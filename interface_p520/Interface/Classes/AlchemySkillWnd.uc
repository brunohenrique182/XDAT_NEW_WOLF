class AlchemySkillWnd extends UICommonAPI;

const Skill_MAX_COUNT = 24;
const Skill_GROUP_COUNT = 8;
const SKILL_COL_COUNT = 7;
const Skill_GROUP_COUNT_P = 6;
const SKILL_ITEMWND_WIDTH = 260;
const SKILL_SLOTBG_WIDTH = 252;
const TOP_MARGIN = 5;
const NAME_WND_HEIGHT = 20;
const BETWEEN_NAME_ITEM = 3;
const SKILL_NORMAL = 0;
const SKILL_BUF = 1;
const SKILL_DEBUF = 2;
const SKILL_TOGGLE = 3;
const SKILL_SONG_DANCE = 4;
const SKILL_ITEM = 5;
const SKILL_HERO = 6;
const SKILL_CHANGE = 7;
const SKILLTYPE_ALCHEMYSKILL = 140;
const OFFSET_X_ICON_TEXTURE = 0;
const OFFSET_Y_ICON_TEXTURE = 4;
const OFFSET_Y_SECONDLINE = -17;

var WindowHandle m_wndTop;
var WindowHandle m_wndSkillDrawWnd;
var bool m_bShow;
var string m_Windowname;
var int currentUserLevel;
var WindowHandle Drawer;
var L2Util util;
var bool bDrawBgTree1;
var bool bDrawBgTree2;
var bool bDrawBgTree3;
var string treeName;
var string ROOTNAME;
var string LIST1;
var string LIST2;
var string LIST3;
var int selectedRequestLevel;
var int totalSkillCount;
var int addCount;
var string beforeTreeName;
var int nScrollHeight;
var TreeHandle m_UITree;
var array<string> treeNodeNameNewSkillArray;
var array<string> treeNodeNameLevelUpArray;
var string clickedTreeNodeName;
var array<UIConstants.SkillTrainInfo> skillTrainInfoArray;
var int clickedTreeNodeIndex;
var WindowHandle SkillTrainInfoWndScript;
var int levelUpSkillIndex;
var int newSkillIndex;
var UserInfo PlayerInfo;
var bool bRefreshSelect;
var int mainLevel;

function OnRegisterEvent()
{
	RegisterEvent(2010);
	RegisterEvent(2030);
	RegisterEvent(180);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	OnRegisterEvent();
	InitHandle();
	util = L2Util(GetScript("L2Util"));
	SkillTrainInfoWndScript = GetWindowHandle("AlchemySkillLearnWnd");
	m_bShow = false;
	return;
}

function InitHandle()
{
	m_UITree = GetTreeHandle("AlchemySkillWnd.SkillTrainTree");
	return;
}

function OnShow()
{
	GetPlayerInfo(PlayerInfo);
	currentUserLevel = PlayerInfo.nLevel;
	clickedTreeNodeName = "";
	clickedTreeNodeIndex = -1;
	m_bShow = true;
	return;
}

function OnHide()
{
	m_bShow = false;
	if(GetWindowHandle("AlchemySkillLearnWnd").IsShowWindow())
	{
		GetWindowHandle("AlchemySkillLearnWnd").HideWindow();
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int iType;

	switch(Event_ID)
	{
		case 2010:
			ParseInt(param, "Type", iType);
			if((iType == 140))
			{
				ParseInt(param, "Count", totalSkillCount);
				if((totalSkillCount == 0))
				{
					if(IsShowWindow("AlchemySkillWnd"))
					{
						HideWindow("AlchemySkillWnd");
					}
					return;
				}
				GetPlayerInfo(PlayerInfo);
				currentUserLevel = PlayerInfo.nLevel;
				TreeClear();
				ShowSkillTree();
				levelUpSkillIndex = 0;
				newSkillIndex = 0;
				bRefreshSelect = false;
				treeNodeNameNewSkillArray.Remove(0, treeNodeNameNewSkillArray.Length);
				treeNodeNameLevelUpArray.Remove(0, treeNodeNameLevelUpArray.Length);
				skillTrainInfoArray.Remove(0, skillTrainInfoArray.Length);
				if(!IsShowWindow("AlchemySkillWnd"))
				{
					ShowWindow("AlchemySkillWnd");
				}
			}
			break;
		case 2030:
			ParseInt(param, "iType", iType);
			if((iType == 140))
			{
				AddSkillTrainListItem(param);
				buildTree();
			}
			break;
		case 180:
			GetPlayerInfo(PlayerInfo);
			if((currentUserLevel != PlayerInfo.nLevel))
			{
				if(IsShowWindow("AlchemySkillWnd"))
				{
					HideWindow("AlchemySkillWnd");
				}
			}
			currentUserLevel = PlayerInfo.nLevel;
			break;
		default:
			break;
	}
	return;
}

function buildTree()
{
	local int i;
	local bool bGetInfo;

	if((skillTrainInfoArray.Length >= totalSkillCount))
	{
		quickSortChar(0, (skillTrainInfoArray.Length - 1), false);
		i = 0;
		while((i < skillTrainInfoArray.Length))
		{
			createTreeNode(skillTrainInfoArray[i]);
			switch(Left(clickedTreeNodeName, 15))
			{
				case "root.SKILLLIST1":
					if(((bGetInfo == false) && ((treeNodeNameNewSkillArray.Length - 1) >= clickedTreeNodeIndex)))
					{
						beforeTreeName = treeNodeNameNewSkillArray[clickedTreeNodeIndex];
						OnClickButton(treeNodeNameNewSkillArray[clickedTreeNodeIndex]);
						bGetInfo = true;
					}
					break;
				case "root.SKILLLIST2":
					if(((bGetInfo == false) && ((treeNodeNameLevelUpArray.Length - 1) >= clickedTreeNodeIndex)))
					{
						beforeTreeName = treeNodeNameLevelUpArray[clickedTreeNodeIndex];
						OnClickButton(treeNodeNameLevelUpArray[clickedTreeNodeIndex]);
						bGetInfo = true;
					}
					break;
				default:
					break;
			}
			i++;
		}
	}
	return;
}

function OnClickButton(string strID)
{
	local array<string> Result;
	local string treelist;
	local array<string> SkillIDLevel;

	treelist = Left(strID, 4);
	if((treelist == ROOTNAME))
	{
		Split(strID, ".", Result);
		if((Result.Length > 2))
		{
			if(((Result[1] == LIST1) || (Result[1] == LIST2)))
			{
				if((beforeTreeName != strID))
				{
					m_UITree.SetExpandedNode(beforeTreeName, false);
				}
				else
				{
					m_UITree.SetExpandedNode(beforeTreeName, true);
				}
				beforeTreeName = strID;
			}
			else
			{
				m_UITree.SetExpandedNode(strID, false);
			}
			if(((Result[1] == LIST1) || (Result[1] == LIST2)))
			{
				Split(Result[2], ",", SkillIDLevel);
				clickedTreeNodeName = strID;
				clickedTreeNodeIndex = int(SkillIDLevel[2]);
				Debug("-------> RequestAcquireSkillInfo");
				RequestAcquireSkillInfo(int(SkillIDLevel[0]), int(SkillIDLevel[1]), 0, 140);
			}
		}
	}
	return;
}

function TreeClear()
{
	Class'NWindow.UIAPI_TREECTRL'.static.Clear(treeName);
	return;
}

function ShowSkillTree()
{
	util.TreeHandleInsertRootNode(m_UITree, ROOTNAME, "", 0, 4);
	util.TreeHandleInsertExpandBtnNode(m_UITree, LIST1, ROOTNAME);
	util.TreeHandleInsertTextNodeItem(m_UITree, ((ROOTNAME $ ".") $ LIST1), GetSystemString(2370), 5, 0, COLOR_DEFAULT, true);
	util.TreeHandleInsertExpandBtnNode(m_UITree, LIST2, ROOTNAME);
	util.TreeHandleInsertTextNodeItem(m_UITree, ((ROOTNAME $ ".") $ LIST2), GetSystemString(2371), 5, 0, COLOR_DEFAULT, true);
	util.TreeHandleInsertExpandBtnNode(m_UITree, LIST3, ROOTNAME);
	util.TreeHandleInsertTextNodeItem(m_UITree, ((ROOTNAME $ ".") $ LIST3), GetSystemString(2372), 5, 0, COLOR_DEFAULT, true);
	m_UITree.SetExpandedNode(((ROOTNAME $ ".") $ LIST1), true);
	m_UITree.SetExpandedNode(((ROOTNAME $ ".") $ LIST2), true);
	m_UITree.SetExpandedNode(((ROOTNAME $ ".") $ LIST3), true);
	return;
}

function int getSkillRequestLevel(int nSkillID, int nSkillLevel)
{
	local int i, RValue;

	RValue = -1;
	i = 0;
	while((i < skillTrainInfoArray.Length))
	{
		if(((skillTrainInfoArray[i].Id == nSkillID) && (skillTrainInfoArray[i].Level == nSkillLevel)))
		{
			RValue = skillTrainInfoArray[i].requiredLevel;
			break;
		}
		i++;
	}
	return RValue;
}

function AddSkillTrainListItem(string param)
{
	local int Id, Level, SubLevel;
	local INT64 spConsume;
	local int requiredLevel;
	local string strName, strIconName, strEnchantName;
	local UIConstants.SkillTrainInfo Info;

	ParseString(param, "strIconName", strIconName);
	ParseString(param, "strName", strName);
	ParseString(param, "strEnchantName", strEnchantName);
	ParseInt(param, "iID", Id);
	ParseInt(param, "iLevel", Level);
	ParseInt(param, "iSubLevel", SubLevel);
	ParseInt(param, "iRequiredLevel", requiredLevel);
	ParseINT64(param, "iSPConsume", spConsume);
	if((Id <= 0))
	{
		return;
	}
	addCount++;
	Info.Id = Id;
	Info.Level = Level;
	Info.SubLevel = SubLevel;
	Info.spConsume = spConsume;
	Info.requiredLevel = requiredLevel;
	Info.strName = strName;
	Info.strIconName = strIconName;
	Info.strEnchantName = strEnchantName;
	skillTrainInfoArray[skillTrainInfoArray.Length] = Info;
	return;
}

function createTreeNode(UIConstants.SkillTrainInfo Info)
{
	local SkillInfo SkillInfo;
	local string setTreeName, panelName;
	local int Level, Id, requiredLevel;
	local string strName, strIconName;
	local UserInfo UserInfo;
	local ItemID cID;
	local string strRetName;
	local CustomTooltip t;
	local bool isMaster;

	Id = Info.Id;
	requiredLevel = Info.requiredLevel;
	cID = GetItemID(Info.Id);
	GetSkillInfo(Info.Id, Info.Level, Info.SubLevel, SkillInfo);
	GetPlayerInfo(UserInfo);
	strName = SkillInfo.SkillName;
	strIconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(cID, Info.Level, Info.SubLevel);
	panelName = SkillInfo.IconPanel;
	Level = Info.Level;
	util.setCustomTooltip(t);
	util.ToopTipMinWidth(200);
	MakeSkillToolTip(strName, cID, Level, Info);
	if((GetAlchemySkillGradeType(Id, Level) == 4))
	{
		isMaster = true;
	}
	else
	{
		isMaster = false;
	}
	if((requiredLevel <= PlayerInfo.nLevel))
	{
		if((Level == 1))
		{
			setTreeName = ((ROOTNAME $ ".") $ LIST1);
			strRetName = util.TreeInsertItemTooltipNode(treeName, ((((("" $ string(Id)) $ ",") $ string(Level)) $ ",") $ string(newSkillIndex)), setTreeName, -7, 0, 38, 0, 30, 38, util.getCustomToolTip());
			treeNodeNameNewSkillArray[newSkillIndex] = strRetName;
			newSkillIndex++;
			if(bDrawBgTree1)
			{
				util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CH3.etc.textbackline", 262, 38, , , , , 14);
			}
			else
			{
				util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.EmptyBtn", 262, 38);
			}
			bDrawBgTree1 = !bDrawBgTree1;
			util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -251, 2);
			util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, strIconName, 32, 32, -34, (4 - 1));
			if((SkillInfo.IconPanel != ""))
			{
				util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, panelName, 32, 32, -32, (4 - 1));
			}
			if(isMaster)
			{
				util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, strName, 5, 5, Yellow03, true);
			}
			else
			{
				util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, strName, 5, 5, COLOR_DEFAULT, true);
			}
			util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, GetSystemString(88), 46, -17, COLOR_GRAY, true, true);
			util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(Level), 2, -17, COLOR_GOLD);
		}
		else if((requiredLevel <= PlayerInfo.nLevel))
		{
			setTreeName = ((ROOTNAME $ ".") $ LIST2);
			strRetName = util.TreeInsertItemTooltipNode(treeName, ((((("" $ string(Id)) $ ",") $ string(Level)) $ ",") $ string(levelUpSkillIndex)), setTreeName, -7, 0, 38, 0, 32, 38, util.getCustomToolTip());
			treeNodeNameLevelUpArray[levelUpSkillIndex] = strRetName;
			levelUpSkillIndex++;
			if(bDrawBgTree2)
			{
				util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CH3.etc.textbackline", 257, 38, , , , , 14);
			}
			else
			{
				util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.EmptyBtn", 257, 38);
			}
			bDrawBgTree2 = !bDrawBgTree2;
			util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -251, 2);
			util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, strIconName, 32, 32, -34, (4 - 1));
			if((SkillInfo.IconPanel != ""))
			{
				util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, panelName, 32, 32, -32, (4 - 1));
			}
			if(isMaster)
			{
				util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, strName, 5, 5, Yellow03, true);
			}
			else
			{
				util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, strName, 5, 5, COLOR_DEFAULT, true);
			}
			util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, GetSystemString(88), 46, -17, COLOR_GRAY, true, true);
			util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(Level), 2, -17, COLOR_GOLD);
		}
	}
	else
	{
		setTreeName = ((ROOTNAME $ ".") $ LIST3);
		strRetName = util.TreeInsertItemTooltipNode(treeName, ((("" $ string(Id)) $ ",") $ string(Level)), setTreeName, -7, 0, 38, 0, 32, 38, util.getCustomToolTip());
		if(bDrawBgTree3)
		{
			util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CH3.etc.textbackline", 257, 38, , , , , 14);
		}
		else
		{
			util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.EmptyBtn", 257, 38);
		}
		bDrawBgTree3 = !bDrawBgTree3;
		util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -251, 2);
		util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, strIconName, 32, 32, -34, (4 - 1));
		util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "l2ui_ct1.ItemWindow_IconDisable", 32, 32, -32, (4 - 1));
		if((TypeCheck(SkillInfo) == true))
		{
			util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "l2ui_ct1.SkillWnd_DF_ListIcon_Active", 32, 32, -34, (4 - 1));
		}
		else
		{
			util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "l2ui_ct1.SkillWnd_DF_ListIcon_Passive", 32, 32, -34, (4 - 1));
		}
		util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, strName, 5, 5, COLOR_DEFAULT, true);
		util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, (GetSystemString(2381) $ " : "), 46, -17, COLOR_GRAY, true, true);
		util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(requiredLevel), 2, -17, COLOR_RED);
	}
	return;
}

function MakeSkillToolTip(string strName, ItemID Id, int Level, UIConstants.SkillTrainInfo pSkillTrainInfo)
{
	local SkillInfo SkillInfo;
	local int SkillID, requiredLevel, nTmp;

	if(!m_bShow)
	{
		return;
	}
	SkillID = pSkillTrainInfo.Id;
	requiredLevel = pSkillTrainInfo.requiredLevel;
	GetSkillInfo(SkillID, Level, 0, SkillInfo);
	if((GetAlchemySkillGradeType(SkillID, Level) == 4))
	{
		util.ToopTipInsertText(strName, true, false, COLOR_YELLOW03);
	}
	else
	{
		util.ToopTipInsertText(strName, true, false, COLOR_DEFAULT);
	}
	util.ToopTipInsertText((" " $ GetSystemString(88)), true, false, COLOR_GRAY);
	util.ToopTipInsertText((" " $ string(Level)), true, false, COLOR_GOLD);
	util.ToopTipInsertText(Class'NWindow.UIDATA_SKILL'.static.GetOperateType(Id, Level, 0), true, true, COLOR_GOLD, 0, 6);
	util.TooltipInsertItemBlank(6);
	nTmp = Class'NWindow.UIDATA_SKILL'.static.GetHpConsume(Id, Level, 0);
	if((nTmp > 0))
	{
		util.TwoWordCombineColon(GetSystemString(1195), string(nTmp), COLOR_GRAY, COLOR_GOLD, true);
	}
	nTmp = Class'NWindow.UIDATA_SKILL'.static.GetMpConsume(Id, Level, 0);
	if((nTmp > 0))
	{
		util.TwoWordCombineColon(GetSystemString(320), string(nTmp), COLOR_GRAY, COLOR_GOLD, true);
	}
	util.ToopTipInsertText(Class'NWindow.UIDATA_SKILL'.static.GetDescription(Id, Level, 0), false, true, COLOR_GRAY, 0, 6);
	util.TooltipInsertItemBlank(6);
	util.TooltipInsertItemLine();
	util.TooltipInsertItemBlank(3);
	util.ToopTipInsertText((("<" $ GetSystemString(2375)) $ ">"), true, true);
	util.TwoWordCombineColon(GetSystemString(2381), string(requiredLevel), COLOR_GRAY, COLOR_GOLD, true);
	return;
}

function bool TypeCheck(SkillInfo Info)
{
	return isActiveSkill(Info.IconType);
}

function closeTreeNode()
{
	m_UITree.SetExpandedNode(beforeTreeName, false);
	beforeTreeName = "";
	return;
}

function quickSortChar(int Left, int Right, bool Desc)
{
	local int q;

	if(((Right - Left) == 0))
	{
		return;
	}
	else if((Left < Right))
	{
		q = partitionChar(Left, Right, Desc);
		quickSortChar(Left, (q - 1), Desc);
		quickSortChar((q + 1), Right, Desc);
	}
	return;
}

function int partitionChar(int Low, int High, bool Desc)
{
	local string pivot, temp;
	local int i, j;

	pivot = Caps(string(skillTrainInfoArray[Low].Level));
	j = Low;
	i = (Low + 1);
	while((i <= High))
	{
		temp = Caps(string(skillTrainInfoArray[i].Level));
		if(Desc)
		{
			if((temp > pivot))
			{
				j++;
				swap(i, j);
			}
			i++;
			continue;
		}
		if((temp < pivot))
		{
			j++;
			swap(i, j);
		}
		i++;
	}
	swap(Low, j);
	return j;
}

function swap(int i, int j)
{
	local UIConstants.SkillTrainInfo Info;

	Info = skillTrainInfoArray[i];
	skillTrainInfoArray[i] = skillTrainInfoArray[j];
	skillTrainInfoArray[j] = Info;
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
	m_Windowname="AlchemySkillWnd"
	treeName="AlchemySkillWnd.SkillTrainTree"
	ROOTNAME="root"
	LIST1="SKILLLIST1"
	LIST2="SKILLLIST2"
	LIST3="SKILLLIST3"
}
