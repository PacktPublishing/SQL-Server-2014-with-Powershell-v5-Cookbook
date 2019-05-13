<#============================================================================
  File:     B04525 - Ch08 - 05 - Granting Connect Permission to Hadr Endpoint.ps1
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

$instanceName = "SQL01"
$endpointName = "AlwaysOnEndpoint"
$endpointAccount = "QUERYWORKS\sqlservice"

$server = New-Object Microsoft.SqlServer.Management.Smo.Server $instanceName
$endpoint = $server.Endpoints[$endpointName]

#identify permission
$permissionSet = New-Object Microsoft.SqlServer.Management.Smo.ObjectPermissionSet([Microsoft.SqlServer.Management.Smo.ObjectPermission]::Connect)

#grant permission
$endpoint.Grant($permissionSet,$endpointAccount)
