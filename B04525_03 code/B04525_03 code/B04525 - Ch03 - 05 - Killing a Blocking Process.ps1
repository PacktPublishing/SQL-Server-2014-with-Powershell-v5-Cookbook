<#============================================================================
  File:     B04525 - Ch03 - 05 - Killing a Blocking Process.ps1
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

$VerbosePreference = "Continue"

#This assumes you already ran the SQL script in the 
#prep section to create the blocking processes
#Otherwise you may not see any results
$server.EnumProcesses() | 
Where-Object BlockingSpid -ne 0 | 
ForEach-Object {
   Write-Verbose "Killing SPID $($_.BlockingSpid)"
   $server.KillProcess($_.BlockingSpid)
}

$VerbosePreference = "SilentlyContinue"

