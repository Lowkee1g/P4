%{
  open Ast
%}

%token <Ast.constant> CST
%token EOF FOR TO EQUAL
%token IF THEN
%token PRINT
%token GT
%token <string> STRING
%token <string> IDENT
%start main
%type <Ast.stmt> main
%%

main:
  | stmt EOF { $1 }
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
  | expr EQUAL EQUAL expr 
    { Ebinop(Beq, $1, $4) }

  ;
  



stmt:
  | FOR id = ident EQUAL expr TO expr {
      Sfor(id, $4, $6)
    }
  | IF expr THEN stmt_list {
      Sif($2, $4)
    }
  | PRINT expr  {
      Sprint($2)
    }
  ;

stmt_list:
  | stmt { [$1] }  (* A list with a single statement *)
  | stmt_list stmt { $1 @ [$2] }  (* Appending a statement to an existing list *)
  ;
  
ident:
  id = IDENT { { loc = ($startpos, $endpos); id } }
;
