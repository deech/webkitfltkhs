{-# LANGUAGE CPP #-}
import Data.Maybe(fromJust, isJust, fromMaybe, maybeToList)
import Distribution.Simple.Compiler
import Distribution.Simple.LocalBuildInfo
import Distribution.PackageDescription
import Distribution.Simple
import Distribution.System
import Distribution.Simple.Setup
import Distribution.Simple.Utils
import Distribution.Verbosity
import Distribution.Text ( display )
import Control.Monad
import Data.List
import Distribution.Simple.Program
  ( Program(..), ConfiguredProgram(..), programPath
   , requireProgram, requireProgramVersion
   , rawSystemProgramConf, rawSystemProgram
   , greencardProgram, cpphsProgram, hsc2hsProgram, c2hsProgram
   , happyProgram, alexProgram, ghcProgram, gccProgram, requireProgram, arProgram)
import Distribution.Simple.Program.Db
import Distribution.Simple.PreProcess
import Distribution.Simple.Register ( generateRegistrationInfo, registerPackage )
import System.IO.Unsafe (unsafePerformIO)
import System.IO.Error
import qualified Distribution.Simple.Program.Ar    as Ar
import qualified Distribution.ModuleName as ModuleName
import Distribution.Simple.BuildPaths
import System.Directory(getCurrentDirectory, getDirectoryContents, doesDirectoryExist)
import System.FilePath ( (</>), (<.>), takeExtension, combine, takeBaseName)
import qualified Distribution.Simple.GHC  as GHC
import qualified Distribution.Simple.JHC  as JHC
import qualified Distribution.Simple.LHC  as LHC
import qualified Distribution.Simple.UHC  as UHC
import qualified Distribution.Simple.PackageIndex as PackageIndex
import Distribution.PackageDescription as PD
import Distribution.InstalledPackageInfo (extraGHCiLibraries, showInstalledPackageInfo)
import System.Environment (getEnv, setEnv)

main :: IO ()
main = defaultMainWithHooks defaultUserHooks {
  preConf = case buildOS of
              Windows -> myCMakePreConf
              _ -> myPreConf,
  buildHook = myBuildHook,
  cleanHook = myCleanHook,
  copyHook = copyCBindings,
  regHook = registerHook
  }

myPreConf :: Args -> ConfigFlags -> IO HookedBuildInfo
myPreConf args flags = do
   putStrLn "Running autoconf ..."
   rawSystemExit normal "autoconf" []
   preConf defaultUserHooks args flags

myCMakePreConf :: Args -> ConfigFlags -> IO HookedBuildInfo
myCMakePreConf args flags =
  do
    let runCMake = do
        fltkHome <- getEnv "FLTK_HOME"
        putStrLn "Running cmake ..."
        rawSystemExit verbose "cmake" [".", "-G", "MSYS Makefiles", "-DFLTK_HOME=" ++ fltkHome]
    clibExists <- doesDirectoryExist webkitfltkcdir
    if (not clibExists)
     then runCMake
     else do
       libs <- getDirectoryContents webkitfltkcdir
       if (null $ filter ((==) "libwebkitfltkc.dll") libs)
        then runCMake
        else return ()
       return ()
    preConf defaultUserHooks args flags

webkitfltkcdir = unsafePerformIO getCurrentDirectory ++ "/c-lib"
webkitfltkclib = "webkitfltkc"

addToEnvironmentVariable :: String -> String -> IO ()
addToEnvironmentVariable env value = do
  currentLdLibraryPath <- tryIOError (getEnv env)
  setEnv env ((either (const "") (\curr -> curr ++ ":") currentLdLibraryPath) ++ value)

myBuildHook pkg_descr local_bld_info user_hooks bld_flags =
  do let compileC = do
             putStrLn "==Compiling C bindings=="
             case buildOS of
              Windows -> rawSystemExit normal "make" []
              os | os `elem` [FreeBSD, OpenBSD, NetBSD, DragonFly]
                -> rawSystemExit normal "gmake" []
              _ -> rawSystemExit normal "make" []
     cdirexists <- doesDirectoryExist webkitfltkcdir
     if cdirexists
       then
       do
        clibraries <- getDirectoryContents webkitfltkcdir
        when (null $ filter (Data.List.isInfixOf "webkitfltkc") clibraries) compileC
       else compileC
     case buildOS of
       Windows -> addToEnvironmentVariable "PATH" webkitfltkcdir
       Linux -> do
         addToEnvironmentVariable "LD_LIBRARY_PATH" webkitfltkcdir
         addToEnvironmentVariable "LIBRARY_PATH" webkitfltkcdir
       _ -> do
         addToEnvironmentVariable "DYLD_LIBRARY_PATH" webkitfltkcdir
         addToEnvironmentVariable "LIBRARY_PATH" webkitfltkcdir
     buildHook defaultUserHooks pkg_descr local_bld_info user_hooks bld_flags

copyCBindings :: PackageDescription -> LocalBuildInfo -> UserHooks -> CopyFlags -> IO ()
copyCBindings pkg_descr lbi uhs flags = do
    (copyHook defaultUserHooks) pkg_descr lbi uhs flags
    let libPref = libdir . absoluteInstallDirs pkg_descr lbi
                . fromFlag . copyDest
                $ flags
    rawSystemExit (fromFlag $ copyVerbosity flags) "cp"
        ["c-lib" </> "libwebkitfltkc.a", libPref]
    case buildOS of
     os | os `elem` [Linux, FreeBSD, OpenBSD, NetBSD, DragonFly]
       -> rawSystemExit (fromFlag $ copyVerbosity flags) "cp"
            ["c-lib" </> "libwebkitfltkc-dyn.so", libPref]
     OSX -> rawSystemExit (fromFlag $ copyVerbosity flags) "cp"
              ["c-lib" </> "libwebkitfltkc-dyn.dylib", libPref]
     Windows ->
            rawSystemExit (fromFlag $ copyVerbosity flags) "cp"
              ["c-lib" </> "libwebkitfltkc-dyn.dll", libPref]

myCleanHook pd x uh cf = do
  case buildOS of
   os | os `elem` [FreeBSD, OpenBSD, NetBSD, DragonFly]
     -> rawSystemExit normal "gmake" ["clean"]
   _ -> rawSystemExit normal "make" ["clean"]
  cleanHook defaultUserHooks pd x uh cf

-- Based on code in "Gtk2HsSetup.hs" from "gtk" package
registerHook pkg_descr localbuildinfo _ flags =
    if hasLibs pkg_descr
    then register pkg_descr localbuildinfo flags
    else setupMessage verbosity
           "Package contains no library to register:" (packageId pkg_descr)
  where verbosity = fromFlag (regVerbosity flags)

register :: PackageDescription -> LocalBuildInfo -> RegisterFlags -> IO ()
register pkg@PackageDescription { library = Just lib } lbi regFlags = do
    let clbi = getComponentLocalBuildInfo lbi CLibName

    installedPkgInfoRaw <- generateRegistrationInfo

                           verbosity pkg lib lbi clbi inplace False distPref packageDb


    let installedPkgInfo = installedPkgInfoRaw {
                                -- this is what this whole register code is all about
                                extraGHCiLibraries =
                                  case buildOS of
                                    Windows -> ["libwebkitfltkc-dyn"]
                                    _ -> ["webkitfltkc-dyn"]
                                }

     -- Three different modes:
    case () of
     _ | modeGenerateRegFile   -> writeRegistrationFile installedPkgInfo
       | modeGenerateRegScript -> die "Generate Reg Script not supported"
       | otherwise             ->
#if __GLASGOW_HASKELL__ >= 800
          registerPackage verbosity (compiler lbi) (withPrograms lbi) False {- multiinstance -} packageDbs installedPkgInfo
#else
          registerPackage verbosity installedPkgInfo pkg lbi inplace packageDbs
#endif
  where
    modeGenerateRegFile = isJust (flagToMaybe (regGenPkgConf regFlags))
    regFile             = fromMaybe (display (packageId pkg) <.> "conf")
                                    (fromFlag (regGenPkgConf regFlags))
    modeGenerateRegScript = fromFlag (regGenScript regFlags)
    inplace   = fromFlag (regInPlace regFlags)
    packageDbs = nub $ withPackageDB lbi
                    ++ maybeToList (flagToMaybe  (regPackageDB regFlags))
    packageDb = registrationPackageDB packageDbs
    distPref  = fromFlag (regDistPref regFlags)
    verbosity = fromFlag (regVerbosity regFlags)

    writeRegistrationFile installedPkgInfo = do
      notice verbosity ("Creating package registration file: " ++ regFile)
      writeUTF8File regFile (showInstalledPackageInfo installedPkgInfo)
