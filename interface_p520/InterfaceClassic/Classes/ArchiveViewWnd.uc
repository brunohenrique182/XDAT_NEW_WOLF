class ArchiveViewWnd extends GFxUIScript;

const FLASH_XPOS = 0;
const FLASH_YPOS = -50;
const cuttingCriteria = 1000000000;
const cuttingCriteriaCipher = 9;

var int currentScreenWidth;
var int currentScreenHeight;
var bool isFlashLoaded;
var int preloadedPledgeID;
var int preloadedCrestID;

function OnRegisterEvent()
{
	return;
}

function OnLoad()
{
	RegisterState("ArchiveViewWnd", "GamingState");
	SetClosingOnESC();
	isFlashLoaded = false;
	return;
}

function OnShow()
{
	PlayConsoleSound(IFST_MAPWND_OPEN);
	return;
}

function OnHide()
{
	PlayConsoleSound(IFST_MAPWND_CLOSE);
	dispatchEventToFlash_String(11, "");
	return;
}

function dispatchEventToFlash_String(int Event_ID, string argString)
{
	local array<GFxValue> args;
	local GFxValue invokeResult;

	AllocGFxValues(args, 2);
	AllocGFxValue(invokeResult);
	args[0].SetInt(Event_ID);
	CreateObject(args[1]);
	args[1].SetMemberString("string", argString);
	Invoke("_root.onEvent", args, invokeResult);
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
	return;
}

function OnFlashLoaded()
{
	local array<GFxValue> args;
	local GFxValue invokeResult;
	local float xLoc, yLoc;

	RegisterDelegateHandler(EDHandler_Statistic);
	setTableContent(Class'NWindow.StatisticAPI'.static.GetTableOfContent());
	beforeFlashLoadedEvent();
	isFlashLoaded = true;
	if(IsSavedInfo())
	{
		SetGFxFromSavedInfo();
	}
	else
	{
		AllocGFxValues(args, 2);
		AllocGFxValue(invokeResult);
		GetAnchorPointFromWindow(xLoc, yLoc, ANCHORPOINT_CenterCenter);
		args[0].SetInt((int(xLoc) + 0));
		args[1].SetInt((int(yLoc) + -50));
		Invoke("_root.onMove", args, invokeResult);
		DeallocGFxValue(invokeResult);
		DeallocGFxValues(args);
	}
	return;
}

function beforeFlashLoadedEvent()
{
	return;
}

function OnDefaultPosition()
{
	return;
}

function OnCallUCLogic(int logicID, string param)
{
	return;
}

function OnFocus(bool bFlag, bool bTransparency)
{
	local array<GFxValue> args;
	local GFxValue invokeResult;

	AllocGFxValues(args, 2);
	args[0].SetBool(bFlag);
	args[1].SetBool(bTransparency);
	AllocGFxValue(invokeResult);
	Invoke("_root.onFocus", args, invokeResult);
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
	return;
}

function setTableContent(string param)
{
	local UserInfo UserInfo;
	local int i, j, k, depth2Max, depth3Max, tmpSize0, tmpID1;
	local string tmpName1;
	local int tmpSize1, tmpID2;
	local string tmpName2;
	local int tmpSize2, tmpID3;
	local string tmpName3;
	local int tmpSize3;
	local array<GFxValue> args;
	local GFxValue invokeResult, argArray_1, argArray_2, argArray_3, ArrayElem;

	AllocGFxValues(args, 2);
	AllocGFxValue(argArray_1);
	AllocGFxValue(argArray_2);
	AllocGFxValue(argArray_3);
	AllocGFxValue(invokeResult);
	AllocGFxValue(ArrayElem);
	args[0].SetInt(4);
	CreateObject(args[1]);
	CreateArray(argArray_1);
	CreateArray(argArray_2);
	CreateArray(argArray_3);
	depth2Max = 0;
	depth3Max = 0;
	ParseInt(param, "Content_Size", tmpSize0);
	args[1].SetMemberInt("depth0Size", tmpSize0);
	GetPlayerInfo(UserInfo);
	args[1].SetMemberString("userName", UserInfo.Name);
	i = 0;
	while((i < tmpSize0))
	{
		CreateObject(ArrayElem);
		ParseInt(param, (("Content_" $ string(i)) $ "_ID"), tmpID1);
		ParseString(param, (("Content_" $ string(i)) $ "_Name"), tmpName1);
		ParseInt(param, (("Content_" $ string(i)) $ "_Size"), tmpSize1);
		ArrayElem.SetMemberInt("ID", tmpID1);
		ArrayElem.SetMemberString("name", tmpName1);
		ArrayElem.SetMemberInt("size", tmpSize1);
		argArray_1.SetElement(i, ArrayElem);
		j = 0;
		while((j < tmpSize1))
		{
			CreateObject(ArrayElem);
			ParseInt(param, (((("Content_" $ string(i)) $ "_") $ string(j)) $ "_ID"), tmpID2);
			ParseString(param, (((("Content_" $ string(i)) $ "_") $ string(j)) $ "_Name"), tmpName2);
			ParseInt(param, (((("Content_" $ string(i)) $ "_") $ string(j)) $ "_Size"), tmpSize2);
			ArrayElem.SetMemberInt("ID", tmpID2);
			ArrayElem.SetMemberString("name", tmpName2);
			ArrayElem.SetMemberInt("size", tmpSize2);
			argArray_2.SetElement((depth2Max + j), ArrayElem);
			k = 0;
			while((k < tmpSize2))
			{
				CreateObject(ArrayElem);
				ParseInt(param, (((((("Content_" $ string(i)) $ "_") $ string(j)) $ "_") $ string(k)) $ "_ID"), tmpID3);
				ParseString(param, (((((("Content_" $ string(i)) $ "_") $ string(j)) $ "_") $ string(k)) $ "_Name"), tmpName3);
				ParseInt(param, (((((("Content_" $ string(i)) $ "_") $ string(j)) $ "_") $ string(k)) $ "_Size"), tmpSize3);
				ArrayElem.SetMemberInt("ID", tmpID3);
				ArrayElem.SetMemberString("name", tmpName3);
				ArrayElem.SetMemberInt("size", tmpSize3);
				argArray_3.SetElement((depth3Max + k), ArrayElem);
				k++;
			}
			depth3Max = (depth3Max + tmpSize2);
			j++;
		}
		depth2Max = (depth2Max + tmpSize1);
		i++;
	}
	args[1].SetMemberValue("depth1ListArray", argArray_1);
	args[1].SetMemberValue("depth2ListArray", argArray_2);
	args[1].SetMemberValue("depth3ListArray", argArray_3);
	Invoke("_root.onEvent", args, invokeResult);
	DeallocGFxValue(argArray_1);
	DeallocGFxValue(argArray_2);
	DeallocGFxValue(argArray_3);
	DeallocGFxValue(ArrayElem);
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int i, Id;
	local UIEventManager.EStatisticUnitType Type;
	local int tmpSize;
	local string tmpName;
	local INT64 tmpValue, tmpValue2;
	local int tmpDiff, tmpPledgeID, tmpPledgeCrestID, ZeroInvisible;
	local string Unit;
	local int UnitType;
	local string content;
	local UserInfo UserInfo;
	local GFxValue argArray_Month, argArray_Total, argArray_Record;
	local array<GFxValue> args;
	local GFxValue invokeResult, ArrayElem;

	if((Event_ID == 150))
	{
		AllocGFxValues(args, 2);
		AllocGFxValue(invokeResult);
		args[0].SetInt(2);
		CreateObject(args[1]);
		GetPlayerInfo(UserInfo);
		args[1].SetMemberString("userName", UserInfo.Name);
		Invoke("_root.onEvent", args, invokeResult);
		DeallocGFxValue(invokeResult);
		DeallocGFxValues(args);
	}
	else if((Event_ID == 40))
	{
		AllocGFxValues(args, 2);
		AllocGFxValue(invokeResult);
		args[0].SetInt(3);
		Invoke("_root.onEvent", args, invokeResult);
		DeallocGFxValue(invokeResult);
		DeallocGFxValues(args);
	}
	else if((Event_ID == 5590))
	{
		if((IsShowWindow() == false))
		{
			ShowWindow();
		}
		else
		{
			HideWindow();
		}
	}
	else if((Event_ID == 5594))
	{
		AllocGFxValues(args, 2);
		AllocGFxValue(argArray_Month);
		AllocGFxValue(argArray_Total);
		AllocGFxValue(invokeResult);
		AllocGFxValue(ArrayElem);
		args[0].SetInt(5);
		CreateObject(args[1]);
		CreateArray(argArray_Month);
		CreateArray(argArray_Total);
		ParseInt(param, "ID", Id);
		ParseInt(Class'NWindow.StatisticAPI'.static.GetContentInfo(Id), "UnitType", UnitType);
		Type = EStatisticUnitType(UnitType);
		if(((int(Type) == 0) || (int(Type) == 4)))
		{
			ParseString(Class'NWindow.StatisticAPI'.static.GetContentInfo(Id), "Unit", Unit);
		}
		else
		{
			Unit = "";
		}
		args[1].SetMemberString("Unit", Unit);
		ParseInt(param, "SizeOfMonth", tmpSize);
		args[1].SetMemberInt("SizeOfMonth", tmpSize);
		i = 0;
		while((i < tmpSize))
		{
			CreateObject(ArrayElem);
			ParseString(param, ("MonthName_" $ string(i)), tmpName);
			ParseINT64(param, ("MonthValue_" $ string(i)), tmpValue);
			ParseInt(param, ("MonthDiff_" $ string(i)), tmpDiff);
			ParseInt(param, ("MonthPledgeID_" $ string(i)), tmpPledgeID);
			ParseInt(param, ("MonthPledgeCrestID_" $ string(i)), tmpPledgeCrestID);
			ArrayElem.SetMemberString("name", tmpName);
			if(((int(Type) == 0) || (int(Type) == 4)))
			{
				ArrayElem.SetMemberString("value", valueNumToStr(tmpValue));
			}
			else
			{
				ArrayElem.SetMemberString("value", setTimeString(tmpValue));
			}
			ArrayElem.SetMemberInt("diff", tmpDiff);
			ArrayElem.SetMemberInt("pledgeID", tmpPledgeID);
			ArrayElem.SetMemberInt("pledgeCrestID", tmpPledgeCrestID);
			argArray_Month.SetElement(i, ArrayElem);
			i++;
		}
		ParseInt(param, "SizeOfTotal", tmpSize);
		args[1].SetMemberInt("SizeOfTotal", tmpSize);
		i = 0;
		while((i < tmpSize))
		{
			CreateObject(ArrayElem);
			ParseString(param, ("TotalName_" $ string(i)), tmpName);
			ParseINT64(param, ("TotalValue_" $ string(i)), tmpValue);
			ParseInt(param, ("TotalDiff_" $ string(i)), tmpDiff);
			ParseInt(param, ("TotalPledgeID_" $ string(i)), tmpPledgeID);
			ParseInt(param, ("TotalPledgeCrestID_" $ string(i)), tmpPledgeCrestID);
			ArrayElem.SetMemberString("name", tmpName);
			if(((int(Type) == 0) || (int(Type) == 4)))
			{
				ArrayElem.SetMemberString("value", valueNumToStr(tmpValue));
			}
			else
			{
				ArrayElem.SetMemberString("value", setTimeString(tmpValue));
			}
			ArrayElem.SetMemberInt("diff", tmpDiff);
			ArrayElem.SetMemberInt("pledgeID", tmpPledgeID);
			ArrayElem.SetMemberInt("pledgeCrestID", tmpPledgeCrestID);
			argArray_Total.SetElement(i, ArrayElem);
			i++;
		}
		args[1].SetMemberValue("array_Total", argArray_Total);
		args[1].SetMemberValue("array_Month", argArray_Month);
		Invoke("_root.onEvent", args, invokeResult);
		DeallocGFxValue(argArray_Month);
		DeallocGFxValue(argArray_Total);
		DeallocGFxValue(ArrayElem);
		DeallocGFxValue(invokeResult);
		DeallocGFxValues(args);
	}
	else if((Event_ID == 5595))
	{
		AllocGFxValues(args, 2);
		AllocGFxValue(argArray_Record);
		AllocGFxValue(invokeResult);
		AllocGFxValue(ArrayElem);
		args[0].SetInt(6);
		CreateObject(args[1]);
		CreateArray(argArray_Record);
		GetPlayerInfo(UserInfo);
		args[1].SetMemberString("userName", UserInfo.Name);
		ParseInt(param, "SizeOfRecord", tmpSize);
		args[1].SetMemberInt("SizeOfRecord", tmpSize);
		i = 0;
		while((i < tmpSize))
		{
			CreateObject(ArrayElem);
			ParseInt(param, ("ID_" $ string(i)), Id);
			content = Class'NWindow.StatisticAPI'.static.GetContentInfo(Id);
			ParseInt(content, "UnitType", UnitType);
			Type = EStatisticUnitType(UnitType);
			if(((int(Type) == 0) || (int(Type) == 4)))
			{
				ParseString(content, "Unit", Unit);
			}
			else
			{
				Unit = "";
			}
			ParseInt(content, "ZeroInvisible", ZeroInvisible);
			tmpName = Class'NWindow.StatisticAPI'.static.GetTitleNameOfStatistic(Id);
			ParseINT64(param, ("MonthValue_" $ string(i)), tmpValue);
			ParseINT64(param, ("TotalValue_" $ string(i)), tmpValue2);
			ArrayElem.SetMemberString("Unit", Unit);
			ArrayElem.SetMemberString("name", tmpName);
			if(((int(Type) == 0) || (int(Type) == 4)))
			{
				ArrayElem.SetMemberString("MonthValue", valueNumToStr(tmpValue));
				ArrayElem.SetMemberString("TotalValue", valueNumToStr(tmpValue2));
			}
			else
			{
				ArrayElem.SetMemberString("MonthValue", setTimeString(tmpValue));
				ArrayElem.SetMemberString("TotalValue", setTimeString(tmpValue2));
			}
			ArrayElem.SetMemberInt("ZeroInvisible", ZeroInvisible);
			argArray_Record.SetElement(i, ArrayElem);
			i++;
		}
		args[1].SetMemberValue("array_Record", argArray_Record);
		Invoke("_root.onEvent", args, invokeResult);
		DeallocGFxValue(argArray_Record);
		DeallocGFxValue(ArrayElem);
		DeallocGFxValue(invokeResult);
		DeallocGFxValues(args);
	}
	if((Event_ID == 9220))
	{
		ParseInt(param, "PledgeID", tmpPledgeID);
		ParseInt(param, "CrestID", tmpPledgeCrestID);
		if(isFlashLoaded)
		{
			AllocGFxValues(args, 2);
			AllocGFxValue(invokeResult);
			args[0].SetInt(10);
			CreateObject(args[1]);
			args[1].SetMemberInt("PledgeID", tmpPledgeID);
			args[1].SetMemberInt("CrestID", tmpPledgeCrestID);
			Invoke("_root.onEvent", args, invokeResult);
			DeallocGFxValue(invokeResult);
			DeallocGFxValues(args);
		}
		else
		{
			preloadedPledgeID = tmpPledgeID;
			preloadedCrestID = tmpPledgeCrestID;
		}
	}
	return;
}

function string valueNumToStr(INT64 tmpValue)
{
	local string returnStr;

	if((tmpValue > INT64(0)))
	{
		returnStr = getValueCuttingCriteria(tmpValue, INT64(1000000000), 0);
		returnStr = ConvertNumToTextNoAdena(returnStr);
		return returnStr;
	}
	return "0";
}

function string getValueCuttingCriteria(INT64 tmpValue, INT64 criteria, int Num)
{
	if((Num > 5))
	{
		return "0";
	}
	if((tmpValue > criteria))
	{
		return getValueCuttingCriteria(tmpValue, (criteria * INT64(1000000000)), (Num + 1));
	}
	else
	{
		return CeilingNum(string(tmpValue), (9 * Num));
	}
}

function string setTimeString(INT64 tmpTime)
{
	local INT64 tmpDay, tmpHou, tmpMin;
	local string timeStr;
	local int minToHou, minToDay;

	minToHou = 60;
	minToDay = (minToHou * 24);
	tmpMin = (tmpTime / INT64(60));
	if((tmpMin > INT64(minToDay)))
	{
		tmpHou = (tmpMin / INT64(60));
		tmpDay = (tmpHou / INT64(24));
		tmpHou = (tmpHou - (tmpDay * INT64(24)));
		if((tmpHou != INT64(0)))
		{
			timeStr = MakeFullSystemMsg(GetSystemMessage(3503), MakeCostString(string(tmpDay)), string(tmpHou));
		}
		else
		{
			timeStr = MakeFullSystemMsg(GetSystemMessage(3418), MakeCostString(string(tmpDay)));
		}
	}
	else if((tmpMin > INT64(60)))
	{
		tmpHou = (tmpMin / INT64(60));
		tmpMin = (tmpMin - (tmpHou * INT64(60)));
		if((tmpMin != INT64(0)))
		{
			timeStr = MakeFullSystemMsg(GetSystemMessage(3304), string(tmpHou), string(tmpMin));
		}
		else
		{
			timeStr = MakeFullSystemMsg(GetSystemMessage(3406), string(tmpHou));
		}
	}
	else
	{
		timeStr = MakeFullSystemMsg(GetSystemMessage(3390), string(tmpMin));
	}
	return timeStr;
}

function OnReceivedCloseUI()
{
	local array<GFxValue> args;
	local GFxValue invokeResult;

	AllocGFxValues(args, 1);
	Invoke("_root.onReceivedCloseUI", args, invokeResult);
	DeallocGFxValue(invokeResult);
	DeallocGFxValues(args);
	return;
}
