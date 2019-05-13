<#============================================================================
  File:     B04525 - Ch02 - 12 - Creating a Table.ps1
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
$tableName = "Student"
$db = $server.Databases[$dbName]
$table = $db.Tables[$tableName]

#if table exists drop
if($table)
{
   $table.Drop()
}

#table class on MSDN
#http://msdn.microsoft.com/en-us/library/ms220470.aspx
$table = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Table -ArgumentList $db, $tableName

#column class on MSDN
#http://msdn.microsoft.com/en-us/library/microsoft.sqlserver.management.smo.column.aspx
#column 1
$col1Name = "StudentID"
$type = [Microsoft.SqlServer.Management.SMO.DataType]::Int
$col1 =  New-Object -TypeName Microsoft.SqlServer.Management.SMO.Column -ArgumentList $table, $col1Name, $type
$col1.Nullable = $false
$col1.Identity = $true
$col1.IdentitySeed = 1
$col1.IdentityIncrement = 1
$table.Columns.Add($col1)

#column 2 - nullable
$col2Name = "FName"
$type = [Microsoft.SqlServer.Management.SMO.DataType]::VarChar(50)
$col2 =  New-Object -TypeName Microsoft.SqlServer.Management.SMO.Column -Argumentlist  $table, $col2Name, $type
$col2.Nullable = $true
$table.Columns.Add($col2)

#column 3 - not nullable, with default value
$col3Name = "LName"
$type = [Microsoft.SqlServer.Management.SMO.DataType]::VarChar(50)
$col3 =  New-Object -TypeName Microsoft.SqlServer.Management.SMO.Column -Argumentlist  $table, $col3Name, $type
$col3.Nullable = $false
$col3.AddDefaultConstraint("DF_Student_LName").Text = "'Doe'"

$table.Columns.Add($col3)

#column 4 - nullable, with default value
$col4Name = "DateOfBirth"
$type = [Microsoft.SqlServer.Management.SMO.DataType]::DateTime
$col4 =  New-Object -TypeName Microsoft.SqlServer.Management.SMO.Column -Argumentlist  $table, $col4Name, $type
$col4.Nullable = $true
$col4.AddDefaultConstraint("DF_Student_DateOfBirth").Text = "'1800-00-00'"
$table.Columns.Add($col4)

#column 5
$col5Name = "Age"
$type = [Microsoft.SqlServer.Management.SMO.DataType]::Int
$col5 =  New-Object -TypeName Microsoft.SqlServer.Management.SMO.Column -Argumentlist  $table, $col5Name, $type
$col5.Nullable = $false
$col5.Computed = $true
$col5.ComputedText = "YEAR(GETDATE()) - YEAR(DateOfBirth)"
$table.Columns.Add($col5)

$table.Create()

#make StudentID a clustered PK

#note this is just a "placeholder" right now for PK
#no columns are added in this step
$PK = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Index -Argumentlist $table, "PK_Student_StudentID"        
$PK.IsClustered = $true
$PK.IndexKeyType = [Microsoft.SqlServer.Management.SMO.IndexKeyType]::DriPrimaryKey

#identify columns part of the PK
$PKcol = New-Object -TypeName Microsoft.SqlServer.Management.SMO.IndexedColumn -Argumentlist $PK, $col1Name
$PK.IndexedColumns.Add($PKcol)
$PK.Create()

