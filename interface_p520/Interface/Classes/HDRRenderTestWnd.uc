class HDRRenderTestWnd extends UICommonAPI;

const TICK_INTERVAL = 10000.0f;

var WindowHandle Me;
var CheckBoxHandle btnUse;
var CheckBoxHandle btnPreview;
var EditBoxHandle editExposure;
var EditBoxHandle editGamma;
var EditBoxHandle editAvgLumMin;
var EditBoxHandle editAvgLumMax;
var SliderCtrlHandle sliderExposure;
var SliderCtrlHandle sliderGamma;
var SliderCtrlHandle sliderAvgLumMin;
var SliderCtrlHandle sliderAvgLumMax;
var ButtonHandle btnOk;
var ButtonHandle btnCancle;
var bool PreUseHDR;
var float PreExposure;
var float PreGamma;
var float PreAvgLumMin;
var float PreAvgLumMax;

function OnRegisterEvent()
{
	RegisterEvent(5050);
	return;
}

function OnLoad()
{
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("HDRRenderTestWnd");
	setWindowTitleByString("HDR Conversion");
	btnUse = GetCheckBoxHandle("HDRRenderTestWnd.UseCheckBox");
	btnPreview = GetCheckBoxHandle("HDRRenderTestWnd.PreviewCheckBox");
	editExposure = GetEditBoxHandle("HDRRenderTestWnd.ExposureEditBox");
	editGamma = GetEditBoxHandle("HDRRenderTestWnd.GammaEditBox");
	editAvgLumMin = GetEditBoxHandle("HDRRenderTestWnd.AvgLumMinEditBox");
	editAvgLumMax = GetEditBoxHandle("HDRRenderTestWnd.AvgLumMaxEditBox");
	sliderExposure = GetSliderCtrlHandle("HDRRenderTestWnd.ExposureSliderCtrl");
	sliderGamma = GetSliderCtrlHandle("HDRRenderTestWnd.GammaSliderCtrl");
	sliderAvgLumMin = GetSliderCtrlHandle("HDRRenderTestWnd.AvgLumMinSliderCtrl");
	sliderAvgLumMax = GetSliderCtrlHandle("HDRRenderTestWnd.AvgLumMaxSliderCtrl");
	btnOk = GetButtonHandle("HDRRenderTestWnd.OkButton");
	btnCancle = GetButtonHandle("HDRRenderTestWnd.CancleButton");
	PreExposure = 0.0000000;
	PreGamma = 0.0000000;
	PreAvgLumMin = 0.0000000;
	PreAvgLumMax = 0.0000000;
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int useHDR;
	local float exposure, Gamma, avgLumMin, avgLumMax;

	if((Event_ID == 5050))
	{
		ParseInt(param, "UseHDR", useHDR);
		ParseFloat(param, "FinalCoef", exposure);
		ParseFloat(param, "GrayLum", Gamma);
		ParseFloat(param, "ClampMin", avgLumMin);
		ParseFloat(param, "ClampMax", avgLumMax);
		InitHDRValue(bool(useHDR), exposure, Gamma, avgLumMin, avgLumMax);
		btnUse.SetCheck(true);
		btnPreview.SetCheck(true);
		Me.ShowWindow();
		SetUseHDRRenderEffect(true);
	}
	return;
}

function OnCompleteEditBox(string strID)
{
	local float Value;
	local int Tick;

	switch(strID)
	{
		case "ExposureEditBox":
			Value = float(editExposure.GetString());
			Tick = int((Value * 10000.0000000));
			sliderExposure.SetCurrentTick(Tick);
			break;
		case "GammaEditBox":
			Value = float(editGamma.GetString());
			Tick = int((Value * 10000.0000000));
			sliderGamma.SetCurrentTick(Tick);
			break;
		case "AvgLumMinEditBox":
			Value = float(editAvgLumMin.GetString());
			Tick = int((Value * 10000.0000000));
			sliderAvgLumMin.SetCurrentTick(Tick);
			break;
		case "AvgLumMaxEditBox":
			Value = float(editAvgLumMax.GetString());
			Tick = int((Value * 10000.0000000));
			sliderAvgLumMax.SetCurrentTick(Tick);
			break;
		default:
			break;
	}
	if(btnPreview.IsChecked())
	{
		ApplyHDRValue();
	}
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "OkButton":
			ApplyHDRValue();
			Me.HideWindow();
			break;
		case "CancleButton":
			RestoreHDRValue();
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
	local float Value;
	local string Str;

	switch(strID)
	{
		case "ExposureSliderCtrl":
			Value = (float(sliderExposure.GetCurrentTick()) / 10000.0000000);
			Str = string(Value);
			editExposure.SetString(Str);
			break;
		case "GammaSliderCtrl":
			Value = (float(sliderGamma.GetCurrentTick()) / 10000.0000000);
			Str = string(Value);
			editGamma.SetString(Str);
			break;
		case "AvgLumMinSliderCtrl":
			Value = (float(sliderAvgLumMin.GetCurrentTick()) / 10000.0000000);
			Str = string(Value);
			editAvgLumMin.SetString(Str);
			break;
		case "AvgLumMaxSliderCtrl":
			Value = (float(sliderAvgLumMax.GetCurrentTick()) / 10000.0000000);
			Str = string(Value);
			editAvgLumMax.SetString(Str);
			break;
		default:
			break;
	}
	if(btnPreview.IsChecked())
	{
		ApplyHDRValue();
	}
	return;
}

function OnClickCheckBox(string strID)
{
	switch(strID)
	{
		case "UseCheckBox":
			SetUseHDRRenderEffect(btnUse.IsChecked());
			break;
		default:
			break;
	}
	if(btnPreview.IsChecked())
	{
		ApplyHDRValue();
	}
	return;
}

function RestoreHDRValue()
{
	SetUseHDRRenderEffect(PreUseHDR);
	SetHDRRenderVal(PreExposure, PreGamma, PreAvgLumMin, PreAvgLumMax);
	return;
}

function InitHDRValue(bool useHDR, float exposure, float Gamma, float avgLumMin, float avgLumMax)
{
	PreUseHDR = useHDR;
	PreExposure = exposure;
	PreGamma = Gamma;
	PreAvgLumMin = avgLumMin;
	PreAvgLumMax = avgLumMax;
	editExposure.SetString(string(PreExposure));
	editGamma.SetString(string(PreGamma));
	editAvgLumMin.SetString(string(PreAvgLumMin));
	editAvgLumMax.SetString(string(PreAvgLumMax));
	sliderExposure.SetCurrentTick(int((PreExposure * 10000.0000000)));
	sliderGamma.SetCurrentTick(int((PreGamma * 10000.0000000)));
	sliderAvgLumMin.SetCurrentTick(int((PreAvgLumMin * 10000.0000000)));
	sliderAvgLumMax.SetCurrentTick(int((PreAvgLumMax * 10000.0000000)));
	return;
}

function ApplyHDRValue()
{
	local float exposure, Gamma, avgLumMin, avgLumMax;

	exposure = float(editExposure.GetString());
	Gamma = float(editGamma.GetString());
	avgLumMin = float(editAvgLumMin.GetString());
	avgLumMax = float(editAvgLumMax.GetString());
	SetHDRRenderVal(exposure, Gamma, avgLumMin, avgLumMax);
	return;
}
