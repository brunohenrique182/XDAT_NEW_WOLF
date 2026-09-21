class ClassChangeWnd extends UICommonAPI
	dependson(UIPacket);

const CLASS_LIST_COLUMN = 3;
const CLASS_LIST_ROW = 5;
const MAX_RACE_TAB = 8;

enum EClassChangeUIState
{
	READY,                          // 0
	Select,                         // 1
	SKILL_EXTRACT,                  // 2
	Result,                         // 3
	Max                             // 4
};

enum ESkillExtractUIState
{
	READY,                          // 0
	SELECTED_OK,                    // 1
	SELECTED_NO,                    // 2
	Max                             // 3
};

struct ClassChangeRaceInfo
{
	var int RaceType;
	var string RaceName;
	var array<ChangeClassData> classInfos;
};

struct ClassChangeUIInfo
{
	var int currentClassID;
	var int currentSex;
	var int SelectedTab;
	var ChangeClassData classInfo;
	var int Sex;
	var bool skillExtract;
	var int extractCostItemId;
	var array<L2ItemAmount> extractCostList;
};

var WindowHandle Me;
var UIControlGroupButtons tabButtons;
var WindowHandle mainContainerWnd;
var WindowHandle selectContainerWnd;
var WindowHandle beforeClassWnd;
var WindowHandle afterClassWnd;
var WindowHandle afterSelectBtnWnd;
var WindowHandle selectClassWnd;
var WindowHandle skillExtractDialogWnd;
var WindowHandle noticeDialogWnd;
var WindowHandle extractNeedItemWnd;
var WindowHandle skillExtractDialogContainer;
var WindowHandle skillExtractEnableWnd;
var ButtonHandle changeBtn;
var ButtonHandle backBtn;
var ButtonHandle historyBtn;
var ButtonHandle history2Btn;
var ButtonHandle maleBtn;
var ButtonHandle femaleBtn;
var ButtonHandle skillExtractOkBtn;
var ButtonHandle skillExtractNoBtn;
var ButtonHandle skillExtractConfirmBtn;
var TextureHandle beforeClassPortraitTex;
var TextureHandle beforeClassMarkTex;
var TextureHandle afterClassPortraitTex;
var TextureHandle afterClassMarkTex;
var TextureHandle resultArrowTex;
var TextureHandle selectPortraitTex;
var TextureHandle selectClassMarkTex;
var TextureHandle maleBtnOverTex;
var TextureHandle femaleBtnOverTex;
var TextBoxHandle beforeClassNameTextBox;
var TextBoxHandle afterClassNameTextBox;
var TextBoxHandle selectClassNameTextBox;
var EffectViewportWndHandle selectBtnViewport;
var EffectViewportWndHandle selectClassBgViewport;
var EffectViewportWndHandle afterClassBgViewport;
var EffectViewportWndHandle selectCardeffectViewport;
var UIControlDialogAssets noticeDialogAsset;
var UIControlTilelist scrollTileList;
var UIControlNeedItemSelectMultiItems extractNeedMultiItemScript;
var array<ClassChangeWndSlot> rendererObjectList;
var L2UITweenTwinkleObject arrowTwinkleObject;
var L2UITweenTwinkleObject btnTwinkleObject;
var array<ClassChangeRaceInfo> _raceInfos;
var array<ChangeClassData> _totalData;
var ClassChangeUIInfo _uiInfo;
var array<int> _prevClassList;

static function ClassChangeWnd Inst()
{
	return ClassChangeWnd(GetScript("ClassChangeWnd"));
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
	local ClassChangeWndSlot slotObject;
	local WindowHandle itemRendererWnd;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	mainContainerWnd = GetWindowHandle((ownerFullPath $ ".ClassChangeMainWnd"));
	selectContainerWnd = GetWindowHandle((ownerFullPath $ ".ClassSelectWnd"));
	beforeClassWnd = GetWindowHandle((mainContainerWnd.m_WindowNameWithFullPath $ ".BeforeClassWnd"));
	afterClassWnd = GetWindowHandle((mainContainerWnd.m_WindowNameWithFullPath $ ".AfterClassWnd"));
	afterSelectBtnWnd = GetWindowHandle((mainContainerWnd.m_WindowNameWithFullPath $ ".SelectBtnWnd"));
	beforeClassPortraitTex = GetTextureHandle((beforeClassWnd.m_WindowNameWithFullPath $ ".BeforeClassPortrait_tex"));
	beforeClassMarkTex = GetTextureHandle((beforeClassWnd.m_WindowNameWithFullPath $ ".BeforeClassMark_tex"));
	beforeClassNameTextBox = GetTextBoxHandle((beforeClassWnd.m_WindowNameWithFullPath $ ".BeforeClassName_txt"));
	afterClassPortraitTex = GetTextureHandle((afterClassWnd.m_WindowNameWithFullPath $ ".AfterClassPortrait_tex"));
	afterClassMarkTex = GetTextureHandle((afterClassWnd.m_WindowNameWithFullPath $ ".AfterClassMark_tex"));
	afterClassNameTextBox = GetTextBoxHandle((afterClassWnd.m_WindowNameWithFullPath $ ".AfterClassName_txt"));
	resultArrowTex = GetTextureHandle((mainContainerWnd.m_WindowNameWithFullPath $ ".ClassChangeArrowOn_tex"));
	skillExtractEnableWnd = GetWindowHandle((mainContainerWnd.m_WindowNameWithFullPath $ ".SkillExtHighlightWnd"));
	selectClassWnd = GetWindowHandle((selectContainerWnd.m_WindowNameWithFullPath $ ".SelectClassWnd"));
	selectPortraitTex = GetTextureHandle((selectClassWnd.m_WindowNameWithFullPath $ ".SelectClassPortrait_tex"));
	selectClassMarkTex = GetTextureHandle((selectClassWnd.m_WindowNameWithFullPath $ ".SelectClassMark_tex"));
	selectClassNameTextBox = GetTextBoxHandle((selectClassWnd.m_WindowNameWithFullPath $ ".SelectClassName_txt"));
	maleBtn = GetButtonHandle((selectClassWnd.m_WindowNameWithFullPath $ ".Male_Btn"));
	femaleBtn = GetButtonHandle((selectClassWnd.m_WindowNameWithFullPath $ ".Female_Btn"));
	maleBtnOverTex = GetTextureHandle((selectClassWnd.m_WindowNameWithFullPath $ ".MaleOver_tex"));
	femaleBtnOverTex = GetTextureHandle((selectClassWnd.m_WindowNameWithFullPath $ ".FemaleOver_tex"));
	historyBtn = GetButtonHandle((mainContainerWnd.m_WindowNameWithFullPath $ ".ClassChangeHistory_Btn"));
	history2Btn = GetButtonHandle((selectContainerWnd.m_WindowNameWithFullPath $ ".ClassChangeHistory2_Btn"));
	backBtn = GetButtonHandle((mainContainerWnd.m_WindowNameWithFullPath $ ".Back_Btn"));
	changeBtn = GetButtonHandle((mainContainerWnd.m_WindowNameWithFullPath $ ".Change_Btn"));
	skillExtractDialogContainer = GetWindowHandle((ownerFullPath $ ".4starSkillPopup_DisableWnd"));
	skillExtractDialogWnd = GetWindowHandle((skillExtractDialogContainer.m_WindowNameWithFullPath $ ".4starSkillPopupWnd"));
	noticeDialogWnd = GetWindowHandle((ownerFullPath $ ".NoticePopup"));
	skillExtractOkBtn = GetButtonHandle((skillExtractDialogWnd.m_WindowNameWithFullPath $ ".4starSkillExt_Yes_Btn"));
	skillExtractNoBtn = GetButtonHandle((skillExtractDialogWnd.m_WindowNameWithFullPath $ ".4starSkillExt_No_Btn"));
	skillExtractConfirmBtn = GetButtonHandle((skillExtractDialogWnd.m_WindowNameWithFullPath $ ".4starContinue_Btn"));
	skillExtractOkBtn.SetDefaultTextDisableColor(getInstanceL2Util().BrightWhite);
	skillExtractNoBtn.SetDefaultTextDisableColor(getInstanceL2Util().BrightWhite);
	selectBtnViewport = GetEffectViewportWndHandle((mainContainerWnd.m_WindowNameWithFullPath $ ".ClassSelectBtnViewport"));
	selectClassBgViewport = GetEffectViewportWndHandle((selectContainerWnd.m_WindowNameWithFullPath $ ".SelectClassBgViewport"));
	afterClassBgViewport = GetEffectViewportWndHandle((mainContainerWnd.m_WindowNameWithFullPath $ ".AfterClassBgViewport"));
	selectCardeffectViewport = GetEffectViewportWndHandle((selectClassWnd.m_WindowNameWithFullPath $ ".selectClassEffectViewport"));
	extractNeedItemWnd = GetWindowHandle((skillExtractDialogWnd.m_WindowNameWithFullPath $ ".NeedItem_wnd"));
	extractNeedMultiItemScript = Class'InterfaceClassic.UIControlNeedItemSelectMultiItems'.static._InitScript(GetWindowHandle((extractNeedItemWnd.m_WindowNameWithFullPath $ ".NeedItemMultiItems")));
	extractNeedMultiItemScript = UIControlNeedItemSelectMultiItems(GetWindowHandle((extractNeedItemWnd.m_WindowNameWithFullPath $ ".NeedItemMultiItems")).GetScript());
	extractNeedMultiItemScript._ConnectPopup(GetWindowHandle((extractNeedItemWnd.m_WindowNameWithFullPath $ ".UIControlNeedItemSelectMultiItemPopup")));
	extractNeedMultiItemScript.DelegateSelectedItemOnClick = OnExtractNeedItemSelect;
	extractNeedMultiItemScript.DelegateOnUpdateItem = OnExtractMultiNeedItemUpdate;
	noticeDialogAsset = Class'InterfaceClassic.UIControlDialogAssets'.static.InitScript(GetWindowHandle((noticeDialogWnd.m_WindowNameWithFullPath $ ".NoticePopupAsset")));
	noticeDialogAsset.DelegateOnCancel = OnNoticeDialogCancel;
	noticeDialogAsset.DelegateOnClickBuy = OnNoticeDialogConfirm;
	noticeDialogAsset.SetUseBuyItem(false);
	noticeDialogAsset.SetUseNeedItem(false);
	noticeDialogAsset.SetUseNumberInput(false);
	noticeDialogAsset.SetDialogDesc(GetSystemString(14892));
	tabButtons = new Class'InterfaceClassic.UIControlGroupButtons';
	scrollTileList = Class'InterfaceClassic.UIControlTilelist'.static.InitScript(GetWindowHandle((selectContainerWnd.m_WindowNameWithFullPath $ ".ClassBtnScrollAreaWnd")), 3, 5, true);
	scrollTileList.DelegateOnItemRenderer = OnChangedTileListRenderer;
	scrollTileList.DelegateOnSelect = OnSelectTileList;
	rendererObjectList.Length = 0;
	i = 0;
	while((i < (3 * 5)))
	{
		itemRendererWnd = GetWindowHandle(scrollTileList._GetRendererPath(i));
		slotObject = new Class'InterfaceClassic.ClassChangeWndSlot';
		slotObject.Init(itemRendererWnd);
		rendererObjectList[rendererObjectList.Length] = slotObject;
		i++;
	}
	SetDefaultTab();
	return;
}

function UpdateList(optional bool needListReset)
{
	local array<ChangeClassData> classInfos;

	classInfos = GetSelectedClassInfos();
	scrollTileList._SetTileListItemNumTotal(classInfos.Length);
	RefreshTileList();
	return;
}

function SetTabSelected(int raceID)
{
	local int btnIndex;

	btnIndex = 0;
	while((btnIndex < tabButtons._getShowButtonNum()))
	{
		if((tabButtons._getButtonValue(btnIndex) == raceID))
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

function LoadClassChangeInfo()
{
	local array<ChangeClassData> classChangeInfos;
	local int i;
	local ChangeClassData tempInfo;
	local ClassChangeRaceInfo tempGroupInfo, defaultRaceInfo;

	_raceInfos.Length = 0;
	GetChangeClassDataAll(classChangeInfos);
	_totalData = classChangeInfos;
	i = 0;
	while((i < classChangeInfos.Length))
	{
		tempInfo = classChangeInfos[i];
		if(tempInfo.IsHide)
		{
			i++;
			continue;
		}
		if(((_raceInfos.Length == 0) || ((_raceInfos.Length > 0) && (_raceInfos[(_raceInfos.Length - 1)].RaceType != int(tempInfo.RaceType)))))
		{
			defaultRaceInfo.RaceType = int(tempInfo.RaceType);
			defaultRaceInfo.RaceName = tempInfo.RaceName;
			_raceInfos.Length = (_raceInfos.Length + 1);
			_raceInfos[(_raceInfos.Length - 1)] = defaultRaceInfo;
		}
		tempGroupInfo = _raceInfos[(_raceInfos.Length - 1)];
		tempGroupInfo.classInfos.Length = (tempGroupInfo.classInfos.Length + 1);
		tempGroupInfo.classInfos[(tempGroupInfo.classInfos.Length - 1)] = tempInfo;
		_raceInfos[(_raceInfos.Length - 1)] = tempGroupInfo;
		i++;
	}
	return;
}

function ResetInfo()
{
	local ClassChangeUIInfo defaultInfo;
	local int i;

	_uiInfo = defaultInfo;
	_raceInfos.Length = 0;
	_totalData.Length = 0;
	_prevClassList.Length = 0;
	i = 0;
	while((i < rendererObjectList.Length))
	{
		rendererObjectList[i].ResetInfo();
		i++;
	}
	return;
}

function ChangeClassData GetClassChangeInfo(int ClassID)
{
	local int i;
	local ChangeClassData defaultInfo, classInfo;

	i = 0;
	while((i < _totalData.Length))
	{
		classInfo = _totalData[i];
		if((classInfo.ClassID == ClassID))
		{
			return classInfo;
		}
		i++;
	}
	return defaultInfo;
}

function UpdateCurrentClassInfo()
{
	local UserInfo UserInfo;
	local ChangeClassData classInfo;

	GetPlayerInfo(UserInfo);
	classInfo = GetClassChangeInfo(UserInfo.nSubClass);
	_uiInfo.currentClassID = UserInfo.nSubClass;
	_uiInfo.currentSex = UserInfo.nSex;
	Debug((((("UpdateCurrentClassInfo" @ string(UserInfo.nClassID)) @ string(UserInfo.nSex)) @ string(UserInfo.Class)) @ string(UserInfo.nSubClass)));
	beforeClassNameTextBox.SetText(classInfo.ClassName);
	beforeClassMarkTex.SetTexture(GetClassMarkBigTextureName(classInfo.ClassID));
	if((UserInfo.nSex == 1))
	{
		beforeClassPortraitTex.SetTexture(classInfo.FemaleTextureName);
	}
	else
	{
		beforeClassPortraitTex.SetTexture(classInfo.MaleTextureName);
	}
	if((_prevClassList.Length == 0))
	{
		historyBtn.SetEnable(false);
		history2Btn.SetEnable(false);
	}
	else
	{
		historyBtn.SetEnable(true);
		history2Btn.SetEnable(true);
	}
	return;
}

function UpdateAfterClassInfo()
{
	if((_uiInfo.Sex == 1))
	{
		afterClassPortraitTex.SetTexture(_uiInfo.classInfo.FemaleTextureName);
	}
	else
	{
		afterClassPortraitTex.SetTexture(_uiInfo.classInfo.MaleTextureName);
	}
	afterClassMarkTex.SetTexture(GetClassMarkBigTextureName(_uiInfo.classInfo.ClassID));
	afterClassNameTextBox.SetText(_uiInfo.classInfo.ClassName);
	return;
}

function UpdateSelectInfo()
{
	selectClassNameTextBox.SetText(_uiInfo.classInfo.ClassName);
	selectClassMarkTex.SetTexture(GetClassMarkBigTextureName(_uiInfo.classInfo.ClassID));
	if((_uiInfo.Sex == 0))
	{
		selectPortraitTex.SetTexture(_uiInfo.classInfo.MaleTextureName);
	}
	else
	{
		selectPortraitTex.SetTexture(_uiInfo.classInfo.FemaleTextureName);
	}
	if((int(_uiInfo.classInfo.Sex) == 0))
	{
		maleBtn.SetDisableTexture("L2UI_NewTex.ClassChangeWnd.MaleBtn_Select");
		femaleBtn.SetDisableTexture("L2UI_NewTex.ClassChangeWnd.FemaleBtn_dis");
		maleBtn.SetEnable(false);
		femaleBtn.SetEnable(false);
		femaleBtnOverTex.HideWindow();
		maleBtnOverTex.HideWindow();
		btnTwinkleObject._Stop();
	}
	else if((int(_uiInfo.classInfo.Sex) == 1))
	{
		maleBtn.SetDisableTexture("L2UI_NewTex.ClassChangeWnd.MaleBtn_dis");
		femaleBtn.SetDisableTexture("L2UI_NewTex.ClassChangeWnd.FemaleBtn_Select");
		maleBtn.SetEnable(false);
		femaleBtn.SetEnable(false);
		femaleBtnOverTex.HideWindow();
		maleBtnOverTex.HideWindow();
		btnTwinkleObject._Stop();
	}
	else if((_uiInfo.Sex == 0))
	{
		maleBtn.SetDisableTexture("L2UI_NewTex.ClassChangeWnd.MaleBtn_Select");
		maleBtn.SetEnable(false);
		femaleBtn.SetEnable(true);
		femaleBtnOverTex.ShowWindow();
		maleBtnOverTex.HideWindow();
		btnTwinkleObject._Stop();
		btnTwinkleObject = Class'InterfaceClassic.L2UITween'.static.Inst()._AddTweenTwinlkle(femaleBtnOverTex, -1.0000000, 0.5000000, 1000.0000000, 0, 220, 0.0000000);
		btnTwinkleObject._Play();
	}
	else if((_uiInfo.Sex == 1))
	{
		femaleBtn.SetDisableTexture("L2UI_NewTex.ClassChangeWnd.FemaleBtn_Select");
		maleBtn.SetEnable(true);
		femaleBtn.SetEnable(false);
		femaleBtnOverTex.HideWindow();
		maleBtnOverTex.ShowWindow();
		btnTwinkleObject._Stop();
		btnTwinkleObject = Class'InterfaceClassic.L2UITween'.static.Inst()._AddTweenTwinlkle(maleBtnOverTex, -1.0000000, 0.5000000, 1000.0000000, 0, 220, 0.0000000);
		btnTwinkleObject._Play();
	}
	return;
}

function InitTabControls()
{
	local int i;
	local ButtonHandle tabButton;
	local TextureHandle tabTexture;
	local ClassChangeRaceInfo raceInfo;

	tabButtons._SetStartInfo("L2UI_CT1.Button.emptyBtn", "L2UI_NewTex.ClassChangeWnd.RaceSelectBtn", "L2UI_NewTex.ClassChangeWnd.RaceSelectBtn_O", false);
	i = 0;
	while((i < 8))
	{
		tabButton = GetButtonHandle(((selectContainerWnd.m_WindowNameWithFullPath $ ".RaceBtn_") $ string(i)));
		tabTexture = GetTextureHandle(((selectContainerWnd.m_WindowNameWithFullPath $ ".RaceTex_") $ string(i)));
		if((_raceInfos.Length > i))
		{
			raceInfo = _raceInfos[i];
			tabButton.ShowWindow();
			tabTexture.ShowWindow();
			tabButton.SetNameText(raceInfo.RaceName);
			tabTexture.SetTexture(GetRaceMarkTextureName(raceInfo.RaceType, false));
			tabButtons._addButtonController(tabButton);
			tabButtons._setButtonValue(i, i);
			i++;
			continue;
		}
		tabButton.HideWindow();
		tabTexture.HideWindow();
		i++;
	}
	tabButtons.DelegateOnClickButton = OnClickTabButton;
	return;
}

function UpdateTabSelectedTextures()
{
	local int i, RaceType;
	local ButtonHandle tabButton;
	local TextureHandle tabTexture;
	local L2Util util;

	util = getInstanceL2Util();
	i = 0;
	while((i < 8))
	{
		tabTexture = GetTextureHandle(((selectContainerWnd.m_WindowNameWithFullPath $ ".RaceTex_") $ string(i)));
		tabButton = GetButtonHandle(((selectContainerWnd.m_WindowNameWithFullPath $ ".RaceBtn_") $ string(i)));
		if(tabTexture.IsShowWindow())
		{
			RaceType = _raceInfos[i].RaceType;
			if((tabButtons._getSelectedButtonValue() == i))
			{
				tabButton.SetDefaultTextEnableColor(util.BrightWhite);
				tabButton.EnableWindow();
				tabTexture.SetTexture(GetRaceMarkTextureName(RaceType, true));
				i++;
				continue;
			}
			tabButton.SetDefaultTextEnableColor(util.Gold);
			tabButton.EnableWindow();
			tabTexture.SetTexture(GetRaceMarkTextureName(RaceType, false));
		}
		i++;
	}
	return;
}

function InitTweenObject()
{
	arrowTwinkleObject = Class'InterfaceClassic.L2UITween'.static.Inst()._AddTweenTwinlkle(resultArrowTex, -1.0000000, 0.5000000, 2000.0000000, 0, 150, 0.0000000);
	arrowTwinkleObject._Stop();
	return;
}

function KillTweenObject()
{
	arrowTwinkleObject._Kill();
	btnTwinkleObject._Kill();
	return;
}

function InitExtractNeedItem()
{
	local int i;
	local UIEventManager.EChangeClassExtractSkillType extractGrade;
	local ChangeClassExtractSkillData extractFeeInfo;
	local L2ItemAmount costData;

	extractGrade = EChangeClassExtractSkillType(IsChangeClassExtractSkill());
	GetChangeClassExtractSkillData(extractFeeInfo);
	if((int(extractGrade) == 0))
	{
		SetState(Select);
		return;
	}
	if((int(extractGrade) == 1))
	{
		_uiInfo.extractCostList = extractFeeInfo.ArrLegendaryFee;
	}
	else if((int(extractGrade) == 2))
	{
		_uiInfo.extractCostList = extractFeeInfo.ArrMythicFee;
	}
	extractNeedMultiItemScript._StartSelectItems(_uiInfo.extractCostList.Length);
	i = 0;
	while((i < _uiInfo.extractCostList.Length))
	{
		costData = _uiInfo.extractCostList[i];
		extractNeedMultiItemScript._AddSelectItemClassID(costData.ItemClassID, INT64(costData.ItemAmount));
		i++;
	}
	extractNeedMultiItemScript._EndSelectItems();
	return;
}

function UpdateExtractBtnState()
{
	if(extractNeedItemWnd.IsShowWindow())
	{
		if(((extractNeedMultiItemScript._GetSelectedIndexPopup() >= 0) && extractNeedMultiItemScript._GetCanBuy()))
		{
			skillExtractConfirmBtn.SetEnable(true);
		}
		else
		{
			skillExtractConfirmBtn.SetEnable(false);
		}
	}
	else if(((skillExtractOkBtn.IsEnableWindow() == true) && (skillExtractNoBtn.IsEnableWindow() == true)))
	{
		skillExtractConfirmBtn.SetEnable(false);
	}
	else
	{
		skillExtractConfirmBtn.SetEnable(true);
	}
	return;
}

function string GetRaceMarkTextureName(int raceID, bool isOn)
{
	local string TextureName;

	TextureName = ("L2UI_NewTex.ClassChangeWnd.ClassChangeRaceMark_" $ GetRaceString(raceID));
	if(isOn)
	{
		TextureName = (TextureName $ "_On");
	}
	return TextureName;
}

function string GetClassMarkBigTextureName(int ClassID)
{
	return (("L2UI_NewTex.ClassChangeWnd.ClassChangeWnd_ClassMark_" $ string(ClassID)) $ "_Big");
}

function array<ChangeClassData> GetSelectedClassInfos()
{
	local array<ChangeClassData> classInfos;

	if((_raceInfos.Length > _uiInfo.SelectedTab))
	{
		classInfos = _raceInfos[_uiInfo.SelectedTab].classInfos;
	}
	return classInfos;
}

function bool IsPrevChanged(int ClassID)
{
	local int i;

	i = 0;
	while((i < _prevClassList.Length))
	{
		if((_prevClassList[i] == ClassID))
		{
			return true;
		}
		i++;
	}
	return false;
}

function OnChangedTileListRenderer(string itemRendererID, int rendererIndex, int Position)
{
	local ClassChangeWndSlot rendererObject;
	local array<ChangeClassData> classInfos;
	local ChangeClassData classInfo;

	rendererObject = rendererObjectList[rendererIndex];
	classInfos = GetSelectedClassInfos();
	if((Position < classInfos.Length))
	{
		classInfo = classInfos[Position];
		rendererObject.SetInfo(classInfo, IsPrevChanged(classInfo.ClassID));
	}
	else
	{
		rendererObject.ResetInfo();
	}
	return;
}

function ShowNoticeDialog()
{
	noticeDialogWnd.ShowWindow();
	noticeDialogAsset.Show();
	return;
}

function HideNoticeDialog()
{
	noticeDialogWnd.HideWindow();
	noticeDialogAsset.Hide();
	return;
}

function OnSelectTileList(string itemRendererID, int rendererIndex, int itemIndex)
{
	local array<ChangeClassData> classInfos;
	local ChangeClassData selectedInfo;

	classInfos = GetSelectedClassInfos();
	if((classInfos.Length > itemIndex))
	{
		selectedInfo = classInfos[itemIndex];
		_uiInfo.classInfo = selectedInfo;
		if((int(selectedInfo.Sex) == 2))
		{
			_uiInfo.Sex = 0;
		}
		else
		{
			_uiInfo.Sex = int(selectedInfo.Sex);
		}
		_uiInfo.skillExtract = false;
		UpdateSelectInfo();
		selectCardeffectViewport.SpawnEffect("LineageEffect2.ui_screen_message_flow");
	}
	return;
}

function OnClickTabButton(string parentWindowName, string strName, int i)
{
	_uiInfo.SelectedTab = i;
	UpdateTabSelectedTextures();
	UpdateList();
	scrollTileList._SetSelect(0, true);
	OnSelectTileList("", 0, 0);
	return;
}

function OnNoticeDialogCancel()
{
	HideNoticeDialog();
	return;
}

function OnNoticeDialogConfirm()
{
	Rq_C_EX_CLASS_CHANGE(_uiInfo.classInfo.ClassID, int(_uiInfo.classInfo.RaceType), _uiInfo.Sex, int(_uiInfo.classInfo.JobGroup), _uiInfo.skillExtract, _uiInfo.extractCostItemId);
	HideNoticeDialog();
	return;
}

function OnExtractNeedItemSelect(int SelectedIndex, int selectedClassID, INT64 selectedAmount)
{
	return;
}

function OnExtractMultiNeedItemUpdate()
{
	UpdateExtractBtnState();
	return;
}

function SetSkillExtractState(ESkillExtractUIState uiState)
{
	switch(uiState)
	{
		case READY:
			_uiInfo.skillExtract = false;
			extractNeedItemWnd.HideWindow();
			skillExtractOkBtn.SetEnable(true);
			skillExtractNoBtn.SetEnable(true);
			skillExtractConfirmBtn.SetEnable(false);
			break;
		case SELECTED_OK:
			skillExtractOkBtn.SetDisableTexture("L2UI_NewTex.ClassChangeWnd.4starSkillExt_Yes");
			skillExtractOkBtn.SetEnable(false);
			skillExtractNoBtn.SetEnable(true);
			extractNeedItemWnd.ShowWindow();
			InitExtractNeedItem();
			UpdateExtractBtnState();
			_uiInfo.skillExtract = true;
			break;
		case SELECTED_NO:
			skillExtractNoBtn.SetDisableTexture("L2UI_NewTex.ClassChangeWnd.4starSkillExt_No");
			skillExtractOkBtn.SetEnable(true);
			skillExtractNoBtn.SetEnable(false);
			skillExtractConfirmBtn.SetEnable(true);
			extractNeedItemWnd.HideWindow();
			_uiInfo.skillExtract = false;
			break;
		default:
			break;
	}
	return;
}

function SetState(EClassChangeUIState uiState)
{
	switch(uiState)
	{
		case READY:
			mainContainerWnd.ShowWindow();
			selectContainerWnd.HideWindow();
			afterSelectBtnWnd.ShowWindow();
			afterClassWnd.HideWindow();
			skillExtractEnableWnd.HideWindow();
			backBtn.HideWindow();
			resultArrowTex.ShowWindow();
			changeBtn.SetEnable(false);
			skillExtractDialogContainer.HideWindow();
			HideNoticeDialog();
			selectBtnViewport.ShowWindow();
			selectBtnViewport.SpawnEffect("LineageEffect3.ui_common_light_deco");
			afterClassBgViewport.ShowWindow();
			afterClassBgViewport.SpawnEffect("LineageEffect3.ui_common_bglight");
			resultArrowTex.SetAlpha(0);
			arrowTwinkleObject._Play();
			break;
		case Select:
			mainContainerWnd.HideWindow();
			selectContainerWnd.ShowWindow();
			skillExtractDialogContainer.HideWindow();
			HideNoticeDialog();
			_uiInfo.skillExtract = false;
			_uiInfo.extractCostItemId = 0;
			arrowTwinkleObject._Stop();
			resultArrowTex.SetAlpha(255);
			selectClassBgViewport.SpawnEffect("LineageEffect3.ui_common_bglight");
			break;
		case SKILL_EXTRACT:
			mainContainerWnd.ShowWindow();
			afterSelectBtnWnd.HideWindow();
			afterClassWnd.ShowWindow();
			selectContainerWnd.HideWindow();
			skillExtractEnableWnd.HideWindow();
			_uiInfo.skillExtract = false;
			_uiInfo.extractCostItemId = 0;
			UpdateAfterClassInfo();
			skillExtractDialogContainer.ShowWindow();
			HideNoticeDialog();
			SetSkillExtractState(READY);
			selectBtnViewport.HideWindow();
			afterClassBgViewport.HideWindow();
			break;
		case Result:
			mainContainerWnd.ShowWindow();
			afterSelectBtnWnd.HideWindow();
			afterClassWnd.ShowWindow();
			selectContainerWnd.HideWindow();
			UpdateAfterClassInfo();
			skillExtractDialogContainer.HideWindow();
			backBtn.ShowWindow();
			resultArrowTex.ShowWindow();
			HideNoticeDialog();
			changeBtn.SetEnable(true);
			arrowTwinkleObject._Play();
			selectBtnViewport.HideWindow();
			afterClassBgViewport.ShowWindow();
			afterClassBgViewport.SpawnEffect("LineageEffect3.ui_common_bglight");
			if((_uiInfo.skillExtract == true))
			{
				skillExtractEnableWnd.ShowWindow();
			}
			else
			{
				skillExtractEnableWnd.HideWindow();
			}
			break;
		default:
			break;
	}
	return;
}

function int GetSelectedTabRaceId()
{
	return tabButtons._getSelectedButtonValue();
}

function array<ChangeClassData> MakeHistoryClassList()
{
	local int i;
	local array<ChangeClassData> classList;

	i = 0;
	while((i < _prevClassList.Length))
	{
		classList[classList.Length] = GetClassChangeInfo(_prevClassList[i]);
		i++;
	}
	return classList;
}

function Rq_C_EX_CLASS_CHANGE(int ClassID, int raceID, int Sex, int JobGroup, bool bExtractSkill, int extractItemId)
{
	local array<byte> stream;
	local UIPacket._C_EX_CLASS_CHANGE packet;

	packet.nClass = ClassID;
	packet.nRace = raceID;
	packet.nSex = Sex;
	packet.nJobGroup = JobGroup;
	packet.bExtractSkill = byte(bExtractSkill);
	packet.nCommissionId = extractItemId;
	Debug(((((((("Rq_C_EX_CLASS_CHANGE" @ string(IsChangeClassExtractSkill())) @ string(ClassID)) @ string(raceID)) @ string(Sex)) @ string(JobGroup)) @ string(bExtractSkill)) @ string(extractItemId)));
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_CLASS_CHANGE(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(922, stream);
	return;
}

function Nt_S_EX_CLASS_CHANGE_UI_OPEN()
{
	local UIPacket._S_EX_CLASS_CHANGE_UI_OPEN packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_CLASS_CHANGE_UI_OPEN(packet))
	{
		return;
	}
	_prevClassList = packet.prevClassList;
	LoadClassChangeInfo();
	UpdateCurrentClassInfo();
	InitTabControls();
	InitTweenObject();
	tabButtons._setTopOrder(0);
	Class'InterfaceClassic.ClassChangeHistoryWnd'.static.Inst().SetInfo(MakeHistoryClassList());
	SetState(READY);
	Me.ShowWindow();
	return;
}

function Rs_S_EX_CLASS_CHANGE_FAIL()
{
	local UIPacket._S_EX_CLASS_CHANGE_FAIL packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_CLASS_CHANGE_FAIL(packet))
	{
		return;
	}
	return;
}

function Nt_S_EX_ACQUIRE_SKILL_RESULT()
{
	local UIPacket._S_EX_ACQUIRE_SKILL_RESULT packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_ACQUIRE_SKILL_RESULT(packet))
	{
		return;
	}
	if((packet.cResult == 0))
	{
		if(Me.IsShowWindow())
		{
			Me.HideWindow();
		}
	}
	return;
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	if((a_ButtonHandle == maleBtn))
	{
		_uiInfo.Sex = 0;
		UpdateSelectInfo();
	}
	else if((a_ButtonHandle == femaleBtn))
	{
		_uiInfo.Sex = 1;
		UpdateSelectInfo();
	}
	else if((a_ButtonHandle.GetWindowName() == "Continue_Btn"))
	{
		if((_uiInfo.currentClassID == _uiInfo.classInfo.ClassID))
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(14610));
		}
		else if((IsChangeClassExtractSkill() != 0))
		{
			SetState(SKILL_EXTRACT);
		}
		else
		{
			SetState(Result);
		}
	}
	else if((a_ButtonHandle.GetWindowName() == "Select_Btn"))
	{
		SetState(Select);
	}
	else if((a_ButtonHandle.GetWindowName() == "Change_Btn"))
	{
		ShowNoticeDialog();
	}
	else if(((a_ButtonHandle.GetWindowName() == "ClassChangeHistory_Btn") || (a_ButtonHandle.GetWindowName() == "ClassChangeHistory2_Btn")))
	{
		Class'InterfaceClassic.ClassChangeHistoryWnd'.static.Inst().ToggleShow();
	}
	else if((a_ButtonHandle.GetWindowName() == "4starSkillExt_Yes_Btn"))
	{
		SetSkillExtractState(SELECTED_OK);
	}
	else if((a_ButtonHandle.GetWindowName() == "4starSkillExt_No_Btn"))
	{
		SetSkillExtractState(SELECTED_NO);
	}
	else if((a_ButtonHandle.GetWindowName() == "4starContinue_Btn"))
	{
		if((extractNeedItemWnd.IsShowWindow() && (extractNeedMultiItemScript._GetMyClassID() > 0)))
		{
			_uiInfo.extractCostItemId = extractNeedMultiItemScript._GetMyClassID();
		}
		else
		{
			_uiInfo.extractCostItemId = 0;
		}
		SetState(Result);
	}
	else if((a_ButtonHandle.GetWindowName() == "PopupClose_Btn"))
	{
		SetState(Select);
	}
	else if((a_ButtonHandle.GetWindowName() == "Back_Btn"))
	{
		SetState(Select);
	}
	else if((a_ButtonHandle.GetWindowName() == "WindowHelp_BTN"))
	{
		Class'InterfaceClassic.HelpWnd'.static.ShowHelp(71);
	}
	else
	{
		tabButtons._selectButtonHandle(a_ButtonHandle);
	}
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(1200));
	RegisterEvent(EV_PacketID(1201));
	RegisterEvent(EV_PacketID(1090));
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case EV_PacketID(1200):
			Nt_S_EX_CLASS_CHANGE_UI_OPEN();
			break;
		case EV_PacketID(1201):
			Rs_S_EX_CLASS_CHANGE_FAIL();
			break;
		case EV_PacketID(1090):
			Nt_S_EX_ACQUIRE_SKILL_RESULT();
			break;
		default:
			break;
	}
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

event OnShow()
{
	Me.SetFocus();
	return;
}

event OnHide()
{
	ResetInfo();
	Class'InterfaceClassic.ClassChangeHistoryWnd'.static.Inst().HideInfo();
	extractNeedMultiItemScript._Clear();
	KillTweenObject();
	return;
}

event OnReceivedCloseUI()
{
	if(skillExtractDialogContainer.IsShowWindow())
	{
		SetState(Select);
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		Me.HideWindow();
	}
	return;
}
