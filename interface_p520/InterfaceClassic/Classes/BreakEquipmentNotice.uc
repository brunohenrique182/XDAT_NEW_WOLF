class BreakEquipmentNotice extends UICommonAPI
	dependson(UIPacket);

var WindowHandle Me;
var string m_Windowname;
var int clickedX;
var int clickedY;
var bool OnMousePressed;
var int nBreakCount;
var L2UITweenTwinkleObject twinkleObject;
var TextureHandle AlarmTexture;

function OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(3410);
	RegisterEvent(EV_PacketID(1197));
	return;
}

function OnShow()
{
	return;
}

function OnLoad()
{
	Me = GetWindowHandle(m_Windowname);
	AlarmTexture = GetMeTexture("AlarmTexture");
	return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	local Rect rectWnd;

	rectWnd = Me.GetRect();
	clickedX = rectWnd.nX;
	clickedY = rectWnd.nY;
	return;
}

event OnMouseOver(WindowHandle W)
{
	if((W.GetWindowName() == "BrokenItemBtn"))
	{
		Class'InterfaceClassic.L2UITween'.static.Inst().StopShake("BreakEquipmentNotice", 100);
		twinkleObject._Stop();
		AlarmTexture.HideWindow();
	}
	return;
}

function OnClickButton(string Name)
{
	local Rect rectWnd, pRect;
	local int currentWidth, currentHeight, setX, setY;

	switch(Name)
	{
		case "BrokenItemBtn":
			rectWnd = Me.GetRect();
			if(((GetAbs((clickedX - rectWnd.nX)) > 3) || ((clickedY - rectWnd.nY) > 3)))
			{
				if(GetWindowHandle("BreakEquipmentRepairWnd").IsShowWindow())
				{
					GetWindowHandle("BreakEquipmentRepairWnd").SetFocus();
				}
				return;
			}
			if(GetWindowHandle("BreakEquipmentRepairWnd").IsShowWindow())
			{
				GetWindowHandle("BreakEquipmentRepairWnd").HideWindow();
			}
			else
			{
				BreakEquipmentRepairWnd(GetScript("BreakEquipmentRepairWnd")).DialogWndOpen(nBreakCount);
				GetCurrentResolution(currentWidth, currentHeight);
				pRect = GetWindowHandle("BreakEquipmentRepairWnd").GetRect();
				if(((rectWnd.nX + (pRect.nWidth / 2)) > currentWidth))
				{
					setX = (((currentWidth - rectWnd.nX) - (rectWnd.nWidth / 2)) - (pRect.nWidth / 2));
				}
				else if(((rectWnd.nX + (rectWnd.nWidth / 2)) < (pRect.nWidth / 2)))
				{
					setX = ((pRect.nWidth / 2) - (rectWnd.nX + (rectWnd.nWidth / 2)));
				}
				else
				{
					setX = 0;
				}
				if((rectWnd.nY < (pRect.nHeight + 5)))
				{
					setY = ((pRect.nHeight / 2) - 30);
				}
				else
				{
					setY = -pRect.nHeight;
				}
				GetWindowHandle("BreakEquipmentRepairWnd").SetAnchor("BreakEquipmentNotice", "TopCenter", "TopCenter", setX, setY);
			}
			break;
		default:
			break;
	}
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	local int nQuitRestrictField;

	switch(a_EventID)
	{
		case 3410:
			HandleStateChanged();
			break;
		case EV_PacketID(1197):
			Handle_S_EX_BREAK_EQUIPMENT_NOTI();
			break;
		case 40:
			ParseInt(a_Param, "QuitRestrictField", nQuitRestrictField);
			if((nQuitRestrictField == 0))
			{
				nBreakCount = 0;
			}
			break;
		default:
			break;
	}
	return;
}

function OnHide()
{
	twinkleObject._Stop();
	AlarmTexture.HideWindow();
	return;
}

function Handle_S_EX_BREAK_EQUIPMENT_NOTI()
{
	local UIPacket._S_EX_BREAK_EQUIPMENT_NOTI packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_BREAK_EQUIPMENT_NOTI(packet))
	{
		return;
	}
	Debug(("S_EX_BREAK_EQUIPMENT_NOTI, nBreakCount:" @ string(packet.nBreakCount)));
	nBreakCount = packet.nBreakCount;
	BreakEquipmentRepairWnd(GetScript("BreakEquipmentRepairWnd")).OnClickPopupCancel();
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)), "InventoryWnd");
	if((nBreakCount > 0))
	{
		twinkleObject = Class'InterfaceClassic.L2UITween'.static.Inst()._AddTweenTwinlkle(AlarmTexture, 4.5000000, 0.5000000, 800.0000000, 0, 255, 0.0000000);
		Class'InterfaceClassic.L2UITween'.static.Inst().StartShake("BreakEquipmentNotice", 4, 1000, small, 0, 100);
		AlarmTexture.ShowWindow();
		GetMeButton("BrokenItemBtn").SetTooltipCustomType(MakeTooltipSimpleColorText(((GetSystemString(14897) $ " : ") $ string(nBreakCount)), GTColor().White));
	}
	if((GetGameStateName() != "COLLECTIONSTATE"))
	{
		if((nBreakCount > 0))
		{
			Me.ShowWindow();
		}
	}
	if((nBreakCount <= 0))
	{
		Me.HideWindow();
	}
	return;
}

function fixIt()
{
	nBreakCount = 0;
	Me.HideWindow();
	return;
}

function HandleStateChanged()
{
	if((GetGameStateName() != "GAMINGSTATE"))
	{
		return;
	}
	if((nBreakCount > 0))
	{
		Me.ShowWindow();
	}
	else
	{
		Me.HideWindow();
	}
	return;
}

function int GetAbs(int Num)
{
	if((Num < 0))
	{
		return -Num;
	}
	return Num;
}

defaultproperties
{
	m_Windowname="BreakEquipmentNotice"
}
