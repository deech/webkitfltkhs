{-# LANGUAGE CPP #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Graphics.UI.FLTK.LowLevel.Webkit
  (
    -- * Webkit
    -- ** Types
    SettingBool(..),
    SettingDouble(..),
    SettingChar(..),
    UrlBlock(..),
    SSLOk(..),

    -- ** Callback function aliases
    WebkitSSLErrorCallback,
    WebkitSetPopupFunc,
    WebkitSetAboutPageFunc,
    WebkitSetDownloadFunc,
    WebkitSetDownloadRefreshFunc,
    WebkitSetNewDownloadFunc,
    WebkitSetBgTabFunc,
    WebkitSetUserAgentFunc,
    WebkitSetTZFunc,
    WebkitDoneFunc,
    WebkitSetAcceptFunc,
    WebkitSetLanguageFunc,
    WebkitUrlBlockFunc,
    WebkitDirNameFunc,
    WebkitSetSSLFunc,
    WebkitPerSiteSettingsFunc,

    -- ** Webkit functions
    webkitInit,
    wkSetSSLErrorFunc,
    wkSetUrlBlockFunc,
    wkSetUploaddirFunc,
    wkSetDownloaddirFunc,
    wkSetSSLFunc,
    wkSetAboutPageFunc,
    wkSetDownloadFunc,
    wkSetDownloadRefreshFunc,
    wkSetNewDownloadFunc,
    wkSetPopupFunc,
    wkSetBgTabFunc,
    wkDropCaches,
    wkSetStreamingProg,
    wkExit,
    wkUrlEncode,
    wkSetCookiePath,
    wkSetFaviconDir,
    wkGetFaviconWithTargetSize,
    wkGetFavicon,
    wkSetPerSiteSettings,
    wkSetImageMax,
    wkSetUserAgentFunc,
    wkSetTZFunc,
    wkSetAcceptFunc,
    wkSetLanguageFunc,
    wkSetCacheDir,
    wkSetCacheMax,
    wkSetWheelSpeed,
    module Graphics.UI.FLTK.LowLevel.WebkitMethods,

    -- * Webview
    -- ** Types
    DownloadIndex(..),
    DownloadStats(..),
    SearchDirection(..),
    -- ** Callback Function Aliases
    WebviewTitleCallback,
    WebviewCallback,
    WebviewProgressCallback,
    WebviewHistoryCallback,
    WebviewSiteCallback,
    WebviewErrorCallback,
    WebviewBindEventCallback,
    -- ** Constructors
    webviewNew,
    webviewNewWithoutGUI
    -- ** Hierarchy
    --
    -- $hierarchy

    -- ** Webview Functions
    --
    -- $widgetfunctions
  )
where
#include "Fl_ExportMacros.h"
#include "types.h"
#include "webkit_C.h"
#include "webview_C.h"
import Foreign
import Foreign.C hiding (CClock)
import Graphics.UI.FLTK.LowLevel.WebkitMethods
import Graphics.UI.FLTK.LowLevel.Fl_Types
import Graphics.UI.FLTK.LowLevel.Fl_Enumerations hiding (SearchDirection)
import Graphics.UI.FLTK.LowLevel.Dispatch
import Graphics.UI.FLTK.LowLevel.Utils
import Graphics.UI.FLTK.LowLevel.FLTKHS
import C2HS hiding (cFromEnum, cFromBool, cToBool,cToEnum)
import qualified Data.Map.Strict as Map
import qualified Data.ByteString as B

#c
  enum SettingBool {
    WebKitSettingJS = WK_SETTING_JS,
    WebkitSettingCSS = WK_SETTING_CSS,
    WebkitSettingIMG = WK_SETTING_IMG,
    WebkitSettingLocalStorage = WK_SETTING_LOCALSTORAGE,
    WebkitSettingQuietJSDialogs = WK_SETTING_QUIET_JS_DIALOGS
  };

  enum SettingDouble {
    WebkitSettingZoom = WK_SETTING_ZOOM
  };

  enum SettingInt {
    WebkitSettingFontSize = WK_SETTING_FONT_SIZE,
    WebkitSettingFixedSize = WK_SETTING_FIXED_SIZE,
    WebkitSettingMinimumFontSize = WK_SETTING_MINIMUM_FONT_SIZE
  };

  enum SettingChar {
    WebkitSettingDefaultFont = WK_SETTING_DEFAULT_FONT,
    WebkitSettingFixedFont = WK_SETTING_FIXED_FONT,
    WebkitSettingUserCSS = WK_SETTING_USER_CSS
  };
#endc
{#enum SettingBool   {} deriving (Show, Eq) #}
{#enum SettingDouble {} deriving (Show, Eq) #}
{#enum SettingChar   {} deriving (Show, Eq) #}
{#enum SettingInt    {} deriving (Show, Eq) #}

type WebviewTitleCallbackPrim         = IO ()
type WebviewPrim                      = Ptr ()
type WebviewCallbackPrim              = WebviewPrim -> IO ()
type WebviewProgressCallbackPrim      = WebviewPrim -> CFloat -> IO ()
type WebviewHistoryCallbackPrim       = CString -> CString -> CLong -> IO ()
type WebviewSiteCallbackPrim          = WebviewPrim -> CString -> IO ()
type WebviewErrorCallbackPrim         = WebviewPrim -> CString -> IO ()
type WebviewBindEventCallbackPrim     = CString -> CString -> CString -> CString -> IO ()
type WebkitUrlBlockFuncPrim           = CString -> IO CInt
type WebkitDirNameFuncPrim            = IO CString
type WebkitSetSSLFuncPrim             = CString -> CString -> IO CInt
type WebkitSSLErrorCallbackPrim       = WebviewPrim -> CString -> CInt -> IO ()
type WebkitSetAboutPageFuncPrim       = CString -> IO CString
type WebkitSetDownloadFuncPrim        = CString -> CString -> IO ()
type WebkitSetDownloadRefreshFuncPrim = IO ()
type WebkitSetNewDownloadFuncPrim     = IO ()
type WebkitSetBgTabFuncPrim           = CString -> IO ()
type WebkitSetUserAgentFuncPrim       = CString -> IO CString
type WebkitSetTZFuncPrim              = IO CInt
type WebkitDoneFuncPrim               = IO ()
type WebkitSetAcceptFuncPrim          = CString -> IO CString
type WebkitSetLanguageFuncPrim        = CString -> IO CString
type WebkitSetPopupFuncPrim           = CString -> IO WebviewPrim
type WebkitPerSiteSettingsFuncPrim    = CString -> IO ()

data UrlBlock = UrlOk | UrlBlock
data SSLOk = SSLOk | SSLAbort

type WebviewTitleCallback             = IO ()
type WebviewCallback                  = Ref Webview -> IO ()
type WebviewProgressCallback          = Ref Webview -> Float -> IO ()
type WebviewHistoryCallback           = String -> String -> CLong -> IO ()
type WebviewSiteCallback              = Ref Webview -> String -> IO ()
type WebviewErrorCallback             = Ref Webview -> String -> IO ()
type WebviewBindEventCallback         = String -> String -> String -> String -> IO ()
type WebkitSSLErrorCallback           = Ref Webview -> String -> Bool -> IO ()
type WebkitSetPopupFunc               = String -> IO (Ref Webview)
type WebkitSetAboutPageFunc           = String -> IO String
type WebkitSetDownloadFunc            = String -> String -> IO ()
type WebkitSetDownloadRefreshFunc     = IO ()
type WebkitSetNewDownloadFunc         = IO ()
type WebkitSetBgTabFunc               = String -> IO ()
type WebkitSetUserAgentFunc           = String -> IO String
type WebkitSetTZFunc                  = IO Int
type WebkitDoneFunc                   = IO ()
type WebkitSetAcceptFunc              = String -> IO String
type WebkitSetLanguageFunc            = String -> IO String
type WebkitUrlBlockFunc               = String -> IO UrlBlock
type WebkitDirNameFunc                = IO String
type WebkitSetSSLFunc                 = String -> String -> IO SSLOk
type WebkitPerSiteSettingsFunc        = String -> IO ()

foreign import ccall "wrapper" webviewTitleCallbackPtr         :: WebviewTitleCallbackPrim         -> IO (FunPtr WebviewTitleCallbackPrim)
foreign import ccall "wrapper" webviewCallbackPtr              :: WebviewCallbackPrim              -> IO (FunPtr WebviewCallbackPrim)
foreign import ccall "wrapper" webviewProgressCallbackPtr      :: WebviewProgressCallbackPrim      -> IO (FunPtr WebviewProgressCallbackPrim)
foreign import ccall "wrapper" webviewHistoryCallbackPtr       :: WebviewHistoryCallbackPrim       -> IO (FunPtr WebviewHistoryCallbackPrim)
foreign import ccall "wrapper" webviewSiteCallbackPtr          :: WebviewSiteCallbackPrim          -> IO (FunPtr WebviewSiteCallbackPrim)
foreign import ccall "wrapper" webviewErrorCallbackPtr         :: WebviewErrorCallbackPrim         -> IO (FunPtr WebviewErrorCallbackPrim)
foreign import ccall "wrapper" webviewBindEventCallbackPtr     :: WebviewBindEventCallbackPrim     -> IO (FunPtr WebviewBindEventCallbackPrim)
foreign import ccall "wrapper" webkitSSLErrorCallbackPtr       :: WebkitSSLErrorCallbackPrim       -> IO (FunPtr WebkitSSLErrorCallbackPrim)
foreign import ccall "wrapper" webkitSetPopupFuncPtr           :: WebkitSetPopupFuncPrim           -> IO (FunPtr WebkitSetPopupFuncPrim)
foreign import ccall "wrapper" webkitUrlBlockFuncPtr           :: WebkitUrlBlockFuncPrim           -> IO (FunPtr WebkitUrlBlockFuncPrim )
foreign import ccall "wrapper" webkitDirNameFuncPtr            :: WebkitDirNameFuncPrim            -> IO (FunPtr WebkitDirNameFuncPrim )
foreign import ccall "wrapper" webkitSetSSLFuncPtr             :: WebkitSetSSLFuncPrim             -> IO (FunPtr WebkitSetSSLFuncPrim )
foreign import ccall "wrapper" webkitSetAboutPageFuncPtr       :: WebkitSetAboutPageFuncPrim       -> IO (FunPtr WebkitSetAboutPageFuncPrim)
foreign import ccall "wrapper" webkitSetDownloadFuncPtr        :: WebkitSetDownloadFuncPrim        -> IO (FunPtr WebkitSetDownloadFuncPrim)
foreign import ccall "wrapper" webkitSetDownloadRefreshFuncPtr :: WebkitSetDownloadRefreshFuncPrim -> IO (FunPtr WebkitSetDownloadRefreshFuncPrim)
foreign import ccall "wrapper" webkitSetNewDownloadFuncPtr     :: WebkitSetNewDownloadFuncPrim     -> IO (FunPtr WebkitSetNewDownloadFuncPrim)
foreign import ccall "wrapper" webkitSetBgTabFuncPtr           :: WebkitSetBgTabFuncPrim           -> IO (FunPtr WebkitSetBgTabFuncPrim)
foreign import ccall "wrapper" webkitSetUserAgentFuncPtr       :: WebkitSetUserAgentFuncPrim       -> IO (FunPtr WebkitSetUserAgentFuncPrim)
foreign import ccall "wrapper" webkitSetTZFuncPtr              :: WebkitSetTZFuncPrim              -> IO (FunPtr WebkitSetTZFuncPrim)
foreign import ccall "wrapper" webkitDoneFuncPtr               :: WebkitDoneFuncPrim               -> IO (FunPtr WebkitDoneFuncPrim)
foreign import ccall "wrapper" webkitSetAcceptFuncPtr          :: WebkitSetAcceptFuncPrim          -> IO (FunPtr WebkitSetAcceptFuncPrim)
foreign import ccall "wrapper" webkitSetLanguageFuncPtr        :: WebkitSetLanguageFuncPrim        -> IO (FunPtr WebkitSetLanguageFuncPrim)
foreign import ccall "wrapper" webkitPerSiteSettingsFuncPtr    :: WebkitPerSiteSettingsFuncPrim    -> IO (FunPtr WebkitPerSiteSettingsFuncPrim)

toWebviewTitleCallbackPtr  :: WebviewTitleCallback  -> IO (FunPtr WebviewTitleCallback)
toWebviewCallbackPtr              :: WebviewCallback              -> IO (FunPtr WebviewCallbackPrim)
toWebviewProgressCallbackPtr      :: WebviewProgressCallback      -> IO (FunPtr WebviewProgressCallbackPrim)
toWebviewHistoryCallbackPtr       :: WebviewHistoryCallback       -> IO (FunPtr WebviewHistoryCallbackPrim)
toWebviewSiteCallbackPtr          :: WebviewSiteCallback          -> IO (FunPtr WebviewSiteCallbackPrim)
toWebviewErrorCallbackPtr         :: WebviewErrorCallback         -> IO (FunPtr WebviewErrorCallbackPrim)
toWebviewBindEventCallbackPtr     :: WebviewBindEventCallback     -> IO (FunPtr WebviewBindEventCallbackPrim)
toWebkitSSLErrorCallbackPtr       :: WebkitSSLErrorCallback       -> IO (FunPtr WebkitSSLErrorCallbackPrim)
toWebkitSetPopupFuncPtr           :: WebkitSetPopupFunc           -> IO (FunPtr WebkitSetPopupFuncPrim)
toWebkitSetAboutPageFuncPtr       :: WebkitSetAboutPageFunc       -> IO (FunPtr WebkitSetAboutPageFuncPrim)
toWebkitSetDownloadFuncPtr        :: WebkitSetDownloadFunc        -> IO (FunPtr WebkitSetDownloadFuncPrim)
toWebkitSetDownloadRefreshFuncPtr :: WebkitSetDownloadRefreshFunc -> IO (FunPtr WebkitSetDownloadRefreshFuncPrim)
toWebkitSetNewDownloadFuncPtr     :: WebkitSetNewDownloadFunc     -> IO (FunPtr WebkitSetNewDownloadFuncPrim)
toWebkitSetBgTabFuncPtr           :: WebkitSetBgTabFunc           -> IO (FunPtr WebkitSetBgTabFuncPrim)
toWebkitSetUserAgentFuncPtr       :: WebkitSetUserAgentFunc       -> IO (FunPtr WebkitSetUserAgentFuncPrim)
toWebkitSetTZFuncPtr              :: WebkitSetTZFunc              -> IO (FunPtr WebkitSetTZFuncPrim)
toWebkitDoneFuncPtr               :: WebkitDoneFunc               -> IO (FunPtr WebkitDoneFuncPrim)
toWebkitSetAcceptFuncPtr          :: WebkitSetAcceptFunc          -> IO (FunPtr WebkitSetAcceptFuncPrim)
toWebkitSetLanguageFuncPtr        :: WebkitSetLanguageFunc        -> IO (FunPtr WebkitSetLanguageFuncPrim)
toWebkitUrlBlockFuncPtr           :: WebkitUrlBlockFunc           -> IO (FunPtr WebkitUrlBlockFuncPrim )
toWebkitDirNameFuncPtr            :: WebkitDirNameFunc            -> IO (FunPtr WebkitDirNameFuncPrim )
toWebkitSetSSLFuncPtr             :: WebkitSetSSLFunc             -> IO (FunPtr WebkitSetSSLFuncPrim)
toWebkitPerSiteSettingsFuncPtr    :: WebkitPerSiteSettingsFunc    -> IO (FunPtr WebkitPerSiteSettingsFuncPrim)

toWebviewTitleCallbackPtr f =
  webviewTitleCallbackPtr f

toWebviewCallbackPtr f =
  webviewCallbackPtr
  (\ptr -> do
      pp <- wrapNonNull ptr "Null pointer: toWebviewCallbackPtr"
      f (castTo (wrapInRef pp)))

toWebviewProgressCallbackPtr f =
  webviewProgressCallbackPtr
  (\ptr (CFloat progress) -> do
      pp <- wrapNonNull ptr "Null pointer: toWebviewProgressCallbackPtr"
      f (castTo (wrapInRef pp)) progress)

toWebviewHistoryCallbackPtr f =
  webviewHistoryCallbackPtr
  (\ __url __title _when -> do
      _url <- peekCString __url
      _title <- peekCString __title
      f _url _title _when)

toWebviewSiteCallbackPtr f =
  webviewSiteCallbackPtr
  (\ptr __url -> do
      pp <- wrapNonNull ptr "Null pointer: toWebviewSiteCallbackPtr"
      _url <- peekCString __url
      f (castTo (wrapInRef pp)) _url)

toWebviewErrorCallbackPtr f =
  webviewErrorCallbackPtr
  (\ptr _webviewError -> do
      pp <- wrapNonNull ptr "Null pointer: toWebviewErrorCallbackPtr"
      webviewError <- peekCString _webviewError
      f (castTo (wrapInRef pp)) webviewError)

toWebviewBindEventCallbackPtr f =
  webviewBindEventCallbackPtr
  (\ _name _id _cssClass _value -> do
      name <- peekCString _name
      webViewId <- peekCString _id
      cssClass <- peekCString _cssClass
      elemValue <- peekCString _value
      f name webViewId cssClass elemValue)

toWebkitSSLErrorCallbackPtr f =
  webkitSSLErrorCallbackPtr
  (\ptr _err _sub -> do
      pp <- wrapNonNull ptr "Null pointer: toWebkitSSLErrorCallbackPtr"
      err <- peekCString _err
      f (castTo (wrapInRef pp)) err (cToBool _sub))

toWebkitSetPopupFuncPtr f =
  webkitSetPopupFuncPtr
  (\_text -> do
      text <- peekCString _text
      webview <- f text
      unsafeRefToPtr webview
  )

toWebkitSetAboutPageFuncPtr f =
  webkitSetAboutPageFuncPtr
  (\__url -> do
      _url <- peekCString __url
      res <- f _url
      newCString res)

toWebkitSetDownloadFuncPtr f =
  webkitSetDownloadFuncPtr
  (\__url _file -> do
      _url <- peekCString __url
      file <- peekCString _file
      f _url file)

toWebkitSetDownloadRefreshFuncPtr f =
  webkitSetDownloadRefreshFuncPtr f

toWebkitSetNewDownloadFuncPtr f =
  webkitSetNewDownloadFuncPtr f

toWebkitSetBgTabFuncPtr f =
  webkitSetBgTabFuncPtr
  (\__url -> do
      _url <- peekCString __url
      f _url)

toWebkitSetUserAgentFuncPtr f =
  webkitSetUserAgentFuncPtr
  (\__url -> do
      _url <- peekCString __url
      res <- f _url
      newCString res)

toWebkitSetTZFuncPtr f =
  webkitSetTZFuncPtr (f >>= return . fromIntegral)

toWebkitSetAcceptFuncPtr f =
  webkitSetAcceptFuncPtr
  (\__url -> do
      _url <- peekCString __url
      res <- f _url
      newCString res)

toWebkitSetLanguageFuncPtr f =
  webkitSetLanguageFuncPtr
  (\__url -> do
      _url <- peekCString __url
      res <- f _url
      newCString res)

toWebkitUrlBlockFuncPtr f =
  webkitUrlBlockFuncPtr
  (\__url -> do
      _url <- peekCString __url
      res <- f _url
      return (case res of
                UrlOk -> 0
                UrlBlock -> 1))

toWebkitDirNameFuncPtr f =
  webkitDirNameFuncPtr $ do
  res <- f
  newCString res

toWebkitSetSSLFuncPtr f =
  webkitSetSSLFuncPtr
  (\_cert _host -> do
      cert <- peekCString _cert
      host <- peekCString _host
      res <- f cert host
      return (case res of
                SSLOk -> 1
                SSLAbort -> 0))

toWebkitDoneFuncPtr f =
  webkitDoneFuncPtr f

toWebkitPerSiteSettingsFuncPtr f =
  webkitPerSiteSettingsFuncPtr
  (\__url -> do
      _url <- peekCString __url
      f _url)

-- | Init. Call this before show()ing anything.
{# fun webkitInit_C as webkitInit {} -> `()' #}

{# fun wk_set_ssl_err_func_C {id `FunPtr WebkitSSLErrorCallbackPrim' } -> `()' #}
-- | Inform the browser of which tab needs a scary SSL warning
wkSetSSLErrorFunc :: WebkitSSLErrorCallback -> IO ()
wkSetSSLErrorFunc f = do
  fPtr <- toWebkitSSLErrorCallbackPtr f
  wk_set_ssl_err_func_C fPtr

{# fun wk_set_urlblock_func_C {id `FunPtr WebkitUrlBlockFuncPrim' } -> `()' #}
-- | Content blocking. Return 0 for ok, 1 for block.
wkSetUrlBlockFunc :: WebkitUrlBlockFunc -> IO ()
wkSetUrlBlockFunc f = do
  fPtr <- toWebkitUrlBlockFuncPtr f
  wk_set_urlblock_func_C fPtr

{#fun wk_set_uploaddir_func_C {id `FunPtr WebkitDirNameFuncPrim'} -> `()' #}
-- | Where to open files for uploading?
wkSetUploaddirFunc :: WebkitDirNameFunc -> IO ()
wkSetUploaddirFunc f = do
  fPtr <- toWebkitDirNameFuncPtr f
  wk_set_uploaddir_func_C fPtr


{#fun wk_set_downloaddir_func_C {id `FunPtr WebkitDirNameFuncPrim'} -> `()' #}
-- | Where to open files for downloading?
wkSetDownloaddirFunc :: WebkitDirNameFunc -> IO ()
wkSetDownloaddirFunc f = do
  fPtr <- toWebkitDirNameFuncPtr f
  wk_set_downloaddir_func_C fPtr

{# fun wk_set_ssl_func_C {id `FunPtr WebkitSetSSLFuncPrim' } -> `()' #}
-- | SSL control - return 1 if this cert is ok, 0 to abort
wkSetSSLFunc :: WebkitSetSSLFunc -> IO ()
wkSetSSLFunc f = do
  fPtr <- toWebkitSetSSLFuncPtr f
  wk_set_ssl_func_C fPtr

-- | Scrolling speed
{# fun wk_set_wheel_speed_C as wkSetWheelSpeed { `Int' } -> `()' #}

{# fun wk_set_aboutpage_func_C {id `FunPtr WebkitSetAboutPageFuncPrim' } -> `()' #}
-- | about:// pages. Return a malloced array (will be freed), NULL if no such page.
wkSetAboutPageFunc :: WebkitSetAcceptFunc -> IO ()
wkSetAboutPageFunc f = do
  fPtr <- toWebkitSetAboutPageFuncPtr f
  wk_set_aboutpage_func_C fPtr

-- | Callback for finished downloads
{# fun wk_set_download_func_C {id `FunPtr WebkitSetDownloadFuncPrim' } -> `()' #}
wkSetDownloadFunc :: WebkitSetDownloadFunc -> IO ()
wkSetDownloadFunc f = do
  fPtr <- toWebkitSetDownloadFuncPtr f
  wk_set_download_func_C fPtr

-- | Callback that some downloads were updated
{# fun wk_set_download_refresh_func_C {id `FunPtr WebkitSetDownloadRefreshFuncPrim' } -> `()' #}
wkSetDownloadRefreshFunc :: WebkitSetDownloadRefreshFunc -> IO ()
wkSetDownloadRefreshFunc f = do
  fPtr <- toWebkitSetDownloadRefreshFuncPtr f
  wk_set_download_refresh_func_C fPtr

{# fun wk_set_new_download_func_C {id `FunPtr WebkitSetNewDownloadFuncPrim' } -> `()' #}
-- | Callback for when a new download has been started
wkSetNewDownloadFunc :: WebkitSetNewDownloadFunc -> IO ()
wkSetNewDownloadFunc f = do
  fPtr <- toWebkitSetNewDownloadFuncPtr f
  wk_set_new_download_func_C fPtr

{#fun wk_set_popup_func_C {id `FunPtr WebkitSetPopupFuncPrim'} -> `()'#}
-- | Page requests a popup to this address
wkSetPopupFunc :: WebkitSetPopupFunc -> IO ()
wkSetPopupFunc f = do
  fPtr <- toWebkitSetPopupFuncPtr f
  wk_set_popup_func_C fPtr

-- | Please open this address in a background tab
{# fun wk_set_bgtab_func_C { id `FunPtr WebkitSetBgTabFuncPrim ' } -> `()' #}
wkSetBgTabFunc :: WebkitSetBgTabFunc -> IO ()
wkSetBgTabFunc f = do
  fPtr <- toWebkitSetBgTabFuncPtr f
  wk_set_bgtab_func_C fPtr

-- | Drop RAM caches
{# fun wk_drop_caches_C as wkDropCaches {} -> `()' #};

-- | Set streaming program and args, default none
{# fun wk_set_streaming_prog_C as wkSetStreamingProg { unsafeToCString `String' } -> `()' #}

-- | Cleanup on exit. Calls drop_caches.
{# fun wk_exit_C as wkExit {} -> `()' #}

-- | Returns a malloced, url-encoded string
{# fun wk_urlencode_C as wkUrlEncode { unsafeToCString `String' } -> `String' unsafeFromCString #}

-- | Where to store the cookie file?
{# fun wk_set_cookie_path_C as wkSetCookiePath { unsafeToCString `String' } -> `()' #}

{# fun wk_set_favicon_dir_C { unsafeToCString `String', id `Ptr CString', fromIntegral `Int', id `FunPtr WebkitDoneFuncPrim'} -> `()' #}
-- | Favicons
wkSetFaviconDir :: String -> Maybe [String] -> Maybe WebkitDoneFunc -> IO ()
wkSetFaviconDir dir preloads f = do
  _preloadsPtr <- maybe (return (castPtr nullPtr)) (\ploads -> sequence (map newCString ploads) >>= newArray) preloads
  _fPtr <- maybe (return (castFunPtr nullFunPtr)) toWebkitDoneFuncPtr f
  wk_set_favicon_dir_C dir _preloadsPtr (maybe 0 length preloads) _fPtr

{# fun wk_get_favicon_with_targetsize_C {unsafeToCString `String' , id `CUInt' } -> `Maybe (Ref RGBImage)' unsafeToMaybeRef #}
wkGetFaviconWithTargetSize :: String -> Int -> IO (Maybe (Ref RGBImage))
wkGetFaviconWithTargetSize _url targetSize = wk_get_favicon_with_targetsize_C _url (fromIntegral targetSize)

{# fun wk_get_favicon_C {unsafeToCString `String'} -> `Maybe (Ref RGBImage)' unsafeToMaybeRef #}
wkGetFavicon :: String -> IO (Maybe (Ref RGBImage))
wkGetFavicon _url = wk_get_favicon_C _url

{# fun wk_set_cache_dir_C as wkSetCacheDir {unsafeToCString `String'} -> `()' #}
{# fun wk_set_cache_max_C as wkSetCacheMax {fromIntegral `Int'} -> `()' #}

{# fun wk_set_persite_settings_func_C {id `FunPtr WebkitPerSiteSettingsFuncPrim'} -> `()' #}
-- | Per-site settings
wkSetPerSiteSettings :: WebkitPerSiteSettingsFunc -> IO ()
wkSetPerSiteSettings f = do
  fPtr <- toWebkitPerSiteSettingsFuncPtr f
  wk_set_persite_settings_func_C fPtr

-- | Maximum image size. Default is 1024, meaning 1024^2 pixels. Larger ones get resized.
{# fun wk_set_image_max_C as wkSetImageMax {fromIntegral `Int'} -> `()' #}

{# fun wk_set_useragent_func_C {id `FunPtr WebkitSetUserAgentFuncPrim'} -> `()' #}
-- | Spoofing function. Use this for per-page useragents.
wkSetUserAgentFunc :: WebkitSetUserAgentFunc -> IO ()
wkSetUserAgentFunc f = do
  fPtr <- toWebkitSetUserAgentFuncPtr f
  wk_set_useragent_func_C fPtr

{# fun wk_set_tz_func_C { id `FunPtr WebkitSetTZFuncPrim'} -> `()' #}
-- | Spoofing function. Return the number of seconds east of GMT
wkSetTZFunc :: WebkitSetTZFunc -> IO ()
wkSetTZFunc f = do
  fPtr <- toWebkitSetTZFuncPtr f
  wk_set_tz_func_C fPtr

-- | Spoofing function. Return the Accept: header for this page
{# fun wk_set_accept_func_C { id `FunPtr WebkitSetAcceptFuncPrim'} -> `()' #}
wkSetAcceptFunc :: WebkitSetAcceptFunc -> IO ()
wkSetAcceptFunc f = do
  fPtr <- toWebkitSetAcceptFuncPtr f
  wk_set_accept_func_C fPtr

{# fun wk_set_language_func_C { id `FunPtr WebkitSetLanguageFuncPrim'} -> `()' #}
-- | Spoofing function. Return the Accept-language: header for this page
wkSetLanguageFunc :: WebkitSetLanguageFunc -> IO ()
wkSetLanguageFunc f = do
  fPtr <- toWebkitSetLanguageFuncPtr f
  wk_set_language_func_C fPtr


{# fun webview_new { `Int',`Int',`Int',`Int' } -> `Ptr ()' id #}
{# fun webview_new_without_gui { `Int',`Int',`Int',`Int'} -> `Ptr ()' id #}
webviewNew :: Rectangle -> IO (Ref Webview)
webviewNew rectangle =
    let (x_pos, y_pos, width, height) = fromRectangle rectangle
    in
      webview_new x_pos y_pos width height  >>= toRef

webviewNewWithoutGUI :: Rectangle -> IO (Ref Webview)
webviewNewWithoutGUI rectangle =
    let (x_pos, y_pos, width, height) = fromRectangle rectangle
    in
      webview_new_without_gui x_pos y_pos width height  >>= toRef

newtype DownloadIndex = DownloadIndex Int
data DownloadStats =
  DownloadStats
  {
    downloadStart :: CLong,
    downloadSize :: CLLong,
    downloadReceived :: CLLong,
    downloadName :: String,
    downloadUrl :: String
  }
data SearchDirection = SearchDirectionForward | SearchDirectionBackward

{# fun webview_destroy { id `Ptr ()' } -> `()' supressWarningAboutRes #}
instance (impl ~  IO ()) => Op (Destroy ()) Webview orig impl where
  runOp _ _ v = swapRef v $ \vPtr -> do
    webview_destroy vPtr
    return nullPtr

{#fun webview_handle { id `Ptr ()', id `CInt' } -> `Int' #}
instance (impl ~ (Event -> IO Int)) => Op (Handle ()) Webview orig impl where
  runOp _ _ webView event = withRef webView (\p -> webview_handle p (fromIntegral . fromEnum $ event))

{# fun webview_resize { id `Ptr ()',`Int',`Int',`Int',`Int' } -> `()' supressWarningAboutRes #}
instance (impl ~ ( Rectangle -> IO ())) => Op (Resize ()) Webview orig impl where
  runOp _ _ webView rectangle = withRef webView $ \webViewPtr -> do
    let (x_pos,y_pos,w_pos,h_pos) = fromRectangle rectangle
    webview_resize webViewPtr x_pos y_pos w_pos h_pos

{# fun webview_resizeFrame { id `Ptr ()'} -> `()' supressWarningAboutRes #}
instance (impl ~ IO ()) => Op (ResizeFrame ()) Webview orig impl where
  runOp _ _ webView = withRef webView $ \webViewPtr -> webview_resizeFrame webViewPtr

{# fun webview_load { id `Ptr ()',unsafeToCString `String' } -> `()' #}
instance (impl ~ (String ->  IO ())) => Op (Load ()) Webview orig impl where
   runOp _ _ self string = withRef self $ \selfPtr ->  webview_load selfPtr string

{# fun webview_download { id `Ptr()',unsafeToCString `String',unsafeToCString `String' } -> `()' #}
instance (impl ~ ( String -> String ->  IO ())) => Op (Download ()) Webview orig impl where
   runOp _ _ self _url suggestedname = withRef self $ \selfPtr ->  webview_download selfPtr _url suggestedname

{# fun webview_statusbar { id `Ptr()' } -> `String' unsafeFromCString #}
instance (impl ~ (  IO (String))) => Op (StatusBar ()) Webview orig impl where
   runOp _ _ self = withRef self $ \selfPtr -> webview_statusbar selfPtr

{# fun webview_title { id `Ptr()' } -> `String' unsafeFromCString #}
instance (impl ~ (  IO (String))) => Op (Title ()) Webview orig impl where
   runOp _ _ self = withRef self $ \selfPtr -> webview_title selfPtr

{# fun webview_url { id `Ptr()' } -> `String' unsafeFromCString #}
instance (impl ~ (  IO (String))) => Op (Url ()) Webview orig impl where
   runOp _ _ self = withRef self $ \selfPtr -> webview_url selfPtr

{# fun webview_snapshot { id `Ptr()',unsafeToCString `String' } -> `()' #}
instance (impl ~ ( String ->  IO ())) => Op (Snapshot ()) Webview orig impl where
   runOp _ _ self str = withRef self $ \selfPtr -> webview_snapshot  selfPtr str

{# fun webview_focusedSource { id `Ptr()' } -> `String' unsafeFromCString #}
instance (impl ~ (  IO (String))) => Op (FocusedSource ()) Webview orig impl where
   runOp _ _ self = withRef self $ \selfPtr -> webview_focusedSource selfPtr

{# fun webview_executeJS { id `Ptr()', id `CString' } -> `()' #}
instance (impl ~ (B.ByteString ->  IO ())) => Op (ExecuteJS ()) Webview orig impl where
   runOp _ _ self js =
     withRef self $ \selfPtr -> do
     jsCString <- copyByteStringToCString js
     webview_executeJS  selfPtr jsCString

{# fun webview_numDownloads { id `Ptr()' } -> `Int' #}
instance (impl ~ (  IO (Int))) => Op (NumDownloads ()) Webview orig impl where
   runOp _ _ self = withRef self $ \selfPtr -> webview_numDownloads selfPtr

{# fun webview_stopDownload { id `Ptr()',`Int' } -> `()' #}
instance (impl ~ ( DownloadIndex ->  IO ())) => Op (StopDownload ()) Webview orig impl where
   runOp _ _ self (DownloadIndex i) = withRef self $ \selfPtr -> webview_stopDownload  selfPtr i

{# fun webview_removeDownload { id `Ptr()',`Int' } -> `()' #}
instance (impl ~ ( DownloadIndex ->  IO ())) => Op (RemoveDownload ()) Webview orig impl where
   runOp _ _ self (DownloadIndex i) = withRef self $ \selfPtr -> webview_removeDownload  selfPtr i

{# fun webview_downloadFinished { id `Ptr()',`Int' } -> `Bool' cToBool #}
instance (impl ~ ( DownloadIndex ->  IO (Bool))) => Op (DownloadFinished ()) Webview orig impl where
   runOp _ _ self (DownloadIndex i) = withRef self $ \selfPtr -> webview_downloadFinished  selfPtr i

{# fun webview_downloadFailed { id `Ptr()',`Int' } -> `Bool' cToBool #}
instance (impl ~ ( DownloadIndex ->  IO (Bool))) => Op (DownloadFailed ()) Webview orig impl where
   runOp _ _ self (DownloadIndex i) = withRef self $ \selfPtr -> webview_downloadFailed  selfPtr i

{# fun webview_downloadStats { id `Ptr()',`Int', id `Ptr CLong', id `Ptr CLLong' , id ` Ptr CLLong' , id `Ptr CString' , id `Ptr CString' } -> `()' #}
instance (impl ~ ( DownloadIndex -> IO (Maybe DownloadStats))) => Op (GetDownloadStats ()) Webview orig impl where
   runOp _ _ self (DownloadIndex i) = withRef self $ \selfPtr ->
     alloca $ \_timePtr ->
     alloca $ \_sizePtr ->
     alloca $ \_receivedPtr ->
     alloca $ \_namePtr ->
     alloca $ \_urlPtr -> do
        _ <- webview_downloadStats selfPtr i _timePtr _sizePtr _receivedPtr _namePtr _urlPtr
        if (_urlPtr == nullPtr)
         then return Nothing
         else do
            _time <- peek _timePtr
            _size <- peek _sizePtr
            _received <- peek _receivedPtr
            _name <- peek _namePtr >>= peekCString
            _url <- peek _urlPtr >>= peekCString
            return (Just (DownloadStats _time _size _received _name _url))

{# fun webview_back { id `Ptr()' } -> `()' #}
instance (impl ~ (  IO ())) => Op (Back ()) Webview orig impl where
   runOp _ _ self = withRef self $ \selfPtr -> webview_back selfPtr

{# fun webview_fwd { id `Ptr()' } -> `()' #}
instance (impl ~ (  IO ())) => Op (Fwd ()) Webview orig impl where
   runOp _ _ self = withRef self $ \selfPtr -> webview_fwd selfPtr

{# fun webview_canBack { id `Ptr()' } -> `Int' #}
instance (impl ~ (  IO (Int))) => Op (CanBack ()) Webview orig impl where
   runOp _ _ self = withRef self $ \selfPtr -> webview_canBack selfPtr

{# fun webview_canFwd { id `Ptr()' } -> `Int' #}
instance (impl ~ (  IO (Int))) => Op (CanFwd ()) Webview orig impl where
   runOp _ _ self = withRef self $ \selfPtr -> webview_canFwd selfPtr

{# fun webview_prev { id `Ptr()' } -> `()' #}
instance (impl ~ (  IO ())) => Op (Prev ()) Webview orig impl where
   runOp _ _ self = withRef self $ \selfPtr -> webview_prev selfPtr

{# fun webview_next { id `Ptr()' } -> `()' #}
instance (impl ~ (  IO ())) => Op (Next ()) Webview orig impl where
   runOp _ _ self = withRef self $ \selfPtr -> webview_next selfPtr

{# fun webview_stop { id `Ptr()' } -> `()' #}
instance (impl ~ (  IO ())) => Op (Stop ()) Webview orig impl where
   runOp _ _ self = withRef self $ \selfPtr -> webview_stop selfPtr

{# fun webview_refresh { id `Ptr()' } -> `()' #}
instance (impl ~ (  IO ())) => Op (Refresh ()) Webview orig impl where
   runOp _ _ self = withRef self $ \selfPtr -> webview_refresh selfPtr

{# fun webview_isLoading { id `Ptr()' } -> `Int' #}
instance (impl ~ (  IO (Int))) => Op (IsLoading ()) Webview orig impl where
   runOp _ _ self = withRef self $ \selfPtr -> webview_isLoading selfPtr

{# fun webview_undo { id `Ptr()' } -> `()' #}
instance (impl ~ (  IO ())) => Op (Undo ()) Webview orig impl where
   runOp _ _ self = withRef self $ \selfPtr -> webview_undo selfPtr

{# fun webview_redo { id `Ptr()' } -> `()' #}
instance (impl ~ (  IO ())) => Op (Redo ()) Webview orig impl where
   runOp _ _ self = withRef self $ \selfPtr -> webview_redo selfPtr

{# fun webview_selectAll { id `Ptr()' } -> `()' #}
instance (impl ~ (  IO ())) => Op (SelectAll ()) Webview orig impl where
   runOp _ _ self = withRef self $ \selfPtr -> webview_selectAll selfPtr

{# fun webview_copy { id `Ptr()' } -> `()' #}
instance (impl ~ (  IO ())) => Op (Copy ()) Webview orig impl where
   runOp _ _ self = withRef self $ \selfPtr -> webview_copy selfPtr

{# fun webview_cut { id `Ptr()' } -> `()' #}
instance (impl ~ (  IO ())) => Op (Cut ()) Webview orig impl where
   runOp _ _ self = withRef self $ \selfPtr -> webview_cut selfPtr

{# fun webview_paste { id `Ptr()' } -> `()' #}
instance (impl ~ (  IO ())) => Op (Paste ()) Webview orig impl where
   runOp _ _ self = withRef self $ \selfPtr -> webview_paste selfPtr

{# fun webview_find { id `Ptr ()', `String', id `CInt', id `CInt'} -> `Bool' #}
instance (impl ~ ( String -> Bool -> SearchDirection -> IO Bool)) => Op (Find ()) Webview orig impl where
   runOp _ _ self toFind caseSensitive direction =
     withRef self (\ selfPtr -> webview_find selfPtr toFind
                                 (cFromBool caseSensitive)
                                 (case direction of
                                    SearchDirectionForward -> 1
                                    SearchDirectionBackward -> 0))

{# fun webview_countFound { id `Ptr ()', `String', id `CInt' } -> `Int' #}
instance (impl ~ ( String -> Bool -> IO Int)) => Op (CountFound ()) Webview orig impl where
   runOp _ _ self toFind caseSensitive =
     withRef self (\ selfPtr -> do
                      res <- webview_countFound selfPtr toFind (cFromBool caseSensitive)
                      return (fromIntegral res))

{# fun webview_setBool { id `Ptr ()', cFromEnum `SettingBool', `Bool' } -> `()' #}
instance (impl ~ (SettingBool -> Bool -> IO ())) => Op (SetBool ()) Webview orig impl where
  runOp _ _ self settings setting = withRef self $ \selfPtr -> webview_setBool selfPtr settings setting
{# fun webview_getBool { id `Ptr ()', cFromEnum `SettingBool' } -> `Bool' #}
instance (impl ~ (SettingBool -> IO Bool)) => Op (GetBool ()) Webview orig impl where
  runOp _ _ self settings = withRef self $ \selfPtr -> webview_getBool selfPtr settings

{# fun webview_setDouble { id `Ptr ()', cFromEnum `SettingDouble', `Double' } -> `()' #}
instance (impl ~ (SettingDouble -> Double -> IO ())) => Op (SetDouble ()) Webview orig impl where
  runOp _ _ self settings setting = withRef self $ \selfPtr -> webview_setDouble selfPtr settings setting
{# fun webview_getDouble { id `Ptr ()', cFromEnum `SettingDouble' } -> `Double' #}
instance (impl ~ (SettingDouble -> IO Double)) => Op (GetDouble ()) Webview orig impl where
  runOp _ _ self settings = withRef self $ \selfPtr -> webview_getDouble selfPtr settings

{# fun webview_setInt { id `Ptr ()', cFromEnum `SettingInt', `Int' } -> `()' #}
instance (impl ~ (SettingInt -> Int -> IO ())) => Op (SetInt ()) Webview orig impl where
  runOp _ _ self settings setting = withRef self $ \selfPtr -> webview_setInt selfPtr settings setting
{# fun webview_getInt { id `Ptr ()', cFromEnum `SettingInt' } -> `Int' #}
instance (impl ~ (SettingInt -> IO Int)) => Op (GetInt ()) Webview orig impl where
  runOp _ _ self settings = withRef self $ \selfPtr -> webview_getInt selfPtr settings

{# fun webview_setChar { id `Ptr ()', cFromEnum `SettingChar', `String' } -> `()' #}
instance (impl ~ (SettingChar -> String -> IO ())) => Op (SetChar ()) Webview orig impl where
  runOp _ _ self settings setting = withRef self $ \selfPtr -> webview_setChar selfPtr settings setting
{# fun webview_getChar { id `Ptr ()', cFromEnum `SettingChar' } -> `String' #}
instance (impl ~ (SettingChar -> IO String)) => Op (GetChar ()) Webview orig impl where
  runOp _ _ self settings = withRef self $ \selfPtr -> webview_getChar selfPtr settings

{# fun webview_titleChangedCB { id `Ptr ()', id `FunPtr WebviewTitleCallbackPrim' } -> `()' #}
instance (impl ~ (WebviewTitleCallback -> IO ())) => Op (TitleChangedCB ()) Webview orig impl where
  runOp _ _ self cb = withRef self $ \selfPtr -> do
    fPtr <- toWebviewTitleCallbackPtr cb
    webview_titleChangedCB selfPtr fPtr

{# fun webview_loadStateChangedCB { id `Ptr ()', id `FunPtr WebviewCallbackPrim' } -> `()' #}
instance (impl ~ (WebviewCallback -> IO ())) => Op (LoadStateChangedCB ()) Webview orig impl where
  runOp _ _ self cb = withRef self $ \selfPtr -> do
    fPtr <- toWebviewCallbackPtr cb
    webview_loadStateChangedCB selfPtr fPtr

{# fun webview_progressChangedCB { id `Ptr ()', id `FunPtr WebviewProgressCallbackPrim' } -> `()' #}
instance (impl ~ (WebviewProgressCallback -> IO ())) => Op (ProgressChangedCB ()) Webview orig impl where
  runOp _ _ self cb = withRef self $ \selfPtr -> do
    fPtr <- toWebviewProgressCallbackPtr cb
    webview_progressChangedCB selfPtr fPtr

{# fun webview_faviconChangedCB { id `Ptr ()', id `FunPtr WebviewCallbackPrim' } -> `()' #}
instance (impl ~ (WebviewCallback -> IO ())) => Op (FaviconChangedCB ()) Webview orig impl where
  runOp _ _ self cb = withRef self $ \selfPtr -> do
    fPtr <- toWebviewCallbackPtr cb
    webview_faviconChangedCB selfPtr fPtr

{# fun webview_statusChangedCB { id `Ptr ()', id `FunPtr WebviewCallbackPrim' } -> `()' #}
instance (impl ~ (WebviewCallback -> IO ())) => Op (StatusChangedCB ()) Webview orig impl where
  runOp _ _ self cb = withRef self $ \selfPtr -> do
    fPtr <- toWebviewCallbackPtr cb
    webview_statusChangedCB selfPtr fPtr

{# fun webview_historyAddCB { id `Ptr ()', id `FunPtr WebviewHistoryCallbackPrim' } -> `()' #}
instance (impl ~ (WebviewHistoryCallback -> IO ())) => Op (HistoryAddCB ()) Webview orig impl where
  runOp _ _ self cb = withRef self $ \selfPtr -> do
    fPtr <- toWebviewHistoryCallbackPtr cb
    webview_historyAddCB selfPtr fPtr

{# fun webview_siteChangingCB { id `Ptr ()', id `FunPtr WebviewSiteCallbackPrim' } -> `()' #}
instance (impl ~ (WebviewSiteCallback -> IO ())) => Op (SiteChangingCB ()) Webview orig impl where
  runOp _ _ self cb = withRef self $ \selfPtr -> do
    fPtr <- toWebviewSiteCallbackPtr cb
    webview_siteChangingCB selfPtr fPtr

{# fun webview_errorCB { id `Ptr ()', id `FunPtr WebviewErrorCallbackPrim' } -> `()' #}
instance (impl ~ (WebviewErrorCallback -> IO ())) => Op (ErrorCB ()) Webview orig impl where
  runOp _ _ self cb = withRef self $ \selfPtr -> do
    fPtr <- toWebviewErrorCallbackPtr cb
    webview_errorCB selfPtr fPtr

{# fun webview_bindEvent { id `Ptr ()', `String', id `CString', `String', id `FunPtr WebviewBindEventCallbackPrim', `Bool' } -> `()' #}
instance (impl ~ (String -> Maybe String -> String -> WebviewBindEventCallback -> Bool -> IO ())) => Op (BindEvent ()) Webview orig impl where
  runOp _ _ self element elementType eventName cb capture =
    withRef self $ \selfPtr -> do
    fPtr <- toWebviewBindEventCallbackPtr cb
    _elementType <- maybe (return (castPtr nullPtr)) newCString elementType
    webview_bindEvent selfPtr element _elementType eventName fPtr capture

{# fun webview_getValue { id `Ptr ()', `String', id `CString', id `CString'} -> `String' #}
instance (impl ~ (String -> Maybe String -> Maybe String -> IO String)) => Op (GetValue ()) Webview orig impl where
  runOp _ _ self element elementType cssClass =
    withRef self $ \selfPtr -> do
    _elementType <- maybe (return (castPtr nullPtr)) newCString elementType
    _cssClass <- maybe (return (castPtr nullPtr)) newCString cssClass
    webview_getValue selfPtr element _elementType _cssClass

{# fun webview_emulateClick { id `Ptr ()', `String', id `CString', id `CString'} -> `()' #}
instance (impl ~ (String -> Maybe String -> Maybe String -> IO ())) => Op (EmulateClick ()) Webview orig impl where
  runOp _ _ self element elementType cssClass =
    withRef self $ \selfPtr -> do
    _elementType <- maybe (return (castPtr nullPtr)) newCString elementType
    _cssClass <- maybe (return (castPtr nullPtr)) newCString cssClass
    webview_emulateClick selfPtr element _elementType _cssClass

{# fun webview_getLinkDetails { id `Ptr ()', `CString', id `Ptr CString', id `Ptr CString' } -> `Int' #}
instance (impl ~ (Maybe String -> IO (Map.Map String String))) => Op (GetLinkDetails ()) Webview orig impl where
  runOp _ _ self cssClass =
    alloca $ \hrefsPtr ->
    alloca $ \textsPtr ->
    withRef self $ \selfPtr -> do
      _cssClass <- maybe (return (castPtr nullPtr)) newCString cssClass
      _num <- webview_getLinkDetails selfPtr _cssClass hrefsPtr textsPtr
      hrefs <- peekArray _num hrefsPtr >>= sequence . map peekCString
      texts <- peekArray _num textsPtr >>= sequence . map peekCString
      return (Map.fromList (zip hrefs texts))

-- $hierarchy
-- @
-- "Graphics.UI.FLTK.LowLevel.Widget"
--  |
--  v
-- "Graphics.UI.FLTK.LowLevel.Webview"
-- @


-- $widgetfunctions
-- @
--
-- back :: 'Ref' 'Webview' -> 'IO' ()
--
-- bindEvent :: 'Ref' 'Webview' -> 'String' -> 'Maybe' 'String' -> 'String' -> 'WebviewBindEventCallback' -> 'Bool' -> 'IO' ()
--
-- canBack :: 'Ref' 'Webview' -> 'IO' ('Int')
--
-- canFwd :: 'Ref' 'Webview' -> 'IO' ('Int')
--
-- copy :: 'Ref' 'Webview' -> 'IO' ()
--
-- countFound :: 'Ref' 'Webview' -> 'String' -> 'Bool' -> 'IO' 'Int'
--
-- cut :: 'Ref' 'Webview' -> 'IO' ()
--
-- destroy :: 'Ref' 'Webview' -> 'IO' ()
--
-- download :: 'Ref' 'Webview' -> 'String' -> 'String' -> 'IO' ()
--
-- downloadFailed :: 'Ref' 'Webview' -> 'DownloadIndex' -> 'IO' ('Bool')
--
-- downloadFinished :: 'Ref' 'Webview' -> 'DownloadIndex' -> 'IO' ('Bool')
--
-- emulateClick :: 'Ref' 'Webview' -> 'String' -> 'Maybe' 'String' -> 'Maybe' 'String' -> 'IO' ()
--
-- errorCB :: 'Ref' 'Webview' -> 'WebviewErrorCallback' -> 'IO' ()
--
-- executeJS :: 'Ref' 'Webview' -> 'B.ByteString' -> 'IO' ()
--
-- faviconChangedCB :: 'Ref' 'Webview' -> 'WebviewCallback' -> 'IO' ()
--
-- find :: 'Ref' 'Webview' -> 'String' -> 'Bool' -> 'SearchDirection' -> 'IO' 'Bool'
--
-- focusedSource :: 'Ref' 'Webview' -> 'IO' ('String')
--
-- fwd :: 'Ref' 'Webview' -> 'IO' ()
--
-- getBool :: 'Ref' 'Webview' -> 'SettingBool' -> 'IO' 'Bool'
--
-- getChar :: 'Ref' 'Webview' -> 'SettingChar' -> 'IO' 'String'
--
-- getDouble :: 'Ref' 'Webview' -> 'SettingDouble' -> 'IO' 'Double'
--
-- getDownloadStats :: 'Ref' 'Webview' -> 'DownloadIndex' -> 'IO' ('Maybe' 'DownloadStats')
--
-- getInt :: 'Ref' 'Webview' -> 'SettingInt' -> 'IO' 'Int'
--
-- getLinkDetails :: 'Ref' 'Webview' -> 'Maybe' 'String' -> 'IO' ('Map.Map' 'String' 'String')
--
-- getValue :: 'Ref' 'Webview' -> 'String' -> 'Maybe' 'String' -> 'Maybe' 'String' -> 'IO' 'String'
--
-- handle :: 'Ref' 'Webview' -> 'Event' -> 'IO' 'Int'
--
-- historyAddCB :: 'Ref' 'Webview' -> 'WebviewHistoryCallback' -> 'IO' ()
--
-- isLoading :: 'Ref' 'Webview' -> 'IO' ('Int')
--
-- load :: 'Ref' 'Webview' -> 'String' -> 'IO' ()
--
-- loadStateChangedCB :: 'Ref' 'Webview' -> 'WebviewCallback' -> 'IO' ()
--
-- next :: 'Ref' 'Webview' -> 'IO' ()
--
-- numDownloads :: 'Ref' 'Webview' -> 'IO' ('Int')
--
-- paste :: 'Ref' 'Webview' -> 'IO' ()
--
-- prev :: 'Ref' 'Webview' -> 'IO' ()
--
-- progressChangedCB :: 'Ref' 'Webview' -> 'WebviewProgressCallback' -> 'IO' ()
--
-- redo :: 'Ref' 'Webview' -> 'IO' ()
--
-- refresh :: 'Ref' 'Webview' -> 'IO' ()
--
-- removeDownload :: 'Ref' 'Webview' -> 'DownloadIndex' -> 'IO' ()
--
-- resize :: 'Ref' 'Webview' -> 'Rectangle' -> 'IO' ()
--
-- resizeFrame :: 'Ref' 'Webview' -> 'IO' ()
--
-- selectAll :: 'Ref' 'Webview' -> 'IO' ()
--
-- setBool :: 'Ref' 'Webview' -> 'SettingBool' -> 'Bool' -> 'IO' ()
--
-- setChar :: 'Ref' 'Webview' -> 'SettingChar' -> 'String' -> 'IO' ()
--
-- setDouble :: 'Ref' 'Webview' -> 'SettingDouble' -> 'Double' -> 'IO' ()
--
-- setInt :: 'Ref' 'Webview' -> 'SettingInt' -> 'Int' -> 'IO' ()
--
-- siteChangingCB :: 'Ref' 'Webview' -> 'WebviewSiteCallback' -> 'IO' ()
--
-- snapshot :: 'Ref' 'Webview' -> 'String' -> 'IO' ()
--
-- statusBar :: 'Ref' 'Webview' -> 'IO' ('String')
--
-- statusChangedCB :: 'Ref' 'Webview' -> 'WebviewCallback' -> 'IO' ()
--
-- stop :: 'Ref' 'Webview' -> 'IO' ()
--
-- stopDownload :: 'Ref' 'Webview' -> 'DownloadIndex' -> 'IO' ()
--
-- title :: 'Ref' 'Webview' -> 'IO' ('String')
--
-- titleChangedCB :: 'Ref' 'Webview' -> 'WebviewTitleCallback' -> 'IO' ()
--
-- undo :: 'Ref' 'Webview' -> 'IO' ()
--
-- url :: 'Ref' 'Webview' -> 'IO' ('String')
-- @
