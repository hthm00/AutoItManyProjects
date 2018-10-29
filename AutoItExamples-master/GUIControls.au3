GUICreate ("GUI", 420, 195)
$Button = GUICtrlCreateButton ("Button", 10, 10, 50, 30)
$Checkbox = GUICtrlCreateCheckbox ("Checkbox", 70, 14)
$Radio = GUICtrlCreateRadio ("Radio", 10, 70)
$Date = GUICtrlCreateDate ("Date", 230, 15, 185)

$Edit = GUICtrlCreateEdit ("Edit", 10, 50, 50, 20, 0)
$Input = GUICtrlCreateInput ("Input", 65, 50, 50, 20)

$Combo = GUICtrlCreateCombo ("Dữ liệu 1", 140, 15, 80)
GUICtrlSetData ($Combo, "Dữ liệu 2")
$List = GUICtrlCreateList ("Item1", 120, 50, 50, 100)
GUICtrlSetData ($List, "Item2")

$ListView = GUICtrlCreateListView ("Listview", 180, 50, 100, 95)
$ListViewItem1 = GUICtrlCreateListViewItem ("LV Item1", $ListView)
$ListViewItem2 = GUICtrlCreateListViewItem ("LV Item2", $ListView)

$ShowValue = GUICtrlCreateButton ("Click vào nút này để xem giá trị của các control trên", 10, 150, 400, 40)
GUISetState ()
While Sleep (10)
   Switch GUIGetMsg ()
   Case -3
	  Exit
   Case $ShowValue
	  MsgBox (0, "MessageBox", "GUICtrlRead ($Button) =  " & GUICtrlRead ($Button) & @CRLF & _
	  "GUICtrlRead ($Checkbox) = " & GUICtrlRead ($Checkbox) & @CRLF & _
	  "GUICtrlRead ($Radio) = " & GUICtrlRead ($Radio) & @CRLF & _
	  "GUICtrlRead ($Date) = " & GUICtrlRead ($Date) & @CRLF & _
	  "GUICtrlRead ($Edit) = " & GUICtrlRead ($Edit) & @CRLF & _
	  "GUICtrlRead ($Input) = " & GUICtrlRead ($Input) & @CRLF & _
	  "GUICtrlRead ($Combo) = " & GUICtrlRead ($Combo) & @CRLF & _
	  "GUICtrlRead ($List) = " & GUICtrlRead ($List) & @CRLF & _
	  "GUICtrlRead ($ListView) = " & GUICtrlRead ($ListView) & @CRLF & _
	  "GUICtrlRead ($ListViewItem1) = " & GUICtrlRead ($ListViewItem1) & @CRLF & _
	  "$ListViewItem1 = " & $ListViewItem1 & @CRLF & _
	  "$ListViewItem2 = " & $ListViewItem2)
   EndSwitch
WEnd