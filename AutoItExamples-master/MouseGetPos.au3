GUICreate("", 70, 70, -1, -1, 0x80000000)
GUISetBkColor(0x1F3F5F)
GUICtrlSetDefColor(0xFFFFAF)

GUICtrlCreateLabel("", 0, 0, 70, 70, -1, 0x00100000)

GUICtrlCreateLabel("x: ", 10, 10, 50, 20)
$x = GUICtrlCreateLabel("", 30, 10, 50, 20)

GUICtrlCreateLabel("y: ", 10, 30, 50, 20)
$y = GUICtrlCreateLabel("", 30, 30, 50, 20)

GUICtrlCreateLabel("Exit (ESC)", 10, 50, 50, 20)
GUISetState()

HotKeySet("F1", "GetPos")
Local $pos

While Sleep(50)
   $pos = MouseGetPos()
   GUICtrlSetData($x, $pos[0])
   GUICtrlSetData($y, $pos[1])
   Switch GUIGetMsg()
   Case -3
	  Exit
   EndSwitch
WEnd

Func GetPos()
EndFunc