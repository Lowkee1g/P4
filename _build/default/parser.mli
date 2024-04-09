
(* The type of tokens. *)

type token = 
  | TO
  | STRING of (string)
  | PRINT
  | NEWLINE
  | IDENT of (string)
  | FOR
  | EQUAL
  | EOF
  | END
  | CST of (Ast.constant)
  | BEGIN

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val file: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.stmt)
