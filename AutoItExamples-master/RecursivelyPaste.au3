;~ Recursively paste a file to a folder and all of its subfolders

Global $sInitDir = @ScriptDir & "\New Folder", $sAbsPath = @ScriptDir & "\test.txt"
RecursivePaste($sInitDir, $sAbsPath)

Func RecursivePaste($sDir, $sFile)
   Local $hSearch = FileFindFirstFile($sDir & "\*"), $sFound = ""
   While 1
	  $sFound = FileFindNextFile($hSearch)
	  If @error Then ExitLoop ; Nothing found

	  If DirGetSize($sDir & "\" & $sFound)) >= 0 Then ; IsDir
		 FileCopy($sFile, $sDir & "\" & $sFound, 1)
		 RecursivePaste($sFound, $sFile)
	  EndIf
   WEnd
   FileClose($hSearch)
EndFunc