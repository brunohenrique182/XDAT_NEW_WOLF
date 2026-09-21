class InviteClanPopWnd extends UICommonAPI;

const SHOW_TYPE_ClanWnd = 1;
const SHOW_TYPE_PersonalConnectionsWnd = 2;
const SHOW_TYPE_PersonalConnectionsWndByUserName = 3;

var string m_userName;
var array<int> m_knighthoodIndex;
var int ShowType;
var WindowHandle Me;
var int friendServerID;
var int friendClanType;
var string TargetUserName;

function OnRegisterEvent()
{
	RegisterEvent(160);
	return;
}

function OnLoad()
{
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	Me = GetWindowHandle("InviteClanPopWnd");
	m_knighthoodIndex.Length = 8;
	m_knighthoodIndex[0] = 0;
	m_knighthoodIndex[1] = 100;
	m_knighthoodIndex[2] = 200;
	m_knighthoodIndex[3] = 1001;
	m_knighthoodIndex[4] = 1002;
	m_knighthoodIndex[5] = 2001;
	m_knighthoodIndex[6] = 2002;
	m_knighthoodIndex[7] = -1;
	return;
}

function OnShow()
{
	return;
}

function showByClanWnd()
{
	Me.ShowWindow();
	ShowType = 1;
	InitializeComboBox();
	return;
}

function showByPersonalConnectionsWnd(int ServerID)
{
	Me.ShowWindow();
	ShowType = 2;
	friendServerID = ServerID;
	InitializeComboBox();
	return;
}

function showByPersonalConnectionsWndUsingUserName(string UserName)
{
	Me.ShowWindow();
	ShowType = 3;
	TargetUserName = UserName;
	InitializeComboBox();
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 160:
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("InviteClanPopWnd");
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string strID)
{
	if((strID == "InviteClandPopOkBtn"))
	{
		if((ShowType == 2))
		{
			AskJoinByPersonalConnectionsWnd();
		}
		else if((ShowType == 3))
		{
			AskJoinByPersonalConnectionsWndByUserName();
		}
		else
		{
			askJoin();
		}
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("InviteClanPopWnd");
	}
	else if((strID == "InviteClandPopCancelBtn"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("InviteClanPopWnd");
	}
	return;
}

function askJoin()
{
	local UserInfo User;
	local int Index, knighthoodID;

	if(GetTargetInfo(User))
	{
		if((User.nID > 0))
		{
			Index = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum("InviteClanPopWnd.ComboboxInviteClandPopWnd");
			if((Index >= 0))
			{
				knighthoodID = Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved("InviteClanPopWnd.ComboboxInviteClandPopWnd", Index);
				RequestClanAskJoin(User.nID, knighthoodID);
			}
		}
	}
	return;
}

function AskJoinByPersonalConnectionsWnd()
{
	local int Index, knighthoodID;

	if((friendServerID > 0))
	{
		Index = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum("InviteClanPopWnd.ComboboxInviteClandPopWnd");
		if((Index >= 0))
		{
			knighthoodID = Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved("InviteClanPopWnd.ComboboxInviteClandPopWnd", Index);
			RequestClanAskJoin(friendServerID, knighthoodID);
		}
	}
	return;
}

function AskJoinByPersonalConnectionsWndByUserName()
{
	local int Index, knighthoodID;

	Index = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum("InviteClanPopWnd.ComboboxInviteClandPopWnd");
	if((Index >= 0))
	{
		knighthoodID = Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved("InviteClanPopWnd.ComboboxInviteClandPopWnd", Index);
		RequestClanAskJoinByName(TargetUserName, knighthoodID);
	}
	return;
}

function InitializeComboBox()
{
	local int i;
	local ClanWndClassicNew Script;
	local int addedCount;
	local string countnum, countnum2;
	local int cnt1, cnt2;
	local string m_sName;

	Class'NWindow.UIAPI_COMBOBOX'.static.Clear("InviteClanPopWnd.ComboboxInviteClandPopWnd");
	Script = ClanWndClassicNew(GetScript("ClanWndClassicNew"));
	countnum2 = ("" $ string(Script.m_myClanType));
	cnt1 = Len(countnum2);
	i = 0;
	while((i < 8))
	{
		countnum = ("" $ string(m_knighthoodIndex[i]));
		m_sName = Script.m_memberList[i].m_sName;
		cnt2 = Len(countnum);
		if((m_sName != ""))
		{
			if((m_knighthoodIndex[i] == -1))
			{
				Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved("InviteClanPopWnd.ComboboxInviteClandPopWnd", m_sName, m_knighthoodIndex[i]);
				++addedCount;
				++i;
				continue;
			}
			if((cnt1 <= cnt2))
			{
				Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved("InviteClanPopWnd.ComboboxInviteClandPopWnd", m_sName, m_knighthoodIndex[i]);
				++addedCount;
			}
		}
		++i;
	}
	if((addedCount > 0))
	{
		Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("InviteClanPopWnd.ComboboxInviteClandPopWnd", 0);
	}
	return;
}
