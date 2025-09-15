@echo off
echo Starting Learning Management System...
echo.

REM Start LocalDB if not running
sqllocaldb start MSSQLLocalDB

REM Start IIS Express
"C:\Program Files\IIS Express\iisexpress.exe" /path:"e:\Learning Management System\Learning Management System" /port:8080

pause
