class SkillLearnWnd extends UICommonAPI;

const OFFSET_X_ICON_TEXTURE = 0;
const OFFSET_Y_ICON_TEXTURE = 4;
const OFFSET_Y_SECONDLINE = -14;
const OFFSET_Y_MPCONSUME = 3;
const OFFSET_Y_CASTRANGE = 0;
const OFFSET_Y_SP = 120;
const WINDOW_W = 300;
const WINDOW_H_MAX = 547;
const WINDOW_H_MIN = 441;
const DIALOGID_SkillLearn = 3864;

var int m_iType;
var int m_iID;
var int m_iLevel;
var int m_iSubLevel;
var WindowHandle Me;
var string m_Windowname;
var TextureHandle texIcon;
var TextureHandle iconActive;
var TextureHandle IconPanel;
var TextBoxHandle txtName;
var TextBoxHandle txtLevel;
var TextBoxHandle txtMP;
var TextBoxHandle txtUseTime;
var TextBoxHandle txtReuseTime;
var HtmlHandle SkillTrainInfoHtml;
var TextBoxHandle txtNeedChaLv;
var TextBoxHandle txtNeedSP;
var TextBoxHandle txtNeedItemString;
var TextBoxHandle txtNeedItemName;
var TextBoxHandle txtNeedDualLvString;
var TextBoxHandle txtColoneDualLv;
var TextBoxHandle txtNeedDualLv;
var TextureHandle iconMP;
var TextureHandle iconUse;
var TextureHandle iconReuse;
var TextureHandle spBg;
var WindowHandle PrevSkillListBox;
var WindowHandle PrevSkillListNone;
var MagicSkillWnd MagicSkillWndScript;
var string LearnNeedItemName;
var INT64 LearnNeedItemNum;
var INT64 LearnSpConsume;
var string LearnNeedItemString;
var L2Util util;

function OnRegisterEvent()
{
	RegisterEvent(2058);
	RegisterEvent(1710);
	RegisterEvent(1720);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	OnRegisterEvent();
	Me = GetWindowHandle("SkillLearnWnd");
	texIcon = GetTextureHandle("SkillLearnWnd.texIcon");
	iconActive = GetTextureHandle("SkillLearnWnd.iconActive");
	IconPanel = GetTextureHandle("SkillLearnWnd.IconPanel");
	txtName = GetTextBoxHandle("SkillLearnWnd.txtName");
	txtLevel = GetTextBoxHandle("SkillLearnWnd.txtLevel");
	txtMP = GetTextBoxHandle("SkillLearnWnd.txtMP");
	txtUseTime = GetTextBoxHandle("SkillLearnWnd.txtUseTime");
	txtReuseTime = GetTextBoxHandle("SkillLearnWnd.txtReuseTime");
	txtNeedChaLv = GetTextBoxHandle("SkillLearnWnd.txtNeedChaLv");
	txtNeedSP = GetTextBoxHandle("SkillLearnWnd.txtNeedSP");
	txtNeedItemString = GetTextBoxHandle("SkillLearnWnd.txtNeedItemString");
	txtNeedItemName = GetTextBoxHandle("SkillLearnWnd.txtNeedItemName");
	txtNeedDualLvString = GetTextBoxHandle("SkillLearnWnd.txtNeedDualLvString");
	txtColoneDualLv = GetTextBoxHandle("SkillLearnWnd.txtColoneDualLv");
	txtNeedDualLv = GetTextBoxHandle("SkillLearnWnd.txtNeedDualLv");
	iconMP = GetTextureHandle("SkillLearnWnd.iconMP");
	iconUse = GetTextureHandle("SkillLearnWnd.iconUse");
	iconReuse = GetTextureHandle("SkillLearnWnd.iconReuse");
	spBg = GetTextureHandle("SkillLearnWnd.spBg");
	PrevSkillListBox = GetWindowHandle("SkillLearnWnd.PrevSkillListBox");
	PrevSkillListNone = GetWindowHandle("SkillLearnWnd.PrevSkillListNone");
	SkillTrainInfoHtml = GetHtmlHandle("SkillLearnWnd.SkillTrainInfoHtml");
	util = L2Util(GetScript("L2Util"));
	MagicSkillWndScript = MagicSkillWnd(GetScript("MagicSkillWnd"));
	return;
}

function OnClickButton(string strBtnID)
{
	switch(strBtnID)
	{
		case "btnLearn":
			ShowDialogLearn();
			break;
		case "btnGoBackList":
			HideWindow("SkillLearnWnd");
			break;
		default:
			break;
	}
	return;
}

function ShowDialogLearn()
{
	local string htmlAdd;

	if((LearnNeedItemNum != INT64(0)))
	{
		DialogSetID(3864);
		htmlAdd = (((htmlAddText((GetSystemString(365) $ " : "), "GameDefault", "c8c8c8") $ htmlAddText((string(LearnSpConsume) $ "<br1>"), "GameDefault", "AF9878")) $ htmlAddText((GetSystemString(2380) $ " : "), "GameDefault", "c8c8c8")) $ htmlAddText(LearnNeedItemString, "GameDefault", "AF9878"));
		DialogShowHtml(DialogModalType_Modalless, DialogType_OKCancel, htmlAdd, m_hOwnerWnd);
	}
	else
	{
		OnLearn();
	}
	return;
}

function OnLearn()
{
	HideWindow("SkillLearnWnd");
	RequestAcquireSkill(m_iID, m_iLevel, m_iSubLevel, m_iType);
	return;
}

function OnHide()
{
	local MagicSkillWnd sc;

	sc = MagicSkillWnd(GetScript("MagicSkillWnd"));
	sc.closeTreeNode();
	if(DialogIsMine())
	{
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow("DialogBox");
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case 2058:
			Me.ShowWindow();
			SkillLearningDetailInfo(param);
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

function OnShow()
{
	HideWindow("SkillTrainInfoWnd.SubWndEnchant");
	ShowWindow("SkillTrainInfoWnd.SubWndNormal");
	if((!GetWindowHandle("MagicSkillWnd").IsShowWindow() || !MagicSkillWndScript.isSkillLearnTab()))
	{
		Me.HideWindow();
	}
	return;
}

function SkillLearningDetailInfo(string param)
{
	local SkillInfo SkillInfo;
	local int Id, Level, SubLevel;
	local INT64 spConsume;
	local int requiredLevel, RequiredDualLevel;
	local UserInfo UserInfo;
	local ItemID cID;
	local int RequiredItemTotalCnt, requiredItemID;
	local INT64 requiredItemCnt;
	local int RequiredSkillCnt, requiredSkillID, requiredSkillLevel;
	local ItemID requiredID;
	local int i;
	local string strName, strIconName, skillDescription, strIconPanel, strHtm;

	ParseInt(param, "ID", Id);
	ParseInt(param, "Level", Level);
	ParseInt(param, "SubLevel", SubLevel);
	ParseINT64(param, "SpConsume", spConsume);
	ParseINT64(param, "SpConsume", LearnSpConsume);
	ParseInt(param, "RequiredLevel", requiredLevel);
	ParseInt(param, "RequiredDualLevel", RequiredDualLevel);
	ParseInt(param, "RequiredItemTotalCnt", RequiredItemTotalCnt);
	ParseInt(param, "RequiredSkillCnt", RequiredSkillCnt);
	cID = GetItemID(Id);
	GetSkillInfo(Id, Level, SubLevel, SkillInfo);
	GetPlayerInfo(UserInfo);
	strName = SkillInfo.SkillName;
	strIconPanel = SkillInfo.IconPanel;
	strIconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(cID, Level, 0);
	texIcon.SetTexture(strIconName);
	if((TypeCheck(SkillInfo) == true))
	{
		iconActive.SetTexture("l2ui_ct1.SkillWnd_DF_ListIcon_Active");
		iconMP.ShowWindow();
		iconUse.ShowWindow();
		iconReuse.ShowWindow();
		txtName.SetText(strName);
		txtLevel.SetText(string(Level));
		txtMP.SetText(string(SkillInfo.MpConsume));
		txtUseTime.SetText(util.MakeTimeString(SkillInfo.HitTime, SkillInfo.CoolTime));
		txtReuseTime.SetText(util.MakeTimeString(SkillInfo.ReuseDelay));
	}
	else
	{
		iconActive.SetTexture("l2ui_ct1.SkillWnd_DF_ListIcon_Passive");
		iconMP.HideWindow();
		iconUse.HideWindow();
		iconReuse.HideWindow();
		txtName.SetText(strName);
		txtLevel.SetText(string(Level));
		txtMP.SetText("");
		txtUseTime.SetText("");
		txtReuseTime.SetText("");
	}
	skillDescription = Class'NWindow.UIDATA_SKILL'.static.GetDescription(cID, Level, 0);
	skillDescription = Substitute(skillDescription, "<", "&lt;", false);
	skillDescription = Substitute(skillDescription, ">", "&gt;", false);
	skillDescription = Substitute(skillDescription, "&lt;font", "<font", false);
	skillDescription = Substitute(skillDescription, "\"&gt;", "\">", false);
	skillDescription = Substitute(skillDescription, "&lt;/font&gt;", "</font>", false);
	skillDescription = Substitute(skillDescription, "\\n\\n", "<br>", false);
	skillDescription = Substitute(skillDescription, "\\n", "<br1>", false);
	strHtm = "";
	SkillTrainInfoHtml.LoadHtmlFromString(htmlSetHtmlStart((strHtm $ htmlAddText(skillDescription, "GameDefault", "afb9cd"))));
	GetWindowHandle("MagicSkillWnd").SetFocus();
	txtNeedChaLv.SetText(string(requiredLevel));
	if((RequiredDualLevel > 0))
	{
		txtNeedDualLvString.ShowWindow();
		txtColoneDualLv.ShowWindow();
		txtNeedDualLv.ShowWindow();
		txtNeedDualLv.SetText(string(RequiredDualLevel));
	}
	else
	{
		txtNeedDualLvString.HideWindow();
		txtColoneDualLv.HideWindow();
		txtNeedDualLv.HideWindow();
	}
	txtNeedSP.SetText(string(spConsume));
	txtNeedItemName.SetText("");
	LearnNeedItemString = "";
	if((RequiredItemTotalCnt > 0))
	{
		i = 1;
		while((i <= RequiredItemTotalCnt))
		{
			ParseInt(param, ("requiredItemID" $ string(i)), requiredItemID);
			ParseINT64(param, ("requiredItemCnt" $ string(i)), requiredItemCnt);
			LearnNeedItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(requiredItemID));
			LearnNeedItemNum = requiredItemCnt;
			txtNeedItemName.SetText(((((txtNeedItemName.GetText() $ LearnNeedItemName) $ " x") $ MakeCostStringINT64(LearnNeedItemNum)) $ "\\n"));
			LearnNeedItemString = ((((LearnNeedItemString $ LearnNeedItemName) $ " x") $ MakeCostStringINT64(LearnNeedItemNum)) $ "<br1>");
			i++;
		}
	}
	else
	{
		LearnNeedItemNum = INT64(0);
		txtNeedItemName.SetText(GetSystemString(27));
	}
	if((RequiredSkillCnt > 0))
	{
		reSizeWindow(true);
		showLearningSkill(RequiredSkillCnt);
		i = 1;
		while((i <= RequiredSkillCnt))
		{
			ParseInt(param, ("requiredSkillID" $ string(i)), requiredSkillID);
			ParseInt(param, ("requiredSkillLevel" $ string(i)), requiredSkillLevel);
			requiredID = GetItemID(requiredSkillID);
			GetTextureHandle(("texPrevSkillIcon" $ string(i))).SetTexture(Class'NWindow.UIDATA_SKILL'.static.GetIconName(requiredID, requiredSkillLevel, 0));
			GetTextureHandle(("texPrevSkillIcon" $ string(i))).SetTextureSize(32, 32);
			if((Class'NWindow.UIDATA_SKILL'.static.SkillIsNewOrUp(requiredID) == 0))
			{
				GetTextBoxHandle(("txtPrevName" $ string(i))).SetText(Class'NWindow.UIDATA_SKILL'.static.GetName(requiredID, requiredSkillLevel, 0));
				GetTextBoxHandle(("txtPrevLevel" $ string(i))).SetText(string(requiredSkillLevel));
				GetTextureHandle(("texPrevSkillIconUp" $ string(i))).ShowWindow();
				i++;
				continue;
			}
			GetTextBoxHandle(("txtPrevName" $ string(i))).SetText(Class'NWindow.UIDATA_SKILL'.static.GetName(requiredID, requiredSkillLevel, 0));
			GetTextBoxHandle(("txtPrevLevel" $ string(i))).SetText(string(requiredSkillLevel));
			GetTextureHandle(("texPrevSkillIconUp" $ string(i))).HideWindow();
			i++;
		}
	}
	else
	{
		reSizeWindow();
	}
	m_iType = 0;
	m_iID = Id;
	m_iLevel = Level;
	m_iSubLevel = SubLevel;
	if((strIconPanel == ""))
	{
		strIconPanel = "";
	}
	IconPanel.SetTexture(strIconPanel);
	Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillLearnWnd.txtSP", string(UserInfo.nSP));
	return;
}

function string addHtmContent(string Title, string Context)
{
	local string htm;

	htm = ((htmlAddText((Title $ " : "), "GameDefault", "afb9cd") $ htmlAddText(Context, "GameDefault", "af0900")) $ "<br1>");
	return htm;
}

function reSizeWindow(optional bool B)
{
	if((B == true))
	{
		PrevSkillListBox.ShowWindow();
		PrevSkillListNone.HideWindow();
		spBg.SetAnchor("SkillLearnWnd.PrevSkillListBox", "BottomLeft", "TopLeft", 0, 5);
		Me.SetWindowSize(300, 547);
	}
	else
	{
		PrevSkillListBox.HideWindow();
		PrevSkillListNone.ShowWindow();
		spBg.SetAnchor("SkillLearnWnd.PrevSkillListNone", "BottomLeft", "TopLeft", 0, 5);
		Me.SetWindowSize(300, 441);
	}
	return;
}

function showLearningSkill(int Count)
{
	local int i;

	i = 1;
	while((i <= 5))
	{
		if((i <= Count))
		{
			GetWindowHandle(("PrevSkillList" $ string(i))).ShowWindow();
			i++;
			continue;
		}
		GetWindowHandle(("PrevSkillList" $ string(i))).HideWindow();
		i++;
	}
	return;
}

function bool TypeCheck(SkillInfo Info)
{
	return isActiveSkill(Info.IconType);
}

function HandleDialogCancel()
{
	return;
}

function HandleDialogOK()
{
	local int Id;

	if(!DialogIsMine())
	{
		return;
	}
	Id = Class'InterfaceClassic.UICommonAPI'.static.DialogGetID();
	if((Id == 3864))
	{
		OnLearn();
	}
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(m_Windowname).HideWindow();
	return;
}

defaultproperties
{
	m_Windowname="SkillLearnWnd"
}
