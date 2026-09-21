class ProductInventoryHelpHtmlWnd extends UICommonAPI;

var WindowHandle Me;
var TextureHandle texBack;
var HtmlHandle htmlViewerProductInventoryHelp;

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("ProductInventoryHelpHtmlWnd");
	texBack = GetTextureHandle("ProductInventoryHelpHtmlWnd.texBack");
	htmlViewerProductInventoryHelp = GetHtmlHandle("ProductInventoryHelpHtmlWnd.htmlViewerProductInventoryHelp");
	return;
}

function OnShow()
{
	return;
}

function Load()
{
	return;
}

function ShowHelp(string strPath)
{
	if((Len(strPath) > 0))
	{
		htmlViewerProductInventoryHelp.LoadHtml(strPath);
		Me.ShowWindow();
		Me.SetFocus();
	}
	return;
}

function OnReceivedCloseUI()
{
	Me.HideWindow();
	return;
}
