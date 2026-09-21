class ObserverWnd extends UICommonAPI;

var bool m_bObserverMode;

function OnRegisterEvent()
{
	RegisterEvent(2450);
	RegisterEvent(2460);
	RegisterEvent(150);
	return;
}

function OnLoad()
{
	m_bObserverMode = false;
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 2450:
			m_bObserverMode = true;
			ShowWindow("ObserverWnd");
			break;
		case 2460:
			m_bObserverMode = false;
			HideWindow("ObserverWnd");
			break;
		case 150:
			if(m_bObserverMode)
			{
				ShowWindow("ObserverWnd");
			}
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "BtnEnd":
			RequestObserverModeEnd();
			break;
		default:
			break;
	}
	return;
}
