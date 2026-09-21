class WindowHandle extends UIEventManager;

var Object m_pTargetWnd;
var string m_WindowNameWithFullPath;

native final function SetWindowTitle(string a_Title);

native final function SetTitlePosOffset(int OffsetX, int OffsetY);

native final function ShowWindow();

native final function HideWindow();

native final function bool IsShowWindow();

native final function bool IsMinimizedWindow();

native final function string GetWindowName();

native final function string GetParentWindowName();

native final function bool ChangeParentWindow(WindowHandle a_hNewParentWnd);

native final function WindowHandle GetParentWindowHandle();

native final function GetChildWindowList(array<WindowHandle> a_ChildList);

native final function bool IsChildOf(WindowHandle a_hParentWnd);

native final function WindowHandle GetTopFrameWnd();

native final function int GetAlpha();

native final function SetAlpha(int a_Alpha, optional float a_Seconds);

native final function UIScript GetScript();

native final function string GetScriptName();

native final function bool IsVirtual();

native final function bool IsAlwaysOnTop();

native final function bool IsAlwaysOnBack();

native final function SetFontColor(Color a_FontColor);

native final function SetAlwaysFullAlpha(bool a_AlwaysFullAlpha);

native final function SetModal(bool a_Modal);

native final function UIEventManager.Rect GetRect();

native final function AddWindowSize(int a_DeltaWidth, int a_DeltaHeight);

native final function SetWindowSize(int a_Width, int a_Height);

native final function GetWindowSize(out int a_Width, out int a_Height);

native final function SetWindowSizeRel(float fWidthRate, float fHeightRate, int nOffsetWidth, int nOffsetHeight);

native final function GetWindowSizeRel(out float fWidthRate, out float fHeightRate, out int nOffsetWidth, out int nOffsetHeight);

native final function SetWindowSizeRel43(float fWidthRate, float fHeightRate, int nOffsetWidth, int nOffsetHeight);

native final function bool IsRelativeSize();

native final function Move(int a_nDeltaX, int a_nDeltaY, optional float a_Seconds);

native final function MoveTo(int a_nX, int a_nY);

native final function MoveEx(int a_nX, int a_nY);

native final function MoveC(int a_nX, int a_nY);

native final function MoveExWithTime(int a_nX, int a_nY, float a_Seconds);

native final function MoveShake(int a_nRange, int a_nSet, optional float a_Seconds);

native final function EnableTick();

native final function DisableTick();

native final function SetAnchor(string AnchorWindowName, string RelativePoint, string AnchorPoint, int OffsetX, int OffsetY);

native final function ClearAnchor();

native final function bool IsAnchored();

native final function bool IsDraggable();

native final function SetDraggable(bool a_Draggable);

native final function SetStuckable(bool a_Stuckable);

native final function bool IsVirtualDrag();

native final function SetVirtualDrag(bool a_bFlag);

native final function SetDragOverTexture(string a_TextureName);

native final function EnableWindow();

native final function DisableWindow();

native final function bool IsEnableWindow();

native final function SetFocus();

native final function bool IsFocused();

native final function ReleaseFocus();

native final function BringToFrontOf(string TargetName);

native final function BringToFront();

native final function SetTimer(int a_TimerID, int a_DelayMiliseconds);

native final function KillTimer(int a_TimerID);

native final function NotifyAlarm();

native final function SetTooltipText(string Text);

native final function string GetTooltipText();

native final function SetTooltipType(string TooltipType);

native final function SetTooltipCustomType(UIEventManager.CustomTooltip Info);

native final function GetTooltipCustomType(out UIEventManager.CustomTooltip Info);

native final function ClearTooltip();

native final function ClearAllChildShortcutItemTooltip();

native final function SetFrameSize(int nWidth, int nHeight);

native final function SetResizeFrameSize(int nWidth, int nHeight);

native function SetScrollBarPosition(int X, int Y, int HeightOffset);

native final function SetScrollPosition(int pos);

native final function int GetScrollPosition();

native final function SetScrollHeight(int Height);

native final function int GetScrollHeight();

native final function SetScrollUnit(int Unit, bool Clear);

native final function SetSettledWnd(bool bFlag);

native final function Rotate(optional bool bWithCapture, optional int RotationTime, optional Vector Direction, optional int BeginAlpha, optional int EndAlpha, optional bool bCW, optional float RotationConstant);

native final function ClearRotation();

native final function IsFront();

native final function InitRotation();

native final function SetEditable(bool bEnable);

native final function WindowHandle AddChildWnd(UIEventManager.EXMLControlType ChildType);

native final function string GetClassName();

native final function DeleteChildWnd(string ChildName);

native final function SetBackTexture(string TextureName);

native final function SetScript(string ScriptName);

native final function bool IsControlContainer();

native final function UIEventManager.EXMLControlType GetControlType();

native final function WindowHandle LoadXMLWindow(string FilePathName);

native final function bool SaveXMLWindow(string FilePathName);

native final function GetXMLDocumentInfo(out string Comment, out string NameSpace, out string XSI, out string SchemaLocation);

native final function SetXMLDocumentInfo(string Comment, string NameSpace, string XSI, string SchemaLocation);

native final function ConvertToEditable();

native final function bool MakeBaseUC(string UCName, string FilePathName);

native final function ChangeControlOrder(UIEventManager.EControlOrderWay WayType);

native final function EnterState();

native final function ExitState();

native final function bool IsCurrentState();

native final function SetShowAndHideAnimType(bool bShow, int Direction, float Time);

native final function SetTooltipCalculateSize(int MinimumWidth);

native final function InsertTooltipDrawItem(UIEventManager.DrawItemInfo infDrawItem);

native final function WindowHandle GetChildWindow(string ChildName);

native final function EnableDynamicAlpha(bool bEnable);

native final function SetResizeFrameOffset(int StartWidth, int StartHeight);

native final function SetCanBeShownDuringScene(bool bCanBeShownDuringScene);

native final function SetUnConditionalShow(bool bValue);

native final function SetUpScalableUIDefaultSetting();

native final function ScalingToDefaultSizeType();

native final function ScalingToCurrentSizeType();

native final function GetCurrentScalableSizeRate(out float WidthRate, out float HeightRate);

native final function WindowHandle GetResizeFrame();

native final function SetRotationAngle(float a_Angle, optional Vector a_AxisVector);

native final function float GetRotationAngle();

native final function SetVisibility(bool a_Visibility);

native final function bool IsVisibility();

native final function SetUseCursor(bool a_bUseCursor);

native final function ChangeScalableSize(int a_SizeType);
