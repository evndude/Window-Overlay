;##############################################################################################
; Creates or Removes Hotkey
; Removes current hotkey if the new one is blank, or changes to the new hotkey
; if it is valid and different than the previous one
EnableHotkey(NewHotkey, ByRef CurrentHotkey, GosubLabel) {
	if (NewHotkey == "" && CurrentHotkey != "") {
		; remove old hotkey
		Hotkey %CurrentHotkey%, %GosubLabel%, Off UseErrorLevel
		if (ErrorLevel)
			Msgbox 48, Error (code=%ErrorLevel%), Error disabling previous hotkey: %CurrentHotkey%
		else
			CurrentHotkey := ""
	}
	else if (NewHotkey != CurrentHotkey) {
		; test if the key string is valid, label is good, and not modifying existing hotkey
		Hotkey %NewHotkey%,, UseErrorLevel
		if ErrorLevel in 2,3,4
		{
			; invalid hotkey
			msgbox Error: invalid hotkey string
			return "ERROR"
		} else { 
			; hotkey doesn't exist yet, so create it
			Hotkey %NewHotkey%, %GosubLabel%, On UseErrorLevel 
			if (ErrorLevel) {
				Msgbox 48, Error (code=%ErrorLevel%), Error enabling hotkey: %NewHotkey%
				return "ERROR"
			} else {
				; if new hotkey worked, unregister old hotkey (if it existed)
				if (CurrentHotkey != "") {
					Hotkey %CurrentHotkey%, %GosubLabel%, Off UseErrorLevel
					if (ErrorLevel)
						Msgbox 48, Error (code=%ErrorLevel%), Error disabling previous hotkey: %CurrentHotkey%
				}
				CurrentHotkey := NewHotkey
			}
		}
	}
	; else either both were blank or there was no change, so do nothing
	return 0
}
