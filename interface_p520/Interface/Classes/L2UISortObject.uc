class L2UISortObject extends UIEventManager;

var int h;
var int i;
var int j;
//var delegate<_DelegateCheckByItemInfo> ___DelegateCheckByItemInfo__Delegate;

delegate bool _DelegateCheckByItemInfo(ItemInfo A, ItemInfo B)
{

}

function _BubbleSortItemInfo(out array<ItemInfo> arr)
{
	local int i, j;
	local ItemInfo temp;

	i = 0;
	while((i < arr.Length))
	{
		j = 0;
		while((j < (arr.Length - i)))
		{
			if((j < (arr.Length - 1)))
			{
				if(_DelegateCheckByItemInfo(arr[j], arr[(j + 1)]))
				{
					temp = arr[j];
					arr[j] = arr[(j + 1)];
					arr[(j + 1)] = temp;
				}
			}
			++j;
		}
		++i;
	}
	return;
}

function _SortItemInfo(out array<ItemInfo> arr)
{
	local ItemInfo tmp;

	h = (arr.Length / 2);
	while((h > 0))
	{
		i = h;
		while((i < arr.Length))
		{
			tmp = arr[i];
			j = (i - h);
			while(((j >= 0) && _DelegateCheckByItemInfo(arr[j], tmp)))
			{
				arr[(j + h)] = arr[j];
				(j -= h);
			}
			arr[(j + h)] = tmp;
			i++;
		}
		(h /= 2.0000000);
	}
	return;
}
