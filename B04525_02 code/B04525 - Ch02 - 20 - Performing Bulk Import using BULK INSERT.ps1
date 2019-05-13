<#============================================================================
  File:     B04525 - Ch02 - 20 - Performing Bulk Import using BULK INSERT.ps1
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

function Import-Person {
<# 
.SYNOPSIS 
    Very simple function to get number 
    of records in Test.Person 
.NOTES 
    Author     : Donabel Santos 
.LINK 
    http://www.sqlbelle.com
#> 
param(
   [string]$instanceName,
   [string]$dbName,
   [string]$fileName
)
$query = @"
TRUNCATE TABLE Test.Person
GO
BULK INSERT AdventureWorks2014.Test.Person
   FROM `'$fileName`'
   WITH 
      (
         FIELDTERMINATOR ='|',
         ROWTERMINATOR ='\n'
      )
SELECT COUNT(*) AS NumRecords
FROM AdventureWorks2014.Test.Person
"@

#check number of records
#code below should be in one line
Invoke-Sqlcmd -Query $query -ServerInstance $instanceName -Database $dbName
}

#Now let’s invoke the function in the same session as follows:
$instanceName = "localhost"
$dbName = "AdventureWorks2014"
$fileName = "C:\Temp\Exports\Person.Person.csv"
Import-Person $instanceName $dbName $fileName


