class XMasSealWnd extends UICommonAPI;

var string m_Windowname;
var WindowHandle m_hXMasSealWnd;
var TextureHandle m_hTexItem;

function OnRegisterEvent()
{
	RegisterEvent(3330);
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
		m_hXMasSealWnd = GetHandle(m_Windowname);
		m_hTexItem = TextureHandle(GetHandle((m_Windowname $ ".texItem")));
	}
	else
	{
		m_hXMasSealWnd = GetWindowHandle(m_Windowname);
		m_hTexItem = GetTextureHandle((m_Windowname $ ".texItem"));
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 3330:
			HandleToggleXMasSealWndShowHide(param);
			break;
		default:
			break;
	}
	return;
}

function HandleToggleXMasSealWndShowHide(string param)
{
	local ItemID Id;
	local string TextureName;

	ParseItemID(param, Id);
	TextureName = Class'NWindow.UIDATA_ITEM'.static.GetEtcItemTextureName(Id);
	m_hTexItem.SetTexture(TextureName);
	if(m_hXMasSealWnd.IsShowWindow())
	{
		m_hXMasSealWnd.HideWindow();
	}
	else
	{
		m_hXMasSealWnd.ShowWindow();
		m_hXMasSealWnd.SetFocus();
	}
	return;
}

defaultproperties
{
	m_Windowname="XMasSealWnd"
}
