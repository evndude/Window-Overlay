;##############################################################################################
; Write settings to the ini file
Write_INI:
	IniWrite %sShowHideHotkey%, %sIniFileName%, Settings, Show-Hide Hotkey
	IniWrite %sChangeWinHotkey%, %sIniFileName%, Settings, Change Win Hotkey
	IniWrite %bUseTransparency%, %sIniFileName%, Settings, Use Transparency
	IniWrite %nTransparencyLevel%, %sIniFileName%, Settings, Transparency Level
	IniWrite %bUseClickThrough%, %sIniFileName%, Settings, Use Click-Through
	IniWrite %bUseMinimize%, %sIniFileName%, Settings, Use Minimize
	IniWrite %bMaintainWinSizeAndPos%, %sIniFileName%, Settings, Maintain Window Size And Position
	IniWrite %nWinPosX%, %sIniFileName%, Settings, Win X Pos
	IniWrite %nWinPosY%, %sIniFileName%, Settings, Win Y Pos
	IniWrite %nWinWidth%, %sIniFileName%, Settings, Win Width
	IniWrite %nWinHeight%, %sIniFileName%, Settings, Win Height
	IniWrite %sWindowTitle%, %sIniFileName%, Settings, Window Title
	IniWrite %sWindowClass%, %sIniFileName%, Settings, Window Class
	IniWrite %sEXEPath%, %sIniFileName%, Settings, EXE Path
	IniWrite %bUseEXECmdLine%, %sIniFileName%, Settings, Use EXE Command Line
	IniWrite %bUseEXECmdStart%, %sIniFileName%, Settings, Use EXE Start Command
	IniWrite %sEXECmdStart%, %sIniFileName%, Settings, EXE Start Command
	IniWrite %bUseEXECmdShow%, %sIniFileName%, Settings, Use EXE Show Command
	IniWrite %sEXECmdShow%, %sIniFileName%, Settings, EXE Show Command
	IniWrite %bUseEXECmdHide%, %sIniFileName%, Settings, Use EXE Hide Command
	IniWrite %sEXECmdHide%, %sIniFileName%, Settings, EXE Hide Command
return

;##############################################################################################
; Read settings from the ini file.
Read_INI:
	sErrorMsg := ""

	IniRead sShowHideHotkeyTemp, %sIniFileName%, Settings, Show-Hide Hotkey
	if (sShowHideHotkeyTemp == "ERROR")
		sErrorMsg := sErrorMsg "`nShow-Hide"
	else
		EnableHotkey(sShowHideHotkeyTemp,sShowHideHotkey,"Show_Or_Hide_Window") ; function in Enable_Hotkey.ahk

	IniRead sChangeWinHotkeyTemp, %sIniFileName%, Settings, Change Win Hotkey
	if (sChangeWinHotkeyTemp == "ERROR")
		sErrorMsg := sErrorMsg "`nChange Win Hotkey"
	else
		EnableHotkey(sChangeWinHotkeyTemp,sChangeWinHotkey,"Change_Window") ; function in Enable_Hotkey.ahk
 
	IniRead bUseTransparency, %sIniFileName%, Settings, Use Transparency
	if (bUseTransparency == "ERROR")
		sErrorMsg := sErrorMsg "`nUse Transparency"

	IniRead nTransparencyLevel, %sIniFileName%, Settings, Transparency Level
	if (nTransparencyLevel == "ERROR")
		sErrorMsg := sErrorMsg "`nTransparency Level"

	IniRead bUseClickThrough, %sIniFileName%, Settings, Use Click-Through
	if (bUseClickThrough == "ERROR")
		sErrorMsg := sErrorMsg "`nUse Click-Through"

	IniRead bUseMinimize, %sIniFileName%, Settings, Use Minimize
	if (bUseMinimize == "ERROR")
		sErrorMsg := sErrorMsg "`nUse Minimize"

	IniRead bMaintainWinSizeAndPos, %sIniFileName%, Settings, Maintain Window Size And Position
	if (bMaintainWinSizeAndPos == "ERROR")
		sErrorMsg := sErrorMsg "`nMaintain Window Size And Position"

	IniRead nWinPosX, %sIniFileName%, Settings, Win X Pos
	if (nWinPosX == "ERROR") {
		nWinPosX := ""
		sErrorMsg := sErrorMsg "`nWin X Pos"
	}

	IniRead nWinPosY, %sIniFileName%, Settings, Win Y Pos
	if (nWinPosY == "ERROR") {
		nWinPosY := ""
		sErrorMsg := sErrorMsg "`nWin Y Pos"
	}

	IniRead nWinWidth, %sIniFileName%, Settings, Win Width
	if (nWinWidth == "ERROR") {
		nWinWidth := ""
		sErrorMsg := sErrorMsg "`nWin Width"
	}

	IniRead nWinHeight, %sIniFileName%, Settings, Win Height
	if (nWinHeight == "ERROR") {
		nWinHeight := ""
		sErrorMsg := sErrorMsg "`nWin Height"
	}

	IniRead sWindowTitle, %sIniFileName%, Settings, Window Title
	if (sWindowTitle == "ERROR") {
		sWindowTitle := ""
		sErrorMsg := sErrorMsg "`nWindow Title"
	}

	IniRead sWindowClass, %sIniFileName%, Settings, Window Class
	if (sWindowClass == "ERROR") {
		sWindowClass := ""
		sErrorMsg := sErrorMsg "`nWindow Class"
	}

	IniRead sEXEPath, %sIniFileName%, Settings, EXE Path
	if (sEXEPath == "ERROR") {
		sEXEPath := ""
		sErrorMsg := sErrorMsg "`nEXE Path"
	}

	IniRead bUseEXECmdLine, %sIniFileName%, Settings, Use EXE Command Line
	if (bUseEXECmdLine == "ERROR") {
		bUseEXECmdLine := false	
		sErrorMsg := sErrorMsg "`nUse EXE Command Line"
	}

	IniRead bUseEXECmdStart, %sIniFileName%, Settings, Use EXE Start Command
	if (bUseEXECmdStart == "ERROR")
		sErrorMsg := sErrorMsg "`nUse EXE Start Command"

	IniRead sEXECmdStart, %sIniFileName%, Settings, EXE Start Command
	if (sEXECmdStart == "ERROR") {
		sEXECmdStart := ""
		sErrorMsg := sErrorMsg "`nEXE Start Command"
	} else
		QuotesFix(sEXECmdStart,"Decode") ; function in Window_Overlay.ahk

	IniRead bUseEXECmdShow, %sIniFileName%, Settings, Use EXE Show Command
	if (bUseEXECmdShow == "ERROR")
		sErrorMsg := sErrorMsg "`nUse EXE Show Command"

	IniRead sEXECmdShow, %sIniFileName%, Settings, EXE Show Command
	if (sEXECmdShow == "ERROR") {
		sEXECmdShow := ""
		sErrorMsg := sErrorMsg "`nEXE Show Command"
	} else
		QuotesFix(sEXECmdShow,"Decode") ; function in Window_Overlay.ahk

	IniRead bUseEXECmdHide, %sIniFileName%, Settings, Use EXE Hide Command
	if (bUseEXECmdHide == "ERROR")
		sErrorMsg := sErrorMsg "`nUse EXE Hide Command"

	IniRead sEXECmdHide, %sIniFileName%, Settings, EXE Hide Command
	if (sEXECmdHide == "ERROR") {
		sEXECmdHide := ""
		sErrorMsg := sErrorMsg "`nEXE Hide Command"
	} else
		QuotesFix(sEXECmdHide,"Decode") ; function in Window_Overlay.ahk

	if (bFirstRun == true || sWindowTitle == "ERROR" || sWindowClass == "ERROR")
		sWindowID := 0
	else if ((sWindowID == 0 || sWindowID == "") && bFromSettings != true)
		sWindowID := FindWindow(sWindowTitle,sWindowClass) ; function in Find_Window.ahk
	; else already have valid sWindowID

	if (sErrorMsg != "") {
		Msgbox 48, Error, Error reading the following`nkeys from the settings INI file:`n%sErrorMsg%
 		sErrorMsg := ""

 		; don't want to open Settings twice
 		if (bFromSettings != true) 
			Gosub Settings ; subroutine in Settings.ahk
	}
return
