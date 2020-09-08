#SingleInstance, force
#NoEnv
#MaxHotkeysPerInterval 200
#InstallKeybdHook
#InstallMouseHook
; scripted by Billy Yu
; Current version 2.0
;	- Added features:
;		- Added the function to set two custom keybinds for shortcuts, with the ability to reset
;		- Added option for special custom keybind by also setting the shortcut
; 		- 
; Version History:
; 1.1:
;	- Added usability with HP ZBook X360 G5 without an external keyboard (Make sure num lock is off)
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
;--------- TO-DO ------------
; - Implement UI Switch to toggle for iter ; iter through types
; - Add content to help menu
; 	- Link to documentation
; - [DONE] Bug with dropdown list shortcuts not updating GUI.
; - holding shift + b down
; - [DONE] Enable secondary for microsoft mute
; 	- If secondary, combine for MSTEAMS. If only primary, solo for MSTEAMS
;----------------------------
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
EXTRA_KEY_LIST .= "{Tab}{Enter}{Backspace}"
;EXTRA_KEY_LIST .= "{PrintScreen}"
; Browser keys
;EXTRA_KEY_LIST .= "{Browser_Back}{Browser_Forward}{Browser_Refresh}{Browser_Stop}{Browser_Search}{Browser_Favorites}{Browser_Home}"
; Media keys
;EXTRA_KEY_LIST .= "{Volume_Mute}{Volume_Down}{Volume_Up}{Media_Next}{Media_Prev}{Media_Stop}{Media_Play_Pause}"
; App Keys
;EXTRA_KEY_LIST .= "{Launch_Mail}{Launch_Media}{Launch_App1}{Launch_App2}"

; BindMode vars
HKLastHotkey := 0 ; Time that Escape was pressed to exit key binding. Used to determine if Escape is held (Clear binding)
DefaultHKObject := {hkp: "", typep: "", hks: "", types: ""}

; Misc vars
Title := "Custom Keybinds"
DisplayVar := ["Shortcut1", "Shortcut2", "Shortcut3", "Shortcut4", "Shortcut5", "Shortcut6", "Shortcut7", "Shortcut8", "Shortcut9", "Shortcut10", "Shortcut11"]
DisplayDefault := ["i", "[", "j", "N/A"]
DisplayFN := ["J", "K", "L", "U", "I", "O", "7"]
ININame := BuildIniName()
HotkeyList := []
modCheck := 2
specialCheck := 0
NumHotkeys := 12
global typeCounter := 0

; Create the GUI, using a Loop feature that auto updates the GUI
general .= "Welcome to "
general .= title
general .= "!`n"
general .= "Press the shortcuts below to apply types or to select tool.`n"
general .= "If you do not have extra mouse buttons, check 'Laptop Only' box.` This will use Middle Mouse combo.`n"
general .= "To edit/setup shortcuts, go to File -> Edit Keybinds."
important .= "Please do not close this window for the script to work in the background!"
;general .= "General Info`n"
Menu, FileMenu, Add, Edit Keybinds, 2ndGui
Menu, FileMenu, Add, Reload Script, Reload
Menu, MyMenuBar, Add, &File, :FileMenu
Menu, MyMenuBar, Add, &Help, Help
Gui, 1: Menu, MyMenuBar
Gui, 1: Font, s9 normal, Segoe UI
Gui, 1: Add, Text, cBlack y5, %general%
Gui, 1: Font, s9 bold, Segoe UI
Gui, 1: Add, Text, cBlack x11 y65, %important%
Gui, 1: Font, s10 normal, Segoe UI
Gui, 1: Add, Text, cBlack yp+20 x60, Primary
Gui, 1: Add, Text, cBlack yp xp+125, Secondary
Gui, 1: Add, Radio, vModGroup gModCheck Group yp xp+150 , Middle
Gui, 1: Add, Radio, gModCheck yp xp+70 Checked , Thumb1
Gui, 1: Add, Radio, gModCheck yp xp+80 , Thumb2
;Gui, 1:+AlwaysOnTop
ypos := 105

Loop % NumHotkeys {
	if (A_Index != NumHotkeys) {
		displayType := DisplayVar[A_Index]
		if (A_Index >= 8) {
			displayShort := DisplayDefault[A_Index - 7]
			Gui, 1: Add, Text, cBlack x5 y%ypos%, (LG)
			Gui, 1: Font, s8, Segoe UI
			Gui, 1: Add, Edit, Disabled vHotkeyName1%A_Index% w110 yp-1 xp+30 , None
			Gui, 1: Font, s10, Segoe UI
			Gui, 1: Add, Text, cBlack y%ypos% xp+115, OR
			Gui, 1: Font, s8, Segoe UI
			Gui, 1: Add, Edit, Disabled vHotkeyName2%A_Index% w110 yp-1 xp+30, None
			Gui, 1: Font, s10 bold, Segoe UI
			Gui, 1: Add, Text, cBlack y%ypos% xp+115, %displayShort%
			Gui, 1: Font, s10 normal, Segoe UI
			if (A_Index == 11) {
				Gui, 1: Add, Text, cBlack y%ypos% xp+60, = %displayType%
			} else {
				Gui, 1: Add, Text, cBlack y%ypos% xp+13, = %displayType%
			}
		} else {
			displayF := DisplayFN[A_Index]
			Gui, 1: Add, Text, cBlack x5 y%ypos%, (LG)
			Gui, 1: Font, s8, Segoe UI
			Gui, 1: Add, Edit, Disabled vHotkeyName1%A_Index% w110 yp-1 xp+30 , None
			Gui, 1: Font, s10, Segoe UI
			Gui, 1: Add, Text, cBlack y%ypos% xp+115, OR
			Gui, 1: Font, s8, Segoe UI
			Gui, 1: Add, Edit, Disabled vHotkeyName2%A_Index% w110 yp-1 xp+30, None
			Gui, 1: Font, s10 bold, Segoe UI
			Gui, 1: Add, Text, cBlack y%ypos% xp+115, [FN + %displayF%] Numpad%A_Index%
			Gui, 1: Font, s10 normal, Segoe UI
			Gui, 1: Add, Text, cBlack y%ypos% xp+128, = %displayType%
		}
		
	} else {
		Gui, 1: Add, Text, cBlack x5 y%ypos%, (Special)
		Gui, 1: Font, s8, Segoe UI
		Gui, 1: Add, Edit, Disabled vHotkeyName1%A_Index% w80 yp-1 xp+60 , None
		Gui, 1: Font, s10, Segoe UI
		Gui, 1: Add, Text, cBlack y%ypos% xp+87, =/+
		Gui, 1: Font, s8, Segoe UI
		Gui, 1: Add, Edit, Disabled vHotkeyName2%A_Index% w80 yp-1 xp+28, None
		Gui, 1: Add, DropDownList, vSpecialChoice gSpecialChoice AltSubmit yp xp+100, Custom|MSTeam Mute
	}
	ypos += 25
}

height := (NumHotkeys * 30) + 60
Gui, 1: Show, Center w560 h%height% , %Title%

; Set GUI State
LoadSettings()

; Enable defined hotkeys
EnableHotkeys()

return ;

2ndGui:
	Gui, 1: +LastFound
	WinGetPos, xx, yy
	xx += 10
	yy += 10
	DisableHotkeys()
	editText .= "To edit your keybinds, click on 'Set Primary'.`n"
	editText .= "Click 'Set Secondary' if you would like a secondary keybind for the same shortcut.`n"
	editText .= "If you would like to reset the keybinds, click on 'Reset Key'"
	Gui, 2: Font, s8 bold, Segoe UI
	Gui, 2: Add, Text, cBlack y5, %editText%
	Gui, 2: Font, s10 normal, Segoe UI
	Gui, 2: Add, Text, cBlack yp+45 x185, Primary
	Gui, 2: Add, Text, cBlack yp xp+120, Secondary
	ypos := 70
	; The GUI that allows editing of keybinds
	Loop % NumHotkeys {
		if (A_Index != NumHotkeys) {
			displayType := DisplayVar[A_Index]
			Gui, 2: Font, s10, Segoe UI
			Gui, 2: Add, Text, cBlack x5 y%ypos%, (LG) %displayType%
			Gui, 2: Font, s8, Segoe UI
			Gui, 2: Add, Edit, Disabled vHotkeyName1%A_Index% w110 xp+155 y%ypos%, None
			Gui, 2: Add, Edit, Disabled vHotkeyName2%A_Index% w110 xp+130 yp-1, None
			Gui, 2: Font,, 
			Gui, 2: Add, Button, gBind1 vBind1%A_Index% yp-1 xp+110, Set Primary
			Gui, 2: Add, Button, gBind2 vBind2%A_Index% xp+70, Set Secondary 
			Gui, 2: Add, Button, gReset vReset%A_Index% xp+85, Reset Key
		} else {
			Gui, 2: Font, s10, Segoe UI
			Gui, 2: Add, Text, cBlack x5 y%ypos%, (Special)
			Gui, 2: Font, s8, Segoe UI
			Gui, 2: Add, Edit, Disabled vHotkeyName1%A_Index% w110 xp+155 y%ypos%, None
			Gui, 2: Font, s8, Segoe UI
			Gui, 2: Add, Edit, Disabled vHotkeyName2%A_Index% w110 xp+130 yp-1, None
			Gui, 2: Font,, 
			Gui, 2: Add, Button, gBind1 vBind1%A_Index% yp-1 xp+110, Set Primary
			Gui, 2: Add, Button, gBind2 vBind2%A_Index% xp+70, Set Secondary 
			Gui, 2: Add, Button, gReset vReset%A_Index% xp+85, Reset Key
		}
		ypos += 25
	}

	Gui, 2: Add, Button, gCloseEdit vCloseEdit xp+25 yp+35, Save
	height := (NumHotkeys * 30) + 60
	Gui, 2: Show, Center w650 h%height% x%xx% y%yy%, Edit Keybinds

	LoadSettings()
	
	return

MenuHandler:
	return

Reload:
	Reload
	return

Help:
	Gui, 1: +LastFound
	WinGetPos, xxx, yyy
	xxx += 100
	yyy += 100
	helpText .= "Quick Defintion. blag blagh blah`n"
	helpText .= "`n"
	helpText .= "`n"
	Gui, 4: Add, Text, ,%helpText%
	Gui, 4: -Border +AlwaysOnTop
	Gui, 4: Add, Button, gCloseHelp vCloseHelp xp+25 yp+35, Close


	;Gui, 4: Show, x%xxx% y%yyy%
	msgbox Hi! I'm Help
	return

CloseHelp:
	helpText := ""
	Gui, 4: Destroy
	return

CloseEdit:
2GuiClose:
	editText := ""
	EnableHotkeys()
	Gui, 2: Destroy ; We cannot recreate the same gui. We must destroy or redisplay it.
	return

GuiClose:
	ExitApp
	return

ModCheck:
	global modCheck

	Gui, Submit, NoHide

	modCheck := ModGroup

	DisableHotkeys()
	ModifyOptions()
	OptionChanged()
	UpdateHotkeyControls()
	return

SpecialChoice:
	global specialCheck

	Gui, Submit, Nohide

	specialCheck := SpecialChoice

	;FileAppend SPECIAL: %specialCheck%`n, *

	DisableHotkeys()
	ModifyOptions()
	OptionChanged()
	UpdateHotkeyControls()
	return

; -------------- Keybinds ------------------------
; Test that bound hotkeys work
DoHotkey1: ; Type Lane
	;soundbeep
	shortcut(substr(A_ThisLabel, 9))
	return
DoHotkey2: ; Type Left_bounded
	;soundbeep
	shortcut(substr(A_ThisLabel, 9))
	return
DoHotkey3: ; Type Right_bounded
	;soundbeep
	shortcut(substr(A_ThisLabel, 9))
	return
DoHotkey4: ; Type Connection
	;soundbeep
	shortcut(substr(A_ThisLabel, 9))
	return
DoHotkey5: ; Type Bidirectional
	;soundbeep
	shortcut(substr(A_ThisLabel, 9))
	return
DoHotkey6: ; Type Roundabout
	;soundbeep
	shortcut(substr(A_ThisLabel, 9))
	return
DoHotkey7: ; Type Guide
	;soundbeep
	shortcut(substr(A_ThisLabel, 9))
	return
DoHotkey8: ; Spline
	;soundbeep
	;Send, {i}
	msgbox You pressed Hotkey 8.
	return
DoHotkey9: ; Reverse Direction
	;soundbeep
	;Send, {[}
	msgbox You pressed Hotkey 9.
	return
DoHotkey10: ; Connection Tool
	;soundbeep
	;Send, {j}
	msgbox You pressed Hotkey 10.
	return
DoHotkey11: ; Center tool
	;soundbeep
	;centerTool()
	msgbox You pressed Hotkey 11.
	;teamsmute()
	return
DoHotkey12: ; Special 
	special()
	return
TeamsMute:
	;teamsmute()
	msgbox TEAMSMUTE
	return

; Something changed - rebuild
OptionChanged:
	OptionChanged()
	return

OptionChanged(){
	Gui, Submit, NoHide
	; Disable Hotkeys
	DisableHotkeys()

	EnableHotkeys()

	SaveSettings()

	return
}

ModifyOptions() {
	global HotkeyList
	global modCheck
	global NumHotkeys
	global specialCheck

	; Check for INI
	; 1 = Middle, 2 = Thumb1, 3 = Thumb2

	Loop % HotkeyList.MaxIndex() {
		tmphkp := HotkeyList[A_Index].hkp
		tmphks := HotkeyList[A_Index].hks
		
		if (A_Index != NumHotkeys) {
			outhkp := ""
			outhks := ""
			FileAppend BOTH: %A_Index% | %tmphkp% AND %tmphks%`n, *
			if (tmphkp != "" && tmphks != "") {
				tmphkp := substr(tmphkp, 12)
				tmphks := substr(tmphks, 12)
				outhkp := BuildHotkeyString(tmphkp, modCheck)
				outhks := BuildHotkeyString(tmphks, modCheck)
				HotkeyList[A_Index].hkp := outhkp
				HotkeyList[A_Index].hks := outhks

				HotkeyList[A_Index].typep := modCheck
				HotkeyList[A_Index].types := modCheck
			} else if (tmphkp != "") {
				tmphkp := substr(tmphkp, 12)
				outhkp := BuildHotkeyString(tmphkp, modCheck)
				HotkeyList[A_Index].hkp := outhkp
				HotkeyList[A_Index].typep := modCheck
			} else if (tmphks != ""){
				tmphks := substr(tmphks, 12)
				outhks := BuildHotkeyString(tmphks, modCheck)
				HotkeyList[A_Index].hks := outhks
				HotkeyList[A_Index].types := modCheck
			}
			; Now we have to update the hotkey list
		}
		
		FileAppend outhkp: %outhkp%`n, *
		FileAppend outhks: %outhks%`n, *
	}
	return
}

SwapVersion() {
	return
}

; Detects a pressed key combination
Bind1:
	Bind(substr(A_GuiControl,6), 1) 
	return

Bind2:
	Bind(substr(A_GuiControl,6), 2) ; param: 1 or 2 (prim or sec)
	return

Bind(ctrlnum, select){
	global BindMode
	global EXTRA_KEY_LIST
	global HKLastHotkey
	global HotkeyList
	global HKControlType
	global HKSecondaryInput
	global modCheck
	global NumHotkeys

	; init vars
	HKControlType := 0
	
	; Disable existing hotkeys
	DisableHotkeys()

	; Start Bind Mode - this starts detections for mouse buttons/special keys
	BindMode := 1

	; Show the prompt
	prompt .= "Please press the desired key.`n"
	prompt .= "(LG) keybinds are automatically paired with ThumbButton 1. If 'Laptop Only' is checked, automatically paired Middle Mouse`n"
	prompt .= "(Special) is reserved custom keybinds. Ex: ThumbButton 2 = Enter`n"
	prompt .= "Supports most keyboard keys.`n"
	prompt .= "`nHit Escape to cancel."
	Gui, 2: +LastFound
	WinGetPos xxx, yyy
	xxx += 25
	yyy += 200
	Gui, 3: Add, Text, Center, %prompt%
	Gui, 3: -Border +AlwaysOnTop
	Gui, 3: Show, x%xxx% y%yyy%

	outhk := ""

	;L1: maximum allowed lenght of input, in this case only 1 input
	;When text reaches this length, input will be terminated and ErrorLevel will be set to
	; "Max" unless the text matches one of the MatchList phrases (EXTRAKEYLIST)
	; set to "Match"
	Loop {
		Input, detectedkey, L1, %EXTRA_KEY_LIST%

		if (substr(ErrorLevel, 1, 7) == "EndKey:"){
			tmp := substr(ErrorLevel, 8)
			detectedkey := tmp
			if (tmp == "Backspace") {
				continue
			} else if (tmp == "Escape") {
				if (HKControlType > 0) {
					detectedKey := HKSecondaryInput
				} else {
					detectedkey := ""
					; Start listening to key up event for Escape, to see if it was held
					hotkey, Escape up, EscapeReleased, ON
				}
			}
		} else {
			break
		}
	} Until (tmp != "Backspace")

	; Hide prompt
	Gui, 3:Submit

	; Stop listening to mouse
	BindMode := 0

	; Process results
	; Data structure will have to store both hk
	; current : {hk: "", type: ""}
	; update: {hkp: "", typep: "", hks: "", types: ""}
	;
	if (detectedkey){
		; Update the hotkey object
		;outhk := BuildHotkeyString(detectedkey,HKControlType)
		FileAppend TypeB: %HKControlType%`n, *
		HKControlType := modCheck
		FileAppend RADIO: %modCheck%`n, *
		
		if (ctrlnum == NumHotkeys) {
			HKControlType := 4
		}
		
		FileAppend TypeA: %HKControlType%`n, *
		outhk := BuildHotkeyString(detectedkey,HKControlType)
		tmp := {hk: outhk, type: HKControlType, status: 0}
		clash := 0
		prevent := 0
		Loop % HotkeyList.MaxIndex(){
			if (detectedkey == "enter" && ctrlnum != NumHotkeys) { ; Add prevention for special keybinds to only take thumb2
				prevent := 1
			} else if (ctrlnum == NumHotkeys && detectedkey != "enter") {
				if (detectedkey != "xbutton1" && detectedkey != "xbutton2") {
					;prevent := 2
				}
			}
			if (StripPrefix(HotkeyList[A_Index].hkp) == StripPrefix(tmp.hk) || StripPrefix(HotkeyList[A_Index].hks) == StripPrefix(tmp.hk)){
				prehkp := HotkeyList[A_Index].hkp
				prehks := HotkeyList[A_Index].hks
				pretmp := tmp.hk
				FileAppend Pre: %prehkp% | %prehks% | %pretmp%, *
				clash := 1
			}
		}
		if (prevent == 1) {
			msgbox 'Enter' key is reserved for special keybind. Exiting...
		} else if (prevent == 2) {
			msgbox %detectedkey% is restricted with special keybind. Exiting...
		} else if (specialCheck == 3 && select == 2) {
			msgbox Please select 'Custom' from drop down list if you want to use secondary keybind for (Special)
		} else if (clash) {
			; Ask if want to overwrite - Need Shortcut, keybind(s) OLD/NEW
			msgbox You cannot bind the same hotkey to two different actions. Exiting...
		} else {
			if (select == 1) { ; select primary or secondary
				tmp := {hkp: outhk, typep: HKControlType, hks: HotkeyList[ctrlnum].hks, types: HotkeyList[ctrlnum].types, status: 0}
			} else {
				tmp := {hkp: HotkeyList[ctrlnum].hkp, typep: HotkeyList[ctrlnum].typep, hks: outhk, types: HKControlType, status: 0}
			}
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

EscapeReleased:
	hotkey, Escape up, EscapeReleased, OFF
	return

; Enables User-Defined Hotkeys
EnableHotkeys(){
	global HotkeyList
	global NumHotkeys
	global specialCheck

	Loop % HotkeyList.MaxIndex(){
		status := HotkeyList[A_Index].status
		hkp := HotkeyList[A_Index].hkp
		hks := HotkeyList[A_Index].hks
		if ((hkp != "" || hks != "") && status == 0){
			FileAppend ENABLE`n, *
			FileAppend hkp: %hkp%`n, *
			FileAppend hks: %hks%`n, *
			prefix := BuildPrefix(HotkeyList[A_Index])
			if (A_Index != NumHotkeys) {
				if (hkp != "" && hks != "") {
					hotkey, %hkp%, DoHotkey%A_Index%, ON
					hotkey, %hks%, DoHotkey%A_Index%, ON
				} else if (hkp != "") {
					;prefix := BuildPrefix(HotkeyList[A_Index])
					;Msgbox % "ADDING: " prefix "," hk
					hotkey, %hkp%, DoHotkey%A_Index%, ON
					;hotkey, %prefix%%hks%, DoHotkey%A_Index%, ON
				} else if (hks != "") {
					;prefix := BuildPrefix(HotkeyList[A_Index])
					;Msgbox % "ADDING: " prefix "," hk
					;hotkey, %prefix%%hkp%, DoHotkey%A_Index%, ON
					hotkey, %hks%, DoHotkey%A_Index%, ON
				}
			} else {
				if (hkp != "") {
					if (specialCheck == 2) {
						if (hks != "") {
							hotkey, %hkp% & %hks%, TeamsMute, ON
						} else {
							hotkey, %hkp%, TeamsMute, ON
						}
					} else {
						hotkey, %hkp%, DoHotkey%A_Index%, ON
					}
					
					;hotkey, %prefix%%hkp%, DoHotkey%A_Index%, ON
				}
				;prefix := BuildPrefix(HotkeyList[A_Index])
				;hotkey, %hkp%, DoHotkey%A_Index%, ON
			}
			HotkeyList[A_Index].status := 1
		}
	}
	return
}

; Disables User-Defined Hotkeys
DisableHotkeys(){
	global HotkeyList
	global NumHotkeys
	global specialCheck

	Loop % HotkeyList.MaxIndex(){
		status := HotkeyList[A_Index].status
		hkp := HotkeyList[A_Index].hkp
		hks := HotkeyList[A_Index].hks
		if ((hkp != "" || hks != "") && status == 1){
			FileAppend DISABLE`n, *
			FileAppend hkp: %hkp%`n, *
			FileAppend hks: %hks%`n, *
			prefix := BuildPrefix(HotkeyList[A_Index])
			if (A_Index != NumHotkeys) {
				if (hkp != "" && hks != "") {
					;Msgbox % "REMOVING: " prefix "," hk
					hotkey, %hkp%, DoHotkey%A_Index%, OFF
					hotkey, %hks%, DoHotkey%A_Index%, OFF
					;hotkey, %prefix%%hks%, DoHotkey%A_Index%, OFF
					;hotkey, %hk%, DoHotkey%A_Index%, OFF
				} else if (hkp != "") {
					;Msgbox % "REMOVING: " prefix "," hk
					;hotkey, %prefix%%hkp%, DoHotkey%A_Index%, OFF
					hotkey, %hkp%, DoHotkey%A_Index%, OFF
					;hotkey, %hk%, DoHotkey%A_Index%, OFF
				} else if (hks != "") {
					;FileAppend special: %hks%`n, *
					;hotkey, %hkp%, DoHotkey%A_Index%, OFF
					hotkey, %hks%, DoHotkey%A_Index%, OFF
				}
			} else {
				if (hkp != "") {
					if (specialCheck == 2) {
						if (hks != "") {
							hotkey, %hkp% & %hks%, TeamsMute, OFF
						} else {
							hotkey, %hkp%, TeamsMute, OFF
						}
					}
					hotkey, %hkp%, DoHotkey%A_Index%, OFF
				}
			}
			
			HotkeyList[A_Index].status := 0
		}
	}
	return
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
	global modCheck
	global specialCheck

	;iniwrite, %swapCheck%, %ININame%, Version, swap
	;iniwrite, %laptopCheck%, %ININame%, Version, laptop
	iniwrite, %modCheck%, %ININame%, Version, radio
	iniwrite, %specialCheck%, %ININame%, Version, special
	Loop % HotkeyList.MaxIndex(){
		hkp := HotkeyList[A_Index].hkp
		typep := HotkeyList[A_Index].typep
		hks := HotkeyList[A_Index].hks
		types := HotkeyList[A_Index].types
		;block := HotkeyList[A_Index].block

		;if (hk != ""){
			iniwrite, %hkp%, %ININame%, Hotkeys, hk_%A_Index%_hkp
			iniwrite, %typep%, %ININame%, Hotkeys, hk_%A_Index%_typep
			iniwrite, %hks%, %ININame%, Hotkeys, hk_%A_Index%_hks
			iniwrite, %types%, %ININame%, Hotkeys, hk_%A_Index%_types
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
	global modCheck
	global specialCheck

	;IniRead, laptopValue, %ININame%, Version, laptop
	;IniRead, swapValue, %ININame%, Version, swap
	IniRead, radioValue, %ININame%, Version, radio
	IniRead, specialValue, %ININame%, Version, special
	if (laptopValue != "ERROR") {
		laptopCheck := laptopValue
	}

	if (swapValue != "ERROR") {
		swapCheck := swapValue
	}

	if (radioValue != "ERROR") {
		modCheck := radioValue
	}

	if (specialValue != "ERROR") {
		specialCheck := specialValue
	}

	Loop % NumHotkeys {
		; Init array so all items exist
		HotkeyList[A_Index] := DefaultHKObject
		IniRead, valp, %ININame% , Hotkeys, hk_%A_Index%_hkp,
		IniRead, typep, %ININame%, Hotkeys, hk_%A_Index%_typep,
		IniRead, vals, %ININame% , Hotkeys, hk_%A_Index%_hks,
		IniRead, types, %ININame%, Hotkeys, hk_%A_Index%_types,
		if (valp != "ERROR" && vals != "ERROR"){
			;IniRead, block, %ININame% , Hotkeys, hk_%A_Index%_block, 0
			IniRead, typep, %ININame%, Hotkeys, hk_%A_Index%_typep, 0
			IniRead, types, %ININame%, Hotkeys, hk_%A_Index%_types, 0
			HotkeyList[A_Index] := {hkp: valp, typep: typep, hks: vals, types: types, status: 0}
		} else if (valp != "ERROR") {
			IniRead, typep, %ININame%, Hotkeys, hk_%A_Index%_typep, 0
			HotkeyList[A_Index] := {hkp: valp, typep: typep, hks: "", types: "", status: 0}
		} else if (vals != "ERROR") {
			IniRead, types, %ININame%, Hotkeys, hk_%A_Index%_types, 0
			HotkeyList[A_Index] := {hkp: "", typep: "", hks: vals, types: types, status: 0}
		}
	}
	UpdateHotkeyControls()
}

; Update the GUI controls with the hotkey names
; Added HotKeyName2 for secondary keybinds
UpdateHotkeyControls(){
	global HotkeyList
	global modCheck
	global specialCheck

	GuiControl, 1: , Laptop, %laptopCheck%
	GuiControl, 1: , Swap, %swapCheck%
	GuiControl, 1: , Button%modCheck%, 1
	GuiControl, Choose, SpecialChoice, %specialCheck%

	Loop % HotkeyList.MaxIndex(){
		;tmp1 := BuildHotkeyName(HotkeyList[A_Index].hkp, HotkeyList[A_index].typep)
		;tmp2 := BuildHotkeyName(HotkeyList[A_Index].hks, HotkeyList[A_index].types)
		tmp1 := BuildHotKeyName(HotkeyList[A_Index].hkp, HotkeyList[A_index].typep)
		tmp2 := BuildHotKeyName(HotkeyList[A_Index].hks, HotkeyList[A_index].types)

		GuiControl, 1: , HotkeyName1%A_Index%, %tmp1%
		GuiControl, 1: , HotkeyName2%A_Index%, %tmp2%
		GuiControl, 2: , HotkeyName1%A_Index%, %tmp1%
		GuiControl, 2: , HotkeyName2%A_Index%, %tmp2%
	
		;tmp := HotkeyList[A_Index].block
		;GuiControl,, Block%A_Index%, %tmp%
	}
	return
}

BuildHotkeyString(str, type := 0){
	FileAppend String: %str%`n, *
	if (type == 4) { ; Reserved for SPECIAL
		outhk := str
	} else if (type == 1) { ; Middle
		outhk := "mbutton  & "
		outhk .= str
	} else if (type == 2) { ; Thumb1
		outhk := "xbutton2 & "
		if (str == "xbutton2") {
			str := "xbutton1"
		}
		outhk .= str
	} else if (type == 3) { ; Thumb2
		outhk := "xbutton1 & "
		if (str == "xbutton1") {
			str := "xbutton2"
		}
		outhk .= str
	}

	return outhk
}

BuildHotKeyName(hk, ctrltype){
	outstr := ""
	;stringupper, hk, hk
	if (hk != "") {
		if (ctrltype == 4) { ; RESERVERD FOR SPECIAL
			if (hk == "xbutton1") {
				outstr := "Thumb2"
			} else if (hk == "xbutton2") {
				outstr := "Thumb1"
			} else if (hk == "enter") {
				outstr := "Enter"
			} else {
				stringupper, hk, hk
				outstr := hk
			}
		} else  {
			if (ctrltype == 1) {
				outstr := "Middle + "
				tmp2 := substr(hk, 12)
				if (tmp2 == "xbutton1") { ; handle thumb2 paired with m,x1,x2
					tmp2 := "Thumb2"
				} else if (tmp2 == "xbutton2") {
					tmp2 := "Thumb1"
				}
			} else if (ctrltype == 2) {
				outstr := "Thumb1 + "
				tmp2 := substr(hk, 12)
				if (tmp2 == "xbutton1") {
					tmp2 := "Thumb2"
				} else if (tmp2 == "xbutton2") {
					tmp2 := "Thumb1"
				}
			} else if (ctrltype == 3) {
				outstr := "Thumb2 + "
				tmp2 := substr(hk, 12)
				if (tmp2 == "xbutton1") {
					tmp2 := "Thumb2"
				} else if (tmp2 == "xbutton2") {
					tmp2 := "Thumb1"
				}
			}
			outstr .= tmp2
		}
	} else {
		outstr := "None"
	}

	return outstr
}

#If BindMode ; This is will allow xbutton1 and enter to be solo keybinds
	xbutton1::
	xbutton2::
		HKControlType := 4
		HKSecondaryInput := A_ThisHotkey
		Send {Escape}
		return
	enter::
		HKControlType := 4
		HKSecondaryInput := A_ThisHotkey
		Send {Escape}
		return
#If

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
	;Send, .1%y%
	msgbox Pressed shortcut %x%
	return
}

special() {
	global HotkeyList
	global NumHotkeys

	sec := HotkeyList[NumHotkeys].hks
	if (sec == "") {
		msgbox (Special) secondary keybind must not be empty...
	} else {
		msgbox Pressed special shortcut
		;Send, {%sec%}
	}
	
	return
}

teamsmute() {
	WinGet TID, ID, ahk_exe, Teams.exe
	WinActivate ahk_id, %TID%
	Sleep, 200
	Send, ^+m
	return
}

centerTool() {
	global HotkeyList

	if (HotkeyList[11].hkp != "") {
		first := substr(HotkeyList[11].hkp, 1, 8)
		second := substr(HotkeyList[11].hkp, 12)
	} else if (HotkeyList[11].hks != "") {
		first := substr(HotkeyList[11].hks, 1, 8)
		second := substr(HotkeyList[11].hks, 12)
	}
	
	if (GetkeyState(%first%, "p") && GetKeyState(%second%, "p")) {
		HoldKey := !HoldKey
	}
	
	if (HoldKey) {
		Send, {Shift DOWN}{b DOWN}
	} else {
		Send, {Shift UP}{b UP}
	}

	return
}

typeIter() {
	typeCounter := ++typeCounter
	if (typeCounter = 8) {
		typeCounter := 1
	}
	shortcut(typeCounter)
	SetTimer, resetCounter, 1250
	return
}

resetCounter:
	typeCounter := 0
	return

; -------Remaps--------

;  v Hardcoded commands v
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

#Numpad0::
#NumpadIns::
	teamsmute()
	return