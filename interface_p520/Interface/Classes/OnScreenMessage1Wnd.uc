class OnScreenMessage1Wnd extends UIScript;

const SCREENMESSAGEWND_MAX = 12;

enum Mstate
{
	FADE_IN,                        // 0
	FADE_MIDDLE,                    // 1
	FADE_OUT,                       // 2
	FADE_NONE                       // 3
};

var string currentwnd1;
var int globalDuration;
var int droprate;
var WindowHandle OnScreenMessage2Wnd;
var WindowHandle handlearr[12];
var Mstate states[12];
var int AlphaValues[12];
var int DropValues[12];
var int LifeTimes[12];

function resetByIdx(int idx)
{
	m_hOwnerWnd.KillTimer(idx);
	AlphaValues[idx] = 0;
	DropValues[idx] = 0;
	LifeTimes[idx] = 0;
	states[idx] = FADE_NONE;
	return;
}

function initAll()
{
	local int idx;

	idx = 1;
	while((idx < 12))
	{
		handlearr[idx] = GetWindowHandle((("OnScreenMessage" $ string(idx)) $ "Wnd"));
		AlphaValues[idx] = 0;
		DropValues[idx] = 0;
		LifeTimes[idx] = 0;
		states[idx] = FADE_NONE;
		m_hOwnerWnd.KillTimer(idx);
		handlearr[idx].SetCanBeShownDuringScene(true);
		idx++;
	}
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(140);
	RegisterEvent(141);
	RegisterEvent(580);
	RegisterEvent(9230);
	RegisterEvent(160);
	return;
}

function OnLoad()
{
	initAll();
	currentwnd1 = "";
	OnScreenMessage2Wnd = GetWindowHandle("OnScreenMessage2Wnd");
	return;
}

function OnTimer(int TimerID)
{
	local int idx;

	idx = TimerID;
	if((int(states[idx]) == 0))
	{
		(AlphaValues[idx] += DropValues[idx]);
		if((AlphaValues[idx] >= 255))
		{
			AlphaValues[idx] = 255;
			states[idx] = FADE_MIDDLE;
			m_hOwnerWnd.KillTimer(idx);
			m_hOwnerWnd.SetTimer(idx, LifeTimes[idx]);
		}
		handlearr[idx].SetAlpha(AlphaValues[idx]);
	}
	else if((int(states[idx]) == 1))
	{
		states[idx] = FADE_OUT;
		m_hOwnerWnd.KillTimer(idx);
		m_hOwnerWnd.SetTimer(idx, 30);
	}
	else if((int(states[idx]) == 2))
	{
		(AlphaValues[idx] -= DropValues[idx]);
		if((AlphaValues[idx] <= 0))
		{
			AlphaValues[idx] = 0;
			states[idx] = FADE_NONE;
			m_hOwnerWnd.KillTimer(idx);
			handlearr[idx].HideWindow();
			if((idx == 10))
			{
				GetEffectViewportWndHandle(((("OnScreenMessage" $ string(idx)) $ "Wnd") $ ".EffectViewport01")).HideWindow();
				GetEffectViewportWndHandle(((("OnScreenMessage" $ string(idx)) $ "Wnd") $ ".EffectViewport01")).SpawnEffect("");
			}
		}
		handlearr[idx].SetAlpha(AlphaValues[idx]);
	}
	else if((int(states[idx]) == 3))
	{
	}
	return;
}

function ResetAllMessage()
{
	local int i;
	local Color DefaultColor;
	local string wndname;

	DefaultColor.R = 255;
	DefaultColor.G = 255;
	DefaultColor.B = 255;
	currentwnd1 = "";
	OnScreenMessage2Wnd.HideWindow();
	i = 1;
	while((i < 12))
	{
		if((i == 9))
		{
			++i;
			continue;
		}
		wndname = (("OnScreenMessage" $ string(i)) $ "Wnd");
		if(GetWindowHandle(wndname).IsShowWindow())
		{
			++i;
			continue;
		}
		Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(((wndname $ ".TextBox") $ string(i)), DefaultColor);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor((((wndname $ ".TextBox") $ string(i)) $ "-1"), DefaultColor);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor((((wndname $ ".TextBox") $ string(i)) $ "-2"), DefaultColor);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(((wndname $ ".TextBoxsm") $ string(i)), DefaultColor);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor((((wndname $ ".TextBoxsm") $ string(i)) $ "-1"), DefaultColor);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor((((wndname $ ".TextBoxsm") $ string(i)) $ "-2"), DefaultColor);
		++i;
	}
	return;
}

function ShowMsg(int WndNum, string TextValue, int Duration, int Animation, int FontType, int BackgroundType, int ColorR, int ColorG, int ColorB, optional bool bUseNpcZoom, optional int MsgNo)
{
	local string wndname, TextBoxName, TextBoxName2, TextBoxName3, TextValue1, TextValue2, TextValue3, CurText, SmallBoxName1, SmallBoxName2, SmallBoxName3;
	local Color FontColor;
	local int i, j, LengthTotal, TotalLength;
	local SystemMsgData msgInfo;

	FontColor.R = byte(ColorR);
	FontColor.G = byte(ColorG);
	FontColor.B = byte(ColorB);
	TextValue1 = "";
	TextValue2 = "";
	TextValue3 = "";
	j = 1;
	TotalLength = Len(TextValue);
	i = 1;
	while((i <= TotalLength))
	{
		LengthTotal = (Len(TextValue) - 1);
		CurText = Left(TextValue, 1);
		TextValue = Right(TextValue, LengthTotal);
		if((CurText == "`"))
		{
			CurText = "";
			++i;
			continue;
		}
		if((CurText == "#"))
		{
			CurText = "";
			j++;
			++i;
			continue;
		}
		if((j == 1))
		{
			TextValue1 = (TextValue1 $ CurText);
			++i;
			continue;
		}
		if((j == 2))
		{
			TextValue2 = (TextValue2 $ CurText);
			++i;
			continue;
		}
		TextValue3 = (TextValue3 $ CurText);
		++i;
	}
	wndname = (("OnScreenMessage" $ string(WndNum)) $ "Wnd");
	if((WndNum == 2))
	{
		if((BackgroundType == 1))
		{
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((wndname $ ".texturetype1"));
		}
		else
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow((wndname $ ".texturetype1"));
		}
	}
	else if((WndNum == 10))
	{
		if((BackgroundType != 1))
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow((wndname $ ".texturetype1"));
		}
		if((BackgroundType != 2))
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow((wndname $ ".texturetype2"));
		}
		if((BackgroundType != 3))
		{
			Class'NWindow.UIAPI_WINDOW'.static.HideWindow((wndname $ ".texturetype3"));
		}
		switch(BackgroundType)
		{
			case 1:
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((wndname $ ".texturetype1"));
				break;
			case 2:
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((wndname $ ".texturetype2"));
				break;
			case 3:
				Class'NWindow.UIAPI_WINDOW'.static.ShowWindow((wndname $ ".texturetype3"));
				break;
			default:
				break;
		}
		GetSystemMsgInfo(MsgNo, msgInfo);
		if((msgInfo.OnScrParam != ""))
		{
			setParamEffectViewPlay(wndname, msgInfo.OnScrParam);
		}
		else
		{
			GetEffectViewportWndHandle((wndname $ ".EffectViewport01")).HideWindow();
		}
	}
	TextBoxName = ((wndname $ ".TextBox") $ string(WndNum));
	TextBoxName2 = (((wndname $ ".TextBox") $ string(WndNum)) $ "-1");
	TextBoxName3 = (((wndname $ ".TextBox") $ string(WndNum)) $ "-2");
	SmallBoxName1 = ((wndname $ ".TextBoxsm") $ string(WndNum));
	SmallBoxName2 = (((wndname $ ".TextBoxsm") $ string(WndNum)) $ "-1");
	SmallBoxName3 = (((wndname $ ".TextBoxsm") $ string(WndNum)) $ "-2");
	currentwnd1 = wndname;
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(TextBoxName, FontColor);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(TextBoxName2, FontColor);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(TextBoxName3, FontColor);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(SmallBoxName1, FontColor);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(SmallBoxName2, FontColor);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(SmallBoxName3, FontColor);
	if((FontType == 0))
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(currentwnd1);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText(TextBoxName, TextValue1);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText(TextBoxName2, TextValue2);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText(TextBoxName3, TextValue3);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText(SmallBoxName1, "");
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText(SmallBoxName2, "");
	}
	else if((FontType == 1))
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(currentwnd1);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText(TextBoxName, "");
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText(TextBoxName2, "");
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText(TextBoxName3, "");
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText(SmallBoxName1, TextValue1);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText(SmallBoxName2, TextValue2);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText(SmallBoxName3, TextValue3);
	}
	switch(Animation)
	{
		case 0:
			droprate = 255;
			break;
		case 1:
			droprate = 25;
			break;
		case 11:
			droprate = 15;
			break;
		case 12:
			droprate = 25;
			break;
		case 13:
			droprate = 35;
			break;
		default:
			break;
	}
	resetByIdx(WndNum);
	DropValues[WndNum] = droprate;
	states[WndNum] = FADE_IN;
	if(!bUseNpcZoom)
	{
		LifeTimes[WndNum] = Duration;
		m_hOwnerWnd.SetTimer(WndNum, 30);
	}
	return;
}

function setParamEffectViewPlay(string wndname, string a_Param)
{
	local float nScale, fCameraDistance;
	local int X, Y;
	local string effect;
	local Vector offset;
	local int nPitch, nYaw;

	ParseFloat(a_Param, "scale", nScale);
	ParseFloat(a_Param, "distance", fCameraDistance);
	ParseInt(a_Param, "x", X);
	ParseInt(a_Param, "y", Y);
	ParseInt(a_Param, "pitch", nPitch);
	ParseInt(a_Param, "yaw", nYaw);
	ParseString(a_Param, "effect", effect);
	offset.X = float(X);
	offset.Y = float(Y);
	Debug(("setParamEffectViewPlay:" @ effect));
	Debug(a_Param);
	GetEffectViewportWndHandle((wndname $ ".EffectViewport01")).ShowWindow();
	GetEffectViewportWndHandle((wndname $ ".EffectViewport01")).SpawnEffect("");
	GetEffectViewportWndHandle((wndname $ ".EffectViewport01")).SetScale(nScale);
	GetEffectViewportWndHandle((wndname $ ".EffectViewport01")).SetCameraPitch(nPitch);
	GetEffectViewportWndHandle((wndname $ ".EffectViewport01")).SetCameraYaw(nYaw);
	GetEffectViewportWndHandle((wndname $ ".EffectViewport01")).SetCameraDistance(fCameraDistance);
	GetEffectViewportWndHandle((wndname $ ".EffectViewport01")).SetOffset(offset);
	GetEffectViewportWndHandle((wndname $ ".EffectViewport01")).SpawnEffect(effect);
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	local int MsgType, MsgNo, WindowType, FontSize, FontType, msgcolor, msgcolorR, msgcolorG, msgcolorB, shadowtype, BackgroundType, LifeTime, AnimationType, SystemMsgIndex;
	local string MsgText, ParamString1, ParamString2;

	if((a_EventID == 140))
	{
		ParseInt(a_Param, "MsgType", MsgType);
		ParseInt(a_Param, "MsgNo", MsgNo);
		ParseInt(a_Param, "WindowType", WindowType);
		ParseInt(a_Param, "FontSize", FontSize);
		ParseInt(a_Param, "FontType", FontType);
		ParseInt(a_Param, "MsgColor", msgcolor);
		ParseInt(a_Param, "MsgColorR", msgcolorR);
		ParseInt(a_Param, "MsgColorG", msgcolorG);
		ParseInt(a_Param, "MsgColorB", msgcolorB);
		if(((msgcolor > -1) && (((msgcolorR + msgcolorG) + msgcolorB) == 0)))
		{
			switch(msgcolor)
			{
				case 1:
					msgcolorR = 255;
					msgcolorG = 255;
					msgcolorB = 255;
					break;
				case 2:
					msgcolorR = 175;
					msgcolorG = 175;
					msgcolorB = 175;
					break;
				case 3:
					msgcolorR = 0;
					msgcolorG = 170;
					msgcolorB = 255;
					break;
				case 4:
					msgcolorR = 255;
					msgcolorG = 102;
					msgcolorB = 102;
					break;
				case 5:
					msgcolorR = 255;
					msgcolorG = 221;
					msgcolorB = 1025;
					break;
				default:
					msgcolorR = 255;
					msgcolorG = 255;
					msgcolorB = 255;
					break;
			}
		}
		else
		{
			if(!ParseInt(a_Param, "MsgColorR", msgcolorR))
			{
				msgcolorR = 255;
			}
			if(!ParseInt(a_Param, "MsgColorG", msgcolorG))
			{
				msgcolorG = 255;
			}
			if(!ParseInt(a_Param, "MsgColorB", msgcolorB))
			{
				msgcolorB = 255;
			}
		}
		ParseInt(a_Param, "ShadowType", shadowtype);
		ParseInt(a_Param, "BackgroundType", BackgroundType);
		ParseInt(a_Param, "LifeTime", LifeTime);
		ParseInt(a_Param, "AnimationType", AnimationType);
		ParseString(a_Param, "Msg", MsgText);
		ResetAllMessage();
		if((MsgType == 0))
		{
			MsgText = GetSystemMessage(MsgNo);
		}
		if((WindowType > 11))
		{
			Debug(("!!!!!!!!!!!!!!!!!!!! EV_ShowScreenMessage! windowtype 오류 : " @ string(WindowType)));  // EN: !!!!!!!!!!!!!!!!!!!! EV_ShowScreenMessage! windowtype error :
			Debug("!!!!!!!!!!!!!!!!!!!! 0~11까지 위치타입을 입력 가능합니다");  // EN?: You can enter a location type from !!!!!!!!!!!!!!!!!!!! 0 to 11.
			return;
		}
		ShowMsg(WindowType, MsgText, LifeTime, AnimationType, FontType, BackgroundType, msgcolorR, msgcolorG, msgcolorB, false, MsgNo);
	}
	else if((a_EventID == 141))
	{
		ParseInt(a_Param, "MsgType", MsgType);
		ParseInt(a_Param, "MsgNo", MsgNo);
		ParseInt(a_Param, "WindowType", WindowType);
		ParseInt(a_Param, "FontSize", FontSize);
		ParseInt(a_Param, "FontType", FontType);
		if(ParseInt(a_Param, "MsgColor", msgcolor))
		{
			if((msgcolor == 0))
			{
				msgcolor = 16777215;
			}
			msgcolorR = ((msgcolor & 16711680) >> 16);
			msgcolorG = ((msgcolor & 65280) >> 8);
			msgcolorB = (msgcolor & 255);
		}
		else
		{
			if(!ParseInt(a_Param, "MsgColorR", msgcolorR))
			{
				msgcolorR = 255;
			}
			if(!ParseInt(a_Param, "MsgColorG", msgcolorG))
			{
				msgcolorG = 255;
			}
			if(!ParseInt(a_Param, "MsgColorB", msgcolorB))
			{
				msgcolorB = 255;
			}
		}
		ParseInt(a_Param, "ShadowType", shadowtype);
		ParseInt(a_Param, "BackgroundType", BackgroundType);
		ParseInt(a_Param, "LifeTime", LifeTime);
		ParseInt(a_Param, "AnimationType", AnimationType);
		ParseString(a_Param, "Msg", MsgText);
		ResetAllMessage();
		switch(MsgType)
		{
			case 0:
				MsgText = GetSystemMessage(MsgNo);
				break;
			case 1:
				break;
			case 2:
				MsgText = (MsgText $ "...");
				break;
			default:
				break;
		}
		ShowMsg(WindowType, MsgText, LifeTime, AnimationType, FontType, BackgroundType, msgcolorR, msgcolorG, msgcolorB, true, MsgNo);
	}
	else if((a_EventID == 580))
	{
		ParseInt(a_Param, "Index", SystemMsgIndex);
		ParseString(a_Param, "Param1", ParamString1);
		ParseString(a_Param, "Param2", ParamString2);
		ValidateSystemMsg(SystemMsgIndex, ParamString1, ParamString2);
	}
	else if((a_EventID == 160))
	{
		Clear();
	}
	else if((a_EventID == 9230))
	{
		ParseString(a_Param, "string", ParamString1);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("OnScreenMessage2Wnd.TextBox2", "");
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("OnScreenMessage2Wnd.TextBox2-1", ParamString1);
		if((ParamString1 == ""))
		{
			OnScreenMessage2Wnd.HideWindow();
		}
		else
		{
			OnScreenMessage2Wnd.SetAlpha(255);
			OnScreenMessage2Wnd.ShowWindow();
		}
	}
	return;
}

function Clear()
{
	initAll();
	currentwnd1 = "";
	return;
}

function ValidateSystemMsg(int Index, string StringTxt1, string StringTxt2)
{
	local SystemMsgData SystemMsgCurrent;
	local int WindowType, FontType, BackgroundType, LifeTime, AnimationType;
	local string MsgText;
	local Color TextColor;

	GetSystemMsgInfo(Index, SystemMsgCurrent);
	if((SystemMsgCurrent.WindowType != 0))
	{
		WindowType = SystemMsgCurrent.WindowType;
		MsgText = SystemMsgCurrent.OnScrMsg;
		MsgText = MakeFullSystemMsg(MsgText, StringTxt1, StringTxt2);
		LifeTime = (SystemMsgCurrent.LifeTime * 1000);
		AnimationType = SystemMsgCurrent.AnimationType;
		FontType = SystemMsgCurrent.FontType;
		BackgroundType = SystemMsgCurrent.BackgroundType;
		TextColor = SystemMsgCurrent.FontColor;
		if((((int(TextColor.R) == 0) && (int(TextColor.G) == 0)) && (int(TextColor.B) == 0)))
		{
			TextColor.R = 255;
			TextColor.G = 255;
			TextColor.B = 255;
		}
		else if((((int(TextColor.R) == 176) && (int(TextColor.G) == 155)) && (int(TextColor.B) == 121)))
		{
			TextColor.R = 255;
			TextColor.G = 255;
			TextColor.B = 255;
		}
		ShowMsg(WindowType, MsgText, LifeTime, AnimationType, FontType, BackgroundType, int(TextColor.R), int(TextColor.G), int(TextColor.B), false, Index);
	}
	return;
}
