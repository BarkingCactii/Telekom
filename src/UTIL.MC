/*----------------------------------------------------------------------*/
/* Program : util.mc                                                    */
/* Description : General Utility functions                              */
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
#include <stdlib/ctype.h>
#include "globals.h"

void ToLower ( char * str )
{
   while ( *str )
   {
      *str = tolower ( *str );
      str++;
   }
}

char * CStr ( char * str )
{
   int   idx;
   int   i;

   if ( !str )
      return str;

   idx = strlen ( str );
   if ( !idx )
      return str;

   for ( i = idx - 1; i; i-- )
   {
      if ( str[i] == '\n' || str[i] == '\r' || str[i] == ' ' )
         str[i] = 0;
      else
         break;   
   }

   if ( strlen ( str ) >= MAXCSTR )
   {
      mdlDialog_openInfoBox ( ERROR_STRTOOLONG );
      str[MAXCSTR - 1] = 0;
   }

   return str;   
}

void MidPoint ( Dpoint3d * result, Dpoint3d * p1, Dpoint3d * p2 )
{
   double   xDiff, yDiff;

   xDiff = fabs (( p1->x - p2->x ) / 2 );
   yDiff = fabs (( p1->y - p2->y ) / 2 );

   if ( p1->x < p2->x )
      result->x = p1->x + xDiff;
   else
      result->x = p2->x + xDiff;

   if ( p1->y < p2->y )
      result->y = p1->y + yDiff;
   else
      result->y = p2->y + yDiff;
}

void Polar ( Dpoint3d * origin, double angle, double dist, Dpoint3d * result )
{
   if ( dist == 0 )
   {
      result->x = origin->x;
      result->y = origin->y;
      result->z = 0;
   }
   else
   {
      result->x = origin->x + ( dist * cos ( angle ));
      result->y = origin->y + ( dist * sin ( angle ));	
      result->z = 0;
   }
}

double Bearing ( Dpoint3d * p1, Dpoint3d * p2 )
{
   double   brg;
   double   ratio;

   if (( p2->x - p1->x ) == 0. )
   {
      if (( p2->y - p1->y ) > 0.)
         brg = fc_pi / 2.;
      else
         brg = 1.5 * fc_pi;
   }
   else 
   {
      ratio = ( p2->y - p1->y ) / ( p2->x - p1->x );
      if ( ratio < 0 )
      {
         if (( p2->x - p1->x ) < 0.)
            brg = fc_pi + atan ( ratio );
         else
            brg = 2*fc_pi + atan ( ratio );
      }
      else
      {
         if (( p2->x - p1->x ) < 0 )
            brg = fc_pi + atan( ratio );
         else
            brg = atan( ratio );
      }
   }

   if ( brg > ( 2 * fc_pi )) 
      brg -= 2 * fc_pi;

   return ( brg );
}

static int SingleNode ( MSElement * elm, void * params, int operation, ULong offset, MSElementDescr * elmDesc )
{
   mdlElement_setSymbology ( elm, &display.cellColor, NULL, NULL );
   return 0;
}

static int MultipleNodes ( MSElement * elm, void * params, int operation, ULong offset, MSElementDescr * elmDesc )
{
   mdlElement_setSymbology ( elm, &display.multiCellColor, NULL, NULL );
   return 0;
}

int SingleCell ( MSElement * elm, void * params, int operation, ULong offset, MSElementDescr * elmDesc )
{
   int color;

   if ( elm->ehdr.type != CELL_HEADER_ELM )
      return 0;

   mdlElmdscr_operation ( elmDesc, SingleNode, NULL, ELMD_ELEMENT );
   return 0;
}

int DuplicateCells ( MSElement * elm, void * params, int operation, ULong offset, MSElementDescr * elmDesc )
{
   int color;

   if ( elm->ehdr.type != CELL_HEADER_ELM )
      return 0;

   mdlElmdscr_operation ( elmDesc, MultipleNodes, NULL, ELMD_ELEMENT );
   return 0;
}

int HideText2 ( MSElement * elm, void * params, int operation, ULong offset, MSElementDescr * elmDesc )
{
   int level;

   if ( elm->ehdr.type != TEXT_ELM )
      return 0;

   level = HIDE_LEVEL;   
   mdlElement_setProperties ( elm, &level, NULL, NULL, NULL, NULL, NULL, NULL, NULL );
   return 0;
}

int HideText ( MSElement * elm, void * params, int operation, ULong offset, MSElementDescr * elmDesc )
{
   if ( elm->ehdr.type != CELL_HEADER_ELM )
      return 0;

   mdlElmdscr_operation ( elmDesc, HideText2, NULL, ELMD_ELEMENT );
   return 0;
}

int ShowText2 ( MSElement * elm, void * params, int operation, ULong offset, MSElementDescr * elmDesc )
{
   int level;

   if ( elm->ehdr.type != TEXT_ELM )
      return 0;

   level = DRAW_LEVEL;   
   mdlElement_setProperties ( elm, &level, NULL, NULL, NULL, NULL, NULL, NULL, NULL );
   return 0;
}

int ShowText ( MSElement * elm, void * params, int operation, ULong offset, MSElementDescr * elmDesc )
{
   int color;

   if ( elm->ehdr.type != CELL_HEADER_ELM )
      return 0;

   mdlElmdscr_operation ( elmDesc, ShowText2, NULL, ELMD_ELEMENT );
   return 0;
}

void ClearViewScreen ( void )
{
   ULong *filePositions;
   int   *fileNums;
   int   numSelected;
   int   i;
   int   memAllocated;

   mdlSelect_allElements();
   numSelected = 0;
   memAllocated = mdlSelect_returnPositions ( &filePositions, &fileNums, &numSelected );
   for ( i = 0; i < numSelected; i++ )
      mdlElement_undoableDelete ( NULL, filePositions[i], TRUE );

   mdlSelect_freeAll ();
   if ( memAllocated == SUCCESS )
   {
      free ( filePositions );
      free ( fileNums );
   }

   mdlSystem_compressDgnFile ();
}

void UpdateViewScreen ( void )
{
   int   i;

   for ( i = 0; i < MAX_VIEWS; i++ )
   {
      if ( mdlView_isVisible ( i ) == TRUE )
         mdlView_updateSingle ( i );
   }
}
