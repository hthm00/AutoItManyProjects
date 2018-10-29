#include-once

#Region Test
;~ Test()

Func Test()
   GetAbsolutePathTest("")
   GetAbsolutePathTest(".")
   GetAbsolutePathTest("C:/hello/../hi")
   GetAbsolutePathTest("D:/this test\use both style", "\")
   GetAbsolutePathTest("https://www.facebook.com/?ref=logo", "/")

   ; Lười viết test case cho cái _FileList quá, ai rảnh viết giùm đi :3
EndFunc

Func GetAbsolutePathTest($path, $delim = "\")
   MsgBox(0, $path, GetAbsolutePath($path, $delim))
EndFunc
#EndRegion


#Region UDF
;~ Creates a list of file names that matched a given regex.
;~ Currently, this function does not look for files in subfolder.
;~ Params:
;~   $dir    -- The directory where the search start
;~   $filter -- A regex to filter file names
;~ Returns:
;~   An array containing matched file names. The first element is the absolute path of the given directory
Func _FileList($dir, $filter)
   $dir = GetAbsolutePath($dir)
   Local $a[1] = [$dir]
   Local $hSearch = FileFindFirstFile($dir & "\*")
   While 1
	  Local $file = FileFindNextFile($hSearch)
	  If @extended Then ContinueLoop ; Skip folder
	  If @error Then ExitLoop ; No more file
	  If StringRegExp($file, $filter) Then
		 Local $size = UBound($a)
		 ReDim $a[$size + 1]
		 $a[$size] = $file
	  EndIf
   WEnd
   Return $a
EndFunc

;~ Converts a relative path to absolute path.
;~ Params:
;~   $path  -- The path to convert
;~   $delim -- The path delimiter to use in the absolute path
;~   $pwd   -- The working dir (i.e: The absolute path of .)
;~ Returns:
;~   Absolute path of $path, or an empty string ("") if $path is empty
Func GetAbsolutePath($path, $delim = "\", $pwd = @ScriptDir)
   If Not $path Then Return ""

   If Not StringInStr($path, ":") Then $path = $pwd & "\" & $path
   Local $pathSplit = StringSplit($path, "\/")

   For $i = 1 To $pathSplit[0]
	  Switch $pathSplit[$i]
	  Case ".."
		 $pathSplit[$i-1] = ""
		 ContinueCase
	  Case "."
		 $pathSplit[$i] = ""
	  Case Else
		 If Not $pathSplit[$i] And ($pathSplit[$i-1] = $delim Or StringInStr($pathSplit[$i-1], ":")) Then _
			$pathSplit[$i] = $delim
	  EndSwitch
   Next

   Local $absPath = ""
   For $i = 1 To $pathSplit[0]
	  If $pathSplit[$i] Then $absPath &= $pathSplit[$i] & ($pathSplit[$i] <> $delim ? $delim : "")
   Next
   Return StringRegExpReplace($absPath, "[\\/]*$", "")
EndFunc
#EndRegion