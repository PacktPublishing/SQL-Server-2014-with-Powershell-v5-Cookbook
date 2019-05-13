<#============================================================================
  File:     B04525 - Ch09 - 06 - Creating an RSS Feed from SQL Server content.ps1
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

$instanceName = "localhost"
$databaseName = "SampleDB"
$timestamp = Get-Date -format "yyyy-MMM-dd-hhmmtt"
$rssFileName = "C:\XML Files\rss_$timestamp.xml"

#values to be used for RSS
$rssTitle = "QueryWorks Latest News"
$rssLink = "http://www.queryworks.ca/rss.xml"
$rssDescription = "What's new in the world of QueryWorks"

#use r as date formatter to get
#date in RFC1123Pattern
$rssDate = (Get-Date -Format r)
$rssManagingEditor = "info@queryworks.ca"
$rssGenerator = "SQL Server 2014 XML and PowerShell"
$rssDocs = "http://www.queryworks.ca/rss.xml"

$query = @"
DECLARE @rssbody XML
SET @rssbody = ( SELECT   
                  name AS 'title' ,
                  collation_name AS 'description' ,
                  'false' AS 'guid/@isPermaLink' ,
                  'http://www.queryworks.ca/?p=' + 
		          CAST(database_id AS VARCHAR(5)) AS 'guid'
                 FROM     
		          sys.databases
                 FOR XML PATH('item') , TYPE)
SELECT @rssbody
"@

$rssFromSQL = Invoke-Sqlcmd -ServerInstance $instanceName -Database $databaseName -Query $query

#extract the RSS from the SQL Server result
[string] $rssBody = $rssFromSQL.Column1.ToString()

#create the final RSS
$rsstext = @"
<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
<channel>
  <title><![CDATA[$rssTitle]]></title>
    <atom:link href="http://www.queryworks.ca/rss.xml" rel="self" type="application/rss+xml" />
    <link>$rssLink</link>
    <description><![CDATA[$rssDescription]]></description>
    <pubDate>$rssDate</pubDate>
    <lastBuildDate>$rssDate</lastBuildDate>
    <managingEditor>$rssManagingEditor</managingEditor>
    <generator>$rssGenerator</generator>
    <docs>$rssDocs</docs>
    $rssBody
</channel>
</rss>
"@
[xml] $rss = $rsstext
$rss.Save($rssFileName)


