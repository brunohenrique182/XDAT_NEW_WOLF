class SkyTowerEnterWnd extends UICommonAPI
	dependson(UIPacket);

var WindowHandle Me;
var WindowHandle UIControlDialogAsset;
var ButtonHandle RewardInfo_btn;
var ButtonHandle Teleport_Btn;
var UIPacket._S_EX_SERVERWAR_FIELD_ENTER_USER_INFO fieldEnterPacket;
var array<L2ItemAmount> rewardItem;
var array<int> rankingRewardProb;
var int minPoint;
var int nCurrentFieldID;

static function SkyTowerEnterWnd Inst()
{
	return SkyTowerEnterWnd(GetScript("SkyTowerEnterWnd"));
}

function OnRegisterEvent()
{
	RegisterEvent((100000 + 1123));
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	SetPopupScript();
	Class'NWindow.UIDataManager'.static.GetServerWarData(minPoint, rewardItem, rankingRewardProb);
	return;
}

function OnShow()
{
	SetTooltipReward();
	Me.SetFocus();
	return;
}

function OnHide()
{
	if(GetMeWindow("UIControlDialogAsset").IsShowWindow())
	{
		GetPopupExpandScript().Hide();
	}
	return;
}

function Initialize()
{
	Me = GetWindowHandle("SkyTowerEnterWnd");
	UIControlDialogAsset = GetWindowHandle("SkyTowerEnterWnd.UIControlDialogAsset");
	RewardInfo_btn = GetButtonHandle("SkyTowerEnterWnd.RewardInfo_btn");
	Teleport_Btn = GetButtonHandle("SkyTowerEnterWnd.Teleport_btn");
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Teleport_btn":
			OnTeleport_btnClick();
			break;
		default:
			break;
	}
	return;
}

function OnTeleport_btnClick()
{
	ShowPopup();
	return;
}

function SetTooltipReward()
{
	local CustomTooltip mCustomTooltip;
	local array<DrawItemInfo> drawListArr;
	local ItemInfo Info;
	local int i;

	drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(14518), getInstanceL2Util().BrightWhite, "hs11", true, false);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	drawListArr[drawListArr.Length] = AddCrossLineForCustomToolTip(130);
	drawListArr[drawListArr.Length] = addDrawItemBlank(4);
	i = 0;
	while((i < rewardItem.Length))
	{
		Info = GetItemInfoByClassID(rewardItem[i].ItemClassID);
		Info.ItemNum = INT64(rewardItem[i].ItemAmount);
		addDrawItemGameItem(drawListArr, Info, true, GTColor().Yellow);
		i++;
	}
	mCustomTooltip = MakeTooltipMultiTextByArray(drawListArr);
	RewardInfo_btn.SetTooltipType("text");
	RewardInfo_btn.SetTooltipCustomType(mCustomTooltip);
	return;
}

function SetPopupScript()
{
	local WindowHandle popExpandWnd;
	local UIControlDialogAssets popupExpandScript;
	local TextureHandle disableWnd;

	popExpandWnd = GetMeWindow("UIControlDialogAsset");
	popupExpandScript = Class'Interface.UIControlDialogAssets'.static.InitScript(popExpandWnd);
	disableWnd = GetMeTexture("disable_tex");
	popupExpandScript.SetDisableWindow(disableWnd);
	Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop((m_hOwnerWnd.m_WindowNameWithFullPath $ ".disable_tex"), false);
	return;
}

function UIControlDialogAssets GetPopupExpandScript()
{
	local WindowHandle popExpandWnd;

	popExpandWnd = GetMeWindow("UIControlDialogAsset");
	return UIControlDialogAssets(popExpandWnd.GetScript());
}

function ShowPopup()
{
	local UIControlDialogAssets popupExpandScript;
	local TimeRestrictFieldUIData fieldUIData;
	local int i;

	popupExpandScript = GetPopupExpandScript();
	GetTimeRestrictFieldInfo(fieldEnterPacket.nFieldID, fieldUIData);
	popupExpandScript.SetDialogDesc(((((MakeFullSystemMsg(GetSystemMessage(13009), fieldUIData.FieldName) $ "\\n\\n") $ GetSystemString(14170)) $ "\\n\\n") $ GetSystemString(14171)));
	if((fieldEnterPacket.lstRequiredItems.Length > 0))
	{
		popupExpandScript.SetUseNeedItem(true);
		popupExpandScript.StartNeedItemList(fieldEnterPacket.lstRequiredItems.Length);
		i = 0;
		while((i < fieldEnterPacket.lstRequiredItems.Length))
		{
			popupExpandScript.AddNeedItemClassID(fieldEnterPacket.lstRequiredItems[i].nItemClassID, fieldEnterPacket.lstRequiredItems[i].nItemAmount);
			i++;
		}
		popupExpandScript.SetItemNum(1);
	}
	else
	{
		popupExpandScript.OKButton.EnableWindow();
	}
	popupExpandScript.Show();
	popupExpandScript.DelegateOnClickBuy = OnDialogOK;
	popupExpandScript.DelegateOnCancel = OnClickCancelDialog;
	showDisable(true);
	return;
}

function OnDialogOK()
{
	if(IsPlayerOnWorldRaidServer())
	{
		API_C_EX_TIME_RESTRICT_FIELD_HOST_USER_LEAVE(NoticeHUD(GetScript("NoticeHud")).getTimeZoneCurrentFieldID(), Class'Interface.NoticeHUD'.static.Inst().skyTowerFieldID);
	}
	else
	{
		Class'Interface.SkyTowerWnd'.static.Inst().API_C_EX_SERVERWAR_MOVE_TO_HOST(Class'Interface.NoticeHUD'.static.Inst().skyTowerFieldID);
	}
	GetPopupExpandScript().Hide();
	showDisable(false);
	Me.HideWindow();
	return;
}

function OnClickCancelDialog()
{
	GetPopupExpandScript().Hide();
	showDisable(false);
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case (100000 + 1123):
			ParsePacket_S_EX_SERVERWAR_FIELD_ENTER_USER_INFO();
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_SERVERWAR_FIELD_ENTER_USER_INFO()
{
	if(!Class'Interface.UIPacket'.static.Decode_S_EX_SERVERWAR_FIELD_ENTER_USER_INFO(fieldEnterPacket))
	{
		return;
	}
	Debug(((("---> S_EX_SERVERWAR_FIELD_ENTER_USER_INFO" @ string(fieldEnterPacket.nFieldID)) @ string(fieldEnterPacket.lstRequiredItems.Length)) @ string(fieldEnterPacket.nRemainTime)));
	Me.ShowWindow();
	Me.SetFocus();
	if((IsPlayerOnWorldRaidServer() && (fieldEnterPacket.nFieldID == NoticeHUD(GetScript("NoticeHud")).getTimeZoneCurrentFieldID())))
	{
		Teleport_Btn.DisableWindow();
	}
	else
	{
		Teleport_Btn.EnableWindow();
	}
	return;
}

function setDisableTeleportBtn()
{
	Teleport_Btn.DisableWindow();
	return;
}

function API_C_EX_SERVERWAR_FIELD_ENTER_USER_INFO(int nFieldID)
{
	local array<byte> stream;
	local UIPacket._C_EX_SERVERWAR_FIELD_ENTER_USER_INFO packet;

	packet.nFieldID = nFieldID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_SERVERWAR_FIELD_ENTER_USER_INFO(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(864, stream);
	Debug(("Api Call -----> C_EX_SERVERWAR_FIELD_ENTER_USER_INFO" @ string(packet.nFieldID)));
	return;
}

function API_C_EX_TIME_RESTRICT_FIELD_HOST_USER_LEAVE(int nLeaveFieldID, int nNextEnterFieldID)
{
	local array<byte> stream;
	local UIPacket._C_EX_TIME_RESTRICT_FIELD_HOST_USER_LEAVE packet;

	packet.nLeaveFieldID = nLeaveFieldID;
	packet.nNextEnterFieldID = nNextEnterFieldID;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_TIME_RESTRICT_FIELD_HOST_USER_LEAVE(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(837, stream);
	Debug((("API C_EX_TIME_RESTRICT_FIELD_HOST_USER_LEAVE :" @ string(nLeaveFieldID)) @ string(nNextEnterFieldID)));
	return;
}

function showDisable(bool bShow)
{
	if(bShow)
	{
		GetMeTexture("disable_tex").ShowWindow();
		GetMeTexture("disable_tex").SetFocus();
	}
	else
	{
		GetMeTexture("disable_tex").HideWindow();
	}
	return;
}

function OnReceivedCloseUI()
{
	CloseUI();
	return;
}
