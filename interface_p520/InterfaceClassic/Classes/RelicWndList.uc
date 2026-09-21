class RelicWndList extends UICommonAPI;

const RELIC_LIST_COLUMN = 4;
const RELIC_LIST_ROW = 4;

var array<RelicWnd.RelicInfo> _relicInfos;
var RelicWnd.RelicUIInfo _uiInfo;
var WindowHandle Me;
var WindowHandle listEmptyContainer;
var WindowHandle disableWnd;
var TextBoxHandle listEmptyTextBox;
var TextBoxHandle listTitleTextBox;
var TextureHandle listTitleBGTex;
var UIControlTilelist scrollTileList;
var UIControlGroupButtons tabButtons;
var array<RelicWndSlot> rendererObjectList;
//var delegate<OnRelicListSort> __OnRelicListSort__Delegate;

static function RelicWndList Inst()
{
	return RelicWndList(GetScript("RelicWnd.RelicWndList"));
}

function Initialize()
{
	InitControls();
	return;
}

function InitControls()
{
	local int i;
	local string ownerFullPath;
	local RelicWndSlot slotObject;
	local WindowHandle itemRendererWnd;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	listEmptyContainer = GetWindowHandle((ownerFullPath $ ".ListEmptyWnd"));
	listEmptyTextBox = GetTextBoxHandle((listEmptyContainer.m_WindowNameWithFullPath $ ".ListEmpty_txt"));
	listTitleBGTex = GetTextureHandle((ownerFullPath $ ".RelicMainListHeader_tex"));
	listTitleTextBox = GetTextBoxHandle((ownerFullPath $ ".MenuTitle_txt"));
	disableWnd = GetWindowHandle((ownerFullPath $ ".ListDisableWnd"));
	tabButtons = new Class'InterfaceClassic.UIControlGroupButtons';
	tabButtons._SetStartInfo("L2UI_CT1.Button.emptyBtn", "L2UI_NewTex.RelicWnd.RelicListBtn_Select", "L2UI_NewTex.RelicWnd.RelicListBtn_O", false);
	tabButtons._addButtonController(GetButtonHandle((ownerFullPath $ ".SideAll_Btn")));
	tabButtons._addButtonController(GetButtonHandle((ownerFullPath $ ".SideR_Btn")));
	tabButtons._addButtonController(GetButtonHandle((ownerFullPath $ ".SideS_Btn")));
	tabButtons._addButtonController(GetButtonHandle((ownerFullPath $ ".SideA_Btn")));
	tabButtons._addButtonController(GetButtonHandle((ownerFullPath $ ".SideB_Btn")));
	tabButtons._addButtonController(GetButtonHandle((ownerFullPath $ ".SideC_Btn")));
	tabButtons._addButtonController(GetButtonHandle((ownerFullPath $ ".SideD_Btn")));
	tabButtons._addButtonController(GetButtonHandle((ownerFullPath $ ".SideN_Btn")));
	tabButtons._setButtonValue(0, 0);
	tabButtons._setButtonValue(1, 7);
	tabButtons._setButtonValue(2, 6);
	tabButtons._setButtonValue(3, 5);
	tabButtons._setButtonValue(4, 4);
	tabButtons._setButtonValue(5, 3);
	tabButtons._setButtonValue(6, 2);
	tabButtons._setButtonValue(7, 1);
	tabButtons.DelegateOnClickButton = OnClickTabButton;
	scrollTileList = Class'InterfaceClassic.UIControlTilelist'.static.InitScript(GetWindowHandle((ownerFullPath $ ".RelicSlotList_Wnd")), 4, 4, true);
	scrollTileList.DelegateOnItemRenderer = OnChangedTileListRenderer;
	scrollTileList.DelegateOnClick = OnClickTileList;
	scrollTileList.DelegateOnSelect = OnSelectTileList;
	rendererObjectList.Length = 0;
	i = 0;
	while((i < (4 * 4)))
	{
		itemRendererWnd = GetWindowHandle(scrollTileList._GetRendererPath(i));
		slotObject = new Class'InterfaceClassic.RelicWndSlot';
		slotObject.Init(itemRendererWnd);
		rendererObjectList[rendererObjectList.Length] = slotObject;
		i++;
	}
	Class'InterfaceClassic.RelicWnd'.static.Inst().DelegateChangeRelicList = OnChangeRelicList;
	Class'InterfaceClassic.RelicWnd'.static.Inst().DelegateChangeCombineStuffList = OnChangeCombineStuffList;
	Class'InterfaceClassic.RelicWnd'.static.Inst().DelegateChangeUpgradeStuffList = OnChangeUpgradeStuffList;
	hideDisableWnd();
	SetDefaultTab();
	return;
}

function UpdateList(optional bool needListReset)
{
	local int oldListNum;

	oldListNum = _relicInfos.Length;
	_relicInfos = Class'InterfaceClassic.RelicWnd'.static.Inst().GetRelicInfos();
	_uiInfo = Class'InterfaceClassic.RelicWnd'.static.Inst().GetRelicUIInfo();
	UpdateRelicInfos();
	if(((needListReset == true) || (oldListNum != _relicInfos.Length)))
	{
		scrollTileList._SetTileListItemNumTotal(_relicInfos.Length);
	}
	RefreshTileList();
	if((_relicInfos.Length == 0))
	{
		if(((int(_uiInfo.uiState) == 2) && (int(GetSelectedTabGrade()) == GetRelicsUncombinableGrade())))
		{
			listEmptyTextBox.SetText(GetSystemString(14561));
		}
		else
		{
			listEmptyTextBox.SetText(GetSystemString(13512));
		}
		listEmptyContainer.ShowWindow();
	}
	else
	{
		listEmptyContainer.HideWindow();
	}
	if((int(_uiInfo.uiState) == 3))
	{
		if((Class'InterfaceClassic.RelicWnd'.static.Inst().GetUpgradeInfo().targetRelicId != 0))
		{
			listTitleTextBox.SetText(GetSystemString(14495));
		}
		else
		{
			listTitleTextBox.SetText(GetSystemString(14500));
		}
		listTitleBGTex.SetTexture("L2UI_NewTex.RelicWnd.RelicHeader_Upgrade");
	}
	else if((int(_uiInfo.uiState) == 2))
	{
		listTitleTextBox.SetText(GetSystemString(14496));
		listTitleBGTex.SetTexture("L2UI_NewTex.RelicWnd.RelicHeader_Combine");
		Class'InterfaceClassic.RelicWndCombine'.static.Inst().SetFailPoints();
	}
	else
	{
		listTitleTextBox.SetText(GetSystemString(14494));
		listTitleBGTex.SetTexture("L2UI_NewTex.RelicWnd.RelicHeader_List");
	}
	return;
}

function SetTabSelected(UIConstants.ERelicGrade Grade)
{
	local int btnIndex;

	btnIndex = 0;
	while((btnIndex < tabButtons._getShowButtonNum()))
	{
		if((int(byte(tabButtons._getButtonValue(btnIndex))) == int(Grade)))
		{
			tabButtons._setTopOrder(btnIndex);
			return;
		}
		btnIndex++;
	}
	return;
}

function RefreshTileList()
{
	scrollTileList._Refresh();
	return;
}

function SetSelected(int Index, optional bool forceToSelect)
{
	scrollTileList._SetSelect(Index, forceToSelect);
	return;
}

function SetUseSelect(bool Use)
{
	scrollTileList._SetUseSelect(Use);
	return;
}

function SetDefaultTab()
{
	tabButtons._setTopOrder(0);
	return;
}

function ResetInfo()
{
	local int i;

	_relicInfos.Length = 0;
	i = 0;
	while((i < rendererObjectList.Length))
	{
		rendererObjectList[i].ResetInfo();
		i++;
	}
	return;
}

function OnChangedTileListRenderer(string itemRendererID, int rendererIndex, int Position)
{
	local RelicWndSlot rendererObject;

	rendererObject = rendererObjectList[rendererIndex];
	if((Position < _relicInfos.Length))
	{
		rendererObject.SetInfo(_relicInfos[Position]);
	}
	else
	{
		rendererObject.ResetInfo();
	}
	return;
}

function SetDefaultInfo()
{
	if((_relicInfos.Length > 0))
	{
		Class'InterfaceClassic.RelicWnd'.static.Inst().OnSelectTileList(_relicInfos[0]);
	}
	return;
}

function OnClickTileList(string BTNID, int rendererIndex, int itemIndex)
{
	if((itemIndex < _relicInfos.Length))
	{
		Class'InterfaceClassic.RelicWnd'.static.Inst().OnClickTileList(_relicInfos[itemIndex]);
	}
	return;
}

function OnSelectTileList(string itemRendererID, int rendererIndex, int itemIndex)
{
	if((itemIndex < _relicInfos.Length))
	{
		Class'InterfaceClassic.RelicWnd'.static.Inst().OnSelectTileList(_relicInfos[itemIndex]);
	}
	return;
}

function OnChangeRelicList()
{
	if(Class'InterfaceClassic.RelicWnd'.static.Inst().IsOpenWindow())
	{
		UpdateList();
	}
	return;
}

function OnChangeCombineStuffList()
{
	if(Class'InterfaceClassic.RelicWnd'.static.Inst().IsOpenWindow())
	{
		UpdateList();
	}
	return;
}

function OnChangeUpgradeStuffList()
{
	if(Class'InterfaceClassic.RelicWnd'.static.Inst().IsOpenWindow())
	{
		UpdateList();
	}
	return;
}

function OnClickTabButton(string parentWindowName, string strName, int i)
{
	if((int(_uiInfo.uiState) == 0))
	{
		UpdateList();
		SetSelected(0, true);
		OnSelectTileList("", 0, 0);
	}
	else
	{
		UpdateList();
	}
	return;
}

function UpdateRelicInfos()
{
	local array<RelicWnd.RelicInfo> tempRelicInfos;
	local RelicWnd.RelicInfo tmpRelicInfo;
	local UIConstants.ERelicGrade selectedGrade;
	local RelicWnd.RelicUpgradeInfo upgradeInfo;
	local bool isStuffMode;
	local int i, uncombineGrade;

	uncombineGrade = GetRelicsUncombinableGrade();
	upgradeInfo = Class'InterfaceClassic.RelicWnd'.static.Inst().GetUpgradeInfo();
	if(((int(_uiInfo.uiState) == 2) || ((int(_uiInfo.uiState) == 3) && (upgradeInfo.targetRelicId != 0))))
	{
		isStuffMode = true;
	}
	selectedGrade = GetSelectedTabGrade();
	i = 0;
	while((i < _relicInfos.Length))
	{
		tmpRelicInfo = _relicInfos[i];
		if((int(selectedGrade) != 0))
		{
			if((tmpRelicInfo.Data.Grade != int(selectedGrade)))
			{
				i++;
				continue;
			}
		}
		if(((int(_uiInfo.uiState) == 2) && (tmpRelicInfo.Data.Grade == uncombineGrade)))
		{
			i++;
			continue;
		}
		if(((int(_uiInfo.uiState) == 3) && (tmpRelicInfo.isEnabled == false)))
		{
			i++;
			continue;
		}
		if(((int(_uiInfo.uiState) == 3) && (tmpRelicInfo.Data.Skills.Length <= 1)))
		{
			i++;
			continue;
		}
		if((int(_uiInfo.uiState) != 0))
		{
			tmpRelicInfo.IsActive = false;
			tmpRelicInfo.IsNew = false;
		}
		if((isStuffMode == true))
		{
			if((tmpRelicInfo.Count <= INT64(0)))
			{
				i++;
				continue;
			}
			if((int(_uiInfo.uiState) == 2))
			{
				tmpRelicInfo.Count = (tmpRelicInfo.Count - INT64(Class'InterfaceClassic.RelicWnd'.static.Inst().GetRegisteredCombineStuffCount(tmpRelicInfo.relicId)));
			}
			else
			{
				tmpRelicInfo.Count = (tmpRelicInfo.Count - INT64(Class'InterfaceClassic.RelicWnd'.static.Inst().GetRegisteredUpgradeStuffCount(tmpRelicInfo.relicId)));
			}
			if((tmpRelicInfo.Count <= INT64(0)))
			{
				tmpRelicInfo.isStuffDisable = true;
			}
			else
			{
				tmpRelicInfo.isStuffDisable = false;
			}
		}
		tempRelicInfos[tempRelicInfos.Length] = tmpRelicInfo;
		i++;
	}
	// tempRelicInfos.Sort(OnRelicListSort);   // array.Sort() unsupported by this compiler
	_relicInfos = tempRelicInfos;
	return;
}

function ShowDisableWnd()
{
	disableWnd.ShowWindow();
	return;
}

function hideDisableWnd()
{
	disableWnd.HideWindow();
	return;
}

function UIConstants.ERelicGrade GetSelectedTabGrade()
{
	return ERelicGrade(tabButtons._getSelectedButtonValue());
}

delegate int OnRelicListSort(RelicWnd.RelicInfo A, RelicWnd.RelicInfo B)
{
	if((A.IsActive != B.IsActive))
	{
		if(((A.IsActive == true) && (B.IsActive == false)))
		{
			return 0;
		}
		else
		{
			return -1;
		}
	}
	if((A.isEnabled != B.isEnabled))
	{
		if(((A.isEnabled == true) && (B.isEnabled == false)))
		{
			return 0;
		}
		else
		{
			return -1;
		}
	}
	if((A.Data.Grade != B.Data.Grade))
	{
		if((A.Data.Grade > B.Data.Grade))
		{
			return 0;
		}
		else
		{
			return -1;
		}
	}
	if((A.Data.SortOrder != B.Data.SortOrder))
	{
		if((A.Data.SortOrder < B.Data.SortOrder))
		{
			return 0;
		}
		else
		{
			return -1;
		}
	}
	if((A.relicId < B.relicId))
	{
		return 0;
	}
	else
	{
		return -1;
	}
	return 0;
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	tabButtons._selectButtonHandle(a_ButtonHandle);
	return;
}

event OnLoad()
{
	Initialize();
	return;
}
