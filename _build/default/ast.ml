type location = Lexing.position * Lexing.position

type ident = { loc: location; id: string; }


type constant =
  | Cnone
  | Cstring of string
  | Cint of int
  | Cbool of bool

type expr =
  | Ecst of constant
  | Eident of ident
  
type stmt =
  | Sfor of ident * expr * expr * stmt
  | Sprint of expr
  | Sblock of stmt list
  

type file = stmt