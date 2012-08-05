(* gPPortInfo.mli - This file is part of the camlgphoto2 library
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

(** Port info related functions. *)

type t
(** The type of port info. *)

type port_type =
  | GP_PORT_NONE
  | GP_PORT_SERIAL
  | GP_PORT_USB
  | GP_PORT_DISK
  | GP_PORT_PTPIP
  
val get_type : t -> port_type
(** @return the type of the given port. *)
  
val get_name : t -> string
(** @return the name (for instance ["usb:"]) of the given port. *)

val get_path : t -> string
(** @return the path (whatever is after the [:]) of the given port. *)
