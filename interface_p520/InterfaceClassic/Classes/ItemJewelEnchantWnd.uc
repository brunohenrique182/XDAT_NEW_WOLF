class ItemJewelEnchantWnd extends UICommonAPI
	dependson(UIPacket);

const C_ANIMLOOPCOUNT = 1;
const TIMER_DELAY = 1000;
const TIMER_DELAY_SKIP = 150;
const TIMER_DELAY_AUTO = 100;
const TIMER_DELAY_AUTOEffect2 = 700;
const DLG_ID_CRASH_ALERT = 1;
const ITEMINVENTORY_COLNUM = 12;
const ITEM_ID_MOVE_TWEEN0 = 0;
const ITEM_ID_MOVE_TWEEN1 = 1;
const ITEM_ID_MOVE_TWEENEND = 2;
const STATE_BEGIN = 'stateBegin';
const STATE_READY = 'stateReady';
const STATE_ONEREADY = 'stateOneReady';
const STATE_ALLREADY = 'stateAllReady';
const STATE_PROCESS = 'stateProcess';
const STATE_RESULT = 'stateResult';
const STATE_AUTORESULT = 'stateAutoResult';

enum EnchantType
{
	Normal,                         // 0
	dye                             // 1
};

enum ResultType
{
	result_fail,                    // 0
	result_fail_noItem,             // 1
	result_Success,                 // 2
	result_only                     // 3
};

enum AUTOPROCESS_STEP_TYPE
{
	non,                            // 0
	onResult,                       // 1
	itputResult,                    // 2
	itputResultReady,               // 3
	inputNext,                      // 4
	inputNextReady,                 // 5
	Progress,                       // 6
	progressStart,                  // 7
	resultBylevel                   // 8
};

var name prevState;
var ItemWindowHandle EnchantJewel1;
var ItemWindowHandle EnchantJewel2;
var ItemWindowHandle EnchantedItemSlot;
var TextBoxHandle InstructionTxt;
var TextBoxHandle WarningTxt;
var TextBoxHandle ProbTxt;
var TextureHandle EnchantJewel1BackTex;
var TextureHandle EnchantJewel2BackTex;
var TextureHandle EnchantedJewelBackTex;
var TextureHandle DropHighlight_EnchantJewel2;
var TextureHandle DropHighlight_EnchantJewel1;
var TextureHandle Groupbox0_tex;
var ButtonHandle EnchantBtn;
var ButtonHandle InitBtn;
var ButtonHandle nextBtn;
var ButtonHandle continueBtn;
var ButtonHandle CancelBtn;
var ProgressCtrlHandle m_hItemEnchantWndEnchantProgress;
var CheckBoxHandle Skip_CheckBox;
var UIControlNeedItemList UIControlNeedItemListObj;
var UIControlNumberInputSteper numberInputStepper;
var ItemInfo jewel1ItemInfo;
var ItemInfo jewel2ItemInfo;
var bool bRequestedPushRetry;
var bool bRequestPushOne;
var bool bRequestPushTwo;
var bool bRequestRemoveOne;
var bool bRequestRemoveTwo;
var bool bRequestTryEnchant;
var EnchantType currentEnchantType;
var ItemJewelEnchantSubWnd ItemJewelEnchantSubWndScript;
var ItemWindowHandle itemJewelEnchantSubWnd_ItemWnd;
var ItemWindowHandle InvenInventoryItem;
var ItemWindowHandle InventoryItem;
var WindowHandle AutoEnchant_wnd;
var Rect slot1StartRect;
var Rect slot2StartRect;
var Rect slotEndStartRect;
var EffectViewportWndHandle mainEffectViewport;
var ItemWindowHandle moveItem1;
var ItemWindowHandle moveItem2;
var AnimTextureHandle shadowItem_tex1;
var AnimTextureHandle shadowItem_tex2;
var AnimTextureHandle ShadowItem_texEnd;
var AnimTextureHandle dropResult_AniTex1;
var AnimTextureHandle dropResult_AniTex2;
var L2UIInventoryObject iObject;
var L2UITimerObject uiTimerObj;
var AUTOPROCESS_STEP_TYPE autoProcessStepType;
var bool bPausedAuto;
var INT64 currentCommissionAdena;
var WindowHandle Dialog_Wnd;
var RichListCtrlHandle EnchantItemList_RichList;
var int EventProb;
//var delegate<SortByLevelDelegate> __SortByLevelDelegate__Delegate;

function StateFuncOnCclickEnchantBtn()
{
	return;
}

function StateFuncOnCclickCancelBtn()
{
	return;
}

function InitFlags()
{
	bRequestedPushRetry = false;
	bRequestTryEnchant = false;
	bRequestPushOne = false;
	bRequestPushTwo = false;
	bRequestRemoveOne = false;
	bRequestRemoveTwo = false;
	return;
}

function InitRichListScript()
{
	UIControlNeedItemListObj = Class'InterfaceClassic.UIControlNeedItemList'.static.InitScript(GetWindowHandle("ItemJewelEnchantWnd.NeedItemWnd"));
	UIControlNeedItemListObj._SetUseAnimation(true);
	UIControlNeedItemListObj.DelegateOnUpdateItem = OnItemUpdateItem;
	UIControlNeedItemListObj._SetAnimationRate(0.5000000);
	return;
}

function InitUIControlNumberInputSteper()
{
	numberInputStepper = Class'InterfaceClassic.UIControlNumberInputSteper'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoEnchant_wnd.EnchantGoalSet_wndAsset")));
	numberInputStepper.DelegateESCKey = OnReceivedCloseUI;
	numberInputStepper.DelegateOnChangeEditBox = OnChangedLevel;
	numberInputStepper.m_hOwnerWnd.ShowWindow();
	numberInputStepper._SetDisable(true);
	numberInputStepper._setMaxLength(2);
	return;
}

function InitAutoEnchant()
{
	local Rect wndRect;

	AutoEnchant_wnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoEnchant_wnd"));
	InventoryItem = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoEnchant_wnd.AutoJewelItemWindow"));
	InventoryItem.SetIconDrawType(ITEMWND_IconDraw_ShowNewlyAcquired);
	slot1StartRect = EnchantJewel1.GetRect();
	slot2StartRect = EnchantJewel2.GetRect();
	slotEndStartRect = EnchantedItemSlot.GetRect();
	wndRect = m_hOwnerWnd.GetRect();
	slot1StartRect.nX = (slot1StartRect.nX - wndRect.nX);
	slot1StartRect.nY = (slot1StartRect.nY - wndRect.nY);
	slot2StartRect.nX = (slot2StartRect.nX - wndRect.nX);
	slot2StartRect.nY = (slot2StartRect.nY - wndRect.nY);
	slotEndStartRect.nX = (slotEndStartRect.nX - wndRect.nX);
	slotEndStartRect.nY = (slotEndStartRect.nY - wndRect.nY);
	moveItem1.HideWindow();
	moveItem2.HideWindow();
	shadowItem_tex1.HideWindow();
	shadowItem_tex2.HideWindow();
	ShadowItem_texEnd.HideWindow();
	dropResult_AniTex1.HideWindow();
	dropResult_AniTex2.HideWindow();
	return;
}

static function ItemJewelEnchantWnd Inst()
{
	return ItemJewelEnchantWnd(GetScript("ItemJewelEnchantWnd"));
}

event OnRegisterEvent()
{
	RegisterEvent(9760);
	RegisterEvent(9770);
	RegisterEvent(9780);
	RegisterEvent(9790);
	RegisterEvent(9800);
	RegisterEvent(9810);
	RegisterEvent(9820);
	RegisterEvent(9830);
	RegisterEvent(9840);
	RegisterEvent(9850);
	RegisterEvent(9851);
	RegisterEvent(9852);
	RegisterEvent(6200);
	RegisterEvent(EV_PacketID(1177));
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Skip_CheckBox = GetCheckBoxHandle("ItemJewelEnchantWnd.Skip_CheckBox");
	Skip_CheckBox.SetCheck(GetOptionBool("UI", "ItemJewelEnchantWndAnimShow"));
	EnchantJewel1 = GetItemWindowHandle("ItemJewelEnchantWnd.EnchantJewel1");
	EnchantJewel2 = GetItemWindowHandle("ItemJewelEnchantWnd.EnchantJewel2");
	EnchantedItemSlot = GetItemWindowHandle("ItemJewelEnchantWnd.EnchantedItemSlot");
	InvenInventoryItem = GetItemWindowHandle("InventoryWnd.InventoryItem");
	itemJewelEnchantSubWnd_ItemWnd = GetItemWindowHandle("ItemJewelEnchantSubWnd.ItemJewelEnchantSubWnd_ItemWnd");
	moveItem1 = GetItemWindowHandle("ItemJewelEnchantWnd.moveItem1");
	moveItem2 = GetItemWindowHandle("ItemJewelEnchantWnd.moveItem2");
	InstructionTxt = GetTextBoxHandle("ItemJewelEnchantWnd.InstructionTxt");
	WarningTxt = GetTextBoxHandle("ItemJewelEnchantWnd.WarningTxt");
	ProbTxt = GetTextBoxHandle("ItemJewelEnchantWnd.ProbTxt");
	EnchantBtn = GetButtonHandle("ItemJewelEnchantWnd.EnchantBtn");
	InitBtn = GetButtonHandle("ItemJewelEnchantWnd.InitBtn");
	nextBtn = GetButtonHandle("ItemJewelEnchantWnd.nextbtn");
	continueBtn = GetButtonHandle("ItemJewelEnchantWnd.continueBtn");
	CancelBtn = GetButtonHandle("itemJewelEnchantWnd.CancelBtn");
	EnchantJewel1BackTex = GetTextureHandle("ItemJewelEnchantWnd.EnchantJewel1BackTex");
	EnchantJewel2BackTex = GetTextureHandle("ItemJewelEnchantWnd.EnchantJewel2BackTex");
	EnchantedJewelBackTex = GetTextureHandle("ItemJewelEnchantWnd.EnchantedJewelBackTex");
	DropHighlight_EnchantJewel1 = GetTextureHandle("ItemJewelEnchantWnd.DropHighlight_EnchantJewel1");
	DropHighlight_EnchantJewel2 = GetTextureHandle("ItemJewelEnchantWnd.DropHighlight_EnchantJewel2");
	Groupbox0_tex = GetTextureHandle("ItemJewelEnchantWnd.TopBg_Wnd.Groupbox0_tex");
	shadowItem_tex1 = GetAnimTextureHandle("ItemJewelEnchantWnd.shadowItem_tex1");
	shadowItem_tex2 = GetAnimTextureHandle("ItemJewelEnchantWnd.shadowItem_tex2");
	ShadowItem_texEnd = GetAnimTextureHandle("ItemJewelEnchantWnd.shadowItem_texEnd");
	dropResult_AniTex1 = GetAnimTextureHandle("ItemJewelEnchantWnd.dropResult_AniTex1");
	dropResult_AniTex2 = GetAnimTextureHandle("ItemJewelEnchantWnd.dropResult_AniTex2");
	m_hItemEnchantWndEnchantProgress = GetProgressCtrlHandle("ItemJewelEnchantWnd.EnchantProgress");
	mainEffectViewport = GetEffectViewportWndHandle("ItemJewelEnchantWnd.mainEffectViewport");
	Dialog_Wnd = GetWindowHandle("ItemJewelEnchantWnd.Dialog_Wnd");
	EnchantItemList_RichList = GetRichListCtrlHandle("ItemJewelEnchantWnd.Dialog_Wnd.EnchantItemList_RichList");
	ItemJewelEnchantSubWndScript = ItemJewelEnchantSubWnd(GetScript("ItemJewelEnchantSubWnd"));
	uiTimerObj = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject();
	uiTimerObj._DelegateOnEnd = NextProcess;
	iObject = Class'InterfaceClassic.L2UIInventory'.static.Inst().NewObject();
	iObject.DelegateOnAddItem = HandleOnAddItem;
	iObject.DelegateOnUpdateItem = HandleOnUpdateItem;
	iObject.DelegateOnCompare = HandleOnCompare;
	InitRichListScript();
	InitUIControlNumberInputSteper();
	InitAutoEnchant();
	InitTransformAutoEncahnt();
	SetState('stateBegin');
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 6200:
			InitTransformAutoEncahnt();
			break;
		case 9760:
			HandleAddJewel1(param);
			break;
		case 9770:
			bRequestPushOne = false;
			break;
		case 9780:
			HandleAddJewel2(param);
			break;
		case 9790:
			bRequestPushTwo = false;
			break;
		case 9800:
			HandleRemoveJewel1(param);
			break;
		case 9810:
			bRequestRemoveOne = false;
			break;
		case 9820:
			HandleRemoveJewel2(param);
			break;
		case 9830:
			bRequestRemoveTwo = false;
			break;
		case 9840:
			HandleEnchantResult(param);
			break;
		case 9850:
			HandleEnchantTryFail();
			break;
		case 9851:
			HandleNewEnchantRetryPutItems(true, param);
			break;
		case 9852:
			HandleNewEnchantRetryPutItems(false, param);
			break;
		case EV_PacketID(1177):
			RT_S_EX_COMBINATION_PROB_LIST();
			break;
		default:
			break;
	}
	return;
}

event OnCallUCFunction(string funcName, string param)
{
	switch(funcName)
	{
		case "tweenEnd":
			HandleOnTweenEnd(int(param));
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	InitTransformDye();
	SetState('stateReady');
	GetWindowHandle("ItemJewelEnchantSubWnd").ShowWindow();
	ItemJewelEnchantSubWndScript._Refresh();
	m_hOwnerWnd.SetFocus();
	PlayEffectStandBy();
	PlaySound("InterfaceSound.ui_synthesis_open");
	return;
}

event OnHide()
{
	SetState('stateReady');
	API_RequestClose();
	InitFlags();
	if((DialogIsMine() && Class'InterfaceClassic.DialogBox'.static.Inst().m_hOwnerWnd.IsShowWindow()))
	{
		Class'InterfaceClassic.DialogBox'.static.Inst().HideDialog();
	}
	uiTimerObj._Stop();
	if((int(currentEnchantType) == 1))
	{
		Class'InterfaceClassic.L2Util'.static.Inst().syncWindowLoc(m_hOwnerWnd.m_WindowNameWithFullPath, "HennaDyeEnchantWnd");
		GetWindowHandle("HennaDyeEnchantWnd").ShowWindow();
	}
	EventProb = 0;
	return;
}

event OnDropItem(string a_WindowID, ItemInfo a_itemInfo, int X, int Y)
{
	if((a_itemInfo.ShortcutType == 4))
	{
		return;
	}
	if((a_itemInfo.DragSrcName != "ItemJewelEnchantSubWnd_ItemWnd"))
	{
		return;
	}
	if(_IsWorkingEnchant())
	{
		return;
	}
	switch(GetStateName())
	{
		case 'stateReady':
			_DropProcess(a_itemInfo, 1);
			break;
		case 'stateOneReady':
		case 'stateAllReady':
			_DropProcess(a_itemInfo, 2);
			break;
		default:
			break;
	}
	return;
}

event OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);
	return;
}

event OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo tmpJewelItemInfo1, tmpJewelItemInfo2;

	if(_IsWorkingEnchant())
	{
		return;
	}
	switch(ControlName)
	{
		case "EnchantJewel1":
			if(_GetSlot1ItemInfo(tmpJewelItemInfo1))
			{
				API_RequestRemoveOne(tmpJewelItemInfo1.Id);
			}
		case "EnchantJewel2":
			if(_GetSlot2ItemInfo(tmpJewelItemInfo2))
			{
				API_RequestRemoveTwo(tmpJewelItemInfo2.Id);
				EventProb = 0;
			}
			break;
		case "AutoJewelItemWindow":
			RemoveInventoryItem(Index);
			break;
		default:
			break;
	}
	return;
}

event OnDropItemSource(string strTarget, ItemInfo Info)
{
	local int Index;

	if(_IsWorkingEnchant())
	{
		return;
	}
	if((strTarget == "Console"))
	{
		switch(Info.DragSrcName)
		{
			case "AutoJewelItemWindow":
				Index = InventoryItem.FindItem(Info.Id);
				break;
			default:
				break;
		}
		OnDBClickItem(Info.DragSrcName, Index);
	}
	return;
}

event OnClickCheckBox(string strID)
{
	switch(strID)
	{
		case "Skip_CheckBox":
			SetOptionBool("UI", "ItemJewelEnchantWndAnimShow", Skip_CheckBox.IsChecked());
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "InitBtn":
			if(((GetStateName() == 'StateResult') || (GetStateName() == 'stateAutoResult')))
			{
				SetState('stateReady');
				RefreshSubWnd();
				API_RequestClose();
			}
			else
			{
				OnDBClickItem("EnchantJewel1", 0);
			}
			break;
		case "AutoEnchantClose_btn":
			TransformAutoEnchantClose();
			break;
		case "AutoEnchantOpen_btn":
			TransFormAutoEnchantOpen();
			break;
		case "nextbtn":
			HandleOnCLickResultItem();
			break;
		case "continueBtn":
			HandleOnClickRetry();
			break;
		case "EnchantBtn":
			StateFuncOnCclickEnchantBtn();
			break;
		case "DialogConfirmBtn":
			SetState('stateProcess');
			PlayEffectProgress();
		case "DialogCancelBtn":
			HideDialog_Wnd();
			break;
		case "WindowHelp_BTN":
			if(getInstanceUIData().GetIsClassicServer())
			{
				Class'InterfaceClassic.HelpWnd'.static.ShowHelp(72);
			}
			else
			{
				Class'InterfaceClassic.HelpWnd'.static.ShowHelp(127);
			}
			break;
		case "cancelBtn":
			StateFuncOnCclickCancelBtn();
			break;
		default:
			break;
	}
	return;
}

event OnTextureAnimEnd(AnimTextureHandle a_AnimTextureHandle)
{
	switch(a_AnimTextureHandle)
	{
		case shadowItem_tex1:
			InventoryItemAllClearClearItems();
		case shadowItem_tex2:
			a_AnimTextureHandle.HideWindow();
			break;
		case dropResult_AniTex2:
		case dropResult_AniTex1:
			a_AnimTextureHandle.HideWindow();
			break;
		default:
			break;
	}
	return;
}

event OnProgressTimeUp(string strID)
{
	switch(strID)
	{
		case "EnchantProgress":
			API_RequestTryEnchant();
			break;
		default:
			break;
	}
	return;
}

function int GetProgressTIme()
{
	if(_IsAutoMode())
	{
		if((GetResultEffectType() > 0))
		{
			return 700;
		}
		else
		{
			return 100;
		}
	}
	else if(Skip_CheckBox.IsChecked())
	{
		return 150;
	}
	return 1000;
}

function FindSameItemArray(ItemInfo iInfo, out array<ItemInfo> iInfos)
{
	local int i;
	local array<ItemInfo> iiInfos;

	iInfos.Length = 0;
	if(IsStackableItem(iInfo.ConsumeType))
	{
		Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(iInfo.Id.ClassID, iInfos);
		return;
	}
	if(getInstanceUIData().GetIsClassicServer())
	{
		getInstanceL2Util().FindItemByClassIDWithFilter(iInfo.Id.ClassID, iiInfos, UNLOCK, , 4);
	}
	else
	{
		getInstanceL2Util().FindItemByClassID(iInfo.Id.ClassID, iiInfos, UNLOCK);
	}
	i = 0;
	while((i < iiInfos.Length))
	{
		if((((iiInfos[i].Id.ClassID == iInfo.Id.ClassID) && (iiInfos[i].Enchanted == iInfo.Enchanted)) && (iInfo.Id.ServerID != iiInfos[i].Id.ServerID)))
		{
			iInfos[iInfos.Length] = iiInfos[i];
		}
		i++;
	}
	return;
}

function HandleOnClickRetry()
{
	local int i;
	local array<ItemInfo> itemInfoArray;

	FindSameItemArray(jewel1ItemInfo, itemInfoArray);
	API_RequestPushOne(itemInfoArray[0], true);
	FindSameItemArray(jewel2ItemInfo, itemInfoArray);
	if(IsStackableItem(jewel1ItemInfo.ConsumeType))
	{
		API_RequestPushTwo(itemInfoArray[0], true);
		API_RequestEnchantRetryPutItems(jewel1ItemInfo.Id.ServerID, jewel2ItemInfo.Id.ServerID);
	}
	else
	{
		i = 0;
		while((i < itemInfoArray.Length))
		{
			if((itemInfoArray[i].Id != jewel1ItemInfo.Id))
			{
				API_RequestPushTwo(itemInfoArray[i], true);
				API_RequestEnchantRetryPutItems(jewel1ItemInfo.Id.ServerID, itemInfoArray[i].Id.ServerID);
				return;
			}
			i++;
		}
	}
	return;
}

function HandleOnCLickResultItem()
{
	local int i;
	local ItemInfo resultJewelItemInfo;
	local INT64 nCommissionAdena;
	local array<ItemInfo> MaterialItems;
	local array<int> CandidateMaterials;

	EnchantedItemSlot.GetItem(0, resultJewelItemInfo);
	if(!ItemJewelEnchantSubWndScript._CanEnchatItem(resultJewelItemInfo.Id.ClassID, resultJewelItemInfo.Enchanted, nCommissionAdena, MaterialItems))
	{
		return;
	}
	EnchantJewel1DeleteItem();
	EnchantJewel2DeleteItem();
	if((API_GetEnchantCandidateMaterialList(resultJewelItemInfo.Id.ClassID, CandidateMaterials) == 1))
	{
		API_RequestPushOne(resultJewelItemInfo, true);
		i = 0;
		while((i < MaterialItems.Length))
		{
			if((MaterialItems[i].Id != resultJewelItemInfo.Id))
			{
				API_RequestPushTwo(MaterialItems[i], true);
				API_RequestEnchantRetryPutItems(jewel1ItemInfo.Id.ServerID, jewel2ItemInfo.Id.ServerID);
				return;
			}
			i++;
		}
	}
	API_RequestPushOne(resultJewelItemInfo);
	return;
}

function SetClearRichListNeedItem()
{
	UIControlNeedItemListObj.CleariObjects();
	currentCommissionAdena = INT64(0);
	return;
}

function SetRichListNeedItem()
{
	local INT64 Commission;
	local array<ItemInfo> MaterialItems;

	API_GetMaterialItemForEnchantFromInven(jewel1ItemInfo.Id.ClassID, jewel1ItemInfo.Enchanted, jewel2ItemInfo.Id.ClassID, jewel2ItemInfo.Enchanted, Commission, MaterialItems);
	if(((currentCommissionAdena == Commission) && (currentCommissionAdena != INT64(0))))
	{
		return;
	}
	UIControlNeedItemListObj.StartNeedItemList(1);
	UIControlNeedItemListObj.AddNeedItemClassID(57, Commission);
	UIControlNeedItemListObj.SetBuyNum(INT64(1));
	currentCommissionAdena = Commission;
	return;
}

function InitTransformDye()
{
	if((int(currentEnchantType) == 1))
	{
		setWindowTitleByString(GetSystemString(13812));
		getInstanceL2Util().syncWindowLoc("HennaDyeEnchantWnd", m_hOwnerWnd.m_WindowNameWithFullPath);
	}
	else
	{
		setWindowTitleByString(GetSystemString(3189));
	}
	return;
}

function InitTransformAutoEncahnt()
{
	if(_IsAutoMode())
	{
		TransFormAutoEnchantOpen();
	}
	else
	{
		TransformAutoEnchantClose();
	}
	return;
}

function TransFormAutoEnchantOpen()
{
	SetINIInt(m_hOwnerWnd.m_WindowNameWithFullPath, "e", 1, "WindowsInfo.ini");
	AutoEnchant_wnd.SetFocus();
	AutoEnchant_wnd.ShowWindow();
	m_hOwnerWnd.SetWindowSize(696, 780);
	RefreshSubWnd();
	Skip_CheckBox.HideWindow();
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".TopBg_Wnd.SubTitle_Txt")).SetText(GetSystemString(14117));
	return;
}

function TransformAutoEnchantClose()
{
	SetINIInt(m_hOwnerWnd.m_WindowNameWithFullPath, "e", 0, "WindowsInfo.ini");
	AutoEnchant_wnd.HideWindow();
	m_hOwnerWnd.SetWindowSize(696, 634);
	ClearAutoJewelItemWindow();
	RefreshSubWnd();
	Skip_CheckBox.ShowWindow();
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".TopBg_Wnd.SubTitle_Txt")).SetText(GetSystemString(14116));
	return;
}

function EnableTransformAutosNCheckBox()
{
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoEnchant_wnd.AutoEnchantClose_btn")).EnableWindow();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoEnchant_wnd.AutoEnchantOpen_btn")).EnableWindow();
	Skip_CheckBox.EnableWindow();
	return;
}

function DisableTransformAutosNCheckBox()
{
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoEnchant_wnd.AutoEnchantClose_btn")).DisableWindow();
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoEnchant_wnd.AutoEnchantOpen_btn")).DisableWindow();
	Skip_CheckBox.DisableWindow();
	return;
}

function EnchantJewel1AddItem(ItemInfo iInfo)
{
	EnchantJewel1.Clear();
	EnchantJewel1.AddItem(iInfo);
	EnchantJewel1.ShowWindow();
	EnchantJewel1BackTex.HideWindow();
	dropResult_AniTex1.ShowWindow();
	dropResult_AniTex1.SetLoopCount(1);
	dropResult_AniTex1.Play();
	ProbTxt.SetText("");
	RQ_C_EX_COMBINATION_PROB_LIST();
	return;
}

function EnchantJewel2AddItem(ItemInfo iInfo)
{
	EnchantJewel2.Clear();
	EnchantJewel2.AddItem(iInfo);
	EnchantJewel2.ShowWindow();
	EnchantJewel2BackTex.HideWindow();
	dropResult_AniTex2.ShowWindow();
	dropResult_AniTex2.SetLoopCount(1);
	dropResult_AniTex2.Play();
	ProbTxt.SetText("");
	RQ_C_EX_COMBINATION_PROB_LIST();
	SetRichListNeedItem();
	return;
}

function EnchantJewel1DeleteItem()
{
	EnchantJewel1.Clear();
	ProbTxt.SetText("");
	EnchantJewel1BackTex.ShowWindow();
	dropResult_AniTex1.HideWindow();
	return;
}

function EnchantJewel2DeleteItem()
{
	EnchantJewel2.Clear();
	ProbTxt.SetText("");
	EnchantJewel2BackTex.ShowWindow();
	dropResult_AniTex2.HideWindow();
	SetClearRichListNeedItem();
	ClearAutoJewelItemWindow();
	return;
}

function EnchantedItemSlotAdd(ItemInfo iInfo)
{
	if((iInfo.Id.ClassID == 0))
	{
		EnchantedItemSlot.Clear();
		return;
	}
	EnchantedItemSlot.MoveC(slotEndStartRect.nX, slotEndStartRect.nY);
	EnchantedItemSlot.SetAlpha(0);
	EnchantedItemSlot.Clear();
	EnchantedItemSlot.AddItem(iInfo);
	EnchantedItemSlot.ShowWindow();
	if(_IsAutoMode())
	{
		EnchantedItemSlot.SetAlpha(255, 0.1000000);
	}
	else
	{
		EnchantedItemSlot.SetAlpha(255, 0.5000000);
	}
	EnchantedJewelBackTex.ShowWindow();
	return;
}

function EnchantedItemSlotDelete()
{
	EnchantedItemSlot.SetAlpha(0);
	EnchantedItemSlot.HideWindow();
	EnchantedJewelBackTex.HideWindow();
	return;
}

function HandleAddJewel1(optional string param)
{
	if(!m_hOwnerWnd.IsShowWindow())
	{
		m_hOwnerWnd.ShowWindow();
	}
	EnchantJewel1AddItem(jewel1ItemInfo);
	if(bRequestPushOne)
	{
		numberInputStepper._setRangeMinMaxNum(1, 1);
		bRequestPushOne = false;
		SetState('stateOneReady');
	}
	if(!SetItemSlot2())
	{
		RefreshSubWnd();
	}
	return;
}

function HandleAddJewel2(optional string param)
{
	ParseInt(param, "Prob", EventProb);
	EnchantJewel2AddItem(jewel2ItemInfo);
	if(bRequestPushTwo)
	{
		SetState('stateAllReady');
		StateTxtWarningTxt();
		bRequestPushTwo = false;
	}
	RefreshSubWnd();
	return;
}

function HandleRemoveJewel1(optional string param)
{
	bRequestRemoveOne = false;
	EnchantJewel1DeleteItem();
	SetState('stateReady');
	RefreshSubWnd();
	return;
}

function HandleRemoveJewel2(optional string param)
{
	bRequestRemoveTwo = false;
	EnchantJewel2DeleteItem();
	SetState('stateOneReady');
	RefreshSubWnd();
	return;
}

function HandleNewEnchantRetryPutItems(bool bSuccess, optional string param)
{
	bRequestedPushRetry = false;
	if(bSuccess)
	{
		HandleAddJewel1();
		HandleAddJewel2(param);
		if(_IsAutoMode())
		{
			PlaySound("InterfaceSound.ui_synthesis_in");
			NextProcess();
		}
		else
		{
			PlaySound("InterfaceSound.ui_synthesis_slot");
			SetState('stateAllReady');
		}
	}
	else
	{
		HandleRemoveJewel1();
		HandleRemoveJewel2();
	}
	RefreshSubWnd();
	return;
}

function ItemID _DropProcess(ItemInfo a_itemInfo, int SlotIndex, optional bool bNoRequestServer)
{
	local ItemInfo tmpJewelItemInfo1, tmpJewelItemInfo2;
	local ItemID emptyItemID;
	local int i;
	local array<ItemInfo> itemInfoArray;

	if((a_itemInfo.bDisabled > 0))
	{
		return emptyItemID;
	}
	if((a_itemInfo.ShortcutType == 4))
	{
		return emptyItemID;
	}
	if(((GetStateName() == 'stateAllReady') && _IsAutoMode()))
	{
		AddInventoryItem(a_itemInfo);
		return a_itemInfo.Id;
	}
	_GetSlot1ItemInfo(tmpJewelItemInfo1);
	_GetSlot2ItemInfo(tmpJewelItemInfo2);
	if((SlotIndex == 0))
	{
		if((tmpJewelItemInfo1.Id.ClassID <= 0))
		{
			SlotIndex = 1;
		}
		else
		{
			SlotIndex = 2;
		}
	}
	if(IsStackableItem(a_itemInfo.ConsumeType))
	{
		InvenInventoryItem.GetItem(InventoryItem.FindItemByClassID(a_itemInfo.Id), a_itemInfo);
		if((SlotIndex == 1))
		{
			API_RequestPushOne(a_itemInfo, bNoRequestServer);
		}
		else
		{
			API_RequestPushTwo(a_itemInfo, bNoRequestServer);
		}
		return a_itemInfo.Id;
	}
	else
	{
		if(getInstanceUIData().GetIsClassicServer())
		{
			getInstanceL2Util().FindItemByClassIDWithFilter(a_itemInfo.Id.ClassID, itemInfoArray, UNLOCK, , 4);
		}
		else
		{
			getInstanceL2Util().FindItemByClassID(a_itemInfo.Id.ClassID, itemInfoArray, UNLOCK);
		}
		if((SlotIndex == 1))
		{
			i = 0;
			while((i < itemInfoArray.Length))
			{
				if((itemInfoArray[i].Enchanted != a_itemInfo.Enchanted))
				{
					i++;
					continue;
				}
				API_RequestPushOne(a_itemInfo, bNoRequestServer);
				return itemInfoArray[i].Id;
				i++;
			}
		}
		else if((SlotIndex == 2))
		{
			i = 0;
			while((i < itemInfoArray.Length))
			{
				if((itemInfoArray[i].Enchanted != a_itemInfo.Enchanted))
				{
					i++;
					continue;
				}
				if((itemInfoArray[i].Id.ServerID == jewel1ItemInfo.Id.ServerID))
				{
					i++;
					continue;
				}
				if((itemInfoArray[i].Id.ServerID != a_itemInfo.Id.ServerID))
				{
					i++;
					continue;
				}
				API_RequestPushTwo(itemInfoArray[i], bNoRequestServer);
				return itemInfoArray[i].Id;
				i++;
			}
		}
	}
	return emptyItemID;
}

function bool SetItemSlot2()
{
	local INT64 nCommissionAdena;
	local array<ItemInfo> itemInfoArray;
	local array<int> CandidateMaterials;

	if((_GetClassIDBySlotItemIndex(2) < 1))
	{
		if(Class'InterfaceClassic.ItemJewelEnchantSubWnd'.static.Inst()._GetCanEnchantItemCurrent(nCommissionAdena, itemInfoArray))
		{
			if((API_GetEnchantCandidateMaterialList(_GetClassIDBySlotItemIndex(1), CandidateMaterials) == 1))
			{
				return (_DropProcess(itemInfoArray[0], 2).ClassID > 0);
			}
		}
	}
	return false;
}

function RefreshSubWnd()
{
	if(BRequesteEnd())
	{
		ItemJewelEnchantSubWndScript._Refresh();
	}
	return;
}

function HandleEnchantTryFail()
{
	getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(213));
	m_hOwnerWnd.HideWindow();
	return;
}

function HandleEnchantResult(string param)
{
	local int ClassID, Enchanted;
	local ItemInfo iInfo;

	ParseInt(param, "ItemClassID", ClassID);
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(ClassID), iInfo);
	ParseInt(param, "ItemEnchant", Enchanted);
	iInfo.Enchanted = Enchanted;
	iInfo.ItemNum = INT64(1);
	if((iInfo.AdditionalName != ""))
	{
		iInfo.AdditionalName = (iInfo.AdditionalName $ " ");
	}
	if((GetResult(iInfo) && (ClassID != 0)))
	{
		showResult(result_Success, iInfo);
	}
	else
	{
		switch(API_GetResultEffectTypeCurrent())
		{
			case CRET_NOFAIL:
				showResult(result_only, iInfo);
				break;
			case CRET_NONE:
				SetState('StateResult');
				SetNextOnResultItem(iInfo);
				showResult(result_fail_noItem, iInfo);
				return;
			case CRET_DEFAULT:
			case CRET_MAX:
			default:
				showResult(result_fail, iInfo);
				break;
		}
	}
	EnchantedItemSlotAdd(iInfo);
	SetState('StateResult');
	return;
}

function bool GetResult(out ItemInfo _resultItem)
{
	local bool bSuccess;
	local CombinationItemUIData o_data;

	API_GetCombinationItemDataCurrent(o_data);
	bSuccess = ((_resultItem.Id.ClassID == o_data.ResultItems[0].ClassID) && (_resultItem.Enchanted == o_data.ResultItems[0].Enchant));
	if(bSuccess)
	{
		_resultItem.ItemNum = INT64(o_data.ResultItems[0].Num);
	}
	else
	{
		_resultItem.ItemNum = INT64(o_data.ResultItems[1].Num);
	}
	return bSuccess;
}

function showResult(ResultType Type, ItemInfo iInfo)
{
	local int strMsgNum;
	local string ItemName;

	switch(Type)
	{
		case result_fail_noItem:
			strMsgNum = 13924;
			PlayEffectFail();
			WarningTxt.SetText("");
			InstructionTxt.SetTextColor(getInstanceL2Util().DRed);
			break;
		case result_fail:
			strMsgNum = 4414;
			PlayEffectFail();
			break;
		case result_Success:
			strMsgNum = 4413;
			PlayEffectSuccess();
			break;
		case result_only:
			strMsgNum = 4417;
			PlayEffectSuccess();
			break;
		default:
			break;
	}
	ItemName = (iInfo.Name @ iInfo.AdditionalName);
	if((iInfo.Enchanted > 0))
	{
		ItemName = (("+" $ string(iInfo.Enchanted)) @ ItemName);
	}
	InstructionTxt.SetText(MakeFullSystemMsg(GetSystemMessage(strMsgNum), ItemName, string(iInfo.ItemNum)));
	return;
}

function ShowDialog(ItemInfo iInfo)
{
	local INT64 limitNum;

	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Disable_BG")).ShowWindow();
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Disable_BG")).SetFocus();
	DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), iInfo.Name, ""));
	limitNum = ItemJewelEnchantSubWndScript._GetIneventoryItemNum(iInfo);
	DialogSetInputlimit(limitNum);
	DialogSetParamInt64(limitNum);
	Class'InterfaceClassic.DialogBox'.static.Inst().SetDefaultAction(EDefaultOK);
	Class'InterfaceClassic.DialogBox'.static.Inst().SetReservedItemInfo(iInfo);
	Class'InterfaceClassic.DialogBox'.static.Inst().AnchorToOwner();
	Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
	Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnHide = HandleDialogOnHide;
	return;
}

function ShowWarningDialog(string Msg)
{
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Disable_BG")).ShowWindow();
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Disable_BG")).SetFocus();
	DialogShowHtml(DialogModalType_Modalless, DialogType_OKCancel, Msg);
	Class'InterfaceClassic.DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
	Class'InterfaceClassic.DialogBox'.static.Inst().AnchorToOwner();
	Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnOK = HandleDialogWarningOK;
	Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnHide = HandleDialogWarningCancel;
	return;
}

function HandleDialogWarningOK()
{
	if(_IsAutoMode())
	{
		ShowDialog_Wnd();
	}
	else
	{
		SetState('stateProcess');
		PlayEffectProgress();
	}
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Disable_BG")).HideWindow();
	return;
}

function HandleDialogWarningCancel()
{
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Disable_BG")).HideWindow();
	return;
}

function HandleDialogOK()
{
	local INT64 ItemNum;
	local ItemInfo iInfo;

	ItemNum = MAX64(INT64(0), INT64(DialogGetString()));
	if((ItemNum == INT64(0)))
	{
		return;
	}
	Class'InterfaceClassic.DialogBox'.static.Inst().GetReservedItemInfo(iInfo);
	ItemJewelEnchantSubWndScript._MoveToOwner(iInfo, ItemNum);
	return;
}

function HandleDialogOnHide()
{
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Disable_BG")).HideWindow();
	return;
}

function bool BRequesteEnd()
{
	return (((((!bRequestedPushRetry && !bRequestTryEnchant) && !bRequestPushOne) && !bRequestPushTwo) && !bRequestRemoveOne) && !bRequestRemoveTwo);
}

function bool _HasItemInSlot(int SlotIndex)
{
	local ItemInfo Info;

	if((SlotIndex == 1))
	{
		return _GetSlot1ItemInfo(Info);
	}
	else
	{
		return _GetSlot2ItemInfo(Info);
	}
	return false;
}

function bool _IsWorkingEnchant()
{
	switch(GetStateName())
	{
		case 'StateResult':
		case 'stateProcess':
			return true;
		default:
			return false;
	}
}

function bool _IsAutoMode()
{
	local int E;

	GetINIInt(m_hOwnerWnd.m_WindowNameWithFullPath, "e", E, "WindowsInfo.ini");
	return (E == 1);
}

function HandleOnAddItem(optional ItemInfo iInfo, optional int Index)
{
	SetNextOnResultItem(iInfo);
	return;
}

function HandleOnUpdateItem(optional ItemInfo iInfo, optional int Index)
{
	SetNextOnResultItem(iInfo);
	return;
}

function SetNextOnResultItem(ItemInfo iInfo)
{
	local ItemInfo resultJewelItemInfo;

	bRequestTryEnchant = false;
	EnchantedItemSlot.GetItem(0, resultJewelItemInfo);
	if(IsStackableItem(iInfo.ConsumeType))
	{
		iInfo.bShowCount = true;
		iInfo.ItemNum = INT64(1);
	}
	EnchantedItemSlot.SetItem(0, iInfo);
	if(_IsAutoMode())
	{
		NextProcess();
	}
	else
	{
		RefreshSubWnd();
		CheckBtnsOnResult();
	}
	return;
}

function bool HandleOnCompare(optional ItemInfo iInfo, optional int Index)
{
	local ItemInfo resultJewelItemInfo;

	if(!m_hOwnerWnd.IsShowWindow())
	{
		return false;
	}
	if(!bRequestTryEnchant)
	{
		return false;
	}
	if((GetStateName() != 'StateResult'))
	{
		return false;
	}
	if(!EnchantedItemSlot.GetItem(0, resultJewelItemInfo))
	{
		return false;
	}
	if(((iInfo.Id.ClassID == resultJewelItemInfo.Id.ClassID) && (resultJewelItemInfo.Enchanted == iInfo.Enchanted)))
	{
		return true;
	}
	return false;
}

function InventoryItemAllClearClearItems()
{
	local int idx;
	local ItemInfo ClearItem;

	GetClearItem(ClearItem);
	while(InventoryItem.GetItem(idx, ClearItem))
	{
		if(!IsValidItemID(ClearItem.Id))
		{
			InventoryItem.DeleteItem(idx);
		}
		else
		{
			idx++;
		}
	}
	return;
}

function int GetClearItemIndex()
{
	local int idx;
	local ItemInfo ClearItem;

	while(InventoryItem.GetItem(idx, ClearItem))
	{
		if(!IsValidItemID(ClearItem.Id))
		{
			return idx;
		}
		idx++;
	}
	return -1;
}

function int GetSameItemIndex(ItemInfo iInfo)
{
	local int idx;
	local ItemInfo iiInfo;

	while(InventoryItem.GetItem(idx, iiInfo))
	{
		if(((iInfo.Id.ClassID == iiInfo.Id.ClassID) && (iInfo.Enchanted == iiInfo.Enchanted)))
		{
			return idx;
		}
		idx++;
	}
	return -1;
}

function NextProcess()
{
	if((int(autoProcessStepType) == 8))
	{
		return;
	}
	autoProcessStepType = AUTOPROCESS_STEP_TYPE((int(autoProcessStepType) + 1));
	switch(autoProcessStepType)
	{
		case onResult:
			uiTimerObj._time = 100;
			uiTimerObj._Reset();
			break;
		case itputResult:
			uiTimerObj._time = 200;
			uiTimerObj._Reset();
			NextProcessInputResult();
			break;
		case itputResultReady:
			uiTimerObj._time = 10;
			uiTimerObj._Reset();
			NextProcessInputResultReady();
			break;
		case inputNext:
			uiTimerObj._time = 200;
			uiTimerObj._Reset();
			NextProcessInputNext();
			break;
		case inputNextReady:
			NextProcessInputNextReady();
			return;
		case Progress:
			if(!UIControlNeedItemListObj.GetCanBuy())
			{
				SetState('stateAllReady');
				return;
			}
			if(bPausedAuto)
			{
				SetState('stateAllReady');
				return;
			}
			else
			{
				SetResultEffectType();
				uiTimerObj._time = 10;
				uiTimerObj._Reset();
			}
			break;
		case progressStart:
			if(bPausedAuto)
			{
				SetState('stateAllReady');
			}
			else
			{
				NextProcessProgress();
			}
			return;
		default:
			break;
	}
	return;
}

function NextProcessProgress()
{
	SetState('stateProcess');
	return;
}

function NextProcessInputResult()
{
	local Rect slotRect, wndRect;
	local int nX, nY, idx;
	local ItemInfo resultJewelItemInfo, ClearItem, iInfo;

	EnchantedItemSlot.GetItem(0, resultJewelItemInfo);
	idx = FindLastInventoryItemIndexItemInfo(resultJewelItemInfo);
	InventoryItem.GetItem(idx, iInfo);
	if(((IsStackableItem(resultJewelItemInfo.ConsumeType) && (resultJewelItemInfo.Id.ClassID == iInfo.Id.ClassID)) && (resultJewelItemInfo.Enchanted == iInfo.Enchanted)))
	{
	}
	else
	{
		GetClearItem(ClearItem);
		InsertInventoryItemItemInfo(idx, ClearItem);
	}
	if(GetPosItemWIndowWithIndex(idx, slotRect))
	{
		return;
	}
	wndRect = m_hOwnerWnd.GetRect();
	nX = (slotRect.nX - wndRect.nX);
	nY = (slotRect.nY - wndRect.nY);
	shadowItem_tex2.Stop();
	shadowItem_tex2.MoveC(nX, nY);
	shadowItem_tex2.ShowWindow();
	shadowItem_tex2.SetLoopCount(1);
	shadowItem_tex2.Play();
	EnchantedItemSlot.BringToFrontOf("AutoEnchant_wnd");
	EnchantedItemSlot.SetAlpha(255);
	TweenAdd(EnchantedItemSlot, -255, 2, uiTimerObj._time, 0, 0, IN_STRONG);
	PlaySound("InterfaceSound.ui_synthesis_out");
	return;
}

function NextProcessInputResultReady()
{
	local int idx;
	local ItemInfo resultJewelItemInfo;

	EnchantedItemSlot.GetItem(0, resultJewelItemInfo);
	EnchantedItemSlot.DeleteItem(0);
	idx = GetClearItemIndex();
	if((idx == -1))
	{
		if(IsStackableItem(resultJewelItemInfo.ConsumeType))
		{
			idx = GetSameItemIndex(resultJewelItemInfo);
		}
		if((idx > -1))
		{
			InventoryItem.GetItem(idx, resultJewelItemInfo);
			resultJewelItemInfo.ItemNum = (resultJewelItemInfo.ItemNum + INT64(1));
			InventoryItem.SetItem(idx, resultJewelItemInfo);
		}
		else
		{
			AddAutoJewelItemWindow(resultJewelItemInfo);
			idx = (InventoryItem.GetItemNum() - 1);
		}
	}
	else
	{
		InventoryItem.SetItem(idx, resultJewelItemInfo);
	}
	InventoryItem.SetNewlyAcquired(idx, true);
	InventoryItemAllClearClearItems();
	return;
}

function NextProcessInputNext()
{
	local int index1, index2;

	if(!GetNextTryIndexAutoMode(index1, index2))
	{
		SetState('stateAutoResult');
		return;
	}
	Animation2(index2);
	Animation1(index1);
	PlayEffectProgress();
	return;
}

function NextProcessInputNextReady()
{
	local ItemInfo iInfo, iiInfo;

	Class'NWindow.UIDATA_INVENTORY'.static.FindItem(jewel1ItemInfo.Id.ServerID, iInfo);
	Class'NWindow.UIDATA_INVENTORY'.static.FindItem(jewel2ItemInfo.Id.ServerID, iiInfo);
	InventoryItemAllClearClearItems();
	shadowItem_tex1.HideWindow();
	shadowItem_tex2.HideWindow();
	API_RequestEnchantRetryPutItems(jewel1ItemInfo.Id.ServerID, jewel2ItemInfo.Id.ServerID);
	return;
}

function Animation1(int Index)
{
	local Rect slotRect, wndRect;
	local int nX, nY;
	local ItemInfo ClearItem;
	local bool isOut;

	wndRect = m_hOwnerWnd.GetRect();
	isOut = GetPosItemWIndowWithIndex(Index, slotRect);
	InventoryItem.GetItem(Index, jewel1ItemInfo);
	nX = (slotRect.nX - wndRect.nX);
	nY = (slotRect.nY - wndRect.nY);
	if((jewel1ItemInfo.ItemNum > INT64(1)))
	{
		jewel1ItemInfo.ItemNum = (jewel1ItemInfo.ItemNum - INT64(1));
		InventoryItem.SetItem(Index, jewel1ItemInfo);
		jewel1ItemInfo.ItemNum = INT64(1);
	}
	else
	{
		GetClearItem(ClearItem);
		InventoryItem.SetItem(Index, ClearItem);
	}
	if(!isOut)
	{
		shadowItem_tex1.MoveC(nX, nY);
		shadowItem_tex1.ShowWindow();
		shadowItem_tex1.SetLoopCount(1);
		shadowItem_tex1.Stop();
		shadowItem_tex1.Play();
	}
	return;
}

function Animation2(int Index)
{
	local Rect slotRect, wndRect;
	local int nX, nY;
	local ItemInfo ClearItem;
	local bool inOut;

	wndRect = m_hOwnerWnd.GetRect();
	inOut = GetPosItemWIndowWithIndex(Index, slotRect);
	nX = (slotRect.nX - wndRect.nX);
	nY = (slotRect.nY - wndRect.nY);
	InventoryItem.GetItem(Index, jewel2ItemInfo);
	if((jewel2ItemInfo.ItemNum > INT64(1)))
	{
		jewel2ItemInfo.ItemNum = (jewel2ItemInfo.ItemNum - INT64(1));
		InventoryItem.SetItem(Index, jewel2ItemInfo);
		jewel2ItemInfo.ItemNum = INT64(1);
	}
	else
	{
		GetClearItem(ClearItem);
		InventoryItem.SetItem(Index, ClearItem);
	}
	if(!inOut)
	{
		shadowItem_tex2.MoveC(nX, nY);
		shadowItem_tex2.ShowWindow();
		shadowItem_tex2.SetLoopCount(1);
		shadowItem_tex2.Play();
	}
	return;
}

function HandleOnTweenEnd(int Id)
{
	switch(Id)
	{
		case 0:
			moveItem1.HideWindow();
			dropResult_AniTex1.ShowWindow();
			dropResult_AniTex1.SetLoopCount(1);
			dropResult_AniTex1.Play();
			break;
		case 1:
			moveItem2.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function bool GetNextTryIndexAutoMode(out int index1, out int index2)
{
	local int i, Len;
	local ItemInfo iInfo;
	local int MaxLevel;
	local CombinationItemUIData o_data;

	API_GetCombinationItemDataCurrent(o_data);
	Len = InventoryItem.GetItemNum();
	MaxLevel = numberInputStepper._getEditNum();
	index1 = -1;
	index2 = -1;
	switch(o_data.AutomaticType)
	{
		case 0:
			return false;
		case 1:
			i = 0;
			while((i < 2))
			{
				if(!InventoryItem.GetItem(i, iInfo))
				{
					return false;
				}
				if(((jewel1ItemInfo.Id.ClassID == iInfo.Id.ClassID) && (jewel1ItemInfo.Enchanted == iInfo.Enchanted)))
				{
					index1 = i;
					i++;
					continue;
				}
				if(((jewel2ItemInfo.Id.ClassID == iInfo.Id.ClassID) && (jewel2ItemInfo.Enchanted == iInfo.Enchanted)))
				{
					index2 = i;
				}
				i++;
			}
			return ((index1 + index2) > 0);
		case 3:
			if(API_GetCombinationItemDataIndex(1, 0, o_data))
			{
				index1 = 1;
				index2 = 0;
				return (o_data.Level < MaxLevel);
			}
			if(API_GetCombinationItemDataIndex(0, 1, o_data))
			{
				index1 = 0;
				index2 = 1;
				return (o_data.Level < MaxLevel);
			}
			return false;
		case 2:
			i = 0;
			while((i < Len))
			{
				InventoryItem.GetItem(i, iInfo);
				if(IsStackableItem(iInfo.ConsumeType))
				{
					if((iInfo.ItemNum > INT64(1)))
					{
						if(API_GetCombinationItemDataIndex(i, i, o_data))
						{
							if((o_data.Level < MaxLevel))
							{
								index1 = i;
								index2 = i;
								return true;
							}
						}
					}
				}
				if((i == (Len - 1)))
				{
					i++;
					continue;
				}
				if(!API_GetCombinationItemDataIndex(i, (i + 1), o_data))
				{
					i++;
					continue;
				}
				if((o_data.Level >= MaxLevel))
				{
					i++;
					continue;
				}
				index1 = i;
				index2 = (i + 1);
				return true;
				i++;
			}
			break;
		default:
			break;
	}
	return false;
}

function OnChangedLevel(UIControlNumberInputSteper mySelf)
{
	local int i;
	local ItemInfo iInfo;

	i = 0;
	while((i < InventoryItem.GetItemNum()))
	{
		InventoryItem.GetItem(i, iInfo);
		if(CheckNDisabledItem(iInfo))
		{
			InventoryItem.SetItem(i, iInfo);
		}
		i++;
	}
	return;
}

function bool CheckNDisabledItem(out ItemInfo iInfo)
{
	local int j, GroupID;
	local CombinationItemUIData o_data;
	local array<int> CandidateMaterials;

	if((API_GetEnchantCandidateMaterialList(iInfo.Id.ClassID, CandidateMaterials) == 0))
	{
		return false;
	}
	API_GetCombinationItemDataCurrent(o_data);
	if(((o_data.AutomaticType == 1) || (o_data.AutomaticType == 0)))
	{
		iInfo.bDisabled = 0;
		return true;
	}
	GroupID = o_data.GroupID;
	j = 0;
	while((j < CandidateMaterials.Length))
	{
		API_GetCombinationItemData(iInfo.Id.ClassID, iInfo.Enchanted, CandidateMaterials[j], 0, o_data);
		if((GroupID != o_data.GroupID))
		{
			j++;
			continue;
		}
		if((o_data.Level >= numberInputStepper._getEditNum()))
		{
			iInfo.bDisabled = 1;
		}
		else
		{
			iInfo.bDisabled = 0;
		}
		return true;
		j++;
	}
	return false;
}

function _SortItemInventory()
{
	local int i, InvenLimit;
	local ItemInfo item;
	local array<ItemInfo> ItemListAll;

	InvenLimit = InventoryItem.GetItemNum();
	i = 0;
	while((i < InvenLimit))
	{
		InventoryItem.GetItem(i, item);
		if(!IsValidItemID(item.Id))
		{
			++i;
			continue;
		}
		ItemListAll[ItemListAll.Length] = item;
		++i;
	}
	if((ItemListAll.Length > 0))
	{
		// ItemListAll.Sort(SortByLevelDelegate);   // array.Sort() unsupported by this compiler
	}
	ClearAutoJewelItemWindow();
	i = 0;
	while((i < ItemListAll.Length))
	{
		AddAutoJewelItemWindow(ItemListAll[i]);
		++i;
	}
	return;
}

function RemoveInventoryItem(int Index)
{
	if((GetStateName() != 'stateAllReady'))
	{
		return;
	}
	InventoryItem.DeleteItem(Index);
	if((InventoryItem.GetItemNum() == 0))
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoEnchant_wnd.InventoryDisable_Wnd")).ShowWindow();
	}
	RefreshSubWnd();
	return;
}

function AddInventoryItem(ItemInfo iInfo)
{
	local INT64 ItemNum;

	ItemNum = ItemJewelEnchantSubWndScript._GetIneventoryItemNum(iInfo);
	if((Class'NWindow.InputAPI'.static.IsAltPressed() || (ItemNum == INT64(1))))
	{
		ItemJewelEnchantSubWndScript._MoveToOwner(iInfo, ItemNum);
	}
	else
	{
		ShowDialog(iInfo);
	}
	return;
}

function _AddInventoryItem(ItemInfo iInfo)
{
	local int idx;
	local ItemInfo iiInfo;

	if(IsStackableItem(iInfo.ConsumeType))
	{
		idx = InventoryItem.FindItem(iInfo.Id);
		if((idx == -1))
		{
			AddAutoJewelItemWindow(iInfo);
		}
		else
		{
			InventoryItem.GetItem(idx, iiInfo);
			iiInfo.ItemNum = (iiInfo.ItemNum + iInfo.ItemNum);
			InventoryItem.SetItem(idx, iiInfo);
		}
	}
	else
	{
		AddAutoJewelItemWindow(iInfo);
	}
	return;
}

delegate int SortByLevelDelegate(ItemInfo aItemInfo, ItemInfo bItemInfo)
{
	local int j, Len;
	local CombinationItemUIData o_data, o_Datb;
	local array<int> CandidateMaterialsA, CandidateMaterialsB;

	if((API_GetEnchantCandidateMaterialList(aItemInfo.Id.ClassID, CandidateMaterialsA) == 0))
	{
		if((API_GetEnchantCandidateMaterialList(bItemInfo.Id.ClassID, CandidateMaterialsB) == 0))
		{
			return 0;
		}
		else
		{
			return -1;
		}
	}
	else if((API_GetEnchantCandidateMaterialList(bItemInfo.Id.ClassID, CandidateMaterialsB) == 0))
	{
		return 0;
	}
	Len = CandidateMaterialsA.Length;
	j = 0;
	while((j < Len))
	{
		if(!API_GetCombinationItemData(aItemInfo.Id.ClassID, aItemInfo.Enchanted, CandidateMaterialsA[j], 0, o_data))
		{
			return -1;
			j++;
			continue;
		}
		break;
		j++;
	}
	Len = CandidateMaterialsB.Length;
	j = 0;
	while((j < Len))
	{
		if(!API_GetCombinationItemData(bItemInfo.Id.ClassID, bItemInfo.Enchanted, CandidateMaterialsB[j], 0, o_Datb))
		{
			return 0;
			j++;
			continue;
		}
		break;
		j++;
	}
	if((o_Datb.Level < o_data.Level))
	{
		return -1;
	}
	return 0;
}

function ShowDialog_Wnd()
{
	local int i, j, Len;
	local ItemInfo iInfoA;
	local RichListCtrlRowData rowData;
	local array<ItemInfo> iInfos;
	local bool IsNew;

	numberInputStepper.checkMinMax();
	EnchantItemList_RichList.DeleteAllItem();
	iInfos[0] = jewel1ItemInfo;
	if(((jewel1ItemInfo.Id.ClassID == jewel2ItemInfo.Id.ClassID) && (jewel1ItemInfo.Enchanted == jewel2ItemInfo.Enchanted)))
	{
		iInfos[0].ItemNum = (jewel2ItemInfo.ItemNum + INT64(1));
	}
	else
	{
		iInfos[1] = jewel2ItemInfo;
	}
	Len = InventoryItem.GetItemNum();
	i = 0;
	while((i < Len))
	{
		InventoryItem.GetItem(i, iInfoA);
		IsNew = false;
		j = 0;
		while((j < iInfos.Length))
		{
			if(((iInfoA.Id.ClassID == iInfos[j].Id.ClassID) && (iInfoA.Enchanted == iInfos[j].Enchanted)))
			{
				iInfos[j].ItemNum = (iInfos[j].ItemNum + iInfoA.ItemNum);
				IsNew = true;
				break;
			}
			j++;
		}
		if(!IsNew)
		{
			iInfos[iInfos.Length] = iInfoA;
		}
		i++;
	}
	i = 0;
	while((i < iInfos.Length))
	{
		if(MakeRowData(iInfos[i], rowData))
		{
			EnchantItemList_RichList.InsertRecord(rowData);
		}
		i++;
	}
	Dialog_Wnd.ShowWindow();
	Dialog_Wnd.SetFocus();
	return;
}

function HideDialog_Wnd()
{
	Dialog_Wnd.HideWindow();
	return;
}

function bool MakeRowData(ItemInfo iInfo, out RichListCtrlRowData rowData)
{
	local RichListCtrlRowData newRowData;
	local string itemNameStr;
	local int validTextWidth, optionalTextWidth, optionalTextHeight;

	newRowData.cellDataList.Length = 1;
	iInfo.bShowCount = false;
	GetTextSizeDefault((((iInfo.AdditionalName @ iInfo.AdditionalName) @ "x") $ MakeCostStringINT64(iInfo.ItemNum)), optionalTextWidth, optionalTextHeight);
	validTextWidth = (320 - (optionalTextWidth + 6));
	itemNameStr = GetItemNameAll(iInfo, true);
	Class'InterfaceClassic.L2Util'.static.GetEllipsisString(itemNameStr, validTextWidth);
	addRichListCtrlTexture(newRowData.cellDataList[0].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, 0);
	AddRichListCtrlItem(newRowData.cellDataList[0].drawitems, iInfo, 32, 32, -34, 2);
	AddRichListCtrlString(newRowData.cellDataList[0].drawitems, itemNameStr, getInstanceL2Util().BrightWhite, false, 5, 8);
	AddRichListCtrlString(newRowData.cellDataList[0].drawitems, iInfo.AdditionalName, getInstanceL2Util().Yellow03, false, 5, 0);
	AddRichListCtrlString(newRowData.cellDataList[0].drawitems, ("x" $ MakeCostStringINT64(iInfo.ItemNum)), getInstanceL2Util().White, false, 5, 0);
	rowData = newRowData;
	return true;
}

function UIEventManager.ECombinationResultBlessType API_GetResultBlessType()
{
	return Class'NWindow.NewEnchantAPI'.static.GetResultBlessType(_GetClassIDBySlotItemIndex(1), _GetEnchantedBySlotItemIndex(1), _GetClassIDBySlotItemIndex(2), _GetEnchantedBySlotItemIndex(2));
}

function API_RequestClose()
{
	Class'NWindow.NewEnchantAPI'.static.RequestClose();
	return;
}

function API_RequestRemoveOne(ItemID iID)
{
	bRequestRemoveOne = true;
	Class'NWindow.NewEnchantAPI'.static.RequestRemoveOne(iID);
	return;
}

function API_RequestRemoveTwo(ItemID iID)
{
	bRequestRemoveTwo = true;
	Class'NWindow.NewEnchantAPI'.static.RequestRemoveTwo(iID);
	return;
}

function API_GetMaterialItemForEnchantFromInven(int OneSlotItemClassID, int OneSlotItemEnchant, int TwoSlotItemClassID, int TwoSlotItemEnchant, out INT64 Commission, out array<ItemInfo> MaterialItems)
{
	local int i;

	MaterialItems.Length = 0;
	if(getInstanceUIData().GetIsClassicServer())
	{
		Class'NWindow.NewEnchantAPI'.static.GetMaterialItemForEnchantFromInven(OneSlotItemClassID, OneSlotItemEnchant, TwoSlotItemClassID, TwoSlotItemEnchant, Commission, MaterialItems, 4);
	}
	else
	{
		Class'NWindow.NewEnchantAPI'.static.GetMaterialItemForEnchantFromInven(OneSlotItemClassID, OneSlotItemEnchant, TwoSlotItemClassID, TwoSlotItemEnchant, Commission, MaterialItems);
	}
	i = 0;
	while((i < MaterialItems.Length))
	{
		MaterialItems[i].bShowCount = IsStackableItem(MaterialItems[i].ConsumeType);
		i++;
	}
	return;
}

function API_RequestPushOne(ItemInfo iInfo, optional bool bNoRequestServer)
{
	if(!bNoRequestServer)
	{
		Class'NWindow.NewEnchantAPI'.static.RequestPushOne(iInfo.Id);
		bRequestPushOne = true;
	}
	jewel1ItemInfo = iInfo;
	jewel1ItemInfo.ItemNum = INT64(1);
	return;
}

function API_RequestPushTwo(ItemInfo iInfo, optional bool bNoRequestServer)
{
	if(!bRequestPushTwo)
	{
		jewel2ItemInfo = iInfo;
		jewel2ItemInfo.ItemNum = INT64(1);
	}
	if(!bNoRequestServer)
	{
		Class'NWindow.NewEnchantAPI'.static.RequestPushTwo(iInfo.Id);
		bRequestPushTwo = true;
	}
	Debug((("API_RequestPushTwo" @ jewel2ItemInfo.Name) @ string(jewel2ItemInfo.Id.ServerID)));
	return;
}

function API_RequestEnchantRetryPutItems(int serverID1, int serverID2)
{
	if(((serverID1 < 1) || (serverID2 < 1)))
	{
		HandleNewEnchantRetryPutItems(false);
		return;
	}
	bRequestedPushRetry = true;
	Class'NWindow.NewEnchantAPI'.static.RequestEnchantRetryPutItems(serverID1, serverID2);
	return;
}

function API_RequestTryEnchant()
{
	if(bRequestTryEnchant)
	{
		return;
	}
	bRequestTryEnchant = true;
	Class'NWindow.NewEnchantAPI'.static.RequestTryEnchant();
	return;
}

function int API_GetEnchantCandidateMaterialList(int ClassID, out array<int> CandidateMaterials)
{
	Class'NWindow.NewEnchantAPI'.static.GetEnchantCandidateMaterialList(ClassID, CandidateMaterials);
	return CandidateMaterials.Length;
}

function UIEventManager.ECombinationResultEffectType API_GetResultEffectTypeCurrent()
{
	return Class'NWindow.NewEnchantAPI'.static.GetResultEffectType(_GetClassIDBySlotItemIndex(1), _GetEnchantedBySlotItemIndex(1), _GetClassIDBySlotItemIndex(2), _GetEnchantedBySlotItemIndex(2));
}

function bool API_GetCombinationItemDataIndex(int index1, int index2, out CombinationItemUIData o_data)
{
	local ItemInfo iInfo, iiInfo;

	if(!InventoryItem.GetItem(index1, iInfo))
	{
		return false;
	}
	if(!InventoryItem.GetItem(index2, iiInfo))
	{
		return false;
	}
	return API_GetCombinationItemData(iInfo.Id.ClassID, iInfo.Enchanted, iiInfo.Id.ClassID, iiInfo.Enchanted, o_data);
}

function bool API_GetCombinationItemData(int classID1, int enchanted1, int classID2, int enchanted2, out CombinationItemUIData o_data)
{
	return Class'NWindow.NewEnchantAPI'.static.GetCombinationItemData(classID1, enchanted1, classID2, enchanted2, o_data);
}

function bool API_GetCombinationItemDataCurrent(out CombinationItemUIData o_data)
{
	return API_GetCombinationItemData(_GetClassIDBySlotItemIndex(1), _GetEnchantedBySlotItemIndex(1), _GetClassIDBySlotItemIndex(2), _GetEnchantedBySlotItemIndex(2), o_data);
}

function StopEffect()
{
	mainEffectViewport.SpawnEffect("");
	return;
}

function PlayEffectProgress()
{
	switch(GetProgressTIme())
	{
		case 700:
		case 1000:
			PlaySound("InterfaceSound.ui_synthesis_progress_long");
			break;
		case 100:
		case 150:
			PlaySound("InterfaceSound.ui_synthesis_progress_short");
			break;
		default:
			break;
	}
	mainEffectViewport.SpawnEffect("LineageEffect2.ui_compose_progress");
	mainEffectViewport.SetCameraDistance(104.0000000);
	return;
}

function PlayEffectSuccess()
{
	PlaySound("InterfaceSound.ui_synthesis_success");
	mainEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_success");
	mainEffectViewport.SetCameraDistance(104.0000000);
	return;
}

function PlayEffectFail()
{
	PlaySound("InterfaceSound.ui_synthesis_fail");
	mainEffectViewport.SpawnEffect("LineageEffect2.ui_upgrade_fail");
	mainEffectViewport.SetCameraDistance(248.0000000);
	return;
}

function PlayEffectStandBy()
{
	mainEffectViewport.SpawnEffect("LineageEffect2.ui_compose_standby");
	mainEffectViewport.SetCameraDistance(104.0000000);
	return;
}

function SetState(name Type)
{
	local ItemInfo iInfo;

	prevState = GetStateName();
	switch(Type)
	{
		case 'stateReady':
			break;
		case 'stateOneReady':
			if(!_GetSlot1ItemInfo(iInfo))
			{
				Type = 'stateReady';
			}
			break;
		case 'stateAllReady':
			break;
		case 'stateProcess':
			break;
		case 'StateResult':
			break;
		case 'stateAutoResult':
			break;
		default:
			break;
	}
	HandleStateBtnsEnd();
	GotoState(Type);
	HandleStateBtns();
	return;
}

function HandleStateBtns()
{
	switch(GetStateName())
	{
		case 'stateReady':
			EnchantBtn.ShowWindow();
			EnchantBtn.DisableWindow();
			continueBtn.HideWindow();
			nextBtn.HideWindow();
			InitBtn.DisableWindow();
			CancelBtn.SetNameText(GetSystemString(646));
			CancelBtn.EnableWindow();
			break;
		case 'stateOneReady':
			EnchantBtn.DisableWindow();
			continueBtn.HideWindow();
			nextBtn.HideWindow();
			InitBtn.EnableWindow();
			CancelBtn.SetNameText(GetSystemString(646));
			CancelBtn.EnableWindow();
			break;
		case 'stateAllReady':
			EnchantBtn.ShowWindow();
			if(UIControlNeedItemListObj.GetCanBuy())
			{
				EnchantBtn.EnableWindow();
			}
			else
			{
				EnchantBtn.DisableWindow();
			}
			continueBtn.HideWindow();
			nextBtn.HideWindow();
			InitBtn.EnableWindow();
			CancelBtn.SetNameText(GetSystemString(646));
			CancelBtn.EnableWindow();
			break;
		case 'stateProcess':
			if(!_IsAutoMode())
			{
				EnchantBtn.HideWindow();
				CheckNShowHideContinueBtn();
				continueBtn.DisableWindow();
				nextBtn.ShowWindow();
				nextBtn.DisableWindow();
			}
			else
			{
				EnchantBtn.DisableWindow();
			}
			CancelBtn.SetNameText(GetSystemString(141));
			CancelBtn.EnableWindow();
			InitBtn.DisableWindow();
			break;
		case 'StateResult':
			if(!_IsAutoMode())
			{
				CancelBtn.SetNameText(GetSystemString(646));
				CancelBtn.EnableWindow();
				InitBtn.EnableWindow();
			}
			break;
		case 'stateAutoResult':
			EnchantBtn.DisableWindow();
			InitBtn.EnableWindow();
			continueBtn.HideWindow();
			nextBtn.HideWindow();
			CancelBtn.SetNameText(GetSystemString(646));
			CancelBtn.EnableWindow();
			break;
		default:
			break;
	}
	return;
}

function CheckNShowHideContinueBtn()
{
	local CombinationItemUIData o_data;

	if(_IsAutoMode())
	{
		return;
	}
	API_GetCombinationItemDataCurrent(o_data);
	if((o_data.AutomaticType != 3))
	{
		nextBtn.SetAnchor(m_hOwnerWnd.m_WindowNameWithFullPath, "BottomCenter", "BottomLeft", 2, -3);
		continueBtn.ShowWindow();
	}
	else
	{
		nextBtn.SetAnchor(m_hOwnerWnd.m_WindowNameWithFullPath, "BottomCenter", "BottomCenter", 0, -3);
	}
	return;
}

function HandleStateBtnsEnd()
{
	switch(GetStateName())
	{
		case 'stateReady':
			break;
		case 'stateOneReady':
			break;
		case 'stateAllReady':
			break;
		case 'stateProcess':
			break;
		case 'StateResult':
			if(!_IsAutoMode())
			{
				EnchantBtn.ShowWindow();
			}
			break;
		case 'stateAutoResult':
			EnchantBtn.ShowWindow();
			break;
		default:
			break;
	}
	return;
}

function SetResultEffectType()
{
	if((GetResultEffectType() > 0))
	{
		Groupbox0_tex.SetTexture("L2UI_NewTex.ItemEnchantWnd.MainBg3");
	}
	else
	{
		Groupbox0_tex.SetTexture("L2UI_NewTex.ItemEnchantWnd.MainBg2");
	}
	return;
}

function int GetResultEffectType()
{
	local CombinationItemUIData o_data;

	API_GetCombinationItemDataCurrent(o_data);
	return o_data.ResultEffectType2;
}

function bool IsNoItemOnFail()
{
	return (int(API_GetResultEffectTypeCurrent()) == 2);
}

function bool IsExcptionWarning()
{
	local CombinationItemUIData o_data;

	API_GetCombinationItemDataCurrent(o_data);
	if(!IsAdenServer())
	{
		return false;
	}
	return ((((218 <= o_data.GroupID) && (o_data.GroupID <= 244)) || ((276 <= o_data.GroupID) && (o_data.GroupID <= 278))) || ((290 <= o_data.GroupID) && (o_data.GroupID <= 299)));
}

function CheckBtnsOnResult()
{
	local ItemInfo resultJewelItemInfo;
	local CombinationItemUIData o_data;

	if(_IsAutoMode())
	{
		return;
	}
	EnchantedItemSlot.GetItem(0, resultJewelItemInfo);
	API_GetCombinationItemDataCurrent(o_data);
	if((o_data.AutomaticType != 3))
	{
		if(ItemJewelEnchantSubWndScript._CheckCanEnchatItem(jewel1ItemInfo.Id.ClassID, jewel1ItemInfo.Enchanted))
		{
			continueBtn.EnableWindow();
		}
	}
	switch(o_data.AutomaticType)
	{
		case 1:
		case 0:
			return;
		case 2:
			if(GetResult(resultJewelItemInfo))
			{
				if(((jewel1ItemInfo.Id.ClassID != resultJewelItemInfo.Id.ClassID) || (jewel1ItemInfo.Enchanted != resultJewelItemInfo.Enchanted)))
				{
					if(ItemJewelEnchantSubWndScript._CheckCanEnchatItem(resultJewelItemInfo.Id.ClassID, resultJewelItemInfo.Enchanted))
					{
						nextBtn.EnableWindow();
					}
				}
			}
			break;
		case 3:
			if(ItemJewelEnchantSubWndScript._CheckCanEnchatItem(resultJewelItemInfo.Id.ClassID, resultJewelItemInfo.Enchanted))
			{
				nextBtn.EnableWindow();
			}
			break;
		default:
			break;
	}
	return;
}

function OnItemUpdateItem()
{
	if((GetStateName() == 'stateAllReady'))
	{
		if(UIControlNeedItemListObj.GetCanBuy())
		{
			EnchantBtn.EnableWindow();
		}
		else
		{
			EnchantBtn.DisableWindow();
		}
	}
	return;
}

function StateTxtWarningTxt()
{
	switch(GetStateName())
	{
		case 'stateAllReady':
		case 'stateProcess':
			switch(API_GetResultEffectTypeCurrent())
			{
				case CRET_NOFAIL:
					WarningTxt.SetText(GetSystemMessage(4424));
					break;
				case CRET_NONE:
					WarningTxt.SetText(GetSystemMessage(13922));
					break;
				case CRET_DEFAULT:
				case CRET_MAX:
				default:
					SetWarningTxtWithBless();
					break;
			}
			break;
		default:
			WarningTxt.SetText("");
	}
	return;
}

function SetWarningTxtWithBless()
{
	local string blessStringWithType;

	switch(API_GetResultBlessType())
	{
		case CRBT_BLESS_IGNORE:
			blessStringWithType = "";
			break;
		case CRBT_BLESS_KEEP_ALL:
			blessStringWithType = ("\\n" $ GetSystemString(14930));
			break;
		case CRBT_BLESS_KEEP_FAIL:
			blessStringWithType = ("\\n" $ GetSystemString(14932));
			break;
		case CRBT_BLESS_KEEP_SUCCESS:
			blessStringWithType = ("\\n" $ GetSystemString(14931));
			break;
		default:
			break;
	}
	WarningTxt.SetText((GetSystemMessage(4234) $ blessStringWithType));
	return;
}

function StateTxtInstructionTxt()
{
	InstructionTxt.SetTextColor(GetColor(187, 187, 187, 255));
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoEnchant_wnd.InventoryDisable_Wnd.descrip_text")).SetTextColor(GetColor(187, 187, 187, 255));
	switch(GetStateName())
	{
		case 'stateReady':
			InstructionTxt.SetText(GetSystemMessage(4232));
			InstructionTxt.SetTextColor(GetColor(255, 255, 187, 255));
			break;
		case 'stateOneReady':
			InstructionTxt.SetText(GetSystemString(3501));
			break;
		case 'stateAllReady':
			if(IsAdenServer())
			{
				InstructionTxt.SetText(GetSystemMessage(14622));
				InstructionTxt.SetTextColor(getInstanceL2Util().DRed);
			}
			else
			{
				InstructionTxt.SetText(GetSystemMessage(4233));
			}
			GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoEnchant_wnd.InventoryDisable_Wnd.descrip_text")).SetTextColor(GetColor(255, 255, 187, 255));
			break;
		case 'stateProcess':
			InstructionTxt.SetText("");
			break;
		case 'StateResult':
			if(!_IsAutoMode())
			{
				InstructionTxt.SetText(GetSystemString(14118));
			}
			break;
		case 'stateAutoResult':
			InstructionTxt.SetText(GetSystemString(14118));
			break;
		default:
			break;
	}
	return;
}

function ClearAutoJewelItemWindow()
{
	InventoryItem.Clear();
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoEnchant_wnd.InventoryDisable_Wnd")).ShowWindow();
	return;
}

function AddAutoJewelItemWindow(ItemInfo iInfo)
{
	CheckNDisabledItem(iInfo);
	InventoryItem.AddItem(iInfo);
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoEnchant_wnd.InventoryDisable_Wnd")).HideWindow();
	return;
}

function array<ItemInfo> GetDyeCombines(array<ItemInfo> iInfos)
{
	local int i;
	local DyeCombinationUIData o_data;
	local array<ItemInfo> dyeCombines;

	i = 0;
	while((i < iInfos.Length))
	{
		if(Class'NWindow.UIDATA_HENNA'.static.GetDyeCombinationData(iInfos[i].Id.ClassID, o_data))
		{
			dyeCombines[dyeCombines.Length] = iInfos[i];
		}
		i++;
	}
	return dyeCombines;
}

function CheckNRemoveSameClassid(int ClassID, int Enchanted, out array<ItemInfo> MaterialItems)
{
	local int i;

	i = 0;
	while((i < MaterialItems.Length))
	{
		if(((MaterialItems[i].Id.ClassID == ClassID) && (MaterialItems[i].Enchanted == Enchanted)))
		{
			MaterialItems[i].ItemNum = (MaterialItems[i].ItemNum - INT64(1));
			if((MaterialItems[i].ItemNum == INT64(0)))
			{
				MaterialItems.Remove(i, 1);
			}
			return;
		}
		i++;
	}
	return;
}

function GetClearItem(out ItemInfo iInfo)
{
	local ItemInfo ClearItemInfo;

	ClearItemID(ClearItemInfo.Id);
	ClearItemInfo.IconName = "L2ui_ct1.emptyBtn";
	iInfo = ClearItemInfo;
	return;
}

function InsertInventoryItemItemInfo(int Index, ItemInfo iInfo)
{
	local int i, Len;

	Len = InventoryItem.GetItemNum();
	AddAutoJewelItemWindow(iInfo);
	if((Index == -1))
	{
		return;
	}
	i = Len;
	while((i > Index))
	{
		InventoryItem.SwapItems(i, (i - 1));
		i--;
	}
	return;
}

function int FindLastInventoryItemIndexItemInfo(ItemInfo resultiInfo)
{
	local int i, Len, Level;
	local ItemInfo iiInfo;
	local CombinationItemUIData o_data;

	API_GetCombinationItemDataCurrent(o_data);
	Len = InventoryItem.GetItemNum();
	switch(o_data.AutomaticType)
	{
		case 1:
			if(IsStackableItem(resultiInfo.ConsumeType))
			{
				i = 0;
				while(InventoryItem.GetItem(i, iiInfo))
				{
					if(((resultiInfo.Id.ClassID == iiInfo.Id.ClassID) && (resultiInfo.Enchanted == iiInfo.Enchanted)))
					{
						resultiInfo.ItemNum = (iiInfo.ItemNum + resultiInfo.ItemNum);
						return i;
					}
					i++;
				}
			}
			return Len;
		case 0:
		case 3:
			return Len;
		case 2:
			break;
		default:
			break;
	}
	API_GetCombinationItemData(resultiInfo.Id.ClassID, resultiInfo.Enchanted, resultiInfo.Id.ClassID, resultiInfo.Enchanted, o_data);
	Level = o_data.Level;
	i = (Len - 1);
	while(InventoryItem.GetItem(i, iiInfo))
	{
		if(API_GetCombinationItemData(iiInfo.Id.ClassID, iiInfo.Enchanted, iiInfo.Id.ClassID, iiInfo.Enchanted, o_data))
		{
			if((Level >= o_data.Level))
			{
				if(((IsStackableItem(resultiInfo.ConsumeType) && (resultiInfo.Id.ClassID == iiInfo.Id.ClassID)) && (resultiInfo.Enchanted == iiInfo.Enchanted)))
				{
					return i;
				}
				return (i + 1);
			}
		}
		i--;
	}
	return 0;
}

function INT64 _GetIneventoryItemNum(ItemInfo iInfo)
{
	local int i, idx;
	local INT64 ItemNum;
	local ItemInfo iiInfo;

	if(IsStackableItem(iInfo.ConsumeType))
	{
		idx = InventoryItem.FindItem(iInfo.Id);
		if((idx == -1))
		{
			return INT64(0);
		}
		InventoryItem.GetItem(idx, iiInfo);
		return iiInfo.ItemNum;
	}
	else
	{
		i = 0;
		while((i < InventoryItem.GetItemNum()))
		{
			while(!InventoryItem.GetItem(idx, iiInfo))
			{
				idx++;
			}
			if((iInfo.Id.ClassID == iiInfo.Id.ClassID))
			{
				if((iInfo.Enchanted == iiInfo.Enchanted))
				{
					ItemNum = (ItemNum + INT64(1));
				}
			}
			i++;
		}
	}
	return ItemNum;
}

function bool _GetSlot1ItemInfo(out ItemInfo iInfo)
{
	return EnchantJewel1.GetItem(0, iInfo);
}

function bool _GetSlot2ItemInfo(out ItemInfo iInfo)
{
	return EnchantJewel2.GetItem(0, iInfo);
}

function bool GetPosItemWIndowWithIndex(int Index, out Rect invenRect)
{
	local bool isOut;
	local int colIndex, rowIndex, scrollPosition;

	invenRect = InventoryItem.GetRect();
	scrollPosition = InventoryItem.GetScrollPosition();
	colIndex = int((float(Index) % 12.0000000));
	rowIndex = Min(3, Max(-1, ((Index / 12) - scrollPosition)));
	invenRect.nX = ((invenRect.nX + (colIndex * 36)) + 1);
	invenRect.nY = ((invenRect.nY + (rowIndex * 36)) + 1);
	switch(rowIndex)
	{
		case -1:
			invenRect.nY = (invenRect.nY + 15);
			isOut = true;
			break;
		case 3:
			invenRect.nY = (invenRect.nY - 15);
			isOut = true;
			break;
		default:
			break;
	}
	return isOut;
}

function TweenAdd(WindowHandle targetWnd, int TargetAlpha, int Id, int Duration, int nX, int nY, L2UITween.easeType Type, optional float Delay)
{
	local L2UITween.TweenObject tweenObjectData;

	tweenObjectData.Owner = m_hOwnerWnd.m_WindowNameWithFullPath;
	tweenObjectData.Id = Id;
	tweenObjectData.Target = targetWnd;
	tweenObjectData.Duration = float(Duration);
	tweenObjectData.Alpha = float(TargetAlpha);
	tweenObjectData.ease = easeType(Type);
	tweenObjectData.MoveX = float(nX);
	tweenObjectData.MoveY = float(nY);
	tweenObjectData.Delay = Delay;
	TweenStop(Id);
	Class'InterfaceClassic.L2UITween'.static.Inst().AddTweenObject(tweenObjectData);
	return;
}

function TweenStop(int Id)
{
	Class'InterfaceClassic.L2UITween'.static.Inst().StopTween(m_hOwnerWnd.m_WindowNameWithFullPath, Id);
	return;
}

function SetUIControlNumberInputSteper()
{
	local CombinationItemUIData o_data;

	API_GetCombinationItemDataCurrent(o_data);
	if(((o_data.AutomaticType == 1) || (o_data.AutomaticType == 0)))
	{
		numberInputStepper._SetDisable(true);
	}
	else
	{
		if((o_data.MaxLevel == 0))
		{
			GetTextBoxHandle((numberInputStepper.m_hOwnerWnd.m_WindowNameWithFullPath $ ".PlusText_txt")).HideWindow();
			GetEditBoxHandle((numberInputStepper.m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemCount_EditBox")).HideWindow();
			numberInputStepper._SetDisable(true);
		}
		else
		{
			GetTextBoxHandle((numberInputStepper.m_hOwnerWnd.m_WindowNameWithFullPath $ ".PlusText_txt")).ShowWindow();
			GetEditBoxHandle((numberInputStepper.m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemCount_EditBox")).ShowWindow();
			numberInputStepper._SetDisable(false);
		}
		numberInputStepper._setRangeMinMaxNum((o_data.Level + 1), (o_data.MaxLevel + 1));
		switch(prevState)
		{
			case 'stateProcess':
			case 'StateResult':
				break;
			default:
				numberInputStepper._setEditNum((o_data.MaxLevel + 1));
				break;
		}
	}
	return;
}

function RQ_C_EX_COMBINATION_PROB_LIST()
{
	local ItemInfo info1, info2;
	local array<byte> stream;
	local UIPacket._C_EX_COMBINATION_PROB_LIST packet;

	if(!_GetSlot1ItemInfo(info1))
	{
		return;
	}
	if(!_GetSlot2ItemInfo(info2))
	{
		return;
	}
	packet.nOneSlotServerID = info1.Id.ServerID;
	packet.nTwoSlotServerID = info2.Id.ServerID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_COMBINATION_PROB_LIST(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(901, stream);
	return;
}

function RT_S_EX_COMBINATION_PROB_LIST()
{
	local ItemInfo info1, info2;
	local string Prob;
	local UIPacket._S_EX_COMBINATION_PROB_LIST packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_COMBINATION_PROB_LIST(packet))
	{
		return;
	}
	_GetSlot1ItemInfo(info1);
	_GetSlot2ItemInfo(info2);
	if((packet.nOneSlotServerID != info1.Id.ServerID))
	{
		return;
	}
	if((packet.nTwoSlotServerID != info2.Id.ServerID))
	{
		return;
	}
	if((EventProb > 0))
	{
		Prob = string(EventProb);
	}
	else
	{
		Prob = string(packet.nProb);
	}
	ProbTxt.SetText(((GetSystemString(642) @ ":") @ Class'InterfaceClassic.L2Util'.static.Inst().MakeDecimalPointString(Prob, 4, true, true)));
	return;
}

function int _GetClassIDBySlotItemIndex(int SlotIndex)
{
	local ItemInfo Info;

	switch(SlotIndex)
	{
		case 1:
			if(!_GetSlot1ItemInfo(Info))
			{
				return -1;
			}
			break;
		case 2:
			if(!_GetSlot2ItemInfo(Info))
			{
				return -1;
			}
			break;
		default:
			break;
	}
	return Info.Id.ClassID;
}

function int _GetServerIDBySlotItemIndex(int SlotIndex)
{
	local ItemInfo Info;

	switch(SlotIndex)
	{
		case 1:
			if(!_GetSlot1ItemInfo(Info))
			{
				return -1;
			}
			break;
		case 2:
			if(!_GetSlot2ItemInfo(Info))
			{
				return -1;
			}
			break;
		default:
			break;
	}
	return Info.Id.ServerID;
}

function int _GetEnchantedBySlotItemIndex(int SlotIndex)
{
	local ItemInfo Info;

	if((SlotIndex == 1))
	{
		_GetSlot1ItemInfo(Info);
	}
	else
	{
		_GetSlot2ItemInfo(Info);
	}
	return Info.Enchanted;
}

function ToggleShowWindow(optional EnchantType Type)
{
	if(m_hOwnerWnd.IsShowWindow())
	{
		m_hOwnerWnd.HideWindow();
	}
	else if(!ItemEnchantWnd(GetScript("ItemEnchantWnd")).bIsShopping)
	{
		currentEnchantType = Type;
		m_hOwnerWnd.ShowWindow();
	}
	return;
}

function _HandleDropedItem(ItemInfo a_itemInfo)
{
	local ItemInfo tmpJewelItemInfo1, tmpJewelItemInfo2;

	_GetSlot1ItemInfo(tmpJewelItemInfo1);
	_GetSlot2ItemInfo(tmpJewelItemInfo2);
	currentEnchantType = Normal;
	if((_IsWorkingEnchant() && m_hOwnerWnd.IsShowWindow()))
	{
		return;
	}
	if((IsSameItemID(tmpJewelItemInfo1.Id, a_itemInfo.Id) || IsSameItemID(tmpJewelItemInfo2.Id, a_itemInfo.Id)))
	{
		return;
	}
	if((tmpJewelItemInfo1.Id.ServerID == 0))
	{
		API_RequestPushOne(a_itemInfo);
	}
	else
	{
		API_RequestPushTwo(a_itemInfo);
	}
	return;
}

function OnReceivedCloseUI()
{
	if(bPausedAuto)
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		m_hOwnerWnd.HideWindow();
		return;
	}
	switch(GetStateName())
	{
		case 'StateResult':
			if(_IsAutoMode())
			{
				StateFuncOnCclickEnchantBtn();
			}
			else
			{
				PlayConsoleSound(IFST_WINDOW_CLOSE);
				m_hOwnerWnd.HideWindow();
			}
			break;
		case 'stateProcess':
			SetState('stateAllReady');
			break;
		default:
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			m_hOwnerWnd.HideWindow();
			break;
	}
	return;
}

auto state stateBegin
{
	function EndState()
	{
		EnchantJewel1DeleteItem();
		EnchantJewel2DeleteItem();
		EnchantedItemSlotDelete();
		numberInputStepper._setRangeMinMaxNum(1, 1);
		numberInputStepper._setEditNum(1);
		numberInputStepper._SetDisable(true);
		m_hItemEnchantWndEnchantProgress.SetPos(0);
		m_hItemEnchantWndEnchantProgress.Reset();
		DropHighlight_EnchantJewel1.SetTexture("L2UI_NewTex.ItemEnchantWnd.EnchantSlotEffect2_64");
		DropHighlight_EnchantJewel2.SetTexture("L2UI_NewTex.ItemEnchantWnd.EnchantSlotEffect2_64");
		EnchantedItemSlot.HideWindow();
		EnchantedJewelBackTex.HideWindow();
		return;
	}
}

state stateReady
{
	function BeginState()
	{
		Groupbox0_tex.SetTexture("L2UI_NewTex.ItemEnchantWnd.MainBg2");
		GetWindowHandle("ItemJewelEnchantSubWnd").ShowWindow();
		EnchantJewel1DeleteItem();
		EnchantJewel2DeleteItem();
		ClearAutoJewelItemWindow();
		StateTxtWarningTxt();
		StateTxtInstructionTxt();
		DropHighlight_EnchantJewel1.SetTexture("L2UI_NewTex.ItemEnchantWnd.EnchantSlotEffect1_64");
		PlayEffectStandBy();
		numberInputStepper._setRangeMinMaxNum(1, 1);
		return;
	}

	function EndState()
	{
		DropHighlight_EnchantJewel1.SetTexture("L2UI_NewTex.ItemEnchantWnd.EnchantSlotEffect2_64");
		return;
	}

	function StateFuncOnCclickCancelBtn()
	{
		m_hOwnerWnd.HideWindow();
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		return;
	}
}

state stateOneReady
{
	function BeginState()
	{
		Groupbox0_tex.SetTexture("L2UI_NewTex.ItemEnchantWnd.MainBg2");
		StateTxtWarningTxt();
		StateTxtInstructionTxt();
		DropHighlight_EnchantJewel2.SetTexture("L2UI_NewTex.ItemEnchantWnd.EnchantSlotEffect1_64");
		return;
	}

	function EndState()
	{
		DropHighlight_EnchantJewel2.SetTexture("L2UI_NewTex.ItemEnchantWnd.EnchantSlotEffect2_64");
		return;
	}

	function StateFuncOnCclickCancelBtn()
	{
		m_hOwnerWnd.HideWindow();
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		return;
	}
}

state stateAllReady
{
	function BeginState()
	{
		GetWindowHandle("ItemJewelEnchantSubWnd").ShowWindow();
		SetUIControlNumberInputSteper();
		bPausedAuto = false;
		StateTxtInstructionTxt();
		SetResultEffectType();
		return;
	}

	function EndState()
	{
		Groupbox0_tex.SetTexture("L2UI_NewTex.ItemEnchantWnd.MainBg2");
		numberInputStepper._SetDisable(true);
		return;
	}

	function StateFuncOnCclickEnchantBtn()
	{
		if(!BRequesteEnd())
		{
			return;
		}
		if(IsExcptionWarning())
		{
			ShowWarningDialog(GetSystemMessage(13907));
		}
		else if(IsNoItemOnFail())
		{
			ShowWarningDialog(GetSystemMessage(13923));
		}
		else if(_IsAutoMode())
		{
			ShowDialog_Wnd();
		}
		else
		{
			SetState('stateProcess');
			PlayEffectProgress();
		}
		return;
	}

	function StateFuncOnCclickCancelBtn()
	{
		m_hOwnerWnd.HideWindow();
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		return;
	}
}

state stateProcess
{
	function BeginState()
	{
		DisableTransformAutosNCheckBox();
		StateTxtWarningTxt();
		StateTxtInstructionTxt();
		m_hItemEnchantWndEnchantProgress.SetProgressTime(GetProgressTIme());
		m_hItemEnchantWndEnchantProgress.Start();
		if(_IsAutoMode())
		{
			ItemJewelEnchantSubWndScript.m_hOwnerWnd.HideWindow();
		}
		SetResultEffectType();
		return;
	}

	function EndState()
	{
		EnableTransformAutosNCheckBox();
		m_hItemEnchantWndEnchantProgress.Stop();
		m_hItemEnchantWndEnchantProgress.SetPos(0);
		m_hItemEnchantWndEnchantProgress.Reset();
		uiTimerObj._Stop();
		Groupbox0_tex.SetTexture("L2UI_NewTex.ItemEnchantWnd.MainBg2");
		return;
	}

	function StateFuncWarningTxt()
	{
		WarningTxt.SetText("");
		return;
	}

	function StateFuncOnCclickCancelBtn()
	{
		if(!BRequesteEnd())
		{
			return;
		}
		SetState('stateAllReady');
		ItemJewelEnchantSubWndScript.m_hOwnerWnd.ShowWindow();
		PlayEffectStandBy();
		return;
	}
}

state StateResult
{
	function BeginState()
	{
		local CombinationItemUIData o_data;
		local ItemInfo resultJewelItemInfo;

		DisableTransformAutosNCheckBox();
		bPausedAuto = false;
		EnchantJewel1.HideWindow();
		EnchantJewel2.HideWindow();
		ProbTxt.SetText("");
		EnchantJewel1BackTex.HideWindow();
		dropResult_AniTex1.HideWindow();
		EnchantJewel2BackTex.HideWindow();
		dropResult_AniTex2.HideWindow();
		if(_IsAutoMode())
		{
			EnchantedItemSlot.GetItem(0, resultJewelItemInfo);
			if(GetResult(resultJewelItemInfo))
			{
				API_GetCombinationItemDataCurrent(o_data);
				if((o_data.Level == (numberInputStepper._getEditNum() - 1)))
				{
					InitBtn.EnableWindow();
					getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13726));
					CancelBtn.SetNameText(GetSystemString(646));
					autoProcessStepType = resultBylevel;
					return;
				}
			}
			autoProcessStepType = non;
		}
		else
		{
			Groupbox0_tex.SetTexture("L2UI_NewTex.ItemEnchantWnd.MainBg4");
			CancelBtn.SetNameText(GetSystemString(646));
		}
		return;
	}

	function EndState()
	{
		EnableTransformAutosNCheckBox();
		EnchantedItemSlotDelete();
		EnchantJewel1.ShowWindow();
		EnchantJewel2.ShowWindow();
		if(!_IsAutoMode())
		{
			ProbTxt.SetText("");
		}
		Groupbox0_tex.SetTexture("L2UI_NewTex.ItemEnchantWnd.MainBg2");
		return;
	}

	function StateFuncOnCclickCancelBtn()
	{
		if(((int(autoProcessStepType) == 8) || !_IsAutoMode()))
		{
			m_hOwnerWnd.HideWindow();
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			return;
		}
		bPausedAuto = true;
		CancelBtn.SetNameText(GetSystemString(14173));
		CancelBtn.DisableWindow();
		return;
	}
}

state stateAutoResult
{
	function BeginState()
	{
		DisableTransformAutosNCheckBox();
		autoProcessStepType = non;
		uiTimerObj._Pause();
		EnchantJewel1.HideWindow();
		EnchantJewel2.HideWindow();
		ProbTxt.SetText("");
		CheckBtnsOnResult();
		StateTxtInstructionTxt();
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13726));
		Groupbox0_tex.SetTexture("L2UI_NewTex.ItemEnchantWnd.MainBg4");
		return;
	}

	function EndState()
	{
		Groupbox0_tex.SetTexture("L2UI_NewTex.ItemEnchantWnd.MainBg2");
		GetTextBoxHandle((numberInputStepper.m_hOwnerWnd.m_WindowNameWithFullPath $ ".PlusText_txt")).ShowWindow();
		GetEditBoxHandle((numberInputStepper.m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemCount_EditBox")).ShowWindow();
		EnableTransformAutosNCheckBox();
		EnchantedItemSlot.HideWindow();
		EnchantedJewelBackTex.HideWindow();
		ProbTxt.SetText("");
		return;
	}

	function StateFuncOnCclickCancelBtn()
	{
		m_hOwnerWnd.HideWindow();
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		return;
	}
}
