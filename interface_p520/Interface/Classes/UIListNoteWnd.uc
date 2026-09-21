class UIListNoteWnd extends UICommonAPI;

var RichListCtrlHandle itemListCtrl;
var EditBoxHandle EditBox;
var UIControlSimpleListEditor Editor;
var WindowHandle Owner;
var string sessionName;
//var delegate<delegateGetTitle> __delegateGetTitle__Delegate;
//var delegate<delegateGetParam> __delegateGetParam__Delegate;
//var delegate<delegateOnDBClick> __delegateOnDBClick__Delegate;

delegate string delegateGetTitle()
{

}

delegate string delegateGetParam()
{

}

delegate delegateOnDBClick(string param)
{
	return;
}

static function UIListNoteWnd Inst()
{
	return UIListNoteWnd(GetScript("UIListNoteWnd"));
}

function Initialize()
{
	itemListCtrl = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".itemListCtrl"));
	EditBox = GetEditBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".editBox"));
	Editor = Class'Interface.UIControlSimpleListEditor'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".UIControlSimpleListEditorExpands")));
	Editor._SetTargetRichCtrlHandleList(itemListCtrl);
	Editor._SetEditBoxHandle(EditBox);
	Editor._SetSessionName(m_hOwnerWnd.m_WindowNameWithFullPath);
	Editor.delegateGetParam = getParam;
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

event OnShow()
{
	itemListCtrl.DeleteAllItem();
	Editor.LoadAll();
	return;
}

event OnDBClickListCtrlRecord(string ListCtrlID)
{
	local RichListCtrlRowData Record;

	itemListCtrl.GetRec(itemListCtrl.GetSelectedIndex(), Record);
	delegateOnDBClick(Record.szReserved);
	return;
}

function _Show(WindowHandle _owner, optional string iniName, optional string sessionName, optional string KeyName)
{
	if(m_hOwnerWnd.IsShowWindow())
	{
		m_hOwnerWnd.HideWindow();
		return;
	}
	Owner = _owner;
	Class'Interface.L2Util'.static.Inst().windowAnchorToSide(Owner, m_hOwnerWnd, 10);
	m_hOwnerWnd.SetWindowTitle(("〓" $ Owner.m_WindowNameWithFullPath));
	if((KeyName == ""))
	{
		KeyName = _owner.m_WindowNameWithFullPath;
	}
	if((sessionName == ""))
	{
		sessionName = m_hOwnerWnd.m_WindowNameWithFullPath;
	}
	if((iniName == ""))
	{
		iniName = "UIDevSimpleListEditor";
	}
	SetIniName(iniName);
	Editor._SetKeyName(KeyName);
	Editor._SetSessionName(sessionName);
	itemListCtrl.DeleteAllItem();
	ShowWindowWithFocus(m_hOwnerWnd.m_WindowNameWithFullPath);
	return;
}

function _SetString(string Str)
{
	EditBox.SetString(Str);
	return;
}

function string _GetString()
{
	return EditBox.GetString();
}

function SetIniName(string iniName)
{
	Editor._SetIniname(iniName);
	return;
}

function string GetName()
{
	return delegateGetTitle();
}

function string getParam()
{
	return delegateGetParam();
}

function RichListCtrlRowData makeRecord(string _title, string _param)
{
	local RichListCtrlRowData Record;

	Record.cellDataList.Length = 1;
	Record.szReserved = _param;
	Record.cellDataList[0].szData = _title;
	AddRichListCtrlString(Record.cellDataList[0].drawitems, _title, getInstanceL2Util().BrightWhite, false, 4, 4);
	return Record;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("UISoundWnd").HideWindow();
	return;
}
