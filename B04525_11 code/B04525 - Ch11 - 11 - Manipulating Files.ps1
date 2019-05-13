<#============================================================================
  File:     B04525 - Ch11 - 11 - Manipulating Files.ps1
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

#create file
$timestamp = Get-Date -format "yyyy-MMM-dd-hhmmtt"
$path = "C:\Temp\"
$fileName = "$timestamp.txt"
$fullPath = Join-Path $path $fileName

New-Item -Path $path -Name $fileName -ItemType "File"

#check if file exists 
Test-Path $fullPath

#copy file
$path = "C:\Temp\"
$newFileName = $timestamp + "_2.txt"
$fullPath2 = Join-Path $path $newFileName

Copy-Item $fullPath $fullPath2 

#move file
$newFolder = "C:\Data"
Move-Item $fullPath2 $newFolder

#append to file
Add-Content $fullPath "Additional Item"

#show contents of file
notepad $fullPath

#merge file contents
$newContent = Get-Content "C:\Temp\processes.txt"
Add-Content $fullPath $newContent
#show contents of file
notepad $fullPath

#delete file
Remove-Item $fullPath
