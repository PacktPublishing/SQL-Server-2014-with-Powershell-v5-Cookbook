<#============================================================================
  File:     B04525 - Ch10 - 02 - Listing SSRS Report Properties.ps1
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

$reportServerUri  = "http://localhost/ReportServer/ReportService2010.asmx"
$proxy = New-WebServiceProxy -Uri $reportServerUri -UseDefaultCredential 

$reportPath = "/Customer Reports/Customer List"

#list this report’s properties
$proxy.ListChildren("/", $true) | 
Where-Object Path -eq $reportPath
