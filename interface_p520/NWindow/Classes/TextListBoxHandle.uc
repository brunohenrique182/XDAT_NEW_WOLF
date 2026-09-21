class TextListBoxHandle extends WindowHandle;

enum ELineGapType
{
	LG_NONE,                        // 0
	LG_AUTO,                        // 1
	LG_MANUAL                       // 2
};

native final function AddString(string Text, Color TextColor);

native final function AddStringToChatWindow(string Text, Color TextColor, Color textSubColor, optional int SharedPositionID);

native final function Clear();

native final function SetTextListBoxScrollPosition(int pos);

native final function SetFontIDByName(string FontName, optional bool SetChild, optional ELineGapType LGType, optional int LineGap);
