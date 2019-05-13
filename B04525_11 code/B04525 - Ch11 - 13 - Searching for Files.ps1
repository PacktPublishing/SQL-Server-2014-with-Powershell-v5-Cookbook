<#============================================================================
  File:     B04525 - Ch11 - 13 - Searching for Files.ps1
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

#search for file with specific extension
$path = "C:\Temp"
Get-ChildItem -Path $path -Include *.sql -Recurse

#search for file based on date creation 
#use LastWriteTime for date modification
[datetime]$startDate =  "2015-05-01"
[datetime]$endDate =  "2015-05-24" 

#note date is at 12 midnight
#sample date Sunday, May 24, 2015 12:00:00 AM

#search for the file
Get-ChildItem -Path $path -Recurse | 
Where-Object CreationTime -ge $startDate | 
Where-Object CreationTime -le $endDate | 
Sort-Object -Property LastWriteTime

#list files greater than 10MB
Get-ChildItem $path -Recurse | 
Where-Object Length -ge 10Mb | 
Select-Object Name,  
@{Name="MB";Expression={"{0:N2}" -f ($_.Length/1MB)}} | 
Sort-Object -Property Length -Descending | 
Format-Table –AutoSize

#search for content of file
#search TXT, CSV and SQL files that contain 
#the word "QueryWorks"
$pattern = "QueryWorks"
Get-ChildItem -Path $path -Include *.txt, *.csv, *.sql -Recurse | 
Select-String -Pattern $pattern
