class RankingWnd_Pvp extends UICommonAPI
	dependson(UIPacket);

const TIMER_ID = 1001113;
const REFRESH_DELAY = 600;

var WindowHandle Me;
var WindowHandle disableWnd;
var TextureHandle RaceMark;
var TextureHandle RankingFlag;
var TextureHandle ClanMarkClassic;
var TextureHandle ClanMark;
var TextureHandle ClanBg;
var TextBoxHandle ClanNameText;
var TextBoxHandle levelText;
var TextBoxHandle ClassText;
var TextBoxHandle NameText;
var ButtonHandle RankingHelpButton;
var TextBoxHandle ServerRankingText;
var TextureHandle ServerRankingArrow;
var TextBoxHandle ServerRankingEqualityText;
var TextBoxHandle ServerMyRankingText;
var TextureHandle ServerRankingBg;
var TextBoxHandle PvpPointText;
var TextBoxHandle PvpMyPointText;
var TextureHandle PvpPointBg;
var TextBoxHandle PvpScoreText;
var HtmlHandle PvpMyScoreKillText;
var HtmlHandle PvpMyScoreDeathText;
var TextureHandle PvpScoreBg;
var TextureHandle RankingTrophy;
var TextureHandle RankingPattern;
var TextureHandle RankingBg1;
var WindowHandle RankingTabAllWnd;
var ButtonHandle Top150Button;
var ButtonHandle MyRankingButton;
var ButtonHandle ShowLastWeekButton;
var WindowHandle DisableWndList;
var TextBoxHandle List_Empty;
var WindowHandle RaceComboboxWnd;
var TextBoxHandle RaceCategoryText;
var ComboBoxHandle RaceCategoryCombobox;
var TextureHandle ServerRichListFrame;
var RichListCtrlHandle RankingTab_RichList;
var TextureHandle RankingBg2;
var TabHandle TabCtrl2;
var TextureHandle TabLineBg2;
var TextureHandle TabBg2;
var DetailStatusWnd DetailStatusWndScript;
var string m_Windowname;
var int nRanking;
var UserInfo myInfo;
var int nRankingGroup;
var int nRankingScope;
var UIEventManager.RankingScope currentRankingScope;
var UIEventManager.RankingGroup currentRankingGroup;
var bool bIAmRanker;
var int myRankingInList;
var bool isFirstInit;
var bool bCurrentSeason;

function OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEvent(40);
	RegisterEvent((100000 + 886));
	RegisterEvent((100000 + 887));
	return;
}

function OnLoad()
{
	Initialize();
	return;
}

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	DetailStatusWndScript = DetailStatusWnd(GetScript("DetailStatusWnd"));
	Me = GetWindowHandle("RankingWnd_Pvp");
	disableWnd = GetWindowHandle((m_Windowname $ ".DisableWnd"));
	RaceMark = GetTextureHandle((m_Windowname $ ".RaceMark"));
	RankingFlag = GetTextureHandle((m_Windowname $ ".RankingFlag"));
	ClanMarkClassic = GetTextureHandle((m_Windowname $ ".ClanMarkClassic"));
	ClanMark = GetTextureHandle((m_Windowname $ ".ClanMark"));
	ClanBg = GetTextureHandle((m_Windowname $ ".ClanBg"));
	ClanNameText = GetTextBoxHandle((m_Windowname $ ".ClanNameText"));
	levelText = GetTextBoxHandle((m_Windowname $ ".LevelText"));
	ClassText = GetTextBoxHandle((m_Windowname $ ".ClassText"));
	NameText = GetTextBoxHandle((m_Windowname $ ".NameText"));
	RankingHelpButton = GetButtonHandle((m_Windowname $ ".RankingHelpButton"));
	ServerRankingText = GetTextBoxHandle((m_Windowname $ ".ServerRankingText"));
	ServerRankingArrow = GetTextureHandle((m_Windowname $ ".ServerRankingArrow"));
	ServerRankingEqualityText = GetTextBoxHandle((m_Windowname $ ".ServerRankingEqualityText"));
	ServerMyRankingText = GetTextBoxHandle((m_Windowname $ ".ServerMyRankingText"));
	ServerRankingBg = GetTextureHandle((m_Windowname $ ".ServerRankingBg"));
	PvpPointText = GetTextBoxHandle((m_Windowname $ ".PvpPointText"));
	PvpMyPointText = GetTextBoxHandle((m_Windowname $ ".PvpMyPointText"));
	PvpPointBg = GetTextureHandle((m_Windowname $ ".PvpPointBg"));
	PvpScoreText = GetTextBoxHandle((m_Windowname $ ".PvpScoreText"));
	PvpMyScoreKillText = GetHtmlHandle((m_Windowname $ ".PvpMyScoreKillText"));
	PvpMyScoreDeathText = GetHtmlHandle((m_Windowname $ ".PvpMyScoreDeathText"));
	PvpScoreBg = GetTextureHandle((m_Windowname $ ".PvpScoreBg"));
	RankingTrophy = GetTextureHandle((m_Windowname $ ".RankingTrophy"));
	RankingPattern = GetTextureHandle((m_Windowname $ ".RankingPattern"));
	RankingBg1 = GetTextureHandle((m_Windowname $ ".RankingBg1"));
	RankingTabAllWnd = GetWindowHandle((m_Windowname $ ".RankingTabAllWnd"));
	Top150Button = GetButtonHandle((m_Windowname $ ".RankingTabAllWnd.Top150Button"));
	MyRankingButton = GetButtonHandle((m_Windowname $ ".RankingTabAllWnd.MyRankingButton"));
	ShowLastWeekButton = GetButtonHandle((m_Windowname $ ".RankingTabAllWnd.ShowLastWeekButton"));
	DisableWndList = GetWindowHandle((m_Windowname $ ".RankingTabAllWnd.DisableWndList"));
	List_Empty = GetTextBoxHandle((m_Windowname $ ".RankingTabAllWnd.DisableWndList.List_Empty"));
	RaceComboboxWnd = GetWindowHandle((m_Windowname $ ".RankingTabAllWnd.RaceComboboxWnd"));
	RaceCategoryText = GetTextBoxHandle((m_Windowname $ ".RankingTabAllWnd.RaceComboboxWnd.RaceCategoryText"));
	RaceCategoryCombobox = GetComboBoxHandle((m_Windowname $ ".RankingTabAllWnd.RaceComboboxWnd.RaceCategoryCombobox"));
	ServerRichListFrame = GetTextureHandle((m_Windowname $ ".RankingTabAllWnd.ServerRichListFrame"));
	RankingTab_RichList = GetRichListCtrlHandle((m_Windowname $ ".RankingTabAllWnd.RankingTab_RichList"));
	RankingBg2 = GetTextureHandle((m_Windowname $ ".RankingTabAllWnd.RankingBg2"));
	TabCtrl2 = GetTabHandle((m_Windowname $ ".RankingTabAllWnd.TabCtrl2"));
	TabLineBg2 = GetTextureHandle((m_Windowname $ ".RankingTabAllWnd.TabLineBg2"));
	TabBg2 = GetTextureHandle((m_Windowname $ ".RankingTabAllWnd.TabBg2"));
	RankingTab_RichList.SetSelectedSelTooltip(false);
	RankingTab_RichList.SetAppearTooltipAtMouseX(true);
	RankingTab_RichList.SetUseStripeBackTexture(false);
	RankingTab_RichList.SetTooltipType("RankingPvp");
	SetCusomTooltipAtHelpBtn();
	return;
}

function OnShow()
{
	if(GetWindowHandle("RankingWnd").IsShowWindow())
	{
		DisableWndList.HideWindow();
		OnRefreshButtonClick();
	}
	return;
}

function OnHide()
{
	return;
}

function OnTimer(int TimeID)
{
	if((TimeID == 1001113))
	{
		hideDisableWnd();
	}
	return;
}

function OnComboBoxItemSelected(string strID, int Index)
{
	OnRefreshButtonClick();
	return;
}

function initRaceCombo()
{
	local int i;

	RaceCategoryCombobox.Clear();
	if(getInstanceUIData().GetIsLiveServer())
	{
		i = 0;
		while((i < 7))
		{
			RaceCategoryCombobox.AddString(getRaceSystemString(i));
			i++;
		}
	}
	else
	{
		i = 0;
		while((i < 6))
		{
			RaceCategoryCombobox.AddString(getRaceSystemString(i));
			i++;
		}
		if(IsAdenServer())
		{
			RaceCategoryCombobox.AddString(getRaceSystemString(30));
			RaceCategoryCombobox.AddString(getRaceSystemString(31));
		}
	}
	return;
}

function OnRClickButton(string Name)
{
	switch(Name)
	{
		case "TabCtrl20":
		case "TabCtrl21":
		case "TabCtrl22":
		case "TabCtrl23":
			setTabState(Name);
			OnRefreshButtonClick();
			break;
		default:
			break;
	}
	return;
}

function setTabState(string TabName)
{
	switch(TabName)
	{
		case "TabCtrl20":
			SettingButton(Top150Button, true, 13016);
			SettingButton(MyRankingButton, true, 13017);
			RaceComboboxWnd.HideWindow();
			currentRankingGroup = ServerGroup;
			break;
		case "TabCtrl21":
			SettingButton(Top150Button, true, 3972);
			SettingButton(MyRankingButton, true, 3975);
			currentRankingGroup = RaceGroup;
			break;
		case "TabCtrl22":
			SettingButton(Top150Button, false);
			SettingButton(MyRankingButton, false);
			RaceComboboxWnd.HideWindow();
			currentRankingGroup = Pledge;
			break;
		case "TabCtrl23":
			SettingButton(Top150Button, false);
			SettingButton(MyRankingButton, false);
			RaceComboboxWnd.HideWindow();
			currentRankingGroup = Friends;
			break;
		default:
			break;
	}
	return;
}

function setLikeRadioButton(string buttonName)
{
	if((buttonName == "Top150Button"))
	{
		Top150Button.SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Down");
		MyRankingButton.SetTexture("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Over");
		currentRankingScope = TopN;
	}
	else if((buttonName == "MyRankingButton"))
	{
		MyRankingButton.SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Down");
		Top150Button.SetTexture("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Over");
		currentRankingScope = AroundMe;
	}
	return;
}

function SettingButton(ButtonHandle btn, bool bShow, optional int nSystemString)
{
	if(bShow)
	{
		btn.ShowWindow();
		btn.SetNameText(GetSystemString(nSystemString));
	}
	else
	{
		btn.HideWindow();
	}
	return;
}

function OnRefreshButtonClick()
{
	checkVisibleCombo();
	API_C_EX_PVP_RANKING_MY_INFO();
	API_C_EX_PVP_RANKING_LIST();
	setMYInfo();
	setDisableWnd();
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "RankingHelpButton":
			break;
		case "Top150Button":
			setLikeRadioButton(Name);
			OnRefreshButtonClick();
			break;
		case "MyRankingButton":
			setLikeRadioButton(Name);
			OnRefreshButtonClick();
			break;
		case "ShowLastWeekButton":
			bCurrentSeason = !bCurrentSeason;
			setToggleSeasonButton();
			OnRefreshButtonClick();
			break;
		case "TabCtrl20":
		case "TabCtrl21":
		case "TabCtrl22":
		case "TabCtrl23":
			setTabState(Name);
			OnRefreshButtonClick();
			break;
		default:
			break;
	}
	return;
}

function InitData()
{
	isFirstInit = false;
	bCurrentSeason = true;
	setToggleSeasonButton();
	setTabState("TabCtrl20");
	setLikeRadioButton("Top150Button");
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9750:
			InitData();
			break;
		case EV_PacketID(886):
			ParsePacket_S_EX_PVP_RANKING_MY_INFO();
			break;
		case EV_PacketID(887):
			ParsePacket_S_EX_PVP_RANKING_LIST();
			break;
		case 40:
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_PVP_RANKING_MY_INFO()
{
	local UIPacket._S_EX_PVP_RANKING_MY_INFO packet;
	local string htmlAdd;
	local int nChangeRank;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_PVP_RANKING_MY_INFO(packet))
	{
		return;
	}
	Debug((((((" -->  Decode_S_EX_PVP_RANKING_MY_INFO :  " @ string(packet.nPVPPoint)) @ string(packet.nRank)) @ string(packet.nPrevRank)) @ string(packet.nKillCount)) @ string(packet.nDieCount)));
	if((packet.nPrevRank == 0))
	{
		nChangeRank = 0;
	}
	else
	{
		nChangeRank = (packet.nPrevRank - packet.nRank);
	}
	if((nChangeRank > 0))
	{
		ServerRankingArrow.ShowWindow();
		ServerRankingArrow.SetTexture("L2UI_CT1.RankingWnd.RankingWnd_ArrowUp");
		ServerRankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(nChangeRank)));
		ServerRankingEqualityText.SetTextColor(getInstanceL2Util().Red);
	}
	else if((nChangeRank < 0))
	{
		ServerRankingArrow.ShowWindow();
		ServerRankingArrow.SetTexture("L2UI_CT1.RankingWnd.RankingWnd_ArrowDown");
		ServerRankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(nChangeRank)));
		ServerRankingEqualityText.SetTextColor(getInstanceL2Util().Blue);
	}
	else
	{
		ServerRankingEqualityText.SetText("-");
		ServerRankingEqualityText.SetTextColor(getInstanceL2Util().Gray);
		ServerRankingArrow.HideWindow();
	}
	PvpMyPointText.SetText(MakeCostStringINT64(packet.nPVPPoint));
	htmlAdd = (htmlAdd $ htmlAddText((GetSystemString(2240) $ ": "), "", getColorHexString(GTColor().Blue)));
	htmlAdd = (htmlAdd $ htmlAddText(string(packet.nKillCount), "", getColorHexString(GTColor().White)));
	PvpMyScoreKillText.LoadHtmlFromString(htmlSetHtmlStart(htmlAdd));
	htmlAdd = "";
	htmlAdd = (htmlAdd $ htmlAddText((GetSystemString(13412) $ ": "), "", getColorHexString(GTColor().Red)));
	htmlAdd = (htmlAdd $ htmlAddText(string(packet.nDieCount), "", getColorHexString(GTColor().White)));
	PvpMyScoreDeathText.LoadHtmlFromString(htmlSetHtmlStart(htmlAdd));
	ServerMyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(packet.nRank)));
	return;
}

function ParsePacket_S_EX_PVP_RANKING_LIST()
{
	local UIPacket._S_EX_PVP_RANKING_LIST packet;
	local int i, nChangeRank, nRankingGroupTm, nRankingScopeTm;
	local string PledgeName;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_PVP_RANKING_LIST(packet))
	{
		return;
	}
	if(isSameEventWithCurrentState(int(currentRankingGroup), int(currentRankingScope), packet.cRankingGroup, packet.cRankingScope))
	{
		RankingTab_RichList.DeleteAllItem();
		bIAmRanker = false;
		myRankingInList = 0;
		nRankingGroup = nRankingGroupTm;
		nRankingScope = nRankingScopeTm;
	}
	i = 0;
	while((i < packet.rankInfoList.Length))
	{
		Debug(("packet.rankInfoList[i].sCharName" @ packet.rankInfoList[i].sCharName));
		Debug(("packet.rankInfoList[i].nRank" @ string(packet.rankInfoList[i].nRank)));
		Debug(("packet.rankInfoList[i].nPrevRank" @ string(packet.rankInfoList[i].nPrevRank)));
		if(((1 == nRankingGroup) || (0 == nRankingGroup)))
		{
			if((packet.rankInfoList[i].nPrevRank == 0))
			{
				nChangeRank = 0;
			}
			else
			{
				nChangeRank = (packet.rankInfoList[i].nPrevRank - packet.rankInfoList[i].nRank);
			}
		}
		else
		{
			nChangeRank = 0;
		}
		Debug(("nChangeRank" @ string(nChangeRank)));
		if((ChinaOriginName(packet.rankInfoList[i].sCharName) == myInfo.Name))
		{
			bIAmRanker = true;
			myRankingInList = RankingTab_RichList.GetRecordCount();
		}
		if((packet.rankInfoList[i].sPledgeName == ""))
		{
			PledgeName = GetSystemString(431);
		}
		else
		{
			PledgeName = packet.rankInfoList[i].sPledgeName;
		}
		AddRankingSystemListItem(packet.rankInfoList[i].nRank, nChangeRank, packet.rankInfoList[i].nPrevRank, getWorldServerFullName(packet.rankInfoList[i].sCharName), ("Lv." $ string(packet.rankInfoList[i].nLevel)), packet.rankInfoList[i].nClass, getWorldServerFullName(PledgeName), packet.rankInfoList[i].nRace, packet.rankInfoList[i].nPVPPoint, packet.rankInfoList[i].nKillCount, packet.rankInfoList[i].nDieCount, bool(packet.bCurrentSeason));
		i++;
	}
	rankingListEndHandler();
	return;
}

function AddRankingSystemListItem(int nRanking, int nChangeRank, int nPrevRank, string PlayerName, string levelStr, int nClassID, string ClanName, int nRace, INT64 pvpScore, int nKillCount, int nDieCount, bool isCurrentSeason)
{
	local RichListCtrlRowData rowData;
	local string texStr, tmStr;
	local Color applyColor;
	local int nH, nW, tH, tW, nAddY, nAddX;
	local bool bisAllReward;
	local string NameLV;

	rowData.cellDataList.Length = 5;
	bisAllReward = true;
	if(((nRanking <= 3) && (nRanking > 0)))
	{
		if((nRanking == 1))
		{
			texStr = "L2UI_ct1.RankingWnd.RankingWnd_1st";
		}
		else if((nRanking == 2))
		{
			texStr = "L2UI_ct1.RankingWnd.RankingWnd_2nd";
		}
		else if((nRanking == 3))
		{
			texStr = "L2UI_ct1.RankingWnd.RankingWnd_3rd";
		}
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, texStr, 38, 33, 10, 5);
		if(bisAllReward)
		{
			applyColor = GTColor().Frangipani;
		}
		else
		{
			applyColor = GTColor().Charcoal;
		}
		nAddY = 12;
		nAddX = 6;
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, string(nRanking), GTColor().Tallow, false, 20, 10);
		if(bisAllReward)
		{
			applyColor = GTColor().WhiteSmoke;
		}
		else
		{
			applyColor = GTColor().Charcoal;
		}
		nAddY = 4;
		nAddX = 10;
	}
	rowData.cellDataList[0].szData = ChinaHideName(PlayerName);
	rowData.cellDataList[1].szData = levelStr;
	rowData.cellDataList[2].szData = GetClassType(nClassID);
	rowData.cellDataList[3].szData = ClanName;
	rowData.cellDataList[4].szData = getRaceSystemString(nRace);
	rowData.nReserved1 = INT64(nKillCount);
	rowData.nReserved2 = INT64(nDieCount);
	rowData.nReserved3 = pvpScore;
	levelStr = (("(" $ levelStr) $ ")");
	if((isCurrentSeason == true))
	{
		if(((((nRankingGroup == 0) && (nRankingScope == 0)) && ((nPrevRank > 150) || (nPrevRank == 0))) || (((nRankingGroup == 1) && (nRankingScope == 0)) && ((nPrevRank > 100) || (nPrevRank == 0)))))
		{
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, "NEW", GTColor().Lime, false, nAddX, (nAddY - 4));
		}
		else
		{
			if((nRankingScope == 1))
			{
				nChangeRank = 0;
			}
			if((nChangeRank > 0))
			{
				addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_CT1.RankingWnd.RankingWnd_ArrowUp", 8, 8, 6, nAddY);
				AddRichListCtrlString(rowData.cellDataList[0].drawitems, string(nChangeRank), GTColor().Froly, false, 2, -4);
			}
			else if((nChangeRank == 0))
			{
				AddRichListCtrlString(rowData.cellDataList[0].drawitems, "-", GetColor(153, 153, 153, 255), false, nAddX, (nAddY - 4));
			}
			else
			{
				addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_CT1.RankingWnd.RankingWnd_ArrowDown", 8, 8, 6, nAddY);
				AddRichListCtrlString(rowData.cellDataList[0].drawitems, string(nChangeRank), GTColor().DeepSkyBlue, false, 2, -4);
			}
		}
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, "-", GetColor(153, 153, 153, 255), false, nAddX, (nAddY - 4));
	}
	NameLV = (ChinaHideName(PlayerName) @ levelStr);
	GetTextSizeDefault(NameLV, nW, nH);
	if((nW > 208))
	{
		GetTextSizeDefault(levelStr, tW, tH);
		tmStr = makeShortStringByPixel((ChinaHideName(PlayerName) $ " "), (208 - tW), "..");
		AddRichListCtrlString(rowData.cellDataList[1].drawitems, (tmStr @ levelStr), applyColor, false, 4, -4);
		GetTextSizeDefault((tmStr @ levelStr), nW, nH);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[1].drawitems, NameLV, applyColor, false, 4, -4);
	}
	if(bisAllReward)
	{
		applyColor = GTColor().Silver;
	}
	else
	{
		applyColor = GTColor().Charcoal;
	}
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, getRaceSystemString(nRace), applyColor, false, -nW, 15);
	if((GetClassTransferDegree(nClassID) >= 1))
	{
		addRichListCtrlTexture(rowData.cellDataList[2].drawitems, (("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ string(nClassID)) $ "_Big"), 31, 42, 28, 0);
	}
	else
	{
		addRichListCtrlTexture(rowData.cellDataList[2].drawitems, (("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ GetRaceString(nRace)) $ "_Big"), 31, 42, 28, 0);
	}
	if(((nRanking <= 3) && (nRanking > 0)))
	{
		if(bisAllReward)
		{
			GTColor().Frangipani;
		}
		else
		{
			applyColor = GTColor().Charcoal;
		}
	}
	else if(bisAllReward)
	{
		applyColor = GTColor().Silver;
	}
	else
	{
		applyColor = GTColor().Charcoal;
	}
	AddRichListCtrlString(rowData.cellDataList[3].drawitems, ClanName, applyColor, false, 5, 0);
	AddRichListCtrlString(rowData.cellDataList[4].drawitems, MakeCostStringINT64(pvpScore), applyColor, false, 0, 0);
	nAddY = 8;
	if(bisAllReward)
	{
		if((myInfo.Name == ChinaOriginName(PlayerName)))
		{
			rowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_MyRankBg";
		}
		else
		{
			rowData.sOverlayTex = "L2UI_CT1.EmptyBtn";
		}
		rowData.OverlayTexU = 734;
		rowData.OverlayTexV = 45;
	}
	else
	{
		if((myInfo.Name == ChinaOriginName(PlayerName)))
		{
			rowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_MyDisableRankBg";
		}
		else
		{
			rowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_DisableRankBg";
		}
		rowData.OverlayTexU = 734;
		rowData.OverlayTexV = 45;
	}
	RankingTab_RichList.InsertRecord(rowData);
	return;
}

function bool isSameEventWithCurrentState(int nRankingGroup, int nRankingScope, int nCurrentRankingGroup, int nCurrentRankingScope)
{
	switch(nRankingGroup)
	{
		case 0:
		case 1:
			if(((nRankingGroup == nCurrentRankingGroup) && (nRankingScope == nCurrentRankingScope)))
			{
				return true;
			}
			break;
		case 2:
		case 3:
			if((nRankingGroup == nCurrentRankingGroup))
			{
				return true;
			}
			break;
		default:
			break;
	}
	return false;
}

function rankingListEndHandler()
{
	local int nStartRow;

	if((RankingTab_RichList.GetRecordCount() > 0))
	{
		DisableWndList.HideWindow();
		if(bIAmRanker)
		{
			nStartRow = (myRankingInList - 3);
			if((nStartRow > 0))
			{
				if((RankingTab_RichList.GetRecordCount() > nStartRow))
				{
					RankingTab_RichList.SetStartRow(nStartRow);
				}
			}
		}
	}
	else
	{
		DisableWndList.ShowWindow();
		switch(currentRankingGroup)
		{
			case ServerGroup:
				List_Empty.SetText(GetSystemString(13023));
				break;
			case RaceGroup:
				List_Empty.SetText(GetSystemString(13023));
				break;
			case Pledge:
				List_Empty.SetText(GetSystemString(13023));
				break;
			case Friends:
				List_Empty.SetText(GetSystemString(13023));
				break;
			default:
				break;
		}
	}
	RankingTab_RichList.SetFocus();
	return;
}

function SetCusomTooltipAtHelpBtn()
{
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText((" - " $ GetSystemString(13019)), getInstanceL2Util().White, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText((" - " $ GetSystemString(13021)), getInstanceL2Util().White, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText((" - " $ GetSystemString(13426)), getInstanceL2Util().White, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText((" - " $ GetSystemString(13427)), getInstanceL2Util().White, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText((" - " $ GetSystemString(13499)), getInstanceL2Util().White, "", true, true);
	RankingHelpButton.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
	return;
}

function checkVisibleCombo()
{
	if((int(currentRankingGroup) == 1))
	{
		if((int(currentRankingScope) == 0))
		{
			RaceComboboxWnd.ShowWindow();
		}
		else
		{
			RaceComboboxWnd.HideWindow();
		}
	}
	else
	{
		RaceComboboxWnd.HideWindow();
	}
	return;
}

function setMYInfo()
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
	if((myInfo.nClanID > 0))
	{
		ClanNameText.SetText(GetClanName(myInfo.nClanID));
	}
	else
	{
		ClanNameText.SetText(GetSystemString(431));
	}
	NameText.SetText(myInfo.Name);
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
	RaceMark.SetTexture(("l2ui_ct1.RankingWnd.RankingWnd_RaceMark_" $ GetRaceString(myInfo.Race)));
	if((isFirstInit == false))
	{
		InitData();
		initRaceCombo();
		isFirstInit = true;
		if((myInfo.Race == 30))
		{
			RaceCategoryCombobox.SetSelectedNum(6);
		}
		else if((myInfo.Race == 31))
		{
			RaceCategoryCombobox.SetSelectedNum(7);
		}
		else
		{
			RaceCategoryCombobox.SetSelectedNum(myInfo.Race);
		}
	}
	return;
}

function setToggleSeasonButton()
{
	if(bCurrentSeason)
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

function setDisableWnd()
{
	disableWnd.ShowWindow();
	RankingWnd(GetScript("RankingWnd")).tabDisable(true);
	Me.SetTimer(1001113, 600);
	return;
}

function hideDisableWnd()
{
	disableWnd.HideWindow();
	RankingWnd(GetScript("RankingWnd")).tabDisable(false);
	Me.KillTimer(1001113);
	return;
}

function API_C_EX_PVP_RANKING_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_PVP_RANKING_LIST packet;

	packet.cRankingGroup = int(currentRankingGroup);
	packet.cRankingScope = int(currentRankingScope);
	packet.bCurrentSeason = byte(bCurrentSeason);
	if(IsAdenServer())
	{
		if((RaceCategoryCombobox.GetSelectedNum() == 6))
		{
			packet.nRace = 30;
		}
		else if((RaceCategoryCombobox.GetSelectedNum() == 7))
		{
			packet.nRace = 31;
		}
		else
		{
			packet.nRace = RaceCategoryCombobox.GetSelectedNum();
		}
	}
	else
	{
		packet.nRace = RaceCategoryCombobox.GetSelectedNum();
	}
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_PVP_RANKING_LIST(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(663, stream);
	Debug((((("----> Api Call : C_EX_OLYMPIAD_RANKING_INFO" @ string(currentRankingGroup)) @ string(currentRankingScope)) @ string(bCurrentSeason)) @ string(packet.nRace)));
	return;
}

function API_C_EX_PVP_RANKING_MY_INFO()
{
	local array<byte> stream;

	Class'Interface.UIPacket'.static.RequestUIPacket(662, stream);
	Debug("----> Api Call : API_C_EX_PVP_RANKING_MY_INFO");
	return;
}
