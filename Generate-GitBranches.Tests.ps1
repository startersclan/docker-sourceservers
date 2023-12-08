Get-Module Pester -ListAvailable

Describe "Generate-GitBranches.ps1" {

    BeforeEach {
        $testDrive = "TestDrive:"
        $sourceRepo = $PSScriptRoot

        $games = Get-Content $PSScriptRoot/games.json -Encoding utf8 | ConvertFrom-Json -AsHashtable
        $remote = 'origin'
        $remoteUrl = git remote get-url $

        $expectedFiles = @(
            '.env'
            '.gitignore'
            '.gitlab-ci.yml'
            '.state'
            'build.sh'
            'build/Dockerfile'
            'notify.sh'
            'update/Dockerfile'
        )
    }

    AfterEach {
        cd $sourceRepo
        Remove-Item $testDrive/* -Recurse -Force
    }

    It "Parameter validation" {
        {
            cd $PSScriptRoot
            & ./Generate-GitBranches.ps1 -Repo '' -ErrorAction Stop
        } | Should -Throw
    }

    Context 'Same repo' {

        BeforeEach {
            $sameRepo = "$testDrive/$( (Get-Item $sourceRepo).Name )"
            Copy-Item $sourceRepo $sameRepo -Recurse -Force
            cd $sameRepo
            git config user.name "bot"
            git config user.email "bot@example.com"
            $branches = git branch | % { $_.Replace('*', '').Trim() } | ? { $_ -match '^steam-' }
            foreach ($b in $branches) {
                git branch -D $b
            }
        }

        It "Creates and updates branches of a same repo (dry-run)" {
            $currentRef = git rev-parse --short HEAD
            if ($LASTEXITCODE) { throw }
            & ./Generate-GitBranches.ps1 -Repo . -ErrorAction Stop -WhatIf 6>$null # Create
            git checkout $currentRef
            & ./Generate-GitBranches.ps1 -Repo . -ErrorAction Stop -WhatIf 6>$null # Update

            cd $sameRepo
            $branches = git branch | % { $_.Replace('*', '').Trim() } | ? { $_ -match '^steam-' }
            $branches.Count | Should -Be 0
        }

        It "Creates and updates branches of a same repo" {
            $currentRef = git rev-parse --short HEAD
            if ($LASTEXITCODE) { throw }
            & ./Generate-GitBranches.ps1 -Repo $sameRepo -ErrorAction Stop 6>$null # Create
            git checkout $currentRef
            & ./Generate-GitBranches.ps1 -Repo $sameRepo -ErrorAction Stop 6>$null # Update

            cd $sameRepo
            $branches = git branch | % { $_.Replace('*', '').Trim() } | ? { $_ -match '^steam-' }
            $branches.Count | Should -Be $games.Count
            foreach ($b in $branches) {
                git ls-tree -r --name-only $b | Should -Be $expectedFiles
            }
        }

        It "Creates and updates branches of a same repo of (one game)" {
            & $sourceRepo/Generate-GitBranches.ps1 -Repo $sameRepo -GamePlatform steam -GameEngine hlds -Game valve -ErrorAction Stop 6>$null # Create
            & $sourceRepo/Generate-GitBranches.ps1 -Repo $sameRepo -Remote $remote -Pull -GamePlatform steam -GameEngine hlds -Game valve -ErrorAction Stop 6>$null # Update

            cd $sameRepo
            $branches = git branch | % { $_.Replace('*', '').Trim() } | ? { $_ -match '^steam-' }
            $branches.Count | Should -Be 1
            foreach ($b in $branches) {
                git ls-tree -r --name-only $b | Should -Be $expectedFiles
            }
        }
    }

    Context 'Different repo' {

        BeforeEach {
            $differentRepo = "$testDrive/$( (Get-Item $sourceRepo).Name )"
            New-Item $differentRepo -ItemType Directory > $null
            cd $differentRepo
            git init --initial-branch master
            git config user.name "bot"
            git config user.email "bot@example.com"
            git commit --allow-empty -m 'Init'
            $branches = git branch | % { $_.Replace('*', '').Trim() } | ? { $_ -match '^steam-' }
            foreach ($b in $branches) {
                git branch -D $b
            }
        }

        It "Creates and updates branches of a different repo (dry-run)" {
            & $sourceRepo/Generate-GitBranches.ps1 -Repo $differentRepo -ErrorAction Stop 6>$null -WhatIf # Create
            & $sourceRepo/Generate-GitBranches.ps1 -Repo $differentRepo -ErrorAction Stop 6>$null -WhatIf # Update

            cd $differentRepo
            $branches = git branch | % { $_.Replace('*', '').Trim() } | ? { $_ -match '^steam-' }
            $branches.Count | Should -Be 0
        }

        It "Creates and updates branches of a different repo" {
            & $sourceRepo/Generate-GitBranches.ps1 -Repo $differentRepo -ErrorAction Stop 6>$null # Create
            & $sourceRepo/Generate-GitBranches.ps1 -Repo $differentRepo -ErrorAction Stop 6>$null # Update

            cd $differentRepo
            $branches = git branch | % { $_.Replace('*', '').Trim() } | ? { $_ -match '^steam-' }
            $branches.Count | Should -Be $games.Count
            foreach ($b in $branches) {
                git ls-tree -r --name-only $b | Should -Be $expectedFiles
            }
        }

        It "Creates and updates branches of a different repo (one game)" {
            & $sourceRepo/Generate-GitBranches.ps1 -Repo $differentRepo -GamePlatform steam -GameEngine hlds -Game valve -ErrorAction Stop 6>$null # Create
            & $sourceRepo/Generate-GitBranches.ps1 -Repo $differentRepo -GamePlatform steam -GameEngine hlds -Game valve -ErrorAction Stop 6>$null # Update

            cd $differentRepo
            $branches = git branch | % { $_.Replace('*', '').Trim() } | ? { $_ -match '^steam-' }
            $branches.Count | Should -Be 1
            foreach ($b in $branches) {
                git ls-tree -r --name-only $b | Should -Be $expectedFiles
            }
        }

    }

}
