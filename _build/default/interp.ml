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

let rec stringOfTables (tablelist: expr list) : string =
	match tablelist with
	| [] -> ""
	| head::[] -> stringOfExpr head 
	| head::rest -> stringOfExpr head ^ "\n" ^ stringOfTables rest 
	

let rec printMultipleValues exprs =
	match exprs with
	| [] -> ""
	| expr::[] -> stringOfExpr expr
	| expr::rest -> stringOfExpr expr ^ ", " ^ printMultipleValues rest

let rec interpret ast indentLevel : string =
		(* Generate a string for indentation: *)
		let indentString = if indentLevel = 0 then "" else String.make (indentLevel * 4) ' ' in
	match ast with
	(* Function *)
	| Sfunc(id, args, stmt) ->
		let argsString = stringOfExprParams args in
		let stmtString = interpret stmt (indentLevel + 1) in
		if indentLevel = 0 then
			Printf.sprintf "%sdef %s(%s):\n%s" indentString id.id argsString stmtString
		else
			Printf.sprintf "%s%s(%s)" indentString id.id argsString
	(* Handle the function call case *)
	| SfuncCall(id, args) ->
		let argsString = stringOfExprParams args in
		Printf.sprintf "%s%s(%s)" indentString id.id argsString

	(* FOR LOOPS*)
	| Sfor(ident, startValue, endValue, stmt) ->
		let startValueString = stringOfExpr startValue in
		let endValueString = stringOfExpr endValue in
		Printf.sprintf "%sfor %s in range(%s, %s + 1):\n%s" (* + 1 to compensate for pythons range function not including last number *)
			indentString ident.id startValueString endValueString (interpret stmt (indentLevel + 1))

	| Sford(ident, startValue, endValue, stmt) ->
		let startValueInt = stringOfExpr startValue in
		let endValueInt = stringOfExpr endValue in
		Printf.sprintf "%sfor %s in range(%s, %s - 1, -1):\n%s" 
			indentString ident.id startValueInt endValueInt (interpret stmt (indentLevel + 1))

	(* IF STATEMENTS*)
	| Sifnest(condition, body, body2) ->
		let conditionString = stringOfExpr condition in
		let bodyString = interpret body (indentLevel + 1) in
		let body2String = interpret body2 (indentLevel) in
		Printf.sprintf "%sif %s:\n%s%s" 
			indentString conditionString bodyString body2String
	
	| Sif(condition, body) ->
		let conditionString = stringOfExpr condition in
		let bodyString = interpret body (indentLevel + 1) in
		Printf.sprintf "%sif %s:\n%s" 
			indentString conditionString bodyString 
		

	| Selseifnest(condition, body1, nextIfStmt) ->
		let conditionString = stringOfExpr condition in
		Printf.sprintf "%selif (%s):\n%s%s" 
			indentString conditionString (interpret body1 (indentLevel + 1)) (interpret nextIfStmt (indentLevel))
	| Selseif(condition, body) ->
		let conditionString = stringOfExpr condition in
		Printf.sprintf "%selif (%s):\n%s" 
			indentString conditionString (interpret body (indentLevel + 1))
	
	
	| Selse(body) ->
		Printf.sprintf "%selse:\n%s" indentString (interpret body (indentLevel + 1))
	| Sendif -> "" 
	  

	(* WHILE LOOPS*)
	| Swhile (condition, body) ->
		let conditionString = stringOfExpr condition in
		Printf.sprintf "%swhile %s:\n%s" indentString conditionString (interpret body (indentLevel + 1))


	(* ARRAY *)
	| SinitArrayList (arrays) ->
		let arrays_str = stringOfArrays arrays in
		(* Replace each comma with a comma, newline, and indentation *)
		let formatted_arrays_str = Str.global_replace (Str.regexp_string "\n") ("\n" ^ indentString) arrays_str in
		Printf.sprintf "%s%s\n" indentString formatted_arrays_str
	
	| SinitTableList (tables) ->
		let tablesString = stringOfTables tables in
		(* Replace each comma with a comma, newline, and indentation *)
		let formattedTablesString = Str.global_replace (Str.regexp_string "\n") ("\n" ^ indentString) tablesString in
		Printf.sprintf "%s%s\n" indentString formattedTablesString

	| Slength (expr) ->
		let exprString = stringOfExpr expr in
		Printf.sprintf "%slen(%s)\n" indentString exprString

	| Scolumns (expr) ->
		let exprString = stringOfExpr expr in
		Printf.sprintf "%slen(%s[0])\n" indentString exprString

	| Srows (expr) ->
		let exprString = stringOfExpr expr in
		Printf.sprintf "%slen(%s)\n" indentString exprString

	| Sswap (expr1, expr2) ->
		let expr1Str = stringOfExpr expr1 in
		let expr2Str = stringOfExpr expr2 in
		Printf.sprintf "%s%s, %s = %s, %s\n" indentString expr1Str expr2Str expr2Str expr1Str
		
	| Sexchange (expr1, expr2) ->
		let expr1Str = stringOfExpr expr1 in
		let expr2Str = stringOfExpr expr2 in
		Printf.sprintf "%s%s, %s = %s, %s\n" indentString expr1Str expr2Str expr2Str expr1Str

	| Sinitmatrix (id, size1, size2) ->
		let size1_str = stringOfExpr size1 in
		let size2_str = stringOfExpr size2 in
		Printf.sprintf "%s%s = Array([Array([0 for _ in range(%s)]) for _ in range(%s)])\n" indentString id.id size2_str size1_str

	| Smatrix (id, size1, size2) ->
		let size1_str = stringOfExpr size1 in
		let size2_str = stringOfExpr size2 in
		Printf.sprintf "%s%s[%s][%s]\n" indentString id.id size2_str size1_str

	| Sassign (expr1, expr2) ->
		let expr1Str = stringOfExpr expr1 in
		let expr2Str = stringOfExpr expr2 in
		Printf.sprintf "%s%s = %s\n" indentString expr1Str expr2Str

	| Sreturn (expr) ->
		let exprString = stringOfExprParams expr in
		let formatted_exprString = Str.global_replace (Str.regexp_string "and") (", ") exprString in
		Printf.sprintf "%sreturn %s\n" indentString formatted_exprString
			
	| Sprint(expr) ->
		let exprString = printMultipleValues expr in
		Printf.sprintf "%s%s\n" indentString exprString

	| Serror(expr) ->
		let exprString = stringOfExpr expr in
		Printf.sprintf "%sraise Exception('%s')\n" indentString exprString

	(* Sort *)
	| SsortA(expr, expr2) ->
		let exprString = stringOfExpr expr in
		let expr2Str = stringOfExpr expr2 in
		Printf.sprintf "%s%s.sort(reverse=False, key=%s)\n" indentString exprString expr2Str
	| SsortD(expr, expr2) ->
		let exprString = stringOfExpr expr in
		let expr2Str = stringOfExpr expr2 in
		Printf.sprintf "%s%s.sort(reverse=True, key=%s)\n" indentString exprString expr2Str

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
		Printf.sprintf "%s%s.insert(0, %s)\n" indentString expr_list insertValue
		
	| SinsertRoot(expr, expr2) ->
		let insertValue = stringOfExpr expr in
		let expr_list = stringOfExpr expr2 in
		let loop_code = Printf.sprintf "%sfor i in range(0, len(%s)):\n" indentString expr_list in
		let insert_code = Printf.sprintf "%s%s.insert(0, %s)\n" (indentString ^ (String.make (indentLevel * 4) ' ')) expr_list insertValue in
		loop_code ^ insert_code
	
		
	| SinsertAll(expr, expr2) ->
		let insertValue = stringOfExpr expr in
		let expr_list = stringOfExpr expr2 in
		Printf.sprintf "%s%s.extend(%s)\n" indentString expr_list insertValue

	

	| Sblock(stmts) ->
		let stmtStrings = List.map (fun s -> interpret s indentLevel) stmts in
		String.concat "" stmtStrings
	(*| _ -> error "Unrecognized AST node"*)
	