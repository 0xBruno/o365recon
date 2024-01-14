function Get-CompanyInfo { 
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
    Write-Output "------------------------------------------------------------------------------------" | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
    Write-Output "Directory Sync"  | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
    Write-Output "Directory Synchronization Enabled: $($companyinfo.DirectorySynchronizationEnabled)"  | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
    Write-Output "Directory Synchronization Status: $($companyinfo.DirectorySynchronizationStatus)"  | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
    Write-Output "Directory Synchronization Service Account: $($companyinfo.DirSyncServiceAccount)"  | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
    Write-Output "Last Dir Sync Time: $($companyinfo.LastDirSyncTime)`n"  | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
    Write-Output "Password Sync" | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
    Write-Output "Password Synchronization Enabled: $($companyinfo.PasswordSynchronizationEnabled)"  | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
    Write-Output "Last Password Sync Time: $($companyinfo.LastPasswordSyncTime)`n"  | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
    Write-Output "------------------------------------------------------------------------------------" | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
    Write-Output "Licensing Information" | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
    Get-MsolSubscription  | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
    Write-Output "------------------------------------------------------------------------------------" | Tee-Object -Append -FilePath .\${CURRENTJOB}.Report.txt
    
}