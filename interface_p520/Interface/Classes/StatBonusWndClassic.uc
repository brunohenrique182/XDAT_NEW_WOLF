class StatBonusWndClassic extends UICommonAPI;

var string m_Windowname;
var WindowHandle Me;
var RichListCtrlHandle ListCtrl;

function OnLoad()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	SetClosingOnESC();
	ListCtrl = GetRichListCtrlHandle((m_Windowname $ ".StatBonus_ListCtrl"));
	ListCtrl.SetUseHorizontalScrollBar(true);
	ListCtrl.SetColumnMinimumWidth(true);
	ListCtrl.SetUseStripeBackTexture(false);
	ListCtrl.SetSelectable(false);
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "Close_Button":
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function OnShow()
{
	ResetData();
	return;
}

function ResetData()
{
	if(!Me.IsShowWindow())
	{
		return;
	}
	ListCtrl.DeleteAllItem();
	MakeRowDatas(API_GetStatBonusNameData());
	return;
}

function MakeRowDatas(array<StatBonusNameUIData> Data)
{
	local int i, myGrade;
	local UserInfo uInfo;
	local int beforeType;

	if(!GetPlayerInfo(uInfo))
	{
		return;
	}
	beforeType = -1;
	i = 0;
	while((i < Data.Length))
	{
		if((beforeType != int(Data[i].Type)))
		{
			beforeType = int(Data[i].Type);
			ListCtrl.InsertRecord(MakeRowDataHeader(beforeType));
			myGrade = (GetStatusBasicByIndex(beforeType, uInfo) + GetStatusPlused(beforeType));
		}
		ListCtrl.InsertRecord(MakeRowData(int(Data[i].Type), Data[i].Desc, Data[i].Grade, myGrade));
		i++;
	}
	return;
}

function ModifyRowData(int Index, int myGrade)
{
	local RichListCtrlRowData rowData;

	ListCtrl.GetRec(Index, rowData);
	ListCtrl.ModifyRecord(Index, MakeRowData(rowData.cellDataList[0].nReserved2, rowData.cellDataList[0].szData, rowData.cellDataList[0].nReserved1, myGrade));
	return;
}

function HandleOnChangedStatusType(int Type)
{
	local int i, myGrade;
	local array<int> indexs;
	local UserInfo uInfo;

	if(!GetPlayerInfo(uInfo))
	{
		return;
	}
	myGrade = (GetStatusBasicByIndex(Type, uInfo) + GetStatusPlused(Type));
	indexs = FindIndexsByType(Type);
	i = 0;
	while((i < indexs.Length))
	{
		ModifyRowData(indexs[i], myGrade);
		i++;
	}
	return;
}

function array<int> FindIndexsByType(int Type)
{
	local int i;
	local array<int> indexs;
	local RichListCtrlRowData rowData;

	i = 0;
	while((i < ListCtrl.GetRecordCount()))
	{
		ListCtrl.GetRec(i, rowData);
		if((rowData.cellDataList[0].szData != ""))
		{
			if((rowData.cellDataList[0].nReserved2 == Type))
			{
				indexs.Length = (indexs.Length + 1);
				indexs[(indexs.Length - 1)] = i;
			}
		}
		i++;
	}
	return indexs;
}

function RichListCtrlRowData MakeRowData(int Type, string Desc, int Grade, int myGrade)
{
	local RichListCtrlRowData rowData;
	local Color TextColor;

	rowData.cellDataList.Length = 1;
	if((myGrade < Grade))
	{
		TextColor = GetColor(153, 153, 153, 255);
	}
	else
	{
		TextColor = GetColor(255, 255, 0, 255);
	}
	rowData.cellDataList[0].szData = Desc;
	rowData.cellDataList[0].nReserved1 = Grade;
	rowData.cellDataList[0].nReserved2 = Type;
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, Desc, TextColor, false, 5);
	return rowData;
}

function RichListCtrlRowData MakeRowDataHeader(int Type)
{
	local string headName;
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = 1;
	switch(Type)
	{
		case 0:
			headName = GetSystemString(104);
			break;
		case 1:
			headName = GetSystemString(107);
			break;
		case 2:
			headName = GetSystemString(105);
			break;
		case 3:
			headName = GetSystemString(108);
			break;
		case 4:
			headName = GetSystemString(106);
			break;
		case 5:
			headName = GetSystemString(109);
			break;
		default:
			break;
	}
	rowData.sOverlayTex = "L2UI_CT1.PlayerStatusWnd.StatsBonus_ListHeader";
	rowData.OverlayTexU = 327;
	rowData.OverlayTexV = 22;
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, headName, GetColor(228, 218, 197, 255), false, 22);
	return rowData;
}

function array<StatBonusNameUIData> API_GetStatBonusNameData()
{
	local array<StatBonusNameUIData> arrStatBonusNameUIData;

	GetStatBonusNameData(arrStatBonusNameUIData);
	return arrStatBonusNameUIData;
}

function int GetBonusByType(int Type, UserInfo uInfo)
{
	switch(Type)
	{
		case 0:
			return uInfo.nStrBonus;
			break;
		case 1:
			return uInfo.nIntBonus;
			break;
		case 2:
			return uInfo.nDexBonus;
			break;
		case 3:
			return uInfo.nWitBonus;
			break;
		case 4:
			return uInfo.nConBonus;
			break;
		case 5:
			return uInfo.nMenBonus;
			break;
		default:
			break;
	}
	return -1;
}

function int GetStatusBasicByIndex(int Type, UserInfo uInfo)
{
	switch(Type)
	{
		case 0:
			return uInfo.nStr;
			break;
		case 1:
			return uInfo.nInt;
			break;
		case 2:
			return uInfo.nDex;
			break;
		case 3:
			return uInfo.nWit;
			break;
		case 4:
			return uInfo.nCon;
			break;
		case 5:
			return uInfo.nMen;
			break;
		default:
			break;
	}
	return -1;
}

function int GetStatusPlused(int Type)
{
	return DetailStatusWndClassic(GetScript("DetailStatusWndClassic")).statusPlused[Type];
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}
