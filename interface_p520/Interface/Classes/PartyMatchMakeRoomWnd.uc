class PartyMatchMakeRoomWnd extends UICommonAPI;

const MIN_PARTY_MEMBER = 2;

enum InviteStateType
{
	MAKEROOM,                       // 0
	INVITE_MAKEROOM,                // 1
	SETTINGCHANGE                   // 2
};

var InviteStateType InviteState;
var int RoomNumber;
var string InvitedName;
var EditBoxHandle MinLevelEditBox;
var EditBoxHandle MaxLevelEditBox;
var ComboBoxHandle MaxMemberCountComboBox;

function OnLoad()
{
	MinLevelEditBox = GetEditBoxHandle("PartyMatchMakeRoomWnd.MinLevelEditBox");
	MaxLevelEditBox = GetEditBoxHandle("PartyMatchMakeRoomWnd.MaxLevelEditBox");
	MaxMemberCountComboBox = GetComboBoxHandle("PartyMatchMakeRoomWnd.MaxPartyMemberCountComboBox");
	return;
}

function OnShow()
{
	switch(InviteState)
	{
		case MAKEROOM:
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PartyMatchMakeRoomWnd.TitletoDo", GetSystemString(1457));
			break;
		case INVITE_MAKEROOM:
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PartyMatchMakeRoomWnd.TitletoDo", GetSystemString(1458));
			break;
		case SETTINGCHANGE:
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PartyMatchMakeRoomWnd.TitletoDo", GetSystemString(1460));
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string a_strButtonName)
{
	switch(a_strButtonName)
	{
		case "OKButton":
			OnOKButtonClick();
			break;
		case "CancelButton":
			OnCancelButtonClick();
			break;
		default:
			break;
	}
	return;
}

function OnOKButtonClick()
{
	local int MaxPartyMemberCount, MinLevel, MaxLevel;
	local string RoomTitle;

	if(getInstanceUIData().GetIsClassicServer())
	{
		MaxLevel = getInstanceUIData().MAXLV;
	}
	else
	{
		MaxLevel = 199;
	}
	MinLevel = Clamp(int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MinLevelEditBox")), 1, MaxLevel);
	MaxLevel = Clamp(int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MaxLevelEditBox")), 1, MaxLevel);
	Class'NWindow.UIAPI_EDITBOX'.static.SetString("PartyMatchMakeRoomWnd.MinLevelEditBox", string(MinLevel));
	Class'NWindow.UIAPI_EDITBOX'.static.SetString("PartyMatchMakeRoomWnd.MaxLevelEditBox", string(MaxLevel));
	MaxLevel = getInstanceUIData().MAXLV;
	RoomTitle = Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.TitleEditBox");
	MaxPartyMemberCount = (MaxMemberCountComboBox.GetSelectedNum() + 2);
	MinLevel = Clamp(int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MinLevelEditBox")), 1, MaxLevel);
	MaxLevel = Clamp(int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MaxLevelEditBox")), 1, MaxLevel);
	Class'NWindow.PartyMatchAPI'.static.RequestManagePartyRoom(RoomNumber, MaxPartyMemberCount, MinLevel, MaxLevel, RoomTitle);
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("PartyMatchMakeRoomWnd");
	if((int(InviteState) == 1))
	{
		Debug("방 만든 뒤 초대하기 INVITE_MAKEROOM");  // EN: invite after creating the room INVITE_MAKEROOM
		Class'NWindow.PartyMatchAPI'.static.RequestAskJoinPartyRoom(InvitedName);
		InviteState = MAKEROOM;
	}
	return;
}

function OnCancelButtonClick()
{
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("PartyMatchMakeRoomWnd");
	if((int(InviteState) == 1))
	{
		InviteState = MAKEROOM;
	}
	return;
}

function InitMaxMemberCountComboBox()
{
	local int i, maxMemberCnt;

	if(getInstanceUIData().GetIsLiveServer())
	{
		maxMemberCnt = 12;
	}
	else
	{
		maxMemberCnt = int(GetPartyMemberMaxCount());
		if((maxMemberCnt == 0))
		{
			maxMemberCnt = 12;
		}
	}
	MaxMemberCountComboBox.Clear();
	i = 2;
	while((i <= maxMemberCnt))
	{
		MaxMemberCountComboBox.AddString(string(i));
		i++;
	}
	MaxMemberCountComboBox.SetSelectedNum((maxMemberCnt - 2));
	return;
}

function SetRoomNumber(int a_RoomNumber)
{
	RoomNumber = a_RoomNumber;
	return;
}

function SetTitle(string a_Title)
{
	Class'NWindow.UIAPI_EDITBOX'.static.SetString("PartyMatchMakeRoomWnd.TitleEditBox", a_Title);
	return;
}

function SetMinLevel(int a_MinLevel)
{
	MinLevelEditBox.SetString(string(a_MinLevel));
	return;
}

function SetMaxLevel(int a_MaxLevel)
{
	MaxLevelEditBox.SetString(string(a_MaxLevel));
	return;
}

function SetMaxPartyMemberCount(int a_MaxPartyMemberCount)
{
	Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("PartyMatchMakeRoomWnd.MaxPartyMemberCountComboBox", (a_MaxPartyMemberCount - 2));
	return;
}
