#include "webkit_C.h"
#ifdef __cplusplus
webkitSSLErrorCallback* CallbackStore::errorCb;
webkitPopupFunc* CallbackStore::popupFuncCb;
EXPORT {
#endif
  FL_EXPORT_C(void ,webkitInit_C)(){
    webkitInit();
  };
  FL_EXPORT_C(void ,wk_set_urlblock_func_C)(int (*func)(const char *)){
    wk_set_urlblock_func(func);
  };
  FL_EXPORT_C(void ,wk_set_uploaddir_func_C)(const char * (*func)()){
    wk_set_uploaddir_func(func);
  };
  FL_EXPORT_C(void ,wk_set_downloaddir_func_C)(const char * (*func)()){
    wk_set_downloaddir_func(func);
  };
  FL_EXPORT_C(void ,wk_set_ssl_func_C)(int (*func)(const char *, const char *)){
    wk_set_ssl_func(func);
  };
  FL_EXPORT_C(void ,wk_set_wheel_speed_C)(const int in){
    wk_set_wheel_speed(in);
  };
  FL_EXPORT_C(void ,wk_set_aboutpage_func_C)(const char * (*func)(const char *)){
    wk_set_aboutpage_func(func);
  };
  FL_EXPORT_C(void ,wk_set_download_func_C)(void (*func)(const char *url, const char *file)){
    wk_set_download_func(func);
  };
  FL_EXPORT_C(void ,wk_set_download_refresh_func_C)(void (*func)()){
    wk_set_download_refresh_func(func);
  };
  FL_EXPORT_C(void ,wk_set_new_download_func_C)(void (*func)()){
    wk_set_new_download_func(func);
  };
  FL_EXPORT_C(void ,wk_set_bgtab_func_C)(void (*func)(const char*)){
    wk_set_bgtab_func(func);
  };
  FL_EXPORT_C(void ,wk_drop_caches_C)(){
    wk_drop_caches();
  };
  FL_EXPORT_C(void ,wk_set_streaming_prog_C)(const char * str){
    wk_set_streaming_prog(str);
  };
  FL_EXPORT_C(void ,wk_exit_C)(){
    wk_exit();
  };
  FL_EXPORT_C(char*,wk_urlencode_C)(const char *in){
    return wk_urlencode(in);
  };
  FL_EXPORT_C(void ,wk_set_cookie_path_C)(const char *path){
    wk_set_cookie_path(path);
  };
  FL_EXPORT_C(void*,wk_get_favicon_C)(const char *url){
    return (void*)wk_get_favicon(url);
  };
  FL_EXPORT_C(void*,wk_get_favicon_with_targetsize_C)(const char *url, const unsigned targetsize){
    return (void*)wk_get_favicon(url,targetsize);
  };
  FL_EXPORT_C(void ,wk_set_cache_dir_C)(const char *dir){
    wk_set_cache_dir(dir);
  };
  FL_EXPORT_C(void ,wk_set_cache_max_C)(const unsigned bytes){
    wk_set_cache_max(bytes);
  };
  FL_EXPORT_C(void ,wk_set_persite_settings_func_C)(void (*func)(const char*)){
    wk_set_persite_settings_func(func);
  };
  FL_EXPORT_C(void ,wk_set_image_max_C)(const unsigned size){
    wk_set_image_max(size);
  };
  FL_EXPORT_C(void ,wk_set_useragent_func_C)(const char * (*func)(const char *)){
    wk_set_useragent_func(func);
  };
  FL_EXPORT_C(void ,wk_set_tz_func_C)(int (*func)()){
    wk_set_tz_func(func);
  };
  FL_EXPORT_C(void ,wk_set_accept_func_C)(const char *(*func)(const char*)){
    wk_set_accept_func(func);
  };
  FL_EXPORT_C(void ,wk_set_language_func_C)(const char *(*func)(const char *)){
    wk_set_language_func(func);
  };
  FL_EXPORT_C(void,wk_set_ssl_err_func_C)(webkitSSLErrorCallback* c){
    CallbackStore::errorCb = c;
    wk_set_ssl_err_func(CallbackStore::interceptErrorCallback);
  }
  FL_EXPORT_C(void,wk_set_popup_func_C)(webkitPopupFunc* c){
    CallbackStore::popupFuncCb = c;
    wk_set_popup_func(CallbackStore::interceptPopupFuncCallback);
  }
  FL_EXPORT_C(void,wk_set_favicon_dir_C)(const char* dir, const char** preloads, long unsigned len, void (*done)()){
    if (preloads) {
      std::vector<const char*> _preloads;
      _preloads.assign(preloads,preloads + len);
      wk_set_favicon_dir(dir, &_preloads, done);
    }
    else {
      wk_set_favicon_dir(dir, NULL, done);
    }
  }
#ifdef __cplusplus
}
#endif
