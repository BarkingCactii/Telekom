/*----------------------------------------------------------------------*/
/* Program : details.mc                                                 */
/* Description : Details dialog box                                     */
/* Coded by : Jeff Hill ( jeff@reoforce.com.au )                        */
/*            PO Box 871 Beenleigh QLD 4207 Australia                   */
/*            Phone: 61-7-55465006                                      */
/*----------------------------------------------------------------------*/

#include <mscexpr.fdf>
#include <msrsrc.fdf>
#include <cmdlist.h>
#include <msparse.fdf>
#include <msselect.fdf>
#include <tcb.h>
#include <msoutput.fdf>
#include <msinput.fdf>
#include <mssystem.fdf>
#include <cexpr.h>
#include <dlogman.fdf>
#include <userfnc.h>
#include "globals.h"

static MSElementDescr * elmDP = 0;
NodeData *nodeDetails;
NodeData *tmpDetails;
static NodeData emptyNodeDetails;
DialogBox *detailsDB;
static ULong previousFilepos = 0;
static int previousIdx;
static int nextIdx;
static   ULong          filepos;

static int entityFound = 0;
static int listIdx;

/*
 *    check if the entity the user selected is in our list
 */
int EntityFound ( unsigned long elemID, NodeData ** details, _L_HANDLE hand )
{
   NodeData     *dataP;
   int           i;

   if ( hand != INVALID_HANDLE )
   {
      for ( dataP = l_head ( hand ); dataP; dataP = l_next ( hand ))
      {
         if ( dataP->tagID == elemID )
         {
            *details = dataP;         
            l_make_current ( hand, dataP );
            entityFound = 1;
            return 1;
         }
      }
   }

   entityFound = 0;
   return 0;
}

/*
 *    Get the pointer for the next node on the same coordinate
 */
int NextEntity ( NodeData ** detailsP, int mark )
{
   NodeData    *lastP;
   NodeData     *dataP;
   NodeData    *details;
   int         i;

   if ( !entityFound )
      return 0;

   if (( lastP = l_current ( hand[listIdx] )) == 0 )
      return 0;

   details = *detailsP;

   for ( dataP = l_next ( hand[listIdx] ); dataP; dataP = l_next ( hand[listIdx] ))
   {
      if ( details->locatePt.x == dataP->locatePt.x && 
           details->locatePt.y == dataP->locatePt.y )
      {
            *detailsP = dataP;
            if ( !mark )
               l_make_current ( hand[listIdx], lastP );
            return 1;
      }
   }

   l_make_current ( hand[listIdx], lastP );

   return 0;
}

/*
 *    Get the pointer for the previous node on the same coordinate
 */
int PreviousEntity ( NodeData ** detailsP, int mark )
{
   NodeData    *lastP;
   NodeData     *dataP;
   NodeData     *details;
   int         i;

   if ( !entityFound )
      return 0;

   if (( lastP = l_current ( hand[listIdx] )) == 0 )
      return 0;

   details = *detailsP;

   for ( dataP = l_prev ( hand[listIdx] ); dataP; dataP = l_prev ( hand[listIdx] ))
   {
      if ( details->locatePt.x == dataP->locatePt.x && 
           details->locatePt.y == dataP->locatePt.y )
      {
            *detailsP = dataP;
            if ( !mark )
               l_make_current ( hand[listIdx], lastP );
            return 1;
      }
   }

   l_make_current ( hand[listIdx], lastP );

   return 0;
}

static int GetDBSize( DialogBox *thisDB, double *currWidth, double *currHeight )
{
   MSDisplayDescr *dp;
   Rectangle      lrect;

   if ( !( dp = mdlWindow_displayDescrGet ( thisDB ) ) )
      return 0;

   mdlWindow_contentRectGetLocal( &lrect, thisDB );
   if ( currWidth )
      *currWidth  = lrect.corner.x - lrect.origin.x + 1;
   if ( currHeight )
      *currHeight = lrect.corner.y - lrect.origin.y + 1;

   return 1;
}

static void SetNewDBSize( DialogBox *thisDB, double newWidth )
{
   double   fontHeight;
   double   currWidth, currHeight;
   double   width, height;

   if ( ! GetDBSize ( thisDB, &currWidth, &currHeight ))
      return;

   fontHeight = mdlDialog_fontGetCurHeight ( thisDB );

   width = newWidth * XC * fontHeight / DCOORD_RESOLUTION;

   mdlWindow_extentSet ( thisDB, width, currHeight );
}

static void UpdateDetails ( void )
{
   int   i;
   DialogItem          *dbItem;
   char                 tmpStr[MAXSTR];
   char                *tmpStrP;
   int                  maxTextLine = MIN_DETAILS_SIZE;

   for ( i = LABELID_Details1; i <= LABELID_Details10; i++ ) 
   {
      if ( ( dbItem = mdlDialog_itemGetByTypeAndId ( detailsDB, RTYPE_Label, i, 0 ) ) )
      {
         tmpStrP = nodeDetails->detailLine[i - LABELID_Details1];
         mdlDialog_itemSetLabel ( detailsDB, dbItem->itemIndex, tmpStrP );
         if ( strlen ( tmpStrP ) > maxTextLine + 5 )
            maxTextLine = strlen ( tmpStrP ) + 5;
      }
   }

   SetNewDBSize( detailsDB, ( double )( maxTextLine ));

   if ( nodeDetails->duplicates )
   {
      tmpStr[0] = 0;
      tmpDetails = nodeDetails;

      if ( NextEntity ( &tmpDetails, 0 ))
         mdlDialog_itemShow ( detailsDB, nextIdx );
      else
         mdlDialog_itemHide ( detailsDB, nextIdx, FALSE );

      if ( PreviousEntity ( &tmpDetails, 0 ))
         mdlDialog_itemShow ( detailsDB, previousIdx );
      else
         mdlDialog_itemHide ( detailsDB, previousIdx, FALSE );
   }
   else
   {
      tmpStr[0] = 0;
      mdlDialog_itemHide ( detailsDB, previousIdx, FALSE );
      mdlDialog_itemHide ( detailsDB, nextIdx, FALSE );
   }
/*
   if ( ( dbItem = mdlDialog_itemGetByTypeAndId ( detailsDB, RTYPE_Label, LABELID_Details11, 0 ) ) )
      mdlDialog_itemSetLabel ( detailsDB, dbItem->itemIndex, tmpStr );
*/
   mdlDialog_itemsSynch ( detailsDB );
}

static void ShowDetails ( ULong elemID )
{
   int   i;

   for ( i = 0; i < MAX_LISTS; i++ )
   {
      if ( EntityFound ( elemID, &nodeDetails, hand[i] ))
      {
         listIdx = i;
         UpdateDetails ();
         return;
      }
   }
   listIdx = -1;
}

static void HiliteEntity ( ULong elemID, int pickedFromScreen )
{
   MSElementUnion elm;

   if ( !pickedFromScreen )
   {
      mdlAssoc_getElement ( &elm, &filepos, elemID, 0 );
   }

   if ( previousFilepos )
      mdlElmdscr_displayFromFile ( previousFilepos, 0, NULL, NORMALDRAW );

   previousFilepos = filepos;
   mdlElmdscr_displayFromFile ( filepos, 0, NULL, HILITE );
   
   ShowDetails ( elemID );

   /*
    * save the element descriptor
    */

   mdlElmdscr_freeAll ( &elmDP );
   mdlElmdscr_read ( &elmDP, filepos, 0, FALSE, NULL );
}

void DataButton_SelectEntity ( Dpoint3d *point, int view )
{
   MSElement      elem;
   ULong          elemID;

   filepos = mdlLocate_findElement ( point, view, 0, 0, FALSE );

   if ( !filepos )
       return;

   if ( mdlElement_read ( &elem, 0, filepos ) == SUCCESS )
   {
      if ( mdlAssoc_isTagged ( &elemID, &elem ) == TRUE )
      {
         HiliteEntity ( elemID, 1 );
      }
   }
}

void Hook_details ( DialogMessage *dmP )
{
   dmP->msgUnderstood = TRUE;

   switch (dmP->messageType)
   {
      case DIALOG_MESSAGE_CREATE:
         nodeDetails = &emptyNodeDetails;
         tmpDetails = nodeDetails;
         listIdx = -1;
      break;
      case DIALOG_MESSAGE_INIT:
         detailsDB = dmP->db;
         mdlDialog_itemHide ( dmP->db, nextIdx, FALSE );
         mdlDialog_itemHide ( dmP->db, previousIdx, FALSE );
      break;
      case DIALOG_MESSAGE_DESTROY:
         entityFound = 0;
         listIdx = -1;
         mdlElmdscr_freeAll ( &elmDP );
         if ( previousFilepos )
            mdlElmdscr_displayFromFile ( previousFilepos, 0, NULL, NORMALDRAW );
         mdlState_startDefaultCommand();
      break;
      default:
         dmP->msgUnderstood = FALSE;
      break;
   }
}

void HookItem_DetailsPrevious ( DialogItemMessage *dimP )
{
   dimP->msgUnderstood = TRUE;
   switch (dimP->messageType)
   {
      case DITEM_MESSAGE_CREATE:
         previousIdx = dimP->itemIndex;
      break;
      case DITEM_MESSAGE_INIT:
         mdlDialog_itemHide ( dimP->db, dimP->itemIndex, FALSE );
      break;
      case DITEM_MESSAGE_STATECHANGED:
      case DITEM_MESSAGE_BUTTON:
         if ( dimP->u.button.buttonTrans == BUTTONTRANS_UP )
         {
            if ( PreviousEntity ( &nodeDetails, 1 ))
               HiliteEntity ( nodeDetails->tagID, 0 );

            tmpDetails = nodeDetails;
            if ( !PreviousEntity ( &tmpDetails, 0 ))
               mdlDialog_itemHide ( dimP->db, dimP->itemIndex, FALSE );
            if ( entityFound )
               mdlDialog_itemShow ( dimP->db, nextIdx );
         }
      break;
      default:
         dimP->msgUnderstood = FALSE;
      break;
   }
}

void HookItem_DetailsNext ( DialogItemMessage *dimP )
{
   dimP->msgUnderstood = TRUE;
   switch (dimP->messageType)
   {
      case DITEM_MESSAGE_CREATE:
         nextIdx = dimP->itemIndex;
      break;
      case DITEM_MESSAGE_INIT:
         mdlDialog_itemHide ( dimP->db, dimP->itemIndex, FALSE );
      break;
      case DITEM_MESSAGE_STATECHANGED:
      case DITEM_MESSAGE_BUTTON:
         if ( dimP->u.button.buttonTrans == BUTTONTRANS_UP )
         {
            if ( NextEntity ( &nodeDetails, 1 ))
               HiliteEntity ( nodeDetails->tagID, 0 );

            tmpDetails = nodeDetails;
            if ( !NextEntity ( &tmpDetails, 0 ))
               mdlDialog_itemHide ( dimP->db, dimP->itemIndex, FALSE );
            if ( entityFound )
               mdlDialog_itemShow ( dimP->db, previousIdx );
         }
      break;
      default:
         dimP->msgUnderstood = FALSE;
      break;
   }
}

void HookItem_DetailsShow ( DialogItemMessage *dimP )
{
   dimP->msgUnderstood = TRUE;
   switch (dimP->messageType)
   {
      case DITEM_MESSAGE_STATECHANGED:
           if ( !elmDP )
              return;

            if ( nodeDetails->displayText == 0 )
               mdlElmdscr_operation ( elmDP, ShowText, NULL, ELMD_ALL_ONCE ); 
            else
               mdlElmdscr_operation ( elmDP, HideText, NULL, ELMD_ALL_ONCE ); 
            mdlElmdscr_rewrite ( elmDP, NULL, filepos );
            UpdateViewScreen ();
      break;
      default:
         dimP->msgUnderstood = FALSE;
      break;
   }
}
