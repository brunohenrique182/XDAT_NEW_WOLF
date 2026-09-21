class JobChangeWnd extends L2UIGFxScript;

var int initClassID;
var int CurrentSubjobClassID;
var int targetCurrentSubjobClassID;

function OnRegisterEvent()
{
	RegisterEvent(5310);
	RegisterEvent(5311);
	RegisterEvent(5312);
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	local NoticeWnd m_NoticeWnd;

	switch(a_EventID)
	{
		case 5310:
		case 5311:
		case 5312:
			m_NoticeWnd = NoticeWnd(GetScript("NoticeWnd"));
			m_NoticeWnd.removeNoticeButton(32);
			if(!IsPlayerOnWorldRaidServer())
			{
				CallGFxFunction("JobChangeWnd", "RequestClassChangeVerifying", "");
			}
			break;
		default:
			break;
	}
	return;
}

function OnLoad()
{
	AddState("GAMINGSTATE");
	SetContainerWindow("SkinnedWindow", 1795);
	return;
}
