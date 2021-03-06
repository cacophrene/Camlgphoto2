(* gUI.ml - This file is part of camlgphoto2 software. *)

open Printf

let _ = GMain.init ()

(* Here it is assumed that the ratio between the length and the width of 
 * pictures is equal to 3/2. Please note that some cameras may use different
 * ratios such as 4/3, but this is uncommon with DSLR cameras. *)
let width = 720 and height = 480
let zoom_size = 200

let main_window = GWindow.window
  ~title:"Camlgphoto2 1.0"
  ~position:`CENTER
  ~resizable:false () 

let vbox = GPack.vbox 
  ~border_width:5 
  ~spacing:5
  ~packing:main_window#add ()

let events, image =
  let events = GBin.event_box 
    ~packing:(vbox#pack ~expand:false) () in
  events#event#add [`POINTER_MOTION; `BUTTON_PRESS];
  let image = GMisc.image ~width ~height ~packing:events#add () in
  events, image 

let bbox = GPack.button_box `HORIZONTAL
  ~layout:`SPREAD
  ~packing:vbox#add ()
let packing = bbox#add

let take_shot = GButton.button ~label:"Cheese !" ~packing () 
let live_view = GButton.toggle_button ~label:"LiveView" ~packing ()
let show_zoom = GButton.toggle_button ~label:"Zoom area" ~packing ()

let status = 
  let status = GMisc.statusbar
    ~has_resize_grip:false
    ~packing:(vbox#pack ~expand:false) () in
  status#set_spacing 5;
  status
let packing = status#pack ~expand:false

let library = 
  let lib = GPMain.lib_version ~verbose:false in 
  GMisc.label
    ~markup:(sprintf "<small><tt>libgphoto2 %s</tt></small>" lib.(0))
    ~packing ()

let _ = GMisc.separator `VERTICAL ~packing ()

let camera = GMisc.label
  ~markup:"<small><tt>...</tt></small>"
  ~packing ()
  
let set_camera_model = 
  ksprintf camera#set_label "<small><tt>%s</tt></small>"

let _ = GMisc.separator `VERTICAL ~packing ()

let lens_name = GMisc.label
  ~markup:"<small><tt>...</tt></small>"
  ~packing ()

let set_lens_name w () =
  let s = GPWidget.string_of_value (GPWidget.get_value w) in
  ksprintf lens_name#set_label "<small><tt>%s</tt></small>" 
    (if String.length s = 0 then "(no lens)" else s)

let _ = GMisc.separator `VERTICAL ~packing ()

let preview_time = GMisc.label 
  ~markup:"<small><tt>Preview: 0.000 s</tt></small>"
  ~packing ()

let set_preview_time = 
  ksprintf preview_time#set_label "<small><tt>Preview: %.3f s</tt></small>"

let _ = GMisc.separator `VERTICAL ~packing ()

let see_coord = GMisc.label
  ~markup:"<small><tt>(000, 000)</tt></small>" 
  ~packing ()

let set_cursor_pos ev =
  let x = GdkEvent.Motion.x ev and y = GdkEvent.Motion.y ev in
  ksprintf see_coord#set_label "<small><tt>(%.3d, %.3d)</tt></small>" 
    (truncate x) (truncate y);
  false

let _ = events#event#connect#motion_notify ~callback:set_cursor_pos


let toolbox = 
  let wnd = GWindow.window
    ~title:"Settings"
    ~resizable:false
    ~type_hint:`UTILITY () in
  main_window#connect#destroy wnd#destroy;
  wnd#event#connect#delete (fun _ -> true);
  wnd

let table = GPack.table
  ~row_spacings:5 ~col_spacings:5 
  ~border_width:5 ~homogeneous:true
  ~packing:toolbox#add ()

let row = ref (-1)

let add_section text () =
  incr row;
  GMisc.label ~xalign:0. ~text 
    ~packing:(table#attach ~left:0 ~top:!row ~right:2) ();
  ()

let add_config ~label ~current choices f g =
  incr row;
  GMisc.label 
    ~xalign:0. ~xpad:15
    ~markup:(sprintf "<small><b>%s</b></small>" label) 
    ~packing:(table#attach ~left:0 ~top:!row) ();
  let combo, _ as text_combo = GEdit.combo_box_text
    ~use_markup:true
    ~strings:(List.map (sprintf "<small>%s</small>") (fst (List.split choices)))
    ~active:(List.assoc current choices)
    ~packing:(table#attach ~left:1 ~top:!row) () in
  combo#connect#changed ~callback:(fun () ->
    Gaux.may (fun s ->
      Scanf.sscanf s "<small>%[^<]</small>" f;
      g ()
    ) (GEdit.text_combo_get_active text_combo));
  ()
