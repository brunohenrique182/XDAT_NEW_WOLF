class SkillEnchantExtractLevelInfoWnd extends UICommonAPI;

var WindowHandle Me;
var TextBoxHandle currentNameTextBox;
var TextBoxHandle targetNameTextBox;
var TextBoxHandle currentLevelTextBox;
var TextBoxHandle targetLevelTextBox;
var HtmlHandle currentInfoHtml;
var HtmlHandle targetInfoHtml;

static function SkillEnchantExtractLevelInfoWnd Inst()
{
	return SkillEnchantExtractLevelInfoWnd(GetScript("SkillEnchantExtractLevelInfoWnd"));
}

function Initialize()
{
	InitControls();
	return;
}

function InitControls()
{
	local string ownerFullPath;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	currentNameTextBox = GetTextBoxHandle((ownerFullPath $ ".InnerTitle01_Txt"));
	targetNameTextBox = GetTextBoxHandle((ownerFullPath $ ".InnerTitle02_Txt"));
	currentLevelTextBox = GetTextBoxHandle((ownerFullPath $ ".InnerTitleNum01_Txt"));
	targetLevelTextBox = GetTextBoxHandle((ownerFullPath $ ".InnerTitleNum02_Txt"));
	currentInfoHtml = GetHtmlHandle((ownerFullPath $ ".Description01_Html"));
	targetInfoHtml = GetHtmlHandle((ownerFullPath $ ".Description02_Html"));
	return;
}

function SetInfo(SkillInfo currentSkillInfo, int replaceSkillId, int targetSubLevel)
{
	local int validSkillId;
	local SkillInfo targetSkillInfo;
	local string currentSkillName, targetSkillName;

	if((replaceSkillId >= 0))
	{
		validSkillId = replaceSkillId;
	}
	else
	{
		validSkillId = currentSkillInfo.SkillID;
	}
	GetSkillInfo(validSkillId, currentSkillInfo.SkillLevel, targetSubLevel, targetSkillInfo);
	currentSkillName = currentSkillInfo.SkillName;
	targetSkillName = targetSkillInfo.SkillName;
	Class'InterfaceClassic.L2Util'.static.GetEllipsisString(currentSkillName, 200);
	Class'InterfaceClassic.L2Util'.static.GetEllipsisString(targetSkillName, 200);
	currentNameTextBox.SetText(currentSkillName);
	targetNameTextBox.SetText(targetSkillName);
	currentLevelTextBox.SetText(("+" $ string(Class'InterfaceClassic.SkillWnd'.static.Inst().ConvertEnchantLevel(currentSkillInfo.SkillSubLevel))));
	targetLevelTextBox.SetText(("+" $ string(Class'InterfaceClassic.SkillWnd'.static.Inst().ConvertEnchantLevel(targetSubLevel))));
	currentInfoHtml.LoadHtmlFromString(Class'InterfaceClassic.SkillEnchantWnd'.static.Inst().ConvertHtmlDesc(currentSkillInfo.SkillDesc));
	targetInfoHtml.LoadHtmlFromString(Class'InterfaceClassic.SkillEnchantWnd'.static.Inst().ConvertHtmlDesc(targetSkillInfo.SkillDesc));
	return;
}

event OnLoad()
{
	Initialize();
	return;
}
