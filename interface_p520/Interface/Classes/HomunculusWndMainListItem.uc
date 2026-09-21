class HomunculusWndMainListItem extends UICommonAPI;

enum type_State
{
	Lock,                           // 0
	NOTACTIVE,                      // 1
	READY,                          // 2
	Normal                          // 3
};

var WindowHandle Me;
var string m_Windowname;
var int Index;
var ButtonHandle mainBtn;
var TextBoxHandle text0;
var TextureHandle texNew;
var TextureHandle texMonster;
var TextureHandle texGradepanel;
var AnimTextureHandle texGrade;
var AnimTextureHandle texCommunion;
var WindowHandle conditionWnd;
var HomunculusWnd HomunculusWndScript;
var HomunculusWndMainList homunculusWndMainListScript;
var HomunculusAPI.HomunculusData currHomunculusData;
var bool Selected;
var bool Enable;
var bool _resolution;
var type_State currState;
//var delegate<DelegateOnClickThis> __DelegateOnClickThis__Delegate;

delegate DelegateOnClickThis(HomunculusWndMainListItem scr)
{
	return;
}

function Initialize()
{
	homunculusWndMainListScript = HomunculusWndMainList(GetScript("HomunculusWnd.HomunculusWndMainList"));
	HomunculusWndScript = HomunculusWnd(GetScript("HomunculusWnd"));
	mainBtn = GetButtonHandle((m_Windowname $ ".mainBtn"));
	text0 = GetTextBoxHandle((m_Windowname $ ".text0"));
	texGrade = GetAnimTextureHandle((m_Windowname $ ".texGrade"));
	texGradepanel = GetTextureHandle((m_Windowname $ ".texGradepanel"));
	texNew = GetTextureHandle((m_Windowname $ ".texNew"));
	texMonster = GetTextureHandle((m_Windowname $ ".texMonster"));
	texCommunion = GetAnimTextureHandle((m_Windowname $ ".texCommunion"));
	conditionWnd = GetWindowHandle((m_Windowname $ ".conditionWnd"));
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

event OnClickButton(string Name)
{
	DelegateOnClickThis(self);
	switch(Name)
	{
		case "MainBtn":
			if(!Enable)
			{
				return;
			}
			if(_resolution)
			{
				return;
			}
			homunculusWndMainListScript.HandleListItemClicked(Index);
			if(currHomunculusData.IsNew)
			{
				SetNew(false);
			}
			break;
		default:
			break;
	}
	return;
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	if(Selected)
	{
		SetNew(false);
		homunculusWndMainListScript.RemNew(currHomunculusData.idx);
	}
	return;
}

function SetLevel(int L)
{
	if(((IsBuilderPC() && (int(GetReleaseMode()) == 0)) && GetWindowHandle("GMWND").IsShowWindow()))
	{
		text0.SetText((((GetSystemString(88) @ string(L)) @ "idx:") $ string(currHomunculusData.idx)));
	}
	else
	{
		text0.SetText((GetSystemString(88) @ string(L)));
	}
	return;
}

function SetGrade(int G)
{
	texGrade.Stop();
	switch(G)
	{
		case 0:
		case 1:
		case 2:
		case 3:
			texGradepanel.SetTexture(("L2UI_EPIC.HomunCulusWnd.Homun_CubeGrade0" $ string((G + 1))));
			texGrade.SetTexture((("L2UI_EPIC.HomunCulusWndAni.Grade0" $ string((G + 1))) $ "Ani_0000"));
			texGrade.ShowWindow();
			texGrade.SetLoopCount(99999);
			texGrade.Play();
			texGradepanel.ShowWindow();
			break;
		default:
			texGradepanel.HideWindow();
			texGrade.HideWindow();
			break;
	}
	return;
}

function SetNew(bool IsNew)
{
	if(IsNew)
	{
		texNew.ShowWindow();
	}
	else
	{
		texNew.HideWindow();
	}
	return;
}

function SetActive(bool IsActive)
{
	currHomunculusData.Activate = IsActive;
	if(IsActive)
	{
		texCommunion.ShowWindow();
		texCommunion.Stop();
		texCommunion.SetLoopCount(99999);
		texCommunion.Play();
	}
	else
	{
		texCommunion.Stop();
		texCommunion.HideWindow();
	}
	return;
}

function SetOnBirth()
{
	GetTextBoxHandle((conditionWnd.m_WindowNameWithFullPath $ ".conditiontxt")).SetText(GetSystemString(13359));
	conditionWnd.ShowWindow();
	return;
}

function _SetSacrificeConditionText()
{
	GetTextBoxHandle((conditionWnd.m_WindowNameWithFullPath $ ".conditiontxt")).SetText(GetSystemString(14611));
	conditionWnd.ShowWindow();
	return;
}

function SetEnable()
{
	Enable = true;
	switch(currState)
	{
		case READY:
			mainBtn.SetTexture("L2UI_EPIC.HomunCulusWnd.CubeListBG_Plus", "L2UI_EPIC.HomunCulusWnd.CubeListBG_Plus_over", "L2UI_EPIC.HomunCulusWnd.CubeListBG_Plus_down");
			break;
		case NOTACTIVE:
			mainBtn.SetTexture("L2UI_EPIC.HomunCulusWnd.CubeListBG_lockActive", "L2UI_EPIC.HomunCulusWnd.CubeListBG_lock_over", "L2UI_EPIC.HomunCulusWnd.CubeListBG_lock_down");
			break;
		case Normal:
			mainBtn.SetTexture("L2UI_EPIC.HomunCulusWnd.CubeListBTN_Empty", "L2UI_EPIC.HomunCulusWnd.CubeListBTN_over", "L2UI_EPIC.HomunCulusWnd. CubeListBTN_Empty");
			break;
		default:
			break;
	}
	return;
}

function ClearAll()
{
	local HomunculusAPI.HomunculusData emptyData;

	currHomunculusData = emptyData;
	SetState(Lock);
	mainBtn.ClearTooltip();
	return;
}

function SetHomunculusData(HomunculusAPI.HomunculusData Data)
{
	local HomunculusAPI.HomunculusNpcData npcData;

	currHomunculusData = Data;
	SetLevel(currHomunculusData.Level);
	SetGrade(currHomunculusData.Type);
	SetActive(currHomunculusData.Activate);
	npcData = HomunculusWndScript.GetHomunculusNpcData(currHomunculusData.Id);
	if((npcData.ImgName == ""))
	{
		texMonster.SetTexture(GetRandomTexture(currHomunculusData.Id));
	}
	else
	{
		texMonster.SetTexture(npcData.ImgName);
	}
	SetNew(currHomunculusData.IsNew);
	SetTooltip();
	return;
}

function SetTooltip()
{
	local HomunculusAPI.HomunculusNpcData npcData;
	local string NpcName, gradeString;
	local CustomTooltip t;

	getInstanceL2Util().setCustomTooltip(t);
	getInstanceL2Util().ToopTipMinWidth(10);
	npcData = HomunculusWndScript.GetHomunculusNpcData(currHomunculusData.Id);
	NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(npcData.NpcID);
	gradeString = HomunculusWndScript.GetGradeString(currHomunculusData.Type);
	getInstanceL2Util().ToopTipInsertColorText((((GetSystemString(88) $ ".") $ string(currHomunculusData.Level)) @ NpcName), true, true);
	getInstanceL2Util().ToopTipInsertColorText(gradeString, true, true);
	mainBtn.SetTooltipCustomType(getInstanceL2Util().getCustomToolTip());
	return;
}

function _SetTooltipSacrifice()
{
	local CustomTooltip t;

	getInstanceL2Util().setCustomTooltip(t);
	getInstanceL2Util().ToopTipMinWidth(10);
	getInstanceL2Util().ToopTipInsertColorText(GetSystemString(14609), true, true);
	mainBtn.SetTooltipCustomType(getInstanceL2Util().getCustomToolTip());
	return;
}

function SetState(type_State toState)
{
	currState = toState;
	conditionWnd.HideWindow();
	Enable = false;
	switch(currState)
	{
		case READY:
			mainBtn.ClearTooltip();
			mainBtn.SetTexture("L2UI_EPIC.HomunCulusWnd.CubeListBG_PlusDisable", "L2UI_EPIC.HomunCulusWnd.CubeListBG_PlusDisable", "L2UI_EPIC.HomunCulusWnd.CubeListBG_PlusDisable");
			mainBtn.ShowWindow();
			text0.SetText("");
			SetGrade(-1);
			SetNew(false);
			SetActive(false);
			mainBtn.EnableWindow();
			texMonster.HideWindow();
			break;
		case Lock:
			mainBtn.ClearTooltip();
			mainBtn.HideWindow();
			text0.SetText("");
			SetGrade(-1);
			SetNew(false);
			SetActive(false);
			mainBtn.DisableWindow();
			texMonster.HideWindow();
			break;
		case Normal:
			mainBtn.SetTexture("L2UI_EPIC.HomunCulusWnd.CubeListBTN_Empty", "L2UI_EPIC.HomunCulusWnd.CubeListBTN_over", "L2UI_EPIC.HomunCulusWnd. CubeListBTN_Empty");
			mainBtn.ShowWindow();
			SetSelected(Selected);
			texMonster.ShowWindow();
			break;
		case NOTACTIVE:
			mainBtn.ClearTooltip();
			mainBtn.SetTexture("L2UI_EPIC.HomunCulusWnd.CubeListBG_lockActive", "L2UI_EPIC.HomunCulusWnd.CubeListBG_lock_over", "L2UI_EPIC.HomunCulusWnd.CubeListBG_lock_down");
			mainBtn.ShowWindow();
			text0.SetText("");
			SetGrade(-1);
			SetNew(false);
			SetActive(false);
			mainBtn.EnableWindow();
			texMonster.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function SetSelected(bool isSelect)
{
	Selected = isSelect;
	if(Selected)
	{
		mainBtn.DisableWindow();
	}
	else
	{
		mainBtn.EnableWindow();
	}
	return;
}

function string GetRandomTexture(int Id)
{
	local int Per;

	Per = ((Id - 1) / 3);
	switch(Per)
	{
		case 0:
			return "L2UI_EPIC.HomunCulusWnd.HomunNPC_Chu";
		case 1:
			return "L2UI_EPIC.HomunCulusWnd.HomunNPC_Utanka";
		case 2:
			return "L2UI_EPIC.HomunCulusWnd.HomunNPC_Buffalo";
		case 3:
			return "L2UI_EPIC.HomunCulusWnd.HomunNPC_Chick";
		case 4:
			return "L2UI_EPIC.HomunCulusWnd.HomunNPC_Hatchling";
		default:
			return "";
	}
}
