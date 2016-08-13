#ifndef __WEBVIEW_C__
#define __WEBVIEW_C__
#ifdef __cplusplus
#include <time.h>
#include "Fl_ExportMacros.h"
#include "webkitfltk/webview.h"
#include <stdio.h>
#include <stdlib.h>
#include "types.h"
EXPORT {
class callbackStoringWebView : public webview {
  static void interceptLoad(webview* v);
  static void interceptFavicon(webview* v);
  static void interceptStatus(webview* v);
  static void interceptProgress(webview* v, float f);
  static void interceptSiteChanging(webview* v, const char* url);
  static void interceptError(webview* v, const char* err);
  // static void interceptResource(unsigned long id, bool finished);
 private:
  webviewCallback* loadCb;
  webviewCallback* faviconCb;
  webviewCallback* statusCb;
  webviewProgressCallback* progressCb;
  webviewSiteCallback* siteCb;
  webviewErrorCallback* errorCb;
  // webviewResourceCallback* resourceCb;
 public:
  void runLoadCallback();
  void runFaviconCallback();
  void runStatusCallback();
  void runProgressCallback(float);
  void runSiteChangingCallback(const char* url);
  void runErrorCallback(const char* err);
  // void runResourceCallback(unsigned long id, int finished);
  void loadStateChangedCB(webviewCallback*);
  void progressChangedCB(webviewProgressCallback*);
  void faviconChangedCB(webviewCallback*);
  void statusChangedCB(webviewCallback*);
  void siteChangingCB(webviewSiteCallback*);
  void errorCB(webviewErrorCallback*);
  // void resourceStateChangedCB(webviewResourceCallback*);
  unsigned getLinkDetails(const char* cssClass, char** hrefs, char**texts);
  callbackStoringWebView(int x, int y, int w, int h, bool noGui);
  ~callbackStoringWebView();
};
#endif
#ifndef INTERNAL_LINKAGE
  typedef enum {
    WK_SETTING_JS = 0,
    WK_SETTING_CSS,
    WK_SETTING_IMG,
    WK_SETTING_LOCALSTORAGE,
    WK_SETTING_QUIET_JS_DIALOGS,
  } SettingBool;

  typedef enum {
    WK_SETTING_ZOOM = 0,
  } SettingDouble;

  typedef enum {
    WK_SETTING_FONT_SIZE = 0,
    WK_SETTING_FIXED_SIZE,
    WK_SETTING_MINIMUM_FONT_SIZE,
  } SettingInt ;

  typedef enum {
    WK_SETTING_DEFAULT_FONT = 0,
    WK_SETTING_FIXED_FONT,
    WK_SETTING_USER_CSS,
  } SettingChar ;
#endif

  FL_EXPORT_C(webviewC,    webview_new)(int x, int y, int w, int h);
  FL_EXPORT_C(webviewC,    webview_new_without_gui)(int x, int y, int w, int h);
  FL_EXPORT_C(void,        webview_destroy)(webviewC self);
  FL_EXPORT_C(int,         webview_handle)(webviewC self, int event);
  FL_EXPORT_C(void,        webview_resize)(webviewC self, int X, int Y, int W, int H);
  FL_EXPORT_C(void,        webview_resizeFrame)(webviewC self);
  FL_EXPORT_C(void,        webview_load)(webviewC self, const char* string);
  FL_EXPORT_C(void,        webview_loadString)(webviewC self, const char * const str, const char * const mime, const char * const enc, const char * const baseurl);
  FL_EXPORT_C(void,        webview_download)(webviewC self, const char * url, const char * suggestedname);
  FL_EXPORT_C(const char*, webview_statusbar)(webviewC self);
  FL_EXPORT_C(const char*, webview_title)(webviewC self);
  FL_EXPORT_C(const char*, webview_url)(webviewC self);
  FL_EXPORT_C(void,        webview_snapshot)(webviewC self, const char * str);
  FL_EXPORT_C(char*,       webview_focusedSource)(webviewC self);
  FL_EXPORT_C(void,        webview_executeJS)(webviewC self, const char* js);
  FL_EXPORT_C(unsigned,    webview_numDownloads)(webviewC self);
  FL_EXPORT_C(void,        webview_stopDownload)(webviewC self, const unsigned i);
  FL_EXPORT_C(void,        webview_removeDownload)(webviewC self, const unsigned i);
  FL_EXPORT_C(int,         webview_downloadFinished)(webviewC self, const unsigned);
  FL_EXPORT_C(int,         webview_downloadFailed)(webviewC self, const unsigned);
  FL_EXPORT_C(void,        webview_downloadStats)(webviewC self, const unsigned, time_t *start, long long *size, long long *received, const char **name, const char **url);
  FL_EXPORT_C(void,        webview_back)(webviewC self);
  FL_EXPORT_C(void,        webview_fwd)(webviewC self);
  FL_EXPORT_C(int,         webview_canBack)(webviewC self);
  FL_EXPORT_C(int,         webview_canFwd)(webviewC self);
  FL_EXPORT_C(void,        webview_prev)(webviewC self);
  FL_EXPORT_C(void,        webview_next)(webviewC self);

  FL_EXPORT_C(void,        webview_stop)(webviewC self);
  FL_EXPORT_C(void,        webview_refresh)(webviewC self);
  FL_EXPORT_C(int,         webview_isLoading)(webviewC self);
  FL_EXPORT_C(void,        webview_undo)(webviewC self);
  FL_EXPORT_C(void,        webview_redo)(webviewC self);
  FL_EXPORT_C(void,        webview_selectAll)(webviewC self);
  FL_EXPORT_C(void,        webview_copy)(webviewC self);
  FL_EXPORT_C(void,        webview_cut)(webviewC self);
  FL_EXPORT_C(void,        webview_paste)(webviewC self);
  FL_EXPORT_C(int,         webview_find)(webviewC self, const char * what, int caseSensitive, int forward);
  FL_EXPORT_C(unsigned,    webview_countFound)(webviewC self, const char * what, int caseSensitive);

  FL_EXPORT_C(void,        webview_setBool)(webviewC self, const SettingBool, int b);
  FL_EXPORT_C(int,         webview_getBool)(webviewC self, const SettingBool);

  FL_EXPORT_C(void,        webview_setDouble)(webviewC self, const SettingDouble, double setting);
  FL_EXPORT_C(double,      webview_getDouble)(webviewC self, const SettingDouble);

  FL_EXPORT_C(void,        webview_setInt)(webviewC self, const SettingInt, int setting);
  FL_EXPORT_C(int,         webview_getInt)(webviewC self, const SettingInt);

  FL_EXPORT_C(void,        webview_setChar)(webviewC self, const SettingChar, const char* setting);
  FL_EXPORT_C(const char*, webview_getChar)(webviewC self, const SettingChar);

  FL_EXPORT_C(void,        webview_titleChangedCB)(webviewC self, void (*func)());
  FL_EXPORT_C(void,        webview_loadStateChangedCB)(webviewC self, webviewCallback*);
  FL_EXPORT_C(void,        webview_progressChangedCB)(webviewC self, webviewProgressCallback*);
  FL_EXPORT_C(void,        webview_faviconChangedCB)(webviewC self, webviewCallback*);
  FL_EXPORT_C(void,        webview_statusChangedCB)(webviewC self, webviewCallback*);
  FL_EXPORT_C(void,        webview_historyAddCB)(webviewC self, webviewHistoryCallback*);
  FL_EXPORT_C(void,        webview_siteChangingCB)(webviewC self, webviewSiteCallback*);
  FL_EXPORT_C(void,        webview_errorCB)(webviewC self, webviewErrorCallback*);
  // FL_EXPORT_C(void,        webview_resourceStateChangedCB)(webviewC self, webviewResourceCallback*);
  FL_EXPORT_C(void,        webview_bindEvent)(webviewC self, const char *element, const char *type, const char *event, webviewBindEventCallback*, const int capture);

  FL_EXPORT_C(const char*, webview_getValue)(webviewC self, const char *element, const char *type, const char *cssclass);
  FL_EXPORT_C(void,        webview_emulateClick)(webviewC self, const char *element, const char *type, const char *cssclass);
  FL_EXPORT_C(unsigned,    webview_getLinkDetails)(webviewC self, const char *cssclass, char **hrefs, char **texts);
  FL_EXPORT_C(int,         webview_isNoGui)(webviewC self);
#ifdef __cplusplus
}
#endif
#endif /* __WEBVIEW_C__ */
