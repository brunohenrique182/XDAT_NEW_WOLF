class MSViewerWnd extends UICommonAPI;

const SK_NORMAL = 0;
const SK_BUFF = 1;
const SK_DEBUFF = 2;
const SK_TOGGLE = 3;
const SK_SONGDANCE = 4;
const SK_PASSIVE = 5;
const SK_SEARCH = 6;
const SK_MAX = 7;

var string m_Windowname;
var ItemWindowHandle m_hItemWnd[7];
var ItemWindowHandle selectedItemWindowHandle;
var int prevSelectedSkillID;
var WindowHandle m_hWnd;
var WindowHandle m_hProfilerWnd;
var TabHandle m_hTabItemWnd;
var EditBoxHandle m_hEbSkillName;
var EditBoxHandle m_hEbSkillID;
var EditBoxHandle m_hEbSkillVisualEffect;
var EditBoxHandle m_hebSkillType;
var CheckBoxHandle m_hcbSkillCursor;
var ComboBoxHandle comboSkillLevel;
var ComboBoxHandle comboSkillSubLevel;
var TextBoxHandle m_hTxtFrontHairTexture;
var TextBoxHandle m_hTxtRearHairTexture;
var EditBoxHandle m_hEbMultiSpawnNum;
var CheckBoxHandle m_hCbMultiSpawn;
var CheckBoxHandle m_hCbMultiTarget;
var CheckBoxHandle m_hCbSimpleEmitter;
var int m_SelectedSkillLevel;
var int m_SelectedSkillSubLevel;

function OnRegisterEvent()
{
	RegisterEvent(4400);
	RegisterEvent(4410);
	RegisterEvent(4420);
	return;
}

function OnLoad()
{
	InitializeHandle();
	setWindowTitleByString("SKILL VIEWER");
	return;
}

function InitializeHandle()
{
	m_hWnd = GetWindowHandle(m_Windowname);
	m_hProfilerWnd = GetWindowHandle("MSProfilerWnd");
	m_hTabItemWnd = GetTabHandle((m_Windowname $ ".SkillTab"));
	m_hItemWnd[0] = GetItemWindowHandle((m_Windowname $ ".ItemWndSkillNormal"));
	m_hItemWnd[1] = GetItemWindowHandle((m_Windowname $ ".ItemWndSkillBuff"));
	m_hItemWnd[2] = GetItemWindowHandle((m_Windowname $ ".ItemWndSkillDebuff"));
	m_hItemWnd[3] = GetItemWindowHandle((m_Windowname $ ".ItemWndSkillToggle"));
	m_hItemWnd[4] = GetItemWindowHandle((m_Windowname $ ".ItemWndSkillSongdance"));
	m_hItemWnd[5] = GetItemWindowHandle((m_Windowname $ ".ItemWndSkillPassive"));
	m_hItemWnd[6] = GetItemWindowHandle((m_Windowname $ ".ItemWndSkillSearch"));
	m_hEbSkillName = GetEditBoxHandle((m_Windowname $ ".ebSkillName"));
	m_hEbSkillID = GetEditBoxHandle((m_Windowname $ ".ebSkillID"));
	m_hEbSkillVisualEffect = GetEditBoxHandle((m_Windowname $ ".ebVisualEffect"));
	m_hebSkillType = GetEditBoxHandle((m_Windowname $ ".ebSkillType"));
	m_hcbSkillCursor = GetCheckBoxHandle((m_Windowname $ ".cbSkillCursor"));
	m_hcbSkillCursor.SetTooltipText("데칼이 설정된 스킬의 경우, 데칼이펙트를 출력합니다.");  // EN?: For skills with a decal set, print the decal effect.
	comboSkillLevel = GetComboBoxHandle((m_Windowname $ ".ComboBoxSkillLevel"));
	comboSkillSubLevel = GetComboBoxHandle((m_Windowname $ ".ComboBoxSkillSubLevel"));
	m_hEbMultiSpawnNum = GetEditBoxHandle((m_Windowname $ ".ebMultiSpawnNum"));
	m_hCbMultiSpawn = GetCheckBoxHandle((m_Windowname $ ".cbMultiSpawn"));
	m_hCbMultiTarget = GetCheckBoxHandle((m_Windowname $ ".cbMultiTarget"));
	m_hCbSimpleEmitter = GetCheckBoxHandle((m_Windowname $ ".cbSimpleEmitter"));
	m_hEbMultiSpawnNum.SetString("10");
	comboSkillLevel.AddString("1");
	comboSkillLevel.SetSelectedNum(0);
	comboSkillSubLevel.AddString("0");
	comboSkillSubLevel.SetSelectedNum(0);
	return;
}

function OnEvent(int a_EventID, string param)
{
	switch(a_EventID)
	{
		case 4400:
			HandleAddSkill(param);
			break;
		case 4410:
			HandleShowSkillWnd();
			break;
		case 4420:
			HandleDeleteAllSkill();
			break;
		default:
			break;
	}
	return;
}

function HandleShowSkillWnd()
{
	if(m_hWnd.IsShowWindow())
	{
		m_hWnd.HideWindow();
	}
	else
	{
		m_hWnd.ShowWindow();
	}
	return;
}

function HandleDeleteAllSkill()
{
	m_hItemWnd[0].Clear();
	m_hItemWnd[1].Clear();
	m_hItemWnd[2].Clear();
	m_hItemWnd[3].Clear();
	m_hItemWnd[4].Clear();
	m_hItemWnd[5].Clear();
	m_hItemWnd[6].Clear();
	comboSkillLevel.Clear();
	comboSkillSubLevel.Clear();
	selectedItemWindowHandle = none;
	prevSelectedSkillID = -1;
	return;
}

function HandleAddSkill(string param)
{
	local int Type, SkillLevel, SkillSubLevel, SkillLock;
	local string strIconName, strSkillName, strDescription, strEnchantName, strCommand, strIconPanel;
	local ItemInfo infItem;

	ParseItemID(param, infItem.Id);
	ParseInt(param, "Type", Type);
	ParseInt(param, "Level", SkillLevel);
	ParseInt(param, "SubLevel", SkillSubLevel);
	ParseInt(param, "SkillLock", SkillLock);
	ParseString(param, "Name", strSkillName);
	ParseString(param, "IconName", strIconName);
	ParseString(param, "IconPanel", strIconPanel);
	ParseString(param, "Description", strDescription);
	ParseString(param, "AdditionalName", strEnchantName);
	ParseString(param, "Command", strCommand);
	infItem.Level = SkillLevel;
	infItem.SubLevel = SkillSubLevel;
	infItem.Name = strSkillName;
	infItem.AdditionalName = strEnchantName;
	infItem.IconName = strIconName;
	infItem.IconPanel = strIconPanel;
	infItem.Description = strDescription;
	infItem.ShortcutType = 2;
	infItem.MacroCommand = strCommand;
	if((SkillLock > 0))
	{
		infItem.bDisabled = 1;
	}
	else
	{
		infItem.bDisabled = 0;
	}
	if(((Type >= 0) && (Type < 7)))
	{
		m_hItemWnd[Type].AddItem(infItem);
	}
	return;
}

function UpdateSelectedItem(ItemWindowHandle a_hItemWindow, int ItemClassID)
{
	selectedItemWindowHandle = a_hItemWindow;
	if((prevSelectedSkillID != ItemClassID))
	{
		RefreshSkillLevel(ItemClassID);
		prevSelectedSkillID = ItemClassID;
	}
	return;
}

function OnSelectItemWithHandle(ItemWindowHandle a_hItemWindow, int Index)
{
	local ItemInfo Info;

	a_hItemWindow.GetItem(Index, Info);
	UpdateSelectedItem(a_hItemWindow, Info.Id.ClassID);
	return;
}

function OnDBClickItemWithHandle(ItemWindowHandle a_hItemWindow, int Index)
{
	OnRClickItemWithHandle(a_hItemWindow, Index);
	return;
}

function OnRClickItemWithHandle(ItemWindowHandle a_hItemWindow, int Index)
{
	local ItemInfo Info;
	local int Level, SubLevel;

	a_hItemWindow.GetItem(Index, Info);
	UpdateSelectedItem(a_hItemWindow, Info.Id.ClassID);
	Level = Info.Level;
	SubLevel = Info.SubLevel;
	ExecuteSkill(Info, Level, SubLevel);
	return;
}

function ExecuteSkill(ItemInfo Info, int SkillLevel, int SkillSubLevel)
{
	if(Class'NWindow.UIDATA_PAWNVIEWER'.static.IsProfilingEmitter())
	{
		DialogShow(DialogModalType_Modalless, DialogType_Notice, "분석중에는 다른 스킬을 사용할 수 없습니다.");  // EN: you cannot use other skills while analyzing.
	}
	else
	{
		if(m_hProfilerWnd.IsShowWindow())
		{
			m_hProfilerWnd.ShowWindow();
			Class'NWindow.UIDATA_PAWNVIEWER'.static.ExecuteEmitterProfiling();
		}
		Class'NWindow.UIDATA_PAWNVIEWER'.static.ExecuteSkill(Info.Id.ClassID, SkillLevel, SkillSubLevel, m_hCbMultiTarget.IsChecked());
	}
	return;
}

function OnClickCheckBox(string strID)
{
	switch(strID)
	{
		case "cbMultiSpawn":
			if(m_hCbMultiSpawn.IsChecked())
			{
				Class'NWindow.UIDATA_PAWNVIEWER'.static.SpawnDummyPawn(int(m_hEbMultiSpawnNum.GetString()));
			}
			else
			{
				Class'NWindow.UIDATA_PAWNVIEWER'.static.ClearDummyPawn();
			}
			break;
		case "cbSimpleEmitter":
			Class'NWindow.UIDATA_PAWNVIEWER'.static.SetSimpleEmitter(m_hCbSimpleEmitter.IsChecked());
			break;
		case "cbSkillCursor":
			Class'NWindow.UIDATA_PAWNVIEWER'.static.SetGroundSkillCursor(m_hcbSkillCursor.IsChecked());
			break;
		default:
			break;
	}
	return;
}

event OnComboBoxItemSelected(string strID, int Index)
{
	switch(strID)
	{
		case "ComboBoxSkillLevel":
			m_SelectedSkillLevel = int(comboSkillLevel.GetString(Index));
			break;
		case "ComboBoxSkillSubLevel":
			m_SelectedSkillSubLevel = int(comboSkillSubLevel.GetString(Index));
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnSearchByName":
			processBtnSearchByName();
			break;
		case "btnSearchByID":
			processBtnSearchByID();
			break;
		case "btnSearchByVisualEffect":
			processBtnSearchByVisualEffect();
			break;
		case "btnSearchByType":
			processBtnSearchByType();
			break;
		case "btnProfiling":
			processBtnProfiling();
			break;
		case "ButtonExecuteSkill":
			processBtnExecuteSkill();
			break;
		case "btnLoadAllSkills":
			Class'NWindow.UIDATA_PAWNVIEWER'.static.LoadAllSkills();
			break;
		default:
			break;
	}
	return;
}

function processBtnExecuteSkill()
{
	local ItemInfo Info;

	if((selectedItemWindowHandle != none))
	{
		selectedItemWindowHandle.GetSelectedItem(Info);
		if(((m_SelectedSkillLevel == 0) && (m_SelectedSkillSubLevel == 0)))
		{
			m_SelectedSkillLevel = Info.Level;
			m_SelectedSkillSubLevel = Info.SubLevel;
		}
		ExecuteSkill(Info, m_SelectedSkillLevel, m_SelectedSkillSubLevel);
	}
	return;
}

function processBtnProfiling()
{
	if(m_hProfilerWnd.IsShowWindow())
	{
		Class'NWindow.UIDATA_PAWNVIEWER'.static.StopEmitterProfiling();
		m_hProfilerWnd.HideWindow();
	}
	else
	{
		m_hProfilerWnd.ShowWindow();
	}
	return;
}

function processBtnSearchByName()
{
	local string inputString;

	m_hItemWnd[6].Clear();
	inputString = m_hEbSkillName.GetString();
	if((Len(inputString) > 0))
	{
		Class'NWindow.UIDATA_PAWNVIEWER'.static.AddSkillByName(inputString);
		m_hTabItemWnd.SetTopOrder(6, false);
	}
	return;
}

function processBtnSearchByID()
{
	local int Id;

	m_hItemWnd[6].Clear();
	Id = int(m_hEbSkillID.GetString());
	if((Id > 0))
	{
		Class'NWindow.UIDATA_PAWNVIEWER'.static.AddSkillByID(Id);
		m_hTabItemWnd.SetTopOrder(6, false);
	}
	return;
}

function processBtnSearchByVisualEffect()
{
	local string visualEffect;

	m_hItemWnd[6].Clear();
	visualEffect = m_hEbSkillVisualEffect.GetString();
	if((Len(visualEffect) > 0))
	{
		Class'NWindow.UIDATA_PAWNVIEWER'.static.AddSkillByVisualEffect(visualEffect);
		m_hTabItemWnd.SetTopOrder(6, false);
	}
	return;
}

function processBtnSearchByType()
{
	local int Type;

	m_hItemWnd[6].Clear();
	Type = int(m_hebSkillType.GetString());
	if((Type > 0))
	{
		Class'NWindow.UIDATA_PAWNVIEWER'.static.AddSkillByType(Type);
		m_hTabItemWnd.SetTopOrder(6, false);
	}
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	if((int(nKey) == 13))
	{
		switch(a_WindowHandle.GetWindowName())
		{
			case "ebSkillName":
				processBtnSearchByName();
				break;
			case "ebSkillID":
				processBtnSearchByID();
				break;
			case "ebVisualEffect":
				processBtnSearchByVisualEffect();
				break;
			case "ebSkillType":
				processBtnSearchByType();
				break;
			default:
				break;
		}
	}
	return false;
}

function RefreshSkillLevel(int SkillID)
{
	local array<int> skillLevelList, skillSubLevelList;
	local int i;

	Class'NWindow.UIDATA_PAWNVIEWER'.static.GetSkillLevelListByID(SkillID, skillLevelList, skillSubLevelList);
	comboSkillLevel.Clear();
	i = (skillLevelList.Length - 1);
	while((i >= 0))
	{
		comboSkillLevel.AddString(string(skillLevelList[i]));
		--i;
	}
	comboSkillLevel.SetSelectedNum(0);
	m_SelectedSkillLevel = int(comboSkillLevel.GetSelectedString());
	comboSkillSubLevel.Clear();
	i = (skillSubLevelList.Length - 1);
	while((i >= 0))
	{
		comboSkillSubLevel.AddString(string(skillSubLevelList[i]));
		--i;
	}
	comboSkillSubLevel.SetSelectedNum(0);
	m_SelectedSkillSubLevel = int(comboSkillSubLevel.GetSelectedString());
	return;
}

defaultproperties
{
	m_Windowname="MSViewerWnd"
}
