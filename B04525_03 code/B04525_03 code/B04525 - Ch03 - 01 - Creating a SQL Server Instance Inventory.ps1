<#============================================================================
  File:     B04525 - Ch03 - 01 - Creating a SQL Server Instance Inventory.ps1
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

#replace this with your instance name
$instanceName = "localhost"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

#specify folder and filename to be produced
$folder = "C:\Temp"
$currdate = Get-Date -Format "yyyy-MM-dd_hmmtt"
$filename = "$($instanceName)_$($currdate).csv"
$fullpath = Join-Path $folder $filename

#export all “server” object properties
$server | 
Get-Member | 
Where-Object Name -ne "SystemMessages" |
Where-Object MemberType -eq "Property" |
Select-Object Name, @{Name="Value";Expression={$server.($_.Name)}} |
Export-Csv -Path $fullpath -NoTypeInformation 
 
#jobs are also extremely important to monitor, archive 
#export all job names + last run date and result
$server.JobServer.Jobs | 
Select-Object @{Name="Name";Expression={"Job: $($_.Name)"}}, 
       @{Name="Value";Expression={"Last run: $($_.LastRunDate) ($($_.LastRunOutcome))" }} |
Export-Csv -Path $fullpath -NoTypeInformation -Append

#show file in explorer
explorer $folder
