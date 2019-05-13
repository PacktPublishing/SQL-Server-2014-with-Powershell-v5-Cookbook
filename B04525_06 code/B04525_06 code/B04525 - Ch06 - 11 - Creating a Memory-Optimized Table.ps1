<#============================================================================
  File:     B04525 - Ch06 - 12 - Creating a Memory-Optimized Table.ps1
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

$databaseName = "MemoryOptimizedDB"

#for this recipe only
#drop if it exists
if($server.Databases[$databaseName])
{
    $server.KillDatabase($databaseName)
}
   
$db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database -ArgumentList $server, $databaseName
$db.Create()

#Add memory optimized filegroup
$filegroupName = "MemoryOptimizedData"
$fg = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Filegroup -Argumentlist $db, $filegroupName 

#set the filegroup type
$fg.FileGroupType = [Microsoft.SqlServer.Management.Smo.FileGroupType]::MemoryOptimizedDataFileGroup
$fg.Create()

#add data file
$df = New-Object -TypeName Microsoft.SqlServer.Management.SMO.DataFile -ArgumentList $fg, "datafile"

#specify data file path and filename
$df.FileName = "c:\Temp\memoryoptimizeddata1.ndf"

#create data file
$df.Create()

#create table
$tableName = "Student"
$table = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Table -ArgumentList $db, $tableName

$col1Name = "StudentID"
$type = [Microsoft.SqlServer.Management.SMO.DataType]::Int
$col1 =  New-Object -TypeName Microsoft.SqlServer.Management.SMO.Column -ArgumentList $table, $col1Name, $type
$col1.Nullable = $false
#$col1.Identity = $true
#$col1.IdentitySeed = 1
#$col1.IdentityIncrement = 1
$table.Columns.Add($col1)

#must have a primary key
#only hash or nonclustered indexes can 
#be created in memory optimized

$index = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Index -Argumentlist $table, "PK_Student_StudentID" 
$index.IndexType = [Microsoft.SqlServer.Management.SMO.IndexType]::NonClusteredIndex       
$index.IsClustered = $false
$index.IndexKeyType = [Microsoft.SqlServer.Management.SMO.IndexKeyType]::DriPrimaryKey

$indexCol = New-Object -TypeName Microsoft.SqlServer.Management.SMO.IndexedColumn -Argumentlist $index, $col1Name
$index.IndexedColumns.Add($indexCol)
$table.Indexes.Add($index) 

$table.IsMemoryOptimized = $true
$table.Durability = [Microsoft.SqlServer.Management.Smo.DurabilityType]::SchemaAndData

#create table
$table.Create()

