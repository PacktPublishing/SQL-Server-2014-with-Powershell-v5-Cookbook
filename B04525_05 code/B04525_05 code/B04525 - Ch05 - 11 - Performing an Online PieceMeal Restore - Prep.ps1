<#============================================================================
  File:     B04525 - Ch05 - 11 - Performing an Online PieceMeal Restore - Prep.ps1
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


function Create-SampleDatabase ($server, $databaseName)
{
   #for this recipe only
   #drop if it exists
   if($server.Databases[$databaseName])
   {
      $server.KillDatabase($databaseName)
   }
   
   $db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database -ArgumentList $server, $databaseName
   $db.Create()
   
   Write-Output "Created database $databaseName"
}


function Create-SampleTable 
{
	param(
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True)]
		[string] $filegroupname,
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True)]
		[ Microsoft.SqlServer.Management.Smo.Server] $server,
		[Parameter(Mandatory=$True,
		ValueFromPipeline=$True)]
		[string] $databasename
	)

    $db = $server.Databases[$databasename]
    $datafolder = "C:\\DATA\\"
    $tablename = "Student_$($filegroupname)"

    if($filegroupname -ne "TXN" -and $filegroupname -ne "PRIMARY")
    {
        if ($db.FileGroups[$filegroupname])
        {
           $db.FileGroups[$filegroupname].Drop()
        }

        #create the filegroup
        $fg = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Filegroup -Argumentlist $db, $filegroupname 
        $fg.Create()

        #Define a DataFile object on the file group and set the logical file name. 
        $datafilename = "$($tablename)_data"
        $datafile = New-Object -TypeName Microsoft.SqlServer.Management.SMO.DataFile -ArgumentList $fg, $datafilename

        #Make sure to have a directory created to hold the designated data file
        $datafile.FileName = "$($datafolder)$($datafilename).ndf"

        #Call the Create method to create the data file on the instance of SQL Server. 
        $datafile.Create()
        
    }
    
    $table = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Table -ArgumentList $db, $tablename
    
    #column 1
    $col1Name = "StudentID"
    $type = [Microsoft.SqlServer.Management.SMO.DataType]::Int
    $col1 =  New-Object -TypeName Microsoft.SqlServer.Management.SMO.Column -ArgumentList $table, $col1Name, $type
    $col1.Nullable = $false
    $col1.Identity = $true
    $col1.IdentitySeed = 1
    $col1.IdentityIncrement = 1
    $table.Columns.Add($col1)
    
    if($filegroupname -ne "TXN")
    {
       $table.FileGroup = $filegroupname
    }
    
    $table.Create()

}
cls

#clean backup folder
$backupfolder = "C:\BACKUP\"
Remove-Item -Path "$($backupfolder)\*" -Recurse -Force

$instanceName = "localhost"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName
$databasename = "StudentDB"

Create-SampleDatabase $server $databaseName


#-------------------------------------------------
#create three tables, and assign them
#to the respective filegroups
#-------------------------------------------------
"PRIMARY","FG1","FG2"|
ForEach-Object {
    $fg = $_
    Create-SampleTable -filegroupname $fg -server $server -databasename $databasename 

    $backupfile = "$($databasename)_$($fg).bak"
    $fgBackupFile = Join-Path $backupfolder $backupfile
    
    Backup-SqlDatabase `
    -BackupAction Files `
    -DatabaseFileGroup $fg `
    -ServerInstance $instanceName `
    -Database $databasename `
    -BackupFile $fgBackupFile `
    -Checksum `
    -Initialize `
    -BackupSetName "$databasename $fg Backup" `
    -CompressionOption On    
}

#-------------------------------------------------
#create a transaction log backup
#-------------------------------------------------
$fg = "TXN"
Create-SampleTable -filegroupname $fg -server $server -databasename $databasename 

$backupfile = "$($databasename)_$($fg).bak"
$txnBackupFile = Join-Path $backupfolder $backupfile

Backup-SqlDatabase `
-BackupAction ([Microsoft.SqlServer.Management.Smo.BackupActionType]::Log) `
-ServerInstance $instanceName `
-Database $databasename `
-BackupFile $txnBackupFile `
-BackupSetName "$databasename $fg Backup"  `
-Checksum 