class PersonalConnectionsDrawerWnd extends UICommonAPI
	dependson(UIPacket);

const MAX_MEMO_LENGTH = 50;

var WindowHandle Me;
var WindowHandle AddWnd;
var TextBoxHandle AddWndTitle;
var TabHandle AddWndTab;
var TextureHandle AddListTabBgLine;
var TextureHandle AddListTabBg;
var WindowHandle NameEnterWnd;
var TextBoxHandle NameEnter_Description;
var TextBoxHandle NameEnterTitle;
var EditBoxHandle NameEnterEditbox;
var TextureHandle DecoGroupBox;
var WindowHandle ClanListWnd;
var TextBoxHandle ClanList_Description;
var TextureHandle ClanListDeco;
var ListCtrlHandle ClanList;
var TextureHandle ClanListGroupBox;
var WindowHandle InzoneTreeWnd;
var TextBoxHandle InzoneTree_Description;
var TreeHandle InzoneTree;
var TextureHandle InzoneClanListGroupBox;
var ButtonHandle AddListBtn;
var ButtonHandle CloseBtn;
var TextureHandle DescriptionGroupBox;
var WindowHandle DetailInfoWnd;
var WindowHandle MenteeSearchWnd;
var MultiEditBoxHandle MemoContents;
var ButtonHandle MemoEnterBtn;
var TextureHandle texPledgeCrest;
var TextureHandle texPledgeAllianceCrest;
var ButtonHandle AddMenteeBtn;
var ButtonHandle WhisperMenteeBtn;
var ButtonHandle CloseMenteeBtn;
var ButtonHandle RefreshMenteeBtn;
var ButtonHandle BackwardBtn;
var ButtonHandle ForwardBtn;
var TextBoxHandle MenteeCount;
var ComboBoxHandle LevelComboBox;
var ListCtrlHandle MenteeList;
var PersonalConnectionsWnd PersonalConnectionsWndScript;
var int menTeeListCurrentPageCount;
var int menTeeListTotalPage;
var L2Util util;
var string beforeSelectedTreePath;
var string inzoneSelectedParam;
var string selectTreeNodeStr;
var TextBoxHandle NameEnterLimit;
var TextBoxHandle NameEnterLimitTime;

function OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(420);
	RegisterEvent(400);
	RegisterEvent(440);
	RegisterEvent(450);
	RegisterEvent(320);
	RegisterEvent(330);
	RegisterEvent(410);
	RegisterEvent(5000);
	RegisterEvent(5830);
	RegisterEvent(5840);
	RegisterEvent(5850);
	RegisterEvent(5810);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();
	util = L2Util(GetScript("L2Util"));
	LevelComboBox.AddString(GetSystemString(2780));
	LevelComboBox.AddString(GetSystemString(2781));
	LevelComboBox.AddString(GetSystemString(2782));
	LevelComboBox.AddString(GetSystemString(2783));
	menTeeListTotalPage = 1;
	menTeeListCurrentPageCount = 1;
	return;
}

function mentorMenteeListStartHandle(string param)
{
	local int DisableTimeInSec;

	ParseInt(param, "DisableTimeInSec", DisableTimeInSec);
	if((DisableTimeInSec == 0))
	{
		NameEnterLimit.SetText("");
		NameEnterLimitTime.SetText("");
	}
	else
	{
		NameEnterLimit.SetText(GetSystemMessage(3902));
		NameEnterLimitTime.SetText(makeNameEnterLimitTime(DisableTimeInSec));
	}
	return;
}

function string makeNameEnterLimitTime(int DisableTimeInSec)
{
	local string tmpStr;
	local int CurDay, Totday, Curhou, Tothou, CurMin, Totmin, Totsec;

	Totsec = DisableTimeInSec;
	if((Totsec < 60))
	{
		tmpStr = MakeFullSystemMsg(GetSystemMessage(3390), "1");
		tmpStr = MakeFullSystemMsg(GetSystemMessage(3408), tmpStr);
	}
	else
	{
		Totmin = (Totsec / 60);
		CurMin = int((float(Totmin) % 60.0000000));
		Tothou = (Totmin / 60);
		Curhou = int((float(Tothou) % 24.0000000));
		Totday = (Tothou / 24);
		CurDay = int((float(Totday) % 24.0000000));
		if((Tothou >= 24))
		{
			tmpStr = MakeFullSystemMsg(GetSystemMessage(3418), string(CurDay));
		}
		if(((Tothou > 0) && (Curhou != 0)))
		{
			tmpStr = (tmpStr @ MakeFullSystemMsg(GetSystemMessage(3406), string(Curhou)));
		}
		if((CurMin != 0))
		{
			tmpStr = (tmpStr @ MakeFullSystemMsg(GetSystemMessage(3390), string(CurMin)));
		}
	}
	tmpStr = (GetSystemString(1108) @ tmpStr);
	return tmpStr;
}

function OnShow()
{
	if(((PersonalConnectionsWndScript.ConnectionsListSelectTab.GetTopIndex() == 2) && getInstanceUIData().GetIsClassicServer()))
	{
	}
	else if(getInstanceL2Util().isClanV2())
	{
		Class'NWindow.PostWndAPI'.static.RequestPledgeMemberList();
		GetButtonHandle("PersonalConnectionsDrawerWnd.AddWnd.ClanListWnd.ClanListReset_Btn").ShowWindow();
	}
	else if(!IsPlayerOnWorldRaidServer())
	{
		Class'NWindow.UIDATA_CLAN'.static.RequestClanInfo();
		GetButtonHandle("PersonalConnectionsDrawerWnd.AddWnd.ClanListWnd.ClanListReset_Btn").HideWindow();
	}
	texPledgeCrest.HideWindow();
	texPledgeAllianceCrest.HideWindow();
	if(getInstanceUIData().GetIsClassicServer())
	{
		if(IsPlayerOnWorldRaidServer())
		{
			AddWndTab.SetDisable(1, true);
		}
		else
		{
			AddWndTab.SetDisable(1, false);
		}
	}
	return;
}

function Initialize()
{
	Me = GetWindowHandle("PersonalConnectionsDrawerWnd");
	NameEnterLimit = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterLimit");
	NameEnterLimitTime = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterLimitTime");
	AddWnd = GetWindowHandle("PersonalConnectionsDrawerWnd.AddWnd");
	AddWndTitle = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.AddWndTitle");
	AddWndTab = GetTabHandle("PersonalConnectionsDrawerWnd.AddWnd.AddWndTab");
	AddListTabBgLine = GetTextureHandle("PersonalConnectionsDrawerWnd.AddWnd.AddListTabBgLine");
	AddListTabBg = GetTextureHandle("PersonalConnectionsDrawerWnd.AddWnd.AddListTabBg");
	NameEnterWnd = GetWindowHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterWnd");
	NameEnter_Description = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterWnd.NameEnter_Description");
	NameEnterTitle = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterWnd.NameEnterTitle");
	NameEnterEditbox = GetEditBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterWnd.NameEnterEditbox");
	DecoGroupBox = GetTextureHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterWnd.DecoGroupBox");
	ClanListWnd = GetWindowHandle("PersonalConnectionsDrawerWnd.AddWnd.ClanListWnd");
	ClanList_Description = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.ClanListWnd.ClanList_Description");
	ClanListDeco = GetTextureHandle("PersonalConnectionsDrawerWnd.AddWnd.ClanListWnd.ClanListDeco");
	ClanList = GetListCtrlHandle("PersonalConnectionsDrawerWnd.AddWnd.ClanListWnd.ClanList");
	ClanListGroupBox = GetTextureHandle("PersonalConnectionsDrawerWnd.AddWnd.ClanListWnd.ClanListGroupBox");
	InzoneClanListGroupBox = GetTextureHandle("PersonalConnectionsDrawerWnd.AddWnd.InzoneTreeWnd.ClanListGroupBox");
	InzoneTreeWnd = GetWindowHandle("PersonalConnectionsDrawerWnd.AddWnd.InzoneTreeWnd");
	InzoneTree_Description = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.InzoneTreeWnd.InzoneTree_Description");
	InzoneTree = GetTreeHandle("PersonalConnectionsDrawerWnd.AddWnd.InzoneTreeWnd.InzoneTree");
	AddListBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.AddWnd.AddListBtn");
	CloseBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.AddWnd.CloseBtn");
	DescriptionGroupBox = GetTextureHandle("PersonalConnectionsDrawerWnd.AddWnd.DescriptionGroupBox");
	DetailInfoWnd = GetWindowHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd");
	MenteeSearchWnd = GetWindowHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd");
	MemoContents = GetMultiEditBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.MemoContents");
	MemoEnterBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.MemoEnterBtn");
	if(getInstanceUIData().GetIsClassicServer())
	{
		texPledgeCrest = GetTextureHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.texPledgeCrestClassic");
	}
	else
	{
		texPledgeCrest = GetTextureHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.texPledgeCrest");
	}
	texPledgeAllianceCrest = GetTextureHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.texPledgeAllianceCrest");
	AddMenteeBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.AddMenteeBtn");
	WhisperMenteeBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.WhisperMenteeBtn");
	CloseMenteeBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.CloseMenteeBtn");
	RefreshMenteeBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.RefreshMenteeBtn");
	BackwardBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.BackwardBtn");
	ForwardBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.ForwardBtn");
	MenteeCount = GetTextBoxHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.MenteeCount");
	LevelComboBox = GetComboBoxHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.LevelComboBox");
	MenteeList = GetListCtrlHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.MenteeList");
	PersonalConnectionsWndScript = PersonalConnectionsWnd(GetScript("PersonalConnectionsWnd"));
	MemoContents.SetMaxSizeOfText(50);
	GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.BlockInfoText").HideWindow();
	beforeSelectedTreePath = "";
	if(getInstanceUIData().getIsArenaServer())
	{
		AddWndTab.InitTabCtrl();
		AddWndTab.RemoveTabControl(2);
		AddWndTab.RemoveTabControl(1);
		AddListTabBgLine.SetWindowSize(182, 24);
	}
	return;
}

function Load()
{
	return;
}

function OnClickButton(string Name)
{
	local LVDataRecord Record;
	local string tempStr;

	switch(Name)
	{
		case "ClanListReset_Btn":
			Class'NWindow.PostWndAPI'.static.RequestPledgeMemberList();
			break;
		case "AddListBtn":
			OnAddListBtnClick();
			break;
		case "CloseMenteeBtn":
		case "CloseBtn":
			OnCloseBtnClick();
			break;
		case "MemoEnterBtn":
			memoEnterBtnHandler();
			break;
		case "AddWndTab0":
		case "AddWndTab1":
		case "AddWndTab2":
			if((PersonalConnectionsWndScript.ConnectionsListSelectTab.GetTopIndex() == 2))
			{
				if((AddWndTab.GetTopIndex() == 2))
				{
					InzoneTreeWnd.HideWindow();
					MenteeSearchWnd.ShowWindow();
					AddListBtn.HideWindow();
					CloseBtn.HideWindow();
					callMenTeeList(LevelComboBox.GetSelectedNum(), 1);
				}
				else
				{
					MenteeSearchWnd.HideWindow();
					AddListBtn.ShowWindow();
					CloseBtn.ShowWindow();
				}
			}
			else
			{
				AddListBtn.ShowWindow();
				CloseBtn.ShowWindow();
			}
			break;
		case "RefreshMenteeBtn":
			callMenTeeList(LevelComboBox.GetSelectedNum(), 1);
			break;
		case "BackwardBtn":
			callMenTeeList(LevelComboBox.GetSelectedNum(), (menTeeListCurrentPageCount - 1));
			break;
		case "ForwardBtn":
			callMenTeeList(LevelComboBox.GetSelectedNum(), (menTeeListCurrentPageCount + 1));
			break;
		case "WhisperMenteeBtn":
			OnDBClickListCtrlRecord("MenteeList");
			break;
		case "AddMenteeBtn":
			MenteeList.GetSelectedRec(Record);
			if((Record.LVDataList.Length > 0))
			{
				tempStr = Record.LVDataList[0].szData;
			}
			if((tempStr != ""))
			{
				Class'NWindow.PersonalConnectionAPI'.static.RequestMenteeAdd(tempStr);
			}
			else
			{
				AddSystemMessage(3314);
			}
			break;
		default:
			break;
	}
	if((Left(Name, 4) == "root"))
	{
		if((13 < Len(Name)))
		{
			if((beforeSelectedTreePath != Name))
			{
				if((beforeSelectedTreePath == ""))
				{
				}
				else
				{
					InzoneTree.SetExpandedNode(beforeSelectedTreePath, false);
					selectTreeNodeStr = "";
				}
			}
			else
			{
				InzoneTree.SetExpandedNode(beforeSelectedTreePath, true);
			}
			ParseString(inzoneSelectedParam, Name, selectTreeNodeStr);
			beforeSelectedTreePath = Name;
		}
		else
		{
			InzoneTree.SetExpandedNode(beforeSelectedTreePath, false);
			beforeSelectedTreePath = "";
			selectTreeNodeStr = "";
		}
	}
	return;
}

function treeSelectHandler()
{
	return;
}

function memoEnterBtnHandler()
{
	local string UserName;
	local int parentTabIndex;

	UserName = GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.TargetNameText").GetText();
	if((MemoContents.GetString() != ""))
	{
		if((MemoContents.GetTotalSizeOfText() <= 50))
		{
			parentTabIndex = PersonalConnectionsWndScript.ConnectionsListSelectTab.GetTopIndex();
			if((parentTabIndex == 0))
			{
				Class'NWindow.PersonalConnectionAPI'.static.RequestUpdateFriendMemo(UserName, MemoContents.GetString());
			}
			else
			{
				Class'NWindow.PersonalConnectionAPI'.static.RequestUpdateBlockMemo(UserName, MemoContents.GetString());
			}
			AddSystemMessage(3332);
		}
	}
	return;
}

function OnComboBoxItemSelected(string strID, int IndexID)
{
	switch(strID)
	{
		case "LevelComboBox":
			callMenTeeList(IndexID, 1);
			break;
		default:
			break;
	}
	return;
}

function callMenTeeList(int comboLevelIndex, int nChangePage)
{
	if((nChangePage > menTeeListTotalPage))
	{
		nChangePage = menTeeListTotalPage;
	}
	if((nChangePage < 1))
	{
		nChangePage = menTeeListTotalPage;
	}
	switch(comboLevelIndex)
	{
		case 0:
			RequestMenteeWaitingList(nChangePage, 1, 105);
			break;
		case 1:
			RequestMenteeWaitingList(nChangePage, 1, 40);
			break;
		case 2:
			RequestMenteeWaitingList(nChangePage, 41, 84);
			break;
		case 3:
			RequestMenteeWaitingList(nChangePage, 85, 104);
			break;
		default:
			break;
	}
	return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	if((ListCtrlID == "ClanList"))
	{
	}
	return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	local int tabindex;
	local string tempStr;
	local ChatWnd chatWndScript;
	local LVDataRecord Record;

	tabindex = AddWndTab.GetTopIndex();
	if((ListCtrlID == "MenteeList"))
	{
		MenteeList.GetSelectedRec(Record);
		tempStr = Record.LVDataList[0].szData;
		if((tempStr != ""))
		{
			chatWndScript = ChatWnd(GetScript("ChatWnd"));
			chatWndScript.SetChatEditBox((("\"" $ tempStr) $ " "));
		}
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 40:
			restartHandler();
			break;
		case 5000:
			HandleReceivePledgeMemberList(param);
			break;
		case 320:
		case 420:
			if(!getInstanceL2Util().isClanV2())
			{
				clanMemberInfoListEmptyHandle();
			}
			break;
		case 400:
		case 410:
			if(!getInstanceL2Util().isClanV2())
			{
				clanMemberAddedHandle(param);
			}
			break;
		case 440:
			if(!getInstanceL2Util().isClanV2())
			{
				clanMemberInfoUpdateHandle(param);
			}
			break;
		case 450:
			if(!getInstanceL2Util().isClanV2())
			{
				clanMemberRemovedHandle(param);
			}
			break;
		case 5830:
			menteeWaitingListStartHandle(param);
			break;
		case 5840:
			menteeWaitingListHandle(param);
			break;
		case 5850:
			menteeWaitingListEndHandle(param);
			break;
		case 5810:
			mentorMenteeListStartHandle(param);
			break;
		default:
			break;
	}
	return;
}

function menteeWaitingListStartHandle(string param)
{
	local int currentPageCount, TotalPage;

	ParseInt(param, "CurPage", currentPageCount);
	ParseInt(param, "TotalPage", TotalPage);
	if(((currentPageCount <= 0) || (TotalPage <= 0)))
	{
	}
	else
	{
		menTeeListCurrentPageCount = currentPageCount;
		menTeeListTotalPage = TotalPage;
		MenteeList.DeleteAllItem();
		MenteeCount.SetText(((string(menTeeListCurrentPageCount) $ "/") $ string(menTeeListTotalPage)));
		if((menTeeListTotalPage <= menTeeListCurrentPageCount))
		{
			ForwardBtn.DisableWindow();
		}
		else
		{
			ForwardBtn.EnableWindow();
		}
		if((menTeeListCurrentPageCount <= 1))
		{
			BackwardBtn.DisableWindow();
		}
		else
		{
			BackwardBtn.EnableWindow();
		}
	}
	return;
}

function menteeWaitingListHandle(string param)
{
	local LVDataRecord Record;

	setMenteeMemberRecord(Record, param);
	MenteeList.InsertRecord(Record);
	return;
}

function menteeWaitingListEndHandle(string param)
{
	return;
}

function setMenteeMemberRecord(out LVDataRecord Record, string param)
{
	local string Name, levelString;
	local int ClassID, Level, Status;

	Record.LVDataList.Length = 4;
	ParseString(param, "Name", Name);
	ParseInt(param, "Class", ClassID);
	ParseInt(param, "Level", Level);
	if((Status < 1))
	{
		ParseInt(param, "Status", Status);
	}
	if(((Level >= 1) && (Level <= 40)))
	{
		levelString = GetSystemString(2789);
	}
	else if(((Level >= 41) && (Level <= 84)))
	{
		levelString = GetSystemString(2790);
	}
	else if(((Level >= 85) && (Level <= 104)))
	{
		levelString = GetSystemString(2791);
	}
	Record.LVDataList[0].bUseTextColor = true;
	Record.LVDataList[0].TextColor = util.BrightWhite;
	Record.LVDataList[1].bUseTextColor = true;
	Record.LVDataList[1].TextColor = util.BrightWhite;
	Record.LVDataList[0].szData = Name;
	Record.LVDataList[1].szData = levelString;
	Record.LVDataList[1].textAlignment = TA_Center;
	Record.LVDataList[2].szData = string(ClassID);
	Record.LVDataList[2].szTexture = GetClassRoleIconName(ClassID);
	Record.LVDataList[2].HiddenStringForSorting = string(GetClassRoleType(ClassID));
	Record.LVDataList[2].nTextureWidth = 11;
	Record.LVDataList[2].nTextureHeight = 11;
	Record.nReserved1 = INT64(0);
	return;
}

function restartHandler()
{
	OnShow();
	clanMemberInfoListEmptyHandle();
	return;
}

function OnAddListBtnClick()
{
	local int tabindex;
	local string tempStr;
	local int serverNum;
	local string UserName;
	local array<string> arr;

	tabindex = AddWndTab.GetTopIndex();
	if((tabindex == 0))
	{
		if((NameEnterEditbox.GetString() != ""))
		{
			switch(PersonalConnectionsWndScript.ConnectionsListSelectTab.GetTopIndex())
			{
				case 0:
					Class'NWindow.PersonalConnectionAPI'.static.RequestAddFriend(ConvertWorldStrToID(NameEnterEditbox.GetString()));
					break;
				case 1:
					Class'NWindow.PersonalConnectionAPI'.static.RequestAddBlock(ConvertWorldStrToID(NameEnterEditbox.GetString()));
					Debug(("on RequestAddBlock" @ ConvertWorldStrToID(NameEnterEditbox.GetString())));
					break;
				case 2:
					if(getInstanceUIData().GetIsClassicServer())
					{
						Debug(("- 주시 등록" @ NameEnterEditbox.GetString()));  // EN?: - Watch Registration
						if(IsPlayerOnWorldRaidServer())
						{
							Debug(("ConvertWorldStrToID(NameEnterEditbox.GetString()" @ ConvertWorldStrToID(NameEnterEditbox.GetString())));
							Split(ConvertWorldStrToID(NameEnterEditbox.GetString()), "_", arr);
							if((arr.Length > 1))
							{
								UserName = arr[0];
								serverNum = int(arr[1]);
							}
						}
						else
						{
							UserName = NameEnterEditbox.GetString();
							serverNum = 0;
						}
						Debug(("userName" @ UserName));
						Debug(("serverNum" @ string(serverNum)));
						API_C_EX_USER_WATCHER_ADD(UserName, serverNum);
					}
					else
					{
						Class'NWindow.PersonalConnectionAPI'.static.RequestMenteeAdd(NameEnterEditbox.GetString());
					}
					break;
				default:
					break;
			}
			NameEnterEditbox.SetString("");
		}
		else
		{
			AddSystemMessage(3718);
		}
	}
	else if((tabindex == 1))
	{
		tempStr = ConvertWorldStrToID(getUserNameByList());
		if((tempStr != ""))
		{
			switch(PersonalConnectionsWndScript.ConnectionsListSelectTab.GetTopIndex())
			{
				case 0:
					Class'NWindow.PersonalConnectionAPI'.static.RequestAddFriend(tempStr);
					break;
				case 1:
					Class'NWindow.PersonalConnectionAPI'.static.RequestAddBlock(tempStr);
					Debug(("c_on RequestAddBlock" @ tempStr));
					break;
				case 2:
					if(getInstanceUIData().GetIsClassicServer())
					{
						Debug(("혈맹에 있는 주시 등록" @ tempStr));  // EN?: Watch Enrollment in Blood
						if(IsPlayerOnWorldRaidServer())
						{
							Split(ConvertWorldStrToID(tempStr), "_", arr);
							if((arr.Length > 1))
							{
								UserName = arr[0];
								serverNum = int(arr[1]);
							}
						}
						else
						{
							UserName = tempStr;
							serverNum = 0;
						}
						Debug(("userName" @ UserName));
						Debug(("serverNum" @ string(serverNum)));
						API_C_EX_USER_WATCHER_ADD(UserName, serverNum);
					}
					else
					{
						Class'NWindow.PersonalConnectionAPI'.static.RequestMenteeAdd(tempStr);
					}
					break;
				default:
					break;
			}
		}
		else
		{
			AddSystemMessage(3314);
		}
	}
	else if((tabindex == 2))
	{
		if((selectTreeNodeStr != ""))
		{
			switch(PersonalConnectionsWndScript.ConnectionsListSelectTab.GetTopIndex())
			{
				case 0:
					Class'NWindow.PersonalConnectionAPI'.static.RequestAddFriend(selectTreeNodeStr);
					break;
				case 1:
					Class'NWindow.PersonalConnectionAPI'.static.RequestAddBlock(selectTreeNodeStr);
					break;
				case 2:
					Class'NWindow.PersonalConnectionAPI'.static.RequestMenteeAdd(selectTreeNodeStr);
					break;
				default:
					break;
			}
		}
		else
		{
			AddSystemMessage(3314);
		}
	}
	return;
}

function OnCloseBtnClick()
{
	Me.HideWindow();
	return;
}

function HandleReceivePledgeMemberList(string param)
{
	local int Num, i;
	local string strName;
	local int ClanClass, ClanLevel, logon;
	local LVDataRecord Record;
	local array<string> AddName;

	if(!getInstanceL2Util().isClanV2())
	{
		return;
	}
	ParseInt(param, "Num", Num);
	ClanList.DeleteAllItem();
	i = 0;
	while((i < Num))
	{
		ParseString(param, ("Name" $ string(i)), strName);
		ParseInt(param, ("FriendClass" $ string(i)), ClanClass);
		ParseInt(param, ("FriendLevel" $ string(i)), ClanLevel);
		ParseInt(param, ("FriendLogon" $ string(i)), logon);
		AddName[i] = strName;
		Record.LVDataList.Length = 4;
		if((logon > 0))
		{
			Record.LVDataList[0].bUseTextColor = true;
			Record.LVDataList[0].TextColor = util.BrightWhite;
			Record.LVDataList[1].bUseTextColor = true;
			Record.LVDataList[1].TextColor = util.BrightWhite;
		}
		else
		{
			Record.LVDataList[0].bUseTextColor = true;
			Record.LVDataList[0].TextColor = util.White;
			Record.LVDataList[1].bUseTextColor = true;
			Record.LVDataList[1].TextColor = util.White;
		}
		Record.LVDataList[0].szData = ConvertWorldIDToStr(strName);
		Record.LVDataList[0].szReserved = strName;
		Record.LVDataList[1].szData = string(ClanLevel);
		Record.LVDataList[2].szTexture = GetClassRoleIconName(ClanClass);
		Record.LVDataList[2].nTextureWidth = 11;
		Record.LVDataList[2].nTextureHeight = 11;
		Record.LVDataList[2].szData = string(ClanClass);
		Record.LVDataList[2].HiddenStringForSorting = string(GetClassRoleType(ClanClass));
		Record.LVDataList[3].nTextureWidth = 31;
		Record.LVDataList[3].nTextureHeight = 11;
		if((logon > 0))
		{
			Record.LVDataList[3].szData = "1";
			Record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logon";
		}
		else
		{
			Record.LVDataList[3].szData = "0";
			Record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff";
		}
		ClanList.InsertRecord(Record);
		i++;
	}
	return;
}

function setClanMemberRecord(out LVDataRecord Record, string param)
{
	local string Name;
	local int ClassID, Level, Status;

	Record.LVDataList.Length = 4;
	ParseString(param, "Name", Name);
	ParseInt(param, "Class", ClassID);
	ParseInt(param, "Level", Level);
	ParseInt(param, "ID", Status);
	if((Status < 1))
	{
		ParseInt(param, "Status", Status);
	}
	if((Status > 0))
	{
		Record.LVDataList[0].bUseTextColor = true;
		Record.LVDataList[0].TextColor = util.BrightWhite;
		Record.LVDataList[1].bUseTextColor = true;
		Record.LVDataList[1].TextColor = util.BrightWhite;
	}
	else
	{
		Record.LVDataList[0].bUseTextColor = true;
		Record.LVDataList[0].TextColor = util.White;
		Record.LVDataList[1].bUseTextColor = true;
		Record.LVDataList[1].TextColor = util.White;
	}
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

function clanMemberAddedV2Handle(string param)
{
	local LVDataRecord Record;

	setClanMemberRecord(Record, param);
	ClanList.InsertRecord(Record);
	return;
}

function clanMemberInfoListEmptyHandle()
{
	ClanList.DeleteAllItem();
	return;
}

function clanMemberAddedHandle(string param)
{
	local LVDataRecord Record;

	setClanMemberRecord(Record, param);
	ClanList.InsertRecord(Record);
	return;
}

function clanMemberRemovedHandle(string param)
{
	local string Name;
	local int i;

	ParseString(param, "Name", Name);
	i = util.ctrlListSearchByName(ClanList, ConvertWorldIDToStr(Name));
	if((i != -1))
	{
		ClanList.DeleteRecord(i);
	}
	return;
}

function clanMemberInfoUpdateHandle(string param)
{
	local LVDataRecord Record, tempRecord;
	local string Name;
	local int i;

	ParseString(param, "Name", Name);
	setClanMemberRecord(Record, param);
	i = 0;
	while((i < ClanList.GetRecordCount()))
	{
		ClanList.GetRec(i, tempRecord);
		if((tempRecord.LVDataList[0].szData == ConvertWorldIDToStr(Name)))
		{
			ClanList.ModifyRecord(i, Record);
			break;
		}
		i++;
	}
	return;
}

function InzonePartyHistoryUpdateHandler(string param)
{
	local string strRetName, treeName, ROOTNAME;
	local int NumberOfInzoneParty, NumberOfPartyMember, InzoneTypeID, InzoneUseTimeYear, InzoneUseTimeMonth, InzoneUseTimeDay, InzoneClassID, InzoneStatus, inzoneCount, PartyMemberCount;
	local string inzoneName, inzoneMemberName, listName, inzoneDate;

	treeName = "PersonalConnectionsDrawerWnd.AddWnd.InzoneTreeWnd.InzoneTree";
	ROOTNAME = "root";
	if((selectTreeNodeStr != ""))
	{
		InzoneTree.SetExpandedNode(selectTreeNodeStr, false);
	}
	if((beforeSelectedTreePath != ""))
	{
		InzoneTree.SetExpandedNode(beforeSelectedTreePath, false);
	}
	InzoneTree.Clear();
	listName = "";
	inzoneName = "";
	inzoneDate = "";
	inzoneMemberName = "";
	inzoneSelectedParam = "";
	ParseInt(param, "NumberOfInzoneParty", NumberOfInzoneParty);
	util.TreeInsertRootNode(treeName, ROOTNAME, "", 0, 4);
	inzoneCount = 0;
	while((inzoneCount < NumberOfInzoneParty))
	{
		ParseInt(param, ("NumberOfPartyMember" $ string(inzoneCount)), NumberOfPartyMember);
		ParseInt(param, ("InzoneUseTimeYear" $ string(inzoneCount)), InzoneUseTimeYear);
		ParseInt(param, ("InzoneUseTimeMonth" $ string(inzoneCount)), InzoneUseTimeMonth);
		ParseInt(param, ("InzoneUseTimeDay" $ string(inzoneCount)), InzoneUseTimeDay);
		ParseInt(param, ("InzoneTypeID" $ string(inzoneCount)), InzoneTypeID);
		if((NumberOfInzoneParty > 0))
		{
			listName = ("list" $ string(inzoneCount));
			inzoneName = GetInZoneNameWithZoneID(InzoneTypeID);
			inzoneDate = (("(" $ MakeFullSystemMsg(GetSystemMessage(2203), string(InzoneUseTimeMonth), string(InzoneUseTimeDay))) $ ")");
			util.TreeInsertExpandBtnNode(treeName, listName, ROOTNAME);
			listName = ((ROOTNAME $ ".") $ listName);
			util.TreeInsertTextNodeItem(treeName, listName, inzoneName, 5, 0, COLOR_DEFAULT, true);
			util.TreeInsertTextNodeItem(treeName, listName, inzoneDate, 5, 0, COLOR_GOLD, true);
		}
		PartyMemberCount = 0;
		while((PartyMemberCount < NumberOfPartyMember))
		{
			ParseString(param, ((("Inzone" $ string(inzoneCount)) $ "_Name") $ string(PartyMemberCount)), inzoneMemberName);
			ParseInt(param, ((("Inzone" $ string(inzoneCount)) $ "_ClassID") $ string(PartyMemberCount)), InzoneClassID);
			ParseInt(param, ((("Inzone" $ string(inzoneCount)) $ "_Status") $ string(PartyMemberCount)), InzoneStatus);
			util.setCustomTooltip(getJobToolTip(InzoneClassID));
			strRetName = util.TreeInsertItemTooltipNode(treeName, ("member" $ string(PartyMemberCount)), listName, -7, 0, 20, 0, 32, 20, util.getCustomToolTip());
			inzoneSelectedParam = ((((inzoneSelectedParam $ " ") $ strRetName) $ "=") $ inzoneMemberName);
			if(((float(PartyMemberCount) % 2.0000000) == 0.0000000))
			{
				util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CH3.etc.textbackline", 257, 18, 16, 0, , , 14);
			}
			else
			{
				util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CT1.EmptyBtn", 257, 18, 16, 0, , , 14);
			}
			util.TreeInsertTextureNodeItem(treeName, strRetName, GetClassRoleIconName(InzoneClassID), 11, 11, -108, 3);
			if((InzoneStatus > 0))
			{
				util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CH3.BloodHoodWnd.BloodHood_Logon", 31, 11, 25, 3);
			}
			else
			{
				util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff", 31, 11, 25, 3);
			}
			util.TreeInsertTextNodeItem(treeName, strRetName, inzoneMemberName, -211, 2);
			PartyMemberCount++;
		}
		inzoneCount++;
	}
	return;
}

function string getUserNameByList()
{
	local LVDataRecord Record;
	local int tabindex, SelectedIndex;
	local string returnStr;

	returnStr = "";
	tabindex = AddWndTab.GetTopIndex();
	if((tabindex == 1))
	{
		SelectedIndex = ClanList.GetSelectedIndex();
		if((SelectedIndex != -1))
		{
			ClanList.GetSelectedRec(Record);
			returnStr = Record.LVDataList[0].szData;
		}
	}
	else if((tabindex == 2))
	{
	}
	else
	{
		AddSystemMessage(3314);
	}
	return returnStr;
}

function showSelectWindow(string WindowName)
{
	AddWnd.HideWindow();
	NameEnterWnd.HideWindow();
	ClanListWnd.HideWindow();
	InzoneTreeWnd.HideWindow();
	DetailInfoWnd.HideWindow();
	MenteeSearchWnd.HideWindow();
	AddListBtn.ShowWindow();
	CloseBtn.ShowWindow();
	switch(WindowName)
	{
		case "AddWnd":
			AddWnd.ShowWindow();
			AddWndTab.SetTopOrder(0, false);
			NameEnterEditbox.SetFocus();
			break;
		case "NameEnterWnd":
			NameEnterWnd.ShowWindow();
			break;
		case "ClanListWnd":
			ClanListWnd.ShowWindow();
			AddWndTab.SetTopOrder(1, false);
			break;
		case "DetailInfoWnd":
			DetailInfoWnd.ShowWindow();
			break;
		case "MenteeSearchWnd":
			MenteeSearchWnd.ShowWindow();
			AddWndTab.SetTopOrder(2, false);
			break;
		default:
			break;
	}
	switch(PersonalConnectionsWndScript.ConnectionsListSelectTab.GetTopIndex())
	{
		case 0:
		case 1:
			if(getInstanceUIData().GetIsClassicServer())
			{
				AddWndTab.InitTabCtrl();
				AddWndTab.RemoveTabControl(2);
				AddListTabBgLine.SetWindowSize(100, 24);
			}
			else
			{
				AddWndTab.SetDisable(2, true);
			}
			break;
		case 2:
			Debug(("주시 옵션 처리" @ string(PersonalConnectionsWndScript.ConnectionsListSelectTab.GetTopIndex())));  // EN?: Handle watch options
			if(getInstanceUIData().GetIsClassicServer())
			{
				AddWndTab.InitTabCtrl();
				AddWndTab.RemoveTabControl(2);
				AddListTabBgLine.SetWindowSize(100, 24);
			}
			else
			{
				AddWndTab.SetButtonName(2, GetSystemString(2784));
				AddWndTab.SetDisable(2, false);
			}
			break;
		default:
			break;
	}
	return;
}

function setDetailInfo(string Name, int Level, int ClassID, int PledgeCrestID, int AllianceCrestID, int birthMonth, int birthDay, int logoutDiffSeconds, string memo)
{
	local Texture texPledge, texAlliance;
	local string PledgeName, allianceName, classTypeStr;
	local bool bPledge, bAlliance;
	local Rect rectWnd;

	rectWnd = DetailInfoWnd.GetRect();
	GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.TargetNameText").SetText(Name);
	if((((((((Level + ClassID) + PledgeCrestID) + AllianceCrestID) + birthMonth) + birthDay) + logoutDiffSeconds) == 0))
	{
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.BlockInfoText").ShowWindow();
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.TargetStatusText").SetText(GetSystemString(2394));
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Level").SetText("");
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.job").SetText("");
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Clan").SetText("");
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Union").SetText("");
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.BirthDay").SetText("");
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.FinalConnect").SetText("");
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.LevelTitle").HideWindow();
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.JobTitle").HideWindow();
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.ClanTitle").HideWindow();
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.UnionTitle").HideWindow();
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.BirthDayTitle").HideWindow();
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.FinalConnectTitle").HideWindow();
	}
	else
	{
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.BlockInfoText").HideWindow();
		PledgeName = Class'NWindow.UIDATA_CLAN'.static.GetName(PledgeCrestID);
		allianceName = Class'NWindow.UIDATA_CLAN'.static.GetAllianceName(PledgeCrestID);
		texPledge = GetPledgeCrestTexFromPledgeCrestID(PledgeCrestID);
		texAlliance = GetAllianceCrestTexFromAllianceCrestID(AllianceCrestID);
		classTypeStr = GetClassType(ClassID);
		bPledge = Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(PledgeCrestID, texPledge);
		bAlliance = Class'NWindow.UIDATA_CLAN'.static.GetAllianceCrestTexture(PledgeCrestID, texAlliance);
		Debug(((("인맥 혈맹 마크 로드 확인 중 ------------ " @ texPledgeCrest.GetWindowName()) @ string(bPledge)) @ string(PledgeCrestID)));  // EN?: Checking network blood mark load ------------
		texPledgeCrest.SetTextureWithObject(texPledge);
		texPledgeAllianceCrest.SetTextureWithObject(texAlliance);
		texPledgeCrest.HideWindow();
		texPledgeAllianceCrest.HideWindow();
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Clan").ClearAnchor();
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Union").ClearAnchor();
		if(bPledge)
		{
			texPledgeCrest.ShowWindow();
			if(getInstanceUIData().GetIsClassicServer())
			{
				GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Clan").MoveTo((rectWnd.nX + 126), ((rectWnd.nY + 156) + 4));
			}
			else
			{
				GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Clan").MoveTo((rectWnd.nX + 118), ((rectWnd.nY + 156) + 4));
			}
		}
		else
		{
			texPledgeCrest.HideWindow();
			GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Clan").MoveTo((rectWnd.nX + 98), ((rectWnd.nY + 156) + 4));
		}
		if(bAlliance)
		{
			texPledgeAllianceCrest.ShowWindow();
			GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Union").MoveTo((rectWnd.nX + 110), ((rectWnd.nY + 178) + 4));
		}
		else
		{
			texPledgeAllianceCrest.HideWindow();
			GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Union").MoveTo((rectWnd.nX + 98), ((rectWnd.nY + 178) + 4));
		}
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Level").SetText(string(Level));
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.job").SetText(classTypeStr);
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Clan").SetText(PledgeName);
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Union").SetText(allianceName);
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.BirthDay").SetText(MakeFullSystemMsg(GetSystemMessage(2203), string(birthMonth), string(birthDay)));
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.LevelTitle").ShowWindow();
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.JobTitle").ShowWindow();
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.ClanTitle").ShowWindow();
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.UnionTitle").ShowWindow();
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.BirthDayTitle").ShowWindow();
		GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.FinalConnectTitle").ShowWindow();
		if((logoutDiffSeconds <= -1))
		{
			GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.TargetStatusText").SetText(GetSystemString(347));
			GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.FinalConnect").SetText(GetSystemString(2401));
		}
		else
		{
			GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.TargetStatusText").SetText(GetSystemString(348));
			GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.FinalConnect").SetText(getConnectInfoTimeMessage((logoutDiffSeconds / 60)));
		}
	}
	MemoContents.SetString(memo);
	return;
}

function string getConnectInfoTimeMessage(int Minute)
{
	local string returnStr;
	local int Value;

	returnStr = "";
	if((Minute < 60))
	{
		returnStr = MakeFullSystemMsg(GetSystemMessage(3294), string(Minute));
	}
	else if((Minute < (60 * 24)))
	{
		Value = (Minute / 60);
		returnStr = MakeFullSystemMsg(GetSystemMessage(3295), string(Value));
	}
	else if((Minute < ((60 * 24) * 30)))
	{
		Value = ((Minute / 60) / 24);
		returnStr = MakeFullSystemMsg(GetSystemMessage(3296), string(Value));
	}
	else if((Minute < ((60 * 24) * 365)))
	{
		Value = (((Minute / 60) / 24) / 30);
		returnStr = MakeFullSystemMsg(GetSystemMessage(3297), string(Value));
	}
	else if((Minute > ((60 * 24) * 365)))
	{
		Value = (((Minute / 60) / 24) / 30);
		returnStr = MakeFullSystemMsg(GetSystemMessage(3297), string(Value));
	}
	return returnStr;
}

function CustomTooltip getJobToolTip(int Job)
{
	local CustomTooltip m_Tooltip;

	m_Tooltip.DrawList.Length = 1;
	m_Tooltip.DrawList[0].eType = DIT_TEXT;
	m_Tooltip.DrawList[0].t_strText = ((GetSystemString(391) $ " : ") $ GetClassType(Job));
	return m_Tooltip;
}

function API_C_EX_USER_WATCHER_ADD(string sTargetName, int nTargetWorldID)
{
	local array<byte> stream;
	local UIPacket._C_EX_USER_WATCHER_ADD packet;

	packet.sTargetName = sTargetName;
	packet.nTargetWorldID = nTargetWorldID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_USER_WATCHER_ADD(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(700, stream);
	Debug((("----> Api Call : C_EX_USER_WATCHER_ADD" @ sTargetName) @ string(nTargetWorldID)));
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("PersonalConnectionsDrawerWnd").HideWindow();
	return;
}
