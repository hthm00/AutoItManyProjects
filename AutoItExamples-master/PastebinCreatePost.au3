ConsoleWrite(Post("Content", "Name", "10M", "text"))

;~ This function return link of the created post
Func PastebinCreatePost($code, $name, $expire_date, $format, $private = '0', _ ; 0=public 1=unlisted 2=private
						$user_key = '', $APIKey = 'c2f7b3887780260308cec9fae1da7909')
   Local $oHTTP = ObjCreate("WinHTTP.WinHTTPREquest.5.1")
   Local $sData = "api_option=paste" & _
				  "&api_user_key=" & $user_key & _
				  "&api_paste_private=" & $private & _
				  "&api_paste_name=" & _URIEncode($name) & _
				  "&api_paste_expire_date=" & $expire_date & _
				  "&api_paste_format=" & $format & _
				  "&api_dev_key=" & $APIKey & _
				  "&api_paste_code=" & _URIEncode($code)
   $oHTTP.Open("POST", "http://pastebin.com/api/api_post.php")
   $oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
   $oHTTP.Send($sData)

   Return $oHTTP.ResponseText
EndFunc

Func _URIEncode($sData)
    ; Prog@ndy
    Local $aData = StringSplit(BinaryToString(StringToBinary($sData,4),1),"")
    Local $nChar
    $sData=""
    For $i = 1 To $aData[0]
        ; ConsoleWrite($aData[$i] & @CRLF)
        $nChar = Asc($aData[$i])
        Switch $nChar
            Case 45, 46, 48 To 57, 65 To 90, 95, 97 To 122, 126
                $sData &= $aData[$i]
            Case 32
                $sData &= "+"
            Case Else
                $sData &= "%" & Hex($nChar,2)
        EndSwitch
    Next
    Return $sData
EndFunc