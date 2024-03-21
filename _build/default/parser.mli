
(* The type of tokens. *)

type token = 
  | WITH
  | WHILE
  | TO
  | TIMES
  | SWAP
  | STRING of (string)
  | ROWS
  | RETURN
  | RBRACKET
  | PRINT
  | PLUS
  | MINUS
  | MATRIX
  | LT
  | LET
  | LENGTH
  | LBRACKET
  | IF
  | IDENT of (string)
  | GT
  | FOR
  | EQUAL
  | EOF
  | DOWNTO
  | DOT
  | CST of (Ast.constant)
  | CROSS
  | COLUMNS
  | BE_A_NEW

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val main: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.stmt list)
