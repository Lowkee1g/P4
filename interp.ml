open Printf
open Ast
open Lexer
open Parser
open Lexing
open Parsing

let rec string_of_expr expr =
	match expr with
	| Ebinop(op, e1, e2) ->
		let e1_str = string_of_expr e1 in
		let e2_str = string_of_expr e2 in
		Printf.sprintf "%s %s %s" e1_str (string_of_binop op) e2_str (* This will handle expressions like '1 == 1' *)
	| Ecst c -> string_of_constant c
	| Eident id -> id.id
	| Earray (id, index) -> Printf.sprintf "%s[%s]" id.id (string_of_expr index)
	| Ematrix (id, ident1, ident2) -> Printf.sprintf "%s[%s][%s]" id.id (string_of_expr ident1) (string_of_expr ident2)
	| Elength expr -> Printf.sprintf "len(%s)" (string_of_expr expr)
	| Ecolumns expr -> Printf.sprintf "len(%s[0])" (string_of_expr expr)
	| Erows expr -> Printf.sprintf "len(%s)" (string_of_expr expr)
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
	| Ecst (Cstring s) -> Printf.sprintf "print('%s')" s
	| _ -> failwith "Cannot print expression"

let rec interpret ast  =
	match ast with
	| Sfor(ident, start_val, end_val) ->
		let start_val_int = string_of_expr start_val in
		let end_val_int = string_of_expr end_val in
		Printf.sprintf "for %s in range(%s, %s):" ident.id start_val_int end_val_int
	| Sford(ident, start_val, end_val) ->
		let start_val_int = string_of_expr start_val in
		let end_val_int = string_of_expr end_val in
		Printf.sprintf "for %s in range(%s, %s, -1):" ident.id start_val_int end_val_int
	| Sif(e, s1, s2) ->
		let e_str = string_of_expr e in
		let s1_str = interpret s1 in
		let s2_str = interpret s2 in
		Printf.sprintf "if %s:\n%s\nelse:\n%s" e_str s1_str s2_str
	| Sprint(expr) ->
		let expr_str = print_value expr in
		Printf.sprintf "%s" expr_str
	| Sarray (id, size) ->
		let size_int = string_of_expr size in
		Printf.sprintf "%s = [None] * %s" id.id size_int
	| Slength (expr) ->
		let expr_str = string_of_expr expr in
		Printf.sprintf "len(%s)" expr_str
	| Scolumns (expr) ->
		let expr_str = string_of_expr expr in
		Printf.sprintf "len(%s[0])" expr_str
	| Srows (expr) ->
		let expr_str = string_of_expr expr in
		Printf.sprintf "len(%s)" expr_str
	| Sswap (expr1, expr2) ->
		let expr1_str = string_of_expr expr1 in
		let expr2_str = string_of_expr expr2 in
		Printf.sprintf "%s, %s = %s, %s" expr1_str expr2_str expr2_str expr1_str
	| Swhile (e, s1, s2) ->
		let e_str = string_of_expr e in
		let s1_str = interpret s1 in
		let s2_str = interpret s2 in
		Printf.sprintf "while %s:\n%s\n%s" e_str s1_str s2_str 
	| Sinitmatrix (id, size1, size2) ->
		let size1_str = string_of_expr size1 in
		let size2_str = string_of_expr size2 in
		Printf.sprintf "%s = [[0 for _ in range(%s)] for _ in range(%s)]" id.id size2_str size1_str
	| Smatrix (id, size1, size2) ->
		let size1_str = string_of_expr size1 in
		let size2_str = string_of_expr size2 in
		Printf.sprintf "%s[%s][%s]" id.id size2_str size1_str
	| Sassign (expr1, expr2) ->
		let expr1_str = string_of_expr expr1 in
		let expr2_str = string_of_expr expr2 in
		Printf.sprintf "%s = %s" expr1_str expr2_str
	| Sreturn (expr) ->
		let expr_str = string_of_expr expr in
		Printf.sprintf "return %s" expr_str

