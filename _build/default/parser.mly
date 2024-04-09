%{
  open Ast
%}

%token <Ast.constant> CST
%token EOF END BEGIN NEWLINE 
%token IF ELSE ELSEIF
%token PRINT RETURN
%token WHILE FOR TO DOWNTO
%token SWAP WITH LENGTH 
%token GT LT MINUS PLUS EQUAL TIMES
%token LET BE_A_NEW CROSS MATRIX COLUMNS ROWS
%token LBRACKET RBRACKET DOT
%token <string> STRING
%token <string> IDENT
%start file
%type <Ast.file> file
%%

file:
  | NEWLINE? b = nonempty_list(stmt) NEWLINE? EOF
    { Sblock b }
;

  suite:
| s = simple_stmt NEWLINE
    { s }
| NEWLINE BEGIN l = nonempty_list(stmt) END
    { Sblock l }
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


simple_stmt:
  | PRINT e = expr
    { Sprint e }
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


stmt:
  | s = simple_stmt NEWLINE
    { s }
  
  // FOR LOOPS
  | FOR id = ident EQUAL expr TO expr s = suite {
	  Sfor(id, $4, $6, s)
	}
  | FOR id = ident EQUAL expr DOWNTO expr s = suite {
	  Sford(id, $4, $6, s)
	}

  // IF STATEMENTS
  | IF expr s = suite 
    { Sif($2, s) }
  | IF expr s1 = suite ELSE s2 = suite 
    { Sifelse($2, s1, s2) }
  | IF expr s1 = suite ELSEIF expr s2 = suite 
    { Sifelseif($2, s1, $5, s2) }
  
  | WHILE expr s = suite {
	  Swhile($2, s)
	}
  | LET ident BE_A_NEW expr CROSS expr MATRIX {
	  Sinitmatrix($2, $4, $6)
	}
  ;



ident:
  id = IDENT { { loc = ($startpos, $endpos); id } }
;
