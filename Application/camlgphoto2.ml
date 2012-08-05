(* camlgphoto2.ml - This file is part of camlgphoto2 software. *)

open Printf
open GPWidget

let _ = ksprintf GUI.main_window#set_title "CamlGPhoto2 (%s)" (Sys.getcwd ())

let radios = [
  "/main/imgsettings/imageformat"              ;
  "/main/capturesettings/picturestyle"         ;
  "/main/capturesettings/drivemode"            ;
  "/main/imgsettings/iso"                      ;
  "/main/capturesettings/exposurecompensation" ;
  "/main/imgsettings/whitebalance"             ;
  "/main/capturesettings/shutterspeed"         ;
  "/main/capturesettings/meteringmode"         ;
  "/main/capturesettings/aperture"             ;
  "/main/imgsettings/colorspace"               ;
  "/main/capturesettings/aeb"                  ;
]

let print_widgets cam context =
  let config = GPCamera.get_config cam context in
  let rec loop str actions = function
    | [] -> actions
    | w :: widgs -> let str' = Filename.concat str (get_name w) in
      printf "%s%s\n%!" str' (if GPWidget.is_read_only w then " (read-only)" else "");
      if is_parent w then begin
        let actions' = 
          if str' = "/main/imgsettings" || str' = "/main/capturesettings" then
          GUI.add_section (GPWidget.get_label w) :: actions
          else actions
        in loop str (loop str' actions' (GPWidget.get_children w)) widgs
      end else match get_type w with
        | GP_WIDGET_RADIO when not (GPWidget.is_read_only w) && List.mem str' radios ->
          let action () = 
            let current = GPWidget.string_of_value (GPWidget.get_value w)
            and choices = GPWidget.get_choices w in
            GUI.add_config ~label:(GPWidget.get_label w) ~current choices 
              (fun s -> GPWidget.set_value w (GP_VALUE_STRING s)) 
              (fun () -> GPCamera.set_config cam context config) 
          in loop str (action :: actions) widgs
        | GP_WIDGET_TEXT when str' = "/main/status/lensname" ->
          loop str (GUI.set_lens_name w :: actions) widgs
        | _ -> loop str actions widgs
  in List.iter (fun f -> f ()) (List.rev (loop "/" [] [config]))

(* 21/07/2012: we can choose between all available models. *)
let choose_camera = function
  | [model] -> Some model
  | model_list ->
    let dialog = GWindow.dialog 
      ~title:"camlgphoto2"
      ~position:`CENTER_ON_PARENT
      ~border_width:5
      ~resizable:false
      ~parent:GUI.main_window
      ~destroy_with_parent:true () in
    dialog#vbox#set_spacing 5;
    dialog#add_button_stock `CANCEL `CANCEL;
    dialog#add_button_stock `APPLY `APPLY;
    GMisc.label
      ~xalign:0.
      ~markup:"<b>Choose a camera :</b>"
      ~packing:(dialog#vbox#pack ~expand:false) ();
    let combo = GEdit.combo_box_text 
      ~strings:(List.map fst model_list) 
      ~active:0 
      ~packing:dialog#vbox#add () in
    let opt = match dialog#run () with
      | `CANCEL -> printf "No camera selected!\n"; None
      | _ -> match GEdit.text_combo_get_active combo with
        | None -> None
        | Some name -> 
          try Some (List.find (fun (x, _) -> x = name) model_list) with _ -> None
    in dialog#destroy ();
    opt

let unique t =
  let h = Hashtbl.create 7 in
  List.iter (fun x -> Hashtbl.replace h (fst x) x) t;
  let t = Hashtbl.fold (fun _ x r -> x :: r) h [] in
  List.sort compare t

(* 31/07/12 an error message is displayed when no camera is available. *)
let failure message =
  let dialog = GWindow.message_dialog
    ~title:"CamlGPhoto2"
    ~message
    ~message_type:`ERROR
    ~use_markup:true
    ~buttons:GWindow.Buttons.close
    ~parent:GUI.main_window
    ~destroy_with_parent:true
    ~position:`CENTER_ON_PARENT () in
  dialog#connect#close GMain.quit;
  ignore (dialog#run ())

let initialize models context =
  match GPMain.detect models context with
  | [] -> failure "<big><b>No camera available!</b></big>\n\nPlease make sure that \
      your camera is connected to the computer and not locked by another \
      application."; None
  | all -> match choose_camera (unique all) with
    | None -> None
    | Some (model, port_info) -> let open GPCamera in
      let camera = create () in
      GUI.set_camera_model model;
      print_widgets camera context;
      let abilities = GPMain.get_abilities ~model models in
      GPMain.destroy models;
      set_abilities camera abilities;
      set_port_info camera port_info;
      init camera;
      Some camera

let _ =
  Param.init ();
  let main () =
    Printexc.record_backtrace true;
    let context = GPContext.create () in
    let models = GPMain.load context in
    Gaux.may (fun cam ->
      let open GUI in
      main_window#connect#destroy (Action.close_application cam models context);
      live_view#connect#toggled (Action.may_preview cam context);
      take_shot#connect#clicked (Action.get_picture cam context);
      live_view#set_active true;
      toolbox#show ();
      main_window#show ();
      GMain.main ()
    ) (initialize models context) in
  try main () with exn ->
    ksprintf failure "<big><b>Oops... something went wrong!</b></big>\n\n\
      CamlGPhoto2 cannot handle this unexpected event.\n\
      Please include the following backtrace in your bug report.\n\n\
      <small><b>%s</b>\n%s</small>"
      (Printexc.to_string exn) (Printexc.get_backtrace ())
