(* gPPortInfo.ml - This file is part of the camlgphoto2 library
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

type port_type =
  | GP_PORT_NONE
  | GP_PORT_SERIAL
  | GP_PORT_USB
  | GP_PORT_DISK
  | GP_PORT_PTPIP

external get_type : t -> port_type = "caml_gp_port_info_get_type"
external get_name : t -> string = "caml_gp_port_info_get_name"
external get_path : t -> string = "caml_gp_port_info_get_path"
