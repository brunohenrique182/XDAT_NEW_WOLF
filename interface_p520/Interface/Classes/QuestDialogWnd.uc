class QuestDialogWnd extends UICommonAPI
	dependson(UIPacket);

const DISTTICK = 50;
const TALK_DISTANCE = 250;
const TEXTTICK = 50;
const TEXTNUM = 2;
const MONSTERID_DEACTIVE = 19652;
const QUEST_CATEGORY_MAIN = 10001;
const QUEST_CATEGORY_SUB = 20001;
const QUEST_CATEGORY_SPECIAL = 30001;
const DIALOG_HELP_KEY = "\\#$help_index=";
const DIALOG_CLASSCHANGE_KEY = "\\#$class_change";
const DIALOG_MESSAGE_KEY = "\\#$Message0=";

enum QUESTDialogType
{
	non,                            // 0
	Start,                          // 1
	Accept,                         // 2
	complete,                       // 3
	End,                            // 4
	AGAIN                           // 5
};

struct questData
{
	var int QuestID;
	var int dialogType;
	var Vector npcLoc;
};

var TextBoxHandle textBox;
var TextBoxHandle textBox2;
var TextListBoxHandle textBoxList;
var CharacterViewportWindowHandle Viewport;
var ButtonHandle confirmBtn;
var ButtonHandle helpBtn;
var ButtonHandle CancelBtn;
var int _currentQuestID;
var int _currentDialogType;
var int lastAcceptedQuestID;
var string dialog;
var int currentHelpIndex;
var string currentGFxMsg;
var int clickedX;
var int clickedY;
var L2UITimerObject tObjectTalk;
var L2UITimerObject tObjectDist;
var array<questData> qDatas;

static function QuestDialogWnd Inst()
{
	return QuestDialogWnd(GetScript("QuestDialogWnd"));
}

event OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(EV_PacketID(1078));
	return;
}

event OnLoad()
{
	textBox = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".textBox"));
	textBox2 = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".textBox2"));
	textBoxList = GetTextListBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".textBoxList"));
	textBoxList.SetScrollBarPosition(0, -12, 15);
	Viewport = GetCharacterViewportWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".viewport"));
	Viewport.SetUISound(false);
	Viewport.SetSpawnDuration(0.1000000);
	confirmBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".confirmBtn"));
	helpBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".helpBtn"));
	CancelBtn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".cancelBtn"));
	tObjectTalk = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject(50, -1);
	tObjectTalk._DelegateOnStart = HandleTimerOnStart;
	tObjectTalk._DelegateOnTime = HandleTimerOnTime;
	tObjectDist = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject(50, -1);
	tObjectDist._DelegateOnTime = HandleOnTimeUpdateLocChk;
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".portraitSetterBtn")).HideWindow();
	if((IsBuilderPC() && (int(GetReleaseMode()) == 0)))
	{
		GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".portraitSetterBtn")).ShowWindow();
	}
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 40:
			HandleRestart();
			break;
		case EV_PacketID(1078):
			RT_S_EX_QUEST_DIALOG();
			break;
		default:
			break;
	}
	return;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	GetClientCursorPos(clickedX, clickedY);
	if((dialog == ""))
	{
		return;
	}
	tObjectTalk._Stop();
	textBoxList.Clear();
	textBoxList.AddString(dialog, GetColor(199, 199, 199, 255));
	dialog = "";
	return;
}

event OnClickButton(string strID)
{
	if(CheckDrag())
	{
		return;
	}
	switch(strID)
	{
		case "helpBtn":
			ShowCurrentHelp();
			break;
		case "confirmBtn":
			HandleConfirmBtn();
			break;
		case "cancelBtn":
			HandleCancelBtn();
			break;
		case "portraitSetterBtn":
			GetWindowHandle("UIPortraitSetter").ShowWindow();
			UIPortraitSetter(GetScript("UIPortraitSetter"))._SetCurrentQuestInfo();
			break;
		default:
			break;
	}
	return;
}

function HandleRestart()
{
	Clear();
	_currentQuestID = -1;
	_currentDialogType = -1;
	return;
}

function Clear()
{
	qDatas.Length = 0;
	return;
}

function HandleCancelBtn()
{
	switch(qDatas[0].dialogType)
	{
		case 2:
		case 1:
			RQ_C_EX_QUEST_ACCEPT(false);
		default:
			_NextShowQuest();
			return;
	}
}

function ShowCurrentHelp()
{
	if((currentHelpIndex > 0))
	{
		Class'Interface.HelpWnd'.static.ShowHelp(currentHelpIndex);
	}
	return;
}

function HandleConfirmBtn()
{
	switch(_currentDialogType)
	{
		case 1:
			ShowTeleport();
			break;
		case 2:
			Class'Interface.QuestConfirmWnd'.static.Inst()._ShowQuestConfirm();
			break;
		case 3:
			ShowTeleport();
			break;
		case 4:
			Class'Interface.QuestConfirmWnd'.static.Inst()._ShowQuestEnd();
			break;
		default:
			break;
	}
	return;
}

function ShowTeleport()
{
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemString(13853));
	Class'Interface.DialogBox'.static.Inst().DelegateOnOK = HandleDialogOK;
	return;
}

function SetGfxMsg()
{
	if((currentGFxMsg != ""))
	{
		QuestProgressWnd(GetScript("QuestProgressWnd"))._SetGfxMsg(currentGFxMsg);
		currentGFxMsg = "";
	}
	return;
}

function ChkGFxMsg()
{
	if((currentGFxMsg != ""))
	{
		getInstanceL2Util().showGfxScreenMessage(currentGFxMsg);
		currentGFxMsg = "";
	}
	return;
}

function HandleDialogOK()
{
	ChkGFxMsg();
	RQ_C_EX_QUEST_TELEPORT();
	_NextShowQuest();
	return;
}

event OnHide()
{
	CheckAcceptOnHide();
	tObjectTalk._Stop();
	tObjectDist._Stop();
	textBoxList.Clear();
	dialog = "";
	Class'Interface.QuestConfirmWnd'.static.Inst().m_hOwnerWnd.HideWindow();
	if(DialogIsMine())
	{
		Class'Interface.DialogBox'.static.Inst().HideDialog();
	}
	return;
}

function CheckAcceptOnHide()
{
	if((_currentDialogType != 2))
	{
		return;
	}
	if(!IsMainCurrent())
	{
		return;
	}
	if((lastAcceptedQuestID == _currentQuestID))
	{
		return;
	}
	if(CollectionSystem(GetScript("CollectionSystem"))._IsCollectionOpen())
	{
		return;
	}
	SetGfxMsg();
	RQ_C_EX_QUEST_ACCEPT(true);
	return;
}

event OnEnterState(name a_CurrentStateName)
{
	if((qDatas.Length > 0))
	{
		ShowQuest((_currentQuestID == qDatas[0].QuestID));
	}
	return;
}

event OnSetFocus(WindowHandle wndHandle, bool bFocused)
{
	super.OnSetFocus(wndHandle, bFocused);
	if(bFocused)
	{
		Class'Interface.QuestConfirmWnd'.static.Inst().m_hOwnerWnd.BringToFront();
	}
	return;
}

function SetPortrait(NQuestUIData questUIData)
{
	local NQuestNpcPortraitUIData questNpcPortraitUIData;
	local int questPortraitID;

	switch(_currentDialogType)
	{
		case 1:
		case 2:
		case 5:
			questPortraitID = questUIData.StartNPC.Id;
			break;
		case 3:
		case 4:
			questPortraitID = questUIData.EndNPC.Id;
			break;
		default:
			break;
	}
	if((questPortraitID < 1))
	{
		textBox2.SetText(GetSystemString(118));
		Viewport.HideWindow();
		return;
	}
	Viewport.ShowWindow();
	API_GetNQuestNpcPortraitData(questPortraitID, questNpcPortraitUIData);
	textBox2.SetText(API_GetNPCName(questPortraitID));
	Viewport.SetNPCInfo(questPortraitID);
	Viewport.SetCameraDistance(questNpcPortraitUIData.ViewDist);
	Viewport.SetCharacterOffsetX(questNpcPortraitUIData.ViewOffsetX);
	Viewport.SetCharacterOffsetY(questNpcPortraitUIData.ViewOffsetY);
	Viewport.SetCharacterOffsetZ(questNpcPortraitUIData.ViewOffsetZ);
	Viewport.SetCurrentRotation(questNpcPortraitUIData.ViewRotationYaw);
	Viewport.SetCharacterScale(questNpcPortraitUIData.ViewScale);
	Viewport.SpawnNPC();
	return;
}

function ShowQuest(optional bool isfullDialog)
{
	local NQuestUIData questUIData;
	local NQuestDialogUIData questDialogUIData;
	local UserInfo uInfo;

	if((GetGameStateName() == "COLLECTIONSTATE"))
	{
		return;
	}
	tObjectDist._Pause();
	lastAcceptedQuestID = -1;
	_currentQuestID = qDatas[0].QuestID;
	_currentDialogType = qDatas[0].dialogType;
	SetCurrentNPcLoc();
	API_GetNQuestData(_currentQuestID, questUIData);
	if(!GetPlayerInfo(uInfo))
	{
		_NextShowQuest();
		return;
	}
	switch(_currentDialogType)
	{
		case 1:
		case 2:
			if(((questUIData.LevelMin > 0) && (questUIData.LevelMin > uInfo.nLevel)))
			{
				_NextShowQuest();
				return;
			}
			if(((questUIData.LevelMax > 0) && (questUIData.LevelMax < uInfo.nLevel)))
			{
				_NextShowQuest();
				return;
			}
		default:
			m_hOwnerWnd.ShowWindow();
			m_hOwnerWnd.SetFocus();
			textBox.SetText(questUIData.Name);
			SetPortrait(questUIData);
			API_GetNQuestDialogData(_currentQuestID, questDialogUIData);
			SetDialog(questDialogUIData, isfullDialog);
			SetConfirmBtn(questUIData);
			SetDistanceCheck(isfullDialog);
			return;
	}
}

function SetConfirmBtn(NQuestUIData questUIData)
{
	CancelBtn.EnableWindow();
	switch(_currentDialogType)
	{
		case 1:
			confirmBtn.ShowWindow();
			confirmBtn.SetButtonName(900);
			CancelBtn.SetButtonName(14180);
			if(IsMainCurrent())
			{
				CancelBtn.DisableWindow();
			}
			break;
		case 2:
			confirmBtn.ShowWindow();
			confirmBtn.SetButtonName(14179);
			CancelBtn.SetButtonName(14180);
			if(IsMainCurrent())
			{
				CancelBtn.DisableWindow();
			}
			break;
		case 3:
			confirmBtn.ShowWindow();
			confirmBtn.SetButtonName(900);
			CancelBtn.SetButtonName(14180);
			break;
		case 4:
			confirmBtn.ShowWindow();
			confirmBtn.SetButtonName(898);
			CancelBtn.SetButtonName(646);
			break;
		case 5:
			confirmBtn.HideWindow();
			CancelBtn.SetButtonName(646);
			break;
		default:
			break;
	}
	if((currentHelpIndex > 0))
	{
		helpBtn.ShowWindow();
	}
	else
	{
		helpBtn.HideWindow();
	}
	return;
}

function SetDialog(NQuestDialogUIData questDialogUIData, optional bool isfullDialog)
{
	local string tmpDialog, word;

	tObjectTalk._Pause();
	tmpDialog = GetCurrentDialog(questDialogUIData);
	GetWordByKey("\\#$Message0=", tmpDialog, currentGFxMsg);
	if(GetWordByKey("\\#$class_change", tmpDialog, word))
	{
		Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("JobChangeWnd");
	}
	if(GetWordByKey("\\#$help_index=", tmpDialog, word))
	{
		currentHelpIndex = int(word);
	}
	else
	{
		currentHelpIndex = -1;
	}
	dialog = tmpDialog;
	if(isfullDialog)
	{
		textBoxList.AddString(dialog, GetColor(199, 199, 199, 255));
	}
	else
	{
		tObjectTalk._Play();
	}
	return;
}

function string GetCurrentDialog(NQuestDialogUIData questDialogUIData)
{
	switch(_currentDialogType)
	{
		case 1:
			return questDialogUIData.StartDialog;
		case 2:
			return questDialogUIData.AcceptDialog;
		case 3:
			return questDialogUIData.CompleteDialog;
		case 4:
			return questDialogUIData.EndDialog;
		case 5:
			return questDialogUIData.AcceptDialog;
		default:
			return "";
	}
}

function SetDistanceCheck(optional bool isfullDialog)
{
	switch(_currentDialogType)
	{
		case 1:
		case 3:
		case 5:
			return;
		default:
			if((GetCurrentNPCTeleportID() < 0))
			{
				return;
			}
			tObjectDist._Play();
			if(isfullDialog)
			{
				return;
			}
			if((Class'NWindow.UIDATA_TARGET'.static.GetTargetClassID() == GetCurrentNPCData().Id))
			{
				return;
			}
			ExecuteCommand(("/target" @ API_GetNPCName(GetCurrentNPCData().Id)));
			return;
	}
}

function SetCurrentNPcLoc()
{
	switch(_currentDialogType)
	{
		case 1:
		case 2:
			qDatas[0].npcLoc = GetCurrentNPCData().Location;
			break;
		case 3:
		case 4:
			qDatas[0].npcLoc = GetCurrentNPCData().Location;
			break;
		default:
			break;
	}
	return;
}

function _NextShowQuest()
{
	m_hOwnerWnd.HideWindow();
	DelQuest(0);
	if((qDatas.Length == 0))
	{
		return;
	}
	ShowQuest();
	return;
}

function _ConfirmQuest()
{
	SetGfxMsg();
	switch(_currentDialogType)
	{
		case 2:
			RQ_C_EX_QUEST_ACCEPT(true);
			break;
		case 4:
			RQ_C_EX_QUEST_COMPLETE();
			break;
		default:
			break;
	}
	_NextShowQuest();
	return;
}

function _SohwDialogAgain(int QuestID)
{
	local questData qData;

	qData.QuestID = QuestID;
	qData.dialogType = 5;
	switch(qDatas.Length)
	{
		case 0:
			if(AddQuestData(qData))
			{
				ShowQuest();
				return;
			}
			break;
		case 1:
			if((qDatas[0].dialogType == 5))
			{
				if(AddQuestData(qData))
				{
					_NextShowQuest();
					return;
				}
			}
			break;
		default:
			break;
	}
	getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13822));
	return;
}

function HandleTimerOnStart()
{
	textBoxList.Clear();
	return;
}

function HandleTimerOnTime(int t)
{
	local int addStringLen;

	textBoxList.Clear();
	addStringLen = ((t + 1) * 2);
	if((addStringLen < Len(dialog)))
	{
		textBoxList.AddString(Left(dialog, addStringLen), GetColor(199, 199, 199, 255));
		return;
	}
	else
	{
		tObjectTalk._Stop();
		textBoxList.AddString(dialog, GetColor(199, 199, 199, 255));
		dialog = "";
	}
	return;
}

function _ShowStartDialog(int QuestID)
{
	local questData qData;
	local NQuestUIData o_data;

	if((qDatas.Length > 0))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13822));
		return;
	}
	qData.QuestID = QuestID;
	if(!API_GetNQuestData(QuestID, o_data))
	{
		return;
	}
	if(CheckDistanceToStart(QuestID))
	{
		qData.dialogType = 1;
	}
	else
	{
		qData.dialogType = 2;
	}
	if(AddQuestData(qData))
	{
		if((qDatas.Length == 1))
		{
			ShowQuest();
		}
	}
	return;
}

function _ShowCompleteDialog(int QuestID, optional bool bClicked)
{
	local questData qData;
	local NQuestUIData o_data;

	if(((qDatas.Length > 0) && bClicked))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13822));
		return;
	}
	qData.QuestID = QuestID;
	if(!API_GetNQuestData(QuestID, o_data))
	{
		return;
	}
	if(CheckDistanceToComplete(QuestID))
	{
		qData.dialogType = 3;
	}
	else
	{
		qData.dialogType = 4;
	}
	if(AddQuestData(qData))
	{
		if((qDatas.Length == 1))
		{
			ShowQuest();
		}
	}
	return;
}

function bool _CheckDistanceToStart(int qid)
{
	return CheckDistanceToStart(qid);
}

function bool CheckDistanceToStart(int qid)
{
	local UserInfo uInfo;
	local NQuestUIData questUIData;
	local int dist;

	API_GetNQuestData(qid, questUIData);
	if((questUIData.StartNPC.TeleportID < 1))
	{
		return false;
	}
	GetPlayerInfo(uInfo);
	dist = Distance(uInfo.Loc, questUIData.StartNPC.Location);
	if((dist < 0))
	{
		return true;
	}
	return (dist > 250);
}

function bool CheckDistanceToComplete(int qid)
{
	local UserInfo uInfo;
	local NQuestUIData questUIData;
	local int dist;

	API_GetNQuestData(qid, questUIData);
	if((questUIData.EndNPC.TeleportID < 1))
	{
		return false;
	}
	GetPlayerInfo(uInfo);
	dist = Distance(uInfo.Loc, questUIData.EndNPC.Location);
	if((dist < 0))
	{
		return true;
	}
	return (dist > 250);
}

function HandleNewQuestData(int QuestID, int dialogType)
{
	local questData qData;

	qData.QuestID = QuestID;
	qData.dialogType = dialogType;
	if(AddQuestData(qData))
	{
		if((qDatas.Length == 1))
		{
			ShowQuest();
		}
	}
	return;
}

function bool _IsDialogAgain()
{
	return (qDatas[0].dialogType == 5);
}

function int GetQuestIndex(questData qData)
{
	local int i;

	i = 0;
	while((i < qDatas.Length))
	{
		if(((qDatas[i].QuestID == qData.QuestID) && (qDatas[i].dialogType == qData.dialogType)))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function bool AddQuestData(questData qData)
{
	local int Index;

	Index = GetQuestIndex(qData);
	if((Index != -1))
	{
		return false;
	}
	qDatas[qDatas.Length] = qData;
	return true;
}

function DelQuestData(questData qData)
{
	local int Index;

	Index = GetQuestIndex(qData);
	if((Index != -1))
	{
		DelQuest(Index);
	}
	return;
}

function DelQuest(int Index)
{
	_currentQuestID = -1;
	_currentDialogType = -1;
	dialog = "";
	if((qDatas.Length <= Index))
	{
		return;
	}
	qDatas.Remove(Index, 1);
	return;
}

function bool CurrentDataDistChk()
{
	local UserInfo uInfo;
	local int dist;

	switch(_currentDialogType)
	{
		case 1:
		case 3:
		case 5:
			return true;
		case 2:
		case 4:
			break;
		default:
			break;
	}
	GetPlayerInfo(uInfo);
	dist = Distance(uInfo.Loc, qDatas[0].npcLoc);
	if((dist < 0))
	{
		return false;
	}
	return (dist < 250);
}

function HandleOnTimeUpdateLocChk(int t)
{
	if(CurrentDataDistChk())
	{
		return;
	}
	_NextShowQuest();
	return;
}

function bool GetWordByKey(string Key, out string tmpDialog, out string word)
{
	local int firstIndex;

	firstIndex = InStr(tmpDialog, Key);
	if((firstIndex > -1))
	{
		word = Right(tmpDialog, ((Len(tmpDialog) - firstIndex) - Len(Key)));
		tmpDialog = Left(tmpDialog, firstIndex);
		return true;
	}
	word = "";
	return false;
}

function bool IsMainCurrent()
{
	return (qDatas[0].QuestID < 20001);
}

function int Distance(Vector locA, Vector locB)
{
	local int gabX, gabY, gabZ;

	gabX = int((locA.X - locB.X));
	gabY = int((locA.Y - locB.Y));
	gabZ = int((locA.Z - locB.Z));
	return int(Sqrt(float((((gabX * gabX) + (gabY * gabY)) + (gabZ * gabZ)))));
}

function int _GetCurrentTeleportID()
{
	local NQuestUIData questUIData;

	API_GetNQuestData(_currentQuestID, questUIData);
	return questUIData.TeleportID;
}

function int GetCurrentNPCTeleportID()
{
	return GetCurrentNPCData().TeleportID;
}

function NQuestNPCData GetCurrentNPCData()
{
	local NQuestUIData questUIData;

	API_GetNQuestData(_currentQuestID, questUIData);
	switch(_currentDialogType)
	{
		case 1:
		case 2:
		case 5:
			return questUIData.StartNPC;
		case 3:
		case 4:
			return questUIData.EndNPC;
		default:
	}
}

function bool CheckDrag()
{
	local int X, Y, gabX, gabY;

	GetClientCursorPos(X, Y);
	gabX = (X - clickedX);
	gabY = (Y - clickedY);
	return (Sqrt(float(((gabX * gabX) + (gabY * gabY)))) > 1.0000000);
}

function RT_S_EX_QUEST_DIALOG()
{
	local UIPacket._S_EX_QUEST_DIALOG packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_QUEST_DIALOG(packet))
	{
		return;
	}
	HandleNewQuestData(packet.nID, packet.cDialogType);
	return;
}

function RQ_C_EX_QUEST_TELEPORT()
{
	local array<byte> stream;
	local UIPacket._C_EX_QUEST_TELEPORT packet;

	packet.nID = _currentQuestID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_QUEST_TELEPORT(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(827, stream);
	return;
}

function RQ_C_EX_QUEST_ACCEPT(optional bool bAccept)
{
	local array<byte> stream;
	local UIPacket._C_EX_QUEST_ACCEPT packet;

	lastAcceptedQuestID = _currentQuestID;
	packet.nID = _currentQuestID;
	if(bAccept)
	{
		packet.bAccept = 1;
	}
	else
	{
		packet.bAccept = 0;
	}
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_QUEST_ACCEPT(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(828, stream);
	return;
}

function RQ_C_EX_QUEST_COMPLETE()
{
	local array<byte> stream;
	local UIPacket._C_EX_QUEST_COMPLETE packet;

	packet.nID = _currentQuestID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_QUEST_COMPLETE(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(830, stream);
	return;
}

function string API_GetNPCName(int NpcID)
{
	if((NpcID == -1))
	{
		return "?";
	}
	return Class'NWindow.UIDATA_NPC'.static.GetNPCName(NpcID);
}

function bool API_GetNQuestData(int a_QuestID, out NQuestUIData o_data)
{
	return GetNQuestData(a_QuestID, o_data);
}

function bool API_GetNQuestDialogData(int a_QuestID, out NQuestDialogUIData o_data)
{
	return GetNQuestDialogData(a_QuestID, o_data);
}

function bool API_GetNQuestNpcPortraitData(int a_NpcID, out NQuestNpcPortraitUIData o_data)
{
	return GetNQuestNpcPortraitData((1000000 + a_NpcID), o_data);
}
