%option noyywrap
%{
	#include "./FASyntacticAnalyzer.tab.h"
	int i=0;
	int estat = 0;
	int num_estats;
	int simbol = 0;
%}

alfabeto	[Aa][Ll][Ff][Aa][Bb][Ee][Tt][Oo]
estados		[Ee][Ss][Tt][Aa][Dd][Oo][Ss]
transiciones	[Tt][Rr][Aa][Nn][Ss][Ii][Cc][Ii][Oo][Nn][Ee][Ss]
inicial		[Ii][Nn][Ii][Cc][Ii][Aa][Ll]
final		[Ff][Ii][Nn][Aa][Ll][Ee][Ss]
SIMBOLO		[a-zA-Z0-9]
NUMERO		0|[1-9][0-9]*
COMENTARIO	"%"
LINIA		"\n"
TAB			"\t"
ESPACIO		" "
ABRIR		"{"
CERRAR		"}"
ABRIR_P		"("
CERRAR_P	")"
COMA 		","
SEPARADOR	";"
ESPACIOS	({ESPACIO}|{TAB})*

%%
{alfabeto}			{simbol=1;return ALFABET;}
{SIMBOLO}			{ yylval.stringut=strdup(yytext);if(simbol) return SIMBOL; else return NUMERO;}
{estados}			{return ESTATS;}
{NUMERO}			{ yylval.stringut=strdup(yytext);return NUMERO; }
{transiciones}		{return TRANSICIONS;}
{inicial}			{return ESTAT_INICIAL;}
{final}				{return ESTATS_FINALS;}
{ABRIR}				{return OBRE;}
{CERRAR}			{if(simbol) simbol=0; return TANCA;}
{COMA}				{return COMA;}
{ABRIR_P}			{return OBRE_P;}
{CERRAR_P}			{return TANCA_P;}
{SEPARADOR}			{return SEPARADOR;}
{COMENTARIO}(.)*{LINIA}		{}


{ESPACIOS}			{}
{LINIA}				{i=i+1;}

%%
