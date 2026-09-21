class RefineryWnd extends UICommonAPI
	dependson(UIPacket);

const TWEENID_SLOT1 = 1;
const TWEENID_SLOT2 = 2;
const TIMEPROGRESS = 1000;
const Adena = 57;
const SHAKEID_ME = 101;
const DWAFT_ID = 19673;
const TIMEID_Confirm = 90;
const TIME_Confirm = 500;

enum type_State
{
	stone,                          // 0
	Target,                         // 1
	READY,                          // 2
	ing,                            // 3
	Result,                         // 4
	target_only                     // 5
};

struct NewOptionResultInfo
{
	var bool isConfirm;
	var int targetItemSId;
	var int newItemOption1;
	var int newItemOption2;
	var int newItemOption3;
};

struct FeeEventInfo
{
	var bool isEventOn;
	var int itemCountPercent;
	var int FeeAdenaPercent;
};

var WindowHandle Me;
var string m_Windowname;
var ItemInfo RefineItemInfo;
var ItemInfo RefinerItemInfo;
var ItemInfo GemstoneItemInfo;
var ItemInfo RefinedITemInfo;
var WindowHandle m_DragBox1;
var WindowHandle m_DragBox2;
var WindowHandle m_DragBoxResult;
var WindowHandle m_ResultAnimation1;
var WindowHandle m_ResultAnimation2;
var WindowHandle m_ResultAnimation3;
var WindowHandle m_ResultAnimation4;
var AnimTextureHandle m_RefineAnim;
var AnimTextureHandle m_ResultAnim1;
var AnimTextureHandle m_ResultAnim2;
var AnimTextureHandle m_ResultAnim3;
var AnimTextureHandle m_ResultAnim4;
var ButtonHandle m_RefineryBtn;
var ButtonHandle btnReset;
var ItemWindowHandle m_DragboxItem1;
var ItemWindowHandle m_DragBoxItem2;
var ItemWindowHandle m_ResultBoxItem;
var TextBoxHandle m_InstructionText;
var TextBoxHandle txtOptions;
var TextureHandle optionGradeTexture;
var ItemWindowHandle ItemList;
var WindowHandle ItemListWindow;
var CharacterViewportWindowHandle m_ObjectViewport;
var array<UIControlNeedItem> UIControlNeedItemScripts;
var ProgressCtrlHandle m_hRefineryWndRefineryProgress;
var WindowHandle newOptionsWnd;
var WindowHandle optionBlindWnd;
var WindowHandle newOptionBlindWnd;
var WindowHandle newDisableWnd;
var ButtonHandle newOptionBtn;
var ButtonHandle closeWndBtn;
var TextBoxHandle newTxtOptions;
var TextureHandle newOptionGradeTex;
var TextureHandle preOptionCheckTex;
var AnimTextureHandle newOptionApplyAnimTex;
var TextureHandle m_ShortcutIcon_Enter;
var TextureHandle m_ShortcutIcon_ESC;
var TextBoxHandle emptyOptionText;
var TextureHandle specialOpEffectTex;
var TextureHandle newSpecialOpEffectTex;
var type_State CurrentState;
var L2UITween l2UITweenScript;
var L2UIInventoryObjectSimple iObject;
var RefineryWndOption RefineryWndOptionScript;
var NewOptionResultInfo newResultInfo;
var FeeEventInfo eventInfo;
var ItemInfo targetItemInfo;
var bool bHideAndInventoryShow;
var bool _IsFocused;

function InitHandleListItems()
{
	local int i;
	local string WindowName;

	i = 0;
	while((i < 2))
	{
		WindowName = ((m_Windowname $ ".NeedItem") $ string(i));
		GetWindowHandle(WindowName).SetScript("UIControlNeedItem");
		UIControlNeedItemScripts[i] = UIControlNeedItem(GetWindowHandle(WindowName).GetScript());
		UIControlNeedItemScripts[i].Init(WindowName);
		UIControlNeedItemScripts[i].DelegateItemUpdate = PeeItemUpdated;
		i++;
	}
	return;
}

function InitHandleCOD()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	InitHandleListItems();
	m_DragBox1 = GetWindowHandle((m_Windowname $ ".ItemDragBox1Wnd"));
	m_DragBox2 = GetWindowHandle((m_Windowname $ ".ItemDragBox2Wnd"));
	m_DragBoxResult = GetWindowHandle((m_Windowname $ ".ItemDragBoxResultWnd"));
	m_ResultAnimation1 = GetWindowHandle((m_Windowname $ ".RefineResultAnimation01"));
	m_ResultAnimation2 = GetWindowHandle((m_Windowname $ ".RefineResultAnimation02"));
	m_ResultAnimation3 = GetWindowHandle((m_Windowname $ ".RefineResultAnimation03"));
	m_ResultAnimation4 = GetWindowHandle((m_Windowname $ ".RefineResultAnimation04"));
	m_RefineAnim = GetAnimTextureHandle((m_Windowname $ ".RefineLoadingAnimation.RefineLoadingAnim"));
	m_ResultAnim1 = GetAnimTextureHandle((m_Windowname $ ".RefineResultAnimation01.RefineResult1"));
	m_ResultAnim2 = GetAnimTextureHandle((m_Windowname $ ".RefineResultAnimation02.RefineResult2"));
	m_ResultAnim3 = GetAnimTextureHandle((m_Windowname $ ".RefineResultAnimation03.RefineResult3"));
	m_ResultAnim4 = GetAnimTextureHandle((m_Windowname $ ".RefineResultAnimation04.RefineResult4"));
	m_DragboxItem1 = GetItemWindowHandle((m_Windowname $ ".ItemDragBox1Wnd.ItemDragBox"));
	m_DragBoxItem2 = GetItemWindowHandle((m_Windowname $ ".ItemDragBox2Wnd.ItemDragBox"));
	m_ResultBoxItem = GetItemWindowHandle((m_Windowname $ ".ItemDragBoxResultWnd.ItemRefined"));
	btnReset = GetButtonHandle((m_Windowname $ ".btnReset"));
	m_RefineryBtn = GetButtonHandle((m_Windowname $ ".btnRefine"));
	m_InstructionText = GetTextBoxHandle((m_Windowname $ ".txtInstruction"));
	ItemListWindow = GetWindowHandle((m_Windowname $ ".ItemListWindow"));
	ItemList = GetItemWindowHandle((m_Windowname $ ".ItemListWindow.ItemList"));
	l2UITweenScript = L2UITween(GetScript("l2UITween"));
	RefineryWndOptionScript = RefineryWndOption(GetScript("RefineryWndOption"));
	m_hRefineryWndRefineryProgress = GetProgressCtrlHandle((m_Windowname $ ".RefineryProgress"));
	txtOptions = GetTextBoxHandle((m_Windowname $ ".txtOptions"));
	optionGradeTexture = GetTextureHandle((m_Windowname $ ".optionGradeTexture"));
	m_ObjectViewport = GetCharacterViewportWindowHandle((m_Windowname $ ".ObjectViewport"));
	m_ObjectViewport.SetUISound(true);
	m_RefineAnim.SetLoopCount(1);
	m_ResultAnim1.SetLoopCount(1);
	m_ResultAnim2.SetLoopCount(1);
	m_ResultAnim3.SetLoopCount(1);
	m_ResultAnim4.SetLoopCount(1);
	m_hRefineryWndRefineryProgress.SetProgressTime((1000 - 100));
	if(IsSupportedResultChoice())
	{
		newOptionsWnd = GetWindowHandle((m_Windowname $ ".NewOptions_wnd"));
		optionBlindWnd = GetWindowHandle((m_Windowname $ ".OptionGradeBlind_wnd"));
		newOptionBlindWnd = GetWindowHandle((newOptionsWnd.m_WindowNameWithFullPath $ ".NewOptionGradeBlind_wnd"));
		newDisableWnd = GetWindowHandle((m_Windowname $ ".DisableWnd"));
		newOptionBtn = GetButtonHandle((newOptionsWnd.m_WindowNameWithFullPath $ ".NewOption_btn"));
		closeWndBtn = GetButtonHandle((m_Windowname $ ".exitbutton"));
		newTxtOptions = GetTextBoxHandle((newOptionsWnd.m_WindowNameWithFullPath $ ".txtOptions"));
		newOptionGradeTex = GetTextureHandle((newOptionsWnd.m_WindowNameWithFullPath $ ".NewOptionGradeTexture"));
		newOptionApplyAnimTex = GetAnimTextureHandle((m_Windowname $ ".OptionRgstr_Ani"));
		preOptionCheckTex = GetTextureHandle((m_Windowname $ ".CheckTexture"));
	}
	m_ShortcutIcon_Enter = GetTextureHandle((m_Windowname $ ".ShortcutIcon_Enter"));
	m_ShortcutIcon_ESC = GetTextureHandle((m_Windowname $ ".ShortcutIcon_ESC"));
	emptyOptionText = GetTextBoxHandle((m_Windowname $ ".txtNoOptions"));
	specialOpEffectTex = GetTextureHandle((m_Windowname $ ".SpecialOptionEffect"));
	newSpecialOpEffectTex = GetTextureHandle((newOptionsWnd.m_WindowNameWithFullPath $ ".NewSpecialOptionEffect"));
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	InitHandleCOD();
	return;
}

event OnRegisterEvent()
{
	RegisterEvent((100000 + 337));
	RegisterEvent((100000 + 340));
	RegisterEvent((100000 + 342));
	RegisterEvent(EV_PacketID(1030));
	return;
}

event OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case (100000 + 337):
			Decode_S_EX_SHOW_VARIATION_MAKE_WINDOW(a_Param);
			break;
		case (100000 + 340):
			Decode_S_EX_PUT_INTENSIVE_RESULT_FOR_VARIATION_MAKE(a_Param);
			break;
		case (100000 + 342):
			Decode_S_EX_VARIATION_RESULT(a_Param);
			break;
		case EV_PacketID(1030):
			Rs_S_EX_APPLY_VARIATION_OPTION();
			break;
		default:
			break;
	}
	return;
}

event OnDropItem(string a_WindowID, ItemInfo a_itemInfo, int X, int Y)
{
	if((a_itemInfo.ShortcutType == 4))
	{
		return;
	}
	switch(a_itemInfo.DragSrcName)
	{
		case "ItemList":
			HandleOnDropItem(a_itemInfo);
			break;
		default:
			break;
	}
	return;
}

event OnRClickItem(string strID, int Index)
{
	switch(strID)
	{
		case "ItemList":
			OnDBClickItem(strID, Index);
			break;
		default:
			break;
	}
	return;
}

event OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo iInfo;

	switch(ControlName)
	{
		case "ItemList":
			ItemList.GetItem(Index, iInfo);
			if((iInfo.Id.ClassID > 0))
			{
				HandleOnDropItem(iInfo);
			}
			break;
		default:
			break;
	}
	return;
}

event OnHide()
{
	ResetAnims();
	RemObjectSimpleByObject(iObject);
	if(IsSupportedResultChoice())
	{
		if(DialogIsMine())
		{
			DialogHide();
		}
		SetNewResultInfo(false, 0, 0, 0, 0);
		PlayNewOptionApplyEffect(false);
		Rq_C_EX_VARIATION_CLOSE_UI();
	}
	ResetRefineryEventInfo();
	ClearTargetItem();
	return;
}

event OnShow()
{
	bHideAndInventoryShow = false;
	Me.SetFocus();
	SetDwaft();
	SetState(stone);
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("PetWnd");
	iObject = AddItemListenerSimple(0);
	iObject.DelegateOnUpdateItem = HandleUpdateItemStone;
	if(IsSupportedResultChoice())
	{
		SetDialogModal(false);
		SetNewResultInfo(false, 0, 0, 0, 0);
		PlayNewOptionApplyEffect(false);
		Rq_C_EX_VARIATION_OPEN_UI();
	}
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnRefine":
			HandleClickBtnRefine();
			break;
		case "btnClose":
			OnClickbtnClose();
			break;
		case "btnReset":
			if(IsSupportedResultChoice())
			{
				NewResultCheckAndReset();
			}
			else
			{
				SetState(stone);
			}
			break;
		case "btnOptions":
			RefineryWndOptionScript.Toggle();
			break;
		case "NewOption_btn":
			OnNewOptionBtnClicked();
			break;
		case "exitbutton":
			NewResultCheckAndCloseWnd();
			break;
		default:
			break;
	}
	return;
}

event OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 90:
			Me.KillTimer(90);
			if((int(CurrentState) == 4))
			{
				if(IsSupportedResultChoice())
				{
					if(canBuy())
					{
						m_RefineryBtn.EnableWindow();
					}
				}
				else
				{
					m_RefineryBtn.EnableWindow();
				}
			}
			break;
		default:
			break;
	}
	return;
}

event OnTextureAnimEnd(AnimTextureHandle a_WindowHandle)
{
	switch(a_WindowHandle)
	{
		case m_ResultAnim1:
			m_ResultAnimation1.HideWindow();
			break;
		case m_ResultAnim2:
			m_ResultAnimation2.HideWindow();
			break;
		case m_ResultAnim3:
			m_ResultAnimation3.HideWindow();
			break;
		case m_ResultAnim4:
			m_ResultAnimation4.HideWindow();
			break;
		case newOptionApplyAnimTex:
			newOptionApplyAnimTex.HideWindow();
			break;
		default:
			break;
	}
	return;
}

event OnProgressTimeUp(string strID)
{
	switch(strID)
	{
		case "RefineryProgress":
			RequestRefine();
			break;
		default:
			break;
	}
	return;
}

event OnSetFocus(WindowHandle focusedWnd, bool bFocused)
{
	_IsFocused = bFocused;
	super.OnSetFocus(focusedWnd, bFocused);
	UpdateHotKeyControls();
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	switch(nKey)
	{
		case IK_Escape:
			if(m_ShortcutIcon_ESC.IsShowWindow())
			{
				if(m_RefineryBtn.IsEnableWindow())
				{
					HandleClickBtnRefine();
				}
				return true;
			}
			break;
		default:
			break;
	}
	return false;
}

event bool OnKeyDown(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	switch(nKey)
	{
		case IK_Enter:
			if(m_ShortcutIcon_Enter.IsShowWindow())
			{
				if(m_RefineryBtn.IsEnableWindow())
				{
					HandleClickBtnRefine();
				}
				return true;
			}
			break;
		default:
			break;
	}
	return false;
}

function HandleOnDropItem(ItemInfo iInfo)
{
	switch(CurrentState)
	{
		case stone:
			AddItemStone(iInfo);
			break;
		case Target:
			AddItemTarget(iInfo);
			break;
		default:
			break;
	}
	return;
}

function AddItemStone(ItemInfo iInfo)
{
	PlaySound("ItemSound2.smelting.Smelting_dragin");
	iInfo.bShowCount = true;
	m_DragboxItem1.AddItem(iInfo);
	SetState(Target);
	MakeTweenAlpha(m_DragBox1, 1);
	iObject.setId(iInfo.Id);
	if(CheckTargetItem())
	{
		AddItemTarget(targetItemInfo);
		ClearTargetItem();
	}
	return;
}

function AddItemTarget(ItemInfo iInfo)
{
	PlaySound("ItemSound2.smelting.Smelting_dragin");
	m_DragBoxItem2.AddItem(iInfo);
	AddRefineryText();
	SetPeeItems();
	SetState(READY);
	MakeTweenAlpha(m_DragBox2, 2);
	SetOptionList();
	SetNewResultInfo(false, 0, 0, 0, 0);
	UpdateStateNewResult();
	return;
}

function SetPeeItems()
{
	local ItemInfo itemInfoStone, itemInfoTarget;
	local int FeeItemID, FeeItemCount, CancelFee;
	local INT64 feeAdenaCount;

	if(!GetItemInfoStone(itemInfoStone))
	{
		return;
	}
	if(!GetItemInfoTarget(itemInfoTarget))
	{
		return;
	}
	if((eventInfo.isEventOn == true))
	{
		Class'NWindow.RefineryAPI'.static.GetRefineryFee(itemInfoStone.Id.ClassID, itemInfoTarget.Id.ClassID, eventInfo.itemCountPercent, eventInfo.FeeAdenaPercent, FeeItemID, FeeItemCount, feeAdenaCount, CancelFee);
	}
	else
	{
		Class'NWindow.RefineryAPI'.static.GetRefineryFee(itemInfoStone.Id.ClassID, itemInfoTarget.Id.ClassID, 100, 100, FeeItemID, FeeItemCount, feeAdenaCount, CancelFee);
	}
	if(((FeeItemID == 0) || (FeeItemCount == 0)))
	{
		UIControlNeedItemScripts[0].setId(GetItemID(57));
		UIControlNeedItemScripts[0].SetNumNeed(feeAdenaCount);
		UIControlNeedItemScripts[1].Me.HideWindow();
	}
	else
	{
		UIControlNeedItemScripts[0].setId(GetItemID(FeeItemID));
		UIControlNeedItemScripts[0].SetNumNeed(INT64(FeeItemCount));
		UIControlNeedItemScripts[1].Me.ShowWindow();
		UIControlNeedItemScripts[1].setId(GetItemID(57));
		UIControlNeedItemScripts[1].SetNumNeed(feeAdenaCount);
	}
	return;
}

function SetStones()
{
	local int i, Len;
	local array<ItemInfo> iInfos;

	ItemList.Clear();
	Len = API_GetTargetItemListFromInven(iInfos);
	i = 0;
	while((i < Len))
	{
		ItemList.AddItem(iInfos[i]);
		i++;
	}
	return;
}

function SetTargetItems()
{
	local int i, Len;
	local array<ItemInfo> iInfos;
	local ItemInfo itemInfoStone;

	ItemList.Clear();
	if(!GetItemInfoStone(itemInfoStone))
	{
		return;
	}
	Len = API_GetItemListFromInven(itemInfoStone.Id.ClassID, iInfos);
	i = 0;
	while((i < Len))
	{
		ItemList.AddItem(iInfos[i]);
		i++;
	}
	return;
}

function int API_GetItemListFromInven(int stoneClassID, out array<ItemInfo> iItems)
{
	return Class'NWindow.RefineryAPI'.static.GetItemListFromInven(stoneClassID, iItems);
}

function int API_GetTargetItemListFromInven(out array<ItemInfo> iItems)
{
	return Class'NWindow.RefineryAPI'.static.GetTargetItemListFromInven(iItems);
}

function Rq_C_EX_TRY_TO_MAKE_VARIATION(int targetItemServerId, int intensiveItemServerId, bool isEventOn)
{
	local array<byte> stream;
	local UIPacket._C_EX_TRY_TO_MAKE_VARIATION packet;

	packet.nItemServerId = targetItemServerId;
	packet.nIntensiveItemServerID = intensiveItemServerId;
	packet.bIsVariationEventOn = byte(isEventOn);
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_TRY_TO_MAKE_VARIATION(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(271, stream);
	return;
}

function Rq_C_EX_VARIATION_OPEN_UI()
{
	local array<byte> stream;
	local UIPacket._C_EX_VARIATION_OPEN_UI packet;

	if(!IsSupportedResultChoice())
	{
		return;
	}
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_VARIATION_OPEN_UI(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(792, stream);
	return;
}

function Rq_C_EX_VARIATION_CLOSE_UI()
{
	local array<byte> stream;
	local UIPacket._C_EX_VARIATION_CLOSE_UI packet;

	if(!IsSupportedResultChoice())
	{
		return;
	}
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_VARIATION_CLOSE_UI(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(793, stream);
	return;
}

function Rq_C_EX_APPLY_VARIATION_OPTION(int variationItemSId, int itemOption1, int itemOption2, int itemOption3)
{
	local array<byte> stream;
	local UIPacket._C_EX_APPLY_VARIATION_OPTION packet;

	if(!IsSupportedResultChoice())
	{
		return;
	}
	packet.nVariationItemSID = variationItemSId;
	packet.nItemOption1 = itemOption1;
	packet.nItemOption2 = itemOption2;
	packet.nItemOption3 = itemOption3;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_APPLY_VARIATION_OPTION(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(794, stream);
	return;
}

function Decode_S_EX_SHOW_VARIATION_MAKE_WINDOW(string a_Param)
{
	local UIPacket._S_EX_SHOW_VARIATION_MAKE_WINDOW packet;

	if(Me.IsShowWindow())
	{
		Me.HideWindow();
	}
	else
	{
		if(Class'Interface.UIPacket'.static.Decode_S_EX_SHOW_VARIATION_MAKE_WINDOW(packet))
		{
			eventInfo.isEventOn = bool(packet.bIsVariationEventOn);
			eventInfo.itemCountPercent = packet.nGemStoneCountPercent;
			eventInfo.FeeAdenaPercent = packet.nFeeAdenaPercent;
		}
		Me.ShowWindow();
	}
	return;
}

function Decode_S_EX_PUT_INTENSIVE_RESULT_FOR_VARIATION_MAKE(string a_Param)
{
	local int targetItemServerId, TargetItemClassID, insertResult;

	Class'Interface.UIPacket'.static.DecodeInt(targetItemServerId);
	Class'Interface.UIPacket'.static.DecodeInt(TargetItemClassID);
	Class'Interface.UIPacket'.static.DecodeInt(insertResult);
	Handle_S_EX_PUT_INTENSIVE_RESULT_FOR_VARIATION_MAKE(targetItemServerId, TargetItemClassID, insertResult);
	return;
}

function Decode_S_EX_VARIATION_RESULT(string a_Param)
{
	local int Option1, Option2, Option3;
	local INT64 GemStoneCount, NecessaryGemStoneCount;
	local int RefineResult;

	Class'Interface.UIPacket'.static.DecodeInt(Option1);
	Class'Interface.UIPacket'.static.DecodeInt(Option2);
	Class'Interface.UIPacket'.static.DecodeInt(Option3);
	Class'Interface.UIPacket'.static.DecodeInt64(GemStoneCount);
	Class'Interface.UIPacket'.static.DecodeInt64(NecessaryGemStoneCount);
	Class'Interface.UIPacket'.static.DecodeInt(RefineResult);
	Handle_S_EX_VARIATION_RESULT(Option1, Option2, Option3, RefineResult);
	return;
}

function Handle_S_EX_PUT_INTENSIVE_RESULT_FOR_VARIATION_MAKE(int targetItemServerId, int TargetItemClassID, int insertResult)
{
	local ItemInfo targetItem;

	Class'NWindow.UIDATA_INVENTORY'.static.FindItem(targetItemServerId, targetItem);
	AddItemStone(targetItem);
	return;
}

function Handle_S_EX_VARIATION_RESULT(int Option1, int Option2, int Option3, int RefineResult)
{
	local ItemInfo iInfo;

	switch(RefineResult)
	{
		case 1:
			SetState(Result);
			if(GetItemInfoTarget(iInfo))
			{
				if(IsSupportedResultChoice())
				{
					SetNewResultInfo(false, iInfo.Id.ServerID, Option1, Option2, Option3);
					if(((iInfo.RefineryOp1 == 0) && (iInfo.RefineryOp2 == 0)))
					{
						newOptionBtn.SetEnable(false);
						Rq_C_EX_APPLY_VARIATION_OPTION(iInfo.Id.ServerID, Option1, Option2, Option3);
					}
					else
					{
						UpdateStateNewResult();
					}
				}
				else
				{
					iInfo.RefineryOp1 = Option1;
					iInfo.RefineryOp2 = Option2;
					iInfo.RefineryOp3 = Option3;
				}
				m_ResultBoxItem.ShowWindow();
				m_ResultBoxItem.Clear();
				m_ResultBoxItem.AddItem(iInfo);
				m_DragBoxItem2.Clear();
				m_DragBoxItem2.AddItem(iInfo);
				AddRefineryText();
			}
			if(!IsSupportedResultChoice())
			{
				PlayResultQualityAnimation(GetRefineryGradeQuality(Option1, Option2, Option3));
			}
			break;
		case 0:
			SetHideWindow();
			break;
		default:
			break;
	}
	return;
}

function Rs_S_EX_APPLY_VARIATION_OPTION()
{
	local UIPacket._S_EX_APPLY_VARIATION_OPTION packet;
	local bool IsSuccess;
	local ItemInfo iInfo;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_APPLY_VARIATION_OPTION(packet))
	{
		return;
	}
	IsSuccess = bool(packet.bResult);
	if((IsSuccess == true))
	{
		if(GetItemInfoTarget(iInfo))
		{
			SetNewResultInfo(true, packet.nVariationItemSID, 0, 0, 0);
			iInfo.RefineryOp1 = packet.nItemOption1;
			iInfo.RefineryOp2 = packet.nItemOption2;
			iInfo.RefineryOp3 = packet.nItemOption3;
			m_ResultBoxItem.ShowWindow();
			m_ResultBoxItem.Clear();
			m_ResultBoxItem.AddItem(iInfo);
			m_DragBoxItem2.Clear();
			m_DragBoxItem2.AddItem(iInfo);
			UpdateStateNewResult();
			AddRefineryText();
			PlayNewOptionApplyEffect(true);
			PlayResultQualityAnimation(GetRefineryGradeQuality(packet.nItemOption1, packet.nItemOption2, packet.nItemOption3));
			getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13659));
		}
	}
	else
	{
		Debug("S_EX_APPLY_VARIATION_OPTION FAIL");
		newOptionBtn.SetEnable(true);
	}
	return;
}

function SetState(type_State State)
{
	CurrentState = State;
	ResetAnims();
	switch(State)
	{
		case stone:
			SetStateStone();
			break;
		case Target:
			SetStateTarget();
			break;
		case READY:
			SetStateReady();
			break;
		case ing:
			SetStateIng();
			break;
		case Result:
			SetStateResult();
			break;
		default:
			break;
	}
	SetHighLightsEmpty();
	SetButtonSetting();
	SetInstructionText();
	UpdateHotKeyControls();
	return;
}

function SetStateStone()
{
	m_DragBoxResult.HideWindow();
	ItemListWindow.ShowWindow();
	m_DragboxItem1.Clear();
	iObject.setId();
	m_DragBoxItem2.Clear();
	m_DragBox1.ShowWindow();
	m_DragBox2.ShowWindow();
	ClearRefineryText();
	ClearNewRefineryText();
	SetNewResultInfo(false, 0, 0, 0, 0);
	if(!CheckTargetItem())
	{
		SetStones();
	}
	else
	{
		SetStonesWithTargetItem();
	}
	DelOptionList();
	return;
}

function SetStateTarget()
{
	SetTargetItems();
	m_DragBoxResult.HideWindow();
	ItemListWindow.ShowWindow();
	m_DragBox1.ShowWindow();
	m_DragBox2.ShowWindow();
	DelOptionList();
	return;
}

function SetStateReady()
{
	m_DragBoxResult.HideWindow();
	ItemListWindow.HideWindow();
	m_hRefineryWndRefineryProgress.Stop();
	m_hRefineryWndRefineryProgress.Reset();
	m_DragBox1.ShowWindow();
	m_DragBox2.ShowWindow();
	SetNewResultInfo(false, 0, 0, 0, 0);
	UpdateStateNewResult();
	bHideAndInventoryShow = false;
	return;
}

function SetStateIng()
{
	MakeProgressTween();
	m_DragBoxResult.HideWindow();
	ItemListWindow.HideWindow();
	m_RefineAnim.ShowWindow();
	m_RefineAnim.Stop();
	m_RefineAnim.Play();
	m_hRefineryWndRefineryProgress.Stop();
	m_hRefineryWndRefineryProgress.Reset();
	m_hRefineryWndRefineryProgress.Start();
	PlaySound("Itemsound2.smelting.smelting_loding");
	m_DragBox1.ShowWindow();
	m_DragBox2.ShowWindow();
	DwarfPlayAnimation();
	return;
}

function SetStateResult()
{
	MakeShakeTween();
	m_DragBoxResult.ShowWindow();
	ItemListWindow.HideWindow();
	m_DragBox1.HideWindow();
	m_DragBox2.HideWindow();
	return;
}

function SetStateTargetOnly()
{
	return;
}

function UpdateStateNewResult()
{
	local string strDesc1, strDesc2, strDesc3, descAll;
	local int ColorR, ColorG, ColorB, Quality, RefineryOp1, RefineryOp2, RefineryOp3;
	local ItemInfo item;

	if(!IsSupportedResultChoice())
	{
		return;
	}
	if(!GetItemInfoTarget(item))
	{
		return;
	}
	RefineryOp1 = newResultInfo.newItemOption1;
	RefineryOp2 = newResultInfo.newItemOption2;
	RefineryOp3 = newResultInfo.newItemOption3;
	descAll = "";
	if(((RefineryOp1 != 0) || (RefineryOp2 != 0)))
	{
		Quality = GetRefineryGradeQuality(RefineryOp1, RefineryOp2, RefineryOp3);
		SetNewQuality(Quality);
		ToolTip(GetScript("Tooltip")).GetRefineryColor(Quality, ColorR, ColorG, ColorB);
		if((RefineryOp1 != 0))
		{
			strDesc1 = "";
			strDesc2 = "";
			strDesc3 = "";
			if(Class'NWindow.UIDATA_REFINERYOPTION'.static.GetOptionDescription(RefineryOp1, strDesc1, strDesc2, strDesc3))
			{
				AddDesc(strDesc1, descAll);
				AddDesc(strDesc2, descAll);
				AddDesc(strDesc3, descAll);
			}
		}
		if((RefineryOp2 != 0))
		{
			strDesc1 = "";
			strDesc2 = "";
			strDesc3 = "";
			if(Class'NWindow.UIDATA_REFINERYOPTION'.static.GetOptionDescription(RefineryOp2, strDesc1, strDesc2, strDesc3))
			{
				AddDesc(strDesc1, descAll);
				AddDesc(strDesc2, descAll);
				AddDesc(strDesc3, descAll);
			}
		}
		if((RefineryOp3 != 0))
		{
			strDesc1 = "";
			strDesc2 = "";
			strDesc3 = "";
			if(Class'NWindow.UIDATA_REFINERYOPTION'.static.GetOptionDescription(RefineryOp3, strDesc1, strDesc2, strDesc3))
			{
				AddDesc(strDesc1, descAll);
				AddDesc(strDesc2, descAll);
				AddDesc(strDesc3, descAll);
			}
		}
		newTxtOptions.SetTextColor(GetColor(ColorR, ColorG, ColorB, 255));
		newTxtOptions.SetText(descAll);
		if((descAll != ""))
		{
			newOptionGradeTex.ShowWindow();
		}
		if((GetRefineryEffectLevel(RefineryOp1, RefineryOp2, RefineryOp3) != 0))
		{
			newSpecialOpEffectTex.ShowWindow();
		}
		else
		{
			newSpecialOpEffectTex.HideWindow();
		}
		newOptionBtn.SetEnable(true);
		newOptionBlindWnd.HideWindow();
	}
	else
	{
		newOptionBtn.SetEnable(false);
		newOptionBlindWnd.ShowWindow();
		ClearNewRefineryText();
		newOptionGradeTex.HideWindow();
	}
	return;
}

function PlayNewOptionApplyEffect(bool isPlay)
{
	if(!IsSupportedResultChoice())
	{
		return;
	}
	if(isPlay)
	{
		newOptionApplyAnimTex.Stop();
		newOptionApplyAnimTex.SetLoopCount(1);
		newOptionApplyAnimTex.ShowWindow();
		newOptionApplyAnimTex.Play();
	}
	else
	{
		newOptionApplyAnimTex.Stop();
		newOptionApplyAnimTex.HideWindow();
	}
	return;
}

function SetDialogModal(bool isModal)
{
	if(!IsSupportedResultChoice())
	{
		return;
	}
	if((isModal == true))
	{
		newDisableWnd.ShowWindow();
	}
	else
	{
		newDisableWnd.HideWindow();
	}
	return;
}

function SetNewResultInfo(bool confirmed, int itemSId, int newOption1, int newOption2, int newOption3)
{
	newResultInfo.isConfirm = confirmed;
	newResultInfo.targetItemSId = itemSId;
	newResultInfo.newItemOption1 = newOption1;
	newResultInfo.newItemOption2 = newOption2;
	newResultInfo.newItemOption3 = newOption3;
	return;
}

function ShowResultChoiceDialog()
{
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemString(14060));
	Class'Interface.DialogBox'.static.Inst().AnchorToOwner(0, 0);
	Class'Interface.DialogBox'.static.Inst().DelegateOnOK = OnResultChoiceDialogConfirm;
	Class'Interface.DialogBox'.static.Inst().DelegateOnCancel = OnDialogHide;
	Class'Interface.DialogBox'.static.Inst().DelegateOnHide = OnDialogHide;
	Class'Interface.DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
	SetDialogModal(true);
	return;
}

function ShowCloseWndDialog()
{
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemString(14061));
	Class'Interface.DialogBox'.static.Inst().AnchorToOwner(0, 0);
	Class'Interface.DialogBox'.static.Inst().DelegateOnOK = OnCloseWndDialogConfirm;
	Class'Interface.DialogBox'.static.Inst().DelegateOnCancel = OnDialogHide;
	Class'Interface.DialogBox'.static.Inst().DelegateOnHide = OnDialogHide;
	Class'Interface.DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
	SetDialogModal(true);
	return;
}

function ShowResetRefineryDialog()
{
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemString(14061));
	Class'Interface.DialogBox'.static.Inst().AnchorToOwner(0, 0);
	Class'Interface.DialogBox'.static.Inst().DelegateOnOK = OnResetRefieryDialogConfirm;
	Class'Interface.DialogBox'.static.Inst().DelegateOnCancel = OnDialogHide;
	Class'Interface.DialogBox'.static.Inst().DelegateOnHide = OnDialogHide;
	Class'Interface.DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
	SetDialogModal(true);
	return;
}

function bool isPossableInventoryShow()
{
	if((((getInstanceUIData().GetIsLiveServer() && Me.IsShowWindow()) && (newResultInfo.isConfirm == false)) && ((newResultInfo.newItemOption1 != 0) || (newResultInfo.newItemOption2 != 0))))
	{
		return false;
	}
	return true;
}

function setHideAndInventoryShow(bool bFlag)
{
	bHideAndInventoryShow = bFlag;
	return;
}

function NewResultCheckAndCloseWnd()
{
	if(((newResultInfo.isConfirm == false) && ((newResultInfo.newItemOption1 != 0) || (newResultInfo.newItemOption2 != 0))))
	{
		ShowCloseWndDialog();
	}
	else
	{
		SetHideWindow();
	}
	return;
}

function NewResultCheckAndReset()
{
	if(((newResultInfo.isConfirm == false) && ((newResultInfo.newItemOption1 != 0) || (newResultInfo.newItemOption2 != 0))))
	{
		ShowResetRefineryDialog();
	}
	else
	{
		SetState(stone);
	}
	return;
}

function SetInstructionText()
{
	local int numMsg;
	local bool showSpecialOptionNotice;
	local string Msg;

	switch(CurrentState)
	{
		case stone:
			numMsg = 1958;
			break;
		case Target:
			numMsg = 1957;
			break;
		case READY:
			numMsg = 1984;
			if(IsSpecialOptionItem())
			{
				showSpecialOptionNotice = true;
			}
			break;
		case ing:
			numMsg = 13276;
			break;
		case Result:
			numMsg = 1962;
			if(IsSpecialOptionItem())
			{
				showSpecialOptionNotice = true;
			}
			break;
		default:
			break;
	}
	Msg = GetSystemMessage(numMsg);
	m_InstructionText.SetText(Msg);
	return;
}

function SetButtonSetting(optional bool bItemUpdated)
{
	SetRefineryBtnTexture(false);
	switch(CurrentState)
	{
		case stone:
			Me.KillTimer(90);
			btnReset.DisableWindow();
			m_RefineryBtn.DisableWindow();
			m_RefineryBtn.SetButtonName(1477);
			break;
		case Target:
			Me.KillTimer(90);
			btnReset.EnableWindow();
			m_RefineryBtn.DisableWindow();
			m_RefineryBtn.SetButtonName(1477);
			break;
		case READY:
			Me.KillTimer(90);
			btnReset.EnableWindow();
			if(canBuy())
			{
				m_RefineryBtn.EnableWindow();
			}
			else
			{
				m_RefineryBtn.DisableWindow();
			}
			m_RefineryBtn.SetButtonName(1477);
			break;
		case ing:
			Me.KillTimer(90);
			btnReset.DisableWindow();
			SetRefineryBtnTexture(true);
			m_RefineryBtn.EnableWindow();
			m_RefineryBtn.SetButtonName(141);
			break;
		case Result:
			if(bItemUpdated)
			{
				return;
			}
			Me.KillTimer(90);
			btnReset.EnableWindow();
			m_RefineryBtn.DisableWindow();
			Me.SetTimer(90, 500);
			m_RefineryBtn.SetButtonName(14172);
			break;
		default:
			break;
	}
	return;
}

function SetRefineryBtnTexture(bool isCancelTex)
{
	if(isCancelTex)
	{
		m_RefineryBtn.SetTexture("L2UI_NewTex.Button.SimpleBtnRed_DF", "L2UI_NewTex.Button.SimpleBtnRed_Over", "L2UI_NewTex.Button.SimpleBtnRed_Down");
	}
	else
	{
		m_RefineryBtn.SetTexture("L2UI_NewTex.Button.SimpleBtnGreen_DF", "L2UI_NewTex.Button.SimpleBtnGreen_Over", "L2UI_NewTex.Button.SimpleBtnGreen_Down");
	}
	return;
}

function SetHighLightsEmpty()
{
	local int i;

	i = 1;
	while((i < 3))
	{
		if((GetItemWindowHandleByIndex(i).GetItemNum() > 0))
		{
			GetHighLightSelectedByIndex(i).ShowWindow();
		}
		else
		{
			GetHighLightSelectedByIndex(i).HideWindow();
		}
		GetHighLightByIndex(i).HideWindow();
		i++;
	}
	switch(CurrentState)
	{
		case stone:
			GetHighLightByIndex(1).ShowWindow();
			break;
		case Target:
			GetHighLightByIndex(2).ShowWindow();
			break;
		default:
			break;
	}
	return;
}

function bool IsSpecialOptionItem()
{
	local ItemInfo itemInfoTarget;

	if(GetItemInfoTarget(itemInfoTarget))
	{
		if((itemInfoTarget.RefineryOp3 > 0))
		{
			return true;
		}
	}
	return false;
}

function RequestRefine()
{
	local ItemInfo itemInfoStone, itemInfoTarget;

	if(!GetItemInfoStone(itemInfoStone))
	{
		return;
	}
	if(!GetItemInfoTarget(itemInfoTarget))
	{
		return;
	}
	m_RefineryBtn.DisableWindow();
	Rq_C_EX_TRY_TO_MAKE_VARIATION(itemInfoTarget.Id.ServerID, itemInfoStone.Id.ServerID, eventInfo.isEventOn);
	return;
}

function HandleClickBtnRefine()
{
	local ItemInfo iInfoStone;

	switch(CurrentState)
	{
		case READY:
			SetState(ing);
			break;
		case ing:
			SetCancel();
			break;
		case Result:
			if(!GetItemInfoStone(iInfoStone))
			{
				SetState(stone);
			}
			if((iInfoStone.ItemNum == INT64(0)))
			{
				SetState(stone);
			}
			else
			{
				SetState(ing);
			}
			break;
		default:
			break;
	}
	return;
}

function OnClickbtnClose()
{
	SetHideWindow();
	return;
}

function SetHideWindow()
{
	Me.HideWindow();
	PlaySound("Itemsound2.smelting.smelting_dragout");
	if(bHideAndInventoryShow)
	{
		ExecuteEvent(2631);
	}
	return;
}

function SetCancel()
{
	SetDwaft();
	SetState(READY);
	return;
}

function UpdateHotKeyControls()
{
	if((_IsFocused == true))
	{
		if((int(CurrentState) == 3))
		{
			m_ShortcutIcon_ESC.ShowWindow();
			m_ShortcutIcon_Enter.HideWindow();
		}
		else if(((int(CurrentState) == 2) || (int(CurrentState) == 4)))
		{
			m_ShortcutIcon_ESC.HideWindow();
			m_ShortcutIcon_Enter.ShowWindow();
		}
		else
		{
			m_ShortcutIcon_Enter.HideWindow();
			m_ShortcutIcon_ESC.HideWindow();
		}
	}
	else
	{
		m_ShortcutIcon_Enter.HideWindow();
		m_ShortcutIcon_ESC.HideWindow();
	}
	return;
}

event OnNewOptionBtnClicked()
{
	ShowResultChoiceDialog();
	return;
}

event OnResultChoiceDialogConfirm()
{
	if(((newResultInfo.isConfirm == false) && ((newResultInfo.newItemOption1 != 0) || (newResultInfo.newItemOption2 != 0))))
	{
		newOptionBtn.SetEnable(false);
		Rq_C_EX_APPLY_VARIATION_OPTION(newResultInfo.targetItemSId, newResultInfo.newItemOption1, newResultInfo.newItemOption2, newResultInfo.newItemOption3);
	}
	return;
}

event OnCloseWndDialogConfirm()
{
	SetHideWindow();
	return;
}

event OnResetRefieryDialogConfirm()
{
	SetState(stone);
	return;
}

event OnDialogHide()
{
	SetDialogModal(false);
	Me.SetFocus();
	return;
}

event OnReceivedCloseUI()
{
	if((int(CurrentState) == 3))
	{
		SetCancel();
	}
	else if(IsSupportedResultChoice())
	{
		NewResultCheckAndCloseWnd();
	}
	return;
}

function ClearRefineryText()
{
	SetQuality(-1);
	txtOptions.SetText("");
	return;
}

function ClearNewRefineryText()
{
	if(!IsSupportedResultChoice())
	{
		return;
	}
	SetNewQuality(-1);
	newTxtOptions.SetText("");
	return;
}

function AddRefineryText()
{
	local string strDesc1, strDesc2, strDesc3, descAll;
	local int ColorR, ColorG, ColorB, Quality;
	local ItemInfo item;

	if(!GetItemInfoTarget(item))
	{
		return;
	}
	descAll = "";
	if(((item.RefineryOp1 != 0) || (item.RefineryOp2 != 0)))
	{
		Quality = GetRefineryGradeQuality(item.RefineryOp1, item.RefineryOp2, item.RefineryOp3);
		SetQuality(Quality);
		ToolTip(GetScript("Tooltip")).GetRefineryColor(Quality, ColorR, ColorG, ColorB);
		if((item.RefineryOp1 != 0))
		{
			strDesc1 = "";
			strDesc2 = "";
			strDesc3 = "";
			if(Class'NWindow.UIDATA_REFINERYOPTION'.static.GetOptionDescription(item.RefineryOp1, strDesc1, strDesc2, strDesc3))
			{
				AddDesc(strDesc1, descAll);
				AddDesc(strDesc2, descAll);
				AddDesc(strDesc3, descAll);
			}
		}
		if((item.RefineryOp2 != 0))
		{
			strDesc1 = "";
			strDesc2 = "";
			strDesc3 = "";
			if(Class'NWindow.UIDATA_REFINERYOPTION'.static.GetOptionDescription(item.RefineryOp2, strDesc1, strDesc2, strDesc3))
			{
				AddDesc(strDesc1, descAll);
				AddDesc(strDesc2, descAll);
				AddDesc(strDesc3, descAll);
			}
		}
		if((item.RefineryOp3 != 0))
		{
			strDesc1 = "";
			strDesc2 = "";
			strDesc3 = "";
			if(Class'NWindow.UIDATA_REFINERYOPTION'.static.GetOptionDescription(item.RefineryOp3, strDesc1, strDesc2, strDesc3))
			{
				AddDesc(strDesc1, descAll);
				AddDesc(strDesc2, descAll);
				AddDesc(strDesc3, descAll);
			}
		}
		txtOptions.SetTextColor(GetColor(ColorR, ColorG, ColorB, 255));
		txtOptions.SetText(descAll);
		if((descAll != ""))
		{
			optionGradeTexture.ShowWindow();
		}
		if((GetRefineryEffectLevel(item.RefineryOp1, item.RefineryOp2, item.RefineryOp3) != 0))
		{
			specialOpEffectTex.ShowWindow();
		}
		else
		{
			specialOpEffectTex.HideWindow();
		}
		emptyOptionText.HideWindow();
		if(IsSupportedResultChoice())
		{
			if((descAll != ""))
			{
				preOptionCheckTex.ShowWindow();
				optionBlindWnd.HideWindow();
			}
		}
	}
	else
	{
		optionGradeTexture.HideWindow();
		if(IsSupportedResultChoice())
		{
			preOptionCheckTex.HideWindow();
			optionBlindWnd.ShowWindow();
		}
	}
	return;
}

function SetQuality(int Quality)
{
	optionGradeTexture.SetTexture(GetGradeTextureByQuality(Quality));
	if((Quality <= 0))
	{
		optionGradeTexture.HideWindow();
	}
	else
	{
		optionGradeTexture.ShowWindow();
	}
	return;
}

function SetNewQuality(int Quality)
{
	if(!IsSupportedResultChoice())
	{
		return;
	}
	newOptionGradeTex.SetTexture(GetGradeTextureByQuality(Quality));
	if((Quality <= 0))
	{
		newOptionGradeTex.HideWindow();
	}
	else
	{
		newOptionGradeTex.ShowWindow();
	}
	return;
}

function string GetGradeTextureByQuality(int Quality)
{
	switch(Quality)
	{
		case 1:
			return "L2UI_EPIC.RefineryWnd.RefineryWnd_Frame_Yellow";
			break;
		case 2:
			return "L2UI_EPIC.RefineryWnd.RefineryWnd_Frame_Blue";
			break;
		case 3:
			return "L2UI_EPIC.RefineryWnd.RefineryWnd_Frame_purple";
			break;
		case 4:
			return "L2UI_EPIC.RefineryWnd.RefineryWnd_Frame_Red";
			break;
		default:
			return "L2UI_EPIC.RefineryWnd.RefineryWnd_Frame_Red";
			break;
	}
}

function ResetAnims()
{
	l2UITweenScript.StopTween(m_Windowname, 1);
	l2UITweenScript.StopTween(m_Windowname, 2);
	l2UITweenScript.StopShake(m_Windowname, 101);
	m_DragBox1.ShowWindow();
	m_DragBox1.SetAnchor((m_Windowname $ ".MainBg"), "CenterCenter", "CenterCenter", -78, 0);
	m_DragBox1.ClearAnchor();
	m_DragBox1.SetAlpha(255);
	m_DragBox2.ShowWindow();
	m_DragBox2.SetAnchor((m_Windowname $ ".MainBg"), "CenterCenter", "CenterCenter", 78, 0);
	m_DragBox2.ClearAnchor();
	m_DragBox2.SetAlpha(255);
	m_RefineAnim.HideWindow();
	m_RefineAnim.Stop();
	m_hRefineryWndRefineryProgress.SetPos(0);
	m_hRefineryWndRefineryProgress.Stop();
	m_ResultBoxItem.HideWindow();
	m_ResultAnimation1.HideWindow();
	m_ResultAnimation2.HideWindow();
	m_ResultAnimation3.HideWindow();
	m_ResultAnimation4.HideWindow();
	return;
}

function MakeProgressTween()
{
	local L2UITween.TweenObject tweenObj0;

	ResetAnims();
	tweenObj0.Owner = m_Windowname;
	tweenObj0.Id = 1;
	tweenObj0.Target = m_DragBox1;
	tweenObj0.Duration = 1000.0000000;
	tweenObj0.MoveX = 78.0000000;
	tweenObj0.ease = IN_STRONG;
	l2UITweenScript.AddTweenObject(tweenObj0);
	tweenObj0.Id = 2;
	tweenObj0.Target = m_DragBox2;
	tweenObj0.MoveX = -tweenObj0.MoveX;
	tweenObj0.ease = IN_STRONG;
	l2UITweenScript.AddTweenObject(tweenObj0);
	return;
}

function MakeTweenAlpha(WindowHandle targetWindow, int tweenID)
{
	local L2UITween.TweenObject tweenObj0;

	targetWindow.SetAlpha(0);
	tweenObj0.Owner = m_Windowname;
	tweenObj0.Id = tweenID;
	tweenObj0.Target = targetWindow;
	tweenObj0.Duration = 500.0000000;
	tweenObj0.Alpha = 255.0000000;
	tweenObj0.ease = OUT_STRONG;
	l2UITweenScript.AddTweenObject(tweenObj0);
	return;
}

function MakeShakeTween()
{
	local L2UITween.ShakeObject shakeObj;

	shakeObj.Owner = m_Windowname;
	shakeObj.Target = Me;
	shakeObj.Duration = 500.0000000;
	shakeObj.shakeSize = 4.0000000;
	shakeObj.Direction = small;
	shakeObj.Id = 101;
	l2UITweenScript.StartShakeObject(shakeObj);
	return;
}

function PlayResultQualityAnimation(int Grade)
{
	switch(Grade)
	{
		case 1:
			m_ResultAnimation1.ShowWindow();
			PlaySound("ItemSound2.smelting.smelting_finalB");
			m_ResultAnim1.Stop();
			m_ResultAnim1.Play();
			break;
		case 2:
			m_ResultAnimation2.ShowWindow();
			PlaySound("ItemSound2.smelting.smelting_finalC");
			m_ResultAnim2.Stop();
			m_ResultAnim2.Play();
			break;
		case 3:
			m_ResultAnimation3.ShowWindow();
			PlaySound("ItemSound2.smelting.smelting_finalD");
			m_ResultAnim3.Stop();
			m_ResultAnim3.Play();
			break;
		case 4:
			m_ResultAnimation4.ShowWindow();
			PlaySound("ItemSound2.smelting.smelting_finalD");
			m_ResultAnim4.Stop();
			m_ResultAnim4.Play();
			break;
		default:
			break;
	}
	return;
}

function SetDwaft()
{
	m_ObjectViewport.SetNPCInfo(19673);
	m_ObjectViewport.ShowNPC(0.1000000);
	m_ObjectViewport.SpawnNPC();
	m_ObjectViewport.ShowWindow();
	return;
}

function DwarfPlayAnimation()
{
	local int randNum;

	randNum = Rand(10);
	if((randNum < 2))
	{
		m_ObjectViewport.PlayAnimation(2);
	}
	else
	{
		m_ObjectViewport.PlayAnimation(1);
	}
	return;
}

function bool GetItemInfoStone(out ItemInfo iInfo)
{
	return GetItemInfoByIndex(1, iInfo);
}

function bool GetItemInfoTarget(out ItemInfo iInfo)
{
	return GetItemInfoByIndex(2, iInfo);
}

function bool GetItemInfoByIndex(int Index, out ItemInfo iInfo)
{
	return GetItemWindowHandleByIndex(Index).GetItem(0, iInfo);
}

function ResetRefineryEventInfo()
{
	eventInfo.isEventOn = false;
	eventInfo.itemCountPercent = 100;
	eventInfo.FeeAdenaPercent = 100;
	return;
}

function ItemWindowHandle GetItemWindowHandleByIndex(int Index)
{
	return GetItemWindowHandle((((m_Windowname $ ".ItemDragBox") $ string(Index)) $ "Wnd.ItemDragBox"));
}

function WindowHandle GetHighLightByIndex(int Index)
{
	return GetWindowHandle((((m_Windowname $ ".ItemDragBox") $ string(Index)) $ "Wnd.DropHighlight"));
}

function WindowHandle GetHighLightSelectedByIndex(int Index)
{
	return GetWindowHandle((((m_Windowname $ ".ItemDragBox") $ string(Index)) $ "Wnd.SelectedItemHighlight"));
}

function HandleUpdateItemStone(optional array<ItemInfo> iInfo, optional int Index)
{
	local ItemInfo iInfoStone;

	iInfoStone = iInfo[0];
	if((iInfoStone.ItemNum == INT64(0)))
	{
		m_DragboxItem1.Clear();
		switch(CurrentState)
		{
			case Result:
				iObject.setId();
				break;
			default:
				SetState(stone);
				break;
		}
	}
	else
	{
		iInfoStone.bShowCount = true;
		m_DragboxItem1.SetItem(0, iInfoStone);
	}
	return;
}

function PeeItemUpdated(UIControlNeedItem Script)
{
	switch(CurrentState)
	{
		case ing:
			if(!canBuy())
			{
				SetState(READY);
			}
			break;
		default:
			SetButtonSetting(true);
			break;
	}
	return;
}

function bool canBuy()
{
	return (UIControlNeedItemScripts[0].canBuy() && UIControlNeedItemScripts[1].canBuy());
}

function bool IsSupportedResultChoice()
{
	if(getInstanceUIData().GetIsLiveServer())
	{
		return true;
	}
	return false;
}

function bool IsNewResultNotConfirm()
{
	if((((IsSupportedResultChoice() && Me.IsShowWindow()) && (newResultInfo.isConfirm == false)) && ((newResultInfo.newItemOption1 != 0) || (newResultInfo.newItemOption2 != 0))))
	{
		return true;
	}
	return false;
}

function AddDesc(string Desc, out string descAll)
{
	if((Desc == ""))
	{
		return;
	}
	if((descAll != ""))
	{
		descAll = ((descAll $ "\\n") $ Desc);
	}
	else
	{
		descAll = Desc;
	}
	return;
}

function DelOptionList()
{
	RefineryWndOptionScript.DelIds();
	return;
}

function SetOptionList()
{
	local ItemInfo iInfoStone, iInfoTarget;

	if(!GetItemInfoStone(iInfoStone))
	{
		DelOptionList();
		return;
	}
	if(!GetItemInfoTarget(iInfoTarget))
	{
		DelOptionList();
		return;
	}
	RefineryWndOptionScript.SetIDs(iInfoStone.Id.ClassID, iInfoTarget.Id.ClassID);
	return;
}

function _AddTargetItem(ItemInfo iInfo)
{
	targetItemInfo = iInfo;
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
	local int i, Len;
	local array<ItemInfo> iInfos;

	ItemList.Clear();
	Len = GetStonesFormInvenWithTargetItemInfo(iInfos);
	i = 0;
	while((i < Len))
	{
		ItemList.AddItem(iInfos[i]);
		i++;
	}
	m_DragBoxItem2.AddItem(targetItemInfo);
	return;
}

function ClearTargetItem()
{
	targetItemInfo.Id.ClassID = -1;
	targetItemInfo.Id.ServerID = -1;
	return;
}

function int GetStonesFormInvenWithTargetItemInfo(out array<ItemInfo> stones)
{
	local int Len, i, lenj, j;
	local array<ItemInfo> stoneItems, targetItems;

	Len = API_GetTargetItemListFromInven(stoneItems);
	i = 0;
	while((i < Len))
	{
		lenj = API_GetItemListFromInven(stoneItems[i].Id.ClassID, targetItems);
		j = 0;
		while((j < lenj))
		{
			if((targetItems[j].Id == targetItemInfo.Id))
			{
				stones[stones.Length] = stoneItems[i];
				j++;
				continue;
			}
			j++;
		}
		i++;
	}
	return stones.Length;
}
