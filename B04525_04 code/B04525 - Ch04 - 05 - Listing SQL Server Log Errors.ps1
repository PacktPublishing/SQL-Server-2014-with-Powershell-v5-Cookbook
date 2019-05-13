<#============================================================================
  File:     B04525 - Ch04 - 05 - Listing SQL Server Log Errors.ps1
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

#According to MSDN:
#ReadErrorLog: returns A StringCollection system object 
#value that contains an enumerated list of errors from 
#the SQL Server error log.
[datetime]$date = "2015-03-01"

$server.ReadErrorLog() | 
Where-Object Text -like "*failed*" |
Where-Object LogDate -ge $date | 
Format-Table –AutoSize
