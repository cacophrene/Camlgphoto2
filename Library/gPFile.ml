(* gPFile.ml - This file is part of the camlgphoto2 library
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

type kind =
  | FT_PREVIEW
  | FT_NORMAL
  | FT_RAW
  | FT_AUDIO
  | FT_EXIF
  | FT_METADATA

external create : unit -> t   = "caml_gp_file_new"
external from_file_descr : Unix.file_descr -> t = "caml_gp_file_new_from_fd"
external load : string -> t = "caml_gp_file_open"

external incr_ref : t -> unit = "caml_gp_file_ref"
external decr_ref : t -> unit = "caml_gp_file_unref"
external destroy : t -> unit = "caml_gp_file_free"

external clean : t -> unit = "caml_gp_file_clean"
external save : t -> string -> unit = "caml_gp_file_save"
external copy : t -> t = "caml_gp_file_copy"

(*external get_kind : t -> kind = "caml_gp_file_get_type"*)
external get_name : t -> string = "caml_gp_file_get_name"
external set_name : t -> string -> unit = "caml_gp_file_set_name"
external get_mime_type : t -> string = "caml_gp_file_get_mime_type"
external set_mime_type : t -> string -> unit = "caml_gp_file_set_mime_type"
external get_mtime : t -> float = "caml_gp_file_get_mtime"
external set_mtime : t -> float -> unit = "caml_gp_file_set_mtime"

(* external get_data : t -> string = "caml_gp_file_get_data_and_size" *)

external detect_mime_type : t -> unit = "caml_gp_file_detect_mime_type"
external adjust_name_for_mime_type : t -> unit 
  = "caml_gp_file_adjust_name_for_mime_type"
