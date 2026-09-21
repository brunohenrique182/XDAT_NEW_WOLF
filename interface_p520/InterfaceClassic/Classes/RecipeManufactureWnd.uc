class RecipeManufactureWnd extends UICommonAPI;

const RECIPEWND_MAX_MP_WIDTH = 165.0f;
const CRYSTAL_TYPE_WIDTH = 14;
const CRYSTAL_TYPE_HEIGHT = 14;
const DIALOG_STACKABLE_ITEM_REMOVE = 1230;
const DIALOG_STACKABLE_ITEM_ADD = 1240;
const DIALOG_100PER_CHECK = 1250;

var string m_Windowname;
var int m_RecipeID;
var int m_SuccessRate;
var int m_RecipeBookClass;
var bool m_MultipleProduct;
var int m_MaxMP;
var int m_PlayerID;
var int m_AddSuccRate;
var int m_CreateCritical;
var int m_CurrRate;
var BarHandle MPBar;
var ItemWindowHandle m_TributeItemWnd;
var TextBoxHandle m_offeringRateTextBox;
var int m_offering;
var ItemWindowHandle m_ItemWnd;

function OnRegisterEvent()
{
	RegisterEvent(840);
	RegisterEvent(210);
	RegisterEvent(211);
	RegisterEvent(2600);
	RegisterEvent(2610);
	RegisterEvent(1710);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	MPBar = GetBarHandle("barMp");
	m_ItemWnd = GetItemWindowHandle((m_Windowname $ ".ItemWnd"));
	m_TributeItemWnd = GetItemWindowHandle((m_Windowname $ ".TributeWnd.TributeItemWnd"));
	m_offeringRateTextBox = GetTextBoxHandle((m_Windowname $ ".txtOfferingRate"));
	GetTextBoxHandle((m_Windowname $ ".txtOffering")).SetText((GetSystemString(654) $ GetSystemString(642)));
	return;
}

function OnEvent(int Event_ID, string param)
{
	local Rect rectWnd;
	local int ServerID, MPValue, RecipeID, currentMP, maxMP, MakingResult, Type, IsCreateCriticalSuccess;

	if((Event_ID == 840))
	{
		Clear();
		if(IsShowWindow("RecipeBookWnd"))
		{
			rectWnd = Class'NWindow.UIAPI_WINDOW'.static.GetRect("RecipeBookWnd");
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("RecipeBookWnd");
			Class'NWindow.UIAPI_WINDOW'.static.MoveTo("RecipeManufactureWnd", rectWnd.nX, rectWnd.nY);
		}
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("RecipeManufactureWnd");
		Class'NWindow.UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd");
		ParseInt(param, "RecipeID", RecipeID);
		ParseInt(param, "CurrentMP", currentMP);
		ParseInt(param, "MaxMP", maxMP);
		ParseInt(param, "MakingResult", MakingResult);
		ParseInt(param, "Type", Type);
		ParseInt(param, "UseOffering", m_offering);
		ParseInt(param, "AddSuccRate", m_AddSuccRate);
		ParseInt(param, "CreateCritical", m_CreateCritical);
		ParseInt(param, "IsCreateCriticalSuccess", IsCreateCriticalSuccess);
		ReceiveRecipeItemMakeInfo(RecipeID, currentMP, maxMP, MakingResult, Type, IsCreateCriticalSuccess);
		setWindowForm(((m_CreateCritical != -1) && getInstanceUIData().GetIsClassicServer()));
		setTributeWnd();
		setOfferingRate();
	}
	else if(((Event_ID == 210) || (Event_ID == 211)))
	{
		ParseInt(param, "ServerID", ServerID);
		ParseInt(param, "CurrentMP", MPValue);
		if(((m_PlayerID == ServerID) && (m_PlayerID > 0)))
		{
			SetMPBar(MPValue);
		}
	}
	else if(((Event_ID == 2600) || (Event_ID == 2610)))
	{
		HandleInventoryItem(param);
	}
	else if((Event_ID == 1710))
	{
		HandleDialogOK();
	}
	return;
}

function checkClassicForm()
{
	return;
}

function HandleDialogOK()
{
	local ItemInfo scInfo;
	local INT64 inputNum;
	local int tributeID;
	local ItemInfo tributeItemInfo;
	local bool allItemMove;
	local int Id;

	if(DialogIsMine())
	{
		Id = DialogGetID();
		if(((Id == 1230) || (Id == 1240)))
		{
			DialogGetReservedItemInfo(scInfo);
			inputNum = INT64(DialogGetString());
			if((inputNum <= INT64(0)))
			{
				return;
			}
			if((inputNum >= scInfo.ItemNum))
			{
				inputNum = scInfo.ItemNum;
				allItemMove = true;
			}
			tributeID = m_TributeItemWnd.FindItem(scInfo.Id);
			if((Id == 1230))
			{
				if(allItemMove)
				{
					m_TributeItemWnd.DeleteItem(tributeID);
				}
				else
				{
					(scInfo.ItemNum -= inputNum);
					m_TributeItemWnd.SetItem(tributeID, scInfo);
				}
			}
			else if((Id == 1240))
			{
				if((tributeID >= 0))
				{
					m_TributeItemWnd.GetItem(tributeID, tributeItemInfo);
					(tributeItemInfo.ItemNum += inputNum);
					if((scInfo.ItemNum < tributeItemInfo.ItemNum))
					{
						tributeItemInfo.ItemNum = scInfo.ItemNum;
					}
					m_TributeItemWnd.SetItem(tributeID, tributeItemInfo);
				}
				else
				{
					scInfo.ItemNum = inputNum;
					m_TributeItemWnd.AddItem(scInfo);
				}
			}
			setOfferingRate();
		}
		else if((Id == 1250))
		{
			ManufactureWidthTribute();
		}
	}
	return;
}

function bool isShowDialogOnMoveStackableItem(ItemInfo infItem)
{
	if((IsStackableItem(infItem.ConsumeType) && (infItem.ItemNum != INT64(1))))
	{
		if(!Class'NWindow.InputAPI'.static.IsAltPressed())
		{
			return true;
		}
	}
	return false;
}

function deleteTributeItem(ItemInfo infItem)
{
	local int tributeItemID;

	tributeItemID = m_TributeItemWnd.FindItem(infItem.Id);
	if(isShowDialogOnMoveStackableItem(infItem))
	{
		showStackItemDialog(1230, infItem);
	}
	else
	{
		m_TributeItemWnd.DeleteItem(tributeItemID);
		setOfferingRate();
	}
	return;
}

function showStackItemDialog(int Id, ItemInfo infItem)
{
	local string SystemMsg;

	DialogSetID(Id);
	if((Id == 1230))
	{
		SystemMsg = GetSystemMessage(6193);
	}
	else if((Id == 1240))
	{
		SystemMsg = GetSystemMessage(6192);
	}
	else
	{
		SystemMsg = GetSystemMessage(72);
	}
	DialogSetReservedItemInfo(infItem);
	DialogSetParamInt64(infItem.ItemNum);
	DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(SystemMsg, infItem.Name, ""));
	return;
}

function handleRemoveItem(ItemWindowHandle a_hItemWindow, int Index)
{
	local ItemInfo Info;

	if(!a_hItemWindow.GetItem(Index, Info))
	{
		return;
	}
	switch(a_hItemWindow.GetWindowName())
	{
		case "TributeItemWnd":
			deleteTributeItem(Info);
			break;
		default:
			break;
	}
	return;
}

function OnDBClickItemWithHandle(ItemWindowHandle a_hItemWindow, int Index)
{
	handleRemoveItem(a_hItemWindow, Index);
	return;
}

function OnRClickItemWithHandle(ItemWindowHandle a_hItemWindow, int Index)
{
	handleRemoveItem(a_hItemWindow, Index);
	return;
}

function OnDropItemSource(string strTarget, ItemInfo Info)
{
	if((strTarget == "Console"))
	{
		switch(Info.DragSrcName)
		{
			case "TributeItemWnd":
				deleteTributeItem(Info);
				break;
			default:
				break;
		}
	}
	return;
}

function OnDropItem(string a_WindowID, ItemInfo a_itemInfo, int X, int Y)
{
	local int tributeID;
	local ItemInfo tributeItemInfo;

	if(!(((((((a_itemInfo.DragSrcName == "InventoryItem") || (a_itemInfo.DragSrcName == "InventoryItem_1")) || (a_itemInfo.DragSrcName == "InventoryItem_2")) || (a_itemInfo.DragSrcName == "InventoryItem_3")) || (a_itemInfo.DragSrcName == "InventoryItem_4")) || (a_itemInfo.DragSrcName == "PetInvenWnd")) || (-1 != InStr(a_itemInfo.DragSrcName, "EquipItem"))))
	{
		return;
	}
	if((a_itemInfo.DragSrcName == "PetInvenWnd"))
	{
		AddSystemMessage(6184);
		return;
	}
	if((a_WindowID == "TributeItemWnd"))
	{
		if(!Class'NWindow.UIDATA_RECIPE'.static.IsOfferingItem(a_itemInfo.Id))
		{
			if(!IsAdena(a_itemInfo.Id))
			{
				AddSystemMessage(6190);
				return;
			}
		}
		if((m_TributeItemWnd.GetItemNum() == 12))
		{
			AddSystemMessage(6191);
			return;
		}
		a_itemInfo.ItemNum = getMaxTributeItemNum(a_itemInfo);
		if((a_itemInfo.ItemNum <= INT64(0)))
		{
			if(IsAdena(a_itemInfo.Id))
			{
				AddSystemMessage(4157);
			}
			else
			{
				AddSystemMessage(341);
			}
			return;
		}
		if(isShowDialogOnMoveStackableItem(a_itemInfo))
		{
			showStackItemDialog(1240, a_itemInfo);
		}
		else
		{
			tributeID = m_TributeItemWnd.FindItem(a_itemInfo.Id);
			if((tributeID >= 0))
			{
				m_TributeItemWnd.GetItem(tributeID, tributeItemInfo);
				tributeItemInfo.ItemNum = a_itemInfo.ItemNum;
				m_TributeItemWnd.SetItem(tributeID, tributeItemInfo);
			}
			else
			{
				m_TributeItemWnd.AddItem(a_itemInfo);
			}
			setOfferingRate();
		}
	}
	return;
}

function setOfferingRateString(INT64 OfferingRate)
{
	local string strTmp;
	local L2Util util;
	local Color offeringRateColor;

	util = L2Util(GetScript("L2Util"));
	strTmp = (string(OfferingRate) $ "%");
	if((INT64((100 - m_SuccessRate)) <= OfferingRate))
	{
		strTmp = (strTmp $ GetSystemString(2610));
		offeringRateColor.R = 255;
		offeringRateColor.G = 102;
		offeringRateColor.B = 102;
	}
	else
	{
		offeringRateColor = util.Yellow03;
	}
	m_offeringRateTextBox.SetTextColor(offeringRateColor);
	m_offeringRateTextBox.SetText(strTmp);
	return;
}

function setOfferingRate()
{
	local INT64 totalDefaultPrice;
	local int i;
	local ItemInfo tributeItemInfo;

	totalDefaultPrice = INT64(0);
	i = 0;
	while((i < m_TributeItemWnd.GetItemNum()))
	{
		m_TributeItemWnd.GetItem(i, tributeItemInfo);
		(totalDefaultPrice += (tributeItemInfo.ItemNum * tributeItemInfo.n64DefaultPriceFromScript));
		i++;
	}
	m_CurrRate = RefreshRecipeOfferingRate(totalDefaultPrice, false);
	setOfferingRateString(INT64(m_CurrRate));
	return;
}

function setTributeWnd()
{
	if((m_offering > 0))
	{
		GetWindowHandle((m_Windowname $ ".TributeWnd")).ShowWindow();
		GetWindowHandle(m_Windowname).SetWindowSize(254, 537);
		GetTextureHandle((m_Windowname $ ".RecipeBg")).SetWindowSize(241, 107);
		GetTextBoxHandle((m_Windowname $ ".txtOffering")).ShowWindow();
		GetTextBoxHandle((m_Windowname $ ".txtOfferMid")).ShowWindow();
		m_offeringRateTextBox.ShowWindow();
	}
	else
	{
		GetWindowHandle((m_Windowname $ ".TributeWnd")).HideWindow();
		GetWindowHandle(m_Windowname).SetWindowSize(254, 407);
		GetTextureHandle((m_Windowname $ ".RecipeBg")).SetWindowSize(241, 92);
		GetTextBoxHandle((m_Windowname $ ".txtOffering")).HideWindow();
		GetTextBoxHandle((m_Windowname $ ".txtOfferMid")).HideWindow();
		m_offeringRateTextBox.HideWindow();
	}
	return;
}

function INT64 getMaxTributeItemNum(ItemInfo tributeItem)
{
	local ItemInfo infItem;
	local int idx;
	local INT64 needNum;

	needNum = INT64(0);
	idx = m_ItemWnd.FindItemByClassID(tributeItem.Id);
	if((idx > -1))
	{
		m_ItemWnd.GetItem(idx, infItem);
		needNum = infItem.Reserved64;
	}
	return (tributeItem.ItemNum - needNum);
}

function ManufactureWidthTribute()
{
	local array<OfferingItemList> tributeItemList;
	local int i;
	local ItemInfo tributeItem;

	tributeItemList.Length = m_TributeItemWnd.GetItemNum();
	i = 0;
	while((i < tributeItemList.Length))
	{
		m_TributeItemWnd.GetItem(i, tributeItem);
		tributeItemList[i].nItemID = tributeItem.Id.ServerID;
		tributeItemList[i].nAmount = tributeItem.ItemNum;
		i++;
	}
	Class'NWindow.RecipeAPI'.static.RequestRecipeItemMakeSelf(m_RecipeID, m_TributeItemWnd.GetItemNum(), tributeItemList);
	return;
}

function handleAddSuccessNCritical()
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		if((m_SuccessRate == 100))
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtAddSuccessRate", "");
		}
		else if(((m_SuccessRate + m_AddSuccRate) <= 100))
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtAddSuccessRate", (("+" $ string(m_AddSuccRate)) $ "%"));
		}
		else
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtAddSuccessRate", (("+" $ string((100 - m_SuccessRate))) $ "%"));
		}
		if((m_CreateCritical == 0))
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtCreateCriticalValue", GetSystemString(27));
		}
		else
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtCreateCriticalValue", (string(m_CreateCritical) $ "%"));
		}
	}
	return;
}

function setWindowForm(bool bUseCritical)
{
	local int criticalHeight;

	if(m_MultipleProduct)
	{
		criticalHeight = 15;
	}
	if(bUseCritical)
	{
		criticalHeight = 15;
		GetTextBoxHandle((m_Windowname $ ".txtCreateCritical")).ShowWindow();
		GetTextBoxHandle((m_Windowname $ ".txtCreateCriticalMid")).ShowWindow();
		GetTextBoxHandle((m_Windowname $ ".txtCreateCriticalValue")).ShowWindow();
	}
	else
	{
		GetTextBoxHandle((m_Windowname $ ".txtCreateCritical")).HideWindow();
		GetTextBoxHandle((m_Windowname $ ".txtCreateCriticalMid")).HideWindow();
		GetTextBoxHandle((m_Windowname $ ".txtCreateCriticalValue")).HideWindow();
	}
	if((m_offering > 0))
	{
		GetWindowHandle((m_Windowname $ ".TributeWnd")).ShowWindow();
		GetWindowHandle(m_Windowname).SetWindowSize(254, 537);
		GetTextureHandle((m_Windowname $ ".RecipeBg")).SetWindowSize(241, (92 + criticalHeight));
		GetTextBoxHandle((m_Windowname $ ".txtOffering")).ShowWindow();
		GetTextBoxHandle((m_Windowname $ ".txtOfferMid")).ShowWindow();
		m_offeringRateTextBox.ShowWindow();
	}
	else
	{
		GetWindowHandle((m_Windowname $ ".TributeWnd")).HideWindow();
		GetWindowHandle(m_Windowname).SetWindowSize(254, 407);
		GetTextureHandle((m_Windowname $ ".RecipeBg")).SetWindowSize(241, (77 + criticalHeight));
		GetTextBoxHandle((m_Windowname $ ".txtOffering")).HideWindow();
		GetTextBoxHandle((m_Windowname $ ".txtOfferMid")).HideWindow();
		m_offeringRateTextBox.HideWindow();
	}
	return;
}

function OnClickButton(string strID)
{
	local string param;
	local Rect rectWnd;
	local string SystemMsg;
	local int nDefaultRate;

	switch(strID)
	{
		case "btnClose":
			CloseWindow();
			break;
		case "btnPrev":
			Class'NWindow.RecipeAPI'.static.RequestRecipeBookOpen(m_RecipeBookClass);
			rectWnd = Class'NWindow.UIAPI_WINDOW'.static.GetRect(m_Windowname);
			Class'NWindow.UIAPI_WINDOW'.static.MoveTo("RecipeBookWnd", rectWnd.nX, rectWnd.nY);
			CloseWindow();
			break;
		case "btnRecipeTree":
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("RecipeTreeWnd"))
			{
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("RecipeTreeWnd");
			}
			else
			{
				ParamAdd(param, "RecipeID", string(m_RecipeID));
				ParamAdd(param, "SuccessRate", string(m_SuccessRate));
				ParamAdd(param, "AddSuccRate", string(m_AddSuccRate));
				ParamAdd(param, "CreateCritical", string(m_CreateCritical));
				ExecuteEvent(810, param);
			}
			break;
		case "btnManufacture":
			if((m_offering > 0))
			{
				DialogSetID(1250);
				SystemMsg = GetSystemMessage(6206);
				nDefaultRate = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeSuccessRate(m_RecipeID);
				(nDefaultRate += m_CurrRate);
				DialogShow(DialogModalType_Modal, DialogType_OKCancel, MakeFullSystemMsg(SystemMsg, string(nDefaultRate)));
			}
			else
			{
				Class'NWindow.RecipeAPI'.static.RequestRecipeItemMakeSelf(m_RecipeID);
			}
			break;
		default:
			break;
	}
	return;
}

function CloseWindow()
{
	Clear();
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("RecipeManufactureWnd");
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	return;
}

function Clear()
{
	m_RecipeID = 0;
	m_SuccessRate = 0;
	m_RecipeBookClass = 0;
	m_MultipleProduct = false;
	m_MaxMP = 0;
	m_PlayerID = 0;
	m_ItemWnd.Clear();
	if(!IsShowWindow(m_Windowname))
	{
		m_TributeItemWnd.Clear();
	}
	m_offering = 0;
	return;
}

function ReceiveRecipeItemMakeInfo(int RecipeID, int currentMP, int maxMP, int MakingResult, int Type, int IsCreateCriticalSuccess)
{
	local int i;
	local string strTmp;
	local int nTmp, nTmp2, ProductID, ProductNum;
	local string ItemName, param;
	local ItemInfo infItem, NewItem;
	local Rect txtNameRect;

	m_RecipeID = RecipeID;
	m_SuccessRate = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeSuccessRate(RecipeID);
	m_MultipleProduct = bool(Class'NWindow.UIDATA_RECIPE'.static.GetRecipeIsMultipleProduct(RecipeID));
	m_RecipeBookClass = Type;
	m_MaxMP = maxMP;
	m_PlayerID = Class'NWindow.UIDATA_PLAYER'.static.GetPlayerID();
	ProductID = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeProductID(RecipeID);
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(ProductID), NewItem);
	Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("RecipeManufactureWnd.texItem");
	Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("RecipeManufactureWnd.texItem", NewItem);
	ItemName = MakeFullItemName(ProductID);
	nTmp = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeCrystalType(RecipeID);
	strTmp = GetItemGradeTextureName(nTmp);
	Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("RecipeManufactureWnd.texGrade", strTmp);
	if(((((((nTmp == 6) || (nTmp == 7)) || (nTmp == 9)) || (nTmp == 10)) || (nTmp == 11)) || (nTmp == 12)))
	{
		Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("RecipeManufactureWnd.texGrade", (14 * 2), 14);
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("RecipeManufactureWnd.texGrade", 14, 14);
	}
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtName", ItemName);
	txtNameRect = GetTextBoxHandle("RecipeManufactureWnd.txtName").GetRect();
	if((txtNameRect.nWidth > 150))
	{
		GetTextBoxHandle("RecipeManufactureWnd.txtName").SetWindowSize(141, txtNameRect.nHeight);
		GetTextBoxHandle("RecipeManufactureWnd.txtName").SetTextEllipsisWidth(141);
	}
	else
	{
		GetTextBoxHandle("RecipeManufactureWnd.txtName").SetTextEllipsisWidth(-1);
	}
	GetTextBoxHandle("RecipeManufactureWnd.txtName").SetTooltipType("Text");
	GetTextBoxHandle("RecipeManufactureWnd.txtName").SetTooltipText(ItemName);
	nTmp = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeMpConsume(RecipeID);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtMPConsume", ("" $ string(nTmp)));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtSuccessRate", (string(m_SuccessRate) $ "%"));
	handleAddSuccessNCritical();
	if(m_MultipleProduct)
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtOption", GetSystemMessage(2320));
	}
	else
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtOption", "");
	}
	ProductNum = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeProductNum(RecipeID);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtResultValue", ("" $ string(ProductNum)));
	SetMPBar(currentMP);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtCountValue", ("" $ string(GetInventoryItemCount(GetItemID(ProductID)))));
	strTmp = "";
	if((MakingResult == 0))
	{
		strTmp = MakeFullSystemMsg(GetSystemMessage(960), ItemName, "");
	}
	else if((MakingResult == 1))
	{
		if((IsCreateCriticalSuccess == 0))
		{
			strTmp = MakeFullSystemMsg(GetSystemMessage(959), ItemName, ("" $ string(ProductNum)));
		}
		else if((IsCreateCriticalSuccess == 1))
		{
			strTmp = MakeFullSystemMsg(GetSystemMessage(959), ItemName, ("" $ string((ProductNum * 2))));
		}
	}
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtMsg", strTmp);
	param = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeMaterialItem(RecipeID);
	ParseInt(param, "Count", nTmp);
	i = 0;
	while((i < nTmp))
	{
		ParseInt(param, ("ID_" $ string(i)), nTmp2);
		infItem.Id = GetItemID(nTmp2);
		Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(nTmp2), infItem);
		ParseINT64(param, ("NeededNum_" $ string(i)), infItem.Reserved64);
		infItem.ItemNum = GetInventoryItemCount(infItem.Id);
		if((infItem.Reserved64 > infItem.ItemNum))
		{
			infItem.bDisabled = 1;
		}
		else
		{
			infItem.bDisabled = 0;
		}
		m_ItemWnd.AddItem(infItem);
		i++;
	}
	return;
}

function SetMPBar(int currentMP)
{
	MPBar.SetValue(m_MaxMP, currentMP);
	return;
}

function HandleInventoryItem(string param)
{
	local ItemID cID;
	local int idx;
	local ItemInfo infItem;
	local INT64 invenItemCount, needNum;
	local string Type;

	if(!IsShowWindow(m_Windowname))
	{
		return;
	}
	if(ParseItemID(param, cID))
	{
		needNum = INT64(0);
		idx = m_ItemWnd.FindItemByClassID(cID);
		if((idx > -1))
		{
			m_ItemWnd.GetItem(idx, infItem);
			infItem.ItemNum = GetInventoryItemCount(infItem.Id);
			if((infItem.Reserved64 > infItem.ItemNum))
			{
				infItem.bDisabled = 1;
			}
			else
			{
				infItem.bDisabled = 0;
			}
			m_ItemWnd.SetItem(idx, infItem);
			needNum = infItem.Reserved64;
		}
		idx = m_TributeItemWnd.FindItem(cID);
		if((idx > -1))
		{
			ParseString(param, "type", Type);
			m_TributeItemWnd.GetItem(idx, infItem);
			if((Type == "update"))
			{
				invenItemCount = (GetInventoryItemCount(infItem.Id) - needNum);
				if((invenItemCount <= INT64(0)))
				{
					m_TributeItemWnd.DeleteItem(idx);
				}
				else if((invenItemCount < infItem.ItemNum))
				{
					infItem.ItemNum = invenItemCount;
					m_TributeItemWnd.SetItem(idx, infItem);
				}
			}
			else if((Type == "delete"))
			{
				m_TributeItemWnd.DeleteItem(idx);
			}
			else if((Type == "add"))
			{
			}
			setOfferingRate();
		}
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="RecipeManufactureWnd"
}
