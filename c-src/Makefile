FLTKCONFIG=fltk-config
CXX = $(shell $(FLTKCONFIG) --cxx) -Wall -fno-rtti -DINTERNAL_LINKAGE -g -Icpp -I../
CXXSHARED = $(CXX)
CXXSTATIC = $(CXX) -static

CPPFILES= \
  webview_C.cpp \
	webkit_C.cpp

LIBNAME = libwebkitfltkc
OBJECTS = $(CPPFILES:.cpp=.o)
LIBDIR = ../c-lib
SHARED_OBJECT_FILES = ../shared_object_files
STATIC_OBJECT_FILES = ../static_object_files

ifeq ($(shell uname) , Darwin)
	SHARED_EXT=dylib
	SONAME_FLAGS=-dynamiclib -install_name
else
	SHARED_EXT=so
	SONAME_FLAGS= -shared -Wl,-soname
endif
.SILENT:
all: libwebkitfltkc.a libwebkitfltkc-dyn.$(SHARED_EXT)
.SUFFIXES: .cpp .o
.cpp.o:
	test -d $(STATIC_OBJECT_FILES) || mkdir $(STATIC_OBJECT_FILES)
	test -d $(SHARED_OBJECT_FILES) || mkdir $(SHARED_OBJECT_FILES)
	@echo "*** Compiling $<..."
	$(CXXSTATIC) -c -fPIC $^ -o $(STATIC_OBJECT_FILES)/$@
	$(CXXSHARED) -c -fPIC $^ -o $(SHARED_OBJECT_FILES)/$@
libwebkitfltkc.a : $(OBJECTS)
	test -d $(LIBDIR) || mkdir $(LIBDIR)
	@echo "*** Linking $@..."
	(cd $(STATIC_OBJECT_FILES); \
	ar rcs $(LIBDIR)/$@ $^;)
libwebkitfltkc-dyn.so : $(OBJECTS)
	test -d $(LIBDIR) || mkdir $(LIBDIR)
	@echo "*** Linking $@..."
	(cd $(SHARED_OBJECT_FILES); \
	$(CXX) $(SONAME_FLAGS),$(LIBDIR)/$@ -o $(LIBDIR)/$@ $^);
libwebkitfltkc-dyn.dylib: $(OBJECTS)
	test -d $(LIBDIR) || mkdir $(LIBDIR)
	@echo "*** Linking $@..."
	(cd $(SHARED_OBJECT_FILES); \
	$(CXX) $(SONAME_FLAGS),$(LIBDIR)/$@ -o $(LIBDIR)/$@ $^ -L/usr/local/lib);
clean:
	test -d $(LIBDIR) && rm -rf $(LIBDIR)
	test -d $(SHARED_OBJECT_FILES) && rm -rf $(SHARED_OBJECT_FILES)
	test -d $(STATIC_OBJECT_FILES) && rm -rf $(STATIC_OBJECT_FILES)
