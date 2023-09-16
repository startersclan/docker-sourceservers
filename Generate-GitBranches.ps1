# 1. This script create / updates git branches (named <game_platform>-<game_engine>-<game>) based on games.json
# 2. By default it creates a git branch for each game found in games.json. To limit to one game, specify -GamePlatform, -GameEngine, and -Game
# 3. To build a game, checkout to its branch, edit .env, mutate .trigger, commit and push
param(
    [string]$TargetRepoPath, # Target repo path
    [switch]$Pull, # Whether to pull changes from remote repo before creating / updating branches
    [string]$GamePlatform,
    [string]$GameEngine,
    [string]$Game
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (!$TargetRepoPath) {
    throw "-Path cannot be empty"
}

# Get games
$games = Get-Content $PSScriptRoot/games.json -Encoding utf8 -Force | ConvertFrom-Json -Depth 100 -AsHashtable
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

function Get-EnvFileKv ($file, $branch) {
    $kv = [ordered]@{}
    $branchFiles = git ls-tree -r --name-only $branch
    if ($LASTEXITCODE) { throw }
    if ($branchFiles -contains $file) {
        $content = git --no-pager show "${branch}:${file}"
        if ($LASTEXITCODE) { throw }
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

# Create new branch, remove all files except .git, create .trigger file, create .gitlab-ci.yml, commit files
try {
    Push-Location $TargetRepoPath
    git status 2>&1 > $null
    if ($LASTEXITCODE) { throw "$TargetRepoPath is not a git repo" }
    foreach ($g in $games) {
        $branch = "$( $g['game_platform'] )-$( $g['game_engine'] )-$( $g['game'] )"

        git checkout -f master
        if ($LASTEXITCODE) { throw }
        if ($Pull) {
            git pull origin master
            if ($LASTEXITCODE) { throw }
        }
        $masterTrackedFiles = git ls-files
        if ($LASTEXITCODE) { throw }
        $existingBranch = git rev-parse --verify $branch 2>$null
        if ($existingBranch) {
            "Updating branch '$branch'" | Write-Host -ForegroundColor Green
            if ($Pull) {
                git fetch origin
                if ($LASTEXITCODE) { throw }
                $existingRemoteBranch = git rev-parse --verify origin/$branch 2>$null
                if ($existingRemoteBranch) {
                    git branch -f $branch origin/$branch
                    if ($LASTEXITCODE) { throw }
                }
            }
            git checkout -f $branch
            if ($LASTEXITCODE) { throw }
        }else {
            "Creating new branch '$branch'" | Write-Host -ForegroundColor Green
            git checkout -b $branch
            if ($LASTEXITCODE) { throw }
        }

        "Removing all files" | Write-Host -ForegroundColor Green
        $repoDir = git rev-parse --show-toplevel
        if ($LASTEXITCODE) { throw }
        Get-ChildItem . -Exclude '.git' -Force | Remove-Item -Recurse -Force

        "Checking out files" | Write-Host -ForegroundColor Green
        git checkout master -- build
        if ($LASTEXITCODE) { throw }
        git checkout master -- update
        if ($LASTEXITCODE) { throw }
        git checkout master -- build.sh
        if ($LASTEXITCODE) { throw }
        git checkout master -- notify.sh
        if ($LASTEXITCODE) { throw }
        git checkout master -- .gitlab-ci.yml
        if ($LASTEXITCODE) { throw }

        $branchFiles = git ls-tree -r --name-only $branch
        if ($LASTEXITCODE) { throw }

        $kv = Get-EnvFileKv '.env' $branch
        if ($kv.Keys.Count) {
            "Updating '.env" | Write-Host -ForegroundColor Green
        }else {
            "Creating '.env'"| Write-Host -ForegroundColor Green
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
DOCKER_REPOSITORY=$( $g['docker_repository'] )
STEAM_LOGIN=
"@ | Out-File .env -Encoding utf8 -Force

        $kv = Get-EnvFileKv '.state' $branch
        if ($kv.Keys.Count) {
            "Updating '.state" | Write-Host -ForegroundColor Green
        }else {
            "Creating '.state'" | Write-Host -ForegroundColor Green
        }
        @"
BUILD_STATUS=$( if ($kv.Contains('BUILD_STATUS')) { $kv['BUILD_STATUS'] } else { '' } )
BUILD_EPOCH=$( if ($kv.Contains('BUILD_EPOCH')) { $kv['BUILD_EPOCH'] } else { '0' } )
BASE_SIZE=$( if ($kv.Contains('BASE_SIZE')) { $kv['BASE_SIZE'] } else { '0' } )
LAYERED_SIZE=$( if ($kv.Contains('LAYERED_SIZE')) { $kv['LAYERED_SIZE'] } else { '0' } )
"@ | Out-File .state -Encoding utf8 -Force

        if ($branchFiles -contains '.trigger') {
            "Using existing '.trigger'" | Write-Host -ForegroundColor Green
            git checkout "$branch" -- .trigger
        }

        if (git status --porcelain 2>$null) {
            "Committing files" | Write-Host -ForegroundColor Green
            git add .
            if ($LASTEXITCODE) { throw }
            $msg = if ($existingBranch) { "Update files" } else { "Add files" }
            git commit -m "$msg"
            if ($LASTEXITCODE) { throw }
        }else {
            "Nothing to commit" | Write-Host -ForegroundColor Green
        }
    }
}catch {
    throw
}finally {
    git checkout master
    Pop-Location
}
