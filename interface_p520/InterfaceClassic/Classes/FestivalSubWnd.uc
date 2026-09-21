class FestivalSubWnd extends UICommonAPI;

const TIMER_ID = 1010122;

var WindowHandle Me;
var ButtonHandle HelpButton;
var ItemWindowHandle GoldItemWindow;
var TextBoxHandle GoldText;
var TextBoxHandle GoldNumberText;
var TextureHandle FestivalProgressIcon;
var TextBoxHandle TimeNumberText;
var ButtonHandle ParticipationBtn;
var AnimTextureHandle BlinkAni;
var FestivalWnd FestivalWndScript;
var int nIsUseFestival;
var int FestivalID;
var int FestivalEndTime;
var int remainSecond;
var bool isFirstNoticeAnim;

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

function NoticeAniPlay()
{
	isFirstNoticeAnim = true;
	BlinkAni.Stop();
	BlinkAni.ShowWindow();
	BlinkAni.SetLoopCount(7);
	BlinkAni.Play();
	return;
}

function OnHide()
{
	BlinkAni.Stop();
	BlinkAni.HideWindow();
	isFirstNoticeAnim = false;
	return;
}

function Initialize()
{
	FestivalWndScript = FestivalWnd(GetScript("FestivalWnd"));
	Me = GetWindowHandle("FestivalSubWnd");
	HelpButton = GetButtonHandle("FestivalSubWnd.FestivalInnerWnd.HelpButton");
	GoldText = GetTextBoxHandle("FestivalSubWnd.FestivalInnerWnd.GoldText");
	GoldNumberText = GetTextBoxHandle("FestivalSubWnd.FestivalInnerWnd.GoldNumberText");
	FestivalProgressIcon = GetTextureHandle("FestivalSubWnd.FestivalInnerWnd.FestivalProgressIcon");
	TimeNumberText = GetTextBoxHandle("FestivalSubWnd.FestivalInnerWnd.TimeNumberText");
	ParticipationBtn = GetButtonHandle("FestivalSubWnd.FestivalInnerWnd.ParticipationBtn");
	GoldItemWindow = GetItemWindowHandle("FestivalSubWnd.FestivalInnerWnd.GoldItemWindow");
	BlinkAni = GetAnimTextureHandle("FestivalSubWnd.BlinkAni");
	return;
}

function Load()
{
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 40))
	{
		Me.KillTimer(1010122);
		GoldItemWindow.DisableWindow();
		isFirstNoticeAnim = false;
	}
	else if((Event_ID == 20280))
	{
		Debug(("-----  EV_FestivalTopItemInfo" @ param));
		SetFestivalTopItemInfo(param);
		updateUI();
	}
	return;
}

function int getFestivalEndTime()
{
	return FestivalEndTime;
}

function updateUI()
{
	if((nIsUseFestival == 1))
	{
		TimeNumberText.SetText(GetSecToTimeStr(FestivalEndTime));
		TimeNumberText.SetTooltipText(GetSystemString(5202));
		FestivalProgressIcon.SetTexture("L2UI_CT1.FestivalWnd_GreenDot");
		FestivalProgressIcon.SetTooltipText(GetSystemString(5200));
		ParticipationBtn.EnableWindow();
		Me.ShowWindow();
	}
	else if((nIsUseFestival == 2))
	{
		TimeNumberText.SetText(GetSecToTimeStr(FestivalEndTime));
		TimeNumberText.SetTooltipText(GetSystemString(5203));
		FestivalProgressIcon.SetTexture("L2UI_CT1.FestivalWnd_GrayDot");
		FestivalProgressIcon.SetTooltipText(GetSystemString(5201));
		ParticipationBtn.EnableWindow();
		GoldItemWindow.DisableWindow();
		Me.ShowWindow();
	}
	else
	{
		Me.KillTimer(1010122);
		Me.HideWindow();
		GetWindowHandle("FestivalWnd").HideWindow();
	}
	return;
}

function SetFestivalTopItemInfo(string param)
{
	local int ListCount, newFestivalID, Grade, ItemID, RemainItemNum, MAXITEMNUM, i;
	local ItemInfo Info;

	ParseInt(param, "IsUseFestival", nIsUseFestival);
	ParseInt(param, "ListCount", ListCount);
	ParseInt(param, "FestivalID", newFestivalID);
	ParseInt(param, "FestivalEndTime", FestivalEndTime);
	i = 0;
	ParseInt(param, ("Grade" $ string(i)), Grade);
	ParseInt(param, ("itemID" $ string(i)), ItemID);
	ParseInt(param, ("MaxItemNum" $ string(i)), MAXITEMNUM);
	ParseInt(param, ("RemainItemNum" $ string(i)), RemainItemNum);
	Info = GetItemInfoByClassID(ItemID);
	GoldText.SetText(makeShortStringByPixel(Info.Name, 157, ".."));
	GoldNumberText.SetText(((string(RemainItemNum) $ "/") $ string(MAXITEMNUM)));
	GoldItemWindow.Clear();
	GoldItemWindow.AddItem(Info);
	if((RemainItemNum > 0))
	{
		GoldItemWindow.EnableWindow();
	}
	else
	{
		GoldItemWindow.DisableWindow();
	}
	Me.KillTimer(1010122);
	Me.SetTimer(1010122, 1000);
	if(((nIsUseFestival == 1) && isFirstNoticeAnim))
	{
		NoticeAniPlay();
	}
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 1010122))
	{
		FestivalEndTime = (FestivalEndTime - 1);
		if((FestivalEndTime <= 0))
		{
			FestivalEndTime = 0;
			Me.KillTimer(1010122);
			ParticipationBtn.DisableWindow();
		}
		else
		{
			ParticipationBtn.EnableWindow();
		}
		TimeNumberText.SetText(GetSecToTimeStr(FestivalEndTime));
		FestivalWndScript.UpdateTime();
	}
	return;
}

function string GetSecToTimeStr(int Sec)
{
	local string returnStr;
	local int m_timeHour, m_timeMin;

	m_timeHour = ((Sec / 60) / 60);
	m_timeMin = int((float((Sec / 60)) % 60.0000000));
	returnStr = "";
	if((m_timeHour > 0))
	{
		if((m_timeHour < 10))
		{
			returnStr = ((returnStr $ "0") $ string(m_timeHour));
		}
		else
		{
			returnStr = (returnStr $ string(m_timeHour));
		}
	}
	else
	{
		returnStr = (returnStr $ "00");
	}
	if((m_timeMin > 0))
	{
		if((m_timeMin < 10))
		{
			returnStr = ((returnStr $ ":0") $ string(m_timeMin));
		}
		else
		{
			returnStr = ((returnStr $ ":") $ string(m_timeMin));
		}
	}
	else
	{
		returnStr = (returnStr $ ":00");
	}
	return returnStr;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "HelpButton":
			OnHelpButtonClick();
			break;
		case "ParticipationBtn":
			OnParticipationBtnClick();
			break;
		default:
			break;
	}
	return;
}

function OnHelpButtonClick()
{
	local string strParam;
	local HelpHtmlWnd Script;

	Script = HelpHtmlWnd(GetScript("HelpHtmlWnd"));
	ParamAdd(strParam, "FilePath", (GetLocalizedL2TextPathNameUC() $ "festival_help001.htm"));
	Script.HandleShowHelp(strParam);
	return;
}

function OnParticipationBtnClick()
{
	if((GetWindowHandle("FestivalWnd").IsShowWindow() == false))
	{
		RequestFestivalInfo(true);
	}
	toggleWindow("FestivalWnd", true, true);
	return;
}
