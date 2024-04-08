
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
  | IF
  | IDENT of (string)
  | GT
  | FOR
  | EQUAL
  | EOF
  | END
  | DOWNTO
  | DOT
  | DEF
  | CST of (Ast.constant)
  | CROSS
  | COMMA
  | COLUMNS
  | COLON
  | BE_A_NEW
  | BEGIN

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val main: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.main)
