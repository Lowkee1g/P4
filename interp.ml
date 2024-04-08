open Ast
open Format

exception Error of string
let error s = raise (Error s)

let rec string_of_expr expr =
	match expr with
	| Ecst c -> string_of_constant c
	| Eident id -> id.id
	(* Add cases for other types of expressions as needed *)
	
	and string_of_constant = function
	| Cint i -> Printf.sprintf "%d" i
	| Cstring s -> Printf.sprintf "%s" s  (* For string constants, you might want to adjust this to match your output preference *)
	| Cbool b -> if b then "true" else "false"
	| Cnone -> "None"

	(* Add more cases here as necessary *)


let rec print_value expr = 
	match expr with
	| Ecst (Cstring s) -> Printf.sprintf "print('%s')" s
	| _ -> failwith "Cannot print expression"

let rec interpret ast indent_level : string =
	(* Generate a string for indentation: *)
	let indent_str = String.make (indent_level * 2) ' ' in
	match ast with
	| Sfor(ident, start_val, end_val, stmt) ->
		let start_val_str = string_of_expr start_val in
		let end_val_str = string_of_expr end_val in
		Printf.sprintf "%sfor %s in range(%s, %s):\n%s" 
			indent_str ident.id start_val_str end_val_str (interpret stmt (indent_level + 1))
	| Sprint(expr) ->
		let expr_str = print_value expr in
		Printf.sprintf "%s%s\n" indent_str expr_str
	| Sblock(stmts) ->
		let stmt_strs = List.map (fun s -> interpret s (indent_level + 1)) stmts in
		String.concat "" stmt_strs
	| _ -> error "Unrecognized AST node"
	