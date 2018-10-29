#cs
Copy file and display the progress to a progress bar.

Params:
   $sSrc       - The source path
   $sDes       - The destination path
   $iProg      - The control id of the progress bar to display
   $bOverwrite - Determine whether file with the same name should be overwritten or not
#ce
Func _FileCopyWithProgressBar($sSrc, $sDes, $iProg, $bOverWrite = False)
   If Not FileExists($sSrc) Then Return 0

   Local $sBuffer = "", $nOrgSize = FileGetSize($sSrc), $nCurrSize = 0

   If StringRight($sDes, 1) <> "\" Then $sDes &= "\" ;Check for missing '\'

   If StringInStr($sSrc, "/", 1, -1) Then ; Test file name
	  $sDes &= StringMid($sSrc, $p + 1)
   Else
	  $sDes &= (StringInStr($sSrc, "\", 1, -1) ? StringMid($sSrc, $p + 1) : $sSrc)
   EndIf

   If Not $bOverWrite And FileExists($sDes) Then Return 0

   Local $hSrc = FileOpen($sSrc, 16),	$hDes = FileOpen($sDes, 18) ; Open file for read/write
   If $hSrc = -1 Or $hDes = -1 Then Return 0 ; Error, can't open file

   While $nCurrSize < $nOrgSize
	  $sBuffer = FileRead($hSrc, 65536) ; Read 65536 bytes out
	  FileWrite($hDes, $sBuffer) ; Then write it to the target file
	  $nCurrSize += BinaryLen($sBuffer)
	  GUICtrlSetData($iProg, $nCurrSize/$nOrgSize*100)
   WEnd
   GUICtrlSetData($iProg, 100)

   Return BitAND(FileClose($hSrc), FileClose($hDes)) ;If one file can't be closed, return 0
EndFunc