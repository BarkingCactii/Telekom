/*----------------------------------------------------------------------*/
/* Program : plgm5ak.mc                                                 */
/* Description : Long Term Capacity Planning - List of deleted links    */
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

/*
 * parse the line containing coordinate values into the appropriate 
 * data types
 */

static int SetCoordLine ( NodeData * data, char * str )
{
   sscanf ( str, "%lf %lf %lf %lf %lf %lf %lf %lf %s", 
            &data->c.latitudeDegrees, &data->c.latitudeMinutes, &data->c.latitudeSeconds,
            &data->c.longitudeDegrees, &data->c.longitudeMinutes, &data->c.longitudeSeconds,
            &data->c.x, &data->c.y, data->detailLine[0] );
   return 1;
}


void GeneratePLGM5AK ( char * fName, char * fName2, double uor, int readFile )
{
   MSElementUnion elm;
   MSElementDescr *elmDP;
   MSElementDescr *cellDescr;
   MSElementDescr *cellTextDescr;
   int            i;
   NodeData       *dataP;
   int            dataSection;
   int            numNodes;
   DPoint3d       locatePt;
   int            level;

   /*
    * module initialization
    */
   elmDP = 0;

   if ( readFile )
   {
      if ( hand[PLGM5AK_HANDLE] != INVALID_HANDLE )
      {
         l_free ( hand[PLGM5AK_HANDLE] );
         hand[PLGM5AK_HANDLE] = INVALID_HANDLE;
      }
      if (( hand[PLGM5AK_HANDLE] = l_gethandle ()) == LIST_FULL )
      {
         mdlDialog_openInfoBox ( ERROR_NOMEM );
         return;
      }
   }
   else
   {
      if ( hand[PLGM5AK_HANDLE] == INVALID_HANDLE )
         return;
   }

   dataSection = 0;
   
   /*
    * read the data file
    */

   if ( readFile )
   {
      if ( !ReadFile ( fName,  uor,  SetCoordLine, hand[PLGM5AK_HANDLE], 1 ))
         return;
   }

   /*
    * check if any nodes are overlaid. This is accomplished by
    * sorting the points and doing a comparison on adjacent values.
    * The duplicates value is adjusted accordingly
    */

   if ( readFile )
      SetDuplicates ( hand[PLGM5AK_HANDLE] );

   /*
    * now generate the graphics
    */

   for ( dataP = l_head ( hand[PLGM5AK_HANDLE] ); dataP; dataP = l_next ( hand[PLGM5AK_HANDLE] ))
   {
      locatePt.x = dataP->locatePt.x;
      locatePt.y = dataP->locatePt.y;
      locatePt.z = 0;

      mdlCell_create ( &elm, NULL, &locatePt, FALSE );
      mdlElmdscr_new ( &elmDP, NULL, &elm );

      if ( dataSection )
      {
         /*
          *    Place the cell
          */
         if ( GetCellDescriptor ( BUILDING_CELL, &cellDescr, &cellTextDescr, &locatePt ))
         {
            if ( cellDescr )
            {
               if ( dataP->duplicates )
                  mdlElmdscr_operation ( cellDescr, DuplicateCells, NULL, ELMD_ALL_ONCE ); 
               else
                  mdlElmdscr_operation ( cellDescr, SingleCell, NULL, ELMD_ALL_ONCE ); 

               mdlElmdscr_appendDscr ( elmDP, cellDescr );
            }
         }
      }
      else
      {
         Dpoint3d line[2];
         
         line[0].x = locatePt.x;
         line[0].y = locatePt.y;
         line[0].z = 0;
         line[1].x = locatePt.x;
         line[1].y = locatePt.y;
         line[1].z = 0;

         mdlLine_create( &elm, NULL, line );
         mdlElmdscr_appendElement ( elmDP, &elm);
      }

      dataSection = 1;

      for ( i = 0; i < MAX_DETAIL_LINES; i++ )
      {
         if ( strlen ( dataP->detailLine[i] ))
         {
            /*
             *    Place a line of text on screen
             */
            locatePt.y -= display.lineOffset;
            mdlText_create ( &elm, NULL, dataP->detailLine[i], &locatePt, &display.txtSize, NULL, &display.txtParams, NULL );
            mdlElement_setSymbology ( &elm, &display.textColor, NULL, NULL );
            if ( dataP->displayText == 0 )
               level = DRAW_LEVEL;
            else
               level = HIDE_LEVEL;
            mdlElement_setProperties ( &elm, &level, NULL, NULL, NULL, NULL, NULL, NULL, NULL );
            mdlElmdscr_appendElement ( elmDP, &elm);
         }
      }
      /*
       *    Add to the design file and place on screen
       */
      mdlElmdscr_display( elmDP, 0, NORMALDRAW );
      mdlAssoc_tagElement( &dataP->tagID, mdlElmdscr_add ( elmDP ), 0 );
      mdlElmdscr_freeAll (&elmDP);
   }

   GeneratePLGM5AK2 ( fName2, uor, readFile );
}

