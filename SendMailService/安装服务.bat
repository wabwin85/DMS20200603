@echo off
%windir%\Microsoft.NET\Framework\v2.0.50727\InstallUtil.exe -i FishFlow.MailService.exe

net start FishFlow.MailService
pause
