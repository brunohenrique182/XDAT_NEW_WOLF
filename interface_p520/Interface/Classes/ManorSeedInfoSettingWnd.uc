class ManorSeedInfoSettingWnd extends UICommonAPI;

const SEED_NAME = 0;
const TODAY_VOLUME_OF_SALES = 1;
const TODAY_PRICE = 2;
const TOMORROW_VOLUME_OF_SALES = 3;
const TOMORROW_PRICE = 4;
const MINIMUM_CROP_PRICE = 5;
const MAXIMUM_CROP_PRICE = 6;
const SEED_LEVEL = 7;
const REWARD_TYPE_1 = 8;
const REWARD_TYPE_2 = 9;
const COLUMN_CNT = 10;
const DIALOG_ID_STOP = 555;
const DIALOG_ID_SETTODAY = 666;

var int m_ManorID;
var INT64 m_SumOfDefaultPrice;
var string m_Windowname;
var ListCtrlHandle m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl;

function OnRegisterEvent()
{
	RegisterEvent(2656);
	RegisterEvent(2657);
	RegisterEvent(2658);
	RegisterEvent(2659);
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
	m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl = GetListCtrlHandle((m_Windowname $ ".ManorSeedInfoSettingListCtrl"));
	return;
}

function OnEvent(int Event_ID, string a_Param)
{
	switch(Event_ID)
	{
		case 2656:
			HandleShow(a_Param);
			break;
		case 2657:
			HandleAddItem(a_Param);
			break;
		case 2658:
			CalculateSumOfDefaultPrice();
			ShowWindowWithFocus("ManorSeedInfoSettingWnd");
			break;
		case 2659:
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
		case 555:
			HandleStop();
			break;
		case 666:
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

	recordCnt = m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetRecordCount();
	i = 0;
	while((i < recordCnt))
	{
		Record = recordClear;
		m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetRec(i, Record);
		Record.LVDataList[3].szData = "0";
		Record.LVDataList[4].szData = "0";
		m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.ModifyRecord(i, Record);
		++i;
	}
	CalculateSumOfDefaultPrice();
	return;
}

function HandleSetToday()
{
	local int i, recordCnt;
	local LVDataRecord Record, recordClear;

	recordCnt = m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetRecordCount();
	i = 0;
	while((i < recordCnt))
	{
		Record = recordClear;
		m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetRec(i, Record);
		Record.LVDataList[3].szData = Record.LVDataList[1].szData;
		Record.LVDataList[4].szData = Record.LVDataList[2].szData;
		m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.ModifyRecord(i, Record);
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
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("ManorSeedInfoSettingWnd.txtManorName", ManorName);
	DeleteAll();
	return;
}

function HandleChangeValue(string a_Param)
{
	local INT64 TomorrowSalesVolume, TomorrowPrice;
	local LVDataRecord Record;
	local int SelectedIndex;

	ParseINT64(a_Param, "TomorrowSalesVolume", TomorrowSalesVolume);
	ParseINT64(a_Param, "TomorrowPrice", TomorrowPrice);
	SelectedIndex = Class'NWindow.UIAPI_LISTCTRL'.static.GetSelectedIndex("ManorSeedInfoSettingWnd.ManorSeedInfoSettingListCtrl");
	m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetSelectedRec(Record);
	Record.LVDataList[3].szData = string(TomorrowSalesVolume);
	Record.LVDataList[4].szData = string(TomorrowPrice);
	Class'NWindow.UIAPI_LISTCTRL'.static.ModifyRecord("ManorSeedInfoSettingWnd.ManorSeedInfoSettingListCtrl", SelectedIndex, Record);
	CalculateSumOfDefaultPrice();
	return;
}

function DeleteAll()
{
	Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem("ManorSeedInfoSettingWnd.ManorSeedInfoSettingListCtrl");
	return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		case "ManorSeedInfoSettingListCtrl":
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ManorSeedInfoChangeWnd"))
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
		case "ManorSeedInfoSettingListCtrl":
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
			DialogSetID(666);
			DialogShow(DialogModalType_Modalless, DialogType_Warning, GetSystemMessage(1601));
			break;
		case "btnStop":
			DialogSetID(555);
			DialogShow(DialogModalType_Modalless, DialogType_Warning, GetSystemMessage(1600));
			break;
		case "btnOk":
			OnOk();
			break;
		case "btnCancel":
			HideWindow("ManorSeedInfoSettingWnd");
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

	RecordCount = m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetRecordCount();
	ParamAdd(param, "ManorID", string(m_ManorID));
	ParamAdd(param, "SeedCnt", string(RecordCount));
	i = 0;
	while((i < RecordCount))
	{
		Record = recordClear;
		m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetRec(i, Record);
		ParamAdd(param, ("SeedID" $ string(i)), string(Record.nReserved1));
		ParamAdd(param, ("TomorrowSalesVolume" $ string(i)), Record.LVDataList[3].szData);
		ParamAdd(param, ("TomorrowPrice" $ string(i)), Record.LVDataList[4].szData);
		++i;
	}
	RequestSetSeed(param);
	HideWindow("ManorSeedInfoSettingWnd");
	return;
}

function OnChangeBtn()
{
	local LVDataRecord Record;
	local string param;

	if((m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetSelectedIndex() == -1))
	{
		AddSystemMessageString(GetSystemMessage(326));
		return;
	}
	m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetSelectedRec(Record);
	ParamAdd(param, "SeedName", Record.LVDataList[0].szData);
	ParamAdd(param, "TomorrowVolumeOfSales", Record.LVDataList[3].szData);
	ParamAdd(param, "TomorrowLimit", string(Record.nReserved2));
	ParamAdd(param, "TomorrowPrice", Record.LVDataList[4].szData);
	ParamAdd(param, "MinCropPrice", Record.LVDataList[5].szData);
	ParamAdd(param, "MaxCropPrice", Record.LVDataList[6].szData);
	ExecuteEvent(2660, param);
	return;
}

function HandleAddItem(string a_Param)
{
	local LVDataRecord Record;
	local int SeedID;
	local string SeedName;
	local int TodaySeedTotalCnt;
	local INT64 TodaySeedPrice, NextSeedTotalCnt, NextSeedPrice;
	local int MinCropPrice, MaxCropPrice, SeedLevel;
	local string RewardType1, RewardType2;
	local INT64 MaxSeedTotalCnt;
	local int DefaultSeedPrice;

	ParseInt(a_Param, "SeedID", SeedID);
	ParseString(a_Param, "SeedName", SeedName);
	ParseInt(a_Param, "TodaySeedTotalCnt", TodaySeedTotalCnt);
	ParseINT64(a_Param, "TodaySeedPrice", TodaySeedPrice);
	ParseINT64(a_Param, "TodayNextSeedTotalCnt", NextSeedTotalCnt);
	ParseINT64(a_Param, "NextSeedPrice", NextSeedPrice);
	ParseInt(a_Param, "MinCropPrice", MinCropPrice);
	ParseInt(a_Param, "MaxCropPrice", MaxCropPrice);
	ParseInt(a_Param, "SeedLevel", SeedLevel);
	ParseString(a_Param, "RewardType1", RewardType1);
	ParseString(a_Param, "RewardType2", RewardType2);
	ParseINT64(a_Param, "MaxSeedTotalCnt", MaxSeedTotalCnt);
	ParseInt(a_Param, "DefaultSeedPrice", DefaultSeedPrice);
	Record.LVDataList.Length = 10;
	Record.LVDataList[0].szData = SeedName;
	Record.LVDataList[1].szData = string(TodaySeedTotalCnt);
	Record.LVDataList[2].szData = string(TodaySeedPrice);
	Record.LVDataList[3].szData = string(NextSeedTotalCnt);
	Record.LVDataList[4].szData = string(NextSeedPrice);
	Record.LVDataList[5].szData = string(MinCropPrice);
	Record.LVDataList[6].szData = string(MaxCropPrice);
	Record.LVDataList[7].szData = string(SeedLevel);
	Record.LVDataList[8].szData = RewardType1;
	Record.LVDataList[9].szData = RewardType2;
	Record.nReserved1 = INT64(SeedID);
	Record.nReserved2 = MaxSeedTotalCnt;
	Record.nReserved3 = INT64(DefaultSeedPrice);
	Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("ManorSeedInfoSettingWnd.ManorSeedInfoSettingListCtrl", Record);
	return;
}

function CalculateSumOfDefaultPrice()
{
	local LVDataRecord Record, recordClear;
	local int ItemCnt, i;
	local INT64 tmpMulti;
	local string Adenastring;

	m_SumOfDefaultPrice = INT64(0);
	ItemCnt = m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetRecordCount();
	i = 0;
	while((i < ItemCnt))
	{
		Record = recordClear;
		m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetRec(i, Record);
		tmpMulti = (Record.nReserved3 * INT64(Record.LVDataList[3].szData));
		(m_SumOfDefaultPrice += tmpMulti);
		++i;
	}
	Adenastring = MakeCostString(string(m_SumOfDefaultPrice));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("ManorSeedInfoSettingWnd.txtVarNextTotalExpense", Adenastring);
	return;
}

defaultproperties
{
	m_Windowname="ManorSeedInfoSettingWnd"
}
