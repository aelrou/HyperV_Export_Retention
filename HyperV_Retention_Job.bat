start "Z" /wait /b "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -File "C:\HyperV_Export_Retention.ps1" -KeepGroups 4 -Machine "VM1" -Repository "C:\Repository\VM1"
start "Z" /wait /b "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -File "C:\HyperV_Export_Retention.ps1" -KeepGroups 2 -Machine "VM2" -Repository "C:\Repository\VM2"
start "Z" /wait /b "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -File "C:\HyperV_Export_Retention.ps1" -KeepGroups 6 -Machine "VM3" -Repository "C:\Repository\VM3"
