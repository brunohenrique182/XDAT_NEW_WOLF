class GMFindTreeWndSkill extends UICommonAPI;

var WindowHandle Me;
var string m_Windowname;
var EditBoxHandle m_ebIconType;
var EditBoxHandle m_ebGroupType;
var int ItemID;

event OnLoad()
{
	SetClosingOnESC();
	Me = GetWindowHandle(m_Windowname);
	m_ebIconType = GetEditBoxHandle((m_Windowname $ ".ebIconType"));
	m_ebGroupType = GetEditBoxHandle((m_Windowname $ ".ebGroupType"));
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "btnDetail":
			HandleShowHideUISkillToolWnd();
			break;
		default:
			break;
	}
	return;
}

function HandleShowHideUISkillToolWnd()
{
	local WindowHandle uiSkillToolWndHandle;

	uiSkillToolWndHandle = GetWindowHandle("UISkillToolWnd");
	if(uiSkillToolWndHandle.IsShowWindow())
	{
		uiSkillToolWndHandle.HideWindow();
	}
	else
	{
		uiSkillToolWndHandle.ShowWindow();
		uiSkillToolWndHandle.SetFocus();
	}
	return;
}

defaultproperties
{
	m_Windowname="GMFindTreeWndSkill"
}
