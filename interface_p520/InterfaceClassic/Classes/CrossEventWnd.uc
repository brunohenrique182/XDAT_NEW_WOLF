class CrossEventWnd extends UICommonAPI
	dependson(UIPacket);

const BOARD_SIZE = 4;
const STAMP_EFFECT_TIME = 800;
const STAMP_EFFECT_TIMER_ID = 1;
const BUTTON_DELAY_TIME = 1000;
const BUTTON_DELAY_TIMER_ID = 2;
const LEFT_TIME_DELAY_TIME = 60000;
const LEFT_TIME_TIMER_ID = 3;
const CROSS_EFFFECT_PATH = "LineageEffect_br.b_ui_cross_line";
const SEASON_TEX_PATH_TOP = "L2UI_NewTex.CrossEventWnd.CrossAdvenced_SeasonBg_";
const SEASON_TEX_PATH_BOTTOM = "L2UI_NewTex.CrossEventWnd.CrossSlot_SeasonBg_";


struct CrossEventSlot
{
	var CrossEventSlotInfo Info;
	var CrossEventWndSlot slotObject;
};

struct CrossEventUIInfo
{
	var bool isOn;
	var int season;
	var UIPacket._ItemInfo resetItemInfo;
	var array<UIPacket._ItemInfo> normalRewards;
	var array<UIPacket._ItemInfo> rareRewards;
	var int couponNum;
	var int rareRewardCnt;
	var int remainResetCnt;
	var int MaxResetCnt;
	var int getRareItemId;
	var array<int> rowChecked;
	var array<int> columnChecked;
	var bool isWaitingResponse;
	var INT64 RemainTime;
};

var WindowHandle Me;
var ButtonHandle normalRewardBtn;
var ButtonHandle rareRewardBtn;
var ButtonHandle rewardListBtn;
var ButtonHandle resetBtn;
var TextBoxHandle normalRemainTextBox;
var TextBoxHandle rareRemainTextBox;
var TextBoxHandle leftTimeTextBox;
var ItemWindowHandle rareRewardItemWnd;
var UIControlDialogAssets dialogAsset;
var TextureHandle seasonTopTex;
var TextureHandle seasonBottomTex;
var TextureHandle rareRewardItemEmptyTex;
var EffectViewportWndHandle crossEffectX;
var EffectViewportWndHandle crossEffectY;
var EffectViewportWndHandle seasonEffect;
var AnimTextureHandle rareRewardEffectAimTex;
var array<WindowHandle> rowCrossLines;
var array<WindowHandle> columnCrossLines;
var SideBar SideBarScript;
var array<CrossEventSlot> _slots;
var CrossEventUIInfo _uiInfo;

static function CrossEventWnd Inst()
{
	return CrossEventWnd(GetScript("CrossEventWnd"));
}

function Initialize()
{
	InitControls();
	return;
}

function InitControls()
{
	local string ownerFullPath;
	local WindowHandle dialogWnd, bgContainerWnd, uiContainerWnd;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	bgContainerWnd = GetWindowHandle((ownerFullPath $ ".CrossEventBG_Wnd"));
	uiContainerWnd = GetWindowHandle((ownerFullPath $ ".CrossEventUI_Wnd"));
	seasonTopTex = GetTextureHandle((bgContainerWnd.m_WindowNameWithFullPath $ ".CrossAdvencedBgTex"));
	seasonBottomTex = GetTextureHandle((bgContainerWnd.m_WindowNameWithFullPath $ ".CrossSeasonBgTex"));
	normalRewardBtn = GetButtonHandle((uiContainerWnd.m_WindowNameWithFullPath $ ".CrossNormal_Btn"));
	rareRewardBtn = GetButtonHandle((uiContainerWnd.m_WindowNameWithFullPath $ ".CrossAdvanced_Btn"));
	rewardListBtn = GetButtonHandle((uiContainerWnd.m_WindowNameWithFullPath $ ".CrossRewardListWnd_Btn"));
	resetBtn = GetButtonHandle((uiContainerWnd.m_WindowNameWithFullPath $ ".CrossClear_Btn"));
	rareRewardItemWnd = GetItemWindowHandle((uiContainerWnd.m_WindowNameWithFullPath $ ".CrossAdvencedItemSlot"));
	rareRewardItemEmptyTex = GetTextureHandle((uiContainerWnd.m_WindowNameWithFullPath $ ".CrossAdvencedItemEmpty"));
	rareRemainTextBox = GetTextBoxHandle((uiContainerWnd.m_WindowNameWithFullPath $ ".CrossAdvanced_Txt"));
	normalRemainTextBox = GetTextBoxHandle((uiContainerWnd.m_WindowNameWithFullPath $ ".CrossCostNum_Txt"));
	leftTimeTextBox = GetTextBoxHandle((uiContainerWnd.m_WindowNameWithFullPath $ ".CrossEventTime_Txt"));
	rareRewardEffectAimTex = GetAnimTextureHandle((uiContainerWnd.m_WindowNameWithFullPath $ ".CrossAdvendedItemGet_Effect"));
	dialogWnd = GetWindowHandle((ownerFullPath $ ".CrossUIControlButtonAsset"));
	dialogAsset = Class'InterfaceClassic.UIControlDialogAssets'.static.InitScript(dialogWnd);
	dialogAsset.DelegateOnCancel = OnDialogCancel;
	dialogAsset.DelegateOnClickBuy = OnDialogConfirm;
	dialogAsset.SetUseBuyItem(false);
	dialogAsset.SetUseNumberInput(false);
	dialogAsset.SetDisableWindow(GetWindowHandle((ownerFullPath $ ".CrossDisableWindow")));
	SideBarScript = SideBar(GetScript("SideBar"));
	crossEffectX = GetEffectViewportWndHandle((ownerFullPath $ ".CrossEffectX"));
	crossEffectY = GetEffectViewportWndHandle((ownerFullPath $ ".CrossEffectY"));
	seasonEffect = GetEffectViewportWndHandle((ownerFullPath $ ".SeasonEffect"));
	rowCrossLines[0] = GetWindowHandle((ownerFullPath $ ".CrossLineX_0"));
	rowCrossLines[1] = GetWindowHandle((ownerFullPath $ ".CrossLineX_1"));
	rowCrossLines[2] = GetWindowHandle((ownerFullPath $ ".CrossLineX_2"));
	rowCrossLines[3] = GetWindowHandle((ownerFullPath $ ".CrossLineX_3"));
	columnCrossLines[0] = GetWindowHandle((ownerFullPath $ ".CrossLineY_0"));
	columnCrossLines[1] = GetWindowHandle((ownerFullPath $ ".CrossLineY_1"));
	columnCrossLines[2] = GetWindowHandle((ownerFullPath $ ".CrossLineY_2"));
	columnCrossLines[3] = GetWindowHandle((ownerFullPath $ ".CrossLineY_3"));
	InitSlotControls();
	Me = GetWindowHandle(ownerFullPath);
	return;
}

function InitSlotControls()
{
	local int maxSlotNum, i;
	local CrossEventSlot slotData;
	local CrossEventWndSlot slotObject;
	local CrossEventSlotInfo slotInfo;

	maxSlotNum = (4 * 4);
	_slots.Length = 0;
	i = 0;
	while((i < maxSlotNum))
	{
		slotInfo.SlotNum = i;
		slotInfo.Row = (i / 4);
		slotInfo.Column = int((float(i) % 4.0000000));
		slotObject = new Class'InterfaceClassic.CrossEventWndSlot';
		slotObject.Init(GetWindowHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CrossSlot_") $ string(i))));
		slotData.Info = slotInfo;
		slotData.slotObject = slotObject;
		_slots[_slots.Length] = slotData;
		i++;
	}
	return;
}

function InitSlotItemInfos(array<UIPacket._ItemInfo> ItemInfos)
{
	local int i;
	local CrossEventSlot slotData;

	i = 0;
	while((i < _slots.Length))
	{
		if((ItemInfos.Length > i))
		{
			slotData = _slots[i];
			slotData.Info.RewardItemInfo = ItemInfos[i];
			_slots[i] = slotData;
		}
		i++;
	}
	return;
}

function UpdateSlotInfos(array<UIPacket._CrossBlock> crossBlocks)
{
	local int i, rowCheckCnt, columnCheckCnt;
	local UIPacket._CrossBlock blockInfo;
	local bool tempChecked;
	local CrossEventSlot tempSlot;

	_uiInfo.rowChecked.Length = 0;
	_uiInfo.columnChecked.Length = 0;
	_uiInfo.rowChecked.Length = 4;
	_uiInfo.columnChecked.Length = 4;
	i = 0;
	while((i < crossBlocks.Length))
	{
		blockInfo = crossBlocks[i];
		if((_slots.Length > i))
		{
			tempChecked = bool(crossBlocks[i].bChecked);
			tempSlot = _slots[i];
			tempSlot.Info.checked = tempChecked;
			if(tempChecked)
			{
				rowCheckCnt = _uiInfo.rowChecked[tempSlot.Info.Row];
				columnCheckCnt = _uiInfo.columnChecked[tempSlot.Info.Column];
				_uiInfo.rowChecked[tempSlot.Info.Row] = (rowCheckCnt + 1);
				_uiInfo.columnChecked[tempSlot.Info.Column] = (columnCheckCnt + 1);
			}
			_slots[i] = tempSlot;
		}
		i++;
	}
	UpdateSlotCrossedInfos();
	return;
}

function UpdateSlotCrossedInfos()
{
	local int i;
	local CrossEventSlot slotData;

	i = 0;
	while((i < _slots.Length))
	{
		slotData = _slots[i];
		if(((_uiInfo.rowChecked[slotData.Info.Row] >= 4) || (_uiInfo.columnChecked[slotData.Info.Column] >= 4)))
		{
			slotData.Info.crossed = true;
		}
		else
		{
			slotData.Info.crossed = false;
		}
		_slots[i] = slotData;
		i++;
	}
	return;
}

function CrossEventSlot GetSlotData(int Row, int Column)
{
	local int i;
	local CrossEventSlot slotData;

	i = 0;
	while((i < _slots.Length))
	{
		slotData = _slots[i];
		if(((slotData.Info.Row == Row) && (slotData.Info.Column == Column)))
		{
			return slotData;
		}
		i++;
	}
	return slotData;
}

function ReceiveNormalReward(UIPacket._S_EX_CROSS_EVENT_NORMAL_REWARD packet)
{
	local int i, rowCheckCnt, columnCheckCnt, newCrossedRow, newCrossedColumn;
	local CrossEventSlot slotData;

	newCrossedRow = -1;
	newCrossedColumn = -1;
	i = 0;
	while((i < _slots.Length))
	{
		slotData = _slots[i];
		if((((slotData.Info.checked == false) && (packet.nX == slotData.Info.Row)) && (packet.nY == slotData.Info.Column)))
		{
			slotData.Info.checked = true;
			rowCheckCnt = _uiInfo.rowChecked[slotData.Info.Row];
			columnCheckCnt = _uiInfo.columnChecked[slotData.Info.Column];
			_uiInfo.rowChecked[slotData.Info.Row] = (rowCheckCnt + 1);
			_uiInfo.columnChecked[slotData.Info.Column] = (columnCheckCnt + 1);
			if(((rowCheckCnt + 1) == 4))
			{
				newCrossedRow = slotData.Info.Row;
			}
			if(((columnCheckCnt + 1) == 4))
			{
				newCrossedColumn = slotData.Info.Column;
			}
			_slots[i] = slotData;
			break;
		}
		i++;
	}
	if((newCrossedRow > -1))
	{
		Debug(("PlayCrossedEffect Row" @ string(newCrossedRow)));
		PlayCrossLineEffect(true, newCrossedRow);
	}
	if((newCrossedColumn > -1))
	{
		PlayCrossLineEffect(false, newCrossedColumn);
		Debug(("PlayCrossedEffect Column" @ string(newCrossedColumn)));
	}
	if(((newCrossedRow > -1) || (newCrossedColumn > -1)))
	{
		PlaySound("InterfaceSound.ui_synthesis_success");
	}
	PlaySlotStampEffect(packet.nX, packet.nY);
	UpdateSlotCrossedInfos();
	UpdateInfoControls();
	return;
}

function ReceiveRareReward(UIPacket._S_EX_CROSS_EVENT_RARE_REWARD packet)
{
	_uiInfo.getRareItemId = packet.nItemClassID;
	PlayRareRewardEffect();
	UpdateInfoControls();
	return;
}

function PlayRareRewardEffect()
{
	rareRewardEffectAimTex.Stop();
	rareRewardEffectAimTex.ShowWindow();
	rareRewardEffectAimTex.Play();
	PlaySound("InterfaceSound.GachaJewel_Rare");
	return;
}

function StartStampEffectTimer()
{
	Me.SetTimer(1, 800);
	return;
}

function KillStampEffectTimer()
{
	Me.KillTimer(1);
	return;
}

function StartButtonDelayTimer()
{
	_uiInfo.isWaitingResponse = true;
	Me.KillTimer(2);
	Me.SetTimer(2, 1000);
	return;
}

function KillButtonDelayTimer()
{
	Me.KillTimer(2);
	_uiInfo.isWaitingResponse = false;
	return;
}

function StartLeftTimeTimer()
{
	Me.KillTimer(3);
	Me.SetTimer(3, 60000);
	return;
}

function KillLeftTimeTimer()
{
	Me.KillTimer(2);
	return;
}

function PlayCrossLineEffect(bool isRow, int Index)
{
	local Rect slotRect;
	local int rowX, rowY, columnX, columnY, slotSize;

	rowX = 43;
	rowY = 289;
	columnX = 81;
	columnY = 250;
	slotSize = 88;
	if(isRow)
	{
		crossEffectX.MoveC(rowX, (rowY + (slotSize * Index)));
		crossEffectX.SpawnEffect("LineageEffect_br.b_ui_cross_line");
	}
	else
	{
		crossEffectY.MoveC((columnX + (slotSize * Index)), columnY);
		crossEffectY.SpawnEffect("LineageEffect_br.b_ui_cross_line");
	}
	Debug((("PlayCrossLineEffect" @ string(isRow)) @ string(Index)));
	return;
}

function PlaySlotStampEffect(int Row, int Column)
{
	local CrossEventSlot slotData;

	slotData = GetSlotData(Row, Column);
	slotData.slotObject.PlayStampEffect();
	StartStampEffectTimer();
	return;
}

function PlaySeasonEffect()
{
	switch(_uiInfo.season)
	{
		case 1:
			seasonEffect.SpawnEffect("LineageEffect_br.b_frame_season_spring");
			break;
		case 2:
			seasonEffect.SpawnEffect("LineageEffect_br.b_frame_season_summer");
			break;
		case 3:
			seasonEffect.SpawnEffect("LineageEffect_br.b_frame_season_autumn");
			break;
		case 4:
			seasonEffect.SpawnEffect("LineageEffect_br.b_frame_season_winter");
			break;
		default:
			seasonEffect.SpawnEffect("");
			break;
	}
	return;
}

function UpdateSlotControls()
{
	local int i;
	local CrossEventSlot slotData;

	i = 0;
	while((i < _slots.Length))
	{
		slotData = _slots[i];
		slotData.slotObject.SetInfo(slotData.Info, _uiInfo.season);
		i++;
	}
	return;
}

function UpdateCrossLineControls()
{
	local int i;
	local WindowHandle crossLineWnd;

	i = 0;
	while((i < rowCrossLines.Length))
	{
		crossLineWnd = rowCrossLines[i];
		if(((_uiInfo.rowChecked.Length > i) && (_uiInfo.rowChecked[i] >= 4)))
		{
			crossLineWnd.ShowWindow();
			i++;
			continue;
		}
		crossLineWnd.HideWindow();
		i++;
	}
	i = 0;
	while((i < columnCrossLines.Length))
	{
		crossLineWnd = columnCrossLines[i];
		if(((_uiInfo.columnChecked.Length > i) && (_uiInfo.columnChecked[i] >= 4)))
		{
			crossLineWnd.ShowWindow();
			i++;
			continue;
		}
		crossLineWnd.HideWindow();
		i++;
	}
	return;
}

function UpdateInfoControls()
{
	local string leftRewardStr;
	local ItemInfo rareItemInfo;
	local string strResetCnt;

	leftRewardStr = ((GetSystemString(5303) $ ":") @ MakeCostString(string(_uiInfo.rareRewardCnt)));
	rareRemainTextBox.SetText(leftRewardStr);
	if((_uiInfo.rareRewardCnt > 0))
	{
		rareRewardBtn.SetEnable(true);
		rareRemainTextBox.SetTextColor(GetColor(239, 197, 21, 255));
	}
	else
	{
		rareRewardBtn.SetEnable(false);
		rareRemainTextBox.SetTextColor(GetColor(220, 220, 220, 255));
	}
	normalRemainTextBox.SetText(MakeCostString(string(_uiInfo.couponNum)));
	if(IsAllSlotChecked())
	{
		resetBtn.ShowWindow();
		normalRewardBtn.HideWindow();
		strResetCnt = (((((GetSystemString(5308) $ "(") $ string(_uiInfo.remainResetCnt)) $ "/") $ string(_uiInfo.MaxResetCnt)) $ ")");
		resetBtn.SetNameText(strResetCnt);
		if(((_uiInfo.remainResetCnt > 0) && (_uiInfo.rareRewardCnt == 0)))
		{
			resetBtn.SetEnable(true);
		}
		else
		{
			resetBtn.SetEnable(false);
		}
	}
	else
	{
		resetBtn.HideWindow();
		normalRewardBtn.ShowWindow();
		if((_uiInfo.couponNum > 0))
		{
			normalRewardBtn.SetEnable(true);
		}
		else
		{
			normalRewardBtn.SetEnable(false);
		}
	}
	if((_uiInfo.getRareItemId > 0))
	{
		rareItemInfo = GetItemInfoByClassID(_uiInfo.getRareItemId);
		if(!rareRewardItemWnd.SetItem(0, rareItemInfo))
		{
			rareRewardItemWnd.AddItem(rareItemInfo);
		}
		rareRewardItemWnd.ShowWindow();
		rareRewardItemEmptyTex.HideWindow();
	}
	else
	{
		rareRewardItemWnd.HideWindow();
		rareRewardItemEmptyTex.ShowWindow();
	}
	return;
}

function UpdateLeftTimeControls()
{
	local string leftTimeStr;

	leftTimeStr = getInstanceL2Util().getTimeStringBySec3(int(_uiInfo.RemainTime));
	leftTimeTextBox.SetText(leftTimeStr);
	return;
}

function UpdateUIControls()
{
	if(Me.IsShowWindow())
	{
		UpdateSlotControls();
		UpdateCrossLineControls();
		UpdateInfoControls();
		UpdateLeftTimeControls();
	}
	UpdateSideBarTooltip();
	return;
}

function UpdateSeasonSkinTexture()
{
	seasonTopTex.SetTexture(("L2UI_NewTex.CrossEventWnd.CrossAdvenced_SeasonBg_" $ string(_uiInfo.season)));
	seasonBottomTex.SetTexture(("L2UI_NewTex.CrossEventWnd.CrossSlot_SeasonBg_" $ string(_uiInfo.season)));
	return;
}

function ShowResetDialog()
{
	dialogAsset.SetDialogDesc(GetSystemMessage(6267));
	dialogAsset.SetUseNeedItem(true);
	dialogAsset.StartNeedItemList(1);
	dialogAsset.AddNeedItemClassID(_uiInfo.resetItemInfo.nItemClassID, _uiInfo.resetItemInfo.nAmount);
	dialogAsset.SetItemNum(1);
	OpenDialog();
	return;
}

function OpenDialog()
{
	dialogAsset.Show();
	return;
}

function CloseDialog()
{
	dialogAsset.Hide();
	return;
}

function ShowNormalRewardMessage(int luckyMulti, int Row, int Column)
{
	local CrossEventSlotInfo slotInfo;
	local ItemInfo ItemInfo;
	local string itemNameStr, msgStr, ChatMsg, paramStr;

	if((luckyMulti < 2))
	{
		return;
	}
	slotInfo = GetSlotData(Row, Column).Info;
	ItemInfo = GetItemInfoByClassID(slotInfo.RewardItemInfo.nItemClassID);
	itemNameStr = GetItemNameAll(ItemInfo);
	msgStr = MakeFullSystemMsg(GetSystemMessage(6269), itemNameStr, string(luckyMulti));
	getInstanceL2Util().showGfxScreenMessage(msgStr);
	ParamAdd(paramStr, "Type", string(0));
	ParamAdd(paramStr, "param1", itemNameStr);
	AddSystemMessageParam(paramStr);
	paramStr = "";
	ParamAdd(paramStr, "Type", string(0));
	ParamAdd(paramStr, "param1", string(luckyMulti));
	AddSystemMessageParam(paramStr);
	ChatMsg = EndSystemMessageParam(6269, true);
	AddSystemMessageString(ChatMsg);
	return;
}

function ShowSideBarAlarm()
{
	if((SideBarScript._IsAlarmActived(TYPE_CROSS_EVENT) == false))
	{
		SideBarScript.SetAlarmOnOff(29, true);
	}
	return;
}

function UpdateSideBarTooltip()
{
	local WindowHandle btnWnd;
	local string normmalRewardStr, rareRewardStr;
	local int activeRelicId;

	btnWnd = SideBarScript.GetWindowByIndex(29);
	normmalRewardStr = ((GetSystemString(5305) $ ":") @ MakeCostString(string(_uiInfo.couponNum)));
	rareRewardStr = ((GetSystemString(5303) $ ":") @ MakeCostString(string(_uiInfo.rareRewardCnt)));
	btnWnd.SetTooltipCustomType(MakeTooltipMultiText(GetSystemString(5302), getInstanceL2Util().White, "", true, normmalRewardStr, getInstanceL2Util().Yellow, "", true, rareRewardStr, getInstanceL2Util().Yellow, "", true));
	return;
}

function bool IsAllSlotChecked()
{
	local int i;

	i = 0;
	while((i < _slots.Length))
	{
		if((_slots[i].Info.checked == false))
		{
			return false;
		}
		i++;
	}
	return true;
}

function RequstNormalReward()
{
	Rq_C_EX_CROSS_EVENT_NORMAL_REWARD();
	return;
}

function RequestRareReward()
{
	Rq_C_EX_CROSS_EVENT_RARE_REWARD();
	return;
}

function ShowRareRewardListWnd()
{
	Class'InterfaceClassic.CrossEventRewardListWnd'.static.Inst().ToggleShowWnd();
	return;
}

function HideRareRewardListWnd()
{
	Class'InterfaceClassic.CrossEventRewardListWnd'.static.Inst().CloseWnd();
	return;
}

function Rq_C_EX_CROSS_EVENT_DATA()
{
	local array<byte> stream;
	local UIPacket._C_EX_CROSS_EVENT_DATA packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_CROSS_EVENT_DATA(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(876, stream);
	Debug("Rq_C_EX_CROSS_EVENT_DATA");
	return;
}

function Rq_C_EX_CROSS_EVENT_INFO()
{
	local array<byte> stream;
	local UIPacket._C_EX_CROSS_EVENT_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_CROSS_EVENT_INFO(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(877, stream);
	Debug("Rq_C_EX_CROSS_EVENT_INFO");
	return;
}

function Rq_C_EX_CROSS_EVENT_NORMAL_REWARD()
{
	local array<byte> stream;
	local UIPacket._C_EX_CROSS_EVENT_NORMAL_REWARD packet;

	if((_uiInfo.isWaitingResponse == true))
	{
		return;
	}
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_CROSS_EVENT_NORMAL_REWARD(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(878, stream);
	StartButtonDelayTimer();
	return;
}

function Rq_C_EX_CROSS_EVENT_RARE_REWARD()
{
	local array<byte> stream;
	local UIPacket._C_EX_CROSS_EVENT_RARE_REWARD packet;

	if((_uiInfo.isWaitingResponse == true))
	{
		return;
	}
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_CROSS_EVENT_RARE_REWARD(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(879, stream);
	StartButtonDelayTimer();
	return;
}

function Rq_C_EX_CROSS_EVENT_RESET()
{
	local array<byte> stream;
	local UIPacket._C_EX_CROSS_EVENT_RESET packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_CROSS_EVENT_RESET(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(880, stream);
	return;
}

function Rs_S_EX_CROSS_EVENT_DATA()
{
	local UIPacket._S_EX_CROSS_EVENT_DATA packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_CROSS_EVENT_DATA(packet))
	{
		return;
	}
	_uiInfo.season = packet.nSeason;
	_uiInfo.normalRewards = packet.normalRewards;
	_uiInfo.rareRewards = packet.rareRewards;
	_uiInfo.resetItemInfo = packet.resetItemData;
	if((packet.normalRewards.Length > 0))
	{
		InitSlotItemInfos(packet.normalRewards);
	}
	Class'InterfaceClassic.CrossEventRewardListWnd'.static.Inst().SetInfo(packet.rareRewards);
	Debug((((("Rs_S_EX_CROSS_EVENT_DATA" @ string(packet.nSeason)) @ string(packet.normalRewards.Length)) @ string(packet.rareRewards.Length)) @ string(packet.resetItemData.nAmount)));
	return;
}

function Rs_S_EX_CROSS_EVENT_INFO()
{
	local UIPacket._S_EX_CROSS_EVENT_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_CROSS_EVENT_INFO(packet))
	{
		return;
	}
	_uiInfo.isOn = bool(packet.bOnEvent);
	_uiInfo.couponNum = packet.nCoupon;
	_uiInfo.rareRewardCnt = packet.nRareRewardCnt;
	_uiInfo.remainResetCnt = packet.nRemainResetCnt;
	_uiInfo.RemainTime = packet.nEndSeconds;
	_uiInfo.MaxResetCnt = packet.nMaxResetCnt;
	SideBarScript.SetWindowShowHideByIndex(29, _uiInfo.isOn);
	if((_uiInfo.isOn == false))
	{
		if(Me.IsShowWindow())
		{
			Me.HideWindow();
		}
		KillLeftTimeTimer();
		return;
	}
	UpdateSlotInfos(packet.blocks);
	UpdateUIControls();
	StartLeftTimeTimer();
	Debug(((((("Rs_S_EX_CROSS_EVENT_INFO" @ string(packet.bOnEvent)) @ string(packet.nCoupon)) @ string(packet.nRareRewardCnt)) @ string(packet.nRemainResetCnt)) @ string(packet.nEndSeconds)));
	return;
}

function Rs_S_EX_CROSS_EVENT_NORMAL_REWARD()
{
	local UIPacket._S_EX_CROSS_EVENT_NORMAL_REWARD packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_CROSS_EVENT_NORMAL_REWARD(packet))
	{
		return;
	}
	if((int(packet.bSuccess) == 1))
	{
		ReceiveNormalReward(packet);
		ShowNormalRewardMessage(packet.nLuckyMulti, packet.nX, packet.nY);
	}
	else
	{
		_uiInfo.isWaitingResponse = false;
	}
	Debug((((("Rs_S_EX_CROSS_EVENT_NORMAL_REWARD" @ string(packet.bSuccess)) @ string(packet.nX)) @ string(packet.nY)) @ string(packet.nLuckyMulti)));
	return;
}

function Rs_S_EX_CROSS_EVENT_RARE_REWARD()
{
	local UIPacket._S_EX_CROSS_EVENT_RARE_REWARD packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_CROSS_EVENT_RARE_REWARD(packet))
	{
		return;
	}
	if((int(packet.bSuccess) == 1))
	{
		ReceiveRareReward(packet);
	}
	else
	{
		_uiInfo.isWaitingResponse = false;
	}
	Debug((("Rs_S_EX_CROSS_EVENT_RARE_REWARD" @ string(packet.bSuccess)) @ string(packet.nItemClassID)));
	return;
}

function Rs_S_EX_CROSS_EVENT_RESET()
{
	local UIPacket._S_EX_CROSS_EVENT_RESET packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_CROSS_EVENT_RESET(packet))
	{
		return;
	}
	if((int(packet.bSuccess) == 1))
	{
		_uiInfo.remainResetCnt = packet.nRemainResetCnt;
		_uiInfo.getRareItemId = 0;
		Rq_C_EX_CROSS_EVENT_INFO();
	}
	UpdateUIControls();
	Debug((("Rs_S_EX_CROSS_EVENT_RESET" @ string(packet.bSuccess)) @ string(packet.nRemainResetCnt)));
	return;
}

function Nt_S_EX_CROSS_EVENT_NOTI()
{
	local UIPacket._S_EX_CROSS_EVENT_NOTI packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_CROSS_EVENT_NOTI(packet))
	{
		return;
	}
	if((_uiInfo.couponNum < packet.nCoupon))
	{
		ShowSideBarAlarm();
	}
	_uiInfo.couponNum = packet.nCoupon;
	_uiInfo.rareRewardCnt = packet.nRareRewardCnt;
	UpdateInfoControls();
	UpdateSideBarTooltip();
	Debug((("Nt_S_EX_CROSS_EVENT_NOTI" @ string(packet.nCoupon)) @ string(packet.nRareRewardCnt)));
	return;
}

event OnDialogCancel()
{
	CloseDialog();
	return;
}

event OnDialogConfirm()
{
	Rq_C_EX_CROSS_EVENT_RESET();
	CloseDialog();
	return;
}

event OnTimer(int TimerID)
{
	if((TimerID == 1))
	{
		KillStampEffectTimer();
		UpdateUIControls();
	}
	else if((TimerID == 2))
	{
		KillButtonDelayTimer();
	}
	else if((TimerID == 3))
	{
		_uiInfo.RemainTime = (_uiInfo.RemainTime - INT64(60));
		if((_uiInfo.RemainTime < INT64(0)))
		{
			_uiInfo.RemainTime = INT64(0);
			KillLeftTimeTimer();
		}
		UpdateLeftTimeControls();
	}
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "CrossNormal_Btn":
			RequstNormalReward();
			break;
		case "CrossClear_Btn":
			ShowResetDialog();
			break;
		case "CrossAdvanced_Btn":
			RequestRareReward();
			break;
		case "CrossRewardListWnd_Btn":
			ShowRareRewardListWnd();
			break;
		default:
			break;
	}
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(9751);
	RegisterEvent(EV_PacketID(1142));
	RegisterEvent(EV_PacketID(1143));
	RegisterEvent(EV_PacketID(1144));
	RegisterEvent(EV_PacketID(1145));
	RegisterEvent(EV_PacketID(1146));
	RegisterEvent(EV_PacketID(1147));
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case 40:
			_uiInfo.isOn = false;
			break;
		case 9751:
			SideBarScript.SetWindowShowHideByIndex(29, false);
			break;
		case EV_PacketID(1142):
			Rs_S_EX_CROSS_EVENT_DATA();
			break;
		case EV_PacketID(1143):
			Rs_S_EX_CROSS_EVENT_INFO();
			break;
		case EV_PacketID(1144):
			Rs_S_EX_CROSS_EVENT_NORMAL_REWARD();
			break;
		case EV_PacketID(1145):
			Rs_S_EX_CROSS_EVENT_RARE_REWARD();
			break;
		case EV_PacketID(1146):
			Rs_S_EX_CROSS_EVENT_RESET();
			break;
		case EV_PacketID(1147):
			Nt_S_EX_CROSS_EVENT_NOTI();
			break;
		default:
			break;
	}
	return;
}

event OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

event OnShow()
{
	_uiInfo.getRareItemId = 0;
	KillStampEffectTimer();
	KillButtonDelayTimer();
	Rq_C_EX_CROSS_EVENT_INFO();
	UpdateSeasonSkinTexture();
	PlaySeasonEffect();
	SideBarScript.ToggleByWindowName("CrossEventWnd", true);
	return;
}

event OnHide()
{
	HideRareRewardListWnd();
	KillStampEffectTimer();
	KillButtonDelayTimer();
	KillLeftTimeTimer();
	CloseDialog();
	SideBarScript.ToggleByWindowName("CrossEventWnd", false);
	return;
}

event OnReceivedCloseUI()
{
	if(dialogAsset.Me.IsShowWindow())
	{
		CloseDialog();
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		Me.HideWindow();
	}
	return;
}
