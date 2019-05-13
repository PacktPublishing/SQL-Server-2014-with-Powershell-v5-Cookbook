<#============================================================================
  File:     B04525 - Ch08 - 09 - Creating Availability Group Listener.ps1
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

$AGName = "SQLAG"
$AGListenerName = "SQLAGListener"
$AGListenerPort = 1433
$AGListenerIPAddress = "192.168.1.200"
$AGListenerSubnetMask = "255.255.255.0"
$primary = "SQL01"

#server object 
$server = New-Object Microsoft.SqlServer.Management.Smo.Server $primary 

#availability group object 
$AG = $server.AvailabilityGroups[$AGName]

#for our recipe, if listener already exists, 
#remove it first
if ($AG.AvailabilityGroupListeners[$AGListenerName] -ne $null)
{
   $AG.AvailabilityGroupListeners[$AGListenerName].Drop()

}

$AGListener = New-Object Microsoft.SqlServer.Management.Smo.AvailabilityGroupListener -ArgumentList $AG, $AGListenerName

$AGListenerIP = New-Object Microsoft.SqlServer.Management.Smo.AvailabilityGroupListenerIPAddress -ArgumentList $AGListener
$AGListener.PortNumber = $AGListenerPort
$AGListenerIP.IsDHCP = $false
$AGListenerIP.IPAddress = $AGListenerIPAddress
$AGListenerIP.SubnetMask = $AGListenerSubnetMask

#add the listener IP
$AGListener.AvailabilityGroupListenerIPAddresses.Add($AGListenerIP)

#create listener
$AGListener.Create()
