#include <Misc.au3>
#include <ScreenCapture.au3>
#include <WindowsConstants.au3>
;~ _Singleton(@ScriptName)

Global $cancelled
HotKeySet("{F2}", Quit)
HotKeySet("{F1}", Capture)

While Sleep(10)
WEnd


Func Min($a, $b)
   Return $a > $b ? $b : $a
EndFunc

Func Max($a, $b)
   Return $a < $b ? $b : $a
EndFunc

Func EscPressed()
   $cancelled = True
EndFunc

Func Cancel($hwnd)
   GUIDelete($hwnd)
   HotKeySet("{ESC}")
EndFunc

Func Capture()
   Local $pane = GUICreate("ScreenCapture", @DesktopWidth, @DesktopHeight, 0, 0, $WS_POPUP, $WS_EX_TOPMOST, _
						   WinGetHandle(AutoItWinGetTitle()))
   GUISetBkColor(0, $pane)
   GUISetState()
   WinSetTrans($pane, "", 30)
   $cancelled = False
   HotKeySet("{ESC}", EscPressed)

   While Not _IsPressed("01") ; Wait for user to press the left mouse button
	  Sleep(10)
	  If $cancelled Then Return Cancel($pane)
   WEnd
   Local $start = MouseGetPos()
   Local $label = GUICtrlCreateLabel("", $start[0], $start[1])
   GUICtrlSetBkColor($label, 0xFFFFFF)
   While _IsPressed("01")
	  Sleep(50)
	  If $cancelled Then Return Cancel($pane)
	  Local $current = MouseGetPos()
	  GUICtrlSetPos($label, Min($start[0], $current[0]), Min($start[1], $current[1]), _
			Abs($start[0] - $current[0]), Abs($start[1] - $current[1]))
   WEnd
   Cancel($pane)
   $end = MouseGetPos()
   Local $x1 = Min($start[0], $end[0]), $x2 = Min($start[1], $end[1])
   Local $y1 = Max($start[0], $end[0]), $y2 = Max($start[1], $end[1])
   Local $screen = _ScreenCapture_Capture("", $x1, $x2, $y1, $y2, False)

   Local $path = FileSaveDialog("Save image as...", "", "PNG (*.png)", 2 + 16, "untitled.png")
   If @error Then Return
   Sleep(20)
   _ScreenCapture_SaveImage($path, $screen)
   Sleep(100)
EndFunc

Func Quit()
   Exit
EndFunc