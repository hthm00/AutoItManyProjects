GUICreate("")
$Menu = GUICtrlCreateMenu("Menu") ; Trống tham số 2, nó xuất hiện ở menu bar
$Submenu = GUICtrlCreateMenu("Submenu", $Menu) ; Có tham số 2, nó xuất hiện trong menu $Menu
$Submenu2 = GUICtrlCreateMenu("Submenu2", $Submenu) ; Có tham số 2, nó xuất hiện trong menu $SubMenu
$SubmenuItem = GUICtrlCreateMenuItem("Submenu Item", $Submenu2)
GUISetState()

While Sleep(10)
   If GUIGetMsg() = -3 Then Exit
WEnd