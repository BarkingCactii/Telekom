/*----------------------------------------------------------------------*/
/* Program : sort.mc                                                    */
/* Description : Sort routines to check for overlapping nodes           */
/* Coded by : Jeff Hill ( jeff@reoforce.com.au )                        */
/*            PO Box 871 Beenleigh QLD 4207 Australia                   */
/*            Phone: 61-7-55465006                                      */
/*----------------------------------------------------------------------*/

#include <msmisc.fdf>
#include "globals.h"

int SortCompare ( NodeData ** sip1, NodeData ** sip2 )
{
   NodeData * si1, * si2;

   si1 = *sip1;
   si2 = *sip2;

   if ( si1->locatePt.x < si2->locatePt.x )
      return -1;
   else
   if ( si1->locatePt.x > si2->locatePt.x )
      return 1;
   
   if ( si1->locatePt.y < si2->locatePt.y )
      return -1;
   else
   if ( si1->locatePt.y > si2->locatePt.y )
      return 1;

   return 0;
}

static NodeData * nodeList[MAX_NODES];

void SetDuplicates ( _L_HANDLE hand )
{
   int      numNodes;
   NodeData * dataP;
   NodeData * nextDataP;
   int      i;
   int      j;
   int      numDuplicates;

   numNodes = l_count ( hand );
   if ( !numNodes )
      return;

   for ( i = 0, dataP = l_head ( hand ); dataP; dataP = l_next ( hand ), i++ )
   {
      if ( i >= MAX_NODES - 1 )
      {
         mdlDialog_openInfoBox ( ERROR_NOMORENODES );
         return;
      }
      
      nodeList[i] = dataP;
   }

   mdlUtil_quickSort (( char * ) nodeList, numNodes, sizeof ( NodeData * ), SortCompare ); 

   numDuplicates = 0;
   for ( i = 0; i < numNodes - 1; i++ )
   {
      dataP = nodeList[i];
      nextDataP = nodeList[i+1];

      if ( dataP->locatePt.x == nextDataP->locatePt.x &&
           dataP->locatePt.y == nextDataP->locatePt.y )
      {
            if ( !dataP->dupNum )
               dataP->dupNum = 1;

            dataP->duplicates = 1;
            nextDataP->duplicates = 1;

            nextDataP->dupNum = dataP->dupNum + 1;
            numDuplicates = nextDataP->dupNum;
      }
      else
      {
         if ( numDuplicates )
            numDuplicates = 0;
      }
   }
}
