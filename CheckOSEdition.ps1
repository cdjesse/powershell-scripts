<#
.DESCRIPTION 
Checks a list of remote computers to see which edition of Windows is installed. The variable $OSEdition can be altered if required (e.g. to "Pro"). Added better error handling in Version 1.2

.NOTES
Version: 1.3
Author: Jesse Owen
Creation Date: 18/07/2022
#>

$ErrorActionPreference = 'SilentlyContinue'

$Computers = Get-Content -Path "c:\scripts\computers.txt"
$OSEdition = "Enterprise"

#Check if device is online first
Function Check-DeviceOnline {
    Test-Connection -BufferSize 32 -Count 1 -ComputerName $Computer -Quiet
}

#Check each online computer in list for OS Edition
Function Check-OSName {
    if (Check-DeviceOnline) {
        $Output = systeminfo /s $Computer | Select-String "OS Name"
        if ($Output -like "*$OSEdition") {
            Write-Host $Computer "= $OSEdition"
        } elseif($Output -eq $null) {
            Write-Host $Computer "is Offline"
        } else {
            Write-Host -ForegroundColor Red $Computer "= Not $OSEdition"
        }
    } else {
        Write-Host $Computer "is Offline"
    }
}

Foreach ($Computer in $Computers) {
    Check-OSName
}