#load "str.cma" ;;


let input_lines ~filename =
  let rec input_loop ic acc =
    try
      let line = input_line ic in
      match line with
      | "" -> input_loop ic acc
      | _ -> input_loop ic (line::acc)
    with
      End_of_file -> close_in ic; (acc)
  in
  let ic = open_in filename in
  input_loop ic []
;;


let map_input line =
  let str_split = Str.split (Str.regexp "[\t]+") line in
  match str_split with
  | ite::lbl::[] -> (ite, lbl)
  | _ -> failwith line
;;


let rec output_loop rev = function [] -> ()
  | (ite_f, lbl_f) :: tail ->
      let fa, fb = rev lbl_f ite_f in
      Printf.printf "  -e 's|%s|%s|g' \\\n" fa fb;
      output_loop rev tail
;;


let check_arg() =
  if Array.length Sys.argv >= 2 && Sys.argv.(1) = "-rev"
  then (fun a b -> b, a)
  else (fun a b -> a, b)
;;


let () =
  let ln = input_lines "LablGL_to_glMLite.tab" in
  let pl = List.rev_map map_input ln in
  print_endline "sed  \\";
  let may_rev = check_arg() in
  output_loop may_rev pl;
  print_endline "  $1";
  print_endline "#EOF";
;;


