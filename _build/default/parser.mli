
(* The type of tokens. *)

type token = 
  | WITH
  | WHILE
  | UNION
  | TURNSTILE
  | TOP
  | TO
  | TIMES
  | SWAP
  | SUPSETEQLEFT
  | SUBSETRIGHT
  | SUBSETLEFT
  | SUBSETEQRIGHT
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
  | NOTSUPSETEQRIGHT
  | NOTSUBSETEQLEFT
  | NOTINRIGHT
  | NOTINLEFT
  | NIL
  | NEWLINE
  | NEQ
  | MONOTONICALLY_DECREASING_ORDER_BY_WEIGHT
  | MONOTONICALLY_ASCENDING_ORDER_BY_WEIGHT
  | MINUS
  | MATRIX
  | LT
  | LPAREN
  | LET
  | LEQ
  | LENGTH
  | LBRACKET
  | ITEMS
  | INTO
  | INTERSECTION
  | INTEGER of (int)
  | INSERT
  | INRIGHT
  | INLEFT
  | INFINITY
  | IN
  | IF
  | IDENT of (string)
  | GT
  | GEQ
  | FORALL
  | FOR
  | EXISTS
  | EXCHANGE
  | ERROR
  | EQUAL
  | EOF
  | END
  | EMPTYSET
  | ELSEIF
  | ELSE
  | DOWNTO
  | DOTPRODUCT
  | DOTDOT
  | DOT
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
