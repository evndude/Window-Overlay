;##############################################################################################
; Toggle Window Visibility
; Creates a list of all currently running windows (including hidden).
; Selected windows are temporarily shown, and their visibility status
; can be toggled by pressing enter or double-clicking.
;##############################################################################################
; Launches Toggle Window Visibility GUI
Toggle_Window_Visibilty:
	DetectHiddenWindows On
	IfWinExist Toggle Window Visibilty ahk_class AutoHotkeyGUI
	{
		WinShow Toggle Window Visibilty ahk_class AutoHotkeyGUI
		WinActivate Toggle Window Visibilty ahk_class AutoHotkeyGUI
		return
	}
	Gui 3:Default
	Gui +AlwaysOnTop
	Gui Margin, 15, 15
	Gui Font, s12 bold
	Gui Add, Text, w500 center, Toggle Window Visibility
	Gui Font, s11 norm
	Gui Add, Button, xp+430 yp-4 w70 gTWV_Refresh, &Refresh
	Gui Add, Text, w500 x12 y+8 center, Press Enter or Double-Click to toggle a window's visibility.
	Gui Add, Text, w500 y+6 center, Highlight a window to temporarily make it visible.
	Gui Font, norm
	Gui Add, ListView, x14 r14 w500 AltSubmit gTWV_List_View_Action, Hidden|Title|Class|ID
	WL_PopulateListView("","Hidden") ; function in Window_List.ahk
	Gui Add, Button, Hidden Default gTWV_Button_OK, Null
	Gui Show, Center AutoSize, Toggle Window Visibilty
return

;##############################################################################################
; Close Toggle Window Visibility GUI
3GuiEscape:
3GuiClose:
	if (bHiddenStatePrev == "True")
		WinHide %sWindowIDTempPrev%
	Gui Destroy
return

;##############################################################################################
; "Refresh" button routine
TWV_Refresh:
	LV_Delete()
	WL_PopulateListView("","Hidden") ; function in Window_List.ahk
return

;##############################################################################################
; "Ok" button routine (the button is hidden)
TWV_Button_OK:
	nFocusedRow := LV_GetNext(0, "Focused")
	if (nFocusedRow != 0)
		Gosub TWV_Toggle_Window
return

;##############################################################################################
; List View action
TWV_List_View_Action:
	if (A_GuiEvent == "DoubleClick") {	
		if (A_EventInfo != 0) {
			nFocusedRow := A_EventInfo
			Gosub TWV_Toggle_Window
		}
	} else if (A_GuiEvent == "I") ; I means item changed
		if (A_EventInfo != 0 && ErrorLevel == "SF") ; SF means Selected and Focused
			WL_TempShowWindow("Toggle Window Visibilty ahk_class AutoHotkeyGUI") ; function in Window_List.ahk
return

;##############################################################################################
; Toggle the visibility of the selected window
TWV_Toggle_Window:
	LV_GetText(sWindowIDTemp, nFocusedRow, 4)
	LV_GetText(bHiddenState, nFocusedRow, 1)
	sWindowIDTemp := "ahk_id " . sWindowIDTemp
	DetectHiddenWindows Off
	if (bHiddenState == "False") {
		LV_Modify(nFocusedRow, "Col1","True")
		WinHide %sWindowIDTemp%
	} else {
		bHiddenStatePrev := "False" ; to keep window from re-hiding after highlighting a new one
		LV_Modify(nFocusedRow, "Col1","False")
		WinShow %sWindowIDTemp%
		WinSet Transparent, Off, %sWindowIDTemp% ; using "Off" removes click-through also
		WinSet AlwaysOnTop, Off, %sWindowIDTemp%
		Unminimize(sWindowIDTemp) ; function in Show_Hide_Window.ahk
		WinActivate %sWindowIDTemp%
		WinActivate Toggle Window Visibilty ahk_class AutoHotkeyGUI
	}
return
