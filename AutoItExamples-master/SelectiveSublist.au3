$hwnd = GUICreate("", 500, 300)

;Main list
$list = GUICtrlCreateList("A", 10, 10, 100, 50)
GUICtrlSetData($list, "B")
GUICtrlSetData($list, "C")
;Blank list
$blank = GUICtrlCreateList("", 120, 10, 100, 50)
;Sublist1
$subA = GUICtrlCreateList("Sublist A Item1", 120, 10, 100, 50)
GUICtrlSetData($subA, "Sublist A Item2")
GUICtrlSetData($subA, "Sublist A Item3")
GUICtrlSetState($subA, 32)
;Sublist2
$subB = GUICtrlCreateList("Sublist B Item1", 120, 10, 100, 50)
GUICtrlSetData($subB, "Sublist B Item2")
GUICtrlSetData($subB, "Sublist B Item3")
GUICtrlSetState($subB, 32)
;Sublist3
$subC = GUICtrlCreateList("Sublist C Item1", 120, 10, 100, 50)
GUICtrlSetData($subC, "Sublist C Item2")
GUICtrlSetData($subC, "Sublist C Item3")
GUICtrlSetState($subC, 32)

Global $currentList = "", $listRead = ""
GUISetState()
ControlClick($hwnd, "", $list, "left", 1, 1, 1)

While Sleep(10)
   Switch GUIGetMsg()
   Case -3
	  Exit
   Case $list
	  If $blank Then
		 GUICtrlDelete($blank)
		 $blank = 0
	  EndIf
	  $listRead = GUICtrlRead($list)
	  If $listRead <> $currentList Then
		 Execute("GUICtrlSetState($sub" & $currentList & ", 32)")
		 Execute("GUICtrlSetState($sub" & $listRead & ", 16)")
		 $currentList = $listRead
	  EndIf
   EndSwitch
WEnd