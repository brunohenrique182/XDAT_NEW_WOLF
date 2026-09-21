class EventletterCollectorWnd extends UICommonAPI
	dependson(UIPacket);

const SET_MAX = 5;

var string m_Windowname;
var WindowHandle Me;
var int currentSetMax;
var array<LetterCollectUIData> arrLetterCollectUIData;
var array<INT64> minNums;
var int MinLevel;

function OnRegisterEvent()
{
	RegisterEvent(2610);
	RegisterEvent(10140);
	RegisterEvent(180);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Me = GetWindowHandle(m_Windowname);
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 2610:
			HandleUpdateItem(param);
			break;
		case 10140:
			Me.HideWindow();
			if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("EventletterCollectorLauncher"))
			{
				Class'NWindow.UIAPI_WINDOW'.static.HideWindow("EventletterCollectorLauncher");
			}
			break;
		case 180:
			HandleUserInfo();
			break;
		default:
			break;
	}
	return;
}

function OnShow()
{
	if(!getInstanceUIData().GetIsClassicServer())
	{
		GetWindowHandle((m_Windowname $ ".WindowHelp_BTN")).HideWindow();
	}
	Debug("EventletterCollectorWnd OnShow");
	API_GetLetterCollectData(arrLetterCollectUIData);
	SetWindow();
	Settems();
	Me.SetFocus();
	return;
}

function OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	local int Index;

	switch(a_ButtonHandle.GetWindowName())
	{
		case "LetterWndGet_Btn":
			Index = (int(Right(a_ButtonHandle.GetParentWindowName(), 1)) - 1);
			Debug(((("OnClickButtonWithHandle" @ a_ButtonHandle.GetParentWindowName()) @ string(Index)) @ string(arrLetterCollectUIData[Index].Id)));
			API_C_EX_LETTER_COLLECTOR_TAKE_REWARD(arrLetterCollectUIData[Index].Id);
			break;
		case "WindowHelp_BTN":
			HandleBtnClickHelp();
			break;
		default:
			break;
	}
	return;
}

function Settems()
{
	local int i, j, ClassID;
	local ItemInfo Info;
	local ItemWindowHandle ItemWnd;
	local LetterCollectUIData letterCollectData;
	local array<int> classIDs;
	local InventoryWnd invenScript;

	invenScript = InventoryWnd(GetScript("InventoryWnd"));
	j = 1;
	while((j <= currentSetMax))
	{
		letterCollectData = arrLetterCollectUIData[(j - 1)];
		ItemWnd = GetItemWindowByID(j);
		ItemWnd.Clear();
		i = 0;
		while((i < letterCollectData.LetterItemIDs.Length))
		{
			ClassID = letterCollectData.LetterItemIDs[i];
			checkArray(classIDs, ClassID);
			GetItemInfo(ClassID, Info);
			ItemWnd.AddItem(Info);
			i++;
		}
		j++;
	}
	i = 0;
	while((i < classIDs.Length))
	{
		HandleUpdateItemCounts(classIDs[i], invenScript.getItemCountByClassID(classIDs[i]));
		i++;
	}
	GetMinNums();
	CheckCanRewardBtns();
	return;
}

function checkArray(out array<int> classIDs, int ClassID)
{
	local int i;

	i = 0;
	while((i < classIDs.Length))
	{
		if((classIDs[i] == ClassID))
		{
			return;
		}
		i++;
	}
	classIDs.Length = (classIDs.Length + 1);
	classIDs[(classIDs.Length - 1)] = ClassID;
	return;
}

function bool GetItemInfo(int ClassID, out ItemInfo Info)
{
	local ItemInfo nullInfo;

	Info = GetItemInfoByClassID(ClassID);
	if((Info == nullInfo))
	{
		return false;
	}
	Info.bShowCount = true;
	return true;
}

function SetItemNum(INT64 ItemNum, INT64 displayNum, out ItemInfo Info)
{
	Info.ItemNum = displayNum;
	if((ItemNum < INT64(1)))
	{
		Info.bDisabled = 1;
	}
	else
	{
		Info.bDisabled = 0;
	}
	return;
}

function HandleUpdateItem(string param)
{
	local int ClassID;
	local INT64 ItemNum;
	local string Type;

	if(!Me.IsShowWindow())
	{
		return;
	}
	ParseInt(param, "ClassID", ClassID);
	ParseString(param, "type", Type);
	if((Type == "delete"))
	{
		ItemNum = INT64(0);
	}
	else
	{
		ParseINT64(param, "ItemNum", ItemNum);
	}
	HandleUpdateItemCounts(ClassID, ItemNum);
	GetMinNums();
	CheckCanRewardBtns();
	return;
}

function HandleUpdateItemCounts(int ClassID, INT64 totalNum)
{
	local int i, j;
	local INT64 tmpNum;
	local ItemWindowHandle ItemWnd;
	local ItemInfo Info;
	local LetterCollectUIData letterCollectData;

	j = 1;
	while((j <= currentSetMax))
	{
		ItemWnd = GetItemWindowByID(j);
		tmpNum = totalNum;
		letterCollectData = arrLetterCollectUIData[(j - 1)];
		i = 0;
		while((i < letterCollectData.LetterItemIDs.Length))
		{
			if((letterCollectData.LetterItemIDs[i] == ClassID))
			{
				ItemWnd.GetItem(i, Info);
				SetItemNum(tmpNum, totalNum, Info);
				tmpNum = (tmpNum - INT64(1));
				if((tmpNum < INT64(0)))
				{
					tmpNum = INT64(0);
				}
				ItemWnd.SetItem(i, Info);
			}
			i++;
		}
		j++;
	}
	return;
}

function GetMinNums()
{
	local int i, j;
	local ItemWindowHandle ItemWnd;
	local ItemInfo Info;

	minNums.Length = currentSetMax;
	j = 1;
	while((j <= currentSetMax))
	{
		ItemWnd = GetItemWindowByID(j);
		minNums[(j - 1)] = INT64(-1);
		i = 0;
		while((i < ItemWnd.GetItemNum()))
		{
			ItemWnd.GetItem(i, Info);
			if((Info.bDisabled == 1))
			{
				minNums[(j - 1)] = INT64(0);
				i++;
				continue;
			}
			if(((Info.ItemNum < minNums[(j - 1)]) || (minNums[(j - 1)] == INT64(-1))))
			{
				minNums[(j - 1)] = Info.ItemNum;
			}
			i++;
		}
		j++;
	}
	return;
}

function HandleUserInfo()
{
	if((getInstanceUIData().IsLevelUP() || getInstanceUIData().IsLevelDown()))
	{
		CheckCanRewardBtns();
	}
	return;
}

function CheckCanRewardBtns()
{
	local int i;
	local CustomTooltip t;
	local L2Util util;
	local ButtonHandle tmpBtn;
	local UserInfo uInfo;
	local bool canLevel;
	local string levelMessage;

	util = L2Util(GetScript("L2Util"));
	if(GetPlayerInfo(uInfo))
	{
		canLevel = (uInfo.nLevel >= MinLevel);
	}
	i = 1;
	while((i <= currentSetMax))
	{
		util.setCustomTooltip(t);
		util.ToopTipMinWidth(10);
		tmpBtn = GetButtonByID(i);
		if((CanReward(i) && canLevel))
		{
			tmpBtn.EnableWindow();
			util.ToopTipInsertText(((GetSystemString(2984) $ " x") $ string(minNums[(i - 1)])), true, true, COLOR_DEFAULT);
		}
		else
		{
			tmpBtn.DisableWindow();
			if(!canLevel)
			{
				levelMessage = MakeFullSystemMsg(GetSystemMessage(13070), (string(MinLevel) $ GetSystemString(537)));
				util.ToopTipInsertText(levelMessage, true, true, COLOR_GRAY);
			}
		}
		tmpBtn.SetTooltipCustomType(util.getCustomToolTip());
		i++;
	}
	return;
}

function HandleBtnClickHelp()
{
	local string strParam;

	if(getInstanceUIData().GetIsClassicServer())
	{
		if(IsAdenServer())
		{
			ParamAdd(strParam, "FilePath", (GetLocalizedL2TextPathNameUC() $ "ev_eventcollector_aden001.htm"));
		}
		else
		{
			ParamAdd(strParam, "FilePath", (GetLocalizedL2TextPathNameUC() $ "ev_eventcollector001.htm"));
		}
		ExecuteEvent(1210, strParam);
	}
	else
	{
		ParamAdd(strParam, "FilePath", (GetLocalizedL2TextPathNameUC() $ "ev_eventcollector001.htm"));
		ExecuteEvent(1210, strParam);
	}
	return;
}

function API_GetLetterCollectData(out array<LetterCollectUIData> arrLetterCollectUIData)
{
	GetLetterCollectData(arrLetterCollectUIData);
	Debug(("API_GetLetterCollectData" @ string(arrLetterCollectUIData.Length)));
	currentSetMax = arrLetterCollectUIData.Length;
	return;
}

function API_C_EX_LETTER_COLLECTOR_TAKE_REWARD(int setNo)
{
	local array<byte> stream;
	local UIPacket._C_EX_LETTER_COLLECTOR_TAKE_REWARD packet;

	packet.nSetNo = setNo;
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_LETTER_COLLECTOR_TAKE_REWARD(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(610, stream);
	return;
}

function ItemWindowHandle GetItemWindowByID(int windowIndex)
{
	return GetItemWindowHandle((((m_Windowname $ ".LetterWnd_0") $ string(windowIndex)) $ ".LetterWndItemWindow"));
}

function ButtonHandle GetButtonByID(int windowIndex)
{
	return GetButtonHandle((((m_Windowname $ ".LetterWnd_0") $ string(windowIndex)) $ ".LetterWndGet_Btn"));
}

function bool CanReward(int windowIndex)
{
	return (minNums[(windowIndex - 1)] > INT64(0));
}

function SetWindow()
{
	local int i;
	local Rect winRect;

	winRect = Me.GetRect();
	i = 1;
	while((i <= currentSetMax))
	{
		GetWindowHandle(((m_Windowname $ ".LetterWnd_0") $ string(i))).ShowWindow();
		i++;
	}
	i = (currentSetMax + 1);
	while((i <= 5))
	{
		GetWindowHandle(((m_Windowname $ ".LetterWnd_0") $ string(i))).HideWindow();
		i++;
	}
	Me.SetWindowSize(winRect.nWidth, (639 - (100 * (5 - currentSetMax))));
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="EventletterCollectorWnd"
}
