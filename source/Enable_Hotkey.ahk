;##############################################################################################
; Creates or Removes Hotkey
; Removes current hotkey if the new one is blank, or changes to the new hotkey
; if it is valid and different than the previous one
EnableHotkey(NewHotkey, ByRef CurrentHotkey, GosubLabel) {
	global sShowHideHotkey, sChangeWinHotkey ; necessary for checking if hotkey is already used
	if (NewHotkey == "" && CurrentHotkey != "") {
		; remove old hotkey
		Hotkey %CurrentHotkey%, %GosubLabel%, Off UseErrorLevel
		if (ErrorLevel)
			Msgbox 48, Error (code=%ErrorLevel%), Error disabling previous hotkey: %CurrentHotkey%
		else
			CurrentHotkey := ""
	}
	else if (NewHotkey != CurrentHotkey) {
		; check if hotkey is already in use
		if (NewHotkey == sShowHideHotkey || NewHotkey == sChangeWinHotkey) {
			msgbox Error: hotkey string already in use
			return "ERROR"
		}

		; test if the key string is valid
		Hotkey %NewHotkey%,, UseErrorLevel
		if ErrorLevel in 2,3,4
		{
			; invalid hotkey
			msgbox Error: invalid hotkey string
			return "ERROR"
		}

		; hotkey doesn't exist yet, so create it
		Hotkey %NewHotkey%, %GosubLabel%, On UseErrorLevel 
		if (ErrorLevel) {
			Msgbox 48, Error (code=%ErrorLevel%), Error enabling hotkey: %NewHotkey%
			return "ERROR"
		}

		; new hotkey worked, so unregister old hotkey (if it existed)
		if (CurrentHotkey != "") {
			Hotkey %CurrentHotkey%, %GosubLabel%, Off UseErrorLevel
			if (ErrorLevel)
				Msgbox 48, Error (code=%ErrorLevel%), Error disabling previous hotkey: %CurrentHotkey%
		}
		CurrentHotkey := NewHotkey
	}
	; else either both were blank or there was no change, so do nothing
	return 0
}
