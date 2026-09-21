class UIControlGroupButtonAssets extends UICommonAPI;

const TimeID = 1234567;

var int delayButtonTime;
var bool bOnDelayTime;
var string m_Windowname;
var WindowHandle Me;
var UIControlGroupButtons groupButtons;
var string textureNormal;
var string textureDown;
var string textureOver;
var bool bUseLongButtonTextTooltip;
var array<TextureHandle> dotTextureGroup;
//var delegate<DelegateOnDelayTime> __DelegateOnDelayTime__Delegate;

delegate DelegateOnDelayTime(bool bOnDelayTime)
{
	return;
}

static function UIControlGroupButtonAssets _InitScript(WindowHandle wnd)
{
	local UIControlGroupButtonAssets scr;

	wnd.SetScript("UIControlGroupButtonAssets");
	scr = UIControlGroupButtonAssets(wnd.GetScript());
	scr.InitWnd(wnd);
	return scr;
}

function InitWnd(WindowHandle wnd)
{
	m_hOwnerWnd = wnd;
	_SetWindow(m_hOwnerWnd.m_WindowNameWithFullPath);
	return;
}

function _SetWindow(string WindowName)
{
	m_Windowname = WindowName;
	Me = GetWindowHandle(m_Windowname);
	groupButtons = new Class'Interface.UIControlGroupButtons';
	return;
}

function _SetStartInfo(optional string pTextureNormal, optional string pTextureDown, optional string pTextureOver, optional bool pBUseLongButtonTextTooltip, optional bool bDoNotUseAutoButtonHeight)
{
	local int i;
	local Rect R;

	if((pTextureNormal == ""))
	{
		textureNormal = "L2UI_ct1.RankingWnd.RankingWnd_SubTabButton";
	}
	else
	{
		textureNormal = pTextureNormal;
	}
	if((pTextureDown == ""))
	{
		textureDown = "L2UI_ct1.RankingWnd.RankingWnd_SubTabButton_Down";
	}
	else
	{
		textureDown = pTextureDown;
	}
	if((pTextureOver == ""))
	{
		textureOver = "L2UI_ct1.RankingWnd.RankingWnd_SubTabButton_Over";
	}
	else
	{
		textureOver = pTextureOver;
	}
	bUseLongButtonTextTooltip = pBUseLongButtonTextTooltip;
	groupButtons._SetStartInfo(textureNormal, textureDown, textureOver, bUseLongButtonTextTooltip);
	i = 0;
	while((GetButtonHandle(((m_Windowname $ ".__selectButton") $ string(i))).m_pTargetWnd != none))
	{
		groupButtons._addButtonController(GetButtonHandle(((m_Windowname $ ".__selectButton") $ string(i))));
		GetTextureHandle(((m_Windowname $ ".__Condition_tex") $ string(i))).HideWindow();
		dotTextureGroup[dotTextureGroup.Length] = GetTextureHandle(((m_Windowname $ ".__Condition_tex") $ string(i)));
		i++;
	}
	if(!bDoNotUseAutoButtonHeight)
	{
		R = Me.GetRect();
		groupButtons._setButtonHeight(R.nHeight);
	}
	GetTextureHandle((m_Windowname $ ".disable_tex")).HideWindow();
	return;
}

function UIControlGroupButtons _GetGroupButtonsInstance()
{
	return groupButtons;
}

function _setDelayTime(int DelayTime)
{
	delayButtonTime = DelayTime;
	bOnDelayTime = false;
	return;
}

function _clearDelayTime()
{
	delayButtonTime = 0;
	bOnDelayTime = false;
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 1234567))
	{
		Me.KillTimer(1234567);
		_SetEnable();
		DelegateOnDelayTime(bOnDelayTime);
	}
	return;
}

event OnClickButton(string Name)
{
	local string beforeSelectButtonName;

	if((Left(Name, Len("__selectButton")) == "__selectButton"))
	{
		if((bOnDelayTime == false))
		{
			beforeSelectButtonName = groupButtons._getSelectButtonName();
			groupButtons._selectButton(Name);
			if((beforeSelectButtonName == Name))
			{
				if(groupButtons._getUseOverlapClickPrevention())
				{
					_tryDelayClick();
				}
			}
			else
			{
				_tryDelayClick();
			}
		}
	}
	return;
}

event OnMouseOver(WindowHandle winHandle)
{
	groupButtons._OverButtonHandle(winHandle);
	return;
}

event OnMouseOut(WindowHandle winHandle)
{
	groupButtons._OutButtonHandle(winHandle);
	return;
}

event OnLButtonDown(WindowHandle winHandle, int X, int Y)
{
	groupButtons._DownButtonHandle(winHandle);
	return;
}

function _tryDelayClick()
{
	if((delayButtonTime > 0))
	{
		Me.KillTimer(1234567);
		Me.SetTimer(1234567, delayButtonTime);
		_SetDisable();
		DelegateOnDelayTime(bOnDelayTime);
	}
	return;
}

function _SetDisable()
{
	GetTextureHandle((m_Windowname $ ".disable_tex")).SetWindowSize(Me.GetRect().nWidth, Me.GetRect().nHeight);
	GetTextureHandle((m_Windowname $ ".disable_tex")).ShowWindow();
	groupButtons._setDisableAll(true);
	bOnDelayTime = true;
	return;
}

function _SetEnable()
{
	GetTextureHandle((m_Windowname $ ".disable_tex")).HideWindow();
	groupButtons._setEnableAll(true);
	bOnDelayTime = false;
	return;
}

function _DotTextureAllShow(bool bShow)
{
	local int i;

	i = 0;
	while((i < dotTextureGroup.Length))
	{
		if(bShow)
		{
			dotTextureGroup[i].ShowWindow();
			i++;
			continue;
		}
		dotTextureGroup[i].HideWindow();
		i++;
	}
	return;
}

function _DotTextureShow(int buttonIndex, bool bShow, optional int dotX, optional int dotY, optional string alignXStr)
{
	if((dotTextureGroup.Length > buttonIndex))
	{
		if(bShow)
		{
			if((dotX == 0))
			{
				dotX = -4;
			}
			if((dotY == 0))
			{
				dotY = 4;
			}
			if((alignXStr == ""))
			{
				alignXStr = "right";
			}
			groupButtons._setTextureLoc(buttonIndex, dotTextureGroup[buttonIndex], dotX, dotY, alignXStr);
			dotTextureGroup[buttonIndex].ShowWindow();
		}
		else
		{
			dotTextureGroup[buttonIndex].HideWindow();
		}
	}
	return;
}

function _DotTextureColorModify(int buttonIndex, Color dotColor)
{
	if((dotTextureGroup.Length > buttonIndex))
	{
		dotTextureGroup[buttonIndex].SetColorModify(dotColor);
	}
	return;
}

function _DotTextureChangeTexture(int buttonIndex, string texPath)
{
	if((dotTextureGroup.Length > buttonIndex))
	{
		dotTextureGroup[buttonIndex].SetTexture(texPath);
	}
	return;
}
