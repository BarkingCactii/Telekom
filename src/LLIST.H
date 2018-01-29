/*---------------------------------------------------------------------------*/
/* Program : llist.h                                                         */
/* Description : Basic Generic doubly linked list header definition          */
/* Coded by : Jeff Hill ( jeff@reoforce.com.au )                             */
/*---------------------------------------------------------------------------*/
#ifndef LLIST_H
#define LLIST_H

#ifndef TRUE
#define TRUE      1
#endif

#ifndef FALSE
#define FALSE     0
#endif

typedef int _L_HANDLE;

#define LIST_OK	   1                 /* return codes */
#define LIST_ERR	   0
#define LIST_EMPTY	0
#define LIST_FULL    -1
#define INVALID_HANDLE  -1

#define MAX_LISTS	   10                 /* maximum lists at any time */

_L_HANDLE l_gethandle ( void );
int l_add(_L_HANDLE, void **, int);
int l_insert(_L_HANDLE, void **, int, void *);
int l_delete(_L_HANDLE, void *);
void *l_head(_L_HANDLE);
void *l_last(_L_HANDLE);
void *l_next(_L_HANDLE);
void *l_prev(_L_HANDLE);
void *l_current(_L_HANDLE);
void l_make_current(_L_HANDLE, void *);
void *l_nth(_L_HANDLE, int);
int l_swap(_L_HANDLE, int, int);
void l_free(_L_HANDLE);
int l_count(_L_HANDLE);
int l_elemnum(_L_HANDLE);
int l_push(_L_HANDLE, void *);
int l_pop(_L_HANDLE, void **);
int l_empty(_L_HANDLE);
int l_sort ( _L_HANDLE );
int l_walk(_L_HANDLE);
int l_taken();

#endif

