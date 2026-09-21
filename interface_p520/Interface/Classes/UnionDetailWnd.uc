class UnionDetailWnd extends UICommonAPI;

var int m_MasterID;
var WindowHandle Me;
var TextBoxHandle txtMasterName;
var ListCtrlHandle lstPartyMember;
var string m_Windowname;

function OnRegisterEvent()
{
	RegisterEvent(1420);
	return;
}

function OnLoad()
{
	Me = GetWindowHandle(m_Windowname);
	txtMasterName = GetTextBoxHandle((m_Windowname $ ".txtMasterName"));
	lstPartyMember = GetListCtrlHandle((m_Windowname $ ".lstPartyMember"));
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 1420))
	{
		HandleCommandChannelPartyMember(param);
	}
	return;
}

function SetMasterInfo(string masterName, int MasterID)
{
	txtMasterName.SetText(masterName);
	m_MasterID = MasterID;
	return;
}

function int GetMasterID()
{
	return m_MasterID;
}

function Clear()
{
	lstPartyMember.DeleteAllItem();
	txtMasterName.SetText("");
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnClose":
			OnCloseClick();
			break;
		default:
			break;
	}
	return;
}

function OnCloseClick()
{
	Me.HideWindow();
	return;
}

function OnDBClickListCtrlRecord(string strID)
{
	local UserInfo UserInfo;
	local LVDataRecord Record;
	local int ServerID;

	if((strID == "lstPartyMember"))
	{
		lstPartyMember.GetSelectedRec(Record);
		ServerID = int(Record.nReserved1);
		if((ServerID > 0))
		{
			if(GetPlayerInfo(UserInfo))
			{
				if(IsPKMode())
				{
					RequestAttack(ServerID, UserInfo.Loc);
				}
				else
				{
					RequestAction(ServerID, UserInfo.Loc);
				}
			}
		}
	}
	return;
}

function HandleCommandChannelPartyMember(string param)
{
	local LVDataRecord Record;
	local int idx, MemberCount;
	local string Name;
	local int ClassID, ServerID;
	local UnionWnd Script;

	lstPartyMember.DeleteAllItem();
	ParseInt(param, "MemberCount", MemberCount);
	idx = 0;
	while((idx < MemberCount))
	{
		ParseString(param, ("Name_" $ string(idx)), Name);
		ParseInt(param, ("ClassID_" $ string(idx)), ClassID);
		ParseInt(param, ("ServerID_" $ string(idx)), ServerID);
		if((Len(Name) > 0))
		{
			Record.LVDataList.Length = 2;
			Record.nReserved1 = INT64(ServerID);
			Record.LVDataList[0].szData = Name;
			Record.LVDataList[1].nTextureWidth = 11;
			Record.LVDataList[1].nTextureHeight = 11;
			Record.LVDataList[1].szData = string(ClassID);
			Record.LVDataList[1].szTexture = GetClassRoleIconName(ClassID);
			lstPartyMember.InsertRecord(Record);
		}
		idx++;
	}
	Script = UnionWnd(GetScript("UnionWnd"));
	Script.UpdatePartyMemberCount(m_MasterID, MemberCount);
	return;
}

defaultproperties
{
	m_Windowname="UnionDetailWnd"
}
