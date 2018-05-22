%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    int num_estats=3;
    int num_estats_finals=0;
    int estat_inicial;
    int num_simbols=0;
    char* simbols_alfabet[5];
    int estats_finals[5];
    extern FILE* yyin;

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

simbol: simbol COMA simbol | SIMBOL {
    if(simbol_existeix($1))
        printf("[AVIS] El símbol %c ya existeix\n", $1);
    else{
	simbols_alfabet[num_simbols]=$1;
	num_simbols++;
    }
};

alfabet: ALFABET OBRE simbol TANCA | ALFABET OBRE TANCA {
	yyerror("[ERROR]: L'alfabet ha de contindre un o més símbols\n");
};

estatInicial:  ESTAT_INICIAL OBRE NUMERO TANCA {
    if( estat_valid(atoi($3)) )
    {
      	estat_inicial = atoi($3);
        printf("El estat inicial és: %s\n", $3);
    } 
    else
    {
        yyerror("[ERROR]: estat inicial incorrecte\n");
    }
} | ESTAT_INICIAL OBRE TANCA { 
    yyperror("[ERROR]: Els autòmats finits han de tenir un estat inicial\n");
}
;

estatsFinals: ESTATS_FINALS OBRE num TANCA {
    printf("Els estats finals són:");
    for(int i=0 ; i < num_estats_finals)
	printf("%i", llista_finals);
} | ESTATS_FINALS OBRE TANCA {
    yyerror("[ERROR]: Els autòmats finits han de tenir algún estat final");
};

num: num COMA num | NUMERO {
    if( estat_valid(atoi($1))1 )
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

int simbol_existeix(char *simbol){
    for(int i=0 ; i < num_simbols; i++){
        if( strcmp(simbols_alfabet[i],simbol) == 0 ){
	    return 1;
	}
    }
    return 0;
}



yyerror(char *s){
    fprintf(stderr, "error: %s\n", s);
}

main(int argc, char **argv){
    yyin=fopen(argv[1],"r");
    yyparse();
    printf ("It's me! Maaariooooooo!!!");
	printf("Estat inicial: %i", estat_inicial);
}


