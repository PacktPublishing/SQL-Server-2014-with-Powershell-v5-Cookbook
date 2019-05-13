<#============================================================================
  File:     B04525 - Ch10 - 12 - Deploying an SSIS Package to the Package Store.ps1
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

#add ManagedDTS assembly
Add-Type -AssemblyName "Microsoft.SqlServer.ManagedDTS, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"

$server = "localhost"

#create new app
$app = New-Object "Microsoft.SqlServer.Dts.Runtime.Application"

#specify package to be deployed
$dtsx = "C:\SSIS\Customer Package.dtsx"
$package = $app.LoadPackage($dtsx, $null)

#where are we going to deploy?
$SSISPackageStorePath = "\File System\QueryWorks"
$destinationName = "$($SSISPackageStorePath)\$($package.Name)"

#save to the package store
$app.SaveToDtsServer($package, $events, $destinationName, $server)

