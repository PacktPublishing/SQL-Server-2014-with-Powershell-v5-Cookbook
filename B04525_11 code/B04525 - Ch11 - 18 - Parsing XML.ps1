<#============================================================================
  File:     B04525 - Ch11 - 18 - Parsing XML.ps1
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

$vancouverXML = "C:\XML Files\eng-daily-01012012-12312012.xml"

[xml] $xml = Get-Content $vancouverXML

#get number of entries
$xml.climatedata.stationdata.Count

#store max temps in array
$maxtemp = $xml.climatedata.stationdata | 
Foreach-Object 
{ 
   [int]$_.maxtemp."#text" 
}

#list all daily max temperatures
$maxtemp | 
Sort-Object -Descending

#get max temperature recorded in 2012
$maxtemp | 
Sort-Object -Descending | 
Select-Object -First 1
