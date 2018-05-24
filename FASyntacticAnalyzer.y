%define parse.error verbose
%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    int num_estats = -1;
    int num_estats_finals = 0;


    int estat_inicial = -1;
    int num_simbols = 0;
    
    char* simbols_alfabet[10];
    int estats_finals[10];
    
    char* cadena;

    extern FILE* yyin;
    //extern int yylex (void);
    int yylex();
    void yyerror(char * s);

    int simbol_existeix(char * symbol);
    int num_estats_valid(int x);
    int estat_valid(int x);
    int final_existeix(int estat);
    void transicio_valida(char* estat_origen, char* symbol, char* estat_desti);
    

%}

%union {
    char *stringut;
};

/* declare tokens */
%token ALFABET
%token OBRE
%token TANCA
%token COMA
%token ESTATS
%token TRANSICIONS
%token ESTAT_INICIAL
%token ESTATS_FINALS
%token COMENTARI
%token OBRE_P
%token TANCA_P
%token SEPARADOR
%token <stringut> SIMBOL
%token <stringut> NUMERO

%%

af: alfabet estats transicions inicial finals
;
alfabet : ALFABET OBRE simbol TANCA | ALFABET OBRE TANCA {
    yyerror("[ERROR]: L'alfabet ha de contindre un o més símbols\n");
};

simbol : simbol COMA simbol | SIMBOL {
    printf("Llegim -%s-\n", $1);
    if( simbol_existeix($1) )
        printf("[AVIS] El símbol %s ya existeix\n", $1);
    else{
    	strcpy( simbols_alfabet[num_simbols], $1 );
    	num_simbols++;
    }
};

estats: ESTATS OBRE NUMERO TANCA {
    if( num_estats_valid( atoi($3) ) ){
        num_estats = atoi($3);
        printf("El número d'estats és: %s\n", $3);
    }
    else{
        yyerror("Error número de estats no vàlids.");
    }
} | OBRE TANCA { yyerror("Error número de estats no vàlids.");
};

transicions: TRANSICIONS OBRE llista_transicions TANCA
;

llista_transicions: transicio | transicio COMA llista_transicions
;

transicio: OBRE_P NUMERO COMA SIMBOL SEPARADOR NUMERO TANCA_P { transicio_valida($2, $4, $6); }
| OBRE_P NUMERO COMA NUMERO SEPARADOR NUMERO TANCA_P { transicio_valida($2, $4, $6); }
;

inicial: ESTAT_INICIAL OBRE NUMERO TANCA {
    if( estat_valid(atoi($3)) )
    {
      	estat_inicial = atoi($3);
        printf("L'estat inicial és: %s\n", $3);
    } 
    else
    {
        yyerror("[ERROR]: estat inicial incorrecte\n");
    }
} | ESTAT_INICIAL OBRE TANCA { 
    yyerror("[ERROR]: Els autòmats finits han de tenir un estat inicial\n");
} | ESTAT_INICIAL OBRE num TANCA {
    yyerror("[ERROR]: no pot haver més d'un estat inicial\n");
}
;

finals: ESTATS_FINALS OBRE num TANCA {
    printf("Els estats finals són:");
    for (int i=0 ; i < num_estats_finals; i++){
	   printf("%i", estats_finals[i]);
    }
    printf("\n");
} | ESTATS_FINALS '{' '}' {
    yyerror("[ERROR]: Els autòmats finits han de tenir algún estat final");
}
;

num: num COMA num | NUMERO {
    if( estat_valid(atoi($1)) )
    {
        if( !final_existeix( atoi($1) ) ){
            estats_finals[num_estats_finals] = atoi($1);
            num_estats_finals ++;
        }
    }
}
;


%%

int num_estats_valid(int x){
    if ( x >= 1 ){
        return 1;
    }
    else{
        return 0;
    }
}

int estat_valid(int x){
    if( x < num_estats )
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

int simbol_existeix(char* symbol){
    for(int i=0 ; i < num_simbols; i++){
        if( strcmp(simbols_alfabet[i] , symbol) == 0 )
        {
	       return 1;
        }
    }
    return 0;
}

int final_existeix(int estat){
    for(int i=0 ; i < num_estats_finals; i++){
        if( estats_finals[i]==estat )
        {
           return 1;
        }
    }
    return 0;
}

void transicio_valida(char* estat_origen, char* symbol, char* estat_desti)
{
    if(!estat_valid(atoi(estat_origen)))
    {
        cadena = malloc(80);
        sprintf(cadena, "[ERROR] El estat %s de la transició(%s, %s; %s) és desconegut\n", estat_origen, estat_origen, symbol, estat_desti);
        yyerror(cadena);
    }
    if(!estat_valid(atoi(estat_desti))) 
    {
        cadena = malloc(80);
        sprintf(cadena, "[ERROR] El estat %s de la transició(%s, %s; %s) és desconegut\n", estat_desti, estat_origen, symbol, estat_desti);
        yyerror(cadena);
    }
    if(!simbol_existeix(symbol))
    {
        cadena = malloc(80);
        sprintf(cadena, "[ERROR] El símbol %s de la transició(%s, %s; %s) és desconegut\n", symbol, estat_origen, symbol, estat_desti);
        yyerror(cadena);
    }
}

void start()
{
    for (int i = 0; i < 10; i++)
    {
        simbols_alfabet[i] = malloc(256*sizeof(char));
    }
}

void yyerror(char * s){
    fprintf(stderr, "Error: %s\n",  s);
    exit(1);
}

int main(int argc, char **argv){
    start();
    if ( argc > 1 )
        yyin = fopen( argv[1] , "r" );
    else
        yyin = stdin;
    yyparse();
    printf ("It's me! Maaariooooooo!!!\n");
    return(1);
}


