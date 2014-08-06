;##############################################################################################
;
; Window Overlay
; 
; by Evan Casey
;
; This AutoHotKey script turns a window into an overlay by making it always on top of other windows,
; with options for mouse click-through, transparency, and maintaining its size and position.
;
; Check out the readme file for more information.
;
; Hosted on GitHub: http://github.com/evndude/Window-Overlay
;
;##############################################################################################

#NoEnv 						; recommended for performance and compatibility with future AutoHotkey releases.
#MaxThreadsPerHotkey 1
#SingleInstance Force 		; only one instance can be run 
SetWorkingDir %A_ScriptDir% ; script uses source directory for files
SetTitleMatchMode 2			; titles can match anywhere
OnExit Exit_Script

sScriptTitle := "Window Overlay"
sIniFileName := "WindowOverlay_Settings.ini"

;##############################################################################################
; Tray setup
Menu, Tray, NoStandard
Menu, Tray, Add, Enable Overlay, Enable_Overlay
Menu, Tray, Add, Hide Overlay, Hide_Overlay
Menu, Tray, Add, Disable Overlay, Disable_Overlay
Menu, Tray, Add, Change Transparency or Position, Change_Transparency
Menu, Tray, Add, Change Window, Change_Window
Menu, Tray, Add, Unhide Any Window, Toggle_Window_Visibilty
Menu, Tray, Add, Settings, Settings
Menu, Tray, Add, About, About
Menu, Tray, Add, Exit && Disable Overlay, Exit_Script
Menu, Tray, Tip, %sScriptTitle%
IfExist icon.ico
	Menu, Tray, Icon, icon.ico
OnMessage(0x404, "ShowTrayMenu") ; enables left-click to show tray menu

;##############################################################################################
; Default values for writing INI
sShowHideHotkey := "^+e"
sChangeWinHotkey := "^+w"
bUseTransparency := true
nTransparencyLevel := 50
bUseClickThrough := true
bUseMinimize := false
bMaintainWinSizeAndPos := true
nWinPosX := ""
nWinPosY := ""
nWinWidth := ""
nWinHeight := ""
sWindowTitle := ""
sWindowClass := ""
sEXEPath := ""
bUseEXECmdLine := false
bUseEXECmdStart := false
sEXECmdStart := ""
bUseEXECmdShow := false
sEXECmdShow := ""
bUseEXECmdHide := false
sEXECmdHide := ""

;##############################################################################################
; Create or Read Ini File
IfNotExist %sIniFileName%
{
	bFirstRun := true
	Gosub Write_INI ; subroutine in Read_Write_INI.ahk
	sShowHideHotkey := "" ; cleared to enable hotkey read from file
	sChangeWinHotkey := "" ; cleared to enable hotkey read from file
	Gosub Settings ; subroutine in Settings.ahk
} else {
	bFirstRun := false
	sShowHideHotkey := "" ; cleared to enable hotkey read from file
	sChangeWinHotkey := "" ; cleared to enable hotkey read from file
	bFromSettings := false
	Gosub Read_INI ; subroutine in Read_Write_INI.ahk
}
UpdateTrayTip()
return ; end of auto-execute section

;##############################################################################################
; Included files
#include Find_Window.ahk
#include Window_List.ahk
#include Show_Hide_Window.ahk
#include Run_EXE.ahk
#include Enable_Hotkey.ahk
#include Change_Window.ahk
#include Change_Transparency.ahk
#include Toggle_Window_Visibilty.ahk
#include Settings.ahk
#include About.ahk
#include GUI_Tooltips.ahk
#include Read_Write_INI.ahk

;##############################################################################################
; Misc. Functions and Subroutines
;##############################################################################################
; Enables left-click to show tray menu
ShowTrayMenu(wParam, lParam) { 
    if (lParam == 0x202)
	    Menu, Tray, Show
}

;##############################################################################################
; Updates the tray tip's window title and class text. Tray text is limited to 127 chars.
; "Window Overlay" = 14; 	"`n`nCurrent Window:`nTitle: " = 25; 	"`nClass: " = 8;	 " (...)" = 6
; count if both under limit = 14+25+8+44+36 = 127 chars; count if both shortened = 14+25+8+36+6+32+6 = 127 chars
UpdateTrayTip() {
	global sWindowTitle,sWindowClass,sScriptTitle
	if (StrLen(sWindowTitle) > 44)
		sWindowTitleTray := SubStr(sWindowTitle,1,36) " (...)"
	else
		sWindowTitleTray := sWindowTitle
	if (StrLen(sWindowClass) > 36)
		sWindowClassTray := SubStr(sWindowClass,1,32) " (...)"
	else
		sWindowClassTray := sWindowClass
	Menu, Tray, Tip, %sScriptTitle%`n`nCurrent Window:`nTitle: %sWindowTitleTray%`nClass: %sWindowClassTray%
}

;##############################################################################################
; Save new window information
SaveNewWindow(WinTitle,WinClass,WinID) {
	global
	sWindowID := WinID
	if (WinTitle == "GetTitle")
		WinGetTitle sWindowTitle, %sWindowID%
	else
		sWindowTitle := WinTitle

	if (WinClass == "GetClass")
		WinGetClass sWindowClass, %sWindowID%
	else
		sWindowClass := WinClass

	WinGet sEXEPathTemp, ProcessPath, %sWindowID%
	if (sEXEPath != sEXEPathTemp) {
		; turn off EXE commands so they aren't run on an EXE they weren't meant for, must be re-enabled from settings.
		sEXEPath := sEXEPathTemp
		bUseEXECmdLine := false
		IniWrite %bUseEXECmdLine%, %sIniFileName%, Settings, Use EXE Command Line
	}

	IniWrite %sWindowTitle%, %sIniFileName%, Settings, Window Title
	IniWrite %sWindowClass%, %sIniFileName%, Settings, Window Class
	IniWrite %sEXEPath%, %sIniFileName%, Settings, EXE Path
	UpdateTrayTip()
}

;##############################################################################################
; Saves window size and position if MaintainWinSizeAndPos is turned on
GetSizeAndPosition(option = "",window = "") {
	global
	if (sWindowID == 0)
		; don't do anything if no window ID
		return

	if (window == "") {
		; use saved window ID
		ShowWindow("","UnMin","")
		WinGetPos nWinPosXTemp, nWinPosYTemp, nWinWidthTemp, nWinHeightTemp, %sWindowID%
	} else {
		; use window parameter
		Unminimize(window) ; function in Show_Hide_Window.ahk
		WinGetPos nWinPosXTemp, nWinPosYTemp, nWinWidthTemp, nWinHeightTemp, %window%
	}
	if (option == "Save")
		if (bMaintainWinSizeAndPos == true) {
			if (nWinPosXTemp != nWinPosX) {
				nWinPosX := nWinPosXTemp
				IniWrite %nWinPosX%, %sIniFileName%, Settings, Win X Pos
			}
			if (nWinPosYTemp != nWinPosY) {
				nWinPosY := nWinPosYTemp
				IniWrite %nWinPosY%, %sIniFileName%, Settings, Win Y Pos
			}
			if (nWinWidthTemp != nWinWidth) {
				nWinWidth := nWinWidthTemp
				IniWrite %nWinWidth%, %sIniFileName%, Settings, Win Width
			}
			if (nWinHeightTemp != nWinHeight) {
				nWinHeight := nWinHeightTemp
				IniWrite %nWinHeight%, %sIniFileName%, Settings, Win Height
			}
		}
}

;##############################################################################################
; Re-map a value from one range (in_min to in_max) to another (out_min to out_max)
Map(x,in_min,in_max,out_min,out_max) {
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
}

;##############################################################################################
; Keeps Msgbox windows on top of other windows, since by default they are shown under SplashText and AlwaysOnTop GUIs
Msgbox_On_Top: 
	IfWinExist Warning ahk_class #32770
	{
		WinSet AlwaysOnTop, On, Warning ahk_class #32770
		SetTimer Msgbox_On_Top, Off
	}
return

;##############################################################################################
; Quotation Mark Encoder/Decoder
; If a string is enclosed in 'single' or "double" quotation marks, the quotes are saved in
; the INI file with the quotes substituted with <single> or <<double>> angle brackets.
; This is necessary because IniRead command automatically strips matching pairs of quotes.
QuotesFix(ByRef string, option) {
	StringLeft left_char,string,1
	StringRight right_char,string,1
	if (option == "Encode") {
		if (left_char == """" && right_char == """") {
			StringTrimLeft string, string, 1
			StringTrimRight string, string, 1
			string = <<%string%>>
		}
		else if (left_char == "'" && right_char == "'") {
			StringTrimLeft string, string, 1
			StringTrimRight string, string, 1
			string = <%string%>
		}
	} else if (option == "Decode") {
		if (left_char == "<" && right_char == ">") {
			StringTrimLeft string, string, 1
			StringTrimRight string, string, 1

			StringLeft left_char,string,1
			StringRight right_char,string,1
			if (left_char == "<" && right_char == ">") {
				StringTrimLeft string, string, 1
				StringTrimRight string, string, 1
				string = "%string%"
			} else
				string = '%string%'
		}
	} else {
		SetTimer Msgbox_On_Top, 25
		Msgbox 48, Warning, Quotes fix received bad parameter:`n`n`t%option%`n`nValid commands are "Encode" and "Decode"
	}
}

;###################################################################################
; Exit script. Unhides window and removes attributes on close.
Exit_Script:
	DetectHiddenWindows On
	if (sWindowID != 0 && WinExist(sWindowID))
	  	if A_ExitReason not in Shutdown,Reload,Single
	  		; if not shutting down, reloading, or replacing the current script instance
			ShowWindow("RemoveAttr")
	ExitApp
return
