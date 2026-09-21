class PCViewerWnd extends UICommonAPI;

const RaceType_HUMAN = 0;
const RaceType_ELF = 1;
const RaceType_DARKELF = 2;
const RaceType_ORC = 3;
const RaceType_DWARF = 4;
const RaceType_KAMAEL = 5;
const RaceType_ERTHEIA = 6;
const Sex_Male = 0;
const Sex_Female = 1;

enum BEAUTY_TYPE
{
	BEAUTY_FACE,                    // 0
	BEAUTY_HAIR,                    // 1
	BEAUTY_HAIRCOLOR                // 2
};

var string m_Windowname;
var WindowHandle m_hWnd;
var ComboBoxHandle m_ComboCharType;
var ButtonHandle m_ButtonSummon;
var ButtonHandle m_ButtonCharChange;
var TabHandle m_TabCategory;
var ComboBoxHandle m_ComboFace;
var ComboBoxHandle m_ComboHair;
var ComboBoxHandle m_ComboColor;
var ListBoxHandle m_ListBoxBeautyInfo;
var EditBoxHandle m_EditBoxHairAccOffsetX;
var EditBoxHandle m_EditBoxHairAccOffsetY;
var EditBoxHandle m_EditBoxHairAccOffsetZ;
var EditBoxHandle m_EditBoxHairAccPitch;
var EditBoxHandle m_EditBoxHairAccYaw;
var EditBoxHandle m_EditBoxHairAccRoll;
var ItemWindowHandle m_ItemWindowPCItem;
var EditBoxHandle m_EditBoxSearchItem;
var ButtonHandle m_ButtonSearchItem;
var CheckBoxHandle m_CheckBoxRefinery;
var EditBoxHandle m_EditBoxRefineryValue1;
var EditBoxHandle m_EditBoxRefineryValue2;
var EditBoxHandle m_EditBoxRefineryValue3;
var CheckBoxHandle m_CheckBoxEnchant;
var EditBoxHandle m_EditBoxEnchantValue;
var ListBoxHandle m_ListBoxItemPath;
var EditBoxHandle m_EditBoxSearchAnim;
var ButtonHandle m_ButtonSearchAnim;
var ListBoxHandle m_ListBoxAnim;
var EditBoxHandle m_EditBoxAnimSpeed;
var TextBoxHandle m_TextBoxFrame;
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
var string FaceMeshName;
var string FaceTexName;
var string AHairMeshName;
var string AHairTexName;
var string BHairMeshName;
var string BHairTexName;
var string BHairExSubTexName;
var TextBoxHandle m_TextBoxSimulationMeshName;
var ComboBoxHandle m_ComboBoxSimulAnchorVertex;
var ButtonHandle m_ButtonAddSimulAnchor;
var ButtonHandle m_ButtonRemoveSimulAnchor;
var ComboBoxHandle m_ComboBoxSimulCollision;
var ComboBoxHandle m_ComboBoxSimulColType;
var EditBoxHandle m_EditBoxSimulBoneA;
var EditBoxHandle m_EditBoxSimulBoneB;
var EditBoxHandle m_EditBoxSimulRadius;
var CheckBoxHandle m_CheckBoxSimulSphereA;
var CheckBoxHandle m_CheckBoxSimulSphereB;
var ButtonHandle m_ButtonSimulColAdd;
var ButtonHandle m_ButtonSimulColRemove;
var ButtonHandle m_ButtonSimulColUpdate;
var TextBoxHandle m_TextBoxSimulAnimSequence;
var ComboBoxHandle m_ComboBoxSimulForceIdx;
var EditBoxHandle m_EditBoxSimulWeight;
var EditBoxHandle m_EditBoxSimulForceFrame;
var EditBoxHandle m_EditBoxSimulForceStiff;
var CheckBoxHandle m_CheckBoxTerrainCollision;
var CheckBoxHandle m_CheckBoxUseForce;
var EditBoxHandle m_EditBoxSimulForceX;
var EditBoxHandle m_EditBoxSimulForceY;
var EditBoxHandle m_EditBoxSimulForceZ;
var ButtonHandle m_ButtonSimulAnimAdd;
var ButtonHandle m_ButtonSimulAnimRemove;
var ButtonHandle m_ButtonSimulAnimUpdate;
var ListBoxHandle m_ListBoxSimulWhat;
var TextBoxHandle m_TextBoxSimulMantleOffset;
var EditBoxHandle m_EditBoxSimulMantleOffsetX;
var ButtonHandle m_ButtonSimulMantleOffsetXUp;
var ButtonHandle m_ButtonSimulMantleOffsetXDown;
var EditBoxHandle m_EditBoxSimulMantleOffsetY;
var ButtonHandle m_ButtonSimulMantleOffsetYUp;
var ButtonHandle m_ButtonSimulMantleOffsetYDown;
var EditBoxHandle m_EditBoxSimulMantleOffsetZ;
var ButtonHandle m_ButtonSimulMantleOffsetZUp;
var ButtonHandle m_ButtonSimulMantleOffsetZDown;
var ButtonHandle m_ButtonSimulMantleOffsetLoad;
var ButtonHandle m_ButtonSimulMantleOffsetReset;
var ButtonHandle m_ButtonSimulMantleOffsetSave;
var int iSimulVertexNum;
var int iSimulColNum;
var array<string> SimulColTypeList;
var string sSimulColType;
var int iSimulBoneA;
var int iSimulBoneB;
var float fSimulRadius;
var byte bSimulSphereA;
var byte bSimulSphereB;
var int iSimulAnimNum;
var float iSimulWeight;
var float fSimulFrame;
var float fSimulStiff;
var byte bSimulTerrainCol;
var byte bSimulUserForce;
var Vector vSimulForce;
var string sChestMeshName;
var Vector vMantleOffset;
var EditBoxHandle m_EditBoxPCNumber;
var EditBoxHandle m_EditBoxSkillUse;
var EditBoxHandle m_EditBoxSkillStop;
var EditBoxHandle m_EditBoxPCRemove;
var EditBoxHandle m_EditBoxBowSkill;
var ButtonHandle m_ButtonTestStart;
//var delegate<SortByNameDelegate> __SortByNameDelegate__Delegate;

function OnRegisterEvent()
{
	RegisterEvent(4370);
	return;
}

function OnLoad()
{
	InitializeHandle();
	m_hWnd.SetWindowTitle("PC VIEWER");
	return;
}

function OnShow()
{
	Initialize();
	m_hWnd.ShowWindow();
	return;
}

function InitializeHandle()
{
	m_hWnd = GetWindowHandle(m_Windowname);
	m_ComboCharType = GetComboBoxHandle((m_Windowname $ ".Char_ComboBox"));
	m_ButtonSummon = GetButtonHandle((m_Windowname $ ".Spawn_Button"));
	m_ButtonCharChange = GetButtonHandle((m_Windowname $ ".Change_Button"));
	m_TabCategory = GetTabHandle((m_Windowname $ ".FunctionSelect_Tab"));
	m_ComboFace = GetComboBoxHandle((m_Windowname $ ".Face_ComboBox"));
	m_ComboHair = GetComboBoxHandle((m_Windowname $ ".Hair_ComboBox"));
	m_ComboColor = GetComboBoxHandle((m_Windowname $ ".Color_ComboBox"));
	m_ListBoxBeautyInfo = GetListBoxHandle((m_Windowname $ ".FaceHair_ListBox"));
	m_EditBoxHairAccOffsetX = GetEditBoxHandle((m_Windowname $ ".OffsetX_EditBox"));
	m_EditBoxHairAccOffsetY = GetEditBoxHandle((m_Windowname $ ".OffsetY_EditBox"));
	m_EditBoxHairAccOffsetZ = GetEditBoxHandle((m_Windowname $ ".OffsetZ_EditBox"));
	m_EditBoxHairAccPitch = GetEditBoxHandle((m_Windowname $ ".Pitch_EditBox"));
	m_EditBoxHairAccYaw = GetEditBoxHandle((m_Windowname $ ".Yaw_EditBox"));
	m_EditBoxHairAccRoll = GetEditBoxHandle((m_Windowname $ ".Roll_EditBox"));
	m_ItemWindowPCItem = GetItemWindowHandle((m_Windowname $ ".IconList_ItemWindow"));
	m_EditBoxSearchItem = GetEditBoxHandle((m_Windowname $ ".ItemSearch_EditBox"));
	m_ButtonSearchItem = GetButtonHandle((m_Windowname $ ".ItemSearch_Button"));
	m_CheckBoxRefinery = GetCheckBoxHandle((m_Windowname $ ".Variation_CheckBox"));
	m_EditBoxRefineryValue1 = GetEditBoxHandle((m_Windowname $ ".optionA_EditBox"));
	m_EditBoxRefineryValue2 = GetEditBoxHandle((m_Windowname $ ".optionB_EditBox"));
	m_EditBoxRefineryValue3 = GetEditBoxHandle((m_Windowname $ ".optionC_EditBox"));
	m_CheckBoxEnchant = GetCheckBoxHandle((m_Windowname $ ".Enchant_CheckBox"));
	m_EditBoxEnchantValue = GetEditBoxHandle((m_Windowname $ ".enchant_EditBox"));
	m_ListBoxItemPath = GetListBoxHandle((m_Windowname $ ".ItemPath_ListBox"));
	m_EditBoxSearchAnim = GetEditBoxHandle((m_Windowname $ ".SeqSearch_EditBox"));
	m_ButtonSearchAnim = GetButtonHandle((m_Windowname $ ".AnimSearch_Button"));
	m_ListBoxAnim = GetListBoxHandle((m_Windowname $ ".Seq_ListBox"));
	m_EditBoxAnimSpeed = GetEditBoxHandle((m_Windowname $ ".Speed_EditBox"));
	m_TextBoxFrame = GetTextBoxHandle((m_Windowname $ ".Frame_TextBox"));
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
	m_TextBoxSimulationMeshName = GetTextBoxHandle((m_Windowname $ ".SimMsg_TextBox"));
	m_ComboBoxSimulAnchorVertex = GetComboBoxHandle((m_Windowname $ ".VertexNum_ComboBox"));
	m_ButtonAddSimulAnchor = GetButtonHandle((m_Windowname $ ".VtxAdd_Button"));
	m_ButtonRemoveSimulAnchor = GetButtonHandle((m_Windowname $ ".VtxRemove_Button"));
	m_ComboBoxSimulCollision = GetComboBoxHandle((m_Windowname $ ".CollisionNum_ComboBox"));
	m_ComboBoxSimulColType = GetComboBoxHandle((m_Windowname $ ".CollisionType_ComboBox"));
	m_EditBoxSimulBoneA = GetEditBoxHandle((m_Windowname $ ".BoneA_EditBox"));
	m_EditBoxSimulBoneB = GetEditBoxHandle((m_Windowname $ ".BoneB_EditBox"));
	m_EditBoxSimulRadius = GetEditBoxHandle((m_Windowname $ ".Radius_EditBox"));
	m_CheckBoxSimulSphereA = GetCheckBoxHandle((m_Windowname $ ".SphereA_CheckBox"));
	m_CheckBoxSimulSphereB = GetCheckBoxHandle((m_Windowname $ ".SphereB_CheckBox"));
	m_ButtonSimulColAdd = GetButtonHandle((m_Windowname $ ".ColAdd_Button"));
	m_ButtonSimulColRemove = GetButtonHandle((m_Windowname $ ".ColRemove_Button"));
	m_ButtonSimulColUpdate = GetButtonHandle((m_Windowname $ ".ColUpdate_Button"));
	m_TextBoxSimulAnimSequence = GetTextBoxHandle((m_Windowname $ ".AnimMsg_TextBox"));
	m_ComboBoxSimulForceIdx = GetComboBoxHandle((m_Windowname $ ".ForceIdx_ComboBox"));
	m_EditBoxSimulWeight = GetEditBoxHandle((m_Windowname $ ".Weight_EditBox"));
	m_EditBoxSimulForceFrame = GetEditBoxHandle((m_Windowname $ ".ForceFrame_EditBox"));
	m_EditBoxSimulForceStiff = GetEditBoxHandle((m_Windowname $ ".Stiff_EditBox"));
	m_CheckBoxTerrainCollision = GetCheckBoxHandle((m_Windowname $ ".Terrain_CheckBox"));
	m_CheckBoxUseForce = GetCheckBoxHandle((m_Windowname $ ".UseForce_CheckBox"));
	m_EditBoxSimulForceX = GetEditBoxHandle((m_Windowname $ ".ForceX_EditBox"));
	m_EditBoxSimulForceY = GetEditBoxHandle((m_Windowname $ ".ForceY_EditBox"));
	m_EditBoxSimulForceZ = GetEditBoxHandle((m_Windowname $ ".ForceZ_EditBox"));
	m_ButtonSimulAnimAdd = GetButtonHandle((m_Windowname $ ".ForceAdd_Button"));
	m_ButtonSimulAnimRemove = GetButtonHandle((m_Windowname $ ".ForceRem_Button"));
	m_ButtonSimulAnimUpdate = GetButtonHandle((m_Windowname $ ".ForceUpdate_Button"));
	m_TextBoxSimulMantleOffset = GetTextBoxHandle((m_Windowname $ ".ChestMesh_TextBox"));
	m_EditBoxSimulMantleOffsetX = GetEditBoxHandle((m_Windowname $ ".MantleOffsetX_EditBox"));
	m_ButtonSimulMantleOffsetXUp = GetButtonHandle((m_Windowname $ ".PlusX_Button"));
	m_ButtonSimulMantleOffsetXDown = GetButtonHandle((m_Windowname $ ".MinusX_Button"));
	m_EditBoxSimulMantleOffsetY = GetEditBoxHandle((m_Windowname $ ".MantleOffsetY_EditBox"));
	m_ButtonSimulMantleOffsetYUp = GetButtonHandle((m_Windowname $ ".PlusY_Button"));
	m_ButtonSimulMantleOffsetYDown = GetButtonHandle((m_Windowname $ ".MinusY_Button"));
	m_EditBoxSimulMantleOffsetZ = GetEditBoxHandle((m_Windowname $ ".MantleOffsetZ_EditBox"));
	m_ButtonSimulMantleOffsetZUp = GetButtonHandle((m_Windowname $ ".PlusZ_Button"));
	m_ButtonSimulMantleOffsetZDown = GetButtonHandle((m_Windowname $ ".MinusZ_Button"));
	m_ButtonSimulMantleOffsetLoad = GetButtonHandle((m_Windowname $ ".SimLoad_Button"));
	m_ButtonSimulMantleOffsetReset = GetButtonHandle((m_Windowname $ ".SimReset_Button"));
	m_ButtonSimulMantleOffsetSave = GetButtonHandle((m_Windowname $ ".SimSave_Button"));
	m_EditBoxPCNumber = GetEditBoxHandle((m_Windowname $ ".PCNumber_EditBox"));
	m_EditBoxSkillUse = GetEditBoxHandle((m_Windowname $ ".SkillUse_EditBox"));
	m_EditBoxSkillStop = GetEditBoxHandle((m_Windowname $ ".SkillStop_EditBox"));
	m_EditBoxPCRemove = GetEditBoxHandle((m_Windowname $ ".PCRemove_EditBox"));
	m_EditBoxBowSkill = GetEditBoxHandle((m_Windowname $ ".BowSkill_EditBox"));
	m_ButtonTestStart = GetButtonHandle((m_Windowname $ ".TestStart_Button"));
	return;
}

function OnEvent(int a_EventID, string param)
{
	switch(a_EventID)
	{
		case 4370:
			ReloadPCViewerWnd();
			break;
		default:
			break;
	}
	return;
}

function Initialize()
{
	SetClassComboBox();
	SetHairAccOffset();
	m_EditBoxAnimSpeed.SetString("1.0");
	m_EditBoxHitTime.SetString("1.8");
	m_EditBoxLoopIdx.SetString("-1");
	SearchAnimation("");
	return;
}

function OnDBClickListBoxItem(string strID, int SelectedIndex)
{
	local string SelectedStr;
	local float AnimSpeed;

	switch(strID)
	{
		case "Seq_ListBox":
			SelectedStr = m_ListBoxAnim.GetSelectedString();
			AnimSpeed = float(m_EditBoxAnimSpeed.GetString());
			Class'NWindow.UIDATA_PAWNVIEWER'.static.PlayPCAnim(SelectedStr, AnimSpeed);
			break;
		default:
			break;
	}
	return;
}

function OnLButtonClickListBoxItem(string strID, int SelectedIndex)
{
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
				EquipPCItem(Info);
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
				EquipPCItem(Info);
				break;
			default:
				break;
		}
	}
	return;
}

function HairAccOffsetRefresh()
{
	local float OffsetX, OffsetY, OffsetZ, Pitch, Yaw, Roll;

	OffsetX = float(m_EditBoxHairAccOffsetX.GetString());
	OffsetY = float(m_EditBoxHairAccOffsetY.GetString());
	OffsetZ = float(m_EditBoxHairAccOffsetZ.GetString());
	Pitch = float(m_EditBoxHairAccPitch.GetString());
	Yaw = float(m_EditBoxHairAccYaw.GetString());
	Roll = float(m_EditBoxHairAccRoll.GetString());
	Class'NWindow.UIDATA_PAWNVIEWER'.static.AdjustHairAccOffset(OffsetX, OffsetY, OffsetZ, Pitch, Yaw, Roll);
	return;
}

event bool OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
	local string EditBoxStr;

	switch(nKey)
	{
		case IK_Enter:
			if(m_EditBoxSearchItem.IsFocused())
			{
				EditBoxStr = m_EditBoxSearchItem.GetString();
				SearchItem(EditBoxStr);
			}
			else if(m_EditBoxSimulMantleOffsetX.IsFocused())
			{
				vMantleOffset.X = float(m_EditBoxSimulMantleOffsetX.GetString());
				Class'NWindow.UIDATA_PAWNVIEWER'.static.SetMantleOffset(vMantleOffset);
			}
			else if(m_EditBoxSimulMantleOffsetY.IsFocused())
			{
				vMantleOffset.Y = float(m_EditBoxSimulMantleOffsetY.GetString());
				Class'NWindow.UIDATA_PAWNVIEWER'.static.SetMantleOffset(vMantleOffset);
			}
			else if(m_EditBoxSimulMantleOffsetZ.IsFocused())
			{
				vMantleOffset.Z = float(m_EditBoxSimulMantleOffsetZ.GetString());
				Class'NWindow.UIDATA_PAWNVIEWER'.static.SetMantleOffset(vMantleOffset);
			}
			else if(m_EditBoxSearchAnim.IsFocused())
			{
				EditBoxStr = m_EditBoxSearchAnim.GetString();
				SearchAnimation(EditBoxStr);
			}
			else if(m_EditBoxHairAccOffsetX.IsFocused())
			{
				HairAccOffsetRefresh();
			}
			else if(m_EditBoxHairAccOffsetY.IsFocused())
			{
				HairAccOffsetRefresh();
			}
			else if(m_EditBoxHairAccOffsetZ.IsFocused())
			{
				HairAccOffsetRefresh();
			}
			else if(m_EditBoxHairAccPitch.IsFocused())
			{
				HairAccOffsetRefresh();
			}
			else if(m_EditBoxHairAccYaw.IsFocused())
			{
				HairAccOffsetRefresh();
			}
			else if(m_EditBoxHairAccRoll.IsFocused())
			{
				HairAccOffsetRefresh();
			}
			break;
		default:
			break;
	}
	return false;
}

function OnComboBoxItemSelected(string strID, int Index)
{
	local string CharStr;
	local int SelectedValue;

	switch(strID)
	{
		case "Char_ComboBox":
			CharStr = m_ComboCharType.GetString(Index);
			Class'NWindow.UIDATA_PAWNVIEWER'.static.SpawnCharacter(("LineageWarrior." $ CharStr));
			SetBeautyComboBox(BEAUTY_FACE);
			SetBeautyComboBox(BEAUTY_HAIR);
			SetBeautyComboBox(BEAUTY_HAIRCOLOR);
			SearchAnimation("");
			break;
		case "Face_ComboBox":
			SelectedValue = int(m_ComboFace.GetString(Index));
			ApplyBeauty(BEAUTY_FACE, SelectedValue);
			break;
		case "Hair_ComboBox":
			SelectedValue = int(m_ComboHair.GetString(Index));
			ApplyBeauty(BEAUTY_HAIR, SelectedValue);
			SetBeautyComboBox(BEAUTY_HAIRCOLOR);
			break;
		case "Color_ComboBox":
			SelectedValue = int(m_ComboColor.GetString(Index));
			ApplyBeauty(BEAUTY_HAIRCOLOR, SelectedValue);
			break;
		case "CollisionNum_ComboBox":
			SelectedValue = int(m_ComboBoxSimulCollision.GetString(Index));
			SetSimulationCollisionUI(SelectedValue);
			break;
		case "ForceIdx_ComboBox":
			Class'NWindow.UIDATA_PAWNVIEWER'.static.GetAnimForceInfo(m_ComboBoxSimulForceIdx.GetSelectedNum(), iSimulWeight, fSimulFrame, fSimulStiff, bSimulTerrainCol, bSimulUserForce, vSimulForce);
			m_EditBoxSimulWeight.SetString(("" $ string(iSimulWeight)));
			m_EditBoxSimulForceFrame.SetString(("" $ string(fSimulFrame)));
			m_EditBoxSimulForceStiff.SetString(("" $ string(fSimulStiff)));
			m_CheckBoxTerrainCollision.SetCheck(bool(bSimulTerrainCol));
			m_CheckBoxUseForce.SetCheck(bool(bSimulUserForce));
			m_EditBoxSimulForceX.SetString(("" $ string(vSimulForce.X)));
			m_EditBoxSimulForceY.SetString(("" $ string(vSimulForce.Y)));
			m_EditBoxSimulForceZ.SetString(("" $ string(vSimulForce.Z)));
		default:
			break;
	}
	return;
}

function OnClickCheckBox(string strID)
{
	return;
}

function OnClickButton(string strID)
{
	local string EditBoxStr;
	local int SelectedIndex;
	local float frame, Duration, Dues;
	local int Index;
	local Color TextLoadColor;

	TextLoadColor.R = 255;
	TextLoadColor.G = 255;
	TextLoadColor.B = 150;
	switch(strID)
	{
		case "Spawn_Button":
			Class'NWindow.UIDATA_PAWNVIEWER'.static.DuplicateCharacter();
			break;
		case "Change_Button":
			Class'NWindow.UIDATA_PAWNVIEWER'.static.ChangeMyPC();
			break;
		case "ItemSearch_Button":
			EditBoxStr = m_EditBoxSearchItem.GetString();
			SearchItem(EditBoxStr);
			break;
		case "AnimSearch_Button":
			EditBoxStr = m_EditBoxSearchAnim.GetString();
			SearchAnimation(EditBoxStr);
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
			m_TextBoxFrame.SetText((("Frame: " $ string(frame)) $ "/10.0"));
			break;
		case "VtxAdd_Button":
			SelectedIndex = m_ComboBoxSimulAnchorVertex.GetSelectedNum();
			Class'NWindow.UIDATA_PAWNVIEWER'.static.AddAnchorVertex();
			iSimulVertexNum = Class'NWindow.UIDATA_PAWNVIEWER'.static.GetVertexNumber();
			m_ComboBoxSimulAnchorVertex.Clear();
			Index = 0;
			while((Index < iSimulVertexNum))
			{
				m_ComboBoxSimulAnchorVertex.AddString(("" $ string(Index)));
				++Index;
			}
			m_ComboBoxSimulAnchorVertex.SetSelectedNum(SelectedIndex);
			break;
		case "VtxRemove_Button":
			SelectedIndex = m_ComboBoxSimulAnchorVertex.GetSelectedNum();
			Class'NWindow.UIDATA_PAWNVIEWER'.static.RemoveAnchorVertex();
			iSimulVertexNum = Class'NWindow.UIDATA_PAWNVIEWER'.static.GetVertexNumber();
			m_ComboBoxSimulAnchorVertex.Clear();
			Index = 0;
			while((Index < iSimulVertexNum))
			{
				m_ComboBoxSimulAnchorVertex.AddString(("" $ string(Index)));
				++Index;
			}
			m_ComboBoxSimulAnchorVertex.SetSelectedNum(SelectedIndex);
			break;
		case "ColAdd_Button":
			Index = m_ComboBoxSimulColType.GetSelectedNum();
			Class'NWindow.UIDATA_PAWNVIEWER'.static.AddCollision(m_ComboBoxSimulColType.GetString(Index), int(float(m_EditBoxSimulBoneA.GetString())), int(float(m_EditBoxSimulBoneB.GetString())), float(m_EditBoxSimulRadius.GetString()), m_CheckBoxSimulSphereA.IsChecked(), m_CheckBoxSimulSphereB.IsChecked());
			SetSimulationCollisionTypeUI(Index);
			break;
		case "ColRemove_Button":
			Class'NWindow.UIDATA_PAWNVIEWER'.static.RemoveCollision(m_ComboBoxSimulCollision.GetSelectedNum());
			SetSimulationCollisionTypeUI(0);
			break;
		case "ColUpdate_Button":
			Index = m_ComboBoxSimulColType.GetSelectedNum();
			Class'NWindow.UIDATA_PAWNVIEWER'.static.UpdateCollision(m_ComboBoxSimulCollision.GetSelectedNum(), m_ComboBoxSimulColType.GetString(Index), int(float(m_EditBoxSimulBoneA.GetString())), int(float(m_EditBoxSimulBoneB.GetString())), float(m_EditBoxSimulRadius.GetString()), m_CheckBoxSimulSphereA.IsChecked(), m_CheckBoxSimulSphereB.IsChecked());
			break;
		case "ForceAdd_Button":
			vSimulForce.X = float(m_EditBoxSimulForceX.GetString());
			vSimulForce.Y = float(m_EditBoxSimulForceY.GetString());
			vSimulForce.Z = float(m_EditBoxSimulForceZ.GetString());
			Class'NWindow.UIDATA_PAWNVIEWER'.static.AddAnimForce(float(m_EditBoxSimulWeight.GetString()), float(m_EditBoxSimulForceFrame.GetString()), float(m_EditBoxSimulForceStiff.GetString()), m_CheckBoxTerrainCollision.IsChecked(), m_CheckBoxUseForce.IsChecked(), vSimulForce);
			SetAnimSimulationUI(TextLoadColor);
			break;
		case "ForceRem_Button":
			Class'NWindow.UIDATA_PAWNVIEWER'.static.RemoveAnimForce(m_ComboBoxSimulForceIdx.GetSelectedNum());
			SetAnimSimulationUI(TextLoadColor);
			break;
		case "ForceUpdate_Button":
			vSimulForce.X = float(m_EditBoxSimulForceX.GetString());
			vSimulForce.Y = float(m_EditBoxSimulForceY.GetString());
			vSimulForce.Z = float(m_EditBoxSimulForceZ.GetString());
			Class'NWindow.UIDATA_PAWNVIEWER'.static.UpdateAnimForce(m_ComboBoxSimulForceIdx.GetSelectedNum(), float(m_EditBoxSimulWeight.GetString()), float(m_EditBoxSimulForceFrame.GetString()), float(m_EditBoxSimulForceStiff.GetString()), m_CheckBoxTerrainCollision.IsChecked(), m_CheckBoxUseForce.IsChecked(), vSimulForce);
			break;
		case "PlusX_Button":
			vMantleOffset.X = (vMantleOffset.X + 1.0000000);
			m_EditBoxSimulMantleOffsetX.SetString(("" $ string(vMantleOffset.X)));
			Class'NWindow.UIDATA_PAWNVIEWER'.static.SetMantleOffset(vMantleOffset);
			break;
		case "MinusX_Button":
			vMantleOffset.X = (vMantleOffset.X - 1.0000000);
			m_EditBoxSimulMantleOffsetX.SetString(("" $ string(vMantleOffset.X)));
			Class'NWindow.UIDATA_PAWNVIEWER'.static.SetMantleOffset(vMantleOffset);
			break;
		case "PlusY_Button":
			vMantleOffset.Y = (vMantleOffset.Y + 1.0000000);
			m_EditBoxSimulMantleOffsetY.SetString(("" $ string(vMantleOffset.Y)));
			Class'NWindow.UIDATA_PAWNVIEWER'.static.SetMantleOffset(vMantleOffset);
			break;
		case "MinusY_Button":
			vMantleOffset.Y = (vMantleOffset.Y - 1.0000000);
			m_EditBoxSimulMantleOffsetY.SetString(("" $ string(vMantleOffset.Y)));
			Class'NWindow.UIDATA_PAWNVIEWER'.static.SetMantleOffset(vMantleOffset);
			break;
		case "PlusZ_Button":
			vMantleOffset.Z = (vMantleOffset.Z + 1.0000000);
			m_EditBoxSimulMantleOffsetZ.SetString(("" $ string(vMantleOffset.Z)));
			Class'NWindow.UIDATA_PAWNVIEWER'.static.SetMantleOffset(vMantleOffset);
			break;
		case "MinusZ_Button":
			vMantleOffset.Z = (vMantleOffset.Z - 1.0000000);
			m_EditBoxSimulMantleOffsetZ.SetString(("" $ string(vMantleOffset.Z)));
			Class'NWindow.UIDATA_PAWNVIEWER'.static.SetMantleOffset(vMantleOffset);
			break;
		case "SimLoad_Button":
			LoadSimulationMesh();
			break;
		case "SimReset_Button":
			Class'NWindow.UIDATA_PAWNVIEWER'.static.ResetSimulMesh();
			LoadSimulationMesh();
			break;
		case "SimSave_Button":
			Class'NWindow.UIDATA_PAWNVIEWER'.static.SaveSimulMesh();
			break;
		case "TestStart_Button":
			Class'NWindow.UIDATA_PAWNVIEWER'.static.SetPawnNum(int(m_EditBoxPCNumber.GetString()));
			Class'NWindow.UIDATA_PAWNVIEWER'.static.SetSkillUseRatio(float(m_EditBoxSkillUse.GetString()));
			Class'NWindow.UIDATA_PAWNVIEWER'.static.SetSkillCancelRatio(float(m_EditBoxSkillStop.GetString()));
			Class'NWindow.UIDATA_PAWNVIEWER'.static.SetSkillDeleteRatio(float(m_EditBoxPCRemove.GetString()));
			Class'NWindow.UIDATA_PAWNVIEWER'.static.SetArrowRatio(float(m_EditBoxBowSkill.GetString()));
			Class'NWindow.UIDATA_PAWNVIEWER'.static.StartSimulPawn();
			break;
		default:
			break;
	}
	return;
}

function SetClassComboBox()
{
	local array<string> CharTypeArray;
	local int CharTypeIndex;
	local array<string> ClassNames;
	local int SelectedIndex;

	m_ComboCharType.Clear();
	Class'NWindow.UIDATA_PAWNVIEWER'.static.GetClassNameList(CharTypeArray, SelectedIndex);
	CharTypeIndex = 0;
	while((CharTypeIndex < CharTypeArray.Length))
	{
		ClassNames.Length = 0;
		Split(CharTypeArray[CharTypeIndex], ".", ClassNames);
		m_ComboCharType.AddString(ClassNames[1]);
		++CharTypeIndex;
	}
	m_ComboCharType.SetSelectedNum(SelectedIndex);
	SetBeautyComboBox(BEAUTY_FACE);
	SetBeautyComboBox(BEAUTY_HAIR);
	SetBeautyComboBox(BEAUTY_HAIRCOLOR);
	return;
}

function SetHairAccOffset()
{
	local float OffsetX, OffsetY, OffsetZ, Pitch, Yaw, Roll;

	Class'NWindow.UIDATA_PAWNVIEWER'.static.GetHairAccOffset(OffsetX, OffsetY, OffsetZ, Pitch, Yaw, Roll);
	m_EditBoxHairAccOffsetX.SetString(string(OffsetX));
	m_EditBoxHairAccOffsetY.SetString(string(OffsetY));
	m_EditBoxHairAccOffsetZ.SetString(string(OffsetZ));
	m_EditBoxHairAccPitch.SetString(string(Pitch));
	m_EditBoxHairAccYaw.SetString(string(Yaw));
	m_EditBoxHairAccRoll.SetString(string(Roll));
	return;
}

function SetBeautyComboBox(BEAUTY_TYPE Type)
{
	local int Index;
	local array<int> ComboBoxDataList;
	local int defaultFaceNum, defaultHairNum, defaultHairColorNum;
	local UserInfo User;

	switch(Type)
	{
		case BEAUTY_FACE:
			m_ComboFace.Clear();
			defaultFaceNum = 3;
			Index = 0;
			while((Index < defaultFaceNum))
			{
				m_ComboFace.AddString(string(Index));
				++Index;
			}
			Class'NWindow.UIDATA_PAWNVIEWER'.static.GetExceptionalFaceList(ComboBoxDataList);
			Index = 0;
			while((Index < ComboBoxDataList.Length))
			{
				m_ComboFace.AddString(string(ComboBoxDataList[Index]));
				++Index;
			}
			m_ComboFace.SetSelectedNum(0);
			ApplyBeauty(Type, int(m_ComboFace.GetString(0)));
			break;
		case BEAUTY_HAIR:
			GetPlayerInfo(User);
			m_ComboHair.Clear();
			if((User.nSex == 0))
			{
				defaultHairNum = 5;
			}
			else
			{
				defaultHairNum = 7;
			}
			Index = 0;
			while((Index < defaultHairNum))
			{
				m_ComboHair.AddString(string(Index));
				++Index;
			}
			Class'NWindow.UIDATA_PAWNVIEWER'.static.GetExceptionallHairList(ComboBoxDataList);
			Index = 0;
			while((Index < ComboBoxDataList.Length))
			{
				m_ComboHair.AddString(string(ComboBoxDataList[Index]));
				++Index;
			}
			m_ComboHair.SetSelectedNum(0);
			ApplyBeauty(Type, int(m_ComboHair.GetString(0)));
			break;
		case BEAUTY_HAIRCOLOR:
			m_ComboColor.Clear();
			Class'NWindow.UIDATA_PAWNVIEWER'.static.GetExceptionalHairColorList(ComboBoxDataList);
			Index = 0;
			while((Index < ComboBoxDataList.Length))
			{
				m_ComboColor.AddString(string(ComboBoxDataList[Index]));
				++Index;
			}
			m_ComboColor.SetSelectedNum(0);
			if((ComboBoxDataList.Length == 0))
			{
				GetPlayerInfo(User);
				if(((User.Race == 6) || (User.Race == 5)))
				{
					defaultHairColorNum = 3;
				}
				else
				{
					defaultHairColorNum = 4;
				}
				Index = 0;
				while((Index < defaultHairColorNum))
				{
					m_ComboColor.AddString(string(Index));
					++Index;
				}
			}
			ApplyBeauty(Type, int(m_ComboHair.GetString(0)));
			break;
		default:
			return;
	}
	return;
}

function ApplyBeauty(BEAUTY_TYPE Type, int Value)
{
	switch(Type)
	{
		case BEAUTY_FACE:
			Class'NWindow.UIDATA_PAWNVIEWER'.static.ApplyFace(Value);
			break;
		case BEAUTY_HAIR:
			Class'NWindow.UIDATA_PAWNVIEWER'.static.ApplyHair(Value);
			break;
		case BEAUTY_HAIRCOLOR:
			Class'NWindow.UIDATA_PAWNVIEWER'.static.ApplyHairColor(Value);
			break;
		default:
			return;
	}
	SetBeautyMeshAndTexInfo();
	return;
}

function EquipPCItem(ItemInfo Info)
{
	local Color C;
	local array<string> MeshNameList, TexNameList, ExMeshNameList, ExTexNameList;
	local int Index, MeshType;

	Class'NWindow.UIDATA_PAWNVIEWER'.static.EquipPCItem(Info.Id);
	SetHairAccOffset();
	if(m_CheckBoxRefinery.IsChecked())
	{
		Class'NWindow.UIDATA_PAWNVIEWER'.static.ApplyItemRefinery(Info.Id.ClassID, int(m_EditBoxRefineryValue1.GetString()), int(m_EditBoxRefineryValue2.GetString()), int(m_EditBoxRefineryValue3.GetString()));
	}
	if(m_CheckBoxEnchant.IsChecked())
	{
		Class'NWindow.UIDATA_PAWNVIEWER'.static.ApplyItemEnchanted(Info.Id.ClassID, int(m_EditBoxEnchantValue.GetString()));
	}
	m_ListBoxItemPath.Clear();
	MeshType = Class'NWindow.UIDATA_PLAYER'.static.GetMeshType();
	C.R = 255;
	C.G = 255;
	C.B = 150;
	Class'NWindow.UIDATA_ITEM'.static.GetTextureName(Info.Id, MeshType, TexNameList);
	Index = 0;
	while((Index < TexNameList.Length))
	{
		m_ListBoxItemPath.AddStringWithData(TexNameList[Index], C, 0);
		++Index;
	}
	C.R = 255;
	C.G = 255;
	C.B = 200;
	Class'NWindow.UIDATA_ITEM'.static.GetExTextureName(Info.Id, MeshType, ExTexNameList);
	Index = 0;
	while((Index < ExTexNameList.Length))
	{
		m_ListBoxItemPath.AddStringWithData((ExTexNameList[Index] $ "(Extra)"), C, 0);
		++Index;
	}
	C.R = 255;
	C.G = 150;
	C.B = 255;
	Class'NWindow.UIDATA_ITEM'.static.GetMeshName(Info.Id, MeshType, MeshNameList);
	Index = 0;
	while((Index < MeshNameList.Length))
	{
		m_ListBoxItemPath.AddStringWithData(MeshNameList[Index], C, 0);
		++Index;
	}
	C.R = 255;
	C.G = 200;
	C.B = 255;
	Class'NWindow.UIDATA_ITEM'.static.GetExMeshName(Info.Id, MeshType, ExMeshNameList);
	Index = 0;
	while((Index < ExMeshNameList.Length))
	{
		m_ListBoxItemPath.AddStringWithData((ExMeshNameList[Index] $ "(Extra)"), C, 0);
		++Index;
	}
	return;
}

function SetBeautyMeshAndTexInfo()
{
	local Color C;

	m_ListBoxBeautyInfo.Clear();
	FaceMeshName = "";
	FaceTexName = "";
	AHairMeshName = "";
	AHairTexName = "";
	BHairMeshName = "";
	BHairTexName = "";
	BHairExSubTexName = "";
	Class'NWindow.UIDATA_PAWNVIEWER'.static.GetFaceInfo(FaceMeshName, FaceTexName);
	Class'NWindow.UIDATA_PAWNVIEWER'.static.GetAHairInfo(AHairMeshName, AHairTexName);
	Class'NWindow.UIDATA_PAWNVIEWER'.static.GetBHairInfo(BHairMeshName, BHairTexName, BHairExSubTexName);
	C.R = 255;
	C.G = 255;
	C.B = 150;
	m_ListBoxBeautyInfo.AddStringWithData(FaceMeshName, C, 0);
	m_ListBoxBeautyInfo.AddStringWithData(FaceTexName, C, 0);
	C.R = 255;
	C.G = 150;
	C.B = 255;
	m_ListBoxBeautyInfo.AddStringWithData(AHairMeshName, C, 0);
	m_ListBoxBeautyInfo.AddStringWithData(AHairTexName, C, 0);
	C.R = 150;
	C.G = 255;
	C.B = 255;
	m_ListBoxBeautyInfo.AddStringWithData(BHairMeshName, C, 0);
	m_ListBoxBeautyInfo.AddStringWithData(BHairTexName, C, 0);
	m_ListBoxBeautyInfo.AddStringWithData(BHairExSubTexName, C, 0);
	return;
}

function SearchItem(string strSearch)
{
	local ItemID cID;
	local string ItemName;
	local ItemInfo ItemInfo;
	local bool bFindItem;

	m_ItemWindowPCItem.Clear();
	cID = Class'NWindow.UIDATA_ITEM'.static.GetFirstID();
	while(IsValidItemID(cID))
	{
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
			Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cID, ItemInfo);
			if((((ItemInfo.ItemType == 1) || (ItemInfo.ItemType == 0)) || (ItemInfo.ItemType == 2)))
			{
				ItemInfo.ShortcutType = 1;
				m_ItemWindowPCItem.AddItem(ItemInfo);
			}
		}
		cID = Class'NWindow.UIDATA_ITEM'.static.GetNextID();
	}
	return;
}

function SearchAnimation(string Str)
{
	local array<string> AnimList;
	local int Index;

	m_ListBoxAnim.Clear();
	Class'NWindow.UIDATA_PAWNVIEWER'.static.GetPCAnimationList(AnimList);
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

function LoadSimulationMesh()
{
	local Color TextLoadColor;

	TextLoadColor.R = 255;
	TextLoadColor.G = 255;
	TextLoadColor.B = 150;
	Class'NWindow.UIDATA_PAWNVIEWER'.static.LoadSimulMesh();
	SetSimulationMeshUI(TextLoadColor);
	SetSimulationCollisionTypeUI(0);
	SetSimulationCollisionUI(0);
	SetAnimSimulationUI(TextLoadColor);
	SetMantleOffsetUI(TextLoadColor);
	return;
}

function SetSimulationMeshUI(Color TextLoadColor)
{
	local int Index;
	local string SimulMeshName;

	SimulMeshName = Class'NWindow.UIDATA_PAWNVIEWER'.static.GetSimulMeshName();
	m_TextBoxSimulationMeshName.SetText(SimulMeshName);
	m_TextBoxSimulationMeshName.SetTextColor(TextLoadColor);
	iSimulVertexNum = Class'NWindow.UIDATA_PAWNVIEWER'.static.GetVertexNumber();
	m_ComboBoxSimulAnchorVertex.Clear();
	Index = 0;
	while((Index < iSimulVertexNum))
	{
		m_ComboBoxSimulAnchorVertex.AddString(("" $ string(Index)));
		++Index;
	}
	m_ComboBoxSimulAnchorVertex.SetSelectedNum(0);
	return;
}

function SetSimulationCollisionTypeUI(int CollisionTypeIndex)
{
	local int Index;

	SimulColTypeList.Length = 0;
	iSimulColNum = Class'NWindow.UIDATA_PAWNVIEWER'.static.GetCollisionNumber();
	Class'NWindow.UIDATA_PAWNVIEWER'.static.GetCollisionType(SimulColTypeList);
	m_ComboBoxSimulCollision.Clear();
	Index = 0;
	while((Index < iSimulColNum))
	{
		m_ComboBoxSimulCollision.AddString(("" $ string(Index)));
		++Index;
	}
	m_ComboBoxSimulCollision.SetSelectedNum(CollisionTypeIndex);
	return;
}

function SetSimulationCollisionUI(int CollisionIndex)
{
	local int Index, ColTypeIndex;

	ColTypeIndex = 0;
	Class'NWindow.UIDATA_PAWNVIEWER'.static.GetCollisionInfo(CollisionIndex, sSimulColType, iSimulBoneA, iSimulBoneB, fSimulRadius, bSimulSphereA, bSimulSphereB);
	m_ComboBoxSimulColType.Clear();
	Index = 0;
	while((Index < SimulColTypeList.Length))
	{
		if((sSimulColType == SimulColTypeList[Index]))
		{
			ColTypeIndex = Index;
		}
		m_ComboBoxSimulColType.AddString(("" $ SimulColTypeList[Index]));
		++Index;
	}
	m_ComboBoxSimulColType.SetSelectedNum(ColTypeIndex);
	m_EditBoxSimulBoneA.SetString(("" $ string(iSimulBoneA)));
	m_EditBoxSimulBoneB.SetString(("" $ string(iSimulBoneB)));
	m_EditBoxSimulRadius.SetString(("" $ string(fSimulRadius)));
	m_CheckBoxSimulSphereA.SetCheck(bool(bSimulSphereA));
	m_CheckBoxSimulSphereB.SetCheck(bool(bSimulSphereB));
	return;
}

function SetAnimSimulationUI(Color TextLoadColor)
{
	local int Index;
	local string SimulAnimName;

	iSimulAnimNum = Class'NWindow.UIDATA_PAWNVIEWER'.static.GetAnimForceNumber();
	m_TextBoxSimulAnimSequence.SetText(SimulAnimName);
	m_TextBoxSimulAnimSequence.SetTextColor(TextLoadColor);
	m_ComboBoxSimulForceIdx.Clear();
	Index = 0;
	while((Index < iSimulAnimNum))
	{
		m_ComboBoxSimulForceIdx.AddString(("" $ string(Index)));
		++Index;
	}
	m_ComboBoxSimulForceIdx.SetSelectedNum(0);
	Class'NWindow.UIDATA_PAWNVIEWER'.static.GetAnimForceInfo(0, iSimulWeight, fSimulFrame, fSimulStiff, bSimulTerrainCol, bSimulUserForce, vSimulForce);
	m_EditBoxSimulWeight.SetString(("" $ string(iSimulWeight)));
	m_EditBoxSimulForceFrame.SetString(("" $ string(fSimulFrame)));
	m_EditBoxSimulForceStiff.SetString(("" $ string(fSimulStiff)));
	m_CheckBoxTerrainCollision.SetCheck(bool(bSimulTerrainCol));
	m_CheckBoxUseForce.SetCheck(bool(bSimulUserForce));
	m_EditBoxSimulForceX.SetString(("" $ string(vSimulForce.X)));
	m_EditBoxSimulForceY.SetString(("" $ string(vSimulForce.Y)));
	m_EditBoxSimulForceZ.SetString(("" $ string(vSimulForce.Z)));
	return;
}

function SetMantleOffsetUI(Color TextLoadColor)
{
	sChestMeshName = Class'NWindow.UIDATA_PAWNVIEWER'.static.GetChestMesh();
	vMantleOffset = Class'NWindow.UIDATA_PAWNVIEWER'.static.GetMantleOffset();
	m_TextBoxSimulMantleOffset.SetText(sChestMeshName);
	m_TextBoxSimulMantleOffset.SetTextColor(TextLoadColor);
	m_EditBoxSimulMantleOffsetX.SetString(("" $ string(vMantleOffset.X)));
	m_EditBoxSimulMantleOffsetY.SetString(("" $ string(vMantleOffset.Y)));
	m_EditBoxSimulMantleOffsetZ.SetString(("" $ string(vMantleOffset.Z)));
	return;
}

function ReloadPCViewerWnd()
{
	m_hWnd.SetAnchor("", "TopLeft", "TopLeft", 24, 4);
	m_ItemWindowPCItem.Clear();
	return;
}

defaultproperties
{
	m_Windowname="PCViewerWnd"
}
