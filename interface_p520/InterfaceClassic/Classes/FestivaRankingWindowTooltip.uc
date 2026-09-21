class FestivaRankingWindowTooltip extends UICommonAPI;

var WindowHandle Me;
var string m_Windowname;
var FestivalRankingWnd festivalRankingWndScript;
var TextureHandle GiftBox_Tex;

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	festivalRankingWndScript = FestivalRankingWnd(GetScript("festivalRankingWnd"));
	GiftBox_Tex = GetTextureHandle((m_Windowname $ ".FestivalInner_Wnd.GiftBox_Tex"));
	GiftBox_Tex.HideWindow();
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

event OnShow()
{
	SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(self)), true);
	festivalRankingWndScript.C_EX_RANKING_FESTIVAL_MY_RECEIVED_BONUS();
	return;
}

event OnHide()
{
	SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(self)), false);
	return;
}

event OnClickButton(string Name)
{
	local WindowHandle m_FestivalRankingWnd;

	m_FestivalRankingWnd = GetWindowHandle("FestivalRankingWnd");
	switch(Name)
	{
		case "Join_Btn":
			if(m_FestivalRankingWnd.IsShowWindow())
			{
				m_FestivalRankingWnd.HideWindow();
			}
			else
			{
				m_FestivalRankingWnd.ShowWindow();
				m_FestivalRankingWnd.SetFocus();
			}
			break;
		default:
			break;
	}
	return;
}

function SetTimeText(string timeString)
{
	GetTextBoxHandle((m_Windowname $ ".FestivalInner_Wnd.TimeNumber_Txt")).SetText(timeString);
	return;
}

function SetTimerState(string timerTextureName)
{
	GetTextureHandle((m_Windowname $ ".FestivalInner_Wnd.FestivalProgressIcon_Tex")).SetTexture(timerTextureName);
	return;
}

function SetRankingRewardInfoBig(int RankingGroup, string UserName, INT64 Amount, ItemInfo iInfo)
{
	local ItemWindowHandle rewardItemWindow;
	local string rankingBoxPath;

	rankingBoxPath = GetRankingRewardBoxPathByRankingGroup(RankingGroup);
	rewardItemWindow = GetItemWindowHandle((rankingBoxPath $ ".Item_ItemWnd"));
	rewardItemWindow.Clear();
	rewardItemWindow.AddItem(iInfo);
	GetTextBoxHandle((rankingBoxPath $ ".ItemName_Txt")).SetText(UserName);
	GetTextBoxHandle((rankingBoxPath $ ".ItemNumber_Txt")).SetText(MakeCostString(string(Amount)));
	return;
}

function SetGiftBox(bool bShow)
{
	if(bShow)
	{
		GiftBox_Tex.ShowWindow();
	}
	else
	{
		GiftBox_Tex.HideWindow();
	}
	return;
}

function string GetRankingRewardBoxPathByRankingGroup(int RankingGroup)
{
	return ((m_Windowname $ ".FestivalInner_Wnd.itemGroup_Wnd0") $ string((RankingGroup - 1)));
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
	return;
}
