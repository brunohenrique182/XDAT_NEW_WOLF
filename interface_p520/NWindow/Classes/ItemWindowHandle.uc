class ItemWindowHandle extends WindowHandle;

native final function int GetSelectedNum();

native final function int GetItemNum();

native final function ClearSelect();

native final function AddItem(UIEventManager.ItemInfo Info);

native final function AddItemWithFaded(UIEventManager.ItemInfo Info);

native final function bool SetItem(int Index, UIEventManager.ItemInfo Info);

native final function DeleteItem(int Index);

native final function bool GetSelectedItem(out UIEventManager.ItemInfo Info);

native final function bool GetItem(int Index, out UIEventManager.ItemInfo Info);

native final function GetItemIdLevel(int Index, out int Id, out int Level, out int SubLevel);

native final function int GetItemSkillDisabled(int Index);

native final function SetItemSkillDisabled(int Index, int SkillDisabled);

native final function SetBlessPanelDrawType(int Index, UIEventManager.EBlessPanelDrawType Type);

native final function Clear();

native final function int FindItem(UIEventManager.ItemID scID);

native final function int FindItemWithAllProperty(UIEventManager.ItemInfo Info);

native final function int FindItemWithReserved(int Reserved);

native final function SetFaded(bool bOn);

native final function ShowScrollBar(bool bShow);

native final function SwapItems(int index1, int index2);

native final function int GetIndexAt(int X, int Y, int OffsetX, int OffsetY);

native final function SetDisableTex(string a_DisableTex);

native final function SetRow(int a_Row);

native final function SetCol(int a_Col);

native final function SetExpandItemNum(int Index, int Num);

native final function SetItemUsability();

native final function int FindItemByClassID(UIEventManager.ItemID scID);

native final function int GetSideTypePageNum();

native final function int GetSideTypeCurPage();

native final function PushSideTypePrevBtn();

native final function PushSideTypeNextBtn();

native final function SetSelectedNum(int idx);

native final function ResizeScrollBar();

native final function SetToggleEffect(int Index, bool bToggle);

native final function SetIconIndex(int Index, int IconIndex);

native final function SetIconDrawType(UIEventManager.EItemWindowIconDrawType DrawType);

native final function SetNewlyAcquired(int Index, bool bNewlyAcquired);

native final function ClearNewlyAcquired();

native final function ClearItemTooltip();

native final function SetButtonClick(bool bToggle);

native final function SetNoItemDrag(bool bToggle);

native final function SetDualSlotBitType(INT64 a_SlotBitType);

native final function UpdatePointedNum();

native final function SetPetSkillWindow(int Index, bool bPetSkill);

native final function int GetInventoryEffectLevel(int Index);
