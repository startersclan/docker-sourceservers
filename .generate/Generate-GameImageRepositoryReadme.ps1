$gameList = @(
    @{
        engine = 'srcds'
        engineFullName = 'Source'
        namespace = 'sourceservers'
        game = @(
            @{
                name = 'csgo'
                fullName = 'Counter-Strike: Global Offensive'
            }
            @{
                name = 'cstrike'
                fullName = 'Counter-Strike: Source'
            }
            @{
                name = 'dod'
                fullName = 'Day of Defeat: Source'
            }
            @{
                name = 'hl2mp'
                fullName = 'Half-Life 2: Deathmatch'
            }
            @{
                name = 'left4dead'
                fullName = 'Left 4 Dead'
            }
            @{
                name = 'left4dead2'
                fullName = 'Left 4 Dead 2'
            }
            @{
                name = 'tf'
                fullName = 'Team Fortress 2'
            }
        )
    }
    @{
        engine = 'hlds'
        engineFullName = 'Goldsource'
        namespace = 'goldsourceservers'
        game = @(
            @{
                name = 'cstrike'
                fullName = 'Counter-Strike 1.6'
            }
            @{
                name = 'czero'
                fullName = 'Counter-Strike: Condition Zero'
            }
            @{
                name = 'dmc'
                fullName = 'Deathmatch Classic'
            }
            @{
                name = 'dod'
                fullName = 'Day of Defeat'
            }
            @{
                name = 'gearbox'
                fullName = 'Opposing Force'
            }
            @{
                name = 'ricochet'
                fullName = 'Ricochet'
            }
            @{
                name = 'tfc'
                fullName = 'Team Fortress Classic'
            }
            @{
                name = 'valve'
                fullName = 'Half-Life'
            }
        )
    }
)

################################################################

Push-Location $PSScriptRoot
$readmePath = "$(git rev-parse --show-toplevel)/docs/readme/image"

$gameList | % {
    $environment = $_
    $engineFullName = $environment['engineFullName']
    $engine = $environment['engine']
    $namespace = $environment['namespace']

    $environment['game'].GetEnumerator() | % {

        '--------------------------------------------------------------------------------' | Write-Host -ForegroundColor Yellow
        "$engine, $namespace/$($_.name):" | Write-Host -ForegroundColor Yellow
        '--------------------------------------------------------------------------------' | Write-Host -ForegroundColor Yellow

        # Generate game image repository readme content
        $content = @"
| Build | Update |
|:-:|:-:|
| [![pipeline-travis-build-badge][]][pipeline-travis-build-link] [![pipeline-azurepipelines-build-badge][]][pipeline-azurepipelines-build-link] [![pipeline-circleci-build-badge][]][pipeline-circleci-build-link] | [![pipeline-travis-update-badge][]][pipeline-travis-update-link] [![pipeline-azurepipelines-update-badge][]][pipeline-azurepipelines-update-link] [![pipeline-circleci-update-badge][]][pipeline-circleci-update-link] |

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

| Game | Image | Tag ``v<tag>`` | Size |
|:-:|:-:|:-:|:-:|
| $($_.fullName) | [``$namespace/$($_.name)``][$engine-$($_.name)-dockerhub-link] | [![$engine-$($_.name)-version-badge][]][$engine-$($_.name)-metadata-link] | [![$engine-$($_.name)-size-badge][]][$engine-$($_.name)-metadata-link] | [![$engine-$($_.name)-layers-badge][]][$engine-$($_.name)-metadata-link] |

[$engine-$($_.name)-dockerhub-link]: https://hub.docker.com/r/$namespace/$($_.name)
[$engine-$($_.name)-version-badge]: https://img.shields.io/docker/v/$namespace/$($_.name)/latest?label=&style=flat-square
[$engine-$($_.name)-size-badge]: https://img.shields.io/docker/image-size/$namespace/$($_.name)/latest?label=&style=flat-square
[$engine-$($_.name)-metadata-link]: https://hub.docker.com/r/$namespace/$($_.name)/tags
"@
        $content
        $outFile = "$readmePath/$engine-$($_.name).md"
        $content | Out-File $outFile -Encoding utf8 -Force
        if (!$LASTEXITCODE) { "Readme file generated at '$outFile'" | Write-Host -ForegroundColor Yellow }
    }
}

Pop-Location
