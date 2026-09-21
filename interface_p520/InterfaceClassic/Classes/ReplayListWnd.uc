class ReplayListWnd extends UICommonAPI;

const REPLAY_DIR = "..\\REPLAY";
const REPLAY_EXTENSION = ".L2R";
const DIALOG_DEL_CONFIRM = 8889;

var array<string> m_StrFileList;
var ListCtrlHandle m_hRecordList;
var CheckBoxHandle m_hChkCameraInst;
var CheckBoxHandle m_hChkChatData;

function OnLoad()
{
	m_hRecordList = GetListCtrlHandle("ReplayListWnd.ReplayListCtrl");
	m_hChkCameraInst = GetCheckBoxHandle("ReplayListWnd.chkLoadCamInst");
	m_hChkChatData = GetCheckBoxHandle("ReplayListWnd.chkLoadChatData");
	return;
}

function OnShow()
{
	InitReplayList();
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(1710);
	RegisterEvent(1720);
	return;
}

function InitReplayList()
{
	local array<string> strReplayFileList;
	local int i, iLength;
	local string strFileName;

	m_hRecordList.DeleteAllItem();
	GetFileList(strReplayFileList, "..\\REPLAY", ".L2R");
	i = 0;
	while((i < strReplayFileList.Length))
	{
		iLength = (Len(strReplayFileList[i]) - Len(".L2R"));
		strFileName = Left(strReplayFileList[i], iLength);
		AddItem(i, strFileName);
		++i;
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 1710:
			HandleDialogOK();
			break;
		case 1720:
			break;
		default:
			break;
	}
	return;
}

function AddItem(int iNum, string strFileName)
{
	local LVDataRecord Record;
	local LVData Data;

	Data.szData = string(iNum);
	Record.LVDataList[0] = Data;
	Data.szData = strFileName;
	Record.LVDataList[1] = Data;
	m_hRecordList.InsertRecord(Record);
	return;
}

function string GetSelectedFileName()
{
	local int Index;
	local LVDataRecord Record;
	local string strFileName;

	Index = m_hRecordList.GetSelectedIndex();
	if((Index >= 0))
	{
		m_hRecordList.GetRec(Index, Record);
		strFileName = Record.LVDataList[1].szData;
	}
	return strFileName;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	OnOk();
	return;
}

function HandleDialogOK()
{
	local int Id;

	if(DialogIsMine())
	{
		Id = DialogGetID();
		if((Id == 8889))
		{
			OnDelete();
			InitReplayList();
		}
	}
	return;
}

function askDelDialog()
{
	local WindowHandle m_dialogWnd;
	local string strFileName;

	strFileName = GetSelectedFileName();
	if((strFileName == ""))
	{
		return;
	}
	m_dialogWnd = GetWindowHandle("DialogBox");
	if(!m_dialogWnd.IsShowWindow())
	{
		DialogSetID(8889);
		DialogShow(DialogModalType_Modal, DialogType_OKCancel, GetSystemMessage(3719));
	}
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnOK":
			OnOk();
			break;
		case "btnDel":
			askDelDialog();
			break;
		case "btnCancel":
			SetUIState("LoginState");
			break;
		default:
			break;
	}
	return;
}

function OnOk()
{
	local string strFileName;
	local bool bLoadCameraInst, bLoadChatData;

	strFileName = GetSelectedFileName();
	if((strFileName == ""))
	{
		return;
	}
	bLoadCameraInst = m_hChkCameraInst.IsChecked();
	bLoadChatData = m_hChkChatData.IsChecked();
	BeginReplay(strFileName, bLoadCameraInst, bLoadChatData);
	return;
}

function OnDelete()
{
	local string strFileName;

	strFileName = GetSelectedFileName();
	if((strFileName == ""))
	{
		return;
	}
	EraseReplayFile((((("..\\REPLAY" $ "\\") $ strFileName) $ "") $ ".L2R"));
	return;
}
