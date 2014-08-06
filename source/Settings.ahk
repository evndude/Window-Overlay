;##############################################################################################
; Launches the Settings GUI
Settings:
	sGuiName := sScriptTitle . " Settings ahk_class AutoHotkeyGUI"
	IfWinExist %sGuiName%
		WinActivate %sGuiName%
	else {
		if (bIsBusy == true || bFindWindowBusy == true) {
			SetTimer Msgbox_On_Top, 25
			Msgbox 48, Warning, Settings not available.`nFinish current task before another can be executed.
			return
		} else {
			; skip reading settings again if sent here because of a read error
			if (bFromSettings != true) { 
				bFromSettings := true
				Gosub Read_INI ; subroutine in Read_Write_INI.ahk
			}
			bFromSettings := false
			bIsBusy := true

			Gui 1:Default
			Gui Font, s11 bold
			Gui -Resize -MaximizeBox
			Gui Add, Text, x157 y14,   Main Settings
			Gui Font, norm

			Gui Add, Text, w360 x12 y+12, Show/Hide Hotkey
			Gui Font, underline
			Gui Add, Text, xp+122 cBlue gS_Launch_Hotkey_Ref, (Hotkey Help)
			Gui Add, Text, xp+92 cBlue gS_Launch_Key_List, (Key List)
			Gui Font, norm
			Gui Add, Edit, w70 xp+95 yp-2 R1 vsShowHideHotkeyTemp, %sShowHideHotkey%

			Gui Add, Text, w360 x12 y+10, Change Window Hotkey
			Gui Add, Edit, w70 xp+309 yp-2 R1 vsChangeWinHotkeyTemp, %sChangeWinHotkey%

			Gui Add, Text, w360 x12 y+10, Use Transparency?
			Gui Add, Checkbox, xp+349 Checked%bUseTransparency% vbUseTransparency

			Gui Add, Text, w360 x12 y+16, Transparency Level (`%)
			Gui Add, Edit, w46 xp+332 yp-4 R1 vnTransparencyLevelRaw Number	Limit Right, %nTransparencyLevel%
			Gui Add, UpDown, vnTransparencyLevel Range0-100, %nTransparencyLevel%

			Gui Add, Text, w360 x12 y+12, Use Click-Through?
			Gui Add, Checkbox, xp+349 yp+1 Checked%bUseClickThrough% vbUseClickThrough

			Gui Add, Text, w360 x12 y+12, Use Minimize instead of Hiding?
			Gui Add, Checkbox, xp+349 yp+1 Checked%bUseMinimize% vbUseMinimize

			Gui Add, Text, w360 x12 y+12, Maintain Window Size and Position?
			Gui Add, Checkbox, xp+349 Checked%bMaintainWinSizeAndPos% vbMaintainWinSizeAndPos

			if (bFirstRun == true) {
				Gui Font, bold
				Gui Add, Button, x122 y+14 Default gS_Save, &Save && Choose Window
			}
			else {
				Gui Add, Text, w130 x12 y+16, Win X Pos
				Gui Add, Edit, w50 xp+66 yp-3 R1 vnWinPosX Number Right, %nWinPosX%
				Gui Add, Text, w130 x+22 yp+3, Win Width
				Gui Add, Edit, w50 xp+66 yp-3 R1 vnWinWidth Number Right, %nWinWidth%

				Gui Add, Button, x+22 yp-3 gS_Get_Size_And_Pos, Get Current Pos

				Gui Add, Text, w130 x12 y+16, Win Y Pos
				Gui Add, Edit, w50 xp+66 yp-3 R1 vnWinPosY Number Right, %nWinPosY%
				Gui Add, Text, w130 x+17 yp+3, Win Height
				Gui Add, Edit, w50 xp+71 yp-3 R1 vnWinHeight Number Right, %nWinHeight%

				Gui Add, Button, x+14 yp-3 gS_Clear_Saved_Pos, Clear Saved Pos

				Gui Font, bold
				Gui Add, Text, x145 y+16, Optional Settings
				Gui Font, norm

				Gui Add, Text, w360 x12 y+14, Window Title
				Gui Add, Edit, w287 xp+98 yp-3 R1 vsWindowTitleTemp, %sWindowTitle%
				Gui Add, Text, w360 x12 y+12, Window Class
				Gui Add, Edit, w287 xp+98 yp-3 R1 vsWindowClassTemp, %sWindowClass%

				Gui Add, Text, w360 x12 y+12, EXE Path
				Gui Add, Edit, w250 xp+66 yp-3 R1 vsEXEPath, %sEXEPath%
				Gui Add, Button, x+10 yp-3 gS_File_Browse, Browse

				Gui Add, Text, w360 x12 y+9, Use EXE Command Line?
				bHideEXECtrls := !bUseEXECmdLine

				Gui Add, Checkbox, xp+349 Checked%bUseEXECmdLine% vbUseEXECmdLine gS_EXE_Controls_Reposition
				Gui Add, Text, w360 x12 y+14 Hidden%bHideEXECtrls% vS_EXECmdStartLabel, Start Cmd
				Gui Add, Edit, w262 xp+75 yp-3 R1 Hidden%bHideEXECtrls% vsEXECmdStart, %sEXECmdStart%
				Gui Add, Checkbox, x+12 yp+4 Hidden%bHideEXECtrls% Checked%bUseEXECmdStart% vbUseEXECmdStart

				Gui Add, Text, w360 x12 y+16 Hidden%bHideEXECtrls% vS_EXECmdShowLabel, Show Cmd
				Gui Add, Edit, w262 xp+75 yp-3 R1 Hidden%bHideEXECtrls% vsEXECmdShow, %sEXECmdShow%
				Gui Add, Checkbox, x+12 yp+4 Hidden%bHideEXECtrls% Checked%bUseEXECmdShow% vbUseEXECmdShow

				Gui Add, Text, w360 x12 y+16 Hidden%bHideEXECtrls% vS_EXECmdHideLabel, Hide Cmd
				Gui Add, Edit, w262 xp+75 yp-3 R1 Hidden%bHideEXECtrls% vsEXECmdHide, %sEXECmdHide%
				Gui Add, Checkbox, x+12 yp+4 Hidden%bHideEXECtrls% Checked%bUseEXECmdHide% vbUseEXECmdHide

				Gui Font, bold
				Gui Add, Button, w120 x70 y+18 Default gS_Save vS_SaveButton, &Save && Apply
				Gui Font, norm
				Gui Add, Button, w80 x+75 gGuiClose vS_CancelButton, &Cancel

				; hide EXE command options if UseEXECmdLine isn't enabled
				if (bUseEXECmdLine != true) {
					GuiControlGet ControlPos, Pos, bUseEXECmdLine
					ControlPosY := ControlPosY + 30
					GuiControl, Move, S_SaveButton, y%ControlPosY%
					GuiControl, Move, S_CancelButton, y%ControlPosY%
				}
			}
			Gui Show, AutoSize Center, %sScriptTitle% Settings

			Gosub S_Tooltips_Init
			IfWinNotExist About %sScriptTitle%
			{
				; load pointing finger mouse pointer
				hCurs := DllCall("LoadCursor","UInt",NULL,"Int",32649,"UInt")
				; enable function to notify to the window that the mouse has moved
				OnMessage(0x200, "GUI_Tooltips") ; function in GUI_Tooltips.ahk
			}
		}
	}
return

;##############################################################################################
; Close Settings GUI
GuiEscape:
GuiClose:
	bIsBusy := false
	SetTimer S_Tooltip_TurnOn, Off ; subroutine in GUI_Tooltips.ahk
	SetTimer S_Tooltip_TurnOff, 100 ; subroutine in GUI_Tooltips.ahk
	Gosub S_Tooltips_Destroy ; subroutine in GUI_Tooltips.ahk
	Gui Destroy
	IfWinNotExist About %sScriptTitle%
	{
		DllCall("DestroyCursor","Uint",hCurs)
		OnMessage(0x200,"")
	}
return

;##############################################################################################
; "Save" button routine
S_Save:
	Gui Submit, NoHide
	if (EnableHotkey(sShowHideHotkeyTemp,sShowHideHotkey,"Show_Or_Hide_Window") == "ERROR"
			|| EnableHotkey(sChangeWinHotkeyTemp,sChangeWinHotkey,"Change_Window") == "ERROR") ; function in Enable_Hotkey.ahk
		; GUI can't be Saved without valid hotkeys
		return 

	Gosub GuiClose
	if (bFirstRun == true) {
		Gosub Write_INI ; subroutine in Read_Write_INI.ahk
		Gosub Change_Window  ; subroutine in Change_Window.ahk
	} else {
		DetectHiddenWindows On
		if (sWindowTitleTemp != sWindowTitle || sWindowClassTemp != sWindowClass) {
			if (sWindowID != 0 && WinExist(sWindowID))
				; remove previous window's attributes
				ShowWindow("RemoveAttr") ; function in Show_Hide_Window.ahk
			sWindowTitle := sWindowTitleTemp
			sWindowClass := sWindowClassTemp
			sWindowID := FindWindow(sWindowTitle,sWindowClass) ; function in Find_Window.ahk
			UpdateTrayTip() ; function in Window_Overlay.ahk
			GetSizeAndPosition("Save") ; function in Window_Overlay.ahk
		} 
		else if (sWindowID == 0 || WinExist(sWindowTitle . " ahk_class " . sWindowClass) == 0 || (sWindowTitle == "" && sWindowClass == "")) {
			sWindowID := FindWindow(sWindowTitle,sWindowClass) ; function in Find_Window.ahk
			UpdateTrayTip()
		}

		if (bMaintainWinSizeAndPos == true && sWindowID != 0 && (nWinPosX == "" || nWinPosY == "" || nWinWidth == "" || nWinHeight == "")) {
			GetSizeAndPosition() ; function in Window_Overlay.ahk
			if (nWinPosX == "")
				nWinPosX := nWinPosXTemp 
			if (nWinPosY == "")
				nWinPosY := nWinPosYTemp
			if (nWinWidth == "")
				nWinWidth := nWinWidthTemp
			if (nWinHeight == "")
				nWinHeight := nWinHeightTemp
		}

		QuotesFix(sEXECmdStart,"Encode") ; function in Window_Overlay.ahk
		QuotesFix(sEXECmdShow,"Encode")
		QuotesFix(sEXECmdHide,"Encode")

		Gosub Write_INI ; subroutine in Read_Write_INI.ahk

		QuotesFix(sEXECmdStart,"Decode") ; function in Window_Overlay.ahk
		QuotesFix(sEXECmdShow,"Decode")
		QuotesFix(sEXECmdHide,"Decode")

		if (sWindowID != 0)
			ShowWindow("ApplyAttr","UnMin","") ; function in Show_Hide_Window.ahk

		; uncomment to display more warnings
		;else { 
			;SetTimer Msgbox_On_Top, 25
			;Msgbox 48, Warning, New window not found.
		;}
	}
return

;##############################################################################################
; Reposition controls if Use EXE Command Line checkbox is changed
S_EXE_Controls_Reposition:
	GuiControlGet ControlPos, Pos, bUseEXECmdLine
	GuiControlGet bUseEXECmdLine
	WinGetPos,,,, nWinHeightTemp, %sGuiName%
	if (bUseEXECmdLine == true) {
		GuiControl Show, S_EXECmdStartLabel
		GuiControl Show, sEXECmdStart
		GuiControl Show, bUseEXECmdStart
		GuiControl Show, S_EXECmdShowLabel
		GuiControl Show, sEXECmdShow
		GuiControl Show, bUseEXECmdShow
		GuiControl Show, S_EXECmdHideLabel
		GuiControl Show, sEXECmdHide
		GuiControl Show, bUseEXECmdHide
		ControlPosY := ControlPosY + 132
		nWinHeightTemp += 102
	} else {
		GuiControl Hide, S_EXECmdStartLabel
		GuiControl Hide, sEXECmdStart
		GuiControl Hide, bUseEXECmdStart
		GuiControl Hide, S_EXECmdShowLabel
		GuiControl Hide, sEXECmdShow
		GuiControl Hide, bUseEXECmdShow
		GuiControl Hide, S_EXECmdHideLabel
		GuiControl Hide, sEXECmdHide
		GuiControl Hide, bUseEXECmdHide
		ControlPosY := ControlPosY + 30
		nWinHeightTemp -= 102
	}
	GuiControl, Move, S_SaveButton, y%ControlPosY%
	GuiControl, Move, S_CancelButton, y%ControlPosY%
	WinMove %sGuiName%,,,,,%nWinHeightTemp%
return

;##############################################################################################
; Launch AutoHotKey's documentation for the "Hotkey" command in default web browser
S_Launch_Hotkey_Ref:
	Run http://www.autohotkey.com/docs/Hotkeys.htm#Symbols
return

;##############################################################################################
; Launch AutoHotKey's list of valid keys in default web browser
S_Launch_Key_List:
	Run http://www.autohotkey.com/docs/KeyList.htm
return

;##############################################################################################
; Launch file browser for EXE Path button
S_File_Browse:
	Gui +OwnDialogs
	FileSelectFile sEXEPathTemp,3,,Select an EXE, Applications (*.exe)
	if (!ErrorLevel) {
		GuiControl Text, sEXEPath, %sEXEPathTemp%
		if (sEXEPath != sEXEPathTemp) {
			GuiControl,, bUseEXECmdLine, 0
			Gosub S_EXE_Controls_Reposition
		}
	}
return

;##############################################################################################
; Gets current size and position and updates the GUI with them
S_Get_Size_And_Pos:
	; set bIsBusy to false incase ShowWindow() trys to call FindWindow() in GetSizeAndPosition()
	bIsBusy := false
	GetSizeAndPosition() ; function in Window_Overlay.ahk
	bIsBusy := true
	GuiControl Text, nWinPosX, %nWinPosXTemp%
	GuiControl Text, nWinPosY, %nWinPosYTemp%
	GuiControl Text, nWinWidth, %nWinWidthTemp%
	GuiControl Text, nWinHeight, %nWinHeightTemp%
	WinActivate %sGuiName%
return

;##############################################################################################
; Removes saved values for window size and position from GUI
S_Clear_Saved_Pos:
	GuiControl Text, nWinPosX,
	GuiControl Text, nWinPosY,
	GuiControl Text, nWinWidth,
	GuiControl Text, nWinHeight,
return
