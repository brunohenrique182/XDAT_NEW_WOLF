class EnvTestWnd extends UICommonAPI;

const TICK_INTERVAL = 200.0f;

var WindowHandle Me;
var SliderCtrlHandle sliderTerrainAmbR;
var SliderCtrlHandle sliderTerrainAmbG;
var SliderCtrlHandle sliderTerrainAmbB;
var SliderCtrlHandle sliderStaticMeshAmbR;
var SliderCtrlHandle sliderStaticMeshAmbG;
var SliderCtrlHandle sliderStaticMeshAmbB;
var SliderCtrlHandle sliderBspAmbR;
var SliderCtrlHandle sliderBspAmbG;
var SliderCtrlHandle sliderBspAmbB;
var SliderCtrlHandle sliderActorAmbR;
var SliderCtrlHandle sliderActorAmbG;
var SliderCtrlHandle sliderActorAmbB;
var SliderCtrlHandle sliderSkyBoxColorR;
var SliderCtrlHandle sliderSkyBoxColorG;
var SliderCtrlHandle sliderSkyBoxColorB;
var SliderCtrlHandle sliderSkyBspAmbR;
var SliderCtrlHandle sliderSkyBspAmbG;
var SliderCtrlHandle sliderSkyBspAmbB;
var SliderCtrlHandle sliderGodRaySize;
var SliderCtrlHandle sliderGodRayBrightness;
var SliderCtrlHandle sliderGodRayEmit;
var SliderCtrlHandle sliderHsvActorLightHue;
var SliderCtrlHandle sliderHsvActorLightSat;
var SliderCtrlHandle sliderHsvActorLightBri;
var SliderCtrlHandle sliderHsvStaticMeshLightHue;
var SliderCtrlHandle sliderHsvStaticMeshLightSat;
var SliderCtrlHandle sliderHsvStaticMeshLightBri;
var SliderCtrlHandle sliderHsvTerrainLightHue;
var SliderCtrlHandle sliderHsvTerrainLightSat;
var SliderCtrlHandle sliderHsvTerrainLightBri;
var SliderCtrlHandle sliderGammaSettingContrast;
var SliderCtrlHandle sliderGammaSettingBrightness;
var SliderCtrlHandle sliderGammaSettingGamma;
var TextBoxHandle txtTerrainAmb;
var TextBoxHandle txtStaticMeshAmb;
var TextBoxHandle txtBspAmb;
var TextBoxHandle txtActorAmb;
var TextBoxHandle txtSkyBoxColor;
var TextBoxHandle txtSkyBspAmb;
var TextBoxHandle txtGodRay;
var TextBoxHandle txtHsvActorLight;
var TextBoxHandle txtHsvStaticMeshLight;
var TextBoxHandle txtHsvTerrainLight;
var TextBoxHandle txtGammaSetting;
var CheckBoxHandle checkBoxTerrainAmb;
var CheckBoxHandle checkBoxStaticMeshAmb;
var CheckBoxHandle checkBoxBspAmb;
var CheckBoxHandle checkBoxActorAmb;
var CheckBoxHandle checkBoxSkyBoxColor;
var CheckBoxHandle checkBoxSkyBspAmb;
var CheckBoxHandle checkBoxGodRay;
var CheckBoxHandle checkHsvActorLight;
var CheckBoxHandle checkHsvStaticMeshLight;
var CheckBoxHandle checkHsvTerrainLight;
var CheckBoxHandle checkBoxGammaSetting;
var CheckBoxHandle checkBoxWindowDefaultGamma;
var CheckBoxHandle checkBoxGammaCorrection;
var Color terrainAmbColor;
var Color staticMeshAmbColor;
var Color bspAmbColor;
var Color actorAmbColor;
var Color skyBoxColor;
var Color skyBspAmbColor;
var Color HsvActorLightColor;
var Color HsvStaticMeshLightColor;
var Color HsvTerrainLightColor;
var SliderCtrlHandle sliderLightMapIntensity;
var SliderCtrlHandle sliderLightMapIntensity2;
var TextBoxHandle txtLightMapIntensity;
var TextBoxHandle txtLightMapIntensity2;
var float LightMapIntensity;
var float LightMapIntensity2;
var CheckBoxHandle checkBoxLightMapIntensity;
var CheckBoxHandle checkBoxLightMapIntensity2;
var float GodRaySize;
var float GodRayBrightness;
var float GodRayEmit;
var float GammaCorrectionBrightness;
var float GammaCorrectionContrast;
var float GammaCorrectionGamma;
var SliderCtrlHandle sliderSetTime;
var TextBoxHandle txtSetTime;
var CheckBoxHandle checkBoxSetTime;

function OnRegisterEvent()
{
	RegisterEvent(9250);
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
	Me = GetWindowHandle("EnvTestWnd");
	setWindowTitleByString("Env Test");
	sliderTerrainAmbR = GetSliderCtrlHandle("EnvTestWnd.TerrainAmbRSliderCtrl");
	sliderTerrainAmbG = GetSliderCtrlHandle("EnvTestWnd.TerrainAmbGSliderCtrl");
	sliderTerrainAmbB = GetSliderCtrlHandle("EnvTestWnd.TerrainAmbBSliderCtrl");
	sliderStaticMeshAmbR = GetSliderCtrlHandle("EnvTestWnd.StaticMeshAmbRSliderCtrl");
	sliderStaticMeshAmbG = GetSliderCtrlHandle("EnvTestWnd.StaticMeshAmbGSliderCtrl");
	sliderStaticMeshAmbB = GetSliderCtrlHandle("EnvTestWnd.StaticMeshAmbBSliderCtrl");
	sliderBspAmbR = GetSliderCtrlHandle("EnvTestWnd.BspAmbRSliderCtrl");
	sliderBspAmbG = GetSliderCtrlHandle("EnvTestWnd.BspAmbGSliderCtrl");
	sliderBspAmbB = GetSliderCtrlHandle("EnvTestWnd.BspAmbBSliderCtrl");
	sliderActorAmbR = GetSliderCtrlHandle("EnvTestWnd.ActorAmbRSliderCtrl");
	sliderActorAmbG = GetSliderCtrlHandle("EnvTestWnd.ActorAmbGSliderCtrl");
	sliderActorAmbB = GetSliderCtrlHandle("EnvTestWnd.ActorAmbBSliderCtrl");
	sliderSkyBoxColorR = GetSliderCtrlHandle("EnvTestWnd.SkyBoxColorRSliderCtrl");
	sliderSkyBoxColorG = GetSliderCtrlHandle("EnvTestWnd.SkyBoxColorGSliderCtrl");
	sliderSkyBoxColorB = GetSliderCtrlHandle("EnvTestWnd.SkyBoxColorBSliderCtrl");
	sliderSkyBspAmbR = GetSliderCtrlHandle("EnvTestWnd.SkyBspAmbRSliderCtrl");
	sliderSkyBspAmbG = GetSliderCtrlHandle("EnvTestWnd.SkyBspAmbGSliderCtrl");
	sliderSkyBspAmbB = GetSliderCtrlHandle("EnvTestWnd.SkyBspAmbBSliderCtrl");
	sliderGodRaySize = GetSliderCtrlHandle("EnvTestWnd.GodRaySizeSliderCtrl");
	sliderGodRayBrightness = GetSliderCtrlHandle("EnvTestWnd.GodRayBrightnessSliderCtrl");
	sliderGodRayEmit = GetSliderCtrlHandle("EnvTestWnd.GodRayEmitSliderCtrl");
	sliderHsvActorLightHue = GetSliderCtrlHandle("EnvTestWnd.HSVActorLightHueSliderCtrl");
	sliderHsvActorLightSat = GetSliderCtrlHandle("EnvTestWnd.HSVActorLightSatSliderCtrl");
	sliderHsvActorLightBri = GetSliderCtrlHandle("EnvTestWnd.HSVActorLightBriSliderCtrl");
	sliderHsvStaticMeshLightHue = GetSliderCtrlHandle("EnvTestWnd.HSVStaticMeshLightHueSliderCtrl");
	sliderHsvStaticMeshLightSat = GetSliderCtrlHandle("EnvTestWnd.HSVStaticMeshLightSatSliderCtrl");
	sliderHsvStaticMeshLightBri = GetSliderCtrlHandle("EnvTestWnd.HSVStaticMeshLightBriSliderCtrl");
	sliderHsvTerrainLightHue = GetSliderCtrlHandle("EnvTestWnd.HSVTerrainLightHueSliderCtrl");
	sliderHsvTerrainLightSat = GetSliderCtrlHandle("EnvTestWnd.HSVTerrainLightSatSliderCtrl");
	sliderHsvTerrainLightBri = GetSliderCtrlHandle("EnvTestWnd.HSVTerrainLightBriSliderCtrl");
	sliderGammaSettingContrast = GetSliderCtrlHandle("EnvTestWnd.GammaSettingContrastSliderCtrl");
	sliderGammaSettingBrightness = GetSliderCtrlHandle("EnvTestWnd.GammaSettingBrightnessSliderCtrl");
	sliderGammaSettingGamma = GetSliderCtrlHandle("EnvTestWnd.GammaSettingGammaSliderCtrl");
	txtTerrainAmb = GetTextBoxHandle("EnvTestWnd.TerrainAmbTextBox");
	txtStaticMeshAmb = GetTextBoxHandle("EnvTestWnd.StaticMeshAmbTextBox");
	txtBspAmb = GetTextBoxHandle("EnvTestWnd.BspAmbTextBox");
	txtActorAmb = GetTextBoxHandle("EnvTestWnd.ActorAmbTextBox");
	txtSkyBoxColor = GetTextBoxHandle("EnvTestWnd.SkyBoxColorTextBox");
	txtSkyBspAmb = GetTextBoxHandle("EnvTestWnd.SkyBspAmbTextBox");
	txtGodRay = GetTextBoxHandle("EnvTestWnd.GodRayTextBox");
	txtHsvActorLight = GetTextBoxHandle("EnvTestWnd.HSVActorLightTextBox");
	txtHsvStaticMeshLight = GetTextBoxHandle("EnvTestWnd.HSVStaticMeshLightTextBox");
	txtHsvTerrainLight = GetTextBoxHandle("EnvTestWnd.HSVTerrainLightTextBox");
	txtGammaSetting = GetTextBoxHandle("EnvTestWnd.GammaTextBox");
	checkBoxTerrainAmb = GetCheckBoxHandle("EnvTestWnd.EnableTerrainAmbientCheckBox");
	checkBoxStaticMeshAmb = GetCheckBoxHandle("EnvTestWnd.EnableStaticMeshAmbientCheckBox");
	checkBoxBspAmb = GetCheckBoxHandle("EnvTestWnd.EnableBspAmbientCheckBox");
	checkBoxActorAmb = GetCheckBoxHandle("EnvTestWnd.EnableActorAmbientCheckBox");
	checkBoxSkyBoxColor = GetCheckBoxHandle("EnvTestWnd.EnableSkyBoxColorCheckBox");
	checkBoxSkyBspAmb = GetCheckBoxHandle("EnvTestWnd.EnableSkyBspAmbCheckBox");
	checkHsvActorLight = GetCheckBoxHandle("EnvTestWnd.HSVActorLightCheckBox");
	checkHsvStaticMeshLight = GetCheckBoxHandle("EnvTestWnd.HSVStaticMeshLightCheckBox");
	checkHsvTerrainLight = GetCheckBoxHandle("EnvTestWnd.HSVTerrainLightCheckBox");
	checkBoxGammaSetting = GetCheckBoxHandle("EnvTestWnd.CheckBoxGammaSetting");
	checkBoxWindowDefaultGamma = GetCheckBoxHandle("EnvTestWnd.checkBoxWindowDefaultGamma");
	checkBoxGammaCorrection = GetCheckBoxHandle("EnvTestWnd.checkBoxGammaCorrection");
	sliderLightMapIntensity = GetSliderCtrlHandle("EnvTestWnd.sliderLightMapIntensity");
	txtLightMapIntensity = GetTextBoxHandle("EnvTestWnd.txtLightMapIntensity");
	LightMapIntensity = 1.0000000;
	sliderLightMapIntensity2 = GetSliderCtrlHandle("EnvTestWnd.sliderLightMapIntensity2");
	txtLightMapIntensity2 = GetTextBoxHandle("EnvTestWnd.txtLightMapIntensity2");
	LightMapIntensity2 = 1.0000000;
	checkBoxLightMapIntensity = GetCheckBoxHandle("EnvTestWnd.checkBoxLightMapIntensity");
	checkBoxLightMapIntensity2 = GetCheckBoxHandle("EnvTestWnd.checkBoxLightMapIntensity2");
	checkBoxGodRay = GetCheckBoxHandle("EnvTestWnd.CheckBoxGodRay");
	sliderSetTime = GetSliderCtrlHandle("EnvTestWnd.sliderSetTime");
	txtSetTime = GetTextBoxHandle("EnvTestWnd.txtSetTime");
	checkBoxSetTime = GetCheckBoxHandle("EnvTestWnd.checkBoxSetTime");
	GodRaySize = 1.0000000;
	GodRayBrightness = 1.0000000;
	GodRayEmit = 2.5000000;
	GammaCorrectionBrightness = 0.5000000;
	GammaCorrectionContrast = 0.5000000;
	GammaCorrectionGamma = 1.0000000;
	return;
}

function OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
	local string Str;
	local float ftime;

	switch(strID)
	{
		case "TerrainAmbRSliderCtrl":
		case "TerrainAmbGSliderCtrl":
		case "TerrainAmbBSliderCtrl":
			terrainAmbColor.R = byte(sliderTerrainAmbR.GetCurrentTick());
			terrainAmbColor.G = byte(sliderTerrainAmbG.GetCurrentTick());
			terrainAmbColor.B = byte(sliderTerrainAmbB.GetCurrentTick());
			txtTerrainAmb.SetText(((((((("R:" $ string(terrainAmbColor.R)) $ "\\n") $ "G:") $ string(terrainAmbColor.G)) $ "\\n") $ "B:") $ string(terrainAmbColor.B)));
			SetTestTerrainAmbientColor(terrainAmbColor);
			break;
		case "StaticMeshAmbRSliderCtrl":
		case "StaticMeshAmbGSliderCtrl":
		case "StaticMeshAmbBSliderCtrl":
			staticMeshAmbColor.R = byte(sliderStaticMeshAmbR.GetCurrentTick());
			staticMeshAmbColor.G = byte(sliderStaticMeshAmbG.GetCurrentTick());
			staticMeshAmbColor.B = byte(sliderStaticMeshAmbB.GetCurrentTick());
			txtStaticMeshAmb.SetText(((((((("R:" $ string(staticMeshAmbColor.R)) $ "\\n") $ "G:") $ string(staticMeshAmbColor.G)) $ "\\n") $ "B:") $ string(staticMeshAmbColor.B)));
			SetTestStaticMeshAmbientColor(staticMeshAmbColor);
			break;
		case "BspAmbRSliderCtrl":
		case "BspAmbGSliderCtrl":
		case "BspAmbBSliderCtrl":
			bspAmbColor.R = byte(sliderBspAmbR.GetCurrentTick());
			bspAmbColor.G = byte(sliderBspAmbG.GetCurrentTick());
			bspAmbColor.B = byte(sliderBspAmbB.GetCurrentTick());
			txtBspAmb.SetText(((((((("R:" $ string(bspAmbColor.R)) $ "\\n") $ "G:") $ string(bspAmbColor.G)) $ "\\n") $ "B:") $ string(bspAmbColor.B)));
			SetTestBspAmbientColor(bspAmbColor);
			break;
		case "ActorAmbRSliderCtrl":
		case "ActorAmbGSliderCtrl":
		case "ActorAmbBSliderCtrl":
			actorAmbColor.R = byte(sliderActorAmbR.GetCurrentTick());
			actorAmbColor.G = byte(sliderActorAmbG.GetCurrentTick());
			actorAmbColor.B = byte(sliderActorAmbB.GetCurrentTick());
			txtActorAmb.SetText(((((((("R:" $ string(actorAmbColor.R)) $ "\\n") $ "G:") $ string(actorAmbColor.G)) $ "\\n") $ "B:") $ string(actorAmbColor.B)));
			SetTestActorAmbientColor(actorAmbColor);
			break;
		case "SkyBoxColorRSliderCtrl":
		case "SkyBoxColorGSliderCtrl":
		case "SkyBoxColorBSliderCtrl":
			skyBoxColor.R = byte(sliderSkyBoxColorR.GetCurrentTick());
			skyBoxColor.G = byte(sliderSkyBoxColorG.GetCurrentTick());
			skyBoxColor.B = byte(sliderSkyBoxColorB.GetCurrentTick());
			txtSkyBoxColor.SetText(((((((("R:" $ string(skyBoxColor.R)) $ "\\n") $ "G:") $ string(skyBoxColor.G)) $ "\\n") $ "B:") $ string(skyBoxColor.B)));
			SetTestSkyBoxColor(skyBoxColor);
			break;
		case "SkyBspAmbRSliderCtrl":
		case "SkyBspAmbGSliderCtrl":
		case "SkyBspAmbBSliderCtrl":
			skyBspAmbColor.R = byte(sliderSkyBspAmbR.GetCurrentTick());
			skyBspAmbColor.G = byte(sliderSkyBspAmbG.GetCurrentTick());
			skyBspAmbColor.B = byte(sliderSkyBspAmbB.GetCurrentTick());
			txtSkyBspAmb.SetText(((((((("R:" $ string(skyBspAmbColor.R)) $ "\\n") $ "G:") $ string(skyBspAmbColor.G)) $ "\\n") $ "B:") $ string(skyBspAmbColor.B)));
			SetTestSkyBspAmbientColor(skyBspAmbColor);
			break;
		case "GodRaySizeSliderCtrl":
		case "GodRayBrightnessSliderCtrl":
		case "GodRayEmitSliderCtrl":
			GodRaySize = ((float(sliderGodRaySize.GetCurrentTick()) / 200.0000000) + 0.1000000);
			GodRayBrightness = ((float(sliderGodRayBrightness.GetCurrentTick()) / 200.0000000) + 0.1000000);
			GodRayEmit = ((float(sliderGodRayEmit.GetCurrentTick()) / 200.0000000) + 0.1000000);
			txtGodRay.SetText(((((((("SunSize :" $ string(GodRaySize)) $ "\\n") $ "Brightness:") $ string(GodRayBrightness)) $ "\\n") $ "Emit:") $ string(GodRayEmit)));
			SetTestGodRayOption(GodRaySize, GodRayBrightness, GodRayEmit);
			break;
		case "sliderLightMapIntensity":
		case "sliderLightMapIntensity2":
			LightMapIntensity = (float(sliderLightMapIntensity.GetCurrentTick()) / 200.0000000);
			Str = string(LightMapIntensity);
			txtLightMapIntensity.SetText((Str @ "배"));  // EN: boat
			LightMapIntensity2 = (float(sliderLightMapIntensity2.GetCurrentTick()) / 200.0000000);
			Str = string(LightMapIntensity2);
			txtLightMapIntensity2.SetText((Str @ "배"));  // EN: boat
			SetTestBeastLightMapIntensity(LightMapIntensity, LightMapIntensity2);
			break;
		case "sliderSetTime":
			if(checkBoxSetTime.IsChecked())
			{
				ftime = (float(sliderSetTime.GetCurrentTick()) / 10.0000000);
				SetEnvTime(ftime);
				txtSetTime.SetText((string(ftime) @ " 시"));  // EN: hour
			}
			break;
		case "HSVActorLightHueSliderCtrl":
		case "HSVActorLightSatSliderCtrl":
		case "HSVActorLightBriSliderCtrl":
			HsvActorLightColor.R = byte(sliderHsvActorLightHue.GetCurrentTick());
			HsvActorLightColor.G = byte(sliderHsvActorLightSat.GetCurrentTick());
			HsvActorLightColor.B = byte(sliderHsvActorLightBri.GetCurrentTick());
			txtHsvActorLight.SetText(((((((("H:" $ string(HsvActorLightColor.R)) $ "\\n") $ "S:") $ string(HsvActorLightColor.G)) $ "\\n") $ "V:") $ string(HsvActorLightColor.B)));
			SetTestHsvActorLightColor(HsvActorLightColor);
			break;
		case "HSVStaticMeshLightHueSliderCtrl":
		case "HSVStaticMeshLightSatSliderCtrl":
		case "HSVStaticMeshLightBriSliderCtrl":
			HsvStaticMeshLightColor.R = byte(sliderHsvStaticMeshLightHue.GetCurrentTick());
			HsvStaticMeshLightColor.G = byte(sliderHsvStaticMeshLightSat.GetCurrentTick());
			HsvStaticMeshLightColor.B = byte(sliderHsvStaticMeshLightBri.GetCurrentTick());
			txtHsvStaticMeshLight.SetText(((((((("H:" $ string(HsvStaticMeshLightColor.R)) $ "\\n") $ "S:") $ string(HsvStaticMeshLightColor.G)) $ "\\n") $ "V:") $ string(HsvStaticMeshLightColor.B)));
			SetTestHsvStaticMeshLightColor(HsvStaticMeshLightColor);
			break;
		case "HSVTerrainLightHueSliderCtrl":
		case "HSVTerrainLightSatSliderCtrl":
		case "HSVTerrainLightBriSliderCtrl":
			HsvTerrainLightColor.R = byte(sliderHsvTerrainLightHue.GetCurrentTick());
			HsvTerrainLightColor.G = byte(sliderHsvTerrainLightSat.GetCurrentTick());
			HsvTerrainLightColor.B = byte(sliderHsvTerrainLightBri.GetCurrentTick());
			txtHsvTerrainLight.SetText(((((((("H:" $ string(HsvTerrainLightColor.R)) $ "\\n") $ "S:") $ string(HsvTerrainLightColor.G)) $ "\\n") $ "V:") $ string(HsvTerrainLightColor.B)));
			SetTestHsvTerrainLightColor(HsvTerrainLightColor);
			break;
		case "GammaSettingContrastSliderCtrl":
		case "GammaSettingBrightnessSliderCtrl":
		case "GammaSettingGammaSliderCtrl":
			GammaCorrectionBrightness = (float(sliderGammaSettingBrightness.GetCurrentTick()) / 256.0000000);
			GammaCorrectionContrast = (float(sliderGammaSettingContrast.GetCurrentTick()) / 128.0000000);
			GammaCorrectionGamma = ((float(sliderGammaSettingGamma.GetCurrentTick()) / 128.0000000) + 0.5000000);
			txtGammaSetting.SetText(((((((("대비:" $ string(GammaCorrectionContrast)) $ "\\n") $ "밝기:") $ string(GammaCorrectionBrightness)) $ "\\n") $ "감마:") $ string(GammaCorrectionGamma)));  // EN: contrast: | EN: brightness: | EN: gamma:
			SetTestGammaSetting(GammaCorrectionBrightness, GammaCorrectionContrast, GammaCorrectionGamma);
			break;
		default:
			break;
	}
	return;
}

function OnClickCheckBox(string strID)
{
	if((strID == "EnableTerrainAmbientCheckBox"))
	{
		SetEnableTerrainAmbient(checkBoxTerrainAmb.IsChecked());
	}
	else if((strID == "EnableStaticMeshAmbientCheckBox"))
	{
		SetEnableStaticMeshAmbient(checkBoxStaticMeshAmb.IsChecked());
	}
	else if((strID == "EnableBspAmbientCheckBox"))
	{
		SetEnableBspAmbient(checkBoxBspAmb.IsChecked());
	}
	else if((strID == "EnableActorAmbientCheckBox"))
	{
		SetEnableActorAmbient(checkBoxActorAmb.IsChecked());
	}
	else if((strID == "EnableSkyBoxColorCheckBox"))
	{
		SetEnableSkyBoxColor(checkBoxSkyBoxColor.IsChecked());
	}
	else if((strID == "EnableSkyBspAmbCheckBox"))
	{
		SetEnableSkyBspAmbient(checkBoxSkyBspAmb.IsChecked());
	}
	else if((strID == "checkBoxLightMapIntensity"))
	{
		SetEnableLightMapIntensity(checkBoxLightMapIntensity.IsChecked());
	}
	else if((strID == "checkBoxGodRay"))
	{
		SetEnableGodRay(checkBoxGodRay.IsChecked());
	}
	else if((strID == "HSVActorLightCheckBox"))
	{
		SetEnableHsvActorLight(checkHsvActorLight.IsChecked());
	}
	else if((strID == "HSVStaticMeshLightCheckBox"))
	{
		SetEnableHsvStaticMeshLight(checkHsvStaticMeshLight.IsChecked());
	}
	else if((strID == "HSVTerrainLightCheckBox"))
	{
		SetEnableHsvTerrainLight(checkHsvTerrainLight.IsChecked());
	}
	else if((strID == "CheckBoxGammaSetting"))
	{
		SetEnableGammaSetting(checkBoxGammaSetting.IsChecked());
	}
	else if((strID == "CheckBoxWindowDefaultGamma"))
	{
		SetEnableWindowDefaultGamma(checkBoxWindowDefaultGamma.IsChecked());
	}
	else if((strID == "CheckBoxGammaCorrection"))
	{
		SetEnableGammaCorrection(checkBoxGammaCorrection.IsChecked());
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 9250))
	{
		Me.ShowWindow();
	}
	return;
}
