<#============================================================================
  File:     B04525 - Ch08 - 08 - Adding Availability Database to Availability Group.ps1
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
$dbName = "QueryWorksDB"
$secondaryList = @("SQL02", "SQL03")
$cred = Get-Credential

foreach ($secondary in $secondaryList)
{

    $server = New-Object Microsoft.SqlServer.Management.Smo.Server $secondary 

    #get handle to availability grou
    $ag = $server.AvailabilityGroups[$AGName]

    #add database
    Add-SqlAvailabilityDatabase -InputObject $ag `
    -Database $dbName 

}
