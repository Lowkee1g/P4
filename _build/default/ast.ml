type location = Lexing.position * Lexing.position

type ident = {
  loc: location;
  id: string;
}


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
  | Memptyset
  | Blte
  | Bgte
  | Bmod
  | Bin
  | Bun
  | Binter

type constant =
  | Cstring of string
  | Cint of int
  | Cbool of bool
  | Cnil
  | Cinfinity
  | Cpi
  | CminusInfinity

type expr =
  | Ebinop of binop * expr * expr
  | Ecst of constant
  | Eident of ident
  | Earray of ident * expr
  | Elength of ident
  | Ematrix of ident * expr * expr
  | Erows of ident
  | Ecolumns of ident
  | Erandom of expr * expr
  | EfunctionCall of ident * ident list
  | Erange of expr * expr
  | Eobject of ident * expr
  | Einitarray of ident * expr  

type stmt =
  | Sfor of ident * expr * expr * stmt
  | Sford of ident * expr * expr * stmt
  | Sifnest of expr * stmt * stmt
  | Sif of expr * stmt
  | Selseifnest of expr * stmt * stmt
  | Selseif of expr * stmt
  | Selse of stmt
  | Sendif
  | Sprint of expr
  | SinitArrayList of expr list
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
  | Sfunc of ident * ident list * stmt 
  | Serror of expr
  | Sblock of stmt list
  | SsortA of expr * expr
  | SsortD of expr * expr
  | Sinsert of expr * expr
  | SinsertAll of expr * expr
  | SinsertRoot of expr * expr 
  

type file = stmt