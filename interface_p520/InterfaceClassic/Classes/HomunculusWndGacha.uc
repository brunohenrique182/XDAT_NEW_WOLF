class HomunculusWndGacha extends UICommonAPI
	dependson(UIPacket);

const TIMEID_CREATESTART = 9;
const TIME_CREATESTART = 3000;
const CARD_MAX = 4;

var WindowHandle Me;
var string m_Windowname;
var L2Util util;
var ButtonHandle btnMain0;
var TextureHandle Select_tex;
var EffectViewportWndHandle effectViewport;
var WindowHandle resultWnd;
var CharacterViewportWindowHandle m_ObjectViewport;
var TextBoxHandle txtResult0;
var EffectViewportWndHandle effectViewportResult;
var TextureHandle birthCircle_tex;
var AnimTextureHandle birthCircleInput_anitex;
var HomunculusWnd HomunculusWndScript;
var HomunculusWndMainList homunculusWndMainListScript;
var L2UITween l2UITweenScript;
var array<UIControlNeedItemList> needItemLists;
var array<HomunculusAPI.HomunListUIInfo> homunListUIInfos;
var int curTweenID;
var int SelectedIndex;
var int LastIdx;
var int LastType;
var bool isRequested;
var array<L2UIInventoryObject> iObjects;

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	util = L2Util(GetScript("L2Util"));
	effectViewport = GetEffectViewportWndHandle((m_Windowname $ ".EffectViewport"));
	resultWnd = GetWindowHandle((m_Windowname $ ".resultWnd"));
	m_ObjectViewport = GetCharacterViewportWindowHandle((m_Windowname $ ".resultWnd.ObjectViewport"));
	m_ObjectViewport.SetUISound(true);
	txtResult0 = GetTextBoxHandle((m_Windowname $ ".resultWnd.txtResult0"));
	effectViewportResult = GetEffectViewportWndHandle((m_Windowname $ ".resultWnd.EffectViewportResult"));
	birthCircle_tex = GetTextureHandle((m_Windowname $ ".birthCircle_tex"));
	HomunculusWndScript = HomunculusWnd(GetScript("HomunculusWnd"));
	homunculusWndMainListScript = HomunculusWndMainList(GetScript("HomunculusWnd.HomunculusWndMainList"));
	l2UITweenScript = L2UITween(GetScript("L2UITween"));
	btnMain0 = GetButtonHandle((m_Windowname $ ".btnMain0"));
	Select_tex = GetTextureHandle((m_Windowname $ ".SelectedSlot_Tex"));
	birthCircleInput_anitex = GetAnimTextureHandle((m_Windowname $ ".birthCircleInput_anitex"));
	SetTooltip();
	SelectedIndex = -1;
	curTweenID = -1;
	return;
}

function HandleGameInit()
{
	local int i;
	local RichListCtrlHandle rich;

	homunListUIInfos = API_GetHomunculusGatchaList();
	needItemLists.Length = 0;
	i = 0;
	while((i < homunListUIInfos.Length))
	{
		SetCard(i);
		rich = GetRichListCtrl(i);
		SetAdenaPee(rich, homunListUIInfos[i].Fee);
		iObjects[i] = AddItemListener(i);
		iObjects[i].DelegateOnCompare = CompareFunc;
		iObjects[i].DelegateOnAddItem = HandleItemListner;
		iObjects[i].DelegateOnUpdateItem = HandleItemListner;
		iObjects[i].DelegateOnDeletedItem = HandleItemListner;
		i++;
	}
	i = i;
	while((i < 4))
	{
		GetCardWnd(i).HideWindow();
		i++;
	}
	SetDeselect();
	return;
}

function SetAdenaPee(RichListCtrlHandle rich, INT64 pee)
{
	local int Len;

	Len = needItemLists.Length;
	GetWindowHandle((GetCardWndPath(Len) $ ".NeedItemRichListCtrlScript")).SetScript("UIControlNeedItemList");
	needItemLists[Len] = UIControlNeedItemList(GetWindowHandle((GetCardWndPath(Len) $ ".NeedItemRichListCtrlScript")).GetScript());
	needItemLists[Len].SetRichListControler(rich);
	needItemLists[Len].StartNeedItemList(1);
	needItemLists[Len].SetFormType(NAMESIDE);
	needItemLists[Len].AddNeedItemClassID(57, pee);
	needItemLists[Len].DelegateOnUpdateItem = None;
	needItemLists[Len].SetBuyNum(INT64(1));
	return;
}

function SetTooltip()
{
	local CustomTooltip t;

	util.setCustomTooltip(t);
	util.ToopTipMinWidth(200);
	util.ToopTipInsertText(GetSystemString(13548));
	GetButtonHandle((m_Windowname $ ".Help_Btn")).SetTooltipCustomType(util.getCustomToolTip());
	return;
}

event OnRegisterEvent()
{
	RegisterEvent((100000 + 933));
	RegisterEvent((100000 + 932));
	RegisterEvent((100000 + 859));
	RegisterEvent(150);
	return;
}

event OnLoad()
{
	Initialize();
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case (100000 + 932):
			Handle_S_EX_SHOW_HOMUNCULUS_COUPON_UI();
			break;
		case (100000 + 933):
			Handle_S_EX_SUMMON_HOMUNCULUS_COUPON_RESULT();
			break;
		case (100000 + 859):
			Handle_S_EX_DELETE_HOMUNCLUS_DATA_RESULT();
			break;
		case 150:
			if(HomunculusWndScript.ChkSerVer())
			{
				HandleGameInit();
			}
			break;
		default:
			break;
	}
	return;
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	local ItemInfo Info;

	Debug(a_ButtonHandle.GetParentWindowName());
	Debug(a_ButtonHandle.GetWindowName());
	if((a_ButtonHandle.GetWindowName() == "Probability_Btn"))
	{
		if((a_ButtonHandle.GetParentWindowName() == "ItemSlot_Wnd00"))
		{
			GetTexturehandleCraftSlot(0).GetItem(0, Info);
			HomunculusWndProbability(GetScript("HomunculusWndProbability")).API_C_EX_REQ_HOMUNCULUS_PROB_LIST(1, Info.Id.ClassID);
		}
		else if((a_ButtonHandle.GetParentWindowName() == "ItemSlot_Wnd01"))
		{
			GetTexturehandleCraftSlot(1).GetItem(0, Info);
			HomunculusWndProbability(GetScript("HomunculusWndProbability")).API_C_EX_REQ_HOMUNCULUS_PROB_LIST(1, Info.Id.ClassID);
		}
		else if((a_ButtonHandle.GetParentWindowName() == "ItemSlot_Wnd02"))
		{
			GetTexturehandleCraftSlot(2).GetItem(0, Info);
			HomunculusWndProbability(GetScript("HomunculusWndProbability")).API_C_EX_REQ_HOMUNCULUS_PROB_LIST(1, Info.Id.ClassID);
		}
		else if((a_ButtonHandle.GetParentWindowName() == "ItemSlot_Wnd03"))
		{
			GetTexturehandleCraftSlot(3).GetItem(0, Info);
			HomunculusWndProbability(GetScript("HomunculusWndProbability")).API_C_EX_REQ_HOMUNCULUS_PROB_LIST(1, Info.Id.ClassID);
		}
	}
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "swapBtn":
			GetWindowHandle("HomunculusWndProbability").HideWindow();
			HomunculusWndScript.homunculusWndBirthScript.HandleSwapCacha();
			break;
		case "btnMain0":
			ShowPopup();
			break;
		case "btnConfirm":
			HandleConfirm();
			break;
		case "btnDelete":
			ShowDeletePopoup();
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
			Tweenkle(int(param));
			break;
		default:
			break;
	}
	return;
}

event OnSetFocus(WindowHandle a_WindowHandle, bool bFocused)
{
	Debug((("OnSetFocus" @ a_WindowHandle.GetWindowName()) @ string(bFocused)));
	if(bFocused)
	{
		switch(a_WindowHandle.GetWindowName())
		{
			case "ItemSlot_Wnd00":
				SetSelect(0);
				return;
				break;
			case "ItemSlot_Wnd01":
				SetSelect(1);
				return;
				break;
			case "ItemSlot_Wnd02":
				SetSelect(2);
				return;
				break;
			case "ItemSlot_Wnd03":
				SetSelect(3);
				return;
				break;
			default:
				break;
		}
		switch(a_WindowHandle.GetParentWindowName())
		{
			case "ItemSlot_Wnd00":
				SetSelect(0);
				return;
				break;
			case "ItemSlot_Wnd01":
				SetSelect(1);
				return;
				break;
			case "ItemSlot_Wnd02":
				SetSelect(2);
				return;
				break;
			case "ItemSlot_Wnd03":
				SetSelect(3);
				return;
				break;
			default:
				break;
		}
	}
	return;
}

event OnTextureAnimEnd(AnimTextureHandle a_WindowHandle)
{
	switch(a_WindowHandle)
	{
		case birthCircleInput_anitex:
			if(((HomunculusWndScript.Me.IsShowWindow() && Me.IsShowWindow()) && isRequested))
			{
				SummonRequest();
			}
			break;
		default:
			break;
	}
	return;
}

event OnHide()
{
	SetOnHide();
	isRequested = false;
	return;
}

function Show()
{
	local int i;

	i = 0;
	while((i < homunListUIInfos.Length))
	{
		SetCard(i);
		i++;
	}
	Me.ShowWindow();
	Me.SetFocus();
	resultWnd.HideWindow();
	SetEffect("LineageEffect_br.br_e_lamp_deco_d", 50);
	TweenShow();
	return;
}

function Hide()
{
	Me.HideWindow();
	SetOnHide();
	return;
}

function SetOnHide()
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = HomunculusWndScript.GetPopupExpandScript();
	popupExpandScript.Hide();
	birthCircleInput_anitex.Stop();
	SetDeselect();
	isRequested = false;
	SetEffect("", 50);
	return;
}

function SetPostion()
{
	Select_tex.SetAlpha(0);
	if((SelectedIndex == -1))
	{
		return;
	}
	Select_tex.SetAnchor(GetCardWndPath(SelectedIndex), "CenterCenter", "CenterCenter", 2, 2);
	Select_tex.SetAlpha(255, 0.5000000);
	Select_tex.ShowWindow();
	return;
}

function HandleConfirm()
{
	resultWnd.HideWindow();
	ChkCanBuy();
	return;
}

function SetHomunculusData(HomunculusAPI.HomunculusData Data)
{
	local HomunculusAPI.HomunculusNpcData npcData;

	npcData = HomunculusWndScript.GetHomunculusNpcData(Data.Id);
	SetViewPortSetting(Data.Id);
	SetViewPort(npcData.NpcID);
	SetInfo(npcData.NpcID, Data.Type, Data.Level);
	resultWnd.ShowWindow();
	effectViewportResult.SpawnEffect("LineageEffect2.ui_upgrade_succ");
	return;
}

function Handle_S_EX_SHOW_HOMUNCULUS_COUPON_UI()
{
	local UIPacket._S_EX_SHOW_HOMUNCULUS_COUPON_UI packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_SHOW_HOMUNCULUS_COUPON_UI(packet))
	{
		return;
	}
	if(HomunculusWndScript.Me.IsShowWindow())
	{
		if(HomunculusWndScript.homunculusWndBirthScript.isGachaState)
		{
			if((int(HomunculusWndScript.currState) == 1))
			{
				return;
			}
		}
	}
	HomunculusWndScript.Me.ShowWindow();
	HomunculusWndScript.homunculusWndBirthScript.SetGachaState();
	HomunculusWndScript.SetState(birth);
	return;
}

function Handle_S_EX_SUMMON_HOMUNCULUS_COUPON_RESULT()
{
	local UIPacket._S_EX_SUMMON_HOMUNCULUS_COUPON_RESULT packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_SUMMON_HOMUNCULUS_COUPON_RESULT(packet))
	{
		return;
	}
	if((packet.Type == 1))
	{
		LastIdx = packet.nIdx;
		HandleShowResult();
		ChkCanBuy();
	}
	isRequested = false;
	return;
}

function Handle_S_EX_DELETE_HOMUNCLUS_DATA_RESULT()
{
	Debug(("Handle_S_EX_DELETE_HOMUNCLUS_DATA_RESULT" @ string(Me.IsShowWindow())));
	if(Me.IsShowWindow())
	{
		ChkCanBuy();
	}
	return;
}

function HandleShowResult()
{
	local int i;
	local array<HomunculusAPI.HomunculusData> homunculusDatas;

	if(!Me.IsShowWindow())
	{
		return;
	}
	homunculusDatas = HomunculusWndScript.API_GetHomunculusDatas();
	i = 0;
	while((i < homunculusDatas.Length))
	{
		if((homunculusDatas[i].idx == LastIdx))
		{
			SetHomunculusData(homunculusDatas[i]);
			return;
		}
		i++;
	}
	return;
}

function SetInfo(int NpcID, int nType, int Level)
{
	local string NpcName;

	NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(NpcID);
	txtResult0.SetText(((((GetSystemString(88) $ ".") $ string(Level)) @ GetGrade(nType)) @ NpcName));
	SetGrade(nType);
	LastType = nType;
	return;
}

function SetGrade(int Type)
{
	switch(Type)
	{
		case 0:
		case 1:
		case 2:
		case 3:
			m_ObjectViewport.SetBackgroundTex(("L2UI_EPIC.HomunCulusWnd.Homun_birthResultBG_0" $ string((Type + 1))));
			break;
		default:
			break;
	}
	return;
}

function PlayRequestAnimation()
{
	local UIControlDialogAssets popupExpandScript;

	SetEffect("LineageEffect.d_ar_attractcubic_ta", 125);
	birthCircleInput_anitex.Stop();
	birthCircleInput_anitex.Play();
	isRequested = true;
	popupExpandScript = HomunculusWndScript.GetPopupExpandScript();
	popupExpandScript.Hide();
	btnMain0.DisableWindow();
	return;
}

function SummonRequest()
{
	SetEffect("LineageEffect_br.br_e_lamp_deco_d", 50);
	API_C_EX_SUMMON_HOMUNCULUS_COUPON(homunListUIInfos[SelectedIndex].CostItem.Id);
	return;
}

function HandleItemListner(optional ItemInfo iInfo, optional int Index)
{
	if(!HomunculusWndScript.Me.IsShowWindow())
	{
		return;
	}
	SetCard(Index);
	ChkCanBuy();
	return;
}

function bool CompareFunc(ItemInfo iInfo, int Index)
{
	return (homunListUIInfos[Index].CostItem.Id == iInfo.Id.ClassID);
}

function TweenStart()
{
	Me.SetTimer(9, 3000);
	birthCircle_tex.SetAlpha(0);
	TweenAdd(240, 0, 3000, OUT_BOUNCE);
	return;
}

function TweenHide()
{
	birthCircle_tex.SetAlpha(240);
	TweenAdd(-100, 1, 2000, IN_STRONG);
	return;
}

function TweenShow()
{
	birthCircle_tex.SetAlpha(140);
	TweenAdd(100, 2, 2000, OUT_STRONG);
	return;
}

function Tweenkle(int Id)
{
	switch(Id)
	{
		case 0:
			TweenHide();
			break;
		case 1:
			TweenShow();
			break;
		case 2:
			TweenHide();
			break;
		default:
			break;
	}
	return;
}

function SetEffect(string EffectName, optional int dist)
{
	effectViewport.SetCameraDistance(float(dist));
	effectViewport.ShowWindow();
	effectViewport.SpawnEffect(EffectName);
	return;
}

function ShowPopup()
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = HomunculusWndScript.GetPopupExpandScript();
	popupExpandScript.SetDialogDesc(GetSystemString(13558));
	popupExpandScript.SetUseNeedItem(true);
	popupExpandScript.StartNeedItemList(2);
	popupExpandScript.AddNeedItemClassID(homunListUIInfos[SelectedIndex].CostItem.Id, homunListUIInfos[SelectedIndex].CostItem.Amount);
	popupExpandScript.AddNeedItemClassID(57, homunListUIInfos[SelectedIndex].Fee);
	popupExpandScript.SetItemNum(1);
	popupExpandScript.Show();
	popupExpandScript.DelegateOnClickBuy = PlayRequestAnimation;
	return;
}

function ShowDeletePopoup()
{
	local string Msg;
	local UIControlDialogAssets popupExpandScript;
	local HomunculusAPI.HomunCreateData currHmunCreateData;

	popupExpandScript = HomunculusWndScript.GetPopupExpandScript();
	popupExpandScript.SetUseBuyItem(false);
	popupExpandScript.SetUseNeedItem(false);
	popupExpandScript.SetUseNumberInput(false);
	currHmunCreateData = HomunculusWndScript.API_GetHomunCreateData();
	Msg = ((((GetSystemString(13377) $ "\\n") $ GetSystemString(3155)) $ ":") @ string(currHmunCreateData.GainEvolutionPoint[LastType]));
	popupExpandScript.SetDialogDesc(Msg, , , , 30);
	popupExpandScript.Show();
	popupExpandScript.DelegateOnClickBuy = DeleteRequest;
	return;
}

function DeleteRequest()
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = HomunculusWndScript.GetPopupExpandScript();
	popupExpandScript.Hide();
	HomunculusWndScript.API_C_EX_DELETE_HOMUNCULUS_DATA(LastIdx);
	resultWnd.HideWindow();
	return;
}

function SetSelect(int Index)
{
	SelectedIndex = Index;
	ChkCanBuy();
	SetPostion();
	return;
}

function SetDeselect()
{
	SelectedIndex = -1;
	btnMain0.DisableWindow();
	Select_tex.HideWindow();
	return;
}

function array<HomunculusAPI.HomunListUIInfo> API_GetHomunculusGatchaList()
{
	return Class'NWindow.HomunculusAPI'.static.GetHomunculusGatchaList();
}

function API_C_EX_SUMMON_HOMUNCULUS_COUPON(int nItemID)
{
	local array<byte> stream;
	local UIPacket._C_EX_SUMMON_HOMUNCULUS_COUPON packet;

	packet.nItemID = nItemID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_SUMMON_HOMUNCULUS_COUPON(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(703, stream);
	SetSelect(SelectedIndex);
	return;
}

function string GetGrade(int Type)
{
	switch(Type)
	{
		case 0:
			return GetSystemString(441);
			break;
		case 1:
			return GetSystemString(3290);
			break;
		case 2:
			return GetSystemString(13336);
			break;
		default:
			break;
	}
	return "";
}

function SetViewPort(int NpcID)
{
	m_ObjectViewport.SetSpawnDuration(0.1000000);
	m_ObjectViewport.SetNPCInfo(NpcID);
	m_ObjectViewport.SpawnNPC();
	m_ObjectViewport.PlayAnimation(0);
	return;
}

function SetViewPortSetting(int Id)
{
	local float tmpScale;
	local int OffsetY;

	switch(Id)
	{
		case 0:
			tmpScale = 0.5000000;
			OffsetY = -1;
			break;
		case 1:
		case 2:
		case 3:
			tmpScale = 1.2000000;
			OffsetY = -11;
			break;
		case 4:
		case 5:
		case 6:
			tmpScale = 1.5000000;
			OffsetY = -1;
			break;
		case 7:
		case 8:
		case 9:
			tmpScale = 0.9000000;
			OffsetY = -1;
			break;
		case 10:
		case 11:
		case 12:
			tmpScale = 1.7000000;
			OffsetY = -8;
			break;
		case 13:
		case 14:
		case 15:
			tmpScale = 1.1000000;
			OffsetY = -1;
			break;
		case 16:
		case 17:
		case 18:
			tmpScale = 1.4000000;
			OffsetY = -3;
			break;
		case 19:
		case 20:
		case 21:
			tmpScale = 1.6000000;
			OffsetY = -1;
			break;
		case 22:
		case 23:
		case 24:
			tmpScale = 1.5000000;
			OffsetY = -5;
			break;
		case 25:
		case 26:
		case 27:
			tmpScale = 1.2000000;
			OffsetY = 0;
			break;
		case 28:
		case 29:
		case 30:
			tmpScale = 1.2000000;
			OffsetY = -1;
			break;
		case 31:
		case 32:
		case 33:
			tmpScale = 1.4000000;
			OffsetY = -8;
			break;
		case 34:
		case 35:
		case 36:
			tmpScale = 1.4000000;
			OffsetY = -17;
			break;
		case 37:
		case 38:
		case 39:
			tmpScale = 1.6000000;
			OffsetY = 0;
			break;
		default:
			tmpScale = 1.2000000;
			OffsetY = -1;
			break;
	}
	m_ObjectViewport.SetCharacterScale(tmpScale);
	m_ObjectViewport.SetCharacterOffsetY(OffsetY);
	return;
}

function bool GetCanBuy()
{
	local array<ItemInfo> iInfos;

	if((SelectedIndex == -1))
	{
		return false;
	}
	Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(homunListUIInfos[SelectedIndex].CostItem.Id, iInfos);
	if((iInfos.Length == 0))
	{
		return false;
	}
	return (((iInfos[0].ItemNum >= homunListUIInfos[SelectedIndex].CostItem.Amount) && needItemLists[SelectedIndex].GetCanBuy()) && (homunculusWndMainListScript.GetEmptySlot() != -1));
}

function ChkCanBuy()
{
	if((GetCanBuy() && !isRequested))
	{
		btnMain0.EnableWindow();
	}
	else
	{
		btnMain0.DisableWindow();
	}
	return;
}

function string GetGradeTextureByRank(int ProductRank)
{
	switch(ProductRank)
	{
		case 0:
			return "L2UI_EPIC.HomunCulusWnd.GachaCardBG_Gray";
			break;
		case 1:
			return "L2UI_EPIC.HomunCulusWnd.GachaCardBG_Green";
			break;
		case 2:
			return "L2UI_EPIC.HomunCulusWnd.GachaCardBG_Red";
			break;
		case 3:
			return "L2UI_EPIC.HomunCulusWnd.GachaCardBG_Yellow";
			break;
		default:
			break;
	}
	return "";
}

function TextureHandle GetTexturehandleGradeBG(int Num)
{
	return GetTextureHandle((GetCardWndPath(Num) $ ".Grade_Tex"));
}

function WindowHandle GetCardWnd(int Num)
{
	return GetWindowHandle(GetCardWndPath(Num));
}

function ItemWindowHandle GetTexturehandleCraftSlot(int Num)
{
	return GetItemWindowHandle((GetCardWndPath(Num) $ ".BMItem_ItemWnd"));
}

function TextureHandle GetTextureRibbon(int Num)
{
	return GetTextureHandle((GetCardWndPath(Num) $ ".Ribbon_Tex"));
}

function TextBoxHandle GetTextBoxhandleBMItemMYNum(int Num)
{
	return GetTextBoxHandle((GetCardWndPath(Num) $ ".BMItemNumber_Txt"));
}

function TextBoxHandle GetTextItemName(int Num)
{
	return GetTextBoxHandle((GetCardWndPath(Num) $ ".BMItemName_Txt"));
}

function RichListCtrlHandle GetRichListCtrl(int Num)
{
	return GetRichListCtrlHandle((GetCardWndPath(Num) $ ".NeedItemRichListCtrl"));
}

function string GetCardWndPath(int Num)
{
	return ((("HomunculusWnd." $ m_Windowname) $ ".ItemSlot_Wnd0") $ string(Num));
}

function SetCard(int i)
{
	local ItemInfo iInfo;
	local array<ItemInfo> iInfos;
	local string tmpName;
	local Rect rectWnd;
	local INT64 myCardNum;

	GetCardWnd(i).ShowWindow();
	iInfo = GetItemInfoByClassID(homunListUIInfos[i].CostItem.Id);
	GetTexturehandleCraftSlot(i).ShowWindow();
	GetTexturehandleCraftSlot(i).Clear();
	GetTexturehandleCraftSlot(i).AddItem(iInfo);
	rectWnd = GetTextItemName(i).GetRect();
	tmpName = GetEllipsisString(iInfo.Name, rectWnd.nWidth, ("x" $ string(homunListUIInfos[i].CostItem.Amount)));
	GetTextItemName(i).SetText(tmpName);
	GetTexturehandleGradeBG(i).SetTexture(GetGradeTextureByRank(homunListUIInfos[i].Grade));
	Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(homunListUIInfos[i].CostItem.Id, iInfos);
	if((iInfos.Length == 0))
	{
		myCardNum = INT64(0);
	}
	else
	{
		myCardNum = iInfos[0].ItemNum;
	}
	GetTextBoxhandleBMItemMYNum(i).SetText((("(" $ string(myCardNum)) $ ")"));
	if((myCardNum >= homunListUIInfos[i].CostItem.Amount))
	{
		GetTextBoxhandleBMItemMYNum(i).SetTextColor(getInstanceL2Util().BLUE01);
	}
	else
	{
		GetTextBoxhandleBMItemMYNum(i).SetTextColor(getInstanceL2Util().Red);
	}
	if((homunListUIInfos[i].Event > 0))
	{
		GetTextureRibbon(i).SetTexture("L2UI_EPIC.HomunCulusWnd.Img_EventRibbon");
	}
	else
	{
		GetTextureRibbon(i).HideWindow();
	}
	return;
}

function TweenAdd(int TargetAlpha, int Id, int Duration, L2UITween.easeType Type)
{
	local L2UITween.TweenObject tweenObjectData;

	tweenObjectData.Owner = ("HomunculusWnd." $ m_Windowname);
	tweenObjectData.Id = Id;
	tweenObjectData.Target = birthCircle_tex;
	tweenObjectData.Duration = float(Duration);
	tweenObjectData.Alpha = float(TargetAlpha);
	tweenObjectData.ease = easeType(Type);
	TweenStop();
	l2UITweenScript.AddTweenObject(tweenObjectData);
	curTweenID = Id;
	return;
}

function TweenStop()
{
	if((curTweenID != -1))
	{
		l2UITweenScript.StopTween(("HomunculusWnd." $ m_Windowname), curTweenID);
	}
	curTweenID = -1;
	return;
}

function string GetEllipsisString(string Str, int MaxWidth, string numString)
{
	local string fixedString;
	local int nWidth, nHeight, textWidth, numStringWidth, numStringHeight;

	GetTextSizeDefault(numString, numStringWidth, numStringHeight);
	textWidth = MaxWidth;
	GetTextSizeDefault((Str $ "..."), nWidth, nHeight);
	if((((nWidth + numStringWidth) + 4) < textWidth))
	{
		return (Str @ numString);
	}
	fixedString = DivideStringWithWidth(Str, ((textWidth - numStringWidth) - 4));
	if((fixedString != Str))
	{
		fixedString = (fixedString $ "...");
	}
	return (fixedString @ numString);
}
