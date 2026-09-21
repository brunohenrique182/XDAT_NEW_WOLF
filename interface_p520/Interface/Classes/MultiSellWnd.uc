class MultiSellWnd extends UICommonAPI;

const DIALOG_ASK_PRICE = 1123;
const MULTISELLWND_DIALOG_OK = 1122;
const VIS_ITEM_ID = 60793;
const MAXBUY_NUM = 1000000;
const OFFSET_X_ICON_TEXTURE = 0;
const OFFSET_Y_ICON_TEXTURE = 4;
const OFFSET_Y_SECONDLINE = -14;
const ROOTNAME = "root";
const treeName = "tree";
const ITEMNAME_TOTAL_WIDTH = 240;
const TIMER_UPDATE_ID = 1235552;
const TIMER_UPDATEDELAY = 10;

struct NoStackableItemData
{
	var int ClassID;
	var INT64 Count;
};

struct multiSellData
{
	var int PcCafePoint;
	var int clanPoint;
	var int PvPPoint;
	var int RaidPoint;
	var int craftPoint;
	var int visPoint;
	var INT64 vitalityPoint;
	var INT64 Adena;
};

var WindowHandle Me;
var TextBoxHandle ItemInfo_Text;
var TextBoxHandle NeedItem_Text;
var TextBoxHandle ExchangeNum_Text;
var TextBoxHandle DescriptionMsg_Text;
var TabHandle multiSellTab;
var WindowHandle MultisellTabTotalWnd;
var ItemWindowHandle MultisellTabTotalWnd_ItemWindow;
var RichListCtrlHandle MultisellTabTotalWnd_ListCtrl;
var WindowHandle MultisellTabEnableWnd;
var ItemWindowHandle MultisellTabEnableWnd_ItemWindow;
var RichListCtrlHandle MultisellTabEnableWnd_ListCtrl;
var WindowHandle disableWnd;
var EditBoxHandle Search_EditBox;
var EditBoxHandle ItemCount_EditBox;
var ButtonHandle InventoryViewerCall_Button;
var ButtonHandle Search_button;
var ButtonHandle Refrash_Button;
var ButtonHandle Clear_Button;
var ButtonHandle ExChange_Button;
var ButtonHandle Close_Button;
var ButtonHandle IconTabIcon_Button;
var ButtonHandle ListTabIcon_Button;
var ButtonHandle MultiSell_Up_Button;
var ButtonHandle MultiSell_Down_Button;
var ButtonHandle MultiSell_Input_Button;
var int toFindClassID;
var string m_Windowname;
var WindowHandle BuyItemRichListCtrl;
var UIControlNeedItemList needItemScript;
var RichListCtrlHandle NeedRichListCtrl;
var WindowHandle inputItemWnd;
var UIControlNumberInput inputItemScript;
var array<UIConstants.MultiSellInfo> m_MultiSellInfoList;
var int m_MultiSellGroupID;
var int m_nSelectedMultiSellInfoIndex;
var int m_nCurrentMultiSellInfoIndex;
var UserInfo PlayerInfo;
var multiSellData mData;
var L2Util util;
var UIData UIDataScript;
var bool bFirstAdd;
var bool bClose;
var int nShowAll;
var int nRepeat;
var int nKeepEnchant;
var int nShowEnsoul;
var int nVariationItem;
var int nRepeatTimeCurrentInputItemInfoIndex;
var ItemInfo lastSelectItemInfo;
var string dialogMessage;
var int tickIndex;
var int tickItemListIndex;
var string searchStr;
var bool searchMode;
var bool bForceUpdate;
var int ShowType;
var int _tempShowType;

function OnRegisterEvent()
{
	RegisterEvent(2530);
	RegisterEvent(2535);
	RegisterEvent(2540);
	RegisterEvent(2550);
	RegisterEvent(2560);
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent(2565);
	RegisterEvent(180);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int nX, int nY)
{
	if(GetWindowHandle("InventoryViewer").IsShowWindow())
	{
		GetWindowHandle("InventoryViewer").BringToFront();
		if(GetWindowHandle("DialogBox").IsShowWindow())
		{
			GetWindowHandle("DialogBox").SetFocus();
		}
	}
	return;
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	getInstanceInventoryViewer().showWindowByParentWindow(Me);
	bFirstAdd = true;
	Search_EditBox.SetString("");
	disableWindowWithText(false, "");
	disableWnd.HideWindow();
	inputItemScript.SetCount(INT64(0));
	MultiSell_Input_Button.DisableWindow();
	return;
}

function OnHide()
{
	local ItemInfo nullInfo;

	lastSelectItemInfo = nullInfo;
	bClose = false;
	Me.DisableTick();
	if(DialogIsMine())
	{
		DialogHide();
	}
	Me.KillTimer(1235552);
	iniListWithItemWindow();
	if(GetWindowHandle("InventoryViewer").IsShowWindow())
	{
		GetWindowHandle("InventoryViewer").HideWindow();
	}
	needItemScript.CleariObjects();
	return;
}

function Initialize()
{
	util = L2Util(GetScript("L2Util"));
	UIDataScript = UIData(GetScript("UIData"));
	Me = GetWindowHandle("MultiSellWnd");
	disableWnd = GetWindowHandle("MultiSellWnd.DisableWnd");
	ItemInfo_Text = GetTextBoxHandle("MultiSellWnd.ItemInfo_Text");
	NeedItem_Text = GetTextBoxHandle("MultiSellWnd.NeedItem_Text");
	ExchangeNum_Text = GetTextBoxHandle("MultiSellWnd.ExchangeNum_Text");
	DescriptionMsg_Text = GetTextBoxHandle("MultiSellWnd.DescriptionMsgWnd.DescriptionMsg_Text");
	multiSellTab = GetTabHandle("MultiSellWnd.MultiSellTab");
	MultisellTabTotalWnd = GetWindowHandle("MultiSellWnd.MultisellTabTotalWnd");
	MultisellTabTotalWnd_ListCtrl = GetRichListCtrlHandle("MultiSellWnd.MultisellTabTotalWnd.MultisellTabTotalWnd_ListCtrl");
	MultisellTabTotalWnd_ItemWindow = GetItemWindowHandle("MultiSellWnd.MultisellTabTotalWnd.MultisellTabTotalWnd_ItemWindow");
	MultisellTabEnableWnd = GetWindowHandle("MultiSellWnd.MultisellTabEnableWnd");
	MultisellTabEnableWnd_ListCtrl = GetRichListCtrlHandle("MultiSellWnd.MultisellTabEnableWnd.MultisellTabEnableWnd_ListCtrl");
	MultisellTabEnableWnd_ItemWindow = GetItemWindowHandle("MultiSellWnd.MultisellTabEnableWnd.MultisellTabEnableWnd_ItemWindow");
	Search_EditBox = GetEditBoxHandle("MultiSellWnd.Search_EditBox");
	ItemCount_EditBox = GetEditBoxHandle("MultiSellWnd.inputItemWnd.ItemCount_EditBox");
	BuyItemRichListCtrl = GetWindowHandle("MultiSellWnd.BuyItemRichListCtrl");
	NeedRichListCtrl = GetRichListCtrlHandle("MultiSellWnd.BuyItemRichListCtrl.NeedRichListCtrl");
	inputItemWnd = GetWindowHandle("MultiSellWnd.InputItemWnd");
	Search_button = GetButtonHandle("MultiSellWnd.Search_Button");
	Refrash_Button = GetButtonHandle("MultiSellWnd.Refrash_Button");
	Clear_Button = GetButtonHandle("MultiSellWnd.Clear_Button");
	ExChange_Button = GetButtonHandle("MultiSellWnd.ExChange_Button");
	Close_Button = GetButtonHandle("MultiSellWnd.Close_Button");
	IconTabIcon_Button = GetButtonHandle("MultiSellWnd.IconTabIcon_Button");
	ListTabIcon_Button = GetButtonHandle("MultiSellWnd.ListTabIcon_Button");
	MultiSell_Up_Button = GetButtonHandle("MultiSellWnd.inputItemWnd.MultiSell_Up_Button");
	MultiSell_Down_Button = GetButtonHandle("MultiSellWnd.inputItemWnd.MultiSell_Down_Button");
	MultiSell_Input_Button = GetButtonHandle("MultiSellWnd.MultiSell_Input_Button_2");
	InventoryViewerCall_Button = GetButtonHandle("MultiSellWnd.InventoryViewerCall_Button");
	MultisellTabTotalWnd_ListCtrl.SetSelectedSelTooltip(false);
	MultisellTabTotalWnd_ListCtrl.SetAppearTooltipAtMouseX(true);
	MultisellTabEnableWnd_ListCtrl.SetSelectedSelTooltip(false);
	MultisellTabEnableWnd_ListCtrl.SetAppearTooltipAtMouseX(true);
	IconTabIcon_Button.SetTooltipText(GetSystemString(3397));
	ListTabIcon_Button.SetTooltipText(GetSystemString(3397));
	toggleListWithIconWindow(true);
	InitNeedItem();
	InitInputControl();
	return;
}

function toggleListWithIconWindow(optional bool bInit)
{
	if(bInit)
	{
		IconTabIcon_Button.HideWindow();
		ListTabIcon_Button.ShowWindow();
	}
	if(ListTabIcon_Button.IsShowWindow())
	{
		IconTabIcon_Button.ShowWindow();
		ListTabIcon_Button.HideWindow();
		MultisellTabTotalWnd_ItemWindow.HideWindow();
		MultisellTabTotalWnd_ListCtrl.ShowWindow();
		MultisellTabEnableWnd_ItemWindow.HideWindow();
		MultisellTabEnableWnd_ListCtrl.ShowWindow();
		GetTextureHandle("MultiSellWnd.MultisellTabTotalWnd.listSlotBg1_Texture_MultisellTabIconWnd").HideWindow();
		GetTextureHandle("MultiSellWnd.MultisellTabTotalWnd.listSlotBg2_Texture_MultisellTabIconWnd").HideWindow();
		GetTextureHandle("MultiSellWnd.MultisellTabEnableWnd.listSlotBg1_Texture_MultisellTabIconWnd").HideWindow();
		GetTextureHandle("MultiSellWnd.MultisellTabEnableWnd.listSlotBg2_Texture_MultisellTabIconWnd").HideWindow();
		GetTextureHandle("MultiSellWnd.MultisellTabEnableWnd.listGroupBg_Texture_MultisellTabIistWnd").ShowWindow();
		GetTextureHandle("MultiSellWnd.MultisellTabTotalWnd.listGroupBg_Texture_MultisellTabIistWnd").ShowWindow();
	}
	else
	{
		IconTabIcon_Button.HideWindow();
		ListTabIcon_Button.ShowWindow();
		MultisellTabTotalWnd_ListCtrl.HideWindow();
		MultisellTabTotalWnd_ItemWindow.ShowWindow();
		MultisellTabEnableWnd_ListCtrl.HideWindow();
		MultisellTabEnableWnd_ItemWindow.ShowWindow();
		GetTextureHandle("MultiSellWnd.MultisellTabTotalWnd.listSlotBg1_Texture_MultisellTabIconWnd").ShowWindow();
		GetTextureHandle("MultiSellWnd.MultisellTabTotalWnd.listSlotBg2_Texture_MultisellTabIconWnd").ShowWindow();
		GetTextureHandle("MultiSellWnd.MultisellTabEnableWnd.listSlotBg1_Texture_MultisellTabIconWnd").ShowWindow();
		GetTextureHandle("MultiSellWnd.MultisellTabEnableWnd.listSlotBg2_Texture_MultisellTabIconWnd").ShowWindow();
		GetTextureHandle("MultiSellWnd.MultisellTabEnableWnd.listGroupBg_Texture_MultisellTabIistWnd").HideWindow();
		GetTextureHandle("MultiSellWnd.MultisellTabTotalWnd.listGroupBg_Texture_MultisellTabIistWnd").HideWindow();
	}
	return;
}

function InitNeedItem()
{
	BuyItemRichListCtrl.SetScript("UIControlNeedItemList");
	needItemScript = UIControlNeedItemList(BuyItemRichListCtrl.GetScript());
	needItemScript.SetRichListControler(NeedRichListCtrl);
	return;
}

function InitInputControl()
{
	inputItemWnd.SetScript("UIControlNumberInput");
	inputItemScript = UIControlNumberInput(inputItemWnd.GetScript());
	inputItemScript.Init((m_Windowname $ ".inputItemWnd"));
	inputItemScript.DelegateGetCountCanBuy = MaxNumCanBuy;
	inputItemScript.delegateOnItemCountEdited = OnItemCountChanged;
	inputItemScript.DelegateESCKey = OnESCKey;
	inputItemScript.Reset_Btn = GetButtonHandle((m_Windowname $ ".inputItemWnd.Reset_Btn"));
	inputItemScript.Buy_Btn = GetButtonHandle((m_Windowname $ ".ExChange_Button"));
	MultiSell_Up_Button.DisableWindow();
	MultiSell_Down_Button.DisableWindow();
	MultiSell_Input_Button.DisableWindow();
	return;
}

function INT64 MaxNumCanBuy()
{
	local RichListCtrlRowData rowData;
	local int Index;
	local INT64 Count;

	if((multiSellTab.GetTopIndex() == 0))
	{
		Index = MultisellTabTotalWnd_ListCtrl.GetSelectedIndex();
		MultisellTabTotalWnd_ListCtrl.GetRec(Index, rowData);
	}
	else
	{
		Index = MultisellTabEnableWnd_ListCtrl.GetSelectedIndex();
		MultisellTabEnableWnd_ListCtrl.GetRec(Index, rowData);
	}
	if(IsStackableItem(int(rowData.nReserved1)))
	{
		Count = Min64(needItemScript.GetMaxNumCanBuy(), INT64(1000000));
	}
	else
	{
		Count = Min64(INT64(1), Min64(needItemScript.GetMaxNumCanBuy(), INT64(1000000)));
	}
	return Count;
}

function OnItemCountChanged(INT64 ItemCount)
{
	ItemCount = MAX64(INT64(1), ItemCount);
	needItemScript.SetBuyNum(ItemCount);
	return;
}

function OnEvent(int Event_ID, string param)
{
	local UserInfo UserInfo;
	local bool isValidType;

	if((Event_ID == 2530))
	{
		ParseInt(param, "ShowType", _tempShowType);
	}
	if(((_tempShowType != 3) && (_tempShowType != 4)))
	{
		ShowType = _tempShowType;
		switch(Event_ID)
		{
			case 2530:
				if(!bClose)
				{
					HandleMultiSellInfoListBegin(param);
				}
				break;
			case 2535:
				if(!bClose)
				{
					HandleMultiSellResultItemInfo(param);
				}
				break;
			case 2540:
				if(!bClose)
				{
					HandelMultiSellOutputItemInfo(param);
				}
				break;
			case 2550:
				if(!bClose)
				{
					HandelMultiSellInputItemInfo(param);
				}
				break;
			case 2560:
				Me.DisableTick();
				Me.KillTimer(1235552);
				if(bClose)
				{
					Me.HideWindow();
				}
				else
				{
					HandleMultiSellInfoListEnd(param);
					if(getInstanceUIData().GetIsClassicServer())
					{
						if((nShowAll == 0))
						{
							multiSellTab.SetTopOrder(1, true);
						}
						else
						{
							multiSellTab.SetTopOrder(0, true);
						}
					}
					ShowItemList();
				}
				break;
			case 2565:
				HandleMultiSellResult(param);
				break;
			default:
				break;
		}
	}
	switch(Event_ID)
	{
		case 1710:
			HandleDialogOK(true);
			break;
		case 1720:
			HandleDialogOK(false);
			break;
		case 180:
			if(Me.IsShowWindow())
			{
				if(GetPlayerInfo(UserInfo))
				{
					mData.vitalityPoint = INT64(UserInfo.nVitality);
				}
			}
			break;
		default:
			break;
	}
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 1235552))
	{
		if(isExchangeWindowState())
		{
			setSelectItem(lastSelectItemInfo);
		}
		updateUIControl();
		Me.KillTimer(1235552);
	}
	return;
}

function ClearAll()
{
	Me.KillTimer(1235552);
	m_nCurrentMultiSellInfoIndex = 0;
	m_MultiSellInfoList.Length = 0;
	m_MultiSellGroupID = 0;
	disableWindowWithText(false, "");
	disableWnd.HideWindow();
	iniListWithItemWindow();
	return;
}

function iniListWithItemWindow()
{
	MultisellTabTotalWnd_ListCtrl.DeleteAllItem();
	MultisellTabTotalWnd_ItemWindow.Clear();
	MultisellTabEnableWnd_ItemWindow.Clear();
	MultisellTabEnableWnd_ListCtrl.DeleteAllItem();
	return;
}

function HandleMultiSellInfoListBegin(string param)
{
	local ItemInfo nullInfo;

	ParseInt(param, "ShowAll", nShowAll);
	ParseInt(param, "Repeat", nRepeat);
	ParseInt(param, "KeepEnchant", nKeepEnchant);
	ParseInt(param, "ShowEnsoul", nShowEnsoul);
	ParseInt(param, "VariationItem", nVariationItem);
	if(!((nRepeat == 1) && (nShowAll == 1)))
	{
		bFirstAdd = true;
		ClearAll();
	}
	Debug(("---> HandleMultiSellInfoListBegin" @ param));
	if((nRepeat == 0))
	{
		lastSelectItemInfo = nullInfo;
	}
	ParseInt(param, "MultiSellGroupID", m_MultiSellGroupID);
	if((nRepeat == 1))
	{
		m_nCurrentMultiSellInfoIndex = 0;
		m_MultiSellInfoList.Length = 0;
	}
	ParseInt(param, "ShowType", ShowType);
	Debug(("ShowType" @ string(ShowType)));
	switch(ShowType)
	{
		case 0:
			multiSellTab.SetButtonName(1, GetSystemString(3396));
			setWindowTitleByString(GetSystemString(136));
			ExChange_Button.SetButtonName(445);
			break;
		case 1:
			multiSellTab.SetButtonName(1, GetSystemString(13183));
			setWindowTitleByString(GetSystemString(645));
			ExChange_Button.SetButtonName(645);
			break;
		case 2:
			multiSellTab.SetButtonName(1, GetSystemString(3396));
			setWindowTitleByString(GetSystemString(13161));
			ExChange_Button.SetButtonName(445);
			break;
		default:
			break;
	}
	return;
}

function HandleMultiSellResult(string param)
{
	local int Success;

	if(Me.IsShowWindow())
	{
		Me.DisableTick();
		Me.KillTimer(1235552);
		if(((dialogMessage == GetSystemMessage(4363)) && (hasExceptionMultiSellID() == false)))
		{
			bClose = true;
		}
		else
		{
			ParseInt(param, "Success", Success);
			getCurrentSelectedItemInfo(lastSelectItemInfo);
			updateMultiSellData(param);
			bClose = false;
		}
	}
	return;
}

function bool hasExceptionMultiSellID()
{
	local bool bFlag;

	switch(m_MultiSellGroupID)
	{
		case 903:
			bFlag = true;
		case 2196:
			bFlag = true;
		default:
			return bFlag;
	}
}

function HandleMultiSellResultItemInfo(string param)
{
	local int nMultiSellInfoID, nBuyType, nIsBlessedItem;
	local ItemInfo Info;
	local int ensoulNormalSlot, ensoulBmSlot;

	ParseInt(param, "MultiSellInfoID", nMultiSellInfoID);
	ParseInt(param, "BuyType", nBuyType);
	ParseInt(param, "Enchanted", Info.Enchanted);
	ParseInt(param, "RefineryOp1", Info.RefineryOp1);
	ParseInt(param, "RefineryOp2", Info.RefineryOp2);
	ParseInt(param, "RefineryOp3", Info.RefineryOp3);
	ParseInt(param, "AttackAttributeType", Info.AttackAttributeType);
	ParseInt(param, "AttackAttributeValue", Info.AttackAttributeValue);
	ParseInt(param, "DefenseAttributeValueFire", Info.DefenseAttributeValueFire);
	ParseInt(param, "DefenseAttributeValueWater", Info.DefenseAttributeValueWater);
	ParseInt(param, "DefenseAttributeValueWind", Info.DefenseAttributeValueWind);
	ParseInt(param, "DefenseAttributeValueEarth", Info.DefenseAttributeValueEarth);
	ParseInt(param, "DefenseAttributeValueHoly", Info.DefenseAttributeValueHoly);
	ParseInt(param, "DefenseAttributeValueUnholy", Info.DefenseAttributeValueUnholy);
	ParseInt(param, ("EnsoulOptionNum_" $ string(2)), ensoulBmSlot);
	ParseInt(param, ("EnsoulOptionNum_" $ string(1)), ensoulNormalSlot);
	addEnsoulInfo(2, ensoulBmSlot, param, Info);
	addEnsoulInfo(1, ensoulNormalSlot, param, Info);
	ParseInt(param, "IsBlessedItem", nIsBlessedItem);
	Info.IsBlessedItem = numToBool(nIsBlessedItem);
	m_nCurrentMultiSellInfoIndex = m_MultiSellInfoList.Length;
	m_MultiSellInfoList.Length = (m_MultiSellInfoList.Length + 1);
	nRepeatTimeCurrentInputItemInfoIndex = 0;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID = nMultiSellInfoID;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellType = nBuyType;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].ResultItemInfo = Info;
	return;
}

function HandelMultiSellOutputItemInfo(string param)
{
	local int nMultiSellInfoID, nCurrentOutputItemInfoIndex, nIsBlessedItem;
	local ItemInfo Info;
	local int nItemClassID, ensoulNormalSlot, ensoulBmSlot;

	ParseItemID(param, Info.Id);
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(Info.Id, Info);
	ParseInt(param, "ClassID", nItemClassID);
	ParseInt(param, "MultiSellInfoID", nMultiSellInfoID);
	ParseINT64(param, "SlotBitType", Info.SlotBitType);
	ParseInt(param, "ItemType", Info.ItemType);
	ParseINT64(param, "ItemCount", Info.ItemNum);
	ParseInt(param, "Enchanted", Info.Enchanted);
	ParseInt(param, "RefineryOp1", Info.RefineryOp1);
	ParseInt(param, "RefineryOp2", Info.RefineryOp2);
	ParseInt(param, "RefineryOp3", Info.RefineryOp3);
	ParseInt(param, "AttackAttributeType", Info.AttackAttributeType);
	ParseInt(param, "AttackAttributeValue", Info.AttackAttributeValue);
	ParseInt(param, "DefenseAttributeValueFire", Info.DefenseAttributeValueFire);
	ParseInt(param, "DefenseAttributeValueWater", Info.DefenseAttributeValueWater);
	ParseInt(param, "DefenseAttributeValueWind", Info.DefenseAttributeValueWind);
	ParseInt(param, "DefenseAttributeValueEarth", Info.DefenseAttributeValueEarth);
	ParseInt(param, "DefenseAttributeValueHoly", Info.DefenseAttributeValueHoly);
	ParseInt(param, "DefenseAttributeValueUnholy", Info.DefenseAttributeValueUnholy);
	ParseInt(param, ("EnsoulOptionNum_" $ string(2)), ensoulBmSlot);
	ParseInt(param, ("EnsoulOptionNum_" $ string(1)), ensoulNormalSlot);
	addEnsoulInfo(2, ensoulBmSlot, param, Info);
	addEnsoulInfo(1, ensoulNormalSlot, param, Info);
	ParseInt(param, "IsBlessedItem", nIsBlessedItem);
	Info.IsBlessedItem = numToBool(nIsBlessedItem);
	ParseInt(param, "BlessBaseEffectID", Info.BlessBaseEffectID);
	if((m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID != nMultiSellInfoID))
	{
		return;
	}
	if((nItemClassID == -100))
	{
		Info.Name = GetSystemString(1277);
		Info.IconName = GetPcCafeItemIconPackageName();
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if((nItemClassID == -200))
	{
		Info.Name = GetSystemString(1311);
		Info.IconName = "icon.etc_i.etc_bloodpledge_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if((nItemClassID == -300))
	{
		Info.Name = GetSystemString(102);
		Info.IconName = "icon.pvp_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if((nItemClassID == -500))
	{
		Info.Name = GetSystemString(3183);
		Info.IconName = "icon.etc_i.etc_rp_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if((nItemClassID == -600))
	{
		Info.Name = GetSystemString(13159);
		Info.IconName = "Icon.etc_i.craft_point";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if((nItemClassID == -800))
	{
		Info.Name = GetSystemString(2492);
		Info.IconName = "icon.etc_sayha_point_01";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if((nItemClassID == -1100))
	{
		Info.Name = GetItemInfoByClassID(60793).Name;
		Info.IconName = GetItemInfoByClassID(60793).IconName;
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	if((0 < Info.Durability))
	{
		Info.CurrentDurability = Info.Durability;
	}
	nCurrentOutputItemInfoIndex = m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList.Length;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList.Length = (nCurrentOutputItemInfoIndex + 1);
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList[nCurrentOutputItemInfoIndex] = Info;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList[nCurrentOutputItemInfoIndex].Reserved = m_nCurrentMultiSellInfoIndex;
	return;
}

function HandelMultiSellInputItemInfo(string param)
{
	local int nMultiSellInfoID, nCurrentInputItemInfoIndex, nItemClassID, nIsBlessedItem;
	local ItemInfo Info;
	local int ensoulNormalSlot, ensoulBmSlot;

	ParseItemID(param, Info.Id);
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(Info.Id, Info);
	ParseInt(param, "MultiSellInfoID", nMultiSellInfoID);
	ParseInt(param, "ClassID", nItemClassID);
	ParseInt(param, "ItemType", Info.ItemType);
	ParseINT64(param, "ItemCount", Info.ItemNum);
	ParseInt(param, "Enchanted", Info.Enchanted);
	ParseInt(param, "RefineryOp1", Info.RefineryOp1);
	ParseInt(param, "RefineryOp2", Info.RefineryOp2);
	ParseInt(param, "RefineryOp3", Info.RefineryOp3);
	ParseInt(param, "AttackAttributeType", Info.AttackAttributeType);
	ParseInt(param, "AttackAttributeValue", Info.AttackAttributeValue);
	ParseInt(param, "DefenseAttributeValueFire", Info.DefenseAttributeValueFire);
	ParseInt(param, "DefenseAttributeValueWater", Info.DefenseAttributeValueWater);
	ParseInt(param, "DefenseAttributeValueWind", Info.DefenseAttributeValueWind);
	ParseInt(param, "DefenseAttributeValueEarth", Info.DefenseAttributeValueEarth);
	ParseInt(param, "DefenseAttributeValueHoly", Info.DefenseAttributeValueHoly);
	ParseInt(param, "DefenseAttributeValueUnholy", Info.DefenseAttributeValueUnholy);
	ParseInt(param, ("EnsoulOptionNum_" $ string(2)), ensoulBmSlot);
	ParseInt(param, ("EnsoulOptionNum_" $ string(1)), ensoulNormalSlot);
	addEnsoulInfo(2, ensoulBmSlot, param, Info);
	addEnsoulInfo(1, ensoulNormalSlot, param, Info);
	ParseInt(param, "IsBlessedItem", nIsBlessedItem);
	Info.IsBlessedItem = numToBool(nIsBlessedItem);
	ParseInt(param, "BlessBaseEffectID", Info.BlessBaseEffectID);
	if((m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID != nMultiSellInfoID))
	{
		return;
	}
	if((nItemClassID == -100))
	{
		Info.Name = GetSystemString(1277);
		Info.IconName = GetPcCafeItemIconPackageName();
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if((nItemClassID == -200))
	{
		Info.Name = GetSystemString(1311);
		Info.IconName = "icon.etc_i.etc_bloodpledge_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if((nItemClassID == -300))
	{
		Info.Name = GetSystemString(102);
		Info.IconName = "icon.pvp_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if((nItemClassID == -500))
	{
		Info.Name = GetSystemString(3183);
		Info.IconName = "icon.etc_i.etc_rp_point_i00";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if((nItemClassID == -600))
	{
		Info.Name = GetSystemString(13159);
		Info.IconName = "Icon.etc_i.craft_point";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if((nItemClassID == -800))
	{
		Info.Name = GetSystemString(2492);
		Info.IconName = "icon.etc_sayha_point_01";
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else if((nItemClassID == -1100))
	{
		Info.Name = GetItemInfoByClassID(60793).Name;
		Info.IconName = GetItemInfoByClassID(60793).IconName;
		Info.Enchanted = 0;
		Info.ItemType = -1;
		Info.Id.ClassID = 0;
	}
	else
	{
		Info.Name = Class'NWindow.UIDATA_ITEM'.static.GetItemName(Info.Id);
		Info.IconName = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(Info.Id);
	}
	Info.CrystalType = Class'NWindow.UIDATA_ITEM'.static.GetItemCrystalType(Info.Id);
	if((nItemClassID != -400))
	{
		nCurrentInputItemInfoIndex = m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList.Length;
		m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList.Length = (nCurrentInputItemInfoIndex + 1);
		m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList[nCurrentInputItemInfoIndex] = Info;
	}
	return;
}

function HandleMultiSellInfoListEnd(string param)
{
	if(!Me.IsShowWindow())
	{
		Me.ShowWindow();
	}
	updateMultiSellData();
	return;
}

function OnTick()
{
	tickItemAdd();
	return;
}

function tickItemAdd()
{
	local int ListCnt, totalListCnt;
	local ItemInfo Info;
	local string fullNameString;
	local array<NoStackableItemData> noStackableItemDataArray;
	local bool bNoExchange, bCheck;
	local int arrayIndex, N, needItemNum;
	local UIConstants.MultiSellInfo MultiSellInfo;
	local array<ItemInfo> NeedItemList;
	local ItemInfo NeedItem;

	totalListCnt = m_MultiSellInfoList.Length;
	ListCnt = 0;
	while((ListCnt < 50))
	{
		if((tickItemListIndex >= totalListCnt))
		{
			break;
		}
		MultiSellInfo = m_MultiSellInfoList[tickItemListIndex];
		Info = MultiSellInfo.OutputItemInfoList[0];
		if((bFirstAdd || isExchangeWindowState()))
		{
			Search_EditBox.AddNameToAdditionalSearchList(Info.Name, SLT_ADDITIONAL_LIST);
		}
		fullNameString = GetItemNameAll(Info);
		if(((FindMatchString(fullNameString, searchStr) != -1) || (searchMode == false)))
		{
			bNoExchange = false;
			noStackableItemDataArray.Length = 0;
			NeedItemList = MultiSellInfo.InputItemInfoList;
			needItemNum = NeedItemList.Length;
			N = 0;
			while((N < needItemNum))
			{
				NeedItem = NeedItemList[N];
				if(IsStackableItem(NeedItem.ConsumeType))
				{
					bCheck = CompareWithInven(NeedItem);
				}
				else
				{
					arrayIndex = GetNoStackableItemCountArrayIndex(NeedItem, noStackableItemDataArray);
					bCheck = CompareWithInven(NeedItem, noStackableItemDataArray[arrayIndex]);
				}
				if((bCheck == false))
				{
					bNoExchange = true;
					break;
				}
				N++;
			}
			if((bNoExchange == false))
			{
				Info.ForeTexture = "L2UI_CT1.SellablePanel";
				MultisellTabEnableWnd_ItemWindow.AddItem(Info);
				addItem_RichListCtrl(MultisellTabEnableWnd_ListCtrl, Info);
			}
			if((bFirstAdd || bForceUpdate))
			{
				MultisellTabTotalWnd_ItemWindow.AddItem(Info);
				addItem_RichListCtrl(MultisellTabTotalWnd_ListCtrl, Info);
			}
			else if((isExchangeWindowState() == false))
			{
				MultisellTabTotalWnd_ItemWindow.SetItem(totalListCnt, Info);
			}
		}
		tickItemListIndex++;
		ListCnt++;
	}
	if((tickItemListIndex >= m_MultiSellInfoList.Length))
	{
		Me.DisableTick();
		bFirstAdd = false;
		bForceUpdate = false;
		if(searchMode)
		{
			if((multiSellTab.GetTopIndex() == 0))
			{
				if((MultisellTabTotalWnd_ItemWindow.GetItemNum() <= 0))
				{
					disableWindowWithText(true, MakeFullSystemMsg(GetSystemMessage(4356), searchStr));
				}
				else
				{
					disableWindowWithText(false, "");
				}
			}
			else if((MultisellTabEnableWnd_ItemWindow.GetItemNum() <= 0))
			{
				disableWindowWithText(true, MakeFullSystemMsg(GetSystemMessage(4356), searchStr));
			}
			else
			{
				disableWindowWithText(false, "");
			}
		}
		else if(((multiSellTab.GetTopIndex() == 1) && (MultisellTabEnableWnd_ItemWindow.GetItemNum() <= 0)))
		{
			disableWindowWithText(true, GetSystemMessage(4357));
		}
		else
		{
			disableWindowWithText(false, "");
		}
		Me.KillTimer(1235552);
		Me.SetTimer(1235552, 10);
	}
	return;
}

function ShowItemList()
{
	searchStr = Search_EditBox.GetString();
	if((searchStr != ""))
	{
		searchMode = true;
		bFirstAdd = true;
	}
	else
	{
		searchMode = false;
	}
	needItemScript.CleariObjects();
	Class'NWindow.UIAPI_MULTISELLITEMINFO'.static.Clear("MultiSellWnd.multiSellItemInfo");
	if((bFirstAdd || bForceUpdate))
	{
		iniListWithItemWindow();
		Search_EditBox.ClearAdditionalSearchList(SLT_ADDITIONAL_LIST);
	}
	if(isExchangeWindowState())
	{
		MultisellTabEnableWnd_ItemWindow.Clear();
		MultisellTabEnableWnd_ListCtrl.DeleteAllItem();
	}
	tickItemListIndex = 0;
	Me.EnableTick();
	return;
}

function bool isExchangeWindowState()
{
	return ((multiSellTab.GetTopIndex() == 1) || bForceUpdate);
}

function disableWindowWithText(bool bShow, string msgTxt)
{
	if(bShow)
	{
		DescriptionMsg_Text.SetText(msgTxt);
		GetWindowHandle("MultiSellWnd.DescriptionMsgWnd").ShowWindow();
	}
	else
	{
		GetWindowHandle("MultiSellWnd.DescriptionMsgWnd").HideWindow();
	}
	return;
}

function bool CompareWithInven(ItemInfo Info, optional NoStackableItemData noStackableItemDataInfo)
{
	local ItemInfo InvenItemInfo;
	local bool flag;
	local int hasItemCount;
	local array<ItemInfo> itemInfoArr;

	if((Info.IconName == GetPcCafeItemIconPackageName()))
	{
		if((INT64(mData.PcCafePoint) >= Info.ItemNum))
		{
			return true;
		}
	}
	else if((Info.IconName == "icon.etc_i.etc_bloodpledge_point_i00"))
	{
		if((INT64(mData.clanPoint) >= Info.ItemNum))
		{
			return true;
		}
	}
	else if((Info.IconName == "icon.pvp_point_i00"))
	{
		if((INT64(mData.PvPPoint) >= Info.ItemNum))
		{
			return true;
		}
	}
	else if((Info.IconName == "icon.etc_i.etc_rp_point_i00"))
	{
		if((INT64(mData.RaidPoint) >= Info.ItemNum))
		{
			return true;
		}
	}
	else if((Info.IconName == "Icon.etc_i.craft_point"))
	{
		if((INT64(mData.craftPoint) >= Info.ItemNum))
		{
			return true;
		}
	}
	else if((Info.IconName == "icon.etc_sayha_point_01"))
	{
		if((mData.vitalityPoint >= Info.ItemNum))
		{
			return true;
		}
	}
	else if((Info.IconName == GetItemInfoByClassID(60793).IconName))
	{
		if((INT64(mData.visPoint) >= Info.ItemNum))
		{
			return true;
		}
	}
	else if((Info.Id.ClassID > 0))
	{
		itemInfoArr.Length = 0;
		itemInfoArr = FindItems(Info.Id.ClassID);
		hasItemCount = itemInfoArr.Length;
		if((hasItemCount > 0))
		{
			InvenItemInfo = itemInfoArr[0];
			if(IsStackableItem(InvenItemInfo.ConsumeType))
			{
				if((InvenItemInfo.ItemNum >= Info.ItemNum))
				{
					return true;
				}
			}
			else
			{
				if((noStackableItemDataInfo.ClassID > 0))
				{
					if((noStackableItemDataInfo.Count > INT64(0)))
					{
						flag = true;
					}
				}
				return flag;
			}
		}
	}
	return false;
}

function addItem_RichListCtrl(RichListCtrlHandle itemListCtrl, ItemInfo Info)
{
	local RichListCtrlRowData Record;
	local string fullNameString, toolTipParam;

	fullNameString = GetItemNameAll(Info, true);
	ItemInfoToParam(Info, toolTipParam);
	Record.szReserved = toolTipParam;
	Record.cellDataList.Length = 1;
	Record.nReserved1 = INT64(Info.ConsumeType);
	addRichListCtrlTexture(Record.cellDataList[0].drawitems, "l2ui_ct1.ItemWindow_DF_SlotBox_Default", 36, 36, 8, 1);
	AddRichListCtrlItem(Record.cellDataList[0].drawitems, Info, 32, 32, -34, 1);
	if((Info.IconPanel != ""))
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, Info.IconPanel, 32, 32, -32, 0);
	}
	if(Info.IsBlessedItem)
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, "Icon.icon_panel.bless_panel", 32, 32, -32, 0);
	}
	if((Info.ForeTexture != ""))
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, Info.ForeTexture, 32, 32, -32, 0);
	}
	if(IsStackableItem(Info.ConsumeType))
	{
		fullNameString = makeShortStringByPixel(fullNameString, 192, "..");
		AddRichListCtrlString(Record.cellDataList[0].drawitems, fullNameString, getInstanceL2Util().White, false, 6, 10);
		if((Info.AdditionalName != ""))
		{
			AddRichListCtrlString(Record.cellDataList[0].drawitems, Info.AdditionalName, getInstanceL2Util().Yellow03, false, 3, 0);
		}
		if((Info.ItemNum > INT64(0)))
		{
			AddRichListCtrlString(Record.cellDataList[0].drawitems, (("(" $ string(Info.ItemNum)) $ ")"), getInstanceL2Util().White, false, 0, 0);
		}
		else
		{
			AddRichListCtrlString(Record.cellDataList[0].drawitems, "(1)", getInstanceL2Util().White, false, 0, 0);
		}
	}
	else
	{
		fullNameString = makeShortStringByPixel(fullNameString, 210, "..");
		AddRichListCtrlString(Record.cellDataList[0].drawitems, fullNameString, getInstanceL2Util().White, false, 6, 10);
		if((Info.AdditionalName != ""))
		{
			AddRichListCtrlString(Record.cellDataList[0].drawitems, Info.AdditionalName, getInstanceL2Util().Yellow03, false, 3, 0);
		}
	}
	itemListCtrl.InsertRecord(Record);
	return;
}

function updateMultiSellData(optional string serverUpdateParam)
{
	local int nPointCount, nPoint, nType, N;

	GetPlayerInfo(PlayerInfo);
	ParseInt(serverUpdateParam, "NumPoint", nPointCount);
	N = 0;
	while((N < nPointCount))
	{
		ParseInt(serverUpdateParam, ("Type" $ string(N)), nType);
		ParseInt(serverUpdateParam, ("Point" $ string(N)), nPoint);
		if((-500 == nType))
		{
			mData.PvPPoint = nPoint;
			N++;
			continue;
		}
		if((-300 == nType))
		{
			mData.PvPPoint = nPoint;
			N++;
			continue;
		}
		if((-200 == nType))
		{
			mData.clanPoint = nPoint;
			UIDataScript.SetCurrentClanNameValue(nPoint);
			N++;
			continue;
		}
		if((-100 == nType))
		{
			mData.PcCafePoint = nPoint;
			UIDataScript.SetPcCafePoint(nPoint);
			N++;
			continue;
		}
		if((-600 == nType))
		{
			mData.craftPoint = nPoint;
			N++;
			continue;
		}
		if((-1100 == nType))
		{
			mData.visPoint = nPoint;
		}
		N++;
	}
	if((nPointCount <= 0))
	{
		mData.PvPPoint = PlayerInfo.PvPPoint;
		mData.RaidPoint = PlayerInfo.RaidPoint;
		mData.PcCafePoint = UIDataScript.GetCurrentPcCafePoint();
		mData.clanPoint = UIDataScript.GetCurrentClanNameValue();
		mData.craftPoint = UIDataScript.GetCurrentCraftPoint();
	}
	mData.vitalityPoint = UIDataScript.GetCurrentVitalityPoint();
	mData.visPoint = Class'Interface.VirtualItemWnd'.static.Inst().GetVirtualItemPoint();
	return;
}

function HandleDialogOK(bool bOK)
{
	local string param;
	local int SelectedIndex, Id;
	local INT64 inputNum, tryExchangeCount;

	if(DialogIsMine())
	{
		disableWnd.HideWindow();
		Id = DialogGetID();
		if(bOK)
		{
			if((Id == 1123))
			{
				inputNum = INT64(DialogGetString());
				if((inputNum <= INT64(0)))
				{
					inputNum = INT64(1);
				}
				tryExchangeCount = Min64(inputNum, needItemScript.GetMaxNumCanBuy());
				inputItemScript.SetCount(tryExchangeCount);
			}
			else
			{
				tryExchangeCount = INT64(ItemCount_EditBox.GetString());
				setTreeNeedItemInfo();
				SelectedIndex = DialogGetReservedInt();
				if((SelectedIndex >= m_MultiSellInfoList.Length))
				{
					return;
				}
				ParamAdd(param, "MultiSellGroupID", string(m_MultiSellGroupID));
				ParamAdd(param, "MultiSellInfoID", string(m_MultiSellInfoList[SelectedIndex].MultiSellInfoID));
				ParamAdd(param, "ItemCount", string(DialogGetReservedInt2()));
				ParamAdd(param, "Enchant", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.Enchanted));
				ParamAdd(param, "RefineryOp1", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.RefineryOp1));
				ParamAdd(param, "RefineryOp2", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.RefineryOp2));
				ParamAdd(param, "RefineryOp3", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.RefineryOp3));
				ParamAdd(param, "AttrAttackType", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.AttackAttributeType));
				ParamAdd(param, "AttrAttackValue", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.AttackAttributeValue));
				ParamAdd(param, "AttrDefenseValueFire", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueFire));
				ParamAdd(param, "AttrDefenseValueWater", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueWater));
				ParamAdd(param, "AttrDefenseValueWind", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueWind));
				ParamAdd(param, "AttrDefenseValueEarth", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueEarth));
				ParamAdd(param, "AttrDefenseValueHoly", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueHoly));
				ParamAdd(param, "AttrDefenseValueUnholy", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueUnholy));
				addParamEnsoulOptionInfo(m_MultiSellInfoList[SelectedIndex].ResultItemInfo, param);
				ParamAdd(param, "IsBlessedItem", string(boolToNum(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.IsBlessedItem)));
				ParamAdd(param, "IsBlessedItem", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.BlessBaseEffectID));
				RequestMultiSellChoose(param);
			}
		}
		else
		{
			disableWnd.HideWindow();
		}
	}
	return;
}

function OnDBClickItem(string Name, int Index)
{
	if(((Name == "MultisellTabTotalWnd_ItemWindow") || (Name == "MultisellTabEnableWnd_ItemWindow")))
	{
		OnExChange_ButtonClick();
	}
	return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	if(Me.IsShowWindow())
	{
		OnExChange_ButtonClick();
	}
	return;
}

function OnClickItem(string strID, int Index)
{
	if((strID == "MultisellTabTotalWnd_ItemWindow"))
	{
		updateMultiSellData();
		MultisellTabTotalWnd_ListCtrl.SetSelectedIndex(Index, true);
		Me.KillTimer(1235552);
		updateUIControl();
	}
	else if((strID == "MultisellTabEnableWnd_ItemWindow"))
	{
		updateMultiSellData();
		MultisellTabEnableWnd_ListCtrl.SetSelectedIndex(Index, true);
		Me.KillTimer(1235552);
		updateUIControl();
	}
	return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		case "MultisellTabTotalWnd_ListCtrl":
			updateMultiSellData();
			MultisellTabTotalWnd_ItemWindow.SetSelectedNum(MultisellTabTotalWnd_ListCtrl.GetSelectedIndex());
			Me.KillTimer(1235552);
			updateUIControl();
			break;
		case "MultisellTabEnableWnd_ListCtrl":
			updateMultiSellData();
			MultisellTabEnableWnd_ItemWindow.SetSelectedNum(MultisellTabEnableWnd_ListCtrl.GetSelectedIndex());
			Me.KillTimer(1235552);
			updateUIControl();
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "InventoryViewerCall_Button":
			getInstanceInventoryViewer().showWindowByParentWindow(Me, true);
			break;
		case "Search_Button":
			OnSearch_ButtonClick();
			break;
		case "Refrash_Button":
			OnRefrash_ButtonClick();
			break;
		case "ExChange_Button":
			OnExChange_ButtonClick();
			break;
		case "Close_Button":
			OnClose_ButtonClick();
			break;
		case "IconTabIcon_Button":
		case "ListTabIcon_Button":
			toggleListWithIconWindow();
			break;
		case "MultiSell_Input_Button_2":
			updateMultiSellData();
			OnPriceEditBtnHandler();
			break;
		case "MultiSellTab0":
			multiSellTab.SetTopOrder(0, true);
			disableWindowWithText(false, "");
			if(((Search_EditBox.GetString() == "") && (MultisellTabTotalWnd_ItemWindow.GetItemNum() != m_MultiSellInfoList.Length)))
			{
				bForceUpdate = true;
			}
			else
			{
				bForceUpdate = false;
			}
			ShowItemList();
			updateUIControl();
			break;
		case "MultiSellTab1":
			multiSellTab.SetTopOrder(1, true);
			disableWindowWithText(false, "");
			bForceUpdate = false;
			ShowItemList();
			updateUIControl();
			break;
		default:
			break;
	}
	return;
}

function OnExChange_ButtonClick()
{
	local int i, SelectedIndex, inputItemLen;
	local INT64 ItemNum;
	local ItemInfo rItemInfo, inputItemInfo;
	local bool hasEItemcheck;

	if(getCurrentSelectedItemInfo(rItemInfo))
	{
		SelectedIndex = rItemInfo.Reserved;
		ItemNum = INT64(ItemCount_EditBox.GetString());
		inputItemLen = m_MultiSellInfoList[SelectedIndex].InputItemInfoList.Length;
		i = 0;
		while((i < inputItemLen))
		{
			inputItemInfo = m_MultiSellInfoList[SelectedIndex].InputItemInfoList[i];
			if((((inputItemInfo.ItemType == 0) || (inputItemInfo.ItemType == 1)) || (inputItemInfo.ItemType == 2)))
			{
				if((isPointType(inputItemInfo) == false))
				{
					hasEItemcheck = true;
				}
			}
			i++;
		}
		if(hasEItemcheck)
		{
			dialogMessage = GetSystemMessage(4363);
		}
		else
		{
			switch(ShowType)
			{
				case 0:
					dialogMessage = GetSystemMessage(1383);
					break;
				case 1:
					dialogMessage = GetSystemMessage(13098);
					break;
				case 2:
					dialogMessage = GetSystemMessage(1383);
					break;
				default:
					break;
			}
		}
		if((SelectedIndex >= 0))
		{
			disableWnd.ShowWindow();
			disableWnd.SetFocus();
			DialogSetReservedInt(SelectedIndex);
			DialogSetReservedInt2(ItemNum);
			DialogSetID(1122);
			DialogSetCancelD(1122);
			DialogSetString("");
			DialogShow(DialogModalType_Modalless, DialogType_Warning, dialogMessage);
			m_nSelectedMultiSellInfoIndex = SelectedIndex;
		}
	}
	return;
}

function OnPriceEditBtnHandler()
{
	local ItemInfo Info;

	disableWnd.ShowWindow();
	disableWnd.SetFocus();
	DialogSetID(1123);
	DialogSetEditBoxMaxLength(9);
	DialogSetCancelD(1123);
	DialogSetReservedItemID(Info.Id);
	DialogSetEditType("number");
	DialogSetParamInt64(Min64(needItemScript.GetMaxNumCanBuy(), INT64(1000000)));
	DialogSetDefaultOK();
	DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(4362));
	DialogSetInputlimit(Min64(needItemScript.GetMaxNumCanBuy(), INT64(1000000)));
	return;
}

function OnSearch_ButtonClick()
{
	local string searchStr;

	searchStr = Search_EditBox.GetString();
	if((searchStr == ""))
	{
		OnRefrash_ButtonClick();
	}
	else
	{
		ShowItemList();
	}
	return;
}

function OnRefrash_ButtonClick()
{
	disableWindowWithText(false, "");
	disableWnd.HideWindow();
	bForceUpdate = true;
	Search_EditBox.SetString("");
	updateMultiSellData();
	ShowItemList();
	updateUIControl();
	return;
}

function OnClose_ButtonClick()
{
	Me.HideWindow();
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	local string mainKey;

	if(Search_EditBox.IsFocused())
	{
		mainKey = Class'NWindow.InputAPI'.static.GetKeyString(nKey);
		if((mainKey == "ENTER"))
		{
			ShowItemList();
		}
	}
	return false;
}

function updateUIControl()
{
	updateItemInfo();
	setTreeNeedItemInfo();
	return;
}

function updateItemInfo()
{
	local int i, Index;
	local ItemInfo rItemInfo;

	if(getCurrentSelectedItemInfo(rItemInfo))
	{
		Index = rItemInfo.Reserved;
		if((Index <= -1))
		{
			return;
		}
		Class'NWindow.UIAPI_MULTISELLITEMINFO'.static.Clear("MultiSellWnd.multiSellItemInfo");
		if(((Index >= 0) && (Index < m_MultiSellInfoList.Length)))
		{
			i = 0;
			while((i < m_MultiSellInfoList[Index].OutputItemInfoList.Length))
			{
				Class'NWindow.UIAPI_MULTISELLITEMINFO'.static.SetItemInfo("MultiSellWnd.multiSellItemInfo", i, m_MultiSellInfoList[Index].OutputItemInfoList[i]);
				if((m_MultiSellInfoList[Index].OutputItemInfoList[i].IconName == "icon.pvp_point_i00"))
				{
					Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("MultiSellWnd.txtPointItemDescription");
					Class'NWindow.UIAPI_TEXTBOX'.static.SetText("MultiSellWnd.txtPointItemDescription", GetSystemMessage(2334));
					i++;
					continue;
				}
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("MultiSellWnd.PointItemName");
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("MultiSellWnd.txtPointItemDescription");
				Class'NWindow.UIAPI_TEXTBOX'.static.SetText("MultiSellWnd.PointItemName", "");
				Class'NWindow.UIAPI_TEXTBOX'.static.SetText("MultiSellWnd.txtPointItemDescription", "");
				i++;
			}
		}
	}
	return;
}

function int GetIndexArray(int ClassID, out array<NoStackableItemData> noStackableItemDataArray)
{
	local int i;

	i = 0;
	while((i < noStackableItemDataArray.Length))
	{
		if((noStackableItemDataArray[i].ClassID == ClassID))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function int GetNoStackableItemCountArrayIndex(ItemInfo inputItemInfo, out array<NoStackableItemData> noStackableItemDataArray)
{
	local int arrayIndex, nClassID;
	local INT64 noStackableNeedItemNum;
	local array<ItemInfo> hasItemInfoArray;

	if(!IsStackableItem(inputItemInfo.ConsumeType))
	{
		nClassID = inputItemInfo.Id.ClassID;
		hasItemInfoArray = FindItems(nClassID);
		noStackableNeedItemNum = INT64(hasItemInfoArray.Length);
		arrayIndex = GetIndexArray(nClassID, noStackableItemDataArray);
		if((arrayIndex == -1))
		{
			noStackableItemDataArray.Length = (noStackableItemDataArray.Length + 1);
			if((noStackableItemDataArray.Length > 0))
			{
				noStackableItemDataArray[(noStackableItemDataArray.Length - 1)].ClassID = nClassID;
				noStackableItemDataArray[(noStackableItemDataArray.Length - 1)].Count = noStackableNeedItemNum;
			}
			if((arrayIndex == -1))
			{
				arrayIndex = (noStackableItemDataArray.Length - 1);
			}
		}
		else if((noStackableItemDataArray[arrayIndex].Count > INT64(0)))
		{
			noStackableItemDataArray[arrayIndex].Count = (noStackableItemDataArray[arrayIndex].Count - INT64(1));
		}
	}
	return arrayIndex;
}

function setTreeNeedItemInfo()
{
	local int i, Index;
	local ItemInfo rItemInfo;

	if(getCurrentSelectedItemInfo(rItemInfo))
	{
		Index = rItemInfo.Reserved;
		if((Index <= -1))
		{
			return;
		}
		needItemScript.CleariObjects();
		needItemScript.StartNeedItemList(4);
		if(((Index >= 0) && (Index < m_MultiSellInfoList.Length)))
		{
			i = 0;
			while((i < m_MultiSellInfoList[Index].InputItemInfoList.Length))
			{
				if(isPointType(m_MultiSellInfoList[Index].InputItemInfoList[i]))
				{
					needItemScript.AddNeedPoint(m_MultiSellInfoList[Index].InputItemInfoList[i].Name, m_MultiSellInfoList[Index].InputItemInfoList[i].IconName, m_MultiSellInfoList[Index].InputItemInfoList[i].ItemNum, getHasItemOrPointCount(m_MultiSellInfoList[Index].InputItemInfoList[i]));
					i++;
					continue;
				}
				needItemScript.AddNeedItemClassID(m_MultiSellInfoList[Index].InputItemInfoList[i].Id.ClassID, m_MultiSellInfoList[Index].InputItemInfoList[i].ItemNum);
				i++;
			}
		}
		if((needItemScript.GetMaxNumCanBuy() > INT64(0)))
		{
			inputItemScript.SetCount(INT64(1));
		}
		else
		{
			inputItemScript.SetCount(INT64(0));
		}
		itemCountTextEditEnable(true);
		if(!IsStackableItem(rItemInfo.ConsumeType))
		{
			itemCountTextEditEnable(false);
		}
		if(((Index >= 0) && (Index < m_MultiSellInfoList.Length)))
		{
			i = 0;
			while((i < m_MultiSellInfoList[Index].InputItemInfoList.Length))
			{
				if(((IsStackableItem(m_MultiSellInfoList[Index].InputItemInfoList[i].ConsumeType) == false) && (isPointType(m_MultiSellInfoList[Index].InputItemInfoList[i]) == false)))
				{
					itemCountTextEditEnable(false);
				}
				i++;
			}
		}
	}
	return;
}

function bool isPointType(ItemInfo Info)
{
	local bool RValue;

	if((Info.IconName == GetPcCafeItemIconPackageName()))
	{
		RValue = true;
	}
	else if((Info.IconName == "icon.etc_i.etc_bloodpledge_point_i00"))
	{
		RValue = true;
	}
	else if((Info.IconName == "icon.pvp_point_i00"))
	{
		RValue = true;
	}
	else if((Info.IconName == "icon.etc_i.etc_rp_point_i00"))
	{
		RValue = true;
	}
	else if((Info.IconName == "Icon.etc_i.craft_point"))
	{
		RValue = true;
	}
	else if((Info.IconName == "icon.etc_sayha_point_01"))
	{
		RValue = true;
	}
	else if((Info.IconName == GetItemInfoByClassID(60793).IconName))
	{
		RValue = true;
	}
	Debug(("Info.IconName " @ Info.IconName));
	return RValue;
}

function INT64 getHasItemOrPointCount(ItemInfo Info)
{
	local INT64 hasNum;
	local array<ItemInfo> itemInfoArray;
	local int ItemCount;

	if((Info.IconName == GetPcCafeItemIconPackageName()))
	{
		hasNum = INT64(mData.PcCafePoint);
	}
	else if((Info.IconName == "icon.etc_i.etc_bloodpledge_point_i00"))
	{
		hasNum = INT64(mData.clanPoint);
	}
	else if((Info.IconName == "icon.pvp_point_i00"))
	{
		hasNum = INT64(mData.PvPPoint);
	}
	else if((Info.IconName == "icon.etc_i.etc_rp_point_i00"))
	{
		hasNum = INT64(mData.RaidPoint);
	}
	else if((Info.IconName == "Icon.etc_i.craft_point"))
	{
		hasNum = INT64(mData.craftPoint);
	}
	else if((Info.IconName == "icon.etc_sayha_point_01"))
	{
		hasNum = mData.vitalityPoint;
	}
	else if((Info.IconName == GetItemInfoByClassID(60793).IconName))
	{
		hasNum = INT64(mData.visPoint);
	}
	else
	{
		itemInfoArray = FindItems(Info.Id.ClassID);
		ItemCount = itemInfoArray.Length;
		if((ItemCount > 0))
		{
			hasNum = itemInfoArray[0].ItemNum;
		}
	}
	return hasNum;
}

function itemCountTextEditEnable(bool bEnable)
{
	if(bEnable)
	{
		MultiSell_Input_Button.EnableWindow();
	}
	else
	{
		MultiSell_Input_Button.DisableWindow();
	}
	return;
}

function bool getCurrentSelectedItemInfo(out ItemInfo rItemInfo)
{
	local bool bFlag;

	if((multiSellTab.GetTopIndex() == 0))
	{
		bFlag = MultisellTabTotalWnd_ItemWindow.GetSelectedItem(rItemInfo);
	}
	else
	{
		bFlag = MultisellTabEnableWnd_ItemWindow.GetSelectedItem(rItemInfo);
	}
	return bFlag;
}

function int GetCurrentSelectedIndex()
{
	local int RValue;

	RValue = -1;
	if((multiSellTab.GetTopIndex() == 0))
	{
		RValue = MultisellTabTotalWnd_ItemWindow.GetSelectedNum();
	}
	else
	{
		RValue = MultisellTabEnableWnd_ItemWindow.GetSelectedNum();
	}
	return RValue;
}

function setSelectItem(ItemInfo Info)
{
	local int lastSelectedIndex, N;
	local ItemInfo tempInfo;

	lastSelectedIndex = Info.Reserved;
	if((Info.Name == ""))
	{
		return;
	}
	if((multiSellTab.GetTopIndex() == 0))
	{
		N = 0;
		while((N < MultisellTabTotalWnd_ItemWindow.GetItemNum()))
		{
			MultisellTabTotalWnd_ItemWindow.GetItem(N, tempInfo);
			if((tempInfo.Reserved == lastSelectedIndex))
			{
				MultisellTabTotalWnd_ItemWindow.SetSelectedNum(N);
				MultisellTabTotalWnd_ListCtrl.SetSelectedIndex(N, true);
				break;
			}
			N++;
		}
	}
	else
	{
		N = 0;
		while((N < MultisellTabEnableWnd_ItemWindow.GetItemNum()))
		{
			MultisellTabEnableWnd_ItemWindow.GetItem(N, tempInfo);
			if((tempInfo.Reserved == lastSelectedIndex))
			{
				MultisellTabEnableWnd_ItemWindow.SetSelectedNum(N);
				MultisellTabEnableWnd_ListCtrl.SetSelectedIndex(N, true);
				break;
			}
			N++;
		}
	}
	return;
}

function int FindMatchString(string targetStr, string a_Param)
{
	local array<string> modifiedParamArr;
	local int i;
	local string delim, modifiedString;
	local int _inStr;
	local string strTemp1, strTemp2;

	modifiedString = Substitute(targetStr, " ", "", false);
	delim = " ";
	_inStr = InStr(a_Param, delim);
	while((_inStr > -1))
	{
		modifiedParamArr.Insert(modifiedParamArr.Length, 1);
		modifiedParamArr[(modifiedParamArr.Length - 1)] = Left(a_Param, _inStr);
		a_Param = Mid(a_Param, (_inStr + 1));
		_inStr = InStr(a_Param, delim);
	}
	modifiedParamArr.Insert(modifiedParamArr.Length, 1);
	modifiedParamArr[(modifiedParamArr.Length - 1)] = a_Param;
	i = 0;
	while((i < modifiedParamArr.Length))
	{
		strTemp1 = Caps(modifiedString);
		strTemp2 = Caps(modifiedParamArr[i]);
		if(((InStr(strTemp1, strTemp2) == -1) && (modifiedParamArr[i] != " ")))
		{
			return -1;
		}
		i++;
	}
	return 1;
}

function addEnsoulInfo(int slotType, int slotCount, string param, out ItemInfo Info)
{
	local int N, nEOptionID;

	N = 1;
	while((N < (slotCount + 1)))
	{
		ParseInt(param, ((("EnsoulOptionID_" $ string(slotType)) $ "_") $ string(N)), nEOptionID);
		Info.EnsoulOption[(slotType - 1)].OptionArray[(N - 1)] = nEOptionID;
		N++;
	}
	return;
}

function array<ItemInfo> FindItems(int ClassID)
{
	toFindClassID = ClassID;
	GetObjectFindItemByCompare().DelegateCompare = Compare;
	if(getInstanceUIData().GetIsLiveServer())
	{
		return GetObjectFindItemByCompare().GetAllInvenItemAndArtifactItemAndQuestByCompare();
	}
	else
	{
		return GetObjectFindItemByCompare().GetAllItemByCompare();
	}
}

function array<ItemInfo> FilterBlessedItems(array<ItemInfo> infos, bool IsBlessedItem)
{
	local int i;
	local array<ItemInfo> iInfos;

	i = 0;
	while((i < infos.Length))
	{
		if((infos[i].IsBlessedItem == IsBlessedItem))
		{
			iInfos[iInfos.Length] = infos[i];
		}
		i++;
	}
	return iInfos;
}

function bool Compare(ItemInfo iInfo)
{
	local bool bUseExceptionEnsoul, bUseExceptionVariationItem;

	if((toFindClassID != iInfo.Id.ClassID))
	{
		return false;
	}
	bUseExceptionEnsoul = !numToBool(nShowEnsoul);
	bUseExceptionVariationItem = !numToBool(nVariationItem);
	if(iInfo.bSecurityLock)
	{
		return false;
	}
	if(isDamagedItem(iInfo))
	{
		return false;
	}
	if(bUseExceptionEnsoul)
	{
		if(getInstanceL2Util().hasEnsoulOption(iInfo))
		{
			return false;
		}
	}
	if(bUseExceptionVariationItem)
	{
		if(getInstanceL2Util().isRefinery(iInfo))
		{
			return false;
		}
	}
	return true;
}

function OnESCKey()
{
	if((multiSellTab.GetTopIndex() == 0))
	{
		MultisellTabTotalWnd.SetFocus();
	}
	else
	{
		MultisellTabEnableWnd.SetFocus();
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="MultiSellWnd"
}
