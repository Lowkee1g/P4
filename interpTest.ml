open Ast
open Format

(* Exception raised to signal a runtime error *)
exception Error of string
let error s = raise (Error s)

(* Values of Mini-Python.

   Two main differences wrt Python:

   - We use here machine integers (OCaml type `int`) while Python
     integers are arbitrary-precision integers (we could use an OCaml
     library for big integers, such as zarith, but we opt for simplicity
     here).

   - What Python calls a ``list'' is a resizeable array. In Mini-Python,
     there is no way to modify the length, so a mere OCaml array can be used.
*)
type value =
  | Vnone
  | Vbool of bool
  | Vint of int
  | Vstring of string
  | Vlist of value array

(* Print a value on standard output *)
let rec print_value = function
  | Vnone -> printf "None"
  | Vbool true -> printf "True"
  | Vbool false -> printf "False"
  | Vint n -> printf "%d" n
  | Vstring s -> printf "%s" s
  | Vlist a -> print_array print_value a
    let n = Array.length a in
    printf "[";
    for i = 0 to n-1 do print_value a.(i); if i < n-1 then printf ", " done;
    printf "]"

(* Boolean interpretation of a value

   In Python, any value can be used as a Boolean: None, the integer 0,
   the empty string, and the empty list are all considered to be
   False, and any other value to be True.
*)
let is_false v =
    match v with
    | None -> true
    | Some x -> 
      match x with
      | Vint 0 -> true
      | Vstring "" -> true
      | Vlist [||] -> true
      | _ -> false 

let is_true v = (*Kan også skrives som "let is_true v = not (is_false v)"*)
    match v with
    | None -> false
    | Some x -> 
      match x with
      | Vint 0 -> false
      | Vstring "" -> false
      | Vlist [||] -> false
      | _ -> true

(*let () = print_value (Vbool (is_true (Some (Vint 0)))) *)





(* Environment *)

(* Environment: a mapping from identifiers to values *)