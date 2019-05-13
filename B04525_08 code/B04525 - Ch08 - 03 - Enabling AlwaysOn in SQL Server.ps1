<#============================================================================
  File:     B04525 - Ch08 - 03 - Enabling AlwaysOn in SQL Server.ps1
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

#enable AlwaysOn for all active nodes in the cluster
foreach ($node in Get-ClusterNode)
{
   Write-Host "Processing $($node.Name)"

   #enable AlwaysOn
   Enable-SqlAlwaysOn -ServerInstance $node.Name -Force 

   #targeting default instance
   $serviceName = "MSSQLSERVER"
   $service = Get-Service -ComputerName $node.Name `
              -Name $serviceName
   
   #restart service
   Stop-Service $service -Force
   Start-Service $service 
} 

