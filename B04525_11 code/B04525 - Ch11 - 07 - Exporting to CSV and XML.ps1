<#============================================================================
  File:     B04525 - Ch11 - 07 - Exporting to CSV and XML.ps1
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

$csvFile = "C:\Temp\sample.csv"
Get-Process | 
Export-Csv -path $csvFile -Force -NoTypeInformation

#display text file in notepad
notepad $csvFile 


$xmlFile = "C:\Temp\process.xml"
Get-Process | 
Export-Clixml -path $xmlFile  -Force

#display text file in notepad
notepad $xmlFile 
