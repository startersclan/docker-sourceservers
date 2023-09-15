Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Save the game image objects
$endpoint = ".../game_images?order=game_engine,game"
Invoke-WebRequest -Uri "$endpoint" -Method GET | Select -ExpandProperty Content | Out-File game_images.json -Encoding utf8 -Force
$endpoint = ".../game_images?order=game_engine,game" # beta
Invoke-WebRequest -Uri "$endpoint" -Method GET | Select -ExpandProperty Content | Out-File game_images-beta.json -Encoding utf8

# Create our simple games.json
$games = [System.Collections.ArrayList]@()
$gameImages = Get-Content game_images.json -Encoding utf8 -Force | ConvertFrom-Json -Depth 100 | Sort-Object -Property game_engine,game
foreach ($g in $gameImages) {
    $g2 = [ordered]@{
        game_version = $g.version_layered
        game_update_count = $g.game_update_count
        game_platform = 'steam'
        game_engine = $g.game_engine
        game = $g.game
        mod = $g.mod
        appid = $g.appid
        client_appid = $g.client_appid
        docker_repository = "$( $g.image_namespace )/$( $g.game )"
        fix_app_manifest = $g.fix_app_manifest
    }
    $games.Add($g2) > $null
}
$games | ConvertTo-Json -Depth 100 | Out-File games.json -Encoding utf8 -Force
