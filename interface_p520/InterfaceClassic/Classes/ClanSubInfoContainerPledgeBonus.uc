class ClanSubInfoContainerPledgeBonus extends UICommonAPI
	dependson(UIPacket);

const ACCESS_TYPE = 0;
const HUNT_TYPE = 1;
const RAIDPHASE_VIEW_MAX = 35;
const RAIDPHASE_VIEW_NUM = 4;
const RAIDPHASE_GAB = 5;

enum PledgeDonationType
{
	PDT_NORMAL,                     // 0
	PDT_GREAT,                      // 1
	PDT_EXCELLENT,                  // 2
	PDT_MAX                         // 3
};

enum tabindex
{
	TAB_DONATION,                   // 0
	TAB_RAID                        // 1
};

var string m_Windowname;
var WindowHandle Me;
var ItemWindowHandle JoinYesterdayBonus_Item_ItemWnd;
var ItemWindowHandle HuntYesterdayBonus_Item_ItemWnd;
var string JoinWndPath;
var string HuntWndPath;
var string m_ClanPledgeRaidWindowName;
var int accessBonusMax;
var int huntBonusMax;
var ClanWndClassicNew clanWndClassicScr;
var UIControlNeedItemList needItemListNormalScr;
var UIControlNeedItemList needItemListFineScr;
var UIControlNeedItemList needItemListPremiumlScr;
var bool hasPledgeBonusList;
var string m_ClanPledgeDonationWnd;
var int donaRemainCount;
var PledgeDonationType DonationType;
var TabHandle tab;
var TextBoxHandle ProbabilityTitle_txt;
var TextBoxHandle ProbabilityTitle1_txt;

function InitDefaultSetting()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	clanWndClassicScr = ClanWndClassicNew(GetScript("ClanWndClassicNew"));
	clanWndClassicScr.clanSubInfoContainerPledgeBonusScr = self;
	Me.SetFocus();
	return;
}

function Initialize()
{
	m_ClanPledgeRaidWindowName = "ClanPledgeRaid_Window";
	JoinWndPath = (m_Windowname $ ".ClanPledgeBonus_Window.JoinBonusWnd");
	HuntWndPath = (m_Windowname $ ".ClanPledgeBonus_Window.HuntBonusWnd");
	JoinYesterdayBonus_Item_ItemWnd = GetItemWindowHandle((m_Windowname $ ".ClanPledgeBonus_Window.JoinBonusWnd.JoinYesterdayBonus_Item_ItemWnd"));
	HuntYesterdayBonus_Item_ItemWnd = GetItemWindowHandle((m_Windowname $ ".ClanPledgeBonus_Window.HuntBonusWnd.HuntYesterdayBonus_Item_ItemWnd"));
	tab = GetTabHandle((m_Windowname $ ".ClanReward_TabCtrl"));
	hasPledgeBonusList = false;
	m_ClanPledgeDonationWnd = "PledgeDonationWnd";
	if(((int(GetLanguage()) == 8) || (int(GetLanguage()) == 9)))
	{
		ProbabilityTitle_txt = GetTextBoxHandle((m_Windowname $ ".PledgeDonationWnd.PremiumDonationWnd.ProbabilityTitle_txt"));
		ProbabilityTitle1_txt = GetTextBoxHandle((m_Windowname $ ".PledgeDonationWnd.PremiumDonationWnd.ProbabilityTitle1_txt"));
		ProbabilityTitle_txt.SetText(GetSystemString(5981));
		ProbabilityTitle1_txt.SetText(GetSystemString(5981));
	}
	return;
}

function OnLoad()
{
	InitDefaultSetting();
	Initialize();
	if(((int(GetLanguage()) == 8) || (int(GetLanguage()) == 9)))
	{
		GetTextBoxHandle((((m_Windowname $ ".") $ m_ClanPledgeRaidWindowName) $ ".ClanRaidStageTitle_Text")).SetText((GetSystemString(3655) @ ":"));
	}
	else
	{
		GetTextBoxHandle((((m_Windowname $ ".") $ m_ClanPledgeRaidWindowName) $ ".ClanRaidStageTitle_Text")).SetText(((GetSystemString(898) @ GetSystemString(2980)) @ ":"));
	}
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(20190);
	RegisterEvent(20191);
	RegisterEvent(20193);
	RegisterEvent(20192);
	RegisterEvent(40);
	RegisterEvent(20194);
	RegisterEvent(9750);
	RegisterEvent((100000 + 942));
	RegisterEvent((100000 + 943));
	return;
}

function OnShow()
{
	API_C_EX_PLEDGE_DONATION_INFO();
	return;
}

function HandleOnShow()
{
	switch(GetTobIndex())
	{
		case 0:
			API_C_EX_PLEDGE_DONATION_INFO();
			break;
		case 1:
			break;
		default:
			break;
	}
	return;
}

function OnEvent(int a_EventID, string param)
{
	if(!getInstanceUIData().GetIsClassicServer())
	{
		return;
	}
	switch(a_EventID)
	{
		case (100000 + 942):
			Handle_S_EX_PLEDGE_DONATION_INFO();
			break;
		case (100000 + 943):
			Handle_S_EX_PLEDGE_DONATION_REQUEST();
			break;
		case 20190:
			PledgeBonusOpenHandler(param);
			break;
		case 20191:
			PledgeBonusListHandler(param);
			break;
		case 20192:
			hasPledgeBonusList = false;
			if(Me.IsShowWindow())
			{
				HandleOnShow();
			}
			break;
		case 20193:
			PlegeBonusUpdate(param);
			break;
		case 40:
			hasPledgeBonusList = false;
			break;
		case 20194:
			handleSetRaidSkillInfos(param);
			break;
		case 9750:
			InitDonationWnd();
			break;
		default:
			break;
	}
	return;
}

event OnSetFocus(WindowHandle wndHandle, bool bFocused)
{
	m_hOwnerWnd.GetParentWindowHandle().GetScript().OnSetFocus(wndHandle, bFocused);
	return;
}

function PlegeBonusUpdate(string param)
{
	local int missionType, currPoint;

	if(Me.IsShowWindow())
	{
		ParseInt(param, "MissionType", missionType);
		ParseInt(param, "CurrPoint", currPoint);
		if((missionType == 1))
		{
			if((huntBonusMax > 0))
			{
				GetTextBoxHandle((HuntWndPath $ ".HuntBonus_MemberCount1_Text")).SetText(string(currPoint));
				GetTextBoxHandle((HuntWndPath $ ".HuntBonus_MemberCount2_Text")).SetText(("/" $ string(huntBonusMax)));
				setStateProgress(missionType, huntBonusMax, currPoint);
			}
		}
		else if((accessBonusMax > 0))
		{
			GetTextBoxHandle((JoinWndPath $ ".JoinBonus_MemberCount1_Text")).SetText(string(currPoint));
			GetTextBoxHandle((JoinWndPath $ ".JoinBonus_MemberCount2_Text")).SetText(("/" $ string(accessBonusMax)));
			setStateProgress(missionType, accessBonusMax, currPoint);
		}
	}
	return;
}

function PledgeBonusOpenHandler(string param)
{
	local int accessBonusCurr, accessRewardID, accessRewardSkillLV, accessBtnActive, huntBonusCurr, huntRewardID, huntRewardLV, huntBtnActive;
	local SkillInfo accessBonusSkillInfo, huntRewardSkillInfo;
	local ItemInfo accessBonusItemInfo, huntRewardItemInfo;
	local int AccessRewardType, HuntRewardType;

	ParseInt(param, "AccessRewardType", AccessRewardType);
	ParseInt(param, "AccessBonusMax", accessBonusMax);
	ParseInt(param, "AccessBonusCurr", accessBonusCurr);
	ParseInt(param, "AccessRewardID", accessRewardID);
	ParseInt(param, "AccessRewardLV", accessRewardSkillLV);
	ParseInt(param, "AccessBtnActive", accessBtnActive);
	ParseInt(param, "HuntRewardType", HuntRewardType);
	ParseInt(param, "HuntBonusMax", huntBonusMax);
	ParseInt(param, "HuntBonusCurr", huntBonusCurr);
	ParseInt(param, "HuntRewardID", huntRewardID);
	ParseInt(param, "HuntRewardLV", huntRewardLV);
	ParseInt(param, "HuntBtnActive", huntBtnActive);
	JoinYesterdayBonus_Item_ItemWnd.Clear();
	JoinYesterdayBonus_Item_ItemWnd.ClearTooltip();
	JoinYesterdayBonus_Item_ItemWnd.SetTooltipType("");
	if((accessRewardID > 0))
	{
		if((AccessRewardType == 1))
		{
			Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(accessRewardID), accessBonusItemInfo);
			JoinYesterdayBonus_Item_ItemWnd.AddItem(accessBonusItemInfo);
			JoinYesterdayBonus_Item_ItemWnd.SetTooltipType("Inventory");
		}
		else
		{
			GetSkillInfo(accessRewardID, 1, 0, accessBonusSkillInfo);
			JoinYesterdayBonus_Item_ItemWnd.AddItem(getItemInfoBySkillInfo(accessBonusSkillInfo));
			JoinYesterdayBonus_Item_ItemWnd.SetTooltipType("Skill");
		}
	}
	GetTextBoxHandle((JoinWndPath $ ".JoinBonus_MemberCount1_Text")).SetText(string(accessBonusCurr));
	GetTextBoxHandle((JoinWndPath $ ".JoinBonus_MemberCount2_Text")).SetText(("/" $ string(accessBonusMax)));
	if((accessRewardID > 0))
	{
		if((AccessRewardType == 1))
		{
			GetTextBoxHandle((JoinWndPath $ ".JoinYesterdayBonusLV_Text")).SetText("");
			GetNameCtrlHandle((JoinWndPath $ ".JoinYesterdaydayBonusName_Text")).SetName(accessBonusItemInfo.Name, NCT_Normal, TA_Left);
		}
		else
		{
			GetTextBoxHandle((JoinWndPath $ ".JoinYesterdayBonusLV_Text")).SetText((GetSystemString(88) $ string(accessRewardSkillLV)));
			GetNameCtrlHandle((JoinWndPath $ ".JoinYesterdaydayBonusName_Text")).SetName(accessBonusSkillInfo.SkillName, NCT_Normal, TA_Left);
		}
	}
	else
	{
		GetTextBoxHandle((JoinWndPath $ ".JoinYesterdayBonusLV_Text")).SetText("");
		GetNameCtrlHandle((JoinWndPath $ ".JoinYesterdaydayBonusName_Text")).SetName(GetSystemString(5852), NCT_Normal, TA_Left);
	}
	setStateProgress(0, accessBonusMax, accessBonusCurr);
	HuntYesterdayBonus_Item_ItemWnd.Clear();
	HuntYesterdayBonus_Item_ItemWnd.ClearTooltip();
	HuntYesterdayBonus_Item_ItemWnd.SetTooltipType("");
	if((huntRewardID > 0))
	{
		if((HuntRewardType == 1))
		{
			Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(huntRewardID), huntRewardItemInfo);
			HuntYesterdayBonus_Item_ItemWnd.AddItem(huntRewardItemInfo);
			HuntYesterdayBonus_Item_ItemWnd.SetTooltipType("Inventory");
		}
		else
		{
			GetSkillInfo(huntRewardID, 1, 0, huntRewardSkillInfo);
			HuntYesterdayBonus_Item_ItemWnd.AddItem(getItemInfoBySkillInfo(huntRewardSkillInfo));
			HuntYesterdayBonus_Item_ItemWnd.SetTooltipType("Skill");
		}
	}
	GetTextBoxHandle((HuntWndPath $ ".HuntBonus_MemberCount1_Text")).SetText(string(huntBonusCurr));
	GetTextBoxHandle((HuntWndPath $ ".HuntBonus_MemberCount2_Text")).SetText(("/" $ string(huntBonusMax)));
	if((huntRewardLV > 0))
	{
		GetTextBoxHandle((HuntWndPath $ ".HuntYesterdaydayBonusLV_Text")).SetText((GetSystemString(88) $ string(huntRewardLV)));
		GetNameCtrlHandle((HuntWndPath $ ".HuntYesterdaydayBonusName_Text")).SetName(huntRewardItemInfo.Name, NCT_Normal, TA_Left);
	}
	else
	{
		GetTextBoxHandle((HuntWndPath $ ".HuntYesterdaydayBonusLV_Text")).SetText("");
		GetNameCtrlHandle((HuntWndPath $ ".HuntYesterdaydayBonusName_Text")).SetName(GetSystemString(5852), NCT_Normal, TA_Left);
	}
	setStateProgress(1, huntBonusMax, huntBonusCurr);
	if((accessBtnActive > 0))
	{
		GetButtonHandle((JoinWndPath $ ".Clan1_ManageBtn")).EnableWindow();
	}
	else
	{
		GetButtonHandle((JoinWndPath $ ".Clan1_ManageBtn")).DisableWindow();
	}
	if((huntBtnActive > 0))
	{
		GetButtonHandle((HuntWndPath $ ".Clan2_ManageBtn")).EnableWindow();
	}
	else
	{
		GetButtonHandle((HuntWndPath $ ".Clan2_ManageBtn")).DisableWindow();
	}
	return;
}

function setStateProgress(int bonusType, int nMax, int nCur)
{
	local string taretPath, arrowTexture, stateWnd;
	local float maxStep, fProgressStep;
	local int nLevel, nProgress;
	local float fProgress;
	local int i, N;

	if((bonusType == 0))
	{
		stateWnd = JoinWndPath;
		arrowTexture = ".PledgeArrow";
	}
	else
	{
		stateWnd = HuntWndPath;
		arrowTexture = ".HuntArrow";
	}
	maxStep = (float(nMax) / 4.0000000);
	nLevel = (int((float(nCur) / maxStep)) + 1);
	fProgressStep = (maxStep / 3.0000000);
	fProgress = ((float(nCur) % maxStep) / fProgressStep);
	nProgress = appCeil(fProgress);
	i = 1;
	while((i < 5))
	{
		N = 1;
		while((N < 4))
		{
			taretPath = (((((stateWnd $ arrowTexture) $ string(i)) $ "_") $ string(N)) $ "_disable_Texture");
			if(((i == nLevel) && (N < nProgress)))
			{
				GetTextureHandle(taretPath).SetTexture("l2ui_ct1.PledgeArrow_normal");
				N++;
				continue;
			}
			if((i < nLevel))
			{
				GetTextureHandle(taretPath).SetTexture("l2ui_ct1.PledgeArrow_normal");
				N++;
				continue;
			}
			if(((i == nLevel) && (N == nProgress)))
			{
				GetTextureHandle(taretPath).SetTexture("l2ui_ct1.PledgeArrow_get");
				N++;
				continue;
			}
			GetTextureHandle(taretPath).SetTexture("l2ui_ct1.PledgeArrow_disable");
			N++;
		}
		taretPath = ((((stateWnd $ ".") $ "PledgeSelectPanel0") $ string(i)) $ "_ani");
		GetAnimTextureHandle(taretPath).Stop();
		GetAnimTextureHandle(taretPath).Pause();
		GetAnimTextureHandle(taretPath).HideWindow();
		if((nLevel > i))
		{
			setEnablePledgeBonus(bonusType, i, true);
			i++;
			continue;
		}
		setEnablePledgeBonus(bonusType, i, false);
		i++;
	}
	if((nLevel > 1))
	{
		taretPath = ((((stateWnd $ ".") $ "PledgeSelectPanel0") $ string((nLevel - 1))) $ "_ani");
		GetAnimTextureHandle(taretPath).SetLoopCount(9999999);
		GetAnimTextureHandle(taretPath).ShowWindow();
		GetAnimTextureHandle(taretPath).Play();
	}
	if((nCur > 0))
	{
		setEnableFlagTexture(bonusType, true);
	}
	else
	{
		setEnableFlagTexture(bonusType, false);
	}
	return;
}

function setEnableFlagTexture(int bonusType, bool bFlag)
{
	local string stateWnd;

	if((bonusType == 0))
	{
		stateWnd = JoinWndPath;
	}
	else
	{
		stateWnd = HuntWndPath;
	}
	if(bFlag)
	{
		GetTextureHandle((stateWnd $ ".PledgeflagIcon2_texture")).SetTexture("L2UI_CT1.PledgeflagIcon3");
	}
	else
	{
		GetTextureHandle((stateWnd $ ".PledgeflagIcon2_texture")).SetTexture("L2UI_CT1.PledgeflagIcon2");
	}
	return;
}

function bool hasPoint(float Num)
{
	local string temp;
	local array<string> Result;

	temp = string(Num);
	Split(temp, ".", Result);
	return (int(Result[1]) > 0);
}

function addItemSlot(ItemWindowHandle ItemWnd, ItemInfo pIteminfo)
{
	ItemWnd.Clear();
	ItemWnd.AddItem(pIteminfo);
	return;
}

function ItemInfo getItemInfoBySkillInfo(SkillInfo rSkilInfo)
{
	local ItemInfo infItem;

	infItem.Id.ClassID = rSkilInfo.SkillID;
	infItem.Level = 1;
	infItem.SubLevel = 0;
	infItem.Name = rSkilInfo.SkillName;
	infItem.IconName = rSkilInfo.TexName;
	infItem.IconPanel = rSkilInfo.IconPanel;
	infItem.Description = rSkilInfo.SkillDesc;
	infItem.ShortcutType = 2;
	infItem.ItemType = 1;
	return infItem;
}

function PledgeBonusListHandler(string param)
{
	local int accessReward, huntReward;
	local SkillInfo mSkillInfo, tempSkillInfo;
	local ItemInfo mItemInfo, tempItemInfo;
	local int i, accessType, huntType;

	ParseInt(param, "AccessType", accessType);
	ParseInt(param, "HuntType", huntType);
	hasPledgeBonusList = true;
	i = 1;
	while((i < 5))
	{
		ParseInt(param, ("AccessReward" $ string(i)), accessReward);
		ParseInt(param, ("HuntReward" $ string(i)), huntReward);
		GetItemWindowHandle((((JoinWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin")).Clear();
		GetItemWindowHandle((((JoinWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin")).ClearTooltip();
		GetItemWindowHandle((((JoinWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin")).SetTooltipType("");
		GetItemWindowHandle((((HuntWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin")).Clear();
		GetItemWindowHandle((((HuntWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin")).ClearTooltip();
		GetItemWindowHandle((((HuntWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin")).SetTooltipType("");
		if((accessType == 1))
		{
			if((accessReward > 0))
			{
				mItemInfo = tempItemInfo;
				Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(accessReward), mItemInfo);
				addItemSlot(GetItemWindowHandle((((JoinWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin")), mItemInfo);
				GetItemWindowHandle((((JoinWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin")).SetTooltipType("Inventory");
			}
		}
		else if((accessReward > 0))
		{
			mSkillInfo = tempSkillInfo;
			GetSkillInfo(accessReward, 1, 0, mSkillInfo);
			addItemSlot(GetItemWindowHandle((((JoinWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin")), getItemInfoBySkillInfo(mSkillInfo));
			GetItemWindowHandle((((JoinWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin")).SetTooltipType("Skill");
		}
		if((huntType == 1))
		{
			if((huntReward > 0))
			{
				mItemInfo = tempItemInfo;
				Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(huntReward), mItemInfo);
				addItemSlot(GetItemWindowHandle((((HuntWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin")), mItemInfo);
				GetItemWindowHandle((((HuntWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin")).SetTooltipType("Inventory");
			}
			i++;
			continue;
		}
		if((huntReward > 0))
		{
			mSkillInfo = tempSkillInfo;
			GetSkillInfo(huntReward, 1, 0, mSkillInfo);
			addItemSlot(GetItemWindowHandle((((HuntWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin")), getItemInfoBySkillInfo(mSkillInfo));
			GetItemWindowHandle((((HuntWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin")).SetTooltipType("Skill");
		}
		i++;
	}
	return;
}

function setEnablePledgeBonus(int bonusType, int Index, bool bEnable)
{
	local ItemInfo Info;
	local string wndPath;

	if((bonusType == 0))
	{
		wndPath = JoinWndPath;
	}
	else
	{
		wndPath = HuntWndPath;
	}
	if((GetItemWindowHandle((((wndPath $ ".BonusItem") $ string(Index)) $ "_ItemWin")).GetItemNum() > 0))
	{
		GetItemWindowHandle((((wndPath $ ".BonusItem") $ string(Index)) $ "_ItemWin")).GetItem(0, Info);
		GetItemWindowHandle((((wndPath $ ".BonusItem") $ string(Index)) $ "_ItemWin")).Clear();
		if(bEnable)
		{
			Info.ForeTexture = "";
		}
		else
		{
			Info.ForeTexture = "L2UI_CT1.WindowDisable_BG";
		}
		GetItemWindowHandle((((wndPath $ ".BonusItem") $ string(Index)) $ "_ItemWin")).AddItem(Info);
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "FrameCloseButton":
			OnFrameCloseButtonClick();
			break;
		case "FrameResetButton":
			OnFrameResetButtonClick();
			break;
		case "CloseBtn":
		case "ClanRaid_CloseBtn":
			OnCloseBtnClick();
			break;
		case "Clan1_ManageBtn":
			OnClan1_ManageBtnClick();
			break;
		case "Clan2_ManageBtn":
			OnClan2_ManageBtnClick();
			break;
		case "HelpButton":
			OnHelpBtnClick();
			break;
		case "Ok_btn_Result":
			HandleOnClickOk();
			break;
		default:
			break;
	}
	return;
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	switch(a_ButtonHandle.GetWindowName())
	{
		case "ok_btn_buy":
			HandleClickBuy(a_ButtonHandle.GetParentWindowName());
			break;
		default:
			break;
	}
	return;
}

function OnHelpBtnClick()
{
	local string strParam;

	ParamAdd(strParam, "FilePath", (GetLocalizedL2TextPathNameUC() $ "Pledge_help001.htm"));
	ExecuteEvent(1210, strParam);
	return;
}

function OnFrameCloseButtonClick()
{
	Me.HideWindow();
	return;
}

function OnFrameResetButtonClick()
{
	PledgeBonusOpen();
	return;
}

function OnCloseBtnClick()
{
	Me.HideWindow();
	return;
}

function OnClan1_ManageBtnClick()
{
	PlaySound("ItemSound3.sys_bonus_login");
	PledgeBonusReward(0);
	return;
}

function OnClan2_ManageBtnClick()
{
	PlaySound("ItemSound3.sys_bonus_hunt");
	PledgeBonusReward(1);
	return;
}

function bool API_GetPledgeDonationData(PledgeDonationType _donationType, out PledgeDonationData Data)
{
	return GetPledgeDonationData(int(_donationType), Data);
}

function API_C_EX_PLEDGE_DONATION_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_PLEDGE_DONATION_INFO packet;

	if(IsPlayerOnWorldRaidServer())
	{
		return;
	}
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_PLEDGE_DONATION_INFO(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(708, stream);
	return;
}

function API_C_EX_PLEDGE_DONATION_REQUEST()
{
	local array<byte> stream;
	local UIPacket._C_EX_PLEDGE_DONATION_REQUEST packet;

	packet.cDonationType = int(DonationType);
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_PLEDGE_DONATION_REQUEST(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(709, stream);
	return;
}

function Handle_S_EX_PLEDGE_DONATION_INFO()
{
	local UIPacket._S_EX_PLEDGE_DONATION_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_PLEDGE_DONATION_INFO(packet))
	{
		return;
	}
	SetRemainCount(packet.nRemainCount);
	ShowDonaDisableWnd(((int(packet.bNewbie) == 1) || (clanWndClassicScr.m_clanID < 1)));
	return;
}

function Handle_S_EX_PLEDGE_DONATION_REQUEST()
{
	local UIPacket._S_EX_PLEDGE_DONATION_REQUEST packet;
	local string EffectName, donaName, successMsg, donationString;
	local ItemInfo iInfo;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_PLEDGE_DONATION_REQUEST(packet))
	{
		return;
	}
	if((packet.nResultType == 1))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4559));
		return;
	}
	else if((packet.nResultType == 2))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4217));
		return;
	}
	donationString = GetDonaTypeString(PledgeDonationType(packet.cDonationType));
	if((int(packet.bCritical) == 1))
	{
		switch(packet.cDonationType)
		{
			case 0:
				donaName = GetSystemString(441);
				EffectName = "LineageEffect.br_e_u014_turkey_atk4b";
				break;
			case 1:
				donaName = GetSystemString(13279);
				EffectName = "LineageEffect2.ui_upgrade_succ";
				break;
			case 2:
				donaName = GetSystemString(13699);
				EffectName = "LineageEffect_br.br_e_firebox_fire_b";
				break;
			default:
				break;
		}
		GetWindowHandle((((m_Windowname $ ".") $ m_ClanPledgeDonationWnd) $ ".DisableWnd")).ShowWindow();
		GetWindowHandle((((m_Windowname $ ".") $ m_ClanPledgeDonationWnd) $ ".CriticalResultWnd")).ShowWindow();
		GetWindowHandle((((m_Windowname $ ".") $ m_ClanPledgeDonationWnd) $ ".CriticalResultWnd")).SetFocus();
		GetTextBoxHandle((((m_Windowname $ ".") $ m_ClanPledgeDonationWnd) $ ".CriticalResultWnd.Title_txt")).SetText(MakeFullSystemMsg(GetSystemMessage(13386), donaName));
		GetEffectViewportWndHandle((((m_Windowname $ ".") $ m_ClanPledgeDonationWnd) $ ".CriticalResultWnd.EffectViewport")).SpawnEffect(EffectName);
		successMsg = GetSystemMessage(13385);
	}
	else
	{
		successMsg = GetSystemMessage(13383);
	}
	getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(successMsg, donationString));
	if((packet.rewardItem.nAmount > INT64(0)))
	{
		Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(packet.rewardItem.nItemClassID), iInfo);
		getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(13384), iInfo.Name, string(packet.rewardItem.nAmount)));
		MakeFullSystemMsg(GetSystemMessage(13386), donationString);
	}
	SetRemainCount(packet.nRemainCount);
	return;
}

function SetRaidSkill(int Index, int SkillID, int SkillLevel, int lastRaidPhase, int addStep)
{
	local string WindowName;
	local SkillInfo SkillInfo;
	local ItemInfo Info;
	local ItemID cID;
	local int levelGap, viewLevel;

	if(!GetSkillInfo(SkillID, SkillLevel, 0, SkillInfo))
	{
		return;
	}
	WindowName = ((((((m_Windowname $ ".") $ m_ClanPledgeRaidWindowName) $ ".") $ "Stage0") $ string(Index)) $ "_Window");
	cID.ClassID = SkillID;
	Info.Id = cID;
	Info.Level = SkillLevel;
	Info.Name = Class'NWindow.UIDATA_SKILL'.static.GetName(Info.Id, Info.Level, 0);
	Info.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(Info.Id, Info.Level, 0);
	Info.Description = Class'NWindow.UIDATA_SKILL'.static.GetDescription(Info.Id, Info.Level, 0);
	Info.AdditionalName = Class'NWindow.UIDATA_SKILL'.static.GetEnchantName(Info.Id, Info.Level, 0);
	viewLevel = (((Index + addStep) + 1) * 5);
	GetTextBoxHandle((WindowName $ ".StageLvNum_text")).SetText(string(viewLevel));
	GetTextBoxHandle((WindowName $ ".Skill_Name_text")).SetText(Info.Name);
	GetTextBoxHandle((WindowName $ ".Skill_LvNum_text")).SetText(string(SkillLevel));
	GetWindowHandle(WindowName).SetTooltipType("text");
	levelGap = (lastRaidPhase - viewLevel);
	if((levelGap >= 5))
	{
		GetTextureHandle((WindowName $ ".FlagComplete_Icon")).SetTexture("L2UI_EPIC.ClanWnd.ClanWnd_LvFlagCompleteIcon");
		GetTextureHandle((WindowName $ ".StageComplete_Icon")).SetTexture("L2UI_CT1.PledgeBonusWnd.PledgeStageComplete_Icon");
		GetTextureHandle((WindowName $ ".PledgeSelectPanel")).SetTexture("L2UI_CT1.EmptyBtn");
		GetWindowHandle(WindowName).SetTooltipText("");
		Info.bDisabled = 0;
	}
	else if((levelGap >= 0))
	{
		GetTextureHandle((WindowName $ ".FlagComplete_Icon")).SetTexture("L2UI_EPIC.ClanWnd.ClanWnd_LvFlagProcessingIcon");
		GetTextureHandle((WindowName $ ".StageComplete_Icon")).SetTexture("L2UI_CT1.PledgeBonusWnd.PledgeStageProcessing_Icon");
		GetTextureHandle((WindowName $ ".PledgeSelectPanel")).SetTexture("L2UI_CT1.PledgeBonusWnd.PledgeSelectPanel");
		GetWindowHandle(WindowName).SetTooltipText(GetSystemString(3351));
		Info.bDisabled = 0;
	}
	else
	{
		GetTextureHandle((WindowName $ ".FlagComplete_Icon")).SetTexture("L2UI_EPIC.ClanWnd.ClanWnd_LvFlagLockIcon");
		GetTextureHandle((WindowName $ ".StageComplete_Icon")).SetTexture("L2UI_CT1.PledgeBonusWnd.PledgeStageLock_Icon");
		GetTextureHandle((WindowName $ ".PledgeSelectPanel")).SetTexture("L2UI_CT1.PledgeBonusWnd.PledgeCover");
		GetWindowHandle(WindowName).SetTooltipText(GetSystemString(2496));
	}
	Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear((WindowName $ ".StageSkill_ItemWnd"));
	Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem((WindowName $ ".StageSkill_ItemWnd"), Info);
	return;
}

function int GetRaidChaseAddStep(int lastRaidPhase)
{
	local int i, addStepTotal, lastStepActive;

	addStepTotal = ((35 / 5) - 4);
	lastStepActive = (lastRaidPhase / 5);
	Debug(((("GetRaidChaseAddStep" @ string(lastRaidPhase)) @ string(addStepTotal)) @ string(lastStepActive)));
	i = 1;
	while((i <= addStepTotal))
	{
		if((lastStepActive <= i))
		{
			return (i - 1);
		}
		i++;
	}
	return addStepTotal;
}

function handleSetRaidSkillInfos(string param)
{
	local int i, skillCount, SkillID, skillLv, lastRaidPhase, addStep;

	ParseInt(param, "SkillCount", skillCount);
	ParseInt(param, "LastRaidPhase", lastRaidPhase);
	addStep = GetRaidChaseAddStep(lastRaidPhase);
	i = 0;
	while((i < 4))
	{
		ParseInt(param, ("SkillID_" $ string((i + addStep))), SkillID);
		ParseInt(param, ("SkillLV_" $ string((i + addStep))), skillLv);
		SetRaidSkill(i, SkillID, skillLv, lastRaidPhase, addStep);
		i++;
	}
	if((lastRaidPhase == 0))
	{
		GetTextBoxHandle(((((m_Windowname $ ".") $ m_ClanPledgeRaidWindowName) $ ".") $ "ClanRaidMyStage_Text")).SetText(GetSystemString(27));
	}
	else
	{
		GetTextBoxHandle(((((m_Windowname $ ".") $ m_ClanPledgeRaidWindowName) $ ".") $ "ClanRaidMyStage_Text")).SetText((GetSystemString(88) @ string(lastRaidPhase)));
	}
	return;
}

function SetRemainCount(int _donaRemainCount)
{
	donaRemainCount = _donaRemainCount;
	GetTextBoxHandle((((m_Windowname $ ".") $ m_ClanPledgeDonationWnd) $ ".CriticalResultWnd.Help_txt")).SetText(((GetSystemString(13572) @ ":") @ string(donaRemainCount)));
	HandleOnUpdateItemNormal();
	HandleOnUpdateItemFine();
	HandleOnUpdateItemPremium();
	return;
}

function InitDonationWnd()
{
	needItemListNormalScr = new Class'InterfaceClassic.UIControlNeedItemList';
	needItemListNormalScr.DelegateOnUpdateItem = HandleOnUpdateItemNormal;
	needItemListFineScr = new Class'InterfaceClassic.UIControlNeedItemList';
	needItemListFineScr.DelegateOnUpdateItem = HandleOnUpdateItemFine;
	needItemListPremiumlScr = new Class'InterfaceClassic.UIControlNeedItemList';
	needItemListPremiumlScr.DelegateOnUpdateItem = HandleOnUpdateItemPremium;
	SetDonationData(PDT_NORMAL, needItemListNormalScr);
	SetDonationData(PDT_GREAT, needItemListFineScr);
	SetDonationData(PDT_EXCELLENT, needItemListPremiumlScr);
	ShowDonaDisableWnd(true);
	return;
}

function SetDonationData(PledgeDonationType donaType, out UIControlNeedItemList itemNumListScr)
{
	local string donaWndNamePath;
	local RichListCtrlHandle RichListCtrl;
	local UIControlNeedItemList NeedItemList;
	local PledgeDonationData donaData;
	local int i;

	if(!API_GetPledgeDonationData(donaType, donaData))
	{
		return;
	}
	donaWndNamePath = GetDonationPath(donaType);
	RichListCtrl = GetRichListCtrlHandle((donaWndNamePath $ ".PrivateReward_List"));
	NeedItemList = new Class'InterfaceClassic.UIControlNeedItemList';
	NeedItemList.SetRichListControler(RichListCtrl);
	NeedItemList.StartNeedItemList(3);
	NeedItemList.SetHideMyNum(true);
	i = 0;
	while((i < donaData.PersonalRewards.Length))
	{
		NeedItemList.AddNeedItemClassID(donaData.PersonalRewards[i].ItemClassID, INT64(donaData.PersonalRewards[i].ItemCount));
		i++;
	}
	i = 0;
	while((i < donaData.PledgeRewards.Length))
	{
		NeedItemList.AddNeedItemClassID(donaData.PledgeRewards[i].ItemClassID, INT64(donaData.PledgeRewards[i].ItemCount));
		i++;
	}
	NeedItemList.SetBuyNum(INT64(1));
	RichListCtrl = GetRichListCtrlHandle((donaWndNamePath $ ".Cost_List"));
	itemNumListScr.SetRichListControler(RichListCtrl);
	itemNumListScr.SetFormType(NAMESIDE);
	itemNumListScr.StartNeedItemList(1);
	itemNumListScr.AddNeedItemClassID(donaData.DonationItem, donaData.DonationItemAmount);
	itemNumListScr.SetBuyNum(INT64(1));
	return;
}

function HandleOnUpdateItemNormal()
{
	if((needItemListNormalScr.GetCanBuy() && (donaRemainCount > 0)))
	{
		GetButtonHandle((GetDonationPath(PDT_NORMAL) $ ".ok_btn_buy")).EnableWindow();
	}
	else
	{
		GetButtonHandle((GetDonationPath(PDT_NORMAL) $ ".ok_btn_buy")).DisableWindow();
	}
	return;
}

function HandleOnUpdateItemFine()
{
	if((needItemListFineScr.GetCanBuy() && (donaRemainCount > 0)))
	{
		GetButtonHandle((GetDonationPath(PDT_GREAT) $ ".ok_btn_buy")).EnableWindow();
	}
	else
	{
		GetButtonHandle((GetDonationPath(PDT_GREAT) $ ".ok_btn_buy")).DisableWindow();
	}
	return;
}

function HandleOnUpdateItemPremium()
{
	if((needItemListPremiumlScr.GetCanBuy() && (donaRemainCount > 0)))
	{
		GetButtonHandle((GetDonationPath(PDT_EXCELLENT) $ ".ok_btn_buy")).EnableWindow();
	}
	else
	{
		GetButtonHandle((GetDonationPath(PDT_EXCELLENT) $ ".ok_btn_buy")).DisableWindow();
	}
	return;
}

function HandleOnClickOk()
{
	GetWindowHandle((((m_Windowname $ ".") $ m_ClanPledgeDonationWnd) $ ".CriticalResultWnd")).HideWindow();
	GetWindowHandle((((m_Windowname $ ".") $ m_ClanPledgeDonationWnd) $ ".DisableWnd")).HideWindow();
	return;
}

function ShowDonaDisableWnd(bool Show)
{
	if(Show)
	{
		GetWindowHandle((((m_Windowname $ ".") $ m_ClanPledgeDonationWnd) $ ".DisableWnd")).ShowWindow();
		GetWindowHandle((((m_Windowname $ ".") $ m_ClanPledgeDonationWnd) $ ".DisableWnd")).SetFocus();
		GetTextBoxHandle((((m_Windowname $ ".") $ m_ClanPledgeDonationWnd) $ ".DisableWnd.Desc_txt")).ShowWindow();
	}
	else
	{
		GetWindowHandle((((m_Windowname $ ".") $ m_ClanPledgeDonationWnd) $ ".DisableWnd")).HideWindow();
		GetTextBoxHandle((((m_Windowname $ ".") $ m_ClanPledgeDonationWnd) $ ".DisableWnd.Desc_txt")).HideWindow();
	}
	return;
}

function OnClickPopupCancel()
{
	clanWndClassicScr.GetPopupScript().Hide();
	return;
}

function OnClickPopupBuy()
{
	clanWndClassicScr.GetPopupScript().Hide();
	API_C_EX_PLEDGE_DONATION_REQUEST();
	return;
}

function HandleClickBuy(string parentname)
{
	local UIControlDialogAssets uicontrolDialogAssetScr;
	local PledgeDonationData donaData;

	uicontrolDialogAssetScr = clanWndClassicScr.GetPopupScript();
	uicontrolDialogAssetScr.SetDisableWindow(GetWindowHandle((((m_Windowname $ ".") $ m_ClanPledgeDonationWnd) $ ".DisableWnd")));
	uicontrolDialogAssetScr.DelegateOnCancel = OnClickPopupCancel;
	uicontrolDialogAssetScr.DelegateOnClickBuy = OnClickPopupBuy;
	uicontrolDialogAssetScr.SetUseBuyItem(false);
	uicontrolDialogAssetScr.SetUseNeedItem(true);
	uicontrolDialogAssetScr.SetUseNumberInput(false);
	uicontrolDialogAssetScr.StartNeedItemList(1);
	switch(parentname)
	{
		case "PremiumDonationWnd":
			DonationType = PDT_EXCELLENT;
			break;
		case "FineDonationWnd":
			DonationType = PDT_GREAT;
			break;
		case "NormalDonationWnd":
			DonationType = PDT_NORMAL;
			break;
		default:
			break;
	}
	uicontrolDialogAssetScr.SetDialogDesc(MakeFullSystemMsg(GetSystemMessage(13382), GetDonaTypeString(DonationType), string(donaRemainCount)));
	API_GetPledgeDonationData(DonationType, donaData);
	uicontrolDialogAssetScr.AddNeedItemClassID(donaData.DonationItem, donaData.DonationItemAmount);
	uicontrolDialogAssetScr.SetItemNum(1);
	uicontrolDialogAssetScr.Show();
	return;
}

function string GetDonationPath(PledgeDonationType donaType)
{
	switch(donaType)
	{
		case PDT_NORMAL:
			return (((m_Windowname $ ".") $ m_ClanPledgeDonationWnd) $ ".NormalDonationWnd");
		case PDT_GREAT:
			return (((m_Windowname $ ".") $ m_ClanPledgeDonationWnd) $ ".FineDonationWnd");
		case PDT_EXCELLENT:
			return (((m_Windowname $ ".") $ m_ClanPledgeDonationWnd) $ ".PremiumDonationWnd");
		default:
			return "";
	}
}

function string GetDonaTypeString(PledgeDonationType donaType)
{
	switch(donaType)
	{
		case PDT_NORMAL:
			return GetSystemString(13566);
		case PDT_GREAT:
			return GetSystemString(13567);
		case PDT_EXCELLENT:
			return GetSystemString(13568);
		default:
			return "";
	}
}

function int GetTobIndex()
{
	return tab.GetTopIndex();
}
