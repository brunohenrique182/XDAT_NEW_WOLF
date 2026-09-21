class PayBackWnd extends UICommonAPI;

const TIMER_CLICK = 69901;
const TIMER_DELAYC = 3000;

struct PayBackItemInfo
{
	var int EventIDType;
	var int SetIndex;
	var int Requirement;
	var int Received;
	var int RewardItemCount;
	var array<int> RewardItemClassId;
	var array<int> RewardItemAmount;
};

var WindowHandle Me;
var WindowHandle disableWnd;
var TextBoxHandle Disable_Txt;
var WindowHandle PayBackTabWnd;
var ButtonHandle PayBackHelp_Btn;
var ButtonHandle PayBackMyCostRefresh_Btn;
var ItemWindowHandle PayBackItemWindow;
var TextBoxHandle PayBackDesc_Txt;
var TextBoxHandle PayBackTitle_Txt;
var TextBoxHandle PayBackMyCostTitle_Txt;
var TextBoxHandle PayBackMyCostNum_Txt;
var TextBoxHandle Complet_text;
var string m_Windowname;
var L2Util util;
var array<PayBackItemInfo> itemListArray;
var int ConsumedItemAmount;

function OnRegisterEvent()
{
	RegisterEvent(11140);
	RegisterEvent(11141);
	RegisterEvent(11142);
	RegisterEvent(11143);
	RegisterEvent(1710);
	RegisterEvent(1720);
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
	Me = GetWindowHandle(m_Windowname);
	disableWnd = GetWindowHandle("PayBackWnd.DisableWnd");
	Disable_Txt = GetTextBoxHandle("PayBackWnd.DisableWnd.Disable_Txt");
	PayBackTabWnd = GetWindowHandle("PayBackWnd.PayBackTabWnd");
	PayBackHelp_Btn = GetButtonHandle("PayBackWnd.PayBackTabWnd.PayBackHelp_Btn");
	PayBackMyCostRefresh_Btn = GetButtonHandle("PayBackWnd.PayBackTabWnd.PayBackMyCostRefresh_Btn");
	PayBackItemWindow = GetItemWindowHandle("PayBackWnd.PayBackTabWnd.PayBackItemWindow");
	PayBackDesc_Txt = GetTextBoxHandle("PayBackWnd.PayBackTabWnd.PayBackDesc_Txt");
	PayBackTitle_Txt = GetTextBoxHandle("PayBackWnd.PayBackTabWnd.PayBackTitle_Txt");
	PayBackMyCostTitle_Txt = GetTextBoxHandle("PayBackWnd.PayBackTabWnd.PayBackMyCostTitle_Txt");
	PayBackMyCostNum_Txt = GetTextBoxHandle("PayBackWnd.PayBackTabWnd.PayBackMyCostNum_Txt");
	util = L2Util(GetScript("L2Util"));
	initUI();
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
		case "PayBackHelp_Btn":
			OnPayBackHelp_BtnClick();
			break;
		case "PayBackMyCostRefresh_Btn":
			Me.SetTimer(69901, 3000);
			PayBackMyCostRefresh_Btn.DisableWindow();
			OnPayBackMyCostRefresh_BtnClick();
			break;
		default:
			break;
	}
	return;
}

function OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	local array<string> arr;
	local int Num;

	if((a_ButtonHandle.GetWindowName() == "Reward_Btn"))
	{
		Split(a_ButtonHandle.GetParentWindowName(), "_", arr);
		Num = int(Right(arr[1], 2));
		RequestPaybackGiveReward(itemListArray[Num].EventIDType, itemListArray[Num].SetIndex);
	}
	return;
}

function OnShow()
{
	Me.SetFocus();
	PlayConsoleSound(IFST_WINDOW_OPEN);
	return;
}

function initUI()
{
	local int i;

	i = 0;
	while((i < 10))
	{
		GetWindowHandle((((m_Windowname $ ".PayBack_Contents0") $ string(i)) $ "_Wnd")).HideWindow();
		GetItemWindowHandle((((m_Windowname $ ".PayBack_Contents0") $ string(i)) $ "_Wnd.Contents_ItemWindow")).Clear();
		i++;
	}
	PayBackDesc_Txt.SetText("");
	PayBackMyCostNum_Txt.SetText("");
	PayBackTitle_Txt.SetText("");
	ClearAll();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 11140:
			HandleItemBegin(param);
			break;
		case 11141:
			HandleItemList(param);
			break;
		case 11142:
			HandleItemEnd(param);
			break;
		case 11143:
			Debug(("--- EV_PaybackGiveReward : " @ param));
			RewardComplete(param);
			break;
		case 1710:
			break;
		case 1720:
			break;
		default:
			break;
	}
	return;
}

function HandleItemBegin(string param)
{
	local ItemInfo ItemInfo;
	local int ConsumedItemClassID;
	local string Str;
	local int EventEndYear, EventEndMonth, EventEndDay, EventEndHour;

	initUI();
	ParseInt(param, "ConsumedItemClassID", ConsumedItemClassID);
	ParseInt(param, "ConsumedItemAmount", ConsumedItemAmount);
	ParseInt(param, "EventEndYear", EventEndYear);
	ParseInt(param, "EventEndMonth", EventEndMonth);
	ParseInt(param, "EventEndDay", EventEndDay);
	ParseInt(param, "EventEndHour", EventEndHour);
	ItemInfo = GetItemInfoByClassID(ConsumedItemClassID);
	PayBackItemWindow.Clear();
	PayBackItemWindow.AddItem(ItemInfo);
	PayBackItemWindow.SetTooltipType("Inventory");
	PayBackTitle_Txt.SetText(ItemInfo.Name);
	Str = MakeFullSystemMsg(GetSystemMessage(2201), string(EventEndYear), string(EventEndMonth), string(EventEndDay));
	Str = (Str @ MakeFullSystemMsg(GetSystemMessage(2204), string(EventEndHour)));
	PayBackDesc_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(5261), Str));
	PayBackMyCostNum_Txt.SetText(string(ConsumedItemAmount));
	return;
}

function HandleItemList(string param)
{
	local PayBackItemInfo _limitShopItemInfo;
	local int i;

	ParseInt(param, "EventIDType", _limitShopItemInfo.EventIDType);
	ParseInt(param, "SetIndex", _limitShopItemInfo.SetIndex);
	ParseInt(param, "Requirement", _limitShopItemInfo.Requirement);
	ParseInt(param, "Received", _limitShopItemInfo.Received);
	ParseInt(param, "RewardItemCount", _limitShopItemInfo.RewardItemCount);
	_limitShopItemInfo.RewardItemClassId.Length = _limitShopItemInfo.RewardItemCount;
	_limitShopItemInfo.RewardItemAmount.Length = _limitShopItemInfo.RewardItemCount;
	i = 0;
	while((i < _limitShopItemInfo.RewardItemCount))
	{
		ParseInt(param, ("RewardItemClassId_" $ string(i)), _limitShopItemInfo.RewardItemClassId[i]);
		ParseInt(param, ("RewardItemAmount_" $ string(i)), _limitShopItemInfo.RewardItemAmount[i]);
		i++;
	}
	itemListArray.Insert(itemListArray.Length, 1);
	itemListArray[(itemListArray.Length - 1)] = _limitShopItemInfo;
	return;
}

function HandleItemEnd(string param)
{
	if((itemListArray.Length == 0))
	{
		PayBackDesc_Txt.SetText("");
		PayBackMyCostNum_Txt.SetText("");
		PayBackTitle_Txt.SetText("");
		disableWnd.ShowWindow();
	}
	else
	{
		listAddItem();
		disableWnd.HideWindow();
	}
	Me.ShowWindow();
	return;
}

function listAddItem()
{
	local int i, j;
	local WindowHandle wnd;
	local ItemInfo Info;

	i = 0;
	while((i < itemListArray.Length))
	{
		wnd = GetWindowHandle((((m_Windowname $ ".PayBack_Contents0") $ string(i)) $ "_Wnd"));
		wnd.ShowWindow();
		GetTextBoxHandle((wnd.GetWindowName() $ ".Contents_Name_text")).SetText(MakeFullSystemMsg(GetSystemMessage(5263), string(itemListArray[i].Requirement)));
		if((itemListArray[i].Received == 1))
		{
			GetTextureHandle((wnd.GetWindowName() $ ".ContentsDisable_texture")).ShowWindow();
			GetStatusBarHandle((wnd.GetWindowName() $ ".Completegage_statusbar")).HideWindow();
			GetButtonHandle((wnd.GetWindowName() $ ".Reward_Btn")).HideWindow();
			GetTextureHandle((wnd.GetWindowName() $ ".Complet_text")).ShowWindow();
		}
		else
		{
			GetTextureHandle((wnd.GetWindowName() $ ".Complet_text")).HideWindow();
			GetTextureHandle((wnd.GetWindowName() $ ".ContentsDisable_texture")).HideWindow();
			if((ConsumedItemAmount >= itemListArray[i].Requirement))
			{
				GetButtonHandle((wnd.GetWindowName() $ ".Reward_Btn")).ShowWindow();
				GetStatusBarHandle((wnd.GetWindowName() $ ".Completegage_statusbar")).HideWindow();
			}
			else
			{
				GetButtonHandle((wnd.GetWindowName() $ ".Reward_Btn")).HideWindow();
				GetStatusBarHandle((wnd.GetWindowName() $ ".Completegage_statusbar")).ShowWindow();
				GetStatusBarHandle((wnd.GetWindowName() $ ".Completegage_statusbar")).SetPoint(INT64(ConsumedItemAmount), INT64(itemListArray[i].Requirement));
			}
		}
		j = 0;
		while((j < itemListArray[i].RewardItemCount))
		{
			Info = GetItemInfoByClassID(itemListArray[i].RewardItemClassId[j]);
			Info.ItemNum = INT64(itemListArray[i].RewardItemAmount[j]);
			SetShowItemCount(Info);
			GetItemWindowHandle((wnd.GetWindowName() $ ".Contents_ItemWindow")).AddItem(Info);
			GetItemWindowHandle((wnd.GetWindowName() $ ".Contents_ItemWindow")).SetTooltipType("Inventory");
			j++;
		}
		i++;
	}
	return;
}

function RewardComplete(string param)
{
	local int Result;

	ParseInt(param, "Result", Result);
	if((Result == 0))
	{
	}
	ListRefresh();
	return;
}

function OnPayBackHelp_BtnClick()
{
	RequestOpenWndWithoutNPC(OPEN_PAYBACK_HELP_HTML);
	return;
}

function OnPayBackMyCostRefresh_BtnClick()
{
	ListRefresh();
	return;
}

function ListRefresh()
{
	RequestPaybackList(1);
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 69901))
	{
		PayBackMyCostRefresh_Btn.EnableWindow();
		Me.KillTimer(69901);
	}
	return;
}

function ClearAll()
{
	itemListArray.Remove(0, itemListArray.Length);
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="PayBackWnd"
}
