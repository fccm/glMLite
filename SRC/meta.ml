
let clip_slice ?(first=0) ?(last=Sys.max_string_length) s =
  let clip _min _max x = max _min (min _max x)
  and len = String.length s in
  let i = clip 0 len (if (first<0) then len + first else first)
  and j = clip 0 len (if (last<0) then len + last else last)
  in
  if i>=j || i=len
  then String.create 0
  else String.sub s i (j-i)
;;

exception Invalid_string

let find_from str sub pos =
  let len = String.length str
  and sublen = String.length sub in
  if pos >= (len - sublen) then
    raise Invalid_string;
  if sublen = 0 then
    0
  else
    let found = ref 0 in
    try 
      for i = pos to (len - sublen) do
        let j = ref 0 in 
        while String.unsafe_get str (i + !j) = String.unsafe_get sub !j do
          incr j;
          if !j = sublen then begin found := i; raise Exit; end;
        done;
      done;
      raise Invalid_string
    with
      Exit -> !found
;;

let replace_all ~str ~sub ~by =
  let sublen = String.length sub in
  try 
    if sublen = 0 then
      raise Invalid_string;
    let strlen = String.length str in
    let rec find_pos acc pos =
      try
        let i = find_from str sub pos in
        find_pos ((i + sublen)::i::acc) (i + sublen)
      with
        Invalid_string -> (strlen::acc)
    in  
    let all_pos = (find_pos [0] 0) in
    if List.length all_pos = 2 then
      raise Invalid_string;
      
    let rec make_slices acc = function
      | [] -> acc
      | _::[] -> assert(false)
      | last::first::tl ->
          let this = clip_slice ~first ~last str in
          make_slices (this::acc) tl
    in
    let slices = make_slices [] all_pos in

    let res = String.concat by slices in
    (res)
  with
    Invalid_string -> (str)
;;

let file_contents ~filename =
  let ic = open_in filename
  and buf = Buffer.create 4096 in
  let rec aux () =
    try
      let line = input_line ic in
      Buffer.add_string buf line;
      Buffer.add_char buf '\n';
      aux()
    with End_of_file ->
      close_in ic;
      (Buffer.contents buf)
  in
  aux()
;;


(* main *)
let () =
  let argv = List.tl(Array.to_list Sys.argv) in
  let in_file =
    try List.find Sys.file_exists argv
    with Not_found -> failwith "no input file"
  in
  let link_libs =
    let rec aux acc = function
      | "-GL_LIBS" :: libs :: tl ->
          aux (("GL_LIBS",libs)::acc) tl

      | "-GLU_LIBS" :: libs :: tl ->
          aux (("GLU_LIBS",libs)::acc) tl

      | "-GLUT_LIBS" :: libs :: tl ->
          aux (("GLUT_LIBS",libs)::acc) tl

      | _ :: tl -> aux acc tl
      | [] -> acc
    in
    aux [] argv
  in
  let meta_in = file_contents ~filename:in_file in
  let meta =
    List.fold_left
      (fun str (sub, by) -> replace_all ~str ~sub ~by)
      meta_in
      link_libs
  in
  print_string meta;
;;

(* vim: sw=2 sts=2 ts=2 et fdm=marker
 *)
