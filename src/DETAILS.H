#ifndef _DETAILS_H
#define _DETAILS_H

extern NodeData *nodeDetails;
extern DialogBox *detailsDB;

void DataButton_SelectEntity ( Dpoint3d *, int );
void Hook_details ( DialogMessage * );
void HookItem_DetailsPrevious ( DialogItemMessage * );
void HookItem_DetailsNext ( DialogItemMessage * );
void HookItem_DetailsShow ( DialogItemMessage * );

#endif
