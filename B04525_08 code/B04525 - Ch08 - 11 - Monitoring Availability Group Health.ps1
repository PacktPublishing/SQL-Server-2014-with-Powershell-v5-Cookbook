<#============================================================================
  File:     B04525 - Ch08 - 11 - Monitoring Availability Group Health.ps1
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
$AGName = "SQLAG"

#SMO server object
$server = New-Object Microsoft.SqlServer.Management.Smo.Server  $instanceName

#test availability group health
$AGPath = "SQLSERVER:\SQL\$($instanceName)\DEFAULT\AvailabilityGroups\$($AGName)"
Test-SqlAvailabilityGroup -Path $AGPath 

#check all AG properties using SMO
$server.AvailabilityGroups[$AGName] | 
Select-Object * 

#test availability replica health
$AGReplicaPath = "SQLSERVER:\SQL\$($instanceName)\DEFAULT\AvailabilityGroups\$($AGName)\AvailabilityReplicas\$($instanceName)"
Test-SqlAvailabilityReplica -Path $AGReplicaPath 

#check availability replica properties using SMO
$server.AvailabilityGroups[$AGName].AvailabilityReplicas | 
Select-Object *

#test availability database replica state health
$AGReplicaStatePath = "SQLSERVER:\SQL\$($instanceName)\DEFAULT\AvailabilityGroups\$($AGName)\DatabaseReplicaStates"

Get-ChildItem $AGReplicaStatePath | 
Test-SqlDatabaseReplicaState

#check database replica state properties using SMO
$server.AvailabilityGroups[$AGName].DatabaseReplicaStates | 
Select-Object *
