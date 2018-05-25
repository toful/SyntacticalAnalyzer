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

    typedef struct Transicio
    {
        char* estat_inicial;
        char* estats_finals;
        char* simbols_alfabet[10];
        int num_transicions;
    }Transicio;
    Transicio transicions[10*10];

    int num_transicions=0;

    char* codi_afd = "int transicio ( int estat, char simbol ) {\n\tint proxim_estat;\n";
    char* codi_afn = "int * transicio ( int estat, char simbol ) {\n\tstatic int proxim_estat[NUM_ESTATS+1], n=0;\n";
    int afd = 1;

    extern FILE* yyin;
    //extern int yylex (void);
    int yylex();
    void yyerror(char * s);

    int simbol_existeix(char * symbol);
    int num_estats_valid(int x);
    int estat_valid(int x);
    int final_existeix(int estat);
    void transicio_valida(char* estat_origen, char* symbol, char* estat_desti);
    int existeixTransicio(char* estat_origen, char* estat_desti);
    void afegeix_trans_AFN(char* estat_origen, char* symbol, char* estat_desti);
    void afegeix_trans_AFD(char* estat_origen, char* symbol, char* estat_desti);
    int simbol_existeix_transicio(char* symbol, int pos);

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

finals: ESTATS_FINALS OBRE num TANCA | ESTATS_FINALS '{' '}' {
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

    int pos = existeixTransicio(estat_origen, estat_desti);

    if (pos != -1)
    {
        if (simbol_existeix_transicio(symbol, pos))
        {
            printf("[AVIS] Transició (%s, %s, %s) repetida.\n", estat_origen, symbol, estat_desti);
        }
        else
        {
            if(afd) printf("[AVIS] S'ha detectat que el AF és no determinista.\n");
            strcpy(transicions[pos].simbols_alfabet[transicions[pos].num_transicions++], symbol);
            afd = 0;
            afegeix_trans_AFD(estat_origen, symbol, estat_desti); 
            afegeix_trans_AFN(estat_origen, symbol, estat_desti); 
        }
    }
    else
    {
        Transicio temp;
        temp.num_transicions = 1;
        temp.estat_inicial = malloc(16*sizeof(char));
        temp.estats_finals = malloc(16*sizeof(char));
        for (int i = 0; i < 10; ++i)
        {
            temp.simbols_alfabet[i] = malloc(16*sizeof(char));
        }
        strcpy(temp.estat_inicial, estat_origen);
        strcpy(temp.simbols_alfabet[0], symbol);
        strcpy(temp.estats_finals, estat_desti);
        transicions[num_transicions++] = temp;
        afegeix_trans_AFD(estat_origen, symbol, estat_desti); 
        afegeix_trans_AFN(estat_origen, symbol, estat_desti); 
    }
}

int simbol_existeix_transicio(char* symbol, int pos){
    for(int i=0 ; i < transicions[pos].num_transicions; i++){
        if( strcmp(transicions[pos].simbols_alfabet[i] , symbol) == 0 )
        {
           return 1;
        }
    }
    return 0;
}

void afegeix_trans_AFD(char* estat_origen, char* symbol, char* estat_desti)
{
    cadena = malloc(strlen(codi_afd)+70);
    sprintf(cadena, "%s\tif ( (estat == %s) && (simbol == \'%s\') ) proxim_estat = %s;\n", codi_afd, estat_origen, symbol, estat_desti);
    codi_afd = cadena;
}

void afegeix_trans_AFN(char* estat_origen, char* symbol, char* estat_desti)
{
    cadena = malloc(strlen(codi_afn)+80);
    sprintf(cadena, "%s\tif ( (estat == %s) && (simbol == \'%s\') ) proxim_estat[n++] = %s;\n", codi_afn, estat_origen, symbol, estat_desti);
    codi_afn = cadena;
}

void acabar_codi()
{
    if (afd)
    {
        cadena = malloc(strlen(codi_afd)+20);
        sprintf(cadena, "%s\treturn proxim_estat;\n}\n", codi_afd);
        codi_afd = cadena;
    }
    else
    {
        cadena = malloc(strlen(codi_afn)+50);
        sprintf(cadena, "%s\treturn proxim_estat;\n}\n", codi_afn);
        codi_afn = cadena;
    }
    
    
}

int existeixTransicio(char* estat_origen, char* estat_desti)
{
    for (int i = 0; i < num_transicions; i++)
    {
        if ((strcmp(transicions[i].estat_inicial, estat_origen) == 0) && (strcmp(transicions[i].estats_finals, estat_desti) == 0))
        {
            return i;
        }
    }
    return -1;
}

void start()
{
    for (int i = 0; i < 10; i++)
    {
        simbols_alfabet[i] = malloc(16*sizeof(char));
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
    acabar_codi();

    printf("El número d'estats és: %i\n", num_estats);
    printf("L'estat inicial és: %i\n", estat_inicial);
    printf("Els estats finals són: %i", estats_finals[0]);
    for (int i=1 ; i < num_estats_finals; i++){
        printf(", %i", estats_finals[i]);
    }

    
    if (afd)
        printf ("\n\n%s", codi_afd);
    else
        printf ("\n\n%s", codi_afn);

    //creem la llibreria
    FILE* llibreria = fopen("af.h", "wa");
    if (afd)
        fprintf(llibreria, "int transicion (int estado, char simbolo);");
    else
        fprintf(llibreria, "int * transicion (int estado, char simbolo);");
    fclose(llibreria);

    FILE* funcio = fopen("af.c", "wa");
    if (afd)
        fprintf(funcio, "%s", codi_afd);
    else
        fprintf(funcio, "%s", codi_afn);
    fclose(funcio);

    return(1);
}


