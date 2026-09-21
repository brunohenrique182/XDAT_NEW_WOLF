class InventoryWnd extends UICommonAPI
	dependson(UIPacket);

const DIALOG_USE_RECIPE = 1111;
const DIALOG_POPUP = 2222;
const DIALOG_DROPITEM = 3333;
const DIALOG_DROPITEM_ASKCOUNT = 4444;
const DIALOG_DROPITEM_ALL = 5555;
const DIALOG_DESTROYITEM = 6666;
const DIALOG_DESTROYITEM_ALL = 7777;
const DIALOG_DESTROYITEM_ASKCOUNT = 8888;
const DIALOG_CRYSTALLIZE = 9999;
const DIALOG_NOTCRYSTALLIZE = 9998;
const DIALOG_DROPITEM_PETASKCOUNT = 10000;
const EQUIPITEM_Underwear = 0;
const EQUIPITEM_Head = 1;
const EQUIPITEM_Hair = 2;
const EQUIPITEM_Hair2 = 3;
const EQUIPITEM_Neck = 4;
const EQUIPITEM_RHand = 5;
const EQUIPITEM_Chest = 6;
const EQUIPITEM_LHand = 7;
const EQUIPITEM_REar = 8;
const EQUIPITEM_LEar = 9;
const EQUIPITEM_Gloves = 10;
const EQUIPITEM_Legs = 11;
const EQUIPITEM_Feet = 12;
const EQUIPITEM_RFinger = 13;
const EQUIPITEM_LFinger = 14;
const EQUIPITEM_LBracelet = 15;
const EQUIPITEM_RBracelet = 16;
const EQUIPITEM_Deco1 = 17;
const EQUIPITEM_Deco2 = 18;
const EQUIPITEM_Deco3 = 19;
const EQUIPITEM_Deco4 = 20;
const EQUIPITEM_Deco5 = 21;
const EQUIPITEM_Deco6 = 22;
const EQUIPITEM_Cloak = 23;
const EQUIPITEM_Waist = 24;
const EQUIPITEM_Brooch = 25;
const EQUIPITEM_Jewel1 = 26;
const EQUIPITEM_Jewel2 = 27;
const EQUIPITEM_Jewel3 = 28;
const EQUIPITEM_Jewel4 = 29;
const EQUIPITEM_Jewel5 = 30;
const EQUIPITEM_Jewel6 = 31;
const EQUIPITEM_AGATHION_MAIN = 32;
const EQUIPITEM_AGATHION_SUB1 = 33;
const EQUIPITEM_AGATHION_SUB2 = 34;
const EQUIPITEM_AGATHION_SUB3 = 35;
const EQUIPITEM_AGATHION_SUB4 = 36;
const EQUIPITEM_TOTAL_CLASSIC = 37;
const INVENTORY_ITEM_TAB = 0;
const INVENTORY_ITEM_1_TAB = 1;
const INVENTORY_ITEM_2_TAB = 2;
const INVENTORY_ITEM_3_TAB = 3;
const INVENTORY_ITEM_4_TAB = 4;
const QUEST_ITEM_TAB = 5;
const TAB_LENGTH = 4;
const STEP_GAB = 2;
const MAX_STEP = 101;
const HENNA_INDEX = 99;
const Henna_CLASSIC_MAX = 4;
const SIZETYPE_START = 0;
const TIMERID_bRequestedEnableList = 99;
const TIMER_bRequestedEnableList = 1000;
const TIMERID_bRequestedDualInventorySwap = 100;
const TIMER_bRequestedDualInventorySwap = 10000;

enum EnchantAniType
{
	underwear,                      // 0
	Head,                           // 1
	hair,                           // 2
	hair2,                          // 3
	neck,                           // 4
	rHand,                          // 5
	chest,                          // 6
	lHand,                          // 7
	rEar,                           // 8
	lEar,                           // 9
	gloves,                         // 10
	legs,                           // 11
	feet,                           // 12
	rFinger,                        // 13
	lFinger,                        // 14
	cloak,                          // 15
	waist,                          // 16
	Max                             // 17
};

var bool bInitedCompleted;
var bool bRequestHennaOnShow;
var bool bRequestedEnableList;
var bool bRequestItemList;
var int preTabOrder;
var ItemWindowHandle m_invenItem;
var ItemWindowHandle m_questItem;
var ItemWindowHandle m_equipItem[37];
var TextBoxHandle m_hAdenaTextBox;
var TabHandle m_invenTab;
var ButtonHandle m_sortBtn;
var TextureHandle m_Talisman_Disable[6];
var TextureHandle m_Jewel_Disable[6];
var ItemWindowHandle m_invenItem_1;
var ItemWindowHandle m_invenItem_2;
var ItemWindowHandle m_invenItem_3;
var ItemWindowHandle m_invenItem_4;
var TextureHandle m_tabbgLine;
var TextBoxHandle m_itemCount;
var int pInventoryItemCount;
var array<ItemID> m_itemOrder;
var Vector m_clickLocation;
var int m_NormalInvenCount;
var int m_QuestInvenCount;
var bool m_bCurrentState;
var int m_MaxInvenCount;
var int m_MaxQuestItemInvenCount;
var ButtonHandle CollectionBtn;
var AnimTextureHandle CollectionPointAni;
var ButtonHandle ItemAutoPeelBtn;
var ButtonHandle m_hBtnCrystallize;
var WindowHandle ColorNickNameWnd;
var int m_selectedItemTab;
var ButtonHandle AdenacalculateButton;
var ButtonHandle ItemConversionButton;
var ButtonHandle EnchantJewelButton;
var bool m_bFirstOpened;
var ButtonHandle ViewHairButton;
var ButtonHandle ViewAccessoryButton;
var WindowHandle JewelWindow;
var string cur_state;
var int mainClass;
var bool bIsPremiumHennaSlot;
var QuitReportWnd QuitReportWndScript;
var string m_EquipWindowName;
var WindowHandle m_EquipWindow;
var WindowHandle AgathionWindow;
var ButtonHandle AgathionBtn;
var TextureHandle m_Agathion_Disable[5];
var ButtonHandle invenExpandSkillBtn;
var L2Util l2UtilScript;
var bool bIsSavedLocalItemIdx;
var array<int> itemSwapedServerID;
var array<int> itemSwapedServerID_1;
var array<int> itemSwapedServerID_2;
var array<int> itemSwapedServerID_3;
var array<int> itemSwapedServerID_4;
var array<int> itemSwapedServerID_q;
var array<int> itemSwapedServerID_a;
var array<int> itemSwapedIdx;
var array<int> itemSwapedIdx_1;
var array<int> itemSwapedIdx_2;
var array<int> itemSwapedIdx_3;
var array<int> itemSwapedIdx_4;
var array<int> itemSwapedIdx_q;
var array<int> itemSwapedIdx_a;
var bool bIsQuestItemList;
var array<ItemInfo> newItems;
var int m_SelectedExpandEquipIdx;
var int m_SelectedExpandEquipIdxPrev;
var TextureHandle m_TalismanAllow;
var ButtonHandle EquipItem_Brooch_Button;
var ButtonHandle EquipItem_RBracelet_Button;
var ButtonHandle EquipItem_LBracelet_Button;
var WindowHandle m_InventoryWndCharacterView;
var ButtonHandle m_CharacterViewOpen_BTN;
var ButtonHandle m_CharacterViewClose_BTN;
var int bShowhairAccessory;
var TextureHandle EquipSlotBg_Sigil;
var ItemInfo lasetSelectedItemInfo;
var TextureHandle Hair2SlotDisable_tex;
var WindowHandle equipItem_Henna_Window;
var ButtonHandle equipItem_Henna_Button;
var TextureHandle hennas_Disable4;
var ItemWindowHandle hennaItems[4];
var TextureHandle HennaBtn_Texture;
var UIControlGroupButtonAssets SubGroupButtonAsset;
var bool bUnStableSwapping;
var bool bRequestedDualInventorySwap;
var array<AnimTextureHandle> enchantAnis;
var TextureHandle EquipSlotBg_RBracelet;
var TextureHandle EquipSlotBg_LBracelet;
var array<ItemInfo> decoIteminfos;
var array<ItemInfo> AgathionIteminfos;
var array<ItemInfo> jewelIteminfos;
var int sizeType;
var ButtonHandle scaleBtn;

event OnRegisterEvent()
{
	RegisterEvent(2570);
	RegisterEvent(2580);
	RegisterEvent(2590);
	RegisterEvent(2600);
	RegisterEvent(2610);
	RegisterEvent(2620);
	RegisterEvent(2630);
	RegisterEvent(2631);
	RegisterEvent(180);
	RegisterEvent(181);
	RegisterEvent(40);
	RegisterEvent(2070);
	RegisterEvent(9439);
	RegisterEvent(3410);
	RegisterEvent(5312);
	RegisterEvent(5310);
	RegisterEvent(8000);
	RegisterEvent(2900);
	RegisterEvent(11430);
	RegisterEvent(11520);
	RegisterEvent(11590);
	RegisterEvent(11591);
	return;
}

event OnLoad()
{
	l2UtilScript = L2Util(GetScript("L2Util"));
	SetClosingOnESC();
	InitHandleCOD();
	SetEquipWindowHandle();
	InitEnchantAniTextures();
	SetHennaWindows();
	SetHandles();
	m_bCurrentState = false;
	m_selectedItemTab = 0;
	QuitReportWndScript = QuitReportWnd(GetScript("QuitReportWnd"));
	InitTabIcon();
	InitHennaGrouBtns();
	InitSwapGroupButton();
	InitDualToDefaultA();
	invenExpandSkillBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".InvenExpandSkillButton"));
	_HandleHideDevTool();
	return;
}

function InitSwapGroupButton()
{
	SubGroupButtonAsset = Class'InterfaceClassic.UIControlGroupButtonAssets'.static._InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SubUIControlGroupButtonAsset")));
	SubGroupButtonAsset._SetStartInfo("L2UI_ct1.RankingWnd.RankingWnd_SubTabButton", "L2UI_NewTex.Button.SubTabButton_Selected", "L2UI_ct1.RankingWnd.RankingWnd_SubTabButton_Over", true);
	SubGroupButtonAsset._GetGroupButtonsInstance().DelegateOnClickButton = DelegateOnClickButton;
	SubGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(0, GetSystemString(14274));
	SubGroupButtonAsset._GetGroupButtonsInstance()._setButtonText(1, GetSystemString(14275));
	SubGroupButtonAsset._GetGroupButtonsInstance()._setShowButtonNum(2);
	SubGroupButtonAsset._GetGroupButtonsInstance()._fixedWidth(100, 5);
	SubGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(0, true);
	return;
}

function InitHennaGrouBtns()
{
	local UIControlGroupButtonHighlighting scr;

	scr = Class'InterfaceClassic.UIControlGroupButtonHighlighting'.static.InitScript(equipItem_Henna_Window);
	scr._SetBtnTexture("L2UI_CT1.InventoryWnd.Talisman_HennaBTN_Normal", "L2UI_CT1.InventoryWnd.Talisman_HennaBTN_Over", "L2UI_CT1.InventoryWnd.Talisman_HennaBTN_Normal");
	scr.DelegateOnButtonClick = HandleDelegateOnClickBUtton;
	scr.DelegateOnLButtonUp = HandleDelegateOnLButtonUp;
	return;
}

function UpdateInvenExpandSkillBtn()
{
	local bool IsCanLevelUpInvenExpandSkill;

	if((m_selectedItemTab == 5))
	{
		invenExpandSkillBtn.HideWindow();
		return;
	}
	if(m_hOwnerWnd.IsShowWindow())
	{
		IsCanLevelUpInvenExpandSkill = Class'InterfaceClassic.SkillWnd'.static.Inst().IsCanLevelUpInvenExpandSkill();
		if(IsCanLevelUpInvenExpandSkill)
		{
			invenExpandSkillBtn.ShowWindow();
		}
		else
		{
			invenExpandSkillBtn.HideWindow();
		}
	}
	return;
}

event OnChangeScalableUI(int a_SizeType)
{
	local int W, h;
	local float btnW, bglineW, bgLineH, ScaleRatio;
	local int gabBGLine;
	local string btnName;
	local Rect rectWnd, rectWndLine;

	Debug((("OnChangeScalableUI" @ string(sizeType)) @ string(a_SizeType)));
	sizeType = a_SizeType;
	SwitchEquipBox(m_SelectedExpandEquipIdx);
	setBottomButtonPositions();
	SetBraceletAnchor();
	CheckShowCrystallizeButton();
	btnName = GetTextureByCurrentSizeType();
	scaleBtn.SetTexture((btnName $ "N"), (btnName $ "D"), (btnName $ "O"));
	m_invenTab.GetWindowSize(W, h);
	ScaleRatio = GetScaleRatio();
	btnW = (56.0000000 * ScaleRatio);
	gabBGLine = (W - (int(btnW) * 6));
	m_tabbgLine.SetAnchor(m_invenTab.m_WindowNameWithFullPath, "BottomRight", "BottomLeft", -gabBGLine, 0);
	bglineW = (46.0000000 * ScaleRatio);
	bgLineH = (2.0000000 * ScaleRatio);
	m_tabbgLine.SetWindowSize((appCeil(bglineW) + gabBGLine), appCeil(bgLineH));
	toogleCharacterViewPort(false);
	return;
}

function OnClickScaleButtonMoveToButtonCenter()
{
	local int mX, mY;
	local Rect rectWndBtn, rectWnd;

	API_GetClientCursorPos(mX, mY);
	rectWndBtn = scaleBtn.GetRect();
	rectWnd = m_hOwnerWnd.GetRect();
	m_hOwnerWnd.Move(((mX - rectWndBtn.nX) - (rectWndBtn.nWidth / 2)), ((mY - rectWndBtn.nY) - (rectWndBtn.nHeight / 2)));
	return;
}

event OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 99:
			bRequestedEnableList = false;
			m_hOwnerWnd.KillTimer(99);
			break;
		case 100:
			m_hOwnerWnd.KillTimer(100);
			bRequestedDualInventorySwap = false;
			break;
		default:
			break;
	}
	return;
}

event OnEvent(int Event_ID, string param)
{
	local UIEventManager.ELanguageType Language;

	switch(Event_ID)
	{
		case 2900:
			Handle_EV_ResolutionChanged();
			break;
		case 3410:
			cur_state = param;
			break;
		case 180:
			HandleUpdateUserInfo();
			break;
		case 181:
			HandleUpdateUserEquipSlotInfo();
			break;
		case 2570:
			HandleClear();
			break;
		case 2580:
			HandleOpenWindow(param);
			break;
		case 2600:
			HandleAddItem(param);
			break;
		case 2620:
			HandleItemListEnd();
			break;
		case 2610:
			if((int(Language) != 0))
			{
				showItemUpdateEffect(param);
			}
			HandleUpdateItem(param);
			break;
		case 9439:
			ReceiveHairAccessoryPriority(param);
			break;
		case 2590:
			HandleHideWindow();
			break;
		case 2631:
			HandleToggleWindow();
			break;
		case 40:
			HandleRestart();
			break;
		case 2070:
			HandleSetMaxCount(param);
			break;
		case 5312:
			handleChangedSubjob(param);
		case 5310:
			handleNotifySubjob(param);
			break;
		case 8000:
			checkClassicForm();
			break;
		case 11430:
			clearEquipItemTooltip();
			break;
		case 11520:
			HandleHair2SlotEnable(param);
			break;
		case 11590:
			Handle_EV_DualInventoryInfo(param);
			break;
		case 11591:
			Handle_EV_RequestDualInventorySwap();
			break;
		default:
			break;
	}
	return;
}

function clearEquipItemTooltip()
{
	local int i;

	i = 0;
	while((i < 37))
	{
		m_equipItem[i].ClearItemTooltip();
		i++;
	}
	return;
}

event OnShow()
{
	if(CollectionSystem(GetScript("CollectionSystem"))._IsCollectionOpen())
	{
		m_hOwnerWnd.HideWindow();
		return;
	}
	if(IsShowWindow("PostWriteWnd"))
	{
		HideWindow("InventoryWnd");
	}
	else
	{
		getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)), "AttributeEnchantWnd,AttributeRemoveWnd,UnrefineryWnd,CrystallizationWnd,ItemAttributeChangeWnd,ProgressBox");
	}
	CheckShowCrystallizeButton();
	SetAdenaText();
	SetItemCount();
	ShowHideCharacterViewPortOnShow();
	SwitchEquipBox(m_SelectedExpandEquipIdx);
	handleNewItemOnShow();
	CollectionPointAni.Stop();
	CollectionPointAni.Pause();
	CollectionPointAni.HideWindow();
	if(!bInitedCompleted)
	{
		HennaMenuWnd(GetScript("HennaMenuWnd")).API_C_EX_NEW_HENNA_LIST();
		bInitedCompleted = true;
		bRequestItemList = false;
	}
	else
	{
		if(bRequestHennaOnShow)
		{
			HennaMenuWnd(GetScript("HennaMenuWnd")).API_C_EX_NEW_HENNA_LIST();
			bRequestHennaOnShow = false;
		}
		API_C_EX_ITEM_USABLE_LIST();
	}
	return;
}

event OnHide()
{
	handleNewItemOnHide();
	m_invenTab.SetButtonBlink(6, false);
	if(m_bCurrentState)
	{
		SaveInventoryOrder();
	}
	if(DialogIsMine())
	{
		DialogHide();
	}
	if(Class'InterfaceClassic.UIControlContextMenu'.static.GetInstance().IsMine(string(self)))
	{
		Class'InterfaceClassic.UIControlContextMenu'.static.GetInstance().Hide();
	}
	return;
}

event OnEnterState(name a_CurrentStateName)
{
	SetCurrentScaleSize();
	SetBraceletAnchor();
	if((IsPotentialServer() == false))
	{
		SwitchEquipBox(25);
	}
	setBottomButtonPositions();
	m_bCurrentState = true;
	return;
}

function SetBraceletAnchor()
{
	local float ratio;

	ratio = GetScaleRatio();
	ratio = 1.0000000;
	if((IsPotentialServer() == true))
	{
		HennaBtn_Texture.ShowWindow();
		equipItem_Henna_Button.ShowWindow();
		EquipSlotBg_RBracelet.SetAnchor(EquipSlotBg_RBracelet.GetParentWindowHandle().m_WindowNameWithFullPath, "TopLeft", "TopLeft", (64 * ratio), (386 * ratio));
		EquipSlotBg_LBracelet.SetAnchor(EquipSlotBg_RBracelet.GetParentWindowHandle().m_WindowNameWithFullPath, "TopLeft", "TopLeft", (118 * ratio), (386 * ratio));
	}
	else
	{
		HennaBtn_Texture.HideWindow();
		equipItem_Henna_Button.HideWindow();
		EquipSlotBg_RBracelet.SetAnchor(EquipSlotBg_RBracelet.GetParentWindowHandle().m_WindowNameWithFullPath, "TopLeft", "TopLeft", (91 * ratio), (386 * ratio));
		EquipSlotBg_LBracelet.SetAnchor(EquipSlotBg_RBracelet.GetParentWindowHandle().m_WindowNameWithFullPath, "TopLeft", "TopLeft", (172 * ratio), (386 * ratio));
	}
	return;
}

event OnExitState(name a_CurrentStateName)
{
	m_bCurrentState = false;
	return;
}

function bool devModeItemDelete(ItemWindowHandle a_hItemWindow, int Index)
{
	local ItemInfo SelectItemInfo;

	if((IsBuilderPC() && (int(GetReleaseMode()) == 0)))
	{
		if((Class'NWindow.InputAPI'.static.IsAltPressed() && Class'NWindow.InputAPI'.static.IsCtrlPressed()))
		{
			a_hItemWindow.GetItem(Index, SelectItemInfo);
			if((Class'NWindow.UIDATA_PLAYER'.static.HasCrystallizeAbility() && Class'NWindow.UIDATA_ITEM'.static.IsCrystallizable(SelectItemInfo.Id)))
			{
				getInstanceL2Util().showGfxScreenMessage(("DevMode: 결정화 ClassID:" @ string(SelectItemInfo.Id.ClassID)));  // EN?: DevMode: crystallization ClassID:
				CrystallizationWnd(GetScript("CrystallizationWnd")).SetItemInfo(SelectItemInfo);
				RequestCrystallizeEstimate(SelectItemInfo.Id, INT64(1));
				return true;
			}
			else if((SelectItemInfo.bIsDesturctAble == false))
			{
				getInstanceL2Util().showGfxScreenMessage(("DevMode: 파쇄 불가 아이템입니다. //di 클래스아이디 수량, 통해 지우세요. ClassID:" @ string(SelectItemInfo.Id.ClassID)));  // EN?: DevMode: This item is not shreddable.//di Class ID Quantity, clear through. ClassID:
				ChatWnd(GetScript("chatWnd")).SetChatEditBox(((("//di " $ string(SelectItemInfo.Id.ClassID)) $ " ") $ string(SelectItemInfo.ItemNum)));
				return true;
			}
			else
			{
				getInstanceL2Util().showGfxScreenMessage(((("DevMode: 아이템 삭제!" @ SelectItemInfo.Name) @ "ClassID:") @ string(SelectItemInfo.Id.ClassID)));  // EN?: DevMode: Delete Item!
				RequestDestroyItem(SelectItemInfo.Id, SelectItemInfo.ItemNum);
				return true;
			}
		}
	}
	return false;
}

event OnDBClickItemWithHandle(ItemWindowHandle a_hItemWindow, int Index)
{
	if(devModeItemDelete(a_hItemWindow, Index))
	{
		return;
	}
	UseItem(a_hItemWindow, Index);
	return;
}

event OnRClickItemWithHandle(ItemWindowHandle a_hItemWindow, int Index)
{
	local ItemInfo Info;

	if(devModeItemDelete(a_hItemWindow, Index))
	{
		return;
	}
	a_hItemWindow.GetItem(Index, Info);
	delNewItem(Info);
	if(IsKeyDown(IK_Ctrl))
	{
		CheckNOpenItemAutoPeel(Info.Id.ServerID, Info.Id.ClassID, IsKeyDown(IK_Alt));
		return;
	}
	UseItem(a_hItemWindow, Index);
	return;
}

event OnSelectItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
	local int i;
	local ItemInfo Info;
	local string ItemName;

	a_hItemWindow.GetSelectedItem(Info);
	if(IsKeyDown(IK_Shift))
	{
		ItemName = GetItemNameAll(Info);
		if((Len(ItemName) > 40))
		{
			ItemName = Left(ItemName, 40);
			ItemName = (ItemName $ "...");
		}
		SetItemTextLink(Info.Id, ItemName, ToolTip(GetScript("Tooltip"))._GetItemNameColor(Info.Id), _ItemNameLen(Info), Info.Enchanted);
	}
	switch(a_hItemWindow)
	{
		case m_invenItem:
		case m_invenItem_1:
		case m_invenItem_2:
		case m_invenItem_3:
		case m_invenItem_4:
		case m_questItem:
			delNewItem(Info);
			CheckCollectionEnableItem(Info);
			return;
		case m_equipItem[16]:
			SwitchEquipBox(16);
			break;
		case m_equipItem[15]:
			SwitchEquipBox(15);
			break;
		case m_equipItem[25]:
			SwitchEquipBox(25);
			break;
		default:
			break;
	}
	i = 0;
	while((i < 37))
	{
		if((a_hItemWindow != m_equipItem[i]))
		{
			m_equipItem[i].ClearSelect();
		}
		++i;
	}
	return;
}

event OnDropItem(string strTarget, ItemInfo Info, int X, int Y)
{
	local int toIndex, fromIndex;
	local CrystallizationWnd CrystallizationWndScript;
	local ItemWindowHandle normalinven;

	CrystallizationWndScript = CrystallizationWnd(GetScript("CrystallizationWnd"));
	if(!isDragSrcInventory(Info.DragSrcName))
	{
		return;
	}
	if((((((strTarget == "InventoryItem") || (strTarget == "InventoryItem_1")) || (strTarget == "InventoryItem_2")) || (strTarget == "InventoryItem_3")) || (strTarget == "InventoryItem_4")))
	{
		if((Info.DragSrcName == strTarget))
		{
			normalinven = getItemWindowHandleBystrTarget(strTarget);
			toIndex = normalinven.GetIndexAt(X, Y, 1, 1);
			if((toIndex >= 0))
			{
				fromIndex = normalinven.FindItem(Info.Id);
				if((toIndex != fromIndex))
				{
					normalinven.SwapItems(fromIndex, toIndex);
				}
			}
		}
		else if(((-1 != InStr(Info.DragSrcName, "EquipItem")) && (Left(Info.DragSrcName, 12) != "PetEquipItem")))
		{
			handleRequestUnequipItem(Info.DragSrcName, Info.Id, Info.SlotBitType);
		}
		else if((Left(Info.DragSrcName, 12) == "PetEquipItem"))
		{
			PetWndClassic(GetScript("PetWndClassic")).API_C_EX_PET_UNEQUIP_ITEM(Info.Id.ServerID);
		}
		else if((Info.DragSrcName == "PetInvenWnd"))
		{
			if((IsStackableItem(Info.ConsumeType) && (Info.ItemNum > INT64(1))))
			{
				if((Info.AllItemCount > INT64(0)))
				{
					if(CheckItemLimit(Info.Id, Info.AllItemCount))
					{
						Class'NWindow.PetAPI'.static.RequestGetItemFromPet(Info.Id, Info.AllItemCount, false);
					}
				}
				else
				{
					DialogSetID(10000);
					DialogSetReservedItemID(Info.Id);
					DialogSetParamInt64(Info.ItemNum);
					DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), Info.Name));
					DialogSetInputlimit(Info.ItemNum);
					Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
				}
			}
			else
			{
				Class'NWindow.PetAPI'.static.RequestGetItemFromPet(Info.Id, INT64(1), false);
			}
		}
	}
	else if((strTarget == "QuestItem"))
	{
		if((Info.DragSrcName == "QuestItem"))
		{
			toIndex = m_questItem.GetIndexAt(X, Y, 1, 1);
			if((toIndex >= 0))
			{
				fromIndex = m_questItem.FindItem(Info.Id);
				if((toIndex != fromIndex))
				{
					m_questItem.SwapItems(fromIndex, toIndex);
				}
			}
		}
	}
	else if(((-1 != InStr(strTarget, "EquipItem")) || (strTarget == "ObjectViewportDispatchMsg")))
	{
		if((Info.DragSrcName == "PetInvenWnd"))
		{
			Class'NWindow.PetAPI'.static.RequestGetItemFromPet(Info.Id, INT64(1), true);
		}
		else if((-1 != InStr(Info.DragSrcName, "EquipItem")))
		{
		}
		else if((int(byte(Info.ItemType)) != 5))
		{
			RequestUseItem(Info.Id);
		}
	}
	else if((strTarget == "TrashButton"))
	{
		if((IsShowWindow("AttributeEnchantWnd") == true))
		{
			AddSystemMessage(4148);
			return;
		}
		if(isDamagedItem(Info))
		{
			AddSystemMessage(14005);
			return;
		}
		if((IsStackableItem(Info.ConsumeType) && (Info.ItemNum > INT64(1))))
		{
			if((Info.AllItemCount > INT64(0)))
			{
				DialogSetID(7777);
				DialogSetReservedItemID(Info.Id);
				DialogSetReservedInt2(Info.AllItemCount);
				DialogShow(DialogModalType_Modalless, DialogType_Warning, MakeFullSystemMsg(GetSystemMessage(74), Info.Name, ""));
				Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
			}
			else
			{
				DialogSetID(8888);
				DialogSetReservedItemID(Info.Id);
				DialogSetParamInt64(Info.ItemNum);
				DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(73), Info.Name));
				DialogSetInputlimit(Info.ItemNum);
				Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
			}
		}
		else if((Class'NWindow.UIDATA_PLAYER'.static.HasCrystallizeAbility() && Class'NWindow.UIDATA_ITEM'.static.IsCrystallizable(Info.Id)))
		{
			CrystallizationWndScript.SetItemInfo(Info);
			RequestCrystallizeEstimate(Info.Id, INT64(1));
		}
		else
		{
			DialogSetID(6666);
			DialogSetReservedItemID(Info.Id);
			DialogShow(DialogModalType_Modalless, DialogType_Warning, MakeFullSystemMsg(GetSystemMessage(74), Info.Name));
			Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
		}
	}
	else if((strTarget == "CrystallizeButton"))
	{
		if((IsShowWindow("AttributeEnchantWnd") == true))
		{
			AddSystemMessage(4148);
			return;
		}
		if(((((((Info.DragSrcName == "InventoryItem") || (Info.DragSrcName == "InventoryItem_1")) || (Info.DragSrcName == "InventoryItem_2")) || (Info.DragSrcName == "InventoryItem_3")) || (Info.DragSrcName == "InventoryItem_4")) || (-1 != InStr(Info.DragSrcName, "EquipItem"))))
		{
			if((Class'NWindow.UIDATA_PLAYER'.static.HasCrystallizeAbility() && Class'NWindow.UIDATA_ITEM'.static.IsCrystallizable(Info.Id)))
			{
				CrystallizationWndScript.SetItemInfo(Info);
				RequestCrystallizeEstimate(Info.Id, INT64(1));
			}
			else
			{
				CrystallizationWndScript.cancelCystallizeItem();
				AddSystemMessage(2171);
			}
		}
	}
	else if((strTarget == "AdenacalculateButton"))
	{
		if((IsAdena(Info.Id) && !Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("AdenaDistributionWnd")))
		{
			CallGFxFunction("AdenaDistributionWnd", "RequestDivideAdenaStart", "");
		}
		else
		{
			AddSystemMessage(4158);
		}
	}
	else if((strTarget == "EnchantJewelButton"))
	{
		HandleJewelDropedOnButton(Info);
	}
	else if((strTarget == "CollectionBtn"))
	{
		CheckNOpenCollection(Info);
	}
	else if((strTarget == "ItemAutoPeelBtn"))
	{
		CheckNOpenItemAutoPeel(Info.Id.ServerID, Info.Id.ClassID, IsKeyDown(IK_Alt));
	}
	else if((strTarget == "ItemConversionButton"))
	{
		HandleItemUpgradeDropedOnButton(Info);
	}
	return;
}

function HandleItemUpgradeDropedOnButton(ItemInfo iInfo)
{
	if(Class'NWindow.UIDATA_ITEM'.static.IsUpgradableItem(iInfo.Id, 1, 2))
	{
		CallGFxFunction("ItemUpgrade", "DropItemOutside", ((((("ClassID=" $ string(iInfo.Id.ClassID)) @ "Enchanted=") $ string(iInfo.Enchanted)) @ "ServerID=") $ string(iInfo.Id.ServerID)));
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(1960));
	}
	return;
}

function CheckNOpenCollection(ItemInfo iInfo)
{
	if((iInfo.Id.ClassID < 1))
	{
		CollectionSystem(GetScript("collectionSystem")).API_C_EX_COLLECTION_OPEN_UI();
		return;
	}
	if(!isCollectionItem(iInfo))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13411));
		return;
	}
	lasetSelectedItemInfo = iInfo;
	OpenCollectionSelectedItem();
	return;
}

function CheckNOpenItemAutoPeel(int itemServerID, int ItemClassID, bool isAllItem)
{
	if((ItemClassID > 0))
	{
		if((Class'NWindow.UIDATA_ITEM'.static.IsDefaultActionPeel(ItemClassID) == false))
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(1960));
			return;
		}
	}
	OpenItemAutoPeelWnd(itemServerID, isAllItem);
	return;
}

function OnDragItemStartTiny(string strID, ItemInfo infItem)
{
	if(((strID == "InventoryItem") || (strID == "InventoryItem_1")))
	{
		if(((Len(infItem.Name) > 0) && GetWindowHandle("ItemEnchantWnd").IsShowWindow()))
		{
			GetWindowHandle("ItemEnchantWnd").SetFocus();
		}
		if(((Len(infItem.Name) > 0) && GetWindowHandle("ItemLookChangeWnd").IsShowWindow()))
		{
			GetWindowHandle("ItemLookChangeWnd").SetFocus();
		}
	}
	return;
}

event OnDropItemSource(string strTarget, ItemInfo Info)
{
	if((strTarget != "Console"))
	{
		return;
	}
	if(!isDragSrcInventory(Info.DragSrcName))
	{
		return;
	}
	if(IsAdenServer())
	{
		AddSystemMessage(14005);
		return;
	}
	if(((IsShowWindow("ItemEnchantWnd") == false) && (IsShowWindow("AttributeEnchantWnd") == false)))
	{
		m_clickLocation = GetClickLocation();
		if((IsStackableItem(Info.ConsumeType) && (Info.ItemNum > INT64(1))))
		{
			if((Info.AllItemCount > INT64(0)))
			{
				DialogHide();
				DialogSetID(5555);
				DialogSetReservedItemID(Info.Id);
				DialogSetReservedInt2(Info.AllItemCount);
				DialogSetEnterOK();
				DialogShow(DialogModalType_Modalless, DialogType_Warning, MakeFullSystemMsg(GetSystemMessage(1833), Info.Name, ""));
				Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
			}
			else
			{
				DialogHide();
				DialogSetID(4444);
				DialogSetReservedItemID(Info.Id);
				DialogSetParamInt64(Info.ItemNum);
				DialogSetEnterOK();
				DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(71), Info.Name, ""));
				DialogSetInputlimit(Info.ItemNum);
				Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
			}
		}
		else
		{
			DialogHide();
			DialogSetID(3333);
			DialogSetReservedItemID(Info.Id);
			DialogSetEnterOK();
			DialogShow(DialogModalType_Modalless, DialogType_Warning, MakeFullSystemMsg(GetSystemMessage(400), Info.Name, ""));
			Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
		}
	}
	else if((IsShowWindow("AttributeEnchantWnd") == true))
	{
		AddSystemMessage(4147);
	}
	else
	{
		AddSystemMessage(3656);
	}
	return;
}

event OnClickButton(string strID)
{
	local string param;

	switch(strID)
	{
		case "scaleBtn":
			HandleScaleBtn();
			break;
		case "InvenExpandSkillButton":
			Class'InterfaceClassic.SkillWnd'.static.Inst().ShowAndInvenExpandSkillInfo();
			break;
		case "SortButton":
			switch(m_selectedItemTab)
			{
				case 0:
					l2UtilScript.SortItem(m_invenItem);
					SaveInventoryOrder();
					break;
				case 1:
					l2UtilScript.SortItem(m_invenItem_1);
					break;
				case 2:
					l2UtilScript.SortItem(m_invenItem_2);
					break;
				case 3:
					l2UtilScript.SortItem(m_invenItem_3);
					break;
				case 4:
					l2UtilScript.SortItem(m_invenItem_4);
					break;
				case 5:
					SortQuestItem();
					break;
				default:
					l2UtilScript.SortItem(m_invenItem);
					SaveInventoryOrder();
					break;
			}
			break;
		case "InventoryTab0":
			m_selectedItemTab = 0;
			m_invenItem.SetScrollPosition(0);
			SetIconOnSelectTabOrder();
			SetItemCount();
			break;
		case "InventoryTab1":
			m_selectedItemTab = 1;
			m_invenItem_1.SetScrollPosition(0);
			SetIconOnSelectTabOrder();
			SetItemCount();
			break;
		case "InventoryTab2":
			m_selectedItemTab = 2;
			m_invenItem_2.SetScrollPosition(0);
			SetIconOnSelectTabOrder();
			SetItemCount();
			break;
		case "InventoryTab3":
			m_selectedItemTab = 3;
			m_invenItem_3.SetScrollPosition(0);
			SetIconOnSelectTabOrder();
			SetItemCount();
			break;
		case "InventoryTab4":
			m_selectedItemTab = 4;
			m_invenItem_4.SetScrollPosition(0);
			SetIconOnSelectTabOrder();
			SetItemCount();
			break;
		case "InventoryTab5":
			m_selectedItemTab = 5;
			m_questItem.SetScrollPosition(0);
			SetIconOnSelectTabOrder();
			SetItemCount();
			break;
		case "AdenacalculateButton":
			if(!Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("PrivateShopWndReport"))
			{
				CallGFxFunction("AdenaDistributionWnd", "RequestDivideAdenaStart", "");
			}
			else
			{
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(5104));
			}
			break;
		case "ItemConversionButton":
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ItemUpgrade"))
			{
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ItemUpgrade");
			}
			else
			{
				ParamAdd(param, "Flag", "1");
				ParamAdd(param, "Type", "1");
				ExecuteEvent(10190, param);
			}
			break;
		case "HairAccButton":
		case "HairButton":
			ChangeViewAccessoryFunc();
			break;
		case "EnchantJewelButton":
			handleEnchantJewelButton();
			break;
		case "CharacterViewOpen_BTN":
			toogleCharacterViewPort(true);
			InventoryWndCharacterView(GetScript("InventoryWndCharacterView")).CharacterClickec();
			break;
		case "CharacterViewClose_BTN":
			toogleCharacterViewPort(false);
			break;
		case "EquipItem_RBracelet_Button":
			SwitchEquipBox(16);
			break;
		case "EquipItem_LBracelet_Button":
			SwitchEquipBox(15);
			break;
		case "EquipItem_Brooch_Button":
			SwitchEquipBox(25);
			break;
		case "CollectionBtn":
			CheckNOpenCollection(lasetSelectedItemInfo);
			break;
		case "ItemAutoPeelBtn":
			CheckNOpenItemAutoPeel(0, 0, false);
			break;
		case "EquipItem_Henna_Button":
			SwitchEquipBox(99);
			break;
		case "NotStableSwappingBtn":
			_RQ_C_EX_DUAL_INVENTORY_SWAP(-1);
			break;
		default:
			break;
	}
	return;
}

function InitHandleCOD()
{
	m_hOwnerWnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath);
	m_invenItem = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".InventoryItem"));
	m_invenItem_1 = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".InventoryItem_1"));
	m_invenItem_2 = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".InventoryItem_2"));
	m_invenItem_3 = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".InventoryItem_3"));
	m_invenItem_4 = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".InventoryItem_4"));
	m_questItem = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".QuestItem"));
	m_invenItem.SetIconDrawType(ITEMWND_IconDraw_ShowNewlyAcquired);
	m_invenItem_1.SetIconDrawType(ITEMWND_IconDraw_ShowNewlyAcquired);
	m_invenItem_2.SetIconDrawType(ITEMWND_IconDraw_ShowNewlyAcquired);
	m_invenItem_3.SetIconDrawType(ITEMWND_IconDraw_ShowNewlyAcquired);
	m_invenItem_4.SetIconDrawType(ITEMWND_IconDraw_ShowNewlyAcquired);
	m_questItem.SetIconDrawType(ITEMWND_IconDraw_ShowNewlyAcquired);
	m_hAdenaTextBox = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenaText"));
	m_invenTab = GetTabHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".InventoryTab"));
	m_sortBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SortButton"));
	m_hBtnCrystallize = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CrystallizeButton"));
	CollectionBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CollectionBtn"));
	CollectionPointAni = GetAnimTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CollectionPointAni"));
	ItemAutoPeelBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemAutoPeelBtn"));
	EnchantJewelButton = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantJewelButton"));
	ItemConversionButton = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemConversionButton"));
	AdenacalculateButton = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenacalculateButton"));
	ColorNickNameWnd = GetWindowHandle("ColorNickNameWnd");
	m_tabbgLine = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tabbgLine"));
	m_itemCount = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemCount"));
	m_CharacterViewOpen_BTN = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CharacterViewOpen_BTN"));
	m_CharacterViewClose_BTN = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CharacterViewClose_BTN"));
	m_InventoryWndCharacterView = GetWindowHandle("InventoryWndCharacterView");
	ItemAutoPeelBtn.SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(14039), GetSystemString(14062)));
	EquipSlotBg_RBracelet = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EquipSlotBg_RBracelet"));
	EquipSlotBg_LBracelet = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EquipSlotBg_LBracelet"));
	scaleBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".scaleBtn"));
	return;
}

function SetEquipWindowHandle()
{
	local string equipWindow, hyphen, tooltipText;
	local CustomTooltip t;

	m_EquipWindowName = "Equip_classic";
	equipWindow = ((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ m_EquipWindowName);
	m_EquipWindow = GetWindowHandle(equipWindow);
	JewelWindow = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EquipItem_Jewel_Window"));
	m_equipItem[25] = GetItemWindowHandle((equipWindow $ ".EquipItem_Brooch"));
	m_equipItem[26] = GetItemWindowHandle((equipWindow $ ".EquipItem_Jewel_Window.EquipItem_Jewel1"));
	m_equipItem[27] = GetItemWindowHandle((equipWindow $ ".EquipItem_Jewel_Window.EquipItem_Jewel2"));
	m_equipItem[28] = GetItemWindowHandle((equipWindow $ ".EquipItem_Jewel_Window.EquipItem_Jewel3"));
	m_equipItem[29] = GetItemWindowHandle((equipWindow $ ".EquipItem_Jewel_Window.EquipItem_Jewel4"));
	m_equipItem[30] = GetItemWindowHandle((equipWindow $ ".EquipItem_Jewel_Window.EquipItem_Jewel5"));
	m_equipItem[31] = GetItemWindowHandle((equipWindow $ ".EquipItem_Jewel_Window.EquipItem_Jewel6"));
	m_Jewel_Disable[0] = GetTextureHandle((equipWindow $ ".EquipItem_Jewel_Window.Jewel1_Disable"));
	m_Jewel_Disable[1] = GetTextureHandle((equipWindow $ ".EquipItem_Jewel_Window.Jewel2_Disable"));
	m_Jewel_Disable[2] = GetTextureHandle((equipWindow $ ".EquipItem_Jewel_Window.Jewel3_Disable"));
	m_Jewel_Disable[3] = GetTextureHandle((equipWindow $ ".EquipItem_Jewel_Window.Jewel4_Disable"));
	m_Jewel_Disable[4] = GetTextureHandle((equipWindow $ ".EquipItem_Jewel_Window.Jewel5_Disable"));
	m_Jewel_Disable[5] = GetTextureHandle((equipWindow $ ".EquipItem_Jewel_Window.Jewel6_Disable"));
	AgathionWindow = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EquipItem_Agathion_Window"));
	AgathionBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AgathionButton"));
	m_Agathion_Disable[0] = GetTextureHandle((equipWindow $ ".EquipItem_Agathion_Window.AgathionMain_Disable"));
	m_Agathion_Disable[1] = GetTextureHandle((equipWindow $ ".EquipItem_Agathion_Window.Agathion1_Disable"));
	m_Agathion_Disable[2] = GetTextureHandle((equipWindow $ ".EquipItem_Agathion_Window.Agathion2_Disable"));
	m_Agathion_Disable[3] = GetTextureHandle((equipWindow $ ".EquipItem_Agathion_Window.Agathion3_Disable"));
	m_Agathion_Disable[4] = GetTextureHandle((equipWindow $ ".EquipItem_Agathion_Window.Agathion4_Disable"));
	m_equipItem[32] = GetItemWindowHandle((equipWindow $ ".EquipItem_Agathion_Window.EquipItem_AgathionMain"));
	m_equipItem[33] = GetItemWindowHandle((equipWindow $ ".EquipItem_Agathion_Window.EquipItem_AgathionSub1"));
	m_equipItem[34] = GetItemWindowHandle((equipWindow $ ".EquipItem_Agathion_Window.EquipItem_AgathionSub2"));
	m_equipItem[35] = GetItemWindowHandle((equipWindow $ ".EquipItem_Agathion_Window.EquipItem_AgathionSub3"));
	m_equipItem[36] = GetItemWindowHandle((equipWindow $ ".EquipItem_Agathion_Window.EquipItem_AgathionSub4"));
	hyphen = getHyphenByLanguage();
	t = getAgathionTooltip((GetSystemString(2341) @ GetSystemString(3638)), (hyphen $ GetSystemString(3643)));
	m_Agathion_Disable[0].SetTooltipCustomType(getAgathionTooltip((GetSystemString(2738) @ GetSystemString(3638)), (hyphen $ GetSystemString(3642))));
	m_Agathion_Disable[1].SetTooltipCustomType(t);
	m_Agathion_Disable[2].SetTooltipCustomType(t);
	m_Agathion_Disable[3].SetTooltipCustomType(t);
	m_Agathion_Disable[4].SetTooltipCustomType(t);
	tooltipText = ((((GetSystemString(2341) @ GetSystemString(3638)) $ "\\n") $ hyphen) $ GetSystemString(3643));
	m_equipItem[32].SetTooltipText(((((GetSystemString(2738) @ GetSystemString(3638)) $ "\\n") $ hyphen) $ GetSystemString(3642)));
	m_equipItem[33].SetTooltipText(tooltipText);
	m_equipItem[34].SetTooltipText(tooltipText);
	m_equipItem[35].SetTooltipText(tooltipText);
	m_equipItem[36].SetTooltipText(tooltipText);
	Hair2SlotDisable_tex = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Equip_classic.Hair2SlotDisable_tex"));
	Hair2SlotDisable_tex.HideWindow();
	return;
}

function InitEnchantAniTextures()
{
	local string equipWindow;
	local int i;

	equipWindow = ((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ m_EquipWindowName);
	enchantAnis.Length = 17;
	enchantAnis[0] = GetAnimTextureHandle((equipWindow $ ".EnchantAni_Underwear"));
	enchantAnis[1] = GetAnimTextureHandle((equipWindow $ ".EnchantAni_Head"));
	enchantAnis[2] = GetAnimTextureHandle((equipWindow $ ".EnchantAni_Hair"));
	enchantAnis[3] = GetAnimTextureHandle((equipWindow $ ".EnchantAni_Hair2"));
	enchantAnis[4] = GetAnimTextureHandle((equipWindow $ ".EnchantAni_Neck"));
	enchantAnis[5] = GetAnimTextureHandle((equipWindow $ ".EnchantAni_RHand"));
	enchantAnis[6] = GetAnimTextureHandle((equipWindow $ ".EnchantAni_Chest"));
	enchantAnis[7] = GetAnimTextureHandle((equipWindow $ ".EnchantAni_LHand"));
	enchantAnis[8] = GetAnimTextureHandle((equipWindow $ ".EnchantAni_REar"));
	enchantAnis[9] = GetAnimTextureHandle((equipWindow $ ".EnchantAni_LEar"));
	enchantAnis[10] = GetAnimTextureHandle((equipWindow $ ".EnchantAni_Gloves"));
	enchantAnis[11] = GetAnimTextureHandle((equipWindow $ ".EnchantAni_Legs"));
	enchantAnis[12] = GetAnimTextureHandle((equipWindow $ ".EnchantAni_Feet"));
	enchantAnis[13] = GetAnimTextureHandle((equipWindow $ ".EnchantAni_RFinger"));
	enchantAnis[14] = GetAnimTextureHandle((equipWindow $ ".EnchantAni_LFinger"));
	enchantAnis[15] = GetAnimTextureHandle((equipWindow $ ".EnchantAni_Cloak"));
	enchantAnis[16] = GetAnimTextureHandle((equipWindow $ ".EnchantAni_Waist"));
	i = 0;
	while((i < 17))
	{
		enchantAnis[i].SetLoopCount(-1);
		i++;
	}
	i = 0;
	while((i < 17))
	{
		enchantAnis[i].Play();
		i++;
	}
	HideAllEnchantLevelAniTextures();
	return;
}

function SetHandles()
{
	local string equipWindow;

	equipWindow = ((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ m_EquipWindowName);
	ViewHairButton = GetButtonHandle((equipWindow $ ".HairButton"));
	ViewAccessoryButton = GetButtonHandle((equipWindow $ ".HairAccButton"));
	m_equipItem[1] = GetItemWindowHandle((equipWindow $ ".EquipItem_Head"));
	m_equipItem[2] = GetItemWindowHandle((equipWindow $ ".EquipItem_Hair"));
	m_equipItem[3] = GetItemWindowHandle((equipWindow $ ".EquipItem_Hair2"));
	m_equipItem[4] = GetItemWindowHandle((equipWindow $ ".EquipItem_Neck"));
	m_equipItem[5] = GetItemWindowHandle((equipWindow $ ".EquipItem_RHand"));
	m_equipItem[6] = GetItemWindowHandle((equipWindow $ ".EquipItem_Chest"));
	m_equipItem[7] = GetItemWindowHandle((equipWindow $ ".EquipItem_LHand"));
	m_equipItem[8] = GetItemWindowHandle((equipWindow $ ".EquipItem_REar"));
	m_equipItem[9] = GetItemWindowHandle((equipWindow $ ".EquipItem_LEar"));
	m_equipItem[10] = GetItemWindowHandle((equipWindow $ ".EquipItem_Gloves"));
	m_equipItem[11] = GetItemWindowHandle((equipWindow $ ".EquipItem_Legs"));
	m_equipItem[12] = GetItemWindowHandle((equipWindow $ ".EquipItem_Feet"));
	m_equipItem[13] = GetItemWindowHandle((equipWindow $ ".EquipItem_RFinger"));
	m_equipItem[14] = GetItemWindowHandle((equipWindow $ ".EquipItem_LFinger"));
	m_equipItem[15] = GetItemWindowHandle((equipWindow $ ".EquipItem_LBracelet"));
	m_equipItem[23] = GetItemWindowHandle((equipWindow $ ".EquipItem_Cloak"));
	m_equipItem[24] = GetItemWindowHandle((equipWindow $ ".EquipItem_Waist"));
	m_equipItem[17] = GetItemWindowHandle((equipWindow $ ".EquipItem_Talisman1"));
	m_equipItem[18] = GetItemWindowHandle((equipWindow $ ".EquipItem_Talisman2"));
	m_equipItem[19] = GetItemWindowHandle((equipWindow $ ".EquipItem_Talisman3"));
	m_equipItem[20] = GetItemWindowHandle((equipWindow $ ".EquipItem_Talisman4"));
	m_equipItem[21] = GetItemWindowHandle((equipWindow $ ".EquipItem_Talisman5"));
	m_equipItem[22] = GetItemWindowHandle((equipWindow $ ".EquipItem_Talisman6"));
	m_Talisman_Disable[0] = GetTextureHandle((equipWindow $ ".Talisman1_Disable"));
	m_Talisman_Disable[1] = GetTextureHandle((equipWindow $ ".Talisman2_Disable"));
	m_Talisman_Disable[2] = GetTextureHandle((equipWindow $ ".Talisman3_Disable"));
	m_Talisman_Disable[3] = GetTextureHandle((equipWindow $ ".Talisman4_Disable"));
	m_Talisman_Disable[4] = GetTextureHandle((equipWindow $ ".Talisman5_Disable"));
	m_Talisman_Disable[5] = GetTextureHandle((equipWindow $ ".Talisman6_Disable"));
	m_equipItem[16] = GetItemWindowHandle((equipWindow $ ".EquipItem_RBracelet"));
	m_equipItem[0] = GetItemWindowHandle((equipWindow $ ".EquipItem_Underwear"));
	m_equipItem[7].SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
	m_equipItem[1].SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
	m_equipItem[10].SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
	m_equipItem[11].SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
	m_equipItem[12].SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
	m_equipItem[3].SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
	EquipItem_Brooch_Button = GetButtonHandle((equipWindow $ ".EquipItem_Brooch_Button"));
	EquipItem_RBracelet_Button = GetButtonHandle((equipWindow $ ".EquipItem_RBracelet_Button"));
	EquipItem_LBracelet_Button = GetButtonHandle((equipWindow $ ".EquipItem_LBracelet_Button"));
	m_equipItem[1].SetTooltipText(GetSystemString(230));
	m_equipItem[2].SetTooltipText(GetSystemString(1024));
	m_equipItem[3].SetTooltipText(GetSystemString(1024));
	m_equipItem[4].SetTooltipText(GetSystemString(238));
	m_equipItem[5].SetTooltipText(GetSystemString(2520));
	m_equipItem[6].SetTooltipText(GetSystemString(38));
	EquipSlotBg_Sigil = GetTextureHandle((equipWindow $ ".EquipSlotBg_Sigil"));
	SetSigilShieldTextureChange(true);
	m_equipItem[8].SetTooltipText(GetSystemString(237));
	m_equipItem[9].SetTooltipText(GetSystemString(237));
	m_equipItem[10].SetTooltipText(GetSystemString(37));
	m_equipItem[11].SetTooltipText(GetSystemString(39));
	m_equipItem[12].SetTooltipText(GetSystemString(40));
	m_equipItem[13].SetTooltipText(GetSystemString(239));
	m_equipItem[14].SetTooltipText(GetSystemString(239));
	m_equipItem[15].SetTooltipText(GetSystemString(1637));
	EquipItem_LBracelet_Button.SetTooltipText(GetSystemString(1637));
	m_equipItem[23].SetTooltipText(GetSystemString(234));
	m_equipItem[24].SetTooltipText(GetSystemString(2538));
	m_equipItem[16].SetTooltipText(GetSystemString(1636));
	EquipItem_RBracelet_Button.SetTooltipText(GetSystemString(1636));
	m_equipItem[17].SetTooltipText(GetSystemString(1638));
	m_equipItem[18].SetTooltipText(GetSystemString(1638));
	m_equipItem[19].SetTooltipText(GetSystemString(1638));
	m_equipItem[20].SetTooltipText(GetSystemString(1638));
	m_equipItem[21].SetTooltipText(GetSystemString(1638));
	m_equipItem[22].SetTooltipText(GetSystemString(1638));
	m_Talisman_Disable[0].SetTooltipText(GetSystemString(1638));
	m_Talisman_Disable[1].SetTooltipText(GetSystemString(1638));
	m_Talisman_Disable[2].SetTooltipText(GetSystemString(1638));
	m_Talisman_Disable[3].SetTooltipText(GetSystemString(1638));
	m_Talisman_Disable[4].SetTooltipText(GetSystemString(1638));
	m_Talisman_Disable[5].SetTooltipText(GetSystemString(1638));
	m_equipItem[26].SetTooltipText(GetSystemString(3187));
	m_equipItem[27].SetTooltipText(GetSystemString(3187));
	m_equipItem[28].SetTooltipText(GetSystemString(3187));
	m_equipItem[29].SetTooltipText(GetSystemString(3187));
	m_equipItem[30].SetTooltipText(GetSystemString(3187));
	m_equipItem[31].SetTooltipText(GetSystemString(3187));
	m_Jewel_Disable[0].SetTooltipText(GetSystemString(3187));
	m_Jewel_Disable[1].SetTooltipText(GetSystemString(3187));
	m_Jewel_Disable[2].SetTooltipText(GetSystemString(3187));
	m_Jewel_Disable[3].SetTooltipText(GetSystemString(3187));
	m_Jewel_Disable[4].SetTooltipText(GetSystemString(3187));
	m_Jewel_Disable[5].SetTooltipText(GetSystemString(3187));
	m_equipItem[0].SetTooltipText(GetSystemString(28));
	m_equipItem[25].SetTooltipText(GetSystemString(3186));
	EquipItem_Brooch_Button.SetTooltipText(GetSystemString(3186));
	m_TalismanAllow = GetTextureHandle((equipWindow $ ".TalismanAllow"));
	SetDualSlotBitTypes();
	return;
}

function SetDualSlotBitTypes()
{
	m_equipItem[0].SetDualSlotBitType(INT64(1));
	m_equipItem[1].SetDualSlotBitType(INT64(64));
	m_equipItem[2].SetDualSlotBitType(INT64(65536));
	m_equipItem[3].SetDualSlotBitType(INT64(262144));
	m_equipItem[4].SetDualSlotBitType(INT64(8));
	m_equipItem[5].SetDualSlotBitType(INT64(128));
	m_equipItem[6].SetDualSlotBitType(INT64(1024));
	m_equipItem[7].SetDualSlotBitType(INT64(256));
	m_equipItem[8].SetDualSlotBitType(INT64(2));
	m_equipItem[9].SetDualSlotBitType(INT64(4));
	m_equipItem[10].SetDualSlotBitType(INT64(512));
	m_equipItem[11].SetDualSlotBitType(INT64(2048));
	m_equipItem[12].SetDualSlotBitType(INT64(4096));
	m_equipItem[13].SetDualSlotBitType(INT64(16));
	m_equipItem[14].SetDualSlotBitType(INT64(32));
	m_equipItem[23].SetDualSlotBitType(INT64(8192));
	m_equipItem[24].SetDualSlotBitType(INT64(268435456));
	return;
}

function SetSigilShieldTextureChange(bool B)
{
	if(B)
	{
		EquipSlotBg_Sigil.SetTexture("L2UI_ct1.InventoryWnd.Inventory_Slot_SigilShield_Large");
		m_equipItem[7].SetTooltipText(GetSystemString(13205));
	}
	else
	{
		EquipSlotBg_Sigil.SetTexture("L2UI_ct1.InventoryWnd.Inventory_Slot_Sigil_Large");
		m_equipItem[7].SetTooltipText(GetSystemString(1987));
	}
	return;
}

function CustomTooltip getEquipCustomTooltip(string Title, string Desc)
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(Title, getInstanceL2Util().BrightWhite, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = addDrawItemText(Desc, getInstanceL2Util().ColorDesc, "", true, false);
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 205;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	return mCustomTooltip;
}

function SetHennaWindows()
{
	local int i;
	local string equipWindow;

	equipWindow = ((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ m_EquipWindowName);
	equipItem_Henna_Button = GetButtonHandle((equipWindow $ ".equipItem_Henna_Button"));
	equipItem_Henna_Button.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14826)));
	equipItem_Henna_Window = GetWindowHandle((equipWindow $ ".equipItem_Henna_Window"));
	hennas_Disable4 = GetTextureHandle((equipWindow $ ".EquipItem_Henna_Window.henna4_Disable"));
	i = 0;
	while((i < 4))
	{
		hennaItems[i] = GetItemWindowHandle(((equipWindow $ ".EquipItem_Henna_Window.hennaItem") $ string((i + 1))));
		i++;
	}
	HennaBtn_Texture = GetTextureHandle((equipWindow $ ".HennaBtn_Texture"));
	return;
}

function string getHyphenByLanguage()
{
	if((int(GetLanguage()) == 0))
	{
		return "­";
	}
	return "-";
}

function HandleDelegateOnClickBUtton(string btn)
{
	switch(btn)
	{
		case "GroupBaseBtn":
			toggleWindow("HennaEnchantWnd", true);
			break;
		default:
			break;
	}
	return;
}

function HandleDelegateOnLButtonUp(WindowHandle wnd, int X, int Y)
{
	switch(wnd)
	{
		case hennaItems[0]:
		case hennaItems[1]:
		case hennaItems[2]:
		case hennaItems[3]:
			HandleChangeHennaDye((int(Right(wnd.GetWindowName(), 1)) - 1));
			break;
		default:
			break;
	}
	return;
}

function HandleRestart()
{
	bRequestHennaOnShow = false;
	m_bCurrentState = false;
	bInitedCompleted = false;
	bRequestedEnableList = false;
	m_hOwnerWnd.HideWindow();
	InitDualToDefaultA();
	return;
}

function HandleDialogOK()
{
	local int Id;
	local INT64 reserved2;
	local ItemID sID;
	local INT64 Number;

	if(DialogIsMine())
	{
		Id = DialogGetID();
		reserved2 = DialogGetReservedInt2();
		Number = INT64(DialogGetString());
		sID = DialogGetReservedItemID();
		if(((Id == 1111) || (Id == 2222)))
		{
			RequestUseItem(sID);
		}
		else if((Id == 3333))
		{
			RequestDropItem(sID, INT64(1), m_clickLocation);
		}
		else if((Id == 4444))
		{
			if((Number == INT64(0)))
			{
				Number = INT64(1);
			}
			RequestDropItem(sID, Number, m_clickLocation);
		}
		else if((Id == 5555))
		{
			RequestDropItem(sID, reserved2, m_clickLocation);
		}
		else if((Id == 6666))
		{
			RequestDestroyItem(sID, INT64(1));
			PlayConsoleSound(IFST_TRASH_BASKET);
		}
		else if((Id == 8888))
		{
			RequestDestroyItem(sID, Number);
			PlayConsoleSound(IFST_TRASH_BASKET);
		}
		else if((Id == 7777))
		{
			RequestDestroyItem(sID, reserved2);
			PlayConsoleSound(IFST_TRASH_BASKET);
		}
		else if((Id == 9999))
		{
			RequestCrystallizeItem(sID, INT64(1));
			PlayConsoleSound(IFST_TRASH_BASKET);
		}
		else if((Id == 10000))
		{
			Class'NWindow.PetAPI'.static.RequestGetItemFromPet(sID, Number, false);
		}
	}
	return;
}

function ChangeViewAccessoryFunc()
{
	local ItemInfo infItem;

	infItem.Id.ClassID = 17192;
	UseSkill(infItem.Id, 2);
	return;
}

function UseItem(ItemWindowHandle a_hItemWindow, int Index)
{
	local ItemInfo Info;

	if(a_hItemWindow.GetItem(Index, Info))
	{
		UseItemWithItemInfo(Info);
	}
	return;
}

function UseItemWithItemInfo(ItemInfo Info)
{
	if((Info.bDisabled == 0))
	{
		API_UseItemWithInfo(Info);
	}
	else if((Class'NWindow.UIDATA_ITEM'.static.IsDefaultActionPeel(Info.Id.ClassID) && Class'InterfaceClassic.ItemAutoPeelWnd'.static.Inst().IsItemReady()))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13680));
	}
	return;
}

function HandleJewelDropedOnButton(ItemInfo iInfo)
{
	Class'InterfaceClassic.ItemJewelEnchantWnd'.static.Inst()._HandleDropedItem(iInfo);
	return;
}

function UpdateItemUsability()
{
	m_invenItem.SetItemUsability();
	m_invenItem_1.SetItemUsability();
	m_invenItem_2.SetItemUsability();
	m_invenItem_3.SetItemUsability();
	m_invenItem_4.SetItemUsability();
	m_questItem.SetItemUsability();
	return;
}

function API_C_EX_ITEM_USABLE_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_ITEM_USABLE_LIST packet;

	if(bRequestedEnableList)
	{
		return;
	}
	m_hOwnerWnd.KillTimer(99);
	m_hOwnerWnd.SetTimer(99, 1000);
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_ITEM_USABLE_LIST(stream, packet))
	{
		return;
	}
	packet.cDummy = 0;
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(753, stream);
	bRequestedEnableList = true;
	return;
}

function HandleUpdateItemWithInfo(ItemInfo Info, string Type)
{
	local ItemInfo beforeItem;
	local int Index;
	local ItemWindowHandle detailItemWindowHandle;

	SetShowItemCount(Info);
	if((Type == "add"))
	{
		if(IsEquipItem(Info))
		{
			QuitReportWndScript.externalAddItem(Info);
			EquipItemUpdate(Info, true);
		}
		else if(IsQuestItem(Info))
		{
			QuestInvenAddItem(Info);
			handleNewItem(Info);
		}
		else
		{
			QuitReportWndScript.externalAddItem(Info);
			NormalInvenAddItem(Info);
			handleNewItem(Info);
		}
	}
	else if((Type == "update"))
	{
		if(IsEquipItem(Info))
		{
			InvenDelete(Info);
			EquipItemUpdate(Info, true);
		}
		else if(IsQuestItem(Info))
		{
			Index = m_questItem.FindItem(Info.Id);
			if((Index != -1))
			{
				m_questItem.GetItem(Index, beforeItem);
				m_questItem.SetItem(Index, Info);
				if((beforeItem.ItemNum < Info.ItemNum))
				{
					handleNewItem(Info);
				}
			}
			else
			{
				EquipItemDelete(Info.Id);
				QuestInvenAddItem(Info);
				handleNewItem(Info);
			}
		}
		else
		{
			Index = m_invenItem.FindItem(Info.Id);
			if((Index != -1))
			{
				m_invenItem.GetItem(Index, beforeItem);
				if((beforeItem.ItemNum != Info.ItemNum))
				{
					QuitReportWndScript.externalAddItem(Info);
				}
				m_invenItem.SetItem(Index, Info);
				detailItemWindowHandle = GetItemWindowHandleByItemType(Info);
				detailItemWindowHandle.SetItem(detailItemWindowHandle.FindItem(Info.Id), Info);
				if(Class'InterfaceClassic.L2UIInventory'.static.Inst()._IsPeroidicItem(Info))
				{
					m_invenItem_4.SetItem(m_invenItem_4.FindItem(Info.Id), Info);
				}
				if((beforeItem.ItemNum < Info.ItemNum))
				{
					handleNewItem(Info);
				}
			}
			else
			{
				EquipItemDelete(Info.Id);
				NormalInvenAddItem(Info);
			}
		}
	}
	else if((Type == "delete"))
	{
		if(IsEquipItem(Info))
		{
			EquipItemDelete(Info.Id);
		}
		else if(IsQuestItem(Info))
		{
			QuestInvenDelete(Info);
		}
		else
		{
			InvenDelete(Info);
		}
	}
	UpdateItemUsability();
	SetAdenaText();
	SetItemCount();
	return;
}

function HandleUpdateItem(string param)
{
	local ItemInfo Info;
	local string Type;

	ParseString(param, "type", Type);
	ParamToItemInfo(param, Info);
	HandleUpdateItemWithInfo(Info, Type);
	return;
}

function HandleItemListEnd()
{
	if(!bIsQuestItemList)
	{
		bIsQuestItemList = true;
		return;
	}
	SetAdenaText();
	SetItemCount();
	UpdateItemUsability();
	if(bIsSavedLocalItemIdx)
	{
		SaveInventoryOrder();
	}
	if(bRequestItemList)
	{
		bRequestItemList = false;
		ShowWindowWithFocus("InventoryWnd");
		PlayConsoleSound(IFST_INVENWND_OPEN);
	}
	return;
}

function SortAllDetailWIndows()
{
	l2UtilScript.SortItem(m_invenItem_1);
	l2UtilScript.SortItem(m_invenItem_2);
	l2UtilScript.SortItem(m_invenItem_3);
	l2UtilScript.SortItem(m_invenItem_4);
	return;
}

function HandleAddItem(string param)
{
	local ItemInfo Info;

	ParamToItemInfo(param, Info);
	SetShowItemCount(Info);
	if(IsEquipItem(Info))
	{
		EquipItemUpdate(Info);
	}
	else if(IsQuestItem(Info))
	{
		QuestInvenAddItem(Info);
	}
	else
	{
		NormalInvenAddItem(Info);
	}
	return;
}

function FillEmptyItemOnAdd(int ORDER)
{
	local int i;
	local ItemInfo ClearItem;

	if((m_invenItem.GetItemNum() > ORDER))
	{
		return;
	}
	ClearItemID(ClearItem.Id);
	ClearItem.IconName = "L2ui_ct1.emptyBtn";
	i = m_invenItem.GetItemNum();
	while((i <= ORDER))
	{
		m_invenItem.AddItem(ClearItem);
		i++;
	}
	return;
}

function AddDetailWindow(ItemInfo NewItem)
{
	local ItemWindowHandle detailItemWindow;
	local int FindIdx;

	detailItemWindow = GetItemWindowHandleByItemType(NewItem);
	if(bIsSavedLocalItemIdx)
	{
		FindIdx = getLocalItemOrderByItemWindow(detailItemWindow, NewItem.Id.ServerID, -1);
	}
	else
	{
		FindIdx = GetInValidIndex(detailItemWindow);
	}
	if((FindIdx > -1))
	{
		detailItemWindow.SetItem(FindIdx, NewItem);
	}
	else
	{
		detailItemWindow.AddItem(NewItem);
	}
	if(Class'InterfaceClassic.L2UIInventory'.static.Inst()._IsPeroidicItem(NewItem))
	{
		detailItemWindow = m_invenItem_4;
		if(bIsSavedLocalItemIdx)
		{
			FindIdx = getLocalItemOrderByItemWindow(detailItemWindow, NewItem.Id.ServerID, -1);
		}
		else
		{
			FindIdx = GetInValidIndex(detailItemWindow);
		}
		if((FindIdx > -1))
		{
			detailItemWindow.SetItem(FindIdx, NewItem);
		}
		else
		{
			detailItemWindow.AddItem(NewItem);
		}
	}
	return;
}

function NormalInvenAddItem(ItemInfo NewItem)
{
	local int FindIdx;
	local ItemInfo CurItem;

	FindIdx = -1;
	if(bIsSavedLocalItemIdx)
	{
		NewItem.ORDER = getLocalItemOrder(NewItem.Id.ServerID, itemSwapedServerID, itemSwapedIdx, NewItem.ORDER);
	}
	FillEmptyItemOnAdd(NewItem.ORDER);
	if(m_invenItem.GetItem(NewItem.ORDER, CurItem))
	{
		if(!IsValidItemID(CurItem.Id))
		{
			FindIdx = NewItem.ORDER;
		}
	}
	if((FindIdx < 0))
	{
		FindIdx = GetInValidIndex(m_invenItem);
	}
	if((FindIdx > -1))
	{
		m_invenItem.SetItem(FindIdx, NewItem);
	}
	else
	{
		m_invenItem.AddItem(NewItem);
	}
	m_NormalInvenCount++;
	AddDetailWindow(NewItem);
	return;
}

function int GetInValidIndex(ItemWindowHandle wnd)
{
	local int idx, CurLimit;
	local ItemInfo CurItem;

	CurLimit = GetMyInventoryLimit();
	idx = 0;
	while((idx < CurLimit))
	{
		if(wnd.GetItem(idx, CurItem))
		{
			if(!IsValidItemID(CurItem.Id))
			{
				return idx;
			}
		}
		idx++;
	}
	return -1;
}

function QuestInvenAddItem(ItemInfo NewItem)
{
	local int idx, CurLimit, FindIdx;
	local ItemInfo CurItem;

	FindIdx = -1;
	if(bIsSavedLocalItemIdx)
	{
		FindIdx = getLocalItemOrderByItemWindow(m_questItem, NewItem.Id.ServerID, -1);
	}
	else if(m_questItem.GetItem(NewItem.ORDER, CurItem))
	{
		if(!IsValidItemID(CurItem.Id))
		{
			FindIdx = NewItem.ORDER;
		}
	}
	if((FindIdx < 0))
	{
		CurLimit = m_questItem.GetItemNum();
		idx = 0;
		while((idx < CurLimit))
		{
			if(m_questItem.GetItem(idx, CurItem))
			{
				if(!IsValidItemID(CurItem.Id))
				{
					FindIdx = idx;
					break;
				}
			}
			idx++;
		}
	}
	if((FindIdx > -1))
	{
		m_questItem.SetItem(FindIdx, NewItem);
	}
	else
	{
		m_questItem.AddItem(NewItem);
	}
	m_QuestInvenCount++;
	return;
}

function EquipItemUpdate(ItemInfo a_Info, optional bool bSwitchExpandEquipBox)
{
	local ItemWindowHandle hItemWnd;
	local ItemInfo TheItemInfo;
	local bool ClearLHand;
	local ItemInfo rHand, legs, gloves, feet, hair2;

	switch(a_Info.SlotBitType)
	{
		case INT64(1):
			HandleChkSwitchEquipBox(-1, a_Info, bSwitchExpandEquipBox);
			hItemWnd = m_equipItem[0];
			break;
		case INT64(2):
		case INT64(4):
		case INT64(6):
			HandleChkSwitchEquipBox(-1, a_Info, bSwitchExpandEquipBox);
			EquipItemUpdate_Ears_Fingers(a_Info);
			hItemWnd = none;
			break;
		case INT64(8):
			HandleChkSwitchEquipBox(-1, a_Info, bSwitchExpandEquipBox);
			hItemWnd = m_equipItem[4];
			break;
		case INT64(16):
		case INT64(32):
		case INT64(48):
			HandleChkSwitchEquipBox(-1, a_Info, bSwitchExpandEquipBox);
			EquipItemUpdate_Ears_Fingers(a_Info);
			hItemWnd = none;
			break;
		case INT64(64):
			HandleChkSwitchEquipBox(-1, a_Info, bSwitchExpandEquipBox);
			hItemWnd = m_equipItem[1];
			hItemWnd.EnableWindow();
			break;
		case INT64(128):
			HandleChkSwitchEquipBox(-1, a_Info, bSwitchExpandEquipBox);
			SetSigilShieldTextureChange(true);
			hItemWnd = m_equipItem[5];
			break;
		case INT64(256):
			HandleChkSwitchEquipBox(-1, a_Info, bSwitchExpandEquipBox);
			hItemWnd = m_equipItem[7];
			hItemWnd.EnableWindow();
			break;
		case INT64(512):
			HandleChkSwitchEquipBox(-1, a_Info, bSwitchExpandEquipBox);
			hItemWnd = m_equipItem[10];
			hItemWnd.EnableWindow();
			break;
		case INT64(1024):
			HandleChkSwitchEquipBox(-1, a_Info, bSwitchExpandEquipBox);
			hItemWnd = m_equipItem[6];
			break;
		case INT64(2048):
			HandleChkSwitchEquipBox(-1, a_Info, bSwitchExpandEquipBox);
			hItemWnd = m_equipItem[11];
			hItemWnd.EnableWindow();
			break;
		case INT64(4096):
			HandleChkSwitchEquipBox(-1, a_Info, bSwitchExpandEquipBox);
			hItemWnd = m_equipItem[12];
			hItemWnd.EnableWindow();
			break;
		case INT64(8192):
			HandleChkSwitchEquipBox(-1, a_Info, bSwitchExpandEquipBox);
			hItemWnd = m_equipItem[23];
			hItemWnd.EnableWindow();
			break;
		case INT64(16384):
			HandleChkSwitchEquipBox(-1, a_Info, bSwitchExpandEquipBox);
			hItemWnd = m_equipItem[5];
			ClearLHand = true;
			if(m_equipItem[7].GetItem(0, TheItemInfo))
			{
				if((IsSigil(TheItemInfo) || IsArrow(TheItemInfo)))
				{
					ClearLHand = false;
				}
			}
			if(ClearLHand)
			{
				if((Len(a_Info.IconNameEx1) != 0))
				{
					rHand = a_Info;
					m_equipItem[5].Clear();
					AddEquipItem(5, rHand);
					SetSigilShieldTextureChange(false);
				}
				else
				{
					DelEquipItem(7);
					SetSigilShieldTextureChange(false);
				}
			}
			break;
		case INT64(32768):
			HandleChkSwitchEquipBox(-1, a_Info, bSwitchExpandEquipBox);
			hItemWnd = m_equipItem[6];
			a_Info.IconIndex = 1;
			legs = a_Info;
			legs.IconIndex = 2;
			m_equipItem[11].Clear();
			AddEquipItem(11, legs);
			m_equipItem[11].DisableWindow();
			break;
		case INT64(65536):
			HandleChkSwitchEquipBox(-1, a_Info, bSwitchExpandEquipBox);
			hItemWnd = m_equipItem[2];
			break;
		case INT64(131072):
			HandleChkSwitchEquipBox(-1, a_Info, bSwitchExpandEquipBox);
			hItemWnd = m_equipItem[6];
			hair2 = a_Info;
			gloves = a_Info;
			legs = a_Info;
			feet = a_Info;
			hair2.IconName = a_Info.IconNameEx1;
			gloves.IconName = a_Info.IconNameEx2;
			legs.IconName = a_Info.IconNameEx3;
			feet.IconName = a_Info.IconNameEx4;
			m_equipItem[1].Clear();
			AddEquipItem(1, hair2);
			m_equipItem[1].DisableWindow();
			m_equipItem[10].Clear();
			AddEquipItem(10, gloves);
			m_equipItem[10].DisableWindow();
			m_equipItem[11].Clear();
			AddEquipItem(11, legs);
			m_equipItem[11].DisableWindow();
			m_equipItem[12].Clear();
			AddEquipItem(12, feet);
			m_equipItem[12].DisableWindow();
			break;
		case INT64(262144):
			HandleChkSwitchEquipBox(-1, a_Info, bSwitchExpandEquipBox);
			hItemWnd = m_equipItem[3];
			hItemWnd.EnableWindow();
			break;
		case INT64(524288):
			HandleChkSwitchEquipBox(-1, a_Info, bSwitchExpandEquipBox);
			hItemWnd = m_equipItem[2];
			m_equipItem[3].Clear();
			AddEquipItem(3, a_Info);
			m_equipItem[3].DisableWindow();
			break;
		case INT64(1048576):
			HandleChkSwitchEquipBox(16, a_Info, bSwitchExpandEquipBox);
			hItemWnd = m_equipItem[16];
			m_equipItem[16].Clear();
			AddEquipItem(16, a_Info);
			m_equipItem[16].EnableWindow();
			break;
		case INT64(4194304):
		case INT64(12582912):
		case INT64(50331648):
		case INT64(201326592):
			HandleChkSwitchEquipBox(16, a_Info, bSwitchExpandEquipBox);
			HandleDecoEquip(a_Info);
			break;
		case INT64(268435456):
			HandleChkSwitchEquipBox(-1, a_Info, bSwitchExpandEquipBox);
			hItemWnd = m_equipItem[24];
			break;
		case INT64(536870912):
			HandleChkSwitchEquipBox(25, a_Info, bSwitchExpandEquipBox);
			hItemWnd = m_equipItem[25];
			m_equipItem[25].Clear();
			AddEquipItem(25, a_Info);
			m_equipItem[25].EnableWindow();
			break;
		case INT64(1073741824):
			HandleChkSwitchEquipBox(25, a_Info, bSwitchExpandEquipBox);
			HandleJewelEquip(a_Info);
			break;
		case INT64(2097152):
			HandleChkSwitchEquipBox(15, a_Info, bSwitchExpandEquipBox);
			hItemWnd = m_equipItem[15];
			m_equipItem[15].Clear();
			AddEquipItem(15, a_Info);
			m_equipItem[15].EnableWindow();
			break;
		case INT64(48):
			HandleChkSwitchEquipBox(15, a_Info, bSwitchExpandEquipBox);
			handleAgathionEquip(a_Info);
			break;
		default:
			HandleChkSwitchEquipBox(-1, a_Info, bSwitchExpandEquipBox);
			break;
	}
	if((none != hItemWnd))
	{
		hItemWnd.Clear();
		AddEquipItemWithIWnd(hItemWnd, a_Info);
	}
	return;
}

function handleAgathionEquip(ItemInfo iInfo)
{
	local int i;

	if((AddAgathionEquip(iInfo) == false))
	{
		i = 0;
		while((i < AgathionIteminfos.Length))
		{
			if(IsSameServerID(AgathionIteminfos[i].Id, iInfo.Id))
			{
				return;
			}
			i++;
		}
		AgathionIteminfos[AgathionIteminfos.Length] = iInfo;
	}
	return;
}

function HandleAgathionEquipOnSLotUpdate()
{
	local int i;

	i = 0;
	while((i < AgathionIteminfos.Length))
	{
		AddAgathionEquip(AgathionIteminfos[i]);
		i++;
	}
	AgathionIteminfos.Length = 0;
	return;
}

function bool AddAgathionEquip(ItemInfo iInfo)
{
	local int agathionIndex;

	agathionIndex = GetAgathionIndex(iInfo.Id);
	if((agathionIndex == -1))
	{
		return false;
	}
	m_equipItem[(32 + agathionIndex)].Clear();
	AddEquipItem((32 + agathionIndex), iInfo);
	m_equipItem[(32 + agathionIndex)].EnableWindow();
	return true;
}

function HandleJewelEquip(ItemInfo iInfo)
{
	local int i;

	if((AddJewelEquip(iInfo) == false))
	{
		i = 0;
		while((i < jewelIteminfos.Length))
		{
			if(IsSameServerID(jewelIteminfos[i].Id, iInfo.Id))
			{
				return;
			}
			i++;
		}
		jewelIteminfos[jewelIteminfos.Length] = iInfo;
	}
	return;
}

function HandleJewelEquipOnSLotUpdate()
{
	local int i;

	i = 0;
	while((i < jewelIteminfos.Length))
	{
		AddJewelEquip(jewelIteminfos[i]);
		i++;
	}
	jewelIteminfos.Length = 0;
	return;
}

function bool AddJewelEquip(ItemInfo iInfo)
{
	local int jewelIndex;

	jewelIndex = GetJewelIndex(iInfo.Id);
	if((jewelIndex == -1))
	{
		return false;
	}
	m_equipItem[(26 + jewelIndex)].Clear();
	AddEquipItem((26 + jewelIndex), iInfo);
	m_equipItem[(26 + jewelIndex)].EnableWindow();
	return true;
}

function HandleDecoEquip(ItemInfo iInfo)
{
	local int i;

	if((AddDecoEquip(iInfo) == false))
	{
		i = 0;
		while((i < decoIteminfos.Length))
		{
			if(IsSameServerID(decoIteminfos[i].Id, iInfo.Id))
			{
				return;
			}
			i++;
		}
		decoIteminfos[decoIteminfos.Length] = iInfo;
	}
	return;
}

function HandleDecoEquipOnSLotUpdate()
{
	local int i;

	i = 0;
	while((i < decoIteminfos.Length))
	{
		AddDecoEquip(decoIteminfos[i]);
		i++;
	}
	decoIteminfos.Length = 0;
	return;
}

function bool AddDecoEquip(ItemInfo iInfo)
{
	local int decoIndex;

	decoIndex = GetDecoIndex(iInfo.Id);
	if((decoIndex == -1))
	{
		return false;
	}
	m_equipItem[(17 + decoIndex)].Clear();
	AddEquipItem((17 + decoIndex), iInfo);
	m_equipItem[(17 + decoIndex)].EnableWindow();
	return true;
}

function HandleUpdateUserEquipSlotInfo()
{
	HandleUpdateUserEquipSlotInfo_Ears_Fingers();
	HandleDecoEquipOnSLotUpdate();
	UpdateTalismanSlotActivation();
	HandleJewelEquipOnSLotUpdate();
	UpdateJewelSlotActivation();
	HandleAgathionEquipOnSLotUpdate();
	UpdateAgathionSlotActivation();
	return;
}

function handleRequestUnequipItem(string DragSrcName, ItemID infoID, INT64 SlotBitType)
{
	local INT64 tmpSlotbitType;

	if((-1 != InStr(DragSrcName, "Talisman")))
	{
		switch(Right(DragSrcName, 1))
		{
			case "1":
				tmpSlotbitType = INT64(4194304);
				break;
			case "2":
				tmpSlotbitType = INT64(8388608);
				break;
			case "3":
				tmpSlotbitType = INT64(16777216);
				break;
			case "4":
				tmpSlotbitType = INT64(33554432);
				break;
			case "5":
				tmpSlotbitType = INT64(67108864);
				break;
			case "6":
				tmpSlotbitType = INT64(134217728);
				break;
			default:
				break;
		}
	}
	else if((-1 != InStr(DragSrcName, "Jewel")))
	{
		switch(Right(DragSrcName, 1))
		{
			case "1":
				tmpSlotbitType = INT64(1073741824);
				break;
			case "2":
				tmpSlotbitType = -9223372036854775808;
				break;
			case "3":
				tmpSlotbitType = INT64(1);
				break;
			case "4":
				tmpSlotbitType = INT64(2);
				break;
			case "5":
				tmpSlotbitType = INT64(4);
				break;
			case "6":
				tmpSlotbitType = INT64(8);
				break;
			default:
				break;
		}
	}
	else if((-1 != InStr(DragSrcName, "Agathion")))
	{
		tmpSlotbitType = GetAgathionSlotBitType(Right(DragSrcName, 1));
	}
	if((tmpSlotbitType == INT64(0)))
	{
		RequestUnequipItem(infoID, SlotBitType);
	}
	else
	{
		RequestUnequipItem(infoID, tmpSlotbitType);
	}
	return;
}

function EquipItemDelete(ItemID sID)
{
	local int i, Index;
	local ItemInfo TheItemInfo;

	i = 0;
	while((i < 37))
	{
		Index = m_equipItem[i].FindItem(sID);
		if((-1 != Index))
		{
			DelEquipItem(i);
			m_equipItem[i].EnableWindow();
			if((i == 7))
			{
				if(m_equipItem[5].GetItem(0, TheItemInfo))
				{
					if((TheItemInfo.SlotBitType == INT64(16384)))
					{
					}
				}
			}
			else if((i == 5))
			{
				SetSigilShieldTextureChange(true);
			}
			switch(i)
			{
				case 25:
				case 15:
				case 16:
					setExpandEquipItemButton(i);
					SwitchEquipBox(i);
					break;
				case 17:
				case 18:
				case 19:
				case 20:
				case 21:
				case 22:
					SwitchEquipBox(16);
					break;
				case 26:
				case 27:
				case 28:
				case 29:
				case 30:
				case 31:
					SwitchEquipBox(25);
					break;
				case 32:
				case 33:
				case 34:
				case 35:
				case 36:
					SwitchEquipBox(15);
					break;
				default:
					break;
			}
		}
		++i;
	}
	return;
}

function setExpandEquipItemButton(int i)
{
	switch(i)
	{
		case 16:
			EquipItem_RBracelet_Button.ShowWindow();
			break;
		case 15:
			EquipItem_LBracelet_Button.ShowWindow();
			break;
		case 25:
			EquipItem_Brooch_Button.ShowWindow();
			break;
		default:
			break;
	}
	return;
}

function InvenDelete(ItemInfo item)
{
	local int FindIdx;
	local ItemInfo ClearItem;
	local ItemWindowHandle detailItemWindow;

	FindIdx = m_invenItem.FindItem(item.Id);
	if((FindIdx == -1))
	{
		return;
	}
	m_NormalInvenCount--;
	ClearItemID(ClearItem.Id);
	ClearItem.IconName = "L2ui_ct1.emptyBtn";
	m_invenItem.SetItem(FindIdx, ClearItem);
	detailItemWindow = GetItemWindowHandleByItemType(item);
	FindIdx = detailItemWindow.FindItem(item.Id);
	detailItemWindow.SetItem(FindIdx, ClearItem);
	FindIdx = m_invenItem_4.FindItem(item.Id);
	if((FindIdx != -1))
	{
		m_invenItem_4.SetItem(FindIdx, ClearItem);
	}
	return;
}

function QuestInvenDelete(ItemInfo item)
{
	local int FindIdx;
	local ItemInfo ClearItem;

	FindIdx = m_questItem.FindItem(item.Id);
	if((FindIdx != -1))
	{
		m_questItem.DeleteItem(FindIdx);
		m_QuestInvenCount--;
		ClearItemID(ClearItem.Id);
		ClearItem.IconName = "L2ui_ct1.emptyBtn";
		m_questItem.AddItem(ClearItem);
	}
	return;
}

function HandleClear()
{
	if(m_hOwnerWnd.IsShowWindow())
	{
		saveLocalItemOrder();
	}
	InvenClear();
	invenItem_1Clear();
	invenItem_2Clear();
	invenItem_3Clear();
	invenItem_4Clear();
	QuestInvenClear();
	EquipItemClear();
	decoIteminfos.Length = 0;
	AgathionIteminfos.Length = 0;
	jewelIteminfos.Length = 0;
	InvenLimitUpdate();
	bIsQuestItemList = false;
	HideAllEnchantLevelAniTextures();
	return;
}

function EquipItemClear()
{
	local int i;

	i = 0;
	while((i < 37))
	{
		DelEquipItem(i);
		++i;
	}
	setExpandEquipItemButton(25);
	setExpandEquipItemButton(15);
	setExpandEquipItemButton(16);
	return;
}

function InvenClear()
{
	m_invenItem.Clear();
	m_NormalInvenCount = 0;
	return;
}

function QuestInvenClear()
{
	m_questItem.Clear();
	m_QuestInvenCount = 0;
	return;
}

function invenItem_1Clear()
{
	m_invenItem_1.Clear();
	return;
}

function invenItem_2Clear()
{
	m_invenItem_2.Clear();
	return;
}

function invenItem_3Clear()
{
	m_invenItem_3.Clear();
	return;
}

function invenItem_4Clear()
{
	m_invenItem_4.Clear();
	return;
}

function saveLocalItemOrder()
{
	local int i;

	bIsSavedLocalItemIdx = true;
	i = 0;
	while((i < m_invenItem.GetItemNum()))
	{
		saveServerID(m_invenItem, i, itemSwapedServerID, itemSwapedIdx);
		saveServerID(m_invenItem_1, i, itemSwapedServerID_1, itemSwapedIdx_1);
		saveServerID(m_invenItem_2, i, itemSwapedServerID_2, itemSwapedIdx_2);
		saveServerID(m_invenItem_3, i, itemSwapedServerID_3, itemSwapedIdx_3);
		saveServerID(m_invenItem_4, i, itemSwapedServerID_4, itemSwapedIdx_4);
		i++;
	}
	i = 0;
	while((i < m_questItem.GetItemNum()))
	{
		saveServerID(m_questItem, i, itemSwapedServerID_q, itemSwapedIdx_q);
		i++;
	}
	return;
}

function saveServerID(ItemWindowHandle targetWindow, int idx, out array<int> serverIDList, out array<int> SwapedIdx)
{
	local ItemInfo invenInfo;

	targetWindow.GetItem(idx, invenInfo);
	if((invenInfo.Id.ServerID != -1))
	{
		invenInfo.ORDER = idx;
		idx = serverIDList.Length;
		serverIDList.Length = (serverIDList.Length + 1);
		serverIDList[idx] = invenInfo.Id.ServerID;
		SwapedIdx[idx] = invenInfo.ORDER;
	}
	return;
}

function int getLocalItemOrder(int ServerID, array<int> serverIDList, array<int> SwapedIdx, int defaultOrder)
{
	local int i;

	i = 0;
	while((i < serverIDList.Length))
	{
		if((serverIDList[i] == ServerID))
		{
			return SwapedIdx[i];
		}
		i++;
	}
	return defaultOrder;
}

function int getLocalItemOrderByItemWindow(ItemWindowHandle targetWindow, int ServerID, int defaultOrder)
{
	switch(targetWindow)
	{
		case m_invenItem_1:
			return getLocalItemOrder(ServerID, itemSwapedServerID_1, itemSwapedIdx_1, defaultOrder);
		case m_invenItem_2:
			return getLocalItemOrder(ServerID, itemSwapedServerID_2, itemSwapedIdx_2, defaultOrder);
		case m_invenItem_3:
			return getLocalItemOrder(ServerID, itemSwapedServerID_3, itemSwapedIdx_3, defaultOrder);
		case m_invenItem_4:
			return getLocalItemOrder(ServerID, itemSwapedServerID_4, itemSwapedIdx_4, defaultOrder);
		case m_questItem:
			return getLocalItemOrder(ServerID, itemSwapedServerID_q, itemSwapedIdx_q, defaultOrder);
		default:
			return defaultOrder;
	}
}

function SaveInventoryOrder()
{
	local int idx, InvenLimit;
	local ItemInfo item;
	local array<ItemID> IDList;
	local array<int> OrderList;

	InvenLimit = m_invenItem.GetItemNum();
	idx = 0;
	while((idx < InvenLimit))
	{
		if(m_invenItem.GetItem(idx, item))
		{
			if(IsValidItemID(item.Id))
			{
				IDList.Insert(IDList.Length, 1);
				IDList[(IDList.Length - 1)] = item.Id;
				OrderList.Insert(OrderList.Length, 1);
				OrderList[(OrderList.Length - 1)] = item.ORDER;
			}
		}
		idx++;
	}
	if((IDList.Length > 0))
	{
		RequestSaveInventoryOrder(IDList, OrderList);
	}
	bIsSavedLocalItemIdx = false;
	itemSwapedIdx.Length = 0;
	itemSwapedIdx_1.Length = 0;
	itemSwapedIdx_2.Length = 0;
	itemSwapedIdx_3.Length = 0;
	itemSwapedIdx_4.Length = 0;
	itemSwapedIdx_q.Length = 0;
	itemSwapedIdx_a.Length = 0;
	itemSwapedServerID.Length = 0;
	itemSwapedServerID_1.Length = 0;
	itemSwapedServerID_2.Length = 0;
	itemSwapedServerID_3.Length = 0;
	itemSwapedServerID_4.Length = 0;
	itemSwapedServerID_q.Length = 0;
	itemSwapedServerID_a.Length = 0;
	return;
}

function bool IsEquipItem(out ItemInfo Info)
{
	return Info.bEquipped;
}

function bool IsQuestItem(out ItemInfo Info)
{
	return (int(byte(Info.ItemType)) == 3);
}

function EquipItemUpdate_Ears_Fingers(ItemInfo equipiInfo)
{
	local int itemIndex;
	local ItemInfo eqipediInfo;
	local ItemWindowHandle EquipItem;

	if((GetEquipItemIndex_Ears_Fingers(equipiInfo.Id, itemIndex) == false))
	{
		return;
	}
	EquipItem = m_equipItem[itemIndex];
	EquipItem.GetItem(0, eqipediInfo);
	if(IsSameServerID(equipiInfo.Id, eqipediInfo.Id))
	{
		if((equipiInfo.Damaged != eqipediInfo.Damaged))
		{
			EquipItem.SetItem(0, equipiInfo);
		}
		return;
	}
	AddEquipItem(itemIndex, equipiInfo);
	return;
}

function ChangeItemWindow(ItemID equipiID, int itemIndex)
{
	local ItemInfo eqipediInfo, equipiInfo;
	local ItemWindowHandle EquipItem;

	EquipItem = m_equipItem[itemIndex];
	EquipItem.GetItem(0, eqipediInfo);
	if(IsSameServerID(equipiID, eqipediInfo.Id))
	{
		return;
	}
	DelEquipItem(itemIndex);
	if((Class'NWindow.UIDATA_INVENTORY'.static.FindItem(equipiID.ServerID, equipiInfo) == true))
	{
		AddEquipItem(itemIndex, equipiInfo);
	}
	return;
}

function HandleUpdateUserEquipSlotInfo_Ears_Fingers()
{
	local ItemID lEar, rEar, lFinger, rFinger;

	GetAccessoryItemID(lEar, rEar, lFinger, rFinger);
	ChangeItemWindow(lEar, 9);
	ChangeItemWindow(rEar, 8);
	ChangeItemWindow(lFinger, 14);
	ChangeItemWindow(rFinger, 13);
	return;
}

function bool GetEquipItemIndex_Ears_Fingers(ItemID iID, out int itemIndex)
{
	local ItemID lEar, rEar, lFinger, rFinger;

	GetAccessoryItemID(lEar, rEar, lFinger, rFinger);
	if(IsSameServerID(iID, lEar))
	{
		itemIndex = 9;
	}
	else if(IsSameServerID(iID, rEar))
	{
		itemIndex = 8;
	}
	else if(IsSameServerID(iID, lFinger))
	{
		itemIndex = 14;
	}
	else if(IsSameServerID(iID, rFinger))
	{
		itemIndex = 13;
	}
	return (itemIndex > 0);
}

function bool IsBowOrFishingRod(ItemInfo a_Info)
{
	switch(byte(a_Info.WeaponType))
	{
		case 11:
		case 15:
		case 17:
		case 22:
			return true;
		default:
			return false;
	}
}

function bool IsArrow(ItemInfo a_Info)
{
	return a_Info.bArrow;
}

function bool isDragSrcInventory(string DragSrcName)
{
	switch(DragSrcName)
	{
		case "InventoryItem":
		case "QuestItem":
		case "PetInvenWnd":
		case "InventoryItem_1":
		case "InventoryItem_2":
		case "InventoryItem_3":
		case "InventoryItem_4":
			return true;
		default:
			if((-1 != InStr(DragSrcName, "EquipItem")))
			{
				return true;
			}
			return false;
	}
}

function int EquipNormalItemGetItemNum()
{
	local int i, ItemNum;

	i = 0;
	while((i < 37))
	{
		if((m_equipItem[i].m_pTargetWnd != none))
		{
			if(m_equipItem[i].IsEnableWindow())
			{
				ItemNum = (ItemNum + m_equipItem[i].GetItemNum());
			}
		}
		++i;
	}
	return ItemNum;
}

function bool EquipItemFind(ItemID sID)
{
	local int i, Index;
	local ItemInfo iInfo;

	i = 0;
	while((i < 37))
	{
		if((m_equipItem[i].GetItemNum() > 0))
		{
			m_equipItem[i].GetItem(0, iInfo);
		}
		Index = m_equipItem[i].FindItem(sID);
		if((-1 != Index))
		{
			return true;
		}
		++i;
	}
	return false;
}

function int getCurrentInventoryItemCount()
{
	return pInventoryItemCount;
}

function bool getInventoryItemWndName(string Str)
{
	local int i;

	i = 0;
	while((i <= 4))
	{
		if((i == 0))
		{
			if(("InventoryItem" == Str))
			{
				return true;
			}
			++i;
			continue;
		}
		if((("InventoryItem_" $ string(i)) == Str))
		{
			return true;
		}
		++i;
	}
	return false;
}

function bool GetInventoryItemInfo(ItemID Id, out ItemInfo InvenItemInfo, optional bool onlyUseClassID)
{
	local bool bHasItem;
	local int i, Index;
	local ItemInfo tempOutItemInfo, tmpItemInfo;

	bHasItem = false;
	if(onlyUseClassID)
	{
		Index = m_invenItem.FindItemByClassID(Id);
	}
	else
	{
		Index = m_invenItem.FindItem(Id);
	}
	if((Index > -1))
	{
		m_invenItem.GetItem(Index, InvenItemInfo);
		bHasItem = true;
	}
	Index = m_questItem.FindItem(Id);
	if((Index > -1))
	{
		m_questItem.GetItem(Index, InvenItemInfo);
		bHasItem = true;
	}
	i = 0;
	while((i < 37))
	{
		if(onlyUseClassID)
		{
			Index = m_equipItem[i].FindItemByClassID(Id);
		}
		else
		{
			Index = m_equipItem[i].FindItem(Id);
		}
		if((Index > -1))
		{
			m_equipItem[i].GetItem(Index, tempOutItemInfo);
			switch(i)
			{
				case 7:
					m_equipItem[5].GetItem(0, tmpItemInfo);
					break;
				case 3:
					m_equipItem[2].GetItem(0, tmpItemInfo);
					break;
				default:
					break;
			}
			if((tempOutItemInfo.Id.ServerID == tmpItemInfo.Id.ServerID))
			{
				i++;
				continue;
			}
			InvenItemInfo = tempOutItemInfo;
			bHasItem = true;
			break;
		}
		i++;
	}
	return bHasItem;
}

function INT64 getItemCountByClassID(int ClassID)
{
	local int i, ItemNum;
	local INT64 totalCount;
	local ItemInfo tempOutItemInfo, tmpItemInfo, Info;
	local ItemID Id;

	Id.ClassID = ClassID;
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(Id, Info);
	if(IsStackableItem(Info.ConsumeType))
	{
		if(GetInventoryItemInfo(Id, tempOutItemInfo, true))
		{
			return tempOutItemInfo.ItemNum;
		}
	}
	else
	{
		totalCount = getItemWindowCountByClassID(ClassID, m_invenItem);
		totalCount = (totalCount + getItemWindowCountByClassID(ClassID, m_questItem));
		i = 0;
		while((i < 37))
		{
			ItemNum = m_equipItem[i].GetItemNum();
			if((ItemNum == 0))
			{
				i++;
				continue;
			}
			m_equipItem[i].GetItem(0, tempOutItemInfo);
			switch(i)
			{
				case 7:
					m_equipItem[5].GetItem(0, tmpItemInfo);
					break;
				case 3:
					m_equipItem[2].GetItem(0, tmpItemInfo);
					break;
				default:
					break;
			}
			if((tempOutItemInfo.Id.ServerID != tmpItemInfo.Id.ServerID))
			{
				totalCount = (totalCount + getItemWindowCountByClassID(ClassID, m_equipItem[i]));
			}
			i++;
		}
	}
	return totalCount;
}

function INT64 getItemWindowCountByClassID(int ClassID, ItemWindowHandle targetItemWindow)
{
	local int i, Cnt, Index, totalItemNum;
	local ItemInfo tmInfo, tempOutItemInfo, Info;
	local ItemID Id;

	Id.ClassID = ClassID;
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(Id, Info);
	if(IsStackableItem(Info.ConsumeType))
	{
		Index = m_invenItem.FindItemByClassID(Id);
		if(GetInventoryItemInfo(Id, tempOutItemInfo, true))
		{
			return tempOutItemInfo.ItemNum;
		}
	}
	totalItemNum = targetItemWindow.GetItemNum();
	i = 0;
	while((i < totalItemNum))
	{
		targetItemWindow.GetItem(i, tmInfo);
		if((tmInfo.Id.ClassID == ClassID))
		{
			Cnt++;
		}
		i++;
	}
	return INT64(Cnt);
}

function array<ItemInfo> getInventoryAllItemArray(optional bool bExceptionEquipItem)
{
	local int Index;
	local array<ItemInfo> itemarray, totalItemArray;

	Class'NWindow.UIDATA_INVENTORY'.static.GetAllInvenItem(totalItemArray);
	Index = 0;
	while((Index < totalItemArray.Length))
	{
		if((totalItemArray[Index].Id.ClassID <= 0))
		{
			Index++;
			continue;
		}
		itemarray[itemarray.Length] = totalItemArray[Index];
		Index++;
	}
	if((bExceptionEquipItem == false))
	{
		itemarray = L2Util(GetScript("L2Util")).PushItemInfoArray(itemarray, getInventoryEquipItemArray());
	}
	return itemarray;
}

function array<ItemInfo> getInventoryEquipItemArray()
{
	local int i, j;
	local bool isSameItem;
	local array<ItemInfo> itemarray;
	local ItemInfo InvenItemInfo;

	m_equipItem[6].GetItem(0, InvenItemInfo);
	if(IsValidItemID(InvenItemInfo.Id))
	{
		itemarray.Length = 1;
		itemarray[0] = InvenItemInfo;
	}
	i = 0;
	while((i < 37))
	{
		ClearItemID(InvenItemInfo.Id);
		m_equipItem[i].GetItem(0, InvenItemInfo);
		if(!IsValidItemID(InvenItemInfo.Id))
		{
			i++;
			continue;
		}
		isSameItem = false;
		j = 0;
		while((j < itemarray.Length))
		{
			if(IsSameServerID(itemarray[j].Id, InvenItemInfo.Id))
			{
				isSameItem = true;
				j++;
				continue;
			}
			j++;
		}
		if(!isSameItem)
		{
			itemarray.Length = (itemarray.Length + 1);
			itemarray[(itemarray.Length - 1)] = InvenItemInfo;
		}
		i++;
	}
	return itemarray;
}

function GetEquipedListByIdx(int idx, out array<ItemInfo> infos)
{
	local ItemInfo Info;

	if((m_equipItem[idx].GetItemNum() > 0))
	{
		m_equipItem[idx].GetItem(0, Info);
		infos.Length = (infos.Length + 1);
		infos[(infos.Length - 1)] = Info;
	}
	return;
}

function int GetMyInventoryLimit()
{
	return m_MaxInvenCount;
}

function int GetQuestItemInventoryLimit()
{
	return m_MaxQuestItemInvenCount;
}

function array<ItemInfo> getInventoryEnSoulExtractEnableItemArray()
{
	local int i, ItemNum, Index;
	local array<ItemInfo> itemarray;
	local ItemInfo InvenItemInfo;

	ItemNum = m_invenItem.GetItemNum();
	Index = 0;
	while((Index < ItemNum))
	{
		m_invenItem.GetItem(Index, InvenItemInfo);
		if((InvenItemInfo.Id.ClassID <= 0))
		{
			Index++;
			continue;
		}
		if(isDamagedItem(InvenItemInfo))
		{
			Index++;
			continue;
		}
		if((((InvenItemInfo.ItemType == 0) || (InvenItemInfo.ItemType == 1)) || (InvenItemInfo.ItemType == 2)))
		{
		}
		else
		{
			Index++;
			continue;
		}
		if(InvenItemInfo.bSecurityLock)
		{
			Index++;
			continue;
		}
		if(hasEnsoulOption(InvenItemInfo))
		{
			itemarray.Length = (itemarray.Length + 1);
			itemarray[(itemarray.Length - 1)] = InvenItemInfo;
		}
		Index++;
	}
	i = 0;
	while((i < 37))
	{
		ItemNum = m_equipItem[i].GetItemNum();
		Index = 0;
		while((Index < ItemNum))
		{
			m_equipItem[i].GetItem(Index, InvenItemInfo);
			if((7 == i))
			{
				Index++;
				continue;
			}
			if((InvenItemInfo.Id.ClassID <= 0))
			{
				Index++;
				continue;
			}
			if(isDamagedItem(InvenItemInfo))
			{
				Index++;
				continue;
			}
			if((((InvenItemInfo.ItemType == 0) || (InvenItemInfo.ItemType == 1)) || (InvenItemInfo.ItemType == 2)))
			{
			}
			else
			{
				Index++;
				continue;
			}
			if(hasEnsoulOption(InvenItemInfo))
			{
				itemarray.Length = (itemarray.Length + 1);
				itemarray[(itemarray.Length - 1)] = InvenItemInfo;
			}
			Index++;
		}
		i++;
	}
	return itemarray;
}

function array<ItemInfo> getInventoryEnSoulEnableItemArray()
{
	local int i, ItemNum, Index;
	local array<ItemInfo> itemarray;
	local ItemInfo InvenItemInfo;
	local int enSoulNormalCount, enSoulBmCount;

	ItemNum = m_invenItem.GetItemNum();
	Index = 0;
	while((Index < ItemNum))
	{
		m_invenItem.GetItem(Index, InvenItemInfo);
		if((InvenItemInfo.Id.ClassID <= 0))
		{
			Index++;
			continue;
		}
		if(isDamagedItem(InvenItemInfo))
		{
			Index++;
			continue;
		}
		if((((InvenItemInfo.ItemType == 0) || (InvenItemInfo.ItemType == 1)) || (InvenItemInfo.ItemType == 2)))
		{
		}
		else
		{
			Index++;
			continue;
		}
		if(InvenItemInfo.bSecurityLock)
		{
			Index++;
			continue;
		}
		enSoulNormalCount = Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulSlotCount(InvenItemInfo.Id, 1);
		enSoulBmCount = Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulSlotCount(InvenItemInfo.Id, 2);
		if(((enSoulNormalCount > 0) || (enSoulBmCount > 0)))
		{
			itemarray.Length = (itemarray.Length + 1);
			itemarray[(itemarray.Length - 1)] = InvenItemInfo;
		}
		Index++;
	}
	i = 0;
	while((i < 37))
	{
		ItemNum = m_equipItem[i].GetItemNum();
		Index = 0;
		while((Index < ItemNum))
		{
			m_equipItem[i].GetItem(Index, InvenItemInfo);
			if((7 == i))
			{
				Index++;
				continue;
			}
			if((InvenItemInfo.Id.ClassID <= 0))
			{
				Index++;
				continue;
			}
			if(isDamagedItem(InvenItemInfo))
			{
				Index++;
				continue;
			}
			if((((InvenItemInfo.ItemType == 0) || (InvenItemInfo.ItemType == 1)) || (InvenItemInfo.ItemType == 2)))
			{
			}
			else
			{
				Index++;
				continue;
			}
			if(InvenItemInfo.bSecurityLock)
			{
				Index++;
				continue;
			}
			enSoulNormalCount = Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulSlotCount(InvenItemInfo.Id, 1);
			enSoulBmCount = Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulSlotCount(InvenItemInfo.Id, 2);
			if(((enSoulNormalCount > 0) || (enSoulBmCount > 0)))
			{
				itemarray.Length = (itemarray.Length + 1);
				itemarray[(itemarray.Length - 1)] = InvenItemInfo;
			}
			Index++;
		}
		i++;
	}
	return itemarray;
}

function array<ItemInfo> getInventoryEnSoulStoneArray(int nItemType)
{
	local int ItemNum, Index;
	local array<ItemInfo> itemarray;
	local ItemInfo InvenItemInfo;

	ItemNum = m_invenItem.GetItemNum();
	Index = 0;
	while((Index < ItemNum))
	{
		m_invenItem.GetItem(Index, InvenItemInfo);
		if(((InvenItemInfo.EtcItemType == 62) && (Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulStoneType(InvenItemInfo.Id.ClassID) == nItemType)))
		{
			itemarray.Length = (itemarray.Length + 1);
			itemarray[(itemarray.Length - 1)] = InvenItemInfo;
		}
		Index++;
	}
	return itemarray;
}

function SortQuestItem()
{
	local int i, j, InvenLimit;
	local ItemInfo item, temp;
	local int numQuest;
	local array<ItemInfo> QuestList;

	InvenLimit = m_questItem.GetItemNum();
	i = 0;
	while((i < InvenLimit))
	{
		m_questItem.GetItem(i, item);
		if(!IsValidItemID(item.Id))
		{
			i++;
			continue;
		}
		QuestList[numQuest] = item;
		numQuest = (numQuest + 1);
		i++;
	}
	m_questItem.Clear();
	ItemboxUpdate(m_questItem, GetQuestItemInventoryLimit());
	i = 0;
	while((i < numQuest))
	{
		j = i;
		while((j < numQuest))
		{
			if((QuestList[i].Id.ServerID < QuestList[j].Id.ServerID))
			{
				temp = QuestList[i];
				QuestList[i] = QuestList[j];
				QuestList[j] = temp;
			}
			++j;
		}
		i++;
	}
	i = 0;
	while((i < numQuest))
	{
		m_questItem.SetItem(i, QuestList[i]);
		++i;
	}
	return;
}

function UpdateTalismanSlotActivation()
{
	local int i, Count;
	local UserInfo User;

	if(GetPlayerInfo(User))
	{
		Count = Max(0, User.nTalismanNum);
		i = 0;
		while((i < Count))
		{
			m_Talisman_Disable[i].HideWindow();
			m_equipItem[(17 + i)].EnableWindow();
			i++;
		}
		i = Count;
		while((i < 6))
		{
			m_Talisman_Disable[i].ShowWindow();
			m_equipItem[(17 + i)].DisableWindow();
			i++;
		}
	}
	return;
}

function UpdateAgathionSlotActivation()
{
	local int Count, i;
	local UserInfo User;

	if(GetPlayerInfo(User))
	{
		if((User.nAgathionMainNum > 0))
		{
			m_Agathion_Disable[0].HideWindow();
			m_equipItem[32].EnableWindow();
		}
		else
		{
			m_Agathion_Disable[0].ShowWindow();
			m_equipItem[32].DisableWindow();
		}
		Count = Max(0, User.nAgathionSubNum);
		i = 1;
		while((i < (Count + 1)))
		{
			m_Agathion_Disable[i].HideWindow();
			m_equipItem[(32 + i)].EnableWindow();
			i++;
		}
		i = (Count + 1);
		while((i < 5))
		{
			m_Agathion_Disable[i].ShowWindow();
			m_equipItem[(32 + i)].DisableWindow();
			i++;
		}
	}
	return;
}

function UpdateJewelSlotActivation()
{
	local int Count, i;
	local UserInfo User;

	if(GetPlayerInfo(User))
	{
		Count = Max(0, User.nJewelNum);
		i = 0;
		while((i < Count))
		{
			m_Jewel_Disable[i].HideWindow();
			m_equipItem[(26 + i)].EnableWindow();
			i++;
		}
		i = Count;
		while((i < 6))
		{
			m_Jewel_Disable[i].ShowWindow();
			m_equipItem[(26 + i)].DisableWindow();
			i++;
		}
	}
	return;
}

function HandleUpdateUserInfo()
{
	if(m_hOwnerWnd.IsShowWindow())
	{
		InvenLimitUpdate();
		CheckShowCrystallizeButton();
	}
	return;
}

function handleChangedSubjob(string param)
{
	ParseInt(param, "SubjobClassID_0", mainClass);
	return;
}

function handleNotifySubjob(string param)
{
	ParseInt(param, "SubjobClassID_0", mainClass);
	return;
}

function CheckShowCrystallizeButton()
{
	if(Class'NWindow.UIDATA_PLAYER'.static.HasCrystallizeAbility())
	{
		if((m_hBtnCrystallize.IsShowWindow() == false))
		{
			m_hBtnCrystallize.ShowWindow();
		}
	}
	else if((m_hBtnCrystallize.IsShowWindow() == true))
	{
		m_hBtnCrystallize.HideWindow();
	}
	return;
}

function ReceiveHairAccessoryPriority(string param)
{
	ParseInt(param, "priority", bShowhairAccessory);
	SetHandleHairAccessory();
	return;
}

function SetHandleHairAccessory()
{
	ViewHairButton.HideWindow();
	ViewAccessoryButton.HideWindow();
	if((bShowhairAccessory == 0))
	{
		ViewHairButton.ShowWindow();
	}
	else if((bShowhairAccessory == 1))
	{
		ViewAccessoryButton.ShowWindow();
	}
	return;
}

function InitScrollBar()
{
	return;
}

function setBottomButtonPostion(out int Num, ButtonHandle tmpBottomButton)
{
	local int StartX, btnW;
	local float ratio;

	ratio = GetScaleRatio();
	StartX = 226;
	btnW = (32 + 8);
	tmpBottomButton.SetAnchor(tmpBottomButton.GetParentWindowHandle().m_WindowNameWithFullPath, "BottomLeft", "BottomLeft", (StartX + (Num * btnW)), -12);
	tmpBottomButton.ShowWindow();
	++Num;
	return;
}

function checkClassicForm()
{
	m_EquipWindow.HideWindow();
	SetEquipWindowHandle();
	SetHennaWindows();
	SetHandles();
	m_EquipWindow.ShowWindow();
	SwitchEquipBox(25);
	return;
}

function InitTabIcon()
{
	TabIconDeSelect(GetTabIconName(1));
	TabIconDeSelect(GetTabIconName(2));
	TabIconDeSelect(GetTabIconName(3));
	TabIconDeSelect(GetTabIconName(4));
	TabIconDeSelect(GetTabIconName(5));
	return;
}

function SetIconOnSelectTabOrder()
{
	if((preTabOrder != 0))
	{
		TabIconDeSelect(GetTabIconName(preTabOrder));
	}
	preTabOrder = m_invenTab.GetTopIndex();
	if((preTabOrder != 0))
	{
		TabIconSelect(GetTabIconName(preTabOrder));
	}
	return;
}

function string GetTabIconName(int ORDER)
{
	switch(ORDER)
	{
		case 1:
			return (m_hOwnerWnd.m_WindowNameWithFullPath $ ".Tab_Equip_");
		case 2:
			return (m_hOwnerWnd.m_WindowNameWithFullPath $ ".Tab_Consume_");
		case 3:
			return (m_hOwnerWnd.m_WindowNameWithFullPath $ ".Tab_ETC_");
		case 4:
			return (m_hOwnerWnd.m_WindowNameWithFullPath $ ".Tab_Periodic_");
		case 5:
			return (m_hOwnerWnd.m_WindowNameWithFullPath $ ".Tab_Quest_");
		default:
	}
}

function TabIconSelect(string IconName)
{
	GetTextureHandle((IconName $ "tex")).HideWindow();
	GetTextureHandle((IconName $ "Select_tex")).ShowWindow();
	return;
}

function TabIconDeSelect(string IconName)
{
	GetTextureHandle((IconName $ "tex")).ShowWindow();
	GetTextureHandle((IconName $ "Select_tex")).HideWindow();
	return;
}

function setBottomButtonPositions()
{
	local float ratio;
	local int UseClassicJewelEnchantBtn, i;

	GetINIBool("Localize", "UseClassicJewelEnchantBtn", UseClassicJewelEnchantBtn, "L2.ini");
	if((IsAdenServer() == false))
	{
		setBottomButtonPostion(i, AdenacalculateButton);
	}
	else
	{
		AdenacalculateButton.HideWindow();
	}
	if((UseClassicJewelEnchantBtn == 1))
	{
		setBottomButtonPostion(i, EnchantJewelButton);
	}
	else
	{
		EnchantJewelButton.HideWindow();
	}
	if((IsAdenServer() == true))
	{
		setBottomButtonPostion(i, ItemConversionButton);
	}
	else
	{
		ItemConversionButton.HideWindow();
	}
	if((IsCollectionServer() == true))
	{
		setBottomButtonPostion(i, CollectionBtn);
	}
	else
	{
		CollectionBtn.HideWindow();
	}
	setBottomButtonPostion(i, ItemAutoPeelBtn);
	setBottomButtonPostion(i, m_hBtnCrystallize);
	return;
}

function SetAdenaText()
{
	local string Adenastring;

	Adenastring = MakeCostString(string(GetAdena()));
	m_hAdenaTextBox.SetText(Adenastring);
	m_hAdenaTextBox.SetTooltipString(ConvertNumToText(string(GetAdena())));
	return;
}

function SetItemCount()
{
	local int limit, Count;
	local Color countColor;

	if((m_selectedItemTab == 5))
	{
		countColor.R = 176;
		countColor.G = 155;
		countColor.B = 121;
		countColor.A = 255;
		Count = m_QuestInvenCount;
		limit = GetQuestItemInventoryLimit();
	}
	else
	{
		countColor.R = 176;
		countColor.G = 155;
		countColor.B = 121;
		countColor.A = 255;
		Count = (m_NormalInvenCount + EquipNormalItemGetItemNum());
		limit = GetMyInventoryLimit();
	}
	m_itemCount.SetTextColor(countColor);
	m_itemCount.SetText((((("(" $ string(Count)) $ "/") $ string(limit)) $ ")"));
	pInventoryItemCount = (limit - Count);
	UpdateInvenExpandSkillBtn();
	return;
}

function InvenLimitUpdate()
{
	ItemboxUpdate(m_invenItem, GetMyInventoryLimit());
	ItemboxUpdate(m_invenItem_1, GetMyInventoryLimit());
	ItemboxUpdate(m_invenItem_2, GetMyInventoryLimit());
	ItemboxUpdate(m_invenItem_3, GetMyInventoryLimit());
	ItemboxUpdate(m_invenItem_4, GetMyInventoryLimit());
	ItemboxUpdate(m_questItem, GetQuestItemInventoryLimit());
	return;
}

function ItemboxUpdate(ItemWindowHandle hItemWnd, int iInvenLimit)
{
	local int iCount, iItemCount, iAddedCount, iDeletedCount;
	local ItemInfo kClearItem, kCurItem;

	kClearItem.IconName = "L2ui_ct1.emptyBtn";
	ClearItemID(kClearItem.Id);
	iItemCount = hItemWnd.GetItemNum();
	if((iItemCount < iInvenLimit))
	{
		iAddedCount = (iInvenLimit - iItemCount);
		iCount = 0;
		while((iCount < iAddedCount))
		{
			hItemWnd.AddItem(kClearItem);
			iCount++;
		}
	}
	else if((iItemCount > iInvenLimit))
	{
		iDeletedCount = (iItemCount - iInvenLimit);
		iCount = (hItemWnd.GetItemNum() - 1);
		while((iCount >= 0))
		{
			if((iDeletedCount > 0))
			{
				hItemWnd.GetItem(iCount, kCurItem);
				if(!IsValidItemID(kCurItem.Id))
				{
					hItemWnd.DeleteItem(iCount);
					iDeletedCount--;
				}
				if((iDeletedCount <= 0))
				{
					break;
				}
			}
			iCount--;
		}
	}
	return;
}

function HandleSetMaxCount(string param)
{
	local int ExtraBeltCount;

	ParseInt(param, "Inventory", m_MaxInvenCount);
	ParseInt(param, "questItem", m_MaxQuestItemInvenCount);
	ParseInt(param, "extrabelt", ExtraBeltCount);
	m_invenItem.SetExpandItemNum(0, ExtraBeltCount);
	InvenLimitUpdate();
	SetItemCount();
	return;
}

function HandleToggleWindow()
{
	if(m_hOwnerWnd.IsShowWindow())
	{
		m_hOwnerWnd.HideWindow();
		PlayConsoleSound(IFST_INVENWND_CLOSE);
	}
	else if(bInitedCompleted)
	{
		if((RefineryWnd(GetScript("RefineryWnd")).isPossableInventoryShow() == false))
		{
			RefineryWnd(GetScript("RefineryWnd")).OnClickButton("exitbutton");
			RefineryWnd(GetScript("RefineryWnd")).setHideAndInventoryShow(true);
		}
		else
		{
			ShowWindowWithFocus("InventoryWnd");
			PlayConsoleSound(IFST_INVENWND_OPEN);
		}
	}
	else
	{
		bRequestItemList = true;
		RequestItemList();
	}
	return;
}

function HandleOpenWindow(string param)
{
	local int Open;

	if((cur_state == "BEAUTYSHOPSTATE"))
	{
		return;
	}
	ParseInt(param, "Open", Open);
	if((Open == 0))
	{
		return;
	}
	OpenWindow();
	return;
}

function OpenWindow()
{
	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetFocus();
	return;
}

function HandleHideWindow()
{
	DialogHide();
	HideWindow(m_hOwnerWnd.m_WindowNameWithFullPath);
	return;
}

function handleEnchantJewelButton()
{
	Class'InterfaceClassic.ItemJewelEnchantWnd'.static.Inst().ToggleShowWindow();
	return;
}

function toogleCharacterViewPort(bool bShow)
{
	if(bShow)
	{
		SetINIInt(m_hOwnerWnd.m_WindowNameWithFullPath, "e", 0, "WindowsInfo.ini");
		m_InventoryWndCharacterView.ShowWindow();
		m_CharacterViewOpen_BTN.HideWindow();
		m_CharacterViewClose_BTN.ShowWindow();
	}
	else
	{
		SetINIInt(m_hOwnerWnd.m_WindowNameWithFullPath, "e", 1, "WindowsInfo.ini");
		m_InventoryWndCharacterView.HideWindow();
		m_CharacterViewOpen_BTN.ShowWindow();
		m_CharacterViewClose_BTN.HideWindow();
	}
	return;
}

function ShowHideCharacterViewPortOnShow()
{
	local int E;

	GetINIInt(m_hOwnerWnd.m_WindowNameWithFullPath, "e", E, "WindowsInfo.ini");
	toogleCharacterViewPort((E == 0));
	return;
}

function HandleChkSwitchEquipBox(int idx, ItemInfo newInfo, optional bool bSwitchExpandEquipBox)
{
	switch(idx)
	{
		case 16:
			EquipItem_RBracelet_Button.HideWindow();
			break;
		case 15:
			EquipItem_LBracelet_Button.HideWindow();
			break;
		case 25:
			EquipItem_Brooch_Button.HideWindow();
			break;
		case -1:
			break;
		default:
			break;
	}
	if(bSwitchExpandEquipBox)
	{
		SwitchEquipBox(idx);
	}
	return;
}

function SwitchEquipBox(int idx)
{
	if((idx == -1))
	{
		return;
	}
	JewelWindow.HideWindow();
	AgathionWindow.HideWindow();
	equipItem_Henna_Window.HideWindow();
	SetHandleHairAccessory();
	Debug("SwitchEquipBox");
	switch(idx)
	{
		case 16:
			m_TalismanAllow.SetAnchor(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ m_equipItem[idx].GetWindowName()), "TopLeft", "TopLeft", -2, -11);
			break;
		case 15:
			AgathionWindow.ShowWindow();
			AgathionWindow.SetFocus();
			m_TalismanAllow.SetAnchor(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ m_equipItem[idx].GetWindowName()), "TopLeft", "TopLeft", -2, -11);
			break;
		case 25:
			JewelWindow.ShowWindow();
			JewelWindow.SetFocus();
			m_TalismanAllow.SetAnchor(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ m_equipItem[idx].GetWindowName()), "TopLeft", "TopLeft", -2, -11);
			break;
		case 99:
			equipItem_Henna_Window.ShowWindow();
			equipItem_Henna_Window.SetFocus();
			m_TalismanAllow.SetAnchor((m_hOwnerWnd.m_WindowNameWithFullPath $ ".equipItem_Henna_Button"), "TopLeft", "TopLeft", -2, -10);
			break;
		default:
			break;
	}
	if((m_SelectedExpandEquipIdx != idx))
	{
		m_SelectedExpandEquipIdxPrev = m_SelectedExpandEquipIdx;
	}
	m_SelectedExpandEquipIdx = idx;
	return;
}

function handleNewItem(ItemInfo addedItemInfo)
{
	local int Index;

	if((addedItemInfo.Id.ClassID == 57))
	{
		return;
	}
	if(m_hOwnerWnd.IsShowWindow())
	{
		setNewItem(addedItemInfo);
	}
	Index = findNewItem(addedItemInfo.Id);
	if((Index == -1))
	{
		Index = newItems.Length;
		newItems.Length = (newItems.Length + 1);
		newItems[Index] = addedItemInfo;
	}
	else if((newItems[Index].ItemNum < addedItemInfo.ItemNum))
	{
		newItems[Index] = addedItemInfo;
	}
	return;
}

function setNewItem(ItemInfo NewItem)
{
	SetNewAcquiredUtil(NewItem, true);
	return;
}

function SetNewAcquiredUtil(ItemInfo iInfo, bool On)
{
	local int Index;
	local ItemWindowHandle tmpInven, detailItemWindow;

	if(IsQuestItem(iInfo))
	{
		tmpInven = m_questItem;
		Index = tmpInven.FindItem(iInfo.Id);
	}
	else
	{
		detailItemWindow = GetItemWindowHandleByItemType(iInfo);
		Index = detailItemWindow.FindItem(iInfo.Id);
		if((Index != -1))
		{
			detailItemWindow.SetNewlyAcquired(Index, On);
			if(Class'InterfaceClassic.L2UIInventory'.static.Inst()._IsPeroidicItem(iInfo))
			{
				Index = m_invenItem_4.FindItem(iInfo.Id);
				m_invenItem_4.SetNewlyAcquired(Index, On);
			}
		}
		tmpInven = m_invenItem;
		Index = tmpInven.FindItem(iInfo.Id);
	}
	if((Index != -1))
	{
		tmpInven.SetNewlyAcquired(Index, On);
	}
	return;
}

function handleNewItemOnShow()
{
	local int i;

	i = 0;
	while((i < newItems.Length))
	{
		setNewItem(newItems[i]);
		i++;
	}
	return;
}

function handleNewItemOnHide()
{
	local int i;

	i = 0;
	while((i < newItems.Length))
	{
		delNewItem(newItems[i]);
		i++;
	}
	newItems.Length = 0;
	return;
}

function delNewItem(ItemInfo DelItem)
{
	SetNewAcquiredUtil(DelItem, false);
	return;
}

function int findNewItem(ItemID Id)
{
	local int i;

	i = 0;
	while((i < newItems.Length))
	{
		if((newItems[i].Id == Id))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function showItemUpdateEffect(string param)
{
	local int Index, i;
	local ItemInfo Info, NewItem, tmpItem;
	local ItemWindowHandle targetItemWnd;
	local string Type, strParam;

	ParseString(param, "type", Type);
	ParamToItemInfo(param, NewItem);
	i = 0;
	while((i < 37))
	{
		m_equipItem[i].GetItem(0, tmpItem);
		if(IsSameServerID(tmpItem.Id, NewItem.Id))
		{
			return;
		}
		i++;
	}
	if((Type == "delete"))
	{
		return;
	}
	if(IsEquipItem(NewItem))
	{
		return;
	}
	else if(IsQuestItem(NewItem))
	{
		targetItemWnd = m_questItem;
	}
	else
	{
		targetItemWnd = m_invenItem;
	}
	Index = targetItemWnd.FindItem(NewItem.Id);
	targetItemWnd.GetItem(Index, Info);
	if((Info.ItemNum < NewItem.ItemNum))
	{
		strParam = ("iconName=" $ NewItem.IconName);
		strParam = ((strParam @ "itemNum=") $ string((NewItem.ItemNum - Info.ItemNum)));
		getInstanceL2Util().showGfxScreenMessage(strParam, 1);
	}
	return;
}

function CheckCollectionEnableItem(ItemInfo iInfo)
{
	local CollectionSystem collectionSystemScript;

	collectionSystemScript = CollectionSystem(GetScript("collectionSystem"));
	lasetSelectedItemInfo = iInfo;
	if(collectionSystemScript.API_IsCollectionRegistEnableItem(lasetSelectedItemInfo.Id, -1, -1))
	{
		CollectionPointAni.Stop();
		CollectionPointAni.Pause();
		CollectionPointAni.SetLoopCount(-1);
		CollectionPointAni.ShowWindow();
		CollectionPointAni.Play();
	}
	else
	{
		CollectionPointAni.Stop();
		CollectionPointAni.Pause();
		CollectionPointAni.HideWindow();
	}
	return;
}

function OpenCollectionSelectedItem()
{
	local CollectionSystem collectionSystemScript;

	collectionSystemScript = CollectionSystem(GetScript("collectionSystem"));
	collectionSystemScript.SetToFindItemInfo(lasetSelectedItemInfo);
	collectionSystemScript.API_C_EX_COLLECTION_OPEN_UI();
	return;
}

function OpenItemAutoPeelWnd(int itemServerID, bool isAllItem)
{
	m_hOwnerWnd.HideWindow();
	ItemAutoPeelWnd(GetScript("ItemAutoPeelWnd")).RegisterItem(itemServerID, isAllItem);
	return;
}

function HandleHair2SlotEnable(string param)
{
	local int Enable;

	ParseInt(param, "Enable", Enable);
	if((Enable != 1))
	{
		Hair2SlotDisable_tex.ShowWindow();
		if(IsAdenServer())
		{
			Hair2SlotDisable_tex.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14104)));
		}
	}
	else
	{
		Hair2SlotDisable_tex.HideWindow();
	}
	return;
}

function CustomTooltip getAgathionTooltip(string Title, string Desc)
{
	local CustomTooltip t;
	local L2Util util;

	util = L2Util(GetScript("L2Util"));
	util.setCustomTooltip(t);
	util.ToopTipInsertText(Title, true, false, COLOR_GRAY);
	util.ToopTipInsertText(Desc, true, true, COLOR_GRAY);
	return util.getCustomToolTip();
}

function bool IsSigil(ItemInfo a_Info)
{
	if((int(byte(a_Info.ArmorType)) == 4))
	{
		return true;
	}
	return false;
}

function INT64 GetAgathionSlotBitType(string keyword)
{
	switch(keyword)
	{
		case "n":
			return INT64(16);
		case "1":
			return INT64(32);
		case "2":
			return INT64(64);
		case "3":
			return INT64(128);
		case "4":
			return INT64(256);
		default:
			return INT64(0);
	}
}

function ItemWindowHandle getItemWindowHandleBystrTarget(string strTarget)
{
	switch(strTarget)
	{
		case "InventoryItem":
			return m_invenItem;
		case "InventoryItem_1":
			return m_invenItem_1;
		case "InventoryItem_2":
			return m_invenItem_2;
		case "InventoryItem_3":
			return m_invenItem_3;
		case "InventoryItem_4":
			return m_invenItem_4;
		default:
	}
}

function ItemWindowHandle GetItemWindowHandleByItemType(ItemInfo iInfo)
{
	if(!IsValidItemID(iInfo.Id))
	{
		return none;
	}
	switch(Class'NWindow.UIDATA_ITEM'.static.GetInventoryType(iInfo.Id.ClassID))
	{
		case EIIT_EQUIPMENT:
			return m_invenItem_1;
		case EIIT_CONSUMABLE:
		case EIIT_MATERIAL:
			return m_invenItem_2;
		case EIIT_ETC:
		case EIIT_NONE:
			return m_invenItem_3;
		case EIIT_QUEST:
			return m_questItem;
		default:
			return none;
	}
}

function DelegateOnClickButton(string parentWndName, string strName, int Index)
{
	_RQ_C_EX_DUAL_INVENTORY_SWAP(Index);
	return;
}

function _ResetbRequestHennaOnShow()
{
	bRequestHennaOnShow = true;
	return;
}

function string GetHennaPotenString(int potenID, int activeStep)
{
	local DyePotentialUIData dyePotentialData;
	local SkillInfo SkillInfo;

	Class'NWindow.UIDATA_HENNA'.static.GetDyePotentialData(potenID, dyePotentialData);
	GetSkillInfo(dyePotentialData.SkillID, activeStep, 0, SkillInfo);
	return ((dyePotentialData.EffectName @ SkillInfo.SkillDesc) @ GetSystemString(3351));
}

function HandleChangeHennaDye(int hennaItemIndex)
{
	local int X, Y;

	if(((hennaItemIndex == 3) && hennas_Disable4.IsShowWindow()))
	{
		return;
	}
	API_GetClientCursorPos(X, Y);
	Class'InterfaceClassic.HennaEnchantWnd'.static.Inst()._ShowContextMenu(hennaItemIndex, X, Y);
	Class'InterfaceClassic.UIControlContextMenu'.static.GetInstance().Owner = string(self);
	return;
}

function _Handle_S_EX_NEW_HENNA_POTEN_SELECT(UIPacket._S_EX_NEW_HENNA_POTEN_SELECT packet)
{
	local int Index;
	local ItemInfo iInfo;

	if((packet.cSuccess > 0))
	{
		Index = (packet.cSlotID - 1);
		iInfo.Name = (GetSystemString(14826) $ string((Index + 1)));
		iInfo.AdditionalName = MakeFullSystemMsg(GetSystemMessage(13976), string(packet.nActiveStep));
		iInfo.Description = _GetEffectString(Index);
		iInfo.IconName = getPotenIconColor(packet.nActiveStep);
		hennaItems[Index].Clear();
		hennaItems[Index].AddItem(iInfo);
	}
	return;
}

function string getPotenIconColor(int nActiveStep)
{
	if((nActiveStep == 0))
	{
		return "L2UI_NewTex.InventoryWnd.Icon_Potential00";
	}
	else if(((nActiveStep >= 1) && (nActiveStep <= 10)))
	{
		return "L2UI_NewTex.InventoryWnd.Icon_Potential03";
	}
	else if(((nActiveStep >= 11) && (nActiveStep <= 20)))
	{
		return "L2UI_NewTex.InventoryWnd.Icon_Potential04";
	}
	else if(((nActiveStep >= 21) && (nActiveStep <= 30)))
	{
		return "L2UI_NewTex.InventoryWnd.Icon_Potential02";
	}
	return "L2UI_NewTex.InventoryWnd.Icon_Potential01";
}

function _Handle_S_EX_NEW_HENNA_LIST(UIPacket._S_EX_NEW_HENNA_LIST henna_list_packet)
{
	local int i;
	local ItemInfo iInfo;
	local bool bUseHenna;

	Debug("_Handle_S_EX_NEW_HENNA_LIST");
	i = 0;
	while((i < 4))
	{
		hennaItems[i].Clear();
		i++;
	}
	if((0 == henna_list_packet.hennaInfoList[3].cActive))
	{
		hennas_Disable4.ShowWindow();
	}
	else
	{
		hennas_Disable4.HideWindow();
	}
	i = 0;
	while((i < henna_list_packet.hennaInfoList.Length))
	{
		if((henna_list_packet.hennaInfoList[i].cActive > 0))
		{
			iInfo.Name = (GetSystemString(14826) $ string((i + 1)));
			iInfo.AdditionalName = MakeFullSystemMsg(GetSystemMessage(13976), string(henna_list_packet.hennaInfoList[i].nActiveStep));
			iInfo.Description = _GetEffectString(i);
			iInfo.IconName = getPotenIconColor(henna_list_packet.hennaInfoList[i].nActiveStep);
			hennaItems[i].Clear();
			hennaItems[i].AddItem(iInfo);
			if((henna_list_packet.hennaInfoList[i].nActiveStep > 0))
			{
				bUseHenna = true;
			}
		}
		i++;
	}
	if(bUseHenna)
	{
		HennaBtn_Texture.SetTexture("L2UI_NewTex.InventoryWnd.PotentialBtn");
	}
	else
	{
		HennaBtn_Texture.SetTexture("L2UI_NewTex.InventoryWnd.PotentialBtn_Disable");
	}
	return;
}

function string _GetEffectString(int Index)
{
	local array<string> effectNames;
	local int selectedNum;

	Class'InterfaceClassic.HennaEnchantWnd'.static.Inst()._GetEffectStrings(Index, effectNames, selectedNum);
	if((selectedNum > -1))
	{
		return effectNames[selectedNum];
	}
	return "";
}

function _RQ_C_EX_DUAL_INVENTORY_SWAP(int Index)
{
	local array<byte> stream;
	local UIPacket._C_EX_DUAL_INVENTORY_SWAP packet;

	if((bRequestedDualInventorySwap || SubGroupButtonAsset.bOnDelayTime))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13799));
		return;
	}
	if((bUnStableSwapping || (Index == -1)))
	{
		packet.cSwapSlot = _GetSwapSelectButtonIndex();
	}
	else
	{
		packet.cSwapSlot = Index;
	}
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_DUAL_INVENTORY_SWAP(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(824, stream);
	SubGroupButtonAsset._setDelayTime(10000);
	SubGroupButtonAsset._tryDelayClick();
	bRequestedDualInventorySwap = true;
	m_hOwnerWnd.SetTimer(100, 10000);
	HideWindowsAtSwap();
	return;
}

function HideWindowsAtSwap()
{
	GetWindowHandle("ItemJewelEnchantwnd").HideWindow();
	GetWindowHandle("ItemMultiEnchantwnd").HideWindow();
	GetWindowHandle("ItemEnchantWnd").HideWindow();
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ItemUpgrade");
	return;
}

function InitDualToDefaultA()
{
	SubGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(0, true);
	GetTextBoxHandle("HennaEnchantWnd.HennaTitle_txt").SetText(GetSystemString(14284));
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DescriptionMsgWnd")).HideWindow();
	GetWindowHandle("DualInventorySwapBtn").HideWindow();
	bRequestedDualInventorySwap = false;
	m_hOwnerWnd.KillTimer(100);
	return;
}

function Handle_EV_DualInventoryInfo(string param)
{
	local int cActiveSlot, _bStableSwapping, bSuccess;
	local string SetString;

	ParseInt(param, "cActiveSlot", cActiveSlot);
	ParseInt(param, "bSuccess", bSuccess);
	ParseInt(param, "bStableSwapping", _bStableSwapping);
	switch(cActiveSlot)
	{
		case 0:
			SetString = GetSystemString(14274);
			GetTextBoxHandle("HennaEnchantWnd.HennaTitle_txt").SetText(GetSystemString(14284));
			break;
		case 1:
			SetString = GetSystemString(14275);
			GetTextBoxHandle("HennaEnchantWnd.HennaTitle_txt").SetText(GetSystemString(14285));
			break;
		default:
			break;
	}
	bUnStableSwapping = (_bStableSwapping == 0);
	if(bRequestedDualInventorySwap)
	{
		if((bSuccess == 1))
		{
			if(!bUnStableSwapping)
			{
				getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(13797), SetString));
			}
		}
		else
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13798));
		}
	}
	SubGroupButtonAsset._GetGroupButtonsInstance()._setTopOrder(cActiveSlot, true);
	if(bUnStableSwapping)
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DescriptionMsgWnd")).ShowWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DescriptionMsgWnd")).SetFocus();
		GetWindowHandle("DualInventorySwapBtn").ShowWindow();
		getInstanceL2Util().showGfxScreenMessage(GetSystemString(14281));
	}
	else
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DescriptionMsgWnd")).HideWindow();
		GetWindowHandle("DualInventorySwapBtn").HideWindow();
	}
	if(bRequestedDualInventorySwap)
	{
		HennaMenuWnd(GetScript("HennaMenuWnd")).API_C_EX_NEW_HENNA_LIST();
	}
	bRequestedDualInventorySwap = false;
	m_hOwnerWnd.KillTimer(100);
	if(SubGroupButtonAsset.bOnDelayTime)
	{
		SubGroupButtonAsset._setDelayTime(5000);
		SubGroupButtonAsset._tryDelayClick();
	}
	HideWindowsAtSwap();
	BottomBar(GetScript("BottomBar"))._UpdateDualInventoryControls();
	return;
}

function Handle_EV_RequestDualInventorySwap()
{
	_RQ_C_EX_DUAL_INVENTORY_SWAP((_GetSwapSelectButtonIndex() ^ 1));
	return;
}

function int _GetSwapSelectButtonIndex()
{
	return SubGroupButtonAsset._GetGroupButtonsInstance()._getSelectButtonIndex();
}

event OnReceivedCloseUI()
{
	CloseUI();
	return;
}

function ShowContextMenu(ItemInfo iInfo)
{
	local int X, Y;
	local UIControlContextMenu ContextMenu;
	local string itemParam;

	if(!IsValidItemID(iInfo.Id))
	{
		return;
	}
	ContextMenu = Class'InterfaceClassic.UIControlContextMenu'.static.GetInstance();
	ContextMenu.Clear();
	ContextMenu.DelegateOnClickContextMenu = HandleOnClickContextMenu;
	if((((iInfo.ItemType != 0) && (iInfo.ItemType != 1)) && (iInfo.ItemType != 2)))
	{
		return;
	}
	ContextMenu.MenuNew(GetSystemString(1220), 0);
	ContextMenu.MenuNew(GetSystemString(1477), 1);
	if(CanEnsoul(iInfo))
	{
		ContextMenu.MenuNew(GetSystemString(3387), 2);
	}
	ContextMenu.MenuLineAdd();
	if(CanUnRefinery(iInfo))
	{
		ContextMenu.MenuNew(GetSystemString(1479), 3);
	}
	if(CanEnsoulExtract(iInfo))
	{
		ContextMenu.MenuNew(GetSystemString(3490), 4);
	}
	ContextMenu.MenuLineAdd();
	ContextMenu.MenuNew(GetSystemString(443), 5);
	ContextMenu.MenuNew(GetSystemString(491), 6);
	API_GetClientCursorPos(X, Y);
	GetMenuPosition(X, Y);
	ContextMenu.Show(X, Y, string(self));
	ItemInfoToParam(iInfo, itemParam);
	ContextMenu._SetReservedString(itemParam);
	return;
}

function GetMenuPosition(out int X, out int Y)
{
	local int Index;
	local Rect rectWnd;

	Index = m_invenItem.GetIndexAt(X, Y, 0, 0);
	rectWnd = m_invenItem.GetRect();
	X = (((Index / 11) * 18) + rectWnd.nX);
	Y = int(((float(Index) % float((11 * 18))) + float(rectWnd.nY)));
	return;
}

function bool CanEnsoul(ItemInfo iInfo)
{
	local int i;
	local array<ItemInfo> iInfos;

	iInfos = getInventoryEnSoulEnableItemArray();
	i = 0;
	while((i < iInfos.Length))
	{
		if((iInfos[i].Id == iInfo.Id))
		{
			return true;
		}
		i++;
	}
	return false;
}

function bool CanEnsoulExtract(ItemInfo iInfo)
{
	return ToolTip(GetScript("Tooltip")).isEnsoulOption(iInfo);
}

function bool CanUnRefinery(ItemInfo iInfo)
{
	return ToolTip(GetScript("Tooltip")).isRefinery(iInfo);
}

function HandleOnClickContextMenu(int Index)
{
	local ItemInfo iInfo;

	ParamToItemInfo(Class'InterfaceClassic.UIControlContextMenu'.static.GetInstance()._GetReservedString(), iInfo);
	switch(Index)
	{
		case 0:
			ItemEnchantWnd(GetScript("ItemEnchantWnd"))._AddTargetItem(iInfo);
			break;
		case 1:
			RefineryWnd(GetScript("RefineryWnd"))._AddTargetItem(iInfo);
			break;
		case 2:
			GetWindowHandle("EnsoulWnd").ShowWindow();
			EnsoulWnd(GetScript("EnsoulWnd")).InsertWeapon(iInfo);
			break;
		case 3:
			GetWindowHandle("UnrefineryWnd").ShowWindow();
			UnrefineryWnd(GetScript("UnrefineryWnd")).ValidateItem(iInfo);
			break;
		case 4:
			GetWindowHandle("EnsoulExtractWnd").ShowWindow();
			Debug((iInfo.Name @ string(iInfo.Id.ClassID)));
			EnsoulExtractWnd(GetScript("EnsoulExtractWnd")).InsertWeapon(iInfo);
			break;
		case 5:
			UseItemWithItemInfo(iInfo);
			Debug("아이템 사용");  // EN?: Use an item
			break;
		case 6:
			SetItemTextLink(iInfo.Id, GetItemNameAll(iInfo), ToolTip(GetScript("Tooltip"))._GetItemNameColor(iInfo.Id), _ItemNameLen(iInfo), iInfo.Enchanted);
			break;
		default:
			break;
	}
	return;
}

function GetPosByTooltip(out int X, out int Y)
{
	local Rect rectTooltip, rectContextMenu;

	rectTooltip = GetWindowHandle("tooltip").GetRect();
	Debug(((((string(rectTooltip.nX) @ string(rectContextMenu.nWidth)) @ string(rectTooltip.nY)) @ string(rectTooltip.nHeight)) @ string(rectContextMenu.nHeight)));
	X = (rectTooltip.nX - rectContextMenu.nWidth);
	Y = ((rectTooltip.nY + rectTooltip.nHeight) - rectContextMenu.nHeight);
	return;
}

function AddEquipItem(int Index, ItemInfo iInfo)
{
	AddEquipItemWithIWnd(m_equipItem[Index], iInfo);
	return;
}

function AddEquipItemWithIWnd(ItemWindowHandle iWnd, ItemInfo iInfo)
{
	iWnd.AddItem(iInfo);
	ShowEnchantLevelAnimTexture(iWnd);
	return;
}

function DelEquipItem(int Index)
{
	DelEquipItemWithIWnd(m_equipItem[Index]);
	return;
}

function DelEquipItemWithIWnd(ItemWindowHandle iWnd)
{
	iWnd.Clear();
	HideEnchantLevelAnimTexture(iWnd);
	return;
}

function HideAllEnchantLevelAniTextures()
{
	local int i;

	i = 0;
	while((i < 17))
	{
		enchantAnis[i].HideWindow();
		i++;
	}
	return;
}

function int GetIndexEnchantLevelTextureFrame()
{
	local int i;

	i = 0;
	while((i < 17))
	{
		if(enchantAnis[i].IsShowWindow())
		{
			return enchantAnis[i].GetCurrentFrame();
		}
		i++;
	}
	return 1;
}

function ShowEnchantLevelAnimTexture(ItemWindowHandle iWnd)
{
	local AnimTextureHandle aTexture;
	local int lv;
	local string texturePath;

	aTexture = GetInventoryEffectLevelAnimTextureByItemWIndow(iWnd);
	if((aTexture == none))
	{
		return;
	}
	if((iWnd.GetItemNum() < 1))
	{
		aTexture.HideWindow();
		return;
	}
	lv = iWnd.GetInventoryEffectLevel(0);
	if((lv <= 0))
	{
		aTexture.HideWindow();
	}
	else
	{
		texturePath = GetTextureNameInventoryLevel(lv);
		if((texturePath != ""))
		{
			aTexture.SetTexture(GetTextureNameInventoryLevel(lv));
			aTexture.SetLoopCount(-1);
			aTexture.SetCurrentFrame(GetIndexEnchantLevelTextureFrame());
			aTexture.Play();
			aTexture.ShowWindow();
		}
		else
		{
			aTexture.HideWindow();
		}
	}
	return;
}

function HideEnchantLevelAnimTexture(ItemWindowHandle iWnd)
{
	local AnimTextureHandle aTexture;

	aTexture = GetInventoryEffectLevelAnimTextureByItemWIndow(iWnd);
	if((aTexture != none))
	{
		aTexture.HideWindow();
	}
	return;
}

function string GetTextureNameInventoryLevel(int lv)
{
	switch(lv)
	{
		case 1:
			return "L2UI_NewTex.InventoryWnd.InventoryEnchantAni64_Gray0000";
		case 2:
			return "L2UI_NewTex.InventoryWnd.InventoryEnchantAni64_Green0000";
		case 3:
			return "L2UI_NewTex.InventoryWnd.InventoryEnchantAni64_Yellow0000";
		case 4:
			return "L2UI_NewTex.InventoryWnd.InventoryEnchantAni64_Red0000";
		case 5:
			return "L2UI_NewTex.InventoryWnd.InventoryEnchantAni64_Purple0000";
		default:
			return "";
	}
}

function AnimTextureHandle GetInventoryEffectLevelAnimTextureByItemWIndow(ItemWindowHandle iWnd)
{
	local int i, Index;

	i = 0;
	while((i < 17))
	{
		Index = GetEquipItemIndex(i);
		if((m_equipItem[Index] == iWnd))
		{
			return enchantAnis[i];
		}
		i++;
	}
	return none;
}

function AnimTextureHandle GetEnchantAnimTexture(int Index)
{
	local int animTextureIndex;

	animTextureIndex = GetEnchantAnimTextureIndex(Index);
	if((animTextureIndex == -1))
	{
		return none;
	}
	return enchantAnis[animTextureIndex];
}

function int GetEquipItemIndex(int Index)
{
	switch(Index)
	{
		case 0:
			return 0;
		case 1:
			return 1;
		case 2:
			return 2;
		case 3:
			return 3;
		case 4:
			return 4;
		case 5:
			return 5;
		case 6:
			return 6;
		case 7:
			return 7;
		case 8:
			return 8;
		case 9:
			return 9;
		case 10:
			return 10;
		case 11:
			return 11;
		case 12:
			return 12;
		case 13:
			return 13;
		case 14:
			return 14;
		case 15:
			return 23;
		case 16:
			return 24;
		default:
			return -1;
	}
}

function int GetEnchantAnimTextureIndex(int Index)
{
	switch(Index)
	{
		case 0:
			return 0;
		case 1:
			return 1;
		case 2:
			return 2;
		case 3:
			return 3;
		case 4:
			return 4;
		case 5:
			return 5;
		case 6:
			return 6;
		case 7:
			return 7;
		case 8:
			return 8;
		case 9:
			return 9;
		case 10:
			return 10;
		case 11:
			return 11;
		case 12:
			return 12;
		case 13:
			return 13;
		case 14:
			return 14;
		case 23:
			return 15;
		case 24:
			return 16;
		default:
			return -1;
	}
}

function Handle_EV_ResolutionChanged()
{
	SetCurrentScaleSize();
	return;
}

function SetCurrentScaleSize()
{
	local int stepSizeW, stepSizeH, Step, MaxW, minW, MaxH, minH, currentScreenWidth, currentScreenHeight;

	GetCurrentResolution(currentScreenWidth, currentScreenHeight);
	minW = 1280;
	minH = 720;
	MaxW = 2560;
	MaxH = 1440;
	stepSizeW = ((MaxW - minW) / 100);
	stepSizeH = ((MaxH - minH) / 100);
	Step = Min(100, (Step + Max(0, Min(((currentScreenWidth - minW) / stepSizeW), ((currentScreenHeight - minH) / stepSizeH)))));
	Debug(((((((" 스텝 확인 " @ string(Step)) @ string(stepSizeW)) @ string(stepSizeH)) @ string(currentScreenWidth)) $ "*") $ string(currentScreenHeight)));  // EN?: Confirm Steps
	API_ChangeScalableSize(Step);
	return;
}

function HandleScaleBtn()
{
	local int targetSizeType;

	targetSizeType = (sizeType + 1);
	if((targetSizeType == 101))
	{
		targetSizeType = 0;
	}
	Debug(((("HandleScaleBtn" @ string(sizeType)) @ "->") @ string(targetSizeType)));
	API_ChangeScalableSize(targetSizeType);
	OnClickScaleButtonMoveToButtonCenter();
	return;
}

function string GetTextureByCurrentSizeType()
{
	if((sizeType < 37))
	{
		return "L2UI_NewTex.InventoryWnd.Inventory_Scale80_Btn_";
	}
	if((sizeType < 100))
	{
		return "L2UI_NewTex.InventoryWnd.Inventory_Scale100_Btn_";
	}
	if((sizeType < 150))
	{
		return "L2UI_NewTex.InventoryWnd.Inventory_Scale120_Btn_";
	}
}

function float GetScaleRatio()
{
	return (float(GetScalePercentage()) / 100.0000000);
}

function int GetScalePercentage()
{
	return (100 + sizeType);
}

function API_ChangeScalableSize(int a_SizeType)
{
	if((sizeType == a_SizeType))
	{
		return;
	}
	m_hOwnerWnd.ChangeScalableSize(a_SizeType);
	return;
}

function API_UseItemWithInfo(ItemInfo iInfo)
{
	UseItemWithInfo(iInfo);
	return;
}

function API_GetClientCursorPos(out int X, out int Y)
{
	GetClientCursorPos(X, Y);
	return;
}

function _HandleShowDevTool()
{
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScaleBtn")).ShowWindow();
	return;
}

function _HandleHideDevTool()
{
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScaleBtn")).HideWindow();
	return;
}
