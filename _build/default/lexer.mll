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
  "if", IF;
  "then", THEN;
  "print", PRINT;
]

let id_or_kwd = 
  let h = Hashtbl.create 17 in
  List.iter (fun (s, t) -> Hashtbl.add h s t) kwd_tbl;
  fun s ->
    let s = String.lowercase_ascii s in
    try Hashtbl.find h s with Not_found -> IDENT s
}

let letter = ['a'-'z' 'A'-'Z']
let digit = ['0'-'9']
let ident = (letter | '_') (letter | digit | '_')*
let integer = '0' | ['1'-'9'] digit*


rule token = parse
  | '>'                     { print_endline "GreaterThan"; GT }
  | [' ' '\t' '\n']+        { token lexbuf }  (* Ignore white spaces *)
  | ident as id             { print_endline ("Identifier: " ^ id); id_or_kwd id }
  | '='                     { print_endline "Equal"; EQUAL }
  | '"'                     { Buffer.clear string_buff; string lexbuf; STRING (Buffer.contents string_buff) }
  | integer as s            { CST (Cint(int_of_string s)) }
  | eof                     { print_endline "eof"; EOF }
  | _ as c                  { raise (Lexing_error ("illegal character: " ^ String.make 1 c)) }


and string = parse
  | '"'                     { () }  (* End of string literal *)
  | '\\' (['\\' '\'' '"' 'n' 't' 'b' 'r' ' '] as c)   { Buffer.add_char string_buff (char_for_backslash c); string lexbuf }
  | _ as c                  { Buffer.add_char string_buff c; string lexbuf }




(*{ DAVIDS
open Lexing
open Ast
open Parser

exception Lexing_error of string


  let kwd_tbl =
    ["for", FOR;
     "to", TO;
     "if", IF;
     "then", THEN;
     "print", PRINT;
    ]

  let id_or_kwd =
    let h = Hashtbl.create 17 in
    List.iter (fun (s,t) -> Hashtbl.add h s t) kwd_tbl;
    fun s ->
      let s = String.lowercase_ascii s in
      try List.assoc s kwd_tbl with _ -> IDENT s
}


let letter = ['a'-'z' 'A'-'Z']
let digit = ['0'-'9']
let ident = (letter | '_') (letter | digit | '_')*
let integer = '0' | ['1'-'9'] digit*

rule token = parse
  | [' ' '\t' '\n']                 { token lexbuf }  (* Ignore white spaces *)
  | ident as id                { print_endline ("Identifier: " ^ id); id_or_kwd id }
  | '='                        { print_endline "Equal"; EQUAL }
  | '"'                        { print_endline "Quote"; QUOTE }
  | integer as s                { CST (Cint(int_of_string s)) }
  | eof                        { print_endline "eof"; EOF }
  | _ as c  { raise (Lexing_error ("illegal character: " ^ String.make 1 c)) }
*)