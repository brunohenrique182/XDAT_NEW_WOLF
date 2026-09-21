class CustomizingWndNameDeco extends UICommonAPI
	dependson(UIPacket);

const DIALOG_TYPE_REGIST = 0;
const DIALOG_TYPE_APPLY = 1;
const DIALOG_TYPE_RESET = 2;
const STYLETYPE = 2;

struct ItemAmountDATA
{
	var int ItemClassID;
	var INT64 ItemAmount;
};

struct SlotInfoStruct
{
	var int StyleID;
	var bool bOpened;
};

var L2UITimerObject tObject;
var UIControlTilelistScroll scrollTesterV;
var L2UITweenTwinkleObject twinkleObject;
var ItemAmountDATA styleFee;
var int selectedStyleID;
var array<SlotInfoStruct> slotInfosAll;
var int requestedRegistStyleID;
var int requestedSelectStyleID;

static function CustomizingWndNameDeco Inst()
{
	return CustomizingWndNameDeco(GetScript("CustomizingWnd.CustomizingWndNameDeco"));
}

function Initialize()
{
	scrollTesterV = Class'InterfaceClassic.UIControlTilelistScroll'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollAreaWndV")), 1, 7, true, "itemRenderer");
	scrollTesterV.DelegateOnRenderer = HandleDelegateOnRenderer;
	scrollTesterV.DelegateOnClick = HandleDelegateOnClickV;
	scrollTesterV.DelegateOnSelect = HandleDelegateOnSelect;
	return;
}

function InitTimer()
{
	tObject = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(100, -1);
	tObject._DelegateOnTime = DelegateOnTime;
	tObject._Stop();
	return;
}

function DelegateOnTime(int Time)
{
	if((m_hOwnerWnd.GetAlpha() == 0))
	{
		m_hOwnerWnd.HideWindow();
		tObject._Stop();
	}
	else if((m_hOwnerWnd.GetAlpha() == 255))
	{
		tObject._Stop();
	}
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	InitTimer();
	ClearAllRequestDatas();
	return;
}

event OnHide()
{
	scrollTesterV._SetSelect(-1);
	return;
}

event OnShow()
{
	RefreshCanApplyList();
	scrollTesterV._Refresh();
	scrollTesterV._SetDontUseScrollTween(true);
	scrollTesterV._SetSelect(GetApplyingIndex(), true);
	scrollTesterV._SetDontUseScrollTween(false);
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEventProtocols();
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case 9750:
			SetStyleDatas();
			break;
		default:
			OnEventProtocols(EventID);
			break;
	}
	return;
}

event OnReceivedCloseUI()
{
	m_hOwnerWnd.GetParentWindowHandle().GetScript().OnReceivedCloseUI();
	return;
}

function Hide()
{
	local Rect rectWnd;
	local int locX, locY;

	rectWnd = m_hOwnerWnd.GetRect();
	Global2Local(m_hOwnerWnd.GetParentWindowHandle(), rectWnd.nX, rectWnd.nY, locX, locY);
	rectWnd = CustomizingWnd(GetScript("CustomizingWnd")).m_hOwnerWnd.GetRect();
	m_hOwnerWnd.SetAlpha(0, 0.1000000);
	m_hOwnerWnd.MoveExWithTime((25 - locX), 0, 0.1000000);
	if((twinkleObject != none))
	{
		twinkleObject._Stop();
	}
	tObject._Reset();
	GetDialogAssets().Hide();
	return;
}

function Show()
{
	local Rect rectWnd;
	local int locX, locY;

	rectWnd = m_hOwnerWnd.GetRect();
	Global2Local(m_hOwnerWnd.GetParentWindowHandle(), rectWnd.nX, rectWnd.nY, locX, locY);
	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetAlpha(255, 0.1000000);
	m_hOwnerWnd.SetFocus();
	m_hOwnerWnd.MoveExWithTime((-locX + 7), 0, 0.1000000);
	return;
}

function int GetApplyingIndex()
{
	return GetItemIndexByStyleID(selectedStyleID);
}

function int GetItemIndexByStyleID(int StyleID)
{
	local int i;

	i = 0;
	while((i < slotInfosAll.Length))
	{
		if((slotInfosAll[i].StyleID == StyleID))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function ShowDialogAssets(int dialogType)
{
	local UIControlDialogAssets uicontrolDialogAssetScr;
	local CharacterStyleUIData o_data;
	local L2ItemAmount ItemAmount;
	local int i;

	uicontrolDialogAssetScr = GetDialogAssets();
	uicontrolDialogAssetScr.SetDialogID(dialogType);
	uicontrolDialogAssetScr.DelegateOnClickBuy = HandleDialogOK;
	uicontrolDialogAssetScr.DelegateOnCancel = HandleDialogCancel;
	uicontrolDialogAssetScr.SetUseBuyItem(false);
	uicontrolDialogAssetScr.SetUseNumberInput(false);
	uicontrolDialogAssetScr._SetUseSelectItemWindow(false);
	uicontrolDialogAssetScr.StartNeedItemList(1);
	uicontrolDialogAssetScr.SetNeedItemTitle_text(GetSystemString(637));
	if((API_GetCharacterStyleData(GetSelectedStyleID(), o_data) == false))
	{
		return;
	}
	switch(dialogType)
	{
		case 1:
			uicontrolDialogAssetScr.SetUseNeedItem(true);
			uicontrolDialogAssetScr.AddNeedItemClassID(styleFee.ItemClassID, styleFee.ItemAmount);
			uicontrolDialogAssetScr.SetItemNum(1);
			uicontrolDialogAssetScr.SetDialogDescHtml(MakeFullSystemMsg(GetSystemMessage(14634), o_data.StyleName));
			break;
		case 0:
			if((o_data.ActiveCosts.Length > 1))
			{
				uicontrolDialogAssetScr._SetUseSelectItemWindow(true);
				uicontrolDialogAssetScr.SetUseNeedItem(false);
				uicontrolDialogAssetScr._StartSelectItemList(o_data.ActiveCosts.Length);
				i = 0;
				while((i < o_data.ActiveCosts.Length))
				{
					uicontrolDialogAssetScr._AddSelectItemClassID(o_data.ActiveCosts[i].ItemClassID, INT64(o_data.ActiveCosts[i].ItemAmount));
					i++;
				}
			}
			else
			{
				uicontrolDialogAssetScr.SetUseNeedItem(true);
				uicontrolDialogAssetScr.StartNeedItemList(1);
				uicontrolDialogAssetScr.AddNeedItemClassID(o_data.ActiveCosts[0].ItemClassID, INT64(o_data.ActiveCosts[0].ItemAmount));
			}
			uicontrolDialogAssetScr.SetNeedItemTitle_text(GetSystemString(14983));
			uicontrolDialogAssetScr.SetItemNum(1);
			uicontrolDialogAssetScr.SetDialogDescHtml(MakeFullSystemMsg(GetSystemMessage(14633), o_data.StyleName));
			break;
		case 2:
			uicontrolDialogAssetScr.SetUseNeedItem(false);
			uicontrolDialogAssetScr.SetDialogDescHtml(MakeFullSystemMsg(GetSystemMessage(14635), o_data.StyleName));
			uicontrolDialogAssetScr.OKButton.EnableWindow();
			break;
		default:
			break;
	}
	uicontrolDialogAssetScr.Show();
	return;
}

function HandleDialogOK()
{
	local UIControlDialogAssets uicontrolDialogAssetScr;

	uicontrolDialogAssetScr = GetDialogAssets();
	switch(uicontrolDialogAssetScr.GetDialogID())
	{
		case 0:
			RQ_C_EX_CHARACTER_STYLE_REGIST(GetSelectedStyleID());
			break;
		case 2:
			RQ_C_EX_CHARACTER_STYLE_SELECT(-1);
			break;
		case 1:
			RQ_C_EX_CHARACTER_STYLE_SELECT(GetSelectedStyleID());
			break;
		default:
			break;
	}
	GetDialogAssets().Hide();
	return;
}

function HandleDialogCancel()
{
	GetDialogAssets().Hide();
	return;
}

function UIControlDialogAssets GetDialogAssets()
{
	return CustomizingWnd(GetScript("CustomizingWnd"))._GetDialogAssets();
}

function RefreshCanApplyList()
{
	scrollTesterV._SetTileListLength(slotInfosAll.Length);
	scrollTesterV._Refresh();
	if((selectedStyleID > 0))
	{
		scrollTesterV._SetSelect(GetApplyingIndex(), true);
	}
	else
	{
		scrollTesterV._SetSelect(-1);
	}
	return;
}

function RefreshByStyleID(int StyleID)
{
	local int itemIndex, rendererID;

	itemIndex = GetItemIndexByStyleID(StyleID);
	rendererID = scrollTesterV._GetRendererID(itemIndex);
	if(((rendererID < scrollTesterV._GetLength()) && (rendererID > -1)))
	{
		scrollTesterV._RefreshRenderer(rendererID);
	}
	return;
}

function HandleDelegateOnRenderer(string rendererName, int rendererID, int itemIndex)
{
	local bool bCanOpen;
	local SlotInfoStruct slotInfo;
	local CharacterStyleUIData o_data;
	local array<ItemInfo> iInfos;

	if((itemIndex >= scrollTesterV._GetLength()))
	{
		GetWindowHandle(rendererName).HideWindow();
		return;
	}
	GetWindowHandle(rendererName).ShowWindow();
	slotInfo = slotInfosAll[itemIndex];
	if((API_GetCharacterStyleData(slotInfo.StyleID, o_data) == false))
	{
		return;
	}
	GetTextureHandle((rendererName $ ".texNameDeco")).SetTexture(o_data.ChatBgTex);
	GetTextBoxHandle((rendererName $ ".scrollText")).SetText(o_data.StyleName);
	GetTextureHandle((rendererName $ ".circleEffect")).HideWindow();
	GetTextureHandle((rendererName $ ".openBtnHighlight")).HideWindow();
	if((twinkleObject != none))
	{
		twinkleObject._Stop();
	}
	if(slotInfo.bOpened)
	{
		GetTextureHandle((rendererName $ ".lockTexAni_tex")).HideWindow();
		if((slotInfo.StyleID == selectedStyleID))
		{
			GetButtonHandle((rendererName $ ".resetBtn")).SetFocus();
			GetTextureHandle((rendererName $ ".circleEffect")).ShowWindow();
		}
		else
		{
			GetButtonHandle((rendererName $ ".applyBtn")).SetFocus();
		}
		GetTextureHandle((rendererName $ ".bgTexture")).SetTexture("L2UI_NewTex.StyleWnd.StyleWndList_Normal");
	}
	else
	{
		GetButtonHandle((rendererName $ ".registBtn")).SetFocus();
		if((GetCanRegist(slotInfo.StyleID) == true))
		{
			GetButtonHandle((rendererName $ ".registBtn")).SetTexture("L2UI_NewTex.StyleWnd.StyleWndUnLockBtn_Normal", "L2UI_NewTex.StyleWnd.StyleWndUnLockBtn_Over", "L2UI_NewTex.StyleWnd.StyleWndUnLockBtn_Down");
			GetTextureHandle((rendererName $ ".lockTexAni_tex")).ShowWindow();
		}
		else
		{
			GetButtonHandle((rendererName $ ".registBtn")).SetTexture("L2UI_NewTex.StyleWnd.StyleWndUnLockBtn_Disable", "L2UI_NewTex.StyleWnd.StyleWndUnLockBtn_Disable", "L2UI_NewTex.StyleWnd.StyleWndUnLockBtn_Disable");
			GetTextureHandle((rendererName $ ".lockTexAni_tex")).HideWindow();
		}
		GetTextureHandle((rendererName $ ".bgTexture")).SetTexture("L2UI_NewTex.StyleWnd.StyleWndList_Disable");
	}
	if((int(o_data.MarkType) > 0))
	{
		GetTextureHandle((rendererName $ ".Premium_tex")).ShowWindow();
	}
	else
	{
		GetTextureHandle((rendererName $ ".Premium_tex")).HideWindow();
	}
	return;
}

function HandleDelegateOnClickV(string BTNID, int rendererIndex, int itemIndex)
{
	switch(BTNID)
	{
		case "registBtn":
			ShowDialogAssets(0);
			break;
		case "resetBtn":
			ShowDialogAssets(2);
			break;
		case "applyBtn":
			ShowDialogAssets(1);
			break;
		default:
			break;
	}
	return;
}

function HandleDelegateOnSelect(string rendererPath, int rendererID, int itemIndex)
{
	local SlotInfoStruct slotInfo;
	local TextureHandle openBtnHighlight;
	local CharacterStyleUIData o_data;
	local array<ItemInfo> iInfos;

	slotInfo = slotInfosAll[itemIndex];
	openBtnHighlight = GetTextureHandle((rendererPath $ ".openBtnHighlight"));
	if((selectedStyleID == slotInfo.StyleID))
	{
		return;
	}
	if((slotInfo.bOpened == true))
	{
		openBtnHighlight.ShowWindow();
		openBtnHighlight.SetAlpha(0);
		openBtnHighlight.SetTexture("L2UI_NewTex.StyleWnd.StyleWndApplyBtn_Hightlight");
		twinkleObject = Class'InterfaceClassic.L2UITween'.static.Inst()._AddTweenTwinlkle(openBtnHighlight, 4.5000000, 0.5000000, 400.0000000, 0, 255, 0.0000000);
		return;
	}
	if((API_GetCharacterStyleData(slotInfo.StyleID, o_data) == false))
	{
		return;
	}
	if(((slotInfo.bOpened == false) && GetCanRegist(slotInfo.StyleID)))
	{
		openBtnHighlight.ShowWindow();
		openBtnHighlight.SetAlpha(0);
		openBtnHighlight.SetTexture("L2UI_NewTex.StyleWnd.StyleWndUnLockBtn_Highlight");
		twinkleObject = Class'InterfaceClassic.L2UITween'.static.Inst()._AddTweenTwinlkle(openBtnHighlight, 4.5000000, 0.5000000, 400.0000000, 0, 255, 0.0000000);
	}
	else
	{
		openBtnHighlight.HideWindow();
	}
	return;
}

function int GetSelectedStyleID()
{
	if((scrollTesterV._GetSelectedIndex() == -1))
	{
		return -1;
	}
	return slotInfosAll[scrollTesterV._GetSelectedIndex()].StyleID;
}

function API_GetCharacterStyleDataAll(out array<CharacterStyleUIData> o_DataList)
{
	Class'NWindow.UIDATA_ITEM'.static.GetCharacterStyleDataAll(2, o_DataList);
	return;
}

function bool API_GetCharacterStyleData(int a_StyleID, out CharacterStyleUIData o_data)
{
	return Class'NWindow.UIDATA_ITEM'.static.GetCharacterStyleData(2, a_StyleID, o_data);
}

function RegisterEventProtocols()
{
	RegisterEvent(EV_PacketID(1206));
	RegisterEvent(EV_PacketID(1207));
	RegisterEvent(EV_PacketID(1208));
	return;
}

function OnEventProtocols(int EventID)
{
	switch(EventID)
	{
		case EV_PacketID(1206):
			RT_S_EX_CHARACTER_STYLE_LIST();
			break;
		case EV_PacketID(1207):
			RT_S_EX_CHARACTER_STYLE_REGIST();
			break;
		case EV_PacketID(1208):
			RT_S_EX_CHARACTER_STYLE_SELECT();
			break;
		default:
			break;
	}
	return;
}

function _SetSelectByStyleID(int StyleID)
{
	scrollTesterV._SetSelect(GetItemIndexByStyleID(StyleID), true);
	return;
}

function RT_S_EX_CHARACTER_STYLE_LIST()
{
	local UIPacket._S_EX_CHARACTER_STYLE_LIST packet;
	local int i, Index;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_CHARACTER_STYLE_LIST(packet))
	{
		return;
	}
	if((2 != packet.nStyleType))
	{
		return;
	}
	styleFee.ItemClassID = packet.nChangeCostClassID;
	styleFee.ItemAmount = packet.nChangeCostAmount;
	SetSelectedStyleIDs(packet.selectStyleList);
	i = 0;
	while((i < packet.activeStyleIDList.Length))
	{
		Index = GetItemIndexByStyleID(packet.activeStyleIDList[i]);
		if((Index == -1))
		{
			i++;
			continue;
		}
		slotInfosAll[Index].bOpened = true;
		i++;
	}
	if((m_hOwnerWnd.IsShowWindow() == false))
	{
		return;
	}
	scrollTesterV._Refresh();
	return;
}

function RQ_C_EX_CHARACTER_STYLE_REGIST(int StyleID)
{
	local array<byte> stream;
	local UIPacket._C_EX_CHARACTER_STYLE_REGIST packet;

	requestedRegistStyleID = StyleID;
	packet.nStyleType = 2;
	packet.nStyleID = StyleID;
	packet.nCostItemClassID = GetDialogAssets()._GetNeedItemClassIDs()[0];
	Debug(("RQ_C_EX_CHARACTER_STYLE_REGIST" @ string(StyleID)));
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_CHARACTER_STYLE_REGIST(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(927, stream);
	return;
}

function RT_S_EX_CHARACTER_STYLE_REGIST()
{
	local UIPacket._S_EX_CHARACTER_STYLE_REGIST packet;
	local AnimTextureHandle unLockTexAni_tex;
	local TextureHandle openBtnHighlight;
	local int ItemID, rendererID;

	if((requestedRegistStyleID == -2))
	{
		return;
	}
	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_CHARACTER_STYLE_REGIST(packet))
	{
		return;
	}
	if((packet.cResult == 0))
	{
		ClearAllRequestDatas();
		return;
	}
	ItemID = GetItemIndexByStyleID(requestedRegistStyleID);
	slotInfosAll[ItemID].bOpened = true;
	RefreshByStyleID(requestedRegistStyleID);
	rendererID = scrollTesterV._GetRendererID(ItemID);
	ClearAllRequestDatas();
	if((rendererID == -1))
	{
		return;
	}
	openBtnHighlight = GetTextureHandle((scrollTesterV._GetRendererPath(rendererID) $ ".openBtnHighlight"));
	openBtnHighlight.ShowWindow();
	openBtnHighlight.SetAlpha(0);
	openBtnHighlight.SetTexture("L2UI_NewTex.StyleWnd.StyleWndApplyBtn_Hightlight");
	twinkleObject = Class'InterfaceClassic.L2UITween'.static.Inst()._AddTweenTwinlkle(openBtnHighlight, 4.5000000, 0.5000000, 400.0000000, 0, 255, 0.0000000);
	unLockTexAni_tex = GetAnimTextureHandle((scrollTesterV._GetRendererPath(rendererID) $ ".UnLockTexAni_tex"));
	unLockTexAni_tex.SetLoopCount(1);
	unLockTexAni_tex.SetCurrentFrame(1);
	unLockTexAni_tex.ShowWindow();
	unLockTexAni_tex.Play();
	return;
}

function RQ_C_EX_CHARACTER_STYLE_SELECT(int StyleID)
{
	local array<byte> stream;
	local UIPacket._C_EX_CHARACTER_STYLE_SELECT packet;

	requestedSelectStyleID = StyleID;
	packet.nStyleType = 2;
	packet.nStyleID = requestedSelectStyleID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_CHARACTER_STYLE_SELECT(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(928, stream);
	return;
}

function RT_S_EX_CHARACTER_STYLE_SELECT()
{
	local int selectedStyleIDBefore;
	local UIPacket._S_EX_CHARACTER_STYLE_SELECT packet;

	if((requestedSelectStyleID == -2))
	{
		return;
	}
	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_CHARACTER_STYLE_SELECT(packet))
	{
		return;
	}
	if((packet.cResult == 0))
	{
		ClearAllRequestDatas();
		return;
	}
	selectedStyleIDBefore = selectedStyleID;
	selectedStyleID = requestedSelectStyleID;
	RefreshByStyleID(selectedStyleIDBefore);
	RefreshByStyleID(selectedStyleID);
	ClearAllRequestDatas();
	return;
}

function SetStyleDatas()
{
	local int i;
	local array<CharacterStyleUIData> o_DataList;

	slotInfosAll.Length = 0;
	API_GetCharacterStyleDataAll(o_DataList);
	slotInfosAll.Length = o_DataList.Length;
	Debug(("SetStyleDatas" @ string(o_DataList.Length)));
	i = 0;
	while((i < o_DataList.Length))
	{
		slotInfosAll[i].StyleID = o_DataList[i].StyleID;
		i++;
	}
	return;
}

function ClearAllRequestDatas()
{
	requestedRegistStyleID = -2;
	requestedSelectStyleID = -2;
	return;
}

function SetSelectedStyleIDs(array<UIPacket._SelectStyleInfo> selectStyleList)
{
	local int i, SlotID;

	if((selectStyleList.Length == 0))
	{
		selectedStyleID = -1;
	}
	else
	{
		selectedStyleID = selectStyleList[0].nStyleID;
	}
	return;
}

function bool CompareItemAmount(array<L2ItemAmount> itemAmountsA, array<L2ItemAmount> itemAmountsB)
{
	local int i, j;

	i = 0;
	while((i < itemAmountsA.Length))
	{
		j = 0;
		while((j < itemAmountsB.Length))
		{
			if((itemAmountsA[i].ItemClassID == itemAmountsB[j].ItemClassID))
			{
				return true;
			}
			j++;
		}
		i++;
	}
	return false;
}

function bool GetCanRegist(int StyleID)
{
	local int i;
	local array<ItemInfo> iInfos;
	local CharacterStyleUIData o_data;

	if((API_GetCharacterStyleData(StyleID, o_data) == false))
	{
		return false;
	}
	i = 0;
	while((i < o_data.ActiveCosts.Length))
	{
		if((Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(o_data.ActiveCosts[i].ItemClassID, iInfos) == 0))
		{
			i++;
			continue;
		}
		if((iInfos[0].ItemNum >= INT64(o_data.ActiveCosts[i].ItemAmount)))
		{
			return true;
		}
		i++;
	}
	return false;
}

function TEstInfos()
{
	local int i;

	slotInfosAll.Length = 100;
	if((Rand(2) == 1))
	{
		selectedStyleID = (Rand(100) - 1);
	}
	i = 0;
	while((i < slotInfosAll.Length))
	{
		slotInfosAll[i].StyleID = i;
		slotInfosAll[i].bOpened = ((Rand(3) == 0) || (i == selectedStyleID));
		i++;
	}
	return;
}
