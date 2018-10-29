#include-once

#cs
ar			Arabic
bs-Latn		Bosnian (Latin)
bg			Bulgarian
ca			Catalan
zh-CHS		Chinese Simplified
zh-CHT		Chinese Traditional
hr			Croatian
cs			Czech
da			Danish
nl			Dutch
en			English
et			Estonian
fi			Finnish
fr			French
de			German
el			Greek
ht			Haitian Creole
he			Hebrew
hi			Hindi
mww			Hmong Daw
hu			Hungarian
id			Indonesian
it			Italian
ja			Japanese
sw			Kiswahili
tlh			Klingon
tlh-Qaak 	Klingon (pIqaD)
ko			Korean
lv 			Latvian
lt 			Lithuanian
ms 			Malay
mt 			Maltese
no 			Norwegian
fa 			Persian
pl 			Polish
pt 			Portuguese
otq 		Querétaro Otomi
ro 			Romanian
ru 			Russian
sr-Cyrl 	Serbian (Cyrillic)
sr-Latn 	Serbian (Latin)
sk 			Slovak
sl 			Slovenian
es 			Spanish
sv 			Swedish
th 			Thai
tr 			Turkish
uk 			Ukrainian
ur 			Urdu
vi 			Vietnamese
cy 			Welsh
yua 		Yucatec Maya
#ce
Func BingTranslate($Text, $From = "auto", $To = "en")
   Local $sClient = "http://api.microsofttranslator.com/V2/Http.svc/"
   Local $appID = 'appId=68D088969D79A8B23AF8585CC83EBA2A05A97651' ; appID lụm trên mạng
   Local $Data = BinaryToString(StringToBinary($Text, 4))

   If $From == "auto" Then
   $From = InetRead($sClient & 'Detect?' & $appID & "&text=" & $Data, 3)
   $From = BinaryToString($From, 4)
   $From = StringRegExpReplace($From, ".*>(.*)<.*", "$1")
   EndIf
   $Result = InetRead($sClient & 'Translate?' & $appID & "&from=" & $From & _
			"&to=" & $To & "&text=" & $Data, 3)
   $Result = StringRegExpReplace(BinaryToString($Result, 4), ".*>(.*)<.*", "$1")
   Return $Result
EndFunc