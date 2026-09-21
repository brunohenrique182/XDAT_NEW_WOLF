class UITweenTestWnd extends UICommonAPI;

enum ETweenParamType
{
	Tween,                          // 0
	Shake,                          // 1
	Twinkle                         // 2
};

var WindowHandle Me;
var string m_Windowname;
var TextureHandle texture0;
var TextureHandle Texture1;
var EditBoxHandle tweenParamEditBox;
var ComboBoxHandle tweenTypeComboBox;
var WindowHandle tweenParamPanel;
var WindowHandle shakeParamPanel;
var L2UITween l2UITweenScript;
var ComboBoxHandle tweenEaseTypeComboBox;
var ComboBoxHandle shakeDirectionComboBox;
var UIControlSliderWithValue tweenDurationSlider;
var UIControlSliderWithValue tweenAlphaSlider;
var UIControlSliderWithValue tweenSizeXSlider;
var UIControlSliderWithValue tweenSizeYSlider;
var UIControlSliderWithValue tweenMoveXSlider;
var UIControlSliderWithValue tweenMoveYSlider;
var UIControlSliderWithValue tweenDelaySlider;
var UIControlSliderWithValue shakeDurationSlider;
var UIControlSliderWithValue shakeSizeSlider;
var UIControlSliderWithValue shakeDelaySlider;

event OnRegisterEvent()
{
	RegisterEvent(150);
	return;
}

event OnLoad()
{
	Me = GetWindowHandle(m_Windowname);
	tweenParamPanel = GetWindowHandle((m_Windowname $ ".tweenParamPanel"));
	shakeParamPanel = GetWindowHandle((m_Windowname $ ".shakeParamPanel"));
	texture0 = GetTextureHandle((m_Windowname $ ".texture0"));
	Texture1 = GetTextureHandle((m_Windowname $ ".texture1"));
	tweenParamEditBox = GetEditBoxHandle((m_Windowname $ ".tweenParamEditBox"));
	tweenTypeComboBox = GetComboBoxHandle((m_Windowname $ ".tweenTypeComboBox"));
	l2UITweenScript = Class'Interface.L2UITween'.static.Inst();
	SetClosingOnESC();
	GetTextBoxHandle((m_Windowname $ ".TweenHelpTextBox")).SetText(("[EASE] 0:IN_STRONG, 1:OUT_STRONG, 2:INOUT_STRONG, 3:IN_BOUNCE, 4:OUT_BOUNCE, 5:INOUT_BOUNCE, 6:IN_ELASTIC, 7:OUT_ELASTIC, 8:INOUT_ELASTIC\\n" $ "[TYPE] shake, tween [Alpha] 0~255, [DURATION] 1000이 1초 "));  // EN?: [TYPE] shake, tween [Alpha] 0~255, [DURATION] 1000 is 1 second
	GetEditBoxHandle((m_Windowname $ ".texture1EditBox")).SetString("w=100 h=100 texture=L2UI_ct1.Button.Button_DF_Calculator_Long_Over");
	GetEditBoxHandle((m_Windowname $ ".texture2EditBox")).SetString("w=100 h=100 texture=L2UI_ct1.Button.Button_DF_Calculator_Long_Over");
	InitTweenParamControls();
	ResetParams();
	ResetTextures();
	return;
}

function OnShow()
{
	ResetTextures();
	return;
}

function InitTweenParamControls()
{
	local int i;

	tweenTypeComboBox.AddStringWithReserved(GetTweenName(Tween), 0);
	tweenTypeComboBox.AddStringWithReserved(GetTweenName(Shake), 1);
	tweenTypeComboBox.AddStringWithReserved(GetTweenName(Twinkle), 2);
	InitSliderControl(tweenDurationSlider, "tweenDurationSlider", "duration", 0, 20000, 1000, tweenParamPanel);
	InitSliderControl(tweenAlphaSlider, "tweenAlphaSlider", "alpha", -255, 255, 100, tweenParamPanel);
	InitSliderControl(tweenSizeXSlider, "tweenSizeXSlider", "sizeX", -1000, 1000, 100, tweenParamPanel);
	InitSliderControl(tweenSizeYSlider, "tweenSizeYSlider", "sizeY", -1000, 1000, 100, tweenParamPanel);
	InitSliderControl(tweenMoveXSlider, "tweenMoveXSlider", "moveX", -1000, 1000, 0, tweenParamPanel);
	InitSliderControl(tweenMoveYSlider, "tweenMoveYSlider", "moveY", -1000, 1000, 0, tweenParamPanel);
	InitSliderControl(tweenDelaySlider, "tweenDelaySlider", "delay", 0, 10000, 0, tweenParamPanel);
	tweenEaseTypeComboBox = GetComboBoxHandle((tweenParamPanel.m_WindowNameWithFullPath $ ".tweenEaseTypeComboBox"));
	i = 0;
	while((i < (9 + 1)))
	{
		tweenEaseTypeComboBox.AddString(string(GetEnum(Enum'easeType', i)));
		i++;
	}
	InitSliderControl(shakeDurationSlider, "shakeDurationSlider", "duration", 0, 20000, 1000, shakeParamPanel);
	InitSliderControl(shakeSizeSlider, "shakeSizeSlider", "shakeSize", 1, 1000, 40, shakeParamPanel);
	InitSliderControl(shakeDelaySlider, "shakeDelaySlider", "delay", 0, 10000, 0, shakeParamPanel);
	shakeDirectionComboBox = GetComboBoxHandle((tweenParamPanel.m_WindowNameWithFullPath $ ".shakeDirectionComboBox"));
	i = 0;
	while((i < (1 + 1)))
	{
		shakeDirectionComboBox.AddString(string(GetEnum(Enum'directionType', i)));
		i++;
	}
	return;
}

function InitSliderControl(out UIControlSliderWithValue Control, string ControlName, string titleText, int MinValue, int MaxValue, int defaultValue, WindowHandle Owner)
{
	local WindowHandle targetWindowHandle;

	targetWindowHandle = GetWindowHandle(((Owner.m_WindowNameWithFullPath $ ".") $ ControlName));
	targetWindowHandle.SetScript("UIControlSliderWithValue");
	Control = UIControlSliderWithValue(targetWindowHandle.GetScript());
	Control.Init(targetWindowHandle);
	Control._SetMinMaxValue(MinValue, MaxValue);
	Control._SetValue(defaultValue);
	Control._SetTitle(titleText);
	Control.DelegateOnValueChanged = OnSliderValueChanged;
	return;
}

event OnComboBoxItemSelected(string strID, int Index)
{
	switch(strID)
	{
		case "tweenTypeComboBox":
			SetTweenParamTypePanel(ETweenParamType(Index));
			UpdateTweenParamString();
			break;
		case "tweenEaseTypeComboBox":
			UpdateTweenParamString();
			break;
		case "shakeDirectionComboBox":
			UpdateTweenParamString();
			break;
		default:
			break;
	}
	return;
}

event OnSliderValueChanged(UIControlSliderWithValue slider)
{
	UpdateTweenParamString();
	return;
}

event OnCallUCFunction(string functionName, string param)
{
	Debug(("OnCallUCFunction CompleteTween" @ param));
	switch(functionName)
	{
		case "tweenEnd":
			getInstanceL2Util().showGfxScreenMessage(("모션 완료" @ param));  // EN?: Motion completed
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "ButtonStart":
			MaketweenObjectFormString(tweenParamEditBox.GetString());
			break;
		case "ButtonReset":
			ResetTextures();
			break;
		case "ButtonResetParam":
			ResetParams();
			break;
		case "ButtonUpdateTexture":
			UpdateTexture();
			break;
		case "SaveList":
			Class'Interface.UIListNoteWnd'.static.Inst().delegateGetParam = getParam;
			Class'Interface.UIListNoteWnd'.static.Inst()._SetString(GetTweenName(ETweenParamType(tweenTypeComboBox.GetSelectedNum())));
			Class'Interface.UIListNoteWnd'.static.Inst()._Show(m_hOwnerWnd);
			Class'Interface.UIListNoteWnd'.static.Inst().delegateOnDBClick = SetParam;
			break;
		default:
			break;
	}
	return;
}

function string getParam()
{
	local string param;

	param = GetParamsStringFromControlValue();
	ParamAdd(param, "textureValues", GetEditBoxHandle((m_Windowname $ ".texture1EditBox")).GetString());
	Debug(("GetParam" @ param));
	return param;
}

function SetParam(string param)
{
	local string texturetext;

	MaketweenObjectFormString(param);
	ParseString(param, "textureValues", texturetext);
	GetEditBoxHandle((m_Windowname $ ".texture1EditBox")).SetString(texturetext);
	UpdateTexture();
	Debug(("SetParam" @ texturetext));
	return;
}

function UpdateTexture()
{
	local string s1, S2, sText1, sText2;
	local int h1, w1, h2, w2, uw1, uh1, uw2, uh2;

	s1 = GetEditBoxHandle((m_Windowname $ ".texture1EditBox")).GetString();
	S2 = GetEditBoxHandle((m_Windowname $ ".texture2EditBox")).GetString();
	if((s1 == ""))
	{
		sText1 = "L2UI_ct1.Button.Button_DF_Calculator_Long_Over";
		w1 = 100;
		h1 = 100;
		GetEditBoxHandle((m_Windowname $ ".texture1EditBox")).SetString("w=100 h=100 texture=L2UI_ct1.Button.Button_DF_Calculator_Long_Over");
	}
	else
	{
		ParseString(s1, "texture", sText1);
		ParseInt(s1, "h", h1);
		ParseInt(s1, "w", w1);
		ParseInt(s1, "u", uw1);
		ParseInt(s1, "v", uh1);
	}
	if((S2 == ""))
	{
		sText2 = "L2UI_ct1.Button.Button_DF_Calculator_Long_Over";
		w2 = 100;
		h2 = 100;
		GetEditBoxHandle((m_Windowname $ ".texture2EditBox")).SetString("w=100 h=100 texture=L2UI_ct1.Button.Button_DF_Calculator_Long_Over");
	}
	else
	{
		ParseString(S2, "texture", sText2);
		ParseInt(S2, "H", h2);
		ParseInt(S2, "W", w2);
		ParseInt(S2, "u", uw2);
		ParseInt(S2, "v", uh2);
	}
	GetEditBoxHandle((m_Windowname $ ".texture2EditBox"));
	texture0.SetTexture(sText1);
	texture0.SetWindowSize(w1, h1);
	texture0.SetTextureSize(uw1, uh1);
	Texture1.SetTexture(sText2);
	Texture1.SetWindowSize(w2, h2);
	Texture1.SetTextureSize(uw2, uh2);
	return;
}

event OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 150:
			break;
		default:
			break;
	}
	return;
}

function SetTweenParamTypePanel(ETweenParamType Type)
{
	if((int(Type) == 0))
	{
		tweenParamPanel.ShowWindow();
		shakeParamPanel.HideWindow();
	}
	else if((int(Type) == 1))
	{
		shakeParamPanel.ShowWindow();
		tweenParamPanel.HideWindow();
	}
	else if((int(Type) == 2))
	{
		tweenParamPanel.ShowWindow();
		shakeParamPanel.HideWindow();
	}
	return;
}

function MakeScriptTween(L2UITween.TweenObject tweenObj)
{
	local string cord;

	cord = ((((((((((((((((((((((((((((((((((((((((((((((((((((((("local L2UITween.TweenObject tweenObj;" $ Chr(10)) $ Chr(10)) $ "tweenObj.target = GetWindowHandle( ") $ Chr(34)) $ "!대상 텍스쳐 경로?") $ Chr(34)) $ ");") $ Chr(10)) $ "tweenObj.ease = easeType(") $ string(tweenObj.ease)) $ ");") $ Chr(10)) $ "tweenObj.duration =") @ Chr(34)) $ string(tweenObj.Duration)) $ Chr(34)) $ ";") $ Chr(10)) $ "tweenObj.alpha =") @ Chr(34)) $ string(tweenObj.Alpha)) $ Chr(34)) $ ";") $ Chr(10)) $ "tweenObj.moveX =") @ Chr(34)) $ string(tweenObj.MoveX)) $ Chr(34)) $ ";") $ Chr(10)) $ "tweenObj.moveY =") @ Chr(34)) $ string(tweenObj.MoveY)) $ Chr(34)) $ ";") $ Chr(10)) $ "tweenObj.sizeX =") @ Chr(34)) $ string(tweenObj.SizeX)) $ Chr(34)) $ ";") $ Chr(10)) $ "tweenObj.sizeY =") @ Chr(34)) $ string(tweenObj.SizeY)) $ Chr(34)) $ ";") $ Chr(10)) $ "tweenObj.delay =") @ Chr(34)) $ string(tweenObj.Delay)) $ Chr(34)) $ ";") $ Chr(10)) $ "class'L2UITween'.static.Inst().AddTweenObject(tweenObj);");  // EN?: ! Target texture path?
	ClipboardCopy(cord);
	getInstanceL2Util().showGfxScreenMessage("Tween script copyed. → Ctrl + V");
	return;
}

function MakeScriptShake(L2UITween.ShakeObject shakeObj)
{
	local string cord;

	cord = ((((((((((((((((((((((((((((((("local L2UITween.ShakeObject shakeObj;" $ Chr(10)) $ Chr(10)) $ "shakeObj.target = GetWindowHandle( ") $ Chr(34)) $ "!대상 텍스쳐 경로?") $ Chr(34)) $ ");") $ Chr(10)) $ "shakeObj.direction = directionType(") $ string(shakeObj.Direction)) $ ");") $ Chr(10)) $ "shakeObj.shakeSize =") @ Chr(34)) $ string(shakeObj.shakeSize)) $ Chr(34)) $ ";") $ Chr(10)) $ "shakeObj.duration =") @ Chr(34)) $ string(shakeObj.Duration)) $ Chr(34)) $ ";") $ Chr(10)) $ "shakeObj.delay =") @ Chr(34)) $ string(shakeObj.Delay)) $ Chr(34)) $ ";") $ Chr(10)) $ "class'L2UITween'.static.Inst().StartShakeObject(shakeObj);");  // EN?: ! Target texture path?
	ClipboardCopy(cord);
	getInstanceL2Util().showGfxScreenMessage("Shake script copyed. → Ctrl + V");
	return;
}

function MaketweenObjectFormString(string param)
{
	local L2UITween.TweenObject tweenObj;
	local L2UITween.ShakeObject shakeObj;
	local L2UITweenTwinkleObject twinkleObject;
	local string targetString;
	local int easeTypenum;
	local string Type;
	local int Dir;

	ParseString(param, "target", targetString);
	ParseString(param, "type", Type);
	switch(Type)
	{
		case "tween":
			tweenObj.Owner = m_Windowname;
			tweenObj.Target = GetWindowHandle(targetString);
			ParseInt(param, "ease", easeTypenum);
			tweenObj.ease = easeType(easeTypenum);
			ParseFloat(param, "duration", tweenObj.Duration);
			ParseFloat(param, "alpha", tweenObj.Alpha);
			ParseFloat(param, "moveX", tweenObj.MoveX);
			ParseFloat(param, "moveY", tweenObj.MoveY);
			ParseFloat(param, "sizeX", tweenObj.SizeX);
			ParseFloat(param, "sizeY", tweenObj.SizeY);
			ParseFloat(param, "delay", tweenObj.Delay);
			Class'Interface.L2UITween'.static.Inst().AddTweenObject(tweenObj);
			SetTweenParamControls(tweenObj);
			MakeScriptTween(tweenObj);
			break;
		case "shake":
			shakeObj.Target = GetWindowHandle(targetString);
			ParseFloat(param, "shakeSize", shakeObj.shakeSize);
			ParseFloat(param, "duration", shakeObj.Duration);
			ParseFloat(param, "delay", shakeObj.Delay);
			ParseInt(param, "direction", Dir);
			shakeObj.Direction = directionType(Dir);
			Class'Interface.L2UITween'.static.Inst().StartShakeObject(shakeObj);
			SetShakeParamControls(shakeObj);
			MakeScriptShake(shakeObj);
			break;
		case "Twinkle":
			twinkleObject = new Class'Interface.L2UITweenTwinkleObject';
			ParseFloat(param, "alpha", twinkleObject.gab);
			ParseFloat(param, "duration", twinkleObject.Duration);
			ParseFloat(param, "moveX", twinkleObject.twinkleNum);
			ParseFloat(param, "moveY", twinkleObject.Position);
			ParseInt(param, "sizeX", twinkleObject.minAlpha);
			ParseInt(param, "sizeY", twinkleObject.maxAlpha);
			SetTwinkleParamControls(twinkleObject);
			Class'Interface.L2UITween'.static.Inst()._AddTweenTwinlkle(GetWindowHandle(targetString), (twinkleObject.twinkleNum / 10.0000000), (twinkleObject.Position / 10.0000000), twinkleObject.Duration, twinkleObject.minAlpha, twinkleObject.maxAlpha, twinkleObject.gab);
			break;
		default:
			break;
	}
	return;
}

function string GetParamsStringFromControlValue()
{
	local string params;
	local ETweenParamType tweenType;

	tweenType = ETweenParamType(tweenTypeComboBox.GetSelectedNum());
	ParamAdd(params, "target", "UITweenTestWnd.texture0");
	ParamAdd(params, "type", string(GetEnum(Enum'ETweenParamType', tweenTypeComboBox.GetSelectedNum())));
	if((int(tweenType) == 0))
	{
		ParamAdd(params, tweenDurationSlider._GetTitle(), string(tweenDurationSlider._GetValue()));
		ParamAdd(params, tweenAlphaSlider._GetTitle(), string(tweenAlphaSlider._GetValue()));
		ParamAdd(params, tweenSizeXSlider._GetTitle(), string(tweenSizeXSlider._GetValue()));
		ParamAdd(params, tweenSizeYSlider._GetTitle(), string(tweenSizeYSlider._GetValue()));
		ParamAdd(params, tweenMoveXSlider._GetTitle(), string(tweenMoveXSlider._GetValue()));
		ParamAdd(params, tweenMoveYSlider._GetTitle(), string(tweenMoveYSlider._GetValue()));
		ParamAdd(params, tweenDelaySlider._GetTitle(), string(tweenDelaySlider._GetValue()));
		ParamAdd(params, "ease", string(tweenEaseTypeComboBox.GetSelectedNum()));
	}
	else if((int(tweenType) == 1))
	{
		ParamAdd(params, shakeDurationSlider._GetTitle(), string(shakeDurationSlider._GetValue()));
		ParamAdd(params, shakeSizeSlider._GetTitle(), string(shakeSizeSlider._GetValue()));
		ParamAdd(params, shakeDelaySlider._GetTitle(), string(shakeDelaySlider._GetValue()));
		ParamAdd(params, "direction", string(shakeDirectionComboBox.GetSelectedNum()));
	}
	else if((int(tweenType) == 2))
	{
		ParamAdd(params, tweenDurationSlider._GetTitle(), string(tweenDurationSlider._GetValue()));
		ParamAdd(params, tweenAlphaSlider._GetTitle(), string(tweenAlphaSlider._GetValue()));
		ParamAdd(params, tweenAlphaSlider._GetTitle(), string(tweenAlphaSlider._GetValue()));
		ParamAdd(params, tweenMoveXSlider._GetTitle(), string(tweenMoveXSlider._GetValue()));
		ParamAdd(params, tweenMoveYSlider._GetTitle(), string(tweenMoveYSlider._GetValue()));
		ParamAdd(params, tweenSizeXSlider._GetTitle(), string(tweenSizeXSlider._GetValue()));
		ParamAdd(params, tweenSizeYSlider._GetTitle(), string(tweenSizeYSlider._GetValue()));
		ParamAdd(params, tweenDelaySlider._GetTitle(), string(tweenDelaySlider._GetValue()));
	}
	return params;
}

function ResetTextures()
{
	texture0.SetAlpha(255);
	texture0.SetWindowSize(100, 100);
	texture0.SetAnchor(m_Windowname, "TopLeft", "TopLeft", 100, 100);
	texture0.ClearAnchor();
	Texture1.SetAlpha(255);
	Texture1.SetWindowSize(100, 100);
	Texture1.SetAnchor(m_Windowname, "TopLeft", "TopLeft", 400, 100);
	Texture1.ClearAnchor();
	return;
}

function ResetParams()
{
	local L2UITween.TweenObject defaultTweenObj;

	defaultTweenObj.Duration = 1000.0000000;
	defaultTweenObj.Alpha = 100.0000000;
	defaultTweenObj.MoveX = 100.0000000;
	defaultTweenObj.MoveY = -50.0000000;
	defaultTweenObj.SizeX = 100.0000000;
	defaultTweenObj.SizeY = 100.0000000;
	defaultTweenObj.Delay = 0.0000000;
	defaultTweenObj.ease = OUT_BOUNCE;
	SetTweenParamControls(defaultTweenObj);
	return;
}

function SetTweenParamControls(L2UITween.TweenObject tweenObj)
{
	tweenTypeComboBox.SetSelectedNum(0);
	SetTweenParamTypePanel(Tween);
	tweenEaseTypeComboBox.SetSelectedNum(int(tweenObj.ease));
	tweenDurationSlider._SetValue(int(tweenObj.Duration));
	tweenAlphaSlider._SetValue(int(tweenObj.Alpha));
	tweenSizeXSlider._SetValue(int(tweenObj.SizeX));
	tweenSizeYSlider._SetValue(int(tweenObj.SizeY));
	tweenMoveXSlider._SetValue(int(tweenObj.MoveX));
	tweenMoveYSlider._SetValue(int(tweenObj.MoveY));
	tweenDelaySlider._SetValue(int(tweenObj.Delay));
	return;
}

function SetShakeParamControls(L2UITween.ShakeObject shakeObj)
{
	tweenTypeComboBox.SetSelectedNum(1);
	SetTweenParamTypePanel(Shake);
	shakeDirectionComboBox.SetSelectedNum(int(shakeObj.Direction));
	shakeDurationSlider._SetValue(int(shakeObj.Duration));
	shakeSizeSlider._SetValue(int(shakeObj.shakeSize));
	shakeDelaySlider._SetValue(int(shakeObj.Delay));
	return;
}

function SetTwinkleParamControls(L2UITweenTwinkleObject twinkleObj)
{
	tweenTypeComboBox.SetSelectedNum(2);
	SetTweenParamTypePanel(Twinkle);
	tweenDurationSlider._SetValue(int(twinkleObj.Duration));
	tweenAlphaSlider._SetValue(int(twinkleObj.gab));
	tweenSizeXSlider._SetValue(twinkleObj.minAlpha);
	tweenSizeYSlider._SetValue(twinkleObj.maxAlpha);
	tweenMoveXSlider._SetValue(int(twinkleObj.twinkleNum));
	tweenMoveYSlider._SetValue(int(twinkleObj.Position));
	tweenDelaySlider._SetValue(int(twinkleObj.Delay));
	return;
}

function UpdateTweenParamString()
{
	tweenParamEditBox.SetString(GetParamsStringFromControlValue());
	return;
}

function SetValueString(string strID, int Value)
{
	SetValue(Right(strID, (Len(strID) - 10)), Value);
	return;
}

function SetValue(string typeString, int Value)
{
	GetEditBoxHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtICurTick") $ typeString)).SetString(string(Value));
	return;
}

function string GetTweenName(ETweenParamType Index)
{
	switch(Index)
	{
		case Shake:
			return "Shake";
		case Tween:
			return "Tween";
		case Twinkle:
			return "Twinkle";
		default:
			return "";
	}
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="UITweenTestWnd"
}
