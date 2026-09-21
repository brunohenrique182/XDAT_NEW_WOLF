class EventFestivalWndWindowTooltip extends UICommonAPI;

const TIMER_ID = 1010122;

var string m_Windowname;
var WindowHandle Me;
var TextBoxHandle TimeNumberText;
var TextBoxHandle TimeInfoText;
var int FestivalID;
var int FestivalEndTime;
var TextureHandle FestivalProgressIcon;
var TextureHandle FestivalDisable;
var int newFestivalID;
var EventFestivalWnd EventFestivalWndScript;
var SideBar SideBarScript;
var int nRemainItemTotalNum;

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	TimeInfoText = GetTextBoxHandle((m_Windowname $ ".TimeInfoText"));
	FestivalProgressIcon = GetTextureHandle((m_Windowname $ ".FestivalInnerWnd.FestivalProgressIcon"));
	TimeNumberText = GetTextBoxHandle((m_Windowname $ ".FestivalInnerWnd.TimeNumberText"));
	FestivalDisable = GetTextureHandle((m_Windowname $ ".FestivalInnerWnd.FestivalDisable"));
	newFestivalID = -1;
	SideBarScript = SideBar(GetScript("SideBar"));
	GetHandleItemWindowItem(0).SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
	GetHandleItemWindowItem(1).SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
	GetHandleItemWindowItem(2).SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
	EventFestivalWndScript = EventFestivalWnd(GetScript("EventFestivalWnd"));
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(20280);
	RegisterEvent(40);
	RegisterEvent(10140);
	return;
}

function OnLoad()
{
	Initialize();
	return;
}

function OnShow()
{
	HandleOnShow();
	return;
}

function OnHide()
{
	HandleOnHide();
	return;
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case TimerID:
			FestivalEndTime = (FestivalEndTime - 1);
			if((FestivalEndTime <= 0))
			{
				FestivalEndTime = 0;
				Me.KillTimer(1010122);
			}
			TimeNumberText.SetText(GetSecToTimeStr(FestivalEndTime));
			EventFestivalWndScript.UpdateTime();
			break;
		default:
			break;
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 10140:
			SideBarScript.SetWindowShowHideByIndex(20, false);
			GetWindowHandle("EventFestivalWnd").HideWindow();
		case 40:
			Me.KillTimer(1010122);
			DisableAllItemWindow();
			newFestivalID = -1;
			break;
		case 20280:
			if(IsPlayerOnWorldRaidServer())
			{
				return;
			}
			SetFestivalTopItemInfo(param);
			break;
		default:
			break;
	}
	return;
}

function CheckFestavalID(int tmpFestavalID, int nIsUseFestival)
{
	switch(nIsUseFestival)
	{
		case 0:
			Me.HideWindow();
			SideBarScript.SetWindowShowHideByIndex(20, false);
			SideBarScript._DeSpawnEffect(20);
			GetWindowHandle("EventFestivalWnd").HideWindow();
			break;
		case 1:
			SideBarScript.SetWindowShowHideByIndex(20, true);
			if((newFestivalID != tmpFestavalID))
			{
				SideBarScript._SpawnEffect(20, "LineageEffect2.ui_star_circle");
			}
			GotoState('StateActive');
			break;
		case 2:
			SideBarScript.SetWindowShowHideByIndex(20, true);
			SideBarScript._DeSpawnEffect(20);
			GotoState('StateDeActive');
			GetWindowHandle("EventFestivalWnd").HideWindow();
			if((nRemainItemTotalNum == 0))
			{
				TimeInfoText.SetText((GetSystemString(13958) $ ":"));
			}
			else
			{
				TimeInfoText.SetText((GetSystemString(13046) $ ":"));
			}
		default:
			break;
	}
	newFestivalID = tmpFestavalID;
	return;
}

function int getFestivalEndTime()
{
	return FestivalEndTime;
}

function SetFestivalTopItemInfo(string param)
{
	local int ListCount, tmpFestavalID, Grade, ItemID, RemainItemNum, MAXITEMNUM, i, nIsUseFestival;

	ParseInt(param, "IsUseFestival", nIsUseFestival);
	ParseInt(param, "FestivalID", tmpFestavalID);
	ParseInt(param, "ListCount", ListCount);
	ParseInt(param, "FestivalEndTime", FestivalEndTime);
	nRemainItemTotalNum = 0;
	i = 0;
	while((i < ListCount))
	{
		ParseInt(param, ("Grade" $ string(i)), Grade);
		ParseInt(param, ("itemID" $ string(i)), ItemID);
		ParseInt(param, ("MaxItemNum" $ string(i)), MAXITEMNUM);
		ParseInt(param, ("RemainItemNum" $ string(i)), RemainItemNum);
		SetItemInfoByIndex(i, ItemID, RemainItemNum, MAXITEMNUM);
		nRemainItemTotalNum = (nRemainItemTotalNum + RemainItemNum);
		i++;
	}
	CheckFestavalID(tmpFestavalID, nIsUseFestival);
	Me.KillTimer(1010122);
	Me.SetTimer(1010122, 1000);
	return;
}

function SetItemInfoByIndex(int Index, int ItemID, int RemainItemNum, int MAXITEMNUM)
{
	local ItemInfo Info;
	local ItemWindowHandle iWindowHandle;
	local TextBoxHandle textBoxItemName, textBoxItemNum;

	Info = GetItemInfoByClassID(ItemID);
	iWindowHandle = GetHandleItemWindowItem(Index);
	textBoxItemName = GetHandleTextBoxHandleItemName(Index);
	textBoxItemNum = GetHandleTextBoxhandleItemNum(Index);
	iWindowHandle.Clear();
	iWindowHandle.AddItem(Info);
	textBoxItemName.SetText(makeShortStringByPixel(Info.Name, 157, ".."));
	textBoxItemNum.SetText(((string(RemainItemNum) $ "/") $ string(MAXITEMNUM)));
	SoldOutItemwindow(Index, (RemainItemNum == 0));
	return;
}

function HandleOnShow()
{
	SideBarScript._DeSpawnEffect(20);
	return;
}

function HandleOnHide()
{
	return;
}

function ItemWindowHandle GetHandleItemWindowItem(int Index)
{
	return GetItemWindowHandle((((m_Windowname $ ".itemGroup") $ string(Index)) $ ".GoldItemWindow"));
}

function TextBoxHandle GetHandleTextBoxHandleItemName(int Index)
{
	return GetTextBoxHandle((((m_Windowname $ ".itemGroup") $ string(Index)) $ ".GoldText"));
}

function TextBoxHandle GetHandleTextBoxhandleItemNum(int Index)
{
	return GetTextBoxHandle((((m_Windowname $ ".itemGroup") $ string(Index)) $ ".GoldNumberText"));
}

function TextureHandle GetHandleTextureSoldOut(int Index)
{
	return GetTextureHandle((((m_Windowname $ ".itemGroup") $ string(Index)) $ ".SoldOutImg"));
}

function string GetSecToTimeStr(int Sec)
{
	local int m_timeDay, m_timeHour, m_timeMin, total_m, total_h;

	total_m = (Sec / 60);
	total_h = (total_m / 60);
	m_timeDay = (total_h / 24);
	m_timeHour = int((float(total_h) % 24.0000000));
	m_timeMin = int((float(total_m) % 60.0000000));
	if((m_timeDay > 0))
	{
		return MakeFullSystemMsg(GetSystemMessage(4466), string(m_timeDay), string(m_timeHour), string(m_timeMin));
	}
	else if((m_timeHour > 0))
	{
		return MakeFullSystemMsg(GetSystemMessage(3304), string(m_timeHour), string(m_timeMin));
	}
	else if((m_timeMin > 0))
	{
		return MakeFullSystemMsg(GetSystemMessage(3390), string(m_timeMin));
	}
	else
	{
		return MakeFullSystemMsg(GetSystemMessage(4360), "1");
	}
	return "00:00:00";
}

function DisableAllItemWindow()
{
	DisableItemWindow(0);
	DisableItemWindow(1);
	DisableItemWindow(2);
	return;
}

function SoldOutItemwindow(int Index, bool isSoldout)
{
	if(isSoldout)
	{
		DisableItemWindow(Index);
		GetHandleTextureSoldOut(Index).ShowWindow();
	}
	else
	{
		EnableItemWindow(Index);
		GetHandleTextureSoldOut(Index).HideWindow();
	}
	return;
}

function DisableItemWindow(int Index)
{
	GetHandleItemWindowItem(Index).DisableWindow();
	GetHandleTextBoxHandleItemName(Index).SetTextColor(getInstanceL2Util().Gray);
	GetHandleTextBoxhandleItemNum(Index).SetTextColor(getInstanceL2Util().Gray);
	return;
}

function EnableItemWindow(int Index)
{
	GetHandleItemWindowItem(Index).EnableWindow();
	GetHandleTextBoxHandleItemName(Index).SetTextColor(getInstanceL2Util().White);
	GetHandleTextBoxhandleItemNum(Index).SetTextColor(getInstanceL2Util().Yellow);
	return;
}

function OpenMainWindow()
{
	return;
}

auto state StateActive
{
	function BeginState()
	{
		FestivalDisable.HideWindow();
		TimeInfoText.SetText((GetSystemString(1108) $ ":"));
		TimeNumberText.SetText(GetSecToTimeStr(FestivalEndTime));
		TimeNumberText.SetTooltipText(GetSystemString(1108));
		TimeInfoText.SetTextColor(GetColor(174, 152, 121, 255));
		TimeNumberText.SetTextColor(GetColor(174, 152, 121, 255));
		FestivalProgressIcon.SetTexture("L2UI_CT1.OlympiadWnd.ONICON");
		Debug("State StateActive");
		return;
	}

	function EndState()
	{
		return;
	}

	function OpenMainWindow()
	{
		EventFestivalWndScript.Me.ShowWindow();
		return;
	}
}

state StateDeActive
{
	function BeginState()
	{
		FestivalDisable.ShowWindow();
		TimeNumberText.SetTooltipText(GetSystemString(13046));
		TimeNumberText.SetText(GetSecToTimeStr(FestivalEndTime));
		TimeInfoText.SetTextColor(getInstanceL2Util().Gray);
		TimeNumberText.SetTextColor(getInstanceL2Util().Gray);
		FestivalProgressIcon.SetTexture("L2UI_CT1.OlympiadWnd.OffICON");
		Debug("State StateDeActive");
		return;
	}

	function EndState()
	{
		return;
	}

	function OpenMainWindow()
	{
		EventFestivalWndScript.Me.HideWindow();
		AddSystemMessage(13287);
		return;
	}
}
