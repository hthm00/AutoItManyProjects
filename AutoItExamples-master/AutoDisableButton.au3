GUICreate("", 230, 100)
GUICtrlCreateLabel("Nhập đúng 5 kí tự vào Input để nút hiện ra", 10, 10, 210, 50)
$input = GUICtrlCreateInput("", 10, 30, 210, 20)
$btn = GUICtrlCreateButton("Button", 10, 60, 210, 30)
GUICtrlSetState($btn, 128)
GUISetState()
AdlibRegister("setAppropriateButtonState", 250) ; The lower the delay, the more responsive your button is


While Sleep(10)
   Switch GUIGetMsg()
   Case -3
	  Exit
   EndSwitch
WEnd

Func setAppropriateButtonState()
   Static $disabled = True
   If StringLen(GUICtrlRead($input)) = 5 Then
	  If $disabled Then
		 GUICtrlSetState($btn, 64)
		 $disabled = False
	  EndIf
   Else
	  If Not $disabled Then
		 GUICtrlSetState($btn, 128)
		 $disabled = True
	  EndIf
   EndIf
EndFunc