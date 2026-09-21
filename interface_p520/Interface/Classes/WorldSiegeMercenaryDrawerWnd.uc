class WorldSiegeMercenaryDrawerWnd extends UICommonAPI
	dependson(UIPacket);

const TIME_ID = 1;
const TIME_REFRESH = 5000;
const TIMER_ENTRYID = 2;
const TIMER_ENTRYREFRESH = 5000;

var RichListCtrlHandle SiegeMercenaryEntry_List;
var TextBoxHandle SiegeMercenaryPledgeName_Txt;
var TextBoxHandle SiegeMercenaryUserName;
var TextBoxHandle SiegeMercenaryEntryNum01_Txt;
var TextBoxHandle SiegeMercenaryEntryNum02_Txt;
var TabHandle SiegeMercenaryTabCtrl;
var ButtonHandle SiegeMercenaryEntry_Btn;
var ButtonHandle SiegeMercenaryRefresh_Btn;
var TextureHandle SiegeMercenaryPledge_Tex;
var TextureHandle SiegeMercenaryPledgeCrest_Tex;
var WindowHandle SiegeMercenaryConfirmWnd;
var TextBoxHandle txtSiegeMercenaryConfirmDesc_Txt;
var TextBoxHandle SiegeMercenaryEntryCastle_Txt;
var bool IsMe;
var int m_PlayerClanID;
var int currentClanID;

static function WorldSiegeMercenaryDrawerWnd Inst()
{
	return WorldSiegeMercenaryDrawerWnd(GetScript("WorldSiegeMercenaryDrawerWnd"));
}

function Initialize()
{
	SiegeMercenaryEntry_List = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryEntry_List"));
	SiegeMercenaryPledgeName_Txt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryPledgeName_Txt"));
	SiegeMercenaryUserName = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryUserName"));
	SiegeMercenaryEntryNum01_Txt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryEntryNum01_Txt"));
	SiegeMercenaryEntryNum02_Txt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryEntryNum02_Txt"));
	SiegeMercenaryEntry_Btn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryEntry_Btn"));
	SiegeMercenaryRefresh_Btn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryRefresh_Btn"));
	SiegeMercenaryPledge_Tex = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryPledge_Tex"));
	SiegeMercenaryPledgeCrest_Tex = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryPledgeCrest_Tex"));
	SiegeMercenaryConfirmWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryConfirmWnd"));
	txtSiegeMercenaryConfirmDesc_Txt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryConfirmWnd.SiegeMercenaryConfirmDesc_Txt"));
	SiegeMercenaryEntryCastle_Txt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryEntryCastle_Txt"));
	SiegeMercenaryEntryNum02_Txt.SetText("/100");
	return;
}

event OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 1:
			m_hOwnerWnd.KillTimer(TimerID);
			SiegeMercenaryRefresh_Btn.EnableWindow();
			break;
		case 2:
			m_hOwnerWnd.KillTimer(TimerID);
			SiegeMercenaryEntry_Btn.EnableWindow();
		default:
			break;
	}
	return;
}

event OnRegisterEvent()
{
	RegisterEvent((100000 + 971));
	RegisterEvent((100000 + 972));
	return;
}

event OnLoad()
{
	Initialize();
	SetClosingOnESC();
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case (100000 + 971):
			Handle_S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST();
			break;
		case (100000 + 972):
			Handle_S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN();
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	m_hOwnerWnd.SetFocus();
	SiegeMercenaryConfirmWnd.HideWindow();
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "SiegeMercenaryClose_Btn":
			m_hOwnerWnd.HideWindow();
			break;
		case "SiegeMercenaryRefresh_Btn":
			HandleOnClickRefresh();
			break;
		case "SiegeMercenaryEntry_Btn":
			HandleOnCLickEntryBtn();
			break;
		case "SiegeMercenaryConfirmOk_Btn":
			HandleOnCLickConfirmBtn();
			break;
		case "SiegeMercenaryConfirmCancle_Btn":
			SiegeMercenaryConfirmWnd.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function SetSiegeMercenary(int clanID, string ClanName, string PledgeMasterName)
{
	local Texture texPledge, texAlliance;
	local bool bPledge, bAlliance;

	currentClanID = clanID;
	API_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST();
	bPledge = Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(clanID, texPledge);
	bAlliance = Class'NWindow.UIDATA_CLAN'.static.GetAllianceCrestTexture(clanID, texAlliance);
	SiegeMercenaryPledge_Tex.SetTexture("");
	SiegeMercenaryPledgeCrest_Tex.SetTexture("");
	SiegeMercenaryEntryCastle_Txt.SetText(((GetSystemString(13203) @ ":") @ GetCastleName(GetCastleID())));
	if(bPledge)
	{
		SiegeMercenaryPledge_Tex.SetTextureWithObject(texPledge);
		if(bAlliance)
		{
			SiegeMercenaryPledgeCrest_Tex.SetTextureWithObject(texAlliance);
		}
	}
	SiegeMercenaryPledgeName_Txt.SetText(ClanName);
	SiegeMercenaryUserName.SetText(PledgeMasterName);
	MakeCastleMark();
	m_hOwnerWnd.ShowWindow();
	return;
}

function MakeCastleMark()
{
	local TextureHandle castleMark;

	castleMark = GetTextureCatleIcon(0);
	castleMark.ShowWindow();
	castleMark.SetTexture(getInstanceL2Util().GetCastleMinIconName(GetCastleID()));
	castleMark.SetTooltipText(GetCastleName(GetCastleID()));
	return;
}

function Handle_S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST()
{
	local int i;
	local UIPacket._S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST packet;

	Debug("Handle_S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST");
	if(!Class'Interface.UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST(packet))
	{
		return;
	}
	if((packet.nCastleID != GetCastleID()))
	{
		return;
	}
	if((packet.nPledgeSId != currentClanID))
	{
		return;
	}
	IsMe = false;
	SiegeMercenaryEntry_List.DeleteAllItem();
	i = 0;
	while((i < packet.lstWorldCastleWarMercenaryMemberList.Length))
	{
		SiegeMercenaryEntry_List.InsertRecord(MakeData(packet.lstWorldCastleWarMercenaryMemberList[i]));
		i++;
	}
	Debug("Handle_S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST -- end");
	SiegeMercenaryEntryNum01_Txt.SetText(string(SiegeMercenaryEntry_List.GetRecordCount()));
	if(IsMe)
	{
		SiegeMercenaryEntry_Btn.SetButtonName(13104);
	}
	else
	{
		SiegeMercenaryEntry_Btn.SetButtonName(13103);
	}
	Class'Interface.WorldSiegeMercenaryWnd'.static.Inst().ModifyMercenaryMemberCount(SiegeMercenaryEntry_List.GetRecordCount(), packet.nPledgeSId);
	return;
}

function Handle_S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN()
{
	local UserInfo uInfo;
	local UIPacket._S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN packet;

	Debug((("Handle_S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN step 0 - 0" @ string(packet.nResult)) @ string(packet.nMercenaryPledgeSID)));
	if(!GetPlayerInfo(uInfo))
	{
		return;
	}
	if(!Class'Interface.UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN(packet))
	{
		return;
	}
	if((packet.nResult == 0))
	{
		return;
	}
	if((packet.nMercenaryPledgeSID != currentClanID))
	{
		return;
	}
	API_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST();
	return;
}

function API_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST packet;

	packet.nCastleID = GetCastleID();
	packet.nPledgeSId = currentClanID;
	if(Class'Interface.UIPacket'.static.Encode_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST(stream, packet))
	{
		Class'Interface.UIPacket'.static.RequestUIPacket(737, stream);
	}
	return;
}

function API_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN()
{
	local UserInfo uInfo;
	local array<byte> stream;
	local UIPacket._C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN packet;

	if(!GetPlayerInfo(uInfo))
	{
		return;
	}
	packet.nUserSID = uInfo.nID;
	Debug("API_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN -- start");
	if(IsMe)
	{
		packet.nType = 0;
	}
	else
	{
		packet.nType = 1;
	}
	packet.nCastleID = GetCastleID();
	packet.nMercenaryPledgeSID = currentClanID;
	Debug((((("API_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN step 0" @ string(packet.nUserSID)) @ string(packet.nType)) @ string(packet.nCastleID)) @ string(packet.nMercenaryPledgeSID)));
	if(Class'Interface.UIPacket'.static.Encode_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN(stream, packet))
	{
		Class'Interface.UIPacket'.static.RequestUIPacket(738, stream);
	}
	return;
}

function RichListCtrlRowData MakeData(UIPacket._WorldCastleWar_MercenaryMemberInfo memberInfo)
{
	local Color TextColor;
	local RichListCtrlRowData rowData;
	local string classType;

	rowData.cellDataList.Length = 2;
	if((memberInfo.nIsMyInfo == 1))
	{
		IsMe = true;
		TextColor = GetColor(255, 204, 0, 255);
	}
	else if((memberInfo.nIsOnline == 1))
	{
		TextColor = GetColor(221, 221, 221, 255);
	}
	else
	{
		TextColor = GetColor(128, 128, 128, 255);
	}
	rowData.cellDataList[0].HiddenStringForSorting = ConvertWorldIDToStr(memberInfo.wstrMercenaryName);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, ConvertWorldIDToStr(memberInfo.wstrMercenaryName), TextColor, false, 0, 0);
	if((memberInfo.nIsOnline == 1))
	{
		TextColor = GetColor(187, 170, 187, 255);
	}
	else
	{
		TextColor = GetColor(128, 128, 128, 255);
	}
	classType = GetClassType(memberInfo.nClassType);
	rowData.cellDataList[1].HiddenStringForSorting = classType;
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, classType, TextColor, false, 0, 0);
	return rowData;
}

function int GetCastleID()
{
	return Class'Interface.WorldSiegeWnd'.static.Inst().GetCastleIDSelected();
}

function TextureHandle GetTextureCatleIcon(int Index)
{
	return GetTextureHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SiegeMercenaryConfirmWnd.SiegeMercenaryEntryCastle_Tex") $ string(Index)));
}

function HandleOnClickRefresh()
{
	SiegeMercenaryRefresh_Btn.DisableWindow();
	m_hOwnerWnd.SetTimer(1, 5000);
	API_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_LIST();
	return;
}

function HandleOnCLickEntryBtn()
{
	if(IsMe)
	{
		txtSiegeMercenaryConfirmDesc_Txt.SetText(GetSystemString(13065));
	}
	else
	{
		txtSiegeMercenaryConfirmDesc_Txt.SetText(GetSystemString(13066));
	}
	SiegeMercenaryConfirmWnd.ShowWindow();
	return;
}

function HandleOnCLickConfirmBtn()
{
	m_hOwnerWnd.SetTimer(2, 5000);
	SiegeMercenaryEntry_Btn.DisableWindow();
	API_C_EX_WORLDCASTLEWAR_PLEDGE_MERCENARY_MEMBER_JOIN();
	SiegeMercenaryConfirmWnd.HideWindow();
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hOwnerWnd.HideWindow();
	return;
}
