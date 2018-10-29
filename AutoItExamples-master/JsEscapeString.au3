MsgBox(0, '', JsEscapeString("Test string"))

Func JsEscapeString($sString)
   Local $sReturn = ""
   $aStr = StringSplit($sString, "")
   For $i = 1 To $aStr[0]
	  $sReturn &= "\u" & Hex(AscW($aStr[$i]), 4)
   Next
   Return $sReturn
EndFunc