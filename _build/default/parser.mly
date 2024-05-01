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
%token LET BE_A_NEW CROSS MATRIX COLUMNS ROWS ARRAY
%token LBRACKET RBRACKET DOT DOTDOT COMMA LPAREN RPAREN
%token RANDOM ERROR
%token MONOTONICALLY_ASCENDING_ORDER_BY_WEIGHT SORT
%token MONOTONICALLY_DECREASING_ORDER_BY_WEIGHT 
%token NIL                                                          (* NULL   *)
%token INSERT INTO ALL ITEMS IN ROOTLIST                             (* INSERT *)
%token AND OR
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

  | EMPTYSET
  { Memptyset }
;



eDotnotation:
  | ident DOT ROWS
  { Erows($1) }

  | ident DOT COLUMNS
  { Ecolumns($1) }

  | ident DOT LENGTH
  { Elength($1) }

  | ident DOT expr
  { Eobject($1, $3)}
;


expr:
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

  | expr EQUAL EQUAL expr 
	{ Ebinop(Beq, $1, $4) }

  | expr AND expr
  { Ebinop(Band, $1, $3) }

  | expr OR expr
  { Ebinop(Bor, $1, $3) }

  | ident LBRACKET expr RBRACKET
	{ Earray($1, $3) }

  | ident LBRACKET expr RBRACKET LBRACKET expr RBRACKET
	{ Ematrix($1, $3, $6) }


  | RANDOM LPAREN expr COMMA expr RPAREN
  { Erandom($3, $5) }

  | ident LPAREN l = ident_list RPAREN
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

simple_stmt:
  (* Init array *)
  | LET array = array_list BE_A_NEW ARRAY {
    SinitArrayList(array)
  }
  (* Init statments *)
  | LET ident BE_A_NEW expr CROSS expr MATRIX {
	  Sinitmatrix($2, $4, $6)
	}

  | PRINT e = expr
    { Sprint e }

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
    print_string "Sassign ";
	  Sassign($1, $3);
	}
  | RETURN expr {
	  Sreturn($2)
	}
  | ERROR expr {
    Serror($2)
  }
  | SORT e1 = expr MONOTONICALLY_ASCENDING_ORDER_BY_WEIGHT e2 = expr{
    SsortA(e1, e2)
  }
  | SORT e1 = expr MONOTONICALLY_DECREASING_ORDER_BY_WEIGHT e2 = expr {
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
  | id = ident LPAREN l = ident_list RPAREN s = suite {
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
    { Sifnest($2, s, $4) }
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



array_list:
  | e = init_array { [e] }
  | e = init_array AND e1 = init_array { [e; e1] }
  | e = init_array COMMA AND e1 = init_array { [e; e1] } 
  | e = init_array COMMA es = array_list { e :: es }
;

ident_list:
  | id = ident { [id] }  (* Base case: a single identifier *)
  | id = ident MINUS ids = ident_list { id :: ids }  (* Recursive case: an identifier followed by a minus and more identifiers *)
  | id = ident COMMA ids = ident_list { id :: ids }  (* Recursive case: an identifier followed by a comma and more identifiers *)
;

functionName:
  | id1 = ident
    { { loc = ($startpos, $endpos); id = id1.id } }
  | id1 = ident MINUS ids = functionName
    { { loc = ($startpos, $endpos); id = id1.id ^ "-" ^ ids.id } }
;
