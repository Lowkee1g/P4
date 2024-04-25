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
  "exchange", EXCHANGE;
  "with", WITH;

  (*If Statements*)
  "if", IF;
  "else", ELSE;
  "elseif", ELSEIF;

  (*Simple Stmt*)
  "print", PRINT;
  "return", RETURN;
  "error", ERROR;
  "length", LENGTH;
  "Random", RANDOM;

  (* While *)
  "while", WHILE;

  (* Matrix & array *)
  "let", LET;
  "matrix", MATRIX;
  "array", ARRAY;
  "columns", COLUMNS;
  "rows", ROWS;


  (* Sort *)
  "sort", SORT;
  "ascending", ASCENDING;
  "decreasing", DECREASING;
  "monotonically", MONOTONICALLY;
  "order", ORDER;
  "by", BY;
  "weight", WEIGHT;

  (* Insert *)
  "insert", INSERT;
  "into", INTO;
  "all", ALL;
  "items", ITEMS;
  "in", IN;
  "root-list", ROOTLIST;
]

let id_or_kwd = 
  let h = Hashtbl.create 50 in
  List.iter (fun (s, t) -> Hashtbl.add h s t) kwd_tbl;
  fun s ->
    (*let s = String.lowercase_ascii s in*)
    try 
      let found = Hashtbl.find h s in
      print_endline ("Found keyword: " ^ s);  (* This prints if the input was a keyword *)
      found
    with Not_found ->
      print_endline ("Not a keyword: " ^ s);  (* This prints if the input was not a keyword *)
      IDENT s




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
(* let expr = ident | ['1'-'9'] digit* *)
let space = ' ' | '\t'




rule next_tokens = parse
  | '\n'                                { new_line lexbuf; update_stack (indentation lexbuf) }
  | (space)+                            { next_tokens lexbuf }

  (* Special characters start *)
  | "×"                                 { print_string "CROSS "; [CROSS] }
  | "cross"                             { print_string "CROSS "; [CROSS] }
  | "∞"                                 { print_string "Infinity "; [INFINITY] }
  | "inf"                               { print_string "Infinity "; [INFINITY] }
  | "⋅"                                 { print_string "Times "; [TIMES] }
  | "*"                                 { print_string "Times "; [TIMES] }
  | "ø"                                 { print_string "EmptySet "; [EMPTYSET] }
  | "≥"                                 { print_string "GreaterThanEqual "; [GTEQUAL] }
  | "≤"                                 { print_string "LessThanEqual "; [LTEQUAL] }
  (* Special characters end *)

  | "nil"                               { print_string "NIL"; [NIL] }
  | "be" (space)+ "a" (space)+ "new"    { print_string "BeANew "; [BE_A_NEW] }
  | '='                                 { print_string "Equal "; [EQUAL] }
  | '>'                                 { print_string "GreaterThan "; [GT] }
  | '<'                                 { print_string "LessThan "; [LT] }
  | '['                                 { print_string "LBracket "; [LBRACKET] }
  | ']'                                 { print_string "RBracket "; [RBRACKET] }
  | '('                                 { print_string "LParen "; [LPAREN] }
  | ')'                                 { print_string "RParen "; [RPAREN] }
  | '.'                                 { print_string "Dot "; [DOT] }
  | ".."                                { print_string "DOTDOT "; [DOTDOT] }
  | ','                                 { print_string "Comma "; [COMMA] }
  | '-'                                 { print_string "Minus "; [MINUS] }
  | '+'                                 { print_string "Plus "; [PLUS] }
  | '"'                                 { Buffer.clear string_buff; string lexbuf; [STRING (Buffer.contents string_buff)] }
  | ident as id                         { [id_or_kwd id] }
  | integer as s                        { [CST (Cint(int_of_string s))] }
  | eof                                 { print_endline "eof\n\n"; NEWLINE :: unindent 0 @ [EOF] }
  | _ as c                              { raise (Lexing_error ("illegal character: " ^ String.make 1 c)) }

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
