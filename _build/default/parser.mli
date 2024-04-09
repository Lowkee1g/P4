
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
  | NEWLINE
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
  | END
  | DOWNTO
  | DOT
  | CST of (Ast.constant)
  | CROSS
  | COLUMNS
  | BE_A_NEW
  | BEGIN

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val file: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.stmt)
