<#============================================================================
  File:     B04525 - Ch00 - 00 - Name.ps1
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

$verbosepreference = "Continue"
$services = @("SQLBrowser", "ReportServer")
$hostName = "localhost"

$services | 
ForEach-Object {
   $service = Get-Service -Name $_
   if($service.Status -eq "Stopped")
   {
      Write-Verbose "Starting $($service.Name) ...."
      Start-Service -Name $service.Name
   }
   else 
   {
      Write-Verbose "Stopping $($service.Name) ...."
      Stop-Service -Name $service.Name
   }
}
$verbosepreference = "SilentlyContinue"

