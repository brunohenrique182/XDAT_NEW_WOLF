class ItemAutoPeelWnd extends UICommonAPI
	dependson(UIPacket);

const TIMER_ID_ITEM_PEEL_DELAY = 1;
const TIMER_DELAY_ITEM_PEEL = 150;
const DIALOG_ID_ITEM_SET_COUNT = 1;

enum EAutoPeelGradeColor
{
	APGC_NONE,                      // 0
	APGC_YELLOW,                    // 1
	APGC_BLUE,                      // 2
	APGC_RED,                       // 3
	APGC_VIOLET                     // 4
};


var ItemAutoPeelInfo _itemAutoPeelInfo;
var bool _is_waiting_close;
var bool _is_opened_dialog;
var WindowHandle Me;
var ButtonHandle expandBtn;
var ItemWindowHandle targetItemWnd;
var TextBoxHandle statusTextBox;
var StatusBarHandle statusBar;
var TextureHandle anounceLevelTex;
var CharacterViewportWindowHandle itemPeelEffect;
var EditBoxHandle testEditBox;
var L2UIInventoryObjectSimple iObject;
//var delegate<OnItemSortCompare> __OnItemSortCompare__Delegate;

static function ItemAutoPeelWnd Inst()
{
	return ItemAutoPeelWnd(GetScript("ItemAutoPeelWnd"));
}

function Initialize()
{
	InitControls();
	iObject = AddItemListenerSimple(0);
	iObject.DelegateOnUpdateItem = HandleUpdateTargetItem;
	return;
}

function InitControls()
{
	local string ownerFullPath;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	expandBtn = GetButtonHandle((ownerFullPath $ ".ExpandBTN"));
	statusBar = GetStatusBarHandle((ownerFullPath $ ".ProgressBar"));
	statusTextBox = GetTextBoxHandle((ownerFullPath $ ".ProgressBar_Text"));
	targetItemWnd = GetItemWindowHandle((ownerFullPath $ ".BoxItem_itemWnd"));
	anounceLevelTex = GetTextureHandle((ownerFullPath $ ".LvDot_tex"));
	itemPeelEffect = GetCharacterViewportWindowHandle((ownerFullPath $ ".ChEffectViewport"));
	return;
}

function UpdateProgressInfoControls()
{
	if((_itemAutoPeelInfo.isComplete == true))
	{
		statusTextBox.SetText(GetSystemString(898));
	}
	else if((_itemAutoPeelInfo.remainPeelCnt == INT64(0)))
	{
		statusTextBox.SetText(GetSystemString(14092));
	}
	else
	{
		statusTextBox.SetText(MakeCostString(string(_itemAutoPeelInfo.remainPeelCnt)));
	}
	statusBar.SetPoint(_itemAutoPeelInfo.remainPeelCnt, _itemAutoPeelInfo.totalPeelCnt);
	if(((_itemAutoPeelInfo.maxGradeColor > 0) && (_itemAutoPeelInfo.isExpand == false)))
	{
		anounceLevelTex.SetTexture(GetGradeDotTextureName(_itemAutoPeelInfo.maxGradeColor));
		anounceLevelTex.ShowWindow();
	}
	else
	{
		anounceLevelTex.HideWindow();
	}
	return;
}

function UpdateExpandWnd()
{
	if((_itemAutoPeelInfo.isExpand == true))
	{
		expandBtn.HideWindow();
		Class'Interface.ItemAutoPeelExpandWnd'.static.Inst().m_hOwnerWnd.ShowWindow();
	}
	else
	{
		expandBtn.ShowWindow();
		Class'Interface.ItemAutoPeelExpandWnd'.static.Inst().m_hOwnerWnd.HideWindow();
	}
	return;
}

function UpdateSimpleInvenWnd()
{
	if((_itemAutoPeelInfo.isExpand == true))
	{
		if(((_itemAutoPeelInfo.isPeeling == true) && (_itemAutoPeelInfo.isPause == false)))
		{
			ShowSimpleInven(false);
		}
		else
		{
			ShowSimpleInven(true);
		}
	}
	else
	{
		ShowSimpleInven(false);
	}
	return;
}

function UpdateTargetItemInfoControls()
{
	local ItemInfo targetItemInfo;

	if(Class'NWindow.UIDATA_INVENTORY'.static.FindItem(_itemAutoPeelInfo.targetItemSId, targetItemInfo))
	{
		targetItemInfo.bDisabled = 0;
		targetItemInfo.bShowCount = true;
		if(!targetItemWnd.SetItem(0, targetItemInfo))
		{
			targetItemWnd.AddItem(targetItemInfo);
			iObject.setId(targetItemInfo.Id);
		}
	}
	else
	{
		targetItemWnd.Clear();
		iObject.setId();
		if((_itemAutoPeelInfo.targetItemSId > 0))
		{
			Rq_C_EX_STOP_ITEM_AUTO_PEEL();
			ResetTargetInfo();
		}
	}
	return;
}

function UpdateWnd()
{
	UpdateExpandWnd();
	UpdateSimpleInvenWnd();
	return;
}

function UpdateUIControls()
{
	UpdateTargetItemInfoControls();
	UpdateProgressInfoControls();
	Class'Interface.ItemAutoPeelExpandWnd'.static.Inst().UpdateUIControls();
	return;
}

function RegisterItem(int itemSId, bool isAllItem)
{
	local INT64 ItemNum;

	if(((_itemAutoPeelInfo.isPeeling == true) && (_itemAutoPeelInfo.isPause == false)))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13666));
		return;
	}
	Me.ShowWindow();
	SetExpand(true);
	if((itemSId != 0))
	{
		ItemNum = GetItemNum(itemSId);
		_itemAutoPeelInfo.readyTargetItemSid = itemSId;
		if((isAllItem == true))
		{
			_itemAutoPeelInfo.readyTotalPeelCnt = INT64(0);
			Rq_C_EX_READY_ITEM_AUTO_PEEL(itemSId);
		}
		else if((ItemNum > INT64(1)))
		{
			ShowItemCountDialog(itemSId);
		}
		else
		{
			_itemAutoPeelInfo.readyTotalPeelCnt = INT64(1);
			Rq_C_EX_READY_ITEM_AUTO_PEEL(itemSId);
		}
	}
	return;
}

function StartItemAutoPeel()
{
	_itemAutoPeelInfo.isPeeling = true;
	_itemAutoPeelInfo.isPause = false;
	_itemAutoPeelInfo.isComplete = false;
	CheckAndContinueItemPeel();
	UpdateSimpleInvenWnd();
	UpdateUIControls();
	return;
}

function PauseItemAutoPeel()
{
	_itemAutoPeelInfo.isPeeling = true;
	_itemAutoPeelInfo.isPause = true;
	KillItemPeelDelayTimer();
	UpdateSimpleInvenWnd();
	UpdateUIControls();
	return;
}

function StopItemAutoPeel()
{
	_itemAutoPeelInfo.isPeeling = false;
	_itemAutoPeelInfo.isPause = false;
	KillItemPeelDelayTimer();
	UpdateSimpleInvenWnd();
	UpdateUIControls();
	return;
}

function CompleteItemAutoPeel()
{
	_itemAutoPeelInfo.isComplete = true;
	StopItemAutoPeel();
	return;
}

function CheckAndContinueItemPeel()
{
	if((((_itemAutoPeelInfo.targetItemSId != 0) && (_itemAutoPeelInfo.isPeeling == true)) && (_itemAutoPeelInfo.isPause == false)))
	{
		if((_itemAutoPeelInfo.remainPeelCnt == INT64(0)))
		{
			StopItemAutoPeel();
		}
		else
		{
			Rq_C_EX_REQUEST_ITEM_AUTO_PEEL(_itemAutoPeelInfo.targetItemSId, _itemAutoPeelInfo.remainPeelCnt, _itemAutoPeelInfo.totalPeelCnt);
		}
	}
	return;
}

function AddResultItemInfo(array<UIPacket._AutoPeelResultItem> resultItemInfos)
{
	local int i;
	local UIPacket._AutoPeelResultItem tempInfo;

	i = 0;
	while((i < resultItemInfos.Length))
	{
		tempInfo = resultItemInfos[i];
		if((tempInfo.gradeColor > 0))
		{
			_itemAutoPeelInfo.maxGradeColor = Max(_itemAutoPeelInfo.maxGradeColor, tempInfo.gradeColor);
			AddRareResultInfo(tempInfo);
			i++;
			continue;
		}
		AddNormalResultInfo(tempInfo);
		i++;
	}
	return;
}

function AddRareResultInfo(UIPacket._AutoPeelResultItem ResultItemInfo)
{
	local bool isFound;
	local int i;
	local UIPacket._AutoPeelResultItem tempInfo;

	i = 0;
	while((i < _itemAutoPeelInfo.rareItemInfos.Length))
	{
		tempInfo = _itemAutoPeelInfo.rareItemInfos[i];
		if(((tempInfo.nItemClassID == ResultItemInfo.nItemClassID) && (tempInfo.Enchanted == ResultItemInfo.Enchanted)))
		{
			isFound = true;
			tempInfo.nAmount = (tempInfo.nAmount + ResultItemInfo.nAmount);
			_itemAutoPeelInfo.rareItemInfos[i] = tempInfo;
			break;
		}
		i++;
	}
	if((isFound == false))
	{
		_itemAutoPeelInfo.rareItemInfos[_itemAutoPeelInfo.rareItemInfos.Length] = ResultItemInfo;
		// _itemAutoPeelInfo.rareItemInfos.Sort(OnItemSortCompare);   // array.Sort() unsupported by this compiler
	}
	return;
}

function AddNormalResultInfo(UIPacket._AutoPeelResultItem ResultItemInfo)
{
	local bool isFound;
	local int i;
	local UIPacket._AutoPeelResultItem tempInfo;

	i = 0;
	while((i < _itemAutoPeelInfo.normalItemInfos.Length))
	{
		tempInfo = _itemAutoPeelInfo.normalItemInfos[i];
		if(((tempInfo.nItemClassID == ResultItemInfo.nItemClassID) && (tempInfo.Enchanted == ResultItemInfo.Enchanted)))
		{
			isFound = true;
			tempInfo.nAmount = (tempInfo.nAmount + ResultItemInfo.nAmount);
			_itemAutoPeelInfo.normalItemInfos[i] = tempInfo;
			break;
		}
		i++;
	}
	if((isFound == false))
	{
		_itemAutoPeelInfo.normalItemInfos[_itemAutoPeelInfo.normalItemInfos.Length] = ResultItemInfo;
	}
	return;
}

delegate int OnItemSortCompare(UIPacket._AutoPeelResultItem A, UIPacket._AutoPeelResultItem B)
{
	if((A.gradeColor < B.gradeColor))
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

function ResetTargetItem()
{
	if((_itemAutoPeelInfo.targetItemSId > 0))
	{
		Rq_C_EX_STOP_ITEM_AUTO_PEEL();
	}
	return;
}

function ResetTargetInfo()
{
	_itemAutoPeelInfo.targetItemSId = 0;
	_itemAutoPeelInfo.targetItemName = "";
	_itemAutoPeelInfo.remainPeelCnt = INT64(0);
	_itemAutoPeelInfo.totalPeelCnt = INT64(0);
	_itemAutoPeelInfo.isPeeling = false;
	_itemAutoPeelInfo.isPause = false;
	return;
}

function ResetResultInfo()
{
	_itemAutoPeelInfo.maxGradeColor = 0;
	_itemAutoPeelInfo.normalItemInfos.Length = 0;
	_itemAutoPeelInfo.rareItemInfos.Length = 0;
	_itemAutoPeelInfo.isComplete = false;
	return;
}

function ResetInfo()
{
	ResetTargetInfo();
	ResetResultInfo();
	return;
}

function SetExpand(bool isExpand)
{
	_itemAutoPeelInfo.isExpand = isExpand;
	UpdateExpandWnd();
	UpdateSimpleInvenWnd();
	UpdateProgressInfoControls();
	return;
}

function ShowSimpleInven(bool isShow)
{
	if((isShow == true))
	{
		Class'Interface.ItemAutoPeelInvenWnd'.static.Inst().m_hOwnerWnd.ShowWindow();
	}
	else
	{
		Class'Interface.ItemAutoPeelInvenWnd'.static.Inst().m_hOwnerWnd.HideWindow();
	}
	return;
}

function ShowItemCountDialog(optional int forceSId)
{
	local ItemInfo targetItemInfo;

	if((forceSId > 0))
	{
		if((Class'NWindow.UIDATA_INVENTORY'.static.FindItem(forceSId, targetItemInfo) == false))
		{
			return;
		}
	}
	else if((Class'NWindow.UIDATA_INVENTORY'.static.FindItem(_itemAutoPeelInfo.targetItemSId, targetItemInfo) == false))
	{
		return;
	}
	DialogHide();
	DialogSetReservedItemID(targetItemInfo.Id);
	DialogSetParamInt64(targetItemInfo.ItemNum);
	DialogSetID(1);
	DialogSetCancelD(1);
	DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(13657), targetItemInfo.Name));
	_is_opened_dialog = true;
	Class'Interface.DialogBox'.static.Inst().AnchorToOwner(0, 100);
	Class'Interface.DialogBox'.static.Inst().DelegateOnCancel = OnItemCountDialogCancel;
	Class'Interface.DialogBox'.static.Inst().DelegateOnOK = OnItemCountDialogConfirm;
	Class'Interface.DialogBox'.static.Inst().DelegateOnHide = OnItemCountDialogHide;
	Class'Interface.DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)), "AttributeEnchantWnd,AttributeRemoveWnd,UnrefineryWnd,CrystallizationWnd,ItemAttributeChangeWnd,ProgressBox,AlchemyMixCubeWnd");
	SetCountDialogModal(true);
	return;
}

function StartItemPeelDelayTimer()
{
	KillItemPeelDelayTimer();
	Me.SetTimer(1, 150);
	return;
}

function KillItemPeelDelayTimer()
{
	Me.KillTimer(1);
	return;
}

function PlayItemPeelEffect()
{
	if((Me.IsShowWindow() == false))
	{
		return;
	}
	itemPeelEffect.ShowWindow();
	itemPeelEffect.SpawnEffect("LineageEffect2.ui_openbox");
	return;
}

function StopItemPeelEffect()
{
	itemPeelEffect.HideWindow();
	return;
}

function SetCountDialogModal(bool isModal)
{
	if((isModal == true))
	{
		Class'Interface.ItemAutoPeelInvenWnd'.static.Inst().m_hOwnerWnd.DisableWindow();
		Class'Interface.ItemAutoPeelExpandWnd'.static.Inst().ShowDisableWnd(true);
		Me.DisableWindow();
	}
	else
	{
		Class'Interface.ItemAutoPeelInvenWnd'.static.Inst().m_hOwnerWnd.EnableWindow();
		Class'Interface.ItemAutoPeelExpandWnd'.static.Inst().ShowDisableWnd(false);
		Me.EnableWindow();
	}
	UpdateUIControls();
	return;
}

function SetTargetTotalPeelCnt(INT64 Count)
{
	local INT64 oldPeelCnt, newPeelCnt;

	if((_itemAutoPeelInfo.isPeeling == false))
	{
		oldPeelCnt = _itemAutoPeelInfo.totalPeelCnt;
		newPeelCnt = Min64(GetTargetItemNum(), Count);
		if((oldPeelCnt != newPeelCnt))
		{
			_itemAutoPeelInfo.totalPeelCnt = newPeelCnt;
			_itemAutoPeelInfo.remainPeelCnt = _itemAutoPeelInfo.totalPeelCnt;
			UpdateUIControls();
		}
	}
	return;
}

function CloseWindow()
{
	if((Me.IsShowWindow() == false))
	{
		return;
	}
	if((_itemAutoPeelInfo.targetItemSId > 0))
	{
		_is_waiting_close = true;
		Rq_C_EX_STOP_ITEM_AUTO_PEEL();
	}
	else
	{
		Me.HideWindow();
	}
	return;
}

function string GetGradeDotTextureName(int gradeColorType)
{
	switch(gradeColorType)
	{
		case 1:
			return "L2UI_NewTex.ItemAutoPeelWnd.ItemAutoPeelDOT_Lv1";
		case 2:
			return "L2UI_NewTex.ItemAutoPeelWnd.ItemAutoPeelDOT_Lv4";
		case 3:
			return "L2UI_NewTex.ItemAutoPeelWnd.ItemAutoPeelDOT_Lv5";
		case 4:
			return "L2UI_NewTex.ItemAutoPeelWnd.ItemAutoPeelDOT_Lv6";
		default:
			return "";
	}
}

function string GetGradeBGTextureName(int gradeColorType)
{
	Debug((("GetGradeBGTextureName" @ string(gradeColorType)) @ string(1)));
	switch(gradeColorType)
	{
		case 1:
			return "L2UI_NewTex.ItemAutoPeelWnd.ItemAutoPeelListBG_Lv1";
		case 2:
			return "L2UI_NewTex.ItemAutoPeelWnd.ItemAutoPeelListBG_Lv4";
		case 3:
			return "L2UI_NewTex.ItemAutoPeelWnd.ItemAutoPeelListBG_Lv5";
		case 4:
			return "L2UI_NewTex.ItemAutoPeelWnd.ItemAutoPeelListBG_Lv6";
		default:
			return "";
	}
}

function INT64 GetItemNum(int itemSId)
{
	local ItemInfo tempInfo;

	if((Class'NWindow.UIDATA_INVENTORY'.static.FindItem(itemSId, tempInfo) == false))
	{
		return INT64(0);
	}
	else
	{
		return tempInfo.ItemNum;
	}
}

function INT64 GetTargetItemNum()
{
	local int TargetItemID;

	TargetItemID = _itemAutoPeelInfo.targetItemSId;
	if((TargetItemID == 0))
	{
		return INT64(0);
	}
	return GetItemNum(TargetItemID);
}

function ItemAutoPeelInfo GetItemAutoPeelInfo()
{
	return _itemAutoPeelInfo;
}

function bool IsItemPeeling()
{
	if(((_itemAutoPeelInfo.isPeeling == true) && (_itemAutoPeelInfo.isPause == false)))
	{
		return true;
	}
	return false;
}

function bool IsItemReady()
{
	if((_itemAutoPeelInfo.targetItemSId > 0))
	{
		return true;
	}
	return false;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

event OnShow()
{
	itemPeelEffect.SetNPCInfo(19671);
	itemPeelEffect.SpawnNPC();
	ResetInfo();
	Me.SetFocus();
	UpdateUIControls();
	_is_waiting_close = false;
	return;
}

event OnHide()
{
	if(DialogIsMine())
	{
		DialogHide();
	}
	if((_itemAutoPeelInfo.targetItemSId > 0))
	{
		Rq_C_EX_STOP_ITEM_AUTO_PEEL();
	}
	return;
}

event OnDropItem(string strID, ItemInfo Info, int X, int Y)
{
	if((strID == "BoxItem_itemWnd"))
	{
		if((Class'NWindow.UIDATA_ITEM'.static.IsDefaultActionPeel(Info.Id.ClassID) == false))
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(1960));
			return;
		}
		RegisterItem(Info.Id.ServerID, false);
	}
	return;
}

event OnDBClickItem(string strID, int Index)
{
	if((strID == "BoxItem_itemWnd"))
	{
		if(((_itemAutoPeelInfo.isPeeling == true) && (_itemAutoPeelInfo.isPause == false)))
		{
		}
		else
		{
			ResetTargetItem();
		}
	}
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "ExpandBTN":
			SetExpand(true);
			break;
		default:
			break;
	}
	return;
}

event OnTimer(int TimerID)
{
	if((TimerID == 1))
	{
		KillItemPeelDelayTimer();
		CheckAndContinueItemPeel();
	}
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(1026));
	RegisterEvent(EV_PacketID(1027));
	RegisterEvent(EV_PacketID(1028));
	RegisterEvent(40);
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_PacketID(1026):
			Rs_S_EX_READY_ITEM_AUTO_PEEL();
			break;
		case EV_PacketID(1027):
			Rs_S_EX_RESULT_ITEM_AUTO_PEEL();
			break;
		case EV_PacketID(1028):
			Rs_S_EX_STOP_ITEM_AUTO_PEEL();
			break;
		case 40:
			StopItemAutoPeel();
			ResetInfo();
			break;
		default:
			break;
	}
	return;
}

event OnItemCountDialogConfirm()
{
	local INT64 reserved2;
	local int itemSId;
	local INT64 Number;

	if(DialogIsMine())
	{
		Number = INT64(DialogGetString());
		if((Number < INT64(1)))
		{
			return;
		}
		reserved2 = DialogGetReservedInt2();
		itemSId = DialogGetReservedItemID().ServerID;
		_itemAutoPeelInfo.readyTotalPeelCnt = Number;
		_itemAutoPeelInfo.readyTargetItemSid = itemSId;
		Rq_C_EX_READY_ITEM_AUTO_PEEL(itemSId);
	}
	return;
}

event OnItemCountDialogCancel()
{
	if(DialogIsMine())
	{
		if((_is_opened_dialog == true))
		{
			_is_opened_dialog = false;
			SetCountDialogModal(false);
		}
	}
	return;
}

event OnItemCountDialogHide()
{
	if((DialogIsMine() == true))
	{
		if((_is_opened_dialog == true))
		{
			_is_opened_dialog = false;
			SetCountDialogModal(false);
		}
	}
	return;
}

function Rq_C_EX_READY_ITEM_AUTO_PEEL(int itemServerID)
{
	local array<byte> stream;
	local UIPacket._C_EX_READY_ITEM_AUTO_PEEL packet;

	packet.nItemSid = itemServerID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_READY_ITEM_AUTO_PEEL(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(789, stream);
	return;
}

function Rq_C_EX_REQUEST_ITEM_AUTO_PEEL(int itemServerID, INT64 remainPeelCnt, INT64 totalPeelCnt)
{
	local array<byte> stream;
	local UIPacket._C_EX_REQUEST_ITEM_AUTO_PEEL packet;

	packet.nItemSid = itemServerID;
	packet.nRemainPeelCount = remainPeelCnt;
	packet.nTotalPeelCount = totalPeelCnt;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_REQUEST_ITEM_AUTO_PEEL(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(790, stream);
	return;
}

function Rq_C_EX_STOP_ITEM_AUTO_PEEL()
{
	local array<byte> stream;
	local UIPacket._C_EX_STOP_ITEM_AUTO_PEEL packet;

	if(!Class'Interface.UIPacket'.static.Encode_C_EX_STOP_ITEM_AUTO_PEEL(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(791, stream);
	return;
}

function Rs_S_EX_READY_ITEM_AUTO_PEEL()
{
	local UIPacket._S_EX_READY_ITEM_AUTO_PEEL packet;
	local bool IsSuccess;
	local ItemInfo targetItemInfo;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_READY_ITEM_AUTO_PEEL(packet))
	{
		return;
	}
	IsSuccess = bool(packet.bResult);
	if((IsSuccess == true))
	{
		_itemAutoPeelInfo.targetItemSId = packet.nItemSid;
		if((Class'NWindow.UIDATA_INVENTORY'.static.FindItem(_itemAutoPeelInfo.targetItemSId, targetItemInfo) == true))
		{
			_itemAutoPeelInfo.targetItemName = targetItemInfo.Name;
			if((_itemAutoPeelInfo.readyTotalPeelCnt == INT64(0)))
			{
				_itemAutoPeelInfo.totalPeelCnt = targetItemInfo.ItemNum;
				_itemAutoPeelInfo.remainPeelCnt = _itemAutoPeelInfo.totalPeelCnt;
			}
			else
			{
				_itemAutoPeelInfo.totalPeelCnt = Min64(_itemAutoPeelInfo.readyTotalPeelCnt, targetItemInfo.ItemNum);
				_itemAutoPeelInfo.remainPeelCnt = _itemAutoPeelInfo.totalPeelCnt;
			}
		}
		ResetResultInfo();
	}
	else
	{
		ResetTargetInfo();
	}
	_itemAutoPeelInfo.readyTargetItemSid = 0;
	_itemAutoPeelInfo.readyTotalPeelCnt = INT64(0);
	UpdateUIControls();
	return;
}

function Rs_S_EX_RESULT_ITEM_AUTO_PEEL()
{
	local UIPacket._S_EX_RESULT_ITEM_AUTO_PEEL packet;
	local bool IsSuccess;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_RESULT_ITEM_AUTO_PEEL(packet))
	{
		return;
	}
	IsSuccess = bool(packet.bResult);
	if((IsSuccess == true))
	{
		_itemAutoPeelInfo.remainPeelCnt = packet.nRemainPeelCount;
		_itemAutoPeelInfo.totalPeelCnt = packet.nTotalPeelCount;
		AddResultItemInfo(packet.vResultItemList);
		PlayItemPeelEffect();
		if(((packet.nRemainPeelCount == INT64(0)) && (packet.nTotalPeelCount > INT64(0))))
		{
			CompleteItemAutoPeel();
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13656));
			Rq_C_EX_STOP_ITEM_AUTO_PEEL();
			return;
		}
		else
		{
			StartItemPeelDelayTimer();
		}
	}
	else if((_itemAutoPeelInfo.targetItemSId == 0))
	{
		StopItemAutoPeel();
	}
	else
	{
		if((_itemAutoPeelInfo.remainPeelCnt > GetTargetItemNum()))
		{
			_itemAutoPeelInfo.remainPeelCnt = GetTargetItemNum();
		}
		PauseItemAutoPeel();
	}
	UpdateUIControls();
	return;
}

function Rs_S_EX_STOP_ITEM_AUTO_PEEL()
{
	local UIPacket._S_EX_STOP_ITEM_AUTO_PEEL packet;
	local bool IsSuccess;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_STOP_ITEM_AUTO_PEEL(packet))
	{
		return;
	}
	IsSuccess = bool(packet.bResult);
	if((IsSuccess == true))
	{
		ResetTargetInfo();
		if((_is_waiting_close == true))
		{
			_is_waiting_close = false;
			Me.HideWindow();
			ResetInfo();
		}
	}
	else if((_is_waiting_close == true))
	{
	}
	UpdateUIControls();
	UpdateWnd();
	return;
}

function HandleUpdateTargetItem(optional array<ItemInfo> iInfo, optional int Index)
{
	if(((_itemAutoPeelInfo.targetItemSId > 0) && (iInfo.Length > 0)))
	{
		if((iInfo[0].ItemNum == INT64(0)))
		{
			UpdateUIControls();
		}
	}
	return;
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	CloseWindow();
	return;
}
