<#============================================================================
  File:     B04525 - Ch01 - 01 - Install SQL Server.ps1
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
#see recipe for prep work required before
#you can use this script
#change this to the location of your configuration file
$configfile = "C:\Configurations\SQL01_ConfigurationFile.ini"

#we are still using the setup.exe that comes with
#the SQL Server bits
#change to the correct path where setup.exe is stored in your system
$command = "D:\setup.exe /ConfigurationFile=$($configfile)"

#run the command
Invoke-Expression -Command $command | Out-Null

