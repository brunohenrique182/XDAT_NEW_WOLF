class EnsoulExtractWnd extends UICommonAPI;

const OFFSET_X_ICON_TEXTURE = 0;
const OFFSET_Y_ICON_TEXTURE = 4;
const OFFSET_Y_SECONDLINE = -14;
const treeName = "EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl";
const ITEMNAME_TOTAL_WIDTH = 240;
const ROOTNAME = "root";

var WindowHandle Me;
var WindowHandle disableWnd;
var TextureHandle EnsoulGroupbox1_Texture;
var TextureHandle EnsoulGroupbox2_Texture;
var TextBoxHandle EnsoulExtractDiscription_TextBox;
var WindowHandle EnsoulExtractProgressWnd;
var ProgressCtrlHandle EnsoulProgressWnd_ProgressBar;
var TextBoxHandle EnsoulProgressWnd_Title_TextBox;
var WindowHandle EnsoulExtractDefaultWnd;
var ButtonHandle EnsoulExtractDefaultWnd_extract1_Button;
var ButtonHandle EnsoulExtractDefaultWnd_extract2_Button;
var ButtonHandle EnsoulExtractDefaultWnd_extract3_Button;
var ButtonHandle EnsoulExtract_Btn;
var TextureHandle EnsoulExtractDefaultWnd_Select1_Texture;
var TextureHandle EnsoulExtractDefaultWnd_Select2_Texture;
var TextureHandle EnsoulExtractDefaultWnd_Groupbox1_Texture;
var TextureHandle EnsoulExtractDefaultWnd_Groupbox2_Texture;
var TextureHandle EnsoulExtractDefaultWnd_Step1_Texture;
var TextureHandle EnsoulExtractDefaultWnd_Step2_Texture;
var TextureHandle EnsoulExtractDefaultWnd_BM_Texture;
var TextureHandle EnsoulExtractDefaultWnd_SlotBg1_Texture;
var TextureHandle EnsoulExtractDefaultWnd_SlotBg2_Texture;
var TextureHandle EnsoulExtractDefaultWnd_SlotBg3_Texture;
var TextureHandle EnsoulExtractDefaultWnd_SlotBg4_Texture;
var TextureHandle EnsoulExtractDefaultWnd_Divider1;
var TextureHandle EnsoulExtractDefaultWnd_Divider2;
var TextureHandle EnsoulExtractDefaultWnd_Divider3;
var TextureHandle EnsoulExtractDefaultWnd_Step1block_Texture;
var TextureHandle EnsoulExtractDefaultWnd_Step2block_Texture;
var TextureHandle EnsoulExtractDefaultWnd_BMblock_Texture;
var ItemWindowHandle EnsoulExtractDefaultWnd_Item1_ItemWnd;
var ItemWindowHandle EnsoulExtractDefaultWnd_Item2_ItemWnd;
var ItemWindowHandle EnsoulExtractDefaultWnd_Item3_ItemWnd;
var ItemWindowHandle EnsoulExtractDefaultWnd_ItemBM_ItemWnd;
var TextBoxHandle EnsoulExtractDefaultWnd_TitleWeapon_TextBox;
var TextBoxHandle EnsoulExtractDefaultWnd_WeaponName_TextBox;
var TextBoxHandle EnsoulExtractDefaultWnd_TitleSoul_TextBox;
var TextBoxHandle EnsoulExtractDefaultWnd_SoulName1_TextBox;
var TextBoxHandle EnsoulExtractDefaultWnd_Soul1_TextBox;
var TextBoxHandle EnsoulExtractDefaultWnd_SoulName2_TextBox;
var TextBoxHandle EnsoulExtractDefaultWnd_Soul2_TextBox;
var TextBoxHandle EnsoulExtractDefaultWnd_SoulName3_TextBox;
var TextBoxHandle EnsoulExtractDefaultWnd_Soul3_TextBox;
var WindowHandle EnsoulExtractResultWnd;
var ButtonHandle EnsoulExtractInfo_Button;
var ButtonHandle EnsoulOK_Btn;
var ButtonHandle EnsoulCancel_Btn;
var TextureHandle ExtractResultWnd_Groupbox1_Texture;
var TextureHandle ExtractResultWnd_Divider_Texture;
var TextureHandle ExtractResultWnd_ListGroupbox1_Texture;
var TextureHandle ExtractResultWnd_SlotBg1_Texture;
var ItemWindowHandle ExtractResultWnd_ITEM_ItemWnd;
var TextBoxHandle ExtractResultWnd_Title_TextBox;
var TextBoxHandle ExtractResultWnd_Name_TextBox;
var TextBoxHandle ExtractResultWnd_notice_TextBox;
var TextBoxHandle ExtractResultWnd_ChargeTitle_TextBox;
var TreeHandle NeededItem_TreeCtrl;
var WindowHandle EnsoulExtractWnd_ResultWnd;
var ItemWindowHandle EnsoulExtractSubWnd_WeaponItemWindow;
var ItemWindowHandle EnsoulExtractSubWnd_EnsoulItemWindow;
var AnimTextureHandle EnsoulProgress_AnimTex;
var L2Util util;
var EnsoulExtractSubWnd EnsoulExtractSubWndScript;
var InventoryWnd inventoryWndScript;
var int normalSlotCount;
var int bmSlotCount;
var int currentSlotIndex;
var int currentSlotType;
var UIConstants.EnsoulOptionUIInfo ensoulOptionInfoSlot1;
var UIConstants.EnsoulOptionUIInfo ensoulOptionInfoSlot2;
var UIConstants.EnsoulOptionUIInfo ensoulOptionInfoSlotBM;

function OnRegisterEvent()
{
	RegisterEvent(10062);
	RegisterEvent(10063);
	return;
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	GetWindowHandle("EnsoulExtractSubWnd").ShowWindow();
	initProcess();
	return;
}

function initProcess()
{
	disableWnd.HideWindow();
	EnsoulExtractDefaultWnd_Select1_Texture.ShowWindow();
	EnsoulExtractDefaultWnd_Select2_Texture.HideWindow();
	getItemSlotWindow(0).Clear();
	EnsoulExtractDefaultWnd_WeaponName_TextBox.SetTooltipType("");
	EnsoulExtractDefaultWnd_WeaponName_TextBox.ClearTooltip();
	EnsoulExtractDefaultWnd_WeaponName_TextBox.SetText("");
	EnsoulExtractDefaultWnd_extract1_Button.HideWindow();
	EnsoulExtractDefaultWnd_extract2_Button.HideWindow();
	EnsoulExtractDefaultWnd_extract3_Button.HideWindow();
	clearEnsoulStoneSlot();
	EnsoulExtractProgressWnd.HideWindow();
	EnsoulExtractDefaultWnd.ShowWindow();
	EnsoulExtractResultWnd.HideWindow();
	EnsoulExtractWnd_ResultWnd.HideWindow();
	EnsoulExtractSubWndScript.setLock(false);
	EnsoulExtractSubWndScript.syncInventory();
	EnsoulExtractDiscription_TextBox.ShowWindow();
	EnsoulExtractDiscription_TextBox.SetText(GetSystemString(3496));
	return;
}

function OnHide()
{
	GetWindowHandle("EnsoulExtractSubWnd").HideWindow();
	initProcess();
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
	util = L2Util(GetScript("L2Util"));
	inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
	EnsoulExtractSubWndScript = EnsoulExtractSubWnd(GetScript("EnsoulExtractSubWnd"));
	Me = GetWindowHandle("EnsoulExtractWnd");
	EnsoulProgress_AnimTex = GetAnimTextureHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.EnsoulProgress_AnimTex");
	disableWnd = GetWindowHandle("EnsoulExtractWnd.DisableWnd");
	EnsoulGroupbox1_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulGroupbox1_Texture");
	EnsoulGroupbox2_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulGroupbox2_Texture");
	EnsoulExtractDiscription_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDiscription_TextBox");
	EnsoulExtractProgressWnd = GetWindowHandle("EnsoulExtractWnd.EnsoulExtractProgressWnd");
	EnsoulProgressWnd_ProgressBar = GetProgressCtrlHandle("EnsoulExtractWnd.EnsoulExtractProgressWnd.EnsoulProgressWnd_ProgressBar");
	EnsoulProgressWnd_Title_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractProgressWnd.EnsoulProgressWnd_Title_TextBox");
	EnsoulExtractDefaultWnd = GetWindowHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd");
	EnsoulExtractDefaultWnd_extract1_Button = GetButtonHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_extract1_Button");
	EnsoulExtractDefaultWnd_extract2_Button = GetButtonHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_extract2_Button");
	EnsoulExtractDefaultWnd_extract3_Button = GetButtonHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_extract3_Button");
	EnsoulExtractInfo_Button = GetButtonHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractInfo_Button");
	EnsoulExtract_Btn = GetButtonHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtract_Btn");
	EnsoulExtractDefaultWnd_Select1_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Select1_Texture");
	EnsoulExtractDefaultWnd_Select2_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Select2_Texture");
	EnsoulExtractDefaultWnd_Groupbox1_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Groupbox1_Texture");
	EnsoulExtractDefaultWnd_Groupbox2_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Groupbox2_Texture");
	EnsoulExtractDefaultWnd_Step1_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Step1_Texture");
	EnsoulExtractDefaultWnd_Step2_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Step2_Texture");
	EnsoulExtractDefaultWnd_BM_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_BM_Texture");
	EnsoulExtractDefaultWnd_SlotBg1_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_SlotBg1_Texture");
	EnsoulExtractDefaultWnd_SlotBg2_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_SlotBg2_Texture");
	EnsoulExtractDefaultWnd_SlotBg3_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_SlotBg3_Texture");
	EnsoulExtractDefaultWnd_SlotBg4_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_SlotBg4_Texture");
	EnsoulExtractDefaultWnd_Divider1 = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Divider1");
	EnsoulExtractDefaultWnd_Divider2 = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Divider2");
	EnsoulExtractDefaultWnd_Divider3 = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Divider3");
	EnsoulExtractDefaultWnd_Step1block_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Step1block_Texture");
	EnsoulExtractDefaultWnd_Step2block_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Step2block_Texture");
	EnsoulExtractDefaultWnd_BMblock_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_BMblock_Texture");
	EnsoulExtractDefaultWnd_Item1_ItemWnd = GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Item1_ItemWnd");
	EnsoulExtractDefaultWnd_Item2_ItemWnd = GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Item2_ItemWnd");
	EnsoulExtractDefaultWnd_Item3_ItemWnd = GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Item3_ItemWnd");
	EnsoulExtractDefaultWnd_ItemBM_ItemWnd = GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_ItemBM_ItemWnd");
	EnsoulExtractDefaultWnd_TitleWeapon_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_TitleWeapon_TextBox");
	EnsoulExtractDefaultWnd_WeaponName_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_WeaponName_TextBox");
	EnsoulExtractDefaultWnd_TitleSoul_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_TitleSoul_TextBox");
	EnsoulExtractDefaultWnd_SoulName1_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_SoulName1_TextBox");
	EnsoulExtractDefaultWnd_Soul1_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Soul1_TextBox");
	EnsoulExtractDefaultWnd_SoulName2_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_SoulName2_TextBox");
	EnsoulExtractDefaultWnd_Soul2_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Soul2_TextBox");
	EnsoulExtractDefaultWnd_SoulName3_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_SoulName3_TextBox");
	EnsoulExtractDefaultWnd_Soul3_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Soul3_TextBox");
	EnsoulExtractResultWnd = GetWindowHandle("EnsoulExtractWnd.EnsoulExtractResultWnd");
	EnsoulExtractInfo_Button = GetButtonHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.EnsoulExtractInfo_Button");
	EnsoulOK_Btn = GetButtonHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.EnsoulOK_Btn");
	EnsoulCancel_Btn = GetButtonHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.EnsoulCancel_Btn");
	ExtractResultWnd_Groupbox1_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_Groupbox1_Texture");
	ExtractResultWnd_Divider_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_Divider_Texture");
	ExtractResultWnd_ListGroupbox1_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_ListGroupbox1_Texture");
	ExtractResultWnd_SlotBg1_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_SlotBg1_Texture");
	ExtractResultWnd_ITEM_ItemWnd = GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_ITEM_ItemWnd");
	ExtractResultWnd_Title_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_Title_TextBox");
	ExtractResultWnd_Name_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_Name_TextBox");
	ExtractResultWnd_notice_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_notice_TextBox");
	ExtractResultWnd_ChargeTitle_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_ChargeTitle_TextBox");
	NeededItem_TreeCtrl = GetTreeHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl");
	EnsoulExtractWnd_ResultWnd = GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd");
	EnsoulExtractSubWnd_WeaponItemWindow = GetItemWindowHandle("EnsoulExtractSubWnd.EnsoulSubWnd_Item1");
	EnsoulExtractSubWnd_EnsoulItemWindow = GetItemWindowHandle("EnsoulExtractSubWnd.EnsoulSubWnd_Item2");
	GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.OK_Button").HideWindow();
	GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Cancel_Button").HideWindow();
	GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.singleOK_Button").ShowWindow();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 10062:
			Me.ShowWindow();
			break;
		case 10063:
			Debug(("EV_EnsoulExtractionResult" @ param));
			showResult(param);
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "EnsoulExtractDefaultWnd_extract1_Button":
			showConfirm(1);
			break;
		case "EnsoulExtractDefaultWnd_extract2_Button":
			showConfirm(2);
			break;
		case "EnsoulExtractDefaultWnd_extract3_Button":
			showConfirm(3);
			break;
		case "EnsoulExtractInfo_Button":
			helpButtonClick();
			break;
		case "EnsoulExtract_Btn":
			Me.HideWindow();
			Debug("EnsoulExtract_Btn");
			break;
		case "EnsoulOK_Btn":
			OnEnsoulOK_BtnClick();
			break;
		case "EnsoulCancel_Btn":
			OnEnsoulCancel_BtnClick();
			break;
		case "singleOK_Button":
			Debug("singleOK_Button");
			initProcess();
			break;
		default:
			break;
	}
	return;
}

function showConfirm(int SlotIndex)
{
	local ItemInfo ensoulItemInfo, weaponInfo;
	local string ensoulFeeInfoParam;
	local int slotType;

	Debug(("slotIndex" @ string(SlotIndex)));
	disableWnd.HideWindow();
	EnsoulExtractDefaultWnd.HideWindow();
	EnsoulExtractWnd_ResultWnd.HideWindow();
	EnsoulExtractSubWndScript.setLock(true);
	EnsoulExtractResultWnd.ShowWindow();
	EnsoulExtractDiscription_TextBox.SetText(GetSystemString(3497));
	ensoulItemInfo = getltemInfoBySlotIndex(SlotIndex);
	if((ensoulItemInfo.IconName != ""))
	{
		ExtractResultWnd_ITEM_ItemWnd.Clear();
		ExtractResultWnd_ITEM_ItemWnd.AddItem(ensoulItemInfo);
		setEnsoulSlotText(SlotIndex, getEnsoulOptionInfoBySlotIndex(SlotIndex), getInstanceUIData().GetIsLiveServer(), , "", util.ColorLightBrown, true);
	}
	Debug(("getEnsoulOptionInfoBySlotIndex(slotIndex).ExtractionItemID : " @ string(getEnsoulOptionInfoBySlotIndex(SlotIndex).ExtractionItemID)));
	weaponInfo = getltemInfoBySlotIndex(0);
	if(((SlotIndex == 1) || (SlotIndex == 2)))
	{
		slotType = 1;
	}
	else
	{
		slotType = 2;
	}
	currentSlotIndex = SlotIndex;
	currentSlotType = slotType;
	Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulExtractionFeeInfoByItemId(getEnsoulOptionInfoBySlotIndex(SlotIndex).ExtractionItemID, ensoulFeeInfoParam);
	setTreeNeedItemInfo(ensoulFeeInfoParam);
	return;
}

function setTreeNeedItemInfo(string ensoulFeeInfoParam)
{
	local ItemInfo feeItemInfo;
	local int nFeeItemNum, nFeeItemID, i;
	local INT64 nFeeItemCount;
	local ItemInfo InvenFeeItemInfo;

	ParseInt(ensoulFeeInfoParam, "FeeItemCount", nFeeItemNum);
	util.TreeClear("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl");
	util.TreeInsertRootNode("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", "root", "", 0, 4);
	EnsoulOK_Btn.EnableWindow();
	EnsoulExtractDiscription_TextBox.SetText(GetSystemString(3496));
	i = 1;
	while((i < (nFeeItemNum + 1)))
	{
		ParseInt(ensoulFeeInfoParam, ("ItemID_" $ string(i)), nFeeItemID);
		ParseINT64(ensoulFeeInfoParam, ("ItemCount_" $ string(i)), nFeeItemCount);
		Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(nFeeItemID), feeItemInfo);
		addTreeNode(("LIST" $ string((i + 1))), feeItemInfo, nFeeItemCount);
		i++;
	}
	inventoryWndScript.GetInventoryItemInfo(GetItemID(nFeeItemID), InvenFeeItemInfo);
	return;
}

function bool addTreeNode(string nodeLine, ItemInfo Info, INT64 needItemCount)
{
	local ItemInfo InvenItemInfo;
	local string strRetName, gradeTextureName;
	local int textHeight;
	local string enchantedStr, ItemName, AdditionalName, stackableAddStr, shortItemName, ensoulOptionAllName;
	local int enchantedStr_width, additionalName_width, stackableAddStr_width, ensoulOptionAllName_width, gradeTextureName_width;
	local INT64 hasNum;
	local bool bHasItem;
	local array<ItemInfo> itemInfoArray;
	local int ItemCount;

	gradeTextureName = GetItemGradeTextureName(Info.CrystalType);
	if((Len(gradeTextureName) > 0))
	{
		gradeTextureName_width = 16;
		if((((((Info.CrystalType == 6) || (Info.CrystalType == 7)) || (Info.CrystalType == 9)) || (Info.CrystalType == 10)) || (Info.CrystalType == 11)))
		{
			gradeTextureName_width = 32;
		}
	}
	stackableAddStr = "x1";
	GetTextSizeDefault(stackableAddStr, stackableAddStr_width, textHeight);
	if((Info.Enchanted > 0))
	{
		enchantedStr = ("+" $ string(Info.Enchanted));
	}
	GetTextSizeDefault(enchantedStr, enchantedStr_width, textHeight);
	ensoulOptionAllName = GetEnsoulOptionNameAll(Info);
	GetTextSizeDefault(ensoulOptionAllName, ensoulOptionAllName_width, textHeight);
	AdditionalName = Class'NWindow.UIDATA_ITEM'.static.GetItemAdditionalName(Info.Id);
	GetTextSizeDefault(AdditionalName, additionalName_width, textHeight);
	ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(Info.Id);
	if((ItemName == ""))
	{
		ItemName = Info.Name;
	}
	shortItemName = makeShortStringByPixel(ItemName, (240 - (((stackableAddStr_width + additionalName_width) + gradeTextureName_width) + 7)), "..");
	strRetName = (("root" $ ".") $ nodeLine);
	util.TreeInsertItemTooltipSimpleNode("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", nodeLine, "root", -7, 0, 38, 0, 32, 38, GetItemNameAll(Info));
	util.TreeInsertTextureNodeItem("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", strRetName, "L2UI_CT1.EmptyBtn", 257, 38);
	util.TreeInsertTextureNodeItem("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -251, 2);
	util.TreeInsertTextureNodeItem("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", strRetName, Info.IconName, 32, 32, -34, (4 - 1));
	util.TreeInsertTextureNodeItem("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", strRetName, Info.IconPanel, 32, 32, -32, (4 - 1));
	if((enchantedStr != ""))
	{
		util.TreeInsertTextNodeItem("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", strRetName, enchantedStr, 7, 5, COLOR_DEFAULT, true);
	}
	util.TreeInsertTextNodeItem("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", strRetName, shortItemName, 5, 5, COLOR_DEFAULT, true);
	if((ensoulOptionAllName != ""))
	{
		util.TreeInsertTextNodeItem("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", strRetName, ensoulOptionAllName, 5, 5, COLOR_YELLOW, true);
	}
	if((AdditionalName != ""))
	{
		util.TreeInsertTextNodeItem("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", strRetName, AdditionalName, 5, 5, COLOR_YELLOW, true);
	}
	if((gradeTextureName_width > 0))
	{
		util.TreeInsertTextureNodeItem("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", strRetName, gradeTextureName, gradeTextureName_width, 16, 2, 5);
	}
	util.TreeInsertTextNodeItem("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", strRetName, ("x " $ MakeCostString(string(needItemCount))), 45, -14, COLOR_GOLD, false, true);
	ItemCount = Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(Info.Id.ClassID, itemInfoArray);
	if((ItemCount > 0))
	{
		InvenItemInfo = itemInfoArray[0];
		if(!IsStackableItem(InvenItemInfo.ConsumeType))
		{
			hasNum = INT64(1);
		}
		else
		{
			hasNum = InvenItemInfo.ItemNum;
		}
		if((hasNum >= needItemCount))
		{
			bHasItem = true;
		}
	}
	if(bHasItem)
	{
		if((hasNum != INT64(-1)))
		{
			util.TreeInsertTextNodeItem("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", strRetName, (("(" $ MakeCostString(string(hasNum))) $ ")"), 4, -14, COLOR_BRIGHT_BLUE);
		}
	}
	else
	{
		util.TreeInsertTextNodeItem("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", strRetName, (("(" $ MakeCostString(string(hasNum))) $ ")"), 4, -14, COLOR_RED);
		EnsoulOK_Btn.DisableWindow();
		EnsoulExtractDiscription_TextBox.SetText(MakeFullSystemMsg(GetSystemMessage(1473), GetSystemString(3494)));
	}
	return bHasItem;
}

function helpButtonClick()
{
	ExecuteEvent(1210, "40");
	return;
}

function OnEnsoulOK_BtnClick()
{
	EnsoulExtractProgressWnd.ShowWindow();
	EnsoulProgressWnd_ProgressBar.Reset();
	EnsoulProgressWnd_ProgressBar.SetProgressTime(1500);
	EnsoulProgressWnd_ProgressBar.Start();
	PlaySound("ItemSound3.enchant_process");
	EnsoulExtractDiscription_TextBox.HideWindow();
	Debug("해제 시도 EnsoulOK_Btn");  // EN: attempting to release EnsoulOK_Btn
	return;
}

function OnProgressTimeUp(string strID)
{
	Debug(("strID" @ strID));
	if((strID == "EnsoulProgressWnd_ProgressBar"))
	{
		if(Me.IsShowWindow())
		{
			disableWnd.ShowWindow();
			Debug("EnsoulProgressWnd_ProgressBar 창 열기");  // EN: open the EnsoulProgressWnd_ProgressBar window
			EnsoulExtractProgressWnd.HideWindow();
			requestItemEnsoulProcess();
		}
	}
	return;
}

function requestItemEnsoulProcess()
{
	local string param;

	param = makeRequestEnsoulExtractionParam();
	Class'NWindow.EnsoulAPI'.static.RequestItemExtraction(param);
	Debug((" 실행 --- class'EnsoulAPI'.static.RequestItemExtraction() --> param: " @ param));  // EN: run --- class'EnsoulAPI'.static.RequestItemExtraction() --> param:
	return;
}

function string makeRequestEnsoulExtractionParam()
{
	local string param;
	local int targetWeaponServerID, SlotIndex;

	targetWeaponServerID = getltemInfoBySlotIndex(0).Id.ServerID;
	if((2 == currentSlotType))
	{
		SlotIndex = 1;
	}
	else
	{
		SlotIndex = currentSlotIndex;
	}
	ParamAdd(param, "TargetItemID", string(targetWeaponServerID));
	ParamAdd(param, "SlotType", string(currentSlotType));
	ParamAdd(param, "SlotIndex", string(SlotIndex));
	return param;
}

function OnEnsoulCancel_BtnClick()
{
	initProcess();
	StopSound("ItemSound3.enchant_process");
	return;
}

function showResult(string param)
{
	local int resultValue, i, N, EnsoulOptionNum, nEOptionID;
	local ItemInfo weaponInfo;

	getItemSlotWindow(0).GetItem(0, weaponInfo);
	i = 1;
	while((i < 3))
	{
		ParseInt(param, ("EnsoulOptionNum_" $ string(i)), EnsoulOptionNum);
		N = 1;
		while((N < (1 + EnsoulOptionNum)))
		{
			ParseInt(param, ((("EnsoulOptionID_" $ string(i)) $ "_") $ string(N)), nEOptionID);
			weaponInfo.EnsoulOption[(i - 1)].OptionArray[(N - 1)] = nEOptionID;
			N++;
		}
		i++;
	}
	disableWnd.SetFocus();
	disableWnd.ShowWindow();
	disableWnd.SetFocus();
	EnsoulExtractWnd_ResultWnd.ShowWindow();
	ParseInt(param, "ExtractionResult", resultValue);
	if((resultValue > 0))
	{
		confirmResultEnsoulOption(true, weaponInfo);
	}
	else
	{
		confirmResultEnsoulOption(false, weaponInfo);
	}
	return;
}

function confirmResultEnsoulOption(bool bSuccess, ItemInfo Info)
{
	local ItemInfo tempInfo;

	if(bSuccess)
	{
		Debug("애니 돌리기");  // EN: play animation
		EnsoulExtractWnd_ResultWnd.SetWindowSize(233, 200);
		GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.OK_Button").HideWindow();
		GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Cancel_Button").HideWindow();
		GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.singleOK_Button").ShowWindow();
		EnsoulProgress_AnimTex.SetLoopCount(1);
		EnsoulProgress_AnimTex.Stop();
		EnsoulProgress_AnimTex.Play();
		PlaySound("ItemSound3.enchant_success");
		EnsoulProgress_AnimTex.ShowWindow();
		GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").Clear();
		GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").ClearTooltip();
		GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").AddItem(Info);
		GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").SetTooltipType("Inventory");
		LoadHtmlTable(GetHtmlHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Discription_HtmlCtrl"), GetSystemString(3498));
	}
	else
	{
		PlaySound("ItemSound3.enchant_fail");
		EnsoulExtractWnd_ResultWnd.SetWindowSize(233, 250);
		tempInfo.IconName = "L2UI_ct1.Icon.ICON_DF_Exclamation";
		GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.OK_Button").HideWindow();
		GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Cancel_Button").HideWindow();
		GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.singleOK_Button").ShowWindow();
		EnsoulProgress_AnimTex.Stop();
		EnsoulProgress_AnimTex.HideWindow();
		GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").ShowWindow();
		GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").Clear();
		GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").AddItem(tempInfo);
		GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").SetTooltipType("");
		GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").ClearTooltip();
		LoadHtmlTable(GetHtmlHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Discription_HtmlCtrl"), GetSystemMessage(4334));
	}
	return;
}

function OnTextureAnimEnd(AnimTextureHandle a_AnimTextureHandle)
{
	switch(a_AnimTextureHandle.GetWindowName())
	{
		case "EnsoulProgress_AnimTex":
			a_AnimTextureHandle.HideWindow();
			break;
		default:
			break;
	}
	Debug(("---------------------OnTextureAnimEnd : " @ a_AnimTextureHandle.GetWindowName()));
	return;
}

function InsertWeapon(ItemInfo Info)
{
	local string FullName;

	PlaySound("ItemSound3.enchant_input");
	if(getInstanceUIData().GetIsClassicServer())
	{
		if((((Info.ItemType == 0) || (Info.ItemType == 1)) || (Info.ItemType == 2)))
		{
		}
		else
		{
			return;
		}
	}
	else if((((Info.ItemType == 0) || (Info.ItemType == 1)) || (Info.ItemType == 2)))
	{
	}
	else
	{
		return;
	}
	EnsoulExtractDefaultWnd_Step1block_Texture.ShowWindow();
	EnsoulExtractDefaultWnd_Step2block_Texture.ShowWindow();
	EnsoulExtractDefaultWnd_BMblock_Texture.ShowWindow();
	EnsoulExtractDefaultWnd_extract1_Button.HideWindow();
	EnsoulExtractDefaultWnd_extract2_Button.HideWindow();
	EnsoulExtractDefaultWnd_extract3_Button.HideWindow();
	if((EnsoulExtractDefaultWnd_Item1_ItemWnd.GetItemNum() > 0))
	{
		util.ItemWIndow_ItemMoveByIndex(getItemSlotWindow(0), EnsoulExtractSubWnd_WeaponItemWindow, 0);
		EnsoulExtractDefaultWnd_WeaponName_TextBox.SetTooltipType("");
		EnsoulExtractDefaultWnd_WeaponName_TextBox.ClearTooltip();
	}
	util.ItemWIndow_ItemMoveByItemID(EnsoulExtractSubWnd_WeaponItemWindow, getItemSlotWindow(0), Info.Id);
	if((Info.Id.ClassID > 0))
	{
		EnsoulExtractDefaultWnd_Select1_Texture.HideWindow();
		EnsoulExtractDefaultWnd_Select1_Texture.ShowWindow();
		normalSlotCount = Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulSlotCount(Info.Id, 1);
		bmSlotCount = Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulSlotCount(Info.Id, 2);
		EnsoulExtractDefaultWnd_SlotBg1_Texture.HideWindow();
		EnsoulExtractDefaultWnd_SlotBg2_Texture.HideWindow();
		EnsoulExtractDefaultWnd_SlotBg3_Texture.HideWindow();
		FullName = GetItemNameAll(Info);
		util.textBox_setToolTipWithShortString(EnsoulExtractDefaultWnd_WeaponName_TextBox, FullName);
		clearEnsoulStoneSlot();
		applyWeaponEnsoulInfo(Info);
	}
	setWeaponEnsoulOptionSlot(Info);
	return;
}

function applyWeaponEnsoulInfo(ItemInfo Info)
{
	local int N, i, Cnt, OptionID, rIndex;
	local UIConstants.EnsoulOptionUIInfo optionInfo;
	local ItemInfo esInfo;

	Debug("초기화 applyWeaponEnsoulInfo");  // EN: reset applyWeaponEnsoulInfo
	i = 1;
	while((i < 3))
	{
		Cnt = Info.EnsoulOption[(i - 1)].OptionArray.Length;
		N = 1;
		while((N < (1 + Cnt)))
		{
			OptionID = Info.EnsoulOption[(i - 1)].OptionArray[(N - 1)];
			if((OptionID > 0))
			{
				GetEnsoulOptionUIInfo(OptionID, optionInfo);
			}
			else
			{
				N++;
				continue;
			}
			if((OptionID > 0))
			{
				if((i == 2))
				{
					rIndex = 3;
				}
				else
				{
					rIndex = N;
				}
				esInfo.IconName = optionInfo.Icontex;
				if((i == 1))
				{
					if((N == 1))
					{
						Debug(("optionInfo.ExtractionItemID :::: " @ string(optionInfo.ExtractionItemID)));
						if((getItemSlotWindow(1).GetItemNum() == 0))
						{
							ensoulOptionInfoSlot1 = optionInfo;
							getItemSlotWindow(1).AddItem(esInfo);
							setEnsoulSlotText(1, optionInfo, false, , "", util.ColorLightBrown);
							EnsoulExtractDefaultWnd_SlotBg1_Texture.ShowWindow();
							EnsoulExtractDefaultWnd_extract1_Button.ShowWindow();
							if((optionInfo.ExtractionItemID == 0))
							{
								EnsoulExtractDefaultWnd_extract1_Button.SetButtonName(460);
								EnsoulExtractDefaultWnd_extract1_Button.DisableWindow();
							}
							else
							{
								EnsoulExtractDefaultWnd_extract1_Button.SetButtonName(3492);
								EnsoulExtractDefaultWnd_extract1_Button.EnableWindow();
							}
						}
					}
					else if((getItemSlotWindow(2).GetItemNum() == 0))
					{
						ensoulOptionInfoSlot2 = optionInfo;
						getItemSlotWindow(2).AddItem(esInfo);
						setEnsoulSlotText(2, optionInfo, false, , "", util.ColorLightBrown);
						EnsoulExtractDefaultWnd_SlotBg2_Texture.ShowWindow();
						EnsoulExtractDefaultWnd_extract2_Button.ShowWindow();
						if((optionInfo.ExtractionItemID == 0))
						{
							EnsoulExtractDefaultWnd_extract2_Button.DisableWindow();
							EnsoulExtractDefaultWnd_extract2_Button.SetButtonName(460);
						}
						else
						{
							EnsoulExtractDefaultWnd_extract2_Button.SetButtonName(3492);
							EnsoulExtractDefaultWnd_extract2_Button.EnableWindow();
						}
					}
					N++;
					continue;
				}
				if((i == 2))
				{
					ensoulOptionInfoSlotBM = optionInfo;
					if((getItemSlotWindow(3).GetItemNum() == 0))
					{
						getItemSlotWindow(3).AddItem(esInfo);
						setEnsoulSlotText(3, optionInfo, false, , "", util.ColorLightBrown);
						EnsoulExtractDefaultWnd_SlotBg3_Texture.ShowWindow();
						EnsoulExtractDefaultWnd_extract3_Button.ShowWindow();
						if((optionInfo.ExtractionItemID == 0))
						{
							EnsoulExtractDefaultWnd_extract3_Button.SetButtonName(460);
							EnsoulExtractDefaultWnd_extract3_Button.DisableWindow();
							N++;
							continue;
						}
						EnsoulExtractDefaultWnd_extract3_Button.SetButtonName(3492);
						EnsoulExtractDefaultWnd_extract3_Button.EnableWindow();
					}
				}
			}
			N++;
		}
		i++;
	}
	return;
}

function setEnsoulSlotText(int SlotIndex, UIConstants.EnsoulOptionUIInfo eOptionInfo, bool bUseExtractionName, optional bool bDelete, optional string applyAddString, optional Color applyColor, optional bool bConfirmWnd)
{
	local TextBoxHandle soulNameTextBox, soulDescTextBox;
	local CustomTooltip cTooltip;
	local ItemInfo tmItemInfo;

	if(bUseExtractionName)
	{
		if((eOptionInfo.ExtractionItemID > 0))
		{
			Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(eOptionInfo.ExtractionItemID), tmItemInfo);
		}
	}
	if((bConfirmWnd == false))
	{
		if((SlotIndex == 1))
		{
			soulNameTextBox = EnsoulExtractDefaultWnd_SoulName1_TextBox;
			soulDescTextBox = EnsoulExtractDefaultWnd_Soul1_TextBox;
		}
		else if((SlotIndex == 2))
		{
			soulNameTextBox = EnsoulExtractDefaultWnd_SoulName2_TextBox;
			soulDescTextBox = EnsoulExtractDefaultWnd_Soul2_TextBox;
		}
		else if((SlotIndex == 3))
		{
			soulNameTextBox = EnsoulExtractDefaultWnd_SoulName3_TextBox;
			soulDescTextBox = EnsoulExtractDefaultWnd_Soul3_TextBox;
		}
	}
	else
	{
		soulNameTextBox = ExtractResultWnd_Name_TextBox;
		soulDescTextBox = ExtractResultWnd_notice_TextBox;
	}
	if((((int(applyColor.R) != 0) && (int(applyColor.G) != 0)) && (int(applyColor.B) != 0)))
	{
		soulNameTextBox.SetTextColor(applyColor);
	}
	if(bDelete)
	{
		textBoxClear(soulNameTextBox);
		textBoxClear(soulDescTextBox);
	}
	else
	{
		if((eOptionInfo.OptionStep > 0))
		{
			if(bUseExtractionName)
			{
				util.textBox_setToolTipWithShortString(soulNameTextBox, (applyAddString $ tmItemInfo.Name));
			}
			else
			{
				util.textBox_setToolTipWithShortString(soulNameTextBox, MakeFullSystemMsg(GetSystemMessage(4347), (applyAddString $ eOptionInfo.Name), string(eOptionInfo.OptionStep)));
			}
		}
		else if(bUseExtractionName)
		{
			util.textBox_setToolTipWithShortString(soulNameTextBox, (applyAddString $ tmItemInfo.Name));
		}
		else
		{
			util.textBox_setToolTipWithShortString(soulNameTextBox, (applyAddString $ eOptionInfo.Name));
		}
		util.textBox_setToolTipWithShortString(soulDescTextBox, eOptionInfo.Desc);
		addToolTipDrawList(cTooltip, addDrawItemTexture(eOptionInfo.IconPanelTex, false, false, 2));
		addToolTipDrawList(cTooltip, addDrawItemTexture(eOptionInfo.Icontex, false, false, -16));
		addToolTipDrawList(cTooltip, addDrawItemText(eOptionInfo.Name, util.White, "", false));
		addToolTipDrawList(cTooltip, addDrawItemText(" : ", util.White, "", false));
		addToolTipDrawList(cTooltip, addDrawItemText(eOptionInfo.Desc, util.ColorDesc, "", false));
		addToolTipDrawList(cTooltip, addDrawItemBlank(1));
		soulDescTextBox.SetTooltipType("text");
		soulDescTextBox.SetTooltipCustomType(cTooltip);
	}
	return;
}

function clearEnsoulStoneSlot()
{
	getItemSlotWindow(1).Clear();
	getItemSlotWindow(2).Clear();
	getItemSlotWindow(3).Clear();
	textBoxClear(EnsoulExtractDefaultWnd_Soul1_TextBox);
	textBoxClear(EnsoulExtractDefaultWnd_Soul2_TextBox);
	textBoxClear(EnsoulExtractDefaultWnd_Soul3_TextBox);
	textBoxClear(EnsoulExtractDefaultWnd_SoulName1_TextBox);
	textBoxClear(EnsoulExtractDefaultWnd_SoulName2_TextBox);
	textBoxClear(EnsoulExtractDefaultWnd_SoulName3_TextBox);
	return;
}

function UIConstants.EnsoulOptionUIInfo getEnsoulOptionInfoBySlotIndex(int SlotIndex)
{
	local UIConstants.EnsoulOptionUIInfo enInfo;

	if((SlotIndex == 1))
	{
		enInfo = ensoulOptionInfoSlot1;
	}
	else if((SlotIndex == 2))
	{
		enInfo = ensoulOptionInfoSlot2;
	}
	else if((SlotIndex == 3))
	{
		enInfo = ensoulOptionInfoSlotBM;
	}
	else
	{
		Debug(("Error (getEnsoulOptionInfoBySlotIndex) : Index is " @ string(SlotIndex)));
	}
	return enInfo;
}

function ItemWindowHandle getItemSlotWindow(int SlotIndex)
{
	local ItemWindowHandle targetItemWndow;

	if((SlotIndex == 0))
	{
		targetItemWndow = EnsoulExtractDefaultWnd_Item1_ItemWnd;
	}
	else if((SlotIndex == 1))
	{
		targetItemWndow = EnsoulExtractDefaultWnd_Item2_ItemWnd;
	}
	else if((SlotIndex == 2))
	{
		targetItemWndow = EnsoulExtractDefaultWnd_Item3_ItemWnd;
	}
	else if((SlotIndex == 3))
	{
		targetItemWndow = EnsoulExtractDefaultWnd_ItemBM_ItemWnd;
	}
	else
	{
		Debug(("Error (getItemSlotWindow) : Index is " @ string(SlotIndex)));
	}
	return targetItemWndow;
}

function ItemInfo getltemInfoBySlotIndex(int SlotIndex)
{
	local ItemInfo tm;

	getItemSlotWindow(SlotIndex).GetItem(0, tm);
	return tm;
}

function setWeaponEnsoulOptionSlot(ItemInfo tempInfo)
{
	local int N;

	N = Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulSlotCount(tempInfo.Id, 1);
	if((N == 1))
	{
		EnsoulExtractDefaultWnd_Step1block_Texture.HideWindow();
	}
	else if((N == 2))
	{
		EnsoulExtractDefaultWnd_Step1block_Texture.HideWindow();
		EnsoulExtractDefaultWnd_Step2block_Texture.HideWindow();
	}
	N = Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulSlotCount(tempInfo.Id, 2);
	if((N > 0))
	{
		EnsoulExtractDefaultWnd_BMblock_Texture.HideWindow();
	}
	return;
}

function bool externalCheckUsingItem(ItemInfo Info)
{
	local ItemInfo innerItemInfo;
	local bool RValue;

	if((getItemSlotWindow(0).GetItemNum() > 0))
	{
		getItemSlotWindow(0).GetItem(0, innerItemInfo);
		if((innerItemInfo.Id == Info.Id))
		{
			RValue = true;
		}
	}
	return RValue;
}

function OnDropItem(string a_WindowID, ItemInfo a_itemInfo, int X, int Y)
{
	local Rect rectWnd;

	rectWnd = Me.GetRect();
	if(((a_itemInfo.DragSrcName == "EnsoulSubWnd_Item1") || (a_itemInfo.DragSrcName == "EnsoulSubWnd_Item2")))
	{
	}
	else
	{
		return;
	}
	if(((((X > rectWnd.nX) && (X < (rectWnd.nX + rectWnd.nWidth))) && (Y > rectWnd.nY)) && (Y < (rectWnd.nY + rectWnd.nHeight))))
	{
		InsertWeapon(a_itemInfo);
	}
	return;
}

function textBoxClear(TextBoxHandle txtBox)
{
	txtBox.SetText("");
	txtBox.SetTooltipType("");
	txtBox.SetText("");
	return;
}

function LoadHtmlTable(HtmlHandle htmlCtrl, string Desc)
{
	local string htmlStr;
	local int nWidth, nHeight;

	htmlCtrl.GetWindowSize(nWidth, nHeight);
	htmlStr = HtmlAddTableTD(Desc, "center", "center", nWidth, 0, "", true);
	HtmlSetTableTR(htmlStr);
	htmlSetTable(htmlStr, 0, nWidth, 0, "", 0, 0);
	htmlCtrl.LoadHtmlFromString(htmlSetHtmlStart(htmlStr));
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
