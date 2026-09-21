class ButtonHandle extends WindowHandle;

native final function string GetButtonName();

native final function SetButtonName(int a_NameID);

native final function SetNameText(string NameText);

native final function SetTexture(string sForeTexture, string sBackTexture, string sHighlightTexture);

native final function bool IsMouseOver();

native final function int GetButtonValue();

native final function SetButtonValue(int Value);

native final function SetEnable(bool bEnable);

native final function SetDefaultTextEnableColor(Color a_Color);

native final function SetDefaultTextDisableColor(Color a_Color);

native final function SetDisableTexture(string sDisableTexture);

native final function SetCollisionTexture(string strCollisionTex);
