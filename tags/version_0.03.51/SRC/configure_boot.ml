
external conf_main: unit -> string list * string list = "conf_main"

let () = 
  let versions, extensions = conf_main () in
  let version =
    List.fold_left
      (fun greater this ->
         if String.compare greater this > 0 then greater else this
      ) "GL_VERSION_0_0" versions
  in
  let argv = Array.to_list Sys.argv in
  if List.mem "--gl-version" argv then
    print_string version;
;;

