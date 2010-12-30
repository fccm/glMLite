#load "str.cma"

let file_contents filename =
  let b = Buffer.create 8192 in
  let ic = open_in filename in
  try while true do
    let c = input_char ic in
    Buffer.add_char b c;
  done; ""
  with End_of_file ->
    close_in ic;
    (Buffer.contents b)
;;

let () =
  let filename = Sys.argv.(1) in
  let str = file_contents filename in
  let res =
    Str.global_replace (Str.regexp "= struct") ": sig" str
  in
  let oc = open_out filename in
  output_string oc res;
  close_out oc;
;;

(* vim: sw=2 sts=2 ts=2 et fdm=marker
 *)
