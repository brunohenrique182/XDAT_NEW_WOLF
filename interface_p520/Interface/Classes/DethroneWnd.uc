class DethroneWnd extends UICommonAPI
	dependson(UIPacket);

const TIMER_ID = 1001113;
const REFRESH_DELAY = 600;

var string m_Windowname;
var WindowHandle Me;
var WindowHandle MyinfoGroup_wnd;
var TextureHandle ClassBgMain_Big;
var TextureHandle ClassMark_tex;
var TextureHandle ClassLight;
var TextureHandle ClassChangeLightBig;
var ButtonHandle Help_btn;
var TextBoxHandle LvHead_text;
var TextBoxHandle Lv_text;
var TextBoxHandle ClassName_text;
var TextBoxHandle PCName_text;
var TextBoxHandle AttackNum_text;
var TextBoxHandle LifeNum_text;
var TextBoxHandle AttackTitle_text;
var TextBoxHandle LifeTitle_text;
var TextBoxHandle MyRanking_text;
var TextBoxHandle MyRankingNum_text;
var TextBoxHandle MyDethronePointNum_text;
var TextBoxHandle MyRankingTitle_text;
var TextBoxHandle MyDethronePointTitle_text;
var ButtonHandle prvMyRankingInfo_btn;
var TextureHandle MyRankingBG_tex;
var TextBoxHandle MyServerRanking_text;
var TextBoxHandle MyServerDethronePointNum_text;
var TextureHandle MyServerMark_tex;
var TextBoxHandle MyServerRankingTitle_text;
var TextureHandle MyServerRankingBG_tex;
var WindowHandle prvDethroneResultGroup_wnd;
var TextureHandle prvServerMark_tex;
var TextureHandle prvRulerServerMark_tex;
var TextBoxHandle prvRulerName_text;
var TextBoxHandle ServerName_text;
var TextBoxHandle prvWinRulerTitle_text;
var TextBoxHandle prvWinServerTitle_text;
var WindowHandle NowDethroneResultGroup_wnd;
var TextureHandle OnOffIcon_tex;
var TextBoxHandle WinServerName_text;
var TextureHandle NowRulerServerMark_tex;
var TextBoxHandle NowRulerName_text;
var TextureHandle OccupyServerMark_tex;
var TextBoxHandle OccupyName_text;
var TextBoxHandle OccupyPointNum_text;
var TextBoxHandle RulerTitle_text;
var TextBoxHandle OccupyTitle_text;
var TextBoxHandle WinServerTitle_text;
var TabHandle Dethrone_Tab;
var WindowHandle TabInsideWindowDisableWnd;
var WindowHandle DethroneTab_Container;
var ButtonHandle MainRefresh_Button;
var ButtonHandle MainEnter_Button;
var ButtonHandle MainReward_Button;
var UserInfo myInfo;
var DetailStatusWnd DetailStatusWndScript;
var string DialogAsset_path;
var string dethroneSeverPCName;
var UIControlBasicDialog askDialogScript;
var bool isDethroneBOpen;

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	Load();
	return;
}

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	DialogAsset_path = ("DethroneWnd" $ ".UIControlDialogAsset");
	MyinfoGroup_wnd = GetWindowHandle((m_Windowname $ ".MyinfoGroup_wnd"));
	ClassBgMain_Big = GetTextureHandle((m_Windowname $ ".MyinfoGroup_wnd.ClassBgMain_Big"));
	ClassMark_tex = GetTextureHandle((m_Windowname $ ".MyinfoGroup_wnd.ClassMark_tex"));
	ClassLight = GetTextureHandle((m_Windowname $ ".MyinfoGroup_wnd.ClassLight"));
	ClassChangeLightBig = GetTextureHandle((m_Windowname $ ".MyinfoGroup_wnd.ClassChangeLightBig"));
	Help_btn = GetButtonHandle((m_Windowname $ ".MyinfoGroup_wnd.Help_btn"));
	LvHead_text = GetTextBoxHandle((m_Windowname $ ".MyinfoGroup_wnd.LvHead_text"));
	Lv_text = GetTextBoxHandle((m_Windowname $ ".MyinfoGroup_wnd.Lv_text"));
	ClassName_text = GetTextBoxHandle((m_Windowname $ ".MyinfoGroup_wnd.ClassName_text"));
	PCName_text = GetTextBoxHandle((m_Windowname $ ".MyinfoGroup_wnd.PCName_text"));
	AttackNum_text = GetTextBoxHandle((m_Windowname $ ".MyinfoGroup_wnd.AttackNum_text"));
	LifeNum_text = GetTextBoxHandle((m_Windowname $ ".MyinfoGroup_wnd.LifeNum_text"));
	AttackTitle_text = GetTextBoxHandle((m_Windowname $ ".MyinfoGroup_wnd.AttackTitle_text"));
	LifeTitle_text = GetTextBoxHandle((m_Windowname $ ".MyinfoGroup_wnd.LifeTitle_text"));
	MyRanking_text = GetTextBoxHandle((m_Windowname $ ".MyinfoGroup_wnd.MyRanking_text"));
	MyRankingNum_text = GetTextBoxHandle((m_Windowname $ ".MyinfoGroup_wnd.MyRankingNum_text"));
	MyDethronePointNum_text = GetTextBoxHandle((m_Windowname $ ".MyinfoGroup_wnd.MyDethronePointNum_text"));
	MyRankingTitle_text = GetTextBoxHandle((m_Windowname $ ".MyinfoGroup_wnd.MyRankingTitle_text"));
	MyDethronePointTitle_text = GetTextBoxHandle((m_Windowname $ ".MyinfoGroup_wnd.MyDethronePointTitle_text"));
	prvMyRankingInfo_btn = GetButtonHandle((m_Windowname $ ".MyinfoGroup_wnd.prvMyRankingInfo_btn"));
	MyRankingBG_tex = GetTextureHandle((m_Windowname $ ".MyinfoGroup_wnd.MyRankingBG_tex"));
	MyServerRanking_text = GetTextBoxHandle((m_Windowname $ ".MyinfoGroup_wnd.MyServerRanking_text"));
	MyServerDethronePointNum_text = GetTextBoxHandle((m_Windowname $ ".MyinfoGroup_wnd.MyServerDethronePointNum_text"));
	MyServerMark_tex = GetTextureHandle((m_Windowname $ ".MyinfoGroup_wnd.MyServerMark_tex"));
	MyServerRankingTitle_text = GetTextBoxHandle((m_Windowname $ ".MyinfoGroup_wnd.MyServerRankingTitle_text"));
	MyServerRankingBG_tex = GetTextureHandle((m_Windowname $ ".MyinfoGroup_wnd.MyServerRankingBG_tex"));
	prvDethroneResultGroup_wnd = GetWindowHandle((m_Windowname $ ".prvDethroneResultGroup_wnd"));
	prvServerMark_tex = GetTextureHandle((m_Windowname $ ".prvDethroneResultGroup_wnd.prvServerMark_tex"));
	prvRulerServerMark_tex = GetTextureHandle((m_Windowname $ ".prvDethroneResultGroup_wnd.prvRulerServerMark_tex"));
	prvRulerName_text = GetTextBoxHandle((m_Windowname $ ".prvDethroneResultGroup_wnd.prvRulerName_text"));
	ServerName_text = GetTextBoxHandle((m_Windowname $ ".prvDethroneResultGroup_wnd.ServerName_text"));
	prvWinRulerTitle_text = GetTextBoxHandle((m_Windowname $ ".prvDethroneResultGroup_wnd.prvWinRulerTitle_text"));
	prvWinServerTitle_text = GetTextBoxHandle((m_Windowname $ ".prvDethroneResultGroup_wnd.prvWinServerTitle_text"));
	NowDethroneResultGroup_wnd = GetWindowHandle((m_Windowname $ ".NowDethroneResultGroup_wnd"));
	OnOffIcon_tex = GetTextureHandle((m_Windowname $ ".NowDethroneResultGroup_wnd.OnOffIcon_tex"));
	WinServerName_text = GetTextBoxHandle((m_Windowname $ ".NowDethroneResultGroup_wnd.WinServerName_text"));
	NowRulerServerMark_tex = GetTextureHandle((m_Windowname $ ".NowDethroneResultGroup_wnd.NowRulerServerMark_tex"));
	NowRulerName_text = GetTextBoxHandle((m_Windowname $ ".NowDethroneResultGroup_wnd.NowRulerName_text"));
	OccupyServerMark_tex = GetTextureHandle((m_Windowname $ ".NowDethroneResultGroup_wnd.OccupyServerMark_tex"));
	OccupyName_text = GetTextBoxHandle((m_Windowname $ ".NowDethroneResultGroup_wnd.OccupyName_text"));
	OccupyPointNum_text = GetTextBoxHandle((m_Windowname $ ".NowDethroneResultGroup_wnd.OccupyPointNum_text"));
	RulerTitle_text = GetTextBoxHandle((m_Windowname $ ".NowDethroneResultGroup_wnd.RulerTitle_text"));
	OccupyTitle_text = GetTextBoxHandle((m_Windowname $ ".NowDethroneResultGroup_wnd.OccupyTitle_text"));
	WinServerTitle_text = GetTextBoxHandle((m_Windowname $ ".NowDethroneResultGroup_wnd.WinServerTitle_text"));
	Dethrone_Tab = GetTabHandle((m_Windowname $ ".Dethrone_Tab"));
	TabInsideWindowDisableWnd = GetWindowHandle((m_Windowname $ ".TabInsideWindowDisableWnd"));
	DethroneTab_Container = GetWindowHandle((m_Windowname $ ".DethroneTab_Container"));
	MainRefresh_Button = GetButtonHandle((m_Windowname $ ".MainRefresh_Button"));
	MainEnter_Button = GetButtonHandle((m_Windowname $ ".MainEnter_Button"));
	MainReward_Button = GetButtonHandle((m_Windowname $ ".MainReward_Button"));
	DetailStatusWndScript = DetailStatusWnd(GetScript("DetailStatusWnd"));
	GetButtonHandle((m_Windowname $ ".MainShop_Button")).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14313), 250));
	return;
}

function Load()
{
	CommonDialogSetScript(DialogAsset_path, (m_Windowname $ ".DisableDialog_tex"), true);
	CommonDialogGetScript(DialogAsset_path).DelegateOnCancel = OnClickDialogCancel;
	CommonDialogGetScript(DialogAsset_path).DelegateOnClickBuy = OnClickDialogOk;
	CommonDialogGetScript(DialogAsset_path).SetDisableWindow(GetTextureHandle((m_Windowname $ ".DisableDialog_tex")));
	Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop((m_Windowname $ ".DisableDialog_tex"), false);
	SetScript_UIControlBaseDialog();
	return;
}

function SetScript_UIControlBaseDialog()
{
	GetWindowHandle("DethroneWnd.ConfirmWnd").SetScript("UIControlBasicDialog");
	askDialogScript = UIControlBasicDialog(GetWindowHandle("DethroneWnd.ConfirmWnd").GetScript());
	askDialogScript.SetWindow("DethroneWnd.ConfirmWnd");
	askDialogScript.DelegateOnClickCancleButton = OnClickHideDialog;
	askDialogScript.DelegateOnClickOkButton = OnClickOkDialog;
	GetWindowHandle("DethroneWnd.ConfirmWnd").HideWindow();
	return;
}

function OnClickHideDialog(optional int nDialogKey)
{
	GetTextureHandle((m_Windowname $ ".DisableDialog_tex")).HideWindow();
	GetWindowHandle("DethroneWnd.ConfirmWnd").HideWindow();
	return;
}

function OnClickOkDialog(optional int nDialogKey)
{
	if(Class'NWindow.UIDATA_PLAYER'.static.IsInDethrone())
	{
		API_C_EX_DETHRONE_LEAVE();
		OnClickHideDialog();
		Me.HideWindow();
	}
	return;
}

function OnClickDialogOk()
{
	Debug(("CommonDialogGetScript(DialogAsset_path).getDialogID()" @ string(CommonDialogGetScript(DialogAsset_path).GetDialogID())));
	if((CommonDialogGetScript(DialogAsset_path).GetDialogID() == 1))
	{
		DethroneTab02_ServerStatus(GetScript("DethroneWnd.DethroneTab02_ServerStatus")).API_C_EX_DETHRONE_CONNECT_CASTLE();
	}
	else if((CommonDialogGetScript(DialogAsset_path).GetDialogID() == 2))
	{
		DethroneTab02_ServerStatus(GetScript("DethroneWnd.DethroneTab02_ServerStatus")).API_C_EX_DETHRONE_DISCONNECT_CASTLE();
	}
	else if(Class'NWindow.UIDATA_PLAYER'.static.IsInDethrone())
	{
		API_C_EX_DETHRONE_LEAVE();
		Me.HideWindow();
	}
	CommonDialogHide(DialogAsset_path);
	return;
}

function OnClickDialogCancel()
{
	CommonDialogHide(DialogAsset_path);
	return;
}

function gotoTabMission()
{
	Dethrone_Tab.SetTopOrder(3, true);
	Debug("탭 이동");  // EN?: Move tabs
	return;
}

function OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEvent((100000 + 950));
	RegisterEvent((100000 + 963));
	return;
}

function OnShow()
{
	if(Class'NWindow.UIDATA_PLAYER'.static.IsInPrison())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13773));
		Me.HideWindow();
		return;
	}
	if(IsPlayerOnOlympiad())
	{
		getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
		Me.HideWindow();
		return;
	}
	setDisableWnd();
	API_C_EX_DETHRONE_INFO();
	setMYInfo();
	switch(Dethrone_Tab.GetTopIndex())
	{
		case 0:
			DethroneTab01_Ranking(GetScript("DethroneWnd.DethroneTab01_Ranking")).showProcess();
			break;
		case 1:
			DethroneTab02_ServerStatus(GetScript("DethroneWnd.DethroneTab02_ServerStatus")).OnShow();
			break;
		case 2:
			DethroneTab03_OccupyStatus(GetScript("DethroneWnd.DethroneTab03_OccupyStatus")).OnShow();
			break;
		case 3:
			DethroneTab04_Mission(GetScript("DethroneWnd.DethroneTab04_Mission")).OnShow();
			break;
		default:
			break;
	}
	if(GetWindowHandle(DialogAsset_path).IsShowWindow())
	{
		CommonDialogHide(DialogAsset_path);
	}
	if(GetWindowHandle("DethroneWnd.ConfirmWnd").IsShowWindow())
	{
		OnClickHideDialog();
	}
	Debug(("class'UIDATA_PLAYER'.static.IsInDethrone()" @ string(Class'NWindow.UIDATA_PLAYER'.static.IsInDethrone())));
	Debug(("IsPlayerOnWorldRaidServer()" @ string(IsPlayerOnWorldRaidServer())));
	if(Class'NWindow.UIDATA_PLAYER'.static.IsInDethrone())
	{
		MainEnter_Button.SetTexture("L2UI_EPIC.DethroneWnd.Dethrone_ReturnBtn", "L2UI_EPIC.DethroneWnd.Dethrone_ReturnBtn_D", "L2UI_EPIC.DethroneWnd.Dethrone_ReturnBtn_O");
		MainEnter_Button.SetButtonName(13735);
		MainEnter_Button.SetTooltipType("text");
		MainEnter_Button.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13783), 200));
	}
	else
	{
		MainEnter_Button.SetTexture("L2UI_EPIC.DethroneWnd.Dethrone_EntranceBtn", "L2UI_EPIC.DethroneWnd.Dethrone_EntranceBtn_D", "L2UI_EPIC.DethroneWnd.Dethrone_EntranceBtn_O");
		MainEnter_Button.SetButtonName(13734);
		MainEnter_Button.ClearTooltip();
	}
	return;
}

function OnClickButton(string Name)
{
	Debug(("Name" @ Name));
	switch(Name)
	{
		case "Help_btn":
			Class'Interface.HelpWnd'.static.ShowHelp(63, 1);
			break;
		case "MainRefresh_Button":
			API_C_EX_DETHRONE_INFO();
			break;
		case "MainEnter_Button":
			if(Class'NWindow.UIDATA_PLAYER'.static.IsInDethrone())
			{
				askDialogScript.setInit(GetSystemString(13784));
				GetTextureHandle((m_Windowname $ ".DisableDialog_tex")).ShowWindow();
				GetTextureHandle((m_Windowname $ ".DisableDialog_tex")).SetFocus();
				GetWindowHandle("DethroneWnd.ConfirmWnd").ShowWindow();
				GetWindowHandle("DethroneWnd.ConfirmWnd").SetFocus();
			}
			else if((myInfo.nLevel >= 110))
			{
				Me.HideWindow();
				toggleWindow("DethroneCharacterCreateWnd", true, true);
				getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "DethroneCharacterCreateWnd");
			}
			else
			{
				getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(13452));
			}
			break;
		case "MainReward_Button":
			toggleWindow("DethroneResultWnd", true, true);
			break;
		case "prvReward_Button":
			toggleWindow("DethroneResultWnd", true, true);
			break;
		case "Dethrone_Tab0":
		case "Dethrone_Tab1":
		case "Dethrone_Tab2":
		case "Dethrone_Tab3":
			setDisableWnd();
			break;
		case "MainEnchant_Button":
			if(GetWindowHandle("DethroneFireEnchantWnd").IsShowWindow())
			{
				GetWindowHandle("DethroneFireEnchantWnd").HideWindow();
			}
			else
			{
				DethroneFireEnchantWnd(GetScript("DethroneFireEnchantWnd")).API_C_EX_ENHANCED_ABILITY_OF_FIRE_OPEN_UI();
			}
			break;
		case "MainShop_Button":
			toggleWindow("DethroneShopWnd", true, true);
			break;
		default:
			break;
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 9750:
			initControl();
			setDisableWnd();
			break;
		case EV_PacketID(950):
			ParsePacket_S_EX_DETHRONE_INFO();
		case EV_PacketID(963):
			ParsePacket_S_EX_DETHRONE_SEASON_INFO();
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_DETHRONE_INFO()
{
	local UIPacket._S_EX_DETHRONE_INFO packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_DETHRONE_INFO(packet))
	{
		return;
	}
	Debug(((((((((((((((((((" -->  Decode_S_EX_DETHRONE_INFO :  " @ packet.sName) @ string(packet.nAttackPoint)) @ string(packet.nLife)) @ string(packet.nRank)) @ string(packet.nTotalRankers)) @ string(packet.nPersonalDethronePoint)) @ string(packet.nPrevRank)) @ string(packet.nPrevTotalRankers)) @ string(packet.nPrevDethronePoint)) @ string(packet.nServerRank)) @ string(packet.nServerDethronePoint)) @ string(packet.nConquerorWorldID)) @ packet.sConquerorName) @ string(packet.nOccupyingServerWorldID)) @ string(packet.nTopRankerWorldID)) @ packet.sTopRankerName) @ string(packet.nTopServerWorldID)) @ string(packet.nTopServerDethronePoint)));
	dethroneSeverPCName = packet.sName;
	setMYInfo();
	AttackNum_text.SetText(string(packet.nAttackPoint));
	LifeNum_text.SetText(string(packet.nLife));
	MyDethronePointNum_text.SetText(MakeCostString(string(packet.nPersonalDethronePoint)));
	MyRanking_text.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(packet.nRank)));
	MyRankingNum_text.SetText((("(" $ stringPer(float(packet.nRank), float(packet.nTotalRankers))) $ "%)"));
	SetCusomTooltipAtPrvMyRankingInfo_btn((((MakeFullSystemMsg(GetSystemMessage(4553), string(packet.nPrevRank)) $ "(") $ stringPer(float(packet.nPrevRank), float(packet.nPrevTotalRankers))) $ "%)"), packet.nPrevDethronePoint);
	MyServerRanking_text.SetText(MakeFullSystemMsg(GetSystemMessage(4553), string(packet.nServerRank)));
	MyServerDethronePointNum_text.SetText(MakeCostString(string(packet.nServerDethronePoint)));
	prvRulerName_text.SetText(packet.sConquerorName);
	prvRulerServerMark_tex.SetTexture(GetServerMarkNameSmall(packet.nConquerorWorldID));
	if((packet.sConquerorName != ""))
	{
		prvRulerName_text.SetTooltipType("text");
		prvRulerName_text.SetTooltipText(((getServerNameByWorldID(packet.nConquerorWorldID) $ "_") $ getInstanceL2Util().makeZeroString(2, INT64(getServerExtIdByWorldID(packet.nConquerorWorldID)))));
	}
	else
	{
		prvRulerName_text.ClearTooltip();
		prvRulerName_text.SetTooltipText("");
	}
	if((getServerNameByWorldID(packet.nOccupyingServerWorldID) != ""))
	{
		ServerName_text.SetText(((getServerNameByWorldID(packet.nOccupyingServerWorldID) $ "_") $ getInstanceL2Util().makeZeroString(2, INT64(getServerExtIdByWorldID(packet.nOccupyingServerWorldID)))));
		prvServerMark_tex.SetTexture(GetServerMark(packet.nOccupyingServerWorldID));
	}
	NowRulerServerMark_tex.SetTexture(GetServerMarkNameSmall(packet.nTopRankerWorldID));
	NowRulerName_text.SetText(packet.sTopRankerName);
	if((packet.sTopRankerName != ""))
	{
		NowRulerName_text.SetTooltipType("text");
		NowRulerName_text.SetTooltipText(((getServerNameByWorldID(packet.nTopRankerWorldID) $ "_") $ getInstanceL2Util().makeZeroString(2, INT64(getServerExtIdByWorldID(packet.nTopRankerWorldID)))));
	}
	else
	{
		NowRulerName_text.ClearTooltip();
		NowRulerName_text.SetTooltipText("");
	}
	if((getServerNameByWorldID(packet.nTopServerWorldID) != ""))
	{
		OccupyServerMark_tex.SetTexture(GetServerMarkNameSmall(packet.nTopServerWorldID));
		OccupyName_text.SetText(((getServerNameByWorldID(packet.nTopServerWorldID) $ "_") $ getInstanceL2Util().makeZeroString(2, INT64(getServerExtIdByWorldID(packet.nTopServerWorldID)))));
	}
	OccupyPointNum_text.SetText(MakeCostString(string(packet.nTopServerDethronePoint)));
	return;
}

function initControl()
{
	AttackNum_text.SetText("");
	LifeNum_text.SetText("");
	MyDethronePointNum_text.SetText("");
	MyRanking_text.SetText("");
	MyRankingNum_text.SetText("");
	MyServerRanking_text.SetText("");
	MyServerDethronePointNum_text.SetText("");
	ServerName_text.SetText("");
	prvRulerServerMark_tex.SetTexture("");
	prvRulerName_text.SetText("");
	NowRulerServerMark_tex.SetTexture("");
	prvServerMark_tex.SetTexture("");
	NowRulerName_text.SetText("");
	OccupyServerMark_tex.SetTexture("");
	OccupyName_text.SetText("");
	OccupyPointNum_text.SetText("");
	return;
}

function ParsePacket_S_EX_DETHRONE_SEASON_INFO()
{
	local UIPacket._S_EX_DETHRONE_SEASON_INFO packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_DETHRONE_SEASON_INFO(packet))
	{
		return;
	}
	Debug((((" -->  Decode_S_EX_DETHRONE_INFO :  " @ string(packet.bOpen)) @ string(packet.nSeasonYear)) @ string(packet.nSeasonMonth)));
	isDethroneBOpen = numToBool(int(packet.bOpen));
	if((int(packet.bOpen) > 0))
	{
		OnOffIcon_tex.SetTexture("L2UI_CT1.OlympiadWnd.ONICON");
	}
	else
	{
		OnOffIcon_tex.SetTexture("L2UI_CT1.OlympiadWnd.OffICON");
	}
	WinServerName_text.SetText(MakeFullSystemMsg(GetSystemMessage(13433), string(packet.nSeasonYear), string(packet.nSeasonMonth)));
	return;
}

function bool isDethroneOpen()
{
	return isDethroneBOpen;
}

function setMYInfo()
{
	local int nClass, nLevel;

	GetPlayerInfo(myInfo);
	if(getInstanceUIData().GetIsLiveServer())
	{
		nClass = DetailStatusWndScript.getMainClassID();
		nLevel = DetailStatusWndScript.getMainLevel();
	}
	else
	{
		nClass = myInfo.nSubClass;
		nLevel = myInfo.nLevel;
	}
	Lv_text.SetText(string(nLevel));
	ClassName_text.SetText(GetClassType(nClass));
	if((dethroneSeverPCName == ""))
	{
		PCName_text.SetText(myInfo.Name);
	}
	else
	{
		PCName_text.SetText(((dethroneSeverPCName $ "_") $ getInstanceL2Util().makeZeroString(2, INT64(getServerExtIdByWorldID(myInfo.nWorldID)))));
	}
	MyServerMark_tex.SetTexture(GetServerMarkNameSmall(myInfo.nWorldID));
	MyServerRankingTitle_text.SetText(((getServerNameByWorldID(myInfo.nWorldID) $ "_") $ getInstanceL2Util().makeZeroString(2, INT64(getServerExtIdByWorldID(myInfo.nWorldID)))));
	if((GetClassTransferDegree(nClass) >= 1))
	{
		ClassMark_tex.SetTexture((("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ string(nClass)) $ "_Big"));
	}
	else
	{
		ClassMark_tex.SetTexture((("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ GetRaceString(myInfo.Race)) $ "_Big"));
	}
	return;
}

function setDisableWnd()
{
	Dethrone_Tab.DisableWindow();
	TabInsideWindowDisableWnd.ShowWindow();
	Me.SetTimer(1001113, 600);
	return;
}

function hideDisableWnd()
{
	Dethrone_Tab.EnableWindow();
	TabInsideWindowDisableWnd.HideWindow();
	Me.KillTimer(1001113);
	return;
}

function OnTimer(int TimeID)
{
	if((TimeID == 1001113))
	{
		hideDisableWnd();
	}
	return;
}

function AskDialogDethroneConnect()
{
	local int nDialogID, i;
	local array<RequestItem> needItemArray;

	nDialogID = 1;
	GetDethroneConnectCost(needItemArray);
	CommonDialogGetScript(DialogAsset_path).SetUseNeedItem(true);
	CommonDialogGetScript(DialogAsset_path).StartNeedItemList(needItemArray.Length);
	i = 0;
	while((i < needItemArray.Length))
	{
		CommonDialogGetScript(DialogAsset_path).AddNeedItemClassID(needItemArray[i].Id, needItemArray[i].Amount);
		i++;
	}
	CommonDialogGetScript(DialogAsset_path).SetItemNum(1);
	CommonDialogGetScript(DialogAsset_path).SetDialogID(nDialogID);
	CommonDialogGetScript(DialogAsset_path).ShowDesriptionBGDeco();
	CommonDialogShow(DialogAsset_path, connectImgHtml(), true);
	return;
}

function AskDialogDethronedisConnect()
{
	local int nDialogID;

	nDialogID = 2;
	CommonDialogGetScript(DialogAsset_path).SetUseNeedItem(false);
	CommonDialogGetScript(DialogAsset_path).SetDialogID(nDialogID);
	CommonDialogGetScript(DialogAsset_path).ShowDesriptionBGDeco();
	CommonDialogShow(DialogAsset_path, disconnectImgHtml(), true);
	GetButtonHandle((DialogAsset_path $ ".OkButton")).EnableWindow();
	return;
}

function AskDialogDethroneLeave()
{
	local int nDialogID;

	nDialogID = 3;
	CommonDialogGetScript(DialogAsset_path).SetUseNeedItem(false);
	CommonDialogGetScript(DialogAsset_path).SetDialogID(nDialogID);
	CommonDialogGetScript(DialogAsset_path).HideDesriptionBGDeco();
	CommonDialogShow(DialogAsset_path, GetSystemString(13784));
	return;
}

function string connectImgHtml()
{
	local string htmlAdd;

	htmlAdd = HtmlAddTableTD((("<br>" $ htmlAddImg("L2UI_EPIC.HtmlWnd.HtmlWnd_DethroneEnter_IMG", 321, 228)) $ htmlAddText(GetSystemString(13770), "GameDefault", "c8c8c8")), "Center", "Center", 0, 0, "", false);
	HtmlSetTableTR(htmlAdd);
	htmlSetTable(htmlAdd, 0, 340, 0, "", 0, 0);
	return htmlAdd;
}

function string disconnectImgHtml()
{
	local string htmlAdd;

	htmlAdd = HtmlAddTableTD((("<br>" $ htmlAddImg("L2UI_EPIC.HtmlWnd.HtmlWnd_DethroneEnter_IMG", 321, 228)) $ htmlAddText(GetSystemString(13771), "GameDefault", "c8c8c8")), "Center", "Center", 0, 0, "", false);
	HtmlSetTableTR(htmlAdd);
	htmlSetTable(htmlAdd, 0, 340, 0, "", 0, 0);
	return htmlAdd;
}

function SetCusomTooltipAtPrvMyRankingInfo_btn(string rankingString, INT64 pDethronePoint)
{
	local array<DrawItemInfo> drawListArr;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(3701), getInstanceL2Util().Yellow, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(((GetSystemString(1320) $ " : ") $ rankingString), getInstanceL2Util().White, "", true, true);
	drawListArr[drawListArr.Length] = addDrawItemText(((GetSystemString(13739) $ " : ") $ MakeCostString(string(pDethronePoint))), getInstanceL2Util().White, "", true, true);
	prvMyRankingInfo_btn.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
	return;
}

function API_C_EX_DETHRONE_INFO()
{
	local array<byte> stream;

	Class'Interface.UIPacket'.static.RequestUIPacket(715, stream);
	Debug("----> Api Call : C_EX_DETHRONE_INFO");
	return;
}

function API_C_EX_DETHRONE_LEAVE()
{
	local array<byte> stream;

	Class'Interface.UIPacket'.static.RequestUIPacket(724, stream);
	Debug("----> Api Call : C_EX_DETHRONE_LEAVE");
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	if(GetWindowHandle("DethroneWnd.ConfirmWnd").IsShowWindow())
	{
		OnClickHideDialog();
	}
	else
	{
		GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	}
	return;
}
