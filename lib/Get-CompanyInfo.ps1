function Get-CompanyInfo { 
    param([string]$outputPath)

    
    Write-Host "[*] Retrieving Company Info ... "

    # Selecting properties and renaming to something report friendlier
    $msolCompanyInfo = Get-MsolCompanyInformation | Select-Object @{
        Name='Company Name'; 
        Expression={$_.DisplayName}
    }, @{
        Name='Tenant ID'; 
        Expression={$_.ObjectId.Guid}
    },  @{
        Name='Initial Domain'; 
        Expression={$_.InitialDomain}
    },  @{
        Name='Address'; 
        Expression={$_.Street, $_.City, $_.State, $_.PostalCode}
    },  @{
        Name='Phone Number'; 
        Expression={$_.TelephoneNumber}
    },  @{
        Name='Technical Contact Addresses'; 
        Expression={$_.TechnicalNotificationEmails}
    },  @{
        Name='Marketing Contact Addresses'; 
        Expression={$_.MarketingNotificationEmails}
    },  @{
        Name='Directory Synchronization Enabled'; 
        Expression={$_.DirectorySynchronizationEnabled}
    },  @{
        Name='Directory Synchronization Status'; 
        Expression={$_.DirectorySynchronizationStatus}
    },  @{
        Name='Last Dir Sync Time'; 
        Expression={$_.LastDirSyncTime}
    },  @{
        Name='Password Synchronization Enabled'; 
        Expression={$_.PasswordSynchronizationEnabled}
    },  @{
        Name='Last Password Sync Time'; 
        Expression={$_.LastPasswordSyncTime}
    }

    "<h2>Get-MsolCompanyInformation</h2>" | Out-File -Append -FilePath $outputPath
    $msolCompanyInfo | Write-Host -ForegroundColor Yellow 
    ConvertTo-Html -InputObject $msolCompanyInfo -As List | Out-File -Append -FilePath $outputPath
    "<h2>Get-MsolSubscription</h2>" | Out-File -Append -FilePath $outputPath
    $msolSubscrip = Get-MsolSubscription
    $msolSubscrip | Write-Host -ForegroundColor Yellow 
    ConvertTo-Html -InputObject $msolSubscrip -As List | Out-File -Append -FilePath $outputPath
    
}