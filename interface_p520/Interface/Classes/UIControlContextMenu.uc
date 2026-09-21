class UIControlContextMenu extends UICommonAPI;

var RichListCtrlHandle List_ListCtrl;
var string Owner;
var int menuHeight;
var array<UIControlContextMenuObject> menuObjects;
var string m_reservedString;
var int m_reservedInt;
//var delegate<DelegateOnClickContextMenu> __DelegateOnClickContextMenu__Delegate;
//var delegate<DelegateOnHide> __DelegateOnHide__Delegate;

static function UIControlContextMenu GetInstance()
{
	return UIControlContextMenu(GetScript("UIControlContextMenu"));
}

delegate DelegateOnClickContextMenu(int SelectedIndex)
{
	return;
}

delegate DelegateOnHide()
{
	return;
}

function Initialize()
{
	List_ListCtrl = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".List_ListCtrl"));
	List_ListCtrl.SetUseStripeBackTexture(false);
	List_ListCtrl.SetSelectedSelTooltip(false);
	return;
}

event OnLoad()
{
	Initialize();
	return;
}

event OnClickListCtrlRecord(string ListCtrlID)
{
	local int SelectedIndex;

	SelectedIndex = List_ListCtrl.GetSelectedIndex();
	List_ListCtrl.SetSelectable(false);
	DelegateOnClickContextMenu(menuObjects[SelectedIndex].Index);
	return;
}

event OnShow()
{
	List_ListCtrl.SetSelectable(true);
	List_ListCtrl.SetSelectedIndex(-1, false);
	m_hOwnerWnd.SetFocus();
	return;
}

event OnHide()
{
	DelegateOnHide();
	return;
}

event OnSetFocus(WindowHandle a_WindowHandle, bool bFocused)
{
	if((a_WindowHandle != m_hOwnerWnd))
	{
		return;
	}
	if(bFocused)
	{
		return;
	}
	if(!m_hOwnerWnd.IsFocused())
	{
		return;
	}
	Hide();
	return;
}

function _SetReservedString(string Str)
{
	m_reservedString = Str;
	return;
}

function string _GetReservedString()
{
	return m_reservedString;
}

function _SetReservedInt(int Num)
{
	m_reservedInt = Num;
	return;
}

function int _GetReservedInt()
{
	return m_reservedInt;
}

function _ShowTo(WindowHandle targetWnd, string OwnerName, optional string RelativePoint, optional string AnchorPoint, optional int OffsetX, optional int OffsetY)
{
	local Rect rectWnd;

	if((RelativePoint == ""))
	{
		RelativePoint = "TopLeft";
	}
	if((AnchorPoint == ""))
	{
		AnchorPoint = "BottomLeft";
	}
	m_hOwnerWnd.SetAnchor(targetWnd.m_WindowNameWithFullPath, RelativePoint, AnchorPoint, OffsetX, OffsetY);
	Show(rectWnd.nX, rectWnd.nY, OwnerName);
	rectWnd = m_hOwnerWnd.GetRect();
	m_hOwnerWnd.ClearAnchor();
	return;
}

function Show(int X, int Y, string OwnerName)
{
	local int i, currentScreenWidth, currentScreenHeight;
	local array<int> wh;

	if((OwnerName == ""))
	{
		return;
	}
	Owner = OwnerName;
	if((menuObjects.Length < 1))
	{
		return;
	}
	i = 0;
	while((i < menuObjects.Length))
	{
		if(!menuObjects[i].bCustomRecord)
		{
			List_ListCtrl.InsertRecord(makeRecord(menuObjects[i]));
		}
		i++;
	}
	wh = HandleSetWindowSize();
	GetCurrentResolution(currentScreenWidth, currentScreenHeight);
	if(((wh[0] + X) > currentScreenWidth))
	{
		X = (currentScreenWidth - wh[0]);
	}
	if(((wh[1] + Y) > currentScreenHeight))
	{
		Y = (currentScreenHeight - wh[1]);
	}
	m_hOwnerWnd.MoveTo(X, Y);
	m_hOwnerWnd.ShowWindow();
	return;
}

function Hide()
{
	Owner = "";
	m_hOwnerWnd.HideWindow();
	return;
}

function UIControlContextMenuObject MenuNew(string Name, optional int Index, optional Color TextColor)
{
	local int Len;

	Len = menuObjects.Length;
	menuObjects[Len] = new Class'Interface.UIControlContextMenuObject';
	menuObjects[Len].Name = Name;
	menuObjects[Len].Index = Index;
	if(((((int(TextColor.R) == 0) && (int(TextColor.G) == 0)) && (int(TextColor.B) == 0)) && (int(TextColor.A) == 0)))
	{
		menuObjects[Len].TextColor = getInstanceL2Util().BrightWhite;
	}
	else
	{
		menuObjects[Len].TextColor = TextColor;
	}
	return menuObjects[Len];
}

function MenuAddIcon(string IconTextureName, optional int iconWidth, optional int iconHeight)
{
	local int lastIndex;

	lastIndex = (menuObjects.Length - 1);
	if((iconWidth == 0))
	{
		menuObjects[lastIndex].iconWidth = 19;
	}
	else
	{
		menuObjects[lastIndex].iconWidth = iconWidth;
	}
	if((iconHeight == 0))
	{
		menuObjects[lastIndex].iconHeight = 19;
	}
	else
	{
		menuObjects[lastIndex].iconHeight = iconHeight;
	}
	lastIndex = (menuObjects.Length - 1);
	menuObjects[lastIndex].Icon = IconTextureName;
	return;
}

function MenuAddRecord(RichListCtrlRowData Record)
{
	local int Len;

	Len = List_ListCtrl.GetRecordCount();
	menuObjects[Len] = new Class'Interface.UIControlContextMenuObject';
	menuObjects[Len].Index = Len;
	menuObjects[Len].bCustomRecord = true;
	List_ListCtrl.InsertRecord(Record);
	return;
}

function MenuLineAdd()
{
	GetDividText(0).ShowWindow();
	GetDividText(0).MoveC(2, (menuObjects.Length * 26));
	return;
}

function MenuRem(int Index)
{
	menuObjects.Remove(Index, 1);
	return;
}

function bool MenuFix(int Index, UIControlContextMenuObject menuObject)
{
	if((menuObjects.Length < Index))
	{
		return false;
	}
	menuObjects[Index] = menuObject;
	List_ListCtrl.InsertRecord(makeRecord(menuObjects[Index]));
	return true;
}

function Clear()
{
	GetDividText(0).HideWindow();
	menuObjects.Length = 0;
	List_ListCtrl.DeleteAllItem();
	SetMenuHeight(26);
	return;
}

function SetMenuHeight(int Height)
{
	List_ListCtrl.SetContentsHeight(Height);
	menuHeight = Height;
	return;
}

function array<int> HandleSetWindowSize()
{
	local int nWidth, nHeight, i, maxLen;
	local array<int> wh;

	maxLen = 0;
	i = 0;
	while((i < menuObjects.Length))
	{
		GetTextSizeDefault(menuObjects[i].Name, nWidth, nHeight);
		if((menuObjects[i].Icon != ""))
		{
			nWidth = (nWidth + menuObjects[i].iconWidth);
		}
		maxLen = Max(nWidth, maxLen);
		i++;
	}
	nHeight = (menuObjects.Length * menuHeight);
	m_hOwnerWnd.SetWindowSize((maxLen + 25), (nHeight + 2));
	GetDividText(0).SetWindowSize((maxLen + 21), 1);
	List_ListCtrl.SetWindowSize((maxLen + 23), nHeight);
	wh[0] = (maxLen + 25);
	wh[1] = (nHeight + 2);
	return wh;
}

function RichListCtrlRowData makeRecord(UIControlContextMenuObject menuObject)
{
	local RichListCtrlRowData Record;

	Record.cellDataList.Length = 1;
	if((menuObject.Icon != ""))
	{
		addRichListCtrlTexture(Record.cellDataList[0].drawitems, menuObject.Icon, menuObject.iconHeight, menuObject.iconWidth, 0, 0);
		AddRichListCtrlString(Record.cellDataList[0].drawitems, menuObject.Name, menuObject.TextColor, false, 0, 3);
	}
	else
	{
		AddRichListCtrlString(Record.cellDataList[0].drawitems, menuObject.Name, menuObject.TextColor);
	}
	return Record;
}

function TextureHandle GetDividText(int Index)
{
	return GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ContextMenu_Divid"));
}

function bool IsMine(string Name)
{
	return (Owner == Name);
}
