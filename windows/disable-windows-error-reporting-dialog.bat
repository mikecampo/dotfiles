reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d 1 /f
reg add "HKLM\System\CurrentControlSet\Services\WerSvc" /v "Start" /t REG_DWORD /d 4 /f