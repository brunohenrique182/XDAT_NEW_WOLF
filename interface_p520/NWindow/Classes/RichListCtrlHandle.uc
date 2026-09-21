class RichListCtrlHandle extends WindowHandle;

native final function InsertRecord(UIEventManager.RichListCtrlRowData Record);

native final function DeleteAllItem();

native final function DeleteRecord(int Index);

native final function int GetRecordCount();

native final function int GetSelectedIndex();

native final function SetSelectedIndex(int Index, bool bMoveToRow);

native final function ShowScrollBar(bool bShow);

native final function bool ModifyRecord(int Index, UIEventManager.RichListCtrlRowData Record);

native final function GetSelectedRec(out UIEventManager.RichListCtrlRowData Record);

native final function GetRec(int Index, out UIEventManager.RichListCtrlRowData Record);

native final function InitListCtrl();

native final function AdjustColumnWidth(int Col);

native final function int GetMaxColumnWidth();

native final function SetHeaderAlignment(int Col, UIEventManager.ETextAlign Align);

native final function SetHeaderTextOffset(int Col, int offset);

native final function SetResizable(bool B);

native final function SetColumnWidth(int Index, int Width);

native final function EnablePageBrowser(bool Enable);

native final function SetContentsHeight(int Height);

native final function SetSelectedSelTooltip(bool bFlag);

native final function SetAppearTooltipAtMouseX(bool bFlag);

native final function SetColumnString(int Index, int StrIndex);

native final function SetColumnMinimumWidth(bool bFlag);

native final function SetUseHorizontalScrollBar(bool bFlag);

native final function SetStatusBarTexture(string ForeLeftTex, string ForeCenterTex, string ForeRightTex, string BackLeftTex, string BackCenterTex, string BackRightTex);

native final function SetUseStripeBackTexture(bool bUseStripeBackTexture);

native final function SetSelectable(bool bSelectable);

native final function SetStartRow(int StartRow);

native final function SetEnableItemRecordDrag(bool bEnableDrag);

native final function int GetShowRow();

native final function SetSortable(bool bSortable);

native final function ShowSortIcon(int HeaderIndex);

native final function HideSortIcon();

native final function SetAscend(int HeaderIndex, bool bAscend);

native final function bool IsAscending(int HeaderIndex);

native final function AdjustShowRow(int ShowRow);

native final function IncreaseStartRow(int Cnt);

native final function DecreaseStartRow(int Cnt);

native final function int GetStartRow();

native final function SetEnableInteractionPass(bool bEnablePass);

native final function GetPointedRec(out UIEventManager.RichListCtrlRowData Record);

native final function SetColumnText(int Index, string strColumn);

native final function SetColumnTextColor(int Index, Color Col);

native final function SetUseSelectionTexture(bool bUse);
