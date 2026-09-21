class CollectionSystemCategory extends UICommonAPI;

enum CollectionSystemCategoryState
{
	stand,                          // 0
	Sub                             // 1
};

var WindowHandle Me;
var string m_Windowname;
var L2Util util;
var array<CollectionSystemCategoryComponent> collectionSystemCategoryComponents;
var CollectionSystem collectionSystemScript;
var CollectionSystemCategoryState CurrentState;

function SetState(CollectionSystemCategoryState State)
{
	switch(State)
	{
		case stand:
			SetStateStand();
			break;
		case Sub:
			SetStateSub();
			break;
		default:
			break;
	}
	CurrentState = State;
	return;
}

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	util = L2Util(GetScript("L2Util"));
	collectionSystemScript = CollectionSystem(GetScript("collectionSystem"));
	InitCategoryButtons();
	Me.SetAnchor("", "BottomCenter", "BottomCenter", 0, -10);
	return;
}

function SetStateStand()
{
	local int i;

	i = 0;
	while((i < collectionSystemScript.MAX_CATEGORY))
	{
		collectionSystemCategoryComponents[i].SetDeselecte();
		i++;
	}
	return;
}

function SetStateSub()
{
	local int i;

	i = 0;
	while((i < collectionSystemScript.MAX_CATEGORY))
	{
		collectionSystemCategoryComponents[i].SetDeselecte();
		i++;
	}
	collectionSystemCategoryComponents[(collectionSystemScript.selectedCategory - 1)].SetSelecte();
	return;
}

function InitCategoryButtons()
{
	InitCategoryButton(0);
	InitCategoryButton(1);
	InitCategoryButton(2);
	InitCategoryButton(3);
	InitCategoryButton(4);
	InitCategoryButton(5);
	InitCategoryButton(6);
	InitCategoryButton(7);
	return;
}

function InitCategoryButton(int Num)
{
	local string _windowName, buttonName;

	buttonName = collectionSystemScript.GetStringNameByIndex(Num);
	_windowName = ((m_Windowname $ ".CATEGORYBTN_wnd") $ Int2Str2(Num));
	GetWindowHandle(_windowName).SetScript("CollectionSystemCategoryComponent");
	collectionSystemCategoryComponents[Num] = CollectionSystemCategoryComponent(GetWindowHandle(_windowName).GetScript());
	collectionSystemCategoryComponents[Num].Init(_windowName, buttonName, (Num + 1));
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(150);
	RegisterEvent(40);
	return;
}

event OnLoad()
{
	Initialize();
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 150:
			if(ChkSerVer())
			{
				HandleGameInit();
			}
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	return;
}

function HandleGameInit()
{
	if((GetGameStateName() != "GAMINGSTATE"))
	{
		return;
	}
	return;
}

function bool SetCurrentCollectionCount()
{
	local int i;
	local CollectionCount tmpCollectionCount;

	i = 1;
	while((i <= (collectionSystemScript.MAX_CATEGORY - 2)))
	{
		if(!collectionSystemScript.API_GetCollectionCount(i, tmpCollectionCount))
		{
			return false;
		}
		collectionSystemCategoryComponents[(i - 1)].SetPoint(tmpCollectionCount.CollectionCompleteCount, tmpCollectionCount.CollectionTotalCount);
		i++;
	}
	return true;
}

function HideAllDot()
{
	local int i;

	i = 0;
	while((i < collectionSystemCategoryComponents.Length))
	{
		collectionSystemCategoryComponents[i].HideDot();
		i++;
	}
	return;
}

function ShowDot(int Category, int Type)
{
	collectionSystemCategoryComponents[(Category - 1)].ShowDot(Type);
	return;
}

function HideDot(int Category)
{
	collectionSystemCategoryComponents[(Category - 1)].HideDot();
	return;
}

function string Int2Str2(int i)
{
	if((i < 10))
	{
		return ("0" $ string(i));
	}
	return string(i);
}

function bool GetStringIDFromBtnName(string btnName, string someString, out string strID)
{
	if(!CheckBtnName(btnName, someString))
	{
		return false;
	}
	strID = Mid(btnName, Len(someString));
	return true;
}

function bool CheckBtnName(string btnName, string someString)
{
	return (Left(btnName, Len(someString)) == someString);
}

function bool ChkSerVer()
{
	return getInstanceUIData().GetIsLiveServer();
}
