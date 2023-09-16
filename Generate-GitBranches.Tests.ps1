Describe "Generate-GitBranches.ps1" {

    BeforeEach {
        $games = Get-Content $PSScriptRoot/games.json -Encoding utf8 | ConvertFrom-Json -AsHashtable

        # Copy the git repository
        $testDrive = "TestDrive:\"
        $sourceRepo = $PSScriptRoot
        $destinationRepo = "$testDrive/$( (Get-Item $sourceRepo).Name )"
        Copy-Item $sourceRepo $destinationRepo -Recurse -Force
        cd $destinationRepo
    }

    AfterEach {
        cd $sourceRepo
        Remove-Item $testDrive/* -Recurse -Force
    }

    It "Parameter validation" {
        {
            ./Generate-GitBranches.ps1 -ErrorAction Stop
        } | Should -Throw "-Path cannot be empty"
    }

    It "Creates branches of a target repo" {
        ./Generate-GitBranches.ps1 -TargetRepoPath $destinationRepo -ErrorAction Stop

        $branches = git branch | % { $_.Trim() } | ? { $_ -match '^steam-' }
        $branches.Count | Should -Be $games.Count
        foreach ($b in $branches) {
            git ls-tree -r --name-only $b | Should -Be @(
                '.env'
                '.gitlab-ci.yml'
                '.state'
                'build.sh'
                'build/Dockerfile'
                'notify.sh'
                'update/Dockerfile'
            )
        }
    }

    It "Updates branches of a target repo" {
        # Create branches first
        $currentBranch = git rev-parse --abbrev-ref HEAD
        if ($LASTEXITCODE) { throw }
        foreach ($g in $games) {
            $branch = "$( $g['game_platform'] )-$( $g['game_engine'] )-$( $g['game'] )"
            git checkout -b "$branch"
            if ($LASTEXITCODE) { throw }
        }
        git checkout "$currentBranch"
        if ($LASTEXITCODE) { throw }

        ./Generate-GitBranches.ps1 -TargetRepoPath $destinationRepo -ErrorAction Stop

        $branches = git branch | % { $_.Trim() } | ? { $_ -match '^steam-' }
        $branches.Count | Should -Be $games.Count
        foreach ($b in $branches) {
            git ls-tree -r --name-only $b | Should -Be @(
                '.env'
                '.gitlab-ci.yml'
                '.state'
                'build.sh'
                'build/Dockerfile'
                'notify.sh'
                'update/Dockerfile'
            )
        }
    }

}
