class CardExchangeWnd extends UICommonAPI;

const Red = true;
const Yellow = false;

var WindowHandle Me;
var TextBoxHandle DescTitle_TextBox;
var int currentCardEventType;
var int currentRewardListID;
var int currentRewardListCount;
var int currentCardCount;
var int maxCardWCount;
var int maxCardHCount;
var array<int> cardRewardListIDArray;

function OnRegisterEvent()
{
	RegisterEvent(9660);
	RegisterEvent(9670);
	RegisterEvent(9680);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("CardExchangeWnd");
	DescTitle_TextBox = GetTextBoxHandle("CardExchangeWnd.DescTitle_TextBox");
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 9660))
	{
		Debug(("EV_CardRewardStart " @ param));
		cardRewardStartHandler(param);
	}
	else if((Event_ID == 9670))
	{
		Debug(("EV_CardListProperty " @ param));
		cardListPropertyHandler(param);
	}
	else if((Event_ID == 9680))
	{
		Debug(("EV_CardProperty " @ param));
		cardPropertyHandler(param);
	}
	return;
}

function cardRewardStartHandler(string a_Param)
{
	ParseInt(a_Param, "CardEventType", currentCardEventType);
	ParseInt(a_Param, "RewardListNum", maxCardHCount);
	cardRewardListIDArray.Length = 0;
	cardRewardListIDArray.Length = 7;
	currentRewardListCount = 0;
	maxCardWCount = 0;
	return;
}

function cardListPropertyHandler(string a_Param)
{
	local int nRewardListID, nRewardCardNum, nIsEnableReward;
	local string subTitleStr;

	ParseInt(a_Param, "RewardListID", nRewardListID);
	ParseInt(a_Param, "RewardCardNum", nRewardCardNum);
	ParseInt(a_Param, "IsEnableReward", nIsEnableReward);
	GetSubTitle(currentCardEventType, nRewardListID, subTitleStr);
	currentRewardListID = nRewardListID;
	cardRewardListIDArray[currentRewardListCount] = nRewardListID;
	currentRewardListCount++;
	currentCardCount = 1;
	setCardSetText(currentRewardListCount, subTitleStr);
	showCardLine(currentRewardListCount, false);
	checkEnableReceiveButton(currentRewardListCount, nIsEnableReward);
	if((maxCardWCount < nRewardCardNum))
	{
		maxCardWCount = nRewardCardNum;
	}
	if((currentRewardListCount >= maxCardHCount))
	{
		setUISize(maxCardWCount, maxCardHCount);
		Me.ShowWindow();
		Me.SetFocus();
	}
	return;
}

function checkEnableReceiveButton(int nSetNum, int nIsEnableReward)
{
	GetButtonHandle((("CardExchangeWnd.CardList0" $ string(nSetNum)) $ "_Wnd.Receive_Button")).SetEnable(numToBool(nIsEnableReward));
	return;
}

function cardPropertyHandler(string a_Param)
{
	local int nCardID, nCardNeededNum, nCardNum;
	local string texNameStr;
	local bool bHasCard;

	ParseInt(a_Param, "CardID", nCardID);
	ParseInt(a_Param, "CardNeededNum", nCardNeededNum);
	ParseInt(a_Param, "CardNum", nCardNum);
	GetRewardCardTexName(currentCardEventType, currentRewardListID, nCardID, texNameStr);
	if((nCardNum >= nCardNeededNum))
	{
		bHasCard = true;
	}
	else
	{
		bHasCard = false;
	}
	setCardInfo(currentRewardListCount, currentCardCount, nCardID, bHasCard, texNameStr);
	currentCardCount++;
	return;
}

function setCardInfo(int nSetNum, int nCardNum, int nCardID, bool bHasCard, string cardTexture)
{
	showCard(nSetNum, nCardNum, true);
	GetTextureHandle((((("CardExchangeWnd.CardList0" $ string(nSetNum)) $ "_Wnd.Card0") $ string(nCardNum)) $ "_Wnd.Card_Texture")).SetTexture(cardTexture);
	GetButtonHandle((((("CardExchangeWnd.CardList0" $ string(nSetNum)) $ "_Wnd.Card0") $ string(nCardNum)) $ "_Wnd.Card_Btn")).SetTooltipCustomType(getCardToolTip(GetItemInfoByClassID(nCardID)));
	if(bHasCard)
	{
		GetTextureHandle((((("CardExchangeWnd.CardList0" $ string(nSetNum)) $ "_Wnd.Card0") $ string(nCardNum)) $ "_Wnd.Card_Disable_Texture")).HideWindow();
	}
	else
	{
		GetTextureHandle((((("CardExchangeWnd.CardList0" $ string(nSetNum)) $ "_Wnd.Card0") $ string(nCardNum)) $ "_Wnd.Card_Disable_Texture")).ShowWindow();
	}
	return;
}

function CustomTooltip getCardToolTip(ItemInfo item)
{
	local CustomTooltip m_Tooltip;

	m_Tooltip.DrawList.Length = 2;
	m_Tooltip.DrawList[0].eType = DIT_TEXT;
	m_Tooltip.DrawList[0].t_color.R = 255;
	m_Tooltip.DrawList[0].t_color.G = 255;
	m_Tooltip.DrawList[0].t_color.B = 255;
	m_Tooltip.DrawList[0].t_color.A = 255;
	m_Tooltip.DrawList[0].t_strText = item.Name;
	m_Tooltip.DrawList[0].bLineBreak = true;
	m_Tooltip.DrawList[1].eType = DIT_TEXTURE;
	m_Tooltip.DrawList[1].u_nTextureWidth = 242;
	m_Tooltip.DrawList[1].u_nTextureHeight = 344;
	m_Tooltip.DrawList[1].u_strTexture = item.tooltipTexutre;
	m_Tooltip.DrawList[1].bLineBreak = true;
	return m_Tooltip;
}

function OnClickButtonWithHandle(ButtonHandle ButtonHandle)
{
	switch(ButtonHandle.GetWindowName())
	{
		case "Receive_Button":
			OnReceive_ButtonClick(ButtonHandle.GetParentWindowName());
			break;
		default:
			break;
	}
	return;
}

function OnReceive_ButtonClick(string parentWndName)
{
	local int btnIndex;

	Debug(("parentWndName" @ parentWndName));
	btnIndex = (int(Mid(parentWndName, 9, 1)) - 1);
	if((cardRewardListIDArray[btnIndex] > 0))
	{
		Debug(("-- RequestCardReward -> 카드셋 id " @ string(cardRewardListIDArray[btnIndex])));  // EN: -- RequestCardReward -> card set id
		RequestCardReward(cardRewardListIDArray[btnIndex]);
	}
	return;
}

function setUISize(int nW, int nH)
{
	Me.SetWindowSize(getWindowSizeW(nW), getWindowSizeH(nH));
	hideCardSet(nH);
	showCardSet(nH);
	DescTitle_TextBox.SetText(GetSystemString(3128));
	return;
}

function int getWindowSizeW(int CardCount)
{
	if((CardCount == 7))
	{
		return 543;
	}
	else if((CardCount == 6))
	{
		return 489;
	}
	else
	{
		return 435;
	}
}

function int getWindowSizeH(int cardSetLine)
{
	if((cardSetLine == 5))
	{
		return 639;
	}
	else if((cardSetLine == 4))
	{
		return 531;
	}
	else
	{
		return 423;
	}
}

function hideCardSet(int nUseCardSet)
{
	switch(nUseCardSet)
	{
		case 1:
		case 2:
			GetWindowHandle("CardExchangeWnd.CardList03_Wnd").HideWindow();
		case 3:
			GetWindowHandle("CardExchangeWnd.CardList04_Wnd").HideWindow();
		case 4:
			GetWindowHandle("CardExchangeWnd.CardList05_Wnd").HideWindow();
		default:
			return;
	}
}

function showCardSet(int nUseCardSet)
{
	switch(nUseCardSet)
	{
		case 5:
			GetWindowHandle("CardExchangeWnd.CardList05_Wnd").ShowWindow();
		case 4:
			GetWindowHandle("CardExchangeWnd.CardList04_Wnd").ShowWindow();
		case 3:
			GetWindowHandle("CardExchangeWnd.CardList03_Wnd").ShowWindow();
		case 2:
			GetWindowHandle("CardExchangeWnd.CardList02_Wnd").ShowWindow();
		case 1:
			GetWindowHandle("CardExchangeWnd.CardList01_Wnd").ShowWindow();
		default:
			return;
	}
}

function showCard(int nSetNum, int nCardNum, bool bShow)
{
	if(bShow)
	{
		GetWindowHandle((((("CardExchangeWnd.CardList0" $ string(nSetNum)) $ "_Wnd.Card0") $ string(nCardNum)) $ "_Wnd")).ShowWindow();
	}
	else
	{
		GetWindowHandle((((("CardExchangeWnd.CardList0" $ string(nSetNum)) $ "_Wnd.Card0") $ string(nCardNum)) $ "_Wnd")).HideWindow();
	}
	return;
}

function setCardSetText(int nSetNum, string textStr)
{
	GetTextBoxHandle((("CardExchangeWnd.CardList0" $ string(nSetNum)) $ "_Wnd.Title_TextBox")).SetText(textStr);
	return;
}

function showCardLine(int nSetNum, bool bShow)
{
	local int i;

	i = 1;
	while((i < 8))
	{
		showCard(nSetNum, i, bShow);
		i++;
	}
	return;
}

function setAllWCardCount(int maxCardW)
{
	local int h, W;

	h = 1;
	while((h < 6))
	{
		showCardLine(h, false);
		W = 1;
		while((W < (maxCardW + 1)))
		{
			showCard(h, W, true);
			W++;
		}
		h++;
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
