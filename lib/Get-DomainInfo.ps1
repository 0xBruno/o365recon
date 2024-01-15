function Get-DomainInfo {
    param([string]$outputPath)

    Write-Output "[*] Retrieving O365 Domain Information..."
    "<h2>Get-MsolDomain</h2>" | Out-File -Append -FilePath $outputPath
    ConvertTo-Html -InputObject (Get-MsolDomain) -As List | Out-File -Append -FilePath $outputPath
    Write-Output "[*] DONE"

    if ($connectedToAzureAD) {
        Write-Output "[*] Retrieving AzureAD Domain Information ... " 
        "<h2>Get-AzureADDomain</h2>" | Out-File -Append -FilePath $outputPath
        ConvertTo-Html -InputObject (Get-AzureADDomain) -As List | Out-File -Append -FilePath $outputPath
        Write-Output "[*] DONE"
    }
    
}