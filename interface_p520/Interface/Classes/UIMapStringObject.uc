class UIMapStringObject extends Object;

struct mapKeyStruct
{
	var string Key;
	var string Data;
};

var array<mapKeyStruct> dataArray;

function Add(string Key, string dataString)
{
	local int i;

	i = 0;
	while((i < dataArray.Length))
	{
		if((dataArray[i].Key == Key))
		{
			dataArray[i].Data = dataString;
			return;
		}
		i++;
	}
	dataArray.Length = (dataArray.Length + 1);
	dataArray[(dataArray.Length - 1)].Key = Key;
	dataArray[(dataArray.Length - 1)].Data = dataString;
	return;
}

function bool HasKey(string Key)
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

function string Find(string Key)
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
	return "";
}

function string FindKeyByData(string Data)
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
	return "";
}

function RemoveAll()
{
	dataArray.Remove(0, dataArray.Length);
	return;
}

function Remove(string Key)
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

function array<string> ContainAll()
{
	local int i;
	local array<string> arr;

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
			rStr = dataArray[i].Data;
			i++;
			continue;
		}
		rStr = ((rStr $ DividerString) $ dataArray[i].Data);
		i++;
	}
	return rStr;
}
