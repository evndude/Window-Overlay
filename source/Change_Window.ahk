;##############################################################################################
; Change overlay window selection
; The new window's Title, Class, EXE path, and Position are saved.
Change_Window:
	if (bIsBusy == true || bFindWindowBusy == true) {
		SetTimer Msgbox_On_Top, 25
		Msgbox 48, Warning, Change Window not available.`nFinish current task before another can be executed.
		return
	}

	bIsBusy := true
	bWindowChosen := false
	bCancelWindowChoice := false
	Hotkey Space, Change_Window_HK1_Chosen, On
	Hotkey Escape, Change_Window_HK2_Cancel, On
	SplashTextOn, 400, 250, Choose Window,
		( LTrim
			`nMake desired window active
			and press Space Bar to select it,
			or press Escape to cancel.`n
			Title:`n`n
			Class:`n`n
		)
	loop {
		sActiveWindowID := "ahk_id " . WinActive("A")
		WinGetTitle sActiveWindowTitle, %sActiveWindowID%
		WinGetClass sActiveWindowClass, %sActiveWindowID%
		if (A_Index == 1 || (sActiveWindowTitle != sActiveWindowTitlePrev && sActiveWindowTitle != ""
							&& (sActiveWindowTitle != "Start menu" && sActiveWindowClass != "DV2ControlHost") 
							&& sActiveWindowClass != "Shell_TrayWnd")) {
			ControlSetText Static1,
				( LTrim
					`nMake desired window active
					and press Space Bar to select it,
					or press Escape to cancel.`n
					Title:`n%sActiveWindowTitle%`n
					Class:`n%sActiveWindowClass%`n
				), Choose Window
		}
 		if (bWindowChosen == true) {
 			if (sActiveWindowTitle == "" && sActiveWindowClass = "")
 				 ; do nothing if title and class are blank
 				bWindowChosen := false
 			else {
	 			if (bFirstRun == true)
	 				bFirstRun := false  ; first window chosen
	 			else {
	 				if (sWindowID != 0)
 						; if there was a previous window already found, unhide it
			 			ShowWindow("RemoveAttr") ; function in Show_Hide_Window.ahk
	 			}
				SaveNewWindow(sActiveWindowTitle,sActiveWindowClass,sActiveWindowID) ; function in Window_Overlay.ahk
				GetSizeAndPosition("Save") ; function in Window_Overlay.ahk
				ShowWindow("ApplyAttr","UnMin") ; function in Show_Hide_Window.ahk
				SplashTextOff
	 			break
	 		}
 		}
 		if (bCancelWindowChoice == true) {
 			SplashTextOff
 			break
 		}
 		sActiveWindowTitlePrev := sActiveWindowTitle
 		sleep 100
	}
	Hotkey Space,,Off
	Hotkey Escape,,Off
	bIsBusy := false
return

;##############################################################################################
; Temporary hotkeys
Change_Window_HK1_Chosen:
	bWindowChosen := true
return

Change_Window_HK2_Cancel:
	bCancelWindowChoice := true
return
