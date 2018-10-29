#include <Array.au3>
#include "JSON.au3"

#Region Program code
Global $state = _URIEncode('alabama') ; For "D.C." use "district of columbia" instead

$oHTTP = ObjCreate("WinHttp.WinHttpRequest.5.1")

;~ $totalRecordCount = 1 (> 0) để cái vòng lặp dưới diễn ra lần lặp đầu,
;~ giá trị thực sự của $totalRecordCount mới được lưu vào.
Local $page = 1, $receivedRecordCount = 0, $totalRecordCount = 1
While $receivedRecordCount < $totalRecordCount
   ConsoleWrite("Requesting page " & $page & @CRLF)
   Local $url = "http://www.usnews.com/education/best-high-schools/search?state-urlname=" & _
				  $state & "&format=json&page=" & $page
   $oHTTP.Open("GET", $url)
   $oHTTP.Send()
   ; Dữ liệu trả về có kiểu là String, t parse nó thành mảng trong AutoIt luôn để tiện dùng
   Local $jsonResponse = _JSONDecode($oHTTP.ResponseText)
   $totalRecordCount = _JSONSmartFieldRead($jsonResponse, 'totalMatches')
   FilterDataFromPage($receivedRecordCount, $jsonResponse)
   $page += 1
   ConsoleWrite('Received ' & $receivedRecordCount & ' of ' & $totalRecordCount & ' records' & @CRLF)
WEnd
#EndRegion


Func FilterDataFromPage(ByRef $receivedRecordCount, $json)
   Local $recordCountOfThisPage = UBound(_JSONSmartFieldRead($json, 'matches'))
   Local $hFile = FileOpen($state & '.txt', 1) ; Open for appending

   For $i = 0 To $recordCountOfThisPage - 1
	  Local $name = _JSONSmartFieldRead($json, 'matches -> [' & $i & '] -> name')
	  Local $location = _JSONSmartFieldRead($json, 'matches -> [' & $i & '] -> school -> location')
	  Local $district = _JSONSmartFieldRead($json, 'matches -> [' & $i & '] -> school -> district')
	  FileWrite($hFile, $name & @CRLF & $location & ' | ' & $district & @CRLF)
	  $receivedRecordCount += 1
   Next
   FileClose($hFile)
EndFunc

#cs
Read a value from a JSON array based on the given path.
Params:
  $array - The array returned from _JSONDecode
  $path - A string to describe the path to take, each step is separated by ->. Example: 'myObject -> myInt',
        which will return the value of myInt of myObject.
		For array element accessing, use [the-index]. Example: 'myArray -> [0] -> myInt' return the value of
		myInt, which is in the first element of myArray
Return:
  The value of the specified field, or empty string if the path is invalid.
  @error will also be set to 1 on failure
#ce
Func _JSONSmartFieldRead($array, $path)
   Local $aPath = StringSplit($path, " -> ", 3) ; Entire split, no count

   Local $current = $array
   For $key In $aPath
	  If StringRegExp($key, "^\[\d+\]$") Then
		 $key = Int(StringMid($key, 2, StringLen($key) - 2))
		 If UBound($current, 0) <> 1 Or $key < 0 Or $key >= UBound($current) Then Return SetError(1, 0, '')
		 $current = $current[$key]
	  Else
		 $current = _JSONFieldRead($current, $key)
		 If @error Then Return SetError(1, 0, '')
	  EndIf
   Next
   Return $current
EndFunc

Func _JSONFieldRead($array, $fieldName)
   If UBound($array, 0) <> 2 Then Return SetError(1, 0, 'Invalid array')

   Local $size = UBound($array, 1)
   For $i = 0 To $size - 1
	  If $array[$i][0] = $fieldName Then Return $array[$i][1]
   Next
   Return SetError(2, 0, "The requested element doesn't exist")
EndFunc



Func _URIEncode($sData)
   ; Prog@ndy
   Local $aData = StringSplit(BinaryToString(StringToBinary($sData,4),1),"")
   Local $nChar
   $sData=""
   For $i = 1 To $aData[0]
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