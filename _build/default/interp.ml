open Printf
open Ast
open Lexer
open Parser
open Lexing
open Parsing

let rec eval_expr expr = 
  match expr with
  | Ecst (Cint i) -> i
  | _ -> failwith "Cannot evaluate non-integer expression"

let rec string_of_expr expr =
	match expr with
	| Ebinop(op, e1, e2) ->
		let e1_str = string_of_expr e1 in
		let e2_str = string_of_expr e2 in
		Printf.sprintf "%s %s %s" e1_str (string_of_binop op) e2_str (* This will handle expressions like '1 == 1' *)
	| Ecst c -> string_of_constant c
	| Eident id -> id.id
	(* Add cases for other types of expressions as needed *)
	
	and string_of_constant = function
	| Cint i -> Printf.sprintf "%d" i
	| Cstring s -> Printf.sprintf "%s" s  (* For string constants, you might want to adjust this to match your output preference *)
	| Cbool b -> if b then "true" else "false"
	| Cnone -> "None"
	
	and string_of_binop = function
	| Badd -> "+"
	| Bsub -> "-"
	| Bmul -> "*"
	| Bdiv -> "/"
	| Beq -> "=="
	| Bneq -> "!="
	| Blt -> "<"
	| Ble -> "<="
	| Bgt -> ">"
	| Bge -> ">="
	| Band -> "&&"
	| Bor -> "||"
	(* Add more cases here as necessary *)


let rec print_value expr = 
	match expr with
	| Ecst (Cint i) -> Printf.sprintf "print(%d)" i
	| Ecst (Cbool b) -> Printf.sprintf "print(%b)" b
	| Ecst (Cstring s) -> Printf.sprintf "print(%s)" s
	| _ -> failwith "Cannot print expression"

let make_indentation blockcounter = 
	String.make (!blockcounter * 4) ' '

let rec interpret ast blockcounter =
	let spaces = make_indentation blockcounter in
	match ast with
	| Sfor(ident, start_val, end_val) ->
		let start_val_int = eval_expr start_val in
		let end_val_int = eval_expr end_val in
		Printf.sprintf "for %s in range(%d, %d):" ident.id start_val_int end_val_int
	| Sif(cond, body) ->
		let new_blockcounter = !blockcounter + 1 in
		let cond_str = string_of_expr cond in
		let body_str = String.concat "\n" (List.map (fun s -> interpret s (ref new_blockcounter)) body) in
		Printf.sprintf "%sif %s:\n%s" spaces cond_str body_str
	| Sprint(expr) ->
		let expr_str = print_value expr in
		Printf.sprintf "%s%s" spaces expr_str
		
		
		


      

  let _ =
    let filename = "for.txt" in
    try
      let channel = open_in filename in
      let lexbuf = Lexing.from_channel channel in
      let ast = Parser.main Lexer.token lexbuf in
      let result = interpret ast (ref 0) in
      close_in channel;
      let out_channel = open_out "for_result.txt" in
      fprintf out_channel "%s\n" result;
      close_out out_channel;
      printf "Successfully interpreted and wrote the result to for_result.txt\n"
    with
    | Sys_error msg ->
        printf "Error: %s\n" msg
    | Lexer.Lexing_error msg ->
        printf "Lexer error: %s\n" msg
    | Parser.Error ->
          let curr_token = symbol_start_pos () in
          let curr_line = curr_token.pos_lnum in
          let curr_col = curr_token.pos_cnum - curr_token.pos_bol in
          let error_msg = Printf.sprintf "Parser error: syntax error at line %d, column %d\n" curr_line curr_col in
          printf "%s" error_msg
    | End_of_file ->
        printf "End of file\n"
  