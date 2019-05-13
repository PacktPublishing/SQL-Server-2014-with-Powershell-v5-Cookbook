<#============================================================================
  File:     B04525 - Ch08 - 06 - Creating an AlwaysOn Availability Group.ps1
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
$db = "QueryWorksDB"

#create primary replica
$primaryReplica = New-SqlAvailabilityReplica `
-Name "SQL01" `
-EndpointUrl "TCP://SQL01:5022" `
-AsTemplate -FailoverMode Automatic `
-AvailabilityMode SynchronousCommit `
-Version 12 

#create first secondary replica
$secondaryReplica1 = New-SqlAvailabilityReplica `
-Name "SQL02" `
-EndpointUrl "TCP://SQL02:5022" `
-AsTemplate -FailoverMode Automatic `
-AvailabilityMode SynchronousCommit `
-Version 12 

#create second secondary replica
$secondaryReplica2 = New-SqlAvailabilityReplica `
-Name "SQL03" `
-EndpointUrl "TCP://SQL03:5022" `
-AsTemplate -FailoverMode Manual `
-AvailabilityMode AsynchronousCommit `
-Version 12

#PSProvider path of primary instance 
$primaryPath = "SQLSERVER:\SQL\SQL01\DEFAULT"

#create availability group in primary instance
New-SqlAvailabilityGroup `
-Path $primaryPath -Name $AGName `
-AvailabilityReplica ($primaryReplica, $secondaryReplica1, $secondaryReplica2) `
-Database $db 
