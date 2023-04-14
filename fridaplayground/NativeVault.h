//
//  NativeVault.h
//  fridaplayground
//
//  Created by Jeroen Beckers on 06/04/2023.
//

#ifndef NativeVault_h
#define NativeVault_h

#include <stdio.h>

typedef struct Book {
   char* author;
   char* title;
   struct Book *sequel;
} Book;

int isSecure();
int hotPatchMe(void);

Book* getLOTRTrilogy(void);

int validate1(char *pwd);
int validate2(char *pwd);
int validate3(char *pwd);
int validate4(char *pwd);
#endif /* NativeVault_h */

