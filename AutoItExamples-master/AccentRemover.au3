;~ Chuyển các ký tự có dấu trong một file thành không dấu
$file = FileOpenDialog("Chọn file", @ScriptDir, "Text file(*.txt)|All (*.*)")
If @error Then Exit
$ext = FileNameGetExt($file)
$fileContent = FileRead($file)
FileWrite(StringTrimRight($file, StringLen($ext) + 1) & "_converted." & $ext, _AccentRemove($fileContent))

Func FileNameGetExt($fileName) ; Return the extension (e.g: return 'txt' for file name 'a.txt')
   Local $a = StringRegExp($fileName, ".+\.(.+)$", 3)
   Return @error ? $fileName : $a[0]
EndFunc

Func _AccentRemove($sString)
   Local $rrep = StringRegExpReplace
   $sString = StringReplace($sString, "đ", "d", 1, 1)
   $sString = $rrep($sString, "[áàảãạâấầẩẫậăắằẳẵặ]", "a")
   $sString = $rrep($sString, "[éèẻẽẹêếềểễệ]", "e")
   $sString = $rrep($sString, "[íìỉĩị]", "i")
   $sString = $rrep($sString, "[óòỏõọôốồổỗộơớờởỡợ]", "o")
   $sString = $rrep($sString, "[úùủũụưứừửữự]", "u")
   $sString = $rrep($sString, "[ýỳỷỹỵ]", "y")

   $sString = $rrep($sString, "[ÁÀẢÃẠÂẤẦẨẪẬĂẮẰẲẴẶ]", "A")
   $sString = StringReplace($sString, "Đ", "D")
   $sString = $rrep($sString, "[ÉÈẺẼẸÊẾỀỂỄỆ]", "E")
   $sString = $rrep($sString, "[ÍÌỈĨỊ]", "I")
   $sString = $rrep($sString, "[ÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢ]", "O")
   $sString = $rrep($sString, "[ÚÙỦŨỤƯỨỪỬỮỰ]", "U")
   $sString = $rrep($sString, "[ÝỲỶỸỴ]", "Y")

   Return $sString
EndFunc