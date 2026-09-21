class RestartMenuWndReportLostItem extends UICommonAPI;

struct DieInfoDropItemData
{
	var int ItemClassID;
	var int itemEnchant;
	var int ItemAmount;
};

var string m_Windowname;
var WindowHandle Me;
var RichListCtrlHandle itemListCtrl;
var ButtonHandle CloseBtn;
var L2Util util;

function Initialize()
{
	Me = GetWindowHandle(m_Windowname);
	itemListCtrl = GetRichListCtrlHandle((m_Windowname $ ".RestartmenuWndReport_ListCtrl"));
	CloseBtn = GetButtonHandle((m_Windowname $ ".CloseBtn"));
	util = L2Util(GetScript("L2Util"));
	itemListCtrl.SetSelectedSelTooltip(false);
	itemListCtrl.SetAppearTooltipAtMouseX(true);
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(11160);
	RegisterEvent(11163);
	RegisterEvent(11161);
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case 11160:
			handleDieInfoBegin();
			break;
		case 11161:
			handleDieInfoDropitem(param);
			break;
		case 11163:
			handleDieInfoEnd();
			break;
		default:
			break;
	}
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "minCloseButton":
		case "CloseBtn":
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function handleDieInfoBegin()
{
	itemListCtrl.DeleteAllItem();
	return;
}

function handleDieInfoEnd()
{
	return;
}

function handleDieInfoDropitem(string param)
{
	local ItemID cID;
	local RichListCtrlRowData rowData;
	local DieInfoDropItemData Data;
	local ItemInfo Info;
	local string ItemName, IconName;
	local int tW, tH;

	rowData.cellDataList.Length = 1;
	Data = GetDieInfoLostItem(param);
	cID.ClassID = Data.ItemClassID;
	Info = GetItemInfoByClassID(Data.ItemClassID);
	ItemName = GetItemNameAll(Info);
	IconName = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(cID);
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, 0);
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, IconName, 32, 32, -34, 2);
	if((Data.itemEnchant < 1))
	{
		AddEllipsisString(rowData.cellDataList[0].drawitems, ItemName, 290, getInstanceL2Util().BrightWhite, false, true, 3, 9);
	}
	else
	{
		addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_CT1.ENCHANTNUMBER_SMALL_plus", 6, 8, -34, 24);
		if((Data.itemEnchant < 10))
		{
			addRichListCtrlTexture(rowData.cellDataList[0].drawitems, ("L2UI_CT1.ENCHANTNUMBER_SMALL_" $ string(Data.itemEnchant)), 6, 8, 0, 0);
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, ("+" $ string(Data.itemEnchant)), GetColor(170, 110, 230, 255), false, 26, -14);
		}
		else
		{
			addRichListCtrlTexture(rowData.cellDataList[0].drawitems, ("L2UI_CT1.ENCHANTNUMBER_SMALL_" $ string((Data.itemEnchant / 10))), 6, 8, 0, 0);
			addRichListCtrlTexture(rowData.cellDataList[0].drawitems, ("L2UI_CT1.ENCHANTNUMBER_SMALL_" $ string(int((float(Data.itemEnchant) % 10.0000000)))), 6, 8, 0, 0);
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, ("+" $ string(Data.itemEnchant)), GetColor(170, 110, 230, 255), false, 20, -14);
		}
		GetTextSizeDefault(("+" $ string(Data.itemEnchant)), tW, tH);
		AddEllipsisString(rowData.cellDataList[0].drawitems, ItemName, (288 - tW), getInstanceL2Util().BrightWhite, false, true, 5);
	}
	if(IsStackableItem(Info.ConsumeType))
	{
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, ("x" $ string(Data.ItemAmount)), GetColor(200, 170, 120, 255), false, 5, 0);
	}
	itemListCtrl.InsertRecord(rowData);
	return;
}

function Color GetColor(int R, int G, int B, int A)
{
	local Color tColor;

	tColor.R = byte(R);
	tColor.G = byte(G);
	tColor.B = byte(B);
	tColor.A = byte(A);
	return tColor;
}

function DieInfoDropItemData GetDieInfoLostItem(string param)
{
	local DieInfoDropItemData Data;

	ParseInt(param, "ItemClassID", Data.ItemClassID);
	ParseInt(param, "ItemEnchant", Data.itemEnchant);
	ParseInt(param, "ItemAmount", Data.ItemAmount);
	return Data;
}

function lvTextureAddItemEnchantedTexture(int nEnchanted, out LVTexture lvTexture1, out LVTexture lvTexture2, out LVTexture lvTexture3, int X, int Y)
{
	local string s1, S2, ss;

	if((nEnchanted > 0))
	{
		lvTextureAdd(lvTexture1, "L2UI_CT1.ENCHANTNUMBER_SMALL_plus", X, Y, 6, 8);
	}
	if((nEnchanted > 9))
	{
		ss = string(nEnchanted);
		s1 = Left(ss, 1);
		S2 = Right(ss, 1);
		lvTextureAdd(lvTexture2, ("L2UI_CT1.ENCHANTNUMBER_SMALL_" $ s1), (X + 6), Y, 6, 8);
		lvTextureAdd(lvTexture3, ("L2UI_CT1.ENCHANTNUMBER_SMALL_" $ S2), (X + 12), Y, 6, 8);
	}
	else if(((nEnchanted > 0) && (nEnchanted < 10)))
	{
		lvTextureAdd(lvTexture2, ("L2UI_CT1.ENCHANTNUMBER_SMALL_" $ string(nEnchanted)), (X + 6), Y, 6, 8);
	}
	return;
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="RestartMenuWndReportLostItem"
}
