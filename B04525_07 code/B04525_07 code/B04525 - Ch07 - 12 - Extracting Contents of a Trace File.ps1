<#============================================================================
  File:     B04525 - Ch07 - 12 - Extracting Contents of a Trace File .ps1
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

#import SQL Server module
Import-Module SQLPS -DisableNameChecking

Add-Type -AssemblyName "Microsoft.SqlServer.ConnectionInfo, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
Add-Type -AssemblyName "Microsoft.SqlServer.ConnectionInfoExtended,  Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"

#replace this with your trace file name
$path = "C:\Trace\sampletracefile.trc"
$trcreader = New-Object Microsoft.SqlServer.Management.Trace.TraceFile
$trcreader.InitializeAsReader($path)

#extract all
$result = @()
if($trcreader.Read())
{
   while($trcreader.Read())
   {
      #let's extract only the ones that 
      #took more than 1000ms
      $duration = $trcreader.GetValue($trcreader.GetOrdinal(“Duration”))

      if($duration -ge 1000)
      {
           $cols = ($trcreader.FieldCount) -1
           #we need to dynamically build the hash string
           #because we don't know how many columns 
           #are in the incoming trace file
           $hashstr = "`$hash = @{  `n" 
           for($i = 0;$i -le $cols; $i++)
           {
              $colname = $trcreader.GetName($i)
              #don't include binary data
              if($colName -ne "BinaryData") 
              {
                $colvalue = $trcreader.GetValue($trcreader.GetOrdinal($colname))
                $hashstr += "`"$($colname)`"=`"$($colvalue)`" `n"
              }
           }
           $hashstr += "}"

           #create the real hash
           Invoke-Expression $hashstr

           $item = New-Object PSObject -Property $hash
           $result += $item
       }
   }
}
#display
$result | Format-List
