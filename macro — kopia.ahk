; made by /u/lutcikaur
; As always, test the logout before you run into hardcore.
; If you find some errors, the list is at the bottom. Search for the error code.
; GUI's in use : 1, 2, 3, 4

#NoEnv
#SingleInstance force

FileEncoding , UTF-8
SendMode Input
SetTitleMatchMode, 3ddasdasdasd
macroVersion := 131

If (A_AhkVersion <= "1.1.23")
{
	msgbox, You need AutoHotkey v1.1.23 or later to run this script. `n`nPlease go to http://ahkscript.org/download and download a recent version.
	ExitApp
}

IfNotExist %A_MyDocuments%\AutoHotKey
{
	FileCreateDir, %A_MyDocuments%\AutoHotKey
}

SetWorkingDir %A_MyDocuments%\AutoHotKey

elog := A_Now . " " . A_AhkVersion . " " . macroVersion "`n"
FileAppend, %elog% , error.txt, UTF-16

UrlDownloadToFile, http://lutbot.com/ahk/version.html, version.html
	if ErrorLevel
			error("ED06")

FileRead, newestVersion, version.html

if ( macroVersion < newestVersion ) {
	UrlDownloadToFile, http://lutbot.com/ahk/changelog.txt, changelog.txt
			if ErrorLevel
					error("ED08")
	Gui, 4:Add, Text,, Update Available.`nYoure running version %macroVersion%. The newest is version %newestVersion%`nI either messed something up in this version, or I added something new.`nCan I download it for you? It will only take a moment, and the script will automatically restart.
	FileRead, changelog, changelog.txt
	Gui, 4:Add, Edit, w600 h200 +ReadOnly, %changelog% 
	Gui, 4:Add, Button, section default grunUpdate, Update
	Gui, 4:Add, Button, ys gdontUpdate, Skip Update
	Gui, 4:Show
}

If !A_IsAdmin {
	Run *RunAs "%A_ScriptFullPath%"
	ExitApp
}

GetTable := DllCall("GetProcAddress", Ptr, DllCall("LoadLibrary", Str, "Iphlpapi.dll", "Ptr"), Astr, "GetExtendedTcpTable", "Ptr")
SetEntry := DllCall("GetProcAddress", Ptr, DllCall("LoadLibrary", Str, "Iphlpapi.dll", "Ptr"), Astr, "SetTcpEntry", "Ptr")
EnumProcesses := DllCall("GetProcAddress", Ptr, DllCall("LoadLibrary", Str, "Psapi.dll", "Ptr"), Astr, "EnumProcesses", "Ptr")
preloadPsapi := DllCall("LoadLibrary", "Str", "Psapi.dll", "Ptr")
OpenProcessToken := DllCall("GetProcAddress", Ptr, DllCall("LoadLibrary", Str, "Advapi32.dll", "Ptr"), Astr, "OpenProcessToken", "Ptr")
LookupPrivilegeValue := DllCall("GetProcAddress", Ptr, DllCall("LoadLibrary", Str, "Advapi32.dll", "Ptr"), Astr, "LookupPrivilegeValue", "Ptr")
AdjustTokenPrivileges := DllCall("GetProcAddress", Ptr, DllCall("LoadLibrary", Str, "Advapi32.dll", "Ptr"), Astr, "AdjustTokenPrivileges", "Ptr")

IfNotExist, Lib
{
	FileCreateDir, Lib
}

FileDelete, Lib\QDL.ahk
str := "#NoTrayIcon`nSetWorkingDir %A_MyDocuments%\AutoHotKey`nUrlDownloadToFile,%1%,%2%`nIfNotExist, %2%`n{`nFileAppend,ERROR,%2%`n}"
FileAppend, %str%, Lib\QDL.ahk

IfNotExist, cports.exe
{
UrlDownloadToFile, http://lutbot.com/ahk/cports.exe, cports.exe
	if ErrorLevel
			msgbox, We couldn't download cports.exe, this is used as a fallback to the normal logout method. The logout functionality may not work until this is resolved. Please download cports.exe from http://lutbot.com/ahk/cports.exe and place it in %A_MyDocuments%\AutoHotKey.
UrlDownloadToFile, http://lutbot.com/ahk/cports.chm, cports.chm
	if ErrorLevel
			error("ED03")
UrlDownloadToFile, http://lutbot.com/ahk/readme.txt, readme.txt
	if ErrorLevel
			error("ED04")
}

IfNotExist, settings.ini
{
	defaultIni := "[variables]`n"
	defaultIni .= "CharacterName=BTOneMonthLut`n"
	defaultIni .= "League=standard`n"
	defaultIni .= "PoeSteam=0`n"
	defaultIni .= "UpdateTimer=1000`n"
	defaultIni .= "XOffset=0`n"
	defaultIni .= "YOffset=0`n"
	defaultIni .= "MonitorWhispers=0`n"
	defaultIni .= "MonitorWhispersDelay=10000`n"
	defaultIni .= "LogFileLocation=ERROR PLEASE SELECT LOG FILE`n"
	defaultIni .= "OverlayToggle=0`n"
	defaultIni .= "SoundSelector=*-1`n"
	defaultIni .= "Beta=1`n"
	defaultIni .= "Diablo2=0`n"
	defaultIni .= "[whisperMessages]`n"
	defaultIni .= "wm1=One moment, I'm in a map.`n"
	defaultIni .= "wm2=Sorry, That item has already been sold.`n"
	defaultIni .= "wm3=Type a sentence here`n"
	defaultIni .= "wm4=Type a sentence here`n"
	defaultIni .= "wm5=Type a sentence here`n"
	defaultIni .= "[partyMessages]`n"
	defaultIni .= "pm1=Watch for corrupting blood!`n"
	defaultIni .= "pm2=Type a sentence here`n"
	defaultIni .= "pm3=Dangerous exile!`n"
	defaultIni .= "pm4=Minion Instability / Iceblood!`n"
	defaultIni .= "pm5=Type a sentence here`n"
	defaultIni .= "[hotkeys]`n"
	defaultIni .= "logout=```n"
	defaultIni .= "superLogout=F12`n"
	defaultIni .= "oos=F2`n"
	defaultIni .= "remaining=F3`n"
	defaultIni .= "itemLevel=F4`n"
	defaultIni .= "hideout=F5`n"
	defaultIni .= "invite=F6`n"
	defaultIni .= "toggleOverlay=F9`n"
	defaultIni .= "options=F10`n"
	defaultIni .= "wm1=^1`n"
	defaultIni .= "wm2=^2`n"
	defaultIni .= "wm3=^3`n"
	defaultIni .= "wm4=^4`n"
	defaultIni .= "wm5=^5`n"
	defaultIni .= "pm1=!1`n"
	defaultIni .= "pm2=!2`n"
	defaultIni .= "pm3=!3`n"
	defaultIni .= "pm4=!4`n"
	defaultIni .= "pm5=!5"

	FileAppend, %defaultIni%, settings.ini, UTF-16
}

getLeagueListing()

readFromFile()

current := 0
phase := 0
lastWhisperTimeRecieved := 0

;timers
updateTrackingTimer := 5000 ; 5 seconds
baseUpdateTrackingTimer := 300000 ; 5 minutes
overlayTimer := 0
baseOverlayTimer := sleepTime
updateTrackingTimerActive := true
overlayTimerActive := true
lastUpdated := 1
preloadCportsTimer := 0
basePreloadCportsTimer := 180000 ; 3 minutes
preloadCportsCall := "cports.exe /stext TEMP"

;Ranking Overlay
Gui, 1:+ToolWindow
Gui, 1:Font, s8
Gui, 1:Add, Text, x3 y2 vguiErr, Working
Gui, 1:Add, Text, x3 y17, Settings:F10
Gui, 1:Font, s14
Gui, 1:Add, Text, x67 y4 w120 vguiRank, Rank: N/A
Gui, 1:Add, Text, x175 y4 w55 vguiMovedRanks, N/A
Gui, 1:Font, s7
Gui, 1:Add, Text, x3 y32, Ranks, Class:
Gui, 1:Add, Text, x72 y32 w33 vguiClassRank, N/A
Gui, 1:Add, Text, x115 y32, Alive:
Gui, 1:Add, Text, x145 y32 w33 vguiAliveRank, N/A
Gui, 1:Add, Text, x3 y47, Exp Above :
Gui, 1:Add, Text, x3 y62, Exp Below :
Gui, 1:Add, Text, x66 y47 w66 vguiAbove1, N/A
Gui, 1:Add, Text, x135 y47 w66 vguiAbove2, N/A
Gui, 1:Add, Text, x66 y62 w66 vguiBelow1, N/A
Gui, 1:Add, Text, x135 y62 w66 vguiBelow2, N/A
Gui, 1:Font, s14

Gui, 1:Show, x0 y0 w225 h37, poeGUI
Gui, 1:-Caption +AlwaysOnTop +Disabled +E0x20 +LastFound
Winset,TransColor, 0xFFFFFF

;Menu
Gui, 2:Add, Text,, CharacterName:
Gui, 2:Add, Text,, Char's League:
Gui, 2:Add, Text,, Steam Client:
Gui, 2:Add, Text,, UpdateTimer(ms):
Gui, 2:Add, Text,, Overlay X Offset:
Gui, 2:Add, Text,, Overlay Y Offset:
Gui, 2:Add, Text,, Beta version:
Gui, 2:Add, Text,h34, D2 logout?:

Gui, 2:Add, Text,, Logout:
Gui, 2:Add, Text,, ForceLogout:
Gui, 2:Add, Text,, /Oos:
Gui, 2:Add, Text,, /Remaining :
Gui, 2:Add, Text,, /ItemLevel :
Gui, 2:Add, Text,, Travel to Hideout :
Gui, 2:Add, Text,, Invite Player :
Gui, 2:Add, Text,, Toggle Overlay Size:
Gui, 2:Add, Text,, Options (This GUI) :


Gui, 2:Add, Edit, vguiChar ym w100 h20, %charName%
Gui, 2:Add, DropDownList, vguiLeague w100, %leagueString%
;GuiControl, 2:ChooseString, guiLeague, %league%
Gui, 2:Add, Checkbox, vguiSteam w100 h20 Checked%steam%
Gui, 2:Add, Edit, vguiUpdate w100 h20, %sleepTime%
Gui, 2:Add, Edit, vguiXOffset w100 h20, %xOffset%
Gui, 2:Add, Edit, vguiYOffset w100 h20, %yOffset%
Gui, 2:Add, Checkbox, vguibeta h20 Checked%beta%
Gui, 2:Add, Checkbox, vguidiablo2 h20 Checked%diablo2%

Gui, 2:Add, Text, w100 h20, Hotkey:
Gui, 2:Add, Hotkey, w100 h20 vguihotkeyLogout , %hotkeyLogout%
Gui, 2:Add, Hotkey, w100 h20 vguihotkeySuperLogout , %hotkeySuperLogout%
Gui, 2:Add, Hotkey, w100 h20 vguihotkeyOos , %hotkeyOos%
Gui, 2:Add, Hotkey, w100 h20 vguihotkeyRemaining , %hotkeyRemaining%
Gui, 2:Add, Hotkey, w100 h20 vguihotkeyItemLevel , %hotkeyItemLevel%
Gui, 2:Add, Hotkey, w100 h20 vguihotkeyHideout , %hotkeyHideout%
Gui, 2:Add, Hotkey, w100 h20 vguihotkeyInvite , %hotkeyInvite%
Gui, 2:Add, Hotkey, w100 h20 vguihotkeyToggleOverlay , %hotkeyToggleOverlay%
Gui, 2:Add, Hotkey, w100 h20 vguihotkeyOptions , %hotkeyOptions%

Gui, 2:Add, Text, ym, Whisper Hotkey:
Gui, 2:Add, Hotkey, vguihotkeywm1 w100 h20 , %hotkeywm1%
Gui, 2:Add, Hotkey, vguihotkeywm2 w100 h20 , %hotkeywm2%
Gui, 2:Add, Hotkey, vguihotkeywm3 w100 h20 , %hotkeywm3%
Gui, 2:Add, Hotkey, vguihotkeywm4 w100 h20 , %hotkeywm4%
Gui, 2:Add, Hotkey, vguihotkeywm5 w100 h20 , %hotkeywm5%

Gui, 2:Add, Text,, Party Hotkey:
Gui, 2:Add, Hotkey, vguihotkeypm1 w100 h20 , %hotkeypm1%
Gui, 2:Add, Hotkey, vguihotkeypm2 w100 h20 , %hotkeypm2%
Gui, 2:Add, Hotkey, vguihotkeypm3 w100 h20 , %hotkeypm3%
Gui, 2:Add, Hotkey, vguihotkeypm4 w100 h20 , %hotkeypm4%
Gui, 2:Add, Hotkey, vguihotkeypm5 w100 h20 , %hotkeypm5%
Gui, 2:Add, Text,, Questions? Comments?

Gui, 2:Add, Text, ym w200, Whisper Message Text:
Gui, 2:Add, Edit, vguiwm1 w200 h20, %wm1%
Gui, 2:Add, Edit, vguiwm2 w200 h20, %wm2%
Gui, 2:Add, Edit, vguiwm3 w200 h20, %wm3%
Gui, 2:Add, Edit, vguiwm4 w200 h20, %wm4%
Gui, 2:Add, Edit, vguiwm5 w200 h20, %wm5%

Gui, 2:Add, Text, w200, Party Message Text:
Gui, 2:Add, Edit, vguipm1 w200 h20, %pm1%
Gui, 2:Add, Edit, vguipm2 w200 h20, %pm2%
Gui, 2:Add, Edit, vguipm3 w200 h20, %pm3%
Gui, 2:Add, Edit, vguipm4 w200 h20, %pm4%
Gui, 2:Add, Edit, vguipm5 w200 h20, %pm5%
Gui, 2:Add, Text,, @Lutcikaur ingame or /u/lutcikaur on reddit

Gui, 2:Add, Text,, Let me know if it errors

Gui, 2:Add, Text, xm section, Monitor Whispers:
Gui, 2:Add, Checkbox, ys vguiMonitorWhispers h20 Checked%monitorWhispers%
Gui, 2:Add, Text, ys, Check Delay (ms):
Gui, 2:Add, Edit, ys vguiMonitorWhispersDelay w100 h20, %monitorWhispersDelay%
Gui, 2:Add, Button, ys gchangelogGui, Changelog
Gui, 2:Add, Button, ys default gupdateHotkeys, Okay

Gui, 2:Add, Button, section xm gbrowseForLogFile , Browse for Log File
Gui, 2:Add, Text, ys, Whisper Notification Sound:
Gui, 2:Add, DropDownList, ys vguiSoundSelector w50, None|*-1|*16|*32|*48|*64
GuiControl, 2:ChooseString, guiSoundSelector, %soundSelector%
Gui, 2:Add, Button, ys gplaySound, TestPlay Sound
Gui, 2:Add, Text, w380 xs vguiLogFileLocation, %logFileLocation%

; some fucking initializers. Put these together later.
toggle--
toggleOverlay()

;start the main loop. Gotta be last
loopTimers()

getLeagueListing() {
	global
	;Get league listing
	SetTimer, loadLeague, 1000
	run "Lib\QDL.ahk" "http://api.exiletools.com/ladder?activeleagues=1" "leagues.json"
	return
	loadLeague:
	IfExist, leagues.json 
	{
		SetTimer, loadLeague, off
		FileRead, leagues, leagues.json
		JSON_obj_leagues := json_toobj(leagues)
		leagueString := JSON_obj_leagues[0]
		while JSON_obj_leagues[a_index] != "" 
		{
			leagueString .= "|" . JSON_obj_leagues[a_index]
		}
		leagueString .= "|SSF"
		GuiControl,2:, guiLeague, %leagueString%
		GuiControl,2:ChooseString, guiLeague, %league%
	}
	return
}

superLogoutCommand(){
superLogoutCommand:
	logoutCommand()
	return
}

logoutCommand(){
logoutCommand:
	logout()
	return
}

cportsLogout(){
	global cportsCommand, lastlogout
	start := A_TickCount
	ltime := lastlogout + 1000
	if ( ltime < A_TickCount ) {
		RunWait, %cportsCommand%
		lastlogout := A_TickCount
	}
	Sleep 10
	error("nb:" . A_TickCount - start)
	return
}

logout(){
	global executable, GetTable, SetEntry, EnumProcesses, OpenProcessToken, LookupPrivilegeValue, AdjustTokenPrivileges, loadedPsapi
	start := A_TickCount
	poePID := Object()
	s := 4096
	Process, Exist 
	h := DllCall("OpenProcess", "UInt", 0x0400, "Int", false, "UInt", ErrorLevel, "Ptr")

	DllCall(OpenProcessToken, "Ptr", h, "UInt", 32, "PtrP", t)
	VarSetCapacity(ti, 16, 0)
	NumPut(1, ti, 0, "UInt")

	DllCall(LookupPrivilegeValue, "Ptr", 0, "Str", "SeDebugPrivilege", "Int64P", luid)
	NumPut(luid, ti, 4, "Int64")
	NumPut(2, ti, 12, "UInt")

	r := DllCall(AdjustTokenPrivileges, "Ptr", t, "Int", false, "Ptr", &ti, "UInt", 0, "Ptr", 0, "Ptr", 0)
	DllCall("CloseHandle", "Ptr", t)
	DllCall("CloseHandle", "Ptr", h)

	s := VarSetCapacity(a, s)
	c := 0
	DllCall(EnumProcesses, "Ptr", &a, "UInt", s, "UIntP", r)
	Loop, % r // 4
	{
		id := NumGet(a, A_Index * 4, "UInt")

		h := DllCall("OpenProcess", "UInt", 0x0010 | 0x0400, "Int", false, "UInt", id, "Ptr")

		if !h
			continue
		VarSetCapacity(n, s, 0)
		e := DllCall("Psapi\GetModuleBaseName", "Ptr", h, "Ptr", 0, "Str", n, "UInt", A_IsUnicode ? s//2 : s)
		if !e 
			if e := DllCall("Psapi\GetProcessImageFileName", "Ptr", h, "Str", n, "UInt", A_IsUnicode ? s//2 : s)
				SplitPath n, n
		DllCall("CloseHandle", "Ptr", h)
		if (n && e)
			if (n == executable) {
				poePID.Insert(id)
			}
	}

	l := poePID.Length()
	if ( l = 0 ) {
		Process, wait, %executable%, 0.2
		if ( ErrorLevel > 0 ) {
			poePID.Insert(ErrorLevel)
		}
	}
	
	VarSetCapacity(dwSize, 4, 0) 
	result := DllCall(GetTable, UInt, &TcpTable, UInt, &dwSize, UInt, 0, UInt, 2, UInt, 5, UInt, 0) 
	VarSetCapacity(TcpTable, NumGet(dwSize), 0) 

	result := DllCall(GetTable, UInt, &TcpTable, UInt, &dwSize, UInt, 0, UInt, 2, UInt, 5, UInt, 0) 

	num := NumGet(&TcpTable,0,"UInt")

	IfEqual, num, 0
	{
		cportsLogout()
		error("ED11",num,l,executable)
		return
	}

	out := 0
	Loop %num%
	{
		cutby := a_index - 1
		cutby *= 24
		ownerPID := NumGet(&TcpTable,cutby+24,"UInt")
		for index, element in poePID {
			if ( ownerPID = element )
			{
				VarSetCapacity(newEntry, 20, 0) 
				NumPut(12,&newEntry,0,"UInt")
				NumPut(NumGet(&TcpTable,cutby+8,"UInt"),&newEntry,4,"UInt")
				NumPut(NumGet(&TcpTable,cutby+12,"UInt"),&newEntry,8,"UInt")
				NumPut(NumGet(&TcpTable,cutby+16,"UInt"),&newEntry,12,"UInt")
				NumPut(NumGet(&TcpTable,cutby+20,"UInt"),&newEntry,16,"UInt")
				result := DllCall(SetEntry, UInt, &newEntry)
				IfNotEqual, result, 0
				{
					cportsLogout()
					error("TCP" . result,out,result,l,executable)
					return
				}
				out++
			}
		}
	}
	if ( out = 0 ) {
		cportsLogout()
		error("ED10",out,l,executable)
	} else {
		error(l . ":" . A_TickCount - start,out,l,executable)
	}
	return
}

error(var,var2:="",var3:="",var4:="",var5:="",var6:="",var7:="") {
	GuiControl,1:, guiErr, %var%
	print := A_Now . "," . var . "," . var2 . "," . var3 . "," . var4 . "," . var5 . "," . var6 . "," . var7 . "`n"
	FileAppend, %print%, error.txt, UTF-16
	return
}

invite(){
inviteCommand:
	BlockInput On
	Send ^{Enter}{Home}{Delete}/invite {Enter}
	BlockInput Off
	return
}

oosCommand(){
oosCommand:
	BlockInput On
	SendInput, {enter}
	Sleep 2
	SendInput, {/}oos
	SendInput, {enter}
	BlockInput Off
	return
}

remaining(){
remainingCommand:
	BlockInput On
	SendInput, {enter}
	Sleep 2
	SendInput, {/}remaining
	SendInput, {enter}
	BlockInput Off
	return
}

itemlevel(){
itemLevelCommand:
	BlockInput On
	SendInput, {Enter}
	Sleep 2
	SendInput, {/}itemlevel
	SendInput, {Enter}
	Sleep 75
	BlockInput Off
	return
}

hideout(){
hideoutCommand:
	BlockInput On
	SendInput, {Enter}
	Sleep 2
	SendInput, {/}hideout
	SendInput, {Enter}
	BlockInput Off
	return
}

whisperCommand1:
	BlockInput On
	Sleep 2
	SendInput ^{Enter}
	SendInput %wm1%
	SendInput {Enter}
	BlockInput Off
	return
whisperCommand2:
	BlockInput On
	Sleep 2
	SendInput ^{Enter}
	SendInput %wm2%
	SendInput {Enter}
	BlockInput Off
	return
whisperCommand3:
	BlockInput On
	Sleep 2
	SendInput ^{Enter}
	SendInput %wm3%
	SendInput {Enter}
	BlockInput Off
	return
whisperCommand4:
	BlockInput On
	Sleep 2
	SendInput ^{Enter}
	SendInput %wm4%
	SendInput {Enter}
	BlockInput Off
	return
whisperCommand5:
	BlockInput On
	Sleep 2
	SendInput ^{Enter}
	SendInput %wm5%
	SendInput {Enter}
	BlockInput Off
	return
partyCommand1:
	BlockInput On
	Sleep 2
	SendInput {Enter}
	SendInput `%
	SendInput %pm1%
	SendInput {Enter}
	BlockInput Off
	return
partyCommand2:
	BlockInput On
	Sleep 2
	SendInput {Enter}
	SendInput `%
	SendInput %pm2%
	SendInput {Enter}
	BlockInput Off
	return
partyCommand3:
	BlockInput On
	Sleep 2
	SendInput {Enter}
	SendInput `%
	SendInput %pm3%
	SendInput {Enter}
	BlockInput Off
	return
partyCommand4:
	BlockInput On
	Sleep 2
	SendInput {Enter}
	SendInput `%
	SendInput %pm4%
	SendInput {Enter}
	BlockInput Off
	return
partyCommand5:
	BlockInput On
	Sleep 2
	SendInput {Enter}
	SendInput `%
	SendInput %pm5%
	SendInput {Enter}
	BlockInput Off
	return

browseForLogFile:
	FileSelectFile, logFileLocation,, , Navigate to C:\Program Files (x86)\Grinding Gear Games\Path of Exile\logs, Text Documents (*.txt; *.log)
	GuiControl,2:, guiLogFileLocation, %logFileLocation%
	return

changelogGui(){
changelogGui:
	FileRead, changelog, changelog.txt
	Gui, 3:Add, Edit, w600 h200 +ReadOnly, %changelog% 
	Gui, 3:Show
	return
}

playSound:
	Gui, 2:Submit, nohide
	SoundPlay, %guiSoundSelector%
	return

toggleOverlay(){
toggleOverlayCommand:
	global toggle
	toggle++
	if toggle > 1
		toggle := -1
	if toggle = -1
	{
		Gui, 1:Hide
	}
	if toggle = 0
	{
		Gui, 1:Show, h75 NA
	}
	if toggle = 1
	{
		Gui, 1:Show, h46 NA
	}
	return
}

preloadCports(){
	global preloadCportsTimer, basePreloadCportsTimer, preloadCportsCall
	Run, %preloadCportsCall%
	preloadCportsTimer := basePreloadCportsTimer
}

checkOverlay(){
	global overlayTimer, baseOverlayTimer, toggle, xOffset, yOffset
	if toggle != -1
	{
			IfWinActive Path of Exile
			{
				WinGetActiveStats,name,width,height,x,y
				width += x
				width += xOffset
				hh := y
				hh += yOffset
				if toggle = 2 
				{
					width /= 2
					width -= 295
					height /= 2
					height -= 325
					Gui, 5:Show,  y%height% x%width% NA
				} 
				if ( toggle = 1 ) || ( toggle = 0 )
				{
					width -= 231
					Gui, 1:Show,  y%hh% x%width% NA
				}
			} else {
				Gui, 1:Hide
				Gui, 5:Hide
			}
	}
	overlayTimer := baseOverlayTimer
	return
}

runUpdate(){
runUpdate:
	UrlDownloadToFile, http://lutbot.com/ahk/macro.ahk, %A_ScriptFullPath%
		if ErrorLevel
			error("ED07")
		else
			Run "%A_ScriptFullPath%"
	Sleep 5000 ;This shouldn't ever hit.
dontUpdate:
	Gui, 4:Destroy
	return	
}

checkForWhispers(){
	global logFileLocation, lastWhisperTimeRecieved, monitorWhispersTimer, monitorWhispersDelay, soundSelector
	FileRead, BIGFILE, %logFileLocation%
	StringGetPos, last25Location, BIGFILE,`n, R75
	StringTrimLeft, smallfile, BIGFILE, %last25Location%

	regexLocation := 1
	arrayCount := 0
	newStart := 0

	While regexLocation
	{
		regexLocation := RegExMatch( smallfile, "(\d\d\d\d.\d\d.\d\d \d\d:\d\d:\d\d)(?:.*)\[INFO Client \d+\] \@(.*)", regexString, regexLocation+1)
		if regexLocation != 0
		{
			time%arrayCount% := regexString1
			s%arrayCount% := regexString2
			arrayCount++
		}
	}


	loopCounter := 0
	lnum := arrayCount-1
	displayStart := arrayCount
	d = :::
	while loopCounter < arrayCount
	{
		if ( time%loopCounter% > lastWhisperTimeRecieved )
		{
			displayStart := loopCounter
			goto breakWhisperTimes
		}
		loopCounter++
	}
	breakWhisperTimes:
	if( lnum < 0)
		lnum := 0
	lastWhisperTimeRecieved := time%lnum%
	displayString := ""
	iterations := arrayCount - displayStart
	loopCounter := arrayCount

	while loopCounter > displayStart
	{
		loopCounter--
		displayString .= s%loopCounter% . "`n"
	}

	IfWinNotActive Path of Exile
		if iterations > 0
		{
			TrayTip, New Messages: `(%iterations%`), %displayString%
			SoundPlay, %soundSelector%
		}
	monitorWhispersTimer := monitorWhispersDelay
	return
}

loopTimers(){
	global
	Loop {
		if ( overlayTimerActive = true ) 
			overlayTimer -= sleepTime    
		if ( updateTrackingTimerActive = true )
			updateTrackingTimer -= sleepTime
		if ( monitorWhispers )
			monitorWhispersTimer -= sleepTime
		if ( !beta )
			preloadCportsTimer -= sleepTime

		if ( overlayTimer <= 0 ) && ( overlayTimerActive = true )
		{
			checkOverlay()
		}
					
		if ( updateTrackingTimer <= 0 ) && ( updateTrackingTimerActive = true )
		{
			IfWinExist, Path of Exile
				updateTracking()
			else
				updateTrackingTimer := 60000
		}

		if ( monitorWhispersTimer <= 0 ) && ( monitorWhispers )
		{
			IfWinExist, Path of Exile
				checkForWhispers()
		}

		if ( preloadCportsTimer <= 0 )
		{
			IfWinExist, Path of Exile
				preloadCports()
			else
				preloadCportsTimer := basePreloadCportsTimer
		}


		Sleep sleepTime  
	}
	return
}

updateTracking(){
	global charName, league, updateTrackingTimer, baseUpdateTrackingTimer, lastUpdated
	updateTrackingTimer := baseUpdateTrackingTimer ; Wait the base time
	rank := "No Rank"

	if ( league == "SSF" ) {
		url := "http://ssf.poeladder.com/players/" . charName . ""
		SetTimer, loadSSF, 1000
		FileDelete, ladder.json
		run "Lib\QDL.ahk" %url% "ladder.json"
		return
		loadSSF:
		IfExist, ladder.json 
		{
			SetTimer, loadSSF, off
			FileRead, ladderString, ladder.json
			JSON_obj := json_toobj(ladderString)
			r := "rank"
			rank := JSON_obj[r]
			if ( rank == "" ) 
			{
				rank := "Rank: N/A"
			} else {
				rank := "Rank: " . rank
			}
			GuiControl,1:, guiRank, %rank%
			GuiControl,1:, guiMovedRanks
			return
		} else {
			return
		}
		
	} else {
		url := "http://exiletools.com/api/ladder?league=" . league . "&char=" . charName . ""
		url2 := "http://api.exiletools.com/class-rank?league=" . league . "&char=" . charName . "&format=json"

		SetTimer, loadLadder, 1000
		FileDelete, ladder.jsonFileDelete, classLadder.json
		run "Lib\QDL.ahk" %url% "ladder.json"
		run "Lib\QDL.ahk" %url2% "classLadder.json"
		return
		loadLadder:
		IfExist, ladder.json 
		{
			IfExist, classLadder.json
			{
				SetTimer, loadLadder, off
				FileRead, ladderString, ladder.json
				JSON_obj := json_toobj(ladderString)

				For key, value in JSON_obj
					combined := key
				updated := JSON_obj[combined].updated
				if ( updated = lastUpdated )
				{
					updateTrackingTimer := 60000 ; Wait one minute to check again
					return
				}
				lastUpdated := updated
				rank := JSON_obj[combined].rank
				if ( !rank ) {
					rank := "Min Lv:"
					FileDelete, league.json
					url := "http://exiletools.com/api/ladder?league=" . league . "&status=1"
					SetTimer, loadMin, 1000
					run "Lib\QDL.ahk" %url% "league.json"
					return
					loadMin:
					IfExist, league.json 
					{
						SetTimer, loadMin, off
						FileRead, leagueString, league.json
						leagueObj := json_toobj(leagueString)
						movedRanks := leagueObj[league].toGetOnLadder.level
						above1 = N/A
						above2 = N/A
						below1 = N/A
						below2 = N/A
						GuiControl,1:,guiAbove1, %above1%
						GuiControl,1:,guiAbove2, %above2%
						GuiControl,1:,guiBelow1, %below1%
						GuiControl,1:,guiBelow2, %below2%

						GuiControl,1:, guiRank, %rank%
						GuiControl,1:, guiMovedRanks, %movedRanks%
						return
					} else {
						return
					}
				} else {
					r2 := 0
					FileRead, classLadderString, classLadder.json
					ClassLadderJSON := json_toobj(classLadderString)
					for k, v in ClassLadderJSON {
						for k2, v2 in ClassLadderJSON[k] {
							if ( k2 = "total" ) {
								r2 = %v2%
							}
						}
					}
					movedRanks := JSON_obj[combined].movedRanks
					above1 := JSON_obj[combined].xp_to_rank_above[rank-1]
					above1 := RegExReplace(above1, "(\d)(?=(?:\d{3})+(?:\.|$))", "$1,")
					above2 := JSON_obj[combined].xp_to_rank_above[rank-2]
					above2 := RegExReplace(above2, "(\d)(?=(?:\d{3})+(?:\.|$))", "$1,")
					below1 := JSON_obj[combined].xp_to_rank_below[rank+1]
					below1 := RegExReplace(below1, "(\d)(?=(?:\d{3})+(?:\.|$))", "$1,")
					below2 := JSON_obj[combined].xp_to_rank_below[rank+2]
					below2 := RegExReplace(below2, "(\d)(?=(?:\d{3})+(?:\.|$))", "$1,")
					aliveRank := JSON_obj[combined].aliveRank
					rank := "Rank: " . rank
					if ( movedRanks < 0 ) {
						Gui, 1:Font, cRed
						GuiControl, 1:Font, guiMovedRanks
					}
					if ( movedRanks > 0 ) {
						Gui, 1:Font, cGreen
						GuiControl, 1:Font, guiMovedRanks
					}
					GuiControl,1:,guiAbove1, %above1%
					GuiControl,1:,guiAbove2, %above2%
					GuiControl,1:,guiBelow1, %below1%
					GuiControl,1:,guiBelow2, %below2%

					GuiControl,1:, guiRank, %rank%
					GuiControl,1:, guiMovedRanks, %movedRanks%
					GuiControl,1:, guiAliveRank, %aliveRank%
					GuiControl,1:, guiClassRank, %r2%
				}
				return
			} else {
			return
			}
		} else {
			return
		}
	}
	return
}

hotkeys(){
optionsCommand:
	global
	Gui, 2:Show,, Macro Settings Version %macroVersion% :: AHK Version %A_AhkVersion%
	return
}

submit(){  
updateHotkeys:
	global
	Gui, 2:Submit 
	updsettings := "[variables]`n"
	updsettings .= "CharacterName=" . guiChar . "`n"
	updsettings .= "League=" . guiLeague . "`n"
	updsettings .= "PoeSteam=" . guiSteam . "`n"
	updsettings .= "UpdateTimer=" . guiUpdate . "`n"
	updsettings .= "XOffset=" . guiXOffset . "`n"
	updsettings .= "YOffset=" . guiYOffset . "`n"
	updsettings .= "MonitorWhispers=" . guiMonitorWhispers . "`n"
	updsettings .= "MonitorWhispersDelay=" . guiMonitorWhispersDelay . "`n"
	updsettings .= "LogFileLocation=" . logFileLocation . "`n"
	updsettings .= "OverlayToggle=" . toggle . "`n"
	updsettings .= "SoundSelector=" . guiSoundSelector . "`n"
	updsettings .= "Beta=" . guibeta . "`n"
	updsettings .= "Diablo2=" . guidiablo2 . "`n"
	updsettings .= "[whisperMessages]`n"
	updsettings .= "wm1=" . guiwm1 . "`n"
	updsettings .= "wm2=" . guiwm2 . "`n"
	updsettings .= "wm3=" . guiwm3 . "`n"
	updsettings .= "wm4=" . guiwm4 . "`n"
	updsettings .= "wm5=" . guiwm5 . "`n"
	updsettings .= "[partyMessages]`n"
	updsettings .= "pm1=" . guipm1 . "`n"
	updsettings .= "pm2=" . guipm2 . "`n"
	updsettings .= "pm3=" . guipm3 . "`n"
	updsettings .= "pm4=" . guipm4 . "`n"
	updsettings .= "pm5=" . guipm5 . "`n"
	updsettings .= "[hotkeys]`n"
	updsettings .= "logout=" . guihotkeyLogout . "`n"
	updsettings .= "superLogout=" . guihotkeySuperLogout . "`n"
	updsettings .= "oos=" . guihotkeyOos . "`n"
	updsettings .= "remaining=" . guihotkeyRemaining . "`n"
	updsettings .= "itemLevel=" . guihotkeyItemLevel . "`n"
	updsettings .= "hideout=" . guihotkeyHideout . "`n"
	updsettings .= "invite=" . guihotkeyInvite . "`n"
	updsettings .= "toggleOverlay=" . guihotkeyToggleOverlay . "`n"
	updsettings .= "options=" . guihotkeyOptions . "`n"
	updsettings .= "wm1=" . guihotkeywm1 . "`n"
	updsettings .= "wm2=" . guihotkeywm2 . "`n"
	updsettings .= "wm3=" . guihotkeywm3 . "`n"
	updsettings .= "wm4=" . guihotkeywm4 . "`n"
	updsettings .= "wm5=" . guihotkeywm5 . "`n"
	updsettings .= "pm1=" . guihotkeypm1 . "`n"
	updsettings .= "pm2=" . guihotkeypm2 . "`n"
	updsettings .= "pm3=" . guihotkeypm3 . "`n"
	updsettings .= "pm4=" . guihotkeypm4 . "`n"
	updsettings .= "pm5=" . guihotkeypm5

	FileDelete settings.ini
	FileAppend, %updsettings%, settings.ini, UTF-16

	readFromFile()

	return    
}

updateFiles(){
	
}

readFromFile(){
	global
	;reset hotkeys ughh.
	Hotkey, IfWinActive, Path of Exile
	If hotkeyLogout
		Hotkey,% hotkeyLogout, logoutCommand, Off
	If hotkeyOos
		Hotkey,% hotkeyOos, oosCommand, Off
	If hotkeyRemaining
		Hotkey,% hotkeyRemaining, remainingCommand, Off
	If hotkeyItemLevel
		Hotkey,% hotkeyItemLevel, itemLevelCommand, Off
	If hotkeyHideout
		Hotkey,% hotkeyHideout, hideoutCommand, Off
	If hotkeyInvite
		Hotkey,% hotkeyInvite, inviteCommand, Off
	If hotkeyToggleOverlay
		Hotkey,% hotkeyToggleOverlay, toggleOverlayCommand, Off
	If hotkeywm1
		Hotkey,% hotkeywm1, whisperCommand1, Off
	If hotkeywm2
		Hotkey,% hotkeywm2, whisperCommand1, Off
	If hotkeywm3
		Hotkey,% hotkeywm3, whisperCommand1, Off
	If hotkeywm4
		Hotkey,% hotkeywm4, whisperCommand1, Off
	If hotkeywm5
		Hotkey,% hotkeywm5, whisperCommand1, Off
	If hotkeypm1
		Hotkey,% hotkeypm1, partyCommand1, Off
	If hotkeypm2
		Hotkey,% hotkeypm2, partyCommand2, Off
	If hotkeypm3
		Hotkey,% hotkeypm3, partyCommand3, Off
	If hotkeypm4
		Hotkey,% hotkeypm4, partyCommand4, Off
	If hotkeypm5
		Hotkey,% hotkeypm5, partyCommand5, Off

	Hotkey, IfWinActive
	If hotkeyOptions
		Hotkey,% hotkeyOptions, optionsCommand, Off
	If hotkeySuperLogout
		Hotkey,% hotkeySuperLogout, superLogoutCommand, Off
	Hotkey, IfWinActive, Path of Exile

	; variables
	IniRead, charName, settings.ini, variables, CharacterName
	IniRead, league, settings.ini, variables, League
	IniRead, steam, settings.ini, variables, PoeSteam
	IniRead, sleepTime, settings.ini, variables, UpdateTimer
	IniRead, xOffset, settings.ini, variables, XOffset
	IniRead, yOffset, settings.ini, variables, YOffset
	IniRead, monitorWhispers, settings.ini, variables, MonitorWhispers
	IniRead, monitorWhispersDelay, settings.ini, variables, MonitorWhispersDelay
	IniRead, logFileLocation, settings.ini, variables, LogFileLocation
	IniRead, toggle, settings.ini, variables, OverlayToggle
	IniRead, soundSelector, settings.ini, variables, SoundSelector
	IniRead, beta, settings.ini, variables, Beta
	IniRead, diablo2, settings.ini, variables, Diablo2
	; whisper messages
	IniRead, wm1, settings.ini, whisperMessages, wm1
	IniRead, wm2, settings.ini, whisperMessages, wm2
	IniRead, wm3, settings.ini, whisperMessages, wm3
	IniRead, wm4, settings.ini, whisperMessages, wm4
	IniRead, wm5, settings.ini, whisperMessages, wm5
	;party messages
	IniRead, pm1, settings.ini, partyMessages, pm1
	IniRead, pm2, settings.ini, partyMessages, pm2
	IniRead, pm3, settings.ini, partyMessages, pm3
	IniRead, pm4, settings.ini, partyMessages, pm4
	IniRead, pm5, settings.ini, partyMessages, pm5
	;hotkeys
	IniRead, hotkeyLogout, settings.ini, hotkeys, logout, %A_Space%
	IniRead, hotkeySuperLogout, settings.ini, hotkeys, superLogout, %A_Space%
	IniRead, hotkeyOos, settings.ini, hotkeys, oos, %A_Space%
	IniRead, hotkeyRemaining, settings.ini, hotkeys, remaining, %A_Space%
	IniRead, hotkeyItemLevel, settings.ini, hotkeys, itemLevel, %A_Space%
	IniRead, hotkeyHideout, settings.ini, hotkeys, hideout, %A_Space%
	IniRead, hotkeyInvite, settings.ini, hotkeys, invite, %A_Space%
	IniRead, hotkeyToggleOverlay, settings.ini, hotkeys, toggleOverlay, %A_Space%
	IniRead, hotkeyOptions, settings.ini, hotkeys, options, %A_Space%
	IniRead, hotkeywm1, settings.ini, hotkeys, wm1, %A_Space%
	IniRead, hotkeywm2, settings.ini, hotkeys, wm2, %A_Space%
	IniRead, hotkeywm3, settings.ini, hotkeys, wm3, %A_Space%
	IniRead, hotkeywm4, settings.ini, hotkeys, wm4, %A_Space%
	IniRead, hotkeywm5, settings.ini, hotkeys, wm5, %A_Space%
	IniRead, hotkeypm1, settings.ini, hotkeys, pm1, %A_Space%
	IniRead, hotkeypm2, settings.ini, hotkeys, pm2, %A_Space%
	IniRead, hotkeypm3, settings.ini, hotkeys, pm3, %A_Space%
	IniRead, hotkeypm4, settings.ini, hotkeys, pm4, %A_Space%
	IniRead, hotkeypm5, settings.ini, hotkeys, pm5, %A_Space%

	Hotkey, IfWinActive, Path of Exile
	If hotkeyLogout
		Hotkey,% hotkeyLogout, logoutCommand, On
	If hotkeyOos
		Hotkey,% hotkeyOos, oosCommand, On
	If hotkeyRemaining
		Hotkey,% hotkeyRemaining, remainingCommand, On
	If hotkeyItemLevel
		Hotkey,% hotkeyItemLevel, itemLevelCommand, On
	If hotkeyHideout
		Hotkey,% hotkeyHideout, hideoutCommand, On
	If hotkeyInvite
		Hotkey,% hotkeyInvite, inviteCommand, On
	If hotkeyToggleOverlay
		Hotkey,% hotkeyToggleOverlay, toggleOverlayCommand, On
	If hotkeywm1
		Hotkey,% hotkeywm1, whisperCommand1, On
	If hotkeywm2
		Hotkey,% hotkeywm2, whisperCommand2, On
	If hotkeywm3
		Hotkey,% hotkeywm3, whisperCommand3, On
	If hotkeywm4
		Hotkey,% hotkeywm4, whisperCommand4, On
	If hotkeywm5
		Hotkey,% hotkeywm5, whisperCommand5, On
	If hotkeypm1
		Hotkey,% hotkeypm1, partyCommand1, On
	If hotkeypm2
		Hotkey,% hotkeypm2, partyCommand2, On
	If hotkeypm3
		Hotkey,% hotkeypm3, partyCommand3, On
	If hotkeypm4
		Hotkey,% hotkeypm4, partyCommand4, On
	If hotkeypm5
		Hotkey,% hotkeypm5, partyCommand5, On

	Hotkey, IfWinActive
	If hotkeyOptions
		Hotkey,% hotkeyOptions, optionsCommand, On
	else {
		Hotkey,F10, optionsCommand, On
		msgbox You dont have some hotkeys set!`nPlease hit F10 to open up your config prompt and please configure your hotkeys (Path of Exile has to be in focus).`nThe way you configure hotkeys is now in the GUI (default F10). Otherwise, you didn't put a hotkey for the options menu. You need that silly.
	}
	If hotkeySuperLogout
		Hotkey,% hotkeySuperLogout, superLogoutCommand, On
	Hotkey, IfWinActive, Path of Exile

	; extra checks

	if monitorWhispers = ERROR
		monitorWhispers := 0
	if monitorWhispersDelay = ERROR
		monitorWhispersDelay := 10000
	if monitorWhispersDelay < 10000
		monitorWhispersDelay := 10000
	if beta = ERROR
		beta = 0
	if diablo2 = ERROR
		diablo2 = 0

	if ( steam ) {
		cportsCommand := "cports.exe /close * * * * PathOfExileSteam.exe"
		executable := "PathOfExileSteam.exe"
	} else {
		cportsCommand := "cports.exe /close * * * * PathOfExile.exe"
		executable := "PathOfExile.exe"
	}

	if ( diablo2 ) {
		cportsCommand := "cports.exe /close * * * * Game.exe"
		executable := "Game.exe"
	}

	updateTrackingTimer := 5000
	monitorWhispersTimer := monitorWhispersDelay
}

; ; ERROR LIST
; min lv = null : you typed in the league name wrong.
; ED01 : Error downloading rank from http://exiletools.com/ , their server might be unavailible.
; ED02 -> ED04 : Error downloading currports from my website. http://www.nirsoft.net/utils/cports.html holds the original file.
; ED05 : Error downloading ladder stats from http://exiletools.com/ , their server might be unavailible.
; ED06 : Error checking for new version.
; ED07 : Error downloading newest version of ahk script.
; ED08 : Error downloading newest changelog.
; ED09 : Error downloading list of active leagues
; ED10 : Logged out with cports No process
; ED11 : Logged out with cports TcpTable Failure


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; JSON -> AHK Obj parser by VxE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Copyright © 2013 VxE. All rights reserved.

; Uses a two-pass iterative approach to deserialize a json string
json_toobj( str ) {

		quot := """" ; firmcoded specifically for readability. Hardcode for (minor) performance gain
		ws := "`t`n`r " Chr(160) ; whitespace plus NBSP. This gets trimmed from the markup
		obj := {} ; dummy object
		objs := [] ; stack
		keys := [] ; stack
		isarrays := [] ; stack
		literals := [] ; queue
		y := nest := 0

; First pass swaps out literal strings so we can parse the markup easily
		StringGetPos, z, str, %quot% ; initial seek
		while !ErrorLevel
		{
				; Look for the non-literal quote that ends this string. Encode literal backslashes as '\u005C' because the
				; '\u..' entities are decoded last and that prevents literal backslashes from borking normal characters
				StringGetPos, x, str, %quot%,, % z + 1
				while !ErrorLevel
				{
						StringMid, key, str, z + 2, x - z - 1
						StringReplace, key, key, \\, \u005C, A
						If SubStr( key, 0 ) != "\"
								Break
						StringGetPos, x, str, %quot%,, % x + 1
				}
		;       StringReplace, str, str, %quot%%t%%quot%, %quot% ; this might corrupt the string
				str := ( z ? SubStr( str, 1, z ) : "" ) quot SubStr( str, x + 2 ) ; this won't

		; Decode entities
				StringReplace, key, key, \%quot%, %quot%, A
				StringReplace, key, key, \b, % Chr(08), A
				StringReplace, key, key, \t, % A_Tab, A
				StringReplace, key, key, \n, `n, A
				StringReplace, key, key, \f, % Chr(12), A
				StringReplace, key, key, \r, `r, A
				StringReplace, key, key, \/, /, A
				while y := InStr( key, "\u", 0, y + 1 )
						if ( A_IsUnicode || Abs( "0x" SubStr( key, y + 2, 4 ) ) < 0x100 )
								key := ( y = 1 ? "" : SubStr( key, 1, y - 1 ) ) Chr( "0x" SubStr( key, y + 2, 4 ) ) SubStr( key, y + 6 )

				literals.insert(key)

				StringGetPos, z, str, %quot%,, % z + 1 ; seek
		}

; Second pass parses the markup and builds the object iteratively, swapping placeholders as they are encountered
		key := isarray := 1

		; The outer loop splits the blob into paths at markers where nest level decreases
		Loop Parse, str, % "]}"
		{
				StringReplace, str, A_LoopField, [, [], A ; mark any array open-brackets

				; This inner loop splits the path into segments at markers that signal nest level increases
				Loop Parse, str, % "[{"
				{
						; The first segment might contain members that belong to the previous object
						; Otherwise, push the previous object and key to their stacks and start a new object
						if ( A_Index != 1 )
						{
								objs.insert( obj )
								isarrays.insert( isarray )
								keys.insert( key )
								obj := {}
								isarray := key := Asc( A_LoopField ) = 93
						}

						; arrrrays are made by pirates and they have index keys
						if ( isarray )
						{
								Loop Parse, A_LoopField, `,, % ws "]"
										if ( A_LoopField != "" )
												obj[key++] := A_LoopField = quot ? literals.remove(1) : A_LoopField
						}
						; otherwise, parse the segment as key/value pairs
						else
						{
								Loop Parse, A_LoopField, `,
										Loop Parse, A_LoopField, :, % ws
												if ( A_Index = 1 )
														key := A_LoopField = quot ? literals.remove(1) : A_LoopField
												else if ( A_Index = 2 && A_LoopField != "" )
														obj[key] := A_LoopField = quot ? literals.remove(1) : A_LoopField
						}
						nest += A_Index > 1
				} ; Loop Parse, str, % "[{"

				If !--nest
						Break

				; Insert the newly closed object into the one on top of the stack, then pop the stack
				pbj := obj
				obj := objs.remove()
				obj[key := keys.remove()] := pbj
				If ( isarray := isarrays.remove() )
						key++

		} ; Loop Parse, str, % "]}"

		Return obj
} ; json_toobj( str )