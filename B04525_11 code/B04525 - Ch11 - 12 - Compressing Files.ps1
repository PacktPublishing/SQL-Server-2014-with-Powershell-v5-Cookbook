<#============================================================================
  File:     B04525 - Ch11 - 12 - Compressing Files.ps1
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

#replace the variable values with your
#folder and destination file values

#search for file with specific extension
$folderToCompress = "C:\Temp\MyFiles"
$destinationFile = $folderToCompress + ".zip"

Compress-Archive -Path $ folderToCompress –DestinationPath $destinationFile –CompressionLevel Fastest -Update
