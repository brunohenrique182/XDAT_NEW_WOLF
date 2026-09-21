class TextBoxHandle extends WindowHandle;

native final function string GetText();

native final function SetText(string a_Text);

native final function SetTextColor(Color a_Color);

native final function Color GetTextColor();

native final function SetAlign(UIEventManager.ETextAlign Align);

native final function SetInt(int Number);

native final function SetTooltipString(string Text);

native final function SetTextEllipsisWidth(int Width);

native final function SetFontIDByName(string FontName, optional bool SetChild);

native final function int GetSizeX();

native final function int GetSizeY();

native final function SetFormatString(string formatString);
