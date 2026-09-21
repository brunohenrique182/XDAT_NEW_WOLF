class GMSnoopWnd extends UICommonAPI;

const MAX_GMSnoop = 4;

var int m_SnoopIDList[4];
var WindowHandle m_hSnoopWndList[4];
var TextListBoxHandle m_hSnoopChatWndList[4];
var ButtonHandle m_hCancelButtonList[4];
var CheckBoxHandle m_hCheckBox[28];

function OnRegisterEvent()
{
	RegisterEvent(2410);
	return;
}

function OnLoad()
{
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	if((1 == 0))
	{
		InitHandle();
	}
	else
	{
		InitHandleCOD();
	}
	ClearAllSnoop();
	return;
}

function InitHandle()
{
	local int i, j;

	i = 0;
	while((i < 4))
	{
		m_hSnoopWndList[i] = GetHandle(("SnoopWnd" $ string((i + 1))));
		m_hSnoopChatWndList[i] = TextListBoxHandle(GetHandle((("SnoopWnd" $ string((i + 1))) $ ".Chat")));
		m_hCancelButtonList[i] = ButtonHandle(GetHandle((("GMSnoopWnd.SnoopWnd" $ string((i + 1))) $ ".CancelButton")));
		j = 0;
		while((j < 7))
		{
			m_hCheckBox[((i * 7) + j)] = CheckBoxHandle(GetHandle(((("SnoopWnd" $ string((i + 1))) $ ".CheckBox") $ string(j))));
			++j;
		}
		++i;
	}
	return;
}

function InitHandleCOD()
{
	local int i, j;

	i = 0;
	while((i < 4))
	{
		m_hSnoopWndList[i] = GetWindowHandle(("SnoopWnd" $ string((i + 1))));
		m_hSnoopChatWndList[i] = GetTextListBoxHandle((("SnoopWnd" $ string((i + 1))) $ ".Chat"));
		m_hCancelButtonList[i] = GetButtonHandle((("GMSnoopWnd.SnoopWnd" $ string((i + 1))) $ ".CancelButton"));
		j = 0;
		while((j < 7))
		{
			m_hCheckBox[((i * 7) + j)] = GetCheckBoxHandle(((("SnoopWnd" $ string((i + 1))) $ ".CheckBox") $ string(j)));
			++j;
		}
		++i;
	}
	return;
}

function OnShow()
{
	local int i;

	i = 0;
	while((i < 4))
	{
		m_hSnoopWndList[i].HideWindow();
		++i;
	}
	return;
}

function OnHide()
{
	return;
}

function OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	local int i;

	i = 0;
	while((i < 4))
	{
		if((a_ButtonHandle == m_hCancelButtonList[i]))
		{
			Class'NWindow.GMAPI'.static.RequestSnoopEnd(m_SnoopIDList[i]);
			ClearSnoop(i);
		}
		++i;
	}
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 2410:
			HandleGMSnoop(a_Param);
			break;
		default:
			break;
	}
	return;
}

function HandleGMSnoop(string a_Param)
{
	local int SnoopID;
	local string SnoopName;
	local int CreatureID, SayType, SnoopIndex;
	local string CharacterName, chatMessage;
	local WindowHandle hSnoopWnd;
	local TextListBoxHandle hSnoopChatWnd;

	ParseInt(a_Param, "SnoopID", SnoopID);
	ParseString(a_Param, "SnoopName", SnoopName);
	if(!GetSnoopWnd(SnoopID, hSnoopWnd, hSnoopChatWnd, SnoopIndex, SnoopName))
	{
		DialogShow(DialogModalType_Modalless, DialogType_OK, GetSystemMessage(802));
		return;
	}
	ParseString(a_Param, "CharacterName", CharacterName);
	ParseInt(a_Param, "CreatureID", CreatureID);
	ParseInt(a_Param, "Type", SayType);
	ParseString(a_Param, "ChatMessage", chatMessage);
	if(!m_hOwnerWnd.IsShowWindow())
	{
		m_hOwnerWnd.ShowWindow();
	}
	hSnoopWnd.ShowWindow();
	if(!IsFiltered(SayPacketType(SayType), SnoopIndex))
	{
		hSnoopChatWnd.AddString(((CharacterName $ ": ") $ chatMessage), GetChatColorByType(SayType));
	}
	return;
}

function ClearAllSnoop()
{
	local int i;

	i = 0;
	while((i < 4))
	{
		ClearSnoop(i);
		++i;
	}
	return;
}

function ClearSnoop(int a_SnoopIndex)
{
	local int i;
	local bool AllHidden;

	if((0 > a_SnoopIndex))
	{
		return;
	}
	if((4 <= a_SnoopIndex))
	{
		return;
	}
	m_hSnoopChatWndList[a_SnoopIndex].Clear();
	m_SnoopIDList[a_SnoopIndex] = -1;
	m_hSnoopWndList[a_SnoopIndex].HideWindow();
	AllHidden = true;
	i = 0;
	while((i < 4))
	{
		if((-1 != m_SnoopIDList[i]))
		{
			AllHidden = false;
			break;
		}
		++i;
	}
	if(AllHidden)
	{
		m_hOwnerWnd.HideWindow();
	}
	return;
}

function bool GetSnoopWnd(int a_SnoopID, out WindowHandle a_hSnoopWnd, out TextListBoxHandle a_hSnoopChatWnd, out int a_SnoopIndex, string a_CharacterName)
{
	local int SnoopIndex;

	SnoopIndex = GetSnoopIndexByID(a_SnoopID);
	if((-1 != SnoopIndex))
	{
		a_hSnoopWnd = m_hSnoopWndList[SnoopIndex];
		a_hSnoopChatWnd = m_hSnoopChatWndList[SnoopIndex];
		a_SnoopIndex = SnoopIndex;
		return true;
	}
	SnoopIndex = GetSnoopIndexByID(-1);
	if((-1 != SnoopIndex))
	{
		m_SnoopIDList[SnoopIndex] = a_SnoopID;
		a_hSnoopWnd = m_hSnoopWndList[SnoopIndex];
		a_hSnoopChatWnd = m_hSnoopChatWndList[SnoopIndex];
		a_SnoopIndex = SnoopIndex;
		a_hSnoopWnd.SetWindowTitle(((GetSystemString(693) $ " - ") $ a_CharacterName));
		return true;
	}
	return false;
}

function int GetSnoopIndexByID(int a_SnoopID)
{
	local int i;

	i = 0;
	while((i < 4))
	{
		if((a_SnoopID == m_SnoopIDList[i]))
		{
			return i;
		}
		++i;
	}
	return -1;
}

function bool IsFiltered(UIEventManager.SayPacketType a_Type, int a_SnoopIndex)
{
	switch(a_Type)
	{
		case SPT_MARKET:
			if(m_hCheckBox[(a_SnoopIndex * 7)].IsChecked())
			{
				return false;
			}
			break;
		case SPT_PLEDGE:
			if(m_hCheckBox[((a_SnoopIndex * 7) + 1)].IsChecked())
			{
				return false;
			}
			break;
		case SPT_PARTY:
			if(m_hCheckBox[((a_SnoopIndex * 7) + 2)].IsChecked())
			{
				return false;
			}
			break;
		case SPT_SHOUT:
			if(m_hCheckBox[((a_SnoopIndex * 7) + 3)].IsChecked())
			{
				return false;
			}
			break;
		case SPT_TELL:
			if(m_hCheckBox[((a_SnoopIndex * 7) + 4)].IsChecked())
			{
				return false;
			}
			break;
		case SPT_NORMAL:
			if(m_hCheckBox[((a_SnoopIndex * 7) + 5)].IsChecked())
			{
				return false;
			}
			break;
		case SPT_ALLIANCE:
			if(m_hCheckBox[((a_SnoopIndex * 7) + 6)].IsChecked())
			{
				return false;
			}
			break;
		default:
			break;
	}
	return true;
}
