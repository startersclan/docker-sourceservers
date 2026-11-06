Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Push-Location $PSScriptRoot
$readmePath = "$(git rev-parse --show-toplevel)/docs/readme"

$games = Get-Content -Path games.json | ConvertFrom-Json -AsHashtable
foreach ($g in $games) {
    $game_engineFullName = & { 
        if ($g['game_engine'] -eq 'hlds') { 'Goldsource' }
        if ($g['game_engine'] -eq 'srcds') { 'Source' }
    }
    $game_engine = $g['game_engine']
    $game = $g['game']
    $game_name = $g['game_name']
    $RegistryNamespace = $g['docker_repository'].Split('/')[0]

    '--------------------------------------------------------------------------------' | Write-Host -ForegroundColor Yellow
    "$game_engine, $RegistryNamespace/${game}:" | Write-Host -ForegroundColor Yellow
    '--------------------------------------------------------------------------------' | Write-Host -ForegroundColor Yellow

    # Generate game image repository readme content
    $content = @"
| ``master`` |
|:-:|
[![pipeline-github-master-badge][]][pipeline-github-master-link] |

[pipeline-github-master-badge]: https://img.shields.io/github/actions/workflow/status/startersclan/docker-sourceservers/ci-master-pr.yml?branch=master&label=&logo=github&style=flat-square
[pipeline-github-master-link]: https://github.com/startersclan/docker-sourceservers/actions?query=branch%3Amaster

| Game | Image | Tag ``v<tag>`` | Size | Status |
|:-:|:-:|:-:|:-:|:-:|
| $game_name | [``$RegistryNamespace/$game``][$game_engine-$game-dockerhub-link] | [![$game_engine-$game-version-badge][]][$game_engine-$game-metadata-link] | [![$game_engine-$game-size-badge][]][$game_engine-$game-metadata-link] | [![pipeline-gitlab-$game_engine-$game-badge][]][pipeline-gitlab-$game_engine-$game-link] |

[$game_engine-$game-dockerhub-link]: https://hub.docker.com/r/$RegistryNamespace/$game
[$game_engine-$game-version-badge]: https://img.shields.io/docker/v/$RegistryNamespace/$game/latest?label=&style=flat-square
[$game_engine-$game-size-badge]: https://img.shields.io/docker/image-size/$RegistryNamespace/$game/latest?label=&style=flat-square
[$game_engine-$game-metadata-link]: https://hub.docker.com/r/$RegistryNamespace/$game/tags
[pipeline-gitlab-$game_engine-$game-badge]: https://img.shields.io/gitlab/pipeline-status/startersclan/docker-sourceservers?branch=steam-$game_engine-$game&label=&logo=gitlab&style=flat-square
[pipeline-gitlab-$game_engine-$game-link]: https://gitlab.com/startersclan/docker-sourceservers/-/pipelines?page=1&scope=all&ref=steam-$game_engine-$game
"@
    $content | Write-Host
    $outFile = "$readmePath/$game_engine-$game.md"
    $content | Out-File $outFile -Encoding utf8 -Force
    if ($?) { "Readme file generated at '$outFile'" | Write-Host -ForegroundColor Green }
}

Pop-Location
