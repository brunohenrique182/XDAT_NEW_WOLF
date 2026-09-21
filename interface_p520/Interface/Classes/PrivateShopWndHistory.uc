class PrivateShopWndHistory extends UICommonAPI;

var WindowHandle Me;
var ListCtrlHandle itemListCtrl;
var ButtonHandle CloseBtn;
var PrivateShopWndReport PrivateShopWndReportScript;

function Initialize()
{
	SetClosingOnESC();
	Me = GetWindowHandle("PrivateShopWndHistory");
	itemListCtrl = GetListCtrlHandle("PrivateShopWndHistory.ItemList");
	CloseBtn = GetButtonHandle("PrivateShopWndHistory.closeBtn");
	PrivateShopWndReportScript = PrivateShopWndReport(GetScript("PrivateShopWndReport"));
	itemListCtrl.SetSelectedSelTooltip(false);
	itemListCtrl.SetAppearTooltipAtMouseX(true);
	Init();
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(40);
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 40:
			itemListCtrl.DeleteAllItem();
			break;
		default:
			break;
	}
	return;
}

function OnLoad()
{
	Initialize();
	return;
}

function OnShow()
{
	Me.SetFocus();
	return;
}

function OnHide()
{
	Init();
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "close_Btn":
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function Init()
{
	return;
}

function Color getcolorbymessagetype()
{
	switch(PrivateShopWndReportScript.messagetype)
	{
		case "bulksell":
			return GetColor(255, 119, 119, 255);
			break;
		case "sell":
			return GetColor(221, 119, 238, 255);
			break;
		case "buy":
			return GetColor(170, 204, 17, 255);
			break;
		default:
			break;
	}
}

function addHistory(string ItemName, bool isStackable, INT64 ItemNum, string UserName)
{
	local int SystemMsgNum;
	local string SystemMsg;

	switch(PrivateShopWndReportScript.messagetype)
	{
		case "bulksell":
		case "sell":
			if(isStackable)
			{
				SystemMsgNum = 380;
			}
			else
			{
				SystemMsgNum = 378;
			}
			break;
		case "buy":
			if(isStackable)
			{
				SystemMsgNum = 561;
			}
			else
			{
				SystemMsgNum = 559;
			}
			break;
		default:
			break;
	}
	if(isStackable)
	{
		SystemMsg = MakeFullSystemMsg(GetSystemMessage(SystemMsgNum), UserName, ItemName, string(ItemNum));
	}
	else
	{
		SystemMsg = MakeFullSystemMsg(GetSystemMessage(SystemMsgNum), UserName, ItemName);
	}
	itemListCtrl.InsertRecord(makeRecord(SystemMsg, getcolorbymessagetype(), UserName));
	return;
}

function LVDataRecord makeRecord(string Message, Color messageColor, string UserName)
{
	local LVDataRecord Record;
	local int textWidth, textHeight;

	Record.LVDataList.Length = 1;
	GetTextSizeDefault(Message, textWidth, textHeight);
	Record.LVDataList[0].bUseTextColor = true;
	Record.LVDataList[0].TextColor = messageColor;
	Record.LVDataList[0].textAlignment = TA_Left;
	if((textWidth > 430))
	{
		Record.szReserved = Message;
		Record.LVDataList[0].szData = ellipsisWidth(Message, 430);
		Record.nReserved1 = INT64(int(messageColor.R));
		Record.nReserved2 = INT64(int(messageColor.G));
		Record.nReserved3 = INT64(int(messageColor.B));
	}
	else
	{
		Record.LVDataList[0].szData = Message;
	}
	return Record;
}

function string ellipsisWidth(string Text, int MaxWidth)
{
	local int nWidth, nHeight, i;

	GetTextSizeDefault((Text $ ".."), nWidth, nHeight);
	if((nWidth < MaxWidth))
	{
		return Text;
	}
	i = 0;
	while((i < 200))
	{
		GetTextSizeDefault((Text $ ".."), nWidth, nHeight);
		if((nWidth < MaxWidth))
		{
			return (Text $ "..");
		}
		Text = Mid(Text, 0, (Len(Text) - 1));
		i++;
	}
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("PrivateShopWndHistory").HideWindow();
	return;
}
