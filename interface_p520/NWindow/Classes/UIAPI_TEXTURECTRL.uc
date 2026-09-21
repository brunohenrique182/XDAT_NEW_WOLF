class UIAPI_TEXTURECTRL extends UIAPI_WINDOW;

native static function SetUV(string ControlName, int a_U, int a_V);

native static function SetTexture(string ControlName, string strTexture);

native static function SetTextureCtrlType(string ControlName, UIEventManager.ETextureCtrlType Type);

native static function SetTextureWithClanCrest(string ControlName, int clanID);

native static function SetTextureWithObject(string ControlName, Texture objTexture);

native static function string GetTextureName(string ControlName);
