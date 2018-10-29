$GUI = GUICreate("Marquee Title ")
GUISetState()
AdlibRegister("MarqueeTitle", 100)

While Sleep(10)
   If GUIGetMsg() = -3 Then Exit
WEnd

Func MarqueeTitle()
   Local $text = WinGetTitle($GUI)
   WinSetTitle($GUI, "", StringTrimLeft($text, 1) & StringLeft($text, 1))
EndFunc