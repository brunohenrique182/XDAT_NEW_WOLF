class ArtifactEnchantWnd extends UICommonAPI;

const ANIM_SUCCESS = 1;
const ANIM_FAIL = 2;
const ANIM_PROGRESS = 3;
const TIMER_BUTTONDELAY_ID = 100221;
const MAX_USER_LEVEL = 99;

var WindowHandle Me;
var AnimTextureHandle EnchantProgressAnim;
var TextBoxHandle Instruction_Txt;
var TextBoxHandle EnchantNotice_Txt;
var ItemWindowHandle MaterialSlot1_ItemWnd;
var ItemWindowHandle MaterialSlot2_ItemWnd;
var ItemWindowHandle MaterialSlot3_ItemWnd;
var ItemWindowHandle ArtifactItemSlot_ItemWnd;
var TextureHandle MaterialSlotBack1_Texture;
var TextureHandle MaterialSlotBack2_Texture;
var TextureHandle MaterialSlotBack3_Texture;
var TextureHandle ArtifactItemSlotBack_Texture;
var ButtonHandle Reset_Btn;
var ButtonHandle Enchant_Btn;
var ButtonHandle Close_Btn;
var TextureHandle MaterialSlot1_DropHighlight_Texure;
var TextureHandle MaterialSlot2_DropHighlight_Texure;
var TextureHandle MaterialSlot3_DropHighlight_Texure;
var TextureHandle ArtifactItemSlot_DropHighlight_Texure;
var ProgressCtrlHandle EnchantProgress;
var TextBoxHandle ProbabilityNum_Txt;
var TextBoxHandle Probability_Txt;
var bool isProgress;
var bool isResult;
var int nNeedMaterialCount;
var int nNeedGroupID;
var ArtifactEnchantSubWnd ArtifactEnchantSubWndScript;

function OnRegisterEvent()
{
	RegisterEvent(40);
	RegisterEvent(11050);
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	initControl();
	return;
}

function Initialize()
{
	ArtifactEnchantSubWndScript = ArtifactEnchantSubWnd(GetScript("ArtifactEnchantSubWnd"));
	Me = GetWindowHandle("ArtifactEnchantWnd");
	EnchantProgress = GetProgressCtrlHandle("ArtifactEnchantWnd.EnchantProgress");
	EnchantProgressAnim = GetAnimTextureHandle("ArtifactEnchantWnd.EnchantProgressAnim");
	Instruction_Txt = GetTextBoxHandle("ArtifactEnchantWnd.Instruction_Txt");
	EnchantNotice_Txt = GetTextBoxHandle("ArtifactEnchantWnd.EnchantNotice_Txt");
	ArtifactItemSlot_ItemWnd = GetItemWindowHandle("ArtifactEnchantWnd.ArtifactItemSlot_ItemWnd");
	MaterialSlot1_ItemWnd = GetItemWindowHandle("ArtifactEnchantWnd.MaterialSlot1_ItemWnd");
	MaterialSlot2_ItemWnd = GetItemWindowHandle("ArtifactEnchantWnd.MaterialSlot2_ItemWnd");
	MaterialSlot3_ItemWnd = GetItemWindowHandle("ArtifactEnchantWnd.MaterialSlot3_ItemWnd");
	MaterialSlotBack1_Texture = GetTextureHandle("ArtifactEnchantWnd.MaterialSlotBack1_Texture");
	MaterialSlotBack2_Texture = GetTextureHandle("ArtifactEnchantWnd.MaterialSlotBack2_Texture");
	MaterialSlotBack3_Texture = GetTextureHandle("ArtifactEnchantWnd.MaterialSlotBack3_Texture");
	ArtifactItemSlotBack_Texture = GetTextureHandle("ArtifactEnchantWnd.ArtifactItemSlotBack_Texture");
	Enchant_Btn = GetButtonHandle("ArtifactEnchantWnd.Enchant_Btn");
	Reset_Btn = GetButtonHandle("ArtifactEnchantWnd.Reset_Btn");
	Close_Btn = GetButtonHandle("ArtifactEnchantWnd.Close_Btn");
	MaterialSlot1_DropHighlight_Texure = GetTextureHandle("ArtifactEnchantWnd.MaterialSlot1_DropHighlight_Texure");
	MaterialSlot2_DropHighlight_Texure = GetTextureHandle("ArtifactEnchantWnd.MaterialSlot2_DropHighlight_Texure");
	MaterialSlot3_DropHighlight_Texure = GetTextureHandle("ArtifactEnchantWnd.MaterialSlot3_DropHighlight_Texure");
	ArtifactItemSlot_DropHighlight_Texure = GetTextureHandle("ArtifactEnchantWnd.ArtifactItemSlot_DropHighlight_Texure");
	Probability_Txt = GetTextBoxHandle("ArtifactEnchantWnd.Probability_Txt");
	ProbabilityNum_Txt = GetTextBoxHandle("ArtifactEnchantWnd.ProbabilityNum_Txt");
	return;
}

function initControl()
{
	ResetUI();
	EnchantProgress.SetProgressTime(1500);
	EnchantProgress.SetPos(0);
	EnchantProgress.Reset();
	return;
}

function OnEvent(int Event_ID, string param)
{
	if((Event_ID == 40))
	{
		initControl();
	}
	else if((Event_ID == 11050))
	{
		Debug(("EV_Enchant_Artifact_Result" @ param));
		resultHandler(param);
	}
	return;
}

function OnTimer(int TimerID)
{
	if((TimerID == 100221))
	{
		Enchant_Btn.EnableWindow();
		Me.KillTimer(100221);
	}
	return;
}

function resultHandler(string param)
{
	local int nResult, nEnchant;
	local ItemInfo ResultItemInfo;

	ParseInt(param, "Result", nResult);
	ParseInt(param, "Enchant", nEnchant);
	isResult = true;
	Reset_Btn.EnableWindow();
	if((nResult == 0))
	{
		if((getSlot(0).GetItemNum() > 0))
		{
			MaterialSlot1_ItemWnd.HideWindow();
			MaterialSlot2_ItemWnd.HideWindow();
			MaterialSlot3_ItemWnd.HideWindow();
			getSlot(0).GetItem(0, ResultItemInfo);
			getSlot(0).Clear();
			ResultItemInfo.Enchanted = nEnchant;
			getSlot(0).SetItem(0, ResultItemInfo);
			getSlot(0).AddItem(ResultItemInfo);
			Debug(("resultItemInfo 인챈트 " @ string(ResultItemInfo.Enchanted)));  // EN: resultItemInfo enchant
			Instruction_Txt.SetText(GetSystemString(3885));
			EnchantNotice_Txt.SetText(GetSystemString(3890));
			Enchant_Btn.SetNameText(GetSystemString(3135));
			playEffectAnim(1);
			Me.SetTimer(100221, 1000);
		}
	}
	else if((nResult == 1))
	{
		Debug("강화 실패!");  // EN: enchant failed!
		MaterialSlot1_ItemWnd.HideWindow();
		MaterialSlot2_ItemWnd.HideWindow();
		MaterialSlot3_ItemWnd.HideWindow();
		Instruction_Txt.SetText(GetSystemString(3886));
		EnchantNotice_Txt.SetText(GetSystemString(3890));
		Enchant_Btn.SetNameText(GetSystemString(3135));
		playEffectAnim(2);
		Me.SetTimer(100221, 1000);
	}
	else
	{
		Debug("오류 : 재료가 잘못되었거나 문제가 생겨서 아티팩트 강화에 실패한 경우");  // EN: error : artifact enchant failed, either bad materials or something went wrong
		ResetUI();
		AddSystemMessage(4559);
		Me.HideWindow();
	}
	return;
}

function OnTextureAnimEnd(AnimTextureHandle a_WindowHandle)
{
	local ItemInfo Info;
	local array<int> materialServerIDArray;
	local int i;

	EnchantProgressAnim.Stop();
	EnchantProgressAnim.HideWindow();
	switch(a_WindowHandle)
	{
		case EnchantProgressAnim:
			if(isProgress)
			{
				isProgress = false;
				i = 1;
				i = addMetialArr(i, materialServerIDArray);
				i = addMetialArr(i, materialServerIDArray);
				i = addMetialArr(i, materialServerIDArray);
				if((getSlot(0).GetItemNum() > 0))
				{
					getSlot(0).GetItem(0, Info);
					RequestEnchantArtifact(Info.Id.ServerID, materialServerIDArray);
					Debug(((("----> Call Api RequestEnchantArtifact " @ string(Info.Id.ServerID)) @ ", len: ") @ string(materialServerIDArray.Length)));
					i = 0;
					while((i < materialServerIDArray.Length))
					{
						Debug((("materialServerIDArray:  " @ string(i)) @ string(materialServerIDArray[i])));
						i++;
					}
					Enchant_Btn.DisableWindow();
				}
			}
			break;
		default:
			break;
	}
	return;
}

function OnShow()
{
	getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
	GetWindowHandle("ArtifactEnchantSubWnd").ShowWindow();
	setSlotHighlightFocus(0);
	ArtifactEnchantSubWndScript.SetEnable(true);
	ArtifactEnchantSubWndScript.syncInventory(-1, -1);
	return;
}

function OnHide()
{
	ResetUI();
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Reset_Btn":
			OnReset_BtnClick();
			break;
		case "Enchant_Btn":
			OnEnchant_BtnClick();
			break;
		case "Close_Btn":
			OnClose_BtnClick();
			break;
		default:
			break;
	}
	return;
}

function OnReset_BtnClick()
{
	ResetUI();
	ArtifactEnchantSubWndScript.syncInventory(-1, -1);
	return;
}

function OnClose_BtnClick()
{
	if(isProgress)
	{
		progressBarCancel();
	}
	else
	{
		ResetUI();
		Me.HideWindow();
	}
	return;
}

function OnEnchant_BtnClick()
{
	local ItemInfo Info;

	if(isResult)
	{
		if((getSlot(0).GetItemNum() > 0))
		{
			getSlot(0).GetItem(0, Info);
			getSlot(0).Clear();
			ResetUI();
			dropProcess(Info);
		}
	}
	else
	{
		ArtifactEnchantSubWndScript.SetEnable(false);
		setSlotHighlightFocus(-1);
		playEffectAnim(3);
		EnchantProgress.SetProgressTime(1500);
		EnchantProgress.SetPos(0);
		EnchantProgress.Reset();
		EnchantProgress.Start();
		MaterialSlot1_ItemWnd.EnableTick();
		MaterialSlot2_ItemWnd.EnableTick();
		MaterialSlot3_ItemWnd.EnableTick();
		MaterialSlot1_ItemWnd.ClearAnchor();
		MaterialSlot2_ItemWnd.ClearAnchor();
		MaterialSlot3_ItemWnd.ClearAnchor();
		MaterialSlot1_ItemWnd.Move(72, 29, 1.5000000);
		MaterialSlot2_ItemWnd.Move(-64, 29, 1.5000000);
		MaterialSlot3_ItemWnd.Move(0, -71, 1.5000000);
		Close_Btn.SetNameText(GetSystemString(141));
		Enchant_Btn.SetNameText(GetSystemString(5005));
		isProgress = true;
		setEnchantButtonCheck();
	}
	return;
}

function setEnchantButtonCheck()
{
	local int filledSlotCount, i;

	if(isProgress)
	{
		Enchant_Btn.DisableWindow();
		Reset_Btn.DisableWindow();
		return;
	}
	i = 1;
	while((i < 4))
	{
		if((getSlot(i).GetItemNum() > 0))
		{
			filledSlotCount++;
		}
		i++;
	}
	if(((filledSlotCount > 0) || (getSlot(0).GetItemNum() > 0)))
	{
		Instruction_Txt.SetText(GetSystemString(3884));
		Reset_Btn.EnableWindow();
	}
	else
	{
		Reset_Btn.EnableWindow();
	}
	if((nNeedMaterialCount == filledSlotCount))
	{
		EnchantNotice_Txt.SetText(GetSystemString(3889));
		Enchant_Btn.EnableWindow();
	}
	else
	{
		Enchant_Btn.DisableWindow();
	}
	return;
}

function setInitButtonCheck()
{
	return;
}

function int addMetialArr(int i, out array<int> materialServerIDArray)
{
	local ItemInfo Info;

	if((getSlot(i).GetItemNum() > 0))
	{
		getSlot(i).GetItem(0, Info);
		if((Info.Id.ServerID > 0))
		{
			materialServerIDArray[(i - 1)] = Info.Id.ServerID;
			i++;
			Debug(("보낼 Id.ClassID" @ string(Info.Id.ClassID)));  // EN: Id.ClassID to send
		}
	}
	return i;
}

function ResetUI()
{
	Reset_Btn.DisableWindow();
	ArtifactEnchantSubWndScript.SetEnable(true);
	EnchantProgress.SetPos(0);
	EnchantProgress.Reset();
	EnchantProgressAnim.Stop();
	EnchantProgressAnim.HideWindow();
	ArtifactItemSlot_ItemWnd.Clear();
	MaterialSlot1_ItemWnd.Clear();
	MaterialSlot2_ItemWnd.Clear();
	MaterialSlot3_ItemWnd.Clear();
	MaterialSlot1_ItemWnd.ShowWindow();
	MaterialSlot2_ItemWnd.ShowWindow();
	MaterialSlot3_ItemWnd.ShowWindow();
	MaterialSlot1_ItemWnd.DisableTick();
	MaterialSlot2_ItemWnd.DisableTick();
	MaterialSlot3_ItemWnd.DisableTick();
	MaterialSlot1_ItemWnd.MoveC(93, 116);
	MaterialSlot2_ItemWnd.MoveC(230, 116);
	MaterialSlot3_ItemWnd.MoveC(166, 215);
	MaterialSlotBack1_Texture.ShowWindow();
	MaterialSlotBack2_Texture.ShowWindow();
	MaterialSlotBack3_Texture.ShowWindow();
	setSlotHighlightFocus(0);
	Me.KillTimer(100221);
	Enchant_Btn.DisableWindow();
	Enchant_Btn.SetNameText(GetSystemString(5005));
	Close_Btn.SetNameText(GetSystemString(646));
	isProgress = false;
	isResult = false;
	Instruction_Txt.SetText("");
	EnchantNotice_Txt.SetText(GetSystemString(3887));
	Probability_Txt.HideWindow();
	ProbabilityNum_Txt.SetText("");
	return;
}

function progressBarCancel()
{
	isProgress = false;
	EnchantProgress.SetPos(0);
	EnchantProgress.Reset();
	EnchantProgressAnim.Stop();
	EnchantProgressAnim.HideWindow();
	MaterialSlot1_ItemWnd.DisableTick();
	MaterialSlot2_ItemWnd.DisableTick();
	MaterialSlot3_ItemWnd.DisableTick();
	MaterialSlot1_ItemWnd.MoveC(93, 116);
	MaterialSlot2_ItemWnd.MoveC(230, 116);
	MaterialSlot3_ItemWnd.MoveC(166, 215);
	Enchant_Btn.SetNameText(GetSystemString(5005));
	setEnchantButtonCheck();
	Close_Btn.SetNameText(GetSystemString(646));
	ArtifactEnchantSubWndScript.SetEnable(true);
	return;
}

function OnRClickItem(string strID, int Index)
{
	OnDBClickItem(strID, Index);
	return;
}

function OnDBClickItem(string ControlName, int Index)
{
	local ItemInfo Info;
	local ItemWindowHandle targetItemWnd;

	if(isProgress)
	{
		return;
	}
	if(isResult)
	{
		return;
	}
	switch(ControlName)
	{
		case "MaterialSlot1_ItemWnd":
			targetItemWnd = MaterialSlot1_ItemWnd;
			break;
		case "MaterialSlot2_ItemWnd":
			targetItemWnd = MaterialSlot2_ItemWnd;
			break;
		case "MaterialSlot3_ItemWnd":
			targetItemWnd = MaterialSlot3_ItemWnd;
			break;
		case "ArtifactItemSlot_ItemWnd":
			ResetUI();
			ArtifactEnchantSubWndScript.syncInventory(-1, -1);
			return;
		default:
			break;
	}
	if((ControlName == ""))
	{
		return;
	}
	targetItemWnd.GetItem(0, Info);
	if((Info.Id.ClassID > 0))
	{
		targetItemWnd.Clear();
		ArtifactEnchantSubWndScript.syncInventory(nNeedGroupID, minArtifactEnchantNum());
		setSlotHighlightFocus(findEmptySlotIndex());
	}
	return;
}

function OnDropItem(string a_WindowID, ItemInfo a_itemInfo, int X, int Y)
{
	if((a_itemInfo.DragSrcName != "SubWnd_Item1"))
	{
		return;
	}
	dropProcess(a_itemInfo);
	return;
}

function dropProcess(ItemInfo a_itemInfo)
{
	local int emptySlotIndex, ResultProb;
	local bool bContinue;

	emptySlotIndex = findEmptySlotIndex();
	if((emptySlotIndex <= -1))
	{
		return;
	}
	if((emptySlotIndex == 0))
	{
		Debug("--------------------------------------------------------------------------");
		Class'NWindow.UIDATA_ARTIFACT'.static.GetArtifactEnchantCondition(a_itemInfo.Id.ClassID, a_itemInfo.Enchanted, nNeedGroupID, nNeedMaterialCount, ResultProb);
		Debug(((("메인 슬롯 강화 대상 아이템: " @ a_itemInfo.Name) @ string(a_itemInfo.Id.ClassID)) @ string(a_itemInfo.Enchanted)));  // EN: main slot enchant target item:
		Debug(("groupID       : " @ string(nNeedGroupID)));
		Debug(("materialCount : " @ string(nNeedMaterialCount)));
		Debug(("resultProb    : " @ string(ResultProb)));
		Debug("--------------------------------------------------------------------------");
		Probability_Txt.ShowWindow();
		ProbabilityNum_Txt.SetText((string(ResultProb) $ "%"));
		if((ResultProb <= 0))
		{
			OnReset_BtnClick();
			return;
		}
	}
	Debug(("a_ItemInfo.Enchanted" @ string(a_itemInfo.Enchanted)));
	Debug(("minArtifactEnchantNum()" @ string(minArtifactEnchantNum())));
	getSlot(emptySlotIndex).AddItem(a_itemInfo);
	setActiveMaterialSlot(nNeedMaterialCount);
	ArtifactEnchantSubWndScript.syncInventory(nNeedGroupID, minArtifactEnchantNum());
	setSlotHighlightFocus(findEmptySlotIndex());
	setEnchantButtonCheck();
	return;
}

function int minArtifactEnchantNum()
{
	local ItemInfo Info;
	local int minEnchantNum;

	minEnchantNum = -1;
	if((getSlot(0).GetItemNum() > 0))
	{
		getSlot(0).GetItem(0, Info);
		minEnchantNum = Class'NWindow.UIDATA_ARTIFACT'.static.GetArtifactMinEnchantMaterial(Info.Enchanted);
	}
	return minEnchantNum;
}

function setActiveMaterialSlot(int activeMaterialCount)
{
	getSlot(3).DisableWindow();
	getSlot(2).DisableWindow();
	getSlot(1).DisableWindow();
	MaterialSlotBack1_Texture.HideWindow();
	MaterialSlotBack2_Texture.HideWindow();
	MaterialSlotBack3_Texture.HideWindow();
	switch(activeMaterialCount)
	{
		case 3:
			getSlot(3).EnableWindow();
			MaterialSlotBack3_Texture.ShowWindow();
		case 2:
			getSlot(2).EnableWindow();
			MaterialSlotBack2_Texture.ShowWindow();
		case 1:
			getSlot(1).EnableWindow();
			MaterialSlotBack1_Texture.ShowWindow();
		default:
			return;
	}
}

function int findEmptySlotIndex()
{
	if(((ArtifactItemSlot_ItemWnd.GetItemNum() <= 0) && ArtifactItemSlot_ItemWnd.IsEnableWindow()))
	{
		return 0;
	}
	else if(((MaterialSlot1_ItemWnd.GetItemNum() <= 0) && MaterialSlot1_ItemWnd.IsEnableWindow()))
	{
		return 1;
	}
	else if(((MaterialSlot2_ItemWnd.GetItemNum() <= 0) && MaterialSlot2_ItemWnd.IsEnableWindow()))
	{
		return 2;
	}
	else if(((MaterialSlot3_ItemWnd.GetItemNum() <= 0) && MaterialSlot3_ItemWnd.IsEnableWindow()))
	{
		return 3;
	}
	return -1;
}

function setSlotHighlightFocus(int SlotIndex)
{
	local int limitEnchantNum;

	MaterialSlot1_DropHighlight_Texure.HideWindow();
	MaterialSlot2_DropHighlight_Texure.HideWindow();
	MaterialSlot3_DropHighlight_Texure.HideWindow();
	ArtifactItemSlot_DropHighlight_Texure.HideWindow();
	limitEnchantNum = minArtifactEnchantNum();
	switch(SlotIndex)
	{
		case 1:
			if(MaterialSlot1_ItemWnd.IsEnableWindow())
			{
				MaterialSlot1_DropHighlight_Texure.ShowWindow();
				if((limitEnchantNum > 0))
				{
					EnchantNotice_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(5217), string(limitEnchantNum)));
				}
				else
				{
					EnchantNotice_Txt.SetText(GetSystemString(3888));
				}
			}
			break;
		case 2:
			if(MaterialSlot2_ItemWnd.IsEnableWindow())
			{
				MaterialSlot2_DropHighlight_Texure.ShowWindow();
				if((limitEnchantNum > 0))
				{
					EnchantNotice_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(5217), string(limitEnchantNum)));
				}
				else
				{
					EnchantNotice_Txt.SetText(GetSystemString(3888));
				}
			}
			break;
		case 3:
			if(MaterialSlot3_ItemWnd.IsEnableWindow())
			{
				MaterialSlot3_DropHighlight_Texure.ShowWindow();
				if((limitEnchantNum > 0))
				{
					EnchantNotice_Txt.SetText(MakeFullSystemMsg(GetSystemMessage(5217), string(limitEnchantNum)));
				}
				else
				{
					EnchantNotice_Txt.SetText(GetSystemString(3888));
				}
			}
			break;
		case 0:
			ArtifactItemSlot_DropHighlight_Texure.ShowWindow();
			EnchantNotice_Txt.SetText(GetSystemString(3887));
			break;
		default:
			break;
	}
	return;
}

function ItemInfo getSlotItemInfo(int SlotIndex)
{
	local ItemInfo tmInfo;

	switch(SlotIndex)
	{
		case 1:
			if((MaterialSlot1_ItemWnd.GetItemNum() > 0))
			{
				MaterialSlot1_ItemWnd.GetItem(0, tmInfo);
			}
			break;
		case 2:
			if((MaterialSlot2_ItemWnd.GetItemNum() > 0))
			{
				MaterialSlot2_ItemWnd.GetItem(0, tmInfo);
			}
			break;
		case 3:
			if((MaterialSlot3_ItemWnd.GetItemNum() > 0))
			{
				MaterialSlot3_ItemWnd.GetItem(0, tmInfo);
			}
			break;
		case 0:
			if((ArtifactItemSlot_ItemWnd.GetItemNum() > 0))
			{
				ArtifactItemSlot_ItemWnd.GetItem(0, tmInfo);
			}
			break;
		default:
			Debug(("** 경고 : ArtifactEnchantWnd 의 getSlotItemInfo의 입력값이 잘못됨 :" @ string(SlotIndex)));  // EN: ** warning : bad input to getSlotItemInfo in ArtifactEnchantWnd :
	}
	return tmInfo;
}

function ItemWindowHandle getSlot(int SlotIndex)
{
	local ItemWindowHandle tm;

	switch(SlotIndex)
	{
		case 1:
			tm = MaterialSlot1_ItemWnd;
			break;
		case 2:
			tm = MaterialSlot2_ItemWnd;
			break;
		case 3:
			tm = MaterialSlot3_ItemWnd;
			break;
		case 0:
			tm = ArtifactItemSlot_ItemWnd;
			break;
		default:
			Debug(("** 경고 : ArtifactEnchantWnd 의 getSlot의 입력값이 잘못됨 :" @ string(SlotIndex)));  // EN: ** warning : bad input to getSlot in ArtifactEnchantWnd :
	}
	return tm;
}

function bool externalCheckUsingItem(ItemInfo Info)
{
	local bool RValue;
	local int i;

	i = 0;
	while((i < 4))
	{
		if((getSlotItemInfo(i).Id == Info.Id))
		{
			RValue = true;
		}
		i++;
	}
	return RValue;
}

function playEffectAnim(int animType)
{
	EnchantProgressAnim.SetLoopCount(1);
	if((animType == 1))
	{
		PlaySound("ItemSound3.enchant_success");
		EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Success_00");
		EnchantProgressAnim.Stop();
		EnchantProgressAnim.Play();
	}
	else if((animType == 2))
	{
		PlaySound("ItemSound3.enchant_fail");
		EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Failed_01");
		EnchantProgressAnim.Stop();
		EnchantProgressAnim.Play();
	}
	else
	{
		PlaySound("ItemSound3.enchant_process");
		EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Loading_01");
		EnchantProgressAnim.Stop();
		EnchantProgressAnim.Play();
	}
	EnchantProgressAnim.ShowWindow();
	return;
}

function OnReceivedCloseUI()
{
	PlayConsoleSound(IFST_WINDOW_CLOSE);
	GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
	return;
}
