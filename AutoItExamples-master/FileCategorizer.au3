#include <Constants.au3>

;~ A program to move all file in current directory to appropriate folder base on their signature and extension

$hSearch = FileFindFirstFile("*.*")
While $hSearch <> -1
   $next = FileFindNextFile($hSearch)
   If @error Then ExitLoop
   DoWork($next)
WEnd




Func DoWork($filePath)
   If $filePath == @ScriptFullPath Then Return

   If DirGetSize($filePath) > -1 Then Return ; Is directory
   Local $fileExtension = _FileExt($filePath)
   Local $fileSignature = _BinaryFileRead($filePath, 16)

   Local $destFolder = _DetermineDestination($fileExtension, $fileSignature)
   Local $dest = $destFolder & "\" & _FileName($filePath)
;~    FileMove($filePath, $dest, $FC_CREATEPATH)
   FileCopy($filePath, $dest, $FC_CREATEPATH)
   ConsoleWrite($filePath & " -> "  & $destFolder & "\" & _FileName($filePath) & @CRLF)
;~    ConsoleWrite($filePath & " -> "  & _GetDir($filePath) & "\" & $destFolder & "\" & _FileName($filePath) & @CRLF)
EndFunc

Func _DetermineDestination($ext, $sign)
   If StringLen($sign) < 12 Then Return SetError(1, 0, '')

   Local $regex = StringRegExp, $instr = StringInStr
   $sign = StringReplace($sign, "0x", "")

   If $instr($sign, "4D5A") = 1 Then Return "Executable" ; exe dll sys

   If $regex($sign, "1F(9D|A0)") _ ; z
	  Or $instr($sign, "425A68") = 1 _ ; bz2
	  Or $instr($sign, "4C5A4950") = 1 _ ; lz
	  Or $instr($sign, "7573746172") = 1 _ ; tar
	  Or $instr($sign, "377ABCAF271C") = 1 _ ; 7z
	  Or $instr($sign, "1F8B") = 1 _ ; gz
	  Or $instr($sign, "4D534346") = 1 _ ; cab
	  Or $instr($sign, "52617221") = 1 _ ; rar
	  Or $instr($sign, "43723234") = 1 _ ; crx (Chrome extension)
	  Or $instr($sign, "4344303031") = 1 _ ; iso
	  Or $instr($sign, "4B444D56") = 1 _ ; vmdk (VMWare Disk file)
	  Then Return "Archives"

   If $regex($sign, "49492A00|4D4D002A") _ ; tif tiff
	  Or $instr($sign, "00000100") = 1 _ ; ico
	  Or $instr($sign, "47494638") = 1 _ ; gif
	  Or $instr($sign, "FFD8FF") = 1 _ ; jpg jpeg
	  Or $instr($sign, "89504E47") = 1 _ ; png
	  Or $instr($sign, "424D") = 1 _ ; bmp dib
	  Or $instr($sign, "464C4946") = 1 _ ; flif (Free Lossless Image Format)
	  Or $instr($sign, "38425053") = 1 _ ; psd
	  Or $instr($sign, "41474433") = 1 _ ; Free Hand 8
	  Then Return "Images"

   If $regex($sign, "FFFB|494433") _ ; mp3
	  Or $instr($sign, "66747970") = 4 * 2 + 1 _ ; 3gp 3g2 mp4 ...
	  Or $instr($sign, "6D6F6F76") = 4 * 2 + 1 _ ; mov
	  Or $instr($sign, "3026B2758E66CF") = 1 _ ; asf wma wmv
	  Or $instr($sign, "4F676753") = 1 _ ; ogg oga ogv
	  Or $instr($sign, "52494646") = 1 _ ; wav avi ...
	  Or $instr($sign, "4D546864") = 1 _ ; mid midi
	  Or $instr($sign, "664C6143") = 1 _ ; flac (Free Lossless Audio Codec)
	  Or $instr($sign, "464C56") = 1 _ ; flv
	  Or $instr($sign, "5753") = 2 * 1 + 1  _ ; swf
	  Then Return "Media"

   If $instr($sign, "25215053") = 1 _ ; PostScript
	  Or $instr($sign, "5374616E64617264204A6574") = 4 * 2 + 1 _ ; mdb
	  Or $instr($sign, "5374616E6461726420414345") = 4 * 2 + 1 _ ; accdb
	  Or $instr($sign, "3F5F0300") = 1 _ ; hlp (Help file)
	  Or $instr($sign, "D0CF11E0A1B11AE1") = 1 _ ; doc xls ppt msg msi vsd ...
	  Or $instr($sign, "2142444E42") = 1 _ ; pst (Outlook Post Office file)
	  Then Return "Documents"

   If $instr($sign, "CAFEBABE") = 1 _ ; class
	  Or $instr($sign, "4C01") = 1 _ ; obj
	  Then Return "Objects"


   ; Special cases
   If $instr($sign, "504B") = 1 Then ; zip jar apk odt ods odp vsdx docx xlsx pptx ...
	  If StringInStr("odt ods odp vsdx docx xlsx pptx", $ext) Then Return "Documents"
	  Return "Archives"
   EndIf
   If $instr($sign, "25504446") = 1 Then ; pdf ai
	  If $ext = "ai" Then Return "Images"
	  Return "Documents"
   EndIf

   Return "Other"
EndFunc

#Region Utilities
Func _FileExt($path)
   Local $ext = StringRegExp($path, ".*\.(.+?)$", 3)
   Return IsArray($ext) ? $ext[0] : ''
EndFunc
Func _GetDir($path)
   Local $dir = StringRegExp($path, "(.+)(?:\\|/).*\..+?$", 3)
   Return IsArray($dir) ? $dir[0] : ''
EndFunc
Func _FileName($path)
   Local $name = StringRegExp($path, "(?:\\|/)?(.*\..+?)$", 3)
   Return IsArray($name) ? $name[0] : ''
EndFunc

Func _BinaryFileRead($fileName, $count = -1)
   Local $hFile = FileOpen($fileName, $FO_BINARY)
   If $hFile = -1 Then Return SetError(1, 0, '')
   Local $data = FileRead($hFile, $count)
   FileClose($hFile)
   Return $data
EndFunc
#EndRegion