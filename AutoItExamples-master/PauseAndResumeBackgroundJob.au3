GUICreate("This is a GUI", 270, 100)
$Toggle = GUICtrlCreateButton("Pause/Continue", 10, 10, 250, 50)
$Number = GUICtrlCreateLabel("0", 10, 75, 50)
$Clear = GUICtrlCreateButton("Clear", 80, 70, 100)
GUISetState()

Global $Paused = False

While Sleep(50)
   ; These lines will always be executed
   $msg = GUIGetMsg()
   Switch $msg
   Case -3
	  Exit
   Case $Toggle
	  Toggle()
   EndSwitch
   If $Paused Then ContinueLoop

   ; If paused, these lines will not (i.e: the "Clear" button does not work when paused)
   GUICtrlSetData($Number, GUICtrlRead($Number) + 0.1)
   Switch $msg
   Case $Clear
	  GUICtrlSetData($Number, 0)
   EndSwitch
WEnd

Func Toggle()
   $Paused = Not $Paused
EndFunc