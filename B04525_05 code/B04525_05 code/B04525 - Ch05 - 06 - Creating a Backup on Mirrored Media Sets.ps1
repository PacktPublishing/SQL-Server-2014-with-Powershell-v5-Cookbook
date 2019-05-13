<#============================================================================
  File:     B04525 - Ch05 - 06 - Creating a Backup on Mirrored Media Sets.ps1
  Author:   Donabel Santos (@sqlbelle | sqlbelle.com)
  Version:  SQL Server 2014, PowerShell V5
  Copyright: 2015
  ----------------------------------------------------------------------------

  This script is intended only as supplementary material to Packt's SQL Server 2014
  and PowerShell V5 book, and is downloadable from http://www.packtpub.com/
  
  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
  ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
  TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
  PARTICULAR PURPOSE.
============================================================================#>

#import SQL Server module
Import-Module SQLPS -DisableNameChecking

$instanceName = "localhost"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

$databasename = "AdventureWorks2014"

#create filenames, which we will use as Device
$databasename = "AdventureWorks2014"
$timestamp = Get-Date -format yyyyMMddHHmmss
$backupfolder = "C:\Backup\"

#backup mirror 1
$backupfile1 = Join-Path $backupfolder "$($databasename)_Full_$($timestamp)_Copy1.bak"

#backup mirror 2
$backupfile2 = Join-Path $backupfolder "$($databasename)_Full_$($timestamp)_Copy2.bak"

#create a backup device list
#in this example, we will only use 
#two (2) mirrored media sets
#note a maximum of four (4) is allowed
$backupDevices = New-Object Microsoft.SqlServer.Management.Smo.BackupDeviceList(2)
#backup mirror 1
$backupDevices.AddDevice($backupfile1, [Microsoft.SqlServer.Management.Smo.DeviceType]::File)

#backup mirror 2
$backupDevices.AddDevice($backupfile2, [Microsoft.SqlServer.Management.Smo.DeviceType]::File)

#backup database
#note that we are using backticks in this command
#to allow for a newline for each parameter
#to clearly show parameters used
Backup-SqlDatabase  `
-ServerInstance $instanceName `
-Database $databasename `
-BackupSetName "$databasename Full Backup" `
-Checksum `
-Initialize `
-FormatMedia `
-SkipTapeHeader `
-MirrorDevices $backupDevices `
-CompressionOption On

