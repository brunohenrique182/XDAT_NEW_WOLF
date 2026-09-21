class BoardWnd extends UIScript;

var bool m_bShow;
var bool m_bBtnLock;
var string m_Command[8];
var HtmlHandle m_hBoardWndHtmlViewer;
var TabHandle m_hBoardWndTabCtrl;

function OnRegisterEvent()
{
	RegisterEvent(1190);
	RegisterEvent(1200);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	m_hBoardWndHtmlViewer = GetHtmlHandle("BoardWnd.HtmlViewer");
	m_hBoardWndTabCtrl = GetTabHandle("BoardWnd.TabCtrl");
	if((int(GetLanguage()) == 2))
	{
		m_hBoardWndTabCtrl.RemoveTabControl(5);
	}
	m_bShow = false;
	m_bBtnLock = false;
	return;
}

function OnShow()
{
	m_bShow = true;
	return;
}

function OnHide()
{
	m_bShow = false;
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 1190))
	{
		HandleShowBBS(param);
	}
	else if((Event_ID == 1200))
	{
		HandleShowBoardPacket(param);
	}
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnBookmark":
			OnClickBookmark();
			break;
		default:
			break;
	}
	TabButtonClick(strID);
	return;
}

function OnRClickButton(string strID)
{
	TabButtonClick(strID);
	return;
}

function TabButtonClick(string strID)
{
	if((Left(strID, 7) == "TabCtrl"))
	{
		strID = Mid(strID, 7);
		if(!Class'NWindow.UIAPI_WINDOW'.static.IsMinimizedWindow("BoardWnd"))
		{
			ShowBBSTab(int(strID));
		}
	}
	return;
}

function Clear()
{
	return;
}

function HandleShowBBS(string param)
{
	local int Index, Init;

	ParseInt(param, "Index", Index);
	ParseInt(param, "Init", Init);
	if(m_bShow)
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("BoardWnd");
		return;
	}
	if((Init > 0))
	{
		if(!m_hBoardWndHtmlViewer.IsPageLock())
		{
			m_hBoardWndHtmlViewer.SetPageLock(true);
			m_hBoardWndTabCtrl.SetTopOrder(0, false);
			m_hBoardWndHtmlViewer.Clear();
			RequestBBSBoard();
		}
	}
	else
	{
		if((Index == 8))
		{
			m_hBoardWndTabCtrl.SetTopOrder(0, false);
		}
		else
		{
			m_hBoardWndTabCtrl.SetTopOrder(Index, false);
		}
		m_hBoardWndHtmlViewer.Clear();
		ShowBBSTab(Index);
	}
	return;
}

function HandleShowBoardPacket(string param)
{
	local int idx, Ok;
	local string Address;

	ParseInt(param, "OK", Ok);
	if((Ok < 1))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("BoardWnd");
		return;
	}
	idx = 0;
	while((idx < 8))
	{
		m_Command[idx] = "";
		idx++;
	}
	ParseString(param, "Command1", m_Command[0]);
	ParseString(param, "Command2", m_Command[1]);
	ParseString(param, "Command3", m_Command[2]);
	ParseString(param, "Command4", m_Command[3]);
	ParseString(param, "Command5", m_Command[4]);
	ParseString(param, "Command6", m_Command[5]);
	ParseString(param, "Command7", m_Command[6]);
	ParseString(param, "Command8", m_Command[7]);
	m_bBtnLock = false;
	ParseString(param, "Address", Address);
	m_hBoardWndHtmlViewer.SetHtmlBuffData(Address);
	if(!m_bShow)
	{
		PlayConsoleSound(IFST_WINDOW_OPEN);
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("BoardWnd");
		Class'NWindow.UIAPI_WINDOW'.static.SetFocus("BoardWnd");
	}
	return;
}

function ShowBBSTab(int Index)
{
	local string strBypass;
	local UIEventManager.EControlReturnType Ret;

	switch(Index)
	{
		case 0:
			strBypass = "bypass _bbshome";
			break;
		case 1:
			strBypass = "bypass _bbsgetfav";
			break;
		case 2:
			strBypass = "bypass _bbslink";
			break;
		case 3:
			strBypass = "bypass _bbsclan";
			break;
		case 4:
			strBypass = "bypass _bbsmemo";
			break;
		case 5:
			strBypass = "bypass _maillist_0_1_0_";
			break;
		case 6:
			strBypass = "bypass _friendlist_0_";
			break;
		case 8:
			switch(GetReleaseMode())
			{
				case RM_DEV:
					strBypass = "bypass _bbslist_1023_1";
					break;
				case RM_RC:
					strBypass = "bypass _bbslist_8_1";
					break;
				case RM_TEST:
					strBypass = "bypass _bbslist_44_1";
					break;
				case RM_LIVE:
					strBypass = "bypass _bbslist_20_1";
					break;
				default:
					break;
			}
		default:
			break;
	}
	Debug(("strBypass" @ strBypass));
	if((Len(strBypass) > 0))
	{
		Ret = m_hBoardWndHtmlViewer.ControllerExecution(strBypass);
		if((int(Ret) == 1))
		{
			m_bBtnLock = true;
		}
	}
	return;
}

function OnClickBookmark()
{
	local UIEventManager.EControlReturnType Ret;

	if(((Len(m_Command[7]) > 0) && !m_bBtnLock))
	{
		Ret = m_hBoardWndHtmlViewer.ControllerExecution(m_Command[7]);
		if((int(Ret) == 1))
		{
			m_bBtnLock = true;
		}
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("BoardWnd").HideWindow();
	return;
}
