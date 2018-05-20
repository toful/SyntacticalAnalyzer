%{
	#include "./FASyntacticAnalyzer.tab.h"
	int i;
	int estat = 0;
	int num_estats;
	int simbol = 0;
%}

alfabeto	[Aa][Ll][Ff][Aa][Bb][Ee][Tt][Oo]
estados		[Ee][Ss][Tt][Aa][Dd][Oo][Ss]
transiciones	[Tt][Rr][Aa][Nn][Ss][Ii][Cc][Ii][Oo][Nn][Ee][Ss]
inicial		[Ii][Nn][Ii][Cc][Ii][Aa][Ll]
final		[Ff][Ii][Nn][Aa][Ll][Ee][Ss]
ABRIR		"{"
CERRAR		"}"
SIMBOLO		[a-zA-Z0-9]
NUMERO		0|[1-9][0-9]*
COMENTARIO	"%"
LINIA		"\n"
TAB			"\t"
ESPACIO		" "
ESPACIOS	({ESPACIO}|{TAB})*
COMA		","
TRANSICION	"("{ESPACIOS}{NUMERO}{ESPACIOS}","{ESPACIOS}{SIMBOLO}{ESPACIOS}";"{ESPACIOS}{NUMERO}{ESPACIOS}")"

%%
{alfabeto}			{printf("ALFABET"); simbol = 1;}
{estados}			{printf("ESTATS"); estat = 1; simbol = 0;}
{transiciones}			{printf("TRANSICIONS"); simbol = 0;}
{inicial}			{printf("ESTAT_INICIAL"); simbol = 0;}
{final}				{printf("ESTATS_FINALS"); simbol = 0;}
{COMENTARIO}(.)*{LINIA}		{printf("COMENTARI");}
{TRANSICION}			{printf("TRANSICIO"); simbol = 0;}
{NUMERO}			{
	if(simbol == 0){
		printf("NUMERO");
		if( estat == 1 )
		{ 
			for(i=0; i<yyleng; i++) num_estats=num_estats*10+(yytext[i]-48); 
			estat=0;
		}
	}
	else{printf("SIMBOL");}
}
{SIMBOLO}				{printf("SIMBOL");}
{COMA}					{printf("COMA");}
{ABRIR}					{printf("OBRE");}
{CERRAR}				{printf("TANCA");}
{ESPACIOS}|LINIA		{}

%%
