;~ Download a song from mp3.zing.vn using InetRead
Example()

Func Example()
   DownloadMp3("IWAA0BOF") ; Hà Nội Mùa Lá Bay - Dương Trường Giang
EndFunc

;~ Quality:
;~ 128
;~ 320
;~ lossless
Func DownloadMp3($SongID, $quality = "128")
   Local $URL = 'http://api.mp3.zing.vn/api/mobile/song/getsonginfo?requestdata={"id":"{ID}"}'

   Local $src = BinaryToString(InetRead(StringReplace($URL, "{ID}", $SongID), 4))
   Local $links = StringRegExp($src, '"source":\s*\{(.+?)\}', 3)[0]
   $links = StringReplace($links, "\/", "/")
   Local $title = StringRegExp($src, '"title":\s*"(.*?)"', 3)[0]
   Local $artist = StringRegExp($src, '"artist":\s*"(.*?)"', 3)[0]
   Local $fname = _StringUnescape($title & " - " & $artist &  ".mp3")
   $fname = StringRegExpReplace($fname, "[\\/:?*""<>\|]", "")

   $DownloadLink = StringRegExp($links, '"' & $quality & '"\s*:\s*"(.+?)"', 3)
   If @error Then Return 0
   InetGet($DownloadLink[0], $fname)
   Return 1
EndFunc

Func _StringUnescape($s)
   Local $a = StringRegExp($s, "(?<!\\)\\u([\da-fA-F]{4})", 3)
   If @error Then Return SetError(@error, 0, "")
   For $x In $a
	  $s = StringReplace($s, "\u" & $x, ChrW("0x" & $x))
   Next
   Return $s
EndFunc