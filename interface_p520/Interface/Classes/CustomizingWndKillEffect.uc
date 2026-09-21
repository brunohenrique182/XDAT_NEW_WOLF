class CustomizingWndKillEffect extends UICommonAPI
	dependson(UIPacket);

const DIALOG_TYPE_REGIST = 0;
const DIALOG_TYPE_APPLY = 1;
const DIALOG_TYPE_RESET = 2;
const STYLETYPE = 1;
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
var EffectViewportWndHandle ObjectViewport;
var EffectViewportWndHandle BgEffectViewport;
var ButtonHandle openBtn;
var ButtonHandle applyBtn;
var ButtonHandle gotoBtn;
var ButtonHandle resetBtn;
var ButtonHandle soundOnBtn;
var ButtonHandle soundOffBtn;
var TextureHandle openBtnHighlight;
var L2UITweenTwinkleObject twinkleObject;
var TextBoxHandle TextWarning_txt_Top;
var ItemAmountDATA styleFee;
var int selectedStyleID;
var int leftStyleID;
var string KillEffect;
var int favoritesNum;
var array<int> slotInfosIndexes;
var array<SlotInfoStruct> slotInfosAll;
var int requestedRegistStyleID;
var int requestedSelectStyleID;
var FAVORITE_REQUESTED_STRUCT favoriteRequested;
var L2UITimerObject tObjectEffectPlay;

static function CustomizingWndKillEffect Inst()
{
	return CustomizingWndKillEffect(GetScript("CustomizingWnd.CustomizingWndKillEffect"));
}

function Initialize()
{
	scrollTesterV = Class'Interface.UIControlTilelistScroll'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollAreaWndV")), 3, 7, true, "itemRenderer");
	scrollTesterV.DelegateOnRenderer = HandleDelegateOnRenderer;
	scrollTesterV.DelegateOnClick = HandleDelegateOnClickV;
	scrollTesterV.DelegateOnSelect = HandleDelegateOnSelectV;
	ObjectViewport = GetEffectViewportWndHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ObjectViewportKillEffect"));
	ObjectViewport.ShowWindow();
	BgEffectViewport = GetEffectViewportWndHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".BgEffectViewport"));
	gotoBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".gotoBtn"));
	resetBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".resetBtn"));
	openBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".openBtn"));
	applyBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".applyBtn"));
	soundOffBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".soundOffBtn"));
	soundOnBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".soundOnBtn"));
	openBtnHighlight = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".openBtnHighlight"));
	openBtnHighlight.HideWindow();
	TextWarning_txt_Top = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".TextWarning_txt_Top"));
	return;
}

function InitTimer()
{
	tObject = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject(100, -1);
	tObject._DelegateOnTime = DelegateOnTime;
	tObject._Stop();
	tObjectEffectPlay = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject(2000, -1);
	tObjectEffectPlay._DelegateOnPlayStart = DelegateOnTimePlayStart;
	tObjectEffectPlay._DelegateOnTime = DelegateOnTimePlay;
	tObjectEffectPlay._Stop();
	return;
}

function DelegateOnTime(int Time)
{
	if((m_hOwnerWnd.GetAlpha() == 0))
	{
		Debug("Hide ~~~");
		m_hOwnerWnd.HideWindow();
		tObject._Stop();
	}
	else if((m_hOwnerWnd.GetAlpha() == 255))
	{
		tObject._Stop();
		BgEffectViewport.ShowWindow();
		BgEffectViewport.SpawnEffect("LineageEffect3.ui_stylewnd_flag");
	}
	return;
}

function DelegateOnTimePlayStart()
{
	ObjectViewport.SpawnEffect("");
	DelegateOnTimePlay(0);
	return;
}

function DelegateOnTimePlay(int Time)
{
	ObjectViewport.SpawnEffect(KillEffect);
	return;
}

event OnLoad()
{
	m_hOwnerWnd.m_WindowNameWithFullPath = ("CustomizingWnd." $ m_hOwnerWnd.m_WindowNameWithFullPath);
	SetClosingOnESC();
	Initialize();
	InitTimer();
	SoundON();
	ClearAllRequestDatas();
	return;
}

event OnHide()
{
	scrollTesterV._SetSelect(-1);
	tObjectEffectPlay._Stop();
	UnSetLeft();
	return;
}

event OnShow()
{
	local int Index;

	BgEffectViewport.HideWindow();
	ObjectViewport.ShowWindow();
	m_hOwnerWnd.SetFocus();
	RefreshCanApplyList();
	scrollTesterV._Refresh();
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
	}
	scrollTesterV._SetDontUseScrollTween(true);
	scrollTesterV._SetSelect(GetApplyingIndex(), true);
	scrollTesterV._SetDontUseScrollTween(false);
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
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
		case "soundOffBtn":
			SOundOff();
			break;
		case "soundOnBtn":
			SoundON();
			break;
		default:
			break;
	}
	Debug(("OnClickButton" @ strID));
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEventProtocols();
	return;
}

event OnEvent(int EventID, string a_Param)
{
	switch(EventID)
	{
		case 9750:
			SetStyleDatas();
			break;
		default:
			OnEventProtocols(EventID);
			break;
	}
	return;
}

function SoundON()
{
	ObjectViewport.SetUISound(true);
	soundOnBtn.HideWindow();
	soundOffBtn.ShowWindow();
	return;
}

function SOundOff()
{
	ObjectViewport.SetUISound(false);
	soundOnBtn.ShowWindow();
	soundOffBtn.HideWindow();
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
	tObject._Reset();
	BgEffectViewport.HideWindow();
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
	BgEffectViewport.HideWindow();
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

function SetLeft(SlotInfoStruct slotInfo)
{
	local CharacterStyleUIData o_data;
	local array<ItemInfo> iInfos;

	if((API_GetCharacterStyleData(slotInfo.StyleID, o_data) == false))
	{
		return;
	}
	openBtnHighlight.HideWindow();
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".TextWarning_txt")).HideWindow();
	leftStyleID = slotInfo.StyleID;
	KillEffect = o_data.KillEffect;
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
	resetBtn.ShowWindow();
	ObjectViewport.SpawnEffect(KillEffect);
	tObjectEffectPlay._Reset();
	TextWarning_txt_Top.HideWindow();
	if(((slotInfo.bOpened == false) && GetCanRegist(leftStyleID)))
	{
		openBtnHighlight.ShowWindow();
		openBtnHighlight.SetAlpha(0);
		openBtnHighlight.SetTexture("L2UI_NewTex.StyleWnd.StyleWndUnLockBtn_Highlight");
		twinkleObject = Class'Interface.L2UITween'.static.Inst()._AddTweenTwinlkle(openBtnHighlight, 4.5000000, 0.5000000, 400.0000000, 0, 255, 0.0000000);
	}
	else if(((slotInfo.bOpened == true) && (applyBtn.IsShowWindow() == true)))
	{
		openBtnHighlight.ShowWindow();
		openBtnHighlight.SetAlpha(0);
		openBtnHighlight.SetTexture("L2UI_NewTex.StyleWnd.StyleWndApplyBtn_Hightlight");
		TextWarning_txt_Top.ShowWindow();
		twinkleObject = Class'Interface.L2UITween'.static.Inst()._AddTweenTwinlkle(openBtnHighlight, 4.5000000, 0.5000000, 400.0000000, 0, 255, 0.0000000);
	}
	else
	{
		if((twinkleObject != none))
		{
			twinkleObject._Stop();
		}
		openBtnHighlight.HideWindow();
	}
	return;
}

function UnSetLeft()
{
	leftStyleID = -1;
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".TextWarning_txt")).ShowWindow();
	TextWarning_txt_Top.HideWindow();
	if((selectedStyleID > -1))
	{
		gotoBtn.EnableWindow();
	}
	else
	{
		gotoBtn.DisableWindow();
	}
	openBtnHighlight.HideWindow();
	openBtn.HideWindow();
	applyBtn.HideWindow();
	resetBtn.HideWindow();
	tObjectEffectPlay._Stop();
	ObjectViewport.SpawnEffect("");
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
	uicontrolDialogAssetScr.SetUseBuyItem(false);
	uicontrolDialogAssetScr.SetUseNumberInput(false);
	uicontrolDialogAssetScr._SetUseSelectItemWindow(false);
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
			uicontrolDialogAssetScr.SetItemNum(1);
			uicontrolDialogAssetScr.SetDialogDescHtml(MakeFullSystemMsg(GetSystemMessage(14631), o_data.StyleName));
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
			uicontrolDialogAssetScr.SetItemNum(1);
			uicontrolDialogAssetScr.SetNeedItemTitle_text(GetSystemString(14983));
			uicontrolDialogAssetScr.SetDialogDescHtml(MakeFullSystemMsg(GetSystemMessage(14630), o_data.StyleName));
			break;
		case 2:
			uicontrolDialogAssetScr.SetUseNeedItem(false);
			uicontrolDialogAssetScr.SetDialogDescHtml(MakeFullSystemMsg(GetSystemMessage(14632), o_data.StyleName));
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

function RefreshCanApplyList()
{
	local InventoryWnd invenScr;
	local ItemInfo currentWeaponInfo;
	local int i;

	invenScr = InventoryWnd(GetScript("InventoryWnd"));
	invenScr.m_equipItem[5].GetItem(0, currentWeaponInfo);
	slotInfosIndexes.Length = 0;
	i = 0;
	while((i < slotInfosAll.Length))
	{
		slotInfosIndexes[slotInfosIndexes.Length] = i;
		i++;
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

function HideRenderer(string rendererName)
{
	local int i;
	local array<WindowHandle> a_ChildList;

	GetWindowHandle(rendererName).GetChildWindowList(a_ChildList);
	i = 0;
	while((i < a_ChildList.Length))
	{
		a_ChildList[i].HideWindow();
		i++;
	}
	GetWindowHandle((rendererName $ ".TieListBg_tex")).ShowWindow();
	return;
}

function ShowRenderer(string rendererName)
{
	local int i;
	local array<WindowHandle> a_ChildList;

	GetWindowHandle(rendererName).GetChildWindowList(a_ChildList);
	i = 0;
	while((i < a_ChildList.Length))
	{
		a_ChildList[i].ShowWindow();
		i++;
	}
	GetWindowHandle((rendererName $ ".OverTexture")).HideWindow();
	GetWindowHandle((rendererName $ ".SelectTexture")).HideWindow();
	GetWindowHandle((rendererName $ ".TieListBg_tex")).HideWindow();
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
		GetWindowHandle((rendererName $ ".contents.tooltipBtn")).HideWindow();
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
	GetWindowHandle((rendererName $ ".contents.tooltipBtn")).ShowWindow();
	GetWindowHandle((rendererName $ ".contents.tooltipBtn")).SetTooltipCustomType(MakeTooltipSimpleText(o_data.StyleName));
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(o_data.ActiveCosts[0].ItemClassID), iInfo);
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
		if((GetCanRegist(slotInfo.StyleID) == true))
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
	Class'NWindow.UIDATA_ITEM'.static.GetCharacterStyleDataAll(1, o_DataList);
	return;
}

function bool API_GetCharacterStyleData(int a_StyleID, out CharacterStyleUIData o_data)
{
	return Class'NWindow.UIDATA_ITEM'.static.GetCharacterStyleData(1, a_StyleID, o_data);
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
	local SlotInfoStruct slotInfo;

	scrollTesterV._SetSelect(GetItemIndexByStyleID(StyleID), true);
	slotInfo = slotInfosAll[GetIndexByStyleID(StyleID)];
	if((slotInfo.bOpened == true))
	{
		return;
	}
	openBtnHighlight.ShowWindow();
	openBtnHighlight.SetAlpha(0);
	openBtnHighlight.SetTexture("L2UI_NewTex.StyleWnd.StyleWndUnLockBtn_Highlight");
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
	if((1 != packet.nStyleType))
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
	packet.nStyleType = 1;
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
	local int rendererID;

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
	slotInfosAll[GetIndexByStyleID(requestedRegistStyleID)].bOpened = true;
	RefreshByStyleID(requestedRegistStyleID);
	rendererID = scrollTesterV._GetRendererID(GetIndexByStyleID(requestedRegistStyleID));
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
	packet.nStyleType = 1;
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
	selectedStyleID = requestedSelectStyleID;
	RefreshByStyleID(selectedStyleIDBefore);
	RefreshByStyleID(selectedStyleID);
	ClearAllRequestDatas();
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
	packet.nStyleType = 1;
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
	Debug(("RT_S_EX_CHARACTER_STYLE_UPDATE_FAVORITE" @ string(packet.cResult)));
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

function ClearAllRequestDatas()
{
	requestedRegistStyleID = -2;
	requestedSelectStyleID = -2;
	favoriteRequested.StyleID = -2;
	return;
}

function SetSelectedStyleIDs(array<UIPacket._SelectStyleInfo> selectStyleList)
{
	local int i, SlotID;

	if((selectStyleList.Length == 0))
	{
		selectedStyleID = -1;
	}
	else
	{
		selectedStyleID = selectStyleList[0].nStyleID;
	}
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

	slotInfosAll.Length = 25;
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
