class RefineryWndOption extends UICommonAPI
	dependson(UIPacket);

const MAX_OPTION_VARIATION = 3;

struct VariationProbInfo
{
	var int variation;
	var array<UIPacket._VariationProb> probList;
};

struct RefineryProbInfo
{
	var int refineryID;
	var int TargetItemID;
	var int maxPage;
	var int currentPage;
	var array<VariationProbInfo> variationInfos;
};

var WindowHandle Me;
var WindowHandle RefineryWndProbability;
var WindowHandle simpleProbListWnd;
var RichListCtrlHandle ProbabilityList_ListCtrl;
var TextBoxHandle txtInstruction;
var ButtonHandle DetailInfo_BTN;
var WindowHandle listScrollArea;
var array<WindowHandle> listWnds;
var RefineryProbInfo _ProbInfo;

function OnLoad()
{
	Initialize();
	return;
}

function ResetProbInfo()
{
	local RefineryProbInfo defaultInfo;

	_ProbInfo = defaultInfo;
	return;
}

function Initialize()
{
	local int i;
	local string ownerFullPath;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	txtInstruction = GetTextBoxHandle((ownerFullPath $ ".txtInstruction"));
	RefineryWndProbability = GetWindowHandle((ownerFullPath $ ".RefineryWndProbability"));
	ProbabilityList_ListCtrl = GetRichListCtrlHandle((ownerFullPath $ ".ProbabilityList_ListCtrl"));
	DetailInfo_BTN = GetButtonHandle((ownerFullPath $ ".DetailInfo_BTN"));
	simpleProbListWnd = GetWindowHandle((ownerFullPath $ ".SimpleOptionList_Wnd"));
	ProbabilityList_ListCtrl.SetSelectable(false);
	ProbabilityList_ListCtrl.SetAppearTooltipAtMouseX(true);
	ProbabilityList_ListCtrl.SetSelectedSelTooltip(false);
	listScrollArea = GetWindowHandle((simpleProbListWnd.m_WindowNameWithFullPath $ ".SimpleOptionList_Scroll"));
	listWnds.Length = 0;
	i = 0;
	while((i < 3))
	{
		AddListItemControl(listWnds, "LevelList", i, listScrollArea);
		i++;
	}
	toggleProbability(false);
	ResetProbInfo();
	return;
}

function AddListItemControl(out array<WindowHandle> componentList, string componentName, int Index, WindowHandle parentWnd)
{
	local WindowHandle targetWindowHandle;

	targetWindowHandle = GetWindowHandle((((parentWnd.m_WindowNameWithFullPath $ ".") $ componentName) $ string(Index)));
	componentList[componentList.Length] = targetWindowHandle;
	return;
}

function toggleProbability(bool bProbability)
{
	if(bProbability)
	{
		RefineryWndProbability.ShowWindow();
		simpleProbListWnd.HideWindow();
		DetailInfo_BTN.SetButtonName(13959);
	}
	else
	{
		RefineryWndProbability.HideWindow();
		DetailInfo_BTN.SetButtonName(13960);
		simpleProbListWnd.ShowWindow();
	}
	return;
}

function updateProbabilityList()
{
	local int i;

	ProbabilityList_ListCtrl.DeleteAllItem();
	i = 0;
	while((i < 3))
	{
		InsertProbListRecordGroup(i);
		i++;
	}
	return;
}

function InsertProbListRecordGroup(int optionIndex)
{
	local int i;
	local string oDesc1, oDesc2, oDesc3, descAll, probabilityStr;
	local array<UIPacket._VariationProb> probInfos;
	local UIPacket._VariationProb variationProb;
	local L2Util util;

	util = getInstanceL2Util();
	if(((_ProbInfo.variationInfos.Length > optionIndex) && (_ProbInfo.variationInfos[optionIndex].probList.Length > 0)))
	{
		probInfos = _ProbInfo.variationInfos[optionIndex].probList;
		i = 0;
		while((i < probInfos.Length))
		{
			variationProb = probInfos[i];
			if(((((int(GetLanguage()) == 8) || (int(GetLanguage()) == 9)) || (int(GetLanguage()) == 12)) || (int(GetLanguage()) == 14)))
			{
				if((i == 0))
				{
					ProbabilityList_ListCtrl.InsertRecord(makeTitleListItem((GetSystemString(397) @ string((optionIndex + 1))), ""));
				}
			}
			else if((i == 0))
			{
				ProbabilityList_ListCtrl.InsertRecord(makeTitleListItem((string((optionIndex + 1)) $ GetSystemString(397)), ""));
			}
			Class'NWindow.RefineryAPI'.static.GetOptionDescByOptionID(variationProb.nOptionID, oDesc1, oDesc2, oDesc3);
			if((oDesc1 != ""))
			{
				descAll = oDesc1;
			}
			if((oDesc2 != ""))
			{
				descAll = ((descAll $ ",") $ oDesc2);
			}
			if((oDesc3 != ""))
			{
				descAll = ((descAll $ ",") $ oDesc3);
			}
			descAll = Substitute(descAll, "\\n", " ", false);
			probabilityStr = util.MakeDecimalPointString(string(variationProb.nProb), 6, true, true);
			ProbabilityList_ListCtrl.InsertRecord(makeRecordProbability(descAll, probabilityStr));
			i++;
		}
	}
	return;
}

function RichListCtrlRowData makeRecordProbability(string Text, string percentStr)
{
	local RichListCtrlRowData rowData;
	local string textShort;

	textShort = Text;
	rowData.cellDataList.Length = 2;
	textShort = makeShortStringByPixel(Text, 210, "..");
	if((textShort != Text))
	{
		rowData.szReserved = Text;
	}
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, textShort, GTColor().White, false, 0, 0);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, percentStr, GTColor().White, false, 20, 0);
	return rowData;
}

function RichListCtrlRowData makeTitleListItem(string Str, string percentStr)
{
	local Color applyColor;
	local RichListCtrlRowData rowData;

	rowData.cellDataList.Length = 2;
	rowData.sOverlayTex = "L2UI_EPIC.DethroneWnd.List_HeaderBg_Blue";
	applyColor = GTColor().BrightWhite;
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, Str, applyColor, false, 0, 0);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, percentStr, GTColor().White, false, 20, 0);
	rowData.OverlayTexU = 635;
	rowData.OverlayTexV = 26;
	return rowData;
}

function DelIds()
{
	ResetProbList();
	toggleProbability(false);
	return;
}

function SetIDs(int stoneClassID, int targetClassID)
{
	local array<string> Options;

	API_GetOptionDesc(stoneClassID, targetClassID, Options);
	SetSimpleProbList(Options);
	CheckAndRequestProbList();
	return;
}

function ResetProbList()
{
	local array<string> Options;

	SetSimpleProbList(Options);
	txtInstruction.ShowWindow();
	return;
}

function SetSimpleProbList(array<string> Options)
{
	local int i, wndHeight;
	local WindowHandle itemListWnd;
	local HtmlHandle descHtml;
	local TextBoxHandle TitleTextBox;
	local int CalcOffsetY;

	i = 0;
	while((i < listWnds.Length))
	{
		itemListWnd = listWnds[i];
		if(((i >= Options.Length) || (Options[i] == "")))
		{
			itemListWnd.HideWindow();
			i++;
			continue;
		}
		TitleTextBox = GetTextBoxHandle((itemListWnd.m_WindowNameWithFullPath $ ".Level_Txt"));
		descHtml = GetHtmlHandle((itemListWnd.m_WindowNameWithFullPath $ ".Description_Txt"));
		if(((((int(GetLanguage()) == 8) || (int(GetLanguage()) == 9)) || (int(GetLanguage()) == 12)) || (int(GetLanguage()) == 14)))
		{
			TitleTextBox.SetText((GetSystemString(397) @ string((i + 1))));
		}
		else
		{
			TitleTextBox.SetText((string((i + 1)) $ GetSystemString(397)));
		}
		descHtml.LoadHtmlFromString(Class'InterfaceClassic.SkillEnchantWnd'.static.Inst().ConvertHtmlDesc(Options[i]));
		itemListWnd.ShowWindow();
		descHtml.SetDraggable(false);
		descHtml.SetWindowSize(descHtml.GetRect().nWidth, descHtml.GetFrameMaxHeight());
		itemListWnd.SetWindowSize(itemListWnd.GetRect().nWidth, (descHtml.GetRect().nHeight + 46));
		wndHeight = (wndHeight + itemListWnd.GetRect().nHeight);
		if((i > 0))
		{
			if((Options[(i - 1)] == ""))
			{
				CalcOffsetY = -205;
			}
			else
			{
				CalcOffsetY = 0;
			}
			itemListWnd.SetAnchor(listWnds[(i - 1)].m_WindowNameWithFullPath, "BottomCenter", "TopCenter", 0, CalcOffsetY);
		}
		itemListWnd.ClearAnchor();
		i++;
	}
	if(((listWnds[0].IsShowWindow() == false) && (listWnds[1].IsShowWindow() == false)))
	{
		txtInstruction.ShowWindow();
	}
	else
	{
		txtInstruction.HideWindow();
	}
	listScrollArea.SetScrollHeight(wndHeight);
	return;
}

function Toggle()
{
	if(Me.IsShowWindow())
	{
		Me.HideWindow();
	}
	else
	{
		Me.ShowWindow();
		Me.SetFocus();
	}
	return;
}

function CheckAndRequestProbList()
{
	local ItemInfo stoneInfo, TargetInfo;
	local int refineryID, TargetItemID;

	if((RefineryWndProbability.IsShowWindow() == false))
	{
		return;
	}
	Debug(("CheckAndRequestProbList" @ string(RefineryWndProbability.IsShowWindow())));
	RefineryWnd(GetScript("RefineryWnd")).GetItemInfoStone(stoneInfo);
	RefineryWnd(GetScript("RefineryWnd")).GetItemInfoTarget(TargetInfo);
	refineryID = stoneInfo.Id.ClassID;
	TargetItemID = TargetInfo.Id.ClassID;
	if(((refineryID > 0) && (TargetItemID > 0)))
	{
		if(((((_ProbInfo.refineryID == refineryID) && (_ProbInfo.TargetItemID == TargetItemID)) && (_ProbInfo.maxPage > 0)) && (_ProbInfo.maxPage == _ProbInfo.currentPage)))
		{
			updateProbabilityList();
		}
		else
		{
			Rq_C_EX_VARIATION_PROB_LIST(refineryID, TargetItemID);
		}
	}
	else
	{
		ResetProbInfo();
		updateProbabilityList();
	}
	return;
}

function Rq_C_EX_VARIATION_PROB_LIST(int refineryID, int TargetItemID)
{
	local array<byte> stream;
	local UIPacket._C_EX_VARIATION_PROB_LIST packet;

	packet.nRefineryID = refineryID;
	packet.nTargetItemId = TargetItemID;
	if(!Class'InterfaceClassic.UIPacket'.static.Encode_C_EX_VARIATION_PROB_LIST(stream, packet))
	{
		return;
	}
	Debug((("Rq_C_EX_VARIATION_PROB_LIST" @ string(packet.nRefineryID)) @ string(packet.nTargetItemId)));
	Class'InterfaceClassic.UIPacket'.static.RequestUIPacket(898, stream);
	return;
}

function Rs_S_EX_VARIATION_PROB_LIST()
{
	local UIPacket._S_EX_VARIATION_PROB_LIST packet;
	local int i;
	local VariationProbInfo variationProb;
	local UIPacket._VariationProb packetProb;

	if(!Class'InterfaceClassic.UIPacket'.static.Decode_S_EX_VARIATION_PROB_LIST(packet))
	{
		return;
	}
	_ProbInfo.refineryID = packet.nRefineryID;
	_ProbInfo.TargetItemID = packet.nTargetItemId;
	_ProbInfo.maxPage = packet.nMaxPage;
	_ProbInfo.currentPage = packet.nCurrentPage;
	Debug(((((("Rs_S_EX_VARIATION_PROB_LIST" @ string(packet.nRefineryID)) @ string(packet.nTargetItemId)) @ string(packet.nMaxPage)) @ string(packet.nCurrentPage)) @ string(_ProbInfo.variationInfos.Length)));
	if((packet.nCurrentPage == 1))
	{
		_ProbInfo.variationInfos.Length = 0;
	}
	i = 0;
	while((i < packet.variationProbList.Length))
	{
		packetProb = packet.variationProbList[i];
		if((packetProb.nOptionCategory > 3))
		{
			Debug((("!!!!! S_EX_VARIATION_PROB_LIST.nOptionCategory Invalid" @ string(packetProb.nOptionCategory)) @ string(3)));
			i++;
			continue;
		}
		variationProb = _ProbInfo.variationInfos[(packetProb.nOptionCategory - 1)];
		variationProb.probList[variationProb.probList.Length] = packetProb;
		_ProbInfo.variationInfos[(packetProb.nOptionCategory - 1)] = variationProb;
		i++;
	}
	if((packet.nMaxPage == packet.nCurrentPage))
	{
		updateProbabilityList();
	}
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(EV_PacketID(1174));
	return;
}

event OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case 40:
			ResetProbInfo();
			break;
		case EV_PacketID(1174):
			Rs_S_EX_VARIATION_PROB_LIST();
			break;
		default:
			break;
	}
	return;
}

event OnClickButton(string strID)
{
	Debug(("OnClickButton" @ strID));
	if((strID == "DetailInfo_BTN"))
	{
		if(RefineryWndProbability.IsShowWindow())
		{
			toggleProbability(false);
		}
		else
		{
			toggleProbability(true);
			CheckAndRequestProbList();
		}
	}
	return;
}

event OnSetFocus(WindowHandle focusedWnd, bool bFocused)
{
	if((bFocused == true))
	{
		GetWindowHandle("RefineryWnd").SetFocus();
	}
	return;
}

function RichListCtrlRowData makeRecord(string Option, int Quality)
{
	local RichListCtrlRowData Record;
	local Color tmpTextColor;
	local string optionResult;
	local int R, G, B;

	Record.cellDataList.Length = 1;
	ToolTip(GetScript("Tooltip")).GetRefineryColor(Quality, R, G, B);
	tmpTextColor = GetColor(R, G, B, 255);
	optionResult = makeShortStringByPixel(Option, 320, "..");
	if((optionResult != Option))
	{
		Record.szReserved = Option;
	}
	AddRichListCtrlString(Record.cellDataList[0].drawitems, optionResult, tmpTextColor, false);
	return Record;
}

function bool API_GetOptionDesc(int TargetItemClassID, int targetClassID, out array<string> Options)
{
	local string str1, str2, str3;
	local bool optionExist;

	optionExist = Class'NWindow.RefineryAPI'.static.GetOptionDesc(TargetItemClassID, targetClassID, str1, str2, str3);
	Options[0] = str1;
	Options[1] = str2;
	Options[2] = str3;
	return optionExist;
}
