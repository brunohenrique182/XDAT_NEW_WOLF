class WorldOlympiadResultWnd extends UICommonAPI;

const TIMER_ID = 148;
const TIMER_DELAY = 20000;

enum winStateType
{
	IAM,                            // 0
	YOU,                            // 1
	NOT                             // 2
};

struct MemberDataStruct
{
	var string pcName;
	var int TeamColor;
	var int ClassName;
	var INT64 totalDamage;
	var int currentPoint;
	var int GetPoint;
};

struct ResultDataStruct
{
	var int set1Win;
	var int set2Win;
	var int set3Win;
	var int winnerItemCount;
	var int loserItemCount;
};

var string m_Windowname;
var WindowHandle Me;
var TextBoxHandle playerClass1Txt;
var TextBoxHandle playerClass2Txt;
var TextureHandle drawMC;
var TextureHandle player1WinMC;
var TextureHandle player1LoseMC;
var TextureHandle player2WinMC;
var TextureHandle player2LoseMC;
var winStateType winState;
var int m_PlayerNum;
var int m_teamColor;

function OnRegisterEvent()
{
	RegisterEvent(900);
	RegisterEvent(5082);
	return;
}

function OnLoad()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	SetClosingOnESC();
	return;
}

function OnEvent(int Event_ID, string a_Param)
{
	switch(Event_ID)
	{
		case 5082:
			HandleResultLists(a_Param);
			Debug(("EV_ReceiveOlympiadResultV2" @ a_Param));
			Me.ShowWindow();
		case 900:
			ParseInt(a_Param, "PlayerNum", m_PlayerNum);
			break;
			break;
		default:
			break;
	}
	return;
}

function OnShow()
{
	Me.SetTimer(148, 20000);
	Me.SetFocus();
	return;
}

function OnHide()
{
	Me.KillTimer(148);
	return;
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 148:
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string strID)
{
	Me.HideWindow();
	return;
}

function HandleResultLists(string a_Param)
{
	local MemberDataStruct winMemberData, loaeMemberData;
	local ResultDataStruct resultData;
	local string winnerName;

	ParseString(a_Param, "winnerName", winnerName);
	ParseInt(a_Param, "teamColor", m_teamColor);
	ParseInt(a_Param, "set1Win", resultData.set1Win);
	ParseInt(a_Param, "set2Win", resultData.set2Win);
	ParseInt(a_Param, "set3Win", resultData.set3Win);
	ParseInt(a_Param, "winnerItemCount", resultData.winnerItemCount);
	ParseInt(a_Param, "loserItemCount", resultData.loserItemCount);
	ParseString(a_Param, "winPcName0", winMemberData.pcName);
	ParseInt(a_Param, "winTeamColor0", winMemberData.TeamColor);
	ParseInt(a_Param, "winClassName0", winMemberData.ClassName);
	ParseINT64(a_Param, "winTotalDamage0", winMemberData.totalDamage);
	ParseInt(a_Param, "winCurrentPoint0", winMemberData.currentPoint);
	ParseInt(a_Param, "winGetPoint0", winMemberData.GetPoint);
	ParseString(a_Param, "losePcName0", loaeMemberData.pcName);
	ParseInt(a_Param, "loseTeamColor0", loaeMemberData.TeamColor);
	ParseInt(a_Param, "loseClassName0", loaeMemberData.ClassName);
	ParseINT64(a_Param, "loseTotalDamage0", loaeMemberData.totalDamage);
	ParseInt(a_Param, "loseCurrentPoint0", loaeMemberData.currentPoint);
	ParseInt(a_Param, "loseGetPoint0", loaeMemberData.GetPoint);
	if((m_PlayerNum != m_teamColor))
	{
		winState = IAM;
	}
	else if((winnerName == ""))
	{
		winState = NOT;
	}
	else
	{
		winState = YOU;
	}
	HandleResultImages();
	Debug(("winMemberData.PcName" @ winMemberData.pcName));
	if((m_PlayerNum != m_teamColor))
	{
		HandleResultPlayer(winMemberData, resultData, 1);
		HandleResultPlayer(loaeMemberData, resultData, 2);
		HandleResultRewardPoint(winMemberData);
		HandleResultRewardItem(resultData.winnerItemCount);
	}
	else
	{
		HandleResultPlayer(winMemberData, resultData, 2);
		HandleResultPlayer(loaeMemberData, resultData, 1);
		HandleResultRewardPoint(loaeMemberData);
		HandleResultRewardItem(resultData.loserItemCount);
	}
	return;
}

function HandleResultRewardPoint(MemberDataStruct memberData)
{
	local WindowHandle arrowDown, arrowUP;
	local TextBoxHandle currentPoint, upPoint;

	currentPoint = GetTextBoxHandle(((m_Windowname $ ".rewardPointMC") $ ".currentPointText"));
	upPoint = GetTextBoxHandle(((m_Windowname $ ".rewardPointMC") $ ".upPointText"));
	currentPoint.SetText(MakeCostString(string(memberData.currentPoint)));
	arrowDown = GetWindowHandle(((m_Windowname $ ".rewardPointMC") $ ".arrowDownMC"));
	arrowUP = GetWindowHandle(((m_Windowname $ ".rewardPointMC") $ ".arrowUpMC"));
	arrowUP.HideWindow();
	arrowDown.HideWindow();
	if((memberData.GetPoint > 0))
	{
		arrowUP.ShowWindow();
		upPoint.SetTextColor(GetColor(0, 255, 0, 255));
		upPoint.SetText(("+" $ MakeCostString(string(memberData.GetPoint))));
	}
	if((memberData.GetPoint < 0))
	{
		arrowDown.ShowWindow();
		upPoint.SetTextColor(GetColor(204, 0, 0, 255));
		upPoint.SetText(("-" $ MakeCostString(string((memberData.GetPoint * -1)))));
	}
	return;
}

function HandleResultRewardItem(int ItemCount)
{
	local ItemInfo Info;
	local ItemWindowHandle itemHandle;

	Info = GetItemInfoByClassID(45584);
	itemHandle = GetItemWindowHandle(((m_Windowname $ ".rewardItemMC") $ ".Reward_Item"));
	itemHandle.Clear();
	GetTextBoxHandle(((m_Windowname $ ".rewardItemMC") $ ".Reward_Itemname_Text")).SetText(Info.Name);
	GetTextBoxHandle(((m_Windowname $ ".rewardItemMC") $ ".Reward_Quantity_Text")).SetText(("x" $ string(ItemCount)));
	itemHandle.AddItem(Info);
	return;
}

function HandleResultImages()
{
	local TextureHandle drawMC, player1WinMC, player1LoseMC, player2WinMC, player2LoseMC;

	drawMC = GetTextureHandle((m_Windowname $ ".drawMC"));
	player1WinMC = GetTextureHandle((m_Windowname $ ".player1WinMC"));
	player1LoseMC = GetTextureHandle((m_Windowname $ ".player1LoseMC"));
	player2WinMC = GetTextureHandle((m_Windowname $ ".player2WinMC"));
	player2LoseMC = GetTextureHandle((m_Windowname $ ".player2LoseMC"));
	drawMC.HideWindow();
	player1WinMC.HideWindow();
	player1LoseMC.HideWindow();
	player2WinMC.HideWindow();
	player2LoseMC.HideWindow();
	switch(winState)
	{
		case IAM:
			player1WinMC.ShowWindow();
			player2LoseMC.ShowWindow();
			break;
		case YOU:
			player2WinMC.ShowWindow();
			player1LoseMC.ShowWindow();
			break;
		case NOT:
			drawMC.ShowWindow();
			break;
		default:
			break;
	}
	return;
}

function HandleResultPlayer(MemberDataStruct memberData, ResultDataStruct resultData, int memberNum)
{
	local TextBoxHandle txtName;

	txtName = GetTextBoxHandle((((m_Windowname $ ".playerName") $ string(memberNum)) $ "Txt"));
	txtName.SetText(memberData.pcName);
	txtName.SetTextColor(GetOlympiadTeamColor(memberData.TeamColor));
	GetTextBoxHandle((((m_Windowname $ ".playerClass") $ string(memberNum)) $ "Txt")).SetText(GetClassType(memberData.ClassName));
	if((memberData.TeamColor == (resultData.set1Win - 1)))
	{
		GetTextureHandle(((((m_Windowname $ ".player") $ string(memberNum)) $ "ScoreMC") $ ".win1SymbolMC")).ShowWindow();
	}
	else
	{
		GetTextureHandle(((((m_Windowname $ ".player") $ string(memberNum)) $ "ScoreMC") $ ".win1SymbolMC")).HideWindow();
	}
	if((memberData.TeamColor == (resultData.set2Win - 1)))
	{
		GetTextureHandle(((((m_Windowname $ ".player") $ string(memberNum)) $ "ScoreMC") $ ".win2SymbolMC")).ShowWindow();
	}
	else
	{
		GetTextureHandle(((((m_Windowname $ ".player") $ string(memberNum)) $ "ScoreMC") $ ".win2SymbolMC")).HideWindow();
	}
	if((memberData.TeamColor == (resultData.set3Win - 1)))
	{
		GetTextureHandle(((((m_Windowname $ ".player") $ string(memberNum)) $ "ScoreMC") $ ".win3SymbolMC")).ShowWindow();
	}
	else
	{
		GetTextureHandle(((((m_Windowname $ ".player") $ string(memberNum)) $ "ScoreMC") $ ".win3SymbolMC")).HideWindow();
	}
	GetTextBoxHandle(((((m_Windowname $ ".player") $ string(memberNum)) $ "ScoreMC") $ ".damageText")).SetText(MakeCostStringINT64(memberData.totalDamage));
	return;
}

function Color GetOlympiadTeamColor(int TeamColor)
{
	switch(TeamColor)
	{
		case 2:
			return GetColor(102, 170, 238, 255);
			break;
		case 1:
			return GetColor(238, 119, 119, 255);
			break;
		default:
			break;
	}
	return GetColor(220, 220, 220, 255);
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}
