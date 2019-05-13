<#============================================================================
  File:     B04525 - Ch03 - 25 - Scheduling a SQL Server Job.ps1
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

#replace this with your instance name
$instanceName = "localhost"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

$jobserver = $server.JobServer
$jobname = "Test Job"

$job = $jobserver.Jobs[$jobname]
$jobschedule =  New-Object -TypeName Microsoft.SqlServer.Management.SMO.Agent.JobSchedule -ArgumentList $job, "Every Weekend Night 10PM" 

#Values for FrequencyTypes are:
#AutoStart, Daily, Monthly, MonthlyRelative, OneTime, 
#OnIdle, Weekly, unknown
$jobschedule.FrequencyTypes =  [Microsoft.SqlServer.Management.SMO.Agent.FrequencyTypes]::Weekly

#schedule for every Saturday and Sunday 
#can also use 65
$jobschedule.FrequencyInterval = [Microsoft.SqlServer.Management.SMO.Agent.WeekDays]::WeekEnds

#set time
#3 parameters - hours, mins, days
#if we don't specify time, it will start at midnight
$starttime =  New-Object -TypeName TimeSpan -ArgumentList 22, 0, 0
$jobschedule.ActiveStartTimeOfDay = $starttime

#frequency of recurrence
$jobschedule.FrequencyRecurrenceFactor = 1
$jobschedule.ActiveStartDate = "01/01/2015"

#Create the job schedule on the instance of SQL Agent. 
$jobschedule.Create()

