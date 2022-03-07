/** Grammars always start with a grammar header. This grammar is called
*  ArrayInit and must match the filename: ArrayInit.g4
*/
grammar ArrayInit;

/** A rule called top_level that matches comma-separated values between {...}. */
top_level  :  '{' value (',' value)* '}' ;  // must match at least one value

/** A value can be either a nested array/struct or a simple integer (INT) */
value	:	top_level
			|	INT
			;

// parser rules start with lowercase letters, lexer rules with uppercase
INT	:		[0-9]+;             // Define token INT as one or more digits
WS	:		[ \t\r\n]+ -> skip; // Define whitespace rule, toss it out
