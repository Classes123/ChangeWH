#define PLUGIN_NAME "[WC:Source] [VIP] Change WH"
#define FLOOD_TIME  1

#include <clientprefs>
#include <wcs>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name = PLUGIN_NAME,
	author = "Young <",
	version = "1.2.0"
};


KeyValues
    g_hVipGroups;

Cookie
    g_hCookie;

bool
    g_bCanChange[MAXPLAYERS+1];


public void OnPluginStart()
{
    g_hCookie = new Cookie("wcs_addon_change_wh", "WH status", CookieAccess_Private);

    AddCommandListener(Command_WH, "wh");
    RegConsoleCmd("cwh", Command_CWH);
}

public void OnMapStart()
{
    if(g_hVipGroups)
    {
        delete g_hVipGroups;
    }

    char szPath[PLATFORM_MAX_PATH];
    BuildPath(Path_SM, szPath, sizeof szPath, "data/wcs/wcs_vip_groups.ini");

    g_hVipGroups = new KeyValues("VipGroups");
    if(!g_hVipGroups.ImportFromFile(szPath))
    {
        SetFailState(PLUGIN_NAME..." : Error read \"%s\", aborting.", szPath);
    }

    /**
     *  Checking late load
     */
    if(RoundToCeil(GetGameTime()) >= 3)
    {
        for(int i = 1; i <= MaxClients; i++)
        {
            if(WCS_IsPlayerLoaded(i) && !IsFakeClient(i))
            {
                WCS_OnVIPLoaded(i);
            }
        }
    }
}

public Action Command_WH(int iCmdClient, const char[] sCommand, int iArgs)
{
    char szArg[8];
    GetCmdArg(iArgs, szArg, sizeof szArg);

    int iClient = GetClientOfUserId(StringToInt(szArg));
    if(iClient && g_bCanChange[iClient] && UTIL_CookieGetNum(g_hCookie, iClient))
    {
        return Plugin_Handled;
    }
    
    return Plugin_Continue;
}

public Action Command_CWH(int iClient, int iArgs)
{
    static int iUseTime[MAXPLAYERS+1];
    int iCurrentTime = GetTime();

    if((iUseTime[iClient] + FLOOD_TIME < iCurrentTime) && g_bCanChange[iClient])
    {
        iUseTime[iClient] = iCurrentTime;
        bool bStatus = !!UTIL_CookieGetNum(g_hCookie, iClient);

        UTIL_CookieSetNum(g_hCookie, iClient, bStatus ? 0 : 1);
        ServerCommand("wh%s 100 %i", bStatus ? NULL_STRING : ("_off"), GetClientUserId(iClient));
    }

    return Plugin_Handled;
}

public void WCS_OnVIPLoaded(int iClient)
{
    char szGroup[128];
    if(WCS_GetVipGroup(iClient, szGroup, sizeof szGroup))
    {
        g_hVipGroups.Rewind();
        if(g_hVipGroups.JumpToKey(szGroup))
        {
            g_bCanChange[iClient] = !!g_hVipGroups.GetNum("CWH");
        }
    }
}

public void OnClientDisconnect(int iClient)
{
    g_bCanChange[iClient] = false;
}


/**
 *  Helpful functions
 */
int UTIL_CookieGetNum(Cookie hCookie, int iClient)
{
    char szBuff[2];
    hCookie.Get(iClient, szBuff, sizeof szBuff);
    return StringToInt(szBuff);
}

void UTIL_CookieSetNum(Cookie hCookie, int iClient, int iNum)
{
    char szBuff[2];
    IntToString(iNum, szBuff, sizeof szBuff);
    hCookie.Set(iClient, szBuff);
}