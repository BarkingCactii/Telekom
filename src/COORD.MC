/*----------------------------------------------------------------------*/
/* Program : coord.mc                                                   */
/* Description : Coordinate functions                                   */
/* Coded by : Jeff Hill ( jeff@reoforce.com.au )                        */
/*            PO Box 871 Beenleigh QLD 4207 Australia                   */
/*            Phone: 61-7-55465006                                      */
/*----------------------------------------------------------------------*/

#include <stdlib/stdio.h>
#include <stdlib/stdlib.h>
#include <stdlib/float.h>
#include <stdlib/math.h>
#include "globals.h"

static void XYToXY ( double x, double y, Dpoint3d * point )
{
   /*
    * determine length of line from reference point 1
    */

   point->x = ref.x3 + ( x - ref.XYx1 ) * ref.XYXScale;
   point->y = ref.y3 + ( y - ref.XYy1 ) * ref.XYYScale;

   point->x *= uor;
   point->y *= uor;

/*   printf ( "XY [%lf][%lf]\n", point->x, point->y ); */
}

static void LatLongToXY ( double latDeg, double latMin, double latSec,
                          double lngDeg, double lngMin, double lngSec,
                          Dpoint3d * point )
{
   double   x, y;
   double   x1, y1;

   /*
    * convert to latlong to point
    */

   y = latSec / 3600;
   y += latMin / 60;
   y += latDeg;

   x = lngSec / 3600;
   x += lngMin / 60;
   x += lngDeg;

   if ( x == 0 && y == 0 )
      return;

   y1 = ref.latitudeSeconds / 3600;         
   y1 += ref.latitudeMinutes / 60;         
   y1 += ref.latitudeDegrees;

   x1 = ref.longitudeSeconds / 3600;         
   x1 += ref.longitudeMinutes / 60;         
   x1 += ref.longitudeDegrees;

   point->x = ref.x1 + (( x - x1 ) * ref.latLongXScale );
   point->y = ref.y1 + (( y - y1 ) * ref.latLongYScale );

   point->x *= uor;
   point->y *= uor;

/*   printf ( "LL [%lf][%lf]\n", point->x, point->y ); */
}

void MapToUSCoord ( DPoint3d * point, DPoint3d * point2, Coord * c, double uor )
{
   /*
    * determinate what source coordinates are used
    */
   if ( c->x == 0 && c->y == 0 )
   {
      /*
       *  use map coordinates
       */

      LatLongToXY ( c->latitudeDegrees, c->latitudeMinutes, c->latitudeSeconds,
                    c->longitudeDegrees, c->longitudeMinutes, c->longitudeSeconds,
                    point );

   }
   else
   {
      /* 
       * use kilometre offset values
       */

      XYToXY ( c->x, c->y, point );
   }

   /*
    * determinate what destination coordinates are used
    */

   if ( point2 == NULL )
      return;

   if ( c->tox == 0 && c->toy == 0 )
   {
      /*
       *  use map coordinates
       */

      LatLongToXY ( c->toLatitudeDegrees, c->toLatitudeMinutes, c->toLatitudeSeconds,
                    c->toLongitudeDegrees, c->toLongitudeMinutes, c->toLongitudeSeconds,
                    point2 );

   }
   else
   {
      /* 
       * use kilometre offset values
       */

      XYToXY ( c->tox, c->toy, point2 );
   }
}

