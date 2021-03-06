(* action.mli - This file is part of camlgphoto2_test.linux *)

val close_application : 
  GPCamera.t -> 
  GPMain.supported_models -> 
  GPContext.t -> unit -> unit
(** Close application. *)

val preview : string

val get_picture : GPCamera.t -> GPContext.t -> unit -> unit
(** Capture full resolution picture. *)

val may_preview : GPCamera.t -> GPContext.t -> unit -> unit
(** Capture quick preview when [GUI.preview] is toggled. *)
