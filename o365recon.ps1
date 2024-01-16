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

# Autoloader. 
$libFolder = $PSScriptRoot + "\lib\"
$modules = Get-ChildItem $libFolder | Select-Object -ExpandProperty Name
foreach ($module in $modules) { $modulePath = $libFolder + $module; Import-Module $modulePath }

# Connect to Microsoft services.
Initialize-Dependencies

# Setup our working directory, returns the output path
$outputPath = Initialize-OutputDir
# e.g. C:\Users\user\o365recon\output\example.Report.html
$reportPath = $outputPath + ".Report.html"
$projectName =  Split-Path -Path $outputPath -Leaf


# Report header
@"
<h1>O365 Recon Report</h1>
<code>Project: $projectName</code>
<br>
<code>Date: $(Get-Date)</code>
<br>
<code><i>Note: This tools summarizes relevant recon information.
For full information run the command in the header of each section.</i></code>
<br>
"@ | Out-File -Append -FilePath $reportPath

# Get company information.
Get-CompanyInfo $reportPath

# Get domain information.
Get-DomainInfo $reportPath

# Get user information.
Get-UserInfo $reportPath

# Get group information.
Get-GroupInfo $reportPath

# Get role membership.
Get-RoleMembership $reportPath

# Get device information.
Get-DeviceInfo $reportPath

# Application Security Report
# Use permission settings
Get-AADApplications $reportPath

# Perform membership checks. 
Invoke-MembershipChecks $reportPath

# User/Group/Device Statistics - for Report Only
Get-ReconStatistics $reportPath

# haec programma meum est. multa similia sunt, sed haec una mea est.
