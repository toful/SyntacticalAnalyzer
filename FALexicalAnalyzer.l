%option noyywrap
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
SIMBOLO		[a-zA-Z0-9]
NUMERO		0|[1-9][0-9]*
COMENTARIO	"%"
LINIA		"\n"
TAB			"\t"
ESPACIO		" "
ESPACIOS	({ESPACIO}|{TAB})*

%%
{alfabeto}			{return ALFABET;}
{SIMBOLO}			{yylval.string = strdup(yytext);	return SIMBOL; }
{estados}			{return ESTATS;}
{NUMERO}			{strcpy( yylval.string , yytext );	return NUMERO; }
{transiciones}		{return TRANSICIONS;}
{inicial}			{return ESTAT_INICIAL;}
{final}				{return ESTATS_FINALS;}
{COMENTARIO}(.)*{LINIA}		{return COMENTARI;}


{ESPACIOS}|LINIA		{}

%%
