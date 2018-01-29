/*
 * Details.r
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

DialogBoxRsc DIALOGID_Details =
{
    /* Recommended attributes for tool palette frame dialog boxes */
    DIALOGATTR_DEFAULT | DIALOGATTR_AUTOOPEN,
    XC * MIN_DETAILS_SIZE, GENY(16),
    NOHELP, LHELPCMD, HOOKID_Details, NOPARENTID,
    "Text Details",
     {
/*     {{XC * 2, GENY(1.5), 57*XC, GENY(11.5)}, GroupBox, 0, ON, 0, "Details", ""},*/
     {{XC * 2, GENY(1), XC * 7, 0}, Label, LABELID_Details11, ON, ALIGN_LEFT | LABEL_FONT_BOLD, "Details", "" },
     {{XC * 3, GENY(2), XC * 55, 0}, Label, LABELID_Details1, ON, ALIGN_LEFT, "", "" },
     {{XC * 3, GENY(3), XC * 55, 0}, Label, LABELID_Details2, ON, ALIGN_LEFT, "", "" },
     {{XC * 3, GENY(4), XC * 55, 0}, Label, LABELID_Details3, ON, ALIGN_LEFT, "", "" },
     {{XC * 3, GENY(5), XC * 55, 0}, Label, LABELID_Details4, ON, ALIGN_LEFT, "", "" },
     {{XC * 3, GENY(6), XC * 55, 0}, Label, LABELID_Details5, ON, ALIGN_LEFT, "", "" },
     {{XC * 3, GENY(7), XC * 55, 0}, Label, LABELID_Details6, ON, ALIGN_LEFT, "", "" },
     {{XC * 3, GENY(8), XC * 55, 0}, Label, LABELID_Details7, ON, ALIGN_LEFT, "", "" },
     {{XC * 3, GENY(9), XC * 55, 0}, Label, LABELID_Details8, ON, ALIGN_LEFT, "", "" },
     {{XC * 3, GENY(10), XC * 55, 0}, Label, LABELID_Details9, ON, ALIGN_LEFT, "", "" },
     {{XC * 3, GENY(11), XC * 55, 0}, Label, LABELID_Details10, ON, ALIGN_LEFT, "", "" },

     {{XC * 2, GENY(13), 0, 0}, ToggleButton, TOGGLEID_Details, ON, 0, "", ""},

/*     {{XC * 43, GENY(13), XC * 5, 0}, Label, LABELID_Details11, OFF, ALIGN_LEFT, "", "" },*/
     {{XC * 2, GENY(14.5), XC * 9, 0},  PushButton, PUSHBUTTONID_DetailsPrevious, ON, 0, "", ""},
     {{XC * 12, GENY(14.5), XC * 9, 0},  PushButton, PUSHBUTTONID_DetailsNext, ON, 0, "", ""},

     }
};

DItem_ToggleButtonRsc TOGGLEID_Details =
{
   NOCMD, LCMD, NOSYNONYM, NOHELP, LHELPCMD, HOOKITEMID_DetailsShow,
   NOARG, NOMASK, NOINVERT,
   "Hide Text on Display",
   "nodeDetails->displayText"
};

DItem_PushButtonRsc PUSHBUTTONID_DetailsPrevious =
{
   NOT_DEFAULT_BUTTON, NOHELP, LHELPCMD, HOOKITEMID_DetailsPrevious,
   0, NOCMD, LCMD, "",
   " < "
};

DItem_PushButtonRsc PUSHBUTTONID_DetailsNext =
{
   NOT_DEFAULT_BUTTON, NOHELP, LHELPCMD, HOOKITEMID_DetailsNext,
   0, NOCMD, LCMD, "",
   " > "
};
