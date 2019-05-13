<#============================================================================
  File:     B04525 - Ch03 - 03 - Listing Installed Hotfixes and Service Packs.ps1
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

#the version format is:
#major.minor.build.buildminor
#this should tell you collectively at what 
#level your install is
$server.Information.VersionString 

#version of SQL Server:
#'RTM' = Original release version
#'SPn' = Service pack version
#'CTP', = Community Technology Preview version
$server.Information.ProductLevel

#to get hotfixes/updates/patches, we can use 
#the Get-Hotfix cmdlet
#Get-Hotfix wraps the WMI class Win32_QuickFixEngineering
#but this may miss some updates or properties, 
#depending on your OS
#this also does not include updates that are supplied by 
#Microsoft Windows Installer (MSI) 

#get all hotfixes
#note the Get-Hotfix cmdlet does not list updates
#applied by MSI (Microsoft Installer)
Get-Hotfix

#check if a specific hotfix is installed
Get-Hotfix -Id "KB2620704"

