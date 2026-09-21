class ItemLockWnd extends UICommonAPI;

const C_ANIMLOOPCOUNT = 1;

enum WindowType
{
	Lock,                           // 0
	UNLOCK,                         // 1
	Error                           // 2
};

enum StateStep
{
	Start,                          // 0
	READY,                          // 1
	POPUP,                          // 2
	Progress,                       // 3
	End                             // 4
};

var WindowHandle Me;
var TextBoxHandle Instruction_Txt;
var TextBoxHandle ItemName_Txt;
var TextBoxHandle ItemLockPaperTitle_txt;
var TextBoxHandle ItemUnLockPaperTitle_txt;
var TextBoxHandle ItemLockPaperinput_txt;
var ItemWindowHandle ItemLock_ItemWindow;
var ProgressCtrlHandle itemLock_Progress;
var ProgressCtrlHandle itemUnLock_Progress;
var ProgressCtrlHandle currentProgress;
var ButtonHandle ItemLockBtn;
var WindowHandle ItemLockAlert_Wnd;
var WindowHandle disableWnd;
var WindowHandle SubWnd;
var ItemLockSubWnd ItemLockSubWndScript;
var TextureHandle DropHighlight_ItemLock_AniPanel;
var WindowType currentWindowType;
var StateStep CurrentState;
var int currentScrollItemClassID;
var INT64 currentScrollNum;
var InventoryWnd inventoryWndScript;

function Initialize()
{
	CurrentState = Start;
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Me = GetWindowHandle("ItemLockWnd");
	Instruction_Txt = GetTextBoxHandle("ItemLockWnd.Instruction_Txt");
	ItemName_Txt = GetTextBoxHandle("ItemLockWnd.ItemName_Txt");
	ItemLockPaperTitle_txt = GetTextBoxHandle("ItemLockWnd.ItemLockPaperTitle_txt");
	ItemUnLockPaperTitle_txt = GetTextBoxHandle("ItemLockWnd.ItemUnLockPaperTitle_txt");
	ItemLock_ItemWindow = GetItemWindowHandle("ItemLockWnd.ItemLock_ItemWindow");
	itemLock_Progress = GetProgressCtrlHandle("ItemLockWnd.itemLock_Progress");
	itemUnLock_Progress = GetProgressCtrlHandle("ItemLockWnd.itemUnLock_Progress");
	ItemLockBtn = GetButtonHandle("ItemLockWnd.ItemLockBtn");
	disableWnd = GetWindowHandle("ItemLockWnd.DisableWnd");
	ItemLockAlert_Wnd = GetWindowHandle("ItemLockWnd.ItemLockAlert_Wnd");
	ItemLockPaperinput_txt = GetTextBoxHandle("ItemLockWnd.ItemLockPaperinput_txt");
	SubWnd = GetWindowHandle("ItemLockSubWnd");
	ItemLockSubWndScript = ItemLockSubWnd(GetScript("ItemLockSubWnd"));
	DropHighlight_ItemLock_AniPanel = GetTextureHandle("ItemLockWnd.DropHighlight_ItemLock_AniPanel");
	inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
	if(getInstanceUIData().GetIsClassicServer())
	{
		GetButtonHandle("ItemLockWnd.BtnWindowHelp").HideWindow();
	}
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(11000);
	RegisterEvent(11010);
	return;
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	Initialize();
	setWindowByType();
	handleState();
	SubWnd.ShowWindow();
	return;
}

function OnHide()
{
	switch(currentWindowType)
	{
		case Lock:
			RequestLockedItemCancel();
			break;
		case UNLOCK:
			RequestUnlockedItemCancel();
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
		case "ItemLockBtn":
			switch(CurrentState)
			{
				case READY:
					if((int(currentWindowType) == 0))
					{
						CurrentState = POPUP;
					}
					else
					{
						CurrentState = Progress;
					}
					break;
				case Progress:
					CurrentState = READY;
					break;
				case End:
					scrollItemReuse();
					break;
				default:
					break;
			}
			break;
		case "AlertWnd_Confirm_Btn":
			CurrentState = Progress;
			break;
		case "AlertWnd_Close_Btn":
			CurrentState = READY;
			break;
		case "BtnWindowHelp":
			ExecuteEvent(1210, "131");
			return;
			break;
		default:
			break;
	}
	handleState();
	return;
}

function scrollItemReuse()
{
	local ItemInfo outinfo;
	local ItemID Id;

	Id.ClassID = currentScrollItemClassID;
	inventoryWndScript.GetInventoryItemInfo(Id, outinfo, true);
	RequestUseItem(outinfo.Id);
	return;
}

function OnDropItem(string a_WindowID, ItemInfo a_itemInfo, int X, int Y)
{
	if((a_itemInfo.DragSrcName != "ItemLockSubWnd_Item1"))
	{
		return;
	}
	SetItemInfo(a_itemInfo);
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 11000:
			SetShow(param);
			break;
		case 11010:
			handleResult(param);
			handleState();
			break;
		default:
			break;
	}
	return;
}

function OnProgressTimeUp(string strID)
{
	switch(strID)
	{
		case "itemLock_Progress":
			RequestLockedItem(getCurrentItemServerID());
			ItemLockBtn.DisableWindow();
			break;
		case "itemUnLock_Progress":
			RequestUnlockedItem(getCurrentItemServerID());
			ItemLockBtn.DisableWindow();
			break;
		default:
			break;
	}
	return;
}

function setScrollNum(int ClassID)
{
	currentScrollNum = inventoryWndScript.getItemCountByClassID(ClassID);
	if((currentScrollNum == INT64(0)))
	{
		ItemLockPaperinput_txt.SetTextColor(getInstanceL2Util().DRed);
	}
	else
	{
		ItemLockPaperinput_txt.SetTextColor(getInstanceL2Util().White);
	}
	ItemLockPaperinput_txt.SetText(string(currentScrollNum));
	return;
}

function SetItemInfo(ItemInfo a_itemInfo)
{
	if(((int(CurrentState) != 0) && (int(CurrentState) != 1)))
	{
		return;
	}
	ItemLock_ItemWindow.SetItem(0, a_itemInfo);
	ItemLock_ItemWindow.AddItem(a_itemInfo);
	ItemName_Txt.SetText(GetItemNameAll(a_itemInfo));
	DropHighlight_ItemLock_AniPanel.HideWindow();
	CurrentState = READY;
	handleState();
	return;
}

function SetShow(string param)
{
	local string LockType;

	ParseString(param, "LockType", LockType);
	switch(LockType)
	{
		case "Error":
			currentWindowType = Error;
			Me.HideWindow();
			break;
		case "UnLock":
			currentWindowType = UNLOCK;
			if(Me.IsShowWindow())
			{
				OnShow();
			}
			Me.ShowWindow();
			break;
		case "Lock":
			currentWindowType = Lock;
			if(Me.IsShowWindow())
			{
				OnShow();
			}
			Me.ShowWindow();
			break;
		default:
			break;
	}
	ParseInt(param, "ScrollItemClassID", currentScrollItemClassID);
	setScrollNum(currentScrollItemClassID);
	return;
}

function handleClearItem()
{
	ItemLock_ItemWindow.Clear();
	ItemName_Txt.SetText("");
	DropHighlight_ItemLock_AniPanel.ShowWindow();
	return;
}

function setWindowByType()
{
	if((int(currentWindowType) == 0))
	{
		itemUnLock_Progress.HideWindow();
		setWindowTitleByString(GetSystemString(3770));
		ItemLockPaperTitle_txt.SetText(GetSystemString(3772));
		ItemLockPaperTitle_txt.SetTextColor(GetColor(255, 153, 0, 255));
		currentProgress = itemLock_Progress;
	}
	else
	{
		itemLock_Progress.HideWindow();
		setWindowTitleByString(GetSystemString(3771));
		ItemLockPaperTitle_txt.SetText(GetSystemString(3773));
		ItemUnLockPaperTitle_txt.ShowWindow();
		ItemLockPaperTitle_txt.SetTextColor(GetColor(136, 255, 255, 255));
		currentProgress = itemUnLock_Progress;
	}
	currentProgress.ShowWindow();
	return;
}

function handleState()
{
	setWindowByState();
	setButtonByState();
	setWindowInstruction();
	return;
}

function setWindowByState()
{
	switch(CurrentState)
	{
		case Start:
			hideAlert();
			handleClearItem();
			ItemLockSubWndScript.syncInventory();
			ItemLockSubWndScript.setLock(false);
		case READY:
			currentProgress.Reset();
			hideAlert();
			ItemLockSubWndScript.setLock(false);
			break;
		case POPUP:
			showAlert();
			break;
		case Progress:
			ItemLockSubWndScript.setLock(true);
			PlaySound("ItemSound3.enchant_process");
			currentProgress.SetProgressTime(1500);
			currentProgress.Reset();
			currentProgress.Start();
			hideAlert();
			break;
		case End:
			ItemLockSubWndScript.syncInventory();
			ItemLockSubWndScript.setLock(true);
			break;
		default:
			break;
	}
	return;
}

function setButtonByState()
{
	local int buttonString;

	if((int(currentWindowType) == 0))
	{
		switch(CurrentState)
		{
			case Start:
				buttonString = 3774;
				ItemLockBtn.DisableWindow();
				break;
			case READY:
				buttonString = 3774;
				ItemLockBtn.EnableWindow();
				break;
			case Progress:
				buttonString = 141;
				break;
			case End:
				buttonString = 1731;
				if((currentScrollNum > INT64(0)))
				{
					ItemLockBtn.EnableWindow();
				}
				break;
			default:
				return;
		}
	}
	else
	{
		switch(CurrentState)
		{
			case Start:
				buttonString = 3808;
				ItemLockBtn.DisableWindow();
				break;
			case READY:
				buttonString = 3808;
				ItemLockBtn.EnableWindow();
				break;
			case Progress:
				buttonString = 141;
				break;
			case End:
				buttonString = 1731;
				if((currentScrollNum > INT64(0)))
				{
					ItemLockBtn.EnableWindow();
				}
				break;
			default:
				return;
		}
	}
	ItemLockBtn.SetButtonName(buttonString);
	return;
}

function setWindowInstruction()
{
	local int systemMessage;

	if((int(currentWindowType) == 0))
	{
		switch(CurrentState)
		{
			case Start:
				systemMessage = 5129;
				break;
			case READY:
				systemMessage = 5130;
				break;
			case End:
				systemMessage = 5121;
				break;
			default:
				return;
		}
	}
	else
	{
		switch(CurrentState)
		{
			case Start:
				systemMessage = 5132;
				break;
			case READY:
				systemMessage = 5133;
				break;
			case End:
				systemMessage = 5122;
				break;
			default:
				return;
		}
	}
	Instruction_Txt.SetText(GetSystemMessage(systemMessage));
	return;
}

function showAlert()
{
	disableWnd.ShowWindow();
	ItemLockAlert_Wnd.ShowWindow();
	return;
}

function hideAlert()
{
	disableWnd.HideWindow();
	ItemLockAlert_Wnd.HideWindow();
	return;
}

function int getCurrentItemServerID()
{
	local ItemInfo Info;

	ItemLock_ItemWindow.GetItem(0, Info);
	if(IsValidItemID(Info.Id))
	{
		return Info.Id.ServerID;
	}
	return -1;
}

function handleResult(string param)
{
	local int Result;
	local ItemInfo Info;

	ParseInt(param, "Result", Result);
	if((Result == 0))
	{
		Me.HideWindow();
	}
	else
	{
		ItemLock_ItemWindow.GetItem(0, Info);
		Info.bSecurityLock = (int(currentWindowType) == 0);
		ItemLock_ItemWindow.SetItem(0, Info);
		ItemLock_ItemWindow.AddItem(Info);
		switch(currentWindowType)
		{
			case Lock:
				AddSystemMessage(5121);
				break;
			case UNLOCK:
				AddSystemMessage(5122);
				break;
			default:
				break;
		}
		setScrollNum(currentScrollItemClassID);
		PlaySound("ItemSound3.enchant_success");
		CurrentState = End;
	}
	return;
}

function RequestLockedItem(int TargetItemID)
{
	Class'NWindow.EnchantAPI'.static.RequestLockedItem(TargetItemID);
	return;
}

function RequestUnlockedItem(int TargetItemID)
{
	Class'NWindow.EnchantAPI'.static.RequestUnlockedItem(TargetItemID);
	return;
}

function RequestUnlockedItemCancel()
{
	Class'NWindow.EnchantAPI'.static.RequestUnlockedItemCancel();
	return;
}

function RequestLockedItemCancel()
{
	Class'NWindow.EnchantAPI'.static.RequestLockedItemCancel();
	return;
}

function ToggleShowWindow()
{
	if(Me.IsShowWindow())
	{
		Me.HideWindow();
	}
	else
	{
		Me.ShowWindow();
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("ItemLockWnd").HideWindow();
	return;
}
