class CollectionSystemStandComponent extends UICommonAPI;

const STATE_UP = 'stateUp';
const STATE_OVER = 'stateOver';
const STATE_DOWN = 'stateDown';

var WindowHandle Me;
var string m_Windowname;
var string m_ParentName;
var EffectViewportWndHandle effectViewportWnd;
var EffectViewportWndHandle effectViewportWndOver;
var string EffectName;
var bool bCompleted;
var CollectionSystem collectionSystemScript;
var CollectionSystemSub collectionSystemSubScript;
var ButtonHandle KeyItemBTN;
var CollectionMainData cMainData;
var int CurrentState;

function Initialize()
{
	effectViewportWnd = GetEffectViewportWndHandle((m_Windowname $ ".KeyItem_EffectViewport"));
	effectViewportWndOver = GetEffectViewportWndHandle((m_Windowname $ ".KeyItem_EffectViewportOver"));
	KeyItemBTN = GetButtonHandle((m_Windowname $ ".KeyItemBTN"));
	GotoState('stateUp');
	return;
}

function Init(string WindowName, CollectionMainData _mData, optional bool bFavorite)
{
	local int SubIndex;

	m_Windowname = WindowName;
	Me = GetWindowHandle(m_Windowname);
	cMainData = _mData;
	collectionSystemScript = CollectionSystem(GetScript("CollectionSystem"));
	if(bFavorite)
	{
		cMainData.Category = collectionSystemScript.favoriteCategory;
		EffectName = collectionSystemScript.GetStringKeyByIndex((cMainData.Category - 1), (cMainData.background_level - 1));
	}
	else
	{
		SubIndex = collectionSystemScript.GetSubIndexByMainID(cMainData.main_id);
		EffectName = collectionSystemScript.GetStringKeyByIndex((cMainData.Category - 1), SubIndex);
	}
	Initialize();
	SetItemTooltip();
	return;
}

function SetItemTooltip()
{
	local ItemInfo iInfo;
	local string keyItemname;

	if((cMainData.key_item_id > 0))
	{
		Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(cMainData.key_item_id), iInfo);
		keyItemname = iInfo.Name;
	}
	else
	{
		keyItemname = collectionSystemScript.GetStringNameByIndex((cMainData.Category - 1));
	}
	KeyItemBTN.SetTooltipCustomType(MakeTooltipSimpleText(keyItemname));
	return;
}

event OnClickButton(string btnName)
{
	switch(btnName)
	{
		case "KeyItemBTN":
			HandleClick();
			break;
		default:
			break;
	}
	return;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	switch(a_WindowHandle.GetWindowName())
	{
		case "KeyItemBTN":
			HandleBtnDown();
			break;
		default:
			break;
	}
	return;
}

event OnMouseOut(WindowHandle a_WindowHandle)
{
	switch(a_WindowHandle.GetWindowName())
	{
		case "KeyItemBTN":
			HandleBtnOut();
			break;
		default:
			break;
	}
	return;
}

event OnMouseOver(WindowHandle a_WindowHandle)
{
	switch(a_WindowHandle.GetWindowName())
	{
		case "KeyItemBTN":
			HandleBtnOver();
			break;
		default:
			break;
	}
	return;
}

function HandleBtnOver()
{
	GotoState('stateOver');
	return;
}

function HandleBtnOut()
{
	GotoState('stateUp');
	return;
}

function HandleBtnUp()
{
	GotoState('stateOver');
	return;
}

function HandleBtnDown()
{
	GotoState('stateDown');
	return;
}

function HandleClick()
{
	collectionSystemScript.SetCurrentCategory(cMainData.Category);
	return;
}

function popupDetail()
{
	if((cMainData.key_item_id > 0))
	{
		collectionSystemScript.SetCollectionPopupDetail(cMainData.collection_ID);
	}
	return;
}

function CollectionSystemCategoryComponent GetCollectionSystemCategoryComponentScript()
{
	return collectionSystemScript.collectionSystemCategoryScript.collectionSystemCategoryComponents[(cMainData.Category - 1)];
}

function SetShow()
{
	SetComplete();
	return;
}

function SetComplete()
{
	local CollectionInfo cInfo;
	local CollectionData cData;
	local array<ItemInfo> iIonfos;

	if((cMainData.key_item_id > 0))
	{
		if(!collectionSystemScript.API_GetCollectionInfo(cMainData.collection_ID, cInfo))
		{
			return;
		}
		if(!collectionSystemScript.API_GetCollectionData(cMainData.collection_ID, cData))
		{
			return;
		}
		bCompleted = collectionSystemScript.collectionSystemSubScript.GetItemList(cInfo, cData, iIonfos);
	}
	if(bCompleted)
	{
		effectViewportWnd.SpawnEffect(GetEffectName((EffectName $ "_fullnormal")));
	}
	else
	{
		effectViewportWnd.SpawnEffect(GetEffectName((EffectName $ "_normal")));
	}
	effectViewportWndOver.HideWindow();
	switch(CurrentState)
	{
		case 0:
			GotoState('stateUp');
			break;
		case 1:
			GotoState('stateDown');
			break;
		case 2:
			GotoState('stateOver');
			break;
		default:
			break;
	}
	return;
}

function string GetEffectName(string keyItem)
{
	return ("LineageEffect2." $ collectionSystemScript.API_GetGeneralEffectName(keyItem));
}

auto state stateUp
{
	function BeginState()
	{
		if((collectionSystemScript.collectionSystemCategoryScript.collectionSystemCategoryComponents.Length > 0))
		{
			GetCollectionSystemCategoryComponentScript().SetBtnOut();
		}
		effectViewportWndOver.HideWindow();
		CurrentState = 0;
		return;
	}

	function EndState()
	{
		return;
	}
}

state stateDown
{
	function BeginState()
	{
		if((collectionSystemScript.collectionSystemCategoryScript.collectionSystemCategoryComponents.Length > 0))
		{
			GetCollectionSystemCategoryComponentScript().SetBtnOut();
		}
		effectViewportWndOver.HideWindow();
		CurrentState = 1;
		return;
	}

	function EndState()
	{
		return;
	}
}

state stateOver
{
	function BeginState()
	{
		if((collectionSystemScript.collectionSystemCategoryScript.collectionSystemCategoryComponents.Length > 0))
		{
			GetCollectionSystemCategoryComponentScript().SetBtnOver();
		}
		effectViewportWndOver.ShowWindow();
		if(!bCompleted)
		{
			effectViewportWndOver.SpawnEffect(GetEffectName((EffectName $ "_over")));
		}
		else
		{
			effectViewportWndOver.SpawnEffect(GetEffectName((EffectName $ "_fullover")));
		}
		CurrentState = 2;
		return;
	}

	function EndState()
	{
		effectViewportWndOver.HideWindow();
		return;
	}
}
