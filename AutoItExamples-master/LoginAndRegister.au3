; Example of login and register using AutoIt.
; PLEASE NOT THAT THIS IS ONLY AN EXAMPLE. DON'T MIX THE CODE BELOW WITH PRODUCTION CODE

#include <GUIConstants.au3>
#include <Constants.au3>
#include <Crypt.au3>

GUICreate("", 180, 100)
GUICtrlCreateLabel("Tài khoản: ", 10, 13)
$usrTextField = GUICtrlCreateInput("", 70, 10, 100, 20)
GUICtrlCreateLabel("Mật khẩu: ", 10, 43)
$pwdTextField = GUICtrlCreateInput("", 70, 40, 100, 20, $ES_PASSWORD)
$loginButton = GUICtrlCreateButton("Đăng nhập", 5, 70, 80, 25)
$registerButton = GUICtrlCreateButton("Đăng ký", 95, 70, 80, 25)
GUISetState()

While Sleep(10)
   Switch GUIGetMsg()
   Case $GUI_EVENT_CLOSE
	  Exit
   Case $loginButton
	  If Login(GUICtrlRead($usrTextField), Hash(GUICtrlRead($pwdTextField))) Then
		 MsgBox(0, "Login success", "You've logged in successfully")
	  Else
		 MsgBox($MB_ICONERROR, "Login failed", "The username or password is incorrect")
	  EndIf
   Case $registerButton
	  If Register(GUICtrlRead($usrTextField), GUICtrlRead($pwdTextField)) Then
		 MsgBox(0, "Registration approved", "Your registration is approved")
	  Else
		 MsgBox($MB_ICONERROR, "Registration rejected", "Username already exists")
	  EndIf
   EndSwitch
WEnd

Func Hash($data)
; Note that this hash algorithm is not recommended. See https://en.wikipedia.org/wiki/Secure_Hash_Algorithm
; for better algorithms
   Return _Crypt_HashData($data, $CALG_SHA1)
EndFunc

Func Register($usr, $pwd)
   If StringRegExp(FileRead("accounts.txt"), '(?m)^\Q' & $usr & '|\E') Then Return False
   Local $hFile = FileOpen("accounts.txt", BitOR($FO_UTF8_NOBOM, $FO_APPEND))
   ; In real code, there should be a check for FileOpen failure here
   ; Note that I've skipped the username and password validation. You shouldn't do it in real code.
   ; In this case, at least a constraint must be satisfied: No '|' and @CRLF character in username/password.
   FileWrite($hFile, $usr & '|' & Hash($pwd) & @CRLF)
   FileClose($hFile)
   Return True
EndFunc
Func Login($usr, $pwd)
   Return StringRegExp(FileRead("accounts.txt"), '(?m)^\Q' & $usr & '|' & $pwd & '\E$')
EndFunc