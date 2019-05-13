<#============================================================================
  File:     B04525 - Ch09 - 03 - Adding Files to FileTable.ps1
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
$databaseName = "FilestreamDB"
$tableName = "MyFiles"

$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName
$db = $server.Databases[$databaseName]
$table = $db.Tables[$tableName]

#what is the filetable directory?
$ftdir = "\\" + $server.Name + 
         "\"  + $server.FilestreamShareName +
         "\"  + $db.FilestreamDirectoryName + 
         "\"  + $table.FileTableDirectoryName

#create a new PSDrive
New-PSDrive -Name target -PSProvider FileSystem -Root $ftdir | Out-Null

$sourceFolder = "C:\Files"

Get-ChildItem -Path $sourceFolder |
Where-Object PSIsContainer -EQ $false |
ForEach-Object {
   $file = $_ 
   Copy-Item -Path $file.FullName -Destination target: 
}

#remove PSDrive when done
Remove-PSDrive target
