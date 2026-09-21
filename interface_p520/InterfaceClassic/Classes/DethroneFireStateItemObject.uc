class DethroneFireStateItemObject extends UICommonAPI
	dependson(UIPacket);

enum cState
{
	READY,                          // 0
	Spawn,                          // 1
	Success,                        // 2
	DESPAWN                         // 3
};

var UIPacket._HolyFire _info;
var bool _openedWnd;
var WindowHandle Me;
var UIControlNeedItemList needItemListScript;
var TextBoxHandle stateTextBox;
var TextBoxHandle descTextBox;
var TextBoxHandle timeTextBox;
var TextBoxHandle emptyRewardTextBox;
var EffectViewportWndHandle effectViewport;
var StatusRoundHandle timeStatusRound;
var TextureHandle fireBackTex;
var TextureHandle titleBackTex;
var TextureHandle rewardNoneTex;
var TextureHandle successBorderTex;

function Init(WindowHandle ownerWnd)
{
	local string ownerFullPath;

	Me = ownerWnd;
	ownerFullPath = ownerWnd.m_WindowNameWithFullPath;
	needItemListScript = new Class'InterfaceClassic.UIControlNeedItemList';
	needItemListScript.SetRichListControler(GetRichListCtrlHandle((ownerFullPath $ ".Reward_RichList")));
	needItemListScript.SetHideMyNum(true);
	timeTextBox = GetTextBoxHandle((ownerFullPath $ ".Time_Txt"));
	stateTextBox = GetTextBoxHandle((ownerFullPath $ ".Title_Txt"));
	descTextBox = GetTextBoxHandle((ownerFullPath $ ".Desc_Txt"));
	effectViewport = GetEffectViewportWndHandle((ownerFullPath $ ".ObjectViewport"));
	timeStatusRound = GetStatusRoundHandle((ownerFullPath $ ".TimeStatusRound"));
	fireBackTex = GetTextureHandle((ownerFullPath $ ".FireReadyBg_Tex"));
	titleBackTex = GetTextureHandle((ownerFullPath $ ".FireSpawnTitleBg_Tex"));
	rewardNoneTex = GetTextureHandle((ownerFullPath $ ".RewardDisableBg_Tex"));
	successBorderTex = GetTextureHandle((ownerFullPath $ ".FireSuccessBox_Tex"));
	emptyRewardTextBox = GetTextBoxHandle((ownerFullPath $ ".EmptyReward_Txt"));
	_openedWnd = false;
	return;
}

function ResetInfo()
{
	local UIPacket._HolyFire defaultInfo;

	_info = defaultInfo;
	effectViewport.SpawnEffect("");
	needItemListScript.CleariObjects();
	_openedWnd = false;
	return;
}

function SetInfo(UIPacket._HolyFire fireStateInfo, int uiElapsedTimeCount)
{
	local bool needStateUpdate, needRewardItemUpdate;
	local int i, ElapsedTime, rewardLength;
	local float timePer;
	local StatusBaseHandle statusScript;

	rewardLength = fireStateInfo.rewards.Length;
	if(((_openedWnd == false) || (_info.rewards.Length != rewardLength)))
	{
		needRewardItemUpdate = true;
	}
	if(((_openedWnd == false) || (_info.cState != fireStateInfo.cState)))
	{
		needRewardItemUpdate = true;
		needStateUpdate = true;
	}
	if((_openedWnd == false))
	{
		_openedWnd = true;
	}
	_info = fireStateInfo;
	if((fireStateInfo.cState == 1))
	{
		ElapsedTime = (fireStateInfo.nElapsedTime + uiElapsedTimeCount);
		if((ElapsedTime > fireStateInfo.nLifespan))
		{
			ElapsedTime = fireStateInfo.nLifespan;
		}
	}
	else
	{
		ElapsedTime = fireStateInfo.nElapsedTime;
	}
	timePer = ((float(ElapsedTime) / float(fireStateInfo.nLifespan)) * 100.0000000);
	if(((fireStateInfo.cState == 1) || (fireStateInfo.cState == 2)))
	{
		statusScript = timeStatusRound.GetSelfScript();
		timeStatusRound.SetPoint(INT64(ElapsedTime), INT64(fireStateInfo.nLifespan));
		if((int(timePer) >= 100))
		{
			timeStatusRound.SetGaugeColor(1, GetColor(255, 47, 65, 255));
		}
		else
		{
			timeStatusRound.SetGaugeColor(1, GetColor(250, 168, 87, 255));
		}
		timeStatusRound.ShowWindow();
		timeTextBox.SetText((string(timePer) $ "%"));
		timeTextBox.ShowWindow();
	}
	else
	{
		timeStatusRound.HideWindow();
		timeTextBox.HideWindow();
	}
	if(needStateUpdate)
	{
		effectViewport.SpawnEffect(GetStateEffectPath(fireStateInfo.cState));
		stateTextBox.SetText(GetStateTitle(fireStateInfo.cState));
		descTextBox.SetText(GetStateDesc(fireStateInfo.cState));
		titleBackTex.SetTexture(GetTitleBackTextureName(fireStateInfo.cState));
		fireBackTex.SetTexture(GetFireBackTextureName(fireStateInfo.cState));
		if((fireStateInfo.cState == 2))
		{
			successBorderTex.ShowWindow();
		}
		else
		{
			successBorderTex.HideWindow();
		}
	}
	if(needRewardItemUpdate)
	{
		needItemListScript.StartNeedItemList(2);
		emptyRewardTextBox.HideWindow();
		if((rewardLength > 0))
		{
			i = 0;
			while((i < rewardLength))
			{
				needItemListScript.AddNeedItemClassID(fireStateInfo.rewards[i].nItemClassID, fireStateInfo.rewards[i].nAmount);
				i++;
			}
			needItemListScript.SetBuyNum(INT64(1));
			rewardNoneTex.HideWindow();
		}
		else
		{
			if(((fireStateInfo.cState == 2) || (fireStateInfo.cState == 3)))
			{
				if((fireStateInfo.cRewardState == -2))
				{
					emptyRewardTextBox.SetText(GetSystemString(14428));
				}
				else
				{
					emptyRewardTextBox.SetText(GetSystemString(14429));
				}
				emptyRewardTextBox.ShowWindow();
			}
			rewardNoneTex.ShowWindow();
		}
	}
	return;
}

function string GetStateEffectPath(int nState)
{
	local string effectPath;

	switch(nState)
	{
		case 0:
			effectPath = "";
			break;
		case 1:
			effectPath = "LineageEffect2.ui_dethrone_fire_on";
			break;
		case 2:
			effectPath = "LineageEffect2.ui_dethrone_fire_big";
			break;
		case 3:
			effectPath = "LineageEffect2.ui_dethrone_fire_off";
			break;
		default:
			break;
	}
	return effectPath;
}

function string GetTitleBackTextureName(int nState)
{
	local string effectPath;

	switch(nState)
	{
		case 0:
			effectPath = "L2UI_EPIC.DethroneWnd.FireReadyTitleBg";
			break;
		case 1:
			effectPath = "L2UI_EPIC.DethroneWnd.FireSpawnTitleBg";
			break;
		case 2:
			effectPath = "L2UI_EPIC.DethroneWnd.FireSuccessTitleBg";
			break;
		case 3:
			effectPath = "L2UI_EPIC.DethroneWnd.FireDespawnTitleBg";
			break;
		default:
			break;
	}
	return effectPath;
}

function string GetFireBackTextureName(int nState)
{
	local string effectPath;

	switch(nState)
	{
		case 0:
			effectPath = "L2UI_EPIC.DethroneWnd.FireReadyBg";
			break;
		case 1:
			effectPath = "L2UI_EPIC.DethroneWnd.FireSpawnBg";
			break;
		case 2:
			effectPath = "L2UI_EPIC.DethroneWnd.FireSuccessBg";
			break;
		case 3:
			effectPath = "L2UI_EPIC.DethroneWnd.FireDespawnBg";
			break;
		default:
			break;
	}
	return effectPath;
}

function string GetStateTitle(int nState)
{
	local int strID;

	switch(nState)
	{
		case 0:
			strID = 14344;
			break;
		case 1:
			strID = 14345;
			break;
		case 2:
			strID = 14346;
			break;
		case 3:
			strID = 14347;
			break;
		default:
			break;
	}
	return GetSystemString(strID);
}

function string GetStateDesc(int nState)
{
	local int strID;

	switch(nState)
	{
		case 0:
			strID = 14348;
			break;
		case 1:
			strID = 14349;
			break;
		case 2:
			strID = 14350;
			break;
		case 3:
			strID = 14351;
			break;
		default:
			break;
	}
	return GetSystemString(strID);
}
