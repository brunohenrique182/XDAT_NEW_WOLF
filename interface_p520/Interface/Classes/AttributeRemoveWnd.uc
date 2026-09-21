class AttributeRemoveWnd extends UICommonAPI;

const DIALOG_ATTRIBUTE_REMOVE = 9001;
const EQUIPITEM_Max = 37;
const ATTRIBUTE_FIRE = 0;
const ATTRIBUTE_WATER = 1;
const ATTRIBUTE_WIND = 2;
const ATTRIBUTE_EARTH = 3;
const ATTRIBUTE_HOLY = 4;
const ATTRIBUTE_UNHOLY = 5;

var WindowHandle Me;
var TextBoxHandle txtRemoveAdenaStr;
var TextBoxHandle txtRemoveAdena;
var TextBoxHandle txtItemSelectStr;
var ItemWindowHandle ItemWnd;
var TextureHandle ItemWndBg;
var TextureHandle txtRemoveAdenaBg;
var TextureHandle ItemWndScrollBg;
var ButtonHandle btnOk;
var ButtonHandle btnCancel;
var ButtonHandle btnHideBarButton0;
var ButtonHandle btnHideBarButton1;
var ButtonHandle btnHideBarButton2;
var ToolTip toolTipScript;
var BarHandle gageAttributeSelect0;
var BarHandle gageAttributeSelect1;
var BarHandle gageAttributeSelect2;
var CheckBoxHandle btnAttributeSelect0;
var CheckBoxHandle btnAttributeSelect1;
var CheckBoxHandle btnAttributeSelect2;
var TextBoxHandle txtAttributeSelect0;
var TextBoxHandle txtAttributeSelect1;
var TextBoxHandle txtAttributeSelect2;
var ItemInfo SelectItemInfo;
var array<string> tooltipStr;
var array<string> attributeWord;
var array<int> attributerTypeRadio;
var array<int> memoryAttributeSelectedRadio;
var int beforeClickedItem;
var int radioButtonCount;
var InventoryWnd Script;

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	initAttributeElements(false);
	return;
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)), "InventoryWnd");
	initAttributeElements(false);
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(2896);
	RegisterEvent(2897);
	RegisterEvent(2898);
	RegisterEvent(1710);
	RegisterEvent(1720);
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 2896))
	{
		if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("AttributeEnchantWnd"))
		{
			AddSystemMessage(3161);
		}
		else
		{
			HandleAttributeRemoveShow(param);
		}
	}
	else if((Event_ID == 2897))
	{
		HandleAttributeRemoveItemData(param);
	}
	else if((Event_ID == 2898))
	{
		HandleAttributeRemoveResult(param);
	}
	else if((Event_ID == 1710))
	{
		HandleDialogOK();
	}
	else if((Event_ID == 1720))
	{
		Me.EnableWindow();
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "btnOK":
			OnBtnOkClick();
			break;
		case "btnCancel":
			OnbtnCancelClick();
			break;
		case "btnListSelect0":
			if(gageAttributeSelect0.IsShowWindow())
			{
				setRadioButton(0);
			}
			break;
		case "btnListSelect1":
			if(gageAttributeSelect1.IsShowWindow())
			{
				setRadioButton(1);
			}
			break;
		case "btnListSelect2":
			if(gageAttributeSelect2.IsShowWindow())
			{
				setRadioButton(2);
			}
			break;
		default:
			break;
	}
	return;
}

function Initialize()
{
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	Me = GetWindowHandle("AttributeRemoveWnd");
	txtRemoveAdenaStr = GetTextBoxHandle("AttributeRemoveWnd.txtRemoveAdenaStr");
	txtRemoveAdena = GetTextBoxHandle("AttributeRemoveWnd.txtRemoveAdena");
	txtItemSelectStr = GetTextBoxHandle("AttributeRemoveWnd.txtItemSelectStr");
	ItemWnd = GetItemWindowHandle("AttributeRemoveWnd.ItemWnd");
	ItemWndBg = GetTextureHandle("AttributeRemoveWnd.ItemWndBg");
	txtRemoveAdenaBg = GetTextureHandle("AttributeRemoveWnd.txtRemoveAdenaBg");
	ItemWndScrollBg = GetTextureHandle("AttributeRemoveWnd.ItemWndScrollBg");
	btnOk = GetButtonHandle("AttributeRemoveWnd.btnOK");
	btnCancel = GetButtonHandle("AttributeRemoveWnd.btnCancel");
	btnHideBarButton0 = GetButtonHandle("AttributeRemoveWnd.btnListSelect0");
	btnHideBarButton1 = GetButtonHandle("AttributeRemoveWnd.btnListSelect1");
	btnHideBarButton2 = GetButtonHandle("AttributeRemoveWnd.btnListSelect2");
	gageAttributeSelect0 = GetBarHandle("AttributeRemoveWnd.gageAttributeSelect0");
	gageAttributeSelect1 = GetBarHandle("AttributeRemoveWnd.gageAttributeSelect1");
	gageAttributeSelect2 = GetBarHandle("AttributeRemoveWnd.gageAttributeSelect2");
	btnAttributeSelect0 = GetCheckBoxHandle("AttributeRemoveWnd.btnAttributeSelect0");
	btnAttributeSelect1 = GetCheckBoxHandle("AttributeRemoveWnd.btnAttributeSelect1");
	btnAttributeSelect2 = GetCheckBoxHandle("AttributeRemoveWnd.btnAttributeSelect2");
	txtAttributeSelect0 = GetTextBoxHandle("AttributeRemoveWnd.txtAttributeSelect0");
	txtAttributeSelect1 = GetTextBoxHandle("AttributeRemoveWnd.txtAttributeSelect1");
	txtAttributeSelect2 = GetTextBoxHandle("AttributeRemoveWnd.txtAttributeSelect2");
	Script = InventoryWnd(GetScript("InventoryWnd"));
	toolTipScript = ToolTip(GetScript("Tooltip"));
	attributeWord[0] = "Fire";
	attributeWord[1] = "Water";
	attributeWord[2] = "Wind";
	attributeWord[3] = "Earth";
	attributeWord[4] = "Divine";
	attributeWord[5] = "Dark";
	beforeClickedItem = -1;
	return;
}

function initAttributeElements(bool visibleFlag)
{
	txtRemoveAdena.SetText("");
	gageAttributeSelect0.Clear();
	gageAttributeSelect1.Clear();
	gageAttributeSelect2.Clear();
	txtAttributeSelect0.SetText("");
	txtAttributeSelect1.SetText("");
	txtAttributeSelect2.SetText("");
	btnAttributeSelect0.SetCheck(false);
	btnAttributeSelect1.SetCheck(false);
	btnAttributeSelect2.SetCheck(false);
	if((visibleFlag == false))
	{
		btnAttributeSelect0.HideWindow();
		btnAttributeSelect1.HideWindow();
		btnAttributeSelect2.HideWindow();
		gageAttributeSelect0.HideWindow();
		gageAttributeSelect1.HideWindow();
		gageAttributeSelect2.HideWindow();
		txtAttributeSelect0.HideWindow();
		txtAttributeSelect1.HideWindow();
		txtAttributeSelect2.HideWindow();
	}
	else
	{
		btnAttributeSelect0.ShowWindow();
		btnAttributeSelect1.ShowWindow();
		btnAttributeSelect2.ShowWindow();
		gageAttributeSelect0.ShowWindow();
		gageAttributeSelect1.ShowWindow();
		gageAttributeSelect2.ShowWindow();
		txtAttributeSelect0.ShowWindow();
		txtAttributeSelect1.ShowWindow();
		txtAttributeSelect2.ShowWindow();
	}
	return;
}

function string getAttributeNumToStr(int Num)
{
	local string returnStr;

	returnStr = "";
	switch(Num)
	{
		case 0:
			returnStr = GetSystemString(1622);
			break;
		case 1:
			returnStr = GetSystemString(1623);
			break;
		case 2:
			returnStr = GetSystemString(1624);
			break;
		case 3:
			returnStr = GetSystemString(1625);
			break;
		case 4:
			returnStr = GetSystemString(1626);
			break;
		case 5:
			returnStr = GetSystemString(1627);
			break;
		default:
			Debug("UC Error : 잘못된 속성 타입 번호를 getAttributeNumToStr 메소드에 삽입하였습니다.");  // EN: UC Error : a bad attribute type number was passed to getAttributeNumToStr.
	}
	return returnStr;
}

function applyAttribute(int attributeNum)
{
	ItemWnd.GetSelectedItem(SelectItemInfo);
	if((SelectItemInfo.AttackAttributeValue > 0))
	{
		Class'NWindow.EnchantAPI'.static.RequestRemoveAttribute(SelectItemInfo.Id, SelectItemInfo.AttackAttributeType);
	}
	else
	{
		Class'NWindow.EnchantAPI'.static.RequestRemoveAttribute(SelectItemInfo.Id, attributeNum);
	}
	return;
}

function OnBtnOkClick()
{
	local string strName;
	local int attributeTypeByRadio, currentAttributerTypeRadio;

	strName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(SelectItemInfo.Id);
	Debug(("==> Attack: " @ string(SelectItemInfo.AttackAttributeValue)));
	Debug(("==> strName" @ strName));
	attributeTypeByRadio = attributerTypeRadio[getRadioButtonSelected()];
	if((SelectItemInfo.AttackAttributeValue > 0))
	{
		Debug(("==> call  " @ string(SelectItemInfo.AttackAttributeValue)));
		currentAttributerTypeRadio = attributeTypeByRadio;
	}
	else
	{
		Debug(("==> def attributeTypeByRadio  " @ string(attributeTypeByRadio)));
		if((attributeTypeByRadio == 0))
		{
			currentAttributerTypeRadio = 1;
		}
		else if((attributeTypeByRadio == 1))
		{
			currentAttributerTypeRadio = 0;
		}
		else if((attributeTypeByRadio == 2))
		{
			currentAttributerTypeRadio = 3;
		}
		else if((attributeTypeByRadio == 3))
		{
			currentAttributerTypeRadio = 2;
		}
		else if((attributeTypeByRadio == 4))
		{
			currentAttributerTypeRadio = 5;
		}
		else if((attributeTypeByRadio == 5))
		{
			currentAttributerTypeRadio = 4;
		}
	}
	Debug(("GetAdena():" @ string(GetAdena())));
	Debug(("txtRemoveAdena.GetText():" @ txtRemoveAdena.GetText()));
	Debug(("ItemWnd.GetSelectedNum()" @ string(ItemWnd.GetSelectedNum())));
	if((ItemWnd.GetSelectedNum() <= -1))
	{
		AddSystemMessage(242);
		return;
	}
	if((GetAdena() >= INT64(txtRemoveAdena.GetText())))
	{
		Debug("다이얼로그 출력");  // EN: dialog output
		Me.DisableWindow();
		DialogSetID(9001);
		DialogSetReservedInt(attributerTypeRadio[getRadioButtonSelected()]);
		DialogShow(DialogModalType_Modalless, DialogType_Warning, MakeFullSystemMsg(GetSystemMessage(3146), strName, getAttributeNumToStr(currentAttributerTypeRadio)));
	}
	else
	{
		AddSystemMessage(3156);
	}
	return;
}

function HandleDialogOK()
{
	if(DialogIsMine())
	{
		if((DialogGetID() == 9001))
		{
			applyAttribute(DialogGetReservedInt());
			Me.EnableWindow();
		}
	}
	return;
}

function OnbtnCancelClick()
{
	Me.HideWindow();
	ItemWnd.Clear();
	return;
}

function OnClickItem(string strID, int Index)
{
	local ItemInfo infItem;
	local int Price;

	Debug(("click strID" @ strID));
	Debug(("index" @ string(Index)));
	if((strID == "ItemWnd"))
	{
		if((beforeClickedItem != -1))
		{
			memoryAttributeSelectedRadio[beforeClickedItem] = getRadioButtonSelected();
		}
		ItemWnd.GetItem(Index, infItem);
		ItemWnd.GetSelectedItem(SelectItemInfo);
		btnOk.EnableWindow();
		setAttributeGages(infItem, memoryAttributeSelectedRadio[Index]);
		Price = int(infItem.DefaultPrice);
		txtRemoveAdena.SetText(MakeCostString(string(Price)));
		beforeClickedItem = Index;
	}
	return;
}

function HandleAttributeRemoveShow(string param)
{
	ItemWnd.Clear();
	initAttributeElements(false);
	btnOk.DisableWindow();
	Me.ShowWindow();
	Me.SetFocus();
	Me.EnableWindow();
	return;
}

function HandleAttributeRemoveItemData(string param)
{
	local int ServerID;
	local INT64 Adena;
	local ItemID sID;
	local ItemInfo infItem;

	ParseItemID(param, sID);
	ParseInt(param, "ServerID", ServerID);
	ParseINT64(param, "Adena", Adena);
	Class'NWindow.UIDATA_INVENTORY'.static.FindItem(ServerID, infItem);
	infItem.DefaultPrice = Adena;
	if((infItem.Id.ClassID > 0))
	{
		ItemWnd.AddItem(infItem);
	}
	return;
}

function HandleAttributeRemoveResult(string param)
{
	local int Result, removedAttr, GetItemNum;
	local ItemID sID;
	local ItemInfo targetItem;

	Me.EnableWindow();
	ParseInt(param, "Result", Result);
	ParseInt(param, "RemovedAttr", removedAttr);
	ParseInt(param, "ItemID", sID.ServerID);
	sID.ClassID = 0;
	GetItemNum = ItemWnd.GetSelectedNum();
	ItemWnd.GetItem(GetItemNum, targetItem);
	if((Result == 1))
	{
		if((targetItem.AttackAttributeValue > 0))
		{
			targetItem.AttackAttributeValue = 0;
			ItemWnd.DeleteItem(GetItemNum);
			memoryAttributeSelectedRadio.Remove(GetItemNum, 1);
			if((ItemWnd.GetItemNum() > 0))
			{
				ItemWnd.SetSelectedNum((GetItemNum - 1));
				OnClickItem("ItemWnd", (GetItemNum - 1));
			}
			else
			{
				ItemWnd.Clear();
				initAttributeElements(false);
				btnOk.DisableWindow();
			}
		}
		else if((getDefenseAttributeValue(targetItem) > 0))
		{
			switch(removedAttr)
			{
				case 0:
					targetItem.DefenseAttributeValueFire = 0;
					break;
				case 1:
					targetItem.DefenseAttributeValueWater = 0;
					break;
				case 2:
					targetItem.DefenseAttributeValueWind = 0;
					break;
				case 3:
					targetItem.DefenseAttributeValueEarth = 0;
					break;
				case 4:
					targetItem.DefenseAttributeValueHoly = 0;
					break;
				case 5:
					targetItem.DefenseAttributeValueUnholy = 0;
					break;
				default:
					break;
			}
			if((getDefenseAttributeValue(targetItem) > 0))
			{
				ItemWnd.SetItem(GetItemNum, targetItem);
				if((memoryAttributeSelectedRadio[GetItemNum] > 0))
				{
					memoryAttributeSelectedRadio[GetItemNum] = (memoryAttributeSelectedRadio[GetItemNum] - 1);
				}
				else
				{
					memoryAttributeSelectedRadio[GetItemNum] = 0;
				}
				beforeClickedItem = -1;
				ItemWnd.SetSelectedNum(GetItemNum);
				OnClickItem("ItemWnd", GetItemNum);
			}
			else
			{
				ItemWnd.DeleteItem(GetItemNum);
				memoryAttributeSelectedRadio.Remove(GetItemNum, 1);
				if((ItemWnd.GetItemNum() > 0))
				{
					if((ItemWnd.GetItemNum() == GetItemNum))
					{
						ItemWnd.SetSelectedNum((GetItemNum - 1));
						OnClickItem("ItemWnd", (GetItemNum - 1));
					}
					else
					{
						ItemWnd.SetSelectedNum(GetItemNum);
						OnClickItem("ItemWnd", GetItemNum);
					}
				}
				else
				{
					ItemWnd.Clear();
					initAttributeElements(false);
					btnOk.DisableWindow();
				}
			}
		}
	}
	else
	{
		Me.HideWindow();
		ItemWnd.Clear();
	}
	return;
}

function int getDefenseAttributeValue(ItemInfo targetItem)
{
	return (((((targetItem.DefenseAttributeValueFire + targetItem.DefenseAttributeValueWater) + targetItem.DefenseAttributeValueWind) + targetItem.DefenseAttributeValueEarth) + targetItem.DefenseAttributeValueHoly) + targetItem.DefenseAttributeValueUnholy);
}

function int getRadioButtonSelected()
{
	local int returnValueM;

	if(btnAttributeSelect2.IsChecked())
	{
		returnValueM = 2;
	}
	else if(btnAttributeSelect1.IsChecked())
	{
		returnValueM = 1;
	}
	else
	{
		returnValueM = 0;
	}
	return returnValueM;
}

function setRadioButton(int SelectNum)
{
	btnAttributeSelect0.SetCheck(false);
	btnAttributeSelect1.SetCheck(false);
	btnAttributeSelect2.SetCheck(false);
	if((SelectNum == 1))
	{
		btnAttributeSelect1.SetCheck(true);
	}
	else if((SelectNum == 2))
	{
		btnAttributeSelect2.SetCheck(true);
	}
	else
	{
		btnAttributeSelect0.SetCheck(true);
	}
	return;
}

function setAttributeGages(ItemInfo item, int selectedRadioButtonNum)
{
	local int i;
	local BarHandle currentGage;
	local TextBoxHandle currentTextBox;
	local CheckBoxHandle currentRadioButton;

	i = 0;
	while((i < 6))
	{
		tooltipStr[i] = "";
		i++;
	}
	i = 0;
	while((i < 3))
	{
		attributerTypeRadio[i] = 999;
		i++;
	}
	initAttributeElements(false);
	radioButtonCount = 0;
	if((item.AttackAttributeValue > 0))
	{
		toolTipScript.SetAttackAttribute(item.AttackAttributeValue, 0);
		toolTipScript.SetAttackAttribute(item.AttackAttributeValue, 1);
		toolTipScript.SetAttackAttribute(item.AttackAttributeValue, 2);
		toolTipScript.SetAttackAttribute(item.AttackAttributeValue, 3);
		toolTipScript.SetAttackAttribute(item.AttackAttributeValue, 4);
		toolTipScript.SetAttackAttribute(item.AttackAttributeValue, 5);
		switch(item.AttackAttributeType)
		{
			case 0:
				tooltipStr[0] = (((((((((GetSystemString(1622) $ " Lv ") $ string(toolTipScript.AttackAttLevel[0])) $ " (") $ GetSystemString(1622)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")");
				break;
			case 1:
				tooltipStr[1] = (((((((((GetSystemString(1623) $ " Lv ") $ string(toolTipScript.AttackAttLevel[1])) $ " (") $ GetSystemString(1623)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")");
				break;
			case 2:
				tooltipStr[2] = (((((((((GetSystemString(1624) $ " Lv ") $ string(toolTipScript.AttackAttLevel[2])) $ " (") $ GetSystemString(1624)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")");
				break;
			case 3:
				tooltipStr[3] = (((((((((GetSystemString(1625) $ " Lv ") $ string(toolTipScript.AttackAttLevel[3])) $ " (") $ GetSystemString(1625)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")");
				break;
			case 4:
				tooltipStr[4] = (((((((((GetSystemString(1626) $ " Lv ") $ string(toolTipScript.AttackAttLevel[4])) $ " (") $ GetSystemString(1626)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")");
				break;
			case 5:
				tooltipStr[5] = (((((((((GetSystemString(1627) $ " Lv ") $ string(toolTipScript.AttackAttLevel[5])) $ " (") $ GetSystemString(1627)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")");
				break;
			default:
				break;
		}
	}
	else
	{
		toolTipScript.SetDefAttribute(item.DefenseAttributeValueFire, 0);
		toolTipScript.SetDefAttribute(item.DefenseAttributeValueWater, 1);
		toolTipScript.SetDefAttribute(item.DefenseAttributeValueWind, 2);
		toolTipScript.SetDefAttribute(item.DefenseAttributeValueEarth, 3);
		toolTipScript.SetDefAttribute(item.DefenseAttributeValueHoly, 4);
		toolTipScript.SetDefAttribute(item.DefenseAttributeValueUnholy, 5);
		if((item.DefenseAttributeValueFire != 0))
		{
			tooltipStr[0] = (((((((((GetSystemString(1623) $ " Lv ") $ string(toolTipScript.DefAttLevel[0])) $ " (") $ GetSystemString(1622)) $ " ") $ GetSystemString(54)) $ " ") $ string(item.DefenseAttributeValueFire)) $ ")");
		}
		if((item.DefenseAttributeValueWater != 0))
		{
			tooltipStr[1] = (((((((((GetSystemString(1622) $ " Lv ") $ string(toolTipScript.DefAttLevel[1])) $ " (") $ GetSystemString(1623)) $ " ") $ GetSystemString(54)) $ " ") $ string(item.DefenseAttributeValueWater)) $ ")");
		}
		if((item.DefenseAttributeValueWind != 0))
		{
			tooltipStr[2] = (((((((((GetSystemString(1625) $ " Lv ") $ string(toolTipScript.DefAttLevel[2])) $ " (") $ GetSystemString(1624)) $ " ") $ GetSystemString(54)) $ " ") $ string(item.DefenseAttributeValueWind)) $ ")");
		}
		if((item.DefenseAttributeValueEarth != 0))
		{
			tooltipStr[3] = (((((((((GetSystemString(1624) $ " Lv ") $ string(toolTipScript.DefAttLevel[3])) $ " (") $ GetSystemString(1625)) $ " ") $ GetSystemString(54)) $ " ") $ string(item.DefenseAttributeValueEarth)) $ ")");
		}
		if((item.DefenseAttributeValueHoly != 0))
		{
			tooltipStr[4] = (((((((((GetSystemString(1627) $ " Lv ") $ string(toolTipScript.DefAttLevel[4])) $ " (") $ GetSystemString(1626)) $ " ") $ GetSystemString(54)) $ " ") $ string(item.DefenseAttributeValueHoly)) $ ")");
		}
		if((item.DefenseAttributeValueUnholy != 0))
		{
			tooltipStr[5] = (((((((((GetSystemString(1626) $ " Lv ") $ string(toolTipScript.DefAttLevel[5])) $ " (") $ GetSystemString(1627)) $ " ") $ GetSystemString(54)) $ " ") $ string(item.DefenseAttributeValueUnholy)) $ ")");
		}
	}
	if((item.AttackAttributeValue > 0))
	{
		i = 0;
		while((i < 6))
		{
			if((tooltipStr[i] == ""))
			{
				i++;
				continue;
				i++;
				continue;
			}
			currentGage = GetBarHandle(("AttributeRemoveWnd.gageAttributeSelect" $ string(radioButtonCount)));
			currentTextBox = GetTextBoxHandle(("AttributeRemoveWnd.txtAttributeSelect" $ string(radioButtonCount)));
			currentRadioButton = GetCheckBoxHandle(("AttributeRemoveWnd.btnAttributeSelect" $ string(radioButtonCount)));
			currentGage.Clear();
			currentGage.SetValue(toolTipScript.AttackAttMaxValue[i], toolTipScript.AttackAttCurrValue[i]);
			setColorBar(currentGage, i);
			currentGage.ShowWindow();
			currentTextBox.ShowWindow();
			currentRadioButton.ShowWindow();
			currentTextBox.SetText(tooltipStr[i]);
			attributerTypeRadio[radioButtonCount] = i;
			radioButtonCount++;
			i++;
		}
	}
	else
	{
		i = 0;
		while((i < 6))
		{
			if((tooltipStr[i] == ""))
			{
				i++;
				continue;
				i++;
				continue;
			}
			currentGage = GetBarHandle(("AttributeRemoveWnd.gageAttributeSelect" $ string(radioButtonCount)));
			currentTextBox = GetTextBoxHandle(("AttributeRemoveWnd.txtAttributeSelect" $ string(radioButtonCount)));
			currentRadioButton = GetCheckBoxHandle(("AttributeRemoveWnd.btnAttributeSelect" $ string(radioButtonCount)));
			currentGage.Clear();
			currentGage.SetValue(toolTipScript.DefAttMaxValue[i], toolTipScript.DefAttCurrValue[i]);
			setColorBar(currentGage, i);
			currentGage.ShowWindow();
			currentTextBox.ShowWindow();
			currentRadioButton.ShowWindow();
			currentTextBox.SetText(tooltipStr[i]);
			attributerTypeRadio[radioButtonCount] = i;
			radioButtonCount++;
			i++;
		}
	}
	setRadioButton(selectedRadioButtonNum);
	return;
}

function setColorBar(BarHandle bar, int SelectNum)
{
	bar.SetTexture(0, (("L2UI_CT1.Gauge_DF_Attribute_" $ attributeWord[SelectNum]) $ "_Left"));
	bar.SetTexture(1, (("L2UI_CT1.Gauge_DF_Attribute_" $ attributeWord[SelectNum]) $ "_Center"));
	bar.SetTexture(2, (("L2UI_CT1.Gauge_DF_Attribute_" $ attributeWord[SelectNum]) $ "_Right"));
	bar.SetTexture(3, (("L2UI_CT1.Gauge_DF_Attribute_" $ attributeWord[SelectNum]) $ "_Bg_Left"));
	bar.SetTexture(4, (("L2UI_CT1.Gauge_DF_Attribute_" $ attributeWord[SelectNum]) $ "_Bg_Center"));
	bar.SetTexture(5, (("L2UI_CT1.Gauge_DF_Attribute_" $ attributeWord[SelectNum]) $ "_Bg_Right"));
	return;
}

function BarHandle selectBarHandle(int SelectNum)
{
	local BarHandle returnValueM;

	if((SelectNum == 0))
	{
		returnValueM = gageAttributeSelect0;
	}
	else if((SelectNum == 1))
	{
		returnValueM = gageAttributeSelect1;
	}
	else if((SelectNum == 2))
	{
		returnValueM = gageAttributeSelect2;
	}
	return returnValueM;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	OnbtnCancelClick();
	return;
}
