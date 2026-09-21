class UICommonAPI extends UIConstants
	dependson(UIPacket);

struct AbilityPresetInfo
{
	var int currentPreset;
	var int aPresetRemainAP;
	var int bPresetRemainAP;
};
struct CrossEventSlotInfo
{
	var bool checked;
	var bool crossed;
	var int SlotNum;
	var int Row;
	var int Column;
	var UIPacket._ItemInfo RewardItemInfo;
};
struct ItemAutoPeelInfo
{
	var int targetItemSId;
	var string targetItemName;
	var INT64 remainPeelCnt;
	var INT64 totalPeelCnt;
	var bool isPeeling;
	var bool isPause;
	var bool isExpand;
	var bool isComplete;
	var int readyTargetItemSid;
	var INT64 readyTotalPeelCnt;
	var int maxGradeColor;
	var array<UIPacket._AutoPeelResultItem> normalItemInfos;
	var array<UIPacket._AutoPeelResultItem> rareItemInfos;
};
enum EL2PassStepState
{
	NotInProgress,                  // 0
	InProgress,                     // 1
	CompleteNotRewardStep,          // 2
	CompleteRewardReady,            // 3
	CompleteRewarded                // 4
};
enum EL2PassType
{
	Hunt,                           // 0
	Advance,                        // 1
	Max                             // 2
};
struct L2PassStepInfo
{
	var int Index;
	var EL2PassType PassType;
	var EL2PassStepState stepState;
	var bool isPremiumStep;
	var bool isPremiumActivated;
	var int RewardType;
	var int RewardItemID;
	var int rewardItemCnt;
	var int missionMaxCnt;
	var int missionCnt;
};
struct L2PassInfo
{
	var EL2PassType PassType;
	var bool isOn;
	var bool isPremiumActivated;
	var int maxStep;
	var int currentStep;
	var int freeStepNum;
	var int premiumStepNum;
	var int maxStepPage;
	var int currentStepPage;
	var int rewardStep;
	var int premiumRewardStep;
	var int currentMissionCnt;
	var int maxMissionCnt;
	var int notReceivedRewardNum;
	var int LeftTime;
	var array<L2PassStepInfo> stepInfos;
	var array<L2PassStepInfo> premiumStepInfos;
};
struct L2PassSayhasSupportInfo
{
	var bool isOn;
	var int usedTime;
	var int earnedTime;
	var int maxTIme;
};
enum directionType
{
	big,                            // 0
	small                           // 1
};
struct ShakeObject
{
	var WindowHandle Target;
	var string Owner;
	var int Id;
	var float Position;
	var float Duration;
	var float Delay;
	var float shakeSize;
	var int posX;
	var int posY;
	var bool shakeStarted;
	var directionType Direction;
};
struct TweenObject
{
	var WindowHandle Target;
	var string Owner;
	var int Id;
	var float Position;
	var float Duration;
	var float Delay;
	var int sizeXStart;
	var int sizeYStart;
	var float MoveX;
	var float MoveY;
	var float Alpha;
	var float SizeX;
	var float SizeY;
	var int alphaStart;
	var int posX;
	var int posY;
	var easeType ease;
	var bool tweenStarted;
};
struct PetPreviewInfo
{
	var int PetID;
	var int PetLevel;
	var int ItemClassID;
	var int itemServerID;
	var int itemDBID;
	var int petEnvolveStep;
	var int PetNamePrefixID;
	var int PetNameID;
	var int petClassID;
	var int petEvolutionLook;
	var INT64 currentExp;
	var INT64 minExp;
	var INT64 MaxExp;
};
struct PetSkillSlotInfo__PetPreviewWnd
{
	var bool learned;
	var bool isActiveSkill;
	var bool isCanLevelUp;
	var int OrderID;
	var int GroupType;
	var int replaceSkillId;
	var int originalSkillId;
	var SkillInfo SkillInfo;
	var ItemInfo skillItemInfo;
	var int MinLevel;
	var int MaxLevel;
};
struct PetSkillGroupInfo__PetPreviewWnd
{
	var int GroupType;
	var array<PetSkillSlotInfo__PetPreviewWnd> Skills;
};
struct PetSkillSlotInfo__PetSkillWnd
{
	var bool learned;
	var bool isAction;
	var bool isActiveSkill;
	var bool isItemTypeSkill;
	var bool isCanLevelUp;
	var bool isShortCut;
	var int OrderID;
	var int GroupType;
	var int replaceSkillId;
	var SkillInfo SkillInfo;
	var ItemInfo skillItemInfo;
	var int MinLevel;
	var int MaxLevel;
};
struct PetSkillGroupInfo__PetSkillWnd
{
	var int GroupType;
	var array<PetSkillSlotInfo__PetSkillWnd> Skills;
};
struct PrisonUIInfo
{
	var bool inPrison;
	var int PrisonType;
	var PrisonUIData prisonData;
	var int serverRemainTime;
	var int uiRemainTime;
	var int currentItemCnt;
};
struct MagicLampExpInfo
{
	var INT64 Exp;
	var INT64 Count;
};
struct MagicLampGetInfo
{
	var MagicLampExpInfo expInfos[4];
	var INT64 totalNum;
};
enum ERelicUIState
{
	List,                           // 0
	SHOP,                           // 1
	UPGRADE,                        // 2
	COMBINE,                        // 3
	COLLECTION,                     // 4
	EXCHANGE,                       // 5
	Max                             // 6
};
struct RelicCollectionInfo
{
	var RelicsCollectionUIData Data;
	var int CollectionID;
	var bool isComplete;
	var array<UIPacket._CollectionRelicsInfo> relicsList;
	var bool IsNew;
};
struct RelicCombineInfo
{
	var array<int> stuffTotalArray;
	var UIConstants.ERelicGrade Grade;
};
struct RelicExchangeInfo
{
	var UIPacket._RelicsExchangeInfo Info;
};
struct RelicInfo
{
	var RelicsMainUIData Data;
	var int relicId;
	var INT64 Count;
	var bool isEnabled;
	var int Level;
	var bool IsNew;
	var bool IsActive;
	var bool isStuffDisable;
};
struct RelicUIInfo
{
	var ERelicUIState uiState;
	var int activeRelicId;
	var bool isListNew;
	var bool isCollectionNew;
	var bool isExchangeNew;
	var int exchangeMaxNum;
	var bool isShopReddot;
};
struct RelicUpgradeInfo
{
	var array<int> stuffArray;
	var int targetRelicId;
	var RelicInfo RelicInfo;
};
enum EAutoCraftType
{
	ACNone,                         // 0
	ACLimitedItem,                  // 1
	ACFixedCount                    // 2
};
enum EAutoCraftState
{
	ACNoraml,                       // 0
	ACProcess,                      // 1
	ACResult                        // 2
};
struct AutoCraftInfo
{
	var bool useAutoCraft;
	var EAutoCraftType Type;
	var int maxCount;
	var int currentCount;
	var int craftSlotNum;
	var int craftNumArray[5];
	var EAutoCraftState uiState;
	var ItemInfo limitedItemInfo;
};
enum ETeleportListTagType
{
	TLTT_DEFAULT,                   // 0
	TLTT_NEW,                       // 1
	TLTT_EVENT,                     // 2
	TLTT_MAX                        // 3
};
struct TeleportInfo
{
	var string Name;
	var int Id;
	var int TownID;
	var int RcZoneID;
	var int DominionID;
	var int locX;
	var int locY;
	var int Type;
	var int Level;
	var int Priority;
	var array<RequestItem> Price;
	var int UsableLevel;
	var int UsableTransferDegree;
	var int ServerRange;
	var bool isTown;
	var bool isRcTown;
	var bool isSpecial;
	var bool isWorldServer;
	var ETeleportListTagType tagType;
	var int TagStartTime;
	var int TagEndTime;
	var ETeleportListTagType showTagType;
};
struct TeleportTownInfo
{
	var TeleportInfo townInfo;
	var array<TeleportInfo> dominions;
};
enum EMissionLevelRewardState
{
	Unavailable,                    // 0
	Available,                      // 1
	AlreadyReceived                 // 2
};
struct MissionLevelStepInfo
{
	var int Level;
	var MissionRewardItem baseRewardItem;
	var MissionRewardItem keyRewardItem;
	var EMissionLevelRewardState baseRewardState;
	var EMissionLevelRewardState keyRewardState;
};
struct VirtualSlotInfo
{
	var int vMainIndex;
	var int vSubIndex;
	var int SlotIndex;
	var ItemInfo ItemInfo;
	var INT64 SlotBitType;
	var bool IsVirtualItem;
	var bool isSubSlot;
	var bool isBuffSlot;
	var bool isDisabled;
	var int point;
	var int Enchant;
	var int slotNameStrId;
	var int ClassID;
};

const EV_USER_CharacterSelectionChanged = 50000;

enum _FileHandler
{
	FH_NONE,                        // 0
	FH_PLEDGE_CREST_UPLOAD,         // 1
	FH_PLEDGE_EMBLEM_UPLOAD,        // 2
	FH_ALLIANCE_CREST_UPLOAD,       // 3
	FH_WEBBROWSER_FILE_UPLOAD,      // 4
	FH_MAX                          // 5
};

var bool bDoNotUseDebug;
var array<UIControlDialogAssets> uicontrolDialogs;

static function UICommonAPI InstUICommonAPI()
{
	return new Class'Interface.UICommonAPI';
}

function FileRegisterWndShow(_FileHandler filehandlertype)
{
	local FileRegisterWnd Script;

	Script = FileRegisterWnd(GetScript("FileRegisterWnd"));
	Script.ShowFileRegisterWnd(filehandlertype);
	return;
}

function AddFileRegisterWndFileExt(string Str, array<string> strArray)
{
	local FileRegisterWnd Script;

	Script = FileRegisterWnd(GetScript("FileRegisterWnd"));
	Script.AddFileExt(Str, strArray);
	return;
}

function ClearFileRegisterWndFileExt()
{
	local FileRegisterWnd Script;

	Script = FileRegisterWnd(GetScript("FileRegisterWnd"));
	Script.ClearFileExt();
	return;
}

function FileRegisterWndHide()
{
	local FileRegisterWnd Script;

	Script = FileRegisterWnd(GetScript("FileRegisterWnd"));
	Script.HideFileRegisterWnd();
	return;
}

static function DialogShowHtmlWithTarget(UIScript.EDialogModalType modalType, UIScript.EDialogType dialogType, string strMessage, string strControlName)
{
	Class'Interface.DialogBox'.static.Inst()._DialogShowHtmlWithTarget(modalType, dialogType, strMessage, strControlName);
	return;
}

function DialogShowHtml(UIScript.EDialogModalType modalType, UIScript.EDialogType dialogType, string strMessage, optional WindowHandle wnd)
{
	if((wnd.m_pTargetWnd == none))
	{
		wnd = m_hOwnerWnd;
	}
	Class'Interface.DialogBox'.static.Inst()._DialogShowHtml(modalType, dialogType, strMessage, wnd);
	return;
}

static function DialogShowWithTarget(UIScript.EDialogModalType modalType, UIScript.EDialogType dialogType, string strMessage, string strControlName)
{
	Class'Interface.DialogBox'.static.Inst()._DialogShowWithTarget(modalType, dialogType, strMessage, strControlName);
	return;
}

function DialogShow(UIScript.EDialogModalType modalType, UIScript.EDialogType dialogType, string strMessage, optional WindowHandle targetWnd)
{
	if((targetWnd.m_pTargetWnd == none))
	{
		targetWnd = m_hOwnerWnd;
	}
	Class'Interface.DialogBox'.static.Inst()._DialogShow(modalType, dialogType, strMessage, targetWnd);
	return;
}

static function DialogSetCancelD(int targetCancelDialogID)
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	Script.SetDialogCancelD(targetCancelDialogID);
	return;
}

static function DialogSetButtonName(int indexOK, optional int indexCancel)
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	Script._SetButtonName(indexOK, indexCancel);
	return;
}

static function DialogSetButtonWidthSize(int indexOK, optional int indexCancel)
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	Script.SetButtonWidthSize(indexOK, indexCancel);
	return;
}

static function DialogMoveToCursor()
{
	Class'Interface.DialogBox'.static.Inst()._DialogMoveToCursor();
	return;
}

static function DialogHide()
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	Script.HideDialog();
	return;
}

static function DialogSetDefaultOK()
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	Script.SetDefaultAction(EDefaultOK);
	return;
}

static function DialogSetDefaultCancle()
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	Script.SetDefaultAction(EDefaultCancel);
	return;
}

static function DialogSetEnterDoNothing()
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	Script.SetEnterAction(EEnterDoNothing);
	return;
}

static function DialogSetEnterOK()
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	Script.SetEnterAction(EEnterOK);
	return;
}

static function DialogSetEnterCancle()
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	Script.SetEnterAction(EEnterCancel);
	return;
}

function bool DialogIsMine()
{
	return Class'Interface.DialogBox'.static.Inst()._IsOwnerWindow(m_hOwnerWnd);
}

function bool DialogHasPreviousCancelProcess()
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	return Script.HasPreviousCancelProcess();
}

function bool DialogCheckCancelByID(int targetDialogID)
{
	local DialogBox Script;

	Script = DialogBox(GetScript("dialogbox"));
	return Script.CheckCancelDialogID(targetDialogID);
}

static function bool DialogIsMineWithTarget(string TargetName)
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	return (Script.GetTarget() == TargetName);
}

static function DialogSetID(int Id)
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	Script.setId(Id);
	return;
}

static function DialogSetEditType(string strType)
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	Script.SetEditType(strType);
	return;
}

static function string DialogGetString()
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	return Script.GetEditMessage();
}

static function DialogSetString(string strInput)
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	Script.SetEditMessage(strInput);
	return;
}

static function int DialogGetID()
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	return Script.GetID();
}

static function DialogSetParamInt64(INT64 param)
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	Script.setParamInt64(param);
	return;
}

static function DialogSetReservedInt(int Value)
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	Script.SetReservedInt(Value);
	return;
}

static function DialogSetReservedInt2(INT64 Value)
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	Script.SetReservedInt2(Value);
	return;
}

static function DialogSetReservedInt3(int Value)
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	Script.SetReservedInt3(Value);
	return;
}

static function DialogSetReservedItemID(ItemID Id)
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	Script.SetReservedItemID(Id);
	return;
}

static function DialogSetReservedItemInfo(ItemInfo Info)
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	Script.SetReservedItemInfo(Info);
	return;
}

static function int DialogGetReservedInt()
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	return Script.GetReservedInt();
}

static function INT64 DialogGetReservedInt2()
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	return Script.GetReservedInt2();
}

static function int DialogGetReservedInt3()
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	return Script.GetReservedInt3();
}

static function ItemID DialogGetReservedItemID()
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	return Script.GetReservedItemID();
}

static function DialogGetReservedItemInfo(out ItemInfo Info)
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	Script.GetReservedItemInfo(Info);
	return;
}

static function DialogSetEditBoxMaxLength(int MaxLength)
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	Script.SetEditBoxMaxLength(MaxLength);
	return;
}

static function DialogSetIconTexture(string iconTextureStr)
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	Script.SetIconTexture(iconTextureStr);
	return;
}

static function DialogSetIconCustomToolTip(CustomTooltip toolTipInfo)
{
	local DialogBox Script;

	Script = DialogBox(GetScript("DialogBox"));
	Script.SetIconCustomToolTip(toolTipInfo);
	return;
}

static function DialogSetInputlimit(INT64 inputLimit)
{
	Class'Interface.DialogBox'.static.Inst()._inputLimit(inputLimit);
	return;
}

static function int Split(string strInput, string delim, out array<string> arrToken)
{
	local int arrSize;

	while((InStr(strInput, delim) > 0))
	{
		arrToken.Insert(arrToken.Length, 1);
		arrToken[(arrToken.Length - 1)] = Left(strInput, InStr(strInput, delim));
		strInput = Mid(strInput, (InStr(strInput, delim) + 1));
		arrSize = (arrSize + 1);
	}
	arrToken.Insert(arrToken.Length, 1);
	arrToken[(arrToken.Length - 1)] = strInput;
	arrSize = (arrSize + 1);
	return arrSize;
}

function ShowWindow(string a_ControlID)
{
	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(a_ControlID);
	return;
}

function toggleWindow(string a_ControlID, optional bool bFocus, optional bool bUseOpenCloseSound)
{
	if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(a_ControlID))
	{
		if(bUseOpenCloseSound)
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
		}
		Class'NWindow.UIAPI_WINDOW'.static.HideWindow(a_ControlID);
	}
	else
	{
		if(bUseOpenCloseSound)
		{
			PlayConsoleSound(IFST_WINDOW_CLOSE);
		}
		if(Class'Interface.MinimizeManager'.static.Inst()._IsMin(a_ControlID))
		{
			Class'Interface.MinimizeManager'.static.Inst()._MaximizeWindow(a_ControlID);
		}
		else
		{
			Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(a_ControlID);
		}
		if(bFocus)
		{
			Class'NWindow.UIAPI_WINDOW'.static.SetFocus(a_ControlID);
		}
	}
	return;
}

function ShowWindowWithFocus(string a_ControlID)
{
	Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(a_ControlID);
	Class'NWindow.UIAPI_WINDOW'.static.SetFocus(a_ControlID);
	return;
}

static function string reverseString(string Str)
{
	local string reverseStr;
	local int i;

	i = (Len(Str) - 1);
	while((i >= 0))
	{
		reverseStr = (reverseStr $ Mid(Str, i, 1));
		--i;
	}
	return reverseStr;
}

function bool IsOnlyNumber(string Str)
{
	local string M;
	local int i;

	i = 0;
	while((i < Len(Str)))
	{
		M = Mid(Str, i, 1);
		if(((Asc(M) > 47) && (Asc(M) < 58)))
		{
			i++;
			continue;
			i++;
			continue;
		}
		return false;
		i++;
	}
	return true;
}

static function ReplaceText(out string Text, string Replace, string With)
{
	local int i;
	local string Input;

	if(((Text == "") || (Replace == "")))
	{
		return;
	}
	Input = Text;
	Text = "";
	i = InStr(Input, Replace);
	while((i != -1))
	{
		Text = ((Text $ Left(Input, i)) $ With);
		Input = Mid(Input, (i + Len(Replace)));
		i = InStr(Input, Replace);
	}
	Text = (Text $ Input);
	return;
}

static function string trim(string S)
{
	local int i;

	if((Len(S) == 0))
	{
		return S;
	}
	i = 0;
	while(((Mid(S, i, 1) == " ") || (Mid(S, i, 1) == "t")))
	{
		++i;
	}
	S = Right(S, (Len(S) - i));
	if((Len(S) == 0))
	{
		return S;
	}
	i = (Len(S) - 1);
	while(((Mid(S, i, 1) == " ") || (Mid(S, i, 1) == "t")))
	{
		--i;
	}
	S = Left(S, (i + 1));
	return S;
}

static function string trimParam(string S)
{
	local int i;

	if((Len(S) == 0))
	{
		return S;
	}
	i = 0;
	while(((Mid(S, i, 1) == " ") || (Mid(S, i, 1) == Chr(127))))
	{
		++i;
	}
	S = Right(S, (Len(S) - i));
	if((Len(S) == 0))
	{
		return S;
	}
	i = (Len(S) - 1);
	while(((Mid(S, i, 1) == " ") || (Mid(S, i, 1) == Chr(127))))
	{
		--i;
	}
	S = Left(S, (i + 1));
	return S;
}

static function string deleteEnter(string S)
{
	local int i;

	if((Len(S) == 0))
	{
		return S;
	}
	i = 0;
	while(((Mid(S, i, 1) == Chr(13)) || (Mid(S, i, 1) == Chr(10))))
	{
		++i;
	}
	S = Right(S, (Len(S) - i));
	if((Len(S) == 0))
	{
		return S;
	}
	i = (Len(S) - 1);
	while(((Mid(S, i, 1) == Chr(13)) || (Mid(S, i, 1) == Chr(10))))
	{
		--i;
	}
	S = Left(S, (i + 1));
	return S;
}

static function int InStrFromBack(string S, string t)
{
	local string reverseStr;
	local int i;

	reverseStr = reverseString(S);
	i = InStr(reverseStr, t);
	if((i >= 0))
	{
		return ((Len(S) - 1) - i);
	}
	else
	{
		return i;
	}
}

static function int InStrFromBack2(string S, string t)
{
	local string reverseStr;
	local int i;

	reverseStr = reverseString(S);
	i = InStr(reverseStr, reverseString(t));
	if((i >= 0))
	{
		return ((Len(S) - 1) - i);
	}
	else
	{
		return i;
	}
}

function HideWindow(string a_ControlID)
{
	Class'NWindow.UIAPI_WINDOW'.static.HideWindow(a_ControlID);
	return;
}

function bool IsShowWindow(string a_ControlID)
{
	return Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(a_ControlID);
}

function ParamToRecord(string param, out LVDataRecord Record)
{
	local int idx, MaxColumn;

	ParseString(param, "szReserved", Record.szReserved);
	ParseINT64(param, "nReserved1", Record.nReserved1);
	ParseINT64(param, "nReserved2", Record.nReserved2);
	ParseINT64(param, "nReserved3", Record.nReserved3);
	ParseInt(param, "MaxColumn", MaxColumn);
	Record.LVDataList.Length = MaxColumn;
	idx = 0;
	while((idx < MaxColumn))
	{
		ParseString(param, ("szData_" $ string(idx)), Record.LVDataList[idx].szData);
		ParseString(param, ("szReserved_" $ string(idx)), Record.LVDataList[idx].szReserved);
		ParseInt(param, ("nReserved1_" $ string(idx)), Record.LVDataList[idx].nReserved1);
		ParseInt(param, ("nReserved2_" $ string(idx)), Record.LVDataList[idx].nReserved2);
		ParseInt(param, ("nReserved3_" $ string(idx)), Record.LVDataList[idx].nReserved3);
		idx++;
	}
	return;
}

function ParamToRowData(string param, out RichListCtrlRowData rowData)
{
	local int idx, MaxColumn;

	ParseString(param, "szReserved", rowData.szReserved);
	ParseINT64(param, "nReserved1", rowData.nReserved1);
	ParseINT64(param, "nReserved2", rowData.nReserved2);
	ParseINT64(param, "nReserved3", rowData.nReserved3);
	ParseInt(param, "MaxColumn", MaxColumn);
	rowData.cellDataList.Length = MaxColumn;
	idx = 0;
	while((idx < MaxColumn))
	{
		ParseString(param, ("szData_" $ string(idx)), rowData.cellDataList[idx].szData);
		ParseString(param, ("szReserved_" $ string(idx)), rowData.cellDataList[idx].szReserved);
		ParseInt(param, ("nReserved1_" $ string(idx)), rowData.cellDataList[idx].nReserved1);
		ParseInt(param, ("nReserved2_" $ string(idx)), rowData.cellDataList[idx].nReserved2);
		ParseInt(param, ("nReserved3_" $ string(idx)), rowData.cellDataList[idx].nReserved3);
		idx++;
	}
	return;
}

function CustomTooltip MakeTooltipSimpleText(string Text, optional int toolTipWidth)
{
	local CustomTooltip ToolTip;
	local DrawItemInfo Info;
	local bool oneline;

	oneline = true;
	if((toolTipWidth > 0))
	{
		oneline = false;
	}
	ToolTip.DrawList.Length = 1;
	ToolTip.MinimumWidth = toolTipWidth;
	Info.eType = DIT_TEXT;
	Info.t_bDrawOneLine = oneline;
	Info.t_color.R = 230;
	Info.t_color.G = 230;
	Info.t_color.B = 230;
	Info.t_color.A = 255;
	Info.t_strText = Text;
	ToolTip.DrawList[0] = Info;
	return ToolTip;
}

function CustomTooltip MakeTooltipSimpleColorText(string Text, Color TextColor, optional string FontName, optional int toolTipWidth)
{
	local CustomTooltip ToolTip;
	local bool oneline;

	oneline = true;
	if((toolTipWidth > 0))
	{
		oneline = false;
	}
	ToolTip.MinimumWidth = toolTipWidth;
	ToolTip.DrawList[0] = addDrawItemText(Text, TextColor, FontName, oneline);
	return ToolTip;
}

function CustomTooltip MakeTooltipMultiText(string line1text, Color text1Color, optional string font1Name, optional bool bLine1Break, optional string line2text, optional Color text2Color, optional string font2Name, optional bool bLine2Break, optional string line3text, optional Color text3Color, optional string font3Name, optional bool bLine3Break, optional int toolTipWidth)
{
	local CustomTooltip ToolTip;
	local int countLength, textWidth, textHeight, maxTextWidth;

	countLength = 0;
	if((font1Name == ""))
	{
		font1Name = "GameDefault";
	}
	if((font2Name == ""))
	{
		font2Name = "GameDefault";
	}
	if((font3Name == ""))
	{
		font3Name = "GameDefault";
	}
	if((line1text != ""))
	{
		countLength++;
		GetTextSize(line1text, font1Name, textWidth, textHeight);
		if((textWidth > maxTextWidth))
		{
			maxTextWidth = textWidth;
		}
	}
	if((line2text != ""))
	{
		countLength++;
		GetTextSize(line2text, font2Name, textWidth, textHeight);
		if((textWidth > maxTextWidth))
		{
			maxTextWidth = textWidth;
		}
	}
	if((line3text != ""))
	{
		countLength++;
		GetTextSize(line3text, font3Name, textWidth, textHeight);
		if((textWidth > maxTextWidth))
		{
			maxTextWidth = textWidth;
		}
	}
	ToolTip.DrawList.Length = countLength;
	if((toolTipWidth > 0))
	{
		ToolTip.MinimumWidth = toolTipWidth;
	}
	else
	{
		ToolTip.MinimumWidth = (maxTextWidth + 1);
	}
	if((line1text != ""))
	{
		ToolTip.DrawList[0] = addDrawItemText(line1text, text1Color, font1Name, bLine1Break);
	}
	if((line2text != ""))
	{
		ToolTip.DrawList[1] = addDrawItemText(line2text, text2Color, font2Name, bLine2Break);
	}
	if((line3text != ""))
	{
		ToolTip.DrawList[2] = addDrawItemText(line3text, text3Color, font3Name, bLine3Break);
	}
	return ToolTip;
}

function CustomTooltip MakeTooltipMultiTextByArray(array<DrawItemInfo> drawItemInfoArr, optional int toolTipWidth)
{
	local CustomTooltip ToolTip;

	ToolTip.DrawList = drawItemInfoArr;
	if((toolTipWidth > 0))
	{
		ToolTip.MinimumWidth = toolTipWidth;
	}
	return ToolTip;
}

function DrawItemInfo addDrawItemText(string Text, Color TextColor, optional string FontName, optional bool bLineBreak, optional bool oneline, optional int OffsetX, optional int OffsetY, optional int MaxWidth)
{
	local DrawItemInfo Info;
	local array<TextSectionInfo> TextInfos;
	local string FullText;

	Info.eType = DIT_TEXT;
	Info.t_color.R = TextColor.R;
	Info.t_color.G = TextColor.G;
	Info.t_color.B = TextColor.B;
	Info.t_color.A = TextColor.A;
	GetItemTextSectionInfos(Text, FullText, TextInfos);
	if((TextInfos.Length > 0))
	{
		Text = FullText;
		Info.t_SectionList = TextInfos;
	}
	Info.t_strText = Text;
	if((MaxWidth > 0))
	{
		Info.t_MaxWidth = MaxWidth;
	}
	Info.t_bDrawOneLine = oneline;
	Info.bLineBreak = bLineBreak;
	Info.nOffSetX = OffsetX;
	Info.nOffSetY = OffsetY;
	if((FontName != ""))
	{
		Info.t_strFontName = FontName;
	}
	return Info;
}

function DrawItemInfo addDrawItemText_DIAT_Right(string Text, Color TextColor, optional string FontName, optional bool bLineBreak, optional bool oneline, optional int OffsetX, optional int OffsetY, optional int MaxWidth)
{
	local DrawItemInfo Info;
	local array<TextSectionInfo> TextInfos;
	local string FullText;

	Info.eType = DIT_TEXT;
	Info.t_color.R = TextColor.R;
	Info.t_color.G = TextColor.G;
	Info.t_color.B = TextColor.B;
	Info.t_color.A = TextColor.A;
	GetItemTextSectionInfos(Text, FullText, TextInfos);
	if((TextInfos.Length > 0))
	{
		Text = FullText;
		Info.t_SectionList = TextInfos;
	}
	Info.t_strText = Text;
	if((MaxWidth > 0))
	{
		Info.t_MaxWidth = MaxWidth;
	}
	Info.t_bDrawOneLine = oneline;
	Info.bLineBreak = bLineBreak;
	Info.nOffSetX = OffsetX;
	Info.nOffSetY = OffsetY;
	Info.eAlignType = DIAT_RIGHT;
	if((FontName != ""))
	{
		Info.t_strFontName = FontName;
	}
	return Info;
}

function DrawItemInfo addDrawItemText_DIAT_CENTER(string Text, Color TextColor, optional string FontName, optional bool bLineBreak, optional bool oneline, optional int OffsetX, optional int OffsetY, optional int MaxWidth)
{
	local DrawItemInfo Info;
	local array<TextSectionInfo> TextInfos;
	local string FullText;

	Info.eType = DIT_TEXT;
	Info.t_color.R = TextColor.R;
	Info.t_color.G = TextColor.G;
	Info.t_color.B = TextColor.B;
	Info.t_color.A = TextColor.A;
	GetItemTextSectionInfos(Text, FullText, TextInfos);
	if((TextInfos.Length > 0))
	{
		Text = FullText;
		Info.t_SectionList = TextInfos;
	}
	Info.t_strText = Text;
	if((MaxWidth > 0))
	{
		Info.t_MaxWidth = MaxWidth;
	}
	Info.t_bDrawOneLine = oneline;
	Info.bLineBreak = bLineBreak;
	Info.nOffSetX = OffsetX;
	Info.nOffSetY = OffsetY;
	Info.eAlignType = DIAT_CENTER;
	if((FontName != ""))
	{
		Info.t_strFontName = FontName;
	}
	return Info;
}

function DrawItemInfo addDrawItemFormatText(string Text, Color TextColor, optional string FontName, optional bool bLineBreak, optional bool oneline, optional int OffsetX, optional int OffsetY)
{
	local DrawItemInfo Info;

	Info.eType = DIT_FORMATTEXT;
	Info.t_color.R = TextColor.R;
	Info.t_color.G = TextColor.G;
	Info.t_color.B = TextColor.B;
	Info.t_color.A = TextColor.A;
	Info.t_strText = Text;
	Info.t_bDrawOneLine = oneline;
	Info.bLineBreak = bLineBreak;
	Info.nOffSetX = OffsetX;
	Info.nOffSetY = OffsetY;
	if((FontName != ""))
	{
		Info.t_strFontName = FontName;
	}
	return Info;
}

function DrawItemInfo addDrawItemTexture(string Texture, optional bool oneline, optional bool bLineBreak, optional int OffsetX, optional int OffsetY)
{
	local DrawItemInfo Info;

	Info.eType = DIT_TEXTURE;
	Info.t_bDrawOneLine = oneline;
	Info.bLineBreak = bLineBreak;
	Info.u_nTextureWidth = 16;
	Info.u_nTextureHeight = 16;
	Info.nOffSetX = OffsetX;
	Info.nOffSetY = OffsetY;
	Info.u_nTextureUWidth = 32;
	Info.u_nTextureUHeight = 32;
	Info.u_strTexture = Texture;
	return Info;
}

function DrawItemInfo addDrawItemTextureCustom(string Texture, optional bool oneline, optional bool bLineBreak, optional int OffsetX, optional int OffsetY, optional int u_nTextureWidth, optional int u_nTextureHeight, optional int u_nTextureUWidth, optional int u_nTextureUHeight)
{
	local DrawItemInfo Info;

	Info.eType = DIT_TEXTURE;
	Info.t_bDrawOneLine = oneline;
	Info.bLineBreak = bLineBreak;
	Info.u_nTextureWidth = u_nTextureWidth;
	Info.u_nTextureHeight = u_nTextureHeight;
	Info.nOffSetX = OffsetX;
	Info.nOffSetY = OffsetY;
	Info.u_nTextureUWidth = u_nTextureUWidth;
	Info.u_nTextureUHeight = u_nTextureUHeight;
	Info.u_strTexture = Texture;
	return Info;
}

function AddDrawItemItemInfo(out array<DrawItemInfo> drawListArr, ItemInfo iInfo, optional int posX, optional int posY, optional int u_nTextureWidth, optional int u_nTextureHeight, optional int u_nTextureUWidth, optional int u_nTextureVHeight)
{
	if(((u_nTextureWidth + u_nTextureHeight) == 0))
	{
		u_nTextureWidth = 32;
		u_nTextureHeight = 32;
	}
	if(((u_nTextureUWidth + u_nTextureVHeight) == 0))
	{
		u_nTextureUWidth = 32;
		u_nTextureVHeight = 32;
	}
	drawListArr[drawListArr.Length] = addDrawItemTextureCustom(iInfo.IconName, true, false, posX, posY, u_nTextureWidth, u_nTextureHeight, u_nTextureUWidth, u_nTextureVHeight);
	if((iInfo.IconPanel != ""))
	{
		drawListArr[drawListArr.Length] = addDrawItemTextureCustom(iInfo.IconPanel, true, false, -u_nTextureWidth, 0, u_nTextureHeight, u_nTextureHeight, u_nTextureUWidth, u_nTextureVHeight);
	}
	return;
}

function addDrawItemGameItem(out array<DrawItemInfo> drawListArr, ItemInfo Info, optional bool userCount, optional Color tColor, optional int posX, optional int posY, optional int u_nTextureWidth, optional int u_nTextureHeight, optional int u_nTextureUWidth, optional int u_nTextureVHeight)
{
	local Color applyColor;

	if(((((int(tColor.R) == 0) && (int(tColor.G) == 0)) && (int(tColor.B) == 0)) && (int(tColor.A) == 0)))
	{
		applyColor = getInstanceL2Util().White;
	}
	else
	{
		applyColor = tColor;
	}
	AddDrawItemItemInfo(drawListArr, Info, posX, posY, u_nTextureWidth, u_nTextureHeight, u_nTextureUWidth, u_nTextureVHeight);
	drawListArr[drawListArr.Length] = addDrawItemText(GetItemNameAll(Info), applyColor, "", false, true, 4, (u_nTextureHeight / 5));
	if(userCount)
	{
		drawListArr[drawListArr.Length] = addDrawItemText((" x" $ MakeCostStringINT64(Info.ItemNum)), applyColor, "", false, true, 0, (u_nTextureHeight / 5));
	}
	drawListArr[drawListArr.Length] = addDrawItemBlank(2);
	return;
}

function AddDrawItemGameItemColorFul(out array<DrawItemInfo> drawListArr, ItemInfo Info, optional bool userCount, optional Color tColor, optional int posX, optional int posY, optional int u_nTextureWidth, optional int u_nTextureHeight, optional int u_nTextureUWidth, optional int u_nTextureVHeight)
{
	local Color applyColor;

	if(((((int(tColor.R) == 0) && (int(tColor.G) == 0)) && (int(tColor.B) == 0)) && (int(tColor.A) == 0)))
	{
		applyColor = getInstanceL2Util().White;
	}
	else
	{
		applyColor = tColor;
	}
	if(((u_nTextureWidth + u_nTextureHeight) == 0))
	{
		u_nTextureWidth = 32;
		u_nTextureHeight = 32;
	}
	if(((u_nTextureUWidth + u_nTextureVHeight) == 0))
	{
		u_nTextureUWidth = 32;
		u_nTextureVHeight = 32;
	}
	drawListArr[drawListArr.Length] = addDrawItemTextureCustom(Info.IconName, true, false, posX, posY, u_nTextureWidth, u_nTextureHeight, u_nTextureUWidth, u_nTextureVHeight);
	if((Info.IconPanel != ""))
	{
		drawListArr[drawListArr.Length] = addDrawItemTextureCustom(Info.IconPanel, true, false, -u_nTextureWidth, 0, u_nTextureHeight, u_nTextureHeight, u_nTextureUWidth, u_nTextureVHeight);
	}
	addDrawItemGameItemNameAll(drawListArr, Info, 4, (u_nTextureHeight / 5));
	if(userCount)
	{
		drawListArr[drawListArr.Length] = addDrawItemText((" x" $ MakeCostStringINT64(Info.ItemNum)), applyColor, "", false, true, 0, (u_nTextureHeight / 5));
	}
	drawListArr[drawListArr.Length] = addDrawItemBlank(2);
	return;
}

function addDrawItemGameItemNameAll(out array<DrawItemInfo> drawListArr, ItemInfo item, optional int posX, optional int posY, optional string FontName)
{
	local string ItemName;
	local Color applyColor;
	local int nAddTooltipItemName, posXAdd, posYadd;

	posXAdd = posX;
	posYadd = posY;
	if((item.Enchanted > 0))
	{
		drawListArr[drawListArr.Length] = addDrawItemText(("+" $ string(item.Enchanted)), GetColor(170, 110, 230, 255), FontName, false, false, posXAdd, posYadd);
		posXAdd = 0;
		posYadd = 0;
	}
	if(item.IsBlessedItem)
	{
		ItemName = (GetSystemString(13403) $ " ");
		drawListArr[drawListArr.Length] = addDrawItemText(ItemName, getInstanceL2Util().Blue, FontName, false, false, posXAdd, posYadd);
		posXAdd = 0;
		posYadd = 0;
	}
	if(getInstanceUIData().GetIsLiveServer())
	{
		ItemName = Class'NWindow.UIDATA_ITEM'.static.GetRefineryItemName(item.Name, item.RefineryOp1, item.RefineryOp2);
	}
	else
	{
		ItemName = item.Name;
	}
	nAddTooltipItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemNameClass(item.Id);
	switch(nAddTooltipItemName)
	{
		case 0:
			applyColor = GetColor(137, 137, 137, 255);
			break;
		case 1:
			applyColor = GetColor(230, 230, 230, 255);
			break;
		case 2:
			applyColor = GetColor(255, 251, 4, 255);
			break;
		case 3:
			applyColor = GetColor(240, 68, 68, 255);
			break;
		case 4:
			applyColor = GetColor(33, 164, 255, 255);
			break;
		case 5:
			applyColor = GetColor(255, 0, 255, 255);
			break;
		default:
			break;
	}
	drawListArr[drawListArr.Length] = addDrawItemText(ItemName, applyColor, FontName, false, false, posXAdd, posYadd);
	if((Len(item.AdditionalName) > 0))
	{
		drawListArr[drawListArr.Length] = addDrawItemText((" " $ item.AdditionalName), GetColor(255, 217, 105, 255), FontName, false, false, posXAdd, posYadd);
	}
	return;
}

function DrawItemInfo addDrawItemBlank(int Height)
{
	local DrawItemInfo Info;

	Info.eType = DIT_BLANK;
	Info.b_nHeight = Height;
	return Info;
}

function addToolTipDrawList(out CustomTooltip cTooltip, DrawItemInfo DrawItemInfoElement)
{
	cTooltip.DrawList[cTooltip.DrawList.Length] = DrawItemInfoElement;
	return;
}

function DrawItemInfo AddCrossLineForCustomToolTip(optional int minimum_width)
{
	local DrawItemInfo Info;

	Info.eType = DIT_SPLITLINE;
	Info.u_nTextureWidth = minimum_width;
	Info.u_nTextureHeight = 1;
	Info.u_strTexture = "L2ui_ch3.tooltip_line";
	return Info;
}

function setCustomToolTipMinimumWidth(out CustomTooltip m_Tooltip)
{
	m_Tooltip.MinimumWidth = customToolTipGetMaxWidth(m_Tooltip);
	customToolTipLineWidthRefresh(m_Tooltip);
	return;
}

function customToolTipLineWidthRefresh(out CustomTooltip m_Tooltip)
{
	local int i;

	i = 0;
	while((i < m_Tooltip.DrawList.Length))
	{
		if((int(m_Tooltip.DrawList[i].eType) == 3))
		{
			m_Tooltip.DrawList[i].u_nTextureWidth = m_Tooltip.MinimumWidth;
		}
		i++;
	}
	return;
}

function int customToolTipGetMaxWidth(CustomTooltip m_Tooltip)
{
	local int i, Width, Height, MaxWidth, tmpWidth;

	MaxWidth = m_Tooltip.MinimumWidth;
	i = 0;
	while((i < m_Tooltip.DrawList.Length))
	{
		if(((int(m_Tooltip.DrawList[i].eType) == 1) || (int(m_Tooltip.DrawList[i].eType) == 4)))
		{
			if(m_Tooltip.DrawList[i].t_bDrawOneLine)
			{
				GetTextSizeDefault(m_Tooltip.DrawList[i].t_strText, Width, Height);
				if(!m_Tooltip.DrawList[i].bLineBreak)
				{
					Width = (Width + tmpWidth);
				}
			}
		}
		else if(((int(m_Tooltip.DrawList[i].eType) == 2) || (int(m_Tooltip.DrawList[i].eType) == 3)))
		{
			if(m_Tooltip.DrawList[i].t_bDrawOneLine)
			{
				Width = m_Tooltip.DrawList[i].u_nTextureWidth;
				if(!m_Tooltip.DrawList[i].bLineBreak)
				{
					Width = (tmpWidth + Width);
				}
			}
		}
		Width = (Width + m_Tooltip.DrawList[i].nOffSetX);
		if((Width > MaxWidth))
		{
			MaxWidth = Width;
		}
		tmpWidth = Width;
		i++;
	}
	return MaxWidth;
}

static function bool IsValidItemID(ItemID Id)
{
	if(((Id.ClassID < 1) && (Id.ServerID < 1)))
	{
		return false;
	}
	return true;
}

static function ItemID GetItemID(int Id)
{
	local ItemID cID;

	cID.ClassID = Id;
	return cID;
}

static function ItemInfo GetItemInfoByClassID(int Id)
{
	local ItemID cID;
	local ItemInfo Info;

	cID.ClassID = Id;
	Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cID, Info);
	return Info;
}

function int getItemCountWithEnchanted(int ClassID, int Enchanted)
{
	local array<ItemInfo> Items;
	local int i, ItemCount;

	GetInstanceL2UIInventory().FindItem(GetItemID(ClassID), Items);
	i = 0;
	while((i < Items.Length))
	{
		if((Enchanted == Items[i].Enchanted))
		{
			ItemCount++;
		}
		i++;
	}
	return ItemCount;
}

function bool ParseItemID(string param, out ItemID Id)
{
	local bool bRet1, bRet2;

	bRet1 = ParseInt(param, "ClassID", Id.ClassID);
	bRet2 = ParseInt(param, "ServerID", Id.ServerID);
	return (bRet1 || bRet2);
}

function bool ParseItemIDWithIndex(string param, out ItemID Id, int idx)
{
	local bool bRet1, bRet2;

	bRet1 = ParseInt(param, ("ClassID_" $ string(idx)), Id.ClassID);
	bRet2 = ParseInt(param, ("ServerID_" $ string(idx)), Id.ServerID);
	return (bRet1 || bRet2);
}

function ParamAddItemID(out string param, ItemID Id)
{
	if((Id.ClassID > 0))
	{
		ParamAdd(param, "ClassID", string(Id.ClassID));
	}
	if((Id.ServerID > 0))
	{
		ParamAdd(param, "ServerID", string(Id.ServerID));
	}
	return;
}

function ParamAddItemIDWithIndex(out string param, ItemID Id, int idx)
{
	if((Id.ClassID > 0))
	{
		ParamAdd(param, ("ClassID_" $ string(idx)), string(Id.ClassID));
	}
	if((Id.ServerID > 0))
	{
		ParamAdd(param, ("ServerID_" $ string(idx)), string(Id.ServerID));
	}
	return;
}

static function ClearItemID(out ItemID Id)
{
	Id.ClassID = -1;
	Id.ServerID = -1;
	return;
}

static function bool IsSameItemID(ItemID src, ItemID des)
{
	if(((src.ClassID == des.ClassID) && (src.ServerID == des.ServerID)))
	{
		return true;
	}
	return false;
}

static function bool IsSameClassID(ItemID src, ItemID des)
{
	if((src.ClassID == des.ClassID))
	{
		return true;
	}
	return false;
}

static function bool IsSameServerID(ItemID src, ItemID des)
{
	if((src.ServerID == des.ServerID))
	{
		return true;
	}
	return false;
}

static function bool IsAdena(ItemID Id)
{
	if((Id.ClassID == 57))
	{
		return true;
	}
	return false;
}

function string GetPrimeItemSymbolName()
{
	return "BranchSys.ui.primeitem_symbol";
}

function string ChinaHideName(string UserName)
{
	if((int(GetLanguage()) != 4))
	{
		return UserName;
	}
	if((InStr(UserName, "*") == -1))
	{
		return UserName;
	}
	return GetSystemString(13198);
}

function string ChinaOriginName(string UserName)
{
	local string OriginName;

	if((int(GetLanguage()) != 4))
	{
		return UserName;
	}
	if((InStr(UserName, "*") == -1))
	{
		return UserName;
	}
	OriginName = Left(UserName, InStr(UserName, "*"));
	return OriginName;
}

static function string getCurrentWindowName(string targetString)
{
	local array<string> ArrayStr;

	Split(targetString, ".", ArrayStr);
	return ArrayStr[1];
}

static function L2Util getInstanceL2Util()
{
	local L2Util Script;

	Script = L2Util(GetScript("L2Util"));
	return Script;
}

static function InventoryViewer getInstanceInventoryViewer()
{
	local InventoryViewer Script;

	Script = InventoryViewer(GetScript("InventoryViewer"));
	return Script;
}

static function UIData getInstanceUIData()
{
	local UIData Script;

	Script = UIData(GetScript("UIData"));
	return Script;
}

static function NoticeWnd getInstanceNoticeWnd()
{
	local NoticeWnd Script;

	Script = NoticeWnd(GetScript("NoticeWnd"));
	return Script;
}

static function ContextMenu getInstanceContextMenu()
{
	local ContextMenu Script;

	Script = ContextMenu(GetScript("ContextMenu"));
	return Script;
}

static function L2UIColor GTColor()
{
	local L2UIColor Script;

	Script = L2UIColor(GetScript("L2UIColor"));
	return Script;
}

function int getRollIconNum(UIEventManager.EClassRoleType rollType)
{
	switch(rollType)
	{
		case ECRT_KNIGHT:
			return 3;
		case ECRT_WARRIOR:
			return 8;
		case ECRT_ROGUE:
			return 1;
		case ECRT_ARCHOR:
			return 2;
		case ECRT_WIZARD:
			return 5;
		case ECRT_SUMMONER:
			return 7;
		case ECRT_ENCHANTER:
			return 4;
		case ECRT_SUPPORT:
			return 6;
		case ECRT_SHAMAN:
			return 10;
		case ECRT_BARD:
			return 11;
		case ECRT_NOVICE:
			return 1;
		case ECRT_DEATHKNIGHT:
			return 12;
		case ECRT_HUNTER:
			return 13;
		default:
			return 1;
	}
}

function string GetClassRoleIconName(int ClassID)
{
	local int degree;
	local UIEventManager.EClassRoleType rollType;

	rollType = GetClassRoleType(ClassID);
	degree = GetClassTransferDegree(ClassID);
	if((int(rollType) == 9))
	{
		degree = 1;
	}
	else if(((int(rollType) == 12) && (degree == 0)))
	{
		degree = 1;
	}
	else if((degree > 4))
	{
		degree = 4;
	}
	return ((("L2UI_CH3.PartyWnd.party_styleicon" $ string(degree)) $ "_") $ string(getRollIconNum(rollType)));
}

function string GetClassRoleIconNameBig(int ClassID)
{
	local int degree;
	local UIEventManager.EClassRoleType rollType;

	rollType = GetClassRoleType(ClassID);
	degree = GetClassTransferDegree(ClassID);
	if((int(rollType) == 9))
	{
		degree = 1;
	}
	else if(((int(rollType) == 12) && (degree == 0)))
	{
		degree = 1;
	}
	else if((degree > 4))
	{
		degree = 4;
	}
	return (((("L2UI_CH3.PartyWnd.party_styleicon" $ string(degree)) $ "_") $ string(getRollIconNum(rollType))) $ "_Big");
}

function string GetClassArenaRoleIconName(int ClassID)
{
	local UIEventManager.EClassRoleType rollType;

	rollType = GetClassRoleType(ClassID);
	if((int(rollType) == 9))
	{
		return "L2UI.TheArena.party_styleicon1_1";
	}
	return ("L2UI.TheArena.party_styleicon0_" $ string(getRollIconNum(GetClassRoleType(ClassID))));
}

function Color GetNumericColor(string strCommaAdena)
{
	local Color ResultColor;
	local int L, comma_num, i;

	ResultColor.R = 220;
	ResultColor.G = 220;
	ResultColor.B = 220;
	ResultColor.A = 255;
	L = Len(strCommaAdena);
	i = 0;
	while((i < L))
	{
		if((Mid(strCommaAdena, i, 1) == ","))
		{
			++comma_num;
		}
		++i;
	}
	(L -= comma_num);
	if((L < 5))
	{
		return ResultColor;
	}
	L = (L - 5);
	switch(L)
	{
		case 0:
			ResultColor.R = 105;
			ResultColor.G = 255;
			ResultColor.B = 255;
			break;
		case 1:
			ResultColor.R = 255;
			ResultColor.G = 128;
			ResultColor.B = 255;
			break;
		case 2:
			ResultColor.R = 255;
			ResultColor.G = 255;
			ResultColor.B = 0;
			break;
		case 3:
			ResultColor.R = 0;
			ResultColor.G = 255;
			ResultColor.B = 0;
			break;
		case 4:
			ResultColor.R = 255;
			ResultColor.G = 140;
			ResultColor.B = 0;
			break;
		case 5:
			ResultColor.R = 0;
			ResultColor.G = 110;
			ResultColor.B = 255;
			break;
		case 6:
			ResultColor.R = 255;
			ResultColor.G = 0;
			ResultColor.B = 0;
			break;
		case 7:
			ResultColor.R = 150;
			ResultColor.G = 110;
			ResultColor.B = 255;
			break;
		default:
			break;
	}
	return ResultColor;
}

function Color GetExpNumericColor(string strCommaAdena)
{
	local Color ResultColor;
	local int L, comma_num, i;

	ResultColor.R = 220;
	ResultColor.G = 220;
	ResultColor.B = 220;
	ResultColor.A = 255;
	L = Len(strCommaAdena);
	i = 0;
	while((i < L))
	{
		if((Mid(strCommaAdena, i, 1) == ","))
		{
			++comma_num;
		}
		++i;
	}
	(L -= comma_num);
	if((L < 5))
	{
		return ResultColor;
	}
	L = (L - 5);
	switch(L)
	{
		case 4:
			ResultColor.R = 105;
			ResultColor.G = 255;
			ResultColor.B = 255;
			break;
		case 5:
			ResultColor.R = 255;
			ResultColor.G = 128;
			ResultColor.B = 255;
			break;
		case 6:
			ResultColor.R = 255;
			ResultColor.G = 255;
			ResultColor.B = 0;
			break;
		case 7:
			ResultColor.R = 0;
			ResultColor.G = 255;
			ResultColor.B = 0;
			break;
		case 8:
			ResultColor.R = 255;
			ResultColor.G = 140;
			ResultColor.B = 0;
			break;
		case 9:
			ResultColor.R = 0;
			ResultColor.G = 110;
			ResultColor.B = 255;
			break;
		case 10:
			ResultColor.R = 255;
			ResultColor.G = 0;
			ResultColor.B = 0;
			break;
		default:
			break;
	}
	return ResultColor;
}

function string htmlSetHtmlStart(string targetHtml)
{
	return (("<html><body>" $ targetHtml) $ "</body></html>");
}

function string htmlAddItemButton(int nItemID, int nWidth, int nHeight)
{
	local string itemTexture, addItemHtml;
	local ItemID cItemID;

	cItemID.ClassID = nItemID;
	itemTexture = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(cItemID);
	addItemHtml = ((((((((((((((("<button width=" $ string(nWidth)) $ " height=") $ string(nHeight)) $ " itemtooltip=\"") $ string(nItemID)) $ "\"") $ " High=\"") $ itemTexture) $ "\"") $ " back=\"") $ itemTexture) $ "\"") $ " fore=\"") $ itemTexture) $ "\"> ");
	return addItemHtml;
}

function string htmlAddButton(string buttonText, string actionParam, optional int nWidth, optional int nHeight, optional int buttonAddWidth, optional int buttonAddHeight, optional string textStyle, optional string FontName, optional string FontColor, optional string backTexture, optional string highTexture, optional string ForeTexture)
{
	local string resultHtml, addHtml;
	local int textSizeWidth, textSizeHeight;

	if((Len(FontName) > 0))
	{
		GetTextSize(buttonText, FontName, textSizeWidth, textSizeHeight);
	}
	else
	{
		GetTextSize(buttonText, "GameDefault", textSizeWidth, textSizeHeight);
	}
	if((nWidth > 0))
	{
		addHtml = (((addHtml $ "width=") $ string(nWidth)) $ " ");
	}
	else
	{
		addHtml = (((addHtml $ "width=") $ string((textSizeWidth + buttonAddWidth))) $ " ");
	}
	if((nHeight > 0))
	{
		addHtml = (((addHtml $ "height=") $ string(nHeight)) $ " ");
	}
	else
	{
		addHtml = (((addHtml $ "height=") $ string((textSizeHeight + buttonAddHeight))) $ " ");
	}
	if((Len(textStyle) > 0))
	{
		addHtml = (((addHtml $ "textstyle=\"") $ textStyle) $ "\" ");
	}
	if((Len(FontName) > 0))
	{
		addHtml = (((addHtml $ "fontName=\"") $ FontName) $ "\" ");
	}
	if((Len(FontColor) > 0))
	{
		addHtml = (((addHtml $ "fontColor=\"") $ FontColor) $ "\" ");
	}
	if((Len(backTexture) > 0))
	{
		addHtml = (((addHtml $ "back=\"") $ backTexture) $ "\" ");
	}
	else
	{
		addHtml = (addHtml $ "back=\"L2UI_CT1.Button_DF_Down\" ");
	}
	if((Len(highTexture) > 0))
	{
		addHtml = (((addHtml $ "high=\"") $ highTexture) $ "\" ");
	}
	else
	{
		addHtml = (addHtml $ "high=\"L2UI_CT1.Button_DF_Over\" ");
	}
	if((Len(ForeTexture) > 0))
	{
		addHtml = (((addHtml $ "fore=\"") $ ForeTexture) $ "\" ");
	}
	else
	{
		addHtml = (addHtml $ "fore=\"L2UI_CT1.Button_DF\" ");
	}
	if((Len(actionParam) > 0))
	{
		addHtml = (((addHtml $ "action=\"") $ actionParam) $ "\" ");
	}
	resultHtml = (((("<button value=\"" $ buttonText) $ "\" ") $ addHtml) $ "> ");
	return resultHtml;
}

function string htmlAddImg(string strTexture, int nWidth, int nHeight)
{
	local string addItemHtml;

	addItemHtml = (((((("<img src=\"" $ strTexture) $ "\" width=") $ string(nWidth)) $ " height=") $ string(nHeight)) $ ">");
	return addItemHtml;
}

function string htmlAddLineImg(optional int LineWidth)
{
	if((LineWidth > 0))
	{
		return (("<img src=\"L2UI.SquareWhite\" width=" $ string(LineWidth)) $ " height=1>");
	}
	return "<img src=\"L2UI.SquareWhite\" width=270 height=1>";
}

function string htmlAddText(string strText, string FontName, optional string FontColor)
{
	local string targetHtml, addItemHtml;

	if((Len(FontColor) > 0))
	{
		addItemHtml = ((" color=\"" $ FontColor) $ "\" ");
	}
	targetHtml = (((((("<font name=\"" $ FontName) $ "\"") $ addItemHtml) $ ">") $ strText) $ "</font>");
	return targetHtml;
}

function string htmlUrlLinkText(string strText, string URL)
{
	local string targetHtml;

	targetHtml = ((((("<a action=\"url " $ URL) $ "\"") $ ">") $ strText) $ "</a>");
	return targetHtml;
}

function string htmlSetTable(out string targetHtml, int Border, int Width, int Height, string BackGroundTexture, int cellPadding, int cellspacing)
{
	if((BackGroundTexture == ""))
	{
		targetHtml = (((((((((((("<table width=" $ string(Width)) $ " height=") $ string(Height)) $ " border=") $ string(Border)) $ " cellpadding=") $ string(cellPadding)) $ " cellspacing=") $ string(cellspacing)) $ "\">") $ targetHtml) $ "</table>");
	}
	else
	{
		targetHtml = (((((((((((((("<table width=" $ string(Width)) $ " height=") $ string(Height)) $ " border=") $ string(Border)) $ " cellpadding=") $ string(cellPadding)) $ " cellspacing=") $ string(cellspacing)) $ " background=\"") $ BackGroundTexture) $ "\">") $ targetHtml) $ "</table>");
	}
	return targetHtml;
}

function string HtmlSetTableTR(out string targetHtml)
{
	targetHtml = (("<tr> " $ targetHtml) $ "</tr>");
	return targetHtml;
}

function string HtmlAddTableTD(string strText, string alignStr, string vAlignStr, int Width, int Height, optional string BackGroundTexture, optional bool bWidthFix)
{
	local string addItemHtml;

	if((Len(alignStr) > 0))
	{
		addItemHtml = ((" align=" $ alignStr) $ " ");
	}
	if((Len(vAlignStr) > 0))
	{
		addItemHtml = (((" valign=" $ vAlignStr) $ " ") $ addItemHtml);
	}
	if(bWidthFix)
	{
		if((Width > 0))
		{
			addItemHtml = (((" fixwidth=" $ string(Width)) $ " ") $ addItemHtml);
		}
	}
	else if((Width > 0))
	{
		addItemHtml = (((" width=" $ string(Width)) $ " ") $ addItemHtml);
	}
	if((Height > 0))
	{
		addItemHtml = (((" height=" $ string(Height)) $ " ") $ addItemHtml);
	}
	if((Len(BackGroundTexture) > 0))
	{
		addItemHtml = (((" background=\"" $ BackGroundTexture) $ "\" ") $ addItemHtml);
	}
	return (((("<td " $ addItemHtml) $ ">") $ strText) $ "</td>");
}

function string getQuestTypeString(int nQuestType)
{
	local string returnStr;

	switch(nQuestType)
	{
		case 0:
			returnStr = GetSystemString(1795);
			break;
		case 1:
			returnStr = GetSystemString(7285);
			break;
		case 2:
			returnStr = GetSystemString(7286);
			break;
		case 3:
			returnStr = GetSystemString(7287);
			break;
		case 4:
			returnStr = GetSystemString(7288);
			break;
		case 5:
			returnStr = GetSystemString(7276);
			break;
		case 6:
			returnStr = GetSystemString(7277);
			break;
		case 8:
			returnStr = GetSystemString(7278);
			break;
		case 7:
			returnStr = GetSystemString(7279);
			break;
		case 9:
			returnStr = GetSystemString(7280);
			break;
		case 10:
			returnStr = GetSystemString(7281);
			break;
		case 11:
			returnStr = GetSystemString(7282);
			break;
		case 12:
			returnStr = GetSystemString(7283);
			break;
		case 13:
			returnStr = GetSystemString(7284);
			break;
		default:
			returnStr = "";
	}
	return returnStr;
}

function string br()
{
	return "<br>";
}

function string brPixel(int nWidth, optional int nHeight, optional int vspace)
{
	return gfxHtmlAddImg("L2UI_CT1.EmptyBtn", nWidth, nHeight, vspace);
}

function string gfxHtmlAddText(string strText, optional string FontColor, optional string FontSize)
{
	local string targetHtml, addItemHtml;

	if((Len(FontColor) > 0))
	{
		addItemHtml = (((addItemHtml $ "color='") $ FontColor) $ "' ");
	}
	if((Len(FontSize) > 0))
	{
		addItemHtml = (((addItemHtml $ "size='") $ FontSize) $ "' ");
	}
	targetHtml = (((("<font " $ addItemHtml) $ ">") $ strText) $ "</font>");
	return targetHtml;
}

function string gfxHtmlAddImg(string strTexture, int nWidth, int nHeight, optional int vspace)
{
	local string addItemHtml;

	addItemHtml = ((((((("<img src='img://" $ strTexture) $ "' width='") $ string(nWidth)) $ "' height='") $ string(nHeight)) $ "'") $ "'");
	if((vspace != 0))
	{
		addItemHtml = (addItemHtml $ " align='baseline'");
		addItemHtml = (((addItemHtml $ " vspace='") $ string(vspace)) $ "'");
	}
	addItemHtml = (addItemHtml $ ">");
	return addItemHtml;
}

function string gfxHtmlAddItemTexture(int nItemClassID, int nWidth, int nHeight, optional int vspace)
{
	local string addItemHtml, strTexture;

	strTexture = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(nItemClassID));
	addItemHtml = gfxHtmlAddImg(strTexture, nWidth, nHeight, vspace);
	return addItemHtml;
}

function string makeShortString(string targetString, int maxChar, string dotString)
{
	local string rStr;

	if((Len(targetString) > maxChar))
	{
		rStr = (Mid(targetString, 0, maxChar) $ dotString);
	}
	else
	{
		rStr = targetString;
	}
	return rStr;
}

function textBoxShortStringWithTooltip(TextBoxHandle textBox, optional bool bUseTooltip, optional int addWidth)
{
	local int textWidth, textHeight, wTextWidth, hTextHeight;
	local string Context;

	Context = textBox.GetText();
	textBox.GetWindowSize(wTextWidth, hTextHeight);
	GetTextSize(Context, "GameDefault", textWidth, textHeight);
	if((textWidth > wTextWidth))
	{
		if(bUseTooltip)
		{
			textBox.SetTooltipType("text");
			textBox.SetTooltipText(Context);
		}
		Context = makeShortStringByPixel(Context, ((wTextWidth - 8) + addWidth), "..");
	}
	textBox.SetText(Context);
	return;
}

function textBoxShortStringLazy(TextBoxHandle targetTextField, string targetString, optional string dotString, optional string FontName)
{
	local string repDotString;

	if((dotString == ""))
	{
		repDotString = "..";
	}
	targetTextField.SetText(makeShortStringByPixel(targetString, (targetTextField.GetRect().nWidth - 4), repDotString, FontName));
	return;
}

function string makeShortStringByPixel(string targetString, int maxPixel, string dotString, optional string FontName)
{
	local string fixedText, tempStr, prevTempStr;
	local int textWidth, textHeight, prevTextWidth, dotWidth, dotHeight, i;

	if((FontName == ""))
	{
		FontName = "GameDefault";
	}
	GetTextSize(dotString, FontName, dotWidth, dotHeight);
	GetTextSize(targetString, FontName, textWidth, textHeight);
	if((textWidth <= maxPixel))
	{
		fixedText = targetString;
	}
	else
	{
		fixedText = targetString;
		i = 0;
		while((i < Len(targetString)))
		{
			tempStr = Mid(targetString, 0, i);
			GetTextSize(tempStr, FontName, textWidth, textHeight);
			prevTextWidth = textWidth;
			prevTempStr = tempStr;
			if((maxPixel < (textWidth + dotWidth)))
			{
				if((maxPixel > (prevTextWidth + dotWidth)))
				{
					fixedText = (prevTempStr $ dotString);
				}
				else
				{
					fixedText = (tempStr $ dotString);
				}
				break;
			}
			i++;
		}
	}
	return fixedText;
}

function bool isVectorZero(Vector Loc)
{
	if((((int(Loc.X) == 0) && (int(Loc.Y) == 0)) && (int(Loc.Z) == 0)))
	{
		return true;
	}
	else
	{
		return false;
	}
}

function setTargetByServerID(int ServerID)
{
	local UserInfo UserInfo;

	if((ServerID != -1))
	{
		if(GetPlayerInfo(UserInfo))
		{
			RequestAction(ServerID, UserInfo.Loc);
		}
	}
	return;
}

function bool numToBool(int bNum)
{
	if((bNum > 0))
	{
		return true;
	}
	else
	{
		return false;
	}
}

function int boolToNum(bool Num)
{
	if(Num)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

function Color GetColor(int R, int G, int B, int A)
{
	local Color tColor;

	tColor.R = byte(R);
	tColor.G = byte(G);
	tColor.B = byte(B);
	tColor.A = byte(A);
	return tColor;
}

function string GetItemNameWithAdditional(ItemInfo Info)
{
	local string FullName, addStr;

	if((Len(FullName) > 0))
	{
		FullName = ((FullName $ " ") $ Info.Name);
	}
	else
	{
		FullName = Info.Name;
	}
	if((Len(Info.AdditionalName) > 0))
	{
		addStr = ((addStr $ " ") $ Info.AdditionalName);
	}
	FullName = (FullName $ addStr);
	return FullName;
}

function string GetItemNameAllByClassID(int ClassID)
{
	local ItemInfo iInfo;

	if(!Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(ClassID), iInfo))
	{
		return "";
	}
	return GetItemNameAll(iInfo);
}

function string GetItemNameAllBySeverID(int ServerID)
{
	local ItemInfo Info;
	local string itemNameStr;

	Class'NWindow.UIDATA_INVENTORY'.static.FindItem(ServerID, Info);
	itemNameStr = GetItemNameAll(Info);
	return itemNameStr;
}

function string GetItemNameAll(ItemInfo item, optional bool bNoUseAdditionalName)
{
	local string FullName, refineryStr;

	if((item.Enchanted > 0))
	{
		FullName = (("+" $ string(item.Enchanted)) $ " ");
	}
	if(item.IsBlessedItem)
	{
		FullName = ((FullName $ GetSystemString(13403)) $ " ");
	}
	if(getInstanceUIData().GetIsLiveServer())
	{
		refineryStr = Class'NWindow.UIDATA_ITEM'.static.GetRefineryItemName(item.Name, item.RefineryOp1, item.RefineryOp2);
	}
	else
	{
		refineryStr = item.Name;
	}
	if((Len(FullName) > 0))
	{
		FullName = (FullName $ refineryStr);
	}
	else
	{
		FullName = refineryStr;
	}
	if(!bNoUseAdditionalName)
	{
		if((Len(item.AdditionalName) > 0))
		{
			FullName = ((FullName $ " ") $ item.AdditionalName);
		}
	}
	return FullName;
}

function int _ItemNameLen(ItemInfo iInfo)
{
	local string nameString;
	local int enchantLen, bressLen, itemNameLen, additionalNameLen;

	if((iInfo.Enchanted > 0))
	{
		nameString = ("+" $ string(iInfo.Enchanted));
		enchantLen = (Len(nameString) + 1);
	}
	if(iInfo.IsBlessedItem)
	{
		nameString = GetSystemString(13403);
		bressLen = (Len(nameString) + 1);
	}
	if(IsClassicServer())
	{
		nameString = iInfo.Name;
		itemNameLen = Len(iInfo.Name);
	}
	else
	{
		nameString = Class'NWindow.UIDATA_ITEM'.static.GetRefineryItemName(iInfo.Name, iInfo.RefineryOp1, iInfo.RefineryOp2);
		itemNameLen = Len(nameString);
	}
	additionalNameLen = Len(iInfo.AdditionalName);
	if((additionalNameLen > 0))
	{
		itemNameLen++;
	}
	return ((((enchantLen << 24) + (bressLen << 16)) + (itemNameLen << 8)) + additionalNameLen);
}

function string GetEnsoulOptionNameAll(ItemInfo weaponInfo)
{
	local UIConstants.EnsoulOptionUIInfo eOptionInfo;
	local int i, N, Cnt, OptionID;
	local string allName;

	i = 1;
	while((i < 3))
	{
		Cnt = weaponInfo.EnsoulOption[(i - 1)].OptionArray.Length;
		N = 1;
		while((N < (1 + Cnt)))
		{
			OptionID = weaponInfo.EnsoulOption[(i - 1)].OptionArray[(N - 1)];
			if((OptionID <= 0))
			{
				N++;
				continue;
			}
			GetEnsoulOptionUIInfo(OptionID, eOptionInfo);
			if((eOptionInfo.Name != ""))
			{
				if((allName == ""))
				{
					allName = eOptionInfo.Name;
					N++;
					continue;
				}
				allName = ((allName $ "/") $ eOptionInfo.Name);
			}
			N++;
		}
		i++;
	}
	return allName;
}

function bool hasEnsoulOption(ItemInfo weaponInfo)
{
	local UIConstants.EnsoulOptionUIInfo eOptionInfo;
	local int i, N, Cnt, OptionID;

	i = 1;
	while((i < 3))
	{
		Cnt = weaponInfo.EnsoulOption[(i - 1)].OptionArray.Length;
		N = 1;
		while((N < (1 + Cnt)))
		{
			OptionID = weaponInfo.EnsoulOption[(i - 1)].OptionArray[(N - 1)];
			GetEnsoulOptionUIInfo(OptionID, eOptionInfo);
			if((eOptionInfo.Name != ""))
			{
				return true;
			}
			N++;
		}
		i++;
	}
	return false;
}

function addParamEnsoulOptionInfo(ItemInfo Info, out string param)
{
	local int i, N, Cnt;

	i = 1;
	while((i < 3))
	{
		Cnt = Info.EnsoulOption[(i - 1)].OptionArray.Length;
		ParamAdd(param, ("EnsoulOptionNum_" $ string(i)), string(Cnt));
		N = 1;
		while((N < (1 + Cnt)))
		{
			ParamAdd(param, ((("EnsoulOptionID_" $ string(i)) $ "_") $ string(N)), string(Info.EnsoulOption[(i - 1)].OptionArray[(N - 1)]));
			N++;
		}
		i++;
	}
	return;
}

function addEnsoulInfoToItemInfoByParamString(string param, out ItemInfo Info)
{
	local int i, N, Cnt, tmpInt;

	i = 1;
	while((i < 3))
	{
		ParseInt(param, ("EnsoulOptionNum_" $ string(i)), Cnt);
		Info.EnsoulOption[(i - 1)].OptionArray.Length = Cnt;
		N = 1;
		while((N < (1 + Cnt)))
		{
			ParseInt(param, ((("EnsoulOptionID_" $ string(i)) $ "_") $ string(N)), tmpInt);
			Info.EnsoulOption[(i - 1)].OptionArray[(N - 1)] = tmpInt;
			N++;
		}
		i++;
	}
	return;
}

function string maxCountLimitString(INT64 Count, INT64 maxCount, string returnStr)
{
	local string RValue;

	if((Count > maxCount))
	{
		RValue = returnStr;
	}
	else
	{
		RValue = string(Count);
	}
	return RValue;
}

function string getSecToDateStr(int Sec, bool onlyDayFlag)
{
	local string returnStr;
	local int RemainSec, m_timeDay, m_timeHour, m_timeMin;

	m_timeDay = (Sec / 86400);
	RemainSec = int((float(Sec) % 86400.0000000));
	m_timeHour = ((RemainSec / 60) / 60);
	m_timeMin = int((float((RemainSec / 60)) % 60.0000000));
	returnStr = "";
	if((m_timeDay > 0))
	{
		returnStr = (string(m_timeDay) $ GetSystemString(1109));
	}
	if((onlyDayFlag == false))
	{
		if((returnStr != ""))
		{
			returnStr = (returnStr $ "/");
		}
		if((m_timeHour > 0))
		{
			if((m_timeHour < 10))
			{
				returnStr = ((returnStr $ "0") $ string(m_timeHour));
			}
			else
			{
				returnStr = (returnStr $ string(m_timeHour));
			}
		}
		else
		{
			returnStr = (returnStr $ "00");
		}
		if((m_timeMin > 0))
		{
			if((m_timeMin < 10))
			{
				returnStr = ((returnStr $ ":0") $ string(m_timeMin));
			}
			else
			{
				returnStr = ((returnStr $ ":") $ string(m_timeMin));
			}
		}
		else
		{
			returnStr = (returnStr $ ":00");
		}
	}
	return returnStr;
}

function string GetStringDayAndTime(int tmpTime, optional bool bShortDisplay)
{
	local int tmpDay, tmpHou, tmpMin;
	local string timeStr;
	local int minToHou, minToDay;

	minToHou = 60;
	minToDay = (minToHou * 24);
	tmpMin = (tmpTime / 60);
	if((tmpMin > minToDay))
	{
		tmpHou = (tmpMin / 60);
		tmpDay = (tmpHou / 24);
		tmpHou = (tmpHou - (tmpDay * 24));
		if((tmpHou != 0))
		{
			timeStr = MakeFullSystemMsg(GetSystemMessage(3503), string(tmpDay), string(tmpHou));
		}
		else
		{
			timeStr = MakeFullSystemMsg(GetSystemMessage(3418), string(tmpDay));
		}
	}
	else if((tmpMin > 60))
	{
		tmpHou = (tmpMin / 60);
		tmpMin = (tmpMin - (tmpHou * 60));
		if((tmpMin != 0))
		{
			timeStr = MakeFullSystemMsg(GetSystemMessage(3304), string(tmpHou), string(tmpMin));
		}
		else
		{
			timeStr = MakeFullSystemMsg(GetSystemMessage(3406), string(tmpHou));
		}
	}
	else if((tmpTime > 60))
	{
		timeStr = MakeFullSystemMsg(GetSystemMessage(3390), string(tmpMin));
	}
	else if((bShortDisplay == false))
	{
		timeStr = MakeFullSystemMsg(GetSystemMessage(4360), string(1));
	}
	else
	{
		timeStr = MakeFullSystemMsg(GetSystemMessage(3390), string(1));
	}
	return timeStr;
}

function bool isAreaState()
{
	local string stateStr;
	local bool bReturn;

	stateStr = GetGameStateName();
	if(((stateStr == "ARENAGAMINGSTATE") || (stateStr == "ARENABATTLESTATE")))
	{
		bReturn = true;
	}
	else
	{
		bReturn = false;
	}
	return bReturn;
}

function string getHuntingZoneTypeString(int nHuntingZoneType)
{
	local string tmpStr;

	if((nHuntingZoneType == 0))
	{
		tmpStr = GetSystemString(1312);
	}
	else if((nHuntingZoneType == 1))
	{
		tmpStr = GetSystemString(3517);
	}
	else if((nHuntingZoneType == 2))
	{
		tmpStr = GetSystemString(3518);
	}
	else if((nHuntingZoneType == 3))
	{
		tmpStr = GetSystemString(3542);
	}
	else if((nHuntingZoneType == 4))
	{
		tmpStr = GetSystemString(3543);
	}
	else if((nHuntingZoneType == 5))
	{
		tmpStr = GetSystemString(1317);
	}
	else if((nHuntingZoneType == 6))
	{
		tmpStr = GetSystemString(1270);
	}
	else if((nHuntingZoneType == 7))
	{
		tmpStr = GetSystemString(7299);
	}
	else if((nHuntingZoneType == 8))
	{
		tmpStr = GetSystemString(3546);
	}
	else if((nHuntingZoneType == 9))
	{
		tmpStr = GetSystemString(3547);
	}
	else if((nHuntingZoneType == 10))
	{
		tmpStr = GetSystemString(3548);
	}
	return tmpStr;
}

function string getRaidZoneName(int search_zoneid)
{
	local string HuntingZoneName;
	local int i;

	i = 0;
	while((i < 500))
	{
		if(Class'NWindow.UIDATA_HUNTINGZONE'.static.IsValidData(i))
		{
			if((Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneType(i) == 0))
			{
				if((Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZone(i) == search_zoneid))
				{
					HuntingZoneName = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(i);
				}
			}
		}
		i++;
	}
	return HuntingZoneName;
}

function bool IsValidDataForHuntingZoneUIData(HuntingZoneUIData Info)
{
	if(((((((((Info.strName == "") && (Info.nType == 0)) && (Info.nMinLevel == 0)) && (Info.nMaxLevel == 0)) && (Info.nMinLevel == 0)) && (Info.nSearchZoneID == 0)) && (Info.nRegionID == 0)) && (Info.nNpcID == 0)))
	{
		return false;
	}
	return true;
}

function bool tryLevelCheck(int UserLevel, int MinLevel, int MaxLevel)
{
	if(((UserLevel >= MinLevel) && (UserLevel <= MaxLevel)))
	{
		return true;
	}
	return false;
}

function bool isVectorZeroXYZ(float X, float Y, float Z)
{
	if((((X == 0.0000000) && (Y == 0.0000000)) && (Z == 0.0000000)))
	{
		return true;
	}
	return false;
}

function int getHuntingZoneIndexByName(string HuntingZoneName)
{
	local int i, R;

	R = -1;
	i = 0;
	while((i < 500))
	{
		if(Class'NWindow.UIDATA_HUNTINGZONE'.static.IsValidData(i))
		{
			if((Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(i) == HuntingZoneName))
			{
				R = i;
				break;
			}
		}
		i++;
	}
	return R;
}

function UIConstants.RaidUIData getRaidDataByIndex(int Index)
{
	local UIConstants.RaidUIData pRaidUIData;

	if(Class'NWindow.UIDATA_RAID'.static.IsValidData(Index))
	{
		pRaidUIData.Id = Index;
		pRaidUIData.nRaidMonsterID = Class'NWindow.UIDATA_RAID'.static.GetRaidMonsterID(Index);
		pRaidUIData.nRaidMonsterLevel = Class'NWindow.UIDATA_RAID'.static.GetRaidMonsterLevel(Index);
		pRaidUIData.nRaidMonsterZone = Class'NWindow.UIDATA_RAID'.static.GetRaidMonsterZone(Index);
		pRaidUIData.raidDesc = Class'NWindow.UIDATA_RAID'.static.GetRaidDescription(Index);
		pRaidUIData.raidMonsterName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(pRaidUIData.nRaidMonsterID);
		pRaidUIData.nWorldLoc = Class'NWindow.UIDATA_RAID'.static.GetRaidLoc(Index);
		pRaidUIData.RaidMonsterZoneName = getRaidZoneName(pRaidUIData.nRaidMonsterZone);
		Class'NWindow.UIDATA_RAID'.static.GetRaidRecommendLevel(Index, pRaidUIData.nMinLevel, pRaidUIData.nMaxLevel);
	}
	return pRaidUIData;
}

function Vector setVector(int X, int Y, int Z)
{
	local Vector Loc;

	Loc.X = float(X);
	Loc.Y = float(Y);
	Loc.Z = float(Z);
	return Loc;
}

function string getRaceSystemString(int nRace)
{
	local string returnV;

	switch(nRace)
	{
		case 0:
			returnV = GetSystemString(2705);
			break;
		case 1:
			returnV = GetSystemString(171);
			break;
		case 2:
			returnV = GetSystemString(172);
			break;
		case 3:
			returnV = GetSystemString(173);
			break;
		case 4:
			returnV = GetSystemString(174);
			break;
		case 5:
			returnV = GetSystemString(1544);
			break;
		case 6:
			returnV = GetSystemString(3273);
			break;
		case 30:
			returnV = GetSystemString(13536);
			break;
		case 31:
			returnV = GetSystemString(14682);
			break;
		default:
			returnV = "";
	}
	return returnV;
}

function bool IsArtifactRuneItem(ItemInfo Info)
{
	switch(Info.SlotBitType)
	{
		case INT64(4194304):
		case INT64(33554432):
		case INT64(268435456):
		case INT64(1024):
			return true;
			break;
		default:
			break;
	}
	return false;
}

function uDebug(string debugMsg)
{
	if((self.bDoNotUseDebug == false))
	{
		Debug(((getCurrentWindowName(string(self)) $ "|::::|") $ debugMsg));
	}
	return;
}

function lvTextureAdd(out LVTexture LVTexture, string texPath, int X, int Y, int nWeight, int nHeight, optional int U, optional int V)
{
	LVTexture.X = X;
	LVTexture.Y = Y;
	LVTexture.Width = nWeight;
	LVTexture.Height = nHeight;
	if((U > 0))
	{
		LVTexture.U = U;
	}
	else
	{
		LVTexture.U = 0;
	}
	if((V > 0))
	{
		LVTexture.V = V;
	}
	else
	{
		LVTexture.V = 0;
	}
	LVTexture.UL = nWeight;
	LVTexture.VL = nHeight;
	LVTexture.objTex = GetTexture(texPath);
	LVTexture.IsFront = true;
	return;
}

function lvTextureAddItemEnchantedTexture(int nEnchanted, out LVTexture lvTexture1, out LVTexture lvTexture2, out LVTexture lvTexture3, int X, int Y)
{
	local string s1, S2, ss;

	if((nEnchanted > 0))
	{
		lvTextureAdd(lvTexture1, "L2UI_CT1.ENCHANTNUMBER_SMALL_plus", X, Y, 6, 8);
	}
	if((nEnchanted > 9))
	{
		ss = string(nEnchanted);
		s1 = Left(ss, 1);
		S2 = Right(ss, 1);
		lvTextureAdd(lvTexture2, ("L2UI_CT1.ENCHANTNUMBER_SMALL_" $ s1), (X + 6), Y, 6, 8);
		lvTextureAdd(lvTexture3, ("L2UI_CT1.ENCHANTNUMBER_SMALL_" $ S2), (X + 12), Y, 6, 8);
	}
	else if(((nEnchanted > 0) && (nEnchanted < 10)))
	{
		lvTextureAdd(lvTexture2, ("L2UI_CT1.ENCHANTNUMBER_SMALL_" $ string(nEnchanted)), (X + 6), Y, 6, 8);
	}
	return;
}

function lvTextureTreeEnchantedTexture(string treeName, string NodeName, int nEnchanted, int X, int Y)
{
	local L2Util util;
	local string s1, S2, ss;

	util = L2Util(GetScript("L2Util"));
	if((nEnchanted > 0))
	{
		util.TreeInsertTextureNodeItem(treeName, NodeName, "L2UI_CT1.ENCHANTNUMBER_SMALL_plus", 6, 8, X, Y);
	}
	if((nEnchanted > 9))
	{
		ss = string(nEnchanted);
		s1 = Left(ss, 1);
		S2 = Right(ss, 1);
		util.TreeInsertTextureNodeItem(treeName, NodeName, ("L2UI_CT1.ENCHANTNUMBER_SMALL_" $ s1), 6, 8, 0, Y);
		util.TreeInsertTextureNodeItem(treeName, NodeName, ("L2UI_CT1.ENCHANTNUMBER_SMALL_" $ S2), 6, 8, 0, Y);
	}
	else if(((nEnchanted > 0) && (nEnchanted < 10)))
	{
		util.TreeInsertTextureNodeItem(treeName, NodeName, ("L2UI_CT1.ENCHANTNUMBER_SMALL_" $ string(nEnchanted)), 6, 8, 0, Y);
	}
	return;
}

function bool AddDrawItem(out array<RichListCtrlDrawItem> drawitems, out int Index)
{
	if((drawitems.Length > 0))
	{
		drawitems.Length = (drawitems.Length + 1);
	}
	else
	{
		drawitems.Length = 1;
	}
	Index = (drawitems.Length - 1);
	return (Index > -1);
}

function AddRichListCtrlString(out array<RichListCtrlDrawItem> drawitems, string Text, optional Color TextColor, optional bool bStrNewLine, optional int nPosX, optional int nPosY, optional string FontName, optional bool bShowTooltip, optional string TooltipDesc)
{
	local int Index, textW, textH, Len;

	if((AddDrawItem(drawitems, Index) == false))
	{
		return;
	}
	drawitems[Index].eType = LCDIT_TEXT;
	drawitems[Index].nPosX = nPosX;
	drawitems[Index].nPosY = nPosY;
	drawitems[Index].strInfo = getRichListCtrlString(Text, TextColor, bStrNewLine, FontName);
	if(bShowTooltip)
	{
		GetTextSizeDefault(Text, textW, textH);
		Len = drawitems.Length;
		addRichListCtrlTexture(drawitems, "L2UI_CT1.EmptyBtn", textW, textH, -textW, 0);
		drawitems[Len].nReservedTooltipID = 99999;
		drawitems[Len].TooltipDesc = TooltipDesc;
	}
	return;
}

function AddRichListCtrlNewLine(out array<RichListCtrlDrawItem> drawitems, optional int nPosX, optional int nPosY)
{
	local int Index;

	if((AddDrawItem(drawitems, Index) == false))
	{
		return;
	}
	drawitems[Index].eType = LCDIT_TEXT;
	drawitems[Index].nPosX = nPosX;
	drawitems[Index].nPosY = nPosY;
	drawitems[Index].strInfo.bStrNewLine = true;
	return;
}

function addRichListCtrlTexture(out array<RichListCtrlDrawItem> drawitems, string texPath, int nWeight, int nHeight, optional int nPosX, optional int nPosY, optional int U, optional int V)
{
	local int Index;

	if((drawitems.Length > 0))
	{
		drawitems.Length = (drawitems.Length + 1);
	}
	else
	{
		drawitems.Length = 1;
	}
	Index = (drawitems.Length - 1);
	if((Index <= -1))
	{
		return;
	}
	drawitems[Index].eType = LCDIT_TEXTURE;
	drawitems[Index].nPosX = nPosX;
	drawitems[Index].nPosY = nPosY;
	drawitems[Index].texInfo = getRichListCtrlTexture(texPath, nWeight, nHeight, U, V);
	return;
}

function addRichListCtrlItemEnchantedTexture(out array<RichListCtrlDrawItem> drawitems, int nEnchanted, int X, int Y)
{
	local string s1, S2, ss;

	if((nEnchanted > 0))
	{
		addRichListCtrlTexture(drawitems, "L2UI_CT1.ENCHANTNUMBER_SMALL_plus", 6, 8, X, Y);
	}
	if((nEnchanted > 9))
	{
		ss = string(nEnchanted);
		s1 = Left(ss, 1);
		S2 = Right(ss, 1);
		addRichListCtrlTexture(drawitems, ("L2UI_CT1.ENCHANTNUMBER_SMALL_" $ s1), 6, 8);
		addRichListCtrlTexture(drawitems, ("L2UI_CT1.ENCHANTNUMBER_SMALL_" $ S2), 6, 8);
	}
	else if(((nEnchanted > 0) && (nEnchanted < 10)))
	{
		addRichListCtrlTexture(drawitems, ("L2UI_CT1.ENCHANTNUMBER_SMALL_" $ string(nEnchanted)), 6, 8);
	}
	return;
}

function AddRichListCtrlPledgeCrestMark(out array<RichListCtrlDrawItem> drawitems, int nPledgeId, optional int nWidth, optional int nHeight, optional int nPosX, optional int nPosY)
{
	local int Index;

	if((drawitems.Length > 0))
	{
		drawitems.Length = (drawitems.Length + 1);
	}
	else
	{
		drawitems.Length = 1;
	}
	Index = (drawitems.Length - 1);
	if((Index <= -1))
	{
		return;
	}
	drawitems[Index].eType = LCDIT_PLEDGECREST;
	drawitems[Index].nPosX = nPosX;
	drawitems[Index].nPosY = nPosY;
	if(getInstanceUIData().GetIsLiveServer())
	{
		if((nWidth == 0))
		{
			nWidth = 16;
		}
		if((nHeight == 0))
		{
			nHeight = 12;
		}
	}
	else
	{
		if((nWidth == 0))
		{
			nWidth = 24;
		}
		if((nHeight == 0))
		{
			nHeight = 12;
		}
	}
	drawitems[Index].pledgeCrestInfo.Width = nWidth;
	drawitems[Index].pledgeCrestInfo.Height = nHeight;
	drawitems[Index].pledgeCrestInfo.PledgeID = nPledgeId;
	return;
}

function AddRichListCtrlItem(out array<RichListCtrlDrawItem> drawitems, ItemInfo iInfo, optional int nWidth, optional int nHeight, optional int nPosX, optional int nPosY, optional string TooltipTypeString)
{
	local int Index;

	if((drawitems.Length > 0))
	{
		drawitems.Length = (drawitems.Length + 1);
	}
	else
	{
		drawitems.Length = 1;
	}
	Index = (drawitems.Length - 1);
	if((Index <= -1))
	{
		return;
	}
	drawitems[Index].eType = LCDIT_ITEM;
	if((TooltipTypeString == ""))
	{
		TooltipTypeString = "InventoryWithIcon";
	}
	drawitems[Index].TooltipTypeString = TooltipTypeString;
	drawitems[Index].nPosX = nPosX;
	drawitems[Index].nPosY = nPosY;
	if((nWidth == 0))
	{
		nWidth = 32;
	}
	if((nHeight == 0))
	{
		nHeight = 32;
	}
	drawitems[Index].ItemInfo.Width = nWidth;
	drawitems[Index].ItemInfo.Height = nHeight;
	drawitems[Index].ItemInfo.ItemInfo = iInfo;
	return;
}

function AddRichListCtrlSkill(out array<RichListCtrlDrawItem> drawitems, ItemInfo iInfo, optional int nWidth, optional int nHeight, optional int nPosX, optional int nPosY, optional string TooltipTypeString)
{
	local int Index;

	Index = drawitems.Length;
	if((TooltipTypeString == ""))
	{
		TooltipTypeString = "Skill";
	}
	AddRichListCtrlItem(drawitems, iInfo, nWidth, nHeight, nPosX, nPosY, TooltipTypeString);
	drawitems[Index].eType = LCDIT_SKILL;
	return;
}

function AddRichListCtrlSkillBySkillInfo(out array<RichListCtrlDrawItem> drawitems, SkillInfo sInfo, optional int nWidth, optional int nHeight, optional int nPosX, optional int nPosY, optional string TooltipTypeString)
{
	local int Index;
	local ItemInfo iInfo;

	Index = drawitems.Length;
	if((TooltipTypeString == ""))
	{
		TooltipTypeString = "Skill";
	}
	Class'Interface.L2Util'.static.GetSkill2ItemInfo(sInfo, iInfo);
	AddRichListCtrlItem(drawitems, iInfo, nWidth, nHeight, nPosX, nPosY, TooltipTypeString);
	drawitems[Index].eType = LCDIT_SKILL;
	return;
}

function AddRichListCtrlStatusInfo(out array<RichListCtrlDrawItem> drawitems, optional int nWidth, optional int nHeight, optional int nPosX, optional int nPosY, optional bool bNewLine, optional float ForeProgress, optional float OverProgress, optional string Text, optional int nSkinType, optional string FontName, optional Color FontColor)
{
	local int Index;

	if((drawitems.Length > 0))
	{
		drawitems.Length = (drawitems.Length + 1);
	}
	else
	{
		drawitems.Length = 1;
	}
	Index = (drawitems.Length - 1);
	if((nWidth == 0))
	{
		nWidth = 165;
	}
	if((nHeight == 0))
	{
		nHeight = 20;
	}
	drawitems[Index].eType = LCDIT_STATUS;
	drawitems[Index].statusInfo.Width = nWidth;
	drawitems[Index].statusInfo.Height = nHeight;
	drawitems[Index].nPosX = nPosX;
	drawitems[Index].nPosY = nPosY;
	drawitems[Index].statusInfo.bNewLine = bNewLine;
	drawitems[Index].statusInfo.TexWidth = 4;
	drawitems[Index].statusInfo.TexHeight = 15;
	if((nSkinType == 1))
	{
		drawitems[Index].statusInfo.sBackLeftTex = "L2UI_EPIC.SuppressWnd.Gauge_Grey_Large_Bg_Left";
		drawitems[Index].statusInfo.sBackCenterTex = "L2UI_EPIC.SuppressWnd.Gauge_Grey_Large_Bg_Center";
		drawitems[Index].statusInfo.sBackRightTex = "L2UI_EPIC.SuppressWnd.Gauge_Grey_Large_Bg_Right";
		drawitems[Index].statusInfo.sForeLeftTex = "L2UI_EPIC.SuppressWnd.Gauge_Grey_Large_left";
		drawitems[Index].statusInfo.sForeCenterTex = "L2UI_EPIC.SuppressWnd.Gauge_Grey_Large_center";
		drawitems[Index].statusInfo.sForeRightTex = "L2UI_EPIC.SuppressWnd.Gauge_Grey_Large_right";
		drawitems[Index].statusInfo.sOverLeftTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Left3";
		drawitems[Index].statusInfo.sOverCenterTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Center3";
		drawitems[Index].statusInfo.sOverRightTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Right3";
	}
	else if((nSkinType == 2))
	{
		drawitems[Index].statusInfo.sBackLeftTex = "l2ui_ct1.Gauges.Gauge_DF_Large_HP_bg_Left";
		drawitems[Index].statusInfo.sBackCenterTex = "l2ui_ct1.Gauges.Gauge_DF_Large_HP_bg_Center";
		drawitems[Index].statusInfo.sBackRightTex = "l2ui_ct1.Gauges.Gauge_DF_Large_HP_bg_Right";
		drawitems[Index].statusInfo.sForeLeftTex = "l2ui_ct1.Gauges.gauge_df_large_hp_left";
		drawitems[Index].statusInfo.sForeCenterTex = "l2ui_ct1.Gauges.gauge_df_large_hp_center";
		drawitems[Index].statusInfo.sForeRightTex = "l2ui_ct1.Gauges.gauge_df_large_hp_right";
		drawitems[Index].statusInfo.sOverLeftTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Left3";
		drawitems[Index].statusInfo.sOverCenterTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Center3";
		drawitems[Index].statusInfo.sOverRightTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Right3";
	}
	else if((nSkinType == 3))
	{
		drawitems[Index].statusInfo.sBackLeftTex = "L2UI_EPIC.SuppressWnd.Gauge_Yellow_Large_Bg_Left";
		drawitems[Index].statusInfo.sBackCenterTex = "L2UI_EPIC.SuppressWnd.Gauge_Yellow_Large_Bg_Center";
		drawitems[Index].statusInfo.sBackRightTex = "L2UI_EPIC.SuppressWnd.Gauge_Yellow_Large_Bg_Right";
		drawitems[Index].statusInfo.sForeLeftTex = "L2UI_EPIC.SuppressWnd.Gauge_Yellow_Large_left";
		drawitems[Index].statusInfo.sForeCenterTex = "L2UI_EPIC.SuppressWnd.Gauge_Yellow_Large_center";
		drawitems[Index].statusInfo.sForeRightTex = "L2UI_EPIC.SuppressWnd.Gauge_Yellow_Large_right";
		drawitems[Index].statusInfo.sOverLeftTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Left3";
		drawitems[Index].statusInfo.sOverCenterTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Center3";
		drawitems[Index].statusInfo.sOverRightTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Right3";
	}
	else
	{
		drawitems[Index].statusInfo.sBackLeftTex = "L2UI_EPIC.SuppressWnd.Gauge_Yellow_Large_Bg_Left";
		drawitems[Index].statusInfo.sBackCenterTex = "L2UI_EPIC.SuppressWnd.Gauge_Yellow_Large_Bg_Center";
		drawitems[Index].statusInfo.sBackRightTex = "L2UI_EPIC.SuppressWnd.Gauge_Yellow_Large_Bg_Right";
		drawitems[Index].statusInfo.sForeLeftTex = "L2UI_EPIC.SuppressWnd.Gauge_Red_Large_left";
		drawitems[Index].statusInfo.sForeCenterTex = "L2UI_EPIC.SuppressWnd.Gauge_Red_Large_center";
		drawitems[Index].statusInfo.sForeRightTex = "L2UI_EPIC.SuppressWnd.Gauge_Red_Large_right";
		drawitems[Index].statusInfo.sOverLeftTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Left3";
		drawitems[Index].statusInfo.sOverCenterTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Center3";
		drawitems[Index].statusInfo.sOverRightTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Right3";
	}
	if((FontName == ""))
	{
		drawitems[Index].statusInfo.FontName = "GameDefault";
	}
	else
	{
		drawitems[Index].statusInfo.FontName = FontName;
	}
	if((((int(FontColor.R) == 0) && (int(FontColor.G) == 0)) && (int(FontColor.B) == 0)))
	{
		drawitems[Index].statusInfo.FontColor = GTColor().White;
	}
	else
	{
		drawitems[Index].statusInfo.FontColor = FontColor;
	}
	drawitems[Index].statusInfo.ForeProgress = ForeProgress;
	drawitems[Index].statusInfo.OverProgress = OverProgress;
	drawitems[Index].statusInfo.Text = Text;
	return;
}

function AddEllipsisString(out array<RichListCtrlDrawItem> drawitems, string Text, int MaxW, optional Color TextColor, optional bool bStrNewLine, optional bool useDot, optional int nPosX, optional int nPosY, optional string FontName)
{
	local int Len, textW, textH;
	local string Str;
	local bool bEllipsised;

	Str = Text;
	bEllipsised = Class'Interface.L2Util'.static.GetEllipsisString(Str, (MaxW - nPosX));
	if(useDot)
	{
		AddRichListCtrlString(drawitems, Str, TextColor, bStrNewLine, nPosX, nPosY, FontName);
	}
	else
	{
		AddRichListCtrlString(drawitems, Text, TextColor, bStrNewLine, nPosX, nPosY, FontName);
	}
	if(bEllipsised)
	{
		GetTextSizeDefault(Str, textW, textH);
		Len = drawitems.Length;
		addRichListCtrlTexture(drawitems, "L2UI_CT1.EmptyBtn", textW, textH, -textW, 0);
		drawitems[Len].nReservedTooltipID = 99999;
		drawitems[Len].TooltipDesc = Text;
	}
	return;
}

function StringDrawItem getRichListCtrlString(string Text, optional Color TextColor, optional bool bStrNewLine, optional string FontName)
{
	local StringDrawItem stringDrawItemInfo;

	stringDrawItemInfo.strData = Text;
	stringDrawItemInfo.strColor = TextColor;
	stringDrawItemInfo.bStrNewLine = bStrNewLine;
	if((FontName != ""))
	{
		stringDrawItemInfo.FontName = FontName;
	}
	return stringDrawItemInfo;
}

function TextureDrawItem getRichListCtrlTexture(string texPath, int nWeight, int nHeight, optional int UL, optional int VL)
{
	local TextureDrawItem textureDrawItemInfo;

	textureDrawItemInfo.Width = nWeight;
	textureDrawItemInfo.Height = nHeight;
	textureDrawItemInfo.UL = UL;
	textureDrawItemInfo.VL = VL;
	textureDrawItemInfo.sTex = texPath;
	return textureDrawItemInfo;
}

function ButtonDrawItem getRichListCtrlButton(string buttonStrID, string normalTexStr, string pushedTexStr, int nWeight, int nHeight, optional int UL, optional int VL)
{
	local ButtonDrawItem btnDrawItemInfo;

	btnDrawItemInfo.normalTex.Width = nWeight;
	btnDrawItemInfo.normalTex.Height = nHeight;
	btnDrawItemInfo.pushedTex.Width = nWeight;
	btnDrawItemInfo.pushedTex.Height = nHeight;
	btnDrawItemInfo.normalTex.UL = UL;
	btnDrawItemInfo.normalTex.VL = VL;
	btnDrawItemInfo.pushedTex.UL = UL;
	btnDrawItemInfo.pushedTex.VL = VL;
	btnDrawItemInfo.strID = buttonStrID;
	btnDrawItemInfo.normalTex.sTex = normalTexStr;
	btnDrawItemInfo.pushedTex.sTex = pushedTexStr;
	return btnDrawItemInfo;
}

function AddRichListCtrlButton(out array<RichListCtrlDrawItem> drawitems, string buttonStrID, optional int nPosX, optional int nPosY, optional string normalTex, optional string pushedTex, optional string highlightTex, optional int nWeight, optional int nHeight, optional int U, optional int V, optional int nReservedTooltipID, optional string TooltipDesc)
{
	local int Index;

	if((drawitems.Length > 0))
	{
		drawitems.Length = (drawitems.Length + 1);
	}
	else
	{
		drawitems.Length = 1;
	}
	Index = (drawitems.Length - 1);
	if((Index <= -1))
	{
		return;
	}
	drawitems[Index].eType = LCDIT_BUTTON;
	drawitems[Index].nPosX = nPosX;
	drawitems[Index].nPosY = nPosY;
	drawitems[Index].nReservedTooltipID = nReservedTooltipID;
	drawitems[Index].TooltipDesc = TooltipDesc;
	drawitems[Index].btnInfo.strID = buttonStrID;
	drawitems[Index].btnInfo.normalTex.sTex = normalTex;
	drawitems[Index].btnInfo.normalTex.Width = nWeight;
	drawitems[Index].btnInfo.normalTex.Height = nHeight;
	drawitems[Index].btnInfo.normalTex.UL = U;
	drawitems[Index].btnInfo.normalTex.VL = V;
	drawitems[Index].btnInfo.pushedTex.sTex = pushedTex;
	drawitems[Index].btnInfo.pushedTex.Width = nWeight;
	drawitems[Index].btnInfo.pushedTex.Height = nHeight;
	drawitems[Index].btnInfo.pushedTex.UL = U;
	drawitems[Index].btnInfo.pushedTex.VL = V;
	drawitems[Index].btnInfo.highlightTex.sTex = highlightTex;
	drawitems[Index].btnInfo.highlightTex.Width = nWeight;
	drawitems[Index].btnInfo.highlightTex.Height = nHeight;
	drawitems[Index].btnInfo.highlightTex.UL = U;
	drawitems[Index].btnInfo.highlightTex.VL = V;
	return;
}

function modifyRichListCtrlButton(out array<RichListCtrlDrawItem> drawitems, int drawitemIndex, string buttonStrID, optional int nPosX, optional int nPosY, optional string normalTex, optional string pushedTex, optional string highlightTex, optional int nWeight, optional int nHeight, optional int U, optional int V, optional int nReservedTooltipID, optional string TooltipDesc)
{
	local int Index;

	Index = drawitemIndex;
	if((Index <= -1))
	{
		return;
	}
	drawitems[Index].eType = LCDIT_BUTTON;
	drawitems[Index].nPosX = nPosX;
	drawitems[Index].nPosY = nPosY;
	drawitems[Index].nReservedTooltipID = nReservedTooltipID;
	drawitems[Index].TooltipDesc = TooltipDesc;
	drawitems[Index].btnInfo.strID = buttonStrID;
	drawitems[Index].btnInfo.normalTex.sTex = normalTex;
	drawitems[Index].btnInfo.normalTex.Width = nWeight;
	drawitems[Index].btnInfo.normalTex.Height = nHeight;
	drawitems[Index].btnInfo.normalTex.UL = U;
	drawitems[Index].btnInfo.normalTex.VL = V;
	drawitems[Index].btnInfo.pushedTex.sTex = pushedTex;
	drawitems[Index].btnInfo.pushedTex.Width = nWeight;
	drawitems[Index].btnInfo.pushedTex.Height = nHeight;
	drawitems[Index].btnInfo.pushedTex.UL = U;
	drawitems[Index].btnInfo.pushedTex.VL = V;
	drawitems[Index].btnInfo.highlightTex.sTex = highlightTex;
	drawitems[Index].btnInfo.highlightTex.Width = nWeight;
	drawitems[Index].btnInfo.highlightTex.Height = nHeight;
	drawitems[Index].btnInfo.highlightTex.UL = U;
	drawitems[Index].btnInfo.highlightTex.VL = V;
	return;
}

function SetShowItemCount(out ItemInfo Info)
{
	if(((((!IsStackableItem(Info.ConsumeType) || (Info.Id.ClassID == 57)) || (Info.Id.ClassID == 80306)) || (Info.Id.ClassID == 91663)) || (Info.Id.ClassID == 97145)))
	{
		Info.bShowCount = false;
	}
	else
	{
		Info.bShowCount = true;
	}
	return;
}

function AnimTextureLoopPlay(string controlPath, string texturePath, int playLoopCount)
{
	GetAnimTextureHandle(controlPath).SetTexture(texturePath);
	GetAnimTextureHandle(controlPath).ShowWindow();
	GetAnimTextureHandle(controlPath).SetLoopCount(playLoopCount);
	GetAnimTextureHandle(controlPath).Stop();
	GetAnimTextureHandle(controlPath).Play();
	return;
}

function AnimTextureStop(AnimTextureHandle animTexture, optional bool bHide)
{
	if(bHide)
	{
		animTexture.HideWindow();
	}
	animTexture.Stop();
	return;
}

function AnimTexturePlay(AnimTextureHandle animTexture, optional bool bShow, optional int playLoopCount)
{
	if(bShow)
	{
		animTexture.ShowWindow();
	}
	if((playLoopCount <= 0))
	{
		playLoopCount = 999999;
	}
	animTexture.SetLoopCount(playLoopCount);
	animTexture.Stop();
	animTexture.Play();
	return;
}

function string GetRaceString(int nRace)
{
	switch(nRace)
	{
		case 0:
			return "human";
		case 1:
			return "elf";
		case 2:
			return "darkelf";
		case 3:
			return "orc";
		case 4:
			return "dwarf";
		case 5:
			return "kamael";
		case 6:
			return "Ertheia";
		case 30:
			return "sylph";
		case 31:
			return "HighElf";
		default:
			return "";
	}
}

function INT64 getInventoryItemNumByClassID(int nItemID)
{
	local array<ItemInfo> itemInfoArray;
	local INT64 ItemCount;

	FindItemByClassIDFilter(nItemID, itemInfoArray);
	if((itemInfoArray.Length > 0))
	{
		if(IsStackableItem(itemInfoArray[0].ConsumeType))
		{
			ItemCount = itemInfoArray[0].ItemNum;
		}
		else
		{
			ItemCount = INT64(itemInfoArray.Length);
		}
	}
	return ItemCount;
}

function int EV_PacketID(int nServerPacketID)
{
	return (100000 + nServerPacketID);
}

function bool hasEnoughItem(int ItemClassID, INT64 Amount)
{
	local INT64 invenItemCount;

	invenItemCount = getInventoryItemNumByClassID(ItemClassID);
	if((Amount <= invenItemCount))
	{
		return true;
	}
	return false;
}

static function L2UIInventoryObjectSimple AddItemListenerSimple(int ClassID, optional int ServerID, optional int Index)
{
	local L2UIInventoryObjectSimple iObject;

	iObject = GetInstanceL2UIInventory().NewObjectSimple(ClassID, ServerID, Index);
	return iObject;
}

static function RemObjectSimpleByObject(L2UIInventoryObjectSimple iObject)
{
	GetInstanceL2UIInventory().RemObjectSimpleByObject(iObject);
	return;
}

static function RemItemListenerSimple(int ClassID, optional int ServerID)
{
	GetInstanceL2UIInventory().RemObjectSimple(ClassID, ServerID);
	return;
}

static function L2UIInventoryObject AddItemListener(optional int Index)
{
	local L2UIInventoryObject iObject;

	iObject = GetInstanceL2UIInventory().NewObject();
	iObject.Index = Index;
	return iObject;
}

static function L2UIInventory GetInstanceL2UIInventory()
{
	return L2UIInventory(GetScript("L2UIInventory"));
}

static function L2UIInventoryObjectFindByCompare GetObjectFindItemByCompare()
{
	return L2UIInventory(GetScript("L2UIInventory")).L2UIInventoryFindByCompare;
}

static function string fillZeroString(int nLen, string sValue)
{
	local int N, i;
	local string rStr;

	N = (nLen - Len(sValue));
	i = 0;
	while((i < N))
	{
		rStr = ("0" $ rStr);
		i++;
	}
	return (rStr $ sValue);
}

static function string getColorHexString(Color tColor)
{
	local string colorStr;

	colorStr = ((fillZeroString(2, decToHex(int(tColor.R))) $ fillZeroString(2, decToHex(int(tColor.G)))) $ fillZeroString(2, decToHex(int(tColor.B))));
	return colorStr;
}

static function string decToHex(int Value, optional bool bUse0x)
{
	local string returnString, hexStr;
	local int temp1;

	while((Value != 0))
	{
		temp1 = int((float(Value) % 16.0000000));
		Value = (Value / 16);
		if((temp1 < 10))
		{
			returnString = (string(temp1) $ returnString);
		}
		else
		{
			hexStr = Chr((temp1 + 55));
			returnString = (hexStr $ returnString);
		}
	}
	if(bUse0x)
	{
		returnString = ("0x" $ returnString);
	}
	return returnString;
}

static function bool isNullWindow(WindowHandle checkWindowHandle)
{
	local WindowHandle nullWindow;

	if((checkWindowHandle == nullWindow))
	{
		return true;
	}
	return false;
}

static function bool isActiveSkill(int IconType)
{
	local bool B;

	switch(IconType)
	{
		case 0:
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		case 6:
		case 7:
		case 9:
		case 21:
		case 22:
		case 23:
		case 24:
		case 25:
		case 26:
		case 27:
		case 28:
		case 29:
		case 30:
		case 31:
		case 32:
		case 51:
		case 3315:
		case 3320:
		case 3325:
		case 3330:
		case 3335:
		case 3340:
		case 3345:
		case 3350:
		case 3355:
		case 3360:
		case 3365:
			B = true;
			break;
		default:
			break;
	}
	return B;
}

function string getSkillTypeString(int nSkillIconType)
{
	local string returnV;

	if(IsUseRenewalSkillWnd())
	{
		switch(nSkillIconType)
		{
			case 3300:
				returnV = GetSystemString(311);
				break;
			case 3315:
				returnV = GetSystemString(1694);
				break;
			case 3320:
				returnV = GetSystemString(1695);
				break;
			case 3325:
				returnV = GetSystemString(1555);
				break;
			case 3330:
				returnV = GetSystemString(1552);
				break;
			case 3335:
				returnV = GetSystemString(14377);
				break;
			case 3340:
				returnV = GetSystemString(13592);
				break;
			case 3345:
				returnV = GetSystemString(13593);
				break;
			case 3350:
				returnV = GetSystemString(13594);
				break;
			case 3355:
				returnV = GetSystemString(14411);
				break;
			case 3360:
				returnV = GetSystemString(14415);
				break;
			case 3365:
				returnV = GetSystemString(14354);
				break;
			case 3600:
				returnV = GetSystemString(312);
				break;
			case 3615:
				returnV = GetSystemString(14446);
				break;
			case 3620:
				returnV = GetSystemString(1703);
				break;
			case 3625:
				returnV = GetSystemString(13596);
				break;
			case 3630:
				returnV = GetSystemString(14412);
				break;
			case 3635:
				returnV = GetSystemString(14413);
				break;
			case 6615:
				returnV = GetSystemString(14391);
				break;
			case 6620:
				returnV = GetSystemString(14379);
				break;
			case 6625:
				returnV = GetSystemString(14380);
				break;
			case 6630:
				returnV = GetSystemString(14381);
				break;
			case 6635:
				returnV = GetSystemString(14382);
				break;
			case 6640:
				returnV = GetSystemString(14378);
				break;
			case 6642:
				returnV = GetSystemString(14951);
				break;
			case 6645:
				returnV = GetSystemString(14414);
				break;
			case 6650:
				returnV = GetSystemString(14388);
				break;
			case 51:
				returnV = GetSystemString(5896);
				break;
			case -1:
				returnV = GetSystemString(127);
				break;
			default:
				returnV = "Error SkillType";
		}
	}
	else
	{
		switch(nSkillIconType)
		{
			case 0:
				returnV = GetSystemString(1694);
				break;
			case 1:
				returnV = GetSystemString(1695);
				break;
			case 2:
				returnV = GetSystemString(1696);
				break;
			case 3:
				returnV = GetSystemString(13597);
				break;
			case 4:
				returnV = GetSystemString(13598);
				break;
			case 5:
				returnV = GetSystemString(1699);
				break;
			case 6:
				returnV = GetSystemString(1700);
				break;
			case 7:
				returnV = GetSystemString(1698);
				break;
			case 9:
				returnV = GetSystemString(1701);
				break;
			case 11:
				returnV = GetSystemString(1702);
				break;
			case 12:
				returnV = GetSystemString(1703);
				break;
			case 13:
				returnV = GetSystemString(1704);
				break;
			case 14:
				returnV = GetSystemString(1705);
				break;
			case 15:
				returnV = GetSystemString(1699);
				break;
			case 16:
				returnV = GetSystemString(1700);
				break;
			case 17:
				returnV = GetSystemString(3877);
				break;
			case 18:
				returnV = GetSystemString(3897);
				break;
			case 21:
				returnV = GetSystemString(1694);
				break;
			case 22:
				returnV = GetSystemString(1695);
				break;
			case 23:
				returnV = GetSystemString(1555);
				break;
			case 24:
				returnV = GetSystemString(1552);
				break;
			case 25:
				returnV = GetSystemString(13589);
				break;
			case 26:
				returnV = GetSystemString(1553);
				break;
			case 27:
				returnV = GetSystemString(1554);
				break;
			case 28:
				returnV = GetSystemString(13592);
				break;
			case 29:
				returnV = GetSystemString(13593);
				break;
			case 30:
				returnV = GetSystemString(13594);
				break;
			case 31:
				returnV = GetSystemString(13595);
				break;
			case 32:
				returnV = GetSystemString(3897);
				break;
			case 35:
				returnV = GetSystemString(1703);
				break;
			case 36:
				returnV = GetSystemString(1702);
				break;
			case 37:
				returnV = GetSystemString(13596);
				break;
			case 38:
				returnV = GetSystemString(13595);
				break;
			case 39:
				returnV = GetSystemString(1700);
				break;
			case 40:
				returnV = GetSystemString(3897);
				break;
			case 50:
				returnV = GetSystemString(313);
				break;
			case 51:
			case 52:
				returnV = GetSystemString(5896);
				break;
			default:
				returnV = "Error SkillType";
		}
	}
	return returnV;
}

function string getSkillWeaponString(UIEventManager.AttackType eAttackType)
{
	local string returnV;

	if(getInstanceUIData().GetIsClassicServer())
	{
		returnV = getSkillWeaponStringClassic(eAttackType);
	}
	else
	{
		returnV = getSkillWeaponStringLive(eAttackType);
	}
	return returnV;
}

function string getSkillWeaponStringClassic(UIEventManager.AttackType eAttackType)
{
	local string returnV;

	switch(eAttackType)
	{
		case AT_SWORD:
			returnV = GetSystemString(13599);
			break;
		case AT_BUSTER:
			returnV = GetSystemString(14674);
			break;
		case AT_TWOHANDSWORD:
			returnV = GetSystemString(13601);
			break;
		case AT_BLUNT:
			returnV = GetSystemString(13600);
			break;
		case AT_STAFF:
			returnV = GetSystemString(14672);
			break;
		case AT_TWOHANDBLUNT:
			returnV = GetSystemString(2527);
			break;
		case AT_TWOHANDSTAFF:
			returnV = GetSystemString(14673);
			break;
		case AT_DAGGER:
			returnV = GetSystemString(45);
			break;
		case AT_POLE:
			returnV = GetSystemString(46);
			break;
		case AT_BOW:
			returnV = GetSystemString(48);
			break;
		case AT_DUAL:
			returnV = GetSystemString(504);
			break;
		case AT_DUALFIST:
			returnV = GetSystemString(2530);
			break;
		case AT_FISHINGROD:
			returnV = GetSystemString(3184);
			break;
		case AT_RAPIER:
			returnV = GetSystemString(1648);
			break;
		case AT_ANCIENTSWORD:
			returnV = GetSystemString(1650);
			break;
		case AT_SHOOTER:
			returnV = GetSystemString(13639);
			break;
		case AT_DUALBLUNT:
		case AT_DUALDAGGER:
		case AT_CROSSBOW:
		case AT_TWOHANDCROSSBOW:
		case AT_FIST:
		case AT_PISTOL:
		case AT_OWNTHING:
		case AT_FLAG:
		case AT_ETC:
			returnV = "";
		default:
			break;
	}
	return returnV;
}

function string getSkillWeaponStringLive(UIEventManager.AttackType eAttackType)
{
	local string returnV;

	switch(eAttackType)
	{
		case AT_SWORD:
		case AT_BUSTER:
			returnV = GetSystemString(13599);
			break;
		case AT_TWOHANDSWORD:
			returnV = GetSystemString(13601);
			break;
		case AT_BLUNT:
		case AT_STAFF:
			returnV = GetSystemString(13600);
			break;
		case AT_TWOHANDBLUNT:
		case AT_TWOHANDSTAFF:
			returnV = GetSystemString(2527);
			break;
		case AT_DAGGER:
			returnV = GetSystemString(45);
			break;
		case AT_POLE:
			returnV = GetSystemString(46);
			break;
		case AT_BOW:
			returnV = GetSystemString(48);
			break;
		case AT_DUAL:
			returnV = GetSystemString(504);
			break;
		case AT_DUALFIST:
		case AT_FIST:
			returnV = GetSystemString(2530);
			break;
		case AT_FISHINGROD:
			returnV = GetSystemString(3184);
			break;
		case AT_RAPIER:
			returnV = GetSystemString(1648);
			break;
		case AT_CROSSBOW:
		case AT_TWOHANDCROSSBOW:
			returnV = GetSystemString(1649);
			break;
		case AT_ANCIENTSWORD:
			returnV = GetSystemString(1650);
			break;
		case AT_DUALDAGGER:
			returnV = GetSystemString(1970);
			break;
		case AT_DUALBLUNT:
			returnV = GetSystemString(2529);
			break;
		case AT_PISTOL:
		case AT_OWNTHING:
		case AT_FLAG:
		case AT_ETC:
			returnV = "";
		default:
			break;
	}
	return returnV;
}

function string getSkillTraitString(UIEventManager.ESkillTraitType skillTraitType)
{
	local string returnV;

	if(getInstanceUIData().GetIsClassicServer())
	{
		returnV = getSkillTraitStringClassic(skillTraitType);
	}
	else
	{
		returnV = getSkillTraitStringLive(int(skillTraitType));
	}
	return returnV;
}

function string getSkillTraitStringClassic(UIEventManager.ESkillTraitType skillTraitType)
{
	local string returnV;

	switch(skillTraitType)
	{
		case ESkillTrait_Hold:
			returnV = GetSystemString(13606);
			break;
		case ESkillTrait_Infection:
			returnV = GetSystemString(13607);
			break;
		case ESkillTrait_Sleep:
			returnV = GetSystemString(13608);
			break;
		case ESkillTrait_Shock:
			returnV = GetSystemString(13609);
			break;
		case ESkillTrait_Paralyze:
			returnV = GetSystemString(13610);
			break;
		case ESkillTrait_Seal:
			returnV = GetSystemString(13611);
			break;
		case ESkillTrait_Pull:
			returnV = GetSystemString(13612);
			break;
		case ESkillTrait_Silence:
			returnV = GetSystemString(13613);
			break;
		case ESkillTrait_Fear:
			returnV = GetSystemString(13614);
			break;
		case ESkillTrait_SlowDown:
			returnV = GetSystemString(13615);
			break;
		default:
			returnV = "";
	}
	return returnV;
}

function string getSkillTraitStringLive(int nMezType)
{
	local string returnV;

	switch(nMezType)
	{
		case 11:
			returnV = GetSystemString(13616);
			break;
		case 12:
		case 1:
		case 13:
		case 14:
		case 15:
		case 16:
		case 17:
			returnV = GetSystemString(13617);
			break;
		case 18:
		case 19:
			returnV = GetSystemString(13618);
			break;
		case 3:
		case 20:
			returnV = GetSystemString(13619);
			break;
		case 21:
		case 22:
		case 23:
		case 24:
		case 4:
		case 5:
		case 25:
		case 26:
		case 7:
			returnV = GetSystemString(13620);
			break;
		default:
			returnV = "";
	}
	return returnV;
}

function string getSkillTargetTypeString(UIEventManager.ESkillTargetType skillTargetType)
{
	local string returnV;

	switch(skillTargetType)
	{
		case ESkillTarget_Enemy:
		case ESkillTarget_EnemyOnly:
		case ESkillTarget_RealEnemyOnly:
			returnV = GetSystemString(13621);
			break;
		case ESkillTarget_EnemyNot:
			returnV = GetSystemString(13622);
			break;
		case ESkillTarget_Self:
			returnV = GetSystemString(436);
			break;
		case ESkillTarget_Summon:
			returnV = GetSystemString(505);
			break;
		case ESkillTarget_Target:
		case ESkillTarget_TargetSelf:
			returnV = GetSystemString(13693);
			break;
		default:
			returnV = "";
	}
	return returnV;
}

function string getSkillAffectTypeString(UIEventManager.ESkillAffectScope skillAffectObject)
{
	local string returnV;

	switch(skillAffectObject)
	{
		case ESkillAffect_Single:
			returnV = GetSystemString(13625);
			break;
		case ESkillAffect_Party:
			returnV = GetSystemString(440);
			break;
		case ESkillAffect_Pledge:
			returnV = GetSystemString(439);
			break;
		case ESkillAffect_Fan:
		case ESkillAffect_PointBlank:
		case ESkillAffect_RangeSortByDist:
		case ESkillAffect_RangeSortByHp:
		case ESkillAffect_Range:
		case ESkillAffect_Square:
		case ESkillAffect_Range_sort_by_block_act:
		case ESkillAffect_Fan_with_relation:
		case ESkillAffect_Point_blank_with_relation:
		case ESkillAffect_Range_with_relation:
		case ESkillAffect_Square_with_relation:
			returnV = GetSystemString(13626);
			break;
		default:
			returnV = "";
	}
	return returnV;
}

function string getSkillEquipNameStr(int SkillID, int Level, int SubLevel)
{
	local UIEventManager.ESkillConditionEquipType o_EquipType;
	local string returnStr;
	local array<AttackType> o_ArrWeapons;

	Class'NWindow.UIDATA_SKILL'.static.GetMSCondEquipType(SkillID, Level, SubLevel, o_EquipType);
	switch(o_EquipType)
	{
		case SCET_SHIELD:
			returnStr = GetSystemString(231);
			break;
		case SCET_WEAPON:
			Class'NWindow.UIDATA_SKILL'.static.GetMSCondWeapons(SkillID, Level, SubLevel, o_ArrWeapons);
			if(getInstanceUIData().GetIsClassicServer())
			{
				returnStr = outputFilterAttackTypeClassic(o_ArrWeapons);
			}
			else
			{
				returnStr = outputFilterAttackTypeLive(o_ArrWeapons);
			}
			break;
		default:
			break;
	}
	return returnStr;
}

function string outputFilterAttackTypeLive(array<AttackType> ArrWeapons)
{
	local array<int> condition1, condition2, condition3, condition4, condition5, condition6;
	local string returnStr;
	local int i;

	condition1[condition1.Length] = 1;
	condition1[condition1.Length] = 3;
	condition1[condition1.Length] = 2;
	condition1[condition1.Length] = 4;
	condition1[condition1.Length] = 5;
	condition1[condition1.Length] = 6;
	condition1[condition1.Length] = 7;
	condition1[condition1.Length] = 8;
	condition1[condition1.Length] = 9;
	condition1[condition1.Length] = 14;
	condition1[condition1.Length] = 13;
	condition1[condition1.Length] = 20;
	condition1[condition1.Length] = 23;
	condition2[condition2.Length] = 1;
	condition2[condition2.Length] = 3;
	condition2[condition2.Length] = 2;
	condition3[condition3.Length] = 3;
	condition3[condition3.Length] = 5;
	condition4[condition4.Length] = 6;
	condition4[condition4.Length] = 7;
	condition5[condition5.Length] = 10;
	condition5[condition5.Length] = 14;
	condition6[condition6.Length] = 17;
	condition6[condition6.Length] = 22;
	i = 0;
	while((i < ArrWeapons.Length))
	{
		Debug(((("ArrWeapons" @ string(i)) @ ":") @ string(ArrWeapons[i])));
		i++;
	}
	if(compareAttackType(ArrWeapons, condition1))
	{
		returnStr = ((returnStr $ "/") $ GetSystemString(13602));
	}
	Debug(("모든 근접 무기 체크" @ returnStr));  // EN?: Check all melee weapons
	if(compareAttackType(ArrWeapons, condition2))
	{
		returnStr = ((returnStr $ "/") $ GetSystemString(13603));
	}
	Debug(("도검류 체크" @ returnStr));  // EN?: Check swords
	if(compareAttackType(ArrWeapons, condition3))
	{
		returnStr = ((returnStr $ "/") $ GetSystemString(13604));
	}
	Debug(("둔기류 체크" @ returnStr));  // EN?: Check for blunt air
	if(compareAttackType(ArrWeapons, condition4))
	{
		returnStr = ((returnStr $ "/") $ GetSystemString(13605));
	}
	Debug(("지팡이류  체크" @ returnStr));  // EN?: Cane Check
	if(compareAttackType(ArrWeapons, condition5))
	{
		returnStr = ((returnStr $ "/") $ GetSystemString(2530));
	}
	Debug(("격투무기 체크" @ returnStr));  // EN?: Fighting Weapon Check
	if(compareAttackType(ArrWeapons, condition6))
	{
		returnStr = ((returnStr $ "/") $ GetSystemString(1649));
	}
	Debug(("석궁 체크" @ returnStr));  // EN?: Crossbow check
	i = 0;
	while((i < ArrWeapons.Length))
	{
		returnStr = ((returnStr $ "/") $ getSkillWeaponString(ArrWeapons[i]));
		i++;
	}
	if((Len(returnStr) > 0))
	{
		returnStr = Right(returnStr, (Len(returnStr) - 1));
	}
	return returnStr;
}

function string outputFilterAttackTypeClassic(array<AttackType> ArrWeapons)
{
	local array<int> condition1, condition2, condition3, condition4, condition5, condition6, condition7, condition8, condition9;
	local string returnStr;
	local int i;

	condition1[condition1.Length] = 1;
	condition1[condition1.Length] = 3;
	condition1[condition1.Length] = 2;
	condition1[condition1.Length] = 4;
	condition1[condition1.Length] = 5;
	condition1[condition1.Length] = 6;
	condition1[condition1.Length] = 7;
	condition1[condition1.Length] = 14;
	condition1[condition1.Length] = 11;
	condition1[condition1.Length] = 18;
	condition1[condition1.Length] = 16;
	condition1[condition1.Length] = 9;
	condition1[condition1.Length] = 8;
	condition1[condition1.Length] = 13;
	condition1[condition1.Length] = 25;
	condition2[condition2.Length] = 4;
	condition2[condition2.Length] = 6;
	condition2[condition2.Length] = 5;
	condition2[condition2.Length] = 7;
	condition3[condition3.Length] = 1;
	condition3[condition3.Length] = 3;
	condition3[condition3.Length] = 2;
	condition4[condition4.Length] = 1;
	condition4[condition4.Length] = 2;
	condition5[condition5.Length] = 1;
	condition5[condition5.Length] = 3;
	condition6[condition6.Length] = 4;
	condition6[condition6.Length] = 6;
	condition7[condition7.Length] = 5;
	condition7[condition7.Length] = 7;
	condition8[condition8.Length] = 2;
	condition8[condition8.Length] = 5;
	condition8[condition8.Length] = 7;
	condition9[condition9.Length] = 3;
	condition9[condition9.Length] = 6;
	condition9[condition9.Length] = 7;
	if(compareAttackType(ArrWeapons, condition1))
	{
		returnStr = ((returnStr $ "/") $ GetSystemString(2520));
	}
	if(compareAttackType(ArrWeapons, condition3))
	{
		returnStr = ((returnStr $ "/") $ GetSystemString(43));
	}
	if(compareAttackType(ArrWeapons, condition4))
	{
		returnStr = ((returnStr $ "/") $ GetSystemString(43));
	}
	if(compareAttackType(ArrWeapons, condition5))
	{
		returnStr = ((returnStr $ "/") $ GetSystemString(13599));
	}
	if(compareAttackType(ArrWeapons, condition2))
	{
		returnStr = ((returnStr $ "/") $ GetSystemString(44));
	}
	if(compareAttackType(ArrWeapons, condition6))
	{
		returnStr = ((returnStr $ "/") $ GetSystemString(13600));
	}
	if(compareAttackType(ArrWeapons, condition8))
	{
		returnStr = ((((returnStr $ "/") $ GetSystemString(13601)) $ "/") $ GetSystemString(2527));
	}
	if(compareAttackType(ArrWeapons, condition7))
	{
		returnStr = ((returnStr $ "/") $ GetSystemString(2527));
	}
	if(compareAttackType(ArrWeapons, condition9))
	{
		returnStr = ((((((returnStr $ "/") $ GetSystemString(14672)) $ "/") $ GetSystemString(14673)) $ "/") $ GetSystemString(14674));
	}
	i = 0;
	while((i < ArrWeapons.Length))
	{
		returnStr = ((returnStr $ "/") $ getSkillWeaponString(ArrWeapons[i]));
		i++;
	}
	if((Len(returnStr) > 0))
	{
		returnStr = Right(returnStr, (Len(returnStr) - 1));
	}
	return returnStr;
}

function bool compareAttackType(out array<AttackType> ArrWeapons, array<int> checkArray)
{
	local int i, N;
	local bool isSame;

	if((ArrWeapons.Length == 0))
	{
		return false;
	}
	N = 0;
	while((N < checkArray.Length))
	{
		isSame = false;
		i = 0;
		while((i < ArrWeapons.Length))
		{
			if((int(ArrWeapons[i]) == checkArray[N]))
			{
				isSame = true;
				break;
			}
			i++;
		}
		if(!isSame)
		{
			break;
		}
		N++;
	}
	if(!isSame)
	{
		return false;
	}
	N = 0;
	while((N < checkArray.Length))
	{
		i = 0;
		while((i < ArrWeapons.Length))
		{
			if((int(ArrWeapons[i]) == checkArray[N]))
			{
				ArrWeapons.Remove(i, 1);
				break;
			}
			i++;
		}
		N++;
	}
	return true;
}

static function float floatMultiply(float P1, float P2)
{
	local int n1, n2, sum;

	n1 = int((P1 * 1000.0000000));
	n2 = int((P2 * 1000.0000000));
	sum = (n1 * n2);
	return (float(sum) / 1000000.0000000);
}

function CommonDialogSetScript(string uiControlDialogAsset_path, optional string disable_tex_path, optional bool bUseNeedItem)
{
	local WindowHandle popExpandWnd;
	local UIControlDialogAssets popupExpandScript;

	popExpandWnd = GetWindowHandle(uiControlDialogAsset_path);
	popupExpandScript = Class'Interface.UIControlDialogAssets'.static.InitScript(popExpandWnd);
	popupExpandScript.SetUseNeedItem(bUseNeedItem);
	if((disable_tex_path != ""))
	{
		popupExpandScript.SetDisableWindow(GetWindowHandle(disable_tex_path));
	}
	return;
}

function UIControlDialogAssets CommonDialogGetScript(string uiControlDialogAsset_path)
{
	return UIControlDialogAssets(GetWindowHandle(uiControlDialogAsset_path).GetScript());
}

function CommonDialogShow(string uiControlDialogAsset_path, string dialogDesc, optional bool bHtml, optional int okButtonString, optional int cancelButtonString, optional Color TextColor)
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = CommonDialogGetScript(uiControlDialogAsset_path);
	if(bHtml)
	{
		popupExpandScript.SetDialogDescHtml(dialogDesc, okButtonString, cancelButtonString, TextColor);
	}
	else
	{
		popupExpandScript.SetDialogDesc(dialogDesc, okButtonString, cancelButtonString, TextColor);
	}
	popupExpandScript.Show();
	return;
}

function CommonDialogHide(string uiControlDialogAsset_path)
{
	local UIControlDialogAssets popupExpandScript;

	popupExpandScript = CommonDialogGetScript(uiControlDialogAsset_path);
	popupExpandScript.Hide();
	return;
}

function UIEventManager.EAutoNextTargetMode GetNextTargetModeOption()
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		switch(GetOptionInt("CommunIcation", "NextTargetModeClassic"))
		{
			case 0:
				return ANTM_DEFAULT;
			case 1:
				return ANTM_HOSTILE_NPC;
			case 2:
				return ANTM_HOSTILE_PC;
			case 3:
				return ANTM_FRIENDLY_NPC;
			case 4:
				return ANTM_DEFAULT_AND_COUNTER_ATTACK;
			default:
				break;
		}
	}
	else
	{
		switch(GetOptionInt("CommunIcation", "NextTargetMode"))
		{
			case 0:
				return ANTM_DEFAULT;
			case 1:
				return ANTM_HOSTILE_NPC;
			case 2:
				return ANTM_HOSTILE_PC;
			case 3:
				return ANTM_FRIENDLY_NPC;
			default:
				break;
		}
	}
	return ANTM_DEFAULT;
}

function bool isCollectionItem(ItemInfo item)
{
	local array<int> collectionidArray;

	if(IsCollectionServer())
	{
		GetCollectionIdByItemId(collectionidArray, item.Id.ClassID);
		if((collectionidArray.Length > 0))
		{
			return true;
		}
	}
	return false;
}

function string stringPer(float A, float B)
{
	local string Str, returnStr;
	local array<string> arrSplit;

	Str = string((float(appCeil((((A / B) * 100.0000000) * 10.0000000))) / 10.0000000));
	Split(Str, ".", arrSplit);
	returnStr = ((arrSplit[0] $ ".") $ Mid(arrSplit[1], 0, 1));
	return returnStr;
}

function string string0100Per(float A)
{
	local string returnStr;

	if((A <= 0.0000000))
	{
		returnStr = "0";
	}
	else if((A >= 100.0000000))
	{
		returnStr = "100";
	}
	else
	{
		returnStr = string(A);
	}
	return returnStr;
}

function string GetServerMarkNameSmall(int WorldID)
{
	local string Tex;

	Tex = GetServerMarkName(WorldID);
	if((Tex == ""))
	{
		Tex = "L2UI_CT1.EmptyBtn";
	}
	else
	{
		Tex = ("L2UI_EPIC.DethroneWnd.Crest_" $ Tex);
	}
	return Tex;
}

function string GetServerMark(int WorldID)
{
	local string Tex;

	Tex = GetServerMarkName(WorldID);
	if((Tex == ""))
	{
		Tex = "L2UI_CT1.EmptyBtn";
	}
	else
	{
		Tex = (("L2UI_EPIC.DethroneWnd.Crest_" $ Tex) $ "_Green");
	}
	return Tex;
}

function string GetServerMarkNameTarget(int WorldID, bool bEnemy)
{
	local string Tex;

	Tex = GetServerMarkName(WorldID);
	if(bEnemy)
	{
		Tex = (("L2UI_CT1.TargetStatusWnd.TargetStatusWnd_DethroneServerIcon_" $ Tex) $ "_Red");
	}
	else
	{
		Tex = (("L2UI_CT1.TargetStatusWnd.TargetStatusWnd_DethroneServerIcon_" $ Tex) $ "_Blue");
	}
	return Tex;
}

static function string getWorldNameToLocalName(string worldName)
{
	local string UserName;
	local array<string> arr;

	Split(worldName, "_", arr);
	if((arr.Length > 1))
	{
		UserName = arr[0];
	}
	else
	{
		UserName = worldName;
	}
	return UserName;
}

static function string getWorldServerFullName(string worldName)
{
	local string UserName;
	local int serverNo;
	local array<string> arr;

	Split(worldName, "_", arr);
	if((arr.Length > 1))
	{
		serverNo = int(arr[1]);
		UserName = ((arr[0] $ "_") $ getServerNameByWorldID(serverNo));
	}
	else
	{
		UserName = worldName;
	}
	return UserName;
}

static function string getServerNameByWorldID(int ServerWorldID)
{
	local ServerInfoUIData sUiData;

	Class'NWindow.UIDataManager'.static.GetServerInfo(ServerWorldID, sUiData);
	return sUiData.ServerName;
}

static function int getServerExtIdByWorldID(int ServerWorldID)
{
	local ServerInfoUIData sUiData;

	Class'NWindow.UIDataManager'.static.GetServerInfo(ServerWorldID, sUiData);
	return sUiData.ServerExtID;
}

function bool isMyServer(int compareServerID)
{
	local UserInfo Info;

	GetPlayerInfo(Info);
	if((Info.nWorldID == compareServerID))
	{
		return true;
	}
	return false;
}

function string GetCenterTable(string htm, int W, int h, optional string Align, optional string VAlign)
{
	if((Align == ""))
	{
		Align = "Center";
	}
	if((VAlign == ""))
	{
		VAlign = "Center";
	}
	htm = HtmlAddTableTD(htm, Align, VAlign, W, h);
	HtmlSetTableTR(htm);
	htmlSetTable(htm, 0, 0, 0, "", 0, 0);
	return htm;
}

function string GetNameHtmlFull(ItemInfo item)
{
	local string HTML, textureHtml;
	local int W;

	if((item.Enchanted > 0))
	{
		HTML = (GetEnchantedHtml(item.Enchanted) $ " ");
	}
	if(item.IsBlessedItem)
	{
		HTML = ((HTML $ GetNameHtmlBress()) $ " ");
	}
	HTML = (HTML $ GetNameHtml(item));
	if((Len(item.AdditionalName) > 0))
	{
		HTML = (HTML @ GetNameHtmlAddionalName(item.AdditionalName));
	}
	HTML = HtmlAddTableTD(HTML, "Center", "center", 0, 22);
	textureHtml = GetNameHtmlGradeIcon(item.CrystalType, W);
	if((textureHtml != ""))
	{
		HTML = (HTML $ HtmlAddTableTD((" " $ textureHtml), "Center", "Center", (W + 5), 22, "", true));
	}
	HTML = HtmlSetTableTR(HTML);
	return htmlSetTable(HTML, 0, 0, 16, "", 0, 0);
}

function string GetEnchantedHtml(int Enchanted)
{
	return htmlAddText(("+" $ string(Enchanted)), "GameDefault", "AA6EE6");
}

function string GetNameHtmlBress()
{
	return htmlAddText(GetSystemString(13403), "GameDefault", "7A96AB");
}

function string GetNameHtml(ItemInfo item)
{
	local string ItemName, collorString;

	if(Class'Interface.UIData'.static.Inst().GetIsLiveServer())
	{
		ItemName = Class'NWindow.UIDATA_ITEM'.static.GetRefineryItemName(item.Name, item.RefineryOp1, item.RefineryOp2);
	}
	else
	{
		ItemName = item.Name;
	}
	switch(Class'NWindow.UIDATA_ITEM'.static.GetItemNameClass(item.Id))
	{
		case 0:
			collorString = "5F5F5F";
			break;
		case 1:
			collorString = "FFFFFF";
			break;
		case 2:
			collorString = "FFA904";
			break;
		case 3:
			collorString = "F04444";
			break;
		case 4:
			collorString = "21A4FF";
			break;
		case 5:
			collorString = "FF00FF";
			break;
		default:
			break;
	}
	return htmlAddText(ItemName, "GameDefault", collorString);
}

function string GetNameHtmlAddionalName(string AdditionalName)
{
	return htmlAddText(AdditionalName, "GameDefault", getColorHexString(GetColor(255, 217, 105, 255)));
}

function string GetNameHtmlGradeIcon(int nCrystalType, out int W)
{
	local int h;
	local string gradeTextureName;

	gradeTextureName = GetItemGradeTextureName(nCrystalType);
	if((gradeTextureName == ""))
	{
		return "";
	}
	if((((((nCrystalType == 6) || (nCrystalType == 7)) || (nCrystalType == 9)) || (nCrystalType == 10)) || (nCrystalType == 11)))
	{
		W = 32;
		h = 16;
	}
	else
	{
		W = 16;
		h = 16;
	}
	return htmlAddImg(gradeTextureName, W, h);
}

function string cutZeroDecimalStr(string Probability)
{
	local int i;
	local array<string> arrSplit;

	if((float(int(Probability)) < float(Probability)))
	{
		Split(Probability, ".", arrSplit);
		i = Len(arrSplit[1]);
		while((i > 0))
		{
			if((Mid(arrSplit[1], (i - 1), 1) != "0"))
			{
				arrSplit[1] = Left(arrSplit[1], i);
				break;
			}
			i--;
		}
		return ((arrSplit[0] $ ".") $ arrSplit[1]);
	}
	return string(int(Probability));
}

function string cutZeroDecimalFloat(float Probability)
{
	local int i;
	local array<string> arrSplit;

	if((float(int(Probability)) < Probability))
	{
		Split(string(Probability), ".", arrSplit);
		i = Len(arrSplit[1]);
		while((i > 0))
		{
			if((Mid(arrSplit[1], (i - 1), 1) != "0"))
			{
				arrSplit[1] = Left(arrSplit[1], i);
				break;
			}
			i--;
		}
		return ((arrSplit[0] $ ".") $ arrSplit[1]);
	}
	return string(int(Probability));
}

function INT64 MAX64(INT64 A, INT64 B)
{
	if((A > B))
	{
		return A;
	}
	return B;
}

function setWindowTitleByString(string windowTitleStr)
{
	if((GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".FrameHeaderWnd.FrameTitle_txt")).m_pTargetWnd == none))
	{
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath).SetWindowTitle(windowTitleStr);
	}
	else
	{
		GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".FrameHeaderWnd.FrameTitle_txt")).SetText(windowTitleStr);
	}
	return;
}

function setWindowTitleBySysStringNum(int windowTitleSysStringNum)
{
	if((GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".FrameHeaderWnd.FrameTitle_txt")).m_pTargetWnd == none))
	{
		GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath).SetWindowTitle(GetSystemString(windowTitleSysStringNum));
	}
	else
	{
		GetTextBoxHandle((m_hOwnerWnd.m_WindowNameWithFullPath $ ".FrameHeaderWnd.FrameTitle_txt")).SetText(GetSystemString(windowTitleSysStringNum));
	}
	return;
}

function AnimTextureHandle GetMeAnimTexture(string Path)
{
	return GetAnimTextureHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function BarHandle GetMeBar(string Path)
{
	return GetBarHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function ButtonHandle GetMeButton(string Path)
{
	return GetButtonHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function CharacterViewportWindowHandle GetMeCharacterViewportWindow(string Path)
{
	return GetCharacterViewportWindowHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function ChatWindowHandle GetMeChatWindow(string Path)
{
	return GetChatWindowHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function CheckBoxHandle GetMeCheckBox(string Path)
{
	return GetCheckBoxHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function ComboBoxHandle GetMeComboBox(string Path)
{
	return GetComboBoxHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function DrawPanelHandle GetMeDrawPanel(string Path)
{
	return GetDrawPanelHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function EditBoxHandle GetMeEditBox(string Path)
{
	return GetEditBoxHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function EffectViewportWndHandle GetMeEffectViewportWnd(string Path)
{
	return GetEffectViewportWndHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function HtmlHandle GetMeHtml(string Path)
{
	return GetHtmlHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function ItemWindowHandle GetMeItemWindow(string Path)
{
	return GetItemWindowHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function ListBoxHandle GetMeListBox(string Path)
{
	return GetListBoxHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function ListCtrlHandle GetMeListCtrl(string Path)
{
	return GetListCtrlHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function MinimapCtrlHandle GetMeMinimapCtrl(string Path)
{
	return GetMinimapCtrlHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function MultiEditBoxHandle GetMeMultiEditBox(string Path)
{
	return GetMultiEditBoxHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function NameCtrlHandle GetMeNameCtrl(string Path)
{
	return GetNameCtrlHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function ProgressCtrlHandle GetMeProgressCtrl(string Path)
{
	return GetProgressCtrlHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function PropertyControllerHandle GetMePropertyController(string Path)
{
	return GetPropertyControllerHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function RadarMapCtrlHandle GetMeRadarMapCtrl(string Path)
{
	return GetRadarMapCtrlHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function RadioButtonHandle GetMeRadioButton(string Path)
{
	return GetRadioButtonHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function RichListCtrlHandle GetMeRichListCtrl(string Path)
{
	return GetRichListCtrlHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function SliderCtrlHandle GetMeSliderCtrl(string Path)
{
	return GetSliderCtrlHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function StatusBarHandle GetMeStatusBar(string Path)
{
	return GetStatusBarHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function StatusRoundHandle GetMeStatusRound(string Path)
{
	return GetStatusRoundHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function TabHandle GetMeTab(string Path)
{
	return GetTabHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function TextBoxHandle GetMeTextBox(string Path)
{
	return GetTextBoxHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function TextureHandle GetMeTexture(string Path)
{
	return GetTextureHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function TreeHandle GetMeTree(string Path)
{
	return GetTreeHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function WebBrowserHandle GetMeWebBrowser(string Path)
{
	return GetWebBrowserHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function WindowHandle GetMeWindow(optional string Path)
{
	if((Path == ""))
	{
		return GetWindowHandle(m_hOwnerWnd.m_WindowNameWithFullPath);
	}
	return GetWindowHandle(((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path));
}

function string selfName(optional string addStringPath)
{
	if((addStringPath == ""))
	{
		return m_hOwnerWnd.m_WindowNameWithFullPath;
	}
	return ((m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ addStringPath);
}

function CloseUI()
{
	if((m_hOwnerWnd.IsShowWindow() == false))
	{
		return;
	}
	Class'Interface.Shortcut'.static.Inst()._ExeShowHideWIndow(m_hOwnerWnd.m_WindowNameWithFullPath);
	return;
}

function ItemInfo getSkillToItemInfo(SkillInfo rSkilInfo)
{
	local ItemInfo infItem;

	infItem.Id.ClassID = rSkilInfo.SkillID;
	infItem.Level = rSkilInfo.SkillLevel;
	infItem.SubLevel = rSkilInfo.SkillSubLevel;
	infItem.Name = rSkilInfo.SkillName;
	infItem.IconName = rSkilInfo.TexName;
	infItem.IconPanel = rSkilInfo.IconPanel;
	infItem.Description = rSkilInfo.SkillDesc;
	infItem.ShortcutType = 2;
	infItem.ItemType = rSkilInfo.OperateType;
	return infItem;
}

function SkillInfo GetSkillInfoByValue(int SkillID, int SkillLevel, int SkillSubLevel)
{
	local SkillInfo a_SkillInfo;

	GetSkillInfo(SkillID, SkillLevel, SkillSubLevel, a_SkillInfo);
	return a_SkillInfo;
}

function int GetTextSizeWidth(string targetString, optional string FontName)
{
	local int nWidth, nHeight;

	if((FontName == ""))
	{
		FontName = "GameDefault";
	}
	GetTextSize(targetString, FontName, nWidth, nHeight);
	return nWidth;
}

function int GetTextSizeHeight(string targetString, optional string FontName)
{
	local int nWidth, nHeight;

	if((FontName == ""))
	{
		FontName = "GameDefault";
	}
	GetTextSize(targetString, FontName, nWidth, nHeight);
	return nHeight;
}

function DrawPanelArray(DrawPanelHandle drawPanel, out array<DrawItemInfo> drawListArr, optional bool bClear)
{
	local int i;

	if(bClear)
	{
		drawPanel.Clear();
	}
	i = 0;
	while((i < drawListArr.Length))
	{
		drawPanel.InsertDrawItem(drawListArr[i]);
		i++;
	}
	return;
}

function DrawPanelArrayFixedWidth(DrawPanelHandle drawPanel, out array<DrawItemInfo> drawListArr, optional bool bClear, optional int fixedWidth)
{
	local int i, nH;

	if(bClear)
	{
		drawPanel.Clear();
	}
	if((fixedWidth <= 0))
	{
		drawPanel.GetWindowSize(fixedWidth, nH);
	}
	drawPanel.InsertDrawItem(addDrawItemTextureCustom("L2UI_CT1.EmptyBtn", false, true, 0, 0, fixedWidth, 1, 1, 1));
	drawPanel.InsertDrawItem(addDrawItemBlank(0));
	i = 0;
	while((i < drawListArr.Length))
	{
		drawPanel.InsertDrawItem(drawListArr[i]);
		i++;
	}
	return;
}

function MoveRowData(RichListCtrlHandle tlist, int fromIndex, int toIndex)
{
	local RichListCtrlRowData rowData;

	if((fromIndex == toIndex))
	{
		return;
	}
	tlist.GetRec(fromIndex, rowData);
	if((fromIndex < toIndex))
	{
		InsertRowData(tlist, rowData, toIndex);
		tlist.DeleteRecord(fromIndex);
	}
	else
	{
		tlist.DeleteRecord(fromIndex);
		InsertRowData(tlist, rowData, toIndex);
	}
	return;
}

function InsertRowData(RichListCtrlHandle tlist, RichListCtrlRowData rowDataNew, int Index)
{
	local int i, lastIndex, SelectedIndex;
	local RichListCtrlRowData rowData;

	if((tlist.GetRecordCount() == 0))
	{
		tlist.InsertRecord(rowDataNew);
	}
	else
	{
		SelectedIndex = tlist.GetSelectedIndex();
		lastIndex = (tlist.GetRecordCount() - 1);
		tlist.GetRec(lastIndex, rowData);
		tlist.InsertRecord(rowData);
		i = lastIndex;
		while((i > Index))
		{
			tlist.GetRec((i - 1), rowData);
			tlist.ModifyRecord(i, rowData);
			i--;
		}
		tlist.ModifyRecord(Index, rowDataNew);
		if((Index <= SelectedIndex))
		{
			tlist.SetSelectedIndex((SelectedIndex + 1), false);
		}
	}
	return;
}

function _ModifyRowData(RichListCtrlHandle tlist, RichListCtrlRowData rowDataNew, int Index)
{
	local int i, lastIndex, SelectedIndex;
	local array<RichListCtrlRowData> rowdatas;

	SelectedIndex = tlist.GetSelectedIndex();
	lastIndex = (tlist.GetRecordCount() - 1);
	rowdatas.Length = (lastIndex - Index);
	i = 0;
	while((i < rowdatas.Length))
	{
		tlist.GetRec((lastIndex - i), rowdatas[i]);
		tlist.DeleteRecord((lastIndex - i));
		i++;
	}
	tlist.DeleteRecord(Index);
	tlist.InsertRecord(rowDataNew);
	if((Index <= SelectedIndex))
	{
		tlist.SetSelectedIndex((SelectedIndex + 1), false);
	}
	return;
}

function GetLocalPosition(WindowHandle W, out int X, out int Y)
{
	local Rect rectWnd, rectWndParent;

	rectWnd = W.GetRect();
	if((W.m_pTargetWnd == none))
	{
		X = rectWnd.nX;
		Y = rectWnd.nY;
		return;
	}
	rectWndParent = W.GetParentWindowHandle().GetRect();
	X = (rectWnd.nX - rectWndParent.nX);
	Y = (rectWnd.nY - rectWndParent.nY);
	return;
}

function Local2Global(WindowHandle W, int locX, int locY, out int GlobalX, out int GlobalY)
{
	local Rect rectWnd;

	rectWnd = W.GetRect();
	GlobalX = (rectWnd.nX + locX);
	GlobalY = (rectWnd.nY + locY);
	return;
}

function Global2Local(WindowHandle W, int GlobalX, int GlobalY, out int locX, out int locY)
{
	local Rect rectWnd;

	rectWnd = W.GetRect();
	locX = (GlobalX - rectWnd.nX);
	locY = (GlobalY - rectWnd.nY);
	return;
}

function bool IsGamePointType(int nItemClassID)
{
	switch(nItemClassID)
	{
		case 15623:
		case 15624:
		case 82500:
		case 15626:
		case 15627:
		case 47130:
		case 82621:
		case 82499:
		case 82659:
		case 15426:
		case 92482:
		case 97224:
			return true;
		default:
			return false;
	}
}

function string _GetOverlayTexName(int ClassID)
{
	switch(ClassID)
	{
		case 92314:
			return "L2UI_NewTex.NeedItemSelect.Bg_Purple";
		case 91663:
		case 48472:
			return "L2UI_NewTex.NeedItemSelect.Bg_Gold";
		case 97145:
			return "L2UI_NewTex.NeedItemSelect.Bg_Green";
		case 57:
			return "L2UI_NewTex.NeedItemSelect.Bg_Brown";
		default:
			return "";
	}
}

function int GetRefineryGradeQuality(int op1, int op2, int op3)
{
	local int Quality, op2quality, op3quality;

	op2quality = Class'NWindow.UIDATA_REFINERYOPTION'.static.GetQuality(op2);
	if((op2quality < 0))
	{
		op2quality = 0;
	}
	op3quality = Class'NWindow.UIDATA_REFINERYOPTION'.static.GetQuality(op3);
	if((op3quality < 0))
	{
		op3quality = 0;
	}
	Quality = int(Class'NWindow.RefineryAPI'.static.GetThemeColorLevel(byte(Class'NWindow.UIDATA_REFINERYOPTION'.static.GetQuality(op1)), byte(op2quality), byte(op3quality)));
	if((Quality == 0))
	{
		Quality = 1;
	}
	return Quality;
}

function int GetRefineryEffectLevel(int op1, int op2, int op3)
{
	local int effectLevel;

	effectLevel = int(Class'NWindow.RefineryAPI'.static.GetEffectLevel(byte(Class'NWindow.UIDATA_REFINERYOPTION'.static.GetQuality(op1)), byte(Class'NWindow.UIDATA_REFINERYOPTION'.static.GetQuality(op2)), byte(Class'NWindow.UIDATA_REFINERYOPTION'.static.GetQuality(op3))));
	return effectLevel;
}

function AddSystemMessageMakeFullSystemMsg(int nSystemMessage)
{
	getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemMessage(nSystemMessage), ""));
	AddSystemMessageString(MakeFullSystemMsg(GetSystemMessage(nSystemMessage), ""));
	return;
}

event OnSetFocus(WindowHandle focusedWnd, bool bFocused)
{
	if(Class'Interface.DialogBox'.static.Inst()._ChkFocus(m_hOwnerWnd, bFocused))
	{
		return;
	}
	if(UICommonAPI(m_hOwnerWnd.GetTopFrameWnd().GetScript()).UIControlDialogChkFocus(bFocused))
	{
		return;
	}
	return;
}

function bool UIControlDialogChkFocus(bool bFocused)
{
	local int i;

	i = 0;
	while((i < uicontrolDialogs.Length))
	{
		if(uicontrolDialogs[i]._ChkFocus(bFocused))
		{
			return true;
		}
		i++;
	}
	return false;
}

function _AddUIControlDialog(UIControlDialogAssets Asset)
{
	uicontrolDialogs[uicontrolDialogs.Length] = Asset;
	return;
}

function bool isDamagedItem(ItemInfo Info)
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		if((Info.Damaged == -1))
		{
			return true;
		}
	}
	return false;
}

function bool isDamaged(int nDamaged)
{
	if(getInstanceUIData().GetIsClassicServer())
	{
		if((nDamaged == -1))
		{
			return true;
		}
	}
	return false;
}

function INT64 GetInventoryItemCountFilter(int ClassID)
{
	local array<ItemInfo> needItems, needItemFiltered;
	local int i;

	if((Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(ClassID, needItems) == 0))
	{
		return INT64(0);
	}
	if(IsStackableItem(GetItemInfoByClassID(ClassID).ConsumeType))
	{
		return needItems[0].ItemNum;
	}
	i = 0;
	while((i < needItems.Length))
	{
		if((needItems[i].Id.ClassID == ClassID))
		{
			if((isDamagedItem(needItems[i]) == false))
			{
				needItemFiltered[needItemFiltered.Length] = needItems[i];
			}
		}
		i++;
	}
	return INT64(needItemFiltered.Length);
}

function INT64 FindItemByClassIDFilter(int ClassID, out array<ItemInfo> needItemFiltered)
{
	local array<ItemInfo> needItems;
	local int i;

	if((Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(ClassID, needItems) == 0))
	{
		return INT64(0);
	}
	i = 0;
	while((i < needItems.Length))
	{
		if((needItems[i].Id.ClassID == ClassID))
		{
			if((isDamagedItem(needItems[i]) == false))
			{
				needItemFiltered[needItemFiltered.Length] = needItems[i];
			}
		}
		i++;
	}
	if(IsStackableItem(GetItemInfoByClassID(ClassID).ConsumeType))
	{
		return needItems[0].ItemNum;
	}
	return INT64(needItemFiltered.Length);
}

function string RemoveCommasFromNumberString(string NumberString)
{
	NumberString = Substitute(NumberString, ",", "", false);
	if((INT64(NumberString) >= INT64(0)))
	{
		return NumberString;
	}
	else
	{
		return "";
	}
}

function INT64 RemoveCommasFromNumberInt64(string NumberString)
{
	NumberString = Substitute(NumberString, ",", "", false);
	if((INT64(NumberString) >= INT64(0)))
	{
		return INT64(NumberString);
	}
	else
	{
		return INT64(0);
	}
}
