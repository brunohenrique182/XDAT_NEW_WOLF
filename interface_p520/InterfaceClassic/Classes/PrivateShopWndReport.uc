class PrivateShopWndReport extends UICommonAPI;

const STRINGNUM_SALE_TITLE = 500;
const STRINGNUM_BUY_TITLE = 499;
const STRINGNUM_SALE_BULK_TITLE = 1273;

var WindowHandle Me;
var L2Util util;
var ListCtrlHandle ItemList_ListCtrl;
var ButtonHandle Edit_Btn;
var ButtonHandle StopSell_Btn;
var ButtonHandle EditorSetting_Btn;
var ButtonHandle history_Btn;
var array<ItemInfo> getItemInfoArray;
var array<INT64> getItemNumArray;
var array<int> buyItemServerIDArray;
var array<INT64> buyItemNumArray;
var array<string> buyUserNameArray;
var InventoryWnd inventoryWndScript;
var EditBoxHandle SignEditInput_Edit;
var TextBoxHandle SignEditInput_Txt;
var TextBoxHandle SignEditInput_guide;
var TextBoxHandle privateShopTitle_Txt;
var TextBoxHandle Benefit_Input1_Txt;
var TextBoxHandle Benefit_Input2_Txt;
var TextBoxHandle BenefitTitle1_Txt;
var TextBoxHandle BenefitTitle2_Txt;
var PrivateShopWnd privateShopScript;
var string messagetype;
var PrivateShopWndHistory PrivateShopWndHistoryScript;
var bool m_IsPrivateStoreBypass;
var TextureHandle SignEditBox_Tex;
var TextureHandle SignEditDeco_Tex;

event OnRegisterEvent()
{
	RegisterEvent(2610);
	RegisterEvent(10220);
	RegisterEvent(10221);
	return;
}

event OnLoad()
{
	Initialize();
	return;
}

event OnShow()
{
	messagetype = getCurrentMessageType();
	Edit_Btn.EnableWindow();
	UpdateList();
	setPrivateShopMessageText();
	Me.SetFocus();
	GetWindowHandle("PetWnd").HideWindow();
	return;
}

event OnHide()
{
	Init();
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "StopSell_Btn":
			if(!checkShoppingEnd())
			{
				privateShopScript.stopSellFlag = true;
			}
		case "Edit_Btn":
			handleQuit();
			break;
		case "history_Btn":
			Onhistory_BtnClick();
			break;
		case "EditorSetting_Btn":
			togglePrivateShopEditor();
			break;
		default:
			break;
	}
	return;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	if(((a_WindowHandle == SignEditInput_guide) || (a_WindowHandle == SignEditInput_Txt)))
	{
		showPrivateShopEditor();
	}
	return;
}

event OnEvent(int a_EventID, string a_Param)
{
	if(!Me.IsShowWindow())
	{
		return;
	}
	switch(a_EventID)
	{
		case 2610:
			if((buyItemServerIDArray.Length > 0))
			{
				handleinventoryUpdateResult(a_Param);
			}
			break;
		case 10220:
			HandleBuyResult(a_Param);
			break;
		case 10221:
			handleSellingResult(a_Param);
			break;
		default:
			break;
	}
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	if(SignEditInput_Edit.IsFocused())
	{
		if(m_IsPrivateStoreBypass)
		{
			return false;
		}
		if((int(nKey) == 13))
		{
			togglePrivateShopEditor();
		}
		else if((int(nKey) == 27))
		{
			hidePrivateShopwEditor();
		}
	}
	return false;
}

function Initialize()
{
	Me = GetWindowHandle("PrivateShopWndReport");
	ItemList_ListCtrl = GetListCtrlHandle("PrivateShopWndReport.ItemList_ListCtrl");
	StopSell_Btn = GetButtonHandle("PrivateShopWndReport.StopSell_Btn");
	Edit_Btn = GetButtonHandle("PrivateShopWndReport.Edit_Btn");
	history_Btn = GetButtonHandle("PrivateShopWndReport.history_Btn");
	EditorSetting_Btn = GetButtonHandle("PrivateShopWndReport.EditorSetting_Btn");
	util = L2Util(GetScript("L2Util"));
	inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
	privateShopTitle_Txt = GetTextBoxHandle("PrivateShopWndReport.privateShopTitle_Txt");
	SignEditInput_Txt = GetTextBoxHandle("PrivateShopWndReport.SignEditInput_Txt");
	SignEditInput_guide = GetTextBoxHandle("PrivateShopWndReport.SignEditInput_guide");
	SignEditInput_Edit = GetEditBoxHandle("PrivateShopWndReport.SignEditInput_Edit");
	Benefit_Input1_Txt = GetTextBoxHandle("PrivateShopWndReport.Benefit_Input1_Txt");
	Benefit_Input2_Txt = GetTextBoxHandle("PrivateShopWndReport.Benefit_Input2_Txt");
	BenefitTitle1_Txt = GetTextBoxHandle("PrivateShopWndReport.BenefitTitle1_Txt");
	BenefitTitle2_Txt = GetTextBoxHandle("PrivateShopWndReport.BenefitTitle2_Txt");
	PrivateShopWndHistoryScript = PrivateShopWndHistory(GetScript("PrivateShopWndHistory"));
	ItemList_ListCtrl.SetSelectedSelTooltip(false);
	ItemList_ListCtrl.SetAppearTooltipAtMouseX(true);
	privateShopScript = PrivateShopWnd(GetScript("PrivateShopWnd"));
	SignEditInput_guide.SetText(GetSystemMessage(334));
	Init();
	m_IsPrivateStoreBypass = IsPrivateStoreBypass();
	if(m_IsPrivateStoreBypass)
	{
		EditorSetting_Btn.HideWindow();
		history_Btn.HideWindow();
		SignEditInput_Txt.HideWindow();
		SignEditInput_guide.HideWindow();
		SignEditInput_Edit.HideWindow();
		SignEditBox_Tex = GetTextureHandle("PrivateShopWndReport.SignEditBox_Tex");
		SignEditDeco_Tex = GetTextureHandle("PrivateShopWndReport.SignEditDecoPen_Tex");
		SignEditBox_Tex.HideWindow();
		SignEditDeco_Tex.HideWindow();
	}
	return;
}

function Init()
{
	getItemInfoArray.Length = 0;
	getItemNumArray.Length = 0;
	buyItemServerIDArray.Length = 0;
	buyItemNumArray.Length = 0;
	buyUserNameArray.Length = 0;
	ItemList_ListCtrl.DeleteAllItem();
	hidePrivateShopwEditor();
	return;
}

function HandleBuyResult(string param)
{
	local int ServerID;
	local INT64 Amount;
	local string UserName;

	ParseInt(param, "ItemID", ServerID);
	buyItemServerIDArray.Length = (buyItemServerIDArray.Length + 1);
	buyItemServerIDArray[(buyItemServerIDArray.Length - 1)] = ServerID;
	ParseINT64(param, "Amount", Amount);
	buyItemNumArray.Length = (buyItemNumArray.Length + 1);
	buyItemNumArray[(buyItemNumArray.Length - 1)] = Amount;
	ParseString(param, "CharName", UserName);
	buyUserNameArray.Length = (buyUserNameArray.Length + 1);
	buyUserNameArray[(buyUserNameArray.Length - 1)] = UserName;
	return;
}

function handleSellingResult(string param)
{
	local int ServerID;
	local INT64 Amount;
	local string UserName;

	ParseInt(param, "ItemID", ServerID);
	ParseINT64(param, "Amount", Amount);
	ParseString(param, "CharName", UserName);
	findNModifyRecord(ServerID, Amount, UserName);
	return;
}

function handleinventoryUpdateResult(string param)
{
	local int Count, i, Index;
	local ItemInfo updatedItemInfo;
	local LVDataRecord Record;
	local bool isSame, isStackable;

	ParamToItemInfo(param, updatedItemInfo);
	i = 0;
	while((i < buyItemServerIDArray.Length))
	{
		if((buyItemServerIDArray[i] == updatedItemInfo.Id.ServerID))
		{
			Count = 0;
			while((Count < ItemList_ListCtrl.GetRecordCount()))
			{
				ItemList_ListCtrl.GetRec(Count, Record);
				Index = int(Record.nReserved3);
				if((getItemNumArray[Index] != getItemInfoArray[Index].ItemNum))
				{
					isStackable = IsStackableItem(updatedItemInfo.ConsumeType);
					if((updatedItemInfo.Id.ClassID == getItemInfoArray[Index].Id.ClassID))
					{
						if(isStackable)
						{
							isSame = true;
						}
						else
						{
							isSame = compareItem(getItemInfoArray[Index], updatedItemInfo);
						}
					}
					if(isSame)
					{
						Record = getModifyRecord(Record, buyItemNumArray[i]);
						ItemList_ListCtrl.ModifyRecord(Count, Record);
						PrivateShopWndHistoryScript.addHistory(Record.LVDataList[0].szData, isStackable, buyItemNumArray[i], buyUserNameArray[i]);
						setCurrentTotalPrice();
						buyItemServerIDArray.Remove(i, 1);
						buyItemNumArray.Remove(i, 1);
						buyUserNameArray.Remove(i, 1);
						if(checkShoppingEnd())
						{
							Edit_Btn.DisableWindow();
						}
						return;
					}
				}
				Count++;
			}
		}
		i++;
	}
	return;
}

function LVDataRecord getModifyRecord(LVDataRecord Record, INT64 Amount)
{
	local int Index;

	Index = int(Record.nReserved3);
	getItemNumArray[Index] = (getItemNumArray[Index] + Amount);
	Record.LVDataList[0] = makeItemNameRecord(Record, getItemNumArray[Index]);
	Record.LVDataList[1] = makeItemNumRecord(Record, getItemNumArray[Index]);
	Record.LVDataList[2] = makeItemPriceRecord(Record, getItemNumArray[Index]);
	Record.LVDataList[3] = makeItemTotalPrice(Record, getItemNumArray[Index]);
	return Record;
}

function findNModifyRecord(int ServerID, INT64 Amount, string UserName)
{
	local int Count;
	local LVDataRecord Record;

	getBuyItemInfo(ServerID);
	Count = 0;
	while((Count < ItemList_ListCtrl.GetRecordCount()))
	{
		ItemList_ListCtrl.GetRec(Count, Record);
		if((Record.nReserved1 == INT64(ServerID)))
		{
			Record = getModifyRecord(Record, Amount);
			ItemList_ListCtrl.ModifyRecord(Count, Record);
			PrivateShopWndHistoryScript.addHistory(Record.LVDataList[0].szData, Record.LVDataList[2].hasIcon, Amount, UserName);
			setCurrentTotalPrice();
			if(checkShoppingEnd())
			{
				Edit_Btn.DisableWindow();
			}
			return;
		}
		Count++;
	}
	return;
}

function getBuyItemInfo(int ServerID)
{
	local ItemInfo ResourceInfo;
	local ItemID pItemID;

	pItemID.ServerID = ServerID;
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(pItemID, ResourceInfo);
	return;
}

function startOpenPrivateShop(string param)
{
	Me.ShowWindow();
	return;
}

function string getCurrentMessageType()
{
	switch(privateShopScript.m_type)
	{
		case PT_SellList:
			if(privateShopScript.m_bBulk)
			{
				return "bulksell";
			}
			else
			{
				return "sell";
			}
			break;
		case PT_BuyList:
			return "buy";
			break;
		default:
			break;
	}
	return "";
}

function handleGuideMessage()
{
	if(m_IsPrivateStoreBypass)
	{
		return;
	}
	if((SignEditInput_Txt.GetText() == ""))
	{
		SignEditInput_guide.ShowWindow();
	}
	else
	{
		SignEditInput_guide.HideWindow();
	}
	return;
}

function togglePrivateShopEditor()
{
	if(m_IsPrivateStoreBypass)
	{
		return;
	}
	if(SignEditInput_Edit.IsShowWindow())
	{
		if(((GetPrivateShopMessage(messagetype) != SignEditInput_Edit.GetString()) && ("" != SignEditInput_Edit.GetString())))
		{
			SetPrivateShopMessage(messagetype, SignEditInput_Edit.GetString());
			SignEditInput_Txt.SetText(SignEditInput_Edit.GetString());
			handleGuideMessage();
		}
		hidePrivateShopwEditor();
	}
	else
	{
		showPrivateShopEditor();
	}
	return;
}

function showPrivateShopEditor()
{
	if(m_IsPrivateStoreBypass)
	{
		return;
	}
	SignEditInput_Txt.HideWindow();
	SignEditInput_Edit.ShowWindow();
	SignEditInput_Edit.SetString(GetPrivateShopMessage(messagetype));
	SignEditInput_Edit.SetFocus();
	SignEditInput_guide.HideWindow();
	EditorSetting_Btn.SetTexture("L2UI_CT1.Button.completeBtn_df", "L2UI_CT1.Button.completeBtn_down", "L2UI_CT1.Button.completeBtn_over");
	return;
}

function hidePrivateShopwEditor()
{
	if(m_IsPrivateStoreBypass)
	{
		return;
	}
	SignEditInput_Txt.ShowWindow();
	SignEditInput_Edit.HideWindow();
	EditorSetting_Btn.SetTexture("L2UI_CT1.Button.SettingBtn_n", "L2UI_CT1.Button.SettingBtn_d", "L2UI_CT1.Button.SettingBtn_o");
	return;
}

function setPrivateShopMessageText()
{
	local string shopTitle;
	local Color messageColor;

	switch(messagetype)
	{
		case "bulksell":
			messageColor = GetColor(255, 119, 119, 255);
			shopTitle = GetSystemString(1273);
			ItemList_ListCtrl.SetColumnString(2, 2502);
			ItemList_ListCtrl.SetColumnString(3, 3591);
			BenefitTitle1_Txt.SetText(GetSystemString(3593));
			BenefitTitle2_Txt.SetText(GetSystemString(3595));
			break;
		case "sell":
			messageColor = GetColor(221, 119, 238, 255);
			shopTitle = GetSystemString(500);
			ItemList_ListCtrl.SetColumnString(2, 2502);
			ItemList_ListCtrl.SetColumnString(3, 3591);
			BenefitTitle1_Txt.SetText(GetSystemString(3593));
			BenefitTitle2_Txt.SetText(GetSystemString(3595));
			break;
		case "buy":
			messageColor = GetColor(170, 204, 17, 255);
			shopTitle = GetSystemString(499);
			ItemList_ListCtrl.SetColumnString(2, 3590);
			ItemList_ListCtrl.SetColumnString(3, 3592);
			BenefitTitle1_Txt.SetText(GetSystemString(3594));
			BenefitTitle2_Txt.SetText(GetSystemString(3596));
			break;
		default:
			break;
	}
	privateShopTitle_Txt.SetText(shopTitle);
	privateShopTitle_Txt.SetTextColor(messageColor);
	if(!m_IsPrivateStoreBypass)
	{
		SignEditInput_Txt.SetTextColor(messageColor);
		SignEditInput_Txt.SetText(GetPrivateShopMessage(messagetype));
	}
	handleGuideMessage();
	return;
}

function externalAddItem(ItemInfo addItemInfo)
{
	local int Len, i;

	if((int(privateShopScript.m_type) == 3))
	{
		if(!IsStackableItem(addItemInfo.ConsumeType))
		{
			i = 0;
			while((i < getItemInfoArray.Length))
			{
				if((getItemInfoArray[i].Id.ClassID == addItemInfo.Id.ClassID))
				{
					if(compareItem(getItemInfoArray[i], addItemInfo))
					{
						if((addItemInfo.Price != getItemInfoArray[i].Price))
						{
							return;
						}
					}
				}
				i++;
			}
		}
	}
	Len = (getItemInfoArray.Length + 1);
	getItemInfoArray.Length = Len;
	getItemInfoArray[(Len - 1)] = addItemInfo;
	getItemNumArray.Length = Len;
	getItemNumArray[(Len - 1)] = INT64(0);
	if(Me.IsShowWindow())
	{
		UpdateList();
	}
	return;
}

function UpdateList()
{
	local int i;

	ItemList_ListCtrl.DeleteAllItem();
	if((getItemInfoArray.Length > 0))
	{
		i = 0;
		while((i < getItemInfoArray.Length))
		{
			if((getItemInfoArray[i].Id.ClassID != 57))
			{
				AddItem(i);
			}
			i++;
		}
	}
	setCurrentTotalPrice();
	return;
}

function setCurrentTotalPrice()
{
	local int Count, Index;
	local INT64 ItemNum, Price, currentPrice, totalprice;
	local LVDataRecord Record;

	currentPrice = INT64(0);
	totalprice = INT64(0);
	Count = 0;
	while((Count < ItemList_ListCtrl.GetRecordCount()))
	{
		ItemList_ListCtrl.GetRec(Count, Record);
		Index = int(Record.nReserved3);
		Price = getItemInfoArray[Index].Price;
		ItemNum = Record.nReserved2;
		(currentPrice += (getItemNumArray[Index] * Price));
		(totalprice += (ItemNum * Price));
		Benefit_Input1_Txt.SetText(ConvertNumToTextNoAdena(string(currentPrice)));
		Benefit_Input2_Txt.SetText(ConvertNumToTextNoAdena(string((totalprice - currentPrice))));
		if((Benefit_Input1_Txt.GetText() == ""))
		{
			Benefit_Input1_Txt.SetText("0");
		}
		if((Benefit_Input2_Txt.GetText() == ""))
		{
			Benefit_Input2_Txt.SetText("0");
		}
		Count++;
	}
	return;
}

function LVData makeItemTotalPrice(LVDataRecord Record, INT64 ItemNum)
{
	local INT64 Price, totalprice;
	local string costString;

	Price = getItemInfoArray[int(Record.nReserved3)].Price;
	totalprice = (Price * ItemNum);
	costString = MakeCostString(string(totalprice));
	Record.LVDataList[3].bUseTextColor = true;
	if((ItemNum == Record.nReserved2))
	{
		Record.LVDataList[3].TextColor = GetColor(120, 120, 120, 255);
	}
	else
	{
		Record.LVDataList[3].TextColor = GetNumericColor(costString);
	}
	Record.LVDataList[3].szData = ConvertNumToTextNoAdena(string(totalprice));
	return Record.LVDataList[3];
}

function LVData makeItemPriceRecord(LVDataRecord Record, INT64 ItemNum)
{
	local INT64 Price, remainingItemNum, remainingItemPrice;
	local string remainingString;

	if((ItemNum == Record.nReserved2))
	{
		Record.LVDataList[2].bUseTextColor = true;
		Record.LVDataList[2].TextColor = GetColor(120, 120, 120, 255);
		Record.LVDataList[2].AttrColor = Record.LVDataList[2].TextColor;
	}
	if(Record.LVDataList[2].hasIcon)
	{
		Price = getItemInfoArray[int(Record.nReserved3)].Price;
		remainingItemNum = (Record.nReserved2 - ItemNum);
		remainingItemPrice = (remainingItemNum * Price);
		if((remainingItemNum == INT64(0)))
		{
			remainingString = "0";
		}
		else
		{
			remainingString = ConvertNumToTextNoAdena(string(remainingItemPrice));
		}
		Record.LVDataList[2].AttrStat[0] = MakeFullSystemMsg(GetSystemMessage(3657), remainingString);
	}
	return Record.LVDataList[2];
}

function LVData makeItemNumRecord(LVDataRecord Record, INT64 ItemNum)
{
	local string itemNumEasyRead;
	local UIEventManager.ELanguageType Language;

	Language = GetLanguage();
	if((Record.nReserved2 > INT64(9999)))
	{
		itemNumEasyRead = "9999+";
	}
	else
	{
		itemNumEasyRead = string(Record.nReserved2);
	}
	if((ItemNum > Record.nReserved2))
	{
		ItemNum = Record.nReserved2;
	}
	Record.LVDataList[1].szData = ((string((Record.nReserved2 - ItemNum)) $ "/") $ itemNumEasyRead);
	if((ItemNum == Record.nReserved2))
	{
		Record.LVDataList[1].bUseTextColor = true;
		Record.LVDataList[1].TextColor = GetColor(120, 120, 120, 255);
		Record.LVDataList[1].AttrColor = Record.LVDataList[1].TextColor;
		if((messagetype == "buy"))
		{
			Record.LVDataList[1].AttrStat[0] = GetSystemString(3621);
		}
		else
		{
			Record.LVDataList[1].AttrStat[0] = GetSystemString(3616);
		}
	}
	else if((messagetype == "buy"))
	{
		if(((int(Language) == 8) || (int(Language) == 9)))
		{
			Record.LVDataList[1].AttrStat[0] = ((GetSystemString(5214) $ ":") $ string(ItemNum));
		}
		else
		{
			Record.LVDataList[1].AttrStat[0] = ((GetSystemString(1434) $ ":") $ string(ItemNum));
		}
	}
	else if(((int(Language) == 8) || (int(Language) == 9)))
	{
		Record.LVDataList[1].AttrStat[0] = ((GetSystemString(5215) $ ":") $ string(ItemNum));
	}
	else
	{
		Record.LVDataList[1].AttrStat[0] = ((GetSystemString(1157) $ ":") $ string(ItemNum));
	}
	return Record.LVDataList[1];
}

function LVData makeItemNameRecord(LVDataRecord Record, INT64 ItemNum)
{
	if((ItemNum == Record.nReserved2))
	{
		Record.LVDataList[0].bUseTextColor = true;
		Record.LVDataList[0].TextColor = GetColor(120, 120, 120, 255);
		Record.LVDataList[0].iconPanelName = "L2UI_CT1.Windows.WindowDisable_BG";
		Record.LVDataList[0].panelOffsetXFromIconPosX = 0;
		Record.LVDataList[0].panelOffsetYFromIconPosY = 0;
		Record.LVDataList[0].panelWidth = 32;
		Record.LVDataList[0].panelHeight = 32;
		Record.LVDataList[0].panelUL = 32;
		Record.LVDataList[0].panelVL = 32;
	}
	return Record.LVDataList[0];
}

function LVDataRecord makeRecord(int Index)
{
	local LVDataRecord Record;
	local string param, fullNameString, costString;
	local ItemInfo Info;

	Info = getItemInfoArray[Index];
	fullNameString = GetItemNameAll(Info);
	ItemInfoToParam(Info, param);
	Record.szReserved = param;
	Record.nReserved1 = INT64(Info.Id.ServerID);
	Record.nReserved2 = Info.ItemNum;
	Record.nReserved3 = INT64(Index);
	Record.LVDataList.Length = 4;
	Record.LVDataList[0].szData = fullNameString;
	Record.LVDataList[0].hasIcon = true;
	Record.LVDataList[0].nTextureWidth = 32;
	Record.LVDataList[0].nTextureHeight = 32;
	Record.LVDataList[0].nTextureU = 32;
	Record.LVDataList[0].nTextureV = 32;
	Record.LVDataList[0].szTexture = Info.IconName;
	Record.LVDataList[0].IconPosX = 10;
	Record.LVDataList[0].FirstLineOffsetX = 6;
	Record.LVDataList[0].HiddenStringForSorting = fullNameString;
	Record.LVDataList[0].iconBackTexName = "l2ui_ct1.ItemWindow_DF_SlotBox_Default";
	Record.LVDataList[0].backTexOffsetXFromIconPosX = -2;
	Record.LVDataList[0].backTexOffsetYFromIconPosY = -1;
	Record.LVDataList[0].backTexWidth = 36;
	Record.LVDataList[0].backTexHeight = 36;
	Record.LVDataList[0].backTexUL = 36;
	Record.LVDataList[0].backTexVL = 36;
	Record.LVDataList[0].iconPanelName = Info.IconPanel;
	Record.LVDataList[0].panelOffsetXFromIconPosX = 0;
	Record.LVDataList[0].panelOffsetYFromIconPosY = 0;
	Record.LVDataList[0].panelWidth = 32;
	Record.LVDataList[0].panelHeight = 32;
	Record.LVDataList[0].panelUL = 32;
	Record.LVDataList[0].panelVL = 32;
	if(isCollectionItem(Info))
	{
		Record.LVDataList[0].foreTextureName = "L2UI_EPIC.Icon.IconPanel_coll";
		Record.LVDataList[0].panelOffsetXFromIconPosX = 0;
		Record.LVDataList[0].panelOffsetYFromIconPosY = 0;
		Record.LVDataList[0].panelWidth = 32;
		Record.LVDataList[0].panelHeight = 32;
		Record.LVDataList[0].panelUL = 32;
		Record.LVDataList[0].panelVL = 32;
	}
	if(Info.IsBlessedItem)
	{
		Record.LVDataList[0].BlessedItemIconPanelName = "Icon.icon_panel.bless_panel";
	}
	if((Info.Enchanted > 0))
	{
		Record.LVDataList[0].arrTexture.Length = 3;
		lvTextureAddItemEnchantedTexture(Info.Enchanted, Record.LVDataList[0].arrTexture[0], Record.LVDataList[0].arrTexture[1], Record.LVDataList[0].arrTexture[2], 9, 11);
	}
	Record.LVDataList[1].hasIcon = true;
	Record.LVDataList[1].AttrColor = GetColor(200, 200, 200, 255);
	Record.LVDataList[1].textAlignment = TA_Center;
	Record.LVDataList[1] = makeItemNumRecord(Record, getItemNumArray[Index]);
	costString = MakeCostString(string(Info.Price));
	Record.LVDataList[2].szData = ConvertNumToTextNoAdena(string(Info.Price));
	Record.LVDataList[2].bUseTextColor = true;
	Record.LVDataList[2].TextColor = GetNumericColor(costString);
	Record.LVDataList[2].textAlignment = TA_Right;
	Record.LVDataList[2].HiddenStringForSorting = util.makeZeroString(20, Info.Price);
	if(IsStackableItem(Info.ConsumeType))
	{
		Record.LVDataList[2].hasIcon = true;
		Record.LVDataList[2].AttrColor = GetColor(200, 200, 200, 255);
		Record.LVDataList[2].AttrStat[0] = MakeFullSystemMsg(GetSystemMessage(3657), ConvertNumToTextNoAdena(string((Info.Price * Info.ItemNum))));
		Record.LVDataList[2].textAlignment = TA_Right;
	}
	costString = MakeCostString(string((Info.Price * getItemNumArray[Index])));
	Record.LVDataList[3].bUseTextColor = true;
	Record.LVDataList[3].TextColor = GetNumericColor(costString);
	Record.LVDataList[3].szData = costString;
	Record.LVDataList[3].textAlignment = TA_Right;
	return Record;
}

function AddItem(int Index)
{
	ItemList_ListCtrl.InsertRecord(makeRecord(Index));
	return;
}

function bool checkShoppingEnd()
{
	local int i;

	i = 0;
	while((i < getItemInfoArray.Length))
	{
		if((getItemNumArray[i] != getItemInfoArray[i].ItemNum))
		{
			return false;
		}
		i++;
	}
	return true;
}

function Onhistory_BtnClick()
{
	if(m_IsPrivateStoreBypass)
	{
		return;
	}
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("PrivateShopWndHistory"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("PrivateShopWndHistory");
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("PrivateShopWndHistory");
	}
	return;
}

function handleQuit()
{
	if(!checkShoppingEnd())
	{
		privateShopScript.contextMenuQuit();
	}
	else if(!IsPlayerStand())
	{
		ExecuteCommand("/stand");
	}
	Me.HideWindow();
	return;
}

function bool compareItem(ItemInfo info1, ItemInfo info2)
{
	if(((((((((((((((((info1.Enchanted != info2.Enchanted) || (info1.Damaged != info2.Damaged)) || (info1.RefineryOp1 != info2.RefineryOp1)) || (info1.RefineryOp2 != info2.RefineryOp2)) || (info1.RefineryOp3 != info2.RefineryOp3)) || (info1.LookChangeItemID != info2.LookChangeItemID)) || (info1.AttackAttributeType != info2.AttackAttributeType)) || (info1.AttackAttributeValue != info2.AttackAttributeValue)) || (info1.DefenseAttributeValueFire != info2.DefenseAttributeValueFire)) || (info1.DefenseAttributeValueWater != info2.DefenseAttributeValueWater)) || (info1.DefenseAttributeValueWind != info2.DefenseAttributeValueWind)) || (info1.DefenseAttributeValueEarth != info2.DefenseAttributeValueEarth)) || (info1.DefenseAttributeValueHoly != info2.DefenseAttributeValueHoly)) || (info1.DefenseAttributeValueUnholy != info2.DefenseAttributeValueUnholy)) || (info1.IsBlessedItem != info2.IsBlessedItem)) || !compareParamEnSoul(info1, info2)))
	{
		return false;
	}
	return true;
}

function bool compareParamEnSoul(ItemInfo info1, ItemInfo info2)
{
	local int i, N, Cnt;

	i = 1;
	while((i < 3))
	{
		Cnt = info1.EnsoulOption[(i - 1)].OptionArray.Length;
		if((Cnt != info2.EnsoulOption[(i - 1)].OptionArray.Length))
		{
			return false;
		}
		N = 1;
		while((N < (1 + Cnt)))
		{
			if((info1.EnsoulOption[(i - 1)].OptionArray[(N - 1)] != info2.EnsoulOption[(i - 1)].OptionArray[(N - 1)]))
			{
				return false;
			}
			N++;
		}
		i++;
	}
	return true;
}
