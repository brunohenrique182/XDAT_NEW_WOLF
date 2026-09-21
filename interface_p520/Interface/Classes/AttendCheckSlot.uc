class AttendCheckSlot extends UICommonAPI;

const DATE_TEXTURE_PATH = "L2UI_CT1.AttendCheckWnd.Attend_DateNum_";
const B_USE_BLIND = false;
const B_FULL_BLIND = true;
const BLIND_START_DAY = 8;

var TextBoxHandle Pay_Num;
var TextBoxHandle Time_Txt;
var TextBoxHandle RewardState_Txt;
var TextureHandle checkedBgTex;
var TextureHandle stampTex;
var TextureHandle Active_Texture;
var TextureHandle rewardAvailableTex;
var TextureHandle Time_Tex;
var TextureHandle LockIcon_Texture;
var TextureHandle Cover_Texture;
var AnimTextureHandle stampAnimTex;
var WindowHandle buy_Wnd;
var WindowHandle attendHighlight;
var ButtonHandle Buy_Btn;
var ButtonHandle Reward_Btn;
var int _followcost;
var L2UITimerObject tObject;

function _Init(WindowHandle Owner)
{
	m_hOwnerWnd = Owner;
	checkedBgTex = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".StampBG_Texture"));
	stampTex = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".StampRed_Texture"));
	rewardAvailableTex = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".TodayTwinkle_AnimTex"));
	stampAnimTex = GetAnimTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".TodayStampRed_AnimText"));
	Active_Texture = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Active_Texture"));
	RewardState_Txt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".RewardState_Txt"));
	Time_Txt = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Time_Txt"));
	Time_Tex = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Time_Tex"));
	buy_Wnd = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".buy_Wnd"));
	Pay_Num = GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".buy_Wnd.Pay_Num"));
	Buy_Btn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".buy_Wnd.Buy_Btn"));
	Reward_Btn = GetButtonHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Reward_Btn"));
	Cover_Texture = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Cover_Texture"));
	attendHighlight = GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".attendHighlight"));
	attendHighlight.SetAlpha(0);
	LockIcon_Texture = GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".LockIcon_Texture"));
	checkedBgTex.HideWindow();
	stampTex.HideWindow();
	Time_Tex.HideWindow();
	Time_Txt.HideWindow();
	InitTobject();
	return;
}

function InitTobject()
{
	tObject = Class'Interface.L2UITimer'.static.Inst()._MakeTimerObject(900, 1);
	tObject._DelegateOnEnd = onTimerEnd;
	return;
}

function _SetItemInfoControl(int ItemID, INT64 ItemAmount)
{
	local ItemInfo iInfo;
	local string amountStr;

	iInfo = GetItemInfoByClassID(ItemID);
	iInfo.ItemNum = ItemAmount;
	GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AttendMonth_ItemWindow")).Clear();
	GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AttendMonth_ItemWindow")).AddItem(iInfo);
	amountStr = ("x" $ string(ItemAmount));
	if((ItemAmount == INT64(0)))
	{
		GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AttendDayCount_TextBox")).HideWindow();
	}
	else
	{
		GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AttendDayCount_TextBox")).SetText(amountStr);
		GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AttendDayCount_TextBox")).ShowWindow();
	}
	return;
}

function _SetDayTexture(int Day)
{
	local string ten, one;

	StrDaySplit(Day, ten, one);
	GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DateNum_Month_1_Texture")).SetTexture(("L2UI_CT1.AttendCheckWnd.Attend_DateNum_" $ ten));
	GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".DateNum_Month_10_Texture")).SetTexture(("L2UI_CT1.AttendCheckWnd.Attend_DateNum_" $ one));
	SetBlind(Day);
	return;
}

function bool IsBlind(int Day)
{
	if(getInstanceUIData().GetIsLiveServer())
	{
		return false;
	}
	if(!false)
	{
		return false;
	}
	return (Day >= 8);
}

function SetBlind(int Day)
{
	if(IsBlind(Day))
	{
		Cover_Texture.ShowWindow();
	}
	else
	{
		Cover_Texture.HideWindow();
	}
	return;
}

function SetUnBlind()
{
	if((true == false))
	{
		Cover_Texture.HideWindow();
	}
	return;
}

function _SetSlotHighlightControl(bool isHighLight)
{
	if(isHighLight)
	{
		GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SlotHighlight_Texture")).ShowWindow();
		Cover_Texture.SetTexture("L2UI_NewTex.AttendCheckWnd.Cover_Special");
	}
	else
	{
		GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".SlotHighlight_Texture")).HideWindow();
		Cover_Texture.SetTexture("L2UI_NewTex.AttendCheckWnd.Cover_Normal");
	}
	return;
}

function _SetRewardDayPlay()
{
	UnSetHighLight();
	_SetRewardDay();
	stampAnimTex.Stop();
	stampAnimTex.ShowWindow();
	stampAnimTex.Play();
	tObject._Reset();
	stampTex.HideWindow();
	return;
}

function onTimerEnd()
{
	stampTex.ShowWindow();
	return;
}

function _SetRewardDay()
{
	UnSetHighLight();
	stampAnimTex.HideWindow();
	checkedBgTex.ShowWindow();
	stampTex.ShowWindow();
	rewardAvailableTex.HideWindow();
	Active_Texture.HideWindow();
	buy_Wnd.HideWindow();
	Time_Tex.HideWindow();
	Time_Txt.HideWindow();
	RewardState_Txt.ShowWindow();
	LockIcon_Texture.HideWindow();
	SetUnBlind();
	Reward_Btn.HideWindow();
	return;
}

function _SetTimerDay(int RemainTime)
{
	_SetHighLight();
	stampAnimTex.HideWindow();
	stampAnimTex.Stop();
	checkedBgTex.HideWindow();
	tObject._Stop();
	stampTex.HideWindow();
	rewardAvailableTex.HideWindow();
	Active_Texture.ShowWindow();
	buy_Wnd.HideWindow();
	Time_Tex.ShowWindow();
	Time_Txt.ShowWindow();
	RewardState_Txt.HideWindow();
	_SetRemainTime(RemainTime);
	LockIcon_Texture.HideWindow();
	SetUnBlind();
	Reward_Btn.HideWindow();
	RewardState_Txt.HideWindow();
	return;
}

function _SetRemainTime(int RemainTime)
{
	rewardAvailableTex.HideWindow();
	if((RemainTime <= 60))
	{
		Time_Txt.SetText(GetStringDayAndTime(RemainTime, (int(GetLanguage()) != 0)));
	}
	else
	{
		Time_Txt.SetText(Class'Interface.L2Util'.static.Inst().TimeNumberToString(RemainTime));
	}
	return;
}

function _SetAttendDay()
{
	stampAnimTex.HideWindow();
	stampAnimTex.Stop();
	checkedBgTex.HideWindow();
	tObject._Stop();
	stampTex.HideWindow();
	rewardAvailableTex.ShowWindow();
	Active_Texture.ShowWindow();
	buy_Wnd.HideWindow();
	Time_Tex.HideWindow();
	Time_Txt.HideWindow();
	RewardState_Txt.HideWindow();
	Reward_Btn.ShowWindow();
	LockIcon_Texture.HideWindow();
	SetUnBlind();
	return;
}

function _SetHighLight()
{
	Class'Interface.L2UITween'.static.Inst()._AddTweenTwinlkle(attendHighlight, 3.5000000, 0.5000000, 1000.0000000);
	return;
}

function UnSetHighLight()
{
	Class'Interface.L2UITween'.static.Inst()._KillTwinkleWithWnd(attendHighlight);
	attendHighlight.SetAlpha(0);
	return;
}

function _SeRollBookDays(int Day)
{
	stampAnimTex.HideWindow();
	stampAnimTex.Stop();
	UnSetHighLight();
	checkedBgTex.HideWindow();
	tObject._Stop();
	stampTex.HideWindow();
	Active_Texture.ShowWindow();
	buy_Wnd.ShowWindow();
	if((Day == 0))
	{
		Buy_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14438)));
		Buy_Btn.EnableWindow();
	}
	else
	{
		Buy_Btn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(14443)));
		Buy_Btn.DisableWindow();
	}
	rewardAvailableTex.HideWindow();
	Reward_Btn.HideWindow();
	LockIcon_Texture.HideWindow();
	SetUnBlind();
	RewardState_Txt.HideWindow();
	return;
}

function _SetDisable()
{
	UnSetHighLight();
	Active_Texture.HideWindow();
	buy_Wnd.HideWindow();
	rewardAvailableTex.HideWindow();
	Reward_Btn.HideWindow();
	LockIcon_Texture.ShowWindow();
	RewardState_Txt.HideWindow();
	return;
}

function SetPaymentIcon(int ItemID)
{
	switch(ItemID)
	{
		case 91663:
			GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Buy_Wnd.PayMentIcon_Texture")).SetTexture("L2UI_CT1.LCoinShopWnd.LCoinShopWnd_Icon_Lcoin");
			break;
		case 48472:
			GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Buy_Wnd.PayMentIcon_Texture")).SetTexture("L2UI_EPIC.LCoinShopWnd.bm_einhasad_coin");
			break;
		case 57:
			GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Buy_Wnd.PayMentIcon_Texture")).SetTexture("L2UI_CT1.Icon.Icon_DF_Common_Adena");
			break;
		default:
			break;
	}
	GetTextureHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Buy_Wnd.PayMentIcon_Texture")).SetAnchor((m_hOwnerWnd.m_WindowNameWithFullPath $ ".Buy_Wnd.Pay_Num"), "CenterLeft", "CenterRight", -3, 1);
	return;
}

function _SetPay(int ClassID, int payment)
{
	_followcost = payment;
	Pay_Num.SetText(("x" $ MakeCostString(string(_followcost))));
	SetPaymentIcon(ClassID);
	return;
}

function _GetItemInfo(out ItemInfo oIInfo)
{
	local ItemInfo iInfo;

	GetItemWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".AttendMonth_ItemWindow")).GetItem(0, iInfo);
	oIInfo = iInfo;
	return;
}

function StrDaySplit(int nDay, out string ten, out string one)
{
	if((nDay > 9))
	{
		ten = Mid(string(nDay), 0, 1);
		one = Mid(string(nDay), 1, 1);
	}
	else
	{
		ten = "0";
		one = string(nDay);
	}
	return;
}
