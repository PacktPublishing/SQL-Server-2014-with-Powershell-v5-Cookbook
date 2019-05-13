<#============================================================================
  File:     B04525 - Ch10 - 20 - Listing SSAS Instance Properties.ps1
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

Import-Module SQLASCmdlets -DisableNameChecking

#Connect to your Analysis Services server 
$SSASServer = New-Object Microsoft.AnalysisServices.Server

$instanceName = "localhost"
$SSASServer.connect($instanceName)

#get all properties
$SSASServer | 
Select-Object *
