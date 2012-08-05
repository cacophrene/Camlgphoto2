(* gPMain.mli - This file is part of the camlgphoto2 library
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

(** Main module. *)

type supported_models
(** List of supported camera models including their abilities. *)

val lib_version : verbose:bool -> string array
(** Returns libgphoto2 version information in normal or verbose mode. *)


(** {2 Loading} *)

val load : GPContext.t -> supported_models
(** Scans the system for camera drivers. All supported camera models will then
  * be added to the list. *)
  
val destroy : supported_models -> unit
(** Frees the list of supported camera models. *)


(** {2 Informations} *)
  
val count : supported_models -> int
(** Count the entries in the supplied list. *)

val is_supported : supported_models -> model:string -> bool
(** @return [true] if the given camera model is supported, [false] otherwise. *)


(** {2 Access to cameras} *)

val detect : supported_models -> GPContext.t -> (string * GPPortInfo.t) list
(** Tries to detect any camera connected to the computer using the supplied
  * list of supported cameras.
  * @return the list of couples of the form [(camera model, port)]. *)

val get_abilities : supported_models -> model:string -> GPAbilities.t
(** @return the abilities of the given camera model.
  * @raise Not_found if the camera model is not supported. *)
