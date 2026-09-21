class ItemBlessWnd extends UICommonAPI
	dependson(UIPacket);

const TWEENID_SLOT1 = 0;
const TWEENID_SLOT2 = 1;
const SHAKEID_ME = 0;
const TIMEPROGRESS = 600;
const TIMEPROGRESSAUTO = 400;

enum typeState
{
	non,                            // 0
	READY,                          // 1
	Progress,                       // 2
	Result                          // 3
};

var WindowHandle Me;
var string m_Windowname;
var ItemBlessWndSub itemBlessWndSubScript;
var InventoryWnd inventoryWndScript;
var ItemWindowHandle MaterialSlot1_ItemWnd;
var ItemWindowHandle MaterialSlot2_ItemWnd;
var ItemWindowHandle ArtifactItemSlot_ItemWnd;
var TextBoxHandle EnchantNotice_Txt;
var ButtonHandle Enchant_Btn;
var ButtonHandle Enchant_BtnAuto;
var ButtonHandle confirm_Btn;
var ButtonHandle Probability_Btn;
var WindowHandle MaterialSlot1Wnd;
var WindowHandle MaterialSlot2Wnd;
var Rect Slot1Rect;
var Rect Slot2Rect;
var AnimTextureHandle EnchantProgressAnim;
var ProgressCtrlHandle EnchantProgress;
var TextureHandle MaterialSlot2_DropHighlight_Texure;
var EffectViewportWndHandle EnchantEffectViewport;
var ItemInfo itemInfoTarget;
var bool bSuccess;
var L2UITween l2UITweenScript;
var TextBoxHandle scrollItemNum;
var CharacterViewportWindowHandle itemPeelEffect;
var bool IsAutoBlessing;
var bool IsAutoBlessStop;
var typeState CurrentState;
var bool bRequestBless;

function InitViewport()
{
	itemPeelEffect.SetNPCInfo(19671);
	return;
}

function Initialize()
{
	local Rect RectMe;

	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
	l2UITweenScript = L2UITween(GetScript("L2UITween"));
	itemBlessWndSubScript = ItemBlessWndSub(GetScript("ItemBlessWndSub"));
	MaterialSlot1_ItemWnd = GetItemWindowHandle((m_Windowname $ ".MaterialSlot1Wnd.MaterialSlot1_ItemWnd"));
	MaterialSlot2_ItemWnd = GetItemWindowHandle((m_Windowname $ ".MaterialSlot2Wnd.MaterialSlot2_ItemWnd"));
	ArtifactItemSlot_ItemWnd = GetItemWindowHandle((m_Windowname $ ".ArtifactItemSlot_ItemWnd"));
	MaterialSlot1Wnd = GetWindowHandle((m_Windowname $ ".MaterialSlot1Wnd"));
	MaterialSlot2Wnd = GetWindowHandle((m_Windowname $ ".MaterialSlot2Wnd"));
	EnchantNotice_Txt = GetTextBoxHandle((m_Windowname $ ".EnchantNotice_Txt"));
	scrollItemNum = GetTextBoxHandle((m_Windowname $ ".ScrollItemNum"));
	Enchant_Btn = GetButtonHandle((m_Windowname $ ".Enchant_Btn"));
	Enchant_BtnAuto = GetButtonHandle((m_Windowname $ ".Enchant_BtnAuto"));
	confirm_Btn = GetButtonHandle((m_Windowname $ ".Confirm_Btn"));
	Probability_Btn = GetButtonHandle((m_Windowname $ ".Probability_Btn"));
	EnchantProgressAnim = GetAnimTextureHandle((m_Windowname $ ".EnchantProgressAnim"));
	EnchantProgress = GetProgressCtrlHandle((m_Windowname $ ".EnchantProgress"));
	MaterialSlot2_DropHighlight_Texure = GetTextureHandle((m_Windowname $ ".MaterialSlot2Wnd.MaterialSlot2_DropHighlight_Texure"));
	EnchantEffectViewport = GetEffectViewportWndHandle((m_Windowname $ ".EnchantEffectViewport"));
	itemPeelEffect = GetCharacterViewportWindowHandle((m_Windowname $ ".ChEffectViewport"));
	RectMe = Me.GetRect();
	Slot1Rect = MaterialSlot1Wnd.GetRect();
	Slot1Rect.nX = (Slot1Rect.nX - RectMe.nX);
	Slot1Rect.nY = (Slot1Rect.nY - RectMe.nY);
	Slot2Rect = MaterialSlot2Wnd.GetRect();
	Slot2Rect.nX = (Slot2Rect.nX - RectMe.nX);
	Slot2Rect.nY = (Slot2Rect.nY - RectMe.nY);
	GetMeRichListCtrl("Disable_Wnd.ItemBlessInfoWnd.Probability_RichListCtrl").SetSelectedSelTooltip(false);
	GetMeRichListCtrl("Disable_Wnd.ItemBlessInfoWnd.Probability_RichListCtrl").SetAppearTooltipAtMouseX(true);
	MakeItemListener();
	InitViewport();
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(10230);
	RegisterEvent((100000 + 882));
	RegisterEvent((100000 + 884));
	RegisterEvent((100000 + 1202));
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 10230:
			bRequestBless = false;
			break;
		case (100000 + 882):
			Handle_S_EX_OPEN_BLESS_OPTION_SCROLL();
			break;
		case (100000 + 884):
			Handle_S_EX_BLESS_OPTION_ENCHANT();
			break;
		case (100000 + 1202):
			Handle_S_EX_BLESS_OPTION_PROB_LIST();
			break;
		default:
			break;
	}
	return;
}

event OnCallUCFunction(string funcName, string param)
{
	switch(funcName)
	{
		case "tweenEnd":
			if((param == "1"))
			{
				if(IsAutoBlessing)
				{
					itemPeelEffect.ShowWindow();
					itemPeelEffect.SpawnEffect("LineageEffect2.ui_openbox");
				}
				API_C_EX_BLESS_OPTION_ENCHANT(GetItemInfo0().Id.ClassID, GetItemInfo1().Id.ServerID);
			}
			break;
		default:
			break;
	}
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

event OnHide()
{
	IsAutoBlessing = false;
	IsAutoBlessStop = false;
	if((DialogIsMine() && Class'Interface.DialogBox'.static.Inst().m_hOwnerWnd.IsShowWindow()))
	{
		DialogHide();
	}
	return;
}

event OnDropItem(string strTarget, ItemInfo Info, int X, int Y)
{
	if((Info.DragSrcName != "ItemBlessWndSubWnd_Item1"))
	{
		return;
	}
	SetItemInfo(Info);
	return;
}

function SetItemInfo(ItemInfo iInfo)
{
	local ItemInfo emptyInfo;

	itemInfoTarget = iInfo;
	MakeShakeWeekMaterialSlot2Wnd();
	MaterialSlot2_ItemWnd.Clear();
	MaterialSlot2_ItemWnd.AddItem(itemInfoTarget);
	PlaySound("ItemSound2.smelting.Smelting_dragin");
	if(!IsEmptyScroll())
	{
		SetState(READY);
	}
	itemInfoTarget = emptyInfo;
	return;
}

event OnShow()
{
	if(IsPlayerOnWorldRaidServer())
	{
		AddSystemMessage(4047);
		Me.HideWindow();
		return;
	}
	GetMeWindow("Disable_Wnd").HideWindow();
	GetMeWindow("Disable_Wnd.ItemBlessInfoWnd").HideWindow();
	itemPeelEffect.SpawnNPC();
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	SetState(non);
	itemBlessWndSubScript.Me.ShowWindow();
	itemBlessWndSubScript.refresh();
	Me.SetFocus();
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "Enchant_Btn":
			IsAutoBlessing = false;
			HandleNext();
			break;
		case "Enchant_BtnAuto":
			HandleEnchant_BtnAuto();
			break;
		case "Confirm_Btn":
			HandleConfirm();
			break;
		case "Probability_Btn":
			if(GetMeWindow("Disable_Wnd.ItemBlessInfoWnd").IsShowWindow())
			{
				GetMeWindow("Disable_Wnd").HideWindow();
				GetMeWindow("Disable_Wnd.ItemBlessInfoWnd").HideWindow();
			}
			else
			{
				GetMeRichListCtrl("Disable_Wnd.ItemBlessInfoWnd.Probability_RichListCtrl").DeleteAllItem();
				API_C_EX_BLESS_OPTION_PROB_LIST(GetItemInfo0().Id.ClassID, GetItemInfo1().Id.ClassID);
				GetMeWindow("Disable_Wnd").ShowWindow();
				GetMeWindow("Disable_Wnd.ItemBlessInfoWnd").ShowWindow();
			}
			break;
		case "ProbabilityConfirm_Btn":
			GetMeWindow("Disable_Wnd").HideWindow();
			GetMeWindow("Disable_Wnd.ItemBlessInfoWnd").HideWindow();
			break;
		default:
			break;
	}
	return;
}

function HandleShowDialogAuto()
{
	local ItemInfo iInfo;

	iInfo = GetItemInfo0();
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, MakeFullSystemMsg(GetSystemMessage(13788), iInfo.Name, MakeCostStringINT64(iInfo.ItemNum)));
	Class'Interface.DialogBox'.static.Inst().AnchorToOwner(0, 170);
	Class'Interface.DialogBox'.static.Inst().DelegateOnCancel = DialogResultCancel;
	Class'Interface.DialogBox'.static.Inst().DelegateOnOK = DialogResultOKAuto;
	Class'Interface.DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
	itemBlessWndSubScript.m_hOwnerWnd.HideWindow();
	Probability_Btn.DisableWindow();
	return;
}

function DialogResultOKAuto()
{
	itemBlessWndSubScript.m_hOwnerWnd.ShowWindow();
	IsAutoBlessing = true;
	scrollItemNum.SetText(((GetSystemString(5027) @ ":") @ MakeCostStringINT64(GetItemInfo0().ItemNum)));
	scrollItemNum.ShowWindow();
	HandleNext();
	return;
}

function DialogResultCancel()
{
	itemBlessWndSubScript.m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetFocus();
	IsAutoBlessing = false;
	Probability_Btn.EnableWindow();
	return;
}

function HandleEnchant_BtnAuto()
{
	Debug((((("HandleEnchant_BtnAuto" @ string(IsAutoBlessStop)) @ string(IsAutoBlessing)) @ string(bRequestBless)) @ string(CurrentState)));
	if(IsAutoBlessStop)
	{
		return;
	}
	if(bRequestBless)
	{
		IsAutoBlessStop = true;
		return;
	}
	if((int(CurrentState) == 3))
	{
		HandleNextOnResult();
		return;
	}
	if((int(CurrentState) == 2))
	{
		SetState(READY);
		return;
	}
	HandleShowDialogAuto();
	return;
}

function API_C_EX_BLESS_OPTION_ENCHANT(int scrollClassID, int targetSID)
{
	local array<byte> stream;
	local UIPacket._C_EX_BLESS_OPTION_ENCHANT packet;

	bRequestBless = true;
	packet.nScrollClassID = scrollClassID;
	packet.nItemServerId = targetSID;
	Debug((("API_C_EX_BLESS_OPTION_ENCHANT" @ string(scrollClassID)) @ string(targetSID)));
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_BLESS_OPTION_ENCHANT(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(660, stream);
	return;
}

function API_C_EX_BLESS_OPTION_PROB_LIST(int nScrollClassID, int nItemClassID)
{
	local array<byte> stream;
	local UIPacket._C_EX_BLESS_OPTION_PROB_LIST packet;

	packet.nScrollClassID = nScrollClassID;
	packet.nItemClassID = nItemClassID;
	Debug((("API_C_EX_BLESS_OPTION_PROB_LIST" @ string(nScrollClassID)) @ string(nItemClassID)));
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_BLESS_OPTION_PROB_LIST(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(925, stream);
	return;
}

function bool API_GetEnchantBlessScrollData(int ClassID, out EnchantBlessScrollUIData o_data)
{
	return Class'NWindow.UIDATA_ITEM'.static.GetEnchantBlessScrollData(ClassID, o_data);
}

function string getBlessEffectDesc(int nClassID, int nID)
{
	local int i;
	local BlessOptionUIData optionList;

	Class'NWindow.UIDATA_ITEM'.static.GetBlessOptionData(nClassID, optionList);
	i = 0;
	while((i < optionList.BaseEffects.Length))
	{
		if((nID == optionList.BaseEffects[i].Id))
		{
			return optionList.BaseEffects[i].OptionDesc;
		}
		i++;
	}
	return "";
}

function Handle_S_EX_BLESS_OPTION_PROB_LIST()
{
	local UIPacket._S_EX_BLESS_OPTION_PROB_LIST packet;
	local int i;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_BLESS_OPTION_PROB_LIST(packet))
	{
		return;
	}
	Debug((((("Handle_S_EX_BLESS_OPTION_PROB_LIST" @ string(packet.nScrollClassID)) @ string(packet.nItemClassID)) @ string(packet.optionProbList.Length)) @ string(packet.shapeProbList.Length)));
	GetMeRichListCtrl("Disable_Wnd.ItemBlessInfoWnd.Probability_RichListCtrl").DeleteAllItem();
	if((packet.optionProbList.Length > 0))
	{
		GetMeRichListCtrl("Disable_Wnd.ItemBlessInfoWnd.Probability_RichListCtrl").InsertRecord(makeTitleListItem(GetSystemString(14934), ""));
		i = 0;
		while((i < packet.optionProbList.Length))
		{
			GetMeRichListCtrl("Disable_Wnd.ItemBlessInfoWnd.Probability_RichListCtrl").InsertRecord(makeRecordProbability(getBlessEffectDesc(packet.nItemClassID, packet.optionProbList[i].nID), Class'Interface.L2Util'.static.Inst().MakeDecimalPointString(string(packet.optionProbList[i].nProb), 5, true, true)));
			i++;
		}
	}
	if((packet.shapeProbList.Length > 0))
	{
		GetMeRichListCtrl("Disable_Wnd.ItemBlessInfoWnd.Probability_RichListCtrl").InsertRecord(makeTitleListItem(GetSystemString(14935), ""));
		i = 0;
		while((i < packet.shapeProbList.Length))
		{
			GetMeRichListCtrl("Disable_Wnd.ItemBlessInfoWnd.Probability_RichListCtrl").InsertRecord(makeRecordProbability(GetItemNameAllByClassID(packet.shapeProbList[i].nID), Class'Interface.L2Util'.static.Inst().MakeDecimalPointString(string(packet.shapeProbList[i].nProb), 5, true, true)));
			i++;
		}
	}
	return;
}

function Handle_S_EX_OPEN_BLESS_OPTION_SCROLL()
{
	local ItemInfo tItemInfo;
	local UIPacket._S_EX_OPEN_BLESS_OPTION_SCROLL packet;
	local EnchantBlessScrollUIData blessScrollUIData;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_OPEN_BLESS_OPTION_SCROLL(packet))
	{
		return;
	}
	if(FindItem(packet.nScrollClassID, tItemInfo))
	{
		Debug(((("Handle_S_EX_OPEN_BLESS_OPTION_SCROLL" @ string(packet.nScrollClassID)) @ string(blessScrollUIData.EnchantableGroupIDs.Length)) @ string(packet.nProb)));
		if(!API_GetEnchantBlessScrollData(packet.nScrollClassID, blessScrollUIData))
		{
			return;
		}
		tItemInfo.bShowCount = true;
		MaterialSlot1_ItemWnd.Clear();
		MaterialSlot1_ItemWnd.AddItem(tItemInfo);
		PlaySound("ItemSound2.smelting.Smelting_dragin");
		GetProbability_Txt().SetText(((GetSystemString(13938) $ ":") @ Class'Interface.L2Util'.static.Inst().MakeDecimalPointString(string(packet.nProb), 5, true, true)));
		GetMeTextBox("Disable_Wnd.ItemBlessInfoWnd.Probability_Txt").SetText(((GetSystemString(13938) $ ":") @ Class'Interface.L2Util'.static.Inst().MakeDecimalPointString(string(packet.nProb), 5, true, true)));
		itemBlessWndSubScript.SetGroupIDs(blessScrollUIData.EnchantableGroupIDs);
		if(Me.IsShowWindow())
		{
			OnShow();
		}
		else
		{
			Me.ShowWindow();
		}
	}
	return;
}

function Handle_S_EX_BLESS_OPTION_ENCHANT()
{
	local UIPacket._S_EX_BLESS_OPTION_ENCHANT packet;
	local string soundString;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_BLESS_OPTION_ENCHANT(packet))
	{
		return;
	}
	bSuccess = (packet.cResult == 1);
	bRequestBless = false;
	switch(packet.cResult)
	{
		case 0:
			soundString = "ItemSound3.enchant_fail";
			break;
		case 1:
			soundString = "ItemSound3.enchant_success";
			break;
		case 2:
			AddSystemMessage(13277);
			Me.HideWindow();
			return;
		default:
			break;
	}
	PlaySound(soundString);
	SetState(Result);
	return;
}

function HandleNext()
{
	switch(CurrentState)
	{
		case non:
			SetState(READY);
			break;
		case READY:
			SetState(Progress);
			break;
		case Progress:
			SetState(READY);
			break;
		case Result:
			HandleNextOnResult();
			break;
		default:
			break;
	}
	return;
}

function HandleNextOnResult()
{
	local ItemInfo itemTarget, itemResult, scrollItem;

	scrollItem = GetItemInfo0();
	itemTarget = GetItemInfo1();
	itemResult = GetItemInfoResult();
	Debug(((string(scrollItem.Id.ClassID) @ string(itemTarget.Id.ClassID)) @ string(itemResult.Id.ClassID)));
	if(bSuccess)
	{
		SetState(non);
	}
	else if(IsEmptyScroll())
	{
		SetState(non);
	}
	else
	{
		SetState(READY);
	}
	return;
}

function HandleExit()
{
	if(GetMeWindow("Disable_Wnd.ItemBlessInfoWnd").IsShowWindow())
	{
		GetMeWindow("Disable_Wnd").HideWindow();
		GetMeWindow("Disable_Wnd.ItemBlessInfoWnd").HideWindow();
	}
	else if(IsAutoBlessing)
	{
		HandleEnchant_BtnAuto();
	}
	else
	{
		switch(CurrentState)
		{
			case Progress:
				SetState(READY);
				break;
			default:
				MeHideWindow();
				break;
		}
	}
	return;
}

function MeHideWindow()
{
	SetState(non);
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
	return;
}

function HandleConfirm()
{
	confirm_Btn.HideWindow();
	HandleNextOnResult();
	return;
}

function bool IsEmptyScroll()
{
	return (GetItemInfo0().ItemNum <= INT64(0));
}

function bool IsEmptyTarget()
{
	return (GetItemInfo1().ItemNum <= INT64(0));
}

function SetState(typeState State)
{
	switch(State)
	{
		case non:
			SetStateNon();
			break;
		case READY:
			SetStateReady();
			break;
		case Progress:
			setStateProgress();
			break;
		case Result:
			setResult();
			break;
		default:
			break;
	}
	CurrentState = State;
	itemBlessWndSubScript.SetState();
	SetHighLight();
	SetEnchantNotice();
	SetEnchantBtn();
	return;
}

function SetStateNon()
{
	l2UITweenScript.StopTween(m_Windowname, 0);
	l2UITweenScript.StopTween(m_Windowname, 1);
	l2UITweenScript.StopShake(m_Windowname, 0);
	MaterialSlot2_ItemWnd.Clear();
	ArtifactItemSlot_ItemWnd.Clear();
	MaterialSlot1Wnd.ShowWindow();
	MaterialSlot2Wnd.ShowWindow();
	MaterialSlot1Wnd.MoveC(Slot1Rect.nX, Slot1Rect.nY);
	MaterialSlot2Wnd.MoveC(Slot2Rect.nX, Slot2Rect.nY);
	MaterialSlot2Wnd.SetAlpha(255);
	EnchantProgress.Stop();
	EnchantProgress.SetPos(0);
	EnchantProgressAnim.HideWindow();
	EnchantProgressAnim.Stop();
	scrollItemNum.HideWindow();
	Probability_Btn.DisableWindow();
	GetMeTextBox("Instruction_Txt").SetText("");
	IsAutoBlessing = false;
	return;
}

function SetStateReady()
{
	local BlessOptionUIData optionList;

	ArtifactItemSlot_ItemWnd.Clear();
	EnchantProgress.SetPos(0);
	EnchantProgress.Reset();
	EnchantProgress.Stop();
	EnchantProgressAnim.HideWindow();
	EnchantProgressAnim.Stop();
	l2UITweenScript.StopTween(m_Windowname, 0);
	l2UITweenScript.StopTween(m_Windowname, 1);
	l2UITweenScript.StopShake(m_Windowname, 0);
	MaterialSlot1Wnd.ShowWindow();
	MaterialSlot2Wnd.ShowWindow();
	MaterialSlot1Wnd.MoveC(Slot1Rect.nX, Slot1Rect.nY);
	MaterialSlot2Wnd.MoveC(Slot2Rect.nX, Slot2Rect.nY);
	scrollItemNum.HideWindow();
	Probability_Btn.EnableWindow();
	Class'NWindow.UIDATA_ITEM'.static.GetBlessOptionData(itemInfoTarget.Id.ClassID, optionList);
	Debug(("optionList.type" @ string(optionList.Type)));
	if(itemInfoTarget.IsBlessedItem)
	{
		GetMeTextBox("Instruction_Txt").SetText(GetSystemString(14936));
	}
	else
	{
		GetMeTextBox("Instruction_Txt").SetText(GetSystemString(13390));
	}
	IsAutoBlessing = false;
	return;
}

function setStateProgress()
{
	PlaySound("ItemSound3.enchant_process");
	MaterialSlot2Wnd.SetAlpha(255);
	Debug(("SetStateProgress" @ string(IsAutoBlessing)));
	EnchantProgressAnim.SetLoopCount(1);
	if(IsAutoBlessing)
	{
		EnchantProgress.SetProgressTime((400 - 100));
		EnchantProgressAnim.HideWindow();
	}
	else
	{
		EnchantProgress.SetProgressTime((600 - 100));
		EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Loading_01");
		EnchantProgressAnim.Stop();
		EnchantProgressAnim.Play();
		EnchantProgressAnim.ShowWindow();
	}
	EnchantProgress.Start();
	MakeProgressTween();
	return;
}

function SetRetryEnchantAuto()
{
	l2UITweenScript.StopTween(m_Windowname, 0);
	l2UITweenScript.StopTween(m_Windowname, 1);
	l2UITweenScript.StopShake(m_Windowname, 0);
	MaterialSlot1Wnd.MoveC(Slot1Rect.nX, Slot1Rect.nY);
	MaterialSlot2Wnd.MoveC(Slot2Rect.nX, Slot2Rect.nY);
	EnchantProgress.SetPos(0);
	EnchantProgress.Reset();
	EnchantProgress.Stop();
	EnchantProgress.Start();
	MakeProgressTween();
	return;
}

function ResetScrollNum()
{
	local ItemInfo scrolliInfo;

	scrolliInfo = GetItemInfo0();
	scrolliInfo.ItemNum = (scrolliInfo.ItemNum - INT64(1));
	scrollItemNum.SetText(((GetSystemString(5027) @ ":") @ MakeCostStringINT64(scrolliInfo.ItemNum)));
	MaterialSlot1_ItemWnd.SetItem(0, scrolliInfo);
	return;
}

function setResult()
{
	local ItemInfo resultItem;

	Class'NWindow.UIDATA_INVENTORY'.static.FindItem(GetItemInfo1().Id.ServerID, resultItem);
	if((IsAutoBlessing || IsAutoBlessStop))
	{
		ResetScrollNum();
	}
	if(bSuccess)
	{
		confirm_Btn.ShowWindow();
		resultItem.IsBlessedItem = true;
		MakeShakeMe();
	}
	else if(((IsAutoBlessing && (GetItemInfo0().ItemNum > INT64(0))) && !IsAutoBlessStop))
	{
		SetRetryEnchantAuto();
		return;
	}
	if((GetItemInfo0().ItemNum == INT64(1)))
	{
	}
	IsAutoBlessStop = false;
	EnchantProgressAnim.HideWindow();
	ArtifactItemSlot_ItemWnd.Clear();
	ArtifactItemSlot_ItemWnd.AddItem(resultItem);
	MaterialSlot1Wnd.HideWindow();
	MaterialSlot2Wnd.HideWindow();
	playEffectViewPort(bSuccess);
	return;
}

function SetEnchantNotice()
{
	local int stringNum;

	switch(CurrentState)
	{
		case non:
			if(IsEmptyScroll())
			{
				stringNum = 13389;
				itemBlessWndSubScript.DescriptionMsgWnd.ShowWindow();
			}
			else
			{
				stringNum = 13385;
			}
			break;
		case READY:
			stringNum = 13386;
			break;
		case Progress:
			stringNum = 13386;
			break;
		case Result:
			if(bSuccess)
			{
				stringNum = 13387;
			}
			else if(IsAutoBlessing)
			{
				stringNum = 14242;
			}
			else
			{
				stringNum = 13388;
			}
			break;
		default:
			break;
	}
	EnchantNotice_Txt.SetText(GetSystemString(stringNum));
	return;
}

function SetEnchantBtn()
{
	confirm_Btn.HideWindow();
	switch(CurrentState)
	{
		case non:
			Enchant_Btn.ShowWindow();
			Enchant_BtnAuto.ShowWindow();
			Enchant_Btn.DisableWindow();
			Enchant_BtnAuto.DisableWindow();
			Enchant_Btn.SetButtonName(13384);
			Enchant_BtnAuto.SetButtonName(14241);
			break;
		case READY:
			Enchant_Btn.ShowWindow();
			Enchant_BtnAuto.ShowWindow();
			Enchant_Btn.EnableWindow();
			Enchant_BtnAuto.EnableWindow();
			Enchant_Btn.SetButtonName(13384);
			Enchant_BtnAuto.SetButtonName(14241);
			break;
		case Progress:
			if(IsAutoBlessing)
			{
				Enchant_BtnAuto.EnableWindow();
				Enchant_BtnAuto.SetButtonName(141);
				Enchant_Btn.DisableWindow();
			}
			else
			{
				Enchant_Btn.EnableWindow();
				Enchant_Btn.SetButtonName(141);
				Enchant_BtnAuto.DisableWindow();
			}
			break;
		case Result:
			if(bSuccess)
			{
				confirm_Btn.ShowWindow();
				Enchant_Btn.DisableWindow();
				Enchant_BtnAuto.DisableWindow();
				Enchant_Btn.HideWindow();
				Enchant_BtnAuto.HideWindow();
			}
			else if(IsAutoBlessing)
			{
				Enchant_BtnAuto.EnableWindow();
				Enchant_BtnAuto.SetButtonName(141);
			}
			else
			{
				Enchant_Btn.EnableWindow();
				Enchant_Btn.SetButtonName(3135);
			}
			break;
		default:
			break;
	}
	return;
}

function bool FindItem(int ClassID, out ItemInfo oItemInfo)
{
	local array<ItemInfo> itemInfoArray;

	Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(ClassID, itemInfoArray);
	itemInfoArray[0].bShowCount = true;
	oItemInfo = itemInfoArray[0];
	return (itemInfoArray.Length > 0);
}

function ItemInfo GetItemInfo0()
{
	local ItemInfo iInfo;

	MaterialSlot1_ItemWnd.GetItem(0, iInfo);
	return iInfo;
}

function ItemInfo GetItemInfo1()
{
	local ItemInfo iInfo;

	MaterialSlot2_ItemWnd.GetItem(0, iInfo);
	return iInfo;
}

function ItemInfo GetItemInfoResult()
{
	local ItemInfo iInfo;

	ArtifactItemSlot_ItemWnd.GetItem(0, iInfo);
	return iInfo;
}

function TextBoxHandle GetProbability_Txt()
{
	return GetTextBoxHandle(((m_hOwnerWnd.GetWindowName() $ ".") $ "probability_Txt"));
}

function MakeProgressTween()
{
	local L2UITween.TweenObject tweenObj0;

	tweenObj0.Owner = m_Windowname;
	tweenObj0.Id = 0;
	tweenObj0.Target = MaterialSlot1Wnd;
	if(IsAutoBlessing)
	{
		tweenObj0.Duration = 400.0000000;
	}
	else
	{
		tweenObj0.Duration = 600.0000000;
	}
	tweenObj0.MoveX = 145.0000000;
	tweenObj0.ease = IN_STRONG;
	l2UITweenScript.AddTweenObject(tweenObj0);
	tweenObj0.Id = 1;
	tweenObj0.Target = MaterialSlot2Wnd;
	tweenObj0.MoveX = -tweenObj0.MoveX;
	tweenObj0.ease = IN_STRONG;
	l2UITweenScript.AddTweenObject(tweenObj0);
	return;
}

function MakeShakeMe()
{
	local L2UITween.ShakeObject shakeObj;

	shakeObj.Owner = m_Windowname;
	shakeObj.Target = Me;
	shakeObj.Duration = 600.0000000;
	shakeObj.shakeSize = 4.0000000;
	shakeObj.Direction = small;
	shakeObj.Id = 0;
	l2UITweenScript.StartShakeObject(shakeObj);
	return;
}

function MakeShakeWeekMaterialSlot2Wnd()
{
	local L2UITween.TweenObject tweenObj0;

	MaterialSlot2Wnd.SetAlpha(0);
	tweenObj0.Owner = m_Windowname;
	tweenObj0.Id = 19;
	tweenObj0.Target = MaterialSlot2Wnd;
	tweenObj0.Duration = 500.0000000;
	tweenObj0.Alpha = 255.0000000;
	tweenObj0.ease = OUT_STRONG;
	l2UITweenScript.AddTweenObject(tweenObj0);
	return;
}

function playEffectViewPort(bool bSuccess)
{
	local Vector offset;
	local string effectPath;

	if(bSuccess)
	{
		EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Success_00");
		EnchantProgressAnim.SetLoopCount(1);
		EnchantProgressAnim.Stop();
		EnchantProgressAnim.Play();
		EnchantProgressAnim.ShowWindow();
	}
	else
	{
		effectPath = "LineageEffect2.ui_upgrade_fail";
		offset.X = 13.0000000;
		offset.Y = -1.0000000;
		EnchantEffectViewport.SetScale(0.9000000);
		EnchantEffectViewport.SetCameraDistance(300.0000000);
		EnchantEffectViewport.SetOffset(offset);
		EnchantEffectViewport.SpawnEffect(effectPath);
	}
	return;
}

function SetHighLight()
{
	if((IsEmptyTarget() && !IsEmptyScroll()))
	{
		MaterialSlot2_DropHighlight_Texure.ShowWindow();
	}
	else
	{
		MaterialSlot2_DropHighlight_Texure.HideWindow();
	}
	return;
}

function MakeItemListener()
{
	local L2UIInventoryObject iObject;

	iObject = AddItemListener();
	iObject.DelegateOnCompare = CompareScroll;
	iObject.DelegateOnAddItem = UpdateItem;
	iObject.DelegateOnUpdateItem = UpdateItem;
	iObject.DelegateOnDeletedItem = DeletedItem;
	return;
}

function bool CompareScroll(optional ItemInfo iInfo, optional int Index)
{
	if(!Me.IsShowWindow())
	{
		return false;
	}
	return (iInfo.Id.ClassID == GetItemInfo0().Id.ClassID);
}

function DeletedItem(optional ItemInfo iInfo, optional int Index)
{
	MaterialSlot1_ItemWnd.Clear();
	if((int(CurrentState) != 3))
	{
		SetState(non);
	}
	return;
}

function UpdateItem(optional ItemInfo iInfo, optional int Index)
{
	MaterialSlot1_ItemWnd.Clear();
	iInfo.bShowCount = true;
	MaterialSlot1_ItemWnd.AddItem(iInfo);
	return;
}

function AddItem(optional ItemInfo iInfo)
{
	MaterialSlot1_ItemWnd.Clear();
	iInfo.bShowCount = true;
	MaterialSlot1_ItemWnd.AddItem(iInfo);
	return;
}

function RichListCtrlRowData makeRecordProbability(string Text, string percentStr)
{
	local RichListCtrlRowData rowData;

	Text = Substitute(Text, "\\n", " ", false);
	rowData.cellDataList.Length = 2;
	AddEllipsisString(rowData.cellDataList[0].drawitems, Text, 280, GTColor().White, false, true, 0, 0);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, percentStr, GTColor().White, false, 20, 0);
	return rowData;
}

function RichListCtrlRowData makeTitleListItem(string Str, string percentStr)
{
	local Color applyColor;
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = 2;
	rowData.sOverlayTex = "L2UI_EPIC.DethroneWnd.List_HeaderBg_Blue";
	applyColor = GTColor().BrightWhite;
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, Str, applyColor, false, 0, 0);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, percentStr, GTColor().White, false, 20, 0);
	rowData.OverlayTexU = 635;
	rowData.OverlayTexV = 26;
	return rowData;
}

function string GetOptionByOptionID(int option_id)
{
	local string strDesc1, strDesc2, strDesc3;

	if(Class'NWindow.UIDATA_REFINERYOPTION'.static.GetOptionDescription(option_id, strDesc1, strDesc2, strDesc3))
	{
		return strDesc1;
	}
	return "";
}

function OnReceivedCloseUI()
{
	HandleExit();
	return;
}
