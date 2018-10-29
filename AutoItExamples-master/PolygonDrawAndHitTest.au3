;~ Vẽ một đa giác và kiểm tra xem điểm người dùng vừa click nằm trong hay ngoài đa giác
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <GDIPlus.au3>

$SoCanh = InputBox("", "Nhập số cạnh của đa giác: ", "3")
If @error Then Exit
$SoCan = Number($SoCanh)
MsgBox(0, "", "Đã lưu số cạnh, click vào các điểm bất kỳ trên GUI để vẽ")
If $SoCanh < 3 Then Exit MsgBox (16, "Error", "Số cạnh tối thiểu phải bằng 3") And 0
Global $aPoints[$SoCanh + 1][2], $k = 1
$aPoints[0][0] = $SoCanh

_GDIPlus_Startup()

$hGUI = GUICreate("", 500, 300)
GUIRegisterMsg($WM_LBUTTONUP, "SetPoint")
GUIRegisterMsg($WM_PAINT, "Paint")
GUISetState()

Global $hGraph = _GDIPlus_GraphicsCreateFromHWND($hGUI)
Global $hPen = _GDIPlus_PenCreate(0xFF0DFD00, 4)
Global $hBrush = _GDIPlus_BrushCreateSolid(0xFFADAFFF)

While Sleep(10)
   If GUIGetMsg() = -3 Then ExitLoop
WEnd

_GDIPlus_BrushDispose($hBrush)
_GDIPlus_PenDispose($hPen)
_GDIPlus_GraphicsDispose($hGraph)
_GDIPlus_Shutdown()

Func Paint()
   For $i = 2 To $k - 1
	  _GDIPlus_GraphicsDrawLine($hGraph, $aPoints[$i-1][0], $aPoints[$i-1][1], $aPoints[$i][0], $aPoints[$i][1], $hPen)
   Next
   If $k > $SoCanh Then
	  _GDIPlus_GraphicsDrawLine($hGraph, $aPoints[$k-1][0], $aPoints[$k-1][1], $aPoints[1][0], $aPoints[1][1], $hPen)
	  _GDIPlus_GraphicsFillPolygon($hGraph, $aPoints, $hBrush)
   EndIf
EndFunc

Func SetPoint($hwnd, $msg, $wParam, $lParam)
   $aPoints[$k][0] = _WinAPI_LoWord($lParam)
   $aPoints[$k][1] = _WinAPI_HiWord($lParam)

   If $k > 1 Then _GDIPlus_GraphicsDrawLine($hGraph, $aPoints[$k-1][0], $aPoints[$k-1][1], $aPoints[$k][0], $aPoints[$k][1], $hPen)
   $k += 1

   If $k > $SoCanh Then
	  _GDIPlus_GraphicsDrawLine($hGraph, $aPoints[$k-1][0], $aPoints[$k-1][1], $aPoints[1][0], $aPoints[1][1], $hPen)
	  _GDIPlus_GraphicsFillPolygon($hGraph, $aPoints, $hBrush)
	  MsgBox(0, "", "Đã vẽ xong, click một điểm bất kỳ để kiểm tra xem điểm đó nằm trong hay ngoài đa giác vừa vẽ (có thể click nhiều lần)")
	  GUIRegisterMsg($WM_LBUTTONUP, "")
	  GUIRegisterMsg($WM_LBUTTONUP, "TestPoint")
   EndIf
   Return 0
EndFunc

; Thuật toán lấy từ Google
Func isLeft($x0, $y0, $x1, $y1, $x2, $y2)
   Return ( ($x1 - $x0) * ($y2 - $y0) - ($x2 - $x0) * ($y1 - $y0) )
EndFunc

Func TestPoint($hwnd, $msg, $wParam, $lParam)
   Local $x = _WinAPI_LoWord($lParam)
   Local $y = _WinAPI_HiWord($lParam)
   Local $WN = 0
   For $i = 1 To $k - 2
	  If ($aPoints[$i][1] <= $y) Then
		 If ($aPoints[$i+1][1] > $y) And (isLeft($aPoints[$i][0], $aPoints[$i][1], $aPoints[$i+1][0], $aPoints[$i+1][1], $x, $y) > 0) Then $WN += 1
	  Else
		 If ($aPoints[$i+1][1] <= $y) And (isLeft($aPoints[$i][0], $aPoints[$i][1], $aPoints[$i+1][0], $aPoints[$i+1][1], $x, $y) < 0) Then $WN -= 1
	  EndIf
   Next

   If ($aPoints[$k-1][1] <= $y) Then
	  If ($aPoints[0][1] > $y) And (isLeft($aPoints[$k-1][0], $aPoints[$k-1][1], $aPoints[0][0], $aPoints[0][1], $x, $y) > 0) Then $WN += 1
   Else
	  If ($aPoints[0][1] <= $y) And (isLeft($aPoints[$k-1][0], $aPoints[$k-1][1], $aPoints[0][0], $aPoints[0][1], $x, $y) < 0) Then $WN -= 1
   EndIf

   Return MsgBox(0, "Thông báo", "Điểm vừa click nằm " & ($WN ? "trong" : "ngoài") & " hình vừa vẽ") And 0
EndFunc