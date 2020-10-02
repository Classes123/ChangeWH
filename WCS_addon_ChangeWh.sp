#include <wcs>
//#include <morecolors>

#pragma newdecls required
#pragma semicolon 1

public Plugin myinfo =
{
	name = "[WC:Source] [VIP] Change WH",
	author = "Young <",
	version = "1.0.0",
	url = "enderG#0669"
};

static const char sGroup[] = "    ";
							  //\\ Сюда вписываете свою группу!
bool
	bWHStatus[MAXPLAYERS+1];
	
/*
	char sPrefix[128];
	
	public void OnMapStart()
	{
		WCS_GetPrefix(sPrefix, 128);
	}
*/
	
public void OnPluginStart()
{
	RegConsoleCmd("cwh", Command_ChangeWh);
	HookEvent("round_start", Event_RoundStart);
}

public Action Command_ChangeWh(int iClient, int iArgs)
{
	if(WCS_GetVip(iClient))
	{
		char sVipGroup[64];
		WCS_GetVipGroup(iClient, sVipGroup, 64);
		if(StrEqual(sVipGroup, sGroup))
		{
			if(bWHStatus[iClient])
			{
				ServerCommand("wh_off 100 %i", GetClientUserId(iClient));
				bWHStatus[iClient] = false;
			}
			else
			{
				bWHStatus[iClient] = true;
				ServerCommand("wh 100 %i", GetClientUserId(iClient));
			}	
		}
		//else
		//CPrintToChat(iClient, "%s {red}Вы не являетесь VIP игроком со скиллом WH!", sPrefix);
	}
	//else
	//CPrintToChat(iClient, "%s {red}Вы не являетесь VIP Игроком!", sPrefix);

	return Plugin_Handled;
}

public void Event_RoundStart(Event hEvent, const char[] sEvName, bool bDontBroadcast)
{
	for (int i = 1; i <= MaxClients; i++)
		if (WCS_IsPlayerLoaded(i) && !IsFakeClient(i) && !bWHStatus[i])
			CreateTimer(1.0, Timer_OffWH, i, TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_OffWH(Handle hTimer, any iClient)
{
	ServerCommand("wh_off 100 %i", GetClientUserId(iClient));
	return Plugin_Handled;
}

public void OnClientDisconnected(int iClient)
{
	bWHStatus[iClient] = true;
}

public void WCS_OnClientLoaded(int iClient)
{
	bWHStatus[iClient] = true;
}