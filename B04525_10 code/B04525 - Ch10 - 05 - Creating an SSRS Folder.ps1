<#============================================================================
  File:     B04525 - Ch10 - 05 - Creating an SSRS Folder.ps1
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

$reportServerUri  = "http://localhost/ReportServer/ReportService2010.asmx"
$proxy = New-WebServiceProxy -Uri $reportServerUri -UseDefaultCredential

#A workaround we have to do to ensure
#we don't get any namespace clashes is to 
#capture the auto-generated namespace, and 
#create our objects based on this namespace

#capture automatically generated namespace
#this is a workaround to avoid namespace clashes
#resulting in using –Class with New-WebServiceProxy
$type = $Proxy.GetType().Namespace

#formulate data type we need
$datatype = ($type + '.Property')

#display datatype, just for our reference
$datatype

#create new Property
#if we were using –Class SSRS, this would be similar to
#$property = New-Object SSRS.Property
$property = New-Object ($datatype)
$property.Name = "Description"
$property.Value = "Created by PowerShell"
$folderName = "Sales Reports " + (Get-Date -format "yyyy-MMM-dd-hhmmtt")

#Report SSRS Properties
#http://msdn.microsoft.com/en-us/library/ms152826.aspx
$numProperties = 1
$properties = New-Object ($datatype + '[]')$numProperties
$properties[0] = $property

$proxy.CreateFolder($folderName, "/", $properties)

#display new folder in IE
Set-Alias ie "$env:programfiles\Internet Explorer\iexplore.exe"
ie "http://localhost/Reports"
