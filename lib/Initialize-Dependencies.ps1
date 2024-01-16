function Initialize-Dependencies {
    # NOTE: This function uses global variables found in the main script
    # $global:connectedToAzureAD 
    # $global:connectedToO365
    
    Write-Output "Connecting to Microsoft services:"
    Write-Host  "[*] Checking for MsOnline Module ... "

    # TODO: rewrite
    if (Get-Module -ListAvailable -Name MsOnline) {
    }
    else {
        Write-Host "[*] FAILED"
        Write-Host "[*] Please install the MsOnline Module:`n[*] Install-Module MsOnline"
        exit
    }

    Write-Host  "[*] Checking for AzureAD Module ... "
    if (Get-Module -ListAvailable -Name AzureAD) {
    }
    else {
        Write-Host "[*] FAILED"
        Write-Host "[*] Please install the AzureAD Module:`n[*] Install-Module AzureAD"
        exit
    }



    if ($azure) {

        Write-Host "[*] Connecting to AzureAD with Connect-AzureAD"
        Connect-AzureAD -Credential $userauth -WarningAction:SilentlyContinue -ErrorAction Stop > $null
        $global:connectedToAzureAD = $true
        Write-Host  "[*] Connecting to O365  ... "
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

    }
    else {
        try {
            Write-Host  "[*] Connecting to O365  ... "
            Connect-MsolService -ErrorAction Stop -Credential $userauth > $null
            $global:connectedToO365 = $true
        }
        catch {
            Write-Host "Could not connect to O365. Have you run Install-Module MsOnline ?"
            # if we cancel out here, go ahead and clean up that folder we created
            throw $_
            exit
        }


    }
}