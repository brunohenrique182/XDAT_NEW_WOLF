class StatusBaseHandle extends WindowHandle;

enum StatusBarSplitType
{
	SBST_BackLeft,                  // 0
	SBST_BackCenter,                // 1
	SBST_BackRight,                 // 2
	SBST_RegenLeft,                 // 3
	SBST_RegenCenter,               // 4
	SBST_RegenRight,                // 5
	SBST_ForeLeft,                  // 6
	SBST_ForeCenter,                // 7
	SBST_ForeRight,                 // 8
	SBST_OverlayLeft,               // 9
	SBST_OverlayCenter,             // 10
	SBST_OverlayRight,              // 11
	SBST_WarnLeft,                  // 12
	SBST_WarnCenter,                // 13
	SBST_WarnRight,                 // 14
	SBST_ForeLeft01,                // 15
	SBST_ForeCenter01,              // 16
	SBST_ForeRight01,               // 17
	SBST_ForeLeft02,                // 18
	SBST_ForeCenter02,              // 19
	SBST_ForeRight02,               // 20
	SBST_BlockEffectLeft,           // 21
	SBST_BlockEffectCenter,         // 22
	SBST_BlockEffectRight,          // 23
	SBST_Trailer                    // 24
};

enum StatusRoundSplitType
{
	SRST_Back,                      // 0
	SRST_Main,                      // 1
	SRST_Trailer,                   // 2
	SRST_Mask1,                     // 3
	SRST_Mask2,                     // 4
	SRST_Overlay                    // 5
};

struct GaugeTextureSplitData
{
	var string strTexture;
	var Texture pTexture;
	var int BarUSize;
	var int BarVSize;
	var Color Color;
	var int ratio;
};

native final function StatusBaseHandle GetSelfScript();

native final function string GetGaugeTexture(int Type);

native final function SetGaugeTexture(int Type, string strTexture, optional int size1, optional int size2);

native final function Color GetGaugeColor(int Type);

native final function SetGaugeColor(int Type, Color Color);

native final function GetPoint(out INT64 CurrentValue, out INT64 MaxValue, optional out INT64 MinValue);

native final function ClearPoint();

native final function SetPoint(INT64 CurrentValue, INT64 MaxValue);

native final function SetPointPercent(INT64 CurrentValue, INT64 MinValue, INT64 MaxValue);

native final function SetPointExpPercentRate(float CurrentPercentRate);

native final function SetRegenInfo(int Duration, int ticks, float Amount);

native final function SetDrawBlockEffect(bool bDraw);
