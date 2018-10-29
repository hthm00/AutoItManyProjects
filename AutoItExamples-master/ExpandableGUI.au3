$GUI = GUICreate("", 300, 50)
$expand = GUICtrlCreateButton("Mở rộng", 10, 10, 280, 30)
GUICtrlSetResizing($expand, 802) ; $GUI_DOCKALL
GUISetState()

While Sleep(50)
   Switch GUIGetMsg()
   Case -3
	  Exit
   Case $expand
	  Expand()
   EndSwitch
WEnd

Func Expand()
   Local $pos = WinGetPos($GUI)
   If GUICtrlRead($expand) == "Mở rộng" Then
	  GUICtrlSetData($expand,  "Thu nhỏ")
	  WinMove($GUI, "", $pos[0], $pos[1], $pos[2], $pos[3] + 200)
   Else
	  GUICtrlSetData($expand,  "Mở rộng")
	  WinMove($GUI, "", $pos[0], $pos[1], $pos[2], $pos[3] - 200)
   EndIf
EndFunc