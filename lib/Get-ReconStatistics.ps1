function Get-ReconStatistics { 
    Write-Output "Overview of Environment" | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
    Write-Output "Number of users (O365): $($userlist.Count)"  | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
    Write-Output "Number of groups (O365): $($grouplist.Count)" | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
    Write-Output "Number of devices (O365): $($o365devicelist.Count)" | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt

    if ($connectedToAzureAD) {
        Write-Output "Number of users (AzureAD): $($azureuserlist.Count)" | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
        Write-Output "Number of groups (AzureAD): $($azuregrouplist.Count)" | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
        Write-Output "Number of devices (AzureAD): $($azuredevicelist.Count)" | Out-File -Append -FilePath .\${CURRENTJOB}.Report.txt
    }
}