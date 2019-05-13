<#============================================================================
  File:     B04525 - Ch07 - 04 - Listing Policies.ps1
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

#replace with your server information
$connectionString = "server='localhost';Trusted_Connection=true"

$conn = New-Object Microsoft.SqlServer.Management.Sdk.Sfc.SqlStoreConnection($connectionString)

#NOTE notice how the namespace is still called DMF
#DMF - declarative management framework
#DMF was the old reference to Policy Based Management
$policyStore = New-Object Microsoft.SqlServer.Management.DMF.PolicyStore($conn)

#display policies for this instance
$policyStore.Policies | 
Select Name, CreateDate, 
Condition, ObjectSet, Enabled | 
Format-List

