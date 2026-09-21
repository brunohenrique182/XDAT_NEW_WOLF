class ViewPortWndEffect extends ViewPortWndBase;

function OnLoad()
{
	super.OnLoad();
	m_ObjectViewport.SetNPCInfo(19671);
	m_ObjectViewport.SetUISound(true);
	RegisterState(getCurrentWindowName(string(self)), "ARENAGAMINGSTATE");
	RegisterState(getCurrentWindowName(string(self)), "ARENABATTLESTATE");
	RegisterState(getCurrentWindowName(string(self)), "GAMINGSTATE");
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(3410);
	return;
}

function OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case 3410:
			switch(param)
			{
				case "ARENAGAMINGSTATE":
				case "ARENABATTLESTATE":
				case "GAMINGSTATE":
					m_ObjectViewport.SpawnNPC();
					break;
				default:
					break;
			}
		default:
			return;
	}
}
