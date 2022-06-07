//Call Voice & Walkie Talkie Voice
//Jangan Di Share , Wajib Pake Link Discord Zan Store Jika Ingin Share
//Note GM Kalian Harus Udah Ada Voice Nya


//Varibale Walkie Talkie
#define MAX_FREQUENCIAS 9999
new SV_GSTREAM:Frequencia[MAX_FREQUENCIAS] = { SV_NULL, ... };
//Variable Call
new SV_GSTREAM:OnPhone[MAX_PLAYERS];

//Taruh Di enum E_PLAYERS
FreqConnect,

//stock / forward

stock MsgFrequencia(freq, color, msg[])
{
	for(new i=0;i<MAX_PLAYERS;i++)
	{
		if(IsPlayerConnected(i))
		{
			if(pData[i][FreqConnect] > 0 && pData[i][FreqConnect] == freq)
			{
				SendClientMessage(i, color, msg);
			}
		}
	}
	return 1;
}

forward ConectarNaFrequencia(playerid, freq);
public ConectarNaFrequencia(playerid, freq)
{
	pData[playerid][FreqConnect] = freq;
	SvAttachListenerToStream(Frequencia[freq], playerid);
	return 1;
}

//============================[C M D]============================\\

//Find "CMD:call(playerid, params[])"
//Replace / Ganti Dengan Ini
CMD:call(playerid, params[])
{
	new ph;
	if(pData[playerid][pPhone] == 0) return Error(playerid, "You dont have phone!");
	if(pData[playerid][pPhoneCredit] <= 0) return Error(playerid, "You dont have phone credits!");

	if(sscanf(params, "d", ph))
	{
		Usage(playerid, "/call [phone number] 933 - Taxi Call | 911 - SAPD Crime Call | 922 - SAMD Medic Call");
		foreach(new ii : Player)
		{
			if(pData[ii][pMechDuty] == 1)
			{
				SendClientMessageEx(playerid, COLOR_GREEN, "Mekanik Duty: %s | PH: [%d]", ReturnName(ii), pData[ii][pPhone]);
			}
		}
		return 1;
	}
	if(ph == 911)
	{
		if(pData[playerid][pCallTime] >= gettime())
			return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());

        Info(playerid, "911: "WHITE_E"You have reached the emergency crime.");
		Info(playerid, "911: "WHITE_E"How can I help you?");
		SetPVarInt(playerid, "911", 1);

		pData[playerid][pCallTime] = gettime() + 60;
	}
	if(ph == 922)
	{
		if(pData[playerid][pCallTime] >= gettime())
			return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());

		Info(playerid, "922: "WHITE_E"You have reached the emergency medical service.");
		Info(playerid, "922: "WHITE_E"How can I help you?");
		SetPVarInt(playerid, "922", 1);

		pData[playerid][pCallTime] = gettime() + 60;
	}
	if(ph == 933)
	{
		if(pData[playerid][pCallTime] >= gettime())
			return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());

		Info(playerid, "933: "WHITE_E"You have reached the taxi driver.");
		Info(playerid, "933: "WHITE_E"Describe Your Positions!");
		SetPVarInt(playerid, "933", 1);
	}
	if(ph == pData[playerid][pPhone]) return Error(playerid, "Nomor sedang sibuk!");
	foreach(new ii : Player)
	{
		if(pData[ii][pPhone] == ph)
		{
			if(pData[ii][IsLoggedIn] == false || !IsPlayerConnected(ii)) return Error(playerid, "This number is not actived!");

			if(pData[ii][pCall] == INVALID_PLAYER_ID)
			{
				pData[playerid][pCall] = ii;

				SendClientMessageEx(playerid, COLOR_YELLOW, "[CELLPHONE to %d] "WHITE_E"phone begins to ring, please wait for answer!", ph);
				SendClientMessageEx(ii, COLOR_YELLOW, "[CELLPHONE form %d] "WHITE_E"Your phonecell is ringing, type '/p' to answer it!", pData[playerid][pPhone]);
				PlayerPlaySound(playerid, 3600, 0,0,0);
				PlayerPlaySound(ii, 6003, 0,0,0);
				OnPhone[ii] = SvCreateGStream(0xFFA200FF, "InPhone");
				if (OnPhone[ii])
				{
			       SvAttachListenerToStream(OnPhone[ii], ii);
			       SvAttachListenerToStream(OnPhone[ii], playerid);
			    }
			    if (OnPhone[ii])
				{
			        SvAttachSpeakerToStream(OnPhone[ii], playerid);
		        }
                if(OnPhone[ii])
				{
	                SvAttachSpeakerToStream(OnPhone[ii], ii);
			    }
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
				SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s takes out a cellphone and calling someone.", ReturnName(playerid));
				return 1;
			}
			else
			{
				Error(playerid, "Nomor ini sedang sibuk.");
				return 1;
			}
		}
	}
	return 1;
}

//FIND "CMD:hu(playerid"
//Replace / Ganti Dengan Ini
CMD:hu(playerid, params[])
{
	new caller = pData[playerid][pCall];
	if(IsPlayerConnected(caller) && caller != INVALID_PLAYER_ID)
	{
		pData[caller][pCall] = INVALID_PLAYER_ID;
		SetPlayerSpecialAction(caller, SPECIAL_ACTION_STOPUSECELLPHONE);
		SendNearbyMessage(caller, 20.0, COLOR_PURPLE, "* %s puts away their cellphone.", ReturnName(caller));

		SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s puts away their cellphone.", ReturnName(playerid));
		pData[playerid][pCall] = INVALID_PLAYER_ID;
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
	}
	return 1;
	if(OnPhone[Mobile[playerid]] && Mobile[playerid] != -1)
    {
       SvDetachSpeakerFromStream(OnPhone[Mobile[playerid]], Mobile[playerid]);
    }

    if(OnPhone[Mobile[playerid]] && Mobile[playerid] != -1)
    {
       SvDetachSpeakerFromStream(OnPhone[Mobile[playerid]], playerid);
    }

    if(OnPhone[Mobile[playerid]]){
       SvDetachListenerFromStream(OnPhone[Mobile[playerid]], Mobile[playerid]);
       SvDetachListenerFromStream(OnPhone[Mobile[playerid]], playerid);
       SvDeleteStream(OnPhone[Mobile[playerid]]);
       OnPhone[Mobile[playerid]] = SV_NULL;
    }

    if (OnPhone[playerid] && Mobile[playerid] != -1)
    {
        SvDetachSpeakerFromStream(OnPhone[playerid], Mobile[playerid]);
    }

    if(OnPhone[Mobile[playerid]] && Mobile[playerid] != -1)
    {
        SvDetachSpeakerFromStream(OnPhone[playerid], playerid);
    }

    if(OnPhone[playerid])
    {
        SvDetachListenerFromStream(OnPhone[playerid], Mobile[playerid]);
        SvDetachListenerFromStream(OnPhone[playerid], playerid);
        SvDeleteStream(OnPhone[playerid]);
        OnPhone[playerid] = SV_NULL;
    }
    return true;
}

//FIND "CMD:wt"
// Replace / Ganti Dengan Ini

CMD:wt(playerid, params[])
{
	new freq;
	if(pData[playerid][pWT] == 0)
		return Error(playerid, "You dont have walkie talkie!");
	if(sscanf(params, "d", freq)) return SendClientMessage(playerid, -1,"Usage: /wt [FREQ. 1-1000]");
	if(freq > 1000 || freq < 0) return SendClientMessage(playerid, 0xFF0000FF, "Freq INvalid!");
	if(freq == 0)
	if(pData[playerid][pUsingWT] == 0)
	{	
		new string[128];
		pData[playerid][pUsingWT] = 1;
		Info(playerid, "Turn on Walkie Talkie!");
		SetPlayerAttachedObject(playerid, 9, 2967, 1, 0.064000, 0.137000, -0.098000, 20.999000, -18.399000, -88.699000, 1.000000, 1.000000, 1.000000);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
		format(string, 128, "Radio %s Telah Masuk Ke Radio %d", GetName(playerid), pData[playerid][FreqConnect]);
		MsgFrequencia(pData[playerid][FreqConnect], 0xBF0000FF, string);
		format(string, 128, "Radio: %s Telah Connect Ke Radio %d", GetName(playerid), freq);
		MsgFrequencia(freq, 0xFF6C00FF, string);

		SetTimerEx("ConectarNaFrequencia", 100, false, "id", playerid, freq);
	}
	else
	{
		pData[playerid][pUsingWT] = 0;
		Info(playerid, "Turn off Walkie Talkie!");
		if(IsPlayerAttachedObjectSlotUsed(playerid,9)) RemovePlayerAttachedObject(playerid,9);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		SvDetachListenerFromStream(Frequencia[pData[playerid][FreqConnect]], playerid);
		pData[playerid][FreqConnect] = 0;
	}
	return 1;
}