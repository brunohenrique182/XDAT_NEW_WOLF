class FileListWnd extends UICommonAPI;

var bool m_bShow;
var WindowHandle Me;
var ListCtrlHandle FileListCtrl;
var EditBoxHandle EditBoxCtrl;
var ComboBoxHandle FilePathComboBoxCtrl;
var ComboBoxHandle FileExtComboBoxCtrl;
var string m_filePath;

function OnLoad()
{
	local array<string> strArray;

	SetClosingOnESC();
	if((1 == 0))
	{
	}
	else
	{
		Me = GetWindowHandle("FileListWnd");
		FileListCtrl = GetListCtrlHandle("FileListWnd.FLWListCtrl");
		FileListCtrl.SetHeaderAlignment(0, TA_Left);
		EditBoxCtrl = GetEditBoxHandle("FileListWnd.FLWEditBox");
		FilePathComboBoxCtrl = GetComboBoxHandle("FileListWnd.FLWComboBox");
		FileExtComboBoxCtrl = GetComboBoxHandle("FileListWnd.FLWFTypeComboBox");
		strArray.Length = 1;
		strArray[0] = "swf";
		FileExtComboBoxCtrl.AddStringWithFileExt("Flash file", strArray);
		strArray.Length = 1;
		strArray[0] = "*";
		FileExtComboBoxCtrl.AddStringWithFileExt("All file", strArray);
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
	fInfoArray = Class'NWindow.FileListAPI'.static.GetFileInfoList(m_filePath, fExtArray);
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
		EditBoxCtrl.Clear();
		return;
	}
	FileListCtrl.GetRec(idx, Record);
	filePath = ((m_filePath $ "\\") $ Record.LVDataList[0].szData);
	if((Record.nReserved1 == INT64(1)))
	{
		if(Class'NWindow.FileListAPI'.static.ShowFlash(filePath))
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
		Str = ((m_filePath $ "\\") $ Record.LVDataList[0].szData);
		if(Class'NWindow.FileListAPI'.static.ShowFlash(Str))
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
	arrDrvInfo = Class'NWindow.FileListAPI'.static.GetDriveInfoList();
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
			Record.LVDataList[0].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logon";
		}
		else
		{
			Record.LVDataList[0].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff";
		}
		Record.LVDataList[0].nTextureWidth = 14;
		Record.LVDataList[0].nTextureHeight = 14;
		Record.LVDataList[0].nTextureU = 14;
		Record.LVDataList[0].nTextureV = 14;
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
	fExtArray = FileExtComboBoxCtrl.GetFileExtInfo(FileExtComboBoxCtrl.GetSelectedNum());
	fInfoArray = Class'NWindow.FileListAPI'.static.GetFileInfoList(m_filePath, fExtArray);
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
		fInfoArray = Class'NWindow.FileListAPI'.static.GetFileInfoList(m_filePath, fExtArray);
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
				filePath = ((m_filePath $ "\\") $ Record.LVDataList[0].szData);
				if(Class'NWindow.FileListAPI'.static.ShowFlash(filePath))
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

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("FileListWnd").HideWindow();
	return;
}
