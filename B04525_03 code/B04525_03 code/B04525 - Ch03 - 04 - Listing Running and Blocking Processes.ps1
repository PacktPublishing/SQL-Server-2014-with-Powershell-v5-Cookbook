<#============================================================================
  File:     B04525 - Ch03 - 04 - Listing Running and Blocking Processes.ps1
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

#List all processes
$server.EnumProcesses() | 
Select-Object Name, Spid, Command, Status, 
Login, Database, BlockingSpid | 
Format-Table –AutoSize

#List blocking Processes
#This assumes you already ran the SQL Script in the 
#prep section to create the blocking processes
#Otherwise you may not see any results
$server.EnumProcesses() |
Where-Object BlockingSpid -ne 0 | 
Select-Object Name, Spid, Command, Status, 
Login, Database, BlockingSpid | 
Format-Table -AutoSize 


