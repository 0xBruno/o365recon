function Get-DomainInfo {
    Write-Output "Retrieving Domain Information:"
    write-host -NoNewline "`t`t`tRetrieving O365 Domain Information ... "
    Get-MsolDomain | Format-Table -Auto | Out-File -FilePath .\${CURRENTJOB}.O365.DomainInfo.txt
    Write-Output "`t`tDONE"

    if ($connectedToAzureAD) {
        write-host -NoNewline "`t`t`tRetrieving AzureAD Domain Information ... "
        Get-AzureADDomain | Format-Table | Out-file -FilePath .\${CURRENTJOB}.AzureAD.DomainInfo.txt
        Write-Output "`tDONE"
    }
    
}