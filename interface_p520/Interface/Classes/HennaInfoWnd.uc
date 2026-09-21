class HennaInfoWnd extends UICommonAPI
	dependson(UIPacket);

const HENNA_EQUIP = 1;
const HENNA_UNEQUIP = 2;
const DIALOG_ID_ADD = 12302;
const DIALOG_ID_DEL = 12303;

var int m_iState;
var int m_iHennaID;
var int m_iClassID;
var int m_iSeverID;
var bool bHasNeedDyeItem;
var int nSelectCostItemClassID;
var TextBoxHandle txtAddName;
var UIControlNeedItemList needItemListEquip;
var UIControlNeedItemList selectNeedItemListEquip;
var UIControlNeedItemList needItemListUnEquip;
var UIControlNeedItemList selectNeedItemListUnEquip;

function OnRegisterEvent()
{
	RegisterEvent(1660);
	RegisterEvent(1690);
	RegisterEvent(8000);
	RegisterEvent((100000 + 983));
	RegisterEvent((100000 + 984));
	RegisterEvent(1710);
	RegisterEvent(1720);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	OnRegisterEvent();
	GetTextBoxHandle("HennaInfoWnd.HennaInfoWndUnEquip.txtSTRString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3366), 154));
	GetTextBoxHandle("HennaInfoWnd.HennaInfoWndUnEquip.txtDEXString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3368), 154));
	GetTextBoxHandle("HennaInfoWnd.HennaInfoWndUnEquip.txtCONString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3370), 154));
	GetTextBoxHandle("HennaInfoWnd.HennaInfoWndUnEquip.txtINTString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3367), 154));
	GetTextBoxHandle("HennaInfoWnd.HennaInfoWndUnEquip.txtWITString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3369), 154));
	GetTextBoxHandle("HennaInfoWnd.HennaInfoWndUnEquip.txtMENString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3371), 154));
	GetTextBoxHandle("HennaInfoWnd.HennaInfoWndUnEquip.txtLUCString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3372), 154));
	GetTextBoxHandle("HennaInfoWnd.HennaInfoWndUnEquip.txtCHAString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3373), 154));
	initUIControlNeedItemList();
	txtAddName = GetTextBoxHandle("HennaInfoWnd.txtTattooAddName");
	return;
}

function initUIControlNeedItemList()
{
	needItemListEquip = new Class'Interface.UIControlNeedItemList';
	needItemListEquip.SetRichListControler(GetMeRichListCtrl("HennaInfoWndEquip.NeedItemRichListCtrl"));
	needItemListEquip.StartNeedItemList(1);
	needItemListEquip.SetHideMyNum(true);
	selectNeedItemListEquip = new Class'Interface.UIControlNeedItemList';
	selectNeedItemListEquip.SetRichListControler(GetMeRichListCtrl("HennaInfoWndEquip.NeedItemSelectDialog_wnd.NeedItemSelect_ListCtrl"));
	GetMeRichListCtrl("HennaInfoWndEquip.NeedItemSelectDialog_wnd.NeedItemSelect_ListCtrl").SetSelectable(true);
	needItemListUnEquip = new Class'Interface.UIControlNeedItemList';
	needItemListUnEquip.SetRichListControler(GetMeRichListCtrl("HennaInfoWndUnEquip.NeedItemRichListCtrl"));
	needItemListUnEquip.StartNeedItemList(1);
	needItemListUnEquip.SetHideMyNum(true);
	selectNeedItemListUnEquip = new Class'Interface.UIControlNeedItemList';
	selectNeedItemListUnEquip.SetRichListControler(GetMeRichListCtrl("HennaInfoWndUnEquip.NeedItemSelectDialog_wnd.NeedItemSelect_ListCtrl"));
	GetMeRichListCtrl("HennaInfoWndUnEquip.NeedItemSelectDialog_wnd.NeedItemSelect_ListCtrl").SetSelectable(true);
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnPrev":
			if((m_iState == 1))
			{
				RequestHennaItemList();
			}
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd");
			break;
		case "btnOK":
			if((m_iState == 1))
			{
				DialogSetID(12302);
				DialogSetCancelD(12302);
				DialogSetDefaultCancle();
				DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemString(13906));
			}
			break;
		case "btnextract":
			if((m_iState == 2))
			{
				DialogSetID(12303);
				DialogSetCancelD(12303);
				DialogSetDefaultCancle();
				DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemString(13907));
			}
			break;
		case "EXIT_Btn":
			OnReceivedCloseUI();
			break;
		case "NeedItemSelectArrow_btn":
			onToggleSelectNeedItem();
			break;
		default:
			break;
	}
	return;
}

function onToggleSelectNeedItem()
{
	if((m_iState == 1))
	{
		if(GetMeWindow("HennaInfoWndEquip.NeedItemSelectDialog_wnd").IsShowWindow())
		{
			GetMeWindow("HennaInfoWndEquip.NeedItemSelectDialog_wnd").HideWindow();
		}
		else
		{
			GetMeWindow("HennaInfoWndEquip.NeedItemSelectDialog_wnd").ShowWindow();
		}
	}
	else if(GetMeWindow("HennaInfoWndUnEquip.NeedItemSelectDialog_wnd").IsShowWindow())
	{
		GetMeWindow("HennaInfoWndUnEquip.NeedItemSelectDialog_wnd").HideWindow();
	}
	else
	{
		GetMeWindow("HennaInfoWndUnEquip.NeedItemSelectDialog_wnd").ShowWindow();
	}
	return;
}

function OnShow()
{
	if((m_iState == 1))
	{
		setWindowTitleByString(GetSystemString(651));
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.HennaInfoWndUnEquip");
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.HennaInfoWndEquip");
	}
	else if((m_iState == 2))
	{
		setWindowTitleByString(GetSystemString(652));
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.HennaInfoWndEquip");
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.HennaInfoWndUnEquip");
	}
	return;
}

function OnHide()
{
	getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "HennaListWnd");
	if(DialogIsMine())
	{
		DialogHide();
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	if(!getInstanceUIData().GetIsClassicServer())
	{
		return;
	}
	switch(Event_ID)
	{
		case 1710:
			if(DialogIsMine())
			{
				if((DialogGetID() == 12302))
				{
					API_C_EX_NEW_HENNA_EQUIP(HennaMenuWnd(GetScript("HennaMenuWnd")).getSelectIndexSlot(), m_iSeverID, nSelectCostItemClassID);
				}
				else if((DialogGetID() == 12303))
				{
					API_C_EX_NEW_HENNA_UNEQUIP(nSelectCostItemClassID);
				}
			}
			break;
		case 1720:
			break;
		case 1660:
			m_iState = 1;
			GetButtonHandle("HennaInfoWnd.btnPrev").ShowWindow();
			GetButtonHandle("HennaInfoWnd.btnOK").ShowWindow();
			GetButtonHandle("HennaInfoWnd.btnOK").DisableWindow();
			GetButtonHandle("HennaInfoWnd.btnextract").HideWindow();
			OnShow();
			ShowHennaInfoWnd(param);
			break;
		case 1690:
			m_iState = 2;
			GetButtonHandle("HennaInfoWnd.btnPrev").HideWindow();
			GetButtonHandle("HennaInfoWnd.btnOK").HideWindow();
			GetButtonHandle("HennaInfoWnd.btnextract").ShowWindow();
			GetButtonHandle("HennaInfoWnd.btnextract").DisableWindow();
			OnShow();
			ShowHennaInfoWnd(param);
			break;
		case 8000:
			if(getInstanceUIData().GetIsClassicServer())
			{
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.txtLUCString");
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.txtLUCBefore");
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.txtLUCArrow");
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.txtLUCAfter");
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.txtCHAString");
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.txtCHABefore");
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.txtCHAArrow");
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.txtCHAAfter");
			}
			else
			{
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.txtLUCString");
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.txtLUCBefore");
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.txtLUCArrow");
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.txtLUCAfter");
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.txtCHAString");
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.txtCHABefore");
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.txtCHAArrow");
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.txtCHAAfter");
			}
			break;
		case (100000 + 983):
			ParsePacket_S_EX_NEW_HENNA_EQUIP();
			break;
		case (100000 + 984):
			ParsePacket_S_EX_NEW_HENNA_UNEQUIP();
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_NEW_HENNA_EQUIP()
{
	local UIPacket._S_EX_NEW_HENNA_EQUIP packet;
	local ItemInfo dyeItemInfo;
	local int dyeItemClassID;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_NEW_HENNA_EQUIP(packet))
	{
		return;
	}
	Debug((((" -->  Decode_S_EX_NEW_HENNA_EQUIP :  " @ string(packet.cSlotID)) @ string(packet.nHennaID)) @ string(packet.cSuccess)));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd");
	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HennaMenuWnd");
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus("HennaMenuWnd");
	Class'NWindow.UIDATA_HENNA'.static.GetHennaDyeItemClassID(packet.nHennaID, dyeItemClassID);
	dyeItemInfo = GetItemInfoByClassID(dyeItemClassID);
	Debug(("장착 dyeItemInfo" @ dyeItemInfo.Name));  // EN?: Mounting dyeItemInfo
	if((packet.cSuccess > 0))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(877));
	}
	return;
}

function ParsePacket_S_EX_NEW_HENNA_UNEQUIP()
{
	local UIPacket._S_EX_NEW_HENNA_UNEQUIP packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_NEW_HENNA_UNEQUIP(packet))
	{
		return;
	}
	Debug(((" -->  Decode_S_EX_NEW_HENNA_UNEQUIP :  " @ string(packet.cSlotID)) @ string(packet.cSuccess)));
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd");
	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HennaMenuWnd");
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus("HennaMenuWnd");
	if((packet.cSuccess > 0))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(878));
	}
	return;
}

event OnClickListCtrlRecord(string strID)
{
	local int selectNeedItemIndex, selectedClassID;
	local INT64 selectedAmount;

	Debug(("strID" @ strID));
	if((m_iState == 1))
	{
		selectNeedItemIndex = GetMeRichListCtrl("HennaInfoWndEquip.NeedItemSelectDialog_wnd.NeedItemSelect_ListCtrl").GetSelectedIndex();
		selectNeedItemListEquip.GetItemClassID(selectNeedItemIndex, selectedClassID);
		selectNeedItemListEquip.GetItemNeedAmount(selectNeedItemIndex, selectedAmount);
		nSelectCostItemClassID = selectedClassID;
		needItemListEquip.CleariObjects();
		needItemListEquip.AddNeedItemClassID(selectedClassID, selectedAmount);
		needItemListEquip.SetBuyNum(INT64(1));
		GetMeWindow("HennaInfoWndEquip.NeedItemSelectDialog_wnd").HideWindow();
		GetMeWindow("HennaInfoWndEquip.NeedItemSelect_wnd").HideWindow();
		if((bHasNeedDyeItem && needItemListEquip.GetCanBuy()))
		{
			GetMeButton("btnOK").EnableWindow();
			GetMeButton("btnOK").ClearTooltip();
		}
		else
		{
			GetMeButton("btnOK").DisableWindow();
			GetMeButton("btnOK").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13448)));
		}
	}
	else
	{
		selectNeedItemIndex = GetMeRichListCtrl("HennaInfoWndUnEquip.NeedItemSelectDialog_wnd.NeedItemSelect_ListCtrl").GetSelectedIndex();
		selectNeedItemListUnEquip.GetItemClassID(selectNeedItemIndex, selectedClassID);
		selectNeedItemListUnEquip.GetItemNeedAmount(selectNeedItemIndex, selectedAmount);
		nSelectCostItemClassID = selectedClassID;
		needItemListUnEquip.CleariObjects();
		needItemListUnEquip.AddNeedItemClassID(selectedClassID, selectedAmount);
		needItemListUnEquip.SetBuyNum(INT64(1));
		GetMeWindow("HennaInfoWndUnEquip.NeedItemSelectDialog_wnd").HideWindow();
		GetMeWindow("HennaInfoWndUnEquip.NeedItemSelect_wnd").HideWindow();
		if(needItemListUnEquip.GetCanBuy())
		{
			GetMeButton("btnextract").EnableWindow();
			GetMeButton("btnextract").ClearTooltip();
		}
		else
		{
			GetMeButton("btnextract").DisableWindow();
			GetMeButton("btnextract").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13448)));
		}
	}
	return;
}

function ShowHennaInfoWnd(string param)
{
	local INT64 iAdena;
	local string strDyeName, strDyeIconName;
	local int iHennaID, iClassID;
	local INT64 iNum;
	local string strTattooName, strTattooAddName, strTattooIconName;
	local int iINTnow, iINTchange, iSTRnow, iSTRchange, iCONnow, iCONchange, iMENnow, iMENchange, iDEXnow, iDEXchange, iWITnow, iWITchange, iLUCnow, iLUCchange, iCHAnow, iCHAchange, dyeItemlevel, iNeedCount, iCancelCount;
	local Color Col;
	local int i, nWearFeeItemListCount, nWearFeeItemClassID, nWearFeeItemAmount, nCancelFeeItemListCount, nCancelFeeItemClassID, nCancelFeeItemAmount;
	local array<ItemInfo> itemInfoArray;

	Debug(("param" @ param));
	ParseINT64(param, "Adena", iAdena);
	ParseString(param, "DyeIconName", strDyeIconName);
	ParseString(param, "DyeName", strDyeName);
	ParseInt(param, "HennaID", iHennaID);
	ParseInt(param, "ClassID", iClassID);
	ParseString(param, "TattooIconName", strTattooIconName);
	ParseString(param, "TattooName", strTattooName);
	ParseString(param, "TattooAddName", strTattooAddName);
	ParseInt(param, "INTnow", iINTnow);
	ParseInt(param, "INTchange", iINTchange);
	ParseInt(param, "STRnow", iSTRnow);
	ParseInt(param, "STRchange", iSTRchange);
	ParseInt(param, "CONnow", iCONnow);
	ParseInt(param, "CONchange", iCONchange);
	ParseInt(param, "MENnow", iMENnow);
	ParseInt(param, "MENchange", iMENchange);
	ParseInt(param, "DEXnow", iDEXnow);
	ParseInt(param, "DEXchange", iDEXchange);
	ParseInt(param, "WITnow", iWITnow);
	ParseInt(param, "WITchange", iWITchange);
	ParseInt(param, "LUCnow", iLUCnow);
	ParseInt(param, "LUCchange", iLUCchange);
	ParseInt(param, "CHAnow", iCHAnow);
	ParseInt(param, "CHAchange", iCHAchange);
	ParseINT64(param, "NumOfItem", iNum);
	ParseInt(param, "WearFeeItemListCount", nWearFeeItemListCount);
	m_iHennaID = iHennaID;
	m_iClassID = iClassID;
	Class'NWindow.UIDATA_HENNA'.static.GetHennaDyeItemLevel(iHennaID, dyeItemlevel);
	Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(m_iClassID, itemInfoArray);
	m_iSeverID = itemInfoArray[0].Id.ServerID;
	txtAddName.SetText("");
	txtAddName.SetTooltipText("");
	if((m_iState == 1))
	{
		ParseInt(param, "NeedCount", iNeedCount);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtDyeInfo", GetSystemString(638));
		Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("HennaInfoWnd.textureDyeIconName", strDyeIconName);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtDyeName", strDyeName);
		Col.R = 168;
		Col.G = 168;
		Col.B = 168;
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtFee", (GetSystemString(637) $ " : "));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtFee", Col);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooInfo", GetSystemString(639));
		Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("HennaInfoWnd.textureTattooIconName", strTattooIconName);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooName", strTattooName);
		if((Len(strTattooAddName) > 0))
		{
			txtAddName.SetText(GetSystemString(5872));
			txtAddName.SetTooltipType("text");
			txtAddName.SetTooltipText(strTattooAddName);
		}
		if((INT64(iNeedCount) <= iNum))
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtDyeNeedItem", GTColor().White);
			bHasNeedDyeItem = true;
		}
		else
		{
			Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtDyeNeedItem", GTColor().Red);
			bHasNeedDyeItem = false;
		}
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtDyeNeedItem", MakeFullSystemMsg(GetSystemMessage(2781), string(iNeedCount)));
		selectNeedItemListEquip.CleariObjects();
		if((nWearFeeItemListCount == 0))
		{
			GetMeWindow("HennaInfoWndEquip.NeedItemSelectArrow_btn").HideWindow();
			GetMeWindow("HennaInfoWndEquip.NeedItemSelect_wnd").ShowWindow();
			GetMeTextBox("HennaInfoWndEquip.NeedItemSelect_wnd.text").SetText(GetSystemString(13466));
			GetMeWindow("HennaInfoWndEquip.NeedItemSelectDialog_wnd").HideWindow();
			nSelectCostItemClassID = 0;
			if(bHasNeedDyeItem)
			{
				GetMeButton("btnOK").EnableWindow();
				GetMeButton("btnOK").ClearTooltip();
			}
			else
			{
				GetMeButton("btnOK").DisableWindow();
				GetMeButton("btnOK").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13448)));
			}
		}
		else if((nWearFeeItemListCount == 1))
		{
			GetMeWindow("HennaInfoWndEquip.NeedItemSelectArrow_btn").HideWindow();
			i = 0;
			while((i < nWearFeeItemListCount))
			{
				ParseInt(param, ("WearFeeItemClassID_" $ string(i)), nWearFeeItemClassID);
				ParseInt(param, ("WearFeeItemAmount_" $ string(i)), nWearFeeItemAmount);
				i++;
			}
			needItemListEquip.CleariObjects();
			needItemListEquip.CleariObjects();
			needItemListEquip.AddNeedItemClassID(nWearFeeItemClassID, INT64(nWearFeeItemAmount));
			needItemListEquip.SetBuyNum(INT64(1));
			nSelectCostItemClassID = nWearFeeItemClassID;
			GetMeWindow("HennaInfoWndEquip.NeedItemSelect_wnd").HideWindow();
			GetMeWindow("HennaInfoWndEquip.NeedItemSelectDialog_wnd").HideWindow();
			if((bHasNeedDyeItem && needItemListEquip.GetCanBuy()))
			{
				GetMeButton("btnOK").EnableWindow();
				GetMeButton("btnOK").ClearTooltip();
			}
			else
			{
				GetMeButton("btnOK").DisableWindow();
				GetMeButton("btnOK").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13448)));
			}
		}
		else
		{
			GetMeWindow("HennaInfoWndEquip.NeedItemSelectArrow_btn").ShowWindow();
			GetMeWindow("HennaInfoWndEquip.NeedItemSelectDialog_wnd").SetWindowSize(284, ((40 * nWearFeeItemListCount) + 12));
			selectNeedItemListEquip.StartNeedItemList(nWearFeeItemListCount);
			GetMeRichListCtrl("HennaInfoWndEquip.NeedItemSelectDialog_wnd.NeedItemSelect_ListCtrl").AdjustShowRow(nWearFeeItemListCount);
			GetMeRichListCtrl("HennaInfoWndEquip.NeedItemSelectDialog_wnd.NeedItemSelect_ListCtrl").SetWindowSize(280, (40 * nWearFeeItemListCount));
			selectNeedItemListEquip.SetBuyNum(INT64(1));
			i = 0;
			while((i < nWearFeeItemListCount))
			{
				ParseInt(param, ("WearFeeItemClassID_" $ string(i)), nWearFeeItemClassID);
				ParseInt(param, ("WearFeeItemAmount_" $ string(i)), nWearFeeItemAmount);
				selectNeedItemListEquip.AddNeedItemClassID(nWearFeeItemClassID, INT64(nWearFeeItemAmount));
				i++;
			}
			GetMeTextBox("HennaInfoWndUnEquip.NeedItemSelect_wnd.text").SetText(GetSystemString(14054));
			GetMeWindow("HennaInfoWndEquip.NeedItemSelect_wnd").ShowWindow();
			GetMeWindow("HennaInfoWndEquip.NeedItemSelectDialog_wnd").ShowWindow();
			GetMeWindow("HennaInfoWndEquip.NeedItemSelectDialog_wnd").SetFocus();
		}
	}
	else if((m_iState == 2))
	{
		ParseInt(param, "CancelCount", iCancelCount);
		ParseInt(param, "CancelFeeItemListCount", nCancelFeeItemListCount);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooInfoUnEquip", GetSystemString(639));
		Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("HennaInfoWnd.textureTattooIconNameUnEquip", strTattooIconName);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooNameUnEquip", ((GetSystemString(652) $ ":") $ strTattooName));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooAddNameUnEquip", strTattooAddName);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtDyeInfoUnEquip", GetSystemString(638));
		Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("HennaInfoWnd.textureDyeIconNameUnEquip", strDyeIconName);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtDyeNameUnEquip", strDyeName);
		Col.R = 168;
		Col.G = 168;
		Col.B = 168;
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtFeeUnEquip", (GetSystemString(637) $ " : "));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtFeeUnEquip", Col);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.HennaInfoWndUnEquip.txtTattooNameStepUnEquip", MakeFullSystemMsg(GetSystemMessage(5203), string(dyeItemlevel)));
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.HennaInfoWndUnEquip.txtDyeExtractItemUnEquip", MakeFullSystemMsg(GetSystemMessage(2781), string(iCancelCount)));
		Debug(("nCancelFeeItemListCount" @ string(nCancelFeeItemListCount)));
		if((nCancelFeeItemListCount == 0))
		{
			GetMeButton("HennaInfoWndUnEquip.NeedItemSelectArrow_btn").HideWindow();
			GetMeWindow("HennaInfoWndUnEquip.NeedItemSelect_wnd").ShowWindow();
			GetMeTextBox("HennaInfoWndUnEquip.NeedItemSelect_wnd.text").SetText(GetSystemString(13466));
			GetMeWindow("HennaInfoWndEquip.NeedItemSelectDialog_wnd").HideWindow();
			nSelectCostItemClassID = 0;
			GetMeButton("btnextract").EnableWindow();
		}
		else if((nCancelFeeItemListCount == 1))
		{
			GetMeButton("HennaInfoWndUnEquip.NeedItemSelectArrow_btn").HideWindow();
			i = 0;
			while((i < nCancelFeeItemListCount))
			{
				ParseInt(param, ("CancelFeeItemClassID_" $ string(i)), nCancelFeeItemClassID);
				ParseInt(param, ("CancelFeeItemAmount_" $ string(i)), nCancelFeeItemAmount);
				i++;
			}
			needItemListUnEquip.CleariObjects();
			needItemListUnEquip.CleariObjects();
			needItemListUnEquip.AddNeedItemClassID(nCancelFeeItemClassID, INT64(nCancelFeeItemAmount));
			needItemListUnEquip.SetBuyNum(INT64(1));
			nSelectCostItemClassID = nCancelFeeItemClassID;
			GetMeWindow("HennaInfoWndUnEquip.NeedItemSelect_wnd").HideWindow();
			GetMeWindow("HennaInfoWndUnEquip.NeedItemSelectDialog_wnd").HideWindow();
			if(needItemListUnEquip.GetCanBuy())
			{
				GetMeButton("btnextract").EnableWindow();
				GetMeButton("btnextract").ClearTooltip();
			}
			else
			{
				GetMeButton("btnextract").DisableWindow();
				GetMeButton("btnextract").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13448)));
			}
		}
		else
		{
			GetMeWindow("HennaInfoWndUnEquip.NeedItemSelectArrow_btn").ShowWindow();
			selectNeedItemListEquip.CleariObjects();
			GetMeTextBox("HennaInfoWndUnEquip.NeedItemSelect_wnd.text").SetText(GetSystemString(14054));
			GetMeWindow("HennaInfoWndUnEquip.NeedItemSelectDialog_wnd").SetWindowSize(284, ((40 * nCancelFeeItemListCount) + 12));
			selectNeedItemListUnEquip.StartNeedItemList(nCancelFeeItemListCount);
			GetMeRichListCtrl("HennaInfoWndUnEquip.NeedItemSelectDialog_wnd.NeedItemSelect_ListCtrl").AdjustShowRow(nCancelFeeItemListCount);
			GetMeRichListCtrl("HennaInfoWndUnEquip.NeedItemSelectDialog_wnd.NeedItemSelect_ListCtrl").SetWindowSize(280, (40 * nCancelFeeItemListCount));
			selectNeedItemListUnEquip.SetBuyNum(INT64(1));
			i = 0;
			while((i < nCancelFeeItemListCount))
			{
				ParseInt(param, ("CancelFeeItemClassID_" $ string(i)), nCancelFeeItemClassID);
				ParseInt(param, ("CancelFeeItemAmount_" $ string(i)), nCancelFeeItemAmount);
				selectNeedItemListUnEquip.AddNeedItemClassID(nCancelFeeItemClassID, INT64(nCancelFeeItemAmount));
				i++;
			}
			GetMeWindow("HennaInfoWndUnEquip.NeedItemSelect_wnd").ShowWindow();
			GetMeWindow("HennaInfoWndUnEquip.NeedItemSelectDialog_wnd").ShowWindow();
			GetMeWindow("HennaInfoWndUnEquip.NeedItemSelectDialog_wnd").SetFocus();
		}
	}
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooNameStep", MakeFullSystemMsg(GetSystemMessage(5203), string(dyeItemlevel)));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtSTRBefore", iSTRnow);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtSTRAfter", iSTRchange);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtDEXBefore", iDEXnow);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtDEXAfter", iDEXchange);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtCONBefore", iCONnow);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtCONAfter", iCONchange);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtINTBefore", iINTnow);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtINTAfter", iINTchange);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtWITBefore", iWITnow);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtWITAfter", iWITchange);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtMENBefore", iMENnow);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtMENAfter", iMENchange);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtLUCBefore", iLUCnow);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtLUCAfter", iLUCchange);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtCHABefore", iCHAnow);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtCHAAfter", iCHAchange);
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaListWnd");
	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd");
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus("HennaInfoWnd");
	return;
}

function API_C_EX_NEW_HENNA_EQUIP(int nSlotID, int nItemSid, int nCostItemId)
{
	local array<byte> stream;
	local UIPacket._C_EX_NEW_HENNA_EQUIP packet;

	packet.cSlotID = nSlotID;
	packet.nItemSid = nItemSid;
	packet.nCostItemId = nCostItemId;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_NEW_HENNA_EQUIP(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(747, stream);
	Debug(((("Api Call -----> C_EX_NEW_HENNA_EQUIP" @ string(packet.cSlotID)) @ string(packet.nItemSid)) @ string(packet.nCostItemId)));
	return;
}

function API_C_EX_NEW_HENNA_UNEQUIP(int nCostItemId)
{
	local array<byte> stream;
	local UIPacket._C_EX_NEW_HENNA_UNEQUIP packet;

	packet.cSlotID = HennaMenuWnd(GetScript("HennaMenuWnd")).getSelectIndexSlot();
	packet.nCostItemId = nCostItemId;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_NEW_HENNA_UNEQUIP(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(748, stream);
	Debug((("Api Call -----> C_EX_NEW_HENNA_UNEQUIP" @ string(packet.cSlotID)) @ string(packet.nCostItemId)));
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("HennaInfoWnd").HideWindow();
	ShowWindowWithFocus("HennaMenuWnd");
	return;
}
