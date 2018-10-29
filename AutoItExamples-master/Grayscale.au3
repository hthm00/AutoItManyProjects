#include <GUIConstantsEx.au3>
#include <GDIPlus.au3>

$file = FileOpenDialog("Choose file", "", "All (*.*)", 3)
If @error Then Exit
GrayscaleImage($file)

Func GrayscaleImage($sImg)
   _GDIPlus_Startup() ;initialize GDI+
   Local $iColor = 0
   Local $hImg = _GDIPlus_ImageLoadFromFile($sImg)
   Local Const $iWidth = _GDIPlus_ImageGetWidth($hImg), $iHeight = _GDIPlus_ImageGetHeight($hImg)
   Local $iR, $iG, $iB, $iGrey
   For $iY = 0 To $iHeight - 1
      For $iX = 0 To $iWidth - 1
         $iColor = _GDIPlus_BitmapGetPixel($hImg, $iX, $iY) ;get current pixel color
         $iR = BitShift(BitAND($iColor, 0x00FF0000), 16) ;extract red color channel
         $iG = BitShift(BitAND($iColor, 0x0000FF00), 8) ;extract green color channel
         $iB = BitAND($iColor, 0x000000FF) ;;extract blue color channel
         $iGrey = Hex(Int(($iR + $iG + $iB) / 3), 2) ;convert pixels to average greyscale color format
         _GDIPlus_BitmapSetPixel($hImg, $iX, $iY, "0xFF" & $iGrey & $iGrey & $iGrey) ;set greyscaled pixel
      Next
   Next
   Local $ext = Extension($sImg)
   _GDIPlus_ImageSaveToFile($hImg, StringTrimRight($sImg, StringLen($ext) + 1) & "-grayscaled." & $ext)

   _GDIPlus_GraphicsDispose($hImg)
   _GDIPlus_Shutdown()
EndFunc   ;==>Example

Func Extension($sPath)
   Local $a = StringSplit($sPath, ".")
   Return $a[$a[0]]
EndFunc