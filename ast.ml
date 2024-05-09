type location = Lexing.position * Lexing.position

type ident = { loc: location; id: string; }
let print_string_green s = print_string ("\027[32m" ^ s ^ "\027[0m ")
let print_string_red s = print_string ("\027[31m" ^ s ^ "\027[0m ")
let print_string_yellow s = print_string ("\027[33m" ^ s ^ "\027[0m ")
let print_string_blue s = print_string ("\027[34m" ^ s ^ "\027[0m ")
let print_string_magenta s = print_string ("\027[35m" ^ s ^ "\027[0m ")
let print_string_cyan i = print_string ("\027[36m" ^ i ^ "\027[0m ")
let print_int_blue i = print_string ("\027[34m" ^  i ^ "\027[0m ")


type binop = 
  | Badd
  | Bsub
  | Bmul
  | Bdiv
  | Beq
  | Bneq
  | Blt
  | Ble
  | Bgt
  | Bge
  | Band
  | Bor
  | Blte
  | Bgte
  | Bmod
  | Bin
  | Bun
  | Binter
  | Bpow
  | Bcomma
  
type constant =
  | Cstring of string
  | Cint of int
  | Cbool of bool
  | Cnil
  | Cinfinity
  | Cpi
  | CminusInfinity

  
  type expr =
  | Memptyset
  | Elow of expr
  | Ehigh of expr
  | Ebinop of binop * expr * expr
  | Ecst of constant
  | Eident of ident
  | Earray of ident * expr
  | Etable of ident * expr * expr
  | Eset of expr list
  | Einitset of ident * expr list
  | Elength of ident
  | Ematrix of ident * expr * expr
  | Erows of ident
  | Ecolumns of ident
  | Erandom of expr * expr
  | EfunctionCall of ident * expr list
  | Erange of expr * expr
  | Eobject of ident * expr
  | EobjectPI of ident
  | Einitarray of ident * expr  
  | Einittable of ident * expr * expr

type stmt =
  | Sfor of ident * expr * expr * stmt
  | Sford of ident * expr * expr * stmt
  | Sifnest of expr * stmt * stmt
  | Sif of expr * stmt
  | Selseifnest of expr * stmt * stmt
  | Selseif of expr * stmt
  | Selse of stmt
  | Sendif
  | Sprint of expr list
  | SinitArrayList of expr list
  | SinitTableList of expr list
  | Sswap of expr * expr
  | Sexchange of expr * expr
  | Slength of expr
  | Srows of expr
  | Scolumns of expr
  | Swhile of expr * stmt
  | Sinitmatrix of ident * expr * expr
  | Smatrix of ident * expr * expr
  | Sassign of expr * expr
  | Sreturn of expr
  | Sfunc of ident * expr list * stmt
  | SfuncCall of ident * expr list
  | Serror of expr
  | Sblock of stmt list
  | SsortA of expr * expr
  | SsortD of expr * expr
  | Sinsert of expr * expr
  | SinsertAll of expr * expr
  | SinsertRoot of expr * expr 
  

type file = stmt