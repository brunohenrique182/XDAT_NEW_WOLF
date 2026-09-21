class HennaDyeEnchantWnd extends UICommonAPI
	dependson(UIPacket);

const Henna_CLASSIC_MAX = 4;
const STATE_BEGIN = 'begin';
const STATE_SELECT = 'select';
const STATE_PROGRESS = 'progress';
const STATE_RESULTSUCCESS = 'resultSuccess';
const STATE_RESULTFAIL = 'resultFail';

var EffectViewportWndHandle Result_EffectViewport;
var AnimTextureHandle ResultSlotani_Tex;
var TextBoxHandle InstructionTxt;
var ButtonHandle EnchantBtn;
var ButtonHandle AutoEnchantBtn;
var ItemWindowHandle EnchantJewel1;
var ProgressCtrlHandle EnchantProgress;
var TextureHandle Empty_Tex;
var array<UIControlGroupButtonHighlighting> highlightings;
var UIControlNeedItemList needItemListNormalScr;
var int Selected;
var int ENCHANTING_TIME;
var int ENCHANTINGAUTO_TIME;
var bool bIsAutoEnchant;
var L2UITimerObject timeObjectEnchantDelay;
var L2UITimerObject timeObjectInventoryDelay;
var UIControlNeedItemSelectMultiItems UIControlNeedItemSelectMultiItem;
var int selectProb;
var array<DyeCombinationUIData> beforeNeedItemDataArray;
var bool bPressCancelAutoEnchant;
var bool bApiSending;
var array<UIPacket._HennaComposeProbInfo> hennaComposeProbInfoList;

static function HennaDyeEnchantWnd Inst()
{
	return HennaDyeEnchantWnd(GetScript("HennaDyeEnchantWnd"));
}

function Initialize()
{
	Result_EffectViewport = GetEffectViewportWndHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_EffectViewport"));
	ResultSlotani_Tex = GetAnimTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ResultSlotani_Tex"));
	InstructionTxt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".InstructionTxt"));
	EnchantBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantBtn"));
	AutoEnchantBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AutoEnchantBtn"));
	EnchantJewel1 = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantJewel1"));
	Empty_Tex = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItemWnd.Empty_Tex"));
	EnchantProgress = GetProgressCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantProgress"));
	InitHennaGrouBtns();
	InitNeedItemList();
	Selected = -1;
	ENCHANTING_TIME = 700;
	ENCHANTINGAUTO_TIME = 500;
	timeObjectInventoryDelay = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(1, 1);
	timeObjectInventoryDelay._DelegateOnTime = OnTimeDelayInventory;
	timeObjectEnchantDelay = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(ENCHANTING_TIME, 1);
	timeObjectEnchantDelay._DelegateOnTime = OnTimeEnchatDelay;
	UIControlNeedItemSelectMultiItem = Class'InterfaceClassic.UIControlNeedItemSelectMultiItems'.static._InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItemWnd.UIControlNeedItemSelectMultiItem")));
	UIControlNeedItemSelectMultiItem = UIControlNeedItemSelectMultiItems(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItemWnd.UIControlNeedItemSelectMultiItem")).GetScript());
	UIControlNeedItemSelectMultiItem._ConnectPopup(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".UIControlNeedItemSelectMultiItemPopupWithDesc")), true, 150);
	UIControlNeedItemSelectMultiItem.DelegateSelectedItemOnClick = delegateItemSelectOnClick;
	UIControlNeedItemSelectMultiItem.DelegateOnUpdateItem = HandleOnUpdateItemNormal;
	return;
}

function delegateItemSelectOnClick(int SelectedIndex, int selectedClassID, INT64 selectedAmount)
{
	local int i;
	local array<DyeCombinationUIData> o_DataArray;
	local ItemInfo iInfo;
	local int HennaID;

	if(!GetItemInfoAtIndex(Selected, iInfo))
	{
		return;
	}
	HennaID = iInfo.Id.ClassID;
	if(!GetCombinationDataList(iInfo.Id.ClassID, o_DataArray))
	{
		return;
	}
	selectProb = 0;
	needItemListNormalScr.CleariObjects();
	i = 0;
	while((i < o_DataArray.Length))
	{
		if((selectedClassID == o_DataArray[i].SlotTwoItemID))
		{
			needItemListNormalScr.AddNeedItemClassID(57, INT64(o_DataArray[i].Commission));
			needItemListNormalScr.SetBuyNum(INT64(1));
			selectProb = getProb(HennaID, selectedClassID);
			break;
		}
		i++;
	}
	SetSelectedProb();
	return;
}

function OnTimeDelayInventory(int Count)
{
	GotoState('resultFail');
	return;
}

function OnTimeEnchatDelay(int Count)
{
	GotoState('Progress');
	return;
}

function InitHennaGrouBtns()
{
	local int i;
	local UIControlGroupButtonHighlighting scr;

	i = 1;
	while((i <= 4))
	{
		scr = Class'InterfaceClassic.UIControlGroupButtonHighlighting'.static.InitScript(GetDyeSlot(i));
		scr._SetBtnTexture("L2UI_CT1.Button.emptyBtn", "L2UI_NewTex.Button.Slot_Over", "L2UI_NewTex.Button.Slot_Down");
		scr._AddWindow(GetSlotItemWindow(i));
		scr.DelegateOnLButtonUp = HandleDelegateOnLButtonUp;
		highlightings[i] = scr;
		i++;
	}
	return;
}

function InitNeedItemList()
{
	needItemListNormalScr = Class'InterfaceClassic.UIControlNeedItemList'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItemWnd")), 2);
	needItemListNormalScr.DelegateOnUpdateItem = HandleOnUpdateItemNormal;
	return;
}

event OnRegisterEvent()
{
	RegisterEvent((100000 + 987));
	RegisterEvent((100000 + 982));
	RegisterEvent((100000 + 1173));
	RegisterEvent(3410);
	RegisterEvent(17);
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case (100000 + 987):
			Handle_S_EX_NEW_HENNA_COMPOSE();
			break;
		case (100000 + 982):
			Handle_S_EX_NEW_HENNA_LIST();
			break;
		case (100000 + 1173):
			Handle_S_EX_NEW_HENNA_COMPOSE_PROB_LIST();
			break;
		case 3410:
			if((param != "GAMINGSTATE"))
			{
				m_hOwnerWnd.HideWindow();
			}
			break;
		case 17:
			if(!GetWindowHandle("HennaDyeEnchantWnd").IsShowWindow())
			{
				return;
			}
			ParseInt(param, "msec", ENCHANTING_TIME);
			if((timeObjectEnchantDelay._time <= 10))
			{
				ENCHANTING_TIME = 10;
				ENCHANTINGAUTO_TIME = 10;
			}
			else
			{
				ENCHANTINGAUTO_TIME = ENCHANTING_TIME;
			}
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
		case "AutoEnchantBtn":
			OnAutoEnchantBtnClick();
			break;
		case "EnchantBtn":
			OnEnchantBtnClick();
			break;
		case "OpenBtn":
			Class'InterfaceClassic.ItemJewelEnchantWnd'.static.Inst().ToggleShowWindow(dye);
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	GotoState('Begin');
	return;
}

event OnHide()
{
	GotoState('Select');
	ShowMennaMenuWnd();
	timeObjectInventoryDelay._Stop();
	timeObjectEnchantDelay._Stop();
	beforeNeedItemDataArray.Length = 0;
	bPressCancelAutoEnchant = false;
	bApiSending = false;
	return;
}

function ShowMennaMenuWnd()
{
	local Rect rectWnd;

	if(!GetWindowHandle("ItemJewelEnchantWnd").IsShowWindow())
	{
		rectWnd = GetWindowHandle("HennaMenuWnd").GetRect();
		getInstanceL2Util().syncWindowLoc(m_hOwnerWnd.m_WindowNameWithFullPath, "HennaMenuWnd", ((m_hOwnerWnd.GetRect().nWidth - rectWnd.nWidth) / 2), ((m_hOwnerWnd.GetRect().nHeight - rectWnd.nHeight) / 2));
		GetWindowHandle("HennaMenuWnd").ShowWindow();
		GetWindowHandle("HennaMenuWnd").SetFocus();
	}
	return;
}

event OnProgressTimeUp(string strID)
{
	switch(strID)
	{
		case "EnchantProgress":
			API_C_EX_NEW_HENNA_COMPOSE();
			break;
		default:
			break;
	}
	return;
}

function SetUnSelect(int Index)
{
	EnchantJewel1.Clear();
	if((Index > 0))
	{
		GetSlotSlectTex(Index).HideWindow();
	}
	ResultSlotani_Tex.Stop();
	ResultSlotani_Tex.HideWindow();
	EnchantBtn.DisableWindow();
	AutoEnchantBtn.DisableWindow();
	Selected = -1;
	InstructionTxt.SetTextColor(GetColor(187, 187, 187, 255));
	InstructionTxt.SetText(GetSystemString(13827));
	needItemListNormalScr.CleariObjects();
	UIControlNeedItemSelectMultiItem._Clear(true);
	Empty_Tex.ShowWindow();
	beforeNeedItemDataArray.Length = 0;
	return;
}

function SetSelect(int Index)
{
	local ItemInfo iInfo;

	if(!GetItemInfoAtIndex(Index, iInfo))
	{
		return;
	}
	Selected = Index;
	if((Index > 0))
	{
		GetSlotSlectTex(Index).ShowWindow();
	}
	SetSelectedEnchantInfo(true);
	SetSelectedProb();
	PlayAnimationItemChanged();
	return;
}

function SetSelectedEnchantInfo(optional bool bSaveNeedItem)
{
	local ItemInfo iInfo;
	local array<DyeCombinationUIData> o_DataArray;
	local int i;
	local bool bNeedItemUpdate;
	local int HennaID;

	if(!GetItemInfoAtIndex(Selected, iInfo))
	{
		return;
	}
	HennaID = iInfo.Id.ClassID;
	EnchantJewel1.Clear();
	EnchantJewel1.AddItem(iInfo);
	EnchantJewel1.UpdatePointedNum();
	if(!GetCombinationDataList(iInfo.Id.ClassID, o_DataArray))
	{
		return;
	}
	if((o_DataArray.Length == beforeNeedItemDataArray.Length))
	{
		i = 0;
		while((i < beforeNeedItemDataArray.Length))
		{
			if((((beforeNeedItemDataArray[i].SlotTwoItemID == o_DataArray[i].SlotTwoItemID) && (beforeNeedItemDataArray[i].Prob == float(getProb(HennaID, o_DataArray[i].SlotTwoItemID)))) && (beforeNeedItemDataArray[i].Commission == o_DataArray[i].Commission)))
			{
				i++;
				continue;
			}
			bNeedItemUpdate = true;
			i++;
		}
	}
	else
	{
		bNeedItemUpdate = true;
	}
	if((beforeNeedItemDataArray.Length == 0))
	{
		bNeedItemUpdate = true;
	}
	if((bNeedItemUpdate == false))
	{
		return;
	}
	UIControlNeedItemSelectMultiItem._StartSelectItems(o_DataArray.Length);
	i = 0;
	while((i < o_DataArray.Length))
	{
		Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(o_DataArray[i].SlotTwoItemID), iInfo);
		UIControlNeedItemSelectMultiItem._AddSelectItemClassID(iInfo.Id.ClassID, INT64(1), ((GetSystemString(642) @ ":") @ getInstanceL2Util().MakeDecimalPointString(string(getProb(HennaID, o_DataArray[i].SlotTwoItemID)), 2, true, true)));
		i++;
	}
	UIControlNeedItemSelectMultiItem._EndSelectItems();
	needItemListNormalScr.CleariObjects();
	if((o_DataArray.Length == 1))
	{
		needItemListNormalScr.AddNeedItemClassID(57, INT64(o_DataArray[0].Commission));
		needItemListNormalScr.SetBuyNum(INT64(1));
		selectProb = getProb(HennaID, o_DataArray[0].SlotTwoItemID);
	}
	else
	{
		timeObjectInventoryDelay._Stop();
		timeObjectEnchantDelay._Stop();
		bIsAutoEnchant = false;
		GotoState('Select');
	}
	Empty_Tex.HideWindow();
	if(bSaveNeedItem)
	{
		i = 0;
		while((i < o_DataArray.Length))
		{
			o_DataArray[i].Prob = float(getProb(HennaID, o_DataArray[i].SlotTwoItemID));
			i++;
		}
		beforeNeedItemDataArray.Length = 0;
		beforeNeedItemDataArray = o_DataArray;
	}
	return;
}

function SetSelectedProb()
{
	local ItemInfo iInfo;
	local int HennaID;
	local array<DyeCombinationUIData> o_DataArray;

	if(!GetItemInfoAtIndex(Selected, iInfo))
	{
		InstructionTxt.SetTextColor(GetColor(187, 187, 187, 255));
		InstructionTxt.SetText(GetSystemString(13827));
		return;
	}
	HennaID = iInfo.Id.ClassID;
	if(!CheckSelectedHennaLevel())
	{
		InstructionTxt.SetTextColor(GetColor(187, 187, 187, 255));
		InstructionTxt.SetText(GetSystemString(13908));
		UIControlNeedItemSelectMultiItem._Clear(true);
		needItemListNormalScr.CleariObjects();
		Empty_Tex.ShowWindow();
	}
	else if(GetCombinationDataList(HennaID, o_DataArray))
	{
		InstructionTxt.SetText(((GetSystemString(642) @ ":") @ getInstanceL2Util().MakeDecimalPointString(string(selectProb), 2, true, true)));
		InstructionTxt.SetTextColor(GetColor(255, 172, 0, 255));
	}
	else
	{
		InstructionTxt.SetTextColor(Class'InterfaceClassic.L2Util'.static.Inst().Red2);
		InstructionTxt.SetText(GetSystemString(13912));
		UIControlNeedItemSelectMultiItem._Clear(true);
		needItemListNormalScr.CleariObjects();
		Empty_Tex.ShowWindow();
	}
	return;
}

function bool CheckSelectedHennaLevel()
{
	local ItemInfo iInfo;
	local int HennaID;
	local array<DyeCombinationUIData> o_DataArray;

	if(!GetItemInfoAtIndex(Selected, iInfo))
	{
		return false;
	}
	HennaID = iInfo.Id.ClassID;
	GetCombinationDataList(HennaID, o_DataArray);
	if((o_DataArray.Length == 0))
	{
		return false;
	}
	return true;
}

function bool GetCombinationDataList(int HennaID, out array<DyeCombinationUIData> o_DataArray)
{
	local int hennaItemClassID;

	Class'NWindow.UIDATA_HENNA'.static.GetHennaDyeItemClassID(HennaID, hennaItemClassID);
	return Class'NWindow.UIDATA_HENNA'.static.GetDyeCombinationDataList(hennaItemClassID, o_DataArray);
}

function PlayAnimationItemChanged()
{
	ResultSlotani_Tex.ShowWindow();
	ResultSlotani_Tex.SetLoopCount(1);
	ResultSlotani_Tex.Play();
	return;
}

function Handle_S_EX_NEW_HENNA_COMPOSE()
{
	local UIPacket._S_EX_NEW_HENNA_COMPOSE composeResultPacket;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_NEW_HENNA_COMPOSE(composeResultPacket))
	{
		return;
	}
	bApiSending = false;
	Debug((("Handle_S_EX_NEW_HENNA_COMPOSE" @ string(composeResultPacket.nResultHennaID)) @ string(composeResultPacket.nResultItemID)));
	if((composeResultPacket.nResultHennaID < 0))
	{
		Debug(("error: composeResultPacket.nResultHennaID:" @ string(composeResultPacket.nResultHennaID)));
		return;
	}
	if((composeResultPacket.nResultItemID != -1))
	{
		Debug(("error: composeResultPacket.nResultHennaID != -1:" @ string(composeResultPacket.nResultHennaID)));
		return;
	}
	if((composeResultPacket.cSuccess == 1))
	{
		GotoState('resultSuccess');
	}
	else if((composeResultPacket.cSuccess == 0))
	{
		Debug(("compose bIsAutoEnchant" @ string(bIsAutoEnchant)));
		if(bIsAutoEnchant)
		{
			timeObjectInventoryDelay._Stop();
			timeObjectInventoryDelay._Play();
		}
		else
		{
			GotoState('resultFail');
		}
	}
	HennaMenuWnd(GetScript("HennaMenuWnd")).API_C_EX_NEW_HENNA_LIST();
	return;
}

function Handle_S_EX_NEW_HENNA_COMPOSE_PROB_LIST()
{
	local UIPacket._S_EX_NEW_HENNA_COMPOSE_PROB_LIST packet;
	local int i, N;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_NEW_HENNA_COMPOSE_PROB_LIST(packet))
	{
		return;
	}
	hennaComposeProbInfoList = packet.vHennaComposeProbInfoList;
	Debug("S_EX_NEW_HENNA_COMPOSE_PROB_LIST");
	i = 0;
	while((i < hennaComposeProbInfoList.Length))
	{
		Debug(("nHennaID: " @ string(hennaComposeProbInfoList[i].nHennaID)));
		N = 0;
		while((N < hennaComposeProbInfoList[i].vProbInfoList.Length))
		{
			Debug(("vProbInfoList nItemClassID" @ string(hennaComposeProbInfoList[i].vProbInfoList[N].nItemClassID)));
			Debug(("vProbInfoList nProb" @ string(hennaComposeProbInfoList[i].vProbInfoList[N].nProb)));
			N++;
		}
		i++;
	}
	SetSelectedEnchantInfo(true);
	GotoState('Select');
	return;
}

function int getProb(int nHennaID, int needItemClassID)
{
	local int i, N;

	i = 0;
	while((i < hennaComposeProbInfoList.Length))
	{
		if((nHennaID == hennaComposeProbInfoList[i].nHennaID))
		{
			N = 0;
			while((N < hennaComposeProbInfoList[i].vProbInfoList.Length))
			{
				if((needItemClassID == hennaComposeProbInfoList[i].vProbInfoList[N].nItemClassID))
				{
					return hennaComposeProbInfoList[i].vProbInfoList[N].nProb;
				}
				N++;
			}
		}
		i++;
	}
	return 0;
}

function string GetHennaPotenString(int potenID, int activeStep)
{
	local DyePotentialUIData dyePotentialData;
	local SkillInfo SkillInfo;

	Class'NWindow.UIDATA_HENNA'.static.GetDyePotentialData(potenID, dyePotentialData);
	GetSkillInfo(dyePotentialData.SkillID, activeStep, 0, SkillInfo);
	return ((dyePotentialData.EffectName @ SkillInfo.SkillDesc) @ GetSystemString(3351));
}

function Handle_S_EX_NEW_HENNA_LIST()
{
	local int i, HennaID, hennaLevel;
	local UIPacket._S_EX_NEW_HENNA_LIST henna_list_packet;
	local ItemInfo iInfo;
	local string Desc;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_NEW_HENNA_LIST(henna_list_packet))
	{
		return;
	}
	i = 1;
	while((i <= 4))
	{
		GetSlotItemWindow(i).Clear();
		i++;
	}
	i = 0;
	while((i < henna_list_packet.hennaInfoList.Length))
	{
		HennaID = henna_list_packet.hennaInfoList[i].nHennaID;
		if(!Class'NWindow.UIDATA_HENNA'.static.GetItemCheck(HennaID))
		{
			i++;
			continue;
		}
		Class'NWindow.UIDATA_HENNA'.static.GetHennaDyeItemLevel(HennaID, hennaLevel);
		Desc = Substitute(Class'NWindow.UIDATA_HENNA'.static.GetDescriptionS(HennaID), "\\n", ", ", false);
		iInfo.Name = (Class'NWindow.UIDATA_HENNA'.static.GetItemNameS(HennaID) @ Desc);
		iInfo.AdditionalName = MakeFullSystemMsg(GetSystemMessage(5203), string(hennaLevel));
		iInfo.Id.ClassID = HennaID;
		if((henna_list_packet.hennaInfoList[i].nActiveStep > 0))
		{
			iInfo.Description = "";
		}
		else
		{
			iInfo.Description = "";
		}
		iInfo.IconName = Class'NWindow.UIDATA_HENNA'.static.GetIconTexS(HennaID);
		GetSlotItemWindow((i + 1)).AddItem(iInfo);
		GetSlotItemWindow((i + 1)).UpdatePointedNum();
		i++;
	}
	if(((Selected > -1) && (GetStateName() != 'resultSuccess')))
	{
		SetSelectedEnchantInfo(true);
	}
	if(!GetItemInfoAtIndex(Selected, iInfo))
	{
		return;
	}
	EnchantJewel1.Clear();
	EnchantJewel1.AddItem(iInfo);
	EnchantJewel1.UpdatePointedNum();
	HandleOnUpdateItemNormal();
	return;
}

function OnAutoEnchantBtnClick()
{
	switch(GetStateName())
	{
		case 'Progress':
			bPressCancelAutoEnchant = true;
			if(!bApiSending)
			{
				GotoState('Select');
			}
			break;
		case 'Select':
			bIsAutoEnchant = true;
			EnchantProgress.SetProgressTime(ENCHANTINGAUTO_TIME);
			timeObjectEnchantDelay._time = ENCHANTINGAUTO_TIME;
			GotoState('Progress');
			break;
		case 'resultSuccess':
			bPressCancelAutoEnchant = true;
			if(!bApiSending)
			{
				API_C_EX_NEW_HENNA_COMPOSE_PROB_LIST();
			}
			break;
		case 'resultFail':
			bPressCancelAutoEnchant = true;
			SetSelectedEnchantInfo(true);
			if(!bApiSending)
			{
				GotoState('Select');
			}
			break;
		default:
			break;
	}
	return;
}

function OnEnchantBtnClick()
{
	switch(GetStateName())
	{
		case 'Begin':
			GotoState('Select');
			break;
		case 'Select':
			EnchantProgress.SetProgressTime(ENCHANTING_TIME);
			timeObjectEnchantDelay._time = ENCHANTING_TIME;
			GotoState('Progress');
			break;
		case 'Progress':
			GotoState('Select');
			break;
		case 'resultSuccess':
			API_C_EX_NEW_HENNA_COMPOSE_PROB_LIST();
			break;
		case 'resultFail':
			SetSelectedEnchantInfo(true);
			GotoState('Select');
			break;
		default:
			break;
	}
	return;
}

function HandleDelegateOnLButtonUp(WindowHandle wnd, int X, int Y)
{
	if((GetStateName() != 'Select'))
	{
		return;
	}
	SetUnSelect(Selected);
	SetSelect(GetIndex(wnd));
	return;
}

function HandleOnUpdateItemNormal()
{
	if((GetStateName() != 'Select'))
	{
		return;
	}
	if(!GetWindowHandle("HennaDyeEnchantWnd").IsShowWindow())
	{
		return;
	}
	if((((needItemListNormalScr.GetCanBuy() && UIControlNeedItemSelectMultiItem._GetCanBuy()) && (Selected > -1)) && CheckSelectedHennaLevel()))
	{
		EnchantBtn.EnableWindow();
		AutoEnchantBtn.EnableWindow();
	}
	else
	{
		EnchantBtn.DisableWindow();
		AutoEnchantBtn.DisableWindow();
	}
	return;
}

function API_C_EX_NEW_HENNA_COMPOSE()
{
	local int ClassID;
	local array<ItemInfo> iInfos;
	local array<byte> stream;
	local UIPacket._C_EX_NEW_HENNA_COMPOSE packet;

	if(!GetWindowHandle("HennaDyeEnchantWnd").IsShowWindow())
	{
		return;
	}
	ClassID = UIControlNeedItemSelectMultiItem._GetMyClassID();
	if((ClassID <= 0))
	{
		return;
	}
	Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(ClassID, iInfos);
	packet.nSlotOneIndex = Selected;
	packet.nSlotOneItemID = -1;
	packet.nSlotTwoItemID = iInfos[0].Id.ServerID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_NEW_HENNA_COMPOSE(stream, packet))
	{
		return;
	}
	Debug(((("C_EX_NEW_HENNA_COMPOSE" @ string(packet.nSlotOneIndex)) @ string(packet.nSlotOneItemID)) @ string(packet.nSlotTwoItemID)));
	bApiSending = true;
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(751, stream);
	return;
}

function API_C_EX_NEW_HENNA_COMPOSE_PROB_LIST()
{
	local array<byte> stream;

	if(!GetWindowHandle("HennaDyeEnchantWnd").IsShowWindow())
	{
		return;
	}
	Debug("C_EX_NEW_HENNA_COMPOSE_PROB_LIST");
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(897, stream);
	return;
}

function bool GetItemInfoAtIndex(int Index, out ItemInfo iInfo)
{
	local ItemWindowHandle iWnd;

	iWnd = GetSlotItemWindow(Index);
	if((iWnd.m_pTargetWnd == none))
	{
		return false;
	}
	return iWnd.GetItem(0, iInfo);
}

function int GetIndex(WindowHandle wnd)
{
	local int i;

	i = 1;
	while((i <= 4))
	{
		Debug(((("GetIndex" $ string(i)) @ wnd.GetParentWindowName()) @ GetDyeSlot(i).GetWindowName()));
		if((wnd.GetParentWindowName() == GetDyeSlot(i).GetWindowName()))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function DisableDyeSlots()
{
	local int i;

	i = 1;
	while((i <= 4))
	{
		GetDyeSlot(i).DisableWindow();
		highlightings[i]._SetDisable();
		i++;
	}
	return;
}

function EnableDyeSlots()
{
	local int i;

	i = 1;
	while((i <= 4))
	{
		GetDyeSlot(i).EnableWindow();
		highlightings[i]._SetEnable();
		i++;
	}
	return;
}

function WindowHandle GetDyeSlot(int Index)
{
	return GetWindowHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DyeSlotWnd0") $ string(Index)) $ "_wnd"));
}

function WindowHandle GetSlotSlectTex(int Index)
{
	return GetWindowHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DyeSlotWnd0") $ string(Index)) $ "_wnd.SlotSelect_tex"));
}

function ItemWindowHandle GetSlotItemWindow(int Index)
{
	return GetItemWindowHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DyeSlotWnd0") $ string(Index)) $ "_wnd.Henna_ItemWnd"));
}

function OnReceivedCloseUI()
{
	if(bIsAutoEnchant)
	{
		bPressCancelAutoEnchant = true;
		if(!bApiSending)
		{
			GotoState('Select');
		}
	}
	else
	{
		switch(GetStateName())
		{
			case 'Progress':
				GotoState('Select');
				break;
			default:
				PlayConsoleSound(IFST_WINDOW_CLOSE);
				m_hOwnerWnd.HideWindow();
				break;
		}
	}
	return;
}

auto state Begin
{
	function BeginState()
	{
		local int i;

		Class'InterfaceClassic.L2Util'.static.Inst().ItemRelationWindowHide(m_hOwnerWnd.m_WindowNameWithFullPath);
		m_hOwnerWnd.SetFocus();
		Result_EffectViewport.SpawnEffect("");
		InstructionTxt.SetText("");
		EnchantBtn.DisableWindow();
		Empty_Tex.ShowWindow();
		i = 1;
		while((i <= 4))
		{
			SetUnSelect(i);
			i++;
		}
		timeObjectInventoryDelay._Stop();
		timeObjectEnchantDelay._Stop();
		bIsAutoEnchant = false;
		AutoEnchantBtn.SetButtonName(14237);
		API_C_EX_NEW_HENNA_COMPOSE_PROB_LIST();
		return;
	}

	function EndState()
	{
		EnchantBtn.DisableWindow();
		return;
	}
}

state Select
{
	function BeginState()
	{
		EnchantBtn.SetButtonName(2066);
		AutoEnchantBtn.SetButtonName(14613);
		EnchantProgress.SetPos(0);
		EnchantProgress.Reset();
		InstructionTxt.SetText(GetSystemString(13827));
		timeObjectInventoryDelay._Stop();
		timeObjectEnchantDelay._Stop();
		bIsAutoEnchant = false;
		bPressCancelAutoEnchant = false;
		EnableDyeSlots();
		SetSelectedProb();
		HandleOnUpdateItemNormal();
		UIControlNeedItemSelectMultiItem._DisableNeedItemSelectArrow_btn(false);
		return;
	}

	function EndState()
	{
		InstructionTxt.SetTextColor(GetColor(187, 187, 187, 255));
		DisableDyeSlots();
		GetDyeSlot(Selected).EnableWindow();
		return;
	}
}

state Progress
{
	function BeginState()
	{
		PlaySound("ItemSound3.enchant_process");
		UIControlNeedItemSelectMultiItem._DisableNeedItemSelectArrow_btn(true);
		UIControlNeedItemSelectMultiItem._OpenPopup(false);
		if(bIsAutoEnchant)
		{
			AutoEnchantBtn.SetButtonName(1342);
			EnchantBtn.DisableWindow();
		}
		else
		{
			EnchantBtn.SetButtonName(1342);
			AutoEnchantBtn.DisableWindow();
		}
		EnchantProgress.SetPos(0);
		EnchantProgress.Reset();
		EnchantProgress.Start();
		InstructionTxt.SetText(GetSystemString(13893));
		Result_EffectViewport.SpawnEffect("LineageEffect2.ui_spirit_extract");
		return;
	}

	function EndState()
	{
		EnchantProgress.Stop();
		Result_EffectViewport.SpawnEffect("");
		return;
	}
}

state resultSuccess
{
	function BeginState()
	{
		Result_EffectViewport.SpawnEffect("LineageEffect2.ui_upgrade_succ");
		InstructionTxt.SetText(GetSystemString(13894));
		PlaySound("ItemSound3.enchant_success");
		PlayAnimationItemChanged();
		UIControlNeedItemSelectMultiItem._DisableNeedItemSelectArrow_btn(true);
		if(bIsAutoEnchant)
		{
			timeObjectInventoryDelay._Stop();
			timeObjectEnchantDelay._Stop();
			bIsAutoEnchant = false;
			AutoEnchantBtn.SetButtonName(1337);
			AutoEnchantBtn.EnableWindow();
		}
		else
		{
			EnchantBtn.SetButtonName(1337);
			EnchantBtn.EnableWindow();
			AutoEnchantBtn.DisableWindow();
		}
		if(bPressCancelAutoEnchant)
		{
			API_C_EX_NEW_HENNA_COMPOSE_PROB_LIST();
		}
		return;
	}

	function EndState()
	{
		return;
	}
}

state resultFail
{
	function BeginState()
	{
		Result_EffectViewport.SpawnEffect("LineageEffect2.ui_upgrade_fail");
		InstructionTxt.SetText(GetSystemString(13895));
		PlaySound("ItemSound3.enchant_fail");
		UIControlNeedItemSelectMultiItem._DisableNeedItemSelectArrow_btn(true);
		timeObjectInventoryDelay._Stop();
		timeObjectEnchantDelay._Stop();
		if(bIsAutoEnchant)
		{
			if((((needItemListNormalScr.GetCanBuy() && UIControlNeedItemSelectMultiItem._GetCanBuy()) && (Selected > -1)) && CheckSelectedHennaLevel()))
			{
				timeObjectEnchantDelay._Play();
			}
			else
			{
				bIsAutoEnchant = false;
				AutoEnchantBtn.SetButtonName(1337);
				AutoEnchantBtn.EnableWindow();
			}
		}
		else
		{
			EnchantBtn.SetButtonName(1337);
			EnchantBtn.EnableWindow();
			AutoEnchantBtn.DisableWindow();
		}
		if(bPressCancelAutoEnchant)
		{
			GotoState('Select');
		}
		return;
	}

	function EndState()
	{
		return;
	}
}
