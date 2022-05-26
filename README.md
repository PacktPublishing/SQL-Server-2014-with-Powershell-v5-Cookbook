## [Get this title for $10 on Packt's Spring Sale](https://www.packt.com/B04525?utm_source=github&utm_medium=packt-github-repo&utm_campaign=spring_10_dollar_2022)
-----
For a limited period, all eBooks and Videos are only $10. All the practical content you need \- by developers, for developers

# SQL Server 2012 with PowerShell V3 Cookbook

<a href="https://www.packtpub.com/networking-and-servers/sql-server-2012-powershell-v3-cookbook?utm_source=github&utm_medium=repository&utm_campaign=9781849686464 "><img src="https://d1ldz4te4covpm.cloudfront.net/sites/default/files/imagecache/ppv4_main_book_cover/6464EN_Microsoft%20SQL%20Server%202012%20with%20Powershell%203.0%20Cookbook_cov.jpg" alt="SQL Server 2012 with PowerShell V3 Cookbook" height="256px" align="right"></a>

This is the code repository for [SQL Server 2012 with PowerShell V3 Cookbook](https://www.packtpub.com/networking-and-servers/sql-server-2012-powershell-v3-cookbook?utm_source=github&utm_medium=repository&utm_campaign=9781849686464 ), published by Packt.

**Over 150 real-world recipes to simplify database management, automate repetitive tasks, and enhance your productivity**

## What is this book about?
PowerShell is Microsoft’s new command-line shell and scripting language that promises to simplify automation and integration across different Microsoft applications and components. Database professionals can leverage PowerShell by utilizing its numerous built-in cmdlets, or using any of the readily available .NET classes, to automate database tasks, simplify integration, or just discover new ways to accomplish the job at hand.

This book covers the following exciting features:
Create an inventory of database properties and server configuration settings 
Backup and restore databases 
Execute queries to multiple servers 
Maintain permissions and security for users 
Import and export XML into SQL Server 
Extract CLR assemblies and BLOB objects from the database 
Explore database objects 
Manage and deploy SSIS packages and SSRS reports 
Manage and monitor running SQL Server services and accounts 
Parse and display the contents of trace files 
Create SQL Server jobs, alerts and operators 
Find blocking processes that are hampering your database performance 
 

If you feel this book is for you, get your [copy](https://www.amazon.com/dp/1785283324) today!

<a href="https://www.packtpub.com/?utm_source=github&utm_medium=banner&utm_campaign=GitHubBanner"><img src="https://raw.githubusercontent.com/PacktPublishing/GitHub/master/GitHub.png" 
alt="https://www.packtpub.com/" border="5" /></a>

## Instructions and Navigations
All of the code is organized into folders. For example, Chapter03.

The code will look like the following:
```
$server.EnumProcesses() | 
Where-Object BlockingSpid -ne 0 | 
ForEach-Object {
   Write-Verbose "Killing SPID $($_.BlockingSpid)"
   $server.KillProcess($_.BlockingSpid)
}
```

**Following is what you need for this book:**
If you are a SQL Server database professional (DBA, developer, or BI developer) who wants to use PowerShell to automate, integrate, and simplify database tasks, this books is for you. Prior knowledge of scripting would be helpful, but it is not necessary.


## Get to Know the Author
**Donabel Santos**
is a business intelligence architect, trainer/instructor, consultant, author, and principal at QueryWorks Solutions (http://www.queryworks.ca/), based in Vancouver, Canada. She works primarily with SQL Server for database/data warehouse, reporting, and ETL solutions. She scripts and automates tasks with T-SQL and PowerShell and creates corporate dashboards and visualizations with Tableau and Power BI. She is a Microsoft Certified Trainer (MCT) and an accredited Tableau trainer. She provides consulting and corporate training to clients and also conducts some of Tableau's fundamental and advanced classes in Canada. She is the lead instructor for SQL Server and Tableau (Visual Analytics) courses at British Columbia Institute of Technology (BCIT) Part-time Studies (PTS). She is a self-professed data geek. Her idea of fun is working with data, SQL Server, PowerShell, and Tableau. She authored two books from Packt Publishing: SQL Server 2012 with PowerShell v3 Cookbook, and PowerShell and SQL Server Essentials. She has also contributed to PowerShell Deep Dives, Manning Publications. She blogs at http://sqlbelle.com/ and tweets at @sqlbelle.



## Other books by the authors
[PowerShell for SQL Server Essentials](https://www.packtpub.com/application-development/powershell-sql-server-essentials?utm_source=github&utm_medium=repository&utm_campaign=9781784391492 )

[Tableau 10 Business Intelligence Cookbook](https://www.packtpub.com/big-data-and-business-intelligence/tableau-10-business-intelligence-cookbook?utm_source=github&utm_medium=repository&utm_campaign=9781786465634 )


### Suggestions and Feedback
[Click here](https://docs.google.com/forms/d/e/1FAIpQLSdy7dATC6QmEL81FIUuymZ0Wy9vH1jHkvpY57OiMeKGqib_Ow/viewform) if you have any feedback or suggestions.
