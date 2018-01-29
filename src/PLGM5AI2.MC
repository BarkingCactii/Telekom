/*----------------------------------------------------------------------*/
/* Program : plgm5ai2.mc                                                */
/* Description : Building to Building Circuit forcast                   */
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
   sscanf ( str, "%lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf", 
            &data->c.latitudeDegrees, &data->c.latitudeMinutes, &data->c.latitudeSeconds,
            &data->c.longitudeDegrees, &data->c.longitudeMinutes, &data->c.longitudeSeconds,
            &data->c.x, &data->c.y,
            &data->c.toLatitudeDegrees, &data->c.toLatitudeMinutes, &data->c.toLatitudeSeconds,
            &data->c.toLongitudeDegrees, &data->c.toLongitudeMinutes, &data->c.toLongitudeSeconds,
            &data->c.tox, &data->c.toy );
   return 0;

}

void GeneratePLGM5AI2 ( char * fName, double uor, int readFile )
{
   MSElementUnion elm;
   MSElementDescr *elmDP;
   MSElementDescr *cellDescr;
   MSElementDescr *cellTextDescr;
   int            i;
   NodeData       *dataP;
   int            numNodes;
   DPoint3d       locatePt;
   int            level;
   Dpoint3d       line[2];
   Dpoint3d       origin;
   RotMatrix      rotate;
   double         angle;

   /*
    * module initialization
    */
   elmDP = 0;

   if ( readFile )
   {
      if ( hand[PLGM5AI2_HANDLE] != INVALID_HANDLE )
      {
         l_free ( hand[PLGM5AI2_HANDLE] );
         hand[PLGM5AI2_HANDLE] = INVALID_HANDLE;
      }
      if (( hand[PLGM5AI2_HANDLE] = l_gethandle ()) == LIST_FULL )
      {
         mdlDialog_openInfoBox ( ERROR_NOMEM );
         return;
      }
   }
   else
   {
      if ( hand[PLGM5AI2_HANDLE] == INVALID_HANDLE )
         return;
   }

   /*
    * read the data file
    */

   if ( readFile )
   {
      if ( !ReadFile ( fName,  uor,  SetCoordLine, hand[PLGM5AI2_HANDLE], 0 ))
         return;
   }

   /*
    * check if any nodes are overlaid. This is accomplished by
    * sorting the points and doing a comparison on adjacent values.
    * The duplicates value is adjusted accordingly
    */

   if ( readFile )
      SetDuplicates ( hand[PLGM5AI2_HANDLE] );

   /*
    * now generate the graphics
    */

   for ( dataP = l_head ( hand[PLGM5AI2_HANDLE] ); dataP; dataP = l_next ( hand[PLGM5AI2_HANDLE] ))
   {
      locatePt.x = dataP->locatePt.x;
      locatePt.y = dataP->locatePt.y;
      locatePt.z = 0;

      mdlCell_create ( &elm, NULL, &locatePt, FALSE );
      mdlElmdscr_new ( &elmDP, NULL, &elm );

      line[0].x = dataP->locatePt.x;
      line[0].y = dataP->locatePt.y;
      line[0].z = 0;
      line[1].x = dataP->endPt.x;
      line[1].y = dataP->endPt.y;
      line[1].z = 0;

      mdlLine_create( &elm, NULL, line );
      mdlElement_setSymbology ( &elm, &display.lineColor, &display.lineWeight, NULL );
      mdlElmdscr_appendElement ( elmDP, &elm);

      MidPoint ( &origin, &line[0], &line[1] );

      for ( i = 0; i < MAX_DETAIL_LINES; i++ )
      {
         if ( strlen ( dataP->detailLine[i] ))
         {
            /*
             *    Place a line of text on screen
             */
            angle = Bearing ( &line[0], &line[1] );
            if ( angle > fc_pi / 2 && angle < ( 2 * fc_pi ) - ( fc_pi / 2 ))
               angle -= fc_pi;

            mdlRMatrix_fromAngle ( &rotate, angle );
            angle -= fc_pi / 2; 
            Polar ( &origin, angle, display.lineOffset, &origin );
            mdlText_create( &elm, NULL, dataP->detailLine[i], &origin, &display.txtSize, &rotate, &display.txtParams, NULL);
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
}

