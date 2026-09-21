class PartyWndOption extends UIScript;

var bool m_OptionShow;
var int m_arrPetIDOpen[9];
var WindowHandle m_PartyOption;
var WindowHandle m_PartyWndBig;
var CheckBoxHandle m_CheckHideAllPet;
var CheckBoxHandle m_showSmallPartyWndChek;

function OnLoad()
{
	m_OptionShow = false;
	m_PartyOption = GetWindowHandle("PartyWndOption");
	m_PartyWndBig = GetWindowHandle("PartyWnd");
	m_CheckHideAllPet = GetCheckBoxHandle("PartyWndOption.removeAllPet");
	m_showSmallPartyWndChek = GetCheckBoxHandle("PartyWndOption.ShowSmallPartyWndCheck");
	m_showSmallPartyWndChek.HideWindow();
	return;
}

function OnShow()
{
	local int tmpInt;

	GetINIInt("PartyWnd", "e", tmpInt, "Windowsinfo.ini");
	m_showSmallPartyWndChek.SetCheck(bool(tmpInt));
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus("PartyWndOption");
	m_OptionShow = true;
	GetINIInt("PartyWnd", "p", tmpInt, "Windowsinfo.ini");
	m_CheckHideAllPet.SetCheck(bool(tmpInt));
	return;
}

function OnClickCheckBox(string CheckBoxID)
{
	switch(CheckBoxID)
	{
		case "ShowSmallPartyWndCheck":
			break;
		case "removeAllPet":
			break;
		default:
			break;
	}
	return;
}

function SwapBigandSmall()
{
	local int i;
	local PartyWnd script1;
	local PartyWndClassic scriptClassic;

	scriptClassic = PartyWndClassic(GetScript("PartyWndClassic"));
	script1 = PartyWnd(GetScript("PartyWnd"));
	i = 0;
	while((i < 9))
	{
		if(m_CheckHideAllPet.IsChecked())
		{
			if((m_arrPetIDOpen[i] > 0))
			{
				m_arrPetIDOpen[i] = 2;
			}
		}
		else if((m_arrPetIDOpen[i] > 0))
		{
			m_arrPetIDOpen[i] = 1;
		}
		script1.m_arrPetIDOpen[i] = m_arrPetIDOpen[i];
		scriptClassic.m_arrPetIDOpen[i] = m_arrPetIDOpen[i];
		i++;
	}
	script1.ResizeWnd(true);
	scriptClassic.ResizeWnd(true);
	return;
}

function OnClickButton(string strID)
{
	switch(strID)
	{
		case "okbtn":
			SetINIInt("PartyWnd", "e", int(m_showSmallPartyWndChek.IsChecked()), "Windowsinfo.ini");
			SetINIInt("PartyWnd", "p", int(m_CheckHideAllPet.IsChecked()), "Windowsinfo.ini");
			SwapBigandSmall();
			m_PartyOption.HideWindow();
			m_OptionShow = false;
			break;
		default:
			break;
	}
	return;
}

function ShowPartyWndOption()
{
	if((m_OptionShow == false))
	{
		m_PartyOption.ShowWindow();
		m_OptionShow = true;
	}
	else
	{
		m_PartyOption.HideWindow();
		m_OptionShow = false;
	}
	return;
}
