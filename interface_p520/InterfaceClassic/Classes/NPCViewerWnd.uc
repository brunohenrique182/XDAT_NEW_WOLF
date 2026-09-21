class NPCViewerWnd extends UICommonAPI;

enum ESearchMode
{
	Search_NPC_NameID,              // 0
	Search_NPC_Class,               // 1
	Search_NPC_Mesh                 // 2
};

enum EShowMode
{
	Show_NPC_NameID,                // 0
	Show_NPC_Class,                 // 1
	Show_NPC_Mesh                   // 2
};

var string m_Windowname;
var WindowHandle m_hWnd;
var TabHandle m_TabCategory;
var ListBoxHandle m_ListBoxNPC;
var RadioButtonHandle m_RadioButtonNameID;
var RadioButtonHandle m_RadioButtonMesh;
var RadioButtonHandle m_RadioButtonClass;
var ListBoxHandle m_TextNPCMeshTexture;
var EditBoxHandle m_EditBoxSearchNPC;
var ButtonHandle m_ButtonSearchNPC;
var ButtonHandle m_ButtonDuplicateNPC;
var EditBoxHandle m_EditBoxSpeed;
var EditBoxHandle m_EditBoxAnimRate;
var EditBoxHandle m_EditBoxRadius;
var EditBoxHandle m_EditBoxHeight;
var EditBoxHandle m_EditBoxScale;
var EditBoxHandle m_EditBoxState;
var CheckBoxHandle m_CheckBoxCollisionAutoCalc;
var ItemWindowHandle m_ItemWindowNpcItem;
var EditBoxHandle m_EditBoxSearchItem;
var ButtonHandle m_ButtonSearchItem;
var float defaultCollisionRadius;
var float defaultCollisionHeight;
var int SelectedID;
var string NpcSearch;
var float GroundSpeed;
var float AnimRate;
var float CollisionRadius;
var float CollisionHeight;
var float DrawScale;
var int PawnState;
var ESearchMode searchMode;
var array<int> NpcIdList;
var EditBoxHandle m_EditBoxSearchAnim;
var ButtonHandle m_ButtonSearchAnim;
var ListBoxHandle m_ListBoxAnim;
var EditBoxHandle m_EditBoxAnim1;
var EditBoxHandle m_EditBoxAnim2;
var EditBoxHandle m_EditBoxAnim3;
var ButtonHandle m_ButtonUseAnim1;
var ButtonHandle m_ButtonUseAnim2;
var ButtonHandle m_ButtonUseAnim3;
var ButtonHandle m_ButtonDeleteAnim1;
var ButtonHandle m_ButtonDeleteAnim2;
var ButtonHandle m_ButtonDeleteAnim3;
var EditBoxHandle m_EditBoxHitTime;
var EditBoxHandle m_EditBoxLoopIdx;
var ButtonHandle m_ButtonAnimPlay;
//var delegate<SortByNameDelegate> __SortByNameDelegate__Delegate;

function OnRegisterEvent()
{
	RegisterEvent(4380);
	return;
}

function OnLoad()
{
	InitializeHandle();
	m_hWnd.SetWindowTitle("NPC VIEWER");
	SelectedID = 0;
	NpcSearch = "";
	GroundSpeed = 0.0000000;
	AnimRate = 0.0000000;
	CollisionRadius = 0.0000000;
	CollisionHeight = 0.0000000;
	DrawScale = 0.0000000;
	PawnState = 0;
	return;
}

function OnShow()
{
	SearchNPC("");
	Initialize();
	m_hWnd.ShowWindow();
	return;
}

function InitializeHandle()
{
	m_hWnd = GetWindowHandle(m_Windowname);
	m_TabCategory = GetTabHandle((m_Windowname $ ".FunctionSelect_Tab"));
	m_RadioButtonNameID = GetRadioButtonHandle((m_Windowname $ ".NameID_RadioButton"));
	m_RadioButtonMesh = GetRadioButtonHandle((m_Windowname $ ".Mesh_RadioButton"));
	m_RadioButtonClass = GetRadioButtonHandle((m_Windowname $ ".Class_RadioButton"));
	m_ListBoxNPC = GetListBoxHandle((m_Windowname $ ".Npc_ListBox"));
	m_TextNPCMeshTexture = GetListBoxHandle((m_Windowname $ ".Path_ListBox"));
	m_EditBoxSearchNPC = GetEditBoxHandle((m_Windowname $ ".NpcSearch_EditBox"));
	m_ButtonSearchNPC = GetButtonHandle((m_Windowname $ ".Button_NpcSearch"));
	m_ButtonDuplicateNPC = GetButtonHandle((m_Windowname $ ".Button_Duplicate"));
	m_EditBoxSpeed = GetEditBoxHandle((m_Windowname $ ".Speed_EditBox"));
	m_EditBoxAnimRate = GetEditBoxHandle((m_Windowname $ ".Rate_EditBox"));
	m_EditBoxRadius = GetEditBoxHandle((m_Windowname $ ".Radius_EditBox"));
	m_EditBoxHeight = GetEditBoxHandle((m_Windowname $ ".Height_EditBox"));
	m_EditBoxScale = GetEditBoxHandle((m_Windowname $ ".Scale_EditBox"));
	m_EditBoxState = GetEditBoxHandle((m_Windowname $ ".State_EditBox"));
	m_CheckBoxCollisionAutoCalc = GetCheckBoxHandle((m_Windowname $ ".CB_AutoCalculate"));
	m_ItemWindowNpcItem = GetItemWindowHandle((m_Windowname $ ".IconList_ItemWindow"));
	m_EditBoxSearchItem = GetEditBoxHandle((m_Windowname $ ".ItemSearch_EditBox"));
	m_ButtonSearchItem = GetButtonHandle((m_Windowname $ ".ItemSearch_Button"));
	m_EditBoxSearchAnim = GetEditBoxHandle((m_Windowname $ ".SeqSearch_EditBox"));
	m_ButtonSearchAnim = GetButtonHandle((m_Windowname $ ".AnimSearch_Button"));
	m_ListBoxAnim = GetListBoxHandle((m_Windowname $ ".Seq_ListBox"));
	m_EditBoxAnim1 = GetEditBoxHandle((m_Windowname $ ".Ani1_EditBox"));
	m_EditBoxAnim2 = GetEditBoxHandle((m_Windowname $ ".Ani2_EditBox"));
	m_EditBoxAnim3 = GetEditBoxHandle((m_Windowname $ ".Ani3_EditBox"));
	m_ButtonUseAnim1 = GetButtonHandle((m_Windowname $ ".Ani1Use_Button"));
	m_ButtonUseAnim2 = GetButtonHandle((m_Windowname $ ".Ani2Use_Button"));
	m_ButtonUseAnim3 = GetButtonHandle((m_Windowname $ ".Ani3Use_Button"));
	m_ButtonDeleteAnim1 = GetButtonHandle((m_Windowname $ ".Ani1Del_Button"));
	m_ButtonDeleteAnim2 = GetButtonHandle((m_Windowname $ ".Ani2Del_Button"));
	m_ButtonDeleteAnim3 = GetButtonHandle((m_Windowname $ ".Ani3Del_Button"));
	m_EditBoxHitTime = GetEditBoxHandle((m_Windowname $ ".HitTime_EditBox"));
	m_EditBoxLoopIdx = GetEditBoxHandle((m_Windowname $ ".LoopIdx_EditBox"));
	m_ButtonAnimPlay = GetButtonHandle((m_Windowname $ ".ComboPlay_Button"));
	return;
}

function OnEvent(int a_EventID, string param)
{
	switch(a_EventID)
	{
		case 4380:
			ReloadNPCViewerWnd();
			break;
		default:
			break;
	}
	return;
}

function Initialize()
{
	m_EditBoxSearchNPC.SetFocus();
	m_EditBoxHitTime.SetString("1.8");
	m_EditBoxLoopIdx.SetString("-1");
	return;
}

function OnDBClickListBoxItem(string strID, int SelectedIndex)
{
	local string SelectedStr;

	switch(strID)
	{
		case "Npc_ListBox":
			SelectedID = m_ListBoxNPC.GetSelectedItemData();
			HandleNPCData();
			HandleNPCSpawn();
			SearchAnimation("");
			break;
		case "Seq_ListBox":
			SelectedStr = m_ListBoxAnim.GetSelectedString();
			Class'NWindow.UIDATA_PAWNVIEWER'.static.PlayNPCAnim(SelectedStr, 1.0000000);
			break;
		default:
			break;
	}
	return;
}

function OnLButtonClickListBoxItem(string strID, int SelectedIndex)
{
	switch(strID)
	{
		case "Npc_ListBox":
			SelectedID = m_ListBoxNPC.GetSelectedItemData();
			HandleNPCData();
			break;
		default:
			break;
	}
	return;
}

function OnDBClickItemWithHandle(ItemWindowHandle a_hItemWindow, int Index)
{
	local ItemInfo Info;

	if(a_hItemWindow.GetItem(Index, Info))
	{
		switch(a_hItemWindow.GetWindowName())
		{
			case "IconList_ItemWindow":
				Class'NWindow.UIDATA_PAWNVIEWER'.static.EquipNPCItem(Info.Id);
				break;
			default:
				break;
		}
	}
	return;
}

function OnRClickItemWithHandle(ItemWindowHandle a_hItemWindow, int Index)
{
	local ItemInfo Info;

	if(a_hItemWindow.GetItem(Index, Info))
	{
		switch(a_hItemWindow.GetWindowName())
		{
			case "IconList_ItemWindow":
				Class'NWindow.UIDATA_PAWNVIEWER'.static.EquipNPCItem(Info.Id);
				break;
			default:
				break;
		}
	}
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	local string EditBoxString;

	if((int(nKey) == 13))
	{
		switch(a_WindowHandle.GetWindowName())
		{
			case "NpcSearch_EditBox":
				NpcSearch = m_EditBoxSearchNPC.GetString();
				if((NpcSearch != ""))
				{
					SearchNPC(NpcSearch);
				}
				break;
			case "ItemSearch_EditBox":
				NpcSearch = m_EditBoxSearchItem.GetString();
				if((NpcSearch != ""))
				{
					SearchItem(NpcSearch);
				}
				break;
			case "Speed_EditBox":
			case "Rate_EditBox":
			case "Radius_EditBox":
			case "Height_EditBox":
			case "State_EditBox":
				ApplyPawnSetting();
				break;
			case "Scale_EditBox":
				if(m_CheckBoxCollisionAutoCalc.IsChecked())
				{
					ApplyAutoCalcCollisionScale();
				}
				else
				{
					ApplyPawnSetting();
				}
			case "SeqSearch_EditBox":
				EditBoxString = m_EditBoxSearchAnim.GetString();
				SearchAnimation(EditBoxString);
				break;
			default:
				break;
		}
	}
	return false;
}

function OnClickCheckBox(string strID)
{
	switch(strID)
	{
		case "CB_AutoCalculate":
			if(m_CheckBoxCollisionAutoCalc.IsChecked())
			{
				ApplyAutoCalcCollisionScale();
				m_EditBoxRadius.DisableWindow();
				m_EditBoxHeight.DisableWindow();
			}
			else
			{
				m_EditBoxRadius.EnableWindow();
				m_EditBoxHeight.EnableWindow();
			}
			break;
		case "NameID_RadioButton":
			if(m_RadioButtonNameID.IsChecked())
			{
				searchMode = Search_NPC_NameID;
				TogleNPCList(Show_NPC_NameID);
			}
			break;
		case "Mesh_RadioButton":
			if(m_RadioButtonMesh.IsChecked())
			{
				searchMode = Search_NPC_Mesh;
				TogleNPCList(Show_NPC_Mesh);
			}
			break;
		case "Class_RadioButton":
			if(m_RadioButtonClass.IsChecked())
			{
				searchMode = Search_NPC_Class;
				TogleNPCList(Show_NPC_Class);
			}
			break;
		default:
			break;
	}
	return;
}

function OnClickButton(string strID)
{
	local string EditBoxString;
	local float frame, Duration, Dues;

	switch(strID)
	{
		case "Button_NpcSearch":
			EditBoxString = m_EditBoxSearchNPC.GetString();
			SearchNPC(EditBoxString);
			break;
		case "Button_Duplicate":
			Class'NWindow.UIDATA_PAWNVIEWER'.static.SpawnActorAtMyLocation(SelectedID);
			break;
		case "ItemSearch_Button":
			EditBoxString = m_EditBoxSearchItem.GetString();
			SearchItem(EditBoxString);
			break;
		case "AnimSearch_Button":
			EditBoxString = m_EditBoxSearchAnim.GetString();
			SearchAnimation(EditBoxString);
			break;
		case "Ani1Use_Button":
			m_EditBoxAnim1.SetString(m_ListBoxAnim.GetSelectedString());
			break;
		case "Ani2Use_Button":
			m_EditBoxAnim2.SetString(m_ListBoxAnim.GetSelectedString());
			break;
		case "Ani3Use_Button":
			m_EditBoxAnim3.SetString(m_ListBoxAnim.GetSelectedString());
			break;
		case "Ani1Del_Button":
			m_EditBoxAnim1.SetString("");
			break;
		case "Ani2Del_Button":
			m_EditBoxAnim2.SetString("");
			break;
		case "Ani3Del_Button":
			m_EditBoxAnim3.SetString("");
			break;
		case "ComboPlay_Button":
			Class'NWindow.UIDATA_PAWNVIEWER'.static.PlayPCComboAnim(m_EditBoxAnim1.GetString(), m_EditBoxAnim2.GetString(), m_EditBoxAnim3.GetString(), float(m_EditBoxHitTime.GetString()), float(m_EditBoxLoopIdx.GetString()));
			Class'NWindow.UIDATA_PAWNVIEWER'.static.GetAnimFrame(0, frame, Duration, Dues);
			Class'NWindow.UIDATA_PAWNVIEWER'.static.GetAnimFrame(1, frame, Duration, Dues);
			Class'NWindow.UIDATA_PAWNVIEWER'.static.GetAnimFrame(2, frame, Duration, Dues);
			break;
		default:
			break;
	}
	return;
}

function SearchAnimation(string Str)
{
	local array<string> AnimList;
	local int Index;

	m_ListBoxAnim.Clear();
	Class'NWindow.UIDATA_PAWNVIEWER'.static.GetNPCAnimationList(AnimList);
	// AnimList.Sort(SortByNameDelegate);   // array.Sort() unsupported by this compiler
	if((Str == ""))
	{
		Index = 0;
		while((Index < AnimList.Length))
		{
			m_ListBoxAnim.AddString(AnimList[Index]);
			++Index;
		}
	}
	else
	{
		Index = 0;
		while((Index < AnimList.Length))
		{
			if(StringMatching(AnimList[Index], Str, " "))
			{
				m_ListBoxAnim.AddString(AnimList[Index]);
			}
			++Index;
		}
	}
	return;
}

delegate int SortByNameDelegate(string name0, string name1)
{
	if((ToUpper(name0) > ToUpper(name1)))
	{
		return -1;
	}
	return 0;
}

function HandleNPCData()
{
	local string MeshName;
	local array<string> TexList;
	local string ClassName;
	local int Index;
	local Color MeshColor, textureColor, ClassColor;

	MeshColor.R = 255;
	MeshColor.G = 255;
	MeshColor.B = 150;
	textureColor.R = 255;
	textureColor.G = 150;
	textureColor.B = 255;
	ClassColor.R = 150;
	ClassColor.G = 255;
	ClassColor.B = 255;
	m_TextNPCMeshTexture.Clear();
	MeshName = Class'NWindow.UIDATA_NPC'.static.GetNPCMesh(SelectedID);
	Class'NWindow.UIDATA_NPC'.static.GetNPCTextureList(SelectedID, TexList);
	ClassName = Class'NWindow.UIDATA_NPC'.static.GetNPCClass(SelectedID);
	m_TextNPCMeshTexture.AddStringWithData(("" $ MeshName), MeshColor, 0);
	Index = 0;
	while((Index < TexList.Length))
	{
		m_TextNPCMeshTexture.AddStringWithData(("" $ TexList[Index]), textureColor, 0);
		Index++;
	}
	m_TextNPCMeshTexture.AddStringWithData(("" $ ClassName), ClassColor, 0);
	return;
}

function HandleNPCSpawn()
{
	SelectedID = m_ListBoxNPC.GetSelectedItemData();
	Class'NWindow.UIDATA_PAWNVIEWER'.static.SpawnNPC(SelectedID, GroundSpeed, AnimRate, CollisionRadius, CollisionHeight, DrawScale, PawnState);
	defaultCollisionRadius = CollisionRadius;
	defaultCollisionHeight = CollisionHeight;
	m_EditBoxSpeed.SetString(("" $ string(GroundSpeed)));
	m_EditBoxAnimRate.SetString(("" $ string(AnimRate)));
	m_EditBoxRadius.SetString(("" $ string(CollisionRadius)));
	m_EditBoxHeight.SetString(("" $ string(CollisionHeight)));
	m_EditBoxScale.SetString(("" $ string(DrawScale)));
	m_EditBoxState.SetString(("" $ string(PawnState)));
	return;
}

function TogleNPCList(EShowMode ShowMode)
{
	local int Index;
	local string Name, MeshName, ClassName;
	local Color C;

	C.R = 255;
	C.G = 255;
	C.B = 255;
	m_ListBoxNPC.Clear();
	Index = 0;
	while((Index < NpcIdList.Length))
	{
		switch(ShowMode)
		{
			case Show_NPC_NameID:
				Name = Class'NWindow.UIDATA_NPC'.static.GetNPCName(NpcIdList[Index]);
				m_ListBoxNPC.AddStringWithData(((("[" $ string(NpcIdList[Index])) $ "] ") $ Name), C, NpcIdList[Index]);
				break;
			case Show_NPC_Mesh:
				MeshName = Class'NWindow.UIDATA_NPC'.static.GetNPCMesh(NpcIdList[Index]);
				m_ListBoxNPC.AddStringWithData(("" $ MeshName), C, NpcIdList[Index]);
				break;
			case Show_NPC_Class:
				ClassName = Class'NWindow.UIDATA_NPC'.static.GetNPCClass(NpcIdList[Index]);
				m_ListBoxNPC.AddStringWithData(("" $ ClassName), C, NpcIdList[Index]);
				break;
			default:
				break;
		}
		Index++;
	}
	return;
}

function SearchNPC(string strSearch)
{
	local int NpcClassID;
	local string Name, MeshName, ClassName;
	local Color C;
	local bool bFindAllItem;

	C.R = 255;
	C.G = 255;
	C.B = 255;
	m_ListBoxNPC.Clear();
	m_ItemWindowNpcItem.Clear();
	NpcIdList.Length = 0;
	NpcClassID = Class'NWindow.UIDATA_NPC'.static.GetFirstID();
	while(Class'NWindow.UIDATA_NPC'.static.IsValidData(NpcClassID))
	{
		bFindAllItem = false;
		if((strSearch == ""))
		{
			bFindAllItem = true;
		}
		switch(searchMode)
		{
			case Search_NPC_NameID:
				Name = Class'NWindow.UIDATA_NPC'.static.GetNPCName(NpcClassID);
				if((((bFindAllItem == true) || (NpcClassID == int(strSearch))) || StringMatching(Name, strSearch, " ")))
				{
					m_ListBoxNPC.AddStringWithData(((("[" $ string(NpcClassID)) $ "] ") $ Name), C, NpcClassID);
					NpcIdList.Length = (NpcIdList.Length + 1);
					NpcIdList[(NpcIdList.Length - 1)] = NpcClassID;
				}
				break;
			case Search_NPC_Mesh:
				MeshName = Class'NWindow.UIDATA_NPC'.static.GetNPCMesh(NpcClassID);
				if(((bFindAllItem == true) || StringMatching(MeshName, strSearch, " ")))
				{
					m_ListBoxNPC.AddStringWithData(("" $ MeshName), C, NpcClassID);
					NpcIdList.Length = (NpcIdList.Length + 1);
					NpcIdList[(NpcIdList.Length - 1)] = NpcClassID;
				}
				break;
			case Search_NPC_Class:
				ClassName = Class'NWindow.UIDATA_NPC'.static.GetNPCClass(NpcClassID);
				if(((bFindAllItem == true) || StringMatching(ClassName, strSearch, " ")))
				{
					m_ListBoxNPC.AddStringWithData(("" $ ClassName), C, NpcClassID);
					NpcIdList.Length = (NpcIdList.Length + 1);
					NpcIdList[(NpcIdList.Length - 1)] = NpcClassID;
				}
				break;
			default:
				break;
		}
		NpcClassID = Class'NWindow.UIDATA_NPC'.static.GetNextID();
	}
	return;
}

function SearchItem(string strSearch)
{
	local ItemID cID;
	local string ItemName;
	local ItemInfo weaponItemInfo;
	local bool bFindItem;

	m_ItemWindowNpcItem.Clear();
	cID = Class'NWindow.UIDATA_ITEM'.static.GetFirstID();
	while(IsValidItemID(cID))
	{
		if((Class'NWindow.UIDATA_ITEM'.static.GetItemDataType(cID) != 0))
		{
			cID = Class'NWindow.UIDATA_ITEM'.static.GetNextID();
			continue;
		}
		bFindItem = false;
		if((strSearch == ""))
		{
			bFindItem = true;
		}
		else if((cID.ClassID == int(strSearch)))
		{
			bFindItem = true;
		}
		else
		{
			ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(cID);
			if(StringMatching(ItemName, strSearch, " "))
			{
				bFindItem = true;
			}
		}
		if((bFindItem == true))
		{
			Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cID, weaponItemInfo);
			weaponItemInfo.ShortcutType = 1;
			m_ItemWindowNpcItem.AddItem(weaponItemInfo);
		}
		cID = Class'NWindow.UIDATA_ITEM'.static.GetNextID();
	}
	return;
}

function ApplyPawnSetting()
{
	GroundSpeed = float(m_EditBoxSpeed.GetString());
	AnimRate = float(m_EditBoxAnimRate.GetString());
	CollisionRadius = float(m_EditBoxRadius.GetString());
	CollisionHeight = float(m_EditBoxHeight.GetString());
	DrawScale = float(m_EditBoxScale.GetString());
	PawnState = int(m_EditBoxState.GetString());
	Class'NWindow.UIDATA_PAWNVIEWER'.static.ApplyPawnSetting(GroundSpeed, AnimRate, CollisionRadius, CollisionHeight, DrawScale, PawnState);
	return;
}

function ApplyAutoCalcCollisionScale()
{
	local float Scale;

	Scale = float(m_EditBoxScale.GetString());
	CollisionRadius = (Scale * defaultCollisionRadius);
	CollisionHeight = ((Scale * defaultCollisionHeight) + (3.0000000 * (Scale - 1.0000000)));
	m_EditBoxRadius.SetString(("" $ string(CollisionRadius)));
	m_EditBoxHeight.SetString(("" $ string(CollisionHeight)));
	Class'NWindow.UIDATA_PAWNVIEWER'.static.ApplyPawnSetting(0.0000000, 0.0000000, CollisionRadius, CollisionHeight, Scale, 0);
	return;
}

function ReloadNPCViewerWnd()
{
	m_hWnd.SetAnchor("", "TopLeft", "TopLeft", 24, 4);
	m_ItemWindowNpcItem.Clear();
	return;
}

defaultproperties
{
	m_Windowname="NPCViewerWnd"
}
