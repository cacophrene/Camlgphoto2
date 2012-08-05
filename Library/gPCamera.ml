(* gPCamera.ml - This file is part of the camlgphoto2 library
 *
 * Copyright (C) 2010 Edouard Evangelisti
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful, 
 * but WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details. 
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 *)

type t

external create : unit -> t = "caml_gp_camera_new"
external destroy : t -> unit = "caml_gp_camera_free"

external get_abilities : t -> GPAbilities.t = "caml_gp_camera_get_abilities"
external set_abilities : t -> GPAbilities.t -> unit
  = "caml_gp_camera_set_abilities"
external get_port_info : t -> GPPortInfo.t = "caml_gp_camera_set_port_info"
external set_port_info : t -> GPPortInfo.t -> unit 
  = "caml_gp_camera_set_port_info"

external init : t -> unit = "caml_gp_camera_init"
external exit : t -> unit = "caml_gp_camera_exit"

external get_summary : t -> GPContext.t -> string = "caml_gp_camera_get_summary"
external get_manual : t -> GPContext.t -> string = "caml_gp_camera_get_manual"
external get_about : t -> GPContext.t -> string = "caml_gp_camera_get_about"

external get_config : t -> GPContext.t -> GPWidget.t 
  = "caml_gp_camera_get_config"
external set_config : t -> GPContext.t -> GPWidget.t -> unit 
  = "caml_gp_camera_set_config"

external incr_ref : t -> unit = "caml_gp_camera_ref"
external decr_ref : t -> unit = "caml_gp_camera_unref"

type capture_type = 
  | GP_CAPTURE_IMAGE
  | GP_CAPTURE_MOVIE
  | GP_CAPTURE_SOUND

external raw_capture : t -> capture_type -> GPContext.t -> string * string
  = "caml_gp_camera_capture"

let capture camera capture_type context =
  raw_capture camera capture_type context

external capture_preview  : t -> GPContext.t -> GPFile.t 
  = "caml_gp_camera_capture_preview"

type capture_event =
  | GP_EVENT_UNKNOWN
  | GP_EVENT_TIMEOUT
  | GP_EVENT_FILE_ADDED
  | GP_EVENT_FOLDER_ADDED
  | GP_EVENT_CAPTURE_COMPLETE

(* 28/01/12 load/remove files from camera *)
external get_file : t -> string -> string -> GPFileInfo.file_type -> 
  GPContext.t -> GPFile.t = "caml_gp_camera_file_get"

external delete_file : t -> string -> string -> GPContext.t -> unit
  = "caml_gp_camera_file_delete"

external get_info : t -> string -> string -> GPContext.t -> GPFileInfo.t
  = "caml_gp_camera_file_get_info"


