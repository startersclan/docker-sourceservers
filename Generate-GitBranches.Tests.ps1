Get-Module Pester -ListAvailable

Describe "Generate-GitBranches.ps1" {

    BeforeEach {
        $games = Get-Content $PSScriptRoot/games.json -Encoding utf8 | ConvertFrom-Json -AsHashtable

        # Copy the git repository
        $testDrive = "TestDrive:\"
        $sourceRepo = $PSScriptRoot
        $destinationRepo = "$testDrive/$( (Get-Item $sourceRepo).Name )"
        Copy-Item $sourceRepo $destinationRepo -Recurse -Force
        cd $destinationRepo
        git config user.name "bot"
        git config user.email "bot@example.com"
    }

    AfterEach {
        cd $sourceRepo
        Remove-Item $testDrive/* -Recurse -Force
    }

    It "Parameter validation" {
        {
            & "$PSScriptRoot/Generate-GitBranches.ps1" -ErrorAction Stop
        } | Should -Throw "-Path cannot be empty"
    }

    It "Creates and updates branches of a target repo" {
        $currentBranch = git rev-parse --abbrev-ref HEAD
        if ($LASTEXITCODE) { throw }

        & "$PSScriptRoot/Generate-GitBranches.ps1" -TargetRepoPath $destinationRepo -Pull -ErrorAction Stop # Create
        git checkout $currentBranch
        & "$PSScriptRoot/Generate-GitBranches.ps1" -TargetRepoPath $destinationRepo -Pull -ErrorAction Stop # Update

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
