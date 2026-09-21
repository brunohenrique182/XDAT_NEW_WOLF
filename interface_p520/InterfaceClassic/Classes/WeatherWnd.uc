class WeatherWnd extends UICommonAPI;

var WindowHandle WindowHandle;
var ComboBoxHandle WeatherSortCombo;
var ComboBoxHandle SortCombo;
var ComboBoxHandle EmitterPosCombo;
var TextBoxHandle EmitterPosText;
var EditBoxHandle ParticleWeightEdit;
var EditBoxHandle ParticleSpeedEdit;
var TextBoxHandle ParticleEmitterNumText;
var TextBoxHandle ParticleEmitterNum1Text;
var EditBoxHandle ParticleEmitterNumEdit;
var ButtonHandle SetButton;
var ButtonHandle InitializeButton;
var ButtonHandle DeleteButton;
var int WeatherType;
var int MethodType;

function OnLoad()
{
	InitHandle();
	WeatherSortCombo.Clear();
	WeatherSortCombo.AddStringWithReserved("비", 0);  // EN: rain
	WeatherSortCombo.AddStringWithReserved("눈", 1);  // EN: snow
	WeatherSortCombo.AddStringWithReserved("비+눈", 2);  // EN: rain+snow
	SortCombo.Clear();
	SortCombo.AddStringWithReserved("파티클", 0);  // EN: particle
	SortCombo.AddStringWithReserved("매쉬", 1);  // EN: mesh
	SortCombo.AddStringWithReserved("파티클+매쉬", 2);  // EN: particle+mesh
	EmitterPosCombo.Clear();
	EmitterPosCombo.AddStringWithReserved("캐릭터에 Attach", 0);  // EN: attach to character
	EmitterPosCombo.AddStringWithReserved("카메라에 Attach", 1);  // EN: attach to camera
	ParticleWeightEdit.SetString("1");
	ParticleSpeedEdit.SetString("1");
	ParticleEmitterNumEdit.SetString("1");
	WeatherSortCombo.SetSelectedNum(0);
	SortCombo.SetSelectedNum(0);
	EmitterPosCombo.SetSelectedNum(0);
	WeatherType = 0;
	MethodType = 0;
	return;
}

function InitHandle()
{
	WindowHandle = GetWindowHandle("WeatherWnd");
	WeatherSortCombo = GetComboBoxHandle("WeatherWnd.WeatherSortCombo");
	SortCombo = GetComboBoxHandle("WeatherWnd.SortCombo");
	EmitterPosCombo = GetComboBoxHandle("WeatherWnd.EmitterPosCombo");
	EmitterPosText = GetTextBoxHandle("WeatherWnd.EmitterPosText");
	ParticleWeightEdit = GetEditBoxHandle("WeatherWnd.ParticleWeightEdit");
	ParticleSpeedEdit = GetEditBoxHandle("WeatherWnd.ParticleSpeedEdit");
	ParticleEmitterNumEdit = GetEditBoxHandle("WeatherWnd.ParticleEmitterNumEdit");
	ParticleEmitterNumText = GetTextBoxHandle("WeatherWnd.ParticleEmitterNumText");
	ParticleEmitterNum1Text = GetTextBoxHandle("WeatherWnd.ParticleEmitterNum1Text");
	SetButton = GetButtonHandle("WeatherWnd.SetButton");
	InitializeButton = GetButtonHandle("WeatherWnd.InitializeButton");
	DeleteButton = GetButtonHandle("WeatherWnd.DeleteButton");
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(5010);
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 5010:
			WindowHandle.ShowWindow();
			break;
		default:
			break;
	}
	return;
}

function OnComboBoxItemSelected(string a_ControlID, int a_SelectedIndex)
{
	if((a_ControlID == "WeatherSortCombo"))
	{
		WeatherType = a_SelectedIndex;
	}
	else if((a_ControlID == "SortCombo"))
	{
		MethodType = a_SelectedIndex;
		if((a_SelectedIndex == 0))
		{
			ParticleEmitterNumEdit.ShowWindow();
			ParticleEmitterNumText.ShowWindow();
			ParticleEmitterNum1Text.ShowWindow();
			EmitterPosText.ShowWindow();
			EmitterPosCombo.ShowWindow();
		}
		else if((a_SelectedIndex == 1))
		{
			ParticleEmitterNumEdit.HideWindow();
			ParticleEmitterNumText.HideWindow();
			ParticleEmitterNum1Text.HideWindow();
			EmitterPosText.HideWindow();
			EmitterPosCombo.HideWindow();
		}
		else if((a_SelectedIndex == 2))
		{
			ParticleEmitterNumEdit.ShowWindow();
			ParticleEmitterNumText.ShowWindow();
			ParticleEmitterNum1Text.ShowWindow();
			EmitterPosText.ShowWindow();
			EmitterPosCombo.ShowWindow();
		}
	}
	return;
}

function OnClickButton(string a_ControlID)
{
	switch(a_ControlID)
	{
		case "SetButton":
			SetWeatherButton();
			break;
		case "InitializeButton":
			RequestDeleteRainEffect();
			RequestDeleteSnowEffect();
			break;
		case "DeleteButton":
			break;
		default:
			break;
	}
	return;
}

function SetWeatherButton()
{
	if((WeatherType == 0))
	{
		RequestDeleteRainEffect();
		RequestCreateRainEffect(MethodType, EmitterPosCombo.GetSelectedNum());
		RequestSetRainWeight(float(ParticleWeightEdit.GetString()));
		RequestSetRainSpeed(float(ParticleSpeedEdit.GetString()));
		if(((MethodType == 0) || (MethodType == 2)))
		{
			RequestSetRainEmitterParticleNum(float(ParticleEmitterNumEdit.GetString()));
		}
	}
	else if((WeatherType == 1))
	{
		RequestDeleteSnowEffect();
		RequestCreateSnowEffect(MethodType, EmitterPosCombo.GetSelectedNum());
		RequestSetSnowWeight(float(ParticleWeightEdit.GetString()));
		RequestSetSnowSpeed(float(ParticleSpeedEdit.GetString()));
		if(((MethodType == 0) || (MethodType == 2)))
		{
			RequestSetSnowEmitterParticleNum(float(ParticleEmitterNumEdit.GetString()));
		}
	}
	else if((WeatherType == 2))
	{
		RequestDeleteRainEffect();
		RequestCreateRainEffect(MethodType, EmitterPosCombo.GetSelectedNum());
		RequestSetRainWeight(float(ParticleWeightEdit.GetString()));
		RequestSetRainSpeed(float(ParticleSpeedEdit.GetString()));
		if(((MethodType == 0) || (MethodType == 2)))
		{
			RequestSetRainEmitterParticleNum(float(ParticleEmitterNumEdit.GetString()));
		}
		RequestDeleteSnowEffect();
		RequestCreateSnowEffect(MethodType, EmitterPosCombo.GetSelectedNum());
		RequestSetSnowWeight(float(ParticleWeightEdit.GetString()));
		RequestSetSnowSpeed(float(ParticleSpeedEdit.GetString()));
		if(((MethodType == 0) || (MethodType == 2)))
		{
			RequestSetSnowEmitterParticleNum(float(ParticleEmitterNumEdit.GetString()));
		}
	}
	return;
}
