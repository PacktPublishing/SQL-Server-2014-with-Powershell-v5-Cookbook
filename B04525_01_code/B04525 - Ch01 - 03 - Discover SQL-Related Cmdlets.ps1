<#============================================================================
  File:     B04525 - Ch01 - 03 - Discover SQL-Related Cmdlets.ps1
  Author:   Donabel Santos (@sqlbelle | sqlmusings.com)
  Version:  SQL Server 2012, PowerShell V3
  Copyright: 2012
  ----------------------------------------------------------------------------

  This script is intended only as supplementary material to Packt's SQL Server 2012
  and PowerShell V3 book, and is downloadable from http://www.packtpub.com/
  
  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
  ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
  TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
  PARTICULAR PURPOSE.
============================================================================#>
#how many commands from modules that
#have SQL in the name
(Get-Command -Module "*SQL*" –CommandType Cmdlet).Count 

#list all the SQL-related commands
Get-Command -Module "*SQL*" –CommandType Cmdlet | 
Select-Object CommandType, Name, ModuleName | 
Sort-Object -Property ModuleName, CommandType, Name | 
Format-Table -AutoSize

#which modules are loaded in the current PowerShell session
Get-Module -Name "*SQL*"

#explicitly load the SQLPS module
Import-Module -Name "SQLPS"

