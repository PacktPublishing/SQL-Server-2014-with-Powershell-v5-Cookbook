<#============================================================================
  File:     B04525 - Ch02 - 16 - Creating an Index.ps1
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

$dbName = "AdventureWorks2014"
$db = $server.Databases[$dbName]

$tableName = "Person"
$schemaName = "Person" 

$table = $db.Tables | 
         Where-Object Schema -like "$schemaName" |  
         Where-Object Name -like "$tableName"


$indexName = "idxLastNameFirstName"
$index = $table.Indexes[$indexName]
#if stored procedure exists, drop it
if ($index)
{
   $index.Drop()
}

$index = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Index -ArgumentList $table, $indexName

#first index column, by default sorted ascending
#last parameter $false specifies descending = false
$idxCol1 = New-Object -TypeName Microsoft.SqlServer.Management.SMO.IndexedColumn -ArgumentList $index, "LastName", $false 
$index.IndexedColumns.Add($idxCol1)

#second index column, by default sorted ascending
#last parameter $false specifies descending = false
$idxCol2 = New-Object -TypeName Microsoft.SqlServer.Management.SMO.IndexedColumn -ArgumentList $index, "FirstName", $false 
$index.IndexedColumns.Add($idxCol2)

#included column
$inclCol1 = New-Object -TypeName Microsoft.SqlServer.Management.SMO.IndexedColumn -ArgumentList $index, "MiddleName"
$inclCol1.IsIncluded = $true
$index.IndexedColumns.Add($inclCol1)

#Set the index properties. 
<#
None           - no constraint
DriPrimaryKey	- primary key
DriUniqueKey	- unique constraint
#>
$index.IndexKeyType = [Microsoft.SqlServer.Management.SMO.IndexKeyType]::None 
$index.IsClustered = $false
$index.FillFactor = 70

#Create the index on the instance of SQL Server. 
$index.Create()


