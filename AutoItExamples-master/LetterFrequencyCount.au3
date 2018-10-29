#include <GUIRichEdit.au3>
#include <WindowsConstants.au3>
Global $hwnd = GUICreate("", 500, 400)
Global $count = GUICtrlCreateButton("Đếm", 10, 220, 480, 30)
Global $input = _GUICtrlRichEdit_Create($hwnd, "", 10, 10, 480, 200, _
	  BitOR($ES_AUTOHSCROLL, $ES_AUTOVSCROLL, $WS_HSCROLL, $WS_VSCROLL, $ES_MULTILINE, $ES_WANTRETURN))
Global $list = GUICtrlCreateListView("Kí tự|Số lần xuất hiện", 10, 260, 480, 130)
GUISetState()

While Sleep(10)
   Switch GUIGetMsg()
   Case -3
	  Exit
   Case $count
	  ListFrequency(_GUICtrlRichEdit_GetText($input))
   EndSwitch
WEnd

Func ListFrequency($s)
   Local $key = ""
   Local $count[1]

   For $c In StringSplit($s, "", 3)
	  If Not StringInStr($key, $c, 1) Then
		 $key &= $c
		 ReDim $count[StringLen($key)]
	  EndIf
	  $count[StringInStr($key, $c, 1) - 1] += 1
   Next
   GUICtrlDelete($list)
   $list = GUICtrlCreateListView("Kí tự|Số lần xuất hiện", 10, 260, 480, 130)
   GUICtrlRegisterListViewSort(-1, Sort)
   For $i = 0 To UBound($count) - 1
	  GUICtrlCreateListViewItem(StringMid($key, $i + 1, 1) & "|" & $count[$i], $list)
   Next
EndFunc

Func Sort($hWnd, $idItem1, $idItem2, $idColumn)
   Local $s1 = StringSplit(GUICtrlRead($idItem1), "|", 3)
   Local $s2 = StringSplit(GUICtrlRead($idItem2), "|", 3)

   Return ($idColumn = 0 ? $s1[0] > $s2[0] : Number($s1[1]) > Number($s2[1]))
EndFunc