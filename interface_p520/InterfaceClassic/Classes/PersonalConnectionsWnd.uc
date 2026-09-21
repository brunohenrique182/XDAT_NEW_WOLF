class PersonalConnectionsWnd extends UICommonAPI
	dependson(UIPacket);

const FRIENDLIST_LIMIT = 128;
const BLOCKLIST_LIMIT = 512;
const WATCHLIST_LIMIT = 20;
const MENTEE_LIST_LIMIT = 3;
const MENTOR_LIST_LIMIT = 1;
const DIALOG_PersonalConnectionFriendListRemove = 90007;
const DIALOG_PersonalConnectionBlockListRemove = 90008;
const DIALOG_PersonalConnectionMenteeListRemove = 90020;
const DIALOG_PersonalConnectionWatchListRemove = 90030;
const DIALOG_PersonalConnectionConfirmMentee = 90021;

struct relationMemberInfo
{
	var string Name;
	var int UserID;
	var int ClassID;
	var int Level;
	var bool bOnline;
};

struct _pkUserWatcherTarget
{
	var string sName;
	var int nWorldID;
	var int nLevel;
	var int nClass;
	var byte bLoggedin;
};

var WindowHandle Me;
var PersonalConnectionsDrawerWnd m_PersonalConnectionsDrawerWnd;
var TabHandle ConnectionsListSelectTab;
var TextureHandle ConnectionsListSelectTabBgLine;
var TextureHandle TexTabBg;
var TextBoxHandle ListTitle;
var TextBoxHandle ListCount;
var ButtonHandle ListPlusBtn;
var ButtonHandle ListMinusBtn;
var ButtonHandle ListBlockBtn;
var TextureHandle ListDeco;
var ListCtrlHandle FriendList;
var ListCtrlHandle BlockList;
var ListCtrlHandle MentoringList;
var ListCtrlHandle WatchList;
var TextureHandle GroupBox1;
var TextureHandle GroupBox2;
var ButtonHandle InvitePartyBtn;
var ButtonHandle SendPostBtn;
var ButtonHandle InviteClanBtn;
var ButtonHandle WhisperBtn;
var ButtonHandle DetailInfoBtn;
var ButtonHandle OneOnOneTalkBtn;
var int selectedFriendListIndex;
var int selectedBlockListIndex;
var int nClanJoin;
var L2Util util;
var int mentorMenTeeRole;
var TextBoxHandle GuideTitle;
var TextBoxHandle Guide;
var TextureHandle GroupBox_MentoringList1;
var TextureHandle GroupBox_MentoringList2;
var TextureHandle GroupBox_FriendBlockList;
var UserInfo myUserInfo;
var TextBoxHandle NameEnterLimit;
var TextBoxHandle NameEnterLimitTime;
var string MentorName;
var array<relationMemberInfo> friendListArray;
var array<relationMemberInfo> clanListArray;
var array<relationMemberInfo> blockListArray;

function OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(340);
	RegisterEvent(5400);
	RegisterEvent(5401);
	RegisterEvent(5402);
	RegisterEvent(5403);
	RegisterEvent(5404);
	RegisterEvent(5390);
	RegisterEvent(5391);
	RegisterEvent(5392);
	RegisterEvent(5393);
	RegisterEvent(5394);
	RegisterEvent(5411);
	RegisterEvent(9220);
	RegisterEvent(5800);
	RegisterEvent(5810);
	RegisterEvent(5820);
	RegisterEvent(1710);
	RegisterEvent(8000);
	RegisterEvent(10140);
	RegisterEvent((100000 + 929));
	RegisterEvent((100000 + 930));
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	util = L2Util(GetScript("L2Util"));
	Initialize();
	Load();
	ConnectionsListSelectTab.SetDisable(2, true);
	selectedFriendListIndex = -1;
	selectedBlockListIndex = -1;
	GetPlayerInfo(myUserInfo);
	return;
}

function OnShow()
{
	if(Class'NWindow.UIDATA_PLAYER'.static.IsInDethrone())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
		Me.HideWindow();
		return;
	}
	MentorName = "";
	Class'NWindow.PersonalConnectionAPI'.static.RequestFriendInfoList();
	Class'NWindow.PersonalConnectionAPI'.static.RequestBlockInfoList();
	if(getInstanceUIData().GetIsClassicServer())
	{
		API_C_EX_USER_WATCHER_TARGET_LIST();
	}
	if(!IsPlayerOnWorldRaidServer())
	{
		if(getInstanceUIData().GetIsLiveServer())
		{
			if(!getInstanceUIData().getIsArenaServer())
			{
				Class'NWindow.PersonalConnectionAPI'.static.RequestMentorList();
				Debug("Api Call RequestMentorList");
			}
		}
	}
	GetPlayerInfo(myUserInfo);
	listTextUpdate();
	checkClanButtonState();
	if(((ConnectionsListSelectTab.GetTopIndex() == 2) && getInstanceUIData().GetIsLiveServer()))
	{
		GuideTitle.ShowWindow();
		Guide.ShowWindow();
	}
	else
	{
		GuideTitle.HideWindow();
		Guide.HideWindow();
	}
	disableButtonRaidSever();
	return;
}

function checkClassicForm()
{
	ConnectionsListSelectTab.InitTabCtrl();
	if(getInstanceUIData().GetIsClassicServer())
	{
		ConnectionsListSelectTab.SetButtonName(2, GetSystemString(13532));
		ConnectionsListSelectTab.SetDisable(2, false);
		ConnectionsListSelectTabBgLine.SetWindowSize(74, 24);
	}
	else
	{
		ConnectionsListSelectTab.RemoveTabControl(3);
		ConnectionsListSelectTab.SetButtonName(2, GetSystemString(2767));
		ConnectionsListSelectTab.SetDisable(2, false);
		ConnectionsListSelectTabBgLine.SetWindowSize(74, 24);
	}
	return;
}

function Initialize()
{
	Me = GetWindowHandle("PersonalConnectionsWnd");
	m_PersonalConnectionsDrawerWnd = PersonalConnectionsDrawerWnd(GetScript("PersonalConnectionsDrawerWnd"));
	ConnectionsListSelectTab = GetTabHandle("PersonalConnectionsWnd.ConnectionsListSelectTab");
	ConnectionsListSelectTabBgLine = GetTextureHandle("PersonalConnectionsWnd.ConnectionsListSelectTabBgLine");
	TexTabBg = GetTextureHandle("PersonalConnectionsWnd.TexTabBg");
	ListDeco = GetTextureHandle("PersonalConnectionsWnd.ListDeco");
	ListTitle = GetTextBoxHandle("PersonalConnectionsWnd.ListTitle");
	ListCount = GetTextBoxHandle("PersonalConnectionsWnd.ListCount");
	ListPlusBtn = GetButtonHandle("PersonalConnectionsWnd.ListPlusBtn");
	ListMinusBtn = GetButtonHandle("PersonalConnectionsWnd.ListMinusBtn");
	ListBlockBtn = GetButtonHandle("PersonalConnectionsWnd.ListBlockBtn");
	FriendList = GetListCtrlHandle("PersonalConnectionsWnd.FriendList");
	BlockList = GetListCtrlHandle("PersonalConnectionsWnd.BlockList");
	MentoringList = GetListCtrlHandle("PersonalConnectionsWnd.MentoringList");
	WatchList = GetListCtrlHandle("PersonalConnectionsWnd.WatchList");
	GroupBox1 = GetTextureHandle("PersonalConnectionsWnd.GroupBox1");
	GroupBox2 = GetTextureHandle("PersonalConnectionsWnd.GroupBox2");
	InvitePartyBtn = GetButtonHandle("PersonalConnectionsWnd.InvitePartyBtn");
	SendPostBtn = GetButtonHandle("PersonalConnectionsWnd.SendPostBtn");
	InviteClanBtn = GetButtonHandle("PersonalConnectionsWnd.InviteClanBtn");
	WhisperBtn = GetButtonHandle("PersonalConnectionsWnd.WhisperBtn");
	DetailInfoBtn = GetButtonHandle("PersonalConnectionsWnd.DetailInfoBtn");
	OneOnOneTalkBtn = GetButtonHandle("PersonalConnectionsWnd.OneOnOneTalkBtn");
	GuideTitle = GetTextBoxHandle("PersonalConnectionsWnd.GuideTitle");
	Guide = GetTextBoxHandle("PersonalConnectionsWnd.Guide");
	NameEnterLimit = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterLimit");
	NameEnterLimitTime = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterLimitTime");
	GroupBox_MentoringList1 = GetTextureHandle("PersonalConnectionsWnd.GroupBox_MentoringList1");
	GroupBox_MentoringList2 = GetTextureHandle("PersonalConnectionsWnd.GroupBox_MentoringList2");
	GroupBox_FriendBlockList = GetTextureHandle("PersonalConnectionsWnd.GroupBox_FriendBlockList");
	GuideTitle.HideWindow();
	Guide.HideWindow();
	WatchList.HideWindow();
	setTextureVisible(0);
	GuideTitle.SetText(GetSystemString(2773));
	Guide.SetText(GetSystemString(2770));
	listTextUpdate();
	return;
}

function Load()
{
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 40:
			restartHandler();
			break;
		case 340:
			HandleClanMyAuth(param);
			break;
		case 5390:
			friendInfoListEmptyHandle();
			break;
		case 5411:
			Me.ShowWindow();
			break;
		case 5391:
			friendAddedHandle(param);
			listTextUpdate();
			break;
		case 5392:
			friendRemovedHandle(param);
			listTextUpdate();
			break;
		case 5393:
			friendInfoUpdateHandle(param);
			listTextUpdate();
			break;
		case 5394:
			userDetailInfoUpdateHandle(param);
			listTextUpdate();
			break;
		case 5400:
			BlockList.DeleteAllItem();
			break;
		case 5401:
			blockAddedHandler(param);
			listTextUpdate();
			break;
		case 5403:
			blockInfoUpdateHandler(param);
			listTextUpdate();
			break;
		case 5404:
			blockDetailInfoUpdateHandler(param);
			listTextUpdate();
			break;
		case 5402:
			blockRemovedHandler(param);
			listTextUpdate();
			break;
		case 9220:
			break;
		case 1710:
			HandleDialogOK();
			break;
		case 5810:
			mentorMenteeListStartHandler(param);
			break;
		case 5820:
			menTorMenTeeAddedHandle(param);
			listTextUpdate();
			break;
		case 5800:
			conFirmMenteeDialogHandler(param);
			break;
		case (100000 + 929):
			Debug("-- S_EX_USER_WATCHER_TARGET_LIST");
			ParsePacket_S_EX_USER_WATCHER_TARGET_LIST();
			listTextUpdate();
			break;
		case (100000 + 930):
			Debug("-- S_EX_USER_WATCHER_TARGET_STATUS");
			ParsePacket_S_EX_USER_WATCHER_TARGET_STATUS();
			break;
		case 8000:
			checkClassicForm();
			break;
		case 10140:
			WatchList.DeleteAllItem();
			BlockList.DeleteAllItem();
			FriendList.DeleteAllItem();
			MentoringList.DeleteAllItem();
			break;
		default:
			break;
	}
	return;
}

function setTextureVisible(int tabindex)
{
	switch(tabindex)
	{
		case 0:
		case 1:
			GroupBox_MentoringList1.DisableWindow();
			GroupBox_MentoringList2.DisableWindow();
			GroupBox_FriendBlockList.ShowWindow();
			NameEnterLimit.HideWindow();
			NameEnterLimitTime.HideWindow();
			break;
		case 2:
			GroupBox_MentoringList1.ShowWindow();
			GroupBox_MentoringList2.ShowWindow();
			GroupBox_FriendBlockList.DisableWindow();
			NameEnterLimit.ShowWindow();
			NameEnterLimitTime.ShowWindow();
			break;
		default:
			break;
	}
	return;
}

function mentorMenteeListStartHandler(string param)
{
	GetPlayerInfo(myUserInfo);
	MentoringList.DeleteAllItem();
	ParseInt(param, "Role", mentorMenTeeRole);
	switch(mentorMenTeeRole)
	{
		case 0:
			if(((myUserInfo.nLevel >= 105) && (GetClassTransferDegree(myUserInfo.nSubClass) > 3)))
			{
				ConnectionsListSelectTab.SetDisable(2, false);
			}
			else
			{
				ConnectionsListSelectTab.SetDisable(2, true);
				ConnectionsListSelectTab.SetTopOrder(0, false);
			}
			break;
		case 1:
			ConnectionsListSelectTab.SetDisable(2, false);
			break;
		case 2:
			ConnectionsListSelectTab.SetDisable(2, false);
			break;
		default:
			Debug(("Error : mentorMenTeeRole :" @ string(mentorMenTeeRole)));
	}
	listTextUpdate();
	return;
}

function menTorMenTeeAddedHandle(string param)
{
	local LVDataRecord Record;

	setListRecord(Record, param);
	MentoringList.InsertRecord(Record);
	return;
}

function conFirmMenteeDialogHandler(string param)
{
	askDialog(90021, param);
	return;
}

function restartHandler()
{
	subWindowClose();
	buttonsEnabled(true);
	ConnectionsListSelectTab.SetTopOrder(0, false);
	WatchList.HideWindow();
	return;
}

function notifyImportedCrestImageHandler(string param)
{
	OnClickListCtrlRecord("FriendList");
	return;
}

function setListRecord(out LVDataRecord Record, string param)
{
	local string Name, memo;
	local int ClassID, Level, Status;
	local Color TextColor;

	Record.LVDataList.Length = 4;
	ParseString(param, "Name", Name);
	ParseString(param, "memo", memo);
	ParseInt(param, "ClassID", ClassID);
	ParseInt(param, "Level", Level);
	ParseInt(param, "Status", Status);
	TextColor = util.White;
	if((Status == 1))
	{
		TextColor = util.BrightWhite;
	}
	else if((Status == 2))
	{
		TextColor = util.PowderPink;
	}
	else if((Status == 3))
	{
		TextColor = util.HotPink;
	}
	Record.LVDataList[0].bUseTextColor = true;
	Record.LVDataList[0].TextColor = TextColor;
	Record.LVDataList[1].bUseTextColor = true;
	Record.LVDataList[1].TextColor = TextColor;
	Record.szReserved = memo;
	Record.LVDataList[0].szData = ConvertWorldIDToStr(Name);
	Record.LVDataList[0].szReserved = Name;
	Record.LVDataList[1].szData = string(Level);
	Record.LVDataList[2].szData = string(ClassID);
	Record.LVDataList[2].szTexture = GetClassRoleIconName(ClassID);
	Record.LVDataList[2].HiddenStringForSorting = string(GetClassRoleType(ClassID));
	Record.LVDataList[2].nTextureWidth = 11;
	Record.LVDataList[2].nTextureHeight = 11;
	Record.LVDataList[3].nTextureWidth = 31;
	Record.LVDataList[3].nTextureHeight = 11;
	Record.nReserved1 = INT64(0);
	if((Status > 0))
	{
		Record.LVDataList[3].szData = "1";
		Record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logon";
	}
	else
	{
		Record.LVDataList[3].szData = "0";
		Record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff";
	}
	return;
}

function friendInfoListEmptyHandle()
{
	FriendList.DeleteAllItem();
	return;
}

function friendAddedHandle(string param)
{
	local LVDataRecord Record;

	setListRecord(Record, param);
	FriendList.InsertRecord(Record);
	return;
}

function friendRemovedHandle(string param)
{
	local string Name;
	local int i;

	ParseString(param, "Name", Name);
	i = util.ctrlListSearchByName(FriendList, ConvertWorldIDToStr(Name));
	if((i != -1))
	{
		FriendList.DeleteRecord(i);
	}
	if((FriendList.GetRecordCount() <= 0))
	{
		subWindowClose();
	}
	else
	{
		if((FriendList.GetSelectedIndex() == FriendList.GetRecordCount()))
		{
			FriendList.SetSelectedIndex((FriendList.GetSelectedIndex() - 1), false);
		}
		OnClickListCtrlRecord("FriendList");
	}
	return;
}

function friendInfoUpdateHandle(string param)
{
	local LVDataRecord Record, tempRecord;
	local string Name;
	local int i;

	FriendList.ClearTooltip();
	ParseString(param, "Name", Name);
	setListRecord(Record, param);
	i = 0;
	while((i < FriendList.GetRecordCount()))
	{
		FriendList.GetRec(i, tempRecord);
		if((tempRecord.LVDataList[0].szData == ConvertWorldIDToStr(Name)))
		{
			FriendList.ModifyRecord(i, Record);
			break;
		}
		i++;
	}
	return;
}

function userDetailInfoUpdateHandle(string param)
{
	local string Name, memo;
	local int ClassID, Level, Status, PledgeID, allianceID, birthMonth, birthDay, logoutDiffSeconds;

	ParseString(param, "Name", Name);
	ParseString(param, "memo", memo);
	ParseInt(param, "ClassID", ClassID);
	ParseInt(param, "Level", Level);
	ParseInt(param, "Status", Status);
	ParseInt(param, "pledgeID", PledgeID);
	ParseInt(param, "allianceID", allianceID);
	ParseInt(param, "birthMonth", birthMonth);
	ParseInt(param, "birthDay", birthDay);
	ParseInt(param, "logoutDiffSeconds", logoutDiffSeconds);
	m_PersonalConnectionsDrawerWnd.setDetailInfo(ConvertWorldIDToStr(Name), Level, ClassID, PledgeID, allianceID, birthMonth, birthDay, logoutDiffSeconds, memo);
	return;
}

function setBlockRecord(out LVDataRecord Record, string param)
{
	local string Name, memo;

	Record.LVDataList.Length = 1;
	ParseString(param, "Name", Name);
	ParseString(param, "memo", memo);
	Record.LVDataList[0].bUseTextColor = true;
	Record.LVDataList[0].szData = ConvertWorldIDToStr(Name);
	Record.LVDataList[0].szReserved = Name;
	Record.LVDataList[0].TextColor = util.Gold;
	Record.nReserved1 = INT64(0);
	return;
}

function blockInfoListEmptyHandler()
{
	BlockList.DeleteAllItem();
	return;
}

function blockAddedHandler(string param)
{
	local LVDataRecord Record;

	setBlockRecord(Record, param);
	BlockList.InsertRecord(Record);
	return;
}

function blockRemovedHandler(string param)
{
	local string Name;
	local int i;

	ParseString(param, "Name", Name);
	i = util.ctrlListSearchByName(BlockList, ConvertWorldIDToStr(Name));
	if((i != -1))
	{
		BlockList.DeleteRecord(i);
	}
	if((BlockList.GetRecordCount() <= 0))
	{
		subWindowClose();
	}
	else
	{
		if((BlockList.GetSelectedIndex() == BlockList.GetRecordCount()))
		{
			BlockList.SetSelectedIndex((BlockList.GetSelectedIndex() - 1), false);
		}
		OnClickListCtrlRecord("BlockList");
	}
	return;
}

function blockInfoUpdateHandler(string param)
{
	local LVDataRecord Record, tempRecord;
	local string Name;
	local int i;

	ParseString(param, "Name", Name);
	setBlockRecord(Record, param);
	i = 0;
	while((i < BlockList.GetRecordCount()))
	{
		BlockList.GetRec(i, tempRecord);
		if((tempRecord.LVDataList[0].szData == ConvertWorldIDToStr(Name)))
		{
			BlockList.ModifyRecord(i, Record);
			break;
		}
		i++;
	}
	return;
}

function blockDetailInfoUpdateHandler(string param)
{
	local string Name, memo;

	ParseString(param, "Name", Name);
	ParseString(param, "memo", memo);
	m_PersonalConnectionsDrawerWnd.setDetailInfo(Name, 0, 0, 0, 0, 0, 0, 0, memo);
	return;
}

function askDialog(int dialogID, optional string mParam)
{
	local int ClassID, Level;
	local LVDataRecord Record;

	if(IsShowWindow("DialogBox"))
	{
		Class'NWindow.PersonalConnectionAPI'.static.ConfirmMenteeAdd(MentorName, 0);
		return;
	}
	DialogSetID(dialogID);
	if((90007 == dialogID))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3307), getUserNameByList()));
	}
	else if((90008 == dialogID))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3708), getUserNameByList()));
	}
	else if((90020 == dialogID))
	{
		MentoringList.GetSelectedRec(Record);
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(3711), getUserNameByList()));
	}
	else if((90021 == dialogID))
	{
		ParseString(mParam, "MentorName", MentorName);
		ParseInt(mParam, "ClassID", ClassID);
		ParseInt(mParam, "Level", Level);
		Class'InterfaceClassic.DialogBox'.static.Inst().setParamInt64(INT64((10 * 1000)));
		Class'InterfaceClassic.DialogBox'.static.Inst().DialogShow(DialogModalType_Modalless, DialogType_Progress, MakeFullSystemMsg(GetSystemMessage(3690), MentorName, GetClassType(ClassID), string(Level)));
		Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnCancel = HandleDialogMenteeCancel;
		Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnOK = HandleDialogMenteeOK;
		Class'InterfaceClassic.DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
	}
	else if((90030 == dialogID))
	{
		WatchList.GetSelectedRec(Record);
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(13362), getUserNameByList()));
	}
	return;
}

function HandleDialogOK()
{
	local int dialogID, mCode, serverNum;
	local string UserName;
	local array<string> arr;

	if(DialogIsMine())
	{
		dialogID = DialogGetID();
		if((90007 == dialogID))
		{
			UserName = ConvertWorldStrToID(getUserNameByList());
			if((UserName != ""))
			{
				Class'NWindow.PersonalConnectionAPI'.static.RequestRemoveFriend(UserName);
			}
		}
		else if((90008 == dialogID))
		{
			UserName = ConvertWorldStrToID(getUserNameByList());
			if((UserName != ""))
			{
				Class'NWindow.PersonalConnectionAPI'.static.RequestRemoveBlock(UserName);
			}
		}
		else if((90030 == dialogID))
		{
			UserName = ConvertWorldStrToID(getUserNameByList());
			Debug(("주시 목록 삭제할 userName: " @ UserName));  // EN?: UserName to delete watchlist from:
			Split(UserName, "_", arr);
			Debug(("arr.length" @ string(arr.Length)));
			Debug(("arr[0]:" @ arr[0]));
			if((arr.Length > 1))
			{
				Debug(("arr[0]:" @ arr[0]));
				Debug(("arr[1]:" @ arr[1]));
				UserName = arr[0];
				serverNum = int(arr[1]);
			}
			if((UserName != ""))
			{
				API_C_EX_USER_WATCHER_DELETE(UserName, serverNum);
			}
		}
		else if((90020 == dialogID))
		{
			UserName = getUserNameByList();
			if(((UserName != "") && (mentorMenTeeRole != 0)))
			{
				if((mentorMenTeeRole == 1))
				{
					mCode = 1;
				}
				else
				{
					mCode = 0;
				}
				Class'NWindow.PersonalConnectionAPI'.static.RequestMentorCancel(mCode, UserName);
			}
		}
	}
	return;
}

function HandleDialogMenteeCancel()
{
	Class'NWindow.PersonalConnectionAPI'.static.ConfirmMenteeAdd(MentorName, 0);
	return;
}

function HandleDialogMenteeOK()
{
	Class'NWindow.PersonalConnectionAPI'.static.ConfirmMenteeAdd(MentorName, 1);
	return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	local int tabindex;

	tabindex = ConnectionsListSelectTab.GetTopIndex();
	if((tabindex == 0))
	{
		OnOneOnOneTalkBtnClick();
	}
	else if((tabindex == 1))
	{
		onDetailInfoBtnClick();
	}
	else if((tabindex == 2))
	{
		if(getInstanceUIData().GetIsLiveServer())
		{
			OnOneOnOneTalkBtnClick();
		}
	}
	return;
}

function OnClickButton(string Name)
{
	Debug(("Name" @ Name));
	switch(Name)
	{
		case "ListPlusBtn":
			OnListPlusBtnClick();
			break;
		case "ListMinusBtn":
			OnListMinusBtnClick();
			break;
		case "ListBlockBtn":
			OnListBlockBtnClick();
			break;
		case "InvitePartyBtn":
			OnInvitePartyBtnClick();
			break;
		case "SendPostBtn":
			OnSendPostBtnClick();
			break;
		case "InviteClanBtn":
			OnInviteClanBtnClick();
			break;
		case "WhisperBtn":
			OnWhisperBtnClick();
			break;
		case "DetailInfoBtn":
			onDetailInfoBtnClick();
			break;
		case "OneOnOneTalkBtn":
			OnOneOnOneTalkBtnClick();
			break;
		case "ConnectionsListSelectTab0":
			subWindowClose();
			buttonsEnabled(true);
			listTextUpdate();
			checkClanButtonState();
			WatchList.HideWindow();
			GuideTitle.HideWindow();
			Guide.HideWindow();
			ListPlusBtn.ShowWindow();
			setTextureVisible(0);
			disableButtonRaidSever();
			break;
		case "ConnectionsListSelectTab1":
			subWindowClose();
			buttonsEnabled(false);
			listTextUpdate();
			DetailInfoBtn.EnableWindow();
			WatchList.HideWindow();
			GuideTitle.HideWindow();
			Guide.HideWindow();
			ListPlusBtn.ShowWindow();
			setTextureVisible(1);
			disableButtonRaidSever();
			break;
		case "ConnectionsListSelectTab2":
			if(getInstanceUIData().GetIsClassicServer())
			{
				subWindowClose();
				buttonsEnabled(false);
				listTextUpdate();
				setTextureVisible(1);
				WhisperBtn.EnableWindow();
				SendPostBtn.EnableWindow();
				MentoringList.HideWindow();
				WatchList.ShowWindow();
				Debug("watch");
			}
			else
			{
				subWindowClose();
				buttonsEnabled(true);
				listTextUpdate();
				checkClanButtonState();
				GuideTitle.ShowWindow();
				Guide.ShowWindow();
				if(((mentorMenTeeRole == 0) || (mentorMenTeeRole == 1)))
				{
					ListPlusBtn.ShowWindow();
				}
				else
				{
					ListPlusBtn.HideWindow();
				}
				MentoringList.ShowWindow();
				WatchList.HideWindow();
				OneOnOneTalkBtn.EnableWindow();
				DetailInfoBtn.DisableWindow();
				setTextureVisible(2);
			}
			disableButtonRaidSever();
			break;
		default:
			break;
	}
	return;
}

function listTextUpdate()
{
	local int tabindex, mCount;

	tabindex = ConnectionsListSelectTab.GetTopIndex();
	if((tabindex == 0))
	{
		ListTitle.SetText(GetSystemString(2385));
		ListCount.SetText((((("(" $ string(FriendList.GetRecordCount())) $ "/") $ string(128)) $ ")"));
	}
	else if((tabindex == 1))
	{
		ListTitle.SetText(GetSystemString(2384));
		ListCount.SetText((((("(" $ string(BlockList.GetRecordCount())) $ "/") $ string(512)) $ ")"));
	}
	else if((tabindex == 2))
	{
		if(getInstanceUIData().GetIsClassicServer())
		{
			ListTitle.SetText(GetSystemString(13533));
			ListCount.SetText((((("(" $ string(WatchList.GetRecordCount())) $ "/") $ string(20)) $ ")"));
		}
		else
		{
			if(((mentorMenTeeRole == 1) || (mentorMenTeeRole == 0)))
			{
				mCount = 3;
				ListTitle.SetText(GetSystemString(2774));
			}
			else if((mentorMenTeeRole == 2))
			{
				mCount = 1;
				ListTitle.SetText(GetSystemString(2768));
			}
			ListCount.SetText((((("(" $ string(MentoringList.GetRecordCount())) $ "/") $ string(mCount)) $ ")"));
		}
	}
	return;
}

function checkEnabledButton(ListCtrlHandle List)
{
	if((List.GetRecordCount() > 0))
	{
		buttonsEnabled(true);
	}
	else
	{
		buttonsEnabled(false);
	}
	return;
}

function OnListPlusBtnClick()
{
	sideWindowOpen("AddWnd");
	return;
}

function OnListMinusBtnClick()
{
	local int tabindex;
	local string tempStr;

	tempStr = getUserNameByList();
	if((tempStr != ""))
	{
		tabindex = ConnectionsListSelectTab.GetTopIndex();
		if((tabindex == 0))
		{
			askDialog(90007);
		}
		else if((tabindex == 1))
		{
			askDialog(90008);
		}
		else if((tabindex == 2))
		{
			if(getInstanceUIData().GetIsClassicServer())
			{
				Debug("주시 삭제");  // EN?: Delete Watch
				askDialog(90030);
			}
			else
			{
				askDialog(90020);
			}
		}
	}
	return;
}

function OnListBlockBtnClick()
{
	return;
}

function OnInvitePartyBtnClick()
{
	local string tempStr;

	tempStr = ConvertWorldStrToID(getUserNameByList());
	if((tempStr != ""))
	{
		if(getInstanceUIData().getIsArenaServer())
		{
			Class'NWindow.ArenaAPI'.static.RequestMatchGroupAsk(tempStr);
		}
		else
		{
			RequestInviteParty(tempStr);
			Debug(("파티 초대 " @ tempStr));  // EN?: Party Invitation
		}
	}
	return;
}

function OnSendPostBtnClick()
{
	local PostBoxWnd postBoxWndScript;
	local PostWriteWnd postWriteWndScript;
	local string tempStr;

	tempStr = getUserNameByList();
	postBoxWndScript = PostBoxWnd(GetScript("PostBoxWnd"));
	postWriteWndScript = PostWriteWnd(GetScript("PostWriteWnd"));
	postBoxWndScript.OnClickButton("PostSendBtn");
	postWriteWndScript.ToWrite(tempStr);
	postBoxWndScript._RequestCommitionOnly();
	return;
}

function OnInviteClanBtnClick()
{
	local UserInfo Info;
	local string tempStr;
	local LVDataRecord Record;
	local int tabindex;

	tabindex = ConnectionsListSelectTab.GetTopIndex();
	tempStr = getUserNameByList();
	if((tempStr != ""))
	{
		if(GetPlayerInfo(Info))
		{
			if((tabindex == 0))
			{
				FriendList.GetSelectedRec(Record);
			}
			else if((tabindex == 2))
			{
				MentoringList.GetSelectedRec(Record);
			}
			if((Record.LVDataList[3].szData != "1"))
			{
				AddSystemMessageString(GetSystemMessage(3473));
			}
			else if((Info.nClanID > 0))
			{
				if(getInstanceUIData().GetIsClassicServer())
				{
					ClanWndClassicNew(GetScript("ClanWndClassicNew")).AskJoinByName(tempStr);
				}
				else
				{
					RequestClanAskJoinByName(tempStr, 0);
				}
			}
		}
	}
	return;
}

function askJoin()
{
	local UserInfo User;

	if(GetTargetInfo(User))
	{
		if((User.nID > 0))
		{
			if(getInstanceUIData().GetIsClassicServer())
			{
				ClanWndClassicNew(GetScript("ClanWndClassicNew")).AskJoinByName(User.Name);
			}
			else
			{
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("InviteClanPopWnd");
			}
		}
	}
	return;
}

function HandleClanMyAuth(string a_Param)
{
	local int nClanMaster;

	ParseInt(a_Param, "Join", nClanJoin);
	ParseInt(a_Param, "ClanMaster", nClanMaster);
	if(((nClanMaster == 1) || (nClanJoin == 1)))
	{
		nClanJoin = 1;
	}
	else
	{
		nClanJoin = 0;
	}
	checkClanButtonState();
	return;
}

function OnWhisperBtnClick()
{
	local ChatWnd chatWndScript;
	local string tempStr;

	tempStr = getUserNameByList();
	if((tempStr != ""))
	{
		chatWndScript = ChatWnd(GetScript("ChatWnd"));
		chatWndScript.SetChatEditBox((("\"" $ tempStr) $ " "));
	}
	return;
}

function onDetailInfoBtnClick()
{
	if((getUserNameByList() != ""))
	{
		if(m_PersonalConnectionsDrawerWnd.IsShowWindow("PersonalConnectionsDrawerWnd"))
		{
			if(!m_PersonalConnectionsDrawerWnd.DetailInfoWnd.IsShowWindow())
			{
				sideWindowOpen("DetailInfoWnd");
			}
			else
			{
				subWindowClose();
			}
		}
		else
		{
			sideWindowOpen("DetailInfoWnd");
		}
		RequestDetailInfo();
	}
	return;
}

function OnOneOnOneTalkBtnClick()
{
	local LVDataRecord Record;
	local int tabindex;
	local string UserName;

	UserName = ConvertWorldStrToID(getUserNameByList());
	tabindex = ConnectionsListSelectTab.GetTopIndex();
	if((UserName != ""))
	{
		if((tabindex == 0))
		{
			FriendList.GetSelectedRec(Record);
		}
		else if((tabindex == 2))
		{
			if(getInstanceUIData().GetIsClassicServer())
			{
				WatchList.GetSelectedRec(Record);
			}
			else
			{
				MentoringList.GetSelectedRec(Record);
			}
		}
		if((Record.LVDataList[3].szData == "1"))
		{
			Debug(("-> RequestFriendChat -:" @ UserName));
			Class'NWindow.PersonalConnectionAPI'.static.RequestFriendChat(UserName);
		}
		else
		{
			AddSystemMessageString(MakeFullSystemMsg(GetSystemMessage(3), UserName));
		}
	}
	return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	if(m_PersonalConnectionsDrawerWnd.IsShowWindow("PersonalConnectionsDrawerWnd"))
	{
		if(!IsPlayerOnWorldRaidServer())
		{
			if((ConnectionsListSelectTab.GetTopIndex() != 2))
			{
				if(!m_PersonalConnectionsDrawerWnd.DetailInfoWnd.IsShowWindow())
				{
					sideWindowOpen("DetailInfoWnd");
				}
				RequestDetailInfo();
			}
		}
	}
	return;
}

function RequestDetailInfo()
{
	local string tempStr;
	local int tabindex;

	tempStr = ConvertWorldStrToID(getUserNameByList());
	tabindex = ConnectionsListSelectTab.GetTopIndex();
	if((tempStr != ""))
	{
		if((tabindex == 0))
		{
			Class'NWindow.PersonalConnectionAPI'.static.RequestFriendDetailInfo(tempStr);
		}
		else
		{
			Class'NWindow.PersonalConnectionAPI'.static.RequestBlockDetailInfo(tempStr);
		}
	}
	return;
}

function string getUserNameByList()
{
	local LVDataRecord Record;
	local int tabindex;
	local string returnStr;

	returnStr = "";
	tabindex = ConnectionsListSelectTab.GetTopIndex();
	if((tabindex == 0))
	{
		if((FriendList.GetSelectedIndex() != -1))
		{
			FriendList.GetSelectedRec(Record);
			returnStr = Record.LVDataList[0].szData;
		}
	}
	else if((tabindex == 1))
	{
		if((BlockList.GetSelectedIndex() != -1))
		{
			BlockList.GetSelectedRec(Record);
			returnStr = Record.LVDataList[0].szData;
		}
	}
	else if((tabindex == 2))
	{
		if(getInstanceUIData().GetIsClassicServer())
		{
			if((WatchList.GetSelectedIndex() != -1))
			{
				WatchList.GetSelectedRec(Record);
				returnStr = Record.LVDataList[0].szData;
			}
		}
		else if((MentoringList.GetSelectedIndex() != -1))
		{
			MentoringList.GetSelectedRec(Record);
			returnStr = Record.LVDataList[0].szData;
		}
	}
	if((returnStr == ""))
	{
		AddSystemMessage(3314);
	}
	return returnStr;
}

function OnCallUCFunction(string funcName, string param)
{
	if((funcName == "checkInviteClanByGfxCallFunction"))
	{
		if((param == "1"))
		{
			nClanJoin = 1;
		}
		else
		{
			nClanJoin = 0;
		}
		checkClanButtonState();
	}
	return;
}

function checkClanButtonState()
{
	local UserInfo UserInfo;

	if(IsPlayerOnWorldRaidServer())
	{
		InviteClanBtn.DisableWindow();
		return;
	}
	if(GetPlayerInfo(UserInfo))
	{
		if((UserInfo.nClanID == 0))
		{
			InviteClanBtn.DisableWindow();
		}
		else
		{
			switch(ConnectionsListSelectTab.GetTopIndex())
			{
				case 0:
				case 2:
					if((getInstanceUIData().GetIsClassicServer() && (ConnectionsListSelectTab.GetTopIndex() == 2)))
					{
						InviteClanBtn.DisableWindow();
					}
					else
					{
						if((nClanJoin == 0))
						{
							InviteClanBtn.DisableWindow();
						}
						else
						{
							InviteClanBtn.EnableWindow();
						}
						break;
					}
				default:
					break;
			}
		}
	}
	return;
}

function buttonsEnabled(bool bFlag)
{
	if(bFlag)
	{
		InvitePartyBtn.EnableWindow();
		SendPostBtn.EnableWindow();
		InviteClanBtn.EnableWindow();
		WhisperBtn.EnableWindow();
		DetailInfoBtn.EnableWindow();
		OneOnOneTalkBtn.EnableWindow();
	}
	else
	{
		InvitePartyBtn.DisableWindow();
		SendPostBtn.DisableWindow();
		InviteClanBtn.DisableWindow();
		WhisperBtn.DisableWindow();
		DetailInfoBtn.DisableWindow();
		OneOnOneTalkBtn.DisableWindow();
	}
	return;
}

function removeAllArrayItems(out array<relationMemberInfo> pArray)
{
	if((pArray.Length > 0))
	{
		pArray.Remove(0, pArray.Length);
	}
	return;
}

function removeArrayItem(out array<relationMemberInfo> pArray, int deleteItemIndex)
{
	if((pArray.Length > deleteItemIndex))
	{
		pArray.Remove(deleteItemIndex, 1);
	}
	return;
}

function sideWindowOpen(string sideWindowName)
{
	local WindowHandle sideWindowHandler;

	sideWindowHandler = GetWindowHandle(("PersonalConnectionsDrawerWnd." $ sideWindowName));
	if(m_PersonalConnectionsDrawerWnd.IsShowWindow("PersonalConnectionsDrawerWnd"))
	{
		if(sideWindowHandler.IsShowWindow())
		{
			m_PersonalConnectionsDrawerWnd.HideWindow("PersonalConnectionsDrawerWnd");
		}
		else
		{
			m_PersonalConnectionsDrawerWnd.showSelectWindow(sideWindowName);
		}
	}
	else
	{
		m_PersonalConnectionsDrawerWnd.ShowWindow("PersonalConnectionsDrawerWnd");
		m_PersonalConnectionsDrawerWnd.showSelectWindow(sideWindowName);
	}
	return;
}

function subWindowClose()
{
	if(m_PersonalConnectionsDrawerWnd.IsShowWindow("PersonalConnectionsDrawerWnd"))
	{
		m_PersonalConnectionsDrawerWnd.HideWindow("PersonalConnectionsDrawerWnd");
	}
	return;
}

function CustomTooltip getMemoToolTip(int Job, string memo)
{
	local CustomTooltip m_Tooltip;

	m_Tooltip.DrawList.Length = 2;
	m_Tooltip.MinimumWidth = 160;
	m_Tooltip.DrawList[0].eType = DIT_TEXT;
	m_Tooltip.DrawList[0].t_strText = ((GetSystemString(391) $ " : ") $ GetClassType(Job));
	m_Tooltip.DrawList[1].eType = DIT_TEXT;
	m_Tooltip.DrawList[1].t_color.R = 175;
	m_Tooltip.DrawList[1].t_color.G = 152;
	m_Tooltip.DrawList[1].t_color.B = 120;
	m_Tooltip.DrawList[1].t_color.A = 255;
	m_Tooltip.DrawList[1].t_strText = memo;
	return m_Tooltip;
}

function ParsePacket_S_EX_USER_WATCHER_TARGET_STATUS()
{
	local UIPacket._S_EX_USER_WATCHER_TARGET_STATUS packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_USER_WATCHER_TARGET_STATUS(packet))
	{
		return;
	}
	Debug((((" -->  Decode_S_EX_USER_WATCHER_TARGET_STATUS :  " @ packet.sName) @ string(packet.nWorldID)) @ string(packet.bLoggedin)));
	watchInfoUpdateHandle(packet.sName, packet.nWorldID, bool(packet.bLoggedin));
	return;
}

function watchInfoUpdateHandle(string Name, int nWorldID, bool bLoggedin)
{
	local LVDataRecord tempRecord;
	local int i;

	WatchList.ClearTooltip();
	if(IsPlayerOnWorldRaidServer())
	{
		Name = ConvertWorldIDToStr(((Name $ "_") $ string(nWorldID)));
	}
	i = 0;
	while((i < WatchList.GetRecordCount()))
	{
		WatchList.GetRec(i, tempRecord);
		if((tempRecord.LVDataList[0].szData == Name))
		{
			if(bLoggedin)
			{
				tempRecord.LVDataList[0].bUseTextColor = true;
				tempRecord.LVDataList[0].TextColor = util.BrightWhite;
				tempRecord.LVDataList[1].szData = "1";
				tempRecord.LVDataList[1].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logon";
			}
			else
			{
				tempRecord.LVDataList[0].bUseTextColor = true;
				tempRecord.LVDataList[0].TextColor = util.White;
				tempRecord.LVDataList[1].szData = "0";
				tempRecord.LVDataList[1].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff";
			}
			WatchList.ModifyRecord(i, tempRecord);
			break;
		}
		i++;
	}
	return;
}

function string splitName(string withServerName)
{
	local array<string> arr;

	Split(withServerName, "_", arr);
	Debug(("arr" @ string(arr.Length)));
	if((arr.Length > 1))
	{
		return arr[0];
	}
	return withServerName;
}

function disableButtonRaidSever()
{
	if(IsPlayerOnWorldRaidServer())
	{
		DetailInfoBtn.DisableWindow();
		SendPostBtn.DisableWindow();
		InviteClanBtn.DisableWindow();
	}
	return;
}

function ParsePacket_S_EX_USER_WATCHER_TARGET_LIST()
{
	local UIPacket._S_EX_USER_WATCHER_TARGET_LIST packet;
	local int i;
	local LVDataRecord Record;

	WatchList.DeleteAllItem();
	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_USER_WATCHER_TARGET_LIST(packet))
	{
		return;
	}
	i = 0;
	while((i < packet.targetList.Length))
	{
		Debug((((((" -->  Decode_S_EX_USER_WATCHER_TARGET_LIST :  " @ packet.targetList[i].sName) @ string(packet.targetList[i].nWorldID)) @ string(packet.targetList[i].nLevel)) @ string(packet.targetList[i].nClass)) @ string(packet.targetList[i].bLoggedin)));
		setWatchListRecord(Record, packet.targetList[i].sName, packet.targetList[i].nWorldID, packet.targetList[i].nLevel, packet.targetList[i].nClass, bool(packet.targetList[i].bLoggedin));
		WatchList.InsertRecord(Record);
		i++;
	}
	return;
}

function setWatchListRecord(out LVDataRecord Record, string sName, int nWorldID, int Level, int ClassID, bool bLoggedin)
{
	local string Name;
	local Color TextColor;

	Record.LVDataList.Length = 2;
	if(IsPlayerOnWorldRaidServer())
	{
		Name = ((sName $ "_") $ string(nWorldID));
	}
	else
	{
		Name = sName;
	}
	Record.nReserved1 = INT64(nWorldID);
	Record.LVDataList[0].szData = ConvertWorldIDToStr(Name);
	Record.LVDataList[0].szReserved = Name;
	Record.LVDataList[1].nTextureWidth = 31;
	Record.LVDataList[1].nTextureHeight = 11;
	Record.nReserved1 = INT64(0);
	Debug(("bLoggedin" @ string(bLoggedin)));
	if(bLoggedin)
	{
		TextColor = util.BrightWhite;
		Record.LVDataList[1].szData = "1";
		Record.LVDataList[1].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logon";
	}
	else
	{
		TextColor = util.White;
		Record.LVDataList[1].szData = "0";
		Record.LVDataList[1].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff";
	}
	Record.LVDataList[0].bUseTextColor = true;
	Record.LVDataList[0].TextColor = TextColor;
	return;
}

function API_C_EX_USER_WATCHER_DELETE(string sTargetName, int nTargetWorldID)
{
	local array<byte> stream;
	local UIPacket._C_EX_USER_WATCHER_DELETE packet;

	packet.sTargetName = sTargetName;
	packet.nTargetWorldID = nTargetWorldID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_USER_WATCHER_DELETE(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(701, stream);
	Debug((("----> Api Call : C_EX_USER_WATCHER_DELETE" @ sTargetName) @ string(nTargetWorldID)));
	return;
}

function API_C_EX_USER_WATCHER_TARGET_LIST()
{
	local array<byte> stream;

	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(699, stream);
	Debug("----> Api Call : C_EX_USER_WATCHER_TARGET_LIST");
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("PersonalConnectionsWnd").HideWindow();
	return;
}
