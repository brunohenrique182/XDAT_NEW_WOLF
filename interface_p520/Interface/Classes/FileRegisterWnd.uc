class FileRegisterWnd extends UICommonAPI;

var bool m_bShow;
var WindowHandle Me;
var ListCtrlHandle FileListCtrl;
var EditBoxHandle EditBoxCtrl;
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
	if(m_bShow)
	{
		return;
	}
	FileHandler = filehandlertype;
	switch(FileHandler)
	{
		case FH_PLEDGE_CREST_UPLOAD:
			setWindowTitleByString(GetSystemString(2229));
			break;
		case FH_PLEDGE_EMBLEM_UPLOAD:
			setWindowTitleByString(GetSystemString(2229));
			break;
		case FH_ALLIANCE_CREST_UPLOAD:
		case FH_WEBBROWSER_FILE_UPLOAD:
		default:
			setWindowTitleByString(GetSystemString(2229));
			break;
	}
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function FileRegisterWndShowByTypeStr(string numStr)
{
	local array<string> fileextarr;

	Debug(("FileRegisterWndShowByTypeStr : " @ numStr));
	switch(numStr)
	{
		case "FH_PLEDGE_CREST_UPLOAD":
			fileextarr.Length = 1;
			fileextarr[0] = "bmp";
			ClearFileRegisterWndFileExt();
			ClearFileExt();
			AddFileRegisterWndFileExt(GetSystemString(2811), fileextarr);
			ShowFileRegisterWnd(FH_PLEDGE_CREST_UPLOAD);
			break;
		case "FH_PLEDGE_EMBLEM_UPLOAD":
			fileextarr.Length = 2;
			fileextarr[0] = "tga";
			fileextarr[1] = "bmp";
			ClearFileRegisterWndFileExt();
			AddFileRegisterWndFileExt(GetSystemString(2233), fileextarr);
			ShowFileRegisterWnd(FH_PLEDGE_EMBLEM_UPLOAD);
			break;
		case "FH_ALLIANCE_CREST_UPLOAD":
			fileextarr.Length = 1;
			fileextarr[0] = "bmp";
			ClearFileRegisterWndFileExt();
			ClearFileExt();
			AddFileRegisterWndFileExt(GetSystemString(2811), fileextarr);
			ShowFileRegisterWnd(FH_ALLIANCE_CREST_UPLOAD);
			break;
		case "FH_WEBBROWSER_FILE_UPLOAD":
			ShowFileRegisterWnd(FH_WEBBROWSER_FILE_UPLOAD);
			break;
		default:
			Debug(("Error: FileRegisterWndShowByNum 함수에 잘못된 번호를 넣음:" @ numStr));  // EN: Error: a bad number was passed to FileRegisterWndShowByNum:
	}
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
			Me.HideWindow();
			return RequestClanRegisterCrestByFilePath(Path);
		case FH_PLEDGE_EMBLEM_UPLOAD:
			Me.HideWindow();
			return RequestClanRegisterEmblemByFilePath(Path);
		case FH_ALLIANCE_CREST_UPLOAD:
			Me.HideWindow();
			return RequestAllianceRegisterCrestByFilePath(Path);
		case FH_WEBBROWSER_FILE_UPLOAD:
			Me.HideWindow();
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
		Me = GetWindowHandle("FileRegisterWnd");
		FileListCtrl = GetListCtrlHandle("FileRegisterWnd.fileListCtrl");
		FileListCtrl.SetHeaderAlignment(0, TA_Left);
		FileListCtrl.SetResizable(false);
		EditBoxCtrl = GetEditBoxHandle("FileRegisterWnd.fileNameEditBox");
		FilePathComboBoxCtrl = GetComboBoxHandle("FileRegisterWnd.FileLocationComboBox");
		FileExtComboBoxCtrl = GetComboBoxHandle("FileRegisterWnd.FileTypeComboBox");
		FileListCtrl.SetHeaderTextOffset(0, 135);
		strArray.Length = 1;
		strArray[0] = "*";
		FileExtComboBoxCtrl.AddStringWithFileExt(GetSystemString(5861), strArray);
		SetFilePathnAdjustControl(GetMydocumentPath());
	}
	m_bShow = false;
	return;
}

function SetFilePathnAdjustControl(string S)
{
	local array<FileNameInfo> fInfoArray;
	local array<string> fExtArray;

	EditBoxCtrl.Clear();
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
		if(UploadFile(m_filePath, m_fileName))
		{
			Me.HideWindow();
		}
	}
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
	EditBoxCtrl.SetString(Record.LVDataList[0].szData);
	return;
}

function EnumerateFile(array<FileNameInfo> FList)
{
	local int k;
	local LVDataRecord Record;

	FileListCtrl.DeleteAllItem();
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
		k++;
	}
	FileListCtrl.AdjustColumnWidth(0);
	FileListCtrl.SetSelectedIndex(0, true);
	return;
}

function OnShow()
{
	local array<string> fExtArray;

	EditBoxCtrl.Clear();
	FileListCtrl.InitListCtrl();
	FileExtComboBoxCtrl.SetSelectedNum(0);
	fExtArray = FileExtComboBoxCtrl.GetFileExtInfo(FileExtComboBoxCtrl.GetSelectedNum());
	if((GetOptionString("Game", ("FileRegisterPath" $ string(FileHandler))) == ""))
	{
		m_filePath = GetMydocumentPath();
	}
	else
	{
		m_filePath = GetOptionString("Game", ("FileRegisterPath" $ string(FileHandler)));
	}
	if((m_filePath != ""))
	{
		SetFilePathnAdjustControl(m_filePath);
	}
	else
	{
		m_filePath = "C:";
		SetFilePathnAdjustControl(m_filePath);
	}
	m_bShow = true;
	return;
}

function OnHide()
{
	m_bShow = false;
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
		case "registOKButton":
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
				if(UploadFile(m_filePath, m_fileName))
				{
					Me.HideWindow();
				}
			}
			else
			{
				filePath = ((m_filePath $ "\\") $ Record.LVDataList[0].szData);
				SetFilePathnAdjustControl(filePath);
			}
			break;
		case "registCancleButton":
			Me.HideWindow();
			break;
		case "refreshButton":
			SetFilePathnAdjustControl(m_filePath);
			break;
		default:
			break;
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("FileRegisterWnd").HideWindow();
	return;
}
