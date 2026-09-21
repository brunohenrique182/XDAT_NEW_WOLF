class UIPortraitSetter extends UICommonAPI;

enum PortraitType
{
	character,                      // 0
	UserInfo                        // 1
};

var EditBoxHandle NCEditBox0;
var CharacterViewportWindowHandle characterViewport;
var PortraitType currentType;

event OnLoad()
{
	SetClosingOnESC();
	NCEditBox0 = GetEditBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NCEditBox0"));
	characterViewport = GetCharacterViewportWindowHandle("QuestDialogWnd.viewport");
	return;
}

event OnClickButton(string strBtn)
{
	Debug(("strBtn :" @ strBtn));
	if((int(currentType) == 1))
	{
		return;
	}
	switch(strBtn)
	{
		case "spawn":
			characterViewport.SetNPCInfo(int(NCEditBox0.GetString()));
			characterViewport.SpawnNPC();
			break;
		case "ResetBtn":
			Reset();
			break;
		default:
			break;
	}
	return;
}

event OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
	local float fTick;

	Debug((("OnModifyCurrentTickSliderCtrl" @ strID) @ string(iCurrentTick)));
	switch(strID)
	{
		case "SliderCtrlScale":
			fTick = (float(iCurrentTick) / 100.0000000);
			if((fTick == 0.0000000))
			{
				fTick = 0.0100000;
			}
			SetFValueString(strID, fTick);
			characterViewport.SetCharacterScale(fTick);
			characterViewport.SetNPCInfo(int(NCEditBox0.GetString()));
			characterViewport.SpawnNPC();
			break;
		case "SliderCtrlCameraDistance":
			characterViewport.SetCameraDistance(iCurrentTick);
			SetValueString(strID, iCurrentTick);
			break;
		case "SliderCtrlYaw":
			characterViewport.SetCurrentRotation(iCurrentTick);
			SetValueString(strID, iCurrentTick);
			break;
		case "SliderCtrlPitch":
			characterViewport.SetCameraPitch(iCurrentTick);
			SetValueString(strID, iCurrentTick);
			break;
		case "SliderCtrlOffSetX":
			iCurrentTick = (iCurrentTick - 50);
			characterViewport.SetCharacterOffsetX(iCurrentTick);
			SetValueString(strID, iCurrentTick);
			break;
		case "SliderCtrlOffSetY":
			iCurrentTick = (iCurrentTick - 50);
			characterViewport.SetCharacterOffsetY(iCurrentTick);
			SetValueString(strID, iCurrentTick);
			break;
		case "SliderCtrlOffSetZ":
			iCurrentTick = (iCurrentTick - 50);
			characterViewport.SetCharacterOffsetZ(iCurrentTick);
			SetValueString(strID, iCurrentTick);
			break;
		default:
			break;
	}
	return;
}

event OnCompleteEditBox(string strID)
{
	local SliderCtrlHandle slider;
	local int Value;

	switch(strID)
	{
		case "NCEditBox0":
			OnClickButton("spawn");
			return;
		case "txtICurTickOffSetX":
		case "txtICurTickOffSetY":
		case "txtICurTickOffSetZ":
			Value = (int(GetEditBoxHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ strID)).GetString()) + 50);
			break;
		case "txtIcurTickScale":
			Value = int((float(GetEditBoxHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ strID)).GetString()) * 100.0000000));
			break;
		default:
			Value = int(GetEditBoxHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ strID)).GetString());
			break;
	}
	slider = GetSliderCtrlHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SliderCtrl") $ Right(strID, (Len(strID) - 11))));
	slider.SetCurrentTick(Value);
	return;
}

event OnShow()
{
	if(IsBuilderPC())
	{
		return;
	}
	if((int(GetReleaseMode()) == 0))
	{
		return;
	}
	m_hOwnerWnd.HideWindow();
	return;
}

function _SetCurrentQuestInfo()
{
	local NQuestUIData questUIData;

	if(API_GetNQuestData(QuestDialogWnd(GetScript("QuestDialogWnd"))._currentQuestID, questUIData))
	{
		_SetCurrentUserInfo(GetCharacterViewportWindowHandle("QuestDialogWnd.viewport"));
		SetPortrait(questUIData);
		m_hOwnerWnd.ShowWindow();
		SetPortraitType(character);
	}
	return;
}

function _SetCurrentUserInfo(CharacterViewportWindowHandle vp)
{
	if((characterViewport == vp))
	{
		return;
	}
	characterViewport = vp;
	m_hOwnerWnd.ShowWindow();
	SetPortraitType(UserInfo);
	return;
}

function SetPortraitType(optional PortraitType Type)
{
	currentType = Type;
	getInstanceL2Util().showGfxScreenMessage("캐럭터 편집 대상 변경");  // EN?: Change Carrer Editing Destination
	return;
}

function SetPortrait(NQuestUIData questUIData)
{
	local NQuestNpcPortraitUIData questNpcPortraitUIData;
	local int questPortraitID;
	local QuestDialogWnd questDialogWndScr;

	questDialogWndScr = QuestDialogWnd(GetScript("QuestDialogWnd"));
	switch(questDialogWndScr._currentDialogType)
	{
		case 1:
		case 2:
			questPortraitID = questUIData.StartNPC.Id;
			break;
		case 3:
		case 4:
			questPortraitID = questUIData.EndNPC.Id;
			break;
		default:
			return;
	}
	API_GetNQuestNpcPortraitData(questPortraitID, questNpcPortraitUIData);
	NCEditBox0.SetString(string(questPortraitID));
	SetFValue("scale", questNpcPortraitUIData.ViewScale);
	SetFValue("Yaw", float(questNpcPortraitUIData.ViewRotationYaw));
	SetFValue("Pitch", float(questNpcPortraitUIData.ViewRotationYaw));
	SetFValue("CameraDistance", float(questNpcPortraitUIData.ViewDist));
	SetFValue("OffsetX", float(questNpcPortraitUIData.ViewOffsetX));
	SetFValue("OffsetY", float(questNpcPortraitUIData.ViewOffsetY));
	SetFValue("OffsetZ", float(questNpcPortraitUIData.ViewOffsetZ));
	characterViewport.SetNPCInfo(questPortraitID);
	characterViewport.SpawnNPC();
	SetAllCurTick();
	return;
}

function bool API_GetNQuestNpcPortraitData(int a_NpcID, out NQuestNpcPortraitUIData o_data)
{
	return GetNQuestNpcPortraitData((1000000 + a_NpcID), o_data);
}

function bool API_GetNQuestData(int a_QuestID, out NQuestUIData o_data)
{
	return GetNQuestData(a_QuestID, o_data);
}

function Reset()
{
	_SetCurrentQuestInfo();
	SetAllCurTick();
	return;
}

function SetAllCurTick()
{
	OnCompleteEditBox("txtICurTickScale");
	OnCompleteEditBox("txtICurTickCameraDistance");
	OnCompleteEditBox("txtICurTickYaw");
	OnCompleteEditBox("txtICurTickPitch");
	OnCompleteEditBox("txtICurTickOffSetX");
	OnCompleteEditBox("txtICurTickOffSetY");
	OnCompleteEditBox("txtICurTickOffSetZ");
	OnCompleteEditBox("txtICurTickOffSetX");
	OnCompleteEditBox("txtICurTickTimer");
	return;
}

function SetValueString(string strID, int Value)
{
	SetValue(Right(strID, (Len(strID) - 10)), Value);
	return;
}

function SetValue(string typeString, int Value)
{
	GetEditBoxHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtICurTick") $ typeString)).SetString(string(Value));
	return;
}

function SetFValueString(string strID, float Value)
{
	SetFValue(Right(strID, (Len(strID) - 10)), Value);
	return;
}

function SetFValue(string typeString, float Value)
{
	GetEditBoxHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtICurTick") $ typeString)).SetString(string(Value));
	return;
}

function string GetValueString(string strID)
{
	return GetEditBoxHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtICurTick") $ Right(strID, (Len(strID) - 10)))).GetString();
}

function string GetEditorString(string typeString)
{
	return GetEditBoxHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".txtICurTick") $ typeString)).GetString();
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hOwnerWnd.HideWindow();
	return;
}
