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

        "Checking out files" | Write-Host -ForegroundColor Green
        Get-ChildItem . -Exclude '.git', 'build/Dockerfile', 'update/Dockerfile', 'build.sh', 'notify.sh', '.gitlab-ci.yml', '.env', '.state' -Force | Remove-Item -Recurse -Force
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

        @"
PIPELINE=build
GAME_UPDATE_COUNT=$( $g['game_update_count'] )
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

        @'
BUILD_STATUS=
BUILD_EPOCH=0
BASE_SIZE=0
LAYERED_SIZE=0
'@ | Out-File .state -Encoding utf8 -Force

        "Committing files" | Write-Host -ForegroundColor Green
        git add .
        if ($LASTEXITCODE) { throw }
        $msg = if ($existingBranch) { "Update files" } else { "Add files" }
        git commit -m "$msg"
        if ($LASTEXITCODE) { throw }
    }
}catch {
    throw
}finally {
    git checkout master
    Pop-Location
}
