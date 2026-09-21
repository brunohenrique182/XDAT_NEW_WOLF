class TradeWnd extends UICommonAPI;

const DIALOG_ID_TRADE_REQUEST = 323;
const DIALOG_ID_ITEM_NUMBER = 324;

var string m_Windowname;
var L2Util util;

function OnRegisterEvent()
{
	RegisterEvent(1710);
	RegisterEvent(1720);
	RegisterEvent(1950);
	RegisterEvent(1960);
	RegisterEvent(1970);
	RegisterEvent(1980);
	RegisterEvent(1990);
	RegisterEvent(2000);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	OnRegisterEvent();
	return;
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	return;
}

function OnSendPacketWhenHiding()
{
	RequestTradeDone(false);
	return;
}

function OnHide()
{
	Clear();
	RequestTradeDone(false);
	return;
}

function OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case 1950:
			HandleStartTrade(param);
			break;
		case 1960:
			HandleTradeAddItem(param);
			break;
		case 1970:
			HandleTradeDone(param);
			break;
		case 1980:
			HandleTradeOtherOK(param);
			break;
		case 1990:
			HandleTradeUpdateInventoryItem(param);
			break;
		case 2000:
			HandleReceiveStartTrade(param);
			break;
		case 1710:
			HandleDialogOK();
			break;
		case 1720:
			HandleDialogCancel();
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string ControlName)
{
	if((ControlName == "OKButton"))
	{
		Class'NWindow.UIAPI_ITEMWINDOW'.static.SetFaded("TradeWnd.MyList", true);
		RequestTradeDone(true);
		DialogHide();
	}
	else if((ControlName == "CancelButton"))
	{
		RequestTradeDone(false);
		DialogHide();
	}
	else if((ControlName == "MoveButton"))
	{
		HandleMoveButton();
	}
	return;
}

function OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo Info;

	if((ControlName == "InventoryList"))
	{
		if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("TradeWnd.InventoryList", Index, Info))
		{
			if((IsStackableItem(Info.ConsumeType) && (Info.ItemNum != INT64(1))))
			{
				DialogSetID(324);
				DialogSetReservedItemID(Info.Id);
				DialogSetParamInt64(Info.ItemNum);
				DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""));
			}
			else
			{
				RequestAddTradeItem(Info.Id, INT64(1));
			}
		}
	}
	return;
}

function OnDropItem(string strID, ItemInfo Info, int X, int Y)
{
	if(((strID == "MyList") && (Info.DragSrcName == "InventoryList")))
	{
		if(IsStackableItem(Info.ConsumeType))
		{
			if((Info.AllItemCount > INT64(0)))
			{
				RequestAddTradeItem(Info.Id, Info.AllItemCount);
			}
			else if((Info.ItemNum == INT64(1)))
			{
				RequestAddTradeItem(Info.Id, INT64(1));
			}
			else
			{
				DialogSetID(324);
				DialogSetReservedItemID(Info.Id);
				DialogSetParamInt64(Info.ItemNum);
				DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""));
			}
		}
		else
		{
			RequestAddTradeItem(Info.Id, INT64(1));
		}
	}
	return;
}

function MoveToMyList(int Index, INT64 Num)
{
	local ItemInfo Info;

	if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("TradeWnd.InventoryList", Index, Info))
	{
		RequestAddTradeItem(Info.Id, Num);
	}
	return;
}

function HandleMoveButton()
{
	local int Selected;
	local ItemInfo Info;

	Selected = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetSelectedNum("TradeWnd.InventoryList");
	if((Selected >= 0))
	{
		Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("TradeWnd.InventoryList", Selected, Info);
		if((Info.ItemNum == INT64(1)))
		{
			MoveToMyList(Selected, INT64(1));
		}
		else
		{
			DialogSetID(324);
			DialogSetReservedItemID(Info.Id);
			DialogSetParamInt64(Info.ItemNum);
			DialogShow(DialogModalType_Modalless, DialogType_NumberPad, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""));
		}
	}
	return;
}

function HandleStartTrade(string param)
{
	local int targetID, TargetLevel, isFriend, isPledge, isMentoring, isAlliance, isGM;
	local UserInfo TargetInfo;
	local string ClanName, colorString, addStr, levelString, Name;
	local Rect itemWindowRect;

	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("TradeWnd");
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus("TradeWnd");
	ParseInt(param, "targetId", targetID);
	ParseInt(param, "targetLevel", TargetLevel);
	ParseInt(param, "IsFriend", isFriend);
	ParseInt(param, "IsPledge", isPledge);
	ParseInt(param, "IsMentoring", isMentoring);
	ParseInt(param, "IsAlliance", isAlliance);
	ParseInt(param, "IsGM", isGM);
	if((targetID > 0))
	{
		GetUserInfo(targetID, TargetInfo);
		if((TargetInfo.nClanID > 0))
		{
			ClanName = GetClanName(TargetInfo.nClanID);
			if((TargetInfo.WantHideName && (TargetInfo.JoinedDominionID > 0)))
			{
				Name = TargetInfo.RealName;
			}
			else
			{
				Name = TargetInfo.Name;
			}
			if((ClanName != ""))
			{
				addStr = " - ";
			}
			else
			{
				addStr = "";
			}
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText("TradeWnd.Targetname", ((Name $ addStr) $ ClanName));
		}
		else
		{
			if((TargetInfo.WantHideName && (TargetInfo.JoinedDominionID > 0)))
			{
				Name = TargetInfo.RealName;
			}
			else
			{
				Name = TargetInfo.Name;
			}
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText("TradeWnd.Targetname", Name);
		}
		itemWindowRect = GetItemWindowHandle("TradeWnd.InventoryList").GetRect();
		GetTextBoxHandle("TradeWnd.Targetname").SetTextEllipsisWidth(itemWindowRect.nWidth);
		GetTextBoxHandle("TradeWnd.Targetname").SetTooltipType("Text");
		GetTextBoxHandle("TradeWnd.Targetname").SetTooltipText(((Name $ addStr) $ ClanName));
		if((((((isFriend != 0) || (isPledge != 0)) || (isMentoring != 0)) || (isAlliance != 0)) || (isGM != 0)))
		{
			colorString = "Green";
		}
		else
		{
			colorString = "Red";
		}
		SetTooltipString(param);
		levelString = (Left(colorString, 1) $ GetTargetLevelIconIndex(TargetLevel));
		if((isGM != 0))
		{
			levelString = "GM";
			colorString = "Green";
		}
		GetTextureHandle("TradeWnd.ChatLevel").SetTexture(("L2UI_CT1.ChatWindow.ChatLevelIcon_" $ levelString));
		GetButtonHandle("TradeWnd.ChatLevelIcon_Btn").SetTexture(("L2UI_CT1.ChatWindow.ChatLevelIcon_Btn" $ colorString), (("L2UI_CT1.ChatWindow.ChatLevelIcon_Btn" $ colorString) $ "_down"), (("L2UI_CT1.ChatWindow.ChatLevelIcon_Btn" $ colorString) $ "_over"));
	}
	return;
}

function SetTooltipString(string param)
{
	local CustomTooltip t;
	local string charName;
	local int isFriend, isGM, isPledge, isAlliance, isMentoring;

	t.MinimumWidth = 125;
	util = L2Util(GetScript("L2Util"));
	util.setCustomTooltip(t);
	ParseString(param, "CharName", charName);
	ParseInt(param, "IsFriend", isFriend);
	ParseInt(param, "IsPledge", isPledge);
	ParseInt(param, "IsMentoring", isMentoring);
	ParseInt(param, "IsAlliance", isAlliance);
	ParseInt(param, "IsGM", isGM);
	if((isFriend != 0))
	{
		util.ToopTipInsertTitleContents(GetSystemString(2273), GetSystemString(3175), 77, 255, 99, true, true, true);
	}
	else
	{
		util.ToopTipInsertTitleContents(GetSystemString(2273), GetSystemString(3176), 255, 66, 66, true, true, true);
	}
	if((isPledge != 0))
	{
		util.ToopTipInsertTitleContents(GetSystemString(314), GetSystemString(3179), 77, 255, 99, true, true, false);
	}
	else
	{
		util.ToopTipInsertTitleContents(GetSystemString(314), GetSystemString(3180), 255, 66, 66, true, true, false);
	}
	if(((isMentoring != 0) && !getInstanceUIData().GetIsClassicServer()))
	{
		util.ToopTipInsertTitleContents(GetSystemString(2767), GetSystemString(3177), 77, 255, 99, true, true, false);
	}
	else if(!getInstanceUIData().GetIsClassicServer())
	{
		util.ToopTipInsertTitleContents(GetSystemString(2767), GetSystemString(3178), 255, 66, 66, true, true, false);
	}
	if((isAlliance != 0))
	{
		util.ToopTipInsertTitleContents(GetSystemString(490), GetSystemString(3181), 77, 255, 99, true, true, false);
	}
	else
	{
		util.ToopTipInsertTitleContents(GetSystemString(490), GetSystemString(3182), 255, 66, 66, true, true, false);
	}
	GetButtonHandle("TradeWnd.ChatLevelIcon_Btn").SetTooltipCustomType(util.getCustomToolTip());
	return;
}

function string GetTargetLevelIconIndex(int UserLevel)
{
	local int Num;

	Num = (UserLevel / 10);
	if((Num == 0))
	{
		return "01";
	}
	else
	{
		return (string(Num) $ "0");
	}
	return "01";
}

function HandleTradeAddItem(string param)
{
	local string strDest;
	local ItemInfo ItemInfo;
	local int Index;

	ParseString(param, "destination", strDest);
	ParamToItemInfo(param, ItemInfo);
	if((strDest == "inventoryList"))
	{
		strDest = "TradeWnd.InventoryList";
	}
	else if((strDest == "myList"))
	{
		strDest = "TradeWnd.MyList";
		Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight("TradeWnd.InvenWeight", (ItemInfo.ItemNum * INT64(ItemInfo.Weight)));
	}
	else if((strDest == "otherList"))
	{
		strDest = "TradeWnd.OtherList";
		Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight("TradeWnd.InvenWeight", (ItemInfo.ItemNum * INT64(ItemInfo.Weight)));
	}
	Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem(strDest, ItemInfo.Id);
	if((Index >= 0))
	{
		if(IsStackableItem(ItemInfo.ConsumeType))
		{
			Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem(strDest, Index, ItemInfo);
		}
	}
	else
	{
		Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem(strDest, ItemInfo);
	}
	return;
}

function HandleTradeDone(string param)
{
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TradeWnd");
	return;
}

function HandleTradeOtherOK(string param)
{
	Class'NWindow.UIAPI_ITEMWINDOW'.static.SetFaded("TradeWnd.OtherList", true);
	return;
}

function HandleTradeUpdateInventoryItem(string param)
{
	local ItemInfo Info;
	local string Type;
	local int Index;

	ParseString(param, "type", Type);
	ParamToItemInfo(param, Info);
	if((Type == "add"))
	{
		Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("TradeWnd.InventoryList", Info);
	}
	else if((Type == "update"))
	{
		Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem("TradeWnd.InventoryList", Info.Id);
		if((Index >= 0))
		{
			Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem("TradeWnd.InventoryList", Index, Info);
		}
	}
	else if((Type == "delete"))
	{
		Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem("TradeWnd.InventoryList", Info.Id);
		if((Index >= 0))
		{
			Class'NWindow.UIAPI_ITEMWINDOW'.static.DeleteItem("TradeWnd.InventoryList", Index);
		}
	}
	return;
}

function HandleReceiveStartTrade(string param)
{
	local int targetID;
	local UserInfo Info;
	local string Name;
	local bool bOption;

	bOption = GetOptionBool("Communication", "IsRejectingTrade");
	ParseInt(param, "targetID", targetID);
	if((bOption == true))
	{
		AnswerTradeRequest(false);
	}
	else if(((targetID > 0) && GetUserInfo(targetID, Info)))
	{
		if(IsShowWindow("DialogBox"))
		{
			RequestTradeDone(false);
			return;
		}
		if((Info.WantHideName && (Info.JoinedDominionID > 0)))
		{
			Name = Info.RealName;
		}
		else
		{
			Name = Info.Name;
		}
		DialogSetID(323);
		DialogSetCancelD(323);
		DialogSetParamInt64(INT64((10 * 1000)));
		DialogShow(DialogModalType_Modalless, DialogType_Progress, MakeFullSystemMsg(GetSystemMessage(100), Name, ""));
	}
	return;
}

function HandleDialogOK()
{
	local ItemID sID;
	local INT64 Num;

	if(DialogIsMine())
	{
		if((DialogGetID() == 323))
		{
			AnswerTradeRequest(true);
		}
		else if((DialogGetID() == 324))
		{
			sID = DialogGetReservedItemID();
			Num = INT64(DialogGetString());
			RequestAddTradeItem(sID, Num);
		}
	}
	return;
}

function HandleDialogCancel()
{
	if(DialogIsMine())
	{
		if(DialogCheckCancelByID(323))
		{
			AnswerTradeRequest(false);
		}
	}
	return;
}

function Clear()
{
	Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("TradeWnd.InventoryList");
	Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("TradeWnd.MyList");
	Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("TradeWnd.OtherList");
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("TradeWnd.TargetName", "");
	Class'NWindow.UIAPI_INVENWEIGHT'.static.ZeroWeight("TradeWnd.InvenWeight");
	DialogHide();
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	AnswerTradeRequest(false);
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_Windowname);
	return;
}

defaultproperties
{
	m_Windowname="TradeWnd"
}
