$Disks = DriveGetDrive("FIXED")
For $i = 1 To $Disks[0]
   $sPath = FindFile($Disks[$i], "war3.exe")
   If $sPath Then ExitLoop
Next

MsgBox(0, "war3.exe " & ($sPath ? "" : "not ") & "found", ($sPath ? "Có map DotA không ? :v" : "Máy không có Warcraft3 ._."))

Func FindFile($sDir, $sName)
   Local $hSearch = FileFindFirstFile($sDir & "\*")
   Local $sFileName = ""
   Local $Return = ""
   While 1
	  $sFileName = FileFindNextFile($hSearch)
	  If @error Then ExitLoop

	  If $sFileName = $sName Then Return $sDir & "\" & $sName ;File found
	  If StringInStr(FileGetAttrib($sDir & "\" & $sFileName), "D") Then ;If IsDir
		 Switch $sFileName
		 ; Ignore special folder to speed up the process
		 Case "System Volume Information", "WINDOWS", "Documents and Settings", "Drivers", "Common Files"
			ContinueLoop
		 Case Else
			$Return = FindFile($sDir & "\" & $sFileName, $sName)
			If $Return Then Return $Return
		 EndSwitch
	  EndIf
   WEnd
   FileClose($hSearch)
   Return $Return
EndFunc