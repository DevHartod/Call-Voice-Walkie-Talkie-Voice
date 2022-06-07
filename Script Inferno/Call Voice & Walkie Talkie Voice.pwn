//Call Voice & Walkie Talkie Voice
//Jangan Di Share , Wajib Pake Link Discord Zan Store Jika Ingin Share
//Note GM Kalian Harus Udah Ada Voice Nya


//Varibale Walkie Talkie
#define MAX_FREQUENCIAS 9999
new SV_GSTREAM:Frequencia[MAX_FREQUENCIAS] = { SV_NULL, ... };
//Variable Call
new SV_GSTREAM:OnPhone[MAX_PLAYERS];

//Taruh Di Enum pInfo
FreqConnect,

//stock / forward
//FIND "new PlayerInfo[MAX_PLAYERS][pInfo];"
//Tempel Di Bawah Define Nya
stock MsgFrequencia(freq, color, msg[])
{
	for(new i=0;i<MAX_PLAYERS;i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][FreqConnect] > 0 && PlayerInfo[i][FreqConnect] == freq)
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
	PlayerInfo[playerid][FreqConnect] = freq;
	SvAttachListenerToStream(Frequencia[freq], playerid);
	return 1;
}

//============================[C M D]============================\\

//Find "CMD:call(playerid, params[])"
//Replace / Ganti Dengan Ini
CMD:call(playerid, params[])
{
	if(PhoneOnline[playerid] > 0) return Send(playerid, COLOR_GREY, "Ponsel anda terputus...");
	if(PlayerInfo[playerid][pProducts][0] == 0) return Send(playerid, COLOR_RED, "Anda tidak punya telepon!");
    if(PlayerInfo[playerid][pNumber] == 0) return Send(playerid, COLOR_RED, "Anda tidak memiliki kartu SIM!");
    if(player_gag[playerid]) return Send(playerid, COLOR_RED, "Anda sedang di mute, Anda tidak bisa bicara.") & 0;
    if(sscanf(params, "d",params[0])) return Send(playerid, -1, "Masuk: /call [angka]");
   	SendClientMessage(playerid,COLOR_GREY,"Keadaan darurat - 911");


	SetPlayerAttachedObject(playerid,0,330,6);
	if(Mobile[playerid] != -1) return Send(playerid, COLOR_GREY, "Anda sudah berbicara di telepon.");
	if(PlayerInfo[playerid][pSummaNumber] <= 0) Send(playerid, COLOR_GREY, "Anda tidak punya uang di akun ponsel Anda.");
	format(String, 86, "%s mengeluarkan ponsel",Name(playerid));
	ProxDetector(10.0, playerid, String, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	if(params[0] == PlayerInfo[playerid][pNumber]) return Send(playerid, COLOR_GREY, "Anda tidak dapat menyebut diri Anda sendiri, salurannya sibuk.");

    if(params[0] == 911) return SPD(playerid, 8949, DIALOG_STYLE_INPUT, "Panggilan polisi", "Jelaskan tempat Anda berada:", "Untuk menelepon", "Tutup");
	if(params[0] == 03) return SPD(playerid, 8950, DIALOG_STYLE_INPUT, "Panggilan Ambulans", "Jelaskan tempat Anda berjalan:", "Untuk menelepon", "Tutup");
	if(params[0] == 222) return SPD(playerid, 8952, DIALOG_STYLE_INPUT, "Panggilan Mekanik", "Jelaskan tempat Anda berjalan:", "Untuk menelepon", "Tutup");

	for(new i = 70; i <= 72; i++)
	{
		if(!BizzInfo[i][bPhone] || params[0] != BizzInfo[i][bPhone]) continue;

		SetPlayerUseListitem(playerid, i);

		return SPD(playerid, 8948, DIALOG_STYLE_INPUT, "Panggilan taksi", "Jelaskan tempat Anda berada:", "Untuk menelepon", "Tutup");
	}

	foreach(new i : Player)
	{
		if(PlayerInfo[i][pNumber] == params[0] && params[0] != 0)
		{
			Mobile[playerid] = i;

			if(PhoneOnline[Mobile[playerid]] > 0) return Send(playerid, COLOR_GREY, "Telepon pemanggil mati...");

			if(Mobile[Mobile[playerid]] == -1)
			{
			    Send(Mobile[playerid], -1, "Ponsel Anda berdering. Masuk {43CC0E}(/p)"W" untuk menjawab.");
                PlayerPlaySound(Mobile[playerid], 20600, 0.0, 0.0, 0.0), PlayerPlaySound(playerid, 3600, 0.0, 0.0, 0.0);

			    OnPhone[i] = SvCreateGStream(0xFFA200FF, "InPhone");

                if (OnPhone[i])
				{
			       SvAttachListenerToStream(OnPhone[i], i);
			       SvAttachListenerToStream(OnPhone[i], playerid);
			    }
			    if (OnPhone[i])
				{
			        SvAttachSpeakerToStream(OnPhone[i], playerid);
		        }
                if(OnPhone[i])
				{
	                SvAttachSpeakerToStream(OnPhone[i], i);
			    }
				format(String, 86, "%s telepon berdering", Name(i)), SetPlayerChatBubble(i, String, COLOR_PURPLE, 10.0, 5000);
				SetPlayerAttachedObject(playerid, 0, 19513,6,0.101998,0.013999,-0.007999,79.899864,-178.999969,-4.200003,1.000000,1.000000,1.000000);
				SetPlayerSpecialAction(playerid, 11);
				CellTime[playerid] = 1;
				break;
			}
		}
	}
	return 1;
}

//FIND "CMD:h(playerid, params[])"
//Replace / Ganti Dengan Ini
CMD:h(playerid, params[])
{
    if(IsPlayerConnected(Mobile[playerid]) && PlayerInfo[Mobile[playerid]][pLogin] == 1)
    {
        if(Mobile[playerid] != -1)
        {
            Send(Mobile[playerid], COLOR_GREY, "Pelanggan menutup telepon (a)...");
            SetPlayerSpecialAction(Mobile[playerid],SPECIAL_ACTION_STOPUSECELLPHONE);
            SetPlayerSpecialAction(playerid,SPECIAL_ACTION_STOPUSECELLPHONE);
            RemovePlayerAttachedObject(playerid,0);
            RemovePlayerAttachedObject(Mobile[playerid],0);
            CellTime[Mobile[playerid]] = 0;
            CellTime[playerid] = 0;
            Mobile[Mobile[playerid]] = -1;
            Send(playerid, COLOR_GREY, "Kamu menutup telepon...");
        }
        Mobile[playerid] = -1;
        CellTime[playerid] = 0;
        return true;
    }
    SetPlayerSpecialAction(playerid,SPECIAL_ACTION_STOPUSECELLPHONE);
    RemovePlayerAttachedObject(playerid,0);
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
	if(PlayerInfo[playerid][pRadio] == 0) return SCM(playerid, COLOR_GREY, "Anda tidak memiliki Walkie Talky, membelinya di toko 24/7");

	if(sscanf(params, "d", freq)) return SendClientMessage(playerid, -1,"Usage: /wt [FREQ. 1-9999]");
	if(freq > 9999 || freq < 0) return SendClientMessage(playerid, 0xFF0000FF, "Freq INvalid!");
	if(freq == 0)
	{
		SendClientMessage(playerid, 0xFF0000FF, "Radio Telah DI Non Aktifkan");
		SvDetachListenerFromStream(Frequencia[PlayerInfo[playerid][pRadioFreq]], playerid);
		PlayerInfo[playerid][pRadioFreq] = 0;
	} else {
		new string[128];
		format(string, 128, "Radio Telah Connect Ke [%d].", freq);
		SendClientMessage(playerid, 0x00AE00FF, string);

		format(string, 128, "Radio %s Telah Masuk Ke Radio %d", GetName(playerid), PlayerInfo[playerid][pRadioFreq]);
		MsgFrequencia(PlayerInfo[playerid][pRadioFreq], 0xBF0000FF, string);
		format(string, 128, "Radio: %s Telah Connect Ke Radio %d", GetName(playerid), freq);
		MsgFrequencia(freq, 0xFF6C00FF, string);

		SetTimerEx("ConectarNaFrequencia", 100, false, "id", playerid, freq);
	}
	return 1;
}