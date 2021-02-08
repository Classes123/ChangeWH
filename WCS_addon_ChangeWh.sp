/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
																																	   //
#define GROUPS 			"vip_wh1;vip_wh2;vip_wh"	//VIP-Группы, которые могут использовать эту команду (разделять с помощью ';').	   //
#define GROUPS_COUNT 	3							//Число VIP-Групп, указанных выше.												   //
																																	   //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma semicolon 1

#include <wcs>

#pragma newdecls required

public Plugin myinfo =
{
	name = "[WC:Source] [WCSVIP] Change WH",
	author = "Young <",
	version = "1.1.0"
};


char 
	g_sPrefix[128],
	g_sGroups[GROUPS_COUNT][64];

bool
	g_bWHStatus[MAXPLAYERS+1];
	

public void OnMapStart()
{
	GetConVarString(FindConVar("wcs_prefix"), g_sPrefix, sizeof g_sPrefix);
}

public void OnPluginStart()
{
	ExplodeString(GROUPS, ";", g_sGroups, sizeof g_sGroups, sizeof g_sGroups[]);

	RegConsoleCmd("cwh", Command_ChangeWh);
	HookEvent("round_start", Event_RoundStart);
}

public Action Command_ChangeWh(int iClient, int iArgs)
{
	if(WCS_GetVip(iClient))
	{
		char sVipGroup[64];
		WCS_GetVipGroup(iClient, sVipGroup, sizeof sVipGroup);

		for(int i; i < GROUPS_COUNT; i++) 
		{
			if(StrEqual(sVipGroup, g_sGroups[i]))
			{
				ServerCommand("wh%s 100 %i", g_bWHStatus[iClient] ? ("_off") : NULL_STRING,  GetClientUserId(iClient));

				g_bWHStatus[iClient] = g_bWHStatus[iClient] ? false : true;

				return Plugin_Handled;	
			}
		}
	}

	return Plugin_Handled;
}

public void Event_RoundStart(Event hEvent, const char[] sEvName, bool bDontBroadcast)
{
	for (int i = 1; i <= MaxClients; i++)
		if (WCS_IsPlayerLoaded(i) && !IsFakeClient(i) && !g_bWHStatus[i])
			if(WCS_GetVip(i))
				CreateTimer(1.0, Timer_OffWH, GetClientUserId(i), TIMER_FLAG_NO_MAPCHANGE);
			else
				g_bWHStatus[i] = true;	
}

public Action Timer_OffWH(Handle hTimer, any iUserId)
{
	ServerCommand("wh_off 100 %i", iUserId);
}

public void OnClientDisconnected(int iClient)
{
	g_bWHStatus[iClient] = true;
}

public void WCS_OnClientLoaded(int iClient)
{
	g_bWHStatus[iClient] = true;
}
