class LobbyMenuWnd extends L2UIGFxScript;

const FLASH_XPOS = 0;
const FLASH_YPOS = 0;
const DLG_ID_DELETE = 0;
const DLG_ID_RESTORE = 1;
const DLG_ID_DormantUserCoupon = 3;

var int currentScreenWidth;
var int currentScreenHeight;
var int selectedNum;
var int maxCharacterNum;
var bool isDeleting;
var bool isStarting;
var bool isPrologueGrowSelected;
var string m_Windowname;

function OnRegisterEvent()
{
	RegisterEvent(3021);
	RegisterEvent(3022);
	RegisterEvent(3023);
	RegisterEvent(3025);
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent(3026);
	RegisterEvent(3024);
	RegisterEvent(3410);
	RegisterEvent(3027);
	RegisterEvent(4120);
	RegisterGFxEvent(20240);
	return;
}

function OnLoad()
{
	m_Windowname = getCurrentWindowName(string(self));
	RegisterState(m_Windowname, "CHARACTERSELECTSTATE");
	SetContainerWindow("none", 0);
	SetAnchor("", ANCHORPOINT_BottomRight, ANCHORPOINT_TopLeft, 0, 0);
	maxCharacterNum = 0;
	return;
}

function OnShow()
{
	isStarting = false;
	SetFocus();
	return;
}

function int getLanguageNum()
{
	local UIEventManager.ELanguageType Language;

	Language = GetLanguage();
	return int(Language);
}

function OnCallUCFunction(string logicID, string param)
{
	local string btnName;
	local int Index;

	ParseString(param, "btnName", btnName);
	switch(btnName)
	{
		case "startBtn":
			if(!isDeleting)
			{
				OnClickStartButton();
			}
			break;
		case "prev":
			onClickPrevNext(false);
			break;
		case "next":
			onClickPrevNext(true);
			break;
		case "createBtn":
			CreateNewCharacter();
			break;
		case "deleteBtn":
			OnClickDeleteCharacter();
			break;
		case "loginBtn":
			if(((int(GetLanguage()) == 1) || (int(GetLanguage()) == 3)))
			{
				GotoServerList();
			}
			else
			{
				GotoLogin();
			}
			break;
		case "restoreBtn":
			if(!isDeleting)
			{
				ShowRestoreDialog(selectedNum);
			}
			break;
		case "isPrologueGrowSelected":
			isPrologueGrowSelected = bool(logicID);
			break;
		case "selectByIndex":
			ParseInt(param, "index", Index);
			onCharacterSelectChanged(Index);
			break;
		case "add":
			ParseInt(param, "index", Index);
			CreateNewCharacter();
			break;
		case "creditBtn":
			StartCredit();
			break;
		default:
			break;
	}
	return;
}

function OnClickDeleteCharacter()
{
	local string Msg;
	local UserInfo Info;

	if(isStarting)
	{
		return;
	}
	if((IsScheduledToDeleteCharacter(selectedNum) || IsDisciplineCharacter(selectedNum)))
	{
		return;
	}
	if(!GetSelectedCharacterInfo(selectedNum, Info))
	{
		return;
	}
	if((GetUIUserPremiumLevel() > 0))
	{
		Msg = MakeFullSystemMsg(GetSystemMessage(4076), Info.Name);
	}
	else if(IsActivateCharacter(selectedNum))
	{
		Msg = MakeFullSystemMsg(GetSystemMessage(4075), Info.Name);
	}
	else
	{
		Msg = MakeFullSystemMsg(GetSystemMessage(4076), Info.Name);
	}
	ShowDeleteDialog(selectedNum, Msg);
	return;
}

function ShowDeleteDialog(int Index, string Msg)
{
	Class'Interface.UICommonAPI'.static.DialogSetID(0);
	Class'Interface.UICommonAPI'.static.DialogSetReservedInt(Index);
	Class'Interface.UICommonAPI'.static.DialogShowWithTarget(DialogModalType_Modal, DialogType_OKCancel, Msg, m_Windowname);
	return;
}

function OnClickStartButton()
{
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("DialogBox"))
	{
		return;
	}
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("Credit"))
	{
		return;
	}
	if((IsScheduledToDeleteCharacter(selectedNum) || IsDisciplineCharacter(selectedNum)))
	{
		return;
	}
	isStarting = true;
	PlaySoundUntilEnd("InterfaceSound.game_start");
	StartGame(selectedNum);
	return;
}

function bool isLiveServer()
{
	local string Message;

	if(!getInstanceUIData().GetIsClassicServer())
	{
		return false;
	}
	ParamAdd(Message, "Message", GetSystemMessage(4304));
	switch(GetReleaseMode())
	{
		case RM_LIVE:
			ExecuteEvent(581, Message);
			return true;
			break;
		case RM_DEV:
			break;
		case RM_RC:
			break;
		case RM_TEST:
			break;
		default:
			break;
	}
	return false;
}

function OnEvent(int Event_ID, string a_Param)
{
	local UserInfo Info;
	local int i;

	switch(Event_ID)
	{
		case 3410:
			if((a_Param == "CHARACTERSELECTSTATE"))
			{
				if((IsShowWindow() == false))
				{
					ShowWindow();
					CallGFxFunction(m_Windowname, "1", "");
				}
			}
			else
			{
				CallGFxFunction(m_Windowname, "2", "");
				HideWindow();
			}
			break;
		case 3021:
			maxCharacterNum++;
			break;
		case 3022:
			SetFocus();
			CallGFxFunction(m_Windowname, "11", "");
			HandleCharacterSelect(a_Param);
			break;
		case 3023:
			CallGFxFunction(m_Windowname, "9", ("string=" $ GetSystemMessage(5060)));
			ResetCharacterSelectWindow();
			break;
		case 3025:
			HandleSetRestoreButton(a_Param);
			break;
		case 1710:
			HandleDialogResult(true);
			break;
		case 1720:
			HandleDialogResult(false);
			break;
		case 3026:
			SetSelectedCharacter(selectedNum);
			break;
		case 3024:
			if(!isDeleting)
			{
				OnClickStartButton();
			}
			break;
		case 3027:
			isDeleting = false;
			i = 0;
			while((i < 7))
			{
				setParamsCharacterInfo(i, "disable");
				i++;
			}
			i = 0;
			while((i < maxCharacterNum))
			{
				if(GetSelectedCharacterInfo(i, Info))
				{
					setParamsCharacterInfo(i, "normal");
				}
				i++;
			}
			setParamsCharacterInfo(maxCharacterNum, "add");
			break;
		case 4120:
			HandleVitalityEffectInfoParam(a_Param);
			break;
		default:
			break;
	}
	return;
}

function HandleVitalityEffectInfoParam(string a_Param)
{
	local int nVitalityBonus, nVitalityItemRestoreCount;
	local string VitalityMessage1, VitalityMessage2, Result;

	ParseInt(a_Param, "vitalityBonus", nVitalityBonus);
	ParseInt(a_Param, "vitalItemCount", nVitalityItemRestoreCount);
	VitalityMessage1 = MakeFullSystemMsg(GetSystemMessage(6072), (string(nVitalityBonus) $ "%"));
	VitalityMessage2 = MakeFullSystemMsg(GetSystemMessage(6073), string(nVitalityItemRestoreCount));
	Result = (Result $ setParamString("vitalityBonus", string(nVitalityBonus)));
	Result = (Result @ setParamString("vitalItemCount", string(nVitalityItemRestoreCount)));
	Result = (Result @ setParamString("VitalityMessage1", VitalityMessage1));
	Result = (Result @ setParamString("VitalityMessage2", VitalityMessage2));
	CallGFxFunction(m_Windowname, "10", Result);
	return;
}

function string setParamString(string paramName, string vars)
{
	local string Result;

	Result = ((paramName $ "=") $ vars);
	return Result;
}

function string setParamInt(string paramName, int vars)
{
	local string Result;

	Result = ((paramName $ "=") $ string(vars));
	return Result;
}

function string setParamInt64(string paramName, INT64 vars)
{
	local string Result;

	Result = ((paramName $ "=") $ string(vars));
	return Result;
}

function setParams(int Index)
{
	local UserInfo Info;
	local int toDeleteChar, IsDisciplineChar;
	local string Result;
	local int disciplineCharacter;
	local string lastConnectTime;
	local int nTimeToLastLogoutCharacter, deleteRemainSec;

	if(GetSelectedCharacterInfo(Index, Info))
	{
		nTimeToLastLogoutCharacter = GetTimeToLastLogoutCharacter(Index);
		if((nTimeToLastLogoutCharacter > 0))
		{
			lastConnectTime = BR_ConvertTimeToStr(GetTimeToLastLogoutCharacter(Index), 0);
		}
		deleteRemainSec = GetTimeToDeleteCharacter(Index);
		if(IsScheduledToDeleteCharacter(Index))
		{
			toDeleteChar = 1;
		}
		else
		{
			toDeleteChar = 0;
		}
		if(IsDisciplineCharacter(Index))
		{
			IsDisciplineChar = 1;
		}
		else
		{
			IsDisciplineChar = 0;
		}
		Result = (Result $ setParamInt("toDeleteChar", toDeleteChar));
		Result = (Result @ setParamInt("IsDisciplineChar", IsDisciplineChar));
		Result = (Result @ setParamInt("index", Index));
		Result = (Result @ setParamString("Name", Info.Name));
		Result = (Result @ setParamInt("LV", Info.nLevel));
		Result = (Result @ setParamString("SC", GetClassType(Info.nSubClass)));
		Result = (Result @ setParamInt64("SP", Info.nSP));
		Result = (Result @ setParamInt("CR", Info.nCriminalRate));
		Result = (Result @ setParamInt64("HP", Info.nCurHP));
		Result = (Result @ setParamInt64("maxHP", Info.nMaxHP));
		Result = (Result @ setParamInt("MP", Info.nCurMP));
		Result = (Result @ setParamInt("maxMP", Info.nMaxMP));
		Result = (Result @ setParamString("EXP", string((Info.fExpPercentRate * 1000000.0000000))));
		Result = (Result @ setParamInt("VP", Info.nVitality));
		Result = (Result @ setParamInt("maxVP", GetMaxVitality()));
		Result = (Result @ setParamInt("classID", Info.nSubClass));
		Result = (Result @ setParamString("characterImage", getCharacterImg(Info.Race, Info.nSubClass, Info.nSex)));
		Result = (Result @ setParamInt("disciplineCharacter", disciplineCharacter));
		Result = (Result @ setParamInt("deleteRemainSec", deleteRemainSec));
		Result = (Result @ setParamString("lastConnectTime", lastConnectTime));
		Debug(("캐릭터 이미지 : " @ getCharacterImg(Info.Race, Info.nSubClass, Info.nSex)));  // EN?: Character Image:
		CallGFxFunction(m_Windowname, "8", Result);
		HandleVitalityEffectInfo(Info.nVitalBonus, Info.nVitalItem);
	}
	return;
}

function setParamsCharacterInfo(int Index, string selectButtonState)
{
	local UserInfo Info;
	local int toDeleteChar, IsDisciplineChar, disciplineCharacter;
	local string lastConnectTime;
	local int nTimeToLastLogoutCharacter, deleteRemainSec;
	local string Result;

	if(((selectButtonState == "disable") || (selectButtonState == "add")))
	{
		Result = (Result @ setParamInt("test", 0));
		Result = (Result @ setParamString("SelectButtonState", selectButtonState));
		Result = (Result @ setParamInt("index", Index));
		CallGFxFunction(m_Windowname, "15", Result);
	}
	else if(GetSelectedCharacterInfo(Index, Info))
	{
		if(IsScheduledToDeleteCharacter(Index))
		{
			toDeleteChar = 1;
		}
		else
		{
			toDeleteChar = 0;
		}
		if(IsDisciplineCharacter(Index))
		{
			IsDisciplineChar = 1;
		}
		else
		{
			IsDisciplineChar = 0;
		}
		disciplineCharacter = GetTimeToDisciplineCharacter(Index);
		nTimeToLastLogoutCharacter = GetTimeToLastLogoutCharacter(Index);
		if((nTimeToLastLogoutCharacter > 0))
		{
			lastConnectTime = BR_ConvertTimeToStr(GetTimeToLastLogoutCharacter(Index), 0);
		}
		deleteRemainSec = GetTimeToDeleteCharacter(Index);
		Result = (Result $ setParamInt("toDeleteChar", toDeleteChar));
		Result = (Result @ setParamInt("IsDisciplineChar", IsDisciplineChar));
		Result = (Result @ setParamInt("index", Index));
		Result = (Result @ setParamString("Name", Info.Name));
		Result = (Result @ setParamInt("LV", Info.nLevel));
		Result = (Result @ setParamString("SC", GetClassType(Info.nSubClass)));
		Result = (Result @ setParamInt64("SP", Info.nSP));
		Result = (Result @ setParamInt("CR", Info.nCriminalRate));
		Result = (Result @ setParamInt64("HP", Info.nCurHP));
		Result = (Result @ setParamInt64("maxHP", Info.nMaxHP));
		Result = (Result @ setParamInt("MP", Info.nCurMP));
		Result = (Result @ setParamInt("maxMP", Info.nMaxMP));
		Result = (Result @ setParamString("EXP", string((Info.fExpPercentRate * 1000000.0000000))));
		Result = (Result @ setParamInt("VP", Info.nVitality));
		Result = (Result @ setParamInt("maxVP", GetMaxVitality()));
		Result = (Result @ setParamInt("classID", Info.nSubClass));
		Result = (Result @ setParamString("characterImage", getCharacterImg(Info.Race, Info.nSubClass, Info.nSex)));
		Result = (Result @ setParamString("SelectButtonState", selectButtonState));
		Result = (Result @ setParamInt("disciplineCharacter", disciplineCharacter));
		Result = (Result @ setParamString("lastConnectTime", lastConnectTime));
		Result = (Result @ setParamInt("deleteRemainSec", deleteRemainSec));
		CallGFxFunction(m_Windowname, "15", Result);
	}
	return;
}

function HandleVitalityEffectInfo(int nVitalBonus, int nVitalItem)
{
	local string VitalityMessage1, VitalityMessage2, Result;

	VitalityMessage1 = GetSystemString(2495);
	VitalityMessage1 = (VitalityMessage1 $ ",");
	VitalityMessage2 = MakeFullSystemMsg(GetSystemMessage(6073), string(nVitalItem));
	Result = (Result $ setParamString("VitalityMessage1", VitalityMessage1));
	Result = (Result @ setParamString("VitalityMessage2", VitalityMessage2));
	CallGFxFunction(m_Windowname, "10", Result);
	return;
}

function HandleCharacterSelect(string param)
{
	local int Index;

	ParseInt(param, "index", Index);
	if((Index == -1))
	{
		return;
	}
	onCharacterSelectChanged(Index);
	return;
}

function bool checkSelectEnable()
{
	if(!IsDisciplineCharacter(selectedNum))
	{
		return true;
	}
	return false;
}

function int setEnableSelectedNum()
{
	if((selectedNum < 0))
	{
		selectedNum = (maxCharacterNum - 1);
	}
	else if((selectedNum >= maxCharacterNum))
	{
		selectedNum = 0;
	}
	return selectedNum;
}

function onClickPrevNext(bool isNext)
{
	local int Id;

	if((maxCharacterNum > 1))
	{
		if(isNext)
		{
			selectedNum++;
			Id = 7;
		}
		else
		{
			selectedNum--;
			Id = 6;
		}
		setEnableSelectedNum();
		RequestCharacterSelect(selectedNum);
		CallGFxFunction(m_Windowname, string(Id), ("string=" $ string(selectedNum)));
		setParams(selectedNum);
	}
	return;
}

function onCharacterSelectChanged(int Index)
{
	local UserInfo Info;
	local int toDeleteChar, disciplineCharacter;
	local string lastConnectTime;
	local int nTimeToLastLogoutCharacter, deleteRemainSec;

	RequestCharacterSelect(Index);
	if(GetSelectedCharacterInfo(Index, Info))
	{
		if(IsScheduledToDeleteCharacter(Index))
		{
			toDeleteChar = 1;
		}
		else
		{
			toDeleteChar = 0;
		}
	}
	if((selectedNum != Index))
	{
		nTimeToLastLogoutCharacter = GetTimeToLastLogoutCharacter(Index);
		if((nTimeToLastLogoutCharacter > 0))
		{
			lastConnectTime = BR_ConvertTimeToStr(GetTimeToLastLogoutCharacter(Index), 0);
		}
		deleteRemainSec = GetTimeToDeleteCharacter(Index);
		if((selectedNum > Index))
		{
			CallGFxFunction(m_Windowname, "6", ((((((((("string=" $ string(Index)) @ "toDeleteChar=") $ string(toDeleteChar)) @ "disciplineCharacter=") $ string(disciplineCharacter)) @ "deleteRemainSec=") $ string(deleteRemainSec)) @ "lastConnectTime=") $ lastConnectTime));
		}
		else
		{
			CallGFxFunction(m_Windowname, "7", ((((((((("string=" $ string(Index)) @ "toDeleteChar=") $ string(toDeleteChar)) @ "disciplineCharacter=") $ string(disciplineCharacter)) @ "deleteRemainSec=") $ string(deleteRemainSec)) @ "lastConnectTime=") $ lastConnectTime));
		}
		selectedNum = Index;
	}
	else
	{
		Debug("onCharacterSelectChanged  selectedNum == index");
	}
	setParams(Index);
	return;
}

function HandleSetRestoreButton(string param)
{
	local string Type;

	ParseString(param, "Type", Type);
	CallGFxFunction(m_Windowname, "5", ("string=" $ Type));
	return;
}

function HandleShowDialog(string param)
{
	local string Type;
	local int SelectedCharacter;

	ParseString(param, "Type", Type);
	switch(Type)
	{
		case "restore":
			ParseInt(param, "SelectedCharacter", SelectedCharacter);
			ShowRestoreDialog(SelectedCharacter);
			break;
		default:
			break;
	}
	return;
}

function ShowRestoreDialog(int SelectedCharacter)
{
	Class'Interface.UICommonAPI'.static.DialogSetID(1);
	Class'Interface.UICommonAPI'.static.DialogSetReservedInt(SelectedCharacter);
	Class'Interface.UICommonAPI'.static.DialogShowWithTarget(DialogModalType_Modal, DialogType_OKCancel, GetSystemMessage(1555), m_Windowname);
	return;
}

function HandleDialogResult(bool bOK)
{
	local int DlgID, Reserved;

	if(!DialogIsMineWithTarget(m_Windowname))
	{
		return;
	}
	DlgID = Class'Interface.UICommonAPI'.static.DialogGetID();
	Reserved = Class'Interface.UICommonAPI'.static.DialogGetReservedInt();
	switch(DlgID)
	{
		case 1:
			HandleDialogRestore(bOK, Reserved);
			break;
		case 0:
			HandleDialogDelete(bOK, Reserved);
			break;
		case 3:
			HandleDormantUserCoupon(bOK);
			break;
		default:
			break;
	}
	return;
}

function HandleDormantUserCoupon(bool bOK)
{
	if(bOK)
	{
		OpenGivenURL(GetSystemString(3119));
		GotoLogin();
	}
	return;
}

function HandleDialogRestore(bool bOK, int SelectedCharacter)
{
	if(bOK)
	{
		RequestRestoreCharacter(SelectedCharacter);
	}
	RequestCharacterSelect(SelectedCharacter);
	return;
}

function HandleDialogDelete(bool bOK, int SelectedCharacter)
{
	if(bOK)
	{
		isDeleting = true;
		RequestDeleteCharacter(SelectedCharacter);
	}
	return;
}

function ResetCharacterSelectWindow()
{
	selectedNum = -1;
	CallGFxFunction(m_Windowname, "6", "string=-1");
	maxCharacterNum = 0;
	return;
}

function string getCharacterImg(int nRace, int nClassID, int nSex)
{
	local string sexStr, playerType;

	playerType = L2Util(GetScript("L2Util")).GetPlayerType(nClassID, nRace);
	if((nSex == 0))
	{
		sexStr = "M";
	}
	else
	{
		sexStr = "W";
	}
	if((nRace == 6))
	{
		sexStr = "W";
	}
	return ((((getInstanceL2Util().GetRaceString(nRace) $ "_") $ playerType) $ "_") $ sexStr);
}

function bool numToBool(int bNum)
{
	if((bNum > 0))
	{
		return true;
	}
	else
	{
		return false;
	}
}

function int boolToNum(bool Num)
{
	if(Num)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}
