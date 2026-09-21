class UIMapInt64Object extends Object;

struct mapKeyStruct
{
	var INT64 Key;
	var INT64 Data;
};

var array<mapKeyStruct> dataArray;

function Add(INT64 Key, INT64 DataValue)
{
	local int i;

	i = 0;
	while((i < dataArray.Length))
	{
		if((dataArray[i].Key == Key))
		{
			dataArray[i].Data = DataValue;
			return;
		}
		i++;
	}
	dataArray.Length = (dataArray.Length + 1);
	dataArray[(dataArray.Length - 1)].Key = Key;
	dataArray[(dataArray.Length - 1)].Data = DataValue;
	return;
}

function AddIncrease(INT64 Key, INT64 DataValue)
{
	local int i;

	i = 0;
	while((i < dataArray.Length))
	{
		if((dataArray[i].Key == Key))
		{
			dataArray[i].Data = (dataArray[i].Data + DataValue);
			return;
		}
		i++;
	}
	dataArray.Length = (dataArray.Length + 1);
	dataArray[(dataArray.Length - 1)].Key = Key;
	dataArray[(dataArray.Length - 1)].Data = DataValue;
	return;
}

function bool HasKey(INT64 Key)
{
	local int i;

	i = 0;
	while((i < dataArray.Length))
	{
		if((dataArray[i].Key == Key))
		{
			return true;
		}
		i++;
	}
	return false;
}

function INT64 Find(INT64 Key)
{
	local int i;

	i = 0;
	while((i < dataArray.Length))
	{
		if((dataArray[i].Key == Key))
		{
			return dataArray[i].Data;
		}
		i++;
	}
	return INT64(-1);
}

function INT64 FindKeyByData(INT64 Data)
{
	local int i;

	i = 0;
	while((i < dataArray.Length))
	{
		if((dataArray[i].Data == Data))
		{
			return dataArray[i].Key;
		}
		i++;
	}
	return INT64(-1);
}

function RemoveAll()
{
	dataArray.Remove(0, dataArray.Length);
	return;
}

function Remove(INT64 Key)
{
	local int i;

	i = 0;
	while((i < dataArray.Length))
	{
		if((dataArray[i].Key == Key))
		{
			dataArray.Remove(i, 1);
			break;
		}
		i++;
	}
	return;
}

function array<INT64> ContainAll()
{
	local int i;
	local array<INT64> arr;

	i = 0;
	while((i < dataArray.Length))
	{
		arr.Length = (arr.Length + 1);
		arr[(arr.Length - 1)] = dataArray[i].Data;
		i++;
	}
	return arr;
}

function int Size()
{
	return dataArray.Length;
}

function string ToString(optional string DividerString)
{
	local int i;
	local string rStr;

	if((DividerString == ""))
	{
		DividerString = ",";
	}
	i = 0;
	while((i < dataArray.Length))
	{
		if((rStr == ""))
		{
			rStr = string(dataArray[i].Data);
			i++;
			continue;
		}
		rStr = ((rStr $ DividerString) $ string(dataArray[i].Data));
		i++;
	}
	return rStr;
}
