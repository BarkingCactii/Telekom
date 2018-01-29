/*----------------------------------------------------------------------*/
/* Program : fileio.mc                                                  */
/* Description : File Input routines                                    */
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

int ReadIniFile ( char * fName, char * basePath, char * fullDgnFName )
{
   FILE          *fin;
   char           tmpString[255];
   char           dgnName[MAXSTR];
   char           dgnNameInFile[MAXSTR];
   int            i;
   int            fileMatch = 0;

   /*
    * detemine the base design file name
    */
   if ( *fullDgnFName )
   {
      i = strlen ( fullDgnFName ) - 1;
      while ( fullDgnFName[i] != '/' && fullDgnFName[i] != '\\' )
         i--;
      strcpy ( dgnName, &fullDgnFName[i+1] );
      ToLower ( dgnName );
   }
   else
      fileMatch = 1;

   /*
    * open the ini file
    */

   if (( fin = fopen ( fName,"r" )) == NULL )
   {
      sprintf ( tmpString, "Error opening Initialization file %s", fName );
      mdlDialog_openInfoBox ( tmpString );
      return 0;
   }

   for ( fgets ( tmpString, sizeof ( tmpString ), fin ); !feof ( fin ); fgets ( tmpString, sizeof ( tmpString ), fin ))
   {
      if ( tmpString[0] == COMMENT )
         /*
          * comment, so continue
          */
         continue;

      ToLower ( tmpString );
      if ( memcmp ( tmpString, "path", 4 ) == 0 )
      {
         /*
          *    found path variable, construct path
          */

         CStr ( tmpString );

         for ( i = 0; tmpString[i] != '='; i++ );

         if ( !tmpString[i] )
         {
            mdlDialog_openInfoBox ( "Invalid path variable in Initialization file" );
            return 0;
         }

         strcpy ( basePath, &tmpString[i+1] );
         if ( basePath[strlen ( basePath ) - 1] != '/' && basePath[strlen ( basePath ) - 1] != '\\' )
            strcat ( basePath, "\\" );
      }
      else
      if ( memcmp ( tmpString, "designfile", 10 ) == 0 )
      {
         double xDegs, yDegs;
         double tmp;

         if ( fileMatch )
            continue;

         /*
          *    found path variable, construct path
          */

         for ( i = 0; tmpString[i] != '='; i++ );

         if ( !tmpString[i] )
         {
            mdlDialog_openInfoBox ( "Invalid path variable in Initialization file" );
            return 0;
         }

         sscanf ( &tmpString[i + 1], "%s %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf",
              dgnNameInFile,
              &ref.latitudeDegrees, &ref.latitudeMinutes, &ref.latitudeSeconds,
              &ref.longitudeDegrees, &ref.longitudeMinutes, &ref.longitudeSeconds, &ref.x1, &ref.y1,
              &ref.latitudeDegrees2, &ref.latitudeMinutes2, &ref.latitudeSeconds2,
              &ref.longitudeDegrees2, &ref.longitudeMinutes2, &ref.longitudeSeconds2, &ref.x2, &ref.y2,
              &ref.XYx1, &ref.XYy1, &ref.x3, &ref.y3,
              &ref.XYx2, &ref.XYy2, &ref.x4, &ref.y4 );
/*
         printf ( "%s %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf\n",
              dgnNameInFile,
              ref.latitudeDegrees, ref.latitudeMinutes, ref.latitudeSeconds,
              ref.longitudeDegrees, ref.longitudeMinutes, ref.longitudeSeconds, ref.x1, ref.y1,
              ref.latitudeDegrees2, ref.latitudeMinutes2, ref.latitudeSeconds2,
              ref.longitudeDegrees2, ref.longitudeMinutes2, ref.longitudeSeconds2, ref.x2, ref.y2,
              ref.XYx1, ref.XYy1, ref.x3, ref.y3,
              ref.XYx2, ref.XYy2, ref.x4, ref.y4 );
*/
         /*
          * work out the scale of the drawing
          */

         ref.XYXScale = fabs (( ref.x3 - ref.x4 ) / ( ref.XYx1 - ref.XYx2 ));
         ref.XYYScale = fabs (( ref.y3 - ref.y4 ) / ( ref.XYy1 - ref.XYy2 ));

         yDegs = ref.latitudeSeconds / 3600;         
         yDegs += ref.latitudeMinutes / 60;         
         yDegs += ref.latitudeDegrees;
   
         tmp = ref.latitudeSeconds2 / 3600;         
         tmp += ref.latitudeMinutes2 / 60;         
         tmp += ref.latitudeDegrees2;

         yDegs -= tmp;

         xDegs = ref.longitudeSeconds / 3600;         
         xDegs += ref.longitudeMinutes / 60;         
         xDegs += ref.longitudeDegrees;
   
         tmp = ref.longitudeSeconds2 / 3600;         
         tmp += ref.longitudeMinutes2 / 60;         
         tmp += ref.longitudeDegrees2;

         xDegs -= tmp;

         ref.latLongXScale = fabs (( ref.x1 - ref.x2 ) / ( xDegs ));
         ref.latLongYScale = fabs (( ref.y1 - ref.y2 ) / ( yDegs ));

         ToLower ( dgnNameInFile );
         if ( strcmp ( dgnNameInFile, dgnName ) == 0 )
            fileMatch = 1;                     

      }
   }

   fclose ( fin );

   if ( !fileMatch )   
   {
      sprintf ( tmpString, "Reference points for %s not found in ini file", dgnName );
      mdlDialog_openInfoBox ( tmpString );
      return 0;
   }

   return 1;
}

int ReadFile ( char * fName, double uor, MdlFunctionP func, _L_HANDLE hand, int firstRecordHeader )
{
   NodeData       data;
   NodeData      *dataP;
   FILE          *fin;
   char           tmpString[MAXSTR];
   int            detailIdx;
   int            dataSection;
   DPoint3d       titleLocatePt;
   int            firstField;

   /*
    * function initialization
    */

   detailIdx = 0;    
   memset (( void * ) &data, 0, sizeof ( NodeData ));
   titleLocatePt.x = DBL_MAX;
   titleLocatePt.y = DBL_MIN;
   if ( firstRecordHeader )
      dataSection = 0;
   else
      dataSection = 1;
   firstField = 1;

   /*
    * open the data file
    */

   if (( fin = fopen ( fName,"r" )) == NULL )
   {
      sprintf ( tmpString, "Error opening file %s", fName );
      mdlDialog_openInfoBox ( tmpString );
      return 0;
   }

   /* 
    * the first line is always a blank line, so skip over it 
    */

   fgets ( tmpString, MAXSTR, fin );
   if ( feof ( fin ))
   {
      mdlDialog_openInfoBox ( ERROR_EOF );
      return 0;
   }

   /*
    * work through the file, a line at a time
    */

   for ( CStr ( fgets ( tmpString, MAXSTR, fin )); !feof ( fin ); CStr ( fgets ( tmpString, MAXSTR, fin )))
   {
      if ( strcmp ( tmpString, SEPERATOR ) == 0 )
      {
         /*
          * end of data for this group, add it to the list
          */
         if ( l_add ( hand, &dataP, sizeof ( NodeData )) != LIST_OK )
         {
            mdlDialog_openInfoBox ( ERROR_NOMEM );
            return 0;
         }

         memcpy (( void * ) dataP, ( void * ) &data, sizeof ( NodeData ));
         memset (( void * ) &data, 0, sizeof ( NodeData ));
         dataSection = 1;
         detailIdx = 0;
         firstField = 1;
      }
      else
      {
         if ( dataSection && firstField )
         {
            /*
             * if this functions fills a detail line, then it returns
             * non zero, otherwise it indicates no line is used
             */
            if ((*func)( &data, tmpString ))
               detailIdx++;
            MapToUSCoord ( &data.locatePt, &data.endPt, &data.c, uor );

            if ( data.locatePt.x < titleLocatePt.x )
               titleLocatePt.x = data.locatePt.x;
            if ( data.locatePt.y > titleLocatePt.y )
               titleLocatePt.y = data.locatePt.y;

            firstField = 0;
         }
         else
         {
            if ( detailIdx < MAX_DETAIL_LINES )
               strcpy ( data.detailLine[detailIdx++], tmpString );
         }
      }
   }

   fclose ( fin );

   dataP = l_head ( hand );
   if ( !dataP )
   {
      /*
       *    No data was read from file, inform user
       */
      mdlDialog_openInfoBox ( ERROR_EOF );
      return 0;
   }


   /*
    *    Set the locate point for the heading
    */
   if ( firstRecordHeader )
   {
      dataP->locatePt.x = titleLocatePt.x;
      dataP->locatePt.y = titleLocatePt.y + display.headingOffset;
      dataP->locatePt.z = 0;
   }

   return 1;
}

