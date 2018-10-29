#include <WinAPISys.au3>
#include <WindowsConstants.au3>

HotKeySet("{F1}", Sendkey)
HotKeySet("{ESC}", Quit)

$pNotepad = Run("notepad")
$hNotepad = WinWait("[CLASS:Notepad]")
Global $hWnd = ControlGetHandle($hNotepad, "", "Edit1") ; Window nhận message là cái Edit, không phải Notepad

While Sleep(10)
WEnd


Func Sendkey()
   Local $hTimer = TimerInit()
   _Send("Hello")
   ConsoleWrite(TimerDiff($hTimer) & " elapsed" & @CRLF)
EndFunc

Func _Send($string)
   For $char In StringSplit($string, "", 3)
	  _SendCharMsg(Asc($char))
   Next
EndFunc

Func _SendCharMsg($keycode)
   ; SendMessage sẽ chờ xử lý event, còn PostMessage thì không. Dùng thế này tăng tốc cho chương trình
   _WinAPI_PostMessage($hwnd, $WM_CHAR, $keycode, 0)
EndFunc

Func Quit()
   ProcessClose($pNotepad)
   Exit
EndFunc