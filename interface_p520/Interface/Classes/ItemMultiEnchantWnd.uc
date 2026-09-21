class ItemMultiEnchantWnd extends UICommonAPI
	dependson(UIPacket);

const STATE_NONE = 'stateNone';
const STATE_READY_SCROLL = 'stateReadyScroll';
const STATE_READY_EQUIPMENT = 'stateReadyEquipment';
const STATE_ENCHANT = 'stateEnchant';
const STATE_COMPLETE_BLIND = 'stateCompleteBlind';
const STATE_COMPLETE_RESULT = 'stateCompleteResult';
const TIME_EMPTY = 250;
const TIME_ACTIVE = 2000;
const MAX_SLOT = 15;
const MAX_TRY = 50;
const PERMRIAD = 100f;

enum slotRequestedType
{
	Add,                            // 0
	Remove,                         // 1
	refresh                         // 2
};

enum slotStateEnum
{
	non,                            // 0
	active,                         // 1
	resultSuccess,                  // 2
	resultFail                      // 3
};

enum slotProgress
{
	non,                            // 0
	Gray,                           // 1
	Blue,                           // 2
	Red                             // 3
};

struct requestedEquipmentItemInfoStruct
{
	var slotRequestedType Type;
	var int Index;
	var ItemInfo iInfo;
};

var name prevState;
var TextBoxHandle InstructionTxt;
var ButtonHandle EnchantBtn;
var ButtonHandle resetBtn;
var ItemWindowHandle scrollItemWindow;
var RichListCtrlHandle resultFailList_RichList;
var EffectViewportWndHandle EnchantEffectViewport;
var bool bUseLateAnnounce;
var requestedEquipmentItemInfoStruct requestedEqupmentItemInfo;
var L2UITimerObject timerObj;
var array<ItemInfo> failedItemList;
var array<ItemInfo> changePointList;
var int currentEnchantTarget;
var array<slotStateEnum> slotStates;
var array<slotProgress> slotProgresss;
var UIControlNumberInputSteper numberInputStepper;
var ItemEnchantGroupIDWnd groupIDWndScr;

function HandleClickButtonEnchant()
{
	return;
}

static function ItemMultiEnchantWnd Inst()
{
	return ItemMultiEnchantWnd(GetScript("ItemMultiEnchantWnd"));
}

function InitUIControlNumberInputSteper()
{
	numberInputStepper = Class'Interface.UIControlNumberInputSteper'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSystem_Wnd.EnchantGoalSet_wndAsset")));
	numberInputStepper.DelegateOnChangeEditBox = ChangeTargetEnchant;
	numberInputStepper.DelegateESCKey = OnReceivedCloseUI;
	numberInputStepper.m_hOwnerWnd.ShowWindow();
	numberInputStepper._SetDisable(true);
	numberInputStepper._setRangeMinMaxNum(0, 50);
	numberInputStepper._setMaxLength(2);
	return;
}

event OnProgressTimeUp(string strID)
{
	EndProgress();
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	InitUIControlNumberInputSteper();
	slotStates.Length = 15;
	slotProgresss.Length = 15;
	scrollItemWindow = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSystem_Wnd.ScrollItem_ItemWnd"));
	resultFailList_RichList = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ResultFailItem_Wnd.resultFailList_RichList"));
	InstructionTxt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSlot_Wnd.Descrip_text"));
	EnchantBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Enchant_Btn"));
	resetBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Reset_Btn"));
	numberInputStepper._setEditNum(1);
	currentEnchantTarget = 1;
	EnchantEffectViewport = GetEffectViewportWndHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectViewport"));
	EnchantEffectViewport.SetCameraPitch(0);
	EnchantEffectViewport.SetCameraYaw(0);
	SetGrouIDWnd();
	GotoState('stateNone');
	timerObj = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject(2000);
	timerObj._DelegateOnEnd = DelayGotoToStateCompleteREsult;
	return;
}

function SetGrouIDWnd()
{
	groupIDWndScr = ItemEnchantGroupIDWnd(GetScript("GroupIDWnd_ItemMultiEnchantWnd"));
	groupIDWndScr._Init();
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(50);
	RegisterEvent(EV_PacketID(999));
	RegisterEvent(EV_PacketID(1000));
	RegisterEvent(EV_PacketID(1001));
	RegisterEvent(EV_PacketID(995));
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case 50:
			m_hOwnerWnd.HideWindow();
			break;
		case EV_PacketID(999):
			RT_S_EX_RES_SELECT_MULTI_ENCHANT_SCROLL();
			break;
		case EV_PacketID(1000):
			RT_S_EX_RES_SET_MULTI_ENCHANT_ITEM_LIST();
			break;
		case EV_PacketID(1001):
			RT_S_EX_RES_MULTI_ENCHANT_ITEM_LIST();
			break;
		case EV_PacketID(995):
			RT_S_EX_CHANGED_ENCHANT_TARGET_ITEM_PROB_LIST();
			break;
		default:
			break;
	}
	return;
}

event OnDropItemWithHandle(WindowHandle hTarget, ItemInfo infItem, int X, int Y)
{
	switch(infItem.DragSrcName)
	{
		case "itemEnchantSubWndItemWnd":
			_HandleOnDrop(infItem);
			break;
		case "Enchant_ItemWnd":
			OnDBClickItemWithHandle(ItemWindowHandle(hTarget), 0);
			break;
		default:
			break;
	}
	return;
}

event OnRClickItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
	OnDBClickItemWithHandle(a_hItemWindow, a_Index);
	return;
}

event OnDBClickItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
	if((GetStateName() == 'stateReadyEquipment'))
	{
		if((a_hItemWindow.GetWindowName() == "Enchant_ItemWnd"))
		{
			ClearItem(int(Right(a_hItemWindow.GetParentWindowName(), 2)));
		}
	}
	return;
}

function _HandleOnDrop(ItemInfo a_itemInfo)
{
	switch(GetStateName())
	{
		case 'stateReadyScroll':
			RQ_C_EX_REQ_START_MULTI_ENCHANT_SCROLL(a_itemInfo);
			break;
		case 'stateReadyEquipment':
			SetSlotEmpty(a_itemInfo);
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "Enchant_Btn":
			HandleClickButtonEnchant();
			break;
		case "Reset_Btn":
			if(DialogIsMine())
			{
				DialogHide();
			}
			GotoState('stateReadyScroll');
			break;
		case "ItemEnchantWndTap_Btn":
			SwapItemEnchantWnd();
			break;
		case "point_btn":
			groupIDWndScr._ToggleShowHide();
			ChkWindowSizeGroupID();
			break;
		case "WndClose_BTN":
			m_hOwnerWnd.HideWindow();
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	m_hOwnerWnd.SetFocus();
	GotoState('stateReadyScroll');
	switch(DialogGetID())
	{
		case 1111:
		case 2222:
		case 3333:
		case 4444:
		case 5555:
		case 6666:
		case 7777:
		case 8888:
		case 9998:
		case 9999:
		case 10000:
			DialogHide();
			break;
		default:
			break;
	}
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemEnchantWndTap_Btn")).EnableWindow();
	GetEffectViewportWndHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollBG_EffectViewport")).SpawnEffect("LineageEffect2.ui_Enchant_item_select");
	groupIDWndScr._CheckShowHide();
	m_hOwnerWnd.SetWindowSize(858, 542);
	ChkWindowSizeGroupID();
	numberInputStepper._setEditNum(1);
	m_hOwnerWnd.DisableTick();
	StopProgress();
	return;
}

function ChkWindowSizeGroupID()
{
	if(groupIDWndScr.m_hOwnerWnd.IsShowWindow())
	{
		GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Point_txt")).SetText(GetSystemString(14016));
	}
	else
	{
		GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Point_txt")).SetText(GetSystemString(14015));
	}
	return;
}

event OnHide()
{
	NoticeWnd(GetScript("NoticeWnd"))._CreateCollectionButtonBlind();
	GotoState('stateNone');
	RQ_C_EX_REQ_FINISH_MULTI_ENCHANT_SCROLL();
	numberInputStepper._SetDisable(true);
	if(DialogIsMine())
	{
		DialogHide();
	}
	return;
}

event OnTick()
{
	currentEnchantTarget++;
	StartProgress();
	m_hOwnerWnd.DisableTick();
	return;
}

function HandleShowDialog()
{
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, ((GetFailString() $ "\\n\\n") $ GetSystemString(2336)));
	Class'Interface.DialogBox'.static.Inst().AnchorToOwner(0, 200);
	Class'Interface.DialogBox'.static.Inst().DelegateOnCancel = DialogResultCancel;
	Class'Interface.DialogBox'.static.Inst().DelegateOnOK = DialogResultOK;
	Class'Interface.DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
	return;
}

function DialogResultOK()
{
	GotoState('stateEnchant');
	return;
}

function DialogResultCancel()
{
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Dialog_Wnd")).HideWindow();
	m_hOwnerWnd.SetFocus();
	resetBtn.EnableWindow();
	EnchantBtn.EnableWindow();
	return;
}

function string GetFailString()
{
	local int i;
	local string crashString;
	local array<string> crashStrings;

	if(IsBreakable())
	{
		if(IsFailureCrush())
		{
			if(IsInova())
			{
				crashStrings[crashStrings.Length] = GetSystemString(5978);
			}
			else
			{
				crashStrings[crashStrings.Length] = GetSystemString(3338);
			}
		}
		if(IsFailureMaintain())
		{
			if(IsInova())
			{
				crashStrings[crashStrings.Length] = GetSystemString(5980);
			}
			else
			{
				crashStrings[crashStrings.Length] = GetSystemString(2275);
			}
		}
		if(((crashStrings.Length == 0) && (GetFailureDecrease() == 0)))
		{
			crashString = GetSystemMessage(4144);
		}
		else
		{
			crashString = crashStrings[0];
			i = 1;
			while((i < crashStrings.Length))
			{
				crashString = ((crashString $ ",") @ crashStrings[i]);
				i++;
			}
			if((GetFailureDecrease() == 0))
			{
				crashString = MakeFullSystemMsg(GetSystemMessage(13626), crashString);
			}
			else if((crashString == ""))
			{
				crashString = MakeFullSystemMsg(GetSystemMessage(13627), string(GetFailureDecrease()));
			}
			else
			{
				crashString = MakeFullSystemMsg(GetSystemMessage(13628), crashString, string(GetFailureDecrease()));
			}
		}
	}
	return crashString;
}

function RemoveFailedItems()
{
	local int i;
	local ItemInfo iInfo;
	local string Path;

	i = 0;
	while((i < 15))
	{
		if(!GetItemInfoEquipment(i, iInfo))
		{
			i++;
			continue;
		}
		if((int(slotStates[i]) == 3))
		{
			Path = getSlotPath(i);
			GetAnimTextureHandle((Path $ ".EnchantSlotProgress_ani")).HideWindow();
			GetItemWindowHandle((Path $ ".Enchant_ItemWnd")).Clear();
			GetTextBoxHandle((Path $ ".probability_text")).HideWindow();
		}
		i++;
	}
	return;
}

function StartProgress()
{
	local ProgressCtrlHandle StepBar_Progress;

	if(!m_hOwnerWnd.IsShowWindow())
	{
		return;
	}
	SetCurrentProgress();
	StepBar_Progress = GetProgressCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSystem_Wnd.StepBar_Progress"));
	if(IsInActive())
	{
		PlaySound("Itemsound3.ui_multienchant_progress");
		StepBar_Progress.SetProgressTime(2000);
	}
	else
	{
		PlaySound("Itemsound3.ui_multienchant_progress_Vshort");
		StepBar_Progress.SetProgressTime(250);
	}
	StepBar_Progress.Reset();
	StepBar_Progress.Start();
	return;
}

function SetCurrentProgress()
{
	local int i;
	local ItemInfo iInfo;

	SetCurrentEnchantTarget(currentEnchantTarget);
	i = 0;
	while((i < 15))
	{
		if(!GetItemInfoEquipment(i, iInfo))
		{
			i++;
			continue;
		}
		if((int(slotStates[i]) == 3))
		{
			i++;
			continue;
		}
		setSlotState(i, active, iInfo);
		i++;
	}
	return;
}

function EndProgress()
{
	StopProgress();
	if(IsInActive())
	{
		RQ_C_EX_REQ_MULTI_ENCHANT_ITEM_LIST();
		GetAnimTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSystem_Wnd.NextStepAni_tex")).Play();
	}
	else
	{
		m_hOwnerWnd.EnableTick();
	}
	return;
}

function StopProgress()
{
	GetProgressCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSystem_Wnd.StepBar_Progress")).Reset();
	return;
}

function ResetProgressStates()
{
	local int i;

	i = 0;
	while((i < 15))
	{
		slotProgresss[i] = non;
		i++;
	}
	return;
}

function SwapItemEnchantWnd()
{
	local ItemInfo iInfo;

	getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "ItemEnchantWnd");
	GetWindowHandle("ItemEnchantWnd").ShowWindow();
	m_hOwnerWnd.HideWindow();
	if(GetIteminfoScroll(iInfo))
	{
		Class'Interface.ItemEnchantWnd'.static.Inst().API_RequestExAddEnchantScrollItem(iInfo);
	}
	return;
}

function bool IsGreateSuccessEffectWithResultList(ItemInfo scrolliInfo, int targetEnchant, array<UIPacket._EnchantSuccessItem> successItemLists, array<UIPacket._EnchantFailItem> failedItemList)
{
	local array<EnchantScrollSetUIData> enchantScrollSetUIDatas;
	local EnchantScrollSetUIData oneEnchantScrollSetUIData;
	local ItemInfo iInfo;
	local int i, Index, minGreateSuccessEffect;

	minGreateSuccessEffect = 9999999;
	i = 0;
	while((i < successItemLists.Length))
	{
		Index = FindIndexEquipmentWithServerID(successItemLists[i].nItemSid);
		if(GetItemInfoEquipment(Index, iInfo))
		{
			Class'NWindow.UIDATA_ITEM'.static.GetEnchantScrollSetData(scrolliInfo.Id.ClassID, iInfo.Id.ClassID, oneEnchantScrollSetUIData);
			enchantScrollSetUIDatas[enchantScrollSetUIDatas.Length] = oneEnchantScrollSetUIData;
		}
		i++;
	}
	i = 0;
	while((i < failedItemList.Length))
	{
		Index = FindIndexEquipmentWithServerID(failedItemList[i].nItemSid);
		if(GetItemInfoEquipment(Index, iInfo))
		{
			Class'NWindow.UIDATA_ITEM'.static.GetEnchantScrollSetData(scrolliInfo.Id.ClassID, iInfo.Id.ClassID, oneEnchantScrollSetUIData);
			enchantScrollSetUIDatas[enchantScrollSetUIDatas.Length] = oneEnchantScrollSetUIData;
		}
		i++;
	}
	i = 0;
	while((i < enchantScrollSetUIDatas.Length))
	{
		if((int(enchantScrollSetUIDatas[i].GreatSuccessEffect) == -1))
		{
			i++;
			continue;
		}
		minGreateSuccessEffect = Min(minGreateSuccessEffect, int(enchantScrollSetUIDatas[i].GreatSuccessEffect));
		i++;
	}
	return (minGreateSuccessEffect <= targetEnchant);
}

function bool IsGreateSuccessEffect(int targetEnchant)
{
	local int i, minGreateSuccessEffect;
	local array<EnchantScrollSetUIData> enchantScrollSetDatas;

	minGreateSuccessEffect = 99999999;
	enchantScrollSetDatas = API_GetEnchantScrollSetDataS();
	i = 0;
	while((i < enchantScrollSetDatas.Length))
	{
		if((int(enchantScrollSetDatas[i].GreatSuccessEffect) == -1))
		{
			i++;
			continue;
		}
		minGreateSuccessEffect = Min(minGreateSuccessEffect, int(enchantScrollSetDatas[i].GreatSuccessEffect));
		i++;
	}
	return (minGreateSuccessEffect <= targetEnchant);
}

function bool IsSuccess()
{
	local int i;

	i = 0;
	while((i < 15))
	{
		switch(slotStates[i])
		{
			case resultSuccess:
				return true;
			default:
				i++;
		}
	}
	return false;
}

function bool IsBreakable()
{
	return (numberInputStepper._getEditNum() > GetFailureBase());
}

function int GetFailureBase()
{
	local int i, minFailureBase;
	local array<EnchantScrollSetUIData> enchantScrollSetDatas;

	enchantScrollSetDatas = API_GetEnchantScrollSetDataS();
	minFailureBase = 999999999;
	i = 0;
	while((i < enchantScrollSetDatas.Length))
	{
		if((int(enchantScrollSetDatas[i].GreatSuccessEffect) == -1))
		{
			i++;
			continue;
		}
		minFailureBase = Min(minFailureBase, int(enchantScrollSetDatas[i].FailureBase));
		i++;
	}
	return minFailureBase;
}

function int GetFailureDecrease()
{
	local array<EnchantScrollSetUIData> enchantScrollSetUIDatas;

	enchantScrollSetUIDatas = API_GetEnchantScrollSetDataS();
	return int(enchantScrollSetUIDatas[0].FailureDecrease);
}

function bool IsFailureMaintain()
{
	local array<EnchantScrollSetUIData> enchantScrollSetUIDatas;

	enchantScrollSetUIDatas = API_GetEnchantScrollSetDataS();
	return enchantScrollSetUIDatas[0].FailureMaintain;
}

function bool IsFailureCrush()
{
	local array<EnchantScrollSetUIData> enchantScrollSetUIDatas;

	enchantScrollSetUIDatas = API_GetEnchantScrollSetDataS();
	return enchantScrollSetUIDatas[0].FailureCrush;
}

function bool IsActive(int Index)
{
	local ItemInfo iInfo;

	if(!GetItemInfoEquipment(Index, iInfo))
	{
		return false;
	}
	return (iInfo.Enchanted < currentEnchantTarget);
}

function bool IsInActive()
{
	local int i;

	i = 0;
	while((i < 15))
	{
		if(IsActive(i))
		{
			return true;
		}
		i++;
	}
	return false;
}

function bool CanEnchant()
{
	local int equipmentCount, needScrollNum;
	local ItemInfo iInfo;

	switch(GetStateName())
	{
		case 'stateReadyEquipment':
		case 'stateEnchant':
			break;
		default:
			return false;
	}
	equipmentCount = GetEquipmentsCount();
	if((equipmentCount == 0))
	{
		return false;
	}
	if(!GetIteminfoScroll(iInfo))
	{
		return false;
	}
	if((iInfo.ItemNum == INT64(0)))
	{
		return false;
	}
	needScrollNum = GetNeedScrollNum(numberInputStepper._getEditNum());
	if((iInfo.ItemNum < INT64(needScrollNum)))
	{
		return false;
	}
	if((needScrollNum == 0))
	{
		return false;
	}
	return true;
}

function bool IsSafe(int Enchanted)
{
	return (Enchanted < GetFailureBase());
}

function int GetCanMaxTryNum()
{
	local ItemInfo scrolliInfo;
	local int i, j, needScrollNum, needScrollNumTotal;
	local array<ItemInfo> iInfos;
	local int trymaxnum;

	if(!GetIteminfoScroll(scrolliInfo))
	{
		return 0;
	}
	trymaxnum = Min((GetEnchantMax() + 1), 50);
	iInfos = GetItemInfoEquipments();
	i = 1;
	while((i <= trymaxnum))
	{
		needScrollNum = 0;
		j = 0;
		while((j < iInfos.Length))
		{
			if((iInfos[j].Enchanted < i))
			{
				needScrollNum++;
			}
			j++;
		}
		needScrollNumTotal = (needScrollNumTotal + needScrollNum);
		if((scrolliInfo.ItemNum < INT64(needScrollNumTotal)))
		{
			return (i - 1);
		}
		i++;
	}
	return trymaxnum;
}

function int GetNeedScrollNum(int targetEnchant, optional bool bLimit)
{
	local int i, j, needScrollNum, needScrollNumTotal;
	local array<ItemInfo> iInfos;

	iInfos = GetItemInfoEquipments();
	i = 1;
	while((i <= targetEnchant))
	{
		needScrollNum = 0;
		j = 0;
		while((j < iInfos.Length))
		{
			if((iInfos[j].Enchanted < i))
			{
				needScrollNum++;
			}
			j++;
		}
		needScrollNumTotal = (needScrollNumTotal + needScrollNum);
		i++;
	}
	return needScrollNumTotal;
}

function int GetEquipmentsCount()
{
	local int i, Count;

	i = 0;
	while((i < 15))
	{
		if((int(slotStates[i]) == 3))
		{
			i++;
			continue;
		}
		if((GetItemWindowHandle((getSlotPath(i) $ ".Enchant_ItemWnd")).GetItemNum() == 1))
		{
			Count++;
		}
		i++;
	}
	return Count;
}

function int GetEnchantMax()
{
	local int i, RandomValue, RangeMax, RangeMin, currentRangeMax;
	local array<EnchantScrollSetUIData> enchantScrollDatas;

	RangeMax = 9999999;
	enchantScrollDatas = API_GetEnchantScrollSetDataS();
	i = 0;
	while((i < enchantScrollDatas.Length))
	{
		currentRangeMax = enchantScrollDatas[i].EnchantRangeDatas[(enchantScrollDatas[i].EnchantRangeDatas.Length - 1)].RangeMax;
		RangeMax = Min(RangeMax, currentRangeMax);
		RangeMin = enchantScrollDatas[i].EnchantRangeDatas[(enchantScrollDatas[i].EnchantRangeDatas.Length - 1)].RangeMin;
		RandomValue = enchantScrollDatas[i].EnchantRangeDatas[(enchantScrollDatas[i].EnchantRangeDatas.Length - 1)].RandomValue;
		if((((RangeMax == -1) && (RangeMin == -1)) && (RandomValue == 1)))
		{
			RangeMax = Min(RangeMax, 50);
		}
		i++;
	}
	return RangeMax;
}

function bool RefreshScroll(out ItemInfo scrolliInfo)
{
	local ItemInfo iInfo;

	if(!GetIteminfoScroll(scrolliInfo))
	{
		return false;
	}
	scrollItemWindow.Clear();
	if(!Class'NWindow.UIDATA_INVENTORY'.static.FindItem(scrolliInfo.Id.ServerID, iInfo))
	{
		return false;
	}
	iInfo.bShowCount = true;
	scrollItemWindow.AddItem(iInfo);
	return true;
}

function InputScrollItem(int sID)
{
	local ItemInfo iInfo, iInfo2;

	ClearScroll();
	if(!Class'NWindow.UIDATA_INVENTORY'.static.FindItem(sID, iInfo))
	{
		return;
	}
	GetItemInfoEquipment(0, iInfo2);
	iInfo.bShowCount = true;
	scrollItemWindow.AddItem(iInfo);
	GotoState('stateReadyEquipment');
	ClearEquipments();
	PlaySound("Itemsound3.ui_enchant_slot");
	return;
}

function ClearScroll()
{
	scrollItemWindow.Clear();
	return;
}

function bool GetIteminfoScroll(out ItemInfo iInfo)
{
	return scrollItemWindow.GetItem(0, iInfo);
}

function HandleRequestedEquipment()
{
	switch(requestedEqupmentItemInfo.Type)
	{
		case Add:
			InputEquipmentItem();
			break;
		case Remove:
			ClearEquipmentItem();
			PlaySound("Itemsound3.ui_enchant_unslot");
			break;
		case refresh:
			RefreshActiveItem();
			return;
		default:
			break;
	}
	AddCurrentGroupIDs();
	SyncProgressAnis();
	SetNeedScrollNum();
	numberInputStepper._setRangeMinMaxNum(1, GetCanMaxTryNum());
	Class'Interface.ItemMultiEnchantSubWnd'.static.Inst().refresh();
	return;
}

function AddCurrentGroupIDs()
{
	local int i;
	local array<ItemInfo> iInfos;

	groupIDWndScr._HideCurrentGroupID();
	iInfos = GetItemInfoEquipments();
	i = 0;
	while((i < iInfos.Length))
	{
		groupIDWndScr._AddCurrentGroupID(API_GetChallengePointGroupID(iInfos[i].Id.ClassID));
		i++;
	}
	return;
}

function InputEquipmentItem()
{
	PlaySound("Itemsound3.ui_enchant_slot");
	setSlotState(requestedEqupmentItemInfo.Index, active, requestedEqupmentItemInfo.iInfo);
	GetAnimTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSystem_Wnd.PrvStepAni_tex")).Stop();
	GetAnimTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSystem_Wnd.PrvStepAni_tex")).Play();
	return;
}

function ClearEquipments()
{
	local int i;

	i = 0;
	while((i < 15))
	{
		setSlotState(i, non);
		i++;
	}
	groupIDWndScr._HideCurrentGroupID();
	return;
}

function SetSlotEmpty(ItemInfo iInfo)
{
	local int Index;
	local ItemInfo scrollInfo;

	if(!GetIteminfoScroll(scrollInfo))
	{
		Class'Interface.L2Util'.static.Inst().showGfxScreenMessage(GetSystemMessage(13648));
		return;
	}
	if(((scrollInfo.ItemNum / INT64(Max(1, (GetEquipmentsCount() + 1)))) < INT64(1)))
	{
		Class'Interface.L2Util'.static.Inst().showGfxScreenMessage(GetSystemMessage(13648));
		return;
	}
	Index = GetSlotEmpty();
	if((Index == -1))
	{
		Class'Interface.L2Util'.static.Inst().showGfxScreenMessage(GetSystemMessage(13647));
		return;
	}
	requestedEqupmentItemInfo.Type = Add;
	requestedEqupmentItemInfo.Index = Index;
	requestedEqupmentItemInfo.iInfo = iInfo;
	RQ_C_EX_REQ_SET_MULTI_ENCHANT_ITEM_LIST();
	return;
}

function ClearEquipmentItem()
{
	local int Index;
	local ItemInfo iInfo, eiInfo;

	Index = requestedEqupmentItemInfo.Index;
	if((int(slotStates[Index]) == 0))
	{
		return;
	}
	setSlotState(Index, non);
	Index = Index;
	while((Index < (15 - 1)))
	{
		iInfo = eiInfo;
		if(!GetItemInfoEquipment((Index + 1), iInfo))
		{
			break;
		}
		setSlotState(Index, active, iInfo);
		setSlotState((Index + 1), non);
		Index++;
	}
	return;
}

function ClearItem(int Index)
{
	local ItemInfo iInfo;

	if((int(slotStates[Index]) == 0))
	{
		return;
	}
	if(!GetItemInfoEquipment(Index, iInfo))
	{
		return;
	}
	requestedEqupmentItemInfo.Type = Remove;
	requestedEqupmentItemInfo.Index = Index;
	requestedEqupmentItemInfo.iInfo = iInfo;
	RQ_C_EX_REQ_SET_MULTI_ENCHANT_ITEM_LIST();
	return;
}

function RefreshActiveItem()
{
	local int i;
	local ItemInfo iInfo;

	i = 0;
	while((i < 15))
	{
		if((int(slotStates[i]) == 0))
		{
			i++;
			continue;
		}
		if((int(slotStates[i]) == 3))
		{
			i++;
			continue;
		}
		if(!GetItemInfoEquipment(i, iInfo))
		{
			i++;
			continue;
		}
		setSlotState(i, active, iInfo);
		i++;
	}
	numberInputStepper._setRangeMinMaxNum(1, GetCanMaxTryNum());
	return;
}

function bool ChkEnchantBtn()
{
	if(CanEnchant())
	{
		EnchantBtn.EnableWindow();
		return true;
	}
	else
	{
		EnchantBtn.DisableWindow();
		return false;
	}
}

function int GetSlotEmpty()
{
	local int i;

	i = 0;
	while((i < 15))
	{
		if((GetItemWindowHandle((getSlotPath(i) $ ".Enchant_ItemWnd")).GetItemNum() == 0))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function ChangeTargetEnchant(UIControlNumberInputSteper Target)
{
	ChkEnchantBtn();
	SetNeedScrollNum();
	return;
}

function bool GetItemInfoEquipment(int Index, out ItemInfo iInfo)
{
	return GetItemWindowHandle((getSlotPath(Index) $ ".Enchant_ItemWnd")).GetItem(0, iInfo);
}

function setSlotState(int Index, slotStateEnum slotstate, optional ItemInfo iInfo)
{
	local string slotPath;
	local AnimTextureHandle progressAni, boxAni;
	local ItemWindowHandle ItemWnd;
	local TextBoxHandle ProbTxt;
	local bool bIsActive;

	slotPath = getSlotPath(Index);
	progressAni = GetAnimTextureHandle((slotPath $ ".EnchantSlotProgress_ani"));
	boxAni = GetAnimTextureHandle((slotPath $ ".EnchantSlotBox_ani"));
	ItemWnd = GetItemWindowHandle((slotPath $ ".Enchant_ItemWnd"));
	GetItemWindowHandle((slotPath $ ".Enchant_ItemWnd")).SetDisableTex("L2UI_CT1.ItemWindow.ItemWindow_IconDisable");
	ProbTxt = GetTextBoxHandle((getSlotPath(Index) $ ".probability_text"));
	ProbTxt.ShowWindow();
	slotStates[Index] = slotStateEnum(slotstate);
	switch(slotstate)
	{
		case non:
			boxAni.HideWindow();
			progressAni.HideWindow();
			ItemWnd.Clear();
			ProbTxt.HideWindow();
			progressAni.HideWindow();
			slotProgresss[Index] = non;
			break;
		case active:
			progressAni.ShowWindow();
			ItemWnd.Clear();
			ItemWnd.AddItem(iInfo);
			bIsActive = IsActive(Index);
			if(!bIsActive)
			{
				if((int(slotProgresss[Index]) == 1))
				{
					return;
				}
				ProbTxt.SetTextColor(Class'Interface.L2Util'.static.Inst().Gray);
				slotProgresss[Index] = Gray;
				progressAni.SetTexture("L2UI.UISlotEffect.slot_active_gray_0000");
			}
			else if(IsSafe(currentEnchantTarget))
			{
				if((int(slotProgresss[Index]) == 2))
				{
					return;
				}
				ProbTxt.SetTextColor(Class'Interface.L2Util'.static.Inst().Gray);
				slotProgresss[Index] = Blue;
				progressAni.SetTexture("L2UI.UISlotEffect.slot_active_blue_0000");
			}
			else
			{
				if((int(slotProgresss[Index]) == 3))
				{
					return;
				}
				ProbTxt.SetTextColor(Class'Interface.L2Util'.static.Inst().Yellow);
				ProbTxt.ShowWindow();
				slotProgresss[Index] = Red;
				progressAni.SetTexture("L2UI.UISlotEffect.slot_active_red_0000");
			}
			progressAni.ShowWindow();
			progressAni.Stop();
			progressAni.SetLoopCount(999999);
			progressAni.Play();
			break;
		case resultSuccess:
			ItemWnd.Clear();
			ItemWnd.AddItem(iInfo);
			if(IsSafe(iInfo.Enchanted))
			{
				boxAni.SetTexture("L2UI.UISlotEffect.slot_success_blue_0000");
			}
			else
			{
				boxAni.SetTexture("L2UI.UISlotEffect.slot_success_red_0000");
			}
			boxAni.ShowWindow();
			boxAni.Stop();
			boxAni.SetLoopCount(1);
			boxAni.Play();
			break;
		case resultFail:
			boxAni.ShowWindow();
			boxAni.SetTexture("L2UI.UISlotEffect.slot_fail_0000");
			boxAni.ShowWindow();
			boxAni.Stop();
			boxAni.SetLoopCount(1);
			boxAni.Play();
			break;
		default:
			break;
	}
	return;
}

function HandleInstructionTxt()
{
	if((GetEquipmentsCount() == 0))
	{
		InstructionTxt.SetText(GetSystemMessage(2339));
	}
	else
	{
		InstructionTxt.SetText(GetSystemString(13930));
	}
	return;
}

function SetCurrentEnchantTarget(int Current)
{
	currentEnchantTarget = Current;
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSystem_Wnd.PrvNum_text")).SetText(string((currentEnchantTarget - 1)));
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSystem_Wnd.NextNum_text")).SetText(string(currentEnchantTarget));
	return;
}

function SetNeedScrollNum()
{
	local int needScrollNum;
	local TextBoxHandle txtHandle;
	local ItemInfo iInfo;

	txtHandle = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSystem_Wnd.NeedScrollNum_Txt"));
	needScrollNum = GetNeedScrollNum(numberInputStepper._getEditNum());
	if(!GetIteminfoScroll(iInfo))
	{
		GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSystem_Wnd.NeedScrollNumTitle_Txt")).SetText("");
		txtHandle.SetText("");
		return;
	}
	else if((iInfo.ItemNum < INT64(needScrollNum)))
	{
		txtHandle.SetTextColor(Class'Interface.L2Util'.static.Inst().Red);
	}
	else
	{
		txtHandle.SetTextColor(Class'Interface.L2Util'.static.Inst().White);
	}
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSystem_Wnd.NeedScrollNumTitle_Txt")).SetText(GetSystemString(13956));
	txtHandle.SetText(((string(needScrollNum) $ "/") $ string(iInfo.ItemNum)));
	return;
}

function SetEnchantProbs(array<UIPacket._EnchantProbInfo> enchantProbInfo)
{
	local int i, Index;

	i = 0;
	while((i < enchantProbInfo.Length))
	{
		Index = FindIndexEquipmentWithServerID(enchantProbInfo[i].nItemServerId);
		if((Index != -1))
		{
			SetSlotProb(Index, GetProbString(enchantProbInfo[i].nTotalSuccessProbPermyriad));
		}
		i++;
	}
	return;
}

function SetSlotProb(int Index, string txt)
{
	GetTextBoxHandle((getSlotPath(Index) $ ".probability_text")).SetText(txt);
	return;
}

function SyncProgressAnis()
{
	local int i;
	local ItemInfo iInfo;
	local AnimTextureHandle progressAni;

	i = 0;
	while(GetItemInfoEquipment(i, iInfo))
	{
		progressAni = GetAnimTextureHandle((getSlotPath(i) $ ".EnchantSlotProgress_ani"));
		progressAni.Stop();
		progressAni.Play();
		i++;
	}
	return;
}

function array<EnchantScrollSetUIData> API_GetEnchantScrollSetDataS()
{
	local int i;
	local ItemInfo scrolliInfo;
	local array<ItemInfo> itemInfoEquipments;
	local EnchantScrollSetUIData oneEnchantScrollSetUIData;
	local array<EnchantScrollSetUIData> enchantScrollSetUIDatas;

	GetIteminfoScroll(scrolliInfo);
	itemInfoEquipments = GetItemInfoEquipments();
	enchantScrollSetUIDatas.Length = itemInfoEquipments.Length;
	i = 0;
	while((i < itemInfoEquipments.Length))
	{
		Class'NWindow.UIDATA_ITEM'.static.GetEnchantScrollSetData(scrolliInfo.Id.ClassID, itemInfoEquipments[i].Id.ClassID, oneEnchantScrollSetUIData);
		enchantScrollSetUIDatas[i] = oneEnchantScrollSetUIData;
		i++;
	}
	return enchantScrollSetUIDatas;
}

function int API_GetChallengePointGroupID(int ClassID)
{
	return int(Class'NWindow.UIDATA_ITEM'.static.GetChallengePointGroupID(ClassID));
}

function RQ_C_EX_REQ_START_MULTI_ENCHANT_SCROLL(ItemInfo iInfo)
{
	local ItemInfo scrolliInfo;
	local array<byte> stream;
	local UIPacket._C_EX_REQ_START_MULTI_ENCHANT_SCROLL packet;

	if(GetIteminfoScroll(scrolliInfo))
	{
		RQ_C_EX_REQ_CHANGE_MULTI_ENCHANT_SCROLL(iInfo);
		return;
	}
	packet.nScrollItemSid = iInfo.Id.ServerID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_REQ_START_MULTI_ENCHANT_SCROLL(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(765, stream);
	return;
}

function RQ_C_EX_REQ_CHANGE_MULTI_ENCHANT_SCROLL(ItemInfo iInfo)
{
	local array<byte> stream;
	local UIPacket._C_EX_REQ_CHANGE_MULTI_ENCHANT_SCROLL packet;

	if(!Class'Interface.UIPacket'.static.Encode_C_EX_REQ_CHANGE_MULTI_ENCHANT_SCROLL(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(768, stream);
	return;
}

function RT_S_EX_RES_SELECT_MULTI_ENCHANT_SCROLL()
{
	local UIPacket._S_EX_RES_SELECT_MULTI_ENCHANT_SCROLL packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_RES_SELECT_MULTI_ENCHANT_SCROLL(packet))
	{
		return;
	}
	switch(packet.nResult)
	{
		case 0:
			InputScrollItem(packet.nScrollItemSid);
			break;
		default:
			return;
	}
	return;
}

function RQ_C_EX_REQ_SET_MULTI_ENCHANT_ITEM_LIST()
{
	local int i;
	local array<byte> stream;
	local array<ItemInfo> iInfos;
	local UIPacket._C_EX_REQ_SET_MULTI_ENCHANT_ITEM_LIST packet;

	iInfos = GetItemInfoEquipments();
	EnchantBtn.DisableWindow();
	resetBtn.DisableWindow();
	i = 0;
	while((i < iInfos.Length))
	{
		packet.vEnchantItemList[packet.vEnchantItemList.Length] = iInfos[i].Id.ServerID;
		i++;
	}
	if((int(requestedEqupmentItemInfo.Type) == 0))
	{
		packet.vEnchantItemList[packet.vEnchantItemList.Length] = requestedEqupmentItemInfo.iInfo.Id.ServerID;
	}
	else if((int(requestedEqupmentItemInfo.Type) == 1))
	{
		i = 0;
		while((i < iInfos.Length))
		{
			if((requestedEqupmentItemInfo.iInfo.Id == iInfos[i].Id))
			{
				packet.vEnchantItemList.Remove(i, 1);
				break;
			}
			i++;
		}
	}
	if((packet.vEnchantItemList.Length == 0))
	{
		HandleRequestedEquipment();
		HandleInstructionTxt();
		resetBtn.EnableWindow();
		return;
	}
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_REQ_SET_MULTI_ENCHANT_ITEM_LIST(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(769, stream);
	return;
}

function RT_S_EX_RES_SET_MULTI_ENCHANT_ITEM_LIST()
{
	local UIPacket._S_EX_RES_SET_MULTI_ENCHANT_ITEM_LIST packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_RES_SET_MULTI_ENCHANT_ITEM_LIST(packet))
	{
		return;
	}
	resetBtn.EnableWindow();
	switch(packet.nResult)
	{
		case 0:
			HandleRequestedEquipment();
			HandleInstructionTxt();
			break;
		case 1:
			Class'Interface.L2Util'.static.Inst().showGfxScreenMessage(GetSystemMessage(184));
			break;
		case 2:
			Class'Interface.L2Util'.static.Inst().showGfxScreenMessage(GetSystemMessage(13649));
			break;
		case 3:
			Class'Interface.L2Util'.static.Inst().showGfxScreenMessage(GetSystemMessage(3675));
			break;
		case 4:
			Class'Interface.L2Util'.static.Inst().showGfxScreenMessage(GetSystemMessage(13648));
			break;
		default:
			break;
	}
	ChkEnchantBtn();
	return;
}

function RQ_C_EX_REQ_MULTI_ENCHANT_ITEM_LIST()
{
	local int i;
	local ItemInfo iInfo;
	local array<byte> stream;
	local UIPacket._C_EX_REQ_MULTI_ENCHANT_ITEM_LIST packet;

	EnchantBtn.DisableWindow();
	i = 0;
	while((i < 15))
	{
		if((int(slotStates[i]) == 0))
		{
			i++;
			continue;
		}
		if((int(slotStates[i]) == 3))
		{
			i++;
			continue;
		}
		if((int(slotProgresss[i]) == 0))
		{
			i++;
			continue;
		}
		if((int(slotProgresss[i]) == 1))
		{
			i++;
			continue;
		}
		if(!GetItemInfoEquipment(i, iInfo))
		{
			i++;
			continue;
		}
		packet.vEnchantItemList[packet.vEnchantItemList.Length] = iInfo.Id.ServerID;
		i++;
	}
	if((packet.vEnchantItemList.Length == 0))
	{
		return;
	}
	if((numberInputStepper._getEditNum() == currentEnchantTarget))
	{
		if(IsGreateSuccessEffect(currentEnchantTarget))
		{
			groupIDWndScr._SetDisable();
		}
		packet.bUseLateAnnounce = 1;
		bUseLateAnnounce = true;
	}
	else
	{
		bUseLateAnnounce = false;
		packet.bUseLateAnnounce = 0;
	}
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_REQ_MULTI_ENCHANT_ITEM_LIST(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(770, stream);
	return;
}

function RT_S_EX_RES_MULTI_ENCHANT_ITEM_LIST()
{
	local ItemInfo scrolliInfo;
	local UIPacket._S_EX_RES_MULTI_ENCHANT_ITEM_LIST packet;

	EnchantBtn.EnableWindow();
	if(!Class'Interface.UIPacket'.static.Decode_S_EX_RES_MULTI_ENCHANT_ITEM_LIST(packet))
	{
		return;
	}
	groupIDWndScr._SetEnable();
	switch(packet.bResult)
	{
		case 0:
			GotoState('stateReadyEquipment');
			break;
		case 1:
			RefreshScroll(scrolliInfo);
			SetFailItemList(packet.vFailChallengePointInfoList, packet.vFailRewardItemList);
			Class'Interface.L2UITimer'.static.Inst()._AddTimerOnce()._DelegateOnEnd = RemoveFailedItems;
			SetSlots(packet.vSuccessItemList, packet.vFailedItemList);
			if((currentEnchantTarget == numberInputStepper._getEditNum()))
			{
				if(IsGreateSuccessEffectWithResultList(scrolliInfo, currentEnchantTarget, packet.vSuccessItemList, packet.vFailedItemList))
				{
					GotoState('stateCompleteBlind');
				}
				else
				{
					timerObj._Reset();
					groupIDWndScr._SetEnable();
				}
				break;
			}
			currentEnchantTarget++;
			if(!CanEnchant())
			{
				GotoState('stateCompleteResult');
			}
			else
			{
				StartProgress();
			}
			break;
		default:
			break;
	}
	SetNeedScrollNum();
	return;
}

function DelayGotoToStateCompleteREsult()
{
	GotoState('stateCompleteResult');
	return;
}

function AddFailItemList(ItemInfo iInfo)
{
	local int i;

	i = 0;
	while((i < failedItemList.Length))
	{
		if((failedItemList[i].Id.ClassID == iInfo.Id.ClassID))
		{
			failedItemList[i].ItemNum = (failedItemList[i].ItemNum + iInfo.ItemNum);
			return;
		}
		i++;
	}
	failedItemList[failedItemList.Length] = iInfo;
	return;
}

function AddChangePointList(ItemInfo iInfo)
{
	local int i;

	i = 0;
	while((i < changePointList.Length))
	{
		if((changePointList[i].Id.ClassID == iInfo.Id.ClassID))
		{
			changePointList[i].ItemNum = (changePointList[i].ItemNum + iInfo.ItemNum);
			return;
		}
		i++;
	}
	changePointList[changePointList.Length] = iInfo;
	return;
}

function SetFailItemList(array<UIPacket._EnchantFailChallengePointInfo> vFailChallengePointInfo, array<UIPacket._EnchantFailRewardItem> failRewardItems)
{
	local int i;
	local ItemInfo iInfo;

	i = 0;
	while((i < vFailChallengePointInfo.Length))
	{
		Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(Class'Interface.ItemEnchantGroupIDWnd'.static._GetClassIDPoint(vFailChallengePointInfo[i].nGroupID)), iInfo);
		iInfo.ItemNum = INT64(vFailChallengePointInfo[i].nChallengePoint);
		AddChangePointList(iInfo);
		i++;
	}
	i = 0;
	while((i < failRewardItems.Length))
	{
		Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(failRewardItems[i].nItemClassID), iInfo);
		iInfo.ItemNum = INT64(failRewardItems[i].nItemCount);
		AddFailItemList(iInfo);
		i++;
	}
	return;
}

function CheckEmptyFailItemInfoToList()
{
	local RichListCtrlRowData rowData, emptyRowData;

	if((resultFailList_RichList.GetRecordCount() > 0))
	{
		return;
	}
	rowData.cellDataList.Length = 1;
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetSystemString(14024), Class'Interface.L2Util'.static.Inst().Gray, false, 10);
	resultFailList_RichList.InsertRecord(emptyRowData);
	resultFailList_RichList.InsertRecord(emptyRowData);
	resultFailList_RichList.InsertRecord(rowData);
	return;
}

function MakeFailItemList()
{
	local int i;
	local RichListCtrlRowData rowData;

	resultFailList_RichList.DeleteAllItem();
	i = 0;
	while((i < changePointList.Length))
	{
		if((changePointList[i].ItemNum == INT64(0)))
		{
			i++;
			continue;
		}
		rowData.cellDataList.Length = 0;
		makeRecord(changePointList[i], rowData);
		resultFailList_RichList.InsertRecord(rowData);
		i++;
	}
	i = 0;
	while((i < failedItemList.Length))
	{
		if((failedItemList[i].ItemNum == INT64(0)))
		{
			i++;
			continue;
		}
		rowData.cellDataList.Length = 0;
		makeRecord(failedItemList[i], rowData);
		resultFailList_RichList.InsertRecord(rowData);
		i++;
	}
	return;
}

function bool makeRecord(ItemInfo iInfo, out RichListCtrlRowData rowData)
{
	rowData.cellDataList.Length = 1;
	AddRichListCtrlItem(rowData.cellDataList[0].drawitems, iInfo, 32, 32, 7);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetItemNameAll(iInfo), Class'Interface.L2Util'.static.Inst().White, false, 4, 3);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, ("x" $ MakeCostStringINT64(iInfo.ItemNum)), Class'Interface.L2Util'.static.Inst().White, true, 42, 0);
	return true;
}

function SetSlots(array<UIPacket._EnchantSuccessItem> successItemLists, array<UIPacket._EnchantFailItem> failedItemList)
{
	local ItemInfo iInfo;
	local int i, Index;

	if(((currentEnchantTarget != numberInputStepper._getEditNum()) || !IsGreateSuccessEffect(currentEnchantTarget)))
	{
		if((successItemLists.Length > 0))
		{
			PlaySound("Itemsound3.ui_enchant_fx");
		}
		else if((failedItemList.Length > 0))
		{
			PlaySound("Itemsound3.ui_enchant_fail_fx");
		}
	}
	i = 0;
	while((i < successItemLists.Length))
	{
		Index = FindIndexEquipmentWithServerID(successItemLists[i].nItemSid);
		if(GetItemInfoEquipment(Index, iInfo))
		{
			iInfo.Enchanted = successItemLists[i].nFinalEnchanted;
			setSlotState(Index, resultSuccess, iInfo);
		}
		i++;
	}
	i = 0;
	while((i < failedItemList.Length))
	{
		Index = FindIndexEquipmentWithServerID(failedItemList[i].nItemSid);
		if(GetItemInfoEquipment(Index, iInfo))
		{
			setSlotState(Index, resultFail);
		}
		i++;
	}
	i = 0;
	while((i < 15))
	{
		switch(slotStates[i])
		{
			case resultSuccess:
			case active:
				return;
			default:
				i++;
		}
	}
	return;
}

function RQ_C_EX_REQ_VIEW_MULTI_ENCHANT_RESULT()
{
	local array<byte> stream;
	local UIPacket._C_EX_REQ_VIEW_MULTI_ENCHANT_RESULT packet;

	if(!bUseLateAnnounce)
	{
		return;
	}
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_REQ_VIEW_MULTI_ENCHANT_RESULT(stream, packet))
	{
		return;
	}
	bUseLateAnnounce = false;
	Class'Interface.UIPacket'.static.RequestUIPacket(766, stream);
	NoticeWnd(GetScript("NoticeWnd"))._CreateCollectionButtonBlind();
	return;
}

function RQ_C_EX_REQ_FINISH_MULTI_ENCHANT_SCROLL()
{
	local array<byte> stream;
	local UIPacket._C_EX_REQ_FINISH_MULTI_ENCHANT_SCROLL packet;

	if(!Class'Interface.UIPacket'.static.Encode_C_EX_REQ_FINISH_MULTI_ENCHANT_SCROLL(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(767, stream);
	return;
}

function RT_S_EX_CHANGED_ENCHANT_TARGET_ITEM_PROB_LIST()
{
	local UIPacket._S_EX_CHANGED_ENCHANT_TARGET_ITEM_PROB_LIST packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_CHANGED_ENCHANT_TARGET_ITEM_PROB_LIST(packet))
	{
		return;
	}
	SetEnchantProbs(packet.vProbList);
	return;
}

function bool ChkEnchantContinue()
{
	local ItemInfo ScrollItemInfo;

	StopProgress();
	SetCurrentEnchantTarget(1);
	RQ_C_EX_REQ_VIEW_MULTI_ENCHANT_RESULT();
	if(!RefreshScroll(ScrollItemInfo))
	{
		GotoState('stateReadyScroll');
		return false;
	}
	GotoState('stateReadyEquipment');
	if((GetEquipmentsCount() == 0))
	{
		return false;
	}
	numberInputStepper._SetDisable(false);
	requestedEqupmentItemInfo.Type = refresh;
	RQ_C_EX_REQ_SET_MULTI_ENCHANT_ITEM_LIST();
	return true;
}

function string GetProbString(int probPermriad)
{
	return getInstanceL2Util().MakeDecimalPointString(string(probPermriad), 2, true, true);
}

function array<ItemInfo> GetItemInfoEquipments()
{
	local int i, Index;
	local ItemInfo iInfo;
	local array<ItemInfo> iInfos;

	i = 0;
	while((i < 15))
	{
		if((int(slotStates[i]) == 3))
		{
			i++;
			continue;
		}
		if(GetItemInfoEquipment(i, iInfo))
		{
			iInfos[Index] = iInfo;
			Index++;
		}
		i++;
	}
	return iInfos;
}

function int FindIndexEquipmentWithServerID(int ServerID)
{
	local int i;
	local ItemInfo iInfo;

	i = 0;
	while((i < 15))
	{
		if(GetItemInfoEquipment(i, iInfo))
		{
			if((iInfo.Id.ServerID == ServerID))
			{
				return i;
			}
		}
		i++;
	}
	return -1;
}

function string getSlotPath(int Index)
{
	return ((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantSlot_Wnd.Slot_Wnd") $ Int2Str(Index));
}

function string Int2Str(int i)
{
	if((i < 10))
	{
		return ("0" $ string(i));
	}
	return string(i);
}

event OnReceivedCloseUI()
{
	switch(GetStateName())
	{
		case 'stateEnchant':
			if(EnchantBtn.IsEnableWindow())
			{
				HandleClickButtonEnchant();
			}
			return;
		default:
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			m_hOwnerWnd.HideWindow();
			return;
	}
}

auto state stateNone
{
	function BeginState()
	{
		numberInputStepper._SetDisable(true);
		return;
	}

	function EndState()
	{
		prevState = GetStateName();
		return;
	}
}

state stateReadyScroll
{
	function BeginState()
	{
		RQ_C_EX_REQ_VIEW_MULTI_ENCHANT_RESULT();
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemEnchantWndTap_Btn")).EnableWindow();
		InstructionTxt.SetText(GetSystemMessage(4146));
		RQ_C_EX_REQ_FINISH_MULTI_ENCHANT_SCROLL();
		EnchantBtn.DisableWindow();
		resetBtn.DisableWindow();
		EnchantBtn.SetNameText(GetSystemString(13935));
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ResultScreenFence_Wnd")).HideWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Dialog_Wnd")).HideWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ResultFailItem_Wnd")).HideWindow();
		ClearScroll();
		ClearEquipments();
		numberInputStepper._setEditNum(1);
		numberInputStepper._SetDisable(true);
		SetCurrentEnchantTarget(1);
		SetNeedScrollNum();
		Class'Interface.ItemMultiEnchantSubWnd'.static.Inst().Show();
		return;
	}

	function EndState()
	{
		prevState = GetStateName();
		return;
	}
}

state stateReadyEquipment
{
	function BeginState()
	{
		HandleInstructionTxt();
		EnchantBtn.DisableWindow();
		EnchantBtn.SetNameText(GetSystemString(13935));
		resetBtn.EnableWindow();
		numberInputStepper._SetDisable(false);
		Class'Interface.ItemMultiEnchantSubWnd'.static.Inst().Show();
		return;
	}

	function EndState()
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Dialog_Wnd")).HideWindow();
		prevState = GetStateName();
		return;
	}

	function HandleClickButtonEnchant()
	{
		if(IsBreakable())
		{
			HandleShowDialog();
			resetBtn.DisableWindow();
			EnchantBtn.DisableWindow();
			GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Dialog_Wnd")).ShowWindow();
		}
		else
		{
			GotoState('stateEnchant');
		}
		return;
	}
}

state stateEnchant
{
	function BeginState()
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemEnchantWndTap_Btn")).DisableWindow();
		numberInputStepper._SetDisable(true);
		InstructionTxt.SetText(GetSystemString(13931));
		failedItemList.Length = 0;
		changePointList.Length = 0;
		EnchantBtn.EnableWindow();
		EnchantBtn.SetNameText(GetSystemString(13936));
		Class'Interface.ItemMultiEnchantSubWnd'.static.Inst().Hide();
		currentEnchantTarget = 1;
		ResetProgressStates();
		StartProgress();
		return;
	}

	function EndState()
	{
		currentEnchantTarget = 1;
		prevState = GetStateName();
		m_hOwnerWnd.DisableTick();
		StopProgress();
		return;
	}

	function HandleClickButtonEnchant()
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemEnchantWndTap_Btn")).EnableWindow();
		ChkEnchantContinue();
		timerObj._Stop();
		return;
	}
}

state stateCompleteBlind
{
	function BeginState()
	{
		InstructionTxt.SetText(GetSystemString(13953));
		EnchantEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_screen");
		EnchantEffectViewport.SetScale(1.3400000);
		EnchantEffectViewport.SetCameraDistance(222.0000000);
		EnchantEffectViewport.SetFocus();
		EnchantBtn.SetNameText(GetSystemString(13954));
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ResultScreenFence_Wnd")).ShowWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ResultScreenFence_Wnd")).SetFocus();
		EnchantEffectViewport.SetFocus();
		groupIDWndScr._SetDisable();
		PlaySound("Itemsound3.ui_enchant_screen");
		return;
	}

	function EndState()
	{
		EnchantEffectViewport.SpawnEffect("");
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ResultScreenFence_Wnd")).HideWindow();
		prevState = GetStateName();
		groupIDWndScr._SetEnable();
		return;
	}

	function HandleClickButtonEnchant()
	{
		GotoState('stateCompleteResult');
		return;
	}
}

state stateCompleteResult
{
	function BeginState()
	{
		RQ_C_EX_REQ_VIEW_MULTI_ENCHANT_RESULT();
		resetBtn.EnableWindow();
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemEnchantWndTap_Btn")).EnableWindow();
		InstructionTxt.SetText(GetSystemString(13932));
		if(IsSuccess())
		{
			EnchantEffectViewport.SetCameraDistance(175.0000000);
			if(IsGreateSuccessEffect(numberInputStepper._getEditNum()))
			{
				EnchantEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_great_success");
				PlaySound("Itemsound3.ui_enchant_great_success");
				PlaySound("Itemsound3.ui_enchant_success_sfx");
			}
			else
			{
				EnchantEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_success");
				PlaySound("Itemsound3.ui_enchant_success");
				PlaySound("Itemsound3.ui_enchant_success_sfx");
			}
		}
		else
		{
			EnchantEffectViewport.SetCameraDistance(160.0000000);
			EnchantEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_fail");
			PlaySound("Itemsound3.ui_enchant_fail");
			PlaySound("Itemsound3.ui_enchant_fail_sfx");
		}
		EnchantEffectViewport.SetFocus();
		MakeFailItemList();
		EnchantBtn.SetNameText(GetSystemString(3135));
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ResultFailItem_Wnd")).ShowWindow();
		CheckEmptyFailItemInfoToList();
		return;
	}

	function EndState()
	{
		EnchantEffectViewport.SpawnEffect("");
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ResultFailItem_Wnd")).HideWindow();
		prevState = GetStateName();
		numberInputStepper._SetDisable(false);
		return;
	}

	function HandleClickButtonEnchant()
	{
		ChkEnchantContinue();
		return;
	}
}
