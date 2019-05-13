<#============================================================================
  File:     B04525 - Ch04 - 02 - Changing SQL Server Service Account.ps1
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

$instanceName = "localhost"
$managedComputer = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer -ArgumentList $instanceName

#get handle to service
$servicename = "SQLSERVERAGENT"
$sqlservice = $managedComputer.Services | 
Where-Object Name -eq $servicename 

#prompt for the new service account credential
$username = "QUERYWORKS\sqlagent"
$credential = Get-Credential -credential $username 

#change service account
$sqlservice.SetServiceAccount($credential.UserName, $credential.GetNetworkCredential().Password)

#Confirm that the service account has changed:
#list services        
$managedComputer.Services |
Where-Object Name -eq $servicename | 
Select-Object Name, ServiceAccount, 
DisplayName, ServiceState | 
Format-Table -AutoSize
