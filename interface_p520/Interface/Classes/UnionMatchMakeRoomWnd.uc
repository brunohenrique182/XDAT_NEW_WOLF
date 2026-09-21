class UnionMatchMakeRoomWnd extends PartyMatchWndCommon;

const MIN_MEMBER = 20;
const MAX_MEMBER = 50;
const MAX_MEMBER_ADEN = 60;

var WindowHandle Me;
var TextBoxHandle TitletoDo;
var EditBoxHandle TitleEditBox;
var ComboBoxHandle MaxMemberCountComboBox;
var EditBoxHandle MinLevelEditBox;
var EditBoxHandle MaxLevelEditBox;
var int MAKE_TYPE;
var int ROOM_NUM;
var int ROOM_ROUTING;
var int MAX_LEVEL;

function OnRegisterEvent()
{
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
	Me = GetWindowHandle("UnionMatchMakeRoomWnd");
	TitletoDo = GetTextBoxHandle("UnionMatchMakeRoomWnd.TitletoDo");
	TitleEditBox = GetEditBoxHandle("UnionMatchMakeRoomWnd.TitleEditBox");
	MaxMemberCountComboBox = GetComboBoxHandle("UnionMatchMakeRoomWnd.MaxMemberCountComboBox");
	MinLevelEditBox = GetEditBoxHandle("UnionMatchMakeRoomWnd.MinLevelEditBox");
	MaxLevelEditBox = GetEditBoxHandle("UnionMatchMakeRoomWnd.MaxLevelEditBox");
	return;
}

function Load()
{
	Clear();
	MAX_LEVEL = GetMaxLevel();
	return;
}

function OnShow()
{
	setMaxMemberComboInit();
	if((MAKE_TYPE == 1))
	{
		TitletoDo.SetText(GetSystemString(1985));
	}
	else if((MAKE_TYPE == 2))
	{
		TitletoDo.SetText(GetSystemString(1460));
	}
	return;
}

function setMaxMemberComboInit()
{
	local int i;

	MaxMemberCountComboBox.Clear();
	i = 20;
	while((i <= getMaxMember()))
	{
		MaxMemberCountComboBox.AddString(string(i));
		i = (i + 2);
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
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

function int getMaxMember()
{
	if(IsAdenServer())
	{
		return 60;
	}
	return 50;
}

function OnOKButtonClick()
{
	local int MaxMemberCount, MinLevel, MaxLevel;
	local string RoomTitle;

	MaxMemberCount = ((MaxMemberCountComboBox.GetSelectedNum() * 2) + 20);
	MaxMemberCount = Clamp(MaxMemberCount, 20, getMaxMember());
	MinLevel = Clamp(int(MinLevelEditBox.GetString()), 1, MAX_LEVEL);
	MaxLevel = Clamp(int(MaxLevelEditBox.GetString()), 1, MAX_LEVEL);
	RoomTitle = TitleEditBox.GetString();
	Class'NWindow.PartyMatchAPI'.static.RequestManageMpccRoom(ROOM_NUM, MaxMemberCount, MinLevel, MaxLevel, ROOM_ROUTING, RoomTitle);
	Clear();
	Me.HideWindow();
	return;
}

function OnCancelButtonClick()
{
	Clear();
	Me.HideWindow();
	return;
}

function SetRoomNum(int a_RoomNum)
{
	ROOM_NUM = a_RoomNum;
	return;
}

function SetTitle(string a_Title)
{
	TitleEditBox.SetString(a_Title);
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

function SetMaxMemberCount(int a_MaxMemberCount)
{
	local int idx;

	a_MaxMemberCount = Clamp(a_MaxMemberCount, 20, getMaxMember());
	idx = ((a_MaxMemberCount - 20) / 2);
	MaxMemberCountComboBox.SetSelectedNum(idx);
	return;
}

function SetRoomRouting(int a_RoomRouting)
{
	ROOM_ROUTING = a_RoomRouting;
	return;
}

function SetMakeType(int a_Type)
{
	MAKE_TYPE = a_Type;
	return;
}

function Clear()
{
	MAKE_TYPE = 0;
	ROOM_NUM = 0;
	ROOM_ROUTING = 0;
	return;
}
