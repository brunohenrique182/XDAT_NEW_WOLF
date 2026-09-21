class ManorInfoWnd extends UICommonAPI;

const SEED_NAME = 0;
const SEED_REMAIN_CNT = 1;
const SEED_TOTLAL_CNT = 2;
const SEED_PRICE = 3;
const SEED_LEVEL = 4;
const SEED_REWARD_TYPE_1 = 5;
const SEED_REWARD_TYPE_2 = 6;
const SEED_MAX_COLUMN = 7;
const CROP_NAME = 0;
const CROP_REMAIN_CNT = 1;
const CROP_TOTLAL_CNT = 2;
const CROP_PRICE = 3;
const CROP_PROCURE_TYPE = 4;
const CROP_LEVEL = 5;
const CROP_REWARD_TYPE_1 = 6;
const CROP_REWARD_TYPE_2 = 7;
const CROP_MAX_COLUMN = 8;
const DEFAULT_CROP_NAME = 0;
const DEFAULT_CROP_LEVEL = 1;
const DEFAULT_SEED_PRICE = 2;
const DEFAULT_CROP_PRICE = 3;
const DEFAULT_REWARD_TYPE_1 = 4;
const DEFAULT_REWARD_TYPE_2 = 5;
const DEFAULT_MAX_COLUMN = 6;

var string m_Windowname;
var bool m_bTime;
var int m_MerchantOrChamberlain;
var int m_ManorID;
var int m_MyManorID;
var TabHandle m_hManorInfoWndManorInfoTabCtrl;

function OnRegisterEvent()
{
	RegisterEvent(2650);
	RegisterEvent(2652);
	RegisterEvent(2654);
	RegisterEvent(2651);
	RegisterEvent(2653);
	RegisterEvent(2655);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	m_hManorInfoWndManorInfoTabCtrl = GetTabHandle("ManorInfoWnd.ManorInfoTabCtrl");
	m_MerchantOrChamberlain = 0;
	m_ManorID = -1;
	m_MyManorID = -1;
	m_bTime = false;
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 2650:
			HandleSeedInfoShow(a_Param);
			break;
		case 2651:
			HandleSeedAdd(a_Param);
			break;
		case 2652:
			HandleCropInfoShow(a_Param);
			break;
		case 2653:
			HandleCropAdd(a_Param);
			break;
		case 2654:
			HandleDefaultInfoShow(a_Param);
			break;
		case 2655:
			HandleDefaultAdd(a_Param);
			break;
		default:
			break;
	}
	return;
}

function HandleSeedInfoShow(string a_Param)
{
	local int MerchantOrChamberlain, NumOfManor, i, ManorID;
	local string ManorName, ParamString, Message;
	local int ManorCnt;
	local string MyManorName;

	ParseInt(a_Param, "MerchantOrChamberlain", MerchantOrChamberlain);
	ParseInt(a_Param, "ManorID", ManorID);
	ParseString(a_Param, "ManorName", ManorName);
	m_MerchantOrChamberlain = MerchantOrChamberlain;
	m_ManorID = ManorID;
	Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem("ManorInfoWnd.SeedInfoWnd.SeedInfoListCtrl");
	Class'NWindow.UIAPI_COMBOBOX'.static.Clear("ManorInfoWnd.SeedInfoWnd.cbManorSelectInSeedInfo");
	i = 0;
	while((i < GetManorCount()))
	{
		ManorID = GetManorIDInManorList(i);
		Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved("ManorInfoWnd.SeedInfoWnd.cbManorSelectInSeedInfo", GetManorNameInManorList(i), ManorID);
		++i;
	}
	NumOfManor = Class'NWindow.UIAPI_COMBOBOX'.static.GetNumOfItems("ManorInfoWnd.SeedInfoWnd.cbManorSelectInSeedInfo");
	i = 0;
	while((i < NumOfManor))
	{
		if((m_ManorID == Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved("ManorInfoWnd.SeedInfoWnd.cbManorSelectInSeedInfo", i)))
		{
			Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("ManorInfoWnd.SeedInfoWnd.cbManorSelectInSeedInfo", i);
			break;
		}
		++i;
	}
	if(!IsShowWindow("ManorInfoWnd"))
	{
		m_MyManorID = m_ManorID;
	}
	if((MerchantOrChamberlain == 1))
	{
		HideWindow("ManorInfoWnd.SeedInfoWnd.btnBuySeed");
	}
	else
	{
		ShowWindow("ManorInfoWnd.SeedInfoWnd.btnBuySeed");
		ManorCnt = GetManorCount();
		i = 0;
		while((i < ManorCnt))
		{
			if((m_MyManorID == GetManorIDInManorList(i)))
			{
				MyManorName = GetManorNameInManorList(i);
				break;
			}
			++i;
		}
		ParamAdd(ParamString, "Type", string(0));
		ParamAdd(ParamString, "param1", MyManorName);
		AddSystemMessageParam(ParamString);
		Message = EndSystemMessageParam(1605, true);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("ManorInfoWnd.SeedInfoWnd.txtNotice", Message);
	}
	ShowWindowWithFocus("ManorInfoWnd");
	HideWindow("ManorInfoWnd.CropInfoWnd");
	HideWindow("ManorInfoWnd.DefaultInfoWnd");
	m_hManorInfoWndManorInfoTabCtrl.SetTopOrder(0, false);
	if(!IsShowWindow("ManorInfoWnd.SeedInfoWnd"))
	{
		Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("ManorInfoWnd.CropInfoWnd.cbManorSelectInCropInfo", -1);
		ShowWindowWithFocus("ManorInfoWnd.SeedInfoWnd");
	}
	return;
}

function HandleSeedAdd(string a_Param)
{
	local int SeedID;
	local string SeedName;
	local INT64 SeedRemainCnt, SeedTotalCnt, SeedPrice;
	local int SeedLevel;
	local string RewardType1, RewardType2;
	local LVDataRecord Record;

	ParseInt(a_Param, "SeedID", SeedID);
	ParseString(a_Param, "SeedName", SeedName);
	ParseINT64(a_Param, "SeedRemainCnt", SeedRemainCnt);
	ParseINT64(a_Param, "SeedTotalCnt", SeedTotalCnt);
	ParseINT64(a_Param, "SeedPrice", SeedPrice);
	ParseInt(a_Param, "SeedLevel", SeedLevel);
	ParseString(a_Param, "RewardType1", RewardType1);
	ParseString(a_Param, "RewardType2", RewardType2);
	Record.LVDataList.Length = 7;
	Record.LVDataList[0].szData = SeedName;
	Record.LVDataList[1].szData = string(SeedRemainCnt);
	Record.LVDataList[2].szData = string(SeedTotalCnt);
	Record.LVDataList[3].szData = string(SeedPrice);
	Record.LVDataList[4].szData = string(SeedLevel);
	Record.LVDataList[5].szData = RewardType1;
	Record.LVDataList[6].szData = RewardType2;
	Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("ManorInfoWnd.SeedInfoWnd.SeedInfoListCtrl", Record);
	return;
}

function HandleCropInfoShow(string a_Param)
{
	local int MerchantOrChamberlain, NumOfManor, i, ManorID;

	ParseInt(a_Param, "MerchantOrChamberlain", MerchantOrChamberlain);
	ParseInt(a_Param, "ManorID", ManorID);
	m_MerchantOrChamberlain = MerchantOrChamberlain;
	m_ManorID = ManorID;
	Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem("ManorInfoWnd.CropInfoWnd.CropInfoListCtrl");
	Class'NWindow.UIAPI_COMBOBOX'.static.Clear("ManorInfoWnd.CropInfoWnd.cbManorSelectInCropInfo");
	i = 0;
	while((i < GetManorCount()))
	{
		ManorID = GetManorIDInManorList(i);
		Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved("ManorInfoWnd.CropInfoWnd.cbManorSelectInCropInfo", GetManorNameInManorList(i), ManorID);
		++i;
	}
	NumOfManor = Class'NWindow.UIAPI_COMBOBOX'.static.GetNumOfItems("ManorInfoWnd.CropInfoWnd.cbManorSelectInCropInfo");
	i = 0;
	while((i < NumOfManor))
	{
		if((m_ManorID == Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved("ManorInfoWnd.CropInfoWnd.cbManorSelectInCropInfo", i)))
		{
			Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("ManorInfoWnd.CropInfoWnd.cbManorSelectInCropInfo", i);
			break;
		}
		++i;
	}
	if((MerchantOrChamberlain == 1))
	{
		HideWindow("ManorInfoWnd.CropInfoWnd.btnSellCrop");
	}
	else
	{
		ShowWindow("ManorInfoWnd.CropInfoWnd.btnSellCrop");
	}
	if(!IsShowWindow("ManorInfoWnd.CropInfoWnd"))
	{
		ShowWindowWithFocus("ManorInfoWnd.CropInfoWnd");
		if(!IsShowWindow("ManorInfoWnd"))
		{
			ShowWindow("ManorInfoWnd");
		}
		HideWindow("ManorInfoWnd.SeedInfoWnd");
		HideWindow("ManorInfoWnd.DefaultInfoWnd");
	}
	return;
}

function HandleCropAdd(string a_Param)
{
	local int CropID;
	local string CropName;
	local INT64 CropRemainCnt, CropTotalCnt, CropPrice;
	local int ProcureType, CropLevel;
	local string RewardType1, RewardType2;
	local LVDataRecord Record;

	ParseInt(a_Param, "CropID", CropID);
	ParseString(a_Param, "CropName", CropName);
	ParseINT64(a_Param, "CropRemainCnt", CropRemainCnt);
	ParseINT64(a_Param, "CropTotalCnt", CropTotalCnt);
	ParseINT64(a_Param, "CropPrice", CropPrice);
	ParseInt(a_Param, "ProcureType", ProcureType);
	ParseInt(a_Param, "CropLevel", CropLevel);
	ParseString(a_Param, "RewardType1", RewardType1);
	ParseString(a_Param, "RewardType2", RewardType2);
	Record.LVDataList.Length = 8;
	Record.LVDataList[0].szData = CropName;
	Record.LVDataList[1].szData = string(CropRemainCnt);
	Record.LVDataList[2].szData = string(CropTotalCnt);
	Record.LVDataList[3].szData = string(CropPrice);
	Record.LVDataList[4].szData = string(ProcureType);
	Record.LVDataList[5].szData = string(CropLevel);
	Record.LVDataList[6].szData = RewardType1;
	Record.LVDataList[7].szData = RewardType2;
	Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("ManorInfoWnd.CropInfoWnd.CropInfoListCtrl", Record);
	return;
}

function HandleDefaultInfoShow(string a_Param)
{
	local int MerchantOrChamberlain;

	ParseInt(a_Param, "MerchantOrChamberlain", MerchantOrChamberlain);
	m_MerchantOrChamberlain = MerchantOrChamberlain;
	Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem("ManorInfoWnd.DefaultInfoWnd.DefaultInfoListCtrl");
	if((MerchantOrChamberlain == 1))
	{
		HideWindow("ManorInfoWnd.DefaultInfoWnd.btnSellCrop");
		HideWindow("ManorInfoWnd.DefaultInfoWnd.btnBuySeed");
	}
	else
	{
		ShowWindow("ManorInfoWnd.DefaultInfoWnd.btnSellCrop");
		ShowWindow("ManorInfoWnd.DefaultInfoWnd.btnBuySeed");
	}
	ShowWindowWithFocus("ManorInfoWnd");
	ShowWindowWithFocus("ManorInfoWnd.DefaultInfoWnd");
	m_hManorInfoWndManorInfoTabCtrl.SetTopOrder(2, false);
	HideWindow("ManorInfoWnd.SeedInfoWnd");
	HideWindow("ManorInfoWnd.CropInfoWnd");
	return;
}

function HandleDefaultAdd(string a_Param)
{
	local int CropID;
	local string CropName;
	local int CropLevel, SeedPrice, CropPrice;
	local string RewardType1, RewardType2;
	local LVDataRecord Record;

	ParseInt(a_Param, "CropID", CropID);
	ParseString(a_Param, "CropName", CropName);
	ParseInt(a_Param, "CropLevel", CropLevel);
	ParseInt(a_Param, "SeedPrice", SeedPrice);
	ParseInt(a_Param, "CropPrice", CropPrice);
	ParseString(a_Param, "RewardType1", RewardType1);
	ParseString(a_Param, "RewardType2", RewardType2);
	Record.LVDataList.Length = 6;
	Record.LVDataList[0].szData = CropName;
	Record.LVDataList[1].szData = string(CropLevel);
	Record.LVDataList[2].szData = string(SeedPrice);
	Record.LVDataList[3].szData = string(CropPrice);
	Record.LVDataList[4].szData = RewardType1;
	Record.LVDataList[5].szData = RewardType2;
	Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("ManorInfoWnd.DefaultInfoWnd.DefaultInfoListCtrl", Record);
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnBuySeed":
			RequestBypassToServer("manor_menu_select?ask=1&state=-1&time=0");
			break;
		case "btnSellCrop":
			RequestBypassToServer("manor_menu_select?ask=2&state=-1&time=0");
			break;
		case "ManorInfoTabCtrl0":
			OnClickInfoTab("SeedInfo");
			break;
		case "ManorInfoTabCtrl1":
			OnClickInfoTab("CropInfo");
			break;
		case "ManorInfoTabCtrl2":
			RequestBypassToServer("manor_menu_select?ask=5&state=-1&time=0");
			break;
		default:
			break;
	}
	return;
}

function OnClickInfoTab(string TabName)
{
	local int SelectedManorID, SelectedTime;
	local string RequestString, PreString;
	local int Index;
	local string ManorComboBoxName, TimeComboBoxName;

	switch(TabName)
	{
		case "SeedInfo":
			PreString = "manor_menu_select?ask=3&state=";
			ManorComboBoxName = "ManorInfoWnd.SeedInfoWnd.cbManorSelectInSeedInfo";
			TimeComboBoxName = "ManorInfoWnd.SeedInfoWnd.cbTimeInSeedInfo";
			break;
		case "CropInfo":
			PreString = "manor_menu_select?ask=4&state=";
			ManorComboBoxName = "ManorInfoWnd.CropInfoWnd.cbManorSelectInCropInfo";
			TimeComboBoxName = "ManorInfoWnd.CropInfoWnd.cbTimeInCropInfo";
			break;
		default:
			break;
	}
	Index = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum(ManorComboBoxName);
	SelectedManorID = Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved(ManorComboBoxName, Index);
	SelectedTime = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum(TimeComboBoxName);
	if(((TabName == "CropInfo") && (SelectedManorID == -1)))
	{
		SelectedManorID = m_MyManorID;
	}
	if((SelectedManorID != 0))
	{
		RequestString = (((PreString $ string(SelectedManorID)) $ "&time=") $ string(SelectedTime));
		RequestBypassToServer(RequestString);
	}
	return;
}

function OnComboBoxItemSelected(string sName, int Index)
{
	switch(sName)
	{
		case "cbManorSelectInSeedInfo":
			m_bTime = false;
			RequestSelectedData("SeedInfo", Index);
			break;
		case "cbTimeInSeedInfo":
			m_bTime = true;
			RequestSelectedData("SeedInfo", Index);
			break;
		case "cbManorSelectInCropInfo":
			m_bTime = false;
			RequestSelectedData("CropInfo", Index);
			break;
		case "cbTimeInCropInfo":
			m_bTime = true;
			RequestSelectedData("CropInfo", Index);
			break;
		default:
			break;
	}
	return;
}

function RequestSelectedData(string WindowName, int Index)
{
	local int ManorID;
	local string RequestString, PreString;
	local int Time;
	local string ManorComboBoxName, TimeComboBoxName;

	if((WindowName == "SeedInfo"))
	{
		PreString = "manor_menu_select?ask=3&state=";
		ManorComboBoxName = "ManorInfoWnd.SeedInfoWnd.cbManorSelectInSeedInfo";
		TimeComboBoxName = "ManorInfoWnd.SeedInfoWnd.cbTimeInSeedInfo";
	}
	else
	{
		PreString = "manor_menu_select?ask=4&state=";
		ManorComboBoxName = "ManorInfoWnd.CropInfoWnd.cbManorSelectInCropInfo";
		TimeComboBoxName = "ManorInfoWnd.CropInfoWnd.cbTimeInCropInfo";
	}
	if(m_bTime)
	{
		ManorID = m_ManorID;
		Time = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum(TimeComboBoxName);
	}
	else
	{
		ManorID = Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved(ManorComboBoxName, Index);
		Time = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum(TimeComboBoxName);
	}
	if((ManorID > 0))
	{
		RequestString = (((PreString $ string(ManorID)) $ "&time=") $ string(Time));
	}
	RequestBypassToServer(RequestString);
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
	m_Windowname="ManorInfoWnd"
}
