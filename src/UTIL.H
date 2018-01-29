#ifndef _UTIL_H
#define _UTIL_H

void ToLower ( char * );
char * CStr ( char * );
void MidPoint ( Dpoint3d *, Dpoint3d *, Dpoint3d * );
double Bearing ( Dpoint3d *, Dpoint3d * );
void Polar ( Dpoint3d *, double, double, Dpoint3d * );
int SingleCell ( MSElement *, void *, int, ULong, MSElementDescr * );
int DuplicateCells ( MSElement *, void *, int, ULong, MSElementDescr * );
void ClearViewScreen ( void );
void UpdateViewScreen ( void );
int ShowText ( MSElement *, void *, int, ULong, MSElementDescr * );
int HideText ( MSElement *, void *, int, ULong, MSElementDescr * );

#endif
