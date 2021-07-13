$ErrorActionPreference = 'Stop';

# https://www.plenom.com/download/70652/

$packageName = $env:ChocolateyPackageName
$basePackageName = 'Release-2.1.1'
$fullPackage = $basePackageName + '.zip'
$url64 = 'https://www.plenom.com/download/70652/' + $fullPackage
$checksum64 = '0166e741feed9880a6fd4216d669bf1d55c461eda1fbce5f8d6cfa2658ce74e2'

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

# The zip contains a directory name with a space
#
$msiPackageNAme = Join-Path $basePackageName.Replace("-", " ") "Busylight4MS_Teams_Setup64.msi"

$InstallArgs = @{
    PackageName    = $packageName
    File           = Join-Path $WorkSpace $msiPackageNAme
    fileType       = 'msi'
    silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
    validExitCodes = @(0, 3010, 1641, 1603)
    softwareName   = '*Busylight*Teams*'
}

Install-ChocolateyInstallPackage @InstallArgs
