(* param.ml - This file is part of camlgphoto2_test.linux *)

open Arg

let output_dir = ref (Printf.sprintf "%s/Images/Camlgphoto2 Pictures" (Sys.getenv "HOME"))
let fname_patt = ref (Scanf.format_from_string "IMG%04d.JPG" "%d")
let frame_rate = ref 100

let validate s = try fname_patt := Scanf.format_from_string s "%d" with _ -> ()

let set_output_dir x = (x, Set_string output_dir, " Set output directory")
let set_fname_patt x = (x, String validate, " Set filename format")
let set_frame_rate x = (x, Set_int frame_rate, " Set frame rate (ms)")

let cmdline_args = align [
  set_output_dir "-o";
  set_fname_patt "-f";
  set_frame_rate "-r";
  set_output_dir "--output-directory";
  set_fname_patt "--filename-format";
  set_frame_rate "--frame-rate" ]

let init () = parse cmdline_args ignore "Usage: camlgphoto2 [OPTIONS]"
