class SideBar extends UICommonAPI
	dependson(UIPacket);

const WINDOWSIZE = 49;
const WINDOW_H_MIN = 2;
const WINDOW_H_GAP = 2;
const DIALOG_ID_MYSTERIOUS_CANCEL = 0;
const SIDEBAR_WIDTH = 52;

enum SIDEBAR_WINDOWS
{
	TYPE_VP,                        // 0
	TYPE_ELEMENT,                   // 1
	TYPE_L2PASS,                    // 2
	TYPE_LIVELCOINCRAFT,            // 3
	TYPE_EINHASD,                   // 4
	TYPE_RELIC,                     // 5
	TYPE_TIMEZONE,                  // 6
	TYPE_MYSTERIOUSHOUSE,           // 7
	TYPE_HENNAENGRAVE,              // 8
	TYPE_HEROBOOK,                  // 9
	TYPE_NSHOP,                     // 10
	TYPE_VITAMANMANAGER,            // 11
	TYPE_RANKING,                   // 12
	TYPE_HOMUNCULUSWND,             // 13
	TYPE_COLLECTIONSYSTEM,          // 14
	TYPE_WORLDEXCHANGE,             // 15
	TYPE_EVENTINFO,                 // 16
	TYPE_EVENT_EVENTLETTERCOLLECTOR,// 17
	TYPE_EVENT_EVENTBALTHUS,        // 18
	TYPE_EVENT_MARBLEGAME,          // 19
	TYPE_EVENT_FESTIVAL,            // 20
	TYPE_EVENT_FESTIVAL_WRANKING,   // 21
	TYPE_EVENT_FESTIVALRANKING,     // 22
	TYPE_STEADYBOX,                 // 23
	TYPE_VIP,                       // 24
	TYPE_L2PASS_LIVE,               // 25
	TYPE_CASHSHOP,                  // 26
	TYPE_UNIQUEGACHA,               // 27
	TYPE_VIRTUAL_ITEM,              // 28
	TYPE_CROSS_EVENT,               // 29
	Max                             // 30
};

enum SIDEBAR_TYPE
{
	TYPE_NORMAL,                    // 0
	TYPE_ONEVENT,                   // 1
	TYPE_SIDEBAR                    // 2
};

struct ItemData
{
	var string WindowName;
	var bool IsActive;
	var bool isAlarm;
	var bool UseEffect;
	var SIDEBAR_TYPE Type;
};

var string m_Windowname;
var WindowHandle Me;
var Rect rectWndLDowned;
var bool isShowSideBar;
var bool isLockVOption;
var array<ItemData> itemDatas;

static function SideBar Inst()
{
	return SideBar(GetScript("SideBar"));
}

function SetWindowInit()
{
	itemDatas.Length = 30;
	itemDatas[0].WindowName = "SideBarVPWnd";
	itemDatas[0].Type = TYPE_SIDEBAR;
	itemDatas[1].WindowName = "ElementalSpiritWnd";
	itemDatas[3].WindowName = "ShopLcoinCraftWnd";
	itemDatas[4].WindowName = "EinhasdWnd";
	itemDatas[6].WindowName = "TimeZoneWnd";
	itemDatas[7].WindowName = "MysteriousMansionWnd";
	itemDatas[7].Type = TYPE_ONEVENT;
	itemDatas[10].WindowName = "NShopWnd";
	itemDatas[11].WindowName = "PremiumManagerWnd";
	itemDatas[12].WindowName = "RankingWnd";
	itemDatas[9].WindowName = "HeroBookWnd";
	itemDatas[13].WindowName = "HomunculusWnd";
	itemDatas[13].UseEffect = true;
	SetHomnuCulusTooltip(-1, -1, -1);
	itemDatas[14].WindowName = "CollectionSystem";
	itemDatas[15].WindowName = "WorldExchangeBuyWnd";
	itemDatas[5].WindowName = "RelicWnd";
	GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".BtnRelicWnd.Registration_tex")).HideWindow();
	itemDatas[16].WindowName = "EventInfoWnd";
	itemDatas[16].Type = TYPE_ONEVENT;
	itemDatas[17].WindowName = "EventletterCollectorLauncher";
	itemDatas[17].Type = TYPE_ONEVENT;
	itemDatas[18].WindowName = "EventBalthus";
	itemDatas[18].Type = TYPE_ONEVENT;
	itemDatas[19].WindowName = "MarbleGameWnd";
	itemDatas[19].Type = TYPE_ONEVENT;
	itemDatas[27].WindowName = "UniqueGacha";
	itemDatas[27].Type = TYPE_ONEVENT;
	itemDatas[20].WindowName = "EventFestivalWnd";
	itemDatas[20].Type = TYPE_ONEVENT;
	itemDatas[20].UseEffect = true;
	itemDatas[22].WindowName = "FestivaRankingWindowTooltip";
	itemDatas[22].Type = TYPE_ONEVENT;
	itemDatas[8].WindowName = "HennaEngraveWndLive";
	if(getInstanceUIData().GetIsLiveServer())
	{
		itemDatas[25].WindowName = "L2PassWnd";
	}
	else
	{
		itemDatas[2].WindowName = "L2PassWnd";
	}
	itemDatas[21].WindowName = "FestivalWRankingWindowTooltip";
	itemDatas[21].Type = TYPE_ONEVENT;
	itemDatas[24].WindowName = "VIPInfoWnd";
	itemDatas[26].WindowName = "BR_NewCashShopWnd";
	itemDatas[28].WindowName = "VirtualItemWnd";
	itemDatas[29].WindowName = "CrossEventWnd";
	if((int(GetLanguage()) == 0))
	{
		return;
	}
	itemDatas[23].WindowName = "SteadyBoxWnd";
	itemDatas[23].Type = TYPE_ONEVENT;
	itemDatas[23].UseEffect = true;
	itemDatas[24].WindowName = "VIPInfoWnd";
	itemDatas[26].WindowName = "BR_NewCashShopWnd";
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(1710);
	RegisterEvent(9310);
	RegisterEvent(9320);
	RegisterEvent(20150);
	RegisterEvent(9750);
	RegisterEvent(EV_PacketID(1162));
	RegisterEvent((100000 + 879));
	return;
}

event OnLoad()
{
	SetWindowInit();
	Me = GetWindowHandle(m_Windowname);
	return;
}

event OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 40:
			SetWindowShowHideByIndex(7, false);
			break;
		case 9320:
			SetWindowShowHideByIndex(7, false);
			break;
		case 9310:
			HandleCuriousHouse(a_Param);
			break;
		case 1710:
			HandleDialogOK();
			break;
		case 9750:
			HandleOnGameStart();
			break;
		case EV_PacketID(1162):
			RT_S_EX_HOMUNCULUS_SIDEBAR();
			break;
		case EV_PacketID(879):
			ParsePacket_S_EX_MABLE_GAME_UI_LAUNCHER();
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string a_ButtonID)
{
	if(CheckDrag())
	{
		return;
	}
	switch(a_ButtonID)
	{
		case "MinimizeButton":
			Class'Interface.MinimizeManager'.static.Inst()._MinimizeWindow(m_hOwnerWnd.m_WindowNameWithFullPath);
			break;
		default:
			break;
	}
	return;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	rectWndLDowned = Me.GetRect();
	return;
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	local string WindowName;
	local int Index;

	if(CheckDrag())
	{
		return;
	}
	WindowName = GetWindowNameByBtnName(a_ButtonHandle.GetParentWindowHandle().GetWindowName());
	Debug(((a_ButtonHandle.GetParentWindowName() @ WindowName) @ string(Index)));
	Index = GetWindowIndexByName(WindowName);
	if((Index == -1))
	{
		return;
	}
	if((int(itemDatas[Index].Type) == 2))
	{
		return;
	}
	switch(a_ButtonHandle.GetWindowName())
	{
		case "MainBGBtn0":
			SetShowTargetWindowByIndex(Index);
			break;
		case "MainBGBtn1":
			SetHideTargetWindowByIndex(Index);
			break;
		default:
			break;
	}
	return;
}

event OnMouseOver(WindowHandle W)
{
	local int Index;
	local string WindowName;

	if(((W.GetWindowName() != "MainBGBtn0") && (W.GetWindowName() != "MainBGBtn1")))
	{
		return;
	}
	WindowName = GetWindowNameByBtnName(W.GetParentWindowHandle().GetWindowName());
	Index = GetWindowIndexByName(WindowName);
	if((Index == -1))
	{
		return;
	}
	if((Index == 0))
	{
		ShowWindowTooltip(Index);
	}
	switch(Index)
	{
		case 13:
			break;
		case 2:
		case 25:
			break;
		case 5:
			break;
		case 20:
		case 24:
			ShowWindowTooltip(Index);
		default:
			SetAlarmOnOff(Index, false);
			break;
	}
	return;
}

event OnMouseOut(WindowHandle W)
{
	local int Index;
	local string WindowName;

	if((W == Me))
	{
		return;
	}
	WindowName = GetWindowNameByBtnName(W.GetParentWindowHandle().GetWindowName());
	Index = GetWindowIndexByName(WindowName);
	if((Index == -1))
	{
		return;
	}
	if((Index == 0))
	{
		HideWindowTooltip(Index);
	}
	switch(Index)
	{
		case 20:
		case 24:
			HideWindowTooltip(Index);
			break;
		default:
			break;
	}
	return;
}

event OnSetFocus(WindowHandle a_WindowHandle, bool bFocused)
{
	if(bFocused)
	{
		EffectsBringToFrontOf();
	}
	super.OnSetFocus(a_WindowHandle, bFocused);
	return;
}

event OnShow()
{
	local int i;

	i = 0;
	while((i < itemDatas.Length))
	{
		if((itemDatas[i].WindowName == ""))
		{
			i++;
			continue;
		}
		if(itemDatas[i].UseEffect)
		{
			GetWindowHandle((itemDatas[i].WindowName $ "Effect")).SetAlpha(255);
		}
		i++;
	}
	HandleCheckMainBGBtns();
	EffectsBringToFrontOf();
	CheckWorldRanking();
	return;
}

event OnHide()
{
	local int i;

	i = 0;
	while((i < itemDatas.Length))
	{
		if((itemDatas[i].WindowName == ""))
		{
			i++;
			continue;
		}
		if(itemDatas[i].UseEffect)
		{
			GetWindowHandle((itemDatas[i].WindowName $ "Effect")).SetAlpha(0, 0.4000000);
		}
		i++;
	}
	return;
}

function SetWindowShowHideByIndex(int Index, optional bool isShow)
{
	local int isShowLink;
	local WindowHandle tmpItemWnd;

	if((GetGameStateName() == "COLLECTIONSTATE"))
	{
		return;
	}
	tmpItemWnd = GetWindowByIndex(Index);
	itemDatas[Index].IsActive = isShow;
	if((int(itemDatas[Index].Type) != 2))
	{
		if(LoadVOption(itemDatas[Index].WindowName))
		{
			SetShowTargetWindowByIndex(Index);
		}
		ToggleMainBGBtn(Index, ((isShowLink == 1) || CheckIsShowLinkWindow(Index)));
	}
	if((isShow == tmpItemWnd.IsShowWindow()))
	{
		return;
	}
	if(isShow)
	{
		tmpItemWnd.ShowWindow();
	}
	else
	{
		tmpItemWnd.HideWindow();
	}
	SortWindows();
	return;
}

function HandleOnGameStart()
{
	local int i;

	i = 0;
	while((i < itemDatas.Length))
	{
		if((itemDatas[i].WindowName == ""))
		{
			i++;
			continue;
		}
		SetAlarmOnOff(i, false);
		itemDatas[i].IsActive = false;
		i++;
	}
	SetHideAllWindow();
	DefaultShowHide();
	return;
}

function DefaultShowHide()
{
	local bool bShowVP;
	local int bVitaminManager;

	SetLocalization();
	bShowVP = (getInstanceUIData().GetIsClassicServer() || IsAdenServer());
	GetINIBool("Localize", "UseVitaminMgrLive", bVitaminManager, "L2.ini");
	if(bShowVP)
	{
		SetWindowShowHideByIndex(0, bShowVP);
	}
	SetWindowShowHideByIndex(3, getInstanceUIData().GetIsLiveServer());
	SetWindowShowHideByIndex(6, true);
	SetWindowShowHideByIndex(8, getInstanceUIData().GetIsLiveServer());
	SetWindowShowHideByIndex(9, getInstanceUIData().GetIsLiveServer());
	SetWindowShowHideByIndex(10, ((int(GetLanguage()) == 0) || (int(GetLanguage()) == 4)));
	SetWindowShowHideByIndex(11, (getInstanceUIData().GetIsClassicServer() || (bVitaminManager == 1)));
	SetWindowShowHideByIndex(12, true);
	SetWindowShowHideByIndex(13, getInstanceUIData().GetIsLiveServer());
	SetWindowShowHideByIndex(14, getInstanceUIData().GetIsLiveServer());
	SetWindowShowHideByIndex(5, IsUseRelicSystem());
	if((getInstanceUIData().GetIsLiveServer() && Class'Interface.WorldExchangeBuyWnd'.static.Inst().ChkUseableServerID()))
	{
		SetWindowShowHideByIndex(15, true);
	}
	return;
}

function EffectsBringToFrontOf()
{
	local int i;

	i = 0;
	while((i < itemDatas.Length))
	{
		if((itemDatas[i].WindowName == ""))
		{
			i++;
			continue;
		}
		if(itemDatas[i].UseEffect)
		{
			GetWindowHandle((itemDatas[i].WindowName $ "Effect")).BringToFrontOf(m_Windowname);
		}
		i++;
	}
	return;
}

function SortWindows()
{
	local int i, nWndHMax, nMenuY;
	local Rect rectWnd;
	local WindowHandle tmpWindow;

	rectWnd = Me.GetRect();
	isShowSideBar = false;
	nWndHMax = 0;
	nMenuY = 0;
	i = 0;
	while((i < itemDatas.Length))
	{
		if((itemDatas[i].WindowName == ""))
		{
			i++;
			continue;
		}
		tmpWindow = GetWindowByIndex(i);
		if(itemDatas[i].IsActive)
		{
			tmpWindow.MoveTo(rectWnd.nX, ((rectWnd.nY + nWndHMax) + 25));
			nWndHMax = (nWndHMax + 49);
			isShowSideBar = true;
			if(tmpWindow.IsShowWindow())
			{
				nMenuY++;
			}
		}
		i++;
	}
	if((nMenuY == 0))
	{
		nMenuY = 1;
	}
	Me.SetWindowSize(52, ((nMenuY * 49) + 34));
	if((isShowSideBar && !Class'Interface.MinimizeManager'.static.Inst()._IsMin(m_hOwnerWnd.m_WindowNameWithFullPath)))
	{
		Me.ShowWindow();
	}
	else
	{
		Me.HideWindow();
	}
	return;
}

function HandleDialogOK()
{
	if(!DialogIsMine())
	{
		return;
	}
	switch(Class'Interface.UICommonAPI'.static.DialogGetID())
	{
		case 0:
			RequestCancelCuriousHouse();
			break;
		default:
			break;
	}
	return;
}

function ToggleMainBGBtn(int Index, bool On)
{
	if(On)
	{
		GetButtonHandle((((m_Windowname $ ".Btn") $ itemDatas[Index].WindowName) $ ".MainBGBtn0")).HideWindow();
		GetButtonHandle((((m_Windowname $ ".Btn") $ itemDatas[Index].WindowName) $ ".MainBGBtn1")).ShowWindow();
	}
	else
	{
		GetButtonHandle((((m_Windowname $ ".Btn") $ itemDatas[Index].WindowName) $ ".MainBGBtn1")).HideWindow();
		GetButtonHandle((((m_Windowname $ ".Btn") $ itemDatas[Index].WindowName) $ ".MainBGBtn0")).ShowWindow();
	}
	return;
}

function HandleCheckMainBGBtns()
{
	local int i;
	local WindowHandle targetWindow;

	i = 0;
	while((i < itemDatas.Length))
	{
		if((itemDatas[i].WindowName == ""))
		{
			i++;
			continue;
		}
		targetWindow = GetTargetWindowByIndex(i);
		if((targetWindow.m_pTargetWnd != none))
		{
			ToggleMainBGBtn(i, targetWindow.IsShowWindow());
			i++;
			continue;
		}
		ToggleMainBGBtn(i, false);
		i++;
	}
	return;
}

function ToggleByWindowName(string WindowName, bool On)
{
	local int Index;

	Index = GetWindowIndexByName(WindowName);
	if((Index == -1))
	{
		return;
	}
	ToggleMainBGBtn(Index, On);
	return;
}

function SideBarLockVOption(bool _isLockVOption)
{
	isLockVOption = _isLockVOption;
	return;
}

function SetPointByIndex(SIDEBAR_WINDOWS Index, int Min, int Max)
{
	GetStatusBarByIndex(int(Index)).SetPoint(INT64(Min), INT64(Max));
	return;
}

function SetPointExpPercentRate(SIDEBAR_WINDOWS Index, float Per)
{
	GetStatusBarByIndex(int(Index)).SetPointExpPercentRate(Per);
	return;
}

function SetIconTexture(SIDEBAR_WINDOWS Index, string TextureName)
{
	GetMainIconByIndex(int(Index)).SetTexture(TextureName);
	return;
}

function SetDisableItem(SIDEBAR_WINDOWS Index)
{
	GetButtonHandle((((m_Windowname $ ".Btn") $ itemDatas[int(Index)].WindowName) $ ".MainBGBtn1")).DisableWindow();
	GetButtonHandle((((m_Windowname $ ".Btn") $ itemDatas[int(Index)].WindowName) $ ".MainBGBtn0")).DisableWindow();
	return;
}

function SetEnableItem(SIDEBAR_WINDOWS Index)
{
	GetButtonHandle((((m_Windowname $ ".Btn") $ itemDatas[int(Index)].WindowName) $ ".MainBGBtn1")).EnableWindow();
	GetButtonHandle((((m_Windowname $ ".Btn") $ itemDatas[int(Index)].WindowName) $ ".MainBGBtn0")).EnableWindow();
	return;
}

function TextBoxHandle GetTooltipTextBoxByIndex(int Index, int textIndex)
{
	return GetTooltipTextBoxByName(itemDatas[Index].WindowName, ("text" $ string(textIndex)));
}

function TextBoxHandle GetTooltipTextBoxByName(string WindowName, string TextBoxName)
{
	return GetTextBoxHandle(((((m_Windowname $ ".Btn") $ WindowName) $ ".TooltipWnd.") $ TextBoxName));
}

function TextureHandle GetMainIconByIndex(int Index)
{
	return GetMainIconByWindowName(itemDatas[Index].WindowName);
}

function TextureHandle GetMainIconByWindowName(string WindowName)
{
	return GetTextureHandle((((m_Windowname $ ".Btn") $ WindowName) $ ".IconMain"));
}

function WindowHandle GetWindowByIndex(int Index)
{
	return GetWindowHandle(((m_Windowname $ ".Btn") $ itemDatas[Index].WindowName));
}

function StatusRoundHandle GetStatusBarByIndex(int Index)
{
	return GetStatusRoundHandle((((m_Windowname $ ".Btn") $ itemDatas[Index].WindowName) $ ".MainStatus"));
}

function TextureHandle GetMainAlarmByIndex(int Index)
{
	return GetTextureHandle((((m_Windowname $ ".Btn") $ itemDatas[Index].WindowName) $ ".MainAlarm"));
}

function TextureHandle GetMainAlarmByName(string WindowName)
{
	return GetTextureHandle((((m_Windowname $ ".Btn") $ WindowName) $ ".MainAlarm"));
}

function WindowHandle GetTargetWindowByIndex(int Index)
{
	switch(Index)
	{
		case 10:
			if(GetWindowHandle("IngameWebWnd").IsShowWindow())
			{
				if((IngameWebWnd(GetScript("IngameWebWnd")).Key == "l2nshop"))
				{
					return GetWindowHandle("IngameWebWnd");
				}
			}
			break;
		case 7:
			break;
		case 4:
			return GetWindowHandle("PremiumManagerWnd");
		default:
			return GetWindowHandle(itemDatas[Index].WindowName);
	}
}

function AnimTextureHandle GetEffectAniTextureByIndex(int windowIndex, int Index)
{
	return GetAnimTextureHandle(((itemDatas[windowIndex].WindowName $ "Effect.EffectAnim") $ string(Index)));
}

function EffectViewportWndHandle GetEffectViewportByIndex(int widowIndex, int Index)
{
	return GetEffectViewportWndHandle(((itemDatas[widowIndex].WindowName $ "Effect.EffectViewport") $ string(Index)));
}

function _SpawnEffect(int windowIndex, string TextureName, optional int EffectIndex)
{
	local EffectViewportWndHandle Viewport;

	if((GetWindowByIndex(windowIndex).IsShowWindow() == false))
	{
		return;
	}
	Viewport = GetEffectViewportByIndex(windowIndex, EffectIndex);
	Viewport.ShowWindow();
	Viewport.SpawnEffect(TextureName);
	return;
}

function _DeSpawnEffect(int windowIndex, optional int EffectIndex)
{
	local EffectViewportWndHandle Viewport;

	Viewport = GetEffectViewportByIndex(windowIndex, EffectIndex);
	Viewport.HideWindow();
	Viewport.SpawnEffect("");
	return;
}

function bool GetSomeAlarmActived()
{
	local int i;

	i = 0;
	while((i < itemDatas.Length))
	{
		if((itemDatas[i].WindowName == ""))
		{
			i++;
			continue;
		}
		if(itemDatas[i].isAlarm)
		{
			return true;
		}
		i++;
	}
	return false;
}

function bool _IsAlarmActived(SIDEBAR_WINDOWS Index)
{
	return itemDatas[int(Index)].isAlarm;
}

function bool CheckIsShowLinkWindow(int Index)
{
	switch(Index)
	{
		case 10:
			if(GetWindowHandle("IngameWebWnd").IsShowWindow())
			{
				return (IngameWebWnd(GetScript("IngameWebWnd")).Key == "l2nshop");
			}
			break;
		case 7:
			break;
		case 4:
			break;
		default:
			return Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(itemDatas[Index].WindowName);
	}
	return false;
}

function bool CheckDrag()
{
	local Rect rectWnd;

	rectWnd = Me.GetRect();
	return ((GetAbs((rectWndLDowned.nX - rectWnd.nX)) > 5) || (GetAbs((rectWndLDowned.nY - rectWnd.nY)) > 5));
}

function SetAlarmOnOff(int Index, bool On)
{
	if((!itemDatas[Index].IsActive && On))
	{
		return;
	}
	itemDatas[Index].isAlarm = On;
	if(On)
	{
		PlayMainEffectByIndex(Index);
		GetMainAlarmByIndex(Index).ShowWindow();
	}
	else
	{
		GetMainAlarmByIndex(Index).HideWindow();
	}
	if(GetSomeAlarmActived())
	{
		Class'Interface.MinimizeManager'.static.Inst()._ShowAlarm(m_hOwnerWnd.m_WindowNameWithFullPath);
	}
	else
	{
		Class'Interface.MinimizeManager'.static.Inst()._HideAlarm(m_hOwnerWnd.m_WindowNameWithFullPath);
	}
	return;
}

function PlayMainEffectByIndex(int Index)
{
	local AnimTextureHandle effectTextureHandle;

	effectTextureHandle = GetAnimTextureHandle((((m_Windowname $ ".Btn") $ itemDatas[Index].WindowName) $ ".MainEffect"));
	effectTextureHandle.Stop();
	effectTextureHandle.SetLoopCount(1);
	effectTextureHandle.Play();
	return;
}

function SaveVOption(string WindowName, bool On)
{
	if(!isLockVOption)
	{
		SetINIBool(WindowName, "v", On, "WindowsInfo.ini");
	}
	return;
}

function bool LoadVOption(string WindowName)
{
	local int Value;

	if(!GetINIBool(WindowName, "v", Value, "WindowsInfo.ini"))
	{
		return false;
	}
	return (Value == 1);
}

function CustomTooltip getCustomToolTip(string Text)
{
	local CustomTooltip ToolTip;
	local DrawItemInfo Info;

	ToolTip.MinimumWidth = 144;
	ToolTip.DrawList.Length = 1;
	Info.eType = DIT_TEXT;
	Info.t_bDrawOneLine = true;
	Info.t_color.R = 178;
	Info.t_color.G = 190;
	Info.t_color.B = 207;
	Info.t_color.A = 255;
	Info.t_strText = Text;
	ToolTip.DrawList[0] = Info;
	return ToolTip;
}

function string GetEllipsisString(string Str, int MaxWidth)
{
	local string fixedString;
	local int nWidth, nHeight, textWidth;

	textWidth = MaxWidth;
	GetTextSizeDefault((Str $ "..."), nWidth, nHeight);
	if((nWidth < textWidth))
	{
		return Str;
	}
	fixedString = DivideStringWithWidth(Str, textWidth);
	if((fixedString != Str))
	{
		fixedString = (fixedString $ "...");
	}
	return fixedString;
}

function int GetWindowIndexByName(string WindowName)
{
	local int i;

	i = 0;
	while((i < itemDatas.Length))
	{
		if((itemDatas[i].WindowName == ""))
		{
			i++;
			continue;
		}
		if((ToUpper(itemDatas[i].WindowName) == ToUpper(WindowName)))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function string GetWindowNameByBtnName(string btnName)
{
	return Right(btnName, (Len(btnName) - 3));
}

function int GetAbs(int Num)
{
	if((Num < 0))
	{
		return -Num;
	}
	return Num;
}

function SetHideAllWindow()
{
	local int i;

	i = 0;
	while((i < itemDatas.Length))
	{
		if((itemDatas[i].WindowName == ""))
		{
			i++;
			continue;
		}
		GetWindowByIndex(i).HideWindow();
		i++;
	}
	return;
}

function SetShowAllWindow()
{
	local int i;

	i = 0;
	while((i < itemDatas.Length))
	{
		if((itemDatas[i].WindowName == ""))
		{
			i++;
			continue;
		}
		if(itemDatas[i].IsActive)
		{
			GetWindowByIndex(i).ShowWindow();
		}
		i++;
	}
	return;
}

function SetHideTargetWindowByIndex(int Index)
{
	local WindowHandle targetWindow, emtyWindow;

	switch(Index)
	{
		case 1:
		case 17:
		case 18:
		case 24:
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow(itemDatas[Index].WindowName);
			return;
		case 15:
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("WorldExchangeBuyWnd");
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("WorldExchangeRegiWnd");
			return;
		case 27:
			UniqueGacha(GetScript("UniqueGacha")).closeAltW();
			return;
		default:
			targetWindow = GetTargetWindowByIndex(Index);
			if((emtyWindow == targetWindow))
			{
				return;
			}
			targetWindow.HideWindow();
			if((int(itemDatas[Index].Type) == 2))
			{
				SaveVOption(targetWindow.GetWindowName(), false);
			}
			return;
	}
}

function SetShowTargetWindowByIndex(int Index)
{
	local WindowHandle targetWindow, emptyWindow;

	switch(Index)
	{
		case 10:
			showHideL2InGameWeb("nshop", "");
			return;
			break;
		case 11:
			RequestOpenWndWithoutNPC(OPEN_PREMIUM_MANAGER);
			return;
			break;
		case 7:
			HandleMysteriousBtn();
			return;
		case 1:
			ElementalSpiritWnd(GetScript("ElementalSpiritWnd"))._API_RequestElementalSpiritInfo(true);
			break;
		case 17:
		case 18:
		case 24:
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(itemDatas[Index].WindowName);
			return;
		case 26:
			ShowIngameShop();
			return;
		case 20:
			EventFestivalWndWindowTooltip(GetScript("EventFestivalWndWindowTooltip")).OpenMainWindow();
			return;
			break;
		case 4:
			RequestOpenWndWithoutNPC(OPEN_EINHASAD_COIN_HTML);
			return;
		case 14:
			OpenCollectionSelectedItem();
			return;
		case 23:
			SteadyBoxWnd(GetScript("SteadyBoxWnd")).API_C_EX_STEADY_BOX_LOAD();
			return;
		case 6:
			if(getInstanceUIData().GetIsClassicServer())
			{
				TimeZoneWnd(GetScript("TimeZoneWnd")).ShowBySideBar();
				return;
			}
			break;
		case 5:
			Class'Interface.RelicWnd'.static.Inst().OpenWindow();
			return;
		case 19:
			if(IsPlayerOnWorldRaidServer())
			{
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
				return;
			}
			if(!GetWindowHandle("MarbleGameWnd").IsShowWindow())
			{
				API_C_EX_MABLE_GAME_OPEN();
			}
			else
			{
				GetWindowHandle("MarbleGameWnd").HideWindow();
			}
			return;
		default:
			break;
	}
	targetWindow = GetTargetWindowByIndex(Index);
	if((targetWindow == emptyWindow))
	{
		return;
	}
	if(targetWindow.IsShowWindow())
	{
		return;
	}
	targetWindow.ShowWindow();
	targetWindow.SetFocus();
	return;
}

function setMakegfxWindowTooltip(int Type, string Str)
{
	if((Type == 17))
	{
		GetWindowByIndex(17).SetTooltipCustomType(MakeTooltipMultiText(GetSystemString(13105), getInstanceL2Util().White, "", true, MakeFullSystemMsg(GetSystemMessage(13070), (Str $ GetSystemString(537))), getInstanceL2Util().White, "", true, , , , ));
	}
	else if((Type == 18))
	{
		GetWindowByIndex(18).SetTooltipCustomType(MakeTooltipSimpleText(Str));
	}
	return;
}

function ShowWindowTooltip(int Index)
{
	local WindowHandle windowTooltip;

	windowTooltip = GetWindowHandle((itemDatas[Index].WindowName $ "WindowTooltip"));
	windowTooltip.SetAnchor(((m_Windowname $ ".BTN") $ itemDatas[Index].WindowName), "BottomLeft", "BottomRight", 0, 1);
	if(CheckTooltipLeftArea(windowTooltip))
	{
		windowTooltip.SetAnchor(((m_Windowname $ ".BTN") $ itemDatas[Index].WindowName), "BottomRight", "BottomLeft", 0, 1);
	}
	windowTooltip.ShowWindow();
	windowTooltip.SetFocus();
	return;
}

function HideWindowTooltip(int Index)
{
	local WindowHandle windowTooltip;

	windowTooltip = GetWindowHandle((itemDatas[Index].WindowName $ "WindowTooltip"));
	windowTooltip.HideWindow();
	return;
}

function bool CheckTooltipLeftArea(WindowHandle targetWindowTooltip)
{
	local Rect windowTooltipRect;

	windowTooltipRect = targetWindowTooltip.GetRect();
	if((windowTooltipRect.nX < 0))
	{
		return true;
	}
	return false;
}

function SetLocalization()
{
	local int nShowUsePrimeShop, nUseVipInfoWnd;
	local string strShopType, VipinfoServerType;

	if((int(GetLanguage()) == 0))
	{
		return;
	}
	if(getInstanceUIData().GetIsClassicServer())
	{
		if(IsAdenServer())
		{
			VipinfoServerType = "UseVipInfoWndAden";
			strShopType = "UseAdenPrimeShop";
		}
		else
		{
			VipinfoServerType = "UseVipInfoWndClassic";
			strShopType = "UseClassicPrimeShop";
		}
	}
	else
	{
		VipinfoServerType = "UseVipInfoWnd";
		strShopType = "UsePrimeShop";
	}
	switch(GetLanguage())
	{
		case LANG_Russia:
		case LANG_Euro:
			SetIconTexture(TYPE_VITAMANMANAGER, "L2UI_NewTex.SideBar.SideBar_KookaburraIcon");
			break;
		default:
			break;
	}
	GetINIBool("VipSystem", VipinfoServerType, nUseVipInfoWnd, "L2.ini");
	SetWindowShowHideByIndex(24, (nUseVipInfoWnd > 0));
	GetINIBool("PrimeShop", strShopType, nShowUsePrimeShop, "L2.ini");
	SetWindowShowHideByIndex(26, (nShowUsePrimeShop > 0));
	return;
}

function ShowIngameShop()
{
	if((getInstanceUIData().GetIsClassicServer() && !IsAdenServer()))
	{
		toggleWindow("IngameShopWnd", true, true);
	}
	else
	{
		ExecuteEvent(9010);
	}
	return;
}

function RT_S_EX_HOMUNCULUS_SIDEBAR()
{
	local UIPacket._S_EX_HOMUNCULUS_SIDEBAR packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_HOMUNCULUS_SIDEBAR(packet))
	{
		return;
	}
	SetHomnuCulusTooltip(packet.nID, packet.nLevel, packet.nType);
	return;
}

function SetHomnuCulusTooltip(int nID, int Level, int Type)
{
	local string NpcName, ToolTipString;
	local HomunculusAPI.HomunculusNpcData npcData;
	local HomunculusWnd HomunculusWndScript;
	local Color C;

	HomunculusWndScript = HomunculusWnd(GetScript("HomunculusWNd"));
	if((nID <= 0))
	{
		ToolTipString = ((GetSystemString(14671) $ ":") @ GetSystemString(27));
		C = getInstanceL2Util().Gray;
	}
	else
	{
		npcData = HomunculusWndScript.GetHomunculusNpcData(nID);
		NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(npcData.NpcID);
		ToolTipString = ((((((((GetSystemString(14671) $ ":") @ GetSystemString(88)) $ ".") $ string(Level)) @ NpcName) $ "(") $ HomunculusWndScript.GetGradeString(Type)) $ ")");
		C = getInstanceL2Util().Yellow;
	}
	GetWindowByIndex(13).SetTooltipCustomType(MakeTooltipMultiText(GetSystemString(13343), getInstanceL2Util().White, "", true, ToolTipString, C, "", true));
	return;
}

function HandleCuriousHouse(string a_Param)
{
	local int HouseState;
	local AnimTextureHandle BgCircle_Ani;

	ParseInt(a_Param, "State", HouseState);
	GetWindowByIndex(7).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(2812)));
	switch(HouseState)
	{
		case 0:
		case 1:
			BgCircle_Ani = GetAnimTextureHandle((m_Windowname $ ".BtnMysteriousMansionWnd.BgCircle_Ani"));
			BgCircle_Ani.Stop();
			SetWindowShowHideByIndex(7, false);
			SetAlarmOnOff(7, false);
			break;
		case 2:
			AddSystemMessage(3732);
			SetEnableItem(TYPE_MYSTERIOUSHOUSE);
			SetWindowShowHideByIndex(7, true);
			PlayMainEffectByIndex(7);
			SetAlarmOnOff(7, true);
			BgCircle_Ani = GetAnimTextureHandle((m_Windowname $ ".BtnMysteriousMansionWnd.BgCircle_Ani"));
			BgCircle_Ani.SetLoopCount(9999999);
			BgCircle_Ani.Play();
			BgCircle_Ani.ShowWindow();
			break;
		case 3:
			BgCircle_Ani = GetAnimTextureHandle((m_Windowname $ ".BtnMysteriousMansionWnd.BgCircle_Ani"));
			BgCircle_Ani.Stop();
			BgCircle_Ani.HideWindow();
			SetDisableItem(TYPE_MYSTERIOUSHOUSE);
			break;
		default:
			break;
	}
	return;
}

function HandleMysteriousBtn()
{
	DialogSetID(0);
	DialogShow(DialogModalType_Modal, DialogType_OKCancel, GetSystemMessage(3783));
	DialogMoveToCursor();
	return;
}

function API_C_EX_MABLE_GAME_OPEN()
{
	local array<byte> stream;

	Class'Interface.UIPacket'.static.RequestUIPacket(651, stream);
	Debug("---> C_EX_MABLE_GAME_OPEN");
	return;
}

function ParsePacket_S_EX_MABLE_GAME_UI_LAUNCHER()
{
	local UIPacket._S_EX_MABLE_GAME_UI_LAUNCHER packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_MABLE_GAME_UI_LAUNCHER(packet))
	{
		return;
	}
	if((int(packet.bActivate) > 0))
	{
		SetWindowShowHideByIndex(19, true);
	}
	else
	{
		SetWindowShowHideByIndex(19, false);
	}
	return;
}

function showHideL2InGameWeb(string Category, string Message)
{
	local string strParam;
	local BR_ChinaShop brChinaShopScript;

	if((int(GetLanguage()) == 0))
	{
		ParamAdd(strParam, "Category", Category);
		ParamAdd(strParam, "Message", "");
		ExecuteEvent(10120, strParam);
	}
	else
	{
		brChinaShopScript = BR_ChinaShop(GetScript("BR_ChinaShop"));
		brChinaShopScript.OnShow();
	}
	return;
}

function OpenCollectionSelectedItem()
{
	local CollectionSystem collectionSystemScript;

	collectionSystemScript = CollectionSystem(GetScript("collectionSystem"));
	collectionSystemScript.API_C_EX_COLLECTION_OPEN_UI();
	return;
}

function CheckWorldRanking()
{
	if((IsAdenServer() && IsPlayerOnWorldRaidServer()))
	{
		SetIconTexture(TYPE_RANKING, "L2UI_NewTex.SideBar.SideBar_WorldRankingIcon");
	}
	else
	{
		SetIconTexture(TYPE_RANKING, "L2UI_NewTex.SideBar.SideBar_RankingIcon");
	}
	return;
}

defaultproperties
{
	m_Windowname="SideBar"
}
