class RevengeWnd extends UICommonAPI
	dependson(UIPacket);

enum CONTEXT_MENU_INDEX
{
	PledgeBtn,                      // 0
	RankerBtn                       // 1
};

struct DeadData
{
	var string deadTime;
	var string param;
};

var WindowHandle Me;
var WindowHandle RevengeConfirmWnd;
var HtmlHandle RevengeConfirmDescTitle_HtmlCtrl;
var TextBoxHandle RevengeConfirmCostTitle_Txt;
var TextBoxHandle RevengeConfirmMyCostTitle_Txt;
var TextBoxHandle RevengeConfirmCostNum_Txt;
var TextBoxHandle RevengeConfirmCostUnitTitle_Txt;
var TextBoxHandle RevengeConfirmMyCostNum_Txt;
var TextBoxHandle RevengeConfirmMyCostUnitTitle_Txt;
var ButtonHandle RevengeConfirmOk_Btn;
var ButtonHandle RevengeConfirmCancle_Btn;
var ButtonHandle RevengeLocation_Btn;
var ButtonHandle RevengeTeleport_Btn;
var RichListCtrlHandle Revenge_List;
var TextureHandle RevengeListDeco_Tex;
var TextBoxHandle RevengeDesc_Txt;
var TextBoxHandle RevengeLocationCostTitle_Txt;
var TextBoxHandle RevengeLocationCostNum_Txt;
var TextBoxHandle RevengeLocationBtnTitle_Txt;
var TextBoxHandle RevengeLocationBtnNum01_Txt;
var TextBoxHandle RevengeLocationBtnNum02_Txt;
var TextBoxHandle RevengeTeleportCostTitle_Txt;
var TextBoxHandle RevengeTeleportCostNum_Txt;
var TextBoxHandle RevengeTeleportBtnTitle_Txt;
var TextBoxHandle RevengeTeleportBtnNum01_Txt;
var TextBoxHandle RevengeTeleportBtnNum02_Txt;
var ItemWindowHandle RevengeLocationCost_ItemWindow;
var ItemWindowHandle RevengeTeleportCost_ItemWindow;
var WindowHandle RevengeDisableWnd;
var string ask_state;
var int RemainLocationCount;
var int RemainTeleportCount;
var int MaxLocationCount;
var int MaxTeleportCount;
var string enemyUserName;
var string ActionType;
var int teleportSequence;
var int teleportNeedItemClassID;
var INT64 teleportNeedItemNum;
var int locationSequence;
var int locationNeedItemClassID;
var INT64 locationNeedItemNum;
var int lastSelectedListIndex;
var array<DeadData> deadDataArray;
var RichListCtrlHandle Helpcall_List;
var WindowHandle HelpcallListDisableWnd;
var WindowHandle HelpcallDisableWnd;
var ItemWindowHandle HelpcallTeleportCost_ItemWindow;
var TextBoxHandle HelpcallTeleportCostTitle_Txt;
var TextBoxHandle HelpcallTeleportCostNum_Txt;
var TextBoxHandle HelpcallTeleportBtnNum01_Txt;
var TextBoxHandle HelpcallTeleportBtnNum02_Txt;
var ButtonHandle HelpcallTeleport_Btn;
var array<UIPacket._CLNTPVPBookShareRevengeInfo> m_PVPBookShareRevengeInfo;
var array<UIPacket._CLNTPVPBookShareRevengeInfo> m_PVPBookShareRevengeInfoHelp;
var L2UITimerObject uiTimer;
var L2UITimerObject uiTimerHelp;
//var delegate<OnSortCompare> __OnSortCompare__Delegate;
//var delegate<OnSortCompare2> __OnSortCompare2__Delegate;

function OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(11390);
	RegisterEvent((100000 + 923));
	RegisterEvent((100000 + 924));
	RegisterEvent((100000 + 925));
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	uiTimer = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject();
	uiTimer._DelegateOnTime = HandleOnTime;
	uiTimer._DelegateOnEnd = HandleOnTimeEnd;
	uiTimer._time = 1;
	uiTimerHelp = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject();
	uiTimerHelp._DelegateOnTime = HandleOnTimeHelp;
	uiTimerHelp._DelegateOnEnd = HandleOnTimeEndHelp;
	uiTimerHelp._time = 1;
	return;
}

function Initialize()
{
	Me = GetWindowHandle("RevengeWnd");
	RevengeConfirmWnd = GetWindowHandle("RevengeWnd.RevengeConfirmWnd");
	RevengeDisableWnd = GetWindowHandle("RevengeWnd.RevengeTabWnd.DisableWnd");
	RevengeConfirmDescTitle_HtmlCtrl = GetHtmlHandle("RevengeWnd.RevengeConfirmWnd.RevengeConfirmDescTitle_HtmlCtrl");
	RevengeConfirmCostTitle_Txt = GetTextBoxHandle("RevengeWnd.RevengeConfirmWnd.RevengeConfirmCostTitle_Txt");
	RevengeConfirmMyCostTitle_Txt = GetTextBoxHandle("RevengeWnd.RevengeConfirmWnd.RevengeConfirmMyCostTitle_Txt");
	RevengeConfirmCostNum_Txt = GetTextBoxHandle("RevengeWnd.RevengeConfirmWnd.RevengeConfirmCostNum_Txt");
	RevengeConfirmCostUnitTitle_Txt = GetTextBoxHandle("RevengeWnd.RevengeConfirmWnd.RevengeConfirmCostUnitTitle_Txt");
	RevengeConfirmMyCostNum_Txt = GetTextBoxHandle("RevengeWnd.RevengeConfirmWnd.RevengeConfirmMyCostNum_Txt");
	RevengeConfirmMyCostUnitTitle_Txt = GetTextBoxHandle("RevengeWnd.RevengeConfirmWnd.RevengeConfirmMyCostUnitTitle_Txt");
	RevengeConfirmOk_Btn = GetButtonHandle("RevengeWnd.RevengeConfirmWnd.RevengeConfirmOk_Btn");
	RevengeConfirmCancle_Btn = GetButtonHandle("RevengeWnd.RevengeConfirmWnd.RevengeConfirmCancle_Btn");
	Revenge_List = GetRichListCtrlHandle("RevengeWnd.RevengeTabWnd.Revenge_List");
	RevengeListDeco_Tex = GetTextureHandle("RevengeWnd.RevengeTabWnd.RevengeListDeco_Tex");
	RevengeLocation_Btn = GetButtonHandle("RevengeWnd.RevengeTabWnd.RevengeLocation_Btn");
	RevengeTeleport_Btn = GetButtonHandle("RevengeWnd.RevengeTabWnd.RevengeTeleport_Btn");
	RevengeDesc_Txt = GetTextBoxHandle("RevengeWnd.RevengeTabWnd.RevengeDesc_Txt");
	RevengeLocationCostTitle_Txt = GetTextBoxHandle("RevengeWnd.RevengeTabWnd.RevengeLocationCostTitle_Txt");
	RevengeLocationCostNum_Txt = GetTextBoxHandle("RevengeWnd.RevengeTabWnd.RevengeLocationCostNum_Txt");
	RevengeLocationBtnTitle_Txt = GetTextBoxHandle("RevengeWnd.RevengeTabWnd.RevengeLocationBtnTitle_Txt");
	RevengeLocationBtnNum01_Txt = GetTextBoxHandle("RevengeWnd.RevengeTabWnd.RevengeLocationBtnNum01_Txt");
	RevengeLocationBtnNum02_Txt = GetTextBoxHandle("RevengeWnd.RevengeTabWnd.RevengeLocationBtnNum02_Txt");
	RevengeTeleportCostTitle_Txt = GetTextBoxHandle("RevengeWnd.RevengeTabWnd.RevengeTeleportCostTitle_Txt");
	RevengeTeleportCostNum_Txt = GetTextBoxHandle("RevengeWnd.RevengeTabWnd.RevengeTeleportCostNum_Txt");
	RevengeTeleportBtnTitle_Txt = GetTextBoxHandle("RevengeWnd.RevengeTabWnd.RevengeTeleportBtnTitle_Txt");
	RevengeTeleportBtnNum01_Txt = GetTextBoxHandle("RevengeWnd.RevengeTabWnd.RevengeTeleportBtnNum01_Txt");
	RevengeTeleportBtnNum02_Txt = GetTextBoxHandle("RevengeWnd.RevengeTabWnd.RevengeTeleportBtnNum02_Txt");
	RevengeLocationCost_ItemWindow = GetItemWindowHandle("RevengeWnd.RevengeTabWnd.RevengeLocationCost_ItemWindow");
	RevengeTeleportCost_ItemWindow = GetItemWindowHandle("RevengeWnd.RevengeTabWnd.RevengeTeleportCost_ItemWindow");
	Revenge_List.SetSelectedSelTooltip(false);
	Revenge_List.SetAppearTooltipAtMouseX(true);
	Revenge_List.SetTooltipType("Revenge");
	Helpcall_List = GetRichListCtrlHandle("RevengeWnd.HelpcallTabWnd.Helpcall_List");
	HelpcallListDisableWnd = GetWindowHandle("RevengeWnd.HelpcallTabWnd.HelpcallListDisableWnd");
	HelpcallDisableWnd = GetWindowHandle("RevengeWnd.HelpcallTabWnd.DisableWnd");
	HelpcallTeleportCost_ItemWindow = GetItemWindowHandle("RevengeWnd.HelpcallTabWnd.HelpcallTeleportCost_ItemWindow");
	HelpcallTeleportCostTitle_Txt = GetTextBoxHandle("RevengeWnd.HelpcallTabWnd.HelpcallTeleportCostTitle_Txt");
	HelpcallTeleportCostNum_Txt = GetTextBoxHandle("RevengeWnd.HelpcallTabWnd.HelpcallTeleportCostNum_Txt");
	HelpcallTeleport_Btn = GetButtonHandle("RevengeWnd.HelpcallTabWnd.HelpcallTeleport_Btn");
	HelpcallTeleportBtnNum01_Txt = GetTextBoxHandle("RevengeWnd.HelpcallTabWnd.HelpcallTeleportBtnNum01_Txt");
	HelpcallTeleportBtnNum02_Txt = GetTextBoxHandle("RevengeWnd.HelpcallTabWnd.HelpcallTeleportBtnNum02_Txt");
	Helpcall_List.SetSelectedSelTooltip(false);
	Helpcall_List.SetAppearTooltipAtMouseX(true);
	Helpcall_List.SetTooltipType("RevengeHelp");
	InitData();
	return;
}

function InitData()
{
	m_PVPBookShareRevengeInfo.Length = 0;
	m_PVPBookShareRevengeInfoHelp.Length = 0;
	Revenge_List.DeleteAllItem();
	Helpcall_List.DeleteAllItem();
	lastSelectedListIndex = -1;
	RevengeDisableWnd.ShowWindow();
	HelpcallListDisableWnd.ShowWindow();
	HelpcallDisableWnd.ShowWindow();
	RevengeLocationBtnNum01_Txt.SetText("0");
	RevengeLocationBtnNum02_Txt.SetText(" / 0");
	RevengeTeleportBtnNum01_Txt.SetText("0");
	RevengeTeleportBtnNum02_Txt.SetText(" / 0");
	RevengeLocationCostTitle_Txt.SetText("");
	RevengeLocationCostNum_Txt.SetText("x0");
	RevengeTeleportCostTitle_Txt.SetText("");
	RevengeTeleportCostNum_Txt.SetText("x0");
	HelpcallTeleportCostTitle_Txt.SetText("");
	HelpcallTeleportCostNum_Txt.SetText("x0");
	HelpcallTeleportBtnNum01_Txt.SetText("0");
	HelpcallTeleportBtnNum02_Txt.SetText(" / 0");
	return;
}

function setLocationPart(int nItemID, INT64 nItemNum)
{
	local string ItemName;

	ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(nItemID));
	RevengeLocationCost_ItemWindow.Clear();
	RevengeLocationCost_ItemWindow.AddItem(GetItemInfoByClassID(nItemID));
	RevengeLocationCostTitle_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(13060), ItemName));
	RevengeLocationCostNum_Txt.SetText(("x" $ string(nItemNum)));
	return;
}

function setTeleportPart(int nItemID, INT64 nItemNum)
{
	local string ItemName;

	ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(nItemID));
	RevengeTeleportCost_ItemWindow.Clear();
	RevengeTeleportCost_ItemWindow.AddItem(GetItemInfoByClassID(nItemID));
	RevengeTeleportCostTitle_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(13060), ItemName));
	RevengeTeleportCostNum_Txt.SetText(("x" $ string(nItemNum)));
	return;
}

function AddPvpBookListItem(UIPacket._CLNTPVPBookShareRevengeInfo RevengeInfo, int Index)
{
	local RichListCtrlRowData rowData;
	local string PledgeName, sName;
	local int nLevel, nClassID, Race, KillDateTime, Online;
	local string timeStr;

	sName = RevengeInfo.sKillUserName;
	PledgeName = RevengeInfo.sKillUserPledgeName;
	Race = RevengeInfo.nKillUserRace;
	nLevel = RevengeInfo.nKillUserLevel;
	nClassID = RevengeInfo.nKillUserClass;
	Online = RevengeInfo.nKillUserOnline;
	KillDateTime = RevengeInfo.nKilledTime;
	timeStr = Right(ConvertTimetoStr(KillDateTime), 11);
	rowData.cellDataList.Length = 6;
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, ("Lv" $ string(nLevel)), GetColor(187, 170, 136, 255), false, 5, 10);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, sName, GetColor(211, 211, 211, 255), false, 10, 0);
	rowData.cellDataList[0].szData = sName;
	rowData.cellDataList[1].szData = GetClassType(nClassID);
	rowData.cellDataList[2].szData = ("Lv" $ string(nLevel));
	rowData.cellDataList[3].szData = ConvertTimetoStr(KillDateTime);
	rowData.cellDataList[4].szData = string(RevengeInfo.nShareType);
	rowData.cellDataList[5].szData = string(Online);
	rowData.cellDataList[0].nReserved1 = RevengeInfo.nShowKillerCount;
	rowData.cellDataList[0].nReserved2 = RevengeInfo.nTeleportKillerCount;
	rowData.cellDataList[0].HiddenStringForSorting = sName;
	rowData.cellDataList[1].HiddenStringForSorting = GetClassType(nClassID);
	rowData.cellDataList[2].HiddenStringForSorting = ("Lv" $ getInstanceL2Util().makeZeroString(4, INT64(nLevel)));
	rowData.cellDataList[3].HiddenStringForSorting = ConvertTimetoStr(KillDateTime);
	rowData.cellDataList[4].HiddenStringForSorting = string(RevengeInfo.nShareType);
	rowData.cellDataList[5].HiddenStringForSorting = string(Online);
	if((GetClassTransferDegree(nClassID) >= 1))
	{
		addRichListCtrlTexture(rowData.cellDataList[1].drawitems, (("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ string(nClassID)) $ "_Big"), 31, 42, 0, -5);
	}
	else
	{
		addRichListCtrlTexture(rowData.cellDataList[1].drawitems, (("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ GetRaceString(Race)) $ "_Big"), 31, 42, 0, -5);
	}
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, PledgeName, GetColor(211, 211, 211, 255), false, 5, 10);
	AddRichListCtrlString(rowData.cellDataList[3].drawitems, timeStr, GetColor(255, 255, 187, 255), false, 5, 10);
	if((RevengeInfo.nShareType != 1))
	{
		addRichListCtrlTexture(rowData.cellDataList[4].drawitems, "L2UI_EPIC.RevengeWnd.RevengeWnd_HelpcallIcon", 30, 29, 15, 2);
	}
	else
	{
		AddRichListCtrlButton(rowData.cellDataList[4].drawitems, ("helpBtn" $ string(Index)), 10, 0, "L2UI_EPIC.RevengeWnd.RevengeWnd_HelpcallBtn_Normal", "L2UI_EPIC.RevengeWnd.RevengeWnd_HelpcallBtn_Down", "L2UI_EPIC.RevengeWnd.RevengeWnd_HelpcallBtn_Over", 37, 32, 37, 32);
	}
	if((Online == 2))
	{
		addRichListCtrlTexture(rowData.cellDataList[5].drawitems, "L2UI_CT1.RevengeWnd.RevengeWnd_OnLineIcon", 16, 19, 0, 8);
	}
	else
	{
		addRichListCtrlTexture(rowData.cellDataList[5].drawitems, "L2UI_CT1.RevengeWnd.RevengeWnd_OffLineIcon", 16, 19, 0, 8);
	}
	Revenge_List.InsertRecord(rowData);
	return;
}

function AddPvpHelpBookListItem(UIPacket._CLNTPVPBookShareRevengeInfo RevengeInfo, int Index)
{
	local RichListCtrlRowData rowData;
	local string sName, sNameed;
	local int nLevel, nLevelhelp, nKillUserKarma, empty, nClassID, Race, KillDateTime, Online;
	local INT64 nKillUserKarmaMin;
	local string PledgeName, PledgeNamehelp, timeStr;

	HelpcallListDisableWnd.HideWindow();
	sName = RevengeInfo.sKillUserName;
	sNameed = RevengeInfo.sKilledUserName;
	PledgeName = RevengeInfo.sKillUserPledgeName;
	PledgeNamehelp = RevengeInfo.sKilledUserPledgeName;
	Race = RevengeInfo.nKillUserRace;
	nLevel = RevengeInfo.nKillUserLevel;
	nLevelhelp = RevengeInfo.nKilledUserLevel;
	nClassID = RevengeInfo.nKillUserClass;
	Online = RevengeInfo.nKillUserOnline;
	KillDateTime = RevengeInfo.nSharedTime;
	nKillUserKarma = RevengeInfo.nKillUserKarma;
	timeStr = Right(ConvertTimetoStr(KillDateTime), 11);
	Class'NWindow.PersonalConnectionAPI'.static.GetPvpbookRequiredItem("ShareRevenge_Karma", 1, empty, nKillUserKarmaMin);
	rowData.cellDataList.Length = 7;
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, (GetSystemString(88) $ string(nLevel)), GetColor(187, 170, 136, 255), false, 5, 10);
	if((INT64(nKillUserKarma) <= nKillUserKarmaMin))
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, sName, GetColor(230, 101, 101, 255), false, 10, 0);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, sName, GetColor(211, 211, 211, 255), false, 10, 0);
	}
	AddRichListCtrlString(rowData.cellDataList[4].drawitems, sNameed, GetColor(211, 211, 211, 255), false, 0, 10);
	rowData.cellDataList[0].szData = sName;
	rowData.cellDataList[1].szData = GetClassType(nClassID);
	rowData.cellDataList[2].szData = string(Online);
	rowData.cellDataList[3].szData = ConvertTimetoStr(KillDateTime);
	rowData.cellDataList[4].szData = sNameed;
	rowData.cellDataList[5].szData = PledgeName;
	rowData.cellDataList[6].szData = PledgeNamehelp;
	rowData.cellDataList[0].nReserved1 = RevengeInfo.nSharedTeleportKillerCount;
	rowData.cellDataList[1].nReserved1 = nLevel;
	rowData.cellDataList[2].nReserved1 = nLevelhelp;
	rowData.cellDataList[3].nReserved1 = nKillUserKarma;
	rowData.cellDataList[0].HiddenStringForSorting = sName;
	rowData.cellDataList[1].HiddenStringForSorting = GetClassType(nClassID);
	rowData.cellDataList[2].HiddenStringForSorting = string(Online);
	rowData.cellDataList[3].HiddenStringForSorting = ConvertTimetoStr(KillDateTime);
	rowData.cellDataList[4].HiddenStringForSorting = sNameed;
	if((GetClassTransferDegree(nClassID) >= 1))
	{
		addRichListCtrlTexture(rowData.cellDataList[1].drawitems, (("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ string(nClassID)) $ "_Big"), 31, 42, 0, -5);
	}
	else
	{
		addRichListCtrlTexture(rowData.cellDataList[1].drawitems, (("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ GetRaceString(Race)) $ "_Big"), 31, 42, 0, -5);
	}
	AddRichListCtrlString(rowData.cellDataList[3].drawitems, timeStr, GetColor(255, 255, 187, 255), false, 5, 10);
	if((Online == 2))
	{
		addRichListCtrlTexture(rowData.cellDataList[2].drawitems, "L2UI_CT1.RevengeWnd.RevengeWnd_OnLineIcon", 16, 19, 25, 8);
	}
	else
	{
		addRichListCtrlTexture(rowData.cellDataList[2].drawitems, "L2UI_CT1.RevengeWnd.RevengeWnd_OffLineIcon", 16, 19, 25, 8);
	}
	Helpcall_List.InsertRecord(rowData);
	return;
}

function OnShow()
{
	RevengeConfirmWnd.HideWindow();
	if(!Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("MiniMapGfxWnd"))
	{
		Me.SetFocus();
	}
	if((lastSelectedListIndex >= 0))
	{
		Revenge_List.SetSelectedIndex(lastSelectedListIndex, true);
	}
	C_EX_PVPBOOK_SHARE_REVENGE_LIST();
	return;
}

function OnHide()
{
	uiTimer._Stop();
	uiTimerHelp._Stop();
	InitData();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 11390:
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("MiniMapGfxWnd"))
			{
				Class'NWindow.UIAPI_WINDOW'.static.SetFocus("MiniMapGfxWnd");
			}
			break;
		case 40:
			InitData();
			break;
		case (100000 + 923):
			S_EX_PVPBOOK_SHARE_REVENGE_LIST();
			break;
		case (100000 + 924):
			S_EX_PVPBOOK_SHARE_REVENGE_KILLER_LOCATION();
			break;
		case (100000 + 925):
			break;
		default:
			break;
	}
	return;
}

function showMapKillerLocation(string param)
{
	local Vector Position;

	ParseFloat(param, "X", Position.X);
	ParseFloat(param, "Y", Position.Y);
	ParseFloat(param, "Z", Position.Z);
	getInstanceL2Util().ShowHighLightMapIcon(Position, 0, 0);
	return;
}

function pvpBookListEndHandler()
{
	local int Index;
	local RichListCtrlRowData rowData;
	local int RemainLocationCount, RemainTeleportCount;

	Index = Revenge_List.GetSelectedIndex();
	Revenge_List.GetRec(Index, rowData);
	RemainLocationCount = rowData.cellDataList[0].nReserved1;
	RemainTeleportCount = rowData.cellDataList[0].nReserved2;
	MaxLocationCount = Class'NWindow.PersonalConnectionAPI'.static.GetPvpbookMaxCount("location");
	MaxTeleportCount = Class'NWindow.PersonalConnectionAPI'.static.GetPvpbookMaxCount("teleport");
	locationSequence = ((MaxLocationCount - RemainLocationCount) + 1);
	if((locationSequence > MaxLocationCount))
	{
		locationSequence = MaxLocationCount;
	}
	Class'NWindow.PersonalConnectionAPI'.static.GetPvpbookRequiredItem("location", locationSequence, locationNeedItemClassID, locationNeedItemNum);
	teleportSequence = ((MaxTeleportCount - RemainTeleportCount) + 1);
	if((teleportSequence > MaxTeleportCount))
	{
		teleportSequence = MaxTeleportCount;
	}
	Class'NWindow.PersonalConnectionAPI'.static.GetPvpbookRequiredItem("teleport", teleportSequence, teleportNeedItemClassID, teleportNeedItemNum);
	if((RemainLocationCount <= 0))
	{
		RevengeLocation_Btn.DisableWindow();
		GetTextureHandle("RevengeWnd.RevengeLocationDisable_Tex").ShowWindow();
	}
	else
	{
		RevengeLocation_Btn.EnableWindow();
		GetTextureHandle("RevengeWnd.RevengeLocationDisable_Tex").HideWindow();
	}
	if((RemainTeleportCount <= 0))
	{
		RevengeTeleport_Btn.DisableWindow();
		GetTextureHandle("RevengeWnd.RevengeTeleportDisable_Tex").ShowWindow();
	}
	else
	{
		RevengeTeleport_Btn.EnableWindow();
		GetTextureHandle("RevengeWnd.RevengeTeleportDisable_Tex").HideWindow();
	}
	if((int(rowData.cellDataList[4].szData) != 1))
	{
		RevengeTeleport_Btn.DisableWindow();
		GetTextureHandle("RevengeWnd.RevengeTeleportDisable_Tex").ShowWindow();
	}
	RevengeLocationBtnNum01_Txt.SetText(string(RemainLocationCount));
	RevengeLocationBtnNum02_Txt.SetText((" / " $ string(MaxLocationCount)));
	RevengeTeleportBtnNum01_Txt.SetText(string(RemainTeleportCount));
	RevengeTeleportBtnNum02_Txt.SetText((" / " $ string(MaxTeleportCount)));
	setLocationPart(locationNeedItemClassID, locationNeedItemNum);
	setTeleportPart(teleportNeedItemClassID, teleportNeedItemNum);
	return;
}

function helpBookListEndHandler()
{
	local int Sequence, MaxShareTeleport, needItemClassID, nSharedTeleportKillerCount, nKillUserKarma;
	local INT64 needItemNum, nKillUserKarmaMin;
	local string ItemName;
	local int Index;
	local RichListCtrlRowData rowData;
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	Index = Helpcall_List.GetSelectedIndex();
	Helpcall_List.GetRec(Index, rowData);
	nSharedTeleportKillerCount = rowData.cellDataList[0].nReserved1;
	nKillUserKarma = rowData.cellDataList[3].nReserved1;
	MaxShareTeleport = Class'NWindow.PersonalConnectionAPI'.static.GetPvpbookMaxCount("ShareTeleport");
	Class'NWindow.PersonalConnectionAPI'.static.GetPvpbookRequiredItem("ShareRevenge_Karma", 1, needItemClassID, nKillUserKarmaMin);
	Sequence = ((MaxShareTeleport - nSharedTeleportKillerCount) + 1);
	if((INT64(nKillUserKarma) <= nKillUserKarmaMin))
	{
		Class'NWindow.PersonalConnectionAPI'.static.GetPvpbookRequiredItem("ShareTeleport_Karma", 1, needItemClassID, needItemNum);
	}
	else
	{
		Class'NWindow.PersonalConnectionAPI'.static.GetPvpbookRequiredItem("ShareTeleport", Sequence, needItemClassID, needItemNum);
	}
	ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(needItemClassID));
	if((nSharedTeleportKillerCount <= 0))
	{
		HelpcallTeleport_Btn.DisableWindow();
		GetTextureHandle("RevengeWnd.HelpcallTeleportDisable_Tex").ShowWindow();
	}
	else
	{
		HelpcallTeleport_Btn.EnableWindow();
		GetTextureHandle("RevengeWnd.HelpcallTeleportDisable_Tex").HideWindow();
	}
	if((UserInfo.Name == rowData.cellDataList[0].szData))
	{
		HelpcallTeleport_Btn.DisableWindow();
		GetTextureHandle("RevengeWnd.HelpcallTeleportDisable_Tex").ShowWindow();
	}
	if((Sequence <= MaxShareTeleport))
	{
		HelpcallTeleportCost_ItemWindow.Clear();
		HelpcallTeleportCost_ItemWindow.AddItem(GetItemInfoByClassID(needItemClassID));
		HelpcallTeleportBtnNum01_Txt.SetText(string(nSharedTeleportKillerCount));
		HelpcallTeleportBtnNum02_Txt.SetText(("/ " @ string(MaxShareTeleport)));
		HelpcallTeleportCostTitle_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(13060), ItemName));
		if((needItemNum > INT64(0)))
		{
			HelpcallTeleportCostNum_Txt.SetText(("x" @ string(needItemNum)));
		}
		else
		{
			HelpcallTeleportCostNum_Txt.SetText(GetSystemString(3983));
		}
	}
	else
	{
		HelpcallTeleportCost_ItemWindow.Clear();
		HelpcallTeleportBtnNum01_Txt.SetText("0");
		HelpcallTeleportBtnNum02_Txt.SetText(("/ " @ string(MaxShareTeleport)));
		HelpcallTeleportCostTitle_Txt.SetText("");
		HelpcallTeleportCostNum_Txt.SetText("x0");
	}
	return;
}

function tryWhisper()
{
	local ChatWnd chatWndScript;
	local string tempStr;
	local RichListCtrlRowData rowData;

	if((Revenge_List.GetSelectedIndex() <= -1))
	{
		return;
	}
	Revenge_List.GetSelectedRec(rowData);
	tempStr = rowData.cellDataList[0].szData;
	if((tempStr != ""))
	{
		chatWndScript = ChatWnd(GetScript("ChatWnd"));
		chatWndScript.SetChatEditBox((("\"" $ tempStr) $ " "));
	}
	return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		case "Revenge_List":
			pvpBookListEndHandler();
			SwitchingRevengeDisableWnd();
			break;
		case "Helpcall_List":
			helpBookListEndHandler();
			SwitchingRevengeHelpDisableWnd();
			break;
		default:
			break;
	}
	return;
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	switch(a_WindowHandle)
	{
		case Revenge_List:
			SwitchingRevengeDisableWnd();
			break;
		case Helpcall_List:
			SwitchingRevengeHelpDisableWnd();
			break;
		default:
			break;
	}
	return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		case "Revenge_List":
			tryWhisper();
			break;
		default:
			break;
	}
	return;
}

function SwitchingRevengeDisableWnd()
{
	local int SelectedIndex;

	SelectedIndex = Revenge_List.GetSelectedIndex();
	if((SelectedIndex >= 0))
	{
		RevengeDisableWnd.HideWindow();
	}
	else
	{
		RevengeDisableWnd.ShowWindow();
	}
	return;
}

function SwitchingRevengeHelpDisableWnd()
{
	local int SelectedIndex;

	SelectedIndex = Helpcall_List.GetSelectedIndex();
	if((SelectedIndex >= 0))
	{
		HelpcallDisableWnd.HideWindow();
	}
	else
	{
		HelpcallDisableWnd.ShowWindow();
	}
	return;
}

function OnClickButton(string Name)
{
	local string Str;
	local int Select;
	local Rect rectWnd;

	Str = Left(Name, 7);
	switch(Name)
	{
		case "RevengeConfirmOk_Btn":
			OnRevengeConfirmOk_BtnClick();
			break;
		case "RevengeConfirmCancle_Btn":
			OnRevengeConfirmCancle_BtnClick();
			break;
		case "RevengeLocation_Btn":
			OnRevengeLocation_BtnClick();
			break;
		case "RevengeTeleport_Btn":
			OnRevengeTeleport_BtnClick();
			break;
		case "Reset_Btn":
			refresh();
			break;
		case "HelpcallTeleport_Btn":
			ShareTeleportKiller();
			break;
		default:
			break;
	}
	if((Str == "helpBtn"))
	{
		Select = int(Right(Name, (Len(Name) - 7)));
		rectWnd = Revenge_List.GetRect();
		ShowContextMenu((rectWnd.nX + 510), ((rectWnd.nY + (Select * 34)) + 15));
	}
	return;
}

function refresh()
{
	C_EX_PVPBOOK_SHARE_REVENGE_LIST();
	return;
}

function OnRevengeConfirmOk_BtnClick()
{
	local int Index;
	local RichListCtrlRowData rowData;

	RevengeConfirmWnd.HideWindow();
	if((ask_state == "teleport"))
	{
		C_EX_PVPBOOK_SHARE_REVENGE_TELEPORT_TO_KILLER(enemyUserName);
		Me.HideWindow();
	}
	else if((ask_state == "location"))
	{
		lastSelectedListIndex = Revenge_List.GetSelectedIndex();
		C_EX_PVPBOOK_SHARE_REVENGE_KILLER_LOCATION(enemyUserName);
	}
	else if((ask_state == "sharePledge"))
	{
		Index = Revenge_List.GetSelectedIndex();
		Revenge_List.GetRec(Index, rowData);
		API_C_EX_PVPBOOK_SHARE_REVENGE_REQ_SHARE_REVENGEINFO(rowData.cellDataList[0].szData, 1);
	}
	else if((ask_state == "shareRanker"))
	{
		Index = Revenge_List.GetSelectedIndex();
		Revenge_List.GetRec(Index, rowData);
		API_C_EX_PVPBOOK_SHARE_REVENGE_REQ_SHARE_REVENGEINFO(rowData.cellDataList[0].szData, 2);
	}
	else if((ask_state == "ShareTeleportKiller"))
	{
		C_EX_PVPBOOK_SHARE_REVENGE_SHARED_TELEPORT_TO_KILLER();
		Me.HideWindow();
	}
	return;
}

function API_C_EX_PVPBOOK_SHARE_REVENGE_REQ_SHARE_REVENGEINFO(string Kill, int Type)
{
	local array<byte> stream;
	local UIPacket._C_EX_PVPBOOK_SHARE_REVENGE_REQ_SHARE_REVENGEINFO packet;
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	packet.sKilledUserName = UserInfo.Name;
	packet.sKillUserName = Kill;
	packet.nShareType = Type;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_PVPBOOK_SHARE_REVENGE_REQ_SHARE_REVENGEINFO(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(693, stream);
	return;
}

function C_EX_PVPBOOK_SHARE_REVENGE_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_PVPBOOK_SHARE_REVENGE_LIST packet;
	local UserInfo UserInfo;

	InitData();
	GetPlayerInfo(UserInfo);
	packet.nOwnerUserSID = UserInfo.nID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_PVPBOOK_SHARE_REVENGE_LIST(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(692, stream);
	return;
}

function C_EX_PVPBOOK_SHARE_REVENGE_KILLER_LOCATION(string enemyUserName)
{
	local array<byte> stream;
	local UIPacket._C_EX_PVPBOOK_SHARE_REVENGE_KILLER_LOCATION packet;
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	packet.sKilledUserName = UserInfo.Name;
	packet.sKillUserName = enemyUserName;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_PVPBOOK_SHARE_REVENGE_KILLER_LOCATION(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(694, stream);
	return;
}

function C_EX_PVPBOOK_SHARE_REVENGE_TELEPORT_TO_KILLER(string enemyUserName)
{
	local array<byte> stream;
	local UIPacket._C_EX_PVPBOOK_SHARE_REVENGE_TELEPORT_TO_KILLER packet;
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	packet.sKilledUserName = UserInfo.Name;
	packet.sKillUserName = enemyUserName;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_PVPBOOK_SHARE_REVENGE_TELEPORT_TO_KILLER(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(695, stream);
	return;
}

function C_EX_PVPBOOK_SHARE_REVENGE_SHARED_TELEPORT_TO_KILLER()
{
	local int Index;
	local RichListCtrlRowData rowData;
	local array<byte> stream;
	local UIPacket._C_EX_PVPBOOK_SHARE_REVENGE_SHARED_TELEPORT_TO_KILLER packet;

	Index = Helpcall_List.GetSelectedIndex();
	Helpcall_List.GetRec(Index, rowData);
	packet.sKilledUserName = rowData.cellDataList[4].szData;
	packet.sKillUserName = rowData.cellDataList[0].szData;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_PVPBOOK_SHARE_REVENGE_SHARED_TELEPORT_TO_KILLER(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(696, stream);
	return;
}

function S_EX_PVPBOOK_SHARE_REVENGE_LIST()
{
	local UIPacket._S_EX_PVPBOOK_SHARE_REVENGE_LIST packet;
	local int i;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_PVPBOOK_SHARE_REVENGE_LIST(packet))
	{
		return;
	}
	if((packet.cCurrentPage == 1))
	{
		uiTimer._Stop();
		uiTimerHelp._Stop();
		InitData();
	}
	i = 0;
	while((i < packet.RevengeInfo.Length))
	{
		switch(packet.RevengeInfo[i].nShareType)
		{
			case 1:
				m_PVPBookShareRevengeInfo[m_PVPBookShareRevengeInfo.Length] = packet.RevengeInfo[i];
				break;
			case 2:
			case 4:
				m_PVPBookShareRevengeInfoHelp[m_PVPBookShareRevengeInfoHelp.Length] = packet.RevengeInfo[i];
				break;
			default:
				m_PVPBookShareRevengeInfo[m_PVPBookShareRevengeInfo.Length] = packet.RevengeInfo[i];
				m_PVPBookShareRevengeInfoHelp[m_PVPBookShareRevengeInfoHelp.Length] = packet.RevengeInfo[i];
				break;
		}
		i++;
	}
	if((packet.cMaxPage == packet.cCurrentPage))
	{
		MakeList();
	}
	return;
}

function S_EX_PVPBOOK_SHARE_REVENGE_KILLER_LOCATION()
{
	local UIPacket._S_EX_PVPBOOK_SHARE_REVENGE_KILLER_LOCATION packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_PVPBOOK_SHARE_REVENGE_KILLER_LOCATION(packet))
	{
		return;
	}
	return;
}

function MakeList()
{
	if(!Me.IsShowWindow())
	{
		return;
	}
	// m_PVPBookShareRevengeInfo.Sort(OnSortCompare);   // array.Sort() unsupported by this compiler
	// m_PVPBookShareRevengeInfoHelp.Sort(OnSortCompare2);   // array.Sort() unsupported by this compiler
	uiTimer._maxCount = (m_PVPBookShareRevengeInfo.Length / 10);
	if((uiTimer._maxCount == 0))
	{
		HandleOnTimeEnd();
	}
	else
	{
		uiTimer._Play();
	}
	uiTimerHelp._maxCount = (m_PVPBookShareRevengeInfoHelp.Length / 10);
	if((uiTimerHelp._maxCount == 0))
	{
		HandleOnTimeEndHelp();
	}
	else
	{
		uiTimerHelp._Play();
	}
	return;
}

function HandleOnTime(int t)
{
	local int i, sI, eI;

	sI = (t * 10);
	eI = ((t * 10) + 10);
	i = sI;
	while((i < eI))
	{
		AddPvpBookListItem(m_PVPBookShareRevengeInfo[i], i);
		i++;
	}
	return;
}

function HandleOnTimeEnd()
{
	local int i, sI, eI;

	sI = (uiTimer._maxCount * 10);
	eI = int((float(sI) + (float(m_PVPBookShareRevengeInfo.Length) % 10.0000000)));
	i = sI;
	while((i < eI))
	{
		AddPvpBookListItem(m_PVPBookShareRevengeInfo[i], i);
		i++;
	}
	return;
}

function HandleOnTimeHelp(int t)
{
	local int i, sI, eI;

	sI = (t * 10);
	eI = ((t * 10) + 10);
	i = sI;
	while((i < eI))
	{
		AddPvpHelpBookListItem(m_PVPBookShareRevengeInfoHelp[i], i);
		i++;
	}
	return;
}

function HandleOnTimeEndHelp()
{
	local int i, sI, eI;

	sI = (uiTimerHelp._maxCount * 10);
	eI = int((float(sI) + (float(m_PVPBookShareRevengeInfoHelp.Length) % 10.0000000)));
	i = sI;
	while((i < eI))
	{
		AddPvpHelpBookListItem(m_PVPBookShareRevengeInfoHelp[i], i);
		i++;
	}
	return;
}

delegate int OnSortCompare(UIPacket._CLNTPVPBookShareRevengeInfo A, UIPacket._CLNTPVPBookShareRevengeInfo B)
{
	if((A.nKilledTime < B.nKilledTime))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

delegate int OnSortCompare2(UIPacket._CLNTPVPBookShareRevengeInfo A, UIPacket._CLNTPVPBookShareRevengeInfo B)
{
	if((A.nSharedTime < B.nSharedTime))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

function OnRevengeConfirmCancle_BtnClick()
{
	RevengeConfirmWnd.HideWindow();
	return;
}

function OnRevengeLocation_BtnClick()
{
	local int Index;

	ask_state = "location";
	Index = Revenge_List.GetSelectedIndex();
	showAsk(locationNeedItemClassID, locationNeedItemNum);
	return;
}

function OnRevengeTeleport_BtnClick()
{
	ask_state = "teleport";
	showAsk(teleportNeedItemClassID, teleportNeedItemNum);
	return;
}

function showAsk(int nNeedItemID, INT64 nNeedItemNum)
{
	local string ItemName;
	local INT64 myItemNum;
	local int askSystemMsg;
	local RichListCtrlRowData rowData;
	local string htmlStr;

	if((Revenge_List.GetSelectedIndex() <= -1))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(326));
		return;
	}
	Revenge_List.GetSelectedRec(rowData);
	if((rowData.cellDataList[5].szData != "2"))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13056));
		return;
	}
	enemyUserName = rowData.cellDataList[0].szData;
	if((ask_state == "location"))
	{
		askSystemMsg = 13050;
	}
	else
	{
		askSystemMsg = 13051;
	}
	ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(nNeedItemID));
	myItemNum = getInventoryItemNumByClassID(nNeedItemID);
	RevengeConfirmWnd.ShowWindow();
	RevengeConfirmCostTitle_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(13060), ItemName));
	RevengeConfirmMyCostTitle_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(13059), ItemName));
	RevengeConfirmCostNum_Txt.SetText(MakeCostString(string(nNeedItemNum)));
	RevengeConfirmMyCostNum_Txt.SetText(MakeCostString(string(myItemNum)));
	htmlStr = ("<html><body>" $ htmlAddText(MakeFullSystemMsg(GetSystemMessage(askSystemMsg), enemyUserName), "", ""));
	if((myItemNum >= nNeedItemNum))
	{
		RevengeConfirmMyCostNum_Txt.SetTextColor(getInstanceL2Util().White);
		RevengeConfirmOk_Btn.EnableWindow();
	}
	else
	{
		RevengeConfirmMyCostNum_Txt.SetTextColor(getInstanceL2Util().Red);
		RevengeConfirmOk_Btn.DisableWindow();
		htmlStr = ((htmlStr $ "<br1>") $ htmlAddText((("(" $ GetSystemMessage(701)) $ ")"), "", "EE7777"));
	}
	htmlStr = (htmlStr $ "</body></html>");
	RevengeConfirmDescTitle_HtmlCtrl.LoadHtmlFromString(htmlStr);
	return;
}

function ShowContextMenu(int X, int Y)
{
	local UIControlContextMenu ContextMenu;
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
	ContextMenu = Class'Interface.UIControlContextMenu'.static.GetInstance();
	ContextMenu.Clear();
	ContextMenu.DelegateOnClickContextMenu = HandleOnClickContextMenu;
	if((UserInfo.nClanID > 0))
	{
		ContextMenu.MenuNew(GetSystemString(13508), 0);
		ContextMenu.MenuAddIcon("L2UI_EPIC.RevengeWnd.RevengeWnd_PledgeIcon");
	}
	ContextMenu.MenuNew(GetSystemString(13509), 1);
	ContextMenu.MenuAddIcon("L2UI_EPIC.RevengeWnd.RevengeWnd_RankerIcon");
	ContextMenu.Show((X - 5), (Y - 5), string(self));
	return;
}

function HandleOnClickContextMenu(int Index)
{
	switch(Index)
	{
		case 0:
			ask_state = "sharePledge";
			SharePledge();
			break;
		case 1:
			ask_state = "shareRanker";
			ShareRanker();
			break;
		default:
			break;
	}
	return;
}

function SharePledge()
{
	local string ItemName;
	local INT64 nNeedItemNum, myItemNum;
	local int item_id;
	local string htmlStr;

	Class'NWindow.PersonalConnectionAPI'.static.GetPvpbookRequiredItem("ShareRevengeCost_Pledge", 1, item_id, nNeedItemNum);
	RevengeConfirmWnd.ShowWindow();
	ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(item_id));
	myItemNum = getInventoryItemNumByClassID(item_id);
	RevengeConfirmCostTitle_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(13060), ItemName));
	RevengeConfirmMyCostTitle_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(13059), ItemName));
	RevengeConfirmCostNum_Txt.SetText(MakeCostString(string(nNeedItemNum)));
	RevengeConfirmMyCostNum_Txt.SetText(MakeCostString(string(myItemNum)));
	htmlStr = ("<html><body>" $ htmlAddText(GetSystemMessage(13318), "", ""));
	if((myItemNum >= nNeedItemNum))
	{
		RevengeConfirmMyCostNum_Txt.SetTextColor(getInstanceL2Util().White);
		RevengeConfirmOk_Btn.EnableWindow();
	}
	else
	{
		RevengeConfirmMyCostNum_Txt.SetTextColor(getInstanceL2Util().Red);
		RevengeConfirmOk_Btn.DisableWindow();
		htmlStr = ((htmlStr $ "<br1>") $ htmlAddText((("(" $ GetSystemMessage(701)) $ ")"), "", "EE7777"));
	}
	htmlStr = (htmlStr $ "</body></html>");
	RevengeConfirmDescTitle_HtmlCtrl.LoadHtmlFromString(htmlStr);
	return;
}

function ShareRanker()
{
	local string ItemName;
	local INT64 nNeedItemNum, myItemNum;
	local int item_id;
	local string htmlStr;

	Class'NWindow.PersonalConnectionAPI'.static.GetPvpbookRequiredItem("ShareRevengeCost_Ranker", 1, item_id, nNeedItemNum);
	RevengeConfirmWnd.ShowWindow();
	ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(item_id));
	myItemNum = getInventoryItemNumByClassID(item_id);
	RevengeConfirmCostTitle_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(13060), ItemName));
	RevengeConfirmMyCostTitle_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(13059), ItemName));
	RevengeConfirmCostNum_Txt.SetText(MakeCostString(string(nNeedItemNum)));
	RevengeConfirmMyCostNum_Txt.SetText(MakeCostString(string(myItemNum)));
	htmlStr = ("<html><body>" $ htmlAddText(GetSystemMessage(13319), "", ""));
	if((myItemNum >= nNeedItemNum))
	{
		RevengeConfirmMyCostNum_Txt.SetTextColor(getInstanceL2Util().White);
		RevengeConfirmOk_Btn.EnableWindow();
	}
	else
	{
		RevengeConfirmMyCostNum_Txt.SetTextColor(getInstanceL2Util().Red);
		RevengeConfirmOk_Btn.DisableWindow();
		htmlStr = ((htmlStr $ "<br1>") $ htmlAddText((("(" $ GetSystemMessage(701)) $ ")"), "", "EE7777"));
	}
	htmlStr = (htmlStr $ "</body></html>");
	RevengeConfirmDescTitle_HtmlCtrl.LoadHtmlFromString(htmlStr);
	return;
}

function ShareTeleportKiller()
{
	local string ItemName;
	local INT64 nNeedItemNum, myItemNum, nKillUserKarmaMin;
	local int item_id, nKillUserKarma, Index, MaxShareTeleport, Sequence;
	local RichListCtrlRowData rowData;
	local string htmlStr;

	ask_state = "ShareTeleportKiller";
	Index = Helpcall_List.GetSelectedIndex();
	Helpcall_List.GetRec(Index, rowData);
	if((Helpcall_List.GetSelectedIndex() <= -1))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(326));
		return;
	}
	if((rowData.cellDataList[2].szData != "2"))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13056));
		return;
	}
	nKillUserKarma = rowData.cellDataList[3].nReserved1;
	MaxShareTeleport = Class'NWindow.PersonalConnectionAPI'.static.GetPvpbookMaxCount("ShareTeleport");
	Class'NWindow.PersonalConnectionAPI'.static.GetPvpbookRequiredItem("ShareRevenge_Karma", 1, item_id, nKillUserKarmaMin);
	Sequence = ((MaxShareTeleport - rowData.cellDataList[0].nReserved1) + 1);
	if((INT64(nKillUserKarma) <= nKillUserKarmaMin))
	{
		Class'NWindow.PersonalConnectionAPI'.static.GetPvpbookRequiredItem("ShareTeleport_Karma", 1, item_id, nNeedItemNum);
	}
	else
	{
		Class'NWindow.PersonalConnectionAPI'.static.GetPvpbookRequiredItem("ShareTeleport", Sequence, item_id, nNeedItemNum);
	}
	RevengeConfirmWnd.ShowWindow();
	ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(item_id));
	myItemNum = getInventoryItemNumByClassID(item_id);
	RevengeConfirmCostTitle_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(13060), ItemName));
	RevengeConfirmMyCostTitle_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(13059), ItemName));
	if((nNeedItemNum > INT64(0)))
	{
		RevengeConfirmCostNum_Txt.SetText(MakeCostString(string(nNeedItemNum)));
	}
	else
	{
		RevengeConfirmCostNum_Txt.SetText(GetSystemString(3983));
	}
	RevengeConfirmMyCostNum_Txt.SetText(MakeCostString(string(myItemNum)));
	htmlStr = ("<html><body>" $ htmlAddText(MakeFullSystemMsg(GetSystemMessage(13320), rowData.cellDataList[0].szData), "", ""));
	if((myItemNum >= nNeedItemNum))
	{
		RevengeConfirmMyCostNum_Txt.SetTextColor(getInstanceL2Util().White);
		RevengeConfirmOk_Btn.EnableWindow();
	}
	else
	{
		RevengeConfirmMyCostNum_Txt.SetTextColor(getInstanceL2Util().Red);
		RevengeConfirmOk_Btn.DisableWindow();
		htmlStr = ((htmlStr $ "<br1>") $ htmlAddText((("(" $ GetSystemMessage(701)) $ ")"), "", "EE7777"));
	}
	htmlStr = (htmlStr $ "</body></html>");
	RevengeConfirmDescTitle_HtmlCtrl.LoadHtmlFromString(htmlStr);
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	if(RevengeConfirmWnd.IsShowWindow())
	{
		RevengeConfirmWnd.HideWindow();
	}
	else
	{
		GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	}
	return;
}
