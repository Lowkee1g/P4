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
  "else", ELSE;
  "elseif", ELSEIF;
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


let stack = ref [0]  (* indentation stack *)

let rec unindent n = match !stack with
  | m :: _ when m = n -> []
  | m :: st when m > n -> stack := st; END :: unindent n
  | _ -> raise (Lexing_error "bad indentation")

let update_stack n =
  match !stack with
  | m :: _ when m < n ->
    stack := n :: !stack;
    [NEWLINE; BEGIN]
  | _ ->
    NEWLINE :: unindent n
}

let letter = ['a'-'z' 'A'-'Z']
let digit = ['0'-'9']
let ident = (letter | '_') (letter | digit | '_')*
let integer = '0' | ['1'-'9'] digit*
let space = ' ' | '\t'


rule next_tokens = parse
  | '\n'    { new_line lexbuf; update_stack (indentation lexbuf) }
  | (space)+ { next_tokens lexbuf }
  | ident as id             { print_endline ("Identifier: " ^ id); [id_or_kwd id] }
  | '='                     { print_endline "Equal"; [EQUAL] }
  | '>'                     { print_endline "GreaterThan"; [GT] }
  | '<'                     { print_endline "LessThan"; [LT] }
  | '['                     { print_endline "LBracket"; [LBRACKET] }
  | ']'                     { print_endline "RBracket"; [RBRACKET] }
  | '('                     { print_endline "LParen"; [LPAREN] }
  | ')'                     { print_endline "RParen"; [RPAREN] }
  | '.'                     { print_endline "Dot"; [DOT] }
  | ','                     { print_endline "Comma"; [COMMA] }
  | '-'                     { print_endline "Minus"; [MINUS] }
  | '+'                     { print_endline "Plus"; [PLUS] }
  | '*'                     { print_endline "Times"; [TIMES] }
  | '"'                     { Buffer.clear string_buff; string lexbuf; [STRING (Buffer.contents string_buff)] }
  | integer as s            { [CST (Cint(int_of_string s))] }
  | eof                     { print_endline "eof"; NEWLINE :: unindent 0 @ [EOF] }
  | _ as c                  { raise (Lexing_error ("illegal character: " ^ String.make 1 c)) }

and indentation = parse
  | (space)* '\n'
      { new_line lexbuf; indentation lexbuf }
  | space* as s
      { String.length s }


and string = parse
  | '"'                     { () }  (* End of string literal *)
  | '\\' (['\\' '\'' '"' 'n' 't' 'b' 'r' ' '] as c)   { Buffer.add_char string_buff (char_for_backslash c); string lexbuf }
  | _ as c                  { Buffer.add_char string_buff c; string lexbuf }

  {

let next_token =
    let tokens = Queue.create () in (* next tokens to emit *)
    fun lb ->
      if Queue.is_empty tokens then begin
	let l = next_tokens lb in
	List.iter (fun t -> Queue.add t tokens) l
      end;
      Queue.pop tokens
}
