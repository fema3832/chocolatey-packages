Import-Module AU

$downloadUrl = 'https://download.bitdefender.com/windows/installer/en-us/bitdefender_avfree.exe'

function global:au_GetLatest {

    $tempFile = Join-Path $env:TEMP 'bitdefender_avfree.exe'

    Write-Host "Downloading Bitdefender Antivirus Free installer..."

    Invoke-WebRequest `
        -Uri $downloadUrl `
        -OutFile $tempFile `
        -UseBasicParsing

    if (-not (Test-Path $tempFile)) {
        throw "Failed to download Bitdefender installer."
    }

    # Extract version from EXE metadata
    $version = (Get-Item $tempFile).VersionInfo.ProductVersion

    if (-not $version) {
        throw "Could not determine Bitdefender version."
    }

    return @{
        Version = $version
        Url32   = $downloadUrl
    }
}

function global:au_SearchReplace {
    @{
        'tools\chocolateyinstall.ps1' = @{
            '(?i)^\s*url\s*=.*$'        = "  url           = '$($Latest.Url32)'"
            '(?i)^\s*checksum\s*=.*$'   = "  checksum      = '$($Latest.Checksum32)'"
        }
        'bitdefender-av-free.nuspec' = @{
            '(?i)<version>.*?</version>' = "<version>$($Latest.Version)</version>"
        }
    }
}

function global:au_AfterUpdate {
    Write-Host "Bitdefender Antivirus Free updated to version $($Latest.Version)"
}

Update-Package -NoReadme
