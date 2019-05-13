<#============================================================================
  File:     B04525 - Ch08 - 10 - Testing Availability Group Failover.ps1
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
Import-Module SQLPS –DisableNameChecking
$AGName = "SQLAG"
$instanceName = "SQL02"

$path = "SQLServer:\SQL\$($instanceName)\DEFAULT\AvailabilityGroups\$($AGName)"

#failover
Switch-SqlAvailabilityGroup –Path $path 


