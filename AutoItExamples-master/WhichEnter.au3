;~ Câu hỏi đầy thách thức của ad Phạm Tuyên :)) Phân biệt giữa phím Enter và Numpad Enter

#include <WinAPI.au3>
#include <WindowsConstants.au3>
HotKeySet("{ESC}", Quit)
Global $hStub_KeyProc = DllCallbackRegister("_KeyProc", "long", "int;wparam;lparam")
Local $hMod = _WinAPI_GetModuleHandle(Null)
Global $hHook = _WinAPI_SetWindowsHookEx($WH_KEYBOARD_LL, DllCallbackGetPtr($hStub_KeyProc), $hMod)

While 1
   Sleep(10)
WEnd

Func _KeyProc($nCode, $wParam, $lParam)
   Local $tKEYHOOKS = DllStructCreate($tagKBDLLHOOKSTRUCT, $lParam)
   If $nCode < 0 Then Return _WinAPI_CallNextHookEx($hHook, $nCode, $wParam, $lParam)
   If $wParam = $WM_KEYDOWN And DllStructGetData($tKEYHOOKS, "vkCode") = 0x0D Then
	  If DllStructGetData($tKEYHOOKS, "flags") Then
		 ConsoleWrite("Numpad Enter" & @CRLF)
	  Else
		 ConsoleWrite("Standard Enter" & @CRLF)
	  EndIf
   EndIf
   Return _WinAPI_CallNextHookEx($hHook, $nCode, $wParam, $lParam)
EndFunc ;===> _KeyProc

Func Quit()
   _WinAPI_UnhookWindowsHookEx($hHook)
   DllCallbackFree($hStub_KeyProc)
   Exit
EndFunc