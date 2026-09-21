class UIOpenToolWnd extends UICommonAPI;

const XML_EXT = ".xml";
const UC_EXT = ".uc";
const PREV_DIR = "..";

var WindowHandle Me;
var ButtonHandle searchBtn;
var ButtonHandle InitBtn;
var ButtonHandle showBtn;
var EditBoxHandle searchEditBox;
var EditBoxHandle itemCountEditBox;
var EditBoxHandle descViewEditBox;
var ListCtrlHandle itemListCtrl;
var array<string> FileList;
var string m_CurPath;

function OnRegisterEvent()
{
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
	Me = GetWindowHandle("UIOpenToolWnd");
	itemListCtrl = GetListCtrlHandle("UIOpenToolWnd.itemListCtrl");
	searchEditBox = GetEditBoxHandle("UIOpenToolWnd.searchEditBox");
	itemCountEditBox = GetEditBoxHandle("UIOpenToolWnd.itemCountEditBox");
	descViewEditBox = GetEditBoxHandle("UIOpenToolWnd.descViewEditBox");
	searchBtn = GetButtonHandle("UIOpenToolWnd.searchBtn");
	InitBtn = GetButtonHandle("UIOpenToolWnd.InitBtn");
	showBtn = GetButtonHandle("UIOpenToolWnd.showBtn");
	return;
}

function Load()
{
	return;
}

function OnShow()
{
	setWindowTitleByString("UIOpenTool [UC Files List]");
	updateUCFiles();
	return;
}

function OnClickButton(string Name)
{
	local string Str;

	switch(Name)
	{
		case "searchBtn":
			OnSearchBtnClick();
			break;
		case "InitBtn":
			OnInitBtnClick();
			break;
		case "showBtn":
			OnShowBtnClick();
			break;
		case "copyBtn":
			Str = descViewEditBox.GetString();
			if((Str != ""))
			{
				getInstanceL2Util().showGfxScreenMessage("Copy!! ClipBoard  -o-)/");
				ClipboardCopy(descViewEditBox.GetString());
			}
			break;
		default:
			break;
	}
	return;
}

function OnSearchBtnClick()
{
	local int idx;
	local LVDataRecord recordInfo;

	if((searchEditBox.GetString() == ""))
	{
		updateUCFiles();
		return;
	}
	itemListCtrl.DeleteAllItem();
	searchEditBox.ClearAdditionalSearchList(SLT_ADDITIONAL_LIST);
	idx = 0;
	while((idx < FileList.Length))
	{
		if((InStr(Caps(FileList[idx]), Caps(searchEditBox.GetString())) != -1))
		{
			recordInfo.LVDataList.Length = 3;
			recordInfo.LVDataList[0].szData = FileList[idx];
			itemListCtrl.InsertRecord(recordInfo);
			searchEditBox.AddNameToAdditionalSearchList(FileList[idx], SLT_ADDITIONAL_LIST);
		}
		idx++;
	}
	itemCountEditBox.SetString(string(itemListCtrl.GetRecordCount()));
	return;
}

function OnInitBtnClick()
{
	searchEditBox.SetString("");
	return;
}

function string GetSelectedStr()
{
	local LVDataRecord Record;
	local string Str;

	itemListCtrl.GetSelectedRec(Record);
	Str = ("///sw name=" $ Record.LVDataList[0].szData);
	return Str;
}

function OnClickListCtrlRecord(string Str)
{
	Debug(("str" @ Str));
	descViewEditBox.SetString(GetSelectedStr());
	return;
}

function OnShowBtnClick()
{
	local LVDataRecord Record;
	local string Str;

	itemListCtrl.GetSelectedRec(Record);
	Str = Record.LVDataList[0].szData;
	if((Str != ""))
	{
		if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(Str))
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow(Str);
		}
		else
		{
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(Str);
			Class'NWindow.UIAPI_WINDOW'.static.SetFocus(Str);
		}
	}
	return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	if((ListCtrlID == "itemListCtrl"))
	{
		OnShowBtnClick();
	}
	return;
}

function updateUCFiles()
{
	local int idx, FileListNum;
	local LVDataRecord recordInfo;
	local LVData data1;
	local array<string> FileListLocal;

	itemListCtrl.DeleteAllItem();
	searchEditBox.ClearAdditionalSearchList(SLT_ADDITIONAL_LIST);
	FileList.Remove(0, FileList.Length);
	m_CurPath = (GetInterfaceDir() $ "\\CLASSES\\COMMON\\");
	GetFileList(FileListLocal, m_CurPath, ".uc");
	idx = 0;
	while((idx < FileListLocal.Length))
	{
		FileList[FileList.Length] = Left(FileListLocal[idx], (Len(FileListLocal[idx]) - 3));
		data1.szData = FileList[idx];
		recordInfo.LVDataList.Length = 3;
		recordInfo.LVDataList[0] = data1;
		itemListCtrl.InsertRecord(recordInfo);
		searchEditBox.AddNameToAdditionalSearchList(FileListLocal[idx], SLT_ADDITIONAL_LIST);
		idx++;
	}
	FileListNum = (FileListNum + FileList.Length);
	m_CurPath = (GetInterfaceDir() $ "\\CLASSES\\CLASSIC\\");
	GetFileList(FileListLocal, m_CurPath, ".uc");
	idx = 0;
	while((idx < FileListLocal.Length))
	{
		FileList[FileList.Length] = Left(FileListLocal[idx], (Len(FileListLocal[idx]) - 3));
		data1.szData = FileList[idx];
		recordInfo.LVDataList.Length = 3;
		recordInfo.LVDataList[0] = data1;
		itemListCtrl.InsertRecord(recordInfo);
		searchEditBox.AddNameToAdditionalSearchList(FileListLocal[idx], SLT_ADDITIONAL_LIST);
		idx++;
	}
	FileListNum = (FileListNum + FileList.Length);
	m_CurPath = (GetInterfaceDir() $ "\\CLASSES\\LIVE\\");
	GetFileList(FileListLocal, m_CurPath, ".uc");
	idx = 0;
	while((idx < FileListLocal.Length))
	{
		FileList[FileList.Length] = Left(FileListLocal[idx], (Len(FileListLocal[idx]) - 3));
		data1.szData = FileList[idx];
		recordInfo.LVDataList.Length = 3;
		recordInfo.LVDataList[0] = data1;
		itemListCtrl.InsertRecord(recordInfo);
		searchEditBox.AddNameToAdditionalSearchList(FileListLocal[idx], SLT_ADDITIONAL_LIST);
		idx++;
	}
	FileListNum = (FileListNum + FileList.Length);
	descViewEditBox.SetString(("Total UC Files: " $ string(FileListNum)));
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	if(searchEditBox.IsFocused())
	{
		if((int(nKey) == 13))
		{
			if((trim(searchEditBox.GetString()) != ""))
			{
				OnSearchBtnClick();
			}
		}
	}
	return false;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("UIOpenToolWnd").HideWindow();
	return;
}
