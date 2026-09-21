class HomunculusWndRevolution extends UICommonAPI
	dependson(UIPacket);

const LISTITEMMAX = 7;
const EVOLUTION_CLASSID = 83051;

var HomunculusWnd HomunculusWndScript;
var HomunculusWndMainList homunculusWndMainListScript;
var HomunculusWndMainViewport homunculusWndMainViewportScript;
var array<HomunculusWndMainListItem> listItems;
var HomunculusWndMainListItem listItem0;
var HomunculusWndMainListItem listItem1;
var UIControlPageNavi pageNavi;
var UIControlTilelist scrollList;
var UIControlNeedItemList needItemScript;
var WindowHandle ScrollAreaWnd;
var ButtonHandle btn0;
var EffectViewportWndHandle effectViewport;
var WindowHandle resultWnd;
var EffectViewportWndHandle effectViewportResult;
var CharacterViewportWindowHandle ObjectViewport;
var TextBoxHandle txtResult0;
var array<HomunculusAPI.HomunculusData> homunculusDatas;
var int nActivateSlotIndex;
var bool bRequested;
var int evolutionPoint;

function Initialize()
{
	HomunculusWndScript = HomunculusWnd(GetScript("HomunculusWnd"));
	if(!HomunculusWndScript.ChkSerVer())
	{
		return;
	}
	homunculusWndMainViewportScript = HomunculusWndMainViewport(GetScript("HomunculusWnd.HomunculusWndMainViewport"));
	homunculusWndMainListScript = HomunculusWndMainList(GetScript("HomunculusWnd.HomunculusWndMainList"));
	btn0 = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".btn0"));
	btn0.DisableWindow();
	effectViewport = GetEffectViewportWndHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EffectViewport"));
	resultWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".resultWnd"));
	ObjectViewport = GetCharacterViewportWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".resultWnd.ObjectViewport"));
	ObjectViewport.SetBackgroundTex("L2UI_EPIC.HomunCulusWnd.Homun_birthResultBG_04");
	effectViewportResult = GetEffectViewportWndHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".resultWnd.EffectViewportResult"));
	ObjectViewport.SetUISound(true);
	txtResult0 = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".resultWnd.txtResult0"));
	ScrollAreaWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollAreaWnd"));
	ScrollAreaWnd.HideWindow();
	InitPageNavi();
	InitHandleListItems();
	InitNeedItem();
	InitTileList();
	return;
}

function InitPageNavi()
{
	local WindowHandle PageNaviControl;

	PageNaviControl = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollAreaWnd.PageNaviControl"));
	PageNaviControl.SetScript("UIControlPageNavi");
	pageNavi = UIControlPageNavi(PageNaviControl.GetScript());
	pageNavi.Init((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollAreaWnd.PageNaviControl"));
	pageNavi.SetTotalPage(3);
	pageNavi.Go(1);
	pageNavi.DelegeOnChangePage = pageChanged;
	return;
}

function InitHandleListItems()
{
	local int i;
	local string Path;

	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Item0")).SetScript("HomunculusWndMainListItem");
	GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Item1")).SetScript("HomunculusWndMainListItem");
	listItem0 = HomunculusWndMainListItem(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Item0")).GetScript());
	listItem1 = HomunculusWndMainListItem(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Item1")).GetScript());
	listItem0._resolution = true;
	listItem1._resolution = true;
	listItem0.Init((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Item0"));
	listItem1.Init((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Item1"));
	listItem1.m_hOwnerWnd.SetTooltipType("text");
	listItem1.m_hOwnerWnd.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13401)));
	listItem0.SetState(Normal);
	ClearItem1();
	listItem1.DelegateOnClickThis = HandleDelegateOnClickThis;
	i = 0;
	while((i < 7))
	{
		Path = ((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ScrollAreaWnd.ScrollArea.itemRenderer0") $ string(i));
		GetWindowHandle(Path).SetScript("HomunculusWndMainListItem");
		listItems[i] = HomunculusWndMainListItem(GetWindowHandle(Path).GetScript());
		listItems[i].Init(Path);
		listItems[i].SetState(READY);
		listItems[i].DelegateOnClickThis = HandleDelegateOnClickSacrificeListItem;
		i++;
	}
	return;
}

function InitTileList()
{
	scrollList = Class'InterfaceClassic.UIControlTilelist'.static.InitScript(ScrollAreaWnd, 7, 1);
	scrollList.DelegateOnItemRenderer = HandleDelegateOnItemRenderer;
	scrollList.DelegateOnClick = HandleDelegateOnClick;
	scrollList._SetUsePage(true);
	scrollList._SetTileListItemNumTotal(18);
	scrollList.DelegateOnScroll = HandleOnScroll;
	return;
}

function InitNeedItem()
{
	needItemScript = Class'InterfaceClassic.UIControlNeedItemList'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NeedItemWnd")), 2, 2);
	needItemScript._SetUseDefaultBackground(false);
	needItemScript.DelegateOnUpdateItem = HandleOnNeedItemUpted;
	return;
}

function SetItem0()
{
	listItem0.SetHomunculusData(homunculusWndMainViewportScript.GetCurrHomunculusData());
	SetItemsExpData(listItem0);
	return;
}

function ClearItem1()
{
	listItem1.ClearAll();
	listItem1.SetState(READY);
	listItem1.SetEnable();
	listItem1._SetTooltipSacrifice();
	btn0.DisableWindow();
	return;
}

function HandleDelegateOnClickThis(HomunculusWndMainListItem item)
{
	ChkNHideDialog();
	SetSacrificeList();
	ScrollAreaWnd.ShowWindow();
	ScrollAreaWnd.SetFocus();
	return;
}

function HandleDelegateOnClickSacrificeListItem(HomunculusWndMainListItem item)
{
	if(item.currHomunculusData.Activate)
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13968));
		return;
	}
	listItem1.SetHomunculusData(item.currHomunculusData);
	listItem1.SetState(Normal);
	SetItemsExpData(listItem1);
	ScrollAreaWnd.HideWindow();
	HandleOnNeedItemUpted();
	return;
}

function HandleDelegateOnClick(string BTNID, int rendererIndex, int itemIndex)
{
	switch(BTNID)
	{
		case "close_Btn":
			ScrollAreaWnd.HideWindow();
			break;
		default:
			listItem1.SetHomunculusData(homunculusDatas[itemIndex]);
			break;
	}
	return;
}

function SetSacrificeList()
{
	local int i;
	local array<HomunculusAPI.HomunculusData> datas;

	datas = HomunculusWndScript.API_GetHomunculusDatas();
	homunculusDatas.Length = 0;
	i = 0;
	while((i < datas.Length))
	{
		if((datas[i].Type != 2))
		{
			i++;
			continue;
		}
		if((datas[i].idx == listItem0.currHomunculusData.idx))
		{
			i++;
			continue;
		}
		if(((datas[i].idx == listItem1.currHomunculusData.idx) && (listItem1.currHomunculusData.Id > 0)))
		{
			i++;
			continue;
		}
		homunculusDatas[homunculusDatas.Length] = datas[i];
		i++;
	}
	scrollList._SetTileListItemNumTotal(homunculusDatas.Length);
	scrollList._Refresh();
	pageNavi.SetTotalPage((scrollList._PageMax() + 1));
	pageNavi.Go(1);
	return;
}

function HandleOnScroll()
{
	pageNavi.Go((scrollList._Page() + 1));
	return;
}

function bool _ChkSacrificeState()
{
	if(ScrollAreaWnd.IsShowWindow())
	{
		ScrollAreaWnd.HideWindow();
		return true;
	}
	return false;
}

function HandleDelegateOnItemRenderer(string itemRendererID, int rendererIndex, int Position)
{
	if((homunculusDatas.Length <= Position))
	{
		listItems[rendererIndex].ClearAll();
	}
	else
	{
		listItems[rendererIndex].SetHomunculusData(homunculusDatas[Position]);
		listItems[rendererIndex].SetState(Normal);
		if(listItems[rendererIndex].currHomunculusData.Activate)
		{
			listItems[rendererIndex]._SetSacrificeConditionText();
		}
	}
	SetItemsExpData(listItems[rendererIndex]);
	return;
}

function SetNeedItems()
{
	local int i;
	local HomunculusAPI.HomunculusNpcData npcData;

	npcData = HomunculusWndScript.GetHomunculusNpcData(listItem0.currHomunculusData.Id);
	needItemScript.CleariObjects();
	needItemScript.AddNeedItemClassID(83051, INT64(npcData.EvolutionCostPoint));
	needItemScript.ModifyCurrentAmount(0, INT64(evolutionPoint));
	i = 0;
	while((i < npcData.EvolutionCostItems.Length))
	{
		needItemScript.AddNeedItemClassID(npcData.EvolutionCostItems[i].ItemClassID, npcData.EvolutionCostItems[i].ItemAmount);
		i++;
	}
	needItemScript.SetBuyNum(INT64(1));
	return;
}

event OnShow()
{
	SetItem0();
	SetNeedItems();
	ClearItem1();
	SetSacrificeList();
	btn0.DisableWindow();
	ScrollAreaWnd.HideWindow();
	GetStatusBarHandle((listItem1.m_Windowname $ ".EXPBar")).SetPointExpPercentRate((0.0000000 / 0.0000000));
	effectViewport.SpawnEffect("LineageEffect2.ui_soul_crystal");
	resultWnd.HideWindow();
	return;
}

event OnHide()
{
	ChkNHideDialog();
	effectViewport.SpawnEffect("");
	return;
}

event OnLoad()
{
	Initialize();
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "HelpWnd_Btn":
			Class'InterfaceClassic.HelpWnd'.static.ShowHelp(109);
			break;
		case "close_Btn":
			HomunculusWndScript.SetState(Main);
			break;
		case "Btn0":
			HandleDialogShow();
			break;
		case "btnConfirm":
			HandleOnClickConfirm();
			break;
		default:
			break;
	}
	return;
}

function ChkNHideDialog()
{
	if(Class'InterfaceClassic.DialogBox'.static.Inst().m_hOwnerWnd.IsShowWindow())
	{
		if((("Transient." $ HomunculusWndScript.m_hOwnerWnd.m_WindowNameWithFullPath) == Class'InterfaceClassic.DialogBox'.static.Inst().GetTarget()))
		{
			Class'InterfaceClassic.DialogBox'.static.Inst().HideDialog();
		}
	}
	return;
}

function HandleDialogShow()
{
	DialogSetID(-1);
	DialogShow(DialogModalType_Modalless, DialogType_OKCancel, GetSystemString(14612));
	Class'InterfaceClassic.DialogBox'.static.Inst().AnchorToOwner(0, 200);
	Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnOK = HandleRevolutionProgress;
	Class'InterfaceClassic.DialogBox'.static.Inst().DelegateOnHide = HandleOnNeedItemUpted;
	btn0.DisableWindow();
	ScrollAreaWnd.HideWindow();
	return;
}

function HandleRevolutionProgress()
{
	RQ_C_EX_HOMUNCULUS_EVOLVE();
	return;
}

function _Show()
{
	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetFocus();
	return;
}

function _Hide()
{
	m_hOwnerWnd.HideWindow();
	return;
}

function _SetEvolutionPoint(int nEvolutionPoint)
{
	evolutionPoint = nEvolutionPoint;
	needItemScript.ModifyCurrentAmount(0, INT64(evolutionPoint));
	return;
}

function pageChanged(int Page)
{
	scrollList._SetPage((Page - 1));
	return;
}

function int GetCurrentHomunculusIdx()
{
	return listItem0.currHomunculusData.idx;
}

function RQ_C_EX_HOMUNCULUS_EVOLVE()
{
	local array<byte> stream;
	local UIPacket._C_EX_HOMUNCULUS_EVOLVE packet;

	if(!SetRequestLock())
	{
		return;
	}
	packet.nEvolveHomunIndex = GetCurrentHomunculusIdx();
	packet.nMaterialHomunIndex = listItem1.currHomunculusData.idx;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_HOMUNCULUS_EVOLVE(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(892, stream);
	return;
}

function _RT_S_EX_HOMUNCULUS_EVOLVE()
{
	local UIPacket._S_EX_HOMUNCULUS_EVOLVE packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_HOMUNCULUS_EVOLVE(packet))
	{
		return;
	}
	RequestedRelease();
	if((int(packet.bSuccess) == 0))
	{
		return;
	}
	homunculusWndMainViewportScript._SetRevolutionIdx(GetCurrentHomunculusIdx());
	homunculusWndMainListScript._AddNew(GetCurrentHomunculusIdx());
	txtResult0.SetText("");
	ObjectViewport.SetNPCInfo(-1);
	ObjectViewport.SpawnNPC();
	return;
}

function _SetViewPort()
{
	SetViewPort();
	return;
}

function SetViewPort()
{
	local HomunculusAPI.HomunculusNpcData npcData;
	local string NpcName;

	npcData = HomunculusWndScript.GetHomunculusNpcData(homunculusWndMainListScript.GetCurrHomunculusData().Id);
	if((homunculusWndMainListScript.GetCurrHomunculusData().Type != 3))
	{
		return;
	}
	resultWnd.ShowWindow();
	effectViewportResult.SpawnEffect("LineageEffect2.ui_upgrade_succ");
	NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(npcData.NpcID);
	txtResult0.SetText((((GetSystemString(88) $ ".1") @ GetSystemString(13144)) @ NpcName));
	SetViewPortSetting(npcData.Id);
	ObjectViewport.SetNPCInfo(npcData.NpcID);
	ObjectViewport.SpawnNPC();
	PlayRandAnimation();
	return;
}

function SetViewPortSetting(int Id)
{
	local float tmpScale;
	local int OffsetY;

	switch(Id)
	{
		case 0:
			tmpScale = 1.0000000;
			OffsetY = 1;
			break;
		case 3:
		case 40:
			tmpScale = 1.2000000;
			OffsetY = -11;
			break;
		case 6:
		case 41:
			tmpScale = 1.5000000;
			OffsetY = -1;
			break;
		case 9:
		case 42:
			tmpScale = 0.9000000;
			OffsetY = -1;
			break;
		case 12:
		case 43:
			tmpScale = 1.7000000;
			OffsetY = -8;
			break;
		case 15:
		case 44:
			tmpScale = 1.1000000;
			OffsetY = -1;
			break;
		case 18:
		case 45:
			tmpScale = 1.4000000;
			OffsetY = -3;
			break;
		case 21:
		case 46:
			tmpScale = 1.6000000;
			OffsetY = -1;
			break;
		case 24:
		case 47:
			tmpScale = 1.5000000;
			OffsetY = -5;
			break;
		case 27:
		case 48:
			tmpScale = 1.2000000;
			OffsetY = 0;
			break;
		case 30:
		case 49:
			tmpScale = 1.2000000;
			OffsetY = -1;
			break;
		case 33:
		case 50:
			tmpScale = 1.4000000;
			OffsetY = -8;
			break;
		case 36:
		case 51:
			tmpScale = 1.4000000;
			OffsetY = -17;
			break;
		case 52:
		case 39:
			tmpScale = 1.6000000;
			OffsetY = 0;
			break;
		default:
			tmpScale = 1.2000000;
			OffsetY = -1;
			break;
	}
	ObjectViewport.SetCharacterScale(tmpScale);
	ObjectViewport.SetCharacterOffsetY(OffsetY);
	return;
}

function PlayRandAnimation()
{
	local int aniType;

	aniType = Rand(2);
	ObjectViewport.PlayAnimation(aniType);
	return;
}

function HandleOnClickConfirm()
{
	m_hOwnerWnd.HideWindow();
	return;
}

function HandleOnNeedItemUpted()
{
	needItemScript.ModifyCurrentAmount(0, INT64(evolutionPoint));
	if((needItemScript.GetCanBuy() && (listItem1.currHomunculusData.Id > 0)))
	{
		btn0.EnableWindow();
	}
	else
	{
		btn0.DisableWindow();
	}
	return;
}

function SetItemsExpData(HomunculusWndMainListItem item)
{
	local HomunculusAPI.HomunculusNpcLevelData npcLevelData;
	local int prevExp, currExp;

	prevExp = HomunculusWndScript.API_GetHomunculusNpcLevelData(item.currHomunculusData.Id, (item.currHomunculusData.Level - 1)).MaxExp;
	npcLevelData = HomunculusWndScript.API_GetHomunculusNpcLevelData(item.currHomunculusData.Id, item.currHomunculusData.Level);
	currExp = (npcLevelData.MaxExp - prevExp);
	if((int(item.currState) == 3))
	{
		GetStatusBarHandle((item.m_Windowname $ ".EXPBar")).SetPointExpPercentRate((float((item.currHomunculusData.Exp - prevExp)) / float(currExp)));
	}
	else
	{
		GetStatusBarHandle((item.m_Windowname $ ".EXPBar")).SetPointExpPercentRate((0.0000000 / 0.0000000));
	}
	return;
}

function RequestedRelease()
{
	bRequested = false;
	return;
}

function bool SetRequestLock()
{
	if(bRequested)
	{
		return false;
	}
	Class'InterfaceClassic.L2UITimer'.static.Inst()._AddTimerOnce(5000)._DelegateOnEnd = RequestedRelease;
	return true;
}

function bool _IsRequested()
{
	return bRequested;
}
