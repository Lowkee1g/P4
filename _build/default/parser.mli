
(* The type of tokens. *)

type token = 
  | WITH
  | TO
  | SWAP
  | STRING of (string)
  | RBRACKET
  | PRINT
  | MINUS
  | LT
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

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val main: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.stmt list)
