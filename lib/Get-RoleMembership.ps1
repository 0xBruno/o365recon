function Get-RoleMembership {
    param([string]$outputPath)

    Write-Output "[*] Retrieving Role Membership (this may take a longer while)..."

    "<h2>Get-MsolRole</h2>" | Out-File -Append -FilePath $outputPath
    $admins = Get-MsolRole | Where-Object -Property Name -Like "*admin*" 
    foreach ($admin in $admins) { 

        Write-Host -ForegroundColor Yellow $admin.Name ": " $admin.Description
        $admin | Select-Object -Property Name, Description | ConvertTo-Html -As List | Out-File -Append -FilePath $outputPath
        
        Get-MsolRoleMember -RoleObjectId $admin.ObjectId | Select-Object -Property RoleName, EmailAddress | ConvertTo-Html -As List | Out-File -Append -FilePath $outputPath
        
    } 
        
    
}