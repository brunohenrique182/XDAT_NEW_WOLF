class SkillTrainInfoWnd extends UICommonAPI;

const OFFSET_X_ICON_TEXTURE = 0;
const OFFSET_Y_ICON_TEXTURE = 4;
const OFFSET_Y_SECONDLINE = -14;
const OFFSET_Y_MPCONSUME = 3;
const OFFSET_Y_CASTRANGE = 0;
const OFFSET_Y_SP = 120;
const SKILLTYPE_ALCHEMYSKILL = 140;

var int m_iType;
var int m_iID;
var int m_iLevel;
var int m_iSubLevel;
var TreeHandle SkillTrainInfoTree;
var L2Util util;
var string treeName;
var Rect rectWnd;

function OnRegisterEvent()
{
	RegisterEvent(2040);
	RegisterEvent(2050);
	RegisterEvent(2051);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	if((1 == 0))
	{
		OnRegisterEvent();
	}
	util = L2Util(GetScript("L2Util"));
	rectWnd = GetWindowHandle("SkillTrainInfoWnd").GetRect();
	return;
}

function OnClickButton(string strBtnID)
{
	switch(strBtnID)
	{
		case "btnLearn":
			OnLearn();
			break;
		case "btnGoBackList":
			ShowWindowWithFocus("SkillTrainListWnd");
			break;
		default:
			break;
	}
	return;
}

function OnLearn()
{
	RequestAcquireSkill(m_iID, m_iLevel, m_iSubLevel, m_iType);
	return;
}

function OnEvent(int Event_ID, string param)
{
	local int iType;
	local string strIconName, strName;
	local int iID, iLevel, iSubLevel;
	local INT64 iSPConsume, iEXPConsume;
	local string strDescription, strOperateType;
	local int iMPConsume, iCastRange;
	local INT64 iNumOfItem;
	local string strEnchantName, strEnchantDesc;
	local int iPercent;

	switch(Event_ID)
	{
		case 2040:
			ParseInt(param, "Type", iType);
			m_iType = iType;
			if((m_iType == 140))
			{
				return;
			}
			if((m_iType == 3))
			{
				return;
			}
			ParseString(param, "strIconName", strIconName);
			ParseString(param, "strName", strName);
			ParseInt(param, "iID", iID);
			ParseInt(param, "iLevel", iLevel);
			ParseInt(param, "iSubLevel", iSubLevel);
			ParseString(param, "strOperateType", strOperateType);
			ParseInt(param, "iMPConsume", iMPConsume);
			ParseInt(param, "iCastRange", iCastRange);
			ParseINT64(param, "iSPConsume", iSPConsume);
			ParseString(param, "strDescription", strDescription);
			ParseINT64(param, "iEXPConsume", iEXPConsume);
			ParseString(param, "strEnchantName", strEnchantName);
			ParseString(param, "strEnchantDesc", strEnchantDesc);
			ParseInt(param, "iPercent", iPercent);
			m_iType = iType;
			m_iID = iID;
			m_iLevel = iLevel;
			m_iSubLevel = iSubLevel;
			ShowSkillTrainInfoWnd();
			AddSkillTrainInfo(strIconName, strName, iID, iLevel, iSubLevel, strOperateType, iMPConsume, iCastRange, strDescription, iSPConsume, iEXPConsume, strEnchantName, strEnchantDesc, iPercent);
			break;
		case 2051:
			Debug(("EV_SkillTrainInfoWndAddExtendInfo" @ param));
			if((m_iType == 140))
			{
				return;
			}
			if((m_iType == 3))
			{
				return;
			}
			ParseString(param, "strIconName", strIconName);
			ParseString(param, "strName", strName);
			ParseINT64(param, "iNumOfItem", iNumOfItem);
			AddSkillTrainInfoExtend(strIconName, strName, iNumOfItem);
			ShowNeedItems();
			break;
		case 2050:
			if((m_iType == 140))
			{
				return;
			}
			if((m_iType == 3))
			{
				return;
			}
			if(IsShowWindow("SkillTrainInfoWnd"))
			{
				HideWindow("SkillTrainInfoWnd");
			}
			break;
		default:
			break;
	}
	return;
}

function ShowSkillTrainInfoWnd()
{
	local int iWindowTitle, iSPIdx;
	local UserInfo infoPlayer;
	local INT64 iPlayerSP;

	GetPlayerInfo(infoPlayer);
	switch(m_iType)
	{
		case 2:
		case 3:
			HideWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon");
			HideWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName");
			HideWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIconSlot");
			HideWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon1");
			HideWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName1");
			HideWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIconSlot1");
			iWindowTitle = 1436;
			iSPIdx = 1372;
			iPlayerSP = INT64(GetClanNameValue(infoPlayer.nClanID));
			break;
		default:
			iWindowTitle = 477;
			iSPIdx = 92;
			iPlayerSP = infoPlayer.nSP;
			break;
	}
	setWindowTitleBySysStringNum(iWindowTitle);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtSPString", GetSystemString(iSPIdx));
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.txtSP", string(iPlayerSP));
	GetTextureHandle("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon").SetTexture("");
	GetTextureHandle("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon1").SetTexture("");
	GetTextBoxHandle("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName").SetText("");
	GetTextBoxHandle("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName1").SetText("");
	ShowWindowWithFocus("SkillTrainInfoWnd");
	return;
}

function AddSkillTrainInfo(string strIconName, string strName, int iID, int iLevel, int iSubLevel, string strOperateType, int iMPConsume, int iCastRange, string strDescription, INT64 iSPConsume, INT64 iEXPConsume, string strEnchantName, string strEnchantDesc, int iPercent)
{
	local SkillInfo SkillInfo;
	local string strIconPanel;

	GetSkillInfo(iID, iLevel, iSubLevel, SkillInfo);
	ChangeSize(false);
	Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("SkillTrainInfoWnd.texIcon", strIconName);
	if((SkillInfo.IconPanel != ""))
	{
		strIconPanel = SkillInfo.IconPanel;
	}
	else
	{
		strIconPanel = "";
	}
	Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("SkillTrainInfoWnd.IconPanel", strIconPanel);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.txtName", strName);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("SkillTrainInfoWnd.txtLevel", iLevel);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.txtOperateType", strOperateType);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("SkillTrainInfoWnd.txtMP", iMPConsume);
	util.TreeClear(treeName);
	util.TreeInsertRootNode(treeName, "root", "");
	util.TreeInsertTextNodeItem(treeName, "root", strDescription);
	switch(m_iType)
	{
		case 2:
		case 3:
			if(!getInstanceUIData().GetIsClassicServer())
			{
				Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtNeedSPString", GetSystemString(1437));
			}
			else
			{
				ChangeSize(true);
			}
			break;
		default:
			Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtNeedSPString", GetSystemString(365));
			break;
	}
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtNeedSP", string(iSPConsume));
	if((iCastRange >= 0))
	{
		ShowWindow("SkillTrainInfoWnd.txtCastRangeString");
		ShowWindow("SkillTrainInfoWnd.txtColoneCastRange");
		ShowWindow("SkillTrainInfoWnd.txtCastRange");
		Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("SkillTrainInfoWnd.txtCastRange", iCastRange);
	}
	else
	{
		HideWindow("SkillTrainInfoWnd.txtCastRangeString");
		HideWindow("SkillTrainInfoWnd.txtColoneCastRange");
		HideWindow("SkillTrainInfoWnd.txtCastRange");
	}
	return;
}

function AddSkillTrainInfoExtend(string strIconName, string strName, INT64 iNumOfItem)
{
	if((GetTextBoxHandle("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName").GetText() == ""))
	{
		Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon", strIconName);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName", ((strName $ " X ") $ string(iNumOfItem)));
	}
	else
	{
		Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon1", strIconName);
		Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName1", ((strName $ " X ") $ string(iNumOfItem)));
	}
	return;
}

function OnShow()
{
	HideWindow("SkillTrainInfoWnd.SubWndEnchant");
	ShowWindow("SkillTrainInfoWnd.SubWndNormal");
	HideWindow("SkillTrainInfoWnd.SkillTrainInfoSubWndClanClassic");
	HideWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon");
	HideWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName");
	HideWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIconSlot");
	HideWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon1");
	HideWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName1");
	HideWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIconSlot1");
	if(IsShowWindow("SkillTrainListWnd"))
	{
		HideWindow("SkillTrainListWnd");
	}
	Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("SkillTrainInfoWnd", "SkillTrainListWnd", "TopLeft", "TopLeft", 0, 0);
	return;
}

function ShowNeedItems()
{
	ShowWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon");
	ShowWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName");
	ShowWindow("SkillTrainInfoWnd.SubWndNormal.texIconSlotBg");
	if((GetTextBoxHandle("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName1").GetText() != ""))
	{
		ShowWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon1");
		ShowWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName1");
		ShowWindow("SkillTrainInfoWnd.SubWndNormal.texIconSlotBg1");
	}
	return;
}

function ChangeSize(bool B)
{
	if(B)
	{
		HideWindow("SkillTrainListWnd.txtSPString");
		HideWindow("SkillTrainListWnd.txtSP");
		HideWindow("SkillTrainInfoWnd.SubWndNormal.txtSPString");
		HideWindow("SkillTrainInfoWnd.txtSP");
		HideWindow("SkillTrainInfoWnd.spTextBg");
		HideWindow("SkillTrainInfoWnd.spBg");
		HideWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedSPString");
		HideWindow("SkillTrainInfoWnd.SubWndNormal.txtColone3");
		HideWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedSP");
		GetTextureHandle("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon").SetAnchor("SkillTrainInfoWnd", "TopLeft", "TopLeft", 12, (294 - 16));
		GetTextureHandle("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon1").SetAnchor("SkillTrainInfoWnd", "TopLeft", "TopLeft", 12, (332 - 16));
		GetWindowHandle("SkillTrainInfoWnd").SetWindowSize(rectWnd.nWidth, (rectWnd.nHeight - 30));
	}
	else
	{
		ShowWindow("SkillTrainListWnd.txtSPString");
		ShowWindow("SkillTrainListWnd.txtSP");
		ShowWindow("SkillTrainInfoWnd.SubWndNormal.txtSPString");
		ShowWindow("SkillTrainInfoWnd.txtSP");
		ShowWindow("SkillTrainInfoWnd.spTextBg");
		ShowWindow("SkillTrainInfoWnd.spBg");
		ShowWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedSPString");
		ShowWindow("SkillTrainInfoWnd.SubWndNormal.txtColone3");
		ShowWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedSP");
		GetTextureHandle("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon").SetAnchor("SkillTrainInfoWnd", "TopLeft", "TopLeft", 12, 294);
		GetWindowHandle("SkillTrainInfoWnd").SetWindowSize(rectWnd.nWidth, rectWnd.nHeight);
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle("SkillTrainInfoWnd").HideWindow();
	return;
}

defaultproperties
{
	treeName="SkillTrainInfoWnd.SubWndNormal.SkillTrainInfoTree"
}
