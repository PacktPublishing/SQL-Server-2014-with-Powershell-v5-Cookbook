<#============================================================================
  File:     B04525 - Ch03 - 11 - Exporting SQL Query to Multiple Servers.ps1
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

#replace this with your own file that contains 
#a list of instances you want to send the query to
$instances = Get-Content "C:\Temp\sqlinstances.txt"
$query = "SELECT @@SERVERNAME 'SERVERNAME', @@VERSION 'VERSION'"
$databasename = "master"
$instances |
ForEach-Object {

   $server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $_

   Invoke-Sqlcmd -ServerInstance $_ -Database $databasename -Query $query
}

