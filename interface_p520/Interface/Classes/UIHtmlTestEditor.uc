class UIHtmlTestEditor extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle RefreshButton;
var ButtonHandle ClearButton;
var HtmlHandle HtmlViewer;
var string currentFocusString;

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();
	setWindowTitleByString("UIHtmlTestEditor");
	return;
}

function Initialize()
{
	Me = GetWindowHandle("UIHtmlTestEditor");
	RefreshButton = GetButtonHandle("UIHtmlTestEditor.refreshButton");
	ClearButton = GetButtonHandle("UIHtmlTestEditor.clearButton");
	HtmlViewer = GetHtmlHandle("UIHtmlTestEditor.htmlViewer");
	return;
}

function OnShow()
{
	GetEditBoxHandle(("UIHtmlTestEditor." $ "lineEditBox01")).SetFocus();
	return;
}

function Load()
{
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "refreshButton":
			OnRefreshButtonClick();
			break;
		case "clearButton":
			OnclearButtonClick();
			break;
		case "copyButton":
			OnCopyButtonClick();
			break;
		case "UpButton":
			onUpButtonClick();
			break;
		case "DownButton":
			onDownButtonClick();
			break;
		case "btnButton":
			GetEditBoxHandle(("UIHtmlTestEditor." $ currentFocusString)).AddString("<button value=\"test\" width=100 height=25 High=\"L2UI_CT1.Button_DF_Over\" back=\"L2UI_CT1.Button_DF_Down\" fore=\"L2UI_CT1.Button_DF\">");
			break;
		case "imgButton":
			GetEditBoxHandle(("UIHtmlTestEditor." $ currentFocusString)).AddString("<img src=\"Icon.Item_Normal06\" width=32 height=32>");
			break;
		case "fontColorButton":
			GetEditBoxHandle(("UIHtmlTestEditor." $ currentFocusString)).AddString("<font name=\"GameDefault\" color=\"FFFFFF\"> test </font>");
			break;
		case "tableButton":
			GetEditBoxHandle(("UIHtmlTestEditor." $ currentFocusString)).AddString("<table width=0 height=0 border=1 cellpadding=0 cellspacing=1 background=\"\"> </table>");
			break;
		case "trButton":
			GetEditBoxHandle(("UIHtmlTestEditor." $ currentFocusString)).AddString("<tr> </tr>");
			break;
		case "tdButton":
			GetEditBoxHandle(("UIHtmlTestEditor." $ currentFocusString)).AddString("<td fixwidth=0 width=0 height=0 background=\"\">test</td>");
			break;
		case "brButton":
			GetEditBoxHandle(("UIHtmlTestEditor." $ currentFocusString)).AddString("<br>");
			break;
		case "br1Button":
			GetEditBoxHandle(("UIHtmlTestEditor." $ currentFocusString)).AddString("<br1>");
			break;
		default:
			break;
	}
	return;
}

function OnRefreshButtonClick()
{
	local int i;
	local string Str;

	i = 1;
	while((i <= 20))
	{
		Str = (Str $ GetEditBoxHandle((("UIHtmlTestEditor." $ "lineEditBox") $ getInstanceL2Util().makeZeroString(2, INT64(i)))).GetString());
		i++;
	}
	HtmlViewer.LoadHtmlFromString((("<html>" $ Str) $ "</html>"));
	return;
}

function OnclearButtonClick()
{
	local int i;

	i = 1;
	while((i <= 20))
	{
		GetEditBoxHandle((("UIHtmlTestEditor." $ "lineEditBox") $ getInstanceL2Util().makeZeroString(2, INT64(i)))).SetString("");
		i++;
	}
	GetEditBoxHandle(("UIHtmlTestEditor." $ "lineEditBox01")).SetFocus();
	return;
}

function OnCopyButtonClick()
{
	local int i;
	local string Str, tmp;

	i = 1;
	while((i <= 20))
	{
		tmp = GetEditBoxHandle((("UIHtmlTestEditor." $ "lineEditBox") $ getInstanceL2Util().makeZeroString(2, INT64(i)))).GetString();
		if((tmp != ""))
		{
			Str = ((Str $ tmp) $ Chr(13));
		}
		i++;
	}
	ClipboardCopy(((("<html>" $ Chr(13)) $ Str) $ "</html>"));
	getInstanceL2Util().showGfxScreenMessage("Complete ClipboardCopy!");
	return;
}

function onUpButtonClick()
{
	local int Num;
	local string temp1, temp2;

	Num = int(Right(currentFocusString, 2));
	temp1 = GetEditBoxHandle((("UIHtmlTestEditor." $ "lineEditBox") $ getInstanceL2Util().makeZeroString(2, INT64(Num)))).GetString();
	Num--;
	if((Num < 1))
	{
		Num = 1;
		temp2 = "";
	}
	else
	{
		temp2 = GetEditBoxHandle((("UIHtmlTestEditor." $ "lineEditBox") $ getInstanceL2Util().makeZeroString(2, INT64(Num)))).GetString();
	}
	GetEditBoxHandle((("UIHtmlTestEditor." $ "lineEditBox") $ getInstanceL2Util().makeZeroString(2, INT64(Num)))).SetString(temp1);
	GetEditBoxHandle((("UIHtmlTestEditor." $ "lineEditBox") $ getInstanceL2Util().makeZeroString(2, INT64((Num + 1))))).SetString(temp2);
	GetEditBoxHandle((("UIHtmlTestEditor." $ "lineEditBox") $ getInstanceL2Util().makeZeroString(2, INT64(Num)))).SetFocus();
	return;
}

function onDownButtonClick()
{
	local int Num;
	local string temp1, temp2;

	Num = int(Right(currentFocusString, 2));
	temp1 = GetEditBoxHandle((("UIHtmlTestEditor." $ "lineEditBox") $ getInstanceL2Util().makeZeroString(2, INT64(Num)))).GetString();
	Num++;
	if((Num > 20))
	{
		Num = 20;
		temp2 = "";
	}
	else
	{
		temp2 = GetEditBoxHandle((("UIHtmlTestEditor." $ "lineEditBox") $ getInstanceL2Util().makeZeroString(2, INT64(Num)))).GetString();
	}
	GetEditBoxHandle((("UIHtmlTestEditor." $ "lineEditBox") $ getInstanceL2Util().makeZeroString(2, INT64(Num)))).SetString(temp1);
	GetEditBoxHandle((("UIHtmlTestEditor." $ "lineEditBox") $ getInstanceL2Util().makeZeroString(2, INT64((Num - 1))))).SetString(temp2);
	GetEditBoxHandle((("UIHtmlTestEditor." $ "lineEditBox") $ getInstanceL2Util().makeZeroString(2, INT64(Num)))).SetFocus();
	return;
}

event bool OnKeyDown(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	local string mainKey, tempStr1;
	local int Num, i;

	if(Me.IsShowWindow())
	{
		mainKey = Class'NWindow.InputAPI'.static.GetKeyString(nKey);
		if((mainKey == "ENTER"))
		{
			Num = int(Right(currentFocusString, 2));
			i = 20;
			while((i > Num))
			{
				tempStr1 = GetEditBoxHandle((("UIHtmlTestEditor." $ "lineEditBox") $ getInstanceL2Util().makeZeroString(2, INT64((i - 1))))).GetString();
				GetEditBoxHandle((("UIHtmlTestEditor." $ "lineEditBox") $ getInstanceL2Util().makeZeroString(2, INT64((i - 1))))).SetString("");
				GetEditBoxHandle((("UIHtmlTestEditor." $ "lineEditBox") $ getInstanceL2Util().makeZeroString(2, INT64(i)))).SetString(tempStr1);
				i--;
			}
		}
		else if((mainKey == "DOWN"))
		{
			Num = int(Right(currentFocusString, 2));
			Num++;
			if((Num > 20))
			{
				Num = 20;
			}
			GetEditBoxHandle((("UIHtmlTestEditor." $ "lineEditBox") $ getInstanceL2Util().makeZeroString(2, INT64(Num)))).SetFocus();
		}
		else if((mainKey == "UP"))
		{
			Num = int(Right(currentFocusString, 2));
			Num--;
			if((Num < 1))
			{
				Num = 1;
			}
			GetEditBoxHandle((("UIHtmlTestEditor." $ "lineEditBox") $ getInstanceL2Util().makeZeroString(2, INT64(Num)))).SetFocus();
		}
	}
	return false;
}

event OnSetFocus(WindowHandle a_WindowHandle, bool bFocused)
{
	if((Left(a_WindowHandle.GetWindowName(), 11) == "lineEditBox"))
	{
		currentFocusString = a_WindowHandle.GetWindowName();
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
