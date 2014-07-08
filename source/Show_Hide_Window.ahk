;##############################################################################################
; Hotkey routine
;##############################################################################################
; Toggles the visibility of the selected window and applies attributes.
Show_Or_Hide_Window:
	if (bFindWindowBusy == true || bIsChangingTransparency == true) {
		SetTimer Msgbox_On_Top, 25
		Msgbox 48, Warning, Finish current task before another can be executed.
		return
	}
	sPreviousWindowID := "ahk_id " . WinActive("A")
	DetectHiddenWindows Off
	if (sWindowID != 0 && WinExist(sWindowID) && bOverlayEnabled == true) { 
		; Unminimize if minimized, or hide window if already on top
		bMinimizedState := Unminimize(sWindowID) ; Unminimize returns 1 if it was minimized, or 0 if unminimized
		if (bMinimizedState == 0) 
			ShowWindow("","","","Hide")
	} else
		ShowWindow("ApplyAttr","UnMin","")

	if (sPreviousWindowID != sWindowID)
		WinActivate %sPreviousWindowID%
return

;##############################################################################################
; Tray routines
;##############################################################################################
; Show window overlay and apply attributes
Enable_Overlay:
	if (bFindWindowBusy == true || bIsChangingTransparency == true) {
		SetTimer Msgbox_On_Top, 25
		Msgbox 48, Warning, Enable Overlay not available.`nFinish current task before another can be executed.
 	} else
		ShowWindow("ApplyAttr","UnMin")
return

;##############################################################################################
; Hide window overlay
Hide_Overlay:
	if (bFindWindowBusy == true || bIsChangingTransparency == true) {
		SetTimer Msgbox_On_Top, 25
		Msgbox 48, Warning, Hide Overlay not available.`nFinish current task before another can be executed.
	} else
		ShowWindow("","","","Hide")
return

;##############################################################################################
; Show window overlay and remove attributes
Disable_Overlay:
	if (bFindWindowBusy == true || bIsChangingTransparency == true) {
		SetTimer Msgbox_On_Top, 25
		Msgbox 48, Warning, Disable Overlay not available.`nFinish current task before another can be executed.
	} else
		ShowWindow("RemoveAttr","UnMin")
return

;##############################################################################################
; Window Functions
;##############################################################################################
; Show Window with options for Applying/Removing attributes,
; unminimizing, and/or activating. It can also Hide the window.
; The attr parameter needs to be "ApplyAttr" or "RemoveAttr",
; and the others just need to be non-blank to activate that option.
ShowWindow(attr = "", unmin = "", activ = "", hide = "") {
	global
	DetectHiddenWindows On
	if (sWindowID == 0 || (sWindowID != 0 && WinExist(sWindowID) == 0)) {
		sWindowID := FindWindow(sWindowTitle,sWindowClass) ; function in Find_Window.ahk
		if (sWindowID == 0) {
			;SetTimer Msgbox_On_Top, 25 ; can be uncommented to display more warnings
			;Msgbox 48, Warning, Window not found.`n`nShow/Hide Window canceled.
			return
		}
	}
	DetectHiddenWindows Off

	; Show window
	if (hide == "") {
		if (bUseEXECmdLine == true && bUseEXECmdShow == true && WinExist(sWindowID) == 0)
			sWindowID := RunEXE("Show") ; function in Run_EXE.ahk
		else
			WinShow %sWindowID%
	}

	if (unmin != "")
		Unminimize(sWindowID)

	if (attr == "ApplyAttr")
		Gosub Apply_Attributes
	else if (attr == "RemoveAttr")
		Gosub Remove_Attributes

	if (activ != "")
		WinActivate %sWindowID%

	; Hide window
	if (hide != "") { 
		if (bUseEXECmdLine == true && bUseEXECmdHide == true && WinExist(sWindowID) != 0)
			sWindowID := RunEXE("Hide") ; function in Run_EXE.ahk
		else {
			if (bUseMinimize == true)
				WinMinimize %sWindowID%
			else
				WinHide %sWindowID%
		}
	}
}

;##############################################################################################
; Apply window attributes
Apply_Attributes:
	bOverlayEnabled := true
	WinSet AlwaysOnTop, On, %sWindowID%

	if (bUseClickThrough == true)
		WinSet ExStyle, +0x20, %sWindowID% ; click-through on
	else
		WinSet ExStyle, -0x20, %sWindowID% ; click-through off

	if (bUseTransparency == true) {
		nTransparencyLevel8bit := Round(Map(nTransparencyLevel,0,100,255,0)) ; function in Window_Overlay.ahk
		WinSet Transparent, %nTransparencyLevel8bit%, %sWindowID%
	} else
		WinSet Transparent, 255, %sWindowID% ; using "Off" (instead of 255) removes click-through also

	if (bMaintainWinSizeAndPos == true)
		WinMove %sWindowID%,,%nWinPosX%,%nWinPosY%,%nWinWidth%,%nWinHeight%
return

;##############################################################################################
; Make window like normal again.
Remove_Attributes:
	bOverlayEnabled := false
	WinSet AlwaysOnTop, Off, %sWindowID%
	WinSet ExStyle, -0x20, %sWindowID% ; click-through off
	WinSet Transparent, Off, %sWindowID%
return

;##############################################################################################
; If window is minimized, unminimize
Unminimize(window) {
	WinGet nMinMaxState, MinMax, %window%
	if (nMinMaxState == -1) {
		; win was minimized
		WinRestore %window%
		return 1
	}
	return 0
}
