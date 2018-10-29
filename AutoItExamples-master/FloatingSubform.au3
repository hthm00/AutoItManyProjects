;Tạo 2 GUI
$GUI1 = GUICreate("", 500, 300)
$GUI2 = GUICreate("", 150, 500)
Global $Show = 0
;Cho hiện GUI chính
GUISetState(@SW_SHOW, $GUI1)

;Vào vòng lặp chính của chương trình
While 1
   ;Lấy tọa độ chuột (cả x và y), lấy tọa độ GUI1 để so sánh
   $mousepos = MouseGetPos()
   $GUIPos = WinGetPos($GUI1)

   Select
	  ; Nếu chuột đang chỉ vào GUI chính thì cho hiện GUI phụ
   Case $mousepos[0] >= $GUIPos[0] _
	     And $mousepos[0] <= $GUIPos[0] + $GUIPos[2] _
	     And $mousepos[1] >= $GUIPos[1] _
	     And $mousepos[1] <= $GUIPos[1] + $GUIPos[3]
	     Show()
	  ; Nếu chuột chỉ ra ngoài thì cho ẩn GUI phụ đi
   Case ($mousepos[0] < $GUIPos[0] Or $mousepos[0] > $GUIPos[0] + $GUIPos[2]) _
	  Or ($mousepos[1] < $GUIPos[1] Or $mousepos[1] > $GUIPos[1] + $GUIPos[3])
	  Hide()
   EndSelect
   ;phần này như bình thường
   Switch GUIGetMsg()
   Case -3
	  Exit
   EndSwitch
WEnd

Func Show()
   If Not $show Then
	  ; Lấy tọa độ 2 GUI
	  Local $p1 = WinGetPos($GUI1)
	  Local $p2 = WinGetPos($GUI2)

	  ;Cho hiện GUI trước khi di chuyển GUI ra
	  GUISetState(@SW_SHOW, $GUI2)
	  For $i = 0 To $p2[2] Step 5
		 Sleep(5)
		 WinMove($GUI2, "", $p1[0] + $p1[2], $p2[1], $i, $p2[3])
	  Next
	  $show = 1
   EndIf
EndFunc

Func Hide()
   If $show Then
	  ;Lấy tọa độ của 2 GUI
	  Local $p1 = WinGetPos($GUI1)
	  Local $p2 = WinGetPos($GUI2)

	  ;Di chuyển GUI vào trước khi ẩn GUI
	  For $i = 0 To $p2[2] Step 5
		 Sleep(5)
		 WinMove($GUI2, "", $p1[0] + $p1[2], $p2[1], $p2[2] - $i, $p2[3])
	  Next

	  ;Ẩn GUI
	  GUISetState(@SW_HIDE, $GUI2)
	  ;Trả GUI về kích thước ban đầu
	  WinMove($GUI2, "", $p2[0], $p2[1], $p2[2], $p2[3])
	  $show = 0
   EndIf
EndFunc