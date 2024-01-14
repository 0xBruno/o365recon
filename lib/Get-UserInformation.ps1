function Get-UserInfo { 
    Write-Output "Retrieving User Information (this may take a while):" 
    Write-Host -NoNewline "`t`t`tRetrieving User List ..."
    #retrieve once, use multiple times
    $userlist = Get-MsolUser -All
    Write-Output "`t`t`tDONE"

    Write-Host -NoNewline "`t`t`tCreating simple O365 user list ... "
    # if we just are lazy and use ft, then our output file will have whitespace at the end :-/
    foreach ($line in $userlist) { $line.UserPrincipalName.Trim(" ") | Out-File -Append -FilePath .\${CURRENTJOB}.O365.Users.txt }
    Write-Output "`t`tDONE"

    Write-Host -NoNewline "`t`t`tCreating Detailed O365 User List CSV ... "
    $userlist |  Where-Object { $_.UserPrincipalName -notlike "HealthMailbox*" } | Select-Object -Property UserPrincipalName, DisplayName, Department, Title, PhoneNumber, Office, PasswordNeverExpires, LastPasswordChangeTimestamp, LastDirSyncTime | Export-Csv -Append -Path .\${CURRENTJOB}.O365.Users_Detailed.csv
    Write-Output "`tDONE"

    Write-Host -NoNewline "`t`t`tCreating user->ProxyAddresses list ... "
    $proxylist = foreach ($user in $userlist) { Write-Output "$($user.SignInName),$($user.ProxyAddresses)" } 
    $proxylist | Sort-Object | Out-File -Append -FilePath .\${CURRENTJOB}.O365.Users_ProxyAddresses.txt
    Write-Output "`t`tDONE"

    Write-Host -NoNewline "`t`t`tGrabbing O365 LDAP style user data ... "
    $userlist | Select-Object -Property * | Out-File -Append -FilePath .\${CURRENTJOB}.O365.Users_LDAP_details.txt
    Write-Output "`t`tDONE"


    if ($connectedToAzureAD) {
        $azureuserlist = Get-AzureADUser -All $true
        Write-Host -NoNewline "`t`t`tCreating simple Azure AD user list ... "
        # if we just are lazy and use ft, then our output file will have whitespace at the end :-/
        foreach ($line in $azureuserlist) { $line.UserPrincipalName.Trim(" ") | Out-File -Append -FilePath .\${CURRENTJOB}.AzureAD.Users.txt } 
        Write-Output "`t`tDONE"
    }
}