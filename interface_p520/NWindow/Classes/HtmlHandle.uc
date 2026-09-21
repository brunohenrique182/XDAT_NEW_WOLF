class HtmlHandle extends WindowHandle;

native final function LoadHtml(string Filename);

native final function LoadHtmlFromString(string HtmlString, optional bool bSetFocus);

native final function Clear();

native final function int GetFrameMaxHeight();

native final function UIEventManager.EControlReturnType ControllerExecution(string strBypass);

native final function SetHtmlBuffData(string strData);

native final function SetPageLock(bool bLock);

native final function bool IsPageLock();
