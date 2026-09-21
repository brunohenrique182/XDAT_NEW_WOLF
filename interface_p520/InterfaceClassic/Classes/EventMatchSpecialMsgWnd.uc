class EventMatchSpecialMsgWnd extends UICommonAPI;

const TIMERID_Hide = 1;

var TextureHandle MessageTex;

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
		MessageTex = TextureHandle(GetHandle("MsgTex"));
	}
	else
	{
		MessageTex = GetTextureHandle("MsgTex");
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
	local string Message, TextureName;

	ParseInt(a_Param, "Type", Type);
	ParseString(a_Param, "Message", Message);
	switch(byte(Type))
	{
		case 1:
			TextureName = "L2UI_CH3.BroadcastObs.br_msg1_finish";
			break;
		case 2:
			TextureName = "L2UI_CH3.BroadcastObs.br_msg1_start";
			break;
		case 3:
			TextureName = "L2UI_CH3.BroadcastObs.br_msg1_gameover";
			break;
		case 4:
			TextureName = "L2UI_CH3.BroadcastObs.br_msg1_count1";
			break;
		case 5:
			TextureName = "L2UI_CH3.BroadcastObs.br_msg1_count2";
			break;
		case 6:
			TextureName = "L2UI_CH3.BroadcastObs.br_msg1_count3";
			break;
		case 7:
			TextureName = "L2UI_CH3.BroadcastObs.br_msg1_count4";
			break;
		case 8:
			TextureName = "L2UI_CH3.BroadcastObs.br_msg1_count5";
			break;
		default:
			return;
	}
	MessageTex.SetTexture(TextureName);
	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.KillTimer(1);
	m_hOwnerWnd.SetTimer(1, 5000);
	return;
}
