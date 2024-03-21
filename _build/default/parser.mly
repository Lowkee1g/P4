%{
  open Ast
%}

%token <Ast.constant> CST
%token EOF FOR TO DOWNTO EQUAL 
%token IF
%token PRINT
%token SWAP WITH LENGTH
%token GT LT MINUS 
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
  | expr EQUAL EQUAL expr 
    { Ebinop(Beq, $1, $4) }
  | ident LBRACKET expr RBRACKET
    { Earray($1, $3) }
  | expr DOT LENGTH
    { Elength($1) }
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
  ;

stmt_list:
  | stmt { [$1] }  (* A list with a single statement *)
  | stmt_list stmt { $1 @ [$2] }  (* Appending a statement to an existing list *)
  ;
  
ident:
  id = IDENT { { loc = ($startpos, $endpos); id } }
;
