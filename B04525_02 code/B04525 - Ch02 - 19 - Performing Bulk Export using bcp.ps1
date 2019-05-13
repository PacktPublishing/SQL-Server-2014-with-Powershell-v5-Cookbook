<#============================================================================
  File:     B04525 - Ch02 - 19 - Performing Bulk Export using bcp.ps1
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
$server = "localhost"
$table = "AdventureWorks2014.Person.Person"
$curdate = Get-Date -Format "yyyy-MM-dd_hmmtt"

$foldername = "C:\Temp\Exports\"

#format file name
$formatfilename = "$($table)_$($curdate).fmt"

#export file name
$exportfilename = "$($table)_$($curdate).csv"

$destination_exportfilename = "$($foldername)$($exportfilename)"
$destination_formatfilename = "$($foldername)$($formatfilename)"

#command to generate format file
$cmdformatfile = "bcp $table format nul -T -c -t `"|`" -r `"\n`" -f `"$($destination_formatfilename)`" -S$($server)"

#command to generate the export file
$cmdexport = "bcp $($table) out `"$($destination_exportfilename)`" -S$($server) -T -f `"$destination_formatfilename`""

#run the format file command
Invoke-Expression $cmdformatfile
 
#delay 1 sec, give server some time to generate the format file
#sleep helps us avoid race conditions
Start-Sleep -s 1

#run the export command
Invoke-Expression $cmdexport  

#check the folder for generated file
explorer.exe $foldername


