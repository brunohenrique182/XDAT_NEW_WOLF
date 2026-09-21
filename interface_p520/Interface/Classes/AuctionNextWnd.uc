class AuctionNextWnd extends UICommonAPI;

var WindowHandle Me;
var ItemWindowHandle AuctionNextItem;
var TextBoxHandle txtItemName;
var TextBoxHandle AuctionNextTime;
var TextureHandle GroupBox_AuctionNextTime;
var ButtonHandle btnClose;
var HtmlHandle HtmlViewer;

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("AuctionNextWnd");
	txtItemName = GetTextBoxHandle("AuctionNextWnd.txtItemName");
	AuctionNextTime = GetTextBoxHandle("AuctionNextWnd.AuctionNextTime");
	AuctionNextItem = GetItemWindowHandle("AuctionNextWnd.AuctionNextItem");
	btnClose = GetButtonHandle("AuctionNextWnd.BtnClose");
	HtmlViewer = GetHtmlHandle("AuctionNextWnd.HtmlViewer");
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(3051);
	RegisterEvent(3052);
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "BtnClose":
			OnBtnCloseClick();
			break;
		default:
			break;
	}
	return;
}

function OnBtnCloseClick()
{
	Me.HideWindow();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 3051:
			Debug(("EV_ITEM_AUCTION_NEXT_INFO" @ param));
			HandleAuctionNextInfo(param);
			break;
		case 3052:
			Debug(("EV_ITEM_AUCTION_NEXT_NOTEXIST" @ param));
			HandleAuctionNextInfo(param, true);
			break;
		default:
			break;
	}
	return;
}

function HandleAuctionNextInfo(string param, optional bool bNoItem)
{
	local int startYear, startMon, startDay, startMin, startHour;
	local INT64 startPrice;
	local ItemInfo Info;

	Debug(("HandleAuctionNextInfo param = " $ param));
	Me.ShowWindow();
	Me.SetFocus();
	ParseInt(param, "startTimeYear", startYear);
	ParseInt(param, "startTimeMonth", startMon);
	ParseInt(param, "startTimeDay", startDay);
	ParseInt(param, "startTimeHour", startHour);
	ParseInt(param, "startTimeMinute", startMin);
	ParseINT64(param, "startPrice", startPrice);
	if(bNoItem)
	{
		Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(15625), Info);
		AuctionNextItem.Clear();
		AuctionNextItem.AddItem(Info);
		AuctionNextItem.ClearTooltip();
		AuctionNextItem.SetTooltipType("text");
		txtItemName.SetText(GetSystemString(584));
		HtmlViewer.LoadHtmlFromString(htmlSetHtmlStart(GetSystemString(3552)));
	}
	else
	{
		ParamToItemInfo(param, Info);
		AuctionNextItem.Clear();
		AuctionNextItem.AddItem(Info);
		AuctionNextItem.SetTooltipType("Inventory");
		txtItemName.SetText(Info.Name);
		HtmlViewer.LoadHtmlFromString(htmlSetHtmlStart(Info.Description));
	}
	if((startMin >= 10))
	{
		AuctionNextTime.SetText(((((((((string(startYear) $ "/") $ string(startMon)) $ "/") $ string(startDay)) $ "  ") $ string(startHour)) $ ":") $ string(startMin)));
	}
	else if(((startMin < 10) || (startMin >= 0)))
	{
		AuctionNextTime.SetText((((((((((string(startYear) $ "/") $ string(startMon)) $ "/") $ string(startDay)) $ "  ") $ string(startHour)) $ ":") $ "0") $ string(startMin)));
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("AuctionNextWnd").HideWindow();
	return;
}
