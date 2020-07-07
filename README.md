# HyperV_Export_Retention
PowerShell script counterpart to HyperV_Export that deletes outdated backups  

Permit running PowerShell scripts on a host: *PowerShell* `Set-ExecutionPolicy RemoteSigned` Then `Y` to confirm  
Run a script: *CMD* `"powershell.exe" -File "C:\HyperV_Export_Retention.ps1" -KeepGroups 3 -Machine "VMName" -Repository "C:\Repository\VMName"`  
Run a script: *PowerShell* `& "C:\HyperV_Retention.ps1" -KeepGroups 3 -Machine "VMName" -Repository "C:\Repository\VMName"`  

This PowerShell script is designed to run as a scheduled task with Administrative privileges on Windows 10. It has also been tested on Server 2012 **R2**, Server 2016, and Server 2019.

# Please review and update as necessary:  
 - $KeepGroups parameter: This is the number of backups to keep and must be an intiger of 1 or greater.  
 - $Machine parameter: This is the name of the VM and is used for the first part of the filename of the backup files.  
 - $Repository parameter: This is the directory where the backup files of a given VM are located.  
 - The $LogDir directory: `"C:\Repository"`  
 - The $LogFile name: `"Retention.log"`  
