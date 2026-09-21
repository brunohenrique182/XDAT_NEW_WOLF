class WorldSiegeBoardWnd extends UICommonAPI
	dependson(UIPacket);

const MAP_SCALE = 0.0312;
const MAX_HERO = 5;
const MAX_GOLEM = 3;
const MAX_DOOR = 3;
const MAX_Occupation = 20;
const TIMER_MYPOS_ID = 0;
const TIMER_MYPOS_TIME = 500;
const TIMER_HUD_INFO_ID = 1;
const TIMER_HUD_INFO_TIME = 3000;
const TIMER_HEROWEAPON_DELETE_ID = 2;
const TIMER_HEROWEAPON_DELETE_TIME = 12000;

var string m_Windowname;
var WindowHandle Me;
var TextBoxHandle Time_Txt;
var TextureHandle Icon_PC;
var TextureHandle Map_tex;
var Vector startLoc;
var UIMapInt64Object mapObjOccupy;
var UIMapInt64Object mapObjHeroWeapon;
var UIMapInt64Object mapObjHeroWeaponUser;
var UIMapInt64Object mapObjGolem;
var bool bHUDInfoReq;
var array<WorldSiegeBoardOcptnObject> worldSiegeBoardOcptnObjects;

static function WorldSiegeBoardWnd Inst()
{
	return WorldSiegeBoardWnd(GetScript("WorldSiegeBoardWnd"));
}

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	Icon_PC = GetTextureHandle((m_Windowname $ ".WorldSegeMapWnd.Icon_PC"));
	Time_Txt = GetTextBoxHandle((m_Windowname $ ".Time_txt"));
	Map_tex = GetTextureHandle((m_Windowname $ ".WorldSegeMapWnd.Map_tex"));
	startLoc.X = 139712.0000000;
	startLoc.Y = -400.0000000;
	InitWorldSiegeBoardOcptnObjects();
	mapObjOccupy = new Class'InterfaceClassic.UIMapInt64Object';
	mapObjHeroWeapon = new Class'InterfaceClassic.UIMapInt64Object';
	mapObjHeroWeaponUser = new Class'InterfaceClassic.UIMapInt64Object';
	mapObjGolem = new Class'InterfaceClassic.UIMapInt64Object';
	return;
}

function InitWorldSiegeBoardOcptnObjects()
{
	local int i;

	i = 0;
	while((GetWindowHandle(((m_Windowname $ ".WorldSegeMapWnd.Icon_ocptnObjectWnd") $ Int2Str(i))).m_pTargetWnd != none))
	{
		worldSiegeBoardOcptnObjects[i] = Class'InterfaceClassic.WorldSiegeBoardOcptnObject'.static.InitScript(GetWindowHandle(((m_Windowname $ ".WorldSegeMapWnd.Icon_ocptnObjectWnd") $ Int2Str(i))), i);
		worldSiegeBoardOcptnObjects[i].GotoState('stateDespawn');
		i++;
	}
	return;
}

function SetDoorIcons()
{
	local int i;
	local array<WorldCastleWarMapData> o_npcInfos;

	API_GetWorldCastleWarMapInfo(WCWMNT_Door, o_npcInfos);
	i = 0;
	while((i < o_npcInfos.Length))
	{
		MoveIcon(GetDoorIcon(i), o_npcInfos[i].Location);
		GetDoorIcon(i).ShowWindow();
		i++;
	}
	return;
}

event OnRegisterEvent()
{
	RegisterEvent((100000 + 973));
	RegisterEvent((100000 + 974));
	RegisterEvent((100000 + 975));
	RegisterEvent((100000 + 976));
	RegisterEvent((100000 + 977));
	RegisterEvent((100000 + 978));
	RegisterEvent(9750);
	return;
}

event OnLoad()
{
	Initialize();
	SetClosingOnESC();
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9750:
			EndWorldSiege();
			SetDoorIcons();
			break;
		case (100000 + 973):
			Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_OCCUPY_INFO();
			break;
		case (100000 + 974):
			Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_INFO();
			break;
		case (100000 + 975):
			Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_USER();
			break;
		case (100000 + 976):
			Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_SIEGE_GOLEM_INFO();
			break;
		case (100000 + 977):
			Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_DOOR_INFO();
			break;
		case (100000 + 978):
			Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO();
			break;
		default:
			break;
	}
	return;
}

event OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 0:
			MoveIcon(Icon_PC, GetPlayerPosition(), (500.0000000 / 1000.0000000));
			break;
		case 1:
			bHUDInfoReq = false;
			m_hOwnerWnd.KillTimer(TimerID);
			break;
		case 2:
			DeleteHeroWeapons();
			m_hOwnerWnd.KillTimer(TimerID);
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	MoveIcon(Icon_PC, GetPlayerPosition(), 0.0000000);
	Me.SetTimer(0, 500);
	m_hOwnerWnd.SetFocus();
	API_C_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO();
	return;
}

event OnHide()
{
	Me.KillTimer(0);
	return;
}

function Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_OCCUPY_INFO()
{
	local UIPacket._S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_OCCUPY_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_OCCUPY_INFO(packet))
	{
		return;
	}
	if(!ChkCastleID(packet.nCastleID))
	{
		return;
	}
	Debug(("packet.lstWorldCastleWar_MainBattleOccupyInfoList:" @ string(packet.lstWorldCastleWar_MainBattleOccupyInfoList.Length)));
	SetOccupyInfos(packet.lstWorldCastleWar_MainBattleOccupyInfoList);
	return;
}

function SetOccupyInfos(array<UIPacket._WorldCastleWar_MainBattleOccupyInfo> occupyInfos)
{
	local int i, Index, Key;
	local UIPacket._WorldCastleWar_MainBattleOccupyInfo occupyInfo;

	i = 0;
	while((i < occupyInfos.Length))
	{
		occupyInfo = occupyInfos[i];
		Key = occupyInfo.nOccupyNPCSID;
		Index = int(mapObjOccupy.Find(INT64(Key)));
		Debug((((("SetOccupyInfos Start" @ string(occupyInfo.nOccypyNPCState)) @ string(Index)) @ string(mapObjOccupy.Size())) @ string(occupyInfo.nOccupyNPCClassID)));
		if((occupyInfo.nOccypyNPCState == 0))
		{
			if((Index == -1))
			{
				i++;
				continue;
			}
			mapObjOccupy.Remove(INT64(Key));
		}
		if((Index == -1))
		{
			Index = DespawnOccupiedDespawnStateOccupy(PositionToVector(occupyInfo.nOccypyNPCLocation));
			if((Index != -1))
			{
				Debug(("겹치는 위치 입니다. 해당 위치에 있었던 점령체는 지워 버립니다." @ string(worldSiegeBoardOcptnObjects[Index].sID)));  // EN?: Overlapping positions. Occupants in these positions will be erased.
				mapObjOccupy.Remove(INT64(worldSiegeBoardOcptnObjects[Index].sID));
				worldSiegeBoardOcptnObjects[Index].GotoState('stateDespawn');
			}
			if((Index == -1))
			{
				Index = FindDespawnOccupy();
			}
			if((Index == -1))
			{
				i++;
				continue;
			}
			mapObjOccupy.Add(INT64(Key), INT64(Index));
		}
		Debug((((("SetOccupyInfos :" @ string(occupyInfo.nOccypyNPCState)) @ string(Index)) @ "/") @ string(Key)));
		worldSiegeBoardOcptnObjects[Index]._SetMainBattleOccupyInfo(occupyInfo);
		MoveIcon(GetOccpyIcon(Index), PositionToVector(occupyInfo.nOccypyNPCLocation));
		i++;
	}
	return;
}

function int DespawnOccupiedDespawnStateOccupy(Vector worldLoc)
{
	local int i, dist;
	local Vector Loc;

	i = 0;
	while((i < worldSiegeBoardOcptnObjects.Length))
	{
		Loc = worldSiegeBoardOcptnObjects[i].Loc;
		dist = int(Sqrt(float((((int((Loc.X - worldLoc.X)) ^ int((2.0000000 + (Loc.Y - worldLoc.Y)))) ^ int((2.0000000 + (Loc.Z - worldLoc.Z)))) ^ 2))));
		Debug(("거리 재기 " @ string(dist)));  // EN?: Distance Measurement
		if(((dist < 5) && (dist > -5)))
		{
			Debug(((("가까움 :" @ string(i)) @ "/") @ string(dist)));  // EN?: Close
			return i;
		}
		i++;
	}
	return -1;
}

function int FindDespawnOccupy()
{
	local int i;

	i = 0;
	while((i < worldSiegeBoardOcptnObjects.Length))
	{
		if((worldSiegeBoardOcptnObjects[i].GetStateName() == 'stateDespawn'))
		{
			return i;
		}
		i++;
	}
	return -1;
}

function Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_INFO()
{
	local UIPacket._S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_INFO(packet))
	{
		return;
	}
	if(!ChkCastleID(packet.nCastleID))
	{
		return;
	}
	Debug(("packet.lstWorldCastleWar_MainBattleHeroWeaponInfoList:" @ string(packet.lstWorldCastleWar_MainBattleHeroWeaponInfoList.Length)));
	SetHeroWeaponInfos(packet.lstWorldCastleWar_MainBattleHeroWeaponInfoList);
	return;
}

function SetHeroWeaponInfos(array<UIPacket._WorldCastleWar_MainBattleHeroWeaponInfo> heroWeaponIfnos, optional bool isAll)
{
	local int i, Key, Index;
	local UIPacket._WorldCastleWar_MainBattleHeroWeaponInfo heroWeaponInfo;
	local Vector Loc;

	if(isAll)
	{
		HideAllHeroIcons();
		mapObjHeroWeapon.RemoveAll();
	}
	i = 0;
	while((i < heroWeaponIfnos.Length))
	{
		heroWeaponInfo = heroWeaponIfnos[i];
		Key = heroWeaponInfo.nHeroWeaponNPCSID;
		Index = int(mapObjHeroWeapon.Find(INT64(Key)));
		if((heroWeaponInfo.nHeroWeaponNPCState == 0))
		{
			if((Index == -1))
			{
				i++;
				continue;
			}
			GetHeroIcon(Index).HideWindow();
			i++;
			continue;
		}
		Index = FindDespawnHeroWeapon();
		if((Index == -1))
		{
			Debug("영웅 무기 리스트가 다 참");  // EN?: Heroes' Weapons List is Complete
			i++;
			continue;
		}
		mapObjHeroWeapon.Add(INT64(Key), INT64(Index));
		GetHeroIcon(Index).ShowWindow();
		Loc = PositionToVector(heroWeaponInfo.nHeroWeaponNPCLocation);
		MoveIcon(GetHeroIcon(Index), Loc);
		if(!isAll)
		{
			GetHeroIcon(Index).SetAlpha(0);
			GetHeroIcon(Index).SetAlpha(255, 0.5000000);
		}
		i++;
	}
	return;
}

function int FindDespawnHeroWeapon()
{
	local int i;

	i = 0;
	while((i < 5))
	{
		if(!GetHeroIcon(i).IsShowWindow())
		{
			return i;
		}
		i++;
	}
	return -1;
}

function Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_USER()
{
	local UIPacket._S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_USER packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HERO_WEAPON_USER(packet))
	{
		return;
	}
	if(!ChkCastleID(packet.nCastleID))
	{
		return;
	}
	if((packet.lstWorldCastleWar_MainBattleHeroWeaponUserInfoList.Length > 0))
	{
		m_hOwnerWnd.KillTimer(2);
		m_hOwnerWnd.SetTimer(2, 12000);
		Debug(("packet.lstWorldCastleWar_MainBattleHeroWeaponUserInfoList:" @ string(packet.lstWorldCastleWar_MainBattleHeroWeaponUserInfoList.Length)));
	}
	SetHeroWeaponUserInfos(packet.lstWorldCastleWar_MainBattleHeroWeaponUserInfoList);
	return;
}

function SetHeroWeaponUserInfos(array<UIPacket._WorldCastleWar_MainBattleHeroWeaponUserInfo> heroWeaponUserInfos)
{
	local int i, Key, Index, Len;
	local UIPacket._WorldCastleWar_MainBattleHeroWeaponUserInfo heroWeaponUserInfo;
	local Vector Loc;
	local UIMapInt64Object usedKey;

	usedKey = new Class'InterfaceClassic.UIMapInt64Object';
	i = 0;
	while((i < heroWeaponUserInfos.Length))
	{
		heroWeaponUserInfo = heroWeaponUserInfos[i];
		Loc = PositionToVector(heroWeaponUserInfo.nHeroWeaponUserLocation);
		Key = heroWeaponUserInfo.nHeroWeaponUserSID;
		Index = int(mapObjHeroWeaponUser.Find(INT64(Key)));
		if((Index > -1))
		{
			mapObjHeroWeaponUser.Remove(INT64(Key));
			MoveIcon(GetHeroPCIcon(Index), Loc, 1.0000000);
			GetHeroPCIcon(Index).ShowWindow();
		}
		else
		{
			Index = GetEmptyHeroWeaponIndex();
			if((Index == -1))
			{
				Debug("히어로 웨폰 아이콘들 전부 사용 중");  // EN?: Hero Weapon Icons all in use
				i++;
				continue;
			}
			MoveIcon(GetHeroPCIcon(Index), Loc);
			ShowHeroPCIcon(Index, heroWeaponUserInfo.sHeroWeaponUserName);
		}
		usedKey.Add(INT64(Key), INT64(Index));
		i++;
	}
	Len = mapObjHeroWeaponUser.Size();
	i = 0;
	while((i < Len))
	{
		Index = int(mapObjHeroWeaponUser.dataArray[0].Data);
		GetHeroPCIcon(Index).HideWindow();
		mapObjHeroWeaponUser.dataArray.Remove(0, 1);
		i++;
	}
	i = 0;
	while((i < usedKey.Size()))
	{
		Key = int(usedKey.dataArray[i].Key);
		Index = int(usedKey.dataArray[i].Data);
		mapObjHeroWeaponUser.Add(INT64(Key), INT64(Index));
		i++;
	}
	return;
}

function DeleteHeroWeapons()
{
	local array<UIPacket._WorldCastleWar_MainBattleHeroWeaponUserInfo> heroWeaponUserInfos;

	SetHeroWeaponUserInfos(heroWeaponUserInfos);
	return;
}

function ShowHeroPCIcon(int Index, string tooltipStr)
{
	GetHeroPCIcon(Index).SetTooltipCustomType(MakeTooltipSimpleText(tooltipStr));
	GetHeroPCIcon(Index).SetAlpha(0);
	GetHeroPCIcon(Index).ShowWindow();
	GetHeroPCIcon(Index).SetAlpha(255, 0.5000000);
	return;
}

function int GetEmptyHeroWeaponIndex()
{
	local int i;

	i = 0;
	while((i < 5))
	{
		if(!GetHeroPCIcon(i).IsShowWindow())
		{
			return i;
		}
		i++;
	}
	return -1;
}

function Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_SIEGE_GOLEM_INFO()
{
	local UIPacket._S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_SIEGE_GOLEM_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_SIEGE_GOLEM_INFO(packet))
	{
		return;
	}
	if(!ChkCastleID(packet.nCastleID))
	{
		return;
	}
	Debug(("packet.lstWorldCastleWar_MainBattleSiegeGolemInfoList:" @ string(packet.lstWorldCastleWar_MainBattleSiegeGolemInfoList.Length)));
	SetSiegeGolemInfos(packet.lstWorldCastleWar_MainBattleSiegeGolemInfoList);
	return;
}

function SetSiegeGolemInfos(array<UIPacket._WorldCastleWar_MainBattleSiegeGolemInfo> siegeGolemInfos, optional bool isAll)
{
	local int i, Key, Index;
	local UIPacket._WorldCastleWar_MainBattleSiegeGolemInfo siegeGolemInfo;
	local Vector Loc;

	if(isAll)
	{
		HideAllNPCIcons();
		mapObjGolem.RemoveAll();
	}
	i = 0;
	while((i < siegeGolemInfos.Length))
	{
		siegeGolemInfo = siegeGolemInfos[i];
		Key = siegeGolemInfo.nSiegeGolemNPCSID;
		Index = int(mapObjGolem.Find(INT64(Key)));
		Debug(((string(i) @ "골렘 상태 ") @ string(siegeGolemInfo.nSiegeGolemNPCState)));  // EN?: Golem Status
		if((siegeGolemInfo.nSiegeGolemNPCState == 0))
		{
			if((Index == -1))
			{
				i++;
				continue;
			}
			GetGolemIcon(Index).HideWindow();
			i++;
			continue;
		}
		Index = FindGolemDespawn();
		if((Index == -1))
		{
			Debug("골렘이 꽉참");  // EN?: Golem is full
			i++;
			continue;
		}
		mapObjGolem.Add(INT64(Key), INT64(Index));
		Loc = PositionToVector(siegeGolemInfo.nSiegeGolemNPCLocation);
		MoveIcon(GetGolemIcon(Index), Loc);
		GetGolemIcon(Index).ShowWindow();
		if(!isAll)
		{
			GetGolemIcon(Index).SetAlpha(0);
			GetGolemIcon(Index).SetAlpha(255, 0.5000000);
		}
		i++;
	}
	return;
}

function int FindGolemDespawn()
{
	local int i;

	i = 0;
	while((i < 3))
	{
		if(!GetGolemIcon(i).IsShowWindow())
		{
			return i;
		}
		i++;
	}
	return -1;
}

function Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_DOOR_INFO()
{
	local UIPacket._S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_DOOR_INFO packet;

	Debug("Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_DOOR_INFO");
	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_DOOR_INFO(packet))
	{
		return;
	}
	if(!ChkCastleID(packet.nCastleID))
	{
		return;
	}
	Debug(("packet.lstWorldCastleWar_MainBattleDoorInfoList:" @ string(packet.lstWorldCastleWar_MainBattleDoorInfoList.Length)));
	SetDoorInfos(packet.lstWorldCastleWar_MainBattleDoorInfoList);
	return;
}

function SetDoorInfos(array<UIPacket._WorldCastleWar_MainBattleDoorInfo> doorInfos)
{
	local int i, j, DoorState;
	local array<WorldCastleWarMapData> o_npcInfos;

	API_GetWorldCastleWarMapInfo(WCWMNT_Door, o_npcInfos);
	Debug(("SetDoorInfos" @ string(o_npcInfos.Length)));
	i = 0;
	while((i < o_npcInfos.Length))
	{
		DoorState = -1;
		j = 0;
		while((j < doorInfos.Length))
		{
			if((o_npcInfos[i].ClassID == doorInfos[j].nDoorStaticObjectID))
			{
				Debug((("같은 ID 찾음 문 상태는 - " @ string(doorInfos[j].nDoorState)) @ string(o_npcInfos[i].ClassID)));  // EN?: Identical ID found statement status is -
				DoorState = doorInfos[j].nDoorState;
				break;
			}
			j++;
		}
		if((DoorState == -1))
		{
			i++;
			continue;
		}
		else if((DoorState == 1))
		{
			Debug(((GetDoorIcon(i).GetTextureName() @ "/") @ "L2UI_EPIC.WorldSiegeWnd.WorldSiegeWnd_CastleGateBroken_Normal"));
			if(("WorldSiegeWnd_CastleGateBroken_Normal" != GetDoorIcon(i).GetTextureName()))
			{
				GetDoorIcon(i).SetAlpha(0);
				GetDoorIcon(i).SetTexture("L2UI_EPIC.WorldSiegeWnd.WorldSiegeWnd_CastleGateBroken_Normal");
			}
		}
		else
		{
			Debug(((GetDoorIcon(i).GetTextureName() @ "/") @ "L2UI_EPIC.WorldSiegeWnd.WorldSiegeWnd_CastleGate_Normal"));
			if(("WorldSiegeWnd_CastleGate_Normal" != GetDoorIcon(i).GetTextureName()))
			{
				GetDoorIcon(i).SetAlpha(0);
				GetDoorIcon(i).SetTexture("L2UI_EPIC.WorldSiegeWnd.WorldSiegeWnd_CastleGate_Normal");
			}
		}
		GetDoorIcon(i).ShowWindow();
		GetDoorIcon(i).SetAlpha(255, 0.5000000);
		i++;
	}
	return;
}

function Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO()
{
	local UIPacket._S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO packet;

	Debug("Handle_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO");
	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO(packet))
	{
		return;
	}
	if(!ChkCastleID(packet.nCastleID))
	{
		return;
	}
	Debug("HUD_INFO ---------------------------------------- start");
	Debug(("HUD_INFO 점 령 체 - " @ string(packet.lstWorldCastleWar_MainBattleOccupyInfoList.Length)));  // EN?: HUD_info Occupied Body -
	Debug(("HUD_INFO 영웅무기 - " @ string(packet.lstWorldCastleWar_MainBattleHeroWeaponInfoList.Length)));  // EN?: HUD_info Hero Weapon -
	Debug(("HUD_INFO 영    웅 - " @ string(packet.lstWorldCastleWar_MainBattleHeroWeaponUserInfoList.Length)));  // EN?: HUD_info Young Ung -
	Debug(("HUD_INFO 골    렘 - " @ string(packet.lstWorldCastleWar_MainBattleSiegeGolemInfoList.Length)));  // EN?: HUD_info Golem -
	Debug(("HUD_INFO 성    벽 - " @ string(packet.lstWorldCastleWar_MainBattleDoorInfoList.Length)));  // EN?: HUD_info Walls -
	Debug("HUD_INFO ---------------------------------------- end");
	SetOccupyInfos(packet.lstWorldCastleWar_MainBattleOccupyInfoList);
	SetHeroWeaponInfos(packet.lstWorldCastleWar_MainBattleHeroWeaponInfoList, true);
	SetHeroWeaponUserInfos(packet.lstWorldCastleWar_MainBattleHeroWeaponUserInfoList);
	SetSiegeGolemInfos(packet.lstWorldCastleWar_MainBattleSiegeGolemInfoList, true);
	SetDoorInfos(packet.lstWorldCastleWar_MainBattleDoorInfoList);
	return;
}

function EndWorldSiege()
{
	m_hOwnerWnd.HideWindow();
	HideAllOccupation();
	HideAllHeroIcons();
	HIdeAllHeroIconPCs();
	HideAllNPCIcons();
	HideAllGateIcons();
	mapObjOccupy.RemoveAll();
	mapObjHeroWeapon.RemoveAll();
	mapObjHeroWeaponUser.RemoveAll();
	mapObjGolem.RemoveAll();
	return;
}

function HideAllHeroIcons()
{
	local int i;

	i = 0;
	while((i < 5))
	{
		GetHeroIcon(i).HideWindow();
		i++;
	}
	return;
}

function HIdeAllHeroIconPCs()
{
	local int i;

	i = 0;
	while((i < 5))
	{
		GetHeroPCIcon(i).HideWindow();
		i++;
	}
	return;
}

function HideAllNPCIcons()
{
	local int i;

	i = 0;
	while((i < 3))
	{
		GetGolemIcon(i).HideWindow();
		i++;
	}
	return;
}

function HideAllGateIcons()
{
	local int i;

	i = 0;
	while((i < 3))
	{
		GetDoorIcon(i).HideWindow();
		i++;
	}
	return;
}

function HideAllOccupation()
{
	local int i;

	i = 0;
	while((i < worldSiegeBoardOcptnObjects.Length))
	{
		worldSiegeBoardOcptnObjects[i].GotoState('stateDespawn');
		worldSiegeBoardOcptnObjects[i].SendHideOccupyInfoRadar();
		i++;
	}
	return;
}

function WindowHandle GetOccpyIcon(int Index)
{
	return GetWindowHandle(((m_Windowname $ ".WorldSegeMapWnd.Icon_ocptnObjectWnd") $ Int2Str(Index)));
}

function TextureHandle GetHeroIcon(int Index)
{
	return GetTextureHandle(((m_Windowname $ ".WorldSegeMapWnd.Icon_Hero") $ Int2Str(Index)));
}

function TextureHandle GetHeroPCIcon(int Index)
{
	return GetTextureHandle(((m_Windowname $ ".WorldSegeMapWnd.Icon_HeroPC") $ Int2Str(Index)));
}

function TextureHandle GetGolemIcon(int Index)
{
	return GetTextureHandle(((m_Windowname $ ".WorldSegeMapWnd.Icon_NPC") $ Int2Str(Index)));
}

function TextureHandle GetDoorIcon(int Index)
{
	return GetTextureHandle(((m_Windowname $ ".WorldSegeMapWnd.Icon_CastleGate0") $ Int2Str(Index)));
}

function MoveIcon(WindowHandle Icon, Vector worldLoc, optional float Second)
{
	local Vector mapPoint;
	local Rect rectMap, rectIcon;

	rectMap = Map_tex.GetRect();
	rectIcon = Icon.GetRect();
	mapPoint = GetMinimapPosFromWorldLoc(worldLoc);
	Icon.Move(int((mapPoint.X - float(((rectIcon.nX - rectMap.nX) + (rectIcon.nWidth / 2))))), int((mapPoint.Y - float(((rectIcon.nY - rectMap.nY) + (rectIcon.nHeight / 2))))), Second);
	return;
}

function HandlePos(string param)
{
	local Vector Loc;

	Loc = ParseVector(param);
	Loc = GetPlayerPosition();
	GetMinimapPosFromWorldLoc(Loc);
	return;
}

function SetIconPos(TextureHandle Icon, Vector Loc)
{
	local Vector mapPos;

	mapPos = GetMinimapPosFromWorldLoc(Loc);
	Icon.MoveTo(int(mapPos.X), int(mapPos.Y));
	return;
}

function API_C_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO packet;

	if(bHUDInfoReq)
	{
		return;
	}
	bHUDInfoReq = true;
	m_hOwnerWnd.SetTimer(1, 3000);
	packet.nCastleID = GetCastleID();
	if(Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_WORLDCASTLEWAR_SIEGE_MAINBATTLE_HUD_INFO(stream, packet))
	{
		Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(745, stream);
	}
	return;
}

function API_GetWorldCastleWarMapInfo(UIEventManager.EWorldCastleWarMapNPCType a_npcType, out array<WorldCastleWarMapData> o_npcInfo)
{
	GetWorldCastleWarMapInfo(a_npcType, o_npcInfo);
	return;
}

function Vector PositionToVector(UIPacket._Position pos)
{
	local Vector wolrdPoint;

	wolrdPoint.X = float(pos.X);
	wolrdPoint.Y = float(pos.Y);
	wolrdPoint.Z = float(pos.Z);
	return wolrdPoint;
}

function bool IsSameVector(Vector vec0, Vector vec1)
{
	return (vec0 == vec1);
}

function bool ChkCastleID(int castleID)
{
	return (castleID == GetCastleID());
}

function int GetCastleID()
{
	return Class'InterfaceClassic.WorldSiegeWnd'.static.Inst().GetCastleIDSelected();
}

function Vector GetMinimapPosFromWorldLoc(Vector wlorldLoc)
{
	local Vector mapPosition;

	mapPosition.X = ((wlorldLoc.X - startLoc.X) * 0.0312000);
	mapPosition.Y = ((wlorldLoc.Y - startLoc.Y) * 0.0312000);
	return mapPosition;
}

function Vector ParseVector(string param)
{
	local Vector Loc;
	local int X, Y, Z;

	ParseInt(param, "x", X);
	ParseInt(param, "y", Y);
	ParseInt(param, "z", Z);
	Loc.X = float(X);
	Loc.Y = float(Y);
	Loc.Z = float(Z);
	return Loc;
}

function string Int2Str(int i)
{
	if((i < 10))
	{
		return ("0" $ string(i));
	}
	return string(i);
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	Me.HideWindow();
	return;
}
