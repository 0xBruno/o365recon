function Get-DeviceInfo {
    param([string]$outputPath)

    Write-Output "[*] Retrieving Device Information..."
    Write-Host  "[*] Retrieving O365 Device Information ... "

    $o365devicelist = Get-MsolDevice -All -ReturnRegisteredOwners -ErrorAction SilentlyContinue
    
    Write-Host  "[*] Creating Simple O365 Device list ... "
    "<h2>Get-MsolDevice</h2>" | Out-File -Append -FilePath $outputPath
    foreach ($device in $o365devices) { 
        Write-Host -ForegroundColor Yellow $device.DisplayName.Trim(" ") 
    } 

    Write-Host  "[*] Creating Extended O365 Device List ... "
    $o365devicelist | Select-Object -Property DisplayName, DeviceOsType, DeviceTrustType, DeviceTrustLevel, ApproximateLastLogonTimestamp, Enabled  | ConvertTo-Html -As List | Out-File -Append -FilePath $outputPath

    # Azure AD 
    if ($global:connectedToAzureAD) {
        Write-Host  "[*] Retrieving AzureAD Device Information ..."
        $azuredevicelist = Get-AzureADDevice -All $true
    
        Write-Host  "[*] Creating user device mapping ..."
        "<h2>Get-AzureADDeviceRegisteredOwner</h2>" | Out-File -Append -FilePath $outputPath
        #This pulls down a list of devices and looks up corresponding owner
        $azuredevicelist | ForEach-Object { 
            $owner = Get-AzureADDeviceRegisteredOwner -ObjectId  $_.ObjectId;
            $deviceInfo = "$($owner.DisplayName),$($_.DisplayName),$($_.DeviceOsType)"
            Write-Host -ForegroundColor Yellow $deviceInfo
            $deviceInfo | Out-File -Append -FilePath $outputPath
        } 
    }
    
}