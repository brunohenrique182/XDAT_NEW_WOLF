class GMFindTreeWndItem extends UICommonAPI;

enum ATTRIBUTECOMBOTYPE
{
	ATTRIBUTE_NONE,                 // 0
	ATTRIBUTE_FIRE,                 // 1
	ATTRIBUTE_WATER,                // 2
	ATTRIBUTE_WIND,                 // 3
	ATTRIBUTE_EARTH,                // 4
	ATTRIBUTE_HOLY,                 // 5
	ATTRIBUTE_UNHOLY                // 6
};

var WindowHandle Me;
var string m_Windowname;
var TextBoxHandle textBoxEnchant;
var EditBoxHandle editBoxEnchant;
var TextBoxHandle textBoxAttribute0;
var EditBoxHandle editBoxAttribute0;
var ComboBoxHandle comboAttribute0;
var TextBoxHandle textBoxAttribute1;
var EditBoxHandle editBoxAttribute1;
var ComboBoxHandle comboAttribute1;
var TextBoxHandle textBoxAttribute2;
var EditBoxHandle editBoxAttribute2;
var ComboBoxHandle comboAttribute2;
var TextBoxHandle textBoxOptioinNormal;
var EditBoxHandle editBoxOptioinNormal;
var TextBoxHandle textBoxOptioinRandom;
var EditBoxHandle editBoxOptioinRandom;
var TextBoxHandle textBoxOption3;
var EditBoxHandle editBoxOption3;
var TextBoxHandle textBoxEnsoul0;
var EditBoxHandle editBoxEnsoul0;
var TextBoxHandle textBoxEnsoul1;
var EditBoxHandle editBoxEnsoul1;
var TextBoxHandle textBoxEnsoul2;
var EditBoxHandle editBoxEnsoul2;
var GMFindTreeWnd GMFindTreeWndScript;
var ButtonHandle summonButton;
var ListCtrlHandle summonList;
var CheckBoxHandle checkBoxBless;
var int ItemID;
var L2Util util;

function OnLoad()
{
	SetClosingOnESC();
	Me = GetWindowHandle(m_Windowname);
	textBoxEnchant = GetTextBoxHandle((m_Windowname $ ".textBoxEnchant"));
	editBoxEnchant = GetEditBoxHandle((m_Windowname $ ".editBoxEnchant"));
	textBoxAttribute0 = GetTextBoxHandle((m_Windowname $ ".textBoxAttribute0"));
	editBoxAttribute0 = GetEditBoxHandle((m_Windowname $ ".editBoxAttribute0"));
	comboAttribute0 = GetComboBoxHandle((m_Windowname $ ".comboAttribute0"));
	AddComboxStrings(comboAttribute0);
	textBoxAttribute1 = GetTextBoxHandle((m_Windowname $ ".textBoxAttribute1"));
	editBoxAttribute1 = GetEditBoxHandle((m_Windowname $ ".editBoxAttribute1"));
	comboAttribute1 = GetComboBoxHandle((m_Windowname $ ".comboAttribute1"));
	AddComboxStrings(comboAttribute1);
	textBoxAttribute2 = GetTextBoxHandle((m_Windowname $ ".textBoxAttribute2"));
	editBoxAttribute2 = GetEditBoxHandle((m_Windowname $ ".editBoxAttribute2"));
	comboAttribute2 = GetComboBoxHandle((m_Windowname $ ".comboAttribute2"));
	AddComboxStrings(comboAttribute2);
	textBoxOptioinNormal = GetTextBoxHandle((m_Windowname $ ".textBoxOptioinNormal"));
	editBoxOptioinNormal = GetEditBoxHandle((m_Windowname $ ".editBoxOptioinNormal"));
	textBoxOptioinRandom = GetTextBoxHandle((m_Windowname $ ".textBoxOptioinRandom"));
	editBoxOptioinRandom = GetEditBoxHandle((m_Windowname $ ".editBoxOptioinRandom"));
	textBoxOption3 = GetTextBoxHandle((m_Windowname $ ".textBoxOption3"));
	editBoxOption3 = GetEditBoxHandle((m_Windowname $ ".editBoxOption3"));
	textBoxEnsoul0 = GetTextBoxHandle((m_Windowname $ ".textBoxEnsoul0"));
	editBoxEnsoul0 = GetEditBoxHandle((m_Windowname $ ".editBoxEnsoul0"));
	textBoxEnsoul1 = GetTextBoxHandle((m_Windowname $ ".textBoxEnsoul1"));
	editBoxEnsoul1 = GetEditBoxHandle((m_Windowname $ ".editBoxEnsoul1"));
	textBoxEnsoul2 = GetTextBoxHandle((m_Windowname $ ".textBoxEnsoul2"));
	editBoxEnsoul2 = GetEditBoxHandle((m_Windowname $ ".editBoxEnsoul2"));
	summonButton = GetButtonHandle((m_Windowname $ ".btnSummon"));
	summonList = GetListCtrlHandle((m_Windowname $ ".ListFindWnd"));
	checkBoxBless = GetCheckBoxHandle((m_Windowname $ ".CheckBoxBless"));
	GMFindTreeWndScript = GMFindTreeWnd(GetScript("GMFindTreeWnd"));
	util = L2Util(GetScript("L2Util"));
	summonList.SetSelectedSelTooltip(false);
	summonList.SetAppearTooltipAtMouseX(true);
	LoadLists();
	return;
}

function OnShow()
{
	SetDisableAllHandles();
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnSummon":
			HandleSummon();
			break;
		case "BtnEditUp":
			LineUP();
			break;
		case "BtnEditDown":
			LineDown();
			break;
		case "BtnEditAdd":
			HandleAdd();
			break;
		case "BtnEditdel":
			HandleDelete();
			break;
		case "BtnEditAlldel":
			HandleDeleteAll();
			break;
		case "btnCopy":
			HandleCopyBuildcommand();
			break;
		case "btnDetail":
			if(GetWindowHandle("UIItemToolWnd").IsShowWindow())
			{
				GetWindowHandle("UIItemToolWnd").HideWindow();
			}
			else
			{
				GetWindowHandle("UIItemToolWnd").ShowWindow();
				GetWindowHandle("UIItemToolWnd").SetFocus();
			}
			break;
		default:
			break;
	}
	return;
}

function OnComboBoxItemSelected(string strID, int IndexID)
{
	switch(strID)
	{
		case "comboAttribute0":
		case "comboAttribute1":
		case "comboAttribute2":
			CheckAtrributeTypeChanged(strID, IndexID);
			break;
		default:
			break;
	}
	return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	local LVDataRecord Record;
	local int selectedIdx;
	local array<string> params;

	selectedIdx = summonList.GetSelectedIndex();
	summonList.GetRec(selectedIdx, Record);
	GMFindTreeWndScript.ShowList(string(Record.nReserved1), LISTTYPE_ITEM);
	SetItemID(int(Record.nReserved1));
	Split(Record.LVDataList[1].szData, "/", params);
	comboAttribute0.SetSelectedNum((int(params[0]) + 1));
	editBoxAttribute0.SetString(params[1]);
	comboAttribute1.SetSelectedNum((int(params[2]) + 1));
	editBoxAttribute1.SetString(params[3]);
	comboAttribute2.SetSelectedNum((int(params[4]) + 1));
	editBoxAttribute2.SetString(params[5]);
	editBoxEnchant.SetString(params[6]);
	editBoxOptioinNormal.SetString(params[7]);
	editBoxOptioinRandom.SetString(params[8]);
	editBoxOption3.SetString(params[9]);
	editBoxEnsoul0.SetString(params[10]);
	editBoxEnsoul1.SetString(params[11]);
	editBoxEnsoul2.SetString(params[12]);
	return;
}

function OnDrawerHideFinished()
{
	SaveLists();
	return;
}

function LineUP()
{
	local int selectedIdx;
	local LVDataRecord recordSelected, recordUp;

	selectedIdx = summonList.GetSelectedIndex();
	if((selectedIdx < 1))
	{
		return;
	}
	summonList.GetRec(selectedIdx, recordSelected);
	summonList.GetRec((selectedIdx - 1), recordUp);
	summonList.ModifyRecord(selectedIdx, recordUp);
	summonList.ModifyRecord((selectedIdx - 1), recordSelected);
	summonList.SetSelectedIndex((selectedIdx - 1), true);
	return;
}

function LineDown()
{
	local int selectedIdx, Count;
	local LVDataRecord recordSelected, recordDown;

	selectedIdx = summonList.GetSelectedIndex();
	Count = summonList.GetRecordCount();
	if(((selectedIdx == -1) && (selectedIdx == (Count - 1))))
	{
		return;
	}
	summonList.GetRec(selectedIdx, recordSelected);
	summonList.GetRec((selectedIdx + 1), recordDown);
	summonList.ModifyRecord(selectedIdx, recordDown);
	summonList.ModifyRecord((selectedIdx + 1), recordSelected);
	summonList.SetSelectedIndex((selectedIdx + 1), true);
	return;
}

function HandleDelete()
{
	local int selectedIdx;

	selectedIdx = summonList.GetSelectedIndex();
	if((selectedIdx == -1))
	{
		getInstanceL2Util().showGfxScreenMessage("선택 된 아이템이 없습니다.");  // EN: no item is selected.
	}
	else
	{
		RemoveINI("GMSummon", string((summonList.GetRecordCount() - 1)), "UIDEV.ini");
		summonList.DeleteRecord(selectedIdx);
		if((summonList.GetRecordCount() == selectedIdx))
		{
			summonList.SetSelectedIndex((selectedIdx - 1), true);
		}
	}
	return;
}

function HandleDeleteAll()
{
	local int i, Count;

	Count = summonList.GetRecordCount();
	i = 0;
	while((i < Count))
	{
		RemoveINI("GMSummon", string(i), "UIDEV.ini");
		i++;
	}
	summonList.DeleteAllItem();
	return;
}

function HandleAdd()
{
	local int SelectedIndex;

	SelectedIndex = GetIsSameRecord();
	if((SelectedIndex > -1))
	{
		summonList.SetSelectedIndex(SelectedIndex, true);
		getInstanceL2Util().showGfxScreenMessage("등록 된 아이템이 존재 합니다.");  // EN: a registered item already exists.
		return;
	}
	if((ItemID > 0))
	{
		summonList.InsertRecord(makeRecord());
		summonList.SetSelectedIndex((summonList.GetRecordCount() - 1), true);
	}
	return;
}

function HandleSummon()
{
	ExecuteCommand(MakeSummonCommand());
	return;
}

function SaveLists()
{
	local int Count, i;
	local string param;
	local LVDataRecord Record;

	Debug(("OnHide count 00 " $ string(Count)));
	Count = summonList.GetRecordCount();
	i = 0;
	while((i < Count))
	{
		summonList.GetRec(i, Record);
		param = "";
		ParamAdd(param, "itemID", string(Record.nReserved1));
		ParamAdd(param, "params", Record.LVDataList[1].szData);
		Debug(("OnHide count" $ string(Count)));
		SetINIString("GMSummon", string(i), param, "UIDEV.ini");
		i++;
	}
	return;
}

function LoadLists()
{
	local string param, params;
	local bool bUseParam;
	local int i, tmpItemID;

	i = 0;
	bUseParam = GetINIString("GMSummon", string(i), param, "UIDEV.ini");
	while(bUseParam)
	{
		ParseInt(param, "itemID", tmpItemID);
		ParseString(param, "params", params);
		summonList.InsertRecord(MakeRecordByParmas(tmpItemID, params));
		i++;
		bUseParam = GetINIString("GMSummon", string(i), param, "UIDEV.ini");
	}
	return;
}

function HandleCopyBuildcommand()
{
	local string buildcommand;

	buildcommand = MakeSummonCommand();
	getInstanceL2Util().showGfxScreenMessage(("Copy...... <br>" $ buildcommand));
	ClipboardCopy(buildcommand);
	return;
}

function LVDataRecord makeRecord()
{
	return MakeRecordByParmas(ItemID, MakeParam());
}

function LVDataRecord MakeRecordByParmas(int tmpItemID, string params)
{
	local LVDataRecord Record;
	local ItemInfo inItem;
	local string toolTipParam;

	Record.LVDataList.Length = 2;
	Record.nReserved1 = INT64(tmpItemID);
	inItem = MakeItemInfoWithParams(tmpItemID, params);
	ItemInfoToParam(inItem, toolTipParam);
	Record.szReserved = toolTipParam;
	Record.LVDataList[0].szData = inItem.Name;
	Record.LVDataList[0].textAlignment = TA_Left;
	Record.LVDataList[1].szData = params;
	Record.LVDataList[1].textAlignment = TA_Center;
	return Record;
}

function ItemInfo MakeItemInfoWithParams(int tmpItemID, string params)
{
	local ItemInfo inItem;
	local array<string> paramArray;

	inItem = GetItemInfoByClassID(tmpItemID);
	Split(params, "/", paramArray);
	switch(inItem.ItemType)
	{
		case 0:
			inItem.AttackAttributeType = int(paramArray[0]);
			inItem.AttackAttributeValue = int(paramArray[1]);
			break;
		case 1:
			GetItemWithAttribute(int(paramArray[0]), int(paramArray[1]), inItem);
			GetItemWithAttribute(int(paramArray[2]), int(paramArray[3]), inItem);
			GetItemWithAttribute(int(paramArray[4]), int(paramArray[5]), inItem);
			break;
		default:
			break;
	}
	inItem.Enchanted = int(paramArray[6]);
	inItem.RefineryOp1 = int(paramArray[7]);
	inItem.RefineryOp2 = int(paramArray[8]);
	inItem.RefineryOp3 = int(paramArray[9]);
	inItem.EnsoulOption[0].OptionArray.Length = 3;
	inItem.EnsoulOption[0].OptionArray[0] = int(paramArray[10]);
	inItem.EnsoulOption[0].OptionArray[1] = int(paramArray[11]);
	inItem.EnsoulOption[0].OptionArray[2] = int(paramArray[12]);
	return inItem;
}

function string MakeParam()
{
	local string enchantNum, attributeType0, attributeType1, attributeType2, attributeLvString0, attributeLvString1, attributeLvString2, optionNormalID, optionRandomID, optionID3, ensoul0, ensoul1, ensoul2, param;

	param = "";
	attributeType0 = string(GetIntAttribute(comboAttribute0));
	attributeLvString0 = GetStringNumWithEditBox(editBoxAttribute0);
	attributeType1 = string(GetIntAttribute(comboAttribute1));
	attributeLvString1 = GetStringNumWithEditBox(editBoxAttribute1);
	attributeType2 = string(GetIntAttribute(comboAttribute2));
	attributeLvString2 = GetStringNumWithEditBox(editBoxAttribute2);
	enchantNum = GetStringNumWithEditBox(editBoxEnchant);
	optionNormalID = GetStringNumWithEditBox(editBoxOptioinNormal);
	optionRandomID = GetStringNumWithEditBox(editBoxOptioinRandom);
	optionID3 = GetStringNumWithEditBox(editBoxOption3);
	ensoul0 = GetStringNumWithEditBox(editBoxEnsoul0);
	ensoul1 = GetStringNumWithEditBox(editBoxEnsoul1);
	ensoul2 = GetStringNumWithEditBox(editBoxEnsoul2);
	param = (attributeType0 $ "/");
	param = ((param $ attributeLvString0) $ "/");
	param = ((param $ attributeType1) $ "/");
	param = ((param $ attributeLvString1) $ "/");
	param = ((param $ attributeType2) $ "/");
	param = ((param $ attributeLvString2) $ "/");
	param = ((param $ enchantNum) $ "/");
	param = ((param $ optionNormalID) $ "/");
	param = ((param $ optionRandomID) $ "/");
	param = ((param $ optionID3) $ "/");
	param = ((param $ ensoul0) $ "/");
	param = ((param $ ensoul1) $ "/");
	param = (param $ ensoul2);
	return param;
}

function int GetFireAttribute()
{
	local int i;
	local EditBoxHandle editBoxAttribute;
	local ComboBoxHandle comboAttribute;

	i = 0;
	while((i < 3))
	{
		comboAttribute = GetComboBoxHandle(((m_Windowname $ ".comboAttribute") $ string(i)));
		if((GetIntAttribute(comboAttribute) != 0))
		{
			i++;
			continue;
		}
		editBoxAttribute = GetEditBoxHandle(((m_Windowname $ ".editBoxAttribute") $ string(i)));
		return int(GetStringNumWithEditBox(editBoxAttribute));
		i++;
	}
	return 0;
}

function int GetWaterAttribute()
{
	local int i;
	local EditBoxHandle editBoxAttribute;
	local ComboBoxHandle comboAttribute;

	i = 0;
	while((i < 3))
	{
		comboAttribute = GetComboBoxHandle(((m_Windowname $ ".comboAttribute") $ string(i)));
		if((GetIntAttribute(comboAttribute) != 1))
		{
			i++;
			continue;
		}
		editBoxAttribute = GetEditBoxHandle(((m_Windowname $ ".editBoxAttribute") $ string(i)));
		return int(GetStringNumWithEditBox(editBoxAttribute));
		i++;
	}
	return 0;
}

function SetDefaultAttribute(int Index, int defaultAttribute, int defaultAttributeLv, out int oAttribute, out int oAttributeLv)
{
	local int attribute;
	local ComboBoxHandle comboAttribute;

	comboAttribute = GetComboBoxHandle(((m_Windowname $ ".comboAttribute") $ string(Index)));
	attribute = GetIntAttribute(comboAttribute);
	if((attribute == -1))
	{
		oAttribute = defaultAttribute;
		defaultAttributeLv = oAttributeLv;
	}
	else
	{
		oAttribute = attribute;
	}
	oAttributeLv = int(GetStringNumWithEditBox(GetEditBoxHandle(((m_Windowname $ ".editBoxAttribute") $ string(Index)))));
	return;
}

function string MakeSummonCommand()
{
	local string enchantNum, attributeType0, attributeType1, attributeType2, attributeLvString0, attributeLvString1, attributeLvString2, optionNormalID, optionRandomID, optionID3, ensoul0, ensoul1, ensoul2;
	local int attribute0, attribute1, attribute2, attributeLv0, attributeLv1, attributeLv2, waterAttribtueLv, fireAttributeLv, isBless, defaultAttribute, defaultAttributeLv;

	enchantNum = GetStringNumWithEditBox(editBoxEnchant);
	fireAttributeLv = GetFireAttribute();
	waterAttribtueLv = GetWaterAttribute();
	if((waterAttribtueLv > 0))
	{
		defaultAttribute = 1;
		defaultAttributeLv = waterAttribtueLv;
	}
	else
	{
		defaultAttribute = 0;
		defaultAttributeLv = fireAttributeLv;
	}
	SetDefaultAttribute(0, defaultAttribute, defaultAttributeLv, attribute0, attributeLv0);
	SetDefaultAttribute(1, defaultAttribute, defaultAttributeLv, attribute1, attributeLv1);
	SetDefaultAttribute(2, defaultAttribute, defaultAttributeLv, attribute2, attributeLv2);
	attributeType0 = string(attribute0);
	attributeLvString0 = string(attributeLv0);
	attributeType1 = string(attribute1);
	attributeLvString1 = string(attributeLv1);
	attributeType2 = string(attribute2);
	attributeLvString2 = string(attributeLv2);
	optionNormalID = GetStringNumWithEditBox(editBoxOptioinNormal);
	optionRandomID = GetStringNumWithEditBox(editBoxOptioinRandom);
	optionID3 = GetStringNumWithEditBox(editBoxOption3);
	ensoul0 = GetStringNumWithEditBox(editBoxEnsoul0);
	ensoul1 = GetStringNumWithEditBox(editBoxEnsoul1);
	ensoul2 = GetStringNumWithEditBox(editBoxEnsoul2);
	if(checkBoxBless.IsChecked())
	{
		isBless = 1;
	}
	else
	{
		isBless = 0;
	}
	if((((((((((attributeType0 != "0") || (attributeType1 != "0")) || (attributeType2 != "0")) || (optionNormalID != "0")) || (optionRandomID != "0")) || (ensoul0 != "0")) || (ensoul1 != "0")) || (ensoul2 != "0")) || (isBless == 1)))
	{
		if(IsHairAccessary())
		{
			if((isBless == 1))
			{
				getInstanceL2Util().showGfxScreenMessage("S급 부터 축복+제련이 가능 합니다.");  // EN?: From class S, you can bless + refine.
				Debug((("//summon_bless" @ string(ItemID)) @ enchantNum));
				return (("//summon_bless" @ string(ItemID)) @ enchantNum);
			}
			else
			{
				Debug(((((("//summon_option" @ string(ItemID)) @ optionNormalID) @ optionRandomID) @ optionID3) @ enchantNum));
				return ((((("//summon_option" @ string(ItemID)) @ optionNormalID) @ optionRandomID) @ optionID3) @ enchantNum);
			}
		}
		else
		{
			Debug(((((((((((((((("HandleSummon : //summon_attribute" @ string(ItemID)) @ attributeType0) @ attributeLvString0) @ attributeType1) @ attributeLvString1) @ attributeType2) @ attributeLvString2) @ enchantNum) @ optionNormalID) @ optionRandomID) @ optionID3) @ ensoul0) @ ensoul1) @ ensoul2) @ string(isBless)));
			return ((((((((((((((("//summon_attribute" @ string(ItemID)) @ attributeType0) @ attributeLvString0) @ attributeType1) @ attributeLvString1) @ attributeType2) @ attributeLvString2) @ enchantNum) @ optionNormalID) @ optionRandomID) @ optionID3) @ ensoul0) @ ensoul1) @ ensoul2) @ string(isBless));
		}
	}
	if((enchantNum != "0"))
	{
		return (("//summon2" @ enchantNum) @ string(ItemID));
	}
	return (("//summon" @ string(ItemID)) @ "1");
}

function SetDisableAllHandles()
{
	SetEnchant(false);
	SetAttribute(false, 0);
	SetAttribute(false, 1);
	SetAttribute(false, 2);
	SetOptions(false);
	SetEnsoul(false);
	SetBless(false);
	summonButton.DisableWindow();
	return;
}

function SetItemID(int Id)
{
	local ItemInfo infItem;

	ItemID = Id;
	infItem = GetItemInfoByClassID(ItemID);
	SetDisableAllHandles();
	switch(infItem.ItemType)
	{
		case 0:
			SetEnchant(true);
			if((!getInstanceUIData().GetIsClassicServer() && IsSGradeMoreThan()))
			{
				SetAttribute(true, 0);
			}
			SetOptions(true);
			if(IsSGradeMoreThan())
			{
				SetEnsoul(true);
			}
			if(CanBless())
			{
				SetBless(true);
			}
			summonButton.EnableWindow();
			Me.ShowWindow();
			break;
		case 1:
			SetEnchant(true);
			SetOptions(true);
			if((!getInstanceUIData().GetIsClassicServer() && IsSGradeMoreThan()))
			{
				SetAttribute(true, 0);
				SetAttribute(true, 1);
				SetAttribute(true, 2);
			}
			summonButton.EnableWindow();
			Me.ShowWindow();
			break;
		case 2:
			SetEnchant(true);
			SetOptions(true);
			summonButton.EnableWindow();
			Me.ShowWindow();
			break;
		default:
			if((int(byte(infItem.EtcItemType)) == 7))
			{
				SetEnchant(true);
				summonButton.EnableWindow();
				Me.ShowWindow();
			}
			break;
	}
	return;
}

function SetEnchant(bool bEnable)
{
	if(bEnable)
	{
		textBoxEnchant.SetTextColor(util.Gold);
		editBoxEnchant.EnableWindow();
	}
	else
	{
		textBoxEnchant.SetTextColor(util.Gray);
		editBoxEnchant.DisableWindow();
	}
	return;
}

function SetAttribute(bool bEnable, int Index)
{
	local TextBoxHandle textBox;
	local EditBoxHandle EditBox;
	local ComboBoxHandle comboBox;

	textBox = GetTextBoxHandle(((m_Windowname $ ".textBoxAttribute") $ string(Index)));
	EditBox = GetEditBoxHandle(((m_Windowname $ ".editBoxAttribute") $ string(Index)));
	comboBox = GetComboBoxHandle(((m_Windowname $ ".comboAttribute") $ string(Index)));
	if(bEnable)
	{
		textBox.SetTextColor(util.Gold);
		EditBox.EnableWindow();
		comboBox.EnableWindow();
	}
	else
	{
		textBox.SetTextColor(util.Gray);
		EditBox.DisableWindow();
		comboBox.DisableWindow();
	}
	return;
}

function SetOptions(bool bEnable)
{
	if(bEnable)
	{
		textBoxOptioinNormal.SetTextColor(util.Gold);
		editBoxOptioinNormal.EnableWindow();
		textBoxOptioinRandom.SetTextColor(util.Gold);
		editBoxOptioinRandom.EnableWindow();
		textBoxOption3.SetTextColor(util.Gold);
		editBoxOption3.EnableWindow();
	}
	else
	{
		textBoxOptioinNormal.SetTextColor(util.Gray);
		editBoxOptioinNormal.DisableWindow();
		textBoxOptioinRandom.SetTextColor(util.Gray);
		editBoxOptioinRandom.DisableWindow();
		textBoxOption3.SetTextColor(util.Gray);
		editBoxOption3.DisableWindow();
	}
	return;
}

function SetEnsoul(bool bEnable)
{
	if(bEnable)
	{
		textBoxEnsoul0.SetTextColor(util.Gold);
		editBoxEnsoul0.EnableWindow();
		textBoxEnsoul1.SetTextColor(util.Gold);
		editBoxEnsoul1.EnableWindow();
		textBoxEnsoul2.SetTextColor(util.Gold);
		editBoxEnsoul2.EnableWindow();
	}
	else
	{
		textBoxEnsoul0.SetTextColor(util.Gray);
		editBoxEnsoul0.DisableWindow();
		textBoxEnsoul1.SetTextColor(util.Gray);
		editBoxEnsoul1.DisableWindow();
		textBoxEnsoul2.SetTextColor(util.Gray);
		editBoxEnsoul2.DisableWindow();
	}
	return;
}

function SetBless(bool bEnable)
{
	if(bEnable)
	{
		checkBoxBless.EnableWindow();
	}
	else
	{
		checkBoxBless.DisableWindow();
	}
	return;
}

function int GetIsSameRecord()
{
	local LVDataRecord Record;
	local ItemInfo inItem;
	local string toolTipParam;
	local int i;

	inItem = MakeItemInfoWithParams(ItemID, MakeParam());
	ItemInfoToParam(inItem, toolTipParam);
	i = 0;
	while((i < summonList.GetRecordCount()))
	{
		summonList.GetRec(i, Record);
		if((Record.szReserved == toolTipParam))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function CheckAtrributeTypeChanged(string strID, int IndexID)
{
	local int tmpInt, i;
	local ComboBoxHandle comboBox;

	if((IndexID == 0))
	{
		return;
	}
	i = 0;
	while((i < 3))
	{
		if((("comboAttribute" $ string(i)) == strID))
		{
			i++;
			continue;
		}
		comboBox = GetComboBoxHandle(((m_Windowname $ ".comboAttribute") $ string(i)));
		tmpInt = comboBox.GetSelectedNum();
		if((tmpInt == IndexID))
		{
			comboBox.SetSelectedNum(0);
			i++;
			continue;
		}
		if(IsAttributeOpposite(IndexID, tmpInt))
		{
			comboBox.SetSelectedNum(0);
			getInstanceL2Util().showGfxScreenMessage((string(tmpInt) $ "번 상성 속성을 초기화 했습니다."));  // EN: reset the elemental attribute number.
		}
		i++;
	}
	return;
}

function bool IsAttributeOpposite(int indexMine, int indexTarget)
{
	switch(indexMine)
	{
		case 1:
			if((indexTarget == 2))
			{
				return true;
			}
			break;
		case 2:
			if((indexTarget == 1))
			{
				return true;
			}
			break;
		case 3:
			if((indexTarget == 4))
			{
				return true;
			}
			break;
		case 4:
			if((indexTarget == 3))
			{
				return true;
			}
			break;
		case 5:
			if((indexTarget == 6))
			{
				return true;
			}
			break;
		case 6:
			if((indexTarget == 5))
			{
				return true;
			}
			break;
		default:
			break;
	}
}

function bool GetCanSummon()
{
	local ItemInfo infItem;

	infItem = GetItemInfoByClassID(ItemID);
	switch(infItem.ItemType)
	{
		case 0:
		case 1:
		case 2:
			break;
		default:
			return false;
	}
	if(getInstanceUIData().GetIsLiveServer())
	{
		if(!IsSGradeMoreThan())
		{
			return IsHairAccessary();
		}
		return true;
	}
	else if(getInstanceUIData().GetIsClassicServer())
	{
		return true;
	}
	return false;
}

function bool IsSGradeMoreThan()
{
	local ItemInfo infItem;

	infItem = GetItemInfoByClassID(ItemID);
	switch(infItem.CrystalType)
	{
		case 5:
		case 6:
		case 7:
		case 8:
		case 9:
		case 10:
		case 11:
			return true;
		default:
			return false;
	}
}

function bool IsHairAccessary()
{
	local ItemInfo infItem;

	infItem = GetItemInfoByClassID(ItemID);
	if((infItem.ItemType == 1))
	{
		if((((infItem.SlotBitType == INT64(65536)) || (infItem.SlotBitType == INT64(524288))) || (infItem.SlotBitType == INT64(262144))))
		{
			return true;
		}
	}
	return false;
}

function bool CanBless()
{
	local ItemInfo infItem;

	infItem = GetItemInfoByClassID(ItemID);
	return (infItem.EnchantBlessGroupID > 0);
}

function GetItemWithAttribute(int Index, int Value, out ItemInfo inItem)
{
	switch(Index)
	{
		case 0:
			break;
		case 1:
			inItem.DefenseAttributeValueFire = Value;
			break;
		case 2:
			inItem.DefenseAttributeValueWater = Value;
			break;
		case 3:
			inItem.DefenseAttributeValueWind = Value;
			break;
		case 4:
			inItem.DefenseAttributeValueEarth = Value;
			break;
		case 5:
			inItem.DefenseAttributeValueHoly = Value;
			break;
		case 6:
			inItem.DefenseAttributeValueUnholy = Value;
			break;
		default:
			break;
	}
	return;
}

function string GetStringNumWithEditBox(EditBoxHandle EditBox)
{
	if(EditBox.IsEnableWindow())
	{
		return string(int(EditBox.GetString()));
	}
	return "0";
}

function int GetIntAttribute(ComboBoxHandle comboBox)
{
	if(!comboBox.IsEnableWindow())
	{
		return -1;
	}
	return (comboBox.GetSelectedNum() - 1);
}

function AddComboxStrings(ComboBoxHandle comboxHandle)
{
	comboxHandle.AddString(GetSystemString(27));
	comboxHandle.AddString(GetSystemString(1622));
	comboxHandle.AddString(GetSystemString(1623));
	comboxHandle.AddString(GetSystemString(1624));
	comboxHandle.AddString(GetSystemString(1625));
	comboxHandle.AddString(GetSystemString(1626));
	comboxHandle.AddString(GetSystemString(1627));
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
	m_Windowname="GMFindTreeWndItem"
}
