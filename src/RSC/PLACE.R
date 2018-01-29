/*
 * Place.r
 *
 */

#include <rscdefs.h>
#include <cmdclass.h>
#include <dlogbox.h>
#include <dlogids.h>
#include <keys.h>
#include "dlogdids.h"
#include "icons.h"
#include "dlogdcmd.h"

#if defined (MSVERSION) && (MSVERSION >= 0x551)

DialogBoxRsc DIALOGID_Graph =
{
    DIALOGATTR_TOOLBOXCOMMON,
    0, 0,
    NOHELP, LHELPCMD, HOOKID_Graph, NOPARENTID,
    "",
     {
     {{ 0, 0, 0, 0}, ToolBox, DIALOGID_Graph, ON, 0, "", "" },
     }
};

DItem_ToolBoxRsc DIALOGID_Graph = 
{
     NOHELP, MHELPTOPIC, NOHOOK, NOARG, 0, "",
{
     {{ 0, 0, 0, 0}, IconCmd, ICONSMALLICONID_1, ON, 0, "", "" },
     {{ 0, 0, 0, 0}, IconCmd, ICONSMALLICONID_2, ON, 0, "", "" },
     {{ 0, 0, 0, 0}, IconCmd, ICONSMALLICONID_3, ON, 0, "", "" },
     {{ 0, 0, 0, 0}, IconCmd, ICONSMALLICONID_4, ON, 0, "", "" },
     {{ 0, 0, 0, 0}, IconCmd, ICONSMALLICONID_5, ON, 0, "", "" },
     {{ 0, 0, 0, 0}, IconCmd, ICONSMALLICONID_6, ON, 0, "", "" },
     {{ 0, 0, 0, 0}, IconCmd, ICONSMALLICONID_9, ON, 0, "", "" },
     {{ 0, 0, 0, 0}, IconCmd, ICONSMALLICONID_10, ON, 0, "", "" },
     {{ 0, 0, 0, 0}, IconCmd, ICONSMALLICONID_7, ON, 0, "", "" },
     {{ 0, 0, 0, 0}, IconCmd, ICONSMALLICONID_8, ON, 0, "", "" },
}
};

#else

DialogBoxRsc DIALOGID_Graph =
{
    DIALOGATTR_DEFAULT | DIALOGATTR_NORIGHTICONS | DIALOGATTR_AUTOOPEN,
    0, 0,
    NOHELP, LHELPCMD, HOOKID_Graph, NOPARENTID,
    "Place",
     {
     {{ 0, 0, 0, 0}, IconCmdFrame, ICONCMDFRAMEID_Graph, ON, 0, "", "" },
     }
};

DItem_IconCmdFrameRsc         ICONCMDFRAMEID_Graph =
    {
    10, 1, NOHELP, LHELPCMD, "",
        {
        { IconCmd, ICONSMALLICONID_1},
        { IconCmd, ICONSMALLICONID_2},
        { IconCmd, ICONSMALLICONID_3},
        { IconCmd, ICONSMALLICONID_4},
        { IconCmd, ICONSMALLICONID_5},
        { IconCmd, ICONSMALLICONID_6},
        { IconCmd, ICONSMALLICONID_7},
        { IconCmd, ICONSMALLICONID_8},
        { IconCmd, ICONSMALLICONID_9},
        { IconCmd, ICONSMALLICONID_10},
        }
    };

#endif

DItem_IconCmdRsc	ICONSMALLICONID_1 =
    {
    NOHELP, OHELPTASKIDCMD, 0,
    CMD_CMD1, OTASKID , "",
    "",
     {
     }
#if defined (MSVERSION) && (MSVERSION >= 0x551)
}
extendedAttributes
{{
{EXTATTR_FLYTEXT, "Total Traffic Incoming for DLS ( projected )"},
{EXTATTR_BALLOON, "Incoming DLS"},
}
#endif
};

DItem_IconCmdRsc	ICONSMALLICONID_2 =
    {
    NOHELP, OHELPTASKIDCMD, 0,
    CMD_CMD2, OTASKID , "",
    "",
     {
     }
#if defined (MSVERSION) && (MSVERSION >= 0x551)
}
extendedAttributes
{{
{EXTATTR_FLYTEXT, "Total Traffic Outgoing for DLS ( projected )"},
{EXTATTR_BALLOON, "Outgoing DLS"},
}
#endif
};

DItem_IconCmdRsc	ICONSMALLICONID_3 =
    {
    NOHELP, OHELPTASKIDCMD, 0,
    CMD_CMD3, OTASKID , "",
    "",
     {
     }
#if defined (MSVERSION) && (MSVERSION >= 0x551)
}
extendedAttributes
{{
{EXTATTR_FLYTEXT, "Building to Building Circuit Forecast"},
{EXTATTR_BALLOON, "Bldg <-> Bldg Circuit"},
}
#endif
};

DItem_IconCmdRsc	ICONSMALLICONID_4 =
    {
    NOHELP, OHELPTASKIDCMD, 0,
    CMD_CMD4, OTASKID , "",
    "",
     {
     }
#if defined (MSVERSION) && (MSVERSION >= 0x551)
}
extendedAttributes
{{
{EXTATTR_FLYTEXT, "List of Exchanges - Having Spare Capacity"},
{EXTATTR_BALLOON, "Exchange List"},
}
#endif
};

DItem_IconCmdRsc	ICONSMALLICONID_5 =
    {
    NOHELP, OHELPTASKIDCMD, 0,
    CMD_CMD5, OTASKID , "",
    "",
     {
     }
#if defined (MSVERSION) && (MSVERSION >= 0x551)
}
extendedAttributes
{{
{EXTATTR_FLYTEXT, "Long Term Transmission Capacity Planning - List of Deleted Links"},
{EXTATTR_BALLOON, "Deleted Links"},
}
#endif
};

DItem_IconCmdRsc	ICONSMALLICONID_6 =
    {
    NOHELP, OHELPTASKIDCMD, 0,
    CMD_CMD6, OTASKID , "",
    "",
     {
     }
#if defined (MSVERSION) && (MSVERSION >= 0x551)
}
extendedAttributes
{{
{EXTATTR_FLYTEXT, "Long Term Transmission Capacity Planning - Target Network"},
{EXTATTR_BALLOON, "Target Network"},
}
#endif
};

DItem_IconCmdRsc	ICONSMALLICONID_7 =
    {
    NOHELP, OHELPTASKIDCMD, 0,
    CMD_CMD7, OTASKID , "",
    "",
     {
     }
#if defined (MSVERSION) && (MSVERSION >= 0x551)
}
extendedAttributes
{{
{EXTATTR_FLYTEXT, "Clear the screen"},
{EXTATTR_BALLOON, "Clear"},
}
#endif
};

DItem_IconCmdRsc	ICONSMALLICONID_8 =
    {
    NOHELP, OHELPTASKIDCMD, 0,
    CMD_CMD8, OTASKID , "",
    "",
     {
     }
#if defined (MSVERSION) && (MSVERSION >= 0x551)
}
extendedAttributes
{{
{EXTATTR_FLYTEXT, "Exit Microstation"},
{EXTATTR_BALLOON, "Exit"},
}
#endif
};

DItem_IconCmdRsc	ICONSMALLICONID_9 =
    {
    NOHELP, OHELPTASKIDCMD, 0,
    CMD_CMD9, OTASKID , "",
    "",
     {
     }
#if defined (MSVERSION) && (MSVERSION >= 0x551)
}
extendedAttributes
{{
{EXTATTR_FLYTEXT, "Display Text Details for selected point"},
{EXTATTR_BALLOON, "Details"},
}
#endif
};

DItem_IconCmdRsc	ICONSMALLICONID_10 =
    {
    NOHELP, OHELPTASKIDCMD, 0,
    CMD_CMD10, OTASKID , "",
    "",
     {
     }
#if defined (MSVERSION) && (MSVERSION >= 0x551)
}
extendedAttributes
{{
{EXTATTR_FLYTEXT, "Modify and Re-Apply display settings"},
{EXTATTR_BALLOON, "Display Settings"},
}
#endif
};
