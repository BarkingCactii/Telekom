/*----------------------------------------------------------------------*/
/* Program : display.mc                                                 */
/* Description : Display settings                                       */
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

DisplaySettings display;
static int apply;

void SetDefaultDisplaySettings ( void )
{
   memset (( void * ) &display.txtParams, 0, sizeof ( display.txtParams ));

   display.txtParams.font = FONT_STYLE;
   display.txtSize.size.width = FONT_HEIGHT * uor;
   display.txtSize.size.height = FONT_HEIGHT * uor;

   display.lineOffset = LINE_OFFSET * uor;
   display.headingOffset = HEADING_OFFSET * ( LINE_OFFSET * uor );

   display.textColor = 0;

   display.cellScale = SCALE_FACTOR;
   display.cellColor = 4; /* YELLOW comes out brown */;
   display.multiCellColor = GREEN;

   display.lineColor = 0;
   display.lineWeight = 0;
}

void Hook_Display ( DialogMessage *dmP )
{
   ULong    iFont;
   char     igdsFontName[80], igdsFontString[80];

   dmP->msgUnderstood = TRUE;
   switch ( dmP->messageType )
   {
       case DIALOG_MESSAGE_INIT:
          apply = 0;
       break;

       case DIALOG_MESSAGE_FOCUSOUT:
          display.txtSize.size.width = display.txtSize.size.height;
       case DIALOG_MESSAGE_DESTROY:
          if ( apply )
          {
             ClearViewScreen ();
             GeneratePLGM5AA ( 0, uor, 0 );
             GeneratePLGM5AB ( 0, uor, 0 );
             GeneratePLGM5AI ( 0, 0, uor, 0 );
             GeneratePLGM5AJ ( 0, uor, 0 );
             GeneratePLGM5AK ( 0, 0, uor, 0 );
             GeneratePLGM5AL ( 0, 0, uor, 0 );
             UpdateViewScreen ();
          }
       break;          
       default:
          dmP->msgUnderstood = FALSE;
       break;
   }
}

void HookItem_DisplayFont ( DialogItemMessage *dimP )
{
   ULong     iFont;
   char      igdsFontName[80], igdsFontString[80];

   dimP->msgUnderstood = TRUE;

   switch (dimP->messageType)
   {
      case DITEM_MESSAGE_CREATE:
      {
         if (dimP->dialogItemP->id == OPTIONBUTTONID_TextFont)
         {
            for (iFont=0; iFont < 255; iFont++)
            {
               if (mdlText_fontExists (iFont))
               {
                  mdlText_getFontName ( igdsFontName, iFont );
                  strlwr ( &igdsFontName[1] );
                  sprintf ( igdsFontString, "%d - %s", iFont, igdsFontName );
                  mdlDialog_optionButtonInsertItem ( igdsFontString, NULL, NULL, NULL, &iFont, NULL, NULL, NULL, dimP->dialogItemP->rawItemP, -1 );
               }
            }
         }
      }
      break;

      default:
           dimP->msgUnderstood = FALSE;
      break;
     }
}

void HookItem_DisplayApply ( DialogItemMessage *dimP )
{
     dimP->msgUnderstood = TRUE;

     switch (dimP->messageType)
     {
        case DITEM_MESSAGE_BUTTON:
         if ( dimP->u.button.buttonTrans == BUTTONTRANS_UP )
         {
            apply = 1;
            mdlDialog_closeCommandQueue ( dimP->db );
         }
        break;

          default:
               dimP->msgUnderstood = FALSE;
          break;
     }
}

void HookItem_DisplayHeight ( DialogItemMessage *dimP )
{
   dimP->msgUnderstood = TRUE;
   
   switch (dimP->messageType)
   {
       case DITEM_MESSAGE_STATECHANGED:
          display.txtSize.size.width = display.txtSize.size.height;
       break;

       default:
          dimP->msgUnderstood = FALSE;
       break;
   }
}
