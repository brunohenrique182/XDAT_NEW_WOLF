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
const EQUIPITEM_ARTIFACT = 37;
const EQUIPITEM_ARTIFACT1_SUB1 = 38;
const EQUIPITEM_ARTIFACT1_SUB2 = 39;
const EQUIPITEM_ARTIFACT1_SUB3 = 40;
const EQUIPITEM_ARTIFACT1_SUB4 = 41;
const EQUIPITEM_ARTIFACT2_SUB1 = 42;
const EQUIPITEM_ARTIFACT2_SUB2 = 43;
const EQUIPITEM_ARTIFACT2_SUB3 = 44;
const EQUIPITEM_ARTIFACT2_SUB4 = 45;
const EQUIPITEM_ARTIFACT3_SUB1 = 46;
const EQUIPITEM_ARTIFACT3_SUB2 = 47;
const EQUIPITEM_ARTIFACT3_SUB3 = 48;
const EQUIPITEM_ARTIFACT3_SUB4 = 49;
const EQUIPITEM_ARTIFACT1_MAIN1 = 50;
const EQUIPITEM_ARTIFACT2_MAIN1 = 51;
const EQUIPITEM_ARTIFACT3_MAIN1 = 52;
const EQUIPITEM_ARTIFACT1_MAIN2 = 53;
const EQUIPITEM_ARTIFACT2_MAIN2 = 54;
const EQUIPITEM_ARTIFACT3_MAIN2 = 55;
const EQUIPITEM_ARTIFACT1_MAIN3 = 56;
const EQUIPITEM_ARTIFACT2_MAIN3 = 57;
const EQUIPITEM_ARTIFACT3_MAIN3 = 58;
const EQUIPITEM_Total = 59;
const EQUIPITEM_TOTAL_CLASSIC = 37;
const INVENTORY_ITEM_TAB = 0;
const INVENTORY_ITEM_1_TAB = 1;
const INVENTORY_ITEM_2_TAB = 2;
const INVENTORY_ITEM_3_TAB = 3;
const INVENTORY_ITEM_4_TAB = 4;
const QUEST_ITEM_TAB = 5;
const ARTIFACT_ITEM_TAB = 6;
const ICON_WIDTH = 36;
const INVENTORYWND_MIN_WIDTH = 556;
const ITEMWINDOW_MIN_WIDTH = 339;
const TAB_BG_MIN_WIDTH = 350;
const TAB_BG_LING_MIN_WIDTH = 10;
const TAB_LENGTH = 4;
const ARTIFACT_TOOLTIPMAX = 405;
const Henna_CLASSIC_MAX = 0;
const TIMERID_bRequestedEnableList = 99;
const TIMER_bRequestedEnableList = 1000;

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
	brooch,                         // 17
	LBracelet,                      // 18
	RBracelet,                      // 19
	Artifact,                       // 20
	Max                             // 21
};

var int EQUIPITEM_Max;
var bool bInitedCompleted;
var bool bRequestedEnableList;
var bool bRequestItemList;
var int preTabOrder;
var WindowHandle m_hInventoryWnd;
var ItemWindowHandle m_invenItem;
var ItemWindowHandle m_questItem;
var ItemWindowHandle m_equipItem[59];
var ItemWindowHandle m_hHennaItemWindow;
var ItemWindowHandle m_hPremiumHennaItemWindow;
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
var array<ItemInfo> m_EarItemList;
var array<ItemInfo> m_FingerItemLIst;
var array<ItemInfo> m_DecoItemList;
var int m_NormalInvenCount;
var int m_QuestInvenCount;
var int m_ArtifactInvenCount;
var bool m_bCurrentState;
var int m_MaxInvenCount;
var int m_MaxQuestItemInvenCount;
var int m_MaxArtifactInvenCount;
var ButtonHandle CollectionBtn;
var AnimTextureHandle CollectionPointAni;
var ButtonHandle ItemAutoPeelBtn;
var ButtonHandle m_hBtnCrystallize;
var WindowHandle ColorNickNameWnd;
var int m_selectedItemTab;
var ButtonHandle AdenacalculateButton;
var ButtonHandle EnchantJewelButton;
var ButtonHandle AlchemyOpenerBtn;
var bool m_bFirstOpened;
var ButtonHandle ViewHairButton;
var ButtonHandle ViewAccessoryButton;
var WindowHandle JewelWindow;
var WindowHandle AlchemyOpenerWindow;
var ButtonHandle AlchemyMixCubeWndBtn;
var ButtonHandle AlchemyItemConversionWndBtn;
var ButtonHandle AlchemyItemCreateWndBtn;
var string cur_state;
var int mainClass;
var bool bIsPremiumHennaSlot;
var QuitReportWnd QuitReportWndScript;
var string m_EquipWindowName;
var WindowHandle m_EquipWindow;
var WindowHandle AgathionWindow;
var ButtonHandle AgathionBtn;
var ButtonHandle virtualItemBtn;
var TextureHandle m_Agathion_Disable[5];
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
var ButtonHandle EquipItem_Artifact_Button;
var WindowHandle m_InventoryWndCharacterView;
var ButtonHandle m_CharacterViewOpen_BTN;
var ButtonHandle m_CharacterViewClose_BTN;
var ItemWindowHandle m_artifactRuneItem;
var WindowHandle ArtifactWindow;
var TextureHandle m_Artifact_Disable[3];
var TextureHandle m_Artifact_Active[3];
var TextureHandle m_Artifact_Stone;
var CharacterViewportWindowHandle m_ObjectViewport;
var int _currentStoneState;
var ButtonHandle EnchantArtifactRuneButton;
var int bShowhairAccessory;
var TextureHandle EquipSlotBg_Sigil;
var array<AnimTextureHandle> enchantAnis;
var ItemInfo lasetSelectedItemInfo;

event OnRegisterEvent()
{
	RegisterEvent(2570);
	RegisterEvent(2580);
	RegisterEvent(2590);
	RegisterEvent(2600);
	RegisterEvent(2610);
	RegisterEvent(2620);
	RegisterEvent(2630);
	RegisterEvent(2632);
	RegisterEvent(2633);
	RegisterEvent(2631);
	RegisterEvent(260);
	RegisterEvent(180);
	RegisterEvent(181);
	RegisterEvent(40);
	RegisterEvent(2070);
	RegisterEvent(9439);
	RegisterEvent(3410);
	RegisterEvent(9873);
	RegisterEvent(5312);
	RegisterEvent(5310);
	RegisterEvent(8000);
	RegisterEvent(11430);
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
	InitScrollBar();
	m_bCurrentState = false;
	m_selectedItemTab = 0;
	HandlePremiumHenna();
	QuitReportWndScript = QuitReportWnd(GetScript("QuitReportWnd"));
	_currentStoneState = -2;
	InitTabIcon();
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
		case 2600:
			HandleAddItem(param);
			break;
		case 2570:
			HandleClear();
			break;
		case 2580:
			HandleOpenWindow(param);
			break;
		case 2590:
			HandleHideWindow();
			break;
		case 2610:
			if((int(Language) != 0))
			{
				showItemUpdateEffect(param);
			}
			HandleUpdateItem(param);
			break;
		case 2620:
			HandleItemListEnd();
			break;
		case 2630:
			UpdateHennaInfo();
			break;
		case 2632:
			UpdatePremiumHennaInfo(false);
			break;
		case 2633:
			UpdatePremiumHennaInfo(true);
			break;
		case 260:
			UpdateHennaInfo();
			break;
		case 2631:
			HandleToggleWindow();
			break;
		case 180:
			HandleUpdateUserInfo();
			break;
		case 181:
			HandleUpdateUserEquipSlotInfo();
			break;
		case 40:
			HandleRestart();
			break;
		case 2070:
			HandleSetMaxCount(param);
			break;
		case 9439:
			ReceiveHairAccessoryPriority(param);
			break;
		case 3410:
			cur_state = param;
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
		default:
			break;
	}
	return;
}

function clearEquipItemTooltip()
{
	local int i;

	i = 0;
	while((i < EQUIPITEM_Max))
	{
		m_equipItem[i].ClearItemTooltip();
		i++;
	}
	return;
}

event OnShow()
{
	if(IsShowWindow("PostWriteWnd"))
	{
		HideWindow("InventoryWnd");
	}
	else
	{
		getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)), "AttributeEnchantWnd,AttributeRemoveWnd,UnrefineryWnd,CrystallizationWnd,ItemAttributeChangeWnd,ProgressBox,AlchemyMixCubeWnd");
	}
	CheckShowCrystallizeButton();
	SetAdenaText();
	SetItemCount();
	UpdateHennaInfo();
	SetAhclemyOpener();
	setBottomButtonPositions();
	ShowHideCharacterViewPortOnShow();
	SwitchEquipBox(m_SelectedExpandEquipIdx);
	handleNewItemOnShow();
	ResetArtifactSkillList();
	CollectionPointAni.Stop();
	CollectionPointAni.Pause();
	CollectionPointAni.HideWindow();
	if(Class'Interface.VirtualItemWnd'.static.Inst().IsVirtualItemOpened())
	{
		virtualItemBtn.ShowWindow();
	}
	else
	{
		virtualItemBtn.HideWindow();
	}
	if(!bInitedCompleted)
	{
		bInitedCompleted = true;
		bRequestItemList = false;
	}
	else
	{
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
	return;
}

event OnEnterState(name a_CurrentStateName)
{
	m_bCurrentState = true;
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
	if(IsKeyDown(IK_Ctrl))
	{
		CheckNOpenItemAutoPeel(Info.Id.ServerID, Info.Id.ClassID, IsKeyDown(IK_Alt));
		return;
	}
	delNewItem(Info);
	UseItem(a_hItemWindow, Index);
	return;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	switch(a_WindowHandle)
	{
		case m_hHennaItemWindow:
			ShowHideHennaEngraveWndLive();
			break;
		default:
			break;
	}
	return;
}

function ShowHideHennaEngraveWndLive()
{
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("HennaEngraveWndLive"))
	{
		GetWindowHandle("HennaEngraveWndLive").HideWindow();
	}
	else
	{
		ShowWindowWithFocus("HennaEngraveWndLive");
	}
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
		case m_artifactRuneItem:
			delNewItem(Info);
			CheckCollectionEnableItem(Info);
			return;
			break;
		case m_equipItem[16]:
			SwitchEquipBox(16);
			break;
		case m_equipItem[15]:
			SwitchEquipBox(15);
			break;
		case m_equipItem[25]:
			SwitchEquipBox(25);
			break;
		case m_equipItem[37]:
			SwitchEquipBox(37);
			break;
		default:
			break;
	}
	i = 0;
	while((i < EQUIPITEM_Max))
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
	if(((((((strTarget == "InventoryItem") || (strTarget == "InventoryItem_1")) || (strTarget == "InventoryItem_2")) || (strTarget == "InventoryItem_3")) || (strTarget == "InventoryItem_4")) || (strTarget == "ArtifactItem")))
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
					Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
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
		if((IsStackableItem(Info.ConsumeType) && (Info.ItemNum > INT64(1))))
		{
			if((Info.AllItemCount > INT64(0)))
			{
				DialogSetID(7777);
				DialogSetReservedItemID(Info.Id);
				DialogSetReservedInt2(Info.AllItemCount);
				DialogShow(DialogModalType_Modalless, DialogType_Warning, MakeFullSystemMsg(GetSystemMessage(74), Info.Name, ""));
				Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
			}
			else
			{
				DialogSetID(8888);
				DialogSetReservedItemID(Info.Id);
				DialogSetParamInt64(Info.ItemNum);
				DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(73), Info.Name));
				DialogSetInputlimit(Info.ItemNum);
				Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
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
			Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
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
	return;
}

event OnReceivedCloseUI()
{
	CloseUI();
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
				Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
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
				Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
			}
		}
		else
		{
			DialogHide();
			DialogSetID(3333);
			DialogSetReservedItemID(Info.Id);
			DialogSetEnterOK();
			DialogShow(DialogModalType_Modalless, DialogType_Warning, MakeFullSystemMsg(GetSystemMessage(400), Info.Name, ""));
			Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
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
	switch(strID)
	{
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
				case 6:
					SortAttifactItem();
					SaveInventoryOrder();
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
		case "InventoryTab6":
			m_selectedItemTab = 6;
			m_artifactRuneItem.SetScrollPosition(0);
			SetIconOnSelectTabOrder();
			SetItemCount();
			m_invenTab.SetButtonBlink(6, false);
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
		case "HairAccButton":
		case "HairButton":
			ChangeViewAccessoryFunc();
			break;
		case "EnchantJewelButton":
			handleEnchantJewelButton();
			break;
		case "AlchemyOpenerBtn":
		case "AlchemyCloseButton":
			toggleAlchemyOpener();
			break;
		case "AlchemyItemCreateWndBtn":
			break;
		case "AlchemyItemConversionWndBtn":
			toggleShowAlchemyWindow("AlchemyItemConversionWnd");
			AlchemyOpenerWindow.HideWindow();
			break;
		case "AlchemyMixCubeWndBtn":
			toggleShowAlchemyWindow("AlchemyMixCubeWnd");
			AlchemyOpenerWindow.HideWindow();
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
		case "EquipItem_Artifact_Button":
			SwitchEquipBox(37);
			break;
		case "EnchantArtifactRuneButton":
			toggleWindow("ArtifactEnchantWnd", true, true);
			break;
		case "CloseButtonArtifactWindow":
			SwitchEquipBox(m_SelectedExpandEquipIdxPrev);
			break;
		case "OpenButtonArtifactEffect":
			if(m_InventoryWndCharacterView.IsShowWindow())
			{
				toogleCharacterViewPort(false);
			}
			else
			{
				InventoryWndCharacterView(GetScript("InventoryWndCharacterView")).ArtifactClicked();
			}
			break;
		case "CollectionBtn":
			CheckNOpenCollection(lasetSelectedItemInfo);
			break;
		case "ItemAutoPeelBtn":
			CheckNOpenItemAutoPeel(0, 0, false);
			break;
		case "DethroneEnchantBtn":
			if(GetWindowHandle("DethroneFireEnchantWnd").IsShowWindow())
			{
				GetWindowHandle("DethroneFireEnchantWnd").HideWindow();
			}
			else
			{
				DethroneFireEnchantWnd(GetScript("DethroneFireEnchantWnd")).API_C_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI();
			}
			break;
		case "VirtualItemOpen_BTN":
			Class'Interface.VirtualItemWnd'.static.Inst().OpenWindow();
			break;
		default:
			break;
	}
	return;
}

function InitHandleCOD()
{
	m_hInventoryWnd = GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath);
	m_invenItem = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".InventoryItem"));
	m_invenItem_1 = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".InventoryItem_1"));
	m_invenItem_2 = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".InventoryItem_2"));
	m_invenItem_3 = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".InventoryItem_3"));
	m_invenItem_4 = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".InventoryItem_4"));
	m_questItem = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".QuestItem"));
	m_artifactRuneItem = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ArtifactItem"));
	m_invenItem.SetIconDrawType(ITEMWND_IconDraw_ShowNewlyAcquired);
	m_invenItem_1.SetIconDrawType(ITEMWND_IconDraw_ShowNewlyAcquired);
	m_invenItem_2.SetIconDrawType(ITEMWND_IconDraw_ShowNewlyAcquired);
	m_invenItem_3.SetIconDrawType(ITEMWND_IconDraw_ShowNewlyAcquired);
	m_invenItem_4.SetIconDrawType(ITEMWND_IconDraw_ShowNewlyAcquired);
	m_questItem.SetIconDrawType(ITEMWND_IconDraw_ShowNewlyAcquired);
	m_artifactRuneItem.SetIconDrawType(ITEMWND_IconDraw_ShowNewlyAcquired);
	m_hAdenaTextBox = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenaText"));
	m_invenTab = GetTabHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".InventoryTab"));
	m_sortBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SortButton"));
	AlchemyOpenerWindow = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AlchemyOpener_Window"));
	AlchemyMixCubeWndBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AlchemyOpener_Window.AlchemyMixCubeWndBtn"));
	AlchemyItemConversionWndBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AlchemyOpener_Window.AlchemyItemConversionWndBtn"));
	AlchemyItemCreateWndBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AlchemyOpener_Window.AlchemyItemCreateWndBtn"));
	m_hBtnCrystallize = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CrystallizeButton"));
	CollectionBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CollectionBtn"));
	CollectionPointAni = GetAnimTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CollectionPointAni"));
	ItemAutoPeelBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemAutoPeelBtn"));
	EnchantJewelButton = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantJewelButton"));
	EnchantArtifactRuneButton = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantArtifactRuneButton"));
	AdenacalculateButton = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenacalculateButton"));
	ColorNickNameWnd = GetWindowHandle("ColorNickNameWnd");
	AlchemyOpenerBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AlchemyOpenerBtn"));
	m_tabbgLine = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".tabbgLine"));
	m_itemCount = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemCount"));
	m_CharacterViewOpen_BTN = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CharacterViewOpen_BTN"));
	m_CharacterViewClose_BTN = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CharacterViewClose_BTN"));
	m_InventoryWndCharacterView = GetWindowHandle("InventoryWndCharacterView");
	ItemAutoPeelBtn.SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(14039), GetSystemString(14062)));
	virtualItemBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".VirtualItemOpen_BTN"));
	return;
}

function SetEquipWindowHandle()
{
	local string equipWindow, hyphen, tooltipText;
	local CustomTooltip t;

	m_EquipWindowName = "Equip_Live";
	EQUIPITEM_Max = 59;
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
	ArtifactWindow = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EquipItem_Artifact_Window"));
	m_Artifact_Disable[0] = GetTextureHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_WindowSub1_Disable"));
	m_Artifact_Disable[1] = GetTextureHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_WindowSub2_Disable"));
	m_Artifact_Disable[2] = GetTextureHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_WindowSub3_Disable"));
	m_Artifact_Active[0] = GetTextureHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_WindowSub1_Active"));
	m_Artifact_Active[1] = GetTextureHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_WindowSub2_Active"));
	m_Artifact_Active[2] = GetTextureHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_WindowSub3_Active"));
	m_Artifact_Stone = GetTextureHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_Stone_Texture"));
	m_equipItem[50] = GetItemWindowHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_B01"));
	m_equipItem[53] = GetItemWindowHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_C01"));
	m_equipItem[56] = GetItemWindowHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_D01"));
	m_equipItem[38] = GetItemWindowHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_A01"));
	m_equipItem[39] = GetItemWindowHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_A02"));
	m_equipItem[40] = GetItemWindowHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_A03"));
	m_equipItem[41] = GetItemWindowHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_A04"));
	m_equipItem[51] = GetItemWindowHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_B02"));
	m_equipItem[54] = GetItemWindowHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_C02"));
	m_equipItem[57] = GetItemWindowHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_D02"));
	m_equipItem[42] = GetItemWindowHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_A05"));
	m_equipItem[43] = GetItemWindowHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_A06"));
	m_equipItem[44] = GetItemWindowHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_A07"));
	m_equipItem[45] = GetItemWindowHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_A08"));
	m_equipItem[52] = GetItemWindowHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_B03"));
	m_equipItem[55] = GetItemWindowHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_C03"));
	m_equipItem[58] = GetItemWindowHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_D03"));
	m_equipItem[46] = GetItemWindowHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_A09"));
	m_equipItem[47] = GetItemWindowHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_A10"));
	m_equipItem[48] = GetItemWindowHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_A11"));
	m_equipItem[49] = GetItemWindowHandle((equipWindow $ ".EquipItem_Artifact_Window.EquipItem_Artifact_A12"));
	HandleShowHideArtifactPanelTextureBySetNum(0, false);
	HandleShowHideArtifactPanelTextureBySetNum(1, false);
	HandleShowHideArtifactPanelTextureBySetNum(2, false);
	t = getAgathionTooltip(GetSystemString(3877), (hyphen $ GetSystemString(3092)));
	m_Artifact_Disable[0].SetTooltipCustomType(t);
	m_Artifact_Disable[1].SetTooltipCustomType(t);
	m_Artifact_Disable[2].SetTooltipCustomType(t);
	m_equipItem[50].SetTooltipText((GetSystemString(3891) @ GetSystemString(3877)));
	m_equipItem[53].SetTooltipText((GetSystemString(3892) @ GetSystemString(3877)));
	m_equipItem[56].SetTooltipText((GetSystemString(3893) @ GetSystemString(3877)));
	m_equipItem[38].SetTooltipText((GetSystemString(3894) @ GetSystemString(3877)));
	m_equipItem[39].SetTooltipText((GetSystemString(3894) @ GetSystemString(3877)));
	m_equipItem[40].SetTooltipText((GetSystemString(3894) @ GetSystemString(3877)));
	m_equipItem[41].SetTooltipText((GetSystemString(3894) @ GetSystemString(3877)));
	m_equipItem[51].SetTooltipText((GetSystemString(3891) @ GetSystemString(3877)));
	m_equipItem[54].SetTooltipText((GetSystemString(3892) @ GetSystemString(3877)));
	m_equipItem[57].SetTooltipText((GetSystemString(3893) @ GetSystemString(3877)));
	m_equipItem[42].SetTooltipText((GetSystemString(3894) @ GetSystemString(3877)));
	m_equipItem[43].SetTooltipText((GetSystemString(3894) @ GetSystemString(3877)));
	m_equipItem[44].SetTooltipText((GetSystemString(3894) @ GetSystemString(3877)));
	m_equipItem[45].SetTooltipText((GetSystemString(3894) @ GetSystemString(3877)));
	m_equipItem[52].SetTooltipText((GetSystemString(3891) @ GetSystemString(3877)));
	m_equipItem[55].SetTooltipText((GetSystemString(3892) @ GetSystemString(3877)));
	m_equipItem[58].SetTooltipText((GetSystemString(3893) @ GetSystemString(3877)));
	m_equipItem[46].SetTooltipText((GetSystemString(3894) @ GetSystemString(3877)));
	m_equipItem[47].SetTooltipText((GetSystemString(3894) @ GetSystemString(3877)));
	m_equipItem[48].SetTooltipText((GetSystemString(3894) @ GetSystemString(3877)));
	m_equipItem[49].SetTooltipText((GetSystemString(3894) @ GetSystemString(3877)));
	m_Artifact_Active[0].HideWindow();
	m_Artifact_Active[1].HideWindow();
	m_Artifact_Active[2].HideWindow();
	return;
}

function InitEnchantAniTextures()
{
	local string equipWindow;
	local int i;

	equipWindow = ((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ m_EquipWindowName);
	enchantAnis.Length = 21;
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
	enchantAnis[17] = GetAnimTextureHandle((equipWindow $ ".EnchantAni_brooch"));
	enchantAnis[18] = GetAnimTextureHandle((equipWindow $ ".EnchantAni_LBracelet"));
	enchantAnis[19] = GetAnimTextureHandle((equipWindow $ ".EnchantAni_RBracelet"));
	enchantAnis[20] = GetAnimTextureHandle((equipWindow $ ".EnchantAni_artifact"));
	i = 0;
	while((i < 21))
	{
		enchantAnis[i].SetLoopCount(-1);
		i++;
	}
	i = 0;
	while((i < 21))
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
	setCustomTooltip();
	m_equipItem[37] = GetItemWindowHandle((equipWindow $ ".EquipItem_Artifact"));
	EquipItem_Artifact_Button = GetButtonHandle((equipWindow $ ".EquipItem_Artifact_Button"));
	m_equipItem[1].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(230), GetSystemString(13122)));
	m_equipItem[2].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1024), GetSystemString(13125)));
	m_equipItem[3].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1024), GetSystemString(13126)));
	m_equipItem[4].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(238), GetSystemString(13127)));
	m_equipItem[5].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(2520), GetSystemString(13121)));
	m_equipItem[6].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(38), GetSystemString(13122)));
	EquipSlotBg_Sigil = GetTextureHandle((m_EquipWindowName $ ".EquipSlotBg_Sigil"));
	SetSigilShieldTextureChange(true);
	m_equipItem[9].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(237), GetSystemString(13127)));
	m_equipItem[8].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(237), GetSystemString(13127)));
	m_equipItem[10].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(37), GetSystemString(13122)));
	m_equipItem[11].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(39), GetSystemString(13122)));
	m_equipItem[12].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(40), GetSystemString(13122)));
	m_equipItem[13].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(239), GetSystemString(13127)));
	m_equipItem[14].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(239), GetSystemString(13127)));
	m_equipItem[15].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1637), GetSystemString(13133)));
	EquipItem_LBracelet_Button.SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1637), GetSystemString(13133)));
	m_equipItem[16].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1636), GetSystemString(13131)));
	EquipItem_RBracelet_Button.SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1636), GetSystemString(13131)));
	m_equipItem[23].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(234), GetSystemString(13124)));
	m_equipItem[24].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(2538), GetSystemString(13123)));
	m_equipItem[17].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1638), GetSystemString(13132)));
	m_equipItem[18].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1638), GetSystemString(13132)));
	m_equipItem[19].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1638), GetSystemString(13132)));
	m_equipItem[20].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1638), GetSystemString(13132)));
	m_equipItem[21].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1638), GetSystemString(13132)));
	m_equipItem[22].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1638), GetSystemString(13132)));
	m_Talisman_Disable[0].SetTooltipText(GetSystemString(1638));
	m_Talisman_Disable[1].SetTooltipText(GetSystemString(1638));
	m_Talisman_Disable[2].SetTooltipText(GetSystemString(1638));
	m_Talisman_Disable[3].SetTooltipText(GetSystemString(1638));
	m_Talisman_Disable[4].SetTooltipText(GetSystemString(1638));
	m_Talisman_Disable[5].SetTooltipText(GetSystemString(1638));
	m_Talisman_Disable[0].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1638), GetSystemString(13132)));
	m_Talisman_Disable[1].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1638), GetSystemString(13132)));
	m_Talisman_Disable[2].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1638), GetSystemString(13132)));
	m_Talisman_Disable[3].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1638), GetSystemString(13132)));
	m_Talisman_Disable[4].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1638), GetSystemString(13132)));
	m_Talisman_Disable[5].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1638), GetSystemString(13132)));
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
	m_equipItem[26].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3187), GetSystemString(13130)));
	m_equipItem[27].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3187), GetSystemString(13130)));
	m_equipItem[28].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3187), GetSystemString(13130)));
	m_equipItem[29].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3187), GetSystemString(13130)));
	m_equipItem[30].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3187), GetSystemString(13130)));
	m_equipItem[31].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3187), GetSystemString(13130)));
	m_Jewel_Disable[0].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3187), GetSystemString(13130)));
	m_Jewel_Disable[1].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3187), GetSystemString(13130)));
	m_Jewel_Disable[2].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3187), GetSystemString(13130)));
	m_Jewel_Disable[3].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3187), GetSystemString(13130)));
	m_Jewel_Disable[4].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3187), GetSystemString(13130)));
	m_Jewel_Disable[5].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3187), GetSystemString(13130)));
	m_equipItem[0].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(28), GetSystemString(13128)));
	m_equipItem[25].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3186), GetSystemString(13129)));
	EquipItem_Brooch_Button.SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3186), GetSystemString(13129)));
	EquipItem_Artifact_Button.SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3895), GetSystemString(13136)));
	m_TalismanAllow = GetTextureHandle((equipWindow $ ".TalismanAllow"));
	return;
}

function SetSigilShieldTextureChange(bool B)
{
	if(B)
	{
		EquipSlotBg_Sigil.SetTexture("L2UI_ct1.InventoryWnd.Inventory_Slot32_SigilShield");
		m_equipItem[7].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(13205), GetSystemString(13122)));
	}
	else
	{
		EquipSlotBg_Sigil.SetTexture("L2UI_ct1.InventoryWnd.Inventory_Slot32_Sigil");
		m_equipItem[7].SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(1987), GetSystemString(13122)));
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
	local string equipWindow;

	equipWindow = ((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ m_EquipWindowName);
	m_hPremiumHennaItemWindow = GetItemWindowHandle((equipWindow $ ".PremiumHennaItem"));
	m_hHennaItemWindow = GetItemWindowHandle((equipWindow $ ".HennaItem"));
	m_hHennaItemWindow.SetTooltipCustomType(getEquipCustomTooltip(GetSystemString(3185), GetSystemString(13137)));
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

function HandleRestart()
{
	m_bCurrentState = false;
	_currentStoneState = -1;
	bInitedCompleted = false;
	bRequestedEnableList = false;
	m_hInventoryWnd.HideWindow();
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
		if((Info.bDisabled == 0))
		{
			API_UseItemWithInfo(Info);
		}
		else if((Class'NWindow.UIDATA_ITEM'.static.IsDefaultActionPeel(Info.Id.ClassID) && Class'Interface.ItemAutoPeelWnd'.static.Inst().IsItemReady()))
		{
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13680));
		}
	}
	return;
}

function HandleJewelDropedOnButton(ItemInfo iInfo)
{
	Class'Interface.ItemJewelEnchantWnd'.static.Inst()._HandleDropedItem(iInfo);
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
	m_artifactRuneItem.SetItemUsability();
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
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_ITEM_USABLE_LIST(stream, packet))
	{
		return;
	}
	packet.cDummy = 0;
	Class'Interface.UIPacket'.static.RequestUIPacket(753, stream);
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
			if(IsArtifactRuneItem(Info))
			{
				ResetArtifactSkillList();
			}
		}
		else if(IsQuestItem(Info))
		{
			QuestInvenAddItem(Info);
			handleNewItem(Info);
		}
		else if(IsArtifactRuneItem(Info))
		{
			ArtifactInvenAddItem(Info);
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
			if(EquipItemFind(Info.Id))
			{
				EquipItemUpdate(Info, true);
				if(IsArtifactRuneItem(Info))
				{
					ResetArtifactSkillList();
				}
			}
			else if(IsArtifactRuneItem(Info))
			{
				ArtifactRuneDelete(Info);
				EquipItemUpdate(Info, true);
				ResetArtifactSkillList();
			}
			else
			{
				InvenDelete(Info);
				EquipItemUpdate(Info, true);
			}
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
		else if(IsArtifactRuneItem(Info))
		{
			Index = m_artifactRuneItem.FindItem(Info.Id);
			if((Index != -1))
			{
				m_artifactRuneItem.GetItem(Index, beforeItem);
				QuitReportWndScript.externalAddItem(Info);
				m_artifactRuneItem.SetItem(Index, Info);
			}
			else
			{
				EquipItemDelete(Info.Id);
				ArtifactInvenAddItem(Info);
				ResetArtifactSkillList();
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
		else if(IsArtifactRuneItem(Info))
		{
			ArtifactRuneDelete(Info);
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
	if(m_hInventoryWnd.IsShowWindow())
	{
		ResetArtifactSkillList();
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
	else if(IsArtifactRuneItem(Info))
	{
		ArtifactInvenAddItem(Info);
	}
	else
	{
		NormalInvenAddItem(Info);
	}
	return;
}

function ArtifactInvenAddItem(ItemInfo NewItem)
{
	local int idx, CurLimit, FindIdx;
	local ItemInfo CurItem;

	FindIdx = -1;
	CurLimit = m_artifactRuneItem.GetItemNum();
	if(bIsSavedLocalItemIdx)
	{
		NewItem.ORDER = getLocalItemOrder(NewItem.Id.ServerID, itemSwapedServerID_a, itemSwapedIdx_a, NewItem.ORDER);
	}
	if(m_artifactRuneItem.GetItem(NewItem.ORDER, CurItem))
	{
		if(!IsValidItemID(CurItem.Id))
		{
			FindIdx = NewItem.ORDER;
		}
	}
	if((FindIdx < 0))
	{
		idx = 0;
		while((idx < CurLimit))
		{
			if(m_artifactRuneItem.GetItem(idx, CurItem))
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
		m_artifactRuneItem.SetItem(FindIdx, NewItem);
	}
	else
	{
		m_artifactRuneItem.AddItem(NewItem);
	}
	m_ArtifactInvenCount++;
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
	local ItemInfo CurItem;
	local int CurLimit, FindIdx, idx;

	detailItemWindow = GetItemWindowHandleByItemType(NewItem);
	if(bIsSavedLocalItemIdx)
	{
		FindIdx = getLocalItemOrderByItemWindow(detailItemWindow, NewItem.Id.ServerID, -1);
	}
	else
	{
		FindIdx = -1;
		CurLimit = m_invenItem.GetItemNum();
		idx = 0;
		while((idx < CurLimit))
		{
			if(detailItemWindow.GetItem(idx, CurItem))
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
		detailItemWindow.SetItem(FindIdx, NewItem);
	}
	else
	{
		detailItemWindow.AddItem(NewItem);
	}
	return;
}

function NormalInvenAddItem(ItemInfo NewItem)
{
	local int idx, CurLimit, FindIdx;
	local ItemInfo CurItem;

	FindIdx = -1;
	CurLimit = m_invenItem.GetItemNum();
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
		idx = 0;
		while((idx < CurLimit))
		{
			if(m_invenItem.GetItem(idx, CurItem))
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

function HandleArtifactEquip(ItemInfo a_Info)
{
	local int artifactEquipIdx;

	artifactEquipIdx = GetArtifactEmptySlotIdxBySlotBit(a_Info);
	if((artifactEquipIdx != -1))
	{
		m_equipItem[artifactEquipIdx].Clear();
		m_equipItem[artifactEquipIdx].AddItem(a_Info);
		m_equipItem[artifactEquipIdx].EnableWindow();
	}
	return;
}

function handleAgathionEquip(ItemInfo a_Info)
{
	local int agathionIndex;

	agathionIndex = GetAgathionIndex(a_Info.Id);
	if((agathionIndex != -1))
	{
		m_equipItem[(32 + agathionIndex)].Clear();
		m_equipItem[(32 + agathionIndex)].AddItem(a_Info);
		m_equipItem[(32 + agathionIndex)].EnableWindow();
	}
	return;
}

function EarItemUpdate()
{
	local int i, LEarIndex, REarIndex;

	LEarIndex = -1;
	REarIndex = -1;
	i = 0;
	while((i < m_EarItemList.Length))
	{
		switch(IsLOrREar(m_EarItemList[i].Id))
		{
			case -1:
				LEarIndex = i;
				break;
			case 0:
				m_EarItemList.Remove(i, 1);
				i--;
				break;
			case 1:
				REarIndex = i;
				break;
			default:
				break;
		}
		++i;
	}
	if((-1 != LEarIndex))
	{
		m_equipItem[9].Clear();
		AddEquipItem(9, m_EarItemList[LEarIndex]);
	}
	if((-1 != REarIndex))
	{
		m_equipItem[8].Clear();
		AddEquipItem(8, m_EarItemList[REarIndex]);
	}
	return;
}

function FingerItemUpdate()
{
	local int i, LFingerIndex, RFingerIndex;

	LFingerIndex = -1;
	RFingerIndex = -1;
	i = 0;
	while((i < m_FingerItemLIst.Length))
	{
		switch(IsLOrRFinger(m_FingerItemLIst[i].Id))
		{
			case -1:
				LFingerIndex = i;
				break;
			case 0:
				m_FingerItemLIst.Remove(i, 1);
				break;
			case 1:
				RFingerIndex = i;
				break;
			default:
				break;
		}
		++i;
	}
	if((-1 != LFingerIndex))
	{
		m_equipItem[14].Clear();
		AddEquipItem(14, m_FingerItemLIst[LFingerIndex]);
	}
	if((-1 != RFingerIndex))
	{
		m_equipItem[13].Clear();
		AddEquipItem(13, m_FingerItemLIst[RFingerIndex]);
	}
	return;
}

function EquipItemUpdate(ItemInfo a_Info, optional bool bSwitchExpandEquipBox)
{
	local ItemWindowHandle hItemWnd;
	local ItemInfo TheItemInfo;
	local bool ClearLHand;
	local ItemInfo rHand, legs, gloves, feet, hair2;
	local int i, decoIndex, jewelIndex;

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
			i = 0;
			while((i < m_EarItemList.Length))
			{
				if(IsSameServerID(m_EarItemList[i].Id, a_Info.Id))
				{
					m_EarItemList[i] = a_Info;
					break;
				}
				++i;
			}
			if((i == m_EarItemList.Length))
			{
				m_EarItemList.Length = (m_EarItemList.Length + 1);
				m_EarItemList[(m_EarItemList.Length - 1)] = a_Info;
			}
			hItemWnd = none;
			EarItemUpdate();
			break;
		case INT64(8):
			HandleChkSwitchEquipBox(-1, a_Info, bSwitchExpandEquipBox);
			hItemWnd = m_equipItem[4];
			break;
		case INT64(16):
		case INT64(32):
		case INT64(48):
			HandleChkSwitchEquipBox(-1, a_Info, bSwitchExpandEquipBox);
			i = 0;
			while((i < m_FingerItemLIst.Length))
			{
				if(IsSameServerID(m_FingerItemLIst[i].Id, a_Info.Id))
				{
					m_FingerItemLIst[i] = a_Info;
					break;
				}
				++i;
			}
			if((i == m_FingerItemLIst.Length))
			{
				m_FingerItemLIst.Length = (m_FingerItemLIst.Length + 1);
				m_FingerItemLIst[(m_FingerItemLIst.Length - 1)] = a_Info;
			}
			hItemWnd = none;
			FingerItemUpdate();
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
			decoIndex = GetDecoIndex(a_Info.Id);
			if((decoIndex != -1))
			{
				m_equipItem[(17 + decoIndex)].Clear();
				m_equipItem[(17 + decoIndex)].AddItem(a_Info);
				m_equipItem[(17 + decoIndex)].EnableWindow();
			}
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
			jewelIndex = GetJewelIndex(a_Info.Id);
			if((jewelIndex != -1))
			{
				m_equipItem[(26 + jewelIndex)].Clear();
				m_equipItem[(26 + jewelIndex)].AddItem(a_Info);
				m_equipItem[(26 + jewelIndex)].EnableWindow();
			}
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
		case INT64(512):
			HandleChkSwitchEquipBox(37, a_Info, bSwitchExpandEquipBox);
			m_equipItem[37].Clear();
			AddEquipItem(37, a_Info);
			m_equipItem[37].EnableWindow();
			ResetArtifactSkillList();
			break;
		default:
			if(IsArtifactRuneItem(a_Info))
			{
				HandleChkSwitchEquipBox(37, a_Info, bSwitchExpandEquipBox);
				HandleArtifactEquip(a_Info);
			}
			else
			{
				HandleChkSwitchEquipBox(-1, a_Info, bSwitchExpandEquipBox);
			}
			break;
	}
	if((none != hItemWnd))
	{
		hItemWnd.Clear();
		AddEquipItemWithIWnd(hItemWnd, a_Info);
	}
	return;
}

function UpdatePremiumHennaInfo(bool Clear)
{
	local int HennaID, IsActive;
	local ItemInfo HennaItemInfo;
	local bool hennacheck;

	m_hPremiumHennaItemWindow.Clear();
	if((Clear || (bIsPremiumHennaSlot == false)))
	{
		return;
	}
	if(Class'NWindow.HennaAPI'.static.GetPremiumHennaInfo(HennaID, IsActive))
	{
		hennacheck = Class'NWindow.UIDATA_HENNA'.static.GetItemCheck(HennaID);
		if(hennacheck)
		{
			HennaItemInfo.Name = Class'NWindow.UIDATA_HENNA'.static.GetItemNameS(HennaID);
			HennaItemInfo.AdditionalName = Class'NWindow.UIDATA_HENNA'.static.GetAddtionNameS(HennaID);
			HennaItemInfo.Description = Class'NWindow.UIDATA_HENNA'.static.GetDescriptionS(HennaID);
			HennaItemInfo.IconName = Class'NWindow.UIDATA_HENNA'.static.GetIconTexS(HennaID);
			HennaItemInfo.CurrentPeriod = Class'NWindow.HennaAPI'.static.GetPremiumHennaPeriod();
		}
		if((0 == IsActive))
		{
			HennaItemInfo.bDisabled = 1;
		}
		else
		{
			HennaItemInfo.bDisabled = 0;
		}
		m_hPremiumHennaItemWindow.AddItem(HennaItemInfo);
	}
	return;
}

function UpdateHennaInfo()
{
	local int i, HennaInfoCount, HennaID, IsActive;
	local ItemInfo HennaItemInfo;
	local UserInfo PlayerInfo;
	local int ClassStep;
	local bool hennacheck;

	if(GetPlayerInfo(PlayerInfo))
	{
		ClassStep = GetClassStep(PlayerInfo.nSubClass);
		switch(ClassStep)
		{
			case 1:
			case 2:
			case 3:
			case 4:
			case 5:
				m_hHennaItemWindow.SetRow(ClassStep);
				break;
			default:
				m_hHennaItemWindow.SetRow(0);
				break;
		}
	}
	m_hHennaItemWindow.Clear();
	HennaInfoCount = Class'NWindow.HennaAPI'.static.GetHennaInfoCount();
	if((HennaInfoCount > ClassStep))
	{
		HennaInfoCount = ClassStep;
	}
	else
	{
		i = 0;
		while((i < HennaInfoCount))
		{
			if(Class'NWindow.HennaAPI'.static.GetHennaInfo(i, HennaID, IsActive))
			{
				hennacheck = Class'NWindow.UIDATA_HENNA'.static.GetItemCheck(HennaID);
				if(hennacheck)
				{
					HennaItemInfo.Name = Class'NWindow.UIDATA_HENNA'.static.GetItemNameS(HennaID);
					HennaItemInfo.Description = Class'NWindow.UIDATA_HENNA'.static.GetDescriptionS(HennaID);
					HennaItemInfo.IconName = Class'NWindow.UIDATA_HENNA'.static.GetIconTexS(HennaID);
				}
				if((0 == IsActive))
				{
					HennaItemInfo.bDisabled = 1;
				}
				else
				{
					HennaItemInfo.bDisabled = 0;
				}
				m_hHennaItemWindow.AddItem(HennaItemInfo);
			}
			++i;
		}
	}
	return;
}

function HandleUpdateUserEquipSlotInfo()
{
	EarItemUpdate();
	FingerItemUpdate();
	UpdateTalismanSlotActivation();
	UpdateJewelSlotActivation();
	UpdateAgathionSlotActivation();
	UpdateArtifactSlotActivation();
	SortArtifactSlot();
	return;
}

function handleRequestUnequipItem(string DragSrcName, ItemID infoID, INT64 SlotBitType)
{
	local string tmpSlotbitType;

	tmpSlotbitType = "";
	if((-1 != InStr(DragSrcName, "Talisman")))
	{
		switch(Right(DragSrcName, 1))
		{
			case "1":
				tmpSlotbitType = "4194304";
				break;
			case "2":
				tmpSlotbitType = "8388608";
				break;
			case "3":
				tmpSlotbitType = "16777216";
				break;
			case "4":
				tmpSlotbitType = "33554432";
				break;
			case "5":
				tmpSlotbitType = "67108864";
				break;
			case "6":
				tmpSlotbitType = "134217728";
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
				tmpSlotbitType = "1073741824";
				break;
			case "2":
				tmpSlotbitType = "2147483648";
				break;
			case "3":
				tmpSlotbitType = "4294967296";
				break;
			case "4":
				tmpSlotbitType = "8589934592";
				break;
			case "5":
				tmpSlotbitType = "17179869184";
				break;
			case "6":
				tmpSlotbitType = "34359738368";
				break;
			default:
				break;
		}
	}
	else if((-1 != InStr(DragSrcName, "Agathion")))
	{
		tmpSlotbitType = getAgathionSlotBitTypeString(Right(DragSrcName, 1));
	}
	else if((-1 != InStr(DragSrcName, "Artifact")))
	{
		tmpSlotbitType = getArtifactSlotBitTypeString(Right(DragSrcName, 3));
	}
	if((tmpSlotbitType == ""))
	{
		RequestUnequipItem(infoID, SlotBitType);
	}
	else
	{
		RequestUnequipItem(infoID, INT64(tmpSlotbitType));
	}
	return;
}

function EquipItemDelete(ItemID sID)
{
	local int i, Index;
	local ItemInfo TheItemInfo;

	i = 0;
	while((i < EQUIPITEM_Max))
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
				case 37:
					ResetArtifactSkillList();
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
				case 38:
				case 39:
				case 40:
				case 41:
				case 42:
				case 43:
				case 44:
				case 45:
				case 46:
				case 47:
				case 48:
				case 49:
				case 50:
				case 53:
				case 56:
				case 51:
				case 54:
				case 57:
				case 52:
				case 55:
				case 58:
					ResetArtifactSkillList();
					SwitchEquipBox(37);
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
		case 37:
			EquipItem_Artifact_Button.ShowWindow();
			break;
		default:
			break;
	}
	return;
}

function ArtifactRuneDelete(ItemInfo item)
{
	local int FindIdx;
	local ItemInfo ClearItem;

	ClearItemID(ClearItem.Id);
	ClearItem.IconName = "L2ui_ct1.emptyBtn";
	FindIdx = m_artifactRuneItem.FindItem(item.Id);
	if((FindIdx != -1))
	{
		m_artifactRuneItem.SetItem(FindIdx, ClearItem);
		m_ArtifactInvenCount--;
	}
	return;
}

function InvenDelete(ItemInfo item)
{
	local int FindIdx, DetailFindIdx;
	local ItemInfo ClearItem;
	local ItemWindowHandle detailItemWindow;

	detailItemWindow = GetItemWindowHandleByItemType(item);
	ClearItemID(ClearItem.Id);
	ClearItem.IconName = "L2ui_ct1.emptyBtn";
	FindIdx = m_invenItem.FindItem(item.Id);
	DetailFindIdx = detailItemWindow.FindItem(item.Id);
	if((FindIdx != -1))
	{
		m_invenItem.SetItem(FindIdx, ClearItem);
		detailItemWindow.SetItem(DetailFindIdx, ClearItem);
		m_NormalInvenCount--;
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
	artifactItemClear();
	EquipItemClear();
	m_EarItemList.Length = 0;
	m_FingerItemLIst.Length = 0;
	m_DecoItemList.Length = 0;
	InvenLimitUpdate();
	bIsQuestItemList = false;
	HideAllEnchantLevelAniTextures();
	return;
}

function EquipItemClear()
{
	local int i;

	i = 0;
	while((i < EQUIPITEM_Max))
	{
		DelEquipItem(i);
		++i;
	}
	setExpandEquipItemButton(25);
	setExpandEquipItemButton(15);
	setExpandEquipItemButton(16);
	setExpandEquipItemButton(37);
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

function artifactItemClear()
{
	m_artifactRuneItem.Clear();
	m_ArtifactInvenCount = 0;
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
	i = 0;
	while((i < m_artifactRuneItem.GetItemNum()))
	{
		saveServerID(m_artifactRuneItem, i, itemSwapedServerID_a, itemSwapedIdx_a);
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
		case m_artifactRuneItem:
			return getLocalItemOrder(ServerID, itemSwapedServerID_a, itemSwapedIdx_a, defaultOrder);
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
	InvenLimit = m_artifactRuneItem.GetItemNum();
	idx = 0;
	while((idx < InvenLimit))
	{
		if(m_artifactRuneItem.GetItem(idx, item))
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

function int IsLOrREar(ItemID sID)
{
	local ItemID lEar, rEar, lFinger, rFinger;

	GetAccessoryItemID(lEar, rEar, lFinger, rFinger);
	if(IsSameServerID(sID, lEar))
	{
		return -1;
	}
	else if(IsSameServerID(sID, rEar))
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

function int IsLOrRFinger(ItemID sID)
{
	local ItemID lEar, rEar, lFinger, rFinger;

	GetAccessoryItemID(lEar, rEar, lFinger, rFinger);
	if(IsSameServerID(sID, lFinger))
	{
		return -1;
	}
	else if(IsSameServerID(sID, rFinger))
	{
		return 1;
	}
	else
	{
		return 0;
	}
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
		case "ArtifactItem":
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
	while((i <= 37))
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

function int EquipArtifactItemGetitemNum()
{
	local int i, ItemNum;

	i = 38;
	while((i < EQUIPITEM_Max))
	{
		if(m_equipItem[i].IsEnableWindow())
		{
			ItemNum = (ItemNum + m_equipItem[i].GetItemNum());
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
	while((i < EQUIPITEM_Max))
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
	return ("ArtifactItem" == Str);
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
	while((i < EQUIPITEM_Max))
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
		totalCount = (totalCount + getItemWindowCountByClassID(ClassID, m_artifactRuneItem));
		i = 0;
		while((i < EQUIPITEM_Max))
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
	local array<ItemInfo> itemarray, totalItemArray, artifactItemArray;

	Class'NWindow.UIDATA_INVENTORY'.static.GetAllInvenItem(totalItemArray);
	Class'NWindow.UIDATA_INVENTORY'.static.GetAllArtifactItem(artifactItemArray);
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
	Index = 0;
	while((Index < artifactItemArray.Length))
	{
		if((artifactItemArray[Index].Id.ClassID <= 0))
		{
			Index++;
			continue;
		}
		itemarray[itemarray.Length] = artifactItemArray[Index];
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
	while((i < EQUIPITEM_Max))
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

function array<ItemInfo> GetArtifactEquipedList(int ArtifactPageNum)
{
	local array<ItemInfo> artifactItemInfos;

	switch(ArtifactPageNum)
	{
		case 0:
			GetEquipedListByIdx(50, artifactItemInfos);
			GetEquipedListByIdx(53, artifactItemInfos);
			GetEquipedListByIdx(56, artifactItemInfos);
			GetEquipedListByIdx(38, artifactItemInfos);
			GetEquipedListByIdx(39, artifactItemInfos);
			GetEquipedListByIdx(40, artifactItemInfos);
			GetEquipedListByIdx(41, artifactItemInfos);
			break;
		case 1:
			GetEquipedListByIdx(51, artifactItemInfos);
			GetEquipedListByIdx(54, artifactItemInfos);
			GetEquipedListByIdx(57, artifactItemInfos);
			GetEquipedListByIdx(42, artifactItemInfos);
			GetEquipedListByIdx(43, artifactItemInfos);
			GetEquipedListByIdx(44, artifactItemInfos);
			GetEquipedListByIdx(45, artifactItemInfos);
			break;
		case 2:
			GetEquipedListByIdx(52, artifactItemInfos);
			GetEquipedListByIdx(55, artifactItemInfos);
			GetEquipedListByIdx(58, artifactItemInfos);
			GetEquipedListByIdx(46, artifactItemInfos);
			GetEquipedListByIdx(47, artifactItemInfos);
			GetEquipedListByIdx(48, artifactItemInfos);
			GetEquipedListByIdx(49, artifactItemInfos);
			break;
		default:
			break;
	}
	return artifactItemInfos;
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

function int GetArtifactItemInventoryLimit()
{
	return m_MaxArtifactInvenCount;
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
	while((i < EQUIPITEM_Max))
	{
		ItemNum = m_equipItem[i].GetItemNum();
		Index = 0;
		while((Index < ItemNum))
		{
			m_equipItem[i].GetItem(Index, InvenItemInfo);
			if((7 == i))
			{
				if((((int(byte(InvenItemInfo.ItemType)) == 1) || (int(byte(InvenItemInfo.ItemType)) == 2)) || IsSigilArmor(InvenItemInfo.Id)))
				{
				}
				else
				{
					Index++;
					continue;
				}
			}
			if((InvenItemInfo.Id.ClassID <= 0))
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
		if((InvenItemInfo.IsVirtualItem == true))
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
	while((i < EQUIPITEM_Max))
	{
		ItemNum = m_equipItem[i].GetItemNum();
		Index = 0;
		while((Index < ItemNum))
		{
			m_equipItem[i].GetItem(Index, InvenItemInfo);
			if((7 == i))
			{
				if((((int(byte(InvenItemInfo.ItemType)) == 1) || (int(byte(InvenItemInfo.ItemType)) == 2)) || IsSigilArmor(InvenItemInfo.Id)))
				{
				}
				else
				{
					Index++;
					continue;
				}
			}
			if((InvenItemInfo.Id.ClassID <= 0))
			{
				Index++;
				continue;
			}
			if((InvenItemInfo.IsVirtualItem == true))
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

function SortAttifactItem()
{
	local int i, InvenLimit;
	local ItemInfo item;
	local int numArtifact;
	local array<ItemInfo> ArtifactList, ArtifactListNormal, ArtifactListType1, ArtifactListType2, ArtifactListType3;

	InvenLimit = m_artifactRuneItem.GetItemNum();
	i = 0;
	while((i < InvenLimit))
	{
		m_artifactRuneItem.GetItem(i, item);
		if(!IsValidItemID(item.Id))
		{
			i++;
			continue;
		}
		ArtifactList[numArtifact] = item;
		numArtifact++;
		i++;
	}
	m_artifactRuneItem.Clear();
	ArtifactList = getInstanceL2Util().sortByEnchanted(ArtifactList);
	ArtifactList = getInstanceL2Util().sortByName(ArtifactList);
	i = 0;
	while((i < numArtifact))
	{
		switch(ArtifactList[i].SlotBitType)
		{
			case INT64(4194304):
				ArtifactListType1.Length = (ArtifactListType1.Length + 1);
				ArtifactListType1[(ArtifactListType1.Length - 1)] = ArtifactList[i];
				break;
			case INT64(33554432):
				ArtifactListType2.Length = (ArtifactListType2.Length + 1);
				ArtifactListType2[(ArtifactListType2.Length - 1)] = ArtifactList[i];
				break;
			case INT64(268435456):
				ArtifactListType3.Length = (ArtifactListType3.Length + 1);
				ArtifactListType3[(ArtifactListType3.Length - 1)] = ArtifactList[i];
				break;
			case INT64(1024):
				ArtifactListNormal.Length = (ArtifactListNormal.Length + 1);
				ArtifactListNormal[(ArtifactListNormal.Length - 1)] = ArtifactList[i];
				break;
			default:
				break;
		}
		i++;
	}
	ItemboxUpdate(m_artifactRuneItem, GetArtifactItemInventoryLimit());
	numArtifact = 0;
	i = 0;
	while((i < ArtifactListType1.Length))
	{
		m_artifactRuneItem.SetItem(i, ArtifactListType1[i]);
		i++;
	}
	(numArtifact += i);
	i = 0;
	while((i < ArtifactListType2.Length))
	{
		m_artifactRuneItem.SetItem((numArtifact + i), ArtifactListType2[i]);
		i++;
	}
	(numArtifact += i);
	i = 0;
	while((i < ArtifactListType3.Length))
	{
		m_artifactRuneItem.SetItem((numArtifact + i), ArtifactListType3[i]);
		i++;
	}
	(numArtifact += i);
	i = 0;
	while((i < ArtifactListNormal.Length))
	{
		m_artifactRuneItem.SetItem((numArtifact + i), ArtifactListNormal[i]);
		i++;
	}
	return;
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

function UpdateArtifactSlotActivation()
{
	local UserInfo currentUserInfo;
	local int i;

	if(!GetPlayerInfo(currentUserInfo))
	{
		return;
	}
	i = 0;
	while((i < currentUserInfo.nArtifactGroupNum))
	{
		m_Artifact_Disable[i].HideWindow();
		i++;
	}
	i = i;
	while((i < 3))
	{
		m_Artifact_Disable[i].ShowWindow();
		i++;
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

function HandlePremiumHenna()
{
	local int nUsePremiumHenna;
	local TextureHandle PremiumHennaTex;

	if(!GetINIBool("Localize", "UsePremiumHennaSlot", nUsePremiumHenna, "L2.ini"))
	{
		return;
	}
	bIsPremiumHennaSlot = (nUsePremiumHenna == 1);
	if((bIsPremiumHennaSlot == false))
	{
		PremiumHennaTex = GetTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ m_EquipWindowName) $ ".Charge_HennaSlotBg"));
		PremiumHennaTex.HideWindow();
		m_hPremiumHennaItemWindow.HideWindow();
	}
	return;
}

function HandleUpdateUserInfo()
{
	if(m_hOwnerWnd.IsShowWindow())
	{
		SetAhclemyOpener();
		InvenLimitUpdate();
		CheckShowCrystallizeButton();
		setBottomButtonPositions();
	}
	return;
}

function handleChangedSubjob(string param)
{
	ParseInt(param, "SubjobClassID_0", mainClass);
	SetAhclemyOpener();
	return;
}

function handleNotifySubjob(string param)
{
	ParseInt(param, "SubjobClassID_0", mainClass);
	SetAhclemyOpener();
	return;
}

function CheckShowCrystallizeButton()
{
	if(Class'NWindow.UIDATA_PLAYER'.static.HasCrystallizeAbility())
	{
		m_hBtnCrystallize.ShowWindow();
	}
	else
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
	if(ArtifactWindow.IsShowWindow())
	{
		return;
	}
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

function SetAhclemyOpener()
{
	AlchemyOpenerBtn.HideWindow();
	return;
}

function InitScrollBar()
{
	m_invenItem.SetScrollBarPosition(0, 17, 0);
	m_invenItem_1.SetScrollBarPosition(0, 17, 0);
	m_invenItem_2.SetScrollBarPosition(0, 17, 0);
	m_invenItem_3.SetScrollBarPosition(0, 17, 0);
	m_invenItem_4.SetScrollBarPosition(0, 17, 0);
	m_questItem.SetScrollBarPosition(0, 17, 0);
	m_artifactRuneItem.SetScrollBarPosition(0, 17, 0);
	return;
}

function setBottomButtonPostion(out int Num, ButtonHandle tmpBottomButton)
{
	local int StartX, btnW;

	StartX = 232;
	btnW = 39;
	tmpBottomButton.SetAnchor(m_hOwnerWnd.m_WindowNameWithFullPath, "TopLeft", "TopLeft", (StartX + (Num * btnW)), 426);
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
	setBottomButtonPositions();
	SwitchEquipBox(25);
	return;
}

function InitTabIcon()
{
	m_invenTab.SetButtonOffsetTex(1, "L2UI_CT1.InventoryWnd.Inventory_Tab_Equip", 11, 8);
	m_invenTab.SetButtonOffsetTex(2, "L2UI_CT1.InventoryWnd.Inventory_Tab_Consume", 11, 7);
	m_invenTab.SetButtonOffsetTex(3, "L2UI_CT1.InventoryWnd.Inventory_Tab_Material", 11, 8);
	m_invenTab.SetButtonOffsetTex(4, "L2UI_CT1.InventoryWnd.Inventory_Tab_Etc", 12, 8);
	m_invenTab.SetButtonOffsetTex(5, "L2UI_CT1.InventoryWnd.Inventory_Tab_Quest", 10, 7);
	m_invenTab.SetButtonOffsetTex(6, "L2UI_CT1.InventoryWnd.Inventory_Tab_Artifact", 11, 8);
	return;
}

function SetIconOnSelectTabOrder()
{
	switch(preTabOrder)
	{
		case 1:
			m_invenTab.SetButtonOffsetTex(1, "L2UI_CT1.InventoryWnd.Inventory_Tab_Equip", 11, 8);
			break;
		case 2:
			m_invenTab.SetButtonOffsetTex(2, "L2UI_CT1.InventoryWnd.Inventory_Tab_Consume", 11, 7);
			break;
		case 3:
			m_invenTab.SetButtonOffsetTex(3, "L2UI_CT1.InventoryWnd.Inventory_Tab_Material", 11, 8);
			break;
		case 4:
			m_invenTab.SetButtonOffsetTex(4, "L2UI_CT1.InventoryWnd.Inventory_Tab_Etc", 12, 8);
			break;
		case 5:
			m_invenTab.SetButtonOffsetTex(5, "L2UI_CT1.InventoryWnd.Inventory_Tab_Quest", 10, 7);
			break;
		case 6:
			m_invenTab.SetButtonOffsetTex(6, "L2UI_CT1.InventoryWnd.Inventory_Tab_Artifact", 11, 8);
			break;
		default:
			break;
	}
	preTabOrder = m_invenTab.GetTopIndex();
	switch(preTabOrder)
	{
		case 1:
			m_invenTab.SetButtonOffsetTex(1, "L2UI_CT1.InventoryWnd.Inventory_Tab_Equip_Select", 11, 8);
			break;
		case 2:
			m_invenTab.SetButtonOffsetTex(2, "L2UI_CT1.InventoryWnd.Inventory_Tab_Consume_Select", 11, 7);
			break;
		case 3:
			m_invenTab.SetButtonOffsetTex(3, "L2UI_CT1.InventoryWnd.Inventory_Tab_Material_Select", 11, 8);
			break;
		case 4:
			m_invenTab.SetButtonOffsetTex(4, "L2UI_CT1.InventoryWnd.Inventory_Tab_Etc_Select", 12, 8);
			break;
		case 5:
			m_invenTab.SetButtonOffsetTex(5, "L2UI_CT1.InventoryWnd.Inventory_Tab_Quest_Select", 10, 7);
			break;
		case 6:
			m_invenTab.SetButtonOffsetTex(6, "L2UI_CT1.InventoryWnd.Inventory_Tab_Artifact_Select", 11, 8);
			break;
		default:
			break;
	}
	return;
}

function setBottomButtonPositions()
{
	local int i;

	if(Class'NWindow.UIDATA_PLAYER'.static.HasCrystallizeAbility())
	{
		setBottomButtonPostion(i, m_hBtnCrystallize);
	}
	setBottomButtonPostion(i, ItemAutoPeelBtn);
	setBottomButtonPostion(i, EnchantJewelButton);
	setBottomButtonPostion(i, EnchantArtifactRuneButton);
	setBottomButtonPostion(i, AlchemyOpenerBtn);
	EnchantArtifactRuneButton.ShowWindow();
	EnchantJewelButton.ShowWindow();
	CollectionBtn.HideWindow();
	CollectionPointAni.HideWindow();
	AdenacalculateButton.HideWindow();
	ItemAutoPeelBtn.ShowWindow();
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
	else if((m_selectedItemTab == 6))
	{
		countColor.R = 130;
		countColor.G = 200;
		countColor.B = 240;
		countColor.A = 255;
		Count = (m_ArtifactInvenCount + EquipArtifactItemGetitemNum());
		limit = GetArtifactItemInventoryLimit();
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
	ItemboxUpdate(m_artifactRuneItem, GetArtifactItemInventoryLimit());
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
	ParseInt(param, "artifactInventory", m_MaxArtifactInvenCount);
	m_invenItem.SetExpandItemNum(0, ExtraBeltCount);
	InvenLimitUpdate();
	SetItemCount();
	return;
}

function SetArtifactActiveSet(int setNum, bool IsActive)
{
	if(IsActive)
	{
		m_Artifact_Active[setNum].ShowWindow();
	}
	else
	{
		m_Artifact_Active[setNum].HideWindow();
	}
	HandleShowHideArtifactPanelTextureBySetNum(setNum, IsActive);
	return;
}

function SetArtifactActiveStone(int currentStoneState)
{
	m_Artifact_Stone.SetTexture(("L2UI_CT1.InventoryWnd.Inventory_DF_ArtifactBook_Stone_" $ string(currentStoneState)));
	m_Artifact_Stone.SetTooltipCustomType(GetArtifactStoneTooltip(currentStoneState));
	return;
}

function SetArtifactEffectByStoneState(int currentStoneState)
{
	if((_currentStoneState == currentStoneState))
	{
		return;
	}
	switch(currentStoneState)
	{
		case -1:
			SetArtifactBookEffect("", 0, 0, 0);
			break;
		case 0:
			SetArtifactBookEffect("LineageEffect_br.br_e_lamp_deco_d", 240, 0, 0);
			break;
		case 1:
			SetArtifactBookEffect("LineageEffect_br.br_e_lamp_deco_d", 192, 0, 0);
			break;
		case 2:
			SetArtifactBookEffect("LineageEffect_br.br_e_lamp_deco_d", 146, 0, 0);
			break;
		case 3:
			SetArtifactBookEffect("LineageEffect_br.br_e_lamp_deco_d", 100, 0, 0);
			break;
		default:
			SetArtifactBookEffect("", 0, 0, 0);
			break;
	}
	_currentStoneState = currentStoneState;
	return;
}

function HandleShowHideArtifactPanelTextureBySetNum(int setNum, bool IsActive)
{
	switch(setNum)
	{
		case 0:
			HandleShowHideArtifactPanelTexture(50, IsActive);
			HandleShowHideArtifactPanelTexture(53, IsActive);
			HandleShowHideArtifactPanelTexture(56, IsActive);
			HandleShowHideArtifactPanelTexture(38, IsActive);
			HandleShowHideArtifactPanelTexture(39, IsActive);
			HandleShowHideArtifactPanelTexture(40, IsActive);
			HandleShowHideArtifactPanelTexture(41, IsActive);
			break;
		case 1:
			HandleShowHideArtifactPanelTexture(51, IsActive);
			HandleShowHideArtifactPanelTexture(54, IsActive);
			HandleShowHideArtifactPanelTexture(57, IsActive);
			HandleShowHideArtifactPanelTexture(42, IsActive);
			HandleShowHideArtifactPanelTexture(43, IsActive);
			HandleShowHideArtifactPanelTexture(44, IsActive);
			HandleShowHideArtifactPanelTexture(45, IsActive);
			break;
		case 2:
			HandleShowHideArtifactPanelTexture(52, IsActive);
			HandleShowHideArtifactPanelTexture(55, IsActive);
			HandleShowHideArtifactPanelTexture(58, IsActive);
			HandleShowHideArtifactPanelTexture(46, IsActive);
			HandleShowHideArtifactPanelTexture(47, IsActive);
			HandleShowHideArtifactPanelTexture(48, IsActive);
			HandleShowHideArtifactPanelTexture(49, IsActive);
			break;
		default:
			break;
	}
	return;
}

function HandleShowHideArtifactPanelTexture(int idx, bool isShow)
{
	if((m_EquipWindowName == ""))
	{
		return;
	}
	if(isShow)
	{
		GetTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EquipItem_Artifact_Window.") $ m_equipItem[idx].GetWindowName()) $ "_Panel_Texture")).ShowWindow();
	}
	else
	{
		GetTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EquipItem_Artifact_Window.") $ m_equipItem[idx].GetWindowName()) $ "_Panel_Texture")).HideWindow();
	}
	return;
}

function string GetArtifactStonePassive(int State)
{
	local SkillInfo SkillInfo;

	switch(State)
	{
		case 0:
			GetSkillInfo(35227, 1, 0, SkillInfo);
			return SkillInfo.SkillDesc;
		case 1:
			GetSkillInfo(35228, 1, 0, SkillInfo);
			return SkillInfo.SkillDesc;
		case 2:
			GetSkillInfo(35229, 1, 0, SkillInfo);
			return SkillInfo.SkillDesc;
		default:
			return "";
	}
}

function SetArtifactBookEffect(string EffectName, optional int dist, optional int OffsetX, optional int OffsetY)
{
	m_ObjectViewport.SetCameraDistance(dist);
	m_ObjectViewport.SetCharacterOffsetX(OffsetX);
	m_ObjectViewport.SetCharacterOffsetY(OffsetY);
	m_ObjectViewport.ShowWindow();
	m_ObjectViewport.SetSpawnDuration(0.2000000);
	m_ObjectViewport.SetNPCInfo(19671);
	m_ObjectViewport.SetUISound(true);
	m_ObjectViewport.SpawnNPC();
	m_ObjectViewport.SpawnEffect(EffectName);
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
	m_hInventoryWnd.ShowWindow();
	m_hInventoryWnd.SetFocus();
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
	Class'Interface.ItemJewelEnchantWnd'.static.Inst().ToggleShowWindow();
	return;
}

function toggleShowAlchemyWindow(string winName)
{
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(winName))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow(winName);
	}
	else
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(winName);
	}
	return;
}

function toggleAlchemyOpener()
{
	if(AlchemyOpenerWindow.IsShowWindow())
	{
		AlchemyOpenerWindow.HideWindow();
	}
	else
	{
		AlchemyOpenerWindow.ShowWindow();
	}
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
		case 37:
			EquipItem_Artifact_Button.HideWindow();
			break;
		case -1:
			if((m_SelectedExpandEquipIdx == 37))
			{
				if((m_SelectedExpandEquipIdxPrev != 37))
				{
					idx = m_SelectedExpandEquipIdxPrev;
				}
			}
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
	ArtifactWindow.HideWindow();
	SetHandleHairAccessory();
	switch(idx)
	{
		case 16:
			m_TalismanAllow.SetAnchor(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ m_equipItem[idx].GetWindowName()), "TopLeft", "TopLeft", -6, -12);
			break;
		case 15:
			AgathionWindow.ShowWindow();
			AgathionWindow.SetFocus();
			m_TalismanAllow.SetAnchor(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ m_equipItem[idx].GetWindowName()), "TopLeft", "TopLeft", -6, -12);
			break;
		case 25:
			JewelWindow.ShowWindow();
			JewelWindow.SetFocus();
			m_TalismanAllow.SetAnchor(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ m_equipItem[idx].GetWindowName()), "TopLeft", "TopLeft", -6, -12);
			break;
		case 37:
			ArtifactWindow.ShowWindow();
			ArtifactWindow.SetFocus();
			ViewAccessoryButton.HideWindow();
			ViewHairButton.HideWindow();
			m_TalismanAllow.SetAnchor(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ m_equipItem[idx].GetWindowName()), "TopLeft", "TopLeft", -6, -12);
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
	if(m_hInventoryWnd.IsShowWindow())
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
	local int Index;
	local ItemWindowHandle tmpInven, detailItemWindow;

	if(IsQuestItem(NewItem))
	{
		tmpInven = m_questItem;
		Index = tmpInven.FindItem(NewItem.Id);
	}
	else if(IsArtifactRuneItem(NewItem))
	{
		if(!m_artifactRuneItem.IsShowWindow())
		{
			m_invenTab.SetButtonBlink(6, true);
		}
		tmpInven = m_artifactRuneItem;
		Index = m_artifactRuneItem.FindItem(NewItem.Id);
	}
	else
	{
		tmpInven = m_invenItem;
		detailItemWindow = GetItemWindowHandleByItemType(NewItem);
		Index = detailItemWindow.FindItem(NewItem.Id);
		if((Index != -1))
		{
			detailItemWindow.SetNewlyAcquired(Index, true);
		}
		Index = tmpInven.FindItem(NewItem.Id);
	}
	if((Index != -1))
	{
		tmpInven.SetNewlyAcquired(Index, true);
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
	local int Index;
	local ItemWindowHandle tmpInven, detailItemWindow;

	if(IsQuestItem(DelItem))
	{
		tmpInven = m_questItem;
		Index = tmpInven.FindItem(DelItem.Id);
	}
	else if(IsArtifactRuneItem(DelItem))
	{
		tmpInven = m_artifactRuneItem;
		Index = m_artifactRuneItem.FindItem(DelItem.Id);
	}
	else
	{
		tmpInven = m_invenItem;
		detailItemWindow = GetItemWindowHandleByItemType(DelItem);
		Index = detailItemWindow.FindItem(DelItem.Id);
		if((Index != -1))
		{
			detailItemWindow.SetNewlyAcquired(Index, false);
		}
		Index = tmpInven.FindItem(DelItem.Id);
	}
	if((Index != -1))
	{
		tmpInven.SetNewlyAcquired(Index, false);
	}
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
	while((i < EQUIPITEM_Max))
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
	m_hInventoryWnd.HideWindow();
	ItemAutoPeelWnd(GetScript("ItemAutoPeelWnd")).RegisterItem(itemServerID, isAllItem);
	return;
}

function _Handle_S_EX_NEW_HENNA_LIST(UIPacket._S_EX_NEW_HENNA_LIST henna_list_packet)
{
	return;
}

function _Handle_S_EX_NEW_HENNA_POTEN_SELECT(UIPacket._S_EX_NEW_HENNA_POTEN_SELECT packet)
{
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

function CustomTooltip GetArtifactStoneTooltip(int currentStoneState)
{
	local CustomTooltip t;
	local L2Util util;
	local string lv, Title, passiveDesc, lvString;
	local int i;
	local Color c0, c1;
	local int nWidth, nHeight, nWidthMax;

	util = L2Util(GetScript("L2Util"));
	util.setCustomTooltip(t);
	lv = GetSystemString(2980);
	if((currentStoneState > 0))
	{
		Title = ((lv @ string(currentStoneState)) @ GetSystemString(3882));
	}
	else
	{
		Title = GetSystemString(3883);
	}
	c0.R = 221;
	c0.G = 221;
	c0.B = 221;
	c0.A = 255;
	util.ToopTipInsertColorText(Title, true, false, c0);
	util.TooltipInsertItemBlank(2);
	util.TooltipInsertItemLine();
	c0.R = 255;
	c0.G = 180;
	c0.B = 0;
	c0.A = 255;
	c1.R = 200;
	c1.G = 200;
	c1.B = 200;
	c1.A = 255;
	i = 0;
	while((i < currentStoneState))
	{
		lvString = ((lv @ string((i + 1))) @ ": ");
		passiveDesc = GetArtifactStonePassive(i);
		util.TooltipInsertItemBlank(4);
		util.ToopTipInsertColorText(lvString, true, true, c0);
		util.ToopTipInsertColorText(passiveDesc, false, false, c1);
		GetTextSizeDefault((lvString $ passiveDesc), nWidth, nHeight);
		if((nWidthMax < nWidth))
		{
			nWidthMax = nWidth;
		}
		i++;
	}
	c0.R = 100;
	c0.G = 70;
	c0.B = 0;
	c0.A = 255;
	c1.R = 68;
	c1.G = 68;
	c1.B = 68;
	c1.A = 255;
	i = i;
	while((i < 3))
	{
		lvString = ((lv @ string((i + 1))) @ ": ");
		passiveDesc = GetArtifactStonePassive(i);
		util.TooltipInsertItemBlank(4);
		util.ToopTipInsertColorText(lvString, true, true, c0);
		util.ToopTipInsertColorText(passiveDesc, false, false, c1);
		GetTextSizeDefault((lvString $ passiveDesc), nWidth, nHeight);
		if((nWidthMax < nWidth))
		{
			nWidthMax = nWidth;
		}
		i++;
	}
	if((nWidthMax > 405))
	{
		nWidthMax = 405;
	}
	util.ToopTipMinWidth(nWidthMax);
	return util.getCustomToolTip();
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

function setCustomTooltip()
{
	local L2Util util;
	local CustomTooltip t;

	util = L2Util(GetScript("L2Util"));
	util.setCustomTooltip(t);
	util.ToopTipMinWidth(150);
	util.ToopTipInsertText(GetSystemString(3265), true, false);
	util.TooltipInsertItemBlank(4);
	util.ToopTipInsertText(GetSystemString(3270), false, true, COLOR_GRAY);
	AlchemyMixCubeWndBtn.SetTooltipCustomType(util.getCustomToolTip());
	util.setCustomTooltip(t);
	util.ToopTipMinWidth(150);
	util.ToopTipInsertText(GetSystemString(3266), true, false);
	util.TooltipInsertItemBlank(4);
	util.ToopTipInsertText(GetSystemString(3271), false, true, COLOR_GRAY);
	AlchemyItemConversionWndBtn.SetTooltipCustomType(util.getCustomToolTip());
	AlchemyItemCreateWndBtn.DisableWindow();
	util.setCustomTooltip(t);
	util.ToopTipInsertText(GetSystemString(3312), true, false);
	util.TooltipInsertItemBlank(4);
	util.ToopTipInsertText(GetSystemString(3272), false, true, COLOR_GRAY);
	AlchemyItemCreateWndBtn.SetTooltipCustomType(util.getCustomToolTip());
	return;
}

function toggleAlchemyOpenerTooltip(bool isOn)
{
	local L2Util util;
	local CustomTooltip t;

	util = L2Util(GetScript("L2Util"));
	util.setCustomTooltip(t);
	util.ToopTipInsertText(GetSystemString(3257), true, false);
	if(!isOn)
	{
		util.ToopTipMinWidth(150);
		util.TooltipInsertItemBlank(4);
		util.ToopTipInsertText(GetSystemMessage(4263), false, true, COLOR_GRAY);
	}
	AlchemyOpenerBtn.SetTooltipCustomType(util.getCustomToolTip());
	return;
}

function bool IsSigil(ItemInfo a_Info)
{
	if((int(byte(a_Info.ArmorType)) == 4))
	{
		return true;
	}
	return false;
}

function int GetArtifactEmptySlotIdxBySlotBit(ItemInfo a_Info)
{
	local int Index;

	Index = -1;
	switch(a_Info.SlotBitType)
	{
		case INT64(1024):
		case INT64(4194304):
		case INT64(33554432):
		case INT64(268435456):
			Index = GetArtifactIndex(a_Info.Id);
		default:
			if((Index == -1))
			{
				return FindNextEmptyArtifactIndex();
			}
			else
			{
				return (38 + Index);
			}
	}
}

function SortArtifactSlot()
{
	local array<ItemInfo> artifactItems;
	local ItemInfo iInfo;
	local int i;

	i = 38;
	while((i <= 58))
	{
		if(m_equipItem[i].GetItem(0, iInfo))
		{
			m_equipItem[i].Clear();
			artifactItems[artifactItems.Length] = iInfo;
		}
		i++;
	}
	i = 0;
	while((i < artifactItems.Length))
	{
		HandleArtifactEquip(artifactItems[i]);
		i++;
	}
	return;
}

function int FindNextEmptyArtifactIndex()
{
	local int i;
	local ItemInfo Info;

	i = 38;
	while((i <= 58))
	{
		if(!m_equipItem[i].GetItem(0, Info))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function ResetArtifactSkillList()
{
	InventoryWndCharacterView(GetScript("InventoryWndCharacterView")).ResetArtifactSkillList();
	return;
}

function string getArtifactSlotBitTypeString(string keyword)
{
	switch(keyword)
	{
		case "A01":
			return "4398046511104";
		case "A02":
			return "8796093022208";
		case "A03":
			return "17592186044416";
		case "A04":
			return "35184372088832";
		case "A05":
			return "70368744177664";
		case "A06":
			return "140737488355328";
		case "A07":
			return "281474976710656";
		case "A08":
			return "562949953421312";
		case "A09":
			return "1125899906842624";
		case "A10":
			return "2251799813685248";
		case "A11":
			return "4503599627370496";
		case "A12":
			return "9007199254740992";
		case "B01":
			return "18014398509481984";
		case "B02":
			return "36028797018963968";
		case "B03":
			return "72057594037927936";
		case "C01":
			return "144115188075855872";
		case "C02":
			return "288230376151711744";
		case "C03":
			return "576460752303423488";
		case "D01":
			return "1152921504606846976";
		case "D02":
			return "2305843009213693952";
		case "D03":
			return "4611686018427387904";
		default:
			return "";
	}
}

function string getAgathionSlotBitTypeString(string keyword)
{
	switch(keyword)
	{
		case "n":
			return "68719476736";
			break;
		case "1":
			return "137438953472";
			break;
		case "2":
			return "274877906944";
			break;
		case "3":
			return "549755813888";
			break;
		case "4":
			return "1099511627776";
			break;
		default:
			break;
	}
	return "";
}

function ItemWindowHandle getItemWindowHandleBystrTarget(string strTarget)
{
	switch(strTarget)
	{
		case "InventoryItem":
			return m_invenItem;
			break;
		case "InventoryItem_1":
			return m_invenItem_1;
			break;
		case "InventoryItem_2":
			return m_invenItem_2;
			break;
		case "InventoryItem_3":
			return m_invenItem_3;
			break;
		case "InventoryItem_4":
			return m_invenItem_4;
			break;
		case "ArtifactItem":
			return m_artifactRuneItem;
			break;
		default:
			break;
	}
}

function ItemWindowHandle GetItemWindowHandleByItemType(ItemInfo item)
{
	if(!IsValidItemID(item.Id))
	{
		return none;
	}
	switch(Class'NWindow.UIDATA_ITEM'.static.GetInventoryType(item.Id.ClassID))
	{
		case EIIT_EQUIPMENT:
			return m_invenItem_1;
			break;
		case EIIT_CONSUMABLE:
			return m_invenItem_2;
			break;
		case EIIT_MATERIAL:
			return m_invenItem_3;
			break;
		case EIIT_ETC:
		case EIIT_NONE:
			return m_invenItem_4;
			break;
		case EIIT_QUEST:
			return m_questItem;
		default:
			break;
	}
	return none;
}

function int _GetSwapSelectButtonIndex()
{
	return -1;
}

function _ResetbRequestHennaOnShow()
{
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
	while((i < 21))
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
	while((i < 21))
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
	local string texturePath;
	local int lv;

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
			return "L2UI_NewTex.InventoryWnd.InventoryEnchantAniLive_Red0000";
		case 2:
			return "L2UI_NewTex.InventoryWnd.InventoryEnchantAniLive_Purple0000";
		case 3:
			return "L2UI_NewTex.InventoryWnd.InventoryEnchantAniLive_Gold0000";
		case 4:
			return "L2UI_NewTex.InventoryWnd.InventoryEnchantAniLive_Green0000";
		case 101:
			return "L2UI_NewTex.InventoryWnd.InventoryEnchantAniLive_Dragon0000";
		default:
			return "";
	}
}

function AnimTextureHandle GetInventoryEffectLevelAnimTextureByItemWIndow(ItemWindowHandle iWnd)
{
	local int i, Index;

	i = 0;
	while((i < 21))
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
		case 17:
			return 25;
		case 18:
			return 15;
		case 19:
			return 16;
		case 20:
			return 37;
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
		case 25:
			return 17;
		case 15:
			return 18;
		case 16:
			return 19;
		case 37:
			return 20;
		default:
			return -1;
	}
}

function _HandleShowDevTool()
{
	return;
}

function _HandleHideDevTool()
{
	return;
}

function API_UseItemWithInfo(ItemInfo iInfo)
{
	UseItemWithInfo(iInfo);
	return;
}
