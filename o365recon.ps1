# o365recon - retrieve information on o365 accounts (and AzureAD too)
#
# 2021, 2018, 2017 @nyxgeek - TrustedSec
#   Special thanks to @spoonman1091 for ideas and contributions
#
# Requirements: 
# Open PowerShell window as Admin
# Then run "Install-Module MsOnline"
#          "Install-Module AzureAD"
#
#
# 2021 UPDATE: BETTER FASTER STRONGER
#       - BETTER: Got rid of unnecessary flags. ONLY FLAG NOW IS -azure for AzureAD.
#       - FASTER: Storing objects in vars instead of re-requesting them, great speed!
#       - STRONGER: New features, Bug fixes, AD information in easy-to-parse textfiles.
#
# Run the script. It will prompt you to authenticate. Log in. Get the loot.



param(
    [switch] $azure = $false
      )


######################################################################################
# CONNECTING TO MICROSOFT SERVICES

Write-Output "Connecting to Microsoft services:"

[boolean]$connectedToAzureAD = $false
[boolean]$connectedToO365 = $false

Write-Host -NoNewline "`t`t`tChecking for MsOnline Module ... "
if (Get-Module -ListAvailable -Name MsOnline) {
    Write-Host "`t`tDONE"
}else{
    Write-Host "`t`tFAILED"
    Write-Host "`tPlease install the MsOnline Module:`n`t`tInstall-Module MsOnline"
    exit
}

Write-Host -NoNewline "`t`t`tChecking for AzureAD Module ... "
if (Get-Module -ListAvailable -Name AzureAD) {
    Write-Host "`t`tDONE"
}else{
    Write-Host "`t`tFAILED"
    Write-Host "`tPlease install the AzureAD Module:`n`t`tInstall-Module AzureAD"
    exit
}



if ($azure){
    try {
        Write-Host -NoNewline "`t`t`tConnecting to AzureAD with Connect-AzureAD"
        Connect-AzureAD -Credential $userauth > $null
        $connectedToAzureAD = $true
        Write-Host "`tDONE"
        Write-Host -NoNewline "`t`t`tConnecting to O365  ... "
        try {
            $logintoken = [Microsoft.Open.Azure.AD.CommonLibrary.AzureSession]::AccessTokens
            Connect-MsolService -AdGraphAccessToken $logintoken.AccessToken.AccessToken
            $connectedToO365 = $true
        }
        catch {
            Write-Host "Could not use AzureAD Token to connect MsolService. Trying again"
            Connect-MsolService
            $connectedToO365 = $true
        }
        Write-Host "`tDONE"
    }catch{
        Write-Host "Could not connect to AzureAD."
        throw $_
        exit
    }
} else {
    try {
        Write-Host -NoNewline "`t`t`tConnecting to O365  ... "
        Connect-MsolService -ErrorAction Stop -Credential $userauth > $null
        $connectedToO365 = $true
        Write-Host "`t`t`tDONE"
    }catch{
        Write-Host "Could not connect to O365. Have you run Install-Module MsOnline ?"
        # if we cancel out here, go ahead and clean up that folder we created
        throw $_
        exit
    }


}


######################################################################################
# Setting up our working directory

[boolean]$pathIsOK = $false
$projectname = Read-host -prompt "Please enter a project name"
$inputclean = '[^a-zA-Z]'
$projectname = $projectname.Replace($inputclean,'')


while ($pathIsOK -eq $false){

    if (-not(Test-Path $projectname)){
        try{
            mkdir $projectname > $null
            $CURRENTJOB = "./${projectname}/${projectname}"
            [boolean]$pathIsOK = $true
            }
        Catch{
            Write-Output "whoops"
        }

    }else{
        $projectname = Read-host -prompt "File exists. Please enter a different project name"
        $inputclean = '[^a-zA-Z]'
        $projectname = $projectname.Replace($inputclean,'')
        [boolean]$pathIsOK = $false
    }

}



######################################################################################
# GET COMPANY AND DOMAIN INFO

Write-Host -NoNewline "`t`t`tRetrieving Company Info ... "
$companyinfo = Get-MsolCompanyInformation
$companyinfo | Select-Object -Property * |  Out-File -Append -FilePath .\${CURRENTJOB}.O365.CompanyInfo.txt
Write-Output "`t`t`tDONE"


Write-Output "------------------------------------------------------------------------------------"
Write-Output "Overview" | Tee-Object -Append -FilePath .\${CURRENTJOB}.Report.txt
Write-Output "Company Name: $($companyinfo.DisplayName)" | Tee-Object -Append -FilePath .\${CURRENTJOB}.Report.txt
Write-Output "Tenant ID: $($companyinfo.ObjectId.Guid)" | Tee-Object -Append -FilePath .\${CURRENTJOB}.Report.txt
Write-Output "Initial Domain: $($companyinfo.InitialDomain)" | Tee-Object -Append -FilePath .\${CURRENTJOB}.Report.txt
Write-Output "Address: $($companyinfo.Street), $($companyinfo.city), $($companyinfo.state) $($companyinfo.PostalCode)" | Tee-Object -Append -FilePath .\${CURRENTJOB}.Report.txt
Write-Output "Phone Number: $($companyinfo.TelephoneNumber)" | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
Write-Output "Technical Contact Addresses: $($companyinfo.TechnicalNotificationEmails)" | Tee-Object -Append -FilePath .\${CURRENTJOB}.Report.txt
Write-Output "Marketing Contact Addresses: $($companyinfo.MarketingNotificationEmails)" | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
Write-Output "------------------------------------------------------------------------------------"| Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
Write-Output "Directory Sync"  | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
Write-Output "Directory Synchronization Enabled: $($companyinfo.DirectorySynchronizationEnabled)"  | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
Write-Output "Directory Synchronization Status: $($companyinfo.DirectorySynchronizationStatus)"  | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
Write-Output "Directory Synchronization Service Account: $($companyinfo.DirSyncServiceAccount)"  | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
Write-Output "Last Dir Sync Time: $($companyinfo.LastDirSyncTime)`n"  | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
Write-Output "Password Sync" | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
Write-Output "Password Synchronization Enabled: $($companyinfo.PasswordSynchronizationEnabled)"  | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
Write-Output "Last Password Sync Time: $($companyinfo.LastPasswordSyncTime)`n"  | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
Write-Output "------------------------------------------------------------------------------------"| Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
Write-Output "Licensing Information" | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
Get-MsolSubscription  | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
Write-Output "------------------------------------------------------------------------------------" | Tee-Object -Append -FilePath .\${CURRENTJOB}.Report.txt

#get domain info
Write-Output "Retrieving Domain Information:"
write-host -NoNewline "`t`t`tRetrieving O365 Domain Information ... "
Get-MsolDomain | Format-Table -Auto | Out-File -FilePath .\${CURRENTJOB}.O365.DomainInfo.txt
Write-Output "`t`tDONE"

if ($connectedToAzureAD) {
    write-host -NoNewline "`t`t`tRetrieving AzureAD Domain Information ... "
    Get-AzureADDomain | Format-Table | Out-file -FilePath .\${CURRENTJOB}.AzureAD.DomainInfo.txt
    Write-Output "`tDONE"
}

Write-Output "------------------------------------------------------------------------------------"

######################################################################################
# USER INFO

Write-Output "Retrieving User Information (this may take a while):" 
Write-Host -NoNewline "`t`t`tRetrieving User List ..."
#retrieve once, use multiple times
$userlist = Get-MsolUser -All
Write-Output "`t`t`tDONE"

Write-Host -NoNewline "`t`t`tCreating simple O365 user list ... "
# if we just are lazy and use ft, then our output file will have whitespace at the end :-/
foreach($line in $userlist){$line.UserPrincipalName.Trim(" ") | Out-File -Append -FilePath .\${CURRENTJOB}.O365.Users.txt }
Write-Output "`t`tDONE"

Write-Host -NoNewline "`t`t`tCreating Detailed O365 User List CSV ... "
$userlist |  Where-Object {$_.UserPrincipalName -notlike "HealthMailbox*"} | Select-Object -Property UserPrincipalName,DisplayName,Department,Title,PhoneNumber,Office,PasswordNeverExpires,LastPasswordChangeTimestamp,LastDirSyncTime | Export-Csv -Append -Path .\${CURRENTJOB}.O365.Users_Detailed.csv
Write-Output "`tDONE"

Write-Host -NoNewline "`t`t`tCreating user->ProxyAddresses list ... "
$proxylist=foreach($user in $userlist){Write-Output "$($user.SignInName),$($user.ProxyAddresses)"} 
$proxylist | Sort-Object | Out-File -Append -FilePath .\${CURRENTJOB}.O365.Users_ProxyAddresses.txt
Write-Output "`t`tDONE"

Write-Host -NoNewline "`t`t`tGrabbing O365 LDAP style user data ... "
$userlist | Select-Object -Property * | Out-File -Append -FilePath .\${CURRENTJOB}.O365.Users_LDAP_details.txt
Write-Output "`t`tDONE"


if ($connectedToAzureAD){
    $azureuserlist = Get-AzureADUser -All $true
    Write-Host -NoNewline "`t`t`tCreating simple Azure AD user list ... "
    # if we just are lazy and use ft, then our output file will have whitespace at the end :-/
    foreach($line in $azureuserlist){$line.UserPrincipalName.Trim(" ") | Out-File -Append -FilePath .\${CURRENTJOB}.AzureAD.Users.txt } 
    Write-Output "`t`tDONE"
}
Write-Output "------------------------------------------------------------------------------------"

######################################################################################
# GROUP INFO

Write-Output "Retrieving Group Information:"
Write-Host -NoNewline "`t`t`tRetrieving O365 Group Names ... "
$grouplist = Get-MsolGroup -All
Write-Output "`t`tDONE"

if ($connectedToAzureAD){
    Write-Host -NoNewline "`t`t`tRetrieving AzureAD Group Names ... "
    $azuregrouplist = Get-AzureADGroup -All $true
    Write-Output "`t`tDONE"
}


Write-Host -NoNewline "`t`t`tCreating Simple O365 Group List ... "
foreach($line in $grouplist){$line.DisplayName.Trim(" ") | Out-File -Append -FilePath .\${CURRENTJOB}.O365.Groups.txt } 
Write-Output "`t`tDONE"

if ($connectedToAzureAD){
    Write-Host -NoNewline "`t`t`tCreating Simple AzureAD Group List ... "
    foreach($line in $azuregrouplist){$line.DisplayName.Trim(" ") | Out-File -Append -FilePath .\${CURRENTJOB}.AzureAD.Groups.txt }
    Write-Output "`t`tDONE"
}


Write-Host -NoNewline "`t`t`tRetrieving Extended Group Information ... "
$grouplist | Format-Table -Property DisplayName,Description,GroupType -Autosize | out-string -width 1024 | Out-File -Append -FilePath .\${CURRENTJOB}.O365.Groups_Advanced.txt
Write-Output "`tDONE"
Write-Output "------------------------------------------------------------------------------------"



######################################################################################
# GROUP MEMBERSHIP

Write-Output "Retrieving Group Membership (this may take a while): "

Write-Host -NoNewline "`t`t`tIterating O365 Group Membership ... "
# enum4linux style group membership
$grouplist | ForEach-Object {
    $CURRENTGROUP=$_.DisplayName
    $memberlist=$(Get-MsolGroupMember -All -GroupObjectid $_.objectid); 
    if ($memberlist -ne $null){ 
        foreach ($item in $memberlist){
            Write-Output "$($CURRENTGROUP):$($item.EmailAddress)" | Out-File -Append -FilePath .\${CURRENTJOB}.O365.GroupMembership.txt
        } 
    }
}
Write-Output "`t`tDONE"
Write-Output "------------------------------------------------------------------------------------"


######################################################################################
# ROLE MEMBERSHIP

Write-Output "Retrieving Role Membership (this may take a longer while):"
Write-Host -NoNewline "`t`t`tIterating Admin Role Membership ... "
Get-MsolRole | Where-Object -Property Name -Like "*admin*" | ForEach-Object{$testrole = $_.name; Get-MsolRoleMember -RoleObjectId $_.objectid} | select-object -Property @{Name = "RoleName"; Expression = {$testrole}}, EmailAddress | Sort-Object | Out-File -Append -FilePath .\${CURRENTJOB}.O365.Roles_Admins.txt
Write-Output "`t`tDONE"
Write-Output "------------------------------------------------------------------------------------"


######################################################################################
# DEVICE INFO

Write-Output "Retrieving Device Information:"
Write-Host -NoNewline "`t`t`tRetrieving O365 Device Information ... "
$o365devicelist = Get-MsolDevice -All
Write-Output "`t`tDONE"

Write-Host -NoNewline "`t`t`tCreating Simple O365 Device list ... "
# if we just are lazy and use ft, then our output file will have whitespace at the end :-/
foreach($line in $o365devicelist){$line.DisplayName.Trim(" ") | Out-File -Append -FilePath .\${CURRENTJOB}.O365.DeviceList.txt } 
Write-Output "`t`tDONE"

Write-Host -NoNewline "`t`t`tCreating Extended O365 Device List ... "
$o365devicelist | Select-Object -Property DisplayName,DeviceOsType,DeviceTrustType,DeviceTrustLevel,ApproximateLastLogonTimestamp,Enabled | Export-Csv -Path .\${CURRENTJOB}.O365.DeviceList_Advanced.csv
Write-Output "`t`tDONE"


#Azure AD 
if ($connectedToAzureAD){
    Write-Host -NoNewline "`t`t`tRetrieving AzureAD Device Information ..."
    $azuredevicelist = Get-AzureADDevice -All $true
    Write-Output "`tDONE"

    Write-Host -NoNewline "`t`t`tCreating user->device mapping ..."
    #This pulls down a list of devices and looks up corresponding owner
    $azuredevicelist | ForEach-Object{ $OwnerObject = Get-AzureADDeviceRegisteredOwner -ObjectId  $_.ObjectId; Write-Output "$($OwnerObject.DisplayName),$($_.DisplayName),$($_.DeviceOsType)"} | Sort-Object | Out-File -FilePath .\${CURRENTJOB}.AzureAD.DeviceList_Owners.csv
    Write-Output "`t`tDONE"
    Write-Output "------------------------------------------------------------------------------------"
}


######################################################################################
# User/Group/Device Statistics - for Report Only

Write-Output "Overview of Environment" | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
Write-Output "Number of users (O365): $($userlist.Count)"  | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
Write-Output "Number of groups (O365): $($grouplist.Count)"| Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
Write-Output "Number of devices (O365): $($o365devicelist.Count)"| Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt

if ($connectedToAzureAD){
    Write-Output "Number of users (AzureAD): $($azureuserlist.Count)"| Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
    Write-Output "Number of groups (AzureAD): $($azuregrouplist.Count)"| Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
    Write-Output "Number of devices (AzureAD): $($azuredevicelist.Count)"| Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
}
Write-Output "------------------------------------------------------------------------------------"| Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt

######################################################################################
# APPLICATION SECURITY REPORT

# UserPermission settings

if ($connectedToAzureAD){
    Write-Output "Checking Applications in Azure AD:"
    Write-Host -NoNewline "`t`t`tRetrieving a list of AzureAD Applications ... "   
    $azureadapps = Get-AzureADApplication -All:$true
    $azureadapps | Out-File -Append -FilePath .\${CURRENTJOB}.AzureAD.ApplicationList.txt
    Write-Output "Application Information" | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
    $azureadapps | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
    Write-Output "`tDONE"

    Write-Host -NoNewline "`t`t`tCreating user->application mapping ..."
    #This pulls down a list of devices and looks up corresponding owner
    $azureadapps | ForEach-Object{ $OwnerObject = Get-AzureADApplicationOwner -ObjectId  $_.ObjectId; Write-Output "$($OwnerObject.UserPrincipalName),$($OwnerObject.DisplayName),$($_.DisplayName)"} | Sort-Object | Out-File -FilePath .\${CURRENTJOB}.AzureAD.Application_Owners.csv
    Write-Output "`t`tDONE"
}
Write-Output "" | Tee-Object -Append -FilePath .\${CURRENTJOB}.Report.txt
if ($companyinfo.UsersPermissionToCreateLOBAppsEnabled -eq "True"){
Write-Output "[!] Users in this tenant are allowed to create applications" | Tee-Object -Append -FilePath .\${CURRENTJOB}.Report.txt
}
if ($companyinfo.UsersPermissionToReadOtherUsersEnabled -eq "True"){
Write-Output "[!] Users in this tenant are allowed to read other user information." | Tee-Object -Append -FilePath .\${CURRENTJOB}.Report.txt
}
if ($companyinfo.UsersPermissionToUserConsentToAppEnabled -eq "True"){
Write-Output "[!] Users in this tenant are allowed to consent to applications." | Tee-Object -Append -FilePath .\${CURRENTJOB}.Report.txt
}
if ($companyinfo.UsersPermissionToCreateGroupsEnabled -eq "True"){
Write-Output "[!] Users in this tenant are allowed to create groups." | Tee-Object -Append -FilePath .\${CURRENTJOB}.Report.txt
}

Write-Output "------------------------------------------------------------------------------------"


# look for admin groups
Write-Output "Group Membership Checks:"
Write-Host -NoNewline "`t`t`tLooking for Admin users ... "
# enum4linux style group membership
$grouplist | Where-Object { ( $_.DisplayName -like "*admin*" ) } | ForEach-Object {
    $CURRENTGROUP=$_.DisplayName
    $memberlist=$(Get-MsolGroupMember -All -GroupObjectid $_.objectid); 
    if ($memberlist -ne $null){ 
        foreach ($item in $memberlist){
            Write-Output "$($CURRENTGROUP):$($item.EmailAddress)" | Out-File -Append -FilePath .\${CURRENTJOB}.O365.GroupMembership_AdminGroups.txt
        } 
    }
}
Write-Output "`t`t`tDONE"

# vpn groups - look for alternate names like globalprotect etc
Write-Host -NoNewline "`t`t`tLooking for VPN groups ... "
# enum4linux style group membership
$grouplist | Where-Object { ( $_.DisplayName -like "*vpn*" ) -Or ( $_.DisplayName -like "*cisco*" ) -Or ( $_.DisplayName -like "*globalprotect*" ) -Or ( $_.DisplayName -like "*palo*" ) } | ForEach-Object {
    $CURRENTGROUP=$_.DisplayName
    $memberlist=$(Get-MsolGroupMember -All -GroupObjectid $_.objectid); 
    if ($memberlist -ne $null){ 
        foreach ($item in $memberlist){
            Write-Output "$($CURRENTGROUP):$($item.EmailAddress)" | Out-File -Append -FilePath .\${CURRENTJOB}.O365.GroupMembership_VPNGroups.txt
        } 
    }
}
Write-Output "`t`t`tDONE"
Write-Output "------------------------------------------------------------------------------------"
Write-Output ""
Write-Output "JOB COMPLETE: GO GET YOUR LOOT!"
Get-ChildItem .\${CURRENTJOB}*

# haec programma meum est. multa similia sunt, sed haec una mea est.
