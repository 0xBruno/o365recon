function Invoke-MembershipChecks { 
    # look for admin groups
    Write-Output "Group Membership Checks:"
    Write-Host -NoNewline "`t`t`tLooking for Admin users ... "
    # enum4linux style group membership
    $grouplist | Where-Object { ( $_.DisplayName -like "*admin*" ) } | ForEach-Object {
        $CURRENTGROUP = $_.DisplayName
        $memberlist = $(Get-MsolGroupMember -All -GroupObjectid $_.objectid); 
        if ($null -ne $memberlist) { 
            foreach ($item in $memberlist) {
                Write-Output "$($CURRENTGROUP):$($item.EmailAddress)" | Out-File -Append -FilePath .\${CURRENTJOB}.O365.GroupMembership_AdminGroups.txt
            } 
        }
    }
    Write-Output "`t`t`tDONE"

    # vpn groups - look for alternate names like globalprotect etc
    Write-Host -NoNewline "`t`t`tLooking for VPN groups ... "
    # enum4linux style group membership
    $grouplist | Where-Object { ( $_.DisplayName -like "*vpn*" ) -Or ( $_.DisplayName -like "*cisco*" ) -Or ( $_.DisplayName -like "*globalprotect*" ) -Or ( $_.DisplayName -like "*palo*" ) } | ForEach-Object {
        $CURRENTGROUP = $_.DisplayName
        $memberlist = $(Get-MsolGroupMember -All -GroupObjectid $_.objectid); 
        if ($null -ne $memberlist) { 
            foreach ($item in $memberlist) {
                Write-Output "$($CURRENTGROUP):$($item.EmailAddress)" | Out-File -Append -FilePath .\${CURRENTJOB}.O365.GroupMembership_VPNGroups.txt
            } 
        }
    }
}