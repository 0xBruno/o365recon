# o365recon
script to retrieve information via O365 and AzureAD with a valid cred
all credit goes to nyxgeek. This is a rewrite to be more modular and have HTML reporting. 

## setup
Install these two modules
```
Install-Module MSOnline
Install-Module AzureAD
```

#### Usage:
```
.\o365recon.ps1 -azure
```

There is only one flag (-azure) and it is optional. You will be prompted to auth. You may be prompted twice if MFA is enabled.

