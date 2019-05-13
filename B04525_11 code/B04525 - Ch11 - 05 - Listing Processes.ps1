<#============================================================================
  File:     B04525 - Ch11 - 05 - Listing Processes.ps1
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

#list all processes to screen
Get-Process

#list 10 most recently started processes
Get-Process | 
Sort-Object -Property StartTime -Descending | 
Select-Object Name, StartTime, Path, Responding -First 10

#Add the following script and run to list save the processes to a text file: 
#save processes to a text file
$txtFile = "C:\Temp\processes.txt"

Get-Process | 
Out-File -FilePath $txtFile -Force

#display text file in notepad
notepad $txtFile

#Add the following script and run to save the processes to a CSV file:
#save processes to a csv file
$csvFile = "C:\Temp\processes.csv"

Get-Process | 
Export-Csv -Path $csvFile -Force -NoTypeInformation

#display first five lines in file
Get-Content $csvFile -totalCount 5

#Add the following script and run to save the processes to XML
$xmlFile = "C:\Temp\processes.xml"

#get top 5 CPU-heavy processes that start with S
Get-Process | 
Where-Object ProcessName -like "S*" | 
Sort-Object -Property CPU -Descending | 
Select-Object Name, CPU -First 5 | 
Export-Clixml -path $xmlFile -Force

#display in Internet Explorer
Set-Alias ie "$env:programfiles\Internet Explorer\iexplore.exe"

ie $xmlFile
