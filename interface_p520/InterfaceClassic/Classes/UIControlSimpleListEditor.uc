class UIControlSimpleListEditor extends UICommonAPI;

struct COPYED_DATA_STRUCT
{
	var string Title;
	var string param;
};

var RichListCtrlHandle targetList;
var EditBoxHandle targetEditBox;
var string iniName;
var string sessionName;
var string KeyName;
var COPYED_DATA_STRUCT copyed_data;
//var delegate<DelegateOnInsert> __DelegateOnInsert__Delegate;
//var delegate<DelegateOnUp> __DelegateOnUp__Delegate;
//var delegate<DelegateOnDown> __DelegateOnDown__Delegate;
//var delegate<DelegateOnX> __DelegateOnX__Delegate;
//var delegate<DelegateOnDeleteAll> __DelegateOnDeleteAll__Delegate;
//var delegate<DelegateOnCopy> __DelegateOnCopy__Delegate;
//var delegate<DelegateOnPaste> __DelegateOnPaste__Delegate;
//var delegate<DelegateHandleInsertDialogOK> __DelegateHandleInsertDialogOK__Delegate;
//var delegate<delegateGetTitle> __delegateGetTitle__Delegate;
//var delegate<delegateGetParam> __delegateGetParam__Delegate;

delegate DelegateOnInsert(string _title, string _param)
{
	return;
}

delegate DelegateOnUp()
{
	return;
}

delegate DelegateOnDown()
{
	return;
}

delegate DelegateOnX()
{
	return;
}

delegate DelegateOnDeleteAll()
{
	return;
}

delegate DelegateOnCopy()
{
	return;
}

delegate DelegateOnPaste()
{
	return;
}

delegate DelegateHandleInsertDialogOK()
{
	return;
}

delegate string delegateGetTitle()
{

}

delegate string delegateGetParam()
{

}

static function UIControlSimpleListEditor InitScript(WindowHandle wnd)
{
	local UIControlSimpleListEditor scr;

	wnd.SetScript("UIControlSimpleListEditor");
	scr = UIControlSimpleListEditor(wnd.GetScript());
	scr.InitWnd(wnd);
	return scr;
}

function InitWnd(WindowHandle wnd)
{
	m_hOwnerWnd = wnd;
	_SetIniname("UIDevSimpleListEditor");
	return;
}

function _SetTargetRichCtrlHandleList(RichListCtrlHandle _targetRichList)
{
	targetList = _targetRichList;
	sessionName = targetList.m_WindowNameWithFullPath;
	LoadAll();
	return;
}

function _SetEditBoxHandle(EditBoxHandle Editor)
{
	targetEditBox = Editor;
	return;
}

function _InsertRecord(RichListCtrlRowData Record)
{
	targetList.InsertRecord(Record);
	Save(Record.cellDataList[0].szData, Record.szReserved);
	DelegateOnInsert(Record.cellDataList[0].szData, Record.szReserved);
	targetList.SetSelectedIndex((targetList.GetRecordCount() - 1), true);
	return;
}

function _Insert(string param)
{
	_InsertRecord(makeRecord(Class'InterfaceClassic.DialogBox'.static.Inst().GetEditMessage(), param));
	return;
}

function HandleInsertDialogOK()
{
	local string Title;

	Title = Class'InterfaceClassic.DialogBox'.static.Inst().GetEditMessage();
	if((Title == ""))
	{
		return;
	}
	_Insert(delegateGetParam());
	DelegateHandleInsertDialogOK();
	return;
}

function _SetKeyName(string _keyName)
{
	KeyName = _keyName;
	return;
}

function _SetSessionName(string _sessionName)
{
	sessionName = _sessionName;
	return;
}

function _SetIniname(string _iniName)
{
	iniName = _iniName;
	return;
}

function Save(string Title, string param)
{
	saveIndex(Title, param, (targetList.GetRecordCount() - 1));
	return;
}

function saveIndex(string Title, string param, int Index)
{
	SetINIString(sessionName, ((KeyName $ "_") $ string(Index)), param, iniName);
	SaveINI(iniName);
	return;
}

function SaveAll()
{
	local int Index;
	local RichListCtrlRowData Record;

	Index = 0;
	while((Index < targetList.GetRecordCount()))
	{
		targetList.GetRec(Index, Record);
		saveIndex(Record.cellDataList[0].szData, Record.szReserved, Index);
		Index++;
	}
	SaveINI(iniName);
	return;
}

function LoadAll()
{
	local int Index;
	local string savedString, Title;

	while(GetINIString(sessionName, ((KeyName $ "_") $ string(Index)), savedString, iniName))
	{
		ParseString(savedString, "*t", Title);
		targetList.InsertRecord(makeRecord(Title, savedString));
		Index++;
	}
	return;
}

function RemoveAll()
{
	RemoveINI(sessionName, "", iniName);
	SaveINI(iniName);
	return;
}

function RemoveIndex(int Index)
{
	local RichListCtrlRowData Record;

	targetList.DeleteRecord(Index);
	Index = Index;
	while((Index < targetList.GetRecordCount()))
	{
		targetList.GetRec(Index, Record);
		SetINIString(sessionName, ((KeyName $ "_") $ string(Index)), Record.szReserved, iniName);
		Index++;
	}
	RemoveINI(sessionName, ((KeyName $ "_") $ string(targetList.GetRecordCount())), iniName);
	SaveINI(iniName);
	return;
}

function Copy()
{
	local int Index;
	local RichListCtrlRowData Record;

	Index = targetList.GetSelectedIndex();
	targetList.GetRec(Index, Record);
	copyed_data.Title = Record.cellDataList[0].szData;
	copyed_data.param = Record.szReserved;
	return;
}

function Paste()
{
	_InsertRecord(makeRecord(copyed_data.Title, copyed_data.param));
	return;
}

function OnAddClicked()
{
	DialogShow(DialogModalType_Modalless, DialogType_OKInput, GetSystemMessage(328));
	Class'InterfaceClassic.DialogBox'.static.Inst().SetDefaultAction(EDefaultOK);
	Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnOK = HandleInsertDialogOK;
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "BtnEditAdd":
			OnAddClicked();
			if((targetEditBox.m_pTargetWnd != none))
			{
				Class'InterfaceClassic.DialogBox'.static.Inst().SetEditMessage(targetEditBox.GetString());
			}
			break;
		case "Copy_Btn":
			Copy();
			DelegateOnCopy();
			break;
		case "Paste_Btn":
			Paste();
			DelegateOnPaste();
			break;
		case "BtnEditdel":
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, "선택 된 항목을 삭제 하시겠습니까?");  // EN?: Are you sure you want to delete the selected items?
			Class'InterfaceClassic.DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
			Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnOK = DelSelected;
			break;
		case "BtnEditAlldel":
			DialogShow(DialogModalType_Modalless, DialogType_OKCancel, "모든 항목을 삭제 하시겠습니까?");  // EN?: Are you sure you want to delete ALL log items?
			Class'InterfaceClassic.DialogBox'.static.Inst().SetDefaultAction(EDefaultCancel);
			Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnOK = DelAll;
			break;
		case "BtnEditUp":
			HandleUP();
			break;
		case "BtnEditDown":
			HandleDown();
			break;
		default:
			break;
	}
	return;
}

function DelSelected()
{
	RemoveIndex(targetList.GetSelectedIndex());
	DelegateOnX();
	return;
}

function DelAll()
{
	targetList.DeleteAllItem();
	RemoveAll();
	DelegateOnDeleteAll();
	DelegateOnX();
	return;
}

function HandleUP()
{
	local int SelectedIndex;
	local RichListCtrlRowData Record, Record2;

	DelegateOnUp();
	if((targetList.GetSelectedIndex() > 0))
	{
		SelectedIndex = targetList.GetSelectedIndex();
		targetList.GetRec(SelectedIndex, Record);
		targetList.GetRec((SelectedIndex - 1), Record2);
		targetList.ModifyRecord((SelectedIndex - 1), Record);
		targetList.ModifyRecord(SelectedIndex, Record2);
		targetList.SetSelectedIndex((SelectedIndex - 1), true);
		saveIndex(Record.cellDataList[0].szData, Record.szReserved, (SelectedIndex - 1));
		saveIndex(Record2.cellDataList[0].szData, Record2.szReserved, SelectedIndex);
	}
	return;
}

function HandleDown()
{
	local int SelectedIndex;
	local RichListCtrlRowData Record, Record2;

	DelegateOnDown();
	if((targetList.GetRecordCount() > (targetList.GetSelectedIndex() + 1)))
	{
		SelectedIndex = targetList.GetSelectedIndex();
		targetList.GetRec(SelectedIndex, Record);
		targetList.GetRec((SelectedIndex + 1), Record2);
		targetList.ModifyRecord((SelectedIndex + 1), Record);
		targetList.ModifyRecord(SelectedIndex, Record2);
		targetList.SetSelectedIndex((SelectedIndex + 1), true);
		saveIndex(Record.cellDataList[0].szData, Record.szReserved, (SelectedIndex + 1));
		saveIndex(Record2.cellDataList[0].szData, Record2.szReserved, SelectedIndex);
	}
	return;
}

function RichListCtrlRowData makeRecord(string _title, string _param)
{
	local RichListCtrlRowData Record;

	ParamAdd(_param, "*t", _title);
	Record.cellDataList.Length = 1;
	Record.szReserved = _param;
	Record.cellDataList[0].szData = _title;
	AddRichListCtrlString(Record.cellDataList[0].drawitems, _title, getInstanceL2Util().BrightWhite, false, 4, 4);
	return Record;
}
