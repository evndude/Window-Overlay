;##############################################################################################
; Run an EXE with optional Start, Show, or Hide command, and return the window ID (with "ahk_id " added)
RunEXE(command = "") {
	global
	if (command == "Start")
		command := sEXECmdStart
	else if (command == "Show")
		command := sEXECmdShow
	else if (command == "Hide")
		command := sEXECmdHide
	; else command is blank and EXE is run with a blank command

	Run %sEXEPath% %command%,,UseErrorLevel
	if (ErrorLevel == "ERROR") {
		Msgbox 48, Error, Error: Application path invalid or EXE doesn't exist.
		Gui 4:Destroy
		sSelectedWinID := 0
	} else if (command == sEXECmdHide)
		; don't wait for window if hiding, keep same window ID
		sSelectedWinID := sWindowID
	else {
		WinWait ahk_class %sWindowClass%,,5
		if (ErrorLevel) {
			; class doesn't exist
			sSelectedWinID := 0
			SetTimer Keep_Checking_For_Win, 100
			Msgbox 48, Warning, Application doesn't appear to have started.`nDo nothing to keep waiting,`nor press OK to cancel task.
		} else {
			; class does exist
			WinWait %sWindowTitle% ahk_class %sWindowClass%,,3
			if (ErrorLevel) {
				; title doesn't exist
				SetTimer Keep_Checking_For_Win, 100
				sSelectedWinID := 0
				sSearchWindow := "ahk_class " . sWindowClass
				sWindowListText := "Window Class Found But Not Title"
				Gosub Window_List ; subroutine in Window_List.ahk
			} else {
				; title does exist
				sSelectedWinID := WinExist(sWindowTitle . " ahk_class " . sWindowClass)
				if (sSelectedWinID != 0)
					sSelectedWinID := "ahk_id " . sSelectedWinID
			}
		}
		SetTimer Keep_Checking_For_Win, Off
	}
	return sSelectedWinID
}

;##############################################################################################
; If waiting for window times out, keep checking for it in the background incase it just needed more time.
Keep_Checking_For_Win:
	if (sSelectedWinID != 0)
		SetTimer Keep_Checking_For_Win, Off
	else {
		nWindowIDTemp := WinExist(sWindowTitle . " ahk_class " . sWindowClass)
		if (nWindowIDTemp != 0) {
			SetTimer Keep_Checking_For_Win, Off
			Gui 5:Destroy ; close Window List GUI
			ControlClick Button1, Warning ahk_class #32770
			sSelectedWinID := "ahk_id " . nWindowIDTemp
			SetTimer Msgbox_On_Top, 25
			Msgbox 48, Warning, Window was slow to start but has now been found.`n`nThis message will self-destruct in a few seconds.,4
		}
	}
return
