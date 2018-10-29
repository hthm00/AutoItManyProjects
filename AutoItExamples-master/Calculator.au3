#include <GUIConstants.au3>
#include <WinAPI.au3>

;~ Note: Multiple clicks on "=" button does not re-perform the last operation like the original program.

$hGUI = GUICreate("AutoIt Calculator", 260, 225)

#Region Menu (suffix _m)
$hEdit_m = GUICtrlCreateMenu("Edit")
$hCopy = GUICtrlCreateMenuItem("Copy	Ctrl + C", $hEdit_m)
$hPaste = GUICtrlCreateMenuItem("Paste	Ctrl + V", $hEdit_m)

$hView_m = GUICtrlCreateMenu("View")
$hStandard = GUICtrlCreateMenuItem("Standard", $hView_m)
$hScientific = GUICtrlCreateMenuItem("Scientific", $hView_m)
GUICtrlCreateMenuItem("", $hView_m) ; Separator
$hGrouping = GUICtrlCreateMenuItem("Digit grouping", $hView_m)

$hHelp_m = GUICtrlCreateMenu("Help")
$hHelp = GUICtrlCreateMenuItem("Help", $hHelp_m)
GUICtrlCreateMenuItem("", $hHelp_m)
$hAbout = GUICtrlCreateMenuItem("About", $hHelp_m)
#EndRegion

#Region Screen
$hScreen = GUICtrlCreateInput("0.", 7, 2, 245, 23, BitOR($ES_AUTOHSCROLL, $ES_RIGHT))
$hDummy = GUICtrlCreateLabel("", -100, -100, 0, 0)

; Make the "screen" untouchable =))
Global $hCallback = DllCallbackRegister("_NewInputProc", "ptr", "hwnd;uint;long;ptr")
Global $oldProc = _WinAPI_SetWindowLong(GUICtrlGetHandle($hScreen), $GWL_WNDPROC, DllCallbackGetPtr($hCallback))
#EndRegion

#Region Button (prefix b)
; First row
GUICtrlCreateLabel("", 12, 38, 27, 26, 0, $WS_EX_CLIENTEDGE)
$bBackspace = GUICtrlCreateButton("Backspace", 50, 35, 67, 29)
$bCE = GUICtrlCreateButton("CE", 121, 35, 63, 29)
$bC = GUICtrlCreateButton("C", 187, 35, 63, 29)

; Second row
$bMC = GUICtrlCreateButton("MC", 8, 73, 36, 29)
$b7 = GUICtrlCreateButton("7", 54, 73, 36, 29)
$b8 = GUICtrlCreateButton("8", 93, 73, 36, 29)
$b9 = GUICtrlCreateButton("9", 132, 73, 36, 29)
$bDiv = GUICtrlCreateButton("/", 171, 73, 36, 29)
$bSqrt = GUICtrlCreateButton("sqrt", 210, 73, 36, 29)

; Third row
$bMR = GUICtrlCreateButton("MR", 8, 106, 36, 29)
$b4 = GUICtrlCreateButton("4", 54, 106, 36, 29)
$b5 = GUICtrlCreateButton("5", 93, 106, 36, 29)
$b6 = GUICtrlCreateButton("6", 132, 106, 36, 29)
$bMul = GUICtrlCreateButton("*", 171, 106, 36, 29)
$bPer = GUICtrlCreateButton("%", 210, 106, 36, 29)

; Fourth row
$bMS = GUICtrlCreateButton("MS", 8, 138, 36, 29)
$b1 = GUICtrlCreateButton("1", 54, 138, 36, 29)
$b2 = GUICtrlCreateButton("2", 93, 138, 36, 29)
$b3 = GUICtrlCreateButton("3", 132, 138, 36, 29)
$bSub = GUICtrlCreateButton("-", 171, 138, 36, 29)
$bMulInv = GUICtrlCreateButton("1/x", 210, 138, 36, 29)

; Fifth row
$bMP = GUICtrlCreateButton("M+", 8, 171, 36, 29)
$b0 = GUICtrlCreateButton("0", 54, 171, 36, 29)
$bAddInv = GUICtrlCreateButton("+/-", 93, 171, 36, 29)
$bDot = GUICtrlCreateButton(".", 132, 171, 36, 29)
$bAdd = GUICtrlCreateButton("+", 171, 171, 36, 29)
$bEqu = GUICtrlCreateButton("=", 210, 171, 36, 29)
#EndRegion

Global $sOperator = "", $sNumber = "", $sExpression = "", $sDisplayStr = "", $isMulInv = False
GUISetState()

While Sleep(10)
;~ ToolTip($sNumber & @CRLF & $sOperator & @CRLF & $sExpression & @CRLF & $sDisplayStr)
   $msg = GUIGetMsg()
   Switch $msg
   Case -3 ; Quit Message received, clean up and terminate the program
	  _WinAPI_SetWindowLong(GUICtrlGetHandle($hScreen), $GWL_WNDPROC, $oldProc)
	  DllCallbackFree($hCallback)
	  Exit
   Case $hHelp
	  MsgBox(16, "Error", "I haven't written it yet!")
   Case $hAbout
	  MsgBox(64, "About Calculator", "Just a simple code to demonstrate AutoIt")
   ; ------------------------------------------------------------------------ ;
   Case $b0, $b1, $b2, $b3, $b4, $b5, $b6, $b7, $b8, $b9 ; Digits
	  If $sOperator Then
		 $sExpression &= $sOperator
		 $sOperator = ""
	  EndIf
	  $sNumber &= GUICtrlRead($msg)
	  $sDisplayStr = $sNumber
   ; ------------------------------------------------------------------------ ;
   Case $bDiv, $bMul, $bSub, $bAdd ; operator + - * /
	  $sOperator = GUICtrlRead($msg)
	  ContinueCase
   Case $bEqu ; operator =
	  If $msg = $bEqu Then ; This line is necessary, because the previous case fell through
		 If Not StringRegExp($sExpression, "[-+*/]$") And $sNumber Then _
			$sExpression = "" ; If there is no operator, clear the old result
	  EndIf
	  If $sNumber Then
		 $sExpression &= $sNumber
		 $sNumber = ""
	  EndIf
	  $sExpression = Number(Execute($sExpression))
	  $sDisplayStr = $sExpression
   ; ------------------------------------------------------------------------ ;
   Case $bDot
	  $sNumber = Number($sNumber) ; If $sNumber is empty string, it will be converted to the value 0
	  If Not StringInStr($sNumber, ".") Then $sNumber &= "."
	  $sDisplayStr = $sNumber
   ; ------------------------------------------------------------------------ ;
   Case $bBackspace
	  $sNumber = Number(StringTrimRight($sNumber, 1)) ; Remove the right-most digit
	  $sDisplayStr = $sNumber
   Case $bC ; This will clear all
	  $sExpression = ""
	  ContinueCase
   Case $bCE ; This will clear the current number and operator, but not the previous calculated value
	  $sNumber = ""
	  $sOperator = ""
	  $sDisplayStr = 0
   ; ------------------------------------------------------------------------ ;
   ; These button invoke the mathematic function directly on the last saved result
   Case $bSqrt, $bPer
	  If $msg = $bSqrt Then
		 $sDisplayStr = Sqrt(Number($sExpression)) ; Calculate square root
	  Else
		 $sDisplayStr = Number($sExpression) / 100 ; Convert percent to decimal
	  EndIf
	  $sNumber = ""
	  $sOperator = ""
	  $sExpression = $sDisplayStr
   ; Use boolean instead of direct calculation to prevent loss of data.
   Case $bMulInv
	  $isMulInv = Not $isMulInv
	  $sNumber = ""
	  $sOperator = ""
	  If $isMulInv Then
		 $sDisplayStr = (Number($sExpression) ? 1 / $sExpression : 0)
	  Else
		 $sDisplayStr = Number($sExpression)
	  EndIf
   Case $bAddInv
	  $sNumber *= -1
	  $sDisplayStr = $sNumber
   ; ------------------------------------------------------------------------ ;
   Case $bMC, $bMR, $bMS, $bMP
	  MsgBox(16, "Error", "I have no idea what does this button do")
	  ContinueCase
   Case Else
	  ContinueLoop
   EndSwitch
   If $sDisplayStr == "1.#INF" Then
	  $sDisplayStr = "Cannot divide by zero"
	  $sExpression = ""
	  $sNumber = ""
	  $sOperator = ""
   Else
	  $sDisplayStr = Execute($sDisplayStr)
   EndIf

   If Not StringInStr($sDisplayStr, ".") Then $sDisplayStr &= "."
   GUICtrlSetData($hScreen, $sDisplayStr)
WEnd

Func _NewInputProc($hwnd, $msg, $wParam, $lParam)
   If $msg = $WM_SETFOCUS Then GUICtrlSetState($hDummy, $GUI_FOCUS)
   Return _WinAPI_CallWindowProc($oldProc, $hwnd, $msg, $wParam, $lParam)
EndFunc