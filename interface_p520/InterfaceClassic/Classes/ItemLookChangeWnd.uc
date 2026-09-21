class ItemLookChangeWnd extends UICommonAPI;

const DIALOG_RESULT_SUCCESS = 303;
const DIALOG_RESULT_FAILURE = 304;
const DIALOG_ONLY_NOTICE = 5555;
const DIALOG_LOOKCHANGE_START = 4444;
const DIALOG_LOOKCHANGE_START_FINAL = 7777;
const DIALOG_RESTORELOOKCHANGE_START = 6666;
const C_ANIMLOOPCOUNT = 1;

enum EShapeShiftingWindowType
{
	SST_WindowInvalid,              // 0
	SST_WindowNormal,               // 1
	SST_WindowBlessed,              // 2
	SST_WindowFixed,                // 3
	SST_WindowRestore,              // 4
	SST_WindowMax                   // 5
};

enum EShapeWindowType
{
	SWT_InvalID,                    // 0
	SWT_Weapon,                     // 1
	SWT_Armor,                      // 2
	SWT_Hair_Accessary,             // 3
	SWT_AllItem,                    // 4
	SWT_Max                         // 5
};

var WindowHandle Me;
var TextureHandle BackPattern;
var TextBoxHandle WeaponSlotTxt;
var TextBoxHandle LookSlotTxt;
var TextBoxHandle RestoreSlotTxt;
var TextBoxHandle InstructionTxt;
var TextBoxHandle AdenaText;
var ItemWindowHandle StoneItemSlot;
var ItemWindowHandle WeaponItemSlot;
var ItemWindowHandle LookItemSlot;
var ItemWindowHandle RestoreItemSlot;
var ItemWindowHandle EnchantedItemSlot;
var ButtonHandle EnchantBtn;
var ButtonHandle ExitBtn;
var ButtonHandle OkBtn;
var TextureHandle GroupBox2;
var TextureHandle GroupBox1;
var TextureHandle StoneItemSlotBackTex;
var TextureHandle WeaponItemSlotBackTex;
var TextureHandle LookItemSlotBackTex;
var TextureHandle RestoreItemSlotBackTex;
var TextureHandle EnchantedItemSlotBackTex;
var TextureHandle DropHighlight_StoneItem;
var TextureHandle DropHighlight_WeaponItem;
var TextureHandle DropHighlight_LookItem;
var TextureHandle DropHighlight_RestoreItem;
var AnimTextureHandle EnchantProgressAnim;
var ProgressCtrlHandle m_hItemLookChangeWndEnchantProgress;
var bool bItemLookChangebool;
var bool bItemLookChangedbool;
var int mItemLookChangeType;
var INT64 mPriceAdena;
var bool bIsShopping;
var ItemInfo TempDropItemInfo;
var ItemInfo weaponItemInfo;
var ItemInfo LookWeaponItemInfo;
var EShapeShiftingWindowType eShapeShiftingWindow;
var EShapeWindowType eShapeWindow;
var bool bItemLookEnchantStart;
var InventoryWnd inventoryWndScript;

function OnLoad()
{
	SetClosingOnESC();
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	if((1 == 0))
	{
		Me = GetHandle("ItemLookChangeWnd");
		EnchantProgressAnim = AnimTextureHandle(GetHandle("ItemLookChangeWnd.EnchantProgressAnim"));
		BackPattern = TextureHandle(GetHandle("ItemLookChangeWnd.BackPattern"));
		WeaponSlotTxt = TextBoxHandle(GetHandle("ItemLookChangeWnd.WeaponSlotTxt"));
		LookSlotTxt = TextBoxHandle(GetHandle("ItemLookChangeWnd.LookSlotTxt"));
		RestoreSlotTxt = TextBoxHandle(GetHandle("ItemLookChangeWnd.RestoreSlotTxt"));
		InstructionTxt = TextBoxHandle(GetHandle("ItemLookChangeWnd.InstructionTxt"));
		AdenaText = TextBoxHandle(GetHandle("ItemLookChangeWnd.AdenaText"));
		StoneItemSlot = ItemWindowHandle(GetHandle("ItemLookChangeWnd.StoneItemSlot"));
		WeaponItemSlot = ItemWindowHandle(GetHandle("ItemLookChangeWnd.WeaponItemSlot"));
		LookItemSlot = ItemWindowHandle(GetHandle("ItemLookChangeWnd.LookItemSlot"));
		RestoreItemSlot = ItemWindowHandle(GetHandle("ItemLookChangeWnd.RestoreItemSlot"));
		EnchantedItemSlot = ItemWindowHandle(GetHandle("ItemLookChangeWnd.EnchantedItemSlot"));
		EnchantBtn = ButtonHandle(GetHandle("ItemLookChangeWnd.EnchantBtn"));
		ExitBtn = ButtonHandle(GetHandle("ItemLookChangeWnd.ExitBtn"));
		OkBtn = ButtonHandle(GetHandle("ItemLookChangeWnd.OkBtn"));
		GroupBox2 = TextureHandle(GetHandle("ItemLookChangeWnd.Groupbox2"));
		GroupBox1 = TextureHandle(GetHandle("ItemLookChangeWnd.Groupbox1"));
		StoneItemSlotBackTex = TextureHandle(GetHandle("ItemLookChangeWnd.StoneItemSlotBackTex"));
		WeaponItemSlotBackTex = TextureHandle(GetHandle("ItemLookChangeWnd.WeaponItemSlotBackTex"));
		LookItemSlotBackTex = TextureHandle(GetHandle("ItemLookChangeWnd.LookItemSlotBackTex"));
		RestoreItemSlotBackTex = TextureHandle(GetHandle("ItemLookChangeWnd.RestoreItemSlotBackTex"));
		EnchantedItemSlotBackTex = TextureHandle(GetHandle("ItemLookChangeWnd.EnchantedItemSlotBackTex"));
		DropHighlight_StoneItem = TextureHandle(GetHandle("ItemLookChangeWnd.DropHighlight_StoneItem"));
		DropHighlight_WeaponItem = TextureHandle(GetHandle("ItemLookChangeWnd.DropHighlight_WeaponItem"));
		DropHighlight_LookItem = TextureHandle(GetHandle("ItemLookChangeWnd.DropHighlight_LookItem"));
		DropHighlight_RestoreItem = TextureHandle(GetHandle("ItemLookChangeWnd.DropHighlight_RestoreItem"));
	}
	else
	{
		Me = GetWindowHandle("ItemLookChangeWnd");
		EnchantProgressAnim = GetAnimTextureHandle("ItemLookChangeWnd.EnchantProgressAnim");
		BackPattern = GetTextureHandle("ItemLookChangeWnd.BackPattern");
		WeaponSlotTxt = GetTextBoxHandle("ItemLookChangeWnd.WeaponSlotTxt");
		LookSlotTxt = GetTextBoxHandle("ItemLookChangeWnd.LookSlotTxt");
		RestoreSlotTxt = GetTextBoxHandle("ItemLookChangeWnd.RestoreSlotTxt");
		InstructionTxt = GetTextBoxHandle("ItemLookChangeWnd.InstructionTxt");
		AdenaText = GetTextBoxHandle("ItemLookChangeWnd.AdenaText");
		StoneItemSlot = GetItemWindowHandle("ItemLookChangeWnd.StoneItemSlot");
		WeaponItemSlot = GetItemWindowHandle("ItemLookChangeWnd.WeaponItemSlot");
		LookItemSlot = GetItemWindowHandle("ItemLookChangeWnd.LookItemSlot");
		RestoreItemSlot = GetItemWindowHandle("ItemLookChangeWnd.RestoreItemSlot");
		EnchantedItemSlot = GetItemWindowHandle("ItemLookChangeWnd.EnchantedItemSlot");
		EnchantBtn = GetButtonHandle("ItemLookChangeWnd.EnchantBtn");
		ExitBtn = GetButtonHandle("ItemLookChangeWnd.ExitBtn");
		OkBtn = GetButtonHandle("ItemLookChangeWnd.OkBtn");
		GroupBox2 = GetTextureHandle("ItemLookChangeWnd.Groupbox2");
		GroupBox1 = GetTextureHandle("ItemLookChangeWnd.Groupbox1");
		StoneItemSlotBackTex = GetTextureHandle("ItemLookChangeWnd.StoneItemSlotBackTex");
		WeaponItemSlotBackTex = GetTextureHandle("ItemLookChangeWnd.WeaponItemSlotBackTex");
		LookItemSlotBackTex = GetTextureHandle("ItemLookChangeWnd.LookItemSlotBackTex");
		RestoreItemSlotBackTex = GetTextureHandle("ItemLookChangeWnd.RestoreItemSlotBackTex");
		EnchantedItemSlotBackTex = GetTextureHandle("ItemLookChangeWnd.EnchantedItemSlotBackTex");
		DropHighlight_StoneItem = GetTextureHandle("ItemLookChangeWnd.DropHighlight_StoneItem");
		DropHighlight_WeaponItem = GetTextureHandle("ItemLookChangeWnd.DropHighlight_WeaponItem");
		DropHighlight_LookItem = GetTextureHandle("ItemLookChangeWnd.DropHighlight_LookItem");
		DropHighlight_RestoreItem = GetTextureHandle("ItemLookChangeWnd.DropHighlight_RestoreItem");
		m_hItemLookChangeWndEnchantProgress = GetProgressCtrlHandle("ItemLookChangeWnd.EnchantProgress");
	}
	Initialize();
	Load();
	return;
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)), "InventoryWnd");
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
	return;
}

function Initialize()
{
	mPriceAdena = INT64(0);
	bItemLookChangebool = false;
	bItemLookChangedbool = false;
	bIsShopping = false;
	eShapeShiftingWindow = SST_WindowInvalid;
	eShapeWindow = SWT_Weapon;
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(9260);
	RegisterEvent(9270);
	RegisterEvent(9280);
	RegisterEvent(9290);
	RegisterEvent(9300);
	RegisterEvent(1710);
	return;
}

function Load()
{
	inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int shape, ShowWindow;
	local ItemID cID;

	if((Event_ID == 9260))
	{
		ParseInt(param, "ShapeType", shape);
		ParseInt(param, "ShapeShiftingType", ShowWindow);
		ParseItemID(param, cID);
		eShapeShiftingWindow = GetShapeShiftingType(ShowWindow);
		eShapeWindow = GetShapeType(shape);
		if(!bIsShopping)
		{
			if((int(eShapeShiftingWindow) == 4))
			{
				HandleRestoreLookChangeShow(cID);
			}
			else
			{
				HandleLookChangeShow(cID);
			}
		}
		else
		{
			Class'NWindow.ItemLookChangeAPI'.static.RequestExCancelItemLookChange();
		}
	}
	else if((Event_ID == 9290))
	{
		if((int(eShapeShiftingWindow) == 4))
		{
			HandleRestorePutTargetItemResult(param);
		}
		else
		{
			HandlePutTargetItemResult(param);
		}
	}
	else if((Event_ID == 9300))
	{
		HandletPutSupportItemResult(param);
	}
	else if((Event_ID == 9280))
	{
		Debug(("Event_ID EV_ItemLookChangeResult" @ param));
		if((int(eShapeShiftingWindow) == 4))
		{
			Debug("SST_WindowRestore");
			HandlerRestoreLookChangeResult(param);
		}
		else
		{
			Debug("HandleLookChangeResult");
			HandleLookChangeResult(param);
		}
	}
	else if((Event_ID == 1710))
	{
		HandleDialogOK();
	}
	else if((Event_ID == 1720))
	{
	}
	return;
}

function EShapeShiftingWindowType GetShapeShiftingType(int ShowWindow)
{
	if((ShowWindow == 0))
	{
		return SST_WindowInvalid;
	}
	else if((ShowWindow == 1))
	{
		return SST_WindowNormal;
	}
	else if((ShowWindow == 2))
	{
		return SST_WindowBlessed;
	}
	else if((ShowWindow == 3))
	{
		return SST_WindowFixed;
	}
	else if((ShowWindow == 4))
	{
		return SST_WindowRestore;
	}
	return SST_WindowInvalid;
}

function EShapeWindowType GetShapeType(int ShowWindow)
{
	if((ShowWindow == 1))
	{
		return SWT_Weapon;
	}
	else if((ShowWindow == 2))
	{
		return SWT_Armor;
	}
	else if((ShowWindow == 3))
	{
		return SWT_Hair_Accessary;
	}
	else if((ShowWindow == 4))
	{
		return SWT_AllItem;
	}
	return SWT_InvalID;
}

function bool HandleDialogOK()
{
	local int Id;

	if(DialogIsMine())
	{
		Id = DialogGetID();
		if((Id == 6666))
		{
			OnRestoreLookChangeStart();
			EnchantBtn.DisableWindow();
			bItemLookEnchantStart = true;
			return true;
		}
		else if(((Id == 7777) || (Id == 4444)))
		{
			OnLookChangeStart();
			EnchantBtn.DisableWindow();
			bItemLookEnchantStart = true;
			return true;
		}
		else if((Id == 304))
		{
		}
	}
	return false;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "EnchantBtn":
			DialogHide();
			if((int(eShapeShiftingWindow) == 4))
			{
				DialogShow(DialogModalType_Modal, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(6082), weaponItemInfo.Name));
				DialogSetID(6666);
			}
			else if(((int(eShapeShiftingWindow) == 1) || (int(eShapeShiftingWindow) == 2)))
			{
				DialogShow(DialogModalType_Modal, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(6080), weaponItemInfo.Name, LookWeaponItemInfo.Name));
				DialogSetID(4444);
			}
			else if((int(eShapeShiftingWindow) == 3))
			{
				DialogShow(DialogModalType_Modal, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(6081), weaponItemInfo.Name));
				DialogSetID(4444);
			}
			break;
		case "ExitBtn":
			if(!bItemLookChangedbool)
			{
				Class'NWindow.ItemLookChangeAPI'.static.RequestExCancelItemLookChange();
				ProcCancel();
				Me.HideWindow();
			}
			else
			{
				Me.HideWindow();
			}
			break;
		case "OkBtn":
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function HandleLookChangeShow(ItemID cID)
{
	local ItemID cFixID;
	local ItemInfo cItemInfo;

	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cID, cItemInfo);
	bItemLookChangedbool = false;
	ResetUI();
	Me.ShowWindow();
	Me.SetFocus();
	ExitBtn.SetNameText(GetSystemString(646));
	EnchantBtn.SetNameText(GetSystemString(428));
	cItemInfo.ItemNum = INT64(1);
	StoneItemSlot.SetItem(0, cItemInfo);
	StoneItemSlot.AddItem(cItemInfo);
	PlaySound("ItemSound3.enchant_input");
	mItemLookChangeType = 0;
	ItemLookChangeThreeSlot();
	if((int(eShapeShiftingWindow) == 3))
	{
		cFixID.ClassID = cItemInfo.LookChangeIconID;
		Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cFixID, LookWeaponItemInfo);
		LookItemSlot.SetItem(0, LookWeaponItemInfo);
		LookItemSlot.AddItem(LookWeaponItemInfo);
		DropHighlight_LookItem.ShowWindow();
		DropHighlight_LookItem.SetTexture("L2UI_ch3.RefineryWnd.refineslot2");
		LookItemSlotBackTex.HideWindow();
	}
	if((int(eShapeWindow) == 1))
	{
		WeaponItemSlotBackTex.SetTexture("l2ui_ct1.ItemLookChangeWnd_SlotBg_Weapon");
		LookItemSlotBackTex.SetTexture("BranchSys3.Icon.ItemLookChangeWnd_SlotBg_Look");
	}
	else if((int(eShapeWindow) == 2))
	{
		WeaponItemSlotBackTex.SetTexture("BranchSys3.Icon.ItemLookChangeWnd_SlotBg_Armor");
		LookItemSlotBackTex.SetTexture("BranchSys3.Icon.ItemLookChangeWnd_SlotBg_ArmorLook");
	}
	else
	{
		WeaponItemSlotBackTex.SetTexture("BranchSys3.Icon.ItemLookChangeWnd_SlotBg_Cap");
		LookItemSlotBackTex.SetTexture("BranchSys3.Icon.ItemLookChangeWnd_SlotBg_CapLook");
	}
	return;
}

function HandleRestoreLookChangeShow(ItemID cID)
{
	local ItemInfo cItemInfo;

	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cID, cItemInfo);
	bItemLookChangedbool = false;
	ResetUI();
	Me.ShowWindow();
	Me.SetFocus();
	ExitBtn.SetNameText(GetSystemString(646));
	EnchantBtn.SetNameText(GetSystemString(428));
	cItemInfo.ItemNum = INT64(1);
	WeaponItemSlot.SetItem(0, cItemInfo);
	WeaponItemSlot.AddItem(cItemInfo);
	PlaySound("ItemSound3.enchant_input");
	mItemLookChangeType = 0;
	RestoreLookChangeTwoSlot();
	if((int(eShapeWindow) == 1))
	{
		RestoreItemSlotBackTex.SetTexture("l2ui_ct1.ItemLookChangeWnd_SlotBg_Weapon");
	}
	else if((int(eShapeWindow) == 2))
	{
		RestoreItemSlotBackTex.SetTexture("BranchSys3.Icon.ItemLookChangeWnd_SlotBg_Armor");
	}
	else if((int(eShapeWindow) == 3))
	{
		RestoreItemSlotBackTex.SetTexture("BranchSys3.Icon.ItemLookChangeWnd_SlotBg_Cap");
	}
	else
	{
		RestoreItemSlotBackTex.SetTexture("BranchSys3.Icon.ItemLookChangeWnd_SlotBg_Equip");
	}
	return;
}

function ResetUI()
{
	OkBtn.HideWindow();
	EnchantProgressAnim.HideWindow();
	EnchantProgressAnim.HideWindow();
	EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Loading_01");
	EnchantProgressAnim.HideWindow();
	ExitBtn.ShowWindow();
	EnchantBtn.ShowWindow();
	EnchantBtn.DisableWindow();
	OkBtn.HideWindow();
	WeaponItemSlot.SetAlpha(255, 0.0000000);
	StoneItemSlot.Clear();
	WeaponItemSlot.Clear();
	LookItemSlot.Clear();
	RestoreItemSlot.Clear();
	EnchantedItemSlot.Clear();
	EnchantedItemSlotBackTex.HideWindow();
	m_hItemLookChangeWndEnchantProgress.SetProgressTime(1500);
	m_hItemLookChangeWndEnchantProgress.SetPos(0);
	m_hItemLookChangeWndEnchantProgress.Reset();
	DropHighlight_WeaponItem.SetTexture("L2UI_ch3.RefineryWnd.refineslot1");
	DropHighlight_LookItem.SetTexture("L2UI_ch3.RefineryWnd.refineslot1");
	DropHighlight_RestoreItem.SetTexture("L2UI_ch3.RefineryWnd.refineslot1");
	weaponItemInfo.Id.ClassID = 0;
	weaponItemInfo.Id.ServerID = 0;
	LookWeaponItemInfo.Id.ClassID = 0;
	LookWeaponItemInfo.Id.ServerID = 0;
	mPriceAdena = INT64(0);
	bItemLookEnchantStart = false;
	return;
}

function ItemLookChangeThreeSlot()
{
	RestoreSlotTxt.HideWindow();
	RestoreItemSlot.HideWindow();
	RestoreItemSlotBackTex.HideWindow();
	DropHighlight_RestoreItem.HideWindow();
	StoneItemSlot.SetAnchor("ItemLookChangeWnd", "TopLeft", "TopLeft", 141, 61);
	StoneItemSlot.ClearAnchor();
	StoneItemSlot.ShowWindow();
	StoneItemSlotBackTex.ShowWindow();
	WeaponItemSlot.SetAnchor("ItemLookChangeWnd", "TopLeft", "TopLeft", 79, 107);
	WeaponItemSlot.ClearAnchor();
	WeaponItemSlot.ShowWindow();
	WeaponItemSlotBackTex.ShowWindow();
	LookItemSlot.SetAnchor("ItemLookChangeWnd", "TopLeft", "TopLeft", 203, 107);
	LookItemSlot.ClearAnchor();
	LookItemSlot.ShowWindow();
	LookItemSlotBackTex.ShowWindow();
	WeaponSlotTxt.SetText(GetSystemString(5085));
	WeaponSlotTxt.ShowWindow();
	LookSlotTxt.ShowWindow();
	DropHighlight_StoneItem.ShowWindow();
	DropHighlight_WeaponItem.ShowWindow();
	DropHighlight_LookItem.HideWindow();
	if((int(eShapeWindow) == 1))
	{
		setWindowTitleByString(GetSystemString(5083));
		InstructionTxt.SetText(GetSystemString(5088));
	}
	else if((int(eShapeWindow) == 2))
	{
		setWindowTitleByString(GetSystemString(5102));
		InstructionTxt.SetText(GetSystemString(5104));
	}
	else if((int(eShapeWindow) == 3))
	{
		setWindowTitleByString(GetSystemString(5112));
		InstructionTxt.SetText(GetSystemString(5116));
	}
	else
	{
		setWindowTitleByString(GetSystemString(14663));
		InstructionTxt.SetText(GetSystemString(14664));
	}
	AdenaText.SetText(string(mPriceAdena));
	return;
}

function RestoreLookChangeTwoSlot()
{
	WeaponSlotTxt.HideWindow();
	LookSlotTxt.HideWindow();
	StoneItemSlot.HideWindow();
	StoneItemSlotBackTex.HideWindow();
	LookItemSlot.HideWindow();
	LookItemSlotBackTex.HideWindow();
	WeaponItemSlot.SetAnchor("ItemLookChangeWnd", "TopLeft", "TopLeft", 79, 107);
	WeaponItemSlot.ClearAnchor();
	WeaponItemSlot.ShowWindow();
	WeaponItemSlotBackTex.ShowWindow();
	RestoreItemSlot.SetAnchor("ItemLookChangeWnd", "TopLeft", "TopLeft", 203, 107);
	RestoreItemSlot.ClearAnchor();
	RestoreItemSlot.ShowWindow();
	RestoreItemSlotBackTex.ShowWindow();
	RestoreSlotTxt.ShowWindow();
	DropHighlight_RestoreItem.ShowWindow();
	DropHighlight_WeaponItem.SetTexture("L2UI_ch3.RefineryWnd.refineslot2");
	DropHighlight_WeaponItem.ShowWindow();
	DropHighlight_LookItem.HideWindow();
	DropHighlight_StoneItem.HideWindow();
	if((int(eShapeWindow) == 1))
	{
		setWindowTitleByString(GetSystemString(5084));
		InstructionTxt.SetText(GetSystemString(5090));
	}
	else if((int(eShapeWindow) == 2))
	{
		setWindowTitleByString(GetSystemString(5103));
		InstructionTxt.SetText(GetSystemString(5105));
	}
	else if((int(eShapeWindow) == 3))
	{
		setWindowTitleByString(GetSystemString(5113));
		InstructionTxt.SetText(GetSystemString(5117));
	}
	else
	{
		setWindowTitleByString(GetSystemString(14665));
		InstructionTxt.SetText(GetSystemString(14666));
	}
	AdenaText.SetText(string(mPriceAdena));
	return;
}

function OnLookChangeStart()
{
	local Rect Item1Rect, Item2Rect, Item3Rect, ResultRect;

	EnchantProgressAnim.SetLoopCount(1);
	EnchantProgressAnim.Stop();
	EnchantProgressAnim.Play();
	PlaySound("ItemSound3.enchant_process");
	EnchantProgressAnim.ShowWindow();
	bItemLookChangebool = true;
	m_hItemLookChangeWndEnchantProgress.Start();
	Item1Rect = StoneItemSlot.GetRect();
	Item2Rect = WeaponItemSlot.GetRect();
	Item3Rect = LookItemSlot.GetRect();
	ResultRect = EnchantedItemSlot.GetRect();
	StoneItemSlot.Move((ResultRect.nX - Item1Rect.nX), (ResultRect.nY - Item1Rect.nY), 1.5000000);
	WeaponItemSlot.Move((ResultRect.nX - Item2Rect.nX), (ResultRect.nY - Item2Rect.nY), 1.5000000);
	LookItemSlot.Move((ResultRect.nX - Item3Rect.nX), (ResultRect.nY - Item3Rect.nY), 1.5000000);
	StoneItemSlotBackTex.HideWindow();
	WeaponItemSlotBackTex.HideWindow();
	LookItemSlotBackTex.HideWindow();
	WeaponSlotTxt.HideWindow();
	LookSlotTxt.HideWindow();
	ExitBtn.SetNameText(GetSystemString(141));
	EnchantBtn.SetNameText(GetSystemString(428));
	return;
}

function ProcCancel()
{
	mPriceAdena = INT64(0);
	eShapeShiftingWindow = SST_WindowInvalid;
	bItemLookChangebool = false;
	m_hItemLookChangeWndEnchantProgress.Stop();
	EnchantProgressAnim.Stop();
	return;
}

function OnTextureAnimEnd(AnimTextureHandle a_WindowHandle)
{
	EnchantProgressAnim.HideWindow();
	EnchantProgressAnim.Stop();
	EnchantProgressAnim.HideWindow();
	switch(a_WindowHandle)
	{
		case EnchantProgressAnim:
			if(bItemLookChangebool)
			{
				bItemLookChangebool = false;
				Class'NWindow.ItemLookChangeAPI'.static.RequestItemLookChange(weaponItemInfo.Id);
			}
			break;
		default:
			break;
	}
	EnchantProgressAnim.HideWindow();
	return;
}

function OnHide()
{
	mPriceAdena = INT64(0);
	bItemLookChangebool = false;
	eShapeShiftingWindow = SST_WindowInvalid;
	Class'NWindow.ItemLookChangeAPI'.static.RequestExCancelItemLookChange();
	return;
}

function OnDropItem(string a_WindowID, ItemInfo a_itemInfo, int X, int Y)
{
	if(bItemLookEnchantStart)
	{
		return;
	}
	TempDropItemInfo = a_itemInfo;
	switch(a_WindowID)
	{
		case "WeaponItemSlot":
			Class'NWindow.ItemLookChangeAPI'.static.RequestExTryToPut_Shape_Shifting_TargetItem(a_itemInfo.Id);
			break;
		case "LookItemSlot":
			if((int(eShapeShiftingWindow) != 3))
			{
				Class'NWindow.ItemLookChangeAPI'.static.RequestExTryToPut_Shape_Shifting_EnchantSupportItem(weaponItemInfo.Id, a_itemInfo.Id);
			}
			break;
		case "RestoreItemSlot":
			Class'NWindow.ItemLookChangeAPI'.static.RequestExTryToPut_Shape_Shifting_TargetItem(a_itemInfo.Id);
			break;
		default:
			break;
	}
	return;
}

function HandlePutTargetItemResult(string param)
{
	local int ResultID;
	local INT64 Adena;

	ParseInt(param, "Result", ResultID);
	ParseINT64(param, "Adena", Adena);
	if((ResultID <= 0))
	{
		DialogHide();
		DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemString(5091));
		DialogSetID(5555);
	}
	else
	{
		weaponItemInfo = TempDropItemInfo;
		WeaponItemSlot.SetItem(0, weaponItemInfo);
		WeaponItemSlot.AddItem(weaponItemInfo);
		DropHighlight_WeaponItem.SetTexture("L2UI_ch3.RefineryWnd.refineslot2");
		DropHighlight_LookItem.ShowWindow();
		StoneItemSlotBackTex.HideWindow();
		WeaponItemSlotBackTex.HideWindow();
		if((int(eShapeShiftingWindow) == 3))
		{
			EnchantBtn.EnableWindow();
			InstructionTxt.SetText(MakeFullSystemMsg(GetSystemMessage(6075), weaponItemInfo.Name));
		}
		else
		{
			InstructionTxt.SetText(GetSystemString(5089));
		}
		mPriceAdena = Adena;
		AdenaText.SetText(string(mPriceAdena));
	}
	return;
}

function HandletPutSupportItemResult(string param)
{
	local string StartTxt;
	local int ResultID;

	ParseInt(param, "Result", ResultID);
	if((ResultID <= 0))
	{
		DialogHide();
		DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemString(5092));
		DialogSetID(5555);
	}
	else
	{
		LookWeaponItemInfo = TempDropItemInfo;
		LookItemSlot.SetItem(0, LookWeaponItemInfo);
		LookItemSlot.AddItem(LookWeaponItemInfo);
		DropHighlight_LookItem.SetTexture("L2UI_ch3.RefineryWnd.refineslot2");
		StoneItemSlotBackTex.HideWindow();
		WeaponItemSlotBackTex.HideWindow();
		LookItemSlotBackTex.HideWindow();
		EnchantBtn.EnableWindow();
		if((int(eShapeShiftingWindow) == 2))
		{
			StartTxt = MakeFullSystemMsg(GetSystemMessage(6076), weaponItemInfo.Name);
		}
		else
		{
			StartTxt = MakeFullSystemMsg(GetSystemMessage(6075), weaponItemInfo.Name);
		}
		InstructionTxt.SetText(StartTxt);
	}
	return;
}

function HandleLookChangeResult(string param)
{
	local int IntResult, CurrentPeriod;
	local ItemID WeaponItemID, LookWeaponItemID;
	local ItemInfo cResultWeaponItemID;
	local string endTxt;

	EnchantProgressAnim.HideWindow();
	ParseInt(param, "Result", IntResult);
	ParseInt(param, "WeaponClassID", WeaponItemID.ClassID);
	ParseInt(param, "LookWeaponClassID", LookWeaponItemID.ClassID);
	ParseInt(param, "CurrentPeriod", CurrentPeriod);
	inventoryWndScript.GetInventoryItemInfo(weaponItemInfo.Id, cResultWeaponItemID);
	LookItemSlotBackTex.HideWindow();
	WeaponItemSlotBackTex.HideWindow();
	EnchantedItemSlotBackTex.HideWindow();
	LookItemSlotBackTex.HideWindow();
	EnchantBtn.HideWindow();
	ExitBtn.HideWindow();
	switch(IntResult)
	{
		case 0:
			bItemLookChangedbool = true;
			EnchantProgressAnim.HideWindow();
			EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Failed_01");
			EnchantProgressAnim.SetLoopCount(1);
			EnchantProgressAnim.Stop();
			EnchantProgressAnim.Play();
			PlaySound("ItemSound3.enchant_fail");
			EnchantProgressAnim.ShowWindow();
			BackPattern.SetAlpha(0, 0.0000000);
			BackPattern.ShowWindow();
			BackPattern.SetAlpha(255, 2.0000000);
			EnchantedItemSlot.SetAlpha(0);
			EnchantedItemSlot.Clear();
			EnchantedItemSlot.AddItem(cResultWeaponItemID);
			EnchantedItemSlot.ShowWindow();
			EnchantedItemSlot.SetAlpha(255, 2.0000000);
			endTxt = MakeFullSystemMsg(GetSystemMessage(6078), cResultWeaponItemID.Name);
			InstructionTxt.SetText(endTxt);
			LookItemSlot.HideWindow();
			WeaponItemSlot.HideWindow();
			StoneItemSlot.HideWindow();
			LookItemSlot.HideWindow();
			break;
		case 1:
			bItemLookChangedbool = true;
			EnchantProgressAnim.HideWindow();
			EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Success_00");
			EnchantProgressAnim.SetLoopCount(1);
			EnchantProgressAnim.Stop();
			EnchantProgressAnim.Play();
			PlaySound("ItemSound3.enchant_success");
			EnchantProgressAnim.ShowWindow();
			BackPattern.SetAlpha(0, 0.0000000);
			BackPattern.ShowWindow();
			BackPattern.SetAlpha(255, 2.0000000);
			cResultWeaponItemID.CurrentPeriod = CurrentPeriod;
			cResultWeaponItemID.LookChangeItemID = LookWeaponItemID.ClassID;
			cResultWeaponItemID.LookChangeItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(LookWeaponItemID);
			if((cResultWeaponItemID.BodyPart == 28))
			{
				cResultWeaponItemID.LookChangeIconPanel = "BranchSys3.Icon.pannel_lookChange_All";
			}
			else
			{
				cResultWeaponItemID.LookChangeIconPanel = "BranchSys3.Icon.pannel_lookChange";
			}
			EnchantedItemSlot.SetAlpha(0);
			EnchantedItemSlot.Clear();
			EnchantedItemSlot.AddItem(cResultWeaponItemID);
			EnchantedItemSlot.ShowWindow();
			EnchantedItemSlot.SetAlpha(255, 2.0000000);
			endTxt = MakeFullSystemMsg(GetSystemMessage(6085), cResultWeaponItemID.Name, cResultWeaponItemID.LookChangeItemName);
			InstructionTxt.SetText(endTxt);
			LookItemSlot.HideWindow();
			WeaponItemSlot.HideWindow();
			StoneItemSlot.HideWindow();
			LookItemSlot.HideWindow();
			break;
		default:
			EnchantProgressAnim.HideWindow();
			if(!bItemLookChangedbool)
			{
				Me.HideWindow();
			}
			break;
	}
	OkBtn.ShowWindow();
	return;
}

function HandleRestorePutTargetItemResult(string param)
{
	local int ResultID;
	local INT64 Adena;

	ParseInt(param, "Result", ResultID);
	ParseINT64(param, "Adena", Adena);
	if((ResultID <= 0))
	{
		DialogHide();
		DialogShow(DialogModalType_Modalless, DialogType_Notice, GetSystemString(5093));
		DialogSetID(5555);
	}
	else
	{
		weaponItemInfo = TempDropItemInfo;
		RestoreItemSlot.SetItem(0, weaponItemInfo);
		RestoreItemSlot.AddItem(weaponItemInfo);
		DropHighlight_RestoreItem.SetTexture("L2UI_ch3.RefineryWnd.refineslot2");
		RestoreItemSlotBackTex.HideWindow();
		EnchantBtn.EnableWindow();
		mPriceAdena = Adena;
		AdenaText.SetText(string(mPriceAdena));
	}
	return;
}

function OnRestoreLookChangeStart()
{
	local Rect Item1Rect, Item2Rect, ResultRect;

	EnchantProgressAnim.SetLoopCount(1);
	EnchantProgressAnim.Stop();
	EnchantProgressAnim.Play();
	PlaySound("ItemSound3.enchant_process");
	EnchantProgressAnim.ShowWindow();
	bItemLookChangebool = true;
	m_hItemLookChangeWndEnchantProgress.Start();
	Item1Rect = RestoreItemSlot.GetRect();
	Item2Rect = WeaponItemSlot.GetRect();
	ResultRect = EnchantedItemSlot.GetRect();
	RestoreItemSlot.Move((ResultRect.nX - Item1Rect.nX), (ResultRect.nY - Item1Rect.nY), 1.5000000);
	WeaponItemSlot.Move((ResultRect.nX - Item2Rect.nX), (ResultRect.nY - Item2Rect.nY), 1.5000000);
	RestoreItemSlotBackTex.HideWindow();
	WeaponItemSlotBackTex.HideWindow();
	RestoreSlotTxt.HideWindow();
	ExitBtn.SetNameText(GetSystemString(141));
	EnchantBtn.SetNameText(GetSystemString(428));
	return;
}

function HandlerRestoreLookChangeResult(string param)
{
	local int IntResult;
	local ItemID WeaponItemID;
	local ItemInfo cResultWeaponItemID;
	local string endTxt;

	EnchantProgressAnim.HideWindow();
	ParseInt(param, "Result", IntResult);
	ParseInt(param, "WeaponClassID", WeaponItemID.ClassID);
	inventoryWndScript.GetInventoryItemInfo(weaponItemInfo.Id, cResultWeaponItemID);
	EnchantBtn.HideWindow();
	ExitBtn.HideWindow();
	switch(IntResult)
	{
		case 0:
			bItemLookChangedbool = true;
			EnchantProgressAnim.HideWindow();
			EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Failed_01");
			EnchantProgressAnim.SetLoopCount(1);
			EnchantProgressAnim.Stop();
			EnchantProgressAnim.Play();
			PlaySound("ItemSound3.enchant_fail");
			EnchantProgressAnim.ShowWindow();
			BackPattern.SetAlpha(0, 0.0000000);
			BackPattern.ShowWindow();
			BackPattern.SetAlpha(255, 2.0000000);
			EnchantedItemSlot.SetAlpha(0);
			EnchantedItemSlot.Clear();
			EnchantedItemSlot.AddItem(cResultWeaponItemID);
			EnchantedItemSlot.ShowWindow();
			EnchantedItemSlot.SetAlpha(255, 2.0000000);
			endTxt = MakeFullSystemMsg(GetSystemMessage(6078), cResultWeaponItemID.Name);
			InstructionTxt.SetText(endTxt);
			LookItemSlot.HideWindow();
			WeaponItemSlot.HideWindow();
			WeaponItemSlot.HideWindow();
			RestoreItemSlot.HideWindow();
			break;
		case 1:
			bItemLookChangedbool = true;
			EnchantProgressAnim.HideWindow();
			EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Success_00");
			EnchantProgressAnim.SetLoopCount(1);
			EnchantProgressAnim.Stop();
			EnchantProgressAnim.Play();
			PlaySound("ItemSound3.enchant_success");
			EnchantProgressAnim.ShowWindow();
			BackPattern.SetAlpha(0, 0.0000000);
			BackPattern.ShowWindow();
			BackPattern.SetAlpha(255, 2.0000000);
			if((cResultWeaponItemID.LookChangeItemID > 0))
			{
				cResultWeaponItemID.CurrentPeriod = 0;
			}
			cResultWeaponItemID.LookChangeItemID = 0;
			cResultWeaponItemID.LookChangeItemName = "";
			cResultWeaponItemID.LookChangeIconID = 0;
			cResultWeaponItemID.LookChangeIconPanel = "";
			EnchantedItemSlot.Clear();
			EnchantedItemSlot.AddItem(cResultWeaponItemID);
			endTxt = MakeFullSystemMsg(GetSystemMessage(6086), cResultWeaponItemID.Name);
			InstructionTxt.SetText(endTxt);
			EnchantedItemSlot.SetAlpha(0);
			EnchantedItemSlot.ShowWindow();
			EnchantedItemSlot.SetAlpha(255, 2.0000000);
			WeaponItemSlot.HideWindow();
			RestoreItemSlot.HideWindow();
			break;
		default:
			break;
	}
	OkBtn.ShowWindow();
	return;
}

function SetIsShopping(bool isShopping)
{
	bIsShopping = isShopping;
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	OnClickButton("ExitBtn");
	return;
}
