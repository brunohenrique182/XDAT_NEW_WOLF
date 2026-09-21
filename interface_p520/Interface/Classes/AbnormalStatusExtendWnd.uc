class AbnormalStatusExtendWnd extends UICommonAPI;

var WindowHandle Me;
var StatusIconHandle StatusIcon;
var TextBoxHandle Count_txt;
var ButtonHandle DragBtn;
var int NSTATUSICON_MAXCOL;
var int m_EtcStatusRow;
var int m_ShortStatusRow;
var string m_Windowname;
var int bClose;
var bool m_bOnCurState;
var Rect rectWndLDowned;

function OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEvent(40);
	RegisterEvent(3410);
	return;
}

function OnEvent(int Event_ID, string param)
{
	if(getInstanceUIData().GetIsLiveServer())
	{
		return;
	}
	switch(Event_ID)
	{
		case 40:
			StatusIcon.Clear();
			break;
		case 9750:
			break;
		case 3410:
			HnadleStateChanged();
			break;
		default:
			break;
	}
	return;
}

function OnShow()
{
	if(getInstanceUIData().GetIsLiveServer())
	{
		Me.HideWindow();
		return;
	}
	closeStatus(bClose);
	return;
}

function OnLoad()
{
	InitHandle();
	if(!GetINIInt(m_Windowname, "e", bClose, "WindowsInfo.ini"))
	{
		bClose = 0;
	}
	return;
}

function InitHandle()
{
	NSTATUSICON_MAXCOL = 24;
	Me = GetWindowHandle("AbnormalStatusExtendWnd");
	StatusIcon = GetStatusIconHandle("AbnormalStatusExtendWnd.StatusIcon");
	Count_txt = GetTextBoxHandle("AbnormalStatusExtendWnd.Count_txt");
	DragBtn = GetButtonHandle("AbnormalStatusExtendWnd.DragBtn");
	Count_txt.SetText("0");
	return;
}

function OnClickButton(string Name)
{
	if(CheckDrag())
	{
		return;
	}
	switch(Name)
	{
		case "DragBtn":
			if(StatusIcon.IsShowWindow())
			{
				bClose = 1;
				SetINIInt(m_Windowname, "e", bClose, "WindowsInfo.ini");
				closeStatus(bClose);
			}
			else
			{
				bClose = 0;
				SetINIInt(m_Windowname, "e", bClose, "WindowsInfo.ini");
				closeStatus(bClose);
			}
			break;
		default:
			break;
	}
	return;
}

function closeStatus(int i)
{
	if((i == 0))
	{
		StatusIcon.ShowWindow();
		DragBtn.SetTexture("L2UI_NewTex.BuffWnd.BuffExpand_Normal", "L2UI_NewTex.BuffWnd.BuffExpand_Over", "L2UI_NewTex.BuffWnd.BuffExpand_Down");
	}
	else
	{
		StatusIcon.HideWindow();
		DragBtn.SetTexture("L2UI_NewTex.BuffWnd.BuffMin_Normal", "L2UI_NewTex.BuffWnd.BuffMin_Over", "L2UI_NewTex.BuffWnd.BuffMin_Down");
	}
	return;
}

function OnClickItem(string strID, int Index)
{
	local int Row, Col;
	local StatusIconInfo Info;
	local SkillInfo SkillInfo;

	Col = (Index / 10);
	Row = (Index - (Col * 10));
	StatusIcon.GetItem(Row, Col, Info);
	if(!GetSkillInfo(Info.Id.ClassID, Info.Level, Info.SubLevel, SkillInfo))
	{
		return;
	}
	if((InStr(strID, "StatusIcon") > -1))
	{
		if(((SkillInfo.Debuff == 0) && (SkillInfo.OperateType == 1)))
		{
			RequestDispel(Info.ServerID, Info.Id, Info.Level, Info.SubLevel);
		}
		else
		{
			AddSystemMessage(2318);
		}
	}
	return;
}

function bool CheckDrag()
{
	local Rect rectWnd;

	rectWnd = Me.GetRect();
	return ((GetAbs((rectWndLDowned.nX - rectWnd.nX)) > 5) || (GetAbs((rectWndLDowned.nY - rectWnd.nY)) > 5));
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	rectWndLDowned = Me.GetRect();
	return;
}

function AddBuff(array<StatusIconInfo> arr)
{
	InsertBuffList(arr);
	UpdateWindowSize();
	return;
}

function bool InsertBuffList(array<StatusIconInfo> statusIconInfs)
{
	local int i, Count, rowcount;

	StatusIcon.Clear();
	StatusIcon.AddRow();
	StatusIcon.SetIconSize(26);
	Count = statusIconInfs.Length;
	if((Count > 0))
	{
		if((GetGameStateName() == "GAMINGSTATE"))
		{
			Me.ShowWindow();
		}
	}
	else
	{
		Me.HideWindow();
	}
	rowcount = 0;
	Count_txt.SetText(string(Count));
	i = 0;
	while((i < statusIconInfs.Length))
	{
		StatusIcon.AddCol(0, statusIconInfs[i]);
		i++;
	}
	return (statusIconInfs.Length > 0);
}

function UpdateWindowSize()
{
	local Rect rectWnd, rectBtn;

	rectWnd = StatusIcon.GetRect();
	rectBtn = DragBtn.GetRect();
	Me.SetWindowSize((rectWnd.nWidth + 45), rectBtn.nHeight);
	return;
}

function HnadleStateChanged()
{
	if((GetGameStateName() != "GAMINGSTATE"))
	{
		return;
	}
	if((StatusIcon.GetColCount(0) > 0))
	{
		Me.ShowWindow();
	}
	return;
}

function int GetAbs(int Num)
{
	if((Num < 0))
	{
		return -Num;
	}
	return Num;
}

defaultproperties
{
	m_Windowname="AbnormalStatusExtendWnd"
}
