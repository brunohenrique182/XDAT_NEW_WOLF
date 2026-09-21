class SiegeMercenaryDrawerWnd extends UICommonAPI;

const TIME_ID = 1;
const TIME_REFRESH = 5000;
const TIMER_ENTRYID = 2;
const TIMER_ENTRYREFRESH = 5000;

enum TYPE_TABORDER
{
	Attacker,                       // 0
	DEFENDER                        // 1
};

var string m_Windowname;
var WindowHandle Me;
var RichListCtrlHandle SiegeMercenaryEntry_List;
var TextureHandle SiegeMercenaryMark_Tex;
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
var TextBoxHandle EntryNum01_Txt;
var bool IsMe;
var int m_PlayerClanID;
var int currentClanID;
var array<int> castleIDs;

function Initialize()
{
	Me = GetWindowHandle(m_Windowname);
	SiegeMercenaryEntry_List = GetRichListCtrlHandle((m_Windowname $ ".SiegeMercenaryEntry_List"));
	SiegeMercenaryTabCtrl = GetTabHandle((m_Windowname $ ".SiegeMercenaryTabCtrl"));
	SiegeMercenaryMark_Tex = GetTextureHandle((m_Windowname $ ".SiegeMercenaryMark_Tex"));
	SiegeMercenaryPledgeName_Txt = GetTextBoxHandle((m_Windowname $ ".SiegeMercenaryPledgeName_Txt"));
	SiegeMercenaryUserName = GetTextBoxHandle((m_Windowname $ ".SiegeMercenaryUserName"));
	EntryNum01_Txt = GetTextBoxHandle((m_Windowname $ ".EntryNum01_Txt"));
	SiegeMercenaryEntryNum01_Txt = GetTextBoxHandle((m_Windowname $ ".SiegeMercenaryEntryNum01_Txt"));
	SiegeMercenaryEntryNum02_Txt = GetTextBoxHandle((m_Windowname $ ".SiegeMercenaryEntryNum02_Txt"));
	SiegeMercenaryEntry_Btn = GetButtonHandle((m_Windowname $ ".SiegeMercenaryEntry_Btn"));
	SiegeMercenaryRefresh_Btn = GetButtonHandle((m_Windowname $ ".SiegeMercenaryRefresh_Btn"));
	SiegeMercenaryPledge_Tex = GetTextureHandle((m_Windowname $ ".SiegeMercenaryPledge_Tex"));
	SiegeMercenaryPledgeCrest_Tex = GetTextureHandle((m_Windowname $ ".SiegeMercenaryPledgeCrest_Tex"));
	SiegeMercenaryConfirmWnd = GetWindowHandle((m_Windowname $ ".SiegeMercenaryConfirmWnd"));
	txtSiegeMercenaryConfirmDesc_Txt = GetTextBoxHandle((m_Windowname $ ".SiegeMercenaryConfirmWnd.SiegeMercenaryConfirmDesc_Txt"));
	SiegeMercenaryEntryNum02_Txt.SetText("/100");
	return;
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 1:
			Me.KillTimer(TimerID);
			SiegeMercenaryRefresh_Btn.EnableWindow();
			break;
		case 2:
			Me.KillTimer(TimerID);
			SiegeMercenaryEntry_Btn.EnableWindow();
		default:
			break;
	}
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(11340);
	RegisterEvent(11341);
	RegisterEvent(11342);
	RegisterEvent(11350);
	return;
}

function OnLoad()
{
	Initialize();
	SetClosingOnESC();
	return;
}

function OnEvent(int Event_ID, string param)
{
	Debug((("OnEvent" @ string(Event_ID)) @ param));
	switch(Event_ID)
	{
		case 11340:
			HandleMercenaryMemberListStart(param);
			break;
		case 11341:
			HandleMercenaryMemberList(param);
			break;
		case 11342:
			HandleMercenaryMemberListEnd(param);
			break;
		case 11350:
			HandlePledgeMercenaryMemberJoin(param);
			break;
		default:
			break;
	}
	return;
}

function OnShow()
{
	Me.SetFocus();
	SiegeMercenaryConfirmWnd.HideWindow();
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "SiegeMercenaryClose_Btn":
			Me.HideWindow();
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

function HandleMercenaryMemberListStart(string param)
{
	IsMe = false;
	SiegeMercenaryEntry_List.DeleteAllItem();
	return;
}

function HandleMercenaryMemberList(string param)
{
	local int IsMeInt, IsOnline;
	local string Name, classType;
	local int ClassID;
	local Color TextColor;
	local RichListCtrlRowData rowData;

	ParseInt(param, "IsMe", IsMeInt);
	ParseInt(param, "IsOnline", IsOnline);
	ParseString(param, "Name", Name);
	ParseInt(param, "ClassID", ClassID);
	rowData.cellDataList.Length = 2;
	if((IsMeInt > 0))
	{
		IsMe = true;
		TextColor = GetColor(255, 204, 0, 255);
	}
	else if((IsOnline > 0))
	{
		TextColor = GetColor(221, 221, 221, 255);
	}
	else
	{
		TextColor = GetColor(128, 128, 128, 255);
	}
	rowData.cellDataList[0].HiddenStringForSorting = Name;
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, Name, TextColor, false, 0, 0);
	if((IsOnline > 0))
	{
		TextColor = GetColor(187, 170, 187, 255);
	}
	else
	{
		TextColor = GetColor(128, 128, 128, 255);
	}
	classType = GetClassType(ClassID);
	rowData.cellDataList[1].HiddenStringForSorting = classType;
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, classType, TextColor, false, 0, 0);
	SiegeMercenaryEntry_List.InsertRecord(rowData);
	return;
}

function HandleMercenaryMemberListEnd(string param)
{
	SiegeMercenaryEntryNum01_Txt.SetText(string(SiegeMercenaryEntry_List.GetRecordCount()));
	if(IsMe)
	{
		SiegeMercenaryEntry_Btn.SetButtonName(13104);
	}
	else
	{
		SiegeMercenaryEntry_Btn.SetButtonName(13103);
	}
	return;
}

function HandlePledgeMercenaryMemberJoin(string param)
{
	local int Result;

	ParseInt(param, "Result", Result);
	if((Result > 0))
	{
		API_RequestPledgeMercenaryMemberList(currentClanID);
	}
	return;
}

function MakeCastleIds(string castleIDsStr)
{
	local array<string> castleIDsStrs;
	local int i;
	local TextureHandle castleMark;

	Split(castleIDsStr, "/", castleIDsStrs);
	i = 0;
	while((i < 2))
	{
		GetTextureCatleIcon(i).HideWindow();
		i++;
	}
	castleIDs.Length = castleIDsStrs.Length;
	i = 0;
	while((i < castleIDsStrs.Length))
	{
		castleIDs[i] = int(castleIDsStrs[i]);
		castleMark = GetTextureCatleIcon(i);
		castleMark.ShowWindow();
		castleMark.SetTexture(getInstanceL2Util().GetCastleMinIconName(castleIDs[i]));
		castleMark.SetTooltipText(GetCastleName(castleIDs[i]));
		i++;
	}
	return;
}

function SetSiegeMercenary(string castleIDsStr, int Type, int clanID, string ClanName, string PledgeMasterName, int MercenaryReward)
{
	local Texture texPledge, texAlliance;
	local bool bPledge, bAlliance;

	MakeCastleIds(castleIDsStr);
	currentClanID = clanID;
	API_RequestPledgeMercenaryMemberList(currentClanID);
	bPledge = Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(clanID, texPledge);
	bAlliance = Class'NWindow.UIDATA_CLAN'.static.GetAllianceCrestTexture(clanID, texAlliance);
	SiegeMercenaryPledge_Tex.SetTexture("");
	SiegeMercenaryPledgeCrest_Tex.SetTexture("");
	if(bPledge)
	{
		SiegeMercenaryPledge_Tex.SetTextureWithObject(texPledge);
		if(bAlliance)
		{
			SiegeMercenaryPledgeCrest_Tex.SetTextureWithObject(texAlliance);
		}
	}
	switch(Type)
	{
		case 0:
			SiegeMercenaryMark_Tex.SetTexture("L2UI_CT1.Icon.ICON_DF_SIEGE_SWORD");
			break;
		case 1:
			SiegeMercenaryMark_Tex.SetTexture("L2UI_CT1.Icon.ICON_DF_SIEGE_SHIELD");
			break;
		default:
			break;
	}
	SiegeMercenaryPledgeName_Txt.SetText(ClanName);
	SiegeMercenaryUserName.SetText(PledgeMasterName);
	EntryNum01_Txt.SetText((string(MercenaryReward) $ "%"));
	API_RequestPledgeMercenaryMemberList(clanID);
	return;
}

function int GetCastleID()
{
	local SiegeWnd siegeWndScript;

	siegeWndScript = SiegeWnd(GetScript("SiegeWnd"));
	return siegeWndScript.castleIDs[siegeWndScript.SelectedIndex];
}

function Color GetColor(int R, int G, int B, int A)
{
	local Color tColor;

	tColor.R = byte(R);
	tColor.G = byte(G);
	tColor.B = byte(B);
	tColor.A = byte(A);
	return tColor;
}

function TextureHandle GetTextureCatleIcon(int Index)
{
	return GetTextureHandle(((m_Windowname $ ".SiegeMercenaryConfirmWnd.SiegeMercenaryEntryCastle_Tex") $ string(Index)));
}

function HandleOnClickRefresh()
{
	SiegeMercenaryRefresh_Btn.DisableWindow();
	Me.SetTimer(1, 5000);
	API_RequestPledgeMercenaryMemberList(currentClanID);
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
	local int Type;
	local UserInfo Info;

	if(IsMe)
	{
		Type = 0;
	}
	else
	{
		Type = 1;
	}
	Me.SetTimer(2, 5000);
	SiegeMercenaryEntry_Btn.DisableWindow();
	if(GetPlayerInfo(Info))
	{
		API_RequestPledgeMercenaryMemberJoin(GetCastleID(), Type, Info.nID, currentClanID);
	}
	SiegeMercenaryConfirmWnd.HideWindow();
	return;
}

function API_RequestPledgeMercenaryMemberList(int PledgeID)
{
	Debug((("API_RequestPledgeMercenaryMemberList" @ string(castleIDs[0])) @ string(PledgeID)));
	Class'NWindow.SiegeAPI'.static.RequestPledgeMercenaryMemberList(castleIDs[0], PledgeID);
	return;
}

function API_RequestPledgeMercenaryMemberJoin(int castleID, int Type, int UserID, int PledgeID)
{
	Debug((((("API_RequestPledgeMercenaryMemberList" @ string(castleIDs[0])) @ string(Type)) @ string(UserID)) @ string(PledgeID)));
	Class'NWindow.SiegeAPI'.static.RequestPledgeMercenaryMemberJoin(castleIDs[0], Type, UserID, PledgeID);
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("SiegeMercenaryDrawerWnd");
	return;
}

defaultproperties
{
	m_Windowname="SiegeMercenaryDrawerWnd"
}
