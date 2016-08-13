#ifndef __TYPES__
#define __TYPES__
#include <time.h>
typedef void*  webviewC;
typedef void  (webviewCallback)(void*);
typedef void  (webviewProgressCallback)(void*,float);
typedef void  (webviewHistoryCallback)(const char* url, const char* title, const time_t when);
typedef void  (webviewSiteCallback)(void*,const char*);
typedef void  (webviewErrorCallback)(void*, const char*);
// typedef void (webviewResourceCallback)(unsigned long, int);
typedef void  (webviewBindEventCallback)(const char *name, const char *id, const char *cssclass, const char *value);
typedef void  (webkitSSLErrorCallback)(void*, const char *, const int sub);
typedef void* (webkitPopupFunc)(const char*);

#endif
