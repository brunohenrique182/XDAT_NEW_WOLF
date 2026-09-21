class InventoryWndCharacterView extends UICommonAPI;

const ORCRIDERSCALE = 0.803f;
const ORCRIDERX = 0;
const ORCRIDERY = 1;
const TIMER_ID_ANIMATION = 19;
const TIMER_DELAY = 2000;
const TIMER_ID_CLICK = 2;
const TIMER_DELAY_CLICK = 150;

var ButtonHandle m_CloseButton;
var CharacterViewportWindowHandle m_ObjectViewport;
var ButtonHandle m_BtnRotateLeft;
var ButtonHandle m_BtnRotateRight;
var bool isDown;
var bool isAniPlaing;
var int m_MeshType;

function OnRegisterEvent()
{
	RegisterEvent(3810);
	return;
}

function OnLoad()
{
	InitHandleCOD();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 3810:
			HandleChangeCharacterPawn(param);
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
		case "CloseButton":
			ToggleMe();
			break;
		default:
			break;
	}
	return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	if((a_WindowHandle == m_BtnRotateLeft))
	{
		m_ObjectViewport.StartRotation(false);
	}
	else if((a_WindowHandle == m_BtnRotateRight))
	{
		m_ObjectViewport.StartRotation(true);
	}
	else if((a_WindowHandle == m_ObjectViewport))
	{
		m_hOwnerWnd.SetTimer(2, 150);
		isDown = true;
	}
	return;
}

function OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	if((a_WindowHandle == m_BtnRotateLeft))
	{
		m_ObjectViewport.EndRotation();
	}
	else if((a_WindowHandle == m_BtnRotateRight))
	{
		m_ObjectViewport.EndRotation();
	}
	else if(((!isAniPlaing && isDown) && (a_WindowHandle == m_ObjectViewport)))
	{
		isAniPlaing = true;
		if(((m_MeshType == 18) || (m_MeshType == 19)))
		{
			m_ObjectViewport.PlayAnimation(3);
		}
		else
		{
			PlayRandAttackAnimation();
		}
		m_hOwnerWnd.KillTimer(19);
		m_hOwnerWnd.SetTimer(19, 2000);
	}
	m_hOwnerWnd.KillTimer(2);
	isDown = false;
	return;
}

function OnRButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	if(((!isAniPlaing && isDown) && (a_WindowHandle == m_ObjectViewport)))
	{
		isAniPlaing = true;
		PlayRandAnimation();
		m_hOwnerWnd.KillTimer(19);
		m_hOwnerWnd.SetTimer(19, 2000);
	}
	m_hOwnerWnd.KillTimer(2);
	isDown = false;
	return;
}

function OnRButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	if((a_WindowHandle == m_ObjectViewport))
	{
		m_hOwnerWnd.SetTimer(2, 150);
		isDown = true;
	}
	return;
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 19:
			m_hOwnerWnd.KillTimer(19);
			isAniPlaing = false;
			break;
		case 2:
			m_hOwnerWnd.KillTimer(2);
			isDown = false;
			break;
		default:
			break;
	}
	return;
}

function PlayRandAttackAnimation()
{
	local int aniType;

	aniType = (Rand(3) + 1);
	m_ObjectViewport.PlayAttackAnimation(aniType);
	return;
}

function PlayRandAnimation()
{
	local int aniType;

	aniType = (Rand(13) + 1);
	m_ObjectViewport.PlayAnimation(aniType);
	return;
}

function InitHandleCOD()
{
	m_BtnRotateLeft = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".TabCharacterView.BtnRotateLeft"));
	m_BtnRotateRight = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".TabCharacterView.BtnRotateRight"));
	m_CloseButton = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CloseButton"));
	m_ObjectViewport = GetCharacterViewportWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".TabCharacterView.ObjectViewport"));
	m_ObjectViewport.SetDragRotationRate(300);
	return;
}

function HandleChangeCharacterPawn(string param)
{
	local UserInfo uInfo;

	ParseInt(param, "MeshType", m_MeshType);
	switch(m_MeshType)
	{
		case 0:
			m_ObjectViewport.SetCharacterScale(1.0000000);
			m_ObjectViewport.SetCharacterOffsetX(-2);
			m_ObjectViewport.SetCharacterOffsetY(-3);
			break;
		case 1:
			m_ObjectViewport.SetCharacterScale(1.0300000);
			m_ObjectViewport.SetCharacterOffsetX(-2);
			m_ObjectViewport.SetCharacterOffsetY(-5);
			break;
		case 8:
			m_ObjectViewport.SetCharacterScale(1.0470001);
			m_ObjectViewport.SetCharacterOffsetX(2);
			m_ObjectViewport.SetCharacterOffsetY(-5);
			break;
		case 9:
			m_ObjectViewport.SetCharacterScale(1.0700001);
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(-6);
			break;
		case 6:
			m_ObjectViewport.SetCharacterScale(0.9800000);
			m_ObjectViewport.SetCharacterOffsetX(-2);
			m_ObjectViewport.SetCharacterOffsetY(-4);
			break;
		case 7:
			m_ObjectViewport.SetCharacterScale(1.0400000);
			m_ObjectViewport.SetCharacterOffsetX(-4);
			m_ObjectViewport.SetCharacterOffsetY(-5);
			break;
		case 2:
			m_ObjectViewport.SetCharacterScale(0.9900000);
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(-4);
			break;
		case 3:
			m_ObjectViewport.SetCharacterScale(1.0150000);
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(-4);
			break;
		case 10:
			if(GetPlayerInfo(uInfo))
			{
				if((uInfo.Class == 217))
				{
					m_ObjectViewport.SetCharacterScale(0.8030000);
					m_ObjectViewport.SetCharacterOffsetX(0);
					m_ObjectViewport.SetCharacterOffsetY(1);
				}
				else
				{
					m_ObjectViewport.SetCharacterScale(0.9530000);
					m_ObjectViewport.SetCharacterOffsetX(0);
					m_ObjectViewport.SetCharacterOffsetY(-6);
				}
			}
			break;
		case 11:
			m_ObjectViewport.SetCharacterScale(0.9700000);
			m_ObjectViewport.SetCharacterOffsetX(2);
			m_ObjectViewport.SetCharacterOffsetY(-5);
			break;
		case 12:
			m_ObjectViewport.SetCharacterScale(0.9550000);
			m_ObjectViewport.SetCharacterOffsetX(-2);
			m_ObjectViewport.SetCharacterOffsetY(-5);
			break;
		case 13:
			m_ObjectViewport.SetCharacterScale(0.9850000);
			m_ObjectViewport.SetCharacterOffsetX(0);
			m_ObjectViewport.SetCharacterOffsetY(-5);
			break;
		case 4:
			m_ObjectViewport.SetCharacterScale(1.0430000);
			m_ObjectViewport.SetCharacterOffsetX(0);
			m_ObjectViewport.SetCharacterOffsetY(1);
			break;
		case 5:
			m_ObjectViewport.SetCharacterScale(1.0900000);
			m_ObjectViewport.SetCharacterOffsetX(0);
			m_ObjectViewport.SetCharacterOffsetY(-3);
			break;
		case 14:
			m_ObjectViewport.SetCharacterScale(0.9930000);
			m_ObjectViewport.SetCharacterOffsetX(-5);
			m_ObjectViewport.SetCharacterOffsetY(-4);
			break;
		case 15:
			m_ObjectViewport.SetCharacterScale(1.0100000);
			m_ObjectViewport.SetCharacterOffsetX(0);
			m_ObjectViewport.SetCharacterOffsetY(-3);
			break;
		case 17:
			m_ObjectViewport.SetCharacterScale(1.0150000);
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(-1);
			break;
		case 18:
			m_ObjectViewport.SetCharacterScale(1.0150000);
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(-1);
			break;
		case 19:
			m_ObjectViewport.SetCharacterScale(1.0150000);
			m_ObjectViewport.SetCharacterOffsetX(-1);
			m_ObjectViewport.SetCharacterOffsetY(-1);
			break;
		case 20:
			m_ObjectViewport.SetCharacterScale(0.9930000);
			m_ObjectViewport.SetCharacterOffsetX(-5);
			m_ObjectViewport.SetCharacterOffsetY(-4);
			break;
		case 21:
			m_ObjectViewport.SetCharacterScale(1.0100000);
			m_ObjectViewport.SetCharacterOffsetX(4);
			m_ObjectViewport.SetCharacterOffsetY(-3);
			break;
		default:
			break;
	}
	return;
}

function ToggleMe()
{
	local InventoryWnd inventoryWndScript;

	inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
	inventoryWndScript.toogleCharacterViewPort(!m_hOwnerWnd.IsShowWindow());
	return;
}

function string GetEllipsisString(string Str, int MaxWidth)
{
	local string fixedString;
	local int nWidth, nHeight;

	GetTextSizeDefault((Str $ "..."), nWidth, nHeight);
	if((nWidth < MaxWidth))
	{
		return Str;
	}
	fixedString = DivideStringWithWidth(Str, MaxWidth);
	if((fixedString != Str))
	{
		fixedString = (fixedString $ "...");
	}
	return fixedString;
}

function CharacterClickec()
{
	if(!m_hOwnerWnd.IsShowWindow())
	{
		ToggleMe();
	}
	GetTabHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CharacterTab")).SetTopOrder(0, true);
	return;
}
