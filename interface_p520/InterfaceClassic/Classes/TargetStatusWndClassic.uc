class TargetStatusWndClassic extends TargetStatusWnd;

function OnEvent(int a_EventID, string a_Param)
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		EachServerEvent(a_EventID, a_Param);
	}
	return;
}

function OnEnterState(name a_CurrentStateName)
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		EachSeverEnterState(a_CurrentStateName);
	}
	return;
}

defaultproperties
{
	m_Windowname="TargetStatusWndClassic"
}
