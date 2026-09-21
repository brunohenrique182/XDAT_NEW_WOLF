class AuctionWnd extends UICommonAPI;

const TIMER_ID = 777;
const TIMER_DELAY = 1000;
const DIALOG_ASK_AUCTION_PRICE = 321;
const DIALOG_CONFIRM_PRICE = 432;
const ADENA_OVER_FLOW = "1000000000000";

var WindowHandle Me;
var TextBoxHandle txtRemainStr;
var TextBoxHandle txtTimeHour;
var TextBoxHandle txtTimeMin;
var TextBoxHandle txtTimeSec;
var TextBoxHandle txtHighBid;
var TextBoxHandle txtMyAdenaStr;
var TextBoxHandle txtMyAdena;
var TextBoxHandle txtItemInfoStr;
var ButtonHandle BtnBid1;
var ButtonHandle BtnBid2;
var ButtonHandle BtnBid3;
var ButtonHandle BtnBid4;
var ButtonHandle BtnBidInput;
var TextBoxHandle txtHighBidStr;
var ButtonHandle btnClose;
var ButtonHandle BtnNext;
var ItemWindowHandle AuctionItem;
var TextBoxHandle txtItemName;
var TextBoxHandle txtHighBid_word;
var INT64 m_myLastBidPrice;
var INT64 m_myBidPrice;
var INT64 m_currentPrice;
var int m_auctionID;
var ItemInfo m_auctionItem;
var int bShowUI;
var int iAuctionID;
var INT64 iCurrentPrice;
var int iRemainSecond;

function OnRegisterEvent()
{
	RegisterEvent(3050);
	RegisterEvent(9570);
	RegisterEvent(1710);
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
	Me = GetWindowHandle("AuctionWnd");
	txtRemainStr = GetTextBoxHandle("AuctionWnd.txtRemainStr");
	txtTimeHour = GetTextBoxHandle("AuctionWnd.txtTimeHour");
	txtTimeMin = GetTextBoxHandle("AuctionWnd.txtTimeMin");
	txtTimeSec = GetTextBoxHandle("AuctionWnd.txtTimeSec");
	txtHighBid = GetTextBoxHandle("AuctionWnd.txtHighBid");
	txtMyAdenaStr = GetTextBoxHandle("AuctionWnd.txtMyAdenaStr");
	txtMyAdena = GetTextBoxHandle("AuctionWnd.txtMyAdena");
	txtItemInfoStr = GetTextBoxHandle("AuctionWnd.txtItemInfoStr");
	BtnBid1 = GetButtonHandle("AuctionWnd.BtnBid1");
	BtnBid2 = GetButtonHandle("AuctionWnd.BtnBid2");
	BtnBid3 = GetButtonHandle("AuctionWnd.BtnBid3");
	BtnBid4 = GetButtonHandle("AuctionWnd.BtnBid4");
	BtnBidInput = GetButtonHandle("AuctionWnd.BtnBidInput");
	txtHighBidStr = GetTextBoxHandle("AuctionWnd.txtHighBidStr");
	btnClose = GetButtonHandle("AuctionWnd.BtnClose");
	AuctionItem = GetItemWindowHandle("AuctionWnd.AuctionItem");
	txtItemName = GetTextBoxHandle("AuctionWnd.txtItemName");
	BtnNext = GetButtonHandle("AuctionWnd.BtnNextAuction");
	txtHighBid_word = GetTextBoxHandle("AuctionWnd.txtHighBid_word");
	return;
}

function Load()
{
	return;
}

function OnEvent(int Event_ID, string param)
{
	local ItemInfo Info;

	switch(Event_ID)
	{
		case 3050:
			ParseInt(param, "ShowUI", bShowUI);
			ParseInt(param, "AuctionID", iAuctionID);
			ParseINT64(param, "CurrentPrice", iCurrentPrice);
			ParseInt(param, "RemainSecond", iRemainSecond);
			ParamToItemInfo(param, Info);
			m_currentPrice = iCurrentPrice;
			m_auctionID = iAuctionID;
			m_auctionItem = Info;
			if((bShowUI == 1))
			{
				InsertAuctionItem();
				m_hOwnerWnd.SetTimer(777, 1000);
				Me.ShowWindow();
				Me.SetFocus();
			}
			UpdateAuctionWnd();
			break;
		case 9570:
			myUpdateAdena();
			break;
		case 1710:
			HandleDialogOK();
			break;
		default:
			break;
	}
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 777))
	{
		Class'NWindow.AuctionAPI'.static.RequestInfoItemAuction(m_auctionID);
	}
	return;
}

function InsertAuctionItem()
{
	AuctionItem.Clear();
	AuctionItem.AddItem(m_auctionItem);
	AuctionItem.SetTooltipType("Inventory");
	txtItemName.SetText(m_auctionItem.Name);
	return;
}

function OnShow()
{
	BtnNext.EnableWindow();
	BtnBid1.EnableWindow();
	BtnBid2.EnableWindow();
	BtnBid3.EnableWindow();
	BtnBid4.EnableWindow();
	BtnBidInput.EnableWindow();
	return;
}

function OnHide()
{
	Class'NWindow.UIAPI_WINDOW'.static.KillUITimer("AuctionWnd", 777);
	Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("AuctionWnd.AuctionItem");
	return;
}

function OnClickButton(string Name)
{
	m_myBidPrice = INT64(-1);
	switch(Name)
	{
		case "BtnBid1":
			m_myBidPrice = (m_currentPrice * INT64(2));
			if(((m_myBidPrice > INT64("1000000000000")) || (m_myBidPrice < INT64(0))))
			{
				BtnBid1.DisableWindow();
				BtnBid1.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(2157)));
			}
			else
			{
				DialogSetID(432);
				DialogShow(DialogModalType_Modalless, DialogType_Warning, MakeFullSystemMsg(GetSystemMessage(2137), m_auctionItem.Name, MakeCostString(string(m_myBidPrice))));
			}
			break;
		case "BtnBid2":
			m_myBidPrice = (((m_currentPrice * INT64(5)) / INT64(10)) + m_currentPrice);
			if(((m_myBidPrice > INT64("1000000000000")) || (m_myBidPrice < INT64(0))))
			{
				BtnBid2.DisableWindow();
				BtnBid2.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(2157)));
			}
			else
			{
				DialogSetID(432);
				DialogShow(DialogModalType_Modalless, DialogType_Warning, MakeFullSystemMsg(GetSystemMessage(2137), m_auctionItem.Name, MakeCostString(string(m_myBidPrice))));
			}
			break;
		case "BtnBid3":
			m_myBidPrice = ((m_currentPrice / INT64(10)) + m_currentPrice);
			if(((m_myBidPrice > INT64("1000000000000")) || (m_myBidPrice < INT64(0))))
			{
				BtnBid3.DisableWindow();
				BtnBid3.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(2157)));
			}
			else
			{
				DialogSetID(432);
				DialogShow(DialogModalType_Modalless, DialogType_Warning, MakeFullSystemMsg(GetSystemMessage(2137), m_auctionItem.Name, MakeCostString(string(m_myBidPrice))));
			}
			break;
		case "BtnBid4":
			m_myBidPrice = (((m_currentPrice * INT64(5)) / INT64(100)) + m_currentPrice);
			Debug(("m_myBidPrice" @ string(m_myBidPrice)));
			if(((m_myBidPrice > INT64("1000000000000")) || (m_myBidPrice < INT64(0))))
			{
				BtnBid4.DisableWindow();
				BtnBid4.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(2157)));
			}
			else
			{
				DialogSetID(432);
				DialogShow(DialogModalType_Modalless, DialogType_Warning, MakeFullSystemMsg(GetSystemMessage(2137), m_auctionItem.Name, MakeCostString(string(m_myBidPrice))));
				Debug(("MakeCostString(string(m_myBidPrice) )" @ MakeCostString(string(m_myBidPrice))));
			}
			break;
		case "BtnBidInput":
			OnBtnBidInputClick();
			break;
		case "BtnClose":
			if(IsShowWindow("AuctionWnd"))
			{
				HideWindow("AuctionWnd");
			}
			break;
		case "BtnFailBid":
			RequestBypassToServer("item_auction_withdraw");
			Debug("유찰금 받기 실행!");  // EN: run: collect unsold-auction funds!
			break;
		default:
			break;
	}
	return;
}

function myUpdateAdena()
{
	local CustomTooltip cTooltip;

	txtMyAdena.SetText(MakeCostString(string(GetAdena())));
	addToolTipDrawList(cTooltip, addDrawItemText(((ConvertNumToTextNoAdena(string(GetAdena())) $ " ") $ GetSystemString(469)), getInstanceL2Util().White, "", false));
	txtMyAdena.SetTooltipCustomType(cTooltip);
	return;
}

function UpdateAuctionWnd()
{
	local int temp1, m_timeHour, m_timeMin, m_timeSec;
	local string tempStr;
	local INT64 tempPrice;

	txtHighBid.SetText(((MakeCostString(string(m_currentPrice)) $ " ") $ GetSystemString(469)));
	txtHighBid.SetTextColor(GetNumericColor(string(m_currentPrice)));
	txtHighBid_word.SetTextColor(GetNumericColor(string(m_currentPrice)));
	txtHighBid_word.SetText(((ConvertNumToTextNoAdena(string(m_currentPrice)) $ " ") $ GetSystemString(469)));
	myUpdateAdena();
	m_timeSec = int((float(iRemainSecond) % 60.0000000));
	temp1 = (iRemainSecond / 60);
	m_timeHour = (temp1 / 60);
	m_timeMin = int((float(temp1) % 60.0000000));
	if((m_timeHour > 0))
	{
		if((m_timeHour < 10))
		{
			txtTimeHour.SetText(("0" $ string(m_timeHour)));
		}
		else
		{
			txtTimeHour.SetText(string(m_timeHour));
		}
	}
	else
	{
		txtTimeHour.SetText("00");
	}
	if((m_timeMin > 0))
	{
		if((m_timeMin < 10))
		{
			txtTimeMin.SetText(("0" $ string(m_timeMin)));
		}
		else
		{
			txtTimeMin.SetText(string(m_timeMin));
		}
	}
	else
	{
		txtTimeMin.SetText("00");
	}
	if((m_timeSec > 0))
	{
		if((m_timeSec < 10))
		{
			txtTimeSec.SetText(("0" $ string(m_timeSec)));
		}
		else
		{
			txtTimeSec.SetText(string(m_timeSec));
		}
	}
	else
	{
		txtTimeSec.SetText("00");
	}
	tempPrice = (m_currentPrice * INT64(2));
	if(((tempPrice > INT64("1000000000000")) || (tempPrice < INT64(0))))
	{
		BtnBid1.DisableWindow();
		BtnBid1.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(2076)));
	}
	else
	{
		if(!BtnBid1.IsEnableWindow())
		{
			BtnBid1.EnableWindow();
		}
		tempStr = MakeFullSystemMsg(GetSystemMessage(2157), MakeCostString(string(tempPrice)));
		BtnBid1.SetTooltipCustomType(MakeTooltipMultiText(tempStr, getInstanceL2Util().White, "", false, (("(" $ ConvertNumToText(string(tempPrice))) $ ")"), GetNumericColor(string(tempPrice)), "", true));
	}
	tempPrice = (((m_currentPrice * INT64(5)) / INT64(10)) + m_currentPrice);
	if(((tempPrice > INT64("1000000000000")) || (tempPrice < INT64(0))))
	{
		BtnBid2.DisableWindow();
		BtnBid2.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(2076)));
	}
	else
	{
		if(!BtnBid2.IsEnableWindow())
		{
			BtnBid2.EnableWindow();
		}
		tempStr = MakeFullSystemMsg(GetSystemMessage(2157), MakeCostString(string(tempPrice)));
		BtnBid2.SetTooltipCustomType(MakeTooltipMultiText(tempStr, getInstanceL2Util().White, "", false, (("(" $ ConvertNumToText(string(tempPrice))) $ ")"), GetNumericColor(string(tempPrice)), "", true));
	}
	tempPrice = ((m_currentPrice / INT64(10)) + m_currentPrice);
	if(((tempPrice > INT64("1000000000000")) || (tempPrice < INT64(0))))
	{
		BtnBid3.DisableWindow();
		BtnBid3.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(2076)));
	}
	else
	{
		if(!BtnBid3.IsEnableWindow())
		{
			BtnBid3.EnableWindow();
		}
		tempStr = MakeFullSystemMsg(GetSystemMessage(2157), MakeCostString(string(tempPrice)));
		BtnBid3.SetTooltipCustomType(MakeTooltipMultiText(tempStr, getInstanceL2Util().White, "", false, (("(" $ ConvertNumToText(string(tempPrice))) $ ")"), GetNumericColor(string(tempPrice)), "", true));
	}
	tempPrice = (((m_currentPrice * INT64(5)) / INT64(100)) + m_currentPrice);
	if(((tempPrice > INT64("1000000000000")) || (tempPrice < INT64(0))))
	{
		BtnBid4.DisableWindow();
		BtnBid4.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(2076)));
	}
	else
	{
		if(!BtnBid4.IsEnableWindow())
		{
			BtnBid4.EnableWindow();
		}
		tempStr = MakeFullSystemMsg(GetSystemMessage(2157), MakeCostString(string(tempPrice)));
		BtnBid4.SetTooltipCustomType(MakeTooltipMultiText(tempStr, getInstanceL2Util().White, "", false, (("(" $ ConvertNumToText(string(tempPrice))) $ ")"), GetNumericColor(string(tempPrice)), "", true));
	}
	if((((m_timeHour == 0) && (m_timeMin == 0)) && (m_timeSec == 0)))
	{
		m_hOwnerWnd.KillTimer(777);
	}
	if((iRemainSecond == 0))
	{
		BtnBid1.DisableWindow();
		BtnBid2.DisableWindow();
		BtnBid3.DisableWindow();
		BtnBid4.DisableWindow();
		BtnBidInput.DisableWindow();
		btnClose.EnableWindow();
	}
	return;
}

function OnBtnBidInputClick()
{
	DialogSetID(321);
	DialogSetEditType("number");
	DialogSetParamInt64(INT64(-1));
	DialogSetDefaultOK();
	DialogShow(DialogModalType_Modalless, DialogType_NumberPad, GetSystemMessage(2138));
	return;
}

function HandleDialogOK()
{
	local int Id;

	if(DialogIsMine())
	{
		Id = DialogGetID();
		if((Id == 321))
		{
			m_myBidPrice = INT64(DialogGetString());
			DialogSetID(432);
			DialogShow(DialogModalType_Modalless, DialogType_Warning, MakeFullSystemMsg(GetSystemMessage(2137), m_auctionItem.Name, MakeCostString(string(m_myBidPrice))));
		}
		else if((Id == 432))
		{
			Class'NWindow.AuctionAPI'.static.RequestBidItemAuction(m_auctionID, m_myBidPrice);
		}
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	OnClickButton("BtnClose");
	return;
}
