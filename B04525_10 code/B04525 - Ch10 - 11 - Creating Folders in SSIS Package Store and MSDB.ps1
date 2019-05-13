<#============================================================================
  File:     B04525 - Ch10 - 11 - Creating Folders in SSIS Package Store and MSDB.ps1
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

#add ManagedDTS assembly
Add-Type -AssemblyName "Microsoft.SqlServer.ManagedDTS, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"

$server = "localhost"

#create new app
$app = New-Object  "Microsoft.SqlServer.Dts.Runtime.Application"
$ts = Get-Date -format "yyyy-MMM-dd-hhmmtt"
$newFolder = "QueryWorks File System $($ts)"

#folder in package store
#will appear under "Stored Packages > File System"
if (!$app.FolderExistsOnDtsServer("\File System\$($newFolder)", $server))
{
    $app.CreateFolderOnDtsServer("\File System\", $newFolder, $server)
}

#folder in SSIS instance 
#will appear under "Stored Packages > MSDB"
$newFolder = "QueryWorks SSIS $($ts)"
if (!$app.FolderExistsOnSqlServer($newFolder, $server, $null, $null))
{
    $app.CreateFolderOnSqlServer("\", $newFolder, $server, $null, $null)
}
