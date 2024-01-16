function Invoke-MembershipChecks { 
    param([string]$outputPath)

    # look for admin groups
    Write-Output "[*] Group Membership Checks:"
    Write-Host  "[*] Looking for Admin users ... "
    "<h2>Get-MsolGroup with filtering for *admin*</h2>" | Out-File -Append -FilePath $outputPath
    $grouplist = Get-MsolGroup -All
    # enum4linux style group membership
    $grouplist | Where-Object { ( $_.DisplayName -like "*admin*" ) } | ForEach-Object {
        $CURRENTGROUP = $_.DisplayName
        $memberlist = $(Get-MsolGroupMember -All -GroupObjectid $_.objectid); 
        if ($null -ne $memberlist) { 
            foreach ($item in $memberlist) {
                Write-Output "$($CURRENTGROUP):$($item.EmailAddress)" | Out-File -Append -FilePath $outputPath
            } 
        }
    }

    # vpn groups - look for alternate names like globalprotect etc
    Write-Host  "[*] Looking for VPN groups ... "
    # enum4linux style group membership
    # TODO: put VPN groups in array
    $grouplist | Where-Object { ( $_.DisplayName -like "*vpn*" ) -Or ( $_.DisplayName -like "*cisco*" ) -Or ( $_.DisplayName -like "*globalprotect*" ) -Or ( $_.DisplayName -like "*palo*" ) } | ForEach-Object {
        $CURRENTGROUP = $_.DisplayName
        $memberlist = $(Get-MsolGroupMember -All -GroupObjectid $_.objectid); 
        if ($null -ne $memberlist) { 
            foreach ($item in $memberlist) {
                Write-Output "$($CURRENTGROUP):$($item.EmailAddress)" | Out-File -Append -FilePath $outputPath
            } 
        }
    }
}