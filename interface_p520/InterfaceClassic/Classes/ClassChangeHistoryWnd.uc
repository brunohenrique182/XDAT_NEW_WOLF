class ClassChangeHistoryWnd extends UICommonAPI;

var WindowHandle Me;
var RichListCtrlHandle RichListCtrl;

static function ClassChangeHistoryWnd Inst()
{
	return ClassChangeHistoryWnd(GetScript("ClassChangeHistoryWnd"));
}

function Initialize()
{
	InitControls();
	return;
}

function InitControls()
{
	local string ownerFullPath;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	RichListCtrl = GetRichListCtrlHandle((ownerFullPath $ ".ClassChangeHistoryList_ListCtrl"));
	RichListCtrl.SetSelectable(false);
	Me = GetWindowHandle(ownerFullPath);
	return;
}

function SetInfo(array<ChangeClassData> classList)
{
	local int i;
	local RichListCtrlRowData rowData;
	local ChangeClassData classInfo;
	local L2Util util;

	util = getInstanceL2Util();
	RichListCtrl.DeleteAllItem();
	rowData.cellDataList.Length = 2;
	i = 0;
	while((i < classList.Length))
	{
		rowData.cellDataList[0].drawitems.Length = 0;
		rowData.cellDataList[1].drawitems.Length = 0;
		classInfo = classList[i];
		AddRichListCtrlString(rowData.cellDataList[0].drawitems, classInfo.RaceName, util.ColorYellow);
		AddRichListCtrlString(rowData.cellDataList[1].drawitems, classInfo.ClassName, util.White);
		RichListCtrl.InsertRecord(rowData);
		i++;
	}
	return;
}

function ToggleShow()
{
	if(Me.IsShowWindow())
	{
		Me.HideWindow();
	}
	else
	{
		Me.ShowWindow();
	}
	return;
}

function HideInfo()
{
	Me.HideWindow();
	return;
}

event OnLoad()
{
	Initialize();
	return;
}
