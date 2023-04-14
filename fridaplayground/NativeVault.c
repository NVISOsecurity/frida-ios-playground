//
//  NativeVault.c
//  fridaplayground
//
//  Created by Jeroen Beckers on 06/04/2023.
//

#include "NativeVault.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char *strrev(char *str)
{
      char *p1, *p2;

      if (! str || ! *str)
            return str;
      for (p1 = str, p2 = str + strlen(str) - 1; p2 > p1; ++p1, --p2)
      {
            *p1 ^= *p2;
            *p2 ^= *p1;
            *p1 ^= *p2;
      }
      return str;
}

Book* getLOTRTrilogy(void){
    char book1title[] = "The Fellowship of the Ring";
    char book2title[] = "The Two Towers";
    char book3title[] = "The Return of the King";
    char bookauthor[] = "J. R. R. Tolkien";
    Book *book1 = malloc(sizeof(struct Book));
    Book *book2 = malloc(sizeof(struct Book));
    Book *book3 = malloc(sizeof(struct Book));
    
    book1->title = strdup(book1title);
    book2->title = strdup(book2title);
    book3->title = strdup(book3title);
    
    book1->author = book2->author = book3->author = strdup(bookauthor);
    
    book1->sequel = book2;
    book2->sequel = book3;
    
    return book1;
}

static int unexported()
{
    return 0;
}

int isSecure()
{
    return unexported();
}

int hotPatchMe(){
    int a = 0x13371337;
    if(a == 0x42424242){
        return 1;
    }
    return 0;
}

int validate1(char *pwd){
    char sol[5] = "Gsjeb";
    if(strlen(pwd) == 5)
    {
        int i;
        for(i = 0; i<5; i++){
            if(pwd[i] + 1 != sol[i]){
                return 1000;
            }
        }
    }
    return 1;
}
int validate2(char *pwd){
    char* a = "nuF";
    int i = 0;
    for(i = 0; i<3; i++)
    {
        if(pwd[i] != a[2-i])
        {
            return 1000;
        }
    }
    return 1;
}
int validate3(char *pwd){
    char* a = "Frida";
    char b[] = {0x16, 0x00, 0x06, 0x02, 0x08, 0x32};
    int i = 0;
    for(i = 0; i<strlen(b); i++)
    {
        if((pwd[i] ^ a[i%5]) != b[i]){
            return 1000;
        }
    }
    return 1;
}

