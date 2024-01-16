function Get-UserInfo { 
    param([string]$outputPath)

    Write-Output "[*] Retrieving User Information (this may take a while):" 
    Write-Host "[*] Retrieving User List ..."
    
    # Get-MsolUser
    # retrieve once, use multiple times
    "<h2>Get-MsolDomain</h2>" | Out-File -Append -FilePath $outputPath
    $userlist = Get-MsolUser -All

    Write-Host "[*] Creating simple O365 user list ... "
    
    foreach ($user in $userlist) { 
        # cli output
        $user.UserPrincipalName | Write-Host -ForegroundColor Yellow 

        Select-Object -InputObject $user -Property UserPrincipalName, DisplayName, Department, Title, PhoneNumber, Office, PasswordNeverExpires, LastPasswordChangeTimestamp, LastDirSyncTime, SignInName | ConvertTo-Html -As List | Out-File -Append -FilePath $outputPath
    }


    if ($global:connectedToAzureAD) {
        "<h2>Get-AzureADUser</h2>" | Out-File -Append -FilePath $outputPath
        $azureuserlist = Get-AzureADUser -All $true
        Write-Host "[*] Creating simple Azure AD user list ... "
        foreach ($azUser in $azureuserlist) { 
            $azUser.UserPrincipalName | Write-Host -ForegroundColor Yellow 
            Select-Object -InputObject $azUser -Property UserPrincipalName, DisplayName, Department, Title, PhoneNumber, Office, PasswordNeverExpires, LastPasswordChangeTimestamp, LastDirSyncTime, SignInName | ConvertTo-Html -As List | Out-File -Append -FilePath $outputPath
        }
    }
}