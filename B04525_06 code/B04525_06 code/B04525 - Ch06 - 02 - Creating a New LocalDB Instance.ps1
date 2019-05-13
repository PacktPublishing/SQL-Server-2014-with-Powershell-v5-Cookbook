<#============================================================================
  File:     B04525 - Ch06 - 02 - Creating a New LocalDB Instance.ps1
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

#create new LocalDB instance
$localDBInstance = "NewLocalDB"
$command = "SQLLocalDB create `"$($localDBInstance)`""

#execute the command
Invoke-Expression $command

#confirm by listing all instances
$command = "SQLLocalDB i"
Invoke-Expression $command

