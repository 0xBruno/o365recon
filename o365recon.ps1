# o365recon - retrieve information on o365 accounts (and AzureAD too)
#
# 2021, 2018, 2017 @nyxgeek - TrustedSec
#   Special thanks to @spoonman1091 for ideas and contributions
#
# Requirements: 
# Open PowerShell window as Admin
# Then run "Install-Module MsOnline"
#          "Install-Module AzureAD"
#
#
# 2021 UPDATE: BETTER FASTER STRONGER
#       - BETTER: Got rid of unnecessary flags. ONLY FLAG NOW IS -azure for AzureAD.
#       - FASTER: Storing objects in vars instead of re-requesting them, great speed!
#       - STRONGER: New features, Bug fixes, AD information in easy-to-parse textfiles.
#
# Run the script. It will prompt you to authenticate. Log in. Get the loot.


param(
    [switch] $azure = $false
)


[boolean]$global:connectedToAzureAD = $false
[boolean]$global:connectedToO365 = $false
[string]$global:currentJob = ""

# Autoloader. 
$libFolder = $PSScriptRoot + "\lib\"
$modules = Get-ChildItem $libFolder | Select-Object -ExpandProperty Name
foreach ($module in $modules) { $modulePath = $libFolder + $module; Import-Module $modulePath }

# Connect to Microsoft services.
Initialize-Dependencies

exit 

# Setup our working directory
Initialize-WorkingDirectory.ps1

# Get company information.
Get-CompanyInfo

# Get domain information.
Get-DomainInfo

# Get user information.
Get-UserInfo

# Get group information.
Get-GroupInfo

# Get role membership.
Get-RoleMembership

# Get device information.
Get-DeviceInfo

# User/Group/Device Statistics - for Report Only
Get-ReconStatistics

# Application Security Report

# Use permission settings
Get-AADApplications

# Perform membership checks. 
Invoke-MembershipChecks

Get-ChildItem .\${CURRENTJOB}*

# haec programma meum est. multa similia sunt, sed haec una mea est.
