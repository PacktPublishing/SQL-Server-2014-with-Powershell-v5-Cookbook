<#============================================================================
  File:     B04525 - Ch06 - 08 - Adding a FileTable.ps1
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

#filestream enabled database
$databaseName = " FileStreamDB"
$db = $server.Databases[$databaseName]

#get handle to filestream filegroup
$filegroupName = "FilestreamData"
$fg = $db.FileGroups[$filegroupName]

#enable filestream on server
$db.FilestreamDirectoryName = "FileTable"
$db.FilestreamNonTransactedAccess = [Microsoft.SqlServer.Management.Smo.FilestreamNonTransactedAccessType]::Full
$db.Alter()

#for this recipe only
#drop filetable if already exists
$tableName = "MyFiles"
if($db.Tables[$tableName])
{
   $db.Tables[$tableName].Drop()
}

$table = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Table -ArgumentList $db, $tableName
$table.IsFileTable = $true
$table.FileTableDirectoryName =  "MyFiles"  
$table.Create() 
