class SteadyBoxWnd extends UICommonAPI
	dependson(UIPacket);

const TIMEID_STEADY = 4424;
const TIME_STEADY = 1000;
const TIMER_CLICK = 99908;
const TIMER_DELAYC = 3000;
const SLOT_MAX = 4;

enum E_STEADY_BOX_GOAL_TYPE
{
	E_STEADY_BOX_GOAL_TYPE_NONE,    // 0
	E_STEADY_BOX_GOAL_TYPE_ANY,     // 1
	E_STEADY_BOX_GOAL_TYPE_PVP,     // 2
	E_STEADY_BOX_GOAL_TYPE_NPC,     // 3
	E_STEADY_BOX_GOAL_TYPE_MAX      // 4
};

enum E_STEADY_BOX_STATE
{
	ESBS_CLOSED_SLOT,               // 0
	ESBS_EMPTY_SLOT,                // 1
	ESBS_WAITING_BOX,               // 2
	ESBS_OPENING_BOX,               // 3
	ESBS_REWARD,                    // 4
	ESBS_LOCK,                      // 5
	ESBS_INIT                       // 6
};

enum TimerCheckType
{
	TCT_STEADYBOX,                  // 0
	TCT_MAX                         // 1
};

enum BoxState
{
	empty                           // 0
};

enum E_POPUP_TYPE
{
	SLOT_OPEN,                      // 0
	BOX_OPEN,                       // 1
	BOX_TIME_OPEN,                  // 2
	BOX_TIME_OPEN_PRICE             // 3
};

struct slotInfo
{
	var int nSlotID;
	var int nSlotState;
	var int nSlotStateBefore;
	var int nBoxType;
};

var WindowHandle Me;
var WindowHandle Result_wnd;
var WindowHandle Dialog_Wnd;
var ItemWindowHandle Item_ItemWindow;
var TextBoxHandle ItemName_Txt;
var TextBoxHandle ItemNum_txt;
var TextBoxHandle ItemNum_txts;
var ButtonHandle OKButton;
var TextureHandle Charge_GroupBox_Tex0;
var TextureHandle Itemslot_tex;
var ButtonHandle ReFresh_btn;
var ItemWindowHandle ResultItem_itemwindow;
var TextBoxHandle ResultItem_txt;
var TextBoxHandle DescriptionTextBox;
var SideBar SideBarScript;
var string m_Windowname;
var string m_RewardGroupWnd;
var string m_WindowNameRewardGroupWnd;
var int maxPointConstant;
var int maxPointEvent;
var bool slotOpenCall;
var int lastEmptySlot;
var int popuptype;
var int selectSlot;
var int EndTimesSlot;
var int EndTimes;
var int eventZoneType;
var array<slotInfo> slotInfos;
var array<UIPacket._SteadyBoxPrice> boxPrice;
var array<UIPacket._SteadyBoxPrice> boxTimePrice;

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	Result_wnd = GetWindowHandle((m_Windowname $ ".Result_wnd"));
	Dialog_Wnd = GetWindowHandle((m_Windowname $ ".Dialog_wnd"));
	Item_ItemWindow = GetItemWindowHandle((m_Windowname $ ".Dialog_wnd.Item_itemwindow"));
	ItemName_Txt = GetTextBoxHandle((m_Windowname $ ".Dialog_wnd.ItemName_txt"));
	ItemNum_txt = GetTextBoxHandle((m_Windowname $ ".Dialog_wnd.ItemNum_txt"));
	ItemNum_txts = GetTextBoxHandle((m_Windowname $ ".Dialog_wnd.ItemNum_txts"));
	OKButton = GetButtonHandle((m_Windowname $ ".Dialog_wnd.OkButton"));
	Charge_GroupBox_Tex0 = GetTextureHandle((m_Windowname $ ".Dialog_wnd.Charge_GroupBox_Tex0"));
	Itemslot_tex = GetTextureHandle((m_Windowname $ ".Dialog_wnd.Itemslot_tex"));
	ResultItem_itemwindow = GetItemWindowHandle((m_Windowname $ ".Result_wnd.ResultConfirm_Wnd.ResultItem_itemwindow"));
	ResultItem_txt = GetTextBoxHandle((m_Windowname $ ".Result_wnd.ResultConfirm_Wnd.ResultItem_txt"));
	DescriptionTextBox = GetTextBoxHandle((m_Windowname $ ".Result_wnd.ResultConfirm_Wnd.ResultItem_txt"));
	ReFresh_btn = GetButtonHandle((m_Windowname $ ".Refresh_BTN"));
	m_WindowNameRewardGroupWnd = (m_Windowname $ ".RewardGroup_Wnd");
	SideBarScript = SideBar(GetScript("sidebar"));
	slotInfos.Length = 4;
	Clear();
	return;
}

function Clear()
{
	local int i;

	EndTimesSlot = -1;
	slotOpenCall = false;
	i = 0;
	while((i < slotInfos.Length))
	{
		slotInfos[i].nSlotID = i;
		slotInfos[i].nSlotState = 6;
		slotInfos[i].nSlotStateBefore = 6;
		slotInfos[i].nBoxType = 0;
		GetSteadyBoxBtn(slotInfos[i].nSlotID).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(5206)));
		GetRewardTimeTxt(slotInfos[i].nSlotID).SetTextColor(getInstanceL2Util().White);
		GetRewardTimeTxt(slotInfos[i].nSlotID).SetText(GetSystemString(3587));
		i++;
	}
	Dialog_Wnd.HideWindow();
	return;
}

function string GetSteadyBoxPath(int Index)
{
	return (((m_WindowNameRewardGroupWnd $ ".SteadyBox") $ Int2Str(Index)) $ "_wnd");
}

function TextBoxHandle GetRewardTimeTxt(int Index)
{
	return GetTextBoxHandle((GetSteadyBoxPath(Index) $ ".RewardTime_Txt"));
}

function TextureHandle GetTextureBox(int Index)
{
	return GetTextureHandle((GetSteadyBoxPath(Index) $ ".SetTextureBOX_tex"));
}

function EffectViewportWndHandle GetBoxEffect(int Index)
{
	return GetEffectViewportWndHandle((GetSteadyBoxPath(Index) $ ".Box_EffectViewport"));
}

function ButtonHandle GetSteadyBoxBtn(int SlotIndex)
{
	return GetButtonHandle((GetSteadyBoxPath(SlotIndex) $ ".SteadyBox_BTN"));
}

function EffectViewportWndHandle GetResultEffect()
{
	return GetEffectViewportWndHandle((m_Windowname $ ".Result_wnd.Result_EffectViewport"));
}

function string GetSteadyBoxTexture(int SlotIndex, int boxtype)
{
	local slotInfo sInfo;

	sInfo = slotInfos[SlotIndex];
	switch(sInfo.nSlotState)
	{
		case 0:
		case 5:
			return "L2UI_CT1.EmptyBtn";
		case 1:
			return "L2UI_EPIC.SteadyBoxWnd.SteadyBoxSlot_Plus";
		case 2:
		case 3:
			return (("L2UI_EPIC.SteadyBoxWnd.SteadyBoxSlot_img" $ GetBoxType(boxtype)) $ "_Close");
		case 4:
			return (("L2UI_EPIC.SteadyBoxWnd.SteadyBoxSlot_img" $ GetBoxType(boxtype)) $ "_Open");
		default:
	}
}

function string GetBoxType(int boxtype)
{
	switch(boxtype)
	{
		case 1:
			return "03";
		case 2:
			return "02";
		case 3:
			return "01";
		default:
	}
}

function string GetGoalGroupPath(int SlotIndex)
{
	return (((m_Windowname $ ".GoalGroup") $ Int2Str(SlotIndex)) $ "_Wnd");
}

function ButtonHandle GetGoalHelp_Btn(int Index)
{
	return GetButtonHandle((GetGoalGroupPath(Index) $ ".GoalHelp_btn"));
}

function TextBoxHandle GetHuntingType_tex(int Index)
{
	return GetTextBoxHandle((GetGoalGroupPath(Index) $ ".HuntingType_tex"));
}

function TextBoxHandle GetHuntingZone_tex(int Index)
{
	return GetTextBoxHandle((GetGoalGroupPath(Index) $ ".HuntingZone_tex"));
}

function StatusBarHandle GetGuage(int Index)
{
	return GetStatusBarHandle((GetGoalGroupPath(Index) $ ".HuntingGauge_statusbar"));
}

function WindowHandle GetMAXWnd(int Index)
{
	return GetWindowHandle((GetGoalGroupPath(Index) $ ".HuntingMaxGauge_Wnd"));
}

function TextureHandle GetDisabletex(int Index)
{
	return GetTextureHandle((GetGoalGroupPath(Index) $ ".Disable_tex"));
}

function bool API_C_EX_STEADY_BOX_LOAD()
{
	local array<byte> stream;
	local UIPacket._C_EX_STEADY_BOX_LOAD packet;

	if(!Class'Interface.UIPacket'.static.Encode_C_EX_STEADY_BOX_LOAD(stream, packet))
	{
		return false;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(678, stream);
}

function bool API_C_EX_TIMER_CHECK()
{
	local array<byte> stream;
	local UIPacket._C_EX_TIMER_CHECK packet;

	packet.nType = 0;
	packet.nIndex = 0;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_TIMER_CHECK(stream, packet))
	{
		return false;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(677, stream);
}

function bool API_C_EX_STEADY_OPEN_SLOT(int Id)
{
	local array<byte> stream;
	local UIPacket._C_EX_STEADY_OPEN_SLOT packet;

	packet.nSlotID = (Id + 1);
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_STEADY_OPEN_SLOT(stream, packet))
	{
		return false;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(679, stream);
}

function bool API_C_EX_STEADY_OPEN_BOX(int Id, INT64 Amount)
{
	local array<byte> stream;
	local UIPacket._C_EX_STEADY_OPEN_BOX packet;

	packet.nSlotID = (Id + 1);
	packet.nAmount = Amount;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_STEADY_OPEN_BOX(stream, packet))
	{
		return false;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(680, stream);
}

function bool API_C_EX_STEADY_GET_REWARD(int Id)
{
	local array<byte> stream;
	local UIPacket._C_EX_STEADY_GET_REWARD packet;

	packet.nSlotID = (Id + 1);
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_STEADY_GET_REWARD(stream, packet))
	{
		return false;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(681, stream);
}

function Handle_S_EX_STEADY_BOX_UI_INIT()
{
	local int i;
	local string type0, type1, title0, desc0, title1, desc1;
	local L2UITime L2UITime;
	local UIPacket._S_EX_STEADY_BOX_UI_INIT packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_STEADY_BOX_UI_INIT(packet))
	{
		return;
	}
	Debug("Handle_S_EX_STEADY_BOX_UI_INIT");
	Debug(("packet.nConstantMaxPoint-->" @ string(packet.nConstantMaxPoint)));
	Debug(("packet.nEventMaxPoint-->" @ string(packet.nEventMaxPoint)));
	Debug(("packet.nEventId-->" @ string(packet.nEventID)));
	Debug(("packet.nEventStartTime-->" @ string(packet.nEventStartTime)));
	Debug(("packet.nEventEndTime-->" @ string(packet.nEventEndTime)));
	SideBarScript.SetWindowShowHideByIndex(23, true);
	GetSteadyBoxString(1, type0, title0, desc0);
	GetDisabletex(0).HideWindow();
	GetGoalHelp_Btn(0).SetTooltipCustomType(MakeTooltipSimpleText(desc0));
	GetHuntingType_tex(0).SetText(type0);
	GetHuntingZone_tex(0).SetText(title0);
	GetGuage(0).SetPoint(INT64(0), INT64(maxPointConstant));
	GetMAXWnd(0).HideWindow();
	GetHuntingType_tex(1).SetTextColor(getInstanceL2Util().Red3);
	maxPointConstant = packet.nConstantMaxPoint;
	maxPointEvent = packet.nEventMaxPoint;
	GetTimeStruct(packet.nEventEndTime, L2UITime);
	eventZoneType = packet.nEventID;
	if((eventZoneType != 0))
	{
		GetDisabletex(1).HideWindow();
		GetSteadyBoxString(packet.nEventID, type1, title1, desc1);
		GetGoalHelp_Btn(1).SetTooltipCustomType(MakeTooltipSimpleText(((desc1 $ "\\n") $ MakeFullSystemMsg(GetSystemMessage(6209), string(L2UITime.nYear), string(L2UITime.nMonth), string(L2UITime.nDay)))));
		GetHuntingType_tex(1).SetText(type1);
		GetHuntingZone_tex(1).SetText(title1);
		GetGuage(1).SetPoint(INT64(0), INT64(maxPointEvent));
		GetMAXWnd(1).HideWindow();
	}
	else
	{
		GetDisabletex(1).ShowWindow();
		GetGoalHelp_Btn(1).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13368)));
		GetHuntingType_tex(1).SetText(GetSystemString(13368));
		GetHuntingZone_tex(1).SetText(GetSystemString(13368));
		GetGuage(1).DisableWindow();
		GetMAXWnd(1).HideWindow();
	}
	Me.SetTimer(4424, 1000);
	boxPrice = packet.vPriceBoxOpen;
	boxTimePrice = packet.vPriceForTime;
	i = 0;
	while((i < packet.vPriceBoxOpen.Length))
	{
		Debug(((("packet.vPriceBoxOpen-->" @ string(i)) @ "->") @ string(packet.vPriceBoxOpen[i].nIndex)));
		Debug(((("packet.vPriceBoxOpen-->" @ string(i)) @ "->") @ string(packet.vPriceBoxOpen[i].nItemType)));
		Debug(((("packet.vPriceBoxOpen-->" @ string(i)) @ "->") @ string(packet.vPriceBoxOpen[i].nAmount)));
		i++;
	}
	i = 0;
	while((i < packet.vPriceForTime.Length))
	{
		Debug(((("packet.vPriceForTime-->" @ string(i)) @ "->") @ string(packet.vPriceForTime[i].nIndex)));
		Debug(((("packet.vPriceForTime-->" @ string(i)) @ "->") @ string(packet.vPriceForTime[i].nItemType)));
		Debug(((("packet.vPriceForTime-->" @ string(i)) @ "->") @ string(packet.vPriceForTime[i].nAmount)));
		i++;
	}
	Debug(("packet.nBoxOpenEndTime-->" @ string(packet.nBoxOpenEndTime)));
	EndTimes = packet.nBoxOpenEndTime;
	return;
}

function Handle_S_EX_TIMER_CHECK()
{
	local UIPacket._S_EX_TIMER_CHECK packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_TIMER_CHECK(packet))
	{
		return;
	}
	Debug("Handle_S_EX_TIMER_CHECK");
	Debug(("packet.nType-->" @ string(packet.nType)));
	Debug(("packet.nIndex-->" @ string(packet.nIndex)));
	Debug(("packet.bFinished-->" @ string(packet.bFinished)));
	Debug(("packet.nCurrentTime-->" @ string(packet.nCurrentTime)));
	Debug(("packet.nEndTime-->" @ string(packet.nEndTime)));
	Debug((((("EndTinmes-->" @ string(EndTimes)) @ " == ") @ "packet.nEndTime - packet.nCurrentTime-->") @ string((packet.nEndTime - packet.nCurrentTime))));
	if((int(packet.bFinished) == 0))
	{
		EndTimes = (packet.nEndTime - packet.nCurrentTime);
	}
	return;
}

function Handle_S_EX_STEADY_ALL_BOX_UPDATE()
{
	local int i;
	local UIPacket._S_EX_STEADY_ALL_BOX_UPDATE packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_STEADY_ALL_BOX_UPDATE(packet))
	{
		return;
	}
	Debug("Handle_S_EX_STEADY_ALL_BOX_UPDATE");
	Debug(("packet.nConstantCurrentPoint-->" @ string(packet.nConstantCurrentPoint)));
	Debug(("packet.nEventGoalCurrentPoint-->" @ string(packet.nEventGoalCurrentPoint)));
	if(!Me.IsShowWindow())
	{
		Me.ShowWindow();
		Me.SetFocus();
	}
	GetGuage(0).SetPoint(INT64(packet.nConstantCurrentPoint), INT64(maxPointConstant));
	if((packet.nConstantCurrentPoint >= maxPointConstant))
	{
		showeffect();
		GetMAXWnd(0).ShowWindow();
		GetGuage(0).HideWindow();
	}
	else
	{
		GetMAXWnd(0).HideWindow();
		GetGuage(0).ShowWindow();
	}
	if((eventZoneType != 0))
	{
		GetGuage(1).SetPoint(INT64(packet.nEventGoalCurrentPoint), INT64(maxPointEvent));
		if((packet.nEventGoalCurrentPoint >= maxPointEvent))
		{
			showeffect();
			GetMAXWnd(1).ShowWindow();
			GetGuage(1).HideWindow();
		}
		else
		{
			GetMAXWnd(1).HideWindow();
			GetGuage(1).ShowWindow();
		}
	}
	EndTimes = packet.nEndTime;
	i = 0;
	while((i < packet.vMySlotList.Length))
	{
		Debug(((("packet.nSlotID-->" @ string(i)) @ "->") @ string((packet.vMySlotList[i].nSlotID - 1))));
		Debug(((("packet.nSlotState-->" @ string(i)) @ "->") @ string(packet.vMySlotList[i].nSlotState)));
		Debug(((("packet.nBoxType-->" @ string(i)) @ "->") @ string(packet.vMySlotList[i].nBoxType)));
		if((packet.vMySlotList[i].nSlotState > -1))
		{
			ChangeSlot((packet.vMySlotList[i].nSlotID - 1), packet.vMySlotList[i].nSlotState, packet.vMySlotList[i].nBoxType);
			i++;
			continue;
		}
		switch(packet.vMySlotList[i].nSlotState)
		{
			case -1:
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4559));
				break;
			case -2:
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13052));
				break;
			case -3:
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(6211));
				break;
			case -4:
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13202));
				break;
			case -5:
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13202));
				break;
			default:
				break;
		}
		i++;
	}
	ChangeSlot(packet.vMySlotList.Length, 0, 0);
	UpdateSlot();
	return;
}

function Handle_S_EX_STEADY_ONE_BOX_UPDATE()
{
	local UIPacket._S_EX_STEADY_ONE_BOX_UPDATE packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_STEADY_ONE_BOX_UPDATE(packet))
	{
		return;
	}
	Debug("Handle_S_EX_STEADY_ONE_BOX_UPDATE");
	GetGuage(0).SetPoint(INT64(packet.nConstantCurrentPoint), INT64(maxPointConstant));
	if((packet.nConstantCurrentPoint >= maxPointConstant))
	{
		showeffect();
		GetMAXWnd(0).ShowWindow();
		GetGuage(0).HideWindow();
	}
	else
	{
		GetMAXWnd(0).HideWindow();
		GetGuage(0).ShowWindow();
	}
	if((eventZoneType != 0))
	{
		GetGuage(1).SetPoint(INT64(packet.nEventGoalCurrentPoint), INT64(maxPointEvent));
		if((packet.nEventGoalCurrentPoint >= maxPointEvent))
		{
			showeffect();
			GetMAXWnd(1).ShowWindow();
			GetGuage(1).HideWindow();
		}
		else
		{
			GetMAXWnd(1).HideWindow();
			GetGuage(1).ShowWindow();
		}
	}
	Debug(("packet.nConstantCurrentPoint->" @ string(packet.nConstantCurrentPoint)));
	Debug(("packet.nEventGoalCurrentPoint->" @ string(packet.nEventGoalCurrentPoint)));
	Debug(("packet.MySlot.nSlotID->" @ string((packet.MySlot.nSlotID - 1))));
	Debug(("packet.MySlot.nSlotState->" @ string(packet.MySlot.nSlotState)));
	Debug(("packet.MySlot.nBoxType->" @ string(packet.MySlot.nBoxType)));
	Debug(("packet.nEndTime->" @ string(packet.nEndTime)));
	EndTimes = packet.nEndTime;
	if((packet.MySlot.nSlotState > -1))
	{
		ChangeSlot((packet.MySlot.nSlotID - 1), packet.MySlot.nSlotState, packet.MySlot.nBoxType);
		if(slotOpenCall)
		{
			if((packet.MySlot.nSlotID < 4))
			{
				ChangeSlot(packet.MySlot.nSlotID, 0, 0);
			}
			slotOpenCall = false;
		}
		UpdateSlotNum((packet.MySlot.nSlotID - 1));
	}
	else
	{
		switch(packet.MySlot.nSlotState)
		{
			case -1:
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4559));
				break;
			case -2:
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13052));
				break;
			case -3:
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(6211));
				break;
			case -4:
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13202));
				break;
			case -5:
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13202));
				break;
			default:
				break;
		}
	}
	return;
}

function Handle_S_EX_STEADY_BOX_REWARD()
{
	local ItemInfo Info;
	local UIPacket._S_EX_STEADY_BOX_REWARD packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_STEADY_BOX_REWARD(packet))
	{
		return;
	}
	Info = GetItemInfoByClassID(packet.nItemType);
	Result_wnd.ShowWindow();
	GetResultEffect().SpawnEffect("LineageEffect2.ui_upgrade_succ");
	Info.Enchanted = packet.nEnchant;
	ResultItem_itemwindow.Clear();
	ResultItem_itemwindow.AddItem(Info);
	ResultItem_txt.SetText(GetItemNameAll(Info));
	Debug("Handle_S_EX_STEADY_BOX_REWARD");
	Debug(("packet.nSlotID->" @ string(packet.nSlotID)));
	Debug(("packet.nItemType->" @ string(packet.nItemType)));
	Debug(("packet.nAmount->" @ string(packet.nAmount)));
	Debug(("packet.nEnchant->" @ string(packet.nEnchant)));
	return;
}

function ChangeSlot(int SlotID, int slotstate, int boxtype)
{
	local int i;

	i = 0;
	while((i < slotInfos.Length))
	{
		if((slotInfos[i].nSlotID == SlotID))
		{
			slotInfos[i].nSlotStateBefore = slotInfos[i].nSlotState;
			Debug(("slotInfos[i].nSlotState--->" @ string(slotInfos[i].nSlotState)));
			Debug(("slotInfos[i].nSlotStateBefore--->" @ string(slotInfos[i].nSlotStateBefore)));
			slotInfos[i].nSlotState = slotstate;
			slotInfos[i].nBoxType = boxtype;
		}
		i++;
	}
	return;
}

function UpdateSlot()
{
	local int i;

	EndTimesSlot = -1;
	i = 0;
	while((i < slotInfos.Length))
	{
		GetSteadyBoxBtn(slotInfos[i].nSlotID).EnableWindow();
		switch(slotInfos[i].nSlotState)
		{
			case 5:
				GetSteadyBoxBtn(slotInfos[i].nSlotID).DisableWindow();
				GetSteadyBoxBtn(slotInfos[i].nSlotID).SetTooltipCustomType(MakeTooltipSimpleText(""));
				GetRewardTimeTxt(slotInfos[i].nSlotID).SetTextColor(getInstanceL2Util().White);
				GetRewardTimeTxt(slotInfos[i].nSlotID).SetText(GetSystemString(3587));
				GetBoxEffect(slotInfos[i].nSlotID).SpawnEffect("");
				break;
			case 3:
				GetSteadyBoxBtn(slotInfos[i].nSlotID).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(5209)));
				EndTimesSlot = slotInfos[i].nSlotID;
				GetRewardTimeTxt(slotInfos[i].nSlotID).SetTextColor(getInstanceL2Util().Yellow);
				GetRewardTimeTxt(slotInfos[i].nSlotID).SetText(getInstanceL2Util().getTimeStringBySec2(EndTimes));
				GetBoxEffect(slotInfos[i].nSlotID).SpawnEffect("");
				break;
			case 4:
				GetSteadyBoxBtn(slotInfos[i].nSlotID).SetTooltipCustomType(MakeTooltipSimpleText(""));
				GetRewardTimeTxt(slotInfos[i].nSlotID).SetTextColor(getInstanceL2Util().Green);
				GetRewardTimeTxt(slotInfos[i].nSlotID).SetText(GetSystemString(2279));
				GetBoxEffect(slotInfos[i].nSlotID).SetCameraDistance(400.0000000);
				GetBoxEffect(slotInfos[i].nSlotID).SpawnEffect("LineageEffect2.Ui_Soul_Crystal");
				break;
			case 0:
				GetSteadyBoxBtn(slotInfos[i].nSlotID).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(5206)));
				GetRewardTimeTxt(slotInfos[i].nSlotID).SetTextColor(getInstanceL2Util().White);
				GetRewardTimeTxt(slotInfos[i].nSlotID).SetText(GetSystemString(3587));
				GetBoxEffect(slotInfos[i].nSlotID).SpawnEffect("");
				break;
			case 1:
				GetSteadyBoxBtn(slotInfos[i].nSlotID).SetTooltipCustomType(MakeTooltipSimpleText(""));
				GetRewardTimeTxt(slotInfos[i].nSlotID).SetTextColor(getInstanceL2Util().White);
				GetRewardTimeTxt(slotInfos[i].nSlotID).SetText(GetSystemString(7523));
				GetBoxEffect(slotInfos[i].nSlotID).SpawnEffect("");
				break;
			case 2:
				GetSteadyBoxBtn(slotInfos[i].nSlotID).SetTooltipCustomType(MakeTooltipSimpleText(""));
				GetRewardTimeTxt(slotInfos[i].nSlotID).SetTextColor(getInstanceL2Util().White);
				GetRewardTimeTxt(slotInfos[i].nSlotID).SetText(GetSystemString(5213));
				if((((slotInfos[i].nSlotStateBefore == 1) || (slotInfos[i].nSlotStateBefore == 4)) || (slotInfos[i].nSlotStateBefore == 0)))
				{
					showeffect();
					GetBoxEffect(slotInfos[i].nSlotID).SetCameraDistance(200.0000000);
					GetBoxEffect(slotInfos[i].nSlotID).SpawnEffect("LineageEffect2.Ui_spirit_extract");
				}
				break;
			default:
				break;
		}
		GetTextureBox(slotInfos[i].nSlotID).SetTexture(GetSteadyBoxTexture(slotInfos[i].nSlotID, slotInfos[i].nBoxType));
		i++;
	}
	return;
}

function UpdateSlotNum(int Num)
{
	local int i;

	i = Num;
	GetSteadyBoxBtn(slotInfos[i].nSlotID).EnableWindow();
	switch(slotInfos[i].nSlotState)
	{
		case 5:
			GetSteadyBoxBtn(slotInfos[i].nSlotID).DisableWindow();
			GetSteadyBoxBtn(slotInfos[i].nSlotID).SetTooltipCustomType(MakeTooltipSimpleText(""));
			GetRewardTimeTxt(slotInfos[i].nSlotID).SetTextColor(getInstanceL2Util().White);
			GetRewardTimeTxt(slotInfos[i].nSlotID).SetText(GetSystemString(3587));
			GetBoxEffect(slotInfos[i].nSlotID).SpawnEffect("");
			break;
		case 3:
			GetSteadyBoxBtn(slotInfos[i].nSlotID).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(5209)));
			EndTimesSlot = slotInfos[i].nSlotID;
			GetRewardTimeTxt(slotInfos[i].nSlotID).SetTextColor(getInstanceL2Util().Yellow);
			GetRewardTimeTxt(slotInfos[i].nSlotID).SetText(getInstanceL2Util().getTimeStringBySec2(EndTimes));
			GetBoxEffect(slotInfos[i].nSlotID).SpawnEffect("");
			break;
		case 4:
			GetSteadyBoxBtn(slotInfos[i].nSlotID).SetTooltipCustomType(MakeTooltipSimpleText(""));
			GetRewardTimeTxt(slotInfos[i].nSlotID).SetTextColor(getInstanceL2Util().Green);
			GetRewardTimeTxt(slotInfos[i].nSlotID).SetText(GetSystemString(2279));
			GetBoxEffect(slotInfos[i].nSlotID).SetCameraDistance(400.0000000);
			GetBoxEffect(slotInfos[i].nSlotID).SpawnEffect("LineageEffect2.Ui_Soul_Crystal");
			break;
		case 0:
			GetSteadyBoxBtn(slotInfos[i].nSlotID).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(5206)));
			GetRewardTimeTxt(slotInfos[i].nSlotID).SetTextColor(getInstanceL2Util().White);
			GetRewardTimeTxt(slotInfos[i].nSlotID).SetText(GetSystemString(3587));
			GetBoxEffect(slotInfos[i].nSlotID).SpawnEffect("");
			break;
		case 1:
			GetSteadyBoxBtn(slotInfos[i].nSlotID).SetTooltipCustomType(MakeTooltipSimpleText(""));
			GetRewardTimeTxt(slotInfos[i].nSlotID).SetTextColor(getInstanceL2Util().White);
			GetRewardTimeTxt(slotInfos[i].nSlotID).SetText(GetSystemString(7523));
			GetBoxEffect(slotInfos[i].nSlotID).SpawnEffect("");
			break;
		case 2:
			GetSteadyBoxBtn(slotInfos[i].nSlotID).SetTooltipCustomType(MakeTooltipSimpleText(""));
			GetRewardTimeTxt(slotInfos[i].nSlotID).SetTextColor(getInstanceL2Util().White);
			GetRewardTimeTxt(slotInfos[i].nSlotID).SetText(GetSystemString(5213));
			if((((slotInfos[i].nSlotStateBefore == 1) || (slotInfos[i].nSlotStateBefore == 4)) || (slotInfos[i].nSlotStateBefore == 0)))
			{
				showeffect();
				GetBoxEffect(slotInfos[i].nSlotID).SetCameraDistance(200.0000000);
				GetBoxEffect(slotInfos[i].nSlotID).SpawnEffect("LineageEffect2.Ui_spirit_extract");
			}
			break;
		default:
			break;
	}
	GetTextureBox(slotInfos[i].nSlotID).SetTexture(GetSteadyBoxTexture(slotInfos[i].nSlotID, slotInfos[i].nBoxType));
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEvent(40);
	RegisterEvent((100000 + 904));
	RegisterEvent((100000 + 903));
	RegisterEvent((100000 + 905));
	RegisterEvent((100000 + 906));
	RegisterEvent((100000 + 907));
	return;
}

event OnLoad()
{
	Initialize();
	SetClosingOnESC();
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9750:
			break;
		case 40:
			Me.KillTimer(4424);
			Clear();
			break;
		case (100000 + 904):
			Handle_S_EX_STEADY_BOX_UI_INIT();
			break;
		case (100000 + 903):
			Handle_S_EX_TIMER_CHECK();
			break;
		case (100000 + 905):
			Handle_S_EX_STEADY_ALL_BOX_UPDATE();
			break;
		case (100000 + 906):
			Handle_S_EX_STEADY_ONE_BOX_UPDATE();
			break;
		case (100000 + 907):
			Handle_S_EX_STEADY_BOX_REWARD();
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string Name)
{
	local int ItemID;
	local INT64 Amounts;
	local string strParam;

	Debug(Name);
	switch(Name)
	{
		case "Refresh_BTN":
			API_C_EX_STEADY_BOX_LOAD();
			Me.SetTimer(99908, 3000);
			ReFresh_btn.DisableWindow();
			break;
		case "OkButton":
			switch(popuptype)
			{
				case 0:
					slotOpenCall = true;
					API_C_EX_STEADY_OPEN_SLOT(selectSlot);
					Dialog_Wnd.HideWindow();
					break;
				case 1:
					findBoxPrice(slotInfos[selectSlot].nBoxType, ItemID, Amounts);
					API_C_EX_STEADY_OPEN_BOX(selectSlot, Amounts);
					Dialog_Wnd.HideWindow();
					break;
				case 3:
					API_C_EX_STEADY_OPEN_BOX(selectSlot, boxTimePrice[TimeChk()].nAmount);
					Dialog_Wnd.HideWindow();
					break;
				case 2:
					API_C_EX_STEADY_OPEN_BOX(selectSlot, INT64(0));
					Dialog_Wnd.HideWindow();
					break;
				default:
					break;
			}
			break;
		case "CancleButton":
			Dialog_Wnd.HideWindow();
			break;
		case "OkButtons":
			Result_wnd.HideWindow();
			break;
		case "WindowHelp_BTN":
			ParamAdd(strParam, "FilePath", (GetLocalizedL2TextPathNameUC() $ "g_steadybox_help.htm"));
			ExecuteEvent(1210, strParam);
			break;
		default:
			break;
	}
	return;
}

function int TimeChk()
{
	local int i;

	i = 1;
	while((i < boxTimePrice.Length))
	{
		if((boxTimePrice[i].nIndex > (EndTimes / 60)))
		{
			return (i - 1);
		}
		i++;
	}
	return (i - 1);
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	switch(a_ButtonHandle.GetWindowName())
	{
		case "SteadyBox_BTN":
			Debug(("OnClickButtonWithHandle" @ a_ButtonHandle.GetParentWindowName()));
			HandleOnClickSteadyBox(int(Left(Right(a_ButtonHandle.GetParentWindowName(), 6), 2)));
			break;
		default:
			break;
	}
	return;
}

function HandleOnClickSteadyBox(int Index)
{
	local int ItemID, Amount;
	local INT64 Amounts;
	local ItemInfo Info;

	Debug(("HandleOnClickSteadyBox" @ string(Index)));
	Debug(("slotInfos[i].nSlotState-->" @ string(slotInfos[Index].nSlotState)));
	GetSteadyBoxBtn(Index).ClearTooltip();
	Debug("추가작업 필요!!!");  // EN?: Needs more work!!!
	Item_ItemWindow.Clear();
	selectSlot = slotInfos[Index].nSlotID;
	switch(slotInfos[Index].nSlotState)
	{
		case 0:
			popuptype = 0;
			hideNeedItems(true);
			GetSteadyBoxSlotInfo((selectSlot + 1), ItemID, Amount);
			Info = GetItemInfoByClassID(ItemID);
			GetTextBoxHandle((m_Windowname $ ".Dialog_wnd.ItemRegistrationConfirm_Wnd.DescriptionTextBox")).SetText(GetSystemString(5207));
			Item_ItemWindow.AddItem(Info);
			ItemName_Txt.SetText(GetItemNameAll(Info));
			ItemNum_txt.SetText(("x" $ string(Amount)));
			ItemNum_txts.SetText((("(" $ string(GetInventoryItemCount(Info.Id))) $ ")"));
			disableOKButton(INT64(Amount), GetInventoryItemCount(Info.Id));
			Dialog_Wnd.ShowWindow();
			Debug("슬롯 오픈!!!");  // EN?: Slots open!!!
			break;
		case 1:
			Debug("상자 없음..음..!!!");  // EN?: No box.. um..!!!
			break;
		case 2:
			Debug("박스 오픈!!!");  // EN?: Box open!!!
			if((EndTimes > 0))
			{
				findBoxPrice(slotInfos[Index].nBoxType, ItemID, Amounts);
				Info = GetItemInfoByClassID(ItemID);
				popuptype = 1;
				hideNeedItems(true);
				Item_ItemWindow.AddItem(Info);
				GetTextBoxHandle((m_Windowname $ ".Dialog_wnd.ItemRegistrationConfirm_Wnd.DescriptionTextBox")).SetText(GetSystemString(5210));
				ItemName_Txt.SetText(GetItemNameAll(Info));
				ItemNum_txt.SetText(("x" $ string(Amounts)));
				ItemNum_txts.SetText((("(" $ string(GetInventoryItemCount(Info.Id))) $ ")"));
				disableOKButton(Amounts, GetInventoryItemCount(Info.Id));
				Dialog_Wnd.ShowWindow();
			}
			else
			{
				popuptype = 2;
				hideNeedItems(false);
				GetTextBoxHandle((m_Windowname $ ".Dialog_wnd.ItemRegistrationConfirm_Wnd.DescriptionTextBox")).SetText(GetSystemString(5208));
				OKButton.EnableWindow();
				Dialog_Wnd.ShowWindow();
			}
			break;
		case 3:
			popuptype = 3;
			hideNeedItems(true);
			Info = GetItemInfoByClassID(boxTimePrice[TimeChk()].nItemType);
			Item_ItemWindow.AddItem(Info);
			GetTextBoxHandle((m_Windowname $ ".Dialog_wnd.ItemRegistrationConfirm_Wnd.DescriptionTextBox")).SetText(GetSystemString(5210));
			ItemName_Txt.SetText(GetItemNameAll(Info));
			ItemNum_txt.SetText(("x" $ string(boxTimePrice[TimeChk()].nAmount)));
			ItemNum_txts.SetText((("(" $ string(GetInventoryItemCount(Info.Id))) $ ")"));
			disableOKButton(boxTimePrice[TimeChk()].nAmount, GetInventoryItemCount(Info.Id));
			Dialog_Wnd.ShowWindow();
			Debug("남은 시간에 따라 !!!");  // EN?: According to the remaining time!!!
			break;
		case 4:
			API_C_EX_STEADY_GET_REWARD(selectSlot);
			Debug("상자 받기~~");  // EN?: Get a box ~ ~
			break;
		default:
			break;
	}
	return;
}

function hideNeedItems(bool Show)
{
	if(Show)
	{
		Charge_GroupBox_Tex0.ShowWindow();
		Itemslot_tex.ShowWindow();
		Item_ItemWindow.ShowWindow();
		ItemName_Txt.ShowWindow();
		ItemNum_txt.ShowWindow();
		ItemNum_txts.ShowWindow();
	}
	else
	{
		Charge_GroupBox_Tex0.HideWindow();
		Itemslot_tex.HideWindow();
		Item_ItemWindow.HideWindow();
		ItemName_Txt.HideWindow();
		ItemNum_txt.HideWindow();
		ItemNum_txts.HideWindow();
	}
	return;
}

function disableOKButton(INT64 Price, INT64 Having)
{
	if((Price > Having))
	{
		ItemNum_txts.SetTextColor(getInstanceL2Util().Red);
		OKButton.DisableWindow();
	}
	else
	{
		ItemNum_txts.SetTextColor(getInstanceL2Util().Blue);
		OKButton.EnableWindow();
	}
	return;
}

function findBoxPrice(int boxtype, out int ItemID, out INT64 Amount)
{
	local int i;

	i = 0;
	while((i < boxPrice.Length))
	{
		if((boxPrice[i].nIndex == boxtype))
		{
			ItemID = boxPrice[i].nItemType;
			Amount = boxPrice[i].nAmount;
		}
		i++;
	}
	return;
}

function RichListCtrlRowData makeRecord(int nItemClassID, int Amount)
{
	local ItemInfo Info;
	local RichListCtrlRowData Record;
	local string fullNameString, toolTipParam;

	Info = GetItemInfoByClassID(nItemClassID);
	fullNameString = GetItemNameAll(Info);
	ItemInfoToParam(Info, toolTipParam);
	Record.szReserved = toolTipParam;
	Record.cellDataList.Length = 1;
	Record.cellDataList[0].nReserved1 = nItemClassID;
	Record.cellDataList[0].szData = fullNameString;
	return Record;
}

event OnShow()
{
	SideBarScript.ToggleByWindowName(getCurrentWindowName(string(self)), true);
	Hideffect();
	return;
}

event OnHide()
{
	SideBarScript.ToggleByWindowName(getCurrentWindowName(string(self)), false);
	Hideffect();
	return;
}

function showeffect()
{
	SideBarScript._SpawnEffect(23, "LineageEffect2.ui_star_circle");
	return;
}

function Hideffect()
{
	SideBarScript._DeSpawnEffect(23);
	return;
}

event OnTimer(int tID)
{
	switch(tID)
	{
		case 4424:
			if((EndTimesSlot > -1))
			{
				EndTimes = (EndTimes - 1);
				if((EndTimes >= 0))
				{
					GetRewardTimeTxt(EndTimesSlot).SetText(getInstanceL2Util().getTimeStringBySec2(EndTimes));
				}
				if((EndTimes < 0))
				{
					showeffect();
					EndTimes = 0;
					EndTimesSlot = -1;
					API_C_EX_TIMER_CHECK();
				}
			}
			break;
		case 99908:
			ReFresh_btn.EnableWindow();
			Me.KillTimer(99908);
			break;
		default:
			break;
	}
	return;
}

function bool GetStringIDFromBtnName(string btnName, string someString, out string strID)
{
	if(!CheckBtnName(btnName, someString))
	{
		return false;
	}
	strID = Mid(btnName, Len(someString));
	return true;
}

function bool CheckBtnName(string btnName, string someString)
{
	return (Left(btnName, Len(someString)) == someString);
}

function string Int2Str(int Num)
{
	if((Num < 10))
	{
		return ("0" $ string(Num));
	}
	return string(Num);
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
	return;
}
