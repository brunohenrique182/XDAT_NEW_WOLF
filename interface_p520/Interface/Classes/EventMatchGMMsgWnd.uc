class EventMatchGMMsgWnd extends UICommonAPI;

const TIMERID_Hide = 1;

var TextBoxHandle MessageTextBox;

function OnRegisterEvent()
{
	RegisterEvent(2270);
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
		MessageTextBox = TextBoxHandle(GetHandle("MsgTextBox"));
	}
	else
	{
		MessageTextBox = GetTextBoxHandle("MsgTextBox");
	}
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 2270:
			HandleEventMatchGMMessage(a_Param);
			break;
		default:
			break;
	}
	return;
}

function OnTimer(int a_TimerID)
{
	switch(a_TimerID)
	{
		case 1:
			m_hOwnerWnd.HideWindow();
			MessageTextBox.SetText("");
			m_hOwnerWnd.KillTimer(1);
			break;
		default:
			break;
	}
	return;
}

function HandleEventMatchGMMessage(string a_Param)
{
	local int Type;
	local string Message;

	ParseInt(a_Param, "Type", Type);
	ParseString(a_Param, "Message", Message);
	switch(byte(Type))
	{
		case 0:
			m_hOwnerWnd.ShowWindow();
			MessageTextBox.SetText(Message);
			m_hOwnerWnd.KillTimer(1);
			m_hOwnerWnd.SetTimer(1, 5000);
			break;
		default:
			break;
	}
	return;
}
