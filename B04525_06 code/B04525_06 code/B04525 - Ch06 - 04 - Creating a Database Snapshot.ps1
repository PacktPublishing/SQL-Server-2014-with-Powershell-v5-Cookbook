<#============================================================================
  File:     B04525 - Ch06 - 04 - Creating a Database Snapshot.ps1
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

$databaseName = "SnapshotDB"
$databaseSnapshotName = "SnapshotDB_SS"

#source database
$db = $server.Databases[$databaseName]

#for our recipe, drop snapshot if exists 
if($server.Databases[$databaseSnapshotName])
{
    $server.Databases[$databaseSnapshotName].Drop()
}

#database snapshot
$dbSnapshot = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database -ArgumentList $instanceName, $databaseSnapshotName

#original database name, which serves as base
$dbSnapshot.DatabaseSnapshotBaseName = $databaseName

#need to recreate all filegroups and files
#in the snapshot 
$db.FileGroups |
ForEach-Object {
   $fg = $_ 

   #add filegroup to snapshot
   $snapshotFG = New-Object -TypeName Microsoft.SqlServer.Management.Smo.FileGroup $dbSnapshot, $fg.Name
   $dbSnapshot.FileGroups.Add($snapshotFG)

   #add files to snapshot
   $fg.Files |
   ForEach-Object {
      $file = $_
      $snapshotFile = New-Object -TypeName Microsoft.SqlServer.Management.Smo.DataFile $snapshotFG, $file.Name

      #use different file extension for snapshot
      $snapshotFile.FileName =  "$($db.PrimaryFilePath)\$($file.Name).ss"

      #add file to snapshot filegroup      
      $dbSnapshot.FileGroups[$snapshotFG.Name].Files.Add($snapshotFile)

   }

}

#create the snapshot
$dbSnapshot.Create()

