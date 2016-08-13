{-# LANGUAGE TypeSynonymInstances, TypeFamilies, GADTs, FlexibleContexts, EmptyDataDecls, CPP #-}

#ifdef CALLSTACK_AVAILABLE
{-# LANGUAGE ImplicitParams #-}
#endif

#ifdef CALLSTACK_AVAILABLE
#define MAKE_METHOD(Datatype, Method) \
data Datatype a; \
Method :: (?loc :: CallStack, Match r ~ FindOp a a (Datatype ()), Op (Datatype ()) r a impl) => Ref a -> impl; \
Method aRef = (unsafePerformIO $ withRef aRef (\_ -> return ())) `seq` dispatch (undefined :: Datatype()) aRef
#elif HASCALLSTACK_AVAILABLE
#define MAKE_METHOD(Datatype, Method) \
data Datatype a; \
Method :: (HasCallStack, Match r ~ FindOp a a (Datatype ()), Op (Datatype ()) r a impl) => Ref a -> impl; \
Method aRef = (unsafePerformIO $ withRef aRef (\_ -> return ())) `seq` dispatch (undefined :: Datatype()) aRef
#else
#define MAKE_METHOD(Datatype, Method) \
data Datatype a; \
Method :: (Match r ~ FindOp a a (Datatype ()), Op (Datatype ()) r a impl) => Ref a -> impl; \
Method aRef = dispatch (undefined :: Datatype ()) aRef
#endif

module Graphics.UI.FLTK.LowLevel.WebkitMethods
  (
    Webview,
    ResizeFrame,
    resizeFrame,
    Load,
    load,
    LoadString,
    loadString,
    Download,
    download,
    StatusBar,
    statusBar,
    Title,
    title,
    Url,
    url,
    Snapshot,
    snapshot,
    FocusedSource,
    focusedSource,
    ExecuteJS,
    executeJS,
    NumDownloads,
    numDownloads,
    StopDownload,
    stopDownload,
    RemoveDownload,
    removeDownload,
    DownloadFinished,
    downloadFinished,
    DownloadFailed,
    downloadFailed,
    GetDownloadStats,
    getDownloadStats,
    Back,
    back,
    Fwd,
    fwd,
    CanBack,
    canBack,
    CanFwd,
    canFwd,
    Stop,
    stop,
    Refresh,
    refresh,
    IsLoading,
    isLoading,
    Redo,
    redo,
    Paste,
    paste,
    CountFound,
    countFound,
    SetBool,
    setBool,
    GetBool,
    getBool,
    SetDouble,
    setDouble,
    GetDouble,
    getDouble,
    SetInt,
    setInt,
    GetInt,
    getInt,
    SetChar,
    setChar,
    GetChar,
    getChar,
    TitleChangedCB,
    titleChangedCB,
    LoadStateChangedCB,
    loadStateChangedCB,
    ProgressChangedCB,
    progressChangedCB,
    FaviconChangedCB,
    faviconChangedCB,
    StatusChangedCB,
    statusChangedCB,
    HistoryAddCB,
    historyAddCB,
    SiteChangingCB,
    siteChangingCB,
    ErrorCB,
    errorCB,
    BindEvent,
    bindEvent,
    EmulateClick,
    emulateClick,
    GetLinkDetails,
    getLinkDetails,
    IsNoGui,
    isNoGui,
    SelectAll,
    selectAll
  )
where
import Graphics.UI.FLTK.LowLevel.Dispatch
import Graphics.UI.FLTK.LowLevel.Hierarchy
import Graphics.UI.FLTK.LowLevel.Fl_Types
import Prelude hiding (getChar)
#if defined(CALLSTACK_AVAILABLE) || defined(HASCALLSTACK_AVAILABLE)
import GHC.Stack
import System.IO.Unsafe
#endif

data CWebview parent
type Webview = CWebview Widget
type WebviewFuncs =
  (Destroy
  (Handle
  (Resize
  (ResizeFrame
  (Load
  (LoadString
  (Download
  (StatusBar
  (Title
  (Url
  (Snapshot
  (FocusedSource
  (ExecuteJS
  (NumDownloads
  (StopDownload
  (RemoveDownload
  (DownloadFinished
  (DownloadFailed
  (GetDownloadStats
  (Back
  (Fwd
  (CanBack
  (CanFwd
  (Prev
  (Next
  (Stop
  (Refresh
  (IsLoading
  (Undo
  (Redo
  (Copy
  (Cut
  (Paste
  (Find
  (CountFound
  (SetBool
  (GetBool
  (SetDouble
  (GetDouble
  (SetInt
  (GetInt
  (SetChar
  (GetChar
  (TitleChangedCB
  (LoadStateChangedCB
  (ProgressChangedCB
  (FaviconChangedCB
  (StatusChangedCB
  (HistoryAddCB
  (SiteChangingCB
  (ErrorCB
  (BindEvent
  (GetValue
  (EmulateClick
  (GetLinkDetails
  (IsNoGui
  ()))))))))))))))))))))))))))))))))))))))))))))))))))))))))
type instance Functions Webview = WebviewFuncs

MAKE_METHOD(ResizeFrame,resizeFrame)
MAKE_METHOD(LoadString,loadString)
MAKE_METHOD(Download,download)
MAKE_METHOD(StatusBar,statusBar)
MAKE_METHOD(Title,title)
MAKE_METHOD(Url,url)
MAKE_METHOD(Snapshot,snapshot)
MAKE_METHOD(FocusedSource,focusedSource)
MAKE_METHOD(ExecuteJS,executeJS)
MAKE_METHOD(NumDownloads,numDownloads)
MAKE_METHOD(StopDownload,stopDownload)
MAKE_METHOD(RemoveDownload,removeDownload)
MAKE_METHOD(DownloadFinished,downloadFinished)
MAKE_METHOD(DownloadFailed,downloadFailed)
MAKE_METHOD(GetDownloadStats,getDownloadStats)
MAKE_METHOD(Back,back)
MAKE_METHOD(Fwd,fwd)
MAKE_METHOD(CanBack,canBack)
MAKE_METHOD(CanFwd,canFwd)
MAKE_METHOD(Stop,stop)
MAKE_METHOD(Refresh,refresh)
MAKE_METHOD(IsLoading,isLoading)
MAKE_METHOD(Redo,redo)
MAKE_METHOD(Paste,paste)
MAKE_METHOD(CountFound,countFound)
MAKE_METHOD(SetBool,setBool)
MAKE_METHOD(GetBool,getBool)
MAKE_METHOD(SetDouble,setDouble)
MAKE_METHOD(GetDouble,getDouble)
MAKE_METHOD(SetInt,setInt)
MAKE_METHOD(GetInt,getInt)
MAKE_METHOD(SetChar,setChar)
MAKE_METHOD(GetChar,getChar)
MAKE_METHOD(TitleChangedCB,titleChangedCB)
MAKE_METHOD(LoadStateChangedCB,loadStateChangedCB)
MAKE_METHOD(ProgressChangedCB,progressChangedCB)
MAKE_METHOD(FaviconChangedCB,faviconChangedCB)
MAKE_METHOD(StatusChangedCB,statusChangedCB)
MAKE_METHOD(HistoryAddCB,historyAddCB)
MAKE_METHOD(SiteChangingCB,siteChangingCB)
MAKE_METHOD(ErrorCB,errorCB)
MAKE_METHOD(BindEvent,bindEvent)
MAKE_METHOD(EmulateClick,emulateClick)
MAKE_METHOD(GetLinkDetails,getLinkDetails)
MAKE_METHOD(IsNoGui,isNoGui)
