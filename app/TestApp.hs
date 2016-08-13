module Main where

import qualified Graphics.UI.FLTK.LowLevel.FL as FL
import Graphics.UI.FLTK.LowLevel.FLTKHS
import Graphics.UI.FLTK.LowLevel.Webkit
import System.Environment

main :: IO ()
main = do
  webkitInit
  win <- windowNew
            (Size (Width 800) (Height 600))
            Nothing
            Nothing
  v <- webviewNew (toRectangle (0,0,800,600))
  showWidget win
  load v "http://www.google.com"
  return ()
