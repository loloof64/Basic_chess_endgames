/*
Original grammar from https://github.com/antlr/grammars-v4/tree/master/lua
(Commit 753536777d827ccc0c9b108531ea67375c2039ac)

Adapted to a tiny set, and merged into a single parser file by loloof64

*/

/*

MIT license

Author: Ken Domino, October 2023

Based on previous work of: Kazunori Sakamoto, Alexander Alexeev

*/

// ------------------------------------
// Parser
// ------------------------------------

// $antlr-format alignTrailingComments true, columnLimit 150, minEmptyLines 1, maxEmptyLinesToKeep 1, reflowComments false, useTab false
// $antlr-format allowShortRulesOnASingleLine false, allowShortBlocksOnASingleLine true, alignSemicolons hanging, alignColons hanging


grammar Lua;

start_
    : chunk EOF
    ;

chunk
    : block
    ;

block
    : stat* returnStat
    ;
    
returnStat
	: 'return' exp
	;

stat
    : ';'						# semiColumnExec	
    | assign					# assignExec
    | ifstat					# ifExec				
    ;
    
assign
	: namelist '=' explist
	;
	
ifstat
	:	'if' exp 'then' block 
		('elseif' exp 'then' block)* 
		('else' endExec=block)? 
		'end'
	;

namelist
    : NAME (',' NAME)*
    ;

explist
    : exp (',' exp)*
    ;

exp
    : 'false'												# falseExpr
    | 'true'												# trueExpr
    | number												# numberExpr
    | prefix												# prefixExpr
    | <assoc = right> exp ('^') exp							# exponentExpr
    | op=('not' | '-') exp									# unaryExpr
    | exp op=('*' | '/' | '%' | '//') exp					# mulDivModuloExpr
    | exp op=('+' | '-') exp								# plusMinusExpr
    | exp op=('<' | '>' | '<=' | '>=' | '~=' | '==') exp	# booleanBinaryLogicalExpr
    | exp ('and') exp										# booleanAndExpr
    | exp ('or') exp										# booleanOrExpr
    | exp op=('&' | '|' | '~' | '<<' | '>>') exp			# intBinaryLogicalExpr
    ;
    
prefix
    : NAME							# variablePrefix
    | '(' exp ')'					# parenthesisPrefix
    ;
    
number
    : INT					# integerValue
    ;

// ------------------------------------
// Lexer
// ------------------------------------

// $antlr-format alignTrailingComments true, columnLimit 150, maxEmptyLinesToKeep 1, reflowComments false, useTab false
// $antlr-format allowShortRulesOnASingleLine true, allowShortBlocksOnASingleLine true, minEmptyLines 0, alignSemicolons ownLine
// $antlr-format alignColons trailing, singleLineOverrulesHangingColon true, alignLexerCommands true, alignLabels true, alignTrailers true

// Insert here @header for C++ lexer.

SEMI : ';';
EQ   : '=';
END      : 'end';
IF       : 'if';
THEN     : 'then';
ELSEIF   : 'elseif';
ELSE     : 'else';
COMMA    : ',';
LT       : '<';
GT       : '>';
RETURN   : 'return';
FALSE    : 'false';
TRUE     : 'true';
DOT      : '.';
SQUIG    : '~';
MINUS    : '-';
OP       : '(';
CP       : ')';
NOT      : 'not';
LL       : '<<';
GG       : '>>';
AMP      : '&';
SS       : '//';
PER      : '%';
LE       : '<=';
GE       : '>=';
AND      : 'and';
OR       : 'or';
PLUS     : '+';
STAR     : '*';
EE       : '==';
PIPE     : '|';	
CARET    : '^';
SLASH    : '/';
SQEQ     : '~=';

NAME: [a-zA-Z_][a-zA-Z_0-9]*;

INT: Digit+;

fragment EscapeSequence:
    '\\' '\r'? '\n'
;

fragment Digit: [0-9];

COMMENT: '--' { this.HandleComment(); } -> channel(HIDDEN);

WS: [ \t\u000C\r]+ -> channel(HIDDEN);

NL: [\n] -> channel(2);
