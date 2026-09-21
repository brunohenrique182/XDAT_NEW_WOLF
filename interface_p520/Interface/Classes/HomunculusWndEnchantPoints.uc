class HomunculusWndEnchantPoints extends UICommonAPI
	dependson(UIPacket);

const TIMEID_DELAY = 1;
const TIME_REFRESH = 100;

enum TYPE_POINT
{
	killnpc,                        // 0
	vp,                             // 1
	vpinsert                        // 2
};

var WindowHandle Me;
var string m_Windowname;
var L2Util util;
var ItemWindowHandle costIcon00_ItemWindow;
var TextBoxHandle costItemName00;
var TextBoxHandle cost00_Txt;
var StatusBarHandle statusBar0;
var StatusBarHandle statusBar1;
var ButtonHandle btn00;
var ButtonHandle btn01;
var ButtonHandle btn10;
var ButtonHandle btn11;
var ButtonHandle btnplus1;
var int NPCKillPoint;
var int InsertNPCKillPoint;
var int InitNPCKillPoint;
var int VPPoint;
var int InsertVPPoint;
var int InitVPPoint;
var int nActivateSlotIndex;
var int MaxVitality;
var HomunculusWnd HomunculusWndScript;
var HomunculusAPI.HomunEnchantData HomunEnchantData;
var HomunculusWndMainDetailStatsEnchant homunculusWndMainDetailStatsEnchantScript;
var HomunculusWndMainList homunculusWndMainListScript;

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	util = L2Util(GetScript("L2Util"));
	costIcon00_ItemWindow = GetItemWindowHandle((m_Windowname $ ".costIcon00_ItemWindow"));
	costItemName00 = GetTextBoxHandle((m_Windowname $ ".costItemName00"));
	cost00_Txt = GetTextBoxHandle((m_Windowname $ ".cost00_Txt"));
	btn00 = GetButtonHandle((m_Windowname $ ".btn00"));
	btn01 = GetButtonHandle((m_Windowname $ ".btn01"));
	btn10 = GetButtonHandle((m_Windowname $ ".btn10"));
	btn11 = GetButtonHandle((m_Windowname $ ".btn11"));
	btnplus1 = GetButtonHandle((m_Windowname $ ".btnplus1"));
	statusBar0 = GetStatusBarHandle((m_Windowname $ ".statusBar0"));
	statusBar1 = GetStatusBarHandle((m_Windowname $ ".statusBar1"));
	HomunculusWndScript = HomunculusWnd(GetScript("HomunculusWnd"));
	homunculusWndMainDetailStatsEnchantScript = HomunculusWndMainDetailStatsEnchant(GetScript("HomunculusWnd.HomunculusWndMainDetailStatsEnchant"));
	homunculusWndMainListScript = HomunculusWndMainList(GetScript("HomunculusWnd.HomunculusWndMainList"));
	MaxVitality = GetMaxVitality();
	return;
}

function HandleGameInit()
{
	if((GetGameStateName() != "GAMINGSTATE"))
	{
		return;
	}
	HomunEnchantData = HomunculusWndScript.API_GetHomunEnchantData();
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(150);
	RegisterEvent(2610);
	RegisterEvent(191);
	RegisterEvent(180);
	RegisterEvent((100000 + 863));
	RegisterEvent((100000 + 861));
	RegisterEvent((100000 + 862));
	return;
}

function OnLoad()
{
	Initialize();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 150:
			if(HomunculusWndScript.ChkSerVer())
			{
				HandleGameInit();
			}
			break;
		case 2610:
			if(Me.IsShowWindow())
			{
				SetNeedItemInfo();
			}
			break;
		case 191:
		case 180:
			if(Me.IsShowWindow())
			{
				HandleVPInsertBtnPlus1();
			}
			break;
		case (100000 + 863):
			Handle_S_EX_HOMUNCULUS_POINT_INFO();
			break;
		case (100000 + 861):
			Handle_S_EX_HOMUNCULUS_GET_ENCHANT_POINT_RESULT();
			break;
		case (100000 + 862):
			Handle_S_EX_HOMUNCULUS_INIT_POINT_RESULT();
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "btn00":
			HomunculusWndScript.API_C_EX_HOMUNCULUS_GET_ENCHANT_POINT(0);
			HandleBtnsDisable();
			break;
		case "btn01":
			HomunculusWndScript.API_C_EX_HOMUNCULUS_INIT_POINT(0);
			HandleBtnsDisable();
			break;
		case "btn10":
			HomunculusWndScript.API_C_EX_HOMUNCULUS_GET_ENCHANT_POINT(1);
			HandleBtnsDisable();
			break;
		case "btn11":
			HomunculusWndScript.API_C_EX_HOMUNCULUS_INIT_POINT(1);
			HandleBtnsDisable();
			break;
		case "btnplus1":
			HomunculusWndScript.API_C_EX_HOMUNCULUS_GET_ENCHANT_POINT(2);
			HandleBtnsDisable();
			break;
		case "btnClose":
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 1:
			Me.KillTimer(1);
			HandleCanBtns();
		default:
			return;
	}
}

function Toggle()
{
	if(Me.IsShowWindow())
	{
		Hide();
	}
	else
	{
		Show();
	}
	return;
}

function Show()
{
	API_C_EX_SHOW_HOMUNCULUS_INFO();
	SetPoints();
	SetTooltip();
	SetNeedItemInfo();
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function Hide()
{
	Me.HideWindow();
	return;
}

function ArarmOnOff()
{
	if(((((HomunEnchantData.PointMax != InsertNPCKillPoint) || (HomunEnchantData.PointResetMax != InitNPCKillPoint)) && (NPCKillPoint >= HomunEnchantData.PointNeedExp)) && (HomunEnchantData.PointNeedExp != 0)))
	{
		HomunculusWndScript.SetNotice(1);
	}
	else
	{
		HomunculusWndScript.HideNotice(1);
	}
	return;
}

function HandleBtnsDisable()
{
	btn00.DisableWindow();
	btn01.DisableWindow();
	btn10.DisableWindow();
	btn11.DisableWindow();
	btnplus1.DisableWindow();
	Me.SetTimer(1, 100);
	return;
}

function HandleCanBtns()
{
	if(CanInsertKillPoint())
	{
		btn00.EnableWindow();
	}
	else
	{
		btn00.DisableWindow();
	}
	if(CanInitKillPoint())
	{
		btn01.EnableWindow();
	}
	else
	{
		btn01.DisableWindow();
	}
	if(CanInsertVPPoint())
	{
		btn10.EnableWindow();
	}
	else
	{
		btn10.DisableWindow();
	}
	if(CanInitVPPoint())
	{
		btn11.EnableWindow();
	}
	else
	{
		btn11.DisableWindow();
	}
	HandleVPInsertBtnPlus1();
	return;
}

function SetPoints()
{
	btn00.SetNameText(((((GetSystemString(13353) $ "\\n") $ string((HomunEnchantData.PointMax - InsertNPCKillPoint))) $ "/") $ string(HomunEnchantData.PointMax)));
	btn01.SetNameText(((((GetSystemString(479) $ "\\n") $ string((HomunEnchantData.PointResetMax - InitNPCKillPoint))) $ "/") $ string(HomunEnchantData.PointResetMax)));
	btn10.SetNameText(((((GetSystemString(13353) $ "\\n") $ string((HomunEnchantData.BonusMax - InsertVPPoint))) $ "/") $ string(HomunEnchantData.BonusMax)));
	btn11.SetNameText(((((GetSystemString(479) $ "\\n") $ string((HomunEnchantData.BonusResetMax - InitVPPoint))) $ "/") $ string(HomunEnchantData.BonusResetMax)));
	HandleCanBtns();
	statusBar0.SetPoint(INT64(NPCKillPoint), INT64(HomunEnchantData.PointNeedExp));
	statusBar1.SetPoint(INT64(VPPoint), INT64(HomunEnchantData.BonusNeedVp));
	return;
}

function SetNeedItemInfo()
{
	local ItemInfo iInfo;
	local HomunculusAPI.HomunEnchantResetData HomunEnchantResetData;
	local INT64 ItemNum;

	HomunEnchantResetData = HomunculusWndScript.API_GetPointResetItem();
	iInfo = GetItemInfoByClassID(HomunEnchantResetData.ItemID);
	costIcon00_ItemWindow.AddItem(iInfo);
	costItemName00.SetText(GetItemNameAll(iInfo));
	ItemNum = GetInventoryItemCount(iInfo.Id);
	cost00_Txt.SetText(((GetSystemString(13392) $ ":") $ MakeCostString(string(ItemNum))));
	return;
}

function SetTooltip()
{
	local HomunculusAPI.HomunEnchantResetData HomunEnchantResetData;
	local CustomTooltip t, T2;
	local ItemInfo iInfo;
	local string Msg, needNumString, ItemName;

	util.setCustomTooltip(t);
	util.ToopTipMinWidth(300);
	HomunEnchantResetData = HomunculusWndScript.API_GetPointResetItem();
	iInfo = GetItemInfoByClassID(HomunEnchantResetData.ItemID);
	ItemName = GetItemNameAll(iInfo);
	needNumString = MakeCostString(string(HomunEnchantResetData.NeededNum));
	Msg = MakeFullSystemMsg(GetSystemMessage(13214), ItemName, needNumString);
	util.ToopTipInsertText(Msg);
	btn01.SetTooltipCustomType(util.getCustomToolTip());
	util.setCustomTooltip(T2);
	util.ToopTipMinWidth(300);
	HomunEnchantResetData = HomunculusWndScript.API_GetBonusResetItem();
	iInfo = GetItemInfoByClassID(HomunEnchantResetData.ItemID);
	ItemName = GetItemNameAll(iInfo);
	needNumString = MakeCostString(string(HomunEnchantResetData.NeededNum));
	Msg = MakeFullSystemMsg(GetSystemMessage(13214), ItemName, needNumString);
	util.ToopTipInsertText(Msg);
	btn11.SetTooltipCustomType(util.getCustomToolTip());
	btnplus1.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13354)));
	return;
}

function Handle_S_EX_HOMUNCULUS_POINT_INFO()
{
	local UIPacket._S_EX_HOMUNCULUS_POINT_INFO packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_HOMUNCULUS_POINT_INFO(packet))
	{
		return;
	}
	HomunculusWndScript.SetEnchantpoint(packet.nEnchantPoint);
	HomunculusWndScript._SetEvolutionPoint(packet.nEvolutionPoint);
	HomunculusWndRevolution(GetScript("HomunculusWnd.HomunculusWndRevolution"))._SetEvolutionPoint(packet.nEvolutionPoint);
	homunculusWndMainDetailStatsEnchantScript.SetBtnEnable0();
	NPCKillPoint = packet.nNPCKillPoint;
	InsertNPCKillPoint = packet.nInsertNPCKillPoint;
	InitNPCKillPoint = packet.nInitNPCKillPoint;
	VPPoint = packet.nVPPoint;
	InsertVPPoint = packet.nInsertVPPoint;
	InitVPPoint = packet.nInitVPPoint;
	nActivateSlotIndex = packet.nActivateSlotIndex;
	homunculusWndMainListScript.SetActiveSlotIndex(nActivateSlotIndex);
	SetPoints();
	ArarmOnOff();
	return;
}

function Handle_S_EX_HOMUNCULUS_GET_ENCHANT_POINT_RESULT()
{
	local UIPacket._S_EX_HOMUNCULUS_GET_ENCHANT_POINT_RESULT packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_HOMUNCULUS_GET_ENCHANT_POINT_RESULT(packet))
	{
		return;
	}
	Debug((("Handle_S_EX_HOMUNCULUS_GET_ENCHANT_POINT_RESULT" @ string(packet.nID)) @ string(packet.nEnchantType)));
	AddSystemMessage(packet.nID);
	if((packet.Type == 0))
	{
		return;
	}
	switch(packet.nEnchantType)
	{
		case 0:
			break;
		case 1:
			break;
		case 2:
			break;
		default:
			break;
	}
	return;
}

function Handle_S_EX_HOMUNCULUS_INIT_POINT_RESULT()
{
	local UIPacket._S_EX_HOMUNCULUS_INIT_POINT_RESULT packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_HOMUNCULUS_INIT_POINT_RESULT(packet))
	{
		return;
	}
	AddSystemMessage(packet.nID);
	if((packet.Type == 0))
	{
		return;
	}
	switch(packet.nInitType)
	{
		case 0:
			break;
		case 1:
			break;
		default:
			break;
	}
	return;
}

function HandleVPInsertBtnPlus1()
{
	if(CanInsertVPPlus())
	{
		btnplus1.EnableWindow();
	}
	else
	{
		btnplus1.DisableWindow();
	}
	return;
}

function bool CanInitKillPoint()
{
	return ((InitNPCKillPoint < HomunEnchantData.PointResetMax) && (InsertNPCKillPoint >= HomunEnchantData.PointMax));
}

function bool CanInsertKillPoint()
{
	return ((NPCKillPoint >= HomunEnchantData.PointNeedExp) && (InsertNPCKillPoint < HomunEnchantData.PointMax));
}

function bool CanInitVPPoint()
{
	return ((InitVPPoint < HomunEnchantData.BonusResetMax) && (InsertVPPoint >= HomunEnchantData.BonusMax));
}

function bool CanInsertVPPoint()
{
	return ((VPPoint >= HomunEnchantData.BonusNeedVp) && (InsertVPPoint < HomunEnchantData.BonusMax));
}

function bool CanInsertVPPlus()
{
	local UserInfo uInfo;

	if(GetPlayerInfo(uInfo))
	{
		return ((uInfo.nVitality >= (MaxVitality / 4)) && (VPPoint < HomunEnchantData.BonusNeedVp));
	}
	return false;
}

function API_C_EX_SHOW_HOMUNCULUS_INFO()
{
	HomunculusWndScript.API_C_EX_SHOW_HOMUNCULUS_INFO(2);
	return;
}
