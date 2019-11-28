grammar Airports;

r       : EOF | (TEXT* (airport|TEXT)* TEXT*) ;

airport : AIRPORT ;
AIRPORT : ('A'..'Z')('A'..'Z')('A'..'Z') ;
TEXT    : .+? -> skip ;

WS      : [ \t\r\n]+ -> skip; // skip spaces, tabs, newlines
