class UnionWnd extends UICommonAPI;

var bool m_bChOpened;
var WindowHandle Me;
var WindowHandle PartyMemberWnd;
var TextBoxHandle txtOwner;
var TextBoxHandle txtRoutingType;
var TextBoxHandle txtCountInfo;
var ButtonHandle banBtn;
var ButtonHandle quitBtn;
var ListCtrlHandle lstParty;
var ButtonHandle btnadenacalculate;
var string m_userName;
var int m_PartyNum;
var int m_PartyMemberNum;
var int m_SearchedMasterID;

event OnRegisterEvent()
{
	RegisterEvent(1360);
	RegisterEvent(1370);
	RegisterEvent(1380);
	RegisterEvent(1390);
	RegisterEvent(1395);
	RegisterEvent(1400);
	return;
}

event OnLoad()
{
	Me = GetWindowHandle("UnionWnd");
	setPartyMemberWnd();
	txtOwner = GetTextBoxHandle("UnionWnd.txtOwner");
	txtRoutingType = GetTextBoxHandle("UnionWnd.txtRoutingType");
	txtCountInfo = GetTextBoxHandle("UnionWnd.txtCountInfo");
	lstParty = GetListCtrlHandle("UnionWnd.lstParty");
	banBtn = GetButtonHandle("UnionWnd.btnBan");
	quitBtn = GetButtonHandle("UnionWnd.btnOut");
	btnadenacalculate = GetButtonHandle("UnionWnd.btnadenacalculate");
	m_bChOpened = false;
	m_PartyNum = 0;
	m_PartyMemberNum = 0;
	m_SearchedMasterID = 0;
	return;
}

function setPartyMemberWnd()
{
	PartyMemberWnd = getUnionDetailWnd();
	return;
}

function WindowHandle getUnionDetailWnd()
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		return GetWindowHandle("UnionDetailWndClassic");
	}
	else
	{
		return GetWindowHandle("UnionDetailWnd");
	}
}

event OnShow()
{
	local UserInfo a_UserInfo;

	setPartyMemberWnd();
	GetPlayerInfo(a_UserInfo);
	m_userName = a_UserInfo.Name;
	PartyMemberWnd.HideWindow();
	return;
}

event OnEnterState(name a_CurrentStateName)
{
	if((a_CurrentStateName == 'LoadingState'))
	{
		HandleCommandChannelEnd();
	}
	ChkAdenaDistribution();
	if(m_bChOpened)
	{
		Me.ShowWindow();
	}
	else
	{
		Me.HideWindow();
	}
	return;
}

event OnEvent(int Event_ID, string param)
{
	if((Event_ID == 1360))
	{
		HandleCommandChannelStart();
	}
	else if((Event_ID == 1370))
	{
		HandleCommandChannelEnd();
	}
	else if((Event_ID == 1380))
	{
		HandleCommandChannelInfo(param);
	}
	else if((Event_ID == 1390))
	{
		HandleCommandChannelPartyList(param);
	}
	else if((Event_ID == 1395))
	{
		HandleCommandChannelPartyUpdate(param);
	}
	else if((Event_ID == 1400))
	{
		HandleCommandChannelRoutingType(param);
	}
	return;
}

event OnDBClickListCtrlRecord(string strID)
{
	if((strID == "lstParty"))
	{
		RequestPartyMember(true);
	}
	return;
}

function Clear()
{
	MemberClear();
	txtOwner.SetText("");
	txtRoutingType.SetText(GetSystemString(1383));
	txtCountInfo.SetText("");
	return;
}

function MemberClear()
{
	lstParty.DeleteAllItem();
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnRefresh":
			OnRefreshClick();
			break;
		case "btnBan":
			OnBanClick();
			break;
		case "btnOut":
			OnOutClick();
			break;
		case "btnMemberInfo":
			OnMemberInfoClick();
			break;
		case "btnadenacalculate":
			OnAdenaDistribution();
			break;
		default:
			break;
	}
	return;
}

function ChkAdenaDistribution()
{
	if(IsAdenServer())
	{
		GetButtonHandle("UnionWnd.btnMemberInfo").SetWindowSize(156, 27);
		btnadenacalculate.HideWindow();
	}
	else
	{
		GetButtonHandle("UnionWnd.btnMemberInfo").SetWindowSize(72, 27);
		btnadenacalculate.ShowWindow();
	}
	return;
}

function OnAdenaDistribution()
{
	CallGFxFunction("AdenaDistributionWnd", "RequestDivideAdenaStart", "");
	return;
}

function OnRefreshClick()
{
	RequestNewInfo();
	return;
}

function RequestNewInfo()
{
	Class'NWindow.CommandChannelAPI'.static.RequestCommandChannelInfo();
	return;
}

function OnBanClick()
{
	local int idx;
	local LVDataRecord Record;
	local string PartyMasterName;

	idx = lstParty.GetSelectedIndex();
	if((idx > -1))
	{
		lstParty.GetRec(idx, Record);
		PartyMasterName = Record.LVDataList[0].szData;
		if((Len(PartyMasterName) > 0))
		{
			Class'NWindow.CommandChannelAPI'.static.RequestCommandChannelBanParty(PartyMasterName);
		}
	}
	return;
}

function OnOutClick()
{
	Class'NWindow.CommandChannelAPI'.static.RequestCommandChannelWithdraw();
	return;
}

function OnMemberInfoClick()
{
	if(PartyMemberWnd.IsShowWindow())
	{
		PartyMemberWnd.HideWindow();
	}
	else
	{
		RequestPartyMember(true);
	}
	return;
}

function RequestPartyMember(bool bShowWindow)
{
	local LVDataRecord Record;
	local string PartyMasterName;
	local int MasterID;
	local UnionDetailWnd Script;
	local UnionDetailWndClassic scriptClassic;

	Script = UnionDetailWnd(GetScript("UnionDetailWnd"));
	scriptClassic = UnionDetailWndClassic(GetScript("UnionDetailWndClassic"));
	m_SearchedMasterID = 0;
	lstParty.GetSelectedRec(Record);
	PartyMasterName = Record.LVDataList[0].szData;
	MasterID = int(Record.nReserved1);
	if(((Len(PartyMasterName) > 0) && (MasterID > 0)))
	{
		if(bShowWindow)
		{
			if(!PartyMemberWnd.IsShowWindow())
			{
				PartyMemberWnd.ShowWindow();
			}
		}
		m_SearchedMasterID = MasterID;
		Script.SetMasterInfo(PartyMasterName, MasterID);
		scriptClassic.SetMasterInfo(PartyMasterName, MasterID);
		Class'NWindow.CommandChannelAPI'.static.RequestCommandChannelPartyMembersInfo(MasterID);
	}
	return;
}

function HandleCommandChannelStart()
{
	Me.ShowWindow();
	Me.SetFocus();
	m_bChOpened = true;
	RequestNewInfo();
	if(!IsPlayerOnWorldRaidAdenServer())
	{
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("UnionWnd.btnBan");
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("UnionWnd.btnOut");
	}
	Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("UnionWnd.btnadenacalculate");
	return;
}

function HandleCommandChannelEnd()
{
	Me.HideWindow();
	Clear();
	m_bChOpened = false;
	return;
}

function HandleCommandChannelInfo(string param)
{
	local string OwnerName;
	local int RoutingType, PartyNum, PartyMemberNum;
	local string OwnerDisplayName;

	MemberClear();
	ParseString(param, "OwnerName", OwnerName);
	ParseInt(param, "RoutingType", RoutingType);
	ParseInt(param, "PartyNum", PartyNum);
	ParseInt(param, "PartyMemberNum", PartyMemberNum);
	m_PartyNum = PartyNum;
	m_PartyMemberNum = PartyMemberNum;
	OwnerDisplayName = OwnerName;
	Class'Interface.L2Util'.static.GetEllipsisString(OwnerDisplayName, 134);
	txtOwner.SetText(OwnerDisplayName);
	txtOwner.SetTooltipCustomType(MakeTooltipSimpleText(OwnerName));
	UpdateRoutingType(RoutingType);
	UpdateCountInfo();
	if((OwnerName == m_userName))
	{
		Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("UnionWnd.btnBan");
		Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("UnionWnd.btnadenacalculate");
	}
	else
	{
		if(!IsPlayerOnWorldRaidAdenServer())
		{
			Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("UnionWnd.btnBan");
		}
		Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("UnionWnd.btnadenacalculate");
	}
	return;
}

function HandleCommandChannelPartyList(string param)
{
	local LVDataRecord Record;
	local string masterName;
	local int MasterID, PartyNum, totalCount;

	ParseString(param, "MasterName", masterName);
	ParseInt(param, "MasterID", MasterID);
	ParseInt(param, "PartyNum", PartyNum);
	Record.LVDataList.Length = 2;
	Record.nReserved1 = INT64(MasterID);
	Record.LVDataList[0].szData = masterName;
	Record.LVDataList[1].szData = string(PartyNum);
	lstParty.InsertRecord(Record);
	if(((m_SearchedMasterID > 0) && (m_SearchedMasterID == MasterID)))
	{
		if(PartyMemberWnd.IsShowWindow())
		{
			totalCount = lstParty.GetRecordCount();
			if((totalCount > 0))
			{
				lstParty.SetSelectedIndex((totalCount - 1), false);
			}
			RequestPartyMember(false);
		}
	}
	if((masterName == m_userName))
	{
		Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("UnionWnd.btnOut");
	}
	return;
}

function HandleCommandChannelPartyUpdate(string param)
{
	local LVDataRecord Record;
	local int SearchIdx;
	local string masterName;
	local int MasterID, MemberCount, Type;
	local UnionDetailWnd Script;
	local UnionDetailWndClassic scriptClassic;

	ParseString(param, "MasterName", masterName);
	ParseInt(param, "MasterID", MasterID);
	ParseInt(param, "MemberCount", MemberCount);
	ParseInt(param, "Type", Type);
	if((MasterID < 1))
	{
		return;
	}
	switch(Type)
	{
		case 0:
			SearchIdx = FindMasterID(MasterID);
			if((SearchIdx > -1))
			{
				lstParty.GetRec(SearchIdx, Record);
				MemberCount = int(Record.LVDataList[1].szData);
				lstParty.DeleteRecord(SearchIdx);
				m_PartyNum--;
				m_PartyMemberNum = (m_PartyMemberNum - MemberCount);
				if(PartyMemberWnd.IsShowWindow())
				{
					Script = UnionDetailWnd(GetScript("UnionDetailWnd"));
					scriptClassic = UnionDetailWndClassic(GetScript("UnionDetailWndClassic"));
					if((MasterID == Script.GetMasterID()))
					{
						Script.Clear();
						scriptClassic.Clear();
						PartyMemberWnd.HideWindow();
					}
				}
			}
			break;
		case 1:
			Record.LVDataList.Length = 2;
			Record.nReserved1 = INT64(MasterID);
			Record.LVDataList[0].szData = masterName;
			Record.LVDataList[1].szData = string(MemberCount);
			lstParty.InsertRecord(Record);
			m_PartyNum++;
			m_PartyMemberNum = (m_PartyMemberNum + MemberCount);
			break;
		default:
			break;
	}
	UpdateCountInfo();
	if((masterName == m_userName))
	{
		Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("UnionWnd.btnOut");
	}
	return;
}

function HandleCommandChannelRoutingType(string param)
{
	local int RoutingType;

	ParseInt(param, "RoutingType", RoutingType);
	UpdateRoutingType(RoutingType);
	return;
}

function UpdateRoutingType(int Type)
{
	if((Type == 0))
	{
		txtRoutingType.SetText(GetSystemString(1383));
	}
	else if((Type == 1))
	{
		txtRoutingType.SetText(GetSystemString(1384));
	}
	return;
}

function int FindMasterID(int MasterID)
{
	local int idx;
	local LVDataRecord Record;
	local int SearchIdx;

	SearchIdx = -1;
	idx = 0;
	while((idx < lstParty.GetRecordCount()))
	{
		lstParty.GetRec(idx, Record);
		if((int(Record.nReserved1) == MasterID))
		{
			SearchIdx = idx;
			break;
		}
		idx++;
	}
	return SearchIdx;
}

function UpdateCountInfo()
{
	txtCountInfo.SetText(((((string(m_PartyNum) $ GetSystemString(440)) $ " / ") $ string(m_PartyMemberNum)) $ GetSystemString(1013)));
	return;
}

function UpdatePartyMemberCount(int MasterID, int MemberCount)
{
	local int idx;
	local LVDataRecord Record;

	idx = FindMasterID(MasterID);
	if((idx > -1))
	{
		lstParty.GetRec(idx, Record);
		m_PartyMemberNum = (m_PartyMemberNum - int(Record.LVDataList[1].szData));
		m_PartyMemberNum = (m_PartyMemberNum + MemberCount);
		Record.LVDataList[1].szData = string(MemberCount);
		lstParty.ModifyRecord(idx, Record);
	}
	UpdateCountInfo();
	return;
}

function bool IsPlayerOnWorldRaidAdenServer()
{
	return (IsPlayerOnWorldRaidServer() && IsAdenServer());
}
