class ManorSeedInfoChangeWnd extends UICommonAPI;

var INT64 m_MinCropPrice;
var INT64 m_MaxCropPrice;
var INT64 m_TomorrowLimit;

function OnRegisterEvent()
{
	RegisterEvent(2660);
	return;
}

function OnLoad()
{
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	return;
}

function OnEvent(int Event_ID, string a_Param)
{
	switch(Event_ID)
	{
		case 2660:
			HandleShow(a_Param);
			break;
		default:
			break;
	}
	return;
}

function HandleShow(string a_Param)
{
	local string SeedName;
	local INT64 TomorrowVolumeOfSales, TomorrowLimit, TomorrowPrice, MinCropPrice, MaxCropPrice;
	local string TomorrowLimitString;

	ParseString(a_Param, "SeedName", SeedName);
	ParseINT64(a_Param, "TomorrowVolumeOfSales", TomorrowVolumeOfSales);
	ParseINT64(a_Param, "TomorrowLimit", TomorrowLimit);
	ParseINT64(a_Param, "TomorrowPrice", TomorrowPrice);
	ParseINT64(a_Param, "MinCropPrice", MinCropPrice);
	ParseINT64(a_Param, "MaxCropPrice", MaxCropPrice);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("ManorSeedInfoChangeWnd.txtSeedName", SeedName);
	Class'NWindow.UIAPI_EDITBOX'.static.SetString("ManorSeedInfoChangeWnd.ebTomorrowSalesVolume", string(TomorrowVolumeOfSales));
	m_TomorrowLimit = TomorrowLimit;
	TomorrowLimitString = MakeCostString(string(TomorrowLimit));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("ManorSeedInfoChangeWnd.txtVarTomorrowLimit", TomorrowLimitString);
	Class'NWindow.UIAPI_EDITBOX'.static.SetString("ManorSeedInfoChangeWnd.ebTomorrowPrice", string(TomorrowPrice));
	m_MinCropPrice = MinCropPrice;
	m_MaxCropPrice = MaxCropPrice;
	ShowWindowWithFocus("ManorSeedInfoChangeWnd");
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus("ManorSeedInfoChangeWnd.ebTomorrowSalesVolume");
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnOk":
			OnClickBtnOk();
			break;
		case "btnCancel":
			HideWindow("ManorSeedInfoChangeWnd");
			break;
		default:
			break;
	}
	return;
}

function OnClickBtnOk()
{
	local INT64 InputTomorrowSalesVolume, InputTomorrowPrice;
	local string ParamString;

	InputTomorrowSalesVolume = INT64(Class'NWindow.UIAPI_EDITBOX'.static.GetString("ManorSeedInfoChangeWnd.ebTomorrowSalesVolume"));
	InputTomorrowPrice = INT64(Class'NWindow.UIAPI_EDITBOX'.static.GetString("ManorSeedInfoChangeWnd.ebTomorrowPrice"));
	if(((InputTomorrowSalesVolume < INT64(0)) || (InputTomorrowSalesVolume > m_TomorrowLimit)))
	{
		ShowErrorDialog(INT64(0), m_TomorrowLimit, 1558);
		return;
	}
	if(((InputTomorrowSalesVolume != INT64(0)) && ((InputTomorrowPrice < m_MinCropPrice) || (InputTomorrowPrice > m_MaxCropPrice))))
	{
		ShowErrorDialog(m_MinCropPrice, m_MaxCropPrice, 1557);
		return;
	}
	ParamAdd(ParamString, "TomorrowSalesVolume", string(InputTomorrowSalesVolume));
	ParamAdd(ParamString, "TomorrowPrice", string(InputTomorrowPrice));
	ExecuteEvent(2659, ParamString);
	HideWindow("ManorSeedInfoChangeWnd");
	return;
}

function ShowErrorDialog(INT64 MinValue, INT64 MaxValue, int SystemStringIdx)
{
	local string ParamString, Message;

	ParamAdd(ParamString, "Type", string(1));
	ParamAdd(ParamString, "param1", string(MinValue));
	AddSystemMessageParam(ParamString);
	ParamString = "";
	ParamAdd(ParamString, "Type", string(1));
	ParamAdd(ParamString, "param1", string(MaxValue));
	AddSystemMessageParam(ParamString);
	Message = EndSystemMessageParam(SystemStringIdx, true);
	DialogShow(DialogModalType_Modalless, DialogType_Notice, Message);
	return;
}
