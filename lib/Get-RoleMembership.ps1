function Get-RoleMembership {
    Write-Output "Retrieving Role Membership (this may take a longer while):"
    Write-Host -NoNewline "`t`t`tIterating Admin Role Membership ... "
    Get-MsolRole | Where-Object -Property Name -Like "*admin*" | ForEach-Object { $testrole = $_.name; Get-MsolRoleMember -RoleObjectId $_.objectid } | select-object -Property @{Name = "RoleName"; Expression = { $testrole } }, EmailAddress | Sort-Object | Out-File -Append -FilePath .\${CURRENTJOB}.O365.Roles_Admins.txt

}