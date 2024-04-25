open Ast
open Format

exception Error of string
let error s = raise (Error s)


let rec string_of_idents_params idents =
	match idents with
	| [] -> ""
	| id::[] -> id.id
	| id::rest -> id.id ^ ", " ^ string_of_idents_params rest


let rec string_of_idents_dash idents =
	match idents with
	| [] -> ""
	| id::[] -> id.id
	| id::rest -> id.id ^ "_" ^ string_of_idents_dash rest



let rec string_of_expr expr =
	match expr with
	| Ebinop(op, e1, e2) ->
		let e1_str = string_of_expr e1 in
		let e2_str = string_of_expr e2 in
		Printf.sprintf "%s %s %s" e1_str (string_of_binop op) e2_str (* This will handle expressions like '1 == 1' *)
	| Ecst c -> string_of_constant c
	| Eident id -> id.id
	| Earray (id, index) -> Printf.sprintf "%s[%s]" id.id (string_of_expr index)
	| Erange (e1, e2) -> Printf.sprintf "range(%s, %s)" (string_of_expr e1) (string_of_expr e2)
	| Ematrix (id, ident1, ident2) -> Printf.sprintf "%s[%s][%s]" id.id (string_of_expr ident1) (string_of_expr ident2)
	| Elength id -> Printf.sprintf "len(%s)" id.id
	| Ecolumns id -> Printf.sprintf "len(%s[0])" id.id
	| Erows id -> Printf.sprintf "len(%s)"  id.id
	| Erandom (e1, e2) -> Printf.sprintf "random.randint(%s, %s)" (string_of_expr e1) (string_of_expr e2)
	| EfunctionCall (id, args) -> Printf.sprintf "%s(%s)" id.id (string_of_idents_params args)
	| Eobject (id1, id2) -> Printf.sprintf "%s.%s" id1.id id2.id
	(* Add cases for other types of expressions as needed *)
	
	and string_of_constant = function
	| Cint i -> Printf.sprintf "%d" i
	| Cstring s -> Printf.sprintf "%s" s  (* For string constants, you might want to adjust this to match your output preference *)
	| Cbool b -> if b then "true" else "false"
	| Cnil -> "None"
	| Cinfinity -> "float('inf')"
	| CminusInfinity -> "float('-inf')"

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
	| Memptyset -> "{}"
	| Mgreaterthanequal -> ">="
	| Mlessthanequal -> "<="


let rec print_value expr = 
	match expr with
	| Ecst (Cstring s) -> Printf.sprintf "print('%s')" s
	| Eident id -> Printf.sprintf "print(%s)" id.id
	| Earray (id, index) -> Printf.sprintf "print(%s[%s])" id.id (string_of_expr index)
	| Ematrix (id, ident1, ident2) -> Printf.sprintf "print(%s[%s][%s])" id.id (string_of_expr ident1) (string_of_expr ident2)
	| _ -> failwith "Cannot print expression"

let rec interpret ast indent_level : string =
	(* Generate a string for indentation: *)
	let indent_str = if indent_level = 0 then "" else String.make (indent_level * 4) ' ' in
	match ast with
	(* Function *)
	(* Handle the function definition case *)
	| Sfunc(id, args, stmt) ->
		(* Use string_of_idents to turn the list of idents into a comma-separated string *)
		let args_str = string_of_idents_params args in
		let id_str = string_of_idents_dash id in

		(* Use args_str in the formatted string for the function definition *)
		Printf.sprintf "%sdef %s(%s):\n%s" indent_str id_str args_str (interpret stmt (indent_level + 1))


	(* FOR LOOPS*)
	| Sfor(ident, start_val, end_val, stmt) ->
		let start_val_str = string_of_expr start_val in
		let end_val_str = string_of_expr end_val in
		Printf.sprintf "%sfor %s in range(%s, %s):\n%s" 
			indent_str ident.id start_val_str end_val_str (interpret stmt (indent_level + 1))

	| Sford(ident, start_val, end_val, stmt) ->
		let start_val_int = string_of_expr start_val in
		let end_val_int = string_of_expr end_val in
		Printf.sprintf "%sfor %s in range(%s, %s, -1):%s" 
			indent_str ident.id start_val_int end_val_int (interpret stmt (indent_level + 1))

	(* IF STATEMENTS*)
	| Sif(cond, body, body2) ->
		let cond_str = string_of_expr cond in
		let body_str = interpret body (indent_level + 1) in
		let body2_str = interpret body2 (indent_level) in
		Printf.sprintf "%sif %s:\n%s%s" 
			indent_str cond_str body_str body2_str

	| Selseif(cond, body1, nextIfStmt) ->
		let cond_str = string_of_expr cond in
		Printf.sprintf "%selif (%s):\n%s%s" 
			indent_str cond_str (interpret body1 (indent_level + 1)) (interpret nextIfStmt (indent_level))
	
	| Selse(body) ->
		Printf.sprintf "%selse:\n%s" indent_str (interpret body (indent_level + 1))

	| Sendif -> "" 
	  


	(* WHILE LOOPS*)
	| Swhile (cond, body) ->
		let cond_str = string_of_expr cond in
		Printf.sprintf "%swhile %s:\n%s" indent_str cond_str (interpret body (indent_level + 1))


	(* ARRAY *)
	| Sinitarray (id, range) ->
		let range_str = string_of_expr range in
		Printf.sprintf "%s%s = [None] * %s\n" indent_str id.id range_str

	| Sarray (id, size) ->
		let size_int = string_of_expr size in
		Printf.sprintf "%s%s = [None] * %s\n" indent_str id.id size_int


	| Slength (expr) ->
		let expr_str = string_of_expr expr in
		Printf.sprintf "%slen(%s)\n" indent_str expr_str

	| Scolumns (expr) ->
		let expr_str = string_of_expr expr in
		Printf.sprintf "%slen(%s[0])\n" indent_str expr_str

	| Srows (expr) ->
		let expr_str = string_of_expr expr in
		Printf.sprintf "%slen(%s)\n" indent_str expr_str

	| Sswap (expr1, expr2) ->
		let expr1_str = string_of_expr expr1 in
		let expr2_str = string_of_expr expr2 in
		Printf.sprintf "%s%s, %s = %s, %s\n" indent_str expr1_str expr2_str expr2_str expr1_str
		
	| Sexchange (expr1, expr2) ->
		let expr1_str = string_of_expr expr1 in
		let expr2_str = string_of_expr expr2 in
		Printf.sprintf "%s%s, %s = %s, %s\n" indent_str expr1_str expr2_str expr2_str expr1_str

	| Sinitmatrix (id, size1, size2) ->
		let size1_str = string_of_expr size1 in
		let size2_str = string_of_expr size2 in
		Printf.sprintf "%s%s = [[0 for _ in range(%s)] for _ in range(%s)]\n" indent_str id.id size2_str size1_str

	| Smatrix (id, size1, size2) ->
		let size1_str = string_of_expr size1 in
		let size2_str = string_of_expr size2 in
		Printf.sprintf "%s%s[%s][%s]\n" indent_str id.id size2_str size1_str

	| Sassign (expr1, expr2) ->
		let expr1_str = string_of_expr expr1 in
		let expr2_str = string_of_expr expr2 in
		Printf.sprintf "%s%s = %s\n" indent_str expr1_str expr2_str

	| Sreturn (expr) ->
		let expr_str = string_of_expr expr in
		Printf.sprintf "%sreturn %s\n" indent_str expr_str
			
	| Sprint(expr) ->
		let expr_str = print_value expr in
		Printf.sprintf "%s%s\n" indent_str expr_str

	| Serror(expr) ->
		let expr_str = string_of_expr expr in
		Printf.sprintf "%sraise Exception('%s')\n" indent_str expr_str

	(* Sort *)
	| SsortA(expr, expr2) ->
		let expr_str = string_of_expr expr in
		let expr2_str = string_of_expr expr2 in
		Printf.sprintf "%s%s.sort(reverse=False, key=%s)\n" indent_str expr_str expr2_str
	| SsortD(expr, expr2) ->
		let expr_str = string_of_expr expr in
		let expr2_str = string_of_expr expr2 in
		Printf.sprintf "%s%s.sort(reverse=True, key=%s)\n" indent_str expr_str expr2_str

	(* Get *)

	(* Insert *)
	(*insert x into H's root list
    insert A[i] into H's root list
    insert all-items-in T.table into new-table
    insert x into T.table

    insert expr into expr
    insert all-items-in expr into expr
    insert expr into expr root list *)

	| Sinsert(expr, expr2) ->
		let insertValue = string_of_expr expr in
		let expr_list = string_of_expr expr2 in
		Printf.sprintf "%s%s.insert(0, %s)\n" indent_str expr_list insertValue
		
	| SinsertRoot(expr, expr2) ->
		let insertValue = string_of_expr expr in
		let expr_list = string_of_expr expr2 in
		let loop_code = Printf.sprintf "%sfor i in range(0, len(%s)):\n" indent_str expr_list in
		let insert_code = Printf.sprintf "%s%s.insert(0, %s)\n" (indent_str ^ (String.make (indent_level * 4) ' ')) expr_list insertValue in
		loop_code ^ insert_code
	
		
	| SinsertAll(expr, expr2) ->
		let insertValue = string_of_expr expr in
		let expr_list = string_of_expr expr2 in
		Printf.sprintf "%s%s.extend(%s)\n" indent_str expr_list insertValue

	

	| Sblock(stmts) ->
		let stmt_strs = List.map (fun s -> interpret s indent_level) stmts in
		String.concat "" stmt_strs
	(*| _ -> error "Unrecognized AST node"*)
	