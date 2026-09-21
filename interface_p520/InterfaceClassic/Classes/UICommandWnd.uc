class UICommandWnd extends UICommonAPI;

const TIMER_ID = 601221;
const TIMER_ID_RUN = 601222;

var WindowHandle Me;
var ListCtrlHandle itemListCtrl;
var ListCtrlHandle noteListCtrl;
var EditBoxHandle inputEditBox;
var EditBoxHandle descViewEditBox;
var EditBoxHandle newNoteEditBox;
var EditBoxHandle runTimeEditBox;
var EditBoxHandle itemToolEditBox;
var TextBoxHandle noteNameTextBox;
var CheckBoxHandle autoOpenCheckBox;
var CheckBoxHandle textBuildCommandCutCheckBox;
var CheckBoxHandle textSpCutCheckBox;
var CheckBoxHandle runExceptionCheckBox;
var ButtonHandle runDownBtn;
var ButtonHandle runUpBtn;
var ButtonHandle removeListBtn;
var ButtonHandle editBtn;
var ButtonHandle deleteNoteBtn;
var ButtonHandle newNoteBtn;
var ButtonHandle selfTargetBtn;
var int nAutoOpen;
var bool nReloadOpen;
var bool isStepRun;
var string currentNoteName;
var array<string> noteArray;

function OnRegisterEvent()
{
	RegisterEvent(20);
	RegisterEvent(9570);
	RegisterEvent(9750);
	RegisterEvent(40);
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent(3410);
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
	Me = GetWindowHandle("UICommandWnd");
	inputEditBox = GetEditBoxHandle("UICommandWnd.inputEditBox");
	descViewEditBox = GetEditBoxHandle("UICommandWnd.descViewEditBox");
	newNoteEditBox = GetEditBoxHandle("UICommandWnd.newNoteEditBox");
	runTimeEditBox = GetEditBoxHandle("UICommandWnd.runTimeEditBox");
	itemToolEditBox = GetEditBoxHandle("UICommandWnd.itemToolEditBox");
	noteNameTextBox = GetTextBoxHandle("UICommandWnd.noteNameTextBox");
	itemListCtrl = GetListCtrlHandle("UICommandWnd.itemListCtrl");
	noteListCtrl = GetListCtrlHandle("UICommandWnd.noteListCtrl");
	autoOpenCheckBox = GetCheckBoxHandle("UICommandWnd.autoOpenCheckBox");
	textBuildCommandCutCheckBox = GetCheckBoxHandle("UICommandWnd.textBuildCommandCutCheckBox");
	textSpCutCheckBox = GetCheckBoxHandle("UICommandWnd.textSpCutCheckBox");
	runExceptionCheckBox = GetCheckBoxHandle("UICommandWnd.runExceptionCheckBox");
	nAutoOpen = -9999;
	runTimeEditBox.SetString("1");
	playButtonTexture(true);
	setWindowTitleByString("UITools [BuildCommandNote] - ver:1.3 - By Dongland");
	return;
}

function playButtonTexture(bool bPlay)
{
	if(bPlay)
	{
		GetButtonHandle("UICommandWnd.executeAllBtn").SetTexture("L2UI_ct1.24Hz.24Hz_DF_PlayControlBtn_Play", "L2UI_ct1.24Hz.24Hz_DF_PlayControlBtn_Play_Down", "L2UI_ct1.24Hz.24Hz_DF_PlayControlBtn_Play_Over");
	}
	else
	{
		GetButtonHandle("UICommandWnd.executeAllBtn").SetTexture("L2UI_ct1.24Hz.24Hz_DF_PlayControlBtn_Stop", "L2UI_ct1.24Hz.24Hz_DF_PlayControlBtn_Stop_Down", "L2UI_ct1.24Hz.24Hz_DF_PlayControlBtn_Stop_Over");
	}
	return;
}

function OnShow()
{
	if((int(GetReleaseMode()) != 0))
	{
		Me.HideWindow();
	}
	nReloadOpen = true;
	LoadIni();
	Me.SetFocus();
	return;
}

function LoadIni()
{
	local int i, nTextSpCutCheckBox, nTextBuildCommandCutCheckBox, nRunExceptionCheckBox;
	local string noteListStr, strRunTimeEditBox;

	noteArray.Remove(0, noteArray.Length);
	GetINIString("___CommonInfo___", "runTimeEditBox", strRunTimeEditBox, "UIDEV_BuildCommand.ini");
	if((strRunTimeEditBox != ""))
	{
		runTimeEditBox.SetString(strRunTimeEditBox);
	}
	GetINIInt("___CommonInfo___", "textSpCutCheckBox", nTextSpCutCheckBox, "UIDEV_BuildCommand.ini");
	GetINIInt("___CommonInfo___", "textBuildCommandCutCheckBox", nTextBuildCommandCutCheckBox, "UIDEV_BuildCommand.ini");
	GetINIInt("___CommonInfo___", "runExceptionCheckBox", nRunExceptionCheckBox, "UIDEV_BuildCommand.ini");
	if((nTextSpCutCheckBox != -1))
	{
		textSpCutCheckBox.SetCheck(numToBool(nTextSpCutCheckBox));
	}
	if((nTextBuildCommandCutCheckBox != -1))
	{
		textBuildCommandCutCheckBox.SetCheck(numToBool(nTextBuildCommandCutCheckBox));
	}
	if((nRunExceptionCheckBox != -1))
	{
		runExceptionCheckBox.SetCheck(numToBool(nRunExceptionCheckBox));
	}
	GetINIString("___CommonInfo___", "startNote", currentNoteName, "UIDEV_BuildCommand.ini");
	GetINIString("___CommonInfo___", "noteList", noteListStr, "UIDEV_BuildCommand.ini");
	if(((currentNoteName == "") && (noteListStr == "")))
	{
		SetINIString("___CommonInfo___", "startNote", "baseNote", "UIDEV_BuildCommand.ini");
		currentNoteName = "baseNote";
		makeNewNote(currentNoteName);
	}
	else
	{
		Split(noteListStr, "|", noteArray);
		noteListCtrl.DeleteAllItem();
		i = 0;
		while((i < noteArray.Length))
		{
			addListNote(noteArray[i]);
			if((noteArray[i] == currentNoteName))
			{
				noteListCtrl.SetSelectedIndex(i, true);
			}
			i++;
		}
		if(((currentNoteName == "") && (noteArray.Length > 0)))
		{
			currentNoteName = noteArray[0];
			SetINIString("___CommonInfo___", "startNote", currentNoteName, "UIDEV_BuildCommand.ini");
		}
	}
	openNoteCommand(currentNoteName);
	return;
}

function openNoteCommand(string openNoteName)
{
	local int Max, i;
	local string cmdStr;

	currentNoteName = openNoteName;
	itemListCtrl.DeleteAllItem();
	noteNameTextBox.SetText(currentNoteName);
	GetINIInt(currentNoteName, "max", Max, "UIDEV_BuildCommand.ini");
	i = 0;
	while((i < Max))
	{
		GetINIString(currentNoteName, string(i), cmdStr, "UIDEV_BuildCommand.ini");
		if((cmdStr != ""))
		{
			AddList(i, cmdStr);
		}
		i++;
	}
	if((itemListCtrl.GetRecordCount() > 0))
	{
		SetINIInt(currentNoteName, "max", itemListCtrl.GetRecordCount(), "UIDEV_BuildCommand.ini");
	}
	SetINIString("___CommonInfo___", "startNote", currentNoteName, "UIDEV_BuildCommand.ini");
	return;
}

function OnCompleteEditBox(string strID)
{
	local string strInput;

	if((currentNoteName == ""))
	{
		getInstanceL2Util().showGfxScreenMessage("저정된 노트가 없습니다. 새로 만들거나 노트를 열어주세요.");  // EN: there is no saved note. Create a new one or open an existing note.
		return;
	}
	if((strID == "inputEditBox"))
	{
		strInput = inputEditBox.GetString();
		if((Len(strInput) < 1))
		{
			return;
		}
		if(textSpCutCheckBox.IsChecked())
		{
			strInput = deleteSpStr(strInput);
		}
		executeLineCommand(strInput);
		inputEditBox.SetString("");
		AddCommandList(currentNoteName, strInput);
		itemListCtrl.SetSelectedIndex((itemListCtrl.GetRecordCount() - 1), true);
	}
	else if((strID == "descViewEditBox"))
	{
		strInput = descViewEditBox.GetString();
		if((Len(strInput) < 1))
		{
			return;
		}
		OnEditBtnClick();
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int nOpen;

	if((int(GetReleaseMode()) != 0))
	{
		return;
	}
	if((Event_ID == 1710))
	{
		if(DialogIsMine())
		{
			removeNote();
		}
	}
	else if((Event_ID == 1720))
	{
	}
	else if((Event_ID == 20))
	{
		pasteClipboardAtList();
	}
	else if((Event_ID == 40))
	{
		nReloadOpen = false;
		nAutoOpen = -9999;
		inputEditBox.ClearAdditionalSearchList(SLT_ADDITIONAL_LIST);
		Me.KillTimer(601222);
		playButtonTexture(true);
		isStepRun = false;
	}
	else if((Event_ID == 9750))
	{
		if((nAutoOpen == -9999))
		{
			GetINIInt("___CommonInfo___", "autoOpen", nAutoOpen, "UIDEV_BuildCommand.ini");
			if((nAutoOpen == 1))
			{
				Me.ShowWindow();
				autoOpenCheckBox.SetCheck(true);
			}
			else
			{
				autoOpenCheckBox.SetCheck(false);
			}
			Me.SetTimer(601221, 5000);
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
			GetINIInt("___CommonInfo___", "autoOpen", nOpen, "UIDEV_BuildCommand.ini");
			if((nOpen == 1))
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

function OnTimer(int TimerID)
{
	local string noteListStr;
	local array<string> tempNoteArray;
	local int i;

	if((TimerID == 601221))
	{
		GetINIString("___CommonInfo___", "noteList", noteListStr, "UIDEV_BuildCommand.ini");
		if((noteListStr != ""))
		{
			Split(noteListStr, "|", tempNoteArray);
			i = 0;
			while((i < tempNoteArray.Length))
			{
				if((tempNoteArray[i] == "[start]"))
				{
					autoExecuteCommand("[start]");
					break;
				}
				i++;
			}
		}
		Me.KillTimer(601221);
	}
	else if((TimerID == 601222))
	{
		if(((itemListCtrl.GetSelectedIndex() + 1) == itemListCtrl.GetRecordCount()))
		{
			Me.KillTimer(601222);
			isStepRun = false;
			playButtonTexture(true);
			Debug("TIMER_ID_RUN 중지");  // EN: TIMER_ID_RUN stopped
		}
		OnRunDownBtnClick();
	}
	return;
}

function OnHide()
{
	Me.KillTimer(601222);
	isStepRun = false;
	playButtonTexture(true);
	return;
}

function stepTimeExecuteCommand()
{
	Me.KillTimer(601222);
	if(isStepRun)
	{
		isStepRun = false;
		playButtonTexture(true);
		return;
	}
	SetINIString("___CommonInfo___", "runTimeEditBox", runTimeEditBox.GetString(), "UIDEV_BuildCommand.ini");
	if((itemListCtrl.GetSelectedIndex() < 0))
	{
		getInstanceL2Util().showGfxScreenMessage("Stop Command!");
		return;
	}
	if((float(runTimeEditBox.GetString()) > 0.0000000))
	{
		isStepRun = true;
		Me.SetTimer(601222, int(float(runTimeEditBox.GetString())));
		getInstanceL2Util().showGfxScreenMessage((runTimeEditBox.GetString() @ ", 1/1000초당, 한줄씩 커맨드를 실행!"));  // EN: , runs one command line every 1/1000 second!
		playButtonTexture(false);
	}
	else
	{
		autoExecuteCommand(currentNoteName);
		getInstanceL2Util().showGfxScreenMessage((currentNoteName @ "노트의 전체 커맨드를 실행!"));  // EN: run every command in the note!
	}
	return;
}

function autoExecuteCommand(string executeNoteName)
{
	local int Max, i;
	local string cmdStr;

	if((executeNoteName == ""))
	{
		return;
	}
	GetINIInt(executeNoteName, "max", Max, "UIDEV_BuildCommand.ini");
	i = 0;
	while((i < Max))
	{
		GetINIString(executeNoteName, string(i), cmdStr, "UIDEV_BuildCommand.ini");
		if((cmdStr != ""))
		{
			executeLineCommand(cmdStr);
		}
		i++;
	}
	return;
}

function AddCommandList(string section, string bCommandStr)
{
	if((bCommandStr != ""))
	{
		SetINIString(section, string(itemListCtrl.GetRecordCount()), bCommandStr, "UIDEV_BuildCommand.ini");
		AddList(itemListCtrl.GetRecordCount(), bCommandStr);
		SetINIInt(currentNoteName, "max", itemListCtrl.GetRecordCount(), "UIDEV_BuildCommand.ini");
		SaveINI("UIDEV_BuildCommand.ini");
	}
	return;
}

function addListNote(string noteName)
{
	local LVDataRecord Record;

	if((trim(noteName) != ""))
	{
		Record.LVDataList.Length = 1;
		Record.LVDataList[0].szData = noteName;
		Record.LVDataList[0].HiddenStringForSorting = getInstanceL2Util().makeZeroString(6, INT64(noteListCtrl.GetRecordCount()));
		noteListCtrl.InsertRecord(Record);
	}
	return;
}

function removeNote()
{
	local LVDataRecord Record;

	if((noteListCtrl.GetSelectedIndex() > -1))
	{
		noteListCtrl.GetSelectedRec(Record);
		removeNoteArray(Record.LVDataList[0].szData);
		noteListCtrl.DeleteRecord(noteListCtrl.GetSelectedIndex());
		RemoveINI(Record.LVDataList[0].szData, "", "UIDEV_BuildCommand.ini");
		if((currentNoteName == Record.LVDataList[0].szData))
		{
			currentNoteName = "";
			noteNameTextBox.SetText(currentNoteName);
			itemListCtrl.DeleteAllItem();
			descViewEditBox.SetString("");
			inputEditBox.SetString("");
			if((noteListCtrl.GetRecordCount() > 0))
			{
				if((noteListCtrl.GetSelectedIndex() > -1))
				{
					noteListCtrl.GetSelectedRec(Record);
				}
			}
			SetINIString("___CommonInfo___", "startNote", "", "UIDEV_BuildCommand.ini");
		}
		SaveINI("UIDEV_BuildCommand.ini");
	}
	return;
}

function string getNoteSelectedName()
{
	local LVDataRecord Record;

	noteListCtrl.GetSelectedRec(Record);
	return Record.LVDataList[0].szData;
}

function reNameNewNote(string noteName)
{
	local int i;
	local string listStr;

	if((trim(noteName) == ""))
	{
		return;
	}
	if(hasNoteInArray(noteName))
	{
		getInstanceL2Util().showGfxScreenMessage((noteName @ "이미 같은 이름의 노트가 있습니다."));  // EN?: A religion with that name has already been created.
		return;
	}
	SetINIString("___CommonInfo___", "startNote", noteName, "UIDEV_BuildCommand.ini");
	i = 0;
	while((i < noteArray.Length))
	{
		if((noteArray[i] == getNoteSelectedName()))
		{
			noteArray[i] = noteName;
		}
		if((i == 0))
		{
			listStr = (listStr $ noteArray[i]);
			i++;
			continue;
		}
		listStr = ((listStr $ "|") $ noteArray[i]);
		i++;
	}
	SetINIString("___CommonInfo___", "noteList", listStr, "UIDEV_BuildCommand.ini");
	removeAndRenameNoteCommand(getNoteSelectedName(), noteName);
	LoadIni();
	return;
}

function removeAndRenameNoteCommand(string openNoteName, string renameString)
{
	local int Max, i;
	local string cmdStr;

	GetINIInt(openNoteName, "max", Max, "UIDEV_BuildCommand.ini");
	SetINIInt(renameString, "max", Max, "UIDEV_BuildCommand.ini");
	i = 0;
	while((i < Max))
	{
		GetINIString(openNoteName, string(i), cmdStr, "UIDEV_BuildCommand.ini");
		if((cmdStr != ""))
		{
			SetINIString(renameString, string(i), cmdStr, "UIDEV_BuildCommand.ini");
		}
		i++;
	}
	removeNoteArray(openNoteName);
	RemoveINI(openNoteName, "", "UIDEV_BuildCommand.ini");
	SaveINI("UIDEV_BuildCommand.ini");
	return;
}

function makeNewNote(string noteName)
{
	if((trim(noteName) != ""))
	{
		if(hasNoteInArray(noteName))
		{
			getInstanceL2Util().showGfxScreenMessage((noteName @ "이미 같은 이름의 노트가 있습니다."));  // EN?: A religion with that name has already been created.
			return;
		}
		getInstanceL2Util().showGfxScreenMessage((noteName @ "노트를 생성 하였습니다."));  // EN: the note has been created.
		SetINIString("___CommonInfo___", "startNote", noteName, "UIDEV_BuildCommand.ini");
		SetINIInt(noteName, "max", 0, "UIDEV_BuildCommand.ini");
		noteNameTextBox.SetText(noteName);
		descViewEditBox.SetString("");
		newNoteEditBox.SetString("");
		addNoteArray(noteName);
		LoadIni();
	}
	return;
}

function removeNoteArray(string noteName)
{
	local int Index, i;
	local string listStr;

	Index = getNoteIndexInArray(noteName);
	if((Index > -1))
	{
		getInstanceL2Util().showGfxScreenMessage((noteName @ "노트를 삭제 하였습니다."));  // EN: the note has been deleted.
		noteArray.Remove(Index, 1);
	}
	i = 0;
	while((i < noteArray.Length))
	{
		if((i == 0))
		{
			listStr = (listStr $ noteArray[i]);
			i++;
			continue;
		}
		listStr = ((listStr $ "|") $ noteArray[i]);
		i++;
	}
	SetINIString("___CommonInfo___", "noteList", listStr, "UIDEV_BuildCommand.ini");
	return;
}

function addNoteArray(string noteName)
{
	local int i, lenArray;
	local string listStr;
	local array<string> noteArrayTemp;

	i = 0;
	while((i < noteArray.Length))
	{
		noteArrayTemp[i] = noteArray[i];
		i++;
	}
	if(!hasNoteInArray(noteName))
	{
		noteArray[0] = noteName;
		lenArray = noteArrayTemp.Length;
		i = 0;
		while((i < lenArray))
		{
			noteArray[(i + 1)] = noteArrayTemp[i];
			i++;
		}
	}
	else
	{
		return;
	}
	i = 0;
	while((i < noteArray.Length))
	{
		if((i == 0))
		{
			listStr = (listStr $ noteArray[i]);
			i++;
			continue;
		}
		listStr = ((listStr $ "|") $ noteArray[i]);
		i++;
	}
	SetINIString("___CommonInfo___", "noteList", listStr, "UIDEV_BuildCommand.ini");
	SaveINI("UIDEV_BuildCommand.ini");
	return;
}

function int getNoteIndexInArray(string noteName)
{
	local int i;

	i = 0;
	while((i < noteArray.Length))
	{
		if((noteArray[i] == noteName))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function bool hasNoteInArray(string noteName)
{
	local int i;

	i = 0;
	while((i < noteArray.Length))
	{
		if((noteArray[i] == noteName))
		{
			return true;
		}
		i++;
	}
	return false;
}

function AddList(int Index, string bCommandStr)
{
	local LVDataRecord Record;

	Record.LVDataList.Length = 2;
	Record.LVDataList[0].szData = string(Index);
	Record.LVDataList[0].HiddenStringForSorting = getInstanceL2Util().makeZeroString(6, INT64(Index));
	Record.LVDataList[1].szData = bCommandStr;
	itemListCtrl.InsertRecord(Record);
	inputEditBox.AddNameToAdditionalSearchList(bCommandStr, SLT_ADDITIONAL_LIST);
	return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	local LVDataRecord Record;

	if((ListCtrlID == "itemListCtrl"))
	{
		if((itemListCtrl.GetSelectedIndex() > -1))
		{
			itemListCtrl.GetSelectedRec(Record);
			descViewEditBox.SetString(Record.LVDataList[1].szData);
		}
	}
	return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	local LVDataRecord Record;

	if((ListCtrlID == "itemListCtrl"))
	{
		itemListCtrl.GetSelectedRec(Record);
		if((Record.LVDataList[1].szData != ""))
		{
			executeLineCommand(Record.LVDataList[1].szData);
		}
	}
	else if((ListCtrlID == "noteListCtrl"))
	{
		noteListCtrl.GetSelectedRec(Record);
		if((Record.LVDataList[0].szData != ""))
		{
			openNoteCommand(Record.LVDataList[0].szData);
			getInstanceL2Util().showGfxScreenMessage((Record.LVDataList[0].szData @ "노트를 오픈 했습니다!"));  // EN: the note has been opened!
		}
	}
	return;
}

function OnRButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	inputEditBox.SetFocus();
	return;
}

function OnRClickListCtrlRecord(string ListCtrlID)
{
	local LVDataRecord Record;

	if((ListCtrlID == "itemListCtrl"))
	{
		itemListCtrl.GetSelectedRec(Record);
		if((Record.LVDataList[1].szData != ""))
		{
			OnClickListCtrlRecord("itemListCtrl");
			descViewEditBox.SetFocus();
		}
	}
	else if((ListCtrlID == "noteListCtrl"))
	{
		noteListCtrl.GetSelectedRec(Record);
		if((Record.LVDataList[0].szData != ""))
		{
			openNoteCommand(Record.LVDataList[0].szData);
			getInstanceL2Util().showGfxScreenMessage((Record.LVDataList[0].szData @ "노트를 오픈 했습니다!"));  // EN: the note has been opened!
		}
	}
	return;
}

function removeListItem()
{
	local int i, currMax;
	local bool bLast;
	local LVDataRecord Record;

	if((itemListCtrl.GetSelectedIndex() > -1))
	{
		if((itemListCtrl.GetRecordCount() > 0))
		{
			if((itemListCtrl.GetSelectedIndex() == (itemListCtrl.GetRecordCount() - 1)))
			{
				bLast = true;
			}
		}
		currMax = itemListCtrl.GetRecordCount();
		itemListCtrl.GetSelectedRec(Record);
		inputEditBox.DeleteNameFromAdditionalSearchList(Record.LVDataList[1].szData, SLT_ADDITIONAL_LIST);
		itemListCtrl.DeleteRecord(itemListCtrl.GetSelectedIndex());
		if((bLast && (itemListCtrl.GetRecordCount() > 0)))
		{
			itemListCtrl.SetSelectedIndex((itemListCtrl.GetRecordCount() - 1), true);
		}
		OnClickListCtrlRecord("itemListCtrl");
		i = itemListCtrl.GetSelectedIndex();
		while((i < currMax))
		{
			itemListCtrl.GetRec(i, Record);
			if((i < itemListCtrl.GetRecordCount()))
			{
				SetINIString(currentNoteName, string(i), Record.LVDataList[1].szData, "UIDEV_BuildCommand.ini");
				i++;
				continue;
			}
			RemoveINI(currentNoteName, string(i), "UIDEV_BuildCommand.ini");
			i++;
		}
		SetINIInt(currentNoteName, "max", itemListCtrl.GetRecordCount(), "UIDEV_BuildCommand.ini");
		SaveINI("UIDEV_BuildCommand.ini");
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
		case "textBuildCommandCutCheckBox":
			OnTextBuildCommandCutCheckBoxClick();
			break;
		case "textSpCutCheckBox":
			OnTextSpCutCheckBoxClick();
			break;
		case "runExceptionCheckBox":
			OnRunExceptionCheckBoxClick();
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
		case "runUpBtn":
			OnRunUpBtnClick();
			break;
		case "runDownBtn":
			OnRunDownBtnClick();
			break;
		case "editBtn":
			OnEditBtnClick();
			break;
		case "copyBtn":
			onCopyBtnClick();
			break;
		case "removeListBtn":
			removeListItem();
			break;
		case "selfTargetBtn":
			OnSelfTargetBtn();
			break;
		case "searchToolBtn":
			if(IsShowWindow("GMFindTreeWnd"))
			{
				HideWindow("GMFindTreeWnd");
			}
			else
			{
				GMWnd(GetScript("GMWnd")).OnClickNPCListButton();
			}
			break;
		case "itemBtn":
			toggleWindow("UIItemToolWnd", true);
			if((itemToolEditBox.GetString() != ""))
			{
				UIItemToolWnd(GetScript("UIItemToolWnd")).executeSearch(itemToolEditBox.GetString());
			}
			break;
		case "newNoteBtn":
			makeNewNote(newNoteEditBox.GetString());
			break;
		case "reNameNoteBtn":
			reNameNewNote(newNoteEditBox.GetString());
			break;
		case "deleteNoteBtn":
			DialogSetID(10234);
			DialogShow(DialogModalType_Modalless, DialogType_Warning, "노트를 정말 삭제 할까요?");  // EN: really delete the note?
			break;
		case "powerBtn":
			RequestSelfTarget();
			ExecuteCommand("//스킬사용 7029 3");  // EN: //use skill 7029 3
			ExecuteCommand("//스킬 4101 1");  // EN: //skill 4101 1
			getInstanceL2Util().showGfxScreenMessage("슈퍼헤이스트: 힘차고 강한 버프!");  // EN: Super Haste: a strong, powerful buff!
			break;
		case "swordBtn":
			ExecuteCommand("//생성 1305");  // EN: //spawn 1305
			getInstanceL2Util().showGfxScreenMessage("강한 무기 ID: 1305 획득!");  // EN: strong weapon ID: 1305 obtained!
			break;
		case "homeBtn":
			ExecuteCommand("//home");
			getInstanceL2Util().showGfxScreenMessage("//home 위치로 이동");  // EN: //move to home location
			break;
		case "hideOffBtn":
			ExecuteCommand("//투명 끔");  // EN: //invisibility off
			break;
		case "executeAllBtn":
			stepTimeExecuteCommand();
			break;
		case "lineUpMoveButton":
			OnLineUpBtnClick();
			break;
		case "lineDownMoveButton":
			OnLineDownBtnClick();
			break;
		case "helpBtn":
			ShowHelp();
			break;
		case "test1Button":
			Debug("test1Button");
			break;
		case "uiOpenButton":
			toggleWindow("UIOpenToolWnd", true);
			break;
		case "GMButton":
			toggleWindow("GMWnd", true);
			break;
		case "powerToolButton":
			toggleWindow("UIPowerToolWnd", true);
			break;
		case "reloadFSButton":
			ExecuteCommand("///reloadfs");
			break;
		case "rebuildUIButton":
			ExecuteCommand("///rebuildui");
			break;
		case "uiDebugButton":
			toggleWindow("DebugWnd", true);
			break;
		case "restartButton":
			ExecRestart();
			break;
		case "locSaveBtn":
			savePostion();
			break;
		case "resetUIButton":
			getInstanceUIData().ResetUIData();
			break;
		case "noteUpMoveButton":
			OnNoteUpMoveButtonClick();
			break;
		case "noteDownMoveButton":
			OnNoteDownMoveButtonClick();
			break;
		default:
			break;
	}
	return;
}

function OnNoteUpMoveButtonClick()
{
	local LVDataRecord Record, tmRecord;
	local int selectIndex;

	if((noteListCtrl.GetSelectedIndex() > -1))
	{
		noteListCtrl.GetSelectedRec(Record);
		selectIndex = (noteListCtrl.GetSelectedIndex() - 1);
		if((selectIndex > -1))
		{
			noteListCtrl.GetRec(selectIndex, tmRecord);
			noteListCtrl.ModifyRecord(noteListCtrl.GetSelectedIndex(), tmRecord);
			noteListCtrl.ModifyRecord(selectIndex, Record);
		}
		if((selectIndex >= 0))
		{
			noteListCtrl.SetSelectedIndex(selectIndex, false);
			OnClickListCtrlRecord("noteListCtrl");
			noteListCtrl.SetFocus();
		}
	}
	relistSaveNote();
	return;
}

function OnNoteDownMoveButtonClick()
{
	local LVDataRecord Record, tmRecord;
	local int selectIndex;

	if((noteListCtrl.GetSelectedIndex() > -1))
	{
		noteListCtrl.GetSelectedRec(Record);
		selectIndex = (noteListCtrl.GetSelectedIndex() + 1);
		if((selectIndex < noteListCtrl.GetRecordCount()))
		{
			noteListCtrl.GetRec(selectIndex, tmRecord);
			noteListCtrl.ModifyRecord(noteListCtrl.GetSelectedIndex(), tmRecord);
			noteListCtrl.ModifyRecord(selectIndex, Record);
		}
		if((selectIndex < noteListCtrl.GetRecordCount()))
		{
			noteListCtrl.SetSelectedIndex(selectIndex, false);
			OnClickListCtrlRecord("noteListCtrl");
			noteListCtrl.SetFocus();
		}
	}
	relistSaveNote();
	return;
}

function relistSaveNote()
{
	local int i;
	local string listStr;
	local LVDataRecord tmRecord;

	noteArray.Remove(0, noteArray.Length);
	i = 0;
	while((i < noteListCtrl.GetRecordCount()))
	{
		noteListCtrl.GetRec(i, tmRecord);
		noteArray.Length = (noteArray.Length + 1);
		noteArray[i] = tmRecord.LVDataList[0].szData;
		i++;
	}
	i = 0;
	while((i < noteArray.Length))
	{
		if((i == 0))
		{
			listStr = (listStr $ noteArray[i]);
			i++;
			continue;
		}
		listStr = ((listStr $ "|") $ noteArray[i]);
		i++;
	}
	SetINIString("___CommonInfo___", "noteList", listStr, "UIDEV_BuildCommand.ini");
	SaveINI("UIDEV_BuildCommand.ini");
	return;
}

function savePostion()
{
	local Vector PlayerPosition;

	PlayerPosition = GetPlayerPosition();
	inputEditBox.SetString(((("//텔 " $ string(PlayerPosition.X)) @ string(PlayerPosition.Y)) @ string(PlayerPosition.Z)));  // EN: //teleport
	inputEditBox.SetFocus();
	return;
}

function string htmlSetHtmlStart(string targetHtml)
{
	return (("<html><body>" $ targetHtml) $ "</body></html>");
}

function ShowHelp()
{
	local string param, Desc;

	Desc = (((((((((((((((((((((((((((((((((" - UI 빌드 명령어 노트 - <br1>" $ "빌드 명령어를 반복적으로 치기 귀찮아서 만든 툴입니다.<br1>") $ "<br>") $ "클라이언트 System 폴더UIDEV_BuildCommand.ini 에 저장 됩니다.<br1>") $ "노트식으로 사용해도 되고, 빌드명령어 실행기로 사용해도 됩니다.<br1>") $ "<br>") $ " =========== 특수 기능 목록 ========<br1>") $ "* TTP등 여러 줄로 된 빌드 명령어를 복사 해서 붙이는 기능 <br1>") $ " ex) '//', '///' 빌드 커멘트 표식이전에 다양한 스트링이 붙어 있는 멀티라인을 한번에 클립보드에 복사해서 붙이기를 해보세요.<br><br>") $ "  1.//투명 끔 <br1>") $ "  2.//생성 57 100 <br1>") $ "  - //생성 1 <br1>") $ "  - ///어쩌고 <br1>") $ "  - ///sw name=ActionWnd <br1>") $ "  <br>") $ " --------------------------------------  <br1>") $ "* 게임 실행시 빌드명령어 자동 실행 기능 - <br1>") $ "노트 이름을 [start] 로 지정하고 노트를 만들면, <br1>") $ "게임 시작시 해당 명령어 전체가 자동으로 실행됩니다..<br1>") $ " --------------------------------------  <br1>") $ "  <br>") $ "* UI 이벤트 강제 발생하기 <br1>") $ "ex) UI 이벤트 18번을 Param값으로 Flag=1 을 보내는 예<br1>") $ "#event18#Flag=1<br>") $ "  <br>") $ " --------------------------------------  <br1>") $ "* 반복 기능  #goto<br1>") $ "ex) 특정 명령어 줄로 이동 시켜 주는 기능입니다. 이걸 이용해서 반복 실행을 하면 편합니다.<br1>") $ "#goto2<br1>") $ "위 예제 처럼 입력하면 2번째 라인으로 이동합니다. #goto 명령은 0이 첫번째 줄입니다. <br1>") $ "* 최소 시간은 100, 0.1초 이상 입력해야 goto 명령어가 작동합니다. <br1>") $ "<br>") $ "문의 사항이나 버그는 UI팀 김동근(dongland@ncsoft.com) 로 알려주세요.<br1>") $ "<br1>");  // EN: - UI build command note - <br1> | EN: a tool made because typing build commands over and over is tedious.<br1> | EN: saved to UIDEV_BuildCommand.ini in the client System folder.<br1> | EN: use it as a notepad, or as a build-command runner.<br1> | EN: =========== special feature list ========<br1> | EN: * copy and paste multi-line build commands such as TTP <br1> | EN: ex) try copying a multi-line block with assorted strings before the '//' or '///' build-comment markers, and pasting it all at once.<br><br> | EN: 1.//invisibility off <br1> | EN: 2.//spawn 57 100 <br1> | EN: - //spawn 1 <br1> | EN: - ///whatever <br1> | EN: * run build commands automatically at game start - <br1> | EN: if you name a note [start] and create it, <br1> | EN: the whole command set runs automatically at game start..<br1> | EN: * force a UI event to fire <br1> | EN: ex) example of firing UI event 18 with Param Flag=1<br1> | EN: * repeat feature  #goto<br1> | EN: ex) jumps to a specific command line. Handy for running things repeatedly.<br1> | EN: entering it as above jumps to the second line. For #goto, 0 is the first line. <br1> | EN: * minimum is 100; goto only works at 0.1 seconds or more. <br1> | EN?: If you have any questions or bugs, please let us know at dongland@ncsoft.com<br1>
	ParamAdd(param, "HtmlString", htmlSetHtmlStart(Desc));
	HelpHtmlWnd(GetScript("HelpHtmlWnd")).HandleLoadHelpHtml(param);
	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HelpHtmlWnd");
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus("HelpHtmlWnd");
	return;
}

function OnAutoOpenCheckBoxBtnClick()
{
	SetINIInt("___CommonInfo___", "autoOpen", boolToNum(autoOpenCheckBox.IsChecked()), "UIDEV_BuildCommand.ini");
	SaveINI("UIDEV_BuildCommand.ini");
	return;
}

function OnTextBuildCommandCutCheckBoxClick()
{
	SetINIInt("___CommonInfo___", "textBuildCommandCutCheckBox", boolToNum(textBuildCommandCutCheckBox.IsChecked()), "UIDEV_BuildCommand.ini");
	SaveINI("UIDEV_BuildCommand.ini");
	return;
}

function OnTextSpCutCheckBoxClick()
{
	SetINIInt("___CommonInfo___", "textSpCutCheckBox", boolToNum(textBuildCommandCutCheckBox.IsChecked()), "UIDEV_BuildCommand.ini");
	SaveINI("UIDEV_BuildCommand.ini");
	return;
}

function OnRunExceptionCheckBoxClick()
{
	SetINIInt("___CommonInfo___", "runExceptionCheckBox", boolToNum(runExceptionCheckBox.IsChecked()), "UIDEV_BuildCommand.ini");
	SaveINI("UIDEV_BuildCommand.ini");
	return;
}

function OnSelfTargetBtn()
{
	RequestSelfTarget();
	return;
}

function OnRunUpBtnClick()
{
	local LVDataRecord Record;
	local int selectIndex;

	if((itemListCtrl.GetSelectedIndex() > -1))
	{
		itemListCtrl.GetSelectedRec(Record);
		if((Record.LVDataList[1].szData != ""))
		{
			executeLineCommand(Record.LVDataList[1].szData);
			getInstanceL2Util().showGfxScreenMessage(("실행:" @ Record.LVDataList[1].szData));  // EN: run:
		}
		selectIndex = (itemListCtrl.GetSelectedIndex() - 1);
		if((selectIndex >= 0))
		{
			itemListCtrl.SetSelectedIndex(selectIndex, false);
			OnClickListCtrlRecord("itemListCtrl");
			itemListCtrl.SetFocus();
		}
	}
	return;
}

function OnRunDownBtnClick()
{
	local LVDataRecord Record;
	local int selectIndex;

	if((itemListCtrl.GetSelectedIndex() > -1))
	{
		itemListCtrl.GetSelectedRec(Record);
		if((Record.LVDataList[1].szData != ""))
		{
			executeLineCommand(Record.LVDataList[1].szData);
			getInstanceL2Util().showGfxScreenMessage(("실행:" @ Record.LVDataList[1].szData));  // EN: run:
		}
		selectIndex = (itemListCtrl.GetSelectedIndex() + 1);
		if((selectIndex < itemListCtrl.GetRecordCount()))
		{
			itemListCtrl.SetSelectedIndex(selectIndex, false);
			OnClickListCtrlRecord("itemListCtrl");
			itemListCtrl.SetFocus();
		}
	}
	return;
}

function OnLineUpBtnClick()
{
	local LVDataRecord Record, tmRecord;
	local int selectIndex;

	if((itemListCtrl.GetSelectedIndex() > -1))
	{
		itemListCtrl.GetSelectedRec(Record);
		selectIndex = (itemListCtrl.GetSelectedIndex() - 1);
		if((selectIndex > -1))
		{
			itemListCtrl.GetRec(selectIndex, tmRecord);
			itemListCtrl.ModifyRecord(itemListCtrl.GetSelectedIndex(), tmRecord);
			itemListCtrl.ModifyRecord(selectIndex, Record);
			SetINIString(currentNoteName, string(itemListCtrl.GetSelectedIndex()), tmRecord.LVDataList[1].szData, "UIDEV_BuildCommand.ini");
			SetINIString(currentNoteName, string(selectIndex), Record.LVDataList[1].szData, "UIDEV_BuildCommand.ini");
			SaveINI("UIDEV_BuildCommand.ini");
		}
		if((selectIndex >= 0))
		{
			itemListCtrl.SetSelectedIndex(selectIndex, false);
			OnClickListCtrlRecord("itemListCtrl");
			itemListCtrl.SetFocus();
		}
	}
	return;
}

function OnLineDownBtnClick()
{
	local LVDataRecord Record, tmRecord;
	local int selectIndex;

	if((itemListCtrl.GetSelectedIndex() > -1))
	{
		itemListCtrl.GetSelectedRec(Record);
		selectIndex = (itemListCtrl.GetSelectedIndex() + 1);
		if((selectIndex < itemListCtrl.GetRecordCount()))
		{
			itemListCtrl.GetRec(selectIndex, tmRecord);
			itemListCtrl.ModifyRecord(itemListCtrl.GetSelectedIndex(), tmRecord);
			itemListCtrl.ModifyRecord(selectIndex, Record);
			SetINIString(currentNoteName, string(itemListCtrl.GetSelectedIndex()), tmRecord.LVDataList[1].szData, "UIDEV_BuildCommand.ini");
			SetINIString(currentNoteName, string(selectIndex), Record.LVDataList[1].szData, "UIDEV_BuildCommand.ini");
			SaveINI("UIDEV_BuildCommand.ini");
		}
		if((selectIndex < itemListCtrl.GetRecordCount()))
		{
			itemListCtrl.SetSelectedIndex(selectIndex, false);
			OnClickListCtrlRecord("itemListCtrl");
			itemListCtrl.SetFocus();
		}
	}
	return;
}

function onCopyBtnClick()
{
	local LVDataRecord Record;
	local string totalString;
	local int i;

	i = 0;
	while((i < itemListCtrl.GetRecordCount()))
	{
		itemListCtrl.GetRec(i, Record);
		totalString = ((totalString $ Record.LVDataList[1].szData) $ Chr(13));
		i++;
	}
	if((Len(totalString) > 0))
	{
		getInstanceL2Util().showGfxScreenMessage("명령어 page를 클립 보드에 카피 했습니다.");  // EN?: Command page copied to clipboard.
		ClipboardCopy(totalString);
	}
	return;
}

function OnEditBtnClick()
{
	local LVDataRecord Record;
	local int selectIndex;

	selectIndex = itemListCtrl.GetSelectedIndex();
	if((selectIndex > -1))
	{
		if((descViewEditBox.GetString() != ""))
		{
			itemListCtrl.GetSelectedRec(Record);
			inputEditBox.DeleteNameFromAdditionalSearchList(Record.LVDataList[1].szData, SLT_ADDITIONAL_LIST);
			Record.LVDataList[1].szData = descViewEditBox.GetString();
			itemListCtrl.ModifyRecord(selectIndex, Record);
			inputEditBox.AddNameToAdditionalSearchList(descViewEditBox.GetString(), SLT_ADDITIONAL_LIST);
			SetINIString(currentNoteName, string(selectIndex), descViewEditBox.GetString(), "UIDEV_BuildCommand.ini");
			SaveINI("UIDEV_BuildCommand.ini");
		}
	}
	return;
}

function pasteClipboardAtList()
{
	local array<string> commandArray;
	local int idx;
	local string pasteString, CommandStr;

	if((!Me.IsShowWindow() || !inputEditBox.IsFocused()))
	{
		return;
	}
	CommandStr = ClipboardPaste();
	if((InStr(CommandStr, Chr(13)) != -1))
	{
		Split(CommandStr, Chr(13), commandArray);
		idx = 0;
		while((idx < commandArray.Length))
		{
			pasteString = deleteEnter(commandArray[idx]);
			if(textSpCutCheckBox.IsChecked())
			{
				pasteString = deleteSpStr(pasteString);
			}
			if(textBuildCommandCutCheckBox.IsChecked())
			{
				if((InStr(pasteString, "//") == -1))
				{
					idx++;
					continue;
				}
			}
			AddCommandList(currentNoteName, deleteFrontStr(pasteString));
			idx++;
		}
		itemListCtrl.SetSelectedIndex((itemListCtrl.GetRecordCount() - 1), true);
	}
	else if((InStr(CommandStr, ((Chr(10) $ Chr(10)) $ Chr(47))) != -1))
	{
		Split(CommandStr, ((Chr(10) $ Chr(10)) $ Chr(47)), commandArray);
		idx = 0;
		while((idx < commandArray.Length))
		{
			pasteString = deleteEnter(commandArray[idx]);
			if(textSpCutCheckBox.IsChecked())
			{
				pasteString = deleteSpStr(pasteString);
			}
			if(textBuildCommandCutCheckBox.IsChecked())
			{
				if((InStr(pasteString, "//") == -1))
				{
					idx++;
					continue;
				}
			}
			AddCommandList(currentNoteName, deleteFrontStr(pasteString));
			idx++;
		}
		itemListCtrl.SetSelectedIndex((itemListCtrl.GetRecordCount() - 1), true);
	}
	else if((InStr(CommandStr, Chr(10)) != -1))
	{
		Split(CommandStr, Chr(10), commandArray);
		idx = 0;
		while((idx < commandArray.Length))
		{
			pasteString = deleteEnter(commandArray[idx]);
			if(textSpCutCheckBox.IsChecked())
			{
				pasteString = deleteSpStr(pasteString);
			}
			if(textBuildCommandCutCheckBox.IsChecked())
			{
				if((InStr(pasteString, "//") == -1))
				{
					idx++;
					continue;
				}
			}
			AddCommandList(currentNoteName, deleteFrontStr(pasteString));
			idx++;
		}
		itemListCtrl.SetSelectedIndex((itemListCtrl.GetRecordCount() - 1), true);
	}
	else if((InStr(CommandStr, (Chr(13) $ Chr(10))) != -1))
	{
		Split(CommandStr, (Chr(13) $ Chr(10)), commandArray);
		idx = 0;
		while((idx < commandArray.Length))
		{
			pasteString = deleteEnter(commandArray[idx]);
			if(textSpCutCheckBox.IsChecked())
			{
				pasteString = deleteSpStr(pasteString);
			}
			if(textBuildCommandCutCheckBox.IsChecked())
			{
				if((InStr(pasteString, "//") == -1))
				{
					idx++;
					continue;
				}
			}
			AddCommandList(currentNoteName, deleteFrontStr(pasteString));
			idx++;
		}
		itemListCtrl.SetSelectedIndex((itemListCtrl.GetRecordCount() - 1), true);
	}
	else if((InStr(CommandStr, (Chr(10) $ Chr(13))) != -1))
	{
		Split(CommandStr, (Chr(10) $ Chr(13)), commandArray);
		idx = 0;
		while((idx < commandArray.Length))
		{
			pasteString = deleteEnter(commandArray[idx]);
			if(textSpCutCheckBox.IsChecked())
			{
				pasteString = deleteSpStr(pasteString);
			}
			if(textBuildCommandCutCheckBox.IsChecked())
			{
				if((InStr(pasteString, "//") == -1))
				{
					idx++;
					continue;
				}
			}
			AddCommandList(currentNoteName, deleteFrontStr(pasteString));
			idx++;
		}
		itemListCtrl.SetSelectedIndex((itemListCtrl.GetRecordCount() - 1), true);
	}
	else
	{
		if(textSpCutCheckBox.IsChecked())
		{
			CommandStr = deleteSpStr(CommandStr);
		}
		if(textBuildCommandCutCheckBox.IsChecked())
		{
			inputEditBox.AddString(deleteFrontStr(CommandStr));
		}
		else
		{
			inputEditBox.AddString(CommandStr);
		}
	}
	return;
}

function string deleteSpStr(string S)
{
	local int idx;
	local string Str;

	idx = InStr(S, "(");
	if((idx > 0))
	{
		Str = Mid(S, 0, idx);
	}
	else
	{
		Str = S;
	}
	return Str;
}

function string deleteFrontStr(string S)
{
	local int idx;
	local string Str;

	idx = InStr(S, "//");
	if((idx > 0))
	{
		Str = Mid(S, idx, Len(S));
	}
	else
	{
		Str = S;
	}
	return Str;
}

function executeLineCommand(string S)
{
	local int idx, i, gotoLine;
	local string Str, param, sKey, sValue;
	local array<string> commandArray, wordArray;
	local string commandKey;

	idx = InStr(S, "#event");
	if((idx > -1))
	{
		commandKey = "#event";
	}
	if((idx == -1))
	{
		idx = InStr(S, "#goto");
		if((idx > -1))
		{
			commandKey = "#goto";
		}
	}
	if((idx > -1))
	{
		if((commandKey == "#goto"))
		{
			Str = Mid(S, (idx + Len("#goto")), Len(S));
			Split(Str, "#", commandArray);
			if((commandArray.Length > 0))
			{
				Debug(("goto다!!" @ commandArray[0]));  // EN: it's a goto!!
				if((int(commandArray[0]) > -1))
				{
					gotoLine = (int(commandArray[0]) - 1);
					if((gotoLine <= 0))
					{
						gotoLine = 0;
					}
					Debug(("-->" @ string(int(runTimeEditBox.GetString()))));
					if((int(runTimeEditBox.GetString()) < 100))
					{
						getInstanceL2Util().showGfxScreenMessage((runTimeEditBox.GetString() @ ", 작동안함, 1/100초 이상 실행시간이 커야 작동합니다"));  // EN: , not working; execution time must exceed 1/100 second
					}
					else
					{
						Me.KillTimer(601222);
						isStepRun = false;
						getInstanceL2Util().showGfxScreenMessage((runTimeEditBox.GetString() @ ", 반복!"));  // EN: , repeat!
						itemListCtrl.SetSelectedIndex(gotoLine, false);
						stepTimeExecuteCommand();
					}
				}
			}
		}
		else if((commandKey == "#event"))
		{
			Str = Mid(S, (idx + Len("#event")), Len(S));
			Split(Str, "#", commandArray);
			if((commandArray.Length > 0))
			{
				if((commandArray.Length == 1))
				{
					ExecuteEvent(int(commandArray[0]), "");
				}
				else
				{
					i = 1;
					while((i < commandArray.Length))
					{
						if((wordArray.Length > 0))
						{
							wordArray.Remove(0, wordArray.Length);
						}
						Split(commandArray[i], "=", wordArray);
						if((wordArray.Length > 0))
						{
							sKey = wordArray[0];
							sValue = "";
							if((wordArray.Length > 1))
							{
								sValue = wordArray[1];
							}
						}
						ParamAdd(param, sKey, sValue);
						i++;
					}
					ExecuteEvent(int(commandArray[0]), param);
				}
			}
		}
	}
	else
	{
		if(runExceptionCheckBox.IsChecked())
		{
			S = deleteSpStr(S);
		}
		ExecuteCommand(S);
		getInstanceL2Util().showGfxScreenMessage(("실행:" @ S));  // EN: run:
	}
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	local LVDataRecord Record;

	if((Class'NWindow.InputAPI'.static.IsCtrlPressed() && (Class'NWindow.InputAPI'.static.GetKeyString(nKey) == "C")))
	{
		if(itemListCtrl.IsFocused())
		{
			itemListCtrl.GetSelectedRec(Record);
			ClipboardCopy(Record.LVDataList[1].szData);
			AddSystemMessageString(("클립 보드 카피:" @ Record.LVDataList[1].szData));  // EN: clipboard copy:
			inputEditBox.SetFocus();
		}
	}
	if((Class'NWindow.InputAPI'.static.GetKeyString(nKey) == "ALT"))
	{
		if(descViewEditBox.IsFocused())
		{
			inputEditBox.SetFocus();
		}
		else if(itemListCtrl.IsFocused())
		{
			descViewEditBox.SetFocus();
		}
		else
		{
			itemListCtrl.SetFocus();
		}
	}
	if((Class'NWindow.InputAPI'.static.GetKeyString(nKey) == "ENTER"))
	{
		if(descViewEditBox.IsFocused())
		{
			OnEditBtnClick();
			itemListCtrl.SetFocus();
		}
	}
	return false;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	nReloadOpen = false;
	return;
}
