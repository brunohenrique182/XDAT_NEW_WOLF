class ClanPledgeBonusDrawerWnd extends UICommonAPI;

const ACCESS_TYPE = 0;
const HUNT_TYPE = 1;

var WindowHandle Me;
var ItemWindowHandle JoinYesterdayBonus_Item_ItemWnd;
var ItemWindowHandle HuntYesterdayBonus_Item_ItemWnd;
var string JoinWndPath;
var string HuntWndPath;
var bool hasPledgeBonusList;
var string m_Windowname;
var int accessBonusMax;
var int huntBonusMax;

function OnRegisterEvent()
{
	RegisterEvent(20190);
	RegisterEvent(20191);
	RegisterEvent(20193);
	RegisterEvent(20192);
	RegisterEvent(40);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function Initialize()
{
	JoinWndPath = (m_Windowname $ ".JoinBonusWnd");
	HuntWndPath = (m_Windowname $ ".HuntBonusWnd");
	Me = GetWindowHandle(m_Windowname);
	JoinYesterdayBonus_Item_ItemWnd = GetItemWindowHandle((m_Windowname $ ".JoinBonusWnd.JoinYesterdayBonus_Item_ItemWnd"));
	HuntYesterdayBonus_Item_ItemWnd = GetItemWindowHandle((m_Windowname $ ".HuntBonusWnd.HuntYesterdayBonus_Item_ItemWnd"));
	hasPledgeBonusList = false;
	return;
}

function OnShow()
{
	if(GetWindowHandle("ClanDrawerWnd").IsShowWindow())
	{
		ClanDrawerWnd(GetScript("ClanDrawerWnd")).HideClanWindow();
	}
	return;
}

function OnEvent(int a_EventID, string param)
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		return;
	}
	switch(a_EventID)
	{
		case 20190:
			if(!Me.IsShowWindow())
			{
				Me.ShowWindow();
			}
			PledgeBonusOpenHandler(param);
			break;
		case 20191:
			PledgeBonusListHandler(param);
			break;
		case 20192:
			hasPledgeBonusList = false;
			Me.HideWindow();
			break;
		case 20193:
			PlegeBonusUpdate(param);
			break;
		case 40:
			hasPledgeBonusList = false;
			Me.HideWindow();
			break;
		default:
			break;
	}
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

	if(!Me.IsShowWindow())
	{
		Me.ShowWindow();
	}
	ParseInt(param, "AccessBonusMax", AccessRewardType);
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
			GetTextBoxHandle((JoinWndPath $ ".JoinYesterdayBonusLV_Text")).SetText(("Lv" $ string(accessRewardSkillLV)));
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
		if((AccessRewardType == 1))
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
		GetTextBoxHandle((HuntWndPath $ ".HuntYesterdaydayBonusLV_Text")).SetText(("Lv" $ string(huntRewardLV)));
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
	local float maxStep;
	local int nProgressStep;
	local float fProgressStep;
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
	nProgressStep = int((maxStep / 3.0000000));
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

function bool getHasPledgeBonusList()
{
	return hasPledgeBonusList;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="ClanPledgeBonusDrawerWnd"
}
