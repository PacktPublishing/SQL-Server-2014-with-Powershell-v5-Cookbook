<#============================================================================
  File:     B04525 - Ch10 - 14 - Downloading an SSIS Package to a File.ps1
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

$timestamp = Get-Date -format "yyyy-MMM-dd-hhmmtt"
$destinationFolder = "C:\SSIS\SSIS $($timestamp)"

#If the path exists, will error silently and continue
New-Item -ItemType Directory -Path $destinationFolder -ErrorAction SilentlyContinue

$packageToDownload = "Customer Package"
$packageParentPath = "\File System\QueryWorks"

#download the specified package
#here we're dealing with package in 
#the SSIS Package store
$app.GetDtsServerPackageInfos($packageParentPath,$server) |
Where-Object Flags -eq "Package" |
ForEach-Object {
    $package = $_
    $packagePath = "$($package.Folder)\$($package.Name)"

    #check if this package does exist in the Package Store
    if($app.ExistsOnDtsServer($packagePath, $server))
    {
        $fileName = Join-Path $destinationFolder "$($package.Name).dtsx"
        $newPackage = $app.LoadFromDtsServer($packagePath, $server,$null)
        $app.SaveToXml($fileName, $newPackage, $null)
    }
}

