class DrawPanelHandle extends WindowHandle;

native final function InsertDrawItem(UIEventManager.DrawItemInfo infNodeItem);

native final function Clear();

native final function PreCheckPanelSize(out int Width, out int Height);

native final function SetMiddleAlign(bool bMiddle, int Width);
