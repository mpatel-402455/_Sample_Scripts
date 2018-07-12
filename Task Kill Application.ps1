Get-Process | 
  Where-Object { $_.MainWindowHandle -ne 0 } |
  Select-Object -Property Name, Description, MainWindowTitle, Path, Company, ID |
  Out-GridView -Title 'Choose Application to Kill' -PassThru |
  Stop-Process -WhatIf


  $DBName = xxit6\*


$SPath = Get-WmiObject -ComputerName "xxPJCM501" Win32_Process | Where-Object {$_.CommandLine -like """L:\IBMS\$DBName\*""" -or $_.CommandLine -like "L:\IBMS\$DBName\*"} | Select-Object -Property ProcessID, CommandLine 
$ProcessIDs = ($SPath.ProcessID)


Get-WmiObject -Class Win32_Process | Where-Object {$_.CommandLine -like "C:\Program Files\Adblock Plus for IE\AdblockPlusEngine.exe"} 
