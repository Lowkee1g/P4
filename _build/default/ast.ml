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
  
  type stmt =
  | Sfor of ident * expr * expr
  | Sif of expr * stmt
  | Sprint of expr
