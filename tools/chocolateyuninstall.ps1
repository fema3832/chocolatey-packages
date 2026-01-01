$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName

$uninstallKeys = @(
  'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
  'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
)

$apps = Get-ItemProperty $uninstallKeys -ErrorAction SilentlyContinue |
  Where-Object {
    $_.DisplayName -like 'Bitdefender Antivirus Free*'
  }

if ($apps) {
  foreach ($app in $apps) {
    if ($app.UninstallString) {
      Write-Host "Attempting to uninstall Bitdefender Antivirus Free..."

      $uninstallCmd = $app.UninstallString

      Start-Process `
        -FilePath "cmd.exe" `
        -ArgumentList "/c $uninstallCmd" `
        -Wait `
        -NoNewWindow
    }
  }
}
else {
  Write-Warning "Bitdefender Antivirus Free not found. It may already be uninstalled."
}
