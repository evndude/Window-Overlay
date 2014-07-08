;##############################################################################################
; Window List
; Creates a list of windows using the sSearchWindow global var. The sSelectedWinID global
; var is set to the selected window, or 0 if the window is closed without a selection.
; The selected window's Title, Class, EXE path, and Position can be saved.
;##############################################################################################
; Launches Window List GUI
Window_List:
	Gui 5:Default
	Gui +AlwaysOnTop
	Gui Margin, 15, 15
	Gui Font, s12 bold
	Gui Add, Text, w500 center, %sWindowListText%
	Gui Font, s11 norm
	Gui Add, Button, xp+430 yp-4 w70 gWL_Refresh, &Refresh
	Gui Add, Text, w500 center x14 y+8, Press Enter or Double-Click to select a window. Highlight a window to make it visible.
	Gui Add, Checkbox, x43 y+10 vbSaveNewWindow, %A_Space% Update settings with new window's Title, Class, EXE path, and Position?
	Gui Add, ListView, x15 r14 w500 AltSubmit gWL_List_View_Action, Hidden|Title|Class|ID
	WL_PopulateListView(sSearchWindow,"Hidden")
	Gui Add, Button, Hidden Default gWL_Button_OK, OK
	Gui Show, Center AutoSize, Select A Window
	loop {
		; wait until a window is selected or GUI canceled before continuing
		if (WinExist("Select A Window ahk_class AutoHotkeyGUI"))
			sleep 50
		else
			break
	}
return

;##############################################################################################
; Close Window List GUI
5GuiEscape:
5GuiClose:
	; re-hide last selected win if closing and was previously hidden
	if (bHiddenStatePrev == "True")
		WinHide %sWindowIDTempPrev%

	sSelectedWinID := 0
	Gui Destroy
return

;##############################################################################################
; "Refresh" button routine
WL_Refresh:
	LV_Delete()
	WL_PopulateListView(sSearchWindow,"Hidden")
return

;##############################################################################################
; "Ok" button routine (the button is hidden)
WL_Button_OK:
	nFocusedRow := LV_GetNext(0, "Focused")
	if (nFocusedRow != 0)
		Gosub WL_Window_Selected
return

;##############################################################################################
; List View action
WL_List_View_Action:
	if (A_GuiEvent == "DoubleClick") {
		if (A_EventInfo != 0) {
			nFocusedRow := A_EventInfo
			Gosub WL_Window_Selected
		}
	} else if (A_GuiEvent == "I") ; I means item changed,
		if (A_EventInfo != 0 && ErrorLevel == "SF") ; SF means Selected and Focused
			WL_TempShowWindow("Select A Window ahk_class AutoHotkeyGUI")
return

;##############################################################################################
; A window was selected with double-click or enter.
WL_Window_Selected:
	LV_GetText(sSelectedWinID, nFocusedRow, 4)
	sSelectedWinID := "ahk_id " . sSelectedWinID

	GuiControlGet bSaveNewWindow
	if (bSaveNewWindow == true) {
		SaveNewWindow("GetTitle","GetClass",sSelectedWinID)
		GetSizeAndPosition("Save",sSelectedWinID)
	}
	
	Gui Destroy
return

;##############################################################################################
; Temporarily shows windows that are hidden
WL_TempShowWindow(gui_name) {
	global
	LV_GetText(bHiddenState, A_EventInfo, 1)
	LV_GetText(sWindowIDTemp, A_EventInfo, 4)
	sWindowIDTemp := "ahk_id " . sWindowIDTemp
	if (bHiddenState == "True")
		WinShow %sWindowIDTemp%

	Unminimize(sWindowIDTemp) ; function in Show_Hide_Window.ahk
	WinActivate %sWindowIDTemp%
	WinActivate %gui_name%

	if (bHiddenStatePrev == "True")
		WinHide %sWindowIDTempPrev%
	sWindowIDTempPrev := sWindowIDTemp
	bHiddenStatePrev := bHiddenState
}

;##############################################################################################
; Populates a list view control with the matching windows
WL_PopulateListView(sSearchWindow = "",hidden_on = "") {
	if (hidden_on == "Hidden")
		DetectHiddenWindows On
	else
		DetectHiddenWindows Off
	WinGet nWindowArray, List, %sSearchWindow%
	Loop %nWindowArray% {
		DetectHiddenWindows On
		nWindowIDTemp := nWindowArray%A_Index%
		WinGetTitle sWindowTitleTemp, ahk_id %nWindowIDTemp%
		WinGetClass sWindowClassTemp, ahk_id %nWindowIDTemp%
		if (sWindowTitleTemp != "" 
					&& (sWindowTitleTemp != "Window_Overlay.ahk" && sWindowClassTemp != "AutoHotkeyGUI")
					&& (sWindowTitleTemp != "Select A Window" && sWindowClassTemp != "AutoHotkeyGUI")
					&& (sWindowTitleTemp != "Toggle Window Visibility" && sWindowClassTemp != "AutoHotkeyGUI")
					&& (sWindowTitleTemp != "Start menu" && sWindowClassTemp != "DV2ControlHost")
					&& (sWindowTitleTemp != "Jump List" && sWindowClassTemp != "DV2ControlHost")
					&& (sWindowTitleTemp != "Start" && sWindowClassTemp != "Button")
					&& (sWindowTitleTemp != "Program Manager" && sWindowClassTemp != "Progman")
					&& (sWindowTitleTemp != "Default IME" && sWindowClassTemp != "IME")
					&& sWindowTitleTemp != "MSCTFIME UI"
					&& sWindowTitleTemp != "CSpThreadTask Window"
					&& sWindowTitleTemp != "tooltip_view_"
					&& sWindowTitleTemp != "MCI command handling window"
					&& sWindowTitleTemp != "GDI+ Window"
					&& sWindowClassTemp != "wxWindowClassNR"
					&& (sWindowTitleTemp != "DDE Server Window" && sWindowClassTemp != "OleDdeWndClass")
					&& (sWindowTitleTemp != "Msg" && sWindowClassTemp != "Messaging")) {
			DetectHiddenWindows Off
			if (WinExist("ahk_id " . nWindowIDTemp))
				LV_Add("","False",sWindowTitleTemp,sWindowClassTemp,nWindowIDTemp)
			else
				LV_Add("","True",sWindowTitleTemp,sWindowClassTemp,nWindowIDTemp)
		}
	}
	LV_ModifyCol(1,"AutoHdr Center Sort")
	LV_ModifyCol(2,"300")
	LV_ModifyCol(3,"150")
	LV_ModifyCol(4,"AutoHdr")
}
