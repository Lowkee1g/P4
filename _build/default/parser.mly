%{
  open Ast
%}

%token EMPTYSET LTE GTE NEQ UNION INTERSECT PI MOD TIMES DIVIDE

%token <Ast.constant> CST 
%token EOF END BEGIN NEWLINE 
%token IF ELSE ELSEIF
%token PRINT RETURN
%token WHILE FOR TO DOWNTO
%token SWAP WITH LENGTH EXCHANGE
%token GT LT MINUS PLUS EQUAL INFINITY
%token LET BE_A_NEW CROSS MATRIX COLUMNS ROWS ARRAY TABLE
%token LBRACKET RBRACKET DOT DOTDOT COMMA LPAREN RPAREN LBRACE RBRACE
%token RANDOM ERROR LOW HIGH
%token MONOTONICALLY_ASCENDING_ORDER_BY_WEIGHT SORT
%token MONOTONICALLY_DECREASING_ORDER_BY_WEIGHT 
%token NIL                                                          (* NULL   *)
%token INSERT INTO ALL ITEMS IN ROOTLIST                             (* INSERT *)
%token AND OR POWER
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

(* indentation *)
suite:
  | s = simple_stmt NEWLINE
      { s }
  | NEWLINE BEGIN l = nonempty_list(stmt) END
      { Sblock l }
;

math_op:
  | TIMES
  { Bmul }

  | PLUS
  { Badd }
  
  | MINUS
  { Bsub }
  
  | GT
  { Bgt }

  | POWER
  { Bpow }
  
  | LT
  { Blt }

  | MOD
  { Bmod }

  | DIVIDE
  { Bdiv }

  | LTE
  { Blte }

  | GTE
  { Bgte }

  | NEQ
  { Bneq }

  | IN
  { Bin }

  | UNION
  { Bun }

  | INTERSECT
  { Binter }

;



eDotnotation:
  | ident DOT ROWS
  { Erows($1) }

  | ident DOT COLUMNS
  { Ecolumns($1) }

  | ident DOT LENGTH
  { Elength($1) }

  | ident DOT ident
  { Eobject($1, Eident $3) }

  | ident DOT PI
  { EobjectPI($1) }
;


expr:
  | EMPTYSET
  { Memptyset }

  | NIL 
  { Ecst Cnil }

  | INFINITY 
  { Ecst Cinfinity }

  | PI
  { Ecst Cpi }

  | MINUS INFINITY
  { Ecst CminusInfinity }

  | c = CST 
  { Ecst c }

  | dot = eDotnotation 
  { dot }


  | id = ident
	{ Eident id }

  | s = STRING 
	{ Ecst (Cstring s) }

  | expr m = math_op expr 
	{ Ebinop(m, $1, $3) }

  /* | MINUS i = CST
  {
    match i with
    | Cint n -> Ecst (Cint (-n))
    | _ -> failwith "Expected an integer constant" } */
  | LBRACE expr_list RBRACE 
  { Eset($2) }

  | LOW LBRACKET expr RBRACKET
  { Elow($3) }

  | HIGH LBRACKET expr RBRACKET
  { Ehigh($3) }

  | expr EQUAL EQUAL expr 
	{ Ebinop(Beq, $1, $4) }

  /* | expr COMMA expr
  { Ebinop(Bcomma, $1, $3) } */

  | expr AND expr
  { Ebinop(Band, $1, $3) }

  | expr OR expr
  { Ebinop(Bor, $1, $3) }

  | ident LBRACKET expr RBRACKET
	{ Earray($1, $3) }

  | ident LBRACKET expr COMMA expr RBRACKET
  { Etable($1, $3, $5) }

  | ident LBRACKET expr RBRACKET LBRACKET expr RBRACKET
	{ Ematrix($1, $3, $6) }


  | RANDOM LPAREN expr COMMA expr RPAREN
  { Erandom($3, $5) }

  | ident LPAREN l = expr_list RPAREN
  { EfunctionCall($1, l) }


  | expr DOTDOT expr
  { Erange($1, $3) }  
  ;

init_array:
  (* Array *)
  | id = ident LBRACKET e1 = expr RBRACKET
  { 
    Einitarray(id, e1) 
  }
  ;

init_table:
  | id = ident LBRACKET e1 = expr COMMA e2 = expr RBRACKET
  { 
    print_string_red "Einittable -> ";
    Einittable(id, e1, e2);
  }
  ;

simple_stmt:
  (* Init array *)
  | LET array = array_list BE_A_NEW ARRAY {
    print_string_green "SinitArrayList -> ";
    SinitArrayList(array)
  }
  | LET table = table_list BE_A_NEW TABLE {
    print_string_green "SinitTable -> ";
    SinitTableList(table)
  }


  (* Init statments *)
  | LET ident BE_A_NEW expr CROSS expr MATRIX {
    print_string_green "Sinitmatrix -> ";
	  Sinitmatrix($2, $4, $6)
	}

  | PRINT e = expr_list { 
    print_string_green "Sprint -> ";
    Sprint(e) 
  }

  | SWAP expr WITH expr {
    print_string_green "Sswap -> ";
	  Sswap($2, $4)
	}
  | EXCHANGE expr WITH expr {
    print_string_green "Sexchange -> ";
	  Sexchange($2, $4)
	}
  | ident LBRACKET expr RBRACKET LBRACKET expr RBRACKET {
    print_string_green "SassignMatrix -> ";
	  Smatrix($1, $3, $6)
	}
  | expr EQUAL expr {
    print_string_green "Sassign -> ";
    Sassign($1, $3);  (* Capture the result of Sassign *)
  }

  | RETURN expr {
    print_string_green "Sreturn -> ";
	  Sreturn($2)
	}

  | RETURN LPAREN expr RPAREN {
    print_string_green "Sreturn -> ";
    Sreturn($3)
  }

  | ERROR expr {
    print_string_green "Serror -> ";
    Serror($2)
  }
  | SORT e1 = expr INTO MONOTONICALLY_ASCENDING_ORDER_BY_WEIGHT e2 = expr{
    print_string_green "SsortA -> ";
    SsortA(e1, e2)
  }
  | SORT e1 = expr INTO MONOTONICALLY_DECREASING_ORDER_BY_WEIGHT e2 = expr {
    print_string_green "SsortD -> ";
    SsortD(e1, e2)
  }
  | INSERT e1 = expr INTO e2 = expr {
    print_string_green "Sinsert -> ";
    Sinsert(e1, e2)
  }
  | INSERT ALL ITEMS IN e1 = expr INTO e2 = expr {
    print_string_green "SinsertAll -> ";
    SinsertAll(e1, e2)
  }
  | INSERT e1 = expr INTO e2 = expr ROOTLIST {
    print_string_green "SinsertRoot -> ";
    SinsertRoot(e1, e2)
  }
;

stmt:
  | s = simple_stmt NEWLINE
    { s }
  

  // FUNCTION DEFINITIONS
  | id = ident LPAREN l = expr_list RPAREN NEWLINE {
    SfuncCall (id, l)
  }
  | id = ident LPAREN l = expr_list RPAREN s = suite {
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
    {Sifnest($2, s, $4) }
  | IF expr s = suite 
    { Sif($2, s) }
  | ELSEIF expr s = suite stmt
    { Selseifnest($2, s, $4) }
  | ELSEIF expr s = suite 
    { Selseif($2, s) }
  | ELSE s = suite 
    { Selse(s) }

  
  // WHILE LOOPS
  | WHILE expr s = suite {
	  Swhile($2, s)
	}
  
  ;

ident:
  | id = IDENT {
    { loc = ($startpos, $endpos); id } 
  }
;

table_list:
  | e = init_table { [e] }
  | e = init_table AND e1 = init_table { [e; e1] }
  | e = init_table COMMA AND e1 = init_table { [e; e1] } 
  | e = init_table COMMA es = table_list { e :: es }

array_list:
  | e = init_array { [e] }
  | e = init_array AND e1 = init_array { [e; e1] }
  | e = init_array COMMA AND e1 = init_array { [e; e1] } 
  | e = init_array COMMA es = array_list { e :: es }
;

expr_list:
  | id = expr { [id] }  (* Base case: a single identifier *)
  | id = expr MINUS ids = expr_list { id :: ids }  (* Recursive case: an identifier followed by a minus and more identifiers *)
  | id = expr COMMA ids = expr_list { id :: ids }  (* Recursive case: an identifier followed by a comma and more identifiers *)
  | id = expr ids = expr_list { id :: ids }  (* Recursive case: an identifier followed by more identifiers *)
;
