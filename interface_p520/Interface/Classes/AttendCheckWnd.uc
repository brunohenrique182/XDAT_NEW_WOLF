class AttendCheckWnd extends UICommonAPI
	dependson(UIPacket);

const TOTAL_ATENDANCE_Number = 28;
const COL_NUM = 7;
const ROW_MAX = 4;
const WIDTH_MAX = 1008;
const HEIGHT_MAX = 778;
const HEIGHT_ROW = 129;

var bool bInitSlot;
var bool bInitPayments;
var bool bAttendToday;
var UIPacket._S_EX_VIP_ATTENDANCE_LIST packet_attendanceList;
var array<AttendCheckSlot> attendCheckSlots;
var UIControlDialogAssets buyBtnDialogAsset;
var RichListCtrlHandle Reward_RichList;
var WindowHandle Reward_BtnUIControlGroupButtonAsset;
var L2UITimerObject tObject;
var L2UITimerObject tObjectReward;
var int followItemID;
var WindowHandle DisableWindow;
var int clickedDay;

event OnRegisterEvent()
{
	RegisterEvent(9750);
	RegisterEvent(40);
	RegisterEvent(EV_PacketID(1100));
	RegisterEvent(EV_PacketID(1101));
	RegisterEvent(EV_PacketID(1102));
	RegisterEvent(EV_PacketID(1103));
	return;
}

event OnLoad()
{
	Reward_RichList = GetRichListCtrlHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Reward_BtnUIControlGroupButtonAsset.Reward_RichList"));
	Reward_RichList.SetSelectedSelTooltip(false);
	Reward_RichList.SetAppearTooltipAtMouseX(true);
	Reward_RichList.SetSortable(false);
	Reward_RichList.SetSelectable(false);
	Reward_BtnUIControlGroupButtonAsset = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Reward_BtnUIControlGroupButtonAsset"));
	DisableWindow = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DisableWindow"));
	SetClosingOnESC();
	InitAssets();
	InitSlots();
	InitTimer();
	return;
}

event OnShow()
{
	Reward_BtnUIControlGroupButtonAsset.HideWindow();
	buyBtnDialogAsset.Hide();
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	InitSlotItems();
	InitClientAttendanceDatas();
	m_hOwnerWnd.SetFocus();
	return;
}

event OnHide()
{
	tObject._Stop();
	tObjectReward._Stop();
	return;
}

event OnEvent(int Event_ID, string a_Param)
{
	switch(Event_ID)
	{
		case 9750:
			InitPeriodString();
			break;
		case 40:
			InitFlags();
			break;
		case EV_PacketID(1100):
			Rt_S_EX_VIP_ATTENDANCE_LIST();
			break;
		case EV_PacketID(1101):
			Rt_S_EX_VIP_ATTENDANCE_CHECK();
			break;
		case EV_PacketID(1102):
			Rt_S_EX_VIP_ATTENDANCE_REWARD();
			break;
		case EV_PacketID(1103):
			Rt_S_EX_VIP_ATTENDANCE_NOTIFY();
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "WndClose_BTN":
			m_hOwnerWnd.HideWindow();
			break;
		case "HelpBtn":
			HandleHelpBtnClicked();
			break;
		case "Buy_Btn":
			HandleBuyBtn();
			break;
		case "OkButton":
			Rq_C_EX_VIP_ATTENDANCE_REWARD();
		case "CancleButton":
			HideRewardPopup();
			break;
		default:
			break;
	}
	return;
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	if((a_ButtonHandle.GetWindowName() == "Reward_Btn"))
	{
		HandleOnClickRewardBtn(a_ButtonHandle);
	}
	return;
}

function HandleOnClickRewardBtn(ButtonHandle a_ButtonHandle)
{
	local array<string> btnNames;

	Split(a_ButtonHandle.GetParentWindowName(), "_", btnNames);
	if((btnNames.Length < 2))
	{
		return;
	}
	clickedDay = (int(btnNames[1]) + 1);
	HandleRewardBtn();
	return;
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	m_hOwnerWnd.HideWindow();
	return;
}

function HandleRewardBtn()
{
	local int i;
	local RichListCtrlRowData rowData;
	local ItemInfo iInfo;

	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(57), iInfo);
	Reward_RichList.DeleteAllItem();
	i = packet_attendanceList.cRewardDay;
	while((i < clickedDay))
	{
		attendCheckSlots[i]._GetItemInfo(iInfo);
		if(MakeRewardItem(i, iInfo, rowData))
		{
			Reward_RichList.InsertRecord(rowData);
		}
		i++;
	}
	if((Reward_RichList.GetRecordCount() == 0))
	{
		return;
	}
	DisableWindow.ShowWindow();
	DisableWindow.SetFocus();
	Reward_BtnUIControlGroupButtonAsset.ShowWindow();
	Reward_BtnUIControlGroupButtonAsset.SetFocus();
	return;
}

function HideRewardPopup()
{
	DisableWindow.HideWindow();
	Reward_BtnUIControlGroupButtonAsset.HideWindow();
	return;
}

function HandleBuyBtn()
{
	if(!bAttendToday)
	{
		Class'Interface.L2Util'.static.Inst().showGfxScreenMessage(GetSystemMessage(13848));
		return;
	}
	buyBtnDialogAsset.SetDialogDesc(GetSystemMessage(13846));
	buyBtnDialogAsset.SetUseBuyItem(false);
	buyBtnDialogAsset.SetUseNeedItem(true);
	buyBtnDialogAsset.SetUseNumberInput(false);
	buyBtnDialogAsset._SetUseItemWindow(false);
	buyBtnDialogAsset.DelegateOnClickBuy = OnBuyBtnDialogConfirmOneDay;
	buyBtnDialogAsset.StartNeedItemList(1);
	buyBtnDialogAsset.AddNeedItemClassID(followItemID, INT64(attendCheckSlots[packet_attendanceList.cAttendanceDay]._followcost));
	buyBtnDialogAsset.SetItemNum(1);
	buyBtnDialogAsset.Show();
	return;
}

function delegateOnItemCountEdited(INT64 ItemCount)
{
	buyBtnDialogAsset.StartNeedItemList(1);
	buyBtnDialogAsset.AddNeedItemClassID(57, ItemCount);
	return;
}

function OnBuyBtnDialogConfirmOneDay()
{
	Rq_C_EX_VIP_ATTENDANCE_CHECK();
	buyBtnDialogAsset.Hide();
	return;
}

function OnBuyBtnDialogCancel()
{
	buyBtnDialogAsset.Hide();
	return;
}

function SetRewardDays()
{
	local int i;

	i = 0;
	while((i < packet_attendanceList.cRewardDay))
	{
		attendCheckSlots[i]._SetRewardDay();
		i++;
	}
	return;
}

function SetAttendDays()
{
	local int i;

	i = packet_attendanceList.cRewardDay;
	while((i < packet_attendanceList.cAttendanceDay))
	{
		attendCheckSlots[i]._SetAttendDay();
		i++;
	}
	tObject._Stop();
	bAttendToday = (packet_attendanceList.nRemainCheckTime == 0);
	if((packet_attendanceList.cRollBookDay <= packet_attendanceList.cAttendanceDay))
	{
		return;
	}
	if(!bAttendToday)
	{
		packet_attendanceList.cFollowBaseDay = (packet_attendanceList.cAttendanceDay + 1);
		tObject._maxCount = packet_attendanceList.nRemainCheckTime;
		attendCheckSlots[packet_attendanceList.cAttendanceDay]._SetTimerDay(packet_attendanceList.nRemainCheckTime);
		tObject._Reset();
	}
	return;
}

function SetRollBookDays()
{
	local int i, followStartDay, rollBookDay;

	rollBookDay = Min(28, packet_attendanceList.cRollBookDay);
	if(bAttendToday)
	{
		followStartDay = packet_attendanceList.cAttendanceDay;
	}
	else
	{
		followStartDay = (packet_attendanceList.cAttendanceDay + 1);
	}
	i = followStartDay;
	while((i < rollBookDay))
	{
		attendCheckSlots[i]._SeRollBookDays((i - followStartDay));
		i++;
	}
	return;
}

function SetDisables()
{
	local int i;

	i = packet_attendanceList.cRollBookDay;
	while((i < 28))
	{
		attendCheckSlots[i]._SetDisable();
		i++;
	}
	return;
}

function API_GetAttendanceData(out int followItemID, out string Period, out array<int> followCosts)
{
	GetAttendanceData(followItemID, Period, followCosts);
	return;
}

function Rq_C_EX_VIP_ATTENDANCE_LIST()
{
	local array<byte> stream;

	Class'Interface.UIPacket'.static.RequestUIPacket(846, stream);
	return;
}

function Rt_S_EX_VIP_ATTENDANCE_LIST()
{
	if(!Class'Interface.UIPacket'.static.Decode_S_EX_VIP_ATTENDANCE_LIST(packet_attendanceList))
	{
		return;
	}
	Debug((((((("Rt_S_EX_VIP_ATTENDANCE_LIST :" @ string(packet_attendanceList.nMinimumLevel)) @ string(packet_attendanceList.nRemainCheckTime)) @ string(packet_attendanceList.cRollBookDay)) @ string(packet_attendanceList.cAttendanceDay)) @ string(packet_attendanceList.cRewardDay)) @ string(packet_attendanceList.cFollowBaseDay)));
	SetRewardDays();
	SetAttendDays();
	SetRollBookDays();
	SetDisables();
	m_hOwnerWnd.ShowWindow();
	return;
}

function Rq_C_EX_VIP_ATTENDANCE_CHECK()
{
	local array<byte> stream;
	local UIPacket._C_EX_VIP_ATTENDANCE_CHECK packet;

	if(!IsLevelCondition())
	{
		Class'Interface.L2Util'.static.Inst().showGfxScreenMessage(GetSystemMessage(6129));
		return;
	}
	packet.cDay = (packet_attendanceList.cAttendanceDay + 1);
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_VIP_ATTENDANCE_CHECK(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(847, stream);
	return;
}

function Rt_S_EX_VIP_ATTENDANCE_CHECK()
{
	local UIPacket._S_EX_VIP_ATTENDANCE_CHECK packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_VIP_ATTENDANCE_CHECK(packet))
	{
		return;
	}
	if((int(packet.bResult) == 1))
	{
		attendCheckSlots[packet_attendanceList.cAttendanceDay]._SetAttendDay();
		attendCheckSlots[packet_attendanceList.cAttendanceDay]._SetHighLight();
		packet_attendanceList.cAttendanceDay = (packet_attendanceList.cAttendanceDay + 1);
		SetRollBookDays();
	}
	return;
}

function Rq_C_EX_VIP_ATTENDANCE_REWARD()
{
	local array<byte> stream;
	local UIPacket._C_EX_VIP_ATTENDANCE_REWARD packet;

	packet.cDay = clickedDay;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_VIP_ATTENDANCE_REWARD(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(848, stream);
	return;
}

function Rt_S_EX_VIP_ATTENDANCE_REWARD()
{
	local UIPacket._S_EX_VIP_ATTENDANCE_REWARD packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_VIP_ATTENDANCE_REWARD(packet))
	{
		return;
	}
	if((int(packet.bResult) == 1))
	{
		SetRewardDayPlay();
	}
	return;
}

function SetRewardDayPlay()
{
	local int maxNum;

	attendCheckSlots[packet_attendanceList.cRewardDay]._SetRewardDayPlay();
	maxNum = ((clickedDay - packet_attendanceList.cRewardDay) - 1);
	if((maxNum > 0))
	{
		tObjectReward._maxCount = maxNum;
		tObjectReward._Reset();
	}
	packet_attendanceList.cRewardDay = clickedDay;
	return;
}

function Rt_S_EX_VIP_ATTENDANCE_NOTIFY()
{
	if(!m_hOwnerWnd.IsShowWindow())
	{
		return;
	}
	tObject._Stop();
	attendCheckSlots[packet_attendanceList.cAttendanceDay]._SetAttendDay();
	attendCheckSlots[packet_attendanceList.cAttendanceDay]._SetHighLight();
	Rq_C_EX_VIP_ATTENDANCE_LIST();
	return;
}

function HandleOnTimer(int Cnt)
{
	attendCheckSlots[packet_attendanceList.cAttendanceDay]._SetRemainTime((tObject._maxCount - Cnt));
	return;
}

function HandleOnTimerReward(int Cnt)
{
	local int rewardDay;

	rewardDay = ((packet_attendanceList.cRewardDay - tObjectReward._maxCount) + Cnt);
	attendCheckSlots[rewardDay]._SetRewardDayPlay();
	return;
}

function InitFlags()
{
	bInitSlot = false;
	bAttendToday = false;
	return;
}

function InitClientAttendanceDatas()
{
	local int followcost, costIndex;
	local string o_Period;
	local array<int> o_FollowCosts;
	local int i, rollBookDay;

	API_GetAttendanceData(followItemID, o_Period, o_FollowCosts);
	rollBookDay = Min(28, packet_attendanceList.cRollBookDay);
	i = packet_attendanceList.cFollowBaseDay;
	while((i < rollBookDay))
	{
		costIndex = Min((i - packet_attendanceList.cFollowBaseDay), (o_FollowCosts.Length - 1));
		followcost = o_FollowCosts[costIndex];
		attendCheckSlots[i]._SetPay(followItemID, followcost);
		i++;
	}
	return;
}

function InitPeriodString()
{
	local string o_Period;
	local array<int> o_FollowCosts;

	API_GetAttendanceData(followItemID, o_Period, o_FollowCosts);
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".EventPeriod00_Txt")).SetText(((GetSystemString(14436) @ ":") @ o_Period));
	return;
}

function InitSlots()
{
	local int i;

	attendCheckSlots.Length = 28;
	i = 0;
	while((i < 28))
	{
		attendCheckSlots[i] = new Class'Interface.AttendCheckSlot';
		attendCheckSlots[i]._Init(GetWindowHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DaySlot_") $ string(i))));
		attendCheckSlots[i]._SetDayTexture((i + 1));
		i++;
	}
	return;
}

function InitSlotItems()
{
	local int i;

	if(bInitSlot)
	{
		return;
	}
	i = 0;
	while((i < packet_attendanceList.RewardItems.Length))
	{
		attendCheckSlots[i].m_hOwnerWnd.ShowWindow();
		attendCheckSlots[i]._SetItemInfoControl(packet_attendanceList.RewardItems[i].nClassID, packet_attendanceList.RewardItems[i].nAmount);
		attendCheckSlots[i]._SetSlotHighlightControl((int(packet_attendanceList.RewardItems[i].bHighlight) == 1));
		i++;
	}
	i = i;
	while((i < 28))
	{
		attendCheckSlots[i].m_hOwnerWnd.HideWindow();
		i++;
	}
	m_hOwnerWnd.SetWindowSize(1008, (778 - (129 * (4 - appCeil((float(packet_attendanceList.RewardItems.Length) / 7.0000000))))));
	bInitSlot = true;
	return;
}

function InitTimer()
{
	tObject = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject(1000, 0);
	tObject._DelegateOnTime = HandleOnTimer;
	tObject._Stop();
	tObjectReward = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject(150, 0);
	tObjectReward._DelegateOnTime = HandleOnTimerReward;
	tObjectReward._Stop();
	return;
}

function InitAssets()
{
	local WindowHandle buyBtnWnd;

	buyBtnWnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Buy_BtnUIControlGroupButtonAsset"));
	buyBtnDialogAsset = Class'Interface.UIControlDialogAssets'.static.InitScript(buyBtnWnd);
	buyBtnDialogAsset.DelegateOnCancel = OnBuyBtnDialogCancel;
	buyBtnDialogAsset.SetDisableWindow(DisableWindow);
	buyBtnDialogAsset.SetUseBuyItem(false);
	buyBtnDialogAsset.SetUseNeedItem(true);
	buyBtnDialogAsset.SetUseNumberInput(false);
	return;
}

function HandleHelpBtnClicked()
{
	local string strParam;

	ParamAdd(strParam, "FilePath", (GetLocalizedL2TextPathNameUC() $ "g_attendance_help001.htm"));
	HelpHtmlWnd(GetScript("HelpHtmlWnd")).HandleShowHelp(strParam);
	return;
}

function _Rq_C_EX_VIP_ATTENDANCE_LIST()
{
	Rq_C_EX_VIP_ATTENDANCE_LIST();
	return;
}

function bool IsLevelCondition()
{
	local UserInfo uInfo;

	if(!GetPlayerInfo(uInfo))
	{
		return false;
	}
	return (uInfo.nLevel >= packet_attendanceList.nMinimumLevel);
}

function bool MakeRewardItem(int Day, ItemInfo iInfo, out RichListCtrlRowData oRowData)
{
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = 3;
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, MakeFullSystemMsg(GetSystemMessage(3418), string((Day + 1))), getInstanceL2Util().BrightWhite, false, 5, 0);
	addRichListCtrlTexture(rowData.cellDataList[1].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, 1);
	AddRichListCtrlItem(rowData.cellDataList[1].drawitems, iInfo, 32, 32, -34, 1);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, GetItemNameAll(iInfo, true), getInstanceL2Util().BrightWhite, false, 5, 9);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, iInfo.AdditionalName, getInstanceL2Util().Yellow03, false, 5, 0);
	AddRichListCtrlString(rowData.cellDataList[2].drawitems, ("x" $ MakeCostStringINT64(iInfo.ItemNum)), getInstanceL2Util().White, false, 5);
	oRowData = rowData;
	return true;
}
