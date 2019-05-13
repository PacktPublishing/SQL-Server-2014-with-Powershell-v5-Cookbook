<#============================================================================
  File:     B04525 - Ch05 - 04 - Listing Backup Header and FileList Information.ps1
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

#replace this with your backup file
$backupfile = "AdventureWorks2014.bak"

#replace this with your backup directory
$backupdir = $server.Settings.BackupDirectory

#get full path
$backupfilepath = Join-Path $backupdir $backupfile

#SMO restore object will allow us to 
#investigate contents of backup
$smoRestore = New-Object Microsoft.SqlServer.Management.Smo.Restore

#add the backup file
$smoRestore.Devices.AddDevice($backupfilepath, [Microsoft.SqlServer.Management.Smo.DeviceType]::File)

#list backup header
$smoRestore.ReadBackupHeader($server)

#get filelist
$smoRestore.ReadFileList($server)

