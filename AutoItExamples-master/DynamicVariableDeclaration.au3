GUICreate("", 270, 290)
$lv = GUICtrlCreateListView("Tên biến|Giá trị", 10, 10, 250, 180)
GUICtrlCreateLabel("Tên biến: ", 10, 200)
$name = GUICtrlCreateInput("", 60, 197, 70, 20)
GUICtrlCreateLabel("Giá trị: ", 150, 200)
$value = GUICtrlCreateInput("", 185, 197, 70, 20)
$add = GUICtrlCreateButton("Thêm biến", 10, 230, 250)
$test = GUICtrlCreateButton("In giá trị của $abc", 10, 260, 250)
GUISetState()

While Sleep(10)
   Switch GUIGetMsg()
   Case -3
	  Exit
   Case $add
	  Local $sName = GUICtrlRead($name), $sValue = GUICtrlRead($value)
	  Assign($sName, $sValue, 2)
	  GUICtrlCreateListViewItem($sName & "|" & $sValue, $lv)
	  GUICtrlSetData($name, "")
	  GUICtrlSetData($value, "")
   Case $test
	  MsgBox(0, "", $abc)
   EndSwitch
WEnd