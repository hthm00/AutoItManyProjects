#pragma compile("ProductVersion", 1.0.0.1)
#pragma compile("Comments", "Written by MC")
#include "JSON.au3"

Local $id = InputBox("Enter ID", "Nhập ID của bài Quiz", "")
If @error Then Exit
Local $inflow = GetInflowID(Get("http://vn.vonvon.me/mequiz/621/n/" & $id))
If @error Then
   MsgBox(16, "Error", "ID không hợp lệ")
   Exit
EndIf

Local $url = "http://vn.vonvon.me/api/quiz/621?inflow=" & $inflow & "&firstInflow=1&mq_id=" & $id
Local $a = _JSONDecodeAll(_StringUnescape(GET($url)))[0]
Local $name = $a[7][1]
Local $questions = $a[3][1]
Local $choices = $a[9][1]
Local $choiceMappings, $text, $item, $choiceID, $nQuestions = UBound($questions)
Local $correctAnswer = ""

For $i = 1 To $nQuestions - 1
   $item = $questions[$i]
   $choiceMappings = $item[1][1]
   $text = AddName($item[3][1], $name)
   $correctAnswer &= "Câu hỏi: " & $text & @CRLF

   $item = $choiceMappings
   For $j = 1 To UBound($item) - 1
	  If $item[$j][1] = 1 Then
		 $choiceID = $item[$j][0]
		 ExitLoop
	  EndIf
   Next
   For $x In $choices
	  If $x[8][1] = $choiceID Then
		 $correctAnswer &= "Trả lời: " & AddName($x[3][1], $name) & @CRLF & @CRLF
		 ExitLoop
	  EndIf
   Next
Next
Local $f = FileOpen($name & ".txt", 128 + 2)
FileWrite($f, StringStripWS($correctAnswer, 2))
FileClose($f)



Func GetInflowID($sString)
   Local $a = StringRegExp($sString, "\QinflowUUID&#34;: &#34;\E(.+?)\Q&#34;\E", 3)
   If @error Then Return SetError(1, 0, 0)
   Return $a[0]
EndFunc
Func AddName($sString, $name)
   Return StringRegExpReplace($sString, "<MQ_FULLNAME=BẠN>+", $name)
EndFunc
Func _StringUnescape($s)
   Local $a = StringRegExp($s, "(?<!\\)\\u([\da-fA-F]{4})", 3)
   If @error Then Return SetError(@error, 0, "")
   For $x In $a
	  $s = StringReplace($s, "\u" & $x, ChrW("0x" & $x))
   Next
   Return $s
EndFunc
Func GET($url, $flag = 4)
   Return BinaryToString(InetRead($url), $flag)
EndFunc