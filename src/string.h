#ifndef STRING_H
#define STRING_H

#define NULL ((void*)0)
typedef unsigned int size_t;



void _strcpy(char dest[], char source[]) {   // destino <-origem
    int i = 0;
    while (source[i] != '\0' && i < 255) {
        dest[i] = source[i];
        i++;
    }
    dest[i] = '\0';
}


size_t _strlen(const char *s) {
    size_t count = 0;
    for(int i = 0; s[i] != '\0'; i++) {
        count++;
    }
    return count;
}



int _strcmp(char token0[], char command[])
{
    for (int i = 0; token0[i] != '\0' || command[i] != '\0'; i++)
    {
        if (token0[i] != command[i])
            return -1;
    }
    return 0;
}


void _split(char *buffer, char *tokens[2])
{
    int j = 0;
    int k = 0;
    for (int i = 0; buffer[i] != '\0'; i++)
    {
        if (buffer[i] == ' ')
        {
            tokens[j][k] = '\0';
            j++;
            k = 0;
            continue;
        }
        tokens[j][k] = buffer[i];
        k++;
    }
    tokens[j][k] = '\0';
}



#endif