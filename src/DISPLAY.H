#ifndef _DISPLAY_H
#define _DISPLAY_H

void SetDefaultDisplaySettings ( void );
void Hook_Display ( DialogMessage * );
void HookItem_DisplayFont ( DialogItemMessage * );
void HookItem_DisplayApply ( DialogItemMessage * );
void HookItem_DisplayHeight ( DialogItemMessage * );

extern DisplaySettings display;

#endif

