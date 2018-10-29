#include <Array.au3>
#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include "MPDF_UDF.au3"
#include "_FileList.au3"

Global $url = InputBox("", "Nhập URL của trang cần tải về:")
If @error Then Exit
Global $base_dir = FileSelectFolder("Chọn nơi lưu", "", $FSF_CREATEBUTTON, @ScriptDir)
If @error Then Exit

Global $base_url = "http://www.luyenthithukhoa.vn"
Global $content = BinaryToString(InetRead($url), 4)
If Not $content Then Exit Not MsgBox($MB_ICONERROR, "Lỗi", "Không thể tải trang")
Global $title = StringStripWS(StringRegExp($content, "<title>(.+?)</title>", 3)[0], 7)
$base_dir &= "\" & $title
Global $imgs = StringRegExp($content, '(?i)src="(/images/(?:baitap|tailieu|tintuc)/.+?\.(?:jpg|png|gif))"', 3)
If DirGetSize($base_dir) >= 0 And _
   MsgBox(BitOR($MB_YESNO, $MB_ICONQUESTION), "", "Thư mục đã tồn tại, lưu file tải về vào đó?") = 7 Then Exit

Global $err = "", $count = UBound($imgs), $i = 0
DirCreate($base_dir)
ProgressOn("luyenthithukhoa.vn Downloader", "Đang tải", "", Default, Default, $DLG_MOVEABLE)

For $i = 0 To $count - 1
   $fileName = StringRegExp($imgs[$i], "(?i)[^/]+\.(?:jpg|png|gif)$", 3)[0]
   Local $img_url = $base_url & $imgs[$i], $local_path = $base_dir & "\" & $fileName
   ProgressSet($i * 100 / $count, $imgs[$i])
   FileDelete($local_path)
   InetGet($img_url, $local_path)
   If @error Then $err &= $img_url & @CRLF
Next
ProgressOff()
If $err Then
   FileWrite($title & "_error_report.txt", $err)
   MsgBox(0, "", "Một số ảnh tải về không thành công, xem file " & $title & "_error_report.txt để biết chi tiết")
Else
   _ImagesToPdf($title, $base_dir, "(?i)[^?/\\*:<>|]+\.(jpg|png|bmp|gif)$")
EndIf

Func _ImagesToPdf($title, $img_dir, $filter = "(?i)[^?/\\*:<>|]+\.(jpg|png|bmp|gif)$")
   _SetTitle($title)
   _SetSubject("")
   _SetKeywords("")
   _OpenAfter(False)
   _SetUnit($PDF_UNIT_CM)
   _SetPaperSize("a4")
   _SetZoomMode($PDF_ZOOM_CUSTOM, 90)
   _SetOrientation($PDF_ORIENTATION_PORTRAIT)
   _SetLayoutMode($PDF_LAYOUT_CONTINOUS)
   _InitPDF($img_dir & ".pdf")

   Local $aImgs = _FileList($img_dir, $filter)
   ProgressOn("luyenthithukhoa.vn Downloader", "Đang tạo file pdf", "", Default, Default, $DLG_MOVEABLE)
   Local $size = UBound($aImgs)
   For $i = 1 To $size - 1
	  _LoadResImage("img" & $i, $aImgs[0] & "\" & $aImgs[$i])
	  ProgressSet($i * 100 / $size, $aImgs[$i])
	  _BeginPage()
	  _InsertImage("img" & $i, 0, 0, _GetPageWidth() / _GetUnit(), _GetPageHeight() / _GetUnit())
	  _EndPage()
   Next

   _ClosePDFFile()
   ProgressOff()
EndFunc