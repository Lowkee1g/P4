{
open Lexing
open Ast
open Parser

exception Lexing_error of string

let string_buff = Buffer.create 256


let char_for_backslash = function
  | 'n' -> '\n'
  | 'r' -> '\r'
  | 'b' -> '\b'
  | 't' -> '\t'
  | c   -> c

let backslash_escapes = ['\\'; '\''; '"'; 'n'; 't'; 'b'; 'r'; ' ']

let kwd_tbl = [
  "for", FOR;
  "to", TO;
  "downto", DOWNTO;
  "swap", SWAP;
  "length", LENGTH;
  "with", WITH;
  "if", IF;
  "print", PRINT;
  "while", WHILE;
  "let", LET;
  "cross", CROSS; (* Produktet af to matrixer *)
  "matrix", MATRIX;
  "columns", COLUMNS;
  "rows", ROWS;
  "return", RETURN;
]

let id_or_kwd = 
  let h = Hashtbl.create 17 in
  List.iter (fun (s, t) -> Hashtbl.add h s t) kwd_tbl;
  fun s ->
    (*let s = String.lowercase_ascii s in*)
    try Hashtbl.find h s with Not_found -> IDENT s
}

let letter = ['a'-'z' 'A'-'Z']
let digit = ['0'-'9']
let ident = (letter | '_') (letter | digit | '_')*
let integer = '0' | ['1'-'9'] digit*


rule token = parse
  | [' ' '\t' '\n']+        { token lexbuf }  (* Ignore white spaces *)
  | ident as id             { print_endline ("Identifier: " ^ id); id_or_kwd id }
  | '>'                     { print_endline "GreaterThan"; GT }
  | '<'                     { print_endline "LessThan"; LT }
  | '='                     { print_endline "Equal"; EQUAL }
  | '['                     { print_endline "LBracket"; LBRACKET }
  | ']'                     { print_endline "RBracket"; RBRACKET }
  | '.'                     { print_endline "Dot"; DOT }
  | '-'                     { print_endline "Minus"; MINUS }
  | '+'                     { print_endline "Plus"; PLUS }
  | '*'                     { print_endline "Times"; TIMES }
  | '"'                     { Buffer.clear string_buff; string lexbuf; STRING (Buffer.contents string_buff) }
  | "be a new"              { print_endline "be a new"; BE_A_NEW }
  | integer as s            { CST (Cint(int_of_string s)) }
  | eof                     { print_endline "eof"; EOF }
  | _ as c                  { raise (Lexing_error ("illegal character: " ^ String.make 1 c)) }


and string = parse
  | '"'                     { () }  (* End of string literal *)
  | '\\' (['\\' '\'' '"' 'n' 't' 'b' 'r' ' '] as c)   { Buffer.add_char string_buff (char_for_backslash c); string lexbuf }
  | _ as c                  { Buffer.add_char string_buff c; string lexbuf }



