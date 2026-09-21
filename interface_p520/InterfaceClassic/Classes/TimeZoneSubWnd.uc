class TimeZoneSubWnd extends UICommonAPI;

var string m_Windowname;
var WindowHandle Me;
var ItemWindowHandle TimeZoneSubWnd_ItemWnd;
var TimeZoneWnd timeZoneWndScript;

function Initialize()
{
	Me = GetWindowHandle(m_Windowname);
	TimeZoneSubWnd_ItemWnd = GetItemWindowHandle((m_Windowname $ ".TimeZoneSubWnd_ItemWnd"));
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(11230);
	RegisterEvent(2610);
	return;
}

function OnLoad()
{
	Initialize();
	SetClosingOnESC();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 11230:
			HandleTimeRestrictFieldChargeResult(param);
			break;
		case 2610:
			HandleUpdateItem(param);
			break;
		default:
			break;
	}
	return;
}

function HandleUpdateItem(string param)
{
	local int i, ItemNum, ClassID;
	local ItemInfo Info;
	local string Type;

	if(!Me.IsShowWindow())
	{
		return;
	}
	ParseInt(param, "ClassID", ClassID);
	i = 0;
	while((i < TimeZoneSubWnd_ItemWnd.GetItemNum()))
	{
		TimeZoneSubWnd_ItemWnd.GetItem(i, Info);
		if((Info.Id.ClassID == ClassID))
		{
			ParseString(param, "type", Type);
			if((Type == "delete"))
			{
				TimeZoneSubWnd_ItemWnd.DeleteItem(i);
				return;
			}
			else
			{
				ParseInt(param, "ItemNum", ItemNum);
				Info.ItemNum = INT64(ItemNum);
			}
			TimeZoneSubWnd_ItemWnd.SetItem(i, Info);
			return;
		}
		i++;
	}
	return;
}

function HandleTimeRestrictFieldChargeResult(string param)
{
	local int FieldId;

	if(!Me.IsShowWindow())
	{
		return;
	}
	ParseInt(param, "FieldID", FieldId);
	return;
}

function OnDBClickItemWithHandle(ItemWindowHandle a_hItemWindow, int Index)
{
	OnRClickItemWithHandle(a_hItemWindow, Index);
	return;
}

function OnRClickItemWithHandle(ItemWindowHandle a_hItemWindow, int Index)
{
	local ItemInfo Info;

	a_hItemWindow.GetItem(Index, Info);
	RequestUseItem(Info.Id);
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Close_Btn":
			Me.HideWindow();
			break;
		default:
			break;
	}
	return;
}

function OnShow()
{
	Me.SetFocus();
	if(getInstanceUIData().GetIsClassicServer())
	{
		Me.SetDraggable(false);
	}
	return;
}

function API_GetTimeRestrictFieldInfo(int FieldId, out TimeRestrictFieldUIData fieldUIData)
{
	GetTimeRestrictFieldInfo(FieldId, fieldUIData);
	return;
}

function HandleGetItemList(int FieldId)
{
	local int i;
	local array<int> RefillItemList;
	local TimeRestrictFieldUIData fieldUIData;
	local ItemInfo refillItemInfo;
	local InventoryWnd invenScript;
	local ItemID cID;

	TimeZoneSubWnd_ItemWnd.Clear();
	API_GetTimeRestrictFieldInfo(FieldId, fieldUIData);
	RefillItemList = fieldUIData.RefillItemList;
	invenScript = InventoryWnd(GetScript("InventoryWnd"));
	i = 0;
	while((i < RefillItemList.Length))
	{
		cID.ClassID = RefillItemList[i];
		if(invenScript.GetInventoryItemInfo(cID, refillItemInfo, true))
		{
			refillItemInfo.bShowCount = true;
			TimeZoneSubWnd_ItemWnd.AddItem(refillItemInfo);
		}
		i++;
	}
	return;
}

function SetShowSubWindow(int FieldId, ButtonHandle targetButton)
{
	local int currentScreenWidth, currentScreenHeight, myWidth, targetX;
	local Rect rectWnd;

	HandleGetItemList(FieldId);
	rectWnd = Me.GetRect();
	myWidth = rectWnd.nWidth;
	GetCurrentResolution(currentScreenWidth, currentScreenHeight);
	rectWnd = targetButton.GetRect();
	if((currentScreenWidth < (rectWnd.nX + myWidth)))
	{
		targetX = (currentScreenWidth - myWidth);
	}
	else
	{
		targetX = (rectWnd.nX + 20);
	}
	Me.ClearAnchor();
	Me.MoveTo(targetX, rectWnd.nY);
	Me.ShowWindow();
	Me.SetDraggable(true);
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="TimeZoneSubWnd"
}
