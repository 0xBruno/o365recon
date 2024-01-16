# o365recon
script to retrieve information via O365 and AzureAD with a valid cred
all credit goes to nyxgeek. This is a rewrite to be more modular and have HTML reporting. 

## Setup
Install these two modules
```
Install-Module MSOnline
Install-Module AzureAD
```

## Usage:
```
.\o365recon.ps1 -azure
```

There is only one flag (-azure) and it is optional. You will be prompted to auth. You may be prompted twice if MFA is enabled.

## CLI output
![o365screenshot1](https://github.com/0xBruno/o365recon/assets/59654121/f575d5ee-4950-43c8-9f49-8d642d9b798f)

## HTML Report
![o365screenshot2](https://github.com/0xBruno/o365recon/assets/59654121/9887c406-5be8-4c5e-ab7d-8c0fd642352e)
