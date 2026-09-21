class SideBarWndBase extends UICommonAPI;

var SideBar SideBarScript;

function InitSideBarWndDefaultOnLoad()
{
	SetClosingOnESC();
	SideBarScript = SideBar(GetScript("SideBar"));
	return;
}

function HandleOnClickClose(string a_ButtonID)
{
	if((a_ButtonID == "Close_Btn"))
	{
		m_hOwnerWnd.HideWindow();
		SideBarScript.SaveVOption(m_hOwnerWnd.m_WindowNameWithFullPath, false);
	}
	return;
}

function HandleOnShow()
{
	ToggleSideBarItem();
	return;
}

function HandleOnHide()
{
	ToggleSideBarItem();
	return;
}

event OnLoad()
{
	InitSideBarWndDefaultOnLoad();
	return;
}

event OnShow()
{
	HandleOnShow();
	return;
}

event OnHide()
{
	ToggleSideBarItem();
	return;
}

function ToggleSideBarItem()
{
	SideBarScript.ToggleByWindowName(m_hOwnerWnd.m_WindowNameWithFullPath, m_hOwnerWnd.IsShowWindow());
	return;
}
