(* gPWidget.ml - This file is part of the camlgphoto2 library
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

type widget_type = 
  | GP_WIDGET_WINDOW
  | GP_WIDGET_SECTION
  | GP_WIDGET_TEXT
  | GP_WIDGET_RANGE
  | GP_WIDGET_TOGGLE
  | GP_WIDGET_RADIO
  | GP_WIDGET_MENU
  | GP_WIDGET_BUTTON
  | GP_WIDGET_DATE

let string_of_type = function
  | GP_WIDGET_WINDOW -> "GP_WIDGET_WINDOW"
  | GP_WIDGET_SECTION -> "GP_WIDGET_SECTION"
  | GP_WIDGET_TEXT -> "GP_WIDGET_TEXT"
  | GP_WIDGET_RANGE -> "GP_WIDGET_RANGE"
  | GP_WIDGET_TOGGLE -> "GP_WIDGET_TOGGLE"
  | GP_WIDGET_RADIO -> "GP_WIDGET_RADIO"
  | GP_WIDGET_MENU -> "GP_WIDGET_MENU"
  | GP_WIDGET_BUTTON -> "GP_WIDGET_BUTTON"
  | GP_WIDGET_DATE -> "GP_WIDGET_DATE"

type widget_value =
  | GP_VALUE_OTHER
  | GP_VALUE_INT of int
  | GP_VALUE_FLOAT of float
  | GP_VALUE_STRING of string

let string_of_value = function
  | GP_VALUE_INT x -> string_of_int x
  | GP_VALUE_FLOAT x -> string_of_float x
  | GP_VALUE_STRING x -> x
  | _ -> ""

type widget_id = int
type widget_name = string
type widget_label = string

external create : widget_type -> label:string -> t = "caml_gp_widget_new"
external destroy : t -> unit = "caml_gp_widget_free"

external is_read_only : t -> bool = "caml_gp_widget_get_readonly"

external get_info : t -> string = "caml_gp_widget_get_info"
external get_name : t -> widget_name = "caml_gp_widget_get_name"
external get_label : t -> widget_label = "caml_gp_widget_get_label"

external get_id : t -> widget_id = "caml_gp_widget_get_id"

external get_type : t -> widget_type = "caml_gp_widget_get_type"

external get_value : t -> widget_value = "caml_gp_widget_get_value"
external set_value : t -> widget_value -> unit = "caml_gp_widget_set_value"


external get_choices : t -> (string * int) list = "caml_gp_widget_get_choices"

external count_children : t -> int = "caml_gp_widget_count_children"
let is_parent t = count_children t > 0
external get_nth_child : t -> int -> t = "caml_gp_widget_get_child"
external get_children : t -> t list = "caml_gp_widget_get_children"
external get_parent : t -> t = "caml_gp_widget_get_parent"
external get_root : t -> t = "caml_gp_widget_get_root"
external get_child_by_label : t -> widget_label -> t 
  = "caml_gp_widget_get_child_by_label"
external get_child_by_id : t -> widget_id -> t 
  = "caml_gp_widget_get_child_by_label"
external get_child_by_name : t -> widget_name -> t
  = "caml_gp_widget_get_child_by_name"


external set_info : t -> string -> unit = "caml_gp_widget_set_info"
external set_name : t -> widget_name -> unit = "caml_gp_widget_set_name"

external incr_ref : t -> unit = "caml_gp_widget_ref"
external decr_ref : t -> unit = "caml_gp_widget_unref"

