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
COMA 		","
ESPACIOS	({ESPACIO}|{TAB})*

%%
{alfabeto}			{i++; return ALFABET;}
{SIMBOLO}			{i++; yylval.string=strdup(yytext); return SIMBOL; }
{estados}			{return ESTATS;}
{NUMERO}			{yylval.string=strdup(yytext);	return NUMERO; }
{transiciones}		{return TRANSICIONS;}
{inicial}			{return ESTAT_INICIAL;}
{final}				{return ESTATS_FINALS;}
{ABRIR}				{return OBRE;}
{CERRAR}			{return TANCA;}
{COMA}				{return COMA;}
{COMENTARIO}(.)*{LINIA}		{}


{ESPACIOS}			{}
{LINIA}				{i=i+1;}

%%
