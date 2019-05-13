<#============================================================================
  File:     B04525 - Ch02 - 01 - Listing SQL Server Instances.ps1
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

#sql browser must be installed and running for us
#to discover SQL Server instances
Start-Service "SQLBrowser"

$instanceName = "localhost"  
$managedComputer = New-Object Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer $instanceName

#list server instances        
$managedComputer.ServerInstances 



