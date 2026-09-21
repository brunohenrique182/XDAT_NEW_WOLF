class UIEditor_ControlManager extends UICommonAPI;

const XML_PATH = "..\\Interface\\Default";
const TIMERID_SELECT = 9;
const TIMER_SELECT = 200;

struct windowInfos
{
	var WindowHandle topWnd;
	var array<string> hiddenList;
	var array<string> foldedList;
};

var WindowHandle Me;
var TextBoxHandle txtNewControl;
var ListBoxHandle lstControls;
var ItemWindowHandle ControlItem;
var TextBoxHandle txtControlAlign;
var TextBoxHandle txtPathStr;
var CheckBoxHandle chkShowWindowBox;
var CheckBoxHandle chkVirtualBack;
var CheckBoxHandle chkExampleAni;
var ButtonHandle btnLeft;
var ButtonHandle btnCenter;
var ButtonHandle btnRight;
var ButtonHandle btnWidth;
var ButtonHandle btnHeight;
var ButtonHandle btnUp;
var ButtonHandle btnDown;
var RichListCtrlHandle richListCurrentControl;
var WindowHandle m_CurTopWnd;
var WindowHandle selectWnd;
var bool bCallfromEvent;
var int lastFindIndex;
var ComboBoxHandle TypeFilter;
var array<windowInfos> attachedWindows;
var int windowInfosCurrentIndex;
var int dontInsertRecordCount;
var bool chkDbClick;

event OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 9:
			chkDbClick = false;
			m_hOwnerWnd.KillTimer(9);
			break;
		default:
			break;
	}
	return;
}

function InitNewControlList()
{
	local int i;
	local string strName;

	lstControls.Clear();
	TypeFilter.AddString("None");
	i = 1;
	while((i < 100))
	{
		strName = GetXMLControlString(EXMLControlType(i));
		if((Len(strName) > 0))
		{
			TypeFilter.AddString(strName);
			lstControls.AddString(strName);
			i++;
			continue;
		}
		break;
		i++;
	}
	return;
}

function InitControlItem()
{
	local ItemInfo infItem;

	setWindowTitleByString("UIEditor - ControlManager");
	infItem.Name = "NewControl";
	infItem.IconName = "L2UI_CH3.MenuIcon.menuButton4";
	ControlItem.AddItem(infItem);
	txtControlAlign.SetText("Control Align");
	InitNewControlList();
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(2920);
	RegisterEvent(2930);
	RegisterEvent(2940);
	return;
}

event OnLoad()
{
	windowInfosCurrentIndex = -1;
	InitHandle();
	InitControlItem();
	return;
}

function InitHandle()
{
	Me = GetWindowHandle("UIEditor_ControlManager");
	ControlItem = GetItemWindowHandle("UIEditor_ControlManager.NewControlItem");
	lstControls = GetListBoxHandle("UIEditor_ControlManager.lstControls");
	txtControlAlign = GetTextBoxHandle("UIEditor_ControlManager.txtControlAlign");
	txtPathStr = GetTextBoxHandle("UIEditor_ControlManager.txtPathStr");
	chkShowWindowBox = GetCheckBoxHandle("UIEditor_ControlManager.chkShowWindowBox");
	chkVirtualBack = GetCheckBoxHandle("UIEditor_ControlManager.chkVirtualBack");
	chkExampleAni = GetCheckBoxHandle("UIEditor_ControlManager.chkExampleAni");
	btnLeft = GetButtonHandle("UIEditor_ControlManager.btnLeft");
	btnCenter = GetButtonHandle("UIEditor_ControlManager.btnCenter");
	btnRight = GetButtonHandle("UIEditor_ControlManager.btnRight");
	btnWidth = GetButtonHandle("UIEditor_ControlManager.btnWidth");
	btnHeight = GetButtonHandle("UIEditor_ControlManager.btnHeight");
	TypeFilter = GetComboBoxHandle("UIEditor_ControlManager.TypeFilter");
	btnUp = GetButtonHandle("UIEditor_ControlManager.btnUp");
	btnDown = GetButtonHandle("UIEditor_ControlManager.btnDown");
	richListCurrentControl = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".richListCurrentControl"));
	return;
}

event OnCompleteEditBox(string strID)
{
	switch(strID)
	{
		case "FindBox":
			HandleFind();
			break;
		default:
			break;
	}
	return;
}

event OnComboBoxItemSelected(string strID, int Index)
{
	switch(strID)
	{
		case "TypeFilter":
			richListCurrentControl.DeleteAllItem();
			AddChildWIndowToList(m_CurTopWnd, "", 0);
			break;
		default:
			break;
	}
	return;
}

event OnEvent(int Event_ID, string param)
{
	if((Event_ID == 2920))
	{
		HandleTrackerAttach();
	}
	else if((Event_ID == 2930))
	{
		HandleTrackerDetach();
	}
	else if((Event_ID == 2940))
	{
		HandleEditorSetProperty(param);
	}
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "btnLeft":
		case "btnCenter":
		case "btnRight":
		case "btnWidth":
		case "btnHeight":
			OnAlignClick(Name);
			break;
		case "btnUp":
		case "btnDown":
			OnOrderClick(Name);
			break;
		case "FindBtn":
			HandleFind();
			break;
		case "listBtn":
			FoldRecord();
			break;
		default:
			break;
	}
	return;
}

event OnClickItem(string strID, int Index)
{
	switch(strID)
	{
		case "NewControlItem":
			AddControl(selectWnd, 0, 0);
		default:
			return;
	}
}

event OnChangeEditBox(string strID)
{
	switch(strID)
	{
		case "FindBox":
			lastFindIndex = 0;
			break;
		default:
			break;
	}
	return;
}

event OnClickCheckBox(string Name)
{
	switch(Name)
	{
		case "chkShowWindowBox":
			ShowEnableTrackerBox(chkShowWindowBox.IsChecked());
			break;
		case "chkVirtualBack":
			ShowVirtualWindowBackground(chkVirtualBack.IsChecked());
			break;
		case "chkExampleAni":
			ShowExampleAnimation(chkExampleAni.IsChecked());
			break;
		default:
			break;
	}
	return;
}

function OnAlignClick(string Name)
{
	switch(Name)
	{
		case "btnLeft":
			ExecuteAlign(TAT_Left);
			break;
		case "btnCenter":
			ExecuteAlign(TAT_Center);
			break;
		case "btnRight":
			ExecuteAlign(TAT_Right);
			break;
		case "btnWidth":
			ExecuteAlign(TAT_Width);
			break;
		case "btnHeight":
			ExecuteAlign(TAT_Height);
			break;
		default:
			break;
	}
	return;
}

event OnDBClickListCtrlRecord(string strID)
{
	if((strID != "richListCurrentControl"))
	{
		return;
	}
	SetShowHideSelectedList();
	chkDbClick = false;
	m_hOwnerWnd.KillTimer(9);
	return;
}

event OnClickListCtrlRecord(string strID)
{
	if((strID != "richListCurrentControl"))
	{
		return;
	}
	SetClickListCtrlCurrentSelected();
	return;
}

event OnRClickListCtrlRecord(string strID)
{
	return;
}

event OnRButtonUp(WindowHandle wndHandle, int X, int Y)
{
	ShowContextMenu(X, Y);
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey Key)
{
	if((a_WindowHandle != richListCurrentControl))
	{
		return false;
	}
	if((Class'NWindow.InputAPI'.static.IsCtrlPressed() && (Class'NWindow.InputAPI'.static.GetKeyString(Key) == "C")))
	{
		listClipboardCopy("richListCurrentControl");
		return false;
	}
	switch(Key)
	{
		case IK_Delete:
			SetClickListCtrlCurrentSelected();
			selectWnd.SetFocus();
			DeleteAttachedWindow();
			break;
		case IK_Left:
			FoldRecord();
			break;
		case IK_Right:
			SetShowHideSelectedList();
			break;
		case IK_Space:
			break;
		case IK_Enter:
			SetClickListCtrlCurrentSelected();
			break;
		default:
			break;
	}
	return false;
}

event bool OnKeyDown(WindowHandle a_WindowHandle, Interactions.EInputKey Key)
{
	local int SelectedIndex;

	if((a_WindowHandle != richListCurrentControl))
	{
		return false;
	}
	SelectedIndex = richListCurrentControl.GetSelectedIndex();
	switch(Key)
	{
		case IK_Up:
			if(Class'NWindow.InputAPI'.static.IsShiftPressed())
			{
				OnOrderClick("btnUp");
			}
			else if((SelectedIndex > 0))
			{
				richListCurrentControl.SetSelectedIndex((SelectedIndex - 1), true);
			}
			break;
		case IK_Down:
			if(Class'NWindow.InputAPI'.static.IsShiftPressed())
			{
				OnOrderClick("btnDown");
			}
			else if((SelectedIndex < (richListCurrentControl.GetRecordCount() - 1)))
			{
				richListCurrentControl.SetSelectedIndex((SelectedIndex + 1), true);
			}
			break;
		default:
			break;
	}
	return false;
}

function SetClickListCtrlCurrentSelected()
{
	local int idx;
	local RichListCtrlRowData rowDdata;

	idx = richListCurrentControl.GetSelectedIndex();
	if((idx < 0))
	{
		return;
	}
	bCallfromEvent = false;
	richListCurrentControl.GetRec(idx, rowDdata);
	SelectControl(rowDdata.szReserved);
	return;
}

function listClipboardCopy(string strID)
{
	local int idx, SplitCount;
	local RichListCtrlRowData rowData;
	local array<string> arrSplit;

	if((strID != "richListCurrentControl"))
	{
		return;
	}
	idx = richListCurrentControl.GetSelectedIndex();
	if((idx < 0))
	{
		return;
	}
	richListCurrentControl.GetRec(idx, rowData);
	SplitCount = Split(rowData.szReserved, ".", arrSplit);
	if((SplitCount > 0))
	{
		ClipboardCopy(arrSplit[(arrSplit.Length - 1)]);
	}
	return;
}

function DeleteRecordIdexToEnd(int startIdx)
{
	local int i, Len;

	Len = richListCurrentControl.GetRecordCount();
	i = startIdx;
	while((i < Len))
	{
		richListCurrentControl.DeleteRecord(startIdx);
		i++;
	}
	return;
}

function UpdateControlList()
{
	m_CurTopWnd = none;
	return;
}

function FoldRecord()
{
	local int idx;
	local RichListCtrlRowData rowData;
	local WindowHandle hWnd;
	local windowInfos wndInfo;
	local int foldedIndex;
	local bool isFolded;
	local array<WindowHandle> ChildList;

	idx = richListCurrentControl.GetSelectedIndex();
	if((idx < 0))
	{
		return;
	}
	richListCurrentControl.GetRec(idx, rowData);
	if((rowData.nReserved1 < INT64(1)))
	{
		return;
	}
	hWnd = FindWindowHandle(rowData.szReserved);
	ChildList = GetChildWindowListUtil(hWnd);
	if((ChildList.Length < 1))
	{
		return;
	}
	foldedIndex = GetfoldedWndIndex(rowData.szReserved);
	isFolded = (foldedIndex > -1);
	wndInfo = windowInfosCur();
	if(!isFolded)
	{
		attachedWindows[windowInfosCurrentIndex].foldedList[wndInfo.foldedList.Length] = rowData.szReserved;
	}
	else
	{
		attachedWindows[windowInfosCurrentIndex].foldedList.Remove(foldedIndex, 1);
	}
	ModifyRecordFolded(idx, !isFolded);
	dontInsertRecordCount = (idx + 1);
	DeleteRecordIdexToEnd(dontInsertRecordCount);
	AddChildWIndowToList(m_CurTopWnd, "", 0);
	return;
}

function SetShowHideList(int idx, int hiddenIndex)
{
	local WindowHandle hWnd;
	local windowInfos wndInfo;
	local RichListCtrlRowData rowData;
	local bool isHidden;

	isHidden = (hiddenIndex > -1);
	richListCurrentControl.GetRec(idx, rowData);
	if((rowData.nReserved1 < INT64(1)))
	{
		return;
	}
	hWnd = FindWindowHandle(rowData.szReserved);
	wndInfo = windowInfosCur();
	if(!isHidden)
	{
		attachedWindows[windowInfosCurrentIndex].hiddenList[wndInfo.hiddenList.Length] = rowData.szReserved;
		hWnd.ExitState();
	}
	else
	{
		attachedWindows[windowInfosCurrentIndex].hiddenList.Remove(hiddenIndex, 1);
		hWnd.EnterState();
	}
	ModifyRecordHidden(idx, !isHidden);
	return;
}

function SetShowHideSelectedList()
{
	local int idx, hiddenIndex;
	local RichListCtrlRowData rowData;

	idx = richListCurrentControl.GetSelectedIndex();
	if((idx < 0))
	{
		return;
	}
	richListCurrentControl.GetRec(idx, rowData);
	if((rowData.nReserved1 < INT64(1)))
	{
		return;
	}
	hiddenIndex = GetHiddenWndIndex(rowData.szReserved);
	SetShowHideList(idx, hiddenIndex);
	return;
}

function RefreshControlList()
{
	UpdateControlList();
	HandleTrackerAttach();
	return;
}

function HandleTrackerAttach()
{
	local WindowHandle TrackerWnd, topWnd;
	local int Index;

	TrackerWnd = GetTrackerAttachedWindow();
	if((TrackerWnd == none))
	{
		return;
	}
	topWnd = TrackerWnd.GetTopFrameWnd();
	if((topWnd == none))
	{
		return;
	}
	if((m_CurTopWnd != topWnd))
	{
		Index = GetTrackerIndex(topWnd);
		if((Index == -1))
		{
			SetChildListDepth(topWnd);
			windowInfosCurrentIndex = attachedWindows.Length;
			AddWindowInfo(topWnd);
		}
		else
		{
			windowInfosCurrentIndex = Index;
		}
		m_CurTopWnd = topWnd;
		richListCurrentControl.DeleteAllItem();
		AddChildWIndowToList(topWnd, "", 0);
	}
	if((selectWnd != TrackerWnd))
	{
		SelectControlList(GetfullName(TrackerWnd));
		chkDbClick = true;
		m_hOwnerWnd.SetTimer(9, 200);
	}
	else if(chkDbClick)
	{
		chkDbClick = false;
		SetShowHideSelectedList();
	}
	else
	{
		chkDbClick = true;
		m_hOwnerWnd.SetTimer(9, 200);
	}
	return;
}

function HandleTrackerDetach()
{
	if((windowInfosCurrentIndex > -1))
	{
		attachedWindows.Remove(windowInfosCurrentIndex, 1);
	}
	m_CurTopWnd = none;
	richListCurrentControl.DeleteAllItem();
	return;
}

function HandleEditorSetProperty(string param)
{
	local string PropertyName;
	local int Count;
	local array<string> NameList;

	ParseString(param, "PropertyName", PropertyName);
	if((Len(PropertyName) < 1))
	{
		return;
	}
	Count = Split(PropertyName, ".", NameList);
	if((Count < 2))
	{
		return;
	}
	if(((NameList[(Count - 1)] == "name") && (NameList[(Count - 2)] == "DefaultProperty")))
	{
		UpdateControlList();
		HandleTrackerAttach();
	}
	return;
}

function ModifyRecordHidden(int idx, bool isHidden)
{
	local RichListCtrlRowData rowData;

	richListCurrentControl.GetRec(idx, rowData);
	SetListColorRowData(rowData, ColorByType(rowData.cellDataList[2].szData, isHidden));
	richListCurrentControl.ModifyRecord(idx, rowData);
	return;
}

function ModifyRecordFolded(int idx, bool isFolded)
{
	local RichListCtrlRowData rowData;

	richListCurrentControl.GetRec(idx, rowData);
	if((rowData.cellDataList[0].nReserved1 == 1))
	{
		if(isFolded)
		{
			rowData.cellDataList[0].drawitems[0].btnInfo.normalTex.sTex = "l2ui_ch3.QuestWnd.QuestWndPlusBtn";
			rowData.cellDataList[0].drawitems[0].btnInfo.pushedTex.sTex = "l2ui_ch3.QuestWnd.QuestWndPlusBtn_Over";
			rowData.cellDataList[0].drawitems[0].btnInfo.highlightTex.sTex = "l2ui_ch3.QuestWnd.QuestWndPlusBtn_Down";
		}
		else
		{
			rowData.cellDataList[0].drawitems[0].btnInfo.normalTex.sTex = "l2ui_ch3.QuestWnd.QuestWndMinusBtn";
			rowData.cellDataList[0].drawitems[0].btnInfo.pushedTex.sTex = "l2ui_ch3.QuestWnd.QuestWndMinusBtn_Over";
			rowData.cellDataList[0].drawitems[0].btnInfo.highlightTex.sTex = "l2ui_ch3.QuestWnd.QuestWndMinusBtn_Down";
		}
	}
	richListCurrentControl.ModifyRecord(idx, rowData);
	return;
}

function AddChildWIndowToList(WindowHandle hWnd, string parentname, int depth, optional bool isLast)
{
	local int idx;
	local UIEventManager.EXMLControlType Type;
	local string Name, FullName;
	local array<WindowHandle> ChildList;
	local int ChildDepth;
	local string ChildHead;
	local bool isHidden, isFolded;
	local RichListCtrlRowData rowData;
	local Color C;

	if((hWnd == none))
	{
		return;
	}
	Type = hWnd.GetControlType();
	if((int(Type) == 0))
	{
		return;
	}
	if(!hWnd.IsShowWindow())
	{
		return;
	}
	Name = hWnd.GetWindowName();
	if((Len(Name) < 1))
	{
		return;
	}
	if((Len(parentname) > 0))
	{
		FullName = ((parentname $ ".") $ Name);
	}
	else
	{
		FullName = Name;
	}
	ChildList = GetChildWindowListUtil(hWnd);
	if((depth > 0))
	{
		idx = 0;
		while((idx < depth))
		{
			if((idx == (depth - 1)))
			{
				if(((ChildList.Length > 0) || isLast))
				{
					ChildHead = (ChildHead $ "└");
				}
				else
				{
					ChildHead = (ChildHead $ "┡");
				}
				idx++;
				continue;
			}
			ChildHead = (ChildHead $ "·");
			idx++;
		}
	}
	rowData.cellDataList.Length = 4;
	rowData.nReserved1 = INT64(depth);
	rowData.szReserved = FullName;
	isHidden = IsHiddenWindow(FullName);
	isFolded = IsFoldedWindow(FullName);
	if(((ChildList.Length > 0) && (m_CurTopWnd != hWnd)))
	{
		rowData.cellDataList[0].nReserved1 = 1;
		if(isFolded)
		{
			AddRichListCtrlButton(rowData.cellDataList[0].drawitems, "listBtn", (2 * (depth - 1)), 0, "l2ui_ch3.QuestWnd.QuestWndPlusBtn", "l2ui_ch3.QuestWnd.QuestWndPlusBtn_Over", "l2ui_ch3.QuestWnd.QuestWndPlusBtn_Down", 15, 15, 15, 15);
		}
		else
		{
			AddRichListCtrlButton(rowData.cellDataList[0].drawitems, "listBtn", (2 * (depth - 1)), 0, "l2ui_ch3.QuestWnd.QuestWndMinusBtn", "l2ui_ch3.QuestWnd.QuestWndMinusBtn_Over", "l2ui_ch3.QuestWnd.QuestWndMinusBtn_Down", 15, 15, 15, 15);
		}
	}
	else
	{
		rowData.cellDataList[0].nReserved1 = 0;
	}
	rowData.cellDataList[0].szData = GetDepthString(depth);
	rowData.cellDataList[1].szData = (ChildHead $ Name);
	rowData.cellDataList[1].szReserved = Name;
	rowData.cellDataList[2].szData = GetXMLControlString(Type);
	rowData.cellDataList[3].szData = ReverseParentName(parentname);
	C = ColorByType(rowData.cellDataList[2].szData, isHidden);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, rowData.cellDataList[1].szData, C);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, rowData.cellDataList[2].szData, C);
	AddRichListCtrlString(rowData.cellDataList[3].drawitems, rowData.cellDataList[3].szData, C);
	if(((int(Type) == TypeFilter.GetSelectedNum()) || (TypeFilter.GetSelectedNum() == 0)))
	{
		dontInsertRecordCount--;
		if((dontInsertRecordCount < 0))
		{
			richListCurrentControl.InsertRecord(rowData);
		}
	}
	if(!hWnd.IsControlContainer())
	{
		return;
	}
	ChildDepth = (depth + 1);
	if(!isFolded)
	{
		idx = 0;
		while((idx < ChildList.Length))
		{
			AddChildWIndowToList(ChildList[idx], FullName, ChildDepth, (idx == (ChildList.Length - 1)));
			idx++;
		}
	}
	return;
}

function string ReverseParentName(string Name)
{
	local int idx, Count;
	local string NewName;
	local array<string> NameList;

	if((Len(Name) < 1))
	{
		return "";
	}
	Count = Split(Name, ".", NameList);
	idx = (Count - 1);
	while((idx >= 0))
	{
		if((Len(NewName) > 0))
		{
			NewName = (NewName $ ".");
		}
		NewName = (NewName $ NameList[idx]);
		idx--;
	}
	return NewName;
}

function WindowHandle FindWindowHandle(string a_FullName)
{
	local int idx, Count;
	local string NewName;
	local array<string> NameList;
	local WindowHandle ParentHandle, FindedHandle;

	NewName = a_FullName;
	Count = Split(a_FullName, ".", NameList);
	if((Count > 1))
	{
		NewName = "";
		idx = 1;
		while((idx < Count))
		{
			if((Len(NewName) > 0))
			{
				NewName = (NewName $ ".");
			}
			NewName = (NewName $ NameList[idx]);
			idx++;
		}
		ParentHandle = m_CurTopWnd;
		FindedHandle = FindHandle(NewName, ParentHandle);
	}
	else
	{
		FindedHandle = m_CurTopWnd;
	}
	return FindedHandle;
}

function SelectControl(string ControlName)
{
	local WindowHandle hWnd;

	if((Len(ControlName) < 1))
	{
		return;
	}
	hWnd = FindWindowHandle(ControlName);
	if((hWnd != none))
	{
		hWnd.SetFocus();
	}
	selectWnd = hWnd;
	if(hWnd.IsShowWindow())
	{
	}
	else
	{
		hWnd.ShowWindow();
	}
	return;
}

function SelectControlList(string FullName)
{
	local int idx;
	local WindowHandle hWnd;
	local RichListCtrlRowData rowData;

	if((Len(FullName) < 1))
	{
		return;
	}
	richListCurrentControl.GetRecordCount();
	idx = 0;
	while((idx < richListCurrentControl.GetRecordCount()))
	{
		richListCurrentControl.GetRec(idx, rowData);
		if((rowData.szReserved == FullName))
		{
			hWnd = FindWindowHandle(rowData.szReserved);
			if((hWnd != selectWnd))
			{
				selectWnd = hWnd;
				if((hWnd != none))
				{
					richListCurrentControl.SetSelectedIndex(idx, bCallfromEvent);
					txtPathStr.SetText(rowData.cellDataList[3].szData);
					bCallfromEvent = true;
				}
			}
			break;
		}
		idx++;
	}
	return;
}

function OnOrderClick(string Name)
{
	local WindowHandle TrackerWnd;

	TrackerWnd = GetTrackerAttachedWindow();
	if((TrackerWnd == none))
	{
		return;
	}
	switch(Name)
	{
		case "btnUp":
			TrackerWnd.ChangeControlOrder(COW_Up);
			break;
		case "btnDown":
			TrackerWnd.ChangeControlOrder(COW_Down);
			break;
		default:
			break;
	}
	RefreshControlList();
	return;
}

function UIEventManager.EXMLControlType GetCurrentControlType()
{
	return GetXMLControlIndex(GetCurrentControlTypeString());
}

function string GetCurrentControlTypeString()
{
	return lstControls.GetSelectedString();
}

function HandleFind()
{
	local int i, Cnt;
	local RichListCtrlRowData rowData;

	Cnt = richListCurrentControl.GetRecordCount();
	i = (lastFindIndex + 1);
	while((i < Cnt))
	{
		richListCurrentControl.GetRec(i, rowData);
		if((FindMatchString(rowData.cellDataList[1].szReserved, GetEditBoxHandle("FindBox").GetString()) != -1))
		{
			richListCurrentControl.SetSelectedIndex(i, true);
			lastFindIndex = i;
			OnClickListCtrlRecord("richListCurrentControl");
			return;
		}
		i++;
	}
	lastFindIndex = 0;
	return;
}

function int FindMatchString(string targetString, string toFindString)
{
	local string delim;

	if((toFindString == ""))
	{
		return 1;
	}
	delim = " ";
	if(StringMatching(targetString, toFindString, delim))
	{
		return 1;
	}
	else
	{
		return -1;
	}
	return 1;
}

function int GetTrackerIndex(WindowHandle TrackerWnd)
{
	local int i;

	i = 0;
	while((i < attachedWindows.Length))
	{
		if((attachedWindows[i].topWnd == TrackerWnd))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function bool IsHiddenWindow(string wndname)
{
	return (GetHiddenWndIndex(wndname) != -1);
}

function int GetHiddenWndIndex(string wndname)
{
	local int i;
	local windowInfos wndInfo;

	wndInfo = windowInfosCur();
	i = 0;
	while((i < wndInfo.hiddenList.Length))
	{
		if((wndInfo.hiddenList[i] == wndname))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function bool IsFoldedWindow(string wndname)
{
	return (GetfoldedWndIndex(wndname) != -1);
}

function int GetfoldedWndIndex(string wndname)
{
	local int i;
	local windowInfos wndInfo;

	wndInfo = windowInfosCur();
	i = 0;
	while((i < wndInfo.foldedList.Length))
	{
		if((wndInfo.foldedList[i] == wndname))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function AddWindowInfo(WindowHandle topWnd)
{
	local windowInfos wndInfo;

	wndInfo.topWnd = topWnd;
	attachedWindows[attachedWindows.Length] = wndInfo;
	return;
}

function AddControl(WindowHandle targetHandle, int X, int Y)
{
	local WindowHandle ParentHandle, TargetWndHandle, NewWnd;
	local string strTarget;
	local UIEventManager.EXMLControlType Type;

	if((targetHandle == none))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, "No Selected Control.");
		return;
	}
	TargetWndHandle = targetHandle;
	strTarget = targetHandle.GetWindowName();
	Type = GetCurrentControlType();
	if(!TargetWndHandle.IsControlContainer())
	{
		ParentHandle = TargetWndHandle.GetParentWindowHandle();
		while((ParentHandle != none))
		{
			if(ParentHandle.IsControlContainer())
			{
				break;
			}
			ParentHandle = ParentHandle.GetParentWindowHandle();
		}
		TargetWndHandle = ParentHandle;
	}
	if((TargetWndHandle == none))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, (("Can't Select Control to " $ strTarget) $ "."));
		return;
	}
	if((strTarget == "Worksheet"))
	{
		if(((int(Type) != 1) && (int(Type) != 30)))
		{
			DialogShow(DialogModalType_Modalless, DialogType_OK, "Please Drop Container Control First! (Window, ScrollArea..)");
			return;
		}
	}
	UpdateControlList();
	NewWnd = TargetWndHandle.AddChildWnd(Type);
	if((NewWnd != none))
	{
		SetDefaultValue(NewWnd, Type, strTarget, X, Y);
	}
	return;
}

function SetDefaultValue(WindowHandle NewWnd, UIEventManager.EXMLControlType Type, string strTarget, int X, int Y)
{
	local int DefaultWidth, DEFAULTHEIGHT;
	local ButtonHandle hButton;
	local TextBoxHandle hTextBox;
	local TextureHandle hTexture;
	local BarHandle hBar;

	DefaultWidth = 50;
	DEFAULTHEIGHT = 50;
	NewWnd.SetEditable(true);
	switch(Type)
	{
		case XCT_FrameWnd:
			if((strTarget == "Worksheet"))
			{
				DefaultWidth = 256;
				DEFAULTHEIGHT = 256;
				NewWnd.SetBackTexture("Default.BlackTexture");
				NewWnd.SetXMLDocumentInfo("Created By L2UIEditor Ver1.0", "http://www.lineage2.co.kr/ui", "http://www.w3.org/2001/XMLSchema-instance", "http://www.lineage2.co.kr/ui ..\\..\\..\\Schema.xsd");
			}
			else
			{
				DefaultWidth = 50;
				DEFAULTHEIGHT = 50;
			}
			break;
		case XCT_Button:
			DefaultWidth = 76;
			DEFAULTHEIGHT = 23;
			hButton = ButtonHandle(NewWnd);
			hButton.SetTexture("L2UI_ct1.Button.Button_DF", "L2UI_ct1.Button.Button_DF_Click", "L2UI_ct1.Button.Button_DF_Over");
			break;
		case XCT_TextBox:
			DefaultWidth = 100;
			DEFAULTHEIGHT = 12;
			hTextBox = TextBoxHandle(NewWnd);
			hTextBox.SetText(hTextBox.GetWindowName());
			break;
		case XCT_EditBox:
			DefaultWidth = 50;
			DEFAULTHEIGHT = 17;
			break;
		case XCT_TextureCtrl:
			hTexture = TextureHandle(NewWnd);
			hTexture.SetTexture("Default.WhiteTexture");
			break;
		case XCT_ChatListBox:
			break;
		case XCT_TabControl:
			break;
		case XCT_ItemWnd:
			break;
		case XCT_CheckBox:
			DefaultWidth = 80;
			DEFAULTHEIGHT = 12;
			break;
		case XCT_ComboBox:
			DefaultWidth = 50;
			DEFAULTHEIGHT = 19;
			break;
		case XCT_ProgressCtrl:
			break;
		case XCT_MultiEdit:
			DefaultWidth = 50;
			DEFAULTHEIGHT = 50;
			break;
		case XCT_ListCtrl:
			break;
		case XCT_ListBox:
			break;
		case XCT_StatusBarCtrl:
			DefaultWidth = 50;
			DEFAULTHEIGHT = 12;
			break;
		case XCT_NameCtrl:
			DefaultWidth = 50;
			DEFAULTHEIGHT = 12;
			break;
		case XCT_MinimapWnd:
			break;
		case XCT_ShortcutItemWnd:
			break;
		case XCT_XMLTreeCtrl:
			break;
		case XCT_SliderCtrl:
			break;
		case XCT_EffectButton:
			break;
		case XCT_TextListBox:
			break;
		case XCT_RadarWnd:
			break;
		case XCT_HtmlViewer:
			break;
		case XCT_RadioButton:
			DefaultWidth = 80;
			DEFAULTHEIGHT = 12;
			break;
		case XCT_InvenWeightWnd:
			break;
		case XCT_StatusIconCtrl:
			break;
		case XCT_BarCtrl:
			DefaultWidth = 50;
			DEFAULTHEIGHT = 6;
			hBar = BarHandle(NewWnd);
			hBar.SetValue(100, 25);
			break;
		case XCT_ScrollWnd:
			break;
		case XCT_FishViewportWnd:
			break;
		case XCT_VIPShopItemInfoWnd:
			break;
		case XCT_VIPShopNeededItemWnd:
			break;
		case XCT_DrawPanel:
			break;
		default:
			break;
	}
	NewWnd.SetWindowSize(DefaultWidth, DEFAULTHEIGHT);
	NewWnd.SetFocus();
	return;
}

function windowInfos windowInfosCur()
{
	return attachedWindows[windowInfosCurrentIndex];
}

function string GetfullName(WindowHandle hWnd)
{
	local UIEventManager.EXMLControlType Type;
	local string FullName, parentname;
	local WindowHandle hParent;

	if((hWnd == none))
	{
		return FullName;
	}
	FullName = hWnd.GetWindowName();
	hParent = hWnd.GetParentWindowHandle();
	while((hParent != none))
	{
		parentname = hParent.GetWindowName();
		if(((parentname == "Console") || (parentname == "Worksheet")))
		{
			return FullName;
		}
		Type = hParent.GetControlType();
		if(((int(Type) != 0) && (Len(parentname) > 0)))
		{
			FullName = ((parentname $ ".") $ FullName);
		}
		hParent = hParent.GetParentWindowHandle();
	}
	return FullName;
}

function Color ColorByType(string Type, bool isHidden)
{
	if(isHidden)
	{
		return getInstanceL2Util().DarkGray;
	}
	switch(Type)
	{
		case "Window":
			return getInstanceL2Util().DRed;
		case "Button":
			return getInstanceL2Util().Gold;
		case "Texture":
			return getInstanceL2Util().ColorGray;
		default:
			return getInstanceL2Util().White;
	}
}

function string GetDepthString(int depth)
{
	return "";
	switch(depth)
	{
		case 0:
			return "";
		case 1:
			return "¹";
		case 2:
			return "₂";
		case 3:
			return "³";
		case 4:
			return "₄";
		case 5:
			return "ⁿ";
		default:
			return "ⁿ";
	}
}

function SetListColorRowData(out RichListCtrlRowData rowData, Color sColor)
{
	rowData.cellDataList[1].drawitems[0].strInfo.strColor = sColor;
	rowData.cellDataList[2].drawitems[0].strInfo.strColor = sColor;
	rowData.cellDataList[3].drawitems[0].strInfo.strColor = sColor;
	return;
}

function array<WindowHandle> GetChildWindowListUtil(WindowHandle hWnd)
{
	local array<WindowHandle> ChildList;

	switch(hWnd.GetControlType())
	{
		case XCT_TabControl:
		case XCT_ListBox:
			break;
		default:
			hWnd.GetChildWindowList(ChildList);
			break;
	}
	return ChildList;
}

function SetChildListDepth(WindowHandle hWnd)
{
	local int i;
	local array<WindowHandle> childListBack, ChildList, childListTop, childes;

	childes = GetChildWindowListUtil(hWnd);
	i = 0;
	while((i < childes.Length))
	{
		if(childes[i].IsAlwaysOnBack())
		{
			childListBack[childListBack.Length] = childes[i];
			i++;
			continue;
		}
		if(childes[i].IsAlwaysOnTop())
		{
			childListTop[childListTop.Length] = childes[i];
			i++;
			continue;
		}
		ChildList[ChildList.Length] = childes[i];
		i++;
	}
	i = (childListBack.Length - 1);
	while((i >= 0))
	{
		childListBack[i].BringToFront();
		i--;
	}
	i = (ChildList.Length - 1);
	while((i >= 0))
	{
		ChildList[i].BringToFront();
		i--;
	}
	i = 0;
	while((i < childListTop.Length))
	{
		childListTop[i].BringToFront();
		i++;
	}
	i = 0;
	while((i < childes.Length))
	{
		SetChildListDepth(childes[i]);
		i++;
	}
	return;
}

function string MakeHelpString()
{
	local string help, breakLine;

	breakLine = "\\n·";
	help = "※단축키";  // EN?: Keyboard shortcut
	help = ((help $ breakLine) $ "ENTER : 선택");  // EN?: Enter: Optional
	help = ((help $ breakLine) $ "더블클릭 : 숨기기/켜기");  // EN?: Double-click: hide/turn on
	help = ((help $ breakLine) $ "↑ : 위 선택");  // EN?: ↑ : select above
	help = ((help $ breakLine) $ "↓ : 아래 선택");  // EN?: ↓ : select below
	help = ((help $ breakLine) $ "→ : 숨기기/켜기");  // EN?: → : hide/turn on
	help = ((help $ breakLine) $ "← : 폴더접고 펴기");  // EN?: ← : Folding and unfolding folders
	help = ((help $ breakLine) $ "+, - 버튼 클릭 : 폴더접고 펴기");  // EN?: Click the +, - buttons: fold and unfold
	help = ((help $ breakLine) $ "DELETE : 삭제");  // EN?:         Delete        : '<g id="1">Delete</g>',
	return help;
}

function HandleOnClickContextMenu(int Index)
{
	local int i;

	switch(Index)
	{
		case 0:
			SetShowHideSelectedList();
			break;
		case 1:
			FoldRecord();
			break;
		case 2:
			i = 0;
			while((i < attachedWindows[windowInfosCurrentIndex].hiddenList.Length))
			{
				FindWindowHandle(attachedWindows[windowInfosCurrentIndex].hiddenList[i]).EnterState();
				i++;
			}
			attachedWindows[windowInfosCurrentIndex].hiddenList.Length = 0;
			RefreshControlList();
			break;
		case 3:
			break;
		case 4:
			break;
		case 5:
			attachedWindows[windowInfosCurrentIndex].foldedList.Length = 0;
			RefreshControlList();
			break;
		case 999:
			DialogShow(DialogModalType_Modalless, DialogType_OK, MakeHelpString(), m_hOwnerWnd);
			break;
		default:
			break;
	}
	return;
}

function ShowContextMenu(int X, int Y)
{
	local int idx;
	local RichListCtrlRowData rowData;
	local UIControlContextMenu ContextMenu;

	idx = richListCurrentControl.GetSelectedIndex();
	richListCurrentControl.GetRec(idx, rowData);
	ContextMenu = Class'Interface.UIControlContextMenu'.static.GetInstance();
	ContextMenu.Clear();
	ContextMenu.DelegateOnClickContextMenu = HandleOnClickContextMenu;
	if((GetHiddenWndIndex(rowData.szReserved) > -1))
	{
		ContextMenu.MenuNew("보이기", 0);  // EN?: Display
	}
	else
	{
		ContextMenu.MenuNew("숨기기", 0);  // EN?: hide
	}
	if((rowData.cellDataList[0].nReserved1 > 0))
	{
		if((GetfoldedWndIndex(rowData.szReserved) > -1))
		{
			ContextMenu.MenuNew("+ 펴기", 1);  // EN?: + Expand
		}
		else
		{
			ContextMenu.MenuNew("- 접기", 1);  // EN?: Collapse
		}
	}
	ContextMenu.MenuLineAdd();
	ContextMenu.MenuNew("모두 보이기", 2);  // EN?: Show all
	ContextMenu.MenuNew("+ 모두 펴기", 5);  // EN?: Expand All
	ContextMenu.MenuNew("※단축키", 999, getInstanceL2Util().ColorGray);  // EN?: Keyboard shortcut
	ContextMenu.Show((X + 1), (Y + 1), string(self));
	return;
}
