<#============================================================================
  File:     B04525 - Ch11 - 17 - Creating HTML Report.ps1
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

#simple CSS Style
$style = @"
<style type='text/css'>
  td {border:1px solid gray;} 
  .stopped{background-color: #E01B1B;}
</style>
"@ 

#let's get content from Get-Service
#and output this to a styled HTML 
Get-Service | 
ConvertTo-Html -Property Name, Status -Head $style | 
Foreach-Object { 
    #if service is running, use green background
    if ($_ -like "*<td>Stopped</td>*") 
	 {
	 	$_ -replace "<tr>", "<tr class='stopped'>"
	 } 
	 else 
	 { 
      #display normally
	 	$_ 
	 }	 
  } | 
Out-File "C:\Temp\sample.html" -force

#open the page in Internet Explorer
Set-Alias ie "$env:programfiles\Internet Explorer\iexplore.exe"
ie "C:\Temp\sample.html"
