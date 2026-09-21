class CharacterCreateMenuWnd extends L2UIGFxScript;

const JOBID_WARRIOR = 0;
const JOBID_MAGE = 1;
const JOBID_SHINEMAKER = 1;
const JOBID_DEATHKNIGHT = 2;
const JOBID_DEATHFIGHTER = 2;
const JOBID_ORCRIDER = 2;
const JOBID_ASSASIN = 3;
const JOBID_WEREWOLF = 4;
const JOBID_ROSEVAIN = 5;
const RACEID_HUMAN = 0;
const RACEID_ELF = 1;
const RACEID_DARKELF = 2;
const RACEID_ORC = 3;
const RACEID_DWARF = 4;
const RACEID_KAMAEL = 5;
const RACEID_ERTHEIA = 6;
const RACEID_SYLPH = 30;
const RACEID_HIGH_ELF = 31;
const DLG_ID_CREATE = 3300;

var string m_Windowname;
var L2Util util;
var bool m_bZoomed;
var int Race;
var int Job;
var int gender;
var int HairType;
var int HairColor;
var int FaceType;
var string Name;
var bool IsCreate;
var CharacterCreateEditbox characterCreateEditboxScript;
var int characterID;
var int initClassID;

function int GetFaceTypeMaxNum()
{
	if(IsWereWolf(Job))
	{
		return 3;
	}
	if(IsDeathKnight(Race, Job))
	{
		return 1;
	}
	if(IsAssassin(Job))
	{
		return 1;
	}
	if(IsRoseVain(Job))
	{
		return 2;
	}
	if((IsAdenServer() && (IsHumanMage(Race, Job) || IsElf(Race))))
	{
		return 5;
	}
	if((Race == 31))
	{
		if((gender == 0))
		{
			return 1;
		}
		else
		{
			return 3;
		}
	}
	return 3;
}

function int GetHairColorMaxNum()
{
	if(IsWereWolf(Job))
	{
		return 3;
	}
	if(IsDeathKnight(Race, Job))
	{
		if(getInstanceUIData().GetIsLiveServer())
		{
			return 3;
		}
		else
		{
			return 1;
		}
	}
	if(IsAssassin(Job))
	{
		return 1;
	}
	if(IsRoseVain(Job))
	{
		return 3;
	}
	if(IsShineMaker(Race, Job))
	{
		return 3;
	}
	switch(Race)
	{
		case 5:
		case 6:
		case 30:
			return 3;
		case 31:
			if((gender == 0))
			{
				return 1;
			}
			else
			{
				return 3;
			}
		default:
			return 4;
	}
}

function int GetHairTypeMaxNum()
{
	if(IsWereWolf(Job))
	{
		return 3;
	}
	if(IsDeathKnight(Race, Job))
	{
		return 1;
	}
	if(IsRoseVain(Job))
	{
		return 2;
	}
	if(IsAdenServer())
	{
		if(IsHumanMage(Race, Job))
		{
			if((gender == 0))
			{
				return 9;
			}
			else
			{
				return 12;
			}
		}
		else if(IsElf(Race))
		{
			if((gender == 0))
			{
				return 8;
			}
			else
			{
				return 10;
			}
		}
	}
	if(IsAssassin(Job))
	{
		return 1;
	}
	if(IsShineMaker(Race, Job))
	{
		return 3;
	}
	switch(Race)
	{
		case 6:
			return 7;
		case 31:
			if((gender == 0))
			{
				return 1;
			}
			else
			{
				return 3;
			}
			break;
		default:
			break;
	}
	if((gender == 1))
	{
		return 7;
	}
	return 5;
}

function ResetStyle()
{
	HairType = 0;
	HairColor = 0;
	FaceType = 0;
	if(((Race == 5) && getInstanceUIData().GetIsClassicServer()))
	{
		FaceType = 1;
	}
	HandleSetCharacterStyle();
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(3210);
	RegisterEvent(5618);
	RegisterEvent(3410);
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent(581);
	RegisterGFxEvent(11630);
	RegisterGFxEvent(11631);
	return;
}

event OnLoad()
{
	m_Windowname = getCurrentWindowName(string(self));
	SetContainerHUD("none", 0);
	AddState("CHARACTERCREATESTATE");
	SetAlwaysOnTop(true);
	HasTextField(true);
	SetAnchor("", ANCHORPOINT_BottomRight, ANCHORPOINT_TopLeft, 0, 0);
	util = L2Util(GetScript("L2Util"));
	characterCreateEditboxScript = CharacterCreateEditbox(GetScript("CharacterCreateEditbox"));
	return;
}

event OnHide()
{
	UnsetRotateCursor();
	CallGFxFunction(m_Windowname, "EXIT", "0");
	return;
}

event OnEvent(int Event_ID, string param)
{
	if((Event_ID == 3410))
	{
		if((param == "CHARACTERCREATESTATE"))
		{
			Race = -1;
			CallGFxFunction(m_Windowname, "ENTER", "0");
		}
		else
		{
			CallGFxFunction(m_Windowname, "EXIT", "0");
		}
	}
	else if((Event_ID == 5618))
	{
		if((GetGameStateName() == "CHARACTERCREATESTATE"))
		{
			HandlecharacterNameCreatable(param);
		}
	}
	else if((Event_ID == 1710))
	{
		HandleDialogResult(true);
	}
	else if((Event_ID == 1720))
	{
		HandleDialogResult(false);
	}
	else if((Event_ID == 581))
	{
		HandleShowMessage(param);
	}
	return;
}

event OnCallUCFunction(string logicID, string param)
{
	local string btnName, TargetName;

	ParseString(param, "btnName", btnName);
	if(isChinaVer())
	{
		GetWindowHandle("CharacterCreateEditbox").ClearAnchor();
		GetWindowHandle("CharacterCreateEditbox").SetAnchor("", "BottomCenter", "TopLeft", -125, -73);
		characterCreateEditboxScript.setFocusTarget();
	}
	switch(btnName)
	{
		case "exit":
			if(IsShowWindow(m_Windowname))
			{
				RequestPrevState();
			}
			break;
		case "confirm":
			IsCreate = false;
			ParseString(param, "Name", Name);
			if(isChinaVer())
			{
				Name = characterCreateEditboxScript.getCharacterNameTextFieldValue();
			}
			handleNameConfirm();
			break;
		case "left":
			handleTurnLeft(int(logicID));
			break;
		case "right":
			handleTurnRight(int(logicID));
			break;
		case "zoom":
			if((logicID == "1"))
			{
				zoomIn();
			}
			else
			{
				zoomOut();
			}
			break;
		case "race":
			SetCharacterChange(int(logicID), Job, gender);
			break;
		case "gender":
			SetCharacterChange(Race, Job, int(logicID));
			break;
		case "job":
			SetCharacterChange(Race, int(logicID), gender);
			break;
		case "faceType":
			FaceType = int(logicID);
			HandleSetCharacterStyle();
			break;
		case "hairType":
			HairType = int(logicID);
			HandleSetCharacterStyle();
			break;
		case "hairColor":
			HairColor = int(logicID);
			HandleSetCharacterStyle();
			break;
		case "create":
			IsCreate = true;
			ParseString(param, "Name", Name);
			if(isChinaVer())
			{
				Name = characterCreateEditboxScript.getCharacterNameTextFieldValue();
			}
			handleNameConfirm();
			break;
		case "class":
			ParseString(param, "targetName", TargetName);
			ClassDescription(int(logicID), TargetName);
			break;
		case "dragPoint":
			HandleDragCharacter(float(logicID), param);
			break;
		case "ID":
			characterID = int(logicID);
			break;
		case "setRandom":
			SetRandom(logicID);
			break;
		case "classID":
			initClassID = int(logicID);
			Debug((("OnCallGfxFunc" @ logicID) @ param));
			break;
		case "xmlEditBoxFocus":
			characterCreateEditboxScript.setFocusTarget();
			break;
		default:
			break;
	}
	return;
}

function SetRandom(string param)
{
	local int nextRace, nextGender, nextJob;

	Debug(("setRandom" @ param));
	ParseInt(param, "randRace", nextRace);
	ParseInt(param, "randGender", nextGender);
	ParseInt(param, "randJob", nextJob);
	SetCharacterChange(nextRace, nextJob, nextGender);
	return;
}

function SetCharacterChange(int nextRace, int nextJob, int nextGender)
{
	if((Race != nextRace))
	{
		switch(nextRace)
		{
			case 0:
				if((IsClassicOriginServer() == true))
				{
					break;
				}
				nextGender = 0;
				nextJob = 4;
				break;
			case 2:
				if((IsAdenServer() == false))
				{
					break;
				}
				nextGender = 1;
				nextJob = 5;
				break;
			default:
				break;
		}
	}
	nextJob = GetCanSelectJob(nextRace, nextGender, nextJob);
	SetSceneChange(nextRace, nextJob, nextGender);
	SetGFxUIStep1();
	SetGFxUIStep2();
	return;
}

function SetSceneChange(int nextRace, int nextJob, int nextGender)
{
	local bool bSceneChange;

	bSceneChange = IsSceneChange(nextRace, nextJob);
	ShowDefaultCharacter(characterID, bSceneChange);
	if(bSceneChange)
	{
		m_bZoomed = false;
		FadeInOut(nextRace, nextJob);
		CallGFxFunction(m_Windowname, "SCENE_CHANGED", "");
	}
	Race = nextRace;
	Job = nextJob;
	gender = nextGender;
	return;
}

function string SetGFxUIStep1()
{
	local string Result;
	local array<int> initialStat;

	initialStat = GetClassInitialStat(initClassID);
	ParamAdd(Result, "STR", string(initialStat[0]));
	ParamAdd(Result, "DEX", string(initialStat[1]));
	ParamAdd(Result, "CON", string(initialStat[2]));
	ParamAdd(Result, "INT", string(initialStat[3]));
	ParamAdd(Result, "WIT", string(initialStat[4]));
	ParamAdd(Result, "MEN", string(initialStat[5]));
	ParamAdd(Result, "LUC", string(initialStat[6]));
	ParamAdd(Result, "CHA", string(initialStat[7]));
	ParamAdd(Result, "race", string(Race));
	ParamAdd(Result, "gender", string(gender));
	ParamAdd(Result, "job", string(Job));
	ParamAdd(Result, "max_faceType", string(GetFaceTypeMaxNum()));
	ParamAdd(Result, "max_hairType", string(GetHairTypeMaxNum()));
	ParamAdd(Result, "max_hairColor", string(GetHairColorMaxNum()));
	CallGFxFunction(m_Windowname, "STEP_CHANGED_1", Result);
	return Result;
}

function SetGFxUIStep2()
{
	local string Result;

	Result = "";
	ResetStyle();
	ParamAdd(Result, "faceType", string(FaceType));
	ParamAdd(Result, "hairType", string(HairType));
	ParamAdd(Result, "hairColor", string(HairColor));
	CallGFxFunction(m_Windowname, "STEP_CHANGED_2", Result);
	return;
}

function HandleSetCharacterStyle()
{
	if((IsDeathKnight(Race, Job) && getInstanceUIData().GetIsLiveServer()))
	{
		SetCharacterColor(E_CHARACTER_COLOR((GetHairColor() + 1)));
	}
	else
	{
		SetCharacterStyle(characterID, HairType, GetHairColor(), FaceType);
	}
	return;
}

function bool IsSceneChange(int nextRace, int nextJob)
{
	if((Race != nextRace))
	{
		return true;
	}
	if((nextJob == Job))
	{
		return false;
	}
	if((IsClassicOriginServer() == true))
	{
		return false;
	}
	if((IsRoseVain(Job) || IsRoseVain(nextJob)))
	{
		return true;
	}
	if((IsWereWolf(Job) || IsWereWolf(nextJob)))
	{
		return true;
	}
	if((IsClassicServer() == false))
	{
		return false;
	}
	if((IsDeathKnight(Race, Job) || IsDeathKnight(nextRace, nextJob)))
	{
		return true;
	}
	if((IsAdenServer() == false))
	{
		return false;
	}
	if((IsOrcRider(Race, Job) || IsOrcRider(nextRace, nextJob)))
	{
		return true;
	}
	if((IsAssassin(Job) || IsAssassin(nextJob)))
	{
		return true;
	}
	return false;
}

function ClassDescription(int ClassID, string TargetName)
{
	local string Result;

	Result = "";
	ParamAdd(Result, "classID", string(ClassID));
	ParamAdd(Result, "classType", GetClassType(ClassID));
	ParamAdd(Result, "desc", GetClassDescription(ClassID));
	ParamAdd(Result, "targetName", TargetName);
	CallGFxFunction(m_Windowname, "NAME_CHECK_RESULT", Result);
	return;
}

function string GetSceneName(int tmpRace, int tmpJob)
{
	if((tmpRace == -1))
	{
		return "";
	}
	if(IsRoseVain(tmpJob))
	{
		return "RoseVain_";
	}
	if(IsOrcRider(tmpRace, tmpJob))
	{
		return "OrcRider_";
	}
	if(IsAssassin(tmpJob))
	{
		return "Assassin_";
	}
	if(IsWereWolf(tmpJob))
	{
		return "WereWolf_";
	}
	if((!getInstanceUIData().GetIsLiveServer() && IsDeathKnight(tmpRace, tmpJob)))
	{
		return (GetRaceString(tmpRace) $ "_DK_");
	}
	return (GetRaceString(tmpRace) $ "_");
}

function FadeInOut(int nextRace, int nextJob)
{
	if((Race == -1))
	{
		ExecLobbyEvent((GetSceneName(nextRace, nextJob) $ "FadeIn"));
	}
	else
	{
		ExecLobbyEvent((GetSceneName(Race, Job) $ "FadeOut"));
		ExecLobbyNextEvent((GetSceneName(Race, Job) $ "FadeOut"), (GetSceneName(nextRace, nextJob) $ "FadeIn"));
	}
	return;
}

function HandleDragCharacter(float Speed, string param)
{
	if((Job == 5))
	{
		return;
	}
	if((Speed == 0.0000000))
	{
		return;
	}
	Speed = (Speed * 400.0000000);
	if((Speed > 0.0000000))
	{
		Speed = float(Min(int(Speed), 10000));
	}
	else
	{
		Speed = float(Max(int(Speed), -10000));
	}
	DefaultCharacterMouseTurn(characterID, Speed);
	return;
}

function handleTurnLeft(int logicID)
{
	if((logicID == 3))
	{
		DefaultCharacterTurn(characterID, 6.0000000);
	}
	else
	{
		DefaultCharacterStop(characterID);
	}
	return;
}

function handleTurnRight(int logicID)
{
	if((logicID == 3))
	{
		DefaultCharacterTurn(characterID, -6.0000000);
	}
	else
	{
		DefaultCharacterStop(characterID);
	}
	return;
}

function zoomIn()
{
	ExecLobbyEvent((GetSceneName(Race, Job) $ "ZoomIn"));
	m_bZoomed = true;
	return;
}

function zoomOut()
{
	ExecLobbyEvent((GetSceneName(Race, Job) $ "ZoomOut"));
	m_bZoomed = false;
	return;
}

function int GetCanSelectJob(int nextRace, int nextGender, int nextJob)
{
	switch(nextJob)
	{
		case 2:
		case 2:
		case 2:
			if(((CanSelectRaceOrcRider(nextRace, nextGender) == false) && (CanSelectRaceDk(nextRace, nextGender) == false)))
			{
				return 0;
			}
			else
			{
				break;
			}
		case 3:
			if((CanSelectJobAssassin(nextRace, nextGender) == false))
			{
				return 0;
			}
			else
			{
				break;
			}
		case 4:
			if((CanSelectWereWolf(nextRace, nextGender) == false))
			{
				return 0;
			}
			else
			{
				break;
			}
		case 5:
			if((CanSelectRoseVain(nextRace, nextGender) == false))
			{
				return 0;
			}
			else
			{
				break;
			}
		default:
			break;
	}
	return nextJob;
}

function bool CanSelectRoseVain(int nextRace, int nextGender)
{
	if((IsAdenServer() == false))
	{
		return false;
	}
	if((nextRace != 2))
	{
		return false;
	}
	return (nextGender == 1);
}

function bool CanSelectWereWolf(int nextRace, int nextGender)
{
	if((IsClassicOriginServer() == true))
	{
		return false;
	}
	if((nextRace != 0))
	{
		return false;
	}
	return (nextGender == 0);
}

function bool CanSelectJobAssassin(int nextRace, int nextGender)
{
	if(!IsAdenServer())
	{
		return false;
	}
	switch(nextRace)
	{
		case 0:
			return (nextGender == 0);
		case 2:
			return (nextGender == 1);
		default:
			return false;
	}
}

function bool CanSelectRaceDk(int tmpRace, int tmpGender)
{
	if((tmpGender != 0))
	{
		return false;
	}
	switch(tmpRace)
	{
		case 0:
			return true;
		case 1:
		case 2:
			return getInstanceUIData().GetIsClassicServer();
		default:
			return false;
	}
}

function bool CanSelectRaceDwarfShineMaker(int tmpRace)
{
	if((tmpRace != 4))
	{
		return false;
	}
	if((IsClassicServer() == true))
	{
		return false;
	}
	return true;
}

function bool CanSelectRaceOrcRider(int tmpRace, int tmpGender)
{
	if((tmpGender != 0))
	{
		return false;
	}
	if(!IsAdenServer())
	{
		return false;
	}
	if((tmpRace != 3))
	{
		return false;
	}
	return true;
}

function int GetHairColor()
{
	if(IsHumanMageNewHairtype())
	{
		return 0;
	}
	if(IsAdenElfNewHairType())
	{
		return 0;
	}
	return HairColor;
}

function bool IsHumanMageNewHairtype()
{
	if((!IsAdenServer() || !IsHumanMage(Race, Job)))
	{
		return false;
	}
	if((gender == 0))
	{
		return (HairType >= 5);
	}
	else
	{
		return (HairType >= 7);
	}
	return false;
}

function bool IsAdenElfNewHairType()
{
	if((!IsElf(Race) || !IsAdenServer()))
	{
		return false;
	}
	if((gender == 0))
	{
		return (HairType >= 5);
	}
	else
	{
		return (HairType >= 7);
	}
}

function HandleCreateCharacter(bool bOK)
{
	local int classType;

	if(bOK)
	{
		classType = CharacterCreateGetClassType(Race, Job, gender);
		if((getInstanceUIData().GetIsLiveServer() && IsDeathKnight(Race, Job)))
		{
			RequestCreateCharacter(Name, Race, classType, gender, HairType, GetHairColor(), FaceType, E_CHARACTER_COLOR((GetHairColor() + 1)));
		}
		else
		{
			RequestCreateCharacter(Name, Race, classType, gender, HairType, GetHairColor(), FaceType, ECC_NONE);
		}
	}
	return;
}

function HandlecharacterNameCreatable(string a_Param)
{
	local int CreateFailType, systemStringArr[8];

	ParseInt(a_Param, "CreateFailType", CreateFailType);
	if((CreateFailType == -1))
	{
		if(IsCreate)
		{
			ShowCreateDialog();
		}
		else
		{
			ShowMessage(GetSystemMessage(3539));
		}
	}
	else
	{
		systemStringArr[0] = 128;
		systemStringArr[1] = 77;
		systemStringArr[2] = 79;
		systemStringArr[3] = 80;
		systemStringArr[4] = 204;
		systemStringArr[5] = 1882;
		systemStringArr[6] = 2037;
		systemStringArr[7] = 6074;
		ShowMessage(GetSystemMessage(systemStringArr[CreateFailType]));
	}
	return;
}

function ShowCreateDialog()
{
	Class'InterfaceClassic.UICommonAPI'.static.DialogSetID(3300);
	Class'InterfaceClassic.UICommonAPI'.static.DialogShowWithTarget(DialogModalType_Modal, DialogType_OKCancel, GetSystemMessage(3533), m_Windowname);
	return;
}

function handleNameConfirm()
{
	if((((isChinaVer() && (Len(Name) < 3)) || (Len(Name) == 0)) || !CheckNameLength(Name)))
	{
		ShowMessage(GetSystemMessage(80));
		return;
	}
	else if(!CheckValidName(Name))
	{
		ShowMessage(GetSystemMessage(204));
		return;
	}
	RequestCharacterNameCreatable(Name);
	return;
}

function HandleDialogResult(bool bOK)
{
	local int DlgID;

	if(!DialogIsMineWithTarget(m_Windowname))
	{
		return;
	}
	DlgID = Class'InterfaceClassic.UICommonAPI'.static.DialogGetID();
	switch(DlgID)
	{
		case 3300:
			HandleCreateCharacter(bOK);
			break;
		default:
			break;
	}
	return;
}

function bool isChinaVer()
{
	return ((4 == int(GetLanguage())) || (1 == int(GetLanguage())));
}

function bool isOldChinaVer()
{
	return ((4 == int(GetLanguage())) && !IsAdenServer());
}

function HandleShowMessage(string param)
{
	local string Msg;

	ParseString(param, "Message", Msg);
	ShowMessage(Msg);
	return;
}

function ShowMessage(string Msg)
{
	CallGFxFunction(m_Windowname, "EV_SystemMsgChanged", Msg);
	return;
}

function bool IsDeathKnight(int tmpRace, int tmpJob)
{
	if((tmpJob != 2))
	{
		return false;
	}
	if((tmpJob != 2))
	{
		return false;
	}
	switch(tmpRace)
	{
		case 0:
			return true;
		case 1:
		case 2:
			return getInstanceUIData().GetIsClassicServer();
		default:
			return false;
	}
}

function bool IsWereWolf(int tmpJob)
{
	return (tmpJob == 4);
}

function bool IsShineMaker(int tmpRace, int tmpJob)
{
	if((tmpJob != 1))
	{
		return false;
	}
	if((tmpRace == 4))
	{
		return getInstanceUIData().GetIsLiveServer();
	}
	return false;
}

function bool IsRoseVain(int tmpJob)
{
	return (tmpJob == 5);
}

function bool IsOrcRider(int tmpRace, int tmpJob)
{
	return ((tmpJob == 2) && (tmpRace == 3));
}

function bool IsAssassin(int tmpJob)
{
	return (tmpJob == 3);
}

function bool IsHumanMage(int tmpRace, int tmpJob)
{
	return ((tmpJob == 1) && (tmpRace == 0));
}

function bool IsElf(int tmpRace)
{
	return (tmpRace == 1);
}

function string GetRaceString(int raceID)
{
	return Class'InterfaceClassic.UICommonAPI'.static.InstUICommonAPI().GetRaceString(raceID);
}
