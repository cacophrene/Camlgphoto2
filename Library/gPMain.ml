(* gPMain.ml - This file is part of the camlgphoto2 library
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

let _ = Callback.register_exception "not found" Not_found

external lib_version : verbose:bool -> string array = "caml_gp_library_version"

type supported_models
type port_info

external load : GPContext.t -> supported_models = "caml_gp_abilities_list_load"
external destroy : supported_models -> unit = "caml_gp_abilities_list_free"

external count : supported_models -> int = "caml_gp_abilities_list_count"

external is_supported : supported_models -> model:string -> bool 
  = "caml_gp_abilities_list_lookup_model"
  
external get_abilities : supported_models -> model:string -> GPAbilities.t
  = "caml_gp_abilities_list_get_abilities"
  
external detect : supported_models -> GPContext.t -> 
  (string * GPPortInfo.t) list = "caml_gp_abilities_list_detect"
