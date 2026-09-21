class OlympiadPlayer2Wnd extends OlympiadPlayerWnd;

function OnLoad()
{
	SetPlayerNum(2);
	super.OnLoad();
	return;
}

function UpdateUsersInfo()
{
	if((m_IsPlayer == 1))
	{
		super.UpdateUsersInfo();
	}
	return;
}
