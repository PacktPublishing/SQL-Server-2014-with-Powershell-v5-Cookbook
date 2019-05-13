<#============================================================================
  File:     B04525 - Ch03 - 21 - Adding a SQL Server Operator.ps1
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

$jobserver     = $server.JobServer
$operatorName  = "tstark"
$operatorEmail = "tstark@queryworks.local"

$operator = New-Object  Microsoft.SqlServer.Management.Smo.Agent.Operator -ArgumentList $jobserver, $operatorName
$operator.EmailAddress = $operatorEmail
$operator.Create()

#verify by listing operators
$jobserver.Operators 


