<#============================================================================
  File:     B04525 - Ch11 - 08 - Using Invoke-Expression.ps1
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

$VerbosePreference = "Continue"

$program = "`"C:\Program Files\7-Zip\7z.exe`""

#arguments
$7zargs = " a -tzip "
$zipFile = " `"C:\Temp\new archive.zip`" "
$directoryToZip = " `"C:\Temp\old`" "

#compose the command
$cmd = "& $program $7zargs $zipFile $directoryToZip "

#display final command
Write-Verbose $cmd

#execute the command
Invoke-Expression $cmd

$VerbosePreference = "SilentlyContinue"
