class ItemEnchantWnd extends UICommonAPI
	dependson(UIPacket);

const STATE_NONE = 'stateNone';
const STATE_READY_SCROLL = 'stateReadyScroll';
const STATE_READY_EQUIPMENT = 'stateReadyEquipment';
const STATE_READY_SUPPORT = 'stateReadySupport';
const STATE_READY_SUPPORT_SYSTEM = 'stateReadySupportsystem';
const STATE_READY_SUPPORT_STONE = 'stateReadySupportstone';
const STATE_ENCHANT = 'stateEnchant';
const STATE_COMPLETE_BLIND = 'stateCompleteBlind';
const STATE_COMPLETE_RESULT = 'stateCompleteResult';
const STATE_COMPLETE_RESULT_FAIL = 'stateCompleteResultfail';
const PERMRIAD = 100f;

struct failchallangePointInfoStruct
{
	var int gropuID;
	var int point;
	var int rewardPnt;
};

var ButtonHandle EnchantBtn;
var ButtonHandle EnchantBtnAuto;
var ButtonHandle resetBtn;
var TextBoxHandle WarningTxt00;
var TextBoxHandle WarningTxt01;
var TextBoxHandle InstructionTxt;
var ItemWindowHandle scrollItemWindow;
var ItemWindowHandle equipmentItemWindow;
var ItemWindowHandle supportItemWindow;
var AnimTextureHandle ResultSlotani_Tex;
var ItemWindowHandle EnchantedItemSlot;
var WindowHandle supportItemListWnd;
var ItemWindowHandle supportItemWnds;
var WindowHandle supportSystemListWnd;
var TextureHandle supportSystemActiveImage;
var RichListCtrlHandle supportSystemList;
var ItemInfo requestedItemInfoScroll;
var ItemInfo requestedItemInfoEquipment;
var ItemInfo requestedItemInfoSupport;
var INT64 mEnchantItemType;
var EffectViewportWndHandle EnchantEffectViewport;
var ItemWindowHandle InventoryItem;
var L2UITimerObject timerObject;
var array<UIPacket._EnchantChallengePointInfo> vCurrentPointInfo;
var bool bIsShopping;
var bool bUsedTicket;
var EnchantScrollSetUIData enchantScrollData;
var bool isGreateSuccess;
var bool bWaitTargetItem;
var int enchantEffect;
var ItemEnchantGroupIDWnd groupIDWndScr;
var name prevState;
var name resultState;
var int SelectedSystemSupport;
var failchallangePointInfoStruct failChallangePointInfo;
var bool isAutoEnchanting;
var bool isAutoEnchantingStop;
var TextBoxHandle scrollItemNum;
var L2UITweenObject tObjectEnchantEffectItem_Wnd_Show;
var L2UITweenObject tObjectEnchantEffectItem_Wnd_Hide;
var ItemInfo targetItemInfo;

function HandleClickButtonEnchant()
{
	return;
}

function HandleClickButtonReset()
{
	return;
}

function bool CanUseAutoMode()
{
	local UIEventManager.EEtcItemType Type;

	Type = EEtcItemType(GetIteminfoScroll().EtcItemType);
	switch(Type)
	{
		case ITEME_ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_AM:
		case ITEME_ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_WP:
		case ITEME_ANCIENT_CRYSTAL_ENCHANT_AG:
			return true;
		default:
			return false;
	}
}

function SetAutoMode()
{
	EnchantBtn.SetAnchor(m_hOwnerWnd.m_WindowNameWithFullPath, "BottomCenter", "BottomCenter", 85, -7);
	EnchantBtnAuto.SetNameText(GetSystemString(14237));
	EnchantBtnAuto.EnableWindow();
	EnchantBtnAuto.ShowWindow();
	return;
}

function SetNormalMode()
{
	EnchantBtn.SetAnchor(m_hOwnerWnd.m_WindowNameWithFullPath, "BottomCenter", "BottomCenter", 0, -7);
	EnchantBtnAuto.HideWindow();
	return;
}

static function ItemEnchantWnd Inst()
{
	return ItemEnchantWnd(GetScript("ItemEnchantWnd"));
}

event OnRegisterEvent()
{
	RegisterEvent(50);
	RegisterEvent(2860);
	RegisterEvent(2865);
	RegisterEvent(2870);
	RegisterEvent(2880);
	RegisterEvent(2881);
	RegisterEvent(2882);
	RegisterEvent(2883);
	RegisterEvent(EV_PacketID(996));
	RegisterEvent(EV_PacketID(998));
	RegisterEvent(EV_PacketID(997));
	RegisterEvent(EV_PacketID(994));
	RegisterEvent(EV_PacketID(995));
	return;
}

event OnLoad()
{
	scrollItemWindow = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".scrollItemWnd.itemSlot"));
	equipmentItemWindow = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".equipmentItemWnd.itemSlot"));
	supportItemWindow = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportItemWnd.itemSlotSupport"));
	supportItemWnds = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportItemListWnd.supportItemWnds"));
	supportItemListWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportItemListWnd"));
	supportSystemActiveImage = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemWnd.ActiveImage"));
	supportSystemListWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemListWnd"));
	supportSystemList = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemListWnd.supportSystemList2Wnd.supportSystemList"));
	EnchantBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantBtn"));
	EnchantBtnAuto = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantBtnAuto"));
	resetBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ResetBtn"));
	EnchantedItemSlot = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd.EnchantedItemSlot"));
	InstructionTxt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".InstructionTxt"));
	WarningTxt00 = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".WarningTxt00"));
	WarningTxt01 = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".WarningTxt01"));
	scrollItemNum = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".scrollItemNum"));
	EnchantEffectViewport = GetEffectViewportWndHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectViewport"));
	EnchantEffectViewport.SetCameraPitch(0);
	EnchantEffectViewport.SetCameraYaw(0);
	InventoryItem = GetItemWindowHandle("InventoryWnd.InventoryItem");
	timerObject = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject();
	SetGrouIDWnd();
	GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_Wnd.Fail_Wnd.FailGetItme_RichList")).SetSelectedSelTooltip(false);
	GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_Wnd.Fail_Wnd.FailGetItme_RichList")).SetAppearTooltipAtMouseX(true);
	GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_Wnd.Fail_Wnd.FailGetItme_RichList")).SetSelectable(false);
	SetLoadEnchantEffectItem_Wnd();
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".FailprdctItem_wnd")).HideWindow();
	SetClosingOnESC();
	return;
}

function SetLoadEnchantEffectItem_Wnd()
{
	local Rect rectWnd;

	tObjectEnchantEffectItem_Wnd_Show = new Class'Interface.L2UITweenObject';
	tObjectEnchantEffectItem_Wnd_Hide = new Class'Interface.L2UITweenObject';
	tObjectEnchantEffectItem_Wnd_Show.Owner = m_hOwnerWnd.m_WindowNameWithFullPath;
	tObjectEnchantEffectItem_Wnd_Hide.Owner = m_hOwnerWnd.m_WindowNameWithFullPath;
	tObjectEnchantEffectItem_Wnd_Show.Target = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectItem_Wnd"));
	tObjectEnchantEffectItem_Wnd_Hide.Target = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectItem_Wnd"));
	tObjectEnchantEffectItem_Wnd_Show.Duration = 500.0000000;
	tObjectEnchantEffectItem_Wnd_Hide.Duration = 500.0000000;
	tObjectEnchantEffectItem_Wnd_Show.Alpha = 255.0000000;
	tObjectEnchantEffectItem_Wnd_Hide.Alpha = -255.0000000;
	tObjectEnchantEffectItem_Wnd_Show.Id = 1000;
	tObjectEnchantEffectItem_Wnd_Hide.Id = 1001;
	tObjectEnchantEffectItem_Wnd_Show.ease = OUT_STRONG;
	tObjectEnchantEffectItem_Wnd_Hide.ease = IN_STRONG;
	tObjectEnchantEffectItem_Wnd_Show._DelegateOnStart = OnDelegateOnStart;
	tObjectEnchantEffectItem_Wnd_Hide._DelegateOnEnd = OnDelegateOnEnd;
	rectWnd = tObjectEnchantEffectItem_Wnd_Show.Target.GetRect();
	tObjectEnchantEffectItem_Wnd_Show.Target.MoveTo((rectWnd.nX - 25), rectWnd.nY);
	return;
}

function OnDelegateOnStart(L2UITweenObject tObject)
{
	switch(tObject.Id)
	{
		case 1000:
			tObject.Target.ShowWindow();
			break;
		default:
			break;
	}
	return;
}

function OnDelegateOnEnd(L2UITweenObject tObject)
{
	switch(tObject.Id)
	{
		case 1001:
			tObject.Target.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function SetGrouIDWnd()
{
	groupIDWndScr = ItemEnchantGroupIDWnd(GetScript("GroupIDWnd_ItmeEnchantWnd"));
	groupIDWndScr._Init();
	return;
}

event OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	m_hOwnerWnd.SetFocus();
	WarningTxt00.SetText("");
	WarningTxt01.SetText("");
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
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemMultiEnchantWndTap_Btn")).EnableWindow();
	GetEffectViewportWndHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".MainBgEffectViewport")).SpawnEffect("LineageEffect2.ui_Enchant_bg");
	groupIDWndScr._CheckShowHide();
	ChkWindowSizeGroupID();
	m_hOwnerWnd.SetWindowSize(858, 542);
	PlaySound("Itemsound3.ui_enchant_open");
	SetEnchantEffectItemTitle();
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
	isAutoEnchanting = false;
	isAutoEnchantingStop = false;
	if(DialogIsMine())
	{
		DialogHide();
	}
	API_RequestExCancelEnchantItem();
	ClearTargetItem();
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "EnchantBtnAuto":
			if((GetStateName() == 'stateEnchant'))
			{
				HandleClickButtonEnchant();
			}
			else
			{
				HandleShowDialogAuto();
			}
			break;
		case "EnchantBtn":
			isAutoEnchanting = false;
			scrollItemNum.HideWindow();
			HandleClickButtonEnchant();
			break;
		case "ResetBtn":
			if(DialogIsMine())
			{
				DialogHide();
			}
			API_RequestExCancelEnchantItem();
			GotoState('stateReadyScroll');
			break;
		case "StoneActivBtn":
			ToggleSupportItemListWnd();
			break;
		case "SystemActivBtn":
		case "Close_Btn":
			ToggleSupportSystemListWndWnd();
			break;
		case "SystemActivBtnPoint":
			API_C_EX_SET_ENCHANT_CHALLENGE_POINT(false);
			break;
		case "SystemActivBtnTicket":
			API_C_EX_SET_ENCHANT_CHALLENGE_POINT(true);
			break;
		case "SystemResetBtn":
			API_C_EX_RESET_ENCHANT_CHALLENGE_POINT();
			break;
		case "EnchantEffect_BTN":
			HandleClickEnchantEffectItem();
			break;
		case "ItemMultiEnchantWndTap_Btn":
			SwapMultiEnchantWnd();
			break;
		case "PointBtn":
			groupIDWndScr._ToggleShowHide();
			ChkWindowSizeGroupID();
			break;
		case "WndClose_BTN":
			m_hOwnerWnd.HideWindow();
			break;
		case "Refresh_btn":
			SetSupportSystemList();
			break;
		case "LeftM_Btn":
			PrevEnchantEffectItem();
			break;
		case "RightM_Btn":
			NextEnchantEffectItem();
			break;
		default:
			break;
	}
	return;
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	local RichListCtrlRowData Record;

	supportSystemList.GetSelectedRec(Record);
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemListWnd.supportSystemList2Wnd.SystemActivBtnPoint")).EnableWindow();
	if(((Record.cellDataList[3].nReserved1 <= GetCurrentPoint()) && (Record.nReserved2 == INT64(1))))
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemListWnd.supportSystemList2Wnd.SystemActivBtnPoint")).EnableWindow();
	}
	else
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemListWnd.supportSystemList2Wnd.SystemActivBtnPoint")).DisableWindow();
	}
	if(((Record.cellDataList[4].nReserved1 > 0) && (Record.nReserved2 == INT64(1))))
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemListWnd.supportSystemList2Wnd.SystemActivBtnTicket")).EnableWindow();
	}
	else
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemListWnd.supportSystemList2Wnd.SystemActivBtnTicket")).DisableWindow();
	}
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 50:
			m_hOwnerWnd.HideWindow();
			break;
		case 2860:
			if(!bIsShopping)
			{
				GotoState('stateNone');
				HandleEnchantShow(param);
			}
			else
			{
				API_RequestExCancelEnchantItem();
			}
			break;
		case 2870:
			HandleEnchantResult(param);
			break;
		case 2880:
			HandlePutTargetItemResult(param);
			break;
		case 2881:
			HandlePutSupportItemResult(param);
			break;
		case 2883:
			HandleRemoveSupportItemResult(param);
			break;
		case 2882:
			HandlePutScrollResult(param);
			break;
		case EV_PacketID(996):
			Handle_S_EX_ENCHANT_CHALLENGE_POINT_INFO();
			break;
		case EV_PacketID(998):
			Handle_S_EX_RESET_ENCHANT_CHALLENGE_POINT();
			break;
		case EV_PacketID(997):
			Handle_S_EX_SET_ENCHANT_CHALLENGE_POINT();
			break;
		case EV_PacketID(994):
			Handle_S_EX_RES_ENCHANT_ITEM_FAIL_REWARD_INFO();
			break;
		case EV_PacketID(995):
			if(m_hOwnerWnd.IsShowWindow())
			{
				Handle_S_EX_CHANGED_ENCHANT_TARGET_ITEM_PROB_LIST();
			}
		default:
			break;
	}
	return;
}

event OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);
	return;
}

event OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo a_itemInfo;

	switch(ControlName)
	{
		case "itemSlotSupport":
			API_RequestExRemoveEnchantSupportItem();
			break;
		case "supportItemWnds":
			supportItemWnds.GetItem(Index, a_itemInfo);
			API_RequestExTryToPutEnchantSupportItem(a_itemInfo);
			break;
		default:
			break;
	}
	return;
}

event OnDropItem(string a_WindowID, ItemInfo a_itemInfo, int X, int Y)
{
	switch(a_itemInfo.DragSrcName)
	{
		case "supportItemWnds":
			API_RequestExTryToPutEnchantSupportItem(a_itemInfo);
			break;
		case "itemEnchantSubWndItemWnd":
			RequestInputItemInfo(a_itemInfo);
			break;
		default:
			RequestInputItemInfo(a_itemInfo);
			break;
	}
	return;
}

event OnDropItemSource(string strTarget, ItemInfo Info)
{
	if(((strTarget == "Console") || (GetStateName() == 'stateReadySupportstone')))
	{
		switch(Info.DragSrcName)
		{
			case "itemSlotSupport":
				API_RequestExRemoveEnchantSupportItem();
				break;
			default:
				break;
		}
	}
	return;
}

event OnMouseOut(WindowHandle W)
{
	switch(W.GetWindowName())
	{
		case "FailprdctItem_BTN":
			GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".FailprdctItem_wnd")).HideWindow();
			break;
		default:
			break;
	}
	return;
}

event OnMouseOver(WindowHandle W)
{
	switch(W.GetWindowName())
	{
		case "FailprdctItem_BTN":
			GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".FailprdctItem_wnd")).ShowWindow();
			break;
		default:
			break;
	}
	return;
}

function RequestInputItemInfo(ItemInfo iInfo)
{
	switch(GetStateName())
	{
		case 'stateReadyScroll':
			API_RequestExAddEnchantScrollItem(iInfo);
			break;
		case 'stateReadyEquipment':
		case 'stateReadySupport':
		case 'stateReadySupportstone':
		case 'stateReadySupportsystem':
			API_RequestExTryToPutEnchantTargetItem(iInfo);
			break;
		default:
			break;
	}
	return;
}

function HandleShowDialogAuto()
{
	local ItemInfo iInfo;

	iInfo = GetIteminfoScroll();
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(13787), iInfo.Name, MakeCostStringINT64(iInfo.ItemNum)));
	Class'Interface.DialogBox'.static.Inst().AnchorToOwner(0, 200);
	Class'Interface.DialogBox'.static.Inst().DelegateOnCancel = DialogResultCancel;
	Class'Interface.DialogBox'.static.Inst().DelegateOnOK = DialogResultOKAuto;
	Class'Interface.DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
	Class'Interface.ItemEnchantSubWnd'.static.Inst().m_hOwnerWnd.HideWindow();
	return;
}

function HandleShowDialog()
{
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, ((GetFailString() $ "\\n\\n") $ GetSystemString(2336)));
	Class'Interface.DialogBox'.static.Inst().AnchorToOwner(0, 200);
	Class'Interface.DialogBox'.static.Inst().DelegateOnCancel = DialogResultCancel;
	Class'Interface.DialogBox'.static.Inst().DelegateOnOK = DialogResultOK;
	Class'Interface.DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
	Class'Interface.ItemEnchantSubWnd'.static.Inst().m_hOwnerWnd.HideWindow();
	return;
}

function DialogResultOKAuto()
{
	isAutoEnchanting = true;
	scrollItemNum.SetText(((GetSystemString(5027) @ ":") @ MakeCostStringINT64(requestedItemInfoScroll.ItemNum)));
	HandleClickButtonEnchant();
	return;
}

function DialogResultOK()
{
	GotoState('stateEnchant');
	return;
}

function DialogResultCancel()
{
	m_hOwnerWnd.SetFocus();
	resetBtn.EnableWindow();
	EnchantBtn.EnableWindow();
	EnchantBtnAuto.EnableWindow();
	isAutoEnchanting = false;
	Class'Interface.ItemEnchantSubWnd'.static.Inst().m_hOwnerWnd.ShowWindow();
	return;
}

function bool IsAGScrollType()
{
	local UIEventManager.EEtcItemType Type;

	Type = EEtcItemType(GetIteminfoScroll().EtcItemType);
	return ((((int(Type) == 63) || (int(Type) == 64)) || (int(Type) == 65)) || (int(Type) == 66));
}

function SetTitleByItemType()
{
	if(IsAGScrollType())
	{
		setWindowTitleByString(GetSystemString(3639));
	}
	else
	{
		setWindowTitleByString(GetSystemString(1220));
	}
	return;
}

function HandleInstructionTxt()
{
	switch(GetStateName())
	{
		case 'stateReadyEquipment':
			if(IsAGScrollType())
			{
				InstructionTxt.SetText(GetSystemMessage(4504));
			}
			else
			{
				InstructionTxt.SetText(GetSystemMessage(2339));
			}
			break;
		case 'stateReadySupport':
		case 'stateReadySupportsystem':
		case 'stateReadySupportstone':
			if(IsAGScrollType())
			{
				if((int(byte(GetIteminfoScroll().EtcItemType)) == 64))
				{
					InstructionTxt.SetText(GetSystemMessage(4508));
				}
				else
				{
					InstructionTxt.SetText(GetSystemMessage(4505));
				}
			}
			else if(CanUseAutoMode())
			{
				InstructionTxt.SetText(GetSystemString(14239));
			}
			else
			{
				InstructionTxt.SetText(GetSystemString(13930));
			}
			break;
		case 'stateEnchant':
			InstructionTxt.SetText(GetSystemString(13931));
			break;
		case 'stateCompleteBlind':
		case 'stateCompleteResult':
		case 'stateCompleteResultfail':
			InstructionTxt.SetText(GetSystemString(13932));
			break;
		default:
			break;
	}
	return;
}

function CheckWarningTxt()
{
	WarningTxt00.SetText(GetSuccessString());
	WarningTxt01.SetText(GetFailString());
	return;
}

function string GetSuccessString()
{
	local int ramdonV;
	local UIEventManager.EEtcItemType EEtcItemType;
	local string successString, randomstring;

	EEtcItemType = EEtcItemType(GetIteminfoScroll().EtcItemType);
	ramdonV = GetRandomValue();
	if((ramdonV > 1))
	{
		randomstring = ("1~" $ string(ramdonV));
	}
	else
	{
		randomstring = "1";
	}
	if(((int(EEtcItemType) == 86) || (int(EEtcItemType) == 87)))
	{
		successString = MakeFullSystemMsg(GetSystemMessage(13630), randomstring);
	}
	else
	{
		successString = MakeFullSystemMsg(GetSystemMessage(13629), randomstring);
	}
	return successString;
}

function string GetFailStringNormal()
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
			if(IsInova())
			{
				crashString = MakeFullSystemMsg(GetSystemMessage(13626), GetSystemString(5979));
			}
			else
			{
				crashString = MakeFullSystemMsg(GetSystemMessage(13626), GetSystemString(479));
			}
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

function string GetFailString()
{
	local int Prob;
	local string crashString;
	local RichListCtrlRowData Record;

	switch(GetStateName())
	{
		case 'stateReadySupport':
			crashString = GetFailStringNormal();
			break;
		case 'stateReadySupportstone':
			crashString = GetSystemMessage(13650);
			break;
		case 'stateReadySupportsystem':
			if((SelectedSystemSupport > -1))
			{
				supportSystemList.GetRec(SelectedSystemSupport, Record);
				Prob = Record.cellDataList[1].nReserved1;
				if((Prob < 100))
				{
					switch(Record.nReserved1)
					{
						case INT64(3):
							crashString = MakeFullSystemMsg(GetSystemMessage(13651), string(Prob));
							break;
						case INT64(4):
							crashString = MakeFullSystemMsg(GetSystemMessage(13652), string(Prob));
							break;
						case INT64(5):
							crashString = MakeFullSystemMsg(GetSystemMessage(13653), string(Prob));
							break;
						default:
							crashString = GetFailStringNormal();
							break;
					}
				}
				else
				{
					switch(Record.nReserved1)
					{
						case INT64(3):
							if(IsInova())
							{
								crashString = MakeFullSystemMsg(GetSystemMessage(13626), GetSystemString(5979));
							}
							else
							{
								crashString = MakeFullSystemMsg(GetSystemMessage(13626), GetSystemString(479));
							}
							break;
						case INT64(4):
							crashString = MakeFullSystemMsg(GetSystemMessage(13627), "1");
							break;
						case INT64(5):
							if(IsInova())
							{
								crashString = MakeFullSystemMsg(GetSystemMessage(13626), GetSystemString(5980));
							}
							else
							{
								crashString = MakeFullSystemMsg(GetSystemMessage(13626), GetSystemString(2275));
							}
							break;
						default:
							crashString = GetFailStringNormal();
							break;
					}
				}
			}
			else
			{
				crashString = GetFailStringNormal();
			}
			break;
		default:
			break;
	}
	return crashString;
}

function HandlePutTargetItemResult(string param)
{
	local int ResultID;

	ParseInt(param, "Result", ResultID);
	if((ResultID == 0))
	{
		GotoState('stateReadyEquipment');
		return;
	}
	InputEquipmentItem();
	if(bWaitTargetItem)
	{
		API_RequestExTryToPutEnchantSupportItem(requestedItemInfoSupport);
	}
	return;
}

function HandlePutScrollResult(string param)
{
	local int ResultID;

	ParseInt(param, "Result", ResultID);
	if((ResultID == 0))
	{
		return;
	}
	InputScrollItem();
	return;
}

function HandlePutSupportItemResult(string param)
{
	local int ResultID;

	EnchantBtn.EnableWindow();
	ParseInt(param, "Result", ResultID);
	if((ResultID == 0))
	{
		return;
	}
	InputSupportItem();
	return;
}

function HandleRemoveSupportItemResult(string param)
{
	supportItemWindow.Clear();
	GotoState('stateReadySupport');
	HandleInstructionTxt();
	return;
}

function HandleEnchantShow(string param)
{
	local ItemID cID;
	local array<ItemInfo> iInfos;

	ParseItemID(param, cID);
	if(!Class'Interface.L2UIInventory'.static.Inst().FindItem(cID, iInfos))
	{
		return;
	}
	requestedItemInfoScroll = iInfos[0];
	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetFocus();
	InputScrollItem();
	return;
}

function Handle_S_EX_ENCHANT_CHALLENGE_POINT_INFO()
{
	local UIPacket._S_EX_ENCHANT_CHALLENGE_POINT_INFO packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_ENCHANT_CHALLENGE_POINT_INFO(packet))
	{
		return;
	}
	vCurrentPointInfo = packet.vCurrentPointInfo;
	return;
}

function Handle_S_EX_RESET_ENCHANT_CHALLENGE_POINT()
{
	local UIPacket._S_EX_RESET_ENCHANT_CHALLENGE_POINT packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_RESET_ENCHANT_CHALLENGE_POINT(packet))
	{
		return;
	}
	if((int(packet.bResult) == 1))
	{
		SelectedSystemSupport = -1;
		GotoState('stateReadySupport');
	}
	return;
}

function Handle_S_EX_SET_ENCHANT_CHALLENGE_POINT()
{
	local UIPacket._S_EX_SET_ENCHANT_CHALLENGE_POINT packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_SET_ENCHANT_CHALLENGE_POINT(packet))
	{
		return;
	}
	EnchantBtn.EnableWindow();
	if((int(packet.bResult) == 0))
	{
		return;
	}
	InputSupportSystem();
	return;
}

function Handle_S_EX_RES_ENCHANT_ITEM_FAIL_REWARD_INFO()
{
	local UIPacket._S_EX_RES_ENCHANT_ITEM_FAIL_REWARD_INFO packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_RES_ENCHANT_ITEM_FAIL_REWARD_INFO(packet))
	{
		return;
	}
	SetFailItems(packet.nEnchantChallengePointGroupId, packet.nEnchantChallengePoint, packet.vRewardItemList);
	return;
}

function Handle_S_EX_CHANGED_ENCHANT_TARGET_ITEM_PROB_LIST()
{
	local UIPacket._S_EX_CHANGED_ENCHANT_TARGET_ITEM_PROB_LIST packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_CHANGED_ENCHANT_TARGET_ITEM_PROB_LIST(packet))
	{
		return;
	}
	SetEnchantProb(packet.vProbList);
	return;
}

function ToggleSupportItemListWnd()
{
	if(supportItemListWnd.IsShowWindow())
	{
		supportItemListWnd.HideWindow();
	}
	else
	{
		supportSystemListWnd.HideWindow();
		supportItemListWnd.ShowWindow();
		SetSupportItemList();
	}
	return;
}

function SetSupportItemList()
{
	if(supportItemListWnd.IsShowWindow())
	{
		Class'Interface.ItemEnchantSubWnd'.static.Inst().SetSupportItems(supportItemWnds);
	}
	return;
}

function ToggleSupportSystemListWndWnd()
{
	if(supportSystemListWnd.IsShowWindow())
	{
		supportSystemListWnd.HideWindow();
	}
	else
	{
		supportItemListWnd.HideWindow();
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemListWnd.supportSystemList2Wnd.SystemActivBtnPoint")).DisableWindow();
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemListWnd.supportSystemList2Wnd.SystemActivBtnTicket")).DisableWindow();
		supportSystemListWnd.ShowWindow();
		supportSystemListWnd.SetFocus();
	}
	return;
}

function HandleClickEnchantEffectItem()
{
	local bool isShow;

	isShow = GetEnchantEffectItemShowOption();
	SetINIBool(m_hOwnerWnd.m_WindowNameWithFullPath, "e", !isShow, "windowsInfo.ini");
	SetEnchantEffectItemTitle();
	SetEnchantEffectItem_Wnd();
	return;
}

function bool GetEnchantEffectItemShowOption()
{
	local int E;

	if(!GetINIBool(m_hOwnerWnd.m_WindowNameWithFullPath, "e", E, "windowsInfo.ini"))
	{
		return true;
	}
	return bool(E);
}

function SetEnchantEffectItemTitle()
{
	local bool isShow;

	isShow = GetEnchantEffectItemShowOption();
	if(isShow)
	{
		GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectBTN_Text")).SetText(GetSystemString(14431));
		GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectBTN_Text")).SetTextColor(Class'Interface.L2UIColor'.static.Inst().White);
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffect_BTN")).SetTexture("L2UI_NewTex.ItemEnchantWnd.Magnifier_Down", "L2UI_NewTex.ItemEnchantWnd.Magnifier_Over", "L2UI_NewTex.ItemEnchantWnd.Magnifier_DF");
	}
	else
	{
		GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectBTN_Text")).SetText(GetSystemString(14432));
		GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectBTN_Text")).SetTextColor(Class'Interface.L2UIColor'.static.Inst().Gray);
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffect_BTN")).SetTexture("L2UI_NewTex.ItemEnchantWnd.Magnifier_DF", "L2UI_NewTex.ItemEnchantWnd.Magnifier_Over", "L2UI_NewTex.ItemEnchantWnd.Magnifier_Down");
	}
	return;
}

function SetEnchantEffectItem_Wnd()
{
	if((GetItemInfoEquipment().Id.ClassID <= 0))
	{
		return;
	}
	if(GetEnchantEffectItemShowOption())
	{
		SetEnchantEffectItem_WndShow();
	}
	else
	{
		SetEnchantEffectItem_WndHide();
	}
	return;
}

function SetEnchantEffectItem_WndHide()
{
	local int locX, locY;

	tObjectEnchantEffectItem_Wnd_Show._Stop();
	tObjectEnchantEffectItem_Wnd_Hide._Reset();
	GetLocalPosition(tObjectEnchantEffectItem_Wnd_Hide.Target, locX, locY);
	tObjectEnchantEffectItem_Wnd_Hide.MoveX = float((-25 + (468 - locX)));
	return;
}

function SetEnchantEffectItem_WndShow()
{
	local int locX, locY;

	supportItemListWnd.HideWindow();
	supportSystemListWnd.HideWindow();
	tObjectEnchantEffectItem_Wnd_Hide._Stop();
	GetLocalPosition(tObjectEnchantEffectItem_Wnd_Hide.Target, locX, locY);
	tObjectEnchantEffectItem_Wnd_Show.MoveX = (25.0000000 - float((locX - 443)));
	tObjectEnchantEffectItem_Wnd_Show._Reset();
	SetEnchantEffectItem();
	return;
}

function SetEnchantEffectItem()
{
	local HtmlHandle htmlInfo;
	local ItemInfo iInfo;

	iInfo = GetItemInfoEquipment();
	htmlInfo = GetHtmlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectItem_Wnd.CurrentEffect_Ctrl00"));
	htmlInfo.Clear();
	htmlInfo.LoadHtmlFromString(GetItemInfoHtml(iInfo, iInfo.Enchanted, true));
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectItem_Wnd.CurrentEffectTitle_Ctrl00")).SetText(("+" $ string(iInfo.Enchanted)));
	switch(byte(GetIteminfoScroll().EtcItemType))
	{
		case 86:
		case 87:
			enchantEffect = (iInfo.Enchanted - 1);
			break;
		default:
			enchantEffect = (iInfo.Enchanted + 1);
			break;
	}
	SetEnchantEffectItemAfter(enchantEffect);
	return;
}

function PrevEnchantEffectItem()
{
	SetEnchantEffectItemAfter(--enchantEffect);
	return;
}

function NextEnchantEffectItem()
{
	SetEnchantEffectItemAfter(++enchantEffect);
	return;
}

function SetEnchantEffectItemAfter(int EnchantedNum)
{
	local HtmlHandle htmlInfoAfter;
	local ItemInfo iInfo;
	local int enchantMax, enchantedBefore;

	iInfo = GetItemInfoEquipment();
	enchantMax = GetEnchantMax();
	if((enchantMax == -1))
	{
		enchantMax = 20;
	}
	else
	{
		enchantMax = (enchantMax + 1);
	}
	EnchantedNum = Min(enchantMax, Max(0, EnchantedNum));
	enchantedBefore = iInfo.Enchanted;
	iInfo.Enchanted = EnchantedNum;
	if((EnchantedNum == enchantMax))
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectItem_Wnd.RightM_Btn")).DisableWindow();
	}
	else
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectItem_Wnd.RightM_Btn")).EnableWindow();
	}
	if((EnchantedNum == 0))
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectItem_Wnd.LeftM_Btn")).DisableWindow();
	}
	else
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectItem_Wnd.LeftM_Btn")).EnableWindow();
	}
	htmlInfoAfter = GetHtmlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectItem_Wnd.CurrentEffect_Ctrl01"));
	htmlInfoAfter.Clear();
	htmlInfoAfter.LoadHtmlFromString(GetItemInfoHtml(iInfo, enchantedBefore));
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectItem_Wnd.CurrentEffectTitle_Ctrl01")).SetText(("+" $ string(iInfo.Enchanted)));
	switch(byte(GetIteminfoScroll().EtcItemType))
	{
		case 86:
		case 87:
			if((((enchantedBefore + GetRandomValue()) <= EnchantedNum) && (EnchantedNum < enchantedBefore)))
			{
				GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectItem_Wnd.CurrentEffectTitle_Ctrl01")).SetTextColor(GetColor(170, 110, 230, 255));
			}
			else
			{
				GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectItem_Wnd.CurrentEffectTitle_Ctrl01")).SetTextColor(Class'Interface.L2UIColor'.static.Inst().Gray);
			}
			break;
		default:
			if((((enchantedBefore + GetRandomValue()) >= EnchantedNum) && (EnchantedNum > enchantedBefore)))
			{
				GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectItem_Wnd.CurrentEffectTitle_Ctrl01")).SetTextColor(GetColor(170, 110, 230, 255));
			}
			else
			{
				GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EnchantEffectItem_Wnd.CurrentEffectTitle_Ctrl01")).SetTextColor(Class'Interface.L2UIColor'.static.Inst().Gray);
			}
			break;
	}
	return;
}

function SaveFailChallangePointInfo(int GroupID, int point)
{
	failChallangePointInfo.gropuID = GroupID;
	failChallangePointInfo.point = point;
	return;
}

function SetFailItems(int GroupID, int point, array<UIPacket._EnchantRewardItem> rewardItemLits)
{
	local int Index, i;
	local ItemInfo iInfo;
	local string Path, CurrentPath;

	SaveFailChallangePointInfo(GroupID, point);
	Path = (m_hOwnerWnd.m_WindowNameWithFullPath $ ".FailprdctItem_wnd.FailprdctItem_wnd0");
	if((point > 0))
	{
		GetWindowHandle((Path $ string(Index))).ShowWindow();
		Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(Class'Interface.ItemEnchantGroupIDWnd'.static._GetClassIDPoint(GroupID)), iInfo);
		CurrentPath = ((Path $ string(Index)) $ ".");
		GetItemWindowHandle((CurrentPath $ "FailItem_ItemWnd")).Clear();
		GetItemWindowHandle((CurrentPath $ "FailItem_ItemWnd")).AddItem(iInfo);
		GetTextBoxHandle((CurrentPath $ "FailItemName_txt")).SetText(iInfo.Name);
		Class'Interface.L2Util'.static.SetEllipsisTextBox(GetTextBoxHandle((CurrentPath $ "FailItemName_txt")));
		GetTextBoxHandle((CurrentPath $ "FailItemNum_txt")).SetText(("x" $ string(point)));
		Index++;
	}
	i = 0;
	while((i < rewardItemLits.Length))
	{
		if(!Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(rewardItemLits[i].nItemClassID), iInfo))
		{
			i++;
			continue;
		}
		GetWindowHandle((Path $ string(Index))).ShowWindow();
		CurrentPath = ((Path $ string(Index)) $ ".");
		GetItemWindowHandle((CurrentPath $ "FailItem_ItemWnd")).Clear();
		GetItemWindowHandle((CurrentPath $ "FailItem_ItemWnd")).AddItem(iInfo);
		GetTextBoxHandle((CurrentPath $ "FailItemName_txt")).SetText(iInfo.Name);
		GetTextBoxHandle((CurrentPath $ "FailItemName_txt")).SetTextColor(Class'Interface.L2UIColor'.static.Inst().White);
		Class'Interface.L2Util'.static.SetEllipsisTextBox(GetTextBoxHandle((CurrentPath $ "FailItemName_txt")));
		GetTextBoxHandle((CurrentPath $ "FailItemNum_txt")).SetTextColor(Class'Interface.L2UIColor'.static.Inst().Gold);
		GetTextBoxHandle((CurrentPath $ "FailItemNum_txt")).SetText(("x" $ string(rewardItemLits[i].nCount)));
		Index++;
		i++;
	}
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".FailprdctItem_wnd")).SetWindowSize(330, ((Index * 46) + 60));
	if((Index == 0))
	{
		GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".FailprdctItem_wnd.Point_txt")).SetText(GetSystemString(27));
	}
	else
	{
		GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".FailprdctItem_wnd.Point_txt")).SetText(GetSystemString(13949));
	}
	i = Index;
	while((GetWindowHandle((Path $ string(i))).m_pTargetWnd != none))
	{
		GetWindowHandle((Path $ string(Index))).HideWindow();
		Index++;
		i++;
	}
	return;
}

function DrawItemInfo GetProbDrawItemInfo(string probStr, int Prob)
{
	if((Prob == 0))
	{
		return addDrawItemText(probStr, getInstanceL2Util().Gray, "", true, true);
	}
	return addDrawItemText(probStr, getInstanceL2Util().Yellow, "", true, true);
}

function SetEnchantProb(array<UIPacket._EnchantProbInfo> enchantProbInfo)
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local string totlaStringProb;

	switch(byte(GetIteminfoScroll().EtcItemType))
	{
		case 86:
		case 87:
			totlaStringProb = "100%";
			break;
		default:
			totlaStringProb = GetProbString(enchantProbInfo[0].nTotalSuccessProbPermyriad);
			break;
	}
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ProbWnd.probTxt")).SetText(totlaStringProb);
	drawListArr[drawListArr.Length] = GetProbDrawItemInfo(((GetSystemString(13939) $ ":") @ totlaStringProb), enchantProbInfo[0].nTotalSuccessProbPermyriad);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = GetProbDrawItemInfo(((GetSystemString(13940) $ ":") @ GetProbString(enchantProbInfo[0].nBaseProbPermyriad)), enchantProbInfo[0].nBaseProbPermyriad);
	drawListArr[drawListArr.Length] = GetProbDrawItemInfo(((GetSystemString(13941) $ ":") @ GetProbString(enchantProbInfo[0].nSupportProbPermyriad)), enchantProbInfo[0].nSupportProbPermyriad);
	drawListArr[drawListArr.Length] = GetProbDrawItemInfo(((GetSystemString(13942) $ ":") @ GetProbString(enchantProbInfo[0].nItemSkillProbPermyriad)), enchantProbInfo[0].nItemSkillProbPermyriad);
	if((getInstanceUIData().GetIsLiveServer() == false))
	{
		drawListArr[drawListArr.Length] = GetProbDrawItemInfo(((GetSystemString(14842) $ ":") @ GetProbString(enchantProbInfo[0].nVariationProbPermyriad)), enchantProbInfo[0].nVariationProbPermyriad);
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	mCustomTooltip.MinimumWidth = 130;
	setCustomToolTipMinimumWidth(mCustomTooltip);
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ProbWnd.probTooltipBtn")).SetTooltipCustomType(mCustomTooltip);
	return;
}

function bool IsGreateSuccessEffect(int targetEnchant)
{
	if((int(enchantScrollData.GreatSuccessEffect) == -1))
	{
		return false;
	}
	return (int(enchantScrollData.GreatSuccessEffect) <= targetEnchant);
}

function bool UseSupportSlot()
{
	if((enchantScrollData.IncBaseMin == -1))
	{
		return false;
	}
	if((enchantScrollData.IncBaseMin > GetItemInfoEquipment().Enchanted))
	{
		return false;
	}
	if((enchantScrollData.IncBaseMax != -1))
	{
		if((GetItemInfoEquipment().Enchanted > enchantScrollData.IncBaseMax))
		{
			return false;
		}
	}
	return true;
}

function bool IsBreakable()
{
	switch(byte(GetIteminfoScroll().EtcItemType))
	{
		case 86:
		case 87:
			return false;
		default:
			return (GetItemInfoEquipment().Enchanted >= GetFailureBase());
	}
}

function int GetFailureBase()
{
	return int(enchantScrollData.FailureBase);
}

function int GetFailureDecrease()
{
	return int(enchantScrollData.FailureDecrease);
}

function bool IsFailureMaintain()
{
	return enchantScrollData.FailureMaintain;
}

function bool IsFailureCrush()
{
	return enchantScrollData.FailureCrush;
}

function int GetRandomValue()
{
	local int i, Min, Max;
	local ItemInfo iInfo;

	iInfo = GetItemInfoEquipment();
	i = 0;
	while((i < enchantScrollData.EnchantRangeDatas.Length))
	{
		Min = enchantScrollData.EnchantRangeDatas[i].RangeMin;
		Max = enchantScrollData.EnchantRangeDatas[i].RangeMax;
		if((Max == -1))
		{
			return enchantScrollData.EnchantRangeDatas[i].RandomValue;
		}
		if(((Min <= iInfo.Enchanted) && (iInfo.Enchanted <= Max)))
		{
			return enchantScrollData.EnchantRangeDatas[i].RandomValue;
		}
		i++;
	}
	return -1;
}

function int GetEnchantMax()
{
	return enchantScrollData.EnchantRangeDatas[(enchantScrollData.EnchantRangeDatas.Length - 1)].RangeMax;
}

function int _GetEnchantMin()
{
	return enchantScrollData.EnchantRangeDatas[0].RangeMin;
}

function AddFailChallangePointInfo()
{
	local ItemInfo iInfo;

	if((failChallangePointInfo.rewardPnt > 0))
	{
		Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(Class'Interface.ItemEnchantGroupIDWnd'.static._GetClassIDPoint(failChallangePointInfo.gropuID)), iInfo);
		iInfo.ItemNum = INT64(failChallangePointInfo.rewardPnt);
		AddFailItemInfoToList(iInfo);
	}
	return;
}

function AddFailItemInfoToList(ItemInfo iInfo)
{
	local RichListCtrlRowData rowData;

	if((iInfo.ItemNum < INT64(1)))
	{
		return;
	}
	if(MakeRecordFailItem(iInfo, rowData))
	{
		GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_Wnd.Fail_Wnd.FailGetItme_RichList")).InsertRecord(rowData);
	}
	return;
}

function CheckEmptyFailItemInfoToList()
{
	local RichListCtrlRowData rowData, emptyRowData;
	local RichListCtrlHandle List;

	List = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_Wnd.Fail_Wnd.FailGetItme_RichList"));
	if((List.GetRecordCount() > 0))
	{
		return;
	}
	rowData.cellDataList.Length = 1;
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetSystemString(14024), Class'Interface.L2Util'.static.Inst().Gray, false, 10);
	List.InsertRecord(emptyRowData);
	List.InsertRecord(emptyRowData);
	List.InsertRecord(rowData);
	return;
}

function bool MakeRecordFailItem(ItemInfo iInfo, out RichListCtrlRowData rowData)
{
	rowData.cellDataList.Length = 1;
	AddRichListCtrlItem(rowData.cellDataList[0].drawitems, iInfo, 32, 32, 7);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetItemNameAll(iInfo), Class'Interface.L2Util'.static.Inst().White, false, 4, 3);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, ("x" $ MakeCostStringINT64(iInfo.ItemNum)), Class'Interface.L2Util'.static.Inst().White, true, 42, 0);
	return true;
}

function SetFailEndTxt(string endTxt)
{
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_Wnd.Fail_Wnd.NextEnchantFail_Text")).SetText(endTxt);
	return;
}

function HandleEnchantResult(string param)
{
	local int IntResult;
	local ItemID ItemID;
	local INT64 Count;
	local ItemInfo ResultItemInfo, failResultItem2;
	local string endTxt;
	local int EnchantValue, enchantedBefore, SecondClassID, SecondCount;
	local ItemInfo SelectItemInfo;

	SelectItemInfo = GetItemInfoEquipment();
	ParseInt(param, "Result", IntResult);
	ParseItemID(param, ItemID);
	ParseINT64(param, "Count", Count);
	ParseInt(param, "EnchantValue", EnchantValue);
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(ItemID, ResultItemInfo);
	ResultItemInfo.Enchanted = EnchantValue;
	ResultItemInfo.ItemNum = Count;
	ResultItemInfo.bShowCount = IsStackableItem(ResultItemInfo.ConsumeType);
	EnchantedItemSlot.Clear();
	GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_Wnd.Fail_Wnd.FailGetItme_RichList")).DeleteAllItem();
	if((SelectItemInfo.Enchanted == 0))
	{
		GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd.PrvEnchantNum_Text")).SetText("0");
	}
	else
	{
		GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd.PrvEnchantNum_Text")).SetText(("+" $ string(SelectItemInfo.Enchanted)));
	}
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd.NextEnchantNum_Text")).SetText(("+" $ string(EnchantValue)));
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd.EnchantResultMsg")).SetText(GetSystemString(3903));
	if((IntResult != 2))
	{
		ResetScrollNum();
		ResetSupportNum();
	}
	switch(IntResult)
	{
		case 0:
			resultState = 'stateCompleteResult';
			enchantedBefore = SelectItemInfo.Enchanted;
			SelectItemInfo.Enchanted = EnchantValue;
			GetHtmlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd.EnchantEffect_Ctrl")).LoadHtmlFromString(GetItemInfoHtml(SelectItemInfo, enchantedBefore));
			EnchantedItemSlot.AddItem(SelectItemInfo);
			GetHtmlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd.ItemName_Ctrl")).LoadHtmlFromString(htmlSetHtmlStart(GetCenterTable(GetNameHtmlFull(SelectItemInfo), 360, 0)));
			break;
		case 1:
			resultState = 'stateCompleteResultfail';
			if(IsAGScrollType())
			{
				endTxt = GetSystemMessage(4511);
			}
			else
			{
				endTxt = MakeFullSystemMsg(GetSystemMessage(64), GetItemInfoEquipment().Name);
			}
			SetFailEndTxt(endTxt);
			AddFailItemInfoToList(ResultItemInfo);
			AddFailChallangePointInfo();
			break;
		case 2:
			isGreateSuccess = false;
			resultState = 'stateReadyScroll';
			break;
		case 3:
			break;
		case 4:
			resultState = 'stateCompleteResultfail';
			if(IsAGScrollType())
			{
				endTxt = GetSystemMessage(4511);
			}
			else
			{
				endTxt = MakeFullSystemMsg(GetSystemMessage(64), SelectItemInfo.Name, "");
			}
			SetFailEndTxt(endTxt);
			break;
		case 5:
			break;
		case 6:
			resultState = 'stateCompleteResultfail';
			endTxt = MakeFullSystemMsg(GetSystemMessage(2343), (("+" $ string(EnchantValue)) @ SelectItemInfo.Name), "1");
			SetFailEndTxt(endTxt);
			SelectItemInfo.Enchanted = EnchantValue;
			AddFailItemInfoToList(SelectItemInfo);
			break;
		case 7:
			resultState = 'stateCompleteResult';
			endTxt = GetSystemMessage(13137);
			GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd.EnchantResultMsg")).SetText(endTxt);
			enchantedBefore = SelectItemInfo.Enchanted;
			SelectItemInfo.Enchanted = EnchantValue;
			EnchantedItemSlot.AddItem(SelectItemInfo);
			GetHtmlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd.ItemName_Ctrl")).LoadHtmlFromString(htmlSetHtmlStart(GetCenterTable(GetNameHtmlFull(SelectItemInfo), 360, 0)));
			GetHtmlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd.EnchantEffect_Ctrl")).LoadHtmlFromString(GetItemInfoHtml(SelectItemInfo, enchantedBefore));
			break;
		case 8:
			if((isAutoEnchanting || isAutoEnchantingStop))
			{
				if((GetIteminfoScroll().ItemNum > INT64(0)))
				{
					if(isGreateSuccess)
					{
						API_C_EX_REQ_VIEW_ENCHANT_RESULT();
					}
					API_RequestExAddEnchantScrollItem(requestedItemInfoScroll);
					return;
				}
				isAutoEnchantingStop = false;
				EnchantBtnAuto.EnableWindow();
			}
			resultState = 'stateCompleteResultfail';
			if(IsAGScrollType())
			{
				endTxt = GetSystemMessage(4509);
			}
			else
			{
				endTxt = GetSystemMessage(6004);
			}
			SetFailEndTxt(endTxt);
			AddFailItemInfoToList(SelectItemInfo);
			break;
		case 9:
			resultState = 'stateCompleteResultfail';
			SelectItemInfo.Enchanted = EnchantValue;
			if(IsAGScrollType())
			{
				endTxt = GetSystemMessage(4511);
			}
			else
			{
				endTxt = MakeFullSystemMsg(GetSystemMessage(2343), (("+" $ string(EnchantValue)) $ SelectItemInfo.Name), "1");
			}
			SetFailEndTxt(endTxt);
			AddFailItemInfoToList(SelectItemInfo);
			break;
		case 10:
			resultState = 'stateCompleteResultfail';
			if(IsAGScrollType())
			{
				endTxt = GetSystemMessage(4512);
			}
			else
			{
				endTxt = MakeFullSystemMsg(GetSystemMessage(2343), SelectItemInfo.Name, "1");
			}
			if((isAutoEnchanting || (isAutoEnchantingStop && (SelectItemInfo.Enchanted == EnchantValue))))
			{
				if((GetIteminfoScroll().ItemNum > INT64(0)))
				{
					if(isGreateSuccess)
					{
						API_C_EX_REQ_VIEW_ENCHANT_RESULT();
					}
					API_RequestExAddEnchantScrollItem(requestedItemInfoScroll);
					return;
				}
				isAutoEnchantingStop = false;
				EnchantBtnAuto.EnableWindow();
			}
			SetFailEndTxt(endTxt);
			SelectItemInfo.Enchanted = EnchantValue;
			AddFailItemInfoToList(SelectItemInfo);
			break;
		default:
			break;
	}
	if(((isGreateSuccess && !isAutoEnchanting) && !isAutoEnchantingStop))
	{
		GotoState('stateCompleteBlind');
	}
	else
	{
		if(isGreateSuccess)
		{
			API_C_EX_REQ_VIEW_ENCHANT_RESULT();
		}
		GotoState(resultState);
	}
	ParseInt(param, "SecondClassID", SecondClassID);
	ParseInt(param, "SecondCount", SecondCount);
	if(((SecondClassID > 0) && (SecondCount > 0)))
	{
		failResultItem2 = GetItemInfoByClassID(SecondClassID);
		failResultItem2.ItemNum = INT64(SecondCount);
		AddFailItemInfoToList(failResultItem2);
	}
	resetBtn.EnableWindow();
	return;
}

function GetSlotAniPlay(string Path)
{
	local AnimTextureHandle aniTex;

	aniTex = GetAnimTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path) $ ".activeAni"));
	aniTex.Stop();
	aniTex.ShowWindow();
	aniTex.SetLoopCount(9999999);
	aniTex.Play();
	return;
}

function SetSlotInputAniPlay(string Path)
{
	local AnimTextureHandle aniTex;

	aniTex = GetAnimTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path) $ ".inputAni"));
	aniTex.Stop();
	aniTex.ShowWindow();
	aniTex.SetLoopCount(1);
	aniTex.Play();
	return;
}

function GetSlotAniStop(string Path)
{
	local AnimTextureHandle aniTex;

	aniTex = GetAnimTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path) $ ".activeAni"));
	aniTex.HideWindow();
	aniTex = GetAnimTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path) $ ".inputAni"));
	aniTex.HideWindow();
	return;
}

function GetSupportActiveAniPlay(string Name)
{
	local AnimTextureHandle aniTex;

	aniTex = GetAnimTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Name) $ "activeAni"));
	aniTex.Stop();
	aniTex.ShowWindow();
	aniTex.SetLoopCount(9999999);
	aniTex.Play();
	return;
}

function GetSupportActiveAniStop(string Name)
{
	local AnimTextureHandle aniTex;

	aniTex = GetAnimTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Name) $ "activeAni"));
	aniTex.HideWindow();
	return;
}

function ChangeEquipmentAni()
{
	local AnimTextureHandle aniTex;

	aniTex = GetAnimTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".equipmentItemWnd.activeAni"));
	if(IsBreakable())
	{
		aniTex.SetTexture("L2UI.UISlotEffect.itemsquare_0000");
	}
	else
	{
		aniTex.SetTexture("L2UI.UISlotEffect.itemsquareSafe_0000");
	}
	aniTex.Stop();
	aniTex.ShowWindow();
	aniTex.SetLoopCount(9999999);
	aniTex.Play();
	return;
}

function API_RequestExCancelEnchantItem()
{
	Class'NWindow.EnchantAPI'.static.RequestExCancelEnchantItem();
	return;
}

function API_RequestExAddEnchantScrollItem(ItemInfo iInfo)
{
	requestedItemInfoScroll = iInfo;
	Class'NWindow.EnchantAPI'.static.RequestExAddEnchantScrollItem(GetItemInfoEquipment().Id, iInfo.Id);
	return;
}

function API_RequestExTryToPutEnchantTargetItem(ItemInfo iInfo)
{
	requestedItemInfoEquipment = iInfo;
	Class'NWindow.EnchantAPI'.static.RequestExTryToPutEnchantTargetItem(iInfo.Id);
	return;
}

function API_RequestExTryToPutEnchantSupportItem(ItemInfo iInfo, optional bool _bWaitTargetItem)
{
	bWaitTargetItem = _bWaitTargetItem;
	requestedItemInfoSupport = iInfo;
	if(_bWaitTargetItem)
	{
		return;
	}
	if(!supportItemWindow.IsShowWindow())
	{
		AddSystemMessage(6094);
		return;
	}
	EnchantBtn.DisableWindow();
	API_C_EX_RESET_ENCHANT_CHALLENGE_POINT();
	Class'NWindow.EnchantAPI'.static.RequestExTryToPutEnchantSupportItem(iInfo.Id, GetItemInfoEquipment().Id);
	return;
}

function API_RequestExRemoveEnchantSupportItem()
{
	if((supportItemWindow.GetItemNum() == 0))
	{
		return;
	}
	EnchantBtn.DisableWindow();
	Class'NWindow.EnchantAPI'.static.RequestExRemoveEnchantSupportItem();
	return;
}

function API_RequestEnchantItem(bool enc)
{
	Class'NWindow.EnchantAPI'.static.RequestEnchantItem(GetItemInfoEquipment().Id, enc);
	if((!bUsedTicket && (SelectedSystemSupport > -1)))
	{
		failChallangePointInfo.rewardPnt = Min(failChallangePointInfo.point, ((groupIDWndScr._GetMaxPoint() - GetCurrentPoint()) + GetSelectedFee()));
	}
	else
	{
		failChallangePointInfo.rewardPnt = Min(failChallangePointInfo.point, (groupIDWndScr._GetMaxPoint() - GetCurrentPoint()));
	}
	if(enc)
	{
		groupIDWndScr._SetDisable();
	}
	return;
}

function bool API_GetEnchantScrollSetData(ItemInfo iInfo, ItemInfo iInfo2)
{
	return Class'NWindow.UIDATA_ITEM'.static.GetEnchantScrollSetData(iInfo.Id.ClassID, iInfo2.Id.ClassID, enchantScrollData);
}

function API_C_EX_SET_ENCHANT_CHALLENGE_POINT(bool useTicket)
{
	local array<byte> stream;
	local UIPacket._C_EX_SET_ENCHANT_CHALLENGE_POINT packet;
	local RichListCtrlRowData Record;

	bUsedTicket = useTicket;
	if(bUsedTicket)
	{
		packet.bUseTicket = 1;
	}
	else
	{
		packet.bUseTicket = 0;
	}
	SelectedSystemSupport = supportSystemList.GetSelectedIndex();
	supportSystemList.GetSelectedRec(Record);
	packet.nUseType = int(Record.nReserved1);
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_SET_ENCHANT_CHALLENGE_POINT(stream, packet))
	{
		return;
	}
	API_RequestExRemoveEnchantSupportItem();
	Class'Interface.UIPacket'.static.RequestUIPacket(762, stream);
	return;
}

function API_C_EX_RESET_ENCHANT_CHALLENGE_POINT()
{
	local array<byte> stream;
	local UIPacket._C_EX_RESET_ENCHANT_CHALLENGE_POINT packet;

	if(!Class'Interface.UIPacket'.static.Encode_C_EX_RESET_ENCHANT_CHALLENGE_POINT(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(763, stream);
	return;
}

function int API_GetChallengePointGroupID()
{
	return int(Class'NWindow.UIDATA_ITEM'.static.GetChallengePointGroupID(GetItemInfoEquipment().Id.ClassID));
}

function API_GetEnchantChallengePointSettingData(out EnchantChallengePointSettingUIData o_data)
{
	Class'NWindow.UIDATA_ITEM'.static.GetEnchantChallengePointSettingData(o_data);
	return;
}

function bool API_GetEnchantChallengePointData(int GroupID, out EnchantChallengePointUIData o_data)
{
	return Class'NWindow.UIDATA_ITEM'.static.GetEnchantChallengePointData(byte(GroupID), o_data);
}

function API_GetEnchantValidateValue(int Enchanted, out EnchantValidateUIData oData)
{
	Class'NWindow.UIDATA_ITEM'.static.GetEnchantValidateValue(GetItemInfoEquipment().Id.ClassID, Enchanted, oData);
	return;
}

function API_C_EX_REQ_ENCHANT_FAIL_REWARD_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_REQ_ENCHANT_FAIL_REWARD_INFO packet;

	packet.nItemServerId = GetItemInfoEquipment().Id.ServerID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_REQ_ENCHANT_FAIL_REWARD_INFO(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(761, stream);
	return;
}

function API_C_EX_REQ_VIEW_ENCHANT_RESULT()
{
	local array<byte> stream;
	local UIPacket._C_EX_REQ_VIEW_ENCHANT_RESULT packet;

	if(!Class'Interface.UIPacket'.static.Encode_C_EX_REQ_VIEW_ENCHANT_RESULT(stream, packet))
	{
		return;
	}
	NoticeWnd(GetScript("NoticeWnd"))._CreateCollectionButtonBlind();
	Class'Interface.UIPacket'.static.RequestUIPacket(764, stream);
	return;
}

function CheckEnchantNEncht()
{
	if(IsBreakable())
	{
		HandleShowDialog();
		resetBtn.DisableWindow();
		EnchantBtn.DisableWindow();
	}
	else
	{
		GotoState('stateEnchant');
	}
	return;
}

function StartAutoEnchant()
{
	if(isAutoEnchantingStop)
	{
		GotoState(prevState);
		return;
	}
	EnchantEffectViewport.SpawnEffect("LineageEffect2.ui_openbox");
	timerObject._Reset();
	EnchantBtnAuto.EnableWindow();
	return;
}

function RequestEnchant()
{
	isGreateSuccess = IsGreateSuccessEffect((GetItemInfoEquipment().Enchanted + 1));
	API_RequestEnchantItem(isGreateSuccess);
	return;
}

function SetSupportSystemList()
{
	local int i;
	local RichListCtrlRowData Record;

	supportSystemList.DeleteAllItem();
	i = 0;
	while((i < 6))
	{
		if(MakeRecordSupportSystem(i, Record))
		{
			supportSystemList.InsertRecord(Record);
		}
		i++;
	}
	return;
}

function int GetIndexPointInfo(int pointGrouID)
{
	local int i;

	i = 0;
	while((i < vCurrentPointInfo.Length))
	{
		if((vCurrentPointInfo[i].nPointGroupId == pointGrouID))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function bool ChkEnchantContinue()
{
	local ItemInfo ScrollItemInfo, equipmentInfo, supportItem;

	EnchantBtn.SetNameText(GetSystemString(13935));
	EnchantBtnAuto.SetNameText(GetSystemString(14237));
	if(!RefreshScroll(ScrollItemInfo))
	{
		API_RequestExCancelEnchantItem();
		GotoState('stateReadyScroll');
		return false;
	}
	if((!RefreshEquipment(equipmentInfo) || ((GetEnchantMax() != -1) && (GetEnchantMax() <= equipmentInfo.Enchanted))))
	{
		if((supportItemWindow.GetItemNum() > 0))
		{
			API_RequestExRemoveEnchantSupportItem();
		}
		if((SelectedSystemSupport > -1))
		{
			API_C_EX_RESET_ENCHANT_CHALLENGE_POINT();
		}
		GotoState('stateReadyScroll');
		API_RequestExAddEnchantScrollItem(ScrollItemInfo);
		return false;
	}
	if(!Class'NWindow.UIDATA_INVENTORY'.static.FindItem(equipmentInfo.Id.ServerID, equipmentInfo))
	{
		return false;
	}
	API_RequestExTryToPutEnchantTargetItem(equipmentInfo);
	if((supportItemWindow.GetItemNum() > 0))
	{
		if(!RefreshSupportStone(supportItem))
		{
			API_RequestExRemoveEnchantSupportItem();
		}
		else
		{
			API_RequestExTryToPutEnchantSupportItem(supportItem, true);
		}
	}
	else if((SelectedSystemSupport > -1))
	{
		API_C_EX_RESET_ENCHANT_CHALLENGE_POINT();
	}
	return true;
}

function bool RefreshEquipment(out ItemInfo equipmentiInfo)
{
	local ItemInfo iInfo;

	equipmentiInfo = GetItemInfoEquipment();
	equipmentItemWindow.Clear();
	if(!Class'NWindow.UIDATA_INVENTORY'.static.FindItem(equipmentiInfo.Id.ServerID, iInfo))
	{
		return false;
	}
	equipmentItemWindow.AddItem(iInfo);
	return true;
}

function bool RefreshScroll(out ItemInfo scrolliInfo)
{
	local ItemInfo iInfo;

	scrolliInfo = GetIteminfoScroll();
	scrollItemWindow.Clear();
	if(!Class'NWindow.UIDATA_INVENTORY'.static.FindItem(scrolliInfo.Id.ServerID, iInfo))
	{
		return false;
	}
	iInfo.bShowCount = true;
	scrolliInfo = iInfo;
	scrollItemWindow.AddItem(iInfo);
	return true;
}

function bool RefreshSupportStone(out ItemInfo supportlliInfo)
{
	local ItemInfo iInfo;

	supportlliInfo = GetItemInfoSupport();
	supportItemWindow.Clear();
	if(!Class'NWindow.UIDATA_INVENTORY'.static.FindItem(supportlliInfo.Id.ServerID, iInfo))
	{
		return false;
	}
	iInfo.bShowCount = true;
	supportItemWindow.AddItem(iInfo);
	return true;
}

function ResetScrollNum()
{
	requestedItemInfoScroll.ItemNum = (requestedItemInfoScroll.ItemNum - INT64(1));
	scrollItemNum.SetText(((GetSystemString(5027) @ ":") @ MakeCostStringINT64(requestedItemInfoScroll.ItemNum)));
	scrollItemWindow.SetItem(0, requestedItemInfoScroll);
	return;
}

function ResetSupportNum()
{
	requestedItemInfoSupport.ItemNum = (requestedItemInfoSupport.ItemNum - INT64(1));
	supportItemWindow.SetItem(0, requestedItemInfoSupport);
	return;
}

function ItemInfo GetIteminfoScroll()
{
	local ItemInfo iInfo;

	scrollItemWindow.GetItem(0, iInfo);
	return iInfo;
}

function ItemInfo GetItemInfoEquipment()
{
	local ItemInfo iInfo;

	equipmentItemWindow.GetItem(0, iInfo);
	return iInfo;
}

function ItemInfo GetItemInfoSupport()
{
	local ItemInfo iInfo;

	supportItemWindow.GetItem(0, iInfo);
	return iInfo;
}

function SwapMultiEnchantWnd()
{
	getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "ItemMultiEnchantWnd");
	GetWindowHandle("ItemMultiEnchantWnd").ShowWindow();
	GetWindowHandle("ItemMultiEnchantWnd").SetFocus();
	Class'Interface.ItemMultiEnchantWnd'.static.Inst()._HandleOnDrop(GetIteminfoScroll());
	m_hOwnerWnd.HideWindow();
	return;
}

function string GetEnchantValueResultHtm(int enchantBefore, int enchantAfter)
{
	local int i;
	local EnchantValidateUIData oData, oDataAfter;
	local string colorString, tableHtmAfter, tableHtmTrAfter;

	API_GetEnchantValidateValue(enchantBefore, oData);
	API_GetEnchantValidateValue(enchantAfter, oDataAfter);
	tableHtmAfter = "";
	i = 0;
	while((i < (16 - 1)))
	{
		if((oDataAfter.EnchantValue[i] > 0.0000000))
		{
			if((oDataAfter.EnchantValue[i] > oData.EnchantValue[i]))
			{
				colorString = "c8ffc8";
			}
			else
			{
				colorString = "c8c8c8";
			}
			tableHtmAfter = HtmlAddTableTD(htmlAddText(GetEnchantEffectName(ValidateEnum(i)), "GameDefault", "c8c8c8"), "left", "center", 200, 0);
			tableHtmAfter = (tableHtmAfter $ HtmlAddTableTD(htmlAddText(string(int(oDataAfter.EnchantValue[i])), "GameDefault", colorString), "right", "center", 100, 0));
			tableHtmTrAfter = (tableHtmTrAfter $ HtmlSetTableTR(tableHtmAfter));
		}
		i++;
	}
	return tableHtmTrAfter;
}

function string GetProbString(int probPermriad)
{
	return getInstanceL2Util().MakeDecimalPointString(string(probPermriad), 2, true, true);
}

function string GetEnchantEffectHtmlString(UIEventManager.ValidateEnum Type, ItemInfo iInfo, EnchantValidateUIData oData)
{
	local int Value;
	local string htm;

	Value = GetItemInfoValueEnchantType(Type, iInfo);
	htm = htmlAddText((GetEnchantEffectName(Type) $ " : "), "GameDefault", "ffffff");
	htm = (htm $ htmlAddText(string(int((float(Value) + oData.EnchantValue[int(Type)]))), "GameDefault", "EBCD00"));
	if((oData.EnchantValue[int(Type)] > 0.0000000))
	{
		htm = (htm $ htmlAddText((" (" $ string(Value)), "GameDefault", getColorHexString(GetColor(176, 155, 121, 255))));
		htm = (htm $ htmlAddText((" +" $ string(int(oData.EnchantValue[int(Type)]))), "GameDefault", getColorHexString(GetColor(238, 170, 34, 255))));
		htm = (htm $ htmlAddText(")", "GameDefault", getColorHexString(GetColor(176, 155, 121, 255))));
	}
	htm = (htm $ HtmlAddTableTD(htm, "left", "center", 310, 20));
	HtmlSetTableTR(htm);
	return htm;
}

function int GetItemInfoValueEnchantType(UIEventManager.ValidateEnum Type, ItemInfo iInfo)
{
	switch(Type)
	{
		case PDEFEND:
			return int(iInfo.pDefense);
		case MDEFEND:
			return int(iInfo.mDefense);
		case pAttack:
			return int(iInfo.pAttack);
		case mAttack:
			return int(iInfo.mAttack);
		case pAttackSpeed:
			return int(iInfo.pAttackSpeed);
		case mAttackSpeed:
			return int(iInfo.mAttackSpeed);
		case PSKILLSPEED:
			return 9999;
		case PHIT:
			return int(iInfo.pHitRate);
		case MHIT:
			return int(iInfo.mHitRate);
		case PCRITICAL:
			return int(iInfo.pCriRate);
		case MCRITICAL:
			return int(iInfo.mCriRate);
		case Speed:
			return int(iInfo.MoveSpeed);
		case ShieldDefense:
			return int(iInfo.ShieldDefense);
		case ShieldDefenseRate:
			return int(iInfo.ShieldDefenseRate);
		case pAvoid:
			return int(iInfo.pAvoid);
		case mAvoid:
			return int(iInfo.mAvoid);
		default:
			return 0;
	}
}

function string GetEnchantEffectName(UIEventManager.ValidateEnum Type)
{
	switch(Type)
	{
		case PDEFEND:
			return GetSystemString(95);
		case MDEFEND:
			return GetSystemString(99);
		case pAttack:
			return GetSystemString(94);
		case mAttack:
			return GetSystemString(98);
		case pAttackSpeed:
			return GetSystemString(13966);
		case mAttackSpeed:
			return GetSystemString(112);
		case PSKILLSPEED:
			return GetSystemString(13968);
		case PHIT:
			return GetSystemString(96);
		case MHIT:
			return GetSystemString(2363);
		case PCRITICAL:
			return GetSystemString(2362);
		case MCRITICAL:
			return GetSystemString(2365);
		case Speed:
			return GetSystemString(432);
		case ShieldDefense:
			return GetSystemString(13206);
		case ShieldDefenseRate:
			return GetSystemString(317);
		case pAvoid:
			return GetSystemString(2361);
		case mAvoid:
			return GetSystemString(2364);
		default:
			return "";
	}
}

function string AddEnchantEffectDescTooltipHtml(ItemInfo item)
{
	local int i;
	local array<string> descriptions;
	local int nFontLevel;
	local string HTML, colorString;

	if(Class'NWindow.UIDATA_ITEM'.static.GetEnchantedItemSkillDesc(item.Id.ClassID, item.Enchanted, descriptions, nFontLevel))
	{
		colorString = GetColorEnchentEffectDescFontLevel(nFontLevel);
		HTML = htmlAddText(GetSystemString(2214), "GameDefault", "B09B79");
		HTML = HtmlAddTableTD(HTML, "left", "center", 200, 0);
		HtmlSetTableTR(HTML);
		HTML = ("<tr><td></td></tr>" $ HTML);
		i = 0;
		while((i < descriptions.Length))
		{
			HTML = (HTML $ Desc2HtmlTR(descriptions[i], colorString));
			i++;
		}
	}
	return HTML;
}

function string GetColorEnchentEffectDescFontLevel(int nFontLevel)
{
	return Class'Interface.L2UIColor'.static.Inst()._Color2ZeroX(Class'Interface.L2UIColor'.static.Inst().Gray);
	switch(nFontLevel)
	{
		case 1:
			return "ffe57f";
		case 2:
			return "6778ff";
		case 3:
			return "cb77ff";
		case 4:
			return "dc00fe";
		default:
			return "FF0000";
	}
}

function string GetItemInfoHtml(ItemInfo iInfo, optional int enchantedCompare, optional bool bBeforeInfo)
{
	local int i;
	local string namehtml, tableHtmTr, ehcnatEffectHtmlString, agaString;
	local EnchantValidateUIData oData, oDataCompare;

	API_GetEnchantValidateValue(iInfo.Enchanted, oData);
	API_GetEnchantValidateValue((iInfo.Enchanted + 1), oDataCompare);
	i = 0;
	while((i < (16 - 1)))
	{
		if(((oData.EnchantValue[i] == 0.0000000) && (oDataCompare.EnchantValue[i] == 0.0000000)))
		{
			i++;
			continue;
		}
		ehcnatEffectHtmlString = GetEnchantEffectHtmlString(ValidateEnum(i), iInfo, oData);
		tableHtmTr = (tableHtmTr $ ehcnatEffectHtmlString);
		i++;
	}
	tableHtmTr = (tableHtmTr $ AddEnchantEffectDescTooltipHtml(iInfo));
	if(((iInfo.ItemType == 2) && (iInfo.SlotBitType == (INT64(16) + INT64(32)))))
	{
		agaString = AgathionSkillInfoToHtml(iInfo);
		if((agaString != ""))
		{
			tableHtmTr = ((agaString $ "<tr></tr>") $ tableHtmTr);
			super.ReplaceText(agaString, "&lt;", "<");
			super.ReplaceText(agaString, "&gt;", ">");
		}
	}
	htmlSetTable(tableHtmTr, 0, 310, 0, "", 0, 5);
	if(((namehtml != "") && (tableHtmTr != "")))
	{
		namehtml = (namehtml $ htmlAddImg("L2UI_EPIC.ClanWnd.ClanWnd_ShadowDivider2", 310, 8));
	}
	return htmlSetHtmlStart((namehtml $ tableHtmTr));
}

function string AgathionSkillInfoToHtml(ItemInfo Info)
{
	local array<SkillInfo> mainSkillList, subSkillList;
	local int i;
	local Color titleColor, DescColor;
	local string HTML, titleHtm;

	GetAgathionMainSkillList(Info.Id.ClassID, Info.Enchanted, mainSkillList);
	GetAgathionSubSkillList(Info.Id.ClassID, Info.Enchanted, subSkillList);
	if((mainSkillList.Length > 0))
	{
		titleColor = Class'Interface.L2UIColor'.static.Inst().Red3;
		DescColor = Class'Interface.L2UIColor'.static.Inst().ColorGray;
		titleHtm = htmlAddText(GetSystemString(3640), "GameDefault", getColorHexString(titleColor));
		HtmlSetTableTR(titleHtm);
		HTML = (HTML $ titleHtm);
		i = 0;
		while((i < mainSkillList.Length))
		{
			HTML = (HTML $ Desc2HtmlTR(mainSkillList[i].SkillDesc, getColorHexString(DescColor)));
			i++;
		}
	}
	if((subSkillList.Length > 0))
	{
		titleColor = Class'Interface.L2UIColor'.static.Inst().Red3;
		DescColor = Class'Interface.L2UIColor'.static.Inst().ColorGray;
		titleHtm = htmlAddText(GetSystemString(3641), "GameDefault", getColorHexString(titleColor));
		titleHtm = HtmlAddTableTD(titleHtm, "left", "center", 200, 0);
		HtmlSetTableTR(titleHtm);
		HTML = (HTML $ titleHtm);
		i = 0;
		while((i < subSkillList.Length))
		{
			HTML = (HTML $ Desc2HtmlTR(subSkillList[i].SkillDesc, getColorHexString(DescColor)));
			i++;
		}
	}
	return HTML;
}

function string Desc2HtmlTR(string Desc, string colorString)
{
	local int i;
	local array<string> descriptArray;
	local string HTML;

	Desc = Substitute(Desc, "<", "&lt;", false);
	Desc = Substitute(Desc, ">", "&gt;", false);
	Desc = Substitute(Desc, "%%", "%", false);
	Desc = Substitute(Desc, "\\n\\n", "^@@^", false);
	Desc = Substitute(Desc, "\\n", "^", false);
	Split(Desc, "^", descriptArray);
	i = 0;
	while((i < descriptArray.Length))
	{
		if((descriptArray[i] == "@@"))
		{
			HTML = (HTML $ "<tr><td></td></tr>");
			i++;
			continue;
		}
		Desc = htmlAddText((" " $ descriptArray[i]), "GameDefault", colorString);
		Desc = HtmlAddTableTD(Desc, "left", "center", 310, 0, "", true);
		HTML = (HTML $ HtmlSetTableTR(Desc));
		i++;
	}
	return HTML;
}

function string GetSystemEnchantEffectName()
{
	local RichListCtrlRowData Record;

	if((SelectedSystemSupport == -1))
	{
		return "";
	}
	supportSystemList.GetRec(SelectedSystemSupport, Record);
	return Record.cellDataList[0].drawitems[0].strInfo.strData;
}

function int GetSelectedFee()
{
	local RichListCtrlRowData Record;

	supportSystemList.GetRec(SelectedSystemSupport, Record);
	return Record.cellDataList[3].nReserved1;
}

function int GetCurrentTicket(int pointUseType)
{
	local int pointIndex;

	pointIndex = GetCurrentPointInfoIndex();
	if((pointIndex == -1))
	{
		return 0;
	}
	switch(pointUseType)
	{
		case 0:
			return vCurrentPointInfo[pointIndex].nTicketPointOpt1;
		case 1:
			return vCurrentPointInfo[pointIndex].nTicketPointOpt2;
		case 2:
			return vCurrentPointInfo[pointIndex].nTicketPointOpt3;
		case 3:
			return vCurrentPointInfo[pointIndex].nTicketPointOpt4;
		case 4:
			return vCurrentPointInfo[pointIndex].nTicketPointOpt5;
		case 5:
			return vCurrentPointInfo[pointIndex].nTicketPointOpt6;
		default:
			return 0;
	}
}

function int GetCurrentPoint()
{
	local int pointIndex;

	pointIndex = GetCurrentPointInfoIndex();
	if((pointIndex != -1))
	{
		return vCurrentPointInfo[pointIndex].nChallengePoint;
	}
	return 0;
}

function int GetCurrentPointInfoIndex()
{
	local int GroupID, i;

	GroupID = API_GetChallengePointGroupID();
	i = 0;
	while((i < vCurrentPointInfo.Length))
	{
		if((vCurrentPointInfo[i].nPointGroupId == GroupID))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function InputScrollItem()
{
	local ItemInfo emptyItem;

	scrollItemWindow.Clear();
	requestedItemInfoScroll.bShowCount = true;
	scrollItemWindow.AddItem(requestedItemInfoScroll);
	API_GetEnchantScrollSetData(requestedItemInfoScroll, emptyItem);
	if((isAutoEnchanting || isAutoEnchantingStop))
	{
		API_RequestExTryToPutEnchantTargetItem(requestedItemInfoEquipment);
		return;
	}
	SetSlotInputAniPlay("scrollItemWnd");
	supportItemListWnd.HideWindow();
	supportSystemListWnd.HideWindow();
	API_RequestExRemoveEnchantSupportItem();
	GotoState('stateReadyEquipment');
	Class'Interface.ItemEnchantSubWnd'.static.Inst().refresh();
	PlaySound("Itemsound3.ui_enchant_slot");
	return;
}

function CheckSupports()
{
	local EnchantChallengePointUIData UIData;

	if(UseSupportSlot())
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportItemWnd")).ShowWindow();
	}
	else
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportItemWnd")).HideWindow();
	}
	if(((((((API_GetChallengePointGroupID() > 0) && API_GetEnchantChallengePointData(API_GetChallengePointGroupID(), UIData)) && (GetFailureDecrease() == 0)) && !IsFailureMaintain()) && IsFailureCrush()) && (GetRandomValue() == 1)))
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemWnd")).ShowWindow();
	}
	else
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemWnd")).HideWindow();
	}
	return;
}

function InputEquipmentItem()
{
	equipmentItemWindow.Clear();
	equipmentItemWindow.AddItem(requestedItemInfoEquipment);
	API_GetEnchantScrollSetData(requestedItemInfoScroll, requestedItemInfoEquipment);
	if((isAutoEnchanting || isAutoEnchantingStop))
	{
		StartAutoEnchant();
		return;
	}
	else if(CanUseAutoMode())
	{
		SetAutoMode();
	}
	else
	{
		SetNormalMode();
	}
	SetSlotInputAniPlay("equipmentItemWnd");
	supportItemListWnd.HideWindow();
	supportSystemListWnd.HideWindow();
	API_RequestExRemoveEnchantSupportItem();
	CheckSupports();
	GotoState('stateReadySupport');
	SetTitleByItemType();
	HandleInstructionTxt();
	Class'Interface.ItemEnchantSubWnd'.static.Inst().refresh();
	PlaySound("Itemsound3.ui_enchant_slot");
	SetSupportSystemList();
	API_C_EX_REQ_ENCHANT_FAIL_REWARD_INFO();
	groupIDWndScr._SetCurrentGroupID(API_GetChallengePointGroupID());
	ChangeEquipmentAni();
	CheckWarningTxt();
	SetEnchantEffectItem();
	return;
}

function InputSupportItem()
{
	supportItemWindow.Clear();
	requestedItemInfoSupport.bShowCount = true;
	supportItemWindow.AddItem(requestedItemInfoSupport);
	SetSlotInputAniPlay("supportItemWnd");
	supportItemListWnd.HideWindow();
	supportSystemListWnd.HideWindow();
	PlaySound("Itemsound3.ui_enchant_slot");
	GotoState('stateReadySupportstone');
	HandleInstructionTxt();
	return;
}

function InputSupportSystem()
{
	supportItemWindow.Clear();
	SetSlotInputAniPlay("supportSystemWnd");
	supportItemListWnd.HideWindow();
	supportSystemListWnd.HideWindow();
	PlaySound("Itemsound3.ui_enchant_slot");
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemWnd.supportSystemSelectedWnd.EnchantEffect_Text")).SetText(GetSystemEnchantEffectName());
	SetSupportSystemList();
	GotoState('stateReadySupportsystem');
	HandleInstructionTxt();
	CheckWarningTxt();
	return;
}

function string GetUseConditionString(int Min, int Max)
{
	local string minString, maxString;

	if((Min == -1))
	{
		return GetSystemString(869);
	}
	if((Min > 0))
	{
		minString = (("+" $ string(Min)) $ GetSystemString(859));
	}
	if((Max != -1))
	{
		maxString = (("+" $ string(Max)) $ GetSystemString(13266));
	}
	if(((minString == "") && (maxString == "")))
	{
		return "-";
	}
	if(((minString != "") && (maxString != "")))
	{
		return ((minString $ ",") @ maxString);
	}
	else if((minString == ""))
	{
		return maxString;
	}
	else if((maxString == ""))
	{
		return minString;
	}
}

function bool GetUseCondition(int Min, int Max)
{
	if((Min == -1))
	{
		return false;
	}
	if((Max == -1))
	{
		Max = 999999;
	}
	return ((Min <= GetItemInfoEquipment().Enchanted) && (GetItemInfoEquipment().Enchanted <= Max));
}

function bool MakeRecordSupportSystem(int Index, out RichListCtrlRowData Record)
{
	local EnchantChallengePointUIData UIData;
	local EnchantOptionData currentOptionData;
	local EnchantOverUpData currentOverUpData;
	local Color TextColor;
	local string UseCondition;
	local bool bUseCondition;
	local string Title, probString;
	local RichListCtrlRowData emptyRecord;
	local int Fee, ticket, i;
	local EnchantChallengePointSettingUIData o_data;
	local int Prob;

	ticket = GetCurrentTicket(Index);
	Record = emptyRecord;
	if(!API_GetEnchantChallengePointData(API_GetChallengePointGroupID(), UIData))
	{
		return false;
	}
	API_GetEnchantChallengePointSettingData(o_data);
	switch(Index)
	{
		case 0:
			Title = GetSystemString(13982);
			currentOptionData = UIData.ProbInc1;
			if(((currentOptionData.RangeMin == -1) && (currentOptionData.RangeMax == -1)))
			{
				return false;
			}
			Fee = int(o_data.ProbInc1Fee);
			Prob = int(currentOptionData.Prob);
			probString = (string(Prob) $ "%");
			bUseCondition = GetUseCondition(currentOptionData.RangeMin, currentOptionData.RangeMax);
			UseCondition = GetUseConditionString(currentOptionData.RangeMin, currentOptionData.RangeMax);
			break;
		case 1:
			Title = GetSystemString(13983);
			currentOptionData = UIData.ProbInc2;
			if(((currentOptionData.RangeMin == -1) && (currentOptionData.RangeMax == -1)))
			{
				return false;
			}
			Fee = int(o_data.ProbInc2Fee);
			Prob = int(currentOptionData.Prob);
			probString = (string(Prob) $ "%");
			bUseCondition = GetUseCondition(currentOptionData.RangeMin, currentOptionData.RangeMax);
			UseCondition = GetUseConditionString(currentOptionData.RangeMin, currentOptionData.RangeMax);
			break;
		case 2:
			currentOverUpData = UIData.OverUpProb;
			if(((currentOverUpData.RangeMin == -1) && (currentOverUpData.RangeMax == -1)))
			{
				return false;
			}
			Fee = int(o_data.OverUpProbFee);
			Title = MakeFullSystemMsg(GetSystemMessage(13655), ((string(currentOverUpData.OverUps[0].Value) $ "~") $ string(currentOverUpData.OverUps[(currentOverUpData.OverUps.Length - 1)].Value)));
			Prob = int(currentOverUpData.OverUps[0].Prob);
			probString = (string(Prob) $ "%");
			i = 1;
			while((i < currentOverUpData.OverUps.Length))
			{
				probString = (((probString $ "/") $ string(currentOverUpData.OverUps[i].Prob)) $ "%");
				i++;
			}
			bUseCondition = GetUseCondition(currentOverUpData.RangeMin, currentOverUpData.RangeMax);
			UseCondition = GetUseConditionString(currentOverUpData.RangeMin, currentOverUpData.RangeMax);
			break;
		case 3:
			Title = GetSystemString(13985);
			currentOptionData = UIData.NumResetProb;
			if(((currentOptionData.RangeMin == -1) && (currentOptionData.RangeMax == -1)))
			{
				return false;
			}
			Fee = int(o_data.NumResetProbFee);
			Prob = int(currentOptionData.Prob);
			probString = (string(Prob) $ "%");
			bUseCondition = GetUseCondition(currentOptionData.RangeMin, currentOptionData.RangeMax);
			UseCondition = GetUseConditionString(currentOptionData.RangeMin, currentOptionData.RangeMax);
			break;
		case 4:
			Title = GetSystemString(13986);
			currentOptionData = UIData.NumDownProb;
			if(((currentOptionData.RangeMin == -1) && (currentOptionData.RangeMax == -1)))
			{
				return false;
			}
			Fee = int(o_data.NumDownProbFee);
			Prob = int(currentOptionData.Prob);
			probString = (string(Prob) $ "%");
			bUseCondition = GetUseCondition(currentOptionData.RangeMin, currentOptionData.RangeMax);
			UseCondition = GetUseConditionString(currentOptionData.RangeMin, currentOptionData.RangeMax);
			break;
		case 5:
			Title = GetSystemString(13987);
			currentOptionData = UIData.NumProtectProb;
			if(((currentOptionData.RangeMin == -1) && (currentOptionData.RangeMax == -1)))
			{
				return false;
			}
			Fee = int(o_data.NumProtectProbFee);
			Prob = int(currentOptionData.Prob);
			probString = (string(Prob) $ "%");
			bUseCondition = GetUseCondition(currentOptionData.RangeMin, currentOptionData.RangeMax);
			UseCondition = GetUseConditionString(currentOptionData.RangeMin, currentOptionData.RangeMax);
			break;
		default:
			break;
	}
	Record.cellDataList.Length = 5;
	if(bUseCondition)
	{
		TextColor = getInstanceL2Util().White;
		Record.nReserved2 = INT64(1);
	}
	else
	{
		TextColor = getInstanceL2Util().DarkGray;
		Record.nReserved2 = INT64(0);
	}
	AddRichListCtrlString(Record.cellDataList[0].drawitems, Title, TextColor);
	Record.cellDataList[1].nReserved1 = Prob;
	AddRichListCtrlString(Record.cellDataList[1].drawitems, probString, TextColor);
	AddRichListCtrlString(Record.cellDataList[2].drawitems, UseCondition, TextColor);
	AddRichListCtrlString(Record.cellDataList[3].drawitems, string(Fee), TextColor);
	if(bUseCondition)
	{
		addRichListCtrlTexture(Record.cellDataList[3].drawitems, "L2UI_NewTex.ItemEnchantWnd.EnchantPointIcon", 20, 20, 5, -3);
	}
	else
	{
		addRichListCtrlTexture(Record.cellDataList[3].drawitems, "L2UI_NewTex.ItemEnchantWnd.EnchantPointIcon_disable", 20, 20, 5, -3);
	}
	Record.cellDataList[3].nReserved1 = Fee;
	AddRichListCtrlString(Record.cellDataList[4].drawitems, ((string(ticket) $ "/") $ string(o_data.MaxTicketCharge)), TextColor);
	Record.cellDataList[4].nReserved1 = ticket;
	if((SelectedSystemSupport == supportSystemList.GetRecordCount()))
	{
		Record.sOverlayTex = "L2UI_EPIC.CollectionSystemWnd.CollectionSystemWnd_List_KeyCollectionBg";
		Record.OverlayTexU = 510;
		Record.OverlayTexV = 24;
	}
	Record.nReserved1 = INT64(Index);
	return true;
}

function int GetSelectedSystemSupportIndex()
{
	local RichListCtrlRowData Record;

	supportSystemList.GetRec(SelectedSystemSupport, Record);
	return int(Record.nReserved1);
}

function SetIsShopping(bool isShopping)
{
	bIsShopping = isShopping;
	return;
}

event OnReceivedCloseUI()
{
	switch(GetStateName())
	{
		case 'stateEnchant':
			HandleClickButtonEnchant();
			break;
		default:
			PlayConsoleSound(IFST_WINDOW_CLOSE);
			if(supportItemListWnd.IsShowWindow())
			{
				supportItemListWnd.HideWindow();
			}
			else if(supportSystemListWnd.IsShowWindow())
			{
				supportSystemListWnd.HideWindow();
			}
			else
			{
				m_hOwnerWnd.HideWindow();
			}
			break;
	}
	return;
}

function _AddTargetItem(ItemInfo iInfo)
{
	targetItemInfo = iInfo;
	GotoState('stateNone');
	equipmentItemWindow.AddItem(targetItemInfo);
	m_hOwnerWnd.ShowWindow();
	return;
}

function bool CheckTargetItem()
{
	if(!IsValidItemID(targetItemInfo.Id))
	{
		return false;
	}
	return true;
}

function SetStonesWithTargetItem()
{
	return;
}

function _GetTargetItemInfo(out ItemInfo iInfo)
{
	iInfo = targetItemInfo;
	return;
}

function ClearTargetItem()
{
	targetItemInfo.Id.ClassID = -1;
	targetItemInfo.Id.ServerID = -1;
	return;
}

auto state stateNone
{
	function BeginState()
	{
		EnchantBtn.DisableWindow();
		EnchantBtnAuto.HideWindow();
		resetBtn.DisableWindow();
		scrollItemWindow.Clear();
		equipmentItemWindow.Clear();
		supportItemWindow.Clear();
		EnchantEffectViewport.SpawnEffect("");
		GotoState('stateReadyScroll');
		scrollItemNum.HideWindow();
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
		isAutoEnchantingStop = false;
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemMultiEnchantWndTap_Btn")).EnableWindow();
		scrollItemWindow.Clear();
		equipmentItemWindow.Clear();
		supportItemWindow.Clear();
		EnchantEffectViewport.SpawnEffect("");
		GetSlotAniStop("scrollItemWnd");
		GetSlotAniStop("equipmentItemWnd");
		GetSlotAniStop("supportItemWnd");
		GetSlotAniStop("supportSystemWnd");
		GetSupportActiveAniStop("stone");
		GetSupportActiveAniStop("system");
		EnchantBtn.DisableWindow();
		SetNormalMode();
		EnchantBtn.SetNameText(GetSystemString(13935));
		resetBtn.DisableWindow();
		InstructionTxt.SetText(GetSystemMessage(4146));
		WarningTxt00.SetText("");
		WarningTxt01.SetText("");
		EnchantedItemSlot.Clear();
		supportItemWindow.Clear();
		Class'Interface.ItemEnchantSubWnd'.static.Inst().m_hOwnerWnd.ShowWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportItemWnd")).HideWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemWnd")).HideWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd")).HideWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd")).HideWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Fail_Wnd")).HideWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.ResultScreenFence_Wnd")).HideWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemWnd.supportSystemSelectedWnd")).HideWindow();
		SetEnchantEffectItem_WndHide();
		GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".StoneActiveAni")).HideWindow();
		GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".systemActiveAni")).HideWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ProbWnd")).HideWindow();
		supportItemListWnd.HideWindow();
		supportSystemListWnd.HideWindow();
		supportSystemActiveImage.HideWindow();
		Class'Interface.ItemEnchantSubWnd'.static.Inst().refresh();
		groupIDWndScr._SetCurrentGroupID(-1);
		scrollItemNum.HideWindow();
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
		equipmentItemWindow.Clear();
		supportItemWindow.Clear();
		EnchantedItemSlot.Clear();
		EnchantEffectViewport.SpawnEffect("");
		GetSlotAniStop("equipmentItemWnd");
		GetSlotAniStop("supportItemWnd");
		GetSlotAniStop("supportSystemWnd");
		GetSupportActiveAniStop("stone");
		GetSupportActiveAniStop("system");
		Class'Interface.ItemEnchantSubWnd'.static.Inst().m_hOwnerWnd.ShowWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportItemWnd")).HideWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemWnd")).HideWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd")).HideWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd")).HideWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Fail_Wnd")).HideWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.ResultScreenFence_Wnd")).HideWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemWnd.supportSystemSelectedWnd")).HideWindow();
		SetEnchantEffectItem_WndHide();
		GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".StoneActiveAni")).HideWindow();
		GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".systemActiveAni")).HideWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ProbWnd")).HideWindow();
		supportItemListWnd.HideWindow();
		supportSystemListWnd.HideWindow();
		supportSystemActiveImage.HideWindow();
		Class'Interface.ItemEnchantSubWnd'.static.Inst().refresh();
		SelectedSystemSupport = -1;
		EnchantBtn.DisableWindow();
		EnchantBtn.SetNameText(GetSystemString(13935));
		SetNormalMode();
		HandleInstructionTxt();
		WarningTxt00.SetText("");
		WarningTxt01.SetText("");
		GetSlotAniPlay("scrollItemWnd");
		resetBtn.EnableWindow();
		groupIDWndScr._SetCurrentGroupID(-1);
		scrollItemNum.HideWindow();
		if(CheckTargetItem())
		{
			API_RequestExTryToPutEnchantTargetItem(targetItemInfo);
			ClearTargetItem();
		}
		return;
	}

	function EndState()
	{
		prevState = GetStateName();
		return;
	}
}

state stateReadySupport
{
	function BeginState()
	{
		isAutoEnchantingStop = false;
		EnchantBtn.EnableWindow();
		GetSlotAniPlay("scrollItemWnd");
		GetSlotAniPlay("equipmentItemWnd");
		GetSlotAniStop("supportItemWnd");
		GetSlotAniStop("supportSystemWnd");
		GetSupportActiveAniStop("stone");
		GetSupportActiveAniStop("system");
		supportSystemActiveImage.HideWindow();
		GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".StoneActiveAni")).HideWindow();
		GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".systemActiveAni")).HideWindow();
		SetSupportSystemList();
		API_RequestExRemoveEnchantSupportItem();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemWnd.supportSystemSelectedWnd")).HideWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ProbWnd")).ShowWindow();
		CheckWarningTxt();
		CheckSupports();
		ChangeEquipmentAni();
		if(CanUseAutoMode())
		{
			SetAutoMode();
		}
		else
		{
			SetNormalMode();
		}
		scrollItemNum.HideWindow();
		SetEnchantEffectItem_Wnd();
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".FailprdctItem_BTN")).ShowWindow();
		return;
	}

	function EndState()
	{
		prevState = GetStateName();
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".FailprdctItem_BTN")).HideWindow();
		return;
	}

	function HandleClickButtonEnchant()
	{
		CheckEnchantNEncht();
		return;
	}
}

state stateReadySupportsystem
{
	function BeginState()
	{
		GetSlotAniPlay("scrollItemWnd");
		GetSlotAniPlay("equipmentItemWnd");
		GetSlotAniStop("supportItemWnd");
		GetSlotAniPlay("supportSystemWnd");
		GetSupportActiveAniPlay("system");
		GetSupportActiveAniStop("stone");
		GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".StoneActiveAni")).HideWindow();
		GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".systemActiveAni")).ShowWindow();
		supportSystemActiveImage.ShowWindow();
		EnchantBtn.EnableWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".supportSystemWnd.supportSystemSelectedWnd")).ShowWindow();
		scrollItemNum.HideWindow();
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".FailprdctItem_BTN")).ShowWindow();
		return;
	}

	function EndState()
	{
		prevState = GetStateName();
		supportItemListWnd.HideWindow();
		supportSystemListWnd.HideWindow();
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".FailprdctItem_BTN")).HideWindow();
		return;
	}

	function HandleClickButtonEnchant()
	{
		CheckEnchantNEncht();
		return;
	}
}

state stateReadySupportstone
{
	function BeginState()
	{
		CheckWarningTxt();
		GetSlotAniPlay("scrollItemWnd");
		GetSlotAniPlay("equipmentItemWnd");
		GetSlotAniPlay("supportItemWnd");
		GetSlotAniStop("supportSystemWnd");
		GetSupportActiveAniPlay("stone");
		GetSupportActiveAniStop("system");
		GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".StoneActiveAni")).ShowWindow();
		GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".systemActiveAni")).HideWindow();
		EnchantBtn.EnableWindow();
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".FailprdctItem_BTN")).ShowWindow();
		scrollItemNum.HideWindow();
		return;
	}

	function EndState()
	{
		prevState = GetStateName();
		supportItemListWnd.HideWindow();
		supportSystemListWnd.HideWindow();
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".FailprdctItem_BTN")).HideWindow();
		return;
	}

	function HandleClickButtonEnchant()
	{
		CheckEnchantNEncht();
		return;
	}
}

state stateEnchant
{
	function BeginState()
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemMultiEnchantWndTap_Btn")).DisableWindow();
		Class'Interface.ItemEnchantSubWnd'.static.Inst().m_hOwnerWnd.HideWindow();
		HandleInstructionTxt();
		EnchantEffectViewport.SetCameraDistance(175.0000000);
		timerObject._DelegateOnEnd = RequestEnchant;
		if(isAutoEnchanting)
		{
			EnchantEffectViewport.SetScale(0.2000000);
			timerObject._time = 600;
			EnchantBtn.DisableWindow();
			EnchantBtnAuto.SetNameText(GetSystemString(14238));
			StartAutoEnchant();
			scrollItemNum.ShowWindow();
		}
		else
		{
			EnchantEffectViewport.SetScale(1.0000000);
			EnchantEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_start");
			PlaySound("Itemsound3.ui_enchant_start");
			PlaySound("Itemsound3.ui_enchant_start_sfx");
			EnchantBtn.EnableWindow();
			EnchantBtn.SetNameText(GetSystemString(13936));
			EnchantBtnAuto.DisableWindow();
			timerObject._time = 1500;
			timerObject._Play();
		}
		EnchantEffectViewport.SetFocus();
		SetEnchantEffectItem_WndHide();
		supportItemListWnd.HideWindow();
		return;
	}

	function EndState()
	{
		SetNormalMode();
		EnchantBtn.SetNameText(GetSystemString(13935));
		prevState = GetStateName();
		EnchantEffectViewport.SpawnEffect("");
		timerObject._Stop();
		resetBtn.EnableWindow();
		isAutoEnchanting = false;
		return;
	}

	function HandleClickButtonEnchant()
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemMultiEnchantWndTap_Btn")).EnableWindow();
		Class'Interface.ItemEnchantSubWnd'.static.Inst().m_hOwnerWnd.ShowWindow();
		if(isAutoEnchanting)
		{
			isAutoEnchantingStop = true;
			InstructionTxt.SetText(GetSystemString(14239));
		}
		else
		{
			GotoState(prevState);
			HandleInstructionTxt();
		}
		return;
	}
}

state stateCompleteBlind
{
	function BeginState()
	{
		SelectedSystemSupport = -1;
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd")).ShowWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.ResultScreenFence_Wnd")).ShowWindow();
		HandleInstructionTxt();
		EnchantEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_screen");
		EnchantEffectViewport.SetScale(1.3400000);
		EnchantEffectViewport.SetCameraDistance(222.0000000);
		EnchantEffectViewport.SetFocus();
		EnchantBtn.SetNameText(GetSystemString(140));
		resetBtn.DisableWindow();
		groupIDWndScr._SetDisable();
		PlaySound("Itemsound3.ui_enchant_screen");
		return;
	}

	function EndState()
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.ResultScreenFence_Wnd")).HideWindow();
		prevState = GetStateName();
		EnchantEffectViewport.SpawnEffect("");
		resetBtn.EnableWindow();
		groupIDWndScr._SetEnable();
		return;
	}

	function HandleClickButtonEnchant()
	{
		API_C_EX_REQ_VIEW_ENCHANT_RESULT();
		GotoState(resultState);
		return;
	}
}

state stateCompleteResult
{
	function BeginState()
	{
		isAutoEnchanting = false;
		isAutoEnchantingStop = false;
		SelectedSystemSupport = -1;
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemMultiEnchantWndTap_Btn")).EnableWindow();
		EnchantEffectViewport.SetScale(1.0000000);
		switch(byte(GetIteminfoScroll().EtcItemType))
		{
			case 86:
			case 87:
				EnchantEffectViewport.SetCameraDistance(160.0000000);
				EnchantEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_fail");
				PlaySound("Itemsound3.ui_enchant_fail");
				PlaySound("Itemsound3.ui_enchant_fail_sfx");
				break;
			default:
				EnchantEffectViewport.SetCameraDistance(175.0000000);
				if(isGreateSuccess)
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
				break;
		}
		EnchantEffectViewport.SetFocus();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd")).ShowWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.NextEnchantFail_Text")).ShowWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd")).ShowWindow();
		HandleInstructionTxt();
		EnchantBtn.EnableWindow();
		EnchantBtn.SetNameText(GetSystemString(3135));
		SetNormalMode();
		return;
	}

	function EndState()
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd")).HideWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Success_Wnd")).HideWindow();
		prevState = GetStateName();
		EnchantEffectViewport.SpawnEffect("");
		return;
	}

	function HandleClickButtonEnchant()
	{
		Class'Interface.ItemEnchantSubWnd'.static.Inst().m_hOwnerWnd.ShowWindow();
		ChkEnchantContinue();
		return;
	}
}

state stateCompleteResultfail
{
	function BeginState()
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemMultiEnchantWndTap_Btn")).EnableWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd")).ShowWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Fail_Wnd")).ShowWindow();
		HandleInstructionTxt();
		EnchantEffectViewport.SpawnEffect("LineageEffect2.ui_Enchant_fail");
		PlaySound("Itemsound3.ui_enchant_fail");
		PlaySound("Itemsound3.ui_enchant_fail_sfx");
		EnchantEffectViewport.SetScale(1.0000000);
		EnchantEffectViewport.SetCameraDistance(160.0000000);
		EnchantEffectViewport.SetFocus();
		EnchantBtn.EnableWindow();
		EnchantBtn.SetNameText(GetSystemString(3135));
		SetNormalMode();
		CheckEmptyFailItemInfoToList();
		return;
	}

	function EndState()
	{
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd")).HideWindow();
		GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Result_wnd.Fail_Wnd")).HideWindow();
		prevState = GetStateName();
		EnchantEffectViewport.SpawnEffect("");
		return;
	}

	function bool IsCanContinueEEtcTypeScroll()
	{
		switch(byte(GetIteminfoScroll().EtcItemType))
		{
			case 21:
			case 22:
			case 64:
			case 32:
			case 33:
			case 66:
				return true;
			default:
				return false;
		}
	}

	function HandleClickButtonEnchant()
	{
		local ItemInfo iInfo;
		local bool bScroll;

		if(getInstanceUIData().GetIsLiveServer())
		{
			if(IsCanContinueEEtcTypeScroll())
			{
				if(ChkEnchantContinue())
				{
					return;
				}
			}
		}
		bScroll = RefreshScroll(iInfo);
		if((supportItemWindow.GetItemNum() > 0))
		{
			API_RequestExRemoveEnchantSupportItem();
		}
		if((SelectedSystemSupport > -1))
		{
			API_C_EX_RESET_ENCHANT_CHALLENGE_POINT();
		}
		GotoState('stateReadyScroll');
		API_RequestExCancelEnchantItem();
		if(bScroll)
		{
			API_RequestExAddEnchantScrollItem(iInfo);
		}
		return;
	}
}
