class HomunculusWndEnchantCommunionChartItem extends UICommonAPI;

enum type_State
{
	Lock,                           // 0
	Normal,                         // 1
	Selected                        // 2
};

var WindowHandle Me;
var string m_Windowname;
var int Index;
var ButtonHandle MainBtnChart;
var StatusRoundHandle MainStatus;
var TextureHandle texDisable;
var TextBoxHandle text0;
var int skillIDClssID;
var int SkillLevel;
var int currEnchantLv;
var L2Util util;
var HomunculusWndEnchantCommunionChart homunculusWndEnchantCommunionChartScript;
var type_State currState;

function Initialize()
{
	util = L2Util(GetScript("L2Util"));
	MainStatus = GetStatusRoundHandle((m_Windowname $ ".MainStatus"));
	MainBtnChart = GetButtonHandle((m_Windowname $ ".MainBtnChart"));
	texDisable = GetTextureHandle((m_Windowname $ ".texDisable"));
	text0 = GetTextBoxHandle((m_Windowname $ ".text0"));
	text0.SetText(string((Index + 1)));
	homunculusWndEnchantCommunionChartScript = HomunculusWndEnchantCommunionChart(GetScript("HomunculusWnd.HomunculusWndEnchantCommunionChart"));
	return;
}

function Init(string WindowName)
{
	m_Windowname = WindowName;
	Me = GetWindowHandle(m_Windowname);
	Index = int(Right(m_Windowname, 1));
	Initialize();
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "MainBtnChart":
			homunculusWndEnchantCommunionChartScript.HandleChartItemClicked(Index);
			break;
		default:
			break;
	}
	return;
}

function SetSkill(int ClassID, int currSkillLevel, int currEnchantLv)
{
	local bool isActivated;

	isActivated = (currEnchantLv > 0);
	skillIDClssID = ClassID;
	SkillLevel = currSkillLevel;
	currEnchantLv = currEnchantLv;
	if(isActivated)
	{
		MainStatus.SetPoint(INT64(currEnchantLv), INT64(3));
	}
	else
	{
		MainStatus.SetPoint(INT64(0), INT64(3));
	}
	SetTooltip(isActivated);
	return;
}

function SetTooltip(bool isActivated)
{
	local ItemID Id;
	local array<string> descs;
	local string Desc;
	local CustomTooltip t;

	util.setCustomTooltip(t);
	util.ToopTipMinWidth(10);
	Id.ClassID = skillIDClssID;
	if(isActivated)
	{
		Desc = Class'NWindow.UIDATA_SKILL'.static.GetDescription(Id, SkillLevel, 0);
		Debug(((("SetTooltip" @ Desc) @ string(skillIDClssID)) @ string(SkillLevel)));
		Split(Desc, "^", descs);
		util.ToopTipInsertText(((descs[0] $ ":") @ descs[1]), true, true);
		MainBtnChart.SetTooltipCustomType(util.getCustomToolTip());
	}
	else
	{
		Desc = Class'NWindow.UIDATA_SKILL'.static.GetDescription(Id, SkillLevel, 0);
		Split(Desc, "^", descs);
		if((int(currState) == 0))
		{
			util.ToopTipInsertColorText((((descs[0] $ ":") @ GetSystemString(3809)) $ descs[1]), true, true, util.Gray);
			texDisable.SetTooltipCustomType(util.getCustomToolTip());
		}
		else
		{
			util.ToopTipInsertColorText((((descs[0] $ ":") @ GetSystemString(3809)) $ descs[1]), true, true);
			MainBtnChart.SetTooltipCustomType(util.getCustomToolTip());
		}
	}
	return;
}

function ClearAll()
{
	texDisable.SetTooltipCustomType(MakeTooltipSimpleText(""));
	return;
}

function SetState(type_State toState)
{
	currState = toState;
	switch(currState)
	{
		case Lock:
			MainBtnChart.HideWindow();
			texDisable.ShowWindow();
			text0.SetTextColor(getInstanceL2Util().Gray);
			break;
		case Normal:
			MainBtnChart.ShowWindow();
			MainBtnChart.EnableWindow();
			texDisable.HideWindow();
			text0.SetTextColor(GetColor(170, 153, 119, 255));
			break;
		case Selected:
			MainBtnChart.ShowWindow();
			MainBtnChart.DisableWindow();
			texDisable.HideWindow();
			text0.SetTextColor(GetColor(170, 153, 119, 255));
			break;
		default:
			break;
	}
	return;
}
