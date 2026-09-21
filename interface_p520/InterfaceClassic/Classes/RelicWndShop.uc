class RelicWndShop extends UICommonAPI
	dependson(UIPacket);

const NUMOFPAGE = 2;

struct RelicWndShopDataStruct
{
	var UIControlNeedItemSelectMultiItems multiNeedItemsScr;
	var WindowHandle BtnsWnd;
	var EffectViewportWndHandle effectViewport;
	var EffectViewportWndHandle effectViewportBack;
	var ButtonHandle BuyBtnAuto;
	var ButtonHandle BuyBtnOnce;
	var TextBoxHandle TimeText;
	var int RemainTime;
	var int SummonID;
};

var array<RelicWndShopDataStruct> relicWndShopDatas;
var L2UITimerObject tObject;
var L2UITimerObject timerObj;
var L2UITimerObject timeRefreshObj;
var bool bRQ_C_EX_RELICS_SUMMON_LIST;
var int overIndex;
var int overIndexNew;
var bool bOver;

function InitHandles()
{
	local int i;
	local string pathName;
	local WindowHandle wnd;

	i = 0;
	while((i < relicWndShopDatas.Length))
	{
		pathName = (((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemWnd") $ string(i)) $ ".");
		relicWndShopDatas[i].BtnsWnd = GetWindowHandle((pathName $ "BtnsWnd"));
		relicWndShopDatas[i].BtnsWnd.SetAlpha(0);
		relicWndShopDatas[i].effectViewport = GetEffectViewportWndHandle((pathName $ "effectViewport"));
		relicWndShopDatas[i].effectViewportBack = GetEffectViewportWndHandle((pathName $ "effectViewportBack"));
		relicWndShopDatas[i].TimeText = GetTextBoxHandle((((pathName $ "Time") $ string(i)) $ "_Txt"));
		relicWndShopDatas[i].BuyBtnAuto = GetButtonHandle((pathName $ "BtnsWnd.BuyBtnAuto"));
		relicWndShopDatas[i].BuyBtnOnce = GetButtonHandle((pathName $ "BtnsWnd.BuyBtnOnce"));
		wnd = GetWindowHandle((pathName $ "NeedItemMultiItems"));
		relicWndShopDatas[i].multiNeedItemsScr = Class'InterfaceClassic.UIControlNeedItemSelectMultiItems'.static._InitScript(wnd);
		relicWndShopDatas[i].multiNeedItemsScr._ConnectPopup(GetWindowHandle((pathName $ "UIControlNeedItemSelectMultiItemPopup")));
		i++;
	}
	return;
}

function InittimeRefreshTimerObj()
{
	if((GetRemainTimeRemain() == false))
	{
		return;
	}
	if((timeRefreshObj._timerID == 0))
	{
		timeRefreshObj = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject((1000 * 60));
		timeRefreshObj._DelegateOnTime = HandleDelegateOnTime;
	}
	timeRefreshObj._Play();
	return;
}

function InitNeedItemSelectMultiItemsPopup()
{
	relicWndShopDatas[0].multiNeedItemsScr.DelegateOnUpdateItem = MultiItemOnUpdate0;
	relicWndShopDatas[1].multiNeedItemsScr.DelegateOnUpdateItem = MultiItemOnUpdate1;
	return;
}

function InitFees(array<L2ItemAmount> CostItems, int Index)
{
	local int i;

	relicWndShopDatas[Index].multiNeedItemsScr._StartSelectItems(CostItems.Length);
	i = 0;
	while((i < CostItems.Length))
	{
		relicWndShopDatas[Index].multiNeedItemsScr._AddSelectItemClassID(CostItems[i].ItemClassID, INT64(CostItems[i].ItemAmount));
		i++;
	}
	relicWndShopDatas[Index].multiNeedItemsScr._EndSelectItems();
	relicWndShopDatas[Index].multiNeedItemsScr._SetSelectByIndex(0);
	return;
}

function MultiItemOnUpdate0()
{
	SetButtonEnableDisable(0, relicWndShopDatas[0].multiNeedItemsScr._GetCanBuy());
	return;
}

function MultiItemOnUpdate1()
{
	SetButtonEnableDisable(1, relicWndShopDatas[1].multiNeedItemsScr._GetCanBuy());
	return;
}

function SetButtonEnableDisable(int Index, bool canBuy)
{
	if((canBuy == true))
	{
		relicWndShopDatas[Index].BuyBtnAuto.EnableWindow();
		relicWndShopDatas[Index].BuyBtnOnce.EnableWindow();
	}
	else
	{
		relicWndShopDatas[Index].BuyBtnAuto.DisableWindow();
		relicWndShopDatas[Index].BuyBtnOnce.DisableWindow();
	}
	return;
}

function SetDatas(array<UIPacket._RelicsSummonInfo> relicsSummonInfos)
{
	local int i;
	local array<RelicsSummonCategory> o_Datas;
	local RelicsPlayUIData relicPlayData;

	API_GetRelicsSummonCategoryList(o_Datas);
	i = 0;
	while((i < 2))
	{
		API_GetRelicsPlayData(ERPDT_Summon, relicsSummonInfos[i].nSummonID, relicPlayData);
		InitFees(relicPlayData.CostItems, i);
		MakeInfo(i, relicPlayData, relicsSummonInfos[i]);
		setTimeString(i);
		i++;
	}
	InittimeRefreshTimerObj();
	return;
}

function MakeInfo(int Index, RelicsPlayUIData relicPlayData, UIPacket._RelicsSummonInfo relicsSummonInfo)
{
	relicWndShopDatas[Index].RemainTime = relicsSummonInfo.nRemainTime;
	relicWndShopDatas[Index].SummonID = relicsSummonInfo.nSummonID;
	return;
}

function setTimeString(int Index)
{
	if((relicWndShopDatas[Index].RemainTime < 1))
	{
		relicWndShopDatas[Index].TimeText.SetText(GetSystemString(3979));
	}
	else
	{
		relicWndShopDatas[Index].TimeText.SetText(getInstanceL2Util().getTimeStringBySec3(relicWndShopDatas[Index].RemainTime));
	}
	return;
}

function HandleDelegateOnTime(int Count)
{
	local int i;

	i = 0;
	while((i < relicWndShopDatas.Length))
	{
		relicWndShopDatas[i].RemainTime = Max(0, (relicWndShopDatas[i].RemainTime - 60));
		setTimeString(i);
		i++;
	}
	if((GetRemainTimeRemain() == false))
	{
		timeRefreshObj._Stop();
	}
	return;
}

function DelegateOnEndRefreshBtnEnable()
{
	GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RelicBuyWnd.RefreshBtn")).EnableWindow();
	return;
}

function bool GetRemainTimeRemain()
{
	local int i;

	i = 0;
	while((i < relicWndShopDatas.Length))
	{
		if((relicWndShopDatas[i].RemainTime > 0))
		{
			return true;
		}
		i++;
	}
	return false;
}

function AskSummonID(string pointName, int SummonID, INT64 SummonCount, int CommisionID, INT64 CommisionAmount)
{
	RelicSummonWnd(GetScript("RelicSummonWnd")).External_AskSummonID(pointName, SummonID, int(SummonCount), CommisionID, CommisionAmount);
	return;
}

function int IsOverBtnsHandle(WindowHandle a_WindowHandle)
{
	local int i;

	i = 0;
	while((i < 2))
	{
		if((relicWndShopDatas[i].BtnsWnd == a_WindowHandle))
		{
			return i;
		}
		i++;
	}
	if((a_WindowHandle.m_pTargetWnd == none))
	{
		return -1;
	}
	return IsOverBtnsHandle(a_WindowHandle.GetParentWindowHandle());
}

function SpawnOverEffect(int Index)
{
	relicWndShopDatas[Index].effectViewport.ShowWindow();
	relicWndShopDatas[Index].effectViewport.SpawnEffect("LineageEffect2.ui_screen_message_flow");
	return;
}

function API_GetRelicsSummonCategoryList(out array<RelicsSummonCategory> o_Datas)
{
	GetRelicsSummonCategoryList(o_Datas);
	return;
}

function API_GetRelicsPlayData(UIEventManager.ERelicsPlayDataType a_Type, int a_grade, out RelicsPlayUIData o_data)
{
	GetRelicsPlayData(a_Type, a_grade, o_data);
	return;
}

function RQ_C_EX_RELICS_SUMMON_LIST()
{
	local array<byte> stream;
	local UIPacket._C_EX_RELICS_SUMMON_LIST packet;

	if(bRQ_C_EX_RELICS_SUMMON_LIST)
	{
		return;
	}
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_RELICS_SUMMON_LIST(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(903, stream);
	if((tObject._timerID == 0))
	{
		tObject = Class'InterfaceClassic.L2UITimer'.static.Inst()._AddTimerOnce(5000);
		tObject._DelegateOnEnd = DelegateOnEndC_EX_RELICS_SUMMON_LIST;
	}
	bRQ_C_EX_RELICS_SUMMON_LIST = true;
	return;
}

function DelegateOnEndC_EX_RELICS_SUMMON_LIST()
{
	bRQ_C_EX_RELICS_SUMMON_LIST = false;
	return;
}

function RT_S_EX_RELICS_SUMMON_LIST()
{
	local UIPacket._S_EX_RELICS_SUMMON_LIST packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_RELICS_SUMMON_LIST(packet))
	{
		return;
	}
	Debug(("RT_S_EX_RELICS_SUMMON_LIST" @ string(packet.infos.Length)));
	bRQ_C_EX_RELICS_SUMMON_LIST = false;
	SetDatas(packet.infos);
	return;
}

function string GetSummonName(int Index)
{
	switch(Index)
	{
		case 0:
			return GetSystemString(14831);
		case 1:
			return GetSystemString(14832);
		default:
	}
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	local int i;

	switch(a_ButtonHandle.GetWindowName())
	{
		case "BtnProb":
			Right(a_ButtonHandle.GetParentWindowHandle().GetParentWindowHandle().GetWindowName(), 1);
			Class'InterfaceClassic.RelicShopProbWnd'.static.Inst().ShowShopProbWnd(relicWndShopDatas[0].SummonID);
			break;
		case "BuyBtnOnce":
			i = int(Right(a_ButtonHandle.GetParentWindowHandle().GetParentWindowHandle().GetWindowName(), 1));
			AskSummonID(GetSummonName(i), relicWndShopDatas[i].SummonID, INT64(1), relicWndShopDatas[i].multiNeedItemsScr._GetMyClassID(), relicWndShopDatas[i].multiNeedItemsScr._GetMyAmount());
			break;
		case "BuyBtnAuto":
			i = int(Right(a_ButtonHandle.GetParentWindowHandle().GetParentWindowHandle().GetWindowName(), 1));
			AskSummonID(GetSummonName(i), relicWndShopDatas[i].SummonID, relicWndShopDatas[i].multiNeedItemsScr._GetMaxNumCanBuy(), relicWndShopDatas[i].multiNeedItemsScr._GetMyClassID(), relicWndShopDatas[i].multiNeedItemsScr._GetMyAmount());
			break;
		default:
			break;
	}
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(1181));
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case EV_PacketID(1181):
			RT_S_EX_RELICS_SUMMON_LIST();
			break;
		default:
			break;
	}
	return;
}

event OnLoad()
{
	relicWndShopDatas.Length = 2;
	InitHandles();
	InitNeedItemSelectMultiItemsPopup();
	return;
}

event OnMouseOver(WindowHandle a_WindowHandle)
{
	local int bOverTargetIndex;

	timerObj = Class'InterfaceClassic.L2UITimer'.static.Inst()._AddTimerOnce(1);
	timerObj._DelegateOnEnd = OverEffecthandle;
	bOverTargetIndex = IsOverBtnsHandle(a_WindowHandle);
	if((bOverTargetIndex == -1))
	{
		return;
	}
	overIndexNew = bOverTargetIndex;
	Debug(("OnMouseOver" @ string(overIndex)));
	bOver = true;
	return;
}

event OnMouseOut(WindowHandle a_WindowHandle)
{
	local int bOutTargetIndex;

	timerObj = Class'InterfaceClassic.L2UITimer'.static.Inst()._AddTimerOnce(1);
	timerObj._DelegateOnEnd = OverEffecthandle;
	bOutTargetIndex = IsOverBtnsHandle(a_WindowHandle);
	if((bOutTargetIndex == -1))
	{
		return;
	}
	bOver = false;
	return;
}

function OverEffecthandle()
{
	if((bOver == false))
	{
		relicWndShopDatas[0].BtnsWnd.SetAlpha(0, 0.2000000);
		relicWndShopDatas[0].effectViewport.HideWindow();
		relicWndShopDatas[1].BtnsWnd.SetAlpha(0, 0.2000000);
		relicWndShopDatas[1].effectViewport.HideWindow();
		overIndex = -1;
		return;
	}
	if((overIndexNew == overIndex))
	{
		return;
	}
	relicWndShopDatas[overIndexNew].BtnsWnd.SetAlpha(255, 0.2000000);
	relicWndShopDatas[overIndex].BtnsWnd.SetAlpha(0, 0.2000000);
	relicWndShopDatas[overIndex].effectViewport.HideWindow();
	SpawnOverEffect(overIndexNew);
	overIndex = overIndexNew;
	return;
}

event OnShow()
{
	RQ_C_EX_RELICS_SUMMON_LIST();
	relicWndShopDatas[0].effectViewportBack.SpawnEffect("LineageEffect3.ui_npcdeco_gold");
	relicWndShopDatas[1].effectViewportBack.SpawnEffect("LineageEffect3.ui_npcdeco_gold_3p");
	return;
}

event OnHide()
{
	relicWndShopDatas[0].effectViewportBack.SpawnEffect("");
	relicWndShopDatas[1].effectViewportBack.SpawnEffect("");
	return;
}
