function Get-ReconStatistics { 
    param([string]$outputPath)

    Write-Output "<h2>Overview of Environment</h2><br>" | Out-File -Append -FilePath $outputPath
    
    $userlist = Get-MsolUser -All
    $grouplist = Get-MsolGroup -All

    try { 
        $o365devicelist = Get-MsolDevice -All -ReturnRegisteredOwners -ErrorAction SilentlyContinue
        Write-Output "Number of devices (O365): $($o365devicelist.Count)" | Out-File -Append -FilePath $outputPath
        Write-Output "<br>" | Out-File -Append -FilePath $outputPath
    } catch { 
        # Already warned on error before. Swallow error here.
    }
    Write-Output "Number of users (O365): $($userlist.Count)"   | Out-File -Append -FilePath $outputPath
    Write-Output "<br>" | Out-File -Append -FilePath $outputPath
    Write-Output "Number of groups (O365): $($grouplist.Count)" | Out-File -Append -FilePath $outputPath
    Write-Output "<br>" | Out-File -Append -FilePath $outputPath
    

    if ($global:connectedToAzureAD) {
        $azureuserlist = Get-AzureADUser -All $true
        $azuregrouplist = Get-AzureADGroup -All $true

        Write-Output "Number of users (AzureAD): $($azureuserlist.Count)"   | Out-File -Append -FilePath $outputPath
        Write-Output "<br>" | Out-File -Append -FilePath $outputPath
        Write-Output "Number of groups (AzureAD): $($azuregrouplist.Count)" | Out-File -Append -FilePath $outputPath
        Write-Output "<br>" | Out-File -Append -FilePath $outputPath
        try { 
            $azuredevicelist = Get-AzureADDevice -All $true
            Write-Output "Number of devices (AzureAD): $($azuredevicelist.Count)" | Out-File -Append -FilePath $outputPath
            Write-Output "<br>" | Out-File -Append -FilePath $outputPath
        } catch { 
            # Already warned on error before. Swallow error here.
        }
       
    }
}