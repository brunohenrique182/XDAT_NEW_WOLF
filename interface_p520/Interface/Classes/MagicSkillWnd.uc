class MagicSkillWnd extends UICommonAPI;

const Skill_MAX_COUNT = 24;
const SKILL_COL_COUNT = 7;
const Skill_GROUP_COUNT = 13;
const Skill_GROUP_COUNT_P = 9;
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
const OFFSET_X_ICON_TEXTURE = 0;
const OFFSET_Y_ICON_TEXTURE = 4;
const OFFSET_Y_SECONDLINE = -17;

struct SubjobInfo
{
	var int Id;
	var int ClassID;
	var int Level;
	var int Type;
};

var WindowHandle m_wndTop;
var WindowHandle m_wndSkillDrawWnd;
var WindowHandle m_wndName[13];
var TextBoxHandle m_NameStr[13];
var TextureHandle m_NameBtn[13];
var TextureHandle m_ItemBg[13];
var WindowHandle m_Wnd[13];
var ItemWindowHandle m_Item[13];
var ButtonHandle m_HiddenBtn[13];
var WindowHandle areaScroll;
var WindowHandle m_wndName_p[9];
var TextBoxHandle m_NameStr_p[9];
var TextureHandle m_NameBtn_p[9];
var TextureHandle m_ItemBg_p[9];
var WindowHandle m_wnd_p[9];
var ItemWindowHandle m_Item_p[9];
var ButtonHandle m_HiddenBtn_p[9];
var WindowHandle areaScroll_p;
var bool m_bShow;
var string m_Windowname;
var int m_bExistSkill[13];
var int nScrollHeight;
var int m_bExistSkill_p[9];
var int nScrollHeight_p;
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
var string beforeTreeName;
var AnimTextureHandle TexTabLightActive;
var AnimTextureHandle TexTabLightPassive;
var TreeHandle m_UITree;
var ButtonHandle ResearchButton;
var array<string> treeNodeNameNewSkillArray;
var array<string> treeNodeNameLevelUpArray;
var string clickedTreeNodeName;
var int clickedTreeNodeIndex;
var WindowHandle SkillTrainInfoWndScript;
var int levelUpSkillIndex;
var int newSkillIndex;
var bool _isSkillLearnNotice;
var array<SubjobInfo> subjobInfoArray;
var SubjobInfo beforeSubjobInfo;
var bool isDualClass;
var int mainLevel;
var int dualLevel;
var int currentType;

function OnRegisterEvent()
{
	if(IsUseRenewalSkillWnd())
	{
		return;
	}
	RegisterEvent(1280);
	RegisterEvent(1290);
	RegisterEvent(1900);
	RegisterEvent(2064);
	RegisterEvent(5360);
	RegisterEvent(2055);
	RegisterEvent(2056);
	RegisterEvent(2057);
	RegisterEvent(1291);
	RegisterEvent(2059);
	RegisterEvent(5310);
	RegisterEvent(5311);
	RegisterEvent(5312);
	RegisterEvent(180);
	RegisterEvent(8000);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	InitHandle();
	util = L2Util(GetScript("L2Util"));
	SkillTrainInfoWndScript = GetWindowHandle("SkillLearnWnd");
	m_bShow = false;
	if(getInstanceUIData().getIsArenaServer())
	{
		ResearchButton.HideWindow();
	}
	return;
}

function InitHandle()
{
	local int i;

	m_UITree = GetTreeHandle("MagicSkillWnd.SkillTrainTree");
	m_wndTop = GetWindowHandle(m_Windowname);
	Drawer = GetWindowHandle("MagicSkillDrawerWnd");
	areaScroll = GetWindowHandle((m_Windowname $ ".ASkillScroll"));
	areaScroll_p = GetWindowHandle((m_Windowname $ ".PSkillScroll"));
	TexTabLightActive = GetAnimTextureHandle("MagicSkillWnd.TexTabLightActive");
	TexTabLightPassive = GetAnimTextureHandle("MagicSkillWnd.TexTabLightPassive");
	ResearchButton = GetButtonHandle("MagicSkillWnd.ResearchButton");
	i = 0;
	while((i < 13))
	{
		m_wndName[i] = GetWindowHandle(((m_Windowname $ ".ASkill.ASkillName") $ string(i)));
		m_Wnd[i] = GetWindowHandle(((m_Windowname $ ".ASkill.ASkill") $ string(i)));
		m_NameStr[i] = GetTextBoxHandle(((((m_Windowname $ ".ASkill.ASkillName") $ string(i)) $ ".ASkillNameStr") $ string(i)));
		m_NameBtn[i] = GetTextureHandle(((((m_Windowname $ ".ASkill.ASkillName") $ string(i)) $ ".ASkillBtn") $ string(i)));
		m_Item[i] = GetItemWindowHandle(((((m_Windowname $ ".ASkill.ASkill") $ string(i)) $ ".ASkillItem") $ string(i)));
		m_ItemBg[i] = GetTextureHandle(((((m_Windowname $ ".ASkill.ASkill") $ string(i)) $ ".ASkillSlotBg") $ string(i)));
		m_HiddenBtn[i] = GetButtonHandle(((((m_Windowname $ ".ASkill.ASkillName") $ string(i)) $ ".ASkillHiddenBtn") $ string(i)));
		m_HiddenBtn[i].SetAlpha(255);
		i++;
	}
	i = 0;
	while((i < 9))
	{
		m_wndName_p[i] = GetWindowHandle(((m_Windowname $ ".PSkill.PSkillName") $ string(i)));
		m_wnd_p[i] = GetWindowHandle(((m_Windowname $ ".PSkill.PSkill") $ string(i)));
		m_NameStr_p[i] = GetTextBoxHandle(((((m_Windowname $ ".PSkill.PSkillName") $ string(i)) $ ".PSkillNameStr") $ string(i)));
		m_NameBtn_p[i] = GetTextureHandle(((((m_Windowname $ ".PSkill.PSkillName") $ string(i)) $ ".PSkillBtn") $ string(i)));
		m_Item_p[i] = GetItemWindowHandle(((((m_Windowname $ ".PSkill.PSkill") $ string(i)) $ ".PSkillItem") $ string(i)));
		m_ItemBg_p[i] = GetTextureHandle(((((m_Windowname $ ".PSkill.PSkill") $ string(i)) $ ".PSkillSlotBg") $ string(i)));
		m_HiddenBtn_p[i] = GetButtonHandle(((((m_Windowname $ ".PSkill.PSkillName") $ string(i)) $ ".PSkillHiddenBtn") $ string(i)));
		m_HiddenBtn_p[i].SetAlpha(255);
		i++;
	}
	TexTabLightActive.HideWindow();
	TexTabLightPassive.HideWindow();
	return;
}

function OnShow()
{
	clickedTreeNodeName = "";
	clickedTreeNodeIndex = -1;
	RequestSkillList();
	m_bShow = true;
	GetWindowHandle("ActionWnd").HideWindow();
	getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "ActionWnd");
	m_wndTop.SetFocus();
	return;
}

function OnHide()
{
	m_bShow = false;
	getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "ActionWnd");
	MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd")).setMagicSkillItemsType(false);
	MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd")).OnTextureAnimEnd(MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd")).EnchantProgressAnim);
	if(Drawer.IsShowWindow())
	{
		Drawer.HideWindow();
		MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd")).isHiding = true;
	}
	SkillTrainInfoWndScript.HideWindow();
	if(DialogIsMine())
	{
		DialogHide();
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int NewSkillID;
	local SkillInfo SkillInfo;
	local UserInfo UserInfo;

	if(IsUseRenewalSkillWnd())
	{
		return;
	}
	if((Event_ID == 1280))
	{
		HandleSkillListStart();
	}
	else if((Event_ID == 180))
	{
		GetPlayerInfo(UserInfo);
		if((currentType == 0))
		{
			mainLevel = UserInfo.nLevel;
		}
		else if((currentType == 1))
		{
			dualLevel = UserInfo.nLevel;
		}
	}
	else if((Event_ID == 5310))
	{
		updateSubjobInfo(param, Event_ID);
	}
	else if((Event_ID == 5311))
	{
		updateSubjobInfo(param, Event_ID);
	}
	else if((Event_ID == 5312))
	{
		updateSubjobInfo(param, Event_ID);
		ExecuteEvent(3280);
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("MagicSkillWnd");
	}
	else if((Event_ID == 1290))
	{
		HandleSkillList(param);
	}
	else if((Event_ID == 1900))
	{
		HandleLanguageChanged();
	}
	else if((Event_ID == 5360))
	{
		ApplySkillAvailability();
	}
	else if((Event_ID == 2055))
	{
		TreeClear();
		ShowSkillTree();
		levelUpSkillIndex = 0;
		newSkillIndex = 0;
		treeNodeNameNewSkillArray.Remove(0, treeNodeNameNewSkillArray.Length);
		treeNodeNameLevelUpArray.Remove(0, treeNodeNameLevelUpArray.Length);
	}
	else if((Event_ID == 2056))
	{
		AddSkillTrainListItem(param);
	}
	else if((Event_ID == 1291))
	{
		ComputeItemWndHeight();
		ComputeItemWndAnchor();
		ParseInt(param, "NewSkillID", NewSkillID);
		GetSkillInfo(NewSkillID, 1, 0, SkillInfo);
		if((NewSkillID != 0))
		{
			if((TypeCheck(SkillInfo) == true))
			{
				TexTabLightActive.ShowWindow();
				TexTabLightActive.SetLoopCount(1);
				TexTabLightActive.Stop();
				TexTabLightActive.Play();
			}
			else
			{
				TexTabLightPassive.ShowWindow();
				TexTabLightPassive.SetLoopCount(1);
				TexTabLightPassive.Stop();
				TexTabLightPassive.Play();
			}
		}
	}
	else if((Event_ID == 2059))
	{
		RequestSkillList();
	}
	else if((Event_ID == 2057))
	{
		switch(Left(clickedTreeNodeName, 15))
		{
			case "root.SKILLLIST1":
				if(((treeNodeNameNewSkillArray.Length - 1) >= clickedTreeNodeIndex))
				{
					beforeTreeName = treeNodeNameNewSkillArray[clickedTreeNodeIndex];
					if(((treeNodeNameNewSkillArray.Length - 1) != clickedTreeNodeIndex))
					{
						OnClickButton(treeNodeNameNewSkillArray[clickedTreeNodeIndex]);
					}
				}
				break;
			case "root.SKILLLIST2":
				if(((treeNodeNameLevelUpArray.Length - 1) >= clickedTreeNodeIndex))
				{
					beforeTreeName = treeNodeNameLevelUpArray[clickedTreeNodeIndex];
					OnClickButton(treeNodeNameLevelUpArray[clickedTreeNodeIndex]);
				}
				break;
			default:
				break;
		}
	}
	else if((Event_ID == 8000))
	{
		checkClassicForm();
	}
	return;
}

function checkClassicForm()
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		ResearchButton.SetButtonName(646);
	}
	else
	{
		ResearchButton.SetButtonName(2070);
	}
	return;
}

function OnClickItem(string strID, int Index)
{
	local ItemInfo infItem;
	local int GroupID;
	local MagicSkillDrawerWnd script_a;

	if(((InStr(strID, "ASkillItem") > -1) && (Index > -1)))
	{
		GroupID = int(Mid(strID, Len("ASkillItem"), (Len(strID) - 1)));
		if(m_Item[GroupID].GetItem(Index, infItem))
		{
			if(Drawer.IsShowWindow())
			{
				script_a = MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd"));
				script_a.handleSetCurrentSkill(infItem);
			}
			else
			{
				UseSkill(infItem.Id, infItem.ShortcutType);
			}
		}
	}
	return;
}

function OnClickButton(string strID)
{
	local int i, Index, nWndWidth, nWndHeight;
	local MagicSkillDrawerWnd script_a;
	local array<string> Result;
	local string treelist;
	local array<string> SkillIDLevel;

	Index = int(Right(strID, 1));
	treelist = Left(strID, 4);
	if((InStr(strID, "ASkillHiddenBtn") > -1))
	{
		if((m_bExistSkill[Index] == 1))
		{
			m_Wnd[Index].GetWindowSize(nWndWidth, nWndHeight);
			nScrollHeight = ((nScrollHeight - nWndHeight) - 3);
			m_NameBtn[Index].SetTexture("l2ui_ch3.QuestWnd.QuestWndPlusBtn");
			m_bExistSkill[Index] = 2;
			m_Wnd[Index].HideWindow();
			if((Index < 13))
			{
				i = (Index + 1);
				while((i < 13))
				{
					if((m_bExistSkill[i] > 0))
					{
						m_wndName[i].ClearAnchor();
						m_wndName[i].SetAnchor(((m_Windowname $ ".ASkill.ASkillName") $ string(Index)), "BottomCenter", "TopCenter", 0, 5);
						break;
					}
					i++;
				}
			}
		}
		else if((m_bExistSkill[Index] == 2))
		{
			m_Wnd[Index].GetWindowSize(nWndWidth, nWndHeight);
			nScrollHeight = ((nScrollHeight + nWndHeight) + 3);
			m_NameBtn[Index].SetTexture("l2ui_ch3.QuestWnd.QuestWndMinusBtn");
			m_bExistSkill[Index] = 1;
			m_Wnd[Index].ShowWindow();
			if((Index < 13))
			{
				i = (Index + 1);
				while((i < 13))
				{
					if((m_bExistSkill[i] > 0))
					{
						m_wndName[i].ClearAnchor();
						m_wndName[i].SetAnchor(((m_Windowname $ ".ASkill.ASkillName") $ string(Index)), "BottomCenter", "TopCenter", 0, ((nWndHeight + 3) + 5));
						break;
					}
					i++;
				}
			}
		}
		areaScroll.SetScrollHeight(nScrollHeight);
	}
	else if((InStr(strID, "PSkillHiddenBtn") > -1))
	{
		if((m_bExistSkill_p[Index] == 1))
		{
			m_wnd_p[Index].GetWindowSize(nWndWidth, nWndHeight);
			nScrollHeight_p = ((nScrollHeight_p - nWndHeight) - 3);
			m_NameBtn_p[Index].SetTexture("l2ui_ch3.QuestWnd.QuestWndPlusBtn");
			m_bExistSkill_p[Index] = 2;
			m_wnd_p[Index].HideWindow();
			if((Index < 9))
			{
				i = (Index + 1);
				while((i < 9))
				{
					if((m_bExistSkill_p[i] > 0))
					{
						m_wndName_p[i].ClearAnchor();
						m_wndName_p[i].SetAnchor(((m_Windowname $ ".PSkill.PSkillName") $ string(Index)), "BottomCenter", "TopCenter", 0, 5);
						break;
					}
					i++;
				}
			}
		}
		else if((m_bExistSkill_p[Index] == 2))
		{
			m_wnd_p[Index].GetWindowSize(nWndWidth, nWndHeight);
			nScrollHeight_p = ((nScrollHeight_p + nWndHeight) + 3);
			m_NameBtn_p[Index].SetTexture("l2ui_ch3.QuestWnd.QuestWndMinusBtn");
			m_bExistSkill_p[Index] = 1;
			m_wnd_p[Index].ShowWindow();
			if((Index < 9))
			{
				i = (Index + 1);
				while((i < 9))
				{
					if((m_bExistSkill_p[i] > 0))
					{
						m_wndName_p[i].ClearAnchor();
						m_wndName_p[i].SetAnchor(((m_Windowname $ ".PSkill.PSkillName") $ string(Index)), "BottomCenter", "TopCenter", 0, ((nWndHeight + 3) + 5));
						break;
					}
					i++;
				}
			}
		}
		areaScroll_p.SetScrollHeight(nScrollHeight_p);
	}
	else if((strID == "ResearchButton"))
	{
		if(getInstanceUIData().GetIsClassicServer())
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("MagicSkillWnd");
		}
		else
		{
			script_a = MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd"));
			if(Drawer.IsShowWindow())
			{
				Drawer.HideWindow();
				script_a.isHiding = true;
				script_a.setMagicSkillItemsType(false);
				script_a.SkillInfoClear();
				RequestSkillList();
			}
			else
			{
				Drawer.ShowWindow();
				script_a.SkillInfoClear();
				script_a.txtMySp.SetText(MakeCostString(string(GetuserSP())));
				RequestSkillList();
			}
		}
	}
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
				RequestAcquireSkillInfo(int(SkillIDLevel[0]), int(SkillIDLevel[1]), int(SkillIDLevel[3]), 0);
			}
		}
	}
	if((strID == "TabCtrl0"))
	{
		if(!getInstanceUIData().getIsArenaServer())
		{
			ResearchButton.ShowWindow();
		}
		TexTabLightActive.HideWindow();
		SkillTrainInfoWndScript.HideWindow();
	}
	else if((strID == "TabCtrl1"))
	{
		if(!getInstanceUIData().getIsArenaServer())
		{
			ResearchButton.ShowWindow();
		}
		TexTabLightPassive.HideWindow();
		SkillTrainInfoWndScript.HideWindow();
	}
	else if((strID == "TabCtrl2"))
	{
		if(Drawer.IsShowWindow())
		{
			Drawer.HideWindow();
			MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd")).isHiding = true;
			MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd")).SkillInfoClear();
			MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd")).setMagicSkillItemsType(false);
			RequestSkillList();
		}
		ResearchButton.HideWindow();
	}
	if((strID == "ActionTap_Btn"))
	{
		GetWindowHandle("ActionWnd").ShowWindow();
	}
	return;
}

function HandleLanguageChanged()
{
	RequestSkillList();
	return;
}

function ApplySkillAvailability()
{
	local int i, j, ItemNum, Id, Level, SubLevel, SkillDisabled;

	i = 0;
	while((i < 13))
	{
		ItemNum = m_Item[i].GetItemNum();
		j = 0;
		while((j < ItemNum))
		{
			m_Item[i].GetItemIdLevel(j, Id, Level, SubLevel);
			if(((Id > 0) && (Level > 0)))
			{
				SkillDisabled = GetSkillAvailability(Id, Level, SubLevel);
				m_Item[i].SetItemSkillDisabled(j, SkillDisabled);
			}
			++j;
		}
		++i;
	}
	i = 0;
	while((i < 9))
	{
		ItemNum = m_Item_p[i].GetItemNum();
		j = 0;
		while((j < ItemNum))
		{
			m_Item_p[i].GetItemIdLevel(j, Id, Level, SubLevel);
			if(((Id > 0) && (Level > 0)))
			{
				SkillDisabled = GetSkillAvailability(Id, Level, SubLevel);
				m_Item_p[i].SetItemSkillDisabled(j, SkillDisabled);
			}
			++j;
		}
		++i;
	}
	return;
}

function HandleSkillListStart()
{
	Clear();
	return;
}

function Clear()
{
	local int i;

	i = 0;
	while((i < 13))
	{
		m_bExistSkill[i] = 0;
		m_NameBtn[i].SetTexture("l2ui_ch3.QuestWnd.QuestWndMinusBtn");
		m_Wnd[i].HideWindow();
		m_wndName[i].HideWindow();
		m_Item[i].Clear();
		m_NameStr[i].SetText("");
		i++;
	}
	i = 0;
	while((i < 9))
	{
		m_bExistSkill_p[i] = 0;
		m_NameBtn_p[i].SetTexture("l2ui_ch3.QuestWnd.QuestWndMinusBtn");
		m_wnd_p[i].HideWindow();
		m_wndName_p[i].HideWindow();
		m_Item_p[i].Clear();
		m_NameStr_p[i].SetText("");
		i++;
	}
	return;
}

function HandleSkillList(string param)
{
	local int tmp, SkillLevel, SkillSubLevel, SkillLock;
	local string strIconName, strSkillName, strDescription, strEnchantName, strCommand, strIconPanel;
	local int iCanEnchant, ReuseDelayShareGroupID, iSkillDisabled;
	local ItemInfo infItem;

	ParseItemID(param, infItem.Id);
	ParseInt(param, "Type", tmp);
	ParseInt(param, "Level", SkillLevel);
	ParseInt(param, "SubLevel", SkillSubLevel);
	ParseInt(param, "SkillLock", SkillLock);
	ParseString(param, "Name", strSkillName);
	ParseString(param, "IconName", strIconName);
	ParseString(param, "IconPanel", strIconPanel);
	ParseString(param, "Description", strDescription);
	ParseString(param, "EnchantName", strEnchantName);
	ParseString(param, "Command", strCommand);
	ParseInt(param, "CanEnchant", iCanEnchant);
	ParseInt(param, "ReuseDelayShareGroupID", ReuseDelayShareGroupID);
	ParseInt(param, "iSkillDisabled", iSkillDisabled);
	infItem.Level = SkillLevel;
	infItem.SubLevel = SkillSubLevel;
	infItem.Name = strSkillName;
	infItem.AdditionalName = strEnchantName;
	infItem.IconName = strIconName;
	infItem.IconPanel = strIconPanel;
	infItem.Description = strDescription;
	infItem.ShortcutType = 2;
	infItem.MacroCommand = strCommand;
	infItem.ReuseDelayShareGroupID = ReuseDelayShareGroupID;
	infItem.iSkillDisabled = iSkillDisabled;
	if((SkillLock > 0))
	{
		infItem.bDisabled = 1;
	}
	else
	{
		infItem.bDisabled = 0;
	}
	infItem.Reserved = iCanEnchant;
	if(Drawer.IsShowWindow())
	{
		if((iCanEnchant > 0))
		{
			infItem.bDisabled = 0;
		}
		else
		{
			infItem.bDisabled = 1;
		}
	}
	GroupingSkill(infItem.Id.ClassID, SkillLevel, SkillSubLevel, infItem);
	return;
}

function ComputeItemWndHeight()
{
	local int i, nItemNum, nItemWndHeight, nWndWidth;

	nScrollHeight = 0;
	i = 0;
	while((i < 13))
	{
		nItemNum = m_Item[i].GetItemNum();
		if((nItemNum < 1))
		{
			m_bExistSkill[i] = 0;
			m_Wnd[i].GetWindowSize(nWndWidth, nItemWndHeight);
			m_Wnd[i].SetWindowSize(nWndWidth, 0);
			i++;
			continue;
		}
		m_bExistSkill[i] = 1;
		nItemWndHeight = ((((((nItemNum - 1) / 7) + 1) * 32) + (((nItemNum - 1) / 7) * 4)) + 12);
		m_Wnd[i].SetWindowSize(260, nItemWndHeight);
		m_ItemBg[i].SetWindowSize(252, (nItemWndHeight - 8));
		m_Item[i].SetRow((((nItemNum - 1) / 7) + 2));
		if(!m_Wnd[i].IsShowWindow())
		{
			m_Wnd[i].ShowWindow();
		}
		if(!m_wndName[i].IsShowWindow())
		{
			m_wndName[i].ShowWindow();
		}
		nScrollHeight = ((((nScrollHeight + 5) + 20) + 3) + nItemWndHeight);
		i++;
	}
	if(areaScroll.IsShowWindow())
	{
		areaScroll.SetScrollHeight(nScrollHeight);
	}
	if(!areaScroll.IsShowWindow())
	{
		areaScroll.SetScrollPosition(0);
	}
	nScrollHeight_p = 0;
	i = 0;
	while((i < 9))
	{
		nItemNum = m_Item_p[i].GetItemNum();
		if((nItemNum < 1))
		{
			m_bExistSkill_p[i] = 0;
			m_wnd_p[i].GetWindowSize(nWndWidth, nItemWndHeight);
			m_wnd_p[i].SetWindowSize(nWndWidth, 0);
			i++;
			continue;
		}
		m_bExistSkill_p[i] = 1;
		nItemWndHeight = ((((((nItemNum - 1) / 7) + 1) * 32) + (((nItemNum - 1) / 7) * 4)) + 12);
		m_wnd_p[i].SetWindowSize(260, nItemWndHeight);
		m_ItemBg_p[i].SetWindowSize(252, (nItemWndHeight - 8));
		m_Item_p[i].SetRow((((nItemNum - 1) / 7) + 2));
		if(!m_wnd_p[i].IsShowWindow())
		{
			m_wnd_p[i].ShowWindow();
		}
		if(!m_wndName_p[i].IsShowWindow())
		{
			m_wndName_p[i].ShowWindow();
		}
		nScrollHeight_p = ((((nScrollHeight_p + 5) + 20) + 3) + nItemWndHeight);
		i++;
	}
	if(areaScroll_p.IsShowWindow())
	{
		areaScroll_p.SetScrollHeight(nScrollHeight_p);
	}
	if(!areaScroll_p.IsShowWindow())
	{
		areaScroll_p.SetScrollPosition(0);
	}
	return;
}

function ComputeItemWndAnchor()
{
	local int i, j, nWndWidth, nWndHeight;

	areaScroll.SetScrollPosition(0);
	if((m_bExistSkill[0] == 0))
	{
		i = 1;
		while((i < 13))
		{
			if((m_bExistSkill[i] > 0))
			{
				m_wndName[i].SetAnchor((m_Windowname $ ".ASkillScroll"), "TopLeft", "TopLeft", 5, 4);
				m_wndName[i].ClearAnchor();
				break;
			}
			i++;
		}
	}
	i = 0;
	while((i < 13))
	{
		if((m_bExistSkill[i] > 0))
		{
			j = (i + 1);
			while((j < 13))
			{
				if((m_bExistSkill[j] > 0))
				{
					if((m_bExistSkill[i] == 1))
					{
						m_Wnd[i].GetWindowSize(nWndWidth, nWndHeight);
						m_wndName[j].SetAnchor(((m_Windowname $ ".ASkill.ASkillName") $ string(i)), "BottomCenter", "TopCenter", 0, ((nWndHeight + 3) + 5));
						break;
						j++;
						continue;
					}
					if((m_bExistSkill[i] == 2))
					{
						m_wndName[j].SetAnchor(((m_Windowname $ ".ASkill.ASkillName") $ string(i)), "BottomCenter", "TopCenter", 0, 5);
						break;
					}
				}
				j++;
			}
		}
		i++;
	}
	if((m_bExistSkill_p[0] == 0))
	{
		i = 1;
		while((i < 9))
		{
			if((m_bExistSkill_p[i] > 0))
			{
				m_wndName_p[i].SetAnchor((m_Windowname $ ".PSkillScroll"), "TopLeft", "TopLeft", 5, 4);
				m_wndName_p[i].ClearAnchor();
				break;
			}
			i++;
		}
	}
	i = 0;
	while((i < 9))
	{
		if((m_bExistSkill_p[i] > 0))
		{
			j = (i + 1);
			while((j < 9))
			{
				if((m_bExistSkill_p[j] > 0))
				{
					if((m_bExistSkill_p[i] == 1))
					{
						m_wnd_p[i].GetWindowSize(nWndWidth, nWndHeight);
						m_wndName_p[j].SetAnchor(((m_Windowname $ ".PSkill.PSkillName") $ string(i)), "BottomCenter", "TopCenter", 0, ((nWndHeight + 3) + 5));
						break;
						j++;
						continue;
					}
					if((m_bExistSkill_p[i] == 2))
					{
						m_wndName_p[j].SetAnchor(((m_Windowname $ ".PSkill.PSkillName") $ string(i)), "BottomCenter", "TopCenter", 0, 5);
						break;
					}
				}
				j++;
			}
		}
		i++;
	}
	return;
}

function int getItemTypeIndex(int nItemType)
{
	local int nIndex;

	switch(nItemType)
	{
		case 0:
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		case 6:
		case 7:
			nIndex = nItemType;
			break;
		case 9:
			nIndex = 8;
			break;
		case 21:
		case 22:
		case 23:
		case 24:
		case 25:
		case 26:
		case 27:
		case 28:
		case 29:
		case 30:
		case 31:
		case 32:
			nIndex = (nItemType - 21);
			break;
		case 51:
			nIndex = 12;
			break;
		case 11:
		case 12:
		case 13:
		case 14:
		case 15:
		case 16:
		case 17:
		case 18:
			nIndex = (nItemType - 11);
			break;
		case 35:
		case 36:
		case 37:
		case 38:
		case 39:
		case 40:
			nIndex = (nItemType - 35);
			break;
		case 52:
			nIndex = 6;
			break;
		default:
			break;
	}
	return nIndex;
}

function GroupingSkill(int SkillID, int SkillLevel, int SkillSubLevel, ItemInfo infItem)
{
	local SkillInfo Info;

	if(!GetSkillInfo(SkillID, SkillLevel, SkillSubLevel, Info))
	{
		Debug("ERROR - no skill info!!");
		return;
	}
	if((Info.IconType == 8))
	{
		infItem.ShortcutType = 7;
	}
	if(isActiveSkill(Info.IconType))
	{
		if((m_NameStr[getItemTypeIndex(Info.IconType)].GetText() == ""))
		{
			m_NameStr[getItemTypeIndex(Info.IconType)].SetText(getSkillTypeString(Info.IconType));
		}
		m_Item[getItemTypeIndex(Info.IconType)].AddItem(infItem);
	}
	else
	{
		if((m_NameStr_p[getItemTypeIndex(Info.IconType)].GetText() == ""))
		{
			m_NameStr_p[getItemTypeIndex(Info.IconType)].SetText(getSkillTypeString(Info.IconType));
		}
		if((Info.IconType != 50))
		{
			m_Item_p[getItemTypeIndex(Info.IconType)].AddItem(infItem);
		}
	}
	return;
}

function bool IsHeroSkillID(int SkillID)
{
	switch(SkillID)
	{
		case 395:
		case 396:
		case 1374:
		case 1375:
		case 1376:
			return true;
		default:
			return false;
	}
}

function bool IsItemSkillID(int SkillID)
{
	switch(SkillID)
	{
		default:
			return false;
	}
}

function bool IsChangeSkillID(int SkillID)
{
	switch(SkillID)
	{
		default:
			return false;
	}
}

function OnDropItem(string a_WindowID, ItemInfo a_itemInfo, int X, int Y)
{
	local MagicSkillDrawerWnd script_a;
	local string DragSrcName;

	script_a = MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd"));
	DragSrcName = Left(a_itemInfo.DragSrcName, 10);
	switch(a_WindowID)
	{
		case "ResearchButton":
			if(getInstanceUIData().GetIsClassicServer())
			{
			}
			else if(((DragSrcName == "PSkillItem") || (DragSrcName == "ASkillItem")))
			{
				if((a_itemInfo.Reserved == 0))
				{
					RequestSkillList();
					script_a.SkillInfoClear();
					script_a.SetAdenaSpInfo();
					script_a.ResearchGuideDesc.SetText(GetSystemString(2041));
					script_a.AddSystemMessage(3070);
				}
				else
				{
					RequestExEnchantSkillInfo(a_itemInfo.Id.ClassID, a_itemInfo.Level, a_itemInfo.SubLevel);
					script_a.SetCurSkillInfo(a_itemInfo);
					script_a.txtMySp.SetText(MakeCostString(string(GetuserSP())));
					RequestSkillList();
				}
			}
			break;
		default:
			break;
	}
	return;
}

function INT64 GetuserSP()
{
	local UserInfo infoPlayer;
	local INT64 iPlayerSP;

	GetPlayerInfo(infoPlayer);
	iPlayerSP = infoPlayer.nSP;
	return iPlayerSP;
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

function updateSubjobInfo(string param, int Event_ID)
{
	local int Count, i, CurrentSubjobClassID;
	local UserInfo myUserInfo;
	local int Race;

	isDualClass = false;
	GetPlayerInfo(myUserInfo);
	ParseInt(param, "Count", Count);
	ParseInt(param, "currentSubjobClassID", CurrentSubjobClassID);
	if((subjobInfoArray.Length > 0))
	{
		subjobInfoArray.Remove(0, subjobInfoArray.Length);
	}
	ParseInt(param, "Race", Race);
	i = 0;
	while((i < Count))
	{
		subjobInfoArray.Insert(subjobInfoArray.Length, 1);
		ParseInt(param, ("SubjobClassID_" $ string(i)), subjobInfoArray[i].ClassID);
		ParseInt(param, ("SubjobID_" $ string(i)), subjobInfoArray[i].Id);
		ParseInt(param, ("SubjobLevel_" $ string(i)), subjobInfoArray[i].Level);
		ParseInt(param, ("SubjobType_" $ string(i)), subjobInfoArray[i].Type);
		if((subjobInfoArray[i].Type == 1))
		{
			isDualClass = true;
		}
		i++;
	}
	i = 0;
	while((i < Count))
	{
		if((subjobInfoArray[i].Type == 0))
		{
			mainLevel = subjobInfoArray[i].Level;
		}
		else if((subjobInfoArray[i].Type == 1))
		{
			dualLevel = subjobInfoArray[i].Level;
		}
		if((CurrentSubjobClassID == subjobInfoArray[i].ClassID))
		{
			currentType = subjobInfoArray[i].Type;
		}
		i++;
	}
	return;
}

function AddSkillTrainListItem(string param)
{
	local SkillInfo SkillInfo;
	local int Id, Level, SubLevel;
	local INT64 spConsume;
	local int requiredLevel, RequiredDualLevel;
	local UserInfo UserInfo;
	local ItemID cID;
	local string strRetName;
	local CustomTooltip t;
	local string strName, strIconName, setTreeName, panelName;
	local int currentMainLevel, currentDualLevel, _currentMainLevel, _currentDualLevel, IsNewSkill;

	ParseInt(param, "ID", Id);
	ParseInt(param, "Level", Level);
	ParseInt(param, "SubLevel", SubLevel);
	ParseINT64(param, "SpConsume", spConsume);
	ParseInt(param, "RequiredLevel", requiredLevel);
	ParseInt(param, "RequiredDualLevel", RequiredDualLevel);
	ParseInt(param, "IsNewSkill", IsNewSkill);
	cID = GetItemID(Id);
	GetSkillInfo(Id, Level, SubLevel, SkillInfo);
	GetPlayerInfo(UserInfo);
	strName = SkillInfo.SkillName;
	strIconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(cID, Level, SubLevel);
	panelName = SkillInfo.IconPanel;
	util.setCustomTooltip(t);
	util.ToopTipMinWidth(200);
	MakeSkillToolTip(strName, cID, Level, SubLevel, param);
	if((RequiredDualLevel > 0))
	{
		currentMainLevel = mainLevel;
		currentDualLevel = dualLevel;
	}
	else
	{
		currentMainLevel = UserInfo.nLevel;
		currentDualLevel = UserInfo.nLevel;
	}
	if(((requiredLevel <= currentMainLevel) && (RequiredDualLevel <= currentDualLevel)))
	{
		if((IsNewSkill == 1))
		{
			setTreeName = ((ROOTNAME $ ".") $ LIST1);
			strRetName = util.TreeInsertItemTooltipNode(treeName, ((((((("" $ string(Id)) $ ",") $ string(Level)) $ ",") $ string(newSkillIndex)) $ ",") $ string(SubLevel)), setTreeName, -7, 0, 38, 0, 30, 38, util.getCustomToolTip());
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
			if((TypeCheck(SkillInfo) == true))
			{
				util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "l2ui_ct1.SkillWnd_DF_ListIcon_Active", 32, 32, -33, (4 - 2));
				strName = makeShortStringByPixel(strName, 202, "...");
				util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, strName, 5, 5, COLOR_DEFAULT, true);
				util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, GetSystemString(88), 46, -17, COLOR_GRAY, true, true);
				util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(Level), 2, -17, COLOR_GOLD);
				util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_MP", 15, 15, 5, (-17 + 1));
				util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(SkillInfo.MpConsume), 0, -17, COLOR_GRAY);
				util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_use", 15, 15, 5, (-17 + 1));
				util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, util.MakeTimeString(SkillInfo.HitTime, SkillInfo.CoolTime), 0, -17, COLOR_GRAY);
				util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_Reuse", 15, 15, 5, (-17 + 1));
				util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, util.MakeTimeString(SkillInfo.ReuseDelay), 0, -17, COLOR_GRAY);
			}
			else
			{
				util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "l2ui_ct1.SkillWnd_DF_ListIcon_Passive", 32, 32, -33, (4 - 2));
				strName = makeShortStringByPixel(strName, 202, "...");
				util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, strName, 5, 5, COLOR_DEFAULT, true);
				util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, GetSystemString(88), 46, -17, COLOR_GRAY, true, true);
				util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(Level), 2, -17, COLOR_GOLD);
			}
		}
		else
		{
			if((RequiredDualLevel > 0))
			{
				_currentMainLevel = mainLevel;
				_currentDualLevel = dualLevel;
			}
			else
			{
				_currentMainLevel = UserInfo.nLevel;
				_currentDualLevel = UserInfo.nLevel;
			}
			if(((requiredLevel <= _currentMainLevel) && (RequiredDualLevel <= _currentDualLevel)))
			{
				setTreeName = ((ROOTNAME $ ".") $ LIST2);
				strRetName = util.TreeInsertItemTooltipNode(treeName, ((((((("" $ string(Id)) $ ",") $ string(Level)) $ ",") $ string(levelUpSkillIndex)) $ ",") $ string(SubLevel)), setTreeName, -7, 0, 38, 0, 32, 38, util.getCustomToolTip());
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
				if((TypeCheck(SkillInfo) == true))
				{
					util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "l2ui_ct1.SkillWnd_DF_ListIcon_Active", 32, 32, -34, (4 - 1));
					strName = makeShortStringByPixel(strName, 206, "...");
					util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, strName, 5, 5, COLOR_DEFAULT, true);
					util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, GetSystemString(88), 46, -17, COLOR_GRAY, true, true);
					util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(Level), 2, -17, COLOR_GOLD);
					util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_MP", 15, 15, 5, (-17 + 1));
					util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(SkillInfo.MpConsume), 0, -17, COLOR_GRAY);
					util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_use", 15, 15, 5, (-17 + 1));
					util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, util.MakeTimeString(SkillInfo.HitTime, SkillInfo.CoolTime), 0, -17, COLOR_GRAY);
					util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_Reuse", 15, 15, 5, (-17 + 1));
					util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, util.MakeTimeString(SkillInfo.ReuseDelay), 0, -17, COLOR_GRAY);
				}
				else
				{
					util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "l2ui_ct1.SkillWnd_DF_ListIcon_Passive", 32, 32, -34, (4 - 1));
					strName = makeShortStringByPixel(strName, 206, "...");
					util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, strName, 5, 5, COLOR_DEFAULT, true);
					util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, GetSystemString(88), 46, -17, COLOR_GRAY, true, true);
					util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(Level), 2, -17, COLOR_GOLD);
				}
			}
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
		strName = makeShortStringByPixel(strName, 206, "...");
		util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, strName, 5, 5, COLOR_DEFAULT, true);
		util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, (GetSystemString(2381) $ " : "), 46, -17, COLOR_GRAY, true, true);
		util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(requiredLevel), 2, -17, COLOR_RED);
	}
	return;
}

function MakeSkillToolTip(string strName, ItemID Id, int Level, int SubLevel, string param)
{
	local SkillInfo SkillInfo;
	local int SkillID, requiredLevel, RequiredDualLevel, RequiredItemTotalCnt, requiredItemID;
	local INT64 requiredItemCnt, RequiredSkillCnt;
	local int requiredSkillID, requiredSkillLevel;
	local ItemID requiredID;
	local int i, nTmp;
	local string strSkillType;

	if(!m_bShow)
	{
		return;
	}
	ParseInt(param, "ID", SkillID);
	GetSkillInfo(SkillID, Level, SubLevel, SkillInfo);
	ParseInt(param, "RequiredLevel", requiredLevel);
	ParseInt(param, "RequiredDualLevel", RequiredDualLevel);
	ParseInt(param, "RequiredItemTotalCnt", RequiredItemTotalCnt);
	ParseINT64(param, "RequiredSkillCnt", RequiredSkillCnt);
	util.ToopTipInsertText(strName, true);
	util.ToopTipInsertText((" " $ GetSystemString(88)), true, false, COLOR_GRAY);
	util.ToopTipInsertText((" " $ string(Level)), true, false, COLOR_GOLD);
	util.ToopTipInsertText(getSkillTypeString(SkillInfo.IconType), true, true, COLOR_GOLD, 0, 6);
	util.TooltipInsertItemBlank(6);
	nTmp = Class'NWindow.UIDATA_SKILL'.static.GetHpConsume(Id, Level, SubLevel);
	if((nTmp > 0))
	{
		util.TwoWordCombineColon(GetSystemString(1195), string(nTmp), COLOR_GRAY, COLOR_GOLD, true);
	}
	nTmp = Class'NWindow.UIDATA_SKILL'.static.GetMpConsume(Id, Level, SubLevel);
	if((nTmp > 0))
	{
		util.TwoWordCombineColon(GetSystemString(320), string(nTmp), COLOR_GRAY, COLOR_GOLD, true);
	}
	nTmp = Class'NWindow.UIDATA_SKILL'.static.GetCastRange(Id, Level, SubLevel);
	if((nTmp >= 0))
	{
		util.TwoWordCombineColon(GetSystemString(321), string(nTmp), COLOR_GRAY, COLOR_GOLD, true);
	}
	if((strSkillType == GetSystemString(311)))
	{
		util.TwoWordCombineColon(GetSystemString(2377), util.MakeTimeString(SkillInfo.HitTime, SkillInfo.CoolTime), COLOR_GRAY, COLOR_GOLD, true);
	}
	if((strSkillType == GetSystemString(311)))
	{
		util.TwoWordCombineColon(GetSystemString(2378), util.MakeTimeString(float(int(SkillInfo.ReuseDelay))), COLOR_GRAY, COLOR_GOLD, true);
	}
	util.ToopTipInsertText(Class'NWindow.UIDATA_SKILL'.static.GetDescription(Id, Level, SubLevel), false, true, COLOR_GRAY, 0, 6);
	util.TooltipInsertItemBlank(6);
	util.TooltipInsertItemLine();
	util.TooltipInsertItemBlank(3);
	util.ToopTipInsertText((("<" $ GetSystemString(2375)) $ ">"), true, true);
	util.TwoWordCombineColon(GetSystemString(2381), string(requiredLevel), COLOR_GRAY, COLOR_GOLD, true);
	if((RequiredDualLevel > 0))
	{
		util.TwoWordCombineColon(GetSystemString(2969), string(RequiredDualLevel), COLOR_GRAY, COLOR_GOLD, true);
	}
	if((RequiredItemTotalCnt > 0))
	{
		util.TooltipInsertItemBlank(6);
		util.ToopTipInsertText((("<" $ GetSystemString(2380)) $ ">"), true, true);
		i = 1;
		while((i <= RequiredItemTotalCnt))
		{
			ParseInt(param, ("requiredItemID" $ string(i)), requiredItemID);
			ParseINT64(param, ("requiredItemCnt" $ string(i)), requiredItemCnt);
			util.ToopTipInsertText(((Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(requiredItemID)) $ " x") $ MakeCostStringINT64(requiredItemCnt)), false, true, COLOR_GOLD);
			i++;
		}
	}
	if((RequiredSkillCnt > INT64(0)))
	{
		util.TooltipInsertItemBlank(6);
		util.ToopTipInsertText((("<" $ GetSystemString(2376)) $ ">"), true);
		i = 1;
		while((INT64(i) <= RequiredSkillCnt))
		{
			ParseInt(param, ("requiredSkillID" $ string(i)), requiredSkillID);
			ParseInt(param, ("requiredSkillLevel" $ string(i)), requiredSkillLevel);
			requiredID = GetItemID(requiredSkillID);
			util.TooltipInsertItemBlank(3);
			util.ToopTipInsertTexture(Class'NWindow.UIDATA_SKILL'.static.GetIconName(requiredID, requiredSkillLevel, 0), true, true);
			if((Class'NWindow.UIDATA_SKILL'.static.SkillIsNewOrUp(requiredID) == 0))
			{
				util.ToopTipInsertTexture("l2ui_ct1.ItemWindow_IconDisable", , , -16);
				util.ToopTipInsertText(Class'NWindow.UIDATA_SKILL'.static.GetName(requiredID, requiredSkillLevel, 0), true, false, COLOR_GRAY, 5);
				i++;
				continue;
			}
			util.ToopTipInsertText(Class'NWindow.UIDATA_SKILL'.static.GetName(requiredID, requiredSkillLevel, 0), true, false, , 5);
			i++;
		}
	}
	return;
}

function bool TypeCheck(SkillInfo Info)
{
	return isActiveSkill(Info.IconType);
}

function externalCallLearnSkill()
{
	if(IsUseRenewalSkillWnd())
	{
		_isSkillLearnNotice = true;
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("SkillWnd");
		return;
	}
	m_wndTop.ShowWindow();
	m_wndTop.SetFocus();
	GetWindowHandle("MagicSkillWnd").SetFocus();
	m_UITree.SetFocus();
	GetTabHandle("MagicSkillWnd.TabCtrl").SetTopOrder(2, false);
	OnClickButton("TabCtrl2");
	return;
}

function bool isSkillLearnTab()
{
	return (GetTabHandle("MagicSkillWnd.TabCtrl").GetTopIndex() == 2);
}

function closeTreeNode()
{
	m_UITree.SetExpandedNode(beforeTreeName, false);
	beforeTreeName = "";
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
	m_Windowname="MagicSkillWnd"
	treeName="MagicSkillWnd.SkillTrainTree"
	ROOTNAME="root"
	LIST1="SKILLLIST1"
	LIST2="SKILLLIST2"
	LIST3="SKILLLIST3"
}
