class ManorCropInfoSettingWnd extends UICommonAPI;

const CROP_NAME = 0;
const TODAY_CROP_TOTOAL_CNT = 1;
const TODAY_CROP_PRICE = 2;
const TODAY_PROCURE_TYPE = 3;
const NEXT_CROP_TOTAL_CNT = 4;
const NEXT_CROP_PRICE = 5;
const NEXT_PROCURE_TYPE = 6;
const MIN_CROP_PRICE = 7;
const MAX_CROP_PRICE = 8;
const CROP_LELEL = 9;
const REWARD_TYPE_1 = 10;
const REWARD_TYPE_2 = 11;
const COLUMN_CNT = 12;
const DIALOG_ID_STOP = 777;
const DIALOG_ID_SETTODAY = 888;

var int m_ManorID;
var INT64 m_SumOfDefaultPrice;
var string m_Windowname;
var ListCtrlHandle m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl;

function OnRegisterEvent()
{
	RegisterEvent(2665);
	RegisterEvent(2666);
	RegisterEvent(2667);
	RegisterEvent(2668);
	RegisterEvent(1710);
	return;
}

function OnLoad()
{
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	m_ManorID = -1;
	m_SumOfDefaultPrice = INT64(0);
	m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl = GetListCtrlHandle((m_Windowname $ ".ManorCropInfoSettingListCtrl"));
	return;
}

function OnEvent(int Event_ID, string a_Param)
{
	switch(Event_ID)
	{
		case 2665:
			HandleShow(a_Param);
			break;
		case 2666:
			HandleAddItem(a_Param);
			break;
		case 2667:
			CalculateSumOfDefaultPrice();
			ShowWindowWithFocus("ManorCropInfoSettingWnd");
			break;
		case 2668:
			HandleChangeValue(a_Param);
			break;
		case 1710:
			HandleDialogOK();
			break;
		default:
			break;
	}
	return;
}

function HandleDialogOK()
{
	local int dialogID;

	if(!DialogIsMine())
	{
		return;
	}
	dialogID = DialogGetID();
	switch(dialogID)
	{
		case 777:
			HandleStop();
			break;
		case 888:
			HandleSetToday();
			break;
		default:
			break;
	}
	return;
}

function HandleStop()
{
	local int i, recordCnt;
	local LVDataRecord Record, recordClear;

	recordCnt = m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetRecordCount();
	i = 0;
	while((i < recordCnt))
	{
		Record = recordClear;
		m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetRec(i, Record);
		Record.LVDataList[4].szData = "0";
		Record.LVDataList[5].szData = "0";
		Record.LVDataList[6].szData = "0";
		Class'NWindow.UIAPI_LISTCTRL'.static.ModifyRecord("ManorCropInfoSettingWnd.ManorCropInfoSettingListCtrl", i, Record);
		++i;
	}
	CalculateSumOfDefaultPrice();
	return;
}

function HandleSetToday()
{
	local int i, recordCnt;
	local LVDataRecord Record, recordClear;

	recordCnt = m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetRecordCount();
	i = 0;
	while((i < recordCnt))
	{
		Record = recordClear;
		m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetRec(i, Record);
		Record.LVDataList[4].szData = Record.LVDataList[1].szData;
		Record.LVDataList[5].szData = Record.LVDataList[2].szData;
		Record.LVDataList[6].szData = Record.LVDataList[3].szData;
		Class'NWindow.UIAPI_LISTCTRL'.static.ModifyRecord("ManorCropInfoSettingWnd.ManorCropInfoSettingListCtrl", i, Record);
		++i;
	}
	CalculateSumOfDefaultPrice();
	return;
}

function HandleShow(string a_Param)
{
	local int ManorID;
	local string ManorName;

	ParseInt(a_Param, "ManorID", ManorID);
	ParseString(a_Param, "ManorName", ManorName);
	m_ManorID = ManorID;
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("ManorCropInfoSettingWnd.txtManorName", ManorName);
	DeleteAll();
	return;
}

function DeleteAll()
{
	Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem("ManorCropInfoSettingWnd.ManorCropInfoSettingListCtrl");
	return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		case "ManorCropInfoSettingListCtrl":
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ManorCropInfoChangeWnd"))
			{
				OnChangeBtn();
			}
			break;
		default:
			break;
	}
	return;
}

function OnDBClickListCtrlRecord(string strID)
{
	switch(strID)
	{
		case "ManorCropInfoSettingListCtrl":
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
		case "btnSetToday":
			DialogSetID(888);
			DialogShow(DialogModalType_Modalless, DialogType_Warning, GetSystemMessage(1601));
			break;
		case "btnStop":
			DialogSetID(777);
			DialogShow(DialogModalType_Modalless, DialogType_Warning, GetSystemMessage(1600));
			break;
		case "btnOk":
			OnOk();
			HideWindow("ManorCropInfoSettingWnd");
			break;
		case "btnCancel":
			HideWindow("ManorCropInfoSettingWnd");
			break;
		default:
			break;
	}
	return;
}

function OnOk()
{
	local int RecordCount;
	local LVDataRecord Record, recordClear;
	local int i;
	local string param;

	RecordCount = m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetRecordCount();
	ParamAdd(param, "ManorID", string(m_ManorID));
	ParamAdd(param, "CropCnt", string(RecordCount));
	i = 0;
	while((i < RecordCount))
	{
		Record = recordClear;
		m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetRec(i, Record);
		ParamAdd(param, ("CropID" $ string(i)), string(Record.nReserved1));
		ParamAdd(param, ("BuyCnt" $ string(i)), Record.LVDataList[4].szData);
		ParamAdd(param, ("Price" $ string(i)), Record.LVDataList[5].szData);
		ParamAdd(param, ("ProcureType" $ string(i)), Record.LVDataList[6].szData);
		++i;
	}
	RequestSetCrop(param);
	return;
}

function HandleAddItem(string a_Param)
{
	local LVDataRecord Record;
	local int CropID;
	local string CropName;
	local INT64 TodayCropTotalCnt, TodayCropPrice;
	local int TodayProcureType;
	local INT64 NextCropTotalCnt, NextCropPrice;
	local int NextProcureType, MinCropPrice, MaxCropPrice, CropLevel;
	local string RewardType1, RewardType2;
	local int MaxCropTotalCnt, DefaultCropPrice;

	ParseInt(a_Param, "CropID", CropID);
	ParseString(a_Param, "CropName", CropName);
	ParseINT64(a_Param, "TodayCropTotalCnt", TodayCropTotalCnt);
	ParseINT64(a_Param, "TodayCropPrice", TodayCropPrice);
	ParseInt(a_Param, "TodayProcureType", TodayProcureType);
	ParseINT64(a_Param, "NextCropTotalCnt", NextCropTotalCnt);
	ParseINT64(a_Param, "NextCropPrice", NextCropPrice);
	ParseInt(a_Param, "NextProcureType", NextProcureType);
	ParseInt(a_Param, "MinCropPrice", MinCropPrice);
	ParseInt(a_Param, "MaxCropPrice", MaxCropPrice);
	ParseInt(a_Param, "CropLevel", CropLevel);
	ParseString(a_Param, "RewardType1", RewardType1);
	ParseString(a_Param, "RewardType2", RewardType2);
	ParseInt(a_Param, "MaxCropTotalCnt", MaxCropTotalCnt);
	ParseInt(a_Param, "DefaultCropPrice", DefaultCropPrice);
	Record.LVDataList.Length = 12;
	Record.LVDataList[0].szData = CropName;
	Record.LVDataList[1].szData = string(TodayCropTotalCnt);
	Record.LVDataList[2].szData = string(TodayCropPrice);
	Record.LVDataList[3].szData = string(TodayProcureType);
	Record.LVDataList[4].szData = string(NextCropTotalCnt);
	Record.LVDataList[5].szData = string(NextCropPrice);
	Record.LVDataList[6].szData = string(NextProcureType);
	Record.LVDataList[7].szData = string(MinCropPrice);
	Record.LVDataList[8].szData = string(MaxCropPrice);
	Record.LVDataList[9].szData = string(CropLevel);
	Record.LVDataList[10].szData = RewardType1;
	Record.LVDataList[11].szData = RewardType2;
	Record.nReserved1 = INT64(CropID);
	Record.nReserved2 = INT64(MaxCropTotalCnt);
	Record.nReserved3 = INT64(DefaultCropPrice);
	Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("ManorCropInfoSettingWnd.ManorCropInfoSettingListCtrl", Record);
	return;
}

function CalculateSumOfDefaultPrice()
{
	local LVDataRecord Record, recordClear;
	local int ItemCnt, i;
	local INT64 tmpMulti;
	local string Adenastring;

	m_SumOfDefaultPrice = INT64(0);
	ItemCnt = m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetRecordCount();
	i = 0;
	while((i < ItemCnt))
	{
		Record = recordClear;
		m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetRec(i, Record);
		tmpMulti = (INT64(Record.LVDataList[5].szData) * INT64(Record.LVDataList[4].szData));
		(m_SumOfDefaultPrice += tmpMulti);
		++i;
	}
	Adenastring = MakeCostString(string(m_SumOfDefaultPrice));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("ManorCropInfoSettingWnd.txtVarNextTotalExpense", Adenastring);
	return;
}

function OnChangeBtn()
{
	local LVDataRecord Record;
	local string param;

	if((m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetSelectedIndex() == -1))
	{
		AddSystemMessageString(GetSystemMessage(326));
		return;
	}
	m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetSelectedRec(Record);
	ParamAdd(param, "CropName", Record.LVDataList[0].szData);
	ParamAdd(param, "TomorrowVolumeOfBuy", Record.LVDataList[4].szData);
	ParamAdd(param, "TomorrowLimit", string(Record.nReserved2));
	ParamAdd(param, "TomorrowPrice", Record.LVDataList[5].szData);
	ParamAdd(param, "TomorrowProcure", Record.LVDataList[6].szData);
	ParamAdd(param, "MinCropPrice", Record.LVDataList[7].szData);
	ParamAdd(param, "MaxCropPrice", Record.LVDataList[8].szData);
	ExecuteEvent(2670, param);
	return;
}

function HandleChangeValue(string a_Param)
{
	local INT64 TomorrowAmountOfPurchase, TomorrowPurchasePrice;
	local int TomorrowProcure;
	local LVDataRecord Record;
	local int SelectedIndex;

	ParseINT64(a_Param, "TomorrowAmountOfPurchase", TomorrowAmountOfPurchase);
	ParseINT64(a_Param, "TomorrowPurchasePrice", TomorrowPurchasePrice);
	ParseInt(a_Param, "TomorrowProcure", TomorrowProcure);
	SelectedIndex = Class'NWindow.UIAPI_LISTCTRL'.static.GetSelectedIndex("ManorCropInfoSettingWnd.ManorCropInfoSettingListCtrl");
	m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetSelectedRec(Record);
	Record.LVDataList[4].szData = string(TomorrowAmountOfPurchase);
	Record.LVDataList[5].szData = string(TomorrowPurchasePrice);
	Record.LVDataList[6].szData = string(TomorrowProcure);
	Class'NWindow.UIAPI_LISTCTRL'.static.ModifyRecord("ManorCropInfoSettingWnd.ManorCropInfoSettingListCtrl", SelectedIndex, Record);
	CalculateSumOfDefaultPrice();
	return;
}

defaultproperties
{
	m_Windowname="ManorCropInfoSettingWnd"
}
