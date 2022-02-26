# Set-ExecutionPolicy RemoteSigned
# Unblock-File -Path "C:\HyperV_Export_Retention.ps1"
# "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -File "C:\HyperV_Export_Retention.ps1"
Param ([int]$KeepGroups,[string]$Machine,[string]$Repository)

$LogDir = "C:\Repository"

$Stop = $true
if ($KeepGroups) {
    if ($KeepGroups -gt 0) {
        if ($Machine) {
            if ($Repository) {
                $Stop = $false
            } else {Write-Host "-Repository directory is required"}
        } else {Write-Host "-Machine name is required"}
    } else {Write-Host "-KeepGroups must be greater than zero"}
} else {Write-Host "-KeepGroups number is required"}

if ($Stop) {
    Write-Host "CMD> ""powershell.exe"" -File ""C:\HyperV_Export_Retention.ps1"" -KeepGroups 3 -Machine ""VMName"" -Repository ""C:\Repository\VMName"""
    Write-Host "PowerShell> & ""C:\HyperV_Export_Retention.ps1"" -KeepGroups 3 -Machine ""VMName"" -Repository ""C:\Repository\VMName"""
    Exit    
}

$FORMAT_ISO_8601 = "yyyy-MM-ddTHHmmss"
$REGEX_ISO_8601 = "\d{4}-\d{2}-\d{2}T\d{2}\d{2}\d{2}"
$DateTimeStart = Get-Date -format $FORMAT_ISO_8601
$LogFile = "Retention.log"

if (!(Test-Path -Path "$($LogDir)\$($LogFile)" -PathType Leaf)) {
    if (!(Test-Path -Path "$($LogDir)" -PathType Container)) {
        try {
            New-Item -Path "$($LogDir)" -ItemType "directory" -ErrorAction Stop
        }
        catch {
            Write-Host($Error[0].Exception.GetType().FullName)
            Write-Host($PSItem.ToString())
            Exit
        }
    }
}
Function LogWrite {
    Param ([string]$LogString)
    Add-content "$($LogDir)\$($LogFile)" -value $LogString
    Write-Host $LogString
}

LogWrite("")
LogWrite($DateTimeStart)
if (!(Test-Path -Path "$($Repository)" -PathType Container)) {
    LogWrite("Cannot access -Repository ""$($Repository)""")
    Exit
}

$FilesNames = Get-ChildItem -Path $Repository -File -Name
$FileGroupDictionary = @{}
foreach ($i in $FilesNames.GetEnumerator()) {
    #if ($i -match "^$($Machine).?(\d{4}-\d{2}-\d{2}T\d{2}\d{2}\d{2}\.7z)(\.\d{3})?$") {
    if ($i -match "^$($Machine).?($($REGEX_ISO_8601)\.7z)(\.\d{3})?$") {
        # $FileName = $Matches.0
        $FileGroup = $Matches.1
        try {
            $FileGroupDictionary.Add($FileGroup,"")
        }
        catch [System.Management.Automation.MethodInvocationException] {
            # When we try to insert a duplicate Key into the Dictionary, this catches the resulting exception.
        }
        catch {
            LogWrite($Error[0].Exception.GetType().FullName)
            LogWrite($PSItem.ToString())
        }
    }
}
LogWrite("Matched files in ""$($Repository)"" for -Machine ""$($Machine)""")

$SortedFileGroupDictionary = @{}
$Count = 0
foreach ($i in $FileGroupDictionary.GetEnumerator() | Sort-Object -Property key -Descending) {
    $SortedFileGroupDictionary.Add($Count+1,$i.Key)
    $Count++
}
LogWrite("Found $($Count) groups of files")

foreach ($i in $SortedFileGroupDictionary.GetEnumerator()) {
    if ($i.Key -gt $KeepGroups) {
        LogWrite("Delete group ", $i.Value -join "")
        foreach ($i2 in $FilesNames.GetEnumerator()) {
            if ($i2 -match $i.Value) {
                try {
                    Remove-Item -Path "$($Repository)\$($i2)" -ErrorAction Stop
                    LogWrite("Deleted file """, $Repository, "\", $i2, """" -join "")
                }
                catch {
                    LogWrite($Error[0].Exception.GetType().FullName)
                    LogWrite($PSItem.ToString())
                }
            }
        }
    } else {LogWrite("Keep group ", $i.Value -join "")}
}
$DateTimeStop = Get-Date -format $FORMAT_ISO_8601
LogWrite("Done. ", $DateTimeStop -join "")
