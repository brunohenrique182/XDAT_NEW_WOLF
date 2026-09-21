class ArmorEnchantEffectTestWnd extends UICommonAPI;

var WindowHandle Me;
var CheckBoxHandle btnUseMask;
var CheckBoxHandle btnShowEffect;
var CheckBoxHandle btnTimeAppear;
var EditBoxHandle editFadeTime;
var EditBoxHandle editShowTime;
var EditBoxHandle editHideTime;
var EditBoxHandle editColorMaxRed;
var EditBoxHandle editColorMaxGreen;
var EditBoxHandle editColorMaxBlue;
var EditBoxHandle editColorMaxAlpha;
var EditBoxHandle editColorMinRed;
var EditBoxHandle editColorMinGreen;
var EditBoxHandle editColorMinBlue;
var EditBoxHandle editColorMinAlpha;
var SliderCtrlHandle sliderColorMaxRed;
var SliderCtrlHandle sliderColorMaxGreen;
var SliderCtrlHandle sliderColorMaxBlue;
var SliderCtrlHandle sliderColorMaxAlpha;
var SliderCtrlHandle sliderColorMinRed;
var SliderCtrlHandle sliderColorMinGreen;
var SliderCtrlHandle sliderColorMinBlue;
var SliderCtrlHandle sliderColorMinAlpha;
var EditBoxHandle editNoiseScale;
var EditBoxHandle editNoisePanSpeed;
var EditBoxHandle editNoiseRate;
var EditBoxHandle editExtrudeMeshPeak;
var EditBoxHandle editExtrudeMeshSharp;
var EditBoxHandle editExtrudeMeshScale;
var ButtonHandle btnOk;
var ButtonHandle btnCancle;
var string ini;
var bool loadedINI;

function OnRegisterEvent()
{
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
	ini = "ArmorEnchantEffectConfig.ini";
	loadedINI = false;
	Me = GetWindowHandle("ArmorEnchantEffectTestWnd");
	setWindowTitleByString("Armor Enchant Effect");
	btnUseMask = GetCheckBoxHandle("ArmorEnchantEffectTestWnd.UseMaskCheckBox");
	btnShowEffect = GetCheckBoxHandle("ArmorEnchantEffectTestWnd.ShowEffectCheckBox");
	btnTimeAppear = GetCheckBoxHandle("ArmorEnchantEffectTestWnd.TimeAppearCheckBox");
	editFadeTime = GetEditBoxHandle("ArmorEnchantEffectTestWnd.FadeTimeEditBox");
	editShowTime = GetEditBoxHandle("ArmorEnchantEffectTestWnd.ShowTimeEditBox");
	editHideTime = GetEditBoxHandle("ArmorEnchantEffectTestWnd.HideTimeEditBox");
	editColorMaxRed = GetEditBoxHandle("ArmorEnchantEffectTestWnd.ColorMaxRedEditBox");
	editColorMaxGreen = GetEditBoxHandle("ArmorEnchantEffectTestWnd.ColorMaxGreenEditBox");
	editColorMaxBlue = GetEditBoxHandle("ArmorEnchantEffectTestWnd.ColorMaxBlueEditBox");
	editColorMaxAlpha = GetEditBoxHandle("ArmorEnchantEffectTestWnd.ColorMaxAlphaEditBox");
	editColorMinRed = GetEditBoxHandle("ArmorEnchantEffectTestWnd.ColorMinRedEditBox");
	editColorMinGreen = GetEditBoxHandle("ArmorEnchantEffectTestWnd.ColorMinGreenEditBox");
	editColorMinBlue = GetEditBoxHandle("ArmorEnchantEffectTestWnd.ColorMinBlueEditBox");
	editColorMinAlpha = GetEditBoxHandle("ArmorEnchantEffectTestWnd.ColorMinAlphaEditBox");
	sliderColorMaxRed = GetSliderCtrlHandle("ArmorEnchantEffectTestWnd.ColorMaxRedSliderCtrl");
	sliderColorMaxGreen = GetSliderCtrlHandle("ArmorEnchantEffectTestWnd.ColorMaxGreenSliderCtrl");
	sliderColorMaxBlue = GetSliderCtrlHandle("ArmorEnchantEffectTestWnd.ColorMaxBlueSliderCtrl");
	sliderColorMaxAlpha = GetSliderCtrlHandle("ArmorEnchantEffectTestWnd.ColorMaxAlphaSliderCtrl");
	sliderColorMinRed = GetSliderCtrlHandle("ArmorEnchantEffectTestWnd.ColorMinRedSliderCtrl");
	sliderColorMinGreen = GetSliderCtrlHandle("ArmorEnchantEffectTestWnd.ColorMinGreenSliderCtrl");
	sliderColorMinBlue = GetSliderCtrlHandle("ArmorEnchantEffectTestWnd.ColorMinBlueSliderCtrl");
	sliderColorMinAlpha = GetSliderCtrlHandle("ArmorEnchantEffectTestWnd.ColorMinAlphaSliderCtrl");
	editNoiseScale = GetEditBoxHandle("ArmorEnchantEffectTestWnd.NoiseScaleEditBox");
	editNoisePanSpeed = GetEditBoxHandle("ArmorEnchantEffectTestWnd.NoisePanSpeedEditBox");
	editNoiseRate = GetEditBoxHandle("ArmorEnchantEffectTestWnd.NoiseRateEditBox");
	editExtrudeMeshPeak = GetEditBoxHandle("ArmorEnchantEffectTestWnd.ExtrudeMeshPeakEditBox");
	editExtrudeMeshSharp = GetEditBoxHandle("ArmorEnchantEffectTestWnd.ExtrudeMeshSharpEditBox");
	editExtrudeMeshScale = GetEditBoxHandle("ArmorEnchantEffectTestWnd.ExtrudeMeshScaleEditBox");
	btnOk = GetButtonHandle("ArmorEnchantEffectTestWnd.OkButton");
	btnCancle = GetButtonHandle("ArmorEnchantEffectTestWnd.CancleButton");
	InitEnchantValue();
	return;
}

function OnEvent(int Event_ID, string param)
{
	return;
}

function OnCompleteEditBox(string strID)
{
	local int ivalue;

	switch(strID)
	{
		case "ColorMaxRedEditBox":
			ivalue = int(editColorMaxRed.GetString());
			sliderColorMaxRed.SetCurrentTick(ivalue);
			break;
		case "ColorMaxGreenEditBox":
			ivalue = int(editColorMaxGreen.GetString());
			sliderColorMaxGreen.SetCurrentTick(ivalue);
			break;
		case "ColorMaxBlueEditBox":
			ivalue = int(editColorMaxBlue.GetString());
			sliderColorMaxBlue.SetCurrentTick(ivalue);
			break;
		case "ColorMaxAlphaEditBox":
			ivalue = int(editColorMaxAlpha.GetString());
			sliderColorMaxAlpha.SetCurrentTick(ivalue);
			break;
		case "ColorMinRedEditBox":
			ivalue = int(editColorMinRed.GetString());
			sliderColorMinRed.SetCurrentTick(ivalue);
			break;
		case "ColorMinGreenEditBox":
			ivalue = int(editColorMinGreen.GetString());
			sliderColorMinGreen.SetCurrentTick(ivalue);
			break;
		case "ColorMinBlueEditBox":
			ivalue = int(editColorMinBlue.GetString());
			sliderColorMinBlue.SetCurrentTick(ivalue);
			break;
		case "ColorMinAlphaEditBox":
			ivalue = int(editColorMinAlpha.GetString());
			sliderColorMinAlpha.SetCurrentTick(ivalue);
			break;
		default:
			break;
	}
	ApplyEnchantValue();
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "OkButton":
			Me.HideWindow();
			break;
		case "CancleButton":
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
	local int ivalue;
	local string Str;

	if((loadedINI == false))
	{
		return;
	}
	switch(strID)
	{
		case "ColorMaxRedSliderCtrl":
			ivalue = sliderColorMaxRed.GetCurrentTick();
			Str = string(ivalue);
			editColorMaxRed.SetString(Str);
			break;
		case "ColorMaxGreenSliderCtrl":
			ivalue = sliderColorMaxGreen.GetCurrentTick();
			Str = string(ivalue);
			editColorMaxGreen.SetString(Str);
			break;
		case "ColorMaxBlueSliderCtrl":
			ivalue = sliderColorMaxBlue.GetCurrentTick();
			Str = string(ivalue);
			editColorMaxBlue.SetString(Str);
			break;
		case "ColorMaxAlphaSliderCtrl":
			ivalue = sliderColorMaxAlpha.GetCurrentTick();
			Str = string(ivalue);
			editColorMaxAlpha.SetString(Str);
			break;
		case "ColorMinRedSliderCtrl":
			ivalue = sliderColorMinRed.GetCurrentTick();
			Str = string(ivalue);
			editColorMinRed.SetString(Str);
			break;
		case "ColorMinGreenSliderCtrl":
			ivalue = sliderColorMinGreen.GetCurrentTick();
			Str = string(ivalue);
			editColorMinGreen.SetString(Str);
			break;
		case "ColorMinBlueSliderCtrl":
			ivalue = sliderColorMinBlue.GetCurrentTick();
			Str = string(ivalue);
			editColorMinBlue.SetString(Str);
			break;
		case "ColorMinAlphaSliderCtrl":
			ivalue = sliderColorMinAlpha.GetCurrentTick();
			Str = string(ivalue);
			editColorMinAlpha.SetString(Str);
			break;
		default:
			break;
	}
	ApplyEnchantValue();
	return;
}

function OnClickCheckBox(string strID)
{
	switch(strID)
	{
		case "UseMaskCheckBox":
			SetINIBool("DISPLAY", "UseMask", btnUseMask.IsChecked(), ini);
			RefreshINI(ini);
			ExecuteCommand("///ArmorEnchant apply");
			break;
		case "ShowEffectCheckBox":
			SetINIBool("DISPLAY", "ShowEffect", btnShowEffect.IsChecked(), ini);
			RefreshINI(ini);
			ExecuteCommand("///ArmorEnchant apply");
			break;
		case "TimeAppearCheckBox":
			SetINIBool("DISPLAY", "TimeAppear", btnTimeAppear.IsChecked(), ini);
			RefreshINI(ini);
			ExecuteCommand("///ArmorEnchant apply");
			break;
		default:
			break;
	}
	return;
}

function OnShow()
{
	return;
}

function InitEnchantValue()
{
	local int ivalue;
	local float fvalue;

	RefreshINI(ini);
	GetINIBool("DISPLAY", "UseMask", ivalue, ini);
	btnUseMask.SetCheck(bool(ivalue));
	GetINIBool("DISPLAY", "ShowEffect", ivalue, ini);
	btnShowEffect.SetCheck(bool(ivalue));
	GetINIBool("DISPLAY", "TimeAppear", ivalue, ini);
	btnTimeAppear.SetCheck(bool(ivalue));
	GetINIFloat("DISPLAY", "FadeTime", fvalue, ini);
	editFadeTime.SetString(string(fvalue));
	GetINIFloat("DISPLAY", "ShowTime", fvalue, ini);
	editShowTime.SetString(string(fvalue));
	GetINIFloat("DISPLAY", "HideTime", fvalue, ini);
	editHideTime.SetString(string(fvalue));
	GetINIInt("Enchant0", "ColorMax_R", ivalue, ini);
	editColorMaxRed.SetString(string(ivalue));
	GetINIInt("Enchant0", "ColorMax_G", ivalue, ini);
	editColorMaxGreen.SetString(string(ivalue));
	GetINIInt("Enchant0", "ColorMax_B", ivalue, ini);
	editColorMaxBlue.SetString(string(ivalue));
	GetINIInt("Enchant0", "ColorMax_A", ivalue, ini);
	editColorMaxAlpha.SetString(string(ivalue));
	GetINIInt("Enchant0", "ColorMin_R", ivalue, ini);
	editColorMinRed.SetString(string(ivalue));
	GetINIInt("Enchant0", "ColorMin_G", ivalue, ini);
	editColorMinGreen.SetString(string(ivalue));
	GetINIInt("Enchant0", "ColorMin_B", ivalue, ini);
	editColorMinBlue.SetString(string(ivalue));
	GetINIInt("Enchant0", "ColorMin_A", ivalue, ini);
	editColorMinAlpha.SetString(string(ivalue));
	GetINIFloat("Enchant0", "NoiseScale", fvalue, ini);
	editNoiseScale.SetString(string(fvalue));
	GetINIFloat("Enchant0", "NoisePanSpeed", fvalue, ini);
	editNoisePanSpeed.SetString(string(fvalue));
	GetINIFloat("Enchant0", "NoiseRate", fvalue, ini);
	editNoiseRate.SetString(string(fvalue));
	GetINIFloat("Enchant0", "ExtrudeMeshPeak", fvalue, ini);
	editExtrudeMeshPeak.SetString(string(fvalue));
	GetINIFloat("Enchant0", "ExtrudeMeshSharp", fvalue, ini);
	editExtrudeMeshSharp.SetString(string(fvalue));
	GetINIFloat("Enchant0", "ExtrudeMeshScale", fvalue, ini);
	editExtrudeMeshScale.SetString(string(fvalue));
	ivalue = int(editColorMaxRed.GetString());
	sliderColorMaxRed.SetCurrentTick(ivalue);
	ivalue = int(editColorMaxGreen.GetString());
	sliderColorMaxGreen.SetCurrentTick(ivalue);
	ivalue = int(editColorMaxBlue.GetString());
	sliderColorMaxBlue.SetCurrentTick(ivalue);
	ivalue = int(editColorMaxAlpha.GetString());
	sliderColorMaxAlpha.SetCurrentTick(ivalue);
	ivalue = int(editColorMinRed.GetString());
	sliderColorMinRed.SetCurrentTick(ivalue);
	ivalue = int(editColorMinGreen.GetString());
	sliderColorMinGreen.SetCurrentTick(ivalue);
	ivalue = int(editColorMinBlue.GetString());
	sliderColorMinBlue.SetCurrentTick(ivalue);
	ivalue = int(editColorMinAlpha.GetString());
	sliderColorMinAlpha.SetCurrentTick(ivalue);
	loadedINI = true;
	return;
}

function ApplyEnchantValue()
{
	local float FadeTime, ShowTime, HideTime;
	local int colorMaxRed, colorMaxGreen, colorMaxBlue, colorMaxAlpha, colorMinRed, colorMinGreen, colorMinBlue, colorMinAlpha;
	local float noiseScale, noisePanSpeed, noiseRate, extrudeMeshPeak, extrudeMeshSharp, extrudeMeshScale;

	if((loadedINI == false))
	{
		return;
	}
	FadeTime = float(editFadeTime.GetString());
	ShowTime = float(editShowTime.GetString());
	HideTime = float(editHideTime.GetString());
	colorMaxRed = int(editColorMaxRed.GetString());
	colorMaxGreen = int(editColorMaxGreen.GetString());
	colorMaxBlue = int(editColorMaxBlue.GetString());
	colorMaxAlpha = int(editColorMaxAlpha.GetString());
	colorMinRed = int(editColorMinRed.GetString());
	colorMinGreen = int(editColorMinGreen.GetString());
	colorMinBlue = int(editColorMinBlue.GetString());
	colorMinAlpha = int(editColorMinAlpha.GetString());
	noiseScale = float(editNoiseScale.GetString());
	noisePanSpeed = float(editNoisePanSpeed.GetString());
	noiseRate = float(editNoiseRate.GetString());
	extrudeMeshPeak = float(editExtrudeMeshPeak.GetString());
	extrudeMeshSharp = float(editExtrudeMeshSharp.GetString());
	extrudeMeshScale = float(editExtrudeMeshScale.GetString());
	SetINIFloat("DISPLAY", "FadeTime", FadeTime, ini);
	SetINIFloat("DISPLAY", "ShowTime", ShowTime, ini);
	SetINIFloat("DISPLAY", "HideTime", HideTime, ini);
	SetINIInt("Enchant0", "ColorMax_R", colorMaxRed, ini);
	SetINIInt("Enchant0", "ColorMax_G", colorMaxGreen, ini);
	SetINIInt("Enchant0", "ColorMax_B", colorMaxBlue, ini);
	SetINIInt("Enchant0", "ColorMax_A", colorMaxAlpha, ini);
	SetINIInt("Enchant0", "ColorMin_R", colorMinRed, ini);
	SetINIInt("Enchant0", "ColorMin_G", colorMinGreen, ini);
	SetINIInt("Enchant0", "ColorMin_B", colorMinBlue, ini);
	SetINIInt("Enchant0", "ColorMin_A", colorMinAlpha, ini);
	SetINIFloat("Enchant0", "NoiseScale", noiseScale, ini);
	SetINIFloat("Enchant0", "NoisePanSpeed", noisePanSpeed, ini);
	SetINIFloat("Enchant0", "NoiseRate", noiseRate, ini);
	SetINIFloat("Enchant0", "ExtrudeMeshPeak", extrudeMeshPeak, ini);
	SetINIFloat("Enchant0", "ExtrudeMeshSharp", extrudeMeshSharp, ini);
	SetINIFloat("Enchant0", "ExtrudeMeshScale", extrudeMeshScale, ini);
	RefreshINI(ini);
	ExecuteCommand("///ArmorEnchant apply");
	return;
}
