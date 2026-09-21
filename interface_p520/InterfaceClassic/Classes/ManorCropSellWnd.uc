class ManorCropSellWnd extends UICommonAPI;

const CROP_NAME = 0;
const MANOR_NAME = 1;
const CROP_REMAIN_CNT = 2;
const CROP_PRICE = 3;
const PROCURE_TYPE = 4;
const MY_CROP_CNT = 5;
const SELL_CNT = 6;
const CROP_LEVEL = 7;
const REWARD_TYPE_1 = 8;
const REWARD_TYPE_2 = 9;
const COLUMN_CNT = 10;

var string m_Windowname;
var ListCtrlHandle m_hManorCropSellWndManorCropSellListCtrl;

function OnRegisterEvent()
{
	RegisterEvent(2640);
	RegisterEvent(2645);
	RegisterEvent(2646);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	m_hManorCropSellWndManorCropSellListCtrl = GetListCtrlHandle((m_Windowname $ ".ManorCropSellListCtrl"));
	return;
}

function OnEvent(int Event_ID, string a_Param)
{
	switch(Event_ID)
	{
		case 2640:
			if(IsShowWindow("ManorCropSellWnd"))
			{
				HideWindow("ManorCropSellWnd");
			}
			else
			{
				DeleteAll();
				ShowWindowWithFocus("ManorCropSellWnd");
			}
			break;
		case 2645:
			HandleAddItem(a_Param);
			break;
		case 2646:
			HandleSetCropSell(a_Param);
			break;
		default:
			break;
	}
	return;
}

function DeleteAll()
{
	Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem("ManorCropSellWnd.ManorCropSellListCtrl");
	return;
}

function OnDBClickListCtrlRecord(string strID)
{
	switch(strID)
	{
		case "ManorCropSellListCtrl":
			OnChangeBtn();
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnChangeSell":
			OnChangeBtn();
			break;
		case "btnSell":
			OnSellBtn();
			break;
		case "btnCancel":
			HideWindow("ManorCropSellWnd");
			break;
		default:
			break;
	}
	return;
}

function OnSellBtn()
{
	local int RecordCount;
	local LVDataRecord Record;
	local INT64 SellCnt;
	local int CropCnt, CropNum, i;
	local string param;

	RecordCount = m_hManorCropSellWndManorCropSellListCtrl.GetRecordCount();
	CropCnt = 0;
	i = 0;
	while((i < RecordCount))
	{
		m_hManorCropSellWndManorCropSellListCtrl.GetRec(i, Record);
		SellCnt = INT64(Record.LVDataList[6].szData);
		if((SellCnt > INT64(0)))
		{
			CropCnt++;
		}
		++i;
	}
	ParamAdd(param, "CropCnt", string(CropCnt));
	CropNum = 0;
	i = 0;
	while((i < RecordCount))
	{
		m_hManorCropSellWndManorCropSellListCtrl.GetRec(i, Record);
		SellCnt = INT64(Record.LVDataList[6].szData);
		if((SellCnt <= INT64(0)))
		{
			++i;
			continue;
		}
		ParamAdd(param, ("CropServerID" $ string(CropNum)), string(Record.nReserved3));
		ParamAdd(param, ("CropID" $ string(CropNum)), string(Record.nReserved2));
		ParamAdd(param, ("ManorID" $ string(CropNum)), string(Record.nReserved1));
		ParamAdd(param, ("SellCount" $ string(CropNum)), string(SellCnt));
		CropNum++;
		++i;
	}
	RequestProcureCropList(param);
	HideWindow("ManorCropSellWnd");
	return;
}

function OnChangeBtn()
{
	local LVDataRecord Record;
	local int SelectedIndex, CropID;
	local string ManorCropSellChangeWndString, param;

	SelectedIndex = Class'NWindow.UIAPI_LISTCTRL'.static.GetSelectedIndex("ManorCropSellWnd.ManorCropSellListCtrl");
	if((SelectedIndex == -1))
	{
		return;
	}
	m_hManorCropSellWndManorCropSellListCtrl.GetSelectedRec(Record);
	CropID = int(Record.nReserved2);
	ManorCropSellChangeWndString = (("manor_menu_select?ask=9&state=" $ string(CropID)) $ "&time=0");
	RequestBypassToServer(ManorCropSellChangeWndString);
	ParamAdd(param, "CropName", Record.LVDataList[0].szData);
	ParamAdd(param, "RewardType1", Record.LVDataList[8].szData);
	ParamAdd(param, "RewardType2", Record.LVDataList[9].szData);
	ExecuteEvent(2649, param);
	return;
}

function HandleAddItem(string a_Param)
{
	local LVDataRecord Record;
	local string CropName, ManorName;
	local INT64 CropRemainCnt, CropPrice;
	local int ProcureType;
	local INT64 MyCropCnt;
	local int CropLevel;
	local string RewardType1, RewardType2;
	local int ManorID, CropID, CropServerID;

	Record.LVDataList.Length = 10;
	ParseString(a_Param, "CropName", CropName);
	ParseString(a_Param, "ManorName", ManorName);
	ParseINT64(a_Param, "CropRemainCnt", CropRemainCnt);
	ParseINT64(a_Param, "CropPrice", CropPrice);
	ParseInt(a_Param, "ProcureType", ProcureType);
	ParseINT64(a_Param, "MyCropCnt", MyCropCnt);
	ParseInt(a_Param, "CropLevel", CropLevel);
	ParseString(a_Param, "RewardType1", RewardType1);
	ParseString(a_Param, "RewardType2", RewardType2);
	ParseInt(a_Param, "ManorID", ManorID);
	ParseInt(a_Param, "CropID", CropID);
	ParseInt(a_Param, "CropServerID", CropServerID);
	Record.LVDataList[0].szData = CropName;
	Record.LVDataList[1].szData = ManorName;
	Record.LVDataList[2].szData = string(CropRemainCnt);
	Record.LVDataList[3].szData = string(CropPrice);
	Record.LVDataList[4].szData = string(ProcureType);
	Record.LVDataList[5].szData = string(MyCropCnt);
	Record.LVDataList[6].szData = "0";
	Record.LVDataList[7].szData = string(CropLevel);
	Record.LVDataList[8].szData = RewardType1;
	Record.LVDataList[9].szData = RewardType2;
	Record.nReserved1 = INT64(ManorID);
	Record.nReserved2 = INT64(CropID);
	Record.nReserved3 = INT64(CropServerID);
	Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("ManorCropSellWnd.ManorCropSellListCtrl", Record);
	return;
}

function HandleSetCropSell(string a_Param)
{
	local string SellCntString;
	local int ManorID;
	local string ManorName, CropRemainCntString, CropPriceString, ProcureTypeString;
	local int SelectedIndex;
	local LVDataRecord Record;

	ParseString(a_Param, "SellCntString", SellCntString);
	ParseInt(a_Param, "ManorID", ManorID);
	ParseString(a_Param, "ManorName", ManorName);
	ParseString(a_Param, "CropRemainCntString", CropRemainCntString);
	ParseString(a_Param, "CropPriceString", CropPriceString);
	ParseString(a_Param, "ProcureTypeString", ProcureTypeString);
	m_hManorCropSellWndManorCropSellListCtrl.GetSelectedRec(Record);
	Record.LVDataList[1].szData = ManorName;
	Record.LVDataList[2].szData = CropRemainCntString;
	Record.LVDataList[3].szData = CropPriceString;
	Record.LVDataList[4].szData = ProcureTypeString;
	Record.LVDataList[6].szData = SellCntString;
	Record.nReserved1 = INT64(ManorID);
	SelectedIndex = Class'NWindow.UIAPI_LISTCTRL'.static.GetSelectedIndex("ManorCropSellWnd.ManorCropSellListCtrl");
	Class'NWindow.UIAPI_LISTCTRL'.static.ModifyRecord("ManorCropSellWnd.ManorCropSellListCtrl", SelectedIndex, Record);
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="ManorCropSellWnd"
}
