class UniversalToolTip extends UICommonAPI;

var array<string> G_CompName_List;
var array<int> G_ToolTipTitle_Str;
var array<int> G_ToolTip_Text;
var int MaxLength;
var WindowHandle UniversalToolTip;
var TextBoxHandle tooltipText;
var TextBoxHandle titleText;
var bool g_Enable;
var int g_Position;

function OnLoad()
{
	RegisterEvent(3060);
	RegisterEvent(3070);
	RegisterEvent(2900);
	return;
}
