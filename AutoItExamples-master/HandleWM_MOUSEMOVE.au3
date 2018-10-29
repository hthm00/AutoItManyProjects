#include <WindowsConstants.au3>
#include <WinAPI.au3>

GUICreate("", 500, 300, -1, -1, $WS_POPUP)
GUISetBkColor(0x52FF52)
$pos = GUICtrlCreateLabel("", 10, 10, 50, 50)
GUISetState()
GUIRegisterMsg($WM_MOUSEMOVE, "WM_MOUSEMOVE")

While Sleep(10)
   If GUIGetMsg() = -3 Then Exit
WEnd

Func WM_MOUSEMOVE($hwnd, $msg, $wParam, $lParam)
   $y = _WinAPI_LoWord($lParam)
   $x = _WinAPI_HiWord($lParam)
   GUICtrlSetData($pos, $x & ":" & $y)
   Return 0
EndFunc