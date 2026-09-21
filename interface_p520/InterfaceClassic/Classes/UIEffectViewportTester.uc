class UIEffectViewportTester extends UICommonAPI;

var EditBoxHandle NCEditBox0;
var EffectViewportWndHandle effectViewport;
var L2UITween l2UITweenScript;
var L2UITimerObject timeObject;
var array<string> Effects;
var bool _isInit;
var bool isOnLoaded;

event OnLoad()
{
	SetClosingOnESC();
	NCEditBox0 = GetEditBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NCEditBox0"));
	effectViewport = GetEffectViewportWndHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".effectViewport"));
	l2UITweenScript = L2UITween(GetScript("l2UITween"));
	Class'InterfaceClassic.UIListNoteWnd'.static.Inst().delegateOnDBClick = SetParam;
	SetEffects();
	isOnLoaded = true;
	return;
}

function string getParam()
{
	local string param;

	param = "";
	ParamAdd(param, "effect", NCEditBox0.GetString());
	ParamAdd(param, "scale", GetEditorString("Scale"));
	ParamAdd(param, "distance", GetEditorString("Distance"));
	ParamAdd(param, "pitch", GetEditorString("Pitch"));
	ParamAdd(param, "yaw", GetEditorString("Yaw"));
	ParamAdd(param, "X", GetEditorString("OffSetX"));
	ParamAdd(param, "Y", GetEditorString("OffSetY"));
	ParamAdd(param, "Z", GetEditorString("OffSetZ"));
	ParamAdd(param, "W", GetEditorString("Width"));
	ParamAdd(param, "H", GetEditorString("Height"));
	ParamAdd(param, "T", GetEditorString("Timer"));
	return param;
}

function SetParam(string param)
{
	local int tmpNum;
	local string EffectName;
	local float tmpFloat;

	ParseString(param, "effect", EffectName);
	NCEditBox0.SetString(EffectName);
	ParseFloat(param, "scale", tmpFloat);
	SetFValue("scale", tmpFloat);
	ParseInt(param, "distance", tmpNum);
	SetValue("distance", tmpNum);
	ParseInt(param, "pitch", tmpNum);
	SetValue("Pitch", tmpNum);
	ParseInt(param, "yaw", tmpNum);
	SetValue("Yaw", tmpNum);
	ParseInt(param, "X", tmpNum);
	SetValue("OffsetX", tmpNum);
	ParseInt(param, "Y", tmpNum);
	SetValue("OffsetY", tmpNum);
	ParseInt(param, "Z", tmpNum);
	SetValue("OffsetZ", tmpNum);
	ParseInt(param, "W", tmpNum);
	SetValue("Width", tmpNum);
	ParseInt(param, "H", tmpNum);
	SetValue("Height", tmpNum);
	ParseInt(param, "T", tmpNum);
	SetValue("Timer", tmpNum);
	SetAllCurTick();
	Start();
	return;
}

event OnClickButtonWithHandle(ButtonHandle wh)
{
	local Rect rectWnd;

	switch(wh.GetWindowName())
	{
		case "defaultList":
			rectWnd = wh.GetRect();
			ShowContextMenu(rectWnd.nX, rectWnd.nY);
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string strBtn)
{
	switch(strBtn)
	{
		case "ButtonStart":
			Start();
			break;
		case "ButtonOnScreen":
			HandleOnClickButtonOnScreen();
			break;
		case "ResetBtn":
			Reset();
			break;
		case "SaveBtn":
			Class'InterfaceClassic.UIListNoteWnd'.static.Inst().delegateGetParam = getParam;
			Class'InterfaceClassic.UIListNoteWnd'.static.Inst()._SetString(NCEditBox0.GetString());
			Class'InterfaceClassic.UIListNoteWnd'.static.Inst()._Show(m_hOwnerWnd);
			break;
		default:
			break;
	}
	return;
}

event OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
	local float fTick;

	switch(strID)
	{
		case "SliderCtrlScale":
			fTick = (float(iCurrentTick) / 100.0000000);
			if((fTick == 0.0000000))
			{
				fTick = 0.0100000;
			}
			effectViewport.SetScale(fTick);
			SetFValueString(strID, fTick);
			if(GetWindowHandle("OnscreenEffectViewPortWnd").IsShowWindow())
			{
				EffectViewUpdate();
			}
			break;
		case "SliderCtrlDistance":
			effectViewport.SetCameraDistance(float(iCurrentTick));
			SetValueString(strID, iCurrentTick);
			if(GetWindowHandle("OnscreenEffectViewPortWnd").IsShowWindow())
			{
				EffectViewUpdate();
			}
			break;
		case "SliderCtrlPitch":
			effectViewport.SetCameraPitch(iCurrentTick);
			SetValueString(strID, iCurrentTick);
			if(GetWindowHandle("OnscreenEffectViewPortWnd").IsShowWindow())
			{
				EffectViewUpdate();
			}
			break;
		case "SliderCtrlYaw":
			effectViewport.SetCameraYaw(iCurrentTick);
			SetValueString(strID, iCurrentTick);
			if(GetWindowHandle("OnscreenEffectViewPortWnd").IsShowWindow())
			{
				EffectViewUpdate();
			}
			break;
		case "SliderCtrlOffSetX":
		case "SliderCtrlOffSetY":
		case "SliderCtrlOffSetZ":
			iCurrentTick = (iCurrentTick - 50);
			SetOffset(strID, iCurrentTick);
			SetValueString(strID, iCurrentTick);
			if(GetWindowHandle("OnscreenEffectViewPortWnd").IsShowWindow())
			{
				EffectViewUpdate();
			}
			break;
		case "SliderCtrlWidth":
		case "SliderCtrlHeight":
			SetValueString(strID, iCurrentTick);
			effectViewport.SetWindowSize(int(GetEditorString("Width")), int(GetEditorString("Height")));
			break;
		case "SliderCtrlTimer":
			SetValueString(strID, iCurrentTick);
			timeObject._time = iCurrentTick;
			if((timeObject._time == 0))
			{
				timeObject._Stop();
			}
			else
			{
				timeObject._Reset();
			}
			break;
		default:
			break;
	}
	return;
}

event OnCompleteEditBox(string strID)
{
	local SliderCtrlHandle slider;
	local int Value;

	switch(strID)
	{
		case "txtICurTickOffSetX":
		case "txtICurTickOffSetY":
		case "txtICurTickOffSetZ":
			Value = (int(GetEditBoxHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ strID)).GetString()) + 50);
			break;
		case "txtIcurTickScale":
			Value = int((float(GetEditBoxHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ strID)).GetString()) * 100.0000000));
			break;
		default:
			Value = int(GetEditBoxHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ strID)).GetString());
			break;
	}
	slider = GetSliderCtrlHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrl") $ Right(strID, (Len(strID) - 11))));
	slider.SetCurrentTick(Value);
	return;
}

event OnShow()
{
	if(!_isInit)
	{
		timeObject = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(int(GetEditorString("Timer")), -1);
		timeObject._DelegateOnTime = OnTimeFunc;
		_isInit = true;
	}
	return;
}

event OnHide()
{
	timeObject._Stop();
	return;
}

function SetEffects()
{
	local int i;

	Effects[i++] = "LineageEffect2.ui_screen_message_flow";
	Effects[i++] = "LineageEffect2.ui_screen_message02_flow";
	Effects[i++] = "LineageEffect2.ui_screen_message03_flow";
	Effects[i++] = "LineageEffect.br_e_u014_turkey_atk4b";
	Effects[i++] = "LineageEffect2.ui_upgrade_succ";
	Effects[i++] = "LineageEffect_br.br_e_firebox_fire_b";
	Effects[i++] = "LineageEffect2.ui_star_circle";
	Effects[i++] = "LineageEffect_br.br_e_lamp_deco_d";
	Effects[i++] = "LineageEffect.d_ar_attractcubic_ta";
	Effects[i++] = "LineageEffect2.ui_spirit_lvup";
	Effects[i++] = "LineageEffect2.bg_astatine_portal";
	Effects[i++] = "LineageEffect.d_firework_a";
	Effects[i++] = "LineageEffect.d_firework_b";
	Effects[i++] = "LineageEffect2.ui_spirit_extract";
	Effects[i++] = "LineageEffect2.ui_upgrade_fail";
	Effects[i++] = "LineageEffect2.ave_white_trans_deco";
	Effects[i++] = "LineageEffect2.ui_yellow_smoke";
	Effects[i++] = "LineageEffect2.ui_soul_crystal";
	Effects[i++] = "LineageEffect.br_e_u095_flower_shower";
	Effects[i++] = "LineageEffect2.y_kn_summon_cubic_fire_body";
	Effects[i++] = "LineageEffect.d_chainheal_ta";
	Effects[i++] = "LineageEffect2.white_black_1_dice";
	Effects[i++] = "LineageEffect2.yellow_black_1_dice";
	Effects[i++] = "LineageEffect2.white_red_1_dice";
	return;
}

function Start()
{
	m_hOwnerWnd.SetFocus();
	if((timeObject._time == 0))
	{
		timeObject._Stop();
		SpawnEffect();
	}
	else
	{
		SpawnEffect();
		timeObject._Play();
	}
	MakeClip();
	return;
}

function SpawnEffect()
{
	effectViewport.SpawnEffect(NCEditBox0.GetString());
	return;
}

function OnTimeFunc(int Count)
{
	SpawnEffect();
	return;
}

function ShowContextMenu(int X, int Y)
{
	local int i;
	local UIControlContextMenu ContextMenu;

	ContextMenu = Class'InterfaceClassic.UIControlContextMenu'.static.GetInstance();
	ContextMenu.Clear();
	ContextMenu.DelegateOnClickContextMenu = HandleOnClickContextMenu;
	i = 0;
	while((i < Effects.Length))
	{
		ContextMenu.MenuNew(Effects[i], i);
		i++;
	}
	ContextMenu.Show(X, Y, string(self));
	return;
}

function HandleOnClickContextMenu(int Index)
{
	NCEditBox0.SetString(Class'InterfaceClassic.UIControlContextMenu'.static.GetInstance().menuObjects[Index].Name);
	Class'InterfaceClassic.UIListNoteWnd'.static.Inst()._SetString(Class'InterfaceClassic.UIControlContextMenu'.static.GetInstance().menuObjects[Index].Name);
	return;
}

function HandleOnClickButtonOnScreen()
{
	EffectViewUpdate();
	return;
}

function EffectViewUpdate()
{
	local OnScreenMessage1Wnd onScreenMessage1WndSrc;
	local string param, TextValue;
	local int Duration, Animation, FontType, BackgroundType, ColorR, ColorG, ColorB;
	local bool bUseNpcZoom;
	local int MsgNo, lineNum;
	local ButtonHandle btn;
	local string textScript;

	onScreenMessage1WndSrc = OnScreenMessage1Wnd(GetScript("OnScreenMessage1Wnd"));
	btn = GetMeButton("ButtonOnScreen");
	lineNum = (btn.GetButtonValue() + 1);
	if((lineNum > 3))
	{
		lineNum = 1;
	}
	btn.SetButtonValue(lineNum);
	Debug((string(btn.GetButtonValue()) @ string(lineNum)));
	param = "";
	ParamAdd(param, "scale", string((GetSliderCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlScale")).GetCurrentTick() / 100)));
	ParamAdd(param, "distance", string(GetSliderCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlDistance")).GetCurrentTick()));
	ParamAdd(param, "x", string((GetSliderCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlOffSetX")).GetCurrentTick() - 50)));
	ParamAdd(param, "y", string((GetSliderCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlOffSetY")).GetCurrentTick() - 50)));
	ParamAdd(param, "effect", NCEditBox0.GetString());
	ParamAdd(param, "yaw", string(GetSliderCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlYaw")).GetCurrentTick()));
	ParamAdd(param, "pitch", string(GetSliderCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlPitch")).GetCurrentTick()));
	ParamAdd(param, "width", string(GetSliderCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlWidth")).GetCurrentTick()));
	ParamAdd(param, "height", string(GetSliderCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlHeight")).GetCurrentTick()));
	TextValue = param;
	textScript = TextValue;
	switch(lineNum)
	{
		case 1:
			break;
		case 2:
			TextValue = ((TextValue $ Chr(10)) $ "Chr(10) 은 앞 들여 쓰기가 됩니다. # Chr(35) 는 가운데 정렬입니다.");  // EN?: Chr (10) is indented. # Chr (35) is the center alignment.
			break;
		case 3:
			TextValue = (TextValue $ "# ↓ # Ctrl + V 로 붙여 쓰세요");  // EN?: # ↓ # Paste in Ctrl + V
			break;
		default:
			break;
	}
	btn.SetNameText(("OnScreenEffectViewPort" @ string(lineNum)));
	FontType = 0;
	ColorR = 255;
	ColorG = 255;
	ColorB = 255;
	bUseNpcZoom = true;
	onScreenMessage1WndSrc.ShowMsg(10, TextValue, Duration, Animation, FontType, BackgroundType, ColorR, ColorG, ColorB, bUseNpcZoom, MsgNo);
	Debug(param);
	onScreenMessage1WndSrc.setParamEffectViewPlay("OnScreenMessage10Wnd", param);
	MakeEffectMessgeClip();
	return;
}

function MakeEffectMessgeClip()
{
	local string param;

	param = ("scale=" $ string((GetSliderCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlScale")).GetCurrentTick() / 100)));
	param = ((param @ "distance=") $ string(GetSliderCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlDistance")).GetCurrentTick()));
	param = ((param @ "x=") $ string((GetSliderCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlOffSetX")).GetCurrentTick() - 50)));
	param = ((param @ "y=") $ string((GetSliderCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlOffSetY")).GetCurrentTick() - 50)));
	param = ((param @ "effect=") $ NCEditBox0.GetString());
	param = ((param @ "yaw=") $ string(GetSliderCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlYaw")).GetCurrentTick()));
	param = ((param @ "pitch=") $ string(GetSliderCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlPitch")).GetCurrentTick()));
	param = ((param @ "width=") $ string(GetSliderCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlWidth")).GetCurrentTick()));
	param = ((param @ "height=") $ string(GetSliderCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlHeight")).GetCurrentTick()));
	ClipboardCopy(((Chr(34) $ param) $ Chr(34)));
	getInstanceL2Util().showGfxScreenMessage("EffectMessage param copyed. → Ctrl + V");
	return;
}

function MakeClip()
{
	local string cord;

	cord = (((((((((((((((((((((((((("effectViewport.SpawnEffect( \"" $ NCEditBox0.GetString()) $ "\");") $ Chr(10)) $ "effectViewport.SetScale(") $ GetEditorString("Scale")) $ ");") $ Chr(10)) $ "effectViewport.SetCameraDistance(") $ GetEditorString("Distance")) $ ");") $ Chr(10)) $ "effectViewport.SetCameraPitch(") $ GetEditorString("Pitch")) $ ");") $ Chr(10)) $ "effectViewport.SetCameraYaw(") $ GetEditorString("Yaw")) $ ");") $ Chr(10)) $ "effectViewport.SetOffset( vec.x=") $ GetEditorString("OffSetX")) $ " vec.y=") $ GetEditorString("OffsetY")) $ " vec.z=") $ GetEditorString("OffsetZ")) $ ");");
	ClipboardCopy(cord);
	getInstanceL2Util().showGfxScreenMessage("Effect script copyed. → Ctrl + V");
	return;
}

function Reset()
{
	NCEditBox0.SetString("LineageEffect2.ui_star_circle");
	OnModifyCurrentTickSliderCtrl("SliderCtrlScale", 100);
	OnModifyCurrentTickSliderCtrl("SliderCtrlDistance", 200);
	OnModifyCurrentTickSliderCtrl("SliderCtrlPitch", 0);
	OnModifyCurrentTickSliderCtrl("SliderCtrlYaw", 0);
	OnModifyCurrentTickSliderCtrl("SliderCtrlOffSetX", 50);
	OnModifyCurrentTickSliderCtrl("SliderCtrlOffSetY", 50);
	OnModifyCurrentTickSliderCtrl("SliderCtrlOffSetZ", 50);
	OnModifyCurrentTickSliderCtrl("SliderCtrlWidth", 600);
	OnModifyCurrentTickSliderCtrl("SliderCtrlHeight", 600);
	OnModifyCurrentTickSliderCtrl("SliderCtrlTimer", 0);
	SetAllCurTick();
	return;
}

function SetAllCurTick()
{
	OnCompleteEditBox("txtICurTickScale");
	OnCompleteEditBox("txtICurTickDistance");
	OnCompleteEditBox("txtICurTickPitch");
	OnCompleteEditBox("txtICurTickYaw");
	OnCompleteEditBox("txtICurTickOffSetX");
	OnCompleteEditBox("txtICurTickOffSetY");
	OnCompleteEditBox("txtICurTickOffSetZ");
	OnCompleteEditBox("txtICurTickOffSetX");
	OnCompleteEditBox("txtICurTickWidth");
	OnCompleteEditBox("txtICurTickHeight");
	OnCompleteEditBox("txtICurTickTimer");
	return;
}

function SetValueString(string strID, int Value)
{
	SetValue(Right(strID, (Len(strID) - 10)), Value);
	return;
}

function SetValue(string typeString, int Value)
{
	local EditBoxHandle EditBox;

	EditBox = GetEditBoxHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtICurTick") $ typeString));
	if((EditBox.m_pTargetWnd != none))
	{
		EditBox.SetString(string(Value));
	}
	return;
}

function SetFValueString(string strID, float Value)
{
	SetFValue(Right(strID, (Len(strID) - 10)), Value);
	return;
}

function SetFValue(string typeString, float Value)
{
	if(!isOnLoaded)
	{
		return;
	}
	GetEditBoxHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtICurTick") $ typeString)).SetString(string(Value));
	return;
}

function string GetValueString(string strID)
{
	return GetEditBoxHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtICurTick") $ Right(strID, (Len(strID) - 10)))).GetString();
}

function string GetEditorString(string typeString)
{
	return GetEditBoxHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtICurTick") $ typeString)).GetString();
}

function SetOffset(string strID, int Value)
{
	local Vector vec;

	vec = GetCurrentOffset();
	switch(strID)
	{
		case "txtICurTickOffSetX":
			vec.X = float(Value);
			break;
		case "txtICurTickOffSetY":
			vec.Y = float(Value);
			break;
		case "txtICurTickOffSetZ":
			vec.Z = float(Value);
			break;
		default:
			break;
	}
	effectViewport.SetOffset(vec);
	return;
}

function Vector GetCurrentOffset()
{
	local Vector offset;

	offset.X = float((GetSliderCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlOffSetX")).GetCurrentTick() - 50));
	offset.Y = float((GetSliderCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlOffSetY")).GetCurrentTick() - 50));
	offset.Z = float((GetSliderCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrlOffSetZ")).GetCurrentTick() - 50));
	return offset;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hOwnerWnd.HideWindow();
	return;
}
