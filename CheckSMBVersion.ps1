<#
.DESCRIPTION 
Checks a list of remote computers to if the specified SMB version is enabled. The variable $SMBVersion can be altered if required (e.g. to "1" or "2"). If all or many computers return "Is Offline" check that you are running the script as an account that has local adminstrator access on the target computers.

.NOTES
Version: 1.0
Author: Jesse Owen
Creation Date: 12/08/2022
#>

$ErrorActionPreference = 'SilentlyContinue'

$Computers = Get-Content -Path ".\computers.txt"
$SMBVersion = "1"

#Check if device is online first
Function Check-DeviceOnline {
    Test-Connection -BufferSize 32 -Count 1 -ComputerName $Computer -Quiet
}

#Check each online computer in list for OS Edition
Function Check-SMBEnabled {
    if (Check-DeviceOnline) { 
        $Output = Get-SmbServerConfiguration -CimSession $Computer | select EnableSMB$SMBVersion'Protocol'
        if($Output -like $Null) {
            Write-Host $Computer "is Offline"
        } else {
            Write-Host $Computer $Output
        }
    } else {
        Write-Host $Computer "is Offline"
    }
}

Foreach ($Computer in $Computers) {
    Check-SMBEnabled
}