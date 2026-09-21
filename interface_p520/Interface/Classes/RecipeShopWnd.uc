class RecipeShopWnd extends UICommonAPI;

const RECIPESHOP_MAX_ITEM_SELL = 20;

var int m_ShopItemMaxCount_Dwarf;
var int m_ShopItemMaxCount_Normal;
var int m_BookItemCount;
var int m_ShopItemCount;
var int m_BookType;
var ItemInfo m_HandleItem;
var bool isStartCraft;

function OnRegisterEvent()
{
	RegisterEvent(850);
	RegisterEvent(860);
	RegisterEvent(870);
	RegisterEvent(2070);
	RegisterEvent(1710);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	return;
}

function OnShow()
{
	PlayConsoleSound(IFST_WORKSHOP_OPEN);
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnEnd":
			CloseWindow();
			break;
		case "btnMsg":
			DialogSetEditBoxMaxLength(29);
			DialogShow(DialogModalType_Modalless, DialogType_OKCancelInput, GetSystemMessage(334));
			DialogSetID(0);
			DialogSetString(Class'NWindow.UIDATA_PLAYER'.static.GetRecipeShopMsg());
			break;
		case "btnStart":
			StartRecipeShop();
			CloseWindow();
			break;
		case "btnMoveUp":
			HandleMoveUpItem();
			break;
		case "btnMoveDown":
			HandleMoveDownItem();
			break;
		default:
			break;
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	local string strPrice;
	local int RecipeID, CanbeMade;
	local INT64 MakingFee, Price;

	if((Event_ID == 850))
	{
		Clear();
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("RecipeShopWnd");
		Class'NWindow.UIAPI_WINDOW'.static.SetFocus("RecipeShopWnd");
		ParseInt(param, "Type", m_BookType);
		if((m_BookType == 1))
		{
			setWindowTitleBySysStringNum(1212);
		}
		else
		{
			setWindowTitleBySysStringNum(1213);
		}
	}
	else if((Event_ID == 860))
	{
		ParseInt(param, "RecipeID", RecipeID);
		AddRecipeBookItem(RecipeID);
	}
	else if((Event_ID == 870))
	{
		ParseInt(param, "RecipeID", RecipeID);
		ParseInt(param, "CanbeMade", CanbeMade);
		ParseINT64(param, "MakingFee", MakingFee);
		AddRecipeShopItem(RecipeID, CanbeMade, MakingFee);
	}
	else if((Event_ID == 2070))
	{
		HandleSetMaxCount(param);
	}
	else if((Event_ID == 1710))
	{
		if(DialogIsMine())
		{
			if((DialogGetID() == 0))
			{
				Class'NWindow.RecipeAPI'.static.RequestRecipeShopMessageSet(DialogGetString());
			}
			else if((DialogGetID() == 1))
			{
				strPrice = DialogGetString();
				if((Len(strPrice) > 0))
				{
					Price = INT64(strPrice);
					if((Price >= INT64("1000000000000")))
					{
						DialogSetID(2);
						DialogShow(DialogModalType_Modalless, DialogType_Warning, GetSystemMessage(1369));
					}
					else
					{
						m_HandleItem.Price = Price;
						UpdateShopItem(m_HandleItem);
					}
				}
				ClearHandleItem();
			}
		}
	}
	return;
}

function OnSendPacketWhenHiding()
{
	Clear();
	return;
}

function CloseWindow()
{
	Clear();
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("RecipeShopWnd");
	return;
}

function OnDBClickItem(string strID, int Index)
{
	local int Max, i;
	local ItemInfo infItem, DeleteItem;

	ClearHandleItem();
	if(((strID == "BookItemWnd") && (m_BookItemCount > Index)))
	{
		Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("RecipeShopWnd.BookItemWnd", Index, infItem);
		Max = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItemNum("RecipeShopWnd.ShopItemWnd");
		i = 0;
		while((i < Max))
		{
			if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("RecipeShopWnd.ShopItemWnd", i, DeleteItem))
			{
				if(IsSameClassID(DeleteItem.Id, infItem.Id))
				{
					DeleteShopItem(infItem);
					return;
				}
			}
			i++;
		}
		Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("RecipeShopWnd.BookItemWnd", Index, infItem);
		ShowShopItemAddDialog(infItem);
	}
	else if(((strID == "ShopItemWnd") && (m_ShopItemCount > Index)))
	{
		Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("RecipeShopWnd.ShopItemWnd", Index, infItem);
		DeleteShopItem(infItem);
	}
	return;
}

function OnDropItem(string strID, ItemInfo infItem, int X, int Y)
{
	if((strID == "BookItemWnd"))
	{
		if((infItem.DragSrcName == "ShopItemWnd"))
		{
			DeleteShopItem(infItem);
		}
	}
	else if((strID == "ShopItemWnd"))
	{
		if((infItem.DragSrcName == "BookItemWnd"))
		{
			ShowShopItemAddDialog(infItem);
		}
	}
	return;
}

function Clear()
{
	ClearHandleItem();
	m_BookItemCount = 0;
	m_ShopItemCount = 0;
	UpdateShopItemCount(0);
	Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("RecipeShopWnd.BookItemWnd");
	Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("RecipeShopWnd.ShopItemWnd");
	return;
}

function ClearHandleItem()
{
	local ItemInfo ItemClear;

	m_HandleItem = ItemClear;
	return;
}

function AddRecipeBookItem(int RecipeID)
{
	local ItemInfo infItem;
	local int ProductID;

	ProductID = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeProductID(RecipeID);
	infItem.Id = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeItemID(RecipeID);
	infItem.Level = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeLevel(RecipeID);
	infItem.Name = Class'NWindow.UIDATA_ITEM'.static.GetItemName(infItem.Id);
	infItem.Description = Class'NWindow.UIDATA_ITEM'.static.GetItemDescription(infItem.Id);
	infItem.Weight = Class'NWindow.UIDATA_ITEM'.static.GetItemWeight(infItem.Id);
	infItem.IconName = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(ProductID));
	infItem.CrystalType = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeCrystalType(RecipeID);
	Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("RecipeShopWnd.BookItemWnd", infItem);
	m_BookItemCount++;
	return;
}

function AddRecipeShopItem(int RecipeID, int CanbeMade, INT64 MakingFee)
{
	local ItemInfo infItem;
	local int ProductID;

	ProductID = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeProductID(RecipeID);
	infItem.Id = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeItemID(RecipeID);
	infItem.Level = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeLevel(RecipeID);
	infItem.Price = MakingFee;
	infItem.Reserved = CanbeMade;
	infItem.Name = Class'NWindow.UIDATA_ITEM'.static.GetItemName(infItem.Id);
	infItem.Description = Class'NWindow.UIDATA_ITEM'.static.GetItemDescription(infItem.Id);
	infItem.Weight = Class'NWindow.UIDATA_ITEM'.static.GetItemWeight(infItem.Id);
	infItem.IconName = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(ProductID));
	infItem.CrystalType = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeCrystalType(RecipeID);
	Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("RecipeShopWnd.ShopItemWnd", infItem);
	m_ShopItemCount++;
	UpdateShopItemCount(m_ShopItemCount);
	return;
}

function ShowShopItemAddDialog(ItemInfo AddItem)
{
	m_HandleItem = AddItem;
	DialogSetID(1);
	DialogSetParamInt64(INT64(-1));
	DialogSetDefaultOK();
	DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(963));
	return;
}

function UpdateShopItem(ItemInfo AddItem)
{
	local int i, Max;
	local ItemInfo infItem;
	local bool bDuplicated;

	bDuplicated = false;
	Max = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItemNum("RecipeShopWnd.ShopItemWnd");
	i = 0;
	while((i < Max))
	{
		if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("RecipeShopWnd.ShopItemWnd", i, infItem))
		{
			if(IsSameClassID(AddItem.Id, infItem.Id))
			{
				bDuplicated = true;
				break;
			}
		}
		i++;
	}
	if(!bDuplicated)
	{
		Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("RecipeShopWnd.ShopItemWnd", AddItem);
		m_ShopItemCount++;
		UpdateShopItemCount(m_ShopItemCount);
	}
	return;
}

function DeleteShopItem(ItemInfo DeleteItem)
{
	local int i, Max;
	local ItemInfo infItem;

	Max = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItemNum("RecipeShopWnd.ShopItemWnd");
	i = 0;
	while((i < Max))
	{
		if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("RecipeShopWnd.ShopItemWnd", i, infItem))
		{
			if(IsSameClassID(DeleteItem.Id, infItem.Id))
			{
				Class'NWindow.UIAPI_ITEMWINDOW'.static.DeleteItem("RecipeShopWnd.ShopItemWnd", i);
				m_ShopItemCount--;
				UpdateShopItemCount(m_ShopItemCount);
				break;
			}
		}
		i++;
	}
	return;
}

function UpdateShopItemCount(int Count)
{
	if((m_BookType == 1))
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeShopWnd.txtCount", (((("(" $ string(Count)) $ "/") $ string(m_ShopItemMaxCount_Normal)) $ ")"));
	}
	else
	{
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeShopWnd.txtCount", (((("(" $ string(Count)) $ "/") $ string(m_ShopItemMaxCount_Dwarf)) $ ")"));
	}
	return;
}

function StartRecipeShop()
{
	local int i, Max;
	local ItemInfo infItem;
	local string param;
	local INT64 Price;

	Max = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItemNum("RecipeShopWnd.ShopItemWnd");
	ParamAdd(param, "Max", string(Max));
	i = 0;
	while((i < Max))
	{
		Price = INT64(0);
		if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("RecipeShopWnd.ShopItemWnd", i, infItem))
		{
			Price = infItem.Price;
		}
		ParamAddItemIDWithIndex(param, infItem.Id, i);
		ParamAdd(param, ("Price_" $ string(i)), string(Price));
		i++;
	}
	isStartCraft = true;
	Class'NWindow.RecipeAPI'.static.RequestRecipeShopListSet(param);
	return;
}

function HandleMoveUpItem()
{
	local ItemInfo infItem;

	if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetSelectedItem("RecipeShopWnd.ShopItemWnd", infItem))
	{
		DeleteShopItem(infItem);
	}
	return;
}

function HandleMoveDownItem()
{
	local ItemInfo infItem;

	if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetSelectedItem("RecipeShopWnd.BookItemWnd", infItem))
	{
		ShowShopItemAddDialog(infItem);
	}
	return;
}

function OnReceivedCloseUI()
{
	CloseWindow();
	return;
}

function OnHide()
{
	PlayConsoleSound(IFST_WORKSHOP_CLOSE);
	if(!isStartCraft)
	{
		Class'NWindow.RecipeAPI'.static.RequestRecipeShopManageQuit();
	}
	isStartCraft = false;
	return;
}

function HandleSetMaxCount(string param)
{
	ParseInt(param, "dwarvenRecipeShop", m_ShopItemMaxCount_Dwarf);
	ParseInt(param, "recipeShop", m_ShopItemMaxCount_Normal);
	return;
}
