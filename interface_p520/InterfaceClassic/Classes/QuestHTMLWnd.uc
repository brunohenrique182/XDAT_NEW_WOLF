class QuestHTMLWnd extends UICommonAPI;

const HTML_WIDTH = 400;
const TABLEBG_WIDTH = 272;

var WindowHandle Me;
var HtmlHandle m_hHtmlViewer;
var bool m_bDrawBg;
var bool m_bPressCloseButton;
var bool m_bReShowWndMode;
var bool m_bReShowQuestHtmlWnd;
var string HtmlString;
var int htmlWidth;
var int bicIconLen;

function OnRegisterEvent()
{
	RegisterEvent(3323);
	RegisterEvent(3324);
	RegisterEvent(3322);
	RegisterEvent(3321);
	RegisterEvent(150);
	RegisterEvent(160);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	OnRegisterEvent();
	Me = GetWindowHandle("QuestHTMLWnd");
	m_hHtmlViewer = GetHtmlHandle("QuestHTMLWnd.HtmlViewer");
	return;
}

function OnShow()
{
	getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "QuestHTMLWnd,NPCDialogWnd");
	return;
}

function OnHide()
{
	ProcCloseQuestHTMLWnd();
	getInstanceL2Util().syncWindowLocAuto("QuestHTMLWnd,NPCDialogWnd");
	return;
}

function OnDefaultPosition()
{
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 3323:
			ShowQuestHTMLWnd();
			break;
		case 3324:
			HideQuestHTMLWnd();
			break;
		case 3322:
			setWindowTitleByString(GetSystemString(444));
			HandleLoadHtmlFromString(param);
			break;
		case 3321:
			HandleQuestIDLoadHtmlFromString(param);
			break;
		case 19:
			m_hHtmlViewer.LoadHtmlFromString(param);
			break;
		default:
			break;
	}
	return;
}

function int getLanguageNumber()
{
	local UIEventManager.ELanguageType Language;
	local int languageNum;

	Language = GetLanguage();
	switch(Language)
	{
		case LANG_Korean:
			languageNum = 0;
			break;
		case LANG_English:
			languageNum = 1;
			break;
		case LANG_Japanese:
			languageNum = 2;
			break;
		case LANG_Taiwan:
			languageNum = 3;
			break;
		case LANG_Chinese:
			languageNum = 4;
			break;
		case LANG_Thai:
			languageNum = 5;
			break;
		case LANG_Philippine:
			languageNum = 6;
			break;
		case LANG_Indonesia:
			languageNum = 7;
			break;
		case LANG_Russia:
			languageNum = 8;
			break;
		case LANG_Euro:
			languageNum = 9;
			break;
		case LANG_Germany:
			languageNum = 10;
			break;
		case LANG_France:
			languageNum = 11;
			break;
		case LANG_Poland:
			languageNum = 12;
			break;
		case LANG_Turkey:
			languageNum = 13;
			break;
		default:
			languageNum = 0;
			break;
	}
	return languageNum;
}

function HandleQuestIDLoadHtmlFromString(string param)
{
	local int QuestID;
	local array<int> RewardIDList;
	local array<INT64> rewardNumList;
	local int i;
	local string addItemHtml, IconName, itemText, ItemName, rewardSmallIconHtml, rewardMsgHtml, rewardEndMsgHtml;
	local int tableIndex, smallIconIndex;

	ParseInt(param, "QuestID", QuestID);
	Class'NWindow.UIDATA_QUEST'.static.GetQuestReward(QuestID, 1, RewardIDList, rewardNumList);
	tableIndex = 0;
	smallIconIndex = 0;
	bicIconLen = 0;
	rewardSmallIconHtml = "<table width=278 border=0 cellpadding=0 cellspacing=1 background=L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Center>";
	i = 0;
	while((i < RewardIDList.Length))
	{
		if(((((RewardIDList[i] != 57) && (RewardIDList[i] != 15623)) && (RewardIDList[i] != 15624)) && (RewardIDList[i] != 47130)))
		{
			bicIconLen++;
		}
		i++;
	}
	if((bicIconLen == 1))
	{
		rewardMsgHtml = "<table width=278 border=0 cellpadding=0 cellspacing=1 background=L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Center>";
	}
	else
	{
		rewardMsgHtml = "<table width=278 border=0 cellpadding=0 cellspacing=1 background=L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Center>";
	}
	if((RewardIDList.Length > 0))
	{
		i = 0;
		while((i < RewardIDList.Length))
		{
			if((i == 0))
			{
				addItemHtml = ((((("<br>" $ htmlTableAdd("L2UI_CT1.GroupBox.GroupBox_DF")) $ "<font color=\"ffcc00\" name=GameDefault>") $ GetSystemString(2006)) $ "</font>") $ "</td></tr></table>");
			}
			Debug(("rewardIDList[i]" @ string(RewardIDList[i])));
			switch(RewardIDList[i])
			{
				case 57:
				case 15623:
				case 15624:
				case 47130:
				case 95641:
					ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(RewardIDList[i]));
					if((RewardIDList[i] == 57))
					{
						IconName = "L2UI_CT1.HtmlWnd.HTMLWnd_adena";
						ItemName = GetSystemString(469);
					}
					else if((RewardIDList[i] == 15623))
					{
						if((getLanguageNumber() == 1))
						{
						}
						IconName = "L2UI_CT1.HtmlWnd.HTMLWnd_EXP";
					}
					else if((RewardIDList[i] == 15624))
					{
						IconName = "L2UI_CT1.HtmlWnd.HTMLWnd_SP";
					}
					else if((RewardIDList[i] == 47130))
					{
						IconName = "L2UI_CT1.HtmlWnd.HTMLWnd_FP";
					}
					else if((RewardIDList[i] == 95641))
					{
						IconName = "L2UI_CT1.HtmlWnd.htmlwnd_lv_point";
					}
					if((rewardNumList[i] == INT64(0)))
					{
						itemText = GetSystemString(584);
					}
					else if((RewardIDList[i] == 15624))
					{
						itemText = MakeCostString(string(rewardNumList[i]));
					}
					else
					{
						itemText = MakeCostString(string(rewardNumList[i]));
					}
					rewardSmallIconHtml = (((((((((rewardSmallIconHtml $ "<tr><td width=38 height=22 align=center valign=center><Img width=32 height=16") $ " src=\"") $ IconName) $ "\"") $ "></td><td height=22 width=236><font color=ba8860>") $ itemText) $ "</font>") @ htmlfontAdd(ItemName)) $ "</td></tr>");
					smallIconIndex = (smallIconIndex + 1);
					break;
				default:
					IconName = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(RewardIDList[i]));
					ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(RewardIDList[i]));
					if((rewardNumList[i] == INT64(0)))
					{
						itemText = htmlfontAdd(GetSystemString(584), "ba8860");
					}
					else if((((((((((((RewardIDList[i] == 15623) || (RewardIDList[i] == 15624)) || (RewardIDList[i] == 15625)) || (RewardIDList[i] == 15626)) || (RewardIDList[i] == 15627)) || (RewardIDList[i] == 15628)) || (RewardIDList[i] == 15629)) || (RewardIDList[i] == 15630)) || (RewardIDList[i] == 15631)) || (RewardIDList[i] == 15632)) || (RewardIDList[i] == 15633)))
					{
						itemText = htmlfontAdd(MakeCostString(string(rewardNumList[i])), "ba8860");
					}
					else
					{
						itemText = MakeFullSystemMsg(htmlfontAdd(GetSystemMessage(1983)), htmlfontAdd(MakeCostString(string(rewardNumList[i])), "ba8860"), "");
					}
					if((getLanguageNumber() == 0))
					{
						if((bicIconLen == 1))
						{
							rewardMsgHtml = ((((((((((((((((((rewardMsgHtml $ "<tr>") $ "<td width=2 height=32></td><td align=center valign=center width=32 height=32><button width=32 height=32") $ " itemtooltip=\"") $ string(RewardIDList[i])) $ "\"") $ " back=\"") $ IconName) $ "\"") $ " high=\"") $ IconName) $ "\"") $ " fore=\"") $ IconName) $ "\"></button></td><td width=1 height=32></td><td width=234 height=32>") $ htmlfontAdd(ItemName)) $ "<br1>") $ itemText) $ "</td></tr>");
						}
						else
						{
							if(((RewardIDList.Length > 0) && (Len(ItemName) > 8)))
							{
								ItemName = (Mid(ItemName, 0, 8) $ "..");
							}
							if(((float(tableIndex) % 2.0000000) > 0.0000000))
							{
								rewardMsgHtml = Mid(rewardMsgHtml, 0, (Len(rewardMsgHtml) - 5));
								rewardMsgHtml = ((((((((((((((((((rewardMsgHtml $ "<td align=center valign=center width=32 height=32><button width=32 height=32") $ " itemtooltip=\"") $ string(RewardIDList[i])) $ "\"") $ " back=\"") $ IconName) $ "\"") $ " high=\"") $ IconName) $ "\"") $ " fore=\"") $ IconName) $ "\"></td><td width=110 height=32></button>") $ htmlfontAdd(ItemName)) $ "<br1>") $ itemText) $ "<br1>") $ "</td></tr>");
							}
							else
							{
								rewardMsgHtml = ((((((((((((((((((rewardMsgHtml $ htmlTableTrAdd()) $ "<tr><td align=center valign=center width=32 height=32><button width=32 height=32") $ " itemtooltip=\"") $ string(RewardIDList[i])) $ "\"") $ " back=\"") $ IconName) $ "\"") $ " high=\"") $ IconName) $ "\"") $ " fore=\"") $ IconName) $ "\"></button></td><td width=110 height=32>") $ htmlfontAdd(ItemName)) $ "<br1>") $ itemText) $ "</td></tr>");
							}
						}
					}
					else
					{
						ItemName = makeShortStringByPixel(ItemName, 230, "..");
						rewardMsgHtml = ((((((((((((((((((rewardMsgHtml $ "<tr>") $ "<td width=2 height=32></td><td align=center valign=center width=32 height=32><button width=32 height=32") $ " itemtooltip=\"") $ string(RewardIDList[i])) $ "\"") $ " back=\"") $ IconName) $ "\"") $ " high=\"") $ IconName) $ "\"") $ " fore=\"") $ IconName) $ "\"></button></td><td width=1 height=32></td><td width=234 height=32>") $ htmlfontAdd(ItemName)) $ "<br1>") $ itemText) $ "</td></tr>");
					}
					tableIndex = (tableIndex + 1);
			}
			i++;
		}
		if((tableIndex > 0))
		{
			rewardMsgHtml = (rewardMsgHtml $ "</table>");
		}
		else
		{
			rewardMsgHtml = "";
		}
		if((smallIconIndex > 0))
		{
			rewardSmallIconHtml = (rewardSmallIconHtml $ "</table>");
		}
		else
		{
			rewardSmallIconHtml = "";
		}
		HtmlString = Mid(HtmlString, 6, Len(HtmlString));
		HtmlString = Mid(HtmlString, 0, (Len(HtmlString) - 7));
		if((bicIconLen == 1))
		{
			rewardEndMsgHtml = "<table width=277 border=0 cellpadding=0 cellspacing=1 background=L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Down><tr><td width=277></td></tr></table>";
		}
		else
		{
			rewardEndMsgHtml = "<table width=277 border=0 cellpadding=0 cellspacing=1 background=L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Down><tr><td width=277></td></tr></table>";
		}
		addItemHtml = ((((HtmlString $ addItemHtml) $ rewardSmallIconHtml) $ rewardMsgHtml) $ rewardEndMsgHtml);
		addItemHtml = (("<html><body>" $ addItemHtml) $ "</body></html>");
		m_hHtmlViewer.LoadHtmlFromString(addItemHtml);
	}
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function string htmlTableAdd(optional string backgroundUrl)
{
	local string htmlStr;

	if((backgroundUrl == ""))
	{
		htmlStr = ("<table width=278 cellpadding=0 border=0 cellspacing=1" $ "><tr><td width=278>");
	}
	else
	{
		htmlStr = (("<table width=278 cellpadding=0 border=0 cellspacing=1 background=" $ backgroundUrl) $ "><tr><td width=272>");
	}
	return htmlStr;
}

function string htmlTableTrAdd()
{
	return "<tr><td width=46 ></td><td width=115 ></td><td width=46 ></td><td width=115 ></td></tr>";
}

function string htmlfontAdd(string strText, optional string FontColor)
{
	local string targetHtml;

	if((FontColor == ""))
	{
		FontColor = "d3c5ae";
	}
	targetHtml = ((((("<font color=\"" $ FontColor) $ "\"") $ ">") $ strText) $ "</font>");
	return targetHtml;
}

function OnHtmlMsgHideWindow(HtmlHandle a_HtmlHandle)
{
	if((a_HtmlHandle == m_hHtmlViewer))
	{
		HideQuestHTMLWnd();
	}
	return;
}

function HandleLoadHtmlFromString(string param)
{
	ParseString(param, "HTMLString", HtmlString);
	m_hHtmlViewer.LoadHtmlFromString(HtmlString);
	return;
}

function ShowQuestHTMLWnd()
{
	ExecuteEvent(3280);
	Me.ShowWindow();
	Me.SetFocus();
	m_bReShowQuestHtmlWnd = true;
	return;
}

function HideQuestHTMLWnd()
{
	Me.HideWindow();
	m_bReShowQuestHtmlWnd = false;
	return;
}

function OnClickButton(string Name)
{
	PressCloseButton();
	return;
}

function OnExitState(name a_CurrentStateName)
{
	if((a_CurrentStateName == 'NpcZoomCameraState'))
	{
		ReShowQuestHTMLWnd();
		Clear();
	}
	return;
}

function OnEnterState(name a_CurrentStateName)
{
	if((a_CurrentStateName == 'NpcZoomCameraState'))
	{
		Clear();
		m_bReShowWndMode = true;
	}
	return;
}

function Clear()
{
	m_bReShowWndMode = false;
	m_bPressCloseButton = false;
	m_bReShowQuestHtmlWnd = false;
	return;
}

function PressCloseButton()
{
	if(m_bReShowWndMode)
	{
		m_bPressCloseButton = true;
	}
	return;
}

function ProcCloseQuestHTMLWnd()
{
	if(((m_bPressCloseButton && m_bReShowWndMode) && m_bReShowQuestHtmlWnd))
	{
		m_bReShowWndMode = false;
		RequestFinishNPCZoomCamera();
	}
	return;
}

function ReShowQuestHTMLWnd()
{
	if((m_bReShowWndMode && m_bReShowQuestHtmlWnd))
	{
		ShowQuestHTMLWnd();
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	PressCloseButton();
	GetWindowHandle("QuestHTMLWnd").HideWindow();
	return;
}
