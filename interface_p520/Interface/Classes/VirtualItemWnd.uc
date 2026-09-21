class VirtualItemWnd extends UICommonAPI
	dependson(UIPacket);

const TIMER_ID_LEFT_TIME = 1;
const TIME_LEFT_TIME = 60000;
const VIRTUAL_ITEM_MULTI_SELL_ID = 3222;

enum E_VI_UPDATE_TYPE
{
	E_VI_UPDATE_TYPE_INVALID,       // 0
	E_VI_UPDATE_TYPE_OPEN,          // 1
	E_VI_UPDATE_TYPE_UPDATE,        // 2
	E_VI_UPDATE_TYPE_RESET,         // 3
	E_VI_UPDATE_TYPE_MAX            // 4
};

enum E_VI_DIALOG_TYPE
{
	E_VI_DIALOG_NONE,               // 0
	E_VI_DIALOG_ALL_RESET,          // 1
	E_VI_DIALOG_SLOT_RESET,         // 2
	E_VI_DIALOG_APPLY,              // 3
	E_VI_DIALOG_MAX                 // 4
};


struct VirtualItemUIInfo
{
	var bool isOpen;
	var int RemainTime;
	var int GetPoint;
	var int usedPoint;
	var int MaxPoint;
	var INT64 selectedSBT;
	var int selectedSlot;
	var E_VI_DIALOG_TYPE dialogType;
	var int decoNum;
	var int agathionNum;
	var int jewelNum;
};

struct VirtualItemSetInfo
{
	var int oldMainIndex;
	var int oldSubIndex;
	var int newMainIndex;
	var int newSubIndex;
};

struct VirtualSlot
{
	var VirtualSlotInfo slotInfo;
	var VirtualItemWndSlot slotObject;
};

var WindowHandle Me;
var WindowHandle dialogContainer;
var WindowHandle emptyListWnd;
var ButtonHandle refreshBtn;
var ButtonHandle applyBtn;
var ButtonHandle CancelBtn;
var ButtonHandle slotResetBtn;
var ButtonHandle allResetBtn;
var ButtonHandle enchantUpBtn;
var ButtonHandle enchantDownBtn;
var ButtonHandle enchantMaxBtn;
var ButtonHandle enchantResetBtn;
var UIControlDialogAssets dialogAsset;
var SideBar SideBarScript;
var RichListCtrlHandle virtualItemRichList;
var TextBoxHandle setInfoTextBox;
var TextBoxHandle setTypeTextBox;
var TextBoxHandle usePointTextBox;
var TextBoxHandle leftPointTextBox;
var TextBoxHandle getPointTextBox;
var TextBoxHandle maxPointTextBox;
var TextBoxHandle leftTimeTextBox;
var TextBoxHandle enchantTextBox;
var TextBoxHandle emptyListTextBox;
var TextBoxHandle pointSetTitle;
var array<VirtualSlot> _virtualSlots;
var VirtualItemSetInfo _setInfo;
var VirtualItemUIInfo _uiInfo;

static function VirtualItemWnd Inst()
{
	return VirtualItemWnd(GetScript("VirtualItemWnd"));
}

function Initialize()
{
	ResetUIInfo();
	InitControls();
	return;
}

function InitControls()
{
	local string ownerFullPath;
	local WindowHandle slotContainer, pointContainer, slotSetContainer, listContainer, enchantSetContainer;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	slotContainer = GetWindowHandle((ownerFullPath $ ".VirtualEquip_Inventory"));
	listContainer = GetWindowHandle((ownerFullPath $ ".VirtualEquipListWnd"));
	slotSetContainer = GetWindowHandle((ownerFullPath $ ".VirtualEquipSetWnd"));
	emptyListWnd = GetWindowHandle((listContainer.m_WindowNameWithFullPath $ ".DisableListWnd"));
	pointContainer = GetWindowHandle((slotSetContainer.m_WindowNameWithFullPath $ ".PointWnd"));
	enchantSetContainer = GetWindowHandle((pointContainer.m_WindowNameWithFullPath $ ".EnchantNumberInput"));
	refreshBtn = GetButtonHandle((slotContainer.m_WindowNameWithFullPath $ ".VirtualEquip_RefreshBtn"));
	applyBtn = GetButtonHandle((slotSetContainer.m_WindowNameWithFullPath $ ".ApplyBtn"));
	CancelBtn = GetButtonHandle((slotSetContainer.m_WindowNameWithFullPath $ ".CancleBtn"));
	allResetBtn = GetButtonHandle((slotContainer.m_WindowNameWithFullPath $ ".All_ResetBtn"));
	slotResetBtn = GetButtonHandle((slotSetContainer.m_WindowNameWithFullPath $ ".SlotResetBtn"));
	setTypeTextBox = GetTextBoxHandle((slotSetContainer.m_WindowNameWithFullPath $ ".VirtualEquipName_txt"));
	setInfoTextBox = GetTextBoxHandle((slotSetContainer.m_WindowNameWithFullPath $ ".VirtualEquipGuide_txt"));
	pointSetTitle = GetTextBoxHandle((slotSetContainer.m_WindowNameWithFullPath $ ".PointSetTitle_txt"));
	leftTimeTextBox = GetTextBoxHandle((slotSetContainer.m_WindowNameWithFullPath $ ".TimeLeft_txt"));
	emptyListTextBox = GetTextBoxHandle((emptyListWnd.m_WindowNameWithFullPath $ ".DisableList_txt"));
	virtualItemRichList = GetRichListCtrlHandle((slotSetContainer.m_WindowNameWithFullPath $ ".VirtualEquipList_ListCtrl"));
	virtualItemRichList.SetUseStripeBackTexture(false);
	virtualItemRichList.SetSelectedSelTooltip(false);
	virtualItemRichList.SetSelectable(false);
	virtualItemRichList.SetAppearTooltipAtMouseX(true);
	virtualItemRichList.SetTooltipType("VirtualItemListTooltip");
	enchantTextBox = GetTextBoxHandle((enchantSetContainer.m_WindowNameWithFullPath $ ".Enchant_TextBox"));
	enchantUpBtn = GetButtonHandle((enchantSetContainer.m_WindowNameWithFullPath $ ".Enchant_Up_Button"));
	enchantDownBtn = GetButtonHandle((enchantSetContainer.m_WindowNameWithFullPath $ ".Enchant_Down_Button"));
	enchantMaxBtn = GetButtonHandle((enchantSetContainer.m_WindowNameWithFullPath $ ".Enchant_Max_Button"));
	enchantResetBtn = GetButtonHandle((enchantSetContainer.m_WindowNameWithFullPath $ ".Enchant_Reset_Btn"));
	usePointTextBox = GetTextBoxHandle((pointContainer.m_WindowNameWithFullPath $ ".UsePoint_txt"));
	leftPointTextBox = GetTextBoxHandle((pointContainer.m_WindowNameWithFullPath $ ".AvailablePoint_txt"));
	getPointTextBox = GetTextBoxHandle((pointContainer.m_WindowNameWithFullPath $ ".GetPoint_txt"));
	maxPointTextBox = GetTextBoxHandle((pointContainer.m_WindowNameWithFullPath $ ".MaxPoint_txt"));
	dialogContainer = GetWindowHandle((ownerFullPath $ ".VirtualEquipment_PopUpWnd"));
	dialogAsset = Class'Interface.UIControlDialogAssets'.static.InitScript(GetWindowHandle((dialogContainer.m_WindowNameWithFullPath $ ".UIControlDialogAsset")));
	dialogAsset.DelegateOnClickBuy = OnDialogConfirm;
	dialogAsset.DelegateOnCancel = OnDialogCancel;
	dialogAsset.SetUseBuyItem(false);
	dialogAsset.SetUseNeedItem(false);
	dialogAsset.SetUseNumberInput(false);
	SideBarScript = SideBar(GetScript("SideBar"));
	InitSlotControls(slotContainer);
	return;
}

function InitSlotControls(WindowHandle slotContainer)
{
	local WindowHandle jewelWnd, talismanWnd, agathionWnd;

	jewelWnd = GetWindowHandle((slotContainer.m_WindowNameWithFullPath $ ".EquipItem_Jewel_Window"));
	talismanWnd = GetWindowHandle((slotContainer.m_WindowNameWithFullPath $ ".EquipItem_Talisman_Window"));
	agathionWnd = GetWindowHandle((slotContainer.m_WindowNameWithFullPath $ ".EquipItem_Agathion_Window"));
	_virtualSlots.Length = 0;
	AddSlotControl(_virtualSlots, 0, INT64(64), slotContainer, "VirtualEquipItem_Head", 5250);
	AddSlotControl(_virtualSlots, 0, INT64(65536), slotContainer, "VirtualEquipItem_Hair", 5249);
	AddSlotControl(_virtualSlots, 0, INT64(262144), slotContainer, "VirtualEquipItem_Hair2", 5249);
	AddSlotControl(_virtualSlots, 0, INT64(512), slotContainer, "VirtualEquipItem_Gloves", 5251);
	AddSlotControl(_virtualSlots, 0, INT64(1024), slotContainer, "VirtualEquipItem_Chest", 5252);
	AddSlotControl(_virtualSlots, 0, INT64(4096), slotContainer, "VirtualEquipItem_Boots", 5253);
	AddSlotControl(_virtualSlots, 0, INT64(8192), slotContainer, "VirtualEquipItem_Cloak", 5254);
	AddSlotControl(_virtualSlots, 0, INT64(2048), slotContainer, "VirtualEquipItem_Legs", 5255);
	AddSlotControl(_virtualSlots, 0, INT64(268435456), slotContainer, "VirtualEquipItem_Waist", 5256);
	AddSlotControl(_virtualSlots, 0, INT64(128), slotContainer, "VirtualEquipItem_RHand", 5257);
	AddSlotControl(_virtualSlots, 0, INT64(256), slotContainer, "VirtualEquipItem_LHand", 5258);
	AddSlotControl(_virtualSlots, 0, INT64(4), slotContainer, "VirtualEquipItem_LEar", 5259);
	AddSlotControl(_virtualSlots, 0, INT64(2), slotContainer, "VirtualEquipItem_REar", 5259);
	AddSlotControl(_virtualSlots, 0, INT64(1), slotContainer, "VirtualEquipItem_UnderWear", 5260);
	AddSlotControl(_virtualSlots, 0, INT64(32), slotContainer, "VirtualEquipItem_LFinger", 5261);
	AddSlotControl(_virtualSlots, 0, INT64(16), slotContainer, "VirtualEquipItem_RFinger", 5261);
	AddSlotControl(_virtualSlots, 0, INT64(8), slotContainer, "VirtualEquipItem_Neck", 5262);
	AddSlotControl(_virtualSlots, 0, INT64(536870912), slotContainer, "VirtualEquipItem_Brooch", 5263);
	AddSlotControl(_virtualSlots, 0, INT64(1048576), slotContainer, "VirtualEquipItem_RBracelet", 5264);
	AddSlotControl(_virtualSlots, 0, INT64(2097152), slotContainer, "VirtualEquipItem_LBracelet", 5265);
	AddSlotControl(_virtualSlots, 1, INT64(1073741824), jewelWnd, "JewelItemWnd01", 5266, true);
	AddSlotControl(_virtualSlots, 2, -9223372036854775808, jewelWnd, "JewelItemWnd02", 5266, true);
	AddSlotControl(_virtualSlots, 3, INT64(1), jewelWnd, "JewelItemWnd03", 5266, true);
	AddSlotControl(_virtualSlots, 4, INT64(2), jewelWnd, "JewelItemWnd04", 5266, true);
	AddSlotControl(_virtualSlots, 5, INT64(4), jewelWnd, "JewelItemWnd05", 5266, true);
	AddSlotControl(_virtualSlots, 6, INT64(8), jewelWnd, "JewelItemWnd06", 5266, true);
	AddSlotControl(_virtualSlots, 1, INT64(4194304), talismanWnd, "TalismanItemWnd01", 5267, true);
	AddSlotControl(_virtualSlots, 2, INT64(8388608), talismanWnd, "TalismanItemWnd02", 5267, true);
	AddSlotControl(_virtualSlots, 3, INT64(16777216), talismanWnd, "TalismanItemWnd03", 5267, true);
	AddSlotControl(_virtualSlots, 4, INT64(33554432), talismanWnd, "TalismanItemWnd04", 5267, true);
	AddSlotControl(_virtualSlots, 5, INT64(67108864), talismanWnd, "TalismanItemWnd05", 5267, true);
	AddSlotControl(_virtualSlots, 6, INT64(134217728), talismanWnd, "TalismanItemWnd06", 5267, true);
	AddSlotControl(_virtualSlots, 1, INT64(16), agathionWnd, "AgathionItemWnd01", 5268, true);
	AddSlotControl(_virtualSlots, 2, INT64(32), agathionWnd, "AgathionItemWnd02", 5268, true);
	AddSlotControl(_virtualSlots, 3, INT64(64), agathionWnd, "AgathionItemWnd03", 5268, true);
	AddSlotControl(_virtualSlots, 4, INT64(128), agathionWnd, "AgathionItemWnd04", 5268, true);
	AddSlotControl(_virtualSlots, 5, INT64(256), agathionWnd, "AgathionItemWnd05", 5268, true);
	AddSlotControl(_virtualSlots, 1, INT64(0), slotContainer, "VirtualBuffSlot00_Wnd", 5269, false, true);
	AddSlotControl(_virtualSlots, 2, INT64(0), slotContainer, "VirtualBuffSlot01_Wnd", 5269, false, true);
	AddSlotControl(_virtualSlots, 3, INT64(0), slotContainer, "VirtualBuffSlot02_Wnd", 5269, false, true);
	return;
}

function AddSlotControl(out array<VirtualSlot> slots, int SlotIndex, INT64 SlotBitType, WindowHandle parentWnd, string wndname, int strID, optional bool isSubSlot, optional bool isBuffSlot)
{
	local WindowHandle slotWnd;
	local VirtualItemWndSlot slotObject;
	local VirtualSlot Slot;
	local VirtualSlotInfo slotInfo;

	slotInfo.SlotBitType = SlotBitType;
	slotInfo.SlotIndex = SlotIndex;
	slotInfo.isSubSlot = isSubSlot;
	slotInfo.isBuffSlot = isBuffSlot;
	slotInfo.slotNameStrId = strID;
	slotWnd = GetWindowHandle(((parentWnd.m_WindowNameWithFullPath $ ".") $ wndname));
	slotWnd.SetScript("VirtualItemWndSlot");
	slotObject = VirtualItemWndSlot(slotWnd.GetScript());
	slotObject.Init(slotWnd, isSubSlot);
	slotObject.SetInfo(slotInfo);
	slotObject.DelegateOnSlotClicked = OnSlotClicked;
	Slot.slotInfo = slotInfo;
	Slot.slotObject = slotObject;
	slots[slots.Length] = Slot;
	return;
}

function bool IsVirtualItemOpened()
{
	return _uiInfo.isOpen;
}

function ResetUIInfo()
{
	local VirtualItemUIInfo defaultInfo;

	_uiInfo = defaultInfo;
	_uiInfo.selectedSBT = INT64(128);
	return;
}

function InitSlotSettingInfo(int mainIndex, int SubIndex)
{
	_setInfo.oldMainIndex = mainIndex;
	_setInfo.oldSubIndex = SubIndex;
	_setInfo.newMainIndex = mainIndex;
	_setInfo.newSubIndex = SubIndex;
	return;
}

function SetNewSlotSettingInfo(int newMainIndex, int newSubIndex)
{
	_setInfo.newMainIndex = newMainIndex;
	_setInfo.newSubIndex = newSubIndex;
	return;
}

function SetNewSlotSubIndexSettingInfo(int newSubIndex)
{
	_setInfo.newSubIndex = newSubIndex;
	return;
}

function UndoSlotSettingInfo()
{
	_setInfo.newMainIndex = _setInfo.oldMainIndex;
	_setInfo.newSubIndex = _setInfo.oldSubIndex;
	return;
}

function bool IsChangeSlotSetting()
{
	if(((_setInfo.oldMainIndex == _setInfo.newMainIndex) && (_setInfo.oldSubIndex == _setInfo.newSubIndex)))
	{
		return false;
	}
	return true;
}

function UpdateVirtualItemInfos(UIPacket._S_EX_VIRTUALITEM_SYSTEM packet)
{
	local int i, j;
	local UIPacket._VirtualItemInfo sVItemInfo;
	local VirtualItemInfo cVItemInfo;
	local bool IsVirtualItem;
	local VirtualSlot tempSlotInfo;

	if((packet.cResult != 1))
	{
		return;
	}
	i = 0;
	while((i < _virtualSlots.Length))
	{
		tempSlotInfo = _virtualSlots[i];
		IsVirtualItem = false;
		j = 0;
		while((j < packet.lstVISItemInfoList.Length))
		{
			sVItemInfo = packet.lstVISItemInfoList[j];
			GetVirtualItemInfo_IndexDetail(sVItemInfo.nIndexMain, sVItemInfo.nIndexSub, cVItemInfo);
			if(((tempSlotInfo.slotInfo.SlotBitType == GetValidSubSlotBitType(GetValidSlotBitType(cVItemInfo.nSBT), sVItemInfo.nSlot)) && (tempSlotInfo.slotInfo.SlotIndex == sVItemInfo.nSlot)))
			{
				tempSlotInfo.slotInfo.vMainIndex = sVItemInfo.nIndexMain;
				tempSlotInfo.slotInfo.vSubIndex = sVItemInfo.nIndexSub;
				tempSlotInfo.slotInfo.point = sVItemInfo.nCostVISPoint;
				tempSlotInfo.slotInfo.ClassID = sVItemInfo.nItemClass;
				tempSlotInfo.slotInfo.IsVirtualItem = true;
				IsVirtualItem = true;
				break;
			}
			j++;
		}
		if((IsVirtualItem == false))
		{
			tempSlotInfo.slotInfo.vMainIndex = 0;
			tempSlotInfo.slotInfo.vSubIndex = 0;
			tempSlotInfo.slotInfo.point = 0;
			tempSlotInfo.slotInfo.ClassID = 0;
			tempSlotInfo.slotInfo.IsVirtualItem = false;
		}
		_virtualSlots[i] = tempSlotInfo;
		i++;
	}
	return;
}

function UpdateUIControls()
{
	UpdateUISlotControls();
	UpdateUISlotSetControls();
	UpdateLeftTimerControls();
	return;
}

function UpdateLeftTimerControls()
{
	local WindowHandle btnWnd;
	local string leftTimeStr;

	leftTimeStr = GetSystemString(5314);
	leftTimeTextBox.SetText(leftTimeStr);
	btnWnd = SideBarScript.GetWindowByIndex(28);
	btnWnd.SetTooltipCustomType(MakeTooltipMultiText(GetSystemString(5247), getInstanceL2Util().White, "", true, leftTimeStr, getInstanceL2Util().Yellow, "", true));
	return;
}

function UpdateUISlotControls()
{
	local int i, j, agathionNum, decoNum, jewelNum;
	local array<ItemInfo> equipItems;
	local VirtualSlot tempSlotInfo;
	local SkillInfo SkillInfo;
	local ItemInfo tempEquipItemInfo, validItemInfo, emptyItemInfo;
	local bool isHairAllType;
	local UserInfo User;

	GetPlayerInfo(User);
	Class'NWindow.UIDATA_INVENTORY'.static.GetAllEquipItem(equipItems, true);
	decoNum = User.nTalismanNum;
	agathionNum = (User.nAgathionMainNum + User.nAgathionSubNum);
	jewelNum = User.nJewelNum;
	i = 0;
	while((i < _virtualSlots.Length))
	{
		tempSlotInfo = _virtualSlots[i];
		validItemInfo = emptyItemInfo;
		tempSlotInfo.slotInfo.isDisabled = false;
		if(((_uiInfo.selectedSBT == tempSlotInfo.slotInfo.SlotBitType) && (_uiInfo.selectedSlot == tempSlotInfo.slotInfo.SlotIndex)))
		{
			tempSlotInfo.slotObject.SetSelcted(true);
		}
		else
		{
			tempSlotInfo.slotObject.SetSelcted(false);
		}
		j = 0;
		while((j < equipItems.Length))
		{
			tempEquipItemInfo = equipItems[j];
			if((tempEquipItemInfo.SlotBitType == INT64(524288)))
			{
				isHairAllType = true;
			}
			if((GetValidSlotBitType(tempEquipItemInfo.SlotBitType) == tempSlotInfo.slotInfo.SlotBitType))
			{
				validItemInfo = tempEquipItemInfo;
				break;
			}
			j++;
		}
		if(((tempSlotInfo.slotInfo.SlotBitType == INT64(262144)) && isHairAllType))
		{
			tempSlotInfo.slotInfo.isDisabled = true;
		}
		if(((tempSlotInfo.slotInfo.SlotBitType == INT64(16)) && (agathionNum < 1)))
		{
			tempSlotInfo.slotInfo.isDisabled = true;
		}
		if(((tempSlotInfo.slotInfo.SlotBitType == INT64(32)) && (agathionNum < 2)))
		{
			tempSlotInfo.slotInfo.isDisabled = true;
		}
		if(((tempSlotInfo.slotInfo.SlotBitType == INT64(64)) && (agathionNum < 3)))
		{
			tempSlotInfo.slotInfo.isDisabled = true;
		}
		if(((tempSlotInfo.slotInfo.SlotBitType == INT64(128)) && (agathionNum < 4)))
		{
			tempSlotInfo.slotInfo.isDisabled = true;
		}
		if(((tempSlotInfo.slotInfo.SlotBitType == INT64(256)) && (agathionNum < 5)))
		{
			tempSlotInfo.slotInfo.isDisabled = true;
		}
		if(((tempSlotInfo.slotInfo.SlotBitType == INT64(1073741824)) && (jewelNum < 1)))
		{
			tempSlotInfo.slotInfo.isDisabled = true;
		}
		if(((tempSlotInfo.slotInfo.SlotBitType == -9223372036854775808) && (jewelNum < 2)))
		{
			tempSlotInfo.slotInfo.isDisabled = true;
		}
		if(((tempSlotInfo.slotInfo.SlotBitType == INT64(1)) && (jewelNum < 3)))
		{
			tempSlotInfo.slotInfo.isDisabled = true;
		}
		if(((tempSlotInfo.slotInfo.SlotBitType == INT64(2)) && (jewelNum < 4)))
		{
			tempSlotInfo.slotInfo.isDisabled = true;
		}
		if(((tempSlotInfo.slotInfo.SlotBitType == INT64(4)) && (jewelNum < 5)))
		{
			tempSlotInfo.slotInfo.isDisabled = true;
		}
		if(((tempSlotInfo.slotInfo.SlotBitType == INT64(8)) && (jewelNum < 6)))
		{
			tempSlotInfo.slotInfo.isDisabled = true;
		}
		if(((tempSlotInfo.slotInfo.SlotBitType == INT64(4194304)) && (decoNum < 1)))
		{
			tempSlotInfo.slotInfo.isDisabled = true;
		}
		if(((tempSlotInfo.slotInfo.SlotBitType == INT64(8388608)) && (decoNum < 2)))
		{
			tempSlotInfo.slotInfo.isDisabled = true;
		}
		if(((tempSlotInfo.slotInfo.SlotBitType == INT64(16777216)) && (decoNum < 3)))
		{
			tempSlotInfo.slotInfo.isDisabled = true;
		}
		if(((tempSlotInfo.slotInfo.SlotBitType == INT64(33554432)) && (decoNum < 4)))
		{
			tempSlotInfo.slotInfo.isDisabled = true;
		}
		if(((tempSlotInfo.slotInfo.SlotBitType == INT64(67108864)) && (decoNum < 5)))
		{
			tempSlotInfo.slotInfo.isDisabled = true;
		}
		if(((tempSlotInfo.slotInfo.SlotBitType == INT64(134217728)) && (decoNum < 6)))
		{
			tempSlotInfo.slotInfo.isDisabled = true;
		}
		if(((tempSlotInfo.slotInfo.isBuffSlot == true) && (tempSlotInfo.slotInfo.ClassID > 0)))
		{
			GetSkillInfo(tempSlotInfo.slotInfo.ClassID, GetVirtualItemEnchantInfo(tempSlotInfo.slotInfo.vMainIndex, tempSlotInfo.slotInfo.vSubIndex).nEnchant, 0, SkillInfo);
			Class'Interface.L2Util'.static.GetSkill2ItemInfo(SkillInfo, validItemInfo);
		}
		tempSlotInfo.slotInfo.ItemInfo = validItemInfo;
		if(((tempSlotInfo.slotInfo.ItemInfo.Id.ClassID > 0) && (tempSlotInfo.slotInfo.isBuffSlot == true)))
		{
			tempSlotInfo.slotInfo.ItemInfo.IsVirtualItem = true;
		}
		tempSlotInfo.slotObject.SetInfo(tempSlotInfo.slotInfo);
		_virtualSlots[i] = tempSlotInfo;
		i++;
	}
	tempSlotInfo = GetVirtualSlot(INT64(262144), 0);
	if(isHairAllType)
	{
		tempSlotInfo.slotInfo.isDisabled = true;
	}
	else
	{
		tempSlotInfo.slotInfo.isDisabled = false;
	}
	tempSlotInfo.slotObject.SetInfo(tempSlotInfo.slotInfo);
	return;
}

function UpdateUISlotSetControls(optional bool isInit)
{
	local VirtualSlotInfo slotInfo;
	local RichListCtrlRowData rowData;
	local array<int> itemIndexList;
	local array<VirtualItemInfo> enchantList;
	local VirtualItemInfo tempVItemInfo;
	local ItemInfo tmepItemInfo;
	local int i, mainIndex, recordCnt, deleteIndex, equipPoint, slotUsedPoint, leftPoint;
	local Color TextColor;
	local string itemNameStr, itemParam, leftPointStr;
	local L2Util util;
	local SkillInfo SkillInfo;
	local bool isEquipped;

	util = L2Util(GetScript("L2Util"));
	slotInfo = GetVirtualSlot(_uiInfo.selectedSBT, _uiInfo.selectedSlot).slotInfo;
	GetVirtualItemInfo_SBT(_uiInfo.selectedSBT, itemIndexList);
	if(isInit)
	{
		InitSlotSettingInfo(slotInfo.vMainIndex, slotInfo.vSubIndex);
	}
	setTypeTextBox.SetText(GetSystemString(slotInfo.slotNameStrId));
	if(slotInfo.isBuffSlot)
	{
		setInfoTextBox.SetText(GetSystemString(5273));
		pointSetTitle.SetText(GetSystemString(5278));
	}
	else
	{
		setInfoTextBox.SetText(GetSystemString(5272));
		pointSetTitle.SetText(GetSystemString(5277));
	}
	slotUsedPoint = GetSlotUsePoint(_setInfo.newMainIndex, _setInfo.newSubIndex);
	leftPoint = ((_uiInfo.GetPoint - _uiInfo.usedPoint) - (slotUsedPoint - slotInfo.point));
	if((leftPoint < 0))
	{
		leftPointStr = MakeCostString(string(-leftPoint));
		leftPointStr = ("-" $ leftPointStr);
	}
	else
	{
		leftPointStr = MakeCostString(string(leftPoint));
	}
	usePointTextBox.SetText(MakeCostString(string(slotUsedPoint)));
	leftPointTextBox.SetText(leftPointStr);
	getPointTextBox.SetText(MakeCostString(string(_uiInfo.GetPoint)));
	if((leftPoint < 0))
	{
		usePointTextBox.SetTextColor(util.Red);
	}
	else
	{
		usePointTextBox.SetTextColor(util.Yellow);
	}
	maxPointTextBox.SetText(MakeCostString(string(_uiInfo.MaxPoint)));
	SetEnchantStepperValue(_setInfo.newMainIndex, _setInfo.newSubIndex);
	if((IsChangeSlotSetting() && (leftPoint >= 0)))
	{
		applyBtn.SetEnable(true);
	}
	else
	{
		applyBtn.SetEnable(false);
	}
	if((_setInfo.oldMainIndex != 0))
	{
		slotResetBtn.SetEnable(true);
	}
	else
	{
		slotResetBtn.SetEnable(false);
	}
	if((_uiInfo.usedPoint > 0))
	{
		allResetBtn.SetEnable(true);
	}
	else
	{
		allResetBtn.SetEnable(false);
	}
	rowData.cellDataList.Length = 3;
	recordCnt = virtualItemRichList.GetRecordCount();
	deleteIndex = 0;
	if((slotInfo.isDisabled && slotInfo.isSubSlot))
	{
		itemIndexList.Length = 0;
	}
	i = 0;
	while((i < Max(itemIndexList.Length, recordCnt)))
	{
		if((i < itemIndexList.Length))
		{
			rowData.cellDataList[0].drawitems.Length = 0;
			rowData.cellDataList[1].drawitems.Length = 0;
			rowData.cellDataList[2].drawitems.Length = 0;
			mainIndex = itemIndexList[i];
			GetVirtualItemInfo_Index(mainIndex, enchantList);
			tempVItemInfo = enchantList[0];
			equipPoint = tempVItemInfo.nEnchantPoints;
			if((mainIndex == _setInfo.newMainIndex))
			{
				isEquipped = true;
			}
			else
			{
				isEquipped = false;
			}
			if(isEquipped)
			{
				if((enchantList.Length > (_setInfo.newSubIndex - 1)))
				{
					tempVItemInfo = enchantList[(_setInfo.newSubIndex - 1)];
				}
				rowData.sOverlayTex = "L2UI_NewTex.VirtualEquipmentWnd.ListSelectBg";
				rowData.OverlayTexU = 197;
				rowData.OverlayTexV = 52;
				TextColor = util.Yellow;
			}
			else
			{
				rowData.sOverlayTex = "";
				TextColor = util.White;
			}
			if(slotInfo.isBuffSlot)
			{
				GetSkillInfo(tempVItemInfo.nClassID, tempVItemInfo.nEnchant, 0, SkillInfo);
				Class'Interface.L2Util'.static.GetSkill2ItemInfo(SkillInfo, tmepItemInfo);
			}
			else
			{
				tmepItemInfo = GetItemInfoByClassID(tempVItemInfo.nClassID);
			}
			if((tempVItemInfo.nEnchant > 0))
			{
				tmepItemInfo.Enchanted = tempVItemInfo.nEnchant;
				itemNameStr = (("+" $ string(tempVItemInfo.nEnchant)) @ tmepItemInfo.Name);
			}
			else
			{
				itemNameStr = tmepItemInfo.Name;
			}
			tmepItemInfo.IsVirtualItem = true;
			ItemInfoToParam(tmepItemInfo, itemParam);
			rowData.szReserved = itemParam;
			addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, 1);
			AddRichListCtrlItem(rowData.cellDataList[0].drawitems, tmepItemInfo, 32, 32, -34, 1);
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, itemNameStr, TextColor, false, 4, 8);
			AddRichListCtrlString(rowData.cellDataList[1].drawitems, MakeCostString(string(equipPoint)), TextColor, false, 0, 4);
			if(isEquipped)
			{
				AddRichListCtrlButton(rowData.cellDataList[2].drawitems, ("listCheckBtn_" @ string(mainIndex)), 0, 0, "L2UI_NewTex.SkyTowerWnd.List_CheckBox_On", "L2UI_NewTex.SkyTowerWnd.List_CheckBox_On", "L2UI_NewTex.SkyTowerWnd.List_CheckBox_On", 28, 28, 28, 28, int(isEquipped));
			}
			else
			{
				AddRichListCtrlButton(rowData.cellDataList[2].drawitems, ("listCheckBtn_" @ string(mainIndex)), 0, 0, "L2UI_NewTex.SkyTowerWnd.List_CheckBox_Off", "L2UI_NewTex.SkyTowerWnd.List_CheckBox_Off", "L2UI_NewTex.SkyTowerWnd.List_CheckBox_Off", 28, 28, 28, 28, int(isEquipped));
			}
			if((i < recordCnt))
			{
				virtualItemRichList.ModifyRecord(i, rowData);
			}
			else
			{
				virtualItemRichList.InsertRecord(rowData);
			}
			i++;
			continue;
		}
		virtualItemRichList.DeleteRecord(((recordCnt - deleteIndex) - 1));
		deleteIndex++;
		i++;
	}
	if((virtualItemRichList.GetRecordCount() > 0))
	{
		emptyListWnd.HideWindow();
	}
	else
	{
		emptyListWnd.ShowWindow();
		if((slotInfo.isDisabled && slotInfo.isSubSlot))
		{
			emptyListTextBox.SetText(GetSystemString(5292));
		}
		else
		{
			emptyListTextBox.SetText(GetSystemString(5299));
		}
	}
	return;
}

function int GetSlotUsePoint(int mainIndex, int SubIndex)
{
	local int i, point;
	local array<VirtualItemInfo> enchantList;

	if((mainIndex == 0))
	{
		return point;
	}
	GetVirtualItemInfo_Index(mainIndex, enchantList);
	i = 0;
	while((i < SubIndex))
	{
		if((enchantList.Length > i))
		{
			point = (point + enchantList[i].nEnchantPoints);
		}
		i++;
	}
	return point;
}

function VirtualItemInfo GetVirtualItemEnchantInfo(int mainIndex, int SubIndex)
{
	local VirtualItemInfo enchantInfo;
	local array<VirtualItemInfo> enchantList;
	local int Index;

	Index = (SubIndex - 1);
	GetVirtualItemInfo_Index(mainIndex, enchantList);
	if(((Index >= 0) && (enchantList.Length > Index)))
	{
		return enchantList[Index];
	}
	return enchantInfo;
}

function VirtualSlot GetVirtualSlot(INT64 SlotBitType, int SlotIndex)
{
	local VirtualSlot tempSlot, targetSlot;
	local int i;

	i = 0;
	while((i < _virtualSlots.Length))
	{
		tempSlot = _virtualSlots[i];
		if(((tempSlot.slotInfo.SlotBitType == SlotBitType) && (tempSlot.slotInfo.SlotIndex == SlotIndex)))
		{
			targetSlot = tempSlot;
			break;
		}
		i++;
	}
	return targetSlot;
}

function INT64 GetValidSlotBitType(INT64 SlotBitType)
{
	local INT64 validSBT;

	validSBT = SlotBitType;
	if((SlotBitType == INT64(16384)))
	{
		validSBT = INT64(128);
	}
	if((SlotBitType == INT64(524288)))
	{
		validSBT = INT64(65536);
	}
	return validSBT;
}

function INT64 GetValidSubSlotBitType(INT64 SlotBitType, int subSlot)
{
	local INT64 resultSBT;

	resultSBT = SlotBitType;
	if((subSlot > 1))
	{
		if((SlotBitType == INT64(16)))
		{
			switch(subSlot)
			{
				case 2:
					resultSBT = INT64(32);
					break;
				case 3:
					resultSBT = INT64(64);
					break;
				case 4:
					resultSBT = INT64(128);
					break;
				case 5:
					resultSBT = INT64(256);
					break;
				default:
					break;
			}
		}
		else if((SlotBitType == INT64(1073741824)))
		{
			switch(subSlot)
			{
				case 2:
					resultSBT = -9223372036854775808;
					break;
				case 3:
					resultSBT = INT64(1);
					break;
				case 4:
					resultSBT = INT64(2);
					break;
				case 5:
					resultSBT = INT64(4);
					break;
				case 6:
					resultSBT = INT64(8);
					break;
				default:
					break;
			}
		}
		else if((SlotBitType == INT64(4194304)))
		{
			switch(subSlot)
			{
				case 2:
					resultSBT = INT64(8388608);
					break;
				case 3:
					resultSBT = INT64(16777216);
					break;
				case 4:
					resultSBT = INT64(33554432);
					break;
				case 5:
					resultSBT = INT64(67108864);
					break;
				case 5:
					resultSBT = INT64(134217728);
					break;
				default:
					break;
			}
		}
	}
	return resultSBT;
}

function int GetVirtualItemPoint()
{
	return (_uiInfo.GetPoint - _uiInfo.usedPoint);
}

function ShowDialog(E_VI_DIALOG_TYPE dialogType)
{
	local string descText;

	_uiInfo.dialogType = dialogType;
	if((int(dialogType) == 1))
	{
		descText = htmlSetHtmlStart(((htmlAddText(GetSystemString(5285), "") $ "<br1>") $ htmlAddText(GetSystemString(5286), "", getColorHexString(GTColor().Red))));
		dialogAsset.SetDialogDescHtml(descText, 0, 0);
	}
	else if((int(dialogType) == 2))
	{
		descText = htmlSetHtmlStart(((htmlAddText(GetSystemString(5288), "") $ "<br1>") $ htmlAddText(GetSystemString(5286), "", getColorHexString(GTColor().Red))));
		dialogAsset.SetDialogDescHtml(descText, 0, 0);
	}
	else if((int(dialogType) == 3))
	{
		descText = GetSystemString(5290);
		dialogAsset.SetDialogDesc(descText);
	}
	dialogAsset.Show();
	dialogContainer.ShowWindow();
	return;
}

function CloseDialog()
{
	dialogContainer.HideWindow();
	dialogAsset.Hide();
	_uiInfo.dialogType = E_VI_DIALOG_NONE;
	return;
}

function bool CheckAndCloseDialog()
{
	if(dialogContainer.IsShowWindow())
	{
		CloseDialog();
		return true;
	}
	return false;
}

function OpenWindow()
{
	Me.ShowWindow();
	return;
}

function CloseWindow()
{
	Me.HideWindow();
	return;
}

function StartLeftTimeTimer()
{
	KillLeftTimeTimer();
	Me.SetTimer(1, 60000);
	return;
}

function KillLeftTimeTimer()
{
	Me.KillTimer(1);
	return;
}

function int GetMaxNumCanEnchant()
{
	local array<VirtualItemInfo> enchantList;

	if((_setInfo.newMainIndex == 0))
	{
		return 0;
	}
	GetVirtualItemInfo_Index(_setInfo.newMainIndex, enchantList);
	return enchantList.Length;
}

function SetScrollToTop()
{
	virtualItemRichList.SetSelectedIndex(0, true);
	virtualItemRichList.SetSelectedIndex(-1, false);
	return;
}

function SetEnchantStepperValue(int mainIndex, int SubIndex)
{
	local array<VirtualItemInfo> enchantList;
	local int prevPoint, nextPoint;
	local string prevPointStr, nextPointStr;

	GetVirtualItemInfo_Index(mainIndex, enchantList);
	if((enchantList.Length > SubIndex))
	{
		nextPoint = enchantList[SubIndex].nEnchantPoints;
		nextPointStr = ((GetSystemString(5300) $ ":") @ string(nextPoint));
	}
	if(((SubIndex > 1) && (enchantList.Length > (SubIndex - 1))))
	{
		prevPoint = enchantList[(SubIndex - 1)].nEnchantPoints;
		prevPointStr = ((GetSystemString(5301) $ ":") @ string(prevPoint));
	}
	if((mainIndex == 0))
	{
		SetEnchantStepperEnable(false);
		enchantTextBox.SetText("-");
	}
	else
	{
		SetEnchantStepperEnable(true);
		enchantTextBox.SetText(("+" $ string((SubIndex - 1))));
		if((SubIndex == 1))
		{
			enchantDownBtn.SetEnable(false);
			enchantResetBtn.SetEnable(false);
		}
		if((SubIndex == GetMaxNumCanEnchant()))
		{
			enchantUpBtn.SetEnable(false);
			enchantMaxBtn.SetEnable(false);
		}
	}
	enchantUpBtn.SetTooltipCustomType(MakeTooltipSimpleText(nextPointStr));
	enchantDownBtn.SetTooltipCustomType(MakeTooltipSimpleText(prevPointStr));
	return;
}

function SetEnchantStepperEnable(bool isEnable)
{
	enchantResetBtn.SetEnable(isEnable);
	enchantMaxBtn.SetEnable(isEnable);
	enchantUpBtn.SetEnable(isEnable);
	enchantDownBtn.SetEnable(isEnable);
	return;
}

function OnEnchantStepperCicked(bool isUp)
{
	if(isUp)
	{
		_setInfo.newSubIndex++;
	}
	else
	{
		_setInfo.newSubIndex--;
	}
	UpdateUISlotSetControls();
	return;
}

function OnEnchantStepperMaxClicked()
{
	local int maxEnchant, availableEnchant, slotUsedPoint, leftPoint;

	leftPoint = ((_uiInfo.GetPoint - _uiInfo.usedPoint) + GetVirtualSlot(_uiInfo.selectedSBT, _uiInfo.selectedSlot).slotInfo.point);
	maxEnchant = GetMaxNumCanEnchant();
	availableEnchant = 1;
	while((availableEnchant < maxEnchant))
	{
		Debug((((("max :" @ string(_setInfo.newMainIndex)) @ string(availableEnchant)) @ string(GetSlotUsePoint(_setInfo.newMainIndex, availableEnchant))) @ string(leftPoint)));
		if(((leftPoint - GetSlotUsePoint(_setInfo.newMainIndex, availableEnchant)) < 0))
		{
			if((availableEnchant > 1))
			{
				availableEnchant = (availableEnchant - 1);
			}
			break;
		}
		availableEnchant++;
	}
	SetNewSlotSubIndexSettingInfo(availableEnchant);
	UpdateUISlotSetControls();
	return;
}

function OnEnchantStepperResetClicked()
{
	SetNewSlotSubIndexSettingInfo(1);
	UpdateUISlotSetControls();
	return;
}

event OnNumberInputCountEdited(INT64 ItemCount)
{
	local int SubIndex;

	if((_setInfo.newMainIndex == 0))
	{
		SubIndex = int(ItemCount);
	}
	else
	{
		SubIndex = (int(ItemCount) + 1);
	}
	if((_setInfo.newSubIndex != SubIndex))
	{
		SetNewSlotSubIndexSettingInfo(SubIndex);
		UpdateUISlotSetControls();
	}
	return;
}

function OnDialogConfirm()
{
	if((int(_uiInfo.dialogType) == 1))
	{
		RequestVirtualItemAllReset();
	}
	else if((int(_uiInfo.dialogType) == 2))
	{
		RequestVirtualItemSlotReset();
	}
	else if((int(_uiInfo.dialogType) == 3))
	{
		RequestVirtualItemEquip();
	}
	CloseDialog();
	return;
}

function OnDialogCancel()
{
	CloseDialog();
	return;
}

function CheckListBtn(string btnName)
{
	local array<string> names;

	Split(btnName, "_", names);
	if((names[0] == "listCheckBtn"))
	{
		OnVirtualItemListClicked(int(names[1]));
	}
	return;
}

function OnVirtualItemListClicked(int mainIndex)
{
	Debug(("OnVirtualItemListClicked :" @ string(mainIndex)));
	SetNewSlotSettingInfo(mainIndex, 1);
	UpdateUISlotSetControls();
	return;
}

function OnSlotClicked(INT64 SBT, int SlotIndex)
{
	Debug((("OnSlotClicked :" @ string(SBT)) @ string(SlotIndex)));
	if(((_uiInfo.selectedSBT == SBT) && (_uiInfo.selectedSlot == SlotIndex)))
	{
		return;
	}
	_uiInfo.selectedSBT = SBT;
	if((SBT == INT64(4)))
	{
		SlotIndex = 2;
	}
	else if((SBT == INT64(2)))
	{
		SlotIndex = 1;
	}
	else if((SBT == INT64(32)))
	{
		SlotIndex = 2;
	}
	else if((SBT == INT64(16)))
	{
		SlotIndex = 1;
	}
	_uiInfo.selectedSlot = SlotIndex;
	UpdateUISlotControls();
	UpdateUISlotSetControls(true);
	SetScrollToTop();
	return;
}

function RequestVirtualItemEquip()
{
	local UIPacket._VirtualItemInfo vItemInfo;
	local VirtualItemInfo enchantInfo;

	enchantInfo = GetVirtualItemEnchantInfo(_setInfo.newMainIndex, _setInfo.newSubIndex);
	vItemInfo.nSlot = _uiInfo.selectedSlot;
	vItemInfo.nIndexMain = _setInfo.newMainIndex;
	vItemInfo.nIndexSub = _setInfo.newSubIndex;
	vItemInfo.nCostVISPoint = GetSlotUsePoint(_setInfo.newMainIndex, _setInfo.newSubIndex);
	vItemInfo.nEnchant = enchantInfo.nEnchant;
	vItemInfo.nItemClass = enchantInfo.nClassID;
	Rq_C_EX_VIRTUALITEM_SYSTEM(E_VI_UPDATE_TYPE_UPDATE, _setInfo.newMainIndex, _setInfo.newSubIndex, _uiInfo.selectedSlot, vItemInfo);
	return;
}

function RequestVirtualItemSlotReset()
{
	local UIPacket._VirtualItemInfo vItemInfo;
	local VirtualItemInfo enchantInfo;

	enchantInfo = GetVirtualItemEnchantInfo(_setInfo.oldMainIndex, _setInfo.oldSubIndex);
	vItemInfo.nSlot = _uiInfo.selectedSlot;
	vItemInfo.nIndexMain = _setInfo.oldMainIndex;
	vItemInfo.nIndexSub = _setInfo.oldSubIndex;
	vItemInfo.nCostVISPoint = GetSlotUsePoint(_setInfo.oldMainIndex, _setInfo.oldSubIndex);
	vItemInfo.nEnchant = enchantInfo.nEnchant;
	vItemInfo.nItemClass = enchantInfo.nClassID;
	Rq_C_EX_VIRTUALITEM_SYSTEM(E_VI_UPDATE_TYPE_RESET, _setInfo.oldMainIndex, _setInfo.oldSubIndex, _uiInfo.selectedSlot, vItemInfo);
	return;
}

function RequestVirtualItemAllReset()
{
	local UIPacket._VirtualItemInfo vItemInfo;
	local VirtualItemInfo enchantInfo;

	enchantInfo = GetVirtualItemEnchantInfo(_setInfo.oldMainIndex, _setInfo.oldSubIndex);
	vItemInfo.nSlot = _uiInfo.selectedSlot;
	vItemInfo.nIndexMain = _setInfo.oldMainIndex;
	vItemInfo.nIndexSub = _setInfo.oldSubIndex;
	vItemInfo.nCostVISPoint = GetSlotUsePoint(_setInfo.oldMainIndex, _setInfo.oldSubIndex);
	vItemInfo.nEnchant = enchantInfo.nEnchant;
	vItemInfo.nItemClass = enchantInfo.nClassID;
	Rq_C_EX_VIRTUALITEM_SYSTEM(E_VI_UPDATE_TYPE_RESET, 0, 0, _uiInfo.selectedSlot, vItemInfo);
	return;
}

function RequestVirtualItemOpen()
{
	local UIPacket._VirtualItemInfo vItemInfo;

	Rq_C_EX_VIRTUALITEM_SYSTEM(E_VI_UPDATE_TYPE_OPEN, 0, 0, 0, vItemInfo);
	return;
}

function Rq_C_EX_MULTI_SELL_LIST(int MultisellID)
{
	local array<byte> stream;
	local UIPacket._C_EX_MULTI_SELL_LIST packet;

	packet.nGroupID = MultisellID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_MULTI_SELL_LIST(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(624, stream);
	return;
}

function Rq_C_EX_VIRTUALITEM_SYSTEM(E_VI_UPDATE_TYPE UpdateType, int mainIndex, int SubIndex, int Slot, UIPacket._VirtualItemInfo vItemInfo)
{
	local array<byte> stream;
	local UIPacket._C_EX_VIRTUALITEM_SYSTEM packet;

	packet.cType = int(UpdateType);
	packet.nSelectIndexMain = mainIndex;
	packet.nSelectIndexSub = SubIndex;
	packet.nSelectSlot = Slot;
	packet.updateVisItemInfo = vItemInfo;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_VIRTUALITEM_SYSTEM(stream, packet))
	{
		return;
	}
	Debug((((("Rq_C_EX_VIRTUALITEM_SYSTEM :" @ string(UpdateType)) @ string(mainIndex)) @ string(SubIndex)) @ string(Slot)));
	Debug((((((("Rq_C_EX_VIRTUALITEM_SYSTEM updateVisItemInfo :" @ string(vItemInfo.nSlot)) @ string(vItemInfo.nIndexMain)) @ string(vItemInfo.nIndexSub)) @ string(vItemInfo.nCostVISPoint)) @ string(vItemInfo.nEnchant)) @ string(vItemInfo.nItemClass)));
	Class'Interface.UIPacket'.static.RequestUIPacket(875, stream);
	return;
}

function Nt_S_EX_VIRTUALITEM_SYSTEM_BASE_INFO()
{
	local UIPacket._S_EX_VIRTUALITEM_SYSTEM_BASE_INFO packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_VIRTUALITEM_SYSTEM_BASE_INFO(packet))
	{
		return;
	}
	Debug((((("Nt_S_EX_VIRTUALITEM_SYSTEM_BASE_INFO" @ string(packet.nEndTime)) @ string(packet.nTotalGetVISPoint)) @ string(packet.nTotalUsedVISPoint)) @ string(packet.nVISMaxPoint)));
	_uiInfo.isOpen = true;
	_uiInfo.RemainTime = packet.nEndTime;
	_uiInfo.GetPoint = packet.nTotalGetVISPoint;
	_uiInfo.usedPoint = packet.nTotalUsedVISPoint;
	_uiInfo.MaxPoint = packet.nVISMaxPoint;
	StartLeftTimeTimer();
	SideBarScript.SetWindowShowHideByIndex(28, true);
	UpdateUISlotControls();
	UpdateLeftTimerControls();
	return;
}

function Rs_S_EX_VIRTUALITEM_SYSTEM()
{
	local int i;
	local UIPacket._S_EX_VIRTUALITEM_SYSTEM packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_VIRTUALITEM_SYSTEM(packet))
	{
		return;
	}
	Debug(((((((((("Rs_S_EX_VIRTUALITEM_SYSTEM" @ string(packet.cResult)) @ string(packet.cType)) @ string(packet.lstVISItemInfoList.Length)) @ string(packet.nEndTime)) @ string(packet.nSelectIndexMain)) @ string(packet.nSelectIndexSub)) @ string(packet.nSelectSlot)) @ string(packet.nTotalGetVISPoint)) @ string(packet.nTotalUsedVISPoint)));
	i = 0;
	while((i < packet.lstVISItemInfoList.Length))
	{
		Debug((((((("lstVISItemInfoList" @ string(i)) @ ":") @ string(packet.lstVISItemInfoList[i].nIndexMain)) @ string(packet.lstVISItemInfoList[i].nIndexSub)) @ string(packet.lstVISItemInfoList[i].nSlot)) @ string(packet.lstVISItemInfoList[i].nCostVISPoint)));
		i++;
	}
	if((packet.cType == 4))
	{
		Me.HideWindow();
	}
	_uiInfo.RemainTime = packet.nEndTime;
	_uiInfo.GetPoint = packet.nTotalGetVISPoint;
	_uiInfo.usedPoint = packet.nTotalUsedVISPoint;
	_uiInfo.MaxPoint = packet.nVISMaxPoint;
	UpdateVirtualItemInfos(packet);
	UpdateUISlotControls();
	UpdateLeftTimerControls();
	UpdateUISlotSetControls(true);
	return;
}

function Nt_S_EX_VIRTUALITEM_SYSTEM_POINT_INFO()
{
	local UIPacket._S_EX_VIRTUALITEM_SYSTEM_POINT_INFO packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_VIRTUALITEM_SYSTEM_POINT_INFO(packet))
	{
		return;
	}
	_uiInfo.GetPoint = packet.nTotalGetVISPoint;
	_uiInfo.usedPoint = packet.nTotalUsedVISPoint;
	_uiInfo.MaxPoint = packet.nVISMaxPoint;
	maxPointTextBox.SetText(MakeCostString(string(_uiInfo.MaxPoint)));
	Debug((((("Nt_S_EX_VIRTUALITEM_SYSTEM_POINT_INFO" @ string(packet.nTotalGetVISPoint)) @ string(packet.nTotalUsedVISPoint)) @ string(packet.nDiffPoint)) @ string(packet.nVISMaxPoint)));
	return;
}

function Nt_UpdateUserEquipSlotInfo()
{
	local UserInfo User;
	local int decoNum, agathionNum, jewelNum;

	if(Me.IsShowWindow())
	{
		GetPlayerInfo(User);
		decoNum = User.nTalismanNum;
		agathionNum = (User.nAgathionMainNum + User.nAgathionSubNum);
		jewelNum = User.nJewelNum;
		if((((_uiInfo.decoNum != decoNum) || (_uiInfo.agathionNum != agathionNum)) || (_uiInfo.jewelNum != jewelNum)))
		{
			RequestVirtualItemOpen();
		}
	}
	return;
}

event OnTimer(int TimerID)
{
	if((TimerID == 1))
	{
		_uiInfo.RemainTime = (_uiInfo.RemainTime - 60);
		if((_uiInfo.RemainTime < 0))
		{
			_uiInfo.RemainTime = 0;
			KillLeftTimeTimer();
		}
		UpdateLeftTimerControls();
	}
	return;
}

event OnClickButton(string buttonStr)
{
	switch(buttonStr)
	{
		case "WindowHelp_BTN":
			Class'Interface.HelpWnd'.static.ShowHelp(50000);
			break;
		case "VirtualEquip_RefreshBtn":
			RequestVirtualItemOpen();
			break;
		case "All_ResetBtn":
			ShowDialog(E_VI_DIALOG_ALL_RESET);
			break;
		case "SlotResetBtn":
			ShowDialog(E_VI_DIALOG_SLOT_RESET);
			break;
		case "ApplyBtn":
			ShowDialog(E_VI_DIALOG_APPLY);
			break;
		case "CancleBtn":
			UndoSlotSettingInfo();
			UpdateUISlotSetControls();
			break;
		case "Enchant_Up_Button":
			OnEnchantStepperCicked(true);
			break;
		case "Enchant_Down_Button":
			OnEnchantStepperCicked(false);
			break;
		case "Enchant_Max_Button":
			OnEnchantStepperMaxClicked();
			break;
		case "Enchant_Reset_Btn":
			OnEnchantStepperResetClicked();
			break;
		case "PointShopBtn":
			Rq_C_EX_MULTI_SELL_LIST(3222);
			CloseWindow();
			break;
		default:
			CheckListBtn(buttonStr);
			break;
	}
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(181);
	RegisterEvent(EV_PacketID(1139));
	RegisterEvent(EV_PacketID(1140));
	RegisterEvent(EV_PacketID(1141));
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
	CloseDialog();
	SideBarScript.ToggleByWindowName("VirtualItemWnd", true);
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	RequestVirtualItemOpen();
	return;
}

event OnHide()
{
	SideBarScript.ToggleByWindowName("VirtualItemWnd", false);
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case 40:
			break;
		case 181:
			Nt_UpdateUserEquipSlotInfo();
			break;
		case EV_PacketID(1139):
			Nt_S_EX_VIRTUALITEM_SYSTEM_BASE_INFO();
			break;
		case EV_PacketID(1140):
			Rs_S_EX_VIRTUALITEM_SYSTEM();
			break;
		case EV_PacketID(1141):
			Nt_S_EX_VIRTUALITEM_SYSTEM_POINT_INFO();
			break;
		default:
			break;
	}
	return;
}

event OnReceivedCloseUI()
{
	if((CheckAndCloseDialog() == false))
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		Me.HideWindow();
	}
	return;
}
