#load "str.cma"

let file_contents filename =
  let ic = open_in filename in
  let buf = Buffer.create 16384
  and tmp = String.create 4096 in
  let rec aux() =
    let bytes = input ic tmp 0 4096 in
    if bytes > 0 then begin
      Buffer.add_substring buf tmp 0 bytes;
      aux()
    end
  in
  (try aux() with End_of_file -> ());
  close_in ic;
  (Buffer.contents buf)
;;

let () =
  let cont = file_contents Sys.argv.(1) in
  let v = Str.split (Str.regexp_string ".") Sys.argv.(2) in
  let v = List.map int_of_string v in
  let major, minor, micro = match v with [a;b;c] -> (a,b,c) | _ -> assert false in

  let reg = Str.regexp_string "let glmlite_version = (0,0,0)"
  and templ = Printf.sprintf "let glmlite_version = (%d,%d,%d)" major minor micro in
  let res = Str.global_replace reg templ cont in
  let oc = open_out Sys.argv.(1) in
  output_string oc res;
  close_out oc;
;;

