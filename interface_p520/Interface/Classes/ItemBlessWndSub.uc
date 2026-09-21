class ItemBlessWndSub extends UICommonAPI;

var string m_Windowname;
var WindowHandle Me;
var ItemWindowHandle SubWnd_Item1;
var TextBoxHandle descTextBox;
var WindowHandle DescriptionMsgWnd;
var ItemBlessWnd itemBlessWndScript;
var L2Util util;
var array<int> groupIDs;

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	SubWnd_Item1 = GetItemWindowHandle((m_Windowname $ ".ItemBlessWndSubWnd_Item1"));
	util = L2Util(GetScript("L2Util"));
	itemBlessWndScript = ItemBlessWnd(GetScript("itemBlessWnd"));
	descTextBox = GetTextBoxHandle((m_Windowname $ ".descTextBox"));
	DescriptionMsgWnd = GetWindowHandle((m_Windowname $ ".DescriptionMsgWnd"));
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(2610);
	RegisterEvent(2600);
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 2610:
			if(Me.IsShowWindow())
			{
				refresh();
				SetState();
			}
			break;
		default:
			break;
	}
	return;
}

event OnLoad()
{
	Initialize();
	return;
}

event OnShow()
{
	refresh();
	HandleDescriptionMsgWnd();
	return;
}

event OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);
	return;
}

event OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo Info;

	SubWnd_Item1.GetItem(Index, Info);
	if((Info.Id.ClassID > 0))
	{
		itemBlessWndScript.SetItemInfo(Info);
	}
	return;
}

function refresh()
{
	local int i;
	local array<ItemInfo> iInfos;

	SubWnd_Item1.Clear();
	GetObjectFindItemByCompare().DelegateCompare = Compare;
	iInfos = GetObjectFindItemByCompare().GetAllItemByCompare();
	iInfos = util.SortItemArray(iInfos);
	i = 0;
	while((i < iInfos.Length))
	{
		SubWnd_Item1.AddItem(iInfos[i]);
		i++;
	}
	if((iInfos.Length > 0))
	{
		DescriptionMsgWnd.HideWindow();
	}
	else
	{
		DescriptionMsgWnd.ShowWindow();
	}
	return;
}

function SetState()
{
	HandleDescriptionMsgWnd();
	return;
}

function HandleDescriptionMsgWnd()
{
	local bool canDropItem, noneItems;

	noneItems = (SubWnd_Item1.GetItemNum() == 0);
	switch(itemBlessWndScript.CurrentState)
	{
		case non:
		case READY:
			canDropItem = true;
			break;
		case Progress:
		case Result:
			canDropItem = false;
			break;
		default:
			break;
	}
	if((canDropItem && !noneItems))
	{
		DescriptionMsgWnd.HideWindow();
	}
	else
	{
		DescriptionMsgWnd.ShowWindow();
	}
	if(noneItems)
	{
		descTextBox.ShowWindow();
	}
	else
	{
		descTextBox.HideWindow();
	}
	return;
}

function SetGroupIDs(array<int> _groupIDs)
{
	groupIDs = _groupIDs;
	return;
}

function bool Compare(ItemInfo iInfo)
{
	local int i;
	local BlessOptionUIData optionList;

	Class'NWindow.UIDATA_ITEM'.static.GetBlessOptionData(iInfo.Id.ClassID, optionList);
	if((int(optionList.Type) == 1))
	{
	}
	else if(iInfo.IsBlessedItem)
	{
		return false;
	}
	if(isDamagedItem(iInfo))
	{
		return false;
	}
	i = 0;
	while((i < groupIDs.Length))
	{
		if((iInfo.EnchantBlessGroupID == groupIDs[i]))
		{
			return true;
		}
		i++;
	}
	return false;
}
