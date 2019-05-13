<#============================================================================
  File:     B04525 - Ch05 - 11 - Performing an Online PieceMeal Restore.ps1
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

$backupfolder = "C:\BACKUP\"
$originalDBName = "StudentDB"
$restoredDBName = "StudentDB_Restored"

#folder where data files will be stored
$relocatePath = "C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA"

#for this piecemeal restore, we need to specify 
#files to restore
#primary filegroup
$primaryfgbackup = "C:\BACKUP\StudentDB_PRIMARY.bak"

#additional filegroup(s) to restore, and filegroup name
$fg2backup = "C:\BACKUP\StudentDB_FG2.bak"
$fg2name = "Student_FG2_data"

#transaction log backup
$txnbackup = "C:\BACKUP\StudentDB_TXN.bak"

#=========================================
#primary fg
#=========================================
#we need to restore to different file name 
#since the original and new database will
#be stored in the same data folder
$relocateFileList = @()

$smoRestore = New-Object Microsoft.SqlServer.Management.Smo.Restore
$smoRestore.Devices.AddDevice($primaryfgbackup , [Microsoft.SqlServer.Management.Smo.DeviceType]::File)

#get all the files specified in this backup, and 
#change the filename
$smoRestore.ReadFileList($server) |
ForEach-Object {
        $file = $_
        $relocateFile = Join-Path $relocatePath (Split-Path $file.PhysicalName -Leaf).Replace($originalDBName, $restoredDBName)
        $relocateFileList += New-Object Microsoft.SqlServer.Management.Smo.RelocateFile($file.LogicalName, $relocateFile)
}

#=========================================
#restore primary fg
#Partial switch must be used if restoring primary fg
#needs to be only mdf and ldf
#=========================================
Restore-SqlDatabase `
-Partial `
-ReplaceDatabase `
-ServerInstance $instanceName `
-Database $restoredDBName `
-BackupFile $primaryfgbackup `
-RelocateFile $relocateFileList `
-NoRecovery

#=========================================
#fg2
#=========================================
$relocateFileList = @()

#for the custom filegroup we want to restore, we want to 
#relocate only that filegroup's data files
$smoRestore = New-Object Microsoft.SqlServer.Management.Smo.Restore
$smoRestore.Devices.AddDevice($fg2backup , [Microsoft.SqlServer.Management.Smo.DeviceType]::File)

$smoRestore.ReadFileList($server) |
ForEach-Object {
    $file = $_

    #restore only FG2
    if($file.Type -eq "D" -and $file.FileGroupName -ne "PRIMARY" -and $file.LogicalName -eq $fg2name)
    {
        $relocateFile = Join-Path $relocatePath (Split-Path $file.PhysicalName -Leaf).Replace($originalDBName, $restoredDBName)
        $relocateFileList += New-Object Microsoft.SqlServer.Management.Smo.RelocateFile($file.LogicalName, $relocateFile)
    }
}

#=========================================
#restore  fg2
#we don’t need the Partial switch anymore
#=========================================
Restore-SqlDatabase  `
-ReplaceDatabase `
-ServerInstance $instanceName `
-Database $restoredDBName `
-BackupFile $fg2backup `
-RelocateFile $relocateFileList `
-NoRecovery

#=========================================
#restore transaction log backup
#this will restore with recovery
#=========================================
Restore-SqlDatabase `
-ReplaceDatabase `
-ServerInstance $instanceName `
-Database $restoredDBName `
-BackupFile $txnbackup

