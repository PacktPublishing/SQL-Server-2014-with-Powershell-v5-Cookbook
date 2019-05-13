<#============================================================================
  File:     B04525 - Ch01 - 05 - Explore SMO Objects.ps1
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
#Import SQLPS Module 
Import-Module SQLPS -DisableNameChecking
$instanceName = "localhost"

#code below all in one line
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

$server | 
Get-Member -MemberType "Property" | 
Where-Object Definition -Like "*Smo*"

#check SMO Objects under Databases
$server.Databases | 
Get-Member -MemberType "Property" | 
Where-Object Definition -Like "*Smo*"

#Check out tables 
$server.Databases["AdventureWorks2008R2"].Tables | 
Get-Member -MemberType "Property" | 
Where-Object Definition -Like "*Smo*"


