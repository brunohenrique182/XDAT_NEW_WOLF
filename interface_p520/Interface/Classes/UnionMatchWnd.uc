class UnionMatchWnd extends PartyMatchWndCommon;

const ROOMMASTER = 1;
const UNIONLEADER = 3;
const UNIONPARTY = 4;
const WAITPARTY = 5;
const WAITNORMAL = 6;

var WindowHandle Me;
var ListCtrlHandle lstMember;
var TextBoxHandle lblNum;
var TextBoxHandle txtNum;
var TextBoxHandle lblTitle;
var TextBoxHandle txtTitle;
var TextBoxHandle lblMethod;
var TextBoxHandle txtMethod;
var TextBoxHandle lblMemberCount;
var TextBoxHandle txtMemberCount;
var TextBoxHandle lblLevelLimit;
var TextBoxHandle txtLevelLimit;
var TextListBoxHandle tlstChat;
var EditBoxHandle edChat;
var ButtonHandle btnRoomInfo;
var ButtonHandle btnUnionInfo;
var ButtonHandle btnBan;
var ButtonHandle btnInviteParty;
var ButtonHandle btnInviteUnion;
var ButtonHandle btnExit;
var TextureHandle txListTitleBg;
var TextureHandle txTitleBg;
var TextureHandle txListBg;
var TextureHandle txChatBg;
var TextBoxHandle lblListTitle;
var WindowHandle UnionMatchDrawerWnd;
var WindowHandle UnionMatchMakeRoomWnd;
var WindowHandle PartyMatchWnd;
var WindowHandle m_UnionWnd;
var string ROOM_NAME;
var int ROOM_TYPE;
var int ROOM_NUM;
var int ROOM_MINLEVEL;
var int ROOM_MAXLEVEL;
var int ROOM_ROUTING;
var int MYID;
var int MYTYPE;
var int CURMEMBER_COUNT;
var int MAXMEMBER_COUNT;
var bool I_REQUEST_EXIT;
var int m_MasterID;

function OnRegisterEvent()
{
	RegisterEvent(1710);
	RegisterEvent(4000);
	RegisterEvent(4030);
	RegisterEvent(4040);
	RegisterEvent(4050);
	RegisterEvent(4060);
	RegisterEvent(4070);
	RegisterEvent(1170);
	RegisterEvent(1140);
	RegisterEvent(1160);
	return;
}

function OnLoad()
{
	Initialize();
	Load();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("UnionMatchWnd");
	lstMember = GetListCtrlHandle("UnionMatchWnd.lstMember");
	lblNum = GetTextBoxHandle("UnionMatchWnd.lblNum");
	txtNum = GetTextBoxHandle("UnionMatchWnd.txtNum");
	lblTitle = GetTextBoxHandle("UnionMatchWnd.lblTitle");
	txtTitle = GetTextBoxHandle("UnionMatchWnd.txtTitle");
	lblMethod = GetTextBoxHandle("UnionMatchWnd.lblMethod");
	txtMethod = GetTextBoxHandle("UnionMatchWnd.txtMethod");
	lblMemberCount = GetTextBoxHandle("UnionMatchWnd.lblMemberCount");
	txtMemberCount = GetTextBoxHandle("UnionMatchWnd.txtMemberCount");
	lblLevelLimit = GetTextBoxHandle("UnionMatchWnd.lblLevelLimit");
	txtLevelLimit = GetTextBoxHandle("UnionMatchWnd.txtLevelLimit");
	tlstChat = GetTextListBoxHandle("UnionMatchWnd.tlstChat");
	edChat = GetEditBoxHandle("UnionMatchWnd.edChat");
	btnRoomInfo = GetButtonHandle("UnionMatchWnd.btnRoomInfo");
	btnUnionInfo = GetButtonHandle("UnionMatchWnd.btnUnionInfo");
	btnBan = GetButtonHandle("UnionMatchWnd.btnBan");
	btnInviteParty = GetButtonHandle("UnionMatchWnd.btnInviteParty");
	btnInviteUnion = GetButtonHandle("UnionMatchWnd.btnInviteUnion");
	btnExit = GetButtonHandle("UnionMatchWnd.btnExit");
	txListTitleBg = GetTextureHandle("UnionMatchWnd.txListTitleBg");
	txTitleBg = GetTextureHandle("UnionMatchWnd.txTitleBg");
	txListBg = GetTextureHandle("UnionMatchWnd.txListBg");
	txChatBg = GetTextureHandle("UnionMatchWnd.txChatBg");
	lblListTitle = GetTextBoxHandle("UnionMatchWnd.lblListTitle");
	m_UnionWnd = GetWindowHandle("UnionWnd");
	UnionMatchDrawerWnd = GetWindowHandle("UnionMatchDrawerWnd");
	UnionMatchMakeRoomWnd = GetWindowHandle("UnionMatchMakeRoomWnd");
	PartyMatchWnd = GetWindowHandle("PartyMatchWnd");
	return;
}

function Load()
{
	CURMEMBER_COUNT = 0;
	I_REQUEST_EXIT = false;
	return;
}

function OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case 4000:
			HandleMpccRoomInfo(param);
			break;
		case 4030:
			HandleDismissMpccRoom(param);
			break;
		case 4040:
			HandleManageMpccRoomMember(param);
			break;
		case 4050:
			HandleMpccRoomMemberStart(param);
			break;
		case 4060:
			HandleMpccRoomMemberInfo(param);
			break;
		case 4070:
			HandleMpccRoomChatMessage(param);
			break;
		case 1160:
			Class'NWindow.PartyMatchAPI'.static.RequestDismissMpccRoom();
			Me.HideWindow();
			break;
		case 1170:
			Class'NWindow.PartyMatchAPI'.static.RequestDismissMpccRoom();
			Me.HideWindow();
			break;
		case 1710:
			if(DialogIsMine())
			{
				if((DialogGetID() == 1))
				{
					Class'NWindow.PartyMatchAPI'.static.RequestDismissMpccRoom();
					Me.HideWindow();
				}
			}
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
		case "btnRoomInfo":
			OnbtnRoomInfoClick();
			break;
		case "btnUnionInfo":
			OnbtnUnionInfoClick();
			break;
		case "btnBan":
			OnbtnBanClick();
			break;
		case "btnInviteParty":
			OnbtnInvitePartyClick();
			break;
		case "btnInviteUnion":
			OnbtnInviteUnionClick();
			break;
		case "btnExit":
			OnbtnExitClick();
			break;
		default:
			break;
	}
	return;
}

function OnShow()
{
	if(UnionMatchDrawerWnd.IsShowWindow())
	{
		Class'NWindow.PartyMatchAPI'.static.RequestMpccPartymasterList();
	}
	if(m_UnionWnd.IsShowWindow())
	{
		Class'NWindow.PartyMatchAPI'.static.RequestMpccPartymasterList();
	}
	return;
}

function OnCompleteEditBox(string strID)
{
	local string ChatMsg;

	if((strID == "edChat"))
	{
		ChatMsg = edChat.GetString();
		ProcessPartyMatchChatMessage(SPT_MPCC_ROOM_CHAT, ChatMsg);
		edChat.SetString("");
	}
	return;
}

function OnbtnRoomInfoClick()
{
	local UnionMatchMakeRoomWnd Script;

	Script = UnionMatchMakeRoomWnd(GetScript("UnionMatchMakeRoomWnd"));
	if((Script != none))
	{
		Script.SetMakeType(2);
		Script.SetRoomNum(ROOM_NUM);
		Script.SetTitle(ROOM_NAME);
		Script.SetMaxMemberCount(MAXMEMBER_COUNT);
		Script.SetMinLevel(ROOM_MINLEVEL);
		Script.SetMaxLevel(ROOM_MAXLEVEL);
		Script.SetRoomRouting(ROOM_ROUTING);
	}
	UnionMatchMakeRoomWnd.ShowWindow();
	UnionMatchMakeRoomWnd.SetFocus();
	return;
}

function OnbtnUnionInfoClick()
{
	if(!UnionMatchDrawerWnd.IsShowWindow())
	{
		UnionMatchDrawerWnd.ShowWindow();
		Class'NWindow.PartyMatchAPI'.static.RequestMpccPartymasterList();
	}
	else
	{
		UnionMatchDrawerWnd.HideWindow();
	}
	return;
}

function OnbtnBanClick()
{
	local int idx;
	local LVDataRecord Record;

	idx = lstMember.GetSelectedIndex();
	if((idx < 0))
	{
		return;
	}
	lstMember.GetRec(idx, Record);
	Class'NWindow.PartyMatchAPI'.static.RequestOustFromMpccRoom(Record.LVDataList[0].nReserved1);
	return;
}

function OnbtnInvitePartyClick()
{
	local int idx;
	local LVDataRecord Record;

	idx = lstMember.GetSelectedIndex();
	if((idx < 0))
	{
		return;
	}
	lstMember.GetRec(idx, Record);
	if((Record.LVDataList[3].nReserved1 == 6))
	{
		RequestInviteParty(Record.LVDataList[0].szData);
	}
	return;
}

function OnbtnInviteUnionClick()
{
	local int idx;
	local LVDataRecord Record;

	idx = lstMember.GetSelectedIndex();
	if((idx < 0))
	{
		return;
	}
	lstMember.GetRec(idx, Record);
	if((Record.LVDataList[3].nReserved1 == 5))
	{
		RequestInviteMpcc(Record.LVDataList[0].szData);
	}
	return;
}

function OnbtnExitClick()
{
	switch(MYTYPE)
	{
		case 1:
		case 3:
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(2993));
			DialogSetID(1);
			break;
		case 4:
			Me.HideWindow();
			break;
		case 5:
		case 6:
			Class'NWindow.PartyMatchAPI'.static.RequestWithdrawMpccRoom();
			I_REQUEST_EXIT = true;
			break;
		default:
			break;
	}
	return;
}

function HandleMpccRoomInfo(string param)
{
	local Rect rectWnd;
	local L2Util util;

	util = L2Util(GetScript("L2Util"));
	ParseInt(param, "RoomNum", ROOM_NUM);
	ParseInt(param, "MaxMemberLimit", MAXMEMBER_COUNT);
	ParseInt(param, "MinLevelLimit", ROOM_MINLEVEL);
	ParseInt(param, "MaxLevelLimit", ROOM_MAXLEVEL);
	ParseInt(param, "PartyRouting", ROOM_ROUTING);
	ParseString(param, "Title", ROOM_NAME);
	if(PartyMatchWnd.IsShowWindow())
	{
		PartyMatchWnd.HideWindow();
	}
	rectWnd = PartyMatchWnd.GetRect();
	Me.MoveTo(rectWnd.nX, rectWnd.nY);
	Me.ShowWindow();
	Me.SetFocus();
	txtNum.SetText(string(ROOM_NUM));
	txtTitle.SetText(ROOM_NAME);
	txtMethod.SetText(util.getLootingString(ROOM_ROUTING));
	txtLevelLimit.SetText(((string(ROOM_MINLEVEL) $ "-") $ string(ROOM_MAXLEVEL)));
	tlstChat.Clear();
	return;
}

function HandleMpccRoomChatMessage(string param)
{
	local Color ChatColor;
	local string chatMessage;
	local int tmpType;

	ParseInt(param, "SayType", tmpType);
	ParseString(param, "Msg", chatMessage);
	ChatColor = GetChatColorByType(tmpType);
	tlstChat.AddString(chatMessage, ChatColor);
	if(Me.IsMinimizedWindow())
	{
		PlaySound("ItemSound3.Sys_party_matching");
	}
	NotifyMe();
	return;
}

function HandleDismissMpccRoom(string param)
{
	local Rect rectWnd;

	if(Me.IsShowWindow())
	{
		Me.HideWindow();
		rectWnd = Me.GetRect();
		PartyMatchWnd.MoveTo(rectWnd.nX, rectWnd.nY);
	}
	if((I_REQUEST_EXIT == false))
	{
		return;
	}
	switch(MYTYPE)
	{
		case 5:
		case 6:
			PartyMatchWnd.ShowWindow();
			PartyMatchWnd.SetFocus();
			break;
		default:
			break;
	}
	I_REQUEST_EXIT = false;
	return;
}

function HandleMpccRoomMemberStart(string param)
{
	local Rect rectWnd;
	local UserInfo myInfo;

	MYID = 0;
	MYTYPE = 0;
	if(GetPlayerInfo(myInfo))
	{
		MYID = myInfo.nID;
	}
	CURMEMBER_COUNT = 0;
	lstMember.DeleteAllItem();
	ParseInt(param, "MyPartyRoomStatus", ROOM_TYPE);
	UpdateInfoButton();
	UpdateRelationButton();
	if(!Me.IsShowWindow())
	{
		rectWnd = PartyMatchWnd.GetRect();
		Me.MoveTo(rectWnd.nX, rectWnd.nY);
		Me.ShowWindow();
		Me.SetFocus();
	}
	else
	{
		NotifyMe();
	}
	return;
}

function HandleMpccRoomMemberInfo(string param)
{
	local int Id;
	local string Name;
	local int Level, ClassID, partyRoomStatus;

	ParseInt(param, "ID", Id);
	ParseString(param, "Name", Name);
	ParseInt(param, "Level", Level);
	ParseInt(param, "ClassID", ClassID);
	ParseInt(param, "partyRoomStatus", partyRoomStatus);
	AddMember(Id, Name, ClassID, Level, partyRoomStatus);
	return;
}

function HandleManageMpccRoomMember(string param)
{
	local int Type, Id;
	local string Name;
	local int Level, ClassID, partyRoomStatus;

	ParseInt(param, "Type", Type);
	ParseInt(param, "ID", Id);
	switch(Type)
	{
		case 0:
			ParseString(param, "Name", Name);
			ParseInt(param, "Level", Level);
			ParseInt(param, "ClassID", ClassID);
			ParseInt(param, "partyRoomStatus", partyRoomStatus);
			AddMember(Id, Name, ClassID, Level, partyRoomStatus);
			break;
		case 1:
			ParseString(param, "Name", Name);
			ParseInt(param, "Level", Level);
			ParseInt(param, "ClassID", ClassID);
			ParseInt(param, "partyRoomStatus", partyRoomStatus);
			ModifyMember(Id, Name, ClassID, Level, partyRoomStatus);
			break;
		case 2:
			RemoveMember(Id);
			break;
		default:
			break;
	}
	NotifyMe();
	return;
}

function UpdateMemberCount()
{
	txtMemberCount.SetText(((string(CURMEMBER_COUNT) $ "/") $ string(MAXMEMBER_COUNT)));
	return;
}

function UpdateInfoButton()
{
	switch(ROOM_TYPE)
	{
		case 1:
		case 3:
			btnRoomInfo.EnableWindow();
			break;
		case 4:
		case 6:
		case 5:
			btnRoomInfo.DisableWindow();
			break;
		default:
			break;
	}
	return;
}

function UpdateRelationButton()
{
	local int idx;
	local LVDataRecord Record;

	btnBan.DisableWindow();
	btnInviteParty.DisableWindow();
	btnInviteUnion.DisableWindow();
	if((ROOM_TYPE == 6))
	{
		return;
	}
	idx = lstMember.GetSelectedIndex();
	if((idx < 0))
	{
		return;
	}
	if((idx == lstMember.GetRecordCount()))
	{
		return;
	}
	lstMember.GetRec(idx, Record);
	if((Record.LVDataList[3].nReserved1 == 5))
	{
		if(isMaster())
		{
			btnBan.EnableWindow();
			btnInviteUnion.EnableWindow();
		}
	}
	else if((Record.LVDataList[3].nReserved1 == 6))
	{
		if(isMaster())
		{
			btnBan.EnableWindow();
		}
		btnInviteParty.EnableWindow();
	}
	return;
}

function bool isMaster()
{
	if(((ROOM_TYPE == 3) || (ROOM_TYPE == 1)))
	{
		return true;
	}
	return false;
}

function NotifyMe()
{
	if(Me.IsMinimizedWindow())
	{
		Me.NotifyAlarm();
	}
	return;
}

function AddMember(int a_ID, string a_name, int a_ClassID, int a_Level, int a_partyRoomStatus)
{
	local int idx;
	local LVDataRecord Record;

	idx = FindMember(a_ID);
	if((idx > -1))
	{
		return;
	}
	Record = makeRecord(a_ID, a_name, a_ClassID, a_Level, a_partyRoomStatus);
	lstMember.InsertRecord(Record);
	CURMEMBER_COUNT++;
	UpdateMemberCount();
	if((a_ID == MYID))
	{
		MYTYPE = a_partyRoomStatus;
	}
	return;
}

function RemoveMember(int a_ID)
{
	local int idx;

	idx = FindMember(a_ID);
	if((idx < 0))
	{
		return;
	}
	lstMember.DeleteRecord(idx);
	CURMEMBER_COUNT--;
	UpdateMemberCount();
	UpdateRelationButton();
	return;
}

function ModifyMember(int a_ID, string a_name, int a_ClassID, int a_Level, int a_partyRoomStatus)
{
	local int idx;
	local LVDataRecord Record;

	idx = FindMember(a_ID);
	if((idx < 0))
	{
		return;
	}
	Record = makeRecord(a_ID, a_name, a_ClassID, a_Level, a_partyRoomStatus);
	lstMember.ModifyRecord(idx, Record);
	if((a_ID == MYID))
	{
		MYTYPE = a_partyRoomStatus;
	}
	UpdateRelationButton();
	return;
}

function int FindMember(int a_ID)
{
	local int i, RecordCount;
	local LVDataRecord Record;

	RecordCount = lstMember.GetRecordCount();
	i = 0;
	while((i < RecordCount))
	{
		lstMember.GetRec(i, Record);
		if((Record.LVDataList[0].nReserved1 == a_ID))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function LVDataRecord makeRecord(int a_ID, string a_name, int a_ClassID, int a_Level, int a_partyRoomStatus)
{
	local LVDataRecord Record;

	Record.LVDataList.Length = 5;
	Record.LVDataList[0].szData = a_name;
	Record.LVDataList[0].nReserved1 = a_ID;
	Record.LVDataList[1].szData = string(a_ClassID);
	Record.LVDataList[1].szTexture = GetClassRoleIconName(a_ClassID);
	Record.LVDataList[1].nTextureWidth = 11;
	Record.LVDataList[1].nTextureHeight = 11;
	Record.LVDataList[2].szData = GetAmbiguousLevelString(a_Level, true);
	switch(a_partyRoomStatus)
	{
		case 1:
		case 3:
			Record.LVDataList[3].szData = GetSystemString(2217);
			break;
		case 4:
			Record.LVDataList[3].szData = GetSystemString(2218);
			break;
		case 5:
			Record.LVDataList[3].szData = GetSystemString(2219);
			break;
		case 6:
			Record.LVDataList[3].szData = GetSystemString(2220);
			break;
		default:
			break;
	}
	Record.LVDataList[3].nReserved1 = a_partyRoomStatus;
	return Record;
}

function OnClickListCtrlRecord(string Id)
{
	if((Id == "lstMember"))
	{
		UpdateRelationButton();
	}
	return;
}
