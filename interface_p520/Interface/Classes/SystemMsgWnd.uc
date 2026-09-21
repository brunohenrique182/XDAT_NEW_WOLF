class SystemMsgWnd extends UICommonAPI;

var WindowHandle m_hChatWnd;
var TextureHandle m_ChatWndBg;
var int m_bUseAlpha;
var bool IsMouseOver;

static function SystemMsgWnd Inst()
{
	return SystemMsgWnd(GetScript("ChatWnd.SystemMsgWnd"));
}

event OnRegisterEvent()
{
	RegisterEvent(150);
	RegisterEvent(555);
	RegisterEvent(2900);
	RegisterEvent(5720);
	return;
}

event OnLoad()
{
	m_hOwnerWnd.EnableDynamicAlpha(true);
	m_hChatWnd = GetWindowHandle("ChatWnd");
	m_ChatWndBg = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ChatWndBg"));
	GetChatWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SystemMsgList")).SetScrollBarPosition(15, 0, 15);
	return;
}

event OnEvent(int a_EventID, string a_Param)
{
	local int tempVal;

	switch(a_EventID)
	{
		case 150:
			GetINIBool("global", "SystemMsgWnd", tempVal, "chatfilter.ini");
			if(getInstanceUIData().GetIsLiveServer())
			{
				if((tempVal != 0))
				{
					Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("SystemMsgWnd");
				}
				else
				{
					Class'NWindow.UIAPI_WINDOW'.static.HideWindow("SystemMsgWnd");
				}
			}
			else
			{
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("SystemMsgWnd");
			}
			break;
		case 555:
			Resize(a_Param);
			break;
		case 2900:
			UpdateResolution();
			break;
		case 5720:
			HandleOptionHasAppled();
			break;
		default:
			break;
	}
	return;
}

event OnMouseOver(WindowHandle W)
{
	IsMouseOver = true;
	Class'Interface.ChatWnd'.static.Inst()._Swap2FullAlphaNormal();
	_Swap2FullAlpha();
	return;
}

event OnMouseOut(WindowHandle W)
{
	IsMouseOver = false;
	Class'Interface.ChatWnd'.static.Inst()._Swap2AlphaNormal();
	_Swap2Alpha();
	return;
}

event OnShow()
{
	local int W, h, tempVal, sizeW;
	local string showWndParam;

	m_hOwnerWnd.GetWindowSize(W, h);
	if(GetINIInt("global", "ChatSizeWidth", sizeW, "chatfilter.ini"))
	{
		m_hOwnerWnd.SetWindowSize(sizeW, h);
	}
	else
	{
		m_hOwnerWnd.SetWindowSize(W, h);
	}
	m_hOwnerWnd.SetResizeFrameOffset(348, h);
	ChangeAnchorEffectButton("SystemMsgWnd");
	ParamAdd(showWndParam, "visible", string(1));
	if(GetINIBool("global", "UseWorldChatSpeaker", tempVal, "chatfilter.ini"))
	{
		CallGFxFunction("worldChatBox", "IsShowSystemMsgWnd", showWndParam);
	}
	CallGFxFunction("UserAlertMessage", "IsShowSystemMsgWnd", showWndParam);
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NewMessageBtn")).HideWindow();
	GetINIBool("global", "UseAlpha", m_bUseAlpha, "chatfilter.ini");
	_Swap2FullAlpha();
	return;
}

event OnHide()
{
	local string showWndParam;

	ChangeAnchorEffectButton("ChatWnd");
	ParamAdd(showWndParam, "visible", string(0));
	CallGFxFunction("worldChatBox", "IsShowSystemMsgWnd", showWndParam);
	CallGFxFunction("UserAlertMessage", "IsShowSystemMsgWnd", showWndParam);
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "NewMessageBtn":
			HandleNewMessageBtn();
			break;
		default:
			break;
	}
	return;
}

function UpdateResolution()
{
	local int CurrentMaxWidth, CurrentMaxHeight, CurrentChatWidth, CurrentChatHeight;

	GetCurrentResolution(CurrentMaxWidth, CurrentMaxHeight);
	m_hChatWnd.GetWindowSize(CurrentChatWidth, CurrentChatHeight);
	if(((CurrentChatWidth > CurrentMaxWidth) || (CurrentChatHeight > (CurrentMaxHeight - 15))))
	{
		m_hOwnerWnd.GetWindowSize(CurrentChatWidth, CurrentChatHeight);
		m_hOwnerWnd.SetWindowSize(348, CurrentChatHeight);
	}
	return;
}

function Resize(string param)
{
	local int W, resizeWidth, h;

	ParseInt(param, "Width", resizeWidth);
	m_hOwnerWnd.GetWindowSize(W, h);
	m_hOwnerWnd.SetWindowSize(resizeWidth, h);
	return;
}

function ChangeAnchorEffectButton(string strID)
{
	Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("TutorialBtnWnd", strID, "TopLeft", "BottomLeft", 5, -5);
	Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("MailBtnWnd", strID, "TopLeft", "BottomLeft", 79, -5);
	Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("BirthdayAlarmBtn", strID, "TopLeft", "BottomLeft", 42, -37);
	return;
}

function _Swap2FullAlpha()
{
	m_ChatWndBg.SetAlpha(255, 0.2000000);
	return;
}

function _Swap2Alpha()
{
	if((m_bUseAlpha == 1))
	{
		m_ChatWndBg.SetAlpha(0, 0.7000000);
	}
	return;
}

function HandleOptionHasAppled()
{
	GetINIBool("global", "UseAlpha", m_bUseAlpha, "chatfilter.ini");
	if(IsMouseOver)
	{
		_Swap2FullAlpha();
	}
	else
	{
		_Swap2Alpha();
	}
	return;
}

function _ShowNewMessageBtn()
{
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NewMessageBtn")).ShowWindow();
	return;
}

function HandleNewMessageBtn()
{
	GetChatWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SystemMsgList")).SetScrollPosition(GetChatWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SystemMsgList")).GetScrollHeight());
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NewMessageBtn")).HideWindow();
	return;
}
