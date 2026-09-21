class FileWnd extends UICommonAPI;

var bool m_bShow;
var WindowHandle Me;
var ListCtrlHandle FileListCtrl;
var EditBoxHandle EditBoxCtrl;
var ComboBoxHandle FilePathComboBoxCtrl;
var ComboBoxHandle FileExtComboBoxCtrl;
var string m_filePath;
var string FileTextureName;
var string FolderTextureName;
var UICommonAPI._FileHandler FileHandler;
var bool IsIdle;
var array<string> LastPath;
var string m_fileName;

function ShowFileWnd(UICommonAPI._FileHandler filehandlertype)
{
	if(m_bShow)
	{
		return;
	}
	FileHandler = filehandlertype;
	switch(FileHandler)
	{
		case FH_PLEDGE_CREST_UPLOAD:
			setWindowTitleByString("CREST UPLOAD");
			break;
		case FH_PLEDGE_EMBLEM_UPLOAD:
			setWindowTitleByString("EMBLEM UPLOAD");
			break;
		default:
			setWindowTitleByString("File Registeration");
			break;
	}
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function HideFileWnd()
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

function bool UploadFile(string filePath, string Filename)
{
	local string filestr;

	filestr = ((filePath $ "\\") $ Filename);
	if((int(FileHandler) >= 5))
	{
		return true;
	}
	LastPath[int(FileHandler)] = filePath;
	UploadFileFullPath(filestr);
}

function bool UploadFileFullPath(string Path)
{
	Debug(Path);
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
		default:
			return true;
	}
}

function OnLoad()
{
	local array<string> strArray;
	local int i;

	LastPath.Length = 5;
	i = 0;
	while((i < 5))
	{
		LastPath[i] = "C:";
		i++;
	}
	IsIdle = true;
	FileHandler = FH_NONE;
	FileTextureName = "L2UI_CH3.BloodHoodWnd.BloodHood_Logon";
	FolderTextureName = "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff";
	if((1 == 0))
	{
	}
	else
	{
		Me = GetWindowHandle("FileWnd");
		FileListCtrl = GetListCtrlHandle("FileWnd.FLWListCtrl");
		FileListCtrl.SetHeaderAlignment(0, TA_Left);
		EditBoxCtrl = GetEditBoxHandle("FileWnd.FLWEditBox");
		FilePathComboBoxCtrl = GetComboBoxHandle("FileWnd.FLWComboBox");
		FileExtComboBoxCtrl = GetComboBoxHandle("FileWnd.FLWFTypeComboBox");
		strArray.Length = 1;
		strArray[0] = "*";
		FileExtComboBoxCtrl.AddStringWithFileExt("모든 파일", strArray);  // EN: all files
		SetFilePathnAdjustControl("C:");
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

	if((strID != "FLWEditBox"))
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
	local int idx;
	local LVDataRecord Record;
	local string Str;

	if((strID != "FLWListCtrl"))
	{
		return;
	}
	idx = FileListCtrl.GetSelectedIndex();
	if((idx < 0))
	{
		return;
	}
	FileListCtrl.GetRec(idx, Record);
	Str = Record.LVDataList[0].szData;
	if((Record.nReserved1 == INT64(0)))
	{
		Str = (m_filePath $ Str);
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
	local int idx, i, j, k;
	local bool bComp;
	local string remainStr;
	local array<DriveInfo> arrDrvInfo;

	if((Len(Str) <= 0))
	{
		return;
	}
	FilePathComboBoxCtrl.Clear();
	m_filePath = Str;
	k = -1;
	bComp = false;
	arrDrvInfo = GetDrivesInfoList();
	j = 0;
	while((j < arrDrvInfo.Length))
	{
		if((Left(arrDrvInfo[j].driveChar, 1) != Left(m_filePath, 1)))
		{
			FilePathComboBoxCtrl.AddString((Left(arrDrvInfo[j].driveChar, 1) $ ":"));
			if(!bComp)
			{
				++k;
			}
			++j;
			continue;
		}
		remainStr = Str;
		idx = InStr(remainStr, "\\");
		if((idx < 0))
		{
			idx = Len(remainStr);
		}
		Str = Left(remainStr, idx);
		remainStr = Right(remainStr, (Len(remainStr) - idx));
		FilePathComboBoxCtrl.AddStringWithGap(Str, 0);
		++k;
		i = 1;
		while((Len(remainStr) > 0))
		{
			remainStr = Right(remainStr, (Len(remainStr) - 1));
			idx = InStr(remainStr, "\\");
			if((idx < 0))
			{
				idx = Len(remainStr);
			}
			Str = Left(remainStr, idx);
			remainStr = Right(remainStr, (Len(remainStr) - idx));
			Str = ("\\" $ Str);
			FilePathComboBoxCtrl.AddStringWithGap(Str, i);
			++i;
			++k;
		}
		bComp = true;
		++j;
	}
	FilePathComboBoxCtrl.SetSelectedNum(k);
	return;
}

function OnClickListCtrlRecord(string strID)
{
	local int idx;
	local LVDataRecord Record;

	if((strID != "FLWListCtrl"))
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
	local LVData Data;
	local LVDataRecord Record;

	FileListCtrl.DeleteAllItem();
	Record.LVDataList.Length = 1;
	k = 0;
	while((k < FList.Length))
	{
		Data.szData = FList[k].Filename;
		Record.LVDataList[0].hasIcon = true;
		if(FList[k].bIsFile)
		{
			Record.LVDataList[0].szTexture = FileTextureName;
		}
		else
		{
			Record.LVDataList[0].szTexture = FolderTextureName;
		}
		Record.LVDataList[0].nTextureWidth = 14;
		Record.LVDataList[0].nTextureHeight = 14;
		Record.LVDataList[0].szData = FList[k].Filename;
		Record.nReserved1 = INT64(FList[k].bIsFile);
		FileListCtrl.InsertRecord(Record);
		k++;
	}
	FileListCtrl.AdjustColumnWidth(0);
	return;
}

function OnShow()
{
	local array<FileNameInfo> fInfoArray;
	local array<string> fExtArray;

	EditBoxCtrl.Clear();
	FileListCtrl.InitListCtrl();
	FileExtComboBoxCtrl.SetSelectedNum(0);
	fExtArray = FileExtComboBoxCtrl.GetFileExtInfo(FileExtComboBoxCtrl.GetSelectedNum());
	m_filePath = LastPath[int(FileHandler)];
	fInfoArray = GetFilesInfoList(LastPath[int(FileHandler)], fExtArray);
	EnumerateFile(fInfoArray);
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
	local int i, S, E;
	local array<FileNameInfo> fInfoArray;
	local array<string> fExtArray;

	if((Index < 0))
	{
		return;
	}
	if((strID == "FLWComboBox"))
	{
		S = getIndexOfCurrentDrive();
		E = getIndexOfCurrentFolder();
		if(((Index >= S) && (Index <= E)))
		{
			i = S;
			while((i <= Index))
			{
				Str = (Str $ FilePathComboBoxCtrl.GetString(i));
				++i;
			}
		}
		else
		{
			Str = FilePathComboBoxCtrl.GetString(Index);
		}
		SetFilePathnAdjustControl(Str);
	}
	else if((strID == "FLWFTypeComboBox"))
	{
		fExtArray = FileExtComboBoxCtrl.GetFileExtInfo(FileExtComboBoxCtrl.GetSelectedNum());
		fInfoArray = GetFilesInfoList(m_filePath, fExtArray);
		EnumerateFile(fInfoArray);
	}
	return;
}

function int getIndexOfCurrentDrive()
{
	local int idx, Num;
	local string rootDrive;

	idx = InStr(m_filePath, "\\");
	if((idx >= 0))
	{
		rootDrive = Left(m_filePath, idx);
	}
	else
	{
		rootDrive = m_filePath;
	}
	Num = FilePathComboBoxCtrl.GetNumOfItems();
	idx = 0;
	while((idx < Num))
	{
		if((rootDrive == FilePathComboBoxCtrl.GetString(idx)))
		{
			return idx;
		}
		++idx;
	}
	return -1;
}

function int getIndexOfCurrentFolder()
{
	local int S, i;
	local string Str;

	Str = m_filePath;
	S = getIndexOfCurrentDrive();
	while((InStr(Str, "\\") >= 0))
	{
		i = InStr(Str, "\\");
		Str = Right(Str, ((Len(Str) - i) - 1));
		if((Len(Str) <= 0))
		{
			break;
		}
		++S;
	}
	return S;
}

function OnClickButton(string strID)
{
	local string editStr, filePath;
	local int Index;
	local LVDataRecord Record;

	switch(strID)
	{
		case "FLWButtonOK":
			editStr = EditBoxCtrl.GetString();
			Index = SearchFileListWithName(editStr);
			if((Index < 0))
			{
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
				filePath = (m_filePath $ Record.LVDataList[0].szData);
				SetFilePathnAdjustControl(filePath);
			}
			break;
		case "FLWButtonCancel":
			Me.HideWindow();
			break;
		case "FLWButtonUp":
			Index = InStrFromBack(m_filePath, "\\");
			if((Index >= 0))
			{
				editStr = Left(m_filePath, Index);
				SetFilePathnAdjustControl(editStr);
			}
			break;
		default:
			break;
	}
	return;
}
