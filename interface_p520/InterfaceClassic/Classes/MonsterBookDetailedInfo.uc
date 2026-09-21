class MonsterBookDetailedInfo extends UICommonAPI;

const MONSTERID_DEACTIVE = 19652;
const TIMER_ID_ANIMATION = 19;
const TIMER_DELAY = 20000;
const TIMER_ID_CLICK = 2;
const TIMER_DELAY_CLICK = 200;

enum AtkAnimationType
{
	ATKWAITANIMMAIN,                // 0
	ATK01ANIMNAME,                  // 1
	ATK02ANIMNAME,                  // 2
	ATK03ANIMNAME                   // 3
};

var string m_Windowname;
var WindowHandle Me;
var WindowHandle dropItemWindow;
var WindowHandle DisableMsgWnd;
var CharacterViewportWindowHandle m_ObjectViewport;
var TextBoxHandle DropITEMNum_txt;
var TextBoxHandle Faction_Txt;
var TextBoxHandle Local_Txt;
var TextBoxHandle MonsterLV_Txt;
var TextBoxHandle MonsterName_Txt;
var TextBoxHandle CallName_Txt;
var TextBoxHandle DisableMsg3DWnd_txt;
var TextBoxHandle GageFrameHPNum_Txt;
var TextBoxHandle GageFrameMPNum_Txt;
var TextureHandle FactionPattern_Text;
var ListCtrlHandle DropItem_ListCtrl;
var TreeHandle NpcInfo;
var ItemID nID;
var int nMonsterBookID;
var bool IsActive;
var bool isDown;
var int currentMonsterID;

function OnLoad()
{
	SetClosingOnESC();
	InitializeCOD();
	dropItemWindow.HideWindow();
	return;
}

function OnRegisterEvent()
{
	return;
	RegisterEvent(10151);
	RegisterEvent(150);
	return;
}

function InitializeCOD()
{
	Me = GetWindowHandle(m_Windowname);
	m_ObjectViewport = GetCharacterViewportWindowHandle((m_Windowname $ ".MonsterStageWnd.ObjectViewport"));
	dropItemWindow = GetWindowHandle((m_Windowname $ ".DropItemWND"));
	DropITEMNum_txt = GetTextBoxHandle((m_Windowname $ ".DropITEMNum_txt"));
	Faction_Txt = GetTextBoxHandle((m_Windowname $ ".Faction_Txt"));
	Local_Txt = GetTextBoxHandle((m_Windowname $ ".Local_Txt"));
	MonsterLV_Txt = GetTextBoxHandle((m_Windowname $ ".MonsterLV_Txt"));
	MonsterName_Txt = GetTextBoxHandle((m_Windowname $ ".MonsterName_Txt"));
	CallName_Txt = GetTextBoxHandle((m_Windowname $ ".CallName_Txt"));
	GageFrameHPNum_Txt = GetTextBoxHandle((m_Windowname $ ".GageFrameHPNum_Txt"));
	GageFrameMPNum_Txt = GetTextBoxHandle((m_Windowname $ ".GageFrameMPNum_Txt"));
	FactionPattern_Text = GetTextureHandle((m_Windowname $ ".FactionPattern_Text"));
	DisableMsg3DWnd_txt = GetTextBoxHandle((m_Windowname $ ".MonsterStageWnd.DisableMsg3DWnd_txt"));
	DisableMsgWnd = GetWindowHandle((m_Windowname $ ".DropItemWND.DisableMsgWnd"));
	DropItem_ListCtrl = GetListCtrlHandle((m_Windowname $ ".DropItemWND.DropItem_ListCtrl"));
	NpcInfo = GetTreeHandle((m_Windowname $ ".MonsterStageWnd.NpcInfo"));
	DropItem_ListCtrl.SetSelectedSelTooltip(false);
	DropItem_ListCtrl.SetAppearTooltipAtMouseX(true);
	m_ObjectViewport.SetDragRotationRate(200);
	m_ObjectViewport.SetSpawnDuration(0.2000000);
	m_ObjectViewport.AutoAttacking(true);
	return;
}

function OnClickButton(string a_ButtonID)
{
	switch(a_ButtonID)
	{
		case "CloseButton":
			Me.HideWindow();
			break;
		case "DropITEM_BTN":
			if(dropItemWindow.IsShowWindow())
			{
				dropItemWindow.HideWindow();
			}
			else
			{
				dropItemWindow.ShowWindow();
			}
			break;
		default:
			break;
	}
	return;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	if((a_WindowHandle == m_ObjectViewport))
	{
		Me.SetFocus();
		Me.SetTimer(2, 200);
		isDown = true;
	}
	return;
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	if((a_WindowHandle == m_ObjectViewport))
	{
		if(isDown)
		{
			PlayRandAnimation();
			Me.KillTimer(19);
			Me.SetTimer(19, 20000);
		}
	}
	Me.KillTimer(2);
	isDown = false;
	return;
}

function OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case 10151:
			checkUpdate(param);
			break;
		default:
			break;
	}
	return;
}

function OnShow()
{
	return;
}

function OnHide()
{
	Me.KillTimer(19);
	currentMonsterID = -1;
	return;
}

function OnCallUCFunction(string funcName, string param)
{
	switch(funcName)
	{
		case "showMonsterInfo":
			setMonsterInfo(param);
			break;
		case "bringToFront":
			Debug(("bringToFront" @ getCurrentWindowName(string(self))));
			Class'NWindow.UIAPI_WINDOW'.static.BringToFront("ContainerWindow");
			Class'NWindow.UIAPI_WINDOW'.static.BringToFront("FactionWnd");
			break;
		default:
			break;
	}
	return;
}

function checkUpdate(string param)
{
	local int monsterID;

	ParseInt(param, "nMonsterBookID", monsterID);
	if((monsterID != nMonsterBookID))
	{
		return;
	}
	setMonsterInfo(param);
	return;
}

function setMonsterInfo(string param)
{
	local L2MonsterBookUIData monaterData;

	ParseInt(param, "nMonsterBookID", nMonsterBookID);
	GetMonsterBookData(nMonsterBookID, monaterData);
	setBasicInfo(monaterData);
	SetViewPort(monaterData);
	SetItemInfo(monaterData);
	return;
}

function PlayRandAnimation()
{
	local int aniType;

	aniType = (Rand(3) + 1);
	m_ObjectViewport.PlayAttackAnimation(aniType);
	return;
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 19:
			PlayRandAnimation();
			break;
		case 2:
			Me.KillTimer(2);
			isDown = false;
			break;
		default:
			break;
	}
	return;
}

function setViewPortParams(int monsterID, int OffsetX, int OffsetY, float viewSale, int Rotation, int Distance)
{
	currentMonsterID = monsterID;
	m_ObjectViewport.SetNPCInfo(currentMonsterID);
	m_ObjectViewport.SetCharacterOffsetX(OffsetX);
	m_ObjectViewport.SetCharacterOffsetY(OffsetY);
	m_ObjectViewport.SetCharacterScale(viewSale);
	m_ObjectViewport.SetCurrentRotation(Rotation);
	m_ObjectViewport.SetCameraDistance(Distance);
	return;
}

function SetViewPort(L2MonsterBookUIData MonsterData)
{
	if(IsActive)
	{
		if((currentMonsterID == MonsterData.nNpcID))
		{
			return;
		}
		setViewPortParams(MonsterData.nNpcID, MonsterData.nViewX, MonsterData.nViewY, MonsterData.fViewScale, MonsterData.nViewRot, MonsterData.nViewDist);
	}
	else
	{
		if((currentMonsterID == 19652))
		{
			return;
		}
		setViewPortParams(19652, 0, 3, 1.0000000, 0, 120);
	}
	Me.KillTimer(19);
	m_ObjectViewport.SpawnNPC();
	PlayRandAnimation();
	Me.SetTimer(19, 20000);
	return;
}

function setBasicInfo(L2MonsterBookUIData MonsterData)
{
	local string Level, npcHP, npcMP;
	local UIEventManager.ELanguageType Language;

	IsActive = (MonsterData.nTrophyLevel > 0);
	MonsterName_Txt.SetText(MonsterData.strNpcName);
	CallName_Txt.SetText(MonsterData.strNpcNick);
	Faction_Txt.SetText(MonsterData.strFactionName);
	Local_Txt.SetText(MonsterData.strZoneName);
	FactionPattern_Text.SetTexture((MonsterData.strFactionEmblem $ "_small"));
	if(IsActive)
	{
		DisableMsg3DWnd_txt.HideWindow();
		DisableMsgWnd.HideWindow();
		Level = string(MonsterData.nNpcLevel);
		npcHP = MakeCostString(string(MonsterData.nNpcHP));
		npcMP = MakeCostString(string(MonsterData.nNpcMP));
		setNpcProperty(MonsterData.nNpcID);
	}
	else
	{
		DisableMsg3DWnd_txt.ShowWindow();
		DisableMsgWnd.ShowWindow();
		Level = "???";
		npcHP = "???";
		npcMP = "???";
		NpcInfo.HideWindow();
	}
	Language = GetLanguage();
	if((((int(Language) == 8) || (int(Language) == 9)) || (int(Language) == 1)))
	{
		MonsterLV_Txt.SetText((GetSystemString(88) $ Level));
	}
	else
	{
		MonsterLV_Txt.SetText(((GetSystemString(88) $ ".") $ Level));
	}
	GageFrameHPNum_Txt.SetText(npcHP);
	GageFrameMPNum_Txt.SetText(npcMP);
	return;
}

function setNpcProperty(int NpcID)
{
	local array<int> arrNpcInfo;

	Class'NWindow.UIDATA_NPC'.static.GetNpcProperty(NpcID, arrNpcInfo);
	UpdateNpcInfoTree(arrNpcInfo);
	NpcInfo.ShowWindow();
	NpcInfo.ShowScrollBar(false);
	return;
}

function UpdateNpcInfoTree(array<int> arrNpcInfo)
{
	local int i, SkillID, SkillLevel;
	local string strNodeName;
	local XMLTreeNodeInfo infNode;
	local XMLTreeNodeItemInfo infNodeItem;
	local XMLTreeNodeInfo infNodeClear;
	local XMLTreeNodeItemInfo infNodeItemClear;

	NpcInfo.Clear();
	infNode.strName = "root";
	strNodeName = NpcInfo.InsertNode("", infNode);
	if((Len(strNodeName) < 1))
	{
		return;
	}
	i = 0;
	while((i < arrNpcInfo.Length))
	{
		SkillID = arrNpcInfo[i];
		SkillLevel = arrNpcInfo[(i + 1)];
		infNode = infNodeClear;
		infNode.nOffSetX = (int((float((i / 2)) % 8.0000000)) * 18);
		if(((float((i / 2)) % 8.0000000) == 0.0000000))
		{
			if((i > 0))
			{
				infNode.nOffSetY = 3;
			}
			else
			{
				infNode.nOffSetY = 0;
			}
		}
		else
		{
			infNode.nOffSetY = -15;
		}
		infNode.strName = ("" $ string((i / 2)));
		infNode.bShowButton = 0;
		infNode.ToolTip = SetNpcInfoTooltip(SkillID, SkillLevel);
		strNodeName = NpcInfo.InsertNode("root", infNode);
		if((Len(strNodeName) < 1))
		{
			Log(("ERROR: Can't insert node. Name: " $ infNode.strName));
			return;
		}
		infNode.ToolTip.DrawList.Remove(0, infNode.ToolTip.DrawList.Length);
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.u_nTextureWidth = 15;
		infNodeItem.u_nTextureHeight = 15;
		infNodeItem.u_nTextureUWidth = 32;
		infNodeItem.u_nTextureUHeight = 32;
		infNodeItem.u_strTexture = Class'NWindow.UIDATA_SKILL'.static.GetIconName(GetItemID(SkillID), SkillLevel, 0);
		NpcInfo.InsertNodeItem(strNodeName, infNodeItem);
		(i += 2);
	}
	return;
}

function CustomTooltip SetNpcInfoTooltip(int Id, int Level)
{
	local CustomTooltip ToolTip;
	local DrawItemInfo Info, infoClear;
	local ItemInfo item;
	local ItemID cID;

	cID = GetItemID(Id);
	item.Name = Class'NWindow.UIDATA_SKILL'.static.GetName(cID, Level, 0);
	item.Description = Class'NWindow.UIDATA_SKILL'.static.GetDescription(cID, Level, 0);
	ToolTip.DrawList.Length = 1;
	Info = infoClear;
	Info.eType = DIT_TEXT;
	Info.t_bDrawOneLine = true;
	Info.t_strText = item.Name;
	ToolTip.DrawList[0] = Info;
	if((Len(item.Description) > 0))
	{
		ToolTip.MinimumWidth = 144;
		ToolTip.DrawList.Length = 2;
		Info = infoClear;
		Info.eType = DIT_TEXT;
		Info.nOffSetY = 6;
		Info.bLineBreak = true;
		Info.t_color.R = 178;
		Info.t_color.G = 190;
		Info.t_color.B = 207;
		Info.t_color.A = 255;
		Info.t_strText = item.Description;
		ToolTip.DrawList[1] = Info;
	}
	return ToolTip;
}

function string ellipsisWidth(string Text, int MaxWidth)
{
	local int nWidth, nHeight, i;

	GetTextSizeDefault((Text $ "..."), nWidth, nHeight);
	if((nWidth < MaxWidth))
	{
		return Text;
	}
	i = 0;
	while((i < 200))
	{
		GetTextSizeDefault((Text $ "..."), nWidth, nHeight);
		if((nWidth < MaxWidth))
		{
			return (Text $ "...");
		}
		Text = Mid(Text, 0, (Len(Text) - 1));
		i++;
	}
}

function SetItemInfo(L2MonsterBookUIData MonsterData)
{
	local int i;

	clearDropItemInfo();
	if(IsActive)
	{
		i = 0;
		while((i < MonsterData.arrDropItemID.Length))
		{
			addDropItemInfo(MonsterData.arrDropItemID[i]);
			i++;
		}
	}
	setDropItemInfo();
	return;
}

function clearDropItemInfo()
{
	DropItem_ListCtrl.DeleteAllItem();
	return;
}

function addDropItemInfo(int ItemID)
{
	DropItem_ListCtrl.InsertRecord(makeRecord(ItemID));
	return;
}

function setDropItemInfo()
{
	local string strItemNum;

	if(IsActive)
	{
		strItemNum = string(DropItem_ListCtrl.GetRecordCount());
	}
	else
	{
		strItemNum = "?";
	}
	DropITEMNum_txt.SetText(strItemNum);
	return;
}

function LVDataRecord makeRecord(int ItemID)
{
	local LVDataRecord Record;
	local string param, AdditionalName, fullNameString;
	local int itemNameClass;
	local ItemInfo Info;

	nID.ClassID = ItemID;
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(nID, Info);
	fullNameString = Info.Name;
	itemNameClass = Class'NWindow.UIDATA_ITEM'.static.GetItemNameClass(Info.Id);
	AdditionalName = Class'NWindow.UIDATA_ITEM'.static.GetItemAdditionalName(Info.Id);
	if((itemNameClass == 0))
	{
		fullNameString = MakeFullSystemMsg(GetSystemMessage(2332), fullNameString);
	}
	else if((itemNameClass == 2))
	{
		fullNameString = MakeFullSystemMsg(GetSystemMessage(2331), fullNameString);
	}
	if((Len(AdditionalName) > 0))
	{
		fullNameString = (((fullNameString $ "(") $ AdditionalName) $ ")");
	}
	ItemInfoToParam(Info, param);
	Record.szReserved = param;
	Record.nReserved1 = INT64(Info.Id.ClassID);
	Record.nReserved2 = Info.ItemNum;
	Record.LVDataList.Length = 4;
	Record.LVDataList[0].szData = ellipsisWidth(fullNameString, 280);
	Record.LVDataList[0].hasIcon = true;
	Record.LVDataList[0].nTextureWidth = 32;
	Record.LVDataList[0].nTextureHeight = 32;
	Record.LVDataList[0].nTextureU = 32;
	Record.LVDataList[0].nTextureV = 32;
	Record.LVDataList[0].szTexture = Info.IconName;
	Record.LVDataList[0].IconPosX = 10;
	Record.LVDataList[0].FirstLineOffsetX = 6;
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
	Record.LVDataList[1].szData = fullNameString;
	Record.LVDataList[1].textAlignment = TA_Right;
	return Record;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="MonsterBookDetailedInfo"
}
