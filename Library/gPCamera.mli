(* gPCamera.mli - This file is part of the camlgphoto2 library
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
(** The type of camera. *)

val create : unit -> t
(** Create a new camera device. *)

val destroy : t -> unit
(** Destroys the camera. *)


(** {2 Camera initialization} *)

val get_abilities:  t -> GPAbilities.t
(** @return the abilities of the given camera. *)

val set_abilities : t -> GPAbilities.t -> unit
(** Prepares initialization by setting camera abilities. *)

val get_port_info : t -> GPPortInfo.t
(** @return the port info of the given camera. *)

val set_port_info : t -> GPPortInfo.t -> unit
(** Prepares initialization by setting camera port info. *)

val init : t -> unit
(** Initiates a connection to the camera. Before calling this function, the
  * camera should be set up using [set_port_info] and [set_abilities]. If that 
  * has been omitted, the library will try to autodetect any cameras and chooses
  * the first one by default. *)

val exit : t -> unit
(** Closes connection to camera. It is recommended that you call this function 
  * when you currently don't need the camera. The camera will get automatically
  * reinitialized by [init] if you try to access it again. *)


(** {2 Camera informations} *)

val get_about : t -> GPContext.t -> string
(** Retrieves information about the camera driver. Typically, this information 
  * contains name and address of the author, acknowledgements, etc. *)

val get_manual : t -> GPContext.t -> string
(** Retrieves the manual for given camera. This manual typically contains
  * information about using the camera. *)

val get_summary : t -> GPContext.t -> string
(** Retrieves a camera summary. This summary typically contains information like
  * manufacturer, pictures taken, or generally information that is not
  * configurable. *)


(** {2 Configuration} *)

val get_config : t -> GPContext.t -> GPWidget.t
(** Retrieves the configuration window of the given camera. *)

val set_config : t -> GPContext.t -> GPWidget.t -> unit
(** Sets the configuration of the given camera. *)



(** {2 Capture functions} *)

val capture_preview : t -> GPContext.t -> GPFile.t
(** Captures a preview that won't be stored on the camera but returned as the
  * result of the evaluation. *)

type capture_type = 
  | GP_CAPTURE_IMAGE    (** Capture an image. *)
  | GP_CAPTURE_MOVIE    (** Capture a movie.  *)
  | GP_CAPTURE_SOUND    (** Capture audio.    *)
(** Specifies the type of capture the user wants to do. *)

val capture : t -> capture_type -> GPContext.t -> string * string
(** Captures an image, movie or sound clip depending on the given capture type. 
  * @return the [(folder, name)] of the captured item. *)

type capture_event =
  | GP_EVENT_UNKNOWN              (** Unknown and unhandled event. *)
  | GP_EVENT_TIMEOUT              (** Timeout, no arguments.       *)
  | GP_EVENT_FILE_ADDED           (** Fichier ajouté.              *)
  | GP_EVENT_FOLDER_ADDED         (** Dossier ajouté.              *)
  | GP_EVENT_CAPTURE_COMPLETE     (** Last capture is complete.    *)
(** Specify what event we received from the camera. *)


(* 28/01/12 added operations on files *)
(** {2 Operations on files} *)
 
val get_file : t -> string -> string -> GPFileInfo.file_type -> 
  GPContext.t -> GPFile.t
(** Retrieve a file stored in the camera. *)

val delete_file : t -> string -> string -> GPContext.t -> unit
(** Delete a file from the camera. *)

val get_info : t -> string -> string -> GPContext.t -> GPFileInfo.t
(** Get file infos. *)


(** {2 Reference counting}
  These functions are needed for memory management. *)

val incr_ref : t -> unit
(** Increments the reference count of the camera. *)

val decr_ref : t -> unit
(** Decrements the reference count of the camera. *)
