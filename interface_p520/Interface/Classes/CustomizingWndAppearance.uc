class CustomizingWndAppearance extends UICommonAPI
	dependson(UIPacket);

const DIALOG_TYPE_REGIST = 0;
const DIALOG_TYPE_APPLY = 1;
const DIALOG_TYPE_RESET = 2;
const STYLETYPE = 0;
const FAVORITES_MAX = 5;

struct ItemAmountDATA
{
	var int ItemClassID;
	var INT64 ItemAmount;
};

struct SlotInfoStruct
{
	var int StyleID;
	var bool bFavorites;
	var bool bOpened;
};

struct FAVORITE_REQUESTED_STRUCT
{
	var int StyleID;
	var bool onOff;
};

var L2UITimerObject tObject;
var UIControlTilelistScroll scrollTesterV;
var CharacterViewportWindowHandle ObjectViewport;
var EffectViewportWndHandle BgEffectViewport;
var ButtonHandle openBtn;
var ButtonHandle applyBtn;
var ButtonHandle gotoBtn;
var ButtonHandle resetBtn;
var TextBoxHandle textWarning_txt_Center;
var TextBoxHandle TextWarning_txt_Top;
var TextureHandle skillActivate_tex;
var TextureHandle openBtnHighlight;
var L2UITweenTwinkleObject twinkleObject;
var L2UITweenTwinkleObject twinkleObjectSkillSelected;
var ItemAmountDATA styleFee;
var int selectedStyleID;
var array<int> selectedStyleIDs;
var int leftStyleID;
var int favoritesNum;
var array<int> slotInfosIndexes;
var array<SlotInfoStruct> slotInfosAll;
var int requestedRegistStyleID;
var int requestedSelectStyleID;
var FAVORITE_REQUESTED_STRUCT favoriteRequested;
var int weaponClassID;
var int EnchantStep;
var array<int> enchantes;
var TextBoxHandle enchantNumTex;
var ButtonHandle nextBtn;
var ButtonHandle prevBtn;
var int activeSlot;

static function CustomizingWndAppearance Inst()
{
	return CustomizingWndAppearance(GetScript("CustomizingWnd.CustomizingWndAppearance"));
}

function Initialize()
{
	scrollTesterV = Class'Interface.UIControlTilelistScroll'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollAreaWndV")), 3, 7, true, "itemRenderer");
	scrollTesterV.DelegateOnRenderer = HandleDelegateOnRenderer;
	scrollTesterV.DelegateOnClick = HandleDelegateOnClickV;
	scrollTesterV.DelegateOnSelect = HandleDelegateOnSelectV;
	ObjectViewport = GetCharacterViewportWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ObjectViewportWeapon"));
	ObjectViewport.SetSpawnDuration(0.1000000);
	ObjectViewport.SetAutoCameraDistByWeapon(true);
	ObjectViewport.SetDragRotationRate(300);
	BgEffectViewport = GetEffectViewportWndHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".BgEffectViewport"));
	gotoBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".gotoBtn"));
	resetBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".resetBtn"));
	openBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".openBtn"));
	applyBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".applyBtn"));
	enchantNumTex = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ShowEnchantWnd.EnchantNumTex"));
	nextBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ShowEnchantWnd.nextBtn"));
	prevBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ShowEnchantWnd.prevBtn"));
	TextWarning_txt_Top = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".TextWarning_txt_Top"));
	textWarning_txt_Center = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".textWarning_txt_Center"));
	openBtnHighlight = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".openBtnHighlight"));
	openBtnHighlight.HideWindow();
	skillActivate_tex = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SkillWndInAppearance.SkillActivate_tex"));
	skillActivate_tex.HideWindow();
	GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SkillWndInAppearance.SkillIcon_tex")).SetDisableTex("L2UI_CT1.ItemWindow.ItemWindow_IconDisable");
	return;
}

function InitTimer()
{
	tObject = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject(100, -1);
	tObject._DelegateOnTime = DelegateOnTime;
	tObject._Stop();
	return;
}

function DelegateOnTime(int Time)
{
	if((m_hOwnerWnd.GetAlpha() == 0))
	{
		m_hOwnerWnd.HideWindow();
		skillActivate_tex.HideWindow();
		tObject._Stop();
	}
	else if((m_hOwnerWnd.GetAlpha() == 255))
	{
		ObjectViewport.ShowWindow();
		tObject._Stop();
		BgEffectViewport.ShowWindow();
		BgEffectViewport.SpawnEffect("LineageEffect3.ui_stylewnd_flag");
	}
	return;
}

event OnLoad()
{
	m_hOwnerWnd.m_WindowNameWithFullPath = ("CustomizingWnd." $ m_hOwnerWnd.m_WindowNameWithFullPath);
	SetClosingOnESC();
	Initialize();
	InitTimer();
	ClearAllRequestDatas();
	return;
}

event OnHide()
{
	scrollTesterV._SetSelect(-1);
	UnSetLeft();
	return;
}

event OnShow()
{
	local int Index;
	local ItemInfo currentWeaponInfo;

	if(getInstanceUIData().GetIsClassicServer())
	{
		ObjectViewport.SetNPCInfo(17027);
	}
	else
	{
		ObjectViewport.SetNPCInfo(19864);
	}
	ObjectViewport.SpawnNPC();
	ObjectViewport.ShowNPC(0.0010000);
	ObjectViewport.HideWindow();
	BgEffectViewport.HideWindow();
	currentWeaponInfo = GetCurrentWeaponInfo();
	weaponClassID = currentWeaponInfo.Id.ClassID;
	RefreshCanApplyList();
	if((selectedStyleID == -1))
	{
		UnSetLeft();
	}
	else
	{
		Index = GetIndexByStyleID(selectedStyleID);
		if((Index == -1))
		{
			UnSetLeft();
		}
		else
		{
			SetLeft(slotInfosAll[Index]);
		}
		scrollTesterV._SetDontUseScrollTween(true);
		scrollTesterV._SetSelect(GetApplyingIndex(), true);
		scrollTesterV._SetDontUseScrollTween(false);
	}
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "nextBtn":
			SetEnchantPlus();
			break;
		case "PrevBtn":
			SetEnchantMinus();
			break;
		case "ButtonUpdate":
			break;
		case "gotoBtn":
			SetLeftByStyleID(selectedStyleID);
			scrollTesterV._SetSelect(GetItemIndexByStyleID(selectedStyleID), true);
			break;
		case "resetBtn":
			ShowDialogAssets(2);
			break;
		case "applyBtn":
			ShowDialogAssets(1);
			break;
		case "openBtn":
			ShowDialogAssets(0);
			break;
		default:
			break;
	}
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEvent(181);
	RegisterEvent(2610);
	RegisterEvent(11590);
	RegisterEventProtocols();
	return;
}

event OnEvent(int EventID, string param)
{
	local CheckBoxHandle chkBox;
	local ItemInfo currentWeaponInfo;

	switch(EventID)
	{
		case 9750:
			SetStyleDatas();
			break;
		case 2610:
		case 181:
			if((m_hOwnerWnd.IsShowWindow() == false))
			{
				return;
			}
			if((GetWindowHandle("CustomizingWnd").IsShowWindow() == false))
			{
				return;
			}
			currentWeaponInfo = GetCurrentWeaponInfo();
			if((weaponClassID == currentWeaponInfo.Id.ClassID))
			{
				return;
			}
			weaponClassID = currentWeaponInfo.Id.ClassID;
			chkBox = GetCheckBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".canApplyCheckBox"));
			if((chkBox.IsChecked() == true))
			{
				RefreshCanApplyList();
			}
			ChkLeftApplyBtn();
			break;
		case 11590:
			Handle_EV_DualInventoryInfo(param);
			break;
		default:
			OnEventProtocols(EventID);
			break;
	}
	return;
}

event OnClickCheckBox(string CheckBoxID)
{
	RefreshCanApplyList();
	return;
}

event OnReceivedCloseUI()
{
	m_hOwnerWnd.GetParentWindowHandle().GetScript().OnReceivedCloseUI();
	return;
}

function Hide()
{
	local Rect rectWnd;
	local int locX, locY;

	rectWnd = m_hOwnerWnd.GetRect();
	Global2Local(m_hOwnerWnd.GetParentWindowHandle(), rectWnd.nX, rectWnd.nY, locX, locY);
	rectWnd = CustomizingWnd(GetScript("CustomizingWnd")).m_hOwnerWnd.GetRect();
	m_hOwnerWnd.SetAlpha(0, 0.1000000);
	m_hOwnerWnd.MoveExWithTime((25 - locX), 0, 0.1000000);
	ObjectViewport.HideWindow();
	BgEffectViewport.HideWindow();
	if((twinkleObject != none))
	{
		twinkleObject._Stop();
	}
	tObject._Reset();
	GetDialogAssets().Hide();
	return;
}

function Show()
{
	local Rect rectWnd;
	local int locX, locY;

	rectWnd = m_hOwnerWnd.GetRect();
	Global2Local(m_hOwnerWnd.GetParentWindowHandle(), rectWnd.nX, rectWnd.nY, locX, locY);
	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetAlpha(255, 0.1000000);
	m_hOwnerWnd.SetFocus();
	m_hOwnerWnd.MoveExWithTime((-locX + 7), 0, 0.1000000);
	tObject._Reset();
	return;
}

function int GetApplyingIndex()
{
	return GetItemIndexByStyleID(selectedStyleID);
}

function int GetItemIndexByStyleID(int StyleID)
{
	local int i;

	i = 0;
	while((i < slotInfosIndexes.Length))
	{
		if((GetSlotInfo(i).StyleID == StyleID))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function int GetIndexByStyleID(int StyleID)
{
	local int i;

	i = 0;
	while((i < slotInfosAll.Length))
	{
		if((slotInfosAll[i].StyleID == StyleID))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function SetLeftByStyleID(int StyleID)
{
	local int Index;

	Index = GetIndexByStyleID(StyleID);
	if((Index == -1))
	{
		UnSetLeft();
	}
	else
	{
		SetLeft(slotInfosAll[Index]);
	}
	return;
}

function ChkLeftApplyBtn()
{
	local CharacterStyleUIData o_data;

	if((leftStyleID < 0))
	{
		return;
	}
	if((API_GetCharacterStyleData(leftStyleID, o_data) == false))
	{
		return;
	}
	if(WeaponTypeCompareByClassID(GetCurrentWeaponInfo().Id.ClassID, o_data.ShiftWeaponID))
	{
		applyBtn.EnableWindow();
		TextWarning_txt_Top.HideWindow();
		if((selectedStyleID != leftStyleID))
		{
			if((openBtn.IsShowWindow() == false))
			{
				TextWarning_txt_Top.ShowWindow();
				TextWarning_txt_Top.SetText(GetSystemString(14954));
				openBtnHighlight.ShowWindow();
				openBtnHighlight.SetAlpha(0);
				openBtnHighlight.SetTexture("L2UI_NewTex.StyleWnd.StyleWndApplyBtn_Hightlight");
				twinkleObject = Class'Interface.L2UITween'.static.Inst()._AddTweenTwinlkle(openBtnHighlight, 4.5000000, 0.5000000, 400.0000000, 0, 255, 0.0000000);
			}
		}
	}
	else
	{
		applyBtn.DisableWindow();
		TextWarning_txt_Top.ShowWindow();
		TextWarning_txt_Top.SetText(GetSystemString(14950));
	}
	return;
}

function SetLeft(SlotInfoStruct slotInfo)
{
	local CharacterStyleUIData o_data;
	local ItemWindowHandle SkillIcon_tex;
	local SkillInfo sInfo;
	local ItemInfo skillItemInfo;

	leftStyleID = slotInfo.StyleID;
	skillActivate_tex.HideWindow();
	if((API_GetCharacterStyleData(leftStyleID, o_data) == false))
	{
		return;
	}
	textWarning_txt_Center.HideWindow();
	if((selectedStyleID > -1))
	{
		gotoBtn.EnableWindow();
	}
	else
	{
		gotoBtn.DisableWindow();
	}
	if((slotInfo.bOpened == true))
	{
		openBtn.HideWindow();
	}
	else
	{
		openBtn.ShowWindow();
	}
	if((leftStyleID == selectedStyleID))
	{
		applyBtn.HideWindow();
	}
	else
	{
		applyBtn.ShowWindow();
	}
	ObjectViewport.SetCurrentRotation(0);
	if(((slotInfo.bOpened == false) && GetCanRegist(leftStyleID)))
	{
		openBtnHighlight.ShowWindow();
		openBtnHighlight.SetTexture("L2UI_NewTex.StyleWnd.StyleWndUnLockBtn_Highlight");
		openBtnHighlight.SetAlpha(0);
		twinkleObject = Class'Interface.L2UITween'.static.Inst()._AddTweenTwinlkle(openBtnHighlight, 4.5000000, 0.5000000, 400.0000000, 0, 255, 0.0000000);
	}
	else if((twinkleObject != none))
	{
		twinkleObject._Stop();
		openBtnHighlight.HideWindow();
	}
	if((o_data.SkillID > 0))
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SkillWndInAppearance")).ShowWindow();
		GetSkillInfo(o_data.SkillID, 1, 0, sInfo);
		SkillIcon_tex = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SkillWndInAppearance.SkillIcon_tex"));
		SkillIcon_tex.Clear();
		skillItemInfo = getSkillToItemInfo(sInfo);
		if((leftStyleID != selectedStyleID))
		{
			skillItemInfo.bDisabled = 1;
		}
		SkillIcon_tex.AddItem(skillItemInfo);
	}
	else
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SkillWndInAppearance")).HideWindow();
	}
	if((o_data.Enchants.Length > 0))
	{
		ShowShowEnchantWnd(o_data.Enchants);
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ShowEnchantWnd")).ShowWindow();
	}
	else
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ShowEnchantWnd")).HideWindow();
		ObjectViewport.SetWeapon(o_data.ShiftWeaponID, 0, true);
	}
	resetBtn.ShowWindow();
	ChkLeftApplyBtn();
	return;
}

function ShowShowEnchantWnd(array<int> _enchantes)
{
	local ItemInfo currentWeaponInfo;

	enchantes = _enchantes;
	currentWeaponInfo = GetCurrentWeaponInfo();
	EnchantStep = GetEnchantStep(currentWeaponInfo.Enchanted);
	if((_enchantes.Length > 0))
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ShowEnchantWnd")).ShowWindow();
		SetCurrentEnchantStep();
	}
	else
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ShowEnchantWnd")).HideWindow();
	}
	return;
}

function SetCurrentEnchantStep()
{
	local ItemInfo currentWeaponInfo;
	local CharacterStyleUIData o_data;

	if((API_GetCharacterStyleData(leftStyleID, o_data) == false))
	{
		return;
	}
	if((EnchantStep <= 0))
	{
		EnchantStep = 0;
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ShowEnchantWnd.PrevBtn")).DisableWindow();
	}
	else
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ShowEnchantWnd.PrevBtn")).EnableWindow();
	}
	if((EnchantStep >= enchantes.Length))
	{
		EnchantStep = enchantes.Length;
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ShowEnchantWnd.nextBtn")).DisableWindow();
	}
	else
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ShowEnchantWnd.nextBtn")).EnableWindow();
	}
	SetWeaponWithEnchantStep();
	currentWeaponInfo = GetCurrentWeaponInfo();
	if((GetEnchantStep(currentWeaponInfo.Enchanted) == EnchantStep))
	{
		enchantNumTex.SetTextColor(getInstanceL2Util().Yellow);
	}
	else
	{
		enchantNumTex.SetTextColor(getInstanceL2Util().White);
	}
	enchantNumTex.SetText(GetEnchantString());
	return;
}

function SetWeaponWithEnchantStep()
{
	local CharacterStyleUIData o_data;

	if((API_GetCharacterStyleData(leftStyleID, o_data) == false))
	{
		return;
	}
	if((EnchantStep == 0))
	{
		ObjectViewport.SetWeapon(o_data.ShiftWeaponID, 0, true);
	}
	else
	{
		ObjectViewport.SetWeapon(o_data.ShiftWeaponID, enchantes[(EnchantStep - 1)], true);
	}
	return;
}

function SetEnchantPlus()
{
	EnchantStep++;
	SetCurrentEnchantStep();
	return;
}

function SetEnchantMinus()
{
	EnchantStep--;
	SetCurrentEnchantStep();
	return;
}

function string GetEnchantString()
{
	if((EnchantStep == 0))
	{
		return "0";
	}
	return ("+" $ string(enchantes[(EnchantStep - 1)]));
}

function int GetEnchantStep(int currentEnchanted)
{
	local int i;

	i = 0;
	while((i < enchantes.Length))
	{
		if((enchantes[i] > currentEnchanted))
		{
			return i;
		}
		i++;
	}
	return i;
}

function UnSetLeft()
{
	leftStyleID = -1;
	textWarning_txt_Center.ShowWindow();
	TextWarning_txt_Top.HideWindow();
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SkillWndInAppearance")).HideWindow();
	if((selectedStyleID > -1))
	{
		gotoBtn.EnableWindow();
	}
	else
	{
		gotoBtn.DisableWindow();
	}
	openBtn.HideWindow();
	applyBtn.HideWindow();
	resetBtn.HideWindow();
	ObjectViewport.SetWeapon(-1, 0, true);
	openBtnHighlight.HideWindow();
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ShowEnchantWnd")).HideWindow();
	return;
}

function SortFavorites()
{
	local int i, j, temp;

	i = 0;
	while((i < (slotInfosIndexes.Length - 1)))
	{
		j = 0;
		while((j < ((slotInfosIndexes.Length - i) - 1)))
		{
			if(((GetSlotInfo(j).bFavorites == false) && (GetSlotInfo((j + 1)).bFavorites == true)))
			{
				temp = slotInfosIndexes[j];
				slotInfosIndexes[j] = slotInfosIndexes[(j + 1)];
				slotInfosIndexes[(j + 1)] = temp;
			}
			j++;
		}
		i++;
	}
	return;
}

function FavoriteActive(int StyleID)
{
	local int rendererID, itemIndex, Index;

	Index = GetIndexByStyleID(StyleID);
	slotInfosAll[Index].bFavorites = true;
	itemIndex = GetItemIndexByStyleID(StyleID);
	rendererID = scrollTesterV._GetRendererID(itemIndex);
	if((rendererID > -1))
	{
		GetButtonHandle((scrollTesterV._GetRendererPath(rendererID) $ ".contents.favoriteBtn_D")).ShowWindow();
	}
	favoritesNum++;
	return;
}

function FavoriteDeActive(int StyleID)
{
	local int rendererID, itemIndex, Index;

	Index = GetIndexByStyleID(StyleID);
	slotInfosAll[Index].bFavorites = false;
	itemIndex = GetItemIndexByStyleID(StyleID);
	rendererID = scrollTesterV._GetRendererID(itemIndex);
	if((rendererID > -1))
	{
		GetButtonHandle((scrollTesterV._GetRendererPath(rendererID) $ ".contents.favoriteBtn_D")).HideWindow();
	}
	favoritesNum--;
	return;
}

function ShowDialogAssets(int dialogType)
{
	local UIControlDialogAssets uicontrolDialogAssetScr;
	local CharacterStyleUIData o_data;
	local L2ItemAmount ItemAmount;
	local int i;

	uicontrolDialogAssetScr = GetDialogAssets();
	uicontrolDialogAssetScr.SetDialogID(dialogType);
	uicontrolDialogAssetScr.DelegateOnClickBuy = HandleDialogOK;
	uicontrolDialogAssetScr.DelegateOnCancel = HandleDialogCancel;
	uicontrolDialogAssetScr._SetUseSelectItemWindow(false);
	uicontrolDialogAssetScr.SetUseBuyItem(false);
	uicontrolDialogAssetScr.SetUseNumberInput(false);
	uicontrolDialogAssetScr.SetNeedItemTitle_text(GetSystemString(637));
	if((API_GetCharacterStyleData(leftStyleID, o_data) == false))
	{
		return;
	}
	switch(dialogType)
	{
		case 1:
			uicontrolDialogAssetScr.SetUseNeedItem(true);
			uicontrolDialogAssetScr.StartNeedItemList(1);
			uicontrolDialogAssetScr.AddNeedItemClassID(styleFee.ItemClassID, styleFee.ItemAmount);
			uicontrolDialogAssetScr.SetDialogDescHtml(MakeFullSystemMsg(GetSystemMessage(14628), o_data.StyleName));
			uicontrolDialogAssetScr.SetItemNum(1);
			break;
		case 0:
			if((o_data.ActiveCosts.Length > 1))
			{
				uicontrolDialogAssetScr._SetUseSelectItemWindow(true);
				uicontrolDialogAssetScr.SetUseNeedItem(false);
				uicontrolDialogAssetScr._StartSelectItemList(o_data.ActiveCosts.Length);
				i = 0;
				while((i < o_data.ActiveCosts.Length))
				{
					uicontrolDialogAssetScr._AddSelectItemClassID(o_data.ActiveCosts[i].ItemClassID, INT64(o_data.ActiveCosts[i].ItemAmount));
					i++;
				}
			}
			else
			{
				uicontrolDialogAssetScr.SetUseNeedItem(true);
				uicontrolDialogAssetScr.StartNeedItemList(1);
				uicontrolDialogAssetScr.AddNeedItemClassID(o_data.ActiveCosts[0].ItemClassID, INT64(o_data.ActiveCosts[0].ItemAmount));
			}
			uicontrolDialogAssetScr.SetNeedItemTitle_text(GetSystemString(14983));
			if(TextWarning_txt_Top.IsShowWindow())
			{
				uicontrolDialogAssetScr.SetDialogDescHtml(((GetSystemMessage(14636) @ "<br1><br1>") $ MakeFullSystemMsg(GetSystemMessage(14627), o_data.StyleName)));
			}
			else
			{
				uicontrolDialogAssetScr.SetDialogDescHtml(MakeFullSystemMsg(GetSystemMessage(14627), o_data.StyleName));
			}
			uicontrolDialogAssetScr.SetItemNum(1);
			break;
		case 2:
			uicontrolDialogAssetScr.SetUseNeedItem(false);
			uicontrolDialogAssetScr.SetDialogDescHtml(MakeFullSystemMsg(GetSystemMessage(14629), o_data.StyleName));
			uicontrolDialogAssetScr.OKButton.EnableWindow();
			break;
		default:
			break;
	}
	uicontrolDialogAssetScr.Show();
	return;
}

function HandleDialogOK()
{
	local UIControlDialogAssets uicontrolDialogAssetScr;

	uicontrolDialogAssetScr = GetDialogAssets();
	switch(uicontrolDialogAssetScr.GetDialogID())
	{
		case 0:
			RQ_C_EX_CHARACTER_STYLE_REGIST(leftStyleID);
			break;
		case 2:
			RQ_C_EX_CHARACTER_STYLE_SELECT(-1);
			break;
		case 1:
			RQ_C_EX_CHARACTER_STYLE_SELECT(leftStyleID);
			break;
		default:
			break;
	}
	GetDialogAssets().Hide();
	return;
}

function HandleDialogCancel()
{
	GetDialogAssets().Hide();
	return;
}

function UIControlDialogAssets GetDialogAssets()
{
	return CustomizingWnd(GetScript("CustomizingWnd"))._GetDialogAssets();
}

function ItemInfo GetCurrentWeaponInfo()
{
	local ItemInfo currentWeaponInfo;
	local InventoryWnd invenScr;

	invenScr = InventoryWnd(GetScript("InventoryWnd"));
	invenScr.m_equipItem[5].GetItem(0, currentWeaponInfo);
	return currentWeaponInfo;
}

function RefreshCanApplyList()
{
	local ItemInfo iInfo, currentWeaponInfo;
	local CheckBoxHandle chkBox;
	local CharacterStyleUIData o_data;
	local int i;

	chkBox = GetCheckBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".canApplyCheckBox"));
	currentWeaponInfo = GetCurrentWeaponInfo();
	slotInfosIndexes.Length = 0;
	if(chkBox.IsChecked())
	{
		i = 0;
		while((i < slotInfosAll.Length))
		{
			if(API_GetCharacterStyleData(slotInfosAll[i].StyleID, o_data))
			{
				iInfo = GetItemInfoByClassID(o_data.ShiftWeaponID);
			}
			if(WeaponTypeCompare(iInfo, currentWeaponInfo))
			{
				slotInfosIndexes[slotInfosIndexes.Length] = i;
			}
			i++;
		}
	}
	else
	{
		i = 0;
		while((i < slotInfosAll.Length))
		{
			slotInfosIndexes[slotInfosIndexes.Length] = i;
			i++;
		}
	}
	SortFavorites();
	scrollTesterV._SetTileListLength(slotInfosIndexes.Length);
	scrollTesterV._Refresh();
	if((leftStyleID > -1))
	{
		scrollTesterV._SetSelect(GetItemIndexByStyleID(leftStyleID), true);
	}
	else if((selectedStyleID > 0))
	{
		scrollTesterV._SetSelect(GetItemIndexByStyleID(selectedStyleID), true);
	}
	else
	{
		scrollTesterV._SetSelect(-1);
	}
	return;
}

function bool WeaponTypeCompareByClassID(int classIDA, int classIDB)
{
	local ItemInfo iInfoA, iInfoB;

	iInfoA = GetItemInfoByClassID(classIDA);
	iInfoB = GetItemInfoByClassID(classIDB);
	return WeaponTypeCompare(iInfoA, iInfoB);
}

function bool WeaponTypeCompare(ItemInfo iInfoA, ItemInfo iInfoB)
{
	if((int(byte(iInfoA.WeaponType)) == 3))
	{
		iInfoA.WeaponType = 1;
	}
	if((int(byte(iInfoB.WeaponType)) == 3))
	{
		iInfoB.WeaponType = 1;
	}
	return (int(byte(iInfoA.WeaponType)) == int(byte(iInfoB.WeaponType)));
}

function RefreshByStyleID(int StyleID)
{
	local int itemIndex, rendererID;

	itemIndex = GetItemIndexByStyleID(StyleID);
	rendererID = scrollTesterV._GetRendererID(itemIndex);
	if((rendererID > -1))
	{
		scrollTesterV._RefreshRenderer(rendererID);
	}
	if((leftStyleID == StyleID))
	{
		SetLeft(slotInfosAll[GetIndexByStyleID(StyleID)]);
	}
	return;
}

function HandleDelegateOnRenderer(string rendererName, int rendererID, int itemIndex)
{
	local ItemInfo iInfo;
	local SlotInfoStruct slotInfo;
	local CharacterStyleUIData o_data;
	local array<ItemInfo> iInfos;

	if((itemIndex >= scrollTesterV._GetLength()))
	{
		GetWindowHandle((rendererName $ ".tooltipBtn")).HideWindow();
		GetWindowHandle((rendererName $ ".contents")).HideWindow();
		GetWindowHandle((rendererName $ ".TieListBg_tex")).ShowWindow();
		GetWindowHandle((rendererName $ ".OverTexture")).ClearTooltip();
		return;
	}
	GetWindowHandle((rendererName $ ".contents")).ShowWindow();
	GetWindowHandle((rendererName $ ".TieListBg_tex")).HideWindow();
	slotInfo = GetSlotInfo(itemIndex);
	if((API_GetCharacterStyleData(slotInfo.StyleID, o_data) == false))
	{
		return;
	}
	GetWindowHandle((rendererName $ ".tooltipBtn")).ShowWindow();
	GetWindowHandle((rendererName $ ".tooltipBtn")).SetTooltipCustomType(MakeTooltipSimpleText(o_data.StyleName));
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(o_data.ShiftWeaponID), iInfo);
	if((slotInfo.StyleID == selectedStyleID))
	{
		GetTextureHandle((rendererName $ ".contents.circleEffect")).ShowWindow();
	}
	else
	{
		GetTextureHandle((rendererName $ ".contents.circleEffect")).HideWindow();
	}
	GetTextureHandle((rendererName $ ".contents.itemIconTex")).SetTexture(iInfo.IconName);
	if(slotInfo.bOpened)
	{
		GetWindowHandle((rendererName $ ".contents.itemIconDisableTex")).HideWindow();
		GetTextureHandle((rendererName $ ".contents.lockTexAni_tex")).HideWindow();
		GetTextureHandle((rendererName $ ".contents.lockTex")).HideWindow();
	}
	else
	{
		GetWindowHandle((rendererName $ ".contents.itemIconDisableTex")).ShowWindow();
		if(GetCanRegist(slotInfo.StyleID))
		{
			GetTextureHandle((rendererName $ ".contents.lockTexAni_tex")).ShowWindow();
			GetTextureHandle((rendererName $ ".contents.lockTex")).ShowWindow();
		}
		else
		{
			GetTextureHandle((rendererName $ ".contents.lockTexAni_tex")).HideWindow();
			GetTextureHandle((rendererName $ ".contents.lockTex")).HideWindow();
		}
	}
	if(slotInfo.bFavorites)
	{
		GetButtonHandle((rendererName $ ".contents.favoriteBtn_D")).ShowWindow();
	}
	else
	{
		GetButtonHandle((rendererName $ ".contents.favoriteBtn_D")).HideWindow();
	}
	if((int(o_data.MarkType) > 0))
	{
		GetTextureHandle((rendererName $ ".contents.Premium_tex")).ShowWindow();
	}
	else
	{
		GetTextureHandle((rendererName $ ".contents.Premium_tex")).HideWindow();
	}
	if((o_data.SkillID > 0))
	{
		GetTextureHandle((rendererName $ ".contents.SkillIcon_texture")).ShowWindow();
	}
	else
	{
		GetTextureHandle((rendererName $ ".contents.SkillIcon_texture")).HideWindow();
	}
	if((selectedStyleIDs[0] == slotInfo.StyleID))
	{
		GetTextureHandle((rendererName $ ".contents.A_tex")).ShowWindow();
	}
	else
	{
		GetTextureHandle((rendererName $ ".contents.A_tex")).HideWindow();
	}
	if((selectedStyleIDs[1] == slotInfo.StyleID))
	{
		GetTextureHandle((rendererName $ ".contents.B_tex")).ShowWindow();
	}
	else
	{
		GetTextureHandle((rendererName $ ".contents.B_tex")).HideWindow();
	}
	return;
}

function HandleDelegateOnSelectV(string itemRendererID, int rendererIndex, int itemIndex)
{
	SetLeft(GetSlotInfo(itemIndex));
	return;
}

function HandleDelegateOnClickV(string BTNID, int rendererIndex, int itemIndex)
{
	switch(BTNID)
	{
		case "favoriteBtn_A":
			RQ_C_EX_CHARACTER_STYLE_UPDATE_FAVORITE(GetSlotInfo(itemIndex).StyleID, true);
			break;
		case "favoriteBtn_D":
			RQ_C_EX_CHARACTER_STYLE_UPDATE_FAVORITE(GetSlotInfo(itemIndex).StyleID, false);
			break;
		default:
			break;
	}
	return;
}

function SlotInfoStruct GetSlotInfo(int itemIndex)
{
	return slotInfosAll[slotInfosIndexes[itemIndex]];
}

function API_GetCharacterStyleDataAll(out array<CharacterStyleUIData> o_DataList)
{
	Class'NWindow.UIDATA_ITEM'.static.GetCharacterStyleDataAll(0, o_DataList);
	return;
}

function bool API_GetCharacterStyleData(int a_StyleID, out CharacterStyleUIData o_data)
{
	return Class'NWindow.UIDATA_ITEM'.static.GetCharacterStyleData(0, a_StyleID, o_data);
}

function RegisterEventProtocols()
{
	RegisterEvent(EV_PacketID(1206));
	RegisterEvent(EV_PacketID(1207));
	RegisterEvent(EV_PacketID(1209));
	RegisterEvent(EV_PacketID(1208));
	return;
}

function OnEventProtocols(int EventID)
{
	switch(EventID)
	{
		case EV_PacketID(1206):
			RT_S_EX_CHARACTER_STYLE_LIST();
			break;
		case EV_PacketID(1207):
			RT_S_EX_CHARACTER_STYLE_REGIST();
			break;
		case EV_PacketID(1209):
			RT_S_EX_CHARACTER_STYLE_UPDATE_FAVORITE();
			break;
		case EV_PacketID(1208):
			RT_S_EX_CHARACTER_STYLE_SELECT();
			break;
		default:
			break;
	}
	return;
}

function _SetSelectByStyleID(int StyleID)
{
	local int i, j, itemIndex;
	local CharacterStyleUIData o_data;
	local int ItemClassID;
	local array<L2ItemAmount> itemAmountsA, itemAmountsB;
	local SlotInfoStruct slotInfo;
	local ItemInfo currentWeaponInfo, iInfo;

	if((API_GetCharacterStyleData(StyleID, o_data) == false))
	{
		return;
	}
	itemAmountsA = o_data.ActiveCosts;
	currentWeaponInfo = GetCurrentWeaponInfo();
	i = 0;
	while((i < slotInfosAll.Length))
	{
		slotInfo = slotInfosAll[i];
		if((slotInfo.bOpened == true))
		{
			i++;
			continue;
		}
		if((API_GetCharacterStyleData(slotInfo.StyleID, o_data) == false))
		{
			i++;
			continue;
		}
		if((CompareItemAmount(itemAmountsA, itemAmountsB) == false))
		{
			i++;
			continue;
		}
		iInfo = GetItemInfoByClassID(o_data.ShiftWeaponID);
		if((WeaponTypeCompare(currentWeaponInfo, iInfo) == true))
		{
			if((slotInfo.bOpened == true))
			{
				i++;
				continue;
			}
			StyleID = slotInfo.StyleID;
			break;
		}
		i++;
	}
	itemIndex = GetItemIndexByStyleID(StyleID);
	scrollTesterV._SetSelect(itemIndex, true);
	if((itemIndex == -1))
	{
		SetLeft(slotInfo);
	}
	slotInfo = slotInfosAll[GetIndexByStyleID(StyleID)];
	if((slotInfo.bOpened == true))
	{
		return;
	}
	openBtnHighlight.ShowWindow();
	openBtnHighlight.SetTexture("L2UI_NewTex.StyleWnd.StyleWndUnLockBtn_Highlight");
	openBtnHighlight.SetAlpha(0);
	twinkleObject = Class'Interface.L2UITween'.static.Inst()._AddTweenTwinlkle(openBtnHighlight, 4.5000000, 0.5000000, 400.0000000, 0, 255, 0.0000000);
	return;
}

function RT_S_EX_CHARACTER_STYLE_LIST()
{
	local UIPacket._S_EX_CHARACTER_STYLE_LIST packet;
	local int i, Index;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_CHARACTER_STYLE_LIST(packet))
	{
		return;
	}
	if((0 != packet.nStyleType))
	{
		return;
	}
	styleFee.ItemClassID = packet.nChangeCostClassID;
	styleFee.ItemAmount = packet.nChangeCostAmount;
	SetSelectedStyleIDs(packet.selectStyleList);
	i = 0;
	while((i < packet.favoriteStyleIDList.Length))
	{
		Index = GetIndexByStyleID(packet.favoriteStyleIDList[i]);
		if((Index == -1))
		{
			i++;
			continue;
		}
		slotInfosAll[Index].bFavorites = true;
		i++;
	}
	i = 0;
	while((i < packet.activeStyleIDList.Length))
	{
		Index = GetIndexByStyleID(packet.activeStyleIDList[i]);
		if((Index == -1))
		{
			i++;
			continue;
		}
		slotInfosAll[Index].bOpened = true;
		i++;
	}
	SortFavorites();
	if((m_hOwnerWnd.IsShowWindow() == false))
	{
		return;
	}
	scrollTesterV._Refresh();
	return;
}

function RQ_C_EX_CHARACTER_STYLE_REGIST(int StyleID)
{
	local array<byte> stream;
	local UIPacket._C_EX_CHARACTER_STYLE_REGIST packet;

	requestedRegistStyleID = StyleID;
	packet.nStyleType = 0;
	packet.nStyleID = StyleID;
	packet.nCostItemClassID = GetDialogAssets()._GetNeedItemClassIDs()[0];
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_CHARACTER_STYLE_REGIST(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(927, stream);
	return;
}

function RT_S_EX_CHARACTER_STYLE_REGIST()
{
	local UIPacket._S_EX_CHARACTER_STYLE_REGIST packet;
	local AnimTextureHandle unLockTexAni_tex;
	local int ItemID, rendererID;

	if((requestedRegistStyleID == -2))
	{
		return;
	}
	if(!Class'Interface.UIPacket'.static.Decode_S_EX_CHARACTER_STYLE_REGIST(packet))
	{
		return;
	}
	if((packet.cResult == 0))
	{
		ClearAllRequestDatas();
		return;
	}
	ItemID = GetIndexByStyleID(requestedRegistStyleID);
	slotInfosAll[ItemID].bOpened = true;
	RefreshByStyleID(requestedRegistStyleID);
	rendererID = scrollTesterV._GetRendererID(GetItemIndexByStyleID(requestedRegistStyleID));
	if((rendererID == -1))
	{
		return;
	}
	unLockTexAni_tex = GetAnimTextureHandle((scrollTesterV._GetRendererPath(rendererID) $ ".contents.UnLockTexAni_tex"));
	unLockTexAni_tex.SetLoopCount(1);
	unLockTexAni_tex.SetCurrentFrame(1);
	unLockTexAni_tex.ShowWindow();
	unLockTexAni_tex.Play();
	ClearAllRequestDatas();
	return;
}

function RQ_C_EX_CHARACTER_STYLE_SELECT(int StyleID)
{
	local array<byte> stream;
	local UIPacket._C_EX_CHARACTER_STYLE_SELECT packet;

	requestedSelectStyleID = StyleID;
	packet.nStyleType = 0;
	packet.nStyleID = requestedSelectStyleID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_CHARACTER_STYLE_SELECT(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(928, stream);
	return;
}

function RT_S_EX_CHARACTER_STYLE_SELECT()
{
	local int selectedStyleIDBefore;
	local UIPacket._S_EX_CHARACTER_STYLE_SELECT packet;

	if((requestedSelectStyleID == -2))
	{
		return;
	}
	if(!Class'Interface.UIPacket'.static.Decode_S_EX_CHARACTER_STYLE_SELECT(packet))
	{
		return;
	}
	if((packet.cResult == 0))
	{
		ClearAllRequestDatas();
		return;
	}
	selectedStyleIDBefore = selectedStyleID;
	selectedStyleIDs[activeSlot] = requestedSelectStyleID;
	selectedStyleID = requestedSelectStyleID;
	RefreshByStyleID(selectedStyleIDBefore);
	RefreshByStyleID(selectedStyleID);
	ClearAllRequestDatas();
	if((selectedStyleID == -1))
	{
		return;
	}
	skillActivate_tex.ShowWindow();
	skillActivate_tex.SetAlpha(0);
	twinkleObjectSkillSelected = Class'Interface.L2UITween'.static.Inst()._AddTweenTwinlkle(skillActivate_tex, 1.5000000, 0.5000000, 800.0000000, 0, 255, 0.0000000);
	return;
}

function RQ_C_EX_CHARACTER_STYLE_UPDATE_FAVORITE(int StyleID, bool onOff)
{
	local array<byte> stream;
	local UIPacket._C_EX_CHARACTER_STYLE_UPDATE_FAVORITE packet;

	if(((onOff == true) && (favoritesNum >= 5)))
	{
		AddSystemMessage(13194);
		return;
	}
	favoriteRequested.onOff = onOff;
	favoriteRequested.StyleID = StyleID;
	packet.nStyleType = 0;
	packet.nStyleID = StyleID;
	if(onOff)
	{
		packet.bOn = 1;
	}
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_CHARACTER_STYLE_UPDATE_FAVORITE(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(929, stream);
	return;
}

function RT_S_EX_CHARACTER_STYLE_UPDATE_FAVORITE()
{
	local UIPacket._S_EX_CHARACTER_STYLE_UPDATE_FAVORITE packet;

	if((favoriteRequested.StyleID == -2))
	{
		return;
	}
	if(!Class'Interface.UIPacket'.static.Decode_S_EX_CHARACTER_STYLE_UPDATE_FAVORITE(packet))
	{
		return;
	}
	if((packet.cResult == 0))
	{
		ClearAllRequestDatas();
		return;
	}
	slotInfosAll[GetIndexByStyleID(favoriteRequested.StyleID)].bFavorites = favoriteRequested.onOff;
	if(favoriteRequested.onOff)
	{
		FavoriteActive(favoriteRequested.StyleID);
	}
	else
	{
		FavoriteDeActive(favoriteRequested.StyleID);
	}
	ClearAllRequestDatas();
	return;
}

function SetStyleDatas()
{
	local int i;
	local array<CharacterStyleUIData> o_DataList;

	slotInfosAll.Length = 0;
	API_GetCharacterStyleDataAll(o_DataList);
	slotInfosAll.Length = o_DataList.Length;
	i = 0;
	while((i < o_DataList.Length))
	{
		slotInfosAll[i].StyleID = o_DataList[i].StyleID;
		i++;
	}
	return;
}

function ClearSelectedStyleIDs()
{
	selectedStyleIDs.Length = 2;
	selectedStyleIDs[0] = -1;
	selectedStyleIDs[1] = -1;
	return;
}

function ClearAllRequestDatas()
{
	requestedRegistStyleID = -2;
	requestedSelectStyleID = -2;
	favoriteRequested.StyleID = -2;
	return;
}

function Handle_EV_DualInventoryInfo(string param)
{
	local TextBoxHandle ABSet_txt;

	ParseInt(param, "cActiveSlot", activeSlot);
	ABSet_txt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ABSet_Wnd.ABSet_txt"));
	switch(activeSlot)
	{
		case 0:
			ABSet_txt.SetText(GetSystemString(14274));
			ABSet_txt.SetTextColor(GetColor(90, 176, 178, 255));
			break;
		case 1:
			ABSet_txt.SetText(GetSystemString(14275));
			ABSet_txt.SetTextColor(GetColor(238, 170, 255, 255));
			break;
		default:
			break;
	}
	selectedStyleID = selectedStyleIDs[activeSlot];
	if((selectedStyleIDs.Length == 0))
	{
		ClearSelectedStyleIDs();
	}
	RefreshByStyleID(selectedStyleIDs[0]);
	RefreshByStyleID(selectedStyleIDs[1]);
	return;
}

function SetSelectedStyleIDs(array<UIPacket._SelectStyleInfo> selectStyleList)
{
	local int i, SlotID;

	ClearSelectedStyleIDs();
	i = 0;
	while((i < selectStyleList.Length))
	{
		SlotID = selectStyleList[i].nOption;
		selectedStyleIDs[SlotID] = selectStyleList[i].nStyleID;
		i++;
	}
	selectedStyleID = selectedStyleIDs[activeSlot];
	return;
}

function bool CompareItemAmount(array<L2ItemAmount> itemAmountsA, array<L2ItemAmount> itemAmountsB)
{
	local int i, j;

	i = 0;
	while((i < itemAmountsA.Length))
	{
		j = 0;
		while((j < itemAmountsB.Length))
		{
			if((itemAmountsA[i].ItemClassID == itemAmountsB[j].ItemClassID))
			{
				return true;
			}
			j++;
		}
		i++;
	}
	return false;
}

function bool GetCanRegist(int StyleID)
{
	local int i;
	local array<ItemInfo> iInfos;
	local CharacterStyleUIData o_data;

	if((API_GetCharacterStyleData(StyleID, o_data) == false))
	{
		return false;
	}
	i = 0;
	while((i < o_data.ActiveCosts.Length))
	{
		if((Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(o_data.ActiveCosts[i].ItemClassID, iInfos) == 0))
		{
			i++;
			continue;
		}
		if((iInfos[0].ItemNum >= INT64(o_data.ActiveCosts[i].ItemAmount)))
		{
			return true;
		}
		i++;
	}
	return false;
}

function TEstInfos()
{
	local int i, ClassID;
	local ItemInfo iInfo;

	slotInfosAll.Length = 100;
	if((Rand(2) == 1))
	{
		selectedStyleID = (Rand(100) - 1);
	}
	i = 0;
	while((i < slotInfosAll.Length))
	{
		iInfo = GetItemInfoByClassID(++ClassID);
		while(((iInfo.SlotBitType != INT64(128)) && (iInfo.SlotBitType != INT64(16384))))
		{
			iInfo = GetItemInfoByClassID(++ClassID);
		}
		slotInfosAll[i].StyleID = i;
		if(((Rand(20) == 1) && (favoritesNum < 5)))
		{
			slotInfosAll[i].bFavorites = true;
			favoritesNum++;
		}
		slotInfosAll[i].bOpened = ((Rand(3) == 0) || (i == selectedStyleID));
		i++;
	}
	if((selectedStyleID > -1))
	{
		gotoBtn.EnableWindow();
	}
	else
	{
		gotoBtn.DisableWindow();
	}
	return;
}
