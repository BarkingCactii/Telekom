#ifndef _COORD_H
#define _COORD_H

#include <mselems.h>

typedef struct coord
{
   /*
    * coordinates or source coordinates if there is a destination coordinate
    */
   double   latitudeDegrees;
   double   latitudeMinutes;
   double   latitudeSeconds;

   double   longitudeDegrees;
   double   longitudeMinutes;
   double   longitudeSeconds;

   double   x;
   double   y;

   /*
    * destination coordinates ( if applicable )
    */
   double   toLatitudeDegrees;
   double   toLatitudeMinutes;
   double   toLatitudeSeconds;

   double   toLongitudeDegrees;
   double   toLongitudeMinutes;
   double   toLongitudeSeconds;
                
   double   tox;
   double   toy;

} Coord;

typedef struct refpoints
{
   double   latitudeDegrees;
   double   latitudeMinutes;
   double   latitudeSeconds;
   double   longitudeDegrees;
   double   longitudeMinutes;
   double   longitudeSeconds;
   double   x1, y1;

   double   latitudeDegrees2;
   double   latitudeMinutes2;
   double   latitudeSeconds2;
   double   longitudeDegrees2;
   double   longitudeMinutes2;
   double   longitudeSeconds2;
   double   x2, y2;

   double   XYx1;
   double   XYy1;
   double   x3, y3;

   double   XYx2;
   double   XYy2;
   double   x4, y4;

   double   latLongXScale;
   double   latLongYScale;
   double   XYXScale;
   double   XYYScale;

} RefPoints;

void MapToUSCoord ( DPoint3d *, DPoint3d *, Coord *, double );

#endif
