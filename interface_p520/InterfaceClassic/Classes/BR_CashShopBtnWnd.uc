class BR_CashShopBtnWnd extends UICommonAPI;

const TIMER_ID = 1410;
const TIMER_DELAY = 500;

var WindowHandle Me;
var ButtonHandle BtnShowCashShop;
var WindowHandle Drawer;
var TextureHandle TexPrime_panel_new;
var array<string> m_UI_prime_panel_new;
var int m_currentAnim;
var bool m_newAnim;
var int m_SubJobClassID;

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	RegisterState("BR_CashShopBtnWnd", "TRAININGROOMSTATE");
	InitHandle();
	Load();
	return;
}

function InitHandle()
{
	if((1 == 0))
	{
		Me = GetHandle("BR_CashShopBtnWnd");
		BtnShowCashShop = ButtonHandle(GetHandle("BR_CashShopBtnWnd.BtnShowCashShop"));
		TexPrime_panel_new = TextureHandle(GetHandle("BR_CashShopBtnWnd.TexNew"));
	}
	else
	{
		Me = GetWindowHandle("BR_CashShopBtnWnd");
		BtnShowCashShop = GetButtonHandle("BR_CashShopBtnWnd.BtnShowCashShop");
		TexPrime_panel_new = GetTextureHandle("BR_CashShopBtnWnd.TexNew");
	}
	m_UI_prime_panel_new.Length = 2;
	m_UI_prime_panel_new[0] = "BranchSys3.ui.g_ui_prime_button_new_ani1";
	m_UI_prime_panel_new[1] = "BranchSys3.ui.g_ui_prime_button_new_ani2";
	m_currentAnim = 0;
	m_SubJobClassID = 0;
	m_newAnim = false;
	TexPrime_panel_new.HideWindow();
	return;
}

function Load()
{
	RequestBR_CashShopNewICon();
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int iResult, bShow;

	return;
	bShow = 0;
	GetINIBool("PrimeShop", "UsePrimeShop", bShow, "L2.ini");
	switch(Event_ID)
	{
		case 9015:
			ParseInt(param, "NewIConAnim", iResult);
			if((iResult > 0))
			{
				TexPrime_panel_new.ShowWindow();
				m_newAnim = true;
				PlayAnimation();
			}
			break;
		case 5312:
			if((param != ""))
			{
				ParseInt(param, "CurrentSubjobClassID", m_SubJobClassID);
				if((!getInstanceL2Util().getIsPrologueGrowType(m_SubJobClassID) && (bShow == 1)))
				{
					Me.ShowWindow();
				}
			}
			break;
		case 40:
			m_SubJobClassID = 0;
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "BtnShowCashShop":
			OnBtnShowCashShopClick();
			break;
		default:
			break;
	}
	return;
}

function OnBtnShowCashShopClick()
{
	local string BR_NewCashShop;

	BR_NewCashShop = "BR_NewCashShopWnd";
	if(IsShowWindow(BR_NewCashShop))
	{
		HideWindow(BR_NewCashShop);
		PlaySound("InterfaceSound.inventory_close_01");
	}
	else
	{
		ExecuteEvent(9010);
		PlaySound("InterfaceSound.inventory_open_01");
		m_newAnim = false;
		TexPrime_panel_new.HideWindow();
	}
	return;
}

function OnShow()
{
	local int bShow;
	local bool bIsGrow;

	bShow = 0;
	if((getInstanceUIData().GetIsClassicServer() == false))
	{
		GetINIBool("PrimeShop", "UsePrimeShop", bShow, "L2.ini");
	}
	else if(IsAdenServer())
	{
		GetINIBool("PrimeShop", "UseAdenPrimeShop", bShow, "L2.ini");
	}
	bIsGrow = getInstanceL2Util().checkIsPrologueGrowType(string(self));
	if(((m_SubJobClassID == 0) && bIsGrow))
	{
		bShow = 0;
	}
	if((bShow == 0))
	{
		Me.HideWindow();
	}
	return;
}

function OnTimer(int TimerID)
{
	if((m_newAnim == false))
	{
		return;
	}
	if((TimerID == 1410))
	{
		if((m_currentAnim == 0))
		{
			m_currentAnim = 1;
			TexPrime_panel_new.SetTexture(m_UI_prime_panel_new[m_currentAnim]);
		}
		else
		{
			m_currentAnim = 0;
			TexPrime_panel_new.SetTexture(m_UI_prime_panel_new[m_currentAnim]);
		}
	}
	return;
}

function PlayAnimation()
{
	if(m_newAnim)
	{
		Me.KillTimer(1410);
		Me.SetTimer(1410, 500);
	}
	else
	{
		Me.KillTimer(1410);
	}
	return;
}
