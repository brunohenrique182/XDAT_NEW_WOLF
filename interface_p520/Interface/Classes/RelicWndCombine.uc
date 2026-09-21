class RelicWndCombine extends UICommonAPI
	dependson(UIPacket);

var WindowHandle Me;
var WindowHandle ScrollAreaWnd;
var WindowHandle needItemWnd;
var WindowHandle costDisableWnd;
var WindowHandle disableWnd;
var array<RelicWndCombineStuffGroup> groupObjectList;
var ButtonHandle combineBtn;
var ButtonHandle probBtn;
var TextureHandle groupGradeTex;
var UIControlNeedItem needItemScript;
var WindowHandle combinePopupWnd;
var TextBoxHandle BonusPointTitle_txt;
var WindowHandle bonusPointDisableWnd;
var TextBoxHandle MyPoint_txt;
var TextBoxHandle MaxPoint_txt;
var ButtonHandle helpBtn;
var ButtonHandle FixCombine_btn;
var UIControlDialogAssets combinePopupAssetScript;
var array<UIPacket._RelicsPointInfo> Points;
var int _fixCombineDialogGrade;

static function RelicWndCombine Inst()
{
	return RelicWndCombine(GetScript("RelicWnd.RelicWndCombine"));
}

function Initialize()
{
	InitControls();
	return;
}

function InitControls()
{
	local int i;
	local WindowHandle itemRendererWnd;
	local RelicWndCombineStuffGroup groupObject;
	local string ownerFullPath;

	ownerFullPath = m_hOwnerWnd.m_WindowNameWithFullPath;
	Me = GetWindowHandle(ownerFullPath);
	ScrollAreaWnd = GetWindowHandle((ownerFullPath $ ".ScrollAreaWnd.RelicCombineListScroll"));
	combineBtn = GetButtonHandle((ownerFullPath $ ".RelicCombineStart_btn"));
	probBtn = GetButtonHandle((ownerFullPath $ ".RelicCombineProb_btn"));
	groupGradeTex = GetTextureHandle((ownerFullPath $ ".CombineGradeBg_tex"));
	disableWnd = GetWindowHandle((ownerFullPath $ ".DisableWnd"));
	costDisableWnd = GetWindowHandle((ownerFullPath $ ".CombineCostWnd.CostDisableWnd"));
	bonusPointDisableWnd = GetWindowHandle((ownerFullPath $ ".BonusPointWnd.BonusPointDisableWnd"));
	bonusPointDisableWnd.HideWindow();
	BonusPointTitle_txt = GetTextBoxHandle((ownerFullPath $ ".BonusPointWnd.BonusPointTitle_txt"));
	BonusPointTitle_txt.SetText("보너스 제목");  // EN?: Bonus Title
	helpBtn = GetButtonHandle((ownerFullPath $ ".BonusPointWnd.HelpBtn"));
	FixCombine_btn = GetButtonHandle((ownerFullPath $ ".BonusPointWnd.FixCombine_btn"));
	FixCombine_btn.DisableWindow();
	MyPoint_txt = GetTextBoxHandle((ownerFullPath $ ".BonusPointWnd.MyPoint_txt"));
	MaxPoint_txt = GetTextBoxHandle((ownerFullPath $ ".BonusPointWnd.MaxPoint_txt"));
	MyPoint_txt.SetText("888");
	MaxPoint_txt.SetText("888");
	combinePopupWnd = GetWindowHandle((ownerFullPath $ ".CombinePopupWnd"));
	needItemWnd = GetWindowHandle((ownerFullPath $ ".CombineCostWnd.CostItem"));
	needItemWnd.SetScript("UIControlNeedItem");
	needItemScript = UIControlNeedItem(needItemWnd.GetScript());
	needItemScript.Init(("RelicWnd." $ needItemWnd.m_WindowNameWithFullPath));
	needItemScript.DelegateItemUpdate = DelegateNeedItemOnUpdateItem;
	groupObjectList.Length = 0;
	i = 0;
	while((i < 11))
	{
		itemRendererWnd = GetWindowHandle(((ScrollAreaWnd.m_WindowNameWithFullPath $ ".RelicCombine") $ string(i)));
		groupObject = new Class'Interface.RelicWndCombineStuffGroup';
		groupObject.Init(itemRendererWnd, i);
		groupObjectList[groupObjectList.Length] = groupObject;
		i++;
	}
	Class'Interface.RelicWnd'.static.Inst().DelegateChangeCombineStuff = OnChangeCombineStuff;
	InitDialogAssets();
	return;
}

function InitDialogAssets()
{
	combinePopupAssetScript = Class'Interface.UIControlDialogAssets'.static.InitScript(GetWindowHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".CombinePopupWnd.combinePopupAsset")));
	combinePopupAssetScript.SetDisableWindow(combinePopupWnd);
	combinePopupAssetScript.DelegateOnCancel = HandleDelegateOnCancel;
	combinePopupAssetScript.DelegateOnClickBuy = HandleDelegateOnClickBuy;
	return;
}

function HandleDelegateOnCancel()
{
	combinePopupAssetScript.Hide();
	return;
}

function HandleDelegateOnClickBuy()
{
	RQ_C_EX_RELICS_CONFIRM_COMBINATION();
	combinePopupAssetScript.Hide();
	return;
}

function DelegateNeedItemOnUpdateItem(UIControlNeedItem Script)
{
	UpdateCombineBtnState();
	return;
}

function UpdateStuffList()
{
	local RelicWnd.RelicCombineInfo combineInfo;
	local int i, j, stuffIndex, maxStuff, stuffRelicId, lastRegisterIndex;
	local array<int> stuffGroup;
	local RelicsPlayUIData relicPlayData;
	local L2ItemAmount CostItem;

	combineInfo = Class'Interface.RelicWnd'.static.Inst().GetCombineInfo();
	maxStuff = 4;
	i = 0;
	while((i < groupObjectList.Length))
	{
		stuffGroup.Length = 0;
		j = 0;
		while((j < maxStuff))
		{
			stuffIndex = ((i * maxStuff) + j);
			if((stuffIndex < combineInfo.stuffTotalArray.Length))
			{
				stuffRelicId = combineInfo.stuffTotalArray[stuffIndex];
				stuffGroup[j] = stuffRelicId;
				lastRegisterIndex = i;
			}
			j++;
		}
		groupObjectList[i].SetInfo(combineInfo.Grade, stuffGroup);
		i++;
	}
	if((lastRegisterIndex <= 4))
	{
		ScrollAreaWnd.SetScrollPosition(0);
	}
	else
	{
		ScrollAreaWnd.SetScrollPosition(int((420.0000000 * (float(lastRegisterIndex) / float(groupObjectList.Length)))));
	}
	if((combineInfo.stuffTotalArray.Length >= maxStuff))
	{
		GetRelicsPlayData(ERPDT_Combination, int(combineInfo.Grade), relicPlayData);
		CostItem = relicPlayData.CostItems[0];
		Debug(((("UpdateStuffList : " @ string(relicPlayData.CostItems.Length)) @ string(CostItem.ItemClassID)) @ string(CostItem.ItemAmount)));
		needItemScript.setId(GetItemID(CostItem.ItemClassID));
		needItemScript.SetNumNeed(INT64((CostItem.ItemAmount * (combineInfo.stuffTotalArray.Length / maxStuff))));
		if(needItemScript.canBuy())
		{
			combineBtn.SetEnable(true);
		}
		else
		{
			combineBtn.SetEnable(false);
		}
		costDisableWnd.HideWindow();
	}
	else
	{
		needItemScript.setId(GetItemID(0));
		needItemScript.SetNumNeed(INT64(0));
		costDisableWnd.ShowWindow();
		combineBtn.SetEnable(false);
	}
	if((combineInfo.stuffTotalArray.Length > 0))
	{
		groupGradeTex.SetTexture(GetGroupGradeTexName(combineInfo.Grade));
		groupGradeTex.ShowWindow();
		probBtn.SetEnable(true);
	}
	else
	{
		groupGradeTex.HideWindow();
		probBtn.SetEnable(false);
	}
	Class'Interface.RelicWnd'.static.Inst().relicCombineProbScript.SetType(1);
	Class'Interface.RelicWnd'.static.Inst().relicCombineProbScript.UpdateInfo();
	return;
}

function ResetInfo()
{
	needItemScript.RemoveInventoryObject();
	return;
}

function UpdateCombineBtnState()
{
	return;
}

function ShowModal()
{
	Class'Interface.RelicWnd'.static.Inst().relicListScript.ShowDisableWnd();
	disableWnd.ShowWindow();
	return;
}

function HideModal()
{
	Class'Interface.RelicWnd'.static.Inst().relicListScript.hideDisableWnd();
	disableWnd.HideWindow();
	return;
}

function HideProbWindow()
{
	Class'Interface.RelicWnd'.static.Inst().relicCombineProbScript.Me.HideWindow();
	return;
}

function HideModalAndDialog()
{
	if((DialogIsMine() == true))
	{
		DialogHide();
	}
	HideModal();
	HideProbWindow();
	return;
}

function OnChangeCombineStuff()
{
	combinePopupAssetScript.Hide();
	UpdateStuffList();
	return;
}

function SetFailPoints()
{
	local RelicsPlayUIData relicPlayData;
	local UIPacket._RelicsPointInfo pointInfo;

	GetRelicsPlayData(ERPDT_Combination, GetSelectedTabGrade(), relicPlayData);
	if((relicPlayData.MaxFailPoint == 0))
	{
		bonusPointDisableWnd.ShowWindow();
	}
	else
	{
		bonusPointDisableWnd.HideWindow();
		BonusPointTitle_txt.SetText(MakeFullSystemMsg(GetSystemMessage(14030), RelicSummonWnd(GetScript("RelicSummonWnd")).getGradeRelicsSystemString((GetSelectedTabGrade() + 1))));
		BonusPointTitle_txt.SetTextColor(Class'Interface.L2Util'.static.Inst().GetRelicTextColor(ERelicGrade((GetSelectedTabGrade() + 1))));
		MaxPoint_txt.SetText(string(relicPlayData.MaxFailPoint));
		if(GetCurrentPointInfo(pointInfo))
		{
			MyPoint_txt.SetText(string(pointInfo.nCurrentCount));
			if((pointInfo.nCurrentCount < pointInfo.nOneTimeCount))
			{
				FixCombine_btn.DisableWindow();
			}
			else
			{
				FixCombine_btn.EnableWindow();
			}
		}
		else
		{
			MyPoint_txt.SetText("0");
			FixCombine_btn.DisableWindow();
		}
	}
	return;
}

function ShowFixCombineConfirmPopup()
{
	local UIPacket._RelicsPointInfo pointInfo;
	local int tryNum, usePnt;
	local string gradeString;

	if((GetCurrentPointInfo(pointInfo) == false))
	{
		return;
	}
	gradeString = RelicSummonWnd(GetScript("RelicSummonWnd")).getGradeRelicsSystemString(GetSelectedTabGrade());
	tryNum = (pointInfo.nCurrentCount / pointInfo.nOneTimeCount);
	usePnt = (tryNum * pointInfo.nOneTimeCount);
	_fixCombineDialogGrade = GetSelectedTabGrade();
	combinePopupAssetScript.SetDialogDesc(MakeFullSystemMsg(GetSystemMessage(14031), string(usePnt), gradeString, string(tryNum)), , , , 48);
	combinePopupAssetScript.Show();
	return;
}

function int GetSelectedTabGrade()
{
	return int(Class'Interface.RelicWndList'.static.Inst().GetSelectedTabGrade());
}

function bool GetCurrentPointInfo(out UIPacket._RelicsPointInfo pointInfo)
{
	local int i;

	i = 0;
	while((i < Points.Length))
	{
		if((Points[i].nGrade == GetSelectedTabGrade()))
		{
			pointInfo = Points[i];
			return true;
		}
		i++;
	}
	return false;
}

function string GetGroupGradeTexName(UIConstants.ERelicGrade Grade)
{
	switch(Grade)
	{
		case RG_N:
			return "L2UI_NewTex.RelicWnd.CombineBg_N";
		case RG_D:
			return "L2UI_NewTex.RelicWnd.CombineBg_D";
		case RG_C:
			return "L2UI_NewTex.RelicWnd.CombineBg_C";
		case RG_B:
			return "L2UI_NewTex.RelicWnd.CombineBg_B";
		default:
			return "";
	}
}

function RQ_C_EX_RELICS_CONFIRM_COMBINATION()
{
	local array<byte> stream;
	local UIPacket._C_EX_RELICS_CONFIRM_COMBINATION packet;

	packet.nGrade = _fixCombineDialogGrade;
	if((packet.nGrade < 1))
	{
		return;
	}
	if(!Class'Interface.UIPacket'.static.Encode_C_EX_RELICS_CONFIRM_COMBINATION(stream, packet))
	{
		return;
	}
	Class'Interface.UIPacket'.static.RequestUIPacket(904, stream);
	return;
}

function RT_S_EX_RELICS_POINT_INFO()
{
	local UIPacket._S_EX_RELICS_POINT_INFO packet;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_RELICS_POINT_INFO(packet))
	{
		return;
	}
	Points = packet.Points;
	SetFailPoints();
	SetDisableCombines();
	return;
}

function SetDisableCombines()
{
	local int i;
	local RelicsPlayUIData relicPlayData;
	local RelicSummonWnd relicSummonWndScr;
	local string strGradeStrings;

	relicSummonWndScr = RelicSummonWnd(GetScript("RelicSummonWnd"));
	i = 0;
	while((i < 5))
	{
		GetRelicsPlayData(ERPDT_Combination, i, relicPlayData);
		if((relicPlayData.MaxFailPoint > 0))
		{
			if((strGradeStrings == ""))
			{
				strGradeStrings = relicSummonWndScr.getGradeRelicsSystemString(i);
				i++;
				continue;
			}
			strGradeStrings = ((relicSummonWndScr.getGradeRelicsSystemString(i) $ ",") @ strGradeStrings);
		}
		i++;
	}
	GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".BonusPointWnd.BonusPointDisableWnd.BonusPointDisable_txt")).SetText(MakeFullSystemMsg(GetSystemMessage(14029), strGradeStrings));
	return;
}

event OnRegisterEvent()
{
	RegisterEvent(EV_PacketID(1182));
	return;
}

event OnEvent(int EventID, string param)
{
	if((EventID == EV_PacketID(1182)))
	{
		RT_S_EX_RELICS_POINT_INFO();
	}
	return;
}

event OnCombineDialogConfirm()
{
	Class'Interface.RelicWnd'.static.Inst().RequestRelicCombine();
	return;
}

event OnCombineDialogCancel()
{
	if((DialogIsMine() == true))
	{
		HideModal();
	}
	return;
}

event OnCombineDialogHide()
{
	if((DialogIsMine() == true))
	{
		HideModal();
	}
	return;
}

event OnClickButton(string btnName)
{
	if((btnName == "RelicUpgrade_btn"))
	{
		Class'Interface.RelicWnd'.static.Inst().AutoRegisterCombineStuffs();
	}
	else if((btnName == "RelicUpgradeReset_btn"))
	{
		Class'Interface.RelicWnd'.static.Inst().ResetCombineInfo();
		Class'Interface.RelicWnd'.static.Inst().DelegateChangeCombineStuff();
		Class'Interface.RelicWnd'.static.Inst().DelegateChangeCombineStuffList();
	}
	else if((btnName == "RelicCombineStart_btn"))
	{
		OnCombineDialogConfirm();
	}
	else if((btnName == "RelicCombineProb_Btn"))
	{
		Class'Interface.RelicCombineProbWnd'.static.Inst().ToggleCombineProbInfo();
	}
	else if((btnName == "FixCombineProb_Btn"))
	{
		Class'Interface.RelicCombineProbWnd'.static.Inst().ToggleFixCombineProbInfo();
	}
	else if((btnName == "FixCombine_btn"))
	{
		ShowFixCombineConfirmPopup();
	}
	return;
}

event OnLoad()
{
	Initialize();
	return;
}

event OnShow()
{
	combinePopupAssetScript.Hide();
	return;
}
