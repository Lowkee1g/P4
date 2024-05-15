{
open Lexing
open Ast
open Parser

exception Lexing_error of string

let silent = ref false

let conditional_print str = if not !silent then print_string str

let string_buff = Buffer.create 256

let is_printable c = 
  let code = Char.code c in
  code >= 32 && code <= 126  (* Printable ASCII range *)

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

  "low", LOW;
  "high", HIGH;

  (*If Statements*)
  "if", IF;
  "else", ELSE;
  "elseif", ELSEIF;

  (*Simple Stmt*)
  "print", PRINT;
  "return", RETURN;
  "error", ERROR;
  "length", LENGTH;
  "RANDOM", RANDOM;
  "random", RANDOM;

  (* While *)
  "while", WHILE;

  (* Matrix & array *)
  "let", LET;
  "matrix", MATRIX;
  "array", ARRAY;
  "arrays", ARRAY;
  "table", TABLE;
  "tables", TABLE;
  "columns", COLUMNS;
  "rows", ROWS;


  (* Sort *)
  "sort", SORT;

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
    try 
      let found = Hashtbl.find h s in
      if not !silent then print_string_yellow ("keyword: " ^ s ^ " ");
      found
    with Not_found ->
      if not !silent then print_string_blue ("Ident: " ^ s ^ " ");
      IDENT s


let debugLines = ref 2;;

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
  | '\n'                                { if not !silent then (print_string_red "\nLine: "; print_int !debugLines; print_string "  "); debugLines := !debugLines + 1; new_line lexbuf; update_stack (indentation lexbuf) }
  | (space)+                            { next_tokens lexbuf }

  (* Special characters start *)
  | "×"                                 { if not !silent then print_string_magenta " CROSS "; [CROSS] }
  | "cross"                             { if not !silent then print_string_magenta " CROSS "; [CROSS] }
  | "∞"                                 { if not !silent then print_string_magenta " Infinity "; [INFINITY] }
  | "inf"                               { if not !silent then print_string_magenta " Infinity "; [INFINITY] }
  | "⋅"                                 { if not !silent then print_string_magenta " Times "; [TIMES] }
  | "*"                                 { if not !silent then print_string_magenta " Times "; [TIMES] }
  (* Special characters end *)

  (* Math *)
  | '='                                 { if not !silent then print_string_magenta " Equal "; [EQUAL] }
  | '>'                                 { if not !silent then print_string_magenta " GreaterThan "; [GT] }
  | '<'                                 { if not !silent then print_string_magenta " LessThan "; [LT] }
  | '-'                                 { if not !silent then print_string_magenta " Minus "; [MINUS] }
  | '+'                                 { if not !silent then print_string_magenta " Plus "; [PLUS] }
  | '/'                                 { if not !silent then print_string_magenta " Divide "; [DIVIDE] }
  | "//"                                { if not !silent then print_string_magenta " DivideFloor "; [DIVIDEFLOOR] }
  | '%'                                 { if not !silent then print_string_magenta " Mod "; [MOD] }
  | '^'                                 { if not !silent then print_string_magenta " Power "; [POWER] }
  | "∅"                                 { if not !silent then print_string_magenta " Empty_set "; [EMPTYSET] }
  | "≤"                                 { if not !silent then print_string_magenta " LessThanEqual "; [LTE] }
  | "≥"                                 { if not !silent then print_string_magenta " GreaterThanEqual "; [GTE] }
  | "≠"                                 { if not !silent then print_string_magenta " NotEqual "; [NEQ] }
  | "∈"                                 { if not !silent then print_string_magenta " In "; [IN] }
  | "⋃"                                 { if not !silent then print_string_magenta " Union "; [UNION] }
  | "⋂"                                 { if not !silent then print_string_magenta " Intersection "; [INTERSECT] }
  | "π"                                 { if not !silent then print_string_magenta " Pi "; [PI] }



  (* Logical *)
  | "and"                               { if not !silent then print_string_magenta " And "; [AND] }
  | "or"                                { if not !silent then print_string_magenta " Or "; [OR] }

  (* Everything else *)
  | "NIL"                               { if not !silent then print_string_magenta " NIL"; [NIL] }
  | "be" (space)+ "a" (space)+ "new"    { if not !silent then print_string_magenta " BeANew "; [BE_A_NEW] }
  | "be" (space)+ "new"              { if not !silent then print_string_magenta " BeNew "; [BE_A_NEW] }
  | "monotonically" (space)+ "ascending" (space)+ "order" (space)+ "by" (space)+ "weight" { if not !silent then print_string "MONOTONICALLY_ASCENDING_ORDER_BY_WEIGHT "; [MONOTONICALLY_ASCENDING_ORDER_BY_WEIGHT] }
  | "monotonically" (space)+ "decreasing" (space)+ "order" (space)+ "by" (space)+ "weight" { if not !silent then print_string "MONOTONICALLY_DESCENDING_ORDER_BY_WEIGHT "; [MONOTONICALLY_DECREASING_ORDER_BY_WEIGHT] }
  | '['                                 { if not !silent then print_string_magenta " LBracket "; [LBRACKET] }
  | ']'                                 { if not !silent then print_string_magenta " RBracket "; [RBRACKET] }
  | '('                                 { if not !silent then print_string_magenta " LParen "; [LPAREN] }
  | ')'                                 { if not !silent then print_string_magenta " RParen "; [RPAREN] }
  | '{'                                 { if not !silent then print_string_magenta " LBrace "; [LBRACE] }
  | '}'                                 { if not !silent then print_string_magenta " RBrace "; [RBRACE] }
  | '.'                                 { if not !silent then print_string_magenta " Dot "; [DOT] }
  | ".."                                { if not !silent then print_string_magenta " DOTDOT "; [DOTDOT] }
  | ','                                 { if not !silent then print_string_magenta " Comma "; [COMMA] }
  | '"'                                 { Buffer.clear string_buff; string lexbuf; [STRING (Buffer.contents string_buff)] }
  | ident as id                         { [id_or_kwd id] }
  | integer as s                        { if not !silent then print_int_blue s;  [CST (Cint(int_of_string s))] }
  | eof                                 { if not !silent then print_endline "eof\n\n"; NEWLINE :: unindent 0 @ [EOF] }
  | _ as c
      {
        let pos = Lexing.lexeme_start_p lexbuf in
        let char_info =
          if is_printable c then
            Printf.sprintf "illegal character: '%c' (ASCII code: %d)" c (Char.code c)
          else
            Printf.sprintf "illegal character with ASCII code: %d" (Char.code c)
        in
        Printf.eprintf "\x1b[31mError on line %d, column %d: %s\x1b[0m\n"
          pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1) char_info;
        raise (Lexing_error char_info)
      }
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
