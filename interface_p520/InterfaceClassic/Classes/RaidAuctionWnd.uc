class RaidAuctionWnd extends UICommonAPI
	dependson(UIPacket);

const MAX_COUNT = 15;
const MIN_INPUT_VALUE = 10000;
const PLUS_VALUE0 = 1000000;
const PLUS_VALUE1 = 10000000;

var HtmlHandle numText_Html;
var TextBoxHandle Time_Txt;
var ItemWindowHandle Item_ItemWnd;
var AnimTextureHandle ItemSlot_Ani;
var TextBoxHandle ItemName_Txt;
var StatusRoundHandle CoolTimeStatus;
var UIControlTextInput uicontrolTextInputScr;
var ButtonHandle plusBtn0;
var ButtonHandle plusBtn1;
var ButtonHandle Bid_Btn;
var ButtonHandle GiveUp_Btn;
var HtmlHandle DscText_Html;
var TextureHandle BidBg_Tex;
var ButtonHandle CancelBid_Btn;
var int orderCurrent;
var int orderMax;
var L2UITweenRotateObject rotateTObject;
var L2UITimerObject tObject;
var L2UITimerObject tObjectEnd;
var L2UITweenObject TweenObject;
var float clientAppSec;
var bool bEndResultState;
var int CurrentID;

function Initialize()
{
	rotateTObject = Class'InterfaceClassic.L2UITween'.static.Inst()._AddTweenRotate(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CircleEffect_Btn")), 9, 360.0000000, 80000.0000000, 0.0000000, true);
	rotateTObject._Pause();
	numText_Html = GetHtmlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".NumText_Html"));
	Time_Txt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".time_txt"));
	Item_ItemWnd = GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Item_ItemWnd"));
	ItemSlot_Ani = GetAnimTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemSlot_Ani"));
	ItemSlot_Ani.SetLoopCount(1);
	ItemName_Txt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".ItemName_Txt"));
	CoolTimeStatus = GetStatusRoundHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CoolTimeStatus"));
	Bid_Btn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Bid_Btn"));
	GiveUp_Btn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".GiveUp_Btn"));
	DscText_Html = GetHtmlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DscText_Html"));
	BidBg_Tex = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".BidBg_Tex"));
	CancelBid_Btn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CancelBid_Btn"));
	return;
}

function InitPlusBtns()
{
	local string costString;

	plusBtn0 = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".plusBtn0"));
	plusBtn1 = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".plusBtn1"));
	costString = MakeCostStringINT64(INT64(1000000));
	plusBtn0.SetDefaultTextEnableColor(GetNumericColor(costString));
	plusBtn0.SetNameText(("+" $ costString));
	costString = MakeCostStringINT64(INT64(10000000));
	plusBtn1.SetDefaultTextEnableColor(GetNumericColor(costString));
	plusBtn1.SetNameText(("+" $ costString));
	return;
}

function InitStatusRound()
{
	tObject = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(1, -1);
	tObject._DelegateOnStart = HandleDelegateOnStart;
	tObject._DelegateOnTime = HandleDelegateOnTime;
	tObject._Stop();
	tObjectEnd = Class'InterfaceClassic.L2UITimer'.static.Inst()._MakeTimerObject(5000, 1);
	tObjectEnd._DelegateOnEnd = HandleDelegateOnEnd;
	tObjectEnd._Stop();
	return;
}

function HandleDelegateOnEnd()
{
	m_hOwnerWnd.HideWindow();
	return;
}

function HandleDelegateOnStart()
{
	clientAppSec = GetAppSeconds();
	Time_Txt.SetText(string(15));
	CoolTimeStatus.SetPoint(INT64(0), INT64(15));
	return;
}

function HandleDelegateOnTime(int C)
{
	local float DeltaTime;

	DeltaTime = (GetAppSeconds() - clientAppSec);
	if((DeltaTime >= 15.0000000))
	{
		tObject._Pause();
		DeltaTime = 15.0000000;
	}
	Time_Txt.SetText(string((15 - int(DeltaTime))));
	CoolTimeStatus.SetPoint(INT64(int((DeltaTime * 1000.0000000))), INT64((15 * 1000)));
	return;
}

function InitInputTexInput()
{
	uicontrolTextInputScr = Class'InterfaceClassic.UIControlTextInput'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Input_TextBox")));
	uicontrolTextInputScr._Show();
	uicontrolTextInputScr._SetAlign(TA_Right);
	uicontrolTextInputScr.SetEdtiable(true);
	uicontrolTextInputScr._SetEditType("number");
	uicontrolTextInputScr._UseNumericColor(true);
	uicontrolTextInputScr._UseCostString(true);
	uicontrolTextInputScr.SetDefaultString((((GetSystemString(13267) $ ":") @ MakeCostStringINT64(INT64(10000))) $ "  "));
	uicontrolTextInputScr._SetUseDefaultStringWithFocus(true);
	uicontrolTextInputScr._SetDefaultAlign(TA_Right);
	uicontrolTextInputScr._SetDefaultFontColor(GetColor(153, 153, 153, 255));
	uicontrolTextInputScr.DelegateOnChangeEdited = HandleDelegateOnChangeEdited;
	uicontrolTextInputScr.DelegateOnClear = HandleDelegateOnClear;
	return;
}

function HandleDelegateOnChangeEdited(string Text)
{
	CheckPlusBtnsEnable();
	return;
}

function HandleDelegateOnClear()
{
	CheckPlusBtnsEnable();
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(16);
	RegisterEvent(17);
	RegisterEvent(4917);
	RegisterEvent(4913);
	RegisterEvent(4916);
	RegisterEvent(EV_PacketID(1193));
	RegisterEvent(EV_PacketID(1194));
	RegisterEvent(1370);
	return;
}

event OnEvent(int Id, string param)
{
	switch(Id)
	{
		case EV_PacketID(1193):
			Rt_S_EX_RAID_AUCTION_BID_INFO();
			break;
		case EV_PacketID(1194):
			Rt_S_EX_RAID_AUCTION_RESULT();
			break;
		case 16:
			HandleTest();
			break;
		case 17:
			m_hOwnerWnd.HideWindow();
			break;
		case 4917:
		case 4913:
		case 4916:
		case 1370:
			HandlePartyDeleteAllParty();
			break;
		default:
			break;
	}
	return;
}

event OnLoad()
{
	Initialize();
	InitInputTexInput();
	InitPlusBtns();
	InitStatusRound();
	InitTweenObject();
	return;
}

event OnClickButton(string strID)
{
	switch(strID)
	{
		case "Bid_Btn":
			HandleCLickBid_Btn();
			break;
		case "GiveUp_Btn":
			HandleCLickGiveUp_Btn();
			break;
		case "plusBtn0":
			HandlePlusByBtn(INT64(1000000));
			break;
		case "plusBtn1":
			HandlePlusByBtn(INT64(10000000));
			break;
		case "CancelBid_Btn":
			HandleCLickCancelBid_Btn();
			break;
		default:
			break;
	}
	return;
}

event OnShow()
{
	m_hOwnerWnd.SetAlpha(0);
	m_hOwnerWnd.SetAlpha(255, 0.1500000);
	rotateTObject._Play();
	GetEffectViewportWndHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".itemSlotViewport")).SpawnEffect("LineageEffect2.ui_yellow_smoke");
	GetEffectViewportWndHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".OnShowViewport")).SpawnEffect("LineageEffect2.ui_relic_card_normal");
	return;
}

event OnHide()
{
	tObjectEnd._Stop();
	rotateTObject._Pause();
	GetEffectViewportWndHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".itemSlotViewport")).SpawnEffect("");
	bEndResultState = false;
	return;
}

event OnTextureAnimEnd(AnimTextureHandle a_WindowHandle)
{
	a_WindowHandle.HideWindow();
	return;
}

function HandlePartyDeleteAllParty()
{
	if((m_hOwnerWnd.IsShowWindow() == false))
	{
		return;
	}
	if(bEndResultState)
	{
		return;
	}
	m_hOwnerWnd.HideWindow();
	AddSystemMessage(14612);
	return;
}

function Set_Init(int nOrder, int nMaxNum, int nClassID, optional INT64 ItemNum)
{
	local ItemInfo iInfo;

	bEndResultState = false;
	ItemSlot_Ani.Stop();
	ItemSlot_Ani.ShowWindow();
	ItemSlot_Ani.Play();
	tObjectEnd._Stop();
	tObject._Reset();
	orderCurrent = (nOrder + 1);
	orderMax = nMaxNum;
	numText_Html.LoadHtmlFromString(GetOrderHtmlString());
	LoadHtmlTable("");
	Time_Txt.ShowWindow();
	CoolTimeStatus.ShowWindow();
	Item_ItemWnd.Clear();
	iInfo = GetItemInfoByClassID(nClassID);
	if((ItemNum == INT64(0)))
	{
		ItemNum = INT64(1);
	}
	iInfo.ItemNum = ItemNum;
	iInfo.bShowCount = (ItemNum > INT64(1));
	Item_ItemWnd.AddItem(iInfo);
	ItemName_Txt.SetText(GetItemNameAll(iInfo));
	Bid_Btn.ShowWindow();
	GiveUp_Btn.ShowWindow();
	CancelBid_Btn.HideWindow();
	BidBg_Tex.HideWindow();
	m_hOwnerWnd.ShowWindow();
	m_hOwnerWnd.SetFocus();
	uicontrolTextInputScr.Clear();
	if((APi_GetAdena() > INT64(0)))
	{
		Bid_Btn.EnableWindow();
		uicontrolTextInputScr._SetLimitNum(APi_GetAdena());
		uicontrolTextInputScr.SetDisable(false);
		uicontrolTextInputScr.SetEdtiable(true);
		uicontrolTextInputScr.Focus();
	}
	else
	{
		Bid_Btn.DisableWindow();
		uicontrolTextInputScr.SetDisable(true);
	}
	CheckPlusBtnsEnable();
	return;
}

function Set_Result(string sName, bool bSuccess)
{
	local UserInfo uInfo;
	local bool bWinnerIsMe;

	plusBtn0.DisableWindow();
	plusBtn1.DisableWindow();
	Bid_Btn.HideWindow();
	GiveUp_Btn.HideWindow();
	CancelBid_Btn.HideWindow();
	uicontrolTextInputScr.SetDisable(true);
	if(GetPlayerInfo(uInfo))
	{
		bWinnerIsMe = (uInfo.Name == sName);
	}
	BidBg_Tex.SetAlpha(0);
	if((bSuccess == false))
	{
		getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(14621), sName));
		LoadHtmlTable(MakeFullSystemMsg(GetSystemMessage(14619), sName));
	}
	else
	{
		getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(14618), sName));
		if(bWinnerIsMe)
		{
			BidBg_Tex.ShowWindow();
			BidBg_Tex.SetAlpha(0);
			BidBg_Tex.SetAlpha(255, 0.1000000);
			LoadHtmlTable(GetSystemString(14918));
		}
		else
		{
			LoadHtmlTable(MakeFullSystemMsg(GetSystemMessage(14604), sName));
		}
	}
	bEndResultState = (orderCurrent == orderMax);
	if(bEndResultState)
	{
		tObjectEnd._Reset();
	}
	return;
}

function Set_Aucction_Giveup()
{
	Bid_Btn.HideWindow();
	GiveUp_Btn.HideWindow();
	CancelBid_Btn.HideWindow();
	uicontrolTextInputScr.SetEdtiable(false);
	LoadHtmlTable(GetSystemString(14902));
	plusBtn0.DisableWindow();
	plusBtn1.DisableWindow();
	return;
}

function Set_AUCTION_REGISTER()
{
	Bid_Btn.HideWindow();
	GiveUp_Btn.HideWindow();
	CancelBid_Btn.ShowWindow();
	uicontrolTextInputScr.SetEdtiable(false);
	LoadHtmlTable("");
	plusBtn0.DisableWindow();
	plusBtn1.DisableWindow();
	AddSystemMessage(14615);
	return;
}

function Set_AUCTION_CANCEL()
{
	Bid_Btn.ShowWindow();
	GiveUp_Btn.ShowWindow();
	CancelBid_Btn.HideWindow();
	LoadHtmlTable("");
	uicontrolTextInputScr.Clear();
	uicontrolTextInputScr.SetEdtiable(true);
	uicontrolTextInputScr.Focus();
	plusBtn0.EnableWindow();
	plusBtn1.EnableWindow();
	return;
}

function HandleTest()
{
	Set_Init(88, 99, 57);
	return;
}

function HandleCLickCancelBid_Btn()
{
	Set_AUCTION_CANCEL();
	RQ_C_EX_RAID_AUCTION_CANCEL_BID();
	return;
}

function HandleCLickBid_Btn()
{
	if((INT64(uicontrolTextInputScr.GetString()) < INT64(10000)))
	{
		getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(14613), MakeCostStringINT64(INT64(10000))));
		return;
	}
	Set_AUCTION_REGISTER();
	RQ_C_EX_RAID_AUCTION_REGISTER(INT64(uicontrolTextInputScr.GetString()));
	return;
}

function HandleCLickGiveUp_Btn()
{
	Set_Aucction_Giveup();
	RQ_C_EX_RAID_AUCTION_REGISTER(INT64(0));
	return;
}

function HandlePlusByBtn(INT64 Num)
{
	local INT64 CurrentValue, adenaTotal, inputValue;

	adenaTotal = APi_GetAdena();
	CurrentValue = INT64(uicontrolTextInputScr.GetString());
	inputValue = Min64((CurrentValue + Num), adenaTotal);
	uicontrolTextInputScr.SetString(MakeCostStringINT64(inputValue));
	return;
}

function CheckPlusBtnsEnable()
{
	local INT64 CurrentValue, adenaTotal;

	adenaTotal = APi_GetAdena();
	CurrentValue = INT64(uicontrolTextInputScr.GetString());
	if((CurrentValue >= adenaTotal))
	{
		plusBtn0.DisableWindow();
		plusBtn1.DisableWindow();
	}
	else
	{
		plusBtn0.EnableWindow();
		plusBtn1.EnableWindow();
	}
	return;
}

function RQ_C_EX_RAID_AUCTION_CANCEL_BID()
{
	local array<byte> stream;
	local UIPacket._C_EX_RAID_AUCTION_CANCEL_BID packet;

	packet.nOrder = (orderCurrent - 1);
	packet.nID = CurrentID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_RAID_AUCTION_CANCEL_BID(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(917, stream);
	return;
}

function RQ_C_EX_RAID_AUCTION_REGISTER(INT64 Amount)
{
	local array<byte> stream;
	local UIPacket._C_EX_RAID_AUCTION_BID packet;

	packet.nOrder = (orderCurrent - 1);
	packet.nAmount = Amount;
	packet.nID = CurrentID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_RAID_AUCTION_BID(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(916, stream);
	return;
}

function Rt_S_EX_RAID_AUCTION_BID_INFO()
{
	local UIPacket._S_EX_RAID_AUCTION_BID_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_RAID_AUCTION_BID_INFO(packet))
	{
		return;
	}
	CurrentID = packet.nID;
	Set_Init(packet.nOrder, packet.nMaxNum, packet.nClassID, packet.nAmount);
	return;
}

function Rt_S_EX_RAID_AUCTION_RESULT()
{
	local UIPacket._S_EX_RAID_AUCTION_RESULT packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_RAID_AUCTION_RESULT(packet))
	{
		return;
	}
	Time_Txt.HideWindow();
	CoolTimeStatus.HideWindow();
	Debug(((("Rt_S_EX_RAID_AUCTION_RESULT" @ string(packet.nOrder)) @ string(packet.bSuccess)) @ packet.sName));
	Set_Result(packet.sName, bool(packet.bSuccess));
	return;
}

function TwinkleHtmlText()
{
	Class'InterfaceClassic.L2UITween'.static.Inst()._AddTweenTwinlkle(DscText_Html, 2.0000000, 0.5000000, 500.0000000);
	return;
}

function ShakeHtmlText()
{
	DscText_Html.ClearAnchor();
	Class'InterfaceClassic.L2UITween'.static.Inst().StartShake(DscText_Html.m_WindowNameWithFullPath, 4, 500, small, 0, 1010101);
	return;
}

function InitTweenObject()
{
	TweenObject = new Class'InterfaceClassic.L2UITweenObject';
	TweenObject._DelegateOnEnd = HandleTweenDelegateOnEnd;
	TweenObject._DelegateOnStart = HandleTweenDelegateOnStart;
	TweenObject.Owner = m_hOwnerWnd.m_WindowNameWithFullPath;
	TweenObject.Id = 0;
	TweenObject.Target = DscText_Html;
	TweenObject.Duration = 500.0000000;
	TweenObject.Alpha = 255.0000000;
	TweenObject.MoveY = -5.0000000;
	TweenObject.ease = OUT_STRONG;
	return;
}

function TweenMoveHtmlText()
{
	TweenObject._Reset();
	return;
}

function HandleTweenDelegateOnStart(L2UITweenObject tweenObj)
{
	DscText_Html.SetAnchor(m_hOwnerWnd.m_WindowNameWithFullPath, "BottomCenter", "CenterCenter", 0, -80);
	DscText_Html.ClearAnchor();
	DscText_Html.SetAlpha(0);
	return;
}

function HandleTweenDelegateOnEnd(L2UITweenObject tweenObj)
{
	DscText_Html.SetAnchor(m_hOwnerWnd.m_WindowNameWithFullPath, "BottomCenter", "CenterCenter", 0, -85);
	return;
}

function INT64 APi_GetAdena()
{
	return GetAdena();
}

function string GetOrderHtmlString()
{
	local string htmlStr;

	htmlStr = htmlAddText(string(orderCurrent), "hs18", getColorHexString(GetColor(255, 221, 102, 255)));
	htmlStr = (htmlStr $ htmlAddText(("/" $ string(orderMax)), "hs12"));
	htmlStr = HtmlAddTableTD(htmlStr, "center", "center", 200, 0, "", true);
	HtmlSetTableTR(htmlStr);
	htmlSetTable(htmlStr, 0, 200, 0, "", 0, 0);
	htmlStr = htmlSetHtmlStart(htmlStr);
	return htmlStr;
}

function LoadHtmlTable(string strMessage)
{
	local string htmlStr;
	local int nHeight;

	if((strMessage == ""))
	{
		DscText_Html.HideWindow();
		return;
	}
	else
	{
		DscText_Html.ShowWindow();
	}
	htmlStr = HtmlAddTableTD(strMessage, "center", "center", 200, 0, "", true);
	HtmlSetTableTR(htmlStr);
	htmlSetTable(htmlStr, 0, 200, 0, "", 0, 0);
	DscText_Html.LoadHtmlFromString(htmlSetHtmlStart(htmlStr));
	nHeight = DscText_Html.GetFrameMaxHeight();
	DscText_Html.SetWindowSize(200, nHeight);
	TweenMoveHtmlText();
	return;
}
