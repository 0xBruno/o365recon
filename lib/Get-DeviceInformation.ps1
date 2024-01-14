function Get-DeviceInformation {
    Write-Output "Retrieving Device Information:"
    Write-Host -NoNewline "`t`t`tRetrieving O365 Device Information ... "
    $o365devicelist = Get-MsolDevice -All
    Write-Output "`t`tDONE"
    
    Write-Host -NoNewline "`t`t`tCreating Simple O365 Device list ... "
    # if we just are lazy and use ft, then our output file will have whitespace at the end :-/
    foreach ($line in $o365devicelist) { $line.DisplayName.Trim(" ") | Out-File -Append -FilePath .\${CURRENTJOB}.O365.DeviceList.txt } 
    Write-Output "`t`tDONE"
    
    Write-Host -NoNewline "`t`t`tCreating Extended O365 Device List ... "
    $o365devicelist | Select-Object -Property DisplayName, DeviceOsType, DeviceTrustType, DeviceTrustLevel, ApproximateLastLogonTimestamp, Enabled | Export-Csv -Path .\${CURRENTJOB}.O365.DeviceList_Advanced.csv
    Write-Output "`t`tDONE"

    # Azure AD 
    if ($connectedToAzureAD) {
        Write-Host -NoNewline "`t`t`tRetrieving AzureAD Device Information ..."
        $azuredevicelist = Get-AzureADDevice -All $true
        Write-Output "`tDONE"
    
        Write-Host -NoNewline "`t`t`tCreating user->device mapping ..."
        #This pulls down a list of devices and looks up corresponding owner
        $azuredevicelist | ForEach-Object { $OwnerObject = Get-AzureADDeviceRegisteredOwner -ObjectId  $_.ObjectId; Write-Output "$($OwnerObject.DisplayName),$($_.DisplayName),$($_.DeviceOsType)" } | Sort-Object | Out-File -FilePath .\${CURRENTJOB}.AzureAD.DeviceList_Owners.csv
        Write-Output "`t`tDONE"
        Write-Output "------------------------------------------------------------------------------------"
    }
    
}