class HomunculusWnd extends UICommonAPI
	dependson(UIPacket);

const SKILLIDNUM = 6;
const TIMEID_ENCHANTPOINT = 19;
const TIME_ENCHANTPOINT = 2000;

enum type_State
{
	non,                            // 0
	birth,                          // 1
	Main,                           // 2
	Communion,                      // 3
	EnchantHomunculus,              // 4
	EnchantPoints,                  // 5
	EnchantCommunion,               // 6
	Revolution                      // 7
};

enum TYPE_ANIM
{
	birth,                          // 0
	levelup                         // 1
};

var WindowHandle Me;
var string m_Windowname;
var L2Util util;
var TextBoxHandle txt0;
var ButtonHandle btn0;
var TextBoxHandle txt1;
var HomunculusWndEnchantPoints homunculusWndEnchantPointsScript;
var HomunculusWndBirth homunculusWndBirthScript;
var HomunculusWndGacha homunculusWndGachaScript;
var HomunculusWndMainList homunculusWndMainListScript;
var HomunculusWndMainDetailStats homunculusWndMainDetailStatsScript;
var HomunculusWndMainDetailStatsEnchant homunculusWndMainDetailStatsEnchantScript;
var HomunculusWndMainViewport homunculusWndMainViewportScript;
var HomunculusWndEnchantCommunionChart homunculusWndEnchantCommunionChartScript;
var HomunculusWndEnchantCommunionInfo homunculusWndEnchantCommunionInfoScript;
var HomunculusWndEnchantCommunionDice homunculusWndEnchantCommunionDiceScript;
var HomunculusWndRevolution homunclusRevolutionScript;
var TabHandle tab;
var int currentEnchantPoint;
var int currentEvolutionPoint;
var SideBar SideBarScript;
var bool conditionBirth;
var bool conditionEnchant;
var HomunculusAPI.HomunEnchantData EnchantData;
var type_State currState;

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	util = L2Util(GetScript("L2Util"));
	homunculusWndEnchantPointsScript = HomunculusWndEnchantPoints(GetScript((m_Windowname $ ".HomunculusWndEnchantPoints")));
	homunculusWndBirthScript = HomunculusWndBirth(GetScript((m_Windowname $ ".homunculusWndBirth")));
	homunculusWndGachaScript = HomunculusWndGacha(GetScript((m_Windowname $ ".homunculusWndGacha")));
	homunculusWndMainListScript = HomunculusWndMainList(GetScript((m_Windowname $ ".HomunculusWndMainList")));
	homunculusWndMainDetailStatsScript = HomunculusWndMainDetailStats(GetScript((m_Windowname $ ".HomunculusWndMainDetailStats")));
	homunculusWndMainViewportScript = HomunculusWndMainViewport(GetScript((m_Windowname $ ".HomunculusWndMainViewport")));
	homunculusWndMainDetailStatsEnchantScript = HomunculusWndMainDetailStatsEnchant(GetScript((m_Windowname $ ".HomunculusWndMainDetailStatsEnchant")));
	homunculusWndEnchantCommunionChartScript = HomunculusWndEnchantCommunionChart(GetScript((m_Windowname $ ".homunculusWndEnchantCommunionChart")));
	homunculusWndEnchantCommunionInfoScript = HomunculusWndEnchantCommunionInfo(GetScript((m_Windowname $ ".homunculusWndEnchantCommunionInfo")));
	homunculusWndEnchantCommunionDiceScript = HomunculusWndEnchantCommunionDice(GetScript((m_Windowname $ ".homunculusWndEnchantCommunionDice")));
	homunclusRevolutionScript = HomunculusWndRevolution(GetScript((m_Windowname $ ".HomunculusWndRevolution")));
	txt0 = GetTextBoxHandle((m_Windowname $ ".HomunculusWndMainContainer.txt0"));
	btn0 = GetButtonHandle((m_Windowname $ ".HomunculusWndMainContainer.btn0"));
	txt1 = GetTextBoxHandle((m_Windowname $ ".HomunculusWndMainContainer.txt1"));
	tab = GetTabHandle((m_Windowname $ ".tab"));
	SideBarScript = SideBar(GetScript("SideBar"));
	SetPopupScript();
	return;
}

function SetPopupScript()
{
	local WindowHandle poopExpandWnd;
	local UIControlDialogAssets popupExpandScript;
	local WindowHandle disableWnd;

	poopExpandWnd = GetWindowHandle((m_Windowname $ ".UIControlDialogAsset"));
	popupExpandScript = Class'InterfaceClassic.UIControlDialogAssets'.static.InitScript(poopExpandWnd);
	popupExpandScript.SetUseNeedItem(true);
	popupExpandScript.DelegateOnCancel = OnClickPopupCancel;
	popupExpandScript.DelegateOnClickBuy = OnClickPopupBuy;
	disableWnd = GetWindowHandle((m_Windowname $ ".disable_tex"));
	popupExpandScript.SetDisableWindow(disableWnd);
	Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop((m_Windowname $ ".disable_tex"), false);
	return;
}

function UIControlDialogAssets GetPopupExpandScript()
{
	local WindowHandle poopExpandWnd;

	poopExpandWnd = GetWindowHandle((m_Windowname $ ".UIControlDialogAsset"));
	return UIControlDialogAssets(poopExpandWnd.GetScript());
}

function OnClickPopupBuy()
{
	GetPopupExpandScript().Hide();
	return;
}

function OnClickPopupCancel()
{
	local WindowHandle poopExpandWnd;
	local UIControlDialogAssets popupExpandScript;

	poopExpandWnd = GetWindowHandle((m_Windowname $ ".UIControlDialogAsset"));
	popupExpandScript = UIControlDialogAssets(poopExpandWnd.GetScript());
	popupExpandScript.Hide();
	return;
}

function bool API_IsHomunReady()
{
	return Class'NWindow.HomunculusAPI'.static.IsHomunReady();
}

function API_C_EX_SHOW_HOMUNCULUS_INFO(int Type)
{
	local array<byte> stream;
	local UIPacket._C_EX_SHOW_HOMUNCULUS_INFO packet;

	packet.Type = Type;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_SHOW_HOMUNCULUS_INFO(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(633, stream);
	return;
}

function API_C_EX_HOMUNCULUS_ACTIVATE_SLOT(int SlotIndex)
{
	local array<byte> stream;
	local UIPacket._C_EX_HOMUNCULUS_ACTIVATE_SLOT packet;

	packet.SlotIndex = SlotIndex;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_HOMUNCULUS_ACTIVATE_SLOT(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(702, stream);
	return;
}

function API_C_EX_HOMUNCULUS_CREATE_START()
{
	local array<byte> stream;
	local UIPacket._C_EX_HOMUNCULUS_CREATE_START packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_HOMUNCULUS_CREATE_START(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(634, stream);
	return;
}

function API_C_EX_HOMUNCULUS_INSERT(int Type)
{
	local array<byte> stream;
	local UIPacket._C_EX_HOMUNCULUS_INSERT packet;

	packet.Type = Type;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_HOMUNCULUS_INSERT(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(635, stream);
	return;
}

function API_C_EX_HOMUNCULUS_SUMMON()
{
	local array<byte> stream;
	local UIPacket._C_EX_HOMUNCULUS_SUMMON packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_HOMUNCULUS_SUMMON(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(636, stream);
	return;
}

function HomunculusAPI.HomunCreateData API_GetHomunCreateData()
{
	return Class'NWindow.HomunculusAPI'.static.GetHomunCreateData();
}

function INT64 API_GetRemainBirthSeconds()
{
	return Class'NWindow.HomunculusAPI'.static.GetRemainBirthSeconds();
}

function array<HomunculusAPI.HomunculusData> API_GetHomunculusDatas()
{
	return Class'NWindow.HomunculusAPI'.static.GetHomunculusDatas();
}

function HomunculusAPI.HomunculusNpcLevelData API_GetHomunculusNpcLevelData(int Id, int Level)
{
	return Class'NWindow.HomunculusAPI'.static.GetHomunculusNpcLevelData(Id, Level);
}

function HomunculusAPI.HomunculusNpcLevelData API_GetMaxHomunculusNpcLevelData(int Id)
{
	return Class'NWindow.HomunculusAPI'.static.GetMaxHomunculusNpcLevelData(Id);
}

function API_C_EX_DELETE_HOMUNCULUS_DATA(int idx)
{
	local array<byte> stream;
	local UIPacket._C_EX_DELETE_HOMUNCULUS_DATA packet;

	packet.nIdx = idx;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_DELETE_HOMUNCULUS_DATA(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(637, stream);
	return;
}

function API_C_EX_REQUEST_ACTIVATE_HOMUNCULUS(int idx, bool bActive)
{
	local array<byte> stream;
	local UIPacket._C_EX_REQUEST_ACTIVATE_HOMUNCULUS packet;

	packet.nIdx = idx;
	if(bActive)
	{
		packet.bActivate = 1;
	}
	else
	{
		packet.bActivate = 0;
	}
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_REQUEST_ACTIVATE_HOMUNCULUS(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(638, stream);
	return;
}

function HomunculusAPI.HomunculusNpcData GetHomunculusNpcData(int Id)
{
	return Class'NWindow.HomunculusAPI'.static.GetHomunculusNpcData(Id);
}

function HomunculusAPI.HomunEnchantData API_GetHomunEnchantData()
{
	return Class'NWindow.HomunculusAPI'.static.GetHomunEnchantData();
}

function HomunculusAPI.HomunEnchantResetData API_GetPointResetItem()
{
	return Class'NWindow.HomunculusAPI'.static.GetPointResetItem();
}

function HomunculusAPI.HomunEnchantResetData API_GetBonusResetItem()
{
	return Class'NWindow.HomunculusAPI'.static.GetBonusResetItem();
}

function API_C_EX_HOMUNCULUS_ENCHANT_EXP(int idx)
{
	local array<byte> stream;
	local UIPacket._C_EX_HOMUNCULUS_ENCHANT_EXP packet;

	packet.nIdx = idx;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_HOMUNCULUS_ENCHANT_EXP(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(643, stream);
	return;
}

function API_C_EX_HOMUNCULUS_GET_ENCHANT_POINT(int Type)
{
	local array<byte> stream;
	local UIPacket._C_EX_HOMUNCULUS_GET_ENCHANT_POINT packet;

	packet.Type = Type;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_HOMUNCULUS_GET_ENCHANT_POINT(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(639, stream);
	return;
}

function API_C_EX_HOMUNCULUS_INIT_POINT(int Type)
{
	local array<byte> stream;
	local UIPacket._C_EX_HOMUNCULUS_INIT_POINT packet;

	packet.Type = Type;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_HOMUNCULUS_INIT_POINT(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(640, stream);
	return;
}

function API_C_EX_ENCHANT_HOMUNCULUS_SKILL(int Type, int idx, int Level)
{
	local array<byte> stream;
	local UIPacket._C_EX_ENCHANT_HOMUNCULUS_SKILL packet;

	packet.Type = Type;
	packet.nIdx = idx;
	packet.nLevel = Level;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_ENCHANT_HOMUNCULUS_SKILL(stream, packet))
	{
		return;
	}
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(642, stream);
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(180);
	RegisterEvent(150);
	RegisterEvent(40);
	RegisterEvent(EV_PacketID(863));
	RegisterEvent(EV_PacketID(1161));
	return;
}

function RT_S_EX_HOMUNCULUS_POINT_INFO()
{
	local UIPacket._S_EX_HOMUNCULUS_POINT_INFO packet;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_HOMUNCULUS_POINT_INFO(packet))
	{
		return;
	}
	return;
}

event OnLoad()
{
	Initialize();
	SetClosingOnESC();
	return;
}

event OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 150:
			if(ChkSerVer())
			{
				HandleGameInit();
			}
			break;
		case 40:
			if(ChkSerVer())
			{
				SetState(non);
			}
			break;
		case EV_PacketID(863):
			RT_S_EX_HOMUNCULUS_POINT_INFO();
			break;
		case EV_PacketID(1161):
			RT_S_EX_HOMUNCULUS_EVOLVE();
			break;
		default:
			break;
	}
	return;
}

function RT_S_EX_HOMUNCULUS_EVOLVE()
{
	homunclusRevolutionScript._RT_S_EX_HOMUNCULUS_EVOLVE();
	return;
}

event OnClickButton(string Name)
{
	switch(Name)
	{
		case "btn0":
			homunculusWndEnchantPointsScript.Toggle();
			if(!homunculusWndEnchantPointsScript.Me.IsShowWindow())
			{
				btn0.DisableWindow();
				Me.SetTimer(19, 2000);
			}
			break;
		case "HelpWnd_Btn":
			ExecuteEvent(1210, "109");
			break;
		default:
			HandleBtnClick(Name);
			break;
	}
	return;
}

event OnRClickButton(string Name)
{
	HandleBtnClick(Name);
	return;
}

event OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	if(homunculusWndEnchantPointsScript.Me.IsShowWindow())
	{
		homunculusWndEnchantPointsScript.Hide();
	}
	else
	{
		switch(currState)
		{
			case EnchantCommunion:
				if((homunculusWndEnchantCommunionDiceScript.completedDiceNum == 3))
				{
					SetState(Communion);
				}
				else
				{
					Me.HideWindow();
				}
				break;
			case EnchantHomunculus:
				SetState(Main);
				break;
			case Communion:
				SetState(Main);
				break;
			case Revolution:
				if(!homunclusRevolutionScript._ChkSacrificeState())
				{
					SetState(Main);
				}
				break;
			default:
				Me.HideWindow();
		}
	}
	return;
}

event OnShow()
{
	homunculusWndMainViewportScript._SetSpawnOnShow();
	if(!API_IsHomunReady())
	{
		Me.HideWindow();
		AddSystemMessage(213);
		return;
	}
	switch(currState)
	{
		case birth:
			if(homunculusWndBirthScript.isGachaState)
			{
				homunculusWndGachaScript.Show();
			}
			break;
		case non:
			API_C_EX_SHOW_HOMUNCULUS_INFO(0);
			API_C_EX_SHOW_HOMUNCULUS_INFO(1);
			API_C_EX_SHOW_HOMUNCULUS_INFO(2);
			SetState(birth);
			break;
		case currState:
			SetState(Main);
			break;
		default:
			break;
	}
	SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(self)), true);
	if(conditionEnchant)
	{
		SetState(Main);
		homunculusWndEnchantPointsScript.Show();
	}
	else if(conditionBirth)
	{
		SetState(birth);
	}
	return;
}

event OnHide()
{
	hidePopup();
	homunculusWndGachaScript.SetOnHide();
	SideBar(GetScript("SideBar")).ToggleByWindowName(getCurrentWindowName(string(self)), false);
	if(GetWindowHandle("HomunculusWndProbability").IsShowWindow())
	{
		GetWindowHandle("HomunculusWndProbability").HideWindow();
	}
	homunculusWndMainViewportScript._SetDispawnOnHide();
	if(homunculusWndBirthScript.resultWnd.IsShowWindow())
	{
		homunculusWndBirthScript.HandleConfirm();
	}
	if(DialogIsMine())
	{
		Class'InterfaceClassic.DialogBox'.static.Inst().HideDialog();
	}
	return;
}

event OnTimer(int tID)
{
	switch(tID)
	{
		case 19:
			Me.KillTimer(19);
			btn0.EnableWindow();
			break;
		default:
			break;
	}
	return;
}

function HandleBtnClick(string btnName)
{
	local string strID;

	if(GetStringIDFromBtnName(btnName, "tab", strID))
	{
		switch(strID)
		{
			case "0":
				SetState(birth);
				break;
			case "1":
				SetState(Main);
				break;
			default:
				break;
		}
	}
	return;
}

function hidePopup()
{
	local WindowHandle poopExpandWnd;
	local UIControlDialogAssets popupExpandScript;

	poopExpandWnd = GetWindowHandle((m_Windowname $ ".UIControlDialogAsset"));
	popupExpandScript = UIControlDialogAssets(poopExpandWnd.GetScript());
	popupExpandScript.Hide();
	return;
}

function HandleGameInit()
{
	if((GetGameStateName() != "GAMINGSTATE"))
	{
		return;
	}
	EnchantData = API_GetHomunEnchantData();
	return;
}

function SetEnchantpoint(int point)
{
	currentEnchantPoint = point;
	txt0.SetText(MakeCostString(string(currentEnchantPoint)));
	return;
}

function _SetEvolutionPoint(int point)
{
	currentEvolutionPoint = point;
	txt1.SetText(MakeCostString(string(currentEvolutionPoint)));
	return;
}

function RenewHomunculusData()
{
	homunculusWndMainDetailStatsScript.SetChangeHomunculusData();
	homunculusWndMainDetailStatsEnchantScript.SetChangeHomunculusData();
	homunculusWndMainViewportScript.SetChangeHomunculusData();
	homunculusWndEnchantCommunionChartScript.SetChangeHomunculusData();
	homunculusWndEnchantCommunionInfoScript.SetChangeHomunculusData();
	return;
}

function ClearHomunculusData()
{
	homunculusWndMainViewportScript.ClearAll();
	homunculusWndMainDetailStatsScript.ClearAll();
	homunculusWndMainDetailStatsEnchantScript.ClearAll();
	homunculusWndEnchantCommunionChartScript.ClearAll();
	homunculusWndEnchantCommunionInfoScript.ClearAll();
	return;
}

function _SetRevolutionState()
{
	SetState(Revolution);
	return;
}

function SetState(type_State NewState)
{
	switch(NewState)
	{
		case birth:
			tab.SetTopOrder(0, true);
			homunculusWndEnchantPointsScript.Hide();
			homunculusWndBirthScript.Show();
			homunculusWndMainListScript.Hide();
			homunculusWndMainDetailStatsScript.Hide();
			homunculusWndMainDetailStatsEnchantScript.Hide();
			homunculusWndMainViewportScript.Hide();
			homunculusWndEnchantCommunionChartScript.Hide();
			homunculusWndEnchantCommunionInfoScript.Hide();
			homunculusWndEnchantCommunionDiceScript.Hide();
			homunclusRevolutionScript._Hide();
			break;
		case Main:
			API_C_EX_SHOW_HOMUNCULUS_INFO(2);
			tab.SetTopOrder(1, true);
			homunculusWndEnchantPointsScript.Hide();
			homunculusWndBirthScript.Hide();
			homunculusWndMainListScript.Show();
			homunculusWndMainDetailStatsScript.Show();
			homunculusWndMainDetailStatsEnchantScript.Hide();
			homunculusWndMainViewportScript.Show();
			homunculusWndEnchantCommunionChartScript.Hide();
			homunculusWndEnchantCommunionInfoScript.Hide();
			homunculusWndEnchantCommunionDiceScript.Hide();
			homunclusRevolutionScript._Hide();
			break;
		case EnchantHomunculus:
			homunculusWndEnchantPointsScript.Hide();
			homunculusWndBirthScript.Hide();
			homunculusWndMainListScript.Show();
			homunculusWndMainDetailStatsScript.Hide();
			homunculusWndMainDetailStatsEnchantScript.Show();
			homunculusWndMainViewportScript.Show();
			homunculusWndEnchantCommunionChartScript.Hide();
			homunculusWndEnchantCommunionInfoScript.Hide();
			homunculusWndEnchantCommunionDiceScript.Hide();
			homunclusRevolutionScript._Hide();
			break;
		case Communion:
			if((int(currState) != 6))
			{
				homunculusWndEnchantPointsScript.Hide();
				homunculusWndBirthScript.Hide();
				homunculusWndMainListScript.Hide();
				homunculusWndMainDetailStatsScript.Hide();
				homunculusWndMainDetailStatsEnchantScript.Hide();
				homunculusWndMainViewportScript.Show();
				homunculusWndEnchantCommunionChartScript.Show();
				homunculusWndEnchantCommunionInfoScript.Show();
				homunculusWndEnchantCommunionDiceScript.Hide();
				homunclusRevolutionScript._Hide();
			}
			else
			{
				homunculusWndEnchantCommunionDiceScript.Hide();
			}
			break;
		case EnchantCommunion:
			if((int(currState) != 3))
			{
				homunculusWndEnchantPointsScript.Hide();
				homunculusWndBirthScript.Hide();
				homunculusWndMainListScript.Hide();
				homunculusWndMainDetailStatsScript.Hide();
				homunculusWndMainDetailStatsEnchantScript.Hide();
				homunculusWndMainViewportScript.Show();
				homunculusWndEnchantCommunionChartScript.Show();
				homunculusWndEnchantCommunionInfoScript.Show();
				homunclusRevolutionScript._Hide();
			}
			homunculusWndEnchantCommunionDiceScript.Show();
			break;
		case Revolution:
			homunclusRevolutionScript._Show();
			break;
		default:
			break;
	}
	if(DialogIsMine())
	{
		Class'InterfaceClassic.DialogBox'.static.Inst().HideDialog();
	}
	currState = NewState;
	return;
}

function SetNotice(int Type)
{
	switch(Type)
	{
		case 0:
			conditionBirth = true;
			break;
		case 1:
			conditionEnchant = true;
			break;
		default:
			break;
	}
	ArarmOnOff((conditionBirth || conditionEnchant));
	return;
}

function HideNotice(int Type)
{
	switch(Type)
	{
		case 0:
			conditionBirth = false;
			break;
		case 1:
			conditionEnchant = false;
			break;
		default:
			break;
	}
	ArarmOnOff((conditionBirth || conditionEnchant));
	return;
}

function ArarmOnOff(bool isOn)
{
	local AnimTextureHandle Anim;
	local SideBar SideBarScript;

	SideBarScript = SideBar(GetScript("SideBar"));
	if((SideBarScript._IsAlarmActived(TYPE_HOMUNCULUSWND) == isOn))
	{
		return;
	}
	Anim = SideBarScript.GetEffectAniTextureByIndex(13, 0);
	if(isOn)
	{
		SideBarScript.SetAlarmOnOff(13, true);
		Anim.ShowWindow();
		Anim.Stop();
		Anim.SetLoopCount(1);
		Anim.Play();
		SideBarScript._SpawnEffect(13, "LineageEffect2.ui_star_circle");
	}
	else
	{
		SideBarScript.SetAlarmOnOff(13, false);
		Anim.Stop();
		Anim.HideWindow();
		SideBarScript._DeSpawnEffect(13);
	}
	return;
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

function string GetGradeString(int Type)
{
	switch(Type)
	{
		case 0:
			return GetSystemString(441);
			break;
		case 1:
			return GetSystemString(3290);
			break;
		case 2:
			return GetSystemString(13336);
			break;
		case 3:
			return GetSystemString(13144);
			break;
		default:
			break;
	}
	return "";
}

function bool ChkSerVer()
{
	return getInstanceUIData().GetIsLiveServer();
}
