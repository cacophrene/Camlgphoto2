(* gPWidget.mli - This file is part of the camlgphoto2 library
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

(** Camera widgets. *)

type t
(** The type of camera widgets. *)

type widget_id
(** The type of camera widget unique id. *)

type widget_name = string
(** Type of camera widget name. *)

type widget_label = string
(** Type of camera widget label. *)

type widget_type = 
  | GP_WIDGET_WINDOW    (** Toplevel configuration widget. *)
  | GP_WIDGET_SECTION   (** Section widget (tab).          *)
  | GP_WIDGET_TEXT      (** Text widget (string).          *)
  | GP_WIDGET_RANGE     (** Slider widget (float).         *)
  | GP_WIDGET_TOGGLE    (** Toggle widget (check box).     *)
  | GP_WIDGET_RADIO     (** Radio button widget.           *)
  | GP_WIDGET_MENU      (** Menu widget (same as above).   *)
  | GP_WIDGET_BUTTON    (** Button press widget.           *)
  | GP_WIDGET_DATE      (** Date entering widget.          *)
(** The actual widget type we want to create. The type of the value it supports 
  * depends on this type. *)

val string_of_type : widget_type -> string
(** @return the string representation of the given camera widget type. *)

val create : widget_type -> label:string -> t
(** Creates a new camera widget of specified type and with given label. *)

val destroy : t -> unit
(** Frees the camera widget. *)


(** {2 Widget parameters}
  * Use the functions below to get/set camera widget parameters. *)

(** {5 Dealing with widget hierarchy} *)

val count_children : t -> int
(** Counts the children of the given camera widget. *)

val is_parent : t -> bool
(** Returns [true] if the given camera widget has one child at least, [false]
  * otherwise. *)

val get_nth_child : t -> int -> t
(** Retrieves the nth child of the given camera widget. *)

val get_children : t -> t list
(** Retrieves all the children of the given camera widget. *)

val get_parent : t -> t
(** Retrieves the parent of the given camera widget. *)

val get_root : t -> t
(** Retrieves the root camera widget. *)

val get_child_by_label : t -> widget_label -> t
(** Retrieves the child of a camera widget given its label.
  * @raise Not_found if no child is associated with the given label. *)

val get_child_by_id : t -> widget_id -> t
(** Retrieves the child of a camera widget given its unique id.
  * @raise Not_found if no child is associated with the given id. *)

val get_child_by_name : t -> widget_name -> t
(** Retrieves the child of a camera widget given its name.
  * @raise Not_found if no child is associated with the given name. *)


(** {5 Widget info} *)

val get_info : t -> string
(** Retrieves the information about the given camera widget. *)
val set_info : t -> string -> unit
(** Sets the information about the given camera widget. *)


(** {5 Widget name} *)

val get_name : t -> widget_name
(** Gets the name of the given camera widget. *)
val set_name : t -> widget_name -> unit
(** Sets the name of the given camera widget. *)

(** {5 Widget value} *)

type widget_value =
  | GP_VALUE_OTHER            (** Unsupported value.     *)
  | GP_VALUE_INT of int       (** Integer.               *)
  | GP_VALUE_FLOAT of float   (** Floating-point number. *)
  | GP_VALUE_STRING of string (** Character string.      *)
(** The type of widget value. *)

val string_of_value : widget_value -> string
(** Returns the string representation of the given widget value. *)

val get_value : t -> widget_value
(** Retrieves the value of the given camera widget. *)

val set_value : t -> widget_value -> unit
(** Modifies the value of the given camera widget. *)

val get_choices : t -> (string * int) list
(** Retrieves the available choices for the given camera widget.
  * @raise Invalid_argument if the widget type is not [GP_WIDGET_MENU] or
  * [GP_WIDGET_RADIO]. *)


(** {5 Other info} *)

val is_read_only : t -> bool
(** Retrieves the read/write state of the given camera widget. *)

val get_label : t -> widget_label
(** Retrieves the label of the given camera widget. *)

val get_id : t -> widget_id
(** Retrieves the unique id of the given camera widget. *)

val get_type : t -> widget_type
(** Retrieves the type of the given camera widget. *)


(** {2 Reference counting} *)

val incr_ref : t -> unit

val decr_ref : t -> unit
