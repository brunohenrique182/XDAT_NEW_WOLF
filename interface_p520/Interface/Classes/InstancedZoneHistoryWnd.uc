class InstancedZoneHistoryWnd extends UICommonAPI;

function OnLoad()
{
	SetClosingOnESC();
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(5860);
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	local int nShowWindow;

	switch(a_EventID)
	{
		case 5860:
			ParseInt(a_Param, "ShowWindow", nShowWindow);
			if((nShowWindow > 0))
			{
				ShowWindowWithFocus("InstancedZoneHistoryWnd");
				handleInzoneWaitingInfo(a_Param);
			}
			Debug(("EV_InzoneWaitingInfo" @ a_Param));
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "refresh_Btn":
			Debug("RequestInzoneWaitingTime");
			RequestInzoneWaitingTime();
			break;
		default:
			break;
	}
	return;
}

function handleInzoneWaitingInfo(string param)
{
	local int currentInzoneID, sizeOfBlockedInzone, blockedInzoneID, blockedInzoneLeftSeconds;
	local string currentInzoneName, blockedInzoneName, LeftTime;
	local int i;

	ParseInt(param, "currentInzoneID", currentInzoneID);
	currentInzoneName = GetInZoneNameWithZoneID(currentInzoneID);
	if((currentInzoneName == "Invalid inzone ID"))
	{
		currentInzoneName = "";
	}
	ParseInt(param, "sizeOfBlockedInzone", sizeOfBlockedInzone);
	if((currentInzoneName == ""))
	{
		GetTextBoxHandle("InstancedZoneHistoryWnd.CurrentInzoneTextBox").SetText(GetSystemString(2794));
	}
	else
	{
		GetTextBoxHandle("InstancedZoneHistoryWnd.CurrentInzoneTextBox").SetText(currentInzoneName);
	}
	GetRichListCtrlHandle("InstancedZoneHistoryWnd.HistoryRichListCtrl").DeleteAllItem();
	i = 0;
	while((i < sizeOfBlockedInzone))
	{
		blockedInzoneName = "";
		LeftTime = "";
		ParseInt(param, ("blockedInzoneID_" $ string(i)), blockedInzoneID);
		ParseInt(param, ("blockedInzoneLeftSeconds_" $ string(i)), blockedInzoneLeftSeconds);
		blockedInzoneName = GetInZoneNameWithZoneID(blockedInzoneID);
		LeftTime = setTimeString(blockedInzoneLeftSeconds);
		GetRichListCtrlHandle("InstancedZoneHistoryWnd.HistoryRichListCtrl").InsertRecord(makeRecord(blockedInzoneName, LeftTime));
		i++;
	}
	return;
}

function RichListCtrlRowData makeRecord(string blockedInzoneName, string LeftTime)
{
	local RichListCtrlRowData Record;

	Record.cellDataList.Length = 2;
	AddRichListCtrlString(Record.cellDataList[0].drawitems, blockedInzoneName);
	AddRichListCtrlString(Record.cellDataList[1].drawitems, LeftTime);
	return Record;
}

function string setTimeString(int tmpTime)
{
	local string timeStr;
	local int timeHour, timeMin;

	if((tmpTime < 60))
	{
		timeStr = MakeFullSystemMsg(GetSystemMessage(3390), string(1));
		timeStr = MakeFullSystemMsg(GetSystemMessage(3408), timeStr);
	}
	else if((tmpTime < 3600))
	{
		tmpTime = (tmpTime / 60);
		timeStr = MakeFullSystemMsg(GetSystemMessage(3390), string(tmpTime));
	}
	else
	{
		timeHour = (tmpTime / 3600);
		timeMin = ((tmpTime - (timeHour * 3600)) / 60);
		if((timeMin > 0))
		{
			timeStr = (MakeFullSystemMsg(GetSystemMessage(3406), string(timeHour)) @ MakeFullSystemMsg(GetSystemMessage(3390), string(timeMin)));
		}
		else
		{
			timeStr = MakeFullSystemMsg(GetSystemMessage(3406), string(timeHour));
		}
	}
	return timeStr;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
