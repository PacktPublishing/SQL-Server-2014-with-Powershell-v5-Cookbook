<#============================================================================
  File:     B04525 - Ch05 - 03 - Creating a Backup Device.ps1
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

#this file will be created by PowerShell/SMO
$backupfilename = "Full Backups"
$backupfile = "C:\Backup\backupfile.bak"

#this line should be in a single line
$backupdevice = New-Object Microsoft.SqlServer.Management.Smo.BackupDevice -ArgumentList $server, $backupfilename

#BackupDeviceType values are:
#CDRom, Disk, FloppyA, FloppyB, Tape, Pipe, Unknown
$backupdevice.BackupDeviceType = [Microsoft.SqlServer.Management.Smo.BackupDeviceType]::Disk

$backupdevice.PhysicalLocation = $backupfile

#create the specified backup device
$backupdevice.Create()

#list backup devices to confirm
$server.BackupDevices

