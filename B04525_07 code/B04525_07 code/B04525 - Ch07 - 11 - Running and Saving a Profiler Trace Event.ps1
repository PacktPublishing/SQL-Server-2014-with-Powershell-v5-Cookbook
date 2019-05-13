<#============================================================================
  File:     B04525 - Ch07 - 11 - Running and Saving a Profiler Trace Event.ps1
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
Add-Type -AssemblyName "Microsoft.SqlServer.ConnectionInfo, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
Add-Type -AssemblyName "Microsoft.SqlServer.ConnectionInfoExtended,  Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"


#import SQL Server module
Import-Module SQLPS -DisableNameChecking

#replace this with your instance name
$instanceName = "localhost"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

#create SqlConnectionInfo object, 
#specifically required to run the traces
#need to specifically use the ConnectionInfoBase type
[Microsoft.SqlServer.Management.Common.ConnectionInfoBase]$conn = New-Object Microsoft.SqlServer.Management.Common.SqlConnectionInfo -ArgumentList "localhost" 

$conn.UseIntegratedSecurity = $true

#create new TraceServer object  
#The TraceServer class can start and read traces
$trcserver = New-Object -TypeName Microsoft.SqlServer.Management.Trace.TraceServer

#need to get a handle to a Trace Template
#in this case we are using the Standard template 
#that comes with Microsoft
$standardTemplate = "C:\Program Files (x86)\Microsoft SQL Server\120\Tools\Profiler\Templates\Microsoft SQL Server\120\Standard.tdf"

$trcserver.InitializeAsReader($conn,$standardTemplate) | Out-Null

$received = 0

#where do you want to write the trace?
#here we compose a timestamped file
$folder = "C:\Temp\"
$currdate = Get-Date -Format "yyyy-MM-dd_hmmtt"
$filename = "$($instanceName)_trace_$($currdate).trc"
$outputtrace = Join-Path $folder $filename

#number of events to capture
$numevents = 10

#create new TraceFile object
#and initialize as writer 
#The TraceFile class can read and write a Trace File
$trcwriter = New-Object Microsoft.SqlServer.Management.Trace.TraceFile

$trcwriter.InitializeAsWriter($trcserver,$outputtrace) | Out-Null

while ($trcserver.Read())
{
    #write incoming trace to file
    $trcwriter.Write() | Out-Null
    $received++

    #we don’t know how many columns are included 
    #in the template so we will have to loop if we 
    #want to capture and display all of them

    #get number of columns
    #we need to subtract 1 because column array
    #is zero-based, ie index starts at 0
    $cols = ($trcserver.FieldCount) -1
    
    #we'll need to dynamically create a hash to
    #contain the trace events

    #because we need to dynamically build this hash
    #based on number of columns included in a template, 
    #we'll have to store the code to build the hash
    #as string first and then invoke expression 
    #to actually build the hash in PowerShell
    $hashstr = "`$hash = `$null; `n `$hash = @{  `n" 
    for($i = 0;$i -le $cols; $i++)
    {
       $colname = $trcserver.GetName($i)

       #add each column to our hash
       #we will not capture the binary data
       if($colname -ne "BinaryData")
       {
          $colvalue = $trcserver.GetValue($trcserver.GetOrdinal($colname))

          $hashstr += "`"$($colname)`"=`"$($colvalue)`" `n"
       }
    }
    $hashstr += "}"

    #create the real hash
    Invoke-Expression $hashstr

    #display
    $item = New-Object PSObject -Property $hash
    $item | Format-List

    if($received -ge $numevents)
    {
       break
    }
}

$trcwriter.Close()
$trcserver.Close()



