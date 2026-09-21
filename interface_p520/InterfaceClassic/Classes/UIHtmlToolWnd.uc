class UIHtmlToolWnd extends UICommonAPI;

var WindowHandle Me;
var ListCtrlHandle FileListCtrl;
var EditBoxHandle EditBoxCtrl;
var EditBoxHandle dirEditBox;
var ComboBoxHandle FilePathComboBoxCtrl;
var ComboBoxHandle FileExtComboBoxCtrl;
var string m_filePath;
var string FileTextureName;
var string FolderTextureName;
var string UpFolderTextureName;
var string CurrentForerTextureName;
var string DesktopTextureName;
var string MyDocumentsTextureName;
var string DriveTextureName;
var UICommonAPI._FileHandler FileHandler;
var bool IsIdle;
var string m_fileName;

function ShowFileRegisterWnd(UICommonAPI._FileHandler filehandlertype)
{
	FileHandler = filehandlertype;
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function HideFileRegisterWnd()
{
	Me.HideWindow();
	return;
}

function AddFileExt(string Str, array<string> strArray)
{
	FileExtComboBoxCtrl.AddStringWithFileExt(Str, strArray);
	return;
}

function ClearFileExt()
{
	FileExtComboBoxCtrl.Clear();
	return;
}

function bool RequestWebBrowserRegisterByFilePath(string Path)
{
	local WebBrowserWnd Script;

	Script = WebBrowserWnd(GetScript("WebBrowserWnd"));
	Debug("RequestWebBrowserRegisterByFilePath");
	Script.UploadFileFullPath(Path);
	return true;
}

function bool UploadFile(string filePath, string Filename)
{
	local string filestr;

	filestr = ((filePath $ "\\") $ Filename);
	if((int(FileHandler) >= 5))
	{
		return true;
	}
	SetOptionString("Game", ("FileRegisterPath" $ string(FileHandler)), filePath);
	UploadFileFullPath(filestr);
}

function bool UploadFileFullPath(string Path)
{
	if((int(FileHandler) >= 5))
	{
		return true;
	}
	switch(FileHandler)
	{
		case FH_NONE:
			return true;
		case FH_PLEDGE_CREST_UPLOAD:
			return RequestClanRegisterCrestByFilePath(Path);
		case FH_PLEDGE_EMBLEM_UPLOAD:
			return RequestClanRegisterEmblemByFilePath(Path);
		case FH_ALLIANCE_CREST_UPLOAD:
			return RequestAllianceRegisterCrestByFilePath(Path);
		case FH_WEBBROWSER_FILE_UPLOAD:
			return RequestWebBrowserRegisterByFilePath(Path);
		default:
			return true;
	}
}

function OnLoad()
{
	local array<string> strArray;

	SetClosingOnESC();
	IsIdle = true;
	FileHandler = FH_NONE;
	FileTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_BMP";
	FolderTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_Folder";
	UpFolderTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_FolderUp";
	CurrentForerTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_FolderOpen";
	DesktopTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_Desktop";
	MyDocumentsTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_MyDocument";
	DriveTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_Drive";
	if((1 == 0))
	{
	}
	else
	{
		Me = GetWindowHandle("UIHtmlToolWnd");
		FileListCtrl = GetListCtrlHandle("UIHtmlToolWnd.fileListCtrl");
		FileListCtrl.SetHeaderAlignment(0, TA_Left);
		FileListCtrl.SetResizable(false);
		EditBoxCtrl = GetEditBoxHandle("UIHtmlToolWnd.fileNameEditBox");
		dirEditBox = GetEditBoxHandle("UIHtmlToolWnd.dirEditBox");
		FilePathComboBoxCtrl = GetComboBoxHandle("UIHtmlToolWnd.FileLocationComboBox");
		FileExtComboBoxCtrl = GetComboBoxHandle("UIHtmlToolWnd.FileTypeComboBox");
		FileListCtrl.SetHeaderTextOffset(0, 135);
		strArray.Length = 2;
		strArray[0] = "htm";
		strArray[1] = "html";
		FileExtComboBoxCtrl.AddStringWithFileExt("All File", strArray);
		SetFilePathnAdjustControl(GetMydocumentPath());
	}
	setWindowTitleByString("UIPowerTools - [ HtmlTool ]");
	return;
}

function SetFilePathnAdjustControl(string S)
{
	local array<FileNameInfo> fInfoArray;
	local array<string> fExtArray;

	EditBoxCtrl.Clear();
	dirEditBox.Clear();
	UpdateFilePathComboBox(S);
	fExtArray = FileExtComboBoxCtrl.GetFileExtInfo(FileExtComboBoxCtrl.GetSelectedNum());
	fInfoArray = GetFilesInfoList(m_filePath, fExtArray);
	EnumerateFile(fInfoArray);
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

function OnCompleteEditBox(string strID)
{
	local LVDataRecord Record;
	local int idx;
	local string strEdit, filePath;

	if((strID != "fileNameEditBox"))
	{
		return;
	}
	strEdit = EditBoxCtrl.GetString();
	idx = SearchFileListWithName(strEdit);
	if((idx < 0))
	{
		UploadFileFullPath(strEdit);
		EditBoxCtrl.Clear();
		return;
	}
	FileListCtrl.GetRec(idx, Record);
	m_fileName = Record.LVDataList[0].szData;
	if((Record.nReserved1 == INT64(1)))
	{
		if(UploadFile(m_filePath, m_fileName))
		{
			Me.HideWindow();
		}
	}
	else
	{
		SetFilePathnAdjustControl(filePath);
	}
	return;
}

function OnDBClickListCtrlRecord(string strID)
{
	local int Index, idx;
	local LVDataRecord Record;
	local string Str, editStr;

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
	if((Record.nReserved2 == INT64(1)))
	{
		Index = InStrFromBack(m_filePath, "\\");
		if((Index >= 0))
		{
			editStr = Left(m_filePath, Index);
			SetFilePathnAdjustControl(editStr);
		}
		return;
	}
	Str = Record.LVDataList[0].szData;
	if((Record.nReserved1 == INT64(0)))
	{
		Str = ((m_filePath $ "\\") $ Str);
		SetFilePathnAdjustControl(Str);
	}
	else
	{
		m_fileName = Record.LVDataList[0].szData;
		if(GetWindowHandle("QuestTutorialWnd").IsShowWindow())
		{
			OnClickButton("htmlBigViewButton");
		}
		else
		{
			OnClickButton("htmlSmallViewButton");
		}
		if(GetWindowHandle("ItemDescWnd").IsShowWindow())
		{
			OnClickButton("htmlSmallViewButton");
		}
	}
	FileListCtrl.SetFocus();
	return;
}

function UpdateFilePathComboBox(string Str)
{
	local int i, j, k, drivenum;
	local array<DriveInfo> arrDrvInfo;
	local int Width, selectedNum;
	local string desktop;

	selectedNum = 0;
	if((Len(Str) <= 0))
	{
		return;
	}
	FilePathComboBoxCtrl.Clear();
	m_filePath = Str;
	k = -1;
	desktop = GetDesktopPath();
	if((Len(desktop) != 0))
	{
		FilePathComboBoxCtrl.AddStringWithIconWithStr(Mid(desktop, (InStrFromBack(desktop, "\\") + 1)), DesktopTextureName, desktop);
		selectedNum++;
	}
	desktop = GetMydocumentPath();
	if((Len(desktop) != 0))
	{
		FilePathComboBoxCtrl.AddStringWithIconWithStr(Mid(desktop, (InStrFromBack(desktop, "\\") + 1)), MyDocumentsTextureName, desktop);
		selectedNum++;
	}
	arrDrvInfo = GetDrivesInfoList();
	drivenum = 0;
	while((drivenum < arrDrvInfo.Length))
	{
		if((Left(arrDrvInfo[drivenum].driveChar, 1) != Left(m_filePath, 1)))
		{
			FilePathComboBoxCtrl.AddStringWithIconWithGapWithStr((Left(arrDrvInfo[drivenum].driveChar, 1) $ ":"), DriveTextureName, 1, (Left(arrDrvInfo[drivenum].driveChar, 1) $ ":"));
			selectedNum++;
			++drivenum;
			continue;
		}
		i = 0;
		j = 0;
		k = 0;
		while(true)
		{
			j = i;
			if((j == 0))
			{
				i = InStr(Mid(Str, j), "\\");
				Width = j;
			}
			else
			{
				i = InStr(Mid(Str, (j + 1)), "\\");
				Width = (j + 1);
			}
			if((i == -1))
			{
				if((j == 0))
				{
					FilePathComboBoxCtrl.AddStringWithIconWithGapWithStr(Mid(Str, j), DriveTextureName, (k + 1), Str);
				}
				else
				{
					FilePathComboBoxCtrl.AddStringWithIconWithGapWithStr(Mid(Str, (j + 1)), CurrentForerTextureName, (k + 1), Str);
				}
				break;
			}
			else
			{
				(i += Width);
				if((j == 0))
				{
					FilePathComboBoxCtrl.AddStringWithIconWithGapWithStr(Mid(Str, j, (i - j)), DriveTextureName, (k + 1), Left(Str, i));
					continue;
				}
				FilePathComboBoxCtrl.AddStringWithIconWithGapWithStr(Mid(Str, (j + 1), ((i - j) - 1)), FolderTextureName, (k + 1), Left(Str, i));
				k++;
			}
		}
		FilePathComboBoxCtrl.SetSelectedNum((k + selectedNum));
		++drivenum;
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
	dirEditBox.SetString(m_filePath);
	EditBoxCtrl.SetString(Record.LVDataList[0].szData);
	return;
}

function EnumerateFile(array<FileNameInfo> FList)
{
	local int k;
	local LVDataRecord Record;

	FileListCtrl.DeleteAllItem();
	EditBoxCtrl.ClearAdditionalSearchList(SLT_ADDITIONAL_LIST);
	Record.LVDataList.Length = 1;
	Record.LVDataList[0].szData = "..";
	Record.LVDataList[0].hasIcon = true;
	Record.LVDataList[0].nTextureWidth = 19;
	Record.LVDataList[0].nTextureHeight = 15;
	Record.LVDataList[0].nTextureU = 19;
	Record.LVDataList[0].nTextureV = 15;
	Record.LVDataList[0].IconPosX = 3;
	Record.LVDataList[0].nsortPrior = 2;
	Record.LVDataList[0].szTexture = UpFolderTextureName;
	Record.nReserved2 = INT64(1);
	k = InStrFromBack(m_filePath, "\\");
	if((k != -1))
	{
		FileListCtrl.InsertRecord(Record);
	}
	k = 0;
	while((k < FList.Length))
	{
		Record.LVDataList[0].szData = FList[k].Filename;
		Record.LVDataList[0].hasIcon = true;
		Record.nReserved2 = INT64(0);
		if(FList[k].bIsFile)
		{
			Record.LVDataList[0].nsortPrior = 0;
			Record.LVDataList[0].szTexture = FileTextureName;
		}
		else
		{
			Record.LVDataList[0].nsortPrior = 1;
			Record.LVDataList[0].szData = Right(Record.LVDataList[0].szData, (Len(Record.LVDataList[0].szData) - 1));
			Record.LVDataList[0].szTexture = FolderTextureName;
		}
		Record.nReserved1 = INT64(FList[k].bIsFile);
		FileListCtrl.InsertRecord(Record);
		if((FList.Length < 1000))
		{
			EditBoxCtrl.AddNameToAdditionalSearchList(FList[k].Filename, SLT_ADDITIONAL_LIST);
		}
		k++;
	}
	dirEditBox.SetString(m_filePath);
	FileListCtrl.AdjustColumnWidth(0);
	FileListCtrl.SetSelectedIndex(0, true);
	return;
}

function OnShow()
{
	local array<string> fExtArray;

	ShowFileRegisterWnd(FH_NONE);
	EditBoxCtrl.Clear();
	dirEditBox.Clear();
	FileListCtrl.InitListCtrl();
	FileExtComboBoxCtrl.SetSelectedNum(0);
	fExtArray = FileExtComboBoxCtrl.GetFileExtInfo(FileExtComboBoxCtrl.GetSelectedNum());
	UpdateFilePathComboBox(m_filePath);
	SetFilePathnAdjustControl(m_filePath);
	dirEditBox.SetString(m_filePath);
	return;
}

function OnHide()
{
	return;
}

function OnComboBoxItemSelected(string strID, int Index)
{
	local string Str;
	local array<FileNameInfo> fInfoArray;
	local array<string> fExtArray;

	if((Index < 0))
	{
		return;
	}
	if((strID == "fileLocationComboBox"))
	{
		Str = FilePathComboBoxCtrl.GetAdditionalString(FilePathComboBoxCtrl.GetSelectedNum());
		SetFilePathnAdjustControl(Str);
	}
	else if((strID == "fileTypeComboBox"))
	{
		fExtArray = FileExtComboBoxCtrl.GetFileExtInfo(FileExtComboBoxCtrl.GetSelectedNum());
		fInfoArray = GetFilesInfoList(m_filePath, fExtArray);
		EnumerateFile(fInfoArray);
	}
	return;
}

function OnClickButton(string strID)
{
	local string editStr, filePath;
	local int Index;
	local LVDataRecord Record;

	switch(strID)
	{
		case "htmlBigViewButton":
		case "htmlSmallViewButton":
			editStr = EditBoxCtrl.GetString();
			Index = SearchFileListWithName(editStr);
			if((Index < 0))
			{
				AddSystemMessage(528);
				EditBoxCtrl.Clear();
				break;
			}
			FileListCtrl.GetRec(Index, Record);
			if((Record.nReserved1 == INT64(1)))
			{
				m_fileName = Record.LVDataList[0].szData;
				filePath = ((m_filePath $ "\\") $ m_fileName);
			}
			else
			{
				filePath = ((m_filePath $ "\\") $ Record.LVDataList[0].szData);
				SetFilePathnAdjustControl(filePath);
			}
			if((strID == "htmlSmallViewButton"))
			{
				htmlButtonClick(true, filePath);
			}
			else
			{
				htmlButtonClick(false, filePath);
			}
			break;
		case "refreshButton":
			SetFilePathnAdjustControl(m_filePath);
			break;
		default:
			break;
	}
	return;
}

function htmlButtonClick(bool bSmallOpenType, string filePath)
{
	local ItemDescWnd Script;

	Script = ItemDescWnd(GetScript("ItemDescWnd"));
	if(bSmallOpenType)
	{
		Script.ShowHelp(filePath);
	}
	else
	{
		ExecuteEvent(2431, (("HtmlFile=" $ filePath) @ "ViewerType=2"));
	}
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	if(EditBoxCtrl.IsFocused())
	{
		if((int(nKey) == 13))
		{
			htmlButtonClick(true, ((m_filePath $ "\\") $ EditBoxCtrl.GetString()));
		}
	}
	else if(dirEditBox.IsFocused())
	{
		if((int(nKey) == 13))
		{
			m_filePath = dirEditBox.GetString();
			UpdateFilePathComboBox(m_filePath);
			SetFilePathnAdjustControl(m_filePath);
		}
	}
	return false;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("UIHtmlToolWnd").HideWindow();
	return;
}
