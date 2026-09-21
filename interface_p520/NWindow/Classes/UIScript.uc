class UIScript extends UIEventManager;

enum EventNotificationCondition
{
	NotifyEvent_Always,             // 0
	NotifyEvent_Visible             // 1
};

enum PawnType
{
	PT_NONE,                        // 0
	PT_NPC,                         // 1
	PT_PC,                          // 2
	PT_PET                          // 3
};

enum EDialogType
{
	DialogType_OKCancel,            // 0
	DialogType_OK,                  // 1
	DialogType_OKCancelInput,       // 2
	DialogType_OKInput,             // 3
	DialogType_Warning,             // 4
	DialogType_Notice,              // 5
	DialogType_NumberPad,           // 6
	DialogType_Progress,            // 7
	DialogType_NumberPad2,          // 8
	DialogType_NumberPadAdena       // 9
};

enum EDialogModalType
{
	DialogModalType_Modal,          // 0
	DialogModalType_Modalless       // 1
};

enum DialogDefaultAction
{
	EDefaultNone,                   // 0
	EDefaultOK,                     // 1
	EDefaultCancel                  // 2
};

enum DialogEnterAction
{
	EEnterNone,                     // 0
	EEnterOK,                       // 1
	EEnterCancel,                   // 2
	EEnterDoNothing                 // 3
};

enum PetitionMethod
{
	PetitionMethod_Default,         // 0
	PetitionMethod_New,             // 1
	PetitionMethod_Web              // 2
};

enum ReleaseMode
{
	RM_DEV,                         // 0
	RM_RC,                          // 1
	RM_TEST,                        // 2
	RM_LIVE                         // 3
};

enum ESoundType
{
	SOUND_Ambient,                  // 0
	SOUND_Effect,                   // 1
	SOUND_Music,                    // 2
	SOUND_SystemVoice,              // 3
	SOUND_NPCVoice,                 // 4
	SOUND_NotifySound,              // 5
	SOUND_MainVolume                // 6
};

enum CollectionRegistFailReason
{
	CRFR_None,                      // 0
	CRFR_UnderNeedEnchant,          // 1
	CRFR_HaveNotEnoughItem,         // 2
	CRFR_OverNeedEnchant            // 3
};

var WindowHandle m_hOwnerWnd;
var bool m_bCreated;
var bool m_bCreatedByXmlData;

native function bool IsPKMode();

native function bool IsFullScreen();

native function RequestExit();

native function RequestAuthCardKeyLogin(int uid, string Value);

native function RequestSelfTarget();

native function RequestTargetCancel();

native function RequestSkillList();

native function RequestRaidRecord();

native function RequestTradeDone(bool bDone);

native function RequestStartTrade(int targetID);

native function RequestAddTradeItem(UIEventManager.ItemID sID, INT64 Num);

native function AnswerTradeRequest(bool bOK);

native function RequestSellItem(string param);

native function RequestBuyItem(string param);

native function NotifyFriendRejectState();

native function RequestBuySeed(string param);

native function RequestSetSeed(string param);

native function RequestSetCrop(string param);

native function RequestAttack(int ServerID, Vector Loc);

native function RequestAction(int ServerID, Vector Loc);

native function RequestAssist(int ServerID, Vector Loc);

native function RequestTargetUser(int ServerID);

native function RequestReTargetUser(int ServerID);

native function RequestWarehouseDeposit(string param);

native function RequestWarehouseWithdraw(string param);

native function RequestChangePetName(string Name);

native function RequestPackageSendableItemList(int targetID);

native function RequestPackageSend(string param);

native function RequestPreviewItem(string param);

native function RequestBBSBoard();

native function RequestMultiSellChoose(string param);

native function RequestRestartPoint(UIEventManager.RestartPoint eType, int nCostItemClassID, int nCostItemAmount);

native function BR_RequestRestartPoint(int Type, optional int NpcItem);

native function RequestUseItem(UIEventManager.ItemID sID);

native function RequestDestroyItem(UIEventManager.ItemID sID, INT64 Num);

native function RequestDropItem(UIEventManager.ItemID sID, INT64 Num, Vector Location);

native function RequestUnequipItem(UIEventManager.ItemID sID, INT64 SlotBitType);

native function RequestCrystallizeItem(UIEventManager.ItemID sID, INT64 Number);

native function RequestCrystallizeItemCancel();

native function RequestItemList();

native function RequestDuelStart(string sTargetName, int duelType);

native function RequestDuelAnswerStart(int duelType, int Option, int answer);

native function RequestDuelSurrender();

native function RequestDispel(int ServerID, UIEventManager.ItemID sID, int SkillLevel, int SkillSubLevel);

native function RequestQuitPrivateShop(string Type);

native function SendPrivateShopList(string Type, string param);

native function int GetPartyMemberCount();

native function bool GetPartyMemberLocation(int a_PartyMemberIndex, out Vector a_Location);

native function bool GetPartyMemberLocationWithID(int a_PartyMemberSID, out Vector a_Location);

native function byte GetPartyMemberMaxCount();

native function RequestClanMemberInfo(int Type, string Name);

native function RequestClanGradeList();

native function RequestClanChangeGrade(string sName, int Grade);

native function RequestClanAssignPupil(string sMaster, string sPupil);

native function RequestClanDeletePupil(string sMaster, string sPupil);

native function RequestClanLeave(string ClanName, int clanType);

native function RequestClanExpelMember(int clanType, string sName);

native function RequestClanAskJoin(int Id, int clanType);

native function RequestClanAskJoinByName(string sName, int clanType);

native function RequestClanDeclareWar();

native function RequestClanDeclareWarWithUserID(int Id);

native function RequestClanDeclareWarWithClanName(string sName);

native function RequestClanWithdrawWar();

native function RequestClanWithdrawWarWithClanName(string sClanName);

native function RequestClanReorganizeMember(int Type, string memberName, int clanType, string targetMemberName);

native function bool RequestClanRegisterCrestByFilePath(string filePath);

native function RequestClanRegisterCrest();

native function RequestClanUnregisterCrest();

native function bool RequestClanRegisterEmblemByFilePath(string filePath);

native function RequestClanRegisterEmblem();

native function RequestClanUnregisterEmblem();

native function bool RequestAllianceRegisterCrestByFilePath(string filePath);

native function RequestClanChangeNickName(string sName, string sNickName);

native function RequestClanWarList(int Page, int State);

native function RequestClanAuth(int gradeID);

native function RequestEditClanAuth(int gradeID, array<int> powers);

native function RequestClanMemberAuth(int clanType, string sName);

native function RequestPCCafeCouponUse(string a_CouponKey);

native function string GetCastleName(int castleID);

native function int GetCastleRegionID(int castleID);

native function string GetCastleLocationName(int castleID);

native function bool HasClanCrest();

native function bool HasClanEmblem();

native function RequestInvitePartyByTargetID(int targetID);

native function RequestInviteParty(string sName);

native function RequestInviteMpcc(string Name);

native final function string GetClassType(int ClassID);

native final function UIEventManager.EClassIconType GetClassIndex(int ClassID);

native function int GetClassLevel(int ClassID);

native function UIEventManager.EClassRoleType GetClassRoleType(int ClassID);

native final function string GetClassRoleName(int ClassID);

native final function string GetClassRoleNameByRole(int ClassRole);

native final function int GetClassTransferDegree(int ClassID);

native function string GetPlayerRealName();

native function bool GetPlayerInfo(out UIEventManager.UserInfo a_UserInfo);

native function bool GetTargetInfo(out UIEventManager.UserInfo a_UserInfo);

native function bool GetUserInfo(int UserID, out UIEventManager.UserInfo a_UserInfo);

native function bool GetPetInfo(out UIEventManager.PetInfo a_PetInfo);

native function bool GetSummonInfo(int ServerID, out UIEventManager.SummonInfo a_SummonInfo);

native function GetSummonPoint(out int nSummonedPoint, out int nSummonablePoint);

native function bool GetSkillInfo(int a_SkillID, int a_SkillLevel, int a_SkillSubLevel, out UIEventManager.SkillInfo a_SkillInfo);

native function bool GetSkillInfo_WRF(int a_SkillID, int a_SkillLevel, int a_SkillSubLevel, int a_rank, string a_name, out UIEventManager.SkillInfo a_SkillInfo);

native function bool GetAccessoryItemID(out UIEventManager.ItemID a_LEar, out UIEventManager.ItemID a_REar, out UIEventManager.ItemID a_LFinger, out UIEventManager.ItemID a_RFinger);

native function int GetDecoIndex(UIEventManager.ItemID DecoID);

native function int GetJewelIndex(UIEventManager.ItemID JewelID);

native function int GetAgathionIndex(UIEventManager.ItemID AgathionID);

native function int GetClassStep(int a_ClassID);

native function bool IsBuilderPC();

native function bool IsPlayerStand();

native function int GetArtifactIndex(UIEventManager.ItemID ArtifactID);

native function string GetClanName(int clanID);

native final function int GetClanNameValue(int iClanID);

native final function INT64 GetAdena();

native final function string GetAdenaStr();

native final function int GetTeleportBookMarkCount();

native final function int GetTeleportFlagCount();

native function bool GetPartyMemberInfo(int UserID, out UIEventManager.PartyMemberInfo PartyMemberInfo);

native function bool GetPartyMemberPetInfo(int UserID, out UIEventManager.PartyMemberPetInfo PartyMemberPetInfo);

native function bool GetPartyMemberSummonedInfo(int UserID, int summonedID, out UIEventManager.PartyMemberSummonedInfo PartyMemberSummonedInfo);

native final function string MakeBuffTimeStr(int Time);

native final function string MakeToppingBuffTimeStr(int Time);

native final function string MakeTimeStr(int Time);

native final function string GetTimeString();

native static function float GetAppSeconds();

native static function INT64 GetAppMilliSeconds();

native final function GetTimeStruct(int IntTime, out UIEventManager.L2UITime UITimeStruct);

native final function GetTimeStructGMT(int IntTime, out UIEventManager.L2UITime UITimeStruct);

native final function string ConvertTimetoStr(int Time);

native final function Debug(string strMsg);

native final function bool IsKeyDown(Interactions.EInputKey Key);

native final function string GetSystemString(int Id);

native final function string GetSystemMessage(int Id);

native final function GetSystemMsgInfo(int Id, out SystemMsgData SysMsgData);

native final function string GetSystemMessageWithParamNumber(int Id, int param);

native final function string GetNpcString(int Id);

native static function UIScript GetScript(string Window);

native final function string MakeFullSystemMsg(string sMsg, string sArg1, optional string sArg2, optional string sArg3, optional string sArg4, optional string sArg5);

native final function GetTextSizeDefault(string strInput, out int nWidth, out int nHeight);

native final function GetTextSize(string strInput, string sFontName, out int nWidth, out int nHeight);

native final function string DivideStringWithWidth(string strInput, int nWidth);

native final function string NextStringWithWidth(int nWidth);

native final function string MakeFullItemName(int Id);

native final function string GetItemGradeString(int nCrystalType);

native final function string GetItemGradeTextureName(int nCrystalType);

native final function string MakeCostStringINT64(INT64 a_Input);

native final function string MakeCostString(string strInput);

native final function string ConvertNumToText(string strInput);

native final function string ConvertNumToTextNoAdena(string strInput);

native final function string CeilingNum(string strInput, int positionalNum);

native final function string ConvertTimeToString(float Time);

native final function PlayConsoleSound(UIEventManager.EInterfaceSoundType eType);

native final function UIEventManager.EIMEType GetCurrentIMELang();

native final function Texture GetPledgeCrestTexFromPledgeCrestID(int PledgeCrestID);

native final function Texture GetAllianceCrestTexFromAllianceCrestID(int AllianceCrestID);

native final function RequestBypassToServer(string strPass);

native final function string GetUserRankString(int Rank);

native final function string GetRoutingString(int RoutingType);

native final function int GetDebuffType(UIEventManager.ItemID cID, int SkillLevel, int SkillSubLevel);

native final function int GetIsMagic(UIEventManager.ItemID cID, int SkillLevel, int SkillSubLevel);

native final function bool IsSongDance(UIEventManager.ItemID cID, int SkillLevel, int SkillSubLevel);

native final function bool IsIconHide(UIEventManager.ItemID cID, int SkillLevel, int SkillSubLevel);

native final function bool IsTriggerSkill(UIEventManager.ItemID cID, int SkillLevel, int SkillSubLevel);

native final function bool CheckItemLimit(UIEventManager.ItemID cID, INT64 Count);

native function Vector GetClickLocation();

native function string GetPcCafeItemIconPackageName(optional bool bSmall);

native final function GetCurrentResolution(out int ScreenWidth, out int ScreenHeight);

native final function int GetMaxLevel();

native function SetPrivateShopMessage(string Type, string Message);

native function string GetPrivateShopMessage(string Type);

native final function AddSystemMessage(int Index);

native final function AddSystemMessageString(string Msg);

native final function AddSystemMessageParam(string strParam);

native final function string EndSystemMessageParam(int MsgNum, bool bGetMsg);

native final function ExecRestart();

native final function ExecQuit();

native final function UIEventManager.EServerAgeLimit GetServerAgeLimit();

native final function int GetServerNo();

native final function bool CanUseAudio();

native final function bool CanUseJoystick();

native final function bool CanUseHDR();

native final function bool IsEnableEngSelection();

native final function UIEventManager.ELanguageType GetLanguage();

native final function int GetLanguageCustom();

native final function GetResolutionList(out array<UIEventManager.ResolutionInfo> a_ResolutionList);

native final function GetRefreshRateList(out array<int> a_RefreshRateList, optional int a_nWidth, optional int a_nHeight);

native final function SetResolution(int a_nResolutionIndex, int a_nRefreshRateIndex);

native final function int GetMultiSample();

native final function int GetResolutionIndex();

native final function GetShaderVersion(out int a_nPixelShaderVersion, out int a_nVertexShaderVersion);

native final function SetDefaultPosition();

native final function SetTextureDetail(int a_nTextureDetail);

native final function SetModelingDetail(int a_nModelingDetail);

native final function SetMotionDetail(int a_nMotionDetail);

native final function SetEffectDetail(int Detail);

native final function SetShadow(bool a_bShadow);

native final function SetBackgroundEffect(bool a_bBackgroundEffect);

native final function SetTerrainClippingRange(int a_nTerrainClippingRange);

native final function SetPawnClippingRange(int a_nPawnClippingRange);

native final function SetReflectionEffect(int a_nReflectionEffect);

native final function SetAntialiasing(int a_nAntialiasing);

native final function SetYebisAntialiasing(bool a_bYebisAntialiasing);

native final function SetHDR(int a_nHDR);

native final function SetWeatherEffect(int a_nWeatherEffect);

native final function SetL2Shader(bool a_bShader);

native final function SetDOF(bool a_bDof);

native final function SetYebisDOF(bool a_bYebisDof);

native final function SetYebisGlow(int a_nYebisGlow);

native final function SetDepthBufferShadow(bool a_bShadow);

native final function SetShaderWaterEffect(bool a_bWater);

native final function SetRenderCharacterCount(int a_NewLimitAcotor);

native final function SetIgnorePartyInviting(bool a_bIgnore);

native final function SetIgnoreFriendInviting(bool a_bIgnore);

native final function SetFixedDefaultCamera(bool a_bFixed);

native final function SetOutline(bool a_bOutline);

native final function bool CanUseSystemDPIScaling();

native final function ChangeLanguage(int LangType);

native final function string GetLocalizedL2TextPathNameUC();

native final function ExecuteCommand(string a_strCmd);

native final function ExecuteCommandFromAction(string strCmd, optional string param);

native final function DoAction(UIEventManager.ItemID cID);

native final function UseSkill(UIEventManager.ItemID cID, int ShortcutType);

native final function bool IsStackableItem(int ConsumeType);

native final function StopMacro();

native final function SetOptionBool(string a_strSection, string a_strName, bool a_bValue);

native final function SetOptionInt(string a_strSection, string a_strName, int a_nValue);

native final function SetOptionFloat(string a_strSection, string a_strName, float a_fValue);

native final function SetOptionString(string a_strSection, string a_strName, string a_strValue);

native final function bool GetOptionBool(string a_strSection, string a_strName);

native final function int GetOptionInt(string a_strSection, string a_strName);

native final function float GetOptionFloat(string a_strSection, string a_strName);

native final function string GetOptionString(string a_strSection, string a_strName);

native final function SetChatFilterBool(string a_strSection, string a_strName, bool a_bValue);

native final function bool GetChatFilterBool(string a_strSection, string a_strName);

native final function ApplyOptionToDamageText();

native final function SendWindowsInfo();

native final function INT64 GetInventoryItemCount(UIEventManager.ItemID cID);

native final function string GetSlotTypeString(int ItemType, INT64 SlotBitType, int ArmorType);

native final function string GetWeaponTypeString(int WeaponType);

native final function string GetAttackSpeedString(int AttackSpeed);

native final function float GetSoulShotPower(int CrystalType, int Enchanted, int WeaponType, bool magicWeapon);

native final function float GetSpiritShotPower(int CrystalType, int Enchanted, int WeaponType, bool magicWeapon);

native final function bool IsMagicalArmor(UIEventManager.ItemID cID);

native final function bool IsSigilArmor(UIEventManager.ItemID Id);

native final function string GetLottoString(int nLookChangeItemID);

native final function string GetRaceTicketString(int Blessed);

native final function RequestSaveInventoryOrder(array<UIEventManager.ItemID> a_IDList, array<int> a_OrderList);

native final function RefreshINI(string a_INIFileName);

native final function bool GetINIBool(string section, string Key, out int Value, string file);

native final function bool GetINIInt(string section, string Key, out int Value, string file);

native final function bool GetINIFloat(string section, string Key, out float Value, string file);

native final function bool GetINIString(string section, string Key, out string Value, string file);

native final function SetINIBool(string section, string Key, bool Value, string file);

native final function SetINIInt(string section, string Key, int Value, string file);

native final function SetINIFloat(string section, string Key, float Value, string file);

native final function SetINIString(string section, string Key, string Value, string file);

native final function RemoveINI(string section, string Key, string file);

native final function SaveINI(string file);

native final function bool GetConstantInt(int a_nID, out int a_nValue);

native final function bool GetConstantString(int a_nID, out string a_strValue);

native final function bool GetConstantBool(int a_nID, out int a_bValue);

native final function bool GetConstantFloat(int a_nID, out float a_fValue);

native final function SetSoundVolume(float a_fVolume);

native final function SetEffectVolume(float a_fVolume);

native final function SetAmbientVolume(float a_fVolume);

native final function SetMusicVolume(float a_fVolume);

native final function SetNpcVoiceVolume(float a_fVolume);

native final function SetSystemVoiceVolume(float a_fVolume);

native final function float GetMusicVolume();

native final function TutorialVoiceOff();

native final function TutorialVoiceOn();

native final function float GetVolumeScale(ESoundType a_nType);

native final function ReturnTooltipInfo(UIEventManager.CustomTooltip Info);

native final function bool GetItemKeepSelectInfo(UIEventManager.ItemID a_ID, out UIEventManager.KeepSelectInfo Info);

native final function bool GetItemTextSectionInfos(string FormatText, out string FullText, out array<UIEventManager.TextSectionInfo> TextInfos);

native final function ReturnShowXMLDetailTooltip(bool a_bShow);

native final function SetShowCompareTooltipOnWorldExchange(bool a_bHide);

native final function SetItemTextLink(UIEventManager.ItemID a_ID, string a_ItemName, Color a_Color, int a_NameLen, int a_Enchant);

native final function RequestShowVisionMovie();

native final function RequestCallToChangeClass();

native final function RequestChangeToAwakenedClass(int bYes);

event OnLoad()
{
	return;
}

event OnTick()
{
	return;
}

event OnShow()
{
	return;
}

event OnHide()
{
	return;
}

event OnEvent(int a_EventID, string a_Param)
{
	return;
}

event OnEventWithParamMap(int a_EventID, ParamMap a_ParamMap)
{
	return;
}

event OnTimer(int TimerID)
{
	return;
}

event OnMinimize()
{
	return;
}

event OnEnterState(name a_PreStateName)
{
	return;
}

event OnExitState(name a_NextStateName)
{
	return;
}

event OnSendPacketWhenHiding()
{
	return;
}

event OnDefaultPosition()
{
	return;
}

event OnDrawerShowFinished()
{
	return;
}

event OnDrawerHideFinished()
{
	return;
}

event OnRegisterEvent()
{
	return;
}

event OnSetFocus(WindowHandle a_WindowHandle, bool bFocused)
{
	return;
}

event bool OnKeyDown(WindowHandle a_WindowHandle, Interactions.EInputKey Key)
{

}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey Key)
{

}

event OnReceivedCloseUI()
{
	return;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	return;
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	return;
}

event OnLButtonDblClick(WindowHandle a_WindowHandle, int X, int Y)
{
	return;
}

event OnRButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	return;
}

event OnRButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	return;
}

event OnRButtonDblClick(WindowHandle a_WindowHandle, int X, int Y)
{
	return;
}

event OnMButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
	return;
}

event OnMButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
	return;
}

event OnMouseOver(WindowHandle a_WindowHandle)
{
	return;
}

event OnMouseOut(WindowHandle a_WindowHandle)
{
	return;
}

event OnMouseMove(WindowHandle a_WindowHandle, int X, int Y)
{
	return;
}

event OnDropItem(string strID, UIEventManager.ItemInfo infItem, int X, int Y)
{
	return;
}

event OnDragItemStart(string strID, UIEventManager.ItemInfo infItem)
{
	return;
}

event OnDragItemEnd(string strID)
{
	return;
}

event OnDragItemStartTiny(string strID, UIEventManager.ItemInfo infItem)
{
	return;
}

event OnDropItemSource(string strTarget, UIEventManager.ItemInfo infItem)
{
	return;
}

event OnDropItemWithHandle(WindowHandle hTarget, UIEventManager.ItemInfo infItem, int X, int Y)
{
	return;
}

event OnDropWnd(WindowHandle hTarget, WindowHandle hDropWnd, int X, int Y)
{
	return;
}

event OnClickButton(string strID)
{
	return;
}

event OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	return;
}

event OnRClickButton(string strID)
{
	return;
}

event OnRClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
	return;
}

event OnButtonTimer(bool bExpired)
{
	return;
}

event OnTabSplit(string sName)
{
	return;
}

event OnTabMerge(string sName)
{
	return;
}

event OnCompleteEditBox(string strID)
{
	return;
}

event OnChangeEditBox(string strID)
{
	return;
}

event OnChatMarkedEditBox(string strID)
{
	return;
}

event OnClickListCtrlRecord(string strID)
{
	return;
}

event OnDBClickListCtrlRecord(string strID)
{
	return;
}

event OnRClickListCtrlRecord(string strID)
{
	return;
}

event OnRollOverListCtrlRecord(string strID, int Index)
{
	return;
}

event OnClickRichListButton(WindowHandle a_WindowHandle, int X, int Y)
{
	return;
}

event OnClickHeaderCtrl(string strID, int Index)
{
	return;
}

event OnLButtonClickListBoxItem(string strID, int SelectedIndex)
{
	return;
}

event OnRButtonClickListBoxItem(string strID, int SelectedIndex)
{
	return;
}

event OnDBClickListBoxItem(string strID, int SelectedIndex)
{
	return;
}

event OnClickCheckBox(string strID)
{
	return;
}

event OnCilckCheckBoxWithHandle(CheckBoxHandle a_CheckBoxHandle)
{
	return;
}

event OnClickItem(string strID, int Index)
{
	return;
}

event OnDBClickItem(string strID, int Index)
{
	return;
}

event OnRClickItem(string strID, int Index)
{
	return;
}

event OnRDBClickItem(string strID, int Index)
{
	return;
}

event OnRClickItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
	return;
}

event OnDBClickItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
	return;
}

event OnSelectItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
	return;
}

event OnProgressTimeUp(string strID)
{
	return;
}

event OnComboBoxItemSelected(string strID, int Index)
{
	return;
}

event OnTextureAnimEnd(AnimTextureHandle a_AnimTextureHandle)
{
	return;
}

event OnPropertyControllerResize(PropertyControllerHandle a_PropertyHandle, int a_Height)
{
	return;
}

event OnHtmlMsgHideWindow(HtmlHandle a_HtmlHandle)
{
	return;
}

event OnFlashCtrlMsg(FlashCtrlHandle a_FlashCtrlHandle, string a_Param)
{
	return;
}

event OnCallUCFunction(string functionName, string param)
{
	return;
}

event OnScrollMove(string strID, int Position)
{
	return;
}

native final function PlaySound(string strSoundName);

native final function PlaySoundUntilEnd(string strSoundName);

native final function StopSound(string a_SoundName);

native final function RequestOpenMinimap();

event OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
	return;
}

event OnChangeScalableUI(int a_SizeType)
{
	return;
}

native final function string GetCurrentZoneName();

native final function int GetCurrentZoneID();

native final function string GetInZoneNameWithZoneID(int inzoneID);

native final function string GetZoneNameWithLocation(Vector Location);

native final function RequestHennaItemInfo(int iHennaID);

native final function RequestHennaItemList();

native final function RequestHennaEquip(int iHennaID);

native final function RequestHennaUnEquipInfo(int iHennaID);

native final function RequestHennaUnEquipList();

native final function RequestHennaUnEquip(int iHennaID);

native final function Vector GetPlayerPosition();

native final function Actor GetCharacterSelectionActor(int a_CharIndex);

native final function string GetSystemDir();

native final function GetFileList(out array<string> FileList, string strDir, string strExtention);

native final function GetDirList(out array<string> DirList, string strDir);

native final function BeginReplay(string strFileName, bool bLoadCameraInst, bool bLoadChatData);

native final function EraseReplayFile(string strFileName);

native final function BeginPlay();

native final function BeginBenchMark();

native final function RequestAcquireSkillInfo(int iID, int iLevel, int iSubLevel, int iType);

native final function RequestAcquireSkill(int iID, int iLevel, int iSubLevel, int iType);

native final function RequestAcquireSkillSubClan(int iID, int iLevel, int iType, int iSubClan);

native final function RequestExEnchantSkillInfo(int iID, int iLevel, int iSubLevel);

native final function RequestExEnchantSkillInfoDetail(int Type, int iID, int iLevel, int iSubLevel);

native final function RequestExEnchantSkill(int Type, int iID, int iLevel, int iSubLevel);

native final function RequestObserverModeEnd();

native final function WindowHandle GetHandle(string a_ControlID, optional WindowHandle a_ParentWnd, optional int a_CloneID);

native final function WindowHandle FindHandle(string a_ControlID, optional WindowHandle a_ParentWnd, optional int a_CloneID);

native final function AnimTextureHandle GetAnimTextureHandle(string a_ControlID);

native final function BarHandle GetBarHandle(string a_ControlID);

native final function ButtonHandle GetButtonHandle(string a_ControlID);

native final function ChatWindowHandle GetChatWindowHandle(string a_ControlID);

native final function CheckBoxHandle GetCheckBoxHandle(string a_ControlID);

native final function ComboBoxHandle GetComboBoxHandle(string a_ControlID);

native final function DrawPanelHandle GetDrawPanelHandle(string a_ControlID);

native final function EditBoxHandle GetEditBoxHandle(string a_ControlID);

native final function MultiEditBoxHandle GetMultiEditBoxHandle(string a_ControlID);

native final function HtmlHandle GetHtmlHandle(string a_ControlID);

native final function ItemWindowHandle GetItemWindowHandle(string a_ControlID);

native final function ListBoxHandle GetListBoxHandle(string a_ControlID);

native final function ListCtrlHandle GetListCtrlHandle(string a_ControlID);

native final function RichListCtrlHandle GetRichListCtrlHandle(string a_ControlID);

native final function MinimapCtrlHandle GetMinimapCtrlHandle(string a_ControlID);

native final function NameCtrlHandle GetNameCtrlHandle(string a_ControlID);

native final function ProgressCtrlHandle GetProgressCtrlHandle(string a_ControlID);

native final function PropertyControllerHandle GetPropertyControllerHandle(string a_ControlID);

native final function RadarMapCtrlHandle GetRadarMapCtrlHandle(string a_ControlID);

native final function SliderCtrlHandle GetSliderCtrlHandle(string a_ControlID);

native final function StatusBarHandle GetStatusBarHandle(string a_ControlID);

native final function StatusRoundHandle GetStatusRoundHandle(string a_ControlID);

native final function StatusIconHandle GetStatusIconHandle(string a_ControlID);

native final function TabHandle GetTabHandle(string a_ControlID);

native final function TextBoxHandle GetTextBoxHandle(string a_ControlID);

native final function TextListBoxHandle GetTextListBoxHandle(string a_ControlID);

native final function TextureHandle GetTextureHandle(string a_ControlID);

native final function TreeHandle GetTreeHandle(string a_ControlID);

native final function WindowHandle GetWindowHandle(string a_ControlID);

native final function EffectViewportWndHandle GetEffectViewportWndHandle(string a_ControlID);

native final function CharacterViewportWindowHandle GetCharacterViewportWindowHandle(string a_ControlID);

native final function SceneCameraCtrlHandle GetSceneCameraCtrlHandle(string a_ControlID);

native final function SceneCameraCtrlHandle GetSceneNpcCtrlHandle(string a_ControlID);

native final function SceneCameraCtrlHandle GetScenePcCtrlHandle(string a_ControlID);

native final function SceneCameraCtrlHandle GetSceneScreenCtrlHandle(string a_ControlID);

native final function SceneCameraCtrlHandle GetSceneMusicCtrlHandle(string a_ControlID);

native final function WebBrowserHandle GetWebBrowserHandle(string controlID);

native final function RequestProcureCropList(string param);

native final function int GetManorCount();

native final function int GetManorIDInManorList(int Index);

native final function string GetManorNameInManorList(int Index);

native final function bool GetQuestLocation(Vector Location);

native final function ShowMessageInLogin(string Message);

native final function InitCreditState();

native final function string GetInterfaceDir();

native final function string GetXMLControlString(UIEventManager.EXMLControlType Type);

native final function UIEventManager.EXMLControlType GetXMLControlIndex(string Type);

native final function ShowVirtualWindowBackground(bool bShow);

native final function ShowExampleAnimation(bool bShow);

native final function GetTrackerAttachedWindowList(array<WindowHandle> a_WindowList);

native final function WindowHandle GetTrackerAttachedWindow();

native final function ClearTracker();

native final function DeleteAttachedWindow();

native final function ExecuteAlign(UIEventManager.ETrackerAlignType Type);

native final function ShowEnableTrackerBox(bool bShow);

native final function CreateNewCharacter();

native final function GotoLogin();

native final function GotoServerList();

native final function StartGame(int SelectedCharacter);

native final function RequestCharacterSelect(int Index);

native function bool GetSelectedCharacterInfo(int Index, out UIEventManager.UserInfo a_UserInfo);

native final function RequestRestoreCharacter(int Index);

native final function RequestDeleteCharacter(int Index);

native final function ResetCharacterPosition();

native function bool IsScheduledToDeleteCharacter(int Index);

native function bool IsDisciplineCharacter(int Index);

native final function SetSelectedCharacter(int Index);

native function int GetTimeToDeleteCharacter(int Index);

native function int GetTimeToDisciplineCharacter(int Index);

native function int GetTimeToLastLogoutCharacter(int Index);

native function bool IsChangeMergedName(int Index);

native final function ShowChangeMergedNameDialogBox(int Type, int selectedCharacterIndex);

native function bool IsActivateCharacter(int Index);

native final function RequestCreateCharacter(string Name, int Race, int Job, int Sex, int HairType, int HairColor, int FaceType, UIEventManager.E_CHARACTER_COLOR eColor);

native final function RequestPrevState();

native final function SetDefaultCharacter();

native final function ClearDefaultCharacterInfo();

native final function ExecLobbyEvent(string EventName, optional bool bReverse);

native final function ExecLobbyNextEvent(string CurEventName, string NextEventName, optional bool bReverse);

native function string GetClassDescription(int Index);

native function array<int> GetClassInitialStat(int Index);

native final function ShowDefaultCharacter(int Index, optional bool bRaceChanged);

native final function SetCharacterStyle(int Index, int HairType, int HairColor, int FaceType);

native final function SetCharacterColor(UIEventManager.E_CHARACTER_COLOR eColor);

native final function DefaultCharacterMouseTurn(int Index, float ratio);

native final function DefaultCharacterTurn(int Index, float ratio);

native final function DefaultCharacterStop(int Index);

native function bool CheckNameLength(string Name);

native function bool CheckValidName(string Name);

native function int CharacterCreateGetClassType(int Race, int Job, int Sex);

native final function RequestAllCastleInfo();

native final function RequestAllFortressInfo();

native final function RequestAllAgitInfo();

native final function RequestFortressSiegeInfo();

native final function RequestFortressMapInfo(int FortressID);

native final function RequestPVPMatchRecord();

native final function RequestChangeNicknameNColor(int ColorIndex, string nickname, UIEventManager.ItemID Id);

native final function int GetMaxNicknameColorIndexCnt();

native final function Color GetNicknameColorWithIndex(int ColorIndex);

native final function RequestWithDrawPremiumItem(int Index, INT64 Amount);

native final function RequestStartShowCrataeCubeRank();

native final function RequestStopShowCrataeCubeRank();

native final function RequestJoinDominionWar(int DominionID, int Clan, int Join, int JoinID);

native final function RequestDominionInfo();

native final function Texture GetDominionFlagIconTex(int DominionID);

native function RequestRefundItem(string param);

native final function RequestSendPost(string receivedPerson, int safeMail, string Title, string contents, array<UIEventManager.RequestItem> itemIDList, INT64 nAdena);

native final function RequestRequestReceivedPostList();

native final function RequestDeleteReceivedPost(array<int> deleteMailList);

native final function RequestRequestReceivedPost(int mailID);

native final function RequestReceivePost(int mailID);

native final function RequestRejectPost(int mailID);

native final function RequestRequestSentPostList();

native final function RequestDeleteSentPost(array<int> deleteMailList);

native final function RequestRequestSentPost(int mailID);

native final function RequestCancelSentPost(int mailID);

native final function RequestPostItemList();

native final function RequestShowNewUserPetition();

native final function RequestShowStepTwo(int categoryId);

native final function RequestShowStepThree(int categoryId);

native final function bool GetUseNewPetitionBool();

native final function PetitionMethod GetPetitionMethod();

native final function RequestShowPetitionAsMethod();

native final function RequestBuySellUIClose();

native final function string GetGameStateName();

native function RequestBR_EventRankerList(int iEventID, int iDay, int iRanking);

native final function RequestCreateRainEffect(int imode, int iEmitterposition);

native final function RequestDeleteRainEffect();

native final function RequestSetWeatherEffect(int iType);

native final function RequestSetRainWeight(float fmul);

native final function RequestSetRainEmitterParticleNum(float fmul);

native final function RequestSetRainSpeed(float fmul);

native final function RequestSetRainMeshScale(Vector mul);

native final function RequestCreateSnowEffect(int imode, int iEmitterposition);

native final function RequestDeleteSnowEffect();

native final function RequestSetSnowWeight(float fmul);

native final function RequestSetSnowEmitterParticleNum(float fmul);

native final function RequestSetSnowSpeed(float fmul);

native final function RequestSetSnowMeshScale(Vector mul);

native final function RequestChangeParticleEmitter(string emitterName);

native final function RequestChangeDiamondMesh(string MeshName);

native final function ClearAllPrivateMarketInfo();

native final function RefreshPrivateMarketInfo();

native final function RequestMoveToMerchant(int merchantId);

native final function array<UIEventManager.FileNameInfo> GetFilesInfoList(string filePath, array<string> arrFilExt);

native final function array<UIEventManager.DriveInfo> GetDrivesInfoList();

native final function AnswerCoupleAction(int ActionID, int bOK, int requestUserID);

native final function string GetMydocumentPath();

native final function string GetDesktopPath();

native final function string GetMyComputerPath();

native final function RequestPartyLootingModify(int scheme);

native final function RequestPartyLootingModifyAgreement(int agree);

native final function RequestAskMemberShip();

native final function RequestAddExpandQuestAlarm(int QuestID);

native final function RadioButtonHandle GetRadioButtonHandle(string a_ControlID);

native final function OpenGivenURL(string URL);

native final function OpenL2Home();

native final function RequestSetYCbCrConversionEffect(bool Enable);

native final function RequestSetYCbCrVal(float fixCbCr, int PlayType, float yCOR1, float cbCOR1, float crCOR1, float yCOR2, float cbCOR2, float crCOR2, float YCbCrConsumingTime);

native final function RequestSetHSVConversionEffect(bool Enable);

native final function RequestSetHSVVal(float fixHS, int PlayType, float hCOR1, float sCOR1, float vCOR1, float hCOR2, float sCOR2, float vCOR2, float HSVConsumingTime);

native final function RequestSetRGBConversionEffect(bool Enable);

native final function RequestSetRGBVal(int PlayType, float rCOR1, float gCOR1, float bCOR1, float rCOR2, float gCOR2, float bCOR2, float RGBConsumingTime);

native final function RequestSetColorGradingEffect(bool Enable);

native final function RequestSetColorGradingVal(int PlayType, string COR1, string COR2, float RGBConsumingTime);

native final function RequestSetPostEffect(bool Enable, int PostEffectID);

native final function RequestPartyMatchWaitList(int a_Page, int a_MinLevel, int a_MaxLevel, int ClassRole, string Name);

native final function RequestMenteeWaitingList(int Page, int MinLevel, int MaxLevel);

native final function SetMotionBlurUse(bool bIsUse);

native final function SetMotionBlurAlpha(byte alphavalue);

native final function ToggleReplayRec();

native final function RequestFinishNPCZoomCamera();

native final function SetHDRRenderVal(float FinalCoef, float GrayLum, float ClampMin, float ClampMax);

native final function SetUseHDRRenderEffect(bool UseHDREffect);

native final function RequestNatureRenderTime(float Time);

native final function RequestNatureRenderIntensity(float Intensity);

native final function RequestNatureRenderRayleigh(float Rayleigh);

native final function RequestNatureRenderMie(float Mie);

native final function RequestNatureRenderTurbidity(float Turbidity);

native final function RequestNatureRenderDir(float Dir);

native final function RequestNatureRenderBlendingRate(float BlendingRate);

native final function int GetActivityUltimateSkillLevel();

native final function Texture GetTexture(string Name);

native function RequestBR_CashShopNewICon();

native function RequestBR_GamePoint();

native function RequestBR_ProductList(UIEventManager.EBR_CashShopProduct ProductType);

native function RequestBR_ProductInfo(int iProductID, bool bPresent);

native function RequestBR_BuyProduct(int iProductID, int iAmount);

native function RequestBR_RecentProductList();

native function RequestBR_AddBasketProductInfo(int iProductID);

native function RequestBR_DeleteBasketProductInfo(int iProductID);

native function RequestBR_PresentBuyProduct(int iProductID, int iAmount, string strCharname, string strContent);

native function bool IsBr_CashShopCateory();

native function bool RequestBr_CashShopCateoryIndex();

native function bool IsBr_CashShopPresent();

native function bool IsBr_CashShopCoinToMoney();

native function float GetBr_CashShopCoinToMoneyValue();

native function bool IsBr_CashShopMainDisable();

native function RequestBR_MinigameLoadScores();

native function RequestBR_MinigameInsertScore(int iScore);

native function ShowCashChargeWebSite();

native function IsUsingPrimeShop();

native function int BR_GetShowEventUI();

native final function string BR_ConvertTimeToStr(int Time, int bOnlyDay);

native final function int BR_GetDayType(int Time, int Type);

native final function string GetFormattedTimeStrMMHH(int Hour, int Minute);

native final function RequestGoodsInventoryItemList();

native final function RequestGoodsInventoryItemDesc(int Index);

native final function RequestUseGoodsInventoryItem(int Index);

native final function string GetGoodsIconName(int Index);

native final function bool IsUseGoodsInvnentory();

native final function RequestSecondaryAuthCreate(string Password);

native final function RequestSecondaryAuthVerify(string Password);

native final function RequestSecondaryAuthModify(string Password, string newPassword);

native final function bool IsUseSecondaryAuth();

native final function bool IsUseEMailAccount();

native final function RequestCharacterNameCreatable(string charName);

native final function RequestCrystallizeEstimate(UIEventManager.ItemID ItemID, INT64 ItemCount);

native final function GetShortcutString(int shortcutNum, out UIEventManager.ShortcutCommandItem commandItem);

native final function RequestPledgeWar(string PledgeName);

native final function RequestSurrenderPledgeWar(string sPledgeName);

native final function bool IsL2NetLoginState();

native final function bool GetDynamicContentInfo(int Id, int Step, out UIEventManager.DynamicContentInfo Info);

native final function RequestDynamicQuestProgressInfo(int Id, int Step);

native final function RequestDynamicQuestScoreInfo(int Id, int Step);

native final function RequestDynamicContentHtml(int Id, int Step);

native final function int GetSkillAvailability(int Id, int Level, int SubLevel);

native final function PawnType GetPawnType(int ServerID);

native final function string GetPawnNameFromServerID(int ServerID);

native final function Vector GetPawnLocFromServerID(int ServerID);

native final function RequestTutorialQuestionMarkPressed(int iQuestionID);

native final function RequestTutorialMarkPressed(int Type, int Id);

native final function RequestAutoLogin();

native final function bool IsNowMovieCapturing();

native final function SetMovieCaptureResolution(int W, int h);

native final function MovieCaptureToggle();

native final function SetMovieCaptureHighQuality();

native final function SetMovieCaptureLowQuality();

native final function OpenMovieCaptureDir();

native final function int GetDisplayHeight();

native final function int GetDisplayWidth();

native final function string GetL2Path();

native final function int GetMaxVitality();

native final function float ExpFloat(float A, int Exp);

native final function int ExpInt(int A, int Exp);

native final function RequestLogin(string s_ID, string s_PassWD, int s_NCOTP);

native final function RequestLoginServer(int ServerID);

native final function RequestSecurityCardLogin(string SecurityNum);

native final function RequestGoogleOtpLogin(string SecurityNum);

native final function EulaAgree(bool IsAgree);

native final function RequestSortedServerInfo();

native final function bool IsUseOTP();

native final function RefuseLogin();

native final function StopLogin();

native final function AutoLogin(int Server, int character);

native final function SaveLastLoginID(string Id);

native final function string GetLastLoginID();

native final function FullScreenMovieStart();

native final function FullScreenMovieEnd();

native final function RequestFlyMoveStart();

native final function RequestCardKeyLogin(string Pass);

native final function RequestCardKeyLoginCancel();

native final function bool IsChinaClient();

native final function bool IsNewChinaLive();

native final function string GetChinaPkString();

native final function StartCredit();

native final function EndCredit();

native final function SetTestTerrainAmbientColor(Color ambient);

native final function SetTestActorAmbientColor(Color ambient);

native final function SetTestStaticMeshAmbientColor(Color ambient);

native final function SetTestBspAmbientColor(Color ambient);

native final function SetTestSkyBoxColor(Color Col);

native final function SetTestSkyBspAmbientColor(Color ambient);

native final function SetTestHsvActorLightColor(Color LightColor);

native final function SetTestHsvStaticMeshLightColor(Color LightColor);

native final function SetTestHsvTerrainLightColor(Color LightColor);

native final function SetTestGammaSetting(float Brightness, float Contrast, float Gamma);

native final function SetEnableTerrainAmbient(bool bEnable);

native final function SetEnableActorAmbient(bool bEnable);

native final function SetEnableStaticMeshAmbient(bool bEnable);

native final function SetEnableBspAmbient(bool bEnable);

native final function SetEnableSkyBoxColor(bool bEnable);

native final function SetEnableSkyBspAmbient(bool bEnable);

native final function SetEnableHsvActorLight(bool bEnable);

native final function SetEnableHsvStaticMeshLight(bool bEnable);

native final function SetEnableHsvTerrainLight(bool bEnable);

native final function SetEnableGammaSetting(bool bEnable);

native final function SetEnableWindowDefaultGamma(bool bEnable);

native final function SetEnableGammaCorrection(bool bEnable);

native final function SetEnableLightMapIntensity(bool bEnable);

native final function SetEnvTime(float Time);

native final function SetTestBeastLightMapIntensity(float Intensity1, float Intensity2);

native final function SetTestGodRayOption(float GodRaySize, float GodRayBrightness, float GodRayEmit);

native final function SetEnableGodRay(bool bEnable);

native final function SelectChangeAttributeItem(int GroupID, int ServerID);

native final function RequestChangeAttributeItem(int GroupID, int ServerID, int changeAttribute);

native final function RequestChangeAttributeCancel();

native function SetClosingOnESC();

native final function bool HasStackableItemInWareHouse(int Type, int ItemID);

native final function bool HasStackableItemInInventory(int Type, int ItemID);

native final function RequestInzoneWaitingTime(optional bool bShowWindow);

native final function bool IsNative();

native final function string ToUpper(string Text);

native final function string ToLower(string Text);

native final function RequestJoinCuriousHouse();

native final function RequestCancelCuriousHouse();

native final function RequestLeaveCuriousHouse();

native final function RequestCuriousHouseHtml();

native final function RequestObservingListCuriousHouse();

native final function RequestObservingCuriousHouse(int HouseID);

native final function RequestLeaveObservingCuriousHouse();

native final function bool IsActivedZoneQuestExist();

native final function bool IsActivedCampaignExist();

native final function bool AmILeader();

native final function SetAlwaysOnBack(bool bAlwaysOnBack);

native final function CallGFxFunction(string WindowName, string functionName, string param);

native final function string ConvertBRCashShopDayWeek(int iDayWeek);

native final function bool IsActivedBRCampaignExist();

native final function bool GetEventContentInfo(int Id, int Step, int GoalGroupID, out UIEventManager.EventContentInfo Info);

native final function RequestEventCampaignProgressInfo(int Id, int Step, int GoalGroupID);

native final function RequestEventCampaignScoreInfo(int Id, int Step, int GoalGroupID);

native final function RequestEventCampaignHtml(int Id, int Step, int GoalGroupID);

native final function int GetUIUserPremiumLevel();

native final function ResponsePetitionAlarm();

native final function int AddTimeData(string Name);

native final function MeasureTimeOn(int Id);

native final function MeasureTimeOff(int Id);

native final function MeasureTimeStart(int Id);

native final function MeasureTimeEnd(int Id);

native final function bool IsPlayerOnWorldRaidServer();

native final function ReleaseMode GetReleaseMode();

native final function EnableChatWndResizing(bool bEnable);

native final function Color GetChatColorByType(int Type);

native final function Color GetChatSubColorByType(int Type);

native final function int ChatNotificationFilter(out string processedMsg, string orignalMsg, string keyword0, string keyword1, string keyword2, string keyword3);

native final function SetChatMessage(string a_Message, optional bool IsAppend);

native final function ProcessChatMessage(string chatMessage, optional UIEventManager.SayPacketType SayType, optional bool bStopMacro, optional bool bSharedPosition);

native function string GetChatPrefix(UIEventManager.SayPacketType SayType);

native function bool IsSameChatPrefix(UIEventManager.SayPacketType SayType, string InputPrefix);

native final function ProcessPetitionChatMessage(string a_strChatMsg);

native final function ProcessPartyMatchChatMessage(UIEventManager.SayPacketType SayType, string a_strChatMsg);

native final function ProcessCommandChatMessage(string a_strChatMsg);

native final function ProcessCommandInterPartyChatMessage(string a_strChatMsg);

native final function SwitchSingleMeshMode(bool bUse);

native final function int GetLoginMapType();

native final function bool IsActivateUSMBackground(int a_ServerType);

native final function RequestAlchemySkillList();

native final function int GetAlchemySkillGradeType(int SkillID, int SkillLevel);

native final function int GetServerType();

native final function bool IsBloodyServer();

native final function bool IsAdenServer();

native final function bool IsClassicOriginServer();

native final function bool IsClassicServer();

native final function int RefreshRecipeOfferingRate(INT64 TotalDP, bool bIsShop);

native final function RequestAttendanceCheck();

native final function RequestAttendanceWndOpen();

native final function bool IsAttendanceSystemEnable();

native final function Texture GetCaptchaImageTex();

native final function RequestRefreshCaptchaImage(INT64 Id);

native final function RequestCaptchaAnswer(INT64 Id, int AnswerCode);

native final function bool IsUsePrivateStore();

native final function CrossEnterEventRoom();

native final function QTRequestEnterPartyRoom();

native final function QTRequestBindClanRoom();

native final function QTRequestEnterClanRoom();

native final function QTRequestGetCurRoomInfo();

native final function RequestTodoListRecommand(bool allLevel);

native final function RequestTodoListInzone(bool allLevel);

native final function RequestTodoListHTML(int listType, string typeID);

native final function RequestOneDayRewardReceive(int ServerID);

native final function RequestOneDayRewardItemList(int rewardID);

native final function string RequestOneDayRewardDesc(int rewardID);

native final function string RequestOneDayRewardPeriod(int rewardID);

native final function RequestTodoListOneDayReward();

native final function bool IsUseToDoList();

native final function RequestCastleWarSeasonReward(int SeasonCastleID);

native final function RequestUserFactionInfo(UIEventManager.EFactionRequsetType eType, int nUserServerID);

native final function GetUserFactionInfoList(int nUserServerID, out array<UIEventManager.L2UserFactionUIInfo> arrFactionInfoList);

native final function GetFactionData(int nFactionID, out UIEventManager.L2FactionUIData FactionData);

native final function GetMonsterBookIDs(out array<int> MonsterBookIDs);

native final function GetMonsterBookData(int nMonsterBookID, out UIEventManager.L2MonsterBookUIData MonsterData);

native final function ClipboardCopy(string Str);

native final function string ClipboardPaste();

native final function StringIntoArray(string Str, string delim, out array<string> tokens);

native final function bool StringMatching(string Str, string pattern, string delim);

native function int appRound(float Value);

native function int appFloor(float Value);

native function int appCeil(float Value);

native function float appFractional(float Value);

native final function SoulShotSlotSelected(int Type, int iClassID);

native final function SoulShotSlotClicked(int Type, int iClassID);

native final function GetAutoEquipShotList(int Type, out array<UIEventManager.ItemInfo> arrShotItemList);

native final function bool IsUseAutoEquipSoulShot();

native final function bool IsUseSteam();

native final function bool IsUseTokenLogin();

native final function bool CashShopCoinChargeForSteam();

native final function PledgeBonusOpen();

native final function PledgeBonusReward(int Type_);

native final function PledgeBonusRewardList();

native final function bool IsUsePledgeBonus();

native final function CancelWaitingQueueTicket();

native final function RequestBlockListForAD(string charName, string ChatMsg);

native final function bool GetMinimapRegionIconData(int nRegionID, out UIEventManager.MinimapRegionIconData IconData);

native final function int GetEventAlarmDataCount();

native final function GetEventAlarmDataByIndex(int Index, out UIEventManager.EventAlarmUIData EventData);

native final function RequestAccountAttendanceReward(byte cRewardType);

native final function RequestAccountAttendanceInfo();

native final function RequestEntireCardRewardList();

native final function RequestCardReward(int Id);

native final function RequestUserBanInfo(int UserID);

native final function CardUpdownGamePickNumber(int nNumber);

native final function CardUpdownGameRewardRequest();

native final function CardUpdownGameRetry();

native final function CardUpdownGameQuit();

native final function int GetAgathionMainSkillList(int a_iClassID, int a_iEnchanted, out array<UIEventManager.SkillInfo> mainSkillList);

native final function int GetAgathionSubSkillList(int a_iClassID, int a_iEnchanted, out array<UIEventManager.SkillInfo> subSkillList);

native final function RequestSwapAgathionSlotItems(INT64 SrcSlotBitType, UIEventManager.ItemID SrcID, INT64 DesSlotBitType, UIEventManager.ItemID DesID);

native final function GetTutorialIndices(out array<UIEventManager.TutorialIndex> arrTutorialIndices);

native final function bool GetTutorialBody(int Id, int Level, out UIEventManager.TutorialBody outBody);

native final function bool GetPledgeMissionData(int nMissionID, out UIEventManager.PledgeMissionUIData pledgeMissionData);

native final function RequestPledgeMissionInfo();

native final function RequestPledgeMissionReward(int nMissionID);

native final function RequestCreatePledge(string Name);

native final function RequestPledgeItemList();

native final function RequestPledgeItemInfo(int nItemClassID);

native final function RequestPledgeItemActivate(int nItemClassID);

native final function RequestPledgeItemBuy(int nItemClassID, int nAmount);

native final function string GetPledgeMasteryName(int nPledgeMasteryID);

native final function RequestElementalSpiritInfo(int nIsOpen);

native final function GetElementalSpiritExpData(int nType, int nEvolLevel, int nSpiritLevel, out INT64 ExpValue);

native final function FlashWindow();

native final function RequestOlympiadRecord();

native final function ShowQuestInfoWindow();

native final function RequestEnchantArtifact(int Artifact, array<int> Materials);

native final function RequestPurchaseLimitShopItemList(int nShopIndex);

native final function RequestPurchaseLimitShopItemBuy(int nShopIndex, int nItemClassID, int nItemAmount);

native final function GetSubTitle(int EventID, int GroupID, out string strSubTitle);

native final function GetRewardCardTexName(int EventID, int GroupID, int ItemID, out string strTexName);

native final function bool IsUseCostume();

native final function bool RequestFestivalInfo(bool IsUIOpen);

native final function bool RequestFestivalGame();

native final function RequestOpenWndWithoutNPC(UIEventManager.HTML_OPEN_TYPE iType);

native final function RequestMagicLampGameInfo(int GameMode);

native final function RequestMagicLampGameStart(int GameMode, int GameCount);

native final function RequestPaybackList(int nPaybackEventIdType);

native final function RequestPaybackGiveReward(int nPaybackEventIdType, int nSetIndex);

native final function SelectCounterAttackTarget();

native final function ResetCounterAttackList();

native final function UpdateAutoplaySetting(UIEventManager.AutoplaySettingData Settings);

native final function bool GetLCoinShopProductData(int nProductID, out UIEventManager.LCoinShopProductUIData productData);

native final function GetLCoinShopBannerData(out array<UIEventManager.LCoinShopBannerUIData> arrBannerData);

native final function bool GetPledgeShopProductData(int nShopIndex, int nProductID, out UIEventManager.PledgeShopProductUIData productData);

native final function bool GetGachaShopData(int nShopID, out UIEventManager.L2GachaShopUIData shopData);

native final function bool GetGachaShopGroupData(int nShopID, int nGroupID, out UIEventManager.L2GachaShopGroupUIData groupData);

native final function bool GetGachaShopGroupDataAll(int nShopID, out array<UIEventManager.L2GachaShopGroupUIData> arrGroupData);

native final function RequestGachaShopInfo();

native final function RequestGachaShopGachaGroup(int nShopID);

native final function RequestGachaShopGachaItem(int nShopID, int nGroupID);

native final function RequestTimeRestrictFieldList();

native final function RequestEnterTimeRestrictField(int FiedlId);

native final function bool GetTimeRestrictFieldInfo(int FieldId, out UIEventManager.TimeRestrictFieldUIData fieldInfo);

native final function RequestRankingCharInfo();

native final function RequestRankingCharRankers(UIEventManager.RankingGroup eRankingGroup, UIEventManager.RankingScope eRankingScope, int iRace, optional int iClass);

native final function int GetRankingRewardSkillID(UIEventManager.RankingType eRankingType, UIEventManager.RankingGroup eRankingGroup, int Grade);

native final function int GetRankingGrade(UIEventManager.RankingType eRankingType, UIEventManager.RankingGroup eRankingGroup, int Ranking);

native final function RequestMyRankingHistory();

native final function UIEventManager.RankingRewardUIData GetRankingReward(UIEventManager.RankingType eRankingType, UIEventManager.RankingGroup eRankingGroup, int Grade);

native function bool IsFinalRelease();

native function bool IsTencentLoginSystem();

native function bool IsCmdLineLogin();

native function bool RequestAuthLoginForTCLS();

native function bool IsInova();

native final function int GetLetterCollectData(out array<UIEventManager.LetterCollectUIData> arrLetterCollectUIData);

native final function int GetStatBonusNameData(out array<UIEventManager.StatBonusNameUIData> arrStatBonusNameUIData);

native final function int GetStatBonusResetData(int nResetPoint, out array<UIEventManager.RequestItem> arrStatBonusResetUIData);

native final function int GetLevelUpItemPhysicalDamageBonus(int ClassID, int PlayerLevel);

native final function int GetLevelUpItemMagicalDamageBonus(int ClassID, int PlayerLevel);

native final function int GetLevelUpItemPhysicalDefenseBonus(int ClassID, int PlayerLevel);

native final function int GetLevelUpItemMagicalDefenseBonus(int ClassID, int PlayerLevel);

native final function bool UseContents(string ContentsName);

native final function RequestMPlayerPush(int Category, string Msg);

native final function bool IsDeathKnightClass(int OriginalClassID);

native final function bool IsDeathFighterClass(int OriginalClassID);

native final function bool IsOrcRiderClass(int OriginalClassID);

native final function bool IsAssassinClass(int OriginalClassID);

native final function bool IsShineMakerClass(int OriginalClassID);

native final function bool IsWereWolfClass(int OriginalClassID);

native final function bool IsRoseVainClass(int OriginalClassID);

native final function bool IsWakerClass(int OriginalClassID);

native final function GetSharedPositionData(out UIEventManager.SharedPositionData Data);

native final function SetMPlayerClientVar(string Name, string Var);

native final function bool GetMableGameCellData(int CellID, out UIEventManager.MableGameCellData Data);

native final function bool GetMableGameEventData(int CellID, UIEventManager.MableGameEventType EventType, out UIEventManager.MableGameEventData Data);

native final function int GetMaxElixir();

native final function int GetMagicLampMaxCharge(int Level);

native final function bool GetPledgeDonationData(int DonationType, out UIEventManager.PledgeDonationData Data);

native final function RequestEnemyPledgeRegister();

native final function string ConvertWorldStrToID(string worldstr);

native final function string ConvertWorldIDToStr(string worldstr);

native final function bool GetPledgeLevelData(int PledgeLevel, out UIEventManager.PledgeLevelData Data);

native final function bool StartLoginState();

native final function bool LoginWaitState();

native final function bool RequestRankingFestivalBonus(array<int> nPoints);

native final function bool GetSteadyBoxString(int nEventID, out string Type, out string Title, out string Desc);

native final function GetSteadyBoxSlotInfo(int nSlotIndex, out int ItemID, out int Amount);

native final function bool GetCollectionData(int collection_ID, out UIEventManager.CollectionData Data);

native final function bool GetCollectionMainData(int main_id, out UIEventManager.CollectionMainData Data);

native final function bool GetCollectionIdByItemName(out array<int> CollectionID, int Category, bool onlyComplete, bool onlyNotComplete, optional bool favorite, optional string ItemName, optional string OptionName, optional bool onlyProgress);

native final function bool GetCollectionIdByItemId(out array<int> CollectionID, int ItemID);

native final function bool IsCollectionRegistEnableItem(UIEventManager.ItemID sID, optional int CollectionID, optional int SlotID);

native final function bool IsCollectionRegistEnableItemWithReason(UIEventManager.ItemID sID, int CollectionID, int SlotID, out CollectionRegistFailReason Reason);

native final function bool GetCollectionInfo(int collection_ID, out UIEventManager.CollectionInfo Info);

native final function bool GetCollectionCount(int Category, out UIEventManager.CollectionCount Count);

native final function bool GetCollectionOption(out array<UIEventManager.CollectionOption> Option);

native final function bool GetCompletePeriodCollection(out array<int> CollectionID);

native final function bool GetCollectionOptionName(int Category, out array<string> OptionName);

native final function GetCharacterAbilityData(out array<UIEventManager.L2CharacterAbilityUIData> o_arrData);

native final function string GetGeneralEffectName(string nameKey);

native static function GetSubjugationList(out array<UIEventManager.SubjugationData> o_arrData);

native final function bool GetPurchaseLimitCraftData(int nShopIndex, int nProductID, out UIEventManager.PurchaseLimitCraftUIData Data);

native final function GetDethroneConnectCost(out array<UIEventManager.RequestItem> o_arrData);

native final function GetDethroneChangeNameCost(out array<UIEventManager.RequestItem> o_arrData);

native final function bool GetDethroneDailyMissionData(int MissionID, out UIEventManager.DethroneDailyMissionData o_data);

native final function int GetDethroneCategory(int DistrictID);

native final function string GetDethroneDistrictName(int DistrictID);

native final function string GetServerMarkName(int WorldID);

native final function bool GetNickNameItemData(int Id, out UIEventManager.NickNameItemData Data);

native final function string GetNickNameIconImage(int Id);

native final function bool RequestDisassembleItemInfo(array<byte> a_itemAssemble, out UIEventManager.ItemInfo o_itemInfo);

native final function GetWorldCastleWarMapInfo(UIEventManager.EWorldCastleWarMapNPCType a_npcType, out array<UIEventManager.WorldCastleWarMapData> o_npcInfo);

native final function AddPledgeInfo(int PledgeID, int PledgeCrestID);

native final function bool IsPlayerOnOlympiad();

native final function GetL2PassReward(int nPassType, int nStartIndex, int nEndIndex, out array<UIEventManager.L2PassRewardData> RewwardData);

native final function GetL2PassRewardTotalList(int nPassType, bool IsPaid, int CompleteStep, out array<UIEventManager.L2PassRewardTotalData> RewwardTotalData);

native final function int GetL2PassHuntingMaxTime();

native final function int GetL2PassRewardStepMaxCount(int nPassType);

native final function int GetL2PassMaxCount(int nPassType);

native final function int GetL2PassLastItem(int nPassType, bool IsPaid);

native final function int GetL2PassAdvanceFreeCount();

native final function GetL2PassPremiumPassCost(int nPassType, out int nItemID, out int nItemCnt);

native final function GetL2PassAdvanceInfo(array<int> EnableList, out array<UIEventManager.L2PassAdvanceData> EnchantData);

native final function GetEventHtmlString(int Index, out string Title, out string Desc);

native final function bool GetMagicLampNormalResultItemList(out array<UIEventManager.MagicLampResultItemUIData> o_ItemList);

native final function bool GetMagicLampAdvancedResultItemList(out array<UIEventManager.MagicLampResultItemUIData> o_ItemList);

native final function bool IsInTimeRestrictField();

native final function UIEventManager.BalrogwarUIData GetBalrogwarData();

native final function bool GetMissionLevelData(int a_SeasonDate, out UIEventManager.MissionLevelUIData o_data);

native final function bool GetBRWorldExchange();

native final function UIEventManager.WorldExchangeUIData GetWorldExchangeData();

native final function int GetServerPrivateStoreSearchItemSubType(int a_ItemClassID);

native final function string ConvertFloatToString(float a_Value, int a_DecimalPlace, bool a_Round);

native final function bool GetSiegePointAlarms(out array<int> PreAlarms, out array<int> Alarms);

native function bool GetPrisonData(int a_PrisonType, out UIEventManager.PrisonUIData o_data);

native function GetPrisonDataList(out array<UIEventManager.PrisonUIData> o_DataArray);

native function GetRecoveryCouponData(int ItemClassID, out UIEventManager.RecoveryCouponData Categories);

native final function OpenWebSite(string openUrl);

native final function string JapanPolicyCheck();

native final function SetUniqueGachaVideo(bool SetOn);

native final function bool GetUniqueGachaVideo();

native function GetUniqueGachaShowItem(out array<UIEventManager.UniqueGachaItemInfo> ShowItemInfo);

native function GetUniqueGachaRewardItem(out array<UIEventManager.UniqueGachaItemInfo> RewardItemInfo);

native function GetUniqueGachaGameTypeInfo(out array<UIEventManager.UniquegachaGameTypeInfo> GameTypeInfo);

native function GetUniqueGachaCostInfo(out int CostType, out int CostItemType);

native final function bool IsPrivateStoreBypass();

native final function GetItemExchangeMultisellData(int a_ItemClassID, out array<UIEventManager.ItemExchangeMultisellUIData> o_arrData);

native final function GetPledgeCrestPresetData(out array<UIEventManager.PledgeCrestPresetUIData> o_arrData);

native final function RequestClanRegisterCrestPreset(int presetID);

native final function RequestClanUnregisterCrestByPledgeID(int PledgeID);

native function GetClientCursorPos(out int X, out int Y);

native final function bool GetNQuestData(int a_QuestID, out UIEventManager.NQuestUIData o_data);

native final function bool GetNQuestDialogData(int a_QuestID, out UIEventManager.NQuestDialogUIData o_data);

native final function bool GetNQuestNpcPortraitData(int a_NpcID, out UIEventManager.NQuestNpcPortraitUIData o_data);

native final function int GetEnchantExpItemListFromInven(int a_grade, int a_SubLevel, out array<UIEventManager.ChargeExpItem> o_Items);

native final function int GetSkillSubLevelList(int a_SkillID, int a_SkillLevel, out array<int> o_SubLevelList);

native final function int GetSkillAcquireList(int a_ClassID, int a_SkillID, out array<UIEventManager.SkillAcquireData> o_Datas, out array<int> o_BlockSkills);

native final function GetSkillExtractData(int a_grade, int a_SubLevel, out array<UIEventManager.SkillExtractData> o_Datas);

native final function GetSkillTargetEnchantData(int a_grade, int a_TargetLevel, out array<UIEventManager.SkillTargetEnchantData> o_Datas);

native final function bool IsExtractSkill(int a_SkillID);

native final function GetAttendanceData(out int o_FollowItemID, out string o_Period, out array<int> o_FollowCosts);

native final function UIEventManager.PledgeEnemyDeletePenaltyUIData GetPledgeEnemyDeletePenaltyData();

native final function GetRankingInzoneDataAll(out array<UIEventManager.RankingInzoneUIData> o_ArrRankingInzoneData);

native static function bool GetRelicsMainData(int a_RelicsID, out UIEventManager.RelicsMainUIData o_data);

native static function bool GetRelicsMainDataAll(out array<UIEventManager.RelicsMainUIData> o_Datas);

native static function bool GetRelicsPlayData(UIEventManager.ERelicsPlayDataType a_Type, int a_grade, out UIEventManager.RelicsPlayUIData o_data);

native static function bool GetRelicsCollectionData(int a_CollectionID, out UIEventManager.RelicsCollectionUIData o_data);

native static function bool GetRelicsCollectionDataAll(out array<UIEventManager.RelicsCollectionUIData> o_Datas);

native static function int GetRelicsSumonEffectGrade();

native static function int GetRelicsChangeGrade();

native static function int GetRelicsUncombinableGrade();

native static function GetRelicsCollectionCumulativeOptions(array<int> a_CollectionIDs, out array<UIEventManager.RelicsCollectionOption> o_Options);

native static function GetRelicsSummonCategoryList(out array<UIEventManager.RelicsSummonCategory> o_data);

native final function GetPurchaseLimitCraftCategoryDataAll(out array<UIEventManager.PurchaseLimitCraftCategoryUIData> o_ArrPurchaseLimitCraftCategoryData, optional bool a_CraftCategory);

native final function GetKillLogData(out byte o_LogTime, out byte o_MaxLog, out byte o_MultiLogTime, out array<byte> o_MultiLogKills);

native final function bool IsVirtualItem(UIEventManager.ItemInfo o_itemInfo);

native final function GetVirtualItemInfo_SBT(INT64 nSBT, array<int> arrIndexlist, optional bool IsRelatedSBT);

native final function GetVirtualItemInfo_Index(int nIndex, array<UIEventManager.VirtualItemInfo> arrVirtualItemList);

native final function GetVirtualItemInfo_IndexDetail(int nIndex, int SubIndex, UIEventManager.VirtualItemInfo VirtualItemData);

native final function string GetLcoinCraftResetString(int nStartTimeInfo, UIEventManager.PLSHOP_RESET_TYPE nType);

native final function bool GetSummonRelicShowProb();

native final function ShowNCSecurityServiceManager();

native final function bool IsCollectionServer();

native final function bool IsPotentialServer();

native final function INT64 GetMaximumSkillPoint();

native final function GetStoreURLData(array<UIEventManager.StoreURLData> o_data);

native final function bool IsInServerGroup(int a_ServerGroupID);

native final function bool IsInEvaServer();

native final function bool IsInWolfServer();

native final function bool SetCursor(int a_Index);

native final function UnsetCursor();

native final function UIEventManager.CollectionDurationUIData GetCollectionDurationUIData();

native final function int GetItemScoreColorIndex(int a_ItemScore);

native final function bool GetEquipmentBreakRestoreCost(int a_RestoreCount, out int o_CostItemID, out int o_CostItemAmount);

native final function GetChangeClassDataAll(out array<UIEventManager.ChangeClassData> o_data);

native final function GetChangeClassExtractSkillData(out UIEventManager.ChangeClassExtractSkillData o_data);

native final function int IsChangeClassExtractSkill();

native final function GetPostFeeSettingData(out UIEventManager.PostFeeSettingData o_data);

native final function GetPostBillingData(out UIEventManager.PostBillingData o_data);

native final function INT64 CalculateBilling(INT64 a_Billing);

native final function int GetRaidAuctionPostFee();

native final function UseItemWithInfo(UIEventManager.ItemInfo a_Info);

native final function bool ScheduleTimeRestrictFieldUserEnterPacket(int a_FieldId, out int o_EntryTime);

native final function bool CheckScheduledTimeRestrictFieldUserEnterPacket(int a_FieldId, out int o_EntryTime);

native final function ClearPacketSchedule();

native final function int GetDisplaySystemRatio();
