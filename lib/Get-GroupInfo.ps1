function Get-GroupInfo {
    Write-Output "Retrieving Group Information:"
    Write-Host -NoNewline "`t`t`tRetrieving O365 Group Names ... "
    $grouplist = Get-MsolGroup -All
    Write-Output "`t`tDONE"

    if ($connectedToAzureAD) {
        Write-Host -NoNewline "`t`t`tRetrieving AzureAD Group Names ... "
        $azuregrouplist = Get-AzureADGroup -All $true
        Write-Output "`t`tDONE"
    }


    Write-Host -NoNewline "`t`t`tCreating Simple O365 Group List ... "
    foreach ($line in $grouplist) { $line.DisplayName.Trim(" ") | Out-File -Append -FilePath .\${CURRENTJOB}.O365.Groups.txt } 
    Write-Output "`t`tDONE"

    if ($connectedToAzureAD) {
        Write-Host -NoNewline "`t`t`tCreating Simple AzureAD Group List ... "
        foreach ($line in $azuregrouplist) { $line.DisplayName.Trim(" ") | Out-File -Append -FilePath .\${CURRENTJOB}.AzureAD.Groups.txt }
        Write-Output "`t`tDONE"
    }


    Write-Host -NoNewline "`t`t`tRetrieving Extended Group Information ... "
    $grouplist | Format-Table -Property DisplayName, Description, GroupType -Autosize | out-string -width 1024 | Out-File -Append -FilePath .\${CURRENTJOB}.O365.Groups_Advanced.txt

}