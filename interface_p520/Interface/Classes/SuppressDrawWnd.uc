class SuppressDrawWnd extends UICommonAPI
	dependson(UIPacket);

struct resultItem
{
	var int ClassID;
	var int ItemNum;
	var int ColorIndex;
};

var WindowHandle Me;
var WindowHandle SuppressDrawResultWnd;
var RichListCtrlHandle SuppressDrawResulrtList_ListCtrl;
var RichListCtrlHandle SuppressDrawList_ListCtrl;
var TextureHandle ListBg_tex;
var RichListCtrlHandle NeedItemRichListCtrl;
var WindowHandle inputItemWnd;
var WindowHandle needItemWnd;
var ButtonHandle Draw_btn;
var TextBoxHandle SuppressDrawTitle_txt;
var TextureHandle SuppressDrawWndBg05_tex;
var TextureHandle SuppressDrawImg_tex;
var TextureHandle SuppressDrawWndBg01_tex;
var TextureHandle SuppressDrawWndBg02_tex;
var EffectViewportWndHandle EffectViewport02;
var string m_Windowname;
var UIControlNumberInput inputItemScript;
var UIControlNeedItemList needItemScript;
var SubjugationData currentSubjugationData;
var int AddGachaNeedPointListIndex;
var int lastSelectedListIndex;
var array<int> probs;
var array<resultItem> ResultItemArray;
//var delegate<SortResultItemDelegate> __SortResultItemDelegate__Delegate;

function OnRegisterEvent()
{
	RegisterEvent((100000 + 940));
	RegisterEvent((100000 + 939));
	return;
}

function Initialize()
{
	Me = GetWindowHandle("SuppressDrawWnd");
	EffectViewport02 = GetEffectViewportWndHandle("SuppressDrawWnd.EffectViewport02");
	SuppressDrawResultWnd = GetWindowHandle("SuppressDrawWnd.SuppressDrawResultWnd");
	SuppressDrawResulrtList_ListCtrl = GetRichListCtrlHandle("SuppressDrawWnd.SuppressDrawResultWnd.SuppressDrawResulrtList_ListCtrl");
	SuppressDrawList_ListCtrl = GetRichListCtrlHandle("SuppressDrawWnd.SuppressDrawList_ListCtrl");
	ListBg_tex = GetTextureHandle("SuppressDrawWnd.ListBg_tex");
	Draw_btn = GetButtonHandle("SuppressDrawWnd.Draw_btn");
	SuppressDrawTitle_txt = GetTextBoxHandle("SuppressDrawWnd.SuppressDrawTitle_txt");
	SuppressDrawWndBg05_tex = GetTextureHandle("SuppressDrawWnd.SuppressDrawWndBg05_tex");
	SuppressDrawImg_tex = GetTextureHandle("SuppressDrawWnd.SuppressDrawImg_tex");
	SuppressDrawWndBg01_tex = GetTextureHandle("SuppressDrawWnd.SuppressDrawWndBg01_tex");
	SuppressDrawWndBg02_tex = GetTextureHandle("SuppressDrawWnd.SuppressDrawWndBg02_tex");
	inputItemWnd = GetWindowHandle("SuppressDrawWnd.inputItemWnd");
	needItemWnd = GetWindowHandle("SuppressDrawWnd.needItemWnd");
	NeedItemRichListCtrl = GetRichListCtrlHandle("SuppressDrawWnd.needItemWnd.NeedItemRichListCtrl");
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	InitNeedItem();
	InitInputControl();
	SetPopupScript();
	SuppressDrawList_ListCtrl.SetSelectedSelTooltip(false);
	SuppressDrawList_ListCtrl.SetAppearTooltipAtMouseX(true);
	SuppressDrawList_ListCtrl.SetSelectable(false);
	SuppressDrawList_ListCtrl.SetUseStripeBackTexture(false);
	SuppressDrawResulrtList_ListCtrl.SetSelectedSelTooltip(false);
	SuppressDrawResulrtList_ListCtrl.SetAppearTooltipAtMouseX(true);
	SuppressDrawResulrtList_ListCtrl.SetSelectable(false);
	SuppressDrawResulrtList_ListCtrl.SetUseStripeBackTexture(false);
	return;
}

event OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	GetPopupExpandScript().Hide();
	SuppressDrawResultWnd.HideWindow();
	showDisable(false);
	inputItemScript.SetCount(INT64(int(needItemScript.GetMaxNumCanBuy())));
	return;
}

event OnHide()
{
	EffectViewport02.SpawnEffect("");
	needItemScript.CleariObjects();
	return;
}

function setScriptData(int subjugationID)
{
	local int i;
	local ItemInfo Info;
	local int probCount;

	currentSubjugationData = SuppressWnd(GetScript("SuppressWnd")).getSubjugationDataByID(subjugationID);
	setWindowTitleByString(((GetSystemString(13630) $ " - ") $ currentSubjugationData.Name));
	ResultItemArray.Length = 0;
	i = 0;
	while((i < (currentSubjugationData.ShowGachaMain.Length / 3)))
	{
		Info = GetItemInfoByClassID(currentSubjugationData.ShowGachaMain[(i * 3)]);
		Info.ItemNum = INT64(currentSubjugationData.ShowGachaMain[((i * 3) + 1)]);
		if((Info.ItemNum > INT64(1)))
		{
			Info.bShowCount = true;
		}
		GetItemWindowHandle((((m_Windowname $ ".valueItem0") $ string((i + 1))) $ "_wnd.itemWindow")).Clear();
		GetItemWindowHandle((((m_Windowname $ ".valueItem0") $ string((i + 1))) $ "_wnd.itemWindow")).AddItem(Info);
		GetTextureHandle((((m_Windowname $ ".valueItem0") $ string((i + 1))) $ "_wnd.ItemSlot_tex")).SetTexture((("L2UI_EPIC.SuppressWnd.SuppressItem0" $ string(currentSubjugationData.ShowGachaMain[((i * 3) + 2)])) $ "_Bg"));
		GetTextBoxHandle((((m_Windowname $ ".valueItem0") $ string((i + 1))) $ "_wnd.ItemName_txt")).SetText(Info.Name);
		GetTextBoxHandle((((m_Windowname $ ".valueItem0") $ string((i + 1))) $ "_wnd.ItemNum_txt")).SetText(("x" $ string(Info.ItemNum)));
		GetTextBoxHandle((((m_Windowname $ ".valueItem0") $ string((i + 1))) $ "_wnd.PerNum_txt")).SetText(getInstanceL2Util().MakeDecimalPointString(string(probs[probCount]), 2, true, true));
		probCount++;
		textBoxShortStringWithTooltip(GetTextBoxHandle((((m_Windowname $ ".valueItem0") $ string((i + 1))) $ "_wnd.ItemName_txt")), true);
		i++;
	}
	SuppressDrawList_ListCtrl.DeleteAllItem();
	i = 0;
	while((i < (currentSubjugationData.ShowGachaSub.Length / 3)))
	{
		addRichListReward(currentSubjugationData.ShowGachaSub[(i * 3)], currentSubjugationData.ShowGachaSub[((i * 3) + 1)], currentSubjugationData.ShowGachaSub[((i * 3) + 2)], probs[probCount]);
		probCount++;
		i++;
	}
	needItemScript.StartNeedItemList(2);
	needItemScript.AddNeedItemClassID(currentSubjugationData.GachaCostItem, INT64(currentSubjugationData.GachaCostNum));
	AddGachaNeedPointListIndex = needItemScript.AddNeedPoint(GetSystemString(13634), "L2UI_EPIC.SuppressWnd.etc_Supprespoint_i00", INT64(1), INT64(0));
	return;
}

function addRichListReward(int nClassID, int nAmount, int ColorIndex, int probInt)
{
	local RichListCtrlRowData rowData;
	local ItemInfo Info;
	local string ItemName;

	rowData.cellDataList.Length = 2;
	Info = GetItemInfoByClassID(nClassID);
	if((Info.ItemNum > INT64(1)))
	{
		Info.bShowCount = true;
	}
	ItemInfoToParam(Info, rowData.szReserved);
	AddRichListCtrlItem(rowData.cellDataList[0].drawitems, Info, 42, 42, 5, 6);
	ItemName = GetItemNameAll(Info);
	Class'Interface.L2Util'.static.GetEllipsisString(ItemName, 400);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, ItemName, GetColor(254, 215, 160, 255), false, 4, 5);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, ("x" $ MakeCostString(string(nAmount))), GTColor().White, true, 52, 0);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, getInstanceL2Util().MakeDecimalPointString(string(probInt), 2, true, true), GTColor().White, true, 20, 15);
	if((ColorIndex == 4))
	{
		rowData.sOverlayTex = "L2UI_CT1.EmptyBtn";
	}
	else
	{
		rowData.sOverlayTex = (("L2UI_EPIC.SuppressWnd.SuppressList0" $ string(ColorIndex)) $ "_Bg");
	}
	rowData.OverlayTexU = 490;
	rowData.OverlayTexV = 51;
	SuppressDrawList_ListCtrl.InsertRecord(rowData);
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Draw_btn":
			ShowPopup();
			break;
		case "ok_btn":
			showDisable(false);
			SuppressDrawResultWnd.HideWindow();
			break;
		case "Main_BTN":
			toggleWindow("SuppressWnd", true, true);
			break;
		default:
			break;
	}
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_PacketID(940):
			ParsePacket_S_EX_SUBJUGATION_GACHA();
			break;
		case EV_PacketID(939):
			ParsePacket_S_EX_SUBJUGATION_GACHA_UI();
			break;
		default:
			break;
	}
	return;
}

function API_C_EX_SUBJUGATION_GACHA_UI(int nID)
{
	local array<byte> stream;
	local UIPacket._C_EX_SUBJUGATION_GACHA_UI packet;

	packet.nID = nID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_SUBJUGATION_GACHA_UI(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(706, stream);
	Debug(("--> C_EX_SUBJUGATION_GACHA_UI " @ string(nID)));
	return;
}

function ParsePacket_S_EX_SUBJUGATION_GACHA_UI()
{
	local UIPacket._S_EX_SUBJUGATION_GACHA_UI packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_SUBJUGATION_GACHA_UI(packet))
	{
		return;
	}
	Debug((" -->  Decode_S_EX_SUBJUGATION_GACHA_UI :  " @ string(packet.nGachaPoint)));
	probs = packet.probs;
	setScriptData(packet.nID);
	needItemScript.ModifyCurrentAmount(AddGachaNeedPointListIndex, INT64(packet.nGachaPoint));
	Debug(("needItemScript.GetMaxNumCanBuy()" @ string(needItemScript.GetMaxNumCanBuy())));
	if((needItemScript.GetMaxNumCanBuy() > INT64(0)))
	{
		if((inputItemScript.GetCount() == INT64(0)))
		{
			inputItemScript.SetCount(INT64(9999));
		}
		else if((inputItemScript.GetCount() > needItemScript.GetMaxNumCanBuy()))
		{
			inputItemScript.SetCount(INT64(int(needItemScript.GetMaxNumCanBuy())));
		}
	}
	else
	{
		inputItemScript.SetCount(INT64(int(needItemScript.GetMaxNumCanBuy())));
	}
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function API_C_EX_SUBJUGATION_GACHA(int nID, int nCount)
{
	local array<byte> stream;
	local UIPacket._C_EX_SUBJUGATION_GACHA packet;

	packet.nID = nID;
	packet.nCount = nCount;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_SUBJUGATION_GACHA(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(707, stream);
	Debug((("--> C_EX_SUBJUGATION_GACHA " @ string(nID)) @ string(nCount)));
	return;
}

function ParsePacket_S_EX_SUBJUGATION_GACHA()
{
	local UIPacket._S_EX_SUBJUGATION_GACHA packet;
	local int i;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_SUBJUGATION_GACHA(packet))
	{
		return;
	}
	Debug(" -->  Decode_S_EX_SUBJUGATION_GACHA :  ");
	API_C_EX_SUBJUGATION_GACHA_UI(currentSubjugationData.Id);
	showDisable(true);
	SuppressDrawResultWnd.ShowWindow();
	SuppressDrawResultWnd.SetFocus();
	playResultEffectViewPort("LineageEffect2.ui_upgrade_succ");
	PlaySound("ItemSound3.enchant_success");
	SuppressDrawResulrtList_ListCtrl.DeleteAllItem();
	ResultItemArray.Length = 0;
	i = 0;
	while((i < packet.vItems.Length))
	{
		Debug(("-nClassID" @ string(packet.vItems[i].nClassID)));
		Debug(("-nAmount" @ string(packet.vItems[i].nAmount)));
		Debug(("-colorIndex" @ string(getResultColorIndex(packet.vItems[i].nClassID, packet.vItems[i].nAmount))));
		ResultItemArray.Length = (ResultItemArray.Length + 1);
		ResultItemArray[(ResultItemArray.Length - 1)].ClassID = packet.vItems[i].nClassID;
		ResultItemArray[(ResultItemArray.Length - 1)].ItemNum = packet.vItems[i].nAmount;
		ResultItemArray[(ResultItemArray.Length - 1)].ColorIndex = getResultColorIndex(packet.vItems[i].nClassID, packet.vItems[i].nAmount);
		i++;
	}
	// ResultItemArray.Sort(SortResultItemDelegate);   // array.Sort() unsupported by this compiler
	i = 0;
	while((i < ResultItemArray.Length))
	{
		addRichListResult(ResultItemArray[i].ClassID, ResultItemArray[i].ItemNum, ResultItemArray[i].ColorIndex);
		i++;
	}
	return;
}

delegate int SortResultItemDelegate(resultItem a1, resultItem a2)
{
	if((a1.ColorIndex > a2.ColorIndex))
	{
		return -1;
	}
	return 0;
}

function addRichListResult(int nClassID, int nAmount, int ColorIndex)
{
	local RichListCtrlRowData rowData;
	local ItemInfo Info;
	local string ItemName;

	rowData.cellDataList.Length = 1;
	Info = GetItemInfoByClassID(nClassID);
	if((Info.ItemNum > INT64(1)))
	{
		Info.bShowCount = true;
	}
	ItemInfoToParam(Info, rowData.szReserved);
	AddRichListCtrlItem(rowData.cellDataList[0].drawitems, Info, 32, 32, 5, 14);
	ItemName = GetItemNameAll(Info);
	Class'Interface.L2Util'.static.GetEllipsisString(ItemName, 200);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, ItemName, GetColor(254, 215, 160, 255), false, 4, 4);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, ("x" $ MakeCostString(string(nAmount))), GTColor().White, true, 40, 0);
	if((ColorIndex == 4))
	{
		rowData.sOverlayTex = "L2UI_CT1.EmptyBtn";
	}
	else
	{
		rowData.sOverlayTex = (("L2UI_EPIC.SuppressWnd.SuppressItemResult0" $ string(ColorIndex)) $ "_Bg");
	}
	Debug(("RowData.sOverlayTex: " @ rowData.sOverlayTex));
	rowData.OverlayTexU = 310;
	rowData.OverlayTexV = 61;
	SuppressDrawResulrtList_ListCtrl.InsertRecord(rowData);
	return;
}

function playResultEffectViewPort(string effectPath)
{
	local Vector offset;

	if((effectPath == "LineageEffect2.ui_upgrade_succ"))
	{
		offset.X = 10.0000000;
		offset.Y = -5.0000000;
		EffectViewport02.SetScale(6.0000000);
		EffectViewport02.SetCameraDistance(1300.0000000);
		EffectViewport02.SetOffset(offset);
	}
	else if((effectPath == "LineageEffect.d_firework_a"))
	{
		offset.X = 10.0000000;
		offset.Y = -5.0000000;
		EffectViewport02.SetScale(6.0000000);
		EffectViewport02.SetCameraDistance(1300.0000000);
		EffectViewport02.SetOffset(offset);
	}
	EffectViewport02.SetFocus();
	EffectViewport02.SpawnEffect(effectPath);
	return;
}

function int getResultColorIndex(int ClassID, int ItemNum)
{
	local int i;

	i = 0;
	while((i < (currentSubjugationData.ShowGachaMain.Length / 3)))
	{
		if((ClassID == currentSubjugationData.ShowGachaMain[(i * 3)]))
		{
			return currentSubjugationData.ShowGachaMain[((i * 3) + 2)];
		}
		i++;
	}
	i = 0;
	while((i < (currentSubjugationData.ShowGachaSub.Length / 3)))
	{
		if((ClassID == currentSubjugationData.ShowGachaSub[(i * 3)]))
		{
			return currentSubjugationData.ShowGachaSub[((i * 3) + 2)];
		}
		i++;
	}
	return 4;
}

function SetPopupScript()
{
	local WindowHandle popExpandWnd;
	local UIControlDialogAssets popupExpandScript;
	local WindowHandle disableWnd;

	popExpandWnd = GetWindowHandle((m_Windowname $ ".UIControlDialogAsset"));
	popupExpandScript = Class'Interface.UIControlDialogAssets'.static.InitScript(popExpandWnd);
	disableWnd = GetWindowHandle((m_Windowname $ ".disable_tex"));
	popupExpandScript.SetDisableWindow(disableWnd);
	Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop((m_Windowname $ ".disable_tex"), false);
	return;
}

function UIControlDialogAssets GetPopupExpandScript()
{
	local WindowHandle popExpandWnd;

	popExpandWnd = GetWindowHandle((m_Windowname $ ".UIControlDialogAsset"));
	return UIControlDialogAssets(popExpandWnd.GetScript());
}

function ShowPopup()
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = GetPopupExpandScript();
	popupExpandScript.SetDialogDesc(GetSystemString(13631));
	popupExpandScript.Show();
	popupExpandScript.OKButton.EnableWindow();
	popupExpandScript.DelegateOnClickBuy = OnDialogOK;
	popupExpandScript.DelegateOnCancel = OnClickCancelDialog;
	showDisable(true);
	return;
}

function OnDialogOK()
{
	API_C_EX_SUBJUGATION_GACHA(currentSubjugationData.Id, int(inputItemScript.GetCount()));
	GetPopupExpandScript().Hide();
	showDisable(false);
	return;
}

function OnClickCancelDialog()
{
	GetPopupExpandScript().Hide();
	showDisable(false);
	return;
}

function InitNeedItem()
{
	needItemWnd.SetScript("UIControlNeedItemList");
	needItemScript = UIControlNeedItemList(needItemWnd.GetScript());
	needItemScript.SetRichListControler(NeedItemRichListCtrl);
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
	inputItemScript.Buy_Btn = GetButtonHandle((m_Windowname $ ".Draw_btn"));
	return;
}

function INT64 MaxNumCanBuy()
{
	return INT64(Min(int(needItemScript.GetMaxNumCanBuy()), currentSubjugationData.MaxUsePoint));
}

function OnItemCountChanged(INT64 ItemCount)
{
	ItemCount = MAX64(INT64(1), ItemCount);
	needItemScript.SetBuyNum(ItemCount);
	return;
}

function showDisable(bool bShow)
{
	if(bShow)
	{
		GetWindowHandle((m_Windowname $ ".disable_tex")).ShowWindow();
		GetEditBoxHandle((m_Windowname $ ".inputItemWnd.ItemCount_EditBox")).HideWindow();
	}
	else
	{
		GetWindowHandle((m_Windowname $ ".disable_tex")).HideWindow();
		GetEditBoxHandle((m_Windowname $ ".inputItemWnd.ItemCount_EditBox")).ShowWindow();
	}
	return;
}

function OnESCKey()
{
	SuppressDrawList_ListCtrl.SetFocus();
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	if(SuppressDrawResultWnd.IsShowWindow())
	{
		showDisable(false);
		SuppressDrawResultWnd.HideWindow();
	}
	else
	{
		GetWindowHandle(m_Windowname).HideWindow();
	}
	return;
}

defaultproperties
{
	m_Windowname="SuppressDrawWnd"
}
