class CollectionSystemSub extends UICommonAPI;

const MAX_COLLECTION_SLOT_NUM = 6;
const TITLE_RECORD_INDEX = -2;
const TITLE_RECORD_INDEX_NORMAL = -1;
const NUMOFINSERTONCE = 8;
const NUMOFMODIFYONCE = 20;

struct indexInfoStruct
{
	var int CollectionID;
	var int Index;
	var bool IsKeyItem;
	var int sortScore;
};

var WindowHandle Me;
var string m_Windowname;
var L2Util util;
var RichListCtrlHandle CollectionList_ListCtrl;
var CollectionSystem collectionSystemScript;
var CollectionSystemCategory collectionSystemCategoryScript;
var CollectionSystemProgressComponent ProgressCollectionComplete_wndScript;
var CollectionSystemProgressComponent ProgressItemComplete_wndScript;
var EditBoxHandle EditBoxFind_EditBox;
var ComboBoxHandle A0_ComboBox;
var ComboBoxHandle A1_ComboBox;
var TextureHandle Img00_tex;
var TextBoxHandle SearchFailed_txt;
var CollectionCount currentCollectionCount;
var L2UITimerObject tObject;
var int RemainTime;
var bool bUseGroupTitle;
var bool bUseNormalTitle;
var L2UITimerObject tObjectHandleList;
var array<int> collectionIds;
var array<RichListCtrlRowData> records;
var array<indexInfoStruct> indexInfos;
var L2UITimerObject tObjectHandleListModify;
//var delegate<SortByNameDelegate> __SortByNameDelegate__Delegate;
//var delegate<SortRecordListByNameDelegate> __SortRecordListByNameDelegate__Delegate;
//var delegate<SortRecordListDelegate> __SortRecordListDelegate__Delegate;
//var delegate<SortEventGroup> __SortEventGroup__Delegate;

function InitTimerObject()
{
	tObject = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject((1000 * 60), -1);
	tObject._DelegateOnTime = HandleDelegateOnTime;
	tObject._Pause();
	tObjectHandleList = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(1, -1);
	tObjectHandleList._DelegateOnStart = HandleDelegateOnStartList;
	tObjectHandleList._DelegateOnTime = HandleDelegateOnTimeList;
	tObjectHandleList._Pause();
	tObjectHandleListModify = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(1, -1);
	tObjectHandleListModify._DelegateOnStart = HandleDelegateOnStartListModify;
	tObjectHandleListModify._DelegateOnTime = HandleDelegateOnTimeListModify;
	tObjectHandleListModify._Pause();
	return;
}

function SetSearchInit()
{
	A0_ComboBox.SetSelectedNum(0);
	A1_ComboBox.SetSelectedNum(0);
	EditBoxFind_EditBox.SetString("");
	return;
}

function InitComboBoxes()
{
	local int i;
	local array<CollectionOption> Options;

	A0_ComboBox.Clear();
	A0_ComboBox.SYS_AddString(144);
	A0_ComboBox.SYS_AddString(13498);
	A0_ComboBox.SYS_AddString(13497);
	A0_ComboBox.SYS_AddString(13701);
	A1_ComboBox.Clear();
	A1_ComboBox.SYS_AddString(144);
	collectionSystemScript.API_GetCollectionOption(Options);
	i = 0;
	while((i < Options.Length))
	{
		A1_ComboBox.AddString(Options[i].Name);
		i++;
	}
	A0_ComboBox.SetSelectedNum(0);
	A1_ComboBox.SetSelectedNum(0);
	return;
}

function InitComboboxA1()
{
	local int i;
	local array<string> optionNames;

	A1_ComboBox.Clear();
	collectionSystemScript.API_GetCollectionOptionName(collectionSystemScript.selectedCategory, optionNames);
	// optionNames.Sort(SortByNameDelegate);   // array.Sort() unsupported by this compiler
	A1_ComboBox.SYS_AddString(144);
	i = 0;
	while((i < optionNames.Length))
	{
		A1_ComboBox.AddString(optionNames[i]);
		i++;
	}
	A1_ComboBox.SetSelectedNum(0);
	return;
}

function InitProgressComponents()
{
	local string _progressWindowName;

	_progressWindowName = (m_Windowname $ ".SubContents.ProgressCollectionComplete_wnd");
	GetWindowHandle(_progressWindowName).SetScript("CollectionSystemProgressComponent");
	ProgressCollectionComplete_wndScript = CollectionSystemProgressComponent(GetWindowHandle(_progressWindowName).GetScript());
	ProgressCollectionComplete_wndScript.Init(_progressWindowName);
	ProgressCollectionComplete_wndScript.DelegateOnButtonClick = HandleOnClickProgressComponent;
	_progressWindowName = (m_Windowname $ ".SubContents.ProgressItemComplete_wnd");
	GetWindowHandle(_progressWindowName).SetScript("CollectionSystemProgressComponent");
	ProgressItemComplete_wndScript = CollectionSystemProgressComponent(GetWindowHandle(_progressWindowName).GetScript());
	ProgressItemComplete_wndScript.Init(_progressWindowName);
	ProgressItemComplete_wndScript.DelegateOnButtonClick = HandleOnClickProgressComponent;
	return;
}

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	util = L2Util(GetScript("L2Util"));
	collectionSystemScript = CollectionSystem(GetScript("CollectionSystem"));
	collectionSystemCategoryScript = CollectionSystemCategory(GetScript("CollectionSystem.CollectionSystemCategory"));
	CollectionList_ListCtrl = GetRichListCtrlHandle((m_Windowname $ ".SubContents.CollectionList_ListCtrl"));
	CollectionList_ListCtrl.SetTooltipType("CollectionSystemListTooltip");
	InitProgressComponents();
	EditBoxFind_EditBox = GetEditBoxHandle((m_Windowname $ ".SubContents.EditBoxFind_EditBox"));
	A0_ComboBox = GetComboBoxHandle((m_Windowname $ ".SubContents.A0_ComboBox"));
	A1_ComboBox = GetComboBoxHandle((m_Windowname $ ".SubContents.A1_ComboBox"));
	Img00_tex = GetTextureHandle((m_Windowname $ ".SubContents.Img00_tex"));
	SearchFailed_txt = GetTextBoxHandle((m_Windowname $ ".SubContents.SearchFailed_txt"));
	InitComboBoxes();
	CollectionList_ListCtrl.SetSelectedSelTooltip(false);
	CollectionList_ListCtrl.SetUseStripeBackTexture(false);
	CollectionList_ListCtrl.SetAppearTooltipAtMouseX(true);
	InitTimerObject();
	return;
}

event OnLoad()
{
	Initialize();
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "Close_btn":
			collectionSystemScript.SetState(non);
			break;
		case "Main_btn":
			collectionSystemScript.SetState(stand);
			break;
		case "btnInfo":
			HandleShowDetailInfo();
			break;
		case "favoriteBtn":
			HandleFavoriteBtn();
			break;
		case "ClearEditBox_Btn":
			SetFindKeyWord("");
			SetCategory(collectionSystemScript.selectedCategory);
			break;
		case "Find_Btn":
			SetCategory(collectionSystemScript.selectedCategory);
			break;
		default:
			break;
	}
	return;
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	HandleShowDetailInfo();
	return;
}

event bool OnKeyDown(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	local string mainKey;

	if((EditBoxFind_EditBox.IsFocused() && Me.IsShowWindow()))
	{
		mainKey = Class'NWindow.InputAPI'.static.GetKeyString(nKey);
		if((mainKey == "ENTER"))
		{
			SetCategory(collectionSystemScript.selectedCategory);
		}
	}
	return false;
}

event OnClickHeaderCtrl(string strID, int Index)
{
	if(((collectionSystemScript.favoriteCategory - 1) != collectionSystemScript.selectedCategory))
	{
		return;
	}
	SortEventCategory();
	return;
}

function HandleShowDetailInfo()
{
	if((GetSelectedCollectionID() > 0))
	{
		collectionSystemScript.SetState(detailinfo);
	}
	return;
}

function HandleFavoriteBtn()
{
	local bool bRegister;
	local int favorited, nCollectionID;

	favorited = GetFavoriteSelected();
	if((favorited == -1))
	{
		return;
	}
	bRegister = (GetFavoriteSelected() != 1);
	nCollectionID = GetSelectedCollectionID();
	collectionSystemScript.API_C_EX_COLLECTION_UPDATE_FAVORITE(bRegister, nCollectionID);
	return;
}

function HandleOnClickProgressComponent()
{
	switch(collectionSystemScript.CurrentState)
	{
		case Sub:
			collectionSystemScript.SetState(subProgress);
			break;
		case stand:
			collectionSystemScript.SetState(mainProgress);
			break;
		default:
			break;
	}
	return;
}

function Show()
{
	Me.ShowWindow();
	return;
}

function SetFindKeyWord(string ItemName)
{
	EditBoxFind_EditBox.SetString(ItemName);
	return;
}

function bool GetTmpListData(int CollectionID, int Index)
{
	local CollectionInfo cInfo;
	local CollectionData cData;
	local bool IsKeyItem, isCompleted, canregist;
	local array<ItemInfo> o_iIonfos;
	local array<CollectionRegistFailReason> o_failReasons;
	local UIScript.CollectionRegistFailReason o_failReason;
	local array<int> o_canRegists;
	local int recordIndex, sortScore;

	if((collectionSystemScript.API_GetCollectionInfo(CollectionID, cInfo) == false))
	{
		return false;
	}
	if((cInfo.isFavorite == false))
	{
		if((collectionSystemScript.selectedCategory == collectionSystemScript.favoriteCategory))
		{
			return false;
		}
	}
	if(!collectionSystemScript.API_GetCollectionData(CollectionID, cData))
	{
		return false;
	}
	IsKeyItem = collectionSystemScript.IsKeyItem(CollectionID);
	isCompleted = GetItemList(cInfo, cData, o_iIonfos);
	canregist = GetRegistrationStates(cData, o_canRegists, o_failReasons, o_failReason);
	if(isCompleted)
	{
	}
	else if(canregist)
	{
		(sortScore += 8);
	}
	else
	{
		switch(o_failReason)
		{
			case CRFR_OverNeedEnchant:
				(sortScore += 6);
				break;
			case CRFR_UnderNeedEnchant:
			case CRFR_HaveNotEnoughItem:
				(sortScore += 4);
				break;
			case CRFR_None:
				(sortScore += 2);
				break;
			default:
				break;
		}
	}
	if(IsKeyItem)
	{
		(sortScore += 1);
	}
	indexInfos.Length = (Index + 1);
	indexInfos[Index].CollectionID = CollectionID;
	indexInfos[Index].Index = Index;
	indexInfos[Index].IsKeyItem = IsKeyItem;
	indexInfos[Index].sortScore = sortScore;
	if((((EditBoxFind_EditBox.GetString() == "") && (A0_ComboBox.GetSelectedNum() == 0)) && (A1_ComboBox.GetSelectedNum() == 0)))
	{
		// indexInfos.Sort(SortRecordListByNameDelegate);   // array.Sort() unsupported by this compiler
	}
	else
	{
		// indexInfos.Sort(SortRecordListDelegate);   // array.Sort() unsupported by this compiler
	}
	return true;
}

function HandleDelegateOnStartListModify()
{
	tObjectHandleList._Stop();
	return;
}

function HandleDelegateOnTimeListModify(int Count)
{
	local int Len, i, startIndex;

	startIndex = (Count * 20);
	Len = Min(CollectionList_ListCtrl.GetRecordCount(), (startIndex + 20));
	i = startIndex;
	while((i < Len))
	{
		ModifyRecordByIndex(i);
		i++;
	}
	if((i < CollectionList_ListCtrl.GetRecordCount()))
	{
		return;
	}
	tObjectHandleListModify._Stop();
	return;
}

function HandleDelegateOnStartList()
{
	local int i, Index;

	tObjectHandleListModify._Stop();
	CollectionList_ListCtrl.DeleteAllItem();
	indexInfos.Length = 0;
	records.Length = 0;
	i = 0;
	while((i < collectionIds.Length))
	{
		if((GetTmpListData(collectionIds[i], Index) == false))
		{
			i++;
			continue;
		}
		Index++;
		i++;
	}
	collectionIds.Length = 0;
	bUseGroupTitle = false;
	bUseNormalTitle = false;
	return;
}

function HandleDelegateOnTimeList(int Count)
{
	local int i, Len, CollectionID, startIndex;
	local RichListCtrlRowData Record;

	startIndex = (Count * 8);
	Len = Min(indexInfos.Length, (8 + startIndex));
	i = startIndex;
	while((i < Len))
	{
		CollectionID = indexInfos[i].CollectionID;
		InsertRecordByCollectionID(CollectionID);
		i++;
	}
	if((i < indexInfos.Length))
	{
		return;
	}
	tObjectHandleList._Stop();
	ResultMakeRecord();
	records.Length = 0;
	indexInfos.Length = 0;
	ChkSearchFailed_txt();
	return;
}

function HandleDelegateOnTime(int Count)
{
	RemainTime = (RemainTime - 60);
	ModifyTitleTime();
	return;
}

function ModifyTitleTime()
{
	local RichListCtrlRowData rowData;

	CollectionList_ListCtrl.GetRec(0, rowData);
	if((rowData.nReserved1 != INT64(-2)))
	{
		return;
	}
	rowData.cellDataList[0].drawitems[3].strInfo.strColor = GetColorWithRemainTime();
	rowData.cellDataList[0].drawitems[3].strInfo.strData = (GetStringDayAndTime(RemainTime) @ GetSystemString(14874));
	CollectionList_ListCtrl.ModifyRecord(0, rowData);
	return;
}

function HandleCollectionRegisted(string param)
{
	local int Success, CollectionID, Index;

	ParseInt(param, "Success", Success);
	if((Success != 1))
	{
		return;
	}
	ParseInt(param, "CollectionID", CollectionID);
	Index = GetRecordIndexByCollectionID(CollectionID);
	if((Index != -1))
	{
		ModifyRecordByIndex(Index);
	}
	ResetCollectionCount();
	return;
}

function ResetCollectionCount()
{
	if(SetCurrentCollectionCount())
	{
		SetCollectionCount();
	}
	CollectionList_ListCtrl.SetFocus();
	return;
}

function ModifyRecordByCollectionID(int CollectionID)
{
	local int Index;

	Index = GetRecordIndexByCollectionID(CollectionID);
	ModifyRecordByIndex(Index);
	return;
}

function DeleteRecordByCollectionID(int CollectionID)
{
	local int Index;

	Index = GetRecordIndexByCollectionID(CollectionID);
	Debug("즐겨 찾기 갱신");  // EN?: Renew your favorites
	if((Index == -1))
	{
		return;
	}
	CollectionList_ListCtrl.DeleteRecord(Index);
	ChkSearchFailed_txt();
	return;
}

function InsertRecordByCollectionID(int CollectionID)
{
	local RichListCtrlRowData Record;

	makeRecord(CollectionID, Record);
	InsertRecordDataMaked(Record, CollectionID);
	return;
}

function ModifyRecordByIndex(int Index)
{
	local RichListCtrlRowData Record;
	local int CollectionID;

	CollectionList_ListCtrl.GetRec(Index, Record);
	CollectionID = int(Record.nReserved1);
	makeRecord(CollectionID, Record);
	CollectionList_ListCtrl.ModifyRecord(Index, Record);
	return;
}

function Color GetColorWithRemainTime()
{
	if((RemainTime > ((60 * 60) * 168)))
	{
		return getInstanceL2Util().White;
	}
	else
	{
		return getInstanceL2Util().DRed;
	}
}

function SetTextureByCategory()
{
	local int Index;

	Index = (collectionSystemScript.selectedCategory - 1);
	Img00_tex.SetTexture(("L2UI_EPIC.CollectionSystemWnd.KeyItem" $ collectionSystemScript.GetStringKeyByIndex(Index)));
	return;
}

delegate int SortByNameDelegate(string name0, string name1)
{
	if((name0 > name1))
	{
		return -1;
	}
	return 0;
}

delegate int SortRecordListByNameDelegate(indexInfoStruct structA, indexInfoStruct structB)
{
	if((!structA.IsKeyItem && structB.IsKeyItem))
	{
		return -1;
	}
	return 0;
}

delegate int SortRecordListDelegate(indexInfoStruct structA, indexInfoStruct structB)
{
	if((structA.sortScore < structB.sortScore))
	{
		return -1;
	}
	return 0;
}

function SortIndexInfoByIsKeyItem()
{
	local int h, i, j;
	local indexInfoStruct tmp;

	h = (indexInfos.Length / 2);
	while((h > 0))
	{
		i = h;
		while((i < indexInfos.Length))
		{
			tmp = indexInfos[i];
			j = (i - h);
			while(((j >= 0) && ((indexInfos[i].IsKeyItem == false) && (tmp.IsKeyItem == true))))
			{
				indexInfos[(j + h)] = indexInfos[j];
				(j -= h);
			}
			indexInfos[(j + h)] = tmp;
			i++;
		}
		(h /= 2.0000000);
	}
	return;
}

function CheckAllCategorys()
{
	local int i;

	if((((A0_ComboBox.GetSelectedNum() == 0) && (A1_ComboBox.GetSelectedNum() == 0)) && (EditBoxFind_EditBox.GetString() == "")))
	{
		return;
	}
	i = 1;
	while((i <= collectionSystemScript.MAX_CATEGORY))
	{
		CheckCategoryDotByCategory(i);
		i++;
	}
	return;
}

function CheckCategoryDotByCategory(int Category)
{
	local int i, selectedNum0, selectedNum1, CollectionID;
	local array<int> collectionIds;
	local string optionKeyward;

	selectedNum0 = A0_ComboBox.GetSelectedNum();
	selectedNum1 = A1_ComboBox.GetSelectedNum();
	if((A1_ComboBox.GetSelectedNum() == 0))
	{
		optionKeyward = "";
	}
	else
	{
		optionKeyward = A1_ComboBox.GetString(selectedNum1);
	}
	collectionSystemCategoryScript.HideDot(Category);
	if((collectionSystemScript.API_GetCollectionIdByItemName(collectionIds, Category, (selectedNum0 == 1), (selectedNum0 == 2), (collectionSystemScript.favoriteCategory == Category), EditBoxFind_EditBox.GetString(), optionKeyward, (selectedNum0 == 3)) == false))
	{
		collectionSystemCategoryScript.ShowDot(i, 3);
		return;
	}
	i = 0;
	while((i < collectionIds.Length))
	{
		CollectionID = collectionIds[i];
		if((CheckCategoryDotByCollectionID(Category, CollectionID) == true))
		{
			return;
		}
		i++;
	}
	return;
}

function bool CheckCategoryDotByCollectionID(int Category, int CollectionID)
{
	local bool canregist;
	local CollectionData cData;
	local int nNotEnoughEnchanted, nHaveNotEnoughListNum, nOverNeedEnchantList;

	if(!collectionSystemScript.API_GetCollectionData(CollectionID, cData))
	{
		return false;
	}
	canregist = CanRegistrationCollectionData(cData, nNotEnoughEnchanted, nHaveNotEnoughListNum, nOverNeedEnchantList);
	if(canregist)
	{
		collectionSystemCategoryScript.ShowDot(Category, 1);
		return true;
	}
	else if(((nNotEnoughEnchanted > 0) || (nHaveNotEnoughListNum > 0)))
	{
		collectionSystemCategoryScript.ShowDot(Category, 2);
	}
	else if((nOverNeedEnchantList > 0))
	{
		collectionSystemCategoryScript.ShowDot(Category, 4);
	}
	return false;
}

function _SetRemainTime(int _remainTime)
{
	RemainTime = _remainTime;
	ModifyTitleTime();
	if((IsEventCategory() && (RemainTime > 0)))
	{
		tObject._Reset();
	}
	else
	{
		tObject._Stop();
	}
	return;
}

function _StopTimer()
{
	tObject._Stop();
	return;
}

function SetCategory(int Category)
{
	local int i, selectedNum0, selectedNum1;
	local string optionKeyward;
	local bool isFavoriteCategory;

	SetTextureByCategory();
	selectedNum0 = A0_ComboBox.GetSelectedNum();
	selectedNum1 = A1_ComboBox.GetSelectedNum();
	if((A1_ComboBox.GetSelectedNum() == 0))
	{
		optionKeyward = "";
	}
	else
	{
		optionKeyward = A1_ComboBox.GetString(selectedNum1);
	}
	isFavoriteCategory = (collectionSystemScript.favoriteCategory == Category);
	switch(collectionSystemScript.requestedMode)
	{
		case Normal:
			collectionSystemScript.API_GetCollectionIdByItemName(collectionIds, Category, (selectedNum0 == 1), (selectedNum0 == 2), isFavoriteCategory, EditBoxFind_EditBox.GetString(), optionKeyward, (selectedNum0 == 3));
			tObjectHandleList._Reset();
			break;
		case modify:
			collectionSystemScript.requestedMode = Normal;
			tObjectHandleListModify._Reset();
			ResetCollectionCount();
			break;
		default:
			break;
	}
	CheckAllCategorys();
	return;
}

function ChkSearchFailed_txt()
{
	if((CollectionList_ListCtrl.GetRecordCount() == 0))
	{
		SearchFailed_txt.ShowWindow();
		if((((A0_ComboBox.GetSelectedNum() == 0) && (A1_ComboBox.GetSelectedNum() == 0)) && (EditBoxFind_EditBox.GetString() == "")))
		{
			SearchFailed_txt.SetText(GetSystemString(13512));
		}
		else
		{
			SearchFailed_txt.SetText(GetSystemMessage(3373));
		}
	}
	else
	{
		SearchFailed_txt.HideWindow();
	}
	return;
}

function InsertRecordDataMaked(RichListCtrlRowData Record, int currentCollectionID)
{
	local RichListCtrlRowData titleRecord;
	local CollectionData cData;

	CollectionList_ListCtrl.InsertRecord(Record);
	if((IsEventCategory() == false))
	{
		return;
	}
	collectionSystemScript.API_GetCollectionData(currentCollectionID, cData);
	if((cData.bDurationEvent == true))
	{
		if((MakeRecordEventGroupTitle(titleRecord) == true))
		{
			CollectionList_ListCtrl.InsertRecord(titleRecord);
			bUseGroupTitle = true;
		}
	}
	else if((MakeRecordEventNormalTitle(titleRecord) == true))
	{
		CollectionList_ListCtrl.InsertRecord(titleRecord);
		bUseNormalTitle = true;
	}
	return;
}

function ResultMakeRecord()
{
	if(IsEventCategory())
	{
		SortEventCategory();
	}
	ResetCollectionCount();
	return;
}

function int GetFavoriteSelected()
{
	local RichListCtrlRowData Record;

	CollectionList_ListCtrl.GetSelectedRec(Record);
	return Record.cellDataList[2].nReserved1;
}

function int GetSelectedCollectionID()
{
	local RichListCtrlRowData Record;

	CollectionList_ListCtrl.GetSelectedRec(Record);
	return int(Record.nReserved1);
}

function bool SetSelectByCollectionID(int CollectionID)
{
	local int Index;

	Index = GetRecordIndexByCollectionID(CollectionID);
	if((Index < 0))
	{
		return false;
	}
	CollectionList_ListCtrl.SetSelectedIndex(Index, true);
}

function int GetRecordIndexByCollectionID(int CollectionID)
{
	local RichListCtrlRowData Record;
	local int i;

	i = 0;
	while((i < CollectionList_ListCtrl.GetRecordCount()))
	{
		CollectionList_ListCtrl.GetRec(i, Record);
		if((Record.nReserved1 == INT64(CollectionID)))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function bool SetCurrentCollectionCount()
{
	local int i;
	local CollectionCount tmpCollectionCount;

	currentCollectionCount.CollectionTotalCount = 0;
	currentCollectionCount.CollectionCompleteCount = 0;
	currentCollectionCount.CollectionProgressCount = 0;
	currentCollectionCount.SlotTotalCount = 0;
	currentCollectionCount.SlotRegistCount = 0;
	i = 1;
	while((i < (collectionSystemScript.MAX_CATEGORY - 1)))
	{
		if(!collectionSystemScript.API_GetCollectionCount(i, tmpCollectionCount))
		{
			return false;
		}
		(currentCollectionCount.CollectionTotalCount += tmpCollectionCount.CollectionTotalCount);
		(currentCollectionCount.CollectionCompleteCount += tmpCollectionCount.CollectionCompleteCount);
		(currentCollectionCount.CollectionProgressCount += tmpCollectionCount.CollectionProgressCount);
		(currentCollectionCount.SlotTotalCount += tmpCollectionCount.SlotTotalCount);
		(currentCollectionCount.SlotRegistCount += tmpCollectionCount.SlotRegistCount);
		i++;
	}
	return true;
}

function SetCollectionCount()
{
	ProgressCollectionComplete_wndScript.SetPoint(currentCollectionCount.CollectionCompleteCount, currentCollectionCount.CollectionTotalCount);
	ProgressItemComplete_wndScript.SetPoint(currentCollectionCount.SlotRegistCount, currentCollectionCount.SlotTotalCount);
	collectionSystemScript.CollectionSystemSubPopupProgressScript.SetProgressCollection(currentCollectionCount.CollectionTotalCount, currentCollectionCount.CollectionCompleteCount, currentCollectionCount.CollectionProgressCount);
	collectionSystemScript.CollectionSystemSubPopupProgressScript.SetProgressItem(currentCollectionCount.SlotTotalCount, currentCollectionCount.SlotRegistCount);
	collectionSystemScript.ProgressCollectionComplete_wndScript.SetPoint(currentCollectionCount.CollectionCompleteCount, currentCollectionCount.CollectionTotalCount);
	collectionSystemScript.ProgressItemComplete_wndScript.SetPoint(currentCollectionCount.SlotRegistCount, currentCollectionCount.SlotTotalCount);
	return;
}

function bool IsEventCategory()
{
	return ((collectionSystemScript.favoriteCategory - 1) == collectionSystemScript.selectedCategory);
}

function string GetOptionByOptionID(int option_id)
{
	local string strDesc1, strDesc2, strDesc3;

	if(Class'NWindow.UIDATA_REFINERYOPTION'.static.GetOptionDescription(option_id, strDesc1, strDesc2, strDesc3))
	{
		return strDesc1;
	}
	return "";
}

function string Int2Str2(int i)
{
	if((i < 10))
	{
		return ("0" $ string(i));
	}
	return string(i);
}

function bool GetStringIDFromBtnName(string btnName, string someString, out string strID)
{
	if(!CheckBtnName(btnName, someString))
	{
		return false;
	}
	strID = Mid(btnName, Len(someString));
	return true;
}

function bool CheckBtnName(string btnName, string someString)
{
	return (Left(btnName, Len(someString)) == someString);
}

function bool getSlotItemInfo(CollectionSlotItem cSItem, CollectionItemInfo cIInfo, out ItemInfo slotItemInfo)
{
	if((cIInfo.nItemClassID > 0))
	{
		if(!Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(cIInfo.nItemClassID), slotItemInfo))
		{
			return false;
		}
		slotItemInfo.IsBlessedItem = (int(byte(cSItem.BlessCondition)) == 1);
		slotItemInfo.Enchanted = cIInfo.Enchant;
		slotItemInfo.ItemNum = INT64(cIInfo.Amount);
		slotItemInfo.BlessPanelDrawType = EBlessPanelDrawType(cIInfo.BlessCondition);
	}
	else
	{
		if(!Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(cSItem.ItemID), slotItemInfo))
		{
			return false;
		}
		slotItemInfo.IsBlessedItem = (int(byte(cSItem.BlessCondition)) == 1);
		slotItemInfo.Enchanted = cSItem.EnchantCondition;
		slotItemInfo.ItemNum = INT64(cSItem.ItemCount);
		slotItemInfo.BlessPanelDrawType = EBlessPanelDrawType(cSItem.BlessCondition);
		slotItemInfo.bDisabled = 1;
	}
	slotItemInfo.bShowCount = IsStackableItem(slotItemInfo.ConsumeType);
	return true;
}

function bool GetItemList(CollectionInfo cInfo, CollectionData cData, out array<ItemInfo> iIonfos)
{
	local int i;
	local bool isCompleted;
	local ItemInfo iInfo;

	isCompleted = true;
	if((cData.SlotItems.Length == 0))
	{
		return false;
	}
	i = 0;
	while((i < cData.SlotItems.Length))
	{
		if((cData.SlotItems[i].Representative == true))
		{
			if(!getSlotItemInfo(cData.SlotItems[i], cInfo.ItemInfo[cData.SlotItems[i].SlotID], iInfo))
			{
				i++;
				continue;
			}
			if((iInfo.bDisabled == 1))
			{
				isCompleted = false;
			}
			iIonfos[iIonfos.Length] = iInfo;
		}
		i++;
	}
	return isCompleted;
}

function bool bUseReplaceItem(int SlotID, CollectionData cData)
{
	local int i;

	i = 0;
	while((i < cData.SlotItems.Length))
	{
		if((cData.SlotItems[i].SlotID == SlotID))
		{
			if((cData.SlotItems[i].Representative == false))
			{
				return true;
			}
		}
		i++;
	}
	return false;
}

function bool MakeRecordEventGroupTitle(out RichListCtrlRowData oRecord)
{
	if((bUseGroupTitle == true))
	{
		return false;
	}
	oRecord.cellDataList.Length = 5;
	oRecord.nReserved1 = INT64(-2);
	AddRichListCtrlString(oRecord.cellDataList[0].drawitems, GetSystemString(14872), GetColor(255, 221, 102, 255), false, 0, 0, "hs15");
	AddRichListCtrlNewLine(oRecord.cellDataList[0].drawitems, 0, 6);
	AddRichListCtrlButton(oRecord.cellDataList[0].drawitems, "helpNormalBtn", 0, 0, "L2UI_NewTex.Button.BTN_Help_Normal", "L2UI_NewTex.Button.BTN_Help_Normal", "L2UI_NewTex.Button.BTN_Help_Normal", 23, 22, 23, 22, 9999, "collectionGroupHelpBtn");
	AddRichListCtrlString(oRecord.cellDataList[0].drawitems, (GetStringDayAndTime(RemainTime) @ GetSystemString(14874)), GetColorWithRemainTime(), false, 3, 4);
	oRecord.sOverlayTex = "L2UI_EPIC.CollectionSystemWnd.ListHeader_Blue";
	return true;
}

function bool MakeRecordEventNormalTitle(out RichListCtrlRowData oRecord)
{
	local CollectionData cData;

	if((bUseNormalTitle == true))
	{
		return false;
	}
	oRecord.cellDataList.Length = 5;
	oRecord.nReserved1 = INT64(-1);
	AddRichListCtrlString(oRecord.cellDataList[0].drawitems, GetSystemString(14873), GetColor(255, 221, 102, 255), false, 0, 0, "hs15");
	AddRichListCtrlNewLine(oRecord.cellDataList[0].drawitems, 0, 10);
	oRecord.sOverlayTex = "L2UI_EPIC.CollectionSystemWnd.ListHeader_Green";
	return true;
}

function bool makeRecord(int CollectionID, out RichListCtrlRowData outRecord)
{
	local int i;
	local CollectionInfo cInfo;
	local CollectionData cData;
	local RichListCtrlRowData Record;
	local array<ItemInfo> iIonfos;
	local bool IsKeyItem;
	local CollectionMainData mainData;
	local int nWidth, nHeight;
	local bool isCompleted, canregist;
	local array<CollectionRegistFailReason> failReasons;
	local UIScript.CollectionRegistFailReason failReason;
	local array<int> canRegists;
	local int sortScore;
	local string ellipsedOptionName;

	Record.cellDataList.Length = 5;
	Record.nReserved1 = INT64(CollectionID);
	if(!collectionSystemScript.API_GetCollectionInfo(CollectionID, cInfo))
	{
		return false;
	}
	if(!collectionSystemScript.API_GetCollectionData(CollectionID, cData))
	{
		return false;
	}
	collectionSystemScript.API_GetCollectionMainData(cData.main_category, mainData);
	IsKeyItem = collectionSystemScript.IsKeyItem(CollectionID);
	if(IsKeyItem)
	{
		Record.cellDataList[0].nReserved1 = 1;
	}
	else
	{
		Record.cellDataList[0].nReserved1 = 0;
	}
	Record.cellDataList[0].szData = cData.collection_name;
	AddRichListCtrlString(Record.cellDataList[0].drawitems, Record.cellDataList[0].szData, util.White, false);
	AddRichListCtrlNewLine(Record.cellDataList[0].drawitems, 0, 3);
	Record.cellDataList[0].HiddenStringForSorting = Record.cellDataList[0].szData;
	isCompleted = GetItemList(cInfo, cData, iIonfos);
	i = 0;
	while((i < iIonfos.Length))
	{
		AddRichListCtrlItem(Record.cellDataList[0].drawitems, iIonfos[i], 32, 32, 5);
		i++;
	}
	Record.cellDataList[1].szData = GetOptionByOptionID(cData.option_id);
	if((cData.Period > 0))
	{
		addRichListCtrlTexture(Record.cellDataList[1].drawitems, "L2UI_ct1.DailyMissionWnd.DailyMissionWnd_IconTime", 12, 12);
	}
	ellipsedOptionName = Record.cellDataList[1].szData;
	Class'InterfaceClassic.L2Util'.static.GetEllipsisString(ellipsedOptionName, 232);
	AddRichListCtrlString(Record.cellDataList[1].drawitems, ellipsedOptionName, util.ColorGold, false);
	Record.cellDataList[1].HiddenStringForSorting = Record.cellDataList[1].szData;
	if(cInfo.isFavorite)
	{
		Record.cellDataList[2].nReserved1 = 1;
		AddRichListCtrlButton(Record.cellDataList[2].drawitems, "favoriteBtn", 0, 0, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_FavoriteBtn", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_FavoriteBtn", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_FavoriteBtn", 32, 32, 32, 32);
		Record.cellDataList[2].HiddenStringForSorting = "1";
	}
	else
	{
		if((collectionSystemScript.selectedCategory == collectionSystemScript.favoriteCategory))
		{
			return false;
		}
		Record.cellDataList[2].nReserved1 = 0;
		AddRichListCtrlButton(Record.cellDataList[2].drawitems, "favoriteBtn", 0, 0, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_FavoriteBg", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_FavoriteBg", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_FavoriteBg", 32, 32, 32, 32);
		Record.cellDataList[2].HiddenStringForSorting = "0";
	}
	if(((!isCompleted || cInfo.isReward) || (cData.RewardItems.Length == 0)))
	{
		addRichListCtrlTexture(Record.cellDataList[3].drawitems, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_AdditionalReward_Get", 34, 38);
		Record.cellDataList[3].HiddenStringForSorting = "1";
	}
	else
	{
		addRichListCtrlTexture(Record.cellDataList[3].drawitems, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_AdditionalReward", 34, 38);
		Record.cellDataList[3].HiddenStringForSorting = "0";
	}
	canregist = GetRegistrationStates(cData, canRegists, failReasons, failReason);
	if(isCompleted)
	{
		if(IsKeyItem)
		{
			AddRichListCtrlButton(Record.cellDataList[4].drawitems, "btnInfo", 0, 0, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_YellowBtn", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_YellowBtn_down", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_YellowBtn_over", 108, 30, 108, 30);
		}
		else
		{
			AddRichListCtrlButton(Record.cellDataList[4].drawitems, "btnInfo", 0, 0, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_GreenBtn", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_GreenBtn_down", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_GreenBtn_over", 108, 30, 108, 30);
		}
	}
	else if(canregist)
	{
		AddRichListCtrlButton(Record.cellDataList[4].drawitems, "btnInfo", 0, 0, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DotBtn", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DotBtn_down", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DotBtn_over", 108, 30, 108, 30);
		(sortScore += 8);
	}
	else
	{
		switch(failReason)
		{
			case CRFR_OverNeedEnchant:
				(sortScore += 6);
				AddRichListCtrlButton(Record.cellDataList[4].drawitems, "btnInfo", 0, 0, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DotBtnSky", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DotBtnSky_Down", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DotBtnSky_over", 108, 30, 108, 30);
				break;
			case CRFR_UnderNeedEnchant:
			case CRFR_HaveNotEnoughItem:
				(sortScore += 4);
				AddRichListCtrlButton(Record.cellDataList[4].drawitems, "btnInfo", 0, 0, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DotBtnEnchant", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DotBtnEnchant_Down", "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_DotBtnEnchant_over", 108, 30, 108, 30);
				break;
			case CRFR_None:
				(sortScore += 2);
				AddRichListCtrlButton(Record.cellDataList[4].drawitems, "btnInfo", 0, 0, "L2UI_ct1.LCoinShopWnd.LCoinShopWnd_DF_Button", "L2UI_ct1.LCoinShopWnd.LCoinShopWnd_DF_Button_down", "L2UI_ct1.LCoinShopWnd.LCoinShopWnd_DF_Button_over", 108, 30, 108, 30);
				break;
			default:
				break;
		}
	}
	if(IsKeyItem)
	{
		(sortScore += 1);
	}
	Record.cellDataList[4].HiddenStringForSorting = string(sortScore);
	GetTextSizeDefault(GetSystemString(1797), nWidth, nHeight);
	AddRichListCtrlString(Record.cellDataList[4].drawitems, GetSystemString(1797), util.White, false, (-(108 + nWidth) / 2), ((30 - nHeight) / 2));
	Record.sOverlayTex = GetOverlayTex(CollectionID, isCompleted, IsKeyItem);
	Record.ForceRefreshTooltip = true;
	if((EditBoxFind_EditBox.GetString() != ""))
	{
		AddRichListCtrlNewLine(Record.cellDataList[0].drawitems, 0, -33);
		i = 0;
		while((i < iIonfos.Length))
		{
			if((ChkReplaceItems(cData, i) || (FindMatchString(iIonfos[i].Name, EditBoxFind_EditBox.GetString()) == 1)))
			{
				addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_EPIC.CollectionSystemWnd.SearchItemAni_0000", 33, 33, 4, 0, 64, 64);
				i++;
				continue;
			}
			addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_CT1.EmptyBtn", 33, 33, 4);
			i++;
		}
	}
	AddRichListCtrlNewLine(Record.cellDataList[0].drawitems, (-32 + 6), -32);
	i = 0;
	while((i < canRegists.Length))
	{
		if((canRegists[i] > 0))
		{
			addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_EPIC.CollectionSystemWnd_Registration", 8, 8, (32 - 3));
			i++;
			continue;
		}
		switch(failReasons[i])
		{
			case CRFR_UnderNeedEnchant:
			case CRFR_HaveNotEnoughItem:
				addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_EPIC.CollectionSystemWnd_Insufficient", 8, 8, (32 - 3));
				break;
			case CRFR_OverNeedEnchant:
				addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_OverEnchant", 8, 8, (32 - 3));
				break;
			case CRFR_None:
				addRichListCtrlTexture(Record.cellDataList[0].drawitems, "L2UI_CT1.EmptyBtn", 8, 8, (32 - 3));
				break;
			default:
				break;
		}
		i++;
	}
	Record.szReserved = string(CollectionID);
	outRecord = Record;
	return true;
}

function bool ChkReplaceItems(CollectionData cData, int SlotID)
{
	local int i;
	local array<ItemInfo> replaceInfos;

	if(!collectionSystemScript.CollectionSystemPopupDetailsScript.GetReplaceItems(cData, SlotID, replaceInfos))
	{
		return false;
	}
	i = 0;
	while((i < replaceInfos.Length))
	{
		if((FindMatchString(replaceInfos[i].Name, EditBoxFind_EditBox.GetString()) == 1))
		{
			return true;
		}
		i++;
	}
	return false;
}

function int FindMatchString(string ItemName, string findString)
{
	local string delim, modifiedString;

	delim = " ";
	modifiedString = Substitute(ItemName, " ", "", false);
	if(StringMatching(modifiedString, findString, delim))
	{
		return 1;
	}
	else
	{
		return -1;
	}
	return 1;
}

function string GetOverlayTex(int CollectionID, bool isCompleted, bool IsKeyItem)
{
	if(IsKeyItem)
	{
		if(isCompleted)
		{
			return "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_KeyCollectionBg_complete";
		}
		else
		{
			return "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_KeyCollectionBg";
		}
	}
	if(isCompleted)
	{
		return "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_CollectionBg_complete";
	}
	else
	{
		return "";
	}
}

function bool CanRegistrationCollectionData(CollectionData cData, out int nNotEnoughItemNum, out int nHaveNotEnoughListNum, out int nOverNeedEnchantList)
{
	local int i;
	local array<ItemInfo> notEnoughEnchantedList, haveNotEnoughList, overNeedEnchantList;

	i = 0;
	while((i < 6))
	{
		if(collectionSystemScript.CollectionSystemPopupDetailsScript.CanRegistration(cData, i, notEnoughEnchantedList, haveNotEnoughList, overNeedEnchantList))
		{
			return true;
			i++;
			continue;
		}
		nNotEnoughItemNum = Max(nNotEnoughItemNum, notEnoughEnchantedList.Length);
		nHaveNotEnoughListNum = Max(nHaveNotEnoughListNum, haveNotEnoughList.Length);
		nOverNeedEnchantList = Max(nOverNeedEnchantList, overNeedEnchantList.Length);
		i++;
	}
	return false;
}

function bool GetRegistrationStates(CollectionData cData, out array<int> canRegists, out array<CollectionRegistFailReason> failReasons, out UIScript.CollectionRegistFailReason failReason)
{
	local int i;
	local array<ItemInfo> notEnoughEnchantedList, haveNotEnoughList, overNeedEnchantList;
	local bool canregist;

	failReason = CRFR_None;
	i = 0;
	while((i < 6))
	{
		canRegists[i] = int(collectionSystemScript.CollectionSystemPopupDetailsScript.CanRegistration(cData, i, notEnoughEnchantedList, haveNotEnoughList, overNeedEnchantList));
		if((canRegists[i] == 0))
		{
			if((notEnoughEnchantedList.Length > 0))
			{
				failReasons[i] = CRFR_UnderNeedEnchant;
			}
			else if((haveNotEnoughList.Length > 0))
			{
				failReasons[i] = CRFR_UnderNeedEnchant;
			}
			else if((overNeedEnchantList.Length > 0))
			{
				failReasons[i] = CRFR_OverNeedEnchant;
			}
			else
			{
				failReasons[i] = CRFR_None;
			}
			switch(failReason)
			{
				case CRFR_None:
					failReason = CollectionRegistFailReason(failReasons[i]);
					break;
				case CRFR_UnderNeedEnchant:
					if((int(failReasons[i]) == 3))
					{
						failReason = CollectionRegistFailReason(failReasons[i]);
					}
					break;
				case CRFR_OverNeedEnchant:
					break;
				default:
					break;
			}
		}
		if((canRegists[i] > 0))
		{
			canregist = true;
		}
		i++;
	}
	return canregist;
}

function bool GetTestEventGroup(int CollectionID)
{
	return ((CollectionID > 0) && (CollectionID < 440));
}

function SortEventCategory()
{
	local array<RichListCtrlRowData> records;
	local int i;

	records.Length = CollectionList_ListCtrl.GetRecordCount();
	i = 0;
	while((i < records.Length))
	{
		CollectionList_ListCtrl.GetRec(i, records[i]);
		i++;
	}
	CollectionList_ListCtrl.DeleteAllItem();
	// records.Sort(SortEventGroup);   // array.Sort() unsupported by this compiler
	i = 0;
	while((i < records.Length))
	{
		CollectionList_ListCtrl.InsertRecord(records[i]);
		i++;
	}
	return;
}

delegate int SortEventGroup(RichListCtrlRowData rowDataA, RichListCtrlRowData rowDataB)
{
	local CollectionData cDataA, cDataB;

	if((int(rowDataA.nReserved1) == -2))
	{
		return 0;
	}
	else if((int(rowDataB.nReserved1) == -2))
	{
		return -1;
	}
	collectionSystemScript.API_GetCollectionData(int(rowDataB.nReserved1), cDataB);
	if(((int(rowDataA.nReserved1) == -1) && (cDataB.bDurationEvent == false)))
	{
		return 0;
	}
	collectionSystemScript.API_GetCollectionData(int(rowDataA.nReserved1), cDataA);
	if(((int(rowDataB.nReserved1) == -1) && (cDataA.bDurationEvent == false)))
	{
		return -1;
	}
	if(((cDataA.bDurationEvent == false) && (cDataB.bDurationEvent == true)))
	{
		return -1;
	}
	return 0;
}

function bool ChkSerVer()
{
	return getInstanceUIData().GetIsLiveServer();
}
