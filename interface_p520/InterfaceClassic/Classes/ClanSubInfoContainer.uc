class ClanSubInfoContainer extends UICommonAPI
	dependson(UIPacket);

const DIALOG_AskClanEnemyCancel = 487;

enum CONTEXT_MENU_INDEX
{
	ClanMemInfoBtn,                 // 0
	AddParty,                       // 1
	AddFriend,                      // 2
	whisperToUser,                  // 3
	Clan1_ChangeMemberNameBtn,      // 4
	Clan1_ChangeMemberGradeBtn      // 5
};

enum TAB_TYPE
{
	CLANMEMBER,                     // 0
	ENEMYINFOS,                     // 1
	CLANSKILLS                      // 2
};

var string m_Windowname;
var WindowHandle Me;
var RichListCtrlHandle ClanMemberList_ListCtrl;
var ListCtrlHandle Clan8_DeclaredListCtrl;
var RichListCtrlHandle ClanSkillList_ListCtrl;
var TextBoxHandle noSkillText;
var TabHandle tab;
var int m_currentShowIndex;
var ClanWndClassicNew clanWndClassicScr;
var ClanSubMenuManageContainer clanSubMenuManageContainerScr;
var string withEnemyPledgeNameStr;
var array<UIPacket._L2PledgeEnemyInfo> L2PledgeEnemyInfoList;
var array<UIPacket._PkPledgeContribution> contributionList;
var L2UITimerObject _timerRefresh;

function InitDefaultSetting()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	clanWndClassicScr = ClanWndClassicNew(GetScript("ClanWndClassicNew"));
	clanWndClassicScr.clanSubInfoContainerScr = self;
	tab = TabHandle(Me.GetChildWindow("ClanReward_TabCtrl"));
	tab.InitTabCtrl();
	Me.SetFocus();
	return;
}

function InitHandleCOD()
{
	ClanMemberList_ListCtrl = GetRichListCtrlHandle((m_Windowname $ ".ClanMemberList_Wnd.ClanMemberList_ListCtrl"));
	Clan8_DeclaredListCtrl = GetListCtrlHandle((m_Windowname $ ".ClanWarList_Wnd.Clan8_DeclaredListCtrl"));
	ClanSkillList_ListCtrl = GetRichListCtrlHandle((m_Windowname $ ".ClanSkillList_Wnd.ClanSkillList_ListCtrl"));
	clanSubMenuManageContainerScr = ClanSubMenuManageContainer(GetScript("ClanWndClassicNew.ClanSubMenuManageContainer"));
	noSkillText = GetTextBoxHandle((m_Windowname $ ".ClanSkillList_Wnd.noSkillText"));
	ClanMemberList_ListCtrl.SetAppearTooltipAtMouseX(true);
	ClanMemberList_ListCtrl.SetSelectedSelTooltip(false);
	ClanSkillList_ListCtrl.SetAppearTooltipAtMouseX(true);
	ClanSkillList_ListCtrl.SetSelectedSelTooltip(false);
	ClanSkillList_ListCtrl.SetSelectable(false);
	Clan8_DeclaredListCtrl.SetSelectedSelTooltip(false);
	Clan8_DeclaredListCtrl.SetAppearTooltipAtMouseX(true);
	return;
}

event OnLoad()
{
	InitDefaultSetting();
	InitHandleCOD();
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(490);
	RegisterEvent(500);
	RegisterEvent((100000 + 889));
	RegisterEvent((100000 + 944));
	RegisterEvent(11490);
	return;
}

function HandleOnShow()
{
	Me.SetFocus();
	HideCancelPopup();
	switch(GetTopIndex())
	{
		case 0:
			break;
		case 1:
			API_C_EX_PLEDGE_ENEMY_INFO_LIST();
			break;
		case 2:
			API_RequestClanSkillList();
			break;
		default:
			break;
	}
	return;
}

event OnEvent(int a_EventID, string a_Param)
{
	if(getInstanceL2Util().isClanV2())
	{
		return;
	}
	switch(a_EventID)
	{
		case 490:
			HandleSkillList(a_Param);
			break;
		case 500:
			HandleSkillRenew(a_Param);
			break;
		case (100000 + 889):
			Handle_S_EX_PLEDGE_ENEMY_INFO_LIST();
			break;
		case 11490:
			HandleEV_RequestEnemyPledgeRegister(a_Param);
			break;
		case (100000 + 944):
			Handle_S_EX_PLEDGE_CONTRIBUTION_LIST();
			break;
		default:
			break;
	}
	return;
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	switch(a_WindowHandle)
	{
		case Clan8_DeclaredListCtrl:
			SwitchingEnemyCancelButton();
			break;
		default:
			break;
	}
	return;
}

event OnClickRichListButton(WindowHandle a_WindowHandle, int X, int Y)
{
	switch(a_WindowHandle)
	{
		case ClanMemberList_ListCtrl:
			if((ClanMemberList_ListCtrl.GetSelectedIndex() < 0))
			{
				return;
			}
			ShowContextMenu(X, Y);
			break;
		default:
			break;
	}
	return;
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	local RichListCtrlRowData Record;

	Record.cellDataList.Length = 10;
	switch(ListCtrlID)
	{
		case "Clan8_DeclaredListCtrl":
			HandleClickCancelEnemy();
			break;
		case "ClanMemberList_ListCtrl":
			clanSubMenuManageContainerScr.SetState(ClanMemberInfoState);
			break;
		default:
			break;
	}
	return;
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	local RichListCtrlRowData Record;

	Record.cellDataList.Length = 10;
	switch(ListCtrlID)
	{
		case "Clan8_DeclaredListCtrl":
			SwitchingEnemyCancelButton();
			break;
		case "ClanMemberList_ListCtrl":
			switch(clanSubMenuManageContainerScr.CurrentState)
			{
				case ClanMemberInfoState:
					RequestCurrentSelectedClanMemberInfo();
					break;
				case ClanMemberAuthState:
					RequestCurrentSelectedClanMemberAuth();
					break;
				default:
					break;
			}
			break;
		default:
			break;
	}
	return;
}

event OnRButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	switch(a_WindowHandle.GetWindowName())
	{
		case "ClanMemberList_ListCtrl":
			if((ClanMemberList_ListCtrl.GetSelectedIndex() < 0))
			{
				return;
			}
			ShowContextMenu(X, Y);
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string btnName)
{
	switch(btnName)
	{
		case "ClanReward_TabCtrl0":
			GetWindowHandle((m_Windowname $ ".OnOffBtns")).ShowWindow();
			API_C_EX_PLEDGE_CONTRIBUTION_LIST();
			HideCancelPopup();
			break;
		case "ClanReward_TabCtrl1":
			if((clanWndClassicScr.m_clanID > 0))
			{
				GetButtonHandle((m_Windowname $ ".ClanWarList_Wnd.ClanWar_OKBtn")).EnableWindow();
			}
			else
			{
				GetButtonHandle((m_Windowname $ ".ClanWarList_Wnd.ClanWar_OKBtn")).DisableWindow();
			}
			GetWindowHandle((m_Windowname $ ".OnOffBtns")).HideWindow();
			API_C_EX_PLEDGE_ENEMY_INFO_LIST();
			HideCancelPopup();
			break;
		case "ClanReward_TabCtrl2":
			GetWindowHandle((m_Windowname $ ".OnOffBtns")).HideWindow();
			API_RequestClanSkillList();
			HideCancelPopup();
			break;
		case "ClanWar_OKBtn":
			HideCancelPopup();
			HandleClickClanWar_OKBtn();
			break;
		case "Clan8_CancelWar1Btn":
			HideCancelPopup();
			HandleClickCancelEnemy();
			break;
		case "Clan8_RefreshWar1Btn":
			HideCancelPopup();
			HandleClickRefreshWarBtn();
			break;
		case "PledgePCOnline_Btn":
		case "PledgePCOffline_Btn":
			TogglePledgePCOnOffLine_Btn();
			break;
		default:
			break;
	}
	return;
}

function _Hide()
{
	Me.HideWindow();
	HideCancelPopup();
	return;
}

function bool RequestCurrentSelectedClanMemberAuth()
{
	local RichListCtrlRowData Record;

	if(!GetSelectedListCtrlItem(Record))
	{
		return false;
	}
	API_RequestClanMemberAuth(int(Record.nReserved1), Record.cellDataList[0].szData);
	return true;
}

function API_RequestClanMemberAuth(int clanType, string memberName)
{
	RequestClanMemberAuth(clanType, memberName);
	return;
}

function bool RequestCurrentSelectedClanMemberInfo()
{
	local RichListCtrlRowData Record;

	if(!GetSelectedListCtrlItem(Record))
	{
		return false;
	}
	API_RequestClanMemberInfo(int(Record.nReserved1), Record.cellDataList[0].szData);
	return true;
}

function API_RequestClanMemberInfo(int clanType, string memberName)
{
	RequestClanMemberInfo(clanType, memberName);
	return;
}

function API_C_EX_PLEDGE_CONTRIBUTION_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_PLEDGE_CONTRIBUTION_LIST packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_PLEDGE_CONTRIBUTION_LIST(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(710, stream);
	return;
}

function string API_ConvertWorldStrToID(string PledgeName)
{
	return ConvertWorldStrToID(PledgeName);
}

function API_C_EX_PLEDGE_ENEMY_INFO_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_PLEDGE_ENEMY_INFO_LIST packet;

	packet.nPledgeSId = clanWndClassicScr.m_clanID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_PLEDGE_ENEMY_INFO_LIST(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(666, stream);
	return;
}

function API_C_EX_PLEDGE_ENEMY_DELETE(int EnemyPledgeSID)
{
	local array<byte> stream;
	local UIPacket._C_EX_PLEDGE_ENEMY_DELETE packet;

	packet.nEnemyPledgeSID = EnemyPledgeSID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_PLEDGE_ENEMY_DELETE(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(668, stream);
	return;
}

function API_RequestClanSkillList()
{
	Class'NWindow.UIDATA_CLAN'.static.RequestClanSkillList();
	return;
}

function Handle_S_EX_PLEDGE_CONTRIBUTION_LIST()
{
	local UIPacket._S_EX_PLEDGE_CONTRIBUTION_LIST packet;
	local int i;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_PLEDGE_CONTRIBUTION_LIST(packet))
	{
		return;
	}
	contributionList = packet.contributionList;
	i = 0;
	while((i < contributionList.Length))
	{
		ModiFyRecordByPkPledgeContribution(contributionList[i]);
		i++;
	}
	return;
}

function API_RequestEnemyPledgeRegister()
{
	RequestEnemyPledgeRegister();
	return;
}

function API_C_EX_PLEDGE_ENEMY_REGISTER()
{
	local array<byte> stream;
	local UIPacket._C_EX_PLEDGE_ENEMY_REGISTER packet;

	if((withEnemyPledgeNameStr != ""))
	{
		packet.sEnemyPledgeName = API_ConvertWorldStrToID(withEnemyPledgeNameStr);
		if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_PLEDGE_ENEMY_REGISTER(stream, packet))
		{
			return;
		}
		Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(667, stream);
	}
	withEnemyPledgeNameStr = "";
	return;
}

function Handle_S_EX_PLEDGE_ENEMY_INFO_LIST()
{
	local UIPacket._S_EX_PLEDGE_ENEMY_INFO_LIST packet;
	local int i;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_PLEDGE_ENEMY_INFO_LIST(packet))
	{
		return;
	}
	L2PledgeEnemyInfoList = packet.L2PledgeEnemyInfoList;
	Clan8_DeclaredListCtrl.DeleteAllItem();
	i = 0;
	while((i < L2PledgeEnemyInfoList.Length))
	{
		HandleClanEnelyList(L2PledgeEnemyInfoList[i]);
		i++;
	}
	SwitchingEnemyCancelButton();
	return;
}

function HideCancelPopup()
{
	clanWndClassicScr.GetPopupScript().Hide();
	if(DialogIsMine())
	{
		Class'InterfaceClassic.DialogBox'.static.Inst().HideDialog();
	}
	return;
}

function ClearList()
{
	local UIControlContextMenu ContextMenu;

	ContextMenu = Class'InterfaceClassic.UIControlContextMenu'.static.GetInstance();
	if(ContextMenu.IsMine(string(self)))
	{
		ContextMenu.Hide();
	}
	ClanMemberList_ListCtrl.DeleteAllItem();
	return;
}

function ClearSkills()
{
	ClanSkillList_ListCtrl.DeleteAllItem();
	return;
}

function HandleEV_RequestEnemyPledgeRegister(string param)
{
	ParseString(param, "PledgeName", withEnemyPledgeNameStr);
	API_C_EX_PLEDGE_ENEMY_REGISTER();
	return;
}

function SwitchingEnemyCancelButton()
{
	local int SelectedIndex;

	SelectedIndex = Clan8_DeclaredListCtrl.GetSelectedIndex();
	if(((SelectedIndex >= 0) && (clanWndClassicScr.m_clanID > 0)))
	{
		Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanWarList_Wnd.Clan8_CancelWar1Btn"));
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanWarList_Wnd.Clan8_CancelWar1Btn"));
	}
	HideCancelPopup();
	return;
}

function HandleCancelEnemy()
{
	local LVDataRecord Record;
	local int Index;

	Index = Clan8_DeclaredListCtrl.GetSelectedIndex();
	if((Index >= 0))
	{
		Clan8_DeclaredListCtrl.GetRec(Index, Record);
		API_C_EX_PLEDGE_ENEMY_DELETE(int(Record.nReserved1));
	}
	return;
}

function HandleClickRefreshWarBtn()
{
	DisableRefreshWar();
	API_C_EX_PLEDGE_ENEMY_INFO_LIST();
	Class'InterfaceClassic.L2UITimer'.static.Inst()._AddTimerOnce(5000)._DelegateOnEnd = EnableRefreshWar;
	return;
}

function DisableRefreshWar()
{
	Class'NWindow.UIAPI_WINDOW'.static.DisableWindow((m_Windowname $ ".ClanWarList_Wnd.Clan8_RefreshWar1Btn"));
	return;
}

function EnableRefreshWar()
{
	Class'NWindow.UIAPI_WINDOW'.static.EnableWindow((m_Windowname $ ".ClanWarList_Wnd.Clan8_RefreshWar1Btn"));
	return;
}

function HandleClickCancelEnemy()
{
	local PledgeEnemyDeletePenaltyUIData uData;
	local LVDataRecord Record;
	local L2UITime UITimeStruct;
	local int Index;
	local UIControlDialogAssets uicontrolDialogAssetScr;
	local string htmlStr;

	Index = Clan8_DeclaredListCtrl.GetSelectedIndex();
	if((Index < 0))
	{
		return;
	}
	uData = API_GetPledgeEnemyDeletePenaltyData();
	Clan8_DeclaredListCtrl.GetRec(Index, Record);
	htmlStr = (htmlAddText(Record.LVDataList[0].szData, "", Class'InterfaceClassic.L2UIColor'.static.Inst()._RGB2ZeroX(255, 204, 0)) @ GetSystemString(14454));
	if(((Record.nReserved2 > INT64(Class'InterfaceClassic.UIData'.static.Inst().GetCurrentRealLocalTimeSec())) && (uData.CostLCoin > 0)))
	{
		uicontrolDialogAssetScr = clanWndClassicScr.GetPopupScript();
		uicontrolDialogAssetScr.DelegateOnClickBuy = HandleDialogOK;
		uicontrolDialogAssetScr.DelegateOnCancel = HandleDialogCancel;
		uicontrolDialogAssetScr.SetUseBuyItem(false);
		uicontrolDialogAssetScr.SetUseNeedItem(true);
		uicontrolDialogAssetScr.SetUseNumberInput(false);
		uicontrolDialogAssetScr.StartNeedItemList(1);
		GetTimeStruct(int(Record.nReserved2), UITimeStruct);
		htmlStr = (((htmlStr $ "<br>") $ htmlAddText(Class'InterfaceClassic.UIData'.static.Inst().getMakeTimeString(UITimeStruct), "", Class'InterfaceClassic.L2UIColor'.static.Inst()._RGB2ZeroX(255, 204, 0))) @ htmlAddText(GetSystemString(14455), "", Class'InterfaceClassic.L2UIColor'.static.Inst()._RGB2ZeroX(170, 153, 119)));
		uicontrolDialogAssetScr.SetDialogDescHtml(htmlStr);
		uicontrolDialogAssetScr.AddNeedItemClassID(91663, INT64(uData.CostLCoin));
		uicontrolDialogAssetScr.SetItemNum(1);
		uicontrolDialogAssetScr.Show();
	}
	else
	{
		Class'InterfaceClassic.UICommonAPI'.static.DialogSetID(487);
		Class'InterfaceClassic.UICommonAPI'.static.DialogSetDefaultCancle();
		DialogShowHtml(DialogModalType_Modalless, DialogType_OKCancel, htmlStr);
		Class'InterfaceClassic.DialogBox'.static.Inst().AnchorToOwner(0, 200);
		Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
		Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnCancel = HandleDialogCancel;
	}
	return;
}

function HandleClickClanWar_OKBtn()
{
	local string dayStr, costStr, remainTimeString, costString;
	local PledgeEnemyDeletePenaltyUIData uData;

	uData = API_GetPledgeEnemyDeletePenaltyData();
	if(((uData.MinimumRegisterTime == 0) || (uData.CostLCoin == 0)))
	{
		API_RequestEnemyPledgeRegister();
		return;
	}
	remainTimeString = GetStringDayAndTime(uData.MinimumRegisterTime);
	Debug(("HandleClickClanWar_OKBtn" @ string(uData.MinimumRegisterTime)));
	dayStr = htmlAddText(remainTimeString, "", Class'InterfaceClassic.L2UIColor'.static.Inst()._RGB2ZeroX(255, 204, 0));
	costString = MakeCostString(string(uData.CostLCoin));
	costStr = htmlAddText(costString, "", Class'InterfaceClassic.L2UIColor'.static.Inst()._RGB2ZeroX(255, 204, 0));
	DialogShowHtml(DialogModalType_Modalless, DialogType_OK, MakeFullSystemMsg(GetSystemMessage(13868), dayStr, costStr));
	Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnOK = API_RequestEnemyPledgeRegister;
	Class'InterfaceClassic.DialogBox'.static.Inst().m_hOwnerWnd.SetFocus();
	return;
}

function HandleClanEnelyList(UIPacket._L2PledgeEnemyInfo pledgeEnemyInfo)
{
	local LVDataRecord Record;
	local PledgeEnemyDeletePenaltyUIData uData;

	uData = API_GetPledgeEnemyDeletePenaltyData();
	Record.LVDataList.Length = 2;
	Record.nReserved1 = INT64(pledgeEnemyInfo.nEnemyPledgeSID);
	if((pledgeEnemyInfo.nRegisterTime < 1))
	{
		Record.nReserved2 = INT64(Class'InterfaceClassic.UIData'.static.Inst().GetCurrentRealLocalTimeSec());
	}
	else
	{
		Record.nReserved2 = INT64((pledgeEnemyInfo.nRegisterTime + uData.MinimumRegisterTime));
	}
	if((uData.CostLCoin > 0))
	{
		if((int(Record.nReserved2) > Class'InterfaceClassic.UIData'.static.Inst().GetCurrentRealLocalTimeSec()))
		{
			Record.LVDataList[0].arrTexture.Length = 1;
			Record.LVDataList[0].arrTexture[0].objTex = GetTexture("L2UI_CT1.SkillWnd.SkillWnd_DF_ListIcon_Use");
			Record.LVDataList[0].arrTexture[0].X = 4;
			Record.LVDataList[0].arrTexture[0].Y = 0;
			Record.LVDataList[0].arrTexture[0].Width = 18;
			Record.LVDataList[0].arrTexture[0].Height = 14;
		}
	}
	Record.LVDataList[0].szData = ConvertWorldIDToStr(pledgeEnemyInfo.sEnemyPledgeName);
	Record.LVDataList[1].szData = pledgeEnemyInfo.sEnemyPledgeMasterName;
	Clan8_DeclaredListCtrl.InsertRecord(Record);
	return;
}

function HandleDialogOK()
{
	HandleCancelEnemy();
	clanWndClassicScr.GetPopupScript().Hide();
	return;
}

function HandleDialogCancel()
{
	clanWndClassicScr.GetPopupScript().Hide();
	return;
}

function PledgeEnemyDeletePenaltyUIData API_GetPledgeEnemyDeletePenaltyData()
{
	return GetPledgeEnemyDeletePenaltyData();
}

function AddToList(int idx)
{
	local RichListCtrlRowData Record;
	local int i, MyIndex, OnLineNum;

	OnLineNum = 0;
	i = 0;
	while((i < clanWndClassicScr.m_memberList[idx].m_array.Length))
	{
		if((clanWndClassicScr.m_memberList[idx].m_array[i].Id > 0))
		{
			OnLineNum++;
		}
		else if(IsOnlyOnline())
		{
			continue;
		}
		Record = makeRecord(clanWndClassicScr.m_memberList[idx].m_array[i]);
		if((Record.cellDataList[0].szData == clanWndClassicScr.m_myName))
		{
			MyIndex = i;
		}
		ClanMemberList_ListCtrl.InsertRecord(Record);
		++i;
	}
	ClanMemberList_ListCtrl.SetSelectedIndex(MyIndex, true);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".OnOffBtns.ClanCurrentNum"), (((("(" $ string(OnLineNum)) $ "/") $ string(clanWndClassicScr.m_memberList[0].m_array.Length)) $ ")"));
	return;
}

function ClearCurrentNum()
{
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".OnOffBtns.ClanCurrentNum"), "0/0");
	return;
}

function HandleSkillRenew(string a_Param)
{
	if((clanWndClassicScr.Me.IsShowWindow() && (GetTopIndex() == 2)))
	{
		API_RequestClanSkillList();
	}
	return;
}

function HandleSkillList(string a_Param)
{
	local int Count, i, Level;
	local ItemID cID;

	ClearSkills();
	ParseInt(a_Param, "Count", Count);
	i = 0;
	while((i < Count))
	{
		ParseItemIDWithIndex(a_Param, cID, i);
		ParseInt(a_Param, ("SkillLevel_" $ string(i)), Level);
		ClanSkillList_ListCtrl.InsertRecord(MakeRecordSkill(cID, Level));
		++i;
	}
	if((Count > 0))
	{
		noSkillText.HideWindow();
	}
	else
	{
		noSkillText.ShowWindow();
	}
	return;
}

function RichListCtrlRowData MakeRecordSkill(ItemID cID, int SkillLevel)
{
	local RichListCtrlRowData Record;
	local ItemInfo iInfo;
	local SkillInfo sInfo;
	local string Desc;
	local int wMax;

	Record.cellDataList.Length = 2;
	Record.nReserved1 = INT64(cID.ClassID);
	Record.nReserved2 = INT64(SkillLevel);
	Record.nReserved3 = INT64(0);
	GetSkillInfo(cID.ClassID, SkillLevel, 0, sInfo);
	Class'InterfaceClassic.L2Util'.static.GetSkill2ItemInfo(sInfo, iInfo);
	AddRichListCtrlSkill(Record.cellDataList[0].drawitems, iInfo, 36, 36, 0, -1);
	AddRichListCtrlString(Record.cellDataList[0].drawitems, sInfo.SkillName, getInstanceL2Util().BrightWhite, false, 4, 4);
	AddRichListCtrlString(Record.cellDataList[0].drawitems, (GetSystemString(88) $ string(sInfo.SkillLevel)), getInstanceL2Util().Yellow03, true, 41, 2);
	AddRichListCtrlString(Record.cellDataList[0].drawitems, getSkillTypeString(sInfo.IconType), GetColor(176, 155, 121, 255), false, 4);
	Desc = Substitute(sInfo.SkillDesc, "\\n", ", ", false);
	Desc = Substitute(Desc, ", , ", ", ", false);
	wMax = 267;
	Class'InterfaceClassic.L2Util'.static.GetEllipsisString(Desc, wMax);
	AddRichListCtrlString(Record.cellDataList[1].drawitems, Desc, GetColor(178, 190, 207, 255));
	return Record;
}

function ShowContextMenu(int X, int Y)
{
	local UIControlContextMenu ContextMenu;

	ContextMenu = Class'InterfaceClassic.UIControlContextMenu'.static.GetInstance();
	ContextMenu.Clear();
	ContextMenu.DelegateOnClickContextMenu = HandleOnClickContextMenu;
	ContextMenu.MenuNew(GetSystemString(1322), 0);
	if(((GetCurrentSelectedName() != clanWndClassicScr.m_myName) && IsSelectedLogin()))
	{
		ContextMenu.MenuLineAdd();
		ContextMenu.MenuNew(GetSystemString(396), 1);
		ContextMenu.MenuNew(GetSystemString(3227), 2);
		ContextMenu.MenuNew(GetSystemString(398), 3);
	}
	ContextMenu.Show(X, Y, string(self));
	return;
}

function HandleOnClickContextMenu(int Index)
{
	switch(Index)
	{
		case 0:
			HandleClickContextClanInfo(Index);
			break;
		case 1:
			HandlePartyAskJoin(Index);
			break;
		case 2:
			HandleAddFriend(Index);
			break;
		case 3:
			HandleWhisper(Index);
			break;
		case 4:
			ChangeNickname(Index);
			break;
		case 5:
			ChangeChangeGrade(Index);
			break;
		default:
			break;
	}
	return;
}

function HandleClickContextClanInfo(int Index)
{
	clanSubMenuManageContainerScr.SetState(ClanMemberInfoState);
	return;
}

function HandlePartyAskJoin(int Index)
{
	local string selectedName;

	selectedName = GetCurrentSelectedName();
	if((selectedName == ""))
	{
		return;
	}
	RequestInviteParty(selectedName);
	return;
}

function HandleAddFriend(int Index)
{
	local string selectedName;

	selectedName = GetCurrentSelectedName();
	if((selectedName == ""))
	{
		return;
	}
	Class'NWindow.PersonalConnectionAPI'.static.RequestAddFriend(selectedName);
	return;
}

function HandleWhisper(int Index)
{
	local string selectedName;

	selectedName = GetCurrentSelectedName();
	if((selectedName == ""))
	{
		return;
	}
	SetChatMessage((("\"" $ selectedName) $ " "));
	return;
}

function ChangeNickname(int Index)
{
	Debug("호칭 변경");  // EN?: Change title
	clanSubMenuManageContainerScr.SetState(ClanMemberInfoState);
	clanSubMenuManageContainerScr.OnClickButton("Clan1_ChangeMemberNameBtn");
	return;
}

function ChangeChangeGrade(int Index)
{
	Debug("등급 변경");  // EN?: Change tier
	clanSubMenuManageContainerScr.SetState(ClanMemberInfoState);
	clanSubMenuManageContainerScr.OnClickButton("Clan1_ChangeMemberGradeBtn");
	return;
}

function bool IsOnlyOnline()
{
	return GetButtonHandle((m_Windowname $ ".OnOffBtns.PledgePCOnline_Btn")).IsShowWindow();
}

function TogglePledgePCOnOffLine_Btn()
{
	if(IsOnlyOnline())
	{
		GetButtonHandle((m_Windowname $ ".OnOffBtns.PledgePCOnline_Btn")).HideWindow();
		GetButtonHandle((m_Windowname $ ".OnOffBtns.PledgePCOffline_Btn")).ShowWindow();
	}
	else
	{
		GetButtonHandle((m_Windowname $ ".OnOffBtns.PledgePCOnline_Btn")).ShowWindow();
		GetButtonHandle((m_Windowname $ ".OnOffBtns.PledgePCOffline_Btn")).HideWindow();
	}
	ShowList(0);
	return;
}

function ShowList(int clanType)
{
	ClearList();
	AddToList(0);
	API_C_EX_PLEDGE_CONTRIBUTION_LIST();
	return;
}

function ModiFyRecordByPkPledgeContribution(UIPacket._PkPledgeContribution contribution)
{
	local int Index;

	Index = GetListIndexBycontribution(contribution);
	if((Index > -1))
	{
		InputContributionToRecord(Index, contribution);
	}
	return;
}

function bool GetContributionByName(string sName, out UIPacket._PkPledgeContribution contribution)
{
	local int i;

	i = 0;
	while((i < contributionList.Length))
	{
		if((sName == contributionList[i].sUserName))
		{
			contribution = contributionList[i];
			return true;
		}
		i++;
	}
	return false;
}

function int GetListIndexBycontribution(UIPacket._PkPledgeContribution contribution)
{
	local int i;
	local RichListCtrlRowData Record;

	i = 0;
	while((i < ClanMemberList_ListCtrl.GetRecordCount()))
	{
		ClanMemberList_ListCtrl.GetRec(i, Record);
		if((Record.cellDataList[0].szData == contribution.sUserName))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function InputContributionToRecord(int Index, UIPacket._PkPledgeContribution contribution)
{
	local RichListCtrlRowData Record;
	local string sCurrentContribution, sTotalContribution;

	sCurrentContribution = string(contribution.nCurrentContribution);
	sTotalContribution = string(contribution.nTotalContribution);
	ClanMemberList_ListCtrl.GetRec(Index, Record);
	Record.cellDataList[3].szData = sCurrentContribution;
	Record.cellDataList[3].HiddenStringForSorting = getInstanceL2Util().makeZeroString(20, INT64(contribution.nCurrentContribution));
	Record.cellDataList[3].drawitems[0].strInfo.strData = MakeCostString(sCurrentContribution);
	Record.cellDataList[4].szData = sTotalContribution;
	Record.cellDataList[4].HiddenStringForSorting = getInstanceL2Util().makeZeroString(20, INT64(contribution.nTotalContribution));
	Record.cellDataList[4].drawitems[0].strInfo.strData = MakeCostString(sTotalContribution);
	ClanMemberList_ListCtrl.ModifyRecord(Index, Record);
	return;
}

function RichListCtrlRowData makeRecord(ClanMemberInfo _clanMemberInfo)
{
	local Color color_txt;
	local int i;
	local RichListCtrlRowData Record;
	local UIPacket._PkPledgeContribution contribution;

	Record.cellDataList.Length = 6;
	Record.nReserved1 = INT64(_clanMemberInfo.clanType);
	if((_clanMemberInfo.sName == clanWndClassicScr.m_myName))
	{
		clanWndClassicScr.m_indexNum = i;
	}
	if((_clanMemberInfo.sName == clanWndClassicScr.m_myName))
	{
		color_txt = getInstanceL2Util().Yellow;
	}
	else if((_clanMemberInfo.Id > 0))
	{
		color_txt = getInstanceL2Util().BrightWhite;
	}
	else
	{
		color_txt = getInstanceL2Util().Gray;
	}
	Record.cellDataList[0].szData = _clanMemberInfo.sName;
	Record.cellDataList[1].szData = string(_clanMemberInfo.Level);
	Record.cellDataList[2].szData = string(_clanMemberInfo.ClassID);
	if(GetContributionByName(_clanMemberInfo.sName, contribution))
	{
		Record.cellDataList[3].szData = string(contribution.nCurrentContribution);
		Record.cellDataList[4].szData = string(contribution.nTotalContribution);
	}
	else
	{
		Record.cellDataList[3].szData = string(0);
		Record.cellDataList[4].szData = string(0);
	}
	Record.cellDataList[5].szData = string(_clanMemberInfo.Id);
	AddRichListCtrlString(Record.cellDataList[0].drawitems, Record.cellDataList[0].szData, color_txt, false);
	AddRichListCtrlString(Record.cellDataList[1].drawitems, Record.cellDataList[1].szData, color_txt, false);
	addRichListCtrlTexture(Record.cellDataList[2].drawitems, GetClassRoleIconName(_clanMemberInfo.ClassID), 11, 11);
	AddRichListCtrlString(Record.cellDataList[3].drawitems, MakeCostString(Record.cellDataList[3].szData), color_txt, false);
	AddRichListCtrlString(Record.cellDataList[4].drawitems, MakeCostString(Record.cellDataList[4].szData), color_txt, false);
	AddRichListCtrlButton(Record.cellDataList[5].drawitems, "btnInfo", 20, 0, "L2UI_EPIC.ClanWnd.ClanWnd_ListSetting", "L2UI_EPIC.ClanWnd.ClanWnd_ListSetting_Over", "L2UI_EPIC.ClanWnd.ClanWnd_ListSetting_Down", 16, 16, 16, 16);
	Record.cellDataList[0].HiddenStringForSorting = _clanMemberInfo.sName;
	Record.cellDataList[1].HiddenStringForSorting = string(_clanMemberInfo.Level);
	Record.cellDataList[2].HiddenStringForSorting = string(GetClassRoleType(_clanMemberInfo.ClassID));
	Record.cellDataList[3].HiddenStringForSorting = Record.cellDataList[3].szData;
	Record.cellDataList[4].HiddenStringForSorting = Record.cellDataList[4].szData;
	return Record;
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

function bool GetSelectedListCtrlItem(out RichListCtrlRowData Record)
{
	local int Index;

	Index = ClanMemberList_ListCtrl.GetSelectedIndex();
	if((Index >= 0))
	{
		ClanMemberList_ListCtrl.GetRec(Index, Record);
		return true;
	}
	return false;
}

function bool IsSelectedLogin()
{
	local RichListCtrlRowData Record;

	if(!GetSelectedListCtrlItem(Record))
	{
		return false;
	}
	return (int(Record.cellDataList[3].szData) > 0);
}

function string GetCurrentSelectedName()
{
	local RichListCtrlRowData Record;

	if(!GetSelectedListCtrlItem(Record))
	{
		return "";
	}
	return Record.cellDataList[0].szData;
}

function int GetTopIndex()
{
	return tab.GetTopIndex();
}
