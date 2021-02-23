$ErrorActionPreference = 'Stop';

$packageName = $env:ChocolateyPackageName
$basePackageName = 'Busylight_Office_MSTeams_Presence_Setup-1.5.7'
$fullPackage = $basePackageName + '.zip'
$url64 = 'https://www.plenom.com/download/70652/' + $fullPackage
$checksum64 = '4d95c3429fec4131ec1fa7fabe3d15d2a6bcb4ebd76a9313e5c9d1d8d96d6d06'

$WorkSpace = Join-Path $env:TEMP "$packageName.$env:chocolateyPackageVersion"

$WebFileArgs = @{
    packageName         = $packageName
    FileFullPath        = Join-Path $WorkSpace $fullPackage
    Url64bit            = $url64
    Checksum64          = $checkSum64
    ChecksumType        = 'sha256'
    GetOriginalFileName = $true
}

$PackedInstaller = Get-ChocolateyWebFile @WebFileArgs

$UnzipArgs = @{
    PackageName  = $packageName
    FileFullPath = $PackedInstaller
    Destination  = $WorkSpace
}

Get-ChocolateyUnzip @UnzipArgs

$msiPackageNAme = Join-Path $basePackageName "Busylight4MS_Teams_Presence_Setup64.msi"

$InstallArgs = @{
    PackageName    = $packageName
    File           = Join-Path $WorkSpace $msiPackageNAme
    fileType       = 'msi'
    silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
    validExitCodes = @(0, 3010, 1641)
    softwareName   = '*Busylight*Teams*'
}

Install-ChocolateyInstallPackage @InstallArgs
