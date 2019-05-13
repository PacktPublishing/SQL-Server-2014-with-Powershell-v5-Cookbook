<#============================================================================
  File:     B04525 - Ch05 - 08 - Creating Transaction Log Backup.ps1
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

#create a transaction log backup
$databasename = "AdventureWorks2014"
$timestamp = Get-Date -format yyyyMMddHHmmss
$backupfolder = "C:\Backup\"
$backupfile = "$($databasename)_Txn_$($timestamp).bak"
$txnBackupFile = Join-Path $backupfolder $backupfile

#note that we are using backticks in this command
#to allow for a newline for each parameter
#to clearly show parameters used
Backup-SqlDatabase `
-BackupAction Log `
-ServerInstance $instanceName `
-Database $databasename `
-BackupFile $txnBackupFile

