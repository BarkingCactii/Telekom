#ifndef _DEFS_H
#define _DEFS_H

#include "coord.h"

#define  PLGM5AAFNAME   "PLGM5AA.LST"
#define  PLGM5ABFNAME   "PLGM5AB.LST"
#define  PLGM5AIFNAME   "PLGM5AI.LST"
#define  PLGM5AI2FNAME  "PLGM5AI2.LST"
#define  PLGM5AJFNAME   "PLGM5AJ.LST"
#define  PLGM5AKFNAME   "PLGM5AK.LST"
#define  PLGM5AK2FNAME  "PLGM5AK2.LST"
#define  PLGM5ALFNAME   "PLGM5AL.LST"
#define  PLGM5AL2FNAME  "PLGM5AL2.LST"

/*
 *    Cell defines
 */
#define  CELLFNAME    "place.cel"
#define  INIFNAME     "place.ini"
#define  DRS_RSU_CELL  "0"
#define  LE_CELL       "1"
#define  DLS_CELL      "2"
#define  GSC_CELL      "3"
#define  ZC_CELL       "5"
#define  DTS_CELL      "6"
#define  BUILDING_CELL "BLDG"

/*
 *    General errors
 */
#define  ERROR_EOF            "Error: Unexpected end of data"
#define  ERROR_CELL           "Error: Cell library not found"
#define  ERROR_CELLNOTFOUND   "Error: Cell not found in library"
#define  ERROR_NOMEM          "Error: Out of Memory"
#define  ERROR_STRTOOLONG     "Error: String too Long. Truncated"
#define  ERROR_NOMORENODES    "Error: Node limit has been reached. Please see your System Administrator"

/*
 *    Mdl errors
 */
#define  MDL_DESCNEW          "Failed to create a new element descriptor"

#define  MAXSTR      132                  /* maximum string size */
#define  MAXCSTR      60                  /* maximum C string size */
#define  MAX_DETAIL_LINES   10            /* maximum number of detail lines per node */
#define  SEPERATOR   "###"                /* record delimiter/seperator */
#define  FONT_STYLE  1                    /* font style */
#define  FONT_HEIGHT  20                  /* font height in mu */
#define  LINE_OFFSET  25                  /* text line seperation in mu */
#define  HEADING_OFFSET 12                /* number of lines offset for heading */
#define  SCALE_FACTOR   6000.0            /* scale factor for placing cells */
#define  DRAW_LEVEL  0                    /* level to draw on */
#define  MAX_NODES   1000                 /* maximum number of nodes */
#define  MAX_VIEWS   8                    /* maxumum number of view screens */
#define  HIDE_LEVEL  17                   /* where text to be hidden is placed */
#define  NEXT_NODE   0                    /* next node - used in searches */
#define  PREV_NODE   1                    /* previous node - used in searches */
#define  COMMENT     ';'                  /* comment in place.ini */

/*
 * Linked list definitions
 */

#define MAX_HANDLES  9
#define PLGM5AA_HANDLE  0
#define PLGM5AB_HANDLE  1
#define PLGM5AJ_HANDLE  2
#define PLGM5AI_HANDLE  3
#define PLGM5AI2_HANDLE 4
#define PLGM5AK_HANDLE  5
#define PLGM5AK2_HANDLE 6
#define PLGM5AL_HANDLE  7
#define PLGM5AL2_HANDLE 8

typedef struct nodedata
{
   Dpoint3d       locatePt;
   Dpoint3d       endPt;         /* used as the endpoint for lines */

   ULong          tagID;

   int            duplicates;    /* number of nodes containing same coordinates */

   Coord          c;

   char           detailLine[MAX_DETAIL_LINES][MAXCSTR];

   int            dupNum;        /* number within duplicates */

   int            displayText;   /* determines whether text is to be displayed on viewing screen */

   int            networkLevel;  /* used by PLGM5AJ only */
} NodeData;

typedef struct displaysettings
{
   TextSizeParam  txtSize;
   TextParam      txtParams;
   int            textColor;
   double         lineOffset;
   double         headingOffset;
   double         cellScale;
   int            cellColor;
   int            multiCellColor;
   int            lineColor;
   int            lineWeight;

} DisplaySettings;


#endif
