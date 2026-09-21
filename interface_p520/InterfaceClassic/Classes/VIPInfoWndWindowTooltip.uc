class VIPInfoWndWindowTooltip extends UICommonAPI;

const VIP_MAX_GRADE = 10;
const GAB_VIPS_W = 20;
const GAB_MINE_W = 3;

var string m_Windowname;
var WindowHandle Me;
var SideBar SideBarScript;
var StatusBarHandle VIPBar;
var WindowHandle VIPs;
var TextBoxHandle VIPText;
var WindowHandle Mine;
var bool isMax;
var int barWidth;

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	SideBarScript = SideBar(GetScript("SideBar"));
	VIPBar = GetStatusBarHandle((m_Windowname $ ".VIPBar"));
	VIPs = GetWindowHandle((m_Windowname $ ".VIPs"));
	VIPText = GetTextBoxHandle((m_Windowname $ ".VIPs.VIPText"));
	Mine = GetWindowHandle((m_Windowname $ ".Mine"));
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(20150);
	return;
}

function OnLoad()
{
	Initialize();
	return;
}

function OnShow()
{
	HandleOnShow();
	return;
}

function OnHide()
{
	HandleOnHide();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 20150:
			HandleEV_VipInfo(param);
			break;
		default:
			break;
	}
	return;
}

function HandleEV_VipInfo(string param)
{
	local int CurrVipLevel, CurrVipPoint, NextVipPoint, DisappearPoint, PrevVipLevel, DisappearNextPoint, afterDisappearPoint, totalPoint, barW;

	ParseInt(param, "CurrVipLevel", CurrVipLevel);
	ParseInt(param, "CurrVipPoint", CurrVipPoint);
	ParseInt(param, "NextVipPoint", NextVipPoint);
	ParseInt(param, "DisappearPoint", DisappearPoint);
	ParseInt(param, "PrevVipLevel", PrevVipLevel);
	ParseInt(param, "DisappearNextPoint", DisappearNextPoint);
	isMax = (CurrVipLevel == 10);
	if(isMax)
	{
		totalPoint = CurrVipPoint;
	}
	else
	{
		totalPoint = NextVipPoint;
	}
	VIPBar.SetPoint(INT64(CurrVipPoint), INT64(totalPoint));
	SetStartX();
	barW = GetBarWidth();
	if((CurrVipLevel == 0))
	{
		VIPs.HideWindow();
	}
	else
	{
		VIPs.ShowWindow();
	}
	VIPText.SetText((GetSystemString(5819) @ string(PrevVipLevel)));
	VIPs.Move(int((((float(barW) / float(totalPoint)) * float(DisappearNextPoint)) - 20.0000000)), 0);
	if((DisappearPoint == 0))
	{
		Mine.HideWindow();
	}
	else
	{
		Mine.ShowWindow();
	}
	afterDisappearPoint = (CurrVipPoint - DisappearPoint);
	if((afterDisappearPoint < 0))
	{
		afterDisappearPoint = 0;
	}
	Mine.Move(int((((float(barW) / float(totalPoint)) * float(afterDisappearPoint)) - 3.0000000)), 0);
	Debug((((("HandleEV_VipInfo" @ string(barW)) @ string(totalPoint)) @ string(afterDisappearPoint)) @ string(((float(barW) / float(totalPoint)) * float(afterDisappearPoint)))));
	return;
}

function SetStartX()
{
	local Rect barRect, mineRect, vipsRect;

	barRect = VIPBar.GetRect();
	vipsRect = VIPs.GetRect();
	mineRect = Mine.GetRect();
	VIPs.MoveTo((barRect.nX - 20), vipsRect.nY);
	Mine.MoveTo((barRect.nX - 3), mineRect.nY);
	return;
}

function string GetVipTexturePath(int Level)
{
	return ("L2UI_NewTex.SideBar.SideBar_BRVIPIcon" $ string(Level));
}

function HandleOnShow()
{
	return;
}

function HandleOnHide()
{
	return;
}

function int GetBarWidth()
{
	local Rect barRect;

	barRect = VIPBar.GetRect();
	return barRect.nWidth;
}
