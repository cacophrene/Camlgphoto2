(* param.mli - This file is part of camlgphoto2_test.linux *)

val init : unit -> unit

val output_dir : string ref

val fname_patt : 
  (int -> string, unit, string, string, string, string) format6 ref
  
val frame_rate : int ref

