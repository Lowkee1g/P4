%{
  open Ast
%}

%token <Ast.constant> CST
%token EOF END BEGIN NEWLINE
%token PRINT 
%token FOR TO EQUAL
%token <string> STRING
%token <string> IDENT
%start file
%type <Ast.file> file
%%

file:
  | NEWLINE? b = nonempty_list(stmt) NEWLINE? EOF
    { Sblock b }
;

expr:
  | c = CST 
  { Ecst c }
  | id = ident
	{ Eident id }
  | s = STRING 
	{ Ecst (Cstring s) }
  ;

suite:
| s = simple_stmt NEWLINE
    { s }
| NEWLINE BEGIN l = nonempty_list(stmt) END
    { Sblock l }
;


stmt:
  | s = simple_stmt NEWLINE
    { s }
  | FOR id = ident EQUAL expr TO expr s = suite {
	  Sfor(id, $4, $6, s)
	}
  ;


simple_stmt:
  | PRINT e = expr
    { Sprint e }
;


ident:
  id = IDENT { { loc = ($startpos, $endpos); id } }
;
