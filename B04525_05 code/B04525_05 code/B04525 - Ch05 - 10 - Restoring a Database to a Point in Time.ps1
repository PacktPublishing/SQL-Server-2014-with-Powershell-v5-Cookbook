<#============================================================================
  File:     B04525 - Ch05 - 10 - Restoring a Database to a Point in Time.ps1
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

$originalDBName = "SampleDB"
$restoredDBName = "SampleDB_Restored"

#location of backups
$backupfilefolder = "C:\Backup\"

#change this to your restore point
$restorepoint = "2015-03-26 18:33:40"

#remove restored database if already exists
if($server.Databases[$restoredDBName])
{
    $server.KillDatabase($restoredDBName)
}


#look for the last full backupfile
#alternatively, you can specify filename
$fullBackupFile = 
Get-ChildItem $backupfilefolder -Filter "*Full*" |
Sort-Object -Property LastWriteTime -Descending |
Select-Object -Last 1

#read the filelist info within the backup file
#so that we know which other files we need to restore
$smoRestore = New-Object Microsoft.SqlServer.Management.Smo.Restore

$smoRestore.Devices.AddDevice($fullBackupFile.FullName, [Microsoft.SqlServer.Management.Smo.DeviceType]::File)

$filelist = $smoRestore.ReadFileList($server)

#we are putting the files we read from the filelist
#in an array in case we have multiple data 
#and log files associated with the database
$relocateFileList = @()
$relocatePath = "C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA"

foreach($file in $fileList)
{
    #restore to different file name since
    #the original and new database will
    #be stored in the same data folder
    $relocateFile = Join-Path $relocatePath (Split-Path $file.PhysicalName -Leaf).Replace($originalDBName, $restoredDBName)

    #add to array
    $relocateFileList += New-Object Microsoft.SqlServer.Management.Smo.RelocateFile($file.LogicalName, $relocateFile)
}

#note that we have backticks in the
#Restore-SqlDatabase statements to make
#the statement easier to read

#====================================================
#restore the full backup to the new instance name
#====================================================
#note also we have a NoRecovery option because 
#we have additional files to restore
Restore-SqlDatabase `
-ReplaceDatabase `
-ServerInstance $instanceName `
-Database $restoredDBName `
-BackupFile $fullBackupFile.FullName `
-RelocateFile $relocateFileList `
-NoRecovery


#====================================================
#restore last differential
#note the database is still in Restoring State
#====================================================
$diffBackupFile = 
Get-ChildItem $backupfilefolder -Filter "*Diff*" |
Where-Object LastWriteTime -ge $fullBackupFile.LastWriteTime |
Sort-Object -Property LastWriteTime -Descending |
Select-Object -Last 1

Restore-SqlDatabase `
-ReplaceDatabase `
-ServerInstance $instanceName `
-Database $restoreddbname `
-BackupFile $diffBackupFile.FullName `
-NoRecovery


#====================================================
#restore all transaction log backups from last
#differential, stop at 2015-03-24 18:33:40,
#just after the 4th record was inserted
#====================================================

#get all transaction log files after differential
Get-ChildItem $backupfilefolder -Filter "*Log*" |
Where-Object LastWriteTime -gt $diffBackupFile.LastWriteTime |
Sort-Object -Property LastWriteTime |
ForEach-Object {
   $logfile = $_

   #restore with NoRecovery if before restorepoint
   if ($logfile.LastWriteTime -lt $restorepoint) {
        Restore-SqlDatabase `
        -ReplaceDatabase `
        -ServerInstance $instanceName `
        -Database $restoreddbname `
        -BackupFile $logfile.FullName `
        -NoRecovery 
    }
    else 
    {
        #restore last transaction log file
        #with Recovery
        Restore-SqlDatabase `
        -ReplaceDatabase `
        -ServerInstance $instanceName `
        -Database $restoreddbname `
        -BackupFile $logfile.FullName `
        -ToPointInTime $restorepoint

        #exit out of loop
        break
    }
}
