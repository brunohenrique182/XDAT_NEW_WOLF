class RestartMenuWndReportDamage extends UICommonAPI;

struct DieInfoDamageData
{
	var UIEventManager.AttackerTypeEnum AttackerType;
	var string AttackerName;
	var string PledgeName;
	var int SkillClassID;
	var INT64 Damage;
	var UIEventManager.DamageTypeEnum DamageType;
	var int SkillLevel;
};

var string m_Windowname;
var WindowHandle Me;
var RichListCtrlHandle itemListCtrl;
var ButtonHandle CloseBtn;
var L2Util util;
var string lastParam;

function OnRegisterEvent()
{
	RegisterEvent(11160);
	RegisterEvent(11163);
	RegisterEvent(11162);
	return;
}

function OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case 11160:
			handleDieInfoBegin();
			break;
		case 11162:
			handleDieInfoDamage(param);
			break;
		case 11163:
			handleDieInfoEnd();
			break;
		default:
			break;
	}
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "minCloseButton":
		case "CloseBtn":
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function handleDieInfoBegin()
{
	itemListCtrl.DeleteAllItem();
	return;
}

function string GetSkillIconNameByDamageType(UIEventManager.DamageTypeEnum DamageType)
{
	switch(DamageType)
	{
		case DAMAGE_NORMAL:
		case DAMAGE_CHRONO:
		case DAMAGE_FIST:
			return "Icon.action_i.action003";
			break;
		case DAMAGE_HEIGHT:
			return "L2UI_CT1.Icon.restart_FallDeath_ICON";
			break;
		case DAMAGE_WATER:
			return "L2UI_CT1.Icon.restart_drownDeath_ICON";
			break;
		case DAMAGE_AREA:
			return "Icon.skill_i.skill11032";
			break;
		case DAMAGE_POISON:
			return "Icon.skill_i.skill6435";
			break;
		case DAMAGE_TRANSFER:
			return "Icon.skill_i.skill1262";
			break;
		case DAMAGE_SHIELD:
			return "Icon.skill_i.skill0086";
			break;
		case DAMAGE_SKILL:
		case DAMAGE_OVER_HIT:
		case DAMAGE_SUICIDE_SKILL:
		case DAMAGE_SUICIDE:
		case DAMAGE_CURSED_WEAPON_EXPIRED:
		case DAMAGE_EVENT:
		case DAMAGE_END:
		default:
			return "L2UI_CT1.Icon.restart_etcDeath_ICON";
			break;
	}
	return "Icon.action_i.action003";
}

function int GetSkillStringByDamageType(UIEventManager.DamageTypeEnum DamageType)
{
	switch(DamageType)
	{
		case DAMAGE_NORMAL:
		case DAMAGE_CHRONO:
		case DAMAGE_FIST:
			return 3998;
			break;
		case DAMAGE_HEIGHT:
			return 3999;
			break;
		case DAMAGE_WATER:
			return 4000;
			break;
		case DAMAGE_AREA:
			return 13001;
			break;
		case DAMAGE_POISON:
			return 13002;
			break;
		case DAMAGE_TRANSFER:
			return 13003;
			break;
		case DAMAGE_SHIELD:
			return 13004;
			break;
		case DAMAGE_SKILL:
		case DAMAGE_OVER_HIT:
		case DAMAGE_SUICIDE_SKILL:
		case DAMAGE_SUICIDE:
		case DAMAGE_CURSED_WEAPON_EXPIRED:
		case DAMAGE_EVENT:
		case DAMAGE_END:
		default:
			return 13005;
			break;
	}
	return 13005;
}

function handleDieInfoDamage(string param, optional bool isLast)
{
	local RichListCtrlRowData rowData;
	local DieInfoDamageData Data;
	local SkillInfo SkillInfo;
	local string skillIconName, SkillName, Damage;

	rowData.cellDataList.Length = 3;
	Data = GetDieInfoDamage(param);
	if(GetSkillInfo(Data.SkillClassID, Max(1, Data.SkillLevel), 0, SkillInfo))
	{
		if((int(Data.AttackerType) == 1))
		{
			skillIconName = "L2UI_CT1.Icon.restart_MonsterDeath_ICON";
		}
		else
		{
			skillIconName = SkillInfo.TexName;
		}
		SkillName = SkillInfo.SkillName;
	}
	else
	{
		skillIconName = GetSkillIconNameByDamageType(Data.DamageType);
		SkillName = GetSystemString(GetSkillStringByDamageType(Data.DamageType));
	}
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, 0);
	addRichListCtrlTexture(rowData.cellDataList[0].drawitems, skillIconName, 32, 32, -34, 2);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, SkillName, util.BrightWhite, false, 5, 8);
	Damage = MakeCostString(string(Data.Damage));
	if(isLast)
	{
		AddRichListCtrlString(rowData.cellDataList[1].drawitems, Damage, GetColor(255, 153, 153, 255), false, 0, 0);
	}
	else
	{
		AddRichListCtrlString(rowData.cellDataList[1].drawitems, Damage, util.BrightWhite, false, 0, 0);
	}
	switch(Data.AttackerType)
	{
		case ATTACKER_NONE:
			AddRichListCtrlString(rowData.cellDataList[1].drawitems, Data.AttackerName, util.White, true, 0, 0);
			break;
		case ATTACKER_PC:
			AddRichListCtrlString(rowData.cellDataList[1].drawitems, Data.AttackerName, GetColor(238, 170, 34, 255), true, 0, 5);
			if((Data.PledgeName != ""))
			{
				AddRichListCtrlString(rowData.cellDataList[1].drawitems, (("(" $ Data.PledgeName) $ ")"), GetColor(180, 180, 180, 255), false, 3, 0);
			}
			else
			{
				AddRichListCtrlString(rowData.cellDataList[1].drawitems, (("(" $ GetSystemString(431)) $ ")"), GetColor(180, 180, 180, 255), false, 3, 0);
			}
			addRichListCtrlTexture(rowData.cellDataList[2].drawitems, "L2UI_CT1.Icon.Restart_PCDamageICON", 16, 16, 0, 0);
			break;
		case ATTACKER_NPC:
			AddRichListCtrlString(rowData.cellDataList[1].drawitems, Data.AttackerName, util.White, true, 0, 0);
			break;
		default:
			AddRichListCtrlString(rowData.cellDataList[1].drawitems, Data.AttackerName, util.White, true, 0, 0);
			break;
	}
	if(isLast)
	{
		addRichListCtrlTexture(rowData.cellDataList[2].drawitems, "L2UI_CT1.Icon.Restart_DeathDamageICON", 16, 16, 0, 0);
		itemListCtrl.ModifyRecord((itemListCtrl.GetRecordCount() - 1), rowData);
		lastParam = "";
	}
	else
	{
		itemListCtrl.InsertRecord(rowData);
		lastParam = param;
	}
	return;
}

function handleDieInfoEnd()
{
	handleDieInfoDamage(lastParam, true);
	itemListCtrl.SetSelectedIndex((itemListCtrl.GetRecordCount() - 1), true);
	itemListCtrl.InitListCtrl();
	return;
}

function Initialize()
{
	Me = GetWindowHandle(m_Windowname);
	itemListCtrl = GetRichListCtrlHandle((m_Windowname $ ".RestartmenuWndReport_ListCtrl"));
	CloseBtn = GetButtonHandle((m_Windowname $ ".CloseBtn"));
	util = L2Util(GetScript("L2Util"));
	itemListCtrl.SetSelectedSelTooltip(false);
	itemListCtrl.SetAppearTooltipAtMouseX(true);
	return;
}

function Color GetColor(int R, int G, int B, int A)
{
	local Color tColor;

	tColor.R = byte(R);
	tColor.G = byte(G);
	tColor.B = byte(B);
	tColor.A = byte(A);
	return tColor;
}

function DieInfoDamageData GetDieInfoDamage(string param)
{
	local DieInfoDamageData Data;
	local int tmpInt;

	ParseInt(param, "AttackerType", tmpInt);
	Data.AttackerType = AttackerTypeEnum(tmpInt);
	ParseString(param, "AttackerName", Data.AttackerName);
	ParseString(param, "PledgeName", Data.PledgeName);
	ParseInt(param, "SkillClassID", Data.SkillClassID);
	ParseINT64(param, "Damage", Data.Damage);
	ParseInt(param, "DamageType", tmpInt);
	ParseInt(param, "SkillLevel", Data.SkillLevel);
	Data.DamageType = DamageTypeEnum(tmpInt);
	return Data;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="RestartMenuWndReportDamage"
}
