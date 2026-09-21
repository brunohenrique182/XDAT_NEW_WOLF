class QuestListWnd extends UICommonAPI;

var WindowHandle Me;
var ListCtrlHandle lstQuest;
var TextureHandle QuestTooltip;

event OnRegisterEvent()
{
	RegisterEvent(2840);
	RegisterEvent(2850);
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Me = GetWindowHandle("QuestListWnd");
	QuestTooltip = GetTextureHandle("QuestListWnd.QuestTooltip");
	lstQuest = GetListCtrlHandle("QuestListWnd.lstQuest");
	InitQuestTooltip();
	lstQuest.SetSelectedSelTooltip(false);
	lstQuest.SetAppearTooltipAtMouseX(true);
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 2840:
			HandleQuestInfoStart();
			break;
		case 2850:
			HandleQuestInfo(param);
			break;
		default:
			break;
	}
	return;
}

event OnHide()
{
	getInstanceL2Util().HideGFxMiniMapSelectedPin(PIN_YELLOW);
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnLoc":
			ShowQuestTarget();
			break;
		default:
			break;
	}
	return;
}

event OnDBClickListCtrlRecord(string Id)
{
	if((Id == "lstQuest"))
	{
		ShowQuestTarget();
	}
	return;
}

function HandleQuestInfoStart()
{
	lstQuest.DeleteAllItem();
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function HandleQuestInfo(string param)
{
	local int QuestID;
	local string questName, QuestRequirement, QuestLevel, QuestTypeText;
	local int QuestType;
	local string QuestNpcName, QuestDecription, TempTxt;
	local LVDataRecord Record;

	ParseInt(param, "QuestID", QuestID);
	ParseString(param, "QuestName", questName);
	ParseString(param, "QuestRequirement", QuestRequirement);
	ParseString(param, "QuestLevel", QuestLevel);
	ParseInt(param, "QuestType", QuestType);
	ParseString(param, "QuestNpcName", QuestNpcName);
	ParseString(param, "QuestDecription", QuestDecription);
	if(((QuestNpcName == "") || (QuestNpcName == "None")))
	{
		TempTxt = GetSystemString(27);
		QuestNpcName = TempTxt;
	}
	Record.LVDataList.Length = 5;
	Record.LVDataList[0].szData = questName;
	Record.LVDataList[1].szData = QuestRequirement;
	Record.LVDataList[2].szData = QuestLevel;
	Record.LVDataList[3].nTextureWidth = 16;
	Record.LVDataList[3].nTextureHeight = 16;
	switch(QuestType)
	{
		case 0:
		case 2:
			Record.LVDataList[3].szTexture = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_1";
			Record.LVDataList[3].szData = "1";
			QuestTypeText = GetSystemString(861);
			break;
		case 1:
		case 3:
			Record.LVDataList[3].szTexture = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_2";
			Record.LVDataList[3].szData = "2";
			QuestTypeText = GetSystemString(862);
			break;
		case 4:
		case 5:
			Record.LVDataList[3].szTexture = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_3";
			Record.LVDataList[3].szData = "3";
			QuestTypeText = GetSystemString(2788);
			break;
		default:
			break;
	}
	Record.LVDataList[3].nReserved1 = QuestType;
	Record.LVDataList[4].szData = QuestNpcName;
	Record.szReserved = QuestDecription;
	Record.nReserved1 = INT64(QuestID);
	ParamAdd(Record.szReserved, "QuestName", questName);
	ParamAdd(Record.szReserved, "LevelText", QuestLevel);
	ParamAdd(Record.szReserved, "QuestTypeText", QuestTypeText);
	lstQuest.InsertRecord(Record);
	return;
}

function ShowQuestTarget()
{
	local int idx, QuestID, NpcID;
	local string strTargetName, questName;
	local Vector vTargetPos;
	local LVDataRecord Record;

	idx = lstQuest.GetSelectedIndex();
	if((idx > -1))
	{
		lstQuest.GetRec(idx, Record);
		QuestID = int(Record.nReserved1);
	}
	if((QuestID > 0))
	{
		questName = Class'NWindow.UIDATA_QUEST'.static.GetQuestName(QuestID, 1);
		NpcID = Class'NWindow.UIDATA_QUEST'.static.GetStartNPCID(QuestID, 1);
		strTargetName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(NpcID);
		vTargetPos = Class'NWindow.UIDATA_QUEST'.static.GetStartNPCLoc(QuestID, 1);
		if((((vTargetPos.X == 0.0000000) && (vTargetPos.Y == 0.0000000)) && (vTargetPos.Z == 0.0000000)))
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(5205));
			getInstanceL2Util().HideGFxMiniMapSelectedPin(PIN_YELLOW);
		}
		if((Len(strTargetName) > 0))
		{
			getInstanceL2Util().ShowGFxMiniMapSelectedPin(PIN_YELLOW, vTargetPos, strTargetName, questName);
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("MiniMapGfxWnd"))
			{
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("MiniMapGfxWnd");
			}
		}
	}
	return;
}

function InitQuestTooltip()
{
	local CustomTooltip toolTipInfo;

	toolTipInfo.DrawList.Length = 6;
	toolTipInfo.DrawList[0].eType = DIT_TEXTURE;
	toolTipInfo.DrawList[0].u_nTextureWidth = 16;
	toolTipInfo.DrawList[0].u_nTextureHeight = 16;
	toolTipInfo.DrawList[0].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_1";
	toolTipInfo.DrawList[1].eType = DIT_TEXT;
	toolTipInfo.DrawList[1].nOffSetX = 5;
	toolTipInfo.DrawList[1].t_bDrawOneLine = true;
	toolTipInfo.DrawList[1].t_strText = GetSystemString(861);
	toolTipInfo.DrawList[2].eType = DIT_TEXTURE;
	toolTipInfo.DrawList[2].nOffSetY = 2;
	toolTipInfo.DrawList[2].u_nTextureWidth = 16;
	toolTipInfo.DrawList[2].u_nTextureHeight = 16;
	toolTipInfo.DrawList[2].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_2";
	toolTipInfo.DrawList[2].bLineBreak = true;
	toolTipInfo.DrawList[3].eType = DIT_TEXT;
	toolTipInfo.DrawList[3].nOffSetY = 2;
	toolTipInfo.DrawList[3].nOffSetX = 5;
	toolTipInfo.DrawList[3].t_bDrawOneLine = true;
	toolTipInfo.DrawList[3].t_strText = GetSystemString(862);
	toolTipInfo.DrawList[4].eType = DIT_TEXTURE;
	toolTipInfo.DrawList[4].nOffSetY = 2;
	toolTipInfo.DrawList[4].u_nTextureWidth = 16;
	toolTipInfo.DrawList[4].u_nTextureHeight = 16;
	toolTipInfo.DrawList[4].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_3";
	toolTipInfo.DrawList[4].bLineBreak = true;
	toolTipInfo.DrawList[5].eType = DIT_TEXT;
	toolTipInfo.DrawList[5].nOffSetY = 2;
	toolTipInfo.DrawList[5].nOffSetX = 5;
	toolTipInfo.DrawList[5].t_bDrawOneLine = true;
	toolTipInfo.DrawList[5].t_strText = GetSystemString(2788);
	QuestTooltip.SetTooltipCustomType(toolTipInfo);
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("QuestListWnd").HideWindow();
	return;
}
