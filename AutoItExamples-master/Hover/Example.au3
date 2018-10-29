#NoTrayIcon
#include "Hover.au3"
Global $width = 700, $height = 500, $defColor = 0xC5C5FF
$hwnd = GUICreate("", $width, $height, -1, -1, 0x80000000)
GUISetBkColor(0xC596F0)
GUISetFont(16)
GUICtrlSetDefColor($defColor)
GUICtrlSetDefBkColor(-2)
GUICtrlCreatePic("bk.jpg", 0, 0, $width, $height)
GUICtrlSetState(-1, 128)

$Install = GUICtrlCreateLabel("Cài đặt", 50, 50)
$Help = GUICtrlCreateLabel("Xem hướng dẫn", 50, 100, 200)
$Exit = GUICtrlCreateLabel("Thoát", 50, 150)
GUISetState()

HoverRegisterWindow($hwnd)
HoverRegisterControl($Install, WinGetPos(ControlGetHandle($hwnd, "", $Install)), OnHover, OnUnhover)
HoverRegisterControl($Help, WinGetPos(ControlGetHandle($hwnd, "", $Help)), OnHover, OnUnhover)
HoverRegisterControl($Exit, WinGetPos(ControlGetHandle($hwnd, "", $Exit)), OnHover, OnUnhover)

While Sleep(50)
   HoverProc()

   Switch GUIGetMsg()
   Case -3, $Exit
	  Exit
   Case $Install
	  MsgBox(0x2000, "Clicked", "Cài đặt")
   Case $Help
	  MsgBox(0x2000, "Clicked", "Hướng dẫn")
   EndSwitch
WEnd

Func OnHover($ctl)
   GUICtrlSetFont($Ctl, Default, 700, BitOR(2, 4))
   GUICtrlSetColor($Ctl, 0x00FFFF)
   GUISetCursor(0, 1)
EndFunc
Func OnUnhover($ctl)
   GUICtrlSetFont($Ctl, Default, 400, 0)
   GUICtrlSetColor($Ctl, $defColor)
   GUISetCursor(2, 1)
EndFunc