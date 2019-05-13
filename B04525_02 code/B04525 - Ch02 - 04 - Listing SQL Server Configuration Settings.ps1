<#============================================================================
  File:     B04525 - Ch02 - 04 - Listing SQL Server Configuration Settings.ps1
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

#Explore: get all properties available for a server object
#see http://msdn.microsoft.com/en-us/library/ms212724.aspx
$server | 
Get-Member | 
Where-Object MemberType -eq "Property"

#The Information class lists nonconfigrable 
#instance settings, like BuildNumber, 
#OSVersion, ProductLevel etc
#This also includes settings specified during install
$server.Information.Properties | 
Select-Object Name, Value | 
Format-Table –AutoSize

#The Settings lists some instance level 
#configurable settings,like LoginMode, 
#BackupDirectory etc
$server.Settings.Properties | 
Select-Object Name, Value | 
Format-Table -AutoSize

#The UserOptions include options that can be set 
#for user connections, for example
#AnsiPadding, AnsiNulls, NoCount, QuotedIdentifier
$server.UserOptions.Properties | 
Select-Object Name, Value | 
Format-Table -AutoSize
 
#The Configuration class contains instance-specific 
#settings, like AgentXPs, clr enabled, xp_cmdshell
#You will normally see this when you run 
#the stored procedure sp_configure
$server.Configuration.Properties  | 
Select-Object DisplayName, RunValue, ConfigValue | 
Format-Table –AutoSize



