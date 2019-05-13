<#============================================================================
  File:     B04525 - Ch02 - 21 - Performing Bulk Import using bcp.ps1
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

Import-Module SQLPS -DisableNameChecking
$instanceName = "localhost"
$dbName = "AdventureWorks2014"

function Truncate-Table {
<# 
.SYNOPSIS 
    Very simple function to truncate 
    records from Test.Person 
.NOTES 
    Author     : Donabel Santos 
.LINK 
    http://www.sqlbelle.com
#>
param([string]$instanceName,[string]$dbName)

$query = @"
TRUNCATE TABLE Test.Person
"@

#check number of records
#code below should be in a single line
Invoke-Sqlcmd -Query $query -ServerInstance $instanceName 
-Database $dbName
}


function Get-PersonCount {
<# 
.SYNOPSIS 
    Very simple function to get number 
    of records in Test.Person 
.NOTES 
    Author     : Donabel Santos 
.LINK 
    http://www.sqlbelle.com
#> 
param([string]$instanceName,[string]$dbName)
$query = @"
SELECT COUNT(*) AS NumRecords
FROM Test.Person
"@

#check number of records
#code below should be in a single line
Invoke-Sqlcmd -Query $query -ServerInstance $instanceName 
-Database $dbName
}

#let's clean up the Test.Person table first
Truncate-Table $instanceName $dbName

$server = "localhost"
$table = "AdventureWorks2014.Test.Person"
$importfile = "C:\Temp\Exports\Person.Person.csv"


#command to import from csv
$cmdimport = "bcp $($table) in `"$($importfile)`" -S$server -T -c -t `"|`" -r `"\n`" " 

#run the import command
Invoke-Expression $cmdimport 

#delay 1 sec, give server some time to import records
#sleep helps us avoid race conditions
Start-Sleep -s 2

Get-PersonCount $instanceName $dbName

