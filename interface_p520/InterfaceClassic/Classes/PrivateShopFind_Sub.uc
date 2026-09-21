class PrivateShopFind_Sub extends UICommonAPI
	dependson(UIPacket);

enum ItemType
{
	Equipment,                      // 0
	Artifact,                       // 1
	Enchant,                        // 2
	Consumable,                     // 3
	EtcType                         // 4
};

enum ItemSubtype
{
	Weapon,                         // 0
	Armor,                          // 1
	Accessary,                      // 2
	EtcEquipment,                   // 3
	ArtifactB1,                     // 4
	ArtifactC1,                     // 5
	ArtifactD1,                     // 6
	ArtifactA1,                     // 7
	ENCHANTSCROLL,                  // 8
	BlessEnchantScroll,             // 9
	MultiEnchantScroll,             // 10
	AncientEnchantScroll,           // 11
	Spiritshot,                     // 12
	Soulshot,                       // 13
	Buff,                           // 14
	VariationStone,                 // 15
	dye,                            // 16
	SoulCrystal,                    // 17
	SkillBook,                      // 18
	EtcEnchant,                     // 19
	PotionAndEtcScroll,             // 20
	ticket,                         // 21
	Craft,                          // 22
	IncEnchantProp,                 // 23
	NONE_DUMY_1,                    // 24
	EtcSubtype                      // 25
};

enum StoreType
{
	Sell,                           // 0
	Buy,                            // 1
	Wholesale,                      // 2
	AllStoreType                    // 3
};

struct categoryStruct
{
	var int SelectedIndex;
	var array<string> categoryStringArray;
	var array<string> categoryKeyArray;
};

var WindowHandle Me;
var ButtonHandle ReFresh_btn;
var TextureHandle GroupBox_tex;
var TextureHandle ListDeco_tex;
var RichListCtrlHandle List_RichList;
var WindowHandle FindDisable_Wnd;
var UIControlGroupButtonAssets SubUIControlGroupButtonAsset;
var PrivateShopFindWnd PrivateShopFindWndScript;
var UIControlGroupButtonAssets SubGroupButtonAsset;
var string m_Windowname;
var bool m_IsPrivateStoreBypass;
var array<categoryStruct> categoryArray;
var array<UIPacket._pkPSSearchItem> pkSearchItemListArray;
var array<UIPacket._pkPSSearchHistory> pkHistoryArray;

function OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEvent(40);
	RegisterEvent((100000 + 979));
	RegisterEvent((100000 + 980));
	return;
}

function OnLoad()
{
	Initialize();
	return;
}

function OnShow()
{
	if(GetWindowHandle("PrivateShopFindWnd").IsShowWindow())
	{
		Debug("OnShow PrivateShopFind_Sub");
		initCategoryData();
	}
	return;
}

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	FindDisable_Wnd = GetWindowHandle((m_Windowname $ ".FindDisable_Wnd"));
	ReFresh_btn = GetButtonHandle((m_Windowname $ ".PrivateShopFind_Sub.Refresh_btn"));
	GroupBox_tex = GetTextureHandle((m_Windowname $ ".PrivateShopFind_Sub.GroupBox_tex"));
	ListDeco_tex = GetTextureHandle((m_Windowname $ ".PrivateShopFind_Sub.ListDeco_tex"));
	List_RichList = GetRichListCtrlHandle((m_Windowname $ ".PrivateShopFind_Sub.List_RichList"));
	PrivateShopFindWndScript = PrivateShopFindWnd(GetScript("PrivateShopFindWnd"));
	initGroupButton();
	categoryArray.Length = 0;
	List_RichList.SetSelectedSelTooltip(false);
	List_RichList.SetAppearTooltipAtMouseX(true);
	m_IsPrivateStoreBypass = IsPrivateStoreBypass();
	List_RichList.SetColumnString(4, 7244);
	return;
}

function initCategoryData()
{
	local string categoryValueStr;

	if((categoryArray.Length <= 0))
	{
		if(getInstanceUIData().GetIsClassicServer())
		{
			categoryValueStr = ((((((("-1," $ string(0)) $ ",") $ string(1)) $ ",") $ string(2)) $ ",") $ string(3));
			categoryArray[categoryArray.Length] = getCategoryStruct("1046,2520,2532,2537,49", categoryValueStr);
			categoryValueStr = ((((((((((("-1," $ string(8)) $ ",") $ string(17)) $ ",") $ string(15)) $ ",") $ string(16)) $ ",") $ string(18)) $ ",") $ string(19));
			categoryArray[categoryArray.Length] = getCategoryStruct("1046,1532,2554,2553,25,2558,49", categoryValueStr);
			categoryValueStr = ((((((("-1," $ string(20)) $ ",") $ string(21)) $ ",") $ string(22)) $ ",") $ string(25));
			categoryArray[categoryArray.Length] = getCategoryStruct("1046,13848,5834,13892,49", categoryValueStr);
			categoryValueStr = ((((("-1," $ string(0)) $ ",") $ string(2)) $ ",") $ string(4));
			categoryArray[categoryArray.Length] = getCategoryStruct("1046,116,13846,49", categoryValueStr);
		}
		else
		{
			categoryValueStr = ((((("-1," $ string(0)) $ ",") $ string(1)) $ ",") $ string(2));
			categoryArray[categoryArray.Length] = getCategoryStruct("1046,2520,2532,2537", categoryValueStr);
			categoryValueStr = ((((((("-1," $ string(4)) $ ",") $ string(5)) $ ",") $ string(6)) $ ",") $ string(7));
			categoryArray[categoryArray.Length] = getCategoryStruct("144,3891,3892,3893,3894", categoryValueStr);
			categoryValueStr = ((((((("-1," $ string(8)) $ ",") $ string(9)) $ ",") $ string(10)) $ ",") $ string(11));
			categoryArray[categoryArray.Length] = getCategoryStruct("144,2611,13841,13842,13843", categoryValueStr);
			categoryValueStr = ((((("-1," $ string(12)) $ ",") $ string(13)) $ ",") $ string(14));
			categoryArray[categoryArray.Length] = getCategoryStruct("144,2545,2544,13318", categoryValueStr);
			categoryValueStr = ((((((("-1," $ string(15)) $ ",") $ string(16)) $ ",") $ string(23)) $ ",") $ string(25));
			categoryArray[categoryArray.Length] = getCategoryStruct("144,3349,25,13844,49", categoryValueStr);
			categoryArray[categoryArray.Length] = getCategoryStruct("144", "-1");
		}
	}
	return;
}

function categoryStruct getCategoryStruct(string categoryString, string matchKeyString)
{
	local categoryStruct Data;

	getInstanceL2Util().setSystemStringArrayByNumStr(categoryString, Data.categoryStringArray);
	getInstanceL2Util().setArrayByNumStr(matchKeyString, Data.categoryKeyArray);
	return Data;
}

function initGroupButton()
{
	SubGroupButtonAsset = Class'InterfaceClassic.UIControlGroupButtonAssets'.static._InitScript(GetWindowHandle((m_Windowname $ ".SubUIControlGroupButtonAsset")));
	SubGroupButtonAsset._SetStartInfo("L2UI_ct1.RankingWnd.RankingWnd_SubTabButton", "L2UI_ct1.RankingWnd.RankingWnd_SubTabButton_Down", "L2UI_ct1.RankingWnd.RankingWnd_SubTabButton_Over", true);
	SubGroupButtonAsset._GetGroupButtonsInstance().DelegateOnClickButton = DelegateOnClickButton;
	SubGroupButtonAsset._setDelayTime(1500);
	SubGroupButtonAsset.DelegateOnDelayTime = DelegateOnDelayTime;
	return;
}

function DelegateOnDelayTime(bool bOnTime)
{
	if(bOnTime)
	{
		ReFresh_btn.DisableWindow();
	}
	else
	{
		ReFresh_btn.EnableWindow();
	}
	return;
}

function setGroupButtonCategory(int Index)
{
	local int i;

	i = 0;
	while((i < categoryArray[Index].categoryStringArray.Length))
	{
		SubGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(i, categoryArray[Index].categoryStringArray[i]);
		SubGroupButtonAsset._GetGroupButtonsInstance()._setButtonValue(i, int(categoryArray[Index].categoryKeyArray[i]));
		i++;
	}
	SubGroupButtonAsset._GetGroupButtonsInstance()._setShowButtonNum(categoryArray[Index].categoryStringArray.Length);
	SubGroupButtonAsset._GetGroupButtonsInstance()._fixedWidth(110, 5);
	SubGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(categoryArray[Index].SelectedIndex);
	return;
}

function DelegateOnClickButton(string parentWndName, string strName, int Index)
{
	local int topButtonGroupIndex;

	topButtonGroupIndex = (PrivateShopFindWndScript.TopGroupButtonAsset._GetGroupButtonsInstance()._getSelectButtonIndex() - 1);
	categoryArray[topButtonGroupIndex].SelectedIndex = Index;
	refresh();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9750:
			categoryArray.Length = 0;
			break;
		case 40:
			categoryArray.Length = 0;
			break;
		case EV_PacketID(979):
			ParsePacket_S_EX_PRIVATE_STORE_SEARCH_ITEM();
			break;
		case EV_PacketID(980):
			ParsePacket_S_EX_PRIVATE_STORE_SEARCH_HISTORY();
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_PRIVATE_STORE_SEARCH_ITEM()
{
	local UIPacket._S_EX_PRIVATE_STORE_SEARCH_ITEM packet;
	local int i;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_PRIVATE_STORE_SEARCH_ITEM(packet))
	{
		return;
	}
	Debug((" -->  Decode_S_EX_PRIVATE_STORE_SEARCH_ITEM :  " @ string(packet.Items.Length)));
	if((packet.Items.Length == 0))
	{
		FindDisable_Wnd.ShowWindow();
	}
	else
	{
		FindDisable_Wnd.HideWindow();
	}
	Debug(("packet.cCurrentPage" @ string(packet.cCurrentPage)));
	Debug(("packet.cMaxPage" @ string(packet.cMaxPage)));
	if((packet.cCurrentPage == 1))
	{
		PrivateShopFindWndScript.disableWnd.ShowWindow();
		pkSearchItemListArray.Length = 0;
		pkHistoryArray.Length = 0;
	}
	i = 0;
	while((i < packet.Items.Length))
	{
		pkSearchItemListArray[pkSearchItemListArray.Length] = packet.Items[i];
		i++;
	}
	return;
}

function ParsePacket_S_EX_PRIVATE_STORE_SEARCH_HISTORY()
{
	local UIPacket._S_EX_PRIVATE_STORE_SEARCH_HISTORY packet;
	local ItemInfo Info;
	local Vector Loc;
	local int i;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_PRIVATE_STORE_SEARCH_HISTORY(packet))
	{
		return;
	}
	i = 0;
	while((i < packet.histories.Length))
	{
		pkHistoryArray[pkHistoryArray.Length] = packet.histories[i];
		i++;
	}
	if((packet.cCurrentPage == packet.cMaxPage))
	{
		i = 0;
		while((i < pkSearchItemListArray.Length))
		{
			RequestDisassembleItemInfo(pkSearchItemListArray[i].itemAssemble, Info);
			Loc.X = float(pkSearchItemListArray[i].nX);
			Loc.Y = float(pkSearchItemListArray[i].nY);
			Loc.Z = float(pkSearchItemListArray[i].nZ);
			if(m_IsPrivateStoreBypass)
			{
				pkSearchItemListArray[i].sUserName = GetSystemString(13198);
			}
			addRichListItem(pkSearchItemListArray[i].cStoreType, Info, Info.ItemNum, pkSearchItemListArray[i].nPrice, pkSearchItemListArray[i].sUserName, pkSearchItemListArray[i].nUserSID, Loc);
			i++;
		}
		PrivateShopFindWndScript.disableWnd.HideWindow();
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Refresh_btn":
			OnReFresh_btnClick();
			break;
		case "teleportBtn":
			OnTeleportBtnListClick();
			break;
		default:
			break;
	}
	return;
}

function OnReFresh_btnClick()
{
	refresh();
	return;
}

function OnTeleportBtnListClick()
{
	OnDBClickListCtrlRecord("List_RichList");
	return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	local RichListCtrlRowData rowData;

	if((ListCtrlID == "List_RichList"))
	{
		List_RichList.GetSelectedRec(rowData);
		if(m_IsPrivateStoreBypass)
		{
			API_C_EX_PRIVATE_STORE_BUY_SELL(rowData.cellDataList[3].nReserved1);
		}
		else
		{
			Debug(("\tRowData.cellDataList[5].nReserved1 " @ string(rowData.cellDataList[5].nReserved1)));
			if((rowData.cellDataList[5].nReserved1 > -1))
			{
				PrivateShopFindWndScript.ShowPopupTeleport(rowData.cellDataList[5].nReserved1);
			}
			else
			{
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13562));
			}
		}
	}
	return;
}

function setUserTargetCommand()
{
	local RichListCtrlRowData rowData;

	if((List_RichList.GetSelectedIndex() > -1))
	{
		List_RichList.GetSelectedRec(rowData);
		ChatWnd(GetScript("ChatWnd")).SetChatEditBox(MakeFullSystemMsg(GetSystemMessage(13571), rowData.cellDataList[3].szReserved));
	}
	return;
}

function addRichListItem(int nShopType, ItemInfo Info, INT64 Amount, INT64 adenaPrice, string pcName, int UserSid, Vector LocVector)
{
	local RichListCtrlRowData rowData;
	local string toolTipParam;
	local Color tColor;

	rowData.cellDataList.Length = 6;
	if((nShopType == 2))
	{
		tColor = GetColor(136, 136, 255, 255);
	}
	else if((nShopType == 1))
	{
		tColor = GetColor(255, 102, 102, 255);
	}
	else
	{
		tColor = GetColor(85, 153, 255, 255);
	}
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, getStringShopType(nShopType), tColor, false, 0, 0);
	rowData.cellDataList[1].HiddenStringForSorting = getStringShopType(nShopType);
	addRichListCtrlTexture(rowData.cellDataList[1].drawitems, "l2ui_ct1.ItemWindow_DF_SlotBox_Default", 36, 36, 8, 1);
	AddRichListCtrlItem(rowData.cellDataList[1].drawitems, Info, 32, 32, -34, 2);
	if((Info.IconPanel != ""))
	{
		addRichListCtrlTexture(rowData.cellDataList[1].drawitems, Info.IconPanel, 32, 32, -32, 0);
	}
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, GetItemNameAll(Info), GTColor().White, false, 4, 7);
	rowData.cellDataList[1].HiddenStringForSorting = GetItemNameAll(Info);
	rowData.cellDataList[1].nReserved1 = Info.Id.ClassID;
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, (("(" $ MakeCostStringINT64(Amount)) $ ")"), GTColor().White, false, 4, 0);
	addRichListCtrlTexture(rowData.cellDataList[2].drawitems, "L2UI_EPIC.RestartMenuWnd.Icon_Adena", 18, 16, 210, 15);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, "", GTColor().White, true, 0, 0);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, ConvertNumToText(string(adenaPrice)), GetNumericColor(MakeCostStringINT64(adenaPrice)), false, 30, -14);
	rowData.cellDataList[2].HiddenStringForSorting = getInstanceL2Util().makeZeroString(20, adenaPrice);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, "", GTColor().White, true, 0, 0);
	toolTipParam = getParamHistory(Info.Id.ClassID);
	AddRichListCtrlButton(rowData.cellDataList[2].drawitems, "ReceipBtn", 0, -22, "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_ReceiptIcon", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_ReceiptIcon", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_ReceiptIcon", 24, 30, 24, 30, 2, toolTipParam);
	AddRichListCtrlString(rowData.cellDataList[3].drawitems, pcName, GTColor().White, false, 4, 2);
	rowData.cellDataList[3].HiddenStringForSorting = pcName;
	rowData.cellDataList[3].szReserved = pcName;
	rowData.cellDataList[3].nReserved1 = UserSid;
	if(m_IsPrivateStoreBypass)
	{
		AddRichListCtrlString(rowData.cellDataList[4].drawitems, GetSystemString(7244), GTColor().White, false, 4, 2);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[4].drawitems, GetZoneNameWithLocation(LocVector), GTColor().White, false, 4, 2);
		rowData.cellDataList[4].HiddenStringForSorting = GetZoneNameWithLocation(LocVector);
	}
	rowData.cellDataList[5].nReserved1 = getInstanceUIData().GetTeleportIDByXYZ(int(LocVector.X), int(LocVector.Y), int(LocVector.Z), true);
	if(m_IsPrivateStoreBypass)
	{
		AddRichListCtrlButton(rowData.cellDataList[5].drawitems, "teleportBtn", 0, 0, "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_ExchangeBtn_Normal", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_ExchangeBtn_Down", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_ExchangeBtn_Over", 30, 30, 30, 30, 1);
	}
	else
	{
		AddRichListCtrlButton(rowData.cellDataList[5].drawitems, "teleportBtn", 0, 0, "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_TeleportBtn_Normal", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_TeleportBtn_Down", "L2UI_EPIC.PrivateShopFindWnd.PrivateShopFindWnd_TeleportBtn_Over", 30, 30, 30, 30, 1);
	}
	List_RichList.InsertRecord(rowData);
	return;
}

function string getParamHistory(int nClassID)
{
	local string param;
	local int Count, i;

	i = 0;
	while((i < pkHistoryArray.Length))
	{
		if((pkHistoryArray[i].nClassID == nClassID))
		{
			Count++;
			ParamAdd(param, ("shopType" $ string(Count)), string(pkHistoryArray[i].cStoreType));
			ParamAdd(param, ("adenaString" $ string(Count)), string(pkHistoryArray[i].nPrice));
			ParamAdd(param, ("enchant" $ string(Count)), string(pkHistoryArray[i].cEnchant));
		}
		i++;
	}
	ParamAdd(param, "count", string(Count));
	return param;
}

function refresh()
{
	local string inputText;
	local int nStoreType, nItemType, nItemSubtype;
	local bool bCollectionUse;

	PrivateShopFindWndScript.TopGroupButtonAsset._tryDelayClick();
	SubGroupButtonAsset._tryDelayClick();
	inputText = PrivateShopFindWndScript.uicontrolTextInputScr.GetString();
	nStoreType = PrivateShopFindWndScript.getStoreTypeByCheckBox();
	nItemType = PrivateShopFindWndScript.TopGroupButtonAsset._GetGroupButtonsInstance()._getSelectedButtonValue();
	nItemSubtype = SubGroupButtonAsset._GetGroupButtonsInstance()._getSelectedButtonValue();
	if(getInstanceUIData().GetIsClassicServer())
	{
		if((nItemType == 10000))
		{
			bCollectionUse = true;
			nItemType = SubGroupButtonAsset._GetGroupButtonsInstance()._getSelectedButtonValue();
			nItemSubtype = -1;
		}
		else
		{
			bCollectionUse = false;
		}
	}
	else if((nItemType == 10000))
	{
		bCollectionUse = true;
		nItemType = SubGroupButtonAsset._GetGroupButtonsInstance()._getSelectedButtonValue();
		nItemSubtype = -1;
	}
	else
	{
		bCollectionUse = false;
	}
	Debug("------------- refresh ----------------------");
	Debug(("inputText" @ inputText));
	Debug(("nStoreType" @ string(nStoreType)));
	Debug(("nItemType" @ string(nItemType)));
	Debug(("nItemSubtype" @ string(nItemSubtype)));
	Debug(("bCollectionUse" @ string(bCollectionUse)));
	List_RichList.DeleteAllItem();
	API_C_EX_PRIVATE_STORE_SEARCH_LIST(inputText, nStoreType, nItemType, nItemSubtype, bCollectionUse);
	return;
}

function string getStringShopType(int nShopType)
{
	if((nShopType == 2))
	{
		return GetSystemString(13851);
	}
	else if((nShopType == 1))
	{
		return GetSystemString(13850);
	}
	return GetSystemString(1157);
}

function API_C_EX_PRIVATE_STORE_SEARCH_LIST(string sSearchWord, int cStoreType, int cItemType, int cItemSubtype, bool bCollectionUse)
{
	local array<byte> stream;
	local UIPacket._C_EX_PRIVATE_STORE_SEARCH_LIST packet;

	sSearchWord = Caps(sSearchWord);
	packet.sSearchWord = sSearchWord;
	packet.cStoreType = cStoreType;
	packet.cItemType = cItemType;
	packet.cItemSubtype = cItemSubtype;
	packet.bSearchCollection = byte(boolToNum(bCollectionUse));
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_PRIVATE_STORE_SEARCH_LIST(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(741, stream);
	Debug(((((("api Call : C_EX_PRIVATE_STORE_SEARCH_LIST" @ packet.sSearchWord) @ string(packet.cStoreType)) @ string(packet.cItemType)) @ string(packet.cItemSubtype)) @ string(packet.bSearchCollection)));
	return;
}

function API_C_EX_PRIVATE_STORE_BUY_SELL(int nUserSID)
{
	local array<byte> stream;
	local UIPacket._C_EX_PRIVATE_STORE_BUY_SELL packet;

	packet.nTargetSid = nUserSID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_PRIVATE_STORE_BUY_SELL(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(845, stream);
	Debug(("api Call : C_EX_PRIVATE_STORE_BUY_SELL" @ string(packet.nTargetSid)));
	return;
}
