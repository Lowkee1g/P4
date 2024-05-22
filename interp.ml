open Ast
open Format
open Str

exception Error of string
let error errorMessage = raise (Error errorMessage)

let rec stringOfExpr expr =
	match expr with
	| Ebinop(Bpow, expr1, expr2) ->
		let leftExpr = stringOfExpr expr1 in
		let rightExpr = stringOfExpr expr2 in
		Printf.sprintf "pow(%s, %s)" leftExpr rightExpr
	| Ebinop(Band, expr1, expr2) -> 
      let leftExpr = stringOfExpr expr1 in
      let rightExpr = stringOfExpr expr2 in
      Printf.sprintf "%s and %s" leftExpr rightExpr 
	| Ebinop(opperator, expr1, expr2) ->
		let opperatorString = stringOfBinaryOperator opperator in
		let expr1Str = stringOfExpr expr1 in
		let expr2Str = stringOfExpr expr2 in
		if opperatorString = ".union" then
			Printf.sprintf "%s.union(%s)" expr1Str expr2Str
		else
			Printf.sprintf "%s %s %s" expr1Str opperatorString expr2Str
	| Ecst const -> stringOfConstant const
	| Eident id -> id.id
	| Earray (id, index) -> Printf.sprintf "%s[%s]" id.id (stringOfExpr index)
	| Einitarray (id, size) -> Printf.sprintf "%s = Array([0 for _ in %s])" id.id (stringOfExpr size)
	| Etable (id, expr1, expr2) -> Printf.sprintf "%s[%s][%s]" id.id (stringOfExpr expr1) (stringOfExpr expr2)
	| Einittable (id, size1, size2) -> Printf.sprintf "%s = Array([Array([0 for _ in %s]) for _ in %s])" id.id (stringOfExpr size1) (stringOfExpr size2)
	| Erange (expr1, expr2) -> Printf.sprintf "range(%s, %s + 1)" (stringOfExpr expr1) (stringOfExpr expr2)
	| Ematrix (id, ident1, ident2) -> Printf.sprintf "%s[%s][%s]" id.id (stringOfExpr ident1) (stringOfExpr ident2)
	| Elength id -> Printf.sprintf "len(%s)" id.id
	| Ecolumns id -> Printf.sprintf "len(%s[0])" id.id
	| Erows id -> Printf.sprintf "len(%s)"  id.id
	| Erandom (expr1, expr2) -> Printf.sprintf "random.randint(%s, %s)" (stringOfExpr expr1) (stringOfExpr expr2)
	| EfunctionCall (id, args) -> Printf.sprintf "%s(%s)" id.id (stringOfExprParams args)
	| Eobject (id1, expr) -> Printf.sprintf "%s.%s" id1.id (objectConstant expr)
	| Eset (expr) -> Printf.sprintf "{%s}" (stringOfExprParams expr)
	| Memptyset -> Printf.sprintf "set()"
	| Elow (expr) -> Printf.sprintf "math.floor(%s)" (stringOfExpr expr)
	| Ehigh (expr) -> Printf.sprintf "math.ceil(%s)" (stringOfExpr expr)
	| _ -> failwith "Cannot print expression"
		
	and stringOfConstant = function
	| Cint intConst -> Printf.sprintf "%d" intConst
	| Cstring stringConst -> Printf.sprintf "%s" stringConst 
	| Cbool boolConst -> if boolConst then "true" else "false"
	| Cnil -> Printf.sprintf "None"
	| Cinfinity -> "float('inf')"
	| CminusInfinity -> "float('-inf')"
	| Cpi -> "(math.pi)"
	
	and stringOfBinaryOperator = function
	| Badd -> "+"
	| Bsub -> "-"
	| Bmul -> "*"
	| Bdiv -> "/"
	| Bfloordiv -> "//"
	| Beq -> "=="
	| Bneq -> "!="
	| Blt -> "<"
	| Ble -> "<="
	| Bgt -> ">"
	| Bge -> ">="
	| Band -> "and"
	| Bor -> "or"
	| Bcomma -> ","
	| Blte -> "<="
	| Bgte -> ">="
	| Bmod -> "%"
	| Bin -> "in"
	| Bun -> ".union"
	| Binter -> "test"

	and objectConstant = function
	| Ocst const -> stringOfConstant const
	| Oident id -> id.id

	and stringOfExprParams (expr: expr list) : string =
		match expr with
		| [] -> ""
		| head::[] -> stringOfExpr head 
		| head::rest -> stringOfExpr head ^ ", " ^ stringOfExprParams rest

				
let rec stringOfArrays (arraylist: expr list) : string =
	match arraylist with
	| [] -> ""
	| head::[] -> stringOfExpr head 
	| head::rest -> stringOfExpr head ^ "\n" ^ stringOfArrays rest

let rec string_of_tables (tablelist: expr list) : string =
	match tablelist with
	| [] -> ""
	| head::[] -> stringOfExpr head 
	| head::rest -> stringOfExpr head ^ "\n" ^ string_of_tables rest 
	

let rec print_multiple_values exprs =
	match exprs with
	| [] -> ""
	| expr::[] -> stringOfExpr expr
	| expr::rest -> stringOfExpr expr ^ ", " ^ print_multiple_values rest




(* let rec print_value expr = 
	match expr with
	| Ecst (Cstring s) -> Printf.sprintf "print('%s')" s
	| Eident id -> Printf.sprintf "print(%s)" id.id
	| Earray (id, index) -> Printf.sprintf "print(%s[%s])" id.id (stringOfExpr index)
	| Ematrix (id, ident1, ident2) -> Printf.sprintf "print(%s[%s][%s])" id.id (stringOfExpr ident1) (stringOfExpr ident2)
	| _ -> failwith "Cannot print expression" *)
	
	let rec interpret ast indent_level : string =
		(* Generate a string for indentation: *)
		let indent_str = if indent_level = 0 then "" else String.make (indent_level * 4) ' ' in
	match ast with
	(* Function *)
	(* Handle the function definition case *)
	| Sfunc(id, args, stmt) ->
		let args_str = stringOfExprParams args in
		let stmt_str = interpret stmt (indent_level + 1) in
		if indent_level = 0 then
			Printf.sprintf "%sdef %s(%s):\n%s" indent_str id.id args_str stmt_str
		else
			Printf.sprintf "%s%s(%s)" indent_str id.id args_str
	(* Handle the function call case *)
	| SfuncCall(id, args) ->
		let args_str = stringOfExprParams args in
		Printf.sprintf "%s%s(%s)" indent_str id.id args_str

	(* FOR LOOPS*)
	| Sfor(ident, start_val, end_val, stmt) ->
		let start_val_str = stringOfExpr start_val in
		let end_val_str = stringOfExpr end_val in
		Printf.sprintf "%sfor %s in range(%s, %s + 1):\n%s" (* + 1 to compensate for pythons range function not including last number *)
			indent_str ident.id start_val_str end_val_str (interpret stmt (indent_level + 1))

	| Sford(ident, start_val, end_val, stmt) ->
		let start_val_int = stringOfExpr start_val in
		let end_val_int = stringOfExpr end_val in
		Printf.sprintf "%sfor %s in range(%s, %s - 1, -1):\n%s" 
			indent_str ident.id start_val_int end_val_int (interpret stmt (indent_level + 1))

	(* IF STATEMENTS*)
	| Sifnest(cond, body, body2) ->
		let cond_str = stringOfExpr cond in
		let body_str = interpret body (indent_level + 1) in
		let body2_str = interpret body2 (indent_level) in
		Printf.sprintf "%sif %s:\n%s%s" 
			indent_str cond_str body_str body2_str
	
	| Sif(cond, body) ->
		let cond_str = stringOfExpr cond in
		let body_str = interpret body (indent_level + 1) in
		Printf.sprintf "%sif %s:\n%s" 
			indent_str cond_str body_str 
		

	| Selseifnest(cond, body1, nextIfStmt) ->
		let cond_str = stringOfExpr cond in
		Printf.sprintf "%selif (%s):\n%s%s" 
			indent_str cond_str (interpret body1 (indent_level + 1)) (interpret nextIfStmt (indent_level))
	| Selseif(cond, body) ->
		let cond_str = stringOfExpr cond in
		Printf.sprintf "%selif (%s):\n%s" 
			indent_str cond_str (interpret body (indent_level + 1))
	
	
	| Selse(body) ->
		Printf.sprintf "%selse:\n%s" indent_str (interpret body (indent_level + 1))

	| Sendif -> "" 
	  


	(* WHILE LOOPS*)
	| Swhile (cond, body) ->
		let cond_str = stringOfExpr cond in
		Printf.sprintf "%swhile %s:\n%s" indent_str cond_str (interpret body (indent_level + 1))


	(* ARRAY *)
	| SinitArrayList (arrays) ->
		let arrays_str = stringOfArrays arrays in
		(* Replace each comma with a comma, newline, and indentation *)
		let formatted_arrays_str = Str.global_replace (Str.regexp_string "\n") ("\n" ^ indent_str) arrays_str in
		Printf.sprintf "%s%s\n" indent_str formatted_arrays_str
	
	| SinitTableList (tables) ->
		let tables_str = string_of_tables tables in
		(* Replace each comma with a comma, newline, and indentation *)
		let formatted_tables_str = Str.global_replace (Str.regexp_string "\n") ("\n" ^ indent_str) tables_str in
		Printf.sprintf "%s%s\n" indent_str formatted_tables_str


	| Slength (expr) ->
		let expr_str = stringOfExpr expr in
		Printf.sprintf "%slen(%s)\n" indent_str expr_str

	| Scolumns (expr) ->
		let expr_str = stringOfExpr expr in
		Printf.sprintf "%slen(%s[0])\n" indent_str expr_str

	| Srows (expr) ->
		let expr_str = stringOfExpr expr in
		Printf.sprintf "%slen(%s)\n" indent_str expr_str

	| Sswap (expr1, expr2) ->
		let expr1Str = stringOfExpr expr1 in
		let expr2Str = stringOfExpr expr2 in
		Printf.sprintf "%s%s, %s = %s, %s\n" indent_str expr1Str expr2Str expr2Str expr1Str
		
	| Sexchange (expr1, expr2) ->
		let expr1Str = stringOfExpr expr1 in
		let expr2Str = stringOfExpr expr2 in
		Printf.sprintf "%s%s, %s = %s, %s\n" indent_str expr1Str expr2Str expr2Str expr1Str

	| Sinitmatrix (id, size1, size2) ->
		let size1_str = stringOfExpr size1 in
		let size2_str = stringOfExpr size2 in
		Printf.sprintf "%s%s = Array([Array([0 for _ in range(%s)]) for _ in range(%s)])\n" indent_str id.id size2_str size1_str

	| Smatrix (id, size1, size2) ->
		let size1_str = stringOfExpr size1 in
		let size2_str = stringOfExpr size2 in
		Printf.sprintf "%s%s[%s][%s]\n" indent_str id.id size2_str size1_str

	| Sassign (expr1, expr2) ->
		let expr1Str = stringOfExpr expr1 in
		let expr2Str = stringOfExpr expr2 in
		Printf.sprintf "%s%s = %s\n" indent_str expr1Str expr2Str

	| Sreturn (expr) ->
		let expr_str = stringOfExprParams expr in
		let formatted_expr_str = Str.global_replace (Str.regexp_string "and") (", ") expr_str in
		Printf.sprintf "%sreturn %s\n" indent_str formatted_expr_str
			
	| Sprint(expr) ->
		let expr_str = print_multiple_values expr in
		Printf.sprintf "%s%s\n" indent_str expr_str

	| Serror(expr) ->
		let expr_str = stringOfExpr expr in
		Printf.sprintf "%sraise Exception('%s')\n" indent_str expr_str

	(* Sort *)
	| SsortA(expr, expr2) ->
		let expr_str = stringOfExpr expr in
		let expr2Str = stringOfExpr expr2 in
		Printf.sprintf "%s%s.sort(reverse=False, key=%s)\n" indent_str expr_str expr2Str
	| SsortD(expr, expr2) ->
		let expr_str = stringOfExpr expr in
		let expr2Str = stringOfExpr expr2 in
		Printf.sprintf "%s%s.sort(reverse=True, key=%s)\n" indent_str expr_str expr2Str

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
		let insertValue = stringOfExpr expr in
		let expr_list = stringOfExpr expr2 in
		Printf.sprintf "%s%s.insert(0, %s)\n" indent_str expr_list insertValue
		
	| SinsertRoot(expr, expr2) ->
		let insertValue = stringOfExpr expr in
		let expr_list = stringOfExpr expr2 in
		let loop_code = Printf.sprintf "%sfor i in range(0, len(%s)):\n" indent_str expr_list in
		let insert_code = Printf.sprintf "%s%s.insert(0, %s)\n" (indent_str ^ (String.make (indent_level * 4) ' ')) expr_list insertValue in
		loop_code ^ insert_code
	
		
	| SinsertAll(expr, expr2) ->
		let insertValue = stringOfExpr expr in
		let expr_list = stringOfExpr expr2 in
		Printf.sprintf "%s%s.extend(%s)\n" indent_str expr_list insertValue

	

	| Sblock(stmts) ->
		let stmt_strs = List.map (fun s -> interpret s indent_level) stmts in
		String.concat "" stmt_strs
	(*| _ -> error "Unrecognized AST node"*)
	