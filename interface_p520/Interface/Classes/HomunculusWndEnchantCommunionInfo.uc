class HomunculusWndEnchantCommunionInfo extends UICommonAPI
	dependson(UIPacket);

const DIALOG_ID_COMMUNION = 2;

var WindowHandle Me;
var string m_Windowname;
var L2Util util;
var TextBoxHandle text0;
var TextBoxHandle text1;
var StatusRoundHandle MainStatus;
var RichListCtrlHandle List_ListCtrl0;
var TextBoxHandle cost00_Txt;
var TextBoxHandle costMine00_Txt;
var TextBoxHandle cost01_Txt;
var TextBoxHandle costMine01_Txt;
var TextBoxHandle cost00_Txt_Dice;
var TextBoxHandle costMine00_Txt_Dice;
var TextBoxHandle cost01_Txt_Dice;
var TextBoxHandle costMine01_Txt_Dice;
var ButtonHandle btnEnchant;
var ButtonHandle btnHelp;
var HomunculusWnd HomunculusWndScript;
var HomunculusWndEnchantCommunionChart homunculusWndEnchantCommunionChartScript;
var HomunculusWndEnchantCommunionDice HomunculusWndEnchantCommunionDiceSctipt;
var HomunculusAPI.HomunEnchantData currHomunEnchantData;
var int currentindex;
var int currentEnchantPoint;
var int currentEvolutionPoint;
var INT64 mySP;
var int requestedCommunionIdx;

function ClearAll()
{
	text0.SetText("");
	text1.SetText(GetSystemString(13393));
	MainStatus.SetPoint(INT64(0), INT64(3));
	List_ListCtrl0.DeleteAllItem();
	costMine00_Txt.SetText("");
	costMine01_Txt.SetText("");
	btnEnchant.DisableWindow();
	currentindex = -1;
	return;
}

function Initialize()
{
	m_Windowname = getCurrentWindowName(string(self));
	Me = GetWindowHandle(m_Windowname);
	util = L2Util(GetScript("L2Util"));
	text0 = GetTextBoxHandle((m_Windowname $ ".text0"));
	text1 = GetTextBoxHandle((m_Windowname $ ".text1"));
	MainStatus = GetStatusRoundHandle((m_Windowname $ ".MainStatus"));
	List_ListCtrl0 = GetRichListCtrlHandle((m_Windowname $ ".List_ListCtrl0"));
	List_ListCtrl0.SetSelectable(false);
	List_ListCtrl0.SetUseStripeBackTexture(false);
	List_ListCtrl0.ShowScrollBar(false);
	List_ListCtrl0.SetAppearTooltipAtMouseX(true);
	List_ListCtrl0.SetSelectedSelTooltip(false);
	cost00_Txt = GetTextBoxHandle((m_Windowname $ ".cost00_Txt"));
	costMine00_Txt = GetTextBoxHandle((m_Windowname $ ".costMine00_Txt"));
	cost01_Txt = GetTextBoxHandle((m_Windowname $ ".cost01_Txt"));
	costMine01_Txt = GetTextBoxHandle((m_Windowname $ ".costMine01_Txt"));
	cost00_Txt_Dice = GetTextBoxHandle("HomunculusWnd.HomunculusWndEnchantCommunionDice.cost00_Txt");
	costMine00_Txt_Dice = GetTextBoxHandle("HomunculusWnd.HomunculusWndEnchantCommunionDice.costMine00_Txt");
	cost01_Txt_Dice = GetTextBoxHandle("HomunculusWnd.HomunculusWndEnchantCommunionDice.cost01_Txt");
	costMine01_Txt_Dice = GetTextBoxHandle("HomunculusWnd.HomunculusWndEnchantCommunionDice.costMine01_Txt");
	btnEnchant = GetButtonHandle((m_Windowname $ ".btnEnchant"));
	btnHelp = GetButtonHandle((m_Windowname $ ".btnHelp"));
	HomunculusWndScript = HomunculusWnd(GetScript("HomunculusWnd"));
	homunculusWndEnchantCommunionChartScript = HomunculusWndEnchantCommunionChart(GetScript("HomunculusWnd.HomunculusWndEnchantCommunionChart"));
	HomunculusWndEnchantCommunionDiceSctipt = HomunculusWndEnchantCommunionDice(GetScript("HomunculusWnd.HomunculusWndEnchantCommunionDice"));
	GetButtonHandle((m_Windowname $ ".EnchantHelp_btn")).SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(13402)));
	return;
}

function HandleGameInit()
{
	if((GetGameStateName() != "GAMINGSTATE"))
	{
		return;
	}
	currHomunEnchantData = HomunculusWndScript.API_GetHomunEnchantData();
	cost00_Txt.SetText(MakeCostString(string(currHomunEnchantData.CommunionNeedEnchantPoint)));
	cost01_Txt.SetText(MakeCostString(string(currHomunEnchantData.CommunionNeedSpPoint)));
	cost00_Txt_Dice.SetText(MakeCostString(string(currHomunEnchantData.CommunionNeedEnchantPoint)));
	cost01_Txt_Dice.SetText(MakeCostString(string(currHomunEnchantData.CommunionNeedSpPoint)));
	return;
}

function OnRegisterEvent()
{
	RegisterEvent((100000 + 867));
	RegisterEvent((100000 + 863));
	RegisterEvent((100000 + 860));
	RegisterEvent(150);
	RegisterEvent(191);
	RegisterEvent(180);
	RegisterEvent(1710);
	return;
}

function OnLoad()
{
	Initialize();
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case (100000 + 863):
			Handle_S_EX_HOMUNCULUS_POINT_INFO();
			break;
		case 150:
			if(HomunculusWndScript.ChkSerVer())
			{
				HandleGameInit();
			}
			break;
		case 191:
		case 180:
			if(Me.IsShowWindow())
			{
				SetMyStat();
			}
			break;
		case (100000 + 867):
			if(Me.IsShowWindow())
			{
				Handle_S_EX_HOMUNCULUS_HPSPVP();
			}
			break;
		case 1710:
			HandleDialogOK(true);
			break;
			break;
		case (100000 + 860):
			Handle_S_EX_ACTIVATE_HOMUNCULUS_RESULT();
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "btnEnchant":
			HandleBtnEnchant();
			break;
		case "btnClose":
			HomunculusWndScript.SetState(Main);
			break;
		default:
			break;
	}
	return;
}

function Show()
{
	ClearAll();
	SetMyStat();
	Me.ShowWindow();
	Me.SetFocus();
	return;
}

function Hide()
{
	requestedCommunionIdx = -1;
	Me.HideWindow();
	return;
}

function SetChangeHomunculusData()
{
	SetHomunculusCommunion();
	SetTooltip();
	return;
}

function SetTooltip()
{
	local CustomTooltip t;
	local HomunculusAPI.HomunculusNpcLevelData npcLevelData;
	local int i;

	util.setCustomTooltip(t);
	util.ToopTipMinWidth(200);
	util.ToopTipInsertText(GetSystemString(13391), true, true);
	util.TooltipInsertItemBlank(5);
	util.TooltipInsertItemLine();
	util.ToopTipInsertColorText(GetSkillName(GetCurrHomunculusData().SkillID[0], GetCurrHomunculusData().SkillLevel[0]), true, true, GetColor(170, 153, 119, 255));
	i = 0;
	while((i < 6))
	{
		npcLevelData = HomunculusWndScript.API_GetHomunculusNpcLevelData(GetCurrHomunculusData().Id, (i + 1));
		util.ToopTipInsertText(GetSkillName(npcLevelData.OptionSkillId[2], npcLevelData.OptionSkillLevel[2]), true, true);
		i++;
	}
	btnHelp.SetTooltipCustomType(util.getCustomToolTip());
	return;
}

function SetMyStat()
{
	local UserInfo uInfo;

	if(GetPlayerInfo(uInfo))
	{
		mySP = uInfo.nSP;
		SetNeedInfo();
	}
	return;
}

function SetNeedInfo()
{
	if((currentEnchantPoint < currHomunEnchantData.CommunionNeedEnchantPoint))
	{
		costMine00_Txt.SetTextColor(getInstanceL2Util().DRed);
		costMine00_Txt_Dice.SetTextColor(getInstanceL2Util().DRed);
	}
	else
	{
		costMine00_Txt.SetTextColor(getInstanceL2Util().BLUE01);
		costMine00_Txt_Dice.SetTextColor(getInstanceL2Util().BLUE01);
	}
	if((mySP < INT64(currHomunEnchantData.CommunionNeedSpPoint)))
	{
		costMine01_Txt.SetTextColor(getInstanceL2Util().DRed);
		costMine01_Txt_Dice.SetTextColor(getInstanceL2Util().DRed);
	}
	else
	{
		costMine01_Txt.SetTextColor(getInstanceL2Util().BLUE01);
		costMine01_Txt_Dice.SetTextColor(getInstanceL2Util().BLUE01);
	}
	costMine00_Txt.SetText((("(" $ MakeCostString(string(currentEnchantPoint))) $ ")"));
	costMine01_Txt.SetText((("(" $ MakeCostStringINT64(mySP)) $ ")"));
	costMine00_Txt_Dice.SetText((("(" $ MakeCostString(string(currentEnchantPoint))) $ ")"));
	costMine01_Txt_Dice.SetText((("(" $ MakeCostStringINT64(mySP)) $ ")"));
	CheckBtnEnchant();
	return;
}

function SetHomunculusCommunion()
{
	local int i;
	local array<string> descs;
	local string Desc;
	local ItemID Id;

	List_ListCtrl0.DeleteAllItem();
	Id.ClassID = GetCurrHomunculusData().SkillID[0];
	Desc = Class'NWindow.UIDATA_SKILL'.static.GetDescription(Id, GetCurrHomunculusData().SkillLevel[0], 0);
	Split(Desc, "^", descs);
	List_ListCtrl0.InsertRecord(makeRecord(descs[0], descs[1], true));
	i = 1;
	while((i < 6))
	{
		if((GetCurrHomunculusData().SkillLevel[i] > 0))
		{
			Id.ClassID = GetCurrHomunculusData().SkillID[i];
			Desc = Class'NWindow.UIDATA_SKILL'.static.GetDescription(Id, GetCurrHomunculusData().SkillLevel[i], 0);
			if((Desc != ""))
			{
				descs.Length = 0;
				Split(Desc, "^", descs);
				List_ListCtrl0.InsertRecord(makeRecord(descs[0], descs[1], false));
			}
		}
		i++;
	}
	return;
}

function SetEnchantpoint(int point)
{
	currentEnchantPoint = point;
	SetNeedInfo();
	return;
}

function SetEvolutionPoint(int point)
{
	currentEvolutionPoint = point;
	return;
}

function SetSelect(int Index)
{
	currentindex = Index;
	text0.SetText(string((Index + 1)));
	SetCurrSkillName();
	MainStatus.SetPoint(INT64(GetCurrHomunculusData().SkillLevel[(Index + 1)]), INT64(3));
	CheckBtnEnchant();
	return;
}

function CheckBtnEnchant()
{
	btnEnchant.DisableWindow();
	if((currentindex == -1))
	{
		return;
	}
	if((mySP < INT64(currHomunEnchantData.CommunionNeedSpPoint)))
	{
		return;
	}
	if((currentEnchantPoint < currHomunEnchantData.CommunionNeedEnchantPoint))
	{
		return;
	}
	if((GetCurrHomunculusData().SkillLevel[(currentindex + 1)] >= 3))
	{
		return;
	}
	btnEnchant.EnableWindow();
	return;
}

function Handle_S_EX_HOMUNCULUS_POINT_INFO()
{
	local UIPacket._S_EX_HOMUNCULUS_POINT_INFO packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_HOMUNCULUS_POINT_INFO(packet))
	{
		return;
	}
	SetEnchantpoint(packet.nEnchantPoint);
	SetEvolutionPoint(packet.nEvolutionPoint);
	return;
}

function Handle_S_EX_HOMUNCULUS_HPSPVP()
{
	local UIPacket._S_EX_HOMUNCULUS_HPSPVP packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_HOMUNCULUS_HPSPVP(packet))
	{
		return;
	}
	mySP = packet.nSP;
	SetNeedInfo();
	return;
}

function Handle_S_EX_ACTIVATE_HOMUNCULUS_RESULT()
{
	local UIPacket._S_EX_ACTIVATE_HOMUNCULUS_RESULT packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_ACTIVATE_HOMUNCULUS_RESULT(packet))
	{
		return;
	}
	if((packet.Type != 1))
	{
		return;
	}
	if((int(packet.bActivate) == 0))
	{
		if((requestedCommunionIdx == GetCurrHomunculusData().idx))
		{
			CheckBtnEnchant();
			if(btnEnchant.IsEnableWindow())
			{
				HomunculusWndScript.SetState(EnchantCommunion);
			}
			requestedCommunionIdx = -1;
		}
	}
	return;
}

function HandleBtnEnchant()
{
	ShowCommunionOffDialog();
	return;
}

function HandleDialogOK(bool bOK)
{
	if(!DialogIsMine())
	{
		return;
	}
	switch(DialogGetID())
	{
		case 2:
			if(!bOK)
			{
				return;
			}
			if(GetCurrHomunculusData().Activate)
			{
				btnEnchant.DisableWindow();
				requestedCommunionIdx = GetCurrHomunculusData().idx;
				HomunculusWndScript.API_C_EX_REQUEST_ACTIVATE_HOMUNCULUS(requestedCommunionIdx, !GetCurrHomunculusData().Activate);
			}
			else
			{
				HomunculusWndScript.SetState(EnchantCommunion);
			}
			break;
		default:
			break;
	}
	return;
}

function ShowCommunionOffDialog()
{
	local DialogBox dScript;

	dScript = DialogBox(GetScript("DialogBox"));
	dScript.setId(2);
	dScript._DialogShow(DialogModalType_Modal, DialogType_OKCancel, GetSystemString(13376), m_hOwnerWnd);
	return;
}

function RichListCtrlRowData makeRecord(string Name, string numString, bool isBase)
{
	local RichListCtrlRowData Record;
	local Color tmpTextColor;

	Record.cellDataList.Length = 2;
	Record.szReserved = "툴팁 정보들";  // EN?: Tooltip Information
	if(isBase)
	{
		tmpTextColor = GetColor(170, 153, 119, 255);
	}
	else
	{
		tmpTextColor = util.BrightWhite;
	}
	AddRichListCtrlString(Record.cellDataList[0].drawitems, Name, tmpTextColor, false);
	AddRichListCtrlString(Record.cellDataList[1].drawitems, numString, tmpTextColor, false, 20);
	return Record;
}

function string GetSkillName(int SkillID, int Level)
{
	local array<string> descs;
	local string Desc;
	local ItemID Id;

	Id.ClassID = SkillID;
	Desc = Class'NWindow.UIDATA_SKILL'.static.GetDescription(Id, Level, 0);
	if((Desc == ""))
	{
		return "";
	}
	Split(Desc, "^", descs);
	return (descs[0] @ descs[1]);
}

function SetCurrSkillName()
{
	local int SkillLevel;
	local ItemID Id;
	local array<string> descs;
	local string Desc;
	local HomunculusAPI.HomunculusNpcLevelData npcLevelData;

	npcLevelData = HomunculusWndScript.API_GetHomunculusNpcLevelData(GetCurrHomunculusData().Id, (currentindex + 1));
	if((GetCurrHomunculusData().SkillLevel[(currentindex + 1)] > 0))
	{
		Id.ClassID = GetCurrHomunculusData().SkillID[(currentindex + 1)];
		SkillLevel = GetCurrHomunculusData().SkillLevel[(currentindex + 1)];
		Desc = Class'NWindow.UIDATA_SKILL'.static.GetDescription(Id, SkillLevel, 0);
		Debug(("SetCurrSkillName" @ Desc));
		if((Desc == ""))
		{
			text1.SetText("");
		}
		else
		{
			Split(Desc, "^", descs);
			text1.SetText(((descs[0] $ ":") $ descs[1]));
		}
	}
	else
	{
		Id.ClassID = npcLevelData.OptionSkillId[2];
		SkillLevel = npcLevelData.OptionSkillLevel[2];
		Desc = Class'NWindow.UIDATA_SKILL'.static.GetDescription(Id, SkillLevel, 0);
		if((Desc == ""))
		{
			text1.SetText("");
		}
		else
		{
			Split(Desc, "^", descs);
			text1.SetText((((descs[0] $ ":") @ GetSystemString(3809)) $ descs[1]));
		}
	}
	return;
}

function HomunculusAPI.HomunculusData GetCurrHomunculusData()
{
	return HomunculusWndMainList(GetScript("HomunculusWnd.HomunculusWndMainList")).GetCurrHomunculusData();
}
