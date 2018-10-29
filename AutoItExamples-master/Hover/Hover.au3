#include-once

#cs
------------------------------------EXAMPLE------------------------------------
$hwnd = GUICreate(...)
$myControl = GUICtrlCreate...
Func MyHoverEventHandler()
  ...
EndFunc
Func MyUnhoverEventHandler()
  ...
EndFunc
$pos = WinGetPos(ControlGetHandle($hwnd, "", $myControl))
HoverRegisterWindow($hwnd)
HoverRegisterControl($myControl, , MyHoverEventHandler, MyUnhoverEventHandler)

While 1
  HoverProc()

  Switch GUIGetMsg()
    ...
  EndSwitch
WEnd
----------------------------------END EXAMPLE----------------------------------

Note: Names start with "HOVER_Internal_" is for internal use only (i.e: they're private members), don't touch them.
#ce

Global $HOVER_Internal_Ctl[1]
Global $HOVER_Internal_CtlPos[1]
Global $HOVER_Internal_CtlIsHovering[1]
Global $HOVER_Internal_OnHover[1]
Global $HOVER_Internal_OnUnhover[1]
Global $HOVER_Internal_CtlCount = 0
Global $HOVER_Internal_Hwnd = 0

#cs
================================================================================
public HoverRegisterWindow($window)
Param:
  $window - Handle of the window where we track hover events
Return: None
================================================================================
#ce
Func HoverRegisterWindow($window)
  $HOVER_Internal_Hwnd = $window
EndFunc

#cs
================================================================================
public HoverRegisterControl($control, $pos, $onHover, $onUnhover)
Add a control to the list of tracking controls. When hover or unhover event occur, the appropriate callback function will be called. The callback function should be in the form below (the parameter can have different name):
Func OnHoverCallback($ControlID)
  ; Your code goes here
EndFunc
$ControlID is the control ID of the control where hover/unhover event was fired.

Params:
  $control    - The control to track
  $pos        - Position and size of the control. The first two elements are
                X and Y position, the second ones are width and height of the
                control.
  $onHover    - The callback function to be called when hover event occur
  $onUnhover  - The callback function to be called when unhover event occur
Return: None
================================================================================
#ce
Func HoverRegisterControl($control, $pos, $onHover, $onUnhover)
  Local $i = $HOVER_Internal_CtlCount

  $HOVER_Internal_CtlCount += 1
  ReDim $HOVER_Internal_Ctl[$HOVER_Internal_CtlCount]
  ReDim $HOVER_Internal_CtlPos[$HOVER_Internal_CtlCount]
  ReDim $HOVER_Internal_CtlIsHovering[$HOVER_Internal_CtlCount]
  ReDim $HOVER_Internal_OnHover[$HOVER_Internal_CtlCount]
  ReDim $HOVER_Internal_OnUnhover[$HOVER_Internal_CtlCount]

  $HOVER_Internal_Ctl[$i] = $control
  $HOVER_Internal_CtlPos[$i] = $pos
  $HOVER_Internal_CtlIsHovering[$i] = False
  $HOVER_Internal_OnHover[$i] = $onHover
  $HOVER_Internal_OnUnhover[$i] = $onUnhover
EndFunc

#cs
================================================================================
public HoverProc()
This function checks for hover/unhover events and call the appropriate event
handler when a hover/unhover event is fired.
NOTE: THIS FUNCTION NEED TO BE CALLED CONTINUOUSLY TO DETECT HOVER/UNHOVER EVENTS.

Return: None
================================================================================
#ce

Func HoverProc()
  If $HOVER_Internal_CtlCount = 0 Or Not WinActive($HOVER_Internal_Hwnd) Then Return

  For $i = 0 To $HOVER_Internal_CtlCount - 1
    If HOVER_Internal_IsHovering($HOVER_Internal_CtlPos[$i]) Then
     If Not $HOVER_Internal_CtlIsHovering[$i] Then _ ; Display hover effect
      Call($HOVER_Internal_OnHover[$i], $HOVER_Internal_Ctl[$i])
     $HOVER_Internal_CtlIsHovering[$i] = True
    Else
     If $HOVER_Internal_CtlIsHovering[$i] Then _ ; Remove hover effect
      Call($HOVER_Internal_OnUnhover[$i], $HOVER_Internal_Ctl[$i])
     $HOVER_Internal_CtlIsHovering[$i] = False
    EndIf
  Next
EndFunc

#cs
================================================================================
private IsHovering($pos)

Param:
  $pos - A 4-elements array containing X, Y, width, height of the control
Return: True if the cursor is hovering over the control, False otherwise
================================================================================
#ce
Func HOVER_Internal_IsHovering($Pos)
  Local $MousePos = MouseGetPos()
  Return $Pos[0] <= $MousePos[0] And $MousePos[0] <= $Pos[0] + $Pos[2] _
      And $Pos[1] <= $MousePos[1] And $MousePos[1] <= $Pos[1] + $Pos[3]
EndFunc