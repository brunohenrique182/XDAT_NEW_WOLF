class HomunculusWndMainList extends UICommonAPI
	dependson(UIPacket);

const LISTITEMMAX = 9;
const LISTMAX = 18;

var WindowHandle Me;
var string m_Windowname;
var HomunculusWndMainViewport homunculusWndMainViewportScript;
var HomunculusWndMainDetailStats homunculusWndMainDetailStatsScript;
var HomunculusWndMainDetailStatsEnchant homunculusWndMainDetailStatsEnchantScript;
var HomunculusWndBirth homunculusWndBirthScript;
var HomunculusWnd HomunculusWndScript;
var array<HomunculusWndMainListItem> listItems;
var int currentSelectedItemIndex;
var int currentSelectedIdx;
var int currentSelectedDataIndex;
var array<HomunculusAPI.HomunculusData> homunculusDatas;
var array<int> listNew;
var bool inited;
var int nActivateSlotIndex;
var UIControlPageNavi pageNavi;
var bool naviBtnClicked;

function HandleGameInit()
{
	if(!HomunculusWndScript.ChkSerVer())
	{
		return;
	}
	inited = false;
	return;
}

function HandleRestart()
{
	if(!HomunculusWndScript.ChkSerVer())
	{
		return;
	}
	inited = false;
	return;
}

function ClearAll()
{
	local int i;

	i = 0;
	while((i < listItems.Length))
	{
		listItems[i].ClearAll();
		i++;
	}
	return;
}

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	homunculusWndMainViewportScript = HomunculusWndMainViewport(GetScript("HomunculusWnd.HomunculusWndMainViewport"));
	homunculusWndMainDetailStatsScript = HomunculusWndMainDetailStats(GetScript("HomunculusWnd.HomunculusWndMainDetailStats"));
	homunculusWndMainDetailStatsEnchantScript = HomunculusWndMainDetailStatsEnchant(GetScript("HomunculusWnd.HomunculusWndMainDetailStatsEnchant"));
	homunculusWndBirthScript = HomunculusWndBirth(GetScript("HomunculusWnd.HomunculusWndBirth"));
	HomunculusWndScript = HomunculusWnd(GetScript("HomunculusWnd"));
	InitPageNavi();
	InitHandleListItems();
	return;
}

function InitHandleListItems()
{
	local int i;

	i = 0;
	while((i < 9))
	{
		GetWindowHandle(((m_Windowname $ ".Item") $ string(i))).SetScript("HomunculusWndMainListItem");
		listItems[i] = HomunculusWndMainListItem(GetWindowHandle(((m_Windowname $ ".Item") $ string(i))).GetScript());
		listItems[i].Init(((m_Windowname $ ".Item") $ string(i)));
		listItems[i].SetState(Normal);
		i++;
	}
	currentSelectedItemIndex = -1;
	return;
}

function InitPageNavi()
{
	local WindowHandle PageNaviControl;

	PageNaviControl = GetWindowHandle((m_Windowname $ ".PageNaviControl"));
	PageNaviControl.SetScript("UIControlPageNavi");
	pageNavi = UIControlPageNavi(PageNaviControl.GetScript());
	pageNavi.Init((m_Windowname $ ".PageNaviControl"));
	pageNavi.SetTotalPage(2);
	pageNavi.Go(1);
	pageNavi.DelegeOnChangePage = pageChanged;
	pageNavi.DelegateOnClickButton = pageNaviButtonClicked;
	return;
}

function API_EX_SHOW_HOMUNCULUS_INFO()
{
	HomunculusWndScript.API_C_EX_SHOW_HOMUNCULUS_INFO(1);
	return;
}

function API_C_EX_HOMUNCULUS_ACTIVATE_SLOT(int SlotIndex)
{
	HomunculusWndScript.API_C_EX_HOMUNCULUS_ACTIVATE_SLOT(SlotIndex);
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(150);
	RegisterEvent(11460);
	RegisterEvent((100000 + 931));
	RegisterEvent((100000 + 859));
	return;
}

function OnLoad()
{
	Initialize();
	return;
}

function OnEvent(int Event_ID, string param)
{
	Debug((("------------------- HomunculusWndMainList's event : " @ string(Event_ID)) @ param));
	switch(Event_ID)
	{
		case 11460:
			HandleListItems();
			inited = true;
			break;
		case 150:
			HandleGameInit();
			break;
		case 40:
			HandleRestart();
			break;
		case (100000 + 931):
			Handle_S_EX_HOMUNCULUS_ACTIVATE_SLOT_RESULT();
			break;
		case (100000 + 859):
			Handle_S_EX_DELETE_HOMUNCLUS_DATA_RESULT();
			break;
		default:
			break;
	}
	return;
}

function ShowPopup()
{
	local UIControlDialogAssets popupExpandScript;
	local array<RequestItem> requestItems;
	local int i;

	popupExpandScript = HomunculusWndScript.GetPopupExpandScript();
	popupExpandScript.SetDialogDesc(GetSystemString(13557));
	popupExpandScript.SetUseNeedItem(true);
	requestItems = API_GetHomunculusSlotActivateCost((nActivateSlotIndex + 1));
	popupExpandScript.StartNeedItemList(requestItems.Length);
	i = 0;
	while((i < requestItems.Length))
	{
		popupExpandScript.AddNeedItemClassID(requestItems[i].Id, requestItems[i].Amount);
		i++;
	}
	popupExpandScript.SetItemNum(1);
	popupExpandScript.Show();
	popupExpandScript.DelegateOnClickBuy = SetActivateSlot;
	return;
}

function array<RequestItem> API_GetHomunculusSlotActivateCost(int SlotIndex)
{
	return Class'NWindow.HomunculusAPI'.static.GetHomunculusSlotActivateCost(SlotIndex);
}

function SetActivateSlot()
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = HomunculusWndScript.GetPopupExpandScript();
	popupExpandScript.Hide();
	API_C_EX_HOMUNCULUS_ACTIVATE_SLOT((nActivateSlotIndex + 1));
	return;
}

function HandleListItemClicked(int itemIndex)
{
	switch(listItems[itemIndex].currState)
	{
		case NOTACTIVE:
			ShowPopup();
			break;
		case Normal:
			RemNew(listItems[itemIndex].currHomunculusData.idx);
			SetSelect(GetDataIndex(itemIndex));
			break;
		case READY:
			homunculusWndBirthScript.isGachaState = false;
			HomunculusWndScript.SetState(birth);
			break;
		default:
			break;
	}
	return;
}

function DeSelect()
{
	local int i;

	i = 0;
	while((i < 9))
	{
		listItems[i].SetSelected(false);
		i++;
	}
	HomunculusWndScript.ClearHomunculusData();
	currentSelectedDataIndex = -1;
	currentSelectedItemIndex = -1;
	currentSelectedIdx = -1;
	return;
}

function SetSelect(int dataindex)
{
	local int itemIndex, i;

	i = 0;
	while((i < 9))
	{
		listItems[i].SetSelected(false);
		i++;
	}
	itemIndex = GetItemIndex(dataindex);
	currentSelectedIdx = homunculusDatas[dataindex].idx;
	currentSelectedDataIndex = dataindex;
	currentSelectedItemIndex = itemIndex;
	if((itemIndex != -1))
	{
		listItems[itemIndex].SetSelected(true);
	}
	HomunculusWndScript.RenewHomunculusData();
	return;
}

function Show()
{
	API_EX_SHOW_HOMUNCULUS_INFO();
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function Hide()
{
	Me.HideWindow();
	return;
}

function SetActiveIdx(bool bActive, int idx)
{
	local int Index;

	Index = GetDataIndexByIdx(idx);
	if((Index == -1))
	{
		return;
	}
	homunculusDatas[Index].Activate = bActive;
	listItems[Index].SetActive(bActive);
	homunculusWndMainViewportScript.SetActive(bActive);
	return;
}

function pageChanged(int Page)
{
	HandleListItems(naviBtnClicked);
	return;
}

function pageNaviButtonClicked(string buttonName)
{
	naviBtnClicked = true;
	return;
}

function SetActiveSlotIndex(int SlotIndex)
{
	if((nActivateSlotIndex > 0))
	{
		HandleListItems();
	}
	nActivateSlotIndex = SlotIndex;
	return;
}

function _AddNew(int idx)
{
	AddNew(idx);
	return;
}

function AddNew(int idx)
{
	local int Index;

	Index = GetIndexNew(idx);
	if((Index > -1))
	{
		return;
	}
	listNew[listNew.Length] = idx;
	return;
}

function RemNew(int idx)
{
	local int Index;

	Index = GetIndexNew(idx);
	if((Index > -1))
	{
		listNew.Remove(Index, 1);
	}
	return;
}

function int HandleNew()
{
	local int i, dataindex, lastNewIdx;

	if(!inited)
	{
		listNew.Length = 0;
		return -1;
	}
	i = 0;
	while((i < homunculusDatas.Length))
	{
		if(homunculusDatas[i].IsNew)
		{
			lastNewIdx = homunculusDatas[i].idx;
			AddNew(lastNewIdx);
		}
		i++;
	}
	if((lastNewIdx > 0))
	{
		dataindex = GetDataIndexByIdx(lastNewIdx);
		if((dataindex > -1))
		{
			currentSelectedIdx = lastNewIdx;
			currentSelectedDataIndex = dataindex;
			currentSelectedItemIndex = -1;
			return lastNewIdx;
		}
	}
	return -1;
}

function HandleListItems(optional bool dontGoToPage)
{
	local HomunculusAPI.HomunculusData newHomunculusData;
	local int i, dataindex, lastNewIdx;
	local HomunculusWndRevolution homunclusRevolutionScript;

	naviBtnClicked = false;
	homunculusDatas = HomunculusWndScript.API_GetHomunculusDatas();
	if((homunculusDatas.Length == 0))
	{
		homunculusWndMainViewportScript.SetNoneHomunculus();
	}
	if(!dontGoToPage)
	{
		lastNewIdx = HandleNew();
		if((lastNewIdx > 0))
		{
			pageNavi.Go(((GetDataIndexByIdx(lastNewIdx) / 9) + 1));
			return;
		}
		if((currentSelectedIdx > -1))
		{
			if((GetPageByDataIndex(currentSelectedDataIndex) != pageNavi.GetPage()))
			{
				pageNavi.Go(GetPageByDataIndex(currentSelectedDataIndex));
				return;
			}
		}
	}
	i = 0;
	while((i < 9))
	{
		dataindex = GetDataIndex(i);
		if((dataindex < homunculusDatas.Length))
		{
			newHomunculusData = homunculusDatas[dataindex];
			listItems[i].SetState(Normal);
			newHomunculusData.IsNew = (GetIndexNew(newHomunculusData.idx) != -1);
			listItems[i].SetHomunculusData(newHomunculusData);
			listItems[i].SetEnable();
			i++;
			continue;
		}
		if(((dataindex == homunculusDatas.Length) && homunculusWndBirthScript.BeProgress()))
		{
			listItems[i].SetState(READY);
			listItems[i].SetOnBirth();
			listItems[i].SetEnable();
			i++;
			continue;
		}
		if((dataindex < nActivateSlotIndex))
		{
			listItems[i].SetState(READY);
			i++;
			continue;
		}
		if((dataindex == nActivateSlotIndex))
		{
			listItems[i].SetState(NOTACTIVE);
			listItems[i].SetEnable();
			i++;
			continue;
		}
		listItems[i].SetState(Lock);
		i++;
	}
	dataindex = GetDataIndexByIdx(currentSelectedIdx);
	if((dataindex == -1))
	{
		DeSelect();
	}
	else
	{
		SetSelect(dataindex);
	}
	homunclusRevolutionScript = HomunculusWndRevolution(GetScript("HomunculusWnd.HomunculusWndRevolution"));
	homunclusRevolutionScript._SetViewPort();
	return;
}

function Handle_S_EX_DELETE_HOMUNCLUS_DATA_RESULT()
{
	local UIPacket._S_EX_DELETE_HOMUNCLUS_DATA_RESULT packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_DELETE_HOMUNCLUS_DATA_RESULT(packet))
	{
		return;
	}
	if((packet.Type == 1))
	{
		AddSystemMessage(13252);
		DeSelect();
	}
	else
	{
		AddSystemMessage(packet.nID);
	}
	return;
}

function Handle_S_EX_HOMUNCULUS_ACTIVATE_SLOT_RESULT()
{
	local UIPacket._S_EX_HOMUNCULUS_ACTIVATE_SLOT_RESULT packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_HOMUNCULUS_ACTIVATE_SLOT_RESULT(packet))
	{
		return;
	}
	if((packet.Type == 1))
	{
		HandleListItems();
	}
	return;
}

function int GetDataIndex(int itemIndex)
{
	return (itemIndex + ((pageNavi.GetPage() - 1) * 9));
}

function int GetItemIndex(int dataindex)
{
	if((pageNavi.GetPage() != ((dataindex / 9) + 1)))
	{
		return -1;
	}
	return (dataindex - ((pageNavi.GetPage() - 1) * 9));
}

function int GetPageByDataIndex(int dataindex)
{
	return ((dataindex / 9) + 1);
}

function int GetDataIndexByIdx(int idx)
{
	local int i;

	i = 0;
	while((i < homunculusDatas.Length))
	{
		if((homunculusDatas[i].idx == idx))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function int GetIndexNew(int idx)
{
	local int i;

	i = 0;
	while((i < listNew.Length))
	{
		if((listNew[i] == idx))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function HomunculusAPI.HomunculusData GetCurrHomunculusData()
{
	local HomunculusAPI.HomunculusData emptyHomunculusData;

	if((currentSelectedDataIndex >= 0))
	{
		return homunculusDatas[currentSelectedDataIndex];
	}
	else
	{
		return emptyHomunculusData;
	}
}

function int GetEmptySlot()
{
	local int firstEmptySlot;

	firstEmptySlot = homunculusDatas.Length;
	if(homunculusWndBirthScript.BeProgress())
	{
		firstEmptySlot = (firstEmptySlot + 1);
	}
	if((firstEmptySlot == nActivateSlotIndex))
	{
		return -1;
	}
	return firstEmptySlot;
}

function bool CanActiveLock()
{
	local int SlotIndex;

	SlotIndex = nActivateSlotIndex;
	if(homunculusWndBirthScript.BeProgress())
	{
		SlotIndex = (SlotIndex + 1);
	}
	return (SlotIndex < 18);
}
