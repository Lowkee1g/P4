type location = Lexing.position * Lexing.position

type ident = { loc: location; id: string; }


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


type constant =
  | Cstring of string
  | Cint of int
  | Cbool of bool
  | Cnil
  | Cinfinity
  | CminusInfinity

type expr =
  | Ebinop of binop * expr * expr
  | Ecst of constant
  | Eident of ident
  | Earray of ident * expr
  | Elength of expr
  | Ematrix of ident * expr * expr
  | Erows of expr
  | Ecolumns of expr
  | Erandom of expr * expr
  | EfunctionCall of ident * ident list
  | Erange of expr * expr
  

type stmt =
  | Sfor of ident * expr * expr * stmt
  | Sford of ident * expr * expr * stmt
  | Sif of expr * stmt * stmt
  | Selseif  of expr * stmt * stmt
  | Selse of stmt
  | Sendif
  | Sprint of expr
  | Sarray of ident * expr
  | Sinitarray of ident * expr
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
  | Sfunc of ident list * ident list * stmt 
  | Serror of expr
  | Sblock of stmt list
  | SsortA of expr * expr
  | SsortD of expr * expr
  | Sinsert of expr * expr
  | SinsertAll of expr * expr
  | SinsertRoot of expr * expr 
  

type file = stmt