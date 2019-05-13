<#============================================================================
  File:     B04525 - Ch03 - 22 - Creating a SQL Server Job.ps1
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

$jobName = "Test Job"

#we will drop our test job if it exists already
if($server.JobServer.Jobs[$jobName])
{
   $server.JobServer.Jobs[$jobName].Drop()
}

$job = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Agent.Job -Argumentlist $server.JobServer, $jobName

#Specify which operator to inform 
$operatorName = "tstark"
$operator = $server.JobServer.Operators[$operatorName]
$job.OperatorToEmail = $operator.Name

#Specify completion action
#Values can be: Never, OnSuccess, OnFailure, Always
$job.EmailLevel =  [Microsoft.SqlServer.Management.SMO.Agent.CompletionAction]::OnFailure

#create
$job.Create()

#apply to local instance of SQL Server
#for local we need to specify "(local)"
$job.ApplyToTargetServer("(local)")

#now let's add a simple T-SQL Job Step
$jobStep = New-Object Microsoft.SqlServer.Management.Smo.Agent.JobStep($job, "Test Job Step")
$jobStep.Subsystem = [Microsoft.SqlServer.Management.Smo.Agent.AgentSubSystem]::TransactSql
$jobStep.Command = "SELECT GETDATE()"
$jobStep.OnSuccessAction = [Microsoft.SqlServer.Management.Smo.Agent.StepCompletionAction]::QuitWithSuccess
$jobStep.OnFailAction = [Microsoft.SqlServer.Management.Smo.Agent.StepCompletionAction]::QuitWithFailure

#create the job
$jobStep.Create()

