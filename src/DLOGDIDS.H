/*----------------------------------------------------------------------*/
/* Program : dlogdids.h                                                 */
/* Description : Dialog box resource Id's                               */
/* Coded by : Jeff Hill ( jeff@reoforce.com.au )                        */
/*----------------------------------------------------------------------*/
#if !defined (__dlogdidsH__)
#define __dlogdidsH__

/*
 * Dialog Box IDs
 */
#define DIALOGID_Graph                 1
#define DIALOGID_Details               2
#define DIALOGID_DisplaySettings       3

/*
 * Option Button IDs
 */
#define OPTIONBUTTONID_TextFont        1
#define OPTIONBUTTONID_LineWeight      2

/*
 * Label Field IDs
 */
#define LABELID_Details1               1
#define LABELID_Details2               2
#define LABELID_Details3               3
#define LABELID_Details4               4
#define LABELID_Details5               5
#define LABELID_Details6               6
#define LABELID_Details7               7
#define LABELID_Details8               8
#define LABELID_Details9               9
#define LABELID_Details10              10
#define LABELID_Details11              11

/*
 * Push Button IDs
 */
#define PUSHBUTTONID_Save	            1
#define PUSHBUTTONID_clear	            2
#define PUSHBUTTONID_DetailsPrevious   3
#define PUSHBUTTONID_DetailsNext       4
#define PUSHBUTTONID_DisplayApply      5

/*
 * Toggle Button IDs
 */
#define TOGGLEID_Details               1

/*
 * Color Picker ID
 */
#define COLORPICKERID_TextColor        1
#define COLORPICKERID_CellColor        2
#define COLORPICKERID_MultiCellColor   3
#define COLORPICKERID_LineColor        4

/*
 * Text IDs
 */
#define TEXTID_TextColor               1
#define TEXTID_LineOffset              2
#define TEXTID_CellColor               3
#define TEXTID_MultiCellColor          4
#define TEXTID_LineColor               5
#define TEXTID_LineWeight              6
#define TEXTID_CellScale               7

/*
 * Hook IDs	
 */
#define BASEID                         100
#define HOOKITEMID_PlaceClear          (BASEID+1)
#define HOOKITEMID_PlaceExit           (BASEID+2)
#define HOOKID_Graph                   (BASEID+3)
#define HOOKID_Details                 (BASEID+4)
#define HOOKITEMID_DetailsPrevious     (BASEID+5)
#define HOOKITEMID_DetailsNext         (BASEID+6)
#define HOOKID_Display                 (BASEID+7)
#define HOOKITEMID_DisplayFont         (BASEID+8)
#define HOOKITEMID_DisplayApply        (BASEID+9)
#define HOOKITEMID_DisplayHeight       (BASEID+10)
#define HOOKITEMID_DetailsShow         (BASEID+11)

/*
 * Synonym Id's
 */
#define SYNONYMID_TextColor            1
#define SYNONYMID_TextFont             2
#define SYNONYMID_CellColor            3
#define SYNONYMID_MultiCellColor       4
#define SYNONYMID_LineColor            5
#define SYNONYMID_LineWeight           6

/*
 * Icon Command Frame Id
 */
#define ICONCMDFRAMEID_Graph           1


/*
 * minimum size for details dialog box
 */
#define MIN_DETAILS_SIZE               23

#endif
