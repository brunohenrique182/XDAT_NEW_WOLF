class RankingWnd_InstanceZone extends UICommonAPI
	dependson(UIPacket);

const TIMER_ID = 1001114;
const REFRESH_DELAY = 600;

struct InzoneRankingUIInfo
{
	var int RankingScope;
	var int inzoneIndex;
	var int RankingID;
	var bool bCurrentSeason;
};

var WindowHandle Me;
var WindowHandle disableWnd;
var WindowHandle DisableWndList;
var ButtonHandle Top150Button;
var ButtonHandle MyRankingButton;
var ButtonHandle ShowLastWeekButton;
var ButtonHandle RankingHelpButton;
var RichListCtrlHandle RankingTab_RichList;
var TextureHandle ClanMark;
var TextureHandle ClanMarkClassic;
var TextureHandle RankingArrow;
var TextBoxHandle ClanNameText;
var TextBoxHandle levelText;
var TextBoxHandle ClassText;
var TextBoxHandle NameText;
var TextBoxHandle RankingEqualityText;
var TextBoxHandle MyRankingText;
var TextBoxHandle RankingText;
var TextBoxHandle MyPointText;
var TextBoxHandle ScoreText;
var UIControlGroupButtonAssets tabGroupButton;
var DetailStatusWnd DetailStatusWndScript;
var int nRanking;
var UserInfo myInfo;
var array<RankingInzoneUIData> _rankingInzoneDataList;
var InzoneRankingUIInfo _rankingUIInfo;

function Initialize()
{
	local string m_Windowname;
	local WindowHandle tabGroupButtonWindow;

	DetailStatusWndScript = DetailStatusWnd(GetScript("DetailStatusWnd"));
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	disableWnd = GetWindowHandle((m_Windowname $ ".DisableWnd"));
	DisableWndList = GetWindowHandle((m_Windowname $ ".RankingTabAllWnd.DisableWndList"));
	Top150Button = GetButtonHandle((m_Windowname $ ".RankingTabAllWnd.Top150Button"));
	MyRankingButton = GetButtonHandle((m_Windowname $ ".RankingTabAllWnd.MyRankingButton"));
	ShowLastWeekButton = GetButtonHandle((m_Windowname $ ".RankingTabAllWnd.ShowLastWeekButton"));
	RankingTab_RichList = GetRichListCtrlHandle((m_Windowname $ ".RankingTabAllWnd.RankingTab_RichList"));
	ClanMark = GetTextureHandle((m_Windowname $ ".ClanMark"));
	ClanMarkClassic = GetTextureHandle((m_Windowname $ ".ClanMarkClassic"));
	ClanNameText = GetTextBoxHandle((m_Windowname $ ".ClanNameText"));
	levelText = GetTextBoxHandle((m_Windowname $ ".LevelText"));
	ClassText = GetTextBoxHandle((m_Windowname $ ".ClassText"));
	NameText = GetTextBoxHandle((m_Windowname $ ".NameText"));
	RankingHelpButton = GetButtonHandle((m_Windowname $ ".RankingHelpButton"));
	RankingEqualityText = GetTextBoxHandle((m_Windowname $ ".RankingEqualityText"));
	RankingArrow = GetTextureHandle((m_Windowname $ ".RankingArrow"));
	MyRankingText = GetTextBoxHandle((m_Windowname $ ".MyRankingText"));
	tabGroupButtonWindow = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RankingTabAllWnd.UIControlGroupButtonAsset"));
	tabGroupButton = Class'InterfaceClassic.UIControlGroupButtonAssets'.static._InitScript(tabGroupButtonWindow);
	tabGroupButton._SetStartInfo("L2UI_NewTex.WindowTab.Tab_Opacity_Unselected", "L2UI_NewTex.WindowTab.Tab_Opacity_Selected", "L2UI_NewTex.WindowTab.Tab_Opacity_Unselected_Over", true);
	tabGroupButton._GetGroupButtonsInstance().DelegateOnClickButton = OnTabGroupBtnClicked;
	MyPointText = GetTextBoxHandle((m_Windowname $ ".MyPointText"));
	ScoreText = GetTextBoxHandle((m_Windowname $ ".ScoreText"));
	RankingTab_RichList.SetSelectedSelTooltip(false);
	RankingTab_RichList.SetAppearTooltipAtMouseX(true);
	RankingTab_RichList.SetTooltipType("RankingRewardInstanceZone");
	RankingTab_RichList.SetUseStripeBackTexture(false);
	RankingArrow.HideWindow();
	MyRankingText.SetText("");
	ScoreText.SetText("");
	MyPointText.SetText("");
	RankingEqualityText.SetText("");
	InitRankingUIInfo();
	InitRankingInzoneData();
	InitInzoneTabGroupButton();
	SetCusomTooltipAtHelpBtn();
	return;
}

function InitRankingInzoneData()
{
	_rankingInzoneDataList.Length = 0;
	GetRankingInzoneDataAll(_rankingInzoneDataList);
	return;
}

function InitRankingUIInfo()
{
	local InzoneRankingUIInfo defaultInfo;

	_rankingUIInfo = defaultInfo;
	_rankingUIInfo.bCurrentSeason = true;
	return;
}

function UpdateMYInfo()
{
	local Texture PledgeCrestTexture;
	local bool bPledgeCrestTexture;
	local int nClass, nLevel;

	GetPlayerInfo(myInfo);
	if(getInstanceUIData().GetIsLiveServer())
	{
		nClass = DetailStatusWndScript.getMainClassID();
		nLevel = DetailStatusWndScript.getMainLevel();
	}
	else
	{
		nClass = myInfo.nSubClass;
		nLevel = myInfo.nLevel;
	}
	levelText.SetText(("Lv." $ string(nLevel)));
	ClassText.SetText(GetClassType(nClass));
	ClanNameText.SetText(GetRankingClanName(myInfo.nClanID));
	NameText.SetText(ChinaHideName(myInfo.Name));
	bPledgeCrestTexture = Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(myInfo.nClanID, PledgeCrestTexture);
	if(getInstanceUIData().GetIsLiveServer())
	{
		ClanMarkClassic.HideWindow();
		if(bPledgeCrestTexture)
		{
			ClanMark.ShowWindow();
			ClanMark.SetTextureWithObject(PledgeCrestTexture);
		}
		else
		{
			ClanMark.HideWindow();
		}
	}
	else
	{
		ClanMark.HideWindow();
		if(bPledgeCrestTexture)
		{
			ClanMarkClassic.ShowWindow();
			ClanMarkClassic.SetTextureWithObject(PledgeCrestTexture);
		}
		else
		{
			ClanMarkClassic.HideWindow();
		}
	}
	return;
}

function SetCusomTooltipAtHelpBtn()
{
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText((" - " $ GetSystemString(14481)), getInstanceL2Util().White, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText((" - " $ GetSystemString(13019)), getInstanceL2Util().White, "", true, true);
	RankingHelpButton.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
	return;
}

function InitInzoneTabGroupButton()
{
	local int i;

	tabGroupButton._GetGroupButtonsInstance()._setShowButtonNum(_rankingInzoneDataList.Length);
	tabGroupButton._GetGroupButtonsInstance()._fixedWidth(160, 0);
	i = 0;
	while((i < _rankingInzoneDataList.Length))
	{
		tabGroupButton._GetGroupButtonsInstance()._setButtonText(i, GetInZoneNameWithZoneID(_rankingInzoneDataList[i].InstantZoneID));
		tabGroupButton._GetGroupButtonsInstance()._setButtonValue(i, _rankingInzoneDataList[i].RankingID);
		i++;
	}
	if((_rankingInzoneDataList.Length > 0))
	{
		tabGroupButton._GetGroupButtonsInstance()._setTopOrder(0, true);
		_rankingUIInfo.RankingID = _rankingInzoneDataList[0].RankingID;
		RankingTab_RichList.SetColumnString(4, GetScoreStringId(int(_rankingInzoneDataList[0].CheckType)));
	}
	return;
}

function SetMyRankingControls(UIPacket._S_EX_INZONE_RANKING_MY_INFO myInfo)
{
	local RankingInzoneUIData rankingData;
	local int changeRank;

	rankingData = GetRankingInzoneData(myInfo.nRankingID);
	changeRank = (myInfo.nPrevRank - myInfo.nRank);
	if((myInfo.nPrevRank == 0))
	{
		changeRank = 0;
	}
	if((changeRank > 0))
	{
		RankingArrow.ShowWindow();
		RankingArrow.SetTexture("L2UI_ct1.RankingWnd.RankingWnd_ArrowUp");
		RankingEqualityText.SetTextColor(GetColor(230, 101, 101, 255));
		RankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(changeRank)));
	}
	else if((changeRank < 0))
	{
		RankingArrow.ShowWindow();
		RankingArrow.SetTexture("L2UI_ct1.RankingWnd.RankingWnd_ArrowDown");
		RankingEqualityText.SetTextColor(GetColor(0, 170, 255, 255));
		RankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(changeRank)));
	}
	else
	{
		RankingArrow.HideWindow();
		RankingEqualityText.SetTextColor(GetColor(153, 153, 153, 255));
		RankingEqualityText.SetText("-");
	}
	if((myInfo.nRank == 0))
	{
		MyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), " - "));
	}
	else
	{
		MyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(myInfo.nRank)));
	}
	ScoreText.SetText(GetSystemString(GetScoreStringId(int(rankingData.CheckType))));
	if((int(rankingData.CheckType) == 0))
	{
		MyPointText.SetText(getInstanceL2Util().GetTimeStringBySec7(int(myInfo.nScore)));
	}
	else if((int(rankingData.CheckType) == 1))
	{
		MyPointText.SetText(MakeCostString(string(myInfo.nScore)));
	}
	else if((int(rankingData.CheckType) == 2))
	{
		MyPointText.SetText(MakeCostString(string(myInfo.nScore)));
	}
	return;
}

function AddRankingList(RankingInzoneUIData rankingData, UIPacket._PkInZoneRanker rankerInfo, bool isHighLight, bool isCurrentSeason)
{
	local RichListCtrlRowData rowData;
	local int i, j, rewardID;
	local string texStr, levelStr, ClanName, clanLvStr;
	local Color applyColor;
	local int nAddX, nAddY, nAddY2, changeRank;
	local SkillInfo tSkillInfo;
	local ItemInfo tItemInfo;
	local RankingInzoneRewardView tRewardInfo;

	rowData.cellDataList.Length = 5;
	changeRank = (rankerInfo.nPrevRank - rankerInfo.nRank);
	ClanName = rankerInfo.sPledgeName;
	clanLvStr = (("(Lv." $ string(rankerInfo.nPledgeLevel)) $ ")");
	if((rankerInfo.sPledgeName == ""))
	{
		ClanName = GetSystemString(431);
		clanLvStr = "-";
	}
	if(((rankerInfo.nRank <= 3) && (rankerInfo.nRank > 0)))
	{
		if((rankerInfo.nRank == 1))
		{
			texStr = "L2UI_ct1.RankingWnd.RankingWnd_1st";
		}
		else if((rankerInfo.nRank == 2))
		{
			texStr = "L2UI_ct1.RankingWnd.RankingWnd_2nd";
		}
		else if((rankerInfo.nRank == 3))
		{
			texStr = "L2UI_ct1.RankingWnd.RankingWnd_3rd";
		}
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, texStr, 38, 33, 10, 5);
		applyColor = GetColor(254, 215, 160, 255);
		nAddY = 12;
		nAddX = 6;
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, string(rankerInfo.nRank), GetColor(170, 153, 119, 255), false, 20, 10);
		applyColor = GetColor(240, 240, 240, 255);
		nAddY = 4;
		nAddX = 10;
	}
	levelStr = (("(Lv." $ string(rankerInfo.nLevel)) $ ")");
	if((isCurrentSeason == true))
	{
		if(((rankerInfo.nPrevRank > 150) || (rankerInfo.nPrevRank == 0)))
		{
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, "NEW", GetColor(0, 255, 0, 255), false, nAddX, (nAddY - 4));
		}
		else if((changeRank > 0))
		{
			addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_CT1.RankingWnd.RankingWnd_ArrowUp", 8, 8, 6, nAddY);
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, string(changeRank), GetColor(230, 101, 101, 255), false, 2, -4);
		}
		else if((changeRank == 0))
		{
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, "-", GetColor(153, 153, 153, 255), false, nAddX, (nAddY - 4));
		}
		else
		{
			addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_CT1.RankingWnd.RankingWnd_ArrowDown", 8, 8, 6, nAddY);
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, string(changeRank), GetColor(0, 170, 255, 255), false, 2, -4);
		}
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, "-", GetColor(153, 153, 153, 255), false, nAddX, (nAddY - 4));
	}
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, (ChinaHideName(rankerInfo.sUserName) @ levelStr), applyColor, false, 4, -4);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, ClanName, applyColor, false, 5, 0);
	applyColor = GetColor(182, 182, 182, 255);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, getRaceSystemString(rankerInfo.nRace), applyColor, true, 3, 2);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, clanLvStr, applyColor, true, 5, 0);
	rowData.cellDataList[0].szData = ChinaHideName(rankerInfo.sUserName);
	rowData.cellDataList[1].szData = levelStr;
	rowData.cellDataList[2].szData = GetClassType(rankerInfo.nClass);
	rowData.cellDataList[3].szData = ClanName;
	rowData.cellDataList[4].szData = getRaceSystemString(rankerInfo.nRace);
	nAddY = 1;
	nAddY2 = 2;
	i = 0;
	while((i < rankingData.RewardViewList.Length))
	{
		tRewardInfo = rankingData.RewardViewList[i];
		if(((tRewardInfo.MinRank <= rankerInfo.nRank) && (tRewardInfo.MaxRank >= rankerInfo.nRank)))
		{
			j = 0;
			while((j < tRewardInfo.RewardIDList.Length))
			{
				addRichListCtrlTexture(rowData.cellDataList[3].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 6, nAddY);
				rewardID = tRewardInfo.RewardIDList[j];
				if((int(rankingData.RewardType) == 0))
				{
					tItemInfo = GetItemInfoByClassID(rewardID);
					tItemInfo.ItemNum = INT64(tRewardInfo.RewardAmountList[j]);
					tItemInfo.bShowCount = true;
					AddRichListCtrlItem(rowData.cellDataList[3].drawitems, tItemInfo, 32, 32, -34, nAddY2);
				}
				else
				{
					GetSkillInfo(rewardID, 1, 0, tSkillInfo);
					addRichListCtrlTexture(rowData.cellDataList[3].drawitems, tSkillInfo.TexName, 32, 32, -34, nAddY2);
					rowData.cellDataList[3].drawitems[(rowData.cellDataList[3].drawitems.Length - 1)].nReservedTooltipID = rewardID;
					rowData.cellDataList[3].drawitems[(rowData.cellDataList[3].drawitems.Length - 1)].TooltipDesc = "on";
				}
				nAddY = -2;
				nAddY2 = 2;
				j++;
			}
		}
		i++;
	}
	if((int(rankingData.CheckType) == 0))
	{
		AddRichListCtrlString(rowData.cellDataList[4].drawitems, getInstanceL2Util().GetTimeStringBySec7(int(rankerInfo.nScore)), applyColor, false, 5, 0);
	}
	else if((int(rankingData.CheckType) == 1))
	{
		AddRichListCtrlString(rowData.cellDataList[4].drawitems, MakeCostString(string(rankerInfo.nScore)), applyColor, false, 5, 0);
	}
	else if((int(rankingData.CheckType) == 2))
	{
		AddRichListCtrlString(rowData.cellDataList[4].drawitems, MakeCostString(string(rankerInfo.nScore)), applyColor, false, 5, 0);
	}
	if(isHighLight)
	{
		rowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_MyRankBg";
	}
	else
	{
		rowData.sOverlayTex = "L2UI_CT1.EmptyBtn";
	}
	rowData.OverlayTexU = 734;
	rowData.OverlayTexV = 45;
	RankingTab_RichList.InsertRecord(rowData);
	return;
}

function ShowDisableWnd()
{
	disableWnd.ShowWindow();
	RankingWnd(GetScript("RankingWnd")).tabDisable(true);
	Me.SetTimer(1001114, 600);
	return;
}

function hideDisableWnd()
{
	disableWnd.HideWindow();
	RankingWnd(GetScript("RankingWnd")).tabDisable(false);
	Me.KillTimer(1001114);
	return;
}

function UpdateSeasonButton()
{
	if(_rankingUIInfo.bCurrentSeason)
	{
		ShowLastWeekButton.SetTexture("L2UI_ct1.Button.Button_DF", "L2UI_ct1.Button.Button_DF_Click", "L2UI_ct1.Button.Button_DF_Over");
		ShowLastWeekButton.SetButtonName(3707);
	}
	else
	{
		ShowLastWeekButton.SetTexture("L2UI_ct1.Button.Button_DF", "L2UI_ct1.Button.Button_DF_Click", "L2UI_ct1.Button.Button_DF_Over");
		ShowLastWeekButton.SetButtonName(3706);
	}
	return;
}

function UpdateScopeButton()
{
	if((_rankingUIInfo.RankingScope == 0))
	{
		Top150Button.SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Down");
		MyRankingButton.SetTexture("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Over");
	}
	else
	{
		MyRankingButton.SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Down");
		Top150Button.SetTexture("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Over");
	}
	return;
}

function UpdateUIControls()
{
	UpdateMYInfo();
	UpdateScopeButton();
	UpdateSeasonButton();
	return;
}

function string GetRankingClanName(int clanID)
{
	if((myInfo.nClanID > 0))
	{
		return GetClanName(clanID);
	}
	else
	{
		return GetSystemString(431);
	}
}

function int GetScoreStringId(int scoreType)
{
	switch(scoreType)
	{
		case 0:
			if(((((int(GetLanguage()) == 8) || (int(GetLanguage()) == 9)) || (int(GetLanguage()) == 12)) || (int(GetLanguage()) == 14)))
			{
				return 5294;
			}
			else
			{
				return 1110;
			}
			break;
		case 1:
			return 3549;
			break;
		case 2:
			return 831;
			break;
		default:
			return 831;
			break;
	}
}

function RankingInzoneUIData GetRankingInzoneData(int RankingID)
{
	local RankingInzoneUIData defaultData;
	local int i;

	i = 0;
	while((i < _rankingInzoneDataList.Length))
	{
		if((_rankingInzoneDataList[i].RankingID == RankingID))
		{
			return _rankingInzoneDataList[i];
		}
		i++;
	}
	return defaultData;
}

function RankingInzoneUIData GetRankingInzoneDataByIndex(int Index)
{
	local RankingInzoneUIData defaultData;

	if((Index < _rankingInzoneDataList.Length))
	{
		defaultData = _rankingInzoneDataList[Index];
	}
	return defaultData;
}

function RequestInstanceZoneRankingInfo()
{
	if((Me.IsShowWindow() == false))
	{
		return;
	}
	ShowDisableWnd();
	Debug(((("RequestInstanceZoneRankingInfo :" @ string(_rankingUIInfo.RankingID)) @ string(_rankingUIInfo.RankingScope)) @ string(_rankingUIInfo.bCurrentSeason)));
	Rq_C_EX_INZONE_RANKING_MY_INFO(_rankingUIInfo.RankingID);
	Rq_C_EX_INZONE_RANKING_LIST(_rankingUIInfo.RankingID, _rankingUIInfo.RankingScope, _rankingUIInfo.bCurrentSeason);
	return;
}

function Rq_C_EX_INZONE_RANKING_MY_INFO(int RankingID)
{
	local array<byte> stream;
	local UIPacket._C_EX_INZONE_RANKING_MY_INFO packet;

	packet.nRankingID = RankingID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_INZONE_RANKING_MY_INFO(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(851, stream);
	return;
}

function Rq_C_EX_INZONE_RANKING_LIST(int RankingID, int RankingScope, bool bCurrentSeason)
{
	local array<byte> stream;
	local UIPacket._C_EX_INZONE_RANKING_LIST packet;

	packet.nRankingID = RankingID;
	packet.cRankingScope = RankingScope;
	packet.bCurrentSeason = byte(bCurrentSeason);
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_INZONE_RANKING_LIST(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(852, stream);
	return;
}

function Rs_S_EX_INZONE_RANKING_MY_INFO()
{
	local UIPacket._S_EX_INZONE_RANKING_MY_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_INZONE_RANKING_MY_INFO(packet))
	{
		return;
	}
	Debug((((("S_EX_INZONE_RANKING_MY_INFO" @ string(packet.nRankingID)) @ string(packet.nScore)) @ string(packet.nRank)) @ string(packet.nPrevRank)));
	SetMyRankingControls(packet);
	return;
}

function Rs_S_EX_INZONE_RANKING_LIST()
{
	local UIPacket._S_EX_INZONE_RANKING_LIST packet;
	local RankingInzoneUIData rankingData;
	local UIPacket._PkInZoneRanker rankerInfo;
	local int i, myRankingIndex, StartRow;
	local UserInfo PlayerInfo;
	local bool isMyRanking;
	local string myClanName;

	myRankingIndex = -1;
	GetPlayerInfo(PlayerInfo);
	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_INZONE_RANKING_LIST(packet))
	{
		return;
	}
	Debug((((("S_EX_INZONE_RANKING_LIST" @ string(packet.nRankingID)) @ string(packet.rankers.Length)) @ string(packet.cRankingScope)) @ string(packet.bCurrentSeason)));
	rankingData = GetRankingInzoneData(packet.nRankingID);
	myClanName = GetRankingClanName(PlayerInfo.nClanID);
	RankingTab_RichList.SetColumnString(4, GetScoreStringId(int(rankingData.CheckType)));
	RankingTab_RichList.DeleteAllItem();
	i = 0;
	while((i < packet.rankers.Length))
	{
		rankerInfo = packet.rankers[i];
		if((((int(rankingData.EnterType) == 0) && (rankerInfo.sUserName == PlayerInfo.Name)) || ((int(rankingData.EnterType) == 1) && (rankerInfo.sPledgeName == myClanName))))
		{
			isMyRanking = true;
			myRankingIndex = i;
		}
		else
		{
			isMyRanking = false;
		}
		AddRankingList(rankingData, rankerInfo, isMyRanking, bool(packet.bCurrentSeason));
		i++;
	}
	if((RankingTab_RichList.GetRecordCount() > 0))
	{
		DisableWndList.HideWindow();
		if((myRankingIndex >= 0))
		{
			StartRow = (myRankingIndex - 3);
			if((StartRow > 0))
			{
				if((RankingTab_RichList.GetRecordCount() > StartRow))
				{
					RankingTab_RichList.SetStartRow(StartRow);
				}
			}
		}
	}
	else
	{
		DisableWndList.ShowWindow();
	}
	RankingTab_RichList.SetFocus();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9750:
			InitRankingUIInfo();
			InitRankingInzoneData();
			InitInzoneTabGroupButton();
			break;
		case EV_PacketID(1107):
			Rs_S_EX_INZONE_RANKING_MY_INFO();
			break;
		case EV_PacketID(1108):
			Rs_S_EX_INZONE_RANKING_LIST();
			break;
		default:
			break;
	}
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEvent(EV_PacketID(1107));
	RegisterEvent(EV_PacketID(1108));
	return;
}

event OnTimer(int TimeID)
{
	if((TimeID == 1001114))
	{
		hideDisableWnd();
	}
	return;
}

event OnTabGroupBtnClicked(string parentWndName, string strName, int Index)
{
	_rankingUIInfo.inzoneIndex = Index;
	_rankingUIInfo.RankingID = GetRankingInzoneDataByIndex(Index).RankingID;
	RequestInstanceZoneRankingInfo();
	return;
}

event OnLoad()
{
	Initialize();
	return;
}

event OnShow()
{
	if(GetWindowHandle("RankingWnd").IsShowWindow())
	{
		DisableWndList.HideWindow();
		UpdateUIControls();
		RequestInstanceZoneRankingInfo();
	}
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "Top150Button":
			_rankingUIInfo.RankingScope = 0;
			UpdateScopeButton();
			RequestInstanceZoneRankingInfo();
			break;
		case "MyRankingButton":
			_rankingUIInfo.RankingScope = 1;
			UpdateScopeButton();
			RequestInstanceZoneRankingInfo();
			break;
		case "ShowLastWeekButton":
			_rankingUIInfo.bCurrentSeason = !_rankingUIInfo.bCurrentSeason;
			UpdateSeasonButton();
			RequestInstanceZoneRankingInfo();
			break;
		default:
			break;
	}
	return;
}
