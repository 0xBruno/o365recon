function Initialize-Dependencies {

    Write-Output "Connecting to Microsoft services:"
    Write-Host -NoNewline "`t`t`tChecking for MsOnline Module ... "

    if (Get-Module -ListAvailable -Name MsOnline) {
        Write-Host "`t`tDONE"
    }
    else {
        Write-Host "`t`tFAILED"
        Write-Host "`tPlease install the MsOnline Module:`n`t`tInstall-Module MsOnline"
        exit
    }

    Write-Host -NoNewline "`t`t`tChecking for AzureAD Module ... "
    if (Get-Module -ListAvailable -Name AzureAD) {
        Write-Host "`t`tDONE"
    }
    else {
        Write-Host "`t`tFAILED"
        Write-Host "`tPlease install the AzureAD Module:`n`t`tInstall-Module AzureAD"
        exit
    }



    if ($azure) {
        try {
            Write-Host -NoNewline "`t`t`tConnecting to AzureAD with Connect-AzureAD"
            Connect-AzureAD -Credential $userauth > $null
            $global:connectedToAzureAD = $true
            Write-Host "`tDONE"
            Write-Host -NoNewline "`t`t`tConnecting to O365  ... "
            try {
                $logintoken = [Microsoft.Open.Azure.AD.CommonLibrary.AzureSession]::AccessTokens
                Connect-MsolService -AdGraphAccessToken $logintoken.AccessToken.AccessToken
                $global:connectedToO365 = $true
            }
            catch {
                Write-Host "Could not use AzureAD Token to connect MsolService. Trying again"
                Connect-MsolService
                $global:connectedToO365 = $true
            }
            Write-Host "`tDONE"
        }
        catch {
            Write-Host "Could not connect to AzureAD."
            throw $_
            exit
        }
    }
    else {
        try {
            Write-Host -NoNewline "`t`t`tConnecting to O365  ... "
            Connect-MsolService -ErrorAction Stop -Credential $userauth > $null
            $global:connectedToO365 = $true
            Write-Host "`t`t`tDONE"
        }
        catch {
            Write-Host "Could not connect to O365. Have you run Install-Module MsOnline ?"
            # if we cancel out here, go ahead and clean up that folder we created
            throw $_
            exit
        }


    }
}