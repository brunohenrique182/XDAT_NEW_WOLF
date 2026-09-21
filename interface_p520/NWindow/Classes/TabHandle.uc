class TabHandle extends WindowHandle;

native final function InitTabCtrl();

native final function SetTopOrder(int Index, bool bSendMessage);

native final function int GetTopIndex();

native final function SetDisable(int Index, bool bDisable);

native final function MergeTab(int Index);

native final function SetButtonName(int Index, string NewName);

native final function SetButtonSizeTex(int Index, float Width, float Height);

native final function SetButtonOffsetTex(int Index, string NewTex, int OffsetX, int OffsetY);

native final function SetButtonBlink(int Index, bool Enable);

native final function SetButtonDisableTexture(int Index, string TextureName);

native final function RemoveTabControl(int Index);

native final function SetTabControlTexture(int Index, string NewForeTexName, optional string NewBackTexName, optional string NewHighLightTexName);

native final function SetButtonTooltip(int Index, int stringIdx);
