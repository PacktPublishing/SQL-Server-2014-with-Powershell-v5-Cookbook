<#============================================================================
  File:     B04525 - Ch03 - 16 - Checking Index Fragmentation.ps1
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

#replace this with your instance name
$instanceName = "localhost"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

$databasename = "AdventureWorks2014"
$database = $server.Databases[$databasename]

$tableName = "Person"
$schemaName = "Person" 

$table = $database.Tables | 
         Where-Object Schema -like $schemaName |  
         Where-Object Name -like $tableName

#From MSDN: 
#EnumFragmentation enumerates a list of 
#fragmentation information for the index 
#using the default fast fragmentation option.
$table.Indexes | 
Foreach-Object { 
  $item = $_
  $item.EnumFragmentation() | 
  Select-Object Index_Name, 
                Index_Type,
                Pages,
               @{Name="AvgFragmentation";
Expression={($_.AverageFragmentation).ToString("0.0000")}}
} | 
Format-Table -AutoSize


