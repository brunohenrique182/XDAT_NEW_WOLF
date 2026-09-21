class RankingWnd_Pet extends UICommonAPI
	dependson(UIPacket);

const TIMER_ID = 1001114;
const REFRESH_DELAY = 600;

var WindowHandle Me;
var WindowHandle disableWnd;
var TextureHandle RaceMark;
var TextureHandle RankingFlag;
var WindowHandle PetItemWnd;
var TextureHandle PetItemBg;
var ItemWindowHandle PerItem;
var ButtonHandle PerItemButton;
var TextBoxHandle PetNameText;
var TextBoxHandle levelText;
var TextBoxHandle RaceText;
var TextBoxHandle NameText;
var TextBoxHandle ServerRankingText;
var ButtonHandle RankingHelpButton;
var TextureHandle ServerRankingArrow;
var TextBoxHandle ServerRankingEqualityText;
var TextBoxHandle ServerMyRankingText;
var TextureHandle ServerRankingBg;
var TextBoxHandle RaceRankingText;
var TextureHandle RaceRankingArrow;
var TextBoxHandle RaceRankingEqualityText;
var TextBoxHandle RaceMyRankingText;
var TextureHandle RaceRankingBg;
var TextureHandle RankingTrophy;
var TextureHandle RankingPattern;
var TextureHandle RankingBg1;
var WindowHandle RankingTabAllWnd;
var ButtonHandle Top150Button;
var ButtonHandle MyPetRankingButton;
var ButtonHandle RefreshButton;
var WindowHandle DisableWndList;
var TextBoxHandle List_Empty;
var WindowHandle petComboboxWnd;
var TextBoxHandle petCategoryText;
var ComboBoxHandle petCategoryCombobox;
var TextureHandle ServerRichListFrame;
var RichListCtrlHandle RankingTab_RichList;
var TextureHandle RankingBg2;
var TabHandle TabCtrl2;
var TextureHandle TabLineBg2;
var TextureHandle TabBg2;
var WindowHandle RankingWnd_PetSub;
var TextBoxHandle Inventory_Title_TextBox;
var TextureHandle PetSubIcon_Texture;
var TextureHandle SlotBg1_Texture;
var ItemWindowHandle SubWnd_Item1;
var TextureHandle tabBg;
var string m_Windowname;
var L2UIInventoryObject iObject;
var DetailStatusWnd DetailStatusWndScript;
var int nSelectPetItemSeverID;
var int nRanking;
var UserInfo myInfo;
var int nSelectNpcID;
var int nRankingGroup;
var int nRankingScope;
var UIEventManager.RankingScope currentRankingScope;
var UIEventManager.RankingGroup currentRankingGroup;
var bool bIAmRanker;
var int myRankingInList;
var bool isFirstInit;
var bool bCurrentSeason;
//var delegate<OnSortCompare> __OnSortCompare__Delegate;

delegate int OnSortCompare(ItemInfo A, ItemInfo B)
{
	if((A.Enchanted < B.Enchanted))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

function OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(9750);
	RegisterEvent((100000 + 908));
	RegisterEvent((100000 + 909));
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
	Me = GetWindowHandle(m_Windowname);
	disableWnd = GetWindowHandle((m_Windowname $ ".DisableWnd"));
	RaceMark = GetTextureHandle((m_Windowname $ ".RaceMark"));
	RankingFlag = GetTextureHandle((m_Windowname $ ".RankingFlag"));
	PetItemWnd = GetWindowHandle((m_Windowname $ ".PetItemWnd"));
	PetItemBg = GetTextureHandle((m_Windowname $ ".PetItemWnd.PetItemBg"));
	PerItem = GetItemWindowHandle((m_Windowname $ ".PetItemWnd.PerItem"));
	PerItemButton = GetButtonHandle((m_Windowname $ ".PetItemWnd.PerItemButton"));
	PetNameText = GetTextBoxHandle((m_Windowname $ ".PetNameText"));
	levelText = GetTextBoxHandle((m_Windowname $ ".LevelText"));
	RaceText = GetTextBoxHandle((m_Windowname $ ".RaceText"));
	NameText = GetTextBoxHandle((m_Windowname $ ".NameText"));
	ServerRankingText = GetTextBoxHandle((m_Windowname $ ".ServerRankingText"));
	RankingHelpButton = GetButtonHandle((m_Windowname $ ".RankingHelpButton"));
	ServerRankingArrow = GetTextureHandle((m_Windowname $ ".ServerRankingArrow"));
	ServerRankingEqualityText = GetTextBoxHandle((m_Windowname $ ".ServerRankingEqualityText"));
	ServerMyRankingText = GetTextBoxHandle((m_Windowname $ ".ServerMyRankingText"));
	ServerRankingBg = GetTextureHandle((m_Windowname $ ".ServerRankingBg"));
	RaceRankingText = GetTextBoxHandle((m_Windowname $ ".RaceRankingText"));
	RaceRankingArrow = GetTextureHandle((m_Windowname $ ".RaceRankingArrow"));
	RaceRankingEqualityText = GetTextBoxHandle((m_Windowname $ ".RaceRankingEqualityText"));
	RaceMyRankingText = GetTextBoxHandle((m_Windowname $ ".RaceMyRankingText"));
	RaceRankingBg = GetTextureHandle((m_Windowname $ ".RaceRankingBg"));
	RankingTrophy = GetTextureHandle((m_Windowname $ ".RankingTrophy"));
	RankingPattern = GetTextureHandle((m_Windowname $ ".RankingPattern"));
	RankingBg1 = GetTextureHandle((m_Windowname $ ".RankingBg1"));
	RankingTabAllWnd = GetWindowHandle((m_Windowname $ ".RankingTabAllWnd"));
	Top150Button = GetButtonHandle((m_Windowname $ ".RankingTabAllWnd.Top150Button"));
	petComboboxWnd = GetWindowHandle((m_Windowname $ ".RankingTabAllWnd.petComboboxWnd"));
	petCategoryText = GetTextBoxHandle((m_Windowname $ ".RankingTabAllWnd.petComboboxWnd.petCategoryText"));
	petCategoryCombobox = GetComboBoxHandle((m_Windowname $ ".RankingTabAllWnd.petComboboxWnd.petCombobox"));
	MyPetRankingButton = GetButtonHandle((m_Windowname $ ".RankingTabAllWnd.MyPetRankingButton"));
	RefreshButton = GetButtonHandle((m_Windowname $ ".RankingTabAllWnd.RefreshButton"));
	DisableWndList = GetWindowHandle((m_Windowname $ ".RankingTabAllWnd.DisableWndList"));
	List_Empty = GetTextBoxHandle((m_Windowname $ ".RankingTabAllWnd.DisableWndList.List_Empty"));
	ServerRichListFrame = GetTextureHandle((m_Windowname $ ".RankingTabAllWnd.ServerRichListFrame"));
	RankingTab_RichList = GetRichListCtrlHandle((m_Windowname $ ".RankingTabAllWnd.RankingTab_RichList"));
	RankingBg2 = GetTextureHandle((m_Windowname $ ".RankingTabAllWnd.RankingBg2"));
	TabCtrl2 = GetTabHandle((m_Windowname $ ".RankingTabAllWnd.TabCtrl2"));
	TabLineBg2 = GetTextureHandle((m_Windowname $ ".RankingTabAllWnd.TabLineBg2"));
	TabBg2 = GetTextureHandle((m_Windowname $ ".RankingTabAllWnd.TabBg2"));
	RankingWnd_PetSub = GetWindowHandle((m_Windowname $ ".RankingWnd_PetSub"));
	Inventory_Title_TextBox = GetTextBoxHandle((m_Windowname $ ".RankingWnd_PetSub.Inventory_Title_TextBox"));
	PetSubIcon_Texture = GetTextureHandle((m_Windowname $ ".RankingWnd_PetSub.PetSubIcon_Texture"));
	SlotBg1_Texture = GetTextureHandle((m_Windowname $ ".RankingWnd_PetSub.SlotBg1_Texture"));
	SubWnd_Item1 = GetItemWindowHandle((m_Windowname $ ".RankingWnd_PetSub.SubWnd_Item1"));
	tabBg = GetTextureHandle((m_Windowname $ ".RankingWnd_PetSub.tabbg"));
	SetCusomTooltipAtHelpBtn();
	RankingTab_RichList.SetSelectedSelTooltip(false);
	RankingTab_RichList.SetAppearTooltipAtMouseX(true);
	RankingTab_RichList.SetUseStripeBackTexture(false);
	RankingTab_RichList.SetTooltipType("RankingPet");
	return;
}

function OnShow()
{
	if(GetWindowHandle("RankingWnd").IsShowWindow())
	{
		OnRefreshButtonClick();
	}
	return;
}

function OnHide()
{
	ShowRankingWnd_PetSub(false);
	return;
}

function initUI()
{
	nSelectPetItemSeverID = 0;
	ShowRankingWnd_PetSub(false);
	PerItemButton.SetTexture("L2UI_EPIC.RankingWnd_PetButton", "L2UI_EPIC.RankingWnd_PetButton_Down", "L2UI_EPIC.RankingWnd_PetButton_Over");
	SetCusomTooltipAtPetButton();
	setTabState("TabCtrl20");
	setLikeRadioButton("Top150Button");
	return;
}

function initComboBox_PetID()
{
	local bool bSelect;
	local int i, selectIndex;
	local array<L2PetRaceEmblemUIData> petInfoArray;

	Class'NWindow.PetAPI'.static.GetPetRaceEmblemDataAll(petInfoArray);
	petCategoryCombobox.Clear();
	i = 0;
	while((i < petInfoArray.Length))
	{
		petCategoryCombobox.AddStringWithReserved(petInfoArray[i].RaceName, petInfoArray[i].PetID);
		i++;
	}
	if((bSelect == false))
	{
		petCategoryCombobox.SetSelectedNum(0);
	}
	else
	{
		petCategoryCombobox.SetSelectedNum(selectIndex);
	}
	return;
}

function SetCusomTooltipAtPetButton()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13413), GTColor().BrightWhite, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13513), GTColor().ColorDesc, "", true, false);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 130;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	PerItemButton.SetTooltipCustomType(mCustomTooltip);
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "PerItemButton":
			OnPerItemButtonClick();
			break;
		case "Top150Button":
			setLikeRadioButton(Name);
			OnRefreshButtonClick();
			break;
		case "MyPetRankingButton":
			setLikeRadioButton(Name);
			OnRefreshButtonClick();
			break;
		case "RefreshButton":
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

function OnPerItemButtonClick()
{
	ShowRankingWnd_PetSub(!RankingWnd_PetSub.IsShowWindow());
	return;
}

function OnRefreshButtonClick()
{
	ShowRankingWnd_PetSub(false);
	syncPetItemInven();
	API_C_EX_PET_RANKING_MY_INFO(nSelectPetItemSeverID);
	API_C_EX_PET_RANKING_LIST(nSelectPetItemSeverID, petCategoryCombobox.GetReserved(petCategoryCombobox.GetSelectedNum()));
	checkVisibleCombo();
	setMYInfo();
	setDisableWnd();
	return;
}

function OnClickItem(string strID, int Index)
{
	local ItemInfo SelectItemInfo;

	if((strID == "SubWnd_Item1"))
	{
		SubWnd_Item1.GetItem(Index, SelectItemInfo);
		if((SelectItemInfo.Id.ClassID > 0))
		{
			setSelectPetItem(SelectItemInfo);
		}
		ShowRankingWnd_PetSub(false);
		OnRefreshButtonClick();
	}
	return;
}

function setSelectPetItem(ItemInfo SelectItemInfo)
{
	local PetNameInfo PetNameInfo;
	local string petNameStr;
	local L2PetRaceEmblemUIData PetEmblemData;

	if((SelectItemInfo.Name == ""))
	{
		RaceText.SetText(GetSystemString(27));
		PetNameText.SetText(GetSystemString(971));
		PerItem.Clear();
		nSelectPetItemSeverID = 0;
	}
	else
	{
		Class'NWindow.PetAPI'.static.GetPetEvolveNameInfo(SelectItemInfo.PetNameID, PetNameInfo);
		petNameStr = PetNameInfo.Name;
		Class'NWindow.PetAPI'.static.GetPetEvolveNameInfo(SelectItemInfo.PetNamePrefixID, PetNameInfo);
		petNameStr = (PetNameInfo.Name @ petNameStr);
		Class'NWindow.PetAPI'.static.GetPetRaceEmblemData(SelectItemInfo.PetID, PetEmblemData);
		RaceText.SetText((("Lv" $ string(SelectItemInfo.Enchanted)) @ PetEmblemData.RaceName));
		if((trim(petNameStr) == ""))
		{
			PetNameText.SetText(GetSystemString(971));
		}
		else
		{
			PetNameText.SetText(petNameStr);
		}
		PerItem.Clear();
		if((SelectItemInfo.Id.ClassID > 0))
		{
			PerItem.AddItem(SelectItemInfo);
		}
		nSelectPetItemSeverID = SelectItemInfo.Id.ServerID;
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

function checkVisibleCombo()
{
	if((int(currentRankingGroup) == 1))
	{
		if((int(currentRankingScope) == 0))
		{
			petComboboxWnd.ShowWindow();
		}
		else
		{
			petComboboxWnd.HideWindow();
		}
	}
	else
	{
		petComboboxWnd.HideWindow();
	}
	return;
}

function setTabState(string TabName)
{
	switch(TabName)
	{
		case "TabCtrl20":
			SettingButton(Top150Button, true, 13016);
			SettingButton(MyPetRankingButton, true, 3975);
			petComboboxWnd.HideWindow();
			currentRankingGroup = ServerGroup;
			break;
		case "TabCtrl21":
			SettingButton(Top150Button, true, 3972);
			SettingButton(MyPetRankingButton, true, 3975);
			currentRankingGroup = RaceGroup;
			break;
		case "TabCtrl22":
			SettingButton(Top150Button, false);
			SettingButton(MyPetRankingButton, false);
			petComboboxWnd.HideWindow();
			currentRankingGroup = Pledge;
			break;
		case "TabCtrl23":
			SettingButton(Top150Button, false);
			SettingButton(MyPetRankingButton, false);
			petComboboxWnd.HideWindow();
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
		MyPetRankingButton.SetTexture("l2ui_ct1.RankingWnd_SubTabButton", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Over");
		currentRankingScope = TopN;
	}
	else if((buttonName == "MyPetRankingButton"))
	{
		MyPetRankingButton.SetTexture("l2ui_ct1.RankingWnd_SubTabButton_Down", "l2ui_ct1.RankingWnd_SubTabButton_Over", "l2ui_ct1.RankingWnd_SubTabButton_Down");
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

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9750:
			initUI();
			break;
		case 40:
			isFirstInit = false;
			nSelectPetItemSeverID = 0;
			break;
		case EV_PacketID(908):
			ParsePacket_S_EX_PET_RANKING_MY_INFO();
		case EV_PacketID(909):
			ParsePacket_S_EX_PET_RANKING_LIST();
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_PET_RANKING_MY_INFO()
{
	local UIPacket._S_EX_PET_RANKING_MY_INFO packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_PET_RANKING_MY_INFO(packet))
	{
		return;
	}
	if((nSelectPetItemSeverID <= 0))
	{
		nSelectPetItemSeverID = packet.nCollarID;
	}
	if((packet.nPrevRank == 0))
	{
		packet.nPrevRank = packet.nRank;
	}
	if((packet.nPrevRaceRank == 0))
	{
		packet.nPrevRaceRank = packet.nRaceRank;
	}
	if(((packet.nPrevRank - packet.nRank) > 0))
	{
		ServerRankingArrow.ShowWindow();
		ServerRankingArrow.SetTexture("L2UI_CT1.RankingWnd.RankingWnd_ArrowUp");
		ServerRankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string((packet.nPrevRank - packet.nRank))));
		ServerRankingEqualityText.SetTextColor(GetColor(230, 101, 101, 255));
	}
	else if(((packet.nPrevRank - packet.nRank) < 0))
	{
		ServerRankingArrow.ShowWindow();
		ServerRankingArrow.SetTexture("L2UI_CT1.RankingWnd.RankingWnd_ArrowDown");
		ServerRankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string((packet.nPrevRank - packet.nRank))));
		ServerRankingEqualityText.SetTextColor(GetColor(0, 170, 255, 255));
	}
	else
	{
		ServerRankingEqualityText.SetText("-");
		ServerRankingEqualityText.SetTextColor(GetColor(153, 153, 153, 255));
		ServerRankingArrow.HideWindow();
	}
	if(((packet.nPrevRaceRank - packet.nRaceRank) > 0))
	{
		RaceRankingArrow.ShowWindow();
		RaceRankingArrow.SetTexture("L2UI_ct1.RankingWnd.RankingWnd_ArrowUp");
		RaceRankingEqualityText.SetTextColor(GetColor(230, 101, 101, 255));
		RaceRankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string((packet.nPrevRaceRank - packet.nRaceRank))));
	}
	else if(((packet.nPrevRaceRank - packet.nRaceRank) < 0))
	{
		RaceRankingArrow.ShowWindow();
		RaceRankingArrow.SetTexture("L2UI_ct1.RankingWnd.RankingWnd_ArrowDown");
		RaceRankingEqualityText.SetTextColor(GetColor(0, 170, 255, 255));
		RaceRankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string((packet.nPrevRaceRank - packet.nRaceRank))));
	}
	else
	{
		RaceRankingArrow.HideWindow();
		RaceRankingEqualityText.SetTextColor(GetColor(153, 153, 153, 255));
		RaceRankingEqualityText.SetText("-");
	}
	if((packet.nRank == 0))
	{
		ServerMyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), " - "));
	}
	else
	{
		ServerMyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(packet.nRank)));
	}
	if((packet.nRaceRank == 0))
	{
		RaceMyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), " - "));
	}
	else
	{
		RaceMyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(packet.nRaceRank)));
	}
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

function ParsePacket_S_EX_PET_RANKING_LIST()
{
	local UIPacket._S_EX_PET_RANKING_LIST packet;
	local int i, nChangeRank, nRankingGroupTm, nRankingScopeTm;
	local ItemInfo currentPetInfo;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_PET_RANKING_LIST(packet))
	{
		return;
	}
	nRankingGroupTm = packet.cRankingGroup;
	nRankingScopeTm = packet.cRankingScope;
	if(isSameEventWithCurrentState(int(currentRankingGroup), int(currentRankingScope), packet.cRankingGroup, packet.cRankingScope))
	{
		RankingTab_RichList.DeleteAllItem();
		bIAmRanker = false;
		myRankingInList = 0;
		nRankingGroup = nRankingGroupTm;
		nRankingScope = nRankingScopeTm;
	}
	Debug(((((" -->  Decode_S_EX_PET_RANKING_LIST :  " @ string(packet.cRankingGroup)) @ string(packet.cRankingScope)) @ string(packet.nIndex)) @ string(packet.nCollarID)));
	Debug(("packet.rankerInfoList.length : " @ string(packet.rankerInfoList.Length)));
	if((PerItem.GetItemNum() > 0))
	{
		PerItem.GetItem(0, currentPetInfo);
	}
	i = 0;
	while((i < packet.rankerInfoList.Length))
	{
		if(((1 == nRankingGroup) || (0 == nRankingGroup)))
		{
			if((packet.rankerInfoList[i].nPrevRank == 0))
			{
				nChangeRank = 0;
			}
			else
			{
				nChangeRank = (packet.rankerInfoList[i].nPrevRank - packet.rankerInfoList[i].nRank);
			}
		}
		else
		{
			nChangeRank = 0;
		}
		if((((ChinaOriginName(packet.rankerInfoList[i].sUserName) == myInfo.Name) && (currentPetInfo.Enchanted == packet.rankerInfoList[i].nPetLevel)) && (currentPetInfo.PetID == packet.rankerInfoList[i].nPetIndex)))
		{
			bIAmRanker = true;
			myRankingInList = RankingTab_RichList.GetRecordCount();
		}
		AddRankingSystemListItem(packet.rankerInfoList[i].nRank, nChangeRank, packet.rankerInfoList[i].nPrevRank, packet.rankerInfoList[i].sUserName, packet.rankerInfoList[i].sNickName, packet.rankerInfoList[i].nUserRace, packet.rankerInfoList[i].nUserLevel, packet.rankerInfoList[i].sPledgeName, packet.rankerInfoList[i].nNPCClassID, packet.rankerInfoList[i].nPetIndex, packet.rankerInfoList[i].nPetLevel);
		i++;
	}
	rankingListEndHandler();
	return;
}

function AddRankingSystemListItem(int nRanking, int nChangeRank, int nPrevRank, string PlayerName, string sNickName, int nRace, int nLevel, string PledgeName, int nNPCClassID, int nPetIndex, int nPetLevel)
{
	local RichListCtrlRowData rowData;
	local string texStr, levelStr, nameStr;
	local Color applyColor;
	local int nH, nW, nAddY, nAddX, prefixID;
	local bool bisAllReward;
	local L2PetRaceEmblemUIData PetEmblemData;
	local array<string> nickNameArray;
	local PetNameInfo NameInfo;

	rowData.cellDataList.Length = 5;
	bisAllReward = true;
	Class'NWindow.PetAPI'.static.GetPetRaceEmblemData(nPetIndex, PetEmblemData);
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
	if(((((nRankingGroup == 0) && (nRankingScope == 0)) && ((nPrevRank > 150) || (nPrevRank == 0))) || (((nRankingGroup == 1) && (nRankingScope == 0)) && ((nPrevRank > 100) || (nPrevRank == 0)))))
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
	levelStr = (("(Lv." $ string(nPetLevel)) $ ")");
	if((sNickName == ""))
	{
		sNickName = Class'NWindow.UIDATA_NPC'.static.GetNPCName((nNPCClassID - 1000000));
	}
	else
	{
		Split(sNickName, ";", nickNameArray);
		prefixID = Class'NWindow.PetAPI'.static.GetPetNameIDBySkill(int(nickNameArray[0]), int(nickNameArray[1]));
		Class'NWindow.PetAPI'.static.GetPetEvolveNameInfo(prefixID, NameInfo);
		nameStr = NameInfo.Name;
		Class'NWindow.PetAPI'.static.GetPetEvolveNameInfo(int(nickNameArray[2]), NameInfo);
		sNickName = (nameStr @ NameInfo.Name);
	}
	rowData.cellDataList[0].szData = sNickName;
	rowData.cellDataList[1].szData = ("Lv." $ string(nPetLevel));
	rowData.cellDataList[2].szData = PetEmblemData.RaceName;
	GetTextSizeDefault(sNickName, nW, nH);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, sNickName, applyColor, false, 4, -2);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, levelStr, applyColor, false, -nW, 15);
	addRichListCtrlTexture(rowData.cellDataList[2].drawitems, PetEmblemData.EmblemTexName, 32, 32, 28, 0);
	levelStr = (("(Lv." $ string(nLevel)) $ ")");
	GetTextSizeDefault(ChinaHideName(PlayerName), nW, nH);
	AddRichListCtrlString(rowData.cellDataList[3].drawitems, ChinaHideName(PlayerName), applyColor, false, 4, -2);
	AddRichListCtrlString(rowData.cellDataList[3].drawitems, levelStr, applyColor, false, -nW, 15);
	if(bisAllReward)
	{
		applyColor = GTColor().Silver;
	}
	else
	{
		applyColor = GTColor().Charcoal;
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
	if((PledgeName == ""))
	{
		PledgeName = GetSystemString(431);
	}
	AddRichListCtrlString(rowData.cellDataList[4].drawitems, PledgeName, applyColor, false, 5, 0);
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

function int syncPetItemInven()
{
	local int i, nSelect, nWindowWidth;
	local array<ItemInfo> itemarray, pickPetArray;
	local ItemInfo emptyItemInfo;

	GetObjectFindItemByCompare().DelegateCompare = petItemCompare;
	itemarray = GetObjectFindItemByCompare().GetAllItemByCompare();
	SubWnd_Item1.Clear();
	nSelect = -1;
	i = 0;
	while((i < itemarray.Length))
	{
		if((itemarray[i].Enchanted > 39))
		{
			InsertCheckInPetArray(itemarray[i], pickPetArray);
		}
		i++;
	}
	// pickPetArray.Sort(OnSortCompare);   // array.Sort() unsupported by this compiler
	i = 0;
	while((i < pickPetArray.Length))
	{
		SubWnd_Item1.AddItem(pickPetArray[i]);
		if((pickPetArray[i].Id.ServerID == nSelectPetItemSeverID))
		{
			nSelect = i;
			SubWnd_Item1.SetSelectedNum(i);
			setSelectPetItem(pickPetArray[i]);
		}
		i++;
	}
	if((pickPetArray.Length > 0))
	{
		SubWnd_Item1.SetRow(1);
		SubWnd_Item1.SetCol(pickPetArray.Length);
	}
	if((pickPetArray.Length > 0))
	{
		SubWnd_Item1.SetWindowSize(((34 + 4) * pickPetArray.Length), 34);
		nWindowWidth = (((34 + 4) * pickPetArray.Length) + 10);
		RankingWnd_PetSub.SetWindowSize(nWindowWidth, 51);
	}
	if((nSelect == -1))
	{
		if((pickPetArray.Length > 0))
		{
			SubWnd_Item1.SetSelectedNum(0);
			setSelectPetItem(pickPetArray[0]);
		}
		else
		{
			setSelectPetItem(emptyItemInfo);
		}
	}
	return pickPetArray.Length;
}

function InsertCheckInPetArray(ItemInfo petItemInfo, out array<ItemInfo> pickPetArray)
{
	local int i;
	local bool bSameItem;

	i = 0;
	while((i < pickPetArray.Length))
	{
		if((petItemInfo.PetID == pickPetArray[i].PetID))
		{
			bSameItem = true;
			if((petItemInfo.Enchanted > pickPetArray[i].Enchanted))
			{
				pickPetArray[i] = petItemInfo;
				return;
			}
		}
		i++;
	}
	if((bSameItem == false))
	{
		pickPetArray[pickPetArray.Length] = petItemInfo;
		return;
	}
	return;
}

function bool petItemCompare(ItemInfo item)
{
	if(((int(byte(item.EtcItemType)) == 7) && (item.PetID > 0)))
	{
		return true;
	}
	return false;
}

function ShowRankingWnd_PetSub(bool bShow)
{
	local int petCount;

	if(bShow)
	{
		petCount = syncPetItemInven();
		if((petCount <= 0))
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemString(13512));
			return;
		}
		RankingWnd_PetSub.ShowWindow();
		RankingWnd_PetSub.SetFocus();
		PerItemButton.SetTexture("L2UI_EPIC.RankingWnd.RankingWnd_PetClickButton", "L2UI_EPIC.RankingWnd.RankingWnd_PetClickButton_Down", "L2UI_EPIC.RankingWnd.RankingWnd_PetClickButton_Over");
	}
	else
	{
		RankingWnd_PetSub.HideWindow();
		PerItemButton.SetTexture("L2UI_EPIC.RankingWnd_PetButton", "L2UI_EPIC.RankingWnd_PetButton_Down", "L2UI_EPIC.RankingWnd_PetButton_Over");
	}
	SetCusomTooltipAtPetButton();
	return;
}

function SetCusomTooltipAtHelpBtn()
{
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText((" - " $ GetSystemString(13428)), getInstanceL2Util().White, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText((" - " $ GetSystemString(13429)), getInstanceL2Util().White, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText((" - " $ GetSystemString(13430)), getInstanceL2Util().White, "", true, true);
	RankingHelpButton.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
	return;
}

function setMYInfo()
{
	GetPlayerInfo(myInfo);
	NameText.SetText(myInfo.Name);
	if((isFirstInit == false))
	{
		isFirstInit = true;
		syncPetItemInven();
		initComboBox_PetID();
	}
	return;
}

function OnComboBoxItemSelected(string strID, int Index)
{
	OnRefreshButtonClick();
	return;
}

function OnTimer(int TimeID)
{
	if((TimeID == 1001114))
	{
		hideDisableWnd();
	}
	return;
}

function setDisableWnd()
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

function API_C_EX_PET_RANKING_MY_INFO(int nPetServerID)
{
	local array<byte> stream;
	local UIPacket._C_EX_PET_RANKING_MY_INFO packet;

	packet.nCollarID = nPetServerID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_PET_RANKING_MY_INFO(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(682, stream);
	Debug(("----> Api Call : C_EX_PET_RANKING_MY_INFO" @ string(nPetServerID)));
	return;
}

function API_C_EX_PET_RANKING_LIST(int nPetServerID, int nIndex)
{
	local array<byte> stream;
	local UIPacket._C_EX_PET_RANKING_LIST packet;

	packet.cRankingGroup = int(currentRankingGroup);
	packet.cRankingScope = int(currentRankingScope);
	packet.nIndex = nIndex;
	packet.nCollarID = nPetServerID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_PET_RANKING_LIST(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(683, stream);
	Debug((((("----> Api Call : C_EX_PET_RANKING_LIST" @ string(currentRankingGroup)) @ string(currentRankingScope)) @ string(nIndex)) @ string(nPetServerID)));
	return;
}
