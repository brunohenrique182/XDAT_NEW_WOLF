class RankingWnd_Clan extends UICommonAPI
	dependson(UIPacket);

const TIMER_ID = 1001115;
const REFRESH_DELAY = 600;

var WindowHandle Me;
var WindowHandle disableWnd;
var TextureHandle ClanIcon_Tex;
var TextBoxHandle ClanNameText;
var TextBoxHandle levelText;
var TextBoxHandle ClassText;
var TextBoxHandle NameText;
var ButtonHandle RankingHelpButton;
var TextBoxHandle RankingText;
var TextureHandle ClanMarkClassic;
var TextureHandle ClanMark;
var TextureHandle RankingArrow;
var TextBoxHandle RankingEqualityText;
var TextBoxHandle MyRankingText;
var TextureHandle RankingBg;
var TextBoxHandle ClanExpText;
var TextBoxHandle MyClanExpText;
var WindowHandle RankingTabAllWnd;
var TextBoxHandle ClanTitleText;
var ButtonHandle Top150Button;
var ButtonHandle MyClanRankingButton;
var ButtonHandle RefreshButton;
var WindowHandle DisableWndList;
var TextBoxHandle List_Empty;
var RichListCtrlHandle RankingTab_RichList;
var DetailStatusWnd DetailStatusWndScript;
var int nRankingScope;
var UIEventManager.RankingScope currentRankingScope;
var bool bIAmRanker;
var int myRankingInList;
var UserInfo myInfo;
var bool isFirstInit;

function OnLoad()
{
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("RankingWnd_Clan");
	disableWnd = GetWindowHandle("RankingWnd_Clan.DisableWnd");
	ClanIcon_Tex = GetTextureHandle("RankingWnd_Clan.ClanIcon_Tex");
	ClanMark = GetTextureHandle("RankingWnd_Clan.ClanMark");
	ClanMarkClassic = GetTextureHandle("RankingWnd_Clan.ClanMarkClassic");
	ClanNameText = GetTextBoxHandle("RankingWnd_Clan.ClanNameText");
	levelText = GetTextBoxHandle("RankingWnd_Clan.LevelText");
	ClassText = GetTextBoxHandle("RankingWnd_Clan.ClassText");
	NameText = GetTextBoxHandle("RankingWnd_Clan.NameText");
	RankingHelpButton = GetButtonHandle("RankingWnd_Clan.RankingHelpButton");
	RankingText = GetTextBoxHandle("RankingWnd_Clan.RankingText");
	RankingArrow = GetTextureHandle("RankingWnd_Clan.RankingArrow");
	RankingEqualityText = GetTextBoxHandle("RankingWnd_Clan.RankingEqualityText");
	MyRankingText = GetTextBoxHandle("RankingWnd_Clan.MyRankingText");
	ClanExpText = GetTextBoxHandle("RankingWnd_Clan.ClanExpText");
	MyClanExpText = GetTextBoxHandle("RankingWnd_Clan.MyClanExpText");
	RankingTabAllWnd = GetWindowHandle("RankingWnd_Clan.RankingTabAllWnd");
	ClanTitleText = GetTextBoxHandle("RankingWnd_Clan.RankingTabAllWnd.ClanTitleText");
	Top150Button = GetButtonHandle("RankingWnd_Clan.RankingTabAllWnd.Top150Button");
	MyClanRankingButton = GetButtonHandle("RankingWnd_Clan.RankingTabAllWnd.MyClanRankingButton");
	RefreshButton = GetButtonHandle("RankingWnd_Clan.RankingTabAllWnd.RefreshButton");
	DisableWndList = GetWindowHandle("RankingWnd_Clan.RankingTabAllWnd.DisableWndList");
	List_Empty = GetTextBoxHandle("RankingWnd_Clan.RankingTabAllWnd.DisableWndList.List_Empty");
	RankingTab_RichList = GetRichListCtrlHandle("RankingWnd_Clan.RankingTabAllWnd.RankingTab_RichList");
	RankingTab_RichList.SetSelectedSelTooltip(false);
	RankingTab_RichList.SetAppearTooltipAtMouseX(true);
	RankingTab_RichList.SetUseStripeBackTexture(false);
	DetailStatusWndScript = DetailStatusWnd(GetScript("DetailStatusWnd"));
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(9750);
	RegisterEvent((100000 + 945));
	RegisterEvent((100000 + 946));
	return;
}

event OnShow()
{
	if(GetWindowHandle("RankingWnd").IsShowWindow())
	{
		OnRefreshButtonClick();
	}
	return;
}

event OnHide()
{
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9750:
			initUI();
			break;
		case 40:
			isFirstInit = false;
			break;
		case EV_PacketID(945):
			ParsePacket_S_EX_PLEDGE_RANKING_MY_INFO();
			break;
		case EV_PacketID(946):
			ParsePacket_S_EX_PLEDGE_RANKING_LIST();
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_PLEDGE_RANKING_MY_INFO()
{
	local UIPacket._S_EX_PLEDGE_RANKING_MY_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_PLEDGE_RANKING_MY_INFO(packet))
	{
		return;
	}
	Debug((((" -->  Decode_S_EX_PLEDGE_RANKING_MY_INFO :  " @ string(packet.nRank)) @ string(packet.nPrevRank)) @ string(packet.nPledgeExp)));
	if((packet.nPrevRank == 0))
	{
		packet.nPrevRank = packet.nRank;
	}
	if(((packet.nPrevRank - packet.nRank) > 0))
	{
		RankingArrow.ShowWindow();
		RankingArrow.SetTexture("L2UI_CT1.RankingWnd.RankingWnd_ArrowUp");
		RankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string((packet.nPrevRank - packet.nRank))));
		RankingEqualityText.SetTextColor(GetColor(230, 101, 101, 255));
	}
	else if(((packet.nPrevRank - packet.nRank) < 0))
	{
		RankingArrow.ShowWindow();
		RankingArrow.SetTexture("L2UI_CT1.RankingWnd.RankingWnd_ArrowDown");
		RankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string((packet.nPrevRank - packet.nRank))));
		RankingEqualityText.SetTextColor(GetColor(0, 170, 255, 255));
	}
	else
	{
		RankingEqualityText.SetText("-");
		RankingEqualityText.SetTextColor(GetColor(153, 153, 153, 255));
		RankingArrow.HideWindow();
	}
	if((packet.nPledgeExp == 0))
	{
		MyClanExpText.SetText("-");
	}
	else
	{
		MyClanExpText.SetText(MakeCostString(string(packet.nPledgeExp)));
	}
	if((packet.nRank == 0))
	{
		MyRankingText.SetText("-");
	}
	else
	{
		MyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(packet.nRank)));
	}
	return;
}

function ParsePacket_S_EX_PLEDGE_RANKING_LIST()
{
	local UIPacket._S_EX_PLEDGE_RANKING_LIST packet;
	local int i, nChangeRank;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_PLEDGE_RANKING_LIST(packet))
	{
		return;
	}
	Debug((" -->  Decode_S_EX_PLEDGE_RANKING_LIST :  " @ string(packet.cRankingScope)));
	Debug(("packet.rankingList.length : " @ string(packet.rankingList.Length)));
	RankingTab_RichList.DeleteAllItem();
	bIAmRanker = false;
	myRankingInList = 0;
	nRankingScope = packet.cRankingScope;
	i = 0;
	while((i < packet.rankingList.Length))
	{
		if((packet.rankingList[i].nPrevRank == 0))
		{
			nChangeRank = 0;
		}
		else
		{
			nChangeRank = (packet.rankingList[i].nPrevRank - packet.rankingList[i].nRank);
		}
		if((packet.rankingList[i].sPledgeName == GetClanName(myInfo.nClanID)))
		{
			bIAmRanker = true;
			myRankingInList = RankingTab_RichList.GetRecordCount();
		}
		AddRankingSystemListItem(packet.rankingList[i].nRank, nChangeRank, packet.rankingList[i].nPrevRank, packet.rankingList[i].sPledgeName, packet.rankingList[i].nPledgeLevel, ChinaHideName(packet.rankingList[i].sPledgeMasterName), packet.rankingList[i].nPledgeMasterLevel, packet.rankingList[i].nPledgeMemberCount, packet.rankingList[i].nPledgeExp);
		i++;
	}
	rankingListEndHandler();
	return;
}

function AddRankingSystemListItem(int nRanking, int nChangeRank, int nPrevRank, string sPledgeName, int nPledgeLevel, string sPledgeMasterName, int nPledgeMasterLevel, int nPledgeMemberCount, int nPledgeExp)
{
	local RichListCtrlRowData rowData;
	local string texStr, levelStr;
	local Color applyColor;
	local int nH, nW, nAddY, nAddX;
	local PledgeLevelData pledgeLevelDataStru;

	rowData.cellDataList.Length = 5;
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
		nAddY = 12;
		nAddX = 6;
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, string(nRanking), GTColor().Tallow, false, 20, 10);
		nAddY = 4;
		nAddX = 10;
	}
	if(((nRankingScope == 0) && ((nPrevRank > 150) || (nPrevRank == 0))))
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, "NEW", GTColor().Lime, false, nAddX, (nAddY - 4));
	}
	else if((nChangeRank > 0))
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
	if(((nRanking <= 3) && (nRanking > 0)))
	{
		applyColor = GTColor().Frangipani;
	}
	else
	{
		applyColor = GTColor().Silver;
	}
	levelStr = (("(Lv." $ string(nPledgeLevel)) $ ")");
	GetTextSizeDefault(sPledgeName, nW, nH);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, sPledgeName, applyColor, false, 4, -2);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, levelStr, applyColor, false, -nW, 15);
	levelStr = (("(Lv." $ string(nPledgeMasterLevel)) $ ")");
	GetTextSizeDefault(sPledgeMasterName, nW, nH);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, sPledgeMasterName, applyColor, false, 4, -2);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, levelStr, applyColor, false, -nW, 15);
	GetPledgeLevelData(nPledgeLevel, pledgeLevelDataStru);
	AddRichListCtrlString(rowData.cellDataList[3].drawitems, ((string(nPledgeMemberCount) $ "/") $ string(pledgeLevelDataStru.NumGeneral)), applyColor, false, 0, 0);
	AddRichListCtrlString(rowData.cellDataList[4].drawitems, MakeCostString(string(nPledgeExp)), applyColor, false, 0, 0);
	if((sPledgeName == GetClanName(myInfo.nClanID)))
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

function initUI()
{
	setLikeRadioButton("Top150Button");
	SetCusomTooltipHelpButton();
	RankingEqualityText.SetText("");
	RankingArrow.HideWindow();
	MyClanExpText.SetText("");
	MyRankingText.SetText("");
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Top150Button":
			setLikeRadioButton(Name);
			OnRefreshButtonClick();
			break;
		case "MyClanRankingButton":
			setLikeRadioButton(Name);
			OnRefreshButtonClick();
			break;
		case "RefreshButton":
			OnRefreshButtonClick();
			break;
		default:
			break;
	}
	return;
}

function OnRefreshButtonClick()
{
	API_C_EX_PLEDGE_RANKING_MY_INFO();
	API_C_EX_PLEDGE_RANKING_LIST();
	setMYInfo();
	setDisableWnd();
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
	if((isFirstInit == false))
	{
		isFirstInit = true;
	}
	return;
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
		List_Empty.SetText(GetSystemString(13023));
	}
	RankingTab_RichList.SetFocus();
	return;
}

function SetCusomTooltipHelpButton()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13691), GTColor().ColorDesc, "", true, true);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 130;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	RankingHelpButton.SetTooltipCustomType(mCustomTooltip);
	return;
}

function setLikeRadioButton(string buttonName)
{
	if((buttonName == "Top150Button"))
	{
		Top150Button.SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Down");
		MyClanRankingButton.SetTexture("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Over");
		currentRankingScope = TopN;
	}
	else if((buttonName == "MyClanRankingButton"))
	{
		MyClanRankingButton.SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Down");
		Top150Button.SetTexture("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Over");
		currentRankingScope = AroundMe;
	}
	return;
}

function OnTimer(int TimeID)
{
	if((TimeID == 1001115))
	{
		hideDisableWnd();
	}
	return;
}

function setDisableWnd()
{
	disableWnd.ShowWindow();
	RankingWnd(GetScript("RankingWnd")).tabDisable(true);
	Me.SetTimer(1001115, 600);
	return;
}

function hideDisableWnd()
{
	disableWnd.HideWindow();
	RankingWnd(GetScript("RankingWnd")).tabDisable(false);
	Me.KillTimer(1001115);
	return;
}

function API_C_EX_PLEDGE_RANKING_MY_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_PLEDGE_RANKING_MY_INFO packet;

	packet.cDummy = 0;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_PLEDGE_RANKING_MY_INFO(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(711, stream);
	Debug("----> Api Call : C_EX_PLEDGE_RANKING_MY_INFO");
	return;
}

function API_C_EX_PLEDGE_RANKING_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_PLEDGE_RANKING_LIST packet;

	packet.cRankingScope = int(currentRankingScope);
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_PLEDGE_RANKING_LIST(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(712, stream);
	Debug(("----> Api Call : C_EX_PLEDGE_RANKING_LIST" @ string(currentRankingScope)));
	return;
}
