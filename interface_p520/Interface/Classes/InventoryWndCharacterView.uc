class InventoryWndCharacterView extends UICommonAPI;

const ORCRIDERSCALE = 0.803f;
const ORCRIDERX = 0;
const ORCRIDERY = 1;
const TIMER_ID_ANIMATION = 19;
const TIMER_DELAY = 2000;
const TIMER_ID_CLICK = 2;
const TIMER_DELAY_CLICK = 150;
const ROOTNAME = "root";

struct ArtifactSkillInfoStruct
{
	var ItemID Id;
	var int SkillID;
	var int Level;
	var string Name;
	var string IconName;
	var string IconPanel;
	var string Description;
	var int ArtifactType;
	var int ArtifactPage;
};

var WindowHandle Me;
var string m_Windowname;
var ButtonHandle m_CloseButton;
var CharacterViewportWindowHandle m_ObjectViewport;
var ButtonHandle m_BtnRotateLeft;
var ButtonHandle m_BtnRotateRight;
var bool isDown;
var bool isAniPlaing;
var int m_MeshType;
var TreeHandle MainTree;

function OnRegisterEvent()
{
	RegisterEvent(3810);
	return;
}

function OnLoad()
{
	InitHandleCOD();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 3810:
			HandleChangeCharacterPawn(param);
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "CloseButton":
			ToggleMe();
			break;
		case "btnAllList":
			toggleWindow("ArtifactItemListWnd", true, true);
			break;
		default:
			ClickTreeNode(strID);
			MainTree.SetFocus();
			break;
	}
	return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	if((a_WindowHandle == m_BtnRotateLeft))
	{
		m_ObjectViewport.StartRotation(false);
	}
	else if((a_WindowHandle == m_BtnRotateRight))
	{
		m_ObjectViewport.StartRotation(true);
	}
	else if((a_WindowHandle == m_ObjectViewport))
	{
		Me.SetTimer(2, 150);
		isDown = true;
	}
	return;
}

function OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	if((a_WindowHandle == m_BtnRotateLeft))
	{
		m_ObjectViewport.EndRotation();
	}
	else if((a_WindowHandle == m_BtnRotateRight))
	{
		m_ObjectViewport.EndRotation();
	}
	else if(((!isAniPlaing && isDown) && (a_WindowHandle == m_ObjectViewport)))
	{
		isAniPlaing = true;
		if(((m_MeshType == 18) || (m_MeshType == 19)))
		{
			m_ObjectViewport.PlayAnimation(3);
		}
		else
		{
			PlayRandAttackAnimation();
		}
		Me.KillTimer(19);
		Me.SetTimer(19, 2000);
	}
	Me.KillTimer(2);
	isDown = false;
	return;
}

function OnRButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	if(((!isAniPlaing && isDown) && (a_WindowHandle == m_ObjectViewport)))
	{
		isAniPlaing = true;
		PlayRandAnimation();
		Me.KillTimer(19);
		Me.SetTimer(19, 2000);
	}
	Me.KillTimer(2);
	isDown = false;
	return;
}

function OnRButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	if((a_WindowHandle == m_ObjectViewport))
	{
		Me.SetTimer(2, 150);
		isDown = true;
	}
	return;
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 19:
			Me.KillTimer(19);
			isAniPlaing = false;
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

function PlayRandAttackAnimation()
{
	local int aniType;

	aniType = (Rand(3) + 1);
	m_ObjectViewport.PlayAttackAnimation(aniType);
	return;
}

function PlayRandAnimation()
{
	local int aniType;

	aniType = (Rand(13) + 1);
	m_ObjectViewport.PlayAnimation(aniType);
	return;
}

function InitHandleCOD()
{
	Me = GetWindowHandle(m_Windowname);
	m_BtnRotateLeft = GetButtonHandle((m_Windowname $ ".TabCharacterView.BtnRotateLeft"));
	m_BtnRotateRight = GetButtonHandle((m_Windowname $ ".TabCharacterView.BtnRotateRight"));
	m_CloseButton = GetButtonHandle((m_Windowname $ ".CloseButton"));
	m_ObjectViewport = GetCharacterViewportWindowHandle((m_Windowname $ ".TabCharacterView.ObjectViewport"));
	m_ObjectViewport.SetDragRotationRate(300);
	if(getInstanceUIData().GetIsLiveServer())
	{
		MainTree = GetTreeHandle((m_Windowname $ ".TabBounsView.MainTree"));
	}
	return;
}

function HandleChangeCharacterPawn(string param)
{
	local UserInfo uInfo;

	ParseInt(param, "MeshType", m_MeshType);
	switch(m_MeshType)
	{
		case 0:
			m_ObjectViewport.SetCharacterScale(1.0000000);
			m_ObjectViewport.SetCharacterOffsetX(-2);
			m_ObjectViewport.SetCharacterOffsetY(-3);
			break;
		case 1:
			m_ObjectViewport.SetCharacterScale(1.0300000);
			m_ObjectViewport.SetCharacterOffsetX(-2);
			m_ObjectViewport.SetCharacterOffsetY(-5);
			break;
		case 8:
			m_ObjectViewport.SetCharacterScale(1.0470001);
			m_ObjectViewport.SetCharacterOffsetX(2);
			m_ObjectViewport.SetCharacterOffsetY(-5);
			break;
		case 9:
			m_ObjectViewport.SetCharacterScale(1.0700001);
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(-6);
			break;
		case 6:
			m_ObjectViewport.SetCharacterScale(0.9800000);
			m_ObjectViewport.SetCharacterOffsetX(-2);
			m_ObjectViewport.SetCharacterOffsetY(-4);
			break;
		case 7:
			m_ObjectViewport.SetCharacterScale(1.0400000);
			m_ObjectViewport.SetCharacterOffsetX(-4);
			m_ObjectViewport.SetCharacterOffsetY(-5);
			break;
		case 2:
			m_ObjectViewport.SetCharacterScale(0.9900000);
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(-4);
			break;
		case 3:
			m_ObjectViewport.SetCharacterScale(1.0150000);
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(-4);
			break;
		case 10:
			if(GetPlayerInfo(uInfo))
			{
				if((uInfo.Class == 217))
				{
					m_ObjectViewport.SetCharacterScale(0.8030000);
					m_ObjectViewport.SetCharacterOffsetX(0);
					m_ObjectViewport.SetCharacterOffsetY(1);
				}
				else
				{
					m_ObjectViewport.SetCharacterScale(0.9530000);
					m_ObjectViewport.SetCharacterOffsetX(0);
					m_ObjectViewport.SetCharacterOffsetY(-6);
				}
			}
			break;
		case 11:
			m_ObjectViewport.SetCharacterScale(0.9700000);
			m_ObjectViewport.SetCharacterOffsetX(2);
			m_ObjectViewport.SetCharacterOffsetY(-5);
			break;
		case 12:
			m_ObjectViewport.SetCharacterScale(0.9550000);
			m_ObjectViewport.SetCharacterOffsetX(-2);
			m_ObjectViewport.SetCharacterOffsetY(-5);
			break;
		case 13:
			m_ObjectViewport.SetCharacterScale(0.9850000);
			m_ObjectViewport.SetCharacterOffsetX(0);
			m_ObjectViewport.SetCharacterOffsetY(-5);
			break;
		case 4:
			m_ObjectViewport.SetCharacterScale(1.0430000);
			m_ObjectViewport.SetCharacterOffsetX(0);
			m_ObjectViewport.SetCharacterOffsetY(1);
			break;
		case 5:
			m_ObjectViewport.SetCharacterScale(1.0900000);
			m_ObjectViewport.SetCharacterOffsetX(0);
			m_ObjectViewport.SetCharacterOffsetY(-3);
			break;
		case 14:
			m_ObjectViewport.SetCharacterScale(0.9930000);
			m_ObjectViewport.SetCharacterOffsetX(-5);
			m_ObjectViewport.SetCharacterOffsetY(-4);
			break;
		case 15:
			m_ObjectViewport.SetCharacterScale(1.0100000);
			m_ObjectViewport.SetCharacterOffsetX(0);
			m_ObjectViewport.SetCharacterOffsetY(-3);
			break;
		case 17:
			m_ObjectViewport.SetCharacterScale(1.0150000);
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(-1);
			break;
		case 18:
			m_ObjectViewport.SetCharacterScale(1.0150000);
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(-1);
			break;
		case 19:
			m_ObjectViewport.SetCharacterScale(1.0150000);
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(-1);
			break;
		default:
			break;
	}
	return;
}

function int GetInitClassID(int currentClassID)
{
	local array<int> EnableClassIndexList;

	Class'NWindow.UIDataManager'.static.GetEnableClassIndexList(currentClassID, EnableClassIndexList);
	return EnableClassIndexList[0];
}

function TreeInsertBlankNodeItem(string NodeName, int gabY)
{
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_BLANK;
	infNodeItem.bStopMouseFocus = true;
	infNodeItem.b_nHeight = gabY;
	MainTree.InsertNodeItem(NodeName, infNodeItem);
	return;
}

function ArtifactSkillInfoStruct HandleArtifactItemList2SkillInfo(ItemInfo Info)
{
	local ArtifactSkillInfoStruct artifactSkillInfo;
	local ArtifactUIData ArtifactData;
	local SkillInfo SkillInfo;

	Class'NWindow.UIDATA_ARTIFACT'.static.FindArtifactData(Info.Id.ClassID, ArtifactData);
	GetSkillInfo(ArtifactData.EnchantSkillID, (Info.Enchanted + 1), 0, SkillInfo);
	artifactSkillInfo.Name = SkillInfo.SkillName;
	artifactSkillInfo.Level = SkillInfo.SkillLevel;
	artifactSkillInfo.IconName = SkillInfo.TexName;
	artifactSkillInfo.IconPanel = SkillInfo.IconPanel;
	artifactSkillInfo.Description = SkillInfo.SkillDesc;
	artifactSkillInfo.SkillID = SkillInfo.SkillID;
	artifactSkillInfo.Id = Info.Id;
	return artifactSkillInfo;
}

function MakeNodes(array<ArtifactSkillInfoStruct> artifactSkillInfos, int ArtifactType)
{
	local int i, MaxW;
	local string strNodeName;
	local Color enchantedColor, NameColor;
	local array<int> nodeNums;

	enchantedColor.R = 170;
	enchantedColor.G = 108;
	enchantedColor.B = 231;
	enchantedColor.A = 255;
	NameColor.R = 220;
	NameColor.G = 220;
	NameColor.B = 220;
	NameColor.A = 255;
	nodeNums.Length = 3;
	MaxW = 218;
	i = 0;
	while((i < artifactSkillInfos.Length))
	{
		strNodeName = makeNode(string(nodeNums[ArtifactType]), (("root" $ ".") $ string(ArtifactType)));
		if((nodeNums[ArtifactType] == 0))
		{
			TreeInsertBlankNodeItem(strNodeName, 5);
		}
		if(((float(nodeNums[ArtifactType]) % 2.0000000) == 0.0000000))
		{
			getInstanceL2Util().TreeHandleInsertTextureNodeItem(MainTree, strNodeName, "L2UI_CT1.EmptyBtn", 260, 38);
		}
		else
		{
			getInstanceL2Util().TreeHandleInsertTextureNodeItem(MainTree, strNodeName, "L2UI_CH3.etc.textbackline", 260, 38, , , , , 14);
		}
		getInstanceL2Util().TreeHandleInsertTextureNodeItem(MainTree, strNodeName, "L2UI_CT1.ItemWindow.ItemWindow_DF_SlotBox_Default", 36, 36, -260, 1);
		getInstanceL2Util().TreeHandleInsertTextureNodeItem(MainTree, strNodeName, artifactSkillInfos[i].IconName, 32, 32, -34, 2);
		getInstanceL2Util().TreeHandleInsertTextureNodeItem(MainTree, strNodeName, artifactSkillInfos[i].IconPanel, 32, 32, -32, 2);
		if((artifactSkillInfos[i].Level > 1))
		{
			TreeHandleInsertTextNodeItem(strNodeName, ("+" $ string((artifactSkillInfos[i].Level - 1))), 3, 4, enchantedColor, true);
			TreeHandleInsertTextNodeItem(strNodeName, GetEllipsisString(artifactSkillInfos[i].Name, (MaxW - 44)), 10, 4, NameColor, true);
		}
		else
		{
			TreeHandleInsertTextNodeItem(strNodeName, GetEllipsisString(artifactSkillInfos[i].Name, MaxW), 3, 4, NameColor, true);
		}
		getInstanceL2Util().TreeHandleInsertTextNodeItem(MainTree, strNodeName, GetEllipsisString(artifactSkillInfos[i].Description, MaxW), 37, -17, COLOR_GOLD, true, true);
		nodeNums[ArtifactType]++;
		i++;
	}
	artifactSkillInfos.Length = 0;
	return;
}

function Clear()
{
	MainTree.Clear();
	return;
}

function StartTreeWnd(string param)
{
	Clear();
	return;
}

function ExpandNodes()
{
	local int i;

	i = 0;
	while((i < 3))
	{
		if((MainTree.GetChildNode((("root" $ ".") $ string(i))) != ""))
		{
			MainTree.SetExpandedNode((("root" $ ".") $ string(i)), true);
			i++;
			continue;
		}
		MainTree.SetExpandedNode((("root" $ ".") $ string(i)), false);
		i++;
	}
	return;
}

function MakeRootNodes()
{
	local XMLTreeNodeInfo infNode;
	local int i;

	infNode.strName = "root";
	MainTree.InsertNode("root", infNode);
	i = 0;
	while((i < 3))
	{
		InsertExpandNode(i);
		i++;
	}
	return;
}

function string makeNode(string NodeName, string parentname)
{
	local XMLTreeNodeInfo infNode, infNodeClear;

	infNode = infNodeClear;
	infNode.strName = NodeName;
	infNode.nOffSetX = 2;
	return MainTree.InsertNode(parentname, infNode);
}

function string InsertExpandNode(int NodeNum)
{
	local string NodeName;
	local Color NameColor;

	NameColor.R = 220;
	NameColor.G = 220;
	NameColor.B = 220;
	NameColor.A = 255;
	NodeName = (("root" $ ".") $ string(NodeNum));
	getInstanceL2Util().TreeHandleInsertExpandBtnNode(MainTree, string(NodeNum), "root", , , , , , , , 7);
	TreeHandleInsertTextNodeItem(NodeName, (GetSystemString(3881) @ string((NodeNum + 1))), 2, 1, NameColor, true);
	return NodeName;
}

function TreeHandleInsertTextNodeItem(string NodeName, string ItemName, int OffsetX, int OffsetY, Color C, bool oneline)
{
	local XMLTreeNodeItemInfo infNodeItem;

	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = ItemName;
	infNodeItem.nOffSetX = OffsetX;
	infNodeItem.nOffSetY = OffsetY;
	infNodeItem.t_bDrawOneLine = oneline;
	infNodeItem.t_color.R = C.R;
	infNodeItem.t_color.G = C.G;
	infNodeItem.t_color.B = C.B;
	infNodeItem.t_color.A = C.A;
	MainTree.InsertNodeItem(NodeName, infNodeItem);
	return;
}

function ResetArtifactSkillList()
{
	local int currentActiveNum;
	local InventoryWnd inventoryWndScript;

	inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
	Clear();
	MakeRootNodes();
	if((inventoryWndScript.m_equipItem[37].GetItemNum() == 0))
	{
		inventoryWndScript.SetArtifactEffectByStoneState(-1);
		inventoryWndScript.SetArtifactActiveStone(0);
		inventoryWndScript.SetArtifactActiveSet(0, false);
		inventoryWndScript.SetArtifactActiveSet(1, false);
		inventoryWndScript.SetArtifactActiveSet(2, false);
		return;
	}
	if(ResetArtifactSkill(0))
	{
		currentActiveNum++;
	}
	if(ResetArtifactSkill(1))
	{
		currentActiveNum++;
	}
	if(ResetArtifactSkill(2))
	{
		currentActiveNum++;
	}
	inventoryWndScript.SetArtifactActiveStone(currentActiveNum);
	inventoryWndScript.SetArtifactEffectByStoneState(currentActiveNum);
	ExpandNodes();
	return;
}

function bool ResetArtifactSkill(int ArtifactType)
{
	local InventoryWnd inventoryWndScript;
	local bool IsActive;
	local int i;
	local array<ItemInfo> infos;
	local array<ArtifactSkillInfoStruct> artifactSkills;

	if(!getInstanceUIData().GetIsLiveServer())
	{
		return false;
	}
	inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
	infos = inventoryWndScript.GetArtifactEquipedList(ArtifactType);
	artifactSkills.Length = infos.Length;
	i = 0;
	while((i < infos.Length))
	{
		artifactSkills[i] = HandleArtifactItemList2SkillInfo(infos[i]);
		i++;
	}
	MakeNodes(artifactSkills, ArtifactType);
	IsActive = (infos.Length >= 7);
	if(IsActive)
	{
		inventoryWndScript.SetArtifactActiveSet(ArtifactType, true);
	}
	else
	{
		inventoryWndScript.SetArtifactActiveSet(ArtifactType, false);
	}
	return IsActive;
}

function ClickTreeNode(string Name)
{
	local string childNodes;

	childNodes = MainTree.GetChildNode(Name);
	if((childNodes == ""))
	{
		MainTree.SetExpandedNode(Name, false);
	}
	return;
}

function ToggleMe()
{
	local InventoryWnd inventoryWndScript;

	inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
	inventoryWndScript.toogleCharacterViewPort(!Me.IsShowWindow());
	return;
}

function string GetEllipsisString(string Str, int MaxWidth)
{
	local string fixedString;
	local int nWidth, nHeight;

	GetTextSizeDefault((Str $ "..."), nWidth, nHeight);
	if((nWidth < MaxWidth))
	{
		return Str;
	}
	fixedString = DivideStringWithWidth(Str, MaxWidth);
	if((fixedString != Str))
	{
		fixedString = (fixedString $ "...");
	}
	return fixedString;
}

function ArtifactClicked()
{
	if(!Me.IsShowWindow())
	{
		ToggleMe();
	}
	GetTabHandle((m_Windowname $ ".CharacterTab")).SetTopOrder(1, true);
	return;
}

function CharacterClickec()
{
	if(!Me.IsShowWindow())
	{
		ToggleMe();
	}
	GetTabHandle((m_Windowname $ ".CharacterTab")).SetTopOrder(0, true);
	return;
}

defaultproperties
{
	m_Windowname="InventoryWndCharacterView"
}
