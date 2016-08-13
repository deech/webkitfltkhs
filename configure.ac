AC_PREREQ([2.60])
AC_INIT([webkitfltkc], [0.0.0.1], [aditya dawt siram ayt gmail dawt com])
AC_CONFIG_SRCDIR([c-src/webview_C.h])
AC_LANG_CPLUSPLUS


# Checks for programs.
AC_PROG_CXX
AC_PROG_CC
AC_USE_SYSTEM_EXTENSIONS

# Checks for libraries.
AC_CHECK_PROGS([fltkconfig], [fltk-config13 fltk-config])
if test "x$fltkconfig" = x; then
AC_MSG_ERROR([fltk-config not found])
fi

VER=$($fltkconfig --version)
MINOR=$(echo $VER | cut -d. -f2)
PATCH=$(echo $VER | cut -d. -f3)

if test "$MINOR" -lt 3 || test "$PATCH" -lt 3; then
  AC_MSG_ERROR([FLTK >= 1.3.3 not found, got $VER])
fi

AC_CHECK_LIB([dl], [dlopen], [], AC_MSG_ERROR([libdl not found]))

dnl All of this is requires just to compile the test below to check if
dnl webkitfltk even exists. Sigh ...
PKG_CHECK_MODULES([DEPS], [libxslt libxml-2.0 sqlite3 \
freetype2 fontconfig cairo >= 1.12.18 libpng libcurl \
openssl >= 0.9.8 glib-2.0])
LIBS=["$LIBS $DEPS_LIBS"]
CXXFLAGS=["$CXXFLAGS $($fltkconfig --cxxflags | sed 's@-I@-isystem @g')"]
LIBS=["$LIBS $($fltkconfig --ldflags --use-images)"]
PKG_CHECK_MODULES([CPPDEPS], [harfbuzz harfbuzz-icu icu-uc icu-i18n webkitfltk])
LIBS=["$LIBS $CPPDEPS_LIBS"]
AC_MSG_NOTICE([ Please be patient. Checking for webkitfltk takes a while because it's compiling and linking a program against a 1GB library.])
AC_CHECK_LIB([webkitfltk], [webkitInit], [], AC_MSG_ERROR([libwebkitfltk not found]))

# Checks for header files.
AC_CHECK_HEADERS([stddef.h stdint.h stdlib.h string.h unistd.h])
# Checks for typedefs, structures, and compiler characteristics.
AC_TYPE_SIZE_T

# Checks for library functions.
AC_FUNC_MALLOC
AC_CHECK_FUNCS([select strdup strerror strrchr strtol])

AC_SUBST(ICUFLAGS,["$(icu-config --ldflags)"])
AC_SUBST(FLTKLIBS,["$($fltkconfig --ldflags --use-images)"])
AC_CONFIG_FILES([Makefile c-src/Makefile webkitfltkhs.buildinfo])
AC_OUTPUT
