class ManorCropInfoChangeWnd extends UICommonAPI;

var INT64 m_MinCropPrice;
var INT64 m_MaxCropPrice;
var INT64 m_TomorrowLimit;

function OnRegisterEvent()
{
	RegisterEvent(2670);
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
		case 2670:
			HandleShow(a_Param);
			break;
		default:
			break;
	}
	return;
}

function HandleShow(string a_Param)
{
	local string CropName;
	local INT64 TomorrowVolumeOfBuy, TomorrowLimit, TomorrowPrice;
	local int TomorrowProcure;
	local INT64 MinCropPrice, MaxCropPrice;
	local string TomorrowLimitString;

	ParseString(a_Param, "CropName", CropName);
	ParseINT64(a_Param, "TomorrowVolumeOfBuy", TomorrowVolumeOfBuy);
	ParseINT64(a_Param, "TomorrowLimit", TomorrowLimit);
	ParseINT64(a_Param, "TomorrowPrice", TomorrowPrice);
	ParseInt(a_Param, "TomorrowProcure", TomorrowProcure);
	ParseINT64(a_Param, "MinCropPrice", MinCropPrice);
	ParseINT64(a_Param, "MaxCropPrice", MaxCropPrice);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("ManorCropInfoChangeWnd.txtCropName", CropName);
	Class'NWindow.UIAPI_EDITBOX'.static.SetString("ManorCropInfoChangeWnd.ebTomorrowAmountOfPurchase", string(TomorrowVolumeOfBuy));
	m_TomorrowLimit = TomorrowLimit;
	TomorrowLimitString = MakeCostString(string(TomorrowLimit));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("ManorCropInfoChangeWnd.txtVarTomorrowPurchaseLimit", TomorrowLimitString);
	Class'NWindow.UIAPI_EDITBOX'.static.SetString("ManorCropInfoChangeWnd.ebTomorrowPurchasePrice", string(TomorrowPrice));
	if((TomorrowProcure == 0))
	{
		TomorrowProcure = 1;
	}
	Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("ManorCropInfoChangeWnd.cbTomorrowReward", (TomorrowProcure - 1));
	m_MinCropPrice = MinCropPrice;
	m_MaxCropPrice = MaxCropPrice;
	ShowWindowWithFocus("ManorCropInfoChangeWnd");
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus("ManorCropInfoChangeWnd.ebTomorrowAmountOfPurchase");
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
			HideWindow("ManorCropInfoChangeWnd");
			break;
		default:
			break;
	}
	return;
}

function OnClickBtnOk()
{
	local INT64 InputTomorrowAmountOfPurchase, InputTomorrowPurchasePrice;
	local int InputTomorrowProcure;
	local string Procure;
	local int selectedNum;
	local string ParamString;

	InputTomorrowAmountOfPurchase = INT64(Class'NWindow.UIAPI_EDITBOX'.static.GetString("ManorCropInfoChangeWnd.ebTomorrowAmountOfPurchase"));
	InputTomorrowPurchasePrice = INT64(Class'NWindow.UIAPI_EDITBOX'.static.GetString("ManorCropInfoChangeWnd.ebTomorrowPurchasePrice"));
	if(((InputTomorrowAmountOfPurchase < INT64(0)) || (InputTomorrowAmountOfPurchase > m_TomorrowLimit)))
	{
		ShowErrorDialog(INT64(0), m_TomorrowLimit, 1560);
		return;
	}
	if(((InputTomorrowAmountOfPurchase != INT64(0)) && ((InputTomorrowPurchasePrice < m_MinCropPrice) || (InputTomorrowPurchasePrice > m_MaxCropPrice))))
	{
		ShowErrorDialog(m_MinCropPrice, m_MaxCropPrice, 1559);
		return;
	}
	selectedNum = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum("ManorCropInfoChangeWnd.cbTomorrowReward");
	Procure = Class'NWindow.UIAPI_COMBOBOX'.static.GetString("ManorCropInfoChangeWnd.cbTomorrowReward", selectedNum);
	InputTomorrowProcure = int(Procure);
	ParamAdd(ParamString, "TomorrowAmountOfPurchase", string(InputTomorrowAmountOfPurchase));
	ParamAdd(ParamString, "TomorrowPurchasePrice", string(InputTomorrowPurchasePrice));
	ParamAdd(ParamString, "TomorrowProcure", string(InputTomorrowProcure));
	ExecuteEvent(2668, ParamString);
	HideWindow("ManorCropInfoChangeWnd");
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
