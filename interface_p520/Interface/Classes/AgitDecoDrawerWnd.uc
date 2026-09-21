class AgitDecoDrawerWnd extends UICommonAPI;

const DIALOG_ID_ASK_DELOPY = 10212322;
const POWER_ENVOY_TYPE = 1000;
const TOTAL_COMBO_TYPE = 9999;

var WindowHandle Me;
var TextBoxHandle Title_Faction_text;
var TextBoxHandle Title_NPCtype_text;
var TextBoxHandle Title_NPCcontents_text;
var ComboBoxHandle NPCType_Combobox;
var WindowHandle AgitNPC_ListWnd;
var ListCtrlHandle AgitNPCListCtrl;
var ButtonHandle Place_Button;
var ButtonHandle Close_Button;
var AgitDecoWnd AgitDecoWndScript;
var array<AgitDecoNPCData> AgitDecoNPCDataArray;
var array<AgitDecoNPCTypeList> NpcTypeArray;
var bool listClickedEnable;

function OnRegisterEvent()
{
	RegisterEvent(1710);
	RegisterEvent(1720);
	return;
}

function OnDrawerHideFinished()
{
	listClickedEnable = false;
	return;
}

function OnDrawerShowFinished()
{
	listClickedEnable = true;
	return;
}

function OnShow()
{
	local int i;

	SetClosingOnESC();
	NpcTypeArray.Length = 0;
	AgitDecoNPCDataArray.Length = 0;
	Class'NWindow.UIDATA_AGIT'.static.GetAllDecoNPCInfo(AgitDecoNPCDataArray, NpcTypeArray, AgitDecoWndScript.getDomainGrade(), AgitDecoWndScript.getDomainArray());
	NPCType_Combobox.Clear();
	NPCType_Combobox.AddStringWithReserved(GetSystemString(1046), 9999);
	i = 0;
	while((i < NpcTypeArray.Length))
	{
		NPCType_Combobox.AddStringWithReserved(GetSystemString(NpcTypeArray[i].NpcTypeIdx), NpcTypeArray[i].NpcType);
		i++;
	}
	if((NpcTypeArray.Length > 0))
	{
		NPCType_Combobox.SetSelectedNum(0);
		upateAgitDecoNpcData(NPCType_Combobox.GetReserved(0));
	}
	return;
}

function updateComboAndList(int NpcType)
{
	local int i;

	if((NpcType == 1000))
	{
		NPCType_Combobox.AddStringWithReserved(GetSystemString(NpcTypeArray[0].NpcTypeIdx), NpcTypeArray[0].NpcType);
		NPCType_Combobox.DisableWindow();
		upateAgitDecoNpcData(NpcTypeArray[0].NpcType);
	}
	else
	{
		NPCType_Combobox.EnableWindow();
		NPCType_Combobox.Clear();
		NPCType_Combobox.AddStringWithReserved(GetSystemString(1046), 9999);
		i = 1;
		while((i < NpcTypeArray.Length))
		{
			NPCType_Combobox.AddStringWithReserved(GetSystemString(NpcTypeArray[i].NpcTypeIdx), NpcTypeArray[i].NpcType);
			i++;
		}
		NPCType_Combobox.SetSelectedNum(0);
		upateAgitDecoNpcData(9999);
	}
	return;
}

function AgitDecoNPCData getAgitDecoNPCDataByNpcID(int NpcID)
{
	local int i;
	local AgitDecoNPCData rAgitDecoNPCData;

	i = 0;
	while((i < AgitDecoNPCDataArray.Length))
	{
		if((AgitDecoNPCDataArray[i].NpcID == NpcID))
		{
			rAgitDecoNPCData = AgitDecoNPCDataArray[i];
			break;
		}
		i++;
	}
	return rAgitDecoNPCData;
}

function OnLoad()
{
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("AgitDecoDrawerWnd");
	Title_Faction_text = GetTextBoxHandle("AgitDecoDrawerWnd.Title_Faction_text");
	Title_NPCtype_text = GetTextBoxHandle("AgitDecoDrawerWnd.Title_NPCtype_text");
	Title_NPCcontents_text = GetTextBoxHandle("AgitDecoDrawerWnd.Title_NPCcontents_text");
	NPCType_Combobox = GetComboBoxHandle("AgitDecoDrawerWnd.NPCType_Combobox");
	AgitNPCListCtrl = GetListCtrlHandle("AgitDecoDrawerWnd.AgitNPC_ListWnd.AgitNPCListCtrl");
	Place_Button = GetButtonHandle("AgitDecoDrawerWnd.Place_Button");
	Close_Button = GetButtonHandle("AgitDecoDrawerWnd.Close_Button");
	AgitNPCListCtrl.DeleteAllItem();
	AgitNPCListCtrl.SetSelectedSelTooltip(false);
	AgitNPCListCtrl.SetAppearTooltipAtMouseX(true);
	AgitDecoWndScript = AgitDecoWnd(GetScript("AgitDecoWnd"));
	AgitDecoNPCDataArray.Length = 0;
	return;
}

function upateAgitDecoNpcData(int selectedNpcType)
{
	local int i, N, currentDecoNpcType;
	local string priceTokenParam;
	local L2FactionUIData FactionData;
	local string titleStr;
	local bool bDeployMent, bUseButton;
	local int addAdenaCnt;

	currentDecoNpcType = AgitDecoWndScript.getCurrentNpcType();
	Debug(("currentDecoNpcType" @ string(currentDecoNpcType)));
	AgitNPCListCtrl.DeleteAllItem();
	if(((currentDecoNpcType != 1000) || (currentDecoNpcType <= 0)))
	{
		AddItem(GetSystemString(869), priceTokenParam, "", 0, 0, false);
	}
	i = 0;
	while((i < AgitDecoNPCDataArray.Length))
	{
		if(((selectedNpcType != AgitDecoNPCDataArray[i].NpcType) && (selectedNpcType != 9999)))
		{
			i++;
			continue;
		}
		if(((selectedNpcType != 1000) && (AgitDecoNPCDataArray[i].NpcType == 1000)))
		{
			i++;
			continue;
		}
		priceTokenParam = "";
		addAdenaCnt = 0;
		if((AgitDecoNPCDataArray[i].PriceAdena > INT64(0)))
		{
			addAdenaCnt++;
		}
		ParamAdd(priceTokenParam, "totalCnt", string((addAdenaCnt + AgitDecoNPCDataArray[i].PriceToken.Length)));
		ParamAdd(priceTokenParam, "item_0", string(57));
		ParamAdd(priceTokenParam, "count_0", string(AgitDecoNPCDataArray[i].PriceAdena));
		N = 0;
		while((N < AgitDecoNPCDataArray[i].PriceToken.Length))
		{
			ParamAdd(priceTokenParam, ("item_" $ string((N + 1))), string(AgitDecoNPCDataArray[i].PriceToken[N].ItemClassID));
			ParamAdd(priceTokenParam, ("count_" $ string((N + 1))), string(AgitDecoNPCDataArray[i].PriceToken[N].Cnt));
			N++;
		}
		ParamAdd(priceTokenParam, "desc", AgitDecoNPCDataArray[i].Desc);
		ParamAdd(priceTokenParam, "period", string(AgitDecoNPCDataArray[i].Period));
		if((AgitDecoNPCDataArray[i].FactionType > 0))
		{
			GetFactionData(AgitDecoNPCDataArray[i].FactionType, FactionData);
			titleStr = ((((("Lv." $ string(AgitDecoNPCDataArray[i].Level)) $ " ") $ FactionData.strFactionName) $ "-") $ GetSystemString(AgitDecoNPCDataArray[i].SubTypeIdx));
		}
		else
		{
			titleStr = ((("Lv." $ string(AgitDecoNPCDataArray[i].Level)) $ " ") $ GetSystemString(AgitDecoNPCDataArray[i].SubTypeIdx));
		}
		bDeployMent = AgitDecoWndScript.getCurrentDeployMentSlotByNpcID(AgitDecoNPCDataArray[i].DecoNpcId);
		if(bDeployMent)
		{
			bUseButton = true;
		}
		AddItem(titleStr, priceTokenParam, AgitDecoNPCDataArray[i].Desc, AgitDecoNPCDataArray[i].Period, AgitDecoNPCDataArray[i].DecoNpcId, bDeployMent);
		i++;
	}
	if((bUseButton && (currentDecoNpcType == 1000)))
	{
		Place_Button.DisableWindow();
	}
	else
	{
		Place_Button.EnableWindow();
	}
	return;
}

function AddItem(string viewStr, string tokenPriceParam, string functionDesc, int periodSec, int DecoNpcId, bool bDeployMent)
{
	local LVDataRecord Record;

	Record.LVDataList.Length = 1;
	Record.nReserved1 = INT64(DecoNpcId);
	Record.nReserved2 = INT64(boolToNum(bDeployMent));
	if(bDeployMent)
	{
		Record.LVDataList[0].bUseTextColor = true;
		Record.LVDataList[0].TextColor = GetColor(238, 170, 34, 255);
		viewStr = ((((viewStr $ " ") $ "(") $ GetSystemString(3441)) $ ")");
	}
	if((viewStr == GetSystemString(869)))
	{
		Record.LVDataList[0].bUseTextColor = true;
		Record.LVDataList[0].TextColor = GetColor(255, 102, 102, 255);
	}
	Record.LVDataList[0].szData = viewStr;
	Record.LVDataList[0].textAlignment = TA_Left;
	Record.szReserved = tokenPriceParam;
	AgitNPCListCtrl.InsertRecord(Record);
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Place_Button":
			OnPlace_ButtonClick();
			break;
		case "Close_Button":
			OnClose_ButtonClick();
			break;
		default:
			break;
	}
	return;
}

function OnPlace_ButtonClick()
{
	Debug("배치 클릭");  // EN: placement click
	selectListNpc();
	return;
}

function OnClose_ButtonClick()
{
	Me.HideWindow();
	return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	switch(ListCtrlID)
	{
		case "AgitNPCListCtrl":
			if(listClickedEnable)
			{
				selectListNpc();
			}
			break;
		default:
			break;
	}
	return;
}

function selectListNpc()
{
	local LVDataRecord Record;
	local int messageNum;

	if(Place_Button.IsEnableWindow())
	{
		if((AgitNPCListCtrl.GetSelectedIndex() >= 0))
		{
			AgitNPCListCtrl.GetSelectedRec(Record);
			if((Record.nReserved2 == INT64(0)))
			{
				Debug(("record.LVDataList[0].szData" @ Record.LVDataList[0].szData));
				DialogSetID(10212322);
				if((AgitDecoWndScript.getCurrentNpcType() == 1000))
				{
					messageNum = 4383;
				}
				else if((Record.LVDataList[0].szData == GetSystemString(869)))
				{
					messageNum = 4384;
				}
				else
				{
					messageNum = 4366;
				}
				DialogShow(DialogModalType_Modal, DialogType_OKCancel, GetSystemMessage(messageNum));
			}
			else
			{
				Debug("이미 배치 된 경우다");  // EN: this is the already-placed case
			}
		}
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 1710))
	{
		HandleDialogOK();
	}
	else if((Event_ID == 1720))
	{
		HandleDialogCancel();
	}
	return;
}

function HandleDialogOK()
{
	if(DialogIsMine())
	{
		switch(DialogGetID())
		{
			case 10212322:
				requestDeployment();
				break;
			default:
				break;
		}
	}
	return;
}

function requestDeployment()
{
	local int AgitID, SlotNum, DecoNpcId;
	local LVDataRecord Record;

	AgitNPCListCtrl.GetSelectedRec(Record);
	AgitID = AgitDecoWndScript.getCurrentAgitID();
	SlotNum = AgitDecoWndScript.getCurrentSelectedSlotNum();
	DecoNpcId = int(Record.nReserved1);
	Class'NWindow.UIDATA_AGIT'.static.RequestCheckAvailability(AgitID, SlotNum, DecoNpcId);
	Debug("Call---- > RequestCheckAvailability()");
	Debug(("agitID:" @ string(AgitID)));
	Debug(("slotNum:" @ string(SlotNum)));
	Debug(("decoNpcId:" @ string(DecoNpcId)));
	return;
}

function HandleDialogCancel()
{
	if(DialogIsMine())
	{
		switch(DialogGetID())
		{
			case 10212322:
				Debug("안함 아무것도");  // EN: doing nothing
				break;
			default:
				break;
		}
	}
	return;
}

function OnComboBoxItemSelected(string strID, int IndexID)
{
	switch(strID)
	{
		case "NPCType_Combobox":
			upateAgitDecoNpcData(NPCType_Combobox.GetReserved(IndexID));
			break;
		default:
			break;
	}
	return;
}

function array<AgitDecoNPCTypeList> getNpcTypeArray()
{
	return NpcTypeArray;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
