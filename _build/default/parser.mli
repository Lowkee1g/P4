
(* The type of tokens. *)

type token = 
  | WITH
  | WHILE
  | TO
  | TIMES
  | SWAP
  | STRING of (string)
  | RPAREN
  | ROWS
  | RETURN
  | RBRACKET
  | RANDOM
  | PRINT
  | PLUS
  | NEWLINE
  | MINUS
  | MATRIX
  | LT
  | LPAREN
  | LET
  | LENGTH
  | LBRACKET
  | INFINITY
  | IF
  | IDENT of (string)
  | GT
  | FOR
  | EXCHANGE
  | EQUAL
  | EOF
  | END
  | ELSEIF
  | ELSE
  | DOWNTO
  | DOT
  | CST of (Ast.constant)
  | CROSS
  | COMMA
  | COLUMNS
  | BE_A_NEW
  | BEGIN

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val file: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.stmt)
