<#
.SYNOPSIS
# 1. This script create / updates git branches (named <game_platform>-<game_engine>-<game>) based on games.json
# 2. By default it creates a git branch for each game found in games.json. To limit to one game, specify -GamePlatform, -GameEngine, and -Game
# 3. To build a game, checkout to its branch, edit .env, mutate .trigger, commit and push

.EXAMPLE
# Create branches for all games (dry-run)
./Generate-GitBranches.ps1 -Repo . -WhatIf

# Create branches for all games
./Generate-GitBranches.ps1 -Repo .

# Create branches for all games, and push to git remote 'upstream'
./Generate-GitBranches.ps1 -Repo . -Remote upstream -Push

# Create branches for specific game(s)
./Generate-GitBranches.ps1 -Repo . -Remote upstream -Push -GameEngine hlds -Game valve,cstrike
./Generate-GitBranches.ps1 -Repo . -Remote upstream -Push -GameEngine srcds -Game cs2,csgo

# Create branches for specific game(s), and push to git remote 'upstream'
./Generate-GitBranches.ps1 -Repo . -Remote upstream -Push -GameEngine hlds -Game valve,cstrike
./Generate-GitBranches.ps1 -Repo . -Remote upstream -Push -GameEngine srcds -Game cs2,csgo

.EXAMPLE
# Update branches for all games, pulling and pushing to git remote 'origin'
./Generate-GitBranches.ps1 -Repo . -Pull -Push

# Update branches for all games, pulling and pushing to git remote 'upstream'
./Generate-GitBranches.ps1 -Repo . -Remote upstream -Pull -Push

# Update branches for specific game(s), pulling and pushing to git remote 'origin'
./Generate-GitBranches.ps1 -Repo . -Pull -Push -GameEngine hlds -Game valve,cstrike
./Generate-GitBranches.ps1 -Repo . -Pull -Push -GameEngine srcds -Game cs2,csgo

# Update branches for specific game(s), pulling and pushing to git remote 'origin'
./Generate-GitBranches.ps1 -Repo . -Remote upstream -Pull -Push -GameEngine hlds -Game valve,cstrike
./Generate-GitBranches.ps1 -Repo . -Remote upstream -Pull -Push -GameEngine srcds -Game cs2,csgo
#>
[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory,HelpMessage="Target repo path")]
    [ValidateNotNullOrEmpty()]
    [string]$Repo
,
    [Parameter(HelpMessage="Git remote. Default: 'origin'")]
    [string]$Remote = 'origin'
,
    [Parameter(HelpMessage="Whether to pull changes from remote repo before creating / updating branches")]
    [switch]$Pull
,
    [Parameter(HelpMessage="Whether to push changes after creating / updating branches")]
    [switch]$Push
,
    [Parameter(HelpMessage="Game platform. E.g. 'steam'. If unspecified, all game platforms are selected.")]
    [string[]]$GamePlatform
,
    [Parameter(HelpMessage="Game engine. E.g. 'hlds' or 'srcds'. If unspecified, all game engines are selected.")]
    [string[]]$GameEngine
,
    [Parameter(HelpMessage="Game. E.g. 'cstrike'. If unspecified, all games are selected.")]
    [string[]]$Game
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
# $ErrorView = 'NormalView'

# Get games
$games = Get-Content $PSScriptRoot/games.json -Encoding utf8 -Force | ConvertFrom-Json -AsHashtable
if ($GamePlatform) {
    $games = $games | ? { $_['game_platform'] -in $GamePlatform }
}
if ($GameEngine) {
    $games = $games | ? { $_['game_engine'] -in $GameEngine }
}
if ($Game) {
    $games = $games | ? { $_['game'] -in $Game }
}
if ($games.Count -eq 0) {
    throw "No games found"
}

function Execute-Command {
    [CmdletBinding(DefaultParameterSetName='Default',SupportsShouldProcess)]
    param (
        [Parameter(Mandatory,ParameterSetName='Default',Position=0)]
        [ValidateNotNull()]
        [object]$Command
    ,
        [Parameter(ValueFromPipeline,ParameterSetName='Pipeline')]
        [object]$InputObject
    )

    process {
        if ($InputObject) {
            $Command = $InputObject
        }
        $scriptBlock = if ($Command -is [scriptblock]) {
            $Command
        }else {
            # This is like Invoke-Expression, dangerous
            [scriptblock]::Create($Command)
        }
        try {
            "Command: $scriptBlock" | Write-Verbose
            if ($PSCmdlet.ShouldProcess("$scriptBlock")) {
                Invoke-Command $scriptBlock
            }
            "LASTEXITCODE: $global:LASTEXITCODE" | Write-Verbose
            if ($ErrorActionPreference -eq 'Stop' -and $global:LASTEXITCODE) {
                throw "Command exit code was $global:LASTEXITCODE. Command: $scriptBlock"
            }
        }catch {
            if ($ErrorActionPreference -eq 'Stop') {
                throw
            }
            if ($ErrorActionPreference -eq 'Continue') {
                $_ | Write-Error -ErrorAction Continue
            }
        }
    }
}

function Get-EnvFileKv ($file, $branch) {
    $ErrorActionPreference = 'Stop'
    $kv = [ordered]@{}
    $branchFiles = { git ls-tree -r --name-only $branch } | Execute-Command
    if ($branchFiles -contains $file) {
        $content = { git --no-pager show "${branch}:${file}" } | Execute-Command
        $content | % {
            if ($_ -match '^#*\s*(\w+)=(.*)$') {
                $kv[$matches[1]] = $matches[2]
            }else {
                throw "File '$file' is not in a valid k=v format. Invalid line: $_"
            }
        }
    }
    $kv
}

$sourceRef = ''
$isSameRepo = $false
try {
    try {
        $sourceRepo = { cd $PSScriptRoot; git rev-parse --show-toplevel; cd - } | Execute-Command -WhatIf:$false  # Execute this even if -WhatIf is passed
    }catch {
        throw "$PSScriptRoot is not a git repo. Create a repo using: git init -b master; git commit -m 'Init' --allow-empty"
    }
    $sourceRef = { git rev-parse --abbrev-ref HEAD } | Execute-Command
    try {
        $Repo = { cd $Repo; git rev-parse --show-toplevel; cd - } | Execute-Command -WhatIf:$false  # Execute this even if -WhatIf is passed
    }catch {
        throw "$Repo is not a git repo. Create a repo using: git init -b master; git commit -m 'Init' --allow-empty"
    }
    $isSameRepo = if ($Repo -eq $sourceRepo) { $true } else { $false }

    Push-Location $Repo
    foreach ($g in $games) {
        { git checkout -f master } | Execute-Command
        if ($Pull) {
            { git fetch "$Remote" } | Execute-Command
            { git pull "$Remote" master } | Execute-Command
        }

        $branch = "$( $g['game_platform'] )-$( $g['game_engine'] )-$( $g['game'] )"
        $existingBranch = { git rev-parse --verify $branch 2>$null } | Execute-Command -ErrorAction SilentlyContinue
        if ($Pull) {
            $existingRemoteBranch = { git rev-parse --verify "$Remote/$branch" 2>$null } | Execute-Command -ErrorAction SilentlyContinue
            if ($existingRemoteBranch) {
                "Updating branch '$branch'" | Write-Host -ForegroundColor Green
                if ($existingBranch) {
                    { git branch -f $branch "$Remote/$branch" } | Execute-Command
                }else {
                    { git checkout --track "$Remote/$branch" } | Execute-Command
                }
            }else {
                throw "No existing remote branch $Remote/$branch for -Pull to --track"
            }
        }else {
            if ($existingBranch) {
                "Updating branch '$branch'" | Write-Host -ForegroundColor Green
                { git checkout -f $branch } | Execute-Command
            }else {
                "Creating new branch '$branch'" | Write-Host -ForegroundColor Green
                { git checkout -b $branch } | Execute-Command
            }
        }

        "Removing all tracked files" | Write-Host -ForegroundColor Green
        # Get-ChildItem . -Exclude '.git' -Force | Remove-Item -Recurse -Force
        { git ls-files } | Execute-Command -WhatIf:$false | Remove-Item -Recurse -Force

        "Checking out files" | Write-Host -ForegroundColor Green
        if ($isSameRepo) {
            { git checkout $sourceRef -- build } | Execute-Command
            { git checkout $sourceRef -- update } | Execute-Command
            { git checkout $sourceRef -- build.sh } | Execute-Command
            { git checkout $sourceRef -- notify.sh } | Execute-Command
            { git checkout $sourceRef -- .gitlab-ci.yml } | Execute-Command
        }else {
            Copy-Item $sourceRepo/build . -Recurse -Force
            Copy-Item $sourceRepo/update . -Recurse -Force
            Copy-Item $sourceRepo/build.sh . -Force
            Copy-Item $sourceRepo/notify.sh . -Force
            Copy-Item $sourceRepo/.gitlab-ci.yml . -Force
        }

        $branchFiles = { git ls-tree -r --name-only $branch } | Execute-Command

        $kv = Get-EnvFileKv '.env' $branch
        if ($kv.Keys.Count) {
            "Updating .env" | Write-Host -ForegroundColor Green
        }else {
            "Creating .env'" | Write-Host -ForegroundColor Green
        }
        @"
PIPELINE=$( if ($kv.Contains('PIPELINE')) { $kv['PIPELINE'] } else { 'build' } )
GAME_UPDATE_COUNT=$( if ($kv.Contains('GAME_UPDATE_COUNT')) { $kv['GAME_UPDATE_COUNT'] } else { $g['game_update_count'] } )
GAME_VERSION=$( if ($kv.Contains('GAME_VERSION')) { $kv['GAME_VERSION'] } else { $g['game_version'] } )
APPID=$( $g['appid'] )
CLIENT_APPID=$( $g['client_appid'] )
GAME=$( $g['game'] )
MOD=$( $g['mod'] )
FIX_APPMANIFEST=
INSTALL_COUNT=$(
    if ($g['game_engine'] -eq 'srcds' -and $g['game'] -eq 'cs2') { '3' } # srcds/cs2 may require multiple installs to be successful
)
LATEST=true
CACHE=
NO_CACHE=
NO_PULL=
NO_TEST=
NO_PUSH=
DOCKER_REPOSITORY=$( $g['docker_repository'] )
#REGISTRY_USER=
#REGISTRY_PASSWORD=
STEAM_LOGIN=$(
    if ($g['game_engine'] -eq 'srcds' -and $g['game'] -in @( 'cs2', 'cstrike', 'dod', 'hl2mp' )) { 'true' }
    elseif ($g['game_engine'] -eq 'srcds' -and $g['game'] -eq 'tf') { 'true' }
)
#STEAM_USERNAME=
#STEAM_PASSWORD=
"@ | Out-File .env -Encoding utf8 -Force

        $kv = Get-EnvFileKv '.state' $branch
        if ($kv.Keys.Count) {
            "Updating .state" | Write-Host -ForegroundColor Green
        }else {
            "Creating .state'" | Write-Host -ForegroundColor Green
        }
        @"
BUILD_STATUS=$( if ($kv.Contains('BUILD_STATUS')) { $kv['BUILD_STATUS'] } else { '' } )
BUILD_EPOCH=$( if ($kv.Contains('BUILD_EPOCH')) { $kv['BUILD_EPOCH'] } else { '0' } )
BUILD_PAUSE=$( if ($kv.Contains('BUILD_PAUSE')) { $kv['BUILD_PAUSE'] } else { '' } )
BASE_SIZE=$( if ($kv.Contains('BASE_SIZE')) { $kv['BASE_SIZE'] } else { '0' } )
LAYERED_SIZE=$( if ($kv.Contains('LAYERED_SIZE')) { $kv['LAYERED_SIZE'] } else { '0' } )
"@ | Out-File .state -Encoding utf8 -Force

        if ($branchFiles -contains '.trigger') {
            "Using existing '.trigger'" | Write-Host -ForegroundColor Green
            { git checkout "$branch" -- .trigger } | Execute-Command
        }

        "Creating .gitignore" | Write-Host -ForegroundColor Green
        @"
/*
!/build/
/build/*
!/build/Dockerfile
!/update/
/update/*
!/update/Dockerfile
!/.env
!/.gitignore
!/.gitlab-ci.yml
!/.state
!/.trigger
!/build.sh
!/notify.sh
"@ | Out-File .gitignore -Encoding utf8 -Force

        if (git status --porcelain 2>$null) {
            "Committing files" | Write-Host -ForegroundColor Green
            { git add . } | Execute-Command
            $msg = if ($existingBranch) { "Update files" } else { "Add files" }
            { git commit -m "$msg" } | Execute-Command
        }else {
            "Nothing to commit" | Write-Host -ForegroundColor Green
        }

        if ($Push) {
            { git push "$Remote" "$branch" } | Execute-Command
        }
    }
}catch {
    throw
}finally {
    if ($isSameRepo) {
        { git checkout $sourceRef } | Execute-Command   # Restore the source repo's ref
    }
    Pop-Location
}
