class SummonedStatusWndClassic extends SummonedStatusWnd;

function OnEvent(int Event_ID, string param)
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		EachServerEvent(Event_ID, param);
	}
	return;
}

function OnEnterState(name a_CurrentStateName)
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		EachServerEnterState(a_CurrentStateName);
	}
	return;
}

function SetBuffButtonTooltip()
{
	local Color b1, b2, b3, b4;
	local array<DrawItemInfo> drawListArr;

	b1 = getInstanceL2Util().Gray;
	b2 = getInstanceL2Util().Gray;
	b3 = getInstanceL2Util().Gray;
	b4 = getInstanceL2Util().Gray;
	if((m_CurBf == 0))
	{
		btnBuff.SetTexture("L2ui_CH3.PartyWnd.party_buffbutton_off", "L2ui_CH3.PartyWnd.party_buffbutton_off", "L2ui_CH3.PartyWnd.party_buffbutton_off");
	}
	else
	{
		btnBuff.SetTexture(("L2ui_CH3.PartyWnd.party_buffbutton_" $ string(m_CurBf)), ("L2ui_CH3.PartyWnd.party_buffbutton_" $ string(m_CurBf)), ("L2ui_CH3.PartyWnd.party_buffbutton_" $ string(m_CurBf)));
	}
	switch(m_CurBf)
	{
		case 0:
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
		default:
			break;
	}
	drawListArr[drawListArr.Length] = addDrawItemText(((GetSystemString(1496) $ "/") $ GetSystemString(1497)), b1, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(1741), b2, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(13440), b3, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(2307), b4, "", true, true);
	btnBuff.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
	return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	local Rect rectWnd;
	local UserInfo UserInfo;

	rectWnd = Me.GetRect();
	if(((X > (rectWnd.nX + 27)) && (X < ((rectWnd.nX + rectWnd.nWidth) - 10))))
	{
		if(GetPlayerInfo(UserInfo))
		{
			if((a_WindowHandle.GetWindowName() == "btnSummonWndClassic"))
			{
				return;
			}
			if((summonedServerID[0] != Class'NWindow.UIDATA_TARGET'.static.GetTargetID()))
			{
				RequestAction(summonedServerID[0], UserInfo.Loc);
			}
		}
	}
	return;
}

defaultproperties
{
	MAX_BUFF_ICONTYPE=4
	m_Windowname="SummonedStatusWndClassic"
}
