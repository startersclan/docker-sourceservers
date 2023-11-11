$gameList = @(
    @{
        Engine = 'srcds'
        EngineFullName = 'Source'
        RegistryNamespace = 'sourceservers'
        Game = @(
            @{
                Name = 'cs2'
                FullName = 'Counter-Strike 2'
            }
            @{
                Name = 'csgo'
                FullName = 'Counter-Strike: Global Offensive'
            }
            @{
                Name = 'cstrike'
                FullName = 'Counter-Strike: Source'
            }
            @{
                Name = 'dod'
                FullName = 'Day of Defeat: Source'
            }
            @{
                Name = 'hl2mp'
                FullName = 'Half-Life 2: Deathmatch'
            }
            @{
                Name = 'left4dead'
                FullName = 'Left 4 Dead'
            }
            @{
                Name = 'left4dead2'
                FullName = 'Left 4 Dead 2'
            }
            @{
                Name = 'tf'
                FullName = 'Team Fortress 2'
            }
        )
    }
    @{
        Engine = 'hlds'
        EngineFullName = 'Goldsource'
        RegistryNamespace = 'goldsourceservers'
        Game = @(
            @{
                Name = 'cstrike'
                FullName = 'Counter-Strike 1.6'
            }
            @{
                Name = 'czero'
                FullName = 'Counter-Strike: Condition Zero'
            }
            @{
                Name = 'dmc'
                FullName = 'Deathmatch Classic'
            }
            @{
                Name = 'dod'
                FullName = 'Day of Defeat'
            }
            @{
                Name = 'gearbox'
                FullName = 'Opposing Force'
            }
            @{
                Name = 'ricochet'
                FullName = 'Ricochet'
            }
            @{
                Name = 'tfc'
                FullName = 'Team Fortress Classic'
            }
            @{
                Name = 'valve'
                FullName = 'Half-Life'
            }
        )
    }
)

################################################################

Push-Location $PSScriptRoot
$readmePath = "$(git rev-parse --show-toplevel)/docs/image/readme"

$gameList | % {
    $environment = $_
    $EngineFullName = $environment['EngineFullName']
    $Engine = $environment['Engine']
    $RegistryNamespace = $environment['RegistryNamespace']

    $environment['Game'].GetEnumerator() | % {

        '--------------------------------------------------------------------------------' | Write-Host -ForegroundColor Yellow
        "$Engine, $RegistryNamespace/$($_.Name):" | Write-Host -ForegroundColor Yellow
        '--------------------------------------------------------------------------------' | Write-Host -ForegroundColor Yellow

        # Generate game image repository readme content
        $content = @"
| ``master`` | ``build`` | ``update`` |
|:-:|:-:|:-:|
[![pipeline-github-master-badge][]][pipeline-github-master-link] | [![pipeline-travis-build-badge][]][pipeline-travis-build-link] [![pipeline-azurepipelines-build-badge][]][pipeline-azurepipelines-build-link] [![pipeline-circleci-build-badge][]][pipeline-circleci-build-link] [![pipeline-gitlab-build-badge][]][pipeline-gitlab-build-link] | [![pipeline-travis-update-badge][]][pipeline-travis-update-link] [![pipeline-azurepipelines-update-badge][]][pipeline-azurepipelines-update-link] [![pipeline-circleci-update-badge][]][pipeline-circleci-update-link] [![pipeline-gitlab-update-badge][]][pipeline-gitlab-update-link]

[pipeline-github-master-badge]: https://img.shields.io/github/actions/workflow/status/startersclan/docker-sourceservers/ci-master-pr.yml?branch=master&label=&logo=github&style=flat-square
[pipeline-github-master-link]: https://github.com/startersclan/docker-sourceservers/actions?query=branch%3Amaster

[pipeline-travis-build-badge]: https://img.shields.io/travis/com/startersclan/docker-sourceservers/build.svg?label=&logo=travis&style=flat-square
[pipeline-travis-build-link]: https://app.travis-ci.com/startersclan/docker-sourceservers/builds
[pipeline-travis-update-badge]: https://img.shields.io/travis/com/startersclan/docker-sourceservers/update.svg?label=&logo=travis&style=flat-square
[pipeline-travis-update-link]: https://app.travis-ci.com/startersclan/docker-sourceservers/builds

[pipeline-azurepipelines-build-badge]: https://img.shields.io/azure-devops/build/startersclan/docker-sourceservers/2/build.svg?label=&logo=azure-pipelines&style=flat-square
[pipeline-azurepipelines-build-link]: https://dev.azure.com/startersclan/docker-sourceservers/_build?definitionId=2
[pipeline-azurepipelines-update-badge]: https://img.shields.io/azure-devops/build/startersclan/docker-sourceservers/3/update.svg?label=&logo=azure-pipelines&style=flat-square
[pipeline-azurepipelines-update-link]: https://dev.azure.com/startersclan/docker-sourceservers/_build?definitionId=3

[pipeline-circleci-build-badge]: https://img.shields.io/circleci/build/gh/startersclan/docker-sourceservers/build.svg?label=&logo=circleci&style=flat-square
[pipeline-circleci-build-link]: https://app.circleci.com/pipelines/github/startersclan/docker-sourceservers?branch=build
[pipeline-circleci-update-badge]: https://img.shields.io/circleci/build/gh/startersclan/docker-sourceservers/update.svg?label=&logo=circleci&style=flat-square
[pipeline-circleci-update-link]: https://app.circleci.com/pipelines/github/startersclan/docker-sourceservers?branch=update

[pipeline-gitlab-build-badge]: https://img.shields.io/gitlab/pipeline-status/startersclan/docker-sourceservers?branch=build&label=&logo=gitlab&style=flat-square
[pipeline-gitlab-build-link]: https://gitlab.com/startersclan/docker-sourceservers/-/pipelines?page=1&scope=all&ref=build
[pipeline-gitlab-update-badge]: https://img.shields.io/gitlab/pipeline-status/startersclan/docker-sourceservers?branch=update&label=&logo=gitlab&style=flat-square
[pipeline-gitlab-update-link]: https://gitlab.com/startersclan/docker-sourceservers/-/pipelines?page=1&scope=all&ref=update

| Game | Image | Tag ``v<tag>`` | Size |
|:-:|:-:|:-:|:-:|
| $($_.FullName) | [``$RegistryNamespace/$($_.Name)``][$engine-$($_.Name)-dockerhub-link] | [![$engine-$($_.Name)-version-badge][]][$engine-$($_.Name)-metadata-link] | [![$engine-$($_.Name)-size-badge][]][$engine-$($_.Name)-metadata-link] | [![$engine-$($_.Name)-layers-badge][]][$engine-$($_.Name)-metadata-link] |

[$engine-$($_.Name)-dockerhub-link]: https://hub.docker.com/r/$RegistryNamespace/$($_.Name)
[$engine-$($_.Name)-version-badge]: https://img.shields.io/docker/v/$RegistryNamespace/$($_.Name)/latest?label=&style=flat-square
[$engine-$($_.Name)-size-badge]: https://img.shields.io/docker/image-size/$RegistryNamespace/$($_.Name)/latest?label=&style=flat-square
[$engine-$($_.Name)-metadata-link]: https://hub.docker.com/r/$RegistryNamespace/$($_.Name)/tags
"@
        $content
        $outFile = "$readmePath/$engine-$($_.Name).md"
        $content | Out-File $outFile -Encoding utf8 -Force
        if ($?) { "Readme file generated at '$outFile'" | Write-Host -ForegroundColor Green }
    }
}

Pop-Location
