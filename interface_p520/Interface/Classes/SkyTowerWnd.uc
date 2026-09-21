class SkyTowerWnd extends UICommonAPI
	dependson(UIPacket);

const Time_ID_Remain = 123445;
const CState_Waiting = 'cWaiting';
const CState_Percentage = 'cPercentage';
const CState_Reward = 'cReward';
const CState_Ongoing = 'cOngoing';
const CState_RewardPopup = 'cRewardPopup';

var int waitingRemainTimeSec;
var WindowHandle Me;
var WindowHandle PercentageWnd;
var RichListCtrlHandle Percentage_List;
var WindowHandle RewardWnd;
var ItemWindowHandle Reward_itemwindow;
var TextBoxHandle RewardDesc01_txt;
var TextBoxHandle RewardItemName_txt;
var TextBoxHandle RewardItemNum_txt;
var TextBoxHandle RewardDesc02_txt;
var ButtonHandle RewardGet_btn;
var ButtonHandle RewardOk_btn;
var EffectViewportWndHandle EffectViewport00;
var WindowHandle OngoingWnd;
var TextBoxHandle OngoingLeftTime_txt;
var RichListCtrlHandle OngoingList;
var WindowHandle WaitingWnd;
var TextBoxHandle WaitingLeftTime_txt;
var RichListCtrlHandle WaitingList;
var WindowHandle UIControlDialogAsset;
var ButtonHandle Reward_Btn;
var array<UIPacket._ServerWarLeaderInfo> lstServerWarLeaderInfoList;
var int nRewardState;
var int nRewardClassID;
var INT64 nRewardItemAmount;
var int nRewardEnchanted;
var int nSelectLeaderWorldID;
var int nSelectLeaderDBID;
var int nCurrentRank;
var int nCurrentNumOfFollwer;
var bool bIsLockVote;
var bool bIsSetLeader;
var array<L2ItemAmount> rewardItem;
var array<int> rankingRewardProb;
var int minPoint;
//var delegate<SortByPoint> __SortByPoint__Delegate;

static function SkyTowerWnd Inst()
{
	return SkyTowerWnd(GetScript("SkyTowerWnd"));
}

function OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent((100000 + 1134));
	RegisterEvent((100000 + 1126));
	RegisterEvent((100000 + 1128));
	RegisterEvent((100000 + 1129));
	RegisterEvent((100000 + 1130));
	RegisterEvent((100000 + 1131));
	RegisterEvent((100000 + 1132));
	RegisterEvent((100000 + 1133));
	RegisterEvent((100000 + 1127));
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	SetPopupScript();
	Class'NWindow.UIDataManager'.static.GetServerWarData(minPoint, rewardItem, rankingRewardProb);
	return;
}

function Initialize()
{
	Me = GetWindowHandle("SkyTowerWnd");
	PercentageWnd = GetWindowHandle("SkyTowerWnd.PercentageWnd");
	Percentage_List = GetRichListCtrlHandle("SkyTowerWnd.PercentageWnd.Percentage_List");
	RewardWnd = GetWindowHandle("SkyTowerWnd.RewardWnd");
	Reward_itemwindow = GetItemWindowHandle("SkyTowerWnd.RewardWnd.Reward_itemwindow");
	RewardDesc01_txt = GetTextBoxHandle("SkyTowerWnd.RewardWnd.RewardDesc01_txt");
	RewardItemName_txt = GetTextBoxHandle("SkyTowerWnd.RewardWnd.RewardItemName_txt");
	RewardItemNum_txt = GetTextBoxHandle("SkyTowerWnd.RewardWnd.RewardItemNum_txt");
	RewardDesc02_txt = GetTextBoxHandle("SkyTowerWnd.RewardWnd.RewardDesc02_txt");
	RewardGet_btn = GetButtonHandle("SkyTowerWnd.RewardWnd.RewardGet_btn");
	RewardOk_btn = GetButtonHandle("SkyTowerWnd.RewardWnd.RewardOk_btn");
	EffectViewport00 = GetEffectViewportWndHandle("SkyTowerWnd.RewardWnd.EffectViewport00");
	OngoingWnd = GetWindowHandle("SkyTowerWnd.OngoingWnd");
	OngoingLeftTime_txt = GetTextBoxHandle("SkyTowerWnd.OngoingWnd.OngoingLeftTime_txt");
	OngoingList = GetRichListCtrlHandle("SkyTowerWnd.OngoingWnd.OngoingList");
	WaitingWnd = GetWindowHandle("SkyTowerWnd.WaitingWnd");
	WaitingLeftTime_txt = GetTextBoxHandle("SkyTowerWnd.WaitingWnd.WaitingLeftTime_txt");
	WaitingList = GetRichListCtrlHandle("SkyTowerWnd.WaitingWnd.WaitingList");
	UIControlDialogAsset = GetWindowHandle("SkyTowerWnd.UIControlDialogAsset");
	Reward_Btn = GetButtonHandle("SkyTowerWnd.Reward_btn");
	PercentageWnd.HideWindow();
	RewardWnd.HideWindow();
	OngoingWnd.HideWindow();
	WaitingWnd.HideWindow();
	OngoingList.SetTooltipType("SimpleRichListTooltip");
	OngoingList.SetSelectedSelTooltip(false);
	OngoingList.SetAppearTooltipAtMouseX(true);
	WaitingList.SetTooltipType("SimpleRichListTooltip");
	WaitingList.SetSelectedSelTooltip(false);
	WaitingList.SetAppearTooltipAtMouseX(true);
	Percentage_List.SetSelectable(false);
	return;
}

function OnShow()
{
	if(IsInState('cWaiting'))
	{
		WaitingLeftTime_txt.SetText((GetSystemString(1199) $ " : "));
	}
	else
	{
		OngoingLeftTime_txt.SetText((GetSystemString(1199) $ " : "));
	}
	Me.SetFocus();
	return;
}

function RefreshReward_Waiting()
{
	local int i;
	local ItemInfo Info;

	i = 0;
	while((i < 5))
	{
		GetMeItemWindow((("WaitingWnd.WaitingReward0" $ string((i + 1))) $ "_itemwindow")).Clear();
		GetMeTextBox((("WaitingWnd.WaitingReward0" $ string((i + 1))) $ "Num_txt")).ShowWindow();
		GetMeTextBox((("WaitingWnd.WaitingReward0" $ string((i + 1))) $ "Num_txt")).SetText("");
		GetMeTexture((("WaitingWnd.WaitingReward0" $ string((i + 1))) $ "NumBg_tex")).ShowWindow();
		i++;
	}
	i = 0;
	while((i < rewardItem.Length))
	{
		Info = GetItemInfoByClassID(rewardItem[i].ItemClassID);
		Info.ItemNum = INT64(rewardItem[i].ItemAmount);
		GetMeItemWindow((("WaitingWnd.WaitingReward0" $ string((i + 1))) $ "_itemwindow")).Clear();
		GetMeItemWindow((("WaitingWnd.WaitingReward0" $ string((i + 1))) $ "_itemwindow")).AddItem(Info);
		GetMeTextBox((("WaitingWnd.WaitingReward0" $ string((i + 1))) $ "Num_txt")).SetText(("x" $ string(Info.ItemNum)));
		i++;
	}
	return;
}

function RefreshReward_Ongoing()
{
	local int i;
	local ItemInfo Info;

	i = 0;
	while((i < 5))
	{
		GetMeItemWindow((("OngoingWnd.OngoingReward0" $ string((i + 1))) $ "_itemwindow")).Clear();
		GetMeTextBox((("OngoingWnd.OngoingReward0" $ string((i + 1))) $ "Num_txt")).ShowWindow();
		GetMeTextBox((("OngoingWnd.OngoingReward0" $ string((i + 1))) $ "Num_txt")).SetText("");
		GetMeTexture((("OngoingWnd.OngoingReward0" $ string((i + 1))) $ "NumBg_tex")).ShowWindow();
		i++;
	}
	i = 0;
	while((i < rewardItem.Length))
	{
		Info = GetItemInfoByClassID(rewardItem[i].ItemClassID);
		Info.ItemNum = INT64(rewardItem[i].ItemAmount);
		GetMeItemWindow((("OngoingWnd.OngoingReward0" $ string((i + 1))) $ "_itemwindow")).Clear();
		GetMeItemWindow((("OngoingWnd.OngoingReward0" $ string((i + 1))) $ "_itemwindow")).AddItem(Info);
		GetMeTextBox((("OngoingWnd.OngoingReward0" $ string((i + 1))) $ "Num_txt")).SetText(("x" $ string(Info.ItemNum)));
		i++;
	}
	return;
}

function SelectRewardItem(int ItemClassID, INT64 Amount, int nItemEnchanted)
{
	local int i;
	local ItemInfo Info;

	Debug(("nRewardClassID" @ string(ItemClassID)));
	i = 1;
	while((i < 6))
	{
		if((GetMeItemWindow((("OngoingWnd.OngoingReward0" $ string(i)) $ "_itemwindow")).GetItemNum() > 0))
		{
			GetMeItemWindow((("OngoingWnd.OngoingReward0" $ string(i)) $ "_itemwindow")).GetItem(0, Info);
			if((((Info.Id.ClassID == ItemClassID) && (Info.ItemNum == Amount)) && (Info.Enchanted == nItemEnchanted)))
			{
				GetMeTexture((("OngoingWnd.OngoingReward0" $ string(i)) $ "Disable_tex")).HideWindow();
				Debug(("보상 획득 아이템 선정 " @ string(ItemClassID)));  // EN?: Select rewarded items
				GetMeTexture((("OngoingWnd.OngoingReward0" $ string(i)) $ "NumBg_tex")).ShowWindow();
				GetMeTextBox((("OngoingWnd.OngoingReward0" $ string(i)) $ "Num_txt")).ShowWindow();
				GetMeTexture((("OngoingWnd.OngoingReward0" $ string(i)) $ "NumBg_tex")).ShowWindow();
				i++;
				continue;
			}
			GetMeTexture((("OngoingWnd.OngoingReward0" $ string(i)) $ "Disable_tex")).ShowWindow();
			GetMeTextBox((("OngoingWnd.OngoingReward0" $ string(i)) $ "Num_txt")).HideWindow();
			GetMeTexture((("OngoingWnd.OngoingReward0" $ string(i)) $ "NumBg_tex")).HideWindow();
		}
		i++;
	}
	return;
}

function OnClickButton(string Name)
{
	Debug(("Name" @ Name));
	switch(Name)
	{
		case "PercentageClose_Btn":
			OnPercentageClose_BtnClick();
			break;
		case "RewardClose_Btn":
			OnRewardClose_BtnClick();
			break;
		case "RewardGet_btn":
			OnRewardGet_btnClick();
			break;
		case "RewardOk_btn":
			OnRewardOk_btnClick();
			break;
		case "WindowHelp_BTN":
			OnWindowHelp_BTNClick();
			break;
		case "OngoingReward_btn":
			OnOngoingReward_btnClick();
			break;
		case "OngoingRefresh_btn":
			OnOngoingRefresh_btnClick();
			break;
		case "Teleport_btn":
			OnTeleport_btnClick();
			break;
		case "Reward_btn":
			OnReward_BtnClick();
			break;
		case "VoteRichlistBtn":
			if((Class'Interface.NoticeHUD'.static.Inst().skyTowerCurrentState == 2))
			{
				VoteRichlistBtn_btnClick();
			}
			break;
		case "WindowClose_Btn":
			WindowClose_BtnClick();
			break;
		default:
			break;
	}
	return;
}

function OnPercentageClose_BtnClick()
{
	if((Class'Interface.NoticeHUD'.static.Inst().skyTowerCurrentState == 4))
	{
		GotoState('cOngoing');
	}
	else
	{
		GotoState('cReward');
	}
	return;
}

function OnRewardClose_BtnClick()
{
	GotoState('cReward');
	return;
}

function OnRewardGet_btnClick()
{
	API_C_EX_SERVERWAR_GET_REWARD(Class'Interface.NoticeHUD'.static.Inst().skyTowerFieldID);
	return;
}

function OnRewardOk_btnClick()
{
	if((Class'Interface.NoticeHUD'.static.Inst().skyTowerCurrentState == 4))
	{
		GotoState('cOngoing');
	}
	else
	{
		GotoState('cReward');
	}
	return;
}

function OnWindowHelp_BTNClick()
{
	Class'Interface.HelpWnd'.static.ShowHelp(74);
	return;
}

function OnOngoingReward_btnClick()
{
	GotoState('cPercentage');
	return;
}

function OnOngoingRefresh_btnClick()
{
	API_C_EX_SERVERWAR_BATTLE_HUD_INFO(Class'Interface.NoticeHUD'.static.Inst().skyTowerFieldID);
	return;
}

function OnTeleport_btnClick()
{
	Debug("텔레포트");  // EN?: Teleport
	API_C_EX_SERVERWAR_MOVE_TO_LEADER_CAMP(Class'Interface.NoticeHUD'.static.Inst().skyTowerFieldID, nSelectLeaderWorldID, nSelectLeaderDBID);
	Me.HideWindow();
	return;
}

function OnReward_BtnClick()
{
	GotoState('cRewardPopup');
	return;
}

function VoteRichlistBtn_btnClick()
{
	Debug(("VoteRichlistBtn_btnClick" @ string(bIsLockVote)));
	Debug(("amILeaderOfSkytower()" @ string(amILeaderOfSkytower())));
	Debug(("amIFollower()" @ string(amIFollower())));
	Debug(("amIFollowerOfLeader()" @ string(amIFollowerOfLeader())));
	Debug(("nSelectLeaderWorldID" @ string(nSelectLeaderWorldID)));
	Debug(("nSelectLeaderDBID" @ string(nSelectLeaderDBID)));
	Debug(("bIsSetLeader " @ string(bIsSetLeader)));
	if(bIsSetLeader)
	{
		AddSystemMessage(13964);
		return;
	}
	if(amILeaderOfSkytower())
	{
		AddSystemMessage(13964);
		return;
	}
	if(amIFollowerOfLeader())
	{
		return;
	}
	if(((nSelectLeaderWorldID > 0) && (nSelectLeaderDBID > 0)))
	{
		return;
	}
	if((bIsLockVote == false))
	{
		ShowPopup();
	}
	return;
}

function WindowClose_BtnClick()
{
	Me.HideWindow();
	return;
}

function refreshList_Percentage()
{
	local int i, N;
	local bool bIsCurrentRank;

	Percentage_List.DeleteAllItem();
	Debug("대표자");  // EN?: Representative
	Debug(("nSelectLeaderWorldID" @ string(nSelectLeaderWorldID)));
	Debug(("nSelectLeaderDBID" @ string(nSelectLeaderDBID)));
	i = 1;
	while((i < 6))
	{
		if((i == 5))
		{
			GetMeTextBox((("PercentageWnd.rank" $ string(i)) $ "_txt")).SetText("-");
		}
		else
		{
			GetMeTextBox((("PercentageWnd.rank" $ string(i)) $ "_txt")).SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(i)));
		}
		Percentage_List.InsertRecord(MakeRecord_Percentage());
		GetMeTextBox((("PercentageWnd.UserName0" $ string(i)) $ "_txt")).SetText("-");
		i++;
	}
	i = 0;
	while((i < lstServerWarLeaderInfoList.Length))
	{
		if(((nSelectLeaderWorldID == lstServerWarLeaderInfoList[i].nWorldID) && (nSelectLeaderDBID == lstServerWarLeaderInfoList[i].nDBID)))
		{
			GetMeTextBox((("PercentageWnd.UserName0" $ string((i + 1))) $ "_txt")).SetTextColor(GTColor().Yellow);
		}
		else
		{
			GetMeTextBox((("PercentageWnd.UserName0" $ string((i + 1))) $ "_txt")).SetTextColor(GTColor().White);
		}
		GetMeTextBox((("PercentageWnd.UserName0" $ string((i + 1))) $ "_txt")).SetText(ConvertWorldIDToStr(lstServerWarLeaderInfoList[i].sName));
		textBoxShortStringWithTooltip(GetMeTextBox((("PercentageWnd.UserName0" $ string((i + 1))) $ "_txt")), true, -6);
		i++;
	}
	Debug(("nCurrentRank" @ string(nCurrentRank)));
	N = 0;
	while((N < 4))
	{
		if((nCurrentRank == (N + 1)))
		{
			bIsCurrentRank = true;
		}
		else
		{
			bIsCurrentRank = false;
		}
		i = 0;
		while((i < lstServerWarLeaderInfoList.Length))
		{
			if(((((nSelectLeaderWorldID == lstServerWarLeaderInfoList[i].nWorldID) && (nSelectLeaderDBID == lstServerWarLeaderInfoList[i].nDBID)) && (nSelectLeaderWorldID > 0)) && (nSelectLeaderDBID > 0)))
			{
				ModifyRecord_Percentage(N, i, (getRewardProb(lstServerWarLeaderInfoList[i].lNumOfFollower, (N + 1)) $ "%"), true, bIsCurrentRank);
				i++;
				continue;
			}
			ModifyRecord_Percentage(N, i, (getRewardProb(lstServerWarLeaderInfoList[i].lNumOfFollower, (N + 1)) $ "%"), false, false);
			i++;
		}
		N++;
	}
	return;
}

function refreshList_Ongoing()
{
	local int i;

	OngoingList.DeleteAllItem();
	i = 0;
	while((i < lstServerWarLeaderInfoList.Length))
	{
		Debug(("전쟁포인트nTotalServerWarPoint: " @ string(lstServerWarLeaderInfoList[i].nTotalServerWarPoint)));  // EN?: warpointnTotalServerWarPoint:
		OngoingList.InsertRecord(MakeRecord_Ongoing((i + 1), lstServerWarLeaderInfoList[i].nWorldID, lstServerWarLeaderInfoList[i].nDBID, lstServerWarLeaderInfoList[i].sName, lstServerWarLeaderInfoList[i].nPledgeSId, lstServerWarLeaderInfoList[i].sPledgeName, lstServerWarLeaderInfoList[i].lNumOfFollower, lstServerWarLeaderInfoList[i].nTotalServerWarPoint));
		i++;
	}
	return;
}

function refreshList_waiting()
{
	local int i;

	WaitingList.DeleteAllItem();
	Debug(("refreshList_waiting , lstServerWarLeaderInfoList.Length" @ string(lstServerWarLeaderInfoList.Length)));
	i = 0;
	while((i < lstServerWarLeaderInfoList.Length))
	{
		WaitingList.InsertRecord(MakeRecord_Waiting(lstServerWarLeaderInfoList[i].nWorldID, lstServerWarLeaderInfoList[i].nDBID, lstServerWarLeaderInfoList[i].sName, lstServerWarLeaderInfoList[i].nPledgeSId, lstServerWarLeaderInfoList[i].sPledgeName, lstServerWarLeaderInfoList[i].nWorldID, lstServerWarLeaderInfoList[i].nDBID));
		i++;
	}
	if(((nSelectLeaderWorldID > 0) && (nSelectLeaderDBID > 0)))
	{
		updateVoteCheckList(nSelectLeaderWorldID, nSelectLeaderDBID);
	}
	return;
}

function RichListCtrlRowData MakeRecord_Percentage()
{
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = 5;
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, "-", GTColor().White, false, 1, 4);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, "-", GTColor().White, false, 1, 4);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, "-", GTColor().White, false, 1, 4);
	AddRichListCtrlString(rowData.cellDataList[3].drawitems, "-", GTColor().White, false, 1, 4);
	AddRichListCtrlString(rowData.cellDataList[4].drawitems, "-", GTColor().White, false, 1, 4);
	return rowData;
}

function ModifyRecord_Percentage(int nRow, int nColumnIndex, string strPer, bool bTextColorChange, bool bIsCurrentRank)
{
	local RichListCtrlRowData rowData;
	local int N;

	Percentage_List.GetRec(nRow, rowData);
	N = 0;
	while((N < rowData.cellDataList[nColumnIndex].drawitems.Length))
	{
		rowData.cellDataList[nColumnIndex].drawitems[N].strInfo.strData = "";
		N++;
	}
	if(bTextColorChange)
	{
		if(bIsCurrentRank)
		{
			addRichListCtrlTexture(rowData.cellDataList[nColumnIndex].drawitems, "L2UI_EPIC.WorldSiegeWnd.WorldSiegeWnd_MyPosition_Normal", 13, 15, -14, 1);
			AddRichListCtrlString(rowData.cellDataList[nColumnIndex].drawitems, strPer, GTColor().Green, false, 0, -1);
		}
		else
		{
			AddRichListCtrlString(rowData.cellDataList[nColumnIndex].drawitems, strPer, GTColor().Yellow, false, 1, 0);
		}
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[nColumnIndex].drawitems, strPer, GTColor().White, false, 1, 0);
	}
	Percentage_List.ModifyRecord(nRow, rowData);
	return;
}

function RichListCtrlRowData MakeRecord_Waiting(int WorldID, int DBId, string UserName, int clanID, string ClanName, int nLeaderWorldID, int nLeaderDBID)
{
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = 3;
	rowData.nReserved2 = INT64(nLeaderWorldID);
	rowData.nReserved3 = INT64(nLeaderDBID);
	rowData.szReserved = ConvertWorldIDToStr(UserName);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, ConvertWorldIDToStr(UserName), GTColor().White, false, 1, 6);
	if((clanID > 0))
	{
		AddRichListCtrlPledgeCrestMark(rowData.cellDataList[1].drawitems, clanID, 0, 0, 1, 6);
		AddRichListCtrlString(rowData.cellDataList[1].drawitems, ClanName, GTColor().White, false, 2, -1);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[1].drawitems, GetSystemString(431), GTColor().White, false);
	}
	AddRichListCtrlButton(rowData.cellDataList[2].drawitems, "VoteRichlistBtn", 4, 0, "L2UI_NewTex.SkyTowerWnd.List_CheckBox_Off", "L2UI_NewTex.SkyTowerWnd.List_CheckBox_Off", "L2UI_NewTex.SkyTowerWnd.List_CheckBox_Off", 28, 28, 28, 28, 1, GetSystemString(14592));
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, GetSystemString(14528), GTColor().White, false, 32, 6);
	rowData.nReserved1 = INT64(0);
	return rowData;
}

function RichListCtrlRowData MakeRecord_Ongoing(int nRanking, int WorldID, int DBId, string UserName, int clanID, string ClanName, int nMemberNum, INT64 nPoint)
{
	local RichListCtrlRowData rowData;
	local string texStr;

	rowData.cellDataList.Length = 4;
	rowData.szReserved = ConvertWorldIDToStr(UserName);
	if((nRanking == 1))
	{
		texStr = "L2UI_NewTex.SkyTowerWnd.Rank1st";
	}
	else if((nRanking == 2))
	{
		texStr = "L2UI_EPIC.RankingFestivalWnd.Rank2nd";
	}
	else if((nRanking == 3))
	{
		texStr = "L2UI_EPIC.RankingFestivalWnd.Rank3rd";
	}
	else if((nRanking == 4))
	{
		texStr = "L2UI_EPIC.RankingFestivalWnd.Rank4nd";
	}
	else if((nRanking == 5))
	{
		texStr = "L2UI_EPIC.RankingFestivalWnd.Rank5nd";
	}
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, texStr, 41, 30, 10, 12);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, ConvertWorldIDToStr(UserName), GTColor().White, false, 2, 6);
	if((clanID > 0))
	{
		AddRichListCtrlPledgeCrestMark(rowData.cellDataList[1].drawitems, clanID, 0, 0, 0, 18);
		AddRichListCtrlString(rowData.cellDataList[1].drawitems, ClanName, GTColor().White, false, 6, -2);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[1].drawitems, GetSystemString(431), GTColor().White, true, 0, 18);
	}
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, MakeFullSystemMsg(GetSystemMessage(2782), string(nMemberNum)), GTColor().White, true, 3, 18);
	AddRichListCtrlString(rowData.cellDataList[3].drawitems, MakeCostStringINT64(nPoint), GTColor().White, true, 4, 17);
	Debug("전황");  // EN?: Progress
	Debug(("nSelectLeaderWorldID" @ string(nSelectLeaderWorldID)));
	Debug(("nSelectLeaderDBID" @ string(nSelectLeaderDBID)));
	Debug(("worldID" @ string(WorldID)));
	Debug(("dbID" @ string(DBId)));
	if(((nSelectLeaderWorldID > 0) && (nSelectLeaderDBID > 0)))
	{
		if(((nSelectLeaderWorldID == WorldID) && (nSelectLeaderDBID == DBId)))
		{
			rowData.sOverlayTex = "L2UI_NewTex.SkyTowerWnd.ListSelect";
			rowData.OverlayTexU = 704;
			rowData.OverlayTexV = 52;
			nCurrentRank = nRanking;
			nCurrentNumOfFollwer = nMemberNum;
		}
	}
	return rowData;
}

event OnTimer(int TimerID)
{
	if((TimerID == 123445))
	{
		waitingRemainTimeSec--;
		if(IsInState('cWaiting'))
		{
			WaitingLeftTime_txt.SetText(((GetSystemString(1199) $ " : ") $ getInstanceL2Util().GetTimeStringBySec4(waitingRemainTimeSec)));
		}
		else
		{
			OngoingLeftTime_txt.SetText(((GetSystemString(1199) $ " : ") $ getInstanceL2Util().GetTimeStringBySec4(waitingRemainTimeSec)));
		}
		if((waitingRemainTimeSec <= 0))
		{
			Me.KillTimer(123445);
		}
	}
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 40:
			bIsLockVote = false;
			bIsSetLeader = false;
			nSelectLeaderWorldID = 0;
			nSelectLeaderDBID = 0;
			nCurrentRank = 0;
			nCurrentNumOfFollwer = 0;
			Me.KillTimer(123445);
			break;
		case (100000 + 1126):
			ParsePacket_S_EX_SERVERWAR_BATTLE_HUD_INFO();
			break;
		case (100000 + 1128):
			ParsePacket_S_EX_SERVERWAR_LEADER_LIST();
			break;
		case (100000 + 1129):
			ParsePacket_S_EX_SERVERWAR_SELECT_LEADER();
			break;
		case (100000 + 1130):
			ParsePacket_S_EX_SERVERWAR_SELECT_LEADER_INFO();
			break;
		case (100000 + 1131):
			ParsePacket_S_EX_SERVERWAR_REWARD_ITEM_INFO();
			break;
		case (100000 + 1132):
			ParsePacket_S_EX_SERVERWAR_REWARD_INFO();
			break;
		case (100000 + 1133):
			ParsePacket_S_EX_SERVERWAR_GET_REWARD();
			break;
		case (100000 + 1127):
			ParsePacket_S_EX_SERVERWAR_NOTIFY_SET_LEADER();
			break;
		case (100000 + 1134):
			ParsePacket_S_EX_SERVERWAR_FIELD_ENTER_HUD_INFO();
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_SERVERWAR_NOTIFY_SET_LEADER()
{
	local UIPacket._S_EX_SERVERWAR_NOTIFY_SET_LEADER packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_SERVERWAR_NOTIFY_SET_LEADER(packet))
	{
		return;
	}
	Debug("--- Decode_S_EX_SERVERWAR_NOTIFY_SET_LEADER --- 대표자 선정");  // EN?: --- Decode_S_EX_SERVERWAR_notify_set_leader --- Representative selection
	Debug(("packet.nServerGroupID" @ string(packet.nServerGroupID)));
	Debug(("packet.nLeaderWorldID" @ string(packet.nLeaderWorldID)));
	Debug(("packet.nLeaderDBID" @ string(packet.nLeaderDBID)));
	bIsSetLeader = true;
	return;
}

function ParsePacket_S_EX_SERVERWAR_FIELD_ENTER_HUD_INFO()
{
	local UIPacket._S_EX_SERVERWAR_FIELD_ENTER_HUD_INFO packet;
	local int i;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_SERVERWAR_FIELD_ENTER_HUD_INFO(packet))
	{
		return;
	}
	Debug(((((((((((("---> S_EX_SERVERWAR_FIELD_ENTER_HUD_INFO" @ string(packet.nServerWarFieldID)) @ string(packet.nServerWarState)) @ string(packet.nServerWarNowTime)) @ string(packet.nServerWarRemainTime)) @ string(packet.nServerWarNextStateBeginTime)) @ string(packet.lstServerWarLeaderInfoList.Length)) @ string(packet.nSelectLeaderWorldID)) @ string(packet.nSelectLeaderDBID)) @ string(packet.nRewardItmeClassID)) @ string(packet.nRewardItemAmount)) @ string(packet.nRewardState)));
	lstServerWarLeaderInfoList = packet.lstServerWarLeaderInfoList;
	// lstServerWarLeaderInfoList.Sort(SortByPoint);   // array.Sort() unsupported by this compiler
	i = 0;
	while((i < lstServerWarLeaderInfoList.Length))
	{
		if(((lstServerWarLeaderInfoList[i].nPledgeSId > 0) && (lstServerWarLeaderInfoList[i].nPledgeCrestDBID > 0)))
		{
			AddPledgeInfo(lstServerWarLeaderInfoList[i].nPledgeSId, lstServerWarLeaderInfoList[i].nPledgeCrestDBID);
		}
		i++;
	}
	nRewardState = packet.nRewardState;
	nRewardClassID = packet.nRewardItmeClassID;
	nRewardItemAmount = packet.nRewardItemAmount;
	nRewardEnchanted = packet.nRewardItmeEnchanted;
	nSelectLeaderWorldID = packet.nSelectLeaderWorldID;
	nSelectLeaderDBID = packet.nSelectLeaderDBID;
	Debug(("nSelectLeaderWorldID" @ string(nSelectLeaderWorldID)));
	Debug(("nSelectLeaderDBID" @ string(nSelectLeaderDBID)));
	setRewardButtonState();
	setRewardItemInfo();
	return;
}

function ParsePacket_S_EX_SERVERWAR_GET_REWARD()
{
	local UIPacket._S_EX_SERVERWAR_GET_REWARD packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_SERVERWAR_GET_REWARD(packet))
	{
		return;
	}
	Debug((("---> S_EX_SERVERWAR_GET_REWARD" @ string(packet.nResult)) @ string(packet.nRewardState)));
	if((packet.nResult > 0))
	{
		RewardGet_btn.HideWindow();
		RewardOk_btn.ShowWindow();
		RewardDesc02_txt.SetText(GetSystemString(14580));
		EffectViewport00.SpawnEffect("LineageEffect_br.br_e_firebox_fire_b");
		PlaySound("SkillSound14.d_firework_a");
		nRewardState = packet.nRewardState;
		Reward_Btn.DisableWindow();
	}
	else
	{
		RewardGet_btn.HideWindow();
		RewardOk_btn.ShowWindow();
		RewardDesc02_txt.SetText(GetSystemString(14581));
		EffectViewport00.SpawnEffect("LineageEffect2.ui_upgrade_fail");
		PlaySound("ItemSound3.enchant_fail");
		nRewardState = packet.nRewardState;
		Reward_Btn.DisableWindow();
	}
	return;
}

function ParsePacket_S_EX_SERVERWAR_REWARD_ITEM_INFO()
{
	local UIPacket._S_EX_SERVERWAR_REWARD_ITEM_INFO packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_SERVERWAR_REWARD_ITEM_INFO(packet))
	{
		return;
	}
	Debug(((("---> S_EX_SERVERWAR_REWARD_ITEM_INFO" @ string(packet.nItmeClassID)) @ string(packet.nItemAmount)) @ string(packet.nItemEnchanted)));
	nRewardClassID = packet.nItmeClassID;
	nRewardItemAmount = packet.nItemAmount;
	nRewardEnchanted = packet.nItemEnchanted;
	return;
}

function setRewardItemInfo()
{
	local ItemInfo RewardItemInfo;

	RewardItemInfo = GetItemInfoByClassID(nRewardClassID);
	RewardItemInfo.ItemNum = nRewardItemAmount;
	RewardItemInfo.Enchanted = nRewardEnchanted;
	Reward_itemwindow.Clear();
	Reward_itemwindow.AddItem(RewardItemInfo);
	RewardItemName_txt.SetText(GetItemNameAllByClassID(nRewardClassID));
	RewardItemNum_txt.SetText(("x" $ string(nRewardItemAmount)));
	RewardDesc02_txt.SetText(MakeFullSystemMsg(GetSystemMessage(13895), getRewardProb(nCurrentNumOfFollwer, nCurrentRank)));
	Debug(("getRewardProb(nCurrentRank, nCurrentNumOfFollwer)" @ getRewardProb(nCurrentNumOfFollwer, nCurrentRank)));
	Debug(("nCurrentRank" @ string(nCurrentRank)));
	Debug(("nCurrentNumOfFollwer" @ string(nCurrentNumOfFollwer)));
	return;
}

function ParsePacket_S_EX_SERVERWAR_REWARD_INFO()
{
	local UIPacket._S_EX_SERVERWAR_REWARD_INFO packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_SERVERWAR_REWARD_INFO(packet))
	{
		return;
	}
	Debug(("---> S_EX_SERVERWAR_REWARD_INFO" @ string(packet.nRewardState)));
	nRewardState = packet.nRewardState;
	Me.ShowWindow();
	GotoState('None');
	GotoState('cReward');
	return;
}

function setRewardButtonState()
{
	RewardGet_btn.ShowWindow();
	RewardOk_btn.HideWindow();
	Debug(("amIFollower()" @ string(amIFollower())));
	Debug(("amIFollowerOfLeader()" @ string(amIFollowerOfLeader())));
	Debug(("amILeaderOfSkytower()" @ string(amILeaderOfSkytower())));
	switch(nRewardState)
	{
		case 0:
		case 2:
			if((amIFollowerOfLeader() || amILeaderOfSkytower()))
			{
				RewardGet_btn.EnableWindow();
			}
			else
			{
				RewardGet_btn.DisableWindow();
			}
			break;
		case 1:
		case 3:
			RewardGet_btn.DisableWindow();
			break;
		default:
			break;
	}
	if(((nRewardState == 3) || (nRewardState == 1)))
	{
		Reward_Btn.DisableWindow();
	}
	else if((amIFollowerOfLeader() || amILeaderOfSkytower()))
	{
		Reward_Btn.EnableWindow();
	}
	else
	{
		Reward_Btn.DisableWindow();
	}
	return;
}

function ParsePacket_S_EX_SERVERWAR_SELECT_LEADER()
{
	local UIPacket._S_EX_SERVERWAR_SELECT_LEADER packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_SERVERWAR_SELECT_LEADER(packet))
	{
		return;
	}
	Debug(((("---> S_EX_SERVERWAR_SELECT_LEADER" @ string(packet.nResult)) @ string(packet.nLeaderWorldID)) @ string(packet.nLeaderDBID)));
	if((packet.nResult == 1))
	{
		nSelectLeaderWorldID = packet.nLeaderWorldID;
		nSelectLeaderDBID = packet.nLeaderDBID;
		updateVoteCheckList(packet.nLeaderWorldID, packet.nLeaderDBID);
	}
	return;
}

function ParsePacket_S_EX_SERVERWAR_SELECT_LEADER_INFO()
{
	local UIPacket._S_EX_SERVERWAR_SELECT_LEADER_INFO packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_SERVERWAR_SELECT_LEADER_INFO(packet))
	{
		return;
	}
	Debug((("---> S_EX_SERVERWAR_SELECT_LEADER_INFO" @ string(packet.nLeaderWorldID)) @ string(packet.nLeaderDBID)));
	nSelectLeaderWorldID = packet.nLeaderWorldID;
	nSelectLeaderDBID = packet.nLeaderDBID;
	if(((Class'Interface.NoticeHUD'.static.Inst().skyTowerCurrentState == 4) || (Class'Interface.NoticeHUD'.static.Inst().skyTowerCurrentState == 5)))
	{
	}
	else
	{
		GotoState('None');
		GotoState('cWaiting');
		Me.ShowWindow();
	}
	return;
}

function ParsePacket_S_EX_SERVERWAR_BATTLE_HUD_INFO()
{
	local UIPacket._S_EX_SERVERWAR_BATTLE_HUD_INFO packet;
	local int i;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_SERVERWAR_BATTLE_HUD_INFO(packet))
	{
		return;
	}
	Debug("---> _S_EX_SERVERWAR_BATTLE_HUD_INFO");
	i = 0;
	while((i < packet.lstServerWarBattleHUDInfoList.Length))
	{
		Debug((((string(packet.lstServerWarBattleHUDInfoList[i].nServerGroupID) @ string(packet.lstServerWarBattleHUDInfoList[i].nLeaderWorldID)) @ string(packet.lstServerWarBattleHUDInfoList[i].nLeaderDBID)) @ string(packet.lstServerWarBattleHUDInfoList[i].nTotlaPoint)));
		updateValueTotalPoint(packet.lstServerWarBattleHUDInfoList[i].nLeaderWorldID, packet.lstServerWarBattleHUDInfoList[i].nLeaderDBID, packet.lstServerWarBattleHUDInfoList[i].nTotlaPoint);
		i++;
	}
	// lstServerWarLeaderInfoList.Sort(SortByPoint);   // array.Sort() unsupported by this compiler
	Me.ShowWindow();
	GotoState('None');
	GotoState('cOngoing');
	return;
}

function updateValueTotalPoint(int nWorldID, int nDBID, INT64 nTotalPoint)
{
	local int i;

	Debug(("updateValueTotalPoint, lstServerWarLeaderInfoList.Length" @ string(lstServerWarLeaderInfoList.Length)));
	i = 0;
	while((i < lstServerWarLeaderInfoList.Length))
	{
		if(((lstServerWarLeaderInfoList[i].nWorldID == nWorldID) && (lstServerWarLeaderInfoList[i].nDBID == nDBID)))
		{
			lstServerWarLeaderInfoList[i].nTotalServerWarPoint = nTotalPoint;
			Debug("갱신");  // EN?: Renewals
		}
		i++;
	}
	return;
}

function ParsePacket_S_EX_SERVERWAR_LEADER_LIST()
{
	local UIPacket._S_EX_SERVERWAR_LEADER_LIST packet;
	local int i;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_SERVERWAR_LEADER_LIST(packet))
	{
		return;
	}
	Debug(("---> _S_EX_SERVERWAR_LEADER_LIST" @ string(packet.lstServerWarLeaderInfoList.Length)));
	i = 0;
	while((i < packet.lstServerWarLeaderInfoList.Length))
	{
		Debug(((((((((((((string(packet.lstServerWarLeaderInfoList[i].nServerGroupID) @ string(packet.lstServerWarLeaderInfoList[i].nWorldID)) @ string(packet.lstServerWarLeaderInfoList[i].nDBID)) @ packet.lstServerWarLeaderInfoList[i].sName) @ string(packet.lstServerWarLeaderInfoList[i].nDBID)) @ string(packet.lstServerWarLeaderInfoList[i].nPledgeDBID)) @ string(packet.lstServerWarLeaderInfoList[i].nPledgeSId)) @ string(packet.lstServerWarLeaderInfoList[i].nPledgeCrestDBID)) @ packet.lstServerWarLeaderInfoList[i].sPledgeName) @ string(packet.lstServerWarLeaderInfoList[i].tBossKillTime)) @ string(packet.lstServerWarLeaderInfoList[i].lNumOfFollower)) @ string(packet.lstServerWarLeaderInfoList[i].nTotalServerWarPoint)) @ string(packet.lstServerWarLeaderInfoList[i].nRank)));
		i++;
	}
	lstServerWarLeaderInfoList = packet.lstServerWarLeaderInfoList;
	Debug(("lstServerWarLeaderInfoList Length" @ string(lstServerWarLeaderInfoList.Length)));
	// lstServerWarLeaderInfoList.Sort(SortByPoint);   // array.Sort() unsupported by this compiler
	if(((Class'Interface.NoticeHUD'.static.Inst().skyTowerCurrentState == 5) || (Class'Interface.NoticeHUD'.static.Inst().skyTowerCurrentState == 3)))
	{
	}
	else if((Class'Interface.NoticeHUD'.static.Inst().skyTowerCurrentState == 4))
	{
		Me.ShowWindow();
		GotoState('None');
		GotoState('cOngoing');
	}
	else
	{
		GotoState('None');
		GotoState('cWaiting');
		Me.ShowWindow();
	}
	return;
}

delegate int SortByPoint(UIPacket._ServerWarLeaderInfo A, UIPacket._ServerWarLeaderInfo B)
{
	if((A.nTotalServerWarPoint != B.nTotalServerWarPoint))
	{
		if((A.nTotalServerWarPoint < B.nTotalServerWarPoint))
		{
			return -1;
		}
		return 0;
	}
	if((A.tBossKillTime > B.tBossKillTime))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

function bool amILeaderOfSkytower()
{
	if(bIsSetLeader)
	{
		return true;
	}
	return Class'NWindow.UIDATA_PLAYER'.static.IsServerWarLeader();
}

function bool amIFollower()
{
	return Class'NWindow.UIDATA_PLAYER'.static.IsServerWarFollower();
}

function bool amIFollowerOfLeader()
{
	if(bIsSetLeader)
	{
		return false;
	}
	if(amILeaderOfSkytower())
	{
		return false;
	}
	if(((nSelectLeaderWorldID > 0) && (nSelectLeaderDBID > 0)))
	{
		return true;
	}
	return false;
}

function API_C_EX_SERVERWAR_MOVE_TO_HOST(int nFieldID)
{
	local array<byte> stream;
	local UIPacket._C_EX_SERVERWAR_MOVE_TO_HOST packet;

	packet.nFieldID = nFieldID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_SERVERWAR_MOVE_TO_HOST(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(865, stream);
	Debug(("Api Call -----> C_EX_SERVERWAR_MOVE_TO_HOST" @ string(packet.nFieldID)));
	return;
}

function API_C_EX_SERVERWAR_MOVE_TO_LEADER_CAMP(int nFieldID, int nLeaderWorldID, int nLeaderDBID)
{
	local array<byte> stream;
	local UIPacket._C_EX_SERVERWAR_MOVE_TO_LEADER_CAMP packet;

	packet.nFieldID = nFieldID;
	packet.nLeaderWorldID = nLeaderWorldID;
	packet.nLeaderDBID = nLeaderDBID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_SERVERWAR_MOVE_TO_LEADER_CAMP(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(870, stream);
	Debug(((("Api Call -----> C_EX_SERVERWAR_MOVE_TO_LEADER_CAMP" @ string(packet.nFieldID)) @ string(packet.nLeaderWorldID)) @ string(packet.nLeaderDBID)));
	return;
}

function API_C_EX_SERVERWAR_BATTLE_HUD_INFO(int nFieldID)
{
	local array<byte> stream;
	local UIPacket._C_EX_SERVERWAR_BATTLE_HUD_INFO packet;

	packet.nFieldID = nFieldID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_SERVERWAR_BATTLE_HUD_INFO(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(866, stream);
	Debug(("Api Call -----> C_EX_SERVERWAR_BATTLE_HUD_INFO" @ string(packet.nFieldID)));
	return;
}

function API_C_EX_SERVERWAR_LEADER_LIST(int nFieldID)
{
	local array<byte> stream;
	local UIPacket._C_EX_SERVERWAR_LEADER_LIST packet;

	packet.nFieldID = nFieldID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_SERVERWAR_LEADER_LIST(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(867, stream);
	Debug(("Api Call -----> C_EX_SERVERWAR_LEADER_LIST" @ string(packet.nFieldID)));
	return;
}

function API_C_EX_SERVERWAR_SELECT_LEADER(int nFieldID, int nLeaderWorldID, int nLeaderDBID)
{
	local array<byte> stream;
	local UIPacket._C_EX_SERVERWAR_SELECT_LEADER packet;

	packet.nFieldID = nFieldID;
	packet.nLeaderWorldID = nLeaderWorldID;
	packet.nLeaderDBID = nLeaderDBID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_SERVERWAR_SELECT_LEADER(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(868, stream);
	Debug(((("Api Call -----> C_EX_SERVERWAR_SELECT_LEADER" @ string(packet.nFieldID)) @ string(packet.nLeaderWorldID)) @ string(packet.nLeaderDBID)));
	return;
}

function API_C_EX_SERVERWAR_SELECT_LEADER_INFO(int nFieldID)
{
	local array<byte> stream;
	local UIPacket._C_EX_SERVERWAR_SELECT_LEADER_INFO packet;

	packet.nFieldID = nFieldID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_SERVERWAR_SELECT_LEADER_INFO(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(869, stream);
	Debug(("Api Call -----> C_EX_SERVERWAR_SELECT_LEADER_INFO" @ string(packet.nFieldID)));
	return;
}

function API_C_EX_SERVERWAR_REWARD_ITEM_INFO(int nFieldID)
{
	local array<byte> stream;
	local UIPacket._C_EX_SERVERWAR_REWARD_ITEM_INFO packet;

	packet.nFieldID = nFieldID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_SERVERWAR_REWARD_ITEM_INFO(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(871, stream);
	Debug(("Api Call -----> C_EX_SERVERWAR_REWARD_ITEM_INFO" @ string(packet.nFieldID)));
	return;
}

function API_C_EX_SERVERWAR_REWARD_INFO(int nFieldID)
{
	local array<byte> stream;
	local UIPacket._C_EX_SERVERWAR_REWARD_INFO packet;

	packet.nFieldID = nFieldID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_SERVERWAR_REWARD_INFO(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(872, stream);
	Debug(("Api Call -----> C_EX_SERVERWAR_REWARD_INFO" @ string(packet.nFieldID)));
	return;
}

function API_C_EX_SERVERWAR_GET_REWARD(int nFieldID)
{
	local array<byte> stream;
	local UIPacket._C_EX_SERVERWAR_GET_REWARD packet;

	packet.nFieldID = nFieldID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_SERVERWAR_GET_REWARD(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(873, stream);
	Debug(("Api Call -----> C_EX_SERVERWAR_GET_REWARD" @ string(packet.nFieldID)));
	return;
}

function SetPopupScript()
{
	local WindowHandle popExpandWnd;
	local UIControlDialogAssets popupExpandScript;
	local WindowHandle disableWnd;

	popExpandWnd = GetMeWindow("UIControlDialogAsset");
	popupExpandScript = Class'Interface.UIControlDialogAssets'.static.InitScript(popExpandWnd);
	disableWnd = GetMeWindow("disable_tex");
	popupExpandScript.SetDisableWindow(disableWnd);
	Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop((m_hOwnerWnd.m_WindowNameWithFullPath $ ".disable_tex"), false);
	return;
}

function UIControlDialogAssets GetPopupExpandScript()
{
	local WindowHandle popExpandWnd;

	popExpandWnd = GetMeWindow("UIControlDialogAsset");
	return UIControlDialogAssets(popExpandWnd.GetScript());
}

function ShowPopup()
{
	local UIControlDialogAssets popupExpandScript;
	local RichListCtrlRowData rowData;

	popupExpandScript = GetPopupExpandScript();
	WaitingList.GetRec(WaitingList.GetSelectedIndex(), rowData);
	popupExpandScript.SetDialogDesc(MakeFullSystemMsg(GetSystemMessage(13927), rowData.szReserved));
	popupExpandScript.Show();
	popupExpandScript.OKButton.EnableWindow();
	popupExpandScript.DelegateOnClickBuy = OnDialogOK;
	popupExpandScript.DelegateOnCancel = OnClickCancelDialog;
	showDisable(true);
	return;
}

function OnDialogOK()
{
	local RichListCtrlRowData rowData;

	WaitingList.GetRec(WaitingList.GetSelectedIndex(), rowData);
	API_C_EX_SERVERWAR_SELECT_LEADER(Class'Interface.NoticeHUD'.static.Inst().skyTowerFieldID, int(rowData.nReserved2), int(rowData.nReserved3));
	OnClickCancelDialog();
	return;
}

function updateVoteCheckList(int nLeaderWorldID, int nLeaderDBID)
{
	local RichListCtrlRowData rowData;
	local int i;

	Debug(("bIsLockVote" @ string(bIsLockVote)));
	Debug(("nLeaderWorldID" @ string(nLeaderWorldID)));
	Debug(("nLeaderDBID" @ string(nLeaderDBID)));
	if(((nLeaderWorldID <= 0) && (nLeaderDBID <= 0)))
	{
		return;
	}
	bIsLockVote = false;
	i = 0;
	while((i < WaitingList.GetRecordCount()))
	{
		WaitingList.GetRec(i, rowData);
		if(((rowData.nReserved2 == INT64(nLeaderWorldID)) && (rowData.nReserved3 == INT64(nLeaderDBID))))
		{
			if((rowData.nReserved1 == INT64(0)))
			{
				modifyRichListCtrlButton(rowData.cellDataList[2].drawitems, 0, "VoteRichlistBtn", 4, 8, "L2UI_NewTex.SkyTowerWnd.List_CheckBox_On", "L2UI_NewTex.SkyTowerWnd.List_CheckBox_On", "L2UI_NewTex.SkyTowerWnd.List_CheckBox_On", 28, 28, 28, 28, 2, "");
				rowData.nReserved1 = INT64(1);
				bIsLockVote = true;
				Debug(("투표 했음" @ string(bIsLockVote)));  // EN?: Voted
			}
			else
			{
				modifyRichListCtrlButton(rowData.cellDataList[2].drawitems, 0, "VoteRichlistBtn", 4, 8, "L2UI_NewTex.SkyTowerWnd.List_CheckBox_Off", "L2UI_NewTex.SkyTowerWnd.List_CheckBox_Off", "L2UI_NewTex.SkyTowerWnd.List_CheckBox_Off", 28, 28, 28, 28, 2, GetSystemString(14592));
				rowData.nReserved1 = INT64(0);
			}
			break;
		}
		i++;
	}
	rowData.sOverlayTex = "L2UI_NewTex.SkyTowerWnd.ListSelect";
	rowData.OverlayTexU = 704;
	rowData.OverlayTexV = 52;
	Debug(("RowData.nReserved1" @ string(rowData.nReserved1)));
	Debug(("RowData.nReserved2" @ string(rowData.nReserved2)));
	Debug(("RowData.nReserved3" @ string(rowData.nReserved3)));
	WaitingList.ModifyRecord(i, rowData);
	GetPopupExpandScript().Hide();
	showDisable(false);
	return;
}

function OnClickCancelDialog()
{
	GetPopupExpandScript().Hide();
	showDisable(false);
	return;
}

function string getRewardProb(int nNumOfFollower, int nRank)
{
	local float fSum;

	if(((nRank == 0) || (nNumOfFollower == 0)))
	{
		return "0";
	}
	fSum = ((1.0000000 / float(nNumOfFollower)) * getRewardReduceProb(nRank));
	return cutZeroDecimalStr(ConvertFloatToString(fSum, 4, false));
}

function float getRewardReduceProb(int nRank)
{
	switch(nRank)
	{
		case 1:
			return (float(rankingRewardProb[0]) / 100.0000000);
		case 2:
			return (float(rankingRewardProb[1]) / 100.0000000);
		case 3:
			return (float(rankingRewardProb[2]) / 100.0000000);
		case 4:
			return (float(rankingRewardProb[3]) / 100.0000000);
		case 5:
			return (float(rankingRewardProb[4]) / 100.0000000);
		default:
			return 0.0000000;
	}
}

function showDisable(bool bShow)
{
	if(bShow)
	{
		GetMeWindow("disable_tex").ShowWindow();
		GetMeWindow("disable_tex").SetFocus();
	}
	else
	{
		GetMeWindow("disable_tex").HideWindow();
	}
	return;
}

function OnReceivedCloseUI()
{
	if(GetMeWindow("PercentageWnd").IsShowWindow())
	{
		OnPercentageClose_BtnClick();
	}
	else if(GetMeWindow("RewardWnd").IsShowWindow())
	{
		GotoState('cReward');
	}
	else
	{
		CloseUI();
	}
	return;
}

state cPercentage
{
	function BeginState()
	{
		Debug("Percentage State");
		OngoingWnd.ShowWindow();
		GetMeWindow("disable_tex").ShowWindow();
		GetMeWindow("disable_tex").SetFocus();
		PercentageWnd.ShowWindow();
		RewardWnd.HideWindow();
		WaitingWnd.HideWindow();
		refreshList_Percentage();
		return;
	}
}

state cReward
{
	function BeginState()
	{
		Debug("Reward State");
		GetMeWindow("disable_tex").HideWindow();
		PercentageWnd.HideWindow();
		RewardWnd.HideWindow();
		OngoingWnd.ShowWindow();
		WaitingWnd.HideWindow();
		GetMeTexture("disableRichList_tex").HideWindow();
		GetMeButton("OngoingWnd.OngoingRefresh_btn").DisableWindow();
		GetMeButton("Teleport_btn").HideWindow();
		GetMeButton("Reward_btn").ShowWindow();
		GetMeTextBox("OngoingWnd.OngoingDesc01_txt").SetText(GetSystemString(14577));
		GetMeTextBox("OngoingWnd.OngoingDesc02_txt").SetText(GetSystemString(14579));
		RefreshReward_Ongoing();
		SelectRewardItem(nRewardClassID, nRewardItemAmount, nRewardEnchanted);
		refreshList_Ongoing();
		setRewardButtonState();
		setRewardItemInfo();
		waitingRemainTimeSec = Class'Interface.NoticeHUD'.static.Inst().SkyTowerRemainTime;
		Me.KillTimer(123445);
		Me.SetTimer(123445, 1000);
		return;
	}
}

state cRewardPopup
{
	function BeginState()
	{
		Debug("rewardPopup State");
		GetMeWindow("disable_tex").ShowWindow();
		GetMeWindow("disable_tex").SetFocus();
		PercentageWnd.HideWindow();
		RewardWnd.ShowWindow();
		OngoingWnd.ShowWindow();
		WaitingWnd.HideWindow();
		RewardDesc02_txt.SetText(MakeFullSystemMsg(GetSystemMessage(13895), getRewardProb(nCurrentNumOfFollwer, nCurrentRank)));
		GetMeButton("Teleport_btn").HideWindow();
		GetMeButton("Reward_btn").ShowWindow();
		return;
	}
}

state cOngoing
{
	function BeginState()
	{
		Debug("Ongoing State");
		GetMeWindow("disable_tex").HideWindow();
		if(GetMeWindow("UIControlDialogAsset").IsShowWindow())
		{
			GetPopupExpandScript().Hide();
		}
		GetMeTexture("disableRichList_tex").HideWindow();
		GetMeButton("OngoingWnd.OngoingRefresh_btn").EnableWindow();
		PercentageWnd.HideWindow();
		RewardWnd.HideWindow();
		WaitingWnd.HideWindow();
		OngoingWnd.ShowWindow();
		if((Class'Interface.NoticeHUD'.static.Inst().skyTowerCurrentState == 4))
		{
			GetMeTextBox("OngoingWnd.OngoingDesc01_txt").SetText(GetSystemString(14521));
			GetMeTextBox("OngoingWnd.OngoingDesc02_txt").SetText(GetSystemString(14522));
		}
		else
		{
			GetMeTextBox("OngoingWnd.OngoingDesc01_txt").SetText(GetSystemString(14577));
			GetMeTextBox("OngoingWnd.OngoingDesc02_txt").SetText(GetSystemString(14579));
		}
		RefreshReward_Ongoing();
		SelectRewardItem(nRewardClassID, nRewardItemAmount, nRewardEnchanted);
		GetMeButton("Teleport_btn").ShowWindow();
		GetMeButton("Reward_btn").HideWindow();
		if(((nSelectLeaderWorldID > 0) && (nSelectLeaderDBID > 0)))
		{
			GetMeButton("Teleport_btn").ClearTooltip();
			GetMeButton("Teleport_btn").EnableWindow();
		}
		else
		{
			GetMeButton("Teleport_btn").DisableWindow();
			GetMeButton("Teleport_btn").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14593)));
		}
		refreshList_Ongoing();
		waitingRemainTimeSec = Class'Interface.NoticeHUD'.static.Inst().SkyTowerRemainTime;
		Me.KillTimer(123445);
		Me.SetTimer(123445, 1000);
		return;
	}
}

state cWaiting
{
	function BeginState()
	{
		Debug("Waiting State");
		GetMeWindow("disable_tex").HideWindow();
		PercentageWnd.HideWindow();
		RewardWnd.HideWindow();
		OngoingWnd.HideWindow();
		WaitingWnd.ShowWindow();
		RefreshReward_Waiting();
		refreshList_waiting();
		GetMeButton("Teleport_btn").ShowWindow();
		GetMeButton("Reward_btn").HideWindow();
		waitingRemainTimeSec = Class'Interface.NoticeHUD'.static.Inst().SkyTowerRemainTime;
		Me.KillTimer(123445);
		Me.SetTimer(123445, 1000);
		if((Class'Interface.NoticeHUD'.static.Inst().skyTowerCurrentState == 3))
		{
			GetMeTextBox("WaitingWnd.WaitingDesc01_txt").SetText(GetSystemString(14600));
			GetMeTextBox("WaitingWnd.WaitingDesc02_txt").SetText(GetSystemString(14601));
			if(((nSelectLeaderWorldID > 0) && (nSelectLeaderDBID > 0)))
			{
				GetMeButton("Teleport_btn").EnableWindow();
				GetMeButton("Teleport_btn").ClearTooltip();
			}
			else
			{
				GetMeButton("Teleport_btn").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14593)));
				GetMeButton("Teleport_btn").DisableWindow();
			}
			if((amIFollowerOfLeader() || amILeaderOfSkytower()))
			{
				GetMeTexture("disableRichList_tex").HideWindow();
			}
			else
			{
				GetMeTexture("disableRichList_tex").ShowWindow();
			}
		}
		else
		{
			GetMeTexture("disableRichList_tex").HideWindow();
			GetMeTextBox("WaitingWnd.WaitingDesc01_txt").SetText(GetSystemString(14519));
			GetMeTextBox("WaitingWnd.WaitingDesc02_txt").SetText(GetSystemString(14520));
			GetMeButton("Teleport_btn").DisableWindow();
			GetMeButton("Teleport_btn").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14571)));
		}
		return;
	}
}
