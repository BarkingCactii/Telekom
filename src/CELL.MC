/*----------------------------------------------------------------------*/
/* Program : cell.mc                                                    */
/* Description : Cell retrieval routines                                */
/* Coded by : Jeff Hill ( jeff@reoforce.com.au )                        */
/*            PO Box 871 Beenleigh QLD 4207 Australia                   */
/*            Phone: 61-7-55465006                                      */
/*----------------------------------------------------------------------*/

#include <mdl.h>
#include <userfnc.h>
#include <mselems.h>
#include <cmdlist.h>
#include <mdlerrs.h>
#include <rscdefs.h>
#include <dlogitem.h>
#include <global.h>
#include <cexpr.h>
#include <tcb.h>
#include <dlogman.fdf>
#include <mssystem.fdf>
#include <msselect.fdf>
#include <stdlib/time.h>
#include <stdlib/float.h>
#include "globals.h"

int GetCellDescriptor ( char * cellName, MSElementDescr ** cellDescr, MSElementDescr ** cellTextDescr, DPoint3d * cellOrigin ) 
{
   double    xRange, yRange;
   DPoint3d  scalePt;
   ULong     filePos;
   char      tmpStr[MAXSTR];

   if ( mdlCell_existsInLibrary ( cellName ) != TRUE )
   {
      sprintf ( tmpStr, "%s %s", cellName, ERROR_CELLNOTFOUND );
      mdlDialog_openInfoBox ( tmpStr );
      return 0;
   }

   if (( filePos = mdlCell_getFilePosInLibrary ( cellName )) == 0 )
   {
      sprintf ( tmpStr, "%s %s", cellName, ERROR_CELLNOTFOUND );
      mdlDialog_openInfoBox ( tmpStr );
      return 0;
   }
/*
   if ( mdlCell_getFilePosition( &filePos, cellName, NULL, TRUE ) != SUCCESS )
   {
      sprintf ( tmpStr, "2 %s %s", cellName, ERROR_CELLNOTFOUND );
      mdlDialog_openInfoBox ( tmpStr );
      return 0;
   }
*/
   scalePt.x = display.cellScale;
   scalePt.y = display.cellScale;
   scalePt.z = display.cellScale;

   /* 
    * Retrieve descriptor from cell library 
    */

   if ( mdlCell_getElmDscr ( cellDescr, cellTextDescr, filePos, cellOrigin, &scalePt, NULL, NULL, 0, 0, NULL ) != SUCCESS )
   {
      sprintf ( tmpStr, "%s %s", cellName, ERROR_CELLNOTFOUND );
      mdlDialog_openInfoBox ( tmpStr );
      return 0;
   }

   mdlCell_fixLevels ( *cellDescr, FALSE, DRAW_LEVEL );

   return 1;
}
