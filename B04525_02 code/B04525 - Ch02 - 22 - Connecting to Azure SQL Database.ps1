<#============================================================================
  File:     B04525 - Ch02 - 22 - Connecting to Azure SQL Database.ps1
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
#Get your Azure subscription. 
#saves this in local directory
Get-AzureSubscription

#Import your settings file
Import-AzurePublishSettingsFile -PublishSettingsFile "C:\DATA\your-credentials.publishsettings"

#set up firewall rules
#change to appropriate values applicable in your environment
$servername = "YourAzureServerName"

New-AzureSqlDatabaseServerFirewallRule -ServerName $servername -RuleName 'ServerIP' -StartIpAddress '192.168.1.101' 
-EndIpAddress '192.168.1.101'

#Connect to your SQL Azure database
$server = Get-AzureSqlDatabase -ServerName $servername

#check the database properties 
$server 


