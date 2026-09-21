class RankingWnd_Character extends UICommonAPI
	dependson(UIPacket);

const TIMER_ID = 1001110;
const REFRESH_DELAY = 600;
const TIMEID_NPC_DELAY = 1000101011;
const NpcSpawnDialogID = 11122;

var WindowHandle Me;
var WindowHandle disableWnd;
var WindowHandle DisableWndList;
var WindowHandle ClassComboboxWnd;
var ComboBoxHandle ClassCharacterCombobox;
var TextBoxHandle List_Empty;
var TextureHandle RaceMark;
var TextureHandle ClanMark;
var TextureHandle ClanMarkClassic;
var TextBoxHandle ClanNameText;
var TextBoxHandle levelText;
var TextBoxHandle ClassText;
var TextBoxHandle NameText;
var ButtonHandle RankingHelpButton;
var TextureHandle ClassRankingArrow;
var TextBoxHandle ClassRankingEqualityText;
var TextBoxHandle ClassMyRankingText;
var TextBoxHandle RaceRankingText;
var TextureHandle ServerRankingArrow;
var TextBoxHandle ServerRankingEqualityText;
var TextBoxHandle ServerMyRankingText;
var TextureHandle RaceRankingArrow;
var TextBoxHandle RaceRankingEqualityText;
var TextBoxHandle RaceMyRankingText;
var ButtonHandle DetailInformationButton;
var WindowHandle RankingTabAllWnd;
var ButtonHandle Top150Button;
var ButtonHandle MyRankingButton;
var ButtonHandle RefreshButton;
var WindowHandle RaceComboboxWnd;
var TextBoxHandle RaceCategoryText;
var ComboBoxHandle RaceCategoryCombobox;
var RichListCtrlHandle RankingTab_RichList;
var TextureHandle RankingBg2;
var TabHandle TabCtrl2;
var TextureHandle RankingRewardICON_Ani;
var ButtonHandle RankingRewardICON_Btn;
var ButtonHandle RankingRewardMenberCheck_Btn;
var WindowHandle LiveRankingWnd;
var WindowHandle ClassicRankingWnd;
var int nRanking;
var UserInfo myInfo;
var int nRankingGroup;
var int nRankingScope;
var UIEventManager.RankingScope currentRankingScope;
var UIEventManager.RankingGroup currentRankingGroup;
var bool bIAmRanker;
var int myRankingInList;
var bool isFirstInit;
var DetailStatusWnd DetailStatusWndScript;
var string m_Windowname;
var int npcSpawnTime;
var bool bFirstShow;

function OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(11260);
	RegisterEvent(11270);
	RegisterEvent(11271);
	RegisterEvent(11272);
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent((100000 + 817));
	RegisterEvent((100000 + 818));
	return;
}

function OnLoad()
{
	Initialize();
	return;
}

function Initialize()
{
	isFirstInit = false;
	m_Windowname = getCurrentWindowName(string(self));
	DetailStatusWndScript = DetailStatusWnd(GetScript("DetailStatusWnd"));
	Me = GetWindowHandle(m_Windowname);
	disableWnd = GetWindowHandle((m_Windowname $ ".DisableWnd"));
	DisableWndList = GetWindowHandle((m_Windowname $ ".DisableWndList"));
	ClassComboboxWnd = GetWindowHandle((m_Windowname $ ".ClassComboboxWnd"));
	ClassCharacterCombobox = GetComboBoxHandle((m_Windowname $ ".ClassComboboxWnd.ClassCharacterCombobox"));
	List_Empty = GetTextBoxHandle((m_Windowname $ ".DisableWndList.List_Empty"));
	RaceMark = GetTextureHandle((m_Windowname $ ".RaceMark"));
	ClanMark = GetTextureHandle((m_Windowname $ ".ClanMark"));
	ClanMarkClassic = GetTextureHandle((m_Windowname $ ".ClanMarkClassic"));
	ClanNameText = GetTextBoxHandle((m_Windowname $ ".ClanNameText"));
	levelText = GetTextBoxHandle((m_Windowname $ ".LevelText"));
	ClassText = GetTextBoxHandle((m_Windowname $ ".ClassText"));
	NameText = GetTextBoxHandle((m_Windowname $ ".NameText"));
	RankingHelpButton = GetButtonHandle((m_Windowname $ ".RankingHelpButton"));
	DetailInformationButton = GetButtonHandle((m_Windowname $ ".DetailInformationButton"));
	RankingTabAllWnd = GetWindowHandle((m_Windowname $ ".RankingTabAllWnd"));
	Top150Button = GetButtonHandle((m_Windowname $ ".RankingTabAllWnd.Top150Button"));
	MyRankingButton = GetButtonHandle((m_Windowname $ ".RankingTabAllWnd.MyRankingButton"));
	RefreshButton = GetButtonHandle((m_Windowname $ ".RankingTabAllWnd.RefreshButton"));
	RaceComboboxWnd = GetWindowHandle((m_Windowname $ ".RankingTabAllWnd.RaceComboboxWnd"));
	RaceCategoryText = GetTextBoxHandle((m_Windowname $ ".RankingTabAllWnd.RaceComboboxWnd.RaceCategoryText"));
	RaceCategoryCombobox = GetComboBoxHandle((m_Windowname $ ".RankingTabAllWnd.RaceComboboxWnd.RaceCategoryCombobox"));
	RankingTab_RichList = GetRichListCtrlHandle((m_Windowname $ ".RankingTabAllWnd.RankingTab_RichList"));
	RankingBg2 = GetTextureHandle((m_Windowname $ ".RankingTabAllWnd.RankingBg2"));
	GetTabHandle((m_Windowname $ ".RankingTabAllWnd.TabCtrl2_Classic")).HideWindow();
	GetTabHandle((m_Windowname $ ".RankingTabAllWnd.TabCtrl2_Live")).HideWindow();
	TabCtrl2 = GetTabHandle((m_Windowname $ ".RankingTabAllWnd.TabCtrl2_Classic"));
	RankingTab_RichList.SetSelectedSelTooltip(false);
	RankingTab_RichList.SetAppearTooltipAtMouseX(true);
	RankingTab_RichList.SetUseStripeBackTexture(false);
	RankingTab_RichList.SetTooltipType("RankingReward");
	RankingRewardICON_Ani = GetTextureHandle((m_Windowname $ ".RankingRewardICON_Ani"));
	RankingRewardICON_Btn = GetButtonHandle((m_Windowname $ ".RankingRewardICON_Btn"));
	RankingRewardICON_Btn.SetTooltipType("text");
	RankingRewardMenberCheck_Btn = GetButtonHandle((m_Windowname $ ".RankingRewardMenberCheck_Btn"));
	RankingRewardMenberCheck_Btn.HideWindow();
	LiveRankingWnd = GetWindowHandle((m_Windowname $ ".LiveRankingWnd"));
	ClassicRankingWnd = GetWindowHandle((m_Windowname $ ".ClassicRankingWnd"));
	initUI();
	return;
}

function OnShow()
{
	if(GetWindowHandle("RankingWnd").IsShowWindow())
	{
		DisableWndList.HideWindow();
		SetCusomTooltipAtHelpBtn();
		OnRefreshButtonClick();
		RankingRewardICON_Btn.SetTooltipCustomType(MakeTooltipSimpleText(krTooltip()));
		initFirstShow();
	}
	return;
}

function initFirstShow()
{
	if(!bFirstShow)
	{
		if(getInstanceUIData().GetIsLiveServer())
		{
			LiveRankingWnd.ShowWindow();
			ClassicRankingWnd.HideWindow();
			ClassComboboxWnd.ShowWindow();
			ServerRankingArrow = GetTextureHandle((m_Windowname $ ".LiveRankingWnd.ServerRankingArrow"));
			ServerRankingEqualityText = GetTextBoxHandle((m_Windowname $ ".LiveRankingWnd.ServerRankingEqualityText"));
			ServerMyRankingText = GetTextBoxHandle((m_Windowname $ ".LiveRankingWnd.ServerMyRankingText"));
			RaceRankingText = GetTextBoxHandle((m_Windowname $ ".LiveRankingWnd.RaceRankingText"));
			RaceRankingArrow = GetTextureHandle((m_Windowname $ ".LiveRankingWnd.RaceRankingArrow"));
			RaceRankingEqualityText = GetTextBoxHandle((m_Windowname $ ".LiveRankingWnd.RaceRankingEqualityText"));
			RaceMyRankingText = GetTextBoxHandle((m_Windowname $ ".LiveRankingWnd.RaceMyRankingText"));
			ClassRankingArrow = GetTextureHandle((m_Windowname $ ".LiveRankingWnd.ClassRankingArrow"));
			ClassRankingEqualityText = GetTextBoxHandle((m_Windowname $ ".LiveRankingWnd.ClassRankingEqualityText"));
			ClassMyRankingText = GetTextBoxHandle((m_Windowname $ ".LiveRankingWnd.ClassMyRankingText"));
			TabCtrl2 = GetTabHandle((m_Windowname $ ".RankingTabAllWnd.TabCtrl2_Live"));
			TabCtrl2.ShowWindow();
			initComboBox_ClassID();
		}
		else
		{
			LiveRankingWnd.HideWindow();
			ClassicRankingWnd.ShowWindow();
			ClassComboboxWnd.HideWindow();
			ServerRankingArrow = GetTextureHandle((m_Windowname $ ".ClassicRankingWnd.ServerRankingArrow"));
			ServerRankingEqualityText = GetTextBoxHandle((m_Windowname $ ".ClassicRankingWnd.ServerRankingEqualityText"));
			ServerMyRankingText = GetTextBoxHandle((m_Windowname $ ".ClassicRankingWnd.ServerMyRankingText"));
			RaceRankingText = GetTextBoxHandle((m_Windowname $ ".ClassicRankingWnd.RaceRankingText"));
			RaceRankingArrow = GetTextureHandle((m_Windowname $ ".ClassicRankingWnd.RaceRankingArrow"));
			RaceRankingEqualityText = GetTextBoxHandle((m_Windowname $ ".ClassicRankingWnd.RaceRankingEqualityText"));
			RaceMyRankingText = GetTextBoxHandle((m_Windowname $ ".ClassicRankingWnd.RaceMyRankingText"));
			ClassRankingArrow = GetTextureHandle((m_Windowname $ ".ClassicRankingWnd.ClassRankingArrow"));
			ClassRankingEqualityText = GetTextBoxHandle((m_Windowname $ ".ClassicRankingWnd.ClassRankingEqualityText"));
			ClassMyRankingText = GetTextBoxHandle((m_Windowname $ ".ClassicRankingWnd.ClassMyRankingText"));
			TabCtrl2 = GetTabHandle((m_Windowname $ ".RankingTabAllWnd.TabCtrl2_Classic"));
			TabCtrl2.ShowWindow();
			initComboBox_ClassID();
		}
		bFirstShow = true;
	}
	return;
}

function string krTooltip()
{
	if((int(GetLanguage()) == 0))
	{
		return (("              " $ GetSystemString(13459)) $ "              ");
	}
	return GetSystemString(13459);
}

function OnHide()
{
	return;
}

function OnTimer(int TimeID)
{
	if((TimeID == 1001110))
	{
		hideDisableWnd();
	}
	else if((TimeID == 1000101011))
	{
		npcSpawnTime = (npcSpawnTime - 1);
		refreshNpcSpawnTooltip();
	}
	return;
}

function OnComboBoxItemSelected(string strID, int Index)
{
	OnRefreshButtonClick();
	return;
}

function AddRankingSystemListItem(int nRanking, int nChangeRank, int nRewardServerRank, int nRewardRaceRank, int nRewardClassRank, string PlayerName, string levelStr, int nClassID, string ClanName, int nRace, string ServerName)
{
	local RichListCtrlRowData rowData;
	local string texStr, tmStr;
	local Color applyColor;
	local int nH, nW, tH, tW, nAddY, nAddX, nAddX2, nAddY2, rewardGrade, SkillID, i;
	local bool bisAllReward;
	local string NameLV;
	local RankingRewardUIData rewardUIData;
	local ItemInfo RewardItemInfo;
	local SkillInfo rewardSkillInfo;

	rowData.cellDataList.Length = 5;
	rewardGrade = GetRankingGrade(RANKTYPE_Character, ServerGroup, nRewardServerRank);
	if(((rewardGrade <= 3) && (rewardGrade > 0)))
	{
		bisAllReward = true;
	}
	if((((int(currentRankingGroup) == 2) || (int(currentRankingGroup) == 3)) || (nRankingScope == 1)))
	{
		bisAllReward = true;
	}
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
			applyColor = GetColor(254, 215, 160, 255);
		}
		else
		{
			applyColor = GetColor(70, 70, 70, 255);
		}
		nAddY = 12;
		nAddX = 6;
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, string(nRanking), GetColor(170, 153, 119, 255), false, 20, 10);
		if(bisAllReward)
		{
			applyColor = GetColor(240, 240, 240, 255);
		}
		else
		{
			applyColor = GetColor(70, 70, 70, 255);
		}
		nAddY = 4;
		nAddX = 10;
	}
	rowData.cellDataList[0].szData = ChinaHideName(PlayerName);
	rowData.cellDataList[1].szData = levelStr;
	rowData.cellDataList[2].szData = GetClassType(nClassID);
	if((ClanName == GetSystemString(431)))
	{
		rowData.cellDataList[3].szData = ClanName;
	}
	else
	{
		rowData.cellDataList[3].szData = (ClanName $ ServerName);
	}
	rowData.cellDataList[4].szData = getRaceSystemString(nRace);
	levelStr = (("(" $ levelStr) $ ")");
	if((((getInstanceUIData().GetIsLiveServer() && ((((nRankingGroup == 0) && (nRankingScope == 0)) && ((nRewardServerRank > 150) || (nRewardServerRank == 0))) && (nRanking <= 150))) || ((((nRankingGroup == 1) && (nRankingScope == 0)) && ((nRewardRaceRank > 100) || (nRewardRaceRank == 0))) && (nRanking <= 100))) || ((((nRankingGroup == 4) && (nRankingScope == 0)) && ((nRewardClassRank > 100) || (nRewardClassRank == 0))) && (nRanking <= 100))))
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, "NEW", GetColor(0, 255, 0, 255), false, nAddX, (nAddY - 4));
	}
	else if((((getInstanceUIData().GetIsClassicServer() && ((((nRankingGroup == 0) && (nRankingScope == 0)) && ((nRewardServerRank > 100) || (nRewardServerRank == 0))) && (nRanking <= 100))) || ((((nRankingGroup == 1) && (nRankingScope == 0)) && ((nRewardRaceRank > 10) || (nRewardRaceRank == 0))) && (nRanking <= 10))) || ((((nRankingGroup == 4) && (nRankingScope == 0)) && ((nRewardClassRank > 10) || (nRewardClassRank == 0))) && (nRanking <= 10))))
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, "NEW", GetColor(0, 255, 0, 255), false, nAddX, (nAddY - 4));
	}
	else
	{
		if(((nRankingScope == 1) && (((nRewardServerRank == 0) || (nRewardRaceRank == 0)) || (nRewardClassRank == 0))))
		{
			nChangeRank = 0;
		}
		if((nChangeRank > 0))
		{
			addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_CT1.RankingWnd.RankingWnd_ArrowUp", 8, 8, 6, nAddY);
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, string(nChangeRank), GetColor(230, 101, 101, 255), false, 2, -4);
		}
		else if((nChangeRank == 0))
		{
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, "-", GetColor(153, 153, 153, 255), false, nAddX, (nAddY - 4));
		}
		else
		{
			addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_CT1.RankingWnd.RankingWnd_ArrowDown", 8, 8, 6, nAddY);
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, string(nChangeRank), GetColor(0, 170, 255, 255), false, 2, -4);
		}
	}
	NameLV = ((ChinaHideName(PlayerName) $ ServerName) @ levelStr);
	GetTextSizeDefault(NameLV, nW, nH);
	if((nW > 208))
	{
		GetTextSizeDefault(levelStr, tW, tH);
		tmStr = makeShortStringByPixel((ChinaHideName(PlayerName) $ " "), (208 - tW), "..");
		AddRichListCtrlString(rowData.cellDataList[1].drawitems, ((tmStr $ ServerName) @ levelStr), applyColor, false, 4, -4);
		GetTextSizeDefault((tmStr @ levelStr), nW, nH);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[1].drawitems, NameLV, applyColor, false, 4, -4);
	}
	if(bisAllReward)
	{
		applyColor = GetColor(182, 182, 182, 255);
	}
	else
	{
		applyColor = GetColor(70, 70, 70, 255);
	}
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, getRaceSystemString(nRace), applyColor, true, 3, 2);
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
			GetColor(254, 215, 160, 255);
		}
		else
		{
			applyColor = GetColor(70, 70, 70, 255);
		}
	}
	else if(bisAllReward)
	{
		applyColor = GetColor(182, 182, 182, 255);
	}
	else
	{
		applyColor = GetColor(70, 70, 70, 255);
	}
	if((ClanName == GetSystemString(431)))
	{
		AddRichListCtrlString(rowData.cellDataList[3].drawitems, ClanName, applyColor, false, 5, 0);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[3].drawitems, (ClanName $ ServerName), applyColor, false, 5, 0);
	}
	nAddY = 8;
	nAddY2 = 1;
	if((IsAdenServer() && IsPlayerOnWorldRaidServer()))
	{
		AddRichListCtrlString(rowData.cellDataList[4].drawitems, "-", applyColor, false, 5, 0);
	}
	else
	{
		if(getInstanceUIData().GetIsClassicServer())
		{
			nAddX = 6;
			nAddX2 = -6;
		}
		else
		{
			nAddX = 6;
		}
		i = 1;
		while((i <= 3))
		{
			SkillID = GetRankingRewardSkillID(RANKTYPE_Character, ServerGroup, i);
			addRichListCtrlTexture(rowData.cellDataList[4].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, (nAddX + nAddX2), nAddY);
			nAddX2 = 0;
			addRichListCtrlTexture(rowData.cellDataList[4].drawitems, getSkillTex(SkillID), 32, 32, -34, nAddY2);
			rowData.cellDataList[4].drawitems[(rowData.cellDataList[4].drawitems.Length - 1)].nReservedTooltipID = SkillID;
			nAddY = -1;
			nAddY2 = 1;
			if(isRewardGrade(rewardGrade, i))
			{
				rowData.cellDataList[4].drawitems[(rowData.cellDataList[4].drawitems.Length - 1)].TooltipDesc = "on";
				i++;
				continue;
			}
			rowData.cellDataList[4].drawitems[(rowData.cellDataList[4].drawitems.Length - 1)].TooltipDesc = "off";
			addRichListCtrlTexture(rowData.cellDataList[4].drawitems, "L2UI_CT1.RankingWnd.RankingWnd_DisableSlotOpa70", 32, 32, -32, 0);
			i++;
		}
		SkillID = GetRankingRewardSkillID(RANKTYPE_Character, RaceGroup, 1);
		rewardGrade = GetRankingGrade(RANKTYPE_Character, RaceGroup, nRewardRaceRank);
		addRichListCtrlTexture(rowData.cellDataList[4].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 26, 26, 18, 6);
		addRichListCtrlTexture(rowData.cellDataList[4].drawitems, getSkillTex(SkillID), 24, 24, -24, 1, 32, 32);
		rowData.cellDataList[4].drawitems[(rowData.cellDataList[4].drawitems.Length - 1)].nReservedTooltipID = SkillID;
		if((rewardGrade >= 1))
		{
			rowData.cellDataList[4].drawitems[(rowData.cellDataList[4].drawitems.Length - 1)].TooltipDesc = "on";
		}
		else
		{
			rowData.cellDataList[4].drawitems[(rowData.cellDataList[4].drawitems.Length - 1)].TooltipDesc = "off";
			addRichListCtrlTexture(rowData.cellDataList[4].drawitems, "L2UI_CT1.RankingWnd.RankingWnd_DisableSlotOpa70", 26, 26, -25, -1);
		}
		if(getInstanceUIData().GetIsClassicServer())
		{
			if((nRankingGroup == 4))
			{
				rewardGrade = GetRankingGrade(RANKTYPE_Character, ClassRankingGroup, nRanking);
			}
			else
			{
				rewardGrade = GetRankingGrade(RANKTYPE_Character, ClassRankingGroup, nRewardClassRank);
			}
			nAddX = 4;
			nAddY = 1;
			rewardUIData = GetRankingReward(RANKTYPE_Character, ClassRankingGroup, rewardGrade);
			if((rewardUIData.SkillID > 0))
			{
				GetSkillInfo(rewardUIData.SkillID, 1, 0, rewardSkillInfo);
				addRichListCtrlTexture(rowData.cellDataList[4].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 26, 26, nAddX, (nAddY - 2));
				addRichListCtrlTexture(rowData.cellDataList[4].drawitems, getSkillTex(rewardUIData.SkillID), 24, 24, -24, 1, 32, 32);
				rowData.cellDataList[4].drawitems[(rowData.cellDataList[4].drawitems.Length - 1)].nReservedTooltipID = rewardUIData.SkillID;
				if((nRewardClassRank == 0))
				{
					rowData.cellDataList[4].drawitems[(rowData.cellDataList[4].drawitems.Length - 1)].TooltipDesc = "off";
					addRichListCtrlTexture(rowData.cellDataList[4].drawitems, "L2UI_CT1.RankingWnd.RankingWnd_DisableSlotOpa70", 26, 26, -25, -1);
				}
				else
				{
					rowData.cellDataList[4].drawitems[(rowData.cellDataList[4].drawitems.Length - 1)].TooltipDesc = "on";
				}
			}
			else if((rewardUIData.ItemID > 0))
			{
				RewardItemInfo = GetItemInfoByClassID(rewardUIData.ItemID);
				RewardItemInfo.ItemNum = INT64(rewardUIData.ItemAmount);
				RewardItemInfo.bShowCount = true;
				if((nRewardClassRank == 0))
				{
					AddRichListCtrlItem(rowData.cellDataList[4].drawitems, RewardItemInfo, 24, 24, nAddX, nAddY, "RankingItemRewardOff");
					addRichListCtrlTexture(rowData.cellDataList[4].drawitems, "L2UI_CT1.RankingWnd.RankingWnd_DisableSlotOpa70", 26, 26, -25, -1);
				}
				else
				{
					AddRichListCtrlItem(rowData.cellDataList[4].drawitems, RewardItemInfo, 24, 24, nAddX, nAddY, "RankingItemRewardOn");
				}
			}
			else
			{
				addRichListCtrlTexture(rowData.cellDataList[4].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 26, 26, nAddX, (nAddY - 1));
			}
		}
	}
	if(getInstanceUIData().GetIsLiveServer())
	{
		SkillID = GetRankingRewardSkillID(RANKTYPE_Character, ClassRankingGroup, 1);
		rewardGrade = GetRankingGrade(RANKTYPE_Character, ClassRankingGroup, nRewardClassRank);
		addRichListCtrlTexture(rowData.cellDataList[4].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 26, 26, , -1);
		addRichListCtrlTexture(rowData.cellDataList[4].drawitems, getSkillTex(SkillID), 24, 24, -24, 1, 32, 32);
		rowData.cellDataList[4].drawitems[(rowData.cellDataList[4].drawitems.Length - 1)].nReservedTooltipID = SkillID;
		if((rewardGrade >= 1))
		{
			rowData.cellDataList[4].drawitems[(rowData.cellDataList[4].drawitems.Length - 1)].TooltipDesc = "on";
		}
		else
		{
			rowData.cellDataList[4].drawitems[(rowData.cellDataList[4].drawitems.Length - 1)].TooltipDesc = "off";
			addRichListCtrlTexture(rowData.cellDataList[4].drawitems, "L2UI_CT1.RankingWnd.RankingWnd_DisableSlotOpa70", 26, 26, -25, -1);
		}
	}
	if(bisAllReward)
	{
		if((getWorldNameToLocalName(myInfo.Name) == ChinaOriginName(PlayerName)))
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
		if((getWorldNameToLocalName(myInfo.Name) == ChinaOriginName(PlayerName)))
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

function bool isRewardGrade(int rewardGrade, int rewardNum)
{
	if(((rewardGrade == 1) && (((rewardNum == 1) || (rewardNum == 2)) || (rewardNum == 3))))
	{
		return true;
	}
	else if(((rewardGrade == 2) && ((rewardNum == 1) || (rewardNum == 2))))
	{
		return true;
	}
	else if(((rewardGrade == 3) && (rewardNum == 1)))
	{
		return true;
	}
	return false;
}

function checkVisibleCombo()
{
	if((int(currentRankingGroup) == 1))
	{
		if((int(currentRankingScope) == 0))
		{
			RaceComboboxWnd.ShowWindow();
			ClassComboboxWnd.HideWindow();
		}
		else
		{
			RaceComboboxWnd.HideWindow();
			ClassComboboxWnd.HideWindow();
		}
	}
	else if((int(currentRankingGroup) == 4))
	{
		if((int(currentRankingScope) == 0))
		{
			RaceComboboxWnd.HideWindow();
			ClassComboboxWnd.ShowWindow();
		}
		else
		{
			RaceComboboxWnd.HideWindow();
			ClassComboboxWnd.HideWindow();
		}
	}
	else
	{
		RaceComboboxWnd.HideWindow();
		ClassComboboxWnd.HideWindow();
	}
	return;
}

function OnRClickButton(string Name)
{
	Debug(("Name" @ Name));
	switch(Name)
	{
		case "TabCtrl2_Classic0":
		case "TabCtrl2_Classic1":
		case "TabCtrl2_Classic2":
		case "TabCtrl2_Classic3":
		case "TabCtrl2_Classic4":
		case "TabCtrl2_Live0":
		case "TabCtrl2_Live1":
		case "TabCtrl2_Live2":
		case "TabCtrl2_Live3":
		case "TabCtrl2_Live4":
			setTabState(Name);
			OnRefreshButtonClick();
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
		case "DetailInformationButton":
			OnDetailInformationButtonClick();
			break;
		case "RankingRewardICON_Btn":
			ShowNpcShowAskDialog();
			break;
		case "Top150Button":
			setLikeRadioButton(Name);
			OnRefreshButtonClick();
			break;
		case "MyRankingButton":
			setLikeRadioButton(Name);
			OnRefreshButtonClick();
			break;
		case "RefreshButton":
			OnRefreshButtonClick();
			break;
		case "TabCtrl2_Classic0":
		case "TabCtrl2_Classic1":
		case "TabCtrl2_Classic2":
		case "TabCtrl2_Classic3":
		case "TabCtrl2_Classic4":
		case "TabCtrl2_Live0":
		case "TabCtrl2_Live1":
		case "TabCtrl2_Live2":
		case "TabCtrl2_Live3":
		case "TabCtrl2_Live4":
			setTabState(Name);
			OnRefreshButtonClick();
			break;
		default:
			break;
	}
	return;
}

function ShowNpcShowAskDialog()
{
	if((npcSpawnTime > 0))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13307));
	}
	else
	{
		Class'Interface.UICommonAPI'.static.DialogSetID(11122);
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(13308), ""));
	}
	return;
}

function setTabState(string TabName)
{
	if(getInstanceUIData().GetIsLiveServer())
	{
		super.ReplaceText(TabName, "_Live", "");
		switch(TabName)
		{
			case "TabCtrl20":
				SettingButton(Top150Button, true, 13016);
				SettingButton(MyRankingButton, true, 3975);
				RaceComboboxWnd.HideWindow();
				currentRankingGroup = ServerGroup;
				break;
			case "TabCtrl21":
				SettingButton(Top150Button, true, 3972);
				SettingButton(MyRankingButton, true, 3975);
				currentRankingGroup = RaceGroup;
				break;
			case "TabCtrl22":
				SettingButton(Top150Button, true, 3972);
				SettingButton(MyRankingButton, true, 3975);
				currentRankingGroup = ClassRankingGroup;
				break;
			case "TabCtrl23":
				SettingButton(Top150Button, false);
				SettingButton(MyRankingButton, false);
				RaceComboboxWnd.HideWindow();
				currentRankingGroup = Pledge;
				break;
			case "TabCtrl24":
				SettingButton(Top150Button, false);
				SettingButton(MyRankingButton, false);
				RaceComboboxWnd.HideWindow();
				currentRankingGroup = Friends;
				break;
			default:
				break;
		}
	}
	else
	{
		super.ReplaceText(TabName, "_Classic", "");
		switch(TabName)
		{
			case "TabCtrl20":
				SettingButton(Top150Button, true, 3972);
				SettingButton(MyRankingButton, false);
				RaceComboboxWnd.HideWindow();
				currentRankingGroup = ServerGroup;
				break;
			case "TabCtrl21":
				SettingButton(Top150Button, true, 14293);
				SettingButton(MyRankingButton, false);
				currentRankingGroup = RaceGroup;
				break;
			case "TabCtrl22":
				SettingButton(Top150Button, true, 14293);
				SettingButton(MyRankingButton, false);
				currentRankingGroup = ClassRankingGroup;
				break;
			case "TabCtrl23":
				SettingButton(Top150Button, false);
				SettingButton(MyRankingButton, false);
				RaceComboboxWnd.HideWindow();
				currentRankingGroup = Pledge;
				break;
			case "TabCtrl24":
				SettingButton(Top150Button, false);
				SettingButton(MyRankingButton, false);
				RaceComboboxWnd.HideWindow();
				currentRankingGroup = Friends;
				break;
			default:
				break;
		}
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

function OnDetailInformationButtonClick()
{
	checkShowRankingHistoryWnd();
	return;
}

function checkShowRankingHistoryWnd()
{
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("RankingHistoryWnd"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("RankingHistoryWnd");
	}
	else
	{
		RequestMyRankingHistory();
	}
	return;
}

function OnRefreshButtonClick()
{
	local int nComboIndex, nRace;

	checkVisibleCombo();
	RequestRankingCharInfo();
	setMYInfo();
	nComboIndex = ClassCharacterCombobox.GetSelectedNum();
	if(IsAdenServer())
	{
		if((RaceCategoryCombobox.GetSelectedNum() == 6))
		{
			nRace = 30;
		}
		else if((RaceCategoryCombobox.GetSelectedNum() == 7))
		{
			nRace = 31;
		}
		else
		{
			nRace = RaceCategoryCombobox.GetSelectedNum();
		}
	}
	else
	{
		nRace = RaceCategoryCombobox.GetSelectedNum();
	}
	RequestRankingCharRankers(currentRankingGroup, currentRankingScope, nRace, ClassCharacterCombobox.GetReserved(nComboIndex));
	Debug((((("---> RequestRankingCharRankers " @ string(currentRankingGroup)) @ string(currentRankingScope)) @ string(nRace)) @ string(ClassCharacterCombobox.GetReserved(nComboIndex))));
	setDisableWnd();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 11260:
			MyRankingDetailInfoHandler(param);
			break;
		case 11270:
			Debug(("EV_CharacterRankingListBegin : " @ param));
			characterRankingListBeginHandler(param);
			break;
		case 11271:
			Debug(("EV_CharacterRankingInfo : " @ param));
			if(isSameEventWithCurrentState(int(currentRankingGroup), int(currentRankingScope), nRankingGroup, nRankingScope))
			{
				addListByCharacterRankingInfo(param);
			}
			break;
		case 11272:
			Debug(("EV_CharacterRankingListEnd : " @ param));
			if(isSameEventWithCurrentState(int(currentRankingGroup), int(currentRankingScope), nRankingGroup, nRankingScope))
			{
				characterRankingListEndHandler(param);
			}
			break;
		case EV_PacketID(817):
			ParsePacket_S_EX_RANKING_CHAR_BUFFZONE_NPC_INFO();
			break;
		case EV_PacketID(818):
			ParsePacket_S_EX_RANKING_CHAR_BUFFZONE_NPC_POSITION();
			break;
		case 1710:
			HandleDialogOK();
			break;
		case 1720:
			break;
		case 40:
			initUI();
			break;
		default:
			break;
	}
	return;
}

function HandleDialogOK()
{
	local int dialogID;

	if(!DialogIsMine())
	{
		return;
	}
	dialogID = DialogGetID();
	if((dialogID == 11122))
	{
		API_C_EX_RANKING_CHAR_SPAWN_BUFFZONE_NPC();
	}
	return;
}

function initUI()
{
	local int i;

	bFirstShow = false;
	npcSpawnTime = 0;
	Me.KillTimer(1000101011);
	RankingTab_RichList.DeleteAllItem();
	TabCtrl2.SetTopOrder(0, false);
	setTabState("TabCtrl20");
	setLikeRadioButton("Top150Button");
	RaceRankingEqualityText.SetText("");
	ServerRankingEqualityText.SetText("");
	ServerMyRankingText.SetText("");
	RaceMyRankingText.SetText("");
	RankingRewardMenberCheck_Btn.HideWindow();
	isFirstInit = false;
	hideDisableWnd();
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
	RankingRewardICON_Ani.HideWindow();
	RankingRewardICON_Btn.HideWindow();
	return;
}

function int myClassID()
{
	local int nClass;

	if(getInstanceUIData().GetIsLiveServer())
	{
		nClass = DetailStatusWndScript.getMainClassID();
	}
	else
	{
		nClass = myInfo.nSubClass;
	}
	return nClass;
}

function initComboBox_ClassID()
{
	local int classIndex, Max, nClassSystemString, nMyClassID, nOriginalClassID, selectIndex;
	local string fullNameString;
	local bool bSelect;

	nMyClassID = myClassID();
	Max = Class'NWindow.UIDataManager'.static.GetClassTypeMaxCount();
	ClassCharacterCombobox.Clear();
	bSelect = false;
	classIndex = 0;
	while((classIndex < Max))
	{
		nClassSystemString = Class'NWindow.UIDataManager'.static.GetClassnameSysstringIndexByClassIndex(classIndex);
		fullNameString = GetSystemString(nClassSystemString);
		nOriginalClassID = -1;
		if((fullNameString != ""))
		{
			if(getInstanceUIData().GetIsClassicServer())
			{
				if((GetClassTransferDegree(classIndex) > 2))
				{
					nOriginalClassID = Class'NWindow.UIDataManager'.static.GetRootClassID(classIndex);
					if((nOriginalClassID > -1))
					{
						if(IsDeathKnightClass(nOriginalClassID))
						{
							if((classIndex == 199))
							{
								ClassCharacterCombobox.AddStringWithReserved(fullNameString, classIndex);
							}
						}
						else if(IsAssassinClass(nOriginalClassID))
						{
							if((classIndex == 224))
							{
								ClassCharacterCombobox.AddStringWithReserved(fullNameString, classIndex);
							}
						}
						else
						{
							ClassCharacterCombobox.AddStringWithReserved(fullNameString, classIndex);
						}
					}
				}
			}
			else if((GetClassTransferDegree(classIndex) > 3))
			{
				nOriginalClassID = Class'NWindow.UIDataManager'.static.GetRootClassID(classIndex);
				if((nOriginalClassID > -1))
				{
					if((classIndex != 216))
					{
						ClassCharacterCombobox.AddStringWithReserved(fullNameString, classIndex);
						if((classIndex == 151))
						{
							if((nMyClassID == 151))
							{
								selectIndex = (ClassCharacterCombobox.GetNumOfItems() - 1);
								bSelect = true;
							}
							nClassSystemString = Class'NWindow.UIDataManager'.static.GetClassnameSysstringIndexByClassIndex(216);
							fullNameString = GetSystemString(nClassSystemString);
							ClassCharacterCombobox.AddStringWithReserved(fullNameString, 216);
							if((nMyClassID == 216))
							{
								selectIndex = (ClassCharacterCombobox.GetNumOfItems() - 1);
								bSelect = true;
							}
						}
					}
				}
			}
			if(((classIndex != 151) && (classIndex != 216)))
			{
				if((((nOriginalClassID > -1) && (nMyClassID > 0)) && (nMyClassID == classIndex)))
				{
					selectIndex = (ClassCharacterCombobox.GetNumOfItems() - 1);
					bSelect = true;
				}
			}
		}
		classIndex++;
	}
	if((bSelect == false))
	{
		ClassCharacterCombobox.SetSelectedNum(0);
	}
	else
	{
		ClassCharacterCombobox.SetSelectedNum(selectIndex);
	}
	Debug("다시 다시 초기화 ");  // EN?: Re-initialize
	return;
}

function MyRankingDetailInfoHandler(string param)
{
	local int nServerRank, nRaceRank, nClassRank, nServerRank_Snapshot, nRaceRank_Snapshot, nClassRank_Snapshot;

	Debug(("MyRankingDetailInfoHandler" @ param));
	ParseInt(param, "ServerRank", nServerRank);
	ParseInt(param, "RaceRank", nRaceRank);
	ParseInt(param, "RewardServerRank", nServerRank_Snapshot);
	ParseInt(param, "RewardRaceRank", nRaceRank_Snapshot);
	ParseInt(param, "ClassRank", nClassRank);
	ParseInt(param, "RewardClassRank", nClassRank_Snapshot);
	if((nServerRank_Snapshot == 0))
	{
		nServerRank_Snapshot = nServerRank;
	}
	if((nRaceRank_Snapshot == 0))
	{
		nRaceRank_Snapshot = nRaceRank;
	}
	if((nClassRank_Snapshot == 0))
	{
		nClassRank_Snapshot = nClassRank;
	}
	if(((nServerRank_Snapshot - nServerRank) > 0))
	{
		ServerRankingArrow.ShowWindow();
		ServerRankingArrow.SetTexture("L2UI_ct1.RankingWnd.RankingWnd_ArrowUp");
		ServerRankingEqualityText.SetTextColor(GetColor(230, 101, 101, 255));
		ServerRankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string((nServerRank_Snapshot - nServerRank))));
	}
	else if(((nServerRank_Snapshot - nServerRank) < 0))
	{
		ServerRankingArrow.ShowWindow();
		ServerRankingArrow.SetTexture("L2UI_ct1.RankingWnd.RankingWnd_ArrowDown");
		ServerRankingEqualityText.SetTextColor(GetColor(0, 170, 255, 255));
		ServerRankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string((nServerRank_Snapshot - nServerRank))));
	}
	else
	{
		ServerRankingArrow.HideWindow();
		ServerRankingEqualityText.SetTextColor(GetColor(153, 153, 153, 255));
		ServerRankingEqualityText.SetText("-");
	}
	if(((nRaceRank_Snapshot - nRaceRank) > 0))
	{
		RaceRankingArrow.ShowWindow();
		RaceRankingArrow.SetTexture("L2UI_ct1.RankingWnd.RankingWnd_ArrowUp");
		RaceRankingEqualityText.SetTextColor(GetColor(230, 101, 101, 255));
		RaceRankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string((nRaceRank_Snapshot - nRaceRank))));
	}
	else if(((nRaceRank_Snapshot - nRaceRank) < 0))
	{
		RaceRankingArrow.ShowWindow();
		RaceRankingArrow.SetTexture("L2UI_ct1.RankingWnd.RankingWnd_ArrowDown");
		RaceRankingEqualityText.SetTextColor(GetColor(0, 170, 255, 255));
		RaceRankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string((nRaceRank_Snapshot - nRaceRank))));
	}
	else
	{
		RaceRankingArrow.HideWindow();
		RaceRankingEqualityText.SetTextColor(GetColor(153, 153, 153, 255));
		RaceRankingEqualityText.SetText("-");
	}
	if(((nClassRank_Snapshot - nClassRank) > 0))
	{
		ClassRankingArrow.ShowWindow();
		ClassRankingArrow.SetTexture("L2UI_ct1.RankingWnd.RankingWnd_ArrowUp");
		ClassRankingEqualityText.SetTextColor(GetColor(230, 101, 101, 255));
		ClassRankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string((nClassRank_Snapshot - nClassRank))));
	}
	else if(((nClassRank_Snapshot - nClassRank) < 0))
	{
		ClassRankingArrow.ShowWindow();
		ClassRankingArrow.SetTexture("L2UI_ct1.RankingWnd.RankingWnd_ArrowDown");
		ClassRankingEqualityText.SetTextColor(GetColor(0, 170, 255, 255));
		ClassRankingEqualityText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string((nClassRank_Snapshot - nClassRank))));
	}
	else
	{
		ClassRankingArrow.HideWindow();
		ClassRankingEqualityText.SetTextColor(GetColor(153, 153, 153, 255));
		ClassRankingEqualityText.SetText("-");
	}
	if((nServerRank == 0))
	{
		ServerMyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), " - "));
	}
	else
	{
		ServerMyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(nServerRank)));
	}
	if((nRaceRank == 0))
	{
		RaceMyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), " - "));
	}
	else
	{
		RaceMyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(nRaceRank)));
	}
	if(getInstanceUIData().GetIsClassicServer())
	{
		if((IsAdenServer() && IsPlayerOnWorldRaidServer()))
		{
			RankingRewardICON_Ani.HideWindow();
			RankingRewardICON_Btn.HideWindow();
			Me.KillTimer(1000101011);
			return;
		}
		if(((nServerRank_Snapshot == 1) && (npcSpawnTime <= -1)))
		{
			RankingRewardMenberCheck_Btn.HideWindow();
			RankingRewardICON_Ani.ShowWindow();
			RankingRewardICON_Btn.ShowWindow();
			Me.KillTimer(1000101011);
		}
		if((nServerRank_Snapshot != 1))
		{
			RankingRewardICON_Ani.HideWindow();
			RankingRewardICON_Btn.HideWindow();
			Me.KillTimer(1000101011);
			npcSpawnTime = -1;
			API_C_EX_RANKING_CHAR_BUFFZONE_NPC_POSITION();
		}
	}
	if((nClassRank == 0))
	{
		ClassMyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), " - "));
	}
	else
	{
		ClassMyRankingText.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(nClassRank)));
	}
	return;
}

function bool isSameEventWithCurrentState(int nRankingGroup, int nRankingScope, int nCurrentRankingGroup, int nCurrentRankingScope)
{
	switch(nRankingGroup)
	{
		case 0:
		case 1:
		case 4:
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

function characterRankingListBeginHandler(string param)
{
	local int nRace, nClass, nRankingGroupTm, nRankingScopeTm;

	ParseInt(param, "Race", nRace);
	ParseInt(param, "RankingGroup", nRankingGroupTm);
	ParseInt(param, "RankingScope", nRankingScopeTm);
	ParseInt(param, "Class", nClass);
	if(isSameEventWithCurrentState(int(currentRankingGroup), int(currentRankingScope), nRankingGroupTm, nRankingScopeTm))
	{
		RankingTab_RichList.DeleteAllItem();
		bIAmRanker = false;
		myRankingInList = 0;
		nRankingGroup = nRankingGroupTm;
		nRankingScope = nRankingScopeTm;
	}
	return;
}

function characterRankingListEndHandler(string param)
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
			case ClassRankingGroup:
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

function addListByCharacterRankingInfo(string param)
{
	local string UserName, PledgeName;
	local int nClass, nRank, nRace, nLevel, nRewardRaceRank, nRewardServerRank, nChangeRank, nRewardClassRank, nWorldID;
	local string ServerName;

	ParseString(param, "UserName", UserName);
	ParseString(param, "PledgeName", PledgeName);
	ParseInt(param, "Class", nClass);
	ParseInt(param, "Race", nRace);
	ParseInt(param, "Level", nLevel);
	ParseInt(param, "Rank", nRank);
	ParseInt(param, "RewardRaceRank", nRewardRaceRank);
	ParseInt(param, "RewardServerRank", nRewardServerRank);
	ParseInt(param, "RewardClassRank", nRewardClassRank);
	if((IsAdenServer() && IsPlayerOnWorldRaidServer()))
	{
		ParseInt(param, "WorldID", nWorldID);
	}
	if((ChinaOriginName(UserName) == getWorldNameToLocalName(myInfo.Name)))
	{
		bIAmRanker = true;
		myRankingInList = RankingTab_RichList.GetRecordCount();
	}
	Debug(("::--> addListByCharacterRankingInfo:" @ param));
	if((PledgeName == ""))
	{
		PledgeName = GetSystemString(431);
	}
	if((1 == nRankingGroup))
	{
		if((nRewardRaceRank == 0))
		{
			nChangeRank = 0;
		}
		else
		{
			nChangeRank = (nRewardRaceRank - nRank);
		}
	}
	else if((0 == nRankingGroup))
	{
		if((nRewardServerRank == 0))
		{
			nChangeRank = 0;
		}
		else
		{
			nChangeRank = (nRewardServerRank - nRank);
		}
		nChangeRank = (nRewardServerRank - nRank);
	}
	else if((4 == nRankingGroup))
	{
		if((nRewardClassRank == 0))
		{
			nChangeRank = 0;
		}
		else
		{
			nChangeRank = (nRewardClassRank - nRank);
		}
		nChangeRank = (nRewardClassRank - nRank);
	}
	else
	{
		nChangeRank = 0;
	}
	if((nWorldID > 0))
	{
		ServerName = ("_" $ getServerNameByWorldID(nWorldID));
	}
	AddRankingSystemListItem(nRank, nChangeRank, nRewardServerRank, nRewardRaceRank, nRewardClassRank, UserName, ("Lv." $ string(nLevel)), nClass, PledgeName, nRace, ServerName);
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

function SetCusomTooltipAtHelpBtn()
{
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText((" - " $ GetSystemString(13018)), getInstanceL2Util().White, "", true, true);
	if(getInstanceUIData().GetIsLiveServer())
	{
		drawListArr[drawListArr.Length] = addDrawItemText((" - " $ GetSystemString(13040)), getInstanceL2Util().White, "", true, true);
	}
	drawListArr[drawListArr.Length] = addDrawItemText((" - " $ GetSystemString(13019)), getInstanceL2Util().White, "", true, true);
	if(getInstanceUIData().GetIsClassicServer())
	{
		drawListArr[drawListArr.Length] = addDrawItemText((" - " $ GetSystemString(13021)), getInstanceL2Util().White, "", true, true);
	}
	else
	{
		drawListArr[drawListArr.Length] = addDrawItemText((" - " $ GetSystemString(13020)), getInstanceL2Util().White, "", true, true);
	}
	RankingHelpButton.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
	return;
}

function string getSkillTex(int SkillID)
{
	return Class'NWindow.UIDATA_SKILL'.static.GetIconName(GetItemID(SkillID), 1, 0);
}

function setDisableWnd()
{
	disableWnd.ShowWindow();
	RankingWnd(GetScript("RankingWnd")).tabDisable(true);
	Me.SetTimer(1001110, 600);
	return;
}

function hideDisableWnd()
{
	disableWnd.HideWindow();
	RankingWnd(GetScript("RankingWnd")).tabDisable(false);
	Me.KillTimer(1001110);
	return;
}

function API_C_EX_RANKING_CHAR_SPAWN_BUFFZONE_NPC()
{
	local array<byte> stream;

	if((IsAdenServer() && IsPlayerOnWorldRaidServer()))
	{
	}
	else
	{
		Class'Interface.UIPacket'.static.RequestUIPacket(598, stream);
		Debug("----> Api Call : API_C_EX_RANKING_CHAR_SPAWN_BUFFZONE_NPC");
	}
	return;
}

function API_C_EX_RANKING_CHAR_BUFFZONE_NPC_POSITION()
{
	local array<byte> stream;

	if((IsAdenServer() && IsPlayerOnWorldRaidServer()))
	{
	}
	else
	{
		Class'Interface.UIPacket'.static.RequestUIPacket(599, stream);
		Debug("----> Api Call : API_C_EX_RANKING_CHAR_BUFFZONE_NPC_POSITION");
	}
	return;
}

function ParsePacket_S_EX_RANKING_CHAR_BUFFZONE_NPC_INFO()
{
	local UIPacket._S_EX_RANKING_CHAR_BUFFZONE_NPC_INFO packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_RANKING_CHAR_BUFFZONE_NPC_INFO(packet))
	{
		return;
	}
	Debug(("이벤트 스폰 타임 " @ string(packet.nRemainedCooltime)));  // EN?: Event spawn time
	npcSpawnTime = packet.nRemainedCooltime;
	Me.KillTimer(1000101011);
	if((npcSpawnTime > 0))
	{
		Me.SetTimer(1000101011, 1000);
	}
	refreshNpcSpawnTooltip();
	return;
}

function ParsePacket_S_EX_RANKING_CHAR_BUFFZONE_NPC_POSITION()
{
	local UIPacket._S_EX_RANKING_CHAR_BUFFZONE_NPC_POSITION packet;
	local Vector vec;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_RANKING_CHAR_BUFFZONE_NPC_POSITION(packet))
	{
		return;
	}
	vec.X = float(packet.nPosX);
	vec.Y = float(packet.nPosY);
	vec.Z = float(packet.nPosZ);
	if((int(packet.bIsInWorld) > 0))
	{
		RankingRewardMenberCheck_Btn.ShowWindow();
		RankingRewardMenberCheck_Btn.SetTooltipCustomType(MakeTooltipMultiText(GetSystemString(13459), GTColor().Yellow, "HS11", false, GetZoneNameWithLocation(vec), GTColor().White, "", true));
		RankingRewardMenberCheck_Btn.EnableWindow();
		Debug((("npc 출현 위치  " @ string(packet.bIsInWorld)) @ GetZoneNameWithLocation(vec)));  // EN?: npc appearance location
	}
	else
	{
		RankingRewardMenberCheck_Btn.ShowWindow();
		RankingRewardMenberCheck_Btn.SetTooltipCustomType(MakeTooltipMultiText(GetSystemString(13459), GTColor().White, "HS11", false, GetSystemString(13472), GTColor().Gray, "", true));
		RankingRewardMenberCheck_Btn.DisableWindow();
	}
	return;
}

function refreshNpcSpawnTooltip()
{
	if((npcSpawnTime > 0))
	{
		RankingRewardICON_Ani.HideWindow();
		RankingRewardICON_Btn.ShowWindow();
		RankingRewardMenberCheck_Btn.HideWindow();
		RankingRewardICON_Btn.SetTooltipCustomType(MakeTooltipMultiText(GetSystemString(13460), getInstanceL2Util().Yellow, "HS11", false, ((GetSystemString(1108) $ " : ") $ getInstanceL2Util().getTimeStringBySec(npcSpawnTime, true, true)), getInstanceL2Util().Yellow, "", true));
		RankingRewardICON_Btn.SetTexture("L2UI_Epic.RankingWnd.RankingBuffIconDisable_n", "L2UI_Epic.RankingWnd.RankingBuffIconDisable_d", "L2UI_Epic.RankingWnd.RankingBuffIconDisable_o");
	}
	else
	{
		RankingRewardICON_Ani.ShowWindow();
		RankingRewardICON_Btn.ShowWindow();
		RankingRewardMenberCheck_Btn.HideWindow();
		RankingRewardICON_Btn.SetTooltipCustomType(MakeTooltipSimpleText(krTooltip()));
		RankingRewardICON_Btn.SetTexture("L2UI_Epic.RankingWnd.RankingBuffIcon_n", "L2UI_Epic.RankingWnd.RankingBuffIcon_d", "L2UI_Epic.RankingWnd.RankingBuffIcon_o");
	}
	return;
}
