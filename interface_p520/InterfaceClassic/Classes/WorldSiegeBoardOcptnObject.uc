class WorldSiegeBoardOcptnObject extends UIScript
	dependson(UIPacket);

const STATE_DESPAWN = 'stateDespawn';
const STATE_NotOccupied = 'stateNotOccupied';
const STATE_ATTACKED = 'stateAttacked';
const STATE_OCCUPIED = 'stateOccupied';
const STATE_OCCUPIEDDESPAWN = 'stateOccupiedDespawn';
const TIMER_ID_DESPAWN = 0;
const TIMER_TIME_DESPAWN = 180000;

var int sID;
var int ClassID;
var WorldSiegeBoardWnd worldSiegeBoardWndScr;
var TextureHandle Icon_ocptnFlag;
var TextureHandle PledgeCrest_tex;
var AnimTextureHandle Glow_ani;
var int PledgeID;
var Vector Loc;
var int Index;
var int Tier;
var bool IsMouseOver;

static function WorldSiegeBoardOcptnObject InitScript(WindowHandle wnd, int idx)
{
	local WorldSiegeBoardOcptnObject Script;

	wnd.SetScript("WorldSiegeBoardOcptnObject");
	Script = WorldSiegeBoardOcptnObject(wnd.GetScript());
	Script.Index = idx;
	Script.InitWnd(wnd);
	return Script;
}

function InitWnd(WindowHandle Window)
{
	m_hOwnerWnd = Window;
	worldSiegeBoardWndScr = WorldSiegeBoardWnd(GetScript("WorldSiegeBoardWnd"));
	Icon_ocptnFlag = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Icon_ocptnFlag"));
	PledgeCrest_tex = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".PledgeCrest_tex"));
	Glow_ani = GetAnimTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Glow_ani"));
	return;
}

event OnMouseOver(WindowHandle a_WindowHandle)
{
	IsMouseOver = true;
	SetTexture();
	return;
}

event OnMouseOut(WindowHandle a_WindowHandle)
{
	IsMouseOver = false;
	SetTexture();
	return;
}

event OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 0:
			m_hOwnerWnd.KillTimer(0);
			GotoState('stateDespawn');
			break;
		default:
			break;
	}
	return;
}

function SetTier(int ClassID)
{
	local int i;
	local array<WorldCastleWarMapData> o_npcInfo;

	API_GetWorldCastleWarMapInfo(o_npcInfo);
	i = 0;
	while((i < o_npcInfo.Length))
	{
		if((o_npcInfo[i].ClassID == (ClassID - 1000000)))
		{
			Tier = o_npcInfo[i].Tier;
			SetTexture();
		}
		i++;
	}
	return;
}

function SendOccupyInfoRadar(UIPacket._WorldCastleWar_MainBattleOccupyInfo occupyInfo)
{
	local string param;

	param = "";
	ParamAdd(param, "index", string(Index));
	ParamAdd(param, "tier", string(Tier));
	ParamAdd(param, "sID", string(sID));
	ParamAdd(param, "state", string(occupyInfo.nOccypyNPCState));
	ParamAdd(param, "x", string(occupyInfo.nOccypyNPCLocation.X));
	ParamAdd(param, "y", string(occupyInfo.nOccypyNPCLocation.Y));
	ParamAdd(param, "z", string(occupyInfo.nOccypyNPCLocation.Z));
	ParamAdd(param, "pledgeID", string(PledgeID));
	ParamAdd(param, "pledgeName", Class'NWindow.UIDATA_CLAN'.static.GetName(PledgeID));
	ParamAdd(param, "pledgeTextureName", PledgeCrest_tex.GetTextureName());
	CallGFxFunction("RadarMapWnd", "WorldSiege_occupyInfo", param);
	return;
}

function SendHideOccupyInfoRadar()
{
	local string param;

	param = "";
	ParamAdd(param, "index", string(Index));
	ParamAdd(param, "tier", string(Tier));
	ParamAdd(param, "sID", string(sID));
	ParamAdd(param, "state", string(0));
	ParamAdd(param, "x", string(0));
	ParamAdd(param, "y", string(0));
	ParamAdd(param, "z", string(0));
	ParamAdd(param, "pledgeID", string(0));
	ParamAdd(param, "pledgeName", "");
	ParamAdd(param, "pledgeTextureName", "");
	CallGFxFunction("RadarMapWnd", "WorldSiege_occupyInfo", param);
	return;
}

function _SetMainBattleOccupyInfo(UIPacket._WorldCastleWar_MainBattleOccupyInfo occupyInfo)
{
	sID = occupyInfo.nOccupyNPCSID;
	if((ClassID != occupyInfo.nOccupyNPCClassID))
	{
		SetTier(occupyInfo.nOccupyNPCClassID);
		ClassID = occupyInfo.nOccupyNPCClassID;
	}
	switch(occupyInfo.nOccypyNPCState)
	{
		case 0:
			if((GetStateName() == 'stateOccupied'))
			{
				GotoState('stateOccupiedDespawn');
			}
			else
			{
				GotoState('stateDespawn');
			}
			break;
		case 1:
			GotoState('stateNotOccupied');
			break;
		case 2:
			GotoState('stateAttacked');
			break;
		case 3:
			PledgeID = occupyInfo.nOccupiedPledgeSID;
			GotoState('stateOccupied');
			break;
		case 4:
			PledgeID = occupyInfo.nOccupiedPledgeSID;
			GotoState('stateOccupiedDespawn');
			break;
		default:
			break;
	}
	Loc = Class'InterfaceClassic.WorldSiegeBoardWnd'.static.Inst().PositionToVector(occupyInfo.nOccypyNPCLocation);
	SendOccupyInfoRadar(occupyInfo);
	return;
}

function SetPledgeID()
{
	local Texture PledgeCrestTexture;

	if(Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(PledgeID, PledgeCrestTexture))
	{
		PledgeCrest_tex.ShowWindow();
		PledgeCrest_tex.SetTextureWithObject(PledgeCrestTexture);
	}
	SetCrestTooltipInfo(PledgeID);
	return;
}

function SetTexture()
{
	if(IsMouseOver)
	{
		Icon_ocptnFlag.SetTexture((("L2UI_EPIC.WorldSiegeWnd.WorldSiegeWnd_Occupation" $ Class'InterfaceClassic.UICommonAPI'.static.getInstanceUIData().Int2Str(Tier)) $ "_Over"));
	}
	else
	{
		Icon_ocptnFlag.SetTexture((("L2UI_EPIC.WorldSiegeWnd.WorldSiegeWnd_Occupation" $ Class'InterfaceClassic.UICommonAPI'.static.getInstanceUIData().Int2Str(Tier)) $ "_Normal"));
	}
	return;
}

function API_GetWorldCastleWarMapInfo(out array<WorldCastleWarMapData> o_npcInfo)
{
	GetWorldCastleWarMapInfo(WCWMNT_Occupy, o_npcInfo);
	return;
}

function Color GetStateColor()
{
	switch(GetStateName())
	{
		case 'stateNotOccupied':
			return Class'InterfaceClassic.L2Util'.static.Inst().White;
		case 'stateAttacked':
			return Class'InterfaceClassic.L2Util'.static.Inst().Red;
		case 'stateOccupied':
			return Class'InterfaceClassic.L2Util'.static.Inst().BWhite;
		case 'stateOccupiedDespawn':
			return Class'InterfaceClassic.L2Util'.static.Inst().BWhite;
		default:
			return Class'InterfaceClassic.L2Util'.static.Inst().White;
	}
}

function string GetStateString()
{
	switch(GetStateName())
	{
		case 'stateDespawn':
			return "";
		case 'stateNotOccupied':
			return GetSystemString(13803);
		case 'stateAttacked':
			return GetSystemString(13804);
		case 'stateOccupied':
			return GetSystemString(13805);
		case 'stateOccupiedDespawn':
			return GetSystemString(13805);
		default:
			return string(GetStateName());
	}
}

function SetCrestTooltipInfo(int PledgeID)
{
	local string PledgeName;
	local Texture PledgeCrestTexture;
	local CustomTooltip mCustomTooltip;
	local DrawItemInfo dTextureInfo;
	local int Index;
	local bool bCrestTexture;

	bCrestTexture = Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(PledgeID, PledgeCrestTexture);
	if(bCrestTexture)
	{
		mCustomTooltip.DrawList.Length = 3;
	}
	else
	{
		mCustomTooltip.DrawList.Length = 2;
	}
	mCustomTooltip.MinimumWidth = 200;
	mCustomTooltip.DrawList[0] = GetStateDrawItemInfo();
	Index = 1;
	if(bCrestTexture)
	{
		dTextureInfo.eType = DIT_TEXTURE;
		dTextureInfo.t_bDrawOneLine = true;
		dTextureInfo.bLineBreak = true;
		dTextureInfo.u_nTextureWidth = 16;
		dTextureInfo.u_nTextureHeight = 12;
		dTextureInfo.u_nTextureUWidth = 16;
		dTextureInfo.u_nTextureUHeight = 12;
		dTextureInfo.u_nTextureV = 4;
		dTextureInfo.u_strTexture = PledgeCrest_tex.GetTextureName();
		mCustomTooltip.DrawList[1] = dTextureInfo;
		Index = 2;
	}
	PledgeName = Class'NWindow.UIDATA_CLAN'.static.GetName(PledgeID);
	mCustomTooltip.DrawList[Index].bLineBreak = !bCrestTexture;
	mCustomTooltip.DrawList[Index].nOffSetX = 2;
	mCustomTooltip.DrawList[Index].eType = DIT_TEXT;
	mCustomTooltip.DrawList[Index].t_bDrawOneLine = true;
	mCustomTooltip.DrawList[Index].t_color = Class'InterfaceClassic.L2Util'.static.Inst().Gold;
	mCustomTooltip.DrawList[Index].t_strText = PledgeName;
	Icon_ocptnFlag.SetTooltipCustomType(mCustomTooltip);
	return;
}

function DrawItemInfo GetStateDrawItemInfo()
{
	local DrawItemInfo dInfo;

	dInfo.eType = DIT_TEXT;
	dInfo.t_bDrawOneLine = true;
	dInfo.t_color = GetStateColor();
	dInfo.t_strText = GetStateString();
	return dInfo;
}

function SetTooltip()
{
	local CustomTooltip mCustomTooltip;

	mCustomTooltip.DrawList[0] = GetStateDrawItemInfo();
	Icon_ocptnFlag.SetTooltipCustomType(mCustomTooltip);
	return;
}

auto state stateDespawn
{
	function BeginState()
	{
		m_hOwnerWnd.SetAlpha(0, 0.5000000);
		PledgeCrest_tex.HideWindow();
		Glow_ani.HideWindow();
		return;
	}

	function EndState()
	{
		m_hOwnerWnd.ShowWindow();
		m_hOwnerWnd.SetAlpha(255, 0.5000000);
		return;
	}
}

state stateNotOccupied
{
	function BeginState()
	{
		SetTooltip();
		return;
	}

	function EndState()
	{
		return;
	}
}

state stateAttacked
{
	function BeginState()
	{
		SetTooltip();
		Glow_ani.ShowWindow();
		Glow_ani.Stop();
		Glow_ani.SetLoopCount(99999);
		Glow_ani.Play();
		return;
	}

	function EndState()
	{
		Glow_ani.HideWindow();
		return;
	}
}

state stateOccupied
{
	function BeginState()
	{
		SetPledgeID();
		Debug(("stateOccupied BeginState" @ string(GetStateName())));
		m_hOwnerWnd.SetAlpha(150, 1.0000000);
		return;
	}

	function EndState()
	{
		PledgeCrest_tex.HideWindow();
		Icon_ocptnFlag.SetAlpha(255, 1.0000000);
		return;
	}
}

state stateOccupiedDespawn
{
	function BeginState()
	{
		Debug(("stateOccupiedDespawn BeginState" @ string(GetStateName())));
		SetPledgeID();
		m_hOwnerWnd.SetTimer(0, 9999999);
		Icon_ocptnFlag.SetColorModify(Class'InterfaceClassic.L2Util'.static.Inst().Gray);
		return;
	}

	function EndState()
	{
		PledgeCrest_tex.HideWindow();
		m_hOwnerWnd.KillTimer(0);
		Icon_ocptnFlag.SetColorModify(Class'InterfaceClassic.L2Util'.static.Inst().BrightWhite);
		return;
	}
}
