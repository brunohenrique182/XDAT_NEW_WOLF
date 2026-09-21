class UIPowerToolWnd extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle event1Btn;
var ButtonHandle event2Btn;
var ButtonHandle event3Btn;
var ButtonHandle event4Btn;
var ButtonHandle event5Btn;
var ButtonHandle renameNoteButton;
var ButtonHandle InitBtn;
var ButtonHandle callEventAllButton;
var ButtonHandle copyClipBoard1Btn;
var ButtonHandle copyClipBoard2Btn;
var ButtonHandle copyClipBoard3Btn;
var ButtonHandle copyClipBoard4Btn;
var ButtonHandle copyClipBoard5Btn;
var EditBoxHandle param1Edit;
var EditBoxHandle param2Edit;
var EditBoxHandle param3Edit;
var EditBoxHandle param4Edit;
var EditBoxHandle param5Edit;
var EditBoxHandle eventNum1Edit;
var EditBoxHandle eventNum2Edit;
var EditBoxHandle eventNum3Edit;
var EditBoxHandle eventNum4Edit;
var EditBoxHandle eventNum5Edit;
var EditBoxHandle TitleEditBox;
var ListCtrlHandle noteListCtrl;
var CheckBoxHandle autoOpenCheckBox;
var int currentPageNum;
var int nAutoOpen;
var bool nReloadOpen;

function OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(3410);
	RegisterEvent(9750);
	return;
}

function OnShow()
{
	nReloadOpen = true;
	LoadIni();
	return;
}

function OnHide()
{
	saveCurrentPage();
	return;
}

function saveCurrentPage()
{
	setEditByINI(currentPageNum, 1);
	setEditByINI(currentPageNum, 2);
	setEditByINI(currentPageNum, 3);
	setEditByINI(currentPageNum, 4);
	setEditByINI(currentPageNum, 5);
	SaveINI("UIDEV.ini");
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("UIPowerToolWnd");
	InitBtn = GetButtonHandle("UIPowerToolWnd.initBtn");
	event1Btn = GetButtonHandle("UIPowerToolWnd.event1Btn");
	event2Btn = GetButtonHandle("UIPowerToolWnd.event2Btn");
	event3Btn = GetButtonHandle("UIPowerToolWnd.event3Btn");
	event4Btn = GetButtonHandle("UIPowerToolWnd.event4Btn");
	event5Btn = GetButtonHandle("UIPowerToolWnd.event5Btn");
	copyClipBoard1Btn = GetButtonHandle("UIPowerToolWnd.copyClipBoard1Btn");
	copyClipBoard2Btn = GetButtonHandle("UIPowerToolWnd.copyClipBoard2Btn");
	copyClipBoard3Btn = GetButtonHandle("UIPowerToolWnd.copyClipBoard3Btn");
	copyClipBoard4Btn = GetButtonHandle("UIPowerToolWnd.copyClipBoard4Btn");
	copyClipBoard5Btn = GetButtonHandle("UIPowerToolWnd.copyClipBoard5Btn");
	InitBtn = GetButtonHandle("UIPowerToolWnd.initBtn");
	renameNoteButton = GetButtonHandle("UIPowerToolWnd.renameNoteButton");
	callEventAllButton = GetButtonHandle("UIPowerToolWnd.callEventAllButton");
	param1Edit = GetEditBoxHandle("UIPowerToolWnd.param1Edit");
	param2Edit = GetEditBoxHandle("UIPowerToolWnd.param2Edit");
	param3Edit = GetEditBoxHandle("UIPowerToolWnd.param3Edit");
	param4Edit = GetEditBoxHandle("UIPowerToolWnd.param4Edit");
	param5Edit = GetEditBoxHandle("UIPowerToolWnd.param5Edit");
	eventNum1Edit = GetEditBoxHandle("UIPowerToolWnd.eventNum1Edit");
	eventNum2Edit = GetEditBoxHandle("UIPowerToolWnd.eventNum2Edit");
	eventNum3Edit = GetEditBoxHandle("UIPowerToolWnd.eventNum3Edit");
	eventNum4Edit = GetEditBoxHandle("UIPowerToolWnd.eventNum4Edit");
	eventNum5Edit = GetEditBoxHandle("UIPowerToolWnd.eventNum5Edit");
	TitleEditBox = GetEditBoxHandle("UIPowerToolWnd.titleEditBox");
	noteListCtrl = GetListCtrlHandle("UIPowerToolWnd.noteListCtrl");
	autoOpenCheckBox = GetCheckBoxHandle("UIPowerToolWnd.autoOpenCheckBox");
	setWindowTitleByString("UIPowerTools [ EventTool ]");
	nAutoOpen = -9999;
	currentPageNum = 1;
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((int(GetReleaseMode()) != 0))
	{
		return;
	}
	if((Event_ID == 40))
	{
		nReloadOpen = false;
		nAutoOpen = -9999;
	}
	else if((Event_ID == 9750))
	{
		if((nAutoOpen == -9999))
		{
			GetINIInt("___CommonInfo___", "UIPowerToolWndAutoOpen", nAutoOpen, "UIDEV.ini");
			if((nAutoOpen == 1))
			{
				Me.ShowWindow();
				autoOpenCheckBox.SetCheck(true);
			}
			else
			{
				autoOpenCheckBox.SetCheck(false);
			}
		}
	}
	else if((Event_ID == 3410))
	{
		if((int(GetReleaseMode()) != 0))
		{
			return;
		}
		if((param == "GAMINGSTATE"))
		{
			GetINIInt("___CommonInfo___", "UIPowerToolWndAutoOpen", nAutoOpen, "UIDEV.ini");
			if((nAutoOpen == 1))
			{
				Me.ShowWindow();
				autoOpenCheckBox.SetCheck(true);
			}
			else
			{
				autoOpenCheckBox.SetCheck(false);
			}
		}
	}
	return;
}

function OnClickCheckBox(string strID)
{
	switch(strID)
	{
		case "autoOpenCheckBox":
			OnAutoOpenCheckBoxBtnClick();
			break;
		default:
			break;
	}
	return;
}

function OnAutoOpenCheckBoxBtnClick()
{
	SetINIInt("___CommonInfo___", "UIPowerToolWndAutoOpen", boolToNum(autoOpenCheckBox.IsChecked()), "UIDEV.ini");
	SaveINI("UIDEV_BuildCommand.ini");
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "event1Btn":
			event1BtnClick();
			break;
		case "event2Btn":
			event2BtnClick();
			break;
		case "event3Btn":
			event3BtnClick();
			break;
		case "event4Btn":
			event4BtnClick();
			break;
		case "event5Btn":
			event5BtnClick();
			break;
		case "copyClipBoard1Btn":
			clipBoardCopyBtnClick(1);
			break;
		case "copyClipBoard2Btn":
			clipBoardCopyBtnClick(2);
			break;
		case "copyClipBoard3Btn":
			clipBoardCopyBtnClick(3);
			break;
		case "copyClipBoard4Btn":
			clipBoardCopyBtnClick(4);
			break;
		case "copyClipBoard5Btn":
			clipBoardCopyBtnClick(5);
			break;
		case "InitBtn":
			InitBtnClick();
			break;
		case "renameNoteButton":
			renameBtnClick();
			break;
		case "callEventAllButton":
			callEventAllButtonClick();
			break;
		default:
			break;
	}
	return;
}

function clipBoardCopyBtnClick(int nBtnNum)
{
	local string rStr;

	switch(nBtnNum)
	{
		case 1:
			rStr = makeCopyString(eventNum1Edit.GetString(), param1Edit.GetString());
			if((rStr != ""))
			{
				ClipboardCopy(rStr);
				AddSystemMessageString("Complete! StringCopy for CommandTool");
			}
			break;
		case 2:
			rStr = makeCopyString(eventNum2Edit.GetString(), param2Edit.GetString());
			if((rStr != ""))
			{
				ClipboardCopy(rStr);
				AddSystemMessageString("Complete! StringCopy for CommandTool");
			}
			break;
		case 3:
			rStr = makeCopyString(eventNum3Edit.GetString(), param3Edit.GetString());
			if((rStr != ""))
			{
				ClipboardCopy(rStr);
				AddSystemMessageString("Complete! StringCopy for CommandTool");
			}
			break;
		case 4:
			rStr = makeCopyString(eventNum4Edit.GetString(), param4Edit.GetString());
			if((rStr != ""))
			{
				ClipboardCopy(rStr);
				AddSystemMessageString("Complete! StringCopy for CommandTool");
			}
			break;
		case 5:
			rStr = makeCopyString(eventNum5Edit.GetString(), param5Edit.GetString());
			if((rStr != ""))
			{
				ClipboardCopy(rStr);
				AddSystemMessageString("Complete! StringCopy for CommandTool");
			}
			break;
		default:
			break;
	}
	return;
}

function string makeCopyString(string eventIDStr, string param)
{
	local int i;
	local string CommandStr;
	local array<string> commandArray;

	CommandStr = ("#event" $ eventIDStr);
	Split(param, " ", commandArray);
	i = 0;
	while((i < commandArray.Length))
	{
		CommandStr = ((CommandStr $ "#") $ trim(commandArray[i]));
		i++;
	}
	if((i == 0))
	{
		CommandStr = "";
	}
	Debug(("commandStr:" @ CommandStr));
	return CommandStr;
}

function event1BtnClick()
{
	ExecuteEvent(int(eventNum1Edit.GetString()), param1Edit.GetString());
	setEditByINI(currentPageNum, 1);
	return;
}

function event2BtnClick()
{
	ExecuteEvent(int(eventNum2Edit.GetString()), param2Edit.GetString());
	setEditByINI(currentPageNum, 2);
	return;
}

function event3BtnClick()
{
	ExecuteEvent(int(eventNum3Edit.GetString()), param3Edit.GetString());
	setEditByINI(currentPageNum, 3);
	return;
}

function event4BtnClick()
{
	ExecuteEvent(int(eventNum4Edit.GetString()), param4Edit.GetString());
	setEditByINI(currentPageNum, 4);
	return;
}

function event5BtnClick()
{
	ExecuteEvent(int(eventNum5Edit.GetString()), param5Edit.GetString());
	setEditByINI(currentPageNum, 5);
	return;
}

function callEventAllButtonClick()
{
	event1BtnClick();
	event2BtnClick();
	event3BtnClick();
	event4BtnClick();
	event5BtnClick();
	return;
}

function InitBtnClick()
{
	param1Edit.SetString("");
	param2Edit.SetString("");
	param3Edit.SetString("");
	param4Edit.SetString("");
	param5Edit.SetString("");
	eventNum1Edit.SetString("");
	eventNum2Edit.SetString("");
	eventNum3Edit.SetString("");
	eventNum4Edit.SetString("");
	eventNum5Edit.SetString("");
	return;
}

function renameBtnClick()
{
	local LVDataRecord Record;

	if((trim(TitleEditBox.GetString()) == ""))
	{
		return;
	}
	SetINIString(("EventPowerToolWnd" $ string(currentPageNum)), "eventNoteName", TitleEditBox.GetString(), "UIDEV.ini");
	noteListCtrl.GetSelectedRec(Record);
	Record.LVDataList[0].szData = TitleEditBox.GetString();
	noteListCtrl.ModifyRecord(noteListCtrl.GetSelectedIndex(), Record);
	return;
}

function loadEditByINI(int nPage, int Index)
{
	local string stringValue;

	stringValue = "";
	GetINIString(("EventPowerToolWnd" $ string(nPage)), ("event" $ string(Index)), stringValue, "UIDEV.ini");
	GetEditBoxHandle((("UIPowerToolWnd.param" $ string(Index)) $ "Edit")).SetString(stringValue);
	GetINIString(("EventPowerToolWnd" $ string(nPage)), ("eventNum" $ string(Index)), stringValue, "UIDEV.ini");
	GetEditBoxHandle((("UIPowerToolWnd.eventNum" $ string(Index)) $ "Edit")).SetString(stringValue);
	return;
}

function setEditByINI(int nPage, int Index)
{
	SetINIString(("EventPowerToolWnd" $ string(nPage)), ("event" $ string(Index)), GetEditBoxHandle((("UIPowerToolWnd.param" $ string(Index)) $ "Edit")).GetString(), "UIDEV.ini");
	SetINIString(("EventPowerToolWnd" $ string(nPage)), ("eventNum" $ string(Index)), GetEditBoxHandle((("UIPowerToolWnd.eventNum" $ string(Index)) $ "Edit")).GetString(), "UIDEV.ini");
	return;
}

function LoadIni()
{
	local int i, N;
	local string startNoteNum, currentNoteName;

	GetINIString("EventPowerToolWnd", "startNoteNum", startNoteNum, "UIDEV.ini");
	if((startNoteNum == ""))
	{
		SetINIString("EventPowerToolWnd", "startNoteNum", "1", "UIDEV.ini");
		currentPageNum = 1;
		noteListCtrl.DeleteAllItem();
		i = 1;
		while((i < 17))
		{
			currentNoteName = ("page" $ string(i));
			addListNote(currentNoteName, i);
			SetINIString(("EventPowerToolWnd" $ string(i)), "eventNoteName", currentNoteName, "UIDEV.ini");
			N = 1;
			while((N < 6))
			{
				makeListNote(i, currentNoteName, N);
				N++;
			}
			i++;
		}
		setEditByINI(currentPageNum, 1);
		setEditByINI(currentPageNum, 2);
		setEditByINI(currentPageNum, 3);
		setEditByINI(currentPageNum, 4);
		setEditByINI(currentPageNum, 5);
		noteListCtrl.SetSelectedIndex(0, false);
		TitleEditBox.SetString(currentNoteName);
	}
	else
	{
		GetINIString("EventPowerToolWnd", "startNoteNum", startNoteNum, "UIDEV.ini");
		currentPageNum = int(startNoteNum);
		noteListCtrl.DeleteAllItem();
		i = 1;
		while((i < 17))
		{
			GetINIString(("EventPowerToolWnd" $ string(i)), "eventNoteName", currentNoteName, "UIDEV.ini");
			addListNote(currentNoteName, i);
			if((string(i) == startNoteNum))
			{
				TitleEditBox.SetString(currentNoteName);
				N = 1;
				while((N < 6))
				{
					loadEditByINI(int(startNoteNum), N);
					N++;
				}
				noteListCtrl.SetSelectedIndex((currentPageNum - 1), false);
			}
			i++;
		}
	}
	return;
}

function makeListNote(int PageNum, string noteName, int paramNum)
{
	if((trim(noteName) != ""))
	{
		SetINIString(("EventPowerToolWnd" $ string(PageNum)), ("event" $ string(paramNum)), "", "UIDEV.ini");
		SetINIString(("EventPowerToolWnd" $ string(PageNum)), ("eventNum" $ string(paramNum)), "", "UIDEV.ini");
	}
	return;
}

function addListNote(string noteName, int nPageNum)
{
	local LVDataRecord Record;

	if((trim(noteName) != ""))
	{
		Record.LVDataList.Length = 1;
		Record.LVDataList[0].szData = noteName;
		Record.LVDataList[0].nReserved1 = nPageNum;
		noteListCtrl.InsertRecord(Record);
	}
	return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	local LVDataRecord Record;
	local int N;

	if((ListCtrlID == "noteListCtrl"))
	{
		if((noteListCtrl.GetSelectedIndex() > -1))
		{
			saveCurrentPage();
			noteListCtrl.GetSelectedRec(Record);
			N = 1;
			while((N < 6))
			{
				loadEditByINI(Record.LVDataList[0].nReserved1, N);
				N++;
			}
			TitleEditBox.SetString(Record.LVDataList[0].szData);
			currentPageNum = Record.LVDataList[0].nReserved1;
			SetINIString("EventPowerToolWnd", "startNoteNum", string(currentPageNum), "UIDEV.ini");
		}
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("UIPowerToolWnd").HideWindow();
	nReloadOpen = false;
	return;
}
