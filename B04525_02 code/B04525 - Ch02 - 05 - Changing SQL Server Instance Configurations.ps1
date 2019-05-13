<#============================================================================
  File:     B04525 - Ch02 - 05 - Changing SQL Server Instance Configurations.ps1
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

<#
run value vs config value
config_value,” is what the setting has been set to (but may or may not be what SQL Server is actually running now. Some settings don’t go into effect until SQL Server has been restarted, or until the RECONFIGURE WITH OVERRIDE option has been run, as appropriate.) And the last column, “run_value,” is the value of the setting currently in effect.
#>

#change FillFactor
$server.Configuration.FillFactor.ConfigValue = 60

#enable SQL Server Agent extended stored procedures
$server.Configuration.AgentXPsEnabled.ConfigValue = 1

#change minimum server memory to 500MB; MB is default
$server.Configuration.MinServerMemory.ConfigValue = 500

$server.Configuration.Alter()

#confirm changes
$server.Configuration.Properties | 
Select-Object DisplayName, ConfigValue | 
Format-Table -AutoSize

#change authentication mode
$server.Settings.LoginMode = [Microsoft.SqlServer.Management.Smo.ServerLoginMode]::Mixed
$server.Alter()

#confirm changes
$server.settings.LoginMode


