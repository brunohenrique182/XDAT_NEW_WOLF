class EventInfoWnd extends UICommonAPI;

const TIMER_ID = 112221;
const EVENTTYPE_ANNIVE = 201;

var WindowHandle Me;
var WindowHandle EventInfoList_Wnd;
var ListCtrlHandle ToDoList_ListCtrl;
var WindowHandle EventDetailInfo_Wnd;
var ButtonHandle EssentialBtn;
var TextBoxHandle EventName_text;
var TextBoxHandle EventNameDetail_text;
var HtmlHandle EventDescription_HtmlViewer;
var TextureHandle EventIcon_texture;
var int clientStartSec;
var int addTimeSec;
var int currentTimeSec;
var L2UITime L2UITime;
var int serverStartTime;
var bool hasNoticeIcon;
var int serverTimeZone;
var int clientTimeZone;
var int daylightSeconds;
var bool bFirstShow;
var bool bFirstTryShow;

function OnRegisterEvent()
{
	RegisterEvent(10230);
	RegisterEvent(40);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function OnHide()
{
	EventDescription_HtmlViewer.Clear();
	SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(self)), Me.IsShowWindow());
	return;
}

function OnShow()
{
	if(!bFirstShow)
	{
		bFirstShow = true;
		getInstanceL2Util().setWindowMoveToCenter(Me);
	}
	checkNeedNotice();
	refreshList();
	SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(self)), Me.IsShowWindow());
	return;
}

function refreshList()
{
	local int nDataCount, i;
	local EventAlarmUIData EventData;
	local bool bTodayIsEventDay;

	ToDoList_ListCtrl.DeleteAllItem();
	nDataCount = GetEventAlarmDataCount();
	i = 0;
	while((i < nDataCount))
	{
		GetEventAlarmDataByIndex(i, EventData);
		if((EventData.nEventID > 0))
		{
			if((EventData.nEventType == 201))
			{
				i++;
				continue;
			}
			if((isUseEventByServer(EventData) == false))
			{
				i++;
				continue;
			}
			bTodayIsEventDay = ((isEventPeroid(EventData) && isEventDay(EventData.nEventDay, L2UITime.nWeekDay)) && isEventOnTime(EventData));
			if(isEventPeroid(EventData))
			{
				AddListData(EventData.strTitle, EventData.strEventDesc, EventData.strNotifyIcon, EventData.nEventType, i, bTodayIsEventDay);
			}
		}
		i++;
	}
	if((ToDoList_ListCtrl.GetRecordCount() > 0))
	{
		ToDoList_ListCtrl.SetSelectedIndex(0, true);
		OnClickListCtrlRecord("");
		ToDoList_ListCtrl.SetFocus();
	}
	return;
}

function Initialize()
{
	Me = GetWindowHandle("EventInfoWnd");
	EventInfoList_Wnd = GetWindowHandle("EventInfoWnd.EventInfoList_Wnd");
	EventDetailInfo_Wnd = GetWindowHandle("EventInfoWnd.EventDetailInfo_Wnd");
	ToDoList_ListCtrl = GetListCtrlHandle("EventInfoWnd.EventInfoList_Wnd.ToDoList_ListCtrl");
	EventName_text = GetTextBoxHandle("EventInfoWnd.EventDetailInfo_Wnd.EventName_text");
	EventNameDetail_text = GetTextBoxHandle("EventInfoWnd.EventDetailInfo_Wnd.EventNameDetail_text");
	EventIcon_texture = GetTextureHandle("EventDetailInfo_Wnd.EventIcon_texture");
	EventDescription_HtmlViewer = GetHtmlHandle("EventInfoWnd.EventDetailInfo_Wnd.EventDescription_HtmlViewer");
	EssentialBtn = GetButtonHandle("EventInfoWnd.EssentialBtn");
	return;
}

function AddListData(string Title, string Desc, string IconName, int nEventType, int Index, bool bTodayIsEventDay)
{
	local LVDataRecord Record;

	Record.LVDataList.Length = 1;
	Record.LVDataList[0].nReserved1 = Index;
	Record.LVDataList[0].szData = getEventStr(nEventType);
	Record.LVDataList[0].bUseTextColor = true;
	if(bTodayIsEventDay)
	{
		Record.LVDataList[0].TextColor = getInstanceL2Util().Yellow;
	}
	else
	{
		Record.LVDataList[0].TextColor = GetColor(175, 152, 120, 255);
	}
	Record.LVDataList[0].hasIcon = true;
	Record.LVDataList[0].nTextureWidth = 32;
	Record.LVDataList[0].nTextureHeight = 32;
	Record.LVDataList[0].nTextureU = 32;
	Record.LVDataList[0].nTextureV = 32;
	Record.LVDataList[0].szTexture = IconName;
	Record.LVDataList[0].IconPosX = 10;
	Record.LVDataList[0].FirstLineOffsetX = 6;
	Record.LVDataList[0].iconBackTexName = "l2ui_ct1.ItemWindow_DF_SlotBox_Default";
	Record.LVDataList[0].backTexOffsetXFromIconPosX = -2;
	Record.LVDataList[0].backTexOffsetYFromIconPosY = -1;
	Record.LVDataList[0].backTexWidth = 36;
	Record.LVDataList[0].backTexHeight = 36;
	Record.LVDataList[0].backTexUL = 36;
	Record.LVDataList[0].backTexVL = 36;
	if((bTodayIsEventDay == false))
	{
		Record.LVDataList[0].iconPanelName = "L2UI_CT1.Windows.WindowDisable_BG";
		Record.LVDataList[0].panelOffsetXFromIconPosX = 0;
		Record.LVDataList[0].panelOffsetYFromIconPosY = 0;
		Record.LVDataList[0].panelWidth = 32;
		Record.LVDataList[0].panelHeight = 32;
		Record.LVDataList[0].panelUL = 8;
		Record.LVDataList[0].panelVL = 8;
	}
	if(bTodayIsEventDay)
	{
		Record.LVDataList[0].AttrColor.R = 255;
		Record.LVDataList[0].AttrColor.G = 255;
		Record.LVDataList[0].AttrColor.B = 255;
	}
	else
	{
		Record.LVDataList[0].AttrColor.R = 120;
		Record.LVDataList[0].AttrColor.G = 120;
		Record.LVDataList[0].AttrColor.B = 120;
	}
	Record.LVDataList[0].AttrStat[0] = makeShortStringByPixel(Title, (260 - 16), "..");
	ToDoList_ListCtrl.InsertRecord(Record);
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int nQuitRestrictField;

	if((Event_ID == 10230))
	{
		setCurrentserverTime(param);
	}
	else if((Event_ID == 40))
	{
		ParseInt(param, "QuitRestrictField", nQuitRestrictField);
		if((nQuitRestrictField == 0))
		{
			bFirstTryShow = false;
		}
		bFirstShow = false;
		clientStartSec = 0;
		currentTimeSec = 0;
		addTimeSec = 0;
		hasNoticeIcon = false;
		EventDescription_HtmlViewer.Clear();
		Me.KillTimer(112221);
	}
	return;
}

function setCurrentserverTime(string param)
{
	clientStartSec = int(GetAppSeconds());
	addTimeSec = int((GetAppSeconds() - float(clientStartSec)));
	ParseInt(param, "ServerTime", serverStartTime);
	ParseInt(param, "ServerTimeZone", serverTimeZone);
	ParseInt(param, "ClientTimeZone", clientTimeZone);
	ParseInt(param, "DaylightSeconds", daylightSeconds);
	checkNeedNotice();
	Me.KillTimer(112221);
	Me.SetTimer(112221, 60000);
	if(hasNoticeIcon)
	{
		if((getInstanceUIData().GetIsLiveServer() && !bFirstTryShow))
		{
			bFirstTryShow = true;
			Me.ShowWindow();
		}
	}
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 112221))
	{
		checkNeedNotice();
	}
	return;
}

function checkNeedNotice()
{
	local int nDataCount, i;
	local EventAlarmUIData EventData;
	local bool bShowNotice;

	addTimeSec = int((GetAppSeconds() - float(clientStartSec)));
	currentTimeSec = (serverStartTime + addTimeSec);
	GetTimeStruct(currentTimeSec, L2UITime);
	nDataCount = GetEventAlarmDataCount();
	i = 0;
	while((i < nDataCount))
	{
		GetEventAlarmDataByIndex(i, EventData);
		if((EventData.nEventType == 201))
		{
			EventData.nIntTimeStart = (((EventData.nIntTimeStart - clientTimeZone) + serverTimeZone) - daylightSeconds);
			EventData.nIntTimeEnd = (((EventData.nIntTimeEnd - clientTimeZone) + serverTimeZone) - daylightSeconds);
		}
		if((EventData.nEventID > 0))
		{
			if((isUseEventByServer(EventData) == false))
			{
				i++;
				continue;
			}
			if((isEventPeroid(EventData) && ((EventData.nEventDay.Length == 0) || isEventDay(EventData.nEventDay, L2UITime.nWeekDay))))
			{
				if((EventData.nEventType == 201))
				{
					Class'Interface.AnniveEventLauncher'.static.Inst()._Show();
					i++;
					continue;
				}
				else
				{
					bShowNotice = true;
				}
				if((hasNoticeIcon == false))
				{
					getInstanceNoticeWnd().EventInfoArrived();
					hasNoticeIcon = true;
				}
			}
		}
		i++;
	}
	if((bShowNotice == false))
	{
		hasNoticeIcon = false;
		getInstanceNoticeWnd().hideNoticeButton_EventInfo();
	}
	return;
}

function bool isEventPeroid(EventAlarmUIData EventData)
{
	if(((currentTimeSec >= EventData.nIntTimeStart) && (currentTimeSec <= EventData.nIntTimeEnd)))
	{
		return true;
	}
	if(((currentTimeSec >= EventData.nIntTimeStart) && (EventData.nIntTimeEnd == 0)))
	{
		return true;
	}
	return false;
}

function bool isUseEventByServer(EventAlarmUIData EventData)
{
	if((EventData.nEventType == 201))
	{
		return true;
	}
	if(IsBloodyServer())
	{
		if(InRange(EventData.nEventType, 101, 200))
		{
			return true;
		}
	}
	else if(IsAdenServer())
	{
		if(InRange(EventData.nEventType, 101, 200))
		{
			return true;
		}
	}
	else if(InRange(EventData.nEventType, 1, 100))
	{
		return true;
	}
	return false;
}

function bool InRange(int Value, int rangeLow, int rangeHigh)
{
	if(((rangeLow <= Value) && (rangeHigh >= Value)))
	{
		return true;
	}
	return false;
}

function bool isEventOnTime(EventAlarmUIData EventData)
{
	local string hourStr, hourEndStr, minuteStr, minuteEndStr;
	local int startM, endM, currentM;

	hourStr = "0";
	minuteStr = "0";
	if((EventData.nActivateTime > 0))
	{
		hourStr = Mid(getInstanceL2Util().makeZeroString(4, INT64(EventData.nActivateTime)), 0, 2);
		minuteStr = Mid(getInstanceL2Util().makeZeroString(4, INT64(EventData.nActivateTime)), 2, 2);
	}
	hourEndStr = "0";
	minuteEndStr = "0";
	if((EventData.nDeactivateTime > 0))
	{
		hourEndStr = Mid(getInstanceL2Util().makeZeroString(4, INT64(EventData.nDeactivateTime)), 0, 2);
		minuteEndStr = Mid(getInstanceL2Util().makeZeroString(4, INT64(EventData.nDeactivateTime)), 2, 2);
	}
	if(((((int(hourStr) <= 0) && (int(minuteStr) <= 0)) && (int(hourEndStr) <= 0)) && (int(minuteEndStr) <= 0)))
	{
		return true;
	}
	else if((getMinute(int(hourStr), int(minuteStr)) <= getMinute(int(hourEndStr), int(minuteEndStr))))
	{
		if(((getMinute(L2UITime.nHour, L2UITime.nMin) >= getMinute(int(hourStr), int(minuteStr))) && (getMinute(L2UITime.nHour, L2UITime.nMin) < getMinute(int(hourEndStr), int(minuteEndStr)))))
		{
			return true;
		}
	}
	else
	{
		startM = getMinute(int(hourStr), int(minuteStr));
		endM = getMinute(int(hourEndStr), int(minuteEndStr));
		currentM = getMinute(L2UITime.nHour, L2UITime.nMin);
		if(((startM > currentM) && (currentM <= endM)))
		{
			currentM = getMinute((L2UITime.nHour + 24), L2UITime.nMin);
		}
		endM = getMinute((int(hourEndStr) + 24), int(minuteEndStr));
		if(((currentM >= startM) && (currentM < endM)))
		{
			return true;
		}
	}
	return false;
}

function int getMinute(int nHour, int nMin)
{
	return ((nHour * 60) + nMin);
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "EssentialBtn":
			OnEssentialBtnClick();
			break;
		default:
			break;
	}
	return;
}

function OnEssentialBtnClick()
{
	Me.HideWindow();
	return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	local LVDataRecord Record;
	local int nSelect;

	nSelect = ToDoList_ListCtrl.GetSelectedIndex();
	if((nSelect >= 0))
	{
		ToDoList_ListCtrl.GetSelectedRec(Record);
		showDetailPage(Record.LVDataList[0].nReserved1);
		ToDoList_ListCtrl.SetFocus();
	}
	return;
}

function showDetailPage(int Index)
{
	local EventAlarmUIData EventData;
	local string htmlStr, addDate;

	GetEventAlarmDataByIndex(Index, EventData);
	EventIcon_texture.SetTexture(EventData.strNotifyIcon);
	EventName_text.SetText(makeShortStringByPixel(EventData.strTitle, 260, ".."));
	EventName_text.SetTooltipString(EventData.strTitle);
	EventNameDetail_text.SetText(getEventStr(EventData.nEventType));
	addDate = ((((((((((((("<table width=290 cellpadding=0 border=0 cellspacing=0>" $ "<tr><td width=285>") $ htmlfontAdd((GetSystemString(1366) $ " : "), "dddddd")) $ htmlfontAdd((getPeriodString(EventData) $ "<br1>"), "bbaa88")) $ "</td></tr><br>") $ "<tr><td width=285>") $ htmlfontAdd((GetSystemString(3605) $ " : "), "dddddd")) $ htmlfontAdd(getEventTimeString(EventData), "bbaa88")) $ "</td></tr><br>") $ "<tr><td width=285><img src=L2UI_CT1.Divider.Divider_DF_Ver width=284 height=2></td></tr>") $ "<tr><td width=285><br>") $ htmlfontAdd(EventData.strEventDesc, "999999")) $ "</td></tr>") $ "</table><br>");
	htmlStr = (("<html><body>" $ addDate) $ "</body></html>");
	EventDescription_HtmlViewer.LoadHtmlFromString(htmlStr);
	return;
}

function string getPeriodString(EventAlarmUIData EventData)
{
	local string yearStr, monthStr, dayStr, rStr;

	yearStr = Mid(getInstanceL2Util().makeZeroString(6, INT64(EventData.nStartDate)), 0, 2);
	monthStr = Mid(getInstanceL2Util().makeZeroString(6, INT64(EventData.nStartDate)), 2, 2);
	dayStr = Mid(getInstanceL2Util().makeZeroString(6, INT64(EventData.nStartDate)), 4, 2);
	rStr = MakeFullSystemMsg(GetSystemMessage(4464), yearStr, monthStr, dayStr);
	if((EventData.nEndDate != -1))
	{
		yearStr = Mid(getInstanceL2Util().makeZeroString(6, INT64(EventData.nEndDate)), 0, 2);
		monthStr = Mid(getInstanceL2Util().makeZeroString(6, INT64(EventData.nEndDate)), 2, 2);
		dayStr = Mid(getInstanceL2Util().makeZeroString(6, INT64(EventData.nEndDate)), 4, 2);
		rStr = ((rStr $ " ~ ") $ MakeFullSystemMsg(GetSystemMessage(4463), yearStr, monthStr, dayStr));
	}
	else
	{
		rStr = ((rStr $ " ~ ") $ GetSystemString(13793));
	}
	return rStr;
}

function string getEventTimeString(EventAlarmUIData EventData)
{
	local string rStr, hourStr, hourEndStr, minuteStr, minuteEndStr;

	hourStr = "0";
	minuteStr = "0";
	if((EventData.nActivateTime > 0))
	{
		hourStr = Mid(getInstanceL2Util().makeZeroString(4, INT64(EventData.nActivateTime)), 0, 2);
		minuteStr = Mid(getInstanceL2Util().makeZeroString(4, INT64(EventData.nActivateTime)), 2, 2);
	}
	hourEndStr = "0";
	minuteEndStr = "0";
	if((EventData.nDeactivateTime > 0))
	{
		hourEndStr = Mid(getInstanceL2Util().makeZeroString(4, INT64(EventData.nDeactivateTime)), 0, 2);
		minuteEndStr = Mid(getInstanceL2Util().makeZeroString(4, INT64(EventData.nDeactivateTime)), 2, 2);
	}
	if(((((int(hourStr) <= 0) && (int(minuteStr) <= 0)) && (int(hourEndStr) <= 0)) && (int(minuteEndStr) <= 0)))
	{
		rStr = GetSystemString(3614);
	}
	else
	{
		rStr = MakeFullSystemMsg(GetSystemMessage(4465), getDayString(EventData.nEventDay), (((hourStr $ ":") $ minuteStr) $ " "), (((hourEndStr $ ":") $ minuteEndStr) $ " "));
	}
	return rStr;
}

function string getEventStr(int nType)
{
	local string rStr;

	if(InRange(nType, 101, 111))
	{
		nType = (nType - 100);
	}
	switch(nType)
	{
		case 1:
			rStr = GetSystemString(3599);
			break;
		case 2:
			rStr = GetSystemString(3600);
			break;
		case 3:
			rStr = GetSystemString(3601);
			break;
		case 4:
			rStr = GetSystemString(3602);
			break;
		case 5:
			rStr = GetSystemString(3603);
			break;
		case 6:
			rStr = GetSystemString(3618);
			break;
		case 7:
			rStr = GetSystemString(3619);
			break;
		case 8:
			rStr = GetSystemString(3620);
			break;
		case 9:
			rStr = GetSystemString(13215);
			break;
		case 10:
			rStr = GetSystemString(13216);
			break;
		case 11:
			rStr = GetSystemString(13217);
			break;
		default:
			break;
	}
	return rStr;
}

function string getDayString(array<int> nEventDay)
{
	local int i, Len, nCount;
	local string dayStr;

	Len = nEventDay.Length;
	if((Len > 0))
	{
		i = 1;
		while((i < Len))
		{
			if((nEventDay[i] > 0))
			{
				nCount++;
				switch(i)
				{
					case 1:
						if((dayStr != ""))
						{
							dayStr = (dayStr $ ",");
						}
						dayStr = (dayStr $ GetSystemString(5134));
						break;
					case 2:
						if((dayStr != ""))
						{
							dayStr = (dayStr $ ",");
						}
						dayStr = (dayStr $ GetSystemString(5135));
						break;
					case 3:
						if((dayStr != ""))
						{
							dayStr = (dayStr $ ",");
						}
						dayStr = (dayStr $ GetSystemString(5136));
						break;
					case 4:
						if((dayStr != ""))
						{
							dayStr = (dayStr $ ",");
						}
						dayStr = (dayStr $ GetSystemString(5137));
						break;
					case 5:
						if((dayStr != ""))
						{
							dayStr = (dayStr $ ",");
						}
						dayStr = (dayStr $ GetSystemString(5138));
						break;
					case 6:
						if((dayStr != ""))
						{
							dayStr = (dayStr $ ",");
						}
						dayStr = (dayStr $ GetSystemString(5139));
						break;
					default:
						break;
				}
			}
			i++;
		}
		if((nEventDay[0] > 0))
		{
			nCount++;
			if((dayStr != ""))
			{
				dayStr = (dayStr $ ",");
			}
			dayStr = (dayStr $ GetSystemString(5140));
		}
	}
	if(((nCount > 6) || (nCount == 0)))
	{
		dayStr = GetSystemString(3613);
	}
	dayStr = (("[" $ dayStr) $ "]");
	return dayStr;
}

function bool isEventDay(array<int> nEventDay, int nToday)
{
	local int i, Len, nCount;

	Len = nEventDay.Length;
	i = 0;
	while((i < Len))
	{
		if((nEventDay[i] > 0))
		{
			nCount++;
			if((nToday == i))
			{
				return true;
			}
		}
		i++;
	}
	if(((nCount > 6) || (nCount == 0)))
	{
		return true;
	}
	return false;
}

function string htmlfontAdd(string strText, optional string FontColor)
{
	local string targetHtml;

	if((FontColor == ""))
	{
		FontColor = "d3c5ae";
	}
	targetHtml = ((((("<font color=\"" $ FontColor) $ "\"") $ ">") $ strText) $ "</font>");
	return targetHtml;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
