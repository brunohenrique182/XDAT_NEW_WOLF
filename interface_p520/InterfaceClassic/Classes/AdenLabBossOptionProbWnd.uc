class AdenLabBossOptionProbWnd extends UICommonAPI
	dependson(UIPacket);

const TYPE_NON = 0;
const TYPE_NORMAL = 1;
const TYPE_SPECIAL = 2;

struct SpecialOptionData
{
	var int OptionID;
	var int buttonIndex;
	var int Level;
};

struct GainOptionStruct
{
	var string Name;
	var int OptionID;
	var float Value;
};

var AdenLabBossOptionWnd AdenLabBossOptionWNdScr;
var AdenLabWnd adenLabWndScr;
var RichListCtrlHandle adenLabBossOptionProb_List;
var RichListCtrlHandle adenLabWndProb_List;
var WindowHandle adenLabWndTransProb_wnd;
var ButtonHandle nextBtn;
var ButtonHandle prevBtn;
var TextBoxHandle EffectStepText;
var int transcendenceCurr;
var HtmlHandle EffectHtml01_txt;
var HtmlHandle EffectHtml02_txt;
var TextBoxHandle EffectHtml01Desc_txt;
var TextBoxHandle EffectHtml02Desc_txt;
var SpecialOptionData SpcialOptionDataCurr;
var int typeCurr;
var WindowHandle disableWnd;
var array<UIPacket._PkAdenLabSpecialGradeProb> gradeProbs;

static function AdenLabBossOptionProbWnd _Inst()
{
	return AdenLabBossOptionProbWnd(GetScript("AdenLabBossOptionProbWnd"));
}

function Init()
{
	adenLabBossOptionProb_List = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AdenLabBossOptionProb_List"));
	adenLabBossOptionProb_List.SetSelectable(false);
	adenLabBossOptionProb_List.SetUseStripeBackTexture(false);
	adenLabWndProb_List = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".adenLabWndProb_List"));
	adenLabWndProb_List.SetSelectable(false);
	adenLabWndProb_List.SetUseStripeBackTexture(false);
	AdenLabBossOptionWNdScr = AdenLabBossOptionWnd(GetScript("AdenLabBossOptionWNd"));
	adenLabWndScr = AdenLabWnd(GetScript("AdenLabWNd"));
	adenLabWndTransProb_wnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".adenLabWndTransProb_wnd"));
	adenLabWndTransProb_wnd.HideWindow();
	nextBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".adenLabWndTransProb_wnd.NextBtn"));
	prevBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".adenLabWndTransProb_wnd.PrevBtn"));
	EffectStepText = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".adenLabWndTransProb_wnd.EffectStepText"));
	disableWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".disableWnd"));
	disableWnd.HideWindow();
	EffectHtml01_txt = GetHtmlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".adenLabWndTransProb_wnd.EffectHtml01_txt"));
	EffectHtml02_txt = GetHtmlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".adenLabWndTransProb_wnd.EffectHtml02_txt"));
	EffectHtml01Desc_txt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".adenLabWndTransProb_wnd.EffectHtml01Desc_txt"));
	EffectHtml02Desc_txt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".adenLabWndTransProb_wnd.EffectHtml02Desc_txt"));
	ClearStateAll();
	return;
}

function _Hide()
{
	m_hOwnerWnd.HideWindow();
	return;
}

function _ToggleAdenOption()
{
	if(!ToggleNChkType(1))
	{
		return;
	}
	ChangeType(1);
	adenLabBossOptionProb_List.HideWindow();
	adenLabWndProb_List.ShowWindow();
	adenLabWndTransProb_wnd.HideWindow();
	MakeAdenOptionInfo();
	ChkDisableWindow();
	return;
}

function MakeAdenOptionInfo()
{
	local int i;
	local array<int> tmpOptionIds, tmpLevels;
	local array<GainOptionStruct> gainNormalOptions, gainSpcialOptions;

	setWindowTitleByString(GetSystemString(14617));
	i = 0;
	while((i < adenLabWndScr._GetCurrentPieceID()))
	{
		adenLabWndScr._GetPieceInfoScript(i)._GetOptionDatas(tmpOptionIds, tmpLevels);
		switch(adenLabWndScr._GetPieceInfoScript(i)._GetStageType())
		{
			case STAGE_NORMAL:
				AddOpitons(gainNormalOptions, tmpOptionIds, tmpLevels);
				break;
			case STAGE_SPECIAL:
				AddOpitons(gainSpcialOptions, tmpOptionIds, tmpLevels);
				break;
			default:
				break;
		}
		i++;
	}
	adenLabWndProb_List.DeleteAllItem();
	if((adenLabWndScr._GetCurrentTranscendEnchant() > 0))
	{
		adenLabWndProb_List.InsertRecord(MakeGainOptoinTitleRowData(2));
		adenLabWndProb_List.InsertRecord(MakeTranscendOptionRowData());
	}
	if((gainSpcialOptions.Length > 0))
	{
		adenLabWndProb_List.InsertRecord(MakeGainOptoinTitleRowData(1));
		i = 0;
		while((i < gainSpcialOptions.Length))
		{
			adenLabWndProb_List.InsertRecord(MakeGainOpitonRowData(gainSpcialOptions[i].OptionID, gainSpcialOptions[i].Value));
			i++;
		}
	}
	if((gainNormalOptions.Length > 0))
	{
		adenLabWndProb_List.InsertRecord(MakeGainOptoinTitleRowData(0));
		i = 0;
		while((i < gainNormalOptions.Length))
		{
			adenLabWndProb_List.InsertRecord(MakeGainOpitonRowData(gainNormalOptions[i].OptionID, gainNormalOptions[i].Value));
			i++;
		}
	}
	return;
}

function RichListCtrlRowData MakeTranscendOptionRowData()
{
	local RichListCtrlRowData rowData;
	local string valueString;

	rowData.cellDataList.Length = 1;
	valueString = MakeFullSystemMsg(GetSystemMessage(13981), string(adenLabWndScr._GetCurrentTranscendEnchant()));
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, valueString);
	return rowData;
}

function AddOpitons(out array<GainOptionStruct> oGainOptions, array<int> optionIds, array<int> lvs)
{
	local int i;

	i = 0;
	while((i < optionIds.Length))
	{
		AddOption(oGainOptions, optionIds[i], lvs[i]);
		i++;
	}
	return;
}

function AddOption(out array<GainOptionStruct> oGainOptions, int OptionID, int lv)
{
	local int i;
	local GainOptionStruct gainOption;
	local ExOptionData optionData;
	local int Index;

	lv = Max(1, lv);
	i = 0;
	while((i < oGainOptions.Length))
	{
		API_GetExOptionData(OptionID, lv, optionData);
		if((oGainOptions[i].Name == optionData.Filter[0].Name))
		{
			oGainOptions[i].Value = (oGainOptions[i].Value + optionData.Filter[0].Value);
			return;
		}
		i++;
	}
	API_GetExOptionData(OptionID, lv, optionData);
	gainOption.OptionID = OptionID;
	gainOption.Value = optionData.Filter[0].Value;
	gainOption.Name = optionData.Filter[0].Name;
	Index = oGainOptions.Length;
	oGainOptions.Length = (oGainOptions.Length + 1);
	oGainOptions[Index] = gainOption;
	return;
}

function _ToggleAdenSpcialOption(int OptionID, int buttonIndex, int CurrentLevel)
{
	if((SpcialOptionDataCurr.OptionID != OptionID))
	{
		m_hOwnerWnd.ShowWindow();
	}
	else if(!ToggleNChkType(2))
	{
		return;
	}
	if(!m_hOwnerWnd.IsShowWindow())
	{
		return;
	}
	ChangeType(2);
	SpcialOptionDataCurr.Level = CurrentLevel;
	SpcialOptionDataCurr.buttonIndex = buttonIndex;
	SpcialOptionDataCurr.OptionID = OptionID;
	adenLabWndTransProb_wnd.HideWindow();
	adenLabWndProb_List.HideWindow();
	adenLabBossOptionProb_List.ShowWindow();
	ModifySpecialOptionProbs();
	return;
}

function ModifySpecialOptionProbs()
{
	local array<int> probs;

	probs = gradeProbs[SpcialOptionDataCurr.buttonIndex].probs;
	MakeAdenSpcialOptionList(SpcialOptionDataCurr.OptionID, probs, (probs.Length - SpcialOptionDataCurr.Level));
	ChkDisableWindow();
	return;
}

function string _GetProbIndexNLevel(int Index, int Level)
{
	return Class'InterfaceClassic.L2Util'.static.Inst().MakeDecimalPointString(string(gradeProbs[Index].probs[(Level - 1)]), 2, true, true);
}

function ChangeType(int newType)
{
	ClearStateAll();
	typeCurr = newType;
	return;
}

function MakeAdenSpcialOptionList(int OptionID, array<int> probs, int SelectedIndex)
{
	local int i;
	local string nameString;

	nameString = AdenLabBossOptionWNdScr._GetOptionNameString(OptionID, 1);
	setWindowTitleByString(nameString);
	adenLabBossOptionProb_List.DeleteAllItem();
	i = probs.Length;
	while((i >= 1))
	{
		adenLabBossOptionProb_List.InsertRecord(MakeSpcialOptionRowData(OptionID, i, probs[(i - 1)], probs.Length, SelectedIndex));
		i--;
	}
	return;
}

function bool ChkType(int newType)
{
	return (typeCurr == newType);
}

function bool ToggleNChkType(int newType)
{
	if(!ChkType(newType))
	{
		m_hOwnerWnd.ShowWindow();
	}
	else if(m_hOwnerWnd.IsShowWindow())
	{
		m_hOwnerWnd.HideWindow();
	}
	else
	{
		m_hOwnerWnd.ShowWindow();
	}
	return m_hOwnerWnd.IsShowWindow();
}

function ClearStateAll()
{
	transcendenceCurr = -1;
	SpcialOptionDataCurr.buttonIndex = -1;
	SpcialOptionDataCurr.OptionID = -1;
	SpcialOptionDataCurr.Level = -1;
	typeCurr = 0;
	return;
}

function ChkDisableWindow()
{
	if(((typeCurr == 1) && (adenLabWndProb_List.GetRecordCount() == 0)))
	{
		disableWnd.ShowWindow();
	}
	else
	{
		disableWnd.HideWindow();
	}
	return;
}

event OnLoad()
{
	Init();
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(1154));
	RegisterEvent(EV_PacketID(1153));
	return;
}

event OnEvent(int EvID, string params)
{
	switch(EvID)
	{
		case EV_PacketID(1154):
			RT_S_EX_ADENLAB_SPECIAL_PROB();
			break;
		case EV_PacketID(1153):
			RT_S_EX_ADENLAB_SPECIAL_SLOT();
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	m_hOwnerWnd.SetFocus();
	return;
}

event OnHide()
{
	ChangeType(0);
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "detailTranscendenceBtn":
			ShowTranscendenceDetailInfo();
			break;
		case "BackBtn":
			HandleBackBtnClick();
			break;
		case "NextBtn":
			HandleNextBtnClick();
			break;
		case "PrevBtn":
			HandlePrevBtnClick();
			break;
		default:
			break;
	}
	return;
}

function RichListCtrlRowData MakeSpcialOptionRowData(int OptionID, int Level, int Prob, int MaxLevel, int SelectedIndex)
{
	local RichListCtrlRowData rowData;
	local string valueString, probString;
	local Color selectedColor;

	rowData.cellDataList.Length = 3;
	if((adenLabBossOptionProb_List.GetRecordCount() == SelectedIndex))
	{
		selectedColor = getInstanceL2Util().Yellow03;
	}
	else
	{
		selectedColor = getInstanceL2Util().White;
	}
	valueString = AdenLabBossOptionWNdScr._GetOptionValueString(OptionID, Level);
	probString = Class'InterfaceClassic.L2Util'.static.Inst().MakeDecimalPointString(string(Prob), 2, true, true);
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, string(Level), selectedColor);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, valueString, selectedColor);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, probString, selectedColor);
	switch((MaxLevel - Level))
	{
		case 0:
			rowData.sOverlayTex = "L2UI_NewTex.AdenLabWnd.OptionListHeaderBg_A";
			break;
		case 1:
			rowData.sOverlayTex = "L2UI_NewTex.AdenLabWnd.OptionListHeaderBg_B";
			break;
		case 2:
			rowData.sOverlayTex = "L2UI_NewTex.AdenLabWnd.OptionListHeaderBg_C";
			break;
		case 3:
			rowData.sOverlayTex = "L2UI_NewTex.AdenLabWnd.OptionListHeaderBg_D";
			break;
		case 4:
			rowData.sOverlayTex = "L2UI_NewTex.AdenLabWnd.OptionListHeaderBg_E";
			break;
		default:
			break;
	}
	return rowData;
}

function RichListCtrlRowData MakeGainOptoinTitleRowData(int Type)
{
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = 1;
	switch(Type)
	{
		case 0:
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetSystemString(441));
			rowData.sOverlayTex = "L2UI_NewTex.AdenLabWnd.ListBg01";
			break;
		case 1:
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetSystemString(1796));
			rowData.sOverlayTex = "L2UI_NewTex.AdenLabWnd.ListBg02";
			break;
		case 2:
			rowData.cellDataList.Length = 2;
			AddRichListCtrlString(rowData.cellDataList[0].drawitems, GetSystemString(14650));
			rowData.sOverlayTex = "L2UI_NewTex.AdenLabWnd.ListBg03";
			AddRichListCtrlButton(rowData.cellDataList[1].drawitems, "detailTranscendenceBtn", 0, 0, "L2UI_NewTex.AdenLabWnd.TransListBtn_Normal", "L2UI_NewTex.AdenLabWnd.TransListBtn_Down", "L2UI_NewTex.AdenLabWnd.TransListBtn_Over", 27, 27, 27, 27);
			break;
		default:
			break;
	}
	return rowData;
}

function RichListCtrlRowData MakeGainOpitonRowData(int OptionID, float Value)
{
	local RichListCtrlRowData rowData;
	local string nameString, valueString;

	nameString = AdenLabBossOptionWNdScr._GetOptionNameString(OptionID, 1);
	valueString = AdenLabBossOptionWNdScr._MakeOptionValueString(OptionID, Value);
	rowData.cellDataList.Length = 2;
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, nameString, GetColor(255, 255, 255, 255), false, 0);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, valueString);
	return rowData;
}

function ShowTranscendenceDetailInfo()
{
	transcendenceCurr = adenLabWndScr._GetCurrentTranscendEnchant();
	adenLabWndTransProb_wnd.ShowWindow();
	adenLabWndProb_List.HideWindow();
	SetTranscendenceTitle();
	ChkNextPrevBtn();
	SetTranscendenceData();
	return;
}

function HandleBackBtnClick()
{
	adenLabWndTransProb_wnd.HideWindow();
	adenLabWndProb_List.ShowWindow();
	return;
}

function HandleNextBtnClick()
{
	transcendenceCurr++;
	ChkNextPrevBtn();
	SetTranscendenceTitle();
	SetTranscendenceData();
	return;
}

function HandlePrevBtnClick()
{
	transcendenceCurr--;
	ChkNextPrevBtn();
	SetTranscendenceTitle();
	SetTranscendenceData();
	return;
}

function SetTranscendenceTitle()
{
	EffectStepText.SetText(MakeFullSystemMsg(GetSystemMessage(13981), string(transcendenceCurr)));
	if((transcendenceCurr == adenLabWndScr._GetCurrentTranscendEnchant()))
	{
		EffectStepText.SetTextColor(GetColor(255, 255, 187, 255));
	}
	else
	{
		EffectStepText.SetTextColor(getInstanceL2Util().Gray);
	}
	return;
}

function ChkNextPrevBtn()
{
	if((transcendenceCurr == 3))
	{
		nextBtn.DisableWindow();
	}
	else
	{
		nextBtn.EnableWindow();
	}
	if((transcendenceCurr == 1))
	{
		prevBtn.DisableWindow();
	}
	else
	{
		prevBtn.EnableWindow();
	}
	return;
}

function SetTranscendenceData()
{
	local array<string> desces;

	desces = Class'InterfaceClassic.AdenLabWnd'.static._Inst()._GetTrancendenceDescs((Class'InterfaceClassic.AdenLabWnd'.static._Inst()._GetMaxPieceInfoNum() + transcendenceCurr));
	if((desces[0] == ""))
	{
		EffectHtml01Desc_txt.ShowWindow();
		EffectHtml01_txt.HideWindow();
	}
	else
	{
		EffectHtml01_txt.LoadHtmlFromString(desces[0]);
		EffectHtml01Desc_txt.HideWindow();
		EffectHtml01_txt.ShowWindow();
	}
	if((desces[1] == ""))
	{
		EffectHtml02Desc_txt.ShowWindow();
		EffectHtml02_txt.HideWindow();
	}
	else
	{
		EffectHtml02_txt.LoadHtmlFromString(desces[1]);
		EffectHtml02Desc_txt.HideWindow();
		EffectHtml02_txt.ShowWindow();
	}
	return;
}

function API_GetEquipAddOptionData(int opitonID, out array<EquipAddOptionData> datas)
{
	Class'NWindow.UIDataManager'.static.GetEquipAddOptionData(opitonID, datas);
	return;
}

function API_GetExOptionData(int OptionID, int lv, out ExOptionData Data)
{
	Class'NWindow.UIDataManager'.static.GetExOptionData(OptionID, byte(lv), Data);
	return;
}

function API_GetCardSelectData(out CardSelectData Data)
{
	Class'NWindow.UIDataManager'.static.GetCardSelectData(1, Data);
	return;
}

function RQ_C_EX_ADENLAB_SPECIAL_PROB(int OptionID)
{
	local array<byte> stream;
	local UIPacket._C_EX_ADENLAB_SPECIAL_PROB packet;

	packet.nBossID = 1;
	packet.nSlotID = OptionID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_ADENLAB_SPECIAL_PROB(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(887, stream);
	return;
}

function RT_S_EX_ADENLAB_SPECIAL_PROB()
{
	local UIPacket._S_EX_ADENLAB_SPECIAL_PROB packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_ADENLAB_SPECIAL_PROB(packet))
	{
		return;
	}
	gradeProbs = packet.gradeProbs;
	ModifySpecialOptionProbs();
	return;
}

function RT_S_EX_ADENLAB_SPECIAL_SLOT()
{
	local UIPacket._S_EX_ADENLAB_SPECIAL_SLOT packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_ADENLAB_SPECIAL_SLOT(packet))
	{
		return;
	}
	if((packet.nBossID != 1))
	{
		return;
	}
	RQ_C_EX_ADENLAB_SPECIAL_PROB(packet.nSlotID);
	return;
}
