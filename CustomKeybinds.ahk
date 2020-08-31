#SingleInstance, force
#MaxHotkeysPerInterval 200
#InstallKeybdHook
#InstallMouseHook
; scripted by Billy Yu
; Current version 2.0
;	- 
; Version History:
; 1.1:
;	- Added usabiliy with HP ZBook X360 G5 without an external keyboard (Make sure num lock is off)
;	- Added extra mouse button (ThumbButton1) as a modifier
; 1.0: first
; ----- VK/Scan Codes ------
; VK | SC | Key 
; 60  052	Numpad0/NumpadIns
; 61  04F	Numpad1/NumpadEnd
; 62  050	Numpad2/NumpadDown
; 63  051	Numpad3/NumpadPgDn
; 64  04B   Numpad4/NumpadLeft
; 65  04C   Numpad5/NumpadClear
; 66  04D   Numpad6/NumpadRight
; 67  047   Numpad7/NumpadHome
; 68  048   Numpad8/NumpadUp
; 69  049   Numpad9/NumpadPgUp


; Build list of "End Keys" for Input command
EXTRA_KEY_LIST := "{Escape}"	; DO NOT REMOVE! - Used to quit binding
; Standard non-printables
EXTRA_KEY_LIST .= "{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}"
EXTRA_KEY_LIST .= "{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BackSpace}{Pause}"
; Numpad - Numlock ON
EXTRA_KEY_LIST .= "{Numpad0}{Numpad1}{Numpad2}{Numpad3}{Numpad4}{Numpad5}{Numpad6}{Numpad7}{Numpad8}{Numpad9}{NumpadDot}{NumpadMult}{NumpadAdd}{NumpadSub}"
; Numpad - Numlock OFF
EXTRA_KEY_LIST .= "{NumpadIns}{NumpadEnd}{NumpadDown}{NumpadPgDn}{NumpadLeft}{NumpadClear}{NumpadRight}{NumpadHome}{NumpadUp}{NumpadPgUp}{NumpadDel}"
; Numpad - Common
EXTRA_KEY_LIST .= "{NumpadMult}{NumpadAdd}{NumpadSub}{NumpadDiv}{NumpadEnter}"
; Stuff we may or may not want to trap
;EXTRA_KEY_LIST .= "{Numlock}"
EXTRA_KEY_LIST .= "{Capslock}"
;EXTRA_KEY_LIST .= "{PrintScreen}"
; Browser keys
EXTRA_KEY_LIST .= "{Browser_Back}{Browser_Forward}{Browser_Refresh}{Browser_Stop}{Browser_Search}{Browser_Favorites}{Browser_Home}"
; Media keys
EXTRA_KEY_LIST .= "{Volume_Mute}{Volume_Down}{Volume_Up}{Media_Next}{Media_Prev}{Media_Stop}{Media_Play_Pause}"
; App Keys
EXTRA_KEY_LIST .= "{Launch_Mail}{Launch_Media}{Launch_App1}{Launch_App2}"

; BindMode vars
HKLastHotkey := 0			; Time that Escape was pressed to exit key binding. Used to determine if Escape is held (Clear binding)
DefaultHKObject := {hk: ""}

; Misc vars
DisplayVar := ["Shortcut1", "Shortcut2", "Shortcut3", "Shortcut4", "Shortcut5", "Shortcut6", "Shortcut7", "Shortcut8", "Shortcut9", "Shortcut10"]
ININame := BuildIniName()
HotkeyList := []
NumHotkeys := 9

; Create the GUI, using a Loop feature that auto updates the GUI
;Gui, 1: Add, Text,, This demo allows you to bind up to %NumHotkeys% Hotkeys and test them.`nHotkeys are remembered between runs.
Menu, FileMenu, Add, Edit Keybinds, 2ndGui
Menu, FileMenu, Add, Reload Script, Reload
Menu, MyMenuBar, Add, &File, :FileMenu
Gui, 1:Menu, MyMenuBar
ypos := 10

Loop % NumHotkeys {
	displayType := DisplayVar[A_Index]
	Gui, 1: Add, Text, cBlack x5 y%ypos%, (LG)
	Gui, 1: Add, Edit, Disabled vHotkeyName%A_Index% w100 yp-1 xp+25 , None
	Gui, 1: Add, Text, cBlack xp+108, Numpad%A_Index% = %displayType%
	;Gui, 1: Add, Button, gBind vBind%A_Index% yp-1 xp+110, Set Hotkey
	;Gui, 1: Add, Button, gReset vReset%A_Index% xp+90, Reset Key
	;Gui, Add, Checkbox, vBlock%A_Index% gOptionChanged xp+30 yp
	ypos += 25
}

height := (NumHotkeys * 30) + 60
Gui, 1: Show, Center w400 h%height% x0 y0, Keybind Test

; Set GUI State
LoadSettings()

; Enable defined hotkeys
EnableHotkeys()

return ; Return after making GUI?

2ndGui:
	DisableHotkeys()
	ypos := 10
	; The GUI that allows editing of keybinds
	Loop % NumHotkeys {
		Gui, 2: Add, Edit, Disabled vHotkeyName%A_Index% w100 x5 y%ypos%, None
		Gui, 2: Add, Button, gBind vBind%A_Index% yp-1 xp+110, Set Hotkey
		Gui, 2: Add, Button, gReset vReset%A_Index% xp+90, Reset Key 
		ypos += 25
	}

	Gui, 2: Add, Button, gClose vClose xp+100 yp+50, Close
	height := (NumHotkeys * 30) + 60
	Gui, 2: Show, Center w400 h%height% x0 y0, Edit Keybinds

	LoadSettings()
	
	return

MenuHandler:
	return

Reload:
	Reload
	return

Close:
2GuiClose:
	Gui, 2: Destroy ; We cannot recreate the same gui. We must destroy or redisplay it.
	return

GuiClose:
	ExitApp
	return

; Test that bound hotkeys work
DoHotkey1:
	;soundbeep
	msgbox You pressed Hotkey 1.
	return
DoHotkey2:
	;soundbeep
	msgbox You pressed Hotkey 2.
	return
DoHotkey3:
	;soundbeep
	msgbox You pressed Hotkey 3.
	return
DoHotkey4:
	;soundbeep
	msgbox You pressed Hotkey 4.
	return
DoHotkey5:
	;soundbeep
	msgbox You pressed Hotkey 5.
	return
DoHotkey6:
	;soundbeep
	msgbox You pressed Hotkey 6.
	return
DoHotkey7:
	;soundbeep
	msgbox You pressed Hotkey 7.
	return
DoHotkey8:
	;soundbeep
	msgbox You pressed Hotkey 8.
	return
DoHotkey9:
	;soundbeep
	msgbox You pressed Hotkey 9.
	return
DoHotkey10:
	;soundbeep
	msgbox You pressed Hotkey 10.
	return
DoHotkey11:
	;soundbeep
	msgbox You pressed Hotkey 11.
	return

; Something changed - rebuild
OptionChanged:
	OptionChanged()
	return

OptionChanged(){
	global HotkeyList

	Gui, Submit, NoHide
	; Disable Hotkeys
	DisableHotkeys()


	EnableHotkeys()

	SaveSettings()
}

; Detects a pressed key combination
Bind:
	Bind(substr(A_GuiControl,5))
	return

Bind(ctrlnum){
	global BindMode
	global EXTRA_KEY_LIST
	global HKLastHotkey
	global HotkeyList

	; init vars

	; Disable existing hotkeys
	DisableHotkeys()

	; Show the prompt
	prompt := "Please press the desired key combination.`n`n"
	prompt .= "Supports most keyboard keys and all mouse buttons. Also Ctrl, Alt, Shift, Win as modifiers or individual keys.`n"
	prompt .= "Joystick buttons are also supported, but currently not with modifiers.`n"
	prompt .= "`nHit Escape to cancel."
	prompt .= "`nHold Escape to clear a binding."
	Gui, 3:Add, text, center, %prompt%
	Gui, 3:-Border +AlwaysOnTop
	Gui, 3:Show

	outhk := ""

	Input, detectedkey, L1, %EXTRA_KEY_LIST%


	; Hide prompt
	Gui, 3:Submit


	; Process results


	if (detectedkey){
		; Update the hotkey object
		outhk := BuildHotkeyString(detectedkey,HKControlType)
		tmp := {hk: outhk, type: HKControlType, status: 0}

		clash := 0
		Loop % HotkeyList.MaxIndex(){
			if (A_Index == ctrlnum){
				continue
			}
			if (StripPrefix(HotkeyList[A_Index].hk) == StripPrefix(tmp.hk)){
				clash := 1
			}
		}
		if (clash){
			msgbox You cannot bind the same hotkey to two different actions. Aborting...
		} else {
			HotkeyList[ctrlnum] := tmp
		}

		; Rebuild rest of hotkey object, save settings etc
		OptionChanged()
		; Write settings to INI file
		;SaveSettings()

		; Update the GUI control
		UpdateHotkeyControls()

		; Enable the hotkeys
		;EnableHotkeys()
	} else {
		; Escape was pressed - resotre original hotkey, if any
		EnableHotkeys()
	}
	return
}

Reset:
	DeleteHotKey(substr(A_GuiControl, 6))
	return

DeleteHotkey(hk){
	global HotkeyList
	global DefaultHKObject

	soundbeep
	DisableHotkeys()
	HotkeyList[hk] := DefaultHKObject

	OptionChanged()

	UpdateHotkeyControls()
	return
}

; Enables User-Defined Hotkeys
EnableHotkeys(){
	global HotkeyList
	Loop % HotkeyList.MaxIndex(){
		status := HotkeyList[A_Index].status
		hk := HotkeyList[A_Index].hk
		FileAppend hk: %hk%`n, *
		if (hk != "" && status == 0){
			prefix := BuildPrefix(HotkeyList[A_Index])
			;Msgbox % "ADDING: " prefix "," hk
			hotkey, %prefix%%hk%, DoHotkey%A_Index%, ON
			HotkeyList[A_Index].status := 1
		}
	}
}

; Disables User-Defined Hotkeys
DisableHotkeys(){
	global HotkeyList

	Loop % HotkeyList.MaxIndex(){
		status := HotkeyList[A_Index].status
		hk := HotkeyList[A_Index].hk
		if (hk != "" && status == 1){
			prefix := BuildPrefix(HotkeyList[A_Index])
			;Msgbox % "REMOVING: " prefix "," hk
			hotkey, %prefix%%hk%, DoHotkey%A_Index%, OFF
			;hotkey, %hk%, DoHotkey%A_Index%, OFF
			HotkeyList[A_Index].status := 0
		}
	}
}

; Builds the prefix for a given hotkey object
BuildPrefix(hk){
	prefix := "~"
	;if (!hk.block){
	;	prefix .= "~"
	;}
	return prefix
}

; Removes ~ * etc prefixes (But NOT modifiers!) from a hotkey object for comparison
StripPrefix(hk){
	Loop {
		chr := substr(hk,1,1)
		if (chr == "~" || chr == "*" || chr == "$"){
			hk := substr(hk,2)
		} else {
			break
		}
	}
	return hk
}

; Write settings to the INI
SaveSettings(){
	global ININame
	global NumHotkeys
	global HotkeyList

	Loop % HotkeyList.MaxIndex(){
		hk := HotkeyList[A_Index].hk
		;block := HotkeyList[A_Index].block

		;if (hk != ""){
			iniwrite, %hk%, %ININame%, Hotkeys, hk_%A_Index%_hk
			;iniwrite, %block%, %ININame%, Hotkeys, hk_%A_Index%_block
		;}
	}
	return
}

; Read settings from the INI
LoadSettings(){
	global ININame
	global NumHotkeys
	global HotkeyList
	global DefaultHKObject

	Loop % NumHotkeys {
		; Init array so all items exist
		HotkeyList[A_Index] := DefaultHKObject
		;FileAppend DEfault: %DefaultHKObject%`n, *
		IniRead, val, %ININame% , Hotkeys, hk_%A_Index%_hk,
		;FileAppend val: %val%`n, *
		if (val != "ERROR"){
			;IniRead, block, %ININame% , Hotkeys, hk_%A_Index%_block, 0
			;FileAppend enter`n,*
			HotkeyList[A_Index] := {hk: val, status: 0}
		}
	}
	UpdateHotkeyControls()
}

; Update the GUI controls with the hotkey names
UpdateHotkeyControls(){
	global HotkeyList

	Loop % HotkeyList.MaxIndex(){
		if (HotkeyList[A_Index].hk != ""){
			tmp := BuildHotkeyName(HotkeyList[A_Index].hk)
			GuiControl, 1: , HotkeyName%A_Index%, %tmp%
			GuiControl, 2: , HotkeyName%A_Index%, %tmp%
		} else {
			GuiControl, 1: , HotkeyName%A_Index%, None
			GuiControl, 2: , HotkeyName%A_Index%, None
		}
		;tmp := HotkeyList[A_Index].block
		;GuiControl,, Block%A_Index%, %tmp%
	}
}

; Builds an AHK String (eg "^c" for CTRL + C) from the last detected hotkey
BuildHotkeyString(str, type := 0){
	outhk := "XButton2 & "
	outhk .= str

	return outhk
}

; Builds a Human-Readable form of a Hotkey string (eg "^C" -> "CTRL + C")
BuildHotkeyName(hk){
	outstr := "ThumbButton1 + "
	stringupper, hk, hk
	tmp2 := substr(hk, 12)
	
	outstr .= tmp2

	return outstr
}

; Takes the start of the file name (before .ini or .exe and replaces it with .ini)
BuildIniName(){
	tmp := A_Scriptname
	Stringsplit, tmp, tmp,.
	ini_name := ""
	last := ""
	Loop, % tmp0
	{
		; build the string up to the last period (.)
		if (last != ""){
			if (ini_name != ""){
				ini_name := ini_name "."
			}
			ini_name := ini_name last
		}
		last := tmp%A_Index%
	}
	;this.ini_name := ini_name ".ini"
	return ini_name ".ini"

}

shortcut(x) {
	y := x + 1
	Send, .1%y%
	return
}

; -------Remaps--------

; -------Command presses-------
; Type Lane
Numpad1::
NumpadEnd::
	shortcut(1)
return

; Type Left-Bounded
Numpad2::
NumpadDown::
	shortcut(2)
return

; Type Right-Bounded
Numpad3::
NumpadPgDn::
	shortcut(3)
return

; Type Connection
Numpad4::
NumpadLeft::
	shortcut(4)
return

; Type Bidirectional
Numpad5::
NumpadClear::
	shortcut(5)
return

; Type Roundabout
Numpad6::
NumpadRight::
	shortcut(6)
return

; Type Guide
Numpad7::
NumpadHome::
	shortcut(7)
return