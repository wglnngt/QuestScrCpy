$strCurDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
#Write-Host "Current work directory is : $strCurDir"
$ENV:PATH = "$strCurDir;${ENV:PATH}"
pushd $strCurDir

function pause() {
	Write-Host "Press any key to contiue..."
	[Console]::ReadKey() | Out-Null
}

function StartAudioStream() {
	$strInstAPP = adb shell "pm list packages -3 | grep com.rom1v.sndcpy"
	if ("$strInstAPP" -eq "") {
		Write-Host "sndcpy app was not installed, will installing now.`n"

		$strInstRet = adb install -t -r -g sndcpy.apk
		if ($strInstRet.IndexOf("Success") -eq -1) {
			Write-Host "Uninstalling existing version first..."
			adb uninstall com.rom1v.sndcpy
			adb install -t -g sndcpy.apk
		}
	} else {
		Write-Host "Detected sndcpy app be installed, now check status:`n"
	}

	$strProcRet = adb shell "ps -A|grep sndcpy"
	if ("$strProcRet" -eq "") {
		Write-Host "Audio listener is not running...`n"
	} else {
		Write-Host "Audio listener already running..."
		Write-Host "Now force stop it, and restart sndcpy again...`n"
		adb shell am force-stop com.rom1v.sndcpy
	}

	adb shell appops set com.rom1v.sndcpy PROJECT_MEDIA allow
	adb forward --remove-all
	adb forward tcp:28200 localabstract:sndcpy
	adb shell am start com.rom1v.sndcpy/.MainActivity

	#ffplay -hide_banner -fflags nobuffer -f s16le -ar 48k -ac 2 -sync ext -nodisp -autoexit -i tcp://localhost:28200
}

# Enable wifi mode via SideQuest.
# And the flow after this will be worked.

Write-Host "Step 1. Connect the headset via usb cable."
Write-Host "Step 2. Enable computer to access files on headset."
Write-Host "Step 3. Enable debug mode whith usb cable, if dialog showed."
Write-Host "`n`n"

Write-Host "When every thing is done. Press any key to go on."
pause

Write-Host "`n`n"
Write-Host "Step 4. Specify the stream type, 0 for USB and 1 for WIFI :"
$nSType = Read-Host "Your choice for stream [0:USB|1:WIFI]"
$strConnectDevice = ""
if ([int]$nSType -eq 1) {
	#adb shell setprop service.adb.tcp.port 5555
	#adb -L tcp:5037 fork-server server --reply-fd 600
	Write-Host "`tStep 4.1 Enable Wifi mode."
	adb tcpip 5555
	Write-Host "`tStep 4.2 Disconnect exist connection for WIFI connection."
	#adb disconnect
	Write-Host "`tStep 4.3 Input the headset's ip address."
	$strSvrIP = Read-Host "Please input the HMD's ip address here"
	$strConnectDevice = "${strSvrIP}:5555"
	Write-Host "`tStep 4.4 Connect the headset."
	adb connect ${strConnectDevice}
} else {
	Write-Host "Step 4.1 Get connected device name."
	$strDev = adb devices | findstr /i "device`$" | %{ $_ -replace "[ \t].*`$", "" }
	$strConnectDevice = "${strDev}"
}
Write-Host "`tYour connecting device is : ${strConnectDevice}"

Write-Host "`n`n"
Write-Host "Step 5. Now, please enable the debug module on your headset, if dialog showed."
pause

Write-Host "`n`n"
Write-Host "Step 6. Start the scrcpy server and connect the stream via scrcpy application on computer."
Write-Host "`tAuto push file to device and run the server, so run the scrcpy client only."

Write-Host "`n`n"
Write-Host "Step 7. Specify the stream device,`n`t0 for Oculus Quest2 and `n`t1 for PICO Neo X :"
$nSType = Read-Host "Your choice for device [0:Quest|1:PICO4|2:PICO3|3:Quest3]"

$oShell = New-Object -com WScript.Shell
$oLink = $oShell.CreateShortcut("$env:temp\scrcpy.lnk")
$oLink.TargetPath = "$PWD\scrcpy.exe"
if ([int]$nSType -eq 0) {
	# Size for Oculus Quest 2 : 3664x1920
	#Start -NoNewWindow scrcpy -args "--crop 1600:900:2017:510 -b 80M --max-fps 0 --max-size 0 -n --window-title QuestViewer -s ${strConnectDevice}"
	$oLink.IconLocation = "$PWD\quest.ico"
	$oLink.WorkingDirectory = "$PWD"
	$oLink.Arguments = "--crop 1600:900:2017:510 -n --window-title QuestViewer -s ${strConnectDevice}"
	$oLink.Save()
} elseif ([int]$nSType -eq 1) {
	# The region of pico4 view is : 4320x2160
	$oLink.IconLocation = "$PWD\neo.ico"
	$oLink.WorkingDirectory = "$PWD"
	$oLink.Arguments = "--crop 1680:944:230:608 -n --window-title PicoViewer -s ${strConnectDevice}"
	$oLink.Save()
} elseif ([int]$nSType -eq 2)  {
	# The region of pico3 view is : 3664x1920
	$oLink.IconLocation = "$PWD\neo.ico"
	$oLink.WorkingDirectory = "$PWD"
	$oLink.Arguments = "--crop 1016:1416:520:210 -n --window-title PicoViewer -s ${strConnectDevice}"
	$oLink.Save()
} elseif ([int]$nSType -eq 3)  {
	# The region of Quest3 view is : 4128x2208
	$oLink.IconLocation = "$PWD\quest.ico"
	$oLink.WorkingDirectory = "$PWD"
	$oLink.Arguments = "--crop 1826:1026:137:603 -n --window-title PicoViewer -s ${strConnectDevice}"
	$oLink.Save()
}
Start -NoNewWindow cmd -args "/c start /b $env:temp\scrcpy.lnk"

#Start -NoNewWindow sndcpy.bat
#StartAudioStream

# Size for customize device
#Start -NoNewWindow scrcpy -args "--window-title DeviceViewer -s ${strConnectDevice}"
#pause
