class FestivalWRankingWindowTooltip extends UICommonAPI;

var WindowHandle Me;
var string m_Windowname;
var FestivalWRankingWnd festivalWRankingWndScript;
var TextureHandle GiftBox_Tex;

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	festivalWRankingWndScript = FestivalWRankingWnd(GetScript("festivalWRankingWnd"));
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
	if(IsPlayerOnWorldRaidServer())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
		Me.HideWindow();
	}
	else
	{
		SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(self)), true);
		festivalWRankingWndScript.Rq_C_EX_WRANKING_FESTIVAL_MY_RECEIVED_BONUS();
	}
	return;
}

event OnHide()
{
	SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(self)), false);
	return;
}

event OnClickButton(string Name)
{
	local WindowHandle m_FestivalWRankingWnd;

	m_FestivalWRankingWnd = GetWindowHandle("FestivalWRankingWnd");
	switch(Name)
	{
		case "Join_Btn":
			if(m_FestivalWRankingWnd.IsShowWindow())
			{
				m_FestivalWRankingWnd.HideWindow();
			}
			else
			{
				m_FestivalWRankingWnd.ShowWindow();
				m_FestivalWRankingWnd.SetFocus();
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
	local string rankingBoxPath, tooltipUserName;
	local TextBoxHandle nameTextBox;
	local L2Util util;

	util = L2Util(GetScript("L2Util"));
	rankingBoxPath = GetRankingRewardBoxPathByRankingGroup(RankingGroup);
	rewardItemWindow = GetItemWindowHandle((rankingBoxPath $ ".Item_ItemWnd"));
	iInfo.bDisabled = 0;
	if(!rewardItemWindow.SetItem(0, iInfo))
	{
		rewardItemWindow.AddItem(iInfo);
	}
	tooltipUserName = UserName;
	nameTextBox = GetTextBoxHandle((rankingBoxPath $ ".ItemName_Txt"));
	nameTextBox.SetTooltipType("Text");
	nameTextBox.SetTooltipString(tooltipUserName);
	util.GetEllipsisString(UserName, 150);
	nameTextBox.SetText(UserName);
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
