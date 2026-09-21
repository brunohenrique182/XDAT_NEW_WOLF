class PartyWndClassic extends PartyWnd;

const MAX_BUFF_ICONTYPE = 5;

event OnEvent(int Event_ID, string param)
{
	if((getInstanceUIData().GetIsLiveServer() == true))
	{
		return;
	}
	EachServerEvent(Event_ID, param);
	return;
}

event OnEnterState(name a_CurrentStateName)
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		EachServerEnterState(a_CurrentStateName);
	}
	return;
}

function SetBuffButtonTooltip()
{
	local Color b1, b2, b3, b4, b5, b6;
	local array<DrawItemInfo> drawListArr;

	b1 = getInstanceL2Util().Gray;
	b2 = getInstanceL2Util().Gray;
	b3 = getInstanceL2Util().Gray;
	b4 = getInstanceL2Util().Gray;
	b5 = getInstanceL2Util().Gray;
	b6 = getInstanceL2Util().Gray;
	if((m_CurBf == 0))
	{
		btnBuff.SetTexture("L2ui_CH3.PartyWnd.party_buffbuttonClassic_6", "L2ui_CH3.PartyWnd.party_buffbuttonClassic_6", "L2ui_CH3.PartyWnd.party_buffbuttonClassic_6");
	}
	else
	{
		btnBuff.SetTexture(("L2ui_CH3.PartyWnd.party_buffbuttonClassic_" $ string(m_CurBf)), ("L2ui_CH3.PartyWnd.party_buffbuttonClassic_" $ string(m_CurBf)), ("L2ui_CH3.PartyWnd.party_buffbuttonClassic_" $ string(m_CurBf)));
	}
	switch(m_CurBf)
	{
		case 0:
			b6 = getInstanceL2Util().Yellow;
			break;
		case 1:
			b1 = getInstanceL2Util().Yellow;
			break;
		case 2:
			b2 = getInstanceL2Util().Yellow;
			break;
		case 3:
			b3 = getInstanceL2Util().Yellow;
			break;
		case 4:
			b4 = getInstanceL2Util().Yellow;
			break;
		case 5:
			b5 = getInstanceL2Util().Yellow;
			break;
		default:
			break;
	}
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(1496), b1, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(1497), b2, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(1741), b3, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13440), b4, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(2307), b5, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(228), b6, "", true, true);
	btnBuff.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
	return;
}

function UpdateBuff()
{
	local int idx;

	if((m_CurBf == 1))
	{
		idx = 0;
		while((idx < 10))
		{
			m_StatusIconBuff[idx].ShowWindow();
			m_PetStatusIconBuff[idx].ShowWindow();
			m_StatusIconDeBuff[idx].HideWindow();
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].HideWindow();
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconItem[idx].HideWindow();
			m_PetStatusIconItem[idx].HideWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();
			m_PetStatusIconTriggerSkill[idx].HideWindow();
			idx++;
		}
	}
	else if((m_CurBf == 2))
	{
		idx = 0;
		while((idx < 10))
		{
			m_StatusIconBuff[idx].HideWindow();
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].ShowWindow();
			m_PetStatusIconDeBuff[idx].ShowWindow();
			m_StatusIconSongDance[idx].HideWindow();
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconItem[idx].HideWindow();
			m_PetStatusIconItem[idx].HideWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();
			m_PetStatusIconTriggerSkill[idx].HideWindow();
			idx++;
		}
	}
	else if((m_CurBf == 3))
	{
		idx = 0;
		while((idx < 10))
		{
			m_StatusIconBuff[idx].HideWindow();
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].HideWindow();
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].ShowWindow();
			m_PetStatusIconSongDance[idx].ShowWindow();
			m_StatusIconItem[idx].HideWindow();
			m_PetStatusIconItem[idx].HideWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();
			m_PetStatusIconTriggerSkill[idx].HideWindow();
			idx++;
		}
	}
	else if((m_CurBf == 4))
	{
		idx = 0;
		while((idx < 10))
		{
			m_StatusIconBuff[idx].HideWindow();
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].HideWindow();
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].HideWindow();
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconItem[idx].ShowWindow();
			m_PetStatusIconItem[idx].ShowWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();
			m_PetStatusIconTriggerSkill[idx].HideWindow();
			idx++;
		}
	}
	else if((m_CurBf == 5))
	{
		idx = 0;
		while((idx < 10))
		{
			m_StatusIconBuff[idx].HideWindow();
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].HideWindow();
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].HideWindow();
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconItem[idx].HideWindow();
			m_PetStatusIconItem[idx].HideWindow();
			m_StatusIconTriggerSkill[idx].ShowWindow();
			m_PetStatusIconTriggerSkill[idx].ShowWindow();
			idx++;
		}
	}
	else
	{
		idx = 0;
		while((idx < 10))
		{
			m_StatusIconBuff[idx].HideWindow();
			m_PetStatusIconBuff[idx].HideWindow();
			m_StatusIconDeBuff[idx].HideWindow();
			m_PetStatusIconDeBuff[idx].HideWindow();
			m_StatusIconSongDance[idx].HideWindow();
			m_PetStatusIconSongDance[idx].HideWindow();
			m_StatusIconItem[idx].HideWindow();
			m_PetStatusIconItem[idx].HideWindow();
			m_StatusIconTriggerSkill[idx].HideWindow();
			m_PetStatusIconTriggerSkill[idx].HideWindow();
			idx++;
		}
	}
	return;
}

defaultproperties
{
	MAX_BUFF_ICONTYPE=5
	DEFAULT_NPARTYSTATUS_HEIGHT=61
	DEFAULT_NPARTYPETSTATUS_HEIGHT=25
	DEFAULT_STATUS_GAP=0
	m_Windowname="PartyWndClassic"
}
