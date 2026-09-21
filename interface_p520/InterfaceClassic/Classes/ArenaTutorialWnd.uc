class ArenaTutorialWnd extends UICommonAPI;

var string m_Windowname;
var WindowHandle m_hNPCDialogViewPortWnd;
var WindowHandle m_hViewPortWndArena;
var HtmlHandle m_hHtmlViewer;
var ViewPortWndArena m_hViewPortWndArenaScript;

function OnRegisterEvent()
{
	RegisterEvent(8700);
	RegisterEvent(8701);
	RegisterEvent(8702);
	RegisterEvent(8703);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	m_hNPCDialogViewPortWnd = GetWindowHandle(m_Windowname);
	m_hHtmlViewer = GetHtmlHandle((m_Windowname $ ".HtmlViewer"));
	m_hViewPortWndArena = GetWindowHandle("ViewPortWndArena");
	m_hViewPortWndArenaScript = ViewPortWndArena(GetScript("ViewPortWndArena"));
	return;
}

function OnSetFocus(WindowHandle a_WindowHandle, bool IsFocused)
{
	if(IsFocused)
	{
		m_hViewPortWndArena.BringToFront();
	}
	return;
}

function OnShow()
{
	return;
}

function OnHide()
{
	m_hViewPortWndArena.HideWindow();
	m_hViewPortWndArena.ClearAnchor();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 8701:
		case 8703:
			m_hNPCDialogViewPortWnd.HideWindow();
			break;
		case 8700:
			handleHtmlViewPort(param);
			break;
		case 8702:
			handleMessageWithViewPort(param);
			break;
		default:
			break;
	}
	return;
}

function handleMessageWithViewPort(string param)
{
	local int StringID, Id, Show, SocialAnim, AttackAnim;
	local string npcString;

	ParseInt(param, "ID", Id);
	ParseInt(param, "NpcStringID", StringID);
	npcString = GetNpcString(StringID);
	if((Id == -1))
	{
		m_hNPCDialogViewPortWnd.HideWindow();
	}
	ParseInt(param, "Show", Show);
	m_hViewPortWndArenaScript.SetNPCViewportData(Id);
	if((Show == 1))
	{
		m_hViewPortWndArenaScript.SpawnNPC();
		m_hViewPortWndArenaScript.ShowNPC(0.1000000);
	}
	getInstanceL2Util().showGfxScreenMessage(npcString, 5);
	ParseInt(param, "AttackAnim", AttackAnim);
	ParseInt(param, "SocialAnim", SocialAnim);
	m_hViewPortWndArena.ShowWindow();
	m_hViewPortWndArena.SetAnchor("", "BottomCenter", "BottomCenter", 350, -28);
	Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop("ViewPortWndArena", true);
	m_hViewPortWndArena.BringToFront();
	if((AttackAnim > -1))
	{
		m_hViewPortWndArenaScript.PlayAnimation(AttackAnim);
	}
	else if((SocialAnim > -1))
	{
		m_hViewPortWndArenaScript.PlayAnimation(SocialAnim);
	}
	return;
}

function handleHtmlViewPort(string param)
{
	local int Id, Show, SocialAnim, AttackAnim;
	local string htmlStr;

	ParseInt(param, "ID", Id);
	if((Id == -1))
	{
		m_hNPCDialogViewPortWnd.HideWindow();
	}
	ParseInt(param, "Show", Show);
	ParseString(param, "HtmlStr", htmlStr);
	LoadHtml(htmlStr);
	ShowWindowWithFocus(m_Windowname);
	m_hViewPortWndArenaScript.SetNPCViewportData(Id);
	if((Show == 1))
	{
		m_hViewPortWndArenaScript.SpawnNPC();
		m_hViewPortWndArenaScript.ShowNPC(0.1000000);
	}
	ParseInt(param, "AttackAnim", AttackAnim);
	ParseInt(param, "SocialAnim", SocialAnim);
	m_hViewPortWndArena.ShowWindow();
	m_hViewPortWndArena.SetAnchor(m_Windowname, "CenterRight", "CenterLeft", 0, 0);
	Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop("ViewPortWndArena", false);
	m_hViewPortWndArena.BringToFront();
	if((AttackAnim > -1))
	{
		m_hViewPortWndArenaScript.PlayAnimation(AttackAnim);
	}
	else if((SocialAnim > -1))
	{
		m_hViewPortWndArenaScript.PlayAnimation(SocialAnim);
	}
	return;
}

function LoadHtml(string param)
{
	m_hHtmlViewer.LoadHtmlFromString(htmlSetHtmlStart(param));
	m_hNPCDialogViewPortWnd.SetFocus();
	return;
}

function string htmlSetHtmlStart(string targetHtml)
{
	return (("<html><body>" $ targetHtml) $ "</body></html>");
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hNPCDialogViewPortWnd.HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="ArenaTutorialWnd"
}
