open List
open Format
open Lexing
open Parser
open Interp

let usage = "usage: mini-python [options] <file.txt>"

let parse_only = ref false
let silent = ref false

let spec = [
  "--parse-only", Arg.Set parse_only, " stop after parsing";
  "-silent", Arg.Set silent, "Supress output";
]

let file = ref None

let set_file s =
  if not (Filename.check_suffix s ".txt") then
    raise (Arg.Bad "no .txt extension");
  file := Some s

let () =
  Arg.parse spec set_file usage; 
    (* (fun x -> raise (Arg.Bad ("Bad argument : " ^ x)))
    "Usage: -silent to suppress output"; *)
  match !file with
  | None ->
    eprintf "No file provided\n";
    exit 1
  | Some filename -> 
    let channel = open_in filename in
    let lexbuf = Lexing.from_channel channel in
    try
      let ast_list = Parser.file Lexer.next_token lexbuf in
      let result_string = interpret ast_list 0 in
      close_in channel;
      let out_channel = open_out (Filename.remove_extension filename ^ "_result.py") in
      if filename = "for.txt" then
        Printf.fprintf out_channel "from Array import Array"
      else if filename = "fortest.txt" then
        Printf.fprintf out_channel "from Array import Array"
      else 
        Printf.fprintf out_channel "import sys\n";
        Printf.fprintf out_channel "sys.path.append('../../')\n";
        Printf.fprintf out_channel "from Array import Array\n\n";
        
        
      Printf.fprintf out_channel "%s\n" result_string;
      close_out out_channel;
      printf "Successfully interpreted and wrote the result to %s_result.txt\n" (Filename.remove_extension filename)
    with
    | Sys_error message ->
        printf "Error: %s\n" message
    | Lexer.Lexing_error message ->
        printf "Lexer error: %s\n" message
    | Parser.Error ->
        let (beginError, endError) = (lexeme_start_p lexbuf, lexeme_end_p lexbuf) in
        let line = beginError.pos_lnum in
        let firstChar = beginError.pos_cnum - beginError.pos_bol + 1 in
        let lastChar = endError.pos_cnum - beginError.pos_bol + 1 in
        eprintf "File \"%s\", line %d, characters %d-%d:\n" filename line firstChar lastChar;
        eprintf "(parser) - syntax error@.";
        exit 1
    | End_of_file ->
        printf "End of file\n"
