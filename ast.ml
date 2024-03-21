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
  | Cnone
  | Cstring of string
  | Cint of int
  | Cbool of bool

type expr =
  | Ebinop of binop * expr * expr
  | Ecst of constant
  | Eident of ident
  | Earray of ident * expr
  | Elength of expr
  | Ematrix of ident * expr * expr
  | Erows of expr
  | Ecolumns of expr
  
type stmt =
  | Sfor of ident * expr * expr
  | Sford of ident * expr * expr
  | Sif of expr * stmt list
  | Sprint of expr
  | Sarray of ident * expr
  | Sswap of expr * expr
  | Slength of expr
  | Srows of expr
  | Scolumns of expr
  | Swhile of expr * stmt list
  | Sinitmatrix of ident * expr * expr
  | Smatrix of ident * expr * expr
  | Sassign of expr * expr
  | Sreturn of expr
  



