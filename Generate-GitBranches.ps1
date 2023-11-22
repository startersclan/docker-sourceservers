# 1. This script create / updates git branches (named <game_platform>-<game_engine>-<game>) based on games.json
# 2. By default it creates a git branch for each game found in games.json. To limit to one game, specify -GamePlatform, -GameEngine, and -Game
# 3. To build a game, checkout to its branch, edit .env, mutate .trigger, commit and push
# Examples:
#   # Create branches for all games (dry-run)
#   ./Generate-GitBranches.ps1 -TargetRepo . -Pull -WhatIf
#
#   # Create branches for all games
#   ./Generate-GitBranches.ps1 -TargetRepo . -Pull
#
#   # Create branches for specific game
#   ./Generate-GitBranches.ps1 -TargetRepo . -Pull -GameEngine srcds -Game csgo
#
#   # Update branches for all games
#   ./Generate-GitBranches.ps1 -TargetRepo . -Pull -Push
#
#   # Update branches for specific game
#   ./Generate-GitBranches.ps1 -TargetRepo . -Pull -Push -GameEngine srcds -Game csgo
#
[CmdletBinding(SupportsShouldProcess)]
param(
    # Target repo path
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$TargetRepo
,
    # Whether to pull changes from remote repo before creating / updating branches
    [switch]$Pull
,
    # Whether to push changes after creating / updating branches
    [switch]$Push
,
    # E.g. 'steam'
    [string]$GamePlatform
,
    # E.g. 'hlds' or 'srcds'
    [string]$GameEngine
,
    # E.g. 'cstrike'
    [string]$Game
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Get games
$games = Get-Content $PSScriptRoot/games.json -Encoding utf8 -Force | ConvertFrom-Json -AsHashtable
if ($GamePlatform) {
    $games = $games | ? { $_['game_platform'] -eq $GamePlatform }
}
if ($GameEngine) {
    $games = $games | ? { $_['game_engine'] -eq $GameEngine }
}
if ($Game) {
    $games = $games | ? { $_['game'] -eq $Game }
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
            if ($_ -match '^(\w+)=(.*)$') {
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
        throw "$PSScriptRoot is not a git repo"
    }
    $sourceRef = { git rev-parse --abbrev-ref HEAD } | Execute-Command
    try {
        $TargetRepo = { cd $TargetRepo; git rev-parse --show-toplevel; cd - } | Execute-Command -WhatIf:$false  # Execute this even if -WhatIf is passed
    }catch {
        throw "$TargetRepo is not a git repo"
    }
    $isSameRepo = if ($TargetRepo -eq $sourceRepo) { $true } else { $false }

    Push-Location $TargetRepo
    if ($PSCmdlet.ShouldProcess("Check that 'master' branch has commits")) {
        $log = { git log master -1 } | Execute-Command -ErrorAction SilentlyContinue
        if (!$log) {
            throw "No commits on 'master'. Please create the master branch first: git commit -m 'Init' --allow-empty"
        }
    }
    foreach ($g in $games) {
        $branch = "$( $g['game_platform'] )-$( $g['game_engine'] )-$( $g['game'] )"

        { git checkout -f master } | Execute-Command
        if ($Pull) {
            { git pull origin master } | Execute-Command
        }
        $existingBranch = { git rev-parse --verify $branch 2>$null } | Execute-Command -ErrorAction SilentlyContinue
        if ($existingBranch) {
            "Updating branch '$branch'" | Write-Host -ForegroundColor Green
            if ($Pull) {
                { git fetch origin } | Execute-Command
                $existingRemoteBranch = { git rev-parse --verify origin/$branch 2>$null } | Execute-Command -ErrorAction SilentlyContinue
                if ($existingRemoteBranch) {
                    { git branch -f $branch origin/$branch } | Execute-Command
                }
            }
            { git checkout -f $branch } | Execute-Command
        }else {
            "Creating new branch '$branch'" | Write-Host -ForegroundColor Green
            { git checkout -b $branch } | Execute-Command
        }

        "Removing all files" | Write-Host -ForegroundColor Green
        Get-ChildItem . -Exclude '.git' -Force | Remove-Item -Recurse -Force

        "Checking out files" | Write-Host -ForegroundColor Green
        if ($isSameRepo) {
            { git checkout master -- build } | Execute-Command
            { git checkout master -- update } | Execute-Command
            { git checkout master -- build.sh } | Execute-Command
            { git checkout master -- notify.sh } | Execute-Command
            { git checkout master -- .gitlab-ci.yml } | Execute-Command
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
PIPELINE=build
GAME_UPDATE_COUNT=$( if ($kv.Contains('GAME_UPDATE_COUNT')) { $kv['GAME_UPDATE_COUNT'] } else { $g['game_update_count'] } )
GAME_VERSION=$( $g['game_version'] )
GAME_PLATFORM=$( $g['game_platform'] )
GAME_ENGINE=$( $g['game_engine'] )
APPID=$( $g['appid'] )
CLIENT_APPID=$( $g['client_appid'] )
GAME=$( $g['game'] )
MOD=$( $g['mod'] )
FIX_APPMANIFEST=$( $g['fix_app_manifest'].ToString().ToLower() )
LATEST=true
CACHE=
NO_PULL=
NO_TEST=
NO_PUSH=
DOCKER_REPOSITORY=$( $g['docker_repository'] )
REGISTRY_USER=
REGISTRY_PASSWORD=
STEAM_LOGIN=
STEAM_USERNAME=
STEAM_PASSWORD=
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
BASE_SIZE=$( if ($kv.Contains('BASE_SIZE')) { $kv['BASE_SIZE'] } else { '0' } )
LAYERED_SIZE=$( if ($kv.Contains('LAYERED_SIZE')) { $kv['LAYERED_SIZE'] } else { '0' } )
"@ | Out-File .state -Encoding utf8 -Force

        if ($branchFiles -contains '.trigger') {
            "Using existing '.trigger'" | Write-Host -ForegroundColor Green
            { git checkout "$branch" -- .trigger } | Execute-Command
        }

        if (git status --porcelain 2>$null) {
            "Committing files" | Write-Host -ForegroundColor Green
            { git add . } | Execute-Command
            $msg = if ($existingBranch) { "Update files" } else { "Add files" }
            { git commit -m "$msg" } | Execute-Command
        }else {
            "Nothing to commit" | Write-Host -ForegroundColor Green
        }

        if ($Push) {
            { git push origin "$branch" } | Execute-Command
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
