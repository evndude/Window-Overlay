;##############################################################################################
; Change window transparency, and also size and position if they are altered.
Change_Transparency:
	if (bIsBusy == true || bFindWindowBusy == true) {
		SetTimer Msgbox_On_Top, 25
		Msgbox 48, Warning, Change Transparency not available.`nFinish current task before another can be executed.
		return
	}
	Send !{Escape} ; makes previous window active so it's not the tray
	sActiveWindowID := "ahk_id " . WinActive("A")
	ShowWindow("ApplyAttr","UnMin","")
	if (sWindowID == 0)
		return
	bIsChangingTransparency := true
	bIsBusy := true
	WinSet ExStyle, -0x20, %sWindowID% ; click-through temporarily off
	bTransparencyChosen := false
	bTransparencyCancelChange := false
	bTransparencyDisable := false
	nTransparencyLevelTemp := nTransparencyLevel
	Hotkey Up, Change_Transparency_HK1_Increase, On
	Hotkey WheelUp, Change_Transparency_HK1_Increase, On
	Hotkey Down, Change_Transparency_HK2_Decrease, On
	Hotkey WheelDown, Change_Transparency_HK2_Decrease, On
	Hotkey Space, Change_Transparency_HK3_Chosen, On
	Hotkey Escape, Change_Transparency_HK4_Cancel, On
	Hotkey Delete, Change_Transparency_HK5_Disable, On
	SplashTextOn, 272, 266, Change Transparency`, Size and/or Position, 
		( LTrim
			`nPress Up Arrow to increase visibility,
			or Down Arrow to decrease visibility,
			or use the Mouse Wheel.`n			
			Current Level:    %nTransparencyLevelTemp%`% transparent
			`nPress Space Bar to finish,
			Escape to cancel,
			or Delete to disable transparency.
			`nClick-through is temporarily disabled
			so window can also be resized and moved.`n
		)
	Loop {
		if (nTransparencyLevelTemp != nTransparencyLevelPrev || A_Index == 1) {
			if (nTransparencyLevelTemp < 0)
				nTransparencyLevelTemp := 0
			else if (nTransparencyLevelTemp > 100)
				nTransparencyLevelTemp := 100
			nTransparencyLevel8bit := Round(Map(nTransparencyLevelTemp,0,100,255,0)) ; function in Window_Overlay.ahk
			WinSet Transparent, %nTransparencyLevel8bit%, %sWindowID%
			ControlSetText Static1,
				( LTrim
					`nPress Up Arrow to increase visibility,
					or Down Arrow to decrease visibility,
					or use the Mouse Wheel.`n					
					Current Level:    %nTransparencyLevelTemp%`% transparent
					`nPress Space Bar to finish,
					Escape to cancel,
					or Delete to disable transparency.
					`nClick-through is temporarily disabled
					so window can also be resized and moved.`n
				),Change Transparency`, Size and/or Position
		}
		if (bTransparencyChosen == true) {
			nTransparencyLevel := nTransparencyLevelTemp
			IniWrite %nTransparencyLevel%, %sIniFileName%, Settings, Transparency Level
			if (bUseTransparency == false) {
				bUseTransparency := true
				IniWrite %bUseTransparency%, %sIniFileName%, Settings, Use Transparency
			}
			GetSizeAndPosition("Save")
			if (bUseClickThrough == true)
				WinSet ExStyle, +0x20, %sWindowID% ; click-through back on
			break
		}
		if (bTransparencyCancelChange == true) {
			if (bUseTransparency == true) {
				nTransparencyLevel8bit := Round(Map(nTransparencyLevel,0,100,255,0)) ; function in Window_Overlay.ahk
				WinSet Transparent, %nTransparencyLevel8bit%, %sWindowID%
			}
			else
				WinSet Transparent, 255, %sWindowID%
			break
		}
		if (bTransparencyDisable == true) {
			bUseTransparency := false
			IniWrite %bUseTransparency%, %sIniFileName%, Settings, Use Transparency
			WinSet Transparent, 255, %sWindowID% ; using "Off" would also remove click-through
			break
		}
		nTransparencyLevelPrev := nTransparencyLevelTemp
		sleep 50
	}
	SplashTextOff
	Hotkey Up,,Off
	Hotkey WheelUp,,Off
	Hotkey Down,,Off
	Hotkey WheelDown,,Off
	Hotkey Space,,Off
	Hotkey Escape,,Off
	Hotkey Delete,,Off
	bIsChangingTransparency := false
	bIsBusy := false
	IfWinNotActive %sActiveWindowID%
		WinActivate %sActiveWindowID%
return

;##############################################################################################
; Temporary hotkeys
Change_Transparency_HK1_Increase:
	nTransparencyLevelTemp += 5
return

Change_Transparency_HK2_Decrease:
	nTransparencyLevelTemp -= 5
return

Change_Transparency_HK3_Chosen:
	bTransparencyChosen := true
return

Change_Transparency_HK4_Cancel:
	bTransparencyCancelChange := true
return

Change_Transparency_HK5_Disable:
	bTransparencyDisable := true
return
