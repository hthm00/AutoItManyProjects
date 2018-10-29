#include <WindowsConstants.au3>
$hwnd = GUICreate("", @DesktopWidth, @DesktopHeight, 0, 0, $WS_POPUP, _
	  BitOR($WS_EX_COMPOSITED, $WS_EX_LAYERED, $WS_EX_TRANSPARENT, $WS_EX_TOPMOST, $WS_EX_TOOLWINDOW), _
	  WinGetHandle(AutoItWinGetTitle()))
GUISetState()
GUISetBkColor(0)
WinSetOnTop($hwnd, "", 1)
; 0 - 200
WinSetTrans($hwnd, "", 200)
HotKeySet("{ESC}", Quit)

While Sleep(10)
WEnd

Func Quit()
   Exit
EndFunc