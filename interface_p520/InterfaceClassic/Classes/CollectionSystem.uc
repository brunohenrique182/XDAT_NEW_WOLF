class CollectionSystem extends UICommonAPI
	dependson(UIPacket);

const STATESTAND = "stateStand";
const STATESUB = "stateSub";
const collectionstateName = "COLLECTIONSTATE";
const MAX_SLOT = 6;

enum collectionState
{
	non,                            // 0
	stand,                          // 1
	Sub,                            // 2
	subProgress,                    // 3
	mainProgress,                   // 4
	detailinfo                      // 5
};

enum LIST_REQUESTEDMODE
{
	Normal,                         // 0
	modify                          // 1
};

var WindowHandle Me;
var string m_Windowname;
var array<WindowHandle> KeyItems;
var array<TextureHandle> MainBG_texs;
var array<TextureHandle> MainBG_texsAni;
var WindowHandle m_CollectionSystemCategory;
var WindowHandle m_CollectionSystemSub;
var WindowHandle m_CollectionSystemSubPopupProgress;
var WindowHandle m_CollectionSystemPopupDetails;
var CheckBoxHandle chkShowAlarm;
var collectionState CurrentState;
var CollectionSystemCategory collectionSystemCategoryScript;
var CollectionSystemSub collectionSystemSubScript;
var CollectionSystemSubPopupProgress CollectionSystemSubPopupProgressScript;
var CollectionSystemPopupDetails CollectionSystemPopupDetailsScript;
var int stadardClickedCategory;
var array<CollectionSystemStandComponent> collectionSystemStandComponentScripts;
var array<CollectionSystemStandComponent> collectionSystemStandComponentFavoriteScript;
var CollectionSystemProgressComponent ProgressCollectionComplete_wndScript;
var CollectionSystemProgressComponent ProgressItemComplete_wndScript;
var array<CollectionMainData> cMainDatas;
var int selectedCategory;
var ItemInfo toFindItemInfo;
var int MAX_CATEGORY;
var int favoriteCategory;
var bool bClickedProgressComponent;
var LIST_REQUESTEDMODE requestedMode;
var int currentBackgroundLevel;
var int max_Background;
var bool bRequest_C_EX_COLLECTION_OPEN_UI;

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	m_CollectionSystemCategory = GetWindowHandle((m_Windowname $ ".CollectionSystemCategory"));
	m_CollectionSystemSub = GetWindowHandle((m_Windowname $ ".CollectionSystemSub"));
	m_CollectionSystemSubPopupProgress = GetWindowHandle((m_Windowname $ ".CollectionSystemSubPopupProgress"));
	m_CollectionSystemPopupDetails = GetWindowHandle((m_Windowname $ ".CollectionSystemPopupDetails"));
	collectionSystemSubScript = CollectionSystemSub(m_CollectionSystemSub.GetScript());
	collectionSystemCategoryScript = CollectionSystemCategory(m_CollectionSystemCategory.GetScript());
	CollectionSystemPopupDetailsScript = CollectionSystemPopupDetails(m_CollectionSystemPopupDetails.GetScript());
	CollectionSystemSubPopupProgressScript = CollectionSystemSubPopupProgress(m_CollectionSystemSubPopupProgress.GetScript());
	InitKeyItemWindows();
	InitProgressComponents();
	InitAlarmCheckBox();
	return;
}

function InitAlarmCheckBox()
{
	local int nBool;

	GetINIBool(m_hOwnerWnd.m_WindowNameWithFullPath, "a", nBool, "windowsInfo.ini");
	chkShowAlarm = GetCheckBoxHandle((m_Windowname $ ".chkShowAlarm"));
	chkShowAlarm.SetCheck((nBool == 1));
	return;
}

function bool _GetAlarmCheck()
{
	local int nBool;

	GetINIBool(m_hOwnerWnd.m_WindowNameWithFullPath, "a", nBool, "windowsInfo.ini");
	return (nBool == 1);
}

event OnClickCheckBox(string strID)
{
	SetINIBool(m_hOwnerWnd.m_WindowNameWithFullPath, "a", chkShowAlarm.IsChecked(), "windowsInfo.ini");
	return;
}

function InitKeyItemWindows()
{
	local int i;

	i = 0;
	while((GetWindowHandle(KeyItemWIndowName(i)).m_pTargetWnd != none))
	{
		KeyItems[i] = GetWindowHandle(KeyItemWIndowName(i));
		KeyItems[i].HideWindow();
		MainBG_texs[i] = GetTextureHandle(((m_Windowname $ ".MainBG_tex") $ Int2Str2(i)));
		MainBG_texs[i].HideWindow();
		MainBG_texsAni[i] = GetTextureHandle(((m_Windowname $ ".MainBG_texAni") $ Int2Str2(i)));
		MainBG_texsAni[i].SetAlpha(0);
		i++;
	}
	KeyItems[0].ShowWindow();
	return;
}

function InitProgressComponents()
{
	local string _progressWindowName;

	_progressWindowName = (m_Windowname $ ".ProgressGroup_wnd.ProgressCollectionComplete_wnd");
	GetWindowHandle(_progressWindowName).SetScript("CollectionSystemProgressComponent");
	ProgressCollectionComplete_wndScript = CollectionSystemProgressComponent(GetWindowHandle(_progressWindowName).GetScript());
	ProgressCollectionComplete_wndScript.Init(_progressWindowName);
	ProgressCollectionComplete_wndScript.DelegateOnButtonClick = HandleOnClickProgressComponent;
	_progressWindowName = (m_Windowname $ ".ProgressGroup_wnd.ProgressItemComplete_wnd");
	GetWindowHandle(_progressWindowName).SetScript("CollectionSystemProgressComponent");
	ProgressItemComplete_wndScript = CollectionSystemProgressComponent(GetWindowHandle(_progressWindowName).GetScript());
	ProgressItemComplete_wndScript.Init(_progressWindowName);
	ProgressItemComplete_wndScript.DelegateOnButtonClick = HandleOnClickProgressComponent;
	return;
}

function SetMainDatas()
{
	local int mainID;
	local CollectionMainData cMainData;

	MAX_CATEGORY = 0;
	max_Background = 0;
	mainID = 1;
	while(API_GetCollectionMainData(mainID, cMainData))
	{
		cMainDatas[cMainDatas.Length] = cMainData;
		MAX_CATEGORY = Max(MAX_CATEGORY, cMainData.Category);
		max_Background = Max(max_Background, cMainData.background_level);
		InitKeyItemButton(cMainData);
		mainID++;
	}
	if((max_Background <= 1))
	{
		GetButtonHandle((m_Windowname $ ".nextBtn")).HideWindow();
		GetButtonHandle((m_Windowname $ ".prevBtn")).HideWindow();
	}
	MAX_CATEGORY++;
	favoriteCategory = MAX_CATEGORY;
	InitFavoriteButtons();
	return;
}

function SetShowKeyItemButtons()
{
	local int i;

	i = 0;
	while((i < cMainDatas.Length))
	{
		collectionSystemStandComponentScripts[i].SetShow();
		i++;
	}
	i = 0;
	while((i < collectionSystemStandComponentFavoriteScript.Length))
	{
		collectionSystemStandComponentFavoriteScript[i].SetShow();
		i++;
	}
	return;
}

function InitKeyItemButton(CollectionMainData mData)
{
	local string _windowName;
	local int Index;

	Index = (mData.main_id - 1);
	_windowName = (((KeyItemWIndowName((mData.background_level - 1)) $ ".KeyItemBTN") $ Int2Str2(Index)) $ "_wnd");
	GetWindowHandle(_windowName).SetScript("CollectionSystemStandComponent");
	collectionSystemStandComponentScripts[Index] = CollectionSystemStandComponent(GetWindowHandle(_windowName).GetScript());
	collectionSystemStandComponentScripts[Index].Init(_windowName, mData);
	return;
}

function InitFavoriteButton(int backgroundLevel)
{
	local string _windowName;
	local CollectionMainData cMainData;

	_windowName = (KeyItemWIndowName((backgroundLevel - 1)) $ ".KeyItemBTNFavorite_wnd");
	GetWindowHandle(_windowName).SetScript("CollectionSystemStandComponent");
	cMainData.background_level = backgroundLevel;
	collectionSystemStandComponentFavoriteScript[(backgroundLevel - 1)] = CollectionSystemStandComponent(GetWindowHandle(_windowName).GetScript());
	collectionSystemStandComponentFavoriteScript[(backgroundLevel - 1)].Init(_windowName, cMainData, true);
	Debug((" 이니트 페보릿 레벨 들 ~ InitFavoriteButton" @ string(backgroundLevel)));  // EN?: Innit Pevorit Levels ~ InitFavoriteButton
	return;
}

function InitFavoriteButtons()
{
	local int i;

	i = 1;
	while((i <= max_Background))
	{
		InitFavoriteButton(i);
		i++;
	}
	return;
}

function string API_GetGeneralEffectName(string KeyName)
{
	return GetGeneralEffectName(KeyName);
}

function bool API_GetCollectionOptionName(int Category, out array<string> optionNames)
{
	optionNames.Length = 0;
	return GetCollectionOptionName(Category, optionNames);
}

function bool API_GetCollectionData(int collection_ID, out CollectionData Data)
{
	local CollectionData cData;

	Data = cData;
	return GetCollectionData(collection_ID, Data);
}

function bool API_GetCollectionMainData(int main_id, out CollectionMainData Data)
{
	local CollectionMainData mData;

	Data = mData;
	return GetCollectionMainData(main_id, Data);
}

function bool API_GetCollectionIdByItemName(out array<int> CollectionID, int Category, bool onlyComplete, bool onlyNotComplete, optional bool favorite, optional string ItemName, optional string OptionName, optional bool onlyProgress)
{
	CollectionID.Length = 0;
	return GetCollectionIdByItemName(CollectionID, Category, onlyComplete, onlyNotComplete, favorite, ItemName, OptionName, onlyProgress);
}

function bool API_GetCollectionIdByItemId(out array<int> CollectionID, int ItemID)
{
	CollectionID.Length = 0;
	return GetCollectionIdByItemId(CollectionID, ItemID);
}

function bool API_IsCollectionRegistEnableItem(ItemID sID, optional int CollectionID, optional int SlotID)
{
	return IsCollectionRegistEnableItem(sID, CollectionID, SlotID);
}

function bool API_IsCollectionRegistEnableItemWithReason(ItemID sID, int CollectionID, int SlotID, out UIScript.CollectionRegistFailReason Reason)
{
	return IsCollectionRegistEnableItemWithReason(sID, CollectionID, SlotID, Reason);
}

function bool API_GetCollectionInfo(int collection_ID, out CollectionInfo Info)
{
	return GetCollectionInfo(collection_ID, Info);
}

function bool API_GetCollectionCount(int Category, out CollectionCount Count)
{
	return GetCollectionCount(Category, Count);
}

function bool API_GetCollectionOption(out array<CollectionOption> Option)
{
	Option.Length = 0;
	return GetCollectionOption(Option);
}

function bool API_GetCompletePeriodCollection(out array<int> CollectionID)
{
	CollectionID.Length = 0;
	return GetCompletePeriodCollection(CollectionID);
}

function C_EX_COLLECTION_SUMMARY()
{
	local array<byte> stream;
	local UIPacket._C_EX_COLLECTION_SUMMARY packet;

	packet.cDummy = 1;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_COLLECTION_SUMMARY(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(689, stream);
	return;
}

function API_C_EX_COLLECTION_LIST(int Category, optional LIST_REQUESTEDMODE _requestedMode)
{
	local array<byte> stream;
	local UIPacket._C_EX_COLLECTION_LIST packet;

	packet.cCategory = Category;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_COLLECTION_LIST(stream, packet))
	{
		return;
	}
	requestedMode = _requestedMode;
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(686, stream);
	return;
}

function API_C_EX_COLLECTION_FAVORITE_LIST(optional LIST_REQUESTEDMODE _requestedMode)
{
	local array<byte> stream;
	local UIPacket._C_EX_COLLECTION_FAVORITE_LIST packet;

	packet.cDummy = 0;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_COLLECTION_FAVORITE_LIST(stream, packet))
	{
		return;
	}
	requestedMode = _requestedMode;
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(688, stream);
	return;
}

function API_C_EX_COLLECTION_OPEN_UI()
{
	local array<byte> stream;
	local UIPacket._C_EX_COLLECTION_OPEN_UI packet;

	if(bRequest_C_EX_COLLECTION_OPEN_UI)
	{
		return;
	}
	packet.cDummy = 0;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_COLLECTION_OPEN_UI(stream, packet))
	{
		return;
	}
	if((Class'InterfaceClassic.ItemAutoPeelWnd'.static.Inst().IsItemPeeling() == true))
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13680));
		return;
	}
	bRequest_C_EX_COLLECTION_OPEN_UI = true;
	m_hOwnerWnd.SetTimer(9, 5000);
	SideBar(GetScript("SideBar")).SideBarLockVOption(true);
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(684, stream);
	return;
}

function API_C_EX_COLLECTION_CLOSE_UI()
{
	local array<byte> stream;
	local UIPacket._C_EX_COLLECTION_CLOSE_UI packet;

	packet.cDummy = 0;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_COLLECTION_CLOSE_UI(stream, packet))
	{
		return;
	}
	SideBar(GetScript("SideBar")).SideBarLockVOption(false);
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(685, stream);
	return;
}

function API_C_EX_COLLECTION_REGISTER(int nCollectionID, int nSlotNumber, int nItemSid)
{
	local array<byte> stream;
	local UIPacket._C_EX_COLLECTION_REGISTER packet;

	packet.nCollectionID = nCollectionID;
	packet.nSlotNumber = nSlotNumber;
	packet.nItemSid = nItemSid;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_COLLECTION_REGISTER(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(690, stream);
	return;
}

function API_C_EX_COLLECTION_RECEIVE_REWARD(int nCollectionID)
{
	local array<byte> stream;
	local UIPacket._C_EX_COLLECTION_RECEIVE_REWARD packet;

	packet.nCollectionID = nCollectionID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_COLLECTION_RECEIVE_REWARD(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(691, stream);
	return;
}

function API_C_EX_COLLECTION_UPDATE_FAVORITE(bool bRegister, int nCollectionID)
{
	local array<byte> stream;
	local UIPacket._C_EX_COLLECTION_UPDATE_FAVORITE packet;

	if(bRegister)
	{
		packet.bRegister = 1;
	}
	else
	{
		packet.bRegister = 0;
	}
	packet.nCollectionID = nCollectionID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_COLLECTION_UPDATE_FAVORITE(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(687, stream);
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(150);
	RegisterEvent(90);
	RegisterEvent(11500);
	RegisterEvent(11501);
	RegisterEvent(11503);
	RegisterEvent(11504);
	RegisterEvent(11502);
	RegisterEvent(11505);
	RegisterEvent(11506);
	RegisterEvent(11507);
	RegisterEvent(11511);
	RegisterEvent(11508);
	RegisterEvent(11509);
	RegisterEvent((100000 + 912));
	RegisterEvent((100000 + 911));
	RegisterEvent((100000 + 918));
	return;
}

event OnLoad()
{
	Initialize();
	return;
}

function Handle_S_EX_COLLECTION_SUMMARY()
{
	if((bClickedProgressComponent == true))
	{
		switch(CurrentState)
		{
			case Sub:
				SetState(subProgress);
				break;
			case stand:
				SetState(mainProgress);
				break;
			default:
				break;
		}
		bClickedProgressComponent = false;
	}
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 150:
			SetMainDatas();
			collectionSystemCategoryScript.InitCategoryButton((favoriteCategory - 1));
			if(ChkSerVer())
			{
				HandleGameInit();
			}
			break;
		case 90:
			HandleShortcutCommand(param);
			break;
		case (100000 + 911):
			S_EX_COLLECTION_OPEN_UI();
			break;
		case (100000 + 912):
			S_EX_COLLECTION_CLOSE_UI();
			break;
		case 11500:
			Handle_EV_CollectionInfoEnd(param);
			break;
		case 11501:
			Handle_EV_CollectionList(param);
			break;
		case 11503:
			Handle_EV_CollectionFavoriteList(param);
			break;
		case 11504:
			Handle_EV_CollectionSummary(param);
			break;
		case 11502:
			Handle_EV_CollectionUpdateFavorite(param);
			break;
		case 11505:
			Handle_EV_CollectionRegister(param);
			break;
		case 11506:
			Handle_EV_CollectionComplete(param);
			break;
		case 11507:
			Handle_EV_CollectionReceiveReward(param);
			break;
		case 11511:
			Handle_EV_CollectionResetReward(param);
			break;
		case 11508:
			Handle_EV_CollectionReset(param);
			break;
		case 11509:
			Handle_EV_CollectionActiveEvent(param);
			break;
		default:
			break;
	}
	return;
}

event OnHide()
{
	ClearFinding();
	collectionSystemSubScript._StopTimer();
	return;
}

event OnTick()
{
	C_EX_COLLECTION_SUMMARY();
	Me.DisableTick();
	return;
}

event OnTimer(int tID)
{
	bRequest_C_EX_COLLECTION_OPEN_UI = false;
	m_hOwnerWnd.KillTimer(9);
	return;
}

function ClearFinding()
{
	collectionSystemSubScript.EditBoxFind_EditBox.SetString("");
	collectionSystemSubScript.A0_ComboBox.SetSelectedNum(0);
	collectionSystemSubScript.A1_ComboBox.SetSelectedNum(0);
	collectionSystemCategoryScript.HideAllDot();
	return;
}

function Handle_EV_CollectionInfoEnd(string param)
{
	Debug(("EV_CollectionInfoEnd" @ param));
	return;
}

function Handle_EV_CollectionList(string param)
{
	local int Category, RemainTime;

	ParseInt(param, "Category", Category);
	ParseInt(param, "RemainTime", RemainTime);
	switch(CurrentState)
	{
		case Sub:
		case subProgress:
		case detailinfo:
			if((selectedCategory == Category))
			{
				collectionSystemSubScript.SetCategory(Category);
				if((stadardClickedCategory >= 0))
				{
					collectionSystemSubScript.SetSelectByCollectionID(stadardClickedCategory);
					SetState(detailinfo);
				}
				stadardClickedCategory = -1;
			}
		default:
			collectionSystemSubScript._SetRemainTime(RemainTime);
			return;
	}
}

function SetCollectionPopupDetail(int tmpCategory)
{
	stadardClickedCategory = tmpCategory;
	return;
}

function Handle_EV_CollectionFavoriteList(string param)
{
	switch(CurrentState)
	{
		case Sub:
		case subProgress:
		case detailinfo:
			if((selectedCategory == favoriteCategory))
			{
				collectionSystemSubScript.SetCategory(favoriteCategory);
			}
		default:
			return;
	}
}

function Handle_EV_CollectionSummary(string param)
{
	collectionSystemCategoryScript.SetCurrentCollectionCount();
	collectionSystemSubScript.SetCurrentCollectionCount();
	Handle_S_EX_COLLECTION_SUMMARY();
	return;
}

function Handle_EV_CollectionUpdateFavorite(string param)
{
	local int CollectionID, registered;

	ParseInt(param, "CollectionID", CollectionID);
	ParseInt(param, "Register", registered);
	if((selectedCategory == favoriteCategory))
	{
		collectionSystemSubScript.DeleteRecordByCollectionID(CollectionID);
	}
	else
	{
		collectionSystemSubScript.ModifyRecordByCollectionID(CollectionID);
	}
	collectionSystemSubScript.CheckCategoryDotByCategory(favoriteCategory);
	return;
}

function Handle_EV_CollectionRegister(string param)
{
	local int Success, CollectionID, bRecursive;

	ParseInt(param, "Success", Success);
	if((Success != 1))
	{
		return;
	}
	ParseInt(param, "CollectionID", CollectionID);
	ParseInt(param, "Recursive", bRecursive);
	switch(selectedCategory)
	{
		case favoriteCategory:
			API_C_EX_COLLECTION_FAVORITE_LIST();
			break;
		default:
			API_C_EX_COLLECTION_LIST(selectedCategory, modify);
			break;
	}
	CollectionSystemPopupDetailsScript.HandleCollectionRegisted(CollectionID, bRecursive);
	return;
}

function Handle_EV_CollectionComplete(string param)
{
	local int CollectionID, i;

	ParseInt(param, "CollectionID", CollectionID);
	collectionSystemSubScript.ModifyRecordByCollectionID(CollectionID);
	CollectionSystemPopupDetailsScript.HandleCompleted(CollectionID);
	i = 0;
	while((i < MAX_CATEGORY))
	{
		collectionSystemStandComponentScripts[i].SetComplete();
		i++;
	}
	Me.EnableTick();
	return;
}

function Handle_EV_CollectionReceiveReward(string param)
{
	local int CollectionID, Success;

	ParseInt(param, "Success", Success);
	if((Success != 1))
	{
		return;
	}
	ParseInt(param, "CollectionID", CollectionID);
	collectionSystemSubScript.ModifyRecordByCollectionID(CollectionID);
	CollectionSystemPopupDetailsScript.HandleCompleted(CollectionID);
	return;
}

function Handle_EV_CollectionResetReward(string param)
{
	return;
}

function Handle_EV_CollectionReset(string param)
{
	local int CollectionID;

	ParseInt(param, "CollectionID", CollectionID);
	collectionSystemSubScript.ModifyRecordByCollectionID(CollectionID);
	CollectionSystemPopupDetailsScript.HandleCompleted(CollectionID);
	return;
}

function Handle_EV_CollectionActiveEvent(string param)
{
	return;
}

function S_EX_COLLECTION_CLOSE_UI()
{
	local UIPacket._S_EX_COLLECTION_CLOSE_UI packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_COLLECTION_CLOSE_UI(packet))
	{
		return;
	}
	Class'NWindow.UIDATA_API'.static.SetState("GAMINGSTATE");
	return;
}

function S_EX_COLLECTION_OPEN_UI()
{
	local UIPacket._S_EX_COLLECTION_OPEN_UI packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_COLLECTION_OPEN_UI(packet))
	{
		return;
	}
	Class'NWindow.UIDATA_API'.static.SetState("COLLECTIONSTATE");
	bRequest_C_EX_COLLECTION_OPEN_UI = false;
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "BtnClose":
			SetState(non);
			break;
		case "prevBtn":
			ShowBackgroundLevel((currentBackgroundLevel - 1));
			break;
		case "nextBtn":
			ShowBackgroundLevel((currentBackgroundLevel + 1));
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	collectionSystemCategoryScript.SetCurrentCollectionCount();
	currentBackgroundLevel = (max_Background - 1);
	SetState(stand);
	Me.SetFocus();
	CheckToFindListByIteminfo();
	stadardClickedCategory = -1;
	if(collectionSystemSubScript.SetCurrentCollectionCount())
	{
		collectionSystemSubScript.SetCollectionCount();
	}
	bRequest_C_EX_COLLECTION_OPEN_UI = false;
	InitAlarmCheckBox();
	return;
}

function SetToFindItemInfo(ItemInfo iInfo)
{
	toFindItemInfo = iInfo;
	return;
}

function CheckToFindListByIteminfo()
{
	local ItemInfo iInfo, nullInfo;

	if((toFindItemInfo == nullInfo))
	{
		return;
	}
	iInfo = toFindItemInfo;
	ShowCollectionListByItemInfo(iInfo);
	toFindItemInfo = nullInfo;
	return;
}

function HandleOnClickProgressComponent()
{
	bClickedProgressComponent = true;
	C_EX_COLLECTION_SUMMARY();
	return;
}

function SetCurrentCategory(int Category)
{
	selectedCategory = Category;
	switch(selectedCategory)
	{
		case favoriteCategory:
			API_C_EX_COLLECTION_FAVORITE_LIST();
			break;
		default:
			API_C_EX_COLLECTION_LIST(selectedCategory);
			break;
	}
	collectionSystemSubScript.SetCategory(Category);
	SetState(Sub);
	return;
}

function HandleShortcutCommand(string param)
{
	local string Command;

	ParseString(param, "Command", Command);
	switch(Command)
	{
		case "OnESCCollectionState":
			OnReceivedCloseUICommand();
			break;
		default:
			break;
	}
	return;
}

function HandleGameInit()
{
	collectionSystemSubScript.InitComboBoxes();
	return;
}

function bool _IsCollectionOpen()
{
	if(bRequest_C_EX_COLLECTION_OPEN_UI)
	{
		return true;
	}
	if(m_hOwnerWnd.IsShowWindow())
	{
		return true;
	}
	if((GetGameStateName() == "COLLECTIONSTATE"))
	{
		return true;
	}
	return false;
}

function HideCurrentKeyItems()
{
	KeyItems[currentBackgroundLevel].HideWindow();
	return;
}

function bool SetNextBtnState(int backgroundLevel)
{
	return false;
	if((backgroundLevel > (max_Background - 1)))
	{
		return true;
	}
	if((backgroundLevel < 0))
	{
		return true;
	}
	if((backgroundLevel == 0))
	{
		GetButtonHandle((m_Windowname $ ".prevBtn")).DisableWindow();
	}
	else
	{
		GetButtonHandle((m_Windowname $ ".prevBtn")).EnableWindow();
	}
	if((backgroundLevel == (max_Background - 1)))
	{
		GetButtonHandle((m_Windowname $ ".nextBtn")).DisableWindow();
	}
	else
	{
		GetButtonHandle((m_Windowname $ ".nextBtn")).EnableWindow();
	}
	return false;
}

function ShowBackgroundLevel(int backgroundLevel)
{
	local int i;

	if(SetNextBtnState(backgroundLevel))
	{
		return;
	}
	if((backgroundLevel > (max_Background - 1)))
	{
		backgroundLevel = 0;
	}
	else if((backgroundLevel < 0))
	{
		backgroundLevel = (max_Background - 1);
	}
	i = 0;
	while((i < max_Background))
	{
		MainBG_texsAni[i].SetAlpha(0);
		MainBG_texs[i].HideWindow();
		KeyItems[i].HideWindow();
		i++;
	}
	if((backgroundLevel != currentBackgroundLevel))
	{
		MainBG_texsAni[currentBackgroundLevel].SetAlpha(255);
		MainBG_texsAni[currentBackgroundLevel].SetAlpha(0, 0.5000000);
	}
	SetShowKeyItemButtons();
	MainBG_texs[backgroundLevel].ShowWindow();
	KeyItems[backgroundLevel].ShowWindow();
	currentBackgroundLevel = backgroundLevel;
	return;
}

function string KeyItemWIndowName(int backgroundLevel)
{
	return ((m_Windowname $ ".KeyItems") $ Int2Str2(backgroundLevel));
}

function bool IsKeyItem(int CollectionID)
{
	local int i;

	i = 0;
	while((i < cMainDatas.Length))
	{
		if((cMainDatas[i].collection_ID == CollectionID))
		{
			return true;
		}
		i++;
	}
	return false;
}

function int GetSubIndexByMainID(int mainID)
{
	local CollectionMainData cMainData;
	local int Category, i, SubIndex;

	API_GetCollectionMainData(mainID, cMainData);
	Category = cMainData.Category;
	i = 1;
	while(API_GetCollectionMainData(i, cMainData))
	{
		if((i == mainID))
		{
			return SubIndex;
		}
		if((cMainData.Category == Category))
		{
			SubIndex++;
		}
		i++;
	}
	return -1;
}

function string GetStringKeyByIndex(int Index, optional int SubIndex)
{
	local string indexName;

	switch(Index)
	{
		case 0:
			indexName = "A";
			break;
		case 1:
			indexName = "B";
			break;
		case 2:
			indexName = "C";
			break;
		case 3:
			indexName = "D";
			break;
		case 4:
			indexName = "E";
			break;
		case 5:
			indexName = "F";
			break;
		case 6:
			indexName = "G";
			break;
		case (favoriteCategory - 1):
			indexName = "H";
			break;
		default:
			break;
	}
	if(getInstanceUIData().GetIsLiveServer())
	{
		return ((("live_" $ indexName) $ "_") $ Int2Str2(SubIndex));
	}
	else
	{
		return ((("col_" $ indexName) $ "_") $ Int2Str2(SubIndex));
	}
}

function string GetStringNameByIndex(int Index)
{
	switch(Index)
	{
		case 0:
			return GetSystemString(13702);
		case 1:
			return GetSystemString(13703);
		case 2:
			return GetSystemString(13704);
		case 3:
			return GetSystemString(13705);
		case 4:
			return GetSystemString(13706);
		case 5:
			return GetSystemString(13707);
		case 6:
			return GetSystemString(13708);
		case (favoriteCategory - 1):
			return GetSystemString(13709);
		default:
			return "";
	}
}

function ShowCollectionListByItemInfo(ItemInfo iInfo)
{
	local CollectionData cData;

	cData = RegistEnableCategory(iInfo);
	selectedCategory = cData.main_category;
	collectionSystemSubScript.SetSearchInit();
	collectionSystemSubScript.SetFindKeyWord(toFindItemInfo.Name);
	API_C_EX_COLLECTION_LIST(selectedCategory);
	collectionSystemSubScript.SetCategory(selectedCategory);
	SetState(Sub);
	return;
}

function CollectionData RegistEnableCategory(ItemInfo iInfo)
{
	local int i, Len;
	local CollectionData cData;
	local array<int> collectionIds;

	API_GetCollectionIdByItemId(collectionIds, iInfo.Id.ClassID);
	Len = collectionIds.Length;
	i = 0;
	while((i < Len))
	{
		API_GetCollectionData(collectionIds[i], cData);
		if(API_IsCollectionRegistEnableItem(iInfo.Id, cData.collection_ID, -1))
		{
			return cData;
		}
		i++;
	}
	API_GetCollectionData(collectionIds[0], cData);
	return cData;
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

function SetState(collectionState State)
{
	GetWindowHandle((m_Windowname $ ".ProgressGroup_wnd")).HideWindow();
	switch(State)
	{
		case non:
			API_C_EX_COLLECTION_CLOSE_UI();
			break;
		case stand:
			ClearFinding();
			GetWindowHandle((m_Windowname $ ".ProgressGroup_wnd")).ShowWindow();
			ShowBackgroundLevel(currentBackgroundLevel);
			SetShowKeyItemButtons();
			m_CollectionSystemSub.HideWindow();
			collectionSystemCategoryScript.SetState(stand);
			CollectionSystemPopupDetailsScript.Me.HideWindow();
			CollectionSystemSubPopupProgressScript.Me.HideWindow();
			break;
		case Sub:
			HideCurrentKeyItems();
			m_CollectionSystemSub.ShowWindow();
			collectionSystemSubScript.InitComboboxA1();
			CollectionSystemPopupDetailsScript.Me.HideWindow();
			CollectionSystemSubPopupProgressScript.Me.HideWindow();
			collectionSystemCategoryScript.SetState(Sub);
			break;
		case mainProgress:
			GetWindowHandle((m_Windowname $ ".ProgressGroup_wnd")).ShowWindow();
			CollectionSystemSubPopupProgressScript.SetCollectionOptions();
			CollectionSystemSubPopupProgressScript.Me.ShowWindow();
			break;
		case subProgress:
			CollectionSystemSubPopupProgressScript.SetCollectionOptions();
			CollectionSystemSubPopupProgressScript.Me.ShowWindow();
			break;
		case detailinfo:
			CollectionSystemPopupDetailsScript.Me.ShowWindow();
			break;
		default:
			break;
	}
	CurrentState = State;
	return;
}

function OnClickEsc()
{
	switch(CurrentState)
	{
		case non:
			return;
		case Sub:
		case stand:
			SetState(non);
			break;
		case subProgress:
			SetState(Sub);
			break;
		case mainProgress:
			SetState(stand);
			break;
		case detailinfo:
			CollectionSystemPopupDetailsScript.OnClickEsc();
			break;
		default:
			break;
	}
	return;
}

function OnReceivedCloseUICommand()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	OnClickEsc();
	return;
}

function bool ChkSerVer()
{
	return getInstanceUIData().GetIsLiveServer();
}
