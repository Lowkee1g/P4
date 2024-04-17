
(* The type of tokens. *)

type token = 
  | WITH
  | WHILE
  | WEIGHT
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
  | ORDER
  | NIL
  | NEWLINE
  | MONOTONICALLY
  | MINUS
  | MATRIX
  | LT
  | LPAREN
  | LET
  | LENGTH
  | LBRACKET
  | ITEMS
  | INTO
  | INTEGER of (int)
  | INSERT
  | INFINITY
  | IN
  | IF
  | IDENT of (string)
  | GT
  | FOR
  | EXCHANGE
  | ERROR
  | EQUAL
  | EOF
  | END
  | ELSEIF
  | ELSE
  | DOWNTO
  | DOTDOT
  | DOT
  | DECREASING
  | CST of (Ast.constant)
  | CROSS
  | COMMA
  | COLUMNS
  | BY
  | BE_A_NEW
  | BEGIN
  | ASCENDING
  | ARRAY
  | ALL

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val file: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.stmt)
