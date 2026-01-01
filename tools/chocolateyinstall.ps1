$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$url   = 'https://download.bitdefender.com/windows/installer/en-us/bitdefender_avfree.exe'
$url64 = ''

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'

  url            = $url
  url64bit       = $url64

  softwareName   = 'Bitdefender Antivirus Free*'

  # REQUIRED for community repo – fill these before publishing
  checksum       = '571296823084D3FC029CB30EDA0DDD921680E6B6461630F9971B755841DEB4D2'
  checksumType   = 'sha256'
  checksum64     = ''
  checksumType64 = 'sha256'

  # Bitdefender silent install
  silentArgs     = '/silent'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
