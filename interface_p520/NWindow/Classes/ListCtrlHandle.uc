class ListCtrlHandle extends WindowHandle;

native final function InsertRecord(UIEventManager.LVDataRecord Record);

native final function DeleteAllItem();

native final function DeleteRecord(int Index);

native final function int GetRecordCount();

native final function int GetSelectedIndex();

native final function SetSelectedIndex(int Index, bool bMoveToRow);

native final function ShowScrollBar(bool bShow);

native final function bool ModifyRecord(int Index, UIEventManager.LVDataRecord Record);

native final function GetSelectedRec(out UIEventManager.LVDataRecord Record);

native final function GetRec(int Index, out UIEventManager.LVDataRecord Record);

native final function InitListCtrl();

native final function AdjustColumnWidth(int Col);

native final function SetHeaderAlignment(int Col, UIEventManager.ETextAlign Align);

native final function SetHeaderTextOffset(int Col, int offset);

native final function SetResizable(bool B);

native final function SetColumnWidth(int Index, int Width);

native final function EnablePageBrowser(bool Enable);

native final function SetSelectedSelTooltip(bool bFlag);

native final function SetAppearTooltipAtMouseX(bool bFlag);

native final function SetColumnString(int Index, int StrIndex);

native final function SetColumnMinimumWidth(bool bFlag);

native final function SetUseHorizontalScrollBar(bool bFlag);

native final function int GetShowRow();

native final function SetSortable(bool bSortable);

native final function ShowSortIcon(int HeaderIndex);

native final function HideSortIcon();

native final function SetAscend(int HeaderIndex, bool bAscend);

native final function bool IsAscending(int HeaderIndex);

native final function SetUseSelectionTexture(bool bUse);
