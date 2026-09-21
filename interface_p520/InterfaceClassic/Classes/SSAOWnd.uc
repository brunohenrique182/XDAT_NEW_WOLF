class SSAOWnd extends UICommonAPI;

var WindowHandle Me;
var ComboBoxHandle cboLevel;
var ComboBoxHandle cboBlend;
var SliderCtrlHandle barStrength;
var SliderCtrlHandle barMaxIntensity;
var SliderCtrlHandle barFadeFront;
var SliderCtrlHandle barDepth;
var SliderCtrlHandle barNoise;
var SliderCtrlHandle barDistance;
var SliderCtrlHandle barBlur;
var SliderCtrlHandle barBlurDepth;
var SliderCtrlHandle barBlurNormal;
var EditBoxHandle txtStrength;
var EditBoxHandle txtMaxIntensity;
var EditBoxHandle txtFadeFront;
var EditBoxHandle txtDepth;
var EditBoxHandle txtDistance;
var EditBoxHandle txtNoise;
var EditBoxHandle txtBlur;
var EditBoxHandle txtBlurDepth;
var EditBoxHandle txtBlurNormal;
var int m_OldLevel;

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	Initialize();
	Load();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("SSAOWnd");
	cboLevel = GetComboBoxHandle("SSAOWnd.cboLevel");
	cboBlend = GetComboBoxHandle("SSAOWnd.cboBlend");
	barNoise = GetSliderCtrlHandle("SSAOWnd.barNoise");
	barMaxIntensity = GetSliderCtrlHandle("SSAOWnd.barMaxIntensity");
	barStrength = GetSliderCtrlHandle("SSAOWnd.barStrength");
	barFadeFront = GetSliderCtrlHandle("SSAOWnd.barFadeFront");
	barDepth = GetSliderCtrlHandle("SSAOWnd.barDepth");
	barDistance = GetSliderCtrlHandle("SSAOWnd.barDistance");
	barBlur = GetSliderCtrlHandle("SSAOWnd.barBlur");
	barBlurDepth = GetSliderCtrlHandle("SSAOWnd.barBlurDepth");
	barBlurNormal = GetSliderCtrlHandle("SSAOWnd.barBlurNormal");
	txtStrength = GetEditBoxHandle("SSAOWnd.txtStrength");
	txtMaxIntensity = GetEditBoxHandle("SSAOWnd.txtMaxIntensity");
	txtFadeFront = GetEditBoxHandle("SSAOWnd.txtFadeFront");
	txtDepth = GetEditBoxHandle("SSAOWnd.txtDepth");
	txtDistance = GetEditBoxHandle("SSAOWnd.txtDistance");
	txtNoise = GetEditBoxHandle("SSAOWnd.txtNoise");
	txtBlur = GetEditBoxHandle("SSAOWnd.txtBlur");
	txtBlurDepth = GetEditBoxHandle("SSAOWnd.txtBlurDepth");
	txtBlurNormal = GetEditBoxHandle("SSAOWnd.txtBlurNormal");
	setWindowTitleByString("SSAO");
	m_OldLevel = 0;
	return;
}

function Load()
{
	OnbtnInitClick();
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "btnInit":
			OnbtnInitClick();
			break;
		case "btnOnOff":
			OnbtnOnOffClick();
			break;
		default:
			break;
	}
	return;
}

function OnComboBoxItemSelected(string Name, int Index)
{
	switch(Name)
	{
		case "cboLevel":
			SetL2Shader(true);
			Class'NWindow.SSAOAPI'.static.SSAO_Level(Index);
			m_OldLevel = Index;
			break;
		case "cboBlend":
			Class'NWindow.SSAOAPI'.static.SSAO_Blend(Index);
			break;
		default:
			break;
	}
	return;
}

function OnModifyCurrentTickSliderCtrl(string Name, int Step)
{
	switch(Name)
	{
		case "barStrength":
			ApplyStrength(Step);
			break;
		case "barMaxIntensity":
			ApplyMaxIntensity(Step);
			break;
		case "barFadeFront":
			ApplyFadeFront(Step);
			break;
		case "barDepth":
			ApplyDepth(Step);
			break;
		case "barNoise":
			ApplyNoise(Step);
			break;
		case "barDistance":
			ApplyDistance(Step);
			break;
		case "barBlur":
			ApplyBlur(Step);
			break;
		case "barBlurDepth":
			ApplyBlurDepth(Step);
			break;
		case "barBlurNormal":
			ApplyBlurNormal(Step);
			break;
		default:
			break;
	}
	return;
}

function OnCompleteEditBox(string Name)
{
	local string Text;

	switch(Name)
	{
		case "txtStrength":
			Text = txtStrength.GetString();
			Class'NWindow.SSAOAPI'.static.SSAO_Strength(float(Text));
			break;
		case "txtMaxIntensity":
			Text = txtMaxIntensity.GetString();
			Class'NWindow.SSAOAPI'.static.SSAO_MaxIntensity(float(Text));
			break;
		case "txtFadeFront":
			Text = txtFadeFront.GetString();
			Class'NWindow.SSAOAPI'.static.SSAO_FadeFront(float(Text));
			break;
		case "txtDepth":
			Text = txtDepth.GetString();
			Class'NWindow.SSAOAPI'.static.SSAO_DepthDifference(float(Text));
			break;
		case "txtNoise":
			Text = txtNoise.GetString();
			Class'NWindow.SSAOAPI'.static.SSAO_NoiseScale(float(Text));
			break;
		case "txtDistance":
			Text = txtDistance.GetString();
			Class'NWindow.SSAOAPI'.static.SSAO_SampleDistance(float(Text));
			break;
		case "txtBlur":
			Text = txtBlur.GetString();
			Class'NWindow.SSAOAPI'.static.SSAO_BlurIntensity(float(Text));
			break;
		case "txtBlurDepth":
			Text = txtBlurDepth.GetString();
			Class'NWindow.SSAOAPI'.static.SSAO_BlurDepthDifference(float(Text));
			break;
		case "txtBlurNormal":
			Text = txtBlurNormal.GetString();
			Class'NWindow.SSAOAPI'.static.SSAO_BlurNormalDifference(float(Text));
			break;
		default:
			break;
	}
	return;
}

function OnbtnInitClick()
{
	barStrength.SetCurrentTick(5);
	barMaxIntensity.SetCurrentTick(5);
	barFadeFront.SetCurrentTick(5);
	barDepth.SetCurrentTick(5);
	barNoise.SetCurrentTick(5);
	barDistance.SetCurrentTick(5);
	barBlur.SetCurrentTick(5);
	barBlurDepth.SetCurrentTick(5);
	barBlurNormal.SetCurrentTick(5);
	return;
}

function OnbtnOnOffClick()
{
	local int Index;

	Index = cboLevel.GetSelectedNum();
	if(((Index == 0) && (m_OldLevel > 0)))
	{
		SetL2Shader(true);
		cboLevel.SetSelectedNum(m_OldLevel);
		Class'NWindow.SSAOAPI'.static.SSAO_Level(m_OldLevel);
	}
	else
	{
		cboLevel.SetSelectedNum(0);
		Class'NWindow.SSAOAPI'.static.SSAO_Level(0);
	}
	return;
}

function ApplyStrength(int Step)
{
	local float Value;

	Value = (float(Step) / 5.0000000);
	Class'NWindow.SSAOAPI'.static.SSAO_Strength(Value);
	txtStrength.SetString(string(Value));
	return;
}

function ApplyMaxIntensity(int Step)
{
	local float Value;

	switch(Step)
	{
		case 0:
			Value = 0.1000000;
			break;
		case 1:
			Value = 0.2000000;
			break;
		case 2:
			Value = 0.3000000;
			break;
		case 3:
			Value = 0.4000000;
			break;
		case 4:
			Value = 0.5000000;
			break;
		case 5:
			Value = 0.6000000;
			break;
		case 6:
			Value = 0.6500000;
			break;
		case 7:
			Value = 0.7000000;
			break;
		case 8:
			Value = 0.8000000;
			break;
		case 9:
			Value = 0.9000000;
			break;
		case 10:
			Value = 1.0000000;
			break;
		default:
			break;
	}
	Class'NWindow.SSAOAPI'.static.SSAO_MaxIntensity(Value);
	txtMaxIntensity.SetString(string(Value));
	return;
}

function ApplyFadeFront(int Step)
{
	local float Value;

	switch(Step)
	{
		case 0:
			Value = 1.0000000;
			break;
		case 1:
			Value = 256.0000000;
			break;
		case 2:
			Value = 512.0000000;
			break;
		case 3:
			Value = 768.0000000;
			break;
		case 4:
			Value = 1024.0000000;
			break;
		case 5:
			Value = 1280.0000000;
			break;
		case 6:
			Value = 2000.0000000;
			break;
		case 7:
			Value = 3000.0000000;
			break;
		case 8:
			Value = 4000.0000000;
			break;
		case 9:
			Value = 5000.0000000;
			break;
		case 10:
			Value = 6000.0000000;
			break;
		default:
			break;
	}
	Class'NWindow.SSAOAPI'.static.SSAO_FadeFront(Value);
	txtFadeFront.SetString(string(Value));
	return;
}

function ApplyDepth(int Step)
{
	local float Value;
	local string Str;

	switch(Step)
	{
		case 0:
			Value = 0.0000100;
			Str = "0.00001";
			break;
		case 1:
			Value = 0.0000500;
			Str = "0.00005";
			break;
		case 2:
			Value = 0.0001000;
			Str = "0.0001";
			break;
		case 3:
			Value = 0.0005000;
			Str = "0.0005";
			break;
		case 4:
			Value = 0.0010000;
			Str = "0.001";
			break;
		case 5:
			Value = 0.0050000;
			Str = "0.005";
			break;
		case 6:
			Value = 0.0100000;
			Str = "0.01";
			break;
		case 7:
			Value = 0.0500000;
			Str = "0.05";
			break;
		case 8:
			Value = 0.1000000;
			Str = "0.1";
			break;
		case 9:
			Value = 0.2500000;
			Str = "0.25";
			break;
		case 10:
			Value = 0.5000000;
			Str = "0.5";
			break;
		default:
			break;
	}
	Class'NWindow.SSAOAPI'.static.SSAO_DepthDifference(Value);
	txtDepth.SetString(Str);
	return;
}

function ApplyNoise(int Step)
{
	local float Value;

	switch(Step)
	{
		case 0:
			Value = 10.0000000;
			break;
		case 1:
			Value = 15.0000000;
			break;
		case 2:
			Value = 20.0000000;
			break;
		case 3:
			Value = 40.0000000;
			break;
		case 4:
			Value = 60.0000000;
			break;
		case 5:
			Value = 80.0000000;
			break;
		case 6:
			Value = 100.0000000;
			break;
		case 7:
			Value = 120.0000000;
			break;
		case 8:
			Value = 150.0000000;
			break;
		case 9:
			Value = 180.0000000;
			break;
		case 10:
			Value = 200.0000000;
			break;
		default:
			break;
	}
	Class'NWindow.SSAOAPI'.static.SSAO_NoiseScale(Value);
	txtNoise.SetString(string(Value));
	return;
}

function ApplyDistance(int Step)
{
	local float Value;

	switch(Step)
	{
		case 0:
			Value = 0.1000000;
			break;
		case 1:
			Value = 0.3000000;
			break;
		case 2:
			Value = 0.5000000;
			break;
		case 3:
			Value = 0.7000000;
			break;
		case 4:
			Value = 0.9000000;
			break;
		case 5:
			Value = 1.0000000;
			break;
		case 6:
			Value = 1.2000000;
			break;
		case 7:
			Value = 1.5000000;
			break;
		case 8:
			Value = 2.0000000;
			break;
		case 9:
			Value = 3.0000000;
			break;
		case 10:
			Value = 5.0000000;
			break;
		default:
			break;
	}
	Class'NWindow.SSAOAPI'.static.SSAO_SampleDistance(Value);
	txtDistance.SetString(string(Value));
	return;
}

function ApplyBlur(int Step)
{
	local float Value;

	switch(Step)
	{
		case 0:
			Value = 1.0000000;
			break;
		case 1:
			Value = 1.2000000;
			break;
		case 2:
			Value = 1.5000000;
			break;
		case 3:
			Value = 2.0000000;
			break;
		case 4:
			Value = 2.5000000;
			break;
		case 5:
			Value = 3.0000000;
			break;
		case 6:
			Value = 5.0000000;
			break;
		case 7:
			Value = 7.0000000;
			break;
		case 8:
			Value = 8.0000000;
			break;
		case 9:
			Value = 9.0000000;
			break;
		case 10:
			Value = 10.0000000;
			break;
		default:
			break;
	}
	Class'NWindow.SSAOAPI'.static.SSAO_BlurIntensity(Value);
	txtBlur.SetString(string(Value));
	return;
}

function ApplyBlurDepth(int Step)
{
	local float Value;

	switch(Step)
	{
		case 0:
			Value = 0.5000000;
			break;
		case 1:
			Value = 1.0000000;
			break;
		case 2:
			Value = 2.0000000;
			break;
		case 3:
			Value = 4.0000000;
			break;
		case 4:
			Value = 6.0000000;
			break;
		case 5:
			Value = 8.0000000;
			break;
		case 6:
			Value = 20.0000000;
			break;
		case 7:
			Value = 50.0000000;
			break;
		case 8:
			Value = 100.0000000;
			break;
		case 9:
			Value = 200.0000000;
			break;
		case 10:
			Value = 500.0000000;
			break;
		default:
			break;
	}
	Class'NWindow.SSAOAPI'.static.SSAO_BlurDepthDifference(Value);
	txtBlurDepth.SetString(string(Value));
	return;
}

function ApplyBlurNormal(int Step)
{
	local float Value;

	switch(Step)
	{
		case 0:
			Value = 0.0000000;
			break;
		case 1:
			Value = 0.0500000;
			break;
		case 2:
			Value = 0.1000000;
			break;
		case 3:
			Value = 0.1500000;
			break;
		case 4:
			Value = 0.2000000;
			break;
		case 5:
			Value = 0.3000000;
			break;
		case 6:
			Value = 0.5000000;
			break;
		case 7:
			Value = 0.7000000;
			break;
		case 8:
			Value = 0.8000000;
			break;
		case 9:
			Value = 0.9000000;
			break;
		case 10:
			Value = 1.0000000;
			break;
		default:
			break;
	}
	Class'NWindow.SSAOAPI'.static.SSAO_BlurNormalDifference(Value);
	txtBlurNormal.SetString(string(Value));
	return;
}
