/*--------------------------------------------------------------------------*/
/* Program : place.mc                                                       */
/* Description : Generate a graphic for switches based on given datafiles   */
/* Coded by : Jeff Hill ( jeff@reoforce.com.au )                            */
/*            PO Box 871 Beenleigh QLD 4207 Australia                       */
/*            Phone: 61-7-55465006                                          */
/*--------------------------------------------------------------------------*/

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
#include "dlogdcmd.h"

double      uor = 0.0;
short		   levelMask[MAX_LEVELS/16];
_L_HANDLE   hand[MAX_HANDLES];               /* linked list handle array */
char        dataPath[MAXSTR];                /* directory containing data files */
RefPoints   ref;                             /* reference points read from ini file */
char        iniFname[MAXSTR];                /* full file spec for ini file */
char        dgnFname[MAXSTR];                /* full file spec for design file */

Private void Hook_placeToolBox ( DialogMessage *dmP )
{
   dmP->msgUnderstood = TRUE;

   switch (dmP->messageType)
   {
      case DIALOG_MESSAGE_DESTROY:
      {
         /* unload this mdl task when the Main Dialog is closed */
         mdlDialog_cmdNumberQueue (FALSE, CMD_MDL_UNLOAD, mdlSystem_getCurrTaskID(), TRUE);
      }

      default:
         dmP->msgUnderstood = FALSE;
      break;
   }
}

Public cmdName void Cmd1 ( char * unparsedP )
cmdNumber CMD_CMD1
{
   char  fileSpec[MAXSTR];

   strcpy ( fileSpec, dataPath );
   strcat ( fileSpec, PLGM5AAFNAME );
   GeneratePLGM5AA ( fileSpec, uor, 1 );
}

Public cmdName void Cmd2 ( char * unparsedP )
cmdNumber CMD_CMD2
{
   char  fileSpec[MAXSTR];

   strcpy ( fileSpec, dataPath );
   strcat ( fileSpec, PLGM5ABFNAME );
   GeneratePLGM5AB ( fileSpec, uor, 1 );
}

Public cmdName void Cmd3 ( char * unparsedP )
cmdNumber CMD_CMD3
{
   char  fileSpec[MAXSTR];
   char  fileSpec2[MAXSTR];

   strcpy ( fileSpec, dataPath );
   strcat ( fileSpec, PLGM5AIFNAME );
   strcpy ( fileSpec2, dataPath );
   strcat ( fileSpec2, PLGM5AI2FNAME );
   GeneratePLGM5AI ( fileSpec, fileSpec2, uor, 1 );
}

Public cmdName void Cmd4 ( char * unparsedP )
cmdNumber CMD_CMD4
{
   char  fileSpec[MAXSTR];

   strcpy ( fileSpec, dataPath );
   strcat ( fileSpec, PLGM5AJFNAME );
   GeneratePLGM5AJ ( fileSpec, uor, 1 );
}

Public cmdName void Cmd5 ( char * unparsedP )
cmdNumber CMD_CMD5
{
   char  fileSpec[MAXSTR];
   char  fileSpec2[MAXSTR];

   strcpy ( fileSpec, dataPath );
   strcat ( fileSpec, PLGM5AKFNAME );
   strcpy ( fileSpec2, dataPath );
   strcat ( fileSpec2, PLGM5AK2FNAME );
   GeneratePLGM5AK ( fileSpec, fileSpec2, uor, 1 );
}

Public cmdName void Cmd6 ( char * unparsedP )
cmdNumber CMD_CMD6
{
   char  fileSpec[MAXSTR];
   char  fileSpec2[MAXSTR];

   strcpy ( fileSpec, dataPath );
   strcat ( fileSpec, PLGM5ALFNAME );
   strcpy ( fileSpec2, dataPath );
   strcat ( fileSpec2, PLGM5AL2FNAME );
   GeneratePLGM5AL ( fileSpec, fileSpec2, uor, 1 );
}

Public cmdName void Cmd7 ( char * unparsedP )
cmdNumber CMD_CMD7
{
   ClearViewScreen ();
   UpdateViewScreen ();
}

Public cmdName void Cmd8 ( char * unparsedP )
cmdNumber CMD_CMD8
{
   ClearViewScreen ();
   mdlSystem_closeDesignFile ();
   mdlSystem_exit ( 0, 1 );
}

Public cmdName void Cmd9 ( char * unparsedP )
cmdNumber CMD_CMD9
{
   mdlLocate_setCursor ();
   mdlState_setFunction( STATE_DATAPOINT, DataButton_SelectEntity );
   mdlState_setFunction( STATE_RESET, NULL );
   mdlDialog_open ( NULL, DIALOGID_Details );
}

Public cmdName void Cmd10 ( char * unparsedP )
cmdNumber CMD_CMD10
{
   mdlDialog_open ( NULL,DIALOGID_DisplaySettings );
}

Private DialogHookInfo uHooks[] =
 {
   { HOOKID_Graph, Hook_placeToolBox },
   { HOOKID_Details, Hook_details },
   { HOOKITEMID_DetailsPrevious,  HookItem_DetailsPrevious },
   { HOOKITEMID_DetailsNext,  HookItem_DetailsNext },
   { HOOKITEMID_DetailsShow,  HookItem_DetailsShow },
   { HOOKID_Display, Hook_Display },
   { HOOKITEMID_DisplayFont, HookItem_DisplayFont },
   { HOOKITEMID_DisplayApply, HookItem_DisplayApply },
   { HOOKITEMID_DisplayHeight, HookItem_DisplayHeight },
 };

static void NewDesignFile ( char* fileName, int state )
{
   int   i;

   if ( state == SYSTEM_NEWFILE_COMPLETE )
   {
      strcpy ( dgnFname, fileName );
      mdlSystem_loadMdlProgram ( "PLACE", mdlSystem_getCurrTaskID(), NULL );

      if ( !ReadIniFile ( iniFname, dataPath, fileName ))
      {
         mdlDialog_cmdNumberQueue (FALSE, CMD_MDL_UNLOAD, mdlSystem_getCurrTaskID(), TRUE);
         mdlSystem_unloadMdlProgram ( mdlSystem_getCurrTaskID());
      }

      uor = tcb->subpermast*tcb->uorpersub;
      SetDefaultDisplaySettings ();
      for ( i = 0; i < MAX_HANDLES; i++ )
      {
         if ( hand[i] != INVALID_HANDLE )
            l_free ( hand[i] );
      }
   }
   if ( state == SYSTEM_NEWFILE_CLOSE )
   {
      ClearViewScreen ();
      mdlSystem_unloadMdlProgram ( mdlSystem_getCurrTaskID());
   }
}

static void Reload ( int argc, char* argv[] )
{
   int i;

   if ( !ReadIniFile ( iniFname, dataPath, dgnFname ))
   {
      mdlDialog_cmdNumberQueue (FALSE, CMD_MDL_UNLOAD, mdlSystem_getCurrTaskID(), TRUE);
      mdlSystem_unloadMdlProgram ( mdlSystem_getCurrTaskID());
   }

   uor = tcb->subpermast*tcb->uorpersub;
   SetDefaultDisplaySettings ();
   for ( i = 0; i < MAX_HANDLES; i++ )
   {
      if ( hand[i] != INVALID_HANDLE )
         l_free ( hand[i] );
   }
}

int main ( int argc, char * argv[] )
{
   RscFileHandle  rfHandle;
   char           *setP;
   DialogBox      *dbP;
   char           tmpStr[MAXSTR];
   int            i;

   mdlResource_openFile (&rfHandle, NULL, FALSE);

   if ( mdlParse_loadCommandTable ( NULL ) == NULL )
      mdlOutput_rscPrintf ( MSG_ERROR, NULL, 0, 4 );

   setP = mdlCExpression_initializeSet (VISIBILITY_DIALOG_BOX, 0, FALSE);

   mdlDialog_publishComplexVariable (setP, "displaysettings", "display", &display); 
   mdlDialog_publishComplexPtr (setP, "nodedata", "nodeDetails", &nodeDetails); 

   /* publish our hook functions */
   mdlDialog_hookPublish (sizeof(uHooks)/sizeof(DialogHookInfo), uHooks);

   /*
    * global initialization
    */

   strcpy ( iniFname, argv[0] );
   i = strlen ( iniFname ) - 1;
   while ( iniFname[i] != '/' && iniFname[i] != '\\' )
      i--;
   iniFname[i + 1] = 0;
   strcat ( iniFname, INIFNAME );
   dgnFname[0] = 0;
   if ( !ReadIniFile ( iniFname, dataPath, tcb->dgnfilenm ))
   {
      mdlDialog_cmdNumberQueue (FALSE, CMD_MDL_UNLOAD, mdlSystem_getCurrTaskID(), TRUE);
      mdlSystem_unloadMdlProgram ( mdlSystem_getCurrTaskID());
   }

   uor = tcb->subpermast*tcb->uorpersub;
   SetDefaultDisplaySettings ();
   for ( i = 0; i < MAX_HANDLES; i++ )
      hand[i] = INVALID_HANDLE;

   /*
    * make sure text hide level is off
    */
   memset (( void * ) levelMask, 0, sizeof ( levelMask ));
   levelMask[1] = 1;  /* turn off level 17 */
   mdlView_setLevels ( FALSE, levelMask, statedata.viewflags, TRUE );

   /*
    * attach the cell library   
    */
   if ( mdlCell_attachLibrary ( tmpStr, CELLFNAME, NULL, TRUE ) != SUCCESS )
   {
      mdlDialog_openInfoBox ( ERROR_CELL );
      mdlDialog_cmdNumberQueue (FALSE, CMD_MDL_UNLOAD, mdlSystem_getCurrTaskID(), TRUE);
      return 0;
   }

   mdlSystem_setFunction ( SYSTEM_NEW_DESIGN_FILE, NewDesignFile );
   mdlSystem_setFunction ( SYSTEM_RELOAD_PROGRAM, Reload );

   dbP = mdlDialog_open(NULL,DIALOGID_Graph);

   return 1;
}
