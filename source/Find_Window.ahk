;##############################################################################################
; Find Window
;##############################################################################################
; Finds the requested window, and return it's ID (with "ahk_id " added) or 0 if it wasn't found or chosen from a list
FindWindow(WinTitle,WinClass) {
	global
	bFindWindowBusy := true
	DetectHiddenWindows On
	if (WinClass = "")
		sSearchWindow := WinTitle
	else
		sSearchWindow := WinTitle . " ahk_class " . WinClass
	WinGet nWindowArray, List, %sSearchWindow%

	if (nWindowArray == 1)
		sSelectedWinID := "ahk_id " . nWindowArray1
	else if (bIsBusy == true) {
		; this enables the show window routines to keep working while sWindowID is valid,
		; and prevents GUIs from interfering with other stuff if sWindowID is invalid
		SetTimer Msgbox_On_Top, 25
		Msgbox 48, Warning, Find Window not available.`nFinish current task before another can be executed.
		sSelectedWinID := 0
	} else {
		; not busy so either GUI can be shown
		if (nWindowArray == 0)
			Gosub Window_Not_Found
		else
			Gosub Multiple_Windows_Found
	}

	; uncomment to display more warnings
	;if (sSelectedWinID == 0) {
	;	SetTimer Msgbox_On_Top, 25
	;	Msgbox 48, Warning, Window not found.
	;}
	bFindWindowBusy := false
	return sSelectedWinID
}

;##############################################################################################
; Window Not Found
; Opened if no window's matched search criteria.
;##############################################################################################
; Launches the Window Not Found GUI
Window_Not_Found:
	Gui 4:Default
	Gui +AlwaysOnTop
	Gui Font, s12 bold
	Gui Add, Text,x135, Window Not Found
	Gui Font, norm
	Gui Add, Text,x4, %A_Space%      Options:`n`t- Run EXE (if application isn't running)`n`t- Choose window from a list of all windows`n`t- Or choose a new window (from visible only)
	Gui Font, s11 bold
	Gui Add, Button,x16 Default gWNF_Run_EXE, &Run EXE
	Gui Add, Button,x+12 gWNF_Show_Window_List, &Window List
	Gui Add, Button,x+12 gWNF_New_Window, &New Window
	Gui Add, Button,x+12 g4GuiClose, &Cancel
	Gui Show, Center, Window Not Found
	loop {
		; wait until a window is selected or GUI canceled before continuing
		if (WinExist("Window Not Found ahk_class AutoHotkeyGUI"))
			sleep 50
		else
			break
	}
return

;##############################################################################################
; Close Window Not Found GUI
4GuiEscape:
4GuiClose:
	sSelectedWinID := 0
	Gui Destroy
return

;##############################################################################################
; Window Not Found - "Run EXE" button routine
WNF_Run_EXE:
	WinHide Window Not Found ahk_class AutoHotkeyGUI
	if (bUseEXECmdLine == true && bUseEXECmdStart == true)
		sWindowID := RunEXE("Start") ; function in Run_EXE.ahk
	else
		sWindowID := RunEXE() ; function in Run_EXE.ahk
	Gui 4:Destroy ; Window Not Found GUI
return

;##############################################################################################
; Window Not Found - "New Window" button routine
WNF_New_Window:
	WinHide Window Not Found ahk_class AutoHotkeyGUI
	bIsBusy := false
	bFindWindowBusy := false

	bFirstRun := true ; set to true so Change_Window won't try to unhide the window that couldn't be found
	Gosub Change_Window
	bFirstRun := false ; turned back off

	if (bWindowChosen == true)
		sSelectedWinID := sWindowID ; set by Change_Window subroutine
	else
		sSelectedWinID := 0

	Gui 4:Destroy ; Window Not Found GUI
return

;##############################################################################################
; Window Not Found - "Window List" button routine
WNF_Show_Window_List:
	WinHide Window Not Found ahk_class AutoHotkeyGUI
	sSearchWindow := "" ; cleared so all windows are searched
	sWindowListText := "Choose From All Windows"
	Gosub Window_List ; subroutine in Window_List.ahk
	Gui 4:Destroy ; Window Not Found GUI
return

;##############################################################################################
; Multiple Windows Found
; Opened if more than one window matched search criteria.
;##############################################################################################
; Launches the Multiple Windows Found GUI. 
Multiple_Windows_Found:
	;sSearchWindow is unchanged so FindWindow()'s value is used
	sWindowListText := "Multiple Windows Found"
	Gosub Window_List ; subroutine in Window_List.ahk
return
