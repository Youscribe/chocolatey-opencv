#NOTE: Please remove any commented lines to tidy up prior to releasing the package, including this one

$packageName = 'OpenCV' # arbitrary name for the package, used in messages
$version = "2.4.11"
$binRoot = "$env:systemdrive\"
$installDir = Join-Path $binRoot 'OpenCV2411'
$url = 'http://downloads.sourceforge.net/project/opencvlibrary/opencv-win/${version}/opencv-${version}.exe'
$url64 = $url # 64bit URL here or just use the same as $url
$validExitCodes = @(0) #please insert other valid exit codes here, exit codes for ms http://msdn.microsoft.com/en-us/library/aa368542(VS.85).aspx

try { #error handling is only necessary if you need to do anything in addition to/instead of the main helpers
	write-host "Chocolatey is installing OpenCV to $installDir"
	write-host "Please wait..."

	$tempDir = "$env:TEMP\chocolatey\opencv"
	if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
	$tempFile = Join-Path $tempDir "opencv.exe"
	
	Get-ChocolateyWebFile 'OpenCV' "$tempFile" "$url"
	
	write-host "Extracting the contents of $tempFile to $installDir"
	
	Start-Process "7za" -ArgumentList "x -o`"$installDir`" -y `"$tempFile`"" -Wait
#	Install-ChocolateyPath "$installDir\opencv\build\x86\vc10\bin" 'User'
	
	if (Test-Path $tempFile){
		Remove-Item $tempFile
	}
  #$processor = Get-WmiObject Win32_Processor
  #$is64bit = $processor.AddressWidth -eq 64

  
  # the following is all part of error handling
  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw 
}