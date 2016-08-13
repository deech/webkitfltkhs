#ifndef __WEBKIT_C__
#define __WEBKIT_C__
#ifdef __cplusplus
#include <stdio.h>
#include <stdlib.h>
#include "webkitfltk/webview.h"
#include "webkitfltk/webkit.h"
#include "Fl_ExportMacros.h"
#include "types.h"
EXPORT {
  class CallbackStore {
  public:
    static webkitSSLErrorCallback* errorCb;
    static webkitPopupFunc* popupFuncCb;
    static void interceptErrorCallback(webview* v, const char * err, const bool sub){
      (*CallbackStore::errorCb)((void*)v, err, sub ? 1 : 0);
    }
    static webview* interceptPopupFuncCallback(const char* s){
      return (webview*)(*CallbackStore::popupFuncCb)(s);
    }
  };
#endif
  FL_EXPORT_C(void ,webkitInit_C)();
  FL_EXPORT_C(void ,wk_set_urlblock_func_C)(int (*func)(const char *));
  FL_EXPORT_C(void ,wk_set_uploaddir_func_C)(const char * (*func)());
  FL_EXPORT_C(void ,wk_set_downloaddir_func_C)(const char * (*func)());
  FL_EXPORT_C(void ,wk_set_ssl_func_C)(int (*func)(const char *, const char *));
  FL_EXPORT_C(void ,wk_set_wheel_speed_C)(const int in);
  FL_EXPORT_C(void ,wk_set_aboutpage_func_C)(const char * (*func)(const char *));
  FL_EXPORT_C(void ,wk_set_download_func_C)(void (*func)(const char *url, const char *file));
  FL_EXPORT_C(void ,wk_set_download_refresh_func_C)(void (*func)());
  FL_EXPORT_C(void ,wk_set_new_download_func_C)(void (*func)());
  FL_EXPORT_C(void ,wk_set_bgtab_func_C)(void (*func)(const char*));
  FL_EXPORT_C(void ,wk_drop_caches_C)();
  FL_EXPORT_C(void ,wk_set_streaming_prog_C)(const char *);
  FL_EXPORT_C(void ,wk_exit_C)();
  FL_EXPORT_C(char*,wk_urlencode_C)(const char *in);
  FL_EXPORT_C(void ,wk_set_cookie_path_C)(const char *path);
  FL_EXPORT_C(void*,wk_get_favicon_C)(const char *url);
  FL_EXPORT_C(void*,wk_get_favicon_with_targetsize_C)(const char *url, const unsigned targetsize);
  FL_EXPORT_C(void ,wk_set_cache_dir_C)(const char *dir);
  FL_EXPORT_C(void ,wk_set_cache_max_C)(const unsigned bytes);
  FL_EXPORT_C(void ,wk_set_persite_settings_func_C)(void (*func)(const char*));
  FL_EXPORT_C(void ,wk_set_image_max_C)(const unsigned size);
  FL_EXPORT_C(void ,wk_set_useragent_func_C)(const char * (*func)(const char *));
  FL_EXPORT_C(void ,wk_set_tz_func_C)(int (*func)());
  FL_EXPORT_C(void ,wk_set_accept_func_C)(const char *(*func)(const char*));
  FL_EXPORT_C(void ,wk_set_language_func_C)(const char *(*func)(const char *));
  FL_EXPORT_C(void, wk_set_ssl_err_func_C)(webkitSSLErrorCallback*);
  FL_EXPORT_C(void, wk_set_popup_func_C)(webkitPopupFunc*);
  FL_EXPORT_C(void, wk_set_favicon_dir_C)(const char* dir, const char** preloads, long unsigned len, void (*done)());
#ifdef __cplusplus
}
#endif
#endif /* __WEBKIT_C__ */
