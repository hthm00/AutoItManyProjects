#include <GUIConstantsEx.au3>

GUICreate("Color Mixer", 500, 110)
GUICtrlCreateLabel("R: ", 10, 15)
$RSlider = GUICtrlCreateSlider(20, 10, 255, 25)
GUICtrlSetLimit($RSlider, 255, 0)
$RValue = GUICtrlCreateLabel("0", 280, 15, 20)

GUICtrlCreateLabel("G: ", 10, 45)
$GSlider = GUICtrlCreateSlider(20, 40, 255, 25)
GUICtrlSetLimit($GSlider, 255, 0)
$GValue = GUICtrlCreateLabel("0", 280, 45, 20)

GUICtrlCreateLabel("B: ", 10, 75)
$BSlider = GUICtrlCreateSlider(20, 70, 255, 25)
GUICtrlSetLimit($BSlider, 255, 0)
$BValue = GUICtrlCreateLabel("0", 280, 75, 20)

$Copy = GUICtrlCreateButton("Copy", 305, 15, 55)
$ColorValue = GUICtrlCreateLabel("#000000", 310, 45, -1, 15)
$Reset = GUICtrlCreateButton("Reset", 305, 65, 55)
$ColorZone = GUICtrlCreateLabel("", 370, 10, 120, 80)
GUICtrlSetBkColor($ColorZone, 0)
GUISetState()


While Sleep(10)
   Switch GUIGetMsg()
   Case -3
	  Exit
   Case $RSlider
	  GUICtrlSetData($RValue, GUICtrlRead($RSlider))
	  UpdateColor()
   Case $GSlider
	  GUICtrlSetData($GValue, GUICtrlRead($GSlider))
	  UpdateColor()
   Case $BSlider
	  GUICtrlSetData($BValue, GUICtrlRead($BSlider))
	  UpdateColor()
   Case $Copy
	  ClipPut(StringTrimLeft(GUICtrlRead($ColorValue), 1))
	  ToolTip("Color value successfully copied to clipboard")
	  Sleep(400)
	  ToolTip("")
   Case $Reset
	  Reset()
   EndSwitch
WEnd

Func Reset()
   GUICtrlSetData($RSlider, 0)
   GUICtrlSetData($GSlider, 0)
   GUICtrlSetData($BSlider, 0)
   GUICtrlSetData($RValue, 0)
   GUICtrlSetData($GValue, 0)
   GUICtrlSetData($BValue, 0)
   UpdateColor()
EndFunc

Func UpdateColor()
   Local $RRead = GUICtrlRead($RSlider)
   Local $GRead = GUICtrlRead($GSlider)
   Local $BRead = GUICtrlRead($BSlider)
   Local $RGBColor = Hex($RRead, 2) & Hex($GRead, 2) & Hex($BRead, 2)
   GUICtrlSetData($ColorValue, "#" & $RGBColor)
   GUICtrlSetBkColor($ColorZone, "0x" & $RGBColor)
EndFunc