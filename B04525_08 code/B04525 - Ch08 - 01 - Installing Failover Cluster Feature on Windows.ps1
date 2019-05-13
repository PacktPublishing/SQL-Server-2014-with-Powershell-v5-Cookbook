<#============================================================================
  File:     B04525 - Ch08 - 01 - Installing Failover Cluster Feature on Windows.ps1
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

#see if the Failover Clustering Feature is turned on:
Get-WindowsFeature Failover* |
Format-Table –Autosize

#if not installed yet, install using the following PowerShell script:
Install-WindowsFeature -Name Failover-Clustering ` 
–IncludeManagementTools

