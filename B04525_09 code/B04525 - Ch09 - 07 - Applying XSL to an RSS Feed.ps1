<#============================================================================
  File:     B04525 - Ch09 - 07 - Applying XSL to an RSS Feed.ps1
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

#replace these with the paths of the files in your system
Set-Alias ie "$env:programfiles\Internet"

#remove $rss variable if it already exists
if ($rss)
{
   Remove-Variable -Name "rss"
} 

#replace these with the paths of the files in your system
$xsl = "C:\DATA\RSS\rss_style.xsl"
$rss = "C:\DATA\RSS\sample_rss.xml"
$styled_rss = "C:\DATA\RSS\sample_result.html"

$xslt = New-Object System.Xml.Xsl.XslCompiledTransform
$xslt.Load($xsl)
$xslt.Transform($rss, $styled_rss)

#load the resulting styled html
#in Internet Explorer
Set-Alias ie "$env:programfiles\Internet Explorer\iexplore.exe"

ie $styled_rss
