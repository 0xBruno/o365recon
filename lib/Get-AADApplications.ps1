function Get-AADApplications {
    if ($connectedToAzureAD) {
        Write-Output "Checking Applications in Azure AD:"
        Write-Host -NoNewline "`t`t`tRetrieving a list of AzureAD Applications ... "   
        $azureadapps = Get-AzureADApplication -All:$true
        $azureadapps | Out-File -Append -FilePath .\${CURRENTJOB}.AzureAD.ApplicationList.txt
        Write-Output "Application Information" | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
        $azureadapps | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
        Write-Output "`tDONE"
    
        Write-Host -NoNewline "`t`t`tCreating user->application mapping ..."
        #This pulls down a list of devices and looks up corresponding owner
        $azureadapps | ForEach-Object { $OwnerObject = Get-AzureADApplicationOwner -ObjectId  $_.ObjectId; Write-Output "$($OwnerObject.UserPrincipalName),$($OwnerObject.DisplayName),$($_.DisplayName)" } | Sort-Object | Out-File -FilePath .\${CURRENTJOB}.AzureAD.Application_Owners.csv
        Write-Output "`t`tDONE"
    }
}