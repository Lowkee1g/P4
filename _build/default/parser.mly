%{
  open Ast
%}

%token <Ast.constant> CST
%token EOF  
%token IF
%token PRINT RETURN
%token WHILE FOR TO DOWNTO
%token SWAP WITH LENGTH 
%token GT LT MINUS PLUS EQUAL TIMES
%token LET BE_A_NEW CROSS MATRIX COLUMNS ROWS
%token LBRACKET RBRACKET DOT
%token <string> STRING
%token <string> IDENT
%start main
%type <Ast.stmt list> main
%%

main:
  | l = list(stmt) EOF { l }
  ;



expr:
  | c = CST 
  { Ecst c }
  | id = ident
	{ Eident id }
  | s = STRING 
	{ Ecst (Cstring s) }
  | expr GT expr 
	{ Ebinop(Bgt, $1, $3) }
  |  expr LT expr 
	{ Ebinop(Blt, $1, $3) }
  | expr MINUS expr 
	{ Ebinop(Bsub, $1, $3) }
  | expr PLUS expr 
	{ Ebinop(Badd, $1, $3) }
  | expr TIMES expr 
	{ Ebinop(Bmul, $1, $3) }
  | expr EQUAL EQUAL expr 
	{ Ebinop(Beq, $1, $4) }
  | ident LBRACKET expr RBRACKET
	{ Earray($1, $3) }
  | ident LBRACKET expr RBRACKET LBRACKET expr RBRACKET
	{ Ematrix($1, $3, $6) }
  | expr DOT LENGTH
	{ Elength($1) }
  | expr DOT COLUMNS
	{ Ecolumns($1) }
  | expr DOT ROWS
	{ Erows($1) }
  ;
  

stmt:
  | FOR id = ident EQUAL expr TO expr {
	  Sfor(id, $4, $6)
	}
  | FOR id = ident EQUAL expr DOWNTO expr {
	  Sford(id, $4, $6)
	}
  | IF expr stmt_list {
	  Sif($2, $3)
	}
  | PRINT expr  {
	  Sprint($2)
	}
  | ident LBRACKET expr RBRACKET {
	  Sarray($1, $3)
	}
  | SWAP expr WITH expr {
	  Sswap($2, $4)
	}
  | expr DOT LENGTH {
	  Slength($1)
	}
  | expr DOT COLUMNS {
	  Scolumns($1)
	}
  | expr DOT ROWS {
	  Srows($1)
	}
  | WHILE expr stmt_list {
	  Swhile($2, $3)
	}
  | LET ident BE_A_NEW expr CROSS expr MATRIX {
	  Sinitmatrix($2, $4, $6)
	}
  | ident LBRACKET expr RBRACKET LBRACKET expr RBRACKET {
	  Smatrix($1, $3, $6)
	}
  | expr EQUAL expr {
	  Sassign($1, $3)
	}
  | RETURN expr {
	  Sreturn($2)
	}
  ;

stmt_list:
  | stmt { [$1] }  (* A list with a single statement *)
  | stmt_list stmt { $1 @ [$2] }  (* Appending a statement to an existing list *)
  ;
  
ident:
  id = IDENT { { loc = ($startpos, $endpos); id } }
;
