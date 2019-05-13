<#============================================================================
  File:     B04525 - Ch10 - 09 - Downloading all SSRS Report RDL Files.ps1
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
$reportServerUri  = "http://localhost/ReportServer/ReportService2010.asmx"
$proxy = New-WebServiceProxy -Uri $reportServerUri -UseDefaultCredential

$destinationFolder = "C:\SSRS\"

#create a new folder where we will save the files
#we'll use a time-stamped folder, format similar 
#to 2012-Mar-28-0850PM
$ts = Get-Date -format "yyyy-MMM-dd-hhmmtt"
$folderName = "RDL Files $($ts)"
$fullFolderName = Join-Path -Path "$($destinationFolder)" -ChildPath $folderName

#If the path exists, will error silently and continue
New-Item -ItemType Directory -Path $fullFolderName -ErrorAction SilentlyContinue

#get all reports
#second parameter means recursive
#CHANGE ALERT: 
#in ReportingService2005 - Type
#in ReportingService2010 - TypeName
$proxy.ListChildren("/", $true) | 
Select-Object TypeName, Path, ID, Name | 
Where-Object TypeName -eq "Report" |
ForEach-Object {
    $item = $_
    [string]$path = $item.Path
    $pathItems=$path.Split("/") 

    #get path name we will mirror structure 
    #when we save the file
    $reportName = $pathitems[$pathItems.Count -1]
    $subfolderName = $path.Trim($reportName)

    $fullSubfolderName = Join-Path -Path "$($fullFolderName)" -ChildPath $subfolderName

    #If the path exists, will error silently and continue
    New-Item -ItemType directory -Path $fullSubfolderName -ErrorAction SilentlyContinue

    #CHANGE ALERT: 
    #in ReportingService2005 - GetReportDefinition
    #in ReportingService2010 - GetItemDefinition
    #use $Proxy | gm to learn more
    [byte[]] $reportDefinition = $proxy.GetItemDefinition($item.Path) 
    
    #note here we're forcing the actual definition to be 
    #stored as a byte array
    #if you take out the @() from the 
    #MemoryStream constructor, 
    #you'll get an error
    [System.IO.MemoryStream] $memStream = New-Object System.IO.MemoryStream(@(,$reportDefinition))

    #save the XML file 
    $rdlFile = New-Object System.Xml.XmlDocument
    $rdlFile.Load($memStream) | Out-Null
    
    $fullReportFileName = "$($fullSubfolderName)$($item.Name).rdl"
    Write-Verbose "Saving $($fullReportFileName)"
    $rdlFile.Save($fullReportFileName)

}

Write-Verbose "Done downloading your RDL files to  $($fullFolderName)"
$VerbosePreference = "SilentlyContinue"
