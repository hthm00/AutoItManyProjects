#include <GUIMenu.au3>
#include <WindowsConstants.au3>
Global $hGUI = GUICreate("Popup menu", 500, 300)

;~ GUIRegisterMsg($WM_NCLBUTTONDOWN, "WM_NCLBUTTONDOWN") ; Left mouse button
GUIRegisterMsg($WM_NCRBUTTONDOWN, "WM_NCRBUTTONDOWN") ; Right mouse button
GUISetState()

While Sleep(10)
   If GUIGetMsg() = -3 Then Exit
WEnd

Func WM_NCLBUTTONDOWN($hwnd, $msg, $wParam, $lParam)
   If ButtonPressed($hwnd, $msg, $wParam, $lparam) Then Return 0
EndFunc

Func WM_NCRBUTTONDOWN($hwnd, $msg, $wParam, $lParam)
   If ButtonPressed($hwnd, $msg, $wParam, $lparam) Then Return 0
EndFunc

Func ButtonPressed($hwnd, $msg, $wParam, $lParam)
   If $wParam = 2 Then ; HTCAPTION
	  $tPoint = _WinAPI_GetMousePos()
	  Local $hMenu = _GUICtrlMenu_CreatePopup()
	  _GUICtrlMenu_AppendMenu($hMenu, 0, 11, "Item1")
	  _GUICtrlMenu_AppendMenu($hMenu, 0, 12, "Item2")
	  _GUICtrlMenu_AppendMenu($hMenu, 0, 13, "Item3")
	  _GUICtrlMenu_TrackPopupMenu($hMenu, $hGUI, DllStructGetData($tPoint, "x"), DllStructGetData($tPoint, "y"))
	  _GUICtrlMenu_DestroyMenu($hMenu)
	  Return 1
   EndIf
EndFunc