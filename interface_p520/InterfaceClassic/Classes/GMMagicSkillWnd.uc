class GMMagicSkillWnd extends MagicSkillWnd;

var bool bShow;

function OnRegisterEvent()
{
	RegisterEvent(2300);
	RegisterEvent(2310);
	return;
}

function OnLoad()
{
	local int i;

	if((1 == 0))
	{
		OnRegisterEvent();
	}
	if((1 == 0))
	{
		m_wndTop = GetHandle(m_Windowname);
		areaScroll = GetHandle((m_Windowname $ ".ASkillScroll"));
		areaScroll_p = GetHandle((m_Windowname $ ".PSkillScroll"));
		i = 0;
		while((i < 13))
		{
			m_wndName[i] = GetHandle(((m_Windowname $ ".ASkill.ASkillName") $ string(i)));
			m_Wnd[i] = GetHandle(((m_Windowname $ ".ASkill.ASkill") $ string(i)));
			m_NameStr[i] = TextBoxHandle(GetHandle(((((m_Windowname $ ".ASkill.ASkillName") $ string(i)) $ ".ASkillNameStr") $ string(i))));
			m_NameBtn[i] = TextureHandle(GetHandle(((((m_Windowname $ ".ASkill.ASkillName") $ string(i)) $ ".ASkillBtn") $ string(i))));
			m_Item[i] = ItemWindowHandle(GetHandle(((((m_Windowname $ ".ASkill.ASkill") $ string(i)) $ ".ASkillItem") $ string(i))));
			m_ItemBg[i] = TextureHandle(GetHandle(((((m_Windowname $ ".ASkill.ASkill") $ string(i)) $ ".ASkillSlotBg") $ string(i))));
			m_HiddenBtn[i] = ButtonHandle(GetHandle(((((m_Windowname $ ".ASkill.ASkillName") $ string(i)) $ ".ASkillHiddenBtn") $ string(i))));
			m_HiddenBtn[i].SetAlpha(255);
			i++;
		}
		i = 0;
		while((i < 9))
		{
			m_wndName_p[i] = GetHandle(((m_Windowname $ ".PSkill.PSkillName") $ string(i)));
			m_wnd_p[i] = GetHandle(((m_Windowname $ ".PSkill.PSkill") $ string(i)));
			m_NameStr_p[i] = TextBoxHandle(GetHandle(((((m_Windowname $ ".PSkill.PSkillName") $ string(i)) $ ".PSkillNameStr") $ string(i))));
			m_NameBtn_p[i] = TextureHandle(GetHandle(((((m_Windowname $ ".PSkill.PSkillName") $ string(i)) $ ".PSkillBtn") $ string(i))));
			m_Item_p[i] = ItemWindowHandle(GetHandle(((((m_Windowname $ ".PSkill.PSkill") $ string(i)) $ ".PSkillItem") $ string(i))));
			m_ItemBg_p[i] = TextureHandle(GetHandle(((((m_Windowname $ ".PSkill.PSkill") $ string(i)) $ ".PSkillSlotBg") $ string(i))));
			m_HiddenBtn_p[i] = ButtonHandle(GetHandle(((((m_Windowname $ ".PSkill.PSkillName") $ string(i)) $ ".PSkillHiddenBtn") $ string(i))));
			m_HiddenBtn_p[i].SetAlpha(255);
			i++;
		}
	}
	else
	{
		m_wndTop = GetWindowHandle(m_Windowname);
		areaScroll = GetWindowHandle((m_Windowname $ ".ASkillScroll"));
		areaScroll_p = GetWindowHandle((m_Windowname $ ".PSkillScroll"));
		i = 0;
		while((i < 13))
		{
			m_wndName[i] = GetWindowHandle(((m_Windowname $ ".ASkill.ASkillName") $ string(i)));
			m_Wnd[i] = GetWindowHandle(((m_Windowname $ ".ASkill.ASkill") $ string(i)));
			m_NameStr[i] = GetTextBoxHandle(((((m_Windowname $ ".ASkill.ASkillName") $ string(i)) $ ".ASkillNameStr") $ string(i)));
			m_NameBtn[i] = GetTextureHandle(((((m_Windowname $ ".ASkill.ASkillName") $ string(i)) $ ".ASkillBtn") $ string(i)));
			m_Item[i] = GetItemWindowHandle(((((m_Windowname $ ".ASkill.ASkill") $ string(i)) $ ".ASkillItem") $ string(i)));
			m_ItemBg[i] = GetTextureHandle(((((m_Windowname $ ".ASkill.ASkill") $ string(i)) $ ".ASkillSlotBg") $ string(i)));
			m_HiddenBtn[i] = GetButtonHandle(((((m_Windowname $ ".ASkill.ASkillName") $ string(i)) $ ".ASkillHiddenBtn") $ string(i)));
			m_HiddenBtn[i].SetAlpha(255);
			i++;
		}
		i = 0;
		while((i < 9))
		{
			m_wndName_p[i] = GetWindowHandle(((m_Windowname $ ".PSkill.PSkillName") $ string(i)));
			m_wnd_p[i] = GetWindowHandle(((m_Windowname $ ".PSkill.PSkill") $ string(i)));
			m_NameStr_p[i] = GetTextBoxHandle(((((m_Windowname $ ".PSkill.PSkillName") $ string(i)) $ ".PSkillNameStr") $ string(i)));
			m_NameBtn_p[i] = GetTextureHandle(((((m_Windowname $ ".PSkill.PSkillName") $ string(i)) $ ".PSkillBtn") $ string(i)));
			m_Item_p[i] = GetItemWindowHandle(((((m_Windowname $ ".PSkill.PSkill") $ string(i)) $ ".PSkillItem") $ string(i)));
			m_ItemBg_p[i] = GetTextureHandle(((((m_Windowname $ ".PSkill.PSkill") $ string(i)) $ ".PSkillSlotBg") $ string(i)));
			m_HiddenBtn_p[i] = GetButtonHandle(((((m_Windowname $ ".PSkill.PSkillName") $ string(i)) $ ".PSkillHiddenBtn") $ string(i)));
			m_HiddenBtn_p[i].SetAlpha(255);
			i++;
		}
	}
	bShow = false;
	return;
}

function OnShow()
{
	return;
}

function OnHide()
{
	return;
}

function ShowMagicSkill(string a_Param)
{
	if((a_Param == ""))
	{
		return;
	}
	if(bShow)
	{
		Clear();
		m_hOwnerWnd.HideWindow();
		bShow = false;
	}
	else
	{
		Class'NWindow.GMAPI'.static.RequestGMCommand(GMCOMMAND_SkillInfo, a_Param);
		bShow = true;
	}
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case 2300:
			HadleGMObservingSkillListStart();
			break;
		case 2310:
			HadleGMObservingSkillList(a_Param);
			break;
		default:
			break;
	}
	return;
}

function HadleGMObservingSkillListStart()
{
	Clear();
	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetFocus();
	return;
}

function HadleGMObservingSkillList(string a_Param)
{
	HandleSkillList(a_Param);
	ComputeItemWndHeight();
	ComputeItemWndAnchor();
	return;
}

function OnClickItem(string strID, int Index)
{
	return;
}

defaultproperties
{
	m_Windowname="GMMagicSkillWnd"
}
