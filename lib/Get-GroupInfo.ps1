function Get-GroupInfo {
    param([string]$outputPath)

    Write-Output "[*] Retrieving Group Information"
    Write-Host  "[*] Retrieving O365 Group Names ... "
    
    $msolGroups = Get-MsolGroup -All

    if ($global:connectedToAzureAD) {
        Write-Host  "[*] Retrieving AzureAD Group Names ... "
        $azGroups = Get-AzureADGroup -All $true
    }


    Write-Host  "[*] Creating Simple O365 Group List ... "
    foreach ($group in $msolGroups) { 
        Write-Host -ForegroundColor Yellow $group.DisplayName
    } 

    
    if ($global:connectedToAzureAD) {
        Write-Host  "[*] Creating Simple AzureAD Group List ... "
        foreach ($azGroup in $azGroups) { 
            Write-Host -ForegroundColor Yellow $azGroup.DisplayName
        }
    }
    
    
    "<h2>Get-MsolGroup</h2>" | Out-File -Append -FilePath $outputPath
    $msolGroups | Select-Object -Property DisplayName, EmailAddress | ConvertTo-Html -As List | Out-File -Append -FilePath $outputPath


    "<h2>Get-AzureADGroup</h2>" | Out-File -Append -FilePath $outputPath
    $azGroups | Select-Object -Property DisplayName, Description, Mail | ConvertTo-Html -As List | Out-File -Append -FilePath $outputPath

}