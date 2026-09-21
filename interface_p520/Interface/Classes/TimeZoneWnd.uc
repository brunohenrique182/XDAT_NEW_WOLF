class TimeZoneWnd extends UICommonAPI;

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
};

var string m_Windowname;
var WindowHandle Me;
var RichListCtrlHandle TimeZoneList;
var WindowHandle disableWnd;
var WindowHandle TimeZoneConfirmWnd;
var TextBoxHandle TimeZoneDescName_Txt;
var TextBoxHandle TimeZoneDescType_Txt;
var TextBoxHandle TimeZoneDescDefaultTime_Txt;
var TextBoxHandle TimeZoneDescLevel_Txt;
var TextListBoxHandle TimeZoneDesc_Tex;
var TextBoxHandle TimeZoneTimeNow01_Txt;
var TextBoxHandle TimeZoneTimeNow02_Txt;
var TextBoxHandle TimeZoneChargeTime01_Txt;
var TextBoxHandle TimeZoneChargeTime02_Txt;
var TextBoxHandle TimeZoneCost01_Txt;
var TextBoxHandle TimeZoneMyCost01_Txt;
var TextBoxHandle TimeZoneCost02_Txt;
var TextBoxHandle TimeZoneMyCost02_Txt;
var ButtonHandle TimeZoneTimePlus_Btn;
var ButtonHandle TimeZoneEnter_Btn;
var ButtonHandle ReFresh_btn;
var ButtonHandle Close_Btn;
var ButtonHandle timeChargeLink_Btn;
var AnimTextureHandle TimeZoneTimePlusAnim_Tex;
var TextBoxHandle TimeZoneTimeTitle_Txt;
var TextBoxHandle TimeZoneChargeTimeTitle_Txt;
var TextBoxHandle TimeZoneCostTitle_Txt;
var ButtonHandle TimeZoneExit_Btn;
var WindowHandle exitDialogDisableWnd;
var int currentSelectedFieldID;
var int nIsPCCafeUser;
var array<RestrictFieldInfo> RestrictFieldInfos;
var bool bListRequested;
var L2Util util;
//var delegate<SortCompare> __SortCompare__Delegate;

function Initialize()
{
	Me = GetWindowHandle(m_Windowname);
	disableWnd = GetWindowHandle((m_Windowname $ ".DisableWnd"));
	exitDialogDisableWnd = GetWindowHandle((m_Windowname $ ".DialogDisableWnd"));
	TimeZoneConfirmWnd = GetWindowHandle((m_Windowname $ ".TimeZoneConfirmWnd"));
	TimeZoneList = GetRichListCtrlHandle((m_Windowname $ ".ListWnd.TimeZoneList"));
	TimeZoneDescName_Txt = GetTextBoxHandle((m_Windowname $ ".DescWnd.TimeZoneDescName_Txt"));
	TimeZoneDescType_Txt = GetTextBoxHandle((m_Windowname $ ".DescWnd.TimeZoneDescType_Txt"));
	TimeZoneDescDefaultTime_Txt = GetTextBoxHandle((m_Windowname $ ".DescWnd.TimeZoneDescDefaultTime_Txt"));
	TimeZoneDescLevel_Txt = GetTextBoxHandle((m_Windowname $ ".DescWnd.TimeZoneDescLevel_Txt"));
	TimeZoneDesc_Tex = GetTextListBoxHandle((m_Windowname $ ".DescWnd.TimeZoneDesc_Tex"));
	TimeZoneTimeTitle_Txt = GetTextBoxHandle((m_Windowname $ ".DescWnd.TimeZoneTimeTitle_Txt"));
	TimeZoneChargeTimeTitle_Txt = GetTextBoxHandle((m_Windowname $ ".DescWnd.TimeZoneChargeTimeTitle_Txt"));
	TimeZoneCostTitle_Txt = GetTextBoxHandle((m_Windowname $ ".DescWnd.TimeZoneCostTitle_Txt"));
	TimeZoneTimeNow01_Txt = GetTextBoxHandle((m_Windowname $ ".DescWnd.TimeZoneTimeNow01_Txt"));
	TimeZoneTimeNow02_Txt = GetTextBoxHandle((m_Windowname $ ".DescWnd.TimeZoneTimeNow02_Txt"));
	TimeZoneChargeTime01_Txt = GetTextBoxHandle((m_Windowname $ ".DescWnd.TimeZoneChargeTime01_Txt"));
	TimeZoneChargeTime02_Txt = GetTextBoxHandle((m_Windowname $ ".DescWnd.TimeZoneChargeTime02_Txt"));
	TimeZoneTimePlus_Btn = GetButtonHandle((m_Windowname $ ".DescWnd.TimeZoneTimePlus_Btn"));
	TimeZoneEnter_Btn = GetButtonHandle((m_Windowname $ ".TimeZoneEnter_Btn"));
	TimeZoneExit_Btn = GetButtonHandle((m_Windowname $ ".TimeZoneExit_Btn"));
	ReFresh_btn = GetButtonHandle((m_Windowname $ ".Refresh_Btn"));
	Close_Btn = GetButtonHandle((m_Windowname $ ".Close_Btn"));
	util = L2Util(GetScript("L2Util"));
	TimeZoneList.SetSelectedSelTooltip(false);
	TimeZoneList.SetAppearTooltipAtMouseX(true);
	timeChargeLink_Btn = GetButtonHandle((m_Windowname $ ".ChargingLink_Btn"));
	TimeZoneTimePlusAnim_Tex = GetAnimTextureHandle((m_Windowname $ ".DescWnd.TimeZoneTimePlusAnim_Tex"));
	currentSelectedFieldID = -1;
	return;
}

function API_RequestEnterTimeRestrictField(int FieldId)
{
	RequestEnterTimeRestrictField(FieldId);
	return;
}

function API_RequestTimeRestrictFieldList()
{
	if(bListRequested)
	{
		return;
	}
	bListRequested = true;
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

	Class'Interface.UIPacket'.static.RequestUIPacket(594, stream);
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(11190);
	RegisterEvent(11200);
	RegisterEvent(11210);
	RegisterEvent(11230);
	RegisterEvent(11240);
	RegisterEvent(11220);
	RegisterEvent(11250);
	RegisterEvent(180);
	RegisterEvent(9750);
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
		case 11190:
			ClearAll();
			break;
		case 11200:
			HandleItemList(param);
			break;
		case 11210:
			Debug(("--> EV_TimeRestrictFieldListEnd" @ param));
			ItemListInfoEnd();
			break;
		case 11230:
			HandleResultFieldCharge(param);
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
		case 180:
			if(Me.IsShowWindow())
			{
				HandleUserInfo();
			}
			break;
		case 9750:
			bListRequested = false;
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "TimeZoneEnter_Btn":
			OnClick_TImeZoneEnter();
			break;
		case "TimeZoneExit_Btn":
			OnClick_TImeZoneExit();
			break;
		case "Refresh_Btn":
			OnCLick_Refresh_Btn();
			break;
		case "Close_Btn":
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_Windowname);
			break;
		case "TimeZoneConfirm_Btn":
			OnOK_ButtonClick();
			break;
		case "TimeZoneCancel_Btn":
			OnCancel_ButtonClick();
			break;
		case "TimeZoneTimePlus_Btn":
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("TimeZoneSubWnd"))
			{
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TimeZoneSubWnd");
			}
			else
			{
				TimeZoneSubWnd(GetScript("TimeZoneSubWnd")).SetShowSubWindow(currentSelectedFieldID, TimeZoneTimePlus_Btn);
			}
			break;
		case "ChargingLink_Btn":
			ShowHideIngameWebTimeCharging();
			break;
		default:
			break;
	}
	return;
}

function ShowHideIngameWebTimeCharging()
{
	local string param;

	ParamAdd(param, "Category", "nshop_timezone_refill");
	ExecuteEvent(10120, param);
	return;
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	OnClickListCtrlRecord(ListCtrlID);
	if(TimeZoneEnter_Btn.IsEnableWindow())
	{
		OnClick_TImeZoneEnter();
	}
	return;
}

event OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 99902:
			ReFresh_btn.EnableWindow();
			Me.KillTimer(99902);
			break;
		default:
			break;
	}
	return;
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	local RichListCtrlRowData Record;

	TimeZoneList.GetSelectedRec(Record);
	if((currentSelectedFieldID != Record.cellDataList[0].nReserved1))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TimeZoneSubWnd");
	}
	currentSelectedFieldID = Record.cellDataList[0].nReserved1;
	SetDesc(Record);
	return;
}

event OnShow()
{
	Debug("OnShow");
	if(Class'NWindow.UIDATA_PLAYER'.static.IsInPrison())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13773));
		Me.HideWindow();
		return;
	}
	disableWnd.ShowWindow();
	TimeZoneConfirmWnd.HideWindow();
	ClearDesc();
	Me.SetFocus();
	if(GetWindowHandle("NoticeHUD").IsShowWindow())
	{
		currentSelectedFieldID = NoticeHUD(GetScript("NoticeHUD")).getTimeZoneCurrentFieldID();
	}
	API_RequestTimeRestrictFieldList();
	SideBar(GetScript("SideBar")).ToggleByWindowName(m_Windowname, true);
	if((int(GetLanguage()) == 0))
	{
		if(getInstanceUIData().GetIsLiveServer())
		{
			timeChargeLink_Btn.ShowWindow();
		}
		else
		{
			timeChargeLink_Btn.HideWindow();
		}
	}
	else
	{
		timeChargeLink_Btn.HideWindow();
	}
	return;
}

event OnHide()
{
	currentSelectedFieldID = -1;
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TimeZoneSubWnd");
	SideBar(GetScript("SideBar")).ToggleByWindowName(m_Windowname, false);
	return;
}

function ShowBySideBar(optional int gotoTimezoneID)
{
	return;
}

event OnClick_TImeZoneEnter()
{
	DialogHide();
	TimeZoneConfirmWnd.ShowWindow();
	return;
}

event OnClick_TImeZoneExit()
{
	ShowTimeZoneExitDialog();
	return;
}

event OnCLick_Refresh_Btn()
{
	API_RequestTimeRestrictFieldList();
	ReFresh_btn.DisableWindow();
	Me.SetTimer(99902, 3000);
	return;
}

event OnOK_ButtonClick()
{
	API_RequestEnterTimeRestrictField(currentSelectedFieldID);
	return;
}

event OnCancel_ButtonClick()
{
	TimeZoneConfirmWnd.HideWindow();
	return;
}

event OnTimeZoneExitDialogConfirm()
{
	Rq_C_EX_TIME_RESTRICT_FIELD_USER_LEAVE();
	return;
}

event OnTimeZoneExitDialogCancel()
{
	return;
}

event OnTimeZoneExitDialogHide()
{
	exitDialogDisableWnd.HideWindow();
	return;
}

function ClearAll()
{
	TimeZoneList.DeleteAllItem();
	return;
}

function HandleItemList(string param)
{
	local RestrictFieldInfo fieldInfo;
	local int i, tmpBFieldActivated, Count;

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
	fieldInfo.bFieldActivated = (tmpBFieldActivated > 0);
	RestrictFieldInfos.Length = (RestrictFieldInfos.Length + 1);
	RestrictFieldInfos[(RestrictFieldInfos.Length - 1)] = fieldInfo;
	return;
}

function RichListCtrlRowData MakeRowDataDraw(RichListCtrlRowData rowData)
{
	local string typeTexture;
	local Color TextColor, remainTimeColor;
	local bool canEnter;
	local TimeRestrictFieldUIData fieldUIData;
	local Color typeColor;
	local string typeStr;

	switch(int(rowData.cellDataList[0].HiddenStringForSorting))
	{
		case 0:
			typeTexture = "L2UI_ct1.TimeZoneWnd.TimeZoneWnd_Type02";
			typeStr = GetSystemString(3580);
			typeColor = GetColor(255, 255, 187, 255);
			break;
		case 1:
			typeTexture = "L2UI_ct1.TimeZoneWnd.TimeZoneWnd_Type01";
			typeStr = GetSystemString(3579);
			typeColor = GetColor(255, 153, 153, 255);
			break;
		default:
			break;
	}
	canEnter = GetBoolListCondition(rowData.cellDataList[2].nReserved1, rowData.cellDataList[2].nReserved2, rowData.cellDataList[3].nReserved1, (rowData.cellDataList[0].nReserved2 == 1), rowData.cellDataList[1].szReserved, rowData.cellDataList[1].nReserved1, rowData.cellDataList[1].nReserved2, int(rowData.nReserved1));
	if(canEnter)
	{
		TextColor = util.BrightWhite;
		remainTimeColor = util.Gold;
	}
	else
	{
		TextColor = util.Gray;
		remainTimeColor = util.Gray;
	}
	rowData.cellDataList[0].drawitems.Length = 0;
	rowData.cellDataList[1].drawitems.Length = 0;
	rowData.cellDataList[2].drawitems.Length = 0;
	rowData.cellDataList[3].drawitems.Length = 0;
	rowData.cellDataList[4].drawitems.Length = 0;
	if((int(GetLanguage()) == 0))
	{
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, typeTexture, 64, 32, 14, 0);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, typeStr, typeColor, false, 0, 0);
	}
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, rowData.cellDataList[1].HiddenStringForSorting, TextColor, false, 5, 0);
	switch(rowData.cellDataList[0].nReserved1)
	{
		case 23:
		case 22:
			addRichListCtrlTexture(rowData.cellDataList[1].drawitems, "L2UI_CT1.DailyMissionWnd_IconEvent", 41, 19, 4, -3);
		default:
			if((rowData.nReserved1 > INT64(0)))
			{
				addRichListCtrlTexture(rowData.cellDataList[1].drawitems, "L2UI_EPIC.Icon.IconPCCafe", 41, 19, 4, -3);
			}
			if((rowData.nReserved2 > INT64(0)))
			{
				if((rowData.nReserved1 > INT64(0)))
				{
					addRichListCtrlTexture(rowData.cellDataList[1].drawitems, "L2UI_EPIC.Icon.IconWorld", 41, 19, 4, 0);
				}
				else
				{
					addRichListCtrlTexture(rowData.cellDataList[1].drawitems, "L2UI_EPIC.Icon.IconWorld", 41, 19, 4, -3);
				}
			}
	}
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, MakeLevelMinMax(rowData.cellDataList[2].nReserved1, rowData.cellDataList[2].nReserved2), TextColor, false, 5, 0);
	if((rowData.cellDataList[1].szReserved == "timezone"))
	{
		AddRichListCtrlString(rowData.cellDataList[3].drawitems, MakeMin(rowData.cellDataList[3].nReserved1), remainTimeColor, false, 5, 0);
		AddRichListCtrlString(rowData.cellDataList[3].drawitems, ("/" $ MakeMin(rowData.cellDataList[3].nReserved2)), TextColor, false, 0, 0);
		AddRichListCtrlString(rowData.cellDataList[4].drawitems, MakeMin(rowData.cellDataList[4].nReserved1), TextColor, false, 5, 0);
		AddRichListCtrlButton(rowData.cellDataList[3].drawitems, "shareWarningBtn", 0, 0, "btnInfo", "btnInfo");
		if((rowData.cellDataList[3].nReserved3 > 0))
		{
			AddRichListCtrlButton(rowData.cellDataList[3].drawitems, "btnInfo", 2, -4, "L2UI_ct1.LCoinShopWnd.LCoinShopWnd_Icon_Account", "L2UI_ct1.LCoinShopWnd.LCoinShopWnd_Icon_Account", "L2UI_ct1.LCoinShopWnd.LCoinShopWnd_Icon_Account", 20, 20, 20, 20, 0, GetSystemString(14710));
		}
	}
	else if((rowData.cellDataList[1].nReserved1 == 1))
	{
		AddRichListCtrlString(rowData.cellDataList[3].drawitems, ("0" @ GetSystemString(3295)), remainTimeColor, false, 5, 0);
		API_GetTimeRestrictFieldInfo(rowData.cellDataList[0].nReserved1, fieldUIData);
		if((fieldUIData.RefillItemList.Length < 1))
		{
			AddRichListCtrlString(rowData.cellDataList[4].drawitems, GetSystemString(13214), remainTimeColor, false, 5, 0);
		}
		else
		{
			AddRichListCtrlString(rowData.cellDataList[4].drawitems, GetSystemString(459), remainTimeColor, false, 5, 0);
		}
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[3].drawitems, ("1" @ GetSystemString(3295)), remainTimeColor, false, 5, 0);
		AddRichListCtrlString(rowData.cellDataList[4].drawitems, GetSystemString(13214), remainTimeColor, false, 5, 0);
	}
	if((rowData.cellDataList[1].nReserved3 == 1))
	{
		rowData.sOverlayTex = "L2UI_CT1.TimeZoneWnd.MyListBG";
		rowData.OverlayTexU = 600;
		rowData.OverlayTexU = 20;
	}
	return rowData;
}

function RichListCtrlRowData MakeRowData(RestrictFieldInfo fieldInfo)
{
	local RichListCtrlRowData rowData;
	local int i;
	local string itemInfoParams;
	local TimeRestrictFieldUIData fieldUIData;

	rowData.cellDataList.Length = 6;
	API_GetTimeRestrictFieldInfo(fieldInfo.FieldId, fieldUIData);
	itemInfoParams = "";
	ParamAdd(itemInfoParams, "count", string(fieldInfo.ItemIDs.Length));
	i = 0;
	while((i < fieldInfo.ItemIDs.Length))
	{
		ParamAdd(itemInfoParams, ("itemID" $ string(i)), string(fieldInfo.ItemIDs[i]));
		ParamAdd(itemInfoParams, ("itemCount" $ string(i)), string(fieldInfo.ItemCounts[i]));
		i++;
	}
	rowData.nReserved1 = INT64(fieldInfo.nIsInZonePCCafeUserOnly);
	rowData.nReserved2 = INT64(fieldInfo.bWorldInZone);
	rowData.cellDataList[0].szReserved = itemInfoParams;
	rowData.cellDataList[0].nReserved1 = fieldInfo.FieldId;
	if(fieldInfo.bFieldActivated)
	{
		rowData.cellDataList[0].nReserved2 = 1;
	}
	rowData.cellDataList[0].nReserved3 = fieldInfo.RemainTimeBase;
	rowData.cellDataList[0].HiddenStringForSorting = string(fieldInfo.ResetCycle);
	rowData.cellDataList[1].HiddenStringForSorting = fieldUIData.FieldName;
	rowData.cellDataList[1].szReserved = fieldUIData.Type;
	rowData.cellDataList[1].nReserved1 = fieldInfo.bUserBound;
	rowData.cellDataList[1].nReserved2 = fieldInfo.bCanReEnter;
	if((NoticeHUD(GetScript("NoticeHUD")).getTimeZoneCurrentFieldID() == fieldInfo.FieldId))
	{
		rowData.cellDataList[1].nReserved3 = 1;
	}
	rowData.cellDataList[2].nReserved1 = fieldInfo.MinLevel;
	rowData.cellDataList[2].nReserved2 = fieldInfo.MaxLevel;
	rowData.cellDataList[2].HiddenStringForSorting = string(fieldInfo.MinLevel);
	rowData.cellDataList[3].nReserved1 = fieldInfo.RemainTime;
	rowData.cellDataList[3].nReserved2 = fieldInfo.RemainTimeMax;
	if(fieldUIData.IsAccountShare)
	{
		rowData.cellDataList[3].nReserved3 = 1;
	}
	rowData.cellDataList[3].HiddenStringForSorting = string(fieldInfo.RemainTime);
	rowData.cellDataList[4].nReserved1 = fieldInfo.RemainRefillTime;
	rowData.cellDataList[4].nReserved2 = fieldInfo.RefillTimeMax;
	rowData.cellDataList[4].HiddenStringForSorting = string(fieldInfo.RemainRefillTime);
	return rowData;
}

function ItemListInfoEnd()
{
	local int i, Index;
	local RichListCtrlRowData rowData;
	local UserInfo myInfo;

	// RestrictFieldInfos.Sort(SortCompare);   // array.Sort() unsupported by this compiler
	GetPlayerInfo(myInfo);
	i = 0;
	while((i < RestrictFieldInfos.Length))
	{
		if(((myInfo.nLevel <= RestrictFieldInfos[i].MaxLevel) || getInstanceUIData().GetIsLiveServer()))
		{
			rowData = MakeRowDataDraw(MakeRowData(RestrictFieldInfos[i]));
			TimeZoneList.InsertRecord(rowData);
			if((RestrictFieldInfos[i].FieldId == currentSelectedFieldID))
			{
				Index = FindIndexByFieldID(currentSelectedFieldID);
				TimeZoneList.SetSelectedIndex(Index, false);
				SetDesc(rowData);
				Debug(("이거 index" @ string(Index)));  // EN?: This is the index
			}
		}
		i++;
	}
	RestrictFieldInfos.Length = 0;
	Me.ShowWindow();
	bListRequested = false;
	Debug(("-_- end 이다. " @ string(currentSelectedFieldID)));  // EN?: It is -_- end.
	return;
}

function SetDesc(RichListCtrlRowData rowData)
{
	local int Count, i, ItemID;
	local RichListCtrlRowData nullrowData;
	local INT64 ItemCount, itemCountMine;
	local ItemInfo CostItem;
	local InventoryWnd invenScript;
	local TextBoxHandle myItemCountTextBoxhandle;
	local bool canEnter;
	local TimeRestrictFieldUIData fieldUIData;
	local Color tempColor;

	API_GetTimeRestrictFieldInfo(rowData.cellDataList[0].nReserved1, fieldUIData);
	canEnter = true;
	invenScript = InventoryWnd(GetScript("InventoryWnd"));
	if((rowData == nullrowData))
	{
		disableWnd.ShowWindow();
	}
	else
	{
		disableWnd.HideWindow();
	}
	ParseInt(rowData.cellDataList[0].szReserved, "count", Count);
	i = 0;
	while((i < 2))
	{
		GetTextBoxHandle((((m_Windowname $ ".TimeZoneConfirmWnd.TimeZoneConfirmWndCostNum0") $ string((i + 1))) $ "_Txt")).SetText("");
		GetItemWindowHandle((((m_Windowname $ ".TimeZoneConfirmWnd.TimeZoneConfirmWndCostIcon0") $ string((i + 1))) $ "_ItemWindow")).Clear();
		GetTextureHandle((((m_Windowname $ ".TimeZoneConfirmWnd.TimeZoneConfirmWndCostIconBg0") $ string((i + 1))) $ "_Tex")).HideWindow();
		GetTextBoxHandle((((m_Windowname $ ".TimeZoneConfirmWnd.TimeZoneConfirmWndCostNum0") $ string((i + 1))) $ "_Txt")).SetText("");
		GetItemWindowHandle((((m_Windowname $ ".DescWnd.TimeZoneCostIcon0") $ string((i + 1))) $ "_ItemWindow")).Clear();
		GetTextureHandle((((m_Windowname $ ".TimeZoneCostIconBg0") $ string((i + 1))) $ "_Tex")).HideWindow();
		GetTextBoxHandle((((m_Windowname $ ".DescWnd.TimeZoneCost0") $ string((i + 1))) $ "_Txt")).SetText("");
		GetTextBoxHandle((((m_Windowname $ ".DescWnd.TimeZoneMyCost0") $ string((i + 1))) $ "_Txt")).SetText("");
		i++;
	}
	GetTextBoxHandle((m_Windowname $ ".TimeZoneConfirmWnd.TimeZoneConfirmWndDesc01_Txt")).SetText(MakeFullSystemMsg(GetSystemMessage(13009), rowData.cellDataList[1].HiddenStringForSorting));
	i = 0;
	while((i < Count))
	{
		ParseInt(rowData.cellDataList[0].szReserved, ("itemID" $ string(i)), ItemID);
		ParseINT64(rowData.cellDataList[0].szReserved, ("ItemCount" $ string(i)), ItemCount);
		if((ItemID == -100))
		{
			CostItem.Name = GetSystemString(1277);
			CostItem.IconName = GetPcCafeItemIconPackageName();
			CostItem.Enchanted = 0;
			CostItem.ItemType = -1;
			CostItem.Id.ClassID = 0;
		}
		else
		{
			CostItem = GetItemInfoByClassID(ItemID);
		}
		GetTextBoxHandle((((m_Windowname $ ".TimeZoneConfirmWnd.TimeZoneConfirmWndCostNum0") $ string((i + 1))) $ "_Txt")).SetText(("x" $ MakeCostString(string(ItemCount))));
		GetItemWindowHandle((((m_Windowname $ ".TimeZoneConfirmWnd.TimeZoneConfirmWndCostIcon0") $ string((i + 1))) $ "_ItemWindow")).AddItem(CostItem);
		GetTextureHandle((((m_Windowname $ ".TimeZoneConfirmWnd.TimeZoneConfirmWndCostIconBg0") $ string((i + 1))) $ "_Tex")).ShowWindow();
		GetTextBoxHandle((((m_Windowname $ ".TimeZoneConfirmWnd.TimeZoneConfirmWndCostNum0") $ string((i + 1))) $ "_Txt")).SetText(("x" $ MakeCostString(string(ItemCount))));
		GetItemWindowHandle((((m_Windowname $ ".DescWnd.TimeZoneCostIcon0") $ string((i + 1))) $ "_ItemWindow")).AddItem(CostItem);
		GetTextureHandle((((m_Windowname $ ".TimeZoneCostIconBg0") $ string((i + 1))) $ "_Tex")).ShowWindow();
		GetTextBoxHandle((((m_Windowname $ ".DescWnd.TimeZoneCost0") $ string((i + 1))) $ "_Txt")).SetText(("x" $ MakeCostString(string(ItemCount))));
		if((CostItem.IconName == GetPcCafeItemIconPackageName()))
		{
			itemCountMine = INT64(getInstanceUIData().GetCurrentPcCafePoint());
		}
		else
		{
			itemCountMine = invenScript.getItemCountByClassID(ItemID);
		}
		myItemCountTextBoxhandle = GetTextBoxHandle((((m_Windowname $ ".DescWnd.TimeZoneMyCost0") $ string((i + 1))) $ "_Txt"));
		myItemCountTextBoxhandle.SetText((("(" $ MakeCostString(string(itemCountMine))) $ ")"));
		if((ItemCount > itemCountMine))
		{
			canEnter = false;
			myItemCountTextBoxhandle.SetTextColor(util.DRed);
			i++;
			continue;
		}
		myItemCountTextBoxhandle.SetTextColor(util.BLUE01);
		i++;
	}
	canEnter = (GetBoolListCondition(rowData.cellDataList[2].nReserved1, rowData.cellDataList[2].nReserved2, rowData.cellDataList[3].nReserved1, (rowData.cellDataList[0].nReserved2 == 1), rowData.cellDataList[1].szReserved, rowData.cellDataList[1].nReserved1, rowData.cellDataList[1].nReserved2, int(rowData.nReserved1)) && canEnter);
	Debug(("UserBound" @ string(rowData.cellDataList[1].nReserved1)));
	Debug(("ReEnter" @ string(rowData.cellDataList[1].nReserved2)));
	if(canEnter)
	{
		TimeZoneEnter_Btn.EnableWindow();
	}
	else
	{
		TimeZoneEnter_Btn.DisableWindow();
	}
	if((NoticeHUD(GetScript("NoticeHUD")).getTimeZoneCurrentFieldID() == fieldUIData.FieldId))
	{
		TimeZoneExit_Btn.EnableWindow();
	}
	else
	{
		TimeZoneExit_Btn.DisableWindow();
	}
	TimeZoneDescName_Txt.SetText(rowData.cellDataList[1].HiddenStringForSorting);
	switch(rowData.cellDataList[0].HiddenStringForSorting)
	{
		case "0":
			TimeZoneDescType_Txt.SetText(GetSystemString(3580));
			break;
		case "1":
			TimeZoneDescType_Txt.SetText(GetSystemString(3579));
			break;
		default:
			break;
	}
	TimeZoneDescLevel_Txt.SetText(MakeLevelMinMax(rowData.cellDataList[2].nReserved1, rowData.cellDataList[2].nReserved2));
	Class'NWindow.UIAPI_TEXTLISTBOX'.static.Clear((m_Windowname $ ".DescWnd.TimeZoneDesc_Tex"));
	Class'NWindow.UIAPI_TEXTLISTBOX'.static.AddString((m_Windowname $ ".DescWnd.TimeZoneDesc_Tex"), fieldUIData.Desc, tempColor);
	if((rowData.cellDataList[1].szReserved == "timezone"))
	{
		TimeZoneTimeTitle_Txt.SetText(GetSystemString(13031));
		TimeZoneDescDefaultTime_Txt.SetText(MakeMin(rowData.cellDataList[0].nReserved3));
		TimeZoneTimeNow02_Txt.SetText(((MakeMin(rowData.cellDataList[3].nReserved1) $ "/") $ MakeMin(rowData.cellDataList[3].nReserved2)));
		TimeZoneChargeTimeTitle_Txt.SetText(GetSystemString(13027));
		TimeZoneChargeTime02_Txt.SetText(((MakeMin(rowData.cellDataList[4].nReserved1) $ "/") $ MakeMin(rowData.cellDataList[4].nReserved2)));
		TimeZoneCostTitle_Txt.SetText(GetSystemString(13032));
		GetTextBoxHandle((m_Windowname $ ".TimeZoneConfirmWnd.TimeInZonecostDesc_Txt")).HideWindow();
	}
	else
	{
		TimeZoneTimeTitle_Txt.SetText(GetSystemString(13212));
		TimeZoneDescDefaultTime_Txt.SetText("");
		TimeZoneTimeNow02_Txt.SetText("-");
		TimeZoneChargeTimeTitle_Txt.SetText("");
		TimeZoneChargeTime02_Txt.SetText("");
		TimeZoneCostTitle_Txt.SetText(GetSystemString(13213));
		GetTextBoxHandle((m_Windowname $ ".TimeZoneConfirmWnd.TimeInZonecostDesc_Txt")).ShowWindow();
	}
	return;
}

function ClearDesc()
{
	local int i;

	i = 0;
	while((i < 2))
	{
		GetTextBoxHandle((((m_Windowname $ ".TimeZoneConfirmWnd.TimeZoneConfirmWndCostNum0") $ string((i + 1))) $ "_Txt")).SetText("");
		GetItemWindowHandle((((m_Windowname $ ".TimeZoneConfirmWnd.TimeZoneConfirmWndCostIcon0") $ string((i + 1))) $ "_ItemWindow")).Clear();
		GetTextureHandle((((m_Windowname $ ".TimeZoneConfirmWnd.TimeZoneConfirmWndCostIconBg0") $ string((i + 1))) $ "_Tex")).HideWindow();
		GetTextBoxHandle((((m_Windowname $ ".TimeZoneConfirmWnd.TimeZoneConfirmWndCostNum0") $ string((i + 1))) $ "_Txt")).SetText("");
		GetItemWindowHandle((((m_Windowname $ ".DescWnd.TimeZoneCostIcon0") $ string((i + 1))) $ "_ItemWindow")).Clear();
		GetTextureHandle((((m_Windowname $ ".TimeZoneCostIconBg0") $ string((i + 1))) $ "_Tex")).HideWindow();
		GetTextBoxHandle((((m_Windowname $ ".DescWnd.TimeZoneCost0") $ string((i + 1))) $ "_Txt")).SetText("");
		GetTextBoxHandle((((m_Windowname $ ".DescWnd.TimeZoneMyCost0") $ string((i + 1))) $ "_Txt")).SetText("");
		i++;
	}
	TimeZoneDescName_Txt.SetText("");
	TimeZoneDescDefaultTime_Txt.SetText("");
	TimeZoneDescType_Txt.SetText("");
	TimeZoneDescLevel_Txt.SetText("");
	Class'NWindow.UIAPI_TEXTLISTBOX'.static.Clear((m_Windowname $ ".DescWnd.TimeZoneDesc_Tex"));
	TimeZoneTimeNow02_Txt.SetText("");
	TimeZoneChargeTime02_Txt.SetText("");
	return;
}

function ShowTimeZoneExitDialog()
{
	DialogHide();
	exitDialogDisableWnd.ShowWindow();
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemMessage(13704));
	Class'Interface.DialogBox'.static.Inst().AnchorToOwner(0, 0);
	Class'Interface.DialogBox'.static.Inst().DelegateOnCancel = OnTimeZoneExitDialogCancel;
	Class'Interface.DialogBox'.static.Inst().DelegateOnOK = OnTimeZoneExitDialogConfirm;
	Class'Interface.DialogBox'.static.Inst().DelegateOnHide = OnTimeZoneExitDialogHide;
	Class'Interface.DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
	return;
}

function HandleUserInfo()
{
	local int i;
	local RichListCtrlRowData rowData;

	i = 0;
	while((i < TimeZoneList.GetRecordCount()))
	{
		TimeZoneList.GetRec(i, rowData);
		TimeZoneList.ModifyRecord(i, MakeRowDataDraw(rowData));
		i++;
	}
	return;
}

function HandleResultFieldAlarm(string param)
{
	local int Index, FieldId, RemainTime;
	local RichListCtrlRowData rowData;

	ParseInt(param, "FieldID", FieldId);
	ParseInt(param, "RemainTime", RemainTime);
	Index = FindIndexByFieldID(FieldId);
	if((Index == -1))
	{
		return;
	}
	TimeZoneList.GetRec(Index, rowData);
	rowData.cellDataList[3].nReserved1 = RemainTime;
	TimeZoneList.ModifyRecord(Index, MakeRowDataDraw(rowData));
	if((FieldId == currentSelectedFieldID))
	{
		TimeZoneTimeNow02_Txt.SetText(((MakeMin(rowData.cellDataList[3].nReserved1) $ "/") $ MakeMin(rowData.cellDataList[3].nReserved2)));
		TimeZoneChargeTime02_Txt.SetText(((MakeMin(rowData.cellDataList[4].nReserved1) $ "/") $ MakeMin(rowData.cellDataList[4].nReserved2)));
	}
	return;
}

function HandleResultFieldCharge(string param)
{
	local int Index, FieldId, RemainTime, ResultRefillTime, resultChargeTime;
	local RichListCtrlRowData rowData;
	local TimeRestrictFieldUIData fieldUIData;
	local string gfxScreenMsg;

	ParseInt(param, "FieldID", FieldId);
	ParseInt(param, "RemainTime", RemainTime);
	ParseInt(param, "ResultRefillTime", ResultRefillTime);
	ParseInt(param, "ResultChargeTime", resultChargeTime);
	API_GetTimeRestrictFieldInfo(FieldId, fieldUIData);
	gfxScreenMsg = MakeFullSystemMsg(GetSystemMessage(13008), fieldUIData.FieldName, string((resultChargeTime / 60)));
	getInstanceL2Util().showGfxScreenMessage(gfxScreenMsg);
	Index = FindIndexByFieldID(FieldId);
	if((Index == -1))
	{
		return;
	}
	TimeZoneList.GetRec(Index, rowData);
	rowData.cellDataList[3].nReserved1 = RemainTime;
	rowData.cellDataList[4].nReserved1 = ResultRefillTime;
	TimeZoneList.ModifyRecord(Index, MakeRowDataDraw(rowData));
	TimeZoneTimePlusAnim_Tex.Play();
	if((FieldId == currentSelectedFieldID))
	{
		TimeZoneTimeNow02_Txt.SetText(((MakeMin(rowData.cellDataList[3].nReserved1) $ "/") $ MakeMin(rowData.cellDataList[3].nReserved2)));
		TimeZoneChargeTime02_Txt.SetText(((MakeMin(rowData.cellDataList[4].nReserved1) $ "/") $ MakeMin(rowData.cellDataList[4].nReserved2)));
	}
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
		TimeZoneConfirmWnd.HideWindow();
	}
	return;
}

function bool GetBoolListCondition(int MinLevel, int MaxLevel, int RemainTime, bool bActive, optional string Type, optional int bUserBound, optional int bCanReEnter, optional int nPccafeContent)
{
	local UserInfo myInfo;

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
	else if((bUserBound == 1))
	{
		if((bCanReEnter == 0))
		{
			return false;
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
		return (string(Min) @ GetSystemString(859));
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

function RichListCtrlRowData GetSelectedRecord()
{
	local RichListCtrlRowData Record;

	TimeZoneList.GetSelectedRec(Record);
	return Record;
}

function int FindIndexByFieldID(int FieldId)
{
	local RichListCtrlRowData Record;
	local int i;

	i = 0;
	while((i < TimeZoneList.GetRecordCount()))
	{
		TimeZoneList.GetRec(i, Record);
		if((Record.cellDataList[0].nReserved1 == FieldId))
		{
			return i;
		}
		i++;
	}
	return -1;
}

delegate int SortCompare(RestrictFieldInfo A, RestrictFieldInfo B)
{
	local bool canAEnter, canBEnter;
	local TimeRestrictFieldUIData fieldUIData;

	API_GetTimeRestrictFieldInfo(A.FieldId, fieldUIData);
	canAEnter = GetBoolListCondition(A.MinLevel, A.MaxLevel, A.RemainTime, A.bFieldActivated, fieldUIData.Type, A.bUserBound, A.bCanReEnter, A.nIsInZonePCCafeUserOnly);
	API_GetTimeRestrictFieldInfo(B.FieldId, fieldUIData);
	canBEnter = GetBoolListCondition(B.MinLevel, B.MaxLevel, B.RemainTime, B.bFieldActivated, fieldUIData.Type, B.bUserBound, B.bCanReEnter, B.nIsInZonePCCafeUserOnly);
	if((!canAEnter && canBEnter))
	{
		return -1;
	}
	return 0;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="TimeZoneWnd"
}
