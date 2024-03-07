(* Abstract Syntax of Mini-Python *)

(* Parsed trees.
   This is the output of the parser and the input of the interpreter. *)

type location = Lexing.position * Lexing.position

type ident = { loc: location; id: string; }

(* Unary operators, representing operations on a single operand *)
type unop =
  | Uneg (* Represents unary negation, for negating numbers: -e *)
  | Unot (* Represents logical NOT operation: not e *)

(* Binary operators, representing operations involving two operands *)
type binop =
  | Badd | Bsub | Bmul | Bdiv | Bmod    (* Arithmetic operators: addition (+), subtraction (-), multiplication {*}, division (/), modulo (%) *)
  | Beq | Bneq | Blt | Ble | Bgt | Bge  (* Comparison operators: equal (==), not equal (!=), less than (<), less than or equal (<=), greater than (>), greater than or equal (>=) *)
  | Band | Bor                          (* Logical operators: AND (and), OR (or) *)

(* Constants that can appear in expressions *)
type constant =
  | Cnone            (* Represents the absence of a value *)
  | Cbool of bool    (* Boolean constant (true or false) *)
  | Cstring of string (* String constant *)
  | Cint of int64    (* Integer constant, using a 64-bit representation *)
  | Cfloat of float  (* Floating-point constant *) 


(* Expressions, representing the smallest elements of computation *)
type expr =
  | Ecst of constant  (* Constant value *)
  | Eident of ident   (* Identifier, representing a variable or function name *)
  | Ebinop of binop * expr * expr (* Binary operation on two expressions *)
  | Eunop of unop * expr (* Unary operation on a single expression *)
  | Ecall of ident * expr list (* Function call with a list of argument expressions *)
  | Elist of expr list (* List of expressions *)
  | Eget of expr * expr (* Array or list access, e1[e2] *)
  (*| Ematrix of expr list list  New: Matrix of expressions * TODO: spørg om det er nødvendigt *)
  | Erange of expr * expr (* Range expression, representing a range of values from e1 to e2 *)
  | Elen of expr (* Length of an array or list *)
  | Einput (* New: Input expression *)
  | Eerror of expr (* New: Error expression *)
  


(* Statements, representing actions or commands in the program *)
and stmt =
  | Sif of expr * stmt * stmt (* If statement with condition, then branch, and else branch *)
  | Swhile of expr * stmt (* New: While loop *)
  | Sreturn of expr (* Return statement with an expression *)
  | Sassign of ident * expr (* Assignment statement, assigning the result of an expression to an identifier *)
  | Sprint of expr (* Print statement for outputting the value of an expression *)
  | Sblock of stmt list (* Block of statements, allowing for multiple statements to be grouped together *)
  | Sfor of ident * expr * stmt (* For loop with an identifier, an expression representing the range or condition, and the loop body as a statement *)
  | Seval of expr (* Evaluation of an expression without using its result *)
  | Sset of expr * expr * expr (* Array or list assignment, e1[e2] = e3 *)
  | Sswap of expr * expr (* Swap two variables *)
  | Ssort of expr (* Sort an array or list *)
  | Serror of expr (* New: Error statement *)


(* Definition of a function or procedure *)
and def = ident * ident list * stmt

(* The structure of a whole file or program, consisting of a list of definitions and a main statement block *)
and file = def list * stmt

