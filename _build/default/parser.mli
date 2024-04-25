
(* The type of tokens. *)

type token = 
  | WITH
  | WHILE
  | UNION
  | TO
  | TIMES
  | SWAP
  | STRING of (string)
  | SORT
  | RPAREN
  | ROWS
  | ROOTLIST
  | RETURN
  | RBRACKET
  | RANDOM
  | PRINT
  | PLUS
  | PI
  | NIL
  | NEWLINE
  | NEQ
  | MONOTONICALLY_DECREASING_ORDER_BY_WEIGHT
  | MONOTONICALLY_ASCENDING_ORDER_BY_WEIGHT
  | MOD
  | MINUS
  | MATRIX
  | LTE
  | LT
  | LPAREN
  | LET
  | LENGTH
  | LBRACKET
  | ITEMS
  | INTO
  | INTERSECT
  | INTEGER of (int)
  | INSERT
  | INFINITY
  | IN
  | IF
  | IDENT of (string)
  | GTE
  | GT
  | FOR
  | EXCHANGE
  | ERROR
  | EQUAL
  | EOF
  | END
  | EMPTYSET
  | ELSEIF
  | ELSE
  | DOWNTO
  | DOTDOT
  | DOT
  | DIVIDE
  | CST of (Ast.constant)
  | CROSS
  | COMMA
  | COLUMNS
  | BE_A_NEW
  | BEGIN
  | ARRAY
  | ALL

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val file: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.stmt)
