<#============================================================================
  File:     B04525 - Ch03 - 06 - Checking Disk Space Usage.ps1
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

#get server list
$servers = @("localhost")

#this can come from a file instead of hardcoding 
#the servers
#servers = Get-Content <filename>

Get-WmiObject -ComputerName $servers -Class Win32_Volume |  
ForEach-Object {
   $drive = $_
   $item  = [PSCustomObject] @{
      Name = $drive.Name
      DeviceType = switch ($drive.DriveType)
                   {
                    0 {"Unknown"}
                    1 {"No Root Directory"}
                    2 {"Removable Disk"}
                    3 {"Local Disk"}
                    4 {"Network Drive"}
                    5 {"Compact Disk"}
                    6 {"RAM"}                              
                   }  
      SizeGB = "{0:N2}" -f ($drive.Capacity/1GB)
      FreeSpaceGB = "{0:N2}" -f ($drive.FreeSpace/1GB)
      FreeSpacePercent = "{0:P0}" -f ($drive.FreeSpace/$drive.Capacity)
   }
   $item
} | 
Format-Table -AutoSize


