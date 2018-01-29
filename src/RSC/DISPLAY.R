/*
 *   Display settings
 */

#include <dlogbox.h>
#include <dlogids.h>
#include <keys.h>

#include "dlogdids.h"
#include "dlogdcmd.h"

DialogBoxRsc DIALOGID_DisplaySettings =
{
    DIALOGATTR_DEFAULT | DIALOGATTR_AUTOOPEN,
    XC * 30, GENY(20.5), 
    NOHELP, LHELPCMD, HOOKID_Display, NOPARENTID,
    "Display Settings",
     {
     {{XC, GENY(1.5), 28*XC, GENY(8.5)}, GroupBox, 0, ON, 0, "Text Settings", ""},
     {{XC * 14, GENY(2), XC * 10, 0}, Text, TEXTID_TextHeight, ON, 0, "", ""},
     {{XC * 14, GENY(3), XC * 10, 0},  Text,  TEXTID_TextColor, ON, 0, "", ""},
     {{XC * 26, GENY(3), 0, 0 }, ColorPicker, COLORPICKERID_TextColor, ON, 0, "", "" },
     {{XC * 2,  GENY(4.5), 26*XC, GENY(3.5)}, GroupBox, 0, ON, 0, "", ""},
     {{XC * 14, GENY(5), XC * 10, 0}, Text, TEXTID_TextFontNum, ON, 0, "", ""},
     {{XC * 3,  GENY(6), XC * 22.5, 0}, OptionButton, OPTIONBUTTONID_TextFont, ON, 0, "", ""},
     {{XC * 14, GENY(8), XC * 10, 0},  Text,  TEXTID_LineOffset, ON, 0, "", ""},

     {{XC, GENY(10), 28*XC, GENY(4.5)}, GroupBox, 0, ON, 0, "Cell Settings", ""},
     {{XC * 14, GENY(10.5), XC * 10, 0},  Text,  TEXTID_CellScale, ON, 0, "", ""},
     {{XC * 14, GENY(11.5), XC * 10, 0},  Text,  TEXTID_CellColor, ON, 0, "", ""},
     {{XC * 26, GENY(11.5), 0, 0 }, ColorPicker, COLORPICKERID_CellColor, ON, 0, "", "" },
     {{XC * 14, GENY(12.5), XC * 10, 0},  Text,  TEXTID_MultiCellColor, ON, 0, "", ""},
     {{XC * 26, GENY(12.5), 0, 0 }, ColorPicker, COLORPICKERID_MultiCellColor, ON, 0, "", "" },

     {{XC, GENY(14.5), 28*XC, GENY(4.5)}, GroupBox, 0, ON, 0, "Line Settings", ""},
     {{XC * 14, GENY(15), XC * 10, 0},  Text,  TEXTID_LineColor, ON, 0, "", ""},
     {{XC * 26, GENY(15), 0, 0 }, ColorPicker, COLORPICKERID_LineColor, ON, 0, "", "" },
     {{XC * 14, GENY(16), XC * 10, 0},  Text,  TEXTID_LineWeight, ON, 0, "", ""},
     {{XC * 14, GENY(17.2), XC * 10, 0},  OptionButton, OPTIONBUTTONID_LineWeight, ON, 0, "", ""},

     {{XC * 11, GENY(18.7), XC * 8, 0},  PushButton, PUSHBUTTONID_DisplayApply, ON, 0, "", ""},
   }
};

DItem_PushButtonRsc PUSHBUTTONID_DisplayApply =
{
   NOT_DEFAULT_BUTTON, NOHELP, LHELPCMD, HOOKITEMID_DisplayApply,
   0, NOCMD, LCMD, "",
   "Apply"
};

DItem_OptionButtonRsc OPTIONBUTTONID_TextFont =
{
    SYNONYMID_TextFont, NOHELP, MHELP,
    HOOKITEMID_DisplayFont, OPTNBTNATTR_NEWSTYLE | NOARG, 
    "",
    "display.txtParams.font",
    { 
    }
};

DItem_TextRsc TEXTID_TextFontNum =
    {
    NOCMD, LCMD, SYNONYMID_TextFont, NOHELP, LHELPCMD, NOHOOK, NOARG,
    10, "%d", "%d", "0", "255", NOMASK, NOCONCAT,
    "Font",
    "display.txtParams.font"
    };

DItem_TextRsc TEXTID_CellScale =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, LHELPCMD, NOHOOK, NOARG,
    10, "%lf", "%lf", "", "", NOMASK, NOCONCAT,
    "Scale",
    "display.cellScale"
    };

DItem_TextRsc TEXTID_TextHeight =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, LHELPCMD, HOOKITEMID_DisplayHeight, NOARG,
    20, "%w", "%w", "", "", NOMASK, NOCONCAT,
    "Height",
    "display.txtSize.size.height"
    };

DItem_TextRsc TEXTID_LineOffset =
    {
    NOCMD, LCMD, NOSYNONYM, NOHELP, LHELPCMD, NOHOOK, NOARG,
    20, "%w", "%w", "", "", NOMASK, NOCONCAT,
    "Line Offset",
    "display.lineOffset"
    };

DItem_TextRsc TEXTID_TextColor =
    {
    NOCMD, LCMD, SYNONYMID_TextColor, NOHELP, LHELPCMD, NOHOOK, NOARG,
    10, "%d", "%d", "0", "255", NOMASK, NOCONCAT,
    "Color",
    "display.textColor"
    };

DItem_ColorPickerRsc COLORPICKERID_TextColor =
    {
    NOCMD, LCMD, SYNONYMID_TextColor, NOHELP, LHELPCMD,
    NOHOOK, NOARG,
    TEXTID_TextColor, NOMASK,
    "",
    "display.textColor"
    };

DItem_TextRsc TEXTID_CellColor =
    {
    NOCMD, LCMD, SYNONYMID_CellColor, NOHELP, LHELPCMD, NOHOOK, NOARG,
    10, "%d", "%d", "0", "255", NOMASK, NOCONCAT,
    "Color",
    "display.cellColor"
    };

DItem_ColorPickerRsc COLORPICKERID_CellColor =
    {
    NOCMD, LCMD, SYNONYMID_CellColor, NOHELP, LHELPCMD,
    NOHOOK, NOARG,
    TEXTID_CellColor, NOMASK,
    "",
    "display.cellColor"
    };

DItem_TextRsc TEXTID_LineColor =
    {
    NOCMD, LCMD, SYNONYMID_LineColor, NOHELP, LHELPCMD, NOHOOK, NOARG,
    10, "%d", "%d", "0", "255", NOMASK, NOCONCAT,
    "Color",
    "display.lineColor"
    };

DItem_ColorPickerRsc COLORPICKERID_LineColor =
    {
    NOCMD, LCMD, SYNONYMID_LineColor, NOHELP, LHELPCMD,
    NOHOOK, NOARG,
    TEXTID_LineColor, NOMASK,
    "",
    "display.lineColor"
    };

DItem_TextRsc TEXTID_MultiCellColor =
    {
    NOCMD, LCMD, SYNONYMID_MultiCellColor, NOHELP, LHELPCMD, NOHOOK, NOARG,
    10, "%d", "%d", "0", "255", NOMASK, NOCONCAT,
    "Multi-Color",
    "display.multiCellColor"
    };

DItem_ColorPickerRsc COLORPICKERID_MultiCellColor =
    {
    NOCMD, LCMD, SYNONYMID_MultiCellColor, NOHELP, LHELPCMD,
    NOHOOK, NOARG,
    TEXTID_MultiCellColor, NOMASK,
    "",
    "display.multiCellColor"
    };

DItem_SynonymsRsc SYNONYMID_CellColor =
    {
        {
        {Text,      TEXTID_CellColor},
        {ColorPicker, COLORPICKERID_CellColor},
        }
    };

DItem_SynonymsRsc SYNONYMID_MultiCellColor =
    {
        {
        {Text,      TEXTID_MultiCellColor},
        {ColorPicker, COLORPICKERID_MultiCellColor},
        }
    };

DItem_SynonymsRsc SYNONYMID_TextColor =
    {
        {
        {Text,      TEXTID_TextColor},
        {ColorPicker, COLORPICKERID_TextColor},
        }
    };

DItem_SynonymsRsc SYNONYMID_LineColor =
    {
        {
        {Text,      TEXTID_LineColor},
        {ColorPicker, COLORPICKERID_LineColor},
        }
    };

DItem_SynonymsRsc SYNONYMID_TextFont =
    {
        {
        {Text,      TEXTID_TextFontNum},
        {OptionButton, OPTIONBUTTONID_TextFont},
        }
    };

DItem_TextRsc TEXTID_LineWeight =
    {
    NOCMD, LCMD, SYNONYMID_LineWeight, NOHELP, LHELPCMD, NOHOOK, NOARG,
    20, "%d", "%d", "0", "15", NOMASK, NOCONCAT,
    "`Weight",
    "display.lineWeight"
    };

DItem_OptionButtonRsc  OPTIONBUTTONID_LineWeight =
{
     SYNONYMID_LineWeight, NOHELP, LHELPCMD, NOHOOK, ON | ALIGN_LEFT | OPTNBTNATTR_NEWSTYLE,
     "",
     "display.lineWeight",
        {
{Icon,ICONID_LineWeight0, NOCMD, MCMD, 0, NOMASK, ON, ""},
{Icon,ICONID_LineWeight1, NOCMD, MCMD, 1, NOMASK, ON, ""},
{Icon,ICONID_LineWeight2, NOCMD, MCMD, 2, NOMASK, ON, ""},
{Icon,ICONID_LineWeight3, NOCMD, MCMD, 3, NOMASK, ON, ""},
{Icon,ICONID_LineWeight4, NOCMD, MCMD, 4, NOMASK, ON, ""},
{Icon,ICONID_LineWeight5, NOCMD, MCMD, 5, NOMASK, ON, ""},
{Icon,ICONID_LineWeight6, NOCMD, MCMD, 6, NOMASK, ON, ""},
{Icon,ICONID_LineWeight7, NOCMD, MCMD, 7, NOMASK, ON, ""},
{Icon,ICONID_LineWeight8, NOCMD, MCMD, 8, NOMASK, ON, ""},
{Icon,ICONID_LineWeight9, NOCMD, MCMD, 9, NOMASK, ON, ""},
{Icon,ICONID_LineWeight10, NOCMD,MCMD, 10,NOMASK, ON, ""},
{Icon,ICONID_LineWeight11, NOCMD,MCMD, 11,NOMASK, ON, ""},
{Icon,ICONID_LineWeight12, NOCMD,MCMD, 12,NOMASK, ON, ""},
{Icon,ICONID_LineWeight13, NOCMD,MCMD, 13,NOMASK, ON, ""},
{Icon,ICONID_LineWeight14, NOCMD,MCMD, 14,NOMASK, ON, ""},
{Icon,ICONID_LineWeight15, NOCMD,MCMD, 15,NOMASK, ON, ""},
        }
};

DItem_SynonymsRsc SYNONYMID_LineWeight =
    {
        {
        {Text,      TEXTID_LineWeight},
        {OptionButton, OPTIONBUTTONID_LineWeight},
        }
    };
