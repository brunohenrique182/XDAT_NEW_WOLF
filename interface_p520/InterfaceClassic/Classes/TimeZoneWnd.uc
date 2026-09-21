class TimeZoneWnd extends UICommonAPI
	dependson(UIPacket);

const TEAM_MATCH_TYPE = "team_matchingInzone";
const MATCH_TYPE = "matchingInzone";
const TIMER_CLICK = 99902;
const TIMER_DELAYC = 3000;

struct RestrictFieldInfo
{
	var int ResetCycle;
	var int FieldId;
	var int MinLevel;
	var int MaxLevel;
	var int RemainTimeBase;
	var array<int> ItemIDs;
	var array<INT64> ItemCounts;
	var int RemainTime;
	var int RemainTimeMax;
	var int RemainRefillTime;
	var int RefillTimeMax;
	var bool bFieldActivated;
	var int bUserBound;
	var int bCanReEnter;
	var int nIsInZonePCCafeUserOnly;
	var int bWorldInZone;
	var bool CanUseEntranceTicket;
	var int EnteranceCount;
};

var WindowHandle Me;
var WindowHandle ScrollAreaWnd;
var WindowHandle disableWnd;
var WindowHandle UIControlDialogAsset;
var WindowHandle UIControlGroupButtonAsset;
var TextBoxHandle Noti_text;
var ButtonHandle ReFresh_btn;
var ButtonHandle Close_Btn;
var L2Util util;
var int currentSelectedFieldID;
var bool bResultFieldChargeRefresh;
var int nIsPCCafeUser;
var int lastClickPlusButtonPosition;
var UserInfo myInfo;
var bool bShowFirst;
var bool bFirstSetting;
var int gotoAskTimezoneID;
var L2UITweenTwinkleObject twinkleSelectTimezoneObject;
var array<RestrictFieldInfo> RestrictFieldInfos;
var array<RestrictFieldInfo> RestrictFieldInfosWorld;
var INT64 beforeAdenaCount;
var UIControlTilelist scrollTileList;
var UIControlGroupButtonAssets TopGroupButtonAsset;
var UIControlNeedItemList needItemListRenderer0Script;
var UIControlNeedItemList needItemListRenderer1Script;
var UIControlNeedItemList needItemListRenderer2Script;
var UIControlNeedItemList needItemListRenderer3Script;
var UIControlPageNavi pageNavi;
var int nShowTileIndex;
var int _openedMatchingInzoneFieldID;
//var delegate<SortCompare> __SortCompare__Delegate;

event OnRegisterEvent()
{
	RegisterEvent(11190);
	RegisterEvent(11200);
	RegisterEvent(11210);
	RegisterEvent(11230);
	RegisterEvent((100000 + 1045));
	RegisterEvent((100000 + 1087));
	RegisterEvent((100000 + 1086));
	RegisterEvent(11240);
	RegisterEvent(11220);
	RegisterEvent(11250);
	RegisterEvent(180);
	RegisterEvent(9570);
	RegisterEvent(19);
	RegisterEvent(9750);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("TimeZoneWnd");
	ScrollAreaWnd = GetWindowHandle("TimeZoneWnd.ScrollAreaWnd");
	disableWnd = GetWindowHandle("TimeZoneWnd.DisableWnd");
	UIControlDialogAsset = GetWindowHandle("TimeZoneWnd.DisableWnd.UIControlDialogAsset");
	UIControlGroupButtonAsset = GetWindowHandle("TimeZoneWnd.UIControlGroupButtonAsset");
	Noti_text = GetTextBoxHandle("TimeZoneWnd.Noti_text");
	ReFresh_btn = GetButtonHandle("TimeZoneWnd.Refresh_Btn");
	Close_Btn = GetButtonHandle("TimeZoneWnd.Close_Btn");
	util = L2Util(GetScript("L2Util"));
	scrollTileList = Class'InterfaceClassic.UIControlTilelist'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollAreaWnd")), 4, 1);
	scrollTileList.DelegateOnItemRenderer = HandleDelegateOnItemRenderer;
	scrollTileList.DelegateOnClick = HandleDelegateOnClick;
	scrollTileList.DelegateOnRendererClick = HandleDelegateOnClickItemRenderer;
	scrollTileList.DelegateOnScroll = HandleOnScroll;
	scrollTileList.DelegateOnSelect = HandleOnSelect;
	scrollTileList._SetUsePage(true);
	scrollTileList._SetUseSelect(true);
	scrollTileList._SetUseOver(true);
	InitPageNavi();
	InitNeedItem();
	initGroupButton();
	initDialogAssetes();
	return;
}

function InitPageNavi()
{
	local WindowHandle PageNaviControl;

	PageNaviControl = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".PageNavi_Control"));
	PageNaviControl.SetScript("UIControlPageNavi");
	pageNavi = UIControlPageNavi(PageNaviControl.GetScript());
	pageNavi.Init((m_hOwnerWnd.m_WindowNameWithFullPath $ ".PageNavi_Control"));
	pageNavi.DelegateOnClickButton = pageNaviButtonClicked;
	pageNavi.SetNoUseGo(true);
	return;
}

function pageNaviButtonClicked(string strName)
{
	Debug(("strName:" @ strName));
	if((strName == "ControlNavi_PrevBtn"))
	{
		OnPrev_BtnClick();
	}
	else if((strName == "ControlNavi_NextBtn"))
	{
		OnNext_BtnClick();
	}
	return;
}

function initGroupButton()
{
	TopGroupButtonAsset = Class'InterfaceClassic.UIControlGroupButtonAssets'.static._InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".UIControlGroupButtonAsset")));
	TopGroupButtonAsset._SetStartInfo("L2UI_NewTex.WindowTab.FlatBrown_Tab_Left_Unselected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_Left_Selected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_Left_Unselected_Over", true);
	TopGroupButtonAsset._GetGroupButtonsInstance().DelegateOnClickButton = DelegateOnClickButton;
	TopGroupButtonAsset._setDelayTime(500);
	return;
}

function DelegateOnClickButton(string parentWndName, string strName, int Index)
{
	Debug("-----메인 탭-------");  // EN?: -----Main Tab-------
	Debug(("strName" @ parentWndName));
	Debug(("strName" @ strName));
	Debug(("index" @ string(Index)));
	ItemListInfoEnd(true);
	return;
}

function InitNeedItem()
{
	needItemListRenderer0Script = new Class'InterfaceClassic.UIControlNeedItemList';
	needItemListRenderer0Script.SetRichListControler(GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollAreaWnd.ScrollArea.itemRenderer00.TimeZoneCostIcon_RichList")));
	needItemListRenderer1Script = new Class'InterfaceClassic.UIControlNeedItemList';
	needItemListRenderer1Script.SetRichListControler(GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollAreaWnd.ScrollArea.itemRenderer01.TimeZoneCostIcon_RichList")));
	needItemListRenderer2Script = new Class'InterfaceClassic.UIControlNeedItemList';
	needItemListRenderer2Script.SetRichListControler(GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollAreaWnd.ScrollArea.itemRenderer02.TimeZoneCostIcon_RichList")));
	needItemListRenderer3Script = new Class'InterfaceClassic.UIControlNeedItemList';
	needItemListRenderer3Script.SetRichListControler(GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollAreaWnd.ScrollArea.itemRenderer03.TimeZoneCostIcon_RichList")));
	return;
}

function initDialogAssetes()
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = Class'InterfaceClassic.UIControlDialogAssets'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".UIControlDialogAsset")));
	disableWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd"));
	popupExpandScript.SetDisableWindow(disableWnd);
	Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd"), false);
	return;
}

function UIControlDialogAssets GetDialogAssetScript()
{
	local WindowHandle poopExpandWnd;

	poopExpandWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".UIControlDialogAsset"));
	return UIControlDialogAssets(poopExpandWnd.GetScript());
}

function ShowDialogAskEnter(RestrictFieldInfo fieldInfo)
{
	local int i;
	local TimeRestrictFieldUIData fieldUIData;
	local string addMessage;

	DialogHide();
	API_GetTimeRestrictFieldInfo(fieldInfo.FieldId, fieldUIData);
	currentSelectedFieldID = fieldInfo.FieldId;
	if((fieldUIData.Type != "timezone"))
	{
		addMessage = ("<br><br>" $ GetSystemString(13500));
		addMessage = ((addMessage $ "<br>") $ GetSystemString(13035));
	}
	else
	{
		addMessage = ("<br><br>" $ GetSystemString(14170));
		addMessage = ((addMessage $ "<br>") $ GetSystemString(14171));
	}
	GetDialogAssetScript().SetDialogDescHtml((htmlAddText(MakeFullSystemMsg(GetSystemMessage(13009), fieldUIData.FieldName), "hs10", getColorHexString(GTColor().White)) $ htmlAddText(addMessage, "", getColorHexString(GTColor().Green))));
	GetDialogAssetScript().SetUseNeedItem(true);
	GetDialogAssetScript().StartNeedItemList(1);
	i = 0;
	while((i < fieldInfo.ItemIDs.Length))
	{
		if((fieldInfo.ItemIDs[i] == -100))
		{
			GetDialogAssetScript().AddNeedPoint(GetSystemString(1277), GetPcCafeItemIconPackageName(), fieldInfo.ItemCounts[i], INT64(getInstanceUIData().GetCurrentPcCafePoint()));
			i++;
			continue;
		}
		GetDialogAssetScript().AddNeedItemClassID(fieldInfo.ItemIDs[i], fieldInfo.ItemCounts[i]);
		i++;
	}
	if((fieldInfo.ItemIDs.Length == 0))
	{
		GetDialogAssetScript().SetItemNum(0);
		GetDialogAssetScript().OKButton.EnableWindow();
	}
	else
	{
		GetDialogAssetScript().SetItemNum(1);
	}
	GetDialogAssetScript().Show();
	GetDialogAssetScript().DelegateOnClickBuy = onClickDialog;
	GetDialogAssetScript().DelegateOnCancel = OnClickCancelDialog;
	return;
}

function ShowTimeZoneExitDialog()
{
	local WindowHandle disablwWnd;

	DialogHide();
	disablwWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd"));
	disablwWnd.ShowWindow();
	disablwWnd.SetFocus();
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(13704));
	Class'InterfaceClassic.DialogBox'.static.Inst().AnchorToOwner(0, 0);
	Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnOK = OnTimeZoneExitDialogConfirm;
	Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnHide = OnTimeZoneExitDialogHide;
	Class'InterfaceClassic.DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
	return;
}

event OnClickTimeZoneExit()
{
	ShowTimeZoneExitDialog();
	return;
}

event OnTimeZoneExitDialogConfirm()
{
	Rq_C_EX_TIME_RESTRICT_FIELD_USER_LEAVE();
	return;
}

event OnTimeZoneExitDialogHide()
{
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWnd")).HideWindow();
	return;
}

function onClickDialog()
{
	GetDialogAssetScript().Hide();
	if(IsPlayerOnWorldRaidServer())
	{
		API_C_EX_TIME_RESTRICT_FIELD_HOST_USER_LEAVE(NoticeHUD(GetScript("NoticeHud")).getTimeZoneCurrentFieldID(), currentSelectedFieldID);
	}
	else
	{
		API_RequestEnterTimeRestrictField(currentSelectedFieldID);
	}
	return;
}

function OnClickCancelDialog()
{
	GetDialogAssetScript().Hide();
	return;
}

function UpdateOpenedMatchingInzoneInfo()
{
	_openedMatchingInzoneFieldID = NoticeHUD(GetScript("NoticeHUD")).GetOpenedMatchingInzoneFieldID();
	return;
}

function ShowBySideBar(optional int gotoAskEnterFieldID)
{
	Debug(("ShowBySideBar, gotoAskEnterFieldID : " @ string(gotoAskEnterFieldID)));
	gotoAskTimezoneID = gotoAskEnterFieldID;
	bShowFirst = true;
	beforeAdenaCount = GetAdena();
	GetPlayerInfo(myInfo);
	if(disableWnd.IsShowWindow())
	{
		disableWnd.HideWindow();
	}
	API_RequestTimeRestrictFieldList();
	lastClickPlusButtonPosition = -1;
	return;
}

event OnShow()
{
	SideBar(GetScript("SideBar")).ToggleByWindowName("TimeZoneWnd", true);
	Me.SetFocus();
	return;
}

event OnHide()
{
	currentSelectedFieldID = -1;
	nShowTileIndex = -1;
	scrollTileList._SetSelect(-1);
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TimeZoneSubWnd");
	DialogHide();
	twinkleSelectTimezoneObject._Stop();
	SideBar(GetScript("SideBar")).ToggleByWindowName("TimeZoneWnd", false);
	return;
}

function setCategoryTab()
{
	if(true)
	{
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(0, GetSystemString(441));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(1, GetSystemString(14093));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(0, 0);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(1, 1);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(1, "L2UI_NewTex.WindowTab.FlatBlue_Tab_Right_Unselected", "L2UI_NewTex.WindowTab.FlatBlue_Tab_Right_Selected", "L2UI_NewTex.WindowTab.FlatBlue_Tab_Right_Unselected_Over");
		TopGroupButtonAsset._GetGroupButtonsInstance()._setShowButtonNum(2);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setAutoWidth(1060, 0);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(0, true);
	}
	else
	{
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(0, GetSystemString(2611));
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(0, 0);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(0, "L2UI_NewTex.WindowTab.FlatBrown_Tab_One_Unselected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_One_Selected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_One_Unselected_Over");
		TopGroupButtonAsset._GetGroupButtonsInstance()._setShowButtonNum(1);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setAutoWidth(1058, 0);
		TopGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(0, true);
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Refresh_Btn":
			OnReFresh_btnClick();
			break;
		case "Close_Btn":
			OnClose_BtnClick();
			break;
		case "Prev_Btn":
			OnPrev_BtnClick(true);
			break;
		case "Next_Btn":
			OnNext_BtnClick(true);
			break;
		default:
			break;
	}
	return;
}

function OnReFresh_btnClick()
{
	API_RequestTimeRestrictFieldList();
	return;
}

function OnClose_BtnClick()
{
	Me.HideWindow();
	return;
}

function OnPrev_BtnClick(optional bool bUpdate)
{
	scrollTileList._PrevPage();
	prevNextButtonState();
	return;
}

function OnNext_BtnClick(optional bool bUpdate)
{
	scrollTileList._NextPage();
	prevNextButtonState();
	return;
}

function prevNextButtonState()
{
	local int Page;

	Page = scrollTileList._Page();
	if((Page <= 0))
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Prev_Btn")).DisableWindow();
	}
	else
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Prev_Btn")).EnableWindow();
	}
	if((Page >= scrollTileList._PageMax()))
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Next_Btn")).DisableWindow();
	}
	else
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Next_Btn")).EnableWindow();
	}
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 11190:
			Debug(("EV_TimeRestrictFieldListStart" @ param));
			ClearAll();
			break;
		case 11200:
			Debug(("EV_TimeRestrictFieldInfo" @ param));
			HandleItemList(param);
			break;
		case 11210:
			Debug(("EV_TimeRestrictFieldListEnd" @ param));
			UpdateOpenedMatchingInzoneInfo();
			ItemListInfoEnd();
			break;
		case 11230:
			HandleResultFieldCharge(param);
			break;
		case EV_PacketID(1045):
			HandleTimeRestrictFieldEnterInfo();
			break;
		case EV_PacketID(1087):
			Handle_S_EX_TIME_RESTRICT_FIELD_HOST_USER_LEAVE();
			break;
		case EV_PacketID(1086):
			Handle_S_EX_TIME_RESTRICT_FIELD_HOST_USER_ENTER();
			break;
		case 11240:
			HandleResultFieldAlarm(param);
			break;
		case 11220:
			HandleEnterResult(param);
			break;
		case 11250:
			Me.HideWindow();
			break;
		case 9570:
			if(Me.IsShowWindow())
			{
				Class'InterfaceClassic.L2UITimer'.static.Inst()._AddTimerOnce(1)._DelegateOnTime = OnTimeAdenCount;
			}
			break;
		case 180:
			if((Me.IsShowWindow() && (getInstanceUIData().IsLevelUP() || getInstanceUIData().IsLevelDown())))
			{
				HandleUserInfo();
			}
			break;
		case 19:
			ParseInt(param, "id", gotoAskTimezoneID);
			ShowBySideBar(gotoAskTimezoneID);
			break;
		case 9750:
			setCategoryTab();
			nShowTileIndex = -1;
			bFirstSetting = true;
			break;
		default:
			break;
	}
	return;
}

function OnTimeAdenCount(int Count)
{
	if((GetAdena() != beforeAdenaCount))
	{
		bResultFieldChargeRefresh = true;
		scrollTileList._Refresh();
		bResultFieldChargeRefresh = false;
	}
	beforeAdenaCount = GetAdena();
	return;
}

function HandleUserInfo()
{
	GetPlayerInfo(myInfo);
	GetDialogAssetScript().Hide();
	API_RequestTimeRestrictFieldList();
	scrollTileList._Refresh();
	return;
}

function updateFieldRemainTime(int nFieldID, int nRemainTime)
{
	local int i;

	i = 0;
	while((i < RestrictFieldInfos.Length))
	{
		if((RestrictFieldInfos[i].FieldId == nFieldID))
		{
			RestrictFieldInfos[i].RemainTime = nRemainTime;
			return;
		}
		i++;
	}
	i = 0;
	while((i < RestrictFieldInfosWorld.Length))
	{
		if((RestrictFieldInfosWorld[i].FieldId == nFieldID))
		{
			RestrictFieldInfosWorld[i].RemainTime = nRemainTime;
			return;
		}
		i++;
	}
	return;
}

function int getIndexByFieldID(int nFieldID)
{
	local int i;

	if((TopGroupButtonAsset._GetGroupButtonsInstance()._getSelectButtonIndex() == 0))
	{
		i = 0;
		while((i < RestrictFieldInfos.Length))
		{
			if((RestrictFieldInfos[i].FieldId == nFieldID))
			{
				return i;
			}
			i++;
		}
	}
	else
	{
		i = 0;
		while((i < RestrictFieldInfosWorld.Length))
		{
			if((RestrictFieldInfosWorld[i].FieldId == nFieldID))
			{
				return i;
			}
			i++;
		}
	}
	return -1;
}

function setFindCurrentTop(int nFieldID)
{
	local int i;

	i = 0;
	while((i < RestrictFieldInfos.Length))
	{
		if((RestrictFieldInfos[i].FieldId == nFieldID))
		{
			TopGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(0, true);
			return;
		}
		i++;
	}
	i = 0;
	while((i < RestrictFieldInfosWorld.Length))
	{
		if((RestrictFieldInfosWorld[i].FieldId == nFieldID))
		{
			TopGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(1, true);
			return;
		}
		i++;
	}
	return;
}

function HandleResultFieldAlarm(string param)
{
	local int FieldId, RemainTime;

	ParseInt(param, "FieldID", FieldId);
	ParseInt(param, "RemainTime", RemainTime);
	Debug(("--> HandleResultFieldAlarm : " @ param));
	updateFieldRemainTime(FieldId, RemainTime);
	scrollTileList._Refresh();
	return;
}

function HandleEnterResult(string param)
{
	local int bEnterSuccess;

	ParseInt(param, "bEnterSuccess", bEnterSuccess);
	if((bEnterSuccess == 1))
	{
		Me.HideWindow();
	}
	else
	{
		GetDialogAssetScript().Hide();
	}
	return;
}

function updateFieldRefillTime(int nFieldID, int nRemainTime, int nResultRefillTime)
{
	local int i;

	i = 0;
	while((i < RestrictFieldInfos.Length))
	{
		if((RestrictFieldInfos[i].FieldId == nFieldID))
		{
			RestrictFieldInfos[i].RemainTime = nRemainTime;
			RestrictFieldInfos[i].RemainRefillTime = nResultRefillTime;
			return;
		}
		i++;
	}
	i = 0;
	while((i < RestrictFieldInfosWorld.Length))
	{
		if((RestrictFieldInfosWorld[i].FieldId == nFieldID))
		{
			RestrictFieldInfosWorld[i].RemainTime = nRemainTime;
			RestrictFieldInfosWorld[i].RemainRefillTime = nResultRefillTime;
			return;
		}
		i++;
	}
	return;
}

function updateFieldEnterInfo(int nFieldID, bool CanUseEntranceTicket, int EnteranceCount)
{
	local int i;

	i = 0;
	while((i < RestrictFieldInfos.Length))
	{
		if((RestrictFieldInfos[i].FieldId == nFieldID))
		{
			RestrictFieldInfos[i].CanUseEntranceTicket = CanUseEntranceTicket;
			RestrictFieldInfos[i].EnteranceCount = EnteranceCount;
			return;
		}
		i++;
	}
	i = 0;
	while((i < RestrictFieldInfosWorld.Length))
	{
		if((RestrictFieldInfosWorld[i].FieldId == nFieldID))
		{
			RestrictFieldInfosWorld[i].CanUseEntranceTicket = CanUseEntranceTicket;
			RestrictFieldInfosWorld[i].EnteranceCount = EnteranceCount;
			return;
		}
		i++;
	}
	return;
}

function HandleResultFieldCharge(string param)
{
	local int FieldId, RemainTime, ResultRefillTime, resultChargeTime;
	local TimeRestrictFieldUIData fieldUIData;
	local string gfxScreenMsg;

	ParseInt(param, "FieldID", FieldId);
	ParseInt(param, "RemainTime", RemainTime);
	ParseInt(param, "ResultRefillTime", ResultRefillTime);
	ParseInt(param, "ResultChargeTime", resultChargeTime);
	updateFieldRefillTime(FieldId, RemainTime, ResultRefillTime);
	bResultFieldChargeRefresh = true;
	scrollTileList._Refresh();
	bResultFieldChargeRefresh = false;
	API_GetTimeRestrictFieldInfo(FieldId, fieldUIData);
	gfxScreenMsg = MakeFullSystemMsg(GetSystemMessage(13008), fieldUIData.FieldName, string((resultChargeTime / 60)));
	getInstanceL2Util().showGfxScreenMessage(gfxScreenMsg);
	Debug(((((("--> HandleResultFieldCharge" @ param) @ string(FieldId)) @ string(RemainTime)) @ string(ResultRefillTime)) @ string(resultChargeTime)));
	return;
}

function Handle_S_EX_TIME_RESTRICT_FIELD_HOST_USER_LEAVE()
{
	local UIPacket._S_EX_TIME_RESTRICT_FIELD_HOST_USER_LEAVE packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_TIME_RESTRICT_FIELD_HOST_USER_LEAVE(packet))
	{
		return;
	}
	Debug("--> Decode_S_EX_TIME_RESTRICT_FIELD_HOST_USER_LEAVE");
	Debug(("packet.nResult" @ string(packet.nResult)));
	Debug(("packet.nLeaveFieldID" @ string(packet.nLeaveFieldID)));
	Debug(("packet.nNextEnterFieldID" @ string(packet.nNextEnterFieldID)));
	if((packet.nResult > 0))
	{
		API_C_EX_TIME_RESTRICT_FIELD_HOST_USER_ENTER(packet.nNextEnterFieldID);
	}
	return;
}

function Handle_S_EX_TIME_RESTRICT_FIELD_HOST_USER_ENTER()
{
	local UIPacket._S_EX_TIME_RESTRICT_FIELD_HOST_USER_ENTER packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_TIME_RESTRICT_FIELD_HOST_USER_ENTER(packet))
	{
		return;
	}
	Debug("--> Decode_S_EX_TIME_RESTRICT_FIELD_HOST_USER_ENTER");
	Debug(("packet.nResult" @ string(packet.nResult)));
	Debug(("packet.nEnteredFieldID" @ string(packet.nEnteredFieldID)));
	if((packet.nResult > 0))
	{
	}
	Me.HideWindow();
	return;
}

function HandleTimeRestrictFieldEnterInfo()
{
	local UIPacket._S_EX_TIME_RESTRICT_FIELD_ENTER_INFO packet;
	local int i;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_TIME_RESTRICT_FIELD_ENTER_INFO(packet))
	{
		return;
	}
	i = 0;
	while((i < packet.vEnterGroupFieldIDList.Length))
	{
		Debug(("--> HandleTimeRestrictFieldEnterInfo FieldID: " @ string(packet.vEnterGroupFieldIDList[i])));
		updateFieldEnterInfo(packet.vEnterGroupFieldIDList[i], numToBool(int(packet.bCanUseEntranceTicket)), packet.nEntranceCount);
		i++;
	}
	bResultFieldChargeRefresh = true;
	scrollTileList._Refresh();
	bResultFieldChargeRefresh = false;
	getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13694));
	Debug((("--> HandleTimeRestrictFieldEnterInfo" @ string(packet.bCanUseEntranceTicket)) @ string(packet.nEntranceCount)));
	return;
}

function ClearAll()
{
	RestrictFieldInfos.Length = 0;
	RestrictFieldInfosWorld.Length = 0;
	GetPlayerInfo(myInfo);
	twinkleSelectTimezoneObject._Stop();
	return;
}

function HandleItemList(string param)
{
	local RestrictFieldInfo fieldInfo;
	local int i, tmpBFieldActivated, Count, nCanUseEntranceTicket;

	ParseInt(param, "ResetCycle", fieldInfo.ResetCycle);
	ParseInt(param, "FieldId", fieldInfo.FieldId);
	ParseInt(param, "MinLevel", fieldInfo.MinLevel);
	ParseInt(param, "MaxLevel", fieldInfo.MaxLevel);
	ParseInt(param, "RemainTimeBase", fieldInfo.RemainTimeBase);
	ParseInt(param, "RequiredItemCnt", Count);
	ParseInt(param, "bIsInZonePCCafeUserOnly", fieldInfo.nIsInZonePCCafeUserOnly);
	ParseInt(param, "bIsPCCafeUser", nIsPCCafeUser);
	ParseInt(param, "bWorldInZone", fieldInfo.bWorldInZone);
	fieldInfo.ItemIDs.Length = Count;
	fieldInfo.ItemCounts.Length = Count;
	i = 0;
	while((i < Count))
	{
		ParseInt(param, ("ItemID" $ string(i)), fieldInfo.ItemIDs[i]);
		ParseINT64(param, ("ItemAmount" $ string(i)), fieldInfo.ItemCounts[i]);
		i++;
	}
	ParseInt(param, "RemainTime", fieldInfo.RemainTime);
	ParseInt(param, "RemainTimeMax", fieldInfo.RemainTimeMax);
	ParseInt(param, "RemainRefillTime", fieldInfo.RemainRefillTime);
	ParseInt(param, "RefillTimeMax", fieldInfo.RefillTimeMax);
	ParseInt(param, "FieldActivated", tmpBFieldActivated);
	ParseInt(param, "bUserBound", fieldInfo.bUserBound);
	ParseInt(param, "bCanReEnter", fieldInfo.bCanReEnter);
	ParseInt(param, "bCanUseEntranceTicket", nCanUseEntranceTicket);
	ParseInt(param, "EntranceCount", fieldInfo.EnteranceCount);
	fieldInfo.CanUseEntranceTicket = numToBool(nCanUseEntranceTicket);
	fieldInfo.bFieldActivated = (tmpBFieldActivated > 0);
	GetPlayerInfo(myInfo);
	if((fieldInfo.bWorldInZone > 0))
	{
		RestrictFieldInfosWorld.Length = (RestrictFieldInfosWorld.Length + 1);
		RestrictFieldInfosWorld[(RestrictFieldInfosWorld.Length - 1)] = fieldInfo;
	}
	else if((myInfo.nLevel <= fieldInfo.MaxLevel))
	{
		RestrictFieldInfos.Length = (RestrictFieldInfos.Length + 1);
		RestrictFieldInfos[(RestrictFieldInfos.Length - 1)] = fieldInfo;
	}
	return;
}

function ItemListInfoEnd(optional bool bDirectRun)
{
	// RestrictFieldInfos.Sort(SortCompare);   // array.Sort() unsupported by this compiler
	// RestrictFieldInfosWorld.Sort(SortCompare);   // array.Sort() unsupported by this compiler
	GetPlayerInfo(myInfo);
	if((bShowFirst && (bDirectRun == false)))
	{
		if((gotoAskTimezoneID == 0))
		{
			setFindCurrentTop(NoticeHUD(GetScript("NoticeHud")).getTimeZoneCurrentFieldID());
		}
		else
		{
			setFindCurrentTop(gotoAskTimezoneID);
		}
	}
	if((TopGroupButtonAsset._GetGroupButtonsInstance()._getSelectButtonIndex() == 0))
	{
		scrollTileList._SetTileListItemNumTotal(RestrictFieldInfos.Length);
		if(bDirectRun)
		{
			nShowTileIndex = -1;
		}
		else if((gotoAskTimezoneID == 0))
		{
			nShowTileIndex = getIndexByFieldID(NoticeHUD(GetScript("NoticeHud")).getTimeZoneCurrentFieldID());
		}
		else
		{
			nShowTileIndex = getIndexByFieldID(gotoAskTimezoneID);
		}
		pageNavi.SetTotalPage((scrollTileList._PageMax() + 1));
		scrollTileList._SetSelect(nShowTileIndex, true);
		if(((bShowFirst == false) || bFirstSetting))
		{
			pageNavi.Go(1);
		}
		pageNavi.BtnCheck();
	}
	else
	{
		scrollTileList._SetTileListItemNumTotal(RestrictFieldInfosWorld.Length);
		if(bDirectRun)
		{
			nShowTileIndex = -1;
		}
		else if((gotoAskTimezoneID == 0))
		{
			nShowTileIndex = getIndexByFieldID(NoticeHUD(GetScript("NoticeHud")).getTimeZoneCurrentFieldID());
		}
		else
		{
			nShowTileIndex = getIndexByFieldID(gotoAskTimezoneID);
		}
		pageNavi.SetTotalPage((scrollTileList._PageMax() + 1));
		scrollTileList._SetSelect(nShowTileIndex, true);
		if(((bShowFirst == false) || bFirstSetting))
		{
			pageNavi.Go(1);
		}
		pageNavi.BtnCheck();
	}
	bShowFirst = false;
	bFirstSetting = false;
	if((Me.IsShowWindow() == false))
	{
		Me.ShowWindow();
	}
	if((gotoAskTimezoneID > 0))
	{
	}
	return;
}

function HandleDelegateOnItemRenderer(string itemRendererID, int rendererIndex, int Position)
{
	local int i, diceIndex, currentZoneId;
	local TimeRestrictFieldUIData fieldUIData;
	local UIControlNeedItemList currentNeedItemListRendererScript;
	local array<RestrictFieldInfo> currentRestrictFieldInfos;
	local bool canEnter, canEnterNeedItem, isTeamMatchingEnterReady;
	local int teamMatchingEntryTime;
	local ButtonHandle enterBtn, ExitBtn;
	local TextBoxHandle entryTimeTextBox;

	enterBtn = GetButtonHandle((itemRendererID $ ".TimeZoneEnter_Btn"));
	ExitBtn = GetButtonHandle((itemRendererID $ ".TimeZoneExit_Btn"));
	currentZoneId = NoticeHUD(GetScript("NoticeHud")).getTimeZoneCurrentFieldID();
	entryTimeTextBox = GetTextBoxHandle((itemRendererID $ ".ZoneEnterDsc_Text"));
	entryTimeTextBox.HideWindow();
	if((Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("TimeZoneWnd") == false))
	{
		return;
	}
	if((Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("TimeZoneSubWnd") && (bResultFieldChargeRefresh == false)))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TimeZoneSubWnd");
	}
	diceIndex = int((float(Position) % float(scrollTileList._GetItemRendererNum())));
	canEnter = true;
	if((Position >= scrollTileList._GetItemNumTotal()))
	{
		GetWindowHandle(itemRendererID).HideWindow();
	}
	else
	{
		GetWindowHandle(itemRendererID).ShowWindow();
		if((TopGroupButtonAsset._GetGroupButtonsInstance()._getSelectButtonIndex() == 0))
		{
			currentRestrictFieldInfos = RestrictFieldInfos;
			enterBtn.SetTexture("L2UI_NewTex.Button.SimpleBtnBrown_DF", "L2UI_NewTex.Button.SimpleBtnBrown_Down", "L2UI_NewTex.Button.SimpleBtnBrown_Over");
		}
		else
		{
			currentRestrictFieldInfos = RestrictFieldInfosWorld;
			enterBtn.SetTexture("L2UI_NewTex.Button.SimpleBtnBlue_DF", "L2UI_NewTex.Button.SimpleBtnBlue_Down", "L2UI_NewTex.Button.SimpleBtnBlue_Over");
		}
		API_GetTimeRestrictFieldInfo(currentRestrictFieldInfos[Position].FieldId, fieldUIData);
		switch(rendererIndex)
		{
			case 0:
				currentNeedItemListRendererScript = needItemListRenderer0Script;
				break;
			case 1:
				currentNeedItemListRendererScript = needItemListRenderer1Script;
				break;
			case 2:
				currentNeedItemListRendererScript = needItemListRenderer2Script;
				break;
			case 3:
				currentNeedItemListRendererScript = needItemListRenderer3Script;
				break;
			default:
				break;
		}
		currentNeedItemListRendererScript.StartNeedItemList(1);
		i = 0;
		while((i < currentRestrictFieldInfos[Position].ItemIDs.Length))
		{
			if((currentRestrictFieldInfos[Position].ItemIDs[i] == -100))
			{
				currentNeedItemListRendererScript.AddNeedPoint(GetSystemString(1277), GetPcCafeItemIconPackageName(), currentRestrictFieldInfos[Position].ItemCounts[i], INT64(getInstanceUIData().GetCurrentPcCafePoint()));
				i++;
				continue;
			}
			currentNeedItemListRendererScript.AddNeedItemClassID(currentRestrictFieldInfos[Position].ItemIDs[i], currentRestrictFieldInfos[Position].ItemCounts[i]);
			i++;
		}
		currentNeedItemListRendererScript.SetBuyNum(INT64(1));
		if(fieldUIData.IsEvent)
		{
			GetTextureHandle((itemRendererID $ ".EventRibbon_Tex")).ShowWindow();
		}
		else
		{
			GetTextureHandle((itemRendererID $ ".EventRibbon_Tex")).HideWindow();
		}
		switch(fieldUIData.PvpType)
		{
			case 0:
				GetTextBoxHandle((itemRendererID $ ".ZonePlayType_Text")).SetText(GetSystemString(14097));
				GetTextBoxHandle((itemRendererID $ ".ZonePlayType_Text")).SetTextColor(GTColor().White);
				break;
			case 1:
				GetTextBoxHandle((itemRendererID $ ".ZonePlayType_Text")).SetText(GetSystemString(14096));
				GetTextBoxHandle((itemRendererID $ ".ZonePlayType_Text")).SetTextColor(GTColor().Red);
				break;
			default:
				GetTextBoxHandle((itemRendererID $ ".ZonePlayType_Text")).SetText(GetSystemString(14098));
				GetTextBoxHandle((itemRendererID $ ".ZonePlayType_Text")).SetTextColor(GTColor().Green);
				break;
		}
		GetTextureHandle((itemRendererID $ ".ZoneImg_Tex")).SetTexture(fieldUIData.FieldImage);
		GetTextureHandle((itemRendererID $ ".ZoneImg_Tex")).SetTooltipCustomType(MakeTooltipSimpleText(fieldUIData.Desc, 300));
		canEnter = GetBoolListCondition(currentRestrictFieldInfos[Position].MinLevel, currentRestrictFieldInfos[Position].MaxLevel, currentRestrictFieldInfos[Position].RemainTime, currentRestrictFieldInfos[Position].bFieldActivated, fieldUIData.Type, currentRestrictFieldInfos[Position].bUserBound, currentRestrictFieldInfos[Position].bCanReEnter, currentRestrictFieldInfos[Position].nIsInZonePCCafeUserOnly, currentRestrictFieldInfos[Position].FieldId);
		if((currentNeedItemListRendererScript.NeedItemRichListCtrl.GetRecordCount() == 0))
		{
			canEnterNeedItem = true;
		}
		else
		{
			canEnterNeedItem = currentNeedItemListRendererScript.GetCanBuy();
		}
		canEnter = (canEnter && canEnterNeedItem);
		enterBtn.SetTooltipCustomType(MakeTooltipSimpleText(""));
		if(canEnter)
		{
			enterBtn.EnableWindow();
			GetWindowHandle((itemRendererID $ ".TimeZoneDisable_wnd")).HideWindow();
			if((((currentRestrictFieldInfos[Position].bUserBound == 1) && ((fieldUIData.Type == "matchingInzone") || (fieldUIData.Type == "team_matchingInzone"))) && (_openedMatchingInzoneFieldID == currentRestrictFieldInfos[Position].FieldId)))
			{
				enterBtn.SetButtonName(14965);
				enterBtn.SetTexture("L2UI_NewTex.Button.SimpleBtnGreen_DF", "L2UI_NewTex.Button.SimpleBtnGreen_Down", "L2UI_NewTex.Button.SimpleBtnGreen_Over");
			}
			else if((fieldUIData.Type == "team_matchingInzone"))
			{
				if(CheckScheduledTimeRestrictFieldUserEnterPacket(fieldUIData.FieldId, teamMatchingEntryTime))
				{
					entryTimeTextBox.SetText(GetTeamMatchingEntryTimeStr(teamMatchingEntryTime));
					entryTimeTextBox.ShowWindow();
					enterBtn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14967)));
					enterBtn.SetButtonName(14960);
					enterBtn.SetTexture("L2UI_NewTex.Button.SimpleBtnRed_DF", "L2UI_NewTex.Button.SimpleBtnRed_Down", "L2UI_NewTex.Button.SimpleBtnRed_Over");
				}
				else
				{
					enterBtn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14967)));
					enterBtn.SetButtonName(14959);
				}
			}
			else
			{
				enterBtn.SetButtonName(13033);
			}
		}
		else
		{
			enterBtn.DisableWindow();
			enterBtn.SetButtonName(14114);
			GetWindowHandle((itemRendererID $ ".TimeZoneDisable_wnd")).SetTooltipType("text");
			GetWindowHandle((itemRendererID $ ".TimeZoneDisable_wnd")).SetTooltipCustomType(MakeTooltipSimpleText(fieldUIData.Desc, 300));
			if(((nIsPCCafeUser == 0) && (currentRestrictFieldInfos[Position].nIsInZonePCCafeUserOnly == 1)))
			{
				GetWindowHandle((itemRendererID $ ".TimeZoneDisable_wnd")).ShowWindow();
				GetTextBoxHandle((itemRendererID $ ".TimeZoneDisable_wnd.DisableDescrip_txt")).SetText(GetSystemString(14099));
			}
			else if((currentRestrictFieldInfos[Position].bFieldActivated == false))
			{
				GetWindowHandle((itemRendererID $ ".TimeZoneDisable_wnd")).ShowWindow();
				GetTextBoxHandle((itemRendererID $ ".TimeZoneDisable_wnd.DisableDescrip_txt")).SetText(fieldUIData.TimeInfo);
			}
			else if((myInfo.nLevel < currentRestrictFieldInfos[Position].MinLevel))
			{
				GetWindowHandle((itemRendererID $ ".TimeZoneDisable_wnd")).ShowWindow();
				GetTextBoxHandle((itemRendererID $ ".TimeZoneDisable_wnd.DisableDescrip_txt")).SetText(MakeFullSystemMsg(GetSystemMessage(6170), string(currentRestrictFieldInfos[Position].MinLevel)));
			}
			else
			{
				GetWindowHandle((itemRendererID $ ".TimeZoneDisable_wnd")).HideWindow();
			}
		}
		switch(currentRestrictFieldInfos[Position].ResetCycle)
		{
			case 0:
				GetTextBoxHandle((itemRendererID $ ".ZoneOpenTitle_Text")).SetText(GetSystemString(3580));
				GetTextBoxHandle((itemRendererID $ ".ZoneOpenTitle_Text")).SetTextColor(GetColor(255, 161, 161, 255));
				break;
			case 1:
				GetTextBoxHandle((itemRendererID $ ".ZoneOpenTitle_Text")).SetText(GetSystemString(3579));
				GetTextBoxHandle((itemRendererID $ ".ZoneOpenTitle_Text")).SetTextColor(GetColor(255, 255, 187, 255));
				break;
			default:
				break;
		}
		GetTextBoxHandle((itemRendererID $ ".ZoneNameTitle_Text")).SetText(fieldUIData.FieldName);
		GetTextBoxHandle((itemRendererID $ ".ZoneLV_Text")).SetText(MakeLevelMinMax(currentRestrictFieldInfos[Position].MinLevel, currentRestrictFieldInfos[Position].MaxLevel));
		GetButtonHandle((itemRendererID $ ".TimeZoneHelp_Btn")).SetTooltipCustomType(MakeTooltipSimpleText(fieldUIData.Desc, 300));
		if((fieldUIData.Type == "timezone"))
		{
			GetTextBoxHandle((itemRendererID $ ".TimeZoneTimeNowTitle_Txt")).SetText(GetSystemString(14100));
			GetTextBoxHandle((itemRendererID $ ".TimeZoneChargeTimeTitle_Txt")).SetText(GetSystemString(13027));
			GetTextBoxHandle((itemRendererID $ ".TimeZoneTimeNow_Txt")).SetText(util.GetTimeStringBySec6(currentRestrictFieldInfos[Position].RemainTime));
			GetTextBoxHandle((itemRendererID $ ".TimeZoneChargeTime_Txt")).SetText(util.GetTimeStringBySec6(currentRestrictFieldInfos[Position].RemainRefillTime));
			if((currentRestrictFieldInfos[Position].RemainTime == 0))
			{
				GetTextBoxHandle((itemRendererID $ ".TimeZoneTimeNow_Txt")).SetTextColor(util.Gray);
			}
			else
			{
				GetTextBoxHandle((itemRendererID $ ".TimeZoneTimeNow_Txt")).SetTextColor(util.BrightWhite);
			}
			if((currentRestrictFieldInfos[Position].RemainRefillTime == 0))
			{
				GetTextBoxHandle((itemRendererID $ ".TimeZoneChargeTime_Txt")).SetTextColor(util.Gray);
			}
			else
			{
				GetTextBoxHandle((itemRendererID $ ".TimeZoneChargeTime_Txt")).SetTextColor(util.BrightWhite);
			}
			GetTextureHandle((itemRendererID $ ".ZoneTypeIcon_Tex")).SetTexture("L2UI_NewTex.Icon.TimeZone");
			GetTextureHandle((itemRendererID $ ".ZoneTypeIcon_Tex")).SetTooltipText(GetSystemString(14094));
		}
		else
		{
			GetTextBoxHandle((itemRendererID $ ".TimeZoneTimeNowTitle_Txt")).SetText(GetSystemString(14101));
			GetTextBoxHandle((itemRendererID $ ".TimeZoneChargeTimeTitle_Txt")).SetText(GetSystemString(14113));
			GetTextureHandle((itemRendererID $ ".ZoneTypeIcon_Tex")).SetTexture("L2UI_NewTex.Icon.InstanceZone");
			GetTextureHandle((itemRendererID $ ".ZoneTypeIcon_Tex")).SetTooltipText(GetSystemString(2668));
			if(currentRestrictFieldInfos[Position].CanUseEntranceTicket)
			{
				GetTextBoxHandle((itemRendererID $ ".TimeZoneChargeTime_Txt")).SetText(GetSystemString(459));
				GetTextBoxHandle((itemRendererID $ ".TimeZoneChargeTime_Txt")).SetTextColor(util.BrightWhite);
			}
			else
			{
				GetTextBoxHandle((itemRendererID $ ".TimeZoneChargeTime_Txt")).SetText(GetSystemString(13214));
				GetTextBoxHandle((itemRendererID $ ".TimeZoneChargeTime_Txt")).SetTextColor(util.Gray);
			}
			GetTextBoxHandle((itemRendererID $ ".TimeZoneTimeNow_Txt")).SetText((string(currentRestrictFieldInfos[Position].EnteranceCount) @ GetSystemString(3295)));
			if((currentRestrictFieldInfos[Position].EnteranceCount == 0))
			{
				GetTextBoxHandle((itemRendererID $ ".TimeZoneTimeNow_Txt")).SetTextColor(util.Gray);
			}
			else
			{
				GetTextBoxHandle((itemRendererID $ ".TimeZoneTimeNow_Txt")).SetTextColor(util.BrightWhite);
			}
		}
		if((currentRestrictFieldInfos[Position].nIsInZonePCCafeUserOnly == 1))
		{
			GetTextureHandle((itemRendererID $ ".PCZone_Tex")).ShowWindow();
			GetTextureHandle((itemRendererID $ ".PCZone_Tex")).SetTooltipType("text");
			GetTextureHandle((itemRendererID $ ".PCZone_Tex")).SetTooltipText(GetSystemString(14099));
		}
		else
		{
			GetTextureHandle((itemRendererID $ ".PCZone_Tex")).HideWindow();
		}
		if((currentZoneId > 0))
		{
			if((TopGroupButtonAsset._GetGroupButtonsInstance()._getSelectButtonIndex() == 0))
			{
				enterBtn.DisableWindow();
			}
			else if((TopGroupButtonAsset._GetGroupButtonsInstance()._getSelectButtonIndex() == 1))
			{
				if((IsPlayerOnWorldRaidServer() == false))
				{
					enterBtn.DisableWindow();
				}
			}
			if(((fieldUIData.Type == "timezone") && (currentZoneId == fieldUIData.FieldId)))
			{
				enterBtn.HideWindow();
				ExitBtn.ShowWindow();
			}
			else
			{
				enterBtn.ShowWindow();
				ExitBtn.HideWindow();
			}
		}
		else
		{
			enterBtn.ShowWindow();
			ExitBtn.HideWindow();
		}
	}
	return;
}

function HandleOnSelect(string itemRendererID, int rendererIndex, int itemIndex)
{
	if((gotoAskTimezoneID == 0))
	{
		twinkleSelectTimezoneObject._Stop();
	}
	else
	{
		twinkleSelectTimezoneObject._Stop();
		twinkleSelectTimezoneObject = Class'InterfaceClassic.L2UITween'.static.Inst()._AddTweenTwinlkle(GetWindowHandle((scrollTileList._GetRendererPath(rendererIndex) $ ".SelectTexture")), 9999999.0000000, 0.5000000, 1200.0000000, 0, 255, 0.0000000);
	}
	gotoAskTimezoneID = 0;
	return;
}

function HandleOnScroll()
{
	if((gotoAskTimezoneID == 0))
	{
		twinkleSelectTimezoneObject._Stop();
	}
	pageNavi.setPageText((scrollTileList._Page() + 1));
	prevNextButtonState();
	return;
}

function HandleDelegateOnClickItemRenderer(string rendererPath, int rendererIndex, int itemIndex)
{
	return;
}

function HandleDelegateOnClick(string BTNID, int rendererIndex, int Position)
{
	local array<RestrictFieldInfo> currentRestrictFieldInfos;
	local TimeRestrictFieldUIData fieldUIData;
	local int outEntryTime;

	twinkleSelectTimezoneObject._Stop();
	if((TopGroupButtonAsset._GetGroupButtonsInstance()._getSelectButtonIndex() == 0))
	{
		currentRestrictFieldInfos = RestrictFieldInfos;
	}
	else
	{
		currentRestrictFieldInfos = RestrictFieldInfosWorld;
	}
	API_GetTimeRestrictFieldInfo(currentRestrictFieldInfos[Position].FieldId, fieldUIData);
	if((BTNID == "TimeZoneEnter_Btn"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TimeZoneSubWnd");
		Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop("TimeZoneSubWnd", false);
		if(((currentRestrictFieldInfos[Position].bFieldActivated == false) && (currentRestrictFieldInfos[Position].bUserBound == 1)))
		{
			ShowDialogAskEnter(currentRestrictFieldInfos[Position]);
		}
		else if((currentRestrictFieldInfos[Position].bUserBound == 1))
		{
			ShowDialogAskEnter(currentRestrictFieldInfos[Position]);
		}
		else if((fieldUIData.Type == "team_matchingInzone"))
		{
			if(CheckScheduledTimeRestrictFieldUserEnterPacket(fieldUIData.FieldId, outEntryTime))
			{
				CancelTeamMatchingInzoneEnter();
			}
			else
			{
				RequestTemaMatchingInzoneEnter(fieldUIData.FieldId);
			}
		}
		else
		{
			ShowDialogAskEnter(currentRestrictFieldInfos[Position]);
		}
	}
	else if((BTNID == "TimeZoneTimePlus_Btn"))
	{
		if((lastClickPlusButtonPosition == Position))
		{
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("TimeZoneSubWnd"))
			{
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TimeZoneSubWnd");
				Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop("TimeZoneSubWnd", false);
			}
			else
			{
				goto L0230;
			}
		}
		else
		{
L0230:
			TimeZoneSubWnd(GetScript("TimeZoneSubWnd")).SetShowSubWindow(currentRestrictFieldInfos[Position].FieldId, GetButtonHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollAreaWnd.ScrollArea.itemRenderer") $ getInstanceL2Util().makeZeroString(2, INT64(rendererIndex))) $ ".TimeZoneTimePlus_Btn")));
			Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop("TimeZoneSubWnd", true);
			GetWindowHandle("TimeZoneSubWnd").SetAnchor((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollAreaWnd.ScrollArea.itemRenderer") $ getInstanceL2Util().makeZeroString(2, INT64(rendererIndex))) $ ".TimeZoneTimePlus_Btn"), "TopRight", "TopRight", 0, 20);
		}
		lastClickPlusButtonPosition = Position;
	}
	else if((BTNID == "TimeZoneExit_Btn"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TimeZoneSubWnd");
		Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop("TimeZoneSubWnd", false);
		ShowTimeZoneExitDialog();
	}
	return;
}

function bool GetBoolListCondition(int MinLevel, int MaxLevel, int RemainTime, bool bActive, optional string Type, optional int bUserBound, optional int bCanReEnter, optional int nPccafeContent, optional int FieldId)
{
	if((Type == "timezone"))
	{
		if(!bActive)
		{
			return false;
		}
		if((RemainTime == 0))
		{
			return false;
		}
	}
	else if((Type == "instantzone"))
	{
		if((bUserBound == 1))
		{
			if((bCanReEnter == 0))
			{
				return false;
			}
		}
	}
	else
	{
		if((((bUserBound == 1) && (_openedMatchingInzoneFieldID > 0)) && (_openedMatchingInzoneFieldID == FieldId)))
		{
			return true;
		}
		if((bActive == false))
		{
			return false;
		}
		if((bUserBound == 1))
		{
			if((bCanReEnter == 0))
			{
				return false;
			}
		}
	}
	if(!GetPlayerInfo(myInfo))
	{
		return false;
	}
	if((myInfo.nLevel < MinLevel))
	{
		return false;
	}
	if((myInfo.nLevel > MaxLevel))
	{
		return false;
	}
	if(((nIsPCCafeUser <= 0) && (nPccafeContent > 0)))
	{
		return false;
	}
	return true;
}

function string MakeMin(int Min)
{
	if((Min <= 0))
	{
		return MakeFullSystemMsg(GetSystemMessage(3390), "0");
	}
	if((Min < 60))
	{
		return MakeFullSystemMsg(GetSystemMessage(3408), MakeFullSystemMsg(GetSystemMessage(3390), "1"));
	}
	else
	{
		return MakeFullSystemMsg(GetSystemMessage(3390), string((Min / 60)));
	}
}

function string MakeLevelMinMax(int Min, int Max)
{
	if((Max == 999))
	{
		return ((GetSystemString(88) @ string(Min)) @ GetSystemString(859));
	}
	return ((string(Min) $ "~") $ string(Max));
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

function string GetTeamMatchingEntryTimeStr(int Second)
{
	local string timeStr, resultStr;
	local int timeHour, timeMin;

	timeHour = (Second / 3600);
	timeMin = ((Second - (timeHour * 3600)) / 60);
	if((timeMin > 0))
	{
		timeStr = (MakeFullSystemMsg(GetSystemMessage(2204), string(timeHour)) @ MakeFullSystemMsg(GetSystemMessage(3390), string(timeMin)));
	}
	else
	{
		timeStr = MakeFullSystemMsg(GetSystemMessage(2204), string(timeHour));
	}
	resultStr = MakeFullSystemMsg(GetSystemMessage(14650), timeStr);
	return resultStr;
}

function API_RequestEnterTimeRestrictField(int FieldId)
{
	RequestEnterTimeRestrictField(FieldId);
	return;
}

function API_RequestTimeRestrictFieldList()
{
	RequestTimeRestrictFieldList();
	return;
}

function API_GetTimeRestrictFieldInfo(int FieldId, out TimeRestrictFieldUIData fieldUIData)
{
	GetTimeRestrictFieldInfo(FieldId, fieldUIData);
	return;
}

function Rq_C_EX_TIME_RESTRICT_FIELD_USER_LEAVE()
{
	local array<byte> stream;

	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(594, stream);
	return;
}

function API_C_EX_TIME_RESTRICT_FIELD_HOST_USER_LEAVE(int nLeaveFieldID, int nNextEnterFieldID)
{
	local array<byte> stream;
	local UIPacket._C_EX_TIME_RESTRICT_FIELD_HOST_USER_LEAVE packet;

	packet.nLeaveFieldID = nLeaveFieldID;
	packet.nNextEnterFieldID = nNextEnterFieldID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_TIME_RESTRICT_FIELD_HOST_USER_LEAVE(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(837, stream);
	Debug((("API C_EX_TIME_RESTRICT_FIELD_HOST_USER_LEAVE :" @ string(nLeaveFieldID)) @ string(nNextEnterFieldID)));
	return;
}

function API_C_EX_TIME_RESTRICT_FIELD_HOST_USER_ENTER(int nEnterFieldID)
{
	local array<byte> stream;
	local UIPacket._C_EX_TIME_RESTRICT_FIELD_HOST_USER_ENTER packet;

	packet.nEnterFieldID = nEnterFieldID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_TIME_RESTRICT_FIELD_HOST_USER_ENTER(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(836, stream);
	Debug(("API C_EX_TIME_RESTRICT_FIELD_HOST_USER_ENTER :" @ string(nEnterFieldID)));
	return;
}

function RequestTemaMatchingInzoneEnter(int fiieldId)
{
	local int entryTime;

	if(ScheduleTimeRestrictFieldUserEnterPacket(fiieldId, entryTime))
	{
		bResultFieldChargeRefresh = true;
		scrollTileList._Refresh();
		bResultFieldChargeRefresh = false;
		UpdateTeamMatchingInzoneNoticeHUD();
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13686));
	}
	return;
}

function CancelTeamMatchingInzoneEnter()
{
	ClearPacketSchedule();
	if(Me.IsShowWindow())
	{
		bResultFieldChargeRefresh = true;
		scrollTileList._Refresh();
		bResultFieldChargeRefresh = false;
	}
	UpdateTeamMatchingInzoneNoticeHUD();
	return;
}

function UpdateTeamMatchingInzoneNoticeHUD()
{
	NoticeHUD(GetScript("NoticeHud")).UpdateMatchingInzoneEnterReadyState();
	return;
}

delegate int SortCompare(RestrictFieldInfo A, RestrictFieldInfo B)
{
	local bool canAEnter, canBEnter;
	local int nCanA, nCanB;
	local bool canBuyA, canBuyB;
	local int i;
	local TimeRestrictFieldUIData fieldUIData;

	API_GetTimeRestrictFieldInfo(A.FieldId, fieldUIData);
	canAEnter = GetBoolListCondition(A.MinLevel, A.MaxLevel, A.RemainTime, A.bFieldActivated, fieldUIData.Type, A.bUserBound, A.bCanReEnter, A.nIsInZonePCCafeUserOnly, A.FieldId);
	canBuyA = true;
	i = 0;
	while((i < A.ItemIDs.Length))
	{
		if((A.ItemIDs[i] == -100))
		{
			if((A.ItemCounts[i] > INT64(getInstanceUIData().GetCurrentPcCafePoint())))
			{
				canBuyA = false;
			}
			i++;
			continue;
		}
		if((A.ItemCounts[i] > getInventoryItemNumByClassID(A.ItemIDs[i])))
		{
			canBuyA = false;
		}
		i++;
	}
	canAEnter = (canAEnter && canBuyA);
	API_GetTimeRestrictFieldInfo(B.FieldId, fieldUIData);
	canBEnter = GetBoolListCondition(B.MinLevel, B.MaxLevel, B.RemainTime, B.bFieldActivated, fieldUIData.Type, B.bUserBound, B.bCanReEnter, B.nIsInZonePCCafeUserOnly, B.FieldId);
	canBuyB = true;
	i = 0;
	while((i < B.ItemIDs.Length))
	{
		if((B.ItemIDs[i] == -100))
		{
			if((B.ItemCounts[i] > INT64(getInstanceUIData().GetCurrentPcCafePoint())))
			{
				canBuyB = false;
			}
			i++;
			continue;
		}
		if((B.ItemCounts[i] > getInventoryItemNumByClassID(B.ItemIDs[i])))
		{
			canBuyB = false;
		}
		i++;
	}
	canBEnter = (canBEnter && canBuyB);
	if((A.MinLevel > myInfo.nLevel))
	{
		nCanA = 5;
	}
	else if(((A.nIsInZonePCCafeUserOnly == 1) && (nIsPCCafeUser == 0)))
	{
		nCanA = 4;
	}
	else if((((A.bUserBound == 1) && (_openedMatchingInzoneFieldID == A.FieldId)) && canAEnter))
	{
		nCanA = 0;
	}
	else if((canBuyA == false))
	{
		nCanA = 2;
	}
	else if(canAEnter)
	{
		nCanA = 1;
	}
	else
	{
		nCanA = 3;
	}
	if((B.MinLevel > myInfo.nLevel))
	{
		nCanB = 5;
	}
	else if(((B.nIsInZonePCCafeUserOnly == 1) && (nIsPCCafeUser == 0)))
	{
		nCanB = 4;
	}
	else if((((B.bUserBound == 1) && (_openedMatchingInzoneFieldID == B.FieldId)) && canBEnter))
	{
		nCanB = 0;
	}
	else if((canBuyB == false))
	{
		nCanB = 2;
	}
	else if(canBEnter)
	{
		nCanB = 1;
	}
	else
	{
		nCanB = 3;
	}
	if((nCanA > nCanB))
	{
		return -1;
	}
	return 0;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hOwnerWnd.HideWindow();
	return;
}
