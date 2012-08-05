(* action.ml - This file is part of camlgphoto2 software. *)

open Printf
open GPCamera

(* Do we need to delete something else? *)
let close_application camera models context () =
  GPCamera.destroy camera;
  GPContext.decr_ref context;
  GMain.quit ()

let get_picture cam context () =
  let dir, name = capture cam GP_CAPTURE_IMAGE context in
  let this = get_file cam dir name GPFileInfo.GP_FILE_TYPE_NORMAL context in
  delete_file cam dir name context;
  GPFile.save this (Filename.concat !Param.output_dir name);
  GPFile.destroy this;
  printf "File %S saved to the computer\n%!" name

let preview = Filename.concat !(Param.output_dir) "preview.jpg"

let interp = `HYPER
let area = ref 70
let zoom = ref 3

let get_zoom_size () = !area * !zoom

(* 31/07/12 Determine the coordinates of the upper left corner 
 * of the magnified picture. *)
let get_dest_x () = (GUI.width - get_zoom_size ()) lsr 1
let get_dest_y () = (GUI.height - get_zoom_size ()) lsr 1

let get_offs_x () = float (- get_dest_x ())
let get_offs_y () = float (- get_dest_y ())

let get_preview camera context () =
  begin try
    let x = Unix.gettimeofday () in
    let file = GPCamera.capture_preview camera context in
    GPFile.save file preview;
    GPFile.destroy file;
    let pixbuf = GdkPixbuf.from_file_at_size 
      ~width:GUI.width 
      ~height:GUI.height preview in
    GUI.image#set_pixbuf (GdkPixbuf.copy pixbuf);
    if GUI.show_zoom#active then begin
      GdkPixbuf.scale
        ~dest:GUI.image#pixbuf
        ~dest_x:(get_dest_x ()) ~dest_y:(get_dest_y ())
        ~width:(get_zoom_size ()) ~height:(get_zoom_size ())
        ~scale_x:(float !zoom) ~scale_y:(float !zoom)
        ~ofs_x:(float (!zoom * (!area - GUI.width lsr 1)))
        ~ofs_y:(float (!zoom * (!area - GUI.height lsr 1)))
        ~interp:`HYPER pixbuf;
    end;
    let y = Unix.gettimeofday () in
    GUI.set_preview_time (y -. x)
  with _ -> () end;
  GUI.live_view#active

let may_preview cam context () =
  if GUI.live_view#active then ignore (Glib.Timeout.add 
    ~ms:!(Param.frame_rate)
    ~callback:(get_preview cam context))
