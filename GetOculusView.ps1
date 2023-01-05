$strCurDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
#Write-Host "Current work directory is : $strCurDir"
$ENV:PATH = "$strCurDir;${ENV:PATH}"
pushd $strCurDir

function pause() {
	Write-Host "Press any key to contiue..."
	[Console]::ReadKey() | Out-Null
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
	adb disconnect
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
$nSType = Read-Host "Your choice for device [0:Quest|1:PICO]"
if ([int]$nSType -eq 0) {
	# Size for Oculus Quest 2 : 3664x1920
	#Start -NoNewWindow scrcpy -args "--crop 1600:900:2017:510 -b 80M --max-fps 0 --max-size 0 -n --window-title QuestViewer -s ${strConnectDevice}"
	Start -NoNewWindow scrcpy -args "--crop 1600:900:2017:510 -n --window-title QuestViewer -s ${strConnectDevice}"
} else {
	# The region of pico view is : 4320x2160
	Start -NoNewWindow scrcpy -args "--crop 1680:944:230:608 -n --window-title PicoViewer -s ${strConnectDevice}"
}
Start -NoNewWindow sndcpy.bat

# Size for customize device
#Start -NoNewWindow scrcpy -args "--window-title DeviceViewer -s ${strConnectDevice}"
pause
