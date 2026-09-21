class AttributeEnchantWnd extends UICommonAPI;

const DIALOG_ASK_ITEM_COUNT = 55555;
const DIALOG_ENCHANT_COMPLETE = 55556;

var WindowHandle Me;
var WindowHandle disableWnd;
var ItemWindowHandle ItemWnd;
var ItemWindowHandle InventoryItemHandle;
var TextBoxHandle textBox;
var TextBoxHandle ItemCountTextBox;
var ButtonHandle OKButton;
var ButtonHandle AttributeCountEditBtn;
var ItemInfo SelectItemInfo;
var ItemInfo ResourceInfo;
var int ScrollCID;
var INT64 LoopEnchantItemCount;
var INT64 ResourceItemCount;
var int ItemClassID;
var EditBoxHandle AttributeCountEditBox;

function OnRegisterEvent()
{
	RegisterEvent(2893);
	RegisterEvent(2865);
	RegisterEvent(2894);
	RegisterEvent(2895);
	RegisterEvent(1710);
	RegisterEvent(1720);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	disableWnd = GetWindowHandle("AttributeEnchantWnd.DisableWnd");
	Me = GetWindowHandle("AttributeEnchantWnd");
	ItemWnd = GetItemWindowHandle("AttributeEnchantWnd.ItemWnd");
	textBox = GetTextBoxHandle("AttributeEnchantWnd.txtScrollName");
	OKButton = GetButtonHandle("AttributeEnchantWnd.btnOK");
	AttributeCountEditBtn = GetButtonHandle("AttributeEnchantWnd.AttributeCountEditBtn");
	AttributeCountEditBox = GetEditBoxHandle("AttributeEnchantWnd.AttributeCountEditBox");
	InventoryItemHandle = GetItemWindowHandle("InventoryWnd.InventoryItem");
	ItemCountTextBox = GetTextBoxHandle("AttributeEnchantWnd.itemCountTxt");
	AttributeCountEditBox.SetMaxLength(6);
	return;
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)), "InventoryWnd");
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 2893))
	{
		if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("AttributeRemoveWnd"))
		{
			AddSystemMessage(3161);
			OnCancelClick();
		}
		else
		{
			HandleAttributeEnchantShow(param);
		}
	}
	else if((Event_ID == 2865))
	{
		HandleAttributeEnchantHide();
	}
	else if((Event_ID == 2894))
	{
		HandleAttributeEnchantItemList(param);
	}
	else if((Event_ID == 2895))
	{
		HandleAttributeEnchantResult(param);
	}
	else if((Event_ID == 1710))
	{
		HandleDialogOK();
	}
	else if((Event_ID == 1720))
	{
		HandleDialogCancel();
	}
	return;
}

function HandleDialogOK()
{
	local int Id;
	local ItemID scID;
	local ItemInfo scInfo;
	local INT64 inputNum;

	if(DialogIsMine())
	{
		Id = DialogGetID();
		inputNum = INT64(DialogGetString());
		if((ResourceItemCount < inputNum))
		{
			inputNum = ResourceItemCount;
		}
		scID = DialogGetReservedItemID();
		DialogGetReservedItemInfo(scInfo);
		if((Id == 55555))
		{
			AttributeCountEditBox.SetString(string(inputNum));
			if((ResourceItemCount < inputNum))
			{
				inputNum = ResourceItemCount;
			}
			LoopEnchantItemCount = inputNum;
		}
	}
	DisableCurrentWindow(false);
	return;
}

function HandleDialogCancel()
{
	if(DialogIsMine())
	{
		DisableCurrentWindow(false);
	}
	return;
}

function OnClickItem(string strID, int Index)
{
	if((strID == "ItemWnd"))
	{
		OKButton.EnableWindow();
	}
	return;
}

function OnClickButton(string strID)
{
	local INT64 ItemCount;

	ItemCount = INT64(AttributeCountEditBox.GetString());
	switch(strID)
	{
		case "btnOK":
			DisableCurrentWindow(true);
			if((ResourceItemCount < INT64(AttributeCountEditBox.GetString())))
			{
				ItemCount = ResourceItemCount;
			}
			AttributeCountEditBox.SetString(string(ItemCount));
			LoopEnchantItemCount = ItemCount;
			OnOkClickProgress();
			break;
		case "btnCancel":
			OnCancelClick();
			break;
		case "AttributeCountEditBtn":
			CountBtnClick();
			break;
		default:
			break;
	}
	return;
}

function CountBtnClick()
{
	local ItemInfo Info;

	if((ItemWnd.GetItemNum() > 0))
	{
		ItemWnd.GetItem(0, Info);
		DialogSetID(55555);
		DialogSetReservedItemID(Info.Id);
		DialogSetEditType("number");
		DialogSetEditBoxMaxLength(6);
		DialogSetParamInt64(ResourceItemCount);
		DialogSetDefaultOK();
		Debug(GetSystemMessage(4142));
		DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(4142));
		DisableCurrentWindow(true);
	}
	return;
}

function OnOkClickProgress()
{
	local ProgressBox Script;

	ItemWnd.GetSelectedItem(SelectItemInfo);
	if((SelectItemInfo.Id.ClassID != 0))
	{
		if(IsShowWindow("ItemEnchantWnd"))
		{
			AddSystemMessage(2188);
			DisableCurrentWindow(false);
		}
		else if((SelectItemInfo.Reserved != 0))
		{
			if((SelectItemInfo.Reserved == 1))
			{
				AddSystemMessage(3117);
			}
			if((SelectItemInfo.Reserved == 2))
			{
				AddSystemMessage(3154);
			}
			if((SelectItemInfo.Reserved == 4))
			{
				AddSystemMessage(3153);
			}
			if((SelectItemInfo.Reserved == 6))
			{
				AddSystemMessage(3155);
			}
			DisableCurrentWindow(false);
		}
		else
		{
			Script = ProgressBox(GetScript("ProgressBox"));
			Script.Initialize();
			Script.ShowDialog(MakeFullSystemMsg(GetSystemMessage(4140), ResourceInfo.Name, string(LoopEnchantItemCount), SelectItemInfo.Name), "AttributeEnchantWnd", 2000, ResourceInfo, SelectItemInfo);
		}
	}
	return;
}

function OnOKClick()
{
	Class'NWindow.EnchantAPI'.static.RequestEnchantItemAttribute(SelectItemInfo.Id, LoopEnchantItemCount);
	return;
}

function OnHide()
{
	local ItemID Id;

	Id = GetItemID(-1);
	Class'NWindow.EnchantAPI'.static.RequestEnchantItemAttribute(Id, LoopEnchantItemCount);
	Clear();
	return;
}

function OnCancelClick()
{
	Me.HideWindow();
	return;
}

function Clear()
{
	ItemWnd.Clear();
	return;
}

function HandleAttributeEnchantShow(string param)
{
	local ItemID cID;
	local INT64 Count;

	Clear();
	ParseItemID(param, cID);
	ParseINT64(param, "ItemCount", Count);
	ResourceItemCount = Count;
	ScrollCID = cID.ClassID;
	textBox.SetText(Class'NWindow.UIDATA_ITEM'.static.GetItemName(cID));
	ItemClassID = cID.ClassID;
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cID, ResourceInfo);
	ItemCountTextBox.SetText("x");
	AttributeCountEditBox.SetString("1");
	OKButton.DisableWindow();
	Me.ShowWindow();
	Me.SetFocus();
	DisableCurrentWindow(false);
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

function HandleAttributeEnchantHide()
{
	return;
}

function HandleAttributeEnchantItemList(string param)
{
	local ItemInfo infItem;
	local int Ispossible;

	ParseInt(param, "Ispossible", Ispossible);
	ParamToItemInfo(param, infItem);
	infItem.Reserved = Ispossible;
	if((((!infItem.bSecurityLock && (infItem.CrystalType > 4)) && (infItem.SlotBitType != INT64(268435456))) && (infItem.SlotBitType != INT64(1))))
	{
		if((Ispossible == 0))
		{
			ItemWnd.AddItem(infItem);
		}
		else
		{
			ItemWnd.AddItemWithFaded(infItem);
		}
	}
	return;
}

function string GetPropString(int Id)
{
	switch(Id)
	{
		case 9546:
			return GetSystemString(2753);
			break;
		case 9547:
			return GetSystemString(2754);
			break;
		case 9549:
			return GetSystemString(2755);
			break;
		case 9548:
			return GetSystemString(2756);
			break;
		case 9551:
			return GetSystemString(2757);
			break;
		case 9550:
			return GetSystemString(2758);
			break;
		default:
			break;
	}
}

function HandleAttributeEnchantResult(string param)
{
	local int Result, isWeapon, attrType, beforeAttrValue, afterAttrValue, failCount;
	local INT64 successCount;
	local ItemInfo iInfo;

	ParseInt(param, "Result", Result);
	ParseInt(param, "IsWeapon", isWeapon);
	ParseInt(param, "AttrType", attrType);
	ParseInt(param, "BeforeAttrValue", beforeAttrValue);
	ParseInt(param, "AfterAttrValue", afterAttrValue);
	ParseInt(param, "FailCount", failCount);
	ParseINT64(param, "SuccessCount", successCount);
	InventoryItemHandle.GetItem(InventoryItemHandle.FindItem(ResourceInfo.Id), iInfo);
	if((Result != 2))
	{
		DialogSetID(55556);
		DialogShow(DialogModalType_Modalless, DialogType_OK, MakeFullSystemMsg(GetSystemMessage(4141), ResourceInfo.Name, string(LoopEnchantItemCount), string(successCount), string(failCount), string((LoopEnchantItemCount - (successCount + INT64(failCount))))));
	}
	DisableCurrentWindow(false);
	Me.HideWindow();
	Clear();
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	HandleAttributeEnchantHide();
	OnCancelClick();
	return;
}
