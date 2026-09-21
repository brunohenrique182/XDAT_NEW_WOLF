class ItemAttributeChangeWnd extends UICommonAPI;

const ATTRIBUTE_FIRE = 0;
const ATTRIBUTE_WATER = 1;
const ATTRIBUTE_WIND = 2;
const ATTRIBUTE_EARTH = 3;
const ATTRIBUTE_HOLY = 4;
const ATTRIBUTE_UNHOLY = 5;
const TOTALLEN = 6;
const DIALOGID_NotSelect = 7010;
const DIALOGID_Change = 7020;

var array<int> arrSystemString;
var array<int> AttackAttLevel;
var array<int> AttackAttCurrValue;
var array<int> AttackAttMaxValue;
var WindowHandle Me;
var TextBoxHandle InventoryItemListTitle;
var ItemWindowHandle InventoryItemList;
var TextureHandle InventoryItemListSlotBg;
var TextureHandle InventoryItemListBg;
var TextBoxHandle AttributeItemTitle;
var ItemWindowHandle AttributeItem;
var NameCtrlHandle AttributeItemName;
var TextBoxHandle AttributeItemtype;
var TreeHandle AttributeIteminfo;
var TextureHandle AttributeItemSlotBg;
var TextureHandle AttributeIteminfoLine;
var TextureHandle AttributeItemBg;
var TextBoxHandle ItemAttributeInfoTitle;
var TextBoxHandle ItemAttribute;
var BarHandle ItemAttributeGage;
var TextureHandle ItemAttributeInfoBg;
var TextBoxHandle AttributeListTitle;
var TextBoxHandle FireAttributeTitle;
var TextBoxHandle WaterAttributeTitle;
var TextBoxHandle WindAttributeTitle;
var TextBoxHandle EarthAttributeTitle;
var TextBoxHandle DivineAttributeTitle;
var TextBoxHandle DarkAttributeTitle;
var ButtonHandle FireAttributeBtn;
var ButtonHandle WaterAttributeBtn;
var ButtonHandle WindAttributeBtn;
var ButtonHandle EarthAttributeBtn;
var ButtonHandle DivineAttributeBtn;
var ButtonHandle DarkAttributeBtn;
var TextureHandle AttributeListBg;
var ButtonHandle changeBtn;
var ButtonHandle CancelBtn;
var WindowHandle disableWnd;
var int GroupID;
var int indexItemList;
var int SelectNum;
var int nItemAttribute;
var ItemInfo infItem;
var L2Util util;
var int saveBeforeIndex;
var int attr_fire;
var int attr_water;
var int attr_wind;
var int attr_earth;
var int attr_holy;
var int attr_unholy;

function OnRegisterEvent()
{
	RegisterEvent(5730);
	RegisterEvent(5731);
	RegisterEvent(5732);
	RegisterEvent(5733);
	RegisterEvent(1710);
	RegisterEvent(1720);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("ItemAttributeChangeWnd");
	InventoryItemList = GetItemWindowHandle("ItemAttributeChangeWnd.InventoryItemList");
	AttributeItem = GetItemWindowHandle("ItemAttributeChangeWnd.AttributeItem");
	AttributeItemName = GetNameCtrlHandle("ItemAttributeChangeWnd.AttributeItemName");
	AttributeItemtype = GetTextBoxHandle("ItemAttributeChangeWnd.AttributeItemtype");
	AttributeIteminfo = GetTreeHandle("ItemAttributeChangeWnd.AttributeIteminfo");
	ItemAttribute = GetTextBoxHandle("ItemAttributeChangeWnd.ItemAttribute");
	ItemAttributeGage = GetBarHandle("ItemAttributeChangeWnd.ItemAttributeGage");
	FireAttributeTitle = GetTextBoxHandle("ItemAttributeChangeWnd.FireAttributeTitle");
	WaterAttributeTitle = GetTextBoxHandle("ItemAttributeChangeWnd.WaterAttributeTitle");
	WindAttributeTitle = GetTextBoxHandle("ItemAttributeChangeWnd.WindAttributeTitle");
	EarthAttributeTitle = GetTextBoxHandle("ItemAttributeChangeWnd.EarthAttributeTitle");
	DivineAttributeTitle = GetTextBoxHandle("ItemAttributeChangeWnd.DivineAttributeTitle");
	DarkAttributeTitle = GetTextBoxHandle("ItemAttributeChangeWnd.DarkAttributeTitle");
	FireAttributeBtn = GetButtonHandle("ItemAttributeChangeWnd.FireAttributeBtn");
	WaterAttributeBtn = GetButtonHandle("ItemAttributeChangeWnd.WaterAttributeBtn");
	WindAttributeBtn = GetButtonHandle("ItemAttributeChangeWnd.WindAttributeBtn");
	EarthAttributeBtn = GetButtonHandle("ItemAttributeChangeWnd.EarthAttributeBtn");
	DivineAttributeBtn = GetButtonHandle("ItemAttributeChangeWnd.DivineAttributeBtn");
	DarkAttributeBtn = GetButtonHandle("ItemAttributeChangeWnd.DarkAttributeBtn");
	AttributeListBg = GetTextureHandle("ItemAttributeChangeWnd.AttributeListBg");
	changeBtn = GetButtonHandle("ItemAttributeChangeWnd.ChangeBtn");
	CancelBtn = GetButtonHandle("ItemAttributeChangeWnd.CancelBtn");
	disableWnd = GetWindowHandle("ItemAttributeChangeWnd.DisableWnd");
	return;
}

function Load()
{
	arrSystemString.Length = 6;
	arrSystemString[0] = 1622;
	arrSystemString[1] = 1623;
	arrSystemString[2] = 1624;
	arrSystemString[3] = 1625;
	arrSystemString[4] = 1626;
	arrSystemString[5] = 1627;
	util = L2Util(GetScript("L2Util"));
	return;
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)), "InventoryWnd");
	return;
}

function OnHide()
{
	DisableCurrentWindow(false);
	if(DialogIsMine())
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		DialogHide();
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	local ItemInfo Info;
	local int Result;

	if((Event_ID == 5730))
	{
		ParseInt(param, "groupID", GroupID);
		setClear();
	}
	else if((Event_ID == 5731))
	{
		if(!Me.IsShowWindow())
		{
			Me.ShowWindow();
			Me.SetFocus();
		}
		ParamToItemInfo(param, Info);
		InventoryItemList.AddItem(Info);
		indexItemList++;
		InventoryItemList.SetSelectedNum(0);
		OnClickItem("InventoryItemList", 0);
	}
	else if((Event_ID == 5732))
	{
		ParseInt(param, "attr_fire", attr_fire);
		ParseInt(param, "attr_water", attr_water);
		ParseInt(param, "attr_wind", attr_wind);
		ParseInt(param, "attr_earth", attr_earth);
		ParseInt(param, "attr_holy", attr_holy);
		ParseInt(param, "attr_unholy", attr_unholy);
		setDefultButton();
	}
	else if((Event_ID == 5733))
	{
		ParseInt(param, "result", Result);
		if((Result == 1))
		{
			Me.HideWindow();
		}
		else
		{
			Me.HideWindow();
		}
	}
	else if((Event_ID == 1710))
	{
		HandleDialogOK();
	}
	else if((Event_ID == 1720))
	{
		DisableCurrentWindow(false);
	}
	return;
}

function HandleDialogOK()
{
	if(DialogIsMine())
	{
		if((DialogGetID() == 7020))
		{
			RequestChangeAttributeItem(GroupID, infItem.Id.ServerID, SelectNum);
		}
		else if((DialogGetID() == 7010))
		{
			DisableCurrentWindow(false);
		}
	}
	return;
}

function setClear()
{
	InventoryItemList.Clear();
	setDefultButton();
	indexItemList = 0;
	SelectNum = -1;
	saveBeforeIndex = -1;
	DisableCurrentWindow(false);
	return;
}

function OnClickButton(string Str)
{
	switch(Str)
	{
		case "FireAttributeBtn":
			OnFireAttributeBtnClick();
			break;
		case "WaterAttributeBtn":
			OnWaterAttributeBtnClick();
			break;
		case "WindAttributeBtn":
			OnWindAttributeBtnClick();
			break;
		case "EarthAttributeBtn":
			OnEarthAttributeBtnClick();
			break;
		case "DivineAttributeBtn":
			OnDivineAttributeBtnClick();
			break;
		case "DarkAttributeBtn":
			OnDarkAttributeBtnClick();
			break;
		case "ChangeBtn":
			DisableCurrentWindow(true);
			OnChangeBtnClick();
			break;
		case "CancelBtn":
			DisableCurrentWindow(false);
			OnHideMeWindow();
			break;
		default:
			break;
	}
	return;
}

function DisableCurrentWindow(bool bFlag)
{
	if(bFlag)
	{
		disableWnd.EnableWindow();
		disableWnd.ShowWindow();
	}
	else
	{
		disableWnd.DisableWindow();
		disableWnd.HideWindow();
	}
	return;
}

function OnClickItem(string strID, int Index)
{
	if(((strID == "InventoryItemList") && (Index > -1)))
	{
		if((saveBeforeIndex == Index))
		{
			return;
		}
		if(InventoryItemList.GetItem(Index, infItem))
		{
			if((infItem.Id.ClassID > 0))
			{
				setDefultButton();
				SelectNum = -1;
				AttributeItem.Clear();
				AttributeItem.AddItem(infItem);
				AttributeItemName.SetNameUsingItem(infItem, NCT_Item, TA_Left);
				AttributeItemtype.SetText(((GetWeaponTypeString(infItem.WeaponType) $ " / ") $ GetSlotTypeString(infItem.ItemType, infItem.SlotBitType, infItem.ArmorType)));
				setAttributeGage(infItem);
				SelectChangeAttributeItem(GroupID, infItem.Id.ServerID);
				setAttributeIteminfo();
				saveBeforeIndex = Index;
			}
		}
	}
	return;
}

function setAttributeGage(ItemInfo item)
{
	if((item.AttackAttributeValue > 0))
	{
		SetAttackAttribute(item.AttackAttributeValue, 0);
		SetAttackAttribute(item.AttackAttributeValue, 1);
		SetAttackAttribute(item.AttackAttributeValue, 2);
		SetAttackAttribute(item.AttackAttributeValue, 3);
		SetAttackAttribute(item.AttackAttributeValue, 4);
		SetAttackAttribute(item.AttackAttributeValue, 5);
		nItemAttribute = item.AttackAttributeType;
		switch(item.AttackAttributeType)
		{
			case 0:
				ItemAttribute.SetText((((((((((GetSystemString(1622) $ " Lv ") $ string(AttackAttLevel[0])) $ " (") $ GetSystemString(1622)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")"));
				ItemAttributeGage.SetTexture(0, "L2UI_CT1.Gauge_df_attribute_Fire_Center");
				ItemAttributeGage.SetTexture(1, "L2UI_CT1.Gauge_df_attribute_Fire_Center");
				ItemAttributeGage.SetTexture(2, "L2UI_CT1.Gauge_df_attribute_Fire_Right");
				ItemAttributeGage.SetTexture(3, "L2UI_CT1.Gauge_df_attribute_Fire_Bg_Left");
				ItemAttributeGage.SetTexture(4, "L2UI_CT1.Gauge_df_attribute_Fire_Bg_Center");
				ItemAttributeGage.SetTexture(5, "L2UI_CT1.Gauge_df_attribute_Fire_Bg_Right");
				break;
			case 1:
				ItemAttribute.SetText((((((((((GetSystemString(1623) $ " Lv ") $ string(AttackAttLevel[1])) $ " (") $ GetSystemString(1623)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")"));
				ItemAttributeGage.SetTexture(0, "L2UI_CT1.Gauge_df_attribute_Water_Left");
				ItemAttributeGage.SetTexture(1, "L2UI_CT1.Gauge_df_attribute_Water_Center");
				ItemAttributeGage.SetTexture(2, "L2UI_CT1.Gauge_df_attribute_Water_Right");
				ItemAttributeGage.SetTexture(3, "L2UI_CT1.Gauge_df_attribute_Water_Bg_Left");
				ItemAttributeGage.SetTexture(4, "L2UI_CT1.Gauge_df_attribute_Water_Bg_Center");
				ItemAttributeGage.SetTexture(5, "L2UI_CT1.Gauge_df_attribute_Water_Bg_Right");
				break;
			case 2:
				ItemAttribute.SetText((((((((((GetSystemString(1624) $ " Lv ") $ string(AttackAttLevel[2])) $ " (") $ GetSystemString(1624)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")"));
				ItemAttributeGage.SetTexture(0, "L2UI_CT1.Gauge_df_attribute_Wind_Left");
				ItemAttributeGage.SetTexture(1, "L2UI_CT1.Gauge_df_attribute_Wind_Center");
				ItemAttributeGage.SetTexture(2, "L2UI_CT1.Gauge_df_attribute_Wind_Right");
				ItemAttributeGage.SetTexture(3, "L2UI_CT1.Gauge_df_attribute_Wind_Bg_Left");
				ItemAttributeGage.SetTexture(4, "L2UI_CT1.Gauge_df_attribute_Wind_Bg_Center");
				ItemAttributeGage.SetTexture(5, "L2UI_CT1.Gauge_df_attribute_Wind_Bg_Right");
				break;
			case 3:
				ItemAttribute.SetText((((((((((GetSystemString(1625) $ " Lv ") $ string(AttackAttLevel[3])) $ " (") $ GetSystemString(1625)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")"));
				ItemAttributeGage.SetTexture(0, "L2UI_CT1.Gauge_df_attribute_Earth_Left");
				ItemAttributeGage.SetTexture(1, "L2UI_CT1.Gauge_df_attribute_Earth_Center");
				ItemAttributeGage.SetTexture(2, "L2UI_CT1.Gauge_df_attribute_Earth_Right");
				ItemAttributeGage.SetTexture(3, "L2UI_CT1.Gauge_df_attribute_Earth_Bg_Left");
				ItemAttributeGage.SetTexture(4, "L2UI_CT1.Gauge_df_attribute_Earth_Bg_Center");
				ItemAttributeGage.SetTexture(5, "L2UI_CT1.Gauge_df_attribute_Earth_Bg_Right");
				break;
			case 4:
				ItemAttribute.SetText((((((((((GetSystemString(1626) $ " Lv ") $ string(AttackAttLevel[4])) $ " (") $ GetSystemString(1626)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")"));
				ItemAttributeGage.SetTexture(0, "L2UI_CT1.Gauge_df_attribute_Divine_Left");
				ItemAttributeGage.SetTexture(1, "L2UI_CT1.Gauge_df_attribute_Divine_Center");
				ItemAttributeGage.SetTexture(2, "L2UI_CT1.Gauge_df_attribute_Divine_Right");
				ItemAttributeGage.SetTexture(3, "L2UI_CT1.Gauge_df_attribute_Divine_Bg_Left");
				ItemAttributeGage.SetTexture(4, "L2UI_CT1.Gauge_df_attribute_Divine_Bg_Center");
				ItemAttributeGage.SetTexture(5, "L2UI_CT1.Gauge_df_attribute_Divine_Bg_Right");
				break;
			case 5:
				ItemAttribute.SetText((((((((((GetSystemString(1627) $ " Lv ") $ string(AttackAttLevel[5])) $ " (") $ GetSystemString(1627)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")"));
				ItemAttributeGage.SetTexture(0, "L2UI_CT1.Gauge_df_attribute_Dark_Left");
				ItemAttributeGage.SetTexture(1, "L2UI_CT1.Gauge_df_attribute_Dark_Center");
				ItemAttributeGage.SetTexture(2, "L2UI_CT1.Gauge_df_attribute_Dark_Right");
				ItemAttributeGage.SetTexture(3, "L2UI_CT1.Gauge_df_attribute_Dark_Bg_Left");
				ItemAttributeGage.SetTexture(4, "L2UI_CT1.Gauge_df_attribute_Dark_Bg_Center");
				ItemAttributeGage.SetTexture(5, "L2UI_CT1.Gauge_df_attribute_Darke_Bg_Right");
				break;
			default:
				break;
		}
		ItemAttributeGage.SetValue(AttackAttMaxValue[0], AttackAttCurrValue[0]);
	}
	return;
}

function OnFireAttributeBtnClick()
{
	setDefultButton();
	SelectNum = 0;
	FireAttributeBtn.SetTexture("L2ui_ct1.ItemAttributeChangeWnd_df_FireAttributeBtn_select", "L2ui_ct1.ItemAttributeChangeWnd_df_FireAttributeBtn_select", "L2ui_ct1.ItemAttributeChangeWnd_df_FireAttributeBtn_select");
	return;
}

function OnWaterAttributeBtnClick()
{
	setDefultButton();
	SelectNum = 1;
	WaterAttributeBtn.SetTexture("L2ui_ct1.ItemAttributeChangeWnd_df_WaterAttributeBtn_select", "L2ui_ct1.ItemAttributeChangeWnd_df_WaterAttributeBtn_select", "L2ui_ct1.ItemAttributeChangeWnd_df_WaterAttributeBtn_select");
	return;
}

function OnWindAttributeBtnClick()
{
	setDefultButton();
	SelectNum = 2;
	WindAttributeBtn.SetTexture("L2ui_ct1.ItemAttributeChangeWnd_df_WindAttributeBtn_select", "L2ui_ct1.ItemAttributeChangeWnd_df_WindAttributeBtn_select", "L2ui_ct1.ItemAttributeChangeWnd_df_WindAttributeBtn_select");
	return;
}

function OnEarthAttributeBtnClick()
{
	setDefultButton();
	SelectNum = 3;
	EarthAttributeBtn.SetTexture("L2ui_ct1.ItemAttributeChangeWnd_df_EarthAttributeBtn_select", "L2ui_ct1.ItemAttributeChangeWnd_df_EarthAttributeBtn_select", "L2ui_ct1.ItemAttributeChangeWnd_df_EarthAttributeBtn_select");
	return;
}

function OnDivineAttributeBtnClick()
{
	setDefultButton();
	SelectNum = 4;
	DivineAttributeBtn.SetTexture("L2ui_ct1.ItemAttributeChangeWnd_df_DivineAttributeBtn_select", "L2ui_ct1.ItemAttributeChangeWnd_df_DivineAttributeBtn_select", "L2ui_ct1.ItemAttributeChangeWnd_df_DivineAttributeBtn_select");
	return;
}

function OnDarkAttributeBtnClick()
{
	setDefultButton();
	SelectNum = 5;
	DarkAttributeBtn.SetTexture("L2ui_ct1.ItemAttributeChangeWnd_df_DarkAttributeBtn_select", "L2ui_ct1.ItemAttributeChangeWnd_df_DarkAttributeBtn_select", "L2ui_ct1.ItemAttributeChangeWnd_df_DarkAttributeBtn_select");
	return;
}

function setDefultButton()
{
	if((attr_fire == 1))
	{
		FireAttributeBtn.EnableWindow();
		FireAttributeBtn.SetTexture("L2ui_ct1.ItemAttributeChangeWnd_df_FireAttributeBtn", "L2ui_ct1.ItemAttributeChangeWnd_df_FireAttributeBtn_down", "L2ui_ct1.ItemAttributeChangeWnd_df_FireAttributeBtn_over");
		FireAttributeTitle.SetTextColor(util.BrightWhite);
	}
	else
	{
		FireAttributeBtn.DisableWindow();
		FireAttributeBtn.SetTexture("L2ui_ct1.ItemAttributeChangeWnd_df_FireAttributeBtn_disable", "L2ui_ct1.ItemAttributeChangeWnd_df_FireAttributeBtn_disable", "L2ui_ct1.ItemAttributeChangeWnd_df_FireAttributeBtn_disable");
		FireAttributeTitle.SetTextColor(util.Gray);
	}
	if((attr_water == 1))
	{
		WaterAttributeBtn.EnableWindow();
		WaterAttributeBtn.SetTexture("L2ui_ct1.ItemAttributeChangeWnd_df_WaterAttributeBtn", "L2ui_ct1.ItemAttributeChangeWnd_df_WaterAttributeBtn_down", "L2ui_ct1.ItemAttributeChangeWnd_df_WaterAttributeBtn_over");
		WaterAttributeTitle.SetTextColor(util.BrightWhite);
	}
	else
	{
		WaterAttributeBtn.DisableWindow();
		WaterAttributeBtn.SetTexture("L2ui_ct1.ItemAttributeChangeWnd_df_WaterAttributeBtn_disable", "L2ui_ct1.ItemAttributeChangeWnd_df_WaterAttributeBtn_disable", "L2ui_ct1.ItemAttributeChangeWnd_df_WaterAttributeBtn_disable");
		WaterAttributeTitle.SetTextColor(util.Gray);
	}
	if((attr_wind == 1))
	{
		WindAttributeBtn.EnableWindow();
		WindAttributeBtn.SetTexture("L2ui_ct1.ItemAttributeChangeWnd_df_WindAttributeBtn", "L2ui_ct1.ItemAttributeChangeWnd_df_WindAttributeBtn_down", "L2ui_ct1.ItemAttributeChangeWnd_df_WindAttributeBtn_over");
		WindAttributeTitle.SetTextColor(util.BrightWhite);
	}
	else
	{
		WindAttributeBtn.DisableWindow();
		WindAttributeBtn.SetTexture("L2ui_ct1.ItemAttributeChangeWnd_df_WindAttributeBtn_disable", "L2ui_ct1.ItemAttributeChangeWnd_df_WindAttributeBtn_disable", "L2ui_ct1.ItemAttributeChangeWnd_df_WindAttributeBtn_disable");
		WindAttributeTitle.SetTextColor(util.Gray);
	}
	if((attr_earth == 1))
	{
		EarthAttributeBtn.EnableWindow();
		EarthAttributeBtn.SetTexture("L2ui_ct1.ItemAttributeChangeWnd_df_EarthAttributeBtn", "L2ui_ct1.ItemAttributeChangeWnd_df_EarthAttributeBtn_down", "L2ui_ct1.ItemAttributeChangeWnd_df_EarthAttributeBtn_over");
		EarthAttributeTitle.SetTextColor(util.BrightWhite);
	}
	else
	{
		EarthAttributeBtn.DisableWindow();
		EarthAttributeBtn.SetTexture("L2ui_ct1.ItemAttributeChangeWnd_df_EarthAttributeBtn_disable", "L2ui_ct1.ItemAttributeChangeWnd_df_EarthAttributeBtn_disable", "L2ui_ct1.ItemAttributeChangeWnd_df_EarthAttributeBtn_disable");
		EarthAttributeTitle.SetTextColor(util.Gray);
	}
	if((attr_holy == 1))
	{
		DivineAttributeBtn.EnableWindow();
		DivineAttributeBtn.SetTexture("L2ui_ct1.ItemAttributeChangeWnd_df_DivineAttributeBtn", "L2ui_ct1.ItemAttributeChangeWnd_df_DivineAttributeBtn_down", "L2ui_ct1.ItemAttributeChangeWnd_df_DivineAttributeBtn_over");
		DivineAttributeTitle.SetTextColor(util.BrightWhite);
	}
	else
	{
		DivineAttributeBtn.DisableWindow();
		DivineAttributeBtn.SetTexture("L2ui_ct1.ItemAttributeChangeWnd_df_DivineAttributeBtn_disable", "L2ui_ct1.ItemAttributeChangeWnd_df_DivineAttributeBtn_disable", "L2ui_ct1.ItemAttributeChangeWnd_df_DivineAttributeBtn_disable");
		DivineAttributeTitle.SetTextColor(util.Gray);
	}
	if((attr_unholy == 1))
	{
		DarkAttributeBtn.EnableWindow();
		DarkAttributeBtn.SetTexture("L2ui_ct1.ItemAttributeChangeWnd_df_DarkAttributeBtn", "L2ui_ct1.ItemAttributeChangeWnd_df_DarkAttributeBtn_down", "L2ui_ct1.ItemAttributeChangeWnd_df_DarkAttributeBtn_over");
		DarkAttributeTitle.SetTextColor(util.BrightWhite);
	}
	else
	{
		DarkAttributeBtn.DisableWindow();
		DarkAttributeBtn.SetTexture("L2ui_ct1.ItemAttributeChangeWnd_df_DarkAttributeBtn_disable", "L2ui_ct1.ItemAttributeChangeWnd_df_DarkAttributeBtn_disable", "L2ui_ct1.ItemAttributeChangeWnd_df_DarkAttributeBtn_disable");
		DarkAttributeTitle.SetTextColor(util.Gray);
	}
	return;
}

function OnChangeBtnClick()
{
	local string Str;

	if((SelectNum == -1))
	{
		Class'Interface.UICommonAPI'.static.DialogSetID(7010);
		DialogShow(DialogModalType_Modalless, DialogType_OK, GetSystemMessage(3667));
	}
	else
	{
		Str = MakeFullSystemMsg(GetSystemMessage(3666), infItem.Name, GetSystemString(arrSystemString[nItemAttribute]), GetSystemString(arrSystemString[SelectNum]));
		Class'Interface.UICommonAPI'.static.DialogSetID(7020);
		DialogShow(DialogModalType_Modalless, DialogType_OKCancel, Str);
	}
	return;
}

function OnHideMeWindow()
{
	RequestChangeAttributeCancel();
	Me.HideWindow();
	return;
}

function SetAttackAttribute(int Attvalue, int Type)
{
	if((Attvalue >= 375))
	{
		AttackAttLevel[Type] = 9;
		AttackAttMaxValue[Type] = 75;
		AttackAttCurrValue[Type] = (Attvalue - 375);
	}
	else if((Attvalue >= 325))
	{
		AttackAttLevel[Type] = 8;
		AttackAttMaxValue[Type] = 50;
		AttackAttCurrValue[Type] = (Attvalue - 325);
	}
	else if((Attvalue >= 300))
	{
		AttackAttLevel[Type] = 7;
		AttackAttMaxValue[Type] = 25;
		AttackAttCurrValue[Type] = (Attvalue - 300);
	}
	else if((Attvalue >= 225))
	{
		AttackAttLevel[Type] = 6;
		AttackAttMaxValue[Type] = 75;
		AttackAttCurrValue[Type] = (Attvalue - 225);
	}
	else if((Attvalue >= 175))
	{
		AttackAttLevel[Type] = 5;
		AttackAttMaxValue[Type] = 50;
		AttackAttCurrValue[Type] = (Attvalue - 175);
	}
	else if((Attvalue >= 150))
	{
		AttackAttLevel[Type] = 4;
		AttackAttMaxValue[Type] = 25;
		AttackAttCurrValue[Type] = (Attvalue - 150);
	}
	else if((Attvalue >= 75))
	{
		AttackAttLevel[Type] = 3;
		AttackAttMaxValue[Type] = 75;
		AttackAttCurrValue[Type] = (Attvalue - 75);
	}
	else if((Attvalue >= 25))
	{
		AttackAttLevel[Type] = 2;
		AttackAttMaxValue[Type] = 50;
		AttackAttCurrValue[Type] = (Attvalue - 25);
	}
	else
	{
		AttackAttLevel[Type] = 1;
		AttackAttMaxValue[Type] = 25;
		AttackAttCurrValue[Type] = Attvalue;
	}
	return;
}

function setAttributeIteminfo()
{
	local EnchantValidateUIData EnchantData;
	local string treeName, tempStr;

	treeName = "ItemAttributeChangeWnd.AttributeIteminfo";
	Class'NWindow.UIDATA_ITEM'.static.GetEnchantValidateValue(infItem.Id.ClassID, infItem.Enchanted, EnchantData);
	util.TreeClear(treeName);
	util.TreeInsertRootNode(treeName, "root", "");
	if((EnchantData.PropertyValue[2] != 0.0000000))
	{
		tempStr = string(((infItem.pAttack + EnchantData.EnchantValue[2]) + EnchantData.PropertyValue[2]));
		util.TreeInsertTextNodeItem(treeName, "root", (GetSystemString(94) $ " : "), 0, 0, COLOR_GRAY, true, true);
		util.TreeInsertTextNodeItem(treeName, "root", tempStr, 0, 0, COLOR_GOLD, true);
	}
	else
	{
		tempStr = string((infItem.pAttack + EnchantData.EnchantValue[2]));
		util.TreeInsertTextNodeItem(treeName, "root", (GetSystemString(94) $ " : "), 0, 0, COLOR_GRAY, true, true);
		util.TreeInsertTextNodeItem(treeName, "root", tempStr, 0, 0, COLOR_GOLD, false);
	}
	if((EnchantData.PropertyValue[3] != 0.0000000))
	{
		tempStr = string(((infItem.mAttack + EnchantData.EnchantValue[3]) + EnchantData.PropertyValue[3]));
		util.TreeInsertTextNodeItem(treeName, "root", (GetSystemString(98) $ " : "), 0, 0, COLOR_GRAY, true, true);
		util.TreeInsertTextNodeItem(treeName, "root", tempStr, 0, 0, COLOR_GOLD, false);
	}
	else
	{
		tempStr = string((infItem.mAttack + EnchantData.EnchantValue[3]));
		util.TreeInsertTextNodeItem(treeName, "root", (GetSystemString(98) $ " : "), 0, 0, COLOR_GRAY, true, true);
		util.TreeInsertTextNodeItem(treeName, "root", tempStr, 0, 0, COLOR_GOLD, false);
	}
	tempStr = GetAttackSpeedString(int(infItem.pAttackSpeed));
	util.TreeInsertTextNodeItem(treeName, "root", (GetSystemString(111) $ " : "), 0, 0, COLOR_GRAY, true, true);
	util.TreeInsertTextNodeItem(treeName, "root", tempStr, 0, 0, COLOR_GOLD, false);
	if((infItem.pDefense > 0.0000000))
	{
		tempStr = string(infItem.pDefense);
		util.TreeInsertTextNodeItem(treeName, "root", (GetSystemString(54) $ " : "), 0, 0, COLOR_GRAY, true, true);
		util.TreeInsertTextNodeItem(treeName, "root", tempStr, 0, 0, COLOR_GOLD, false);
	}
	if((infItem.mDefense > 0.0000000))
	{
		tempStr = string(infItem.mDefense);
		util.TreeInsertTextNodeItem(treeName, "root", (GetSystemString(99) $ " : "), 0, 0, COLOR_GRAY, true, true);
		util.TreeInsertTextNodeItem(treeName, "root", tempStr, 0, 0, COLOR_GOLD, false);
	}
	if(((infItem.pHitRate + EnchantData.PropertyValue[7]) != 0.0000000))
	{
		tempStr = string((infItem.pHitRate + EnchantData.PropertyValue[7]));
		util.TreeInsertTextNodeItem(treeName, "root", (GetSystemString(96) $ " : "), 0, 0, COLOR_GRAY, true, true);
		util.TreeInsertTextNodeItem(treeName, "root", tempStr, 0, 0, COLOR_GOLD, false);
	}
	if(((infItem.pCriRate + EnchantData.PropertyValue[9]) > 0.0000000))
	{
		tempStr = string((infItem.pCriRate + EnchantData.PropertyValue[9]));
		util.TreeInsertTextNodeItem(treeName, "root", (GetSystemString(113) $ " : "), 0, 0, COLOR_GRAY, true, true);
		util.TreeInsertTextNodeItem(treeName, "root", tempStr, 0, 0, COLOR_GOLD, false);
	}
	if(((infItem.MoveSpeed + EnchantData.PropertyValue[11]) != 0.0000000))
	{
		tempStr = string((infItem.MoveSpeed + EnchantData.PropertyValue[11]));
		util.TreeInsertTextNodeItem(treeName, "root", (GetSystemString(432) $ " : "), 0, 0, COLOR_GRAY, true, true);
		util.TreeInsertTextNodeItem(treeName, "root", tempStr, 0, 0, COLOR_GOLD, false);
	}
	if((infItem.ShieldDefense > 0.0000000))
	{
		tempStr = string(infItem.ShieldDefense);
		util.TreeInsertTextNodeItem(treeName, "root", (GetSystemString(95) $ " : "), 0, 0, COLOR_GRAY, true, true);
		util.TreeInsertTextNodeItem(treeName, "root", tempStr, 0, 0, COLOR_GOLD, false);
	}
	if((infItem.ShieldDefenseRate > 0.0000000))
	{
		tempStr = string(infItem.ShieldDefenseRate);
		util.TreeInsertTextNodeItem(treeName, "root", (GetSystemString(317) $ " : "), 0, 0, COLOR_GRAY, true, true);
		util.TreeInsertTextNodeItem(treeName, "root", tempStr, 0, 0, COLOR_GOLD, false);
	}
	if(((infItem.pAvoid + EnchantData.PropertyValue[14]) > 0.0000000))
	{
		tempStr = string((infItem.pAvoid + EnchantData.PropertyValue[14]));
		util.TreeInsertTextNodeItem(treeName, "root", (GetSystemString(2361) $ " : "), 0, 0, COLOR_GRAY, true, true);
		util.TreeInsertTextNodeItem(treeName, "root", tempStr, 0, 0, COLOR_GOLD, false);
	}
	if(((infItem.mAvoid + EnchantData.PropertyValue[15]) > 0.0000000))
	{
		tempStr = string((infItem.mAvoid + EnchantData.PropertyValue[15]));
		util.TreeInsertTextNodeItem(treeName, "root", (GetSystemString(2364) $ " : "), 0, 0, COLOR_GRAY, true, true);
		util.TreeInsertTextNodeItem(treeName, "root", tempStr, 0, 0, COLOR_GOLD, false);
	}
	util.TreeInsertTextNodeItem("ItemAttributeChangeWnd.AttributeIteminfo", "root", infItem.Description, 0, 0, COLOR_DESC, false, true);
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	OnHideMeWindow();
	return;
}
