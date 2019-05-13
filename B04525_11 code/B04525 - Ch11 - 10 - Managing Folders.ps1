<#============================================================================
  File:     B04525 - Ch11 - 10 - Managing Folders.ps1
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

#list folders ordered by name descending
$path = "C:\Temp" 

#get directories only
Get-Childitem $path | 
Where-Object PSIsContainer

#create folder
$newFolder = "C:\Temp\NewFolder"
New-Item -Path $newFolder -ItemType Directory -Force

#check if folder exists 
Test-Path $newFolder

#copy folder
$anotherFolder = "C:\Temp\NewFolder2"
Copy-Item $newFolder $anotherFolder -Force

#move folder
Move-Item $anotherFolder $newFolder

#delete folder
Remove-Item $newFolder -Force -Recurse
