class MultiSellItemExchangeWnd extends UICommonAPI
	dependson(UIPacket);

const DIALOG_ID_ITEM_SET_COUNT = 1;
const TIMER_UPDATE_ID = 1;
const TIMER_UPDATEDELAY = 1;
const DRAW_LIST_PER_TICK = 20;

struct MultiSellGroupInfo
{
	var int MultisellID;
	var int tabindex;
	var bool Loaded;
	var array<UIConstants.MultiSellInfo> infoList;
};

struct MultiSellRequestInfo
{
	var UIConstants.MultiSellInfo MultiSellInfo;
	var int MultisellID;
	var int exchangeNum;
	var int lastSelectedIndex;
	var bool needSelected;
};

struct NoStackableItemData
{
	var int ClassID;
	var INT64 Count;
};

struct multiSellData
{
	var int PcCafePoint;
	var int clanPoint;
	var int PvPPoint;
	var int RaidPoint;
	var int craftPoint;
	var INT64 vitalityPoint;
	var INT64 Adena;
};

var array<ItemExchangeMultisellUIData> _multiSellTabInfos;
var int _selectedTabIndex;
var array<MultiSellGroupInfo> _multiSellGroupInfos;
var int _tempMultiSellInfoIndex;
var int _tempTabIndex;
var int _tempMultiSellId;
var int _tempShowType;
var array<UIConstants.MultiSellInfo> _tempMultiSellInfoList;
var bool _isWaitingResponse;
var MultiSellRequestInfo _requestInfo;
var multiSellData mData;
var UIData UIDataScript;
var bool hasEItemcheck;
var WindowHandle Me;
var WindowHandle disableWnd;
var WindowHandle totalListEmptyWnd;
var WindowHandle availableListEmptyWnd;
var RichListCtrlHandle itemTotalRichList;
var RichListCtrlHandle itemAvailableRichList;
var UIControlGroupButtonAssets tabGroupButtonAsset;
var UIControlNeedItemList needItemScript;
var TabHandle multiSellTab;
var UIControlNumberInput inputItemScript;
var UIControlDialogAssets exchangeDialog;
var UIControlTextInput searchTextInput;
var TextBoxHandle totalListEmptyTextBox;
var TextBoxHandle availableListEmptyTextBox;
var TextureHandle LoadingCircleTex;
var int beforeShowItemClassId;
var bool bIsPreview;
var int _listCount;

static function MultiSellItemExchangeWnd Inst()
{
	return MultiSellItemExchangeWnd(GetScript("MultiSellItemExchangeWnd"));
}

function Initialize()
{
	InitControls();
	return;
}

function InitControls()
{
	local string ownerFullPath;
	local WindowHandle needItemWnd, exchangeDialogWnd;
	local RichListCtrlHandle needItemRichList;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	UIDataScript = UIData(GetScript("UIData"));
	Me = GetWindowHandle(ownerFullPath);
	disableWnd = GetWindowHandle((ownerFullPath $ ".DisableWnd"));
	exchangeDialogWnd = GetWindowHandle((ownerFullPath $ ".UIControlDialogAsset"));
	exchangeDialog = Class'Interface.UIControlDialogAssets'.static.InitScript(exchangeDialogWnd);
	exchangeDialog.DelegateOnCancel = OnExchangeDialogCancel;
	exchangeDialog.DelegateOnClickBuy = OnExchangeDialogConfirm;
	exchangeDialog.SetUseBuyItem(true);
	exchangeDialog.SetUseNeedItem(false);
	exchangeDialog.SetUseNumberInput(false);
	exchangeDialog.SetDisableWindow(disableWnd);
	itemTotalRichList = GetRichListCtrlHandle((ownerFullPath $ ".MultisellTabTotalWnd.ItemTotal_RichList"));
	LoadingCircleTex = GetTextureHandle((ownerFullPath $ ".LoadingCircleTex"));
	itemTotalRichList.SetSelectedSelTooltip(false);
	itemTotalRichList.SetAppearTooltipAtMouseX(true);
	itemAvailableRichList = GetRichListCtrlHandle((ownerFullPath $ ".MultisellTabEnableWnd.ItemEnable_RichList"));
	itemAvailableRichList.SetSelectedSelTooltip(false);
	itemAvailableRichList.SetAppearTooltipAtMouseX(true);
	totalListEmptyWnd = GetWindowHandle((ownerFullPath $ ".MultisellTabTotalWnd.TotalListDisable_Wnd"));
	totalListEmptyTextBox = GetTextBoxHandle((totalListEmptyWnd.m_WindowNameWithFullPath $ ".TotalListDisable_Txt"));
	availableListEmptyWnd = GetWindowHandle((ownerFullPath $ ".MultisellTabEnableWnd.ListDisable_Wnd"));
	availableListEmptyTextBox = GetTextBoxHandle((availableListEmptyWnd.m_WindowNameWithFullPath $ ".ListDisable_Txt"));
	multiSellTab = GetTabHandle((ownerFullPath $ ".MultiSellTab"));
	tabGroupButtonAsset = Class'Interface.UIControlGroupButtonAssets'.static._InitScript(GetWindowHandle((ownerFullPath $ ".TopGroupButtonAsset")));
	tabGroupButtonAsset._SetStartInfo("L2UI_NewTex.WindowTab.FlatBrown_Tab_One_Unselected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_One_Unselected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_One_Unselected", true);
	tabGroupButtonAsset._GetGroupButtonsInstance().DelegateOnClickButton = OnTabGroupBtnClicked;
	needItemWnd = GetWindowHandle((ownerFullPath $ ".Bottom_Wnd.NeedItemWnd"));
	needItemWnd.SetScript("UIControlNeedItemList");
	needItemScript = UIControlNeedItemList(needItemWnd.GetScript());
	needItemRichList = GetRichListCtrlHandle((needItemWnd.m_WindowNameWithFullPath $ ".NeedItemRichListCtrl"));
	needItemScript.SetFormType(Normal);
	needItemScript.SetRichListControler(needItemRichList);
	needItemScript.SetColumnCount(2);
	needItemRichList.SetTooltipType("UIControlNeedItemList");
	inputItemScript = Class'Interface.UIControlNumberInput'.static.InitScript(GetWindowHandle((ownerFullPath $ ".Bottom_Wnd.InputItemWnd")));
	inputItemScript._SetUseCaculator(true);
	inputItemScript.DelegateGetCountCanBuy = MaxNumCanBuy;
	inputItemScript.delegateOnItemCountEdited = OnItemCountChanged;
	inputItemScript.DelegateESCKey = OnItemCountESCKey;
	inputItemScript.DelegateOnClickInput = OnSetCountBtnClicked;
	inputItemScript.DelegateOnClickBuy = OnExchangeBtnClicked;
	searchTextInput = Class'Interface.UIControlTextInput'.static.InitScript(GetWindowHandle((ownerFullPath $ ".ItemExchange_Wnd.ItemFind_Wnd.TextInput")));
	searchTextInput.DelegateOnClear = OnSearchTextInputClear;
	searchTextInput.DelegateOnCompleteEditBox = OnSearchTextInputCompleted;
	searchTextInput.SetDisable(false);
	searchTextInput.SetEdtiable(true);
	searchTextInput.SetDefaultString(GetSystemString(2507));
	return;
}

function ResetInfo()
{
	_multiSellGroupInfos.Length = 0;
	_multiSellTabInfos.Length = 0;
	_isWaitingResponse = false;
	ResetTempInfo();
	return;
}

function ResetTempInfo()
{
	_tempMultiSellInfoList.Length = 0;
	_tempMultiSellInfoIndex = 0;
	_tempMultiSellId = 0;
	_tempTabIndex = -1;
	return;
}

function InitTabButtonControls(int SelectedIndex)
{
	local int i;

	i = 0;
	while((i < _multiSellTabInfos.Length))
	{
		tabGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(i, _multiSellTabInfos[i].MultisellName);
		tabGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(i, i);
		if((_multiSellTabInfos.Length == 1))
		{
			tabGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(i, "L2UI_NewTex.WindowTab.FlatBrown_Tab_One_Unselected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_One_Unselected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_One_Unselected");
			i++;
			continue;
		}
		if((i == 0))
		{
			tabGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(i, "L2UI_NewTex.WindowTab.FlatBrown_Tab_Left_Unselected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_Left_Selected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_Left_Unselected_Over");
			i++;
			continue;
		}
		if((i == (_multiSellTabInfos.Length - 1)))
		{
			tabGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(i, "L2UI_NewTex.WindowTab.FlatBrown_Tab_Right_Unselected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_Right_Selected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_Right_Unselected_Over");
			i++;
			continue;
		}
		tabGroupButtonAsset._GetGroupButtonsInstance()._setButtonTexture(i, "L2UI_NewTex.WindowTab.FlatBrown_Tab_Center_Unselected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_Center_Selected", "L2UI_NewTex.WindowTab.FlatBrown_Tab_Center_Unselected_Over");
		i++;
	}
	tabGroupButtonAsset._GetGroupButtonsInstance()._setShowButtonNum(_multiSellTabInfos.Length);
	tabGroupButtonAsset._GetGroupButtonsInstance()._setAutoWidth(594, 0);
	tabGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(SelectedIndex, true);
	return;
}

function UpdateTabButtonControls()
{
	return;
}

function OnTick()
{
	DrawItemRichList();
	return;
}

function DrawItemRichList()
{
	local int i, N, arrayIndex, totalListCnt, ListCnt, groupNum, needItemNum;
	local bool bNoExchange, bCheck;
	local ItemInfo Info;
	local RichListCtrlRowData tempRowData;
	local array<NoStackableItemData> noStackableItemDataArray;
	local string searchStr;
	local MultiSellGroupInfo groupInfo;
	local array<UIConstants.MultiSellInfo> multiSellInfoList;
	local UIConstants.MultiSellInfo MultiSellInfo;
	local array<ItemInfo> NeedItemList;
	local ItemInfo NeedItem;

	groupNum = _multiSellGroupInfos.Length;
	if((_selectedTabIndex < groupNum))
	{
		groupInfo = _multiSellGroupInfos[_selectedTabIndex];
	}
	else
	{
		Me.DisableTick();
		LoadingCircleTex.HideWindow();
		return;
	}
	searchStr = searchTextInput.GetString();
	multiSellInfoList = groupInfo.infoList;
	totalListCnt = multiSellInfoList.Length;
	ListCnt = 0;
	while((ListCnt < 20))
	{
		if((_listCount >= totalListCnt))
		{
			break;
		}
		bNoExchange = false;
		bCheck = true;
		noStackableItemDataArray.Length = 0;
		MultiSellInfo = multiSellInfoList[_listCount];
		Info = MultiSellInfo.OutputItemInfoList[0];
		NeedItemList = MultiSellInfo.InputItemInfoList;
		needItemNum = NeedItemList.Length;
		N = 0;
		while((N < needItemNum))
		{
			NeedItem = NeedItemList[N];
			if(IsStackableItem(NeedItem.ConsumeType))
			{
				bCheck = CompareWithInven(NeedItem);
			}
			else
			{
				arrayIndex = GetNoStackableItemCountArrayIndex(NeedItem, noStackableItemDataArray);
				bCheck = CompareWithInven(NeedItem, noStackableItemDataArray[arrayIndex]);
			}
			if((bCheck == false))
			{
				bNoExchange = true;
				break;
			}
			N++;
		}
		if(((searchStr == "") || ((searchStr != "") && StringMatching(Info.Name, searchStr, " "))))
		{
			if((Info.Id.ClassID > 0))
			{
				if((bNoExchange == false))
				{
					Info.ForeTexture = "L2UI_CT1.SellablePanel";
					AddItemRichListCtrl(itemAvailableRichList, Info, _listCount);
				}
				AddItemRichListCtrl(itemTotalRichList, Info, _listCount);
			}
		}
		_listCount++;
		ListCnt++;
	}
	if((searchStr == ""))
	{
		totalListEmptyTextBox.SetText(GetSystemMessage(4357));
		availableListEmptyTextBox.SetText(GetSystemMessage(4357));
	}
	else
	{
		totalListEmptyTextBox.SetText(GetSystemString(14184));
		availableListEmptyTextBox.SetText(GetSystemString(14184));
	}
	if((itemTotalRichList.GetRecordCount() > 0))
	{
		totalListEmptyWnd.HideWindow();
	}
	else
	{
		totalListEmptyWnd.ShowWindow();
	}
	if((itemAvailableRichList.GetRecordCount() > 0))
	{
		availableListEmptyWnd.HideWindow();
	}
	else
	{
		availableListEmptyWnd.ShowWindow();
	}
	if((_listCount >= totalListCnt))
	{
		if((_requestInfo.needSelected == true))
		{
			_requestInfo.needSelected = false;
			if((_requestInfo.lastSelectedIndex > -1))
			{
				if((multiSellTab.GetTopIndex() == 0))
				{
					i = 0;
					while((i < itemTotalRichList.GetRecordCount()))
					{
						itemTotalRichList.GetRec(i, tempRowData);
						if((tempRowData.nReserved2 == INT64(_requestInfo.lastSelectedIndex)))
						{
							itemTotalRichList.SetSelectedIndex(i, true);
							break;
						}
						i++;
					}
				}
				else
				{
					i = 0;
					while((i < itemAvailableRichList.GetRecordCount()))
					{
						itemAvailableRichList.GetRec(i, tempRowData);
						if((tempRowData.nReserved2 == INT64(_requestInfo.lastSelectedIndex)))
						{
							itemAvailableRichList.SetSelectedIndex(i, true);
							break;
						}
						i++;
					}
				}
			}
			UpdateItemInfoControls();
		}
		LoadingCircleTex.HideWindow();
		Me.DisableTick();
		return;
	}
	return;
}

function UpdateItemListControls()
{
	itemTotalRichList.DeleteAllItem();
	itemAvailableRichList.DeleteAllItem();
	LoadingCircleTex.ShowWindow();
	_listCount = 0;
	Me.EnableTick();
	return;
}

function UpdateItemInfoControls(optional bool modifyList)
{
	local int i;
	local UIConstants.MultiSellInfo MultiSellInfo;

	if((modifyList == false))
	{
		needItemScript.StartNeedItemList(2);
	}
	if(GetSelectedMultiSellInfo(MultiSellInfo))
	{
		needItemScript._CheckRowCountWithItemNum(MultiSellInfo.InputItemInfoList.Length);
		i = 0;
		while((i < MultiSellInfo.InputItemInfoList.Length))
		{
			if(isPointType(MultiSellInfo.InputItemInfoList[i]))
			{
				needItemScript.AddNeedPoint(MultiSellInfo.InputItemInfoList[i].Name, MultiSellInfo.InputItemInfoList[i].IconName, MultiSellInfo.InputItemInfoList[i].ItemNum, getHasItemOrPointCount(MultiSellInfo.InputItemInfoList[i]));
				i++;
				continue;
			}
			needItemScript.AddNeedItemClassID(MultiSellInfo.InputItemInfoList[i].Id.ClassID, MultiSellInfo.InputItemInfoList[i].ItemNum);
			i++;
		}
		if((needItemScript.GetMaxNumCanBuy() > INT64(0)))
		{
			inputItemScript.SetCount(INT64(1));
		}
		else
		{
			inputItemScript.SetCount(INT64(0));
		}
	}
	else
	{
		inputItemScript.SetCount(INT64(0));
	}
	return;
}

function UpdateUIControlsWithTimer()
{
	Me.KillTimer(1);
	Me.SetTimer(1, 1);
	return;
}

function UpdateUIControls()
{
	UpdateTabButtonControls();
	UpdateItemListControls();
	UpdateItemInfoControls();
	return;
}

function AddItemRichListCtrl(RichListCtrlHandle itemListCtrl, ItemInfo Info, int Index)
{
	local RichListCtrlRowData Record;
	local string fullNameString, toolTipParam;
	local L2Util util;

	fullNameString = GetItemNameAll(Info, true);
	util = getInstanceL2Util();
	ItemInfoToParam(Info, toolTipParam);
	Record.szReserved = toolTipParam;
	Record.cellDataList.Length = 1;
	Record.nReserved1 = INT64(Info.ConsumeType);
	Record.nReserved2 = INT64(Index);
	addRichListCtrlTexture(Record.cellDataList[0].drawitems, "l2ui_ct1.ItemWindow_DF_SlotBox_Default", 36, 36, 8, 1);
	AddRichListCtrlItem(Record.cellDataList[0].drawitems, Info, 32, 32, -34, 1);
	if((Info.IconPanel != ""))
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, Info.IconPanel, 32, 32, -32, 0);
	}
	if(Info.IsBlessedItem)
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, "Icon.icon_panel.bless_panel", 32, 32, -32, 0);
	}
	if((Info.Enchanted > 0))
	{
	}
	if((Info.ForeTexture != ""))
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, Info.ForeTexture, 32, 32, -32, 0);
	}
	if(IsStackableItem(Info.ConsumeType))
	{
		AddRichListCtrlString(Record.cellDataList[0].drawitems, fullNameString, util.White, false, 6, 10);
		if((Info.AdditionalName != ""))
		{
			AddRichListCtrlString(Record.cellDataList[0].drawitems, Info.AdditionalName, util.Yellow03, false, 3, 0);
		}
		if((Info.ItemNum > INT64(0)))
		{
			AddRichListCtrlString(Record.cellDataList[0].drawitems, (("(" $ string(Info.ItemNum)) $ ")"), util.White, false, 0, 0);
		}
		else
		{
			AddRichListCtrlString(Record.cellDataList[0].drawitems, "(1)", util.White, false, 0, 0);
		}
	}
	else
	{
		AddRichListCtrlString(Record.cellDataList[0].drawitems, fullNameString, util.White, false, 6, 10);
		if((Info.AdditionalName != ""))
		{
			AddRichListCtrlString(Record.cellDataList[0].drawitems, Info.AdditionalName, util.Yellow03, false, 3, 0);
		}
	}
	itemListCtrl.InsertRecord(Record);
	return;
}

function ShowItemCountDialog()
{
	local ItemInfo Info;

	DialogHide();
	Debug("ShowItemCountDialog");
	DialogSetReservedItemID(Info.Id);
	DialogSetParamInt64(needItemScript.GetMaxNumCanBuy());
	DialogSetID(1);
	DialogSetCancelD(1);
	disableWnd.ShowWindow();
	disableWnd.SetFocus();
	searchTextInput.SetEdtiable(false);
	DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(4362));
	Class'Interface.DialogBox'.static.Inst().AnchorToOwner(0, 100);
	Class'Interface.DialogBox'.static.Inst().DelegateOnCancel = OnItemCountDialogCancel;
	Class'Interface.DialogBox'.static.Inst().DelegateOnOK = OnItemCountDialogConfirm;
	Class'Interface.DialogBox'.static.Inst().DelegateOnHide = OnItemCountDialogHide;
	Class'Interface.DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
	return;
}

function ShowExchangeDialog()
{
	local ItemInfo ItemInfo, inputItemInfo;
	local UIConstants.MultiSellInfo MultiSellInfo;
	local int inputItemCnt, i, descId;

	if(DialogIsMine())
	{
		DialogHide();
	}
	if((GetSelectedMultiSellInfo(MultiSellInfo) == false))
	{
		return;
	}
	if((_selectedTabIndex >= _multiSellGroupInfos.Length))
	{
		return;
	}
	inputItemCnt = int(inputItemScript.GetCount());
	if((inputItemCnt <= 0))
	{
		return;
	}
	hasEItemcheck = false;
	i = 0;
	while((i < MultiSellInfo.InputItemInfoList.Length))
	{
		inputItemInfo = MultiSellInfo.InputItemInfoList[i];
		if((((inputItemInfo.ItemType == 0) || (inputItemInfo.ItemType == 1)) || (inputItemInfo.ItemType == 2)))
		{
			if((isPointType(inputItemInfo) == false))
			{
				hasEItemcheck = true;
			}
		}
		i++;
	}
	_requestInfo.MultiSellInfo = MultiSellInfo;
	_requestInfo.exchangeNum = inputItemCnt;
	_requestInfo.MultisellID = _multiSellGroupInfos[_selectedTabIndex].MultisellID;
	ItemInfo = MultiSellInfo.OutputItemInfoList[0];
	if(hasEItemcheck)
	{
		descId = 13801;
	}
	else
	{
		descId = 13800;
	}
	exchangeDialog.SetDialogDesc(MakeFullSystemMsg(GetSystemMessage(descId), GetItemNameAll(ItemInfo)));
	exchangeDialog.SetBuyItemInfo(ItemInfo, INT64(int(ItemInfo.ItemNum)), INT64(0));
	exchangeDialog.SetItemNum(_requestInfo.exchangeNum);
	exchangeDialog.OKButton.EnableWindow();
	exchangeDialog.Show();
	searchTextInput.SetEdtiable(false);
	return;
}

function int GetNoStackableItemCountArrayIndex(ItemInfo inputItemInfo, out array<NoStackableItemData> noStackableItemDataArray)
{
	local int arrayIndex, nClassID;
	local INT64 noStackableNeedItemNum;
	local array<ItemInfo> hasItemInfoArray;

	if(!IsStackableItem(inputItemInfo.ConsumeType))
	{
		nClassID = inputItemInfo.Id.ClassID;
		noStackableNeedItemNum = FindItemByClassIDFilter(nClassID, hasItemInfoArray);
		arrayIndex = GetIndexArray(nClassID, noStackableItemDataArray);
		if((arrayIndex == -1))
		{
			noStackableItemDataArray.Length = (noStackableItemDataArray.Length + 1);
			if((noStackableItemDataArray.Length > 0))
			{
				noStackableItemDataArray[(noStackableItemDataArray.Length - 1)].ClassID = nClassID;
				noStackableItemDataArray[(noStackableItemDataArray.Length - 1)].Count = noStackableNeedItemNum;
			}
			if((arrayIndex == -1))
			{
				arrayIndex = (noStackableItemDataArray.Length - 1);
			}
		}
		else if((noStackableItemDataArray[arrayIndex].Count > INT64(0)))
		{
			noStackableItemDataArray[arrayIndex].Count = (noStackableItemDataArray[arrayIndex].Count - INT64(1));
		}
	}
	return arrayIndex;
}

function int GetSelectedItemIndex()
{
	local int selectedListIndex;
	local RichListCtrlRowData Record;

	selectedListIndex = -1;
	if((multiSellTab.GetTopIndex() == 0))
	{
		selectedListIndex = itemTotalRichList.GetSelectedIndex();
		if((selectedListIndex >= 0))
		{
			itemTotalRichList.GetSelectedRec(Record);
			return int(Record.nReserved2);
		}
	}
	else
	{
		selectedListIndex = itemAvailableRichList.GetSelectedIndex();
		if((selectedListIndex >= 0))
		{
			itemAvailableRichList.GetSelectedRec(Record);
			return int(Record.nReserved2);
		}
	}
	return selectedListIndex;
}

function bool GetSelectedMultiSellInfo(out UIConstants.MultiSellInfo MultiSellInfo)
{
	local int SelectedIndex;

	SelectedIndex = GetSelectedItemIndex();
	if((SelectedIndex == -1))
	{
		return false;
	}
	if((_selectedTabIndex < _multiSellGroupInfos.Length))
	{
		if((SelectedIndex < _multiSellGroupInfos[_selectedTabIndex].infoList.Length))
		{
			MultiSellInfo = _multiSellGroupInfos[_selectedTabIndex].infoList[SelectedIndex];
			return true;
		}
	}
	return false;
}

function int GetIndexArray(int ClassID, out array<NoStackableItemData> noStackableItemDataArray)
{
	local int i;

	i = 0;
	while((i < noStackableItemDataArray.Length))
	{
		if((noStackableItemDataArray[i].ClassID == ClassID))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function bool CompareWithInven(ItemInfo Info, optional NoStackableItemData noStackableItemDataInfo)
{
	local ItemInfo InvenItemInfo;
	local bool flag;
	local INT64 hasItemCount;
	local array<ItemInfo> itemInfoArr;

	if((Info.IconName == GetPcCafeItemIconPackageName()))
	{
		if((INT64(mData.PcCafePoint) >= Info.ItemNum))
		{
			return true;
		}
	}
	else if((Info.IconName == "icon.etc_i.etc_bloodpledge_point_i00"))
	{
		if((INT64(mData.clanPoint) >= Info.ItemNum))
		{
			return true;
		}
	}
	else if((Info.IconName == "icon.pvp_point_i00"))
	{
		if((INT64(mData.PvPPoint) >= Info.ItemNum))
		{
			return true;
		}
	}
	else if((Info.IconName == "icon.etc_i.etc_rp_point_i00"))
	{
		if((INT64(mData.RaidPoint) >= Info.ItemNum))
		{
			return true;
		}
	}
	else if((Info.IconName == "Icon.etc_i.craft_point"))
	{
		if((INT64(mData.craftPoint) >= Info.ItemNum))
		{
			return true;
		}
	}
	else if((Info.IconName == "icon.etc_sayha_point_01"))
	{
		if((mData.vitalityPoint >= Info.ItemNum))
		{
			return true;
		}
	}
	else if((Info.Id.ClassID > 0))
	{
		hasItemCount = FindItemByClassIDFilter(Info.Id.ClassID, itemInfoArr);
		if((hasItemCount > INT64(0)))
		{
			InvenItemInfo = itemInfoArr[0];
			if(IsStackableItem(InvenItemInfo.ConsumeType))
			{
				if((InvenItemInfo.ItemNum >= Info.ItemNum))
				{
					return true;
				}
			}
			else
			{
				if((noStackableItemDataInfo.ClassID > 0))
				{
					if((noStackableItemDataInfo.Count > INT64(0)))
					{
						flag = true;
					}
				}
				return flag;
			}
		}
	}
	return false;
}

function bool isPointType(ItemInfo Info)
{
	local bool RValue;

	if((Info.IconName == GetPcCafeItemIconPackageName()))
	{
		RValue = true;
	}
	else if((Info.IconName == "icon.etc_i.etc_bloodpledge_point_i00"))
	{
		RValue = true;
	}
	else if((Info.IconName == "icon.pvp_point_i00"))
	{
		RValue = true;
	}
	else if((Info.IconName == "icon.etc_i.etc_rp_point_i00"))
	{
		RValue = true;
	}
	else if((Info.IconName == "Icon.etc_i.craft_point"))
	{
		RValue = true;
	}
	else if((Info.IconName == "icon.etc_sayha_point_01"))
	{
		RValue = true;
	}
	return RValue;
}

function INT64 getHasItemOrPointCount(ItemInfo Info)
{
	local INT64 hasNum;
	local array<ItemInfo> itemInfoArray;
	local int ItemCount;

	if((Info.IconName == GetPcCafeItemIconPackageName()))
	{
		hasNum = INT64(mData.PcCafePoint);
	}
	else if((Info.IconName == "icon.etc_i.etc_bloodpledge_point_i00"))
	{
		hasNum = INT64(mData.clanPoint);
	}
	else if((Info.IconName == "icon.pvp_point_i00"))
	{
		hasNum = INT64(mData.PvPPoint);
	}
	else if((Info.IconName == "icon.etc_i.etc_rp_point_i00"))
	{
		hasNum = INT64(mData.RaidPoint);
	}
	else if((Info.IconName == "Icon.etc_i.craft_point"))
	{
		hasNum = INT64(mData.craftPoint);
	}
	else if((Info.IconName == "icon.etc_sayha_point_01"))
	{
		hasNum = mData.vitalityPoint;
	}
	else
	{
		ItemCount = Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(Info.Id.ClassID, itemInfoArray);
		if((ItemCount > 0))
		{
			hasNum = itemInfoArray[0].ItemNum;
		}
	}
	return hasNum;
}

function updateMultiSellData(optional string serverUpdateParam)
{
	local int nPointCount, nPoint, nType, N;
	local UserInfo PlayerInfo;

	GetPlayerInfo(PlayerInfo);
	ParseInt(serverUpdateParam, "NumPoint", nPointCount);
	N = 0;
	while((N < nPointCount))
	{
		ParseInt(serverUpdateParam, ("Type" $ string(N)), nType);
		ParseInt(serverUpdateParam, ("Point" $ string(N)), nPoint);
		if((-500 == nType))
		{
			mData.PvPPoint = nPoint;
			N++;
			continue;
		}
		if((-300 == nType))
		{
			mData.PvPPoint = nPoint;
			N++;
			continue;
		}
		if((-200 == nType))
		{
			mData.clanPoint = nPoint;
			UIDataScript.SetCurrentClanNameValue(nPoint);
			N++;
			continue;
		}
		if((-100 == nType))
		{
			mData.PcCafePoint = nPoint;
			UIDataScript.SetPcCafePoint(nPoint);
			N++;
			continue;
		}
		if((-600 == nType))
		{
			mData.craftPoint = nPoint;
		}
		N++;
	}
	if((nPointCount <= 0))
	{
		mData.PvPPoint = PlayerInfo.PvPPoint;
		mData.RaidPoint = PlayerInfo.RaidPoint;
		mData.PcCafePoint = UIDataScript.GetCurrentPcCafePoint();
		mData.clanPoint = UIDataScript.GetCurrentClanNameValue();
		mData.craftPoint = UIDataScript.GetCurrentCraftPoint();
	}
	mData.vitalityPoint = UIDataScript.GetCurrentVitalityPoint();
	return;
}

function INT64 MaxNumCanBuy()
{
	local UIConstants.MultiSellInfo MultiSellInfo;
	local INT64 Count;

	if(GetSelectedMultiSellInfo(MultiSellInfo))
	{
		if(IsStackableItem(MultiSellInfo.OutputItemInfoList[0].ConsumeType))
		{
			Count = INT64(int(needItemScript.GetMaxNumCanBuy()));
		}
		else
		{
			Count = INT64(Min(1, int(needItemScript.GetMaxNumCanBuy())));
		}
		return Count;
	}
	return INT64(0);
}

function bool ChkNeedItemAutoUse()
{
	local int i;

	i = 0;
	while((i < needItemScript._needItemClassIds.Length))
	{
		if((Class'NWindow.ShortcutWndAPI'.static.GetAutomaticUseActivated(needItemScript._needItemClassIds[i]) == true))
		{
			return true;
		}
		i++;
	}
	return false;
}

event OnRegisterEvent()
{
	RegisterEvent(2530);
	RegisterEvent(2535);
	RegisterEvent(2540);
	RegisterEvent(2550);
	RegisterEvent(2560);
	RegisterEvent(2565);
	RegisterEvent(11580);
	RegisterEvent(40);
	RegisterEvent(1710);
	RegisterEvent(1720);
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 11580:
			Rs_EV_ShowSimpleItemExchangeMultisellWnd(param);
			break;
		default:
			break;
	}
	if((Me.IsShowWindow() == false))
	{
		return;
	}
	if((Event_ID == 2530))
	{
		ParseInt(param, "ShowType", _tempShowType);
	}
	if((_tempShowType == 4))
	{
		switch(Event_ID)
		{
			case 2530:
				Rs_EV_MultiSellInfoListBegin(param);
				break;
			case 2535:
				Rs_EV_MultiSellResultItemInfo(param);
				break;
			case 2540:
				Rs_EV_MultiSellOutputItemInfo(param);
				break;
			case 2550:
				Rs_EV_MultiSellInputItemInfo(param);
				break;
			case 2560:
				Rs_EV_MultiSellInfoListEnd(param);
				break;
			case 2565:
				Nt_EV_MultiSellResult(param);
				break;
			case 40:
				beforeShowItemClassId = 0;
				bIsPreview = false;
				break;
			default:
				break;
		}
	}
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

event OnShow()
{
	setMode(bIsPreview);
	return;
}

function setMode(bool bPreview)
{
	if(bPreview)
	{
		setWindowTitleByString(GetSystemString(14668));
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Bottom_Wnd.InputItemWnd")).HideWindow();
		Me.SetWindowSize(608, 577);
		GetMeTexture("Bottom_Wnd.Bg2_Tex").HideWindow();
		GetMeTexture("Bottom_Wnd.Divide2_Tex").HideWindow();
		GetMeTextBox("Bottom_Wnd.Title2_Txt").HideWindow();
	}
	else
	{
		getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
		setWindowTitleByString(GetSystemString(2671));
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Bottom_Wnd.InputItemWnd")).ShowWindow();
		Me.SetWindowSize(608, 710);
		GetMeTexture("Bottom_Wnd.Bg2_Tex").ShowWindow();
		GetMeTexture("Bottom_Wnd.Divide2_Tex").ShowWindow();
		GetMeTextBox("Bottom_Wnd.Title2_Txt").ShowWindow();
	}
	Me.SetFocus();
	return;
}

event OnHide()
{
	ResetUI();
	return;
}

function ResetUI()
{
	if(DialogIsMine())
	{
		DialogHide();
	}
	exchangeDialog.Hide();
	ResetInfo();
	needItemScript.CleariObjects();
	Me.KillTimer(1);
	Me.DisableTick();
	LoadingCircleTex.HideWindow();
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 1))
	{
		UpdateUIControls();
		Me.KillTimer(1);
	}
	return;
}

event OnSearchBtnClicked()
{
	UpdateItemListControls();
	return;
}

event OnSearchTextInputClear()
{
	searchTextInput.Clear();
	UpdateItemListControls();
	return;
}

event OnSearchTextInputCompleted(string Text)
{
	UpdateItemListControls();
	return;
}

event OnTabGroupBtnClicked(string parentWndName, string strName, int Index)
{
	local int MultisellID;

	_selectedTabIndex = Index;
	if((Index < _multiSellTabInfos.Length))
	{
		MultisellID = _multiSellTabInfos[Index].MultisellID;
		if((MultisellID > 0))
		{
			if((((Index < _multiSellGroupInfos.Length) && (_multiSellGroupInfos[Index].MultisellID == MultisellID)) && _multiSellGroupInfos[Index].Loaded))
			{
				UpdateUIControls();
			}
			else
			{
				Rq_C_EX_MULTI_SELL_LIST(MultisellID, Index);
			}
		}
	}
	return;
}

event OnClickButton(string btnName)
{
	switch(btnName)
	{
		case "MultiSellTab0":
		case "MultiSellTab1":
			UpdateItemInfoControls();
			break;
		case "BtnFind":
			UpdateItemListControls();
			break;
		default:
			break;
	}
	return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	if(bIsPreview)
	{
		return;
	}
	if(Me.IsShowWindow())
	{
		ShowExchangeDialog();
	}
	return;
}

event OnItemCountChanged(INT64 ItemCount)
{
	ItemCount = MAX64(INT64(1), ItemCount);
	needItemScript.SetBuyNum(INT64(int(ItemCount)));
	return;
}

event OnSetCountBtnClicked()
{
	ShowItemCountDialog();
	return;
}

event OnExchangeBtnClicked()
{
	ShowExchangeDialog();
	return;
}

event OnItemCountDialogCancel()
{
	return;
}

event OnItemCountDialogConfirm()
{
	if(DialogIsMine())
	{
		inputItemScript.SetCount(INT64(int(DialogGetString())));
	}
	return;
}

event OnItemCountDialogHide()
{
	disableWnd.HideWindow();
	searchTextInput.SetEdtiable(true);
	return;
}

event OnExchangeDialogConfirm()
{
	local string param;
	local UIConstants.MultiSellInfo MultiSellInfo;

	if(ChkNeedItemAutoUse())
	{
		AddSystemMessage(14624);
		return;
	}
	MultiSellInfo = _requestInfo.MultiSellInfo;
	ParamAdd(param, "MultiSellGroupID", string(_requestInfo.MultisellID));
	ParamAdd(param, "MultiSellInfoID", string(MultiSellInfo.MultiSellInfoID));
	ParamAdd(param, "ItemCount", string(_requestInfo.exchangeNum));
	ParamAdd(param, "Enchant", string(MultiSellInfo.ResultItemInfo.Enchanted));
	ParamAdd(param, "RefineryOp1", string(MultiSellInfo.ResultItemInfo.RefineryOp1));
	ParamAdd(param, "RefineryOp2", string(MultiSellInfo.ResultItemInfo.RefineryOp2));
	ParamAdd(param, "RefineryOp3", string(MultiSellInfo.ResultItemInfo.RefineryOp3));
	ParamAdd(param, "AttrAttackType", string(MultiSellInfo.ResultItemInfo.AttackAttributeType));
	ParamAdd(param, "AttrAttackValue", string(MultiSellInfo.ResultItemInfo.AttackAttributeValue));
	ParamAdd(param, "AttrDefenseValueFire", string(MultiSellInfo.ResultItemInfo.DefenseAttributeValueFire));
	ParamAdd(param, "AttrDefenseValueWater", string(MultiSellInfo.ResultItemInfo.DefenseAttributeValueWater));
	ParamAdd(param, "AttrDefenseValueWind", string(MultiSellInfo.ResultItemInfo.DefenseAttributeValueWind));
	ParamAdd(param, "AttrDefenseValueEarth", string(MultiSellInfo.ResultItemInfo.DefenseAttributeValueEarth));
	ParamAdd(param, "AttrDefenseValueHoly", string(MultiSellInfo.ResultItemInfo.DefenseAttributeValueHoly));
	ParamAdd(param, "AttrDefenseValueUnholy", string(MultiSellInfo.ResultItemInfo.DefenseAttributeValueUnholy));
	addParamEnsoulOptionInfo(MultiSellInfo.ResultItemInfo, param);
	ParamAdd(param, "IsBlessedItem", string(MultiSellInfo.ResultItemInfo.BlessBaseEffectID));
	_requestInfo.lastSelectedIndex = GetSelectedItemIndex();
	_requestInfo.needSelected = true;
	RequestMultiSellChoose(param);
	exchangeDialog.Hide();
	searchTextInput.SetEdtiable(true);
	return;
}

event OnExchangeDialogCancel()
{
	exchangeDialog.Hide();
	searchTextInput.SetEdtiable(true);
	return;
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		case "ItemTotal_RichList":
			_requestInfo.needSelected = false;
			UpdateItemInfoControls();
			break;
		case "ItemEnable_RichList":
			_requestInfo.needSelected = false;
			UpdateItemInfoControls();
			break;
		default:
			break;
	}
	return;
}

event OnItemCountESCKey()
{
	if((multiSellTab.GetTopIndex() == 0))
	{
		itemTotalRichList.SetFocus();
	}
	else
	{
		itemAvailableRichList.SetFocus();
	}
	return;
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
	return;
}

function OpenWindow(int ItemClassID, optional bool bPreview)
{
	if(Me.IsShowWindow())
	{
		ResetUI();
		if(((ItemClassID == beforeShowItemClassId) && (bPreview == bIsPreview)))
		{
			Me.HideWindow();
			return;
		}
		else
		{
			setMode(bPreview);
		}
	}
	bIsPreview = bPreview;
	searchTextInput.Clear();
	ResetInfo();
	multiSellTab.SetTopOrder(0, false);
	inputItemScript.SetCount(INT64(0));
	disableWnd.HideWindow();
	searchTextInput.SetEdtiable(true);
	updateMultiSellData();
	GetItemExchangeMultisellData(ItemClassID, _multiSellTabInfos);
	beforeShowItemClassId = ItemClassID;
	_selectedTabIndex = 0;
	hasEItemcheck = false;
	InitTabButtonControls(_selectedTabIndex);
	UpdateUIControls();
	Rq_C_EX_MULTI_SELL_LIST(_multiSellTabInfos[_selectedTabIndex].MultisellID, _selectedTabIndex);
	Me.ShowWindow();
	return;
}

function addEnsoulInfo(int slotType, int slotCount, string param, out ItemInfo Info)
{
	local int N, nEOptionID;

	N = 1;
	while((N < (slotCount + 1)))
	{
		ParseInt(param, ((("EnsoulOptionID_" $ string(slotType)) $ "_") $ string(N)), nEOptionID);
		Info.EnsoulOption[(slotType - 1)].OptionArray[(N - 1)] = nEOptionID;
		N++;
	}
	return;
}

function Rq_C_EX_MULTI_SELL_LIST(int MultisellID, int tabindex)
{
	local array<byte> stream;
	local UIPacket._C_EX_MULTI_SELL_LIST packet;

	packet.nGroupID = MultisellID;
	if((tabindex < _multiSellGroupInfos.Length))
	{
		if(((_multiSellGroupInfos[tabindex].MultisellID == MultisellID) && _multiSellGroupInfos[tabindex].Loaded))
		{
			return;
		}
	}
	if((_isWaitingResponse == true))
	{
		return;
	}
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_MULTI_SELL_LIST(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(624, stream);
	_isWaitingResponse = true;
	return;
}

function Rs_EV_ShowSimpleItemExchangeMultisellWnd(string param)
{
	local int ItemClassID;

	ParseInt(param, "ItemClassID", ItemClassID);
	OpenWindow(ItemClassID);
	return;
}

function Rs_EV_MultiSellInfoListBegin(string param)
{
	ParseInt(param, "MultiSellGroupID", _tempMultiSellId);
	_tempTabIndex = _selectedTabIndex;
	return;
}

function Rs_EV_MultiSellResultItemInfo(string param)
{
	local int nMultiSellInfoID, nBuyType, nIsBlessedItem, ensoulNormalSlot, ensoulBmSlot;
	local ItemInfo Info;

	ParseInt(param, "MultiSellInfoID", nMultiSellInfoID);
	ParseInt(param, "BuyType", nBuyType);
	ParseInt(param, "Enchanted", Info.Enchanted);
	ParseInt(param, "RefineryOp1", Info.RefineryOp1);
	ParseInt(param, "RefineryOp2", Info.RefineryOp2);
	ParseInt(param, "RefineryOp3", Info.RefineryOp3);
	ParseInt(param, "AttackAttributeType", Info.AttackAttributeType);
	ParseInt(param, "AttackAttributeValue", Info.AttackAttributeValue);
	ParseInt(param, "DefenseAttributeValueFire", Info.DefenseAttributeValueFire);
	ParseInt(param, "DefenseAttributeValueWater", Info.DefenseAttributeValueWater);
	ParseInt(param, "DefenseAttributeValueWind", Info.DefenseAttributeValueWind);
	ParseInt(param, "DefenseAttributeValueEarth", Info.DefenseAttributeValueEarth);
	ParseInt(param, "DefenseAttributeValueHoly", Info.DefenseAttributeValueHoly);
	ParseInt(param, "DefenseAttributeValueUnholy", Info.DefenseAttributeValueUnholy);
	ParseInt(param, ("EnsoulOptionNum_" $ string(2)), ensoulBmSlot);
	ParseInt(param, ("EnsoulOptionNum_" $ string(1)), ensoulNormalSlot);
	addEnsoulInfo(2, ensoulBmSlot, param, Info);
	addEnsoulInfo(1, ensoulNormalSlot, param, Info);
	ParseInt(param, "IsBlessedItem", nIsBlessedItem);
	Info.IsBlessedItem = numToBool(nIsBlessedItem);
	ParseInt(param, "BlessBaseEffectID", Info.BlessBaseEffectID);
	_tempMultiSellInfoIndex = _tempMultiSellInfoList.Length;
	_tempMultiSellInfoList.Length = (_tempMultiSellInfoList.Length + 1);
	_tempMultiSellInfoList[_tempMultiSellInfoIndex].MultiSellInfoID = nMultiSellInfoID;
	_tempMultiSellInfoList[_tempMultiSellInfoIndex].MultiSellType = nBuyType;
	_tempMultiSellInfoList[_tempMultiSellInfoIndex].ResultItemInfo = Info;
	return;
}

function Rs_EV_MultiSellOutputItemInfo(string param)
{
	local int nMultiSellInfoID, nCurrentOutputItemInfoIndex, nIsBlessedItem, nItemClassID, ensoulNormalSlot, ensoulBmSlot;
	local ItemInfo Info;

	ParseItemID(param, Info.Id);
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(Info.Id, Info);
	ParseInt(param, "ClassID", nItemClassID);
	ParseInt(param, "MultiSellInfoID", nMultiSellInfoID);
	ParseINT64(param, "SlotBitType", Info.SlotBitType);
	ParseInt(param, "ItemType", Info.ItemType);
	ParseINT64(param, "ItemCount", Info.ItemNum);
	ParseInt(param, "Enchanted", Info.Enchanted);
	ParseInt(param, "RefineryOp1", Info.RefineryOp1);
	ParseInt(param, "RefineryOp2", Info.RefineryOp2);
	ParseInt(param, "RefineryOp3", Info.RefineryOp3);
	ParseInt(param, "AttackAttributeType", Info.AttackAttributeType);
	ParseInt(param, "AttackAttributeValue", Info.AttackAttributeValue);
	ParseInt(param, "DefenseAttributeValueFire", Info.DefenseAttributeValueFire);
	ParseInt(param, "DefenseAttributeValueWater", Info.DefenseAttributeValueWater);
	ParseInt(param, "DefenseAttributeValueWind", Info.DefenseAttributeValueWind);
	ParseInt(param, "DefenseAttributeValueEarth", Info.DefenseAttributeValueEarth);
	ParseInt(param, "DefenseAttributeValueHoly", Info.DefenseAttributeValueHoly);
	ParseInt(param, "DefenseAttributeValueUnholy", Info.DefenseAttributeValueUnholy);
	ParseInt(param, ("EnsoulOptionNum_" $ string(2)), ensoulBmSlot);
	ParseInt(param, ("EnsoulOptionNum_" $ string(1)), ensoulNormalSlot);
	addEnsoulInfo(2, ensoulBmSlot, param, Info);
	addEnsoulInfo(1, ensoulNormalSlot, param, Info);
	ParseInt(param, "IsBlessedItem", nIsBlessedItem);
	Info.IsBlessedItem = numToBool(nIsBlessedItem);
	ParseInt(param, "BlessBaseEffectID", Info.BlessBaseEffectID);
	if((_tempMultiSellInfoList[_tempMultiSellInfoIndex].MultiSellInfoID != nMultiSellInfoID))
	{
		return;
	}
	if((nItemClassID == -100))
	{
		Info.Name = GetSystemString(1277);
		Info.IconName = GetPcCafeItemIconPackageName();
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if((nItemClassID == -200))
	{
		Info.Name = GetSystemString(1311);
		Info.IconName = "icon.etc_i.etc_bloodpledge_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if((nItemClassID == -300))
	{
		Info.Name = GetSystemString(102);
		Info.IconName = "icon.pvp_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if((nItemClassID == -500))
	{
		Info.Name = GetSystemString(3183);
		Info.IconName = "icon.etc_i.etc_rp_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if((nItemClassID == -600))
	{
		Info.Name = GetSystemString(13159);
		Info.IconName = "Icon.etc_i.craft_point";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if((nItemClassID == -800))
	{
		Info.Name = GetSystemString(2492);
		Info.IconName = "icon.etc_sayha_point_01";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	if((0 < Info.Durability))
	{
		Info.CurrentDurability = Info.Durability;
	}
	nCurrentOutputItemInfoIndex = _tempMultiSellInfoList[_tempMultiSellInfoIndex].OutputItemInfoList.Length;
	_tempMultiSellInfoList[_tempMultiSellInfoIndex].OutputItemInfoList.Length = (nCurrentOutputItemInfoIndex + 1);
	_tempMultiSellInfoList[_tempMultiSellInfoIndex].OutputItemInfoList[nCurrentOutputItemInfoIndex] = Info;
	_tempMultiSellInfoList[_tempMultiSellInfoIndex].OutputItemInfoList[nCurrentOutputItemInfoIndex].Reserved = _tempMultiSellInfoIndex;
	return;
}

function Rs_EV_MultiSellInputItemInfo(string param)
{
	local int nMultiSellInfoID, nCurrentInputItemInfoIndex, nItemClassID, nIsBlessedItem, ensoulNormalSlot, ensoulBmSlot;
	local ItemInfo Info;

	ParseItemID(param, Info.Id);
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(Info.Id, Info);
	ParseInt(param, "MultiSellInfoID", nMultiSellInfoID);
	ParseInt(param, "ClassID", nItemClassID);
	ParseInt(param, "ItemType", Info.ItemType);
	ParseINT64(param, "ItemCount", Info.ItemNum);
	ParseInt(param, "Enchanted", Info.Enchanted);
	ParseInt(param, "RefineryOp1", Info.RefineryOp1);
	ParseInt(param, "RefineryOp2", Info.RefineryOp2);
	ParseInt(param, "RefineryOp3", Info.RefineryOp3);
	ParseInt(param, "AttackAttributeType", Info.AttackAttributeType);
	ParseInt(param, "AttackAttributeValue", Info.AttackAttributeValue);
	ParseInt(param, "DefenseAttributeValueFire", Info.DefenseAttributeValueFire);
	ParseInt(param, "DefenseAttributeValueWater", Info.DefenseAttributeValueWater);
	ParseInt(param, "DefenseAttributeValueWind", Info.DefenseAttributeValueWind);
	ParseInt(param, "DefenseAttributeValueEarth", Info.DefenseAttributeValueEarth);
	ParseInt(param, "DefenseAttributeValueHoly", Info.DefenseAttributeValueHoly);
	ParseInt(param, "DefenseAttributeValueUnholy", Info.DefenseAttributeValueUnholy);
	ParseInt(param, ("EnsoulOptionNum_" $ string(2)), ensoulBmSlot);
	ParseInt(param, ("EnsoulOptionNum_" $ string(1)), ensoulNormalSlot);
	addEnsoulInfo(2, ensoulBmSlot, param, Info);
	addEnsoulInfo(1, ensoulNormalSlot, param, Info);
	ParseInt(param, "IsBlessedItem", nIsBlessedItem);
	Info.IsBlessedItem = numToBool(nIsBlessedItem);
	ParseInt(param, "BlessBaseEffectID", Info.BlessBaseEffectID);
	if((_tempMultiSellInfoList[_tempMultiSellInfoIndex].MultiSellInfoID != nMultiSellInfoID))
	{
		return;
	}
	if((nItemClassID == -100))
	{
		Info.Name = GetSystemString(1277);
		Info.IconName = GetPcCafeItemIconPackageName();
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if((nItemClassID == -200))
	{
		Info.Name = GetSystemString(1311);
		Info.IconName = "icon.etc_i.etc_bloodpledge_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if((nItemClassID == -300))
	{
		Info.Name = GetSystemString(102);
		Info.IconName = "icon.pvp_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if((nItemClassID == -500))
	{
		Info.Name = GetSystemString(3183);
		Info.IconName = "icon.etc_i.etc_rp_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if((nItemClassID == -600))
	{
		Info.Name = GetSystemString(13159);
		Info.IconName = "Icon.etc_i.craft_point";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if((nItemClassID == -800))
	{
		Info.Name = GetSystemString(2492);
		Info.IconName = "icon.etc_sayha_point_01";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else
	{
		Info.Name = Class'NWindow.UIDATA_ITEM'.static.GetItemName(Info.Id);
		Info.IconName = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(Info.Id);
	}
	Info.CrystalType = Class'NWindow.UIDATA_ITEM'.static.GetItemCrystalType(Info.Id);
	if((nItemClassID != -400))
	{
		nCurrentInputItemInfoIndex = _tempMultiSellInfoList[_tempMultiSellInfoIndex].InputItemInfoList.Length;
		_tempMultiSellInfoList[_tempMultiSellInfoIndex].InputItemInfoList.Length = (nCurrentInputItemInfoIndex + 1);
		_tempMultiSellInfoList[_tempMultiSellInfoIndex].InputItemInfoList[nCurrentInputItemInfoIndex] = Info;
	}
	return;
}

function Rs_EV_MultiSellInfoListEnd(string param)
{
	local MultiSellGroupInfo groupInfo;

	groupInfo.infoList = _tempMultiSellInfoList;
	groupInfo.MultisellID = _tempMultiSellId;
	groupInfo.tabindex = _tempTabIndex;
	groupInfo.Loaded = true;
	_multiSellGroupInfos[_tempTabIndex] = groupInfo;
	_isWaitingResponse = false;
	updateMultiSellData();
	UpdateUIControlsWithTimer();
	ResetTempInfo();
	return;
}

function Nt_EV_MultiSellResult(string param)
{
	local int Success, i;

	ParseInt(param, "Success", Success);
	Debug(("MultiSellItemExchangeWnd Nt_EV_MultiSellResult" @ string(Success)));
	if((hasEItemcheck == true))
	{
		i = 0;
		while((i < _multiSellGroupInfos.Length))
		{
			_multiSellGroupInfos[i].Loaded = false;
			i++;
		}
		if((_selectedTabIndex < _multiSellTabInfos.Length))
		{
			Rq_C_EX_MULTI_SELL_LIST(_multiSellTabInfos[_selectedTabIndex].MultisellID, _selectedTabIndex);
		}
		hasEItemcheck = false;
	}
	return;
}
