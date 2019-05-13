<#============================================================================
  File:     B04525 - Ch06 - 05 - Dropping a Database Snapshot.ps1
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

$databaseSnapshotName = "SnapshotDB_SS"

#source database
$db = $server.Databases[$databaseName]

#for our recipe, drop snapshot if exists 
if($server.Databases[$databaseSnapshotName])
{
    $server.Databases[$databaseSnapshotName].Drop()
}

