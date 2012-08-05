(* gPFile.mli - This file is part of the camlgphoto2 library
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
(** Camera file-related functions. *)

type t
(** The type of camera files. *)

type kind =
  | FT_PREVIEW    (** A preview of an image.                                  *)
  | FT_NORMAL     (** The regular normal data of a file.                      *)
  | FT_RAW        (** The raw mode of a file (usually not for modern DSLRs).  *)
  | FT_AUDIO      (** The audio view of a file.                               *)
  | FT_EXIF       (** The embedded EXIF data of an image.                     *)
  | FT_METADATA   (** The metadata of a file.                                 *)
(** Specifies the kind of the current file, usually passed to the [get] and 
  * [put] functions. This is useful for multiple views of one file, like that an
  * single image file has "raw", "normal", "exif" and "preview" views, or a 
  * media file has "normal" and "metadata" file views. *)



(** {2 Creating, copying and saving files} *)

val create : unit -> t
(** Creates a new camera file. *)

val from_file_descr : Unix.file_descr -> t
(** Creates a new camera file from the given file descriptor. *)

val load : string -> t
(** Loads the given camera file.
  * Warning: the current implementation does not restrict the range of loadable
  * files. Please make sure that you are loading pictures! *)

val clean : t -> unit
(** Frees the camera file components, not the file itself, preparing it for 
  * being filled with new data. *)
val copy : t -> t
(** Returns a copy of the given camera file. *)
val save : t -> string -> unit
(** [saves caf name] saves camera file [caf] as [name]. *)



(** {2 Getters/setters} 
  * Warning: libgphoto2 developers said these functions will be removed in the 
  * future. *)

val get_name : t -> string
(** @return the camera file name. *)
val set_name : t -> string -> unit
(** Changes the camera file name. *)

val get_mime_type : t -> string
(** @return the camera file MIME type. *)
val set_mime_type : t -> string -> unit
(** Changes the camera file mime type. *)

val get_mtime : t -> float
(** @return the camera file modification time. *)
val set_mtime : t -> float -> unit
(** Changes the camera file modification time. *)

val detect_mime_type : t -> unit
(** Look for camera file mime type. *)
val adjust_name_for_mime_type : t -> unit
(** Adjusts the camera file name to fit its actual MIME type. *)

(* val get_data : t -> string *)

(*val get_kind : t -> kind
(** @return the type of the given camera file. *)*)

 
(** {2 Reference counting} *)

val incr_ref : t -> unit
(** Increments the reference count of the camera file. *)

val decr_ref : t -> unit
(** Decrements the reference count of the camera file. *)

val destroy : t -> unit
(** Destroys the given camera file.
  * Do not reuse the given value after calling this function! *)
