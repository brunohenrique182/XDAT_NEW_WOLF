class UIItemToolWnd extends UICommonAPI;

const DELAY1_ID = 102001;
const DELAY2_ID = 102002;

var WindowHandle Me;
var ListCtrlHandle itemListCtrl;
var ComboBoxHandle ItemTypeComboBox;
var ComboBoxHandle ItemGradeComboBox;
var ComboBoxHandle ItemOptionComboBox;
var ComboBoxHandle ItemOption2ComboBox;
var ButtonHandle searchItemBtn;
var ButtonHandle getItemBtn;
var EditBoxHandle searchEditBox;
var EditBoxHandle itemCountEditBox;
var EditBoxHandle Create2EditBox;
var EditBoxHandle addInfoEditBox;
var ButtonHandle InitBtn;
var L2Util util;
var int iconPanelTotalCount;
var ItemInfo targetItemInfo;
var ItemID cID;
var int searchItemID;
var int filterItemType;
var ItemInfo tmItemInfo;
var string fullNameString;
var string modifiedString;
var string modifiedParam;
var int ItemCrystalType;
var bool useTick;
var bool switchBool;
var string SearchString;
var array<int> SlotBitType;
var CheckBoxHandle ChkBoxBless;
var CheckBoxHandle ChkBox64;

function OnRegisterEvent()
{
	RegisterEvent(540);
	return;
}

function OnShow()
{
	Me.DisableTick();
	useTick = false;
	setWindowTitleByString("UIPowerTools [ ItemSearchTool ]");
	ChkBox64.HideWindow();
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	util = L2Util(GetScript("L2Util"));
	Initialize();
	return;
}

function Initialize()
{
	local int i;

	Me = GetWindowHandle("UIItemToolWnd");
	itemListCtrl = GetListCtrlHandle("UIItemToolWnd.itemListCtrl");
	searchItemBtn = GetButtonHandle("UIItemToolWnd.searchItemBtn");
	getItemBtn = GetButtonHandle("UIItemToolWnd.getItemBtn");
	ItemTypeComboBox = GetComboBoxHandle("UIItemToolWnd.ItemTypeComboBox");
	ItemGradeComboBox = GetComboBoxHandle("UIItemToolWnd.ItemGradeComboBox");
	ItemOptionComboBox = GetComboBoxHandle("UIItemToolWnd.ItemOptionComboBox");
	ItemOption2ComboBox = GetComboBoxHandle("UIItemToolWnd.ItemOption2ComboBox");
	searchEditBox = GetEditBoxHandle("UIItemToolWnd.searchEditBox");
	itemCountEditBox = GetEditBoxHandle("UIItemToolWnd.itemCountEditBox");
	Create2EditBox = GetEditBoxHandle("UIItemToolWnd.Create2EditBox");
	addInfoEditBox = GetEditBoxHandle("UIItemToolWnd.addInfoEditBox");
	ChkBoxBless = GetCheckBoxHandle("UIItemToolWnd.ChkBoxBless");
	ChkBox64 = GetCheckBoxHandle("UIItemToolWnd.ChkBox64");
	ItemTypeComboBox.Clear();
	ItemTypeComboBox.AddString("ITEM_WEAPON");
	ItemTypeComboBox.AddString("ITEM_ARMOR");
	ItemTypeComboBox.AddString("ITEM_ACCESSARY");
	ItemTypeComboBox.AddString("ITEM_QUESTITEM");
	ItemTypeComboBox.AddString("ITEM_ASSET");
	ItemTypeComboBox.AddString("ITEM_ETCITEM");
	ItemTypeComboBox.AddString("Total");
	ItemTypeComboBox.SetSelectedNum(6);
	ItemGradeComboBox.Clear();
	i = 0;
	while((i < 13))
	{
		ItemGradeComboBox.AddString(util.getItemGradeSystemString(i));
		i++;
	}
	ItemGradeComboBox.AddString("Total");
	ItemGradeComboBox.SetSelectedNum(13);
	itemCountEditBox.SetString("1");
	itemListCtrl.SetSelectedSelTooltip(false);
	itemListCtrl.SetAppearTooltipAtMouseX(true);
	inputSlotBitType();
	setOptionComboBoxString(ItemGradeComboBox.GetSelectedNum());
	setOptionComboBox2String(ItemGradeComboBox.GetSelectedNum());
	setWindowTitleByString("UIPowerTools [ ItemTool ]");
	return;
}

function inputSlotBitType()
{
	SlotBitType.Length = 28;
	SlotBitType[0] = 1;
	SlotBitType[1] = 2;
	SlotBitType[2] = 4;
	SlotBitType[3] = 6;
	SlotBitType[4] = 8;
	SlotBitType[5] = 16;
	SlotBitType[6] = 32;
	SlotBitType[7] = 48;
	SlotBitType[8] = 64;
	SlotBitType[9] = 128;
	SlotBitType[10] = 256;
	SlotBitType[11] = 512;
	SlotBitType[12] = 1024;
	SlotBitType[13] = 2048;
	SlotBitType[14] = 4096;
	SlotBitType[15] = 8192;
	SlotBitType[16] = 16384;
	SlotBitType[17] = 32768;
	SlotBitType[18] = 65536;
	SlotBitType[19] = 131072;
	SlotBitType[20] = 262144;
	SlotBitType[21] = 524288;
	SlotBitType[22] = 1048576;
	SlotBitType[23] = 2097152;
	SlotBitType[24] = 4194304;
	SlotBitType[25] = 268435456;
	SlotBitType[26] = 536870912;
	SlotBitType[27] = 1073741824;
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "searchItemBtn":
			OnsearchItemBtnClick();
			break;
		case "getItemBtn":
			OnGetItemBtnClick();
			break;
		case "InitBtn":
			Initialize();
			OnInitBtnClick();
			break;
		case "MultiSell_Up_Button":
			itemCountEditBox.SetString(string((int(itemCountEditBox.GetString()) + 1)));
			break;
		case "MultiSell_Down_Button":
			if((int(itemCountEditBox.GetString()) > 1))
			{
				itemCountEditBox.SetString(string((int(itemCountEditBox.GetString()) - 1)));
			}
			break;
		case "NumInitButton":
			itemCountEditBox.SetString("1");
			Create2EditBox.SetString("1");
			break;
		case "BuildCommandButton":
			Debug("BuildCommandButton");
			ExecuteCommand(addInfoEditBox.GetString());
			AddSystemMessageString(("---> Execute " @ addInfoEditBox.GetString()));
			break;
		case "bcBtn":
			ClipboardCopy(addInfoEditBox.GetString());
			AddSystemMessageString(("---> ClipboardCopy " @ addInfoEditBox.GetString()));
			break;
		default:
			break;
	}
	return;
}

function debugItem(INT64 cID)
{
	local ItemInfo tmItemInfo;
	local ItemID cItemID;

	cItemID.ClassID = int(cID);
	if(Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cItemID, tmItemInfo))
	{
		Debug(((("debugItem" @ string(tmItemInfo.SlotBitType)) @ string(tmItemInfo.ArmorType)) @ string(tmItemInfo.BodyPart)));
	}
	return;
}

function OnGetItemBtnClick()
{
	local LVDataRecord Record;
	local int nItemCount;

	nItemCount = 1;
	if((int(itemCountEditBox.GetString()) > 1))
	{
		nItemCount = int(itemCountEditBox.GetString());
	}
	itemListCtrl.GetSelectedRec(Record);
	debugItem(Record.nReserved1);
	ProcessChatMessage(((("//summon" @ string(Record.nReserved1)) $ " ") $ string(nItemCount)));
	return;
}

function executeSearch(string searchKey)
{
	searchEditBox.SetString(searchKey);
	OnsearchItemBtnClick();
	return;
}

function OnsearchItemBtnClick()
{
	FindAllItem(searchEditBox.GetString());
	return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	local LVDataRecord Record;
	local ItemID cItemID;
	local ItemInfo ItemInfo;

	if((ListCtrlID == "itemListCtrl"))
	{
		if((itemListCtrl.GetSelectedIndex() <= -1))
		{
			return;
		}
		itemListCtrl.GetSelectedRec(Record);
		cItemID.ClassID = int(Record.nReserved1);
		if(Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cItemID, ItemInfo))
		{
			Debug("--------------------------------------------------------");
			Debug(("Name      :" @ ItemInfo.Name));
			Debug(("IconName  :" @ Record.LVDataList[0].szTexture));
			Debug(("IconPanel :" @ Record.LVDataList[0].iconPanelName));
			if((isEnableEnchant(ItemInfo) && (int(Create2EditBox.GetString()) > 1)))
			{
				addInfoEditBox.SetString((("//생성2" @ Create2EditBox.GetString()) @ string(ItemInfo.Id.ClassID)));  // EN: //spawn2
			}
			else
			{
				addInfoEditBox.SetString((("//생성" @ string(ItemInfo.Id.ClassID)) @ itemCountEditBox.GetString()));  // EN: //spawn
			}
		}
	}
	return;
}

function string getItemTypeString(int EtcItemType)
{
	switch(EtcItemType)
	{
		case 0:
			return "ITEME_NONE";
		case 1:
			return "ITEME_SCROLL";
		case 2:
			return "ITEME_ARROW";
		case 3:
			return "ITEME_POTION";
		case 4:
			return "ITEME_SPELLBOOK";
		case 5:
			return "ITEME_RECIPE";
		case 6:
			return "ITEME_MATERIAL";
		case 7:
			return "ITEME_PET_COLLAR";
		case 8:
			return "ITEME_CASTLE_GUARD";
		case 9:
			return "ITEME_DYE";
		case 10:
			return "ITEME_SEED";
		case 11:
			return "ITEME_SEED2";
		case 12:
			return "ITEME_HARVEST";
		case 13:
			return "ITEME_LOTTO";
		case 14:
			return "ITEME_RACE_TICKET";
		case 15:
			return "ITEME_TICKET_OF_LORD";
		case 16:
			return "ITEME_LURE";
		case 17:
			return "ITEME_CROP";
		case 18:
			return "ITEME_MATURECROP";
		case 19:
			return "ITEME_ENCHT_WP";
		case 20:
			return "ITEME_ENCHT_AM";
		case 21:
			return "ITEME_BLESS_ENCHT_WP";
		case 22:
			return "ITEME_BLESS_ENCHT_AM";
		case 23:
			return "ITEME_COUPON";
		case 24:
			return "ITEME_ELIXIR";
		case 25:
			return "ITEME_ENCHT_ATTR";
		case 26:
			return "ITEME_ENCHT_ATTR_CURSED";
		case 27:
			return "ITEME_BOLT";
		case 28:
			return "ITEME_ENCHT_ATTR_INC_PROP_ENCHT_WP";
		case 29:
			return "ITEME_ENCHT_ATTR_INC_PROP_ENCHT_AM";
		case 30:
			return "ITEME_ENCHT_ATTR_CRYSTAL_ENCHANT_AM";
		case 31:
			return "ITEME_ENCHT_ATTR_CRYSTAL_ENCHANT_WP";
		case 32:
			return "ITEME_ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_AM";
		case 33:
			return "ITEME_ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_WP";
		case 34:
			return "ITEME_ENCHT_ATTR_RUNE";
		case 35:
			return "ITEME_ENCHT_ATTRT_RUNE_SELECT";
		case 36:
			return "ITEME_TELEPORTBOOKMARK";
		case 37:
			return "ITEME_CHANGE_ATTR";
		case 38:
			return "ITEME_SOULSHOT";
		case 39:
			return "ITEME_SHAPE_SHIFTING_WP";
		case 40:
			return "ITEME_BLESS_SHAPE_SHIFTING_WP";
		case 41:
			return "ITEME_SHAPE_SHIFTING_WP_FIXED";
		case 42:
			return "ITEME_SHAPE_SHIFTING_AM";
		case 43:
			return "ITEME_BLESS_SHAPE_SHIFTING_AM";
		case 44:
			return "ITEME_SHAPE_SHIFTING_AM_FIXED";
		case 45:
			return "ITEME_SHAPE_SHIFTING_HAIRACC";
		case 46:
			return "ITEME_BLESS_SHAPE_SHIFTING_HAIRACC";
		case 47:
			return "ITEME_SHAPE_SHIFTING_HAIRACC_FIXED";
		case 48:
			return "ITEME_RESTORE_SHAPE_SHIFTING_WP";
		case 49:
			return "ITEME_RESTORE_SHAPE_SHIFTING_AM";
		case 50:
			return "ITEME_RESTORE_SHAPE_SHIFTING_HAIRACC";
		case 51:
			return "ITEME_RESTORE_SHAPE_SHIFTING_ALLITEM";
		case 52:
			return "ITEME_BLESS_INC_PROP_ENCHT_WP";
		case 53:
			return "ITEME_BLESS_INC_PROP_ENCHT_AM";
		case 54:
			return "ITEME_CARD_EVENT";
		case 55:
			return "ITEME_SHAPE_SHIFTING_ALLITEM_FIXED";
		case 56:
			return "ITEME_MULTI_ENCHT_WP";
		case 57:
			return "ITEME_MULTI_ENCHT_AM";
		case 58:
			return "ITEME_MULTI_INC_PROB_ENCHT_WP";
		case 59:
			return "ITEME_MULTI_INC_PROB_ENCHT_AM";
		case 60:
			return "ITEME_ENSOUL_STONE";
		case 61:
			return "ITEME_NICK_COLOR_OLD";
		case 62:
			return "ITEME_NICK_COLOR_NEW";
		case 63:
			return "ITEME_ENCHT_AG";
		case 64:
			return "ITEME_BLESS_ENCHT_AG";
		case 65:
			return "ITEME_MULTI_ENCHT_AG";
		case 66:
			return "ITEME_ANCIENT_CRYSTAL_ENCHANT_AG";
		case 67:
			return "ITEME_INC_PROP_ENCHT_AG";
		case 68:
			return "ITEME_BLESS_INC_PROP_ENCHT_AG";
		case 69:
			return "ITEME_MULTI_INC_PROB_ENCHT_AG";
		case 70:
			return "ITEME_LOCK_ITEM";
		case 71:
			return "ITEME_UNLOCK_ITEM";
		case 72:
			return "ITEME_BULLET";
		default:
			return "아이템 타입이 없습니다.";  // EN: there is no item type.
	}
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	if((ListCtrlID == "itemListCtrl"))
	{
		OnGetItemBtnClick();
	}
	return;
}

function OnInitBtnClick()
{
	FindAllItem("Init");
	addInfoEditBox.SetString("");
	searchEditBox.SetString("");
	return;
}

function FindAllItem(string a_Param)
{
	itemListCtrl.DeleteAllItem();
	if((a_Param == "Init"))
	{
		return;
	}
	searchItemID = int(a_Param);
	if((IsOnlyNumber(a_Param) && (searchItemID > 0)))
	{
		cID.ClassID = searchItemID;
		if(Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cID, tmItemInfo))
		{
			AddItem(tmItemInfo);
			return;
		}
	}
	searchItemID = 0;
	SearchString = a_Param;
	cID = Class'NWindow.UIDATA_ITEM'.static.GetFirstID();
	searchItemID = 0;
	useTick = true;
	Me.EnableTick();
	return;
}

function int FindMatchString(string modifiedString, string a_Param)
{
	local string delim;

	delim = " ";
	if(StringMatching(modifiedString, a_Param, delim))
	{
		return 1;
	}
	else
	{
		return -1;
	}
	return 1;
}

function bool CanBless(ItemInfo Info)
{
	return (Info.EnchantBlessGroupID > 0);
}

function bool isEnableEnchant(ItemInfo Info)
{
	switch(Info.ItemType)
	{
		case 0:
		case 1:
		case 2:
			return true;
		default:
			return false;
	}
}

function bool compareSubType(ItemInfo Info)
{
	local bool isTotal, isTotal2, Condition, condition2;
	local int Reserved, reserved2;

	isTotal = (ItemOptionComboBox.GetSelectedNum() == (ItemOptionComboBox.GetNumOfItems() - 1));
	isTotal2 = (ItemOption2ComboBox.GetSelectedNum() == (ItemOption2ComboBox.GetNumOfItems() - 1));
	Reserved = ItemOptionComboBox.GetReserved(ItemOptionComboBox.GetSelectedNum());
	reserved2 = ItemOption2ComboBox.GetReserved(ItemOption2ComboBox.GetSelectedNum());
	switch(Info.ItemType)
	{
		case 0:
			Condition = (Reserved == Info.WeaponType);
			condition2 = (ItemOption2ComboBox.GetString(ItemOption2ComboBox.GetSelectedNum()) == GetSlotTypeString(Info.ItemType, Info.SlotBitType, Info.WeaponType));
			break;
		case 1:
			Condition = (ItemOptionComboBox.GetString(ItemOptionComboBox.GetSelectedNum()) == GetSlotTypeString(Info.ItemType, Info.SlotBitType, Info.ArmorType));
			condition2 = (reserved2 == Info.ArmorType);
			break;
		case 2:
			Condition = (INT64(Reserved) == Info.SlotBitType);
			condition2 = true;
			break;
		case 5:
			Condition = (Reserved == int(byte(Info.EtcItemType)));
			condition2 = true;
			break;
		default:
			return true;
			break;
	}
	return ((isTotal || Condition) && (isTotal2 || condition2));
}

function setWeaponOptionComboBox(ComboBoxHandle comboBox)
{
	local int i;
	local string comboBoxString;

	i = 0;
	while((i < 100))
	{
		comboBoxString = GetWeaponTypeString(i);
		chkNAddString(comboBoxString, comboBox, i);
		i++;
	}
	return;
}

function setArmorOptionComboBox(ComboBoxHandle comboBox)
{
	setSlotTypeStringByItemType(1, comboBox);
	return;
}

function setAccessaryComboBox(ComboBoxHandle comboBox)
{
	setSlotTypeStringByItemType(2, comboBox);
	return;
}

function setSlotTypeStringByItemType(int ItemType, ComboBoxHandle comboBox)
{
	local int i, k;
	local string comboBoxString;

	i = 0;
	while((i < 100))
	{
		k = 0;
		while((k < SlotBitType.Length))
		{
			comboBoxString = GetSlotTypeString(ItemType, INT64(SlotBitType[k]), i);
			chkNAddString(comboBoxString, comboBox, SlotBitType[k]);
			k++;
		}
		i++;
	}
	return;
}

function setEtcitemComboBox(ComboBoxHandle comboBox)
{
	local int i;

	chkNAddString("NONE", comboBox, i++);
	chkNAddString("SCROLL", comboBox, i++);
	chkNAddString("ARROW", comboBox, i++);
	chkNAddString("POTION", comboBox, i++);
	chkNAddString("SPELLBOOK", comboBox, i++);
	chkNAddString("RECIPE", comboBox, i++);
	chkNAddString("MATERIAL", comboBox, i++);
	chkNAddString("PET_COLLAR", comboBox, i++);
	chkNAddString("CASTLE_GUARD", comboBox, i++);
	chkNAddString("DYE", comboBox, i++);
	chkNAddString("SEED", comboBox, i++);
	chkNAddString("SEED2", comboBox, i++);
	chkNAddString("HARVEST", comboBox, i++);
	chkNAddString("LOTTO", comboBox, i++);
	chkNAddString("RACE_TICKET", comboBox, i++);
	chkNAddString("TICKET_OF_LORD", comboBox, i++);
	chkNAddString("LURE", comboBox, i++);
	chkNAddString("CROP", comboBox, i++);
	chkNAddString("MATURECROP", comboBox, i++);
	chkNAddString("ENCHT_WP", comboBox, i++);
	chkNAddString("ENCHT_AM", comboBox, i++);
	chkNAddString("BLESS_ENCHT_WP", comboBox, i++);
	chkNAddString("BLESS_ENCHT_AM", comboBox, i++);
	chkNAddString("COUPON", comboBox, i++);
	chkNAddString("ELIXIR", comboBox, i++);
	chkNAddString("ENCHT_ATTR", comboBox, i++);
	chkNAddString("ENCHT_ATTR_CURSED", comboBox, i++);
	chkNAddString("BOLT", comboBox, i++);
	chkNAddString("ENCHT_ATTR_INC_PROP_ENCHT_WP", comboBox, i++);
	chkNAddString("ENCHT_ATTR_INC_PROP_ENCHT_AM", comboBox, i++);
	chkNAddString("ENCHT_ATTR_CRYSTAL_ENCHANT_AM", comboBox, i++);
	chkNAddString("ENCHT_ATTR_CRYSTAL_ENCHANT_WP", comboBox, i++);
	chkNAddString("ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_AM", comboBox, i++);
	chkNAddString("ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_WP", comboBox, i++);
	chkNAddString("ENCHT_ATTR_RUNE", comboBox, i++);
	chkNAddString("ENCHT_ATTRT_RUNE_SELECT", comboBox, i++);
	chkNAddString("TELEPORTBOOKMARK", comboBox, i++);
	chkNAddString("CHANGE_ATTR", comboBox, i++);
	chkNAddString("SOULSHOT", comboBox, i++);
	chkNAddString("SHAPE_SHIFTING_WP", comboBox, i++);
	chkNAddString("BLESS_SHAPE_SHIFTING_WP", comboBox, i++);
	chkNAddString("SHAPE_SHIFTING_WP_FIXED", comboBox, i++);
	chkNAddString("SHAPE_SHIFTING_AM", comboBox, i++);
	chkNAddString("BLESS_SHAPE_SHIFTING_AM", comboBox, i++);
	chkNAddString("SHAPE_SHIFTING_AM_FIXED", comboBox, i++);
	chkNAddString("SHAPE_SHIFTING_HAIRACC", comboBox, i++);
	chkNAddString("BLESS_SHAPE_SHIFTING_HAIRACC", comboBox, i++);
	chkNAddString("SHAPE_SHIFTING_HAIRACC_FIXED", comboBox, i++);
	chkNAddString("RESTORE_SHAPE_SHIFTING_WP", comboBox, i++);
	chkNAddString("RESTORE_SHAPE_SHIFTING_AM", comboBox, i++);
	chkNAddString("RESTORE_SHAPE_SHIFTING_HAIRACC", comboBox, i++);
	chkNAddString("RESTORE_SHAPE_SHIFTING_ALLITEM", comboBox, i++);
	chkNAddString("BLESS_INC_PROP_ENCHT_WP", comboBox, i++);
	chkNAddString("BLESS_INC_PROP_ENCHT_AM", comboBox, i++);
	chkNAddString("CARD_EVENT", comboBox, i++);
	chkNAddString("SHAPE_SHIFTING_ALLITEM_FIXED", comboBox, i++);
	chkNAddString("MULTI_ENCHT_WP", comboBox, i++);
	chkNAddString("MULTI_ENCHT_AM", comboBox, i++);
	chkNAddString("MULTI_INC_PROB_ENCHT_WP", comboBox, i++);
	chkNAddString("MULTI_INC_PROB_ENCHT_AM", comboBox, i++);
	chkNAddString("ENSOUL_STONE", comboBox, i++);
	return;
}

function setOptionComboBoxString(int SelectedID)
{
	ItemOptionComboBox.Clear();
	switch(SelectedID)
	{
		case 0:
			setWeaponOptionComboBox(ItemOptionComboBox);
			break;
		case 1:
			setArmorOptionComboBox(ItemOptionComboBox);
			break;
		case 2:
			setAccessaryComboBox(ItemOptionComboBox);
			break;
		case 3:
			break;
		case 4:
			break;
		case 5:
			setEtcitemComboBox(ItemOptionComboBox);
			break;
		default:
			break;
	}
	ItemOptionComboBox.AddString("Total");
	ItemOptionComboBox.SetSelectedNum((ItemOptionComboBox.GetNumOfItems() - 1));
	return;
}

function setWeaponOption2ComboBox(ComboBoxHandle comboBox)
{
	setSlotTypeStringByItemType(0, comboBox);
	return;
}

function setArmorOption2ComboBox(ComboBoxHandle comboBox)
{
	comboBox.AddStringWithReserved(GetSystemString(441), 0);
	comboBox.AddStringWithReserved(GetSystemString(245), 1);
	comboBox.AddStringWithReserved(GetSystemString(246), 2);
	comboBox.AddStringWithReserved(GetSystemString(244), 3);
	comboBox.AddStringWithReserved(GetSystemString(1987), 4);
	return;
}

function setOptionComboBox2String(int SelectedID)
{
	ItemOption2ComboBox.Clear();
	switch(SelectedID)
	{
		case 0:
			setWeaponOption2ComboBox(ItemOption2ComboBox);
			break;
		case 1:
			setArmorOption2ComboBox(ItemOption2ComboBox);
			break;
		case 2:
		case 3:
		case 4:
		case 5:
			break;
		default:
			break;
	}
	ItemOption2ComboBox.AddString("Total");
	ItemOption2ComboBox.SetSelectedNum((ItemOption2ComboBox.GetNumOfItems() - 1));
	return;
}

function chkNAddString(string tmpString, ComboBoxHandle tmpCombox, int reversed)
{
	local int i;

	if((tmpString == ""))
	{
		return;
	}
	i = 0;
	while((i < tmpCombox.GetNumOfItems()))
	{
		if((tmpCombox.GetString(i) == tmpString))
		{
			return;
		}
		i++;
	}
	tmpCombox.AddStringWithReserved(tmpString, reversed);
	return;
}

function tickProcess()
{
	local string AdditionalName;
	local int itemNameClass;

	if(!IsValidItemID(cID))
	{
		Me.DisableTick();
		useTick = false;
		setWindowTitleByString("UIPowerTools [ ItemTool ]");
		return;
	}
	cID = Class'NWindow.UIDATA_ITEM'.static.GetNextID();
	fullNameString = Class'NWindow.UIDATA_ITEM'.static.GetItemName(cID);
	itemNameClass = Class'NWindow.UIDATA_ITEM'.static.GetItemNameClass(cID);
	AdditionalName = Class'NWindow.UIDATA_ITEM'.static.GetItemAdditionalName(cID);
	if((itemNameClass == 0))
	{
		fullNameString = MakeFullSystemMsg(GetSystemMessage(2332), fullNameString);
	}
	else if((itemNameClass == 2))
	{
		fullNameString = MakeFullSystemMsg(GetSystemMessage(2331), fullNameString);
	}
	if((Len(AdditionalName) > 0))
	{
		fullNameString = (fullNameString $ AdditionalName);
	}
	modifiedString = Substitute(fullNameString, " ", "", false);
	if(((FindMatchString(modifiedString, SearchString) != -1) || (SearchString == "")))
	{
		ItemCrystalType = Class'NWindow.UIDATA_ITEM'.static.GetItemCrystalType(cID);
		if(((ItemGradeComboBox.GetSelectedNum() == ItemCrystalType) || (ItemGradeComboBox.GetSelectedNum() == 13)))
		{
			Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cID, tmItemInfo);
			if(ChkBoxBless.IsChecked())
			{
				if(!CanBless(tmItemInfo))
				{
					searchItemID++;
					return;
				}
			}
			filterItemType = ItemTypeComboBox.GetSelectedNum();
			if((filterItemType == tmItemInfo.ItemType))
			{
				if(compareSubType(tmItemInfo))
				{
					AddItem(tmItemInfo);
				}
			}
			else if((filterItemType == 7))
			{
				if(((tmItemInfo.ItemType == 0) || (tmItemInfo.ItemType == 1)))
				{
					if(compareSubType(tmItemInfo))
					{
						AddItem(tmItemInfo);
					}
				}
			}
			else if((filterItemType == 6))
			{
				if(compareSubType(tmItemInfo))
				{
					AddItem(tmItemInfo);
				}
			}
		}
		searchItemID++;
	}
	return;
}

function OnComboBoxItemSelected(string strID, int IndexID)
{
	switch(strID)
	{
		case "ItemTypeComboBox":
			setOptionComboBoxString(IndexID);
			setOptionComboBox2String(IndexID);
			if((ItemOptionComboBox.GetNumOfItems() > 1))
			{
				ItemOptionComboBox.ShowWindow();
			}
			else
			{
				ItemOptionComboBox.HideWindow();
			}
			if((ItemOption2ComboBox.GetNumOfItems() > 1))
			{
				ItemOptionComboBox.SetWindowSize(107, 19);
				ItemOption2ComboBox.ShowWindow();
			}
			else
			{
				ItemOptionComboBox.SetWindowSize(180, 19);
				ItemOption2ComboBox.HideWindow();
			}
			break;
		default:
			break;
	}
	return;
}

function OnTick()
{
	local int i;

	if((switchBool == false))
	{
		setWindowTitleByString("UIPowerTools [ ItemTool ]  - Searching.. ");
		switchBool = true;
	}
	else
	{
		setWindowTitleByString("UIPowerTools [ ItemTool ]  + Searching.... ");
		switchBool = false;
	}
	i = 0;
	while((i < 100))
	{
		if(!useTick)
		{
			break;
		}
		tickProcess();
		i++;
	}
	return;
}

function AddItem(ItemInfo Info)
{
	local LVDataRecord Record;
	local string param, AdditionalName, fullNameString, iconStr;
	local int itemNameClass;
	local EnchantValidateUIData EnchantData;

	Class'NWindow.UIDATA_ITEM'.static.GetEnchantValidateValue(Info.Id.ClassID, Info.Enchanted, EnchantData);
	fullNameString = Info.Name;
	itemNameClass = Class'NWindow.UIDATA_ITEM'.static.GetItemNameClass(Info.Id);
	AdditionalName = Class'NWindow.UIDATA_ITEM'.static.GetItemAdditionalName(Info.Id);
	if((itemNameClass == 0))
	{
		fullNameString = MakeFullSystemMsg(GetSystemMessage(2332), fullNameString);
	}
	else if((itemNameClass == 2))
	{
		fullNameString = MakeFullSystemMsg(GetSystemMessage(2331), fullNameString);
	}
	if((Len(AdditionalName) > 0))
	{
		fullNameString = (((fullNameString $ "(") $ AdditionalName) $ ")");
	}
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfoString(Info.Id.ClassID, param);
	Record.szReserved = param;
	Record.nReserved1 = INT64(Info.Id.ClassID);
	Record.LVDataList.Length = 5;
	Record.LVDataList[0].szData = fullNameString;
	if(ChkBox64.IsChecked())
	{
		iconStr = Caps(Info.IconName);
		super.ReplaceText(iconStr, "ICON.", "ICON2.");
		Record.LVDataList[0].hasIcon = true;
		Record.LVDataList[0].nTextureWidth = 32;
		Record.LVDataList[0].nTextureHeight = 32;
		Record.LVDataList[0].nTextureU = 64;
		Record.LVDataList[0].nTextureV = 64;
		Record.LVDataList[0].szTexture = iconStr;
		Record.LVDataList[0].IconPosX = 10;
		Record.LVDataList[0].FirstLineOffsetX = 6;
	}
	else
	{
		Record.LVDataList[0].hasIcon = true;
		Record.LVDataList[0].nTextureWidth = 32;
		Record.LVDataList[0].nTextureHeight = 32;
		Record.LVDataList[0].nTextureU = 32;
		Record.LVDataList[0].nTextureV = 32;
		Record.LVDataList[0].szTexture = Info.IconName;
		Record.LVDataList[0].IconPosX = 10;
		Record.LVDataList[0].FirstLineOffsetX = 6;
	}
	Record.LVDataList[0].iconBackTexName = "l2ui_ct1.ItemWindow_DF_SlotBox_Default";
	Record.LVDataList[0].backTexOffsetXFromIconPosX = -2;
	Record.LVDataList[0].backTexOffsetYFromIconPosY = -1;
	Record.LVDataList[0].backTexWidth = 36;
	Record.LVDataList[0].backTexHeight = 36;
	Record.LVDataList[0].backTexUL = 36;
	Record.LVDataList[0].backTexVL = 36;
	if((Info.IconPanel != ""))
	{
		iconPanelTotalCount++;
	}
	if(ChkBox64.IsChecked())
	{
		iconStr = Caps(Info.IconPanel);
		super.ReplaceText(iconStr, "ICON.", "ICON2.");
		Record.LVDataList[0].iconPanelName = iconStr;
		Record.LVDataList[0].panelOffsetXFromIconPosX = 0;
		Record.LVDataList[0].panelOffsetYFromIconPosY = 0;
		Record.LVDataList[0].panelWidth = 32;
		Record.LVDataList[0].panelHeight = 32;
		Record.LVDataList[0].panelUL = 64;
		Record.LVDataList[0].panelVL = 64;
	}
	else
	{
		Record.LVDataList[0].iconPanelName = Info.IconPanel;
		Record.LVDataList[0].panelOffsetXFromIconPosX = 0;
		Record.LVDataList[0].panelOffsetYFromIconPosY = 0;
		Record.LVDataList[0].panelWidth = 32;
		Record.LVDataList[0].panelHeight = 32;
		Record.LVDataList[0].panelUL = 32;
		Record.LVDataList[0].panelVL = 32;
	}
	if((((Info.ItemType == 0) || (Info.ItemType == 2)) || (Info.ItemType == 1)))
	{
		Record.LVDataList[1].szData = util.getItemGradeSystemString(Info.CrystalType);
	}
	else if((Info.CrystalType != 0))
	{
		Record.LVDataList[1].szData = util.getItemGradeSystemString(Info.CrystalType);
	}
	else
	{
		Record.LVDataList[1].szData = "-";
	}
	Record.LVDataList[1].HiddenStringForSorting = util.makeZeroString(6, INT64(Info.CrystalType));
	Record.LVDataList[1].textAlignment = TA_Left;
	switch(Info.ItemType)
	{
		case 0:
			itemListCtrl.SetColumnString(2, 55);
			itemListCtrl.SetColumnString(3, 98);
			Record.LVDataList[2].szData = string((Info.pAttack + EnchantData.EnchantValue[2]));
			Record.LVDataList[3].szData = string((Info.mAttack + EnchantData.EnchantValue[3]));
			break;
		case 1:
			itemListCtrl.SetColumnString(2, 54);
			itemListCtrl.SetColumnString(3, 99);
			Record.LVDataList[2].szData = string(int((Info.pDefense + Info.ShieldDefense)));
			Record.LVDataList[3].szData = string(int(Info.mDefense));
			break;
		case 2:
			itemListCtrl.SetColumnString(2, 54);
			itemListCtrl.SetColumnString(3, 99);
			Record.LVDataList[2].szData = string(int((Info.pDefense + Info.ShieldDefense)));
			Record.LVDataList[3].szData = string(int(Info.mDefense));
			break;
		case 5:
			Record.LVDataList[2].szData = string(0);
			Record.LVDataList[3].szData = string(0);
			break;
		default:
			break;
	}
	Record.LVDataList[2].textAlignment = TA_Right;
	Record.LVDataList[3].textAlignment = TA_Right;
	Record.LVDataList[4].szData = string(Info.Id.ClassID);
	Record.LVDataList[4].textAlignment = TA_Left;
	itemListCtrl.InsertRecord(Record);
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("UIItemToolWnd").HideWindow();
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	if(searchEditBox.IsFocused())
	{
		if((int(nKey) == 13))
		{
			if((trim(searchEditBox.GetString()) != ""))
			{
				OnsearchItemBtnClick();
			}
		}
	}
	else if(Create2EditBox.IsFocused())
	{
		OnClickListCtrlRecord("itemListCtrl");
	}
	return false;
}
