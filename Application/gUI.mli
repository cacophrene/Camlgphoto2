(* gUI.mli - This file is part of camlgphoto2 software. *)

val main_window : GWindow.window
(** Main window. *)

val width : int
(** Width of the preview area (in pixels). *)
val height : int
(** Height of the preview area (in pixels). *)

val zoom_size : int
(** Length (in pixels) of the side of the zoom square. *)

val events : GBin.event_box
(** Events manager. *)

val image : GMisc.image
(** Preview image. *)

val live_view : GButton.toggle_button
(** Switch on/off LiveView mode. *)

val take_shot : GButton.button
(** Take a shot. *)

val show_zoom : GButton.toggle_button

val status : GMisc.statusbar
val set_preview_time : float -> unit
val set_camera_model : string -> unit
val set_lens_name : GPWidget.t -> unit -> unit

val toolbox : GWindow.window
(** Settings. *)

val add_section : string -> unit -> unit
(** Add section. *)

val add_config :
  label:string -> 
  current:string -> 
  (string * int) list -> 
  (string -> unit) -> (unit -> unit) -> unit
(** *)
