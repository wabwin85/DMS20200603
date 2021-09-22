@echo off
net stop FishFlow.MailService

%windir%\Microsoft.NET\Framework\v2.0.50727\InstallUtil.exe -u FishFlow.MailService.exe

pause
