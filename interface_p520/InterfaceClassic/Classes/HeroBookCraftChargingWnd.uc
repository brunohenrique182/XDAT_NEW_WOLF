class HeroBookCraftChargingWnd extends UICommonAPI
	dependson(UIPacket);

const DIALOG_TOP_TO_BOTTOM = 111;
const DIALOG_BOTTOM_TO_TOP = 222;
const PRICE_ADENA_CLASSID = 57;

var WindowHandle m_dialogWnd;
var string m_Windowname;
var WindowHandle Me;
var WindowHandle m_Confirm_Wnd;
var TextureHandle statusGaugeHighlight;
var TextBoxHandle statusGaugeMaxText;
var ItemWindowHandle ReceiveSkill_Item;
var TextBoxHandle SkillLevel_textbox;
var TextBoxHandle SkillName_textbox;
var StatusBarHandle PossiblePointStatusBar;
var StatusBarHandle statusCraftPointStatusBar;
var ItemWindowHandle m_topList;
var ItemWindowHandle m_bottomList;
var int nCurrentHeroPoint;
var int nCurrentLevel;
var int nCommission;
var int nMaxHeroPoint;
var INT64 chargeAdded;
var INT64 chargeCurrent;
var INT64 chargePrice;
var bool bProgress;
var int nCurrentChargeProb;
var array<UIPacket._PkHeroBook> books;

function OnRegisterEvent()
{
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent((100000 + 1047));
	RegisterEvent((100000 + 1049));
	RegisterEvent((100000 + 1051));
	RegisterEvent(9570);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("HeroBookCraftChargingWnd");
	m_Confirm_Wnd = GetWindowHandle("HeroBookCraftChargingWnd.Confirm_Wnd");
	statusGaugeHighlight = GetTextureHandle("HeroBookCraftChargingWnd.statusGaugeHighlight");
	statusGaugeMaxText = GetTextBoxHandle("HeroBookCraftChargingWnd.statusGaugeMaxText");
	ReceiveSkill_Item = GetItemWindowHandle("HeroBookCraftChargingWnd.ReceiveSkill_Item");
	SkillLevel_textbox = GetTextBoxHandle("HeroBookCraftChargingWnd.SkillLevel_textbox");
	SkillName_textbox = GetTextBoxHandle("HeroBookCraftChargingWnd.SkillName_textbox");
	PossiblePointStatusBar = GetStatusBarHandle("HeroBookCraftChargingWnd.PossiblePoint");
	statusCraftPointStatusBar = GetStatusBarHandle("HeroBookCraftChargingWnd.statusCraftPoint");
	m_topList = GetItemWindowHandle("HeroBookCraftChargingWnd.TopList");
	m_bottomList = GetItemWindowHandle("HeroBookCraftChargingWnd.BottomList");
	statusCraftPointStatusBar.SetDrawPoint(false);
	PossiblePointStatusBar.SetDrawPoint(false);
	return;
}

function Load()
{
	local StatusBaseHandle Handle;

	Handle = PossiblePointStatusBar.GetSelfScript();
	PossiblePointStatusBar.SetGaugeColor(7, GTColor().Green2);
	return;
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	refreshSetting();
	return;
}

function OnHide()
{
	m_topList.EnableWindow();
	m_bottomList.EnableWindow();
	if(DialogIsMine())
	{
		DialogHide();
	}
	return;
}

function SetStatusCraftPoint()
{
	Log((" --- SetPoint : " $ string(chargeCurrent)));
	statusCraftPointStatusBar.SetPoint(chargeCurrent, INT64(nMaxHeroPoint));
	PossiblePointStatusBar.SetPoint((chargeCurrent + chargeAdded), INT64(nMaxHeroPoint));
	if((INT64(nMaxHeroPoint) <= (chargeCurrent + chargeAdded)))
	{
		statusGaugeMaxText.SetText(GetSystemString(3451));
	}
	else
	{
		statusGaugeMaxText.SetText(getInstanceL2Util().MakeDecimalPointString(string(nCurrentChargeProb), 2, true, true));
	}
	return;
}

function SetAdenaItem()
{
	local ItemInfo iInfo;
	local ItemID iID;

	iID.ClassID = 57;
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(iID, iInfo);
	GetItemWindowHandle((m_Windowname $ ".AdenaIcon")).AddItem(iInfo);
	GetTextBoxHandle((m_Windowname $ ".Confirm_Wnd.ConfirmDetails_Wnd.PopupItemText")).SetText(iInfo.Name);
	GetItemWindowHandle((m_Windowname $ ".Confirm_Wnd.ConfirmDetails_Wnd.PopupIcon")).AddItem(iInfo);
	return;
}

function SetItems()
{
	local array<ItemInfo> iItems;
	local int i;

	Class'NWindow.HeroBookAPI'.static.GetHeroBookItemListFromInven(byte(HeroBookWnd(GetScript("HeroBookWnd")).getCatogoryNum()), iItems);
	m_topList.Clear();
	i = 0;
	while((i < iItems.Length))
	{
		if(isCollectionItem(iItems[i]))
		{
			iItems[i].ForeTexture = "L2UI_EPIC.Icon.IconPanel_coll";
		}
		m_topList.AddItem(iItems[i]);
		i++;
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "PopupOK_BTN":
			OnPopupOK_BTNClick();
			break;
		case "PopupCancel_BTN":
			OnPopupCancel_BTNClick();
			break;
		case "OKButton":
			OnOKButtonClick();
			break;
		case "CancelButton":
			OnCancelButtonClick();
			break;
		case "ResetButton":
			OnResetButtonClick();
			break;
		default:
			break;
	}
	return;
}

function OnPopupOK_BTNClick()
{
	API_C_EX_HERO_BOOK_CHARGE();
	return;
}

function OnPopupCancel_BTNClick()
{
	hidePopup();
	return;
}

function OnOKButtonClick()
{
	ShowPopup();
	return;
}

function OnCancelButtonClick()
{
	Me.HideWindow();
	toggleWindow("HeroBookWnd", true, false);
	StopSound("InterfaceSound.ui_bookenchant_open");
	PlaySound("InterfaceSound.ui_bookenchant_open_short");
	return;
}

function OnResetButtonClick()
{
	Clear();
	CheckAddedCondition();
	SetItems();
	SetChargingInfos();
	API_C_EX_HERO_BOOK_CHARGE_PROB();
	return;
}

function OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);
	return;
}

function OnDBClickItem(string ControlName, int Index)
{
	if((Index >= 0))
	{
		if((ControlName == "TopList"))
		{
			MoveItemTopToBottom(Index, Class'NWindow.InputAPI'.static.IsAltPressed());
		}
		else if((ControlName == "BottomList"))
		{
			MoveItemBottomToTop(Index, Class'NWindow.InputAPI'.static.IsAltPressed());
		}
	}
	return;
}

function OnDropItem(string strID, ItemInfo Info, int X, int Y)
{
	local int Index;

	if(((strID == "TopList") && (Info.DragSrcName == "BottomList")))
	{
		Index = m_bottomList.FindItemWithAllProperty(Info);
		if((Index >= 0))
		{
			MoveItemBottomToTop(Index, (Info.AllItemCount > INT64(0)));
		}
	}
	else if(((strID == "BottomList") && (Info.DragSrcName == "TopList")))
	{
		Index = m_topList.FindItemWithAllProperty(Info);
		if((Index >= 0))
		{
			MoveItemTopToBottom(Index, (Info.AllItemCount > INT64(0)));
		}
	}
	return;
}

function MoveItemTopToBottom(int Index, bool bAllItem)
{
	local ItemInfo topInfo, bottomInfo;
	local int bottomIndex;
	local INT64 toAddNum;

	if((statusGaugeMaxText.GetText() == GetSystemString(3451)))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13101));
		Debug("이거냐 1");  // EN?: Is This It 1
		return;
	}
	if(!m_topList.IsEnableWindow())
	{
		return;
	}
	if(m_topList.GetItem(Index, topInfo))
	{
		if(((!bAllItem && IsStackableItem(topInfo.ConsumeType)) && (topInfo.ItemNum > INT64(1))))
		{
			DialogSetID(111);
			DialogSetReservedItemID(topInfo.Id);
			DialogSetParamInt64(CheckNumEnough(topInfo.ItemNum, topInfo.HeroBookPoint, true));
			DialogSetDefaultOK();
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), topInfo.Name, ""));
			m_topList.DisableWindow();
			m_bottomList.DisableWindow();
		}
		else
		{
			bottomIndex = m_bottomList.FindItem(topInfo.Id);
			toAddNum = CheckNumEnough(topInfo.ItemNum, topInfo.HeroBookPoint, true);
			if((topInfo.ItemNum == toAddNum))
			{
				m_topList.DeleteItem(Index);
			}
			else
			{
				topInfo.ItemNum = (topInfo.ItemNum - toAddNum);
				m_topList.SetItem(Index, topInfo);
			}
			if(((bottomIndex != -1) && IsStackableItem(topInfo.ConsumeType)))
			{
				m_bottomList.GetItem(bottomIndex, bottomInfo);
				(bottomInfo.ItemNum += toAddNum);
				m_bottomList.SetItem(bottomIndex, bottomInfo);
			}
			else
			{
				topInfo.ItemNum = toAddNum;
				m_bottomList.AddItem(topInfo);
			}
			SetChargingInfos();
			API_C_EX_HERO_BOOK_CHARGE_PROB();
		}
	}
	return;
}

function INT64 CheckNumEnough(INT64 itemMax, int nHeroBookPoint, optional bool bNoCheckMessage)
{
	local INT64 enoughNum;

	enoughNum = GetNumEnough(itemMax, nHeroBookPoint);
	Debug(((("CheckNumEnough" @ string(enoughNum)) @ string(itemMax)) @ string(nHeroBookPoint)));
	if(((itemMax != enoughNum) && !bNoCheckMessage))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13101));
		Debug("이거냐 2");  // EN?: Is This It 2
	}
	return enoughNum;
}

function INT64 GetNumEnough(INT64 itemMax, int nHeroBookPoint)
{
	local INT64 CraftChargeCurrentTotal, canPutChargeNum, canCharge;

	CraftChargeCurrentTotal = (chargeCurrent + chargeAdded);
	canCharge = (INT64(nMaxHeroPoint) - CraftChargeCurrentTotal);
	canPutChargeNum = (canCharge / INT64(nHeroBookPoint));
	Debug(("맥스 포인트 nMaxHeroPoint" @ string(nMaxHeroPoint)));  // EN?: Max Point nMaxHeroPoint
	Debug(("현재 전체 포인트 CraftChargeCurrentTotal" @ string(CraftChargeCurrentTotal)));  // EN?: Current Overall Points CraftChargeCurrentTotal
	Debug(("충전 가능한 포인트 canCharge" @ string(canCharge)));  // EN?: Rechargeable Point canCharge
	Debug(("nHeroBookPoint :  nHeroBookPoint" @ string(nHeroBookPoint)));
	Debug(("넣을 수 있는 수량 canPutChargeNum" @ string(canPutChargeNum)));  // EN?: Quantity canPutChargeNum
	if(((canPutChargeNum * INT64(nHeroBookPoint)) < canCharge))
	{
		canPutChargeNum = (canPutChargeNum + INT64(1));
	}
	return Min64(itemMax, canPutChargeNum);
}

function SetChargingInfos()
{
	local int i;
	local INT64 canCharge;
	local ItemInfo iInfo;

	chargePrice = INT64(0);
	chargeAdded = INT64(0);
	i = 0;
	while((i < m_bottomList.GetItemNum()))
	{
		m_bottomList.GetItem(i, iInfo);
		chargeAdded = (chargeAdded + (iInfo.ItemNum * INT64(iInfo.HeroBookPoint)));
		chargePrice = (chargePrice + (INT64((iInfo.HeroBookPoint * nCommission)) * iInfo.ItemNum));
		Debug((((("chargePrice :" @ string(chargePrice)) @ string(iInfo.HeroBookPoint)) @ string(nCommission)) @ string(iInfo.ItemNum)));
		i++;
	}
	if((INT64(nMaxHeroPoint) < (chargeAdded + chargeCurrent)))
	{
		canCharge = (INT64(nMaxHeroPoint) - (chargeAdded + chargeCurrent));
		if((canCharge < INT64(0)))
		{
			chargePrice = (chargePrice + (canCharge * INT64(nCommission)));
		}
	}
	SetStatusCraftPoint();
	CheckAddedCondition();
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".AdenaText"), MakeCostString(string(chargePrice)));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString((m_Windowname $ ".AdenaText"), ConvertNumToText(string(chargePrice)));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".Confirm_Wnd.ConfirmDetails_Wnd.PopupItemNumText"), ("x" $ MakeCostString(string(chargePrice))));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString((m_Windowname $ ".Confirm_Wnd.ConfirmDetails_Wnd.PopupItemNumText"), ConvertNumToText(string(chargePrice)));
	return;
}

function MoveItemBottomToTop(int Index, bool bAllItem)
{
	local ItemInfo bottomInfo, topInfo;
	local int topIndex;

	if(!m_bottomList.IsEnableWindow())
	{
		return;
	}
	if(m_bottomList.GetItem(Index, bottomInfo))
	{
		if(((!bAllItem && IsStackableItem(bottomInfo.ConsumeType)) && (bottomInfo.ItemNum > INT64(1))))
		{
			DialogSetID(222);
			DialogSetReservedItemID(bottomInfo.Id);
			DialogSetParamInt64(bottomInfo.ItemNum);
			DialogSetDefaultOK();
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), bottomInfo.Name, ""));
			m_topList.DisableWindow();
			m_bottomList.DisableWindow();
		}
		else
		{
			topIndex = m_topList.FindItem(bottomInfo.Id);
			if(((topIndex != -1) && IsStackableItem(bottomInfo.ConsumeType)))
			{
				m_topList.GetItem(topIndex, topInfo);
				(topInfo.ItemNum += bottomInfo.ItemNum);
				m_topList.SetItem(topIndex, topInfo);
			}
			else
			{
				m_topList.AddItem(bottomInfo);
			}
			m_bottomList.DeleteItem(Index);
			SetChargingInfos();
			API_C_EX_HERO_BOOK_CHARGE_PROB();
		}
	}
	return;
}

function HandleDialogCancel()
{
	m_topList.EnableWindow();
	m_bottomList.EnableWindow();
	return;
}

function HandleDialogOK()
{
	local int Id, Index, topIndex;
	local INT64 Num;
	local ItemInfo Info, topInfo;
	local ItemID cID;

	if(DialogIsMine())
	{
		Id = DialogGetID();
		Num = INT64(DialogGetString());
		cID = DialogGetReservedItemID();
		m_topList.EnableWindow();
		m_bottomList.EnableWindow();
		if(((Id == 111) && (Num > INT64(0))))
		{
			topIndex = m_topList.FindItem(cID);
			if((topIndex >= 0))
			{
				m_topList.GetItem(topIndex, topInfo);
				Num = Min64(Num, topInfo.ItemNum);
				Num = CheckNumEnough(Num, topInfo.HeroBookPoint, true);
				Index = m_bottomList.FindItem(cID);
				if((Index >= 0))
				{
					m_bottomList.GetItem(Index, Info);
					(Info.ItemNum += Num);
					m_bottomList.SetItem(Index, Info);
				}
				else
				{
					Info = topInfo;
					Info.ItemNum = Num;
					Info.bShowCount = false;
					m_bottomList.AddItem(Info);
				}
				(topInfo.ItemNum -= Num);
				if((topInfo.ItemNum <= INT64(0)))
				{
					m_topList.DeleteItem(topIndex);
				}
				else
				{
					m_topList.SetItem(topIndex, topInfo);
				}
			}
		}
		else if(((Id == 222) && (Num > INT64(0))))
		{
			Index = m_bottomList.FindItem(cID);
			if((Index >= 0))
			{
				m_bottomList.GetItem(Index, Info);
				Num = Min64(Num, Info.ItemNum);
				(Info.ItemNum -= Num);
				if((Info.ItemNum > INT64(0)))
				{
					m_bottomList.SetItem(Index, Info);
				}
				else
				{
					m_bottomList.DeleteItem(Index);
				}
				topIndex = m_topList.FindItem(cID);
				if(((topIndex >= 0) && IsStackableItem(Info.ConsumeType)))
				{
					m_topList.GetItem(topIndex, topInfo);
					(topInfo.ItemNum += Num);
					m_topList.SetItem(topIndex, topInfo);
				}
				else
				{
					Info.ItemNum = Num;
					m_topList.AddItem(Info);
				}
			}
		}
		SetChargingInfos();
		API_C_EX_HERO_BOOK_CHARGE_PROB();
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 1710:
			HandleDialogOK();
			break;
		case 1720:
			HandleDialogCancel();
			break;
		case EV_PacketID(1047):
			ParsePacket_S_EX_HERO_BOOK_INFO();
			break;
		case EV_PacketID(1049):
			ParsePacket_S_EX_HERO_BOOK_CHARGE();
			break;
		case EV_PacketID(1051):
			ParsePacket_S_EX_HERO_BOOK_CHARGE_PROB();
			break;
		case 9570:
			HandleAdena();
			break;
		default:
			break;
	}
	return;
}

function HandleAdena()
{
	local INT64 Adena;
	local TextBoxHandle adenaCostText;

	Adena = GetAdena();
	adenaCostText = GetTextBoxHandle((m_Windowname $ ".Confirm_Wnd.ConfirmDetails_Wnd.PopupItemNumCurrentText"));
	if((Adena < chargePrice))
	{
		adenaCostText.SetTextColor(getInstanceL2Util().DRed);
		GetMeButton("Confirm_Wnd.ConfirmDetails_Wnd.PopupOK_BTN").DisableWindow();
	}
	else
	{
		adenaCostText.SetTextColor(getInstanceL2Util().BLUE01);
		GetMeButton("Confirm_Wnd.ConfirmDetails_Wnd.PopupOK_BTN").EnableWindow();
	}
	adenaCostText.SetText((("(" $ MakeCostString(string(Adena))) $ ")"));
	return;
}

function Clear()
{
	m_topList.Clear();
	m_bottomList.Clear();
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".AdenaText"), "0");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString((m_Windowname $ ".AdenaText"), "");
	SetStatusCraftPoint();
	m_Confirm_Wnd.HideWindow();
	return;
}

function ShowPopup()
{
	HandleAdena();
	m_Confirm_Wnd.ShowWindow();
	m_Confirm_Wnd.SetFocus();
	return;
}

function hidePopup()
{
	HandleAdena();
	m_Confirm_Wnd.HideWindow();
	return;
}

function CheckAddedCondition()
{
	local StatusBaseHandle Handle;

	Handle = statusCraftPointStatusBar.GetSelfScript();
	if((chargeCurrent >= INT64((nMaxHeroPoint / 10))))
	{
		statusCraftPointStatusBar.SetGaugeColor(7, GTColor().Yellow2);
	}
	else
	{
		statusCraftPointStatusBar.SetGaugeColor(7, GTColor().DarkGray);
	}
	if((m_bottomList.GetItemNum() > 0))
	{
		GetButtonHandle((m_Windowname $ ".OKButton")).EnableWindow();
		GetButtonHandle((m_Windowname $ ".ResetButton")).SetButtonName(479);
	}
	else
	{
		GetButtonHandle((m_Windowname $ ".OKButton")).DisableWindow();
		GetButtonHandle((m_Windowname $ ".ResetButton")).SetButtonName(938);
	}
	return;
}

function setProgress(bool bProgressP)
{
	CheckAddedCondition();
	bProgress = bProgressP;
	if(bProgress)
	{
		GetButtonHandle((m_Windowname $ ".OKButton")).DisableWindow();
		hidePopup();
		m_topList.EnableWindow();
		m_bottomList.EnableWindow();
		if(DialogIsMine())
		{
			DialogHide();
		}
	}
	return;
}

function API_C_EX_HERO_BOOK_CHARGE()
{
	local array<byte> stream;
	local UIPacket._C_EX_HERO_BOOK_CHARGE packet;
	local ItemInfo iInfo;
	local int i;

	packet.cCategory = HeroBookWnd(GetScript("HeroBookWnd")).getCatogoryNum();
	packet.Items.Length = m_bottomList.GetItemNum();
	Debug(((("API_C_EX_HERO_BOOK_CHARGE" @ string(packet.cCategory)) @ string(m_bottomList.GetItemNum())) @ string(packet.Items.Length)));
	i = 0;
	while((i < m_bottomList.GetItemNum()))
	{
		m_bottomList.GetItem(i, iInfo);
		packet.Items[i].nItemServerId = iInfo.Id.ServerID;
		packet.Items[i].nAmount = iInfo.ItemNum;
		Debug(("packet.items [ i ].nItemServerId" @ string(packet.Items[i].nItemServerId)));
		Debug(("packet.items [ i ].nAmount" @ string(packet.Items[i].nAmount)));
		i++;
	}
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_HERO_BOOK_CHARGE(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(805, stream);
	return;
}

function API_C_EX_HERO_BOOK_CHARGE_PROB()
{
	local array<byte> stream;
	local UIPacket._C_EX_HERO_BOOK_CHARGE_PROB packet;

	packet.nCategory = HeroBookWnd(GetScript("HeroBookWnd")).getCatogoryNum();
	packet.nTotalItemPoint = int(chargeAdded);
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_HERO_BOOK_CHARGE_PROB(stream, packet))
	{
		return;
	}
	Log((((" --- C_EX_HERO_BOOK_CHARGE_PROB - nCategory : " $ string(packet.nCategory)) $ " - packet.nTotalItemPoint : ") $ string(packet.nTotalItemPoint)));
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(807, stream);
	Debug((("API Call C_EX_HERO_BOOK_CHARGE_PROB " @ string(packet.nCategory)) @ string(chargeAdded)));
	return;
}

function ParsePacket_S_EX_HERO_BOOK_CHARGE_PROB()
{
	local UIPacket._S_EX_HERO_BOOK_CHARGE_PROB packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_HERO_BOOK_CHARGE_PROB(packet))
	{
		return;
	}
	nCurrentChargeProb = packet.nProb;
	Log((" --- S_EX_HERO_BOOK_CHARGE_PROB : " $ string(nCurrentChargeProb)));
	Debug(("nCurrentChargeProb" @ string(nCurrentChargeProb)));
	SetStatusCraftPoint();
	return;
}

function ParsePacket_S_EX_HERO_BOOK_INFO()
{
	local UIPacket._S_EX_HERO_BOOK_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_HERO_BOOK_INFO(packet))
	{
		return;
	}
	books = packet.books;
	refreshSetting();
	return;
}

function refreshSetting()
{
	local HeroBookData levelData;
	local SkillInfo pSkillInfo;
	local int i;

	if(DialogIsMine())
	{
		DialogHide();
		HandleDialogCancel();
	}
	Log((" --- Books : " $ string(books.Length)));
	i = 0;
	while((i < books.Length))
	{
		if((books[i].cCategory == HeroBookWnd(GetScript("HeroBookWnd")).getCatogoryNum()))
		{
			Log((" --- books[i].nPoint : " $ string(books[i].nPoint)));
			chargeCurrent = INT64(books[i].nPoint);
			nCurrentLevel = books[i].nLevel;
			nMaxHeroPoint = books[i].nMaxPoint;
			break;
		}
		i++;
	}
	SetAdenaItem();
	setWindowTitleByString((((GetSystemString(14161) $ " (") $ HeroBookWnd(GetScript("HeroBookWnd")).getCategoryName(HeroBookWnd(GetScript("HeroBookWnd")).getCatogoryNum())) $ ")"));
	Class'NWindow.HeroBookAPI'.static.GetHeroBookData(byte(HeroBookWnd(GetScript("HeroBookWnd")).getCatogoryNum()), nCurrentLevel, levelData);
	nCommission = levelData.Commission;
	Debug(("UIPacket._S_EX_HERO_BOOK_INFO cCategory" @ string(HeroBookWnd(GetScript("HeroBookWnd")).getCatogoryNum())));
	Debug(("UIPacket._S_EX_HERO_BOOK_INFO nMaxPoint" @ string(nMaxHeroPoint)));
	pSkillInfo = GetSkillInfoByValue(levelData.BookSkillID, levelData.BookSkillLevel, 0);
	ReceiveSkill_Item.Clear();
	ReceiveSkill_Item.AddItem(getSkillToItemInfo(pSkillInfo));
	SkillLevel_textbox.SetText(pSkillInfo.SkillName);
	SkillName_textbox.SetText(((GetSystemString(88) $ ".") $ string(pSkillInfo.SkillLevel)));
	Clear();
	CheckAddedCondition();
	SetItems();
	SetChargingInfos();
	if(Me.IsShowWindow())
	{
		API_C_EX_HERO_BOOK_CHARGE_PROB();
	}
	return;
}

function ParsePacket_S_EX_HERO_BOOK_CHARGE()
{
	local UIPacket._S_EX_HERO_BOOK_CHARGE packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_HERO_BOOK_CHARGE(packet))
	{
		return;
	}
	Debug(("ParsePacket_S_EX_HERO_BOOK_CHARGE" @ string(packet.bSuccess)));
	switch(packet.bSuccess)
	{
		case 1:
			Debug("차징 성공 ");  // EN?: Successfully Charged
			m_bottomList.Clear();
			AddSystemMessage(13722);
			PlaySound("ItemSound3.sys_bonus_hunt");
			break;
		default:
			AddSystemMessage(13723);
			Debug("차징 실패 ");  // EN?: Charging failed
			Me.HideWindow();
			break;
	}
	m_Confirm_Wnd.HideWindow();
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_Windowname $ ".AdenaText"), "0");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString((m_Windowname $ ".AdenaText"), "");
	Class'InterfaceClassic.L2UITimer'.static.Inst()._AddTimerOnce(1, 1)._DelegateOnTime = OnTime;
	return;
}

function OnTime(int Count)
{
	CheckAddedCondition();
	OnResetButtonClick();
	return;
}

function OnReceivedCloseUI()
{
	if(m_Confirm_Wnd.IsShowWindow())
	{
		hidePopup();
	}
	else
	{
		CloseUI();
	}
	return;
}

defaultproperties
{
	m_Windowname="HeroBookCraftChargingWnd"
}
