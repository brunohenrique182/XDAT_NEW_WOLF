class HomunculusWndEnchantCommunionChart extends UICommonAPI;

const CHARTITEMMAX = 5;
const LevelMax = 3;
const EFFECT_MONSTER_ID = 19671;

var WindowHandle Me;
var string m_Windowname;
var L2Util util;
var array<HomunculusWndEnchantCommunionChartItem> chartItems;
var HomunculusWnd HomunculusWndScript;
var HomunculusWndEnchantCommunionInfo homunculusWndEnchantCommunionInfoScript;
var CharacterViewportWindowHandle EffectViewportChart;
var int currentSelectedIndex;
var bool Spawned;

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	util = L2Util(GetScript("L2Util"));
	EffectViewportChart = GetCharacterViewportWindowHandle((m_Windowname $ ".EffectViewportChart"));
	HomunculusWndScript = HomunculusWnd(GetScript("HomunculusWnd"));
	homunculusWndEnchantCommunionInfoScript = HomunculusWndEnchantCommunionInfo(GetScript("HomunculusWnd.HomunculusWndEnchantCommunionInfo"));
	InitHandleChartItems();
	EffectViewportChart.SetNPCInfo(19671);
	return;
}

function OnLoad()
{
	Initialize();
	return;
}

function HandleChartItemClicked(int Index)
{
	switch(chartItems[Index].currState)
	{
		case Normal:
			SetSelect(Index);
			break;
		default:
			break;
	}
	return;
}

function SetSelect(int Index)
{
	if((currentSelectedIndex != -1))
	{
		chartItems[currentSelectedIndex].SetState(Normal);
	}
	chartItems[Index].SetState(Selected);
	currentSelectedIndex = Index;
	homunculusWndEnchantCommunionInfoScript.SetSelect(Index);
	return;
}

function Show()
{
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function Hide()
{
	Me.HideWindow();
	currentSelectedIndex = -1;
	return;
}

function InitHandleChartItems()
{
	local int i;

	i = 0;
	while((i < 5))
	{
		GetWindowHandle(((m_Windowname $ ".Item") $ string(i))).SetScript("HomunculusWndEnchantCommunionChartItem");
		chartItems[i] = HomunculusWndEnchantCommunionChartItem(GetWindowHandle(((m_Windowname $ ".Item") $ string(i))).GetScript());
		chartItems[i].Init(((m_Windowname $ ".Item") $ string(i)));
		i++;
	}
	currentSelectedIndex = -1;
	return;
}

function SetEffectByPer(int Level)
{
	local int dist;

	if(!Spawned)
	{
		EffectViewportChart.SpawnNPC();
		EffectViewportChart.SpawnEffect("LineageEffect_br.br_e_lamp_deco_d");
		EffectViewportChart.SetBackgroundTex("L2UI_EPIC.HomunCulusWnd.HomunCom_EnchantBG");
		Spawned = true;
	}
	if((Level > 0))
	{
		EffectViewportChart.ShowWindow();
	}
	switch(Level)
	{
		case 0:
			EffectViewportChart.HideWindow();
			break;
		case 1:
			dist = 300;
			break;
		case 2:
			dist = 250;
			break;
		case 3:
			dist = 200;
			break;
		case 4:
			dist = 150;
			break;
		case 5:
			dist = 100;
			break;
		case 6:
			dist = 50;
			break;
		default:
			break;
	}
	EffectViewportChart.SetCameraDistance(dist);
	return;
}

function ClearAll()
{
	local int i;

	i = 0;
	while((i < 5))
	{
		chartItems[i].ClearAll();
		chartItems[i].SetState(Lock);
		i++;
	}
	currentSelectedIndex = -1;
	SetEffectByPer(0);
	return;
}

function SetChangeHomunculusData()
{
	local int i, SkillID, SkillLevel, currEnchantLv;
	local HomunculusAPI.HomunculusNpcLevelData npcLevelData;

	i = 0;
	while((i < GetCurrHomunculusData().Level))
	{
		if((currentSelectedIndex != i))
		{
			chartItems[i].SetState(Normal);
		}
		else
		{
			SetSelect(i);
		}
		npcLevelData = HomunculusWndScript.API_GetHomunculusNpcLevelData(GetCurrHomunculusData().Id, (i + 1));
		currEnchantLv = GetCurrHomunculusData().SkillLevel[(i + 1)];
		if((currEnchantLv == 0))
		{
			SkillLevel = npcLevelData.OptionSkillLevel[2];
			SkillID = npcLevelData.OptionSkillId[2];
		}
		else
		{
			SkillLevel = currEnchantLv;
			SkillID = GetCurrHomunculusData().SkillID[(i + 1)];
		}
		chartItems[i].SetSkill(SkillID, SkillLevel, currEnchantLv);
		i++;
	}
	i = i;
	while((i < 5))
	{
		chartItems[i].SetState(Lock);
		npcLevelData = HomunculusWndScript.API_GetHomunculusNpcLevelData(GetCurrHomunculusData().Id, (i + 1));
		SkillLevel = npcLevelData.OptionSkillLevel[2];
		SkillID = npcLevelData.OptionSkillId[2];
		chartItems[i].SetSkill(SkillID, SkillLevel, 0);
		i++;
	}
	SetEffectByPer(GetCurrHomunculusData().Level);
	return;
}

function HomunculusAPI.HomunculusData GetCurrHomunculusData()
{
	return HomunculusWndMainList(GetScript("HomunculusWnd.HomunculusWndMainList")).GetCurrHomunculusData();
}
