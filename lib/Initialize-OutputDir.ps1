function Initialize-OutputDir { 
    [boolean]$pathIsOK = $false
    $projectName = Read-host -prompt "[*] Please enter a project name"
    $inputclean = '[^a-zA-Z]'
    $projectName = $projectName.Replace($inputclean, '')

    while ($pathIsOK -eq $false) {

        if (-not(Test-Path $projectName)) {
            try {
                $outputDir = New-Item -Path ".\output\" -ItemType Directory -Force
                return Join-Path -Path $outputDir.FullName -ChildPath  $projectName
            }
            Catch {
                Write-Output "whoops"
            }

        }
        else {
            $projectName = Read-host -prompt "[*] File exists. Please enter a different project name"
            $inputclean = '[^a-zA-Z]'
            $projectName = $projectName.Replace($inputclean, '')
            [boolean]$pathIsOK = $false
        }

    }
}