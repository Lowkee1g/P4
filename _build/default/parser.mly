%{
  open Ast
%}

%token <Ast.constant> CST 
%token EOF END BEGIN NEWLINE 
%token IF ELSE ELSEIF
%token PRINT RETURN
%token WHILE FOR TO DOWNTO
%token SWAP WITH LENGTH EXCHANGE
%token GT LT MINUS PLUS EQUAL TIMES INFINITY
%token LET BE_A_NEW CROSS MATRIX COLUMNS ROWS ARRAY
%token LBRACKET RBRACKET DOT DOTDOT COMMA LPAREN RPAREN
%token RANDOM ERROR
%token SORT MONOTONICALLY ASCENDING DECREASING ORDER BY WEIGHT
%token NIL                                                          (* NULL   *)
%token INSERT INTO ALL ITEMS IN ROOTLIST                              (* INSERT *)
%token <string> STRING 
%token <string> IDENT
%token <int> INTEGER 
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

eDotnotation:
  | ident DOT ident
  { Eobject($1, $3) }

  | ident DOT ROWS
  { Erows($1) }

  | ident DOT COLUMNS
  { Ecolumns($1) }

  | ident DOT LENGTH
  { Elength($1) }
;
  

expr:
  | NIL 
  { Ecst Cnil }

  | INFINITY 
  { Ecst Cinfinity }

  | MINUS INFINITY
  { Ecst CminusInfinity }

  | c = CST 
  { Ecst c }

  | dot = eDotnotation 
  { dot }

  | MINUS i = CST
  {
    match i with
    | Cint n -> Ecst (Cint (-n))
    | _ -> failwith "Expected an integer constant" }

  | id = ident
	{ Eident id }

  | s = STRING 
	{ 
    print_string ("#String: " ^ s);
    Ecst (Cstring s) 
  }

  | expr GT expr 
	{ Ebinop(Bgt, $1, $3) }

  | expr LT expr 
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

  | expr DOTDOT expr
  { Erange($1, $3) }  

  | RANDOM LPAREN expr COMMA expr RPAREN
  { Erandom($3, $5) }

  | ident LPAREN l = ident_list RPAREN
  { EfunctionCall($1, l) }

  ;


simple_stmt:
  (* Init array *)
  | LET id = ident LBRACKET e1 = expr RBRACKET BE_A_NEW ARRAY {
    print_string "#Init array\n";
	  Sinitarray(id, e1)
  }
  (* Init statments *)
  | LET ident BE_A_NEW expr CROSS expr MATRIX {
    print_string "#Init matrix \n\n\n\n";
	  Sinitmatrix($2, $4, $6)
	}

  | PRINT s = string_list { 
    Sprint(s) 
    }
  | ident LBRACKET expr RBRACKET {
    Sarray($1, $3)
	}
  | SWAP expr WITH expr {
	  Sswap($2, $4)
	}
  | EXCHANGE expr WITH expr {
	  Sexchange($2, $4)
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
  | ERROR expr {
    Serror($2)
  }
  | SORT e1 = expr MONOTONICALLY ASCENDING ORDER BY WEIGHT e2 = expr{
    SsortA(e1, e2)
  }
  | SORT e1 = expr MONOTONICALLY DECREASING ORDER BY WEIGHT e2 = expr {
    SsortD(e1, e2)
  }
  | INSERT e1 = expr INTO e2 = expr {
    Sinsert(e1, e2)
  }
  | INSERT ALL ITEMS IN e1 = expr INTO e2 = expr {
    SinsertAll(e1, e2)
  }
  | INSERT e1 = expr INTO e2 = expr ROOTLIST {
    SinsertRoot(e1, e2)
  }
;

stmt:
  | s = simple_stmt NEWLINE
    { s }
  

  // FUNCTION DEFINITIONS
  | id = ident_list LPAREN l = ident_list RPAREN s = suite {
    Sfunc (id, l, s)
  }
  
  // FOR LOOPS
  | FOR id = ident EQUAL expr TO expr s = suite {
	  Sfor(id, $4, $6, s)
	}
  | FOR id = ident EQUAL expr DOWNTO expr s = suite {
	  Sford(id, $4, $6, s)
	}

  // IF STATEMENTS
  | IF expr s = suite stmt
    { Sif($2, s, $4) }
  | ELSEIF expr s = suite stmt
    { Selseif($2, s, $4) }
  | ELSE s = suite 
    { Selse(s) }

  
  | WHILE expr s = suite {
    print_string "#While";
	  Swhile($2, s)
	}
  
  ;

ident:
  | id = IDENT {
    print_string ("#Id: " ^ id ^ "\n");
    { loc = ($startpos, $endpos); id } 
  }
;

ident_list:
  | id = ident { [id] }  (* Base case: a single identifier *)
  | id = ident MINUS ids = ident_list { id :: ids }  (* Recursive case: an identifier followed by a minus and more identifiers *)
  | id = ident COMMA ids = ident_list { id :: ids }  (* Recursive case: an identifier followed by a comma and more identifiers *)
;

string_list:
  | s = STRING { [s] }
  | s = STRING sl = string_list { s :: sl }

(* string_expr:
  | s = STRING { [s] }
  | id = ident { [id] }
  | s = STRING elist = string_expr { s :: elist }
  | id = ident elist = string_expr { id :: elist }
; *)