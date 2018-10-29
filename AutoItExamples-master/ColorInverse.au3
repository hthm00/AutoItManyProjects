#include <GDIPlus.au3>
Local $sImgName = FileOpenDialog("", "", "All (*.*)", 1)
If @error Then Exit

_GDIPlus_Startup()
Local $hImage = _GDIPlus_BitmapCreateFromHBITMAP(_GDIPlus_BitmapCreateHBITMAPFromBitmap(_GDIPlus_ImageLoadFromFile($sImgName)))
Local $nHeight = _GDIPlus_ImageGetHeight($hImage)
Local $nWidth = _GDIPlus_ImageGetWidth($hImage)
Local $iColor
For $y = 0 To $nHeight -1
   For $x = 0 To $nWidth - 1
	  _GDIPlus_BitmapSetPixel($hImage, $x, $y, BitXOR(0xFFFFFFFF, _GDIPlus_BitmapGetPixel($hImage, $x, $y)))
   Next
Next

_GDIPlus_ImageSaveToFile($hImage, StringRegExpReplace($sImgName, '(^.+)(\..+)$', '\1-color-inversed\2'))
_GDIPlus_Shutdown()