class WorldExchangeBuyHome extends UICommonAPI
	dependson(UIPacket);

const MINMULITY = 1000;
const refreshTime = 5000;

var bool bRQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST;
var bool bRQ_COININFO;
var UIControlTextInput uicontrolTextInputScr;
var UIControlTextInput UIControlTextInputResultScr;
var string lastFindString;
var array<int> ItemList;
var WindowHandle SearchResult_Wnd;
var RichListCtrlHandle SearchResult_RichList;
var bool isSearchResultWndShow;
var L2UITimerObject timerObj;
var int MINMULITY_ADENA;

static function WorldExchangeBuyHome Inst()
{
	return WorldExchangeBuyHome(GetScript("WorldExchangeBuyWnd.Home_Wnd"));
}

function InitSearchResult_Wnd()
{
	SearchResult_Wnd = GetWindowHandle("WorldExchangeBuyWnd.SearchResult_Wnd");
	SearchResult_RichList = GetRichListCtrlHandle("WorldExchangeBuyWnd.SearchResult_Wnd.SearchResult_RichList");
	return;
}

function InitTimer()
{
	timerObj = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(5000);
	timerObj._DelegateOnEnd = CoolTimeEnd;
	return;
}

function CoolTimeEnd()
{
	bRQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST = false;
	return;
}

function InitFindItem()
{
	uicontrolTextInputScr = Class'InterfaceClassic.UIControlTextInput'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeFind_Wnd.TextInput")));
	uicontrolTextInputScr.DelegateESCKey = DelegateESCKey;
	uicontrolTextInputScr.DelegateOnChangeEdited = DelegateOnChangeEdited;
	uicontrolTextInputScr.DelegateOnCompleteEditBox = DelegateOnCompleteEditBox;
	uicontrolTextInputScr.DelegateOnClear = DelegateOnClear;
	uicontrolTextInputScr.SetDefaultString(GetSystemString(2507));
	uicontrolTextInputScr.SetEdtiable(true);
	UIControlTextInputResultScr = Class'InterfaceClassic.UIControlTextInput'.static.InitScript(GetWindowHandle("WorldExchangeBuyWnd.SearchResult_Wnd.SearchResultFind_Wnd.TextInput"));
	UIControlTextInputResultScr.DelegateESCKey = _SwapToFind;
	UIControlTextInputResultScr.DelegateOnChangeEdited = DelegateOnChangeEdited;
	UIControlTextInputResultScr.DelegateOnCompleteEditBox = DelegateOnCompleteEditBox;
	UIControlTextInputResultScr.DelegateOnClear = DelegateOnClear;
	UIControlTextInputResultScr.SetDefaultString(GetSystemString(2507));
	UIControlTextInputResultScr.SetEdtiable(true);
	return;
}

function RichListCtrlHandle GetRichList()
{
	return GetRichListCtrlHandle("WorldExchangeBuyWnd.SearchResult_Wnd.SearchResult_RichList");
}

function DelegateESCKey()
{
	Class'InterfaceClassic.WorldExchangeBuyWnd'.static.Inst().DelegateESCKey();
	return;
}

function DelegateOnClear()
{
	_HandleClear();
	return;
}

function _HandleClear()
{
	local array<int> _itemList;

	lastFindString = "";
	ItemList.Length = 0;
	ClearList();
	uicontrolTextInputScr.Clear();
	Class'InterfaceClassic.WorldExchangeBuyWnd'.static.Inst()._SetFindString("", _itemList);
	return;
}

function DelegateOnChangeEdited(string Text)
{
	if((Text == ""))
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeFind_Wnd.BtnFind")).DisableWindow();
	}
	else
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeFind_Wnd.BtnFind")).EnableWindow();
	}
	if((lastFindString == Text))
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SearchResult_Wnd.BtnFind")).DisableWindow();
	}
	else
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SearchResult_Wnd.BtnFind")).EnableWindow();
	}
	return;
}

function DelegateOnCompleteEditBox(string Text)
{
	local array<int> _itemList;

	if(!CheckFindString(Text, _itemList))
	{
		Class'InterfaceClassic.L2Util'.static.Inst().showGfxScreenMessage(((("&#34;" $ Text) $ "&#34;") $ GetSystemMessage(4356)));
		return;
	}
	if((_itemList.Length > 300))
	{
		Class'InterfaceClassic.L2Util'.static.Inst().showGfxScreenMessage(GetSystemMessage(13767));
		return;
	}
	uicontrolTextInputScr.SetString(Text);
	UIControlTextInputResultScr.SetString(Text);
	Class'InterfaceClassic.WorldExchangeBuyWnd'.static.Inst()._SetFindString(Text, _itemList);
	lastFindString = Text;
	ItemList = _itemList;
	RQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST();
	return;
}

function Initialize()
{
	InitSearchResult_Wnd();
	InitFindItem();
	RegisterEvents();
	InitTimer();
	return;
}

event OnLoad()
{
	Initialize();
	return;
}

function RegisterEvents()
{
	RegisterEvent(40);
	RegisterEvent(EV_PacketID(1059));
	return;
}

function bool MakeRowData(UIPacket._WorldExchangeTotalListData _itemData, out RichListCtrlRowData outRowData)
{
	local RichListCtrlRowData rowData;
	local ItemInfo iInfo;
	local string strcom, itemParam;
	local INT64 perPrice;
	local array<string> strs;

	if((_itemData.nItemClassID < 1))
	{
		return false;
	}
	if(!Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(_itemData.nItemClassID), iInfo))
	{
		return false;
	}
	rowData.cellDataList.Length = 4;
	rowData.nReserved1 = INT64(_itemData.nItemClassID);
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "l2ui_ct1.ItemWindow_DF_SlotBox_Default", 36, 36, 0, 1);
	AddRichListCtrlItem(rowData.cellDataList[0].drawitems, iInfo, 32, 32, -34, 2);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetItemNameAll(iInfo), GTColor().White, false, 4, 9);
	perPrice = (_itemData.nMinPricePerPiece / INT64(1000));
	strcom = MakeCostStringINT64(perPrice);
	strs = Class'InterfaceClassic.WorldExchangeBuyWnd'.static.Inst()._GetDividedValue2Strs(_itemData.nMinPricePerPiece, iInfo.ItemNum, 3);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, ("." $ Right(string(_itemData.nMinPricePerPiece), 3)), GetColor(123, 123, 123, 255), false, 0, 1, "hs7");
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, strcom, GetNumericColor(strcom), false, 0, -2);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, string(_itemData.nAmount), GTColor().White, false);
	AddRichListCtrlButton(rowData.cellDataList[3].drawitems, "gotoBtn", 0, 0, "L2UI.WorldExchangeWnd.FindButton", "L2UI.WorldExchangeWnd.FindButton_Down", "L2UI.WorldExchangeWnd.FindButton_Over", 32, 32, 32, 32);
	ItemInfoToParam(iInfo, itemParam);
	rowData.szReserved = itemParam;
	outRowData = rowData;
	return true;
}

event OnShow()
{
	m_hOwnerWnd.SetFocus();
	return;
}

event OnEvent(int a_EventID, string param)
{
	switch(a_EventID)
	{
		case 40:
			Handle_EV_Restart();
			break;
		case EV_PacketID(1059):
			RT_S_EX_WORLD_EXCHANGE_TOTAL_LIST();
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "BtnFind":
			_HandleClickBtnFind();
			break;
		default:
			break;
	}
	return;
}

function _HandleClickBtnFind()
{
	DelegateOnCompleteEditBox(uicontrolTextInputScr.GetString());
	return;
}

function _Hide()
{
	m_hOwnerWnd.HideWindow();
	SearchResult_Wnd.HideWindow();
	return;
}

function _Show()
{
	if(isSearchResultWndShow)
	{
		SearchResult_Wnd.ShowWindow();
		SearchResult_Wnd.SetFocus();
	}
	else
	{
		m_hOwnerWnd.ShowWindow();
		m_hOwnerWnd.SetFocus();
	}
	RQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST();
	return;
}

function _SwapToResult()
{
	isSearchResultWndShow = true;
	m_hOwnerWnd.HideWindow();
	SearchResult_Wnd.ShowWindow();
	SearchResult_Wnd.SetFocus();
	UIControlTextInputResultScr.SetString(uicontrolTextInputScr.GetString());
	return;
}

function _SwapToFind()
{
	isSearchResultWndShow = false;
	SearchResult_Wnd.HideWindow();
	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetFocus();
	uicontrolTextInputScr.SetString(UIControlTextInputResultScr.GetString());
	return;
}

function _GotoFind()
{
	local RichListCtrlRowData rowData;

	if((SearchResult_RichList.GetSelectedIndex() < 0))
	{
		return;
	}
	SearchResult_RichList.GetSelectedRec(rowData);
	Class'InterfaceClassic.WorldExchangeBuyWnd'.static.Inst()._SetCategoryIndexByClassID(int(rowData.nReserved1));
	return;
}

function Handle_EV_Restart()
{
	uicontrolTextInputScr.Clear();
	UIControlTextInputResultScr.Clear();
	_HandleClear();
	_SwapToFind();
	return;
}

function _RQ_COININFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLD_EXCHANGE_TOTAL_LIST packet;

	if(bRQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST)
	{
		return;
	}
	bRQ_COININFO = true;
	bRQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST = true;
	timerObj._Reset();
	SetDisablbRefresh();
	packet.vItemIDList[0] = 57;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_WORLD_EXCHANGE_TOTAL_LIST(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(813, stream);
	return;
}

function _RQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST_WithInfos(array<int> iInfos)
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLD_EXCHANGE_TOTAL_LIST packet;

	if(bRQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST)
	{
		return;
	}
	Class'InterfaceClassic.WorldExchangeBuyWnd'.static.Inst()._DotTextureAllHide();
	if((iInfos.Length == 0))
	{
		return;
	}
	bRQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST = true;
	timerObj._Reset();
	SetDisablbRefresh();
	packet.vItemIDList = iInfos;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_WORLD_EXCHANGE_TOTAL_LIST(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(813, stream);
	return;
}

function RQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST()
{
	_RQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST_WithInfos(ItemList);
	return;
}

function RT_S_EX_WORLD_EXCHANGE_TOTAL_LIST()
{
	local UIPacket._S_EX_WORLD_EXCHANGE_TOTAL_LIST packet;

	bRQ_C_EX_WORLD_EXCHANGE_TOTAL_LIST = false;
	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_WORLD_EXCHANGE_TOTAL_LIST(packet))
	{
		return;
	}
	Handle_S_EX_WORLD_EXCHANGE_TOTAL_LIST(packet);
	return;
}

function SetAdenaInfo(INT64 nAmount, INT64 nPrice, INT64 nMinPricePerPiece)
{
	local ItemInfo iInfo;
	local string Adenastring, numL, numM, numR;

	iInfo = GetItemInfoByClassID(57);
	iInfo.ItemNum = nAmount;
	Debug((((("SetAdenaInfo" @ Adenastring) @ string(nPrice)) @ string(nMinPricePerPiece)) @ string(Class'InterfaceClassic.WorldExchangeBuyWnd'.static.Inst()._IsNewServer())));
	Class'InterfaceClassic.WorldExchangeBuyWnd'.static.Inst()._MakeAdenaitemInfo(iInfo);
	GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeBottom_Wnd.ItemWnd_Wnd")).Clear();
	GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeBottom_Wnd.ItemWnd_Wnd")).AddItem(iInfo);
	Adenastring = Class'InterfaceClassic.WorldExchangeBuyWnd'.static.Inst()._MakeAdenaString(iInfo.ItemNum);
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeBottom_Wnd.Text00_Txt")).SetText(Adenastring);
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeBottom_Wnd.Text00_Txt")).SetTextColor(GetNumericColor(string(iInfo.ItemNum)));
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeBottom_Wnd.Text01_Txt")).SetText((MakeCostStringINT64(nPrice) @ GetSystemString(3931)));
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeBottom_Wnd.Text00_Txt")).SetTextColor(GetNumericColor(string(nPrice)));
	numL = string((nMinPricePerPiece / INT64(MINMULITY_ADENA)));
	numM = Mid(string(nMinPricePerPiece), Len(numL));
	numR = Left(numM, 3);
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeBottom_Wnd.Text02_Txt")).SetText((((numL $ ".") $ numR) @ GetSystemString(3931)));
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeBottom_Wnd.Text02_Txt")).SetTextColor(GetNumericColor(string((nMinPricePerPiece / INT64(MINMULITY_ADENA)))));
	return;
}

function ClearList()
{
	SearchResult_RichList.DeleteAllItem();
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SearchResult_Wnd.FindDisable_Wnd")).ShowWindow();
	Class'InterfaceClassic.WorldExchangeBuyWnd'.static.Inst()._DotTextureAllHide();
	return;
}

function Handle_S_EX_WORLD_EXCHANGE_TOTAL_LIST(UIPacket._S_EX_WORLD_EXCHANGE_TOTAL_LIST packet)
{
	local int i;
	local RichListCtrlRowData rowData;

	if(bRQ_COININFO)
	{
		bRQ_COININFO = false;
		SetAdenaInfo(packet.vItemIDList[0].nAmount, packet.vItemIDList[0].nPrice, packet.vItemIDList[0].nMinPricePerPiece);
	}
	else if((Class'InterfaceClassic.WorldExchangeBuyWnd'.static.Inst()._GetCurrentMainType() == 7))
	{
		ClearList();
		Class'InterfaceClassic.WorldExchangeBuyWnd'.static.Inst()._DotTextureAllHide();
		i = 0;
		while((i < packet.vItemIDList.Length))
		{
			if((packet.vItemIDList[i].nItemClassID == 57))
			{
				SetAdenaInfo(packet.vItemIDList[i].nAmount, packet.vItemIDList[i].nPrice, packet.vItemIDList[i].nMinPricePerPiece);
				Class'InterfaceClassic.L2Util'.static.Inst().showGfxScreenMessage(GetSystemMessage(13786));
				i++;
				continue;
			}
			if(MakeRowData(packet.vItemIDList[i], rowData))
			{
				SearchResult_RichList.InsertRecord(rowData);
				Class'InterfaceClassic.WorldExchangeBuyWnd'.static.Inst()._DotAdd(packet.vItemIDList[i].nItemClassID);
			}
			i++;
		}
		if((SearchResult_RichList.GetRecordCount() > 0))
		{
			GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SearchResult_Wnd.FindDisable_Wnd")).HideWindow();
			Class'InterfaceClassic.WorldExchangeBuyWnd'.static.Inst()._DotSubCurrentSet();
		}
		_SwapToResult();
	}
	else
	{
		Class'InterfaceClassic.WorldExchangeBuyWnd'.static.Inst()._DotTextureAllHide();
		i = 0;
		while((i < packet.vItemIDList.Length))
		{
			if((packet.vItemIDList[i].nItemClassID == 57))
			{
				SetAdenaInfo(packet.vItemIDList[i].nAmount, packet.vItemIDList[i].nPrice, packet.vItemIDList[i].nMinPricePerPiece);
				i++;
				continue;
			}
			if((Class'InterfaceClassic.WorldExchangeBuyWnd'.static.Inst()._GetCurrentMainType() != 0))
			{
				Class'InterfaceClassic.WorldExchangeBuyWnd'.static.Inst()._DotAdd(packet.vItemIDList[i].nItemClassID);
			}
			i++;
		}
		Class'InterfaceClassic.WorldExchangeBuyWnd'.static.Inst()._DotSubCurrentSet();
		return;
	}
	return;
}

function SetDisablbRefresh()
{
	return;
}

function API_GetStringMatchingItemList(string a_str, string a_delim, UIEventManager.EStringMatchingItemFilter a_filter, bool a_bAscend, out array<int> o_ItemList)
{
	Class'NWindow.UIDATA_ITEM'.static.GetStringMatchingItemList(a_str, a_delim, a_filter, a_bAscend, o_ItemList);
	return;
}

function int API_GetServerPrivateStoreSearchItemSubType(int ClassID)
{
	return GetServerPrivateStoreSearchItemSubType(ClassID);
}

function bool CheckFindString(string Text, out array<int> _itemList)
{
	if((Text == ""))
	{
		return true;
	}
	API_GetStringMatchingItemList(Text, " ", SMIF_WorldExchangeItem, true, _itemList);
	return (_itemList.Length > 0);
}

function string GetInt64NumStr(float Num)
{
	local array<string> nums;

	Split(string(Num), ".", nums);
	return nums[0];
}

function _OnLoadEachServer()
{
	MINMULITY_ADENA = 1000;
	if(Class'InterfaceClassic.WorldExchangeBuyWnd'.static.Inst()._IsNewServer())
	{
		GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeBottom_Wnd.Header02_Txt")).SetText(GetSystemString(14424));
	}
	else
	{
		GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".HomeBottom_Wnd.Header02_Txt")).SetText(GetSystemString(14192));
	}
	return;
}
