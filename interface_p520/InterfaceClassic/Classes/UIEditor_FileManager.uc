class UIEditor_FileManager extends UICommonAPI;

const XML_EXT = ".xml";
const UC_EXT = ".uc";
const PREV_DIR = "..";
const TIMER_ID_UPDATEUI = 1022345;
const DELAY_UPDATEUI = 3000;

var WindowHandle Me;
var ListCtrlHandle lstDirs;
var ListCtrlHandle lstFiles;
var ButtonHandle btnLoad;
var ButtonHandle btnSave;
var ButtonHandle btnMakeUC;
var ButtonHandle exitButton;
var ButtonHandle reLoadButton;
var EditBoxHandle txtPath;
var WindowHandle WorkSheet;
var CheckBoxHandle AutoReloadCheckBox;
var string m_CurPath;
var string lastLoadedFile;
var string m_LastCurPath;
var array<string> dirNameArray;
var array<string> fileNameArray;

function InitHandle()
{
	Me = GetWindowHandle("UIEditor_FileManager");
	lstDirs = GetListCtrlHandle("UIEditor_FileManager.wndFileManager.lstDirs");
	lstFiles = GetListCtrlHandle("UIEditor_FileManager.wndFileManager.lstFiles");
	btnLoad = GetButtonHandle("UIEditor_FileManager.wndFileManager.btnLoad");
	btnSave = GetButtonHandle("UIEditor_FileManager.wndFileManager.btnSave");
	btnMakeUC = GetButtonHandle("UIEditor_FileManager.wndFileManager.btnMakeUC");
	txtPath = GetEditBoxHandle("UIEditor_FileManager.wndFileManager.txtPath");
	WorkSheet = GetWindowHandle("Worksheet.Worksheet");
	reLoadButton = GetButtonHandle("UIEditor_FileManager.reLoadButton");
	AutoReloadCheckBox = GetCheckBoxHandle("UIEditor_FileManager.AutoReloadCheckBox");
	return;
}

function InitControlItem()
{
	setWindowTitleByString("UIEditor - FileManager");
	m_CurPath = GetOptionString("UIEditor", "SysPath");
	if((Len(m_CurPath) > 1))
	{
		if((InStr(m_CurPath, GetInterfaceDir()) <= -1))
		{
			m_CurPath = (GetInterfaceDir() $ "\\Default\\");
		}
	}
	else
	{
		m_CurPath = (GetInterfaceDir() $ "\\Default\\");
	}
	txtPath.SetString(m_CurPath);
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(1710);
	return;
}

event OnLoad()
{
	InitHandle();
	InitControlItem();
	Update();
	return;
}

event OnShow()
{
	Me.KillTimer(1022345);
	AutoReloadCheckBox.SetCheck(false);
	return;
}

event OnHide()
{
	Me.KillTimer(1022345);
	AutoReloadCheckBox.SetCheck(false);
	return;
}

event OnTimer(int TimerID)
{
	if((TimerID == 1022345))
	{
		if(AutoReloadCheckBox.IsChecked())
		{
			reloadTargetXMLUI();
			Me.KillTimer(1022345);
			Me.SetTimer(1022345, 3000);
		}
	}
	return;
}

event OnEvent(int Event_ID, string param)
{
	local string Filename;

	if((Event_ID == 1710))
	{
		if(DialogIsMine())
		{
			if((DialogGetID() == 98))
			{
				Filename = DialogGetString();
				if((Len(Filename) < 1))
				{
					return;
				}
				MakeUC(Filename);
			}
			else if((DialogGetID() == 99))
			{
				Filename = DialogGetString();
				if((Len(Filename) < 1))
				{
					return;
				}
				SaveXMLFile(Filename);
			}
		}
	}
	return;
}

event OnDBClickListCtrlRecord(string strID)
{
	local string DirName;
	local LVDataRecord Record;

	if((strID == "lstDirs"))
	{
		lstDirs.GetSelectedRec(Record);
		DirName = Record.LVDataList[0].szData;
		if((DirName == ".."))
		{
			m_LastCurPath = GetLastFineName();
			m_CurPath = GetParentDirectory(m_CurPath);
		}
		else
		{
			m_LastCurPath = "";
			m_CurPath = (m_CurPath $ DirName);
		}
		Update();
	}
	else if((strID == "lstFiles"))
	{
		OnLoadClick();
	}
	return;
}

event OnClickCheckBox(string strID)
{
	if((strID == "AutoReloadCheckBox"))
	{
		if(AutoReloadCheckBox.IsChecked())
		{
			Me.KillTimer(1022345);
			Me.SetTimer(1022345, 3000);
		}
		else
		{
			Me.KillTimer(1022345);
		}
	}
	return;
}

event OnCompleteEditBox(string strID)
{
	switch(strID)
	{
		case "txtPath":
			m_CurPath = txtPath.GetString();
			Update();
			break;
		default:
			break;
	}
	return;
}

event bool OnKeyDown(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	if((Me.IsShowWindow() == false))
	{
		return false;
	}
	if(((int(nKey) < 65) || (int(nKey) > 90)))
	{
		return false;
	}
	switch(a_WindowHandle)
	{
		case lstDirs:
			FindAndSelectList(lstDirs, nKey, dirNameArray);
			break;
		case lstFiles:
			FindAndSelectList(lstFiles, nKey, fileNameArray);
			break;
		default:
			break;
	}
	return false;
}

function UpdateDirectory()
{
	local array<string> DirList;
	local int idx;
	local LVDataRecord Record;
	local string dirStr;

	Record.LVDataList.Length = 1;
	lstDirs.DeleteAllItem();
	lstFiles.DeleteAllItem();
	dirNameArray.Length = 0;
	fileNameArray.Length = 0;
	GetDirList(DirList, m_CurPath);
	Record.LVDataList[0].szData = "..";
	lstDirs.InsertRecord(Record);
	dirNameArray[dirNameArray.Length] = "..";
	idx = 0;
	while((idx < DirList.Length))
	{
		dirStr = DirList[idx];
		Record.LVDataList[0].szData = dirStr;
		lstDirs.InsertRecord(Record);
		dirNameArray[dirNameArray.Length] = dirStr;
		txtPath.AddNameToAdditionalSearchList((m_CurPath $ DirList[idx]), SLT_ADDITIONAL_LIST);
		if((DirList[idx] == m_LastCurPath))
		{
			lstDirs.SetSelectedIndex((idx + 1), true);
		}
		idx++;
	}
	lstDirs.SetFocus();
	return;
}

function UpdateFileList()
{
	local array<string> FileList;
	local int idx;
	local LVDataRecord Record;
	local string filestr;

	Record.LVDataList.Length = 1;
	lstFiles.DeleteAllItem();
	fileNameArray.Length = 0;
	GetFileList(FileList, m_CurPath, ".xml");
	idx = 0;
	while((idx < FileList.Length))
	{
		filestr = FileList[idx];
		Record.LVDataList[0].szData = filestr;
		lstFiles.InsertRecord(Record);
		fileNameArray[fileNameArray.Length] = filestr;
		txtPath.AddNameToAdditionalSearchList((m_CurPath $ FileList[idx]), SLT_ADDITIONAL_LIST);
		idx++;
	}
	lstFiles.SetFocus();
	return;
}

function Update()
{
	if((Right(m_CurPath, 1) != "\\"))
	{
		m_CurPath = (m_CurPath $ "\\");
	}
	SetOptionString("UIEditor", "SysPath", m_CurPath);
	txtPath.SetString(m_CurPath);
	txtPath.ClearAdditionalSearchList(SLT_ADDITIONAL_LIST);
	Debug(("m_CurPath : " @ m_CurPath));
	UpdateDirectory();
	UpdateFileList();
	return;
}

function string GetLastFineName()
{
	local string Path;
	local array<string> DirList;

	Path = m_CurPath;
	if((Right(Path, 1) == "\\"))
	{
		Path = Left(Path, (Len(Path) - 1));
	}
	Split(Path, "\\", DirList);
	return DirList[(DirList.Length - 1)];
}

function string GetParentDirectory(string Path)
{
	local array<string> DirList;
	local int Count, idx;
	local string NewPath;

	if((Len(Path) < 1))
	{
		return NewPath;
	}
	if((Right(Path, 1) == "\\"))
	{
		Path = Left(Path, (Len(Path) - 1));
	}
	Count = Split(Path, "\\", DirList);
	if((Count == 1))
	{
		return Path;
	}
	idx = 0;
	while((idx < (Count - 1)))
	{
		NewPath = ((NewPath $ DirList[idx]) $ "\\");
		idx++;
	}
	return NewPath;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "btnLoad":
			OnLoadClick();
			break;
		case "btnSave":
			OnSaveClick();
			break;
		case "btnMakeUC":
			OnMakeClick();
			break;
		case "exitButton":
			Update();
			Class'NWindow.UIDATA_API'.static.ChangeToPrevState();
			break;
		case "reLoadButton":
			reloadTargetXMLUI();
			break;
		default:
			break;
	}
	return;
}

function OnLoadClick()
{
	local WindowHandle NewControl;
	local string Filename, FullName;
	local LVDataRecord Record;

	if((WorkSheet == none))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Can't Find Worksheet.");
		return;
	}
	lstFiles.GetSelectedRec(Record);
	Filename = Record.LVDataList[0].szData;
	if((Len(Filename) < 1))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Please Select XML File.");
		return;
	}
	FullName = (m_CurPath $ Filename);
	NewControl = WorkSheet.LoadXMLWindow(FullName);
	if((NewControl == none))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Load XML Window Failed!");
		return;
	}
	lastLoadedFile = FullName;
	NewControl.SetScript("UIEditor_Worksheet");
	NewControl.ConvertToEditable();
	NewControl.SetFocus();
	return;
}

function reloadTargetXMLUI()
{
	local WindowHandle NewControl;
	local array<WindowHandle> WindowList;
	local int i;

	if((WorkSheet == none))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Can't Find Worksheet.");
		return;
	}
	WorkSheet.SetFocus();
	WorkSheet.GetChildWindowList(WindowList);
	i = 0;
	while((i < WindowList.Length))
	{
		WindowList[i].SetFocus();
		DeleteAttachedWindow();
		ClearTracker();
		i++;
	}
	NewControl = WorkSheet.LoadXMLWindow(lastLoadedFile);
	if((NewControl == none))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Load XML Window Failed!");
		return;
	}
	NewControl.SetScript("UIEditor_Worksheet");
	NewControl.ConvertToEditable();
	NewControl.SetFocus();
	return;
}

function OnSaveClick()
{
	local string Filename;
	local LVDataRecord Record;

	lstFiles.GetSelectedRec(Record);
	Filename = Record.LVDataList[0].szData;
	DialogSetEditBoxMaxLength(100);
	DialogSetID(99);
	DialogShow(DialogModalType_Modalless, DialogType_OKCancelInput, "Input File Name.");
	DialogSetString(Filename);
	return;
}

function OnMakeClick()
{
	local WindowHandle TrackerWnd, topWnd;
	local string ScriptName, Filename;

	TrackerWnd = GetTrackerAttachedWindow();
	if((TrackerWnd == none))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Select Target Window to save.");
		return;
	}
	topWnd = TrackerWnd.GetTopFrameWnd();
	if((topWnd == none))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Target Window Have No XML Infomation.");
		return;
	}
	ScriptName = topWnd.GetScriptName();
	if((Len(ScriptName) < 1))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Target Window Have No Script Name.");
		return;
	}
	Filename = (ScriptName $ ".uc");
	DialogSetEditBoxMaxLength(100);
	DialogSetID(98);
	DialogShow(DialogModalType_Modalless, DialogType_OKCancelInput, "Input Script File Name.");
	DialogSetString(Filename);
	return;
}

function SaveXMLFile(string Filename)
{
	local WindowHandle TrackerWnd, topWnd;
	local string FullName;

	if((Len(Filename) < 1))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Please Input Save File Name!");
		return;
	}
	TrackerWnd = GetTrackerAttachedWindow();
	if((TrackerWnd == none))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Select Target Window to save.");
		return;
	}
	topWnd = TrackerWnd.GetTopFrameWnd();
	if((topWnd == none))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Target Window Have No XML Infomation.");
		return;
	}
	FullName = (m_CurPath $ Filename);
	if(topWnd.SaveXMLWindow(FullName))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, (("Save Complete. (" $ FullName) $ ")"));
	}
	else
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Save Failed. OTL");
	}
	Update();
	return;
}

function MakeUC(string Filename)
{
	local WindowHandle TrackerWnd, topWnd;
	local array<string> NameList;
	local int idx, Count;
	local string UCName, FullName;

	if((Len(Filename) < 1))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Please Input Save File Name!");
		return;
	}
	Count = Split(Filename, ".", NameList);
	if((("." $ NameList[(Count - 1)]) != ".uc"))
	{
		Filename = (Filename $ ".uc");
	}
	Count = Split(Filename, ".", NameList);
	idx = 0;
	while((idx < (Count - 1)))
	{
		if((idx > 0))
		{
			UCName = (UCName $ ".");
		}
		UCName = (UCName $ NameList[idx]);
		idx++;
	}
	TrackerWnd = GetTrackerAttachedWindow();
	if((TrackerWnd == none))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Select Target Window to save.");
		return;
	}
	topWnd = TrackerWnd.GetTopFrameWnd();
	if((topWnd == none))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Target Window Have No XML Infomation.");
		return;
	}
	FullName = (m_CurPath $ Filename);
	if(topWnd.MakeBaseUC(UCName, FullName))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, (("Save Complete. (" $ FullName) $ ")"));
	}
	else
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "Save Failed. OTL");
	}
	return;
}

function FindAndSelectList(ListCtrlHandle targetListCtrl, Interactions.EInputKey nKey, array<string> listStrArray)
{
	local string keyStr;
	local int i, SelectedIndex;
	local bool isSelected;

	keyStr = Class'NWindow.InputAPI'.static.GetKeyString(nKey);
	SelectedIndex = targetListCtrl.GetSelectedIndex();
	if((SelectedIndex >= 0))
	{
		if((keyStr == ToUpper(Left(listStrArray[SelectedIndex], 1))))
		{
			if((listStrArray.Length > (SelectedIndex + 1)))
			{
				if((keyStr == ToUpper(Left(listStrArray[(SelectedIndex + 1)], 1))))
				{
					targetListCtrl.SetSelectedIndex((SelectedIndex + 1), true);
					isSelected = true;
				}
			}
		}
	}
	if((isSelected == false))
	{
		i = 0;
		while((i < listStrArray.Length))
		{
			if((keyStr == ToUpper(Left(listStrArray[i], 1))))
			{
				targetListCtrl.SetSelectedIndex(i, true);
				break;
			}
			i++;
		}
	}
	return;
}
