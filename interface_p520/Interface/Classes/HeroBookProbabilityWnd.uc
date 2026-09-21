class HeroBookProbabilityWnd extends UICommonAPI
	dependson(UIPacket);

var WindowHandle Me;
var RichListCtrlHandle StatBonus_ListCtrl;
var int chargeCurrent;
var int nCurrentLevel;
var array<UIPacket._PkHeroBook> books;

function OnRegisterEvent()
{
	RegisterEvent((100000 + 1047));
	return;
}

function OnLoad()
{
	SetClosingOnESC();
	Initialize();
	return;
}

function Initialize()
{
	Me = GetWindowHandle("HeroBookProbabilityWnd");
	StatBonus_ListCtrl = GetRichListCtrlHandle("HeroBookProbabilityWnd.StatBonus_ListCtrl");
	StatBonus_ListCtrl.SetSelectedSelTooltip(false);
	StatBonus_ListCtrl.SetAppearTooltipAtMouseX(true);
	StatBonus_ListCtrl.SetUseStripeBackTexture(false);
	return;
}

function refresh(int nCurrentLevelValue)
{
	local int i;
	local array<HeroBookListData> listDatas;

	nCurrentLevel = nCurrentLevelValue;
	Class'NWindow.HeroBookAPI'.static.GetAllHeroBookListData(byte(HeroBookWnd(GetScript("HeroBookWnd")).getCatogoryNum()), listDatas);
	StatBonus_ListCtrl.DeleteAllItem();
	i = 0;
	while((i < listDatas.Length))
	{
		AddList(listDatas[i]);
		i++;
	}
	StatBonus_ListCtrl.SetStartRow((nCurrentLevel - 1));
	return;
}

function AddList(HeroBookListData Data)
{
	local RichListCtrlRowData rowData;
	local SkillInfo a_SkillInfo;
	local ItemInfo a_itemInfo;
	local int addX;

	rowData.cellDataList.Length = 3;
	if(((Data.BookSkillLevel > 0) && (Data.BookSkillLevel < 10)))
	{
		addX = 6;
	}
	else if(((Data.BookSkillLevel > 9) && (Data.BookSkillLevel < 100)))
	{
		addX = 3;
	}
	AddRichListCtrlString(rowData.cellDataList[0].drawitems, string(Data.Id), GTColor().White, false, addX, 3);
	GetSkillInfo(Data.BookSkillID, Data.BookSkillLevel, 0, a_SkillInfo);
	AddRichListCtrlSkillBySkillInfo(rowData.cellDataList[1].drawitems, a_SkillInfo, 32, 32, 5, 0);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, a_SkillInfo.SkillName, GTColor().White, false, 10, 10);
	AddRichListCtrlString(rowData.cellDataList[1].drawitems, (GetSystemString(88) $ string(a_SkillInfo.SkillLevel)), GetColor(176, 155, 121, 255), false, 5, 0);
	if(((Data.SuccessItemID <= 0) && (Data.SuccessSkillID <= 0)))
	{
		AddRichListCtrlString(rowData.cellDataList[2].drawitems, "-", GTColor().Gray, false, 35, 2);
	}
	else
	{
		if((Data.SuccessItemID > 0))
		{
			a_itemInfo = GetItemInfoByClassID(Data.SuccessItemID);
			a_itemInfo.ItemNum = INT64(Data.SuccessItemCount);
			AddRichListCtrlItem(rowData.cellDataList[2].drawitems, a_itemInfo, 32, 32, 5, 0);
		}
		else
		{
			addRichListCtrlTexture(rowData.cellDataList[2].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 32, 32, 5, 0);
		}
		if((Data.SuccessSkillID > 0))
		{
			GetSkillInfo(Data.SuccessSkillID, Data.SuccessSkillLevel, 0, a_SkillInfo);
			AddRichListCtrlSkillBySkillInfo(rowData.cellDataList[2].drawitems, a_SkillInfo, 32, 32, 5, 0);
		}
		else
		{
			addRichListCtrlTexture(rowData.cellDataList[2].drawitems, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 32, 32, 5, 0);
		}
	}
	if((nCurrentLevel == Data.Id))
	{
		rowData.sOverlayTex = "L2UI_CT1.RankingWnd.RankingWnd_MyRankBg";
		rowData.OverlayTexU = 734;
		rowData.OverlayTexV = 45;
	}
	StatBonus_ListCtrl.InsertRecord(rowData);
	if((nCurrentLevel == Data.Id))
	{
		StatBonus_ListCtrl.SetSelectedIndex((nCurrentLevel - 1), false);
	}
	return;
}

function OnEvent(int Event_ID, string param)
{
	switch(Event_ID)
	{
		case EV_PacketID(1047):
			ParsePacket_S_EX_HERO_BOOK_INFO();
			break;
		default:
			break;
	}
	return;
}

function ParsePacket_S_EX_HERO_BOOK_INFO()
{
	local UIPacket._S_EX_HERO_BOOK_INFO packet;
	local int i;

	if(!Class'Interface.UIPacket'.static.Decode_S_EX_HERO_BOOK_INFO(packet))
	{
		return;
	}
	books = packet.books;
	i = 0;
	while((i < books.Length))
	{
		if((books[i].cCategory == HeroBookWnd(GetScript("HeroBookWnd")).getCatogoryNum()))
		{
			chargeCurrent = books[i].nPoint;
			nCurrentLevel = books[i].nLevel;
		}
		i++;
	}
	if(Me.IsShowWindow())
	{
		refresh(nCurrentLevel);
	}
	return;
}

function OnClickButton(string Name)
{
	switch(Name)
	{
		case "Close_Button":
			OnClose_ButtonClick();
			break;
		default:
			break;
	}
	return;
}

function OnClose_ButtonClick()
{
	CloseUI();
	return;
}

function OnReceivedCloseUI()
{
	CloseUI();
	return;
}
