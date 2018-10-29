#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

GUICreate("Color Detector", 200, 130)
GUICtrlCreateLabel("Red: ", 10, 10)
$red = GUICtrlCreateInput("", 50, 10, 60)
GUICtrlCreateLabel("Green: ", 10, 40)
$green = GUICtrlCreateInput("", 50, 40, 60)
GUICtrlCreateLabel("Blue: ", 10, 70)
$blue = GUICtrlCreateInput("", 50, 70, 60)
GUICtrlCreateLabel("Hex: ", 10, 100)
$hex = GUICtrlCreateInput("", 50, 100, 60)
$sample = GUICtrlCreateLabel("", 120, 30, 70, 70, -1, $WS_EX_DLGMODALFRAME)
GUICtrlSetBkColor($sample, 0)
GUISetState()

While Sleep(50)
   DisplayColorValue($red, $green, $blue, $hex, $sample)
   Switch GUIGetMsg()
   Case -3
	  Exit
   EndSwitch
WEnd

Func DisplayColorValue($r, $g, $b, $h, $sample)
   Local $pos = MouseGetPos()
   Local $color = PixelGetColor($pos[0], $pos[1])
   GUICtrlSetData($r, Red($color))
   GUICtrlSetData($g, Green($color))
   GUICtrlSetData($b, Blue($color))
   GUICtrlSetData($h, "#" & Hex($color, 6))
   GUICtrlSetBkColor($sample, $color)
EndFunc



Func Red($color)
   Return BitShift(BitAND($color, 0xFF0000), 16)
EndFunc

Func Green($color)
   Return BitShift(BitAND($color, 0x00FF00), 8)
EndFunc

Func Blue($color)
   Return BitAND($color, 0x0000FF)
EndFunc