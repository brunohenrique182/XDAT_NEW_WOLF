class QuestConfirmWnd extends UICommonAPI;

const DIALOG_TOOLTIP_KEY0 = "\\#$Tooltip0";
const TXTQUESTTARGET_WIDTH = 272;

var TextBoxHandle txtQuestTitle;
var TextBoxHandle txtQuestCategory;
var TextBoxHandle txtRecommandedLevel;
var TextBoxHandle txtRecommandedLevelText;
var TextBoxHandle txtQuestType;
var TextBoxHandle txtQuestTarget;
var TextBoxHandle txtQuestRewardItemTreeTitle;
var TreeHandle QuestRewardItemTree;
var HtmlHandle txtQuestInfo;
var L2Util util;

static function QuestConfirmWnd Inst()
{
	return QuestConfirmWnd(GetScript("QuestConfirmWnd"));
}

event OnLoad()
{
	Initialize();
	util = L2Util(GetScript("L2Util"));
	return;
}

function Initialize()
{
	txtQuestTitle = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtQuestTitle"));
	txtQuestCategory = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtQuestCategory"));
	txtRecommandedLevel = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtRecommandedLevel"));
	txtRecommandedLevelText = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtRecommandedLevelText"));
	txtQuestType = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtQuestType"));
	txtQuestTarget = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtQuestTarget"));
	txtQuestTarget.SetTooltipType("Text");
	txtQuestRewardItemTreeTitle = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtQuestRewardItemTreeTitle"));
	QuestRewardItemTree = GetTreeHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".QuestRewardItemTree"));
	txtQuestInfo = GetHtmlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtQuestInfo"));
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "confirmlBtn":
			HandoeClickConfirm();
			break;
		case "cancelBtn":
			m_hOwnerWnd.HideWindow();
			break;
		default:
			break;
	}
	return;
}

event OnHide()
{
	allclear();
	return;
}

event OnShow()
{
	m_hOwnerWnd.SetFocus();
	return;
}

event OnSetFocus(WindowHandle wndHandle, bool bFocused)
{
	if(bFocused)
	{
		Class'Interface.QuestDialogWnd'.static.Inst().m_hOwnerWnd.SetFocus();
	}
	return;
}

function HandoeClickConfirm()
{
	m_hOwnerWnd.HideWindow();
	Class'Interface.QuestDialogWnd'.static.Inst()._ConfirmQuest();
	return;
}

function _ShowQuestEnd()
{
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".confirmlBtn")).SetButtonName(898);
	SetCurrentQuestInfos(false);
	return;
}

function _ShowQuestConfirm()
{
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".confirmlBtn")).SetButtonName(7422);
	SetCurrentQuestInfos(true);
	return;
}

function SetCurrentQuestInfos(bool bConfirm)
{
	local NQuestUIData qUIData;
	local QuestDialogWnd questDialogWndScr;
	local NQuestDialogUIData questDialogUIData;
	local string QuestInfo;

	questDialogWndScr = Class'Interface.QuestDialogWnd'.static.Inst();
	if(!GetNQuestData(questDialogWndScr._currentQuestID, qUIData))
	{
		return;
	}
	if((questDialogWndScr._currentQuestID < 10001))
	{
		return;
	}
	txtQuestTitle.SetText(qUIData.Name);
	if(bConfirm)
	{
		txtQuestTitle.SetTextColor(util.White);
	}
	else
	{
		txtQuestTitle.SetTextColor(GetColor(255, 221, 102, 255));
	}
	if((questDialogWndScr._currentQuestID < 20001))
	{
		txtQuestCategory.SetText(GetSystemString(2738));
	}
	else if((questDialogWndScr._currentQuestID < 30001))
	{
		txtQuestCategory.SetText(GetSystemString(2341));
	}
	else
	{
		txtQuestCategory.SetText(GetSystemString(1796));
	}
	txtRecommandedLevel.SetText((GetSystemString(922) @ ":"));
	if(((qUIData.LevelMax > 0) && (qUIData.LevelMin > 0)))
	{
		txtRecommandedLevelText.SetText(((string(qUIData.LevelMin) $ "~") $ string(qUIData.LevelMax)));
	}
	else if((qUIData.LevelMin > 0))
	{
		txtRecommandedLevelText.SetText(((string(qUIData.LevelMin) $ " ") $ GetSystemString(859)));
	}
	else
	{
		txtRecommandedLevelText.SetText(GetSystemString(866));
	}
	switch(qUIData.Type)
	{
		case NQT_ONETIME:
			txtQuestType.SetText(GetSystemString(862));
			break;
		case NQT_DAILY:
			txtQuestType.SetText(GetSystemString(2788));
			break;
		case NQT_WEEKLY:
			txtQuestType.SetText(GetSystemString(14389));
			break;
		case NQT_REPEAT:
			txtQuestType.SetText(GetSystemString(861));
			break;
		default:
			break;
	}
	SetTxtQuestTargetText(qUIData.Goal.Name, qUIData.Goal.Num, bConfirm);
	API_GetNQuestDialogData(questDialogWndScr._currentQuestID, questDialogUIData);
	QuestInfo = questDialogUIData.QuestInfo;
	super.ReplaceText(QuestInfo, ("\\#$Tooltip0" $ "S"), "");
	super.ReplaceText(QuestInfo, ("\\#$Tooltip0" $ "E"), "");
	txtQuestInfo.LoadHtmlFromString(htmlSetHtmlStart(QuestInfo));
	setRewardItem(qUIData.Reward);
	m_hOwnerWnd.ShowWindow();
	return;
}

function SetTxtQuestTargetText(string Goalname, int goalNum, bool bConfirm)
{
	local string goalString;
	local int nWidth, nHeight;

	if(bConfirm)
	{
		goalString = (" 0/" $ string(goalNum));
	}
	else
	{
		goalString = (((" " $ string(goalNum)) $ "/") $ string(goalNum));
	}
	GetTextSizeDefault((Goalname $ goalString), nWidth, nHeight);
	if((nWidth > 272))
	{
		txtQuestTarget.SetTooltipText(Goalname);
		GetTextSizeDefault(goalString, nWidth, nHeight);
		Class'Interface.L2Util'.static.GetEllipsisString(Goalname, (272 - nWidth));
	}
	else
	{
		txtQuestTarget.SetTooltipText("");
	}
	txtQuestTarget.SetText((Goalname $ goalString));
	return;
}

function InsertRewardItems(array<NQuestRewardItemData> Items)
{
	local string treeName;
	local int i;
	local string setTreeName, strRetName, IconName, ItemName;
	local int DisplayType;
	local string DisplayString;

	treeName = (m_hOwnerWnd.m_WindowNameWithFullPath $ ".QuestRewardItemTree");
	TreeClear(treeName);
	util.TreeInsertRootNode(treeName, "List", "", 0, 2);
	setTreeName = "List";
	i = 0;
	while((i < Items.Length))
	{
		strRetName = util.TreeInsertItemNode(treeName, string(i), setTreeName, false, -4, -2);
		if(((float(i) % 2.0000000) == 1.0000000))
		{
			util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CH3.etc.textbackline", 244, 38, , , , , 14);
		}
		else
		{
			util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CT1.EmptyBtn", 244, 38);
		}
		util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -238, 2);
		IconName = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(Items[i].ItemClassID));
		ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(Items[i].ItemClassID));
		util.TreeInsertTextureNodeItem(treeName, strRetName, IconName, 32, 32, -34, 3);
		DisplayType = util._GetItemDisplayType(Items[i].ItemClassID);
		if((DisplayType == 9))
		{
			util.TreeInsertTextNodeItem(treeName, strRetName, ItemName, 5, 11, COLOR_DEFAULT, true, , Items[i].ItemClassID);
			i++;
			continue;
		}
		util.TreeInsertTextNodeItem(treeName, strRetName, ItemName, 5, 6, COLOR_DEFAULT, true, , Items[i].ItemClassID);
		if((Items[i].Amount == INT64(0)))
		{
			util.TreeInsertTextNodeItem(treeName, strRetName, GetSystemString(584), 48, -18, COLOR_GOLD, , true);
			i++;
			continue;
		}
		DisplayString = util._GetItemDisplayString(DisplayType, Items[i].Amount);
		if((DisplayString != ""))
		{
			util.TreeInsertTextNodeItem(treeName, strRetName, DisplayString, 44, -17, COLOR_GOLD, , true);
		}
		i++;
	}
	return;
}

function _GetRewardItems(NQuestRewardData rewardDatas, out array<NQuestRewardItemData> Items)
{
	local int i;
	local NQuestRewardItemData rewardItemData;

	if((rewardDatas.Level > 0))
	{
		if(getInstanceUIData().GetIsClassicServer())
		{
			rewardItemData.ItemClassID = 95641;
		}
		else
		{
			rewardItemData.ItemClassID = 82940;
		}
		rewardItemData.Amount = INT64(rewardDatas.Level);
		Items[Items.Length] = rewardItemData;
	}
	if((rewardDatas.Exp > INT64(0)))
	{
		rewardItemData.ItemClassID = 15623;
		rewardItemData.Amount = rewardDatas.Exp;
		Items[Items.Length] = rewardItemData;
	}
	if((rewardDatas.Sp > 0))
	{
		if(getInstanceUIData().GetIsClassicServer())
		{
			rewardItemData.ItemClassID = 15624;
		}
		else
		{
			rewardItemData.ItemClassID = 82500;
		}
		rewardItemData.Amount = INT64(rewardDatas.Sp);
		Items[Items.Length] = rewardItemData;
	}
	i = 0;
	while((i < rewardDatas.Items.Length))
	{
		Items[Items.Length] = rewardDatas.Items[i];
		i++;
	}
	return;
}

function setRewardItem(NQuestRewardData rewardDatas)
{
	local array<NQuestRewardItemData> Items;

	_GetRewardItems(rewardDatas, Items);
	InsertRewardItems(Items);
	return;
}

function TreeClear(string Str)
{
	Class'NWindow.UIAPI_TREECTRL'.static.Clear(Str);
	return;
}

function allclear()
{
	util.TreeClear((m_hOwnerWnd.m_WindowNameWithFullPath $ ".QuestRewardItemTree"));
	txtQuestTitle.SetText("");
	txtRecommandedLevel.SetText("");
	txtRecommandedLevelText.SetText("");
	txtQuestType.SetText("");
	txtQuestTarget.SetText("");
	return;
}

function bool API_GetNQuestDialogData(int a_QuestID, out NQuestDialogUIData o_data)
{
	return GetNQuestDialogData(a_QuestID, o_data);
}
