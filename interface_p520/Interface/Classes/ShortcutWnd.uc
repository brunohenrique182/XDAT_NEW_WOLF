class ShortcutWnd extends UICommonAPI;

const MAX_ShortcutPerPage = 12;
const MAX_ShortcutPerPage2 = 24;
const MAX_ShortcutPerPage3 = 36;
const MAX_ShortcutPerPage4 = 48;

enum EJoyShortcut
{
	JOYSHORTCUT_Left,               // 0
	JOYSHORTCUT_Center,             // 1
	JOYSHORTCUT_Right               // 2
};

var int MAX_Page;
var int MAX_ShortcutExtend;
var int m_extendBounsSlot;
var WindowHandle Me;
var int CurrentShortcutPage;
var int CurrentShortcutPage2;
var int CurrentShortcutPage3;
var int CurrentShortcutPage4;
var int CurrentShortcutPage5;
var int CurrentShortcutPageExtend;
var bool m_IsLocked;
var bool m_IsVertical;
var bool m_IsJoypad;
var bool m_IsJoypadExpand;
var bool m_IsJoypadOn;
var int m_Expand;
var bool m_IsShortcutExpand;
var string m_ShortcutWndName;
var string m_ShortcutWndExtendName;
var AutoShotItemWnd AutoShotItemWndScript;

function OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEvent(630);
	RegisterEvent(640);
	RegisterEvent(660);
	RegisterEvent(650);
	RegisterEvent(590);
	RegisterEvent(600);
	RegisterEvent(610);
	RegisterEvent(620);
	RegisterEvent(91);
	RegisterEvent(693);
	RegisterEvent(5090);
	RegisterEvent(5091);
	RegisterEvent(11430);
	return;
}

function OnShow()
{
	LoadINIValues();
	if(m_IsLocked)
	{
		Lock();
	}
	else
	{
		UNLOCK();
	}
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_1");
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_1");
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_2");
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_2");
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_3");
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_3");
	SettingShortCut();
	if(getInstanceUIData().GetIsClassicServer())
	{
		GetButtonHandle("ShortcutWnd.ShortcutWndVertical.ReduceButton").HideWindow();
		GetButtonHandle("ShortcutWnd.ShortcutWndHorizontal.ReduceButton").HideWindow();
		GetButtonHandle("ShortcutWnd.ShortcutWndVertical.ExpandButton").ShowWindow();
		GetButtonHandle("ShortcutWnd.ShortcutWndHorizontal.ExpandButton").ShowWindow();
		if((MAX_ShortcutExtend <= m_Expand))
		{
			m_Expand = (MAX_ShortcutExtend - 1);
		}
		ExpandByNum(m_Expand);
		if(GetWindowHandle("ShortcutWnd.ShortcutWnd_Extend").IsShowWindow())
		{
			GetWindowHandle("ShortcutWnd.ShortcutWnd_Extend").HideWindow();
		}
	}
	else
	{
		if((MAX_ShortcutExtend <= m_Expand))
		{
			m_Expand = (MAX_ShortcutExtend - 1);
		}
		GetButtonHandle("ShortcutWnd.ShortcutWndVertical.ExpandButton").ShowWindow();
		GetButtonHandle("ShortcutWnd.ShortcutWndHorizontal.ExpandButton").ShowWindow();
		ExpandByNum(m_Expand);
		if((m_extendBounsSlot > 0))
		{
			GetWindowHandle("ShortcutWnd.ShortcutWnd_Extend").ShowWindow();
		}
		else
		{
			GetWindowHandle("ShortcutWnd.ShortcutWnd_Extend").HideWindow();
		}
	}
	SetVertical(m_IsVertical);
	return;
}

function LoadINIValues()
{
	local int tmpInt;

	GetINIInt("ShortcutWnd", "e", m_Expand, "WindowsInfo.ini");
	GetINIInt("ShortcutWnd", "m", m_extendBounsSlot, "WindowsInfo.ini");
	GetINIBool("ShortcutWnd", "l", tmpInt, "windowsInfo.ini");
	m_IsLocked = GetOptionBool("Game", "IsLockShortcutWnd");
	if(bool(tmpInt))
	{
		OnMaxBtn();
	}
	else
	{
		OnMinBtn();
	}
	GetINIInt("ShortcutWnd", "v", tmpInt, "WindowsInfo.ini");
	m_IsVertical = bool(tmpInt);
	return;
}

function OnLoad()
{
	local bool bMinTooltip;
	local ToolTip Script;
	local int minTooltip;

	if(getInstanceUIData().getIsArenaServer())
	{
		return;
	}
	m_ShortcutWndExtendName = "ShortcutWnd_Extend";
	Me = GetWindowHandle("ShortcutWnd");
	AutoShotItemWndScript = AutoShotItemWnd(GetScript("AutoShotItemWnd"));
	LoadINIValues();
	InitShortPageNum();
	GetINIBool("ShortcutWnd", "l", minTooltip, "windowsInfo.ini");
	bMinTooltip = bool(minTooltip);
	Script = ToolTip(GetScript("Tooltip"));
	Script.setBoolSelect(!bMinTooltip);
	if(bMinTooltip)
	{
		HideWindow("ShortcutWnd.ShortcutWndHorizontal.TooltipMaxBtn");
		ShowWindow("ShortcutWnd.ShortcutWndHorizontal.TooltipMinBtn");
		HideWindow("ShortcutWnd.ShortcutWndVertical.TooltipMaxBtn");
		ShowWindow("ShortcutWnd.ShortcutWndVertical.TooltipMinBtn");
	}
	else
	{
		ShowWindow("ShortcutWnd.ShortcutWndHorizontal.TooltipMaxBtn");
		HideWindow("ShortcutWnd.ShortcutWndHorizontal.TooltipMinBtn");
		ShowWindow("ShortcutWnd.ShortcutWndVertical.TooltipMaxBtn");
		HideWindow("ShortcutWnd.ShortcutWndVertical.TooltipMinBtn");
	}
	return;
}

function OnDefaultPosition()
{
	if(getInstanceUIData().getIsArenaServer())
	{
		return;
	}
	if((GetOptionInt("Game", "LayoutDF") == 1))
	{
		m_Expand = (MAX_ShortcutExtend - 1);
		SetVertical(false);
	}
	ArrangeWnd();
	ExpandWnd();
	ExtendShortcutDefaultPostion();
	return;
}

function ExtendShortcutDefaultPostion()
{
	GetWindowHandle(("ShortcutWnd." $ m_ShortcutWndExtendName)).SetAnchor("", "BottomCenter", "TopLeft", 280, -220);
	GetWindowHandle(("ShortcutWnd." $ m_ShortcutWndExtendName)).ClearAnchor();
	return;
}

function OnEnterState(name a_CurrentStateName)
{
	if(getInstanceUIData().getIsArenaServer())
	{
		return;
	}
	ArrangeWnd();
	ExpandWnd();
	return;
}

function OnExitState(name a_CurrentStateName)
{
	if((a_CurrentStateName == 'LoadingState'))
	{
		InitShortPageNum();
	}
	return;
}

function SettingShortCut()
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		if((int(GetLanguage()) == 0))
		{
			GetButtonHandle("ShortcutWnd.ShortcutWndHorizontal.BounsExtendSlotBtn").HideWindow();
			GetButtonHandle("ShortcutWnd.ShortcutWndVertical.BounsExtendSlotBtn").HideWindow();
			MAX_ShortcutExtend = 3;
		}
		else if(IsAdenServer())
		{
			GetButtonHandle("ShortcutWnd.ShortcutWndHorizontal.BounsExtendSlotBtn").HideWindow();
			GetButtonHandle("ShortcutWnd.ShortcutWndVertical.BounsExtendSlotBtn").HideWindow();
			MAX_ShortcutExtend = 3;
		}
		else
		{
			GetButtonHandle("ShortcutWnd.ShortcutWndHorizontal.BounsExtendSlotBtn").ShowWindow();
			GetButtonHandle("ShortcutWnd.ShortcutWndVertical.BounsExtendSlotBtn").ShowWindow();
			MAX_ShortcutExtend = 4;
		}
	}
	else
	{
		GetButtonHandle("ShortcutWnd.ShortcutWndHorizontal.BounsExtendSlotBtn").ShowWindow();
		GetButtonHandle("ShortcutWnd.ShortcutWndVertical.BounsExtendSlotBtn").ShowWindow();
		MAX_ShortcutExtend = 4;
	}
	if((int(GetLanguage()) == 0))
	{
		MAX_Page = 10;
	}
	else
	{
		MAX_Page = 20;
	}
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	if(getInstanceUIData().getIsArenaServer())
	{
		return;
	}
	switch(a_EventID)
	{
		case 9750:
			SettingShortCut();
			break;
		case 91:
			ExecuteShortcutCommandBySlot(a_Param);
			break;
		case 640:
			HandleShortcutPageUpdate(a_Param);
			break;
		case 660:
			HandleShortcutJoypad(a_Param);
			break;
		case 590:
			HandleJoypadLButtonDown(a_Param);
			break;
		case 600:
			HandleJoypadLButtonUp(a_Param);
			break;
		case 610:
			HandleJoypadRButtonDown(a_Param);
			break;
		case 620:
			HandleJoypadRButtonUp(a_Param);
			break;
		case 630:
			HandleShortcutUpdate(a_Param);
			break;
		case 650:
			HandleShortcutClear();
			ArrangeWnd();
			ExpandWnd();
			break;
		case 693:
		case 5090:
		case 5091:
		case 11430:
			ClearAllShortcutItemTooltip();
			break;
			break;
		default:
			break;
	}
	return;
}

function ClearAllShortcutItemTooltip()
{
	Me.ClearAllChildShortcutItemTooltip();
	return;
}

function InitShortPageNum()
{
	CurrentShortcutPage = 0;
	CurrentShortcutPage2 = 1;
	CurrentShortcutPage3 = 2;
	CurrentShortcutPage4 = 3;
	CurrentShortcutPage5 = 4;
	CurrentShortcutPageExtend = 4;
	return;
}

function HandleShortcutPageUpdate(string param)
{
	local int i, nShortcutID, ShortcutPage;

	if(ParseInt(param, "ShortcutPage", ShortcutPage))
	{
		if(((0 > ShortcutPage) || (MAX_Page <= ShortcutPage)))
		{
			return;
		}
		CurrentShortcutPage = ShortcutPage;
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((("ShortcutWnd." $ m_ShortcutWndName) $ ".PageNumTextBox"), string((CurrentShortcutPage + 1)));
		nShortcutID = (CurrentShortcutPage * 12);
		i = 0;
		while((i < 12))
		{
			Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(((("ShortcutWnd." $ m_ShortcutWndName) $ ".Shortcut") $ string((i + 1))), nShortcutID);
			nShortcutID++;
			++i;
		}
	}
	return;
}

function HandleShortcutUpdate(string param)
{
	local int nShortcutID, nShortcutNum;

	ParseInt(param, "ShortcutID", nShortcutID);
	nShortcutNum = (int((float(nShortcutID) % 12.0000000)) + 1);
	if(IsShortcutIDInCurPage(CurrentShortcutPage, nShortcutID))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(((("ShortcutWnd." $ m_ShortcutWndName) $ ".Shortcut") $ string(nShortcutNum)), nShortcutID);
	}
	if(IsShortcutIDInCurPage(CurrentShortcutPage2, nShortcutID))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(((("ShortcutWnd." $ m_ShortcutWndName) $ "_1.Shortcut") $ string(nShortcutNum)), nShortcutID);
	}
	if(IsShortcutIDInCurPage(CurrentShortcutPage3, nShortcutID))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(((("ShortcutWnd." $ m_ShortcutWndName) $ "_2.Shortcut") $ string(nShortcutNum)), nShortcutID);
	}
	if(IsShortcutIDInCurPage(CurrentShortcutPage4, nShortcutID))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(((("ShortcutWnd." $ m_ShortcutWndName) $ "_3.Shortcut") $ string(nShortcutNum)), nShortcutID);
	}
	if(IsShortcutIDInCurPage(CurrentShortcutPage5, nShortcutID))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(((("ShortcutWnd." $ m_ShortcutWndName) $ "_4.Shortcut") $ string(nShortcutNum)), nShortcutID);
	}
	if(IsShortcutIDInCurPage(CurrentShortcutPageExtend, nShortcutID))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(((("ShortcutWnd." $ m_ShortcutWndExtendName) $ ".Shortcut") $ string(nShortcutNum)), nShortcutID);
	}
	return;
}

function HandleShortcutClear()
{
	local int i;

	i = 0;
	while((i < 12))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear(("ShortcutWnd.ShortcutWndVertical.Shortcut" $ string((i + 1))));
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear(("ShortcutWnd.ShortcutWndVertical_1.Shortcut" $ string((i + 1))));
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear(("ShortcutWnd.ShortcutWndVertical_2.Shortcut" $ string((i + 1))));
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear(("ShortcutWnd.ShortcutWndVertical_3.Shortcut" $ string((i + 1))));
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear(("ShortcutWnd.ShortcutWndHorizontal.Shortcut" $ string((i + 1))));
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear(("ShortcutWnd.ShortcutWndHorizontal_1.Shortcut" $ string((i + 1))));
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear(("ShortcutWnd.ShortcutWndHorizontal_2.Shortcut" $ string((i + 1))));
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear(("ShortcutWnd.ShortcutWndHorizontal_3.Shortcut" $ string((i + 1))));
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear(("ShortcutWnd.ShortcutWnd_Extend.Shortcut" $ string((i + 1))));
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear(("ShortcutWnd.ShortcutWndJoypadExpand.Shortcut" $ string((i + 1))));
		++i;
	}
	i = 0;
	while((i < 4))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear(("ShortcutWnd.ShortcutWndJoypad.Shortcut" $ string((i + 1))));
		++i;
	}
	return;
}

function OnClickButton(string a_strID)
{
	switch(a_strID)
	{
		case "PrevBtn":
			OnPrevBtn();
			break;
		case "NextBtn":
			OnNextBtn();
			break;
		case "PrevBtn2":
			OnPrevBtn2();
			break;
		case "NextBtn2":
			OnNextBtn2();
			break;
		case "PrevBtn3":
			OnPrevBtn3();
			break;
		case "NextBtn3":
			OnNextBtn3();
			break;
		case "PrevBtn4":
			OnPrevBtn4();
			break;
		case "PrevBtnExtend":
			OnPrevBtnExtend();
			break;
		case "NextBtn4":
			OnNextBtn4();
			break;
		case "NextBtnExtend":
			OnNextBtnExtend();
			break;
		case "PrevBtn5":
			OnPrevBtn5();
			break;
		case "NextBtn5":
			OnNextBtn5();
			break;
		case "LockBtn":
			OnClickLockBtn();
			break;
		case "UnlockBtn":
			OnClickUnlockBtn();
			break;
		case "RotateBtn":
			OnRotateBtn();
			break;
		case "JoypadBtn":
			OnJoypadBtn();
			break;
		case "ExpandBtn":
			OnExpandBtn();
			break;
		case "ExpandButton":
			OnClickExpandShortcutButton();
			break;
		case "ReduceButton":
			OnClickExpandShortcutButton();
			break;
		case "TooltipMinBtn":
			OnMinBtn();
			break;
		case "TooltipMaxBtn":
			OnMaxBtn();
			break;
		case "BounsExtendSlotBtn":
			OnBounsExtendSlotBtn();
			break;
		default:
			break;
	}
	return;
}

function OnBounsExtendSlotBtn()
{
	if(GetWindowHandle("ShortcutWnd.ShortcutWnd_Extend").IsShowWindow())
	{
		GetWindowHandle("ShortcutWnd.ShortcutWnd_Extend").HideWindow();
		SetINIInt("ShortcutWnd", "m", 0, "WindowsInfo.ini");
	}
	else
	{
		GetWindowHandle("ShortcutWnd.ShortcutWnd_Extend").ShowWindow();
		SetINIInt("ShortcutWnd", "m", 1, "WindowsInfo.ini");
	}
	return;
}

function OnMinBtn()
{
	local ToolTip Script;

	HandleShortcutClear();
	ArrangeWnd();
	ExpandWnd();
	Script = ToolTip(GetScript("Tooltip"));
	Script.setBoolSelect(true);
	ShowWindow("ShortcutWnd.ShortcutWndHorizontal.TooltipMaxBtn");
	HideWindow("ShortcutWnd.ShortcutWndHorizontal.TooltipMinBtn");
	ShowWindow("ShortcutWnd.ShortcutWndVertical.TooltipMaxBtn");
	HideWindow("ShortcutWnd.ShortcutWndVertical.TooltipMinBtn");
	SetINIBool("ShortcutWnd", "l", false, "windowsInfo.ini");
	return;
}

function OnMaxBtn()
{
	local ToolTip Script;

	HandleShortcutClear();
	ArrangeWnd();
	ExpandWnd();
	Script = ToolTip(GetScript("Tooltip"));
	Script.setBoolSelect(false);
	ShowWindow("ShortcutWnd.ShortcutWndHorizontal.TooltipMinBtn");
	HideWindow("ShortcutWnd.ShortcutWndHorizontal.TooltipMaxBtn");
	ShowWindow("ShortcutWnd.ShortcutWndVertical.TooltipMinBtn");
	HideWindow("ShortcutWnd.ShortcutWndVertical.TooltipMaxBtn");
	SetINIBool("ShortcutWnd", "l", true, "windowsInfo.ini");
	return;
}

function OnPrevBtn()
{
	local int nNewPage;

	nNewPage = (CurrentShortcutPage - 1);
	if((0 > nNewPage))
	{
		nNewPage = (MAX_Page - 1);
	}
	SetCurPage(nNewPage);
	return;
}

function OnPrevBtn2()
{
	local int nNewPage;

	nNewPage = (CurrentShortcutPage2 - 1);
	if((0 > nNewPage))
	{
		nNewPage = (MAX_Page - 1);
	}
	SetCurPage2(nNewPage);
	return;
}

function OnPrevBtn3()
{
	local int nNewPage;

	nNewPage = (CurrentShortcutPage3 - 1);
	if((0 > nNewPage))
	{
		nNewPage = (MAX_Page - 1);
	}
	SetCurPage3(nNewPage);
	return;
}

function OnPrevBtn4()
{
	local int nNewPage;

	nNewPage = (CurrentShortcutPage4 - 1);
	if((0 > nNewPage))
	{
		nNewPage = (MAX_Page - 1);
	}
	SetCurPage4(nNewPage);
	return;
}

function OnPrevBtnExtend()
{
	local int nNewPage;

	nNewPage = (CurrentShortcutPageExtend - 1);
	if((0 > nNewPage))
	{
		nNewPage = (MAX_Page - 1);
	}
	SetCurPageExtend(nNewPage);
	return;
}

function OnNextBtnExtend()
{
	local int nNewPage;

	nNewPage = (CurrentShortcutPageExtend + 1);
	if((MAX_Page <= nNewPage))
	{
		nNewPage = 0;
	}
	SetCurPageExtend(nNewPage);
	return;
}

function OnNextBtn()
{
	local int nNewPage;

	nNewPage = (CurrentShortcutPage + 1);
	if((MAX_Page <= nNewPage))
	{
		nNewPage = 0;
	}
	SetCurPage(nNewPage);
	return;
}

function OnNextBtn2()
{
	local int nNewPage;

	nNewPage = (CurrentShortcutPage2 + 1);
	if((MAX_Page <= nNewPage))
	{
		nNewPage = 0;
	}
	SetCurPage2(nNewPage);
	return;
}

function OnNextBtn3()
{
	local int nNewPage;

	nNewPage = (CurrentShortcutPage3 + 1);
	if((MAX_Page <= nNewPage))
	{
		nNewPage = 0;
	}
	SetCurPage3(nNewPage);
	return;
}

function OnNextBtn4()
{
	local int nNewPage;

	nNewPage = (CurrentShortcutPage4 + 1);
	if((MAX_Page <= nNewPage))
	{
		nNewPage = 0;
	}
	SetCurPage4(nNewPage);
	return;
}

function OnPrevBtn5()
{
	local int nNewPage;

	nNewPage = (CurrentShortcutPage5 - 1);
	if((0 > nNewPage))
	{
		nNewPage = (MAX_Page - 1);
	}
	SetCurPage5(nNewPage);
	return;
}

function OnNextBtn5()
{
	local int nNewPage;

	nNewPage = (CurrentShortcutPage5 + 1);
	if((MAX_Page <= nNewPage))
	{
		nNewPage = 0;
	}
	SetCurPage5(nNewPage);
	return;
}

function OnClickLockBtn()
{
	UNLOCK();
	return;
}

function OnClickUnlockBtn()
{
	Lock();
	return;
}

function OnRotateBtn()
{
	SetVertical(!m_IsVertical);
	if(m_IsVertical)
	{
		Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("ShortcutWnd.ShortcutWndVertical", "ShortcutWnd.ShortcutWndHorizontal", "BottomRight", "BottomRight", 0, 0);
		Class'NWindow.UIAPI_WINDOW'.static.ClearAnchor("ShortcutWnd.ShortcutWndVertical");
		Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("ShortcutWnd.ShortcutWndHorizontal", "ShortcutWnd.ShortcutWndVertical", "BottomRight", "BottomRight", 0, 0);
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("ShortcutWnd.ShortcutWndHorizontal", "ShortcutWnd.ShortcutWndVertical", "BottomRight", "BottomRight", 0, 0);
		Class'NWindow.UIAPI_WINDOW'.static.ClearAnchor("ShortcutWnd.ShortcutWndHorizontal");
		Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("ShortcutWnd.ShortcutWndVertical", "ShortcutWnd.ShortcutWndHorizontal", "BottomRight", "BottomRight", 0, 0);
	}
	ExpandByNum(m_Expand);
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus(("ShortcutWnd." $ m_ShortcutWndName));
	AutoShotItemWndScript.ExHideSubWnd();
	return;
}

function OnJoypadBtn()
{
	SetJoypad(!m_IsJoypad);
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus(("ShortcutWnd." $ m_ShortcutWndName));
	return;
}

function OnExpandBtn()
{
	SetJoypadExpand(!m_IsJoypadExpand);
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus(("ShortcutWnd." $ m_ShortcutWndName));
	return;
}

function SetCurPage(int a_nCurPage)
{
	if(((0 > a_nCurPage) || (MAX_Page <= a_nCurPage)))
	{
		return;
	}
	Class'NWindow.ShortcutWndAPI'.static.SetShortcutPage(a_nCurPage);
	return;
}

function SetCurPage2(int a_nCurPage)
{
	local int i, nShortcutID;

	if(((0 > a_nCurPage) || (MAX_Page <= a_nCurPage)))
	{
		return;
	}
	CurrentShortcutPage2 = a_nCurPage;
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText(((((("ShortcutWnd." $ m_ShortcutWndName) $ ".") $ m_ShortcutWndName) $ "_1") $ ".PageNumTextBox"), string((CurrentShortcutPage2 + 1)));
	nShortcutID = (CurrentShortcutPage2 * 12);
	i = 0;
	while((i < 12))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut((((((("ShortcutWnd." $ m_ShortcutWndName) $ ".") $ m_ShortcutWndName) $ "_1") $ ".Shortcut") $ string((i + 1))), nShortcutID);
		nShortcutID++;
		++i;
	}
	return;
}

function SetCurPage3(int a_nCurPage)
{
	local int i, nShortcutID;

	if(((0 > a_nCurPage) || (MAX_Page <= a_nCurPage)))
	{
		return;
	}
	CurrentShortcutPage3 = a_nCurPage;
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText(((((((("ShortcutWnd." $ m_ShortcutWndName) $ ".") $ m_ShortcutWndName) $ "_1.") $ m_ShortcutWndName) $ "_2") $ ".PageNumTextBox"), string((CurrentShortcutPage3 + 1)));
	nShortcutID = (CurrentShortcutPage3 * 12);
	i = 0;
	while((i < 12))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut((((((((("ShortcutWnd." $ m_ShortcutWndName) $ ".") $ m_ShortcutWndName) $ "_1.") $ m_ShortcutWndName) $ "_2") $ ".Shortcut") $ string((i + 1))), nShortcutID);
		nShortcutID++;
		++i;
	}
	return;
}

function SetCurPage4(int a_nCurPage)
{
	local int i, nShortcutID;

	if(((0 > a_nCurPage) || (MAX_Page <= a_nCurPage)))
	{
		return;
	}
	CurrentShortcutPage4 = a_nCurPage;
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText(((((((("ShortcutWnd." $ m_ShortcutWndName) $ ".") $ m_ShortcutWndName) $ "_1.") $ m_ShortcutWndName) $ "_3") $ ".PageNumTextBox"), string((CurrentShortcutPage4 + 1)));
	nShortcutID = (CurrentShortcutPage4 * 12);
	i = 0;
	while((i < 12))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut((((((((("ShortcutWnd." $ m_ShortcutWndName) $ ".") $ m_ShortcutWndName) $ "_1.") $ m_ShortcutWndName) $ "_3") $ ".Shortcut") $ string((i + 1))), nShortcutID);
		nShortcutID++;
		++i;
	}
	return;
}

function SetCurPage5(int a_nCurPage)
{
	local int i, nShortcutID;

	if(((0 > a_nCurPage) || (MAX_Page <= a_nCurPage)))
	{
		return;
	}
	CurrentShortcutPage5 = a_nCurPage;
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText(((((((("ShortcutWnd." $ m_ShortcutWndName) $ ".") $ m_ShortcutWndName) $ "_1.") $ m_ShortcutWndName) $ "_4") $ ".PageNumTextBox"), string((CurrentShortcutPage5 + 1)));
	nShortcutID = (CurrentShortcutPage5 * 12);
	i = 0;
	while((i < 12))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut((((((((("ShortcutWnd." $ m_ShortcutWndName) $ ".") $ m_ShortcutWndName) $ "_1.") $ m_ShortcutWndName) $ "_4") $ ".Shortcut") $ string((i + 1))), nShortcutID);
		nShortcutID++;
		++i;
	}
	return;
}

function SetCurPageExtend(int a_nCurPage)
{
	local int i, nShortcutID;

	if(((0 > a_nCurPage) || (MAX_Page <= a_nCurPage)))
	{
		return;
	}
	CurrentShortcutPageExtend = a_nCurPage;
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((("ShortcutWnd." $ m_ShortcutWndExtendName) $ ".PageNumTextBox"), string((CurrentShortcutPageExtend + 1)));
	nShortcutID = (CurrentShortcutPageExtend * 12);
	i = 0;
	while((i < 12))
	{
		Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(((("ShortcutWnd." $ m_ShortcutWndExtendName) $ ".Shortcut") $ string((i + 1))), nShortcutID);
		nShortcutID++;
		++i;
	}
	return;
}

function bool IsShortcutIDInCurPage(int PageNum, int a_nShortcutID)
{
	if(((PageNum * 12) > a_nShortcutID))
	{
		return false;
	}
	if((((PageNum + 1) * 12) <= a_nShortcutID))
	{
		return false;
	}
	return true;
}

function Lock()
{
	m_IsLocked = true;
	SetOptionBool("Game", "IsLockShortcutWnd", true);
	ShowWindow((("ShortcutWnd." $ m_ShortcutWndName) $ ".LockBtn"));
	HideWindow((("ShortcutWnd." $ m_ShortcutWndName) $ ".UnlockBtn"));
	return;
}

function UNLOCK()
{
	m_IsLocked = false;
	SetOptionBool("Game", "IsLockShortcutWnd", false);
	ShowWindow((("ShortcutWnd." $ m_ShortcutWndName) $ ".UnlockBtn"));
	HideWindow((("ShortcutWnd." $ m_ShortcutWndName) $ ".LockBtn"));
	return;
}

function SetVertical(bool a_IsVertical)
{
	m_IsVertical = a_IsVertical;
	SetINIInt("ShortcutWnd", "v", int(m_IsVertical), "WindowsInfo.ini");
	ArrangeWnd();
	ExpandWnd();
	return;
}

function ArrangeWnd()
{
	local Rect WindowRect;

	if(m_IsJoypad)
	{
		HideWindow("ShortcutWnd.ShortcutWndVertical");
		HideWindow("ShortcutWnd.ShortcutWndHorizontal");
		if(m_IsJoypadExpand)
		{
			HideWindow("ShortcutWnd.ShortcutWndJoypad");
			ShowWindow("ShortcutWnd.ShortcutWndJoypadExpand");
			m_ShortcutWndName = "ShortcutWndJoypadExpand";
		}
		else
		{
			HideWindow("ShortcutWnd.ShortcutWndJoypadExpand");
			ShowWindow("ShortcutWnd.ShortcutWndJoypad");
			m_ShortcutWndName = "ShortcutWndJoypad";
		}
	}
	else
	{
		HideWindow("ShortcutWnd.ShortcutWndJoypadExpand");
		HideWindow("ShortcutWnd.ShortcutWndJoypad");
		if(m_IsVertical)
		{
			m_ShortcutWndName = "ShortcutWndVertical";
			WindowRect = Class'NWindow.UIAPI_WINDOW'.static.GetRect("ShortcutWnd.ShortcutWndVertical");
			if((WindowRect.nY < 0))
			{
				Class'NWindow.UIAPI_WINDOW'.static.MoveTo("ShortcutWnd.ShortcutWndVertical", WindowRect.nX, 0);
			}
			HideWindow("ShortcutWnd.ShortcutWndHorizontal");
			ShowWindow("ShortcutWnd.ShortcutWndVertical");
		}
		else
		{
			m_ShortcutWndName = "ShortcutWndHorizontal";
			WindowRect = Class'NWindow.UIAPI_WINDOW'.static.GetRect("ShortcutWnd.ShortcutWndHorizontal");
			if((WindowRect.nX < 0))
			{
				Class'NWindow.UIAPI_WINDOW'.static.MoveTo("ShortcutWnd.ShortcutWndHorizontal", 0, WindowRect.nY);
			}
			HideWindow("ShortcutWnd.ShortcutWndVertical");
			ShowWindow("ShortcutWnd.ShortcutWndHorizontal");
		}
		if(m_IsJoypadOn)
		{
			ShowWindow((("ShortcutWnd." $ m_ShortcutWndName) $ ".JoypadBtn"));
		}
		else
		{
			HideWindow((("ShortcutWnd." $ m_ShortcutWndName) $ ".JoypadBtn"));
		}
	}
	if(m_IsLocked)
	{
		Lock();
	}
	else
	{
		UNLOCK();
	}
	SetCurPage(CurrentShortcutPage);
	SetCurPage2(CurrentShortcutPage2);
	SetCurPage3(CurrentShortcutPage3);
	SetCurPage4(CurrentShortcutPage4);
	SetCurPageExtend(CurrentShortcutPageExtend);
	m_IsShortcutExpand = (m_Expand != (MAX_ShortcutExtend - 1));
	HandleExpandButton();
	return;
}

function ExpandWnd()
{
	if((m_Expand > 0))
	{
		m_IsShortcutExpand = false;
		ExpandByNum(m_Expand);
	}
	else
	{
		m_IsShortcutExpand = true;
		Reduce();
	}
	return;
}

function ExpandByNum(int expandNum)
{
	m_IsShortcutExpand = true;
	m_Expand = expandNum;
	switch(expandNum)
	{
		case 3:
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndVertical_3");
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndHorizontal_3");
		case 2:
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndVertical_2");
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndHorizontal_2");
		case 1:
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndVertical_1");
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndHorizontal_1");
			break;
		default:
			break;
	}
	SetINIInt("ShortcutWnd", "e", m_Expand, "WindowsInfo.ini");
	HandleExpandButton();
	AutoShotItemWndScript.windowPositionAutoMove();
	AutoShotItemWndScript.checkSlotShowState();
	return;
}

function Reduce()
{
	m_IsShortcutExpand = true;
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_1");
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_2");
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_1");
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_2");
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_3");
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_3");
	m_Expand = 0;
	SetINIInt("ShortcutWnd", "e", m_Expand, "WindowsInfo.ini");
	HandleExpandButton();
	AutoShotItemWndScript.windowPositionAutoMove();
	AutoShotItemWndScript.checkSlotShowState();
	return;
}

function OnClickExpandShortcutButton()
{
	if((m_Expand == (MAX_ShortcutExtend - 1)))
	{
		Reduce();
	}
	else
	{
		ExpandByNum((m_Expand + 1));
	}
	return;
}

function ExecuteShortcutCommandBySlot(string param)
{
	local int Slot;

	ParseInt(param, "Slot", Slot);
	if(Me.IsShowWindow())
	{
		if(((Slot >= 0) && (Slot < 12)))
		{
			Class'NWindow.ShortcutWndAPI'.static.ExecuteShortcutBySlot(((CurrentShortcutPage * 12) + Slot));
		}
		else if(((Slot >= 12) && (Slot < (12 * 2))))
		{
			Class'NWindow.ShortcutWndAPI'.static.ExecuteShortcutBySlot((((CurrentShortcutPage2 * 12) + Slot) - 12));
		}
		else if(((Slot >= (12 * 2)) && (Slot < (12 * 3))))
		{
			Class'NWindow.ShortcutWndAPI'.static.ExecuteShortcutBySlot((((CurrentShortcutPage3 * 12) + Slot) - 24));
		}
		else if(((Slot >= (12 * 3)) && (Slot < (12 * 4))))
		{
			Class'NWindow.ShortcutWndAPI'.static.ExecuteShortcutBySlot((((CurrentShortcutPage4 * 12) + Slot) - 36));
		}
	}
	return;
}

function HandleExpandButton()
{
	if(IsAdenServer())
	{
		return;
	}
	if(m_IsShortcutExpand)
	{
		ShowWindow((("ShortcutWnd." $ m_ShortcutWndName) $ ".ExpandButton"));
		HideWindow((("ShortcutWnd." $ m_ShortcutWndName) $ ".ReduceButton"));
	}
	else
	{
		HideWindow((("ShortcutWnd." $ m_ShortcutWndName) $ ".ExpandButton"));
		ShowWindow((("ShortcutWnd." $ m_ShortcutWndName) $ ".ReduceButton"));
	}
	return;
}

function bool IsVertical()
{
	return m_IsVertical;
}

function int getExpandNum()
{
	return m_Expand;
}

function AutoShotPositionAutoMove()
{
	AutoShotItemWndScript.windowPositionAutoMove();
	AutoShotItemWndScript.checkSlotShowState();
	return;
}

function SetJoypad(bool a_IsJoypad)
{
	m_IsJoypad = a_IsJoypad;
	ArrangeWnd();
	return;
}

function SetJoypadExpand(bool a_IsJoypadExpand)
{
	m_IsJoypadExpand = a_IsJoypadExpand;
	if(m_IsJoypadExpand)
	{
		Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("ShortcutWnd.ShortcutWndJoypadExpand", "ShortcutWnd.ShortcutWndJoypad", "TopLeft", "TopLeft", 0, 0);
		Class'NWindow.UIAPI_WINDOW'.static.ClearAnchor("ShortcutWnd.ShortcutWndJoypadExpand");
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("ShortcutWnd.ShortcutWndJoypad", "ShortcutWnd.ShortcutWndJoypadExpand", "TopLeft", "TopLeft", 0, 0);
		Class'NWindow.UIAPI_WINDOW'.static.ClearAnchor("ShortcutWnd.ShortcutWndJoypad");
	}
	ArrangeWnd();
	return;
}

function HandleShortcutJoypad(string a_Param)
{
	local int onOff;

	if(ParseInt(a_Param, "OnOff", onOff))
	{
		if((1 == onOff))
		{
			m_IsJoypadOn = true;
			if((Len(m_ShortcutWndName) > 0))
			{
				ShowWindow((("ShortcutWnd." $ m_ShortcutWndName) $ ".JoypadBtn"));
			}
		}
		else if((0 == onOff))
		{
			m_IsJoypadOn = false;
			if((Len(m_ShortcutWndName) > 0))
			{
				HideWindow((("ShortcutWnd." $ m_ShortcutWndName) $ ".JoypadBtn"));
			}
		}
	}
	return;
}

function HandleJoypadLButtonUp(string a_Param)
{
	SetJoypadShortcut(JOYSHORTCUT_Center);
	return;
}

function HandleJoypadLButtonDown(string a_Param)
{
	SetJoypadShortcut(JOYSHORTCUT_Left);
	return;
}

function HandleJoypadRButtonUp(string a_Param)
{
	SetJoypadShortcut(JOYSHORTCUT_Center);
	return;
}

function HandleJoypadRButtonDown(string a_Param)
{
	SetJoypadShortcut(JOYSHORTCUT_Right);
	return;
}

function SetJoypadShortcut(EJoyShortcut a_JoyShortcut)
{
	local int i, nShortcutID;

	switch(a_JoyShortcut)
	{
		case JOYSHORTCUT_Left:
			Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypadExpand.JoypadButtonBackTex", "L2UI_CH3.ShortcutWnd.joypad2_back_over1");
			Class'NWindow.UIAPI_TEXTURECTRL'.static.SetAnchor("ShortcutWnd.ShortcutWndJoypadExpand.JoypadButtonBackTex", "ShortcutWnd.ShortcutWndJoypadExpand", "TopLeft", "TopLeft", 28, 0);
			Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypad.JoypadLButtonTex", "L2UI_ch3.Joypad.joypad_L_HOLD");
			Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypad.JoypadRButtonTex", "L2UI_ch3.Joypad.joypad_R");
			nShortcutID = ((CurrentShortcutPage * 12) + 4);
			i = 0;
			while((i < 4))
			{
				Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(("ShortcutWnd.ShortcutWndJoypad.Shortcut" $ string((i + 1))), nShortcutID);
				nShortcutID++;
				++i;
			}
			break;
		case JOYSHORTCUT_Center:
			Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypadExpand.JoypadButtonBackTex", "L2UI_CH3.ShortcutWnd.joypad2_back_over2");
			Class'NWindow.UIAPI_TEXTURECTRL'.static.SetAnchor("ShortcutWnd.ShortcutWndJoypadExpand.JoypadButtonBackTex", "ShortcutWnd.ShortcutWndJoypadExpand", "TopLeft", "TopLeft", 158, 0);
			Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypad.JoypadLButtonTex", "L2UI_ch3.Joypad.joypad_L");
			Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypad.JoypadRButtonTex", "L2UI_ch3.Joypad.joypad_R");
			nShortcutID = (CurrentShortcutPage * 12);
			i = 0;
			while((i < 4))
			{
				Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(("ShortcutWnd.ShortcutWndJoypad.Shortcut" $ string((i + 1))), nShortcutID);
				nShortcutID++;
				++i;
			}
			break;
		case JOYSHORTCUT_Right:
			Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypadExpand.JoypadButtonBackTex", "L2UI_CH3.ShortcutWnd.joypad2_back_over3");
			Class'NWindow.UIAPI_TEXTURECTRL'.static.SetAnchor("ShortcutWnd.ShortcutWndJoypadExpand.JoypadButtonBackTex", "ShortcutWnd.ShortcutWndJoypadExpand", "TopLeft", "TopLeft", 288, 0);
			Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypad.JoypadLButtonTex", "L2UI_ch3.Joypad.joypad_L");
			Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypad.JoypadRButtonTex", "L2UI_ch3.Joypad.joypad_R_HOLD");
			nShortcutID = ((CurrentShortcutPage * 12) + 8);
			i = 0;
			while((i < 4))
			{
				Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(("ShortcutWnd.ShortcutWndJoypad.Shortcut" $ string((i + 1))), nShortcutID);
				nShortcutID++;
				++i;
			}
			break;
		default:
			break;
	}
	return;
}

defaultproperties
{
	MAX_Page=10
	MAX_ShortcutExtend=3
	m_IsVertical=true
}
