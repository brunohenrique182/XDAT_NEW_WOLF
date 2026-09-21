class UIServerHtmlToolWnd extends UICommonAPI;

const TIME_ID = 2001111;
const TIME_DELAY = 100;

var WindowHandle Me;
var ListCtrlHandle FileListCtrl;
var EditBoxHandle EditBoxCtrl;
var string m_fileName;

function OnLoad()
{
	SetClosingOnESC();
	Me = GetWindowHandle("UIServerHtmlToolWnd");
	FileListCtrl = GetListCtrlHandle("UIServerHtmlToolWnd.fileListCtrl");
	FileListCtrl.SetHeaderAlignment(0, TA_Left);
	FileListCtrl.SetResizable(false);
	EditBoxCtrl = GetEditBoxHandle("UIServerHtmlToolWnd.fileNameEditBox");
	setWindowTitleByString("UIPowerTools - [ ServerHtmlTool ]");
	return;
}

function int SearchFileListWithName(string S)
{
	local int i, Num;
	local LVDataRecord Record;

	Num = FileListCtrl.GetRecordCount();
	i = 0;
	while((i < Num))
	{
		FileListCtrl.GetRec(i, Record);
		if((Record.LVDataList[0].szData == S))
		{
			return i;
		}
		++i;
	}
	return -1;
}

function OnDBClickListCtrlRecord(string strID)
{
	local int idx;
	local LVDataRecord Record;

	if((strID != "fileListCtrl"))
	{
		return;
	}
	idx = FileListCtrl.GetSelectedIndex();
	if((idx < 0))
	{
		return;
	}
	FileListCtrl.GetRec(idx, Record);
	if((Record.LVDataList[0].szData != ""))
	{
		loadServerHtml(Record.LVDataList[0].szData);
	}
	FileListCtrl.SetFocus();
	Me.KillTimer(2001111);
	Me.SetTimer(2001111, 100);
	return;
}

function OnTimer(int TimeID)
{
	if((TimeID == 2001111))
	{
		FileListCtrl.SetFocus();
		Me.KillTimer(2001111);
	}
	return;
}

function OnClickListCtrlRecord(string strID)
{
	local int idx;
	local LVDataRecord Record;

	if((strID != "fileListCtrl"))
	{
		return;
	}
	idx = FileListCtrl.GetSelectedIndex();
	if((idx < 0))
	{
		return;
	}
	FileListCtrl.GetRec(idx, Record);
	EditBoxCtrl.SetString(Record.LVDataList[0].szData);
	return;
}

function addHtmlFileAtList(string Filename)
{
	local LVDataRecord Record;

	Record.LVDataList.Length = 1;
	Record.LVDataList[0].szData = Filename;
	FileListCtrl.InsertRecord(Record);
	return;
}

function OnShow()
{
	EditBoxCtrl.Clear();
	FileListCtrl.InitListCtrl();
	FileListCtrl.DeleteAllItem();
	return;
}

function getHtmlListInINI()
{
	local string tempstring;
	local int i, fileCount;

	EditBoxCtrl.Clear();
	FileListCtrl.DeleteAllItem();
	GetINIString("HtmlList", "totalFileCount", tempstring, "serverHtmlList.ini");
	fileCount = int(tempstring);
	i = 0;
	while((i < fileCount))
	{
		GetINIString("HtmlList", ("html" $ string(i)), tempstring, "serverHtmlList.ini");
		addHtmlFileAtList(tempstring);
		i++;
	}
	return;
}

function OnHide()
{
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "htmlSmallViewButton":
			OnDBClickListCtrlRecord("fileListCtrl");
			break;
		case "refreshButton":
			getHtmlListInINI();
			break;
		default:
			break;
	}
	return;
}

function loadServerHtml(string htmlFileName)
{
	ExecuteCommand(("//loadhtml " $ htmlFileName));
	EditBoxCtrl.AddNameToAdditionalSearchList(htmlFileName, SLT_ADDITIONAL_LIST);
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	if(EditBoxCtrl.IsFocused())
	{
		if((int(nKey) == 13))
		{
			Debug("EditBoxCtrl");
			loadServerHtml(EditBoxCtrl.GetString());
		}
	}
	else if(FileListCtrl.IsFocused())
	{
		if((int(nKey) == 13))
		{
			Debug("파일리스트");  // EN: file list
			OnDBClickListCtrlRecord("fileListCtrl");
		}
	}
	return false;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("UIServerHtmlToolWnd").HideWindow();
	return;
}
