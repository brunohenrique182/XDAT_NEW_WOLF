class TokenTradeWnd extends UICommonAPI;

const DelaySelectedTimerID = 12131212;
const DelayTimer = 50;
const TOKENSELLWND_DIALOG_OK = 1124;

struct MultiSellInfo
{
	var int MultiSellInfoID;
	var int MultiSellType;
	var INT64 NeededItemNum;
	var ItemInfo ResultItemInfo;
	var array<ItemInfo> OutputItemInfoList;
	var array<ItemInfo> InputItemInfoList;
	var array<string> Per;
	var array<string> param;
};

var WindowHandle Me;
var ButtonHandle TradeBtn;
var ButtonHandle CancelBtn;
var TextBoxHandle ItemTypeText;
var TextBoxHandle TradePossibleText;
var TextBoxHandle ItemExplainText;
var TreeHandle ItemTypeTree;
var TreeHandle NeedItemTree;
var ListCtrlHandle TradePossibleListCtrl;
var TextureHandle NeedItemIcon;
var L2Util util;
var array<MultiSellInfo> m_MultiSellInfoList;
var int m_MultiSellGroupID;
var int m_nSelectedMultiSellInfoIndex;
var int m_nCurrentMultiSellInfoIndex;
var int lastSelectNitemID;
var int lastSelectIndex;

function OnRegisterEvent()
{
	RegisterEvent(2531);
	RegisterEvent(2536);
	RegisterEvent(2541);
	RegisterEvent(2551);
	RegisterEvent(2561);
	RegisterEvent(9570);
	RegisterEvent(1710);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();
	return;
}

function OnShow()
{
	Me.KillTimer(12131212);
	lastSelectNitemID = 0;
	lastSelectIndex = 0;
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	return;
}

function Initialize()
{
	Me = GetWindowHandle("TokenTradeWnd");
	TradeBtn = GetButtonHandle("TokenTradeWnd.TradeBtn");
	CancelBtn = GetButtonHandle("TokenTradeWnd.CancelBtn");
	ItemTypeText = GetTextBoxHandle("TokenTradeWnd.ItemTypeText");
	TradePossibleText = GetTextBoxHandle("TokenTradeWnd.TradePossibleText");
	ItemExplainText = GetTextBoxHandle("TokenTradeWnd.ItemExplainText");
	ItemTypeTree = GetTreeHandle("TokenTradeWnd.ItemTypeTree");
	NeedItemTree = GetTreeHandle("TokenTradeWnd.NeedItemTree");
	TradePossibleListCtrl = GetListCtrlHandle("TokenTradeWnd.TradePossibleListCtrl");
	NeedItemIcon = GetTextureHandle("TokenTradeWnd.NeedItemIcon");
	TradePossibleListCtrl.SetSelectedSelTooltip(false);
	TradePossibleListCtrl.SetAppearTooltipAtMouseX(true);
	return;
}

function Load()
{
	util = L2Util(GetScript("L2Util"));
	return;
}

function OnClickButton(string strID)
{
	local array<string> Result;
	local string treelist;

	treelist = Left(strID, 4);
	if((strID == "TradeBtn"))
	{
		OnTradeBtnClick();
	}
	else if((strID == "CancelBtn"))
	{
		OnCancelBtnClick();
	}
	if((treelist == "Root"))
	{
		Split(strID, ".", Result);
		SelectChangeItem(int(Result[1]));
	}
	return;
}

function OnTradeBtnClick()
{
	local array<string> Result;
	local string treelist;
	local int SelectedIndex;

	treelist = Class'NWindow.UIAPI_TREECTRL'.static.GetExpandedNode("TokenTradeWnd.ItemTypeTree", "Root");
	Split(treelist, ".", Result);
	if((treelist != ""))
	{
		SelectedIndex = int(Result[1]);
		DialogSetReservedInt(SelectedIndex);
		DialogSetReservedInt2(INT64(1));
		DialogSetID(1124);
		DialogShow(DialogModalType_Modalless, DialogType_Warning, GetSystemMessage(1383));
		m_nSelectedMultiSellInfoIndex = SelectedIndex;
		lastSelectNitemID = m_MultiSellInfoList[m_nSelectedMultiSellInfoIndex].MultiSellInfoID;
	}
	return;
}

function OnCancelBtnClick()
{
	Clear();
	Me.HideWindow();
	return;
}

function OnHide()
{
	Me.KillTimer(12131212);
	lastSelectNitemID = 0;
	lastSelectIndex = 0;
	return;
}

function HandleDialogOK()
{
	local string param;
	local int SelectedIndex;

	if(DialogIsMine())
	{
		SelectedIndex = DialogGetReservedInt();
		if((SelectedIndex >= m_MultiSellInfoList.Length))
		{
			return;
		}
		ParamAdd(param, "MultiSellGroupID", string(m_MultiSellGroupID));
		ParamAdd(param, "MultiSellInfoID", string(m_MultiSellInfoList[SelectedIndex].MultiSellInfoID));
		ParamAdd(param, "ItemCount", string(DialogGetReservedInt2()));
		ParamAdd(param, "Enchant", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.Enchanted));
		ParamAdd(param, "RefineryOp1", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.RefineryOp1));
		ParamAdd(param, "RefineryOp2", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.RefineryOp2));
		ParamAdd(param, "RefineryOp3", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.RefineryOp3));
		ParamAdd(param, "AttrAttackType", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.AttackAttributeType));
		ParamAdd(param, "AttrAttackValue", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.AttackAttributeValue));
		ParamAdd(param, "AttrDefenseValueFire", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueFire));
		ParamAdd(param, "AttrDefenseValueWater", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueWater));
		ParamAdd(param, "AttrDefenseValueWind", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueWind));
		ParamAdd(param, "AttrDefenseValueEarth", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueEarth));
		ParamAdd(param, "AttrDefenseValueHoly", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueHoly));
		ParamAdd(param, "AttrDefenseValueUnholy", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueUnholy));
		ParamAdd(param, "IsBlessedItem", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.BlessBaseEffectID));
		addParamEnsoulOptionInfo(m_MultiSellInfoList[SelectedIndex].ResultItemInfo, param);
		RequestMultiSellChoose(param);
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 2531:
			HandleMultiSellInfoListBegin(param);
			break;
		case 2536:
			HandleMultiSellResultItemInfo(param);
			break;
		case 2541:
			HandelMultiSellOutputItemInfo(param);
			break;
		case 2551:
			HandelMultiSellInputItemInfo(param);
			break;
		case 2561:
			HandleMultiSellInfoListEnd(param);
			break;
		case 1710:
			HandleDialogOK();
			break;
		case 9570:
			if(Me.IsShowWindow())
			{
				needItemUpdate(lastSelectIndex);
			}
			break;
		default:
			break;
	}
	return;
}

function HandleMultiSellInfoListBegin(string param)
{
	Clear();
	ParseInt(param, "MultiSellGroupID", m_MultiSellGroupID);
	return;
}

function HandleMultiSellResultItemInfo(string param)
{
	local int nMultiSellInfoID, nBuyType;
	local ItemInfo Info;
	local int nIsBlessedItem, ensoulNormalSlot, ensoulBmSlot;

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
	ParseInt(param, "IsBlessedItem", nIsBlessedItem);
	Info.IsBlessedItem = numToBool(nIsBlessedItem);
	ParseInt(param, "BlessBaseEffectID", Info.BlessBaseEffectID);
	addEnsoulInfo(2, ensoulBmSlot, param, Info);
	addEnsoulInfo(1, ensoulNormalSlot, param, Info);
	m_nCurrentMultiSellInfoIndex = m_MultiSellInfoList.Length;
	m_MultiSellInfoList.Length = (m_nCurrentMultiSellInfoIndex + 1);
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID = nMultiSellInfoID;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellType = nBuyType;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].ResultItemInfo = Info;
	return;
}

function HandelMultiSellOutputItemInfo(string param)
{
	local int nMultiSellInfoID, nCurrentOutputItemInfoIndex;
	local ItemInfo Info;
	local int nItemClassID;
	local string Per;
	local int nIsBlessedItem, ensoulNormalSlot, ensoulBmSlot;

	Debug(("HandelMultiSellOutputItemInfo : " $ param));
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
	ParseInt(param, "Attribution", Info.Attribution);
	ParseString(param, "Probability", Per);
	ParseInt(param, ("EnsoulOptionNum_" $ string(2)), ensoulBmSlot);
	ParseInt(param, ("EnsoulOptionNum_" $ string(1)), ensoulNormalSlot);
	addEnsoulInfo(2, ensoulBmSlot, param, Info);
	addEnsoulInfo(1, ensoulNormalSlot, param, Info);
	ParseInt(param, "IsBlessedItem", nIsBlessedItem);
	Info.IsBlessedItem = numToBool(nIsBlessedItem);
	ParseInt(param, "BlessBaseEffectID", Info.BlessBaseEffectID);
	if((m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID != nMultiSellInfoID))
	{
		return;
	}
	if((nItemClassID == -300))
	{
		Info.Name = GetSystemString(102);
		Info.IconName = "icon.pvp_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	if((0 < Info.Durability))
	{
		Info.CurrentDurability = Info.Durability;
	}
	nCurrentOutputItemInfoIndex = m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList.Length;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].Per.Length = (nCurrentOutputItemInfoIndex + 1);
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].Per[nCurrentOutputItemInfoIndex] = Per;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].param.Length = (nCurrentOutputItemInfoIndex + 1);
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].param[nCurrentOutputItemInfoIndex] = param;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList.Length = (nCurrentOutputItemInfoIndex + 1);
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList[nCurrentOutputItemInfoIndex] = Info;
	return;
}

function HandelMultiSellInputItemInfo(string param)
{
	local int nMultiSellInfoID, nCurrentInputItemInfoIndex, nItemClassID;
	local ItemInfo Info;
	local int nIsBlessedItem, ensoulNormalSlot, ensoulBmSlot;

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
	ParseInt(param, "Attribution", Info.Attribution);
	ParseInt(param, ("EnsoulOptionNum_" $ string(2)), ensoulBmSlot);
	ParseInt(param, ("EnsoulOptionNum_" $ string(1)), ensoulNormalSlot);
	addEnsoulInfo(2, ensoulBmSlot, param, Info);
	addEnsoulInfo(1, ensoulNormalSlot, param, Info);
	ParseInt(param, "IsBlessedItem", nIsBlessedItem);
	Info.IsBlessedItem = numToBool(nIsBlessedItem);
	ParseInt(param, "BlessBaseEffectID", Info.BlessBaseEffectID);
	if((m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID != nMultiSellInfoID))
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
	else
	{
		Info.Name = Class'NWindow.UIDATA_ITEM'.static.GetItemName(Info.Id);
	}
	Info.ItemType = Class'NWindow.UIDATA_ITEM'.static.GetItemDataType(Info.Id);
	Info.CrystalType = Class'NWindow.UIDATA_ITEM'.static.GetItemCrystalType(Info.Id);
	if((nItemClassID != -400))
	{
		nCurrentInputItemInfoIndex = m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList.Length;
		m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList.Length = (nCurrentInputItemInfoIndex + 1);
		m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList[nCurrentInputItemInfoIndex] = Info;
	}
	return;
}

function HandleMultiSellInfoListEnd(string param)
{
	local WindowHandle m_inventoryWnd;

	m_inventoryWnd = GetWindowHandle("InventoryWnd");
	if(m_inventoryWnd.IsShowWindow())
	{
		m_inventoryWnd.HideWindow();
	}
	ShowWindow("TokenTradeWnd");
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus("TokenTradeWnd");
	ShowItemList();
	return;
}

function ShowItemList()
{
	local ItemInfo Info;
	local int i;
	local string treeName;
	local bool bDrawBgTree;
	local string setTreeName, strRetName, itemAllName;
	local bool bIsSetLastIndex;

	bIsSetLastIndex = false;
	treeName = "TokenTradeWnd.ItemTypeTree";
	TreeClear(treeName);
	util.TreeInsertRootNode(treeName, "Root", "", 0, 0);
	setTreeName = "Root";
	i = 0;
	while((i < m_MultiSellInfoList.Length))
	{
		Info = m_MultiSellInfoList[i].OutputItemInfoList[0];
		strRetName = util.TreeInsertItemTooltipSimpleNode(treeName, string(i), setTreeName, -7, 0, 38, 0, 30, 38);
		if(bDrawBgTree)
		{
			util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CH3.etc.textbackline", 245, 38, , , , , 14);
		}
		else
		{
			util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CT1.EmptyBtn", 245, 38);
		}
		bDrawBgTree = !bDrawBgTree;
		util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -244, 2);
		util.TreeInsertTextureNodeItem(treeName, strRetName, Info.IconName, 32, 32, -34, 3);
		if((Info.Enchanted > 0))
		{
			lvTextureTreeEnchantedTexture(treeName, strRetName, Info.Enchanted, -34, 27);
			util.TreeInsertTextMultiNodeItem(treeName, strRetName, "", 18, 0, 18, COLOR_DEFAULT);
		}
		if((Info.Enchanted > 0))
		{
			itemAllName = (((("+" $ string(Info.Enchanted)) @ Info.Name) @ Info.AdditionalName) @ GetEnsoulOptionNameAll(Info));
		}
		else
		{
			itemAllName = ((Info.Name @ Info.AdditionalName) @ GetEnsoulOptionNameAll(Info));
		}
		util.TreeInsertTextMultiNodeItem(treeName, strRetName, itemAllName, 4, 0, 38, COLOR_DEFAULT);
		if((lastSelectNitemID == m_MultiSellInfoList[i].MultiSellInfoID))
		{
			if((bIsSetLastIndex == false))
			{
				bIsSetLastIndex = true;
				lastSelectIndex = i;
			}
		}
		++i;
	}
	if(((lastSelectNitemID > 0) && (lastSelectIndex > 0)))
	{
		ItemTypeTree.SetExpandedNode(("Root." $ string(lastSelectIndex)), true);
		Me.SetTimer(12131212, 50);
	}
	else if((m_MultiSellInfoList.Length > 0))
	{
		ItemTypeTree.SetExpandedNode("Root.0", true);
		SelectChangeItem(0);
		ItemTypeTree.SetScrollPosition(0);
	}
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 12131212))
	{
		SelectChangeItem(lastSelectIndex);
		Me.KillTimer(12131212);
	}
	return;
}

function SelectChangeItem(int Num)
{
	local ItemInfo Info;
	local LVDataRecord Record;
	local string strParam;
	local int i, ensoulBmSlot, ensoulNormalSlot;
	local string enchantedStr;
	local float hiddenSortNum;

	Debug(("lastSelectIndex" @ string(lastSelectIndex)));
	TradePossibleListCtrl.DeleteAllItem();
	i = 1;
	while((i < m_MultiSellInfoList[Num].OutputItemInfoList.Length))
	{
		Info = m_MultiSellInfoList[Num].OutputItemInfoList[i];
		if((Info.Enchanted <= 0))
		{
			enchantedStr = "";
		}
		else
		{
			enchantedStr = (("+" $ string(Info.Enchanted)) $ " ");
		}
		strParam = m_MultiSellInfoList[Num].param[i];
		ParamAdd(strParam, "name", Info.Name);
		ParamAdd(strParam, "WeaponType", string(Info.WeaponType));
		ParamAdd(strParam, "Enchanted", string(Info.Enchanted));
		ParamAdd(strParam, "Weight", string(Info.Weight));
		ParamAdd(strParam, "Description", Info.Description);
		ParamAdd(strParam, "IconName", Info.IconName);
		ParamAdd(strParam, "SoulshotCount", string(Info.SoulshotCount));
		ParamAdd(strParam, "SpiritshotCount", string(Info.SpiritshotCount));
		ParamAdd(strParam, "CrystalType", string(Info.CrystalType));
		ParamAdd(strParam, "AdditionalName", Info.AdditionalName);
		ParamAdd(strParam, "pAttack", string(Info.pAttack));
		ParamAdd(strParam, "mAttack", string(Info.mAttack));
		ParamAdd(strParam, "pCriRate", string(Info.pCriRate));
		ParamAdd(strParam, "mCriRate", string(Info.mCriRate));
		ParamAdd(strParam, "pAttackSpeed", string(Info.pAttackSpeed));
		ParamAdd(strParam, "mAttackSpeed", string(Info.mAttackSpeed));
		ParamAdd(strParam, "pDefense", string(Info.pDefense));
		ParamAdd(strParam, "ShieldDefense", string(Info.ShieldDefense));
		ParamAdd(strParam, "pAvoid", string(Info.pAvoid));
		ParamAdd(strParam, "ArmorType", string(Info.ArmorType));
		ParamAdd(strParam, "mDefense", string(Info.mDefense));
		ParamAdd(strParam, "Attribution", string(Info.Attribution));
		ParseInt(strParam, ("EnsoulOptionNum_" $ string(2)), ensoulBmSlot);
		ParseInt(strParam, ("EnsoulOptionNum_" $ string(1)), ensoulNormalSlot);
		addEnsoulInfo(2, ensoulBmSlot, strParam, Info);
		addEnsoulInfo(1, ensoulNormalSlot, strParam, Info);
		Record.szReserved = strParam;
		Record.LVDataList.Length = 2;
		if((Info.Enchanted > 0))
		{
			Record.LVDataList[0].szData = (((("+" $ string(Info.Enchanted)) @ Info.Name) @ Info.AdditionalName) @ GetEnsoulOptionNameAll(Info));
		}
		else
		{
			Record.LVDataList[0].szData = ((Info.Name @ Info.AdditionalName) @ GetEnsoulOptionNameAll(Info));
		}
		Record.LVDataList[0].hasIcon = true;
		Record.LVDataList[0].nTextureWidth = 32;
		Record.LVDataList[0].nTextureHeight = 32;
		Record.LVDataList[0].nTextureU = 32;
		Record.LVDataList[0].nTextureV = 32;
		Record.LVDataList[0].szTexture = Info.IconName;
		Record.LVDataList[0].IconPosX = 4;
		Record.LVDataList[0].FirstLineOffsetX = 6;
		Record.LVDataList[0].iconBackTexName = "l2ui_ct1.ItemWindow_DF_SlotBox_Default";
		Record.LVDataList[0].backTexOffsetXFromIconPosX = -2;
		Record.LVDataList[0].backTexOffsetYFromIconPosY = -1;
		Record.LVDataList[0].backTexWidth = 36;
		Record.LVDataList[0].backTexHeight = 36;
		Record.LVDataList[0].backTexUL = 36;
		Record.LVDataList[0].backTexVL = 36;
		if((Info.Enchanted > 0))
		{
			Record.LVDataList[0].arrTexture.Length = 3;
			lvTextureAddItemEnchantedTexture(Info.Enchanted, Record.LVDataList[0].arrTexture[0], Record.LVDataList[0].arrTexture[1], Record.LVDataList[0].arrTexture[2], 9, 11);
		}
		Record.LVDataList[0].AttrColor.R = 200;
		Record.LVDataList[0].AttrColor.G = 200;
		Record.LVDataList[0].AttrColor.B = 200;
		Record.LVDataList[0].AttrStat[0] = ("x" $ string(Info.ItemNum));
		Record.LVDataList[1].bUseTextColor = true;
		if((float(m_MultiSellInfoList[Num].Per[i]) > 30.0000000))
		{
			Record.LVDataList[1].TextColor = util.Token0;
		}
		else if(((float(m_MultiSellInfoList[Num].Per[i]) <= 30.0000000) && (float(m_MultiSellInfoList[Num].Per[i]) >= 11.0000000)))
		{
			Record.LVDataList[1].TextColor = util.Token1;
		}
		else if(((float(m_MultiSellInfoList[Num].Per[i]) <= 10.0000000) && (float(m_MultiSellInfoList[Num].Per[i]) >= 5.0000000)))
		{
			Record.LVDataList[1].TextColor = util.Token2;
		}
		else
		{
			Record.LVDataList[1].TextColor = util.Token3;
		}
		hiddenSortNum = (float(m_MultiSellInfoList[Num].Per[i]) * 1000000.0000000);
		Record.LVDataList[1].HiddenStringForSorting = getInstanceL2Util().makeZeroString(12, INT64(int(hiddenSortNum)));
		Record.LVDataList[1].szData = getInstanceL2Util().CutFloatIntByString(m_MultiSellInfoList[Num].Per[i]);
		Record.LVDataList[1].textAlignment = TA_Center;
		TradePossibleListCtrl.InsertRecord(Record);
		++i;
	}
	needItemUpdate(Num);
	return;
}

function needItemUpdate(int Num)
{
	local bool bDrawBgTree;
	local string treeName, setTreeName, strRetName, strNeed;
	local ItemInfo infoNeed, tempInfo;
	local int i;

	lastSelectIndex = Num;
	treeName = "TokenTradeWnd.NeedItemTree";
	TreeClear(treeName);
	util.TreeInsertRootNode(treeName, "Need", "", 0, 2);
	setTreeName = "Need";
	i = 0;
	while((i < m_MultiSellInfoList[Num].InputItemInfoList.Length))
	{
		infoNeed = m_MultiSellInfoList[Num].InputItemInfoList[i];
		strRetName = util.TreeInsertItemNode(treeName, string(i), setTreeName, false, -6, -2);
		if(bDrawBgTree)
		{
			util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CH3.etc.textbackline", 545, 38, , , , , 14);
		}
		else
		{
			util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CT1.EmptyBtn", 545, 38);
		}
		bDrawBgTree = !bDrawBgTree;
		util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -538, 2);
		switch(infoNeed.Id.ClassID)
		{
			case 57:
				util.TreeInsertTextureNodeItem(treeName, strRetName, infoNeed.IconName, 32, 32, -34, 3);
				util.TreeInsertTextNodeItem(treeName, strRetName, infoNeed.Name, 5, 6, COLOR_DEFAULT, true);
				strNeed = ((((("x" $ string(infoNeed.ItemNum)) $ " / ") $ GetSystemString(2035)) $ " ") $ string(GetInventoryItemCount(infoNeed.Id)));
				util.TreeInsertTextNodeItem(treeName, strRetName, strNeed, 48, -18, COLOR_GRAY, , true);
				break;
			default:
				util.TreeInsertTextureNodeItem(treeName, strRetName, infoNeed.IconName, 32, 32, -34, 3);
				Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(infoNeed.Id.ClassID), tempInfo);
				if((tempInfo.IconPanel != ""))
				{
					util.TreeInsertTextureNodeItem(treeName, strRetName, tempInfo.IconPanel, 32, 32, -34, 3);
				}
				if((infoNeed.Enchanted > 0))
				{
					lvTextureTreeEnchantedTexture(treeName, strRetName, infoNeed.Enchanted, -34, 27);
					util.TreeInsertTextMultiNodeItem(treeName, strRetName, "", 18, 0, 18, COLOR_DEFAULT);
				}
				util.TreeInsertTextNodeItem(treeName, strRetName, (infoNeed.Name @ infoNeed.AdditionalName), 5, 6, COLOR_DEFAULT, true, , infoNeed.Id.ClassID);
				strNeed = ((((("x" $ string(infoNeed.ItemNum)) $ " / ") $ GetSystemString(2035)) $ " ") $ string(GetInventoryItemCountFilter(infoNeed.Id.ClassID)));
				util.TreeInsertTextNodeItem(treeName, strRetName, strNeed, 48, -18, COLOR_GRAY, , true);
		}
		++i;
	}
	return;
}

function TreeClear(string Str)
{
	Class'NWindow.UIAPI_TREECTRL'.static.Clear(Str);
	return;
}

function Clear()
{
	TreeClear("TokenTradeWnd.ItemTypeTree");
	TreeClear("TokenTradeWnd.NeedItemTree");
	TradePossibleListCtrl.DeleteAllItem();
	m_nCurrentMultiSellInfoIndex = 0;
	m_MultiSellInfoList.Length = 0;
	m_MultiSellGroupID = 0;
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

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	OnCancelBtnClick();
	return;
}
