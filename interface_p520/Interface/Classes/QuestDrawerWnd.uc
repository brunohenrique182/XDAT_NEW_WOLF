class QuestDrawerWnd extends UICommonAPI
	dependson(UIPacket);

var array<byte> _emptyByteArray;

const DIALOG_TOOLTIP_KEY0 = "\\#$Tooltip0";

var TextBoxHandle txtQuestTitle;
var TextBoxHandle txtQuestCategory;
var TextBoxHandle txtRecommandedLevel;
var TextBoxHandle txtRecommandedLevelText;
var TextBoxHandle txtQuestType;
var TextBoxHandle txtQuestTarget;
var TreeHandle QuestRewardItemTree;
var HtmlHandle txtQuestInfo;
var L2Util util;
var int currentQuestID;
var bool isComplete;
var bool isEnd;
var bool isProgress;
var bool isAcceptable;
var UIControlDialogAssets teleportDialog;
var WindowHandle modalWnd;

static function QuestDrawerWnd Inst()
{
	return QuestDrawerWnd(GetScript("QuestDrawerWnd"));
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
	txtQuestInfo = GetHtmlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtQuestInfo"));
	QuestRewardItemTree = GetTreeHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".QuestRewardItemTree"));
	modalWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".WindowDisable_Wnd"));
	teleportDialog = Class'Interface.UIControlDialogAssets'.static.InitScript(GetWindowHandle((modalWnd.m_WindowNameWithFullPath $ ".UIControlDialogAsset")));
	teleportDialog.SetDisableWindow(modalWnd);
	teleportDialog.NeedItemRichListCtrl.SetColumnWidth(0, 220);
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "btnGiveUpCurrentQuest":
			OnbtnGiveUpCurrentQuestClick();
			break;
		case "btnShowDialog":
			_OnbtnShowDialog();
			break;
		case "btnClose":
			OnBtnCloseClick();
			break;
		case "btnAction":
			_OnbtnActionClick();
			break;
		default:
			break;
	}
	return;
}

event OnHide()
{
	teleportDialog.Hide();
	allclear();
	currentQuestID = -1;
	return;
}

event OnShow()
{
	m_hOwnerWnd.SetFocus();
	return;
}

function OnbtnGiveUpCurrentQuestClick()
{
	local NQuestUIData qUIData;

	if(!API_GetNQuestData(currentQuestID, qUIData))
	{
		return;
	}
	if((currentQuestID < 20001))
	{
		return;
	}
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(182), qUIData.Name, ""));
	Class'Interface.DialogBox'.static.Inst().AnchorToOwner(0);
	Class'Interface.DialogBox'.static.Inst().DelegateOnOK = RQ_C_EX_QUEST_CANCEL;
	return;
}

function _OnbtnShowDialog()
{
	Debug(("_OnbtnActionClick" @ string(currentQuestID)));
	if(isAcceptable)
	{
		Class'Interface.QuestDialogWnd'.static.Inst()._ShowStartDialog(currentQuestID);
	}
	else
	{
		Class'Interface.QuestDialogWnd'.static.Inst()._SohwDialogAgain(currentQuestID);
	}
	return;
}

function OnBtnCloseClick()
{
	m_hOwnerWnd.HideWindow();
	return;
}

function _OnbtnActionClick()
{
	if(isAcceptable)
	{
	}
	if(isComplete)
	{
		if(isProgress)
		{
			ShowCompleteDialog();
		}
		else
		{
			m_hOwnerWnd.HideWindow();
		}
	}
	else
	{
		ShowTeleportDialog();
	}
	return;
}

function ShowCompleteDialog()
{
	Class'Interface.QuestDialogWnd'.static.Inst()._ShowCompleteDialog(currentQuestID);
	return;
}

function int GetCurrentInstanceZoneID()
{
	local NQuestUIData questUIData;

	API_GetNQuestData(currentQuestID, questUIData);
	return questUIData.InstantZoneID;
}

function int GetCurrentTeleportID()
{
	local NQuestUIData questUIData;

	API_GetNQuestData(currentQuestID, questUIData);
	return questUIData.TeleportID;
}

function ShowTeleportDialog()
{
	local string Desc, teleportName;
	local TeleportListAPI.TeleportListData targetTeleport;
	local INT64 teleportCost;
	local int instanceZoneID;
	local string tellzoneName;

	instanceZoneID = GetCurrentInstanceZoneID();
	if(isAcceptable)
	{
		teleportDialog.SetUseNeedItem(false);
	}
	else if(GetCurrentTeleportInfo(targetTeleport))
	{
		tellzoneName = targetTeleport.Name;
		if((targetTeleport.Level > 0))
		{
			teleportName = ((((("</br>" $ "(") $ tellzoneName) $ " Lv ") $ string(targetTeleport.Level)) $ ")");
		}
		else
		{
			teleportName = ((("</br>" $ "(") $ tellzoneName) $ ")");
		}
		teleportCost = Class'Interface.TeleportWnd'.static.Inst().GetTeleportCost(targetTeleport.Price[0].Amount, targetTeleport.UsableLevel, targetTeleport.UsableTransferDegree);
	}
	else if((instanceZoneID > 0))
	{
		tellzoneName = GetInZoneNameWithZoneID(instanceZoneID);
		teleportName = ((((("</br>" $ "(") $ tellzoneName) @ " - <font name=\"hs9\" color=\"FFDF4C\">") $ GetSystemString(2668)) $ "</font>)");
		teleportDialog.SetUseNeedItem(false);
	}
	else
	{
		return;
	}
	Desc = (GetSystemMessage(5239) $ teleportName);
	GetRichListCtrlHandle((modalWnd.m_WindowNameWithFullPath $ ".UIControlDialogAsset.NeedItemWnd.NeedItemRichListCtrl")).SetUseHorizontalScrollBar(false);
	teleportDialog.SetDialogDescHtml(Desc);
	if((targetTeleport.Price.Length > 0))
	{
		teleportDialog.SetUseNeedItem(true);
		teleportDialog.StartNeedItemList(1);
		teleportDialog.AddNeedItemClassID(targetTeleport.Price[0].Id, teleportCost);
		teleportDialog.SetItemNum(1);
	}
	teleportDialog.Show();
	teleportDialog.DelegateOnClickBuy = OnTeleportDialogConfirm;
	teleportDialog.DelegateOnCancel = OnTeleportDialogCancel;
	return;
}

function OnTeleportDialogConfirm()
{
	local UserInfo UserInfo;

	teleportDialog.Hide();
	if((GetPlayerInfo(UserInfo) == false))
	{
		return;
	}
	if((UserInfo.nCurHP == INT64(0)))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(5243));
		teleportDialog.Hide();
		return;
	}
	RQ_C_EX_QUEST_TELEPORT();
	return;
}

function OnTeleportDialogCancel()
{
	teleportDialog.Hide();
	return;
}

function bool GetCurrentTeleportInfo(out TeleportListAPI.TeleportListData o_tInfo)
{
	local TeleportListAPI.TeleportListData tInfo;
	local int TeleportID;

	TeleportID = GetCurrentTeleportID();
	tInfo = Class'NWindow.TeleportListAPI'.static.GetFirstTeleportListData();
	while(("" != tInfo.Name))
	{
		if((tInfo.Id == TeleportID))
		{
			o_tInfo = tInfo;
			return true;
		}
		tInfo = Class'NWindow.TeleportListAPI'.static.GetNextTeleportListData();
	}
	return false;
}

function _SetCurrentQuestInfos(int qid, int nCount, int cState)
{
	local NQuestUIData qUIData;
	local NQuestDialogUIData questDialogUIData;
	local string QuestInfo;

	teleportDialog.Hide();
	isProgress = (cState == 1);
	isAcceptable = (cState == -1);
	if(!API_GetNQuestData(qid, qUIData))
	{
		return;
	}
	if((qid < 10001))
	{
		return;
	}
	isComplete = (qUIData.Goal.Num <= nCount);
	isEnd = (cState == 2);
	if(isAcceptable)
	{
		txtQuestTitle.SetTextColor(getInstanceL2Util().White);
	}
	else if(isEnd)
	{
		txtQuestTitle.SetTextColor(GetColor(100, 83, 49, 255));
	}
	else if(isComplete)
	{
		txtQuestTitle.SetTextColor(GetColor(255, 221, 102, 255));
	}
	else
	{
		txtQuestTitle.SetTextColor(GetColor(170, 153, 119, 255));
	}
	txtQuestTitle.SetText(qUIData.Name);
	if((qid < 20001))
	{
		txtQuestCategory.SetText(GetSystemString(2738));
	}
	else if((qid < 30001))
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
	SetGoalText(qUIData.Goal.Name, nCount, qUIData.Goal.Num);
	API_GetNQuestDialogData(qid, questDialogUIData);
	QuestInfo = questDialogUIData.QuestInfo;
	super.ReplaceText(QuestInfo, ("\\#$Tooltip0" $ "S"), "");
	super.ReplaceText(QuestInfo, ("\\#$Tooltip0" $ "E"), "");
	if((currentQuestID != qid))
	{
		txtQuestInfo.LoadHtmlFromString(htmlSetHtmlStart(QuestInfo));
	}
	setRewardItem(qUIData.Reward);
	if((cState == -1))
	{
		m_hOwnerWnd.HideWindow();
	}
	else
	{
		m_hOwnerWnd.ShowWindow();
	}
	currentQuestID = qid;
	SetButtons();
	return;
}

function SetGoalText(string Goalname, int Cnt, int goalNum)
{
	local string goalNuMString, goalnameEllipsed;
	local int numW, numH, nameW, nameH;

	if((goalNum > 1))
	{
		goalNuMString = (((" " $ string(Cnt)) $ "/") $ string(goalNum));
	}
	GetTextSizeDefault(Goalname, nameW, nameH);
	GetTextSizeDefault(goalNuMString, numW, numH);
	goalnameEllipsed = Goalname;
	if(Class'Interface.L2Util'.static.Inst().GetEllipsisString(goalnameEllipsed, (277 - numW)))
	{
		txtQuestTarget.SetTooltipString(Goalname);
	}
	else
	{
		txtQuestTarget.SetTooltipString("");
	}
	txtQuestTarget.SetText((goalnameEllipsed $ goalNuMString));
	return;
}

function SetButtons()
{
	if((currentQuestID < 20001))
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnGiveUpCurrentQuest")).DisableWindow();
	}
	else
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnGiveUpCurrentQuest")).EnableWindow();
	}
	if(isAcceptable)
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnGiveUpCurrentQuest")).DisableWindow();
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnAction")).SetButtonName(900);
		if(Class'Interface.QuestDialogWnd'.static.Inst()._CheckDistanceToStart(currentQuestID))
		{
			GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnAction")).EnableWindow();
		}
		else
		{
			GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnAction")).DisableWindow();
		}
	}
	else if(isComplete)
	{
		if(isProgress)
		{
			GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnAction")).SetButtonName(898);
			GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnAction")).EnableWindow();
		}
		else
		{
			GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnGiveUpCurrentQuest")).DisableWindow();
			GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnAction")).SetButtonName(646);
			GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnAction")).EnableWindow();
		}
	}
	else
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnAction")).SetButtonName(900);
		if((GetCurrentTeleportID() < 1))
		{
			GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnAction")).DisableWindow();
		}
		else
		{
			RQ_C_EX_Teleport_UI();
			GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnAction")).EnableWindow();
		}
	}
	return;
}

function InsertRewardItems(array<NQuestRewardItemData> Items)
{
	local string treeName;
	local int i;
	local string setTreeName, strRetName, IconName, ItemName;
	local int addW, DisplayType;
	local string DisplayString;

	treeName = (m_hOwnerWnd.m_WindowNameWithFullPath $ ".QuestRewardItemTree");
	TreeClear(treeName);
	util.TreeInsertRootNode(treeName, "List", "", 0, 2);
	setTreeName = "List";
	addW = 40;
	i = 0;
	while((i < Items.Length))
	{
		strRetName = util.TreeInsertItemNode(treeName, string(i), setTreeName, false, -4, -2);
		if(((float(i) % 2.0000000) == 1.0000000))
		{
			util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CH3.etc.textbackline", (244 + addW), 38, , , , , 14);
		}
		else
		{
			util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_CT1.EmptyBtn", (244 + addW), 38);
		}
		util.TreeInsertTextureNodeItem(treeName, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, (-238 - addW), 2);
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

function setRewardItem(NQuestRewardData rewardDatas)
{
	local array<NQuestRewardItemData> Items;

	Class'Interface.QuestConfirmWnd'.static.Inst()._GetRewardItems(rewardDatas, Items);
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

function RQ_C_EX_QUEST_CANCEL()
{
	local array<byte> stream;
	local UIPacket._C_EX_QUEST_CANCEL packet;

	packet.nID = currentQuestID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_QUEST_CANCEL(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(829, stream);
	return;
}

function RQ_C_EX_Teleport_UI()
{
	Class'Interface.UIPacket'.static.RequestUIPacket(808, _emptyByteArray);
	return;
}

function RQ_C_EX_QUEST_TELEPORT()
{
	local array<byte> stream;
	local UIPacket._C_EX_QUEST_TELEPORT packet;

	packet.nID = currentQuestID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_QUEST_TELEPORT(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(827, stream);
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".btnAction")).DisableWindow();
	return;
}

function bool API_GetNQuestDialogData(int a_QuestID, out NQuestDialogUIData o_data)
{
	return GetNQuestDialogData(a_QuestID, o_data);
}

function bool API_GetNQuestData(int a_QuestID, out NQuestUIData o_data)
{
	return GetNQuestData(a_QuestID, o_data);
}

function int _GetCurrentQuestID()
{
	return currentQuestID;
}
