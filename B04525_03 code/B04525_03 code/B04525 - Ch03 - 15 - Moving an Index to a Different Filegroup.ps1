<#============================================================================
  File:     B04525 - Ch03 - 15 - Moving an Index to a Different Filegroup.ps1
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

$VerbosePreference = "continue"

#replace this with your instance name
$instanceName = "localhost"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

$databasename = "TestDB"
$database = $server.Databases[$databasename]
$tablename = "Student"
$table = $database.Tables[$tablename]

#display which filegroup the table is on now
Write-Verbose "Current: $($table.FileGroup)"

#now move to a different filegroup
#make sure this filegroup already exists
#if not, create it
$fgname = "FGStudent"

if (!($database.FileGroups[$fgname]))
{
   $fg = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Filegroup -ArgumentList $database, $fgname
   $fg.Create()
}


$fg = $database.FileGroups[$fgname]

#create a datafile and specify the filename
$df = New-Object -TypeName Microsoft.SqlServer.Management.SMO.DataFile -ArgumentList $fg, "studentdata"

$df.FileName = "c:\\Temp\\studentdata.ndf"

#create the datafile
$df.Create()

#now let's recreate the clustered index
#onto the new filegroup
$clusteredindex = $table.Indexes | 
Where-Object IsClustered -eq $true

$clusteredindex.FileGroup = $fgname
$clusteredindex.Recreate()

#display which filegroup the table is on now
$table.Refresh()

#display which filegroup the table is on now
Write-Verbose "New: $($table.FileGroup)"

