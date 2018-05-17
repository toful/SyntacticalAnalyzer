%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    int num_estats=3;
    int estat_inicial;

%}

/* declare tokens */
%token ALFABET
%token ESTATS
%token TRANSICIONS
%token ESTAT_INICIAL
%token ESTATS_FINALS
%token COMENTARI
%token TRANSICIO
%token SIMBOL
%token COMA
%token OBRE
%token TANCA
%token NUMERO

%%

estat_inicial:  ESTAT_INICIAL OBRE NUMERO TANCA {
    if( /*estat_valid(atoi($3))*/1 )
    {
        //estat_inicial = atoi($3);
        printf("El estat inicial és: %s\n", $3);
    } 
    else
    {
        printf("ERROR: estat inicial incorrecte");
    }
}
;

num: num COMA num | NUMERO {
    if( /*estat_valid(atoi($1))*/1 )
    {
        printf("OK!");
    }
}
;


%%

int estat_valid(int x){
    if( x<num_estats){
        return 1;
    }
    else{
        return 0;
    }
}

main(int argc, char **argv){
    yyparse();
    printf ("It's me! Maaariooooooo!!!");
}

yyerror(char *s){
    fprintf(stderr, "error: %s\n", s);
}

