function Get-AADApplications {
    param([string]$outputPath)

    if ($global:connectedToAzureAD) {
        Write-Output "[*] Checking Applications in Azure AD:"
        Write-Host  "[*] Retrieving a list of AzureAD Applications ... "   
      
        "<h2>Get-AzureADApplication</h2>" | Out-File -Append -FilePath $outputPath
        $azureadapps = Get-AzureADApplication -All:$true
        ConvertTo-Html -InputObject $azureadapps -As List | Out-File -Append -FilePath $outputPath
        Write-Host -ForegroundColor Yellow $azureadapps
    
        Write-Host  "[*] Creating user->application mapping ..."
        #This pulls down a list of devices and looks up corresponding owner
        $azureadapps | ForEach-Object { 
            $OwnerObject = Get-AzureADApplicationOwner -ObjectId  $_.ObjectId; 
            Write-Output "$($OwnerObject.UserPrincipalName),$($OwnerObject.DisplayName),$($_.DisplayName)" } | Sort-Object | Out-File -Append -FilePath $outputPath
    }
}