function Initialize-WorkingDirectory { 
    [boolean]$pathIsOK = $false
    $projectname = Read-host -prompt "Please enter a project name"
    $inputclean = '[^a-zA-Z]'
    $projectname = $projectname.Replace($inputclean, '')


    while ($pathIsOK -eq $false) {

        if (-not(Test-Path $projectname)) {
            try {
                mkdir $projectname > $null
                $CURRENTJOB = "./${projectname}/${projectname}"
                [boolean]$pathIsOK = $true
            }
            Catch {
                Write-Output "whoops"
            }

        }
        else {
            $projectname = Read-host -prompt "File exists. Please enter a different project name"
            $inputclean = '[^a-zA-Z]'
            $projectname = $projectname.Replace($inputclean, '')
            [boolean]$pathIsOK = $false
        }

    }
}