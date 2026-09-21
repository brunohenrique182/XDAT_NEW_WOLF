class HomunculusWndEnchantCommunionDice extends UICommonAPI
	dependson(UIPacket);

const DICEMAX = 3;
const TIME_DICE = 500;
const TIMEID_DICE = 1;

var WindowHandle Me;
var string m_Windowname;
var TextBoxHandle textResult;
var TextBoxHandle text0;
var TextBoxHandle textDesc;
var StatusRoundHandle MainStatus;
var HomunculusWnd HomunculusWndScript;
var HomunculusWndEnchantCommunionInfo homunculusWndEnchantCommunionInfoScript;
var L2UITween l2UITweenScript;
var array<HomunculusWndEnchantCommunionDiceItem> diceScripts;
var int MDice;
var int HDice;
var int SDice;
var int diceNum;
var int completedDiceNum;
var int resultEnchant;
var ButtonHandle btnContinue;
var ButtonHandle btnConfirm;
var WindowHandle resultWnd;

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	resultWnd = GetWindowHandle((m_Windowname $ ".resultWnd"));
	text0 = GetTextBoxHandle((m_Windowname $ ".resultWnd.text0"));
	MainStatus = GetStatusRoundHandle((m_Windowname $ ".resultWnd.MainStatus"));
	textResult = GetTextBoxHandle((m_Windowname $ ".resultWnd.textResult"));
	textDesc = GetTextBoxHandle((m_Windowname $ ".resultWnd.textDesc"));
	btnContinue = GetButtonHandle((m_Windowname $ ".btnContinue"));
	btnConfirm = GetButtonHandle((m_Windowname $ ".btnConfirm"));
	HomunculusWndScript = HomunculusWnd(GetScript("HomunculusWnd"));
	homunculusWndEnchantCommunionInfoScript = HomunculusWndEnchantCommunionInfo(GetScript("HomunculusWnd.HomunculusWndEnchantCommunionInfo"));
	l2UITweenScript = L2UITween(GetScript("L2UITween"));
	InitHandleDiceItems();
	return;
}

function InitHandleDiceItems()
{
	local int i;

	i = 0;
	while((i < 3))
	{
		GetWindowHandle(((m_Windowname $ ".Dice") $ string(i))).SetScript("HomunculusWndEnchantCommunionDiceItem");
		diceScripts[i] = HomunculusWndEnchantCommunionDiceItem(GetWindowHandle(((m_Windowname $ ".Dice") $ string(i))).GetScript());
		diceScripts[i].Init(((m_Windowname $ ".Dice") $ string(i)));
		i++;
	}
	return;
}

function OnRegisterEvent()
{
	RegisterEvent((100000 + 864));
	RegisterEvent((100000 + 865));
	return;
}

function OnLoad()
{
	Initialize();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case (100000 + 864):
			Handle_S_EX_RESET_HOMUNCULUS_SKILL_RESULT();
			break;
		case (100000 + 865):
			Handle_S_EX_ENCHANT_HOMUNCULUS_SKILL_RESULT();
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "btnConfirm":
			HomunculusWndScript.SetState(Communion);
			HomunculusWndScript.API_C_EX_SHOW_HOMUNCULUS_INFO(1);
			break;
		case "btnContinue":
			HomunculusWndScript.API_C_EX_ENCHANT_HOMUNCULUS_SKILL(1, GetCurrHomunculusData().idx, (GetCurrIndex() + 1));
			break;
		default:
			break;
	}
	return;
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 1:
			diceScripts[diceNum].Dice();
			diceNum++;
			if((diceNum == 3))
			{
				Me.KillTimer(TimerID);
			}
			break;
		default:
			break;
	}
	return;
}

function Show()
{
	resultEnchant = GetCurrHomunculusData().SkillLevel[(GetCurrIndex() + 1)];
	SetInfo();
	Me.ShowWindow();
	Me.SetFocus();
	HomunculusWndScript.API_C_EX_ENCHANT_HOMUNCULUS_SKILL(1, GetCurrHomunculusData().idx, (GetCurrIndex() + 1));
	text0.SetText(string((GetCurrIndex() + 1)));
	return;
}

function Hide()
{
	Me.HideWindow();
	return;
}

function bool CheckBtnContinue()
{
	if((homunculusWndEnchantCommunionInfoScript.currentEnchantPoint < homunculusWndEnchantCommunionInfoScript.currHomunEnchantData.CommunionNeedEnchantPoint))
	{
		return false;
	}
	if((homunculusWndEnchantCommunionInfoScript.mySP < INT64(homunculusWndEnchantCommunionInfoScript.currHomunEnchantData.CommunionNeedSpPoint)))
	{
		return false;
	}
	if((resultEnchant >= 3))
	{
		return false;
	}
	return true;
}

function Dice()
{
	local int i;

	diceNum = 0;
	completedDiceNum = 0;
	btnConfirm.DisableWindow();
	btnContinue.DisableWindow();
	diceScripts[0].Clear();
	diceScripts[0].SetTargetNum(SDice);
	diceScripts[1].Clear();
	diceScripts[1].SetTargetNum(HDice);
	diceScripts[2].Clear();
	diceScripts[2].SetTargetNum(MDice);
	i = 1;
	while((i < 3))
	{
		if((SDice == diceScripts[i].diceTarget0))
		{
			diceScripts[0].isDiceSame = true;
			diceScripts[i].isDiceSame = true;
		}
		i++;
	}
	diceScripts[diceNum].Dice();
	diceNum++;
	Me.SetTimer(1, 500);
	resultWnd.HideWindow();
	return;
}

function SetResultEnchant()
{
	resultWnd.ShowWindow();
	AddSystemMessageString(MakeFullSystemMsg(GetSystemMessage(13219), string(resultEnchant)));
	return;
}

function ClearAll()
{
	local int i;

	i = 0;
	while((i < 3))
	{
		diceScripts[i].Clear();
		i++;
	}
	return;
}

function Handle_S_EX_RESET_HOMUNCULUS_SKILL_RESULT()
{
	local UIPacket._S_EX_RESET_HOMUNCULUS_SKILL_RESULT packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_RESET_HOMUNCULUS_SKILL_RESULT(packet))
	{
		return;
	}
	if((packet.Type == 1))
	{
		ClearAll();
	}
	return;
}

function Handle_S_EX_ENCHANT_HOMUNCULUS_SKILL_RESULT()
{
	local UIPacket._S_EX_ENCHANT_HOMUNCULUS_SKILL_RESULT packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_ENCHANT_HOMUNCULUS_SKILL_RESULT(packet))
	{
		return;
	}
	if((packet.Type == 0))
	{
		AddSystemMessage(packet.nID);
		return;
	}
	else
	{
		ClearAll();
		resultEnchant = packet.Type;
	}
	MDice = packet.MDice;
	HDice = packet.HDice;
	SDice = packet.SDice;
	HomunculusWndScript.API_C_EX_SHOW_HOMUNCULUS_INFO(2);
	Dice();
	return;
}

function CompletedDice()
{
	completedDiceNum++;
	if((completedDiceNum == 3))
	{
		diceScripts[0].ShowSame();
		diceScripts[1].ShowSame();
		diceScripts[2].ShowSame();
		if(CheckBtnContinue())
		{
			btnContinue.EnableWindow();
		}
		btnConfirm.EnableWindow();
		SetResultEnchant();
		SetInfo();
	}
	return;
}

function SetInfo()
{
	MainStatus.SetPoint(INT64(resultEnchant), INT64(3));
	textDesc.SetText(GetSkillName());
	textResult.SetText(MakeFullSystemMsg(GetSystemMessage(13219), string(resultEnchant)));
	return;
}

function HomunculusAPI.HomunculusData GetCurrHomunculusData()
{
	return HomunculusWndMainList(GetScript("HomunculusWnd.HomunculusWndMainList")).GetCurrHomunculusData();
}

function int GetCurrIndex()
{
	return HomunculusWndEnchantCommunionChart(GetScript("HomunculusWnd.HomunculusWndEnchantCommunionChart")).currentSelectedIndex;
}

function string GetSkillName()
{
	local array<string> descs;
	local string Desc;
	local ItemID Id;
	local int Index;

	Index = (GetCurrIndex() + 1);
	Id.ClassID = GetCurrHomunculusData().SkillID[Index];
	Desc = Class'NWindow.UIDATA_SKILL'.static.GetDescription(Id, resultEnchant, 0);
	Debug(((("GetSkillName" @ string(Id.ClassID)) @ Desc) @ string((GetCurrIndex() + 1))));
	if((Desc == ""))
	{
		return "";
	}
	Split(Desc, "^", descs);
	return (descs[0] @ descs[1]);
}
