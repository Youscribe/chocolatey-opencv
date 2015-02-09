$packageName = 'OpenCV'
$binaryKeepers = 'x86\vc10' # All other binaries will be ignored
$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$toolsDir = $scriptPath
$downloadedFile = Join-Path $scriptPath 'opencv.exe'
$url = 'http://downloads.sourceforge.net/project/opencvlibrary/opencv-win/2.4.10/opencv-2.4.10.exe'

Get-ChocolateyWebFile $packageName $downloadedFile $url

Get-ChocolateyUnzip $downloadedFile $toolsDir '' $packageName

function Create-IgnoreFile($exeName) {
    $ignoreFile = "$exeName.ignore"
    set-content -Path ($ignoreFile) -Value ($null)
}

try {
    Create-IgnoreFile $downloadedFile

    # Ignore all but one set of binaries.
    $unusedBinaries = Get-ChildItem -Path "$toolsDir\*.exe" -Recurse -File | Where-Object {!($_.DirectoryName -like "*build\$binaryKeepers\bin*")} | Select-Object -Property FullName
    foreach ($exeFile in $unusedBinaries) {
        Create-IgnoreFile $exeFile.FullName
    }
} catch {
  throw $_.Exception
}
