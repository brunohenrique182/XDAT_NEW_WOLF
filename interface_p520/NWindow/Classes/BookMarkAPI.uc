class BookMarkAPI extends UIEventManager;

native static function bool RequestBookMarkSlotInfo();

native static function bool RequestShowBookMark();

native static function bool RequestSaveBookMarkSlot(string slotTitle, int IconID, string iconTitle);

native static function bool RequestModifyBookMarkSlot(UIEventManager.ItemID SlotID, string slotTitle, int IconID, string iconTitle);

native static function bool RequestDeleteBookMarkSlot(UIEventManager.ItemID SlotID);

native static function bool RequestTelePortBookMark(UIEventManager.ItemID SlotID);

native static function bool RequestChangeBookMarkSlot(UIEventManager.ItemID slotID1, UIEventManager.ItemID slotID2);

native static function bool RequestGetBookMarkPos(UIEventManager.ItemID SlotID, out Vector pos);
