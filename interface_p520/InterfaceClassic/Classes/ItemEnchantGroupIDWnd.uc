class ItemEnchantGroupIDWnd extends UICommonAPI
	dependson(UIPacket);

var UIMapInt64Object groupIDs;

function _Init()
{
	local int i, Id;

	m_hOwnerWnd.HideWindow();
	groupIDs = new Class'InterfaceClassic.UIMapInt64Object';
	i = 0;
	while((GetWindowHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd0") $ string(i))).m_pTargetWnd != none))
	{
		Id = (i + 1);
		GetTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd0") $ string(i)) $ ".selectedTexture")).HideWindow();
		_SetCurrentGroupIDPoint(Id, 0);
		i++;
	}
	return;
}

function SetTooltips()
{
	local int i;

	i = 0;
	while((GetWindowHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd0") $ string(i))).m_pTargetWnd != none))
	{
		GetButtonHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd0") $ string(i)) $ ".point00Icon_Tex")).ClearTooltip();
		GetButtonHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd0") $ string(i)) $ ".point00Icon_Tex")).SetTooltipType("text");
		GetButtonHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd0") $ string(i)) $ ".point00Icon_Tex")).SetTooltipCustomType(MakeTooltipSimpleText(GetTooltipByIndex(i)));
		i++;
	}
	return;
}

function string GetTooltipByIndex(int Index)
{
	if((!IsAdenServer() && getInstanceUIData().GetIsClassicServer()))
	{
		switch(Index)
		{
			case 1:
				return GetNpcString(1600080);
			case 2:
				return GetNpcString(1600081);
			default:
				break;
		}
	}
	switch(Index)
	{
		case 0:
			return GetNpcString(1600077);
		case 1:
			return GetNpcString(1600078);
		case 2:
			return GetNpcString(1600079);
		default:
			return "";
	}
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(996));
	RegisterEvent(40);
	RegisterEvent(9750);
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case EV_PacketID(996):
			Handle_S_EX_ENCHANT_CHALLENGE_POINT_INFO();
			break;
		case 40:
			ResetPoinsts();
			break;
		case 9750:
			if(getInstanceUIData().GetIsClassicServer())
			{
				if(IsAdenServer())
				{
					GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd00")).ShowWindow();
				}
				else
				{
					GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd00")).HideWindow();
				}
			}
			SetTooltips();
			break;
		default:
			break;
	}
	return;
}

function ResetPoinsts()
{
	local int i, Id;

	i = 0;
	while((GetWindowHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd0") $ string(i))).m_pTargetWnd != none))
	{
		Id = (i + 1);
		_SetCurrentGroupIDPoint(Id, 0);
		i++;
	}
	return;
}

function Handle_S_EX_ENCHANT_CHALLENGE_POINT_INFO()
{
	local int i;
	local UIPacket._S_EX_ENCHANT_CHALLENGE_POINT_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_ENCHANT_CHALLENGE_POINT_INFO(packet))
	{
		return;
	}
	i = 0;
	while((i < packet.vCurrentPointInfo.Length))
	{
		_SetCurrentGroupIDPoint(packet.vCurrentPointInfo[i].nPointGroupId, packet.vCurrentPointInfo[i].nChallengePoint);
		i++;
	}
	return;
}

function _AddCurrentGroupID(int Id)
{
	if((Id <= 0))
	{
		return;
	}
	GetTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd0") $ string((Id - 1))) $ ".selectedTexture")).ShowWindow();
	return;
}

function _HideCurrentGroupID()
{
	local int i;

	i = 0;
	while((GetWindowHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd0") $ string(i))).m_pTargetWnd != none))
	{
		GetTextureHandle((((m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd0") $ string(i)) $ ".selectedTexture")).HideWindow();
		i++;
	}
	return;
}

function _SetCurrentGroupID(int Id)
{
	local string Path;

	_HideCurrentGroupID();
	if((Id <= 0))
	{
		return;
	}
	Path = ((m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd0") $ string((Id - 1)));
	GetTextureHandle((Path $ ".selectedTexture")).ShowWindow();
	return;
}

function _SetCurrentGroupIDPoint(int Id, int pnt)
{
	local string Path;

	if((Id == 0))
	{
		return;
	}
	Path = (((m_hOwnerWnd.m_WindowNameWithFullPath $ ".pointGroupWnd0") $ string((Id - 1))) $ ".pnt_txt");
	groupIDs.Add(INT64(Id), INT64(pnt));
	GetTextBoxHandle(Path).SetText(((string(pnt) $ "/") $ string(_GetMaxPoint())));
	return;
}

function int _GetPoint(int GroupID)
{
	return int(groupIDs.Find(INT64(GroupID)));
}

function int _GetMaxPoint()
{
	local EnchantChallengePointSettingUIData o_data;

	API_GetEnchantChallengePointSettingData(o_data);
	return int(o_data.MaxPoint);
}

function _SetDisable()
{
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Disable_tex")).ShowWindow();
	return;
}

function _SetEnable()
{
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Disable_tex")).HideWindow();
	return;
}

function _ToggleShowHide()
{
	if(m_hOwnerWnd.IsShowWindow())
	{
		_Hide();
	}
	else
	{
		_Show();
	}
	return;
}

function _CheckShowHide()
{
	local int V;

	GetINIBool("ItemEnchantGroupIDWnd", "v", V, "Option.ini");
	Debug(((("_CheckShowHide" @ string(GetINIBool("ItemEnchantGroupIDWnd", "v", V, "Option.ini"))) @ string(m_hOwnerWnd.IsShowWindow())) @ string(V)));
	if(GetINIBool("ItemEnchantGroupIDWnd", "v", V, "Option.ini"))
	{
		if((V == 1))
		{
			m_hOwnerWnd.ShowWindow();
		}
		else
		{
			m_hOwnerWnd.HideWindow();
		}
	}
	else
	{
		m_hOwnerWnd.ShowWindow();
	}
	return;
}

function _Show()
{
	m_hOwnerWnd.ShowWindow();
	SetINIBool("ItemEnchantGroupIDWnd", "v", true, "Option.ini");
	return;
}

function _Hide()
{
	m_hOwnerWnd.HideWindow();
	SetINIBool("ItemEnchantGroupIDWnd", "v", false, "Option.ini");
	return;
}

function ItemInfo _GetItemInfoPoint(int GroupID)
{
	local ItemInfo iInfo;

	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(_GetClassIDPoint(GroupID)), iInfo);
	return iInfo;
}

static function int _GetClassIDPoint(int GroupID)
{
	switch(GroupID)
	{
		case 1:
			return 96949;
		case 2:
			return 96950;
		case 3:
			return 96951;
		default:
	}
}

function API_GetEnchantChallengePointSettingData(out EnchantChallengePointSettingUIData o_data)
{
	Class'NWindow.UIDATA_ITEM'.static.GetEnchantChallengePointSettingData(o_data);
	return;
}
