class NameCtrlHandle extends WindowHandle;

native final function SetName(string Name, UIEventManager.ENameCtrlType Type, UIEventManager.ETextAlign Align);

native final function SetNameWithColor(string Name, UIEventManager.ENameCtrlType Type, UIEventManager.ETextAlign Align, Color NameColor);

native final function string GetName();

native final function SetNameUsingItem(out UIEventManager.ItemInfo Info, UIEventManager.ENameCtrlType Type, UIEventManager.ETextAlign Align);
