class WebBrowserHandle extends WindowHandle;

native final function string GetUrl();

native final function bool ExecuteJavaScript(string Command);

native final function string GetCookie(string URL, string Key);

native final function bool SetCookie(string URL, string Key, string Value);

native final function Navigate(UIEventManager.WebRequestInfo requestInfo);

native final function bool CanGoBackPage();

native final function GoBackPage();

native final function bool CanGoForwardPage();

native final function GoForwardPage();

native final function ReloadCurPage();
