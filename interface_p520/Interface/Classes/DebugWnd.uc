class DebugWnd extends UICommonAPI;

var WindowHandle Me;
var TabHandle MainTab;
var ListCtrlHandle itemListCtrl0;
var ListCtrlHandle itemListCtrl1;
var ListCtrlHandle itemListCtrl2;
var ListCtrlHandle itemListCtrl3;
var ListCtrlHandle itemListCtrl4;
var ListCtrlHandle itemListCtrl5;
var WindowHandle AllWnd;
var WindowHandle WarningWnd;
var WindowHandle ErrorWnd;
var WindowHandle ScriptWnd;
var WindowHandle GfxWnd;
var WindowHandle CustomWnd;
var CheckBoxHandle autoOpenCheckBox;
var CheckBoxHandle wCheckBox;
var CheckBoxHandle eCheckBox;
var CheckBoxHandle sCheckBox;
var CheckBoxHandle gCheckBox;
var CheckBoxHandle FilterCheckBox;
var ButtonHandle startToggleButton;
var ButtonHandle LineDnButton;
var EditBoxHandle filterEditBox;
var L2Util util;
var bool bUselastLineFocus;
var int nAutoOpen;
var int nTabIndex;
var bool nReloadOpen;
var int nW_Filter;
var int nE_Filter;
var int nS_Filter;
var int nG_Filter;
var int nF_Filter;
var HtmlHandle mTextParamHtmlCtrl;
var string mTextParamStr;
var array<string> filterArray;

function OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEvent(40);
	RegisterEvent(3410);
	RegisterEvent(9995);
	return;
}

function OnLoad()
{
	Initialize();
	Load();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("DebugWnd");
	MainTab = GetTabHandle("DebugWnd.MainTab");
	AllWnd = GetWindowHandle("DebugWnd.AllWnd");
	WarningWnd = GetWindowHandle("DebugWnd.WarningWnd");
	ErrorWnd = GetWindowHandle("DebugWnd.ErrorWnd");
	ScriptWnd = GetWindowHandle("DebugWnd.ScriptWnd");
	GfxWnd = GetWindowHandle("DebugWnd.GfxWnd");
	CustomWnd = GetWindowHandle("DebugWnd.CustomWnd");
	itemListCtrl0 = GetListCtrlHandle("DebugWnd.AllWnd.itemListCtrl0");
	itemListCtrl1 = GetListCtrlHandle("DebugWnd.WarningWnd.itemListCtrl1");
	itemListCtrl2 = GetListCtrlHandle("DebugWnd.ErrorWnd.itemListCtrl2");
	itemListCtrl3 = GetListCtrlHandle("DebugWnd.ScriptWnd.itemListCtrl3");
	itemListCtrl4 = GetListCtrlHandle("DebugWnd.GfxWnd.itemListCtrl4");
	itemListCtrl5 = GetListCtrlHandle("DebugWnd.CustomWnd.itemListCtrl5");
	autoOpenCheckBox = GetCheckBoxHandle("DebugWnd.autoOpenCheckBox");
	wCheckBox = GetCheckBoxHandle("DebugWnd.wCheckBox");
	eCheckBox = GetCheckBoxHandle("DebugWnd.eCheckBox");
	sCheckBox = GetCheckBoxHandle("DebugWnd.sCheckBox");
	gCheckBox = GetCheckBoxHandle("DebugWnd.gCheckBox");
	FilterCheckBox = GetCheckBoxHandle("DebugWnd.FilterCheckBox");
	startToggleButton = GetButtonHandle("DebugWnd.startToggleButton");
	mTextParamHtmlCtrl = GetHtmlHandle("DebugWnd.TextParamHtmlCtrl");
	filterEditBox = GetEditBoxHandle("DebugWnd.filterEditBox");
	nAutoOpen = -9999;
	checkBoxFilterShow(false);
	setWindowTitleByString("UITools - UDebug");
	util = L2Util(GetScript("L2Util"));
	mTextParamStr = "";
	return;
}

function OnShow()
{
	setStartToggleButton(true);
	return;
}

function setStartToggleButton(bool bFlag)
{
	bUselastLineFocus = bFlag;
	if(bFlag)
	{
		startToggleButton.SetNameText("Stop");
		getCurrentListCtrlHandle().SetSelectedIndex((getCurrentListCtrlHandle().GetRecordCount() - 1), true);
	}
	else
	{
		startToggleButton.SetNameText("Start");
	}
	return;
}

function Load()
{
	return;
}

function OnClickListCtrlRecord(string strID)
{
	local LVDataRecord Record;

	if((getCurrentListCtrlHandle().GetSelectedIndex() != -1))
	{
		getCurrentListCtrlHandle().GetSelectedRec(Record);
		mTextParamHtmlCtrl.LoadHtmlFromString(htmlSetHtmlStart(Record.LVDataList[1].szReserved));
		mTextParamStr = Record.LVDataList[1].szReserved;
		getCurrentListCtrlHandle().SetFocus();
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "NetChatButton":
			ExecuteCommand("///netlog chat");
			break;
		case "reloadUIButton":
			ExecuteCommand("///rebuildui");
			break;
		case "startToggleButton":
			setStartToggleButton(!bUselastLineFocus);
			getCurrentListCtrlHandle().SetFocus();
			break;
		case "cmdToolButton":
			toggleWindow("UICommandWnd", true, false);
			break;
		case "gmButton":
			toggleWindow("GMWnd", true, false);
			break;
		case "debugButton":
			ExecuteCommand("///uidebug");
			break;
		case "ClearButton":
			getCurrentListCtrlHandle().DeleteAllItem();
			break;
		case "CopyButton":
			ClipboardCopy(mTextParamStr);
			break;
		case "ResetUIDataButton":
			getInstanceUIData().ResetUIData();
			break;
		case "LineDnButton":
			getCurrentListCtrlHandle().SetSelectedIndex((getCurrentListCtrlHandle().GetRecordCount() - 1), true);
			break;
		case "RestartButton":
			ExecRestart();
			break;
		case "TextFilterButton":
			break;
		default:
			if((Left(Name, 7) == "MainTab"))
			{
				if(bUselastLineFocus)
				{
					getCurrentListCtrlHandle().SetSelectedIndex((getCurrentListCtrlHandle().GetRecordCount() - 1), true);
				}
				if((Name == "MainTab5"))
				{
					checkBoxFilterShow(true);
				}
				else
				{
					checkBoxFilterShow(false);
				}
				nTabIndex = int(Right(Name, 1));
				SetINIInt("Debug", "tabIndex", nTabIndex, "UIDEV.ini");
				SaveINI("UIDEV.ini");
			}
	}
	return;
}

function checkBoxFilterShow(bool bShow)
{
	if(bShow)
	{
		wCheckBox.ShowWindow();
		eCheckBox.ShowWindow();
		sCheckBox.ShowWindow();
		gCheckBox.ShowWindow();
	}
	else
	{
		wCheckBox.HideWindow();
		eCheckBox.HideWindow();
		sCheckBox.HideWindow();
		gCheckBox.HideWindow();
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int nOpen;
	local string filterStr;

	if((Event_ID == 9995))
	{
		parseParamMsg(param);
	}
	else if((Event_ID == 9750))
	{
		if((nAutoOpen == -9999))
		{
			setStartToggleButton(true);
			GetINIInt("Debug", "autoOpen", nAutoOpen, "UIDEV.ini");
			GetINIInt("Debug", "w", nW_Filter, "UIDEV.ini");
			GetINIInt("Debug", "e", nE_Filter, "UIDEV.ini");
			GetINIInt("Debug", "s", nS_Filter, "UIDEV.ini");
			GetINIInt("Debug", "g", nG_Filter, "UIDEV.ini");
			GetINIString("Debug", "filter", filterStr, "UIDEV.ini");
			filterEditBox.SetString(filterStr);
			sliceFilterText();
			if((nAutoOpen == 1))
			{
				Me.ShowWindow();
				autoOpenCheckBox.SetCheck(true);
			}
			else
			{
				autoOpenCheckBox.SetCheck(false);
			}
			GetINIInt("Debug", "tabIndex", nTabIndex, "UIDEV.ini");
			MainTab.SetTopOrder(nTabIndex, false);
		}
	}
	else if((Event_ID == 3410))
	{
		if((int(GetReleaseMode()) != 0))
		{
			return;
		}
		if((param == "GAMINGSTATE"))
		{
			GetINIInt("Debug", "autoOpen", nOpen, "UIDEV.ini");
			if((nOpen == 1))
			{
				Me.ShowWindow();
				autoOpenCheckBox.SetCheck(true);
				GetINIInt("Debug", "w", nW_Filter, "UIDEV.ini");
				GetINIInt("Debug", "e", nE_Filter, "UIDEV.ini");
				GetINIInt("Debug", "s", nS_Filter, "UIDEV.ini");
				GetINIInt("Debug", "g", nG_Filter, "UIDEV.ini");
				wCheckBox.SetCheck(numToBool(nW_Filter));
				eCheckBox.SetCheck(numToBool(nE_Filter));
				sCheckBox.SetCheck(numToBool(nS_Filter));
				gCheckBox.SetCheck(numToBool(nG_Filter));
				GetINIString("Debug", "filter", filterStr, "UIDEV.ini");
				filterEditBox.SetString(filterStr);
				sliceFilterText();
				GetINIInt("Debug", "Usefilter", nF_Filter, "UIDEV.ini");
				FilterCheckBox.SetCheck(numToBool(nF_Filter));
				GetINIInt("Debug", "tabIndex", nTabIndex, "UIDEV.ini");
				MainTab.SetTopOrder(nTabIndex, false);
				setStartToggleButton(true);
			}
			else
			{
				autoOpenCheckBox.SetCheck(false);
			}
		}
	}
	else if((Event_ID == 40))
	{
		nReloadOpen = false;
		nAutoOpen = -9999;
	}
	return;
}

function parseParamMsg(string param)
{
	local int nDebugMsgType, i;
	local string debugMsg;

	ParseInt(param, "Type", nDebugMsgType);
	i = InStr(param, "Msg=");
	if((i > -1))
	{
		debugMsg = Mid(param, (i + 4), (Len(param) - 1));
		AddList(nDebugMsgType, trimParam(debugMsg));
	}
	return;
}

function AddList(int nDebugMsgType, string debugMsg)
{
	local LVDataRecord Record;
	local string viewStr, szStr, callerWindowName, strData;
	local ListCtrlHandle itemListCtrl;
	local array<string> arrSplit;
	local bool bAddCustom;
	local int i;
	local bool bFilterColor;

	strData = debugMsg;
	debugMsg = deleteEnter(debugMsg);
	if(FilterCheckBox.IsChecked())
	{
		i = 0;
		while((i < filterArray.Length))
		{
			if((InStr(ToLower(debugMsg), ToLower(filterArray[i])) != -1))
			{
				bFilterColor = true;
				break;
			}
			i++;
		}
	}
	Split(debugMsg, "|::::|", arrSplit);
	itemListCtrl = getCurrentListCtrlHandle();
	Record.LVDataList.Length = 2;
	Record.nReserved1 = INT64(nDebugMsgType);
	if((arrSplit.Length < 2))
	{
		viewStr = ((("(" $ GetTimeString()) $ ")") @ debugMsg);
	}
	else
	{
		callerWindowName = arrSplit[0];
		if((arrSplit.Length > 1))
		{
			viewStr = Right(arrSplit[1], ((Len(arrSplit[1]) + 1) - Len("|::::|")));
		}
		viewStr = ((("(" $ GetTimeString()) $ ")") @ viewStr);
	}
	szStr = viewStr;
	if((Len(viewStr) > 100))
	{
		viewStr = Mid(viewStr, 0, 99);
	}
	Record.LVDataList[0].szData = "";
	if(bFilterColor)
	{
		Record.LVDataList[0].bUseTextColor = true;
		Record.LVDataList[0].szData = "#";
		Record.LVDataList[0].TextColor = GetColor(255, 240, 0, 255);
	}
	Record.LVDataList[1].bUseTextColor = true;
	Record.LVDataList[1].szData = viewStr;
	Record.LVDataList[1].szReserved = strData;
	Record.LVDataList[1].textAlignment = TA_Left;
	Record.szReserved = callerWindowName;
	if((nDebugMsgType == 0))
	{
		Record.LVDataList[1].TextColor = GetColor(238, 170, 34, 255);
		bAddCustom = true;
	}
	else if(((nDebugMsgType == 2) || (nDebugMsgType == 5)))
	{
		if((nDebugMsgType == 5))
		{
			Record.LVDataList[1].TextColor = GetColor(255, 0, 255, 255);
		}
		else
		{
			Record.LVDataList[1].TextColor = GetColor(238, 111, 34, 255);
		}
		itemListCtrl1.InsertRecord(Record);
		if((nW_Filter > 0))
		{
			bAddCustom = true;
		}
	}
	else if((nDebugMsgType == 1))
	{
		Record.LVDataList[1].TextColor = GetColor(255, 0, 0, 255);
		itemListCtrl2.InsertRecord(Record);
		if((nE_Filter > 0))
		{
			bAddCustom = true;
		}
	}
	else if((nDebugMsgType == 3))
	{
		Record.LVDataList[1].TextColor = GetColor(222, 222, 222, 255);
		itemListCtrl3.InsertRecord(Record);
		if((nS_Filter > 0))
		{
			bAddCustom = true;
		}
	}
	else if((nDebugMsgType == 4))
	{
		Record.LVDataList[1].TextColor = GetColor(222, 172, 220, 255);
		Record.LVDataList[1].szData = (((("(" $ GetTimeString()) $ ")") @ "GFX") @ debugMsg);
		itemListCtrl4.InsertRecord(Record);
		if((nG_Filter > 0))
		{
			bAddCustom = true;
		}
	}
	itemListCtrl0.InsertRecord(Record);
	if(bAddCustom)
	{
		itemListCtrl5.InsertRecord(Record);
	}
	if(bUselastLineFocus)
	{
		if(((itemListCtrl.GetRecordCount() - 1) < (itemListCtrl.GetSelectedIndex() + 2)))
		{
			itemListCtrl.SetSelectedIndex((itemListCtrl.GetRecordCount() - 1), true);
		}
	}
	return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	setSymbolSelectedRecord();
	return;
}

function setSymbolSelectedRecord()
{
	local LVDataRecord Record;
	local ListCtrlHandle itemListCtrl;

	itemListCtrl = getCurrentListCtrlHandle();
	itemListCtrl.GetSelectedRec(Record);
	Record.LVDataList[0].bUseTextColor = true;
	if((Record.LVDataList[0].szData == "o"))
	{
		Record.LVDataList[0].TextColor = util.Yellow;
		Record.LVDataList[0].szData = "*";
	}
	else if((Record.LVDataList[0].szData == "*"))
	{
		Record.LVDataList[0].szData = "";
	}
	else
	{
		Record.LVDataList[0].TextColor = util.DRed;
		Record.LVDataList[0].szData = "o";
	}
	itemListCtrl.ModifyRecord(itemListCtrl.GetSelectedIndex(), Record);
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	local LVDataRecord Record;
	local ListCtrlHandle itemListCtrl;
	local string copyStr;

	itemListCtrl = getCurrentListCtrlHandle();
	if((Class'NWindow.InputAPI'.static.IsCtrlPressed() && (Class'NWindow.InputAPI'.static.GetKeyString(nKey) == "C")))
	{
		if(itemListCtrl.IsFocused())
		{
			itemListCtrl.GetSelectedRec(Record);
			if((Len(Record.LVDataList[1].szReserved) > 10))
			{
				copyStr = Right(Record.LVDataList[1].szReserved, (Len(Record.LVDataList[1].szReserved) - 11));
			}
			else
			{
				copyStr = Record.LVDataList[1].szReserved;
			}
			if((copyStr == ""))
			{
			}
			else
			{
				ClipboardCopy(copyStr);
			}
		}
	}
	else if(Class'NWindow.InputAPI'.static.IsAltPressed())
	{
		setStartToggleButton(true);
	}
	return false;
}

function OnClickCheckBox(string strID)
{
	switch(strID)
	{
		case "autoOpenCheckBox":
			OnAutoOpenCheckBoxBtnClick();
			break;
		case "wCheckBox":
			SetINIInt("Debug", "w", boolToNum(wCheckBox.IsChecked()), "UIDEV.ini");
			SaveINI("UIDEV.ini");
			nW_Filter = boolToNum(wCheckBox.IsChecked());
			break;
		case "eCheckBox":
			SetINIInt("Debug", "e", boolToNum(eCheckBox.IsChecked()), "UIDEV.ini");
			SaveINI("UIDEV.ini");
			nE_Filter = boolToNum(eCheckBox.IsChecked());
			break;
		case "sCheckBox":
			SetINIInt("Debug", "s", boolToNum(sCheckBox.IsChecked()), "UIDEV.ini");
			SaveINI("UIDEV.ini");
			nS_Filter = boolToNum(sCheckBox.IsChecked());
			break;
		case "gCheckBox":
			SetINIInt("Debug", "g", boolToNum(gCheckBox.IsChecked()), "UIDEV.ini");
			SaveINI("UIDEV.ini");
			nG_Filter = boolToNum(gCheckBox.IsChecked());
			break;
		case "FilterCheckBox":
			SetINIInt("Debug", "Usefilter", boolToNum(FilterCheckBox.IsChecked()), "UIDEV.ini");
			SaveINI("UIDEV.ini");
			nF_Filter = boolToNum(FilterCheckBox.IsChecked());
			break;
		default:
			break;
	}
	return;
}

function onFilterCheckboxClick(string strID)
{
	return;
}

function OnAutoOpenCheckBoxBtnClick()
{
	SetINIInt("Debug", "autoOpen", boolToNum(autoOpenCheckBox.IsChecked()), "UIDEV.ini");
	SaveINI("UIDEV.ini");
	return;
}

function ListCtrlHandle getCurrentListCtrlHandle()
{
	switch(MainTab.GetTopIndex())
	{
		case 1:
			return itemListCtrl1;
		case 2:
			return itemListCtrl2;
		case 3:
			return itemListCtrl3;
		case 4:
			return itemListCtrl4;
		case 5:
			return itemListCtrl5;
		default:
			return itemListCtrl0;
	}
}

function OnCompleteEditBox(string strID)
{
	if((strID == "filterEditBox"))
	{
		sliceFilterText();
		SetINIString("Debug", "filter", filterEditBox.GetString(), "UIDEV.ini");
		SaveINI("UIDEV.ini");
	}
	return;
}

function OnChangeEditBox(string strID)
{
	if((strID == "filterEditBox"))
	{
		if((filterEditBox.GetString() == ""))
		{
			sliceFilterText();
			SetINIString("Debug", "filter", filterEditBox.GetString(), "UIDEV.ini");
			SaveINI("UIDEV.ini");
		}
	}
	return;
}

function sliceFilterText()
{
	filterArray.Length = 0;
	if((filterEditBox.GetString() != ""))
	{
		Split(filterEditBox.GetString(), "/", filterArray);
	}
	return;
}
