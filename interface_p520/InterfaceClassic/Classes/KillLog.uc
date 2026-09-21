class KillLog extends UICommonAPI
	dependson(UIPacket);

const INSERTPOSITIONX = -30;
const SCREENMESSAGEWND_MAX = 7;
const GAB_Y = 0;
const BG_LOCAL_CENTER_X = 175;
const FadeInTime = 500;
const FadeOutTime = 500;
const ROLLOUTTIME = 500;

struct killLogObjectData
{
	var TextBoxHandle killName;
	var TextBoxHandle DeadName;
	var TextureHandle KillPortrait;
	var TextureHandle DeadPortrait;
	var TextureHandle killBox;
	var TextureHandle deadBox;
	var TextureHandle killLogBG;
	var L2UITimerObject KillTimer;
};

var L2UITween l2UITweenScript;
var byte logTime;
var byte maxLog;
var array<byte> multiLogKills;
var int currentindex;
var int activeLogNum;
var L2UITweenObject l2UITweenObjectPos[7];
var killLogObjectData killLogObjects[7];

function SetTweens()
{
	local int i;
	local string targetPath;

	l2UITweenScript = L2UITween(GetScript("l2UITween"));
	i = 0;
	while((i < 7))
	{
		targetPath = GetPathUtil(i);
		l2UITweenObjectPos[i] = new Class'InterfaceClassic.L2UITweenObject';
		l2UITweenObjectPos[i].Id = i;
		l2UITweenObjectPos[i].Owner = m_hOwnerWnd.m_WindowNameWithFullPath;
		l2UITweenObjectPos[i].Target = GetWindowHandle(targetPath);
		l2UITweenObjectPos[i].Duration = 500.0000000;
		l2UITweenObjectPos[i].ease = OUT_STRONG;
		l2UITweenObjectPos[i]._DelegateOnUpdate = OnDelegateOnUpdate;
		killLogObjects[i].killLogBG = GetTextureHandle((targetPath $ ".killLogBG"));
		killLogObjects[i].killName = GetTextBoxHandle((targetPath $ ".killName"));
		killLogObjects[i].DeadName = GetTextBoxHandle((targetPath $ ".deadName"));
		killLogObjects[i].killBox = GetTextureHandle((targetPath $ ".killBox"));
		killLogObjects[i].deadBox = GetTextureHandle((targetPath $ ".deadBox"));
		killLogObjects[i].DeadPortrait = GetTextureHandle((targetPath $ ".deadPortrait"));
		killLogObjects[i].KillPortrait = GetTextureHandle((targetPath $ ".killPortrait"));
		killLogObjects[i].KillTimer = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject((int(logTime) * 1000));
		killLogObjects[i].KillTimer._DelegateOnEnd = OnDelegateOnEnd;
		i++;
	}
	return;
}

function InitKillLogData()
{
	local byte o_MultiLogTime;
	local string param;
	local int multiLogTime;

	API_GetKillLogData(logTime, maxLog, o_MultiLogTime, multiLogKills);
	multiLogTime = (int(o_MultiLogTime) * 1000);
	maxLog = byte(Min(int(maxLog), 7));
	if((multiLogKills.Length == 0))
	{
		TestInitKillData();
		multiLogTime = 3000;
	}
	param = "";
	ParamAdd(param, "multiLogTime", string(multiLogTime));
	CallGFxFunction("KillLogCenter", "InitKillLogData", param);
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(16);
	RegisterEvent(17);
	RegisterEvent(18);
	RegisterEvent(EV_PacketID(1136));
	RegisterEvent(40);
	return;
}

event OnLoad()
{
	l2UITweenScript = L2UITween(GetScript("l2UITween"));
	InitKillLogData();
	SetTweens();
	return;
}

event OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 16:
			HandleTest6();
			break;
		case 17:
			CallGFxFunction("KillLogCenter", "Use Foreign", "");
			break;
		case 18:
			m_hOwnerWnd.KillTimer(0);
			break;
		case EV_PacketID(1136):
			RT_S_EX_ENEMY_KILL_LOG();
			break;
		case 40:
			HandleRestart();
			break;
		default:
			break;
	}
	return;
}

function HandleRestart()
{
	local int i;

	i = 0;
	while((i < 7))
	{
		l2UITweenObjectPos[i].Target.SetAlpha(0);
		i++;
	}
	currentindex = 0;
	activeLogNum = 0;
	return;
}

function HandleTest6()
{
	SetKillLogData(MAKE_S_EX_ENEMY_KILL_LOG());
	FadeInTween();
	FadeOutTweens();
	if((currentindex == (int(maxLog) - 1)))
	{
		currentindex = 0;
	}
	else
	{
		currentindex++;
	}
	return;
}

event OnTimer(int TimerID)
{
	ExecuteEvent(16, "");
	return;
}

function RT_S_EX_ENEMY_KILL_LOG()
{
	local UIPacket._S_EX_ENEMY_KILL_LOG packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_ENEMY_KILL_LOG(packet))
	{
		return;
	}
	SetKillLogData(packet);
	FadeInTween();
	FadeOutTweens();
	if((currentindex == (int(maxLog) - 1)))
	{
		currentindex = 0;
	}
	else
	{
		currentindex++;
	}
	return;
}

function bool MultiKillStopCheck(int killNum)
{
	return (int(multiLogKills[0]) <= killNum);
}

function int MultiKillCheck(int killNum)
{
	local int i;

	i = 0;
	while((i < multiLogKills.Length))
	{
		if((int(multiLogKills[i]) == killNum))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function SetKillLogData(UIPacket._S_EX_ENEMY_KILL_LOG packet)
{
	local Color nameTextColor;

	packet.Attacker.wstrName = ConvertWorldIDToStr(packet.Attacker.wstrName);
	packet.Victim.wstrName = ConvertWorldIDToStr(packet.Victim.wstrName);
	killLogObjects[currentindex].killName.SetText(packet.Attacker.wstrName);
	killLogObjects[currentindex].DeadName.SetText(packet.Victim.wstrName);
	killLogObjects[currentindex].KillPortrait.SetTexture(Get_CharacterTexture(packet.Attacker.nRace, packet.Attacker.nClass, packet.Attacker.nSex));
	killLogObjects[currentindex].DeadPortrait.SetTexture(Get_CharacterTexture(packet.Victim.nRace, packet.Victim.nClass, packet.Victim.nSex));
	if((int(packet.bEnemyDied) == 1))
	{
		killLogObjects[currentindex].killBox.SetTexture("L2UI_NewTex.KillLog.PortraitBg_Blue");
		killLogObjects[currentindex].deadBox.SetTexture("L2UI_NewTex.KillLog.PortraitBg_Red");
		killLogObjects[currentindex].killLogBG.SetTexture("L2UI_NewTex.KillLog.SideBg_Blue");
		nameTextColor = GetColor(105, 165, 255, 255);
	}
	else
	{
		killLogObjects[currentindex].killBox.SetTexture("L2UI_NewTex.KillLog.PortraitBg_Red");
		killLogObjects[currentindex].deadBox.SetTexture("L2UI_NewTex.KillLog.PortraitBg_Blue");
		killLogObjects[currentindex].killLogBG.SetTexture("L2UI_NewTex.KillLog.SideBg_Red");
		nameTextColor = GetColor(255, 102, 102, 255);
	}
	killLogObjects[currentindex].killName.SetTextColor(nameTextColor);
	killLogObjects[currentindex].DeadName.SetTextColor(nameTextColor);
	if((MultiKillStopCheck(packet.Victim.nTotalEnemyKill) || (MultiKillCheck(packet.Attacker.nTotalEnemyKill) > -1)))
	{
		CallGFxFunction("KillLogCenter", "killLog", MakeGFxParam(packet));
	}
	return;
}

function string MakeGFxParam(UIPacket._S_EX_ENEMY_KILL_LOG packet)
{
	local string param;
	local LobbyMenuWnd lobbyMenuWndScr;

	lobbyMenuWndScr = LobbyMenuWnd(GetScript("LobbyMenuWnd"));
	lobbyMenuWndScr.getCharacterImg(packet.Attacker.nRace, packet.Attacker.nClass, packet.Attacker.nSex);
	lobbyMenuWndScr.getCharacterImg(packet.Victim.nRace, packet.Victim.nClass, packet.Victim.nSex);
	param = "";
	ParamAdd(param, "bEnemyDied", string(packet.bEnemyDied));
	ParamAdd(param, "attacker.wstrName", packet.Attacker.wstrName);
	ParamAdd(param, "attacker.sFrameLable", lobbyMenuWndScr.getCharacterImg(packet.Attacker.nRace, packet.Attacker.nClass, packet.Attacker.nSex));
	ParamAdd(param, "attacker.killStep", string(MultiKillCheck(packet.Attacker.nTotalEnemyKill)));
	ParamAdd(param, "victim.wstrName", packet.Victim.wstrName);
	ParamAdd(param, "victim.sFrameLable", lobbyMenuWndScr.getCharacterImg(packet.Victim.nRace, packet.Victim.nClass, packet.Victim.nSex));
	ParamAdd(param, "bIsKillStopping", string(MultiKillStopCheck(packet.Victim.nTotalEnemyKill)));
	return param;
}

function string Get_CharacterTexture(int nRace, int nClassID, int nSex)
{
	local string sexStr;

	if((nSex > 0))
	{
		sexStr = "W";
	}
	else
	{
		sexStr = "M";
	}
	if((nRace == 6))
	{
		sexStr = "W";
	}
	if(IsDeathKnightClass(Class'NWindow.UIDataManager'.static.GetRootClassID(nClassID)))
	{
		sexStr = "M";
	}
	if(IsDeathFighterClass(Class'NWindow.UIDataManager'.static.GetRootClassID(nClassID)))
	{
		sexStr = "M";
	}
	return ((((("L2UI_NewTex.KillLog.FaceIcon_" $ GetRaceString(nRace)) $ "_") $ getInstanceL2Util().GetPlayerType(nClassID, nRace)) $ "_") $ sexStr);
}

function int GetPrevIndex()
{
	if((currentindex == 0))
	{
		return 3;
	}
	return (currentindex - 1);
}

function string GetPathUtil(int Index)
{
	return ((m_hOwnerWnd.m_WindowNameWithFullPath $ ".TopRightStack.killLog") $ string(Index));
}

function FadeInTween()
{
	local int GlobalX, GlobalY;

	Local2Global(l2UITweenObjectPos[currentindex].Target.GetParentWindowHandle(), -(-30), 0, GlobalX, GlobalY);
	l2UITweenObjectPos[currentindex].Target.MoveTo(GlobalX, GlobalY);
	l2UITweenObjectPos[currentindex].MoveY = 0.0000000;
	l2UITweenObjectPos[currentindex].posY = 0;
	l2UITweenObjectPos[currentindex].MoveX = -30.0000000;
	l2UITweenObjectPos[currentindex].posX = 0;
	l2UITweenObjectPos[currentindex].Alpha = 255.0000000;
	l2UITweenObjectPos[currentindex].Target.SetAlpha(0);
	l2UITweenObjectPos[currentindex].ease = OUT_STRONG;
	l2UITweenObjectPos[currentindex].Target.ShowWindow();
	l2UITweenObjectPos[currentindex].Duration = 500.0000000;
	l2UITweenObjectPos[currentindex]._Reset();
	killLogObjects[currentindex].KillTimer._Reset();
	Local2Global(l2UITweenObjectPos[currentindex].Target, 175, 0, GlobalX, GlobalY);
	killLogObjects[currentindex].killLogBG.MoveTo(GlobalX, GlobalY);
	activeLogNum++;
	_SendToGfxScreenMessageKillLogCenterFadeIn();
	return;
}

function FadeOutTweens()
{
	local int i, prevIndex, lastIndex;

	i = 0;
	while((i < (activeLogNum - 1)))
	{
		prevIndex = ((currentindex - i) - 1);
		if((prevIndex < 0))
		{
			prevIndex = (prevIndex + int(maxLog));
		}
		RollOutTween(prevIndex);
		i++;
	}
	if((activeLogNum == int(maxLog)))
	{
		lastIndex = (currentindex + 1);
		lastIndex = int((float(lastIndex) % float(maxLog)));
		FadeOutTween(lastIndex);
	}
	return;
}

function RollOutTween(int Index)
{
	local int locX, locY;

	GetLocalPosition(l2UITweenObjectPos[Index].Target, locX, locY);
	l2UITweenObjectPos[Index].MoveY = (((l2UITweenObjectPos[Index].MoveY - float((locY - l2UITweenObjectPos[Index].posY))) + 0.0000000) + 44.0000000);
	l2UITweenObjectPos[Index].Alpha = 255.0000000;
	l2UITweenObjectPos[Index].MoveX = float(-locX);
	l2UITweenObjectPos[Index].ease = OUT_STRONG;
	l2UITweenObjectPos[Index].Duration = 500.0000000;
	l2UITweenObjectPos[Index]._Reset();
	return;
}

function FadeOutTween(int Index)
{
	local int locX, locY;

	killLogObjects[Index].KillTimer._Stop();
	GetLocalPosition(l2UITweenObjectPos[Index].Target, locX, locY);
	l2UITweenObjectPos[Index]._Stop();
	l2UITweenObjectPos[Index].MoveY = (l2UITweenObjectPos[Index].MoveY - float((locY - l2UITweenObjectPos[Index].posY)));
	l2UITweenObjectPos[Index].MoveX = float((locX - -30));
	l2UITweenObjectPos[Index].Alpha = -255.0000000;
	l2UITweenObjectPos[Index].ease = OUT_STRONG;
	l2UITweenObjectPos[Index].Duration = 500.0000000;
	l2UITweenObjectPos[Index]._Reset();
	activeLogNum--;
	return;
}

function OnDelegateOnUpdate(L2UITweenObject tObject)
{
	local int GlobalX, GlobalY, localX, localY;

	GetLocalPosition(tObject.Target, localX, localY);
	Local2Global(tObject.Target, (175 + localX), 0, GlobalX, GlobalY);
	killLogObjects[tObject.Id].killLogBG.MoveTo(GlobalX, GlobalY);
	return;
}

function OnDelegateOnEnd()
{
	local int firstIndex;

	firstIndex = (currentindex - activeLogNum);
	if((firstIndex < 0))
	{
		firstIndex = (firstIndex + int(maxLog));
	}
	FadeOutTween(firstIndex);
	if((activeLogNum == 0))
	{
		_SendToGfxScreenMessageKillLogCenterFadeOut();
	}
	return;
}

function API_GetKillLogData(out byte o_LogTime, out byte o_MaxLog, out byte o_MultiLogTime, out array<byte> o_MultiLogKills)
{
	GetKillLogData(o_LogTime, o_MaxLog, o_MultiLogTime, o_MultiLogKills);
	return;
}

function _SendToGfxScreenMessageKillLogCenterFadeIn()
{
	if((activeLogNum < 1))
	{
		return;
	}
	if(Class'InterfaceClassic.PositionManager'.static.Inst()._IsSaved(m_hOwnerWnd.GetWindowName()))
	{
		return;
	}
	CallGFxFunction("GfxScreenMessage", "KillLogCenterFadeIn", "");
	return;
}

function _SendToGfxScreenMessageKillLogCenterFadeOut()
{
	CallGFxFunction("GfxScreenMessage", "KillLogCenterFadeOut", "");
	return;
}

function string GetRandomName()
{
	switch(Rand(8))
	{
		case 0:
			return "아이스그린";  // EN?: Ice Green
		case 1:
			return "초코레트";  // EN?: Chocolette
		case 2:
			return "쿠루미";  // EN?: Kurumi
		case 3:
			return "세이버";  // EN?: Fate/stay night
		case 4:
			return "백색의레이디복스";  // EN?: Lady Vox in White
		case 5:
			return "붉은로드나가펜";  // EN?: Red Rodnagappen
		case 6:
			return "케라핌";  // EN?: Kerapim
		case 7:
			return "도도새감별사";  // EN?: Dodo Bird Inspector
		default:
			return "NoName";
	}
}

function UIPacket._S_EX_ENEMY_KILL_LOG MAKE_S_EX_ENEMY_KILL_LOG()
{
	local UIPacket._S_EX_ENEMY_KILL_LOG packet;

	packet.bEnemyDied = byte(Rand(2));
	packet.Attacker.wstrName = GetRandomName();
	packet.Attacker.nTotalEnemyKill = (Rand(11) * 10);
	packet.Victim.wstrName = GetRandomName();
	packet.Attacker.nClass = (Rand(4) + 247);
	packet.Attacker.nRace = 0;
	packet.Attacker.nSex = 0;
	packet.Victim.nClass = (Rand(4) + 247);
	packet.Victim.nRace = 0;
	packet.Attacker.nSex = 0;
	packet.Victim.nTotalEnemyKill = Rand(10);
	return packet;
}

function TestInitKillData()
{
	logTime = 3;
	maxLog = 7;
	multiLogKills.Length = 3;
	multiLogKills[0] = 5;
	multiLogKills[1] = 20;
	multiLogKills[2] = 30;
	return;
}
