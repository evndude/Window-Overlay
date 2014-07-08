;##############################################################################################
; Notifies the Settings and About windows that the mouse has moved.
; Used to display tooltips and change the mouse pointer for hyperlinks
GUI_Tooltips() {
	local sMouseOverControl,sMouseOverWinID,sMouseOverWinTitle,sMouseOverWinClass,sCurrentTTCtrls
	MouseGetPos,,,sMouseOverWinID,sMouseOverControl
	WinGetTitle sMouseOverWinTitle, ahk_id %sMouseOverWinID%
	WinGetClass sMouseOverWinClass, ahk_id %sMouseOverWinID%
	if (sMouseOverWinTitle == "About " . sScriptTitle && sMouseOverWinClass == "AutoHotkeyGUI") {
		if (sMouseOverControl == "Static7") ; ClassNN_Reference
			DllCall("SetCursor","UInt",hCurs)
	}
	else if (sMouseOverWinTitle == sScriptTitle . " Settings" && sMouseOverWinClass == "AutoHotkeyGUI") {
		if (sMouseOverControl != "") {
			loop {
				sCurrentTTCtrls := TT_%A_Index%_ctrls
				if (sCurrentTTCtrls != "") {
					if sMouseOverControl in %sCurrentTTCtrls%
					{
						S_TooltipDelay(TT_%A_Index%_text)
						break
					}
				} else {
					sTooltipText := ""
					SetTimer S_Tooltip_TurnOn, Off
					SetTimer S_Tooltip_TurnOff, 100
					break
				}
			}
			if sMouseOverControl in %TT_3_ctrls%,%TT_4_ctrls% ; ClassNN_Reference
				DllCall("SetCursor","UInt",hCurs)
		} else {
			SetTimer S_Tooltip_TurnOn, Off
			Tooltip ; turn off
		}
	}
}

;##############################################################################################
; Delay tooltips so it looks nice
S_TooltipDelay(text) {
	global
	SetTimer S_Tooltip_TurnOn, 400
	sTooltipText := text
}

S_Tooltip_TurnOn:
	SetTimer S_Tooltip_TurnOn, Off
	SetTimer S_Tooltip_TurnOff, 100
	Tooltip %sTooltipText%
return

S_Tooltip_TurnOff:
	IfWinNotActive %sGuiName%
	{
		SetTimer S_Tooltip_TurnOn, Off
		SetTimer S_Tooltip_TurnOff, Off
		Tooltip ; turn off
	}
return

;##############################################################################################
; Clear tooltip variables to (hopefully) decrease memory usage
S_Tooltips_Destroy:
	loop {
		if (TT_%A_Index%_ctrls != "") {
			TT_%A_Index%_ctrls := "" ; empty var
			TT_%A_Index%_text := "" ; empty var
		}
		else
			break
	}
return

;##############################################################################################
; Texts and control ClassNNs for tooltips
S_Tooltips_Init: ; ClassNN_Reference; make sure to update ClassNNs if GUI changes
	;TT_1_name := "MainSettings"
	TT_1_ctrls := "Static1"
	TT_1_text := "Main Settings"
	;TT_2_name := "HotkeyString"
	TT_2_ctrls := "Static2,Edit1"
	TT_2_text := "Hotkey used to show the window, or`nhide the window if it's already on top.`n`nValid modifier keys:`n    Control  =  ^         Alt  =  !`n          Shift  =  +       Win  =  #`n`nExamples:`n       #g  =  Win + G`n       !F2  =  Alt + F2`n ^+Esc  =  Ctrl + Shift + Escape"
	;TT_3_name := "HotkeyReference"
	TT_3_ctrls := "Static3"
	TT_3_text := "This link will take you to the ""Hotkey""`ncommand reference for AutoHotKey, which`nhas a full explanation of hotkeys and modifiers."
	;TT_4_name := "HotkeyKeyList"
	TT_4_ctrls := "Static4"
	TT_4_text := "This link will take you to a list of all valid keys."
	;TT_5_name := "UseTransparency"
	TT_5_ctrls := "Static5,Button1"
	TT_5_text := "Enables window transparency."
	;TT_6_name := "TransparencyLevel"
	TT_6_ctrls := "Static6,Edit2,msctls_updown321"
	TT_6_text := "0 (opaque) to 100 (trasparent)."
	;TT_7_name := "UseClickThrough"
	TT_7_ctrls := "Static7,Button2"
	TT_7_text := "Window ignores mouse input. The keyboard can still interact`nwith it by clicking it on the taskbar to activate the window."
	;TT_8_name := "UseMinimize"
	TT_8_ctrls := "Static8,Button3"
	TT_8_text := "Minimize the window instead of hiding it.`nThis keeps it visible on the taskbar,`nand plays the minimize animation."
	;TT_9_name := "MaintainWinSizeAndPos"
	TT_9_ctrls := "Static9,Button4"
	TT_9_text := "The window's size and position are remembered,`nand returned to these values if altered.`nAny blank values are automatically filled with`nthe window's current value on save."
	;TT_10_name := "WinPosX"
	TT_10_ctrls := "Static10,Edit3"
	TT_10_text := "The window's top-left corner X (horizontal) coordinate."
	;TT_11_name := "WinPosY"
	TT_11_ctrls := "Static12,Edit5"
	TT_11_text := "The window's top-left corner Y (vertical) coordinate."
	;TT_12_name := "WinWidth"
	TT_12_ctrls := "Static11,Edit4"
	TT_12_text := "The window's width."
	;TT_13_name := "WinHeight"
	TT_13_ctrls := "Static13,Edit6"
	TT_13_text := "The window's height."
	;TT_14_name := "GetCurrentPos"
	TT_14_ctrls := "Button5"
	TT_14_text := "Retrieve window's current size and position."
	;TT_15_name := "ClearSavedPos"
	TT_15_ctrls := "Button6"
	TT_15_text := "Clear saved size and position."
	;TT_16_name := "OptionalSettings"
	TT_16_ctrls := "Static14"
	TT_16_text := "Optional Settings`nWindow Title, Window Class, and EXE Path are found`nautomatically, but can also be set manually.`nUsing EXE commands are an alternative method to`nshow/hide the window, instead of Hiding/Minimizing,`nand can also be used when starting the program."
	;TT_17_name := "WindowTitle"
	TT_17_ctrls := "Static15,Edit7"
	TT_17_text := "The window's title.`nIf the title is dynamic, extra info can be`ntrimmed so the window is always found.`nCan be left blank to only use the Class."
	;TT_18_name := "WindowClass"
	TT_18_ctrls := "Static16,Edit8"
	TT_18_text := "The window's class.`nCan be left blank to only use the Title."
	;TT_19_name := "EXEPath"
	TT_19_ctrls := "Static17,Edit9,Button7"
	TT_19_text := "The program's path.`nUsed to start program if the window isn't found,`nand also with EXE commands (if enabled)."
	;TT_20_name := "UseEXECommand"
	TT_20_ctrls := "Static18,Button8"
	TT_20_text := "Enable using EXE switches as an alternative for some functions.`nThe program needs to have a command line switch`ncorresponding with the window command.`nIt may be necessary to enclose commands with quotation marks."
	;TT_21_name := "sEXECmdStart"
	TT_21_ctrls := "Static19,Edit10,Button9"
	TT_21_text := "Command that starts the window.`nUsed when the program is first opened."
	;TT_22_name := "sEXECmdShow"
	TT_22_ctrls := "Static20,Edit11,Button10"
	TT_22_text := "Command that shows the window.`nAn alternative to using AutoHotKey's normal WinShow method."
	;TT_23_name := "sEXECmdHide"
	TT_23_ctrls := "Static21,Edit12,Button11"
	TT_23_text := "Command that hides the window.`nAn alternative to using the Hiding/Minimizing option above."
return
