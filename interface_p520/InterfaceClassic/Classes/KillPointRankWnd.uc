class KillPointRankWnd extends UIScript;

struct KillPointWndData
{
	var string Name;
	var int KillPoint;
};

var KillPointWndData m_KillPointData[25];
var WindowHandle Me;
var TextBoxHandle TopRatedPCName;
var TextBoxHandle TopRatedKillPC;
var ListCtrlHandle RankingListLeft;
var ListCtrlHandle RankingListRight;
var NameCtrlHandle NameCtrl;
var int m_Count;

function OnRegisterEvent()
{
	RegisterEvent(3470);
	RegisterEvent(3480);
	RegisterEvent(3490);
	RegisterEvent(3500);
	RegisterEvent(3501);
	return;
}

function OnLoad()
{
	if((1 == 0))
	{
		Me = GetHandle("KillPointRankWnd");
		TopRatedPCName = TextBoxHandle(GetHandle("KillPointRankWnd.TopRatedPCName"));
		TopRatedKillPC = TextBoxHandle(GetHandle("KillPointRankWnd.TopRatedKillPC"));
		RankingListLeft = ListCtrlHandle(GetHandle("KillPointRankWnd.RankingListLeft"));
		RankingListRight = ListCtrlHandle(GetHandle("KillPointRankWnd.RankingListRight"));
		NameCtrl = NameCtrlHandle(GetHandle("StatusWnd.UserName"));
	}
	else
	{
		Me = GetWindowHandle("KillPointRankWnd");
		TopRatedPCName = GetTextBoxHandle("KillPointRankWnd.TopRatedPCName");
		TopRatedKillPC = GetTextBoxHandle("KillPointRankWnd.TopRatedKillPC");
		RankingListLeft = GetListCtrlHandle("KillPointRankWnd.RankingListLeft");
		RankingListRight = GetListCtrlHandle("KillPointRankWnd.RankingListRight");
		NameCtrl = GetNameCtrlHandle("StatusWnd.UserName");
	}
	return;
}

function OnShow()
{
	RequestStartShowCrataeCubeRank();
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int statusInt;
	local string Name;
	local int KillPoint;

	Debug(("Event_ID" @ string(Event_ID)));
	switch(Event_ID)
	{
		case 3500:
			if(!Me.IsShowWindow())
			{
			}
			break;
		case 3480:
			Debug(("update list" @ param));
			ParseString(param, "Name", Name);
			ParseInt(param, "KillPoint", KillPoint);
			m_KillPointData[m_Count].Name = Name;
			m_KillPointData[m_Count].KillPoint = KillPoint;
			m_Count++;
			break;
		case 3470:
			Debug(("EV_CrataeCubeRecordItem" @ param));
			ParseInt(param, "Status", statusInt);
			m_Count = 0;
			Debug("update start");
			switch(statusInt)
			{
				case 0:
					Me.ShowWindow();
					break;
				case 1:
					m_Count = 0;
					Debug("update start");
					break;
				case 2:
					Me.ShowWindow();
					break;
				default:
					break;
			}
			break;
		case 3490:
			InsertKillPoint();
			break;
		case 3501:
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string Name)
{
	if((Name == "btnClose"))
	{
		Me.HideWindow();
	}
	return;
}

function OnHide()
{
	RequestStopShowCrataeCubeRank();
	return;
}

function InsertKillPoint()
{
	local int i;
	local LVDataRecord Record;
	local LVData data1, data2, data3;

	RankingListLeft.DeleteAllItem();
	RankingListRight.DeleteAllItem();
	TopRatedPCName.SetText(((("1" @ GetSystemString(1375)) @ " ") @ m_KillPointData[0].Name));
	TopRatedKillPC.SetText(("Kill Point : " @ string(m_KillPointData[0].KillPoint)));
	i = 1;
	while((i < 13))
	{
		data1.szData = string((i + 1));
		data2.szData = m_KillPointData[i].Name;
		if(((m_KillPointData[i].KillPoint < 9999) && (m_KillPointData[i].Name != "")))
		{
			data3.szData = string(m_KillPointData[i].KillPoint);
		}
		else
		{
			data3.szData = "";
		}
		Record.LVDataList[0] = data1;
		Record.LVDataList[1] = data2;
		Record.LVDataList[2] = data3;
		RankingListLeft.InsertRecord(Record);
		if((m_KillPointData[i].Name == NameCtrl.GetName()))
		{
			RankingListLeft.SetSelectedIndex((i - 1), true);
		}
		i++;
	}
	i = 13;
	while((i < 25))
	{
		data1.szData = string((i + 1));
		data2.szData = m_KillPointData[i].Name;
		if(((m_KillPointData[i].KillPoint < 9999) && (m_KillPointData[i].Name != "")))
		{
			data3.szData = string(m_KillPointData[i].KillPoint);
		}
		else
		{
			data3.szData = "";
		}
		Record.LVDataList[0] = data1;
		Record.LVDataList[1] = data2;
		Record.LVDataList[2] = data3;
		RankingListRight.InsertRecord(Record);
		if((m_KillPointData[i].Name == NameCtrl.GetName()))
		{
			RankingListRight.SetSelectedIndex((i - 13), true);
		}
		i++;
	}
	i = 0;
	while((i < 25))
	{
		m_KillPointData[i].Name = "";
		m_KillPointData[i].KillPoint = 9999;
		i++;
	}
	m_Count = 0;
	return;
}
