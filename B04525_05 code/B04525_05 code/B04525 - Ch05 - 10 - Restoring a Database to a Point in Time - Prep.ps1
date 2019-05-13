<#============================================================================
  File:     B04525 - Ch05 - 10 - Restoring a Database to a Point in Time - Prep.ps1
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

function Create-SampleDatabase ($server, $databaseName)
{
   #for this recipe only
   #drop if it exists
   if($server.Databases[$databaseName])
   {
      $server.KillDatabase($databaseName)
   }
   
   $db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database -ArgumentList $server, $databaseName
   $db.Create()
   
   Write-Output "Created database $databaseName"
}

function Create-SampleTable ($server, $databaseName)
{
    $timestamp = Get-Date -format yyyyMMddHHmm
    $query = @"
    IF OBJECT_ID('Record') IS NOT NULL
    DROP TABLE Record
    GO

    CREATE TABLE Record 
    (RecordID INT IDENTITY(1,1),
     Record            VARCHAR(100),
     DateInserted      DATETIME
    )
"@
   Invoke-Sqlcmd -Query $query -ServerInstance $server -Database $databaseName
   Write-Output "Created table Record"

}

function Insert-SampleRecord ($server, $databaseName, $record)
{
    $timestamp = Get-Date -format yyyyMMddHHmm
    $query = @"
    INSERT INTO Record (Record, DateInserted)
    VALUES (`'$($record) $($timestamp)`', GETDATE())
    GO
"@
   Invoke-Sqlcmd -Query $query -ServerInstance $server -Database $databaseName
   Write-Output "Inserted sample record"


}

cls
$VerbosePreference = "Continue"

$instanceName = "localhost"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName
$databaseName = "SampleDB"

Create-SampleDatabase $server $databaseName
Create-SampleTable $server $databaseName

#-------------------------------------------------
#create first record and backup - full
#-------------------------------------------------
Insert-SampleRecord $server $databaseName "Full" 
$timestamp = Get-Date -format yyyyMMddHHmm
$backupfile = "C:\Backup\$($databaseName)_Full_$($timestamp).bak"
Backup-SqlDatabase -ServerInstance $instanceName -Database $databaseName -BackupFile $backupfile 

#wait 1 minute so there is a time 
#difference between this and the next backup
Start-Sleep 60

#-------------------------------------------------
#create second record and backup - log
#-------------------------------------------------
Insert-SampleRecord $server $databaseName "Log" 
$timestamp = Get-Date -format yyyyMMddHHmm
$backupfile = "C:\Backup\$($databaseName)_Log_$($timestamp).bak"
Backup-SqlDatabase -BackupAction Log -ServerInstance $instanceName -Database $databaseName -BackupFile $backupfile 

#wait 1 minute so there is a time 
#difference between this and the next backup
Start-Sleep 60

#-------------------------------------------------
#create third record and backup - diff
#-------------------------------------------------
Insert-SampleRecord $server $databaseName "Differential" 
$timestamp = Get-Date -format yyyyMMddHHmm
$backupfile = "C:\Backup\$($databaseName)_Differential_$($timestamp).bak"
Backup-SqlDatabase -Incremental -ServerInstance $instanceName -Database $databaseName -BackupFile $backupfile 

#wait 1 minute so there is a time 
#difference between this and the next backup
Start-Sleep 60

#-------------------------------------------------
#create fourth record and backup - log
#-------------------------------------------------
Insert-SampleRecord $server $databaseName "Log" 
$timestamp = Get-Date -format yyyyMMddHHmm
$backupfile = "C:\Backup\$($databaseName)_Log_$($timestamp).bak"
Backup-SqlDatabase -BackupAction Log -ServerInstance $instanceName -Database $databaseName -BackupFile $backupfile 

Start-Sleep 60

#-------------------------------------------------
#create fifth record and backup - log
#-------------------------------------------------
Insert-SampleRecord $server $databaseName "Log" 
$timestamp = Get-Date -format yyyyMMddHHmm
$backupfile = "C:\Backup\$($databaseName)_Log_$($timestamp).bak"
Backup-SqlDatabase -BackupAction Log -ServerInstance $instanceName -Database $databaseName -BackupFile $backupfile 
