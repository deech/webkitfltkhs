#include "webview_C.h"
#include "limits.h"
#ifdef __cplusplus
void callbackStoringWebView::interceptLoad(webview* v) {
  ((callbackStoringWebView*)v)->runLoadCallback();
}
void callbackStoringWebView::interceptFavicon(webview* v){
  ((callbackStoringWebView*)v)->runFaviconCallback();
}
void callbackStoringWebView::interceptStatus(webview* v){
  ((callbackStoringWebView*)v)->runStatusCallback();
}
void callbackStoringWebView::interceptProgress(webview* v, float f){
  ((callbackStoringWebView*)v)->runProgressCallback(f);
}
void callbackStoringWebView::interceptSiteChanging(webview* v, const char* url){
  ((callbackStoringWebView*)v)->runSiteChangingCallback(url);
}
void callbackStoringWebView::interceptError(webview* v, const char* err){
  ((callbackStoringWebView*)v)->runErrorCallback(err);
}
// void callbackStoringWebView::interceptResource(unsigned long id, bool finished){
//   ((callbackStoringWebView*)v)->runResourceCallback(id, finished ? 1 : 0);
// }
void callbackStoringWebView::loadStateChangedCB(webviewCallback* c) {
  this->loadCb = c;
  webview::loadStateChangedCB(callbackStoringWebView::interceptLoad);
}
void callbackStoringWebView::progressChangedCB(webviewProgressCallback* c) {
  this->progressCb = c;
  webview::progressChangedCB(callbackStoringWebView::interceptProgress);
}
void callbackStoringWebView::faviconChangedCB(webviewCallback* c) {
  this->faviconCb = c;
  webview::faviconChangedCB(callbackStoringWebView::interceptFavicon);
}
void callbackStoringWebView::statusChangedCB(webviewCallback* c) {
  this->statusCb = c;
  webview::statusChangedCB(callbackStoringWebView::interceptStatus);
}
void callbackStoringWebView::siteChangingCB(webviewSiteCallback* c) {
  this->siteCb = c;
  webview::siteChangingCB(callbackStoringWebView::interceptSiteChanging);
}
void callbackStoringWebView::errorCB(webviewErrorCallback* c) {
  this->errorCb = c;
  webview::errorCB(callbackStoringWebView::interceptError);
}
// void callbackStoringWebView::resourceStateChangedCB(webviewResourceCallback* c) {
//   this->resourceCb = c;
//   webview::resourceStateChangedCB(callbackStoringWebView::interceptResource);
// }
void callbackStoringWebView::runLoadCallback(){
  (*loadCb)((void*) this);
}
void callbackStoringWebView::runFaviconCallback(){
  (*faviconCb)((void*) this);
}
void callbackStoringWebView::runStatusCallback(){
  (*statusCb)((void*) this);
}
void callbackStoringWebView::runProgressCallback(float f){
  (*progressCb)((void*) this, f);
}
void callbackStoringWebView::runSiteChangingCallback(const char* url){
  (*siteCb)((void*) this, url);
}
void callbackStoringWebView::runErrorCallback(const char* err){
  (*errorCb)((void*) this, err);
}

unsigned callbackStoringWebView::getLinkDetails(const char* cssClass, char ** hrefs, char** texts) {
  return webview::getLinkDetails(cssClass, hrefs, texts, UINT_MAX);
}

callbackStoringWebView::callbackStoringWebView(int x, int y, int w, int h, bool noGui) : webview(x,y,w,h,noGui){};
callbackStoringWebView::~callbackStoringWebView(){}
// void callbackStoringWebview::runResourceCallback(unsigned long id, int finished){
//   (*resourceCb)(id, finished);
// }
EXPORT {
#endif
  FL_EXPORT_C(webviewC,webview_new)(int x, int y, int w, int h){
    callbackStoringWebView* v = new callbackStoringWebView(x,y,w,h,false);
    return (webviewC)(v);
  }
  FL_EXPORT_C(webviewC,webview_new_without_gui)(int x, int y, int w, int h){
    callbackStoringWebView* v = new callbackStoringWebView(x,y,w,h,true);
    return (webviewC)(v);
  }
  FL_EXPORT_C(void,webview_destroy)(webviewC self){
    delete (static_cast<callbackStoringWebView*>(self));
  }

  FL_EXPORT_C(int,webview_handle)(webviewC self,int event){
    return (static_cast<callbackStoringWebView*>(self))->handle(event);
  }
  FL_EXPORT_C(void,webview_resize)(webviewC self,int X,int Y,int W,int H){
    (static_cast<callbackStoringWebView*>(self))->resize(X,Y,W,H);
  }
  FL_EXPORT_C(void,webview_resizeFrame)(webviewC self){
    (static_cast<callbackStoringWebView*>(self))->resize();
  }
  FL_EXPORT_C(void,webview_load)(webviewC self,const char* string){
    (static_cast<callbackStoringWebView*>(self))->load(string);
  }
  FL_EXPORT_C(void,webview_loadString)(webviewC self,const char * const str,const char * const mime,const char * const enc,const char * const baseurl){
    (static_cast<callbackStoringWebView*>(self))->loadString(str,mime,enc,baseurl);
  }
  FL_EXPORT_C(void,webview_download)(webviewC self,const char *url,const char *suggestedname){
    (static_cast<callbackStoringWebView*>(self))->download(url,suggestedname);
  }
  FL_EXPORT_C(const char*,webview_statusbar)(webviewC self){
    return (static_cast<callbackStoringWebView*>(self))->statusbar();
  }
  FL_EXPORT_C(const char*,webview_title)(webviewC self){
    return (static_cast<callbackStoringWebView*>(self))->title();
  }
  FL_EXPORT_C(const char*,webview_url)(webviewC self){
    return (static_cast<callbackStoringWebView*>(self))->url();
  }
  FL_EXPORT_C(void,webview_snapshot)(webviewC self,const char * str){
    (static_cast<callbackStoringWebView*>(self))->snapshot(str);
  }
  FL_EXPORT_C(char*,webview_focusedSource)(webviewC self){
    return (static_cast<callbackStoringWebView*>(self))->focusedSource();
  }
  FL_EXPORT_C(void,webview_executeJS)(webviewC self,const char* js){
    (static_cast<callbackStoringWebView*>(self))->executeJS(js);
  }
  FL_EXPORT_C(unsigned,webview_numDownloads)(webviewC self){
    return (static_cast<callbackStoringWebView*>(self))->numDownloads();
  }
  FL_EXPORT_C(void,webview_stopDownload)(webviewC self,const unsigned i){
    (static_cast<callbackStoringWebView*>(self))->stopDownload(i);
  }
  FL_EXPORT_C(void,webview_removeDownload)(webviewC self,const unsigned i){
    (static_cast<callbackStoringWebView*>(self))->removeDownload(i);
  }
  FL_EXPORT_C(int,webview_downloadFinished)(webviewC self,const unsigned i){
    bool b = (static_cast<callbackStoringWebView*>(self))->downloadFinished(i);
    return (b ? 1 : 0);
  }
  FL_EXPORT_C(int,webview_downloadFailed)(webviewC self,const unsigned i){
    bool b = (static_cast<callbackStoringWebView*>(self))->downloadFailed(i);
    return (b ? 1 : 0);
  }
  FL_EXPORT_C(void,webview_downloadStats)(webviewC self,const unsigned i,time_t *start,long long *size,long long *received,const char **name,const char **url){
    (static_cast<callbackStoringWebView*>(self))->downloadStats(i,start,size,received,name,url);
  }
  FL_EXPORT_C(void,webview_back)(webviewC self){
    (static_cast<callbackStoringWebView*>(self))->back();
  }
  FL_EXPORT_C(void,webview_fwd)(webviewC self){
    (static_cast<callbackStoringWebView*>(self))->fwd();
  }
  FL_EXPORT_C(int,webview_canBack)(webviewC self){
    bool b = (static_cast<callbackStoringWebView*>(self))->canBack();
    return (b ? 1 : 0);
  }
  FL_EXPORT_C(int,webview_canFwd)(webviewC self){
    bool b = (static_cast<callbackStoringWebView*>(self))->canFwd();
    return (b ? 1 : 0);
  }
  FL_EXPORT_C(void,webview_prev)(webviewC self){
    (static_cast<callbackStoringWebView*>(self))->prev();
  }
  FL_EXPORT_C(void,webview_next)(webviewC self){
    (static_cast<callbackStoringWebView*>(self))->next();
  }
  FL_EXPORT_C(void,webview_stop)(webviewC self){
    (static_cast<callbackStoringWebView*>(self))->stop();
  }
  FL_EXPORT_C(void,webview_refresh)(webviewC self){
    (static_cast<callbackStoringWebView*>(self))->refresh();
  }
  FL_EXPORT_C(int, webview_isLoading)(webviewC self){
    bool b = (static_cast<callbackStoringWebView*>(self))->isLoading();
    return (b ? 1 : 0);
  }
  FL_EXPORT_C(void,webview_undo)(webviewC self){
    (static_cast<callbackStoringWebView*>(self))->undo();
  }
  FL_EXPORT_C(void,webview_redo)(webviewC self){
    (static_cast<callbackStoringWebView*>(self))->redo();
  }
  FL_EXPORT_C(void,webview_selectAll)(webviewC self){
    (static_cast<callbackStoringWebView*>(self))->selectAll();
  }
  FL_EXPORT_C(void,webview_copy)(webviewC self){
    (static_cast<callbackStoringWebView*>(self))->copy();
  }
  FL_EXPORT_C(void,webview_cut)(webviewC self){
    (static_cast<callbackStoringWebView*>(self))->cut();
  }
  FL_EXPORT_C(void,webview_paste)(webviewC self){
    (static_cast<callbackStoringWebView*>(self))->paste();
  }
  FL_EXPORT_C(int,webview_find)(webviewC self,const char *what,int caseSensitive,int forward){
    bool b = (static_cast<callbackStoringWebView*>(self))->find(what,(caseSensitive >= 1),(forward >= 1));
    return (b ? 1 : 0);
  }
  FL_EXPORT_C(unsigned,webview_countFound)(webviewC self, const char *what, int caseSensitive){
    return (static_cast<callbackStoringWebView*>(self))->countFound(what,(caseSensitive >= 1));
  }

  FL_EXPORT_C(void,webview_setBool)(webviewC self,const SettingBool settings,int b){
    (static_cast<callbackStoringWebView*>(self))->setBool(settings,(b >= 1));
  }
  FL_EXPORT_C(int,webview_getBool)(webviewC self,const SettingBool settings){
    bool b = (static_cast<callbackStoringWebView*>(self))->getBool(settings);
    return (b ? 1 : 0);
  }
  FL_EXPORT_C(void,webview_setDouble)(webviewC self,const SettingDouble settings,double setting){
    (static_cast<callbackStoringWebView*>(self))->setDouble(settings,setting);
  }
  FL_EXPORT_C(double,webview_getDouble)(webviewC self,const SettingDouble settings){
    return (static_cast<callbackStoringWebView*>(self))->getDouble(settings);
  }
  FL_EXPORT_C(void,webview_setInt)(webviewC self,const SettingInt settings,int setting){
    (static_cast<callbackStoringWebView*>(self))->setInt(settings,setting);
  }
  FL_EXPORT_C(int,webview_getInt)(webviewC self,const SettingInt settings){
    return (static_cast<callbackStoringWebView*>(self))->getInt(settings);
  }
  FL_EXPORT_C(void,webview_setChar)(webviewC self,const SettingChar settings,const char* setting){
    (static_cast<callbackStoringWebView*>(self))->setChar(settings,setting);
  }
  FL_EXPORT_C(const char*,webview_getChar)(webviewC self,const SettingChar settings){
    return (static_cast<callbackStoringWebView*>(self))->getChar(settings);
  }

  FL_EXPORT_C(void,webview_titleChangedCB)(webviewC self, void (*func)()){
    (static_cast<callbackStoringWebView*>(self))->titleChangedCB(func);
  };
  FL_EXPORT_C(void,webview_loadStateChangedCB)(webviewC self, webviewCallback c){
    (static_cast<callbackStoringWebView*>(self))->loadStateChangedCB(c);
  }
  FL_EXPORT_C(void,webview_progressChangedCB)(webviewC self, webviewProgressCallback c){
    (static_cast<callbackStoringWebView*>(self))->progressChangedCB(c);
  }
  FL_EXPORT_C(void,webview_faviconChangedCB)(webviewC self, webviewCallback c){
    (static_cast<callbackStoringWebView*>(self))->faviconChangedCB(c);
  }
  FL_EXPORT_C(void,webview_statusChangedCB)(webviewC self, webviewCallback c){
    (static_cast<callbackStoringWebView*>(self))->statusChangedCB(c);
  }
  FL_EXPORT_C(void,webview_historyAddCB)(webviewC self, webviewHistoryCallback c){
    (static_cast<callbackStoringWebView*>(self))->historyAddCB(c);
  }
  FL_EXPORT_C(void,webview_siteChangingCB)(webviewC self, webviewSiteCallback c){
    (static_cast<callbackStoringWebView*>(self))->siteChangingCB(c);
  };
  FL_EXPORT_C(void,webview_errorCB)(webviewC self, webviewErrorCallback c){
    (static_cast<callbackStoringWebView*>(self))->errorCB(c);
  }
  // FL_EXPORT_C(void,webview_resourceStateChangedCB)(webviewC self, webviewSiteCallback c){
  //   (static_cast<callbackStoringWebView*>(self))->resourceStateChangedCB(c);
  // };
  FL_EXPORT_C(void,webview_bindEvent)(webviewC self, const char *element, const char *type, const char *event, webviewBindEventCallback c, const int capture){
    (static_cast<callbackStoringWebView*>(self))->bindEvent(element, type, event, c, capture >= 1);
  }
  FL_EXPORT_C(const char*,webview_getValue)(webviewC self,const char *element,const char *type,const char *cssclass){
    return (static_cast<callbackStoringWebView*>(self))->getValue(element,type,cssclass);
  }
  FL_EXPORT_C(void,webview_emulateClick)(webviewC self,const char *element,const char *type,const char *cssclass){
    (static_cast<callbackStoringWebView*>(self))->emulateClick(element,type,cssclass);
  }
  FL_EXPORT_C(unsigned,webview_getLinkDetails)(webviewC self,const char *cssclass,char **hrefs,char **texts){
    return (static_cast<callbackStoringWebView*>(self))->getLinkDetails(cssclass,hrefs,texts);
  }
  FL_EXPORT_C(int,webview_isNoGui)(webviewC self){
    return (static_cast<callbackStoringWebView*>(self))->isNoGui();
  }
#ifdef __cplusplus
}
#endif
