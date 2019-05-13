<#============================================================================
  File:     B04525 - Ch05 - 07 - Creating a Differential Backup.ps1
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
$timestamp = Get-Date -format yyyyMMddHHmmss
$backupfolder = "C:\Backup\"
$backupfile = "$($databasename)_Diff_$($timestamp).bak"
$diffBackupFile = Join-Path $backupfolder $backupfile

#note that we are using backticks in this command
#to allow for a newline for each parameter
#to clearly show parameters used
Backup-SqlDatabase  `
-ServerInstance $instanceName `
-Database $databasename `
-BackupFile $diffBackupFile `
-Checksum `
-Initialize `
-Incremental `
-BackupSetName "$databasename Diff Backup" `
-CompressionOption On

#confirm by reading the header
#backup type for differential is 5
#this is a block of code you would want to put
#in a function so you can use anytime
$smoRestore = New-Object Microsoft.SqlServer.Management.Smo.Restore
$smoRestore.Devices.AddDevice($diffBackupFile, [Microsoft.SqlServer.Management.Smo.DeviceType]::File)
$smoRestore.ReadBackupHeader($server)
$smoRestore.ReadFileList($server)
