open List

open Format
open Lexing
open Parser
open Interp

let usage = "usage: mini-python [options] file.txt"

let parse_only = ref false

let spec =
  [
    "--parse-only", Arg.Set parse_only, "  stop after parsing";
  ]

let file =
  let file = ref None in
  let set_file s =
    if not (Filename.check_suffix s ".txt") then
      raise (Arg.Bad "no .txt extension");
    file := Some s
  in
  Arg.parse spec set_file usage;
  match !file with Some f -> f | None -> Arg.usage spec usage; exit 1

let report (b,e) =
  let l = b.pos_lnum in
  let fc = b.pos_cnum - b.pos_bol + 1 in
  let lc = e.pos_cnum - b.pos_bol + 1 in
  eprintf "File \"%s\", line %d, characters %d-%d:\n" file l fc lc


let () =
let filename = "for.txt" in
let channel = open_in filename in
let lexbuf = Lexing.from_channel channel in
try
  let ast_list = Parser.file Lexer.next_token lexbuf in
  let result_string = interpret ast_list 0 in
  close_in channel;
  let out_channel = open_out "for_result.py" in
  Printf.fprintf out_channel "%s\n" result_string;
    close_out out_channel;
    printf "Successfully interpreted and wrote the result to for_result.txt\n"
with
| Sys_error msg ->
    printf "Error: %s\n" msg
| Lexer.Lexing_error msg ->
    printf "Lexer error: %s\n" msg
| Parser.Error ->
  report (lexeme_start_p lexbuf, lexeme_end_p lexbuf);
  eprintf "(parser) - syntax error@.";
  exit 1
| End_of_file ->
    printf "End of file\n"
