#ifndef MALLOC_H
#define MALLOC_H

#include "string.h"



#define HEAP_SIZE 8192
static unsigned char static_heap[HEAP_SIZE];
static size_t static_heap_top = 0;



static void *my_malloc(size_t n)
{
    /* alinhar a 4 bytes */
    static_heap_top = (static_heap_top + 3) & ~3;
    if (static_heap_top + n > HEAP_SIZE)
    {
        /* sem memória suficiente -> comportamento simples: retornar NULL */
        return NULL;
    }
    void *p = &static_heap[static_heap_top];
    static_heap_top += n;
    return p;
}


#endif
