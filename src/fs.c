
#include <stdbool.h>
#include "string.h"
#include "malloc.h"
#define BUFFER_MAX 100
#define TOKEN_MAX 50
#define Number_Of_Files 32

extern void putString(char buffer[]);
extern void getString(char buffer[], int);
char buffer[BUFFER_MAX];
char token0[TOKEN_MAX];
char token1[TOKEN_MAX];




typedef struct File {
    bool use;
    char* name;
    int content[12];

}File;

File files[32];

char *tokens[2] = {token0, token1};


typedef struct Dir
{
    char *name;
    unsigned int files;
    struct Dir *children[12];
    struct Dir *parent;
} Dir;


void print_path(Dir *pwd)
{
        
    char *stack[20];
    int top = 0;

    Dir *aux = pwd;

    // sobe até a raiz empilhando
    while (aux != NULL)
    {
        stack[top++] = aux->name;
        aux = aux->parent;
    }

    // imprime do root até o atual
    for (int i = top - 1; i >= 0; i--)
    {
        if ((i == top - 1) | (i == 0)) {
            _strcpy(buffer, stack[i]);
            putString(buffer);
        }
        else {
            _strcpy(buffer, stack[i]);
            putString(buffer);
            putString("/");
        }
    }

    putString("$ ");
}







void clear()
{
    putString("\033[H\033[2J\033[3J\n\r");
}

Dir *cd(Dir *pwd, char token1[])
{
    if (_strcmp(token1, "..") != -1)
    {
        return pwd->parent != NULL ? pwd->parent : pwd;
    }
    for (int i = 0; pwd->children[i] != NULL; i++)
    {
        if ((_strcmp(pwd->children[i]->name, token1) != -1))
            return pwd->children[i];
    }
    return pwd;
}

int mkdir(Dir *pwd, char token1[])
{

    for (int i = 0; i < 12; i++)
    {
        if (pwd->children[i] == NULL)
        {
            /* aloca Dir a partir do heap estático */
            pwd->children[i] = (Dir *)my_malloc(sizeof(Dir));
            if (pwd->children[i] == NULL)
                return -1; /* sem memória */

            /* aloca espaço para o name */
            size_t len = _strlen(token1) + 1;
            pwd->children[i]->name = (char *)my_malloc(len);
            if (pwd->children[i]->name == NULL)
                return -1; /* sem memória */

            _strcpy(pwd->children[i]->name, token1);
            pwd->children[i]->files = 0; //FOI ADICIONADA ESSA LINHA 
            pwd->children[i]->parent = pwd;

            for (int j = 0; j < 12; j++)  
                pwd->children[i]->children[j] = NULL;


            return 0;
        }
    }
    return -1;
}

void ls(Dir *pwd)
{
    for (int i = 0; i < 12; i++)
    {
        if (pwd->children[i] != NULL) {
            _strcpy(buffer, pwd->children[i]->name);
            putString(buffer);
            putString(" ");
        }
    }


    for (int i = 0; i < Number_Of_Files; i++) {
        if(((pwd->files >> i) & 1) && files[i].use) {
            _strcpy(buffer, files[i].name);
            putString(buffer);
            putString(" ");
        }
    }
    putString("\n\r");
}



void touch(Dir *pwd, char token1[]) {

    for(int i = 0; i < Number_Of_Files; i++) {
        if(files[i].use == false) {
          
            files[i].use = true;
            
            
            size_t len = _strlen(token1) + 1;
            files[i].name = (char *)my_malloc(len);
            if (files[i].name != NULL) {
                _strcpy(files[i].name, token1);
            }
            
            
            pwd->files |= (1 << i);
            
            return; 
        }
    }
    
    // Se chegou aqui, não há arquivos livres
    putString("Erro: numero maximo de arquivos atingido\n\r");
}


void initialize_filesystem(Dir* dir) {
    mkdir(dir, "dev");
    dir = cd(dir, "dev");
    mkdir(dir, "gpio");
    mkdir(dir, "uart");
    mkdir(dir, "rtc");
    dir = cd(dir, "gpio");
    touch(dir, "gpio1[21]");
    touch(dir, "gpio1[22]");
    touch(dir, "gpio1[23]");
    touch(dir, "gpio1[24]");
    dir = cd(dir, "..");
    dir = cd(dir, "..");
}

int shell()
{

    Dir *dir = (Dir *)my_malloc(sizeof(Dir));
    
    for (int i = 0; i < Number_Of_Files; i++) {
        files[i].use = false;
        files[i].name = NULL;
    }


    /* inicialização do root */
    dir->name = (char *)my_malloc(2); /* "/" + '\0' */
    if (dir->name == NULL)
        return 1;
    _strcpy(dir->name, "/");
    
    clear();  

    dir->parent = NULL;
    dir->files = 0x0;

    for (int i = 0; i < 12; i++)
        dir->children[i] = NULL;

    initialize_filesystem(dir);
    while (1)
    {
        int max = BUFFER_MAX;
        print_path(dir);
        
        getString(buffer, max);
        putString("\n\r");
        _split(buffer, tokens);

        if (_strcmp(token0, "mkdir") != -1)
            mkdir(dir, token1);

        else if (_strcmp(token0, "ls") != -1)
            ls(dir);
        else if (_strcmp(token0, "clear") != -1)
            clear();
        else if (_strcmp(token0, "cd") != -1)
        {
            dir = cd(dir, token1);
        }
        else if (_strcmp(token0, "touch") != -1)
        {
            touch(dir, token1);
        }
    }

    return 1;
}
