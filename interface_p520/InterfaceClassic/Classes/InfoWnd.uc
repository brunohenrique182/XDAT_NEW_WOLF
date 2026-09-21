class InfoWnd extends UICommonAPI
	dependson(UIPacket);

const TOPPING_MAX = 6;
const TOPPING_ICON_WH = 22;
const WINDOW_H_MIN = 2;
const WINDOW_H_GAP = 2;
const WINDOWS_MAX = 5;

struct ElementalInfo
{
	var int CurrSpiritType;
	var int SpiritClassID;
	var INT64 Exp;
	var INT64 NextExp;
	var INT64 MaxExp;
	var int CurrLevel;
	var int MaxLevel;
	var int EvolLevel;
	var int NpcID;
};

var string m_ToppingWndName;
var string m_VPWndName;
var string m_PCCafeWndwName;
var string m_MysteriousMansionWaitingWndName;
var string m_ElementalExpViewerWndName;
var string m_BloodyCoinWndName;
var string m_CostumeEventWndName;
var string m_IngamePrimeShopWnd;
var string m_IngameVIPWnd;
var string m_MagicLampWndName;
var string m_RandomCraftInfoWndName;
var string m_Windowname;
var TextureHandle windowBackground;
var WindowHandle Me;
var WindowHandle ToppingWnd;
var array<StatusIconHandle> toppingStatusIcons;
var array<TextureHandle> toppingDisableTextures;
var array<ToppingSkillExtraInfo> toppingDefaultInfos;
var WindowHandle VPWnd;
var TextureHandle VpIcon;
var StatusBarHandle VpDetailBar;
var TextBoxHandle VPDetailGaugeMax_Txt;
var TextBoxHandle VPTitleTextBox;
var int nVitalityBonus;
var int nVitalityExtraBonus;
var int nVitalityItemMaxRestoreCount;
var bool isAfterStatusNormaEvent;
var bool isVPApply;
var WindowHandle PCCafeEventWnd;
var WindowHandle HelpButton;
var int m_TotalPoint;
var int m_AddPoint;
var int m_PeriodType;
var int m_RemainTime;
var int m_PointType;
var WindowHandle MysteriousMansionWaitingWnd;
var WindowHandle MHelpButton;
var ButtonHandle MCancelButton;
var WindowHandle ElementalExpViewerWnd;
var StatusBarHandle ElementalExpBar;
var TextureHandle ElementalIcon;
var TextBoxHandle ElementalGrandNameText;
var TextBoxHandle ElementalLevelText;
var ElementalInfo currentemelentalInfo;
var WindowHandle BloodyCoinWnd;
var AnimTextureHandle BloodCoinAddAnim;
var ButtonHandle HelpBCButton;
var TextureHandle BloodyCoin_shopIcon;
var TextBoxHandle BloodCoinTitleTextBox;
var INT64 bloodCoin;
var WindowHandle CostumeEventWnd;
var ItemWindowHandle CostumeShortcutItemWnd1;
var ItemWindowHandle CostumeShortcutItemWnd2;
var ItemWindowHandle CostumeShortcutItemWnd3;
var ItemWindowHandle CostumeShortcutItemWnd4;
var TextBoxHandle CostumeShortCutNum_Txt;
var ButtonHandle CostumeShortCutUp_Btn;
var ButtonHandle CostumeShortCutDown_Btn;
var int nCostumeShortCutNum;
var WindowHandle IngamePrimeShopWnd;
var WindowHandle IngameVIPWnd;
var WindowHandle MagicLampEventWnd;
var ButtonHandle MagicLampHelp_Btn;
var ButtonHandle GameStart_Btn;
var TextBoxHandle MagicLampNum_Txt;
var TextBoxHandle MagicLampGaugeMax_Txt;
var StatusBarHandle MagicLampNum_StatusBar;
var WindowHandle RandomCraftInfoWnd;
var StatusBarHandle RandomCraftNum_StatusBar;
var AnimTextureHandle RandomCraftSmallIcon_Ani;
var TextureHandle RandomCraftNoticeIcon_Tex;
var TextBoxHandle RandomCraftNum_Txt;
var TextBoxHandle RandomCraftMax_Txt;
var ButtonHandle RandomCraftCharging_Btn;
var ButtonHandle RandomCraftRandom_Btn;
var ButtonHandle RandomCraftMaterial_Btn;
var array<WindowHandle> allWindow;
var bool m_bIsPCCafeEvent;
var bool bIsOptionValue;
var bool bIsShowBackup;
var bool isEnterState;
var bool isShowInfoWnd;
var int UseClassicLCoinShop;

function OnRegisterEvent()
{
	return;
	RegisterEvent(150);
	RegisterEvent(161);
	RegisterEvent(950);
	RegisterEvent(180);
	RegisterEvent(4110);
	RegisterEvent(1910);
	RegisterEvent(531);
	RegisterEvent(9310);
	RegisterEvent(9320);
	RegisterEvent(40);
	RegisterEvent(8000);
	RegisterEvent(10930);
	RegisterEvent(10940);
	RegisterEvent(11060);
	RegisterEvent(20256);
	RegisterEvent(9015);
	RegisterEvent(20150);
	RegisterEvent(11080);
	return;
}

function OnLoad()
{
	local int i;

	VPWnd = GetWindowHandle(m_VPWndName);
	VpDetailBar = GetStatusBarHandle((m_VPWndName $ ".VpDetailBar"));
	VPDetailGaugeMax_Txt = GetTextBoxHandle((m_VPWndName $ ".VPDetailGaugeMax_Txt"));
	VPTitleTextBox = GetTextBoxHandle((m_VPWndName $ ".TitleTextBox"));
	VpIcon = GetTextureHandle((m_VPWndName $ ".VPIcon"));
	PCCafeEventWnd = GetWindowHandle(m_PCCafeWndwName);
	HelpButton = GetWindowHandle((m_PCCafeWndwName $ ".HelpButton"));
	ToppingWnd = GetWindowHandle(m_ToppingWndName);
	toppingStatusIcons.Length = 6;
	i = 0;
	while((i < 6))
	{
		toppingStatusIcons[i] = GetStatusIconHandle(((m_ToppingWndName $ ".StatusIcon") $ string((i + 1))));
		toppingStatusIcons[i].Clear();
		toppingDisableTextures[i] = GetTextureHandle(((m_ToppingWndName $ ".toppingDisable") $ string((i + 1))));
		i++;
	}
	MysteriousMansionWaitingWnd = GetWindowHandle(m_MysteriousMansionWaitingWndName);
	MHelpButton = GetWindowHandle((m_MysteriousMansionWaitingWndName $ ".MHelpButton"));
	MHelpButton.SetTooltipCustomType(getCustomToolTip(GetSystemString(2812)));
	MCancelButton = GetButtonHandle((m_MysteriousMansionWaitingWndName $ ".MCancelButton"));
	ElementalExpViewerWnd = GetWindowHandle(m_ElementalExpViewerWndName);
	ElementalExpBar = GetStatusBarHandle((m_ElementalExpViewerWndName $ ".ElementalExpBar"));
	ElementalIcon = GetTextureHandle((m_ElementalExpViewerWndName $ ".ElementalIcon"));
	ElementalGrandNameText = GetTextBoxHandle((m_ElementalExpViewerWndName $ ".TitleTextBox"));
	ElementalLevelText = GetTextBoxHandle((m_ElementalExpViewerWndName $ ".NumberTextBox"));
	BloodyCoinWnd = GetWindowHandle(m_BloodyCoinWndName);
	BloodCoinAddAnim = GetAnimTextureHandle((m_BloodyCoinWndName $ ".BloodCoinAddAnim"));
	BloodCoinTitleTextBox = GetTextBoxHandle((m_BloodyCoinWndName $ ".TitleTextBox"));
	BloodyCoin_shopIcon = GetTextureHandle((m_BloodyCoinWndName $ ".BloodyCoin_shopIcon"));
	BloodCoinAddAnim.Stop();
	HelpBCButton = GetButtonHandle((m_BloodyCoinWndName $ ".HelpBCButton"));
	bloodCoin = INT64(-1);
	CostumeEventWnd = GetWindowHandle(m_CostumeEventWndName);
	CostumeShortcutItemWnd1 = GetItemWindowHandle((m_CostumeEventWndName $ ".CostumeShortcutItemWnd1"));
	CostumeShortcutItemWnd2 = GetItemWindowHandle((m_CostumeEventWndName $ ".CostumeShortcutItemWnd2"));
	CostumeShortcutItemWnd3 = GetItemWindowHandle((m_CostumeEventWndName $ ".CostumeShortcutItemWnd3"));
	CostumeShortcutItemWnd4 = GetItemWindowHandle((m_CostumeEventWndName $ ".CostumeShortcutItemWnd4"));
	CostumeShortCutNum_Txt = GetTextBoxHandle((m_CostumeEventWndName $ ".CostumeShortCutNum_Txt"));
	CostumeShortCutDown_Btn = GetButtonHandle((m_CostumeEventWndName $ ".CostumeShortCutDown_Btn"));
	CostumeShortCutUp_Btn = GetButtonHandle((m_CostumeEventWndName $ ".CostumeShortCutUp_Btn"));
	IngamePrimeShopWnd = GetWindowHandle(m_IngamePrimeShopWnd);
	IngameVIPWnd = GetWindowHandle(m_IngameVIPWnd);
	MagicLampEventWnd = GetWindowHandle(m_MagicLampWndName);
	MagicLampHelp_Btn = GetButtonHandle((m_MagicLampWndName $ ".MagicLampHelp_Btn"));
	GameStart_Btn = GetButtonHandle((m_MagicLampWndName $ ".GameStart_Btn"));
	MagicLampNum_Txt = GetTextBoxHandle((m_MagicLampWndName $ ".MagicLampNum_Txt"));
	MagicLampGaugeMax_Txt = GetTextBoxHandle((m_MagicLampWndName $ ".MagicLampGaugeMax_Txt"));
	MagicLampNum_StatusBar = GetStatusBarHandle((m_MagicLampWndName $ ".MagicLampNum_StatusBar"));
	RandomCraftInfoWnd = GetWindowHandle(m_RandomCraftInfoWndName);
	RandomCraftNum_StatusBar = GetStatusBarHandle((m_RandomCraftInfoWndName $ ".RandomCraftNum_StatusBar"));
	RandomCraftSmallIcon_Ani = GetAnimTextureHandle((m_RandomCraftInfoWndName $ ".RandomCraftSmallIcon_Ani"));
	RandomCraftNoticeIcon_Tex = GetTextureHandle((m_RandomCraftInfoWndName $ ".RandomCraftNoticeIcon_Tex"));
	RandomCraftNum_Txt = GetTextBoxHandle((m_RandomCraftInfoWndName $ ".RandomCraftNum_Txt"));
	RandomCraftMax_Txt = GetTextBoxHandle((m_RandomCraftInfoWndName $ ".RandomCraftMax_Txt"));
	RandomCraftCharging_Btn = GetButtonHandle((m_RandomCraftInfoWndName $ ".RandomCraftCharging_Btn"));
	RandomCraftRandom_Btn = GetButtonHandle((m_RandomCraftInfoWndName $ ".RandomCraftRandom_Btn"));
	RandomCraftMaterial_Btn = GetButtonHandle((m_RandomCraftInfoWndName $ ".RandomCraftMaterial_Btn"));
	RandomCraftNoticeIcon_Tex.SetTexture("L2UI_CT1.InfoWnd.InfoWnd_RandomCraftIcon_dis");
	Me = GetWindowHandle(m_Windowname);
	windowBackground = GetTextureHandle((m_Windowname $ ".CTextureCtrl939"));
	setWindowOrder();
	m_bIsPCCafeEvent = false;
	setWindowShowHide(MagicLampEventWnd, false);
	setWindowShowHide(RandomCraftInfoWnd, false);
	GetINIBool("Localize", "UseClassicLCoinShop", UseClassicLCoinShop, "L2.ini");
	return;
}

function setWindowOrder()
{
	local int i;

	allWindow.Length = 5;
	allWindow[i++] = ToppingWnd;
	allWindow[i++] = VPWnd;
	allWindow[i++] = ElementalExpViewerWnd;
	allWindow[i++] = BloodyCoinWnd;
	allWindow[i++] = PCCafeEventWnd;
	allWindow[i++] = MysteriousMansionWaitingWnd;
	allWindow[i++] = MagicLampEventWnd;
	allWindow[i++] = CostumeEventWnd;
	allWindow[i++] = IngamePrimeShopWnd;
	allWindow[i++] = IngameVIPWnd;
	allWindow[i++] = RandomCraftInfoWnd;
	return;
}

function OnEvent(int a_EventID, string a_Param)
{
	return;
	switch(a_EventID)
	{
		case 150:
			handleOnGamingStateEnter();
			break;
		case 161:
			bIsShowBackup = PCCafeEventWnd.IsShowWindow();
			break;
		case 950:
			if((int(GetLanguage()) == 0))
			{
				handleBuffEvent(a_Param);
				if(getInstanceUIData().GetIsClassicServer())
				{
					if(!isAfterStatusNormaEvent)
					{
						isAfterStatusNormaEvent = true;
						showVPSystemMsg();
					}
				}
			}
			break;
		case 180:
			handleVPPoint();
			break;
		case 4110:
			if(IsAdenServer())
			{
				HandleVitalityEffectInfo(a_Param);
			}
			break;
		case 1910:
			HandlePCCafePointInfo(a_Param);
			break;
		case 531:
			HandleToggleShowPCCafeEventWnd();
			break;
		case 40:
			setWindowShowHide(MysteriousMansionWaitingWnd, false);
			setWindowShowHide(MagicLampEventWnd, false);
			setWindowShowHide(RandomCraftInfoWnd, false);
			bloodCoin = INT64(-1);
			RandomCraftNoticeIcon_Tex.SetTexture("L2UI_CT1.InfoWnd.InfoWnd_RandomCraftIcon_dis");
			nCostumeShortCutNum = 0;
			break;
		case 9320:
			setWindowShowHide(MysteriousMansionWaitingWnd, false);
			break;
		case 9310:
			CuriousHouseHandle(a_Param);
			break;
		case 8000:
			MHelpButton.SetTooltipCustomType(getCustomToolTip(GetSystemString(2812)));
			break;
		case 10930:
			HandleSpriteExp(a_Param);
			break;
		case 11060:
			HandleBloodyCoin(a_Param);
			break;
		case 11080:
			HandleMagicLamp(a_Param);
			break;
		case 10940:
			HandleSpriteInfo(a_Param);
			break;
		case 20256:
			Debug(("============= EV_CostumeShortCutList" @ a_Param));
			HandleCostumeShortCutList(a_Param);
			break;
		case 9015:
			Debug(("============= EV_BR_CashShopNewIconAnim" @ a_Param));
			HandleCashShopNewIconAnim(a_Param);
			break;
		case 20150:
			Debug(("============= EV_VipInfo" @ a_Param));
			HandleVipInfo(a_Param);
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_CRAFT_INFO(UIPacket._S_EX_CRAFT_INFO packet)
{
	local float fPer, MaxPoint;
	local int currentCharge, maxGauge;

	MaxPoint = float(Class'NWindow.RandomCraftAPI'.static.GetMaxItemPoint());
	maxGauge = Class'NWindow.RandomCraftAPI'.static.GetMaxGaugeValue();
	setWindowShowHide(RandomCraftInfoWnd, true);
	RandomCraftNum_Txt.SetText(("x" $ string(packet.nPoint)));
	if(((float(packet.nPoint) >= MaxPoint) && (packet.nCharge >= (maxGauge - 1))))
	{
		RandomCraftMax_Txt.SetText("Max");
	}
	else
	{
		currentCharge = int(getInstanceL2Util().Get9999Percent(INT64(packet.nCharge), INT64(maxGauge)));
		fPer = ((float(currentCharge) / float(maxGauge)) * 100.0000000);
		RandomCraftMax_Txt.SetText(cutFloat(fPer));
	}
	if((int(packet.bGiveItem) > 0))
	{
		RandomCraftNoticeIcon_Tex.SetTexture("L2UI_CT1.InfoWnd.InfoWnd_RandomCraftIcon");
	}
	else
	{
		RandomCraftNoticeIcon_Tex.SetTexture("L2UI_CT1.InfoWnd.InfoWnd_RandomCraftIcon_dis");
	}
	RandomCraftNum_StatusBar.SetPoint(INT64(packet.nCharge), INT64(maxGauge));
	return;
}

function HandleCashShopNewIconAnim(string param)
{
	local int nNewIConAnim;

	ParseInt(param, "NewIConAnim", nNewIConAnim);
	if((nNewIConAnim > 0))
	{
		GetButtonHandle((m_IngamePrimeShopWnd $ ".IngamePrimeShopNoticeIcon_Btn")).ShowWindow();
		GetAnimTextureHandle((m_IngamePrimeShopWnd $ ".IngamePrimeShopNoticeIconEff_AnimTex")).ShowWindow();
		GetAnimTextureHandle((m_IngamePrimeShopWnd $ ".IngamePrimeShopNoticeIconEff_AnimTex")).SetLoopCount(999999);
		GetAnimTextureHandle((m_IngamePrimeShopWnd $ ".IngamePrimeShopNoticeIconEff_AnimTex")).Stop();
		GetAnimTextureHandle((m_IngamePrimeShopWnd $ ".IngamePrimeShopNoticeIconEff_AnimTex")).Play();
	}
	else
	{
		GetButtonHandle((m_IngamePrimeShopWnd $ ".IngamePrimeShopNoticeIcon_Btn")).HideWindow();
		GetAnimTextureHandle((m_IngamePrimeShopWnd $ ".IngamePrimeShopNoticeIconEff_AnimTex")).HideWindow();
		GetAnimTextureHandle((m_IngamePrimeShopWnd $ ".IngamePrimeShopNoticeIconEff_AnimTex")).Stop();
	}
	return;
}

function HandleVipInfo(string param)
{
	local int nCurrVipLevel;

	ParseInt(param, "CurrVipLevel", nCurrVipLevel);
	GetTextBoxHandle((m_IngameVIPWnd $ ".IngameVIPButton_Name")).SetText((GetSystemString(5819) @ string(nCurrVipLevel)));
	GetTextureHandle((m_IngameVIPWnd $ ".IngameVIPIcon_Tex")).SetTexture(("L2UI_CT1.Global.VIPmark_" $ string(nCurrVipLevel)));
	return;
}

function HandleCostumeShortCutList(string param)
{
	local int nResult, nPage, nListSize, nSkillID, nSkillLv, nSlotIndex, i, N;
	local ItemInfo infItem, ClearItem;
	local SkillInfo SkillInfo;

	ParseInt(param, "Result", nResult);
	ParseInt(param, "ListSize", nListSize);
	ClearItem.IconName = "L2ui_ct1.emptyBtn";
	if((nResult > 0))
	{
		setWindowShowHide(CostumeEventWnd, true);
		if((nCostumeShortCutNum <= 0))
		{
			Debug("::변신체 스킬 info창 초기화 ");  // EN: ::reset the transformation skill info window
			nCostumeShortCutNum = 1;
			i = 1;
			while((i < 4))
			{
				GetItemWindowHandle(((m_CostumeEventWndName $ ".CostumeShortcutItemWnd") $ string(i))).Clear();
				N = 0;
				while((N < 4))
				{
					GetItemWindowHandle(((m_CostumeEventWndName $ ".CostumeShortcutItemWnd") $ string(i))).AddItem(ClearItem);
					N++;
				}
				i++;
			}
		}
		i = 0;
		while((i < nListSize))
		{
			ParseInt(param, ("Page" $ string(i)), nPage);
			ParseInt(param, ("SkillID" $ string(i)), nSkillID);
			ParseInt(param, ("SkillLV" $ string(i)), nSkillLv);
			ParseInt(param, ("SlotIndex" $ string(i)), nSlotIndex);
			if(GetSkillInfo(nSkillID, nSkillLv, 0, SkillInfo))
			{
				infItem.Id.ClassID = nSkillID;
				infItem.Level = nSkillLv;
				infItem.SubLevel = SkillInfo.SkillSubLevel;
				infItem.Name = SkillInfo.SkillName;
				infItem.IconName = SkillInfo.TexName;
				infItem.IconPanel = SkillInfo.IconPanel;
				infItem.Description = SkillInfo.SkillDesc;
				infItem.ShortcutType = 2;
				GetItemWindowHandle(((m_CostumeEventWndName $ ".CostumeShortcutItemWnd") $ string((nPage + 1)))).SetItem(nSlotIndex, infItem);
				i++;
				continue;
			}
			GetItemWindowHandle(((m_CostumeEventWndName $ ".CostumeShortcutItemWnd") $ string((nPage + 1)))).SetItem(nSlotIndex, ClearItem);
			i++;
		}
		showCostumeShortcut(0);
	}
	return;
}

function OnClickItem(string strID, int Index)
{
	local ItemInfo infItem;

	if(((InStr(strID, "CostumeShortcutItemWnd") > -1) && (Index > -1)))
	{
		GetItemWindowHandle(((m_CostumeEventWndName $ ".") $ strID)).GetItem(Index, infItem);
		Debug(("OnClickItem CostumeShortcutItemWnd : " @ infItem.Name));
		UseSkill(infItem.Id, infItem.ShortcutType);
	}
	return;
}

function showCostumeShortcut(int nAddPage)
{
	local int i;

	nCostumeShortCutNum = (nCostumeShortCutNum + nAddPage);
	if((nCostumeShortCutNum <= 1))
	{
		CostumeShortCutUp_Btn.EnableWindow();
		CostumeShortCutDown_Btn.DisableWindow();
	}
	else if((nCostumeShortCutNum == 2))
	{
		CostumeShortCutUp_Btn.EnableWindow();
		CostumeShortCutDown_Btn.EnableWindow();
	}
	else if((nCostumeShortCutNum > 2))
	{
		CostumeShortCutUp_Btn.DisableWindow();
		CostumeShortCutDown_Btn.EnableWindow();
	}
	i = 1;
	while((i < 4))
	{
		if((nCostumeShortCutNum == i))
		{
			GetItemWindowHandle(((m_CostumeEventWndName $ ".CostumeShortcutItemWnd") $ string(i))).ShowWindow();
			i++;
			continue;
		}
		GetItemWindowHandle(((m_CostumeEventWndName $ ".CostumeShortcutItemWnd") $ string(i))).HideWindow();
		i++;
	}
	CostumeShortCutNum_Txt.SetText(string(nCostumeShortCutNum));
	return;
}

function OnClickButton(string a_ButtonID)
{
	Debug(("a_ButtonID" @ a_ButtonID));
	switch(a_ButtonID)
	{
		case "CloseButton":
			HandleToggleShowPCCafeEventWnd();
			break;
		case "BloodyCoinBtn":
			HandleToggleShowShopDailyWnd();
			break;
		case "PCCafeBtn":
			HandleToggleShowPCCafeCommuniWnd();
			break;
		case "MCancelButton":
			RequestCancelCuriousHouse();
			break;
		case "GameStart_Btn":
			toggleWindow("MagicLampWnd", true, true);
			break;
		case "CostumeShortCutUp_Btn":
			showCostumeShortcut(1);
			break;
		case "RandomCraftItemPointCharge_Btn":
			toggleWindow("RandomCraftChargingWnd", true, true);
			break;
		case "RandomCraftRandom_Btn":
			toggleWindow("RandomCraftWnd", true, true);
			break;
		case "RandomCraftMaterial_Btn":
			if(GetWindowHandle("MultiSellWnd").IsShowWindow())
			{
				GetWindowHandle("MultiSellWnd").HideWindow();
			}
			else
			{
				API_C_EX_MULTI_SELL_LIST(915);
			}
			break;
		case "CostumeShortCutDown_Btn":
			showCostumeShortcut(-1);
			break;
		case "IngameVIP_Btn":
			toggleWindow("VipInfoWnd", true, true);
			break;
		case "IngamePrimeShop_Btn":
			toggleWindow("IngameShopWnd", true, true);
			break;
		case "IngamePrimeShopNoticeIcon_Btn":
			CallGFxFunction("IngameShopWnd", "showVIPTab", "");
			break;
		default:
			break;
	}
	return;
}

function API_C_EX_MULTI_SELL_LIST(int nMultiSellID)
{
	local array<byte> stream;
	local UIPacket._C_EX_MULTI_SELL_LIST packet;

	packet.nGroupID = nMultiSellID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_MULTI_SELL_LIST(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(624, stream);
	Debug("----> Api Call : C_EX_MULTI_SELL_LIST 멀티셀 호출 ");  // EN?: ---- > Api Call: C_EX_multi_sell_list Multicell call
	return;
}

function getToppingDefault()
{
	local int i;
	local ToppingSkillExtraInfo tmpSkillExtraInfo;

	toppingDefaultInfos.Remove(0, toppingDefaultInfos.Length);
	toppingDefaultInfos.Length = 6;
	Class'NWindow.UIDATA_SKILL'.static.GetFirstDefaultToppingSkillExtraInfo(toppingDefaultInfos[0]);
	while(Class'NWindow.UIDATA_SKILL'.static.GetNextDefaultToppingSkillExtraInfo(tmpSkillExtraInfo))
	{
		i++;
		toppingDefaultInfos[i] = tmpSkillExtraInfo;
	}
	return;
}

function setToppingBuffIcon(int SlotIndex, StatusIconInfo toppingInfo, bool bActive)
{
	local StatusIconInfo tmpInfo;

	toppingStatusIcons[(SlotIndex - 1)].GetItem(0, 0, tmpInfo);
	if(bActive)
	{
		toppingDisableTextures[(SlotIndex - 1)].HideWindow();
	}
	else
	{
		toppingDisableTextures[(SlotIndex - 1)].ShowWindow();
	}
	if((tmpInfo == toppingInfo))
	{
		return;
	}
	toppingStatusIcons[(SlotIndex - 1)].Clear();
	toppingStatusIcons[(SlotIndex - 1)].AddRow();
	toppingStatusIcons[(SlotIndex - 1)].AddCol(0, toppingInfo);
	return;
}

function handleBuffEvent(string param)
{
	local int i, Max;
	local StatusIconInfo Info;
	local ToppingSkillExtraInfo toppingSkillInfo;
	local array<int> bActivedSlot;

	bActivedSlot.Length = 6;
	Info.Size = 22;
	Info.BackTex = "l2ui_ct1.Ntopping_Lock";
	Info.bShow = true;
	Info.bEtcItem = false;
	Info.bShortItem = false;
	ParseInt(param, "ServerID", Info.ServerID);
	ParseInt(param, "Max", Max);
	i = 0;
	while((i < Max))
	{
		ParseItemIDWithIndex(param, Info.Id, i);
		ParseInt(param, ("SkillLevel_" $ string(i)), Info.Level);
		ParseInt(param, ("SkillSubLevel_" $ string(i)), Info.SubLevel);
		ParseInt(param, ("RemainTime_" $ string(i)), Info.RemainTime);
		ParseString(param, ("Name_" $ string(i)), Info.Name);
		ParseString(param, ("IconName_" $ string(i)), Info.IconName);
		ParseString(param, ("IconPanel_" $ string(i)), Info.IconPanel);
		ParseString(param, ("Description_" $ string(i)), Info.Description);
		if(Class'NWindow.UIDATA_SKILL'.static.IsToppingSkill(Info.Id, Info.Level, Info.SubLevel))
		{
			Class'NWindow.UIDATA_SKILL'.static.GetToppingSkillExtraInfo(Info.Id, Info.Level, Info.SubLevel, toppingSkillInfo);
			bActivedSlot[(toppingSkillInfo.SlotIndex - 1)] = 1;
			setToppingBuffIcon(toppingSkillInfo.SlotIndex, Info, true);
		}
		i++;
	}
	setDefaultToppingBuff(bActivedSlot);
	return;
}

function setDefaultToppingBuff(array<int> bActivedSlot)
{
	local int i;
	local StatusIconInfo Info;
	local bool isActived, isActivedTopping;

	Info.Size = 22;
	Info.BackTex = "l2ui_ct1.Ntopping_Lock";
	Info.bShow = true;
	Info.bEtcItem = false;
	Info.bShortItem = false;
	i = 0;
	while((i < 6))
	{
		isActived = (bActivedSlot[i] == 1);
		if(isActived)
		{
			isActivedTopping = true;
		}
		if(!isActived)
		{
			Info.Id = GetItemID(toppingDefaultInfos[i].Id);
			Info.Level = toppingDefaultInfos[i].Level;
			Info.SubLevel = toppingDefaultInfos[i].SubLevel;
			Info.RemainTime = -1;
			Info.Name = Class'NWindow.UIDATA_SKILL'.static.GetName(Info.Id, Info.Level, Info.SubLevel);
			Info.Description = Class'NWindow.UIDATA_SKILL'.static.GetDescription(Info.Id, Info.Level, Info.SubLevel);
			Info.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(Info.Id, Info.Level, Info.SubLevel);
			Info.IconPanel = Class'NWindow.UIDATA_SKILL'.static.GetIconPanel(Info.Id, Info.Level, Info.SubLevel);
			setToppingBuffIcon((i + 1), Info, false);
		}
		i++;
	}
	setWindowShowHide(ToppingWnd, isActivedTopping);
	return;
}

function handleVPPoint()
{
	local UserInfo UserInfo;
	local int vitality, VitalNum, VitalityPer, VitalityPerText, oneline, MaxVitality;

	MaxVitality = GetMaxVitality();
	oneline = (MaxVitality / 25);
	if(GetPlayerInfo(UserInfo))
	{
		vitality = UserInfo.nVitality;
		if((vitality == 0))
		{
			VitalityPer = 0;
			VPDetailGaugeMax_Txt.SetText("0%");
			VPTitleTextBox.SetText((GetSystemString(2492) @ "x0"));
		}
		else if((vitality == MaxVitality))
		{
			VitalityPer = oneline;
			VPDetailGaugeMax_Txt.SetText(GetSystemString(3451));
			VPTitleTextBox.SetText((((GetSystemString(2492) @ "x24(") $ GetSystemString(3451)) $ ")"));
		}
		else
		{
			VitalNum = ((vitality - 1) / oneline);
			VitalityPer = (vitality - (VitalNum * oneline));
			VitalityPerText = ((VitalityPer * 100) / oneline);
			if((VitalityPerText == 0))
			{
				VitalityPerText = 1;
			}
			VPDetailGaugeMax_Txt.SetText((string(VitalityPerText) $ "%"));
			VPTitleTextBox.SetText(((GetSystemString(2492) @ "x") $ string(VitalNum)));
		}
		VpDetailBar.SetPoint(INT64(VitalityPer), INT64(oneline));
	}
	return;
}

function HandleVitalityEffectInfo(string param)
{
	local CustomTooltip t;
	local int nVitality, nVitalityItemRestoreCount;
	local string sBonusString, sExtraBonusString;
	local L2Util util;

	ParseInt(param, "vitalityPoint", nVitality);
	ParseInt(param, "vitalityBonus", nVitalityBonus);
	ParseInt(param, "restoreCount", nVitalityItemRestoreCount);
	ParseInt(param, "maxRestoreCount", nVitalityItemMaxRestoreCount);
	ParseInt(param, "vitalityExtraBonus", nVitalityExtraBonus);
	sBonusString = (string(nVitalityBonus) $ "%");
	if((nVitalityExtraBonus > 0))
	{
		sExtraBonusString = (("(+" $ string(nVitalityExtraBonus)) $ "%)");
	}
	util = L2Util(GetScript("L2Util"));
	util.setCustomTooltip(t);
	util.ToopTipInsertText(GetSystemString(2494), true, false);
	if((nVitality <= 0))
	{
		util.ToopTipInsertText(GetSystemString(2496), true, false, COLOR_GRAY);
		util.ToopTipInsertText(", ", true, false);
		VpIcon.SetTexture("L2UI_CT1.Icon.InfoWnd_VPIcon_dis");
	}
	else
	{
		util.ToopTipInsertText(sBonusString, true, false);
		util.ToopTipInsertText(sExtraBonusString, true, false, COLOR_YELLOW03);
		util.ToopTipInsertText(((" " $ GetSystemString(2495)) $ ". "), true, false);
		VpIcon.SetTexture("L2UI_CT1.Icon.InfoWNd_VPIcon");
	}
	VpDetailBar.SetTooltipCustomType(util.getCustomToolTip());
	if(((isVPApply && (nVitality == 0)) || (!isVPApply && (nVitality > 0))))
	{
		showVPSystemMsg();
	}
	return;
}

function showVPSystemMsg()
{
	local string sBonusString, sExtraBonusString, sSysMsgParamString;
	local UserInfo UserInfo;
	local int nVitality;
	local string sMessage;

	if(!GetPlayerInfo(UserInfo))
	{
		return;
	}
	nVitality = UserInfo.nVitality;
	sBonusString = (string(nVitalityBonus) $ "%");
	if((nVitalityExtraBonus > 0))
	{
		sExtraBonusString = (("(+" $ string(nVitalityExtraBonus)) $ "%)");
	}
	if(isAfterStatusNormaEvent)
	{
		isVPApply = (nVitality > 0);
		if(isVPApply)
		{
			ParamAdd(sSysMsgParamString, "Type", string(0));
			ParamAdd(sSysMsgParamString, "param1", (sBonusString $ sExtraBonusString));
			AddSystemMessageParam(sSysMsgParamString);
			sSysMsgParamString = "";
			ParamAdd(sSysMsgParamString, "Type", string(1));
			ParamAdd(sSysMsgParamString, "param1", string(nVitalityItemMaxRestoreCount));
			AddSystemMessageParam(sSysMsgParamString);
			sMessage = EndSystemMessageParam(6067, true);
			if(!getInstanceUIData().GetIsClassicServer())
			{
				AddSystemMessageString(sMessage);
			}
			isVPApply = true;
		}
		else
		{
			ParamAdd(sSysMsgParamString, "Type", string(1));
			ParamAdd(sSysMsgParamString, "param1", string(nVitalityItemMaxRestoreCount));
			AddSystemMessageParam(sSysMsgParamString);
			sMessage = EndSystemMessageParam(6068, true);
			AddSystemMessageString(sMessage);
			isVPApply = false;
		}
	}
	return;
}

function HandleSpriteInfo(string param)
{
	ParseInt(param, "SpiritClassID", currentemelentalInfo.SpiritClassID);
	ParseInt(param, "CurrLevel", currentemelentalInfo.CurrLevel);
	ParseInt(param, "MaxLevel", currentemelentalInfo.MaxLevel);
	ParseInt(param, "CurrSpiritType", currentemelentalInfo.CurrSpiritType);
	ParseInt(param, "EvolLevel", currentemelentalInfo.EvolLevel);
	ParseInt(param, "NpcID", currentemelentalInfo.NpcID);
	ParseINT64(param, "Exp", currentemelentalInfo.Exp);
	ParseINT64(param, "MaxExp", currentemelentalInfo.MaxExp);
	ParseINT64(param, "NextExp", currentemelentalInfo.NextExp);
	SetElemantalTexture();
	SetElemantalTitle();
	setElemantalLevel();
	SetElementalExp();
	return;
}

function HandleSpriteExp(string param)
{
	local INT64 Exp;
	local int Type;

	ParseINT64(param, "Exp", Exp);
	ParseInt(param, "Type", Type);
	if((currentemelentalInfo.CurrSpiritType == Type))
	{
		currentemelentalInfo.Exp = Exp;
		SetElementalExp();
	}
	return;
}

function SetElementalExp()
{
	local INT64 ExpValue;

	GetElementalSpiritExpData(currentemelentalInfo.CurrSpiritType, currentemelentalInfo.EvolLevel, (currentemelentalInfo.CurrLevel - 1), ExpValue);
	ElementalExpBar.SetPointExpPercentRate((float((currentemelentalInfo.Exp - ExpValue)) / float((currentemelentalInfo.NextExp - ExpValue))));
	return;
}

function SetElemantalTitle()
{
	local string nickname, ellipsedNickName;

	nickname = Class'NWindow.UIDATA_NPC'.static.GetNPCNickName(currentemelentalInfo.NpcID);
	ellipsedNickName = GetEllipsisString(nickname, 120);
	if((nickname != ellipsedNickName))
	{
		ElementalGrandNameText.SetTooltipString(nickname);
	}
	else
	{
		ElementalGrandNameText.SetTooltipString("");
	}
	ElementalGrandNameText.SetText(ellipsedNickName);
	return;
}

function SetElemantalTexture()
{
	local string TextureName;

	switch(currentemelentalInfo.CurrSpiritType)
	{
		case 0:
			setWindowShowHide(ElementalExpViewerWnd, false);
			break;
		case 1:
			TextureName = "L2UI_CT1.Icon.InfoWnd_FireIcon";
			break;
		case 2:
			TextureName = "L2UI_CT1.Icon.InfoWnd_WaterIcon";
			break;
		case 3:
			TextureName = "L2UI_CT1.Icon.InfoWnd_WindIcon";
			break;
		case 4:
			TextureName = "L2UI_CT1.Icon.InfoWnd_EarthIcon";
			break;
		default:
			break;
	}
	ElementalIcon.SetTexture(TextureName);
	return;
}

function setElemantalLevel()
{
	ElementalLevelText.SetText(string(currentemelentalInfo.CurrLevel));
	return;
}

function HandleMagicLamp(string a_Param)
{
	local int nIsOpen, nCount, nCurrExp, nMaxExp;
	local float expPer;

	ParseInt(a_Param, "Count", nCount);
	ParseInt(a_Param, "IsOpen", nIsOpen);
	ParseInt(a_Param, "CurrExp", nCurrExp);
	ParseInt(a_Param, "MaxExp", nMaxExp);
	MagicLampNum_Txt.SetText(("x" $ string(nCount)));
	MagicLampGaugeMax_Txt.ShowWindow();
	if(((nCount >= 99) && (nCurrExp >= nMaxExp)))
	{
		MagicLampGaugeMax_Txt.SetText("Max");
	}
	else
	{
		expPer = ((float(nCurrExp) / float(nMaxExp)) * 100.0000000);
		MagicLampGaugeMax_Txt.SetText(cutFloat(expPer));
	}
	MagicLampNum_StatusBar.SetPoint(INT64(nCurrExp), INT64(nMaxExp));
	if((nIsOpen == 1))
	{
		MagicLampHelp_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3939), 200));
		setWindowShowHide(MagicLampEventWnd, true);
	}
	else
	{
		setWindowShowHide(MagicLampEventWnd, false);
	}
	return;
}

function string cutFloat(float Probability)
{
	local string probabilityStr;
	local array<string> arrSplit;

	Split(string(Probability), ".", arrSplit);
	if((Probability >= 100.0000000))
	{
		probabilityStr = "100%";
	}
	else if((arrSplit.Length == 2))
	{
		if((Len(arrSplit[1]) >= 2))
		{
			probabilityStr = (((arrSplit[0] $ ".") $ Mid(arrSplit[1], 0, 2)) $ "%");
		}
		else
		{
			probabilityStr = (string(Probability) $ "%");
		}
	}
	else
	{
		probabilityStr = (string(Probability) $ "%");
	}
	return probabilityStr;
}

function HandleBloodyCoin(string param)
{
	local INT64 currentCoin;

	ParseINT64(param, "CoinCount", currentCoin);
	RefreshBCInfo(currentCoin);
	return;
}

function RefreshBCInfo(INT64 currentCoin)
{
	local Color TextColor;
	local string AddPointText;
	local INT64 coinAdded;
	local bool isFirstLoad;

	isFirstLoad = (bloodCoin == INT64(-1));
	coinAdded = (currentCoin - bloodCoin);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_BloodyCoinWndName $ ".PointTextBox"), MakeCostString(string(currentCoin)));
	bloodCoin = currentCoin;
	if(isFirstLoad)
	{
		return;
	}
	if((INT64(0) != coinAdded))
	{
		if((INT64(0) < coinAdded))
		{
			AddPointText = ("+" $ MakeCostString(string(coinAdded)));
			TextColor.R = 255;
			TextColor.G = 255;
			TextColor.B = 0;
			BloodCoinAddAnim.SetLoopCount(1);
			BloodCoinAddAnim.Play();
		}
		else if((INT64(0) > coinAdded))
		{
			AddPointText = MakeCostString(string(coinAdded));
			TextColor.R = 255;
			TextColor.G = 0;
			TextColor.B = 0;
		}
		else
		{
			return;
		}
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_BloodyCoinWndName $ ".PointAddTextBox"), AddPointText);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor((m_BloodyCoinWndName $ ".PointAddTextBox"), TextColor);
		Class'NWindow.UIAPI_WINDOW'.static.SetAnchor((m_BloodyCoinWndName $ ".PointAddTextBox"), m_BloodyCoinWndName, "TopRight", "TopRight", -5, 41);
		Class'NWindow.UIAPI_WINDOW'.static.ClearAnchor((m_BloodyCoinWndName $ ".PointAddTextBox"));
		Class'NWindow.UIAPI_WINDOW'.static.Move((m_BloodyCoinWndName $ ".PointAddTextBox"), -5, -18, 0.0000000);
		Class'NWindow.UIAPI_WINDOW'.static.Move((m_BloodyCoinWndName $ ".PointAddTextBox"), 0, -25, 0.3000000);
		Class'NWindow.UIAPI_WINDOW'.static.SetAlpha((m_BloodyCoinWndName $ ".PointAddTextBox"), 255);
		Class'NWindow.UIAPI_WINDOW'.static.SetAlpha((m_BloodyCoinWndName $ ".PointAddTextBox"), 0, 0.3000000);
		GetButtonHandle((m_BloodyCoinWndName $ ".BloodyCoinBtn")).SetAlpha(0);
		GetButtonHandle((m_BloodyCoinWndName $ ".BloodyCoinBtn")).SetAlpha(255, 0.4000000);
	}
	return;
}

function HandleToggleShowShopDailyWnd()
{
	if(((UseClassicLCoinShop == 1) || IsAdenServer()))
	{
		Debug("클래식 엘코인 상점");  // EN: Classic L-Coin Shop
		RequestOpenWndWithoutNPC(OPEN_LCOINSHOP_HTML);
	}
	else
	{
		Debug("라이브 블러디 상점");  // EN: Live Bloody Shop
		RequestOpenWndWithoutNPC(OPEN_PLSHOP_HTML);
	}
	return;
}

function HandleToggleShowPCCafeCommuniWnd()
{
	if(getInstanceL2Util().getIsPrologueGrowType())
	{
		AddSystemMessage(4533);
	}
	else
	{
		RequestOpenWndWithoutNPC(OPEN_PCCAFE_HTML);
	}
	return;
}

function HandlePCCafePointInfo(string a_Param)
{
	local int Show;
	local bool bOption;

	ParseInt(a_Param, "TotalPoint", m_TotalPoint);
	ParseInt(a_Param, "AddPoint", m_AddPoint);
	ParseInt(a_Param, "PeriodType", m_PeriodType);
	ParseInt(a_Param, "RemainTime", m_RemainTime);
	ParseInt(a_Param, "PointType", m_PointType);
	ParseInt(a_Param, "Show", Show);
	if(((Show > 0) && !m_bIsPCCafeEvent))
	{
		bOption = GetOptionBool("ScreenInfo", "IsPcRoomBox");
		if(!bOption)
		{
			setWindowShowHide(PCCafeEventWnd, true);
		}
		m_bIsPCCafeEvent = true;
	}
	RefreshPcCafeInfo(Show);
	return;
}

function bool IsPCCafeEventOpened()
{
	if((0 < m_PeriodType))
	{
		return true;
	}
	return false;
}

function RefreshPcCafeInfo(int nShow)
{
	local Color TextColor;
	local string AddPointText, FullPointText;

	if((nShow == 0))
	{
		setWindowShowHide(PCCafeEventWnd);
	}
	HelpButton.SetTooltipCustomType(getCustomToolTip(GetSystemString(2256)));
	FullPointText = MakeCostString(string(m_TotalPoint));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_PCCafeWndwName $ ".PointTextBox"), FullPointText);
	Class'NWindow.UIAPI_WINDOW'.static.SetAlpha((m_PCCafeWndwName $ ".PointAddTextBox"), 0);
	if(((0 != m_AddPoint) && (nShow != 0)))
	{
		if((0 < m_AddPoint))
		{
			AddPointText = ("+" $ MakeCostString(string(m_AddPoint)));
		}
		else
		{
			AddPointText = MakeCostString(string(m_AddPoint));
		}
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText((m_PCCafeWndwName $ ".PointAddTextBox"), AddPointText);
		switch(m_PointType)
		{
			case 0:
				TextColor.R = 255;
				TextColor.G = 255;
				TextColor.B = 0;
				break;
			case 1:
				TextColor.R = 0;
				TextColor.G = 255;
				TextColor.B = 255;
				break;
			case 2:
				TextColor.R = 255;
				TextColor.G = 0;
				TextColor.B = 0;
				break;
			default:
				break;
		}
		Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor((m_PCCafeWndwName $ ".PointAddTextBox"), TextColor);
		Class'NWindow.UIAPI_WINDOW'.static.SetAnchor((m_PCCafeWndwName $ ".PointAddTextBox"), m_PCCafeWndwName, "TopRight", "TopRight", -5, 41);
		Class'NWindow.UIAPI_WINDOW'.static.ClearAnchor((m_PCCafeWndwName $ ".PointAddTextBox"));
		Class'NWindow.UIAPI_WINDOW'.static.Move((m_PCCafeWndwName $ ".PointAddTextBox"), -5, -18, 0.0000000);
		Class'NWindow.UIAPI_WINDOW'.static.Move((m_PCCafeWndwName $ ".PointAddTextBox"), 0, -25, 0.3000000);
		Class'NWindow.UIAPI_WINDOW'.static.SetAlpha((m_PCCafeWndwName $ ".PointAddTextBox"), 255);
		Class'NWindow.UIAPI_WINDOW'.static.SetAlpha((m_PCCafeWndwName $ ".PointAddTextBox"), 0, 0.3000000);
		GetButtonHandle((m_PCCafeWndwName $ ".PCCafeBtn")).SetAlpha(0);
		GetButtonHandle((m_PCCafeWndwName $ ".PCCafeBtn")).SetAlpha(255, 0.4000000);
		m_AddPoint = 0;
	}
	return;
}

function string GetHelpButtonTooltipText()
{
	local string TooltipSystemMsg;

	if((1 == m_PeriodType))
	{
		TooltipSystemMsg = GetSystemMessage(1705);
	}
	else if((2 == m_PeriodType))
	{
		TooltipSystemMsg = GetSystemMessage(1706);
	}
	else
	{
		return "";
	}
	return MakeFullSystemMsg(TooltipSystemMsg, string(m_RemainTime), "");
}

function HandleToggleShowPCCafeEventWnd(optional bool bIsForceSet, optional bool bIsHide)
{
	if(bIsForceSet)
	{
		SetOptionValue(bIsHide);
		setWindowShowHide(PCCafeEventWnd, (!bIsHide && IsPCCafeEvent()));
		return;
	}
	if(PCCafeEventWnd.IsShowWindow())
	{
		setWindowShowHide(PCCafeEventWnd);
	}
	else if(IsPCCafeEvent())
	{
		setWindowShowHide(PCCafeEventWnd, true);
	}
	return;
}

function bool IsPCCafeEvent()
{
	if((m_bIsPCCafeEvent && bIsOptionValue))
	{
		return false;
	}
	return m_bIsPCCafeEvent;
}

function CuriousHouseHandle(string a_Param)
{
	local int HouseState;

	ParseInt(a_Param, "State", HouseState);
	switch(HouseState)
	{
		case 0:
		case 1:
			setWindowShowHide(MysteriousMansionWaitingWnd, false);
			break;
		case 2:
			AddSystemMessage(3732);
			MCancelButton.EnableWindow();
			setWindowShowHide(MysteriousMansionWaitingWnd, true);
			Me.SetFocus();
			break;
		case 3:
			MCancelButton.DisableWindow();
			break;
		default:
			break;
	}
	return;
}

function handleOnGamingStateEnter()
{
	local int useToppingType;
	local bool bOption;

	bOption = GetOptionBool("ScreenInfo", "IsPcRoomBox");
	if(bOption)
	{
		setWindowShowHide(PCCafeEventWnd);
	}
	else
	{
		setWindowShowHide(PCCafeEventWnd, bIsShowBackup);
	}
	if(!GetINIBool("L2UI", "UseTopping", useToppingType, "L2.ini"))
	{
		useToppingType = 0;
	}
	if((useToppingType == 1))
	{
		getToppingDefault();
	}
	setWindowShowHide(ToppingWnd, false);
	setWindowShowHide(MysteriousMansionWaitingWnd);
	setWindowShowHide(CostumeEventWnd);
	if(IsBloodyServer())
	{
		HelpBCButton.SetTooltipCustomType(getCustomToolTip(GetSystemString(3920)));
		BloodyCoin_shopIcon.SetTexture("L2UI_ct1.Icon.BloodyCoin_shopIcon");
		BloodCoinTitleTextBox.SetText(GetSystemString(3915));
	}
	else if(((UseClassicLCoinShop == 1) || IsAdenServer()))
	{
		HelpBCButton.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3933), 200));
		BloodyCoin_shopIcon.SetTexture("L2UI_ct1.Icon.LCoin_shopIcon");
		BloodCoinTitleTextBox.SetText(GetSystemString(3931));
	}
	return;
}

function OnEnterState(name a_CurrentStateName)
{
	local int nShow;
	local bool bShowCoinShop;

	return;
	isAfterStatusNormaEvent = false;
	if(IsAdenServer())
	{
		setWindowShowHide(VPWnd, true);
	}
	else
	{
		setWindowShowHide(VPWnd, false);
	}
	if((((UseClassicLCoinShop == 1) || IsBloodyServer()) || IsAdenServer()))
	{
		bShowCoinShop = true;
		setWindowShowHide(BloodyCoinWnd, bShowCoinShop);
	}
	else
	{
		setWindowShowHide(BloodyCoinWnd, bShowCoinShop);
	}
	if(IsPCCafeEvent())
	{
		nShow = 1;
	}
	else
	{
		nShow = 0;
	}
	RefreshPcCafeInfo(nShow);
	isEnterState = true;
	checkNShowWindow();
	Me.ShowWindow();
	return;
}

function checkNShowWindow()
{
	local int bIsClassicShow;

	if(!GetINIBool("PrimeShop", "UseClassicPrimeShop", bIsClassicShow, "L2.ini"))
	{
		bIsClassicShow = 0;
	}
	if(((bIsClassicShow == 1) && getInstanceUIData().GetIsClassicServer()))
	{
		if(IsAdenServer())
		{
			setWindowShowHide(IngamePrimeShopWnd, false);
			setWindowShowHide(IngameVIPWnd, false);
		}
		else
		{
			setWindowShowHide(IngamePrimeShopWnd, true);
			setWindowShowHide(IngameVIPWnd, true);
		}
	}
	else
	{
		setWindowShowHide(IngamePrimeShopWnd, false);
		setWindowShowHide(IngameVIPWnd, false);
	}
	return;
}

function OnExitState(name a_CurrentStateName)
{
	RefreshPcCafeInfo(0);
	isEnterState = false;
	Me.HideWindow();
	return;
}

function OnShow()
{
	if(!isShowInfoWnd)
	{
		Me.HideWindow();
	}
	return;
}

function OnHide()
{
	nCostumeShortCutNum = 0;
	return;
}

function CustomTooltip getCustomToolTip(string Text)
{
	local CustomTooltip ToolTip;
	local DrawItemInfo Info;

	ToolTip.MinimumWidth = 144;
	ToolTip.DrawList.Length = 1;
	Info.eType = DIT_TEXT;
	Info.t_bDrawOneLine = true;
	Info.t_color.R = 178;
	Info.t_color.G = 190;
	Info.t_color.B = 207;
	Info.t_color.A = 255;
	Info.t_strText = Text;
	ToolTip.DrawList[0] = Info;
	return ToolTip;
}

function setWindowShowHide(WindowHandle tmpWnd, optional bool isShow)
{
	local int nWndWidth, nWndHeight, i, nWndHMax;
	local Rect rectWnd;

	if((isShow == tmpWnd.IsShowWindow()))
	{
		return;
	}
	if(isShow)
	{
		tmpWnd.ShowWindow();
	}
	else
	{
		tmpWnd.HideWindow();
	}
	rectWnd = Me.GetRect();
	isShowInfoWnd = false;
	i = 0;
	while((i < allWindow.Length))
	{
		if(allWindow[i].IsShowWindow())
		{
			allWindow[i].GetWindowSize(nWndWidth, nWndHeight);
			allWindow[i].MoveTo(rectWnd.nX, (rectWnd.nY + nWndHMax));
			nWndHMax = (nWndHMax + nWndHeight);
			isShowInfoWnd = true;
		}
		i++;
	}
	Me.SetWindowSize(rectWnd.nWidth, (nWndHMax + 2));
	windowBackground.SetWindowSize(rectWnd.nWidth, (nWndHMax + 2));
	if((isShowInfoWnd && isEnterState))
	{
		Me.ShowWindow();
	}
	else
	{
		Me.HideWindow();
	}
	return;
}

function SetOptionValue(bool bValue)
{
	bIsOptionValue = bValue;
	return;
}

function string GetEllipsisString(string Str, int MaxWidth)
{
	local string fixedString;
	local int nWidth, nHeight, textWidth;

	textWidth = MaxWidth;
	GetTextSizeDefault((Str $ "..."), nWidth, nHeight);
	if((nWidth < textWidth))
	{
		return Str;
	}
	fixedString = DivideStringWithWidth(Str, textWidth);
	if((fixedString != Str))
	{
		fixedString = (fixedString $ "...");
	}
	return fixedString;
}

defaultproperties
{
	m_ToppingWndName="InfoWnd.ToppingWnd"
	m_VPWndName="InfoWnd.VPWnd"
	m_PCCafeWndwName="InfoWnd.PCCafeEventWnd"
	m_MysteriousMansionWaitingWndName="InfoWnd.MysteriousMansionWaitingWnd"
	m_ElementalExpViewerWndName="InfoWnd.ElementalWnd"
	m_BloodyCoinWndName="InfoWnd.BloodyCoinWnd"
	m_CostumeEventWndName="InfoWnd.CostumeEventWnd"
	m_IngamePrimeShopWnd="InfoWnd.IngamePrimeShopWnd"
	m_IngameVIPWnd="InfoWnd.IngameVIPWnd"
	m_MagicLampWndName="InfoWnd.MagicLampEventWnd"
	m_RandomCraftInfoWndName="InfoWnd.RandomCraftInfoWnd"
	m_Windowname="InfoWnd"
}
