class UISysMsgToolWnd extends UICommonAPI;

const ASK_SUMMON_NUMBER = 10000;

var WindowHandle Me;
var string m_Windowname;
var bool bShow;
var Color Gold;
var ListCtrlHandle m_hFindTreeList;
var EditBoxHandle m_hEditBox;
var ButtonHandle m_hBtnSummon;
var ButtonHandle b_btnInit;

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Me = GetWindowHandle("UISysMsgToolWnd");
	m_hFindTreeList = GetListCtrlHandle((m_Windowname $ ".ListFindWnd"));
	m_hEditBox = GetEditBoxHandle((m_Windowname $ ".EditBox"));
	m_hBtnSummon = GetButtonHandle((m_Windowname $ ".btnSummon"));
	b_btnInit = GetButtonHandle((m_Windowname $ ".btnInit"));
	m_hFindTreeList.SetSelectedSelTooltip(false);
	m_hFindTreeList.SetAppearTooltipAtMouseX(true);
	bShow = false;
	Gold.R = 176;
	Gold.G = 153;
	Gold.B = 121;
	GetEditBoxHandle((((m_Windowname $ ".param") $ "1") $ "EditBox")).SetString("a");
	GetEditBoxHandle((((m_Windowname $ ".param") $ "2") $ "EditBox")).SetString("b");
	GetEditBoxHandle((((m_Windowname $ ".param") $ "3") $ "EditBox")).SetString("c");
	GetEditBoxHandle((((m_Windowname $ ".param") $ "4") $ "EditBox")).SetString("d");
	GetEditBoxHandle((((m_Windowname $ ".param") $ "5") $ "EditBox")).SetString("e");
	return;
}

function OnShow()
{
	m_hEditBox.SetString("");
	m_hEditBox.SetFocus();
	HandleFind();
	return;
}

function ShowList(string a_Param)
{
	FindAllSystemMessage(a_Param);
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function FindAllSystemMessage(string a_Param)
{
	local int i;
	local string fullNameString;

	ClearList();
	i = 0;
	while((i <= 20000))
	{
		fullNameString = GetSystemMessage(i);
		if((fullNameString != ""))
		{
			if((InsertRecordFindTreeList(fullNameString, a_Param, i, "") >= 20000))
			{
				AddSystemMessage(3489);
				return;
			}
		}
		i++;
	}
	return;
}

function int InsertRecordFindTreeList(string fullNameString, string a_Param, int Id, string IconName)
{
	local string modifiedString, MsgType;
	local LVDataRecord Record;
	local SystemMsgData SysMsgData;

	Record.LVDataList.Length = 3;
	modifiedString = Substitute(fullNameString, " ", "", false);
	if((((FindMatchString(modifiedString, a_Param) != -1) || (a_Param == "")) || (a_Param == string(Id))))
	{
		Record.LVDataList[0].bUseTextColor = true;
		Record.LVDataList[0].TextColor = Gold;
		Record.LVDataList[0].szData = fullNameString;
		Record.LVDataList[1].szData = string(Id);
		Record.LVDataList[1].TextColor = Gold;
		Record.LVDataList[1].nReserved1 = Id;
		GetSystemMsgInfo(Record.LVDataList[1].nReserved1, SysMsgData);
		if((SysMsgData.OnScrMsg != ""))
		{
			MsgType = ("S" $ string(SysMsgData.WindowType));
		}
		if((SysMsgData.GFxScrMsg != ""))
		{
			MsgType = (MsgType $ "G");
		}
		Record.LVDataList[2].szData = MsgType;
		m_hFindTreeList.InsertRecord(Record);
		return m_hFindTreeList.GetRecordCount();
	}
}

function int FindMatchString(string modifiedString, string a_Param)
{
	local string delim;

	delim = " ";
	if(StringMatching(modifiedString, a_Param, delim))
	{
		return 1;
	}
	else
	{
		return -1;
	}
	return 1;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	Summon(INT64(1), 2);
	return;
}

function Summon(INT64 Cnt, int buttonType)
{
	local LVDataRecord Record;
	local string strParam;
	local SystemMsgData SysMsgData;

	Record.LVDataList.Length = 3;
	if(GetSelectedListCtrlItem(Record))
	{
		if((Record.LVDataList[1].szData != ""))
		{
			if((buttonType == 1))
			{
				AddSystemMessageString(MakeFullSystemMsg(Record.LVDataList[0].szData, GetEditBoxHandle((((m_Windowname $ ".param") $ "1") $ "EditBox")).GetString(), GetEditBoxHandle((((m_Windowname $ ".param") $ "2") $ "EditBox")).GetString(), GetEditBoxHandle((((m_Windowname $ ".param") $ "3") $ "EditBox")).GetString(), GetEditBoxHandle((((m_Windowname $ ".param") $ "4") $ "EditBox")).GetString(), GetEditBoxHandle((((m_Windowname $ ".param") $ "5") $ "EditBox")).GetString()));
				GetSystemMsgInfo(Record.LVDataList[1].nReserved1, SysMsgData);
				if((SysMsgData.OnScrMsg != ""))
				{
					ParamAdd(strParam, "MsgType", string(1));
					ParamAdd(strParam, "WindowType", string(SysMsgData.WindowType));
					ParamAdd(strParam, "FontType", string(SysMsgData.FontType));
					ParamAdd(strParam, "BackgroundType", string(SysMsgData.BackgroundType));
					ParamAdd(strParam, "LifeTime", string((SysMsgData.LifeTime * 1000)));
					ParamAdd(strParam, "AnimationType", string(SysMsgData.AnimationType));
					ParamAdd(strParam, "MsgColorR", string(SysMsgData.FontColor.R));
					ParamAdd(strParam, "MsgColorG", string(SysMsgData.FontColor.G));
					ParamAdd(strParam, "MsgColorB", string(SysMsgData.FontColor.B));
					ParamAdd(strParam, "Msg", MakeFullSystemMsg(SysMsgData.OnScrMsg, GetEditBoxHandle((((m_Windowname $ ".param") $ "1") $ "EditBox")).GetString(), GetEditBoxHandle((((m_Windowname $ ".param") $ "2") $ "EditBox")).GetString(), GetEditBoxHandle((((m_Windowname $ ".param") $ "3") $ "EditBox")).GetString(), GetEditBoxHandle((((m_Windowname $ ".param") $ "4") $ "EditBox")).GetString(), GetEditBoxHandle((((m_Windowname $ ".param") $ "5") $ "EditBox")).GetString()));
					ExecuteEvent(140, strParam);
					Debug(("strParam " @ strParam));
				}
				if((SysMsgData.GFxScrMsg != ""))
				{
					getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(SysMsgData.GFxScrMsg, GetEditBoxHandle((((m_Windowname $ ".param") $ "1") $ "EditBox")).GetString(), GetEditBoxHandle((((m_Windowname $ ".param") $ "2") $ "EditBox")).GetString(), GetEditBoxHandle((((m_Windowname $ ".param") $ "3") $ "EditBox")).GetString(), GetEditBoxHandle((((m_Windowname $ ".param") $ "4") $ "EditBox")).GetString(), GetEditBoxHandle((((m_Windowname $ ".param") $ "5") $ "EditBox")).GetString()));
				}
			}
			else
			{
				ExecuteCommand(("///sm m1 " $ string(Record.LVDataList[1].nReserved1)));
			}
		}
	}
	return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	local LVDataRecord Record;
	local int selectIndex;
	local SystemMsgData SysMsgData;

	m_hBtnSummon.EnableWindow();
	selectIndex = m_hFindTreeList.GetSelectedIndex();
	if((selectIndex >= 0))
	{
		m_hFindTreeList.GetSelectedRec(Record);
		GetSystemMsgInfo(Record.LVDataList[1].nReserved1, SysMsgData);
		GetEditBoxHandle((m_Windowname $ ".scrMsgEditBox")).SetString("");
		GetEditBoxHandle((m_Windowname $ ".gfxMsgEditBox")).SetString("");
		if((SysMsgData.OnScrMsg != ""))
		{
			GetEditBoxHandle((m_Windowname $ ".scrMsgEditBox")).SetString(SysMsgData.OnScrMsg);
		}
		if((SysMsgData.OnScrParam != ""))
		{
			GetEditBoxHandle((m_Windowname $ ".scrParamEditBox")).SetString(SysMsgData.OnScrParam);
		}
		if((SysMsgData.GFxScrMsg != ""))
		{
			GetEditBoxHandle((m_Windowname $ ".gfxMsgEditBox")).SetString(SysMsgData.GFxScrMsg);
		}
	}
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnSummon":
			Summon(INT64(1), 1);
			break;
		case "sysButton":
			Summon(INT64(1), 2);
			break;
		case "btnFind":
			HandleFind();
			break;
		case "btnInit":
			m_hEditBox.SetString("");
			GetEditBoxHandle((m_Windowname $ ".scrMsgEditBox")).SetString("");
			GetEditBoxHandle((m_Windowname $ ".gfxMsgEditBox")).SetString("");
			GetEditBoxHandle((m_Windowname $ ".scrParamEditBox")).SetString("");
			GetEditBoxHandle((((m_Windowname $ ".param") $ "1") $ "EditBox")).SetString("");
			GetEditBoxHandle((((m_Windowname $ ".param") $ "2") $ "EditBox")).SetString("");
			GetEditBoxHandle((((m_Windowname $ ".param") $ "3") $ "EditBox")).SetString("");
			GetEditBoxHandle((((m_Windowname $ ".param") $ "4") $ "EditBox")).SetString("");
			GetEditBoxHandle((((m_Windowname $ ".param") $ "5") $ "EditBox")).SetString("");
			break;
		default:
			break;
	}
	return;
}

function HandleFind()
{
	local string EditBoxString;

	EditBoxString = m_hEditBox.GetString();
	ShowList(EditBoxString);
	return;
}

function bool GetSelectedListCtrlItem(out LVDataRecord Record)
{
	local int Index;

	Index = m_hFindTreeList.GetSelectedIndex();
	if((Index >= 0))
	{
		m_hFindTreeList.GetRec(Index, Record);
		return true;
	}
	return false;
}

function ClearList()
{
	m_hFindTreeList.DeleteAllItem();
	m_hFindTreeList.ClearTooltip();
	m_hFindTreeList.SetTooltipType("");
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	if(m_hEditBox.IsFocused())
	{
		if((int(nKey) == 13))
		{
			if((trim(m_hEditBox.GetString()) != ""))
			{
				HandleFind();
			}
		}
	}
	return false;
}

defaultproperties
{
	m_Windowname="UISysMsgToolWnd"
}
