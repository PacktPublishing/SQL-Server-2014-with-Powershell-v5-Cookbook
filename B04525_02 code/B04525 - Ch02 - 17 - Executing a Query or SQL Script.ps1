<#============================================================================
  File:     B04525 - Ch02 - 17 - Executing a Query or SQL Script.ps1
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

#execute a passthrough query, and export to a CSV file

#line continuation in code below only happens at 
#the pipe (|) delimiter
Invoke-Sqlcmd -Query "SELECT * FROM Person.Person" -ServerInstance "$instanceName" -Database $dbName | 
Export-Csv –LiteralPath "C:\Temp\ResultsFromPassThrough.csv" -NoTypeInformation

#execute the SampleScript.sql, and display 
#results to screen 

#line continuation in code below only happens at 
#the pipe (|) delimiter
Invoke-SqlCmd -InputFile "C:\Temp\SampleScript.sql" -ServerInstance "$instanceName" -Database $dbName | 
Select-Object FirstName, LastName, ModifiedDate | 
Format-Table

