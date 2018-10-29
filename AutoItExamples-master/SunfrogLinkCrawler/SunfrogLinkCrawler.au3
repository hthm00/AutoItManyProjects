#include <GUIConstantsEx.au3>
#include <EditConstants.au3>

Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 1)

Global $base_url = "https://www.sunfrog.com"
Global $search_url = $base_url & "/search"

$hMainWnd = GUICreate("SunFrog Link Crawler", 600, 220)
GUICtrlCreateLabel("Từ khóa:", 30, 30)
$keywordField = GUICtrlCreateInput("", 80, 25, 250, 20)
GUICtrlCreateLabel("Hoặc lấy danh sách từ khóa từ file: ", 350, 30)
$chooseInFileBtn = GUICtrlCreateButton("Chọn file...", 520, 25, 70, 25)
$deselectFileBtn = GUICtrlCreateButton("Bỏ chọn file", 520, 55, 70, 25)
$fromFileLabel = GUICtrlCreateLabel("", 350, 50, 170, 30)
GUICtrlCreateLabel("Số lượng link cần lấy với mỗi keyword: ", 30, 60)
$quantityField = GUICtrlCreateInput("40", 220, 55, 50, 20, $ES_NUMBER)
GUICtrlCreateLabel("Thời gian chờ (giây):", 30, 90)
$delayField = GUICtrlCreateInput("3", 140, 85, 50, 20)
GUICtrlCreateLabel("Độ lệch (giây):", 220, 90, 70)
$deviationField = GUICtrlCreateInput("1", 300, 85, 50, 20)
$statusLabel = GUICtrlCreateLabel("Trạng thái: Đang chờ", 30, 125, 540, 25)
$crawlBtn = GUICtrlCreateButton("Get link", 150, 150, 300, 50)
GUICtrlSetFont($crawlBtn, 20)


Global $configFile = "SF-crawler-config.dat"
If Not FileExists($configFile) Then
   SaveSettings()
Else
   $confs = StringRegExp(FileRead($configFile), "(?m)^\s*(\$\w+)=(.+)$", 3)
   For $i = 0 To UBound($confs) - 1 Step 2
	  Execute("GUICtrlSetData(" & $confs[$i] & ", " & $confs[$i + 1] & ")")
   Next
EndIf

GUISetState()

While Sleep(10)
   Switch GUIGetMsg()
   Case -3
	  SaveSettings(GUICtrlRead($quantityField), GUICtrlRead($delayField), GUICtrlRead($deviationField))
	  Exit
   Case $chooseInFileBtn
	  $dir = FileOpenDialog("Chọn file", "", "Text file(*.txt)", 3) ; File and path must exist
	  If Not @error Then GUICtrlSetData($fromFileLabel, $dir)
   Case $deselectFileBtn
	  GUICtrlSetData($fromFileLabel, "")
   Case $crawlBtn
	  If ValidateInput() Then
		 SetInputState($GUI_DISABLE)
		 $errorOccur = Crawl()
		 ; The work is done, re-enable the controls
		 SetInputState($GUI_ENABLE)
		 GUICtrlSetData($statusLabel, "Trạng thái: " & ($errorOccur ? "Thành công" : "Thất bại"))
	  Else
		 MsgBox(0, "Nhập input", "Bạn vẫn chưa nhập đủ thông tin để bắt đầu quét link")
	  EndIf
   EndSwitch
WEnd


Func SaveSettings($quantity = 40, $delay = 3, $deviation = 1)
   Local $hFile = FileOpen($configFile, 2)
   FileWrite($hFile, '$quantityField=' & $quantity & @CRLF & '$delayField=' & $delay & _
		 @CRLF & '$deviationField=' & $deviation)
   FileClose($hFile)
EndFunc

Func ValidateInput()
   Return GUICtrlRead($keywordField) Or GUICtrlRead($fromFileLabel)
EndFunc

Func SetInputState($state)
   GUICtrlSetState($keywordField, $state)
   GUICtrlSetState($quantityField, $state)
   GUICtrlSetState($delayField, $state)
   GUICtrlSetState($deviationField, $state)
   GUICtrlSetState($crawlBtn, $state)
   GUICtrlSetState($chooseInFileBtn, $state)
   GUICtrlSetState($deselectFileBtn, $state)
EndFunc

Func Crawl()
   Local $increment = 40
   Local $quantity = GUICtrlRead($quantityField)
   Local $delay = GUICtrlRead($delayField) * 1000
   Local $deviation = GUICtrlRead($deviationField) * 1000
   Local $inputFile = GUICtrlRead($fromFileLabel)
   Local $keywords[1], $links, $response, $linksArray, $url, $saved, $outputFile
   Local $currentDay = @MDAY & "-" & @MON & "-" & @YEAR

   ; Prepare to crawl links
   If $inputFile Then
	  $keywords = FileReadToArray($inputFile)
	  If @error Then Return MsgBox(16, "Lỗi", "Không thể mở file: " & $inputFile)
   Else
	  $keywords[0] = GUICtrlRead($keywordField)
   EndIf

   ; Start crawling
   For $keyword In $keywords
	  $saved = 0
	  $links = ""
	  $outputFile = $keyword & ".txt"
	  $msg = "Trạng thái: Đang quét link với từ khóa " & $keyword & ": "

	  For $offset = 0 To $quantity - 1 Step $increment
		 GUICtrlSetData($statusLabel, $msg & "Đã lưu " & $offset & " link(s)")
		 $url = $search_url & "/paged2.cfm?schTrmFilter=popular&search=" & URIEncode($keyword) & _
			   "&cID=0&offset=" & $offset
;~ 		 ConsoleWrite($url & @CRLF)
		 $response = HttpRead($url)
		 If @error Then ContinueLoop
;~ 		 FileWrite($outputFile & "-test.html", $response)
		 $linksArray = Filter($response)
		 If @error Then ContinueLoop
		 For $link In $linksArray
			$links &= $link & @CRLF
			$saved += 1
			If $saved = $quantity Then ExitLoop 2
		 Next
		 $sleeptime = $delay + Random(-$deviation, $deviation, 1)
		 ConsoleWrite("Sleep: " & $sleeptime & @CRLF)
		 Sleep($sleeptime)
	  Next
	  FileWrite($outputFile, $links)
	  $links = ""
   Next

   Return 1
EndFunc


#Region
Func Filter($src)
   Local $result = StringRegExp($src, '(?is)<div class="frameit">\s*<a href="(.+?\.html)', 3)
   Return @error ? SetError(@error, 0, "") : $result
EndFunc

Func HttpRead($url)
   Local $data = InetRead($url, 1)
   Return @error ? SetError(1, 0, "") : BinaryToString($data, 4)
EndFunc

Func URIEncode($sData)
   ; Prog@ndy
   Local $aData = StringSplit(BinaryToString(StringToBinary($sData, 4), 1), "")
   Local $nChar
   $sData = ""
   For $i = 1 To $aData[0]
      ; ConsoleWrite($aData[$i] & @CRLF)
      $nChar = Asc($aData[$i])
      Switch $nChar
	  Case 45, 46, 48 To 57, 65 To 90, 95, 97 To 122, 126
		 $sData &= $aData[$i]
	  Case 32
		 $sData &= "+"
	  Case Else
		 $sData &= "%" & Hex($nChar, 2)
      EndSwitch
   Next
   Return $sData
EndFunc
#EndRegion