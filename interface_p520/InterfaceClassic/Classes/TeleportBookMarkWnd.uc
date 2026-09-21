class TeleportBookMarkWnd extends UICommonAPI;

const TEMPLATEICONNAME = "L2ui_ct1.TeleportBookMark_DF_Icon_";

var WindowHandle Me;
var WindowHandle BookMarkEditWnd;
var TextBoxHandle txtTeleportLoc;
var ItemWindowHandle ItemBookMarkItem;
var TextBoxHandle txtSlotAvailability;
var TextBoxHandle txtSavedTeleportList;
var TextBoxHandle txtRequiredItemCount;
var ButtonHandle ItemDelete;
var ButtonHandle ItemEdit;
var ButtonHandle btnSaveMyLoc;
var TeleportBookMarkDrawerWnd m_Script;
var TextBoxHandle txtNoticeMessage;
var TextBoxHandle txtNoticeMessage2;
var TextureHandle TexDeactivated;
var ItemID m_CurBookMarkItemID;
var ItemID m_DeleteBookMarkItemID;
var int m_totalableSlotNum;

event OnShow()
{
	if(Class'NWindow.UIDATA_PLAYER'.static.IsInPrison())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13773));
		Me.HideWindow();
		return;
	}
	if(getInstanceL2Util().checkIsPrologueGrowType(string(self)))
	{
		return;
	}
	Class'NWindow.BookMarkAPI'.static.RequestBookMarkSlotInfo();
	Class'NWindow.BookMarkAPI'.static.RequestShowBookMark();
	GetTeleportItemCnt();
	Me.SetFocus();
	return;
}

function GetTeleportItemCnt()
{
	txtSavedTeleportList.SetText(MakeFullSystemMsg(GetSystemMessage(2360), string(GetTeleportBookMarkCount()), ""));
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	InitializeCOD();
	Load();
	txtNoticeMessage.ShowWindow();
	txtNoticeMessage2.ShowWindow();
	ClearItemID(m_CurBookMarkItemID);
	return;
}

function InitializeCOD()
{
	Me = GetWindowHandle("TeleportBookMarkWnd");
	BookMarkEditWnd = GetWindowHandle("TeleportBookMarkDrawerWnd");
	txtTeleportLoc = GetTextBoxHandle("TeleportBookMarkWnd.txtTeleportLoc");
	ItemBookMarkItem = GetItemWindowHandle("TeleportBookMarkWnd.ItemBookMarkItem");
	txtSlotAvailability = GetTextBoxHandle("TeleportBookMarkWnd.txtSlotAvailability");
	txtSavedTeleportList = GetTextBoxHandle("TeleportBookMarkWnd.txtSavedTeleportList");
	txtRequiredItemCount = GetTextBoxHandle("TeleportBookMarkWnd.txtRequiredItemCount");
	ItemDelete = GetButtonHandle("TeleportBookMarkWnd.ItemDelete");
	ItemEdit = GetButtonHandle("TeleportBookMarkWnd.ItemEdit");
	btnSaveMyLoc = GetButtonHandle("TeleportBookMarkWnd.btnSaveMyLoc");
	TexDeactivated = GetTextureHandle("TeleportBookMarkWnd.TexDeactivated");
	txtNoticeMessage = GetTextBoxHandle("TeleportBookMarkWnd.txtNoticeMessage");
	txtNoticeMessage2 = GetTextBoxHandle("TeleportBookMarkWnd.txtNoticeMessage2");
	m_Script = TeleportBookMarkDrawerWnd(GetScript("TeleportBookMarkDrawerWnd"));
	return;
}

event Load()
{
	ClearItemID(m_CurBookMarkItemID);
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(1710);
	RegisterEvent(3450);
	RegisterEvent(3451);
	RegisterEvent(2420);
	RegisterEvent(580);
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "btnSaveMyLoc":
			OnbtnSaveMyLocClick();
			break;
		default:
			break;
	}
	return;
}

event OnEvent(int Event_ID, string param)
{
	local int SystemMsgIndex;

	if((Event_ID == 3450))
	{
		HandleBookMarkList(param);
	}
	else if((Event_ID == 1710))
	{
		if(DialogIsMine())
		{
			if(IsValidItemID(m_DeleteBookMarkItemID))
			{
				Class'NWindow.BookMarkAPI'.static.RequestDeleteBookMarkSlot(m_DeleteBookMarkItemID);
				ClearItemID(m_DeleteBookMarkItemID);
			}
		}
	}
	else if((Event_ID == 2420))
	{
		GetTeleportItemCnt();
	}
	else if((Event_ID == 3451))
	{
		OpenWindow();
	}
	else if((Event_ID == 580))
	{
		ParseInt(param, "Index", SystemMsgIndex);
		HandleUpdateItemCountSystemMessage(SystemMsgIndex);
	}
	return;
}

function HandleUpdateItemCountSystemMessage(int Index)
{
	switch(Index)
	{
		case 301:
		case 302:
		case 301:
		case 377:
			GetTeleportItemCnt();
			break;
		default:
			break;
	}
	return;
}

function OpenWindow()
{
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

event OnDropItem(string strID, ItemInfo formInfItem, int X, int Y)
{
	switch(strID)
	{
		case "ItemDelete":
			OnDeleteBookMarkSlot(formInfItem);
			break;
		case "ItemEdit":
			OnModifyBookMarkSlot(formInfItem);
			break;
		case "ItemBookMarkItem":
			handleSwap(formInfItem, X, Y);
			break;
		default:
			break;
	}
	return;
}

event OnTick()
{
	Me.DisableTick();
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("MiniMapGfxWnd");
	GetWindowHandle("ActionWnd").HideWindow();
	return;
}

function handleSwap(ItemInfo formInfItem, int X, int Y)
{
	local int toIndex, fromIndex;
	local ItemInfo toItemInfo;

	if((formInfItem.DragSrcName != "ItemBookMarkItem"))
	{
		return;
	}
	toIndex = ItemBookMarkItem.GetIndexAt(X, Y, 1, 1);
	if((toIndex >= 0))
	{
		fromIndex = ItemBookMarkItem.FindItem(formInfItem.Id);
		if((toIndex != fromIndex))
		{
			ItemBookMarkItem.GetItem(toIndex, toItemInfo);
			formInfItem.Id.ClassID = (fromIndex + 1);
			toItemInfo.Id.ClassID = (toIndex + 1);
			Class'NWindow.BookMarkAPI'.static.RequestChangeBookMarkSlot(formInfItem.Id, toItemInfo.Id);
		}
	}
	return;
}

function SetUnActiveSlots()
{
	TexDeactivated.ShowWindow();
	return;
}

function HandleBookMarkList(string param)
{
	local int idx, ableSlotNum, curSlotNum, IconID;
	local string strSlotTitle, strIconTitle;
	local ItemInfo infItem, ClearItem;
	local int emptySlot;
	local Vector Loc;

	ClearItemID(ClearItem.Id);
	ClearItem.IconName = "L2ui_ct1.emptyBtn";
	Clear();
	ParseInt(param, "Count", ableSlotNum);
	curSlotNum = 0;
	m_totalableSlotNum = ableSlotNum;
	if((ableSlotNum == 0))
	{
		txtNoticeMessage.ShowWindow();
		txtNoticeMessage2.ShowWindow();
		TexDeactivated.ShowWindow();
		SetUnActiveSlots();
	}
	else
	{
		txtNoticeMessage.HideWindow();
		txtNoticeMessage2.HideWindow();
		TexDeactivated.HideWindow();
	}
	idx = 0;
	while((idx < ableSlotNum))
	{
		strSlotTitle = "";
		strIconTitle = "";
		ParseInt(param, ("EmptySlot_" $ string(idx)), emptySlot);
		if((emptySlot == 1))
		{
			ItemBookMarkItem.AddItem(ClearItem);
			++idx;
			continue;
		}
		ParseItemIDWithIndex(param, infItem.Id, idx);
		ParseString(param, ("SlotName_" $ string(idx)), strSlotTitle);
		ParseInt(param, ("IconID_" $ string(idx)), IconID);
		ParseString(param, ("IconName_" $ string(idx)), strIconTitle);
		ParseFloat(param, ("XPos_" $ string(idx)), Loc.X);
		ParseFloat(param, ("YPos_" $ string(idx)), Loc.Y);
		ParseFloat(param, ("ZPos_" $ string(idx)), Loc.Z);
		infItem.Name = strSlotTitle;
		infItem.AdditionalName = strIconTitle;
		infItem.IconName = ("L2ui_ct1.TeleportBookMark_DF_Icon_" $ itoStr(IconID));
		infItem.Description = strIconTitle;
		infItem.ShortcutType = 6;
		ItemBookMarkItem.AddItem(infItem);
		curSlotNum++;
		++idx;
	}
	SetBookMarkCount(ableSlotNum, curSlotNum);
	return;
}

function OnDeleteBookMarkSlot(ItemInfo infItem)
{
	local string strMsg;

	if((infItem.ShortcutType != 6))
	{
		return;
	}
	strMsg = MakeFullSystemMsg(GetSystemMessage(2362), infItem.Name, "");
	m_DeleteBookMarkItemID = infItem.Id;
	DialogShow(DialogModalType_Modalless, DialogType_Warning, strMsg);
	return;
}

function OnModifyBookMarkSlot(ItemInfo infItem)
{
	local Vector Loc;

	m_Script.txtTeleportBookMarkDrawerWndNameHead.SetText(GetSystemString(1762));
	if((infItem.ShortcutType != 6))
	{
		return;
	}
	m_CurBookMarkItemID = infItem.Id;
	Class'NWindow.UIAPI_EDITBOX'.static.SetString("TeleportBookMarkDrawerWnd.EditCurrentSaveBookMarkName", infItem.Name);
	Class'NWindow.UIAPI_EDITBOX'.static.SetString("TeleportBookMarkDrawerWnd.EditCurrentSaveBookMarkIcn", infItem.AdditionalName);
	Class'NWindow.BookMarkAPI'.static.RequestGetBookMarkPos(infItem.Id, Loc);
	m_Script.m_CurIconNum = int(Right(infItem.IconName, 2));
	m_Script.ItemBookMarkItem.SetSelectedNum((m_Script.m_CurIconNum - 1));
	m_Script.UpdateIcon();
	if(!BookMarkEditWnd.IsShowWindow())
	{
		BookMarkEditWnd.ShowWindow();
		BookMarkEditWnd.SetFocus();
	}
	return;
}

function OnbtnSaveMyLocClick()
{
	ClearItemID(m_CurBookMarkItemID);
	if(BookMarkEditWnd.IsShowWindow())
	{
		BookMarkEditWnd.HideWindow();
	}
	else
	{
		m_Script.InitializeUI();
		m_Script.UpdateCurrentLocation();
		BookMarkEditWnd.ShowWindow();
		ShowGFXYellowPin(GetPlayerPosition(), GetSystemString(887));
	}
	GetTeleportItemCnt();
	return;
}

event OnHide()
{
	CallGFxFunction("MiniMapGfxWnd", "TeleportBookMarkWnd_HidePosition", "");
	return;
}

function Clear()
{
	ItemBookMarkItem.Clear();
	return;
}

event OnDBClickItem(string strID, int Index)
{
	local ItemInfo infItem;

	if(((strID == "ItemBookMarkItem") && (Index > -1)))
	{
		if(ItemBookMarkItem.GetItem(Index, infItem))
		{
			if((infItem.Id.ClassID > 0))
			{
				Class'NWindow.BookMarkAPI'.static.RequestTelePortBookMark(infItem.Id);
			}
		}
	}
	GetTeleportItemCnt();
	if(getInstanceUIData().GetIsClassicServer())
	{
		Me.EnableTick();
		Me.HideWindow();
	}
	return;
}

event OnClickItem(string strID, int Index)
{
	local ItemInfo infItem;
	local Vector Loc;

	if(((strID == "ItemBookMarkItem") && (Index > -1)))
	{
		if(ItemBookMarkItem.GetItem(Index, infItem))
		{
			if((infItem.Id.ClassID > 0))
			{
				Class'NWindow.BookMarkAPI'.static.RequestGetBookMarkPos(infItem.Id, Loc);
				ShowGFXYellowPin(Loc, infItem.Name);
			}
		}
	}
	GetTeleportItemCnt();
	return;
}

function SetBookMarkCount(int ableSlotNum, int curSlotNum)
{
	txtSlotAvailability.SetText((((("(" $ string(curSlotNum)) $ "/") $ string(ableSlotNum)) $ ")"));
	return;
}

function ShowGFXYellowPin(Vector XYZ, string TargetName)
{
	local string param;

	if((((XYZ.X == 0.0000000) && (XYZ.Y == 0.0000000)) && (XYZ.Z == 0.0000000)))
	{
		return;
	}
	param = "";
	ParamAdd(param, "X", string(XYZ.X));
	ParamAdd(param, "Y", string(XYZ.Y));
	ParamAdd(param, "Z", string(XYZ.Z));
	ParamAdd(param, "targetName", TargetName);
	ParamAdd(param, "questName", "");
	CallGFxFunction("MiniMapGfxWnd", "TeleportBookMarkWnd_ShowPoisition", param);
	return;
}

function AdjustToMyPosition()
{
	CallGFxFunction("MiniMapGfxWnd", "AdjustToMyPosition", "0");
	return;
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("TeleportBookMarkWnd").HideWindow();
	return;
}

function string itoStr(int tmpNum)
{
	local string tmpStr;

	if((tmpNum < 10))
	{
		tmpStr = ("0" $ string(tmpNum));
	}
	else
	{
		tmpStr = string(tmpNum);
	}
	return tmpStr;
}
