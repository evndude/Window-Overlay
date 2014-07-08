#SingleInstance force
;##############################################################################################
; Launches the About GUI
About:
	Gui 2:Default
	Gui +AlwaysOnTop -Resize -MaximizeBox -MinimizeBox
	Gui Font, s12 w400 bold
	Gui Add, Text, x104, Window Overlay v1.0
	Gui Font, norm
	Gui Add, Text, y+12 x15, This AutoHotKey script turns a window into
	Gui Add, Text, y+4, an overlay by making it always on top of other
	Gui Add, Text, y+4, windows, with options for mouse click-through,
	Gui Add, Text, y+4, transparency, and maintaining its size && position.
	Gui Add, Text, y+20, Made by Evan Casey.
	Gui Add, Text, y+20, Hosted on GitHub: 
	Gui Font, underline
	Gui Add, Text, y+4 cBlue gA_Launch_Github, http://github.com/evndude/Window-Overlay
	Gui Font, norm bold
	Gui Add, Button, y+14 xp+136 w80 g2GuiClose Default, &OK
	Gui Show, Center, About %sScriptTitle%

	IfWinNotExist %sScriptTitle% Settings
	{
		; load pointing finger mouse pointer
		hCurs := DllCall("LoadCursor","UInt",NULL,"Int",32649,"UInt")
		; enable function to notify to the window that the mouse has moved
		OnMessage(0x200, "GUI_Tooltips") ; function in GUI_Tooltips.ahk
	}
return

;##############################################################################################
; Close About GUI
2GuiEscape:
2GuiClose:
	Gui Destroy
	IfWinNotExist %sScriptTitle% Settings
	{
		DllCall("DestroyCursor","Uint",hCurs)
		OnMessage(0x200,"")
	}
return

;##############################################################################################
; Launch GitHub repository in default web browser
A_Launch_Github:
	Run http://github.com/evndude/Window-Overlay
return
