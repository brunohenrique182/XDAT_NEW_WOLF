class ErtheiaTestWnd extends UICommonAPI;

var WindowHandle Me;
var WindowHandle armorEnchantWindowHandle;
var ButtonHandle btnHide;
var ButtonHandle btnShowEdgeEffectWnd;
var EditBoxHandle editBlendingTime;
var EditBoxHandle editAlpha;
var EditBoxHandle editGray;
var SliderCtrlHandle sliderAlpha;
var SliderCtrlHandle sliderGray;
var EditBoxHandle editOffsetPercentage;
var SliderCtrlHandle sliderOffsetPercentage;
var EditBoxHandle editFistScale;
var SliderCtrlHandle sliderFistScale;
var ButtonHandle btnApply;
var ButtonHandle btnCancel;
var string ini;
var bool loadedINI;
var bool bHidden;
var string sectionEdgeEffect;
var string sectionWeapon;

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
	ini = "ErtheiaTestConfig.ini";
	loadedINI = false;
	bHidden = false;
	sectionEdgeEffect = "EdgeEffect";
	sectionWeapon = "Weapon";
	Me = GetWindowHandle("ErtheiaTestWnd");
	setWindowTitleByString("Ertheia Test");
	armorEnchantWindowHandle = GetWindowHandle("ArmorEnchantEffectTestWnd");
	btnHide = GetButtonHandle("ErtheiaTestWnd.ButtonHide");
	btnShowEdgeEffectWnd = GetButtonHandle("ErtheiaTestWnd.ButtonShowEdgeEffectWnd");
	editBlendingTime = GetEditBoxHandle("ErtheiaTestWnd.EditBoxBlendingTime");
	editAlpha = GetEditBoxHandle("ErtheiaTestWnd.EditBoxAlpha");
	editGray = GetEditBoxHandle("ErtheiaTestWnd.EditBoxGray");
	sliderAlpha = GetSliderCtrlHandle("ErtheiaTestWnd.SliderCtrlAlpha");
	sliderGray = GetSliderCtrlHandle("ErtheiaTestWnd.SliderCtrlGray");
	editOffsetPercentage = GetEditBoxHandle("ErtheiaTestWnd.EditBoxOffsetPercentage");
	sliderOffsetPercentage = GetSliderCtrlHandle("ErtheiaTestWnd.SliderCtrlOffsetPercentage");
	editFistScale = GetEditBoxHandle("ErtheiaTestWnd.EditBoxFistScale");
	sliderFistScale = GetSliderCtrlHandle("ErtheiaTestWnd.SliderCtrlFistScale");
	btnApply = GetButtonHandle("ErtheiaTestWnd.ApplyButton");
	btnCancel = GetButtonHandle("ErtheiaTestWnd.CancelButton");
	initValue();
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
		case "EditBoxAlpha":
			ivalue = int(editAlpha.GetString());
			sliderAlpha.SetCurrentTick(ivalue);
			break;
		case "EditBoxGray":
			ivalue = int(editGray.GetString());
			sliderGray.SetCurrentTick(ivalue);
			break;
		case "EditBoxOffsetPercentage":
			ivalue = int(editOffsetPercentage.GetString());
			sliderOffsetPercentage.SetCurrentTick(ivalue);
			break;
		case "EditBoxFistScale":
			ivalue = int((float(editFistScale.GetString()) * 100.0000000));
			sliderFistScale.SetCurrentTick(ivalue);
			break;
		default:
			break;
	}
	ApplyValue();
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "ButtonHide":
			if(bHidden)
			{
				bHidden = false;
				btnHide.SetNameText("은신");  // EN: stealth
				ExecuteCommand("///da type=116");
			}
			else
			{
				bHidden = true;
				btnHide.SetNameText("은신 해제");  // EN: stealth off
				ExecuteCommand("///aa type=116");
			}
			break;
		case "ButtonShowEdgeEffectWnd":
			if(armorEnchantWindowHandle.IsShowWindow())
			{
				armorEnchantWindowHandle.HideWindow();
			}
			else
			{
				armorEnchantWindowHandle.ShowWindow();
			}
			break;
		case "ApplyButton":
			ApplyValue();
			break;
		case "CancelButton":
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
	local float fvalue;
	local string Str;

	if((loadedINI == false))
	{
		return;
	}
	switch(strID)
	{
		case "SliderCtrlAlpha":
			ivalue = sliderAlpha.GetCurrentTick();
			Str = string(ivalue);
			editAlpha.SetString(Str);
			break;
		case "SliderCtrlGray":
			ivalue = sliderGray.GetCurrentTick();
			Str = string(ivalue);
			editGray.SetString(Str);
			break;
		case "SliderCtrlOffsetPercentage":
			ivalue = sliderOffsetPercentage.GetCurrentTick();
			Str = string(ivalue);
			editOffsetPercentage.SetString(Str);
			break;
		case "SliderCtrlFistScale":
			fvalue = (float(sliderFistScale.GetCurrentTick()) / 100.0000000);
			Str = string(fvalue);
			editFistScale.SetString(Str);
			break;
		default:
			break;
	}
	ApplyValue();
	return;
}

function OnShow()
{
	return;
}

function initValue()
{
	local int ivalue;
	local float fvalue;

	RefreshINI(ini);
	GetINIFloat(sectionEdgeEffect, "BlendingTime", fvalue, ini);
	editBlendingTime.SetString(string(fvalue));
	GetINIInt(sectionEdgeEffect, "Alpha", ivalue, ini);
	editAlpha.SetString(string(ivalue));
	GetINIInt(sectionEdgeEffect, "Gray", ivalue, ini);
	editGray.SetString(string(ivalue));
	ivalue = int(editAlpha.GetString());
	sliderAlpha.SetCurrentTick(ivalue);
	ivalue = int(editGray.GetString());
	sliderGray.SetCurrentTick(ivalue);
	if(!GetINIInt(sectionWeapon, "OffsetPercentage", ivalue, ini))
	{
		ivalue = 45;
	}
	editOffsetPercentage.SetString(string(ivalue));
	ivalue = int(editOffsetPercentage.GetString());
	sliderOffsetPercentage.SetCurrentTick(ivalue);
	if(!GetINIFloat(sectionWeapon, "FistScale", fvalue, ini))
	{
		fvalue = 1.0000000;
	}
	editFistScale.SetString(string(fvalue));
	ivalue = int((float(editFistScale.GetString()) * 100.0000000));
	sliderFistScale.SetCurrentTick(ivalue);
	loadedINI = true;
	return;
}

function ApplyValue()
{
	local float BlendingTime;
	local int alphavalue, grayValue, staffOffsetPercentage;
	local float fistScale;

	if((loadedINI == false))
	{
		return;
	}
	BlendingTime = float(editBlendingTime.GetString());
	alphavalue = int(editAlpha.GetString());
	grayValue = int(editGray.GetString());
	staffOffsetPercentage = int(editOffsetPercentage.GetString());
	fistScale = float(editFistScale.GetString());
	SetINIFloat(sectionEdgeEffect, "BlendingTime", BlendingTime, ini);
	SetINIInt(sectionEdgeEffect, "Alpha", alphavalue, ini);
	SetINIInt(sectionEdgeEffect, "Gray", grayValue, ini);
	SetINIInt(sectionWeapon, "OffsetPercentage", staffOffsetPercentage, ini);
	SetINIFloat(sectionWeapon, "FistScale", fistScale, ini);
	RefreshINI(ini);
	return;
}
