class ElementalSpiritWnd extends L2UIGFxScriptNoneContainer
	dependson(UIPacket);

const SPIRIT_TYPE_FIRE = 0;
const SPIRIT_TYPE_WATER = 1;
const SPIRIT_TYPE_WIND = 2;
const SPIRIT_TYPE_EARTH = 3;
const SPIRITTYPECOUNTMAX = 4;

struct ElementalInfo
{
	var int SpiritType;
	var int NpcID;
	var int SpiritClassID;
	var int EvolLevel;
	var INT64 Exp;
	var INT64 NextExp;
	var int CurrLevel;
	var int RemainPoint;
};

var bool bUseSpirit;
var array<ElementalInfo> elementalInfos;

event OnRegisterEvent()
{
	RegisterGFxEvent(10860);
	RegisterGFxEvent(10870);
	RegisterGFxEvent(10871);
	RegisterGFxEvent(10880);
	RegisterGFxEvent(10890);
	RegisterGFxEvent(10900);
	RegisterGFxEvent(10910);
	RegisterGFxEvent(10920);
	RegisterGFxEvent(10930);
	RegisterEvent(180);
	RegisterEvent(10940);
	RegisterEvent(10930);
	RegisterEvent(40);
	RegisterEvent(9750);
	RegisterEvent((100000 + 1073));
	return;
}

event OnLoad()
{
	SetSaveWnd(true, false);
	SetClosingOnESC();
	AddState("GAMINGSTATE");
	SetAnchor("", ANCHORPOINT_CenterCenter, ANCHORPOINT_CenterCenter, 0, 0);
	elementalInfos.Length = 4;
	GetTextureSideElementalHandle(0).HideWindow();
	GetTextureSideElementalHandle(1).HideWindow();
	GetTextureSideElementalHandle(2).HideWindow();
	GetTextureSideElementalHandle(3).HideWindow();
	return;
}

event OnFlashLoaded()
{
	RegisterDelegateHandler(EDHandler_ElementalSpirit);
	RegisterDelegateHandler(EDHandler_Container);
	RegisterDelegateHandler(EDHandler_Default);
	RegisterDelegateHandler(EDHandler_GameData);
	return;
}

event OnShow()
{
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("CardDrawEventWnd"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("CardDrawEventWnd");
	}
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ItemUpgrade"))
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ItemUpgrade");
	}
	super.OnShow();
	L2Util(GetScript("L2Util")).ItemRelationWindowHide(getCurrentWindowName(string(self)));
	Class'InterfaceClassic.SideBar'.static.Inst().ToggleByWindowName(getCurrentWindowName(string(self)), true);
	return;
}

event OnHide()
{
	Class'InterfaceClassic.SideBar'.static.Inst().ToggleByWindowName(getCurrentWindowName(string(self)), false);
	super.OnHide();
	return;
}

event OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 40:
			bUseSpirit = false;
			Class'InterfaceClassic.SideBar'.static.Inst().SetWindowShowHideByIndex(1, false);
			break;
		case 10940:
			HandleEV_ElementalSpiritSimpleInfo(a_Param);
			break;
		case 180:
			if(bUseSpirit)
			{
				SetElementalExps();
			}
			break;
		case 10930:
			HandleEV_ElementalSpiritGetExp(a_Param);
			break;
		case (100000 + 1073):
			RT_S_EX_ELEMENTAL_SPIRIT_ATTACK_TYPE();
			break;
		case 9750:
			bUseSpirit = false;
			break;
		default:
			break;
	}
	return;
}

function _API_RequestElementalSpiritInfo(bool bIsOpen)
{
	local int nIsOpen;

	Debug(("bUseSpirit" @ string(bUseSpirit)));
	if((bUseSpirit == false))
	{
		AddSystemMessage(13827);
		return;
	}
	if(bIsOpen)
	{
		nIsOpen = 1;
	}
	RequestElementalSpiritInfo(nIsOpen);
	return;
}

function HandleEV_ElementalSpiritSimpleInfo(string a_Param)
{
	local int Result, Len, i, NpcID, SpiritClassID, SpiritType, spiritIndex;

	Debug(("HandleSpriteInfo" @ a_Param));
	if((ParseInt(a_Param, "Result", Result) && (Result == 0)))
	{
		return;
	}
	ParseInt(a_Param, "SpiritCount", Len);
	Class'InterfaceClassic.SideBar'.static.Inst().SetAlarmOnOff(1, false);
	i = 0;
	while((i < Len))
	{
		if(!ParseInt(a_Param, ("NpcID_" $ string(i)), NpcID))
		{
			i++;
			continue;
		}
		bUseSpirit = true;
		ParseInt(a_Param, ("SpiritClassID_" $ string(i)), SpiritClassID);
		if(((NpcID == 0) && (SpiritClassID == 0)))
		{
			i++;
			continue;
		}
		ParseInt(a_Param, ("SpiritType_" $ string(i)), SpiritType);
		spiritIndex = (SpiritType - 1);
		elementalInfos[spiritIndex].SpiritType = SpiritType;
		elementalInfos[spiritIndex].NpcID = NpcID;
		elementalInfos[spiritIndex].SpiritClassID = SpiritClassID;
		ParseInt(a_Param, ("EvolLevel_" $ string(i)), elementalInfos[spiritIndex].EvolLevel);
		ParseINT64(a_Param, ("Exp_" $ string(i)), elementalInfos[spiritIndex].Exp);
		ParseINT64(a_Param, ("NextExp_" $ string(i)), elementalInfos[spiritIndex].NextExp);
		ParseInt(a_Param, ("CurrLevel_" $ string(i)), elementalInfos[spiritIndex].CurrLevel);
		ParseInt(a_Param, ("RemainPoint_" $ string(i)), elementalInfos[spiritIndex].RemainPoint);
		i++;
	}
	SetElementalExps();
	if((GetGameStateName() != "GAMINGSTATE"))
	{
		return;
	}
	if(!bUseSpirit)
	{
		Class'InterfaceClassic.SideBar'.static.Inst().SetWindowShowHideByIndex(1, false);
	}
	else
	{
		Class'InterfaceClassic.SideBar'.static.Inst().SetWindowShowHideByIndex(1, getInstanceUIData().GetIsClassicServer());
	}
	i = 0;
	while((i < elementalInfos.Length))
	{
		if((elementalInfos[i].RemainPoint > 0))
		{
			Class'InterfaceClassic.SideBar'.static.Inst().SetAlarmOnOff(1, true);
			break;
		}
		i++;
	}
	return;
}

function HandleEV_ElementalSpiritGetExp(string a_Param)
{
	local int Type;

	ParseInt(a_Param, "Type", Type);
	ParseINT64(a_Param, "Exp", elementalInfos[(Type - 1)].Exp);
	SetElementalExps();
	return;
}

function SetElementalExps()
{
	local string nickname;
	local int CurrLevel, i;
	local DrawItemInfo Info, infoTexture;
	local CustomTooltip ToolTip;
	local bool isRemain;
	local UserInfo UserInfo;

	Info.eType = DIT_TEXT;
	Info.t_bDrawOneLine = true;
	i = 0;
	while((i < elementalInfos.Length))
	{
		isRemain = (elementalInfos[i].RemainPoint > 0);
		if(isRemain)
		{
			infoTexture.u_strTexture = "L2UI_NewTex.SideBar.ElementalPoint_Plus";
		}
		else
		{
			infoTexture.u_strTexture = "L2UI_NewTex.SideBar.ElementalPoint_Unable";
		}
		infoTexture.eType = DIT_TEXTURE;
		infoTexture.t_bDrawOneLine = true;
		infoTexture.u_nTextureWidth = 8;
		infoTexture.u_nTextureHeight = 8;
		infoTexture.nOffSetX = 0;
		infoTexture.nOffSetY = 3;
		infoTexture.u_nTextureUWidth = 8;
		infoTexture.u_nTextureUHeight = 8;
		infoTexture.bLineBreak = true;
		infoTexture.eAlignType = DIAT_LEFT;
		ToolTip.DrawList[ToolTip.DrawList.Length] = infoTexture;
		CurrLevel = elementalInfos[i].CurrLevel;
		nickname = Class'NWindow.UIDATA_NPC'.static.GetNPCNickName(elementalInfos[i].NpcID);
		Info.t_strText = (((GetSystemString(88) $ ".") $ string(CurrLevel)) @ nickname);
		Info.t_color = Class'InterfaceClassic.L2Util'.static.Inst().BrightWhite;
		Info.eAlignType = DIAT_LEFT;
		Info.nOffSetX = 5;
		Info.bLineBreak = false;
		ToolTip.DrawList[ToolTip.DrawList.Length] = Info;
		GetPlayerInfo(UserInfo);
		switch((elementalInfos[i].SpiritType - 1))
		{
			case 0:
				Info.t_strText = ((GetSystemString(55) $ ":") $ string(UserInfo.nFireAttack));
				Info.t_color = Class'InterfaceClassic.L2Util'.static.Inst().Yellow;
				Info.bLineBreak = false;
				Info.eAlignType = DIAT_LEFT;
				ToolTip.DrawList[ToolTip.DrawList.Length] = Info;
				Info.t_strText = " / ";
				Info.t_color = Class'InterfaceClassic.L2Util'.static.Inst().White;
				Info.bLineBreak = false;
				Info.eAlignType = DIAT_LEFT;
				ToolTip.DrawList[ToolTip.DrawList.Length] = Info;
				Info.t_strText = ((GetSystemString(54) $ ":") $ string(UserInfo.nFireDefend));
				Info.t_color = Class'InterfaceClassic.L2Util'.static.Inst().MintGreen;
				Info.bLineBreak = false;
				Info.eAlignType = DIAT_LEFT;
				ToolTip.DrawList[ToolTip.DrawList.Length] = Info;
				break;
			case 1:
				Info.t_strText = ((GetSystemString(55) $ ":") $ string(UserInfo.nWaterAttack));
				Info.t_color = Class'InterfaceClassic.L2Util'.static.Inst().Yellow;
				Info.bLineBreak = false;
				Info.eAlignType = DIAT_LEFT;
				ToolTip.DrawList[ToolTip.DrawList.Length] = Info;
				Info.t_strText = " / ";
				Info.t_color = Class'InterfaceClassic.L2Util'.static.Inst().White;
				Info.bLineBreak = false;
				Info.eAlignType = DIAT_LEFT;
				ToolTip.DrawList[ToolTip.DrawList.Length] = Info;
				Info.t_strText = ((GetSystemString(54) $ ":") $ string(UserInfo.nWaterDefend));
				Info.t_color = Class'InterfaceClassic.L2Util'.static.Inst().MintGreen;
				Info.bLineBreak = false;
				Info.eAlignType = DIAT_LEFT;
				ToolTip.DrawList[ToolTip.DrawList.Length] = Info;
				break;
			case 2:
				Info.t_strText = ((GetSystemString(55) $ ":") $ string(UserInfo.nWindAttack));
				Info.t_color = Class'InterfaceClassic.L2Util'.static.Inst().Yellow;
				Info.bLineBreak = false;
				Info.eAlignType = DIAT_LEFT;
				ToolTip.DrawList[ToolTip.DrawList.Length] = Info;
				Info.t_strText = " / ";
				Info.t_color = Class'InterfaceClassic.L2Util'.static.Inst().White;
				Info.bLineBreak = false;
				Info.eAlignType = DIAT_LEFT;
				ToolTip.DrawList[ToolTip.DrawList.Length] = Info;
				Info.t_strText = ((GetSystemString(54) $ ":") $ string(UserInfo.nWindDefend));
				Info.t_color = Class'InterfaceClassic.L2Util'.static.Inst().MintGreen;
				Info.bLineBreak = false;
				Info.eAlignType = DIAT_LEFT;
				ToolTip.DrawList[ToolTip.DrawList.Length] = Info;
				break;
			case 3:
				Info.t_strText = ((GetSystemString(55) $ ":") $ string(UserInfo.nEarthAttack));
				Info.t_color = Class'InterfaceClassic.L2Util'.static.Inst().Yellow;
				Info.bLineBreak = false;
				Info.eAlignType = DIAT_LEFT;
				ToolTip.DrawList[ToolTip.DrawList.Length] = Info;
				Info.t_strText = " / ";
				Info.t_color = Class'InterfaceClassic.L2Util'.static.Inst().White;
				Info.bLineBreak = false;
				Info.eAlignType = DIAT_LEFT;
				ToolTip.DrawList[ToolTip.DrawList.Length] = Info;
				Info.t_strText = ((GetSystemString(54) $ ":") $ string(UserInfo.nEarthDefend));
				Info.t_color = Class'InterfaceClassic.L2Util'.static.Inst().MintGreen;
				Info.bLineBreak = false;
				Info.eAlignType = DIAT_LEFT;
				ToolTip.DrawList[ToolTip.DrawList.Length] = Info;
				break;
			default:
				break;
		}
		i++;
	}
	Class'InterfaceClassic.SideBar'.static.Inst().GetWindowByIndex(1).SetTooltipCustomType(ToolTip);
	return;
}

function RT_S_EX_ELEMENTAL_SPIRIT_ATTACK_TYPE()
{
	local UIPacket._S_EX_ELEMENTAL_SPIRIT_ATTACK_TYPE packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_ELEMENTAL_SPIRIT_ATTACK_TYPE(packet))
	{
		return;
	}
	CheckElementalActive(packet.cBitset);
	return;
}

function ResetElementalSpirits()
{
	return;
}

function CheckElementalActive(int bitSet)
{
	local int i, multiple;

	i = 0;
	while((i < 4))
	{
		multiple = ExpInt(2, i);
		if(((bitSet & multiple) > 0))
		{
			GetTextureSideElementalHandle(i).ShowWindow();
			i++;
			continue;
		}
		GetTextureSideElementalHandle(i).HideWindow();
		i++;
	}
	return;
}

function TextureHandle GetTextureSideElementalHandle(int Index)
{
	switch(Index)
	{
		case 0:
			return GetTextureHandle("SideBar.BtnElementalSpiritWnd.Icon_FireOn");
		case 1:
			return GetTextureHandle("SideBar.BtnElementalSpiritWnd.Icon_WaterOn");
		case 2:
			return GetTextureHandle("SideBar.BtnElementalSpiritWnd.Icon_WindOn");
		case 3:
			return GetTextureHandle("SideBar.BtnElementalSpiritWnd.Icon_EarthOn");
		default:
			return GetTextureHandle("SideBar.BtnElementalSpiritWnd.Icon_EarthOn");
	}
}
